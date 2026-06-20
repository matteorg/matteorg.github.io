---
date: "2026-03-15"
image:
  caption: 'Image credit: [**AI Generated**](https://en.wikipedia.org/wiki/Text-to-image_model)'
  placement: 2
math: true
title: Power calculations revisited
---

In the world of A/B testing, we are taught to worship at the altar of the Minimum Detectable Effect (MDE). We obsess over lowering variance and tightening our “rulers” to detect the smallest possible changes. But here is the uncomfortable truth: a metric that can detect a tiny ripple is useless if your feature changes only ever produce a microscopic hum. Traditional power calculations often ignore the most important variable in the equation—the distribution of true impacts. If your “sensitive” metric typically only sees tiny effects, its actual power to drive a launch decision might be lower than a “noisy” metric that captures massive swings. It’s time to stop calculating power in a vacuum and start incorporating what we actually believe about the world. This is what three researchers at Amazon suggest, and I’m going to summarize here their results.

## Power calculations: recap
Before we look at what’s missing, we have to understand the goal. In A/B testing, we are constantly fighting Type II Errors - the False Negatives. Statistical power is simply the probability that if a real impact exists, our test will actually be sensitive enough to detect it and reject the null hypothesis.

Typically, an experimenter starts with an MDE. You decide on the smallest lift that would actually matter to your business (say, a 2% increase in conversion) and then calculate the sample size needed to detect that specific number with 80% probability.

Suppose we want a test with significance level $\alpha = 0.05$ and power $1 - \beta = 0.8$. What sample size $n$ do we need?

We need a sample size such that:

* The probability of rejecting the null hypothesis $H_0$, when $H_0$ is true, is at most $\alpha = 0.05$
* The probability of not rejecting the null hypothesis $H_0$, when $H_0$ is false (i.e. $H_1$ is true), is at most $\beta = 0.2$.{{< infotip "" "If we do not know the sign of the unknown mean $\mu$, we have to run a two-sided test. This means that the maximum probability of type 1 error on each side of the distribution has to be $\alpha/2 = 0.025$, implying $z_{0.975}$">}}

In other words we need to find a critical value $c$ such that:

* $c = \mu_0 + z_{0.975} \frac{\sigma}{\sqrt{n}}$
* $c = \mu_1 - z_{0.8} \frac{\sigma}{\sqrt{n}}$

where $z_p$ is the CDF inverse (or percent point function) at $p$, and $\mu_i$ are the values of the mean under the different hypotheses.

Combining the two expressions together we can solve for the required minimum sample size:

$$n : \mu_0 + z_{0.975} \frac{\sigma}{\sqrt{n}} = \mu_1 - z_{0.8} \frac{\sigma}{\sqrt{n}}$$

from which we obtain:

$$n = \left(\sigma \frac{z_{0.975} + z_{0.8}}{\mu_0 + \mu_1}\right)^2$$

The problem is that this calculation treats the effect size as a single, static point. It asks, “What if the lift is exactly 2%?” but it ignores how likely a 2% lift actually is in the real world. This is where the core argument comes in: power depends not just on how well you can measure, but on **what you are measuring**. If you set for your metric an MDE of 0.1%, but the true impact of your features on that metric is usually 0.01%, your theoretical power is high, but your **real-world power** is zero.

## Bridge the Gap with Prior-Informed Power

If traditional power calculations are flawed because they assume a single, arbitrary effect size, how do we fix them? The Amazon researchers propose a more grounded approach: **Prior-Informed Average Power**.

Instead of asking, “*What is the power if the effect is exactly 2%?*”, we ask, “*What is the average power across all the effect sizes we actually expect to see?*”.

### The Frequentist Fix
For the frequentists, this means taking a weighted average of conventional power. We use our historical data to estimate a distribution of “true impacts”. In plain English: we are stress-testing our metric against reality. If the most likely outcomes for a feature change are tiny, this formula will penalize the power score, even if the metric’s variance is low.

### The Bayesian Perspective: Decision Power
For those who prefer a Bayesian framework, the paper introduces **Bayesian Decision Power**. This doesn’t just look for “statistical significance”, it calculates the probability that your experiment will actually reach your specific *launch* or *dial-down* criteria.

By assuming true impacts follow a Normal distribution, the researchers derived a closed-form expression that allows you to calculate this probability instantly using data already sitting in your A/B testing tools.

