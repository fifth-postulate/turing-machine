module Helper exposing (take_with_default, tuple, triple)

import List exposing (head, tail)
import Json.Decode exposing (Decoder, succeed, andThen, map, index, int, string)

take_with_default: Int -> a -> List a -> List a
take_with_default n default list =
    if n == 0 then
        []
    else
        case head list of
            Just v ->
                case tail list of
                    Just vs ->
                        v :: take_with_default (n-1) default vs

                    Nothing ->
                        v :: take_with_default (n-1) default []

            Nothing ->
                default :: take_with_default (n-1) default []


tuple: Decoder a -> Decoder b -> Decoder (a,b)
tuple a b =
    succeed (,)
        |: (index 0 a)
        |: (index 1 b)


triple: Decoder a -> Decoder b -> Decoder c -> Decoder (a,b,c)
triple a b c =
    succeed (,,)
        |: (index 0 a)
        |: (index 1 b)
        |: (index 2 c)


(|:): Decoder (a -> b) -> Decoder a -> Decoder b
(|:) =
    apply


apply: Decoder (a -> b) -> Decoder a -> Decoder b
apply f aDecoder =
    f |> andThen (\g -> map g aDecoder)
