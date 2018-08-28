module TM.TuringMachine exposing (TuringMachine, step, turingMachine, view)

import Helper exposing (take_with_default)
import Html exposing (button, div, span, text)
import Html.Attributes exposing (class)
import Json.Decode exposing (Decoder, int, succeed)
import Json.Decode.Pipeline exposing (required)
import List exposing (map)
import TM.Tape exposing (Tape, shift, tape)
import TM.Transitions exposing (Transitions, lookup, transitions)


type alias TuringMachine states symbols =
    { tape : Tape symbols
    , state : states
    , transitions : Transitions states symbols
    }


turingMachine : Decoder (TuringMachine Int String)
turingMachine =
    succeed TuringMachine
        |> required "tape" tape
        |> required "state" int
        |> required "transitions" transitions


step : TuringMachine states symbols -> symbols -> TuringMachine states symbols
step tm blank =
    let
        current =
            ( tm.state, tm.tape.current )

        next =
            lookup tm.transitions current
    in
    case next of
        Just ( q, s, m ) ->
            let
                current_tape =
                    tm.tape

                tape =
                    shift { current_tape | current = s } blank m
            in
            { tm | state = q, tape = tape }

        Nothing ->
            tm


view : TuringMachine Int String -> Int -> String -> Html.Html msg
view tm visible_tape blank =
    let
        make_cell =
            \s -> span [ class "cell" ] [ text s ]

        left_tape =
            map make_cell (take_with_default visible_tape blank tm.tape.left)

        right_tape =
            map make_cell (take_with_default visible_tape blank tm.tape.right)
    in
    div [ class "turing-machine" ]
        [ div [ class "tape" ]
            [ div [ class "left" ] left_tape
            , div [ class "current" ]
                [ make_cell tm.tape.current
                ]
            , div [ class "right" ] right_tape
            ]
        , div [ class "state" ]
            [ span [] [ text (String.fromInt tm.state) ]
            ]
        ]
