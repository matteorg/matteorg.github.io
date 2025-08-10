---
date: "2025-06-20"
image:
  caption: 'Image credit: [**Costas Gabrielatos**](https://www.researchgate.net/figure/Statistical-Significance-vs-Effect-Size_fig1_323830370)'
  placement: 2
math: true
title: Fat Tails, Statistical Significance and Meaningful Effect Size
---

In the world of online experiments and product iteration, there's a recurring pattern that always gives me pause. Time and again, I see teams kick off an A/B test without any real discussion about statistical power, or even a clear idea of the minimum effect size they'd be interested in detecting. Instead, the default approach often seems to be to simply 'turn the experiment on' and then, to use a common phrase, keep it running 'until we reach confidence.' To me, this is fundamentally missing the point of rigorous experimentation. It's a method that not only wastes resources but, more importantly, often leads to spurious conclusions, undermining the very data-driven culture we strive for.

### Manufacturing confidence: the sample size trap

The statistical reality behind this flawed approach is straightforward: as your sample size grows, the precision of your estimates naturally increases. This is why the confidence intervals around your statistical tests—whether for a difference in means or proportions—will invariably shrink. Think of the standard error of the mean, for instance, which is often approximated as $\frac{\sigma}{\sqrt{n}}$, where $\sigma$ is the standard deviation and $n$ is your sample size {{< infotip "" "In the case of a Welch's test for the difference in means of continuous variables with unequal variance, standard error of the difference is computed as $SE_{(\bar{x}_1 - \bar{x}_2)} = \sqrt{\frac{s_1^2}{n_1} + \frac{s_2^2}{n_2}}$ where $s$ and $n$ indicate the group specific sample variance and size.">}}. As $n$ gets larger, the denominator grows, making the standard error smaller. This means that if you simply keep an experiment running indefinitely, given enough data, you'll almost always eventually detect a 'statistically significant' difference, even if the real-world effect is negligible or purely due to random chance. It effectively allows you to 'manufacture' confidence, risking the rollout of features that have no true impact, or worse, a negative one.

![Meme picture 1](/images/fat_tail_size/effect_size1.jpg "Run, experiment! Run!")

### When variance refuses to shrink

Compounding this issue of 'running until confidence' is the nature of many real-world outcome metrics, particularly when dealing with revenue. For variables like transaction value or total revenue per user, we often encounter what are known as fat-tailed distributions. Unlike the neat, predictable bell curve where extreme values are rare, a fat-tailed distribution means that very large, infrequent observations have a disproportionately significant impact on the variance, and thus on the confidence intervals. In such scenarios, the variance of your difference in means will decrease much slower with increasing sample size than you'd intuitively expect. Those less frequent, large values keep the 'noise' level high, making it genuinely harder to distinguish a true signal from random fluctuations, regardless of how much data you collect.

![Meme picture 2](/images/fat_tail_size/effect_size2.jpg "Fat tails at work")

Consider, for example, the revenue generated from airline passengers on an online booking platform. You might have thousands of daily bookings, but only a small percentage convert additional services (e.g. seat reservation, additional baggage) into transactions. Most of these transactions are for a single seat, perhaps with a basic baggage allowance. However, occasionally, a single user books five seats, adds five checked bags, and purchases five travel insurance policies – a transaction that dwarfs hundreds of typical bookings combined. The same user rarely makes multiple such large purchases within a year. This pattern, where a vast majority of transactions are small, but a handful are exceptionally large and infrequent, creates that characteristic fat tail in your revenue distribution. In such an environment, the average revenue can swing wildly with just few 'whale' bookings in a group, making it difficult to achieve stable confidence in your experimental results without an exceptionally large and truly representative sample{{<infotip "" "Similarly, think of the total order value on a typical e-commerce site. You might process tens of thousands of orders daily. A vast majority of these will be for single, relatively inexpensive items – a t-shirt, a book, a small gadget. However, every so often, a customer comes along and purchases a high-end electronics bundle, several pieces of furniture, or an entire seasonal wardrobe. ">}}.

### Simulating fat tails: the Log-Normal distribution

