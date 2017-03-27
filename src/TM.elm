port module TM exposing (..)

import Html exposing (program, div, span, button, text)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Time exposing (every, millisecond)
import Platform.Sub exposing (batch)
import Json.Decode exposing (Decoder, decodeString, string, int, bool)
import Json.Decode.Pipeline exposing (decode, required)

import TM.TuringMachine exposing (TuringMachine, step, turingMachine)

main: Program Never Model Message
main =
    program
    {
      init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }


init: (Model, Cmd Message)
init =
    (nullModel, Cmd.none)


-- Model


type alias Model =
    {
      tm: TuringMachine Int String
    , blank: String
    , visible_tape: Int
    , running: Bool
    }


nullModel: Model
nullModel =
    {
      tm =
            {
                tape =
                    {
                      left = []
                    , current = "_"
                    , right = []
                    }
            , state = 0
            , transitions = []
            }
    , blank = "_"
    , visible_tape = 5
    , running = False
    }


model: Decoder Model
model =
    decode Model
        |> required "tm" turingMachine
        |> required "blank" string
        |> required "visible_tape" int
        |> required "running" bool


-- Update


type Message =
      DoNothing
    | Step
    | ToggleRunning
    | Tick Time.Time
    | Restart String


update: Message -> Model -> (Model, Cmd Message)
update message m =
    let
        next_tm = step m.tm m.blank
    in
        case message of
            Step -> ({m | tm = next_tm}, Cmd.none)

            ToggleRunning -> ({m | running = not m.running}, Cmd.none)

            Tick _ ->
                if m.running then
                    ({m | tm = next_tm}, Cmd.none)
                else
                    (m, Cmd.none)

            Restart description ->
                let
                  next_m =
                      case decodeString model description of
                          Ok m -> m

                          Err msg -> nullModel
                in
                    (next_m, Cmd.none)

            DoNothing -> (m, Cmd.none)


-- View


view: Model -> Html.Html Message
view model =
    let
        running_text =
            if model.running then
                "||"
            else
                ">>"
    in
        div [class "container"]
            [
             div [class "control"]
                 [
                   button [onClick Step] [ text ">"]
                 , button [onClick ToggleRunning] [ text running_text ]
                 ]
            , TM.TuringMachine.view model.tm model.visible_tape model.blank
            ]


-- Subscriptions

port restart: (String -> msg) -> Sub msg

subscriptions: Model -> Sub Message
subscriptions model =
    batch
    [
      every (500 * millisecond) Tick
    , restart Restart
    ]
