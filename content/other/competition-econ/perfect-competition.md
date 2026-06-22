---
date: "2026-03-05"
title: "Perfect Competition"
linktitle: "Perfect Competition" # What shows up in the sidebar
type: book                    # Essential: keeps it part of the 'book' layout
weight: 1                     # 1 = Top of the sidebar, 2 = Below it, etc.
---

## Definition
I learned in class that: “An agent is said to be competitive if she assumes or believes that the market price is given and that her actions do not influence the market price.”

In oder words, think of a single wheat farmer in a world of millions. If she tries to sell her wheat for $\\$1$ more than the going rate, nobody buys. If she sells it for $\\$1$ less, she’s just leaving money on the table. She is a “price taker”, or otherwise said, the market is the boss.

In the real world, “Perfect Competition” almost never exists. It’s a theoretical North Star. We use it to measure how “broken” or “imperfect” a real market is. If a market isn’t acting like this benchmark, IO economists start looking for the “imperfections”.

## Pillars

The main assumptions behind Perfect Competition are the following:

1. **Price-Taking Behavior**: No single buyer or seller is big enough to nudge the price.
    * The Vibe: You are a drop in the ocean. If a wheat farmer doubles her production or quits entirely, the global price of wheat doesn’t move an inch. Everyone just reacts to the price “given” by the market.
2. **Homogenous Goods**: Every single unit of the product is identical.
    * The Vibe: There is no “branding,” no “organic” vs. “regular,” and no “cool packaging.” If you can’t tell the difference between Farmer A’s corn and Farmer B’s corn, you will strictly buy the cheapest one. This kills a firm’s power to raise prices.
3. **Perfectly Divisible Output**: You can buy or sell any tiny fraction of a product.
    * The Vibe: In this math-heavy world, you aren’t stuck buying “one whole car.” You can buy 0.00001 of a car or a single grain of sand. This ensures the math stays “smooth” and firms can adjust their production to the exact atom where profit is maximized.
4. **Perfect Information & No Transaction Costs**: Everyone knows everything instantly, and it costs nothing to trade.
    * The Vibe: Consumers know every price at every store without looking. There are no “hidden fees”, no “searching for a deal”, and no “shipping costs”. If a store across town is 0.01 cheaper, you are there instantly and effortlessly.
5. **No Externalities**: The trade only affects the buyer and the seller.
    * The Vibe: There is no “third-party” drama. No pollution (a negative externality) and no bees pollinating a neighbor’s orchard (a positive externality). The price on the tag reflects the total cost to society.
6. **Free Entry and Exit**: There are zero “Keep Out” signs.
    * The Vibe: If a lemonade stand is making a huge profit, you can start your own in one second for $\\$0$. If you start losing money, you can quit instantly without losing a dime on rent or equipment. This keeps profits at exactly zero in the long run.
    
## Main learnings

When all six the above assumptions are true, we reach **Pareto Efficiency**. This is a state where it is impossible to make one person better off without making someone else worse off. It’s the “Maximum Happiness” setting for an economy.

In what follows we’ll try to illustrate shortly how this equilibrium state materializes in simple mathematical and graphical terms.

## Short- and Long-Run Equilibrium

### Supply Side

Let us start with the problem of the firm. Each firm wants to maximize its profit, intuitively defined as revenue net of costs.

#### Costs

Types of costs:

* Fixed cost ($FC$): The cost that doesn’t depend on the output level.
  * Examples of *explicit* fixed costs:
    - Loan payments
    - rent
    - maintenance
    - part of the wage bill
    -etc.
  * In the short run, most of these fixed costs are *sunk*.{{< infotip "" "A fixed cost is an expense that doesn't change with how much you produce (like the monthly rent). It becomes sunk when that money is committed and cannot be recovered through resale or cancellation (e.g. permits, legal contracts, specialized trainings for staff, etc.).">}}
  * In the long run, if the business isn’t profitable, the firm for example simply doesn’t renew the lease. The cost disappears. This makes almost all costs *avoidable* rather than sunk. This comes from the free exit assumption.
  * *Implicit* fixed costs: The firm owner’s “lost” salary and the “normal” return on the capital invested in the business (the *opportunity cost*). Suppose that you own some land. You can either rent it out or do something with it (e.g. build a factory). When deciding whether to build your factory, you should take into account the opportunity cost of not renting out your land. Or suppose you leave your job to open a bakery: on top of the costs to start and operate the new business you should add the salary you’re giving up on as an implicit cost.