To move from theoretical concepts to tangible examples, I'll now turn to simulating data that perfectly illustrates the challenges of fat tails in A/B testing. My tool of choice for this will be the Log-Normal distribution. What exactly is it? Simply put, if the natural logarithm of a random variable is normally (Gaussian) distributed, then the variable itself follows a log-normal distribution. This fundamental property makes it inherently non-negative – a crucial characteristic for metrics like revenue – and, more importantly for this discussion, right-skewed, often exhibiting a pronounced and realistic fat tail. Its shape is primarily governed by two parameters: $\mu$ (mu) and $\sigma$ (sigma). While $\mu$ relates to the scale or median of the distribution, it is $\sigma$ – the standard deviation of the underlying normal distribution – that directly controls how 'fat' or heavy the tail becomes. A larger $\sigma$ leads to a more extreme skew and a more pronounced fat tail, perfectly mimicking the highly variable revenue patterns above discussed. I'll leverage this versatile distribution to generate the experiment outcomes in the Python examples that follow.

```python
from scipy import stats
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
```

Before we dive into the actual Python simulations, let's briefly introduce the data generating function: `generate_synthetic_data_flexible_purchase_prob`. This function is designed to simulate a realistic A/B testing scenario, providing us with a controlled environment to observe the effects of different experimental parameters. It allows us to define the `num_individuals` and `num_dates` to control the overall scale and duration of our simulated experiment. Crucially, it lets us set distinct `purchase_prob_treatment` and `purchase_prob_control` values, enabling us to embed a known, true difference (or lack thereof) between our groups. The most relevant parameter for our current discussion, however, is `skewed_revenue`. When set to `True`, the function generates purchase revenues from a highly skewed log-normal distribution (using $\sigma=1$ - but you can change it flexibly, even make it as an argument of the function -), designed to mimic those troublesome fat-tailed outcomes we discussed earlier. Conversely, when `skewed_revenue` is `False`, it simulates revenue from a less skewed log-normal distribution (with $\sigma=0.3$), offering a contrast. By controlling these parameters and ensuring reproducibility with a fixed seed, we can reliably demonstrate the impact of different data characteristics on our experiment analysis.{{< infotip "" "Note that results may differ to the ones presented below if you do not set the seed of use a different one. And that's ok. It's simulated data.">}}

{{< collapsiblecode lang="python" title="Define data generating function" >}}
def generate_synthetic_data_flexible_purchase_prob(
    num_individuals=1000,
    num_dates=30,
    purchase_prob_treatment=0.18,
    purchase_prob_control=0.12,
    skewed_revenue=False,
    seed = 21
):
    """
    Generates a synthetic dataset for A/B testing, including individual IDs,
    dates, treatment assignment, purchase indicators, and realized revenue.
   
    The function allows for setting different purchase probabilities for
    treatment and control groups, and offers options for revenue distribution.
   
    Args:
        num_individuals (int): The total number of unique individuals in the dataset.
                               Defaults to 1000.
        num_dates (int): The number of days for which to generate data.
                           Defaults to 30.
        purchase_prob_treatment (float): The probability of an individual in the
                                           'treatment' group making a purchase on any given day.
                                           Must be between 0 and 1. Defaults to 0.18.
        purchase_prob_control (float): The probability of an individual in the
                                         'control' group making a purchase on any given day.
                                         Must be between 0 and 1. Defaults to 0.12.
        skewed_revenue (bool): If True, generates revenue from a highly skewed
                                 (lognormal with specific parameters for more extreme skew)
                                 distribution when a purchase is made. If False, generates
                                 revenue from a less skewed (lognormal with different parameters)
                                 distribution. Defaults to False.
        seed (int): The seed for NumPy's random number generator to ensure
                    reproducibility of the generated data. Defaults to 21.
   
    Returns:
        pandas.DataFrame: A DataFrame with the following columns:
            - 'date' (datetime): The date of the observation.
            - 'individual_id' (str): Unique identifier for each individual.
            - 'treatment' (str): 'treatment' or 'control', indicating group assignment.
            - 'made_purchase' (int): 1 if a purchase was made, 0 otherwise.
            - 'revenue' (float): The realized revenue; 0 if no purchase was made.
    """
    np.random.seed(seed)
    dates = pd.to_datetime(['2025-01-01'] + [pd.Timestamp('2025-01-01') + pd.Timedelta(days=i) for i in range(1, num_dates)])
    individual_ids = [f'ID_{i+1:04d}' for i in range(num_individuals)]
    treatment_assignment = np.random.choice(['treatment', 'control'], size=num_individuals)
 
    data = []
    for date in dates:
        for i in range(num_individuals):
            treatment = treatment_assignment[i]
            if treatment == 'treatment':
                purchase_prob = purchase_prob_treatment
            else:
                purchase_prob = purchase_prob_control
 
            made_purchase = np.random.binomial(1, purchase_prob)
 
            if made_purchase:
                if skewed_revenue:
                    # Highly skewed revenue (lognormal with larger sigma for more extreme values)
                    revenue = np.random.lognormal(mean=0.5, sigma=1.0) * 2
                else:
                    # Less skewed, more 'normal-like' revenue (lognormal with smaller sigma)
                    revenue = np.random.lognormal(mean=2, sigma=0.3)
            else:
                revenue = 0.0
            data.append({
                'date': date,
                'individual_id': individual_ids[i],
                'treatment': treatment,
                'made_purchase': made_purchase,
                'revenue': revenue
            })
 
    return pd.DataFrame(data)
{{< /collapsiblecode >}}

