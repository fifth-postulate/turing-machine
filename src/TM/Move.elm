module TM.Move exposing (Move(..), move)

import Json.Decode exposing (Decoder, map, string)


type Move
    = Left
    | Right


move : Decoder Move
move =
    let
        aMove w =
            case w of
                "L" ->
                    Left

                _ ->
                    Right
    in
    map aMove string