* Variable cost ($VC$): That cost which would be zero if the output level were zero. Since it’s *variable* by definition we can express it as a function of the quantity of output produced $Q$, $VC(Q)$. Examples include:
  - Inputs (cement, electricity, gravel, water, etc.)
  - Part of the wage bill
  - Taxes
  - Trucking
  - Fuel
  - etc.
* **Total cost ($TC$)**: $TC(Q) \equiv FC + VC(Q)$.
  * Total cost is usually higher in the short run because of inflexibility. In the short run, you are “stuck” with certain decisions (fixed inputs), whereas in the long run, you have the freedom to choose the most cost-effective combination of everything.
  * Economists often say the Long-Run Average Cost (LRAC) curve “envelopes” the Short-Run Average Cost (SRAC) curves (the **Envelope Theorem**).
    * In the short run, you are forced to operate on one specific SRAC curve based on the factory size you already have.
    * In the long run, you can jump to the lowest point of whichever SRAC curve is most efficient for your desired production level.
  * When it is cheaper for one single firm to produce two (or more) different products together than it is for two separate firms to produce them individually, we talk about **Economies of scope**: given two products $A$ and $B$, $TC(Q_A, Q_B) < TC(Q_A, 0) + TC(0, Q_B)$
    * **An airline example**: NYC to Paris (A) and Paris to NYC (B) flights. Why is it cheaper for one airline to do both?
      * **Avoided “Deadheading”**: If an airline only flew from NYC to Paris (Product A), the plane would be stuck in France. To fly it back empty just to start the next trip is incredibly expensive. By selling the return trip (Product B), the airline uses the same “input” (the plane and crew) to generate a second product.
      * **Shared Fixed Assets**: One airline needs only one check-in counter at JFK and one at Charles de Gaulle to handle both flights. Two separate airlines would each need their own counters, staff, and landing slots.
      * **Maintenance & Logistics**: A single airline can house its spare parts and mechanics in one hub to service the plane regardless of which leg of the trip it just finished.
* **Average cost ($AC$, also unit cost)**: $AC(Q) \equiv TC(Q)/Q$. Empirically, $AC(Q)$ is U-shaped, implying **Economies of scale** for low $Q$, **Diseconomies of scale** for high $Q$.
  * When a firm is small (low $Q$), increasing production usually makes the cost per unit drop. This happens for three main reasons:
    * **Spreading Fixed Costs**: Imagine renting a bakery for $\\$1,000$ a month. If you bake 1 loaf of bread, that loaf costs $\\$1,000$ in rent. If you bake 1,000 loaves, the rent cost per loaf drops to $\\$1$.
    * **Specialization**: In a small shop, one person does everything. As you grow, you can hire a specialist for the oven and a specialist for the dough. They get faster and better, reducing waste and time.
    * **Technological Efficiencies**: Larger machines are often more efficient. A giant industrial oven uses less energy per loaf than ten tiny home ovens.
  * Eventually, if the firm keeps growing (high $Q$), the cost per unit starts to climb again. This isn’t usually because the machines break, but because of human and organizational limits:
    * **Managerial Complexity**: When a company gets massive, it needs “managers to manage the managers.” Communication slows down, and paperwork piles up. This is often called “Bureaucratic Congestion”.
    * **Coordination Failure**: In a huge factory, the left hand might not know what the right hand is doing. Miscommunications lead to expensive mistakes and idle time.
    * **Worker Alienation**: In a tiny shop, everyone is motivated. In a massive corporation, an individual worker might feel like a “cog in the machine,” leading to lower effort or the need for expensive supervisors to keep them on task.
* Marginal cost ($MC$): the cost of one additional unit. $MC(Q) = \frac{dTC}{dQ}$.

Assume that $AC(Q)$ is U-shaped. Then, $MC(Q)$ crosses $AC(Q)$ at minimum average cost level. To grasp the intuition, think of a coffee shop making cappuccinos:

* **Decreasing $AC$**: The first few cappucinos are expensive because of the mortgage. $AC$ might be $\\$5.00$. Then you’re done paying mortgage and the next latte only costs you $\\$1.00$ ($MC$) in milk and beans, your new $AC$ will drop (say, to $\\$4.00$).
* **Increasing $AC$**: Eventually, the shop gets too crowded. You have to pay workers “overtime” or buy a second, less efficient machine. Now, the additional cappucino costs you $\\$6.00$ to make. Because $\\$6.00$ is higher than the current average, it “drags” the average up.

<details>
  <summary><b>Proof</b></summary>
  
  Let $\hat{Q}$ the output that minimizes $AC$:

$$
\left. \frac{dAC(Q)}{dQ} \right|_{Q=\hat{Q}} = 0
$$

Since:

$$
\frac{dAC(Q)}{dQ} = \frac{d(TC(Q)/Q)}{dQ} = \frac{(dTC(Q)/dQ)Q - TC(Q)}{dQ^2}
$$

$\hat{Q}$ solves:

$$
\frac{(dTC(Q)/dQ)Q - TC(Q)}{dQ^2} = 0 \iff (dTC(Q)/dQ)Q - TC(Q) = 0
$$

Rearranging terms we get:

$$
MC(\hat{Q}) = \left. \frac{dTC(Q)}{dQ} \right|_{Q=\hat{Q}} = \frac{TC(\hat{Q})}{\hat{Q}} = AC(\hat{Q})
$$

![AC-MC Curves](/images/comp-econ/perfect-competition/acmc.png "AC and MC curves.")
  
</details>

#### Profit Maximizing Decision
Each firms tries to maximize the difference between revenue and costs. Formally they solve:

$$
\max_{Q} \pi(Q) \equiv PQ - TC(Q)
$$

where revenue is obviously given by multiplying the quantity of product sold times its price $P$. Note that in this case I did not write $P(Q)$ as under Perfect Competition assumptions the price is taken as given.

The optimal level $Q^\*$ will be such that $P = MC(Q^\*)$. However, as we just said before that with a U-shaped $AC$ curve the $MC$ curve will cross the $AC$ one at $AC$ minimum, for decreasing $AC$ the $MC$ will be lower than the $AC$. Producing at $MC < AC$ would cause a firm to lose money!

This is clear if you look at how we can reformulate profits at the optimum:

$$
\pi(Q^\*) \equiv MC(Q^\*)Q^\* - TC(Q^\*) \equiv Q^\*(MC(Q^\*) - AC(Q^\*))
$$

**Implication**: the firm chooses $Q = 0$. Therefore, the aggregate supply curve will look like this:

![Aggregate Supply](/images/comp-econ/perfect-competition/agg-supply.png "Aggregate supply curve.")

### Demand side

In the world of microeconomics, deriving the aggregate demand curve is essentially a giant “summing up” exercise. While it feels intuitive that prices and quantities have an inverse relationship, the formal derivation relies on individual optimization.

To get to the aggregate level, we start with the individual consumer. We assume each consumer $i$ maximizes their utility $U_i$ subject to a budget constraint $I_i$.

* **Individual Demand**: Through the process of constrained optimization (usually using Lagrange multipliers), we derive the Marshallian Demand for an individual: $q_i(P, I)$.
* **Horizontal Summation**: The aggregate demand $Q(P)$ is the sum of all individual quantities demanded at every possible price point. Mathematically:

$$
Q(P) = \sum_{i=1}^{n} q_i(P, I_i)
$$