To visually illustrate how the sigma parameter of the Log-Normal distribution influences the "fatness" of the tail, let's generate two datasets using our `generate_synthetic_data_flexible_purchase_prob` function: one with `skewed_revenue=False` (corresponding to a sigma of $0.3$), and another with `skewed_revenue=True` (corresponding to a sigma of $1.0$). I'll then plot their revenue distributions side-by-side. For the example below I set the purchase probability parameters to $0.45$

![Revenue plots 1](/images/fat_tail_size/effect_size4.png "Log-normally distributed revenues with different values of sigma")

Observing these two plots side-by-side, the impact of $\sigma$ on the log-normal distribution's tail becomes strikingly clear. On the left, with a lower sigma ($0.3$), the revenue distribution is still right-skewed, but the bulk of the purchases are more concentrated around a central value, and extreme high-value transactions are notably rare and closer to the main body of data. The tail, while present, is relatively 'thin' or light. In stark contrast, the plot on the right, generated with a higher sigma ($1.0$), displays the characteristic 'fat tail'. Here, the vast majority of transactions cluster very close to zero, representing typical, small purchases. However, the distribution stretches out dramatically to the right, showing that while very infrequent, extremely large revenue events do occur (look at the different scale of the $x$ axis!), pulling the average significantly higher and introducing substantial variability.

### Experiments with fat-tails (and not only)

Let's now consider a specific simulation designed to highlight these challenges in a tangible way. Imagine an experiment running for 50 days with only 150 individuals participating, where our treatment aims for a modest increase in purchase probability from $10$% (control) to $11$% (treatment). Crucially, we've set `skewed_revenue` to `True`, ensuring our revenue outcomes exhibit a pronounced fat tail.

```python
synthetic_df = generate_synthetic_data_flexible_purchase_prob(
    num_individuals=150,
    num_dates=50,
    purchase_prob_treatment=0.11,
    purchase_prob_control=0.10,
    skewed_revenue=True,
    seed=1
)
```

As we monitor the cumulative estimated difference in purchase probability day by day, we observe a fascinating, yet misleading, pattern. Around day 18, the 95% confidence interval for purchase probability finally excludes zero, signaling 'statistical significance.' This is often the moment management might go 'positively crazy,' ready to celebrate a win. However, if the experiment were to continue, that initial confidence proves fleeting: after day 28, the confidence interval once again broadens to include zero for about ten days, a period that might cause 'negative craziness' and frustration. This erratic behavior perfectly exemplifies the dangers of stopping an experiment based solely on reaching a fleeting confidence threshold, showcasing how easily one can jump to premature or contradictory conclusions without a proper power analysis and fixed horizon.

