---
date: "2025-08-25"
math: true
title: Investigating High Variance Distributions
---

"Your A/B test is wrong." It's the kind of feedback that stops a data scientist cold, especially when it comes from colleagues who know just enough about statistics to be dangerous. The argument usually goes like this: because our revenue is driven by a handful of "whales" making massive purchases amidst a sea of small interactions, the underlying distribution has infinite variance. If the variance is infinite, the Central Limit Theorem (CLT) collapses, your $p$-values are fantasies, and your uplift is just noise. But before you scrap your results, you need to move beyond intuition and actually test the tail.

The Central Limit Theorem is often treated like a law of nature, but it carries a strict "fine print" requirement: the underlying distribution must have a finite variance. The CLT relies on the idea that as you collect more data, the "noise" of individual outliers eventually gets drowned out by the sheer volume of average observations, causing the sample mean to settle into a predictable bell curve. However, in an infinite variance regime - like a true power law - the outliers are so massive that they scale faster than the sample size. Instead of being diluted, a single new "whale" can appear at any moment and completely shift the mean, no matter how many thousands of data points you've already collected. In this world, the "average" is a moving target that never stabilizes, rendering standard values and confidence intervals mathematically meaningless.

In this article, we'll walk through how to rigorously check if your empirical data actually belongs to a "fat-tailed" family (like Pareto or Levy distributions) where the CLT fails, or if it's simply a high-variance but well-behaved distribution (like Log-Normal). We'll cover diagnostic plots and the stability of the mean so you can defend your results, or admit when the "infinite variance" skeptics actually have a point.

## Fat tailed distributions

When a distribution is described as “fat-tailed,” it means the probability of extreme, “black swan” events is significantly higher than what a standard Normal distribution would predict. In a typical bell curve, the probability of an observation being several standard deviations from the mean drops off exponentially — essentially becoming impossible. In a fat-tailed world, however, the “tail” decays so slowly (following a power law) that these outliers aren’t just possible; they dominate the entire system. When the tail is heavy enough, the variance mathematically fails to converge, meaning no amount of data will ever give you a stable “average” because one massive new data point can move the needle back to zero.

### Common infinite variance distributions

- **Pareto Distribution (Type I)**: Specifically when the shape parameter $\alpha<=2$.
- **Cauchy Distribution**: A famous “pathological” case where even the mean is undefined.
- **Lévy Distribution**: Often used to describe stochastic processes with large, sudden jumps.

### Real-World Phenomena

These distributions aren’t just mathematical curiosities; they define systems where winner-take-all dynamics or recursive growth exist.

- **Wealth & Revenue**: A tiny fraction of “whales” or “super-users” often account for the vast majority of total spend.
- **Social Networks**: The number of followers or links to a website follows a power law (the “rich get richer” effect).
- **Natural Disasters**: The frequency and magnitude of earthquakes or forest fires, where rare mega-events cause more damage than thousands of smaller ones combined.
- **Finance**: Stock market returns during a crash, where price movements far exceed the predictions of “random walk” models.

## Visual inspections

### Histograms

Before diving into complex diagnostics, the humble histogram remains your best first line of defense because it provides an immediate, visceral look at asymmetry and outliers. While a well-behaved distribution looks like a centered mound, a fat-tailed revenue distribution will look like a “hockey stick” - a massive spike at zero or low values with a long, thin trail of data points stretching far to the right. Here are some examples from simulated data.

{{< collapsiblecode lang="python" title="Define data generating function" >}}
import pandas as pd
import numpy as np
import powerlaw
import matplotlib.pyplot as plt
import seaborn as sns
import tqdm

