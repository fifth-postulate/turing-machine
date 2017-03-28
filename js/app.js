(function(){
    var node = document.getElementById('target');
    var app = Elm.TM.embed(node);

    tm = {
        'successor': {
            "tm": {
                "tape": {
                    "left": [],
                    "current": "I",
                    "right": ["I", "I", "I"]
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
                    "right": ["I", "I"]
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
        },
        'addition': {
            "tm": {
                "tape": {
                    "left": [],
                    "current": "I",
                    "right": ["_", "I", "I"]
                },
                "state": 0,
                "transitions": [
                    { "current": [0, "I"], "next": [0, "I", "R"] },
                    { "current": [0, "_"], "next": [1, "_", "R"] },
                    { "current": [1, "I"], "next": [1, "I", "R"] },
                    { "current": [1, "_"], "next": [2, "_", "L"] },
                    { "current": [2, "I"], "next": [2, "I", "L"] },
                    { "current": [2, "_"], "next": [3, "I", "L"] },
                    { "current": [3, "I"], "next": [3, "I", "L"] },
                    { "current": [3, "_"], "next": [4, "_", "R"] },
                ]
            },
            "blank": "_",
            "visible_tape": 5,
            "running": false
        }
    };
    window.tm_key = 'successor';

    var tm_selector = document.getElementById('turing-machine-key');
    for (var key in tm) {
        var option = document.createElement('option');
        option.textContent = key;
        option.setAttribute('value', key);
        tm_selector.appendChild(option);
    }
    tm_selector.onchange = function(event){
        tm_key = event.target.value;
        app.ports.restart.send(JSON.stringify(tm[tm_key]));
    };

    app.ports.restart.send(JSON.stringify(tm[tm_key]));
})();