{{< collapsiblecode lang="python" title="Cumulative plot function" >}}
def cumulative_plot(
    df: pd.DataFrame,
    target_var: str,
    target_name: str,
    confidence_level: float = 0.95
) -> None:
    """
    Generates and displays a time-series plot of the cumulative difference
    between treatment and control groups for a specified target variable,
    including a confidence interval.

    This function calculates cumulative statistics up to each unique date
    and then computes the difference and its confidence interval.

    Args:
        df: The input pandas DataFrame containing 'date', 'treatment', and
            `target_var` columns.
        target_var: The name of the column in `df` representing the dependent
                    variable (e.g., 'made_purchase', 'value_per_purchase').
        target_name: A user-friendly name for the target variable, used in plot labels
                     and titles (e.g., 'Purchase Rate', 'Average Order Value').
        confidence_level: The confidence level for the confidence interval (e.g., 0.95).

    Returns:
        None. Displays a matplotlib plot.
    """
    # Sort the DataFrame by date to ensure correct cumulative calculation
    sorted_df = df.sort_values('date')

    cumulative_results = []
    unique_dates = sorted_df['date'].unique()
    
    # Determine if the target variable is binary once
    is_target_binary = sorted_df[target_var].nunique(dropna=True) == 2
    
    # Z-score or T-score for the given confidence level (two-tailed)
    alpha = 1 - confidence_level
    z_score = stats.norm.ppf(1 - alpha / 2) # For proportions
    
    for current_date in unique_dates:
        # Get all data up to the current date
        cumulative_data = sorted_df[sorted_df['date'] <= current_date]
        
        treatment_target_series = cumulative_data[cumulative_data['treatment'] == 'treatment'][target_var]
        control_target_series = cumulative_data[cumulative_data['treatment'] == 'control'][target_var]
        
        n_treatment = treatment_target_series.count()
        n_control = control_target_series.count()
        
        difference = np.nan
        lower_ci = np.nan
        upper_ci = np.nan

        if is_target_binary:
            # Cumulative confidence interval for difference in proportions
            success_treatment = treatment_target_series.sum()
            rate_treatment = success_treatment / n_treatment if n_treatment > 0 else np.nan
            
            success_control = control_target_series.sum()
            rate_control = success_control / n_control if n_control > 0 else np.nan
            
            difference = rate_treatment - rate_control
            
            if n_treatment > 0 and n_control > 0:
                pooled_proportion = (success_treatment + success_control) / (n_treatment + n_control)
                pooled_proportion = np.clip(pooled_proportion, 0, 1) # Ensure bounds
                
                standard_error_diff = np.sqrt(pooled_proportion * (1 - pooled_proportion) * (1 / n_treatment + 1 / n_control))
                
                margin_of_error = z_score * standard_error_diff
                lower_ci = difference - margin_of_error
                upper_ci = difference + margin_of_error
        else:
            # Cumulative confidence interval for difference in means
            mean_target_treatment = treatment_target_series.mean() if n_treatment > 0 else np.nan
            mean_target_control = control_target_series.mean() if n_control > 0 else np.nan
            
            difference = mean_target_treatment - mean_target_control
            
            if n_treatment > 1 and n_control > 1:
                std_err_diff = np.sqrt(treatment_target_series.std(ddof=1)**2 / n_treatment +
                                        control_target_series.std(ddof=1)**2 / n_control)
                
                # Degrees of freedom for Welch's t-test (Satterthwaite approximation)
                if std_err_diff == 0:
                    degrees_freedom = n_treatment + n_control - 2
                else:
                    numerator = (treatment_target_series.std(ddof=1)**2 / n_treatment + control_target_series.std(ddof=1)**2 / n_control)**2
                    denominator = (treatment_target_series.std(ddof=1)**2 / n_treatment)**2 / (n_treatment - 1) + \
                                  (control_target_series.std(ddof=1)**2 / n_control)**2 / (n_control - 1)
                    degrees_freedom = numerator / denominator if denominator > 0 else n_treatment + n_control - 2
                
                degrees_freedom = max(1, degrees_freedom) # Ensure at least 1
                
                t_score = stats.t.ppf(1 - alpha / 2, df=degrees_freedom)
                margin_of_error = t_score * std_err_diff
                
                lower_ci = difference - margin_of_error
                upper_ci = difference + margin_of_error
        
        cumulative_results.append({
            'date': current_date,
            'difference': difference,
            'lower_ci': lower_ci,
            'upper_ci': upper_ci
        })
            
    cumulative_df = pd.DataFrame(cumulative_results)
    
    # Plot the cumulative difference with confidence intervals
    plt.figure(figsize=(12, 6))
    plt.plot(
        cumulative_df['date'],
        cumulative_df['difference'],
        marker='o',
        linestyle='-',
        label=f'Cumulative Difference in {target_name} (Treatment - Control)'
    )
    plt.fill_between(
        cumulative_df['date'],
        cumulative_df['lower_ci'],
        cumulative_df['upper_ci'],
        alpha=0.2,
        color='blue',
        label=f'{int(confidence_level*100)}% Confidence Interval'
    )
    
    # Add a horizontal line at zero
    plt.axhline(y=0, color='red', linestyle='--', label='Zero Difference')
    
    # Add labels and title
    plt.xlabel('Date')
    plt.ylabel(f'Cumulative Difference in {target_name}')
    plt.title(f'Cumulative Difference in {target_name} (Treatment vs. Control) Over Time with {int(confidence_level*100)}% CI')
    plt.grid(True)
    plt.legend()
    plt.xticks(rotation=45, ha='right')
    plt.tight_layout()
    plt.show()
{{< /collapsiblecode >}}

