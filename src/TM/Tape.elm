module TM.Tape exposing (Tape, shift, tape)

import Json.Decode exposing (Decoder, list, string, succeed)
import Json.Decode.Pipeline exposing (required)
import List exposing (head, tail)
import TM.Move exposing (Move(..))


type alias Tape symbols =
    { left : List symbols
    , current : symbols
    , right : List symbols
    }


tape : Decoder (Tape String)
tape =
    succeed Tape
        |> required "left" (list string)
        |> required "current" string
        |> required "right" (list string)


shift : Tape symbols -> symbols -> Move -> Tape symbols
shift aTape blank move =
    case move of
        Left ->
            let
                left =
                    case tail aTape.left of
                        Just ts ->
                            ts

                        Nothing ->
                            []

                current =
                    case head aTape.left of
                        Just t ->
                            t

                        Nothing ->
                            blank

                right =
                    aTape.current :: aTape.right
            in
            { left = left
            , current = current
            , right = right
            }

        Right ->
            let
                left =
                    aTape.current :: aTape.left

                current =
                    case head aTape.right of
                        Just t ->
                            t

                        Nothing ->
                            blank

                right =
                    case tail aTape.right of
                        Just ts ->
                            ts

                        Nothing ->
                            []
            in
            { left = left
            , current = current
            , right = right
            }
