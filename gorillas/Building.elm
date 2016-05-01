module Building where

import Html exposing (Html, div, button, toElement, fromElement, text)
import Html.Events exposing (onClick) 
import Random exposing (Seed, generate, initialSeed, float)
import Color exposing (..)
import Graphics.Collage exposing (Form, collage, rect, filled, toForm, moveX, moveY)
import Graphics.Element exposing (Element)

type alias Building = {
    height : Float
    , width : Float
    , positionX: Float
    , positionY: Float
    , color : Color
} 

setPositionX : Float-> Building ->Building
setPositionX f b =
    {b|
    positionX = f}    

reinit : (Seed, Float) -> Building -> ( Building, Seed, Float)
reinit (seed, f) building =
    let (height', seed') =
        generate (float 100 400) seed
    in 
        let (width', seed') =
            generate (float 80 150) seed
        in 
            ({building |
            height = height'
            , width = width'
            , positionX = f
            }, seed', f+width')

drawBuilding : Building  -> Form
drawBuilding building  =
        rect building.width building.height 
        |> filled (building.color)
        |> moveX (building.positionX+building.width/2)
        |> moveY (building.positionY+building.height/2)
