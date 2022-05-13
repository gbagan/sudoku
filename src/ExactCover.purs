module ExactCover where

import Prelude
import Data.List.Lazy.Types (List, Step(..))
import Data.List.Lazy as List
import Data.Lazy (Lazy, defer)

foreign import lazyDlxImpl :: (forall a. (Unit -> a) -> Lazy a) 
                         -> (forall a. Step a) 
                         -> (forall a. a -> List a -> Step a)
                         -> Int -> Array (Array Int) -> Array Int -> List (Array Int)

lazyExactCovers :: Int -> Array (Array Int) -> Array Int -> List (Array Int)
lazyExactCovers = lazyDlxImpl defer Nil Cons