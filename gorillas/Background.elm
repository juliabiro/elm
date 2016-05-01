module Background where

import Html exposing (Html, div, button, toElement)
import Html.Events exposing (onClick)
import Random exposing (Seed, generate, initialSeed, float)
import Color exposing (..)
import Graphics.Collage exposing (..)
import Graphics.Element exposing (..)
import Graphics.Input exposing (button)

type alias Building = {
    height : Float
    , width : Float
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
            generate (float 100 400) model.seed
        in 
            let (width', seed') =
                generate (float 80 100) model.seed
            in 
                {model |
                height = height'
                , width = width'
                , seed = seed'
                }
{--
drawBuilding : Building -> List Svg.Attribute
drawBuilding  building  =
    [ 
      x "100"
    , y (toString (floor-building.height))
    , width (toString building.width)
    , height (toString building.height)
    , style "fill: #ff8833;" 
    ]
--}
drawBuilding : Building -> Form
drawBuilding building =
     rect building.width building.height
        |> filled (rgb 174 238 238)
    

view : Signal.Address Action -> Building -> Element 
view address building =
    collage 500 500
    [
    toForm (Graphics.Input.button (Signal.message address Redraw) "redraw")
    , drawBuilding building
    ]
