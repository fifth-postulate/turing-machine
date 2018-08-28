module TM.Transitions exposing (Transition, Transitions, lookup, transitions)

import Helper exposing (triple, tuple)
import Json.Decode exposing (Decoder, int, list, string, succeed)
import Json.Decode.Pipeline exposing (required)
import List exposing (head, tail)
import TM.Move exposing (Move, move)


type alias Transitions states symbols =
    List (Transition states symbols)


transitions =
    list transition


type alias Transition states symbols =
    { current : ( states, symbols )
    , next : ( states, symbols, Move )
    }


transition =
    succeed Transition
        |> required "current" (tuple int string)
        |> required "next" (triple int string move)


lookup : Transitions states symbols -> ( states, symbols ) -> Maybe ( states, symbols, Move )
lookup ts current =
    case head ts of
        Just t ->
            if t.current == current then
                Just t.next

            else
                case tail ts of
                    Just tail ->
                        lookup tail current

                    Nothing ->
                        Nothing

        Nothing ->
            Nothing
