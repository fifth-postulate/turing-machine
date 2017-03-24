module TM exposing (..)

import Html exposing (text)

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
    , head: symbols
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
