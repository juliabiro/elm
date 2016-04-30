import Background exposing (init, redraw, view)
import StartApp.Simple exposing (start)

main = start {
    model = init
    , update = redraw
    , view= view
    }
