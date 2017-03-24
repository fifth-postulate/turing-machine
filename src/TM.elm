module TM exposing (..)

import Html exposing (text)
import List exposing (head, tail)

main: Html.Html msg
main =
    text "Hello, World!"


-- Model


type alias Model =
    {
      tm: TuringMachine Int String
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


