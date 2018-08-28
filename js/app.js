(function(){
    var node = document.getElementById('target');
    var app = Elm.TM.init({
        node: node
    });

    var load = document.getElementById('load-program');
    var program = document.getElementById('program');
    load.onclick = function(event){
        app.ports.restart.send(program.value);
    };
    app.ports.restart.send(program.value);
})();
