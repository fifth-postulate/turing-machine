module TM exposing (..)

import Html exposing (program, div, span, button, text)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Time exposing (every, millisecond)
import List exposing (head, tail, map)

import TM.Transitions exposing (Transitions, Transition, lookup)
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


-- Helpers


take_with_default: Int -> a -> List a -> List a
take_with_default n default list =
    if n == 0 then
        []
    else
        case head list of
            Just v ->
                case tail list of
                    Just vs ->
                        v :: take_with_default (n-1) default vs

                    Nothing ->
                        v :: take_with_default (n-1) default []

            Nothing ->
                default :: take_with_default (n-1) default []


-- Model


type alias Model =
    {
      tm: TuringMachine Int String
    , blank: String
    , visible_tape: Int
    , running: Bool
    }


type alias TuringMachine states symbols =
    {
      tape: Tape symbols
    , state: states
    , transitions: Transitions states symbols
    }


type alias Tape symbols =
    {
      left: List symbols
    , current: symbols
    , right: List symbols
    }


step: TuringMachine states symbols -> symbols -> TuringMachine states symbols
step tm blank =
    let
        current =
            (tm.state, tm.tape.current)

        next =
            lookup tm.transitions current
    in
        case next of
            Just (q, s, m) ->
                let
                    current_tape =
                        tm.tape

                    tape =
                        shift { current_tape | current = s } blank m
                in
                    { tm | state = q, tape = tape }

            Nothing ->
                tm


shift: Tape symbols -> symbols -> Move -> Tape symbols
shift tape blank move =
    case move of
        Left ->
            let
                left =
                    case tail tape.left of
                        Just ts -> ts

                        Nothing -> []

                current =
                    case head tape.left of
                        Just t -> t

                        Nothing -> blank

                right =
                    tape.current :: tape.right

            in
            {
              left = left
            , current = current
            , right = right
            }

        Right ->
            let
                left =
                    tape.current :: tape.left

                current =
                    case head tape.right of
                        Just t -> t

                        Nothing -> blank

                right =
                    case tail tape.right of
                        Just ts -> ts

                        Nothing -> []
            in
            {
              left = left
            , current = current
            , right = right
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
