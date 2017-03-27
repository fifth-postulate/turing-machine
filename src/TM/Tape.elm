module TM.Tape exposing (Tape, shift, tape)

import List exposing (head, tail)
import Json.Decode exposing (Decoder, list, string)
import Json.Decode.Pipeline exposing (decode, required)

import TM.Move exposing (Move(..))

type alias Tape symbols =
    {
      left: List symbols
    , current: symbols
    , right: List symbols
    }


tape: Decoder (Tape String)
tape =
    decode Tape
        |> required "left" (list string)
        |> required "current" string
        |> required "right" (list string)


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


