import Tutorial.Advanced.Category.Lecture1
import Mathlib.RingTheory.TensorProduct

namespace Tutorial 

open Category

namespace Category

universe u v

variable {C : Type u} [Category.{u, v} C]

/- # 始対象 -/

/-- `a`が始対象とは、任意の`b`について`a`から`b`への射が一意に存在するときをいう。 -/
structure Initial (a : C) where
  /-- 射の族: 各`b : C`について`a`から`b`への射 -/
  from_initial : ∀ b : C, Hom a b
  /-- 射の族の一意性 -/
  uniq : ∀ {b : C}, ∀ f : Hom a b, f = from_initial b

/- `Initial a`は性質ではなく構造として定義している。すなわち、単に射の族が存在するというだけでなく、
射の族データも保持している。これは実装の便宜上の都合である。射の族は一意であるため、数学的な違いは
ないと思ってもらって構わない。 -/

/-- 始対象からの射がふたつ存在すれば、それらは等しい。 -/
theorem Initial.uniq' {a : C} (h : Initial a) {b : C} (f g : Hom a b) : f = g :=
  calc f = h.from_initial b := by rw [h.uniq f]
       _ = g := by rw [h.uniq g]

end Category

/- # 始対象の例 -/

/-- 空集合は集合の圏における始対象である。 -/ 
-- 正確には、「空型は型の圏における始対象である。」
-- Leanにおける型と通常の数学書における集合はほとんど同じ意味です。
example : Initial Empty where
  from_initial _ := Empty.elim
  uniq _ := funext (fun x ↦ Empty.elim x)

/-- 整数環`ℤ`は可換環の圏における始対象である。 -/
example : Initial (⟨ℤ, inferInstance⟩ : CommRingCat) where
  from_initial := fun R ↦ Int.castRingHom R
  uniq := RingHom.eq_intCast'

/- # 余極限 -/

/- 圏論における重要な構成である**余極限**を定義する。余極限とは、図式に対して定まる圏の対象である。
図式とは、関手の別名である。関手はまだ定義していなかったので、ここで定義しておく。-/

/- もちろん**極限**も同様に定義できるが、このチュートリアルでは余極限のみ扱う。-/

universe u₁ v₁ u₂ v₂

/-- 圏`C`から圏`D`への関手`F`は対象の間の写像`F.obj : C → D`と射の間の
写像`F.map : Hom a b → Hom (F.obj a) (F.obj b)`から成り、恒等射と合成を保つものである。 -/
structure Functor (C : Type u₁) [Category.{u₁, v₁} C] (D : Type u₂) [Category.{u₂, v₂} D] where
  obj : C → D
  map : ∀ {a b}, Hom a b → Hom (obj a) (obj b)
  map_id : ∀ a, map (𝟙 a) = 𝟙 (obj a)
  map_comp : ∀ {a b c} (f : Hom a b) (g : Hom b c), map (f ≫ g) = (map f) ≫ (map g)

/- 公理の等式をsimp補題に設定しておく -/
attribute [simp] Functor.map_id Functor.map_comp

/- 余極限とは、普遍性を持つ**余錐**のことである。まずは余錐を定義する。-/

variable {J : Type u₁} [Category.{u₁, v₁} J] {C : Type u₂} [Category.{u₂, v₂} C]

/-- 関手`F`上の余錐 -/
structure Cocone (F : Functor J C) where
  /-- `C`の対象（頂点という） -/
  vertex : C
  /-- 頂点への射の族 -/
  to_vertex : ∀ j : J, Hom (F.obj j) vertex
  /-- 射の族の自然性 -/
  naturality : ∀ {i j : J} (f : Hom i j), F.map f ≫ to_vertex j = to_vertex i

/- 公理の等式をsimp補題に設定しておく -/
attribute [simp] Cocone.naturality

/- 余錐全体は圏を成す。射の集合は次のように定義される。-/

variable {F : Functor J C}

/-- 余錐の間の射 -/
@[ext]
structure CoconeHom (s t : Cocone F) where
  /-- 頂点の間の射 -/
  hom : Hom s.vertex t.vertex
  /-- `hom`と余錐の射は可換 -/
  comm : ∀ j : J, s.to_vertex j ≫ hom = t.to_vertex j := by aesop

