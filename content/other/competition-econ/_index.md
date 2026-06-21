---
date: "2026-02-26"
title: "Competition Economics"          # The title that appears at the top of the page
linktitle: "Competition Economics"      # The name used in the sidebar/menus
type: book                     # Required to trigger the sidebar layout
layout: docs                   # Required to use the documentation template
sidebar:
  open: true                   # Ensures the sidebar is expanded by default
---

![Intro example](/images/comp-econ/intro/coca-pepsi.png "Example of agreement in price competition. (AI generated)")

## What is Competition Economics?
Competition Economics, or industrial organization, is the study of how market structures, firm behaviors, and strategic interactions influence competition and affect overall economic efficiency. Or, as I would tell my grandma, Competition Economics is the study of how businesses compete for customers, how they decide on their prices, and how those choices either help or hurt the people buying from them.

In very short: **Competition Economics is the economics of imperfect competition.**

Think of *imperfect competition* as the middle ground between a “perfect” free-for-all and a total monopoly; it’s a market where firms have enough power to set their own prices because their products are unique or they dominate the space. And this is what our world looks like most of the time in reality.

In these markets, the “invisible hand” of competition doesn’t work perfectly because:
- **Price control**: Unlike perfect competition, where prices are set by the market, firms here have the *market power* to raise prices without losing all their customers.
- **Product differentiation**: Companies use branding or features to make you feel like their product is special (e.g., Coke vs. Pepsi).
- **Barriers to entry**: High costs or legal protections make it difficult for new competitors to jump in and drive prices down.

In what follows (this intro and all subsequent chapters) we’ll try to answer the following:
- How do firms make production decisions and how do they compete with each other?
- Should governments interfere with the operation of firms?

## Motivating Example

### Zantac's success
![Pharma competitors](/images/comp-econ/intro/zantac.png "Zantac and its main competitors.")

Four major H2-antagonist drugs (H2 blockers) dominated the market in the late 1980s and early 1990s: Tagamet (cimetidine), Zantac (ranitidine), Pepcid (famotidine), and Axid (nizatidine). Zantac became the world’s first-ever $1 billion/year drug by 1988 through an aggressive, unconventional marketing strategy that positioned it as a premium, superior alternative to Tagamet.

