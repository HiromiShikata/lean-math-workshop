
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
- Set of Axioms は 公理系、 Axiom が公理
- Deductive Closure は Set of Axioms から導出図の書ける Logical Foumla の全体の集合
- Deductive Closure は 無限集合
- 一番外 は Logical Formula 全体の集合
- ⊥ が Deductive Closure の中にいたら 
$
"(Deductive Closure)" = "(Set of Logical Foumlas)"
$
- ⊥ はどこにいるかわからない
- ⊥ は Set of Axioms も Deductive Closure もAもBもXも可能

/* (
Aは公理系なのでAをという名前を辞めて Set of Axioms
B は Deductive Closure
) */

#figure(
  image("./A-B-X.svg", width: 50%),
  caption: "Example of Axioms"
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

=== Step 1: Assume ¬χ in Set of Axioms
#figure(
  image("./A-B-X_contradiction_step1.svg", width: 50%),
)
- ¬χ を Set of Axioms に付け加える
/* #TODO:
 Venn 図と導出図の対応関係をそれぞれのstepに書く
 */

=== Step 2: 
#figure(
  image("./A-B-X_contradiction_step2.svg", width: 50%),
)
- Deductive Closure に ⊥ があった場合


=== Step 3:

#figure(
  image("./A-B-X_contradiction_step3.svg", width: 80%),
)
- [¬χ] を消す


=== Step 4:
#figure(
  image("./A-B-X_contradiction_step4.svg", width: 80%),
)
- χ を Deductive Closure に置く

=== Step 5:
#figure(
  image("./A-B-X_contradiction_step5.svg", width: 80%),
)
- ⊥を消す