* **The Inverse Function**: Once we have $Q(P)$, we invert it to get $P(Q)$. This represents the *willingness to pay* for the last unit produced in the market. Since $Q(P)$ is typically monotonic, the inverse $P(Q)$ inherits the downward slope ($P'(Q) < 0$).

#### Downward slope…always?

The short answer is: *“Usually, but not always”*.

In most cases, the **Law of Demand** holds because of two forces working in the same direction:

* **Substitution Effect**: When price rises, consumers switch to cheaper alternatives.
* **Income Effect**: When price rises, your purchasing power drops. For normal goods, this leads you to buy less.

However, there are two famous exceptions where the demand curve can actually slope **upward**:

1. **Giffen Goods**: A Giffen good is an extreme type of **inferior** good. For these goods, the negative income effect is so strong that it outweighs the substitution effect. If the price of a staple (like bread or rice for someone in extreme poverty) rises, the consumer is so much “poorer” that they can no longer afford meat, forcing them to buy more bread to survive.
2. **Veblen Goods (Conspicuous Consumption)**: These are luxury items where the high price is part of the appeal (e.g., designer handbags, high-end watches). Here, the price acts as a signal of status. If the price drops, the “snob appeal” vanishes, and demand might actually decrease.

#### Price elasticity of demand

In Perfect Competition, we assume the aggregate demand curve is downward sloping for the *entire industry*. However, because an individual firm is a price taker, the demand curve that *a specific firm* sees is perfectly elastic (horizontal). They can sell as much as they want at the market price, but nothing above it.

As a recap, what is the price elasticity of demand? It is the percentage change in demand which results from a 1% change in price, or:

$$
\varepsilon_D(P) \equiv -\frac{dQ}{dP}\frac{P}{Q} = -\frac{dQ/Q}{dP/P} \approx -\frac{\Delta Q/Q}{\Delta P/P}
$$

* $\varepsilon_D(P) > 1$: Demand is elastic (at price $P$), i.e., consumers are quite price sensitive.
* $\varepsilon_D(P) = 1$: Demand is unit elastic.
* $\varepsilon_D(P) < 1$: Demand is inelastic, i.e. consumers do not respond much to price changes.

**A word of caution**: Demand elasticity is a **local** concept, not a global one. No reason to expect $\varepsilon_D(P_1)$ and $\varepsilon_D(P_2)$ to be equal.

### Equilibrium

In the **short run**, the number of firms is fixed. The Perfect Competition equilibrium lies at the intersection of demand and supply curves. If $P^*$ is above firms’ average costs, firms make profits. In the **long run** there is free entry/exit:

* Because of free entry, firms make zero profit in the long run: $P = AC$.
* We still have $P = MC$ for each firm.
* $MC = AC \implies$ The long-run supply curve is horizontal: $P = P_{LR}$, where $P_{LR} = \min_q AC(q)$.

![Equilibrium](/images/comp-econ/perfect-competition/equilibrium.png "Short Run vs Long Run equilibrium.")

This diagram is a classic economics illustration showing how a market moves from a short-term “shock” back to long-term equilibrium in a perfectly competitive market.

On the left, we see what happens to a single firm; on the right, we see the entire market.

1. **The Starting Point ($D_1$ and $S_1$)**: Initially, the market is in equilibrium where the black lines $D_1$ and $S_1$ intersect. The price is at $P^{LR}$ (the Long Run price). At this price, the individual firm is producing at $q^{LR}$, which is the bottom of their Average Cost ($AC$) curve.
    * **Key takeaway**: At this point, firms are making “zero economic profit”; they are covering all costs, but there’s no “extra” money attracting new competitors.
2. **The Short-Run Shift ($D_2$)**: Something happens (like a surge in popularity for a product) that shifts the demand curve from $D_1$ to $D_2$ (the orange line).
    * **In the Market**: The price jumps up to $P^{SR}$.
    * **For the Firm**: The firm sees this higher price and follows its Marginal Cost ($MC$) curve up to produce more ($q^{SR}$).
    * **The Result**: Because the price ($P^{SR}$) is now higher than the Average Cost ($AC$), the firm is making positive economic profit.
3. **The Long-Run Adjustment ($S_2$)**: In a perfectly competitive market, profit acts like a giant “Open” sign for new businesses.
    * **Entry**: Seeing the extra profit, new firms enter the market.
    * **Supply Shifts**: As more firms enter, the market supply curve shifts to the right ($S_1 \rightarrow S_2$).
    * **Price Drops**: The increased supply pushes the market price back down until it hits $P^{LR}$ again.

You can see this happening by playing around with the animated illustration below:
{{< econ-widget >}}

#### Efficiency of Perfect Competition

**Productive efficiency** occurs because competition is so fierce that firms are forced to produce at the lowest possible cost per unit just to survive. If they don’t, they’ll be undercut by someone who does.

**First welfare theorem**: Perfect competition maximizes social welfare (or, perfect competition ensures allocative efficiency).

* Social welfare = consumer surplus + producer surplus

Graphically the allocative efficiency with the maximum social welfare given by $PS$ (producer surplus) and $CS$ (consumer surplus) can be represented as follows:

![Surplus](/images/comp-econ/perfect-competition/welfare.png "Social welfare maximized.")

#### Consumer Surplus

In economics, we assume people only trade when it makes them better off (or at least no worse off).

If a consumer’s Willingness to Pay (WTP) is lower than the equilibrium market price $P^*$, the transaction doesn’t happen.

If you look at the Market Demand curve ($D$) from above, the line continues to the right of the equilibrium points $Q^*$:

* **The bargain hunters (left of $Q^*$)**: these are the consumers whose WTP is higher than $P^*$. They buy the product and enjoy the Consumer Surplus.
    * Consumer surplus is the “deal” you get as a shopper. The demand curve ($D$) represents the **maximum price** consumers are willing to pay for each unit. If you were willing to pay $\\$10$ for a coffee, but the market price ($P^*$) is only $\\$4$, you just “gained” $\\$6$ in value.
* **The excluded (right of $Q^*$)**: these are the consumers represented by the part of the demand curve that is below the $P^*$ line.
    * For these people, the cost ($P^*$) is higher than the value they place on the good. Buying it would actually result in “negative surplus” (a loss of utility), so they simply do not participate in the market.
    
Why does this matters for **efficiency**? Perfect Competition is considered *efficient* because it ensures that every person who values the good more than it costs to make (WTP > MC) gets to buy it. The people “not buying” are **not** a sign of failure; they are a sign of efficient allocation. It wouldn’t make sense for society to use scarce resources to make a product for someone who values it less than the cost of the resources used to create it.

**A Real-World Intuition**

Imagine a concert ticket costs $\\$100$:

* Consumer A loves the band and would have paid $\\$500$. He buys it and feels like he “made” $\\$400$ (Consumer Surplus).
* Consumer B thinks the band is okay and would pay exactly $\\$100$. She buys it but has $\\$0$ surplus.
* Consumer C only likes one song and would only pay $\\$40$. He sees the $\\$100$ price tag and walks away. He is in the “right side of the curve.”

#### Producer Surplus

Why does this matters for *producer surplus* when firms make zero profits in the long run? Think about how we defined *implicit* fixed costs before. Then the following distinction becomes clearer:

* **Producer Surplus** = Total Revenue - Total Variable Costs.
* **Economic Profit** = Total Revenue - Total (Variable + Fixed) Costs.

So in summary:

* The Supply Curve ($S$) is the sum of everyone’s $MC$.
* The Producer Surplus is the “extra” money above *variable* costs.
* In the Long Run, all that “extra” money is exactly enough to cover the Explicit Fixed Costs + Opportunity Costs of all the firms in the market.

In Perfect Competition recall that all firms have the same $AC$:

* We assume all firms have access to the same technology and pay the same prices for inputs (like electricity and labor).
* If one firm had a “secret” lower $AC$, they would dominate the market, or other firms would copy them until everyone had that same low $AC$.
* Therefore, in the LR equilibrium, every single firm is “cloned” at the same size ($q^{LR}$), producing at the same minimum cost.

But then how do we interpret left or right of $Q^*$ for the supply side? In the Market Graph (the one with $S$ and $D$ curves):

* **Firms to the left of $Q^*$**: These represent the “first” units produced. For the very first unit produced in the market, the Marginal Cost is very low (at the start of the $MC$ curve). However, the market price $P^*$ is much higher.
* **Producer Surplus vs. Profit**: That gap between the market price and the low marginal cost of the “early” units is the Producer Surplus.
* **The Bottom Line**: At the equilibrium $Q^\*$, the last unit produced costs exactly $P^\*$ to make. For that last unit, surplus is zero. But for all the units before it, the firm was selling them for $P^\*$ even though their marginal cost was lower.

In the Long Run, the Producer Surplus is exactly equal to the total Fixed Costs the firms have to pay to exist. They aren’t “taking home” the surplus as extra cash; they are using it to pay for their factories and equipment, and to compensate the opportunity cost, so that their final profit ends up at zero.

## Conclusion

While Perfect Competition provides a beautiful, “frictionless” benchmark where efficiency is maximized and prices are fair, it is ultimately a theoretical ideal, or the economic equivalent of studying physics in a vacuum. In the real world, brands matter, information is messy, and big firms often have the power to dictate terms. By mastering this benchmark, you’ve learned what a “perfect” market looks like; now, the real fun of Competition Economics begins as we add back the layers of reality. We move from a world where firms are passive “price-takers” to one where they are strategic players, using everything from game theory to clever marketing to carve out their own piece of the pie.

## References

Much of what you’ll read comes from personal notes or course slides from Industrial Organization and Game Theory courses I attended during my BS and MS at Bocconi University and PhD at the University of Zurich, plus other freely available material.

The most common references are:

* Cabral, L. (2017). Introduction to Industrial Organization (2nd ed.). MIT Press.
* Motta, M., Competition Policy, Theory and Practice, Cambridge University Press, lastest edition.
* Belleflamme P., Peitz M., Industrial Organization, Markets and Strategies, Cambridge University Press, lastest edition.

The *freely* available material that you can consult yourself mainly comes from:

* Battigalli, P. (2020): Game Theory: Analysis of Strategic Thinking. Typescript, Bocconi University. [Downloadable from personal page]
* [MIT Grad IO course](https://ocw.mit.edu/courses/14-271-industrial-organization-i-fall-2022/lists/lecture-notes/)
* [Nicolas Schutz teaching material](https://sites.google.com/site/nicolasschutz/teaching?authuser=0#h.p_ID_32)

#### Thank you for reading!
**Disclaimer**: *I write to learn, based on my background and personal experience. Errors are my own, and if you spot them, let me know! I also appreciate suggestions to investigate new topics!*