```python
cumulative_plot(synthetic_df, 'made_purchase', "Purchase Rate")
```

![Cumulative purchase plot 1](/images/fat_tail_size/effect_size5.png "Reaching confidence...and then losing it.")

Turning our attention to the revenue plot from the same simulation, the picture is even starker. Despite the genuine difference in underlying purchase probabilities, the 95% confidence interval for the cumulative difference in revenue consistently includes zero throughout the entire 50-day period. The extreme variability introduced by the fat-tailed revenue distribution (driven by that high sigma) means that even with 50 days of data from 150 individuals, the 'noise' from those few large, infrequent purchases completely overwhelms any true signal. In such a scenario, detecting a statistically significant revenue uplift becomes virtually impossible, underscoring why managing experiments with fat-tailed metrics requires a fundamentally different approach than simply 'waiting for confidence.'

```python
cumulative_plot(synthetic_df, 'revenue', "Average Revenue")
```

![Cumulative revenue plot 1](/images/fat_tail_size/effect_size6.png "Not a chance to 'reach confidence'.")

#### A tale of thinner tails

To truly appreciate the confounding nature of fat tails, let's consider the initial, smaller-scale experiment again: 150 individuals over 50 days, with the same 0.11% vs 0.10% purchase probability difference. However, this time, imagine our revenue distribution is not skewed (i.e., `skewed_revenue` is `False`, corresponding to a lower sigma). The beauty of our simulation setup, aided by using the same seed for individual assignment, is that the purchase rate plots will show an identical behavior to what we observed before – still reaching that fleeting significance around day 18.

```python
synthetic_df = generate_synthetic_data_flexible_purchase_prob(
    num_individuals=150,
    num_dates=50,
    purchase_prob_treatment=0.11,
    purchase_prob_control=0.10,
    skewed_revenue=False,
    seed=1
)

cumulative_plot(synthetic_df, 'revenue', "Average Revenue")
```

Yet, for revenue, the story changes dramatically. While it might not strictly 'reach' the 95% confidence threshold within the 50-day window (one would indeed see it stably above zero with a longer duration, say 70 days), the crucial difference is the stability and predictability of its confidence intervals. Instead of erratic swings, the estimated difference in revenue remains (almost) consistently positive, showing a steady, albeit slow, convergence. The intervals shrink predictably, reflecting a more 'well-behaved' underlying distribution. This stark contrast highlights that even if an effect is small, a non-skewed outcome allows for a much more reliable path to inference, making it far easier to manage, interpret, and confidently extend an experiment to reach significance, unlike the volatile battle against fat tails.

![Cumulative revenue plot 1](/images/fat_tail_size/effect_size9.png "A more stable path to 'confidence'.")

#### The more (data) the merrier

Now, let's pivot to a scenario that, on the surface, might appear to validate the intuition that 'more data' always solves the problem. Imagine we scale up our experiment significantly, now observing 10,000 individuals over 30 days. We also dial down the true effect on purchase probability to a subtle 0.5 percentage point difference (0.105 for treatment vs. 0.10 for control), while still retaining our problematic fat-tailed revenue distribution.

```python
synthetic_df = generate_synthetic_data_flexible_purchase_prob(
    num_individuals=10000,
    num_dates=30,
    purchase_prob_treatment=0.105,
    purchase_prob_control=0.10,
    skewed_revenue=True,
    seed=1
)
```

