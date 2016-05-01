module Background where
import Html exposing (Html, div, button, toElement, fromElement, text)
import Html.Events exposing (onClick) 
import Random exposing (Seed, generate, initialSeed, float)
import Color exposing (..)
import Graphics.Collage exposing (Form, collage, rect, filled, toForm, moveX, moveY, group)
import Graphics.Element exposing (Element)
import Building exposing (Building, reinit, drawBuilding, setPosition)

type alias RowOfHouses = List Building
type alias Model = (RowOfHouses, Seed)


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
        List.map (reinit seed) row 

putOnFloor :  Form -> Form
putOnFloor form =
    form 
        |> moveY (floor + form.height)        


drawGround : Form 
drawGround = 
    let
        grassy =(h/2 - abs(floor))
    in 
        rect w grassy 
        |> filled (rgb 0 255 150)
        |> moveY (floor - grassy/2) 


setPositions : RowOfHouses -> RowOfHouses
setPositions row =
    let (rh, rt) =
        (List.head row, setPositions List.tail row)
    in 
        (setPosition (List.head rt.position - rh.width) rh)  :: rt

drawRowOfHouses : RowOfHouses -> List Form
drawRowOfHouses row =
    let 
        row' = List.map (setPosition w/2) row
    in 
        setPositions row'
        |> List.map drawBuilding 
        |> List.map putOnFloor 

view : Signal.Address Action -> RowOfHouses -> Html 
view address model =
    div []
    [
    button [ (onClick  address Redraw ) ] [text "redraw"]
    , Html.fromElement(
        collage w h     
        [
        drawGround :: drawRowOfHouses model
        |> group
        ]
        )
    ]