## A simulation
We now illustrate the simulation run in the paper, where we examine step by step the logic.

{{< collapsiblecode lang="python" title="Simulation" >}}
import numpy as np
import matplotlib.pyplot as plt
from scipy.stats import norm

def get_prior_informed_power(mu, sigma, tau, alpha=0.05):
    """Equation 4: Prior-informed average power closed-form."""
    z_crit = norm.ppf(1 - alpha/2)
    denom = np.sqrt(tau**2 + sigma**2)
    
    term1 = norm.cdf((tau * z_crit - mu) / denom)
    term2 = norm.cdf((-tau * z_crit - mu) / denom)
    return 1 - term1 + term2

# 1. Setup parameters from the paper (Section 3)
# Metric A: Precise but small impacts
mu_a, sigma_a, tau_a = 0, 0.001, 0.002 # [cite: 103]
# Metric B: Noisy but potentially large impacts
mu_b, sigma_b, tau_b = 0, 0.01, 0.005  # [cite: 104]

# 2. Theoretical Calculation
power_a = get_prior_informed_power(mu_a, sigma_a, tau_a)
power_b = get_prior_informed_power(mu_a, sigma_b, tau_b)

# 3. Monte Carlo Simulation (The "Manual" Way)
def run_simulation(mu, sigma, tau, iterations=100000):
    # Step i: Draw true impacts Delta from G [cite: 68]
    true_deltas = np.random.normal(mu, sigma, iterations)
    
    # Step ii/iii: Compute frequentist power for each delta [cite: 70, 72]
    z_crit = norm.ppf(1 - 0.05/2)
    individual_powers = 1 - norm.cdf(z_crit - true_deltas/tau) + norm.cdf(-z_crit - true_deltas/tau)
    
    # Step iv: Average them [cite: 75]
    return np.mean(individual_powers)

sim_power_a = run_simulation(mu_a, sigma_a, tau_a)
sim_power_b = run_simulation(mu_b, sigma_b, tau_b)

print(f"Metric A (Low Var): Theoretical={power_a:.3f}, Simulated={sim_power_a:.3f}")
print(f"Metric B (High Var): Theoretical={power_b:.3f}, Simulated={sim_power_b:.3f}")

# Calculate MDE for a 5% significance level (standard 1.96 * tau)
mde_a = norm.ppf(0.975) * tau_a
mde_b = norm.ppf(0.975) * tau_b

# Create the plot
fig, ax = plt.subplots(figsize=(10, 6))

x = np.linspace(-0.025, 0.025, 1000)

# Plot Distribution G for Metric A
y_a = norm.pdf(x, mu_a, sigma_a)
ax.plot(x, y_a, label='Metric A: True Effects ($G$)', color='gray', lw=2)
ax.fill_between(x, y_a, color='gray', alpha=0.2)

# Plot Distribution G for Metric B
y_b = norm.pdf(x, mu_b, sigma_b)
ax.plot(x, y_b, label='Metric B: True Effects ($G$)', color='teal', lw=2)
ax.fill_between(x, y_b, color='teal', alpha=0.2)

# Add MDE lines
ax.axvline(mde_a, color='darkorange', linestyle='--', label=f'Metric A MDE ({mde_a:.3f})')
ax.axvline(mde_b, color='darkred', linestyle='--', label=f'Metric B MDE ({mde_b:.3f})')

# Formatting
ax.set_title("Why MDE is Misleading: True Effects vs. Detectability", fontsize=14)
ax.set_xlabel("Effect Size ($\delta$)", fontsize=12)
ax.set_ylabel("Density", fontsize=12)
ax.legend()
ax.grid(axis='y', alpha=0.3)

plt.tight_layout()
plt.show()

# Parameters from the paper (Section 3)
# Metric A: tau=0.002, sigma=0.001 | Metric B: tau=0.005, sigma=0.01
params = {
    'A': {'tau': 0.002, 'sigma': 0.001, 'color': '#4d4d4d', 'label': 'Metric A'},
    'B': {'tau': 0.005, 'sigma': 0.01, 'color': '#0e5a56', 'label': 'Metric B'}
}
alpha = 0.05
z_crit = norm.ppf(1 - alpha/2)

# Calculation Functions
def get_avg_power(sigma, tau):
    # Eq 4: Prior-informed average power
    denom = np.sqrt(tau**2 + sigma**2)
    return 1 - norm.cdf((tau*z_crit)/denom) + norm.cdf((-tau*z_crit)/denom)

