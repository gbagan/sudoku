module Sudoku.View where

import Prelude
import Data.Array ((..), mapWithIndex)
import Data.Int as Int
import Data.Maybe (Maybe(..))
import Pha.Html (Html)
import Pha.Html as H
import Pha.Html.Events as E
import Sudoku.Model (Model, Msg(..))

view :: Model -> Html Msg
view model = 
    H.div []
    [   H.h1 [] [H.text "Sudoku"]
    ,   H.button [E.onClick \_ -> Solve] [H.text "Solve"]
    ,   H.button [E.onClick \_ -> ClearSolution] [H.text "Clear"]
    ,   grid model
    ]

grid :: Model -> Html Msg
grid {squaresize, cells, isConsoleShowed, selectedCell} =
    let size = squaresize * squaresize in
    H.div [H.class_ $ "sudoku-grid squaresize-" <> show squaresize] $ (
        cells # mapWithIndex \i {value, fixed} ->
                let row = i / size
                    col = i `mod` size
                in
                H.div
                [   H.class_ $ "sudoku-cell"
                ,   H.class' "fixed" fixed
                ,   H.class' "selected" $ selectedCell == Just i
                ,   H.class' "hborder" $ col `mod` squaresize == 0 && col /= 0
                ,   H.class' "vborder" $ row `mod` squaresize == 0 && row /= 0
                ,   H.style "height" $ show (100.0 / Int.toNumber size) <> "%" 
                ,   H.style "width" $ show (100.0 / Int.toNumber size) <> "%"
                ,   H.style "left" $ show (Int.toNumber col * 100.0 / Int.toNumber size) <> "%" 
                ,   H.style "top" $ show (Int.toNumber row * 100.0 / Int.toNumber size) <> "%" 
                ,   E.onClick \_ -> OpenConsole i
                ] [H.span [] [H.text $ if value == 0 then "" else show value]]
        ) <> [H.when isConsoleShowed \_ -> console squaresize]

console :: Int -> Html Msg
console cols =
    H.div [H.class_ "sudoku-console-container"]
    [   H.div [H.class_ "sudoku-console"] $
        (1 .. (cols * cols)) <> [0] <#> \val ->
            H.div
            [   H.class_ $ "sudoku-console-num"
            ,   H.style "width" $ if val == 0 then "100%" else show (100.0 / Int.toNumber cols) <> "%"
            ,   E.onClick \_ -> FillCell val
            ]
            [   H.text $ if val == 0 then "X" else show val
            ]
    ]
