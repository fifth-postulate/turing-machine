(function(){
    var node = document.getElementById('target');
    var app = Elm.TM.init({
        node: node
    });

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
                    { "current": [2, "I"], "next": [3, "_", "L"] },
                    { "current": [3, "I"], "next": [3, "I", "L"] },
                    { "current": [3, "_"], "next": [4, "I", "L"] },
                    { "current": [4, "I"], "next": [4, "I", "L"] },
                    { "current": [4, "_"], "next": [5, "_", "R"] },
                ]
            },
            "blank": "_",
            "visible_tape": 5,
            "running": false
        },
        'copy': {
            "tm": {
                "tape": {
                    "left": [],
                    "current": "I",
                    "right": ["I", "I"]
                },
                "state": 0,
                "transitions": [
                    { "current": [0, "I"], "next": [1, "C", "R"] },
                    { "current": [0, "_"], "next": [5, "_", "L"] },
                    { "current": [1, "I"], "next": [1, "I", "R"] },
                    { "current": [1, "_"], "next": [2, "_", "R"] },
                    { "current": [2, "I"], "next": [2, "I", "R"] },
                    { "current": [2, "_"], "next": [3, "I", "L"] },
                    { "current": [3, "I"], "next": [3, "I", "L"] },
                    { "current": [3, "_"], "next": [4, "_", "L"] },
                    { "current": [4, "I"], "next": [4, "I", "L"] },
                    { "current": [4, "C"], "next": [0, "C", "R"] },
                    { "current": [5, "C"], "next": [5, "I", "L"] },
                    { "current": [5, "_"], "next": [6, "_", "R"] },
                ]
            },
            "blank": "_",
            "visible_tape": 5,
            "running": false
        },
        'delete': {
            "tm": {
                "tape": {
                    "left": [],
                    "current": "M",
                    "right": ["I", "I", "_", "I"]
                },
                "state": 0,
                "transitions": [
                    { "current": [0, "M"], "next": [1, "M", "R"] },
                    { "current": [1, "I"], "next": [1, "_", "R"] },
                    { "current": [1, "_"], "next": [2, "_", "L"] },
                    { "current": [2, "_"], "next": [2, "_", "L"] },
                    { "current": [2, "M"], "next": [3, "M", "R"] },
                ]
            },
            "blank": "_",
            "visible_tape": 5,
            "running": false
        },
        'fibonacci': {
            "tm": {
                "tape": {
                    "left": [],
                    "current": "I",
                    "right": ["I", "I"]
                },
                "state": 0,
                "transitions": [
                    // initialize tape by marking end of input and setting up 1, 1 on tape
                    { "current": [0, "I"], "next": [0, "I", "R"] },
                    { "current": [0, "_"], "next": [1, "M", "R"] },
                    { "current": [1, "_"], "next": [2, "I", "R"] },
                    { "current": [2, "_"], "next": [3, "_", "R"] },
                    { "current": [3, "_"], "next": [4, "I", "L"] },
                    { "current": [4, "_"], "next": [4, "_", "L"] },
                    { "current": [4, "I"], "next": [4, "I", "L"] },
                    { "current": [4, "M"], "next": [5, "M", "L"] },
                    // consume input
                    { "current": [5, "_"], "next": [46, "_", "R"] }, // -1 clean up
                    { "current": [5, "I"], "next": [6, "I", "L"] },
                    { "current": [6, "I"], "next": [6, "I", "L"] },
                    { "current": [6, "_"], "next": [7, "_", "R"] },
                    { "current": [7, "I"], "next": [8, "_", "R"] },
                    { "current": [8, "I"], "next": [8, "I", "R"] },
                    { "current": [8, "M"], "next": [9, "M", "R"] },
                    // copy first number
                    { "current": [9, "I"], "next": [10, "C", "R"] },
                    { "current": [9, "_"], "next": [16, "_", "R"] }, // copy second number
                    { "current": [10, "I"], "next": [10, "I", "R"] },
                    { "current": [10, "_"], "next": [11, "_", "R"] },
                    { "current": [11, "I"], "next": [11, "I", "R"] },
                    { "current": [11, "_"], "next": [12, "_", "R"] },
                    { "current": [12, "I"], "next": [12, "I", "R"] },
                    { "current": [12, "_"], "next": [13, "I", "L"] },
                    { "current": [13, "I"], "next": [13, "I", "L"] },
                    { "current": [13, "_"], "next": [14, "_", "L"] },
                    { "current": [14, "I"], "next": [14, "I", "L"] },
                    { "current": [14, "_"], "next": [15, "_", "L"] },
                    { "current": [15, "I"], "next": [15, "I", "L"] },
                    { "current": [15, "C"], "next": [9, "C", "R"] },
                    // copy second number
                    { "current": [16, "I"], "next": [17, "C", "R"] },
                    { "current": [16, "_"], "next": [23, "_", "R"] }, // add
                    { "current": [17, "I"], "next": [17, "I", "R"] },
                    { "current": [17, "_"], "next": [18, "_", "R"] },
                    { "current": [18, "I"], "next": [18, "I", "R"] },
                    { "current": [18, "_"], "next": [19, "_", "R"] },
                    { "current": [19, "I"], "next": [19, "I", "R"] },
                    { "current": [19, "_"], "next": [20, "I", "L"] },
                    { "current": [20, "I"], "next": [20, "I", "L"] },
                    { "current": [20, "_"], "next": [21, "_", "L"] },
                    { "current": [21, "I"], "next": [21, "I", "L"] },
                    { "current": [21, "_"], "next": [22, "_", "L"] },
                    { "current": [22, "I"], "next": [22, "I", "L"] },
                    { "current": [22, "C"], "next": [16, "C", "R"] },
                    // add
                    { "current": [23, "I"], "next": [23, "I", "R"] },
                    { "current": [23, "_"], "next": [24, "_", "R"] },
                    { "current": [24, "I"], "next": [24, "I", "R"] },
                    { "current": [24, "_"], "next": [25, "_", "L"] },
                    { "current": [25, "I"], "next": [26, "_", "L"] },
                    { "current": [26, "I"], "next": [26, "I", "L"] },
                    { "current": [26, "_"], "next": [27, "I", "L"] },
                    { "current": [27, "I"], "next": [27, "I", "L"] },
                    { "current": [27, "_"], "next": [28, "_", "L"] },
                    // change Cs to Is
                    { "current": [28, "C"], "next": [28, "I", "L"] },
                    { "current": [28, "_"], "next": [29, "_", "L"] },
                    // delete Cs
                    { "current": [29, "C"], "next": [29, "_", "L"] },
                    { "current": [29, "M"], "next": [30, "M", "R"] },
                    // position first number
                    { "current": [30, "_"], "next": [30, "_", "R"] },
                    { "current": [30, "I"], "next": [31, "I", "R"] },
                    { "current": [31, "I"], "next": [31, "I", "R"] },
                    { "current": [31, "_"], "next": [32, "M", "L"] },
                    { "current": [32, "I"], "next": [32, "I", "L"] },
                    { "current": [32, "_"], "next": [33, "_", "R"] },
                    { "current": [33, "_"], "next": [33, "_", "R"] },
                    { "current": [33, "M"], "next": [36, "_", "L"] }, // mark end of first number
                    { "current": [33, "I"], "next": [34, "_", "L"] },
                    { "current": [34, "_"], "next": [34, "_", "L"] },
                    { "current": [34, "M"], "next": [35, "M", "R"] },
                    { "current": [34, "I"], "next": [35, "I", "R"] },
                    { "current": [35, "_"], "next": [33, "I", "R"] },
                    // mark end of first Number
                    { "current": [36, "_"], "next": [36, "_", "L"] },
                    { "current": [36, "I"], "next": [37, "I", "R"] },
                    { "current": [37, "_"], "next": [38, "M", "R"] },
                    // position second number
                    { "current": [38, "_"], "next": [38, "_", "R"] },
                    { "current": [38, "I"], "next": [39, "I", "R"] },
                    { "current": [39, "I"], "next": [39, "I", "R"] },
                    { "current": [39, "_"], "next": [40, "M", "L"] },
                    { "current": [40, "I"], "next": [40, "I", "L"] },
                    { "current": [40, "_"], "next": [41, "_", "R"] },
                    { "current": [41, "_"], "next": [41, "_", "R"] },
                    { "current": [41, "M"], "next": [44, "_", "L"] }, // delete separator M
                    { "current": [41, "I"], "next": [42, "_", "L"] },
                    { "current": [42, "_"], "next": [42, "_", "L"] },
                    { "current": [42, "M"], "next": [43, "M", "R"] },
                    { "current": [42, "I"], "next": [43, "I", "R"] },
                    { "current": [43, "_"], "next": [41, "I", "R"] },
                    // delete separator M
                    { "current": [44, "_"], "next": [44, "_", "L"] },
                    { "current": [44, "I"], "next": [44, "I", "L"] },
                    { "current": [44, "M"], "next": [45, "_", "L"] },
                    { "current": [45, "I"], "next": [45, "I", "L"] },
                    { "current": [45, "M"], "next": [5, "M", "L"] }, // consume input
                    // cleanup
                    { "current": [46, "M"], "next": [46, "M", "R"] },
                    { "current": [46, "I"], "next": [46, "_", "R"] },
                    { "current": [46, "_"], "next": [47, "_", "R"] },
                    { "current": [47, "I"], "next": [47, "I", "R"] },
                    { "current": [47, "_"], "next": [48, "M", "L"] },
                    { "current": [48, "I"], "next": [48, "I", "L"] },
                    { "current": [48, "_"], "next": [49, "_", "R"] },
                    { "current": [49, "_"], "next": [49, "_", "R"] },
                    { "current": [49, "M"], "next": [52, "_", "L"] },
                    { "current": [49, "I"], "next": [50, "_", "L"] },
                    { "current": [50, "_"], "next": [50, "_", "L"] },
                    { "current": [50, "M"], "next": [51, "M", "R"] },
                    { "current": [50, "I"], "next": [51, "I", "R"] },
                    { "current": [51, "_"], "next": [49, "I", "R"] },
                    { "current": [52, "_"], "next": [52, "_", "L"] },
                    { "current": [52, "I"], "next": [52, "I", "L"] },
                    { "current": [52, "M"], "next": [-1, "_", "R"] },
                ]
            },
            "blank": "_",
            "visible_tape": 5,
            "running": false
        },
        'BB(5)?': {
            "tm": {
                "tape": {
                    "left": [],
                    "current": "_",
                    "right": []
                },
                "state": 0,
                "transitions": [
                    { "current": [0, "_"], "next": [1, "I", "L"] },
                    { "current": [0, "I"], "next": [2, "I", "R"] },
                    { "current": [1, "_"], "next": [2, "I", "L"] },
                    { "current": [1, "I"], "next": [1, "I", "L"] },
                    { "current": [2, "_"], "next": [3, "I", "L"] },
                    { "current": [2, "I"], "next": [4, "_", "R"] },
                    { "current": [3, "_"], "next": [0, "I", "R"] },
                    { "current": [3, "I"], "next": [3, "I", "R"] },
                    { "current": [4, "_"], "next": [-1, "I", "L"] },
                    { "current": [4, "I"], "next": [0, "_", "R"] },
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
