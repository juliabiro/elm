module Background where
import Html exposing (Html, div, button, toElement, fromElement, text)
import Html.Events exposing (onClick) 
import Random exposing (Seed, generate, initialSeed, float)
import Color exposing (..)
import Graphics.Collage exposing (Form, collage, rect, filled, toForm, moveX, moveY, group)
import Graphics.Element exposing (Element)
import Building exposing (Building, reinit, drawBuilding, setPositionX)

type alias RowOfHouses = List Building
type alias Model = ( RowOfHouses, Seed)


h = 600
w = 1200
floor = -200

init : Model
init =
    generateBuildings 10 ([], initialSeed 0)

generateBuildings : Int -> Model -> Model
generateBuildings size (row, seed) =
    if List.length row < size then 
        let (b, s') = (reinit seed {
            height = 100
            , width = 10
            , color = rgb 255 147 89
            , positionX = -1*w/2
            , positionY = floor
            })
        in 
            generateBuildings size ( b :: row, s')
    else
        (row, seed)

 
type Action = Redraw 


redraw : Action -> Model -> Model
redraw action (row, seed) =
    case action of 
    Redraw ->
        generateBuildings (List.length row) ([], seed)



drawGround : Form 
drawGround = 
    let
        grassy =(h/2 - abs(floor))
    in 
        rect w grassy 
        |> filled (rgb 0 255 150)
        |> moveY (floor - grassy/2) 


setPositions :   RowOfHouses -> RowOfHouses
setPositions row =
    if row == [] then 
        []
    else
        let (rh, rt) =
            (List.head row, List.tail row)
        in
            if rh == Nothing then
                []
            else 
                let rh' = Just rh
                in                 
                    if rt == Nothing then 
                        [setPositionX (-1*w/2) rh']        
                    else
                        let rth = 
                            List.head (setPositions (Just rt))
                     in
                        if rth == Nothing then
                            [setPositionX (-1*w/2) rh']        
                        else
                            let rth'= Just rth 
                            in 
                                (setPositionX (rth'.position+rth'.width) rh') :: rt

drawRowOfHouses :  RowOfHouses -> List Form
drawRowOfHouses row =
    if row == [] then 
        []
    else
        setPositions row
        |> List.map drawBuilding 

view : Signal.Address Action -> Model -> Html 
view address (roh, s) =
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