In this larger-scale simulation, the plots tell a seemingly more reassuring story. For purchase probability, we see significance reached relatively quickly, around day 10. This is the moment when management might confidently pop the champagne bottle, believing the experiment has unequivocally delivered a positive result. The revenue plot, while lagging due to its inherent volatility, also eventually shows significance, becoming 'barely significant' after approximately 25 days, perhaps prompting more celebratory corks. These results, achieved with a much larger sample size, seem to perfectly align with the expectation that simply collecting more data will eventually unveil any true effect, allowing confidence intervals to shrink and the coveted 'significance' to be achieved.

![Cumulative purchase plot 2](/images/fat_tail_size/effect_size7.png "Amazing CI always above zero quite early!")
![Cumulative revenue plot 2](/images/fat_tail_size/effect_size8.png "Also revenue has made it!")

However, despite these ostensibly 'successful' outcomes, a critical question looms: what is the true, underlying effect size we're actually observing, and how meaningful is it in the face of such noisy, fat-tailed data? Are we truly detecting a robust, practically significant lift, or merely catching fleeting signals in a sea of extreme values, simply because we've collected enough data to overcome the sheer variance? The answers to these questions are crucial for making informed business decisions and avoiding the trap of statistical significance without practical relevance.

### Beyond significance: when is the effect size meaningful for business?

In the boardroom, the focus can quickly shift from the nuances of the data to simplified, yet misleading, narratives. A manager might present a 60% relative increase in revenue without mentioning that this lift is relative to an incredibly small baseline. Or they might extrapolate a tiny per-user effect—say, an extra €0.002 per person—across a massive user base, proclaiming 'we'll make €100k more per month!' While a significant result may be technically correct, these presentations often dangerously abstract from critical factors like, among others, actual costs and the practicality of the effect, misrepresenting its true business value.

#### Guidelines for interpreting rates

For metrics like purchase rate, it's a best practice to consider both the absolute difference and the relative difference. The absolute difference, measured in percentage points (p.p.), gives you the true magnitude of the change, while the relative difference shows the percentage increase from the baseline.

Moving from a 53% to a 57% purchase rate gives you a 4 p.p. absolute difference, which is a significant 5.5% relative increase. The magnitude of the change is immediately clear.

In another scenario, moving from 12.4% to 13.09% also represents a 5.5% relative increase, but the absolute difference is less than a percentage point at just 0.69 p.p..

Both figures tell a different but equally important part of the story. The first case might justify a product overhaul, while the second might be considered a marginal gain not worth the development or full rollout cost. Combining these two views provides a more complete picture of the effect's practical significance.

#### Why Cohen's $d$ falls short with fat tails

When we move to continuous variables like revenue, a common approach is to use a standardized effect size measure like [Cohen's $d$](https://en.wikipedia.org/wiki/Effect_size#Cohen's_d). This metric is designed to show the difference between two means, expressed in units of their pooled standard deviation. Cohen's $d$ provides a useful, scale-independent way to interpret the magnitude of an effect, with general guidelines suggesting that $d$ values of 0.2, 0.5, and 0.8 correspond to small, medium, and large effects, respectively. For example, a Cohen's $d$ of 0.5 means the two group means are separated by half a standard deviation.

However, for distributions with fat tails, Cohen's $d$ is a poor choice. The entire metric is predicated on the standard deviation, a measure that is highly sensitive to extreme values. As we've seen, a single large transaction in a fat-tailed distribution can dramatically inflate the standard deviation, making a real and meaningful change in the average revenue appear *much smaller* than it actually is. This instability and reliance on a measure that is distorted by the very nature of our data make Cohen's $d$ an unreliable tool for informed decision-making in these cases.

Below you see that even when stastitical significance is reached, the effect size computed using Cohen's $d$ (using the last sample presented above) is minimal and constantly low over time.

{{< collapsiblecode lang="python" title="Effect size functions" >}}
cohens_dict = {
    'var':'cohens_d',
    'metric':"Cohen's d",
    'method': calculate_cohens_d
}

cliff_dict = {
    'var':'cliff_d',
    'metric':"Cliff's delta",
    'method': calculate_cliffs_delta
}

