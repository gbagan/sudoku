module Data.JsGenerator (JsGenerator, toLazyList) where

import Prelude
import Data.List.Lazy.Types (List, Step(..))
import Data.Lazy (Lazy, defer)

foreign import data JsGenerator :: Type -> Type

toLazyList :: forall a. JsGenerator a -> List a
toLazyList = toLazyListImpl defer Nil Cons

foreign import toLazyListImpl ::
  forall b.
  (forall a. (Unit -> a) -> Lazy a) ->
  (forall a. Step a) ->
  (forall a. a -> List a -> Step a) ->
  JsGenerator b -> List b
