module TM.Transitions exposing (Transitions, Transition, lookup)

import List exposing (head, tail)
import TM.Move exposing (Move)


type alias Transitions states symbols =
    List (Transition states symbols)


type alias Transition states symbols =
    {
      current: (states, symbols)
    , next: (states, symbols, Move)
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