attribute [simp] CoconeHom.comm

/-- 余錐全体は圏を成す。 -/
instance : Category (Cocone F) where
  Hom s t := CoconeHom s t
  Comp {r s t} (f : CoconeHom r s) (g : CoconeHom s t) := 
    { hom := f.hom ≫ g.hom,
      comm := by 
        intro j
        calc r.to_vertex j ≫ f.hom ≫ g.hom 
          _ = (r.to_vertex j ≫ f.hom) ≫ g.hom  := by rw [Category.assoc]
          _ = s.to_vertex j ≫ g.hom := by rw [f.comm]
          _ = t.to_vertex j := by rw [g.comm] }
  Id t := 
    { hom := 𝟙 t.vertex,
      comm := by
        intro j 
        rw [Category.comp_id] }

/- これで余極限を定義する準備が整った。余極限は普遍性を持つ余錐であると述べたが、ここでいう普遍性とは
始対象のことである。-/

/-- 余極限とは、余錐の圏での始対象のこと。 -/
def Colimit {F : Functor J C} (t : Cocone F) := Initial t

/- 図式を取り換えるごとに様々な余極限が考えられる。以下では余積とコイコライザーについて考える。 -/

/- # 余積 -/

namespace Coproduct

/- 余積の図式とは、2元集合からの関手である。 -/

/- 2元集合は帰納型として定義される。帰納型は`inductive`コマンドで定義することができる。
帰納型の詳細については https://leanprover.github.io/theorem_proving_in_lean4/inductive_types.html
を参照せよ。
 -/

/-- 2元集合 `{l, r}` -/
inductive Shape : Type
  | l : Shape
  | r : Shape

/- 2元集合を、恒等射のみを持つ圏とみなす。「射の型」の定義にも帰納型を使おう。 -/

/-- `Shape`上の射。恒等射のみを持つ。 -/
inductive ShapeHom : Shape → Shape → Type
  -- 各`i : Shape`について`i`から`i`への射
  | id : ∀ i : Shape, ShapeHom i i

instance : Category Shape where
  Hom i j := ShapeHom i j
  Id i := match i with
    /- `match`構文によるパターンマッチを用いた定義。`.l`は`Shape.l`の略。 -/
    | .l => ShapeHom.id .l
    | .r => ShapeHom.id .r
  Comp {i j k} _ _ := match i, j, k with
    /- 再びパターンマッチを用いる。ここはLeanが賢くて、空集合から元をとっているケース
    を書かずに済んでいる -/
    | .l, .l, .l => ShapeHom.id .l
    | .r, .r, .r => ShapeHom.id .r
  /- `<;>`でtacticを繋げて場合分けの証明をコンパクトに行うことができる -/
  id_comp := by rintro ⟨i⟩ ⟨j⟩ ⟨f⟩ <;> rfl
  comp_id := by rintro ⟨i⟩ ⟨j⟩ ⟨f⟩ <;> rfl
  assoc := by rintro ⟨i⟩ ⟨j⟩ ⟨k⟩ ⟨l⟩ ⟨f⟩ ⟨g⟩ ⟨h⟩ <;> rfl

@[simp]
theorem shapeHom_id {i : Shape} : ShapeHom.id i = 𝟙 i := match i with
 | .l => rfl
 | .r => rfl

end Coproduct

/- # 余積の例 -/

/- 圏`Type`での余積はdisjoint unionである。Leanではsum typeとも呼ばれる。`A`と`B`のsum typeを
`A ⊕ B`と書く。sum typeには標準的な写像`Sum.inl : A → A ⊕ B`, `Sum.inr : B → A ⊕ B`が付随する。 -/

/-- 直和を頂点に持つ余錐 -/
@[simps]
def sumCocone (F : Functor Coproduct.Shape Type) : Cocone F where
  vertex := F.obj .l ⊕ F.obj .r
  to_vertex j := match j with
    | .l => Sum.inl
    | .r => Sum.inr
  naturality f := match f with
    | .id _ => by simp
    
