module TuringMachine (TuringMachine, step)


type alias TuringMachine states symbols =
    {
      tape: Tape symbols
    , state: states
    , transitions: Transitions states symbols
    }


step: TuringMachine states symbols -> symbols -> TuringMachine states symbols
step tm blank =
    let
        current =
            (tm.state, tm.tape.current)

        next =
            lookup tm.transitions current
    in
        case next of
            Just (q, s, m) ->
                let
                    current_tape =
                        tm.tape

                    tape =
                        shift { current_tape | current = s } blank m
                in
                    { tm | state = q, tape = tape }

            Nothing ->
                tm
