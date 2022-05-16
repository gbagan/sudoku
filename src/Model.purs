module Sudoku.Model where

import Prelude
import Data.Array ((..), (!!), filter, mapWithIndex, updateAtIndices)
import Data.Tuple.Nested ((/\))
import Data.Maybe (Maybe(..))
import Data.List.Lazy as List
import Sudoku.Solver (solve)

type ModelCell
  = { value :: Int, fixed :: Boolean }

type Solution
  = Array { row :: Int, col :: Int, value :: Int }

type Model
  = { squaresize :: Int
    , cells :: Array ModelCell
    , isConsoleShowed :: Boolean
    , selectedCell :: Maybe Int
    }

init :: Model
init =
  { squaresize: 3
  , cells: 0 .. 80 <#> \_ -> { value: 0, fixed: false }
  , isConsoleShowed: false
  , selectedCell: Nothing
  }

addSolution :: Int -> Solution -> Array ModelCell -> Array ModelCell
addSolution squaresize solution =
  updateAtIndices
    (solution <#> \{ row, col, value } -> (row * squaresize * squaresize + col) /\ { fixed: false, value })

clearSolution :: Array ModelCell -> Array ModelCell
clearSolution = map \cell -> if cell.fixed then cell else { fixed: false, value: 0 }

data Msg
  = FillCell Int
  | OpenConsole Int
  -- | ShowSolution (Maybe Solution)
  | Solve
  | ClearSolution

update :: Msg -> Model -> Model
update msg model = case msg of
  FillCell value -> model { cells = cells, isConsoleShowed = false }
    where
    cells = case model.selectedCell of
      Nothing -> model.cells
      Just i -> model.cells # updateAtIndices [ i /\ { value, fixed: value > 0 } ]
  OpenConsole cell -> model { isConsoleShowed = true, selectedCell = Just cell }
  Solve ->
    let
      { cells, squaresize } = model

      size = squaresize * squaresize

      fixedCells =
        cells
          # mapWithIndex
              ( \i { value } ->
                  { col: i `mod` size, row: i / size, value }
              )
          # filter \{ row, col, value } ->
              value > 0 && (_.fixed <$> cells !! (row * size + col)) == Just true
    in
      case List.head $ solve squaresize fixedCells of
        Nothing -> model
        Just solution -> model { cells = addSolution squaresize solution cells }
  ClearSolution -> model { cells = clearSolution model.cells }
