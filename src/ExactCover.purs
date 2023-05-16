module ExactCover where

import Prelude
import Data.List.Lazy (List)
import Data.Function.Uncurried (Fn3, runFn3)
import JS.Iterable (Iterable, toLazyList)

foreign import dlx :: Fn3 Int (Array (Array Int)) (Array Int) (Iterable (Array Int))

lazyExactCovers :: Int -> Array (Array Int) -> Array Int -> List (Array Int)
lazyExactCovers nbVertices edges fixedVertices = toLazyList $ runFn3 dlx nbVertices edges fixedVertices