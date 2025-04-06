#let project(title: "", authors: (), body) = {
  set document(author: authors, title: title)
  set page(
    paper: "a4",
    margin: (x: 2.5cm, y: 3cm),
  )
  set text(
    font: "New Computer Modern",
    size: 11pt,
  )
  set heading(numbering: "1.1")
  set math.equation(numbering: "(1)")

  align(center)[
    #text(17pt, weight: "bold")[#title]
    #v(1em)
    #text(14pt)[Mathematics and Proof Assistant]
  ]

  body
}

#show: project.with(
  title: "Lean Mathematics Workshop",
)
= 導出図
- X は Logical Formula
- B は 無限集合
- ⊥ が Bの中にいたら B = X


#figure(
  image("./A-B-X.svg", width: 80%),
  caption: "Venn Diagram Representation"
)










= Introduction
This document covers mathematical concepts and their implementation in the Lean theorem prover.

== Mathematical Logic
Mathematics is built upon logical foundations. In this workshop, we explore how these foundations are represented in Lean.

$ forall x, y in RR, x + y = y + x $

= Basic Concepts
Here we introduce the fundamental concepts needed for working with mathematical proofs in Lean.

== Types and Terms
In Lean, every expression has a type. Here are some basic examples:

$ exists x in NN, forall y in NN, y <= x $

= Advanced Topics
We explore more complex mathematical concepts and their formal proofs.

== Proof by Contradiction
The proof by contradiction (reductio ad absurdum) is a fundamental proof technique. Here's the derivation structure:

$
cases(
  "Starting assumption:" &P arrow Q,
  "Contradiction assumption:" &P and not Q,
  "Step 1:" &P &"(from 2)",
  "Step 2:" &P arrow Q &"(from 1)",
  "Step 3:" &Q &"(from 3,4)",
  "Step 4:" &not Q &"(from 2)",
  "Step 5:" &Q and not Q &"(from 5,6)",
  "Conclusion:" &not(P and not Q) &"(by contradiction)"
)
$

This demonstrates that if P implies Q, then it's impossible for P to be true and Q to be false.

$
integral_0^infinity e^(-x^2) d x = sqrt(pi)/2
$

== 背理法の導出図
以下は背理法の導出図です：

$
(P and A)
----------------------- &"[Step 1]"
P
$

$
(P arrow.r.double bot)
----------------------- &"[Step 2]"
not P
$

$
(P and not P)
----------------------- &"[Step 3]"
bot
$

これは背理法の基本的な導出過程を示しています：
1. 任意の前提から P を導出
2. P から矛盾を導出し、not P を得る
3. P と not P から矛盾(bot)を導出
