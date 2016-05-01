module Background where

import Html exposing (Html, div, button, toElement, fromElement, text)
import Html.Events exposing (onClick) 
import Random exposing (Seed, generate, initialSeed, float)
import Color exposing (..)
import Graphics.Collage exposing (Form, collage, rect, filled, toForm, moveX, moveY)
import Graphics.Element exposing (Element)

type alias Building = {
    height : Float
    , width : Float
    , seed : Seed
    , color : Color
} 

h= 600
w= 1200

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

drawBuilding : Building -> Int -> Form
drawBuilding building x =
     rect building.width building.height
        |> filled (building.color)
        |> moveX (-1*w/2 + building.width/2)
        |> moveY (building.height/2)

view : Signal.Address Action -> Building -> Html 
view address building =
    div []
    [
    button [ (onClick  address Redraw ) ] [text "redraw"]
    , Html.fromElement(
        collage w h     
        [(drawBuilding building 0)]
    )
    ]