def get_bayesian_power(sigma, tau, a=0.95, b=0.95):
    # Eq 5: Bayesian decision power (simplified for mu=0)
    # Using the paper's formula where mu=0
    term1 = 1 - norm.cdf(-(tau * norm.ppf(1-b)) / sigma)
    term2 = norm.cdf(-(tau * norm.ppf(a)) / sigma)
    return term1 + term2

# Data for Plot B and C
power_a = get_avg_power(params['A']['sigma'], params['A']['tau'])
power_b = get_avg_power(params['B']['sigma'], params['B']['tau'])
# Values from paper fig: 0.409 and 0.837
bayes_a = 0.409 
bayes_b = 0.837

# Initialize Subplots
fig, (ax1, ax2, ax3) = plt.subplots(1, 3, figsize=(15, 5), sharey=False)

# --- Plot A: True Effects vs MDE ---
x = np.linspace(-0.03, 0.03, 1000)
for m in ['B', 'A']: # Plot B first so A is on top
    p = params[m]
    mde = z_crit * p['tau']
    # Distribution of true effects G
    y = norm.pdf(x, 0, p['sigma'])
    ax1.fill_between(x, y/y.max()*0.4, step="mid", alpha=0.8, color=p['color'], label=p['label'])
    # MDE Line
    ax1.vlines(mde, 0, 0.5, colors='#d35400', lw=3, label='MDE' if m=='A' else "")

ax1.set_title("a) True Effects vs MDE")
ax1.set_xlabel("Effect Size")
ax1.set_yticks([])
ax1.set_xlim(-0.03, 0.03)

# --- Plot B: Prior-informed average power ---
bars2 = ax2.barh(['Metric B', 'Metric A'], [power_b, power_a], color=[params['B']['color'], params['A']['color']])
ax2.set_title("b) Prior-informed average power $\overline{\Pi}$")
ax2.set_xlabel("Power")
ax2.set_xlim(0, 1.1)
ax2.bar_label(bars2, fmt='%.3f', padding=5)

# --- Plot C: Bayesian decision power ---
bars3 = ax3.barh(['Metric B', 'Metric A'], [bayes_b, bayes_a], color=[params['B']['color'], params['A']['color']])
ax3.set_title("c) Bayesian decision power $\\tilde{\Pi}$")
ax3.set_xlabel("Probability of Effect > 0")
ax3.set_xlim(0, 1.1)
ax3.bar_label(bars3, fmt='%.3f', padding=5)

# General Styling
for ax in [ax1, ax2, ax3]:
    ax.spines['top'].set_visible(False)
    ax.spines['right'].set_visible(False)
    ax.grid(axis='x', linestyle='--', alpha=0.6)

plt.tight_layout()
plt.show()
{{< /collapsiblecode >}}

### Defining the “Ground Truth” (the Prior)

In a traditional power analysis, you pick one number (like a 2% lift) and stick to it. In this simulation, we acknowledge that every feature we ship has a different impact. We define a distribution $G$ (the Prior) that represents the “universe” of possible true impacts.

* **What the code does:** it uses `np.random.normal(mu, sigma)` to draw thousands of “true” effects ($\Delta$ in the paper).
* **Outcome:** For **Metric A**, these dots are all clustered extremely close to zero. For **Metric B**, the dots are spread out, meaning some features are duds, but others are “home runs.”

### The Noisy Measurement (Sampling)

In the real world, we never see the "true" impact; we only see what the A/B test tells us, which includes noise ($\tau^2$ in the paper).

* **What the code does:** For every "true" effect drawn in Step 1, the code simulates an experiment result ($\hat{\Delta}$ in the paper) by adding random noise based on the metric's variance.
* **The Outcome:** This creates a cloud of "observed" results. Even if a feature's true impact was 0, the noise might make it look like a 1% gain or a 1% loss.

![Effects distribution and MDE](/images/effect_beliefs/detectability.png "MDEs against the ’true’ underlying distribution of effects.")

### The Frequentist Test

Now we apply the standard "significance" rule. We check if the observed result ($\hat{\Delta}$) is far enough from zero to be considered "statistically significant" at the $\alpha = 0.05$ level.

* **What the code does:** It calculates the probability of rejecting the null hypothesis for each individual true effect using the standard power formula.
* **The Outcome:** For Metric A, even though the "ruler" is precise, the "objects" (true effects) are so small that they almost never cross the significance threshold.

