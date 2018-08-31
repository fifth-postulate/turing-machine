port module TM exposing (Message(..), Model, init, main, model, nullModel, restart, subscriptions, update, view)

import Browser
import Html exposing (button, div, span)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Json.Decode exposing (Decoder, bool, decodeString, errorToString, int, string, succeed)
import Json.Decode.Pipeline exposing (hardcoded, required)
import Platform.Sub exposing (batch)
import TM.TuringMachine exposing (TuringMachine, step, turingMachine)
import Time exposing (every)


main : Program () Model Message
main =
    Browser.element
        { init = \_ -> init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


init : ( Model, Cmd Message )
init =
    ( nullModel, Cmd.none )



-- Model


type alias Model =
    { tm : TuringMachine Int String
    , blank : String
    , visible_tape : Int
    , running : Bool
    , message : Maybe String
    }


nullModel : Model
nullModel =
    { tm =
        { tape =
            { left = []
            , current = "_"
            , right = []
            }
        , state = 0
        , transitions = []
        , steps_taken = 0
        }
    , blank = "_"
    , visible_tape = 5
    , running = False
    , message = Nothing
    }


model : Decoder Model
model =
    succeed Model
        |> required "tm" turingMachine
        |> required "blank" string
        |> required "visible_tape" int
        |> required "running" bool
        |> hardcoded Nothing



-- Update


type Message
    = DoNothing
    | Step
    | ToggleRunning
    | Tick Time.Posix
    | Restart String
    | RemoveMessage


update : Message -> Model -> ( Model, Cmd Message )
update message aModel =
    let
        next_tm =
            step aModel.tm aModel.blank
    in
    case message of
        Step ->
            ( { aModel | tm = next_tm }, Cmd.none )

        ToggleRunning ->
            ( { aModel | running = not aModel.running }, Cmd.none )

        Tick _ ->
            if aModel.running then
                ( { aModel | tm = next_tm }, Cmd.none )

            else
                ( aModel, Cmd.none )

        Restart description ->
            let
                next_m =
                    case decodeString model description of
                        Ok m ->
                            m

                        Err msg ->
                            { aModel | message = Just (errorToString msg) }
            in
            ( next_m, Cmd.none )

        RemoveMessage ->
            ( { aModel | message = Nothing }, Cmd.none )

        DoNothing ->
            ( aModel, Cmd.none )



-- View


view : Model -> Html.Html Message
view aModel =
    let
        running_text =
            if aModel.running then
                "||"

            else
                ">>"

        text =
            Maybe.withDefault "" aModel.message
    in
    div [ class "container" ]
        [ div [ class "message" ] [ Html.span [] [ Html.text text ] ]
        , div [ class "control" ]
            [ button [ onClick Step ] [ Html.text ">" ]
            , button [ onClick ToggleRunning ] [ Html.text running_text ]
            ]
        , TM.TuringMachine.view aModel.tm aModel.visible_tape aModel.blank
        ]



-- Subscriptions


port restart : (String -> msg) -> Sub msg


subscriptions : Model -> Sub Message
subscriptions aModel =
    batch
        [ every 500 Tick
        , restart Restart
        ]
