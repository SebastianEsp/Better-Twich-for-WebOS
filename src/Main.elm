port module Main exposing (..)

import Browser
import Http
import File
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Encode as E
import Json.Decode as D
import Json.Decode.Pipeline as JDP

port streamlink : String -> Cmd msg
port apiresult : String -> Cmd msg
port streamId : (E.Value -> msg) -> Sub msg

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
    streamUrl : String,
    streamId : String
  }

init : () -> (Model, Cmd Msg)
init _ =
  ( 
    {
    title = "Better Twitch for WebOS",
    streamUrl = "",
    streamId = ""
    },
    Cmd.none
  )

getVideo : Model -> Cmd Msg
getVideo model =
  Http.request
    { method = "GET"
    , headers = [Http.header "Client-ID" ("jq2no6sh53vr3258dgzc70ky4fv00u")]
    , url = "https://api.twitch.tv/helix/videos?id=" ++ model.streamUrl
    , body = Http.emptyBody
    , expect = Http.expectString GotVideo
    , timeout = Nothing
    , tracker = Nothing
    }

-- UPDATE

type Msg 
  = Reset
  | LoadStream
  | UpdateUriField String
  | GotVideo (Result Http.Error String)
  | GetVideo

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    Reset ->
      ({ model | title = "Better Twitch for WebOS"}, Cmd.none)
      
    LoadStream ->
      (model, streamlink (model.streamUrl))

    UpdateUriField val ->
      ({ model | streamUrl = val}, Cmd.none)

    GotVideo result ->
      case result of
        Ok url ->
          ({model | title = "SUCCESS"}, apiresult(url))

        Err url ->
          ({model | title = "FAILURE"}, Cmd.none)

    GetVideo ->
      (model, getVideo model)


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
      input[id "uri-field", placeholder "Stream URL", Html.Attributes.value model.streamUrl, onInput UpdateUriField][],
      button[id "load-stream-btn", onClick GetVideo][text "Load"],
      button[id "test", onClick GetVideo][text "test"]
    ]
  ]

type alias RawData =
    { data : List ApiContent
    }

type alias ApiContent =
    { id : String,
      user_name : String
    }

rawDataDecoder : D.Decoder RawData
rawDataDecoder =
    D.succeed RawData
        |> JDP.required "data" (D.list apiContentDecoder)


apiContentDecoder : D.Decoder ApiContent
apiContentDecoder =
    D.succeed ApiContent
        |> JDP.required "id" D.string
        |> JDP.required "user_name" D.string

videoDecoder : D.Decoder String
videoDecoder = 
  D.field "data" D.string
  --D.field "person" (D.field "name" D.string) == D.at ["person","name"] D.string

--        user_id : String,
--      user_name : String,
--      title : String,
--      description : String,
--      created_at : String,
--      published_at : String,
--      url : String,
--      thumbnail_url : String,
--      viewable : String,
--      view_count : String,
--      language : String,
--      type1 : String,
--      duration : String