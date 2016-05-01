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
    , position: Float
    , color : Color
} 

setPosition : Float-> Building ->Building
setPosition f b =
    {b|
    position = f}    

reinit : Seed -> Building -> ( Building, Seed)
reinit seed building =
    let (height', seed') =
        generate (float 100 400) seed
    in 
        let (width', seed') =
            generate (float 80 100) seed
        in 
            ({building |
            height = height'
            , width = width'
            }, seed')



drawBuilding : Building  -> Form
drawBuilding building  =
        rect building.width building.height 
        |> filled (building.color)
        |> moveX (building.position+building.width/2)
