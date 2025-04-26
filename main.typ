
#let project(title: "", authors: (), body) = {
  set document(author: authors, title: title)
  set page(
    paper: "a4",
    margin: (x: 2.5cm, y: 3cm),
  )
  set text(
    size: 24pt,
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
#set page(height: auto)


= 導出図
- X は Logical Formula全体の集合
- A は 公理系
- B は 無限集合
- ⊥ が Bの中にいたら B = X
- ⊥ はどこにいるかわからない
- ⊥ はAもBもXも可能

#todo(
Aは公理系なのでAをという名前を辞めて set of axioms  
)

#figure(
  image("./A-B-X.svg", width: 50%),
  caption: "Venn Diagram Representation"
)

#figure(
  image("./A-B-X_contradiction_assumption.svg", width: 50%),
  caption: "Venn Diagram Representation of Contradiction"
)
#figure(
  image("./A-B-X_contradiction_conclution.svg", width: 50%),
  caption: "Venn Diagram Representation of Contradiction"
)

== 背理法

#import "@preview/curryst:0.5.0": rule, prooftree

#let basic_raa = rule(
  name: $1 text("(背理法)")$,
  $chi$,
  rule(
    name: $$,
    $bot$,
    rule(
      name: $$,
      $dots.v$,
      $cancel([not chi])^1$,
    )
  )
)

#align(center)[
  *基本的な背理法の導出図*
  #v(1em)
  #prooftree(basic_raa)
]
