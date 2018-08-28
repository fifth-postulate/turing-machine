module Helper exposing (take_with_default, triple, tuple)

import Json.Decode as Decode exposing (Decoder, andThen, index, int, map, string, succeed)
import List exposing (head, tail)


take_with_default : Int -> a -> List a -> List a
take_with_default n default list =
    if n == 0 then
        []

    else
        case head list of
            Just v ->
                case tail list of
                    Just vs ->
                        v :: take_with_default (n - 1) default vs

                    Nothing ->
                        v :: take_with_default (n - 1) default []

            Nothing ->
                default :: take_with_default (n - 1) default []


tuple : Decoder a -> Decoder b -> Decoder ( a, b )
tuple first second =
    Decode.map2 (\a b -> ( a, b ))
        (index 0 first)
        (index 1 second)


triple : Decoder a -> Decoder b -> Decoder c -> Decoder ( a, b, c )
triple first second third =
    Decode.map3 (\a b c -> ( a, b, c ))
        (index 0 first)
        (index 1 second)
        (index 2 third)


apply : Decoder (a -> b) -> Decoder a -> Decoder b
apply f aDecoder =
    f |> andThen (\g -> map g aDecoder)
