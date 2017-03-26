module Helper exposing (take_with_default)

import List exposing (head, tail)

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
