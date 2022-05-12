module Sudoku.Model where
import Prelude
import Data.Array ((..), (!!), filter, mapWithIndex, updateAtIndices)
import Data.Tuple.Nested ((/\))
import Data.Maybe (Maybe(..))
import Data.List.Lazy as List
import Sudoku.Solver (solve)

type Model =
    {   squaresize :: Int   
    ,   cells :: Array { value :: Int, fixed :: Boolean}
    ,   isConsoleShowed :: Boolean
    ,   selectedCell :: Maybe Int
    }

init :: Model
init =
    {   squaresize: 3
    ,   cells: 0..80 <#> \_ -> { value: 0, fixed: false }
    ,   isConsoleShowed: false
    ,   selectedCell: Nothing
    }

data Msg =
      FillCell Int
    | OpenConsole Int
    -- | ShowSolution (Maybe Solution)
    | Solve


update :: Msg -> Model -> Model
update msg model = case msg of
    FillCell value ->
        model { cells = cells,isConsoleShowed = false }
        where
        cells = case model.selectedCell of
            Nothing -> model.cells
            Just i -> model.cells # updateAtIndices [i /\ {value, fixed: value > 0 }]
        

    OpenConsole cell -> model { isConsoleShowed = true, selectedCell = Just cell }
    Solve ->
            let { cells, squaresize } = model
                size = squaresize * squaresize
                fixedCells = cells # mapWithIndex (\i {value} ->
                                        {col: i `mod` size, row: i / size, value}
                                   ) # filter \{row, col, value} ->
                                        value > 0 && (_.fixed <$> cells !! (row * size + col)) == Just true
            in
            case List.head $ solve squaresize fixedCells of
                Nothing -> model
                Just solution -> model
