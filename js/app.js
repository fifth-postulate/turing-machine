(function(){
    tm = {
        'successor': {
            "tm": {
                "tape": {
                    "left": [],
                    "current": "I",
                    "right": ["I", "I", "I", "I"]
                },
                "state": 0,
                "transitions": [
                    { "current": [0, "I"], "next": [0, "I", "R"] },
                    { "current": [0, "_"], "next": [1, "I", "L"] },
                    { "current": [1, "I"], "next": [1, "I", "L"] },
                    { "current": [1, "_"], "next": [2, "_", "R"] }
                ]
            },
            "blank": "_",
            "visible_tape": 5,
            "running": false
        },
        'continuous successor': {
            "tm": {
                "tape": {
                    "left": [],
                    "current": "I",
                    "right": ["I", "I", "I", "I"]
                },
                "state": 0,
                "transitions": [
                    { "current": [0, "I"], "next": [0, "I", "R"] },
                    { "current": [0, "_"], "next": [1, "I", "L"] },
                    { "current": [1, "I"], "next": [1, "I", "L"] },
                    { "current": [1, "_"], "next": [0, "_", "R"] }
                ]
            },
            "blank": "_",
            "visible_tape": 5,
            "running": false
        }

    };
    var tm_key = 'successor';

    var node = document.getElementById('target');
    var app = Elm.TM.embed(node);
    app.ports.restart.send(JSON.stringify(tm[tm_key]));
})();