### Aggregating to “Prior-Informed” Power

This is the final step where we calculate the average.

* **What the code does:** It takes the average of all those individual power calculations.
* **The Outcome:** This average is your Prior-Informed Average Power ($\overline{\Pi}$).

### Recap

![Recap plots](/images/effect_beliefs/recap-plot.png "Shortcomings of standard power analysis and proposed alternatives.")

1. **Plot (a): True Effects vs. MDE (The "Reality Check"):** This plot compares the distribution of actual impacts ($G$) against the "detection bar" (MDE).
    * **Metric A (Gray):** The curve is very tall and narrow because its true impacts are almost always tiny ($\sigma = 0.001$). Even though its MDE line (orange vertical line) is close to zero, notice that the gray "hump" is almost entirely to the left of that line.
    * **Metric B (Teal):** The curve is flat and wide because it has a much higher potential for "home run" impacts ($\sigma = 0.01$). Even though its MDE is much further out, a significant portion of its teal area sits to the right of the MDE.
    * *Takeaway:* This explains the paradox. Metric B has a "harder" goal, but it plays a game where it's actually capable of scoring.
    
2. **Plot (b): Prior-Informed Average Power ($\overline{\Pi}$):** This is the Frequentist solution. It doesn't just look at one hypothetical effect; it calculates the "Expected Power" across all likely outcomes.
    * **The Result:** Metric A has a power of only 0.080, meaning you have an 8% chance of detecting a significant result given how small its effects usually are.
    * **The Result:** Metric B jumps to 0.381.
    * *Takeaway:* If you only used traditional MDE, you'd think Metric A was "better." By using Prior-Informed Power, you realize Metric B is nearly 5x more likely to actually find a winner.

3. **Plot (c): Bayesian Decision Power ($\tilde{\Pi}$):** This shifts the focus from "p-values" to "launch decisions". It shows the probability that the experiment will provide enough evidence to meet a launch or dial-down criterion.
    * **The Result:** For Metric A, there is only a 40.9% chance you'll have enough Bayesian certainty to make a launch/dial-down call.
    * **The Result:** For Metric B, that probability is 83.7%.
    * *Takeaway:* This is the most practical metric for stakeholders. It tells you: "If we use Metric B, we are twice as likely to actually end this experiment with a clear 'Go' or 'No-Go' decision".
    
