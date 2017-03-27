module TM exposing (..)

import Html exposing (program, div, span, button, text)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Time exposing (every, millisecond)
import Json.Decode exposing (Decoder, decodeString, string, int, bool)
import Json.Decode.Pipeline exposing (decode, required)

import TM.TuringMachine exposing (TuringMachine, step, turingMachine)
import TM.Move exposing (Move(..))

main: Program Never Model Message
main =
    program
    {
      init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }

json: String
json =
    """
{
    "tm": {
        "tape": {
            "left": [],
            "current": "I",
            "right": ["I", "I", "I", "I"]
        },
        "state": 0,
        "transitions": [
            { "current": [0, "I"], "next": [0, "I", "R"] },
            { "current": [0, "_"], "next": [1, "I", "L"] },
            { "current": [1, "I"], "next": [1, "I", "L"] },
            { "current": [1, "_"], "next": [2, "_", "R"] }
        ]
    },
    "blank": "_",
    "visible_tape": 5,
    "running": false
}
"""


init: (Model, Cmd Message)
init =
    let
        m =
            case decodeString model json of
                Ok m -> m

                Err msg ->
                    {
                        tm =
                            {
                              tape =
                                  {
                                    left = []
                                  , current = msg
                                  , right = ["I"]
                                  }
                            , state = 0
                            , transitions =
                                  [
                                    { current = (0, "I"), next = (0, "I", Right) }
                                  , { current = (0, "_"), next = (1, "I", Left) }
                                  , { current = (1, "I"), next = (1, "I", Left) }
                                  , { current = (1, "_"), next = (2, "_", Right) }
                                  ]
                            }
                    , blank = "_"
                    , visible_tape = 5
                    , running = False
                    }
    in
        (m, Cmd.none)


-- Model


type alias Model =
    {
      tm: TuringMachine Int String
    , blank: String
    , visible_tape: Int
    , running: Bool
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


update: Message -> Model -> (Model, Cmd Message)
update message model =
    let
        next_tm = step model.tm model.blank
    in
        case message of
            Step -> ({model | tm = next_tm}, Cmd.none)

            ToggleRunning -> ({model | running = not model.running}, Cmd.none)

            Tick _ ->
                if model.running then
                    ({model | tm = next_tm}, Cmd.none)
                else
                    (model, Cmd.none)

            DoNothing -> (model, Cmd.none)


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


subscriptions: Model -> Sub Message
subscriptions model =
    every (500 * millisecond) Tick
