port module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Encode as E

main =
  Browser.sandbox { init = init, update = update, view = view }

-- MODEL

type alias Model = 
  {
    test : String
  }

init : Model
init = 
  {
    test = "test"
  }


-- UPDATE

type Msg 
  = Reset

update : Msg -> Model -> Model
update msg model =
  case msg of
    Reset ->
      { model | test = "test"}


-- VIEW

view : Model -> Html Msg
view model =
  div[]
  [
    h1[]
    [
      text model.test
    ],
    video[id "video", controls True][]
  ]