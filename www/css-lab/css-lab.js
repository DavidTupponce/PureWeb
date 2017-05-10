//Javascript for CSS-Lab

var onToggle = function(){
    if (toggle_state) {
        player.pause();
        toggle.src = 'play.png';
        toggle.alt = 'Play';

        toggle_state = 0;
    } else {
        player.play();
        toggle.src = 'pause.png';
        toggle.alt = 'Pause';

        toggle_state = 1;
    }
}

function setCSS(event){
    player.pause();//Mise en pause de l'arriére plan pour économie de ressources
    var variableCSS = document.getElementById('variant-stylesheet');
    variableCSS.href = event.target.id;
    console.log("CSS set to "+event.target.id);
}
/*
var setTropicalCSS = function(){
    player.play();
    setCSS('tropical.css');
}
var setModernUICSS = function(){
    player.pause();
    setCSS('modern-ui.css');
}
var setIndustrialCSS = function(){
    player.pause();
    setCSS('industrial.css');
}
*/
var toggle_state = 1;
var toggle = document.getElementById('toggle-play');
var player = document.getElementById('video-background');

toggle.addEventListener("click", onToggle);

var css_selectors = document.querySelectorAll('li');

for (var i = 0; i < css_selectors.length; i++) {
    css_selectors[i].addEventListener('click', setCSS, false);
    console.log("Event ajouté sur "+css_selectors[i].id+i);
}

/*var css_modernui = document.getElementById('modern-ui.css');
var css_industrial = document.getElementById('industrial.css');

css_tropical.addEventListener("click", setTropicalCSS);
css_modernui.addEventListener("click", setModernUICSS);
css_industrial.addEventListener("click", setIndustrialCSS);*/
