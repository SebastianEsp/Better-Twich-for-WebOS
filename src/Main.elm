port module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Encode as E

port streamlink : String -> Cmd msg

--main =
--  Browser.element { init = init, update = update, view = view }

main =
  Browser.element
    { init = init,
      update = update,
      subscriptions = subscriptions,
      view = view
    }

-- MODEL

type alias Model = 
  {
    title : String,
    streamUrl : String
  }

init : () -> (Model, Cmd Msg)
init _ =
  ( 
    {
    title = "Better Twitch for WebOS",
    streamUrl = ""
    },
    Cmd.none
  )



-- UPDATE

type Msg 
  = Reset
  | LoadStream
  | UpdateUriField String

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    Reset ->
      ({ model | title = "Better Twitch for WebOS"}, Cmd.none)
    LoadStream ->
      (model, streamlink (model.streamUrl))
    UpdateUriField val ->
      ({ model | streamUrl = val}, Cmd.none)


-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none

-- VIEW

view : Model -> Html Msg
view model =
  div[class "container"]
  [
    h1[class "child"]
    [
      text model.title
    ],
    video[id "video", controls True, autoplay True][],
    span[]
    [
      input[id "uri-field", placeholder "Stream URL", value model.streamUrl, onInput UpdateUriField][],
      button[id "load-stream-btn", onClick LoadStream][text "Load"]
    ]
  ]