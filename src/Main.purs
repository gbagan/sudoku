module Main where

import Prelude
import Effect (Effect)
import Pha.App (sandbox)
import Sudoku.Model (init, update)
import Sudoku.View (view)

main :: Effect Unit
main = sandbox {init, view, update, selector: "#root"} 