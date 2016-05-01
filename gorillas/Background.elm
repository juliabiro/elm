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
            generate (int 100 400) model.seed
        in 
            let (width', seed') =
                generate (int 80 100) model.seed
            in 
                {model |
                height = height'
                , width = width'
                , seed = seed'
                }

floor = 500

drawBuilding : Building -> List Svg.Attribute
drawBuilding  building  =
    [ 
      x "100"
    , y (toString (floor-building.height))
    , width (toString building.width)
    , height (toString building.height)
    , style "fill: #ff8833;" 
    ]

view : Signal.Address Action -> Building -> Html
view address building =
   div []
    [ 
    button [onClick (Signal.message address Redraw) ][text "redraw"]
    , svg 
        [ width "500", height "500", viewBox "0 0 500 500"]
        [ rect (drawBuilding building )
            []
        ]
    ]

