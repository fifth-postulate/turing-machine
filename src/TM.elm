module TM exposing (..)

import Html exposing (program, div, span, button, text)
import Html.Attributes exposing (class)
import List exposing (head, tail, map)

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
     , running = False
     }
    , Cmd.none
    )

-- Model


type alias Model =
    {
      tm: TuringMachine Int String
    , blank: String
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


type alias Transitions states symbols =
    List (Transition states symbols)


type alias Transition states symbols =
    {
      current: (states, symbols)
    , next: (states, symbols, Move)
    }


type Move =
      Left
    | Right


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


lookup: Transitions states symbols -> (states, symbols) -> Maybe (states, symbols, Move)
lookup transitions current =
    case head transitions of
        Just transition ->
            if transition.current == current then
                Just transition.next
            else
                case tail transitions of
                    Just ts -> lookup ts current

                    Nothing -> Nothing

        Nothing -> Nothing


-- Update


type Message =
    DoNothing


update: Message -> Model -> (Model, Cmd Message)
update message model =
    (model, Cmd.none)


-- View


view: Model -> Html.Html Message
view model =
    let
        make_cell = \s -> span [class "cell"] [text s]

        left_tape = map make_cell model.tm.tape.left

        right_tape = map make_cell model.tm.tape.right
    in
        div [class "turing-machine"]
            [
              div [class "control"]
                  [
                    button [] [ text ">"]
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
    Sub.none
