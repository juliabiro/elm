module Background where
import Html exposing (Html, div, button, toElement, fromElement, text)
import Html.Events exposing (onClick) 
import Random exposing (Seed, generate, initialSeed, float)
import Color exposing (..)
import Graphics.Collage exposing (Form, collage, rect, filled, toForm, moveX, moveY, group)
import Graphics.Element exposing (Element)
import Building exposing (Building, reinit, drawBuilding, setPositionX)

type alias RowOfHouses = List Building
type alias Model = ( RowOfHouses, Seed, Float)


h = 600
w = 1200
floor = -200

init : Model
init =
    generateBuildings w ([], initialSeed 0, -1*w/2)

generateBuildings : Float -> (Model)-> Model
generateBuildings size (row, seed, float) =
    let s = 
        List.sum (List.map .width row)
    in        
        if s < size then 
            let (b, s', f') = (reinit (seed, float) {
                height = 100
                , width = 10
                , color = rgb 255 147 89
                , positionX = -1*w/2
                , positionY = floor
                })
            in 
                generateBuildings size ( b :: row, s', f')
        else
            (row, seed, -1*w/2)

 
type Action = Redraw 


redraw : Action -> Model -> Model
redraw action (row, seed, float) =
    case action of 
    Redraw ->
        generateBuildings w ([], seed, float)



drawGround : Form 
drawGround = 
    let
        grassy =(h/2 - abs(floor))
    in 
        rect w grassy 
        |> filled (rgb 0 255 150)
        |> moveY (floor - grassy/2) 

drawRowOfHouses :  RowOfHouses -> List Form
drawRowOfHouses row =
    row 
    |> List.map drawBuilding

view : Signal.Address Action -> Model -> Html 
view address (roh, s, f) =
    div []
    [
    button [ (onClick  address Redraw ) ] [text "redraw"]
    , Html.fromElement(
        collage w h     
        [
        drawGround :: drawRowOfHouses roh
        |> group
        ]
        )
    ]
