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

    var file = document.getElementById('load-file');
    file.addEventListener('change', function(){
        var file = this.files[0];
        if (!file) {return;}
        var reader = new FileReader();
        reader.onload = function(event){
            var source = event.target.result;
            program.value = source;
            app.ports.restart.send(program.value);
        };
        reader.readAsText(file);
    }, false);
})();