# --- 1. Data Generation (Simulation) ---
def generate_data(num_rows, share_zeros, distribution_dict, seed):
    np.random.seed(seed) # for reproducibility

    # Part 1: Zeros
    num_zeros = int(num_rows * share_zeros)
    zeros = np.zeros(num_zeros)
    num_non_zeros = num_rows - num_zeros

    # Part 2: Non-Zeros based on Distribution
    dist_type = distribution_dict['distribution']

    if dist_type == 'lognormal':
        # NumPy uses 'mean' and 'sigma'
        non_zeros_raw = np.random.lognormal(
            mean=distribution_dict['mu'],
            sigma=distribution_dict['sigma'],
            size=num_non_zeros
        )

    elif dist_type == 'exponential':
        # NumPy uses 'scale' (1/lambda)
        non_zeros_raw = np.random.exponential(
            scale=distribution_dict['scale'],
            size=num_non_zeros
        )
        
    elif dist_type == 'powerlaw':
        # Using Pareto transformation: (Pareto + 1) * xmin
        alpha = distribution_dict['alpha']
        xmin = distribution_dict['xmin']
        non_zeros_raw = (np.random.pareto(a=alpha, size=num_non_zeros) + 1) * xmin
    
    elif dist_type == 'weibull':
        # NumPy weibull only takes 'a' (shape). Scale is applied manually.
        shape = distribution_dict['shape']
        scale = distribution_dict['scale']
        non_zeros_raw = np.random.weibull(a=shape, size=num_non_zeros) * scale

    else:
        raise ValueError(f"Invalid distribution specified: {dist_type}")
        
    # Filter out values less than 10 as per your original logic
    non_zeros_filtered = non_zeros_raw[non_zeros_raw >= 10]

    # Print internal stats for the non-zero portion
    if len(non_zeros_filtered) > 0:
        print(f"--- {dist_type.upper()} Distribution Diagnostics ---")
        print(f"Simulated non-zero max value: {np.max(non_zeros_filtered):.2f}")
        print(f"Simulated non-zero 90th percentile: {np.percentile(non_zeros_filtered, 90):.2f}")
        print(f"Simulated non-zero 50th percentile (median): {np.median(non_zeros_filtered):.2f}")
    else:
        print(f"Warning: All generated {dist_type} values were filtered out by the >= 10 threshold.")

    # Combine zeros and non-zeros
    revenue_data = np.concatenate((zeros, non_zeros_filtered))

    # Create a Pandas DataFrame
    df = pd.DataFrame({'revenue': revenue_data})

    print(f"\nTotal simulated data points: {len(df)}")
    print(f"Number of zeros: {df['revenue'].eq(0).sum()}")
    print(f"Number of non-zeros: {df['revenue'].gt(0).sum()}")
    
    # Final Descriptive Stats
    non_zero_df = df[df['revenue'] > 0]
    if not non_zero_df.empty:
        print(f"Descriptive statistics for non-zero revenue:\n{non_zero_df['revenue'].describe()}")
    
    return df

log_normal_dict = { # Non-zero, skewed, fat-tailed (Log-Normal)
    'distribution': 'lognormal',
    'mu': 3.5,
    'sigma': 1.2
}

exponential_dict = { # always has finite variance
    'distribution': 'exponential',
    'scale': 20
}

powerlaw_dict = { # alpha between 1 and 2 has finite mean and infinite variance. >2 both are finite
    'distribution': 'powerlaw',
    'xmin': 5,
    'alpha': 1.1
}
weibull_dict = { # always finite variance. Heavy tail with shape < 1
    'distribution': 'weibull',
    'scale': 25,
    'shape': 0.4
}

df = generate_data(
    num_rows=5000,
    share_zeros=0.9,
    distribution_dict=weibull_dict,
    seed=42
)
{{< /collapsiblecode >}}

{{< collapsiblecode lang="python" title="Histogram plotting" >}}

# --- Initial Data Preparation and Visual Inspection ---

# Filter out zeros for tail analysis
non_zero_revenue = df[df['revenue'] > 0]['revenue'].values
print(f"\nAnalyzing {len(non_zero_revenue)} non-zero revenue points.")

# Visualizations:
plt.figure(figsize=(15, 6))

# Histogram (linear scale)
plt.subplot(1, 2, 1)
sns.histplot(non_zero_revenue, bins=50, kde=True)
plt.title('Histogram of Non-Zero Revenue (Linear Scale)')
plt.xlabel('Revenue')
plt.ylabel('Frequency')

{{< /collapsiblecode >}}

![High variance plot 1](/images/variance_test/histlognormal.png "Log-normally distributed revenue with high variance ($\sigma=1.5$)")

![High variance plot 2](/images/variance_test/histpowerlaw.png "Pareto distributed revenue with high variance ($\alpha=1.1$)")

![High variance plot 3](/images/variance_test/histweibull.png "Weibull distributed revenue with high variance ($\alpha=0.4$)")

### Complementary Cumulative Distribution Function (CCDF) on log-log scale

To move beyond the visual “messiness” of a histogram, the Complementary Cumulative Distribution Function (CCDF) plotted on a log-log scale is the gold standard for spotting infinite variance. While a standard CDF tells you the probability that a value is less than $x$ ($P(X \leq x)$), the CCDF tells you the probability that a value is greater than $x$ (i.e. $1-P(X \leq x)$); essentially, it focuses entirely on the behavior of the “whales” in your data. When you plot the CCDF on a log-log scale, something magical happens: if your data follows a power law (the hallmark of infinite variance), the plot will show up as a straight line.

{{< collapsiblecode lang="python" title="CCDF Plotting" >}}
# Complementary Cumulative Distribution Function (CCDF) on log-log scale
plt.subplot(1, 2, 2)
fit_prelim = powerlaw.Fit(non_zero_revenue, discrete=False, verbose=False) # Use a preliminary fit just for plotting CCDF
fit_prelim.plot_ccdf(ax=plt.gca(), linewidth=2, color='blue', label='Observed Data CCDF')
fit_prelim.power_law.plot_ccdf(ax=plt.gca(), linestyle='--', color='red', label='Power Law CCDF')