def calculate_cohens_d(group1, group2):
    """
    Calculates Cohen's d for the difference in means of two independent groups.
    This function is applicable to both continuous and binary (0/1) variables.

    Args:
        group1 (pd.Series): A pandas Series of numerical values for the first group.
        group2 (pd.Series): A pandas Series of numerical values for the second group.

    Returns:
        float: Cohen's d. Returns np.nan if calculation is not possible (e.g., zero variance
               within groups, insufficient data for pooled standard deviation).
    """
    mean1 = group1.mean()
    mean2 = group2.mean()
    n1 = len(group1)
    n2 = len(group2)

    # Handle cases with insufficient data for variance calculation (need at least 2 samples for ddof=1)
    if n1 < 2 or n2 < 2:
        return np.nan # Cannot calculate pooled std if one group has less than 2 samples

    var1 = group1.var(ddof=1) # Sample variance
    var2 = group2.var(ddof=1) # Sample variance

    # Denominator for pooled standard deviation
    # This also implicitly handles cases where n1+n2 < 3 (e.g., n1=1, n2=1)
    denominator_pooled_std = (n1 + n2 - 2)

    if denominator_pooled_std <= 0: # This means total samples are 2 or less.
                                   # We already handled n1<2 or n2<2, so this covers n1=1, n2=1
        return np.nan

    # Calculate pooled standard deviation
    pooled_std = np.sqrt(((n1 - 1) * var1 + (n2 - 1) * var2) / denominator_pooled_std)

    if pooled_std == 0:
        # This happens if all values within both groups are identical (e.g., all 0s or all 1s for binary)
        # In such a case, the standard deviation is 0, and Cohen's d is undefined.
        return np.nan

    d = (mean1 - mean2) / pooled_std
    return d
    
def calculate_cliffs_delta(group1, group2):
    """
    Calculates Cliff's delta for two independent groups.

    Args:
        group1 (np.ndarray or list): A numerical array or list for the first group.
        group2 (np.ndarray or list): A numerical array or list for the second group.

    Returns:
        float: Cliff's delta value.
    """
    group1 = np.asarray(group1)
    group2 = np.asarray(group2)

    n1 = len(group1)
    n2 = len(group2)

    if n1 == 0 or n2 == 0:
        return np.nan

    # Create a grid of all pairwise comparisons
    # This is a key step where broadcasting makes the calculation efficient.
    # The result is a 2D array where each element is a comparison result.
    comparisons = group1[:, None] > group2

    # Count the number of pairs where group1 > group2
    group1_gt_group2 = np.sum(comparisons)

    # Count the number of pairs where group2 > group1
    # We can do this by inverting the comparison result and subtracting the ties
    group2_gt_group1 = np.sum(group2[:, None] > group1)

    # Calculate Cliff's delta
    numerator = group1_gt_group2 - group2_gt_group1
    denominator = n1 * n2

    if denominator == 0:
        return np.nan

    delta = numerator / denominator
    return delta

def effect_size_df(df, target, effect_var, method):
    cumulative_results = []
    unique_dates = df['date'].unique()
    df_sorted = df.sort_values('date')
    
    for current_date in unique_dates:
        cumulative_data = df_sorted[df_sorted['date'] <= current_date]
        treatment_cumulative = cumulative_data[cumulative_data['treatment'] == 'treatment'][target]
        control_cumulative = cumulative_data[cumulative_data['treatment'] == 'control'][target]
        results_cumulative = method(treatment_cumulative, control_cumulative)
        cumulative_results.append({'date': current_date, effect_var: results_cumulative})
    
    return pd.DataFrame(cumulative_results)

def plot_effect_size(metrics_dict, df, target_var, target_name):
    cumulative_effect_df = effect_size_df(df, target_var, metrics_dict['var'], metrics_dict['method'])

    plt.figure(figsize=(10, 6))
    plt.plot(cumulative_effect_df['date'], cumulative_effect_df[metrics_dict['var']], marker='o', linestyle='-')
    if metrics_dict['var']=='cohens_d':
        plt.axhline(y=0.2, color='black', linestyle='--', label="Small effect (0.2)")
        plt.axhline(y=0.5, color='red', linestyle='--', label="Medium effect (0.5)")
        plt.axhline(y=0.8, color='green', linestyle='--', label="Large effect (0.8)")
    else:
        plt.axhline(y=0, color='red', linestyle='--', label="No effect")
    plt.xlabel('Date')
    plt.ylabel(f"Cumulative {metrics_dict['metric']}")
    plt.title(f"Cumulative {metrics_dict['metric']} for {target_name}")
    plt.grid(True)
    plt.legend()
    plt.xticks(rotation=45, ha='right')
    plt.tight_layout()
    plt.show()
{{< /collapsiblecode >}}
```python
plot_effect_size(cohens_dict, synthetic_df, 'revenue', 'Average Revenue')
```
![Cohen's d plot](/images/fat_tail_size/effect_size10.png "Effect size standardized...or deflated?")

#### Cliff's delta: A robust alternative

This is where it becomes crucial to move away from metrics that rely on means and standard deviations. A more robust alternative for fat-tailed distributions is Cliff's delta ($\delta$). This is a non-parametric measure of effect size that assesses the degree of overlap between two distributions without relying on their means or standard deviations. Instead, it is calculated based on the number of times an observation from one group is larger than an observation from the other.

$$\delta = P(x_1 > x_2) - P(x_1 < x_2)$$

This formula effectively measures the probability that a randomly chosen value from one group is larger than a randomly chosen value from the other, minus the probability of the opposite. Because it uses rank-based comparisons, Cliff's delta is highly resistant to outliers and skewed data. Its value ranges from -1 to 1, where, according to [Meissel and Yao (2024)](https://www.researchgate.net/publication/377696423_Using_Cliff's_Delta_as_a_Non-Parametric_Effect_Size_Measure_An_Accessible_Web_App_and_R_Tutorial):

- Negligible effect: $\vert\delta\vert<0.147$

- Small effect: $0.147≤\vert\delta\vert<0.33$

- Medium effect: $0.33≤\vert\delta\vert<0.474$

- Large effect: $\vert\delta\vert≥0.474$

By using Cliff's delta, you can make more reliable claims about the magnitude of an effect on revenue, even when your data is filled with the kind of high-value outliers that would derail a standard deviation-based metric like Cohen's $d$. It allows you to confidently say that your treatment group's revenues are "stochastically superior" to the control group's, without being misled by a handful of large transactions.

Isn't this very similar to [Mann-Whitney U test](https://en.wikipedia.org/wiki/Mann%E2%80%93Whitney_U_test)? Your intuition is correct; Cliff's delta is very similar to the Mann-Whitney U test, but they serve different purposes.

The Mann-Whitney U test is a hypothesis test that gives you a p-value. Its primary purpose is to determine if there is a statistically significant difference between the two distributions. A small p-value suggests that the observed difference is unlikely to be due to random chance alone.

In contrast, Cliff's delta is an **effect size** measure. It quantifies the magnitude of the difference between the two distributions, providing a standardized value that is independent of sample size. It answers the question, "How big is the difference?".

Essentially, the Mann-Whitney U test tells you if a difference exists, while Cliff's delta tells you how large that difference is{{< infotip "" "There is also a direct mathematical relationship between the two. Cliff's delta ($\delta$) can be calculated from the Mann-Whitney U statistic (U) and the sample sizes of the two groups ($n_1$ and $n_2$) using the following formula: $$\delta = \frac{U_1 - U_2}{n_1 n_2} = \frac{2U}{n_1 n_2} - 1$$ where $U$ is the smaller of the two Mann-Whitney U statistics">}}.

Now, in practical terms, is Cliff's delta detecting any non-negligible effect on revenue in the last data generated? It appears not. You can play around with the data generating function to see if you find statistically significant effect that also in terms of magnitude would have relevance.

```python
plot_effect_size(cliff_dict, synthetic_df, 'revenue', 'Average Revenue')
```
![Cliff's delta plot](/images/fat_tail_size/effect_size11.png "Effect size negligible throughout the experiment")

### Conclusion

This article has explored the critical pitfalls of interpreting A/B test results, particularly the flawed practice of running experiments until statistical significance is achieved (but not in a *peeking* or *sequential A/B test* sense - if you want to know more about the topic you can read [this article](https://medium.com/data-science/understanding-group-sequential-testing-befb35cec07a)). We've seen how fat-tailed distributions, common in revenue metrics, introduce extreme volatility that can lead to misleading or erratic results. Even standard power calculations do not apply anymore in these settings. For further insights on how to analyze and handle such distributions stay tuned for the next article.

### Code

You can find the notebook with the full code [here](https://github.com/matteorg/posts/blob/main/fat_tail_significance_effect_size.ipynb).

#### Thank you for reading!

**Disclaimer**: *I write to learn, based on my background and personal experience. Errors are my own, and if you spot them, let me know! I also appreciate suggestion to investigate new topics!*