/- 集合の圏における余積はdisjoint union -/
example (F : Functor Coproduct.Shape Type) : Colimit (sumCocone F) where
  from_initial t := {
    hom := fun x ↦ match x with
      | .inl x => t.to_vertex .l x
      | .inr x => t.to_vertex .r x
    comm := fun j ↦ match j with
      | .l => rfl
      | .r => rfl }
  uniq := by 
    intro t f 
    apply CoconeHom.ext
    funext x
    rcases x with x | x
    · apply congrFun (f.comm .l) x
    · apply congrFun (f.comm .r) x
    
variable {R : CommRingCat}

/- 圏`CommAlgCat R`での余積はテンソル積である。`A`と`B`のテンソル積を`A ⊗[R] B`と書く。テンソル積には
標準的な写像
* `Algebra.TensorProduct.includeLeft : A →ₐ[R] (A ⊗[R] B)` 
* `Algebra.TensorProduct.includeRight : B →ₐ[R] (A ⊗[R] B)`
が付随する。ここで、`→ₐ[R]`は`AlgHom`を表す記号である。 -/

/- おまじない。テンソル積の記号が使えるようになる。 -/
open scoped TensorProduct

/-- テンソル積を頂点に持つ余錐 -/
@[simps]
def tensorCocone (F : Functor Coproduct.Shape (CommAlgCat R)) : Cocone F where
  vertex := ⟨(F.obj .l) ⊗[R] (F.obj .r), inferInstance, inferInstance⟩
  to_vertex := fun j ↦ match j with
    -- ヒント: 「標準的な写像」を使おう
    | .l => Algebra.TensorProduct.includeLeft
    | .r => Algebra.TensorProduct.includeRight
  naturality := by
    rintro i j ⟨_⟩
    -- ヒント: `simp`を試してみよう
    simp

/- `R`上の可換代数の圏における余積はテンソル積 -/
example (F : Functor Coproduct.Shape (CommAlgCat R)) : Colimit (tensorCocone F) where
  from_initial t := {
    -- ヒント: `Algebra.TensorProduct.productMap`を使う
    hom := Algebra.TensorProduct.productMap (t.to_vertex .l) (t.to_vertex .r)
    comm := by 
      rintro (_ | _)
      -- ヒント: `simp`を試してみよう
      · simp
      · simp }
  uniq := by 
    intro t f 
    apply CoconeHom.ext
    have hₗ : ∀ a : F.obj .l, f.hom (Algebra.TensorProduct.includeLeft a) = (t.to_vertex .l) a := by
      -- ヒント: `AlgHom.congr_fun`を使う
      apply AlgHom.congr_fun (f.comm .l)
    have hᵣ : ∀ b : F.obj .r, f.hom (Algebra.TensorProduct.includeRight b) = (t.to_vertex .r) b := by
      apply AlgHom.congr_fun (f.comm .r)
    -- ヒント: `Algebra.TensorProduct.ext`を使う
    apply Algebra.TensorProduct.ext
    intro a b
    change f.hom (a ⊗ₜ[R.base] b) = (t.to_vertex .l) a * (t.to_vertex .r) b
    rw [← hₗ, ← hᵣ]
    change f.hom _ = f.hom _ * f.hom _
    rw [← map_mul]
    congr 1
    simp

/- # コイコライザー -/

namespace Coequalizer

/- まずはコイコライザーの図式を定義する。コイコライザーの図式とは以下の圏からの関手である。 
* 対象: `src`, `tar`
* 射: `src`から`tar`へのふたつの射`fst`, `snd`
```   
src ---- fst, snd ----> tar
```
-/

/- これをLeanで書くと次のようになる -/

inductive Shape : Type
  | src : Shape
  | tar : Shape

inductive ShapeHom : Shape → Shape → Type
  | fst : ShapeHom .src .tar
  | snd : ShapeHom .src .tar
  | id (x : Shape) : ShapeHom x x

/- 合成と恒等射はパターンマッチで定義する -/