plt.title('CCDF of Non-Zero Revenue (Log-Log Scale)')
plt.xlabel('Revenue ($x$)', fontsize=12)
plt.ylabel('P($X \geq x$)', fontsize=12)
plt.xscale('log')
plt.yscale('log')
plt.legend()
plt.grid(True, which="both", ls="--", c='0.7')

plt.tight_layout()
plt.show()
{{< /collapsiblecode >}}

This happens because of one attribute of power laws: their scale invariance. Given a relation $f(x) = Cx^{-\alpha}$ (pdf of a power law) scaling the argument $x$ by a constant factor $C$ causes only a proportionate scaling of the function itself. That is,

$$f(kx) = Ck^{-\alpha}x^{-\alpha} = k^{-\alpha}f(x) \propto f(x)$$

Thus, it follows that all power laws with a particular scaling exponent are equivalent up to constant factors, since each is simply a scaled version of the others. This produces always a linear relationship in the log-log plot. Indeed if you take logs of the first equation (call $y = f(x)$) you get

$$\log(y) = \log(C) - \alpha \log(x)$$

where the power parameter is the slope of the line.

**Implication:** with real data, such straightness is a *necessary*, but *not sufficient* condition for the data following a power-law relation.

The slope of this line ($\alpha$) is the "smoking gun" your skeptic colleagues are looking for. If the slope is shallow (specifically if the power-law exponent $\alpha \le 2$), you are officially in the "infinite variance" zone where the Central Limit Theorem breaks down. If the line curves downward, your distribution is likely "thin-tailed" or log-normal, and your A/B test results are much safer than the skeptics think.

![CCDF Plot 1](/images/variance_test/CCDF.png "CCDF of observed data against that of a Pareto distribution")

Either way, as mentioned above, this is a first check, and in case the two lines are very similar this would only fulfill a *necessary* condition for power law.

### Recursive Mean Plot

Another powerful plot is the Mean Stability Plot (also known as a Recursive Mean Plot). It’s a simple but devastatingly effective visualization: you calculate the cumulative average of your revenue as each new data point is added and plot it over time.

{{< collapsiblecode lang="python" title="RMP Plotting" >}}
def simulate_daily_convergence(days=30, obs_per_day=100, dist_type='lognormal', seed=42):
    """
    Simulates daily data collection and plots the evolution of the mean.
    """
    daily_means = []
    cumulative_data = []
    np.random.seed(seed)
    for day in range(1, days + 1):
        if dist_type == 'lognormal':
            # High variance but finite
            day_data = np.random.lognormal(mean=2, sigma=1.5, size=obs_per_day)
        elif dist_type == 'pareto':
            # Infinite variance (alpha=1.01)
            day_data = (np.random.pareto(1.01, size=obs_per_day) + 1) * 50
        
        cumulative_data.extend(day_data)
        daily_means.append(np.mean(cumulative_data))

    # Plotting
    plt.figure(figsize=(10, 5))
    plt.plot(range(1, days + 1), daily_means, marker='o', linestyle='-', color='#16a085')
    plt.axhline(y=daily_means[-1], color='r', linestyle='--', alpha=0.5)
    plt.title(f'Evolution of Cumulative Mean over {days} Days ({dist_type})')
    plt.xlabel('Day of Experiment')
    plt.ylabel('Cumulative Revenue Mean')
    plt.grid(alpha=0.3)
    plt.show()

# Run it for the "dangerous" Pareto distribution
simulate_daily_convergence(days=90, obs_per_day=1000, dist_type='pareto', seed=2)
{{< /collapsiblecode >}}

In a well-behaved “finite variance” world, the line will be volatile at first but quickly flatten out, oscillating narrower and narrower around a single horizontal value; this is the CLT in action (as in Log-Normal case below).

![RMP Plot 1](/images/variance_test/RMPLognormal.png "Log-Normal Recursive Mean Plot ($\sigma=1.5$)")

However, if your colleagues are right about infinite variance, the plot will look like a series of jagged, unpredictable jumps. Every time a “whale” purchase hits, the mean will spike vertically and stay high, never truly settling (as in Pareto case below).

![RMP Plot 2](/images/variance_test/RMPPareto.png "Pareto Recursive Mean Plot ($\alpha=1.1$)")

## Statistical Tests

