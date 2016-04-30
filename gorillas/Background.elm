module Background where

import Html exposing (Html, div, button)
import Random exposing (Seed, generate, initialSeed, int)
import Svg exposing (svg, rect, text, text')
import Svg.Events exposing (onClick)
import Svg.Attributes exposing (..)

type alias Building = {
    height : Int
    , width : Int
    , seed : Seed
} 

init :  Building
init  =
    {
    height = 100
    , width = 10
    , seed = initialSeed 0
    }
    
type Action = Redraw 

redraw : Action -> Building ->Building
redraw action model =
    case action of 
    Redraw ->
        let (height', seed') =
            generate (int 0 100) model.seed
        in 
            let (width', seed') =
                generate (int 0 10) model.seed
            in 
                {model |
                height = height'
                , width = width'
                , seed = seed'
                }

view : Signal.Address Action -> Building -> Html
view address model =
   div []
    [ 
    button [onClick (Signal.message address Redraw) ][text "redraw"]
    , svg 
        [ width "500", height "500", viewBox "0 0 500 500"]
        [ rect 
            [ x "100"
            , y "100" 
            , width (toString model.width)
            , height (toString model.height)
            , style "fill: #ff0000;"
            ] 
            []
        ]
    ]

