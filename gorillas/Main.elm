import Background exposing (init, redraw, view)
import Graphics.Element exposing (..)
import StartApp.Simple exposing (start)

main =
    start {model= init, view =  view, update = redraw}
