import Background exposing (init, redraw, view)
import Graphics.Element exposing (..)
import Window

main :  Signal Element
main =
    view Signal.map init