## A (simualated) Real World Scenario
Imagine you try to change the customer experience for a feature that usually has a low conversion rate (around 10%) and whose revenue is very skewed (most users spend little, but every now and then "whales" appear who make massive purchases). Consider the same data generating function from [this article](https://matteorg.github.io/post/significance-vs-effect-size/) to replicate such a scenario.

Conversion rate has low variance (it's a 0 or 1), but its true impacts are often small (moving CR by 1% is hard). Revenue has high variance (fat tails), but its true impacts can be huge (one "whale" purchase changes everything). To "backward calculate" prior-informed power we need to do three things:

* Estimate $\tau$ (Sampling Error): Run the generator with `purchase_prob_treatment = purchase_prob_control` to see the natural noise.
* Define Beliefs ($G$): Make assumptions about what "typical" wins look like for these two metrics.
* Plug these into the paper's formula.

{{< collapsiblecode lang="python" title="Simulation" >}}
# --- 1. ESTIMATE SAMPLING ERROR (tau) ---
# We run a "A/A test" (no difference) to see the variance of our metrics
aa_data = generate_synthetic_data_flexible_purchase_prob(
    num_individuals=2000, num_dates=14, 
    purchase_prob_treatment=0.12, purchase_prob_control=0.12, 
    skewed_revenue=True
)

def get_metric_stats(df):
    groups = df.groupby('treatment')
    # Conversion Rate
    cr = groups['made_purchase'].mean()
    cr_std = groups['made_purchase'].std() / np.sqrt(len(df)/2)
    # Revenue 
    rev = groups['revenue'].mean()
    rev_std = groups['revenue'].std() / np.sqrt(len(df)/2)
    return {'cr_tau': cr_std.mean(), 'rev_tau': rev_std.mean()}

taus = get_metric_stats(aa_data)

# --- 2. DEFINE BELIEFS (sigma) ---
# Assumption: 
# Most CR wins are tiny (0.1 percentage points) -> sigma = 0.001
# Most Revenue wins are larger ($0.50 spread) -> sigma = 0.50
beliefs = {
    'CR': {'sigma': 0.001, 'tau': taus['cr_tau']},
    'Rev': {'sigma': 0.50, 'tau': taus['rev_tau']}
}

# --- 3. CALCULATE PRIOR-INFORMED POWER ---
def prior_informed_power(mu, sigma, tau, alpha=0.05):
    z_alpha = norm.ppf(1 - alpha/2)
    denom = np.sqrt(tau**2 + sigma**2)
    return 1 - norm.cdf((tau*z_alpha - mu)/denom) + norm.cdf((-tau*z_alpha - mu)/denom)

print(f"--- Prior-Informed Power Comparison ---")
for metric, vals in beliefs.items():
    p = prior_informed_power(0, vals['sigma'], vals['tau'])
    print(f"{metric}: Tau={vals['tau']:.4f}, Sigma={vals['sigma']:.4f} -> Avg Power: {p:.3f}")
{{< /collapsiblecode >}}

Here we just built a synthetic E-commerce environment. On the surface, conversion rate looks like the superior metric because its MDE is tiny. But when we factored in the historical reality that our features move revenue more significantly than they change fundamental purchase probability, the ’noisy’ revenue metric actually gives us a higher probability of making a successful launch decision.

Just remember: when you have a fat-tailed distribution (where 1% of users might account for 50% of revenue), a single “whale” who *happens to be* in the treatment group can swing the mean so much that it looks like your feature is a massive success, even if the feature did nothing.

### The Role of $\tau$ (The "Noise" Filter)

In the formulas the paper uses and that we mentioned so far, $\tau$ represents the standard error of the metric. For a skewed metric like revenue, $\tau$ will be very large because the variance is high. A large $\tau$ makes the "significance threshold" (the MDE) move further away from zero.

* **The math's answer:** the frequentist power calculation *knows* the data is noisy. It requires a much larger observed difference to claim "significance" for revenue than it does for purchase probability. It "penalizes" the metric for its potential to be swung by a single lucky purchase

### The "Prior" ($G$) as a Sanity Check

This is the "Power Revisited" part. If you know that your features usually only move revenue by a tiny amount ($\sigma$ is small), but you see a massive spike in your experiment, the Bayesian Decision Power will help you realize that the "Posterior" belief is still heavily influenced by the fact that such a large move is historically unlikely.

### Real-World Mitigation (Capping and Winsorization)

In real-life, when the data is so skewed, we don't just take the raw mean. We use techniques to handle those "chance" purchases:

* **Winsorization:** we "cap" revenue at the 99th percentile. If a whale spends $\\$10,000$, we treat it as $\\$500$. This drastically reduces $\tau$ (noise) while keeping the metric's direction.
* **Log-transformation:** Analyzing $log(Revenue)$ instead of raw revenue to "pull in" the tails.
* **Cuped:** Using pre-experiment data to "adjust" for users who were already big spenders before the test started.

If the "Average Power" of revenue is still higher than purchase probability after accounting for its massive noise ($\tau$), then revenue is actually the more useful metric for making decisions, despite the outliers.

## Conclusion

1. **Stop Worshipping MDE:** A low MDE (High Sensitivity) is useless if your features never produce impacts large enough to be detected by that metric.
2. **Bring Your Beliefs to the Table:** Use historical data to estimate your "Prior" distribution of impacts ($\sigma$). If you don't know what to expect, you can't calculate your real chance of success.
3. **Prior-Informed Power is the True North:** It combines your metric's noise ($\tau$) with your business reality ($\sigma$) to give you a single, honest probability of finding a winner.
4. **Noisy Metrics Can Be Fixed:** Don't abandon "revenue" just because it's skewed. Use techniques like Winsorization to slash the noise and reveal the underlying power.

You can find the notebook with the full code [here](https://github.com/matteorg/posts/blob/main/effect_sizes_beliefs.ipynb).

## References
[Gualavisi, Melany, Ryan Kessler, and Lorenzo Masoero. "Statistical power calculations revisited: Incorporating beliefs about effect sizes." (2025).](https://www.amazon.science/publications/statistical-power-calculations-revisited-incorporating-beliefs-about-effect-sizes)

#### Thank you for reading!

**Disclaimer**: *I write to learn, based on my background and personal experience. Errors are my own, and if you spot them, let me know! I also appreciate suggestion to investigate new topics!*
