module Sudoku.Solver where

import Prelude
import Data.List.Lazy (List)
import Data.Array ((..))
import ExactCover (lazyExactCovers)

type Cell
  = { row :: Int
    , col :: Int
    , value :: Int
    }

cellToInt :: Int -> Cell -> Int
cellToInt size { row, col, value } = row * size * size + col * size + value - 1

intToCell :: Int -> Int -> Cell
intToCell size n =
  { col: (n / size) `mod` size
  , row: n / (size * size)
  , value: n `mod` size + 1
  }

generateHypergraph :: Int -> { nbVertices :: Int, edges :: Array (Array Int) }
generateHypergraph squaresize = { nbVertices, edges }
  where
  size = squaresize * squaresize
  nbVertices = size * size * size
  edges = do
    i <- 0 .. (size - 1)
    j <- 0 .. (size - 1)
    [ cellToInt size <<< { row: i, col: j, value: _ } <$> 1 .. size
    , cellToInt size <<< { row: i, col: _, value: j + 1 } <$> 0 .. (size - 1)
    , cellToInt size <<< { row: _, col: i, value: j + 1 } <$> 0 .. (size - 1)
    , cellToInt size
        <<< ( \k ->
              { row: (i `mod` 3) * 3 + k `mod` 3, col: (i / 3) * 3 + k / 3, value: j + 1 }
          )
        <$> 0
        .. (size - 1)
    ]

solve :: Int -> Array Cell -> List (Array Cell)
solve squaresize fixedCells = map (intToCell size) <$> lazyExactCovers nbVertices edges fixedVertices
  where
  size = squaresize * squaresize
  { nbVertices, edges } = generateHypergraph squaresize
  fixedVertices = cellToInt size <$> fixedCells