instance : Category Shape where
  Hom i j := ShapeHom i j 
  Comp {i j k} f g := match i, j, k with
    | .src, .src, .src => ShapeHom.id .src
    | .tar, .tar, .tar => ShapeHom.id .tar
    | .src, .tar, .tar => f
    | .src, .src, .tar => g
  Id i := match i with
    | .src => ShapeHom.id .src
    | .tar => ShapeHom.id .tar
  id_comp := by rintro ⟨i⟩ ⟨j⟩ ⟨f⟩ <;> rfl
  comp_id := by rintro ⟨i⟩ ⟨j⟩ ⟨f⟩ <;> rfl
  assoc := by rintro ⟨i⟩ ⟨j⟩ ⟨k⟩ ⟨l⟩ ⟨f⟩ ⟨g⟩ ⟨h⟩ <;> rfl

@[simp]
theorem hom_id {i : Shape} : ShapeHom.id i = 𝟙 i := by cases i <;> rfl

end Coequalizer

/- # コイコライザーの例 -/

/- 圏`Type`のコイコライザーについて考える。図式`F : Functor Coequalizer.Shape Type`に対して
* `X := F.obj .src`
* `Y := F.obj .tar`
* `f := F.map .fst`
* `g := F.map .snd`
とおいて、`∼`を「任意の`x : X`について`f x ∼ g x`」で生成される同値関係としたとき、商集合`Y / ∼`が
`F`のコイコライザーとなる。-/

/- 「生成される同値関係」は帰納型を使ってシンプルに定義できる -/

inductive coequalizerRel {X Y : Type} (f g : X → Y) : Y → Y → Prop
  | rel : ∀ x : X, coequalizerRel f g (f x) (g x)

/- （正確にはこれは「生成される二項関係」であるが、商をとったら同じになるので違いは気にしないでおく） -/

/- Leanにおいて商集合は`Quot`型で表される。二項関係`r : X → X → Prop`が与えられたとき、`Quot r`は`r`で
生成される同値関係で`X`を割った集合を表す。 -/

/- 商集合を作るときに使う -/
#check Quot

/- 商集合の元を作るときに使う -/
#check Quot.mk

/- 商集合からの写像を作るときに使う -/
#check Quot.lift

/- 商集合の元に関する性質を示すときに使う -/
#check Quot.ind

/- 商の公理: 2項関係で関係するふたつの元は、商をとると等しくなる -/
#check Quot.sound

/-- 商集合を頂点に持つ余錐 -/
@[simps]
def quotCocone (F : Functor Coequalizer.Shape Type) : Cocone F where
  -- ヒント: `Quot`を使う
  vertex := Quot (coequalizerRel (F.map .fst) (F.map .snd))
  to_vertex := fun j => match j with
    -- `Quot.mk`を使う
    | .src => fun x ↦ Quot.mk _ (F.map .fst x)
    | .tar => fun x ↦ Quot.mk _ x
  naturality := by 
    rintro (_ | _) (_ | _) ⟨_⟩
    · simp
    · rfl
    · symm
      funext x   
      -- `Quot.sound`を使う   
      apply Quot.sound
      apply coequalizerRel.rel
    · funext x
      simp

example (F : Functor Coequalizer.Shape Type) : Colimit (quotCocone F) where
  from_initial t := 
    { -- `Quot.lift`を使う
      hom := Quot.lift (t.to_vertex .tar) <| by
        intro x₁ x₂ ⟨x⟩
        have h₁ : t.to_vertex .tar (F.map .fst x) = t.to_vertex .src x := 
          congrFun (t.naturality .fst) x
        have h₂ : t.to_vertex .tar (F.map .snd x) = t.to_vertex .src x := 
          congrFun (t.naturality .snd) x
        rw [h₁, h₂]
      comm := by
        intro j
        funext x
        rcases j
        · apply congrFun (t.naturality .fst)
        · rfl }
  uniq := by
    intro t f 
    apply CoconeHom.ext
    funext x 
    -- `Quot.ind`を使う。`apply Quot.ind _ x`のように使うとよい。
    apply Quot.ind _ x
    intro y 
    apply congrFun (f.comm .tar) y

end Tutorial