Moving away from visual diagnostic, we will initially tackle statistical tests to detect whether a distribution is consistent with an infinite variance one by following the spirit of the Clauset, Shalizi, Newman (CSN) [paper](https://arxiv.org/pdf/0706.1062). This seminal paper completely transformed the landscape of network science and complex systems by forcing the scientific community to transition from an era of anecdotal "power-law hunting" to one of rigorous statistical discipline. Prior to its publication, hundreds of papers across physics, economics, and biology claimed to find power laws based merely on visually straight lines on log-log plots; Clauset, Shalizi, and Newman effectively shattered this paradigm, establishing a definitive benchmark that debunked dozens of these high-profile claims while providing the necessary mathematical toolkit to ensure future discovery was built on undeniable empirical footing.

After covering the steps in CSN article we will finish with an additional approach from Extreme Value Theory (EVT).

### CSN Approach in Short


The best way to proceed is a mix of theoretical explanation and immediate practical implementation with a simulated dataset. This will make the concepts concrete.

Here’s a simplified description of the steps to follow, relevant to our challenge:

* **Prerequisites & data preprocessing:**
    * **Handle zeros:** power laws are defined for positive values ($x > 0$). We must exclude zeros from the analysis when fitting the tail distribution. This is crucial. We’ll focus only on the non-zero revenue values.
    * **Threshold ($x_{min}$):** power laws describe the tail of a distribution. They rarely fit the entire range of non-zero data. We need to find a suitable lower bound $x_{min}$ above which the power-law behavior truly begins. The CSN paper suggests a method for this, which minimizes the Kolmogorov-Smirnov (KS) statistic between the fitted power law and the observed data above $x_{min}$.
    
Steps:

* **Power-law fitting & $x_{min}$ estimation:** fit the power-law distribution to the non-zero data. The `powerlaw` library includes robust methods for estimating the exponent $\alpha$ and the optimal $x_{min}$. From the estimated $\alpha$:
    * if $\alpha \le 2$, the fitted power law suggests infinite variance.
    * if $\alpha > 2$, the fitted power law suggests finite variance.
* **Goodness-of-Fit test for power law:**
    * Once a power law is fitted (with its $\alpha$ and $x_{min}$), we need to assess how well it actually describes the data above $x_{min}$.
    * The CSN paper suggests a bootstrap-based method: Generate many synthetic power-law datasets from the fitted parameters. Compare the KS statistic between the observed data and the fitted power law to the distribution of KS statistics from the synthetic data. If the observed KS statistic is “too large,” the power law is not a good fit.
* **Likelihood Ratio Tests (Comparison with Alternatives):**
    * This is the core of testing against finite-variance alternatives. We compare the power law’s fit against other heavy-tailed distributions (e.g., log-normal, exponential, stretched exponential, Weibull) using a likelihood ratio test.
    * The test essentially asks: “Is the data significantly more likely to have come from Distribution A than from Distribution B?”
    * The `powerlaw` library automates this: it fits several distributions and then provides $R$ values and p-values for pair-wise comparisons.
        * $R > 0$: Power law is more likely.
        * $R < 0$: Alternative is more likely.
        * p-value $< 0.1$ (or your chosen significance level): The difference in likelihood is statistically significant, favoring the distribution associated with the sign of $R$.
        * p-value $\ge 0.1$: The difference is not statistically significant, meaning neither distribution can be confidently favored over the other based on likelihood.
        
### CSN Step 1: Power Law Fitting

{{< collapsiblecode lang="python" title="Power Law Fitting" >}}
# --- 3. Power-Law Fitting & x_min Estimation ---
print("\n--- Step 3: Fitting Power Law and Estimating x_min ---")
fit = powerlaw.Fit(non_zero_revenue, discrete=False, verbose=True)

alpha = fit.power_law.alpha
xmin = fit.power_law.xmin
KS = fit.power_law.D

print(f"\nEstimated Power Law Exponent (alpha): {alpha:.4f}")
print(f"Estimated Power Law x_min: {xmin:.2f}")

if alpha <= 2:
    print(f"  Interpretation: Since alpha ({alpha:.2f}) <= 2, the fitted power law suggests infinite variance.")
elif alpha > 2 and alpha < 3:
    print(f"  Interpretation: Since 2 < alpha ({alpha:.2f}) < 3, the fitted power law suggests finite variance but infinite skewness.")
else: # alpha >= 3
    print(f"  Interpretation: Since alpha ({alpha:.2f}) >= 3, the fitted power law suggests finite variance and finite skewness.")
{{< /collapsiblecode >}}

Suppose we draw data from a LogNormal distribution with $\mu = 3.5$ and $\sigma = 1.8$ (such distribution would have a very large variance of $686971.832$). When we fit a power law distribution to the non-zero data we obtain the following.

![PLF Plot 1](/images/variance_test/PLFLogNormal.png "Fitting a Pareto Law to simulated high-variance Log-Normal")

As you can see, even if we are simulating data from a LogNormal, the first estimation step would return an $\alpha$ consistent with a Pareto distribution with infinite variance. Therefore this estimation procedure alone is not sufficient!

### CSN Step 2: Goodness-of-Fit Test for Power Law

When testing whether your revenue data follows a specific distribution, Goodness-of-Fit (GoF) is simply a measure of how well your observed data matches a theoretical model. It’s the statistical version of “does this key fit the lock?”. If the GoF is high, your data likely follows that distribution; if it’s low, your model (like the Normal distribution) is a poor representation of reality.

In the context of the CSN framework the bootstrapping procedure is used to determine if a Power Law is actually a plausible fit.

Here is how it works:

* **Generate “Synthetic” Datasets:** The algorithm creates thousands of fake datasets that perfectly follow the Power Law model you’ve estimated from your real data.
* **Calculate Distance ($D$):** It measures the distance (via the Kolmogorov-Smirnov statistic) between your real data and the model, and then does the same for every synthetic dataset.
* **The p-value Comparison:** It counts how often the synthetic (perfect) data deviates from the model *more* than your real data does. If this happens at least 10% of the time ($p \ge 0.1$), the Power Law is considered a plausible match. If the p-value is tiny, you can reject the Power Law—even if the log-log plot looks like a straight line - meaning your variance might not be as “infinite” as your colleagues fear.

{{< collapsiblecode lang="python" title="GoF Test" >}}
def calculate_powerlaw_gof_p_value(data, fit, num_bootstraps=2500, discrete=False, seed=None):
    """
    Calculates the p-value for the power-law goodness-of-fit
    using the bootstrapping method described in Clauset, Newman, and Moore (2009).

    Args:
        data (numpy.ndarray): The observed data to be fitted. Must be strictly positive.
        fit (powerlaw.Fit): The fitted powerlaw object.
        num_bootstraps (int): The number of synthetic datasets to generate.
        discrete (bool): Whether the data is discrete or continuous.
        seed (int): Seed for the random number generator.

    Returns:
        float: The p-value for the power-law goodness-of-fit.
        list: A list of D statistics from the synthetic datasets.
    """
    if not isinstance(data, np.ndarray):
        data = np.array(data)

    if np.any(data <= 0):
        raise ValueError("Data must be strictly positive for power-law fitting.")
    
    # The size of synthetic data should be the same as the observed data >= xmin
    # This is crucial for consistency with CNS paper's methodology
    data_above_xmin = data[data >= fit.power_law.xmin]
    n_for_gof = len(data_above_xmin)

    print(f"\nPerforming {num_bootstraps} bootstraps...")
    # Seed numpy for reproducibility of the bootstrap samples
    if seed is not None:
        np.random.seed(seed) 
    
    # Step 2: Generate synthetic datasets and calculate their KS statistics
    synthetic_D_values = []
    
    # Use tqdm for a progress bar as this can take time
    for _ in tqdm.trange(num_bootstraps, desc="Bootstrapping"):
        # Generate a synthetic dataset from the *fitted* power law
        # Use fit_obs.power_law.generate_random() as it handles the distribution type (discrete/continuous)
        synthetic_data = fit.power_law.generate_random(n_for_gof)

        # Fit a new power law to the synthetic data, but crucially,
        # FIX the xmin to the original fitted xmin (as per CNS, Section 3, steps 2-4)
        try:
            fit_synthetic = powerlaw.Fit(
                synthetic_data,
                xmin=fit.power_law.xmin,        # FIX xmin to the original fitted xmin
                #fixed_xmin=True,      # Crucial: tell the fit to use this fixed xmin
                discrete=discrete,
                verbose=False         # Keep quiet for the inner loop
            )
            
            # The D attribute of this synthetic fit is the KS statistic
            # between the synthetic data and the power law with the fixed xmin.
            D_synthetic = fit_synthetic.power_law.D
            synthetic_D_values.append(D_synthetic)
        except Exception as e:
            # Handle cases where a fit might fail for a synthetic dataset (rare but possible for edge cases)
            print(f"  Warning: Fit failed for a synthetic dataset: {e}. Skipping this sample.")
            continue # Skip this sample if fit fails

    # Step 3: Calculate the p-value
    # The p-value is the fraction of synthetic D values that are >= D_obs
    count_greater_or_equal = np.sum(np.array(synthetic_D_values) >= fit.power_law.D)
    
    # Ensure no division by zero if all fits failed
    p_value = count_greater_or_equal / len(synthetic_D_values) if len(synthetic_D_values) > 0 else 0

    print(f"\nBootstrapping complete. Performed {len(synthetic_D_values)} successful bootstraps.")
    if p_value > 0.1:
        print(f"  Interpretation: p-value ({p_value:.2f}) > 0.1. The data above x_min is consistent with a power law distribution.")
    else:
        print(f"  Interpretation: p-value ({p_value:.2f}) <= 0.1. The data above x_min is NOT consistent with a power law distribution.")
    return p_value, synthetic_D_values
  
p_value_gof, synthetic_D_values = calculate_powerlaw_gof_p_value(non_zero_revenue, fit, num_bootstraps=2500, discrete=False, seed=42)
observed_D = fit.power_law.D

plt.figure(figsize=(10, 6))
plt.hist(synthetic_D_values, bins=50, density=True, alpha=0.7, color='skyblue', edgecolor='black', label=f'Synthetic D values (N={len(synthetic_D_values)})')
plt.axvline(observed_D, color='red', linestyle='dashed', linewidth=2, label=f'Observed D: {observed_D:.4f}')
plt.title(f'Distribution of Bootstrapped KS Statistics (p-value: {p_value_gof:.4f})')
plt.xlabel('Kolmogorov-Smirnov Statistic (D)')
plt.ylabel('Density')
plt.legend()
plt.grid(True, linestyle=':', alpha=0.6)
plt.tight_layout()
plt.show()
{{< /collapsiblecode >}}

Let us see in practice what the test says for our LogNormal distribution with high variance as in the previous paragraph.

![GoF Plot 1](/images/variance_test/GoFLogNormal.png "GoF test for a high-variance Log-Normal")

As you can see, the observed KS statistic from the high-variance LogNormal is larger than one computed on synthetic data 53% of the times, meaning that the data above $x_{min}$ is consistent with a Power Law distribution, even though we know it’s drawn from a finite variance one{{< infotip "" "There is one subtle point regarding the Clauset et al. (2009) methodology that I should mention, as it may trip you up when writing these functions: in the paper (Section 3), for a truly rigorous $p$-value, the synthetic fits are actually supposed to re-estimate $x_{min}$ for every synthetic dataset, rather than fixing it to the original $x_{min}$. In the function presented in this paragraph $x_{min}$ is fixed: this tests if our data matches the specific power law model we found. It is a faster and more 'conservative' test. The paper suggests instead letting $powerlaw.Fit$ find the best $x_{min}$ for each synthetic sample. This accounts for the fact that the $x_{min}$ estimation itself is a source of variance. If you want to follow the paper exactly, remove the $xmin = fit.power\_law.xmin$ argument from the internal loop. However, be warned: this makes the function significantly slower because it has to run the KS-minimization algorithm 2,500 times.">}}.

### CSN Step 3: Likelihood Ratio Tests

The Likelihood Ratio Test is the “ultimate” arbiter because it doesn’t just ask if one distribution is a plausible fit, but mathematically compares two competing models (like Power Law vs. Log-Normal) to calculate which one is objectively more likely to have produced your specific dataset. Since how it works is summarized above, let’s jump to some tests!

We’ll check whether the Pareto distribution we fitted starting from a high-variance LogNormal is more likely to be a better fit for - indeed - a Pareto Law than for other distributions (LogNormal, Exponetial and Stretched Exponential in this paragraph).

{{< collapsiblecode lang="python" title="Likelihood Ratio tests" >}}

# --- 5. Likelihood Ratio Tests (Comparison with Alternatives) ---
print("\n--- Step 5: Likelihood Ratio Tests (Power Law vs. Alternatives) ---")

print("\n--- Power Law vs. Log-Normal ---")
R_ln, p_ln = fit.distribution_compare('power_law', 'lognormal')
print(f"R (Power Law vs. Log-Normal): {R_ln:.4f}, p-value: {p_ln:.4f}")
if p_ln < 0.1:
    if R_ln > 0: print("  Interpretation: Power Law is a significantly better fit than Log-Normal.")
    else: print("  Interpretation: Log-Normal is a significantly better fit than Power Law.")
else: print("  Interpretation: No significant difference between Power Law and Log-Normal (cannot favor one).")

print("\n--- Power Law vs. Exponential ---")
R_exp, p_exp = fit.distribution_compare('power_law', 'exponential')
print(f"R (Power Law vs. Exponential): {R_exp:.4f}, p-value: {p_exp:.4f}")
if p_exp < 0.1:
    if R_exp > 0: print("  Interpretation: Power Law is a significantly better fit than Exponential.")
    else: print("  Interpretation: Exponential is a significantly better fit than Power Law (unlikely for fat tail).")
else: print("  Interpretation: No significant difference between Power Law and Exponential.")

print("\n--- Power Law vs. Stretched Exponential ---")
R_strexp, p_strexp = fit.distribution_compare('power_law', 'stretched_exponential')
print(f"R (Power Law vs. Stretched Exponential): {R_strexp:.4f}, p-value: {p_strexp:.4f}")
if p_strexp < 0.1:
    if R_strexp > 0: print("  Interpretation: Power Law is a significantly better fit than Stretched Exponential.")
    else: print("  Interpretation: Stretched Exponential is a significantly better fit than Power Law.")
else: print("  Interpretation: No significant difference between Power Law and Stretched Exponential.")
{{< /collapsiblecode >}}

![LRT Plot 1](/images/variance_test/LRT.png "Likelihood Ratio Tests for plausible alternatives")

It’s interesting to see how the test for Pareto against LogNormal returns $R<0$ which, if you recall from above, means that the LogNormal is more likely to be a good fit for the observed data (however the p-value is too high to conclude this with certainty).

An interesting complementary visualization is that of the CCDF of both the observed data and the alternatives.

{{< collapsiblecode lang="python" title="CCDF Observed vs Alternatives" >}}

# Visualizing the best fit from alternatives
plt.figure(figsize=(8, 6))
fit.plot_ccdf(ax=plt.gca(), linewidth=2, color='blue', label='Observed Data CCDF')
fit.power_law.plot_ccdf(ax=plt.gca(), linestyle='--', color='red', label=f'Fitted Power Law ($\\alpha$={alpha:.2f})')
fit.lognormal.plot_ccdf(ax=plt.gca(), linestyle=':', color='green', label='Fitted Log-Normal')
fit.exponential.plot_ccdf(ax=plt.gca(), linestyle='-.', color='purple', label='Fitted Exponential')
fit.stretched_exponential.plot_ccdf(ax=plt.gca(), linestyle='--', color='brown', label='Fitted Stretched Exp.')

plt.title('CCDF and Fitted Distributions (Log-Log Scale)')
plt.xlabel('Revenue ($x$)')
plt.ylabel('P($X \geq x$)')
plt.xscale('log')
plt.yscale('log')
plt.legend()
plt.grid(True, which="both", ls="--", c='0.7')
plt.tight_layout()
plt.show()
{{< /collapsiblecode >}}

![CCDF Plot 2](/images/variance_test/CCDFAll.png "CCDF of observed data against Power Law and alternatives")

Also from the above graph it is hard to distinguish whether the observed data CCDF is more similar to that of a LogNormal, a Pareto Law or a Stretched Exponential.

### The Hill Estimator

If the CCDF and Likelihood Ratio tests are your high-level diagnostics, the Hill Estimator is your microscope for the very tip of the tail. It is a tool specifically designed to estimate the tail index ($\alpha$) by looking only at the $k$ largest observations in your dataset. By plotting the Hill Estimator for varying values of $k$ — a Hill Plot — you can look for a stable “regime” where the index levels off. If this stable estimate consistently falls below 2, you have mathematically grounded evidence that the variance is infinite. It serves as a vital reality check: if your tail index shifts wildly as you include more of the largest “whales,” your distribution might not be a pure Power Law at all, but rather a high-variance distribution that is simply being temporarily bullied by a few extreme outliers.

If you’re interested in the details: for a distribution $F(x)$ with a tail $1 - F(x) \sim x^{-1/\gamma}L(x)$ as $x \to \infty$, where $L(x)$ is a slowly varying function (meaning $L(tx)/L(x) \to 1$ as $x \to \infty$ for any $t > 0$), the parameter $\gamma$ is the tail index or extreme value index (EVI). The relationship between the Hill estimator's $\gamma$ and the power-law exponent $\alpha$ is simply: $\gamma = 1/(\alpha - 1)$.

Given a sorted sample $X_{(1)} \ge X_{(2)} \ge \dots \ge X_{(n)}$ (order statistics, from largest to smallest), the Hill estimator for the tail index $\gamma$ based on the $k$ largest order statistics is:

$$\hat{\gamma}_k = \frac{1}{k} \sum\_{i=1}^{k} \log(X\_{(i)}) - \log(X\_{(k+1)})$$

Choice of $k$ (Number of Order Statistics): this is the most critical and challenging aspect of using the Hill estimator.

* **Bias-Variance Trade-off:** if $k$ is too small (e.g., only the very few largest values), the estimator has high variance (it’s unstable because it relies on too little data). If $k$ is too large, the estimator might include values that are not truly in the “tail region” where the power-law approximation holds, leading to bias.
* **Hill Plot:** to address the choice of $k$, practitioners often create a Hill plot, which plots $\hat{\gamma}_k$ against $k$ (or $\log k$). The idea is to look for a “stable region” or “plateau” in the plot, where the estimate of $\gamma$ doesn’t change much as $k$ varies. This plateau suggests a range of $k$ values where the power-law assumption is valid and the estimator is relatively stable. However, identifying such a plateau can be subjective.

Let us see the Hill Plot for our simulated LogNormal distribution with high variance.

{{< collapsiblecode lang="python" title="Hill plot" >}}
# --- Hill Estimator and Hill Plot ---
print("\n--- Step 6: Hill Estimator and Hill Plot ---")

# Ensure data is sorted in descending order
sorted_non_zero_revenue = np.sort(non_zero_revenue)[::-1]
n = len(sorted_non_zero_revenue)

# Define a range for k.
# k usually ranges from a small number (e.g., 10 or 0.5% of data)
# up to N/2 or N/3, but not too close to N due to bias.
# A common starting range is from 10 to sqrt(N) or N/10 for initial visualization.
k_values = np.arange(10, int(n/3) + 1, 10) # From 10 to 20% of data, step 10

if len(k_values) == 0:
    print("Not enough data points or k_values range to compute Hill plot.")
else:
    hill_estimates = []
    for k in k_values:
        if k + 1 <= n: # Ensure X_(k+1) exists
            # Using the formula: (1/k) * sum(log(X_i) - log(X_k+1))
            # Where X_i are the k largest values, and X_k+1 is the (k+1)-th largest
            term1 = np.sum(np.log(sorted_non_zero_revenue[:k])) / k
            term2 = np.log(sorted_non_zero_revenue[k]) # Note: Python indexing is 0-based, so k-th element is X_(k+1)
            hill_gamma = term1 - term2
            hill_estimates.append(hill_gamma)
        else:
            hill_estimates.append(np.nan) # Mark as NaN if k+1 out of bounds

    # Convert to numpy array for easier plotting
    hill_estimates = np.array(hill_estimates)

    # Plot the Hill Plot
    plt.figure(figsize=(10, 6))
    plt.plot(k_values, hill_estimates, marker='o', linestyle='-', markersize=4, color='blue')

    # Add a horizontal line at gamma = 1 (alpha = 2) for variance check
    plt.axhline(y=1.0, color='red', linestyle='--', label='$\gamma=1$ ($\\alpha=2$, Infinite Variance)')
    plt.axhline(y=0.5, color='green', linestyle=':', label='$\gamma=0.5$ ($\\alpha=3$, Finite Skewness)') # For reference

    plt.title('Hill Plot (Hill Estimator vs. k)')
    plt.xlabel('Number of Order Statistics (k)')
    plt.ylabel('Hill Estimator ($\hat{\gamma}_k$)')
    # plt.xscale('log') # Can also plot k on log scale, sometimes makes plateau clearer
    plt.grid(True, which="both", ls="--", c='0.7')
    plt.legend()
    plt.tight_layout()
    plt.show()

    # Find the Hill estimate corresponding to powerlaw's alpha (gamma = 1/(alpha - 1))
    gamma_from_powerlaw_alpha = 1 / (alpha - 1) if alpha > 1 else np.inf
    print(f"\nEquivalent gamma from powerlaw.Fit alpha ({alpha:.4f}): {gamma_from_powerlaw_alpha:.4f}")

    # Interpretation
    print("\n--- Interpretation of Hill Plot ---")
    print("Look for a plateau in the Hill plot:")
    print("  - If the plateau is consistently above or around 1, it suggests infinite variance (gamma greater or equal than 1 implies alpha smaller or equal than 2).")
    print("  - If the plateau is consistently below 1 (e.g., around 0.5 for alpha=3), it suggests finite variance.")
    print("  - The stability of the estimate over a range of k indicates robustness.")
    print("Note: For data not truly power-law, the Hill plot might not show a clear plateau.")
{{< /collapsiblecode >}}

![Hill Plot 1](/images/variance_test/Hill.png "Hill Plot for a high-variance simulated LogNormal")

Surprisingly - for me, at least - the Hill Plot in this case kind of shows a plateau consistently above 1. If the plateau is consistently above or around 1, it suggests infinite variance ($\gamma$ greater or equal than 1 implies $\alpha$ smaller or equal than 2) - even though we know that the data is drawn from a finite variance distribution! But again, as I said above, identifying a plateau is quite subjective...

## Conclusion

Navigating the “infinite variance” debate doesn’t mean you have to surrender your A/B test results to skepticism; it means you must shift from blind trust in the CLT to active tail diagnostics. By combining the visual intuition of Mean Stability Plots with the mathematical rigor of the Hill Estimator and Likelihood Ratio Tests, you can distinguish between a distribution that is simply “noisy” (log-normal) and one that is truly “pathological” (power-law). If your data proves to have finite variance, you’ve earned the right to stand by your p-values. If the skeptics are right and the variance is infinite, you haven’t failed; you’ve simply discovered that “average revenue” is the wrong metric to track, and it’s time to switch to more robust statistics like the median or winsorized means to tell the real story of your experiment.

Even when the “infinite variance” bogeyman is disproven, a distribution with a heavy (but finite) tail remains a nightmare for the standard “Normal” intuition.

In a world of Gaussian curves, the mean is the “typical” experience, and the standard deviation is a reliable ruler. But in a heavy-tailed revenue model, a “one standard deviation increase” is a mathematically valid but practically meaningless unit - it’s an abstraction driven by a few massive values that most of your users will never approach.

Using non-parametric tests (like Mann-Whitney U, Bootstrapping or Permutations) or robust statistics (like the Median or Trimmed Mean) becomes more useful here because they describe the experience of the typical user rather than a mathematical average skewed by a few outliers. Even if the CLT eventually kicks in, a p-value telling you the “means are different” might just be reflecting the fact that one group happened to have two whales while the other had one. Switching to rank-based or robust methods allows you to tell a much more honest story: “Our product change improved the experience for the 95% of users who aren’t whales,” which is often a far more actionable business insight than a fragile shift in a volatile mean.

You can find the notebook with the full code [here](https://github.com/matteorg/posts/blob/main/investigate_high_variance.ipynb).

#### Thank you for reading!

**Disclaimer**: *I write to learn, based on my background and personal experience. Errors are my own, and if you spot them, let me know! I also appreciate suggestion to investigate new topics!*
