module Sudoku.Solver where

import Prelude
import Data.List.Lazy (List)
import Data.Array ((..))
import ExactCover (lazyExactCovers)

type Cell = { row :: Int, col :: Int, value :: Int}

square :: Int -> Int -> Int -> Int
square squaresize i j = i - i `mod` squaresize + j / squaresize

cellToInt :: Int -> Cell -> Int
cellToInt squaresize {row, col, value} = row * size * size + col * size + value - 1
    where
    size = squaresize * squaresize

intToCell :: Int -> Int -> Cell
intToCell squaresize n =
    {   col: (n / size) `mod` size
    ,   row: n / size2
    ,   value: n `mod` size + 1
    }
    where
    size = squaresize * squaresize
    size2 = size * size

generateHypergraph :: Int -> {nbVertices :: Int, edges :: Array(Array Int)}
generateHypergraph squaresize = {nbVertices, edges}
    where
    size = squaresize * squaresize
    nbVertices = size * size * size
    edges = do
        i <- 0..(size-1)
        j <- 0..(size-1)
        [   cellToInt squaresize <<< {row: i, col: j, value: _} <$> 1..size
        ,   cellToInt squaresize <<< {row: i, col: _, value: j+1} <$> 0..(size-1)
        ,   cellToInt squaresize <<< {row: _, col: i, value: j+1} <$> 0..(size-1)
        ]

solve :: Int -> Array Cell -> List (Array Cell)
solve squaresize fixedCells = map (intToCell squaresize) <$> lazyExactCovers nbVertices edges 
    where
    size = squaresize * squaresize
    size2 = size * size
    size3 = size * size * size
    {nbVertices, edges} = generateHypergraph squaresize
    
    