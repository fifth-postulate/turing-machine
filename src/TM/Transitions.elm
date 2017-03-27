module TM.Transitions exposing (Transitions, Transition, lookup, transitions)

import List exposing (head, tail)
import Json.Decode exposing (Decoder, list, int, string)
import Json.Decode.Pipeline exposing (decode, required)
import Helper exposing (tuple, triple)

import TM.Move exposing (Move, move)


type alias Transitions states symbols =
    List (Transition states symbols)


transitions =
    list transition


type alias Transition states symbols =
    {
      current: (states, symbols)
    , next: (states, symbols, Move)
    }


transition =
    decode Transition
        |> required "current" (tuple int string)
        |> required "next" (triple int string move)


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