**Key Strategies in Zantac’s Success:**
- *Premium Pricing Strategy*: Despite being a follower to market leader Tagamet, Glaxo CEO Paul Girolami priced Zantac 30% higher, leveraging the perception that higher price equals better quality.
- *Aggressive Sales Force*: Glaxo partnered with Hoffmann-La Roche in the U.S., gaining access to a 1,000-person sales team to push the product into the market rapidly.
- *Marketing & Consumer Awareness*: The campaign included “Heartburn Across America” campaigns, public service announcements, and celebrity tours to drive patient requests, which increased demand, according to a [1996 study](https://europepmc.org/article/med/10169076).
- *Superior Product Positioning*: While similar to Tagamet, Zantac was marketed as having fewer side effects and requiring fewer doses, making it highly attractive to doctors and patients for ulcers and GERD.

By 1988, just five years after its U.S. launch, Zantac became the world’s best-selling drug, propelling Glaxo from a minor player to a top pharmaceutical giant.

![Market Shares](/images/comp-econ/intro/zantacmktshares.jpg "Evolution of market shares. Source: Berndt et al. 1996")

As the plot shows, even when new entrants tried to obtain a piece of the cake, Zantac kept increasing its market share, while Tagamet kept losing share to the new competitors.

#### The role of patents
A company that first discovers and discloses a novel molecular entity - in this case, the chemical structures for $H_2$-antagonists like cimetidine (Tagamet) or ranitidine (Zantac) - obtains a legal monopoly. By filing a patent, the government grants the inventor an exclusive right (typically for 20 years from the filing date) to manufacture and sell the drug, effectively “locking out” any competitors from selling an identical version. In exchange for this temporary monopoly, the company must publicly reveal exactly how the drug is made, allowing the rest of the scientific community to learn from the discovery, though they can’t profit from it until the patent expires.

Drug manufacturers pivot their business strategies when they face “patent cliffs”, namely the moment a high-profit, branded drug loses its legal monopoly and must compete with cheap generics (at expiration of the patent, the “monopoly” vanishes overnight. Generic manufacturers, who didn’t have to pay for the initial $R\\&D$, enter the market with much lower prices).

#### How did Zantec react to the expiration of its patent (1997)?

Zantac reduced its marketing budget by as much as an estimated 95%! In particular, the pages of journal advertising for Zantac dropped by 99.3% near patent loss and hit 100% (complete cessation) after!

Journal ads are for brand awareness, which is useless once a generic version is available. However, Glaxo kept a small, specialized sales force to maintain relationships with key hospitals or specialists for as long as possible.

#### How did Zantec’s competitors react to the expiration of Zantec’s patent?
Pepcid’s advertising while Zantac was losing its patent skyrocketed by 257.7%!

The lesson: when a market leader (Zantac) loses its patent, its competitors who still have patents (Pepcid) go on the offensive. They spend aggressively to “convert” Zantac users over to their brand before those users settle for a cheap generic Zantac.

#### The Dorfman-Steiner Equation

The Dorfman-Steiner equation (or condition) is the "golden rule" for determining how much a firm should spend on advertising to maximize its profits.

The equation states that for a profit-maximizing firm, the ratio of advertising expenditure to total sales should be equal to the ratio of the advertising elasticity of demand to the price elasticity of demand.

In formal terms, the equation is:

$$
\frac{A}{PQ} = \frac{\eta_A}{\epsilon}
$$

Where:

* $A$: Total advertising expenditure
* $PQ$: Total revenue (Price $\times$ Quantity)
* $\eta_A$: Advertising elasticity of demand (how sensitive sales are to changes in ad spend)
* $\epsilon$: Price elasticity of demand (how sensitive sales are to changes in price).

The beauty of this equation is that it tells a business exactly how to behave based on their market position:

* If demand is highly sensitive to ads ($\uparrow \eta_A$) then a company should spend more on ads, as every dollar spent results in a massive surge in customers (what Zantac did when it entered the market).
* If demand is highly sensitive to price ($\uparrow \epsilon$), spend less on ads, as the market is likely competitive/commoditized; ads won’t save you if your price is off (more or less what happened when Zantac’s patent expired).
* If profit margins are high, spend more on ads. Since you make a lot on each unit, even a small bump in volume from ads is worth it.

### Takeaways

These stories illustrate the kind of issues we’ll be interested in in the next sessions.

- Market power:
    - Is there market power?
    - How do firms acquire market power?
    - What are the consequences of market power?
- Entry:
    - If there is market power, why don’t other firms enter to get a share of the cake?
    - Can incumbents do something to deter entry?
    - Is entry into imperfectly competitive markets excessive or insufficient?
- Patents and $R\\&D$:
    - Do firms have enough (or too many?) incentives to conduct $R\\&D$?
    - What is the optimal duration of a patent?
- Imperfect competition
    - What should we expect from competition between a small number of firms?
    - How can positive markups survive when firms compete with homogeneous (i.e. the same) products?
    - How do firms manage to enforce collusion?
- Product differentiation:
    - What are the incentives for product differentiation?
    - What are its implications?
    - Does the market provide enough variety?
- Marketing and advertising:
    - Is advertising just a way to manipulate consumers’ tastes?
    - …or does it allow firms to inform consumers of the existence of their products?
- Mergers:
    - Do firms merge essentially to save on costs and to make production more efficient?
    - …or is it just a way to soften competition, and create market power?
- Competition policy / Antitrust:
    - Should competition authorities do something about mergers?
    - About collusion? Bundling? Tying? Exclusive dealing?

And many other questions…

## A brief history of Industrial Organization

### The Harvard Tradition

The “Harvard Tradition” of the mid-20th century laid the groundwork for how we think about monopolies and antitrust today.

In this view, the “structure” of an industry (how many firms exist and how hard it is to enter) automatically dictates how firms “behave,” which in turn determines how well the market “performs” for consumers.

* **The logic**: Market Structure $\rightarrow$ Conduct $\rightarrow$ Performance (SCP)
* **The philosophy**: If a market is highly concentrated (few firms), it is assumed they will inevitably behave anti-competitively (charge high prices). Therefore, the government should intervene simply based on a company’s size or market share.
* **The “Big is Bad” mentality**: This era was characterized by a suspicion of large corporations regardless of their actual efficiency.

#### Case Study: U.S. v. U.S. Steel (1920)

This case is a fascinating precursor to the SCP era. While U.S. Steel was a massive entity created by merging dozens of smaller firms, the Supreme Court famously ruled that “the law does not make mere size an offense.”

However, the Harvard scholars who followed (like Edward Mason and Joe Bain) pushed back against this leniency. They argued that:

* High Concentration (U.S. Steel’s massive market share) would naturally lead to...
* Implicit Collusion (Conduct), which results in...
* Inefficiency and High Prices (Performance).

Under the pure Harvard SCP view, U.S. Steel’s dominance alone was a signal that the market was broken, prompting a “trust-busting” approach to break up big players to restore competition.

If the Harvard Tradition was the “prosecutor” of big business, the Chicago School (emerging in the 1970s) was the “defense attorney.” Led by figures like Aaron Director, George Stigler, and Robert Bork, this movement flipped the SCP paradigm on its head.

### The Chicago School: “Efficiency Above All”

The Chicago scholars argued that the Harvard folks were seeing ghosts.

They believed that if a company is huge, it usually isn’t because they are “cheating,” but because they are better at what they do.

* **The logic**: Performance $\rightarrow$ Structure. (A firm is big because it is efficient/successful, not the other way around).
* **The philosophy**: The primary goal of antitrust law should be Consumer Welfare, typically measured by lower prices and higher output.
* **The “Laissez-faire” approach**: They argued that markets are “self-correcting.” If a monopoly charges too much, a smart entrepreneur will eventually swoop in to undercut them. Therefore, government intervention often does more harm than good.

#### Key Departures from Harvard

The Chicago School challenged two major Harvard assumptions:

* **Entry Barriers**: Harvard thought things like high advertising costs were “barriers.” Chicago argued these were just “costs of doing business”. If a market is profitable enough, capital will always find a way in.
* **Vertical Integration**: Harvard hated when a manufacturer bought its supplier. Chicago argued this usually creates efficiencies (like cheaper shipping or better coordination) that actually lower prices for Grandma.

### Post-Chicago IO

Modern Game Theory (or “Post-Chicago”) moved away from rigid rules and began treating the market like a strategic chessboard.

Instead of assuming “Big is Bad” or “Big is Efficient,” it uses math to show that it depends on the players.

* **The logic**: Behavior is a game of “If I do X, you will do Y.”
* **Strategic interaction**: Firms don’t just react to prices; they try to manipulate the market (e.g., intentionally over-investing in factory space just to scare off new competitors).
* **The nuance**: It proves that even small actions can have huge anti-competitive effects, meaning the government shouldn’t be totally hands-off (Chicago) or totally aggressive (Harvard), but rather case-by-case

The ‘nuance’ part is especially important. Because modern IO uses math to map out every possible strategy, you can create a perfectly logical model to prove almost anything.

* **Model A** might show that a merger helps consumers by cutting costs.
* **Model B** might show that the same merger allows the company to bully suppliers.

Both are theoretically intuitive (they make sense on paper), but in the real world, an antitrust judge has to figure out which one actually describes the industry they are looking at. It’s like having twenty different maps for the same forest; they all look professional, but only one will lead you to the exit.

If a regulator blocks a merger because they fear “higher prices” (First-order effects), they might miss the fact that the merger would have funded “Massive Innovation” (Second-order effects). Modern IO struggles to weigh these because:

* **Complexity**: Second-order effects are harder to measure.
* **Sensitivity**: A tiny change in a math variable can flip a model from “This is good for people” to “This is a disaster.”

How this plays out in the real-world, like the “Big Tech” debates where “free” services (first-order) might lead to “less privacy” (second-order), will be part of the discussion in the next chapters.

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

Specific to this article:

- Ernst R. Berndt, Linda Bui, David Reiley, and Glen Urban, “The Roles of Marketing, Product Quality and Price Competition in the Growth and Composition of the U.S. Anti-Ulcer Drug Industry,” NBER Working Paper 4904 (1994), https://doi.org/10.3386/w4904.
- Wright R. How Zantac became the best-selling drug in history. Journal of Health Care Marketing. 1996;16(4):24-29.

#### Thank you for reading!
**Disclaimer**: *I write to learn, based on my background and personal experience. Errors are my own, and if you spot them, let me know! I also appreciate suggestions to investigate new topics!*