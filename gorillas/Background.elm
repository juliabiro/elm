module Background where

import Html exposing (Html, div, button, toElement, fromElement, text)
import Html.Events exposing (onClick) 
import Random exposing (Seed, generate, initialSeed, float)
import Color exposing (..)
import Graphics.Collage exposing (collage, rect, filled)
import Graphics.Element exposing (Element)

type alias Building = {
    height : Float
    , width : Float
    , seed : Seed
    , color : Color
} 


init :  Building
init  =
    {
    height = 100
    , width = 10
    , seed = initialSeed 0
    , color = rgb 255 147 89
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

drawBuilding : Building -> Element
drawBuilding building =
    collage 500 500 
    [
     rect building.width building.height
        |> filled (building.color)
    ]

view : Signal.Address Action -> Building -> Html 
view address building =
    div []
    [
    button [ (onClick  address Redraw ) ] [text "redraw"]
    , Html.fromElement(drawBuilding building)
    ]
