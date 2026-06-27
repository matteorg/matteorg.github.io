---
date: "2026-03-14"
title: "Game Theory"
linktitle: "Game Theory" # What shows up in the sidebar
type: book                    # Essential: keeps it part of the 'book' layout
weight: 2                     # 1 = Top of the sidebar, 2 = Below it, etc.
---

![A Beautiful Mind](/images/comp-econ/game-theory/beautiful-mind.jpg "Russel Crowe interpreting John Nash in ‘A Beautiful Mind’.")

## Introduction
**Game theory** is the formal analysis of the behavior of interacting individuals. The crucial feature of an interactive situation is that the consequences of the actions of an individual depend (also) on the actions of other individuals. This is typical of many games people play for fun, such as chess or poker. Hence, interactive situations are called **games** and interactive individuals are called **players**. If a player’s behavior is intentional and he is aware of the interaction (which is not always the case), he should try and anticipate the behavior of other players. This is the essence of strategic thinking.

Why is it important to introduce some game theory concepts for competition economics? Well, imperfect competition usually involves strategic interactions. A firm’s action (price choice, quantity produced, $R\\&D$, advertising expenditures, etc.) affects its rivals’ profits and incentives. Game theory helps us predict outcomes for industries in which firms interact strategically.

The following short review is aimed recapping the most basic game theory concepts used in industrial organization. For an exhaustive and more formal deep dive into game theory I strongly recommend using Pierpaolo Battigalli’s notes, which are freely available [here](https://didattica.unibocconi.eu/mypage/doc.php?idDoc=29501&IdUte=48808&idr=703&Tipo=m&lingua=eng).

## Static Games
In **static games** active players move simultaneously once and for all. In this case each player has only one **action** to take. In **dynamic games**, some or all moves are sequential. In this case each player can have multiple actions to take. The full sequence of actions that leads to the final outcome of the game can be referred to as a **strategy**. In certain cases we will use *strategy* and *action* interchangeably for simplicity (especially in static games, where strategy and action can be considered the same). Games with sequential moves are sometimes analyzed as if the players moved only once and simultaneously. The **normal form** or **strategic form** of a game can be seen as a static game where players simultaneously choose strategies in advance.

{{< beamer-definition type="the" title="Definition: Static Game" >}}
A **static game** is described by:

1. A set of **players**, $I = \{1, 2, \dots, N\}$.
2. For each player, an **action set** $A_i$. Let $a = (a_1, a_2, \dots, a_N) \in \times_{i \in I} A_i$ the list of the actions chosen by each player. We say that $a$ is an outcome of the game, or an **action profile**.
3. For each player $i$, a **payoff function**
$$
\pi_i : a \in \times_{j \in I} A_j \to \pi_i(a) \in \mathbb{R}
$$
{{< /beamer-definition >}}

{{< beamer-example type="the" title="Example: Price Competition with Differentiated Products" >}}
The **static game** is described by:

1. Two **players**, firm 1 and firm 2.
2. **Action set** of firm $i$: $p_i \in [0, +\infty)$ for $i \in \{1, 2\}$ (the set of non-negative prices). An example of **action profile** could be $p_1 = 3$ and $p_2 = 4$.
3. For each firm $i$, a **payoff function** (the profit function)
$$
\pi_i(p_i, p_j) = (p_i - c_i)q_i(p_i, p_j)
$$
where $q_i(p_i, p_j)$ denotes firm $i$'s demand at prices $p_i$ and $p_j$.
{{< /beamer-example >}}

It is sometimes possible to represent the game in matrix form, which ultimately simplifies our search for possible *solutions* of the game. To best illustrate how to build a matrix representation let’s start from another example, undoubtedly the most famous game to start grasping game theory concepts: **the prisoners’ dilemma**.

Suppose **Alan** and **Bob** are caught by the police and accused of having committed a crime. Currently the police has no proof, so they decide to interrogate the suspects in two separate rooms. Alan and Bob are both presented with the following options:

* if **both** confess, they’ll have to spend 5 years in prison.
* if **one** confesses while the other stays silent, the defector (the one confessing) will be released immediately while the partner will have to spend 10 years in prison.
* if **neither** confesses, they’ll both have to spend only 1 year in prison as suspects.

Not knowing what the other partner will say in the separate room, Alan and Bob (from now on **A** and **B**) are both left with the choice to either **cooperate** (i.e. remain silent) or **defect** (i.e. confess and testify against the partner), which we’ll refer to as **C** and **D** from now on.

Not knowing what the other partner will say in the separate room, Alan and Bob (from now on **A** and **B**) are both left with the choice to either **cooperate** (i.e. remain silent) or **defect** (i.e. confess and testify against the partner), which we’ll refer to as **C** and **D** from now on.

If you imagine their payoff (or utility) to be measured in **years of life** (so any year spent in prison is a *lost year*), **A** and **B** will have the following:

$$
\pi_i(a_i, a_j) = \begin{cases} -1 & \text{if } a_i = a_j = C \\\\ 0 & \text{if } a_i = D \text{ and } a_j = C \\\\ -10 & \text{if } a_i = C \text{ and } a_j = D \\\\ -5 & \text{if } a_i = a_j = D \end{cases}
$$

Given this utility function, we can conveniently represent this game in its **matrix form**:

$$
\begin{array}{c|c|c}
 & C & D \\\\
\hline
C & (-1, -1) & (-10, 0) \\\\
\hline
D & (0, -10) & (-5, -5)
\end{array}
$$

where, by convention:

* row player is A, column player is B.
* the first number in parentheses is the row player’s payoff; the second one is the column player’s payoff.

Now that we have defined a game, we would like to make predictions about what players will actually do. Put differently, we need a **solution concept** (or an **equilibrium concept**)

### Equilibrium in dominant strategies

Before defining what a dominant strategy is, it is convenient to rewrite the action profile as $a = (a_i, a_{-i})$, where $\forall i \in I$
$a_{-i} = (a_1, a_2, \dots, a_{i-1}, a_{i+1}, \dots, a_{N-1}, a_N)$, namely the set of all actions of all players other than $i$.

{{< beamer-definition type="the" title="Definition: Dominant Strategy" >}}
$\tilde{a}_i \in A_i$ is a (strictly) **dominant strategy** for player $i$ if:

$$\\forall a_{-i} \in \times_{j \in I \setminus \\{i\\}} A_j, \\forall a_i \in A_i \text{ s.t. }  a_i \\neq \tilde{a}\_i, \pi_i(\tilde{a}\_i, a_{-i}) > \pi_i(a_i, a_{-i})$$
{{< /beamer-definition >}}

In other words, a strategy is strictly dominant if it gives player $i$ a higher payoff than any other possible move, regardless of what the other players choose to do. You don’t even need to try and “predict” your opponents; you should just play this move every single time because it always wins.

Let’s consider our prisoner’s dilemma again and specifically on player $A$. To make it more visually clear, underline the highest payoff that player $A$ can get by choosing $C$ or $D$ given the opponents’ choice. This means, given player $B$ chooses $C$ (focus on first column), player $A$ should compare payoffs $-1$ (from choosing $C$, first row) and $0$ (from choosing $D$, second row). Clearly, being $0 > -1$, $A$ would choose $D$ if he knew $B$ was playing $C$.

$$
\begin{array}{c|c|c}
 & C & D \\\\
\hline
C & (-1, -1) & (-10, 0) \\\\
\hline
D & (\underline{0}, -10) & (-5, -5)
\end{array}
$$

If you apply the same reasoning to both players and both choices you obtain the following representation:

$$
\begin{array}{c|c|c}
 & C & D \\\\
\hline
C & (-1, -1) & (-10, \underline{0}) \\\\
\hline
D & (\underline{0}, -10) & (\underline{-5}, \underline{-5})
\end{array}
$$

You can immediately see that for both $A$ and $B$ choice $D$ is a **dominant strategy**. No matter what the other does, the payoff is always higher by choosing $D$ over $C$. Now, we can define our first **equilibrium concept**.

{{< beamer-definition type="the" title="Definition: Equilibrium in Dominant Strategies" >}}
A strategy profile $\tilde{a} = (\tilde{a}\_1, \dots, \tilde{a}\_N) \in \times_{j \in I} A_j$ is an **equilibrium in dominant strategies** if $\tilde{a}_i$ is a dominant strategy for every player $i$, namely if:

$$
\\forall i \in I, \\forall a_{-i} \in \times_{j \in I \setminus \\{i\\}} A_j, \\forall a_i \in A_i \text{ s.t. } a_i \\neq \tilde{a}\_i, \pi_i(\tilde{a}\_i, a_{-i}) > \pi_i(a_i, a_{-i})
$$
{{< /beamer-definition >}}

In our prisoner’s dilemma it is clear that $(D, D)$ is the only equilibrium in dominant strategies (easy to spot also by checking for those boxes where both payoffs are underlined).

Most people look at the prisoner’s dilemma and think the tragedy comes from a **lack of trust**. We tell ourselves: “I only betrayed my partner because I was afraid they would betray me first”. But if you look at the cold, hard math of Game Theory, that explanation is actually incorrect.

* **The trap of individual logic**: in this game, the equilibrium outcome $(-5, -5)$ is what we call Pareto-dominated. This is just a way of saying there is another outcome $(-1, -1)$ where *everyone* would be better off. From a “utilitarian” view, the outcome where both players defect is actually the *absolute worst-case scenario*. Yet, decentralized decision-making (everyone choosing for themselves) leads us there every time.
* **Why “fear” isn’t the driver**: here is the counterintuitive part. You don’t defect because you’re afraid of your partner. You defect because it is the **strictly dominant** thing to do. If your partner stays silent, you get a better deal by defecting ($0$ instead of $-1$). If your partner betrays you, you still get a better deal by defecting ($-5$ instead of $-10$). You aren’t reacting to their choice out of fear; you are choosing the best option for yourself regardless of what they do. Even if you knew for a fact that your partner was the most loyal person on earth, the “rational” move in this specific vacuum is still to betray them.
* **The power of commitment**: this is why communication alone doesn’t solve the problem. If you and your partner simply talk before the game, you’ll both promise to stay silent. But once the doors close, the incentive to “cheat” remains. To reach the better outcome, you don’t just need to talk; you need a binding commitment, a contract or a shared code of honor that makes defecting impossible or too expensive to consider. Without that structure, individual rationality will always lead to a collective disaster.

The prisoner’s dilemma always reminds me of the movie *Four Brothers*, a good example of when the *code of honor* comes into place:
{{< youtube RdMfFtoOP_c >}}

At this point you should ask yourself “Do dominant strategies always exist?”. Let’s consider the following game, famously known as **The Battle of the Sexes**. In the battle of the sexes, we move from the jail cell to the ultimate arena of conflict: date night. Imagine a couple, **Ann** (row player) and **Bill** (column player): **B** wants to see a football match, **A** wants to weep through a three-hour opera.

They both hate being apart, but they have zero ways to coordinate where they’re going. If they end up at different venues, they’re miserable and alone (both get payoff 0); if they go to the same place, one is thrilled (payoff 2) and the other is bored, but at least with snacks and company (payoff 1). It’s the classic “I love you, but I really want my way” dilemma that proves coordination is easy, but agreeing on who gets the remote is where the real game theory begins. Here is the matrix representation of battle of sexes:

$$
\begin{array}{c|c|c}
 & \text{Football} & \text{Opera} \\\\
\hline
\text{Football} & (1, 2) & (0, 0) \\\\
\hline
\text{Opera} & (0, 0) & (2, 1)
\end{array}
$$

Following the same reasoning as above you will see that if $B$ chose football, $A$ would be better off by choosing football as well ($\pi_A(\text{Football}, \text{Football}) = 1 > 0 = \pi_A(\text{Opera}, \text{Football})$). However, if $B$ chose opera, $A$ would be better off choosing opera, making neither football nor opera dominant strategies. Therefore there is no dominant strategy equilibrium in the battle of sexes game.

### Nash equilibrium

In 1951 John Nash introduced a different solution concept. Let’s consider the battle of the sexes where we do the same “underlining” exercise as before:

$$
\begin{array}{c|c|c}
 & \text{Football} & \text{Opera} \\\\
\hline
\text{Football} & (\underline{1}, \underline{2}) & (0, 0) \\\\
\hline
\text{Opera} & (0, 0) & (\underline{2}, \underline{1})
\end{array}
$$

As you can see there are two cases where both payoffs are underlined: (Football, Football) and (Opera, Opera). Consider the former. Would either $A$ or $B$ have any incentive to deviate from (Football, Football)? Of course not. If $A$ chose opera he would lose a payoff of 1. We can say that playing Football, while not being a dominant strategy, is the **best reply** (or **best response**) to the opponent playing Football (i.e. any other choice would not be able to yield strictly higher payoff). While this not being the case in the battle of sexes, you may already guess that the best response need not be a unique action but rather a set.

{{< beamer-definition type="the" title="Definition: Best Response" >}}
An action $\tilde{a}\_i$ is a **best response** to $a_{-i}$ if:

$$
\tilde{a}\_i = BR(a_{-i}) = \arg \max_{a_i \in A_i} \pi_i(a_i, a_{-i})
$$

Since $BR(a_{-i})$ may not be a singleton, we formally talk about **best response correspondence**:

$$
BR(a_{-i}) : \times_{j \in I \setminus \\{i\\}} A_j \rightrightarrows A_i
$$
{{< /beamer-definition >}}

In the context of competition economics here we will mostly think of the best response as a function.

Given the definition of best response, it is straightforward to formalize Nash equilibrium.

{{< beamer-definition type="the" title="Definition: Nash Equilibrium" >}}
A strategy profile $\tilde{a} = (\tilde{a}\_1, \dots, \tilde{a}\_N)  \in \times_{j \in I} A_j$ is a **Nash Equilibrium** if:

$$
\\forall i, \tilde{a}\_i \in BR_i(\tilde{a}\_{-i})
$$
{{< /beamer-definition >}}

In words, each player chooses a strategy that is a best response to other players’ (equilibrium) strategies.

In the battle of the sexes game, and in general in every game that allows a matrix representation, every combination where **all players’ payoffs are underlined** constitute Nash equilibria.

When a matrix representation is not possible (e.g. with continuous action profiles), to do a best response analysis and solve for the Nash equilibria of a game, just do the following:

* For each player $i$ compute $BR_i(.)$.
* Find the intersection of these best responses.

{{< beamer-example title="Example: Price Competition with Differentiated Products" >}}
Consider the price competition with differentiated products model, and let’s make a few additional assumptions:

* $c_1 = c_2 = 0$
* $q_i = 1 - 2p_i + p_j$

So the profit function of firm $i \in \\{1, 2\\}$ is just $\pi_i(p_1, p_2) = $ $p_i(1 - 2p_i + p_j)$. By definition, $BR_i(p_j) = \arg \max_{p_i} p_i(1 - 2p_i + p_j)$.

As the objective function is concave ($\partial^2 \pi_i / \partial p_i^2 < 0$), we can use the **First Order Condition (FOC)**:

$$
1 - 4p_i + p_j = 0
$$

Solving for $p_i$, we get:

$$
p_i = BR_i(p_j) = \frac{1 + p_j}{4}
$$

In this particular example, the best response correspondence is single-valued (i.e. it’s a function). $(\hat{p}_1, \hat{p}_2)$ is a Nash equilibrium if and only if:

* $\hat{p}_1 \in BR_1(\hat{p}_2)$
* $\hat{p}_2 \in BR_2(\hat{p}_1)$

Therefore, we have to solve the following system of equations (to get the intersection of best-responses):

$$
\begin{cases}
\hat{p}_1 = \frac{1+\hat{p}_2}{4} \\\\
\hat{p}_2 = \frac{1+\hat{p}_1}{4}
\end{cases}
$$

We get $\hat{p}_1 = \hat{p}_2 = 1/3$.

Therefore, $(1/3, 1/3)$ is the only Nash equilibrium of this price competition game.
{{< /beamer-example >}}

If you think about the previous solution concept, the equilibrium in dominant strategies, that is *always* a Nash equilibrium. Intuitively, a dominant strategy is a best response to *any* strategy profile. However, obviously a Nash equilibrium is **not** always an equilibrium in dominant strategies. Additionally, if you recall how we thought about best responses in the battle of the sexes, when looking for Nash equilibria you should *always* and *only* consider **unilateral deviations** from a given profile, and not **joint** ones.

How do we actually *reach* a Nash equilibrium? It’s not just about math; it’s about what you think, what I think, and what I think you think. In game theory we refer to this as **introspective foundation**.

Imagine you’re playing a game. To reach an equilibrium, you have to follow a logic loop that sounds like a line from *The Princess Bride*:

* I am rational, so I will maximize my own payoff.
* I know you are rational, so I know you’ll do the same.
* You know that I know you’re rational... and so on, forever.
{{<youtube sE2qa96pq8I>}}

This “common knowledge of rationality” suggests that if we are both perfectly logical, we will naturally settle on a strategy profile where neither of us has any reason to change our minds. We reach a state of perfect, mutual “no-regrets”.

But let’s be honest: this “introspective” approach isn’t always convincing. In fact, it often fails for three very human reasons:

* **It’s mathematically exhausting**: even for PhD-level game theorists, calculating a Nash equilibrium in a complex game is hard. Expecting two people at a bar or two CEOs in a price war to solve multi-variable calculus in their heads is a stretch.
* **The “correct conjecture” trap**: A Nash equilibrium only works if everyone has correct beliefs about what the other person is going to do. If I incorrectly guess your move, my best response becomes a total disaster.
* **The coordination headache**: What happens when a game has multiple Nash equilibria? If there are two “logical” stable points, how do we make sure we don’t both pick different ones and end up unhappy?
    * Consider for example the battle of the sexes. How should a player choose, even knowing that two Nash equilibria are possible? The introspection story does not tell us how players can coordinate on one of these equilibria!

So, Nash equilibrium appears to be a beautiful theoretical benchmark, though it relies on players being “hyper-rational.” In reality, we often rely on habits, social norms, or trial-and-error rather than infinite logical loops to figure out our next move.

Last but not least, just like we did in the previous paragraph before introducing the battle of the sexes, you should ask yourself “Does a Nash equilibrium always exist?”. The answer is simple and is of course no. The definition of Nash equilibrium does not guarantee its existence. Try to find one or more Nash equilibria in the following game, which I’m sure you’re familiar with:

$$
\begin{array}{c|c|c|c}
 & \text{Rock} & \text{Paper} & \text{Scissor} \\\\
\hline
\text{Rock} & (0, 0) & (-1, \underline{1}) & (\underline{1}, -1) \\\\
\hline
\text{Paper} & (\underline{1}, -1) & (0, 0) & (-1, \underline{1}) \\\\
\hline
\text{Scissor} & (-1, \underline{1}) & (\underline{1}, -1) & (0, 0)
\end{array}
$$

For simplicity I already underlined each player’s best response. As you can see, there’s no combination where a player’s best response to a given opponent’s move is also the opponent’s best response to the player’s action. So no Nash equilibrium exists in this game.{{< infotip "" "Under weak assumptions, even in the Rock-Paper-Scissor game an equilibrium may exist, called $\text{Nash equilibrium in Mixed Strategies}$, which I will however not cover when talking about competition economics.">}}

## Sequential Games
As we introduced before, some games may have multiple steps (and some players may have multiple moves). Let’s start with a simple example of a seller-buyer game. Consider two individuals, $S$ (Seller) and $B$ (Buyer). Let $S$ be the owner of an object and $B$ a potential buyer. For simplicity, consider the following bargaining protocol: $S$ can ask one Dollar (1) or two Dollars (2) to sell the object, $B$ can only accept (a) or reject (r). The monetary value of the object for individual $i$ ($i = S, B$) is denoted by $\pi_i$. This situation can be analyzed as a game which can be represented with a **rooted tree** with utility numbers attached to **terminal nodes** (leaves), player labels attached to **nonterminal nodes**, and action labels attached to **branches**.

![Seller-Buyer mini game](/images/comp-econ/game-theory/sb-mini-game.png "Seller-Buyer mini game")

An intuitive definition for a **sequential game** is a game that can be represented by a game tree, or equivalently in its **extensive form**.

{{< beamer-definition type="the" title="Definition: Sequential Game" >}}
A **sequential game** is:

1. A game tree containing a starting node, other decision nodes, terminal nodes, and branches linking nodes.
2. A list of players $\{1, 2, \dots, N\}$.
3. For each decision node, the name of the player(s) entitled to choose an action.
4. For each player $i$, a specification of $i$'s action set at each node where player $i$ is entitled to choose an action.
5. A specification of the payoff of each player at each terminal node.
{{< /beamer-definition >}}

While in static games a strategy was just an action - therefore we could use the terms interchangeably - in sequential games we refer to a strategy as a **plan of actions**, so the distinction becomes crucial.

Continuing the comparison with static games, it is interesting to note that it is possible to represent sequential games *also* in a normal form, and in certain cases even via matrix representation. Consider the seller-buyer game. The actions and payoffs could be rewritten as follows:

<div style="overflow-x: auto;">

$$
\begin{array}{c|c|c|c|c}
 & \text{a,a} & \text{a,r} & \text{r,a} & \text{r,r} \\\\
\hline
\text{1 dollar} & (1-\pi_S, \pi_B-1) & (1-\pi_S, \pi_B-1) & (0, 0) & (0, 0) \\\\
\hline
\text{2 dollars} & (2-\pi_S, \pi_B-2) & (0, 0) & (2-\pi_S, \pi_B-2) & (0, 0)
\end{array}
$$

</div>

In this representation think of the buyer’s strategy not as a single move, but as a remote-controlled instruction manual he hands over before the game starts. In a static game, you just react to what’s happening. In a sequential game represented this way, the buyer has to decide his response to every possible scenario the seller might create.

When you see a strategy like $\text{(a, r)}$, read it as an “If-Then” statement. The position in the couple corresponds to the specific “node” or choice the seller makes:

* The 1st slot is the response to 1 dollar.
* The 2nd slot is the response to 2 dollars. So, if the buyer chooses the column $\text{(a, r)}$, they are saying: “If you charge me $\\$1$, I will accept; but if you charge me $\\$2$, I will reject.”

Now, we can just extend our definition of a Nash equilibrium to these somewhat more complicated games: in words, a profile of strategies is a Nash equilibrium if and only if no player has an incentive to deviate from his strategy. To begin with, let’s look for Nash equilibria in the seller-buyer mini game. Let’s assume for simplicity that $\pi_S=0.5$ and $\pi_B=2.5$:

$$
\begin{array}{c|c|c|c|c}
 & \text{a,a} & \text{a,r} & \text{r,a} & \text{r,r} \\\\
\hline
\text{1 dollar} & (0.5, \underline{1.5}) & (\underline{0.5}, \underline{1.5}) & (0, 0) & (\underline{0}, 0) \\\\
\hline
\text{2 dollars} & (\underline{1.5}, \underline{0.5}) & (0, 0) & (\underline{1.5}, \underline{0.5}) & (\underline{0}, 0)
\end{array}
$$

In this game we have 3 Nash equilibria:

* ($\\$1$,$\text{(a, r)}$)
* ($\\$2$,$\text{(a, a)}$)
* ($\\$2$,$\text{(r, a)}$)

Now, not all of the equilibria seem to make sense. Why would the seller ever want to reach the equilibrium in which he sells for $\\$1$? Forget about Nash equilibrium for a moment. A rational seller should be able to make the following reasoning: “If I sell for $\\$2$ the buyer is going to make a positive profit by accepting, so he’s going to accept no matter what I charge. Why should I sell for $\\$1$ and deprive myself of $\\$1$ extra profit?”. Ultimately the equilibrium should be reached by the seller choosing $\\$2$ and the buyer accepting.

This kind of intuitive reasoning is called backward induction:

* Start solving for optimal decisions in terminal nodes, and derive the implied payoffs.
* Go one step back and, again, solve for optimal decisions, anticipating that people will behave optimally in subsequent nodes. Derive the implied payoffs.
* Iterate until you reach the initial node.

This thought process is not contained in the Nash equilibrium concept.

Bottom line:

* Nash generates weird equilibria in some simple multistage games.
* Backward induction seems to eliminate these equilibria.
* A “backward induction equilibrium” is *always* a Nash equilibrium.
* A Nash equilibrium may not be consistent with backward induction.

### Subgame-perfect equilibrium

{{< beamer-definition type="the" title="Definition: Subgame" >}}
A **subgame** is a decision node from the original game along with the decision nodes and and terminal nodes directly following this node. A subgame is called a **strict subgame** if it differs from the original game.
{{< /beamer-definition >}}

In our seller-buyer game there are only **two strict subgames**.

![Seller-Buyer mini game subgame](/images/comp-econ/game-theory/subgames.png "Strict subgames in Seller-Buyer mini game")

The idea of backward induction is to look precisely at these subgames first, them move up. You can even make it more visually clear by drawing arrows to highlight what each player would choose in each subgame. Consider the numeric example of the seller-buyer game from before: at the terminal node the buyer needs to choose between accepting and rejecting. Since no matter what the seller does, the buyer has a strictly positive payoff by accepting, we can draw 2 red arrows indicating what the buyer will do. In the upper node, the seller needs to only compare the payoffs of the paths indicated by the two red arrows and ignore the others (as they won’t be chosen by the seller anyway). Since the payoff from selling for $\\$2$ is higher than in the other scenario, we can draw a blue arrow (the seller’s decision) indicating the final seller’s choice. The path that from the beginning of the tree reaches a terminal node with a ‘continuous’ arrow identifies the equilibrium.

![Backward induction](/images/comp-econ/game-theory/spe.png "Backward induction to find unique rational path.")

So the only equilibrium in this game becomes ($\\$2$,$\text{(a, a)}$).

In the above example we set two arbitrary values of $\pi_i$ for $i \in \\{S,B\\}$. Do you think you can derive the values (or ranges of values) of $\pi_i$. If interested, you can play around with the hidden **equilibrium finder** and later you’ll find a rigorous way to define equilibria for different values of $\pi_S$ and $\pi_B$.

<details>
  <summary><b>Equilibrium Finder</b></summary>

{{< seller-buyer-mini-game >}}

Can we derive general conditions on $\pi_S$ and $\pi_B$ such that the outcome of the game changes based on those?

Let's start from the buyer. The buyer moves second and simply compares his utility from accepting to the zero utility of rejecting.

<div style="overflow-x: auto;">

| Condition <span style="display:inline-block; min-width:100px;"></span> | Buyer Strategy <span style="display:inline-block; min-width:180px;"></span> | Intuition <span style="display:inline-block; min-width:300px;"></span> |
| :--- | :--- | :--- |
| $\pi_B < 1$ | **RR** (Always Reject) | The object is worth so little that even the cheap price is too high. |
| $1 < \pi_B < 2$ | **AR** (Accept 1, Reject 2) | The buyer values the object just enough to accept the lower price. |
| $\pi_B > 2$ | **AA** (Accept 1, Accept 2) | The buyer values the object so much he will take either offer. |

</div>

The seller anticipates the buyer's profile above and chooses the offer that maximizes his own payoff.

* **Case A: the high value buyer ($\pi_B>2$)**: the buyer will accept anything.
    * The seller compares:
        * Offer 1: $1-\pi_S$
        * Offer 2: $2-\pi_S$

    * Since $2-\pi_S>1-\pi_S$ is always true, the seller always chooses Offer 2 $\implies$ **SPE:($\\$2$,$\text{(a,a)}$)**.

* **Case B: the medium value buyer ($1<\pi_B<2$)**: the buyer will reject Offer 2.
    * The seller compares:
        * Offer 1: $1-\pi_S$ (accepted)
        * Offer 2: $0$ (rejected)
    * The seller chooses Offer 1 if $1-\pi_S>0$, i.e. if  $\pi_S<1$. $\implies$ **SPE:($\\$1$,$\text{(a,r)}$)** if $\pi_S<1$.

* **Case C: the low value buyer ($\pi_B<1$)**: the buyer will reject any offer $\implies$ **SPEs:($\\$1$,$\text{(r,r)}$) and ($\\$2$,$\text{(r,r)}$)** with payoffs $(0,0)$.

#### Nash Equilibria (NE) vs. Subgame Perfect Equilibria (SPE)

In the normal form matrix you will often find Nash Equilibria that are not Subgame Perfect.
Example: Set $\pi_S=0.5$ and $\pi_B=2.5$. One NE is ($\\$1$,$\text{(a,r)}$). In this scenario, the buyer "threatens" to reject Offer 2. If the seller believes this, he plays Offer 1. However, this is not Subgame Perfect because if the seller actually made Offer 2, the buyer would realize $2.5-2=0.5$, which is better than $0$. The threat to reject is **not credible**.
</details>

{{< beamer-definition type="the" title="Definition: Subgame-Perfect Equilibrium" >}}
A profile of strategies is a **subgame-perfect equilibrium (SPE)** if it induces a Nash equilibrium in every subgame of the original game.
{{< /beamer-definition >}}

Assume that the game has a **finite** number of periods. Then, even if some players move simultaneously at some nodes, we can still use backward induction to solve the game. The trick is again to start with the deepest subgames and to solve for Nash equilibrium in these subgames. Then, in the extensive form, replace these smallest subgames by the players’ payoffs at the Nash equilibrium you’ve just calculated. Iterate until there are no subgames left.

Let’s look at an example with the battle of the sexes with outside option. In this modified version of the game Ann ($A$) has the possibility to decide first whether to play the game or sit it out. If she doesn’t play, both Ann and Bob ($B$) get a payoff of 2. If Ann plays, Ann and Bob choose simultaneously. The game can be represented as follows:

![BoS with Outside Option](/images/comp-econ/game-theory/bos_oo.png "Battle of the sexes with outside option.")

In this case we know already that in case Ann entered the game, the simultaneous battle of the sexes Nash equilibria would be 2, ($\text{Opera, Opera}$) and ($\text{Football, Football}$). However, only in 1 of these two cases does Ann obtain a payoff higher than under the outside option. So how do we find the subgame-perfect equilibria? An alternative representation could help us. The following extensive-form representation is excellent for visualizing information sets - the dashed line shows that Bob doesn’t know which move Ann made inside that subgame. The biggest conceptual hurdle is how a matrix (which usually implies players move at the same time) can be turned into a tree (which usually implies one moves after another). With the matrix logic in the subgame, neither player knows what the other has chosen until both have committed. With the tree logic we draw Ann moving first ($\text{Opera}$ or $\text{Football}$), followed by Bob. However, the dashed line (the information set) connecting Bob’s nodes is the “magic” ingredient. It signifies that when Bob moves, he does not know whether he is at the left node or the right node (as if he got Ann’s decision in a sealed envelope and now he had to decide). If you list the strategies for both players in either version, they remain the same, and the payoffs at the end of every branch in the tree match the corresponding cells in the matrix.

![BoS with Outside Option Tree](/images/comp-econ/game-theory/bos_tree.png "Equilibria in the battle of the sexes with outside option.")

As you can see it is now easy to derive the 2 subgame-perfect equilibria from the tree structure.

Suppose Bob in the terminal node chooses $\text{Football}$ thinking (or hoping?) that Ann chooses $\text{Football}$. Following this decision, by backward induction Ann would opt-out from the game. This equilibrium is represented by the red arrows. Neither has incentive to deviate from this equilibrium. If Ann chose to opt-in and select either $\text{Opera}$ or $\text{Football}$ she would get a lower payoff. Bob has no way to deviate because Ann doesn’t play anyway.

Suppose Bob in the terminal node chooses $\text{Opera}$ thinking (or suspecting?) that Ann chooses $\text{Opera}$. Following this decision, by backward induction Ann would play the game and choose $\text{Opera}$. This equilibrium is represented by the blue arrows. Neither has incentive to deviate from this equilibrium. If Ann chose to opt-in and select $\text{Football}$ she would get a lower payoff (0 instaed of 3). If she chose not to play she’d also get a lower payoff (2 instead of 3). If Bob chose $\text{Football}$ he would get a lower payoff (0 instead of 1).{{< infotip "" "Interesting side note: in many advanced Game Theory classes, professors discuss $\text{Forward Induction}$. This theory suggests that by choosing $in$, Ann is $signaling$ that she intends to play $\text{Opera}$ (because that's the only way $in$ makes sense). If Bob is rational and follows this logic, he should play $\text{Opera}$, making this SPE the most $logical$ one.">}}

#### Final remarks

* *Caution*: Some games may have several Nash equilibria (or SPE) in some of their subgames, as we just saw. In this case, solving for SPE using backward induction becomes trickier. Never assume uniqueness of SPE.
* *Caution*: If the game has an **infinite** number of periods, then you cannot use backward induction to find its SPEs. We’ll see how to handle those cases.

## Conclusion

In competition economics, we treat firms as players and the market as the game board. With our toolkit from this chapter we’ll be able to analyze classic competitive scenarios and more complex topics. Examples include:

* **The Quantity War (Cournot)**: Imagine two tech giants deciding how many tablets to flood the market with. If both overproduce, prices crash; if they hold back, they leave money on the table. We use Nash Equilibrium to find that “sweet spot” where neither firm wants to change their production level given the other’s output.
* **The Price Cut Trap (Bertrand)**: This is the ultimate “race to the bottom.” We see how firms compete on price alone until they hit their marginal cost. It’s a classic example of a Nash Equilibrium where even two firms can end up acting like a perfectly competitive market.
* **The First-Mover Advantage (Stackelberg)**: This is where Subgame Perfection shines. One firm (the Leader) commits to a strategy first, and the other (the Follower) must react. By “looking ahead and reasoning back”, the Leader can manipulate the market to its advantage, knowing exactly how the Follower will be forced to respond.
* **Beyond the Basics**: We also use these models to understand *Entry Deterrence* (using the “outside option” logic you just saw in the battle of the sexes), *Collusion* (why cartels often break apart), *Product Differentiation* (why Coca-Cola and Pepsi spend billions just to stay “different”).

And there’s much much more…

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