module TM exposing (..)

import Html exposing (program, div, span, button, text)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Time exposing (every, millisecond)
import List exposing (head, tail, map)

import TM.TuringMachine exposing (TuringMachine, step)
import TM.Tape exposing (Tape, shift)
import TM.Transitions exposing (Transitions, Transition, lookup)
import TM.Move exposing (Move(..))
import Helper exposing (take_with_default)


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
    (
     {
       tm =
           {
             tape =
                 {
                   left = []
                 , current = "I"
                 , right = ["I", "I", "I"]
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
    , Cmd.none
    )


-- Model


type alias Model =
    {
      tm: TuringMachine Int String
    , blank: String
    , visible_tape: Int
    , running: Bool
    }

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

        make_cell = \s -> span [class "cell"] [text s]

        left_tape =
             map make_cell (take_with_default model.visible_tape model.blank model.tm.tape.left)

        right_tape =
            map make_cell (take_with_default model.visible_tape model.blank model.tm.tape.right)
    in
        div [class "turing-machine"]
            [
              div [class "control"]
                  [
                    button [onClick Step] [ text ">"]
                  , button [onClick ToggleRunning] [ text running_text ]
                  ]
            , div [class "tape"]
                 [
                   div [class "left"] left_tape
                 , div [class "current"]
                     [
                      make_cell model.tm.tape.current
                     ]
                 , div [class "right"] right_tape
                 ]
            , div [class "state"]
                [
                 span [] [ text (toString model.tm.state)]
                ]
            ]


-- Subscriptions


subscriptions: Model -> Sub Message
subscriptions model =
    every (500 * millisecond) Tick
