module ExactCover where

import Prelude
import Data.List.Lazy (List)
import Data.JsGenerator (JsGenerator, toLazyList)

foreign import dlx :: Int -> Array (Array Int) -> Array Int -> JsGenerator (Array Int)

lazyExactCovers :: Int -> Array (Array Int) -> Array Int -> List (Array Int)
lazyExactCovers nbVertices edges fixedVertices = toLazyList $ dlx nbVertices edges fixedVertices