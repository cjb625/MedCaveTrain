$(function(){
    $('#buttonF').click(function(){
if($('#knob1').val().length<3){
$.ajax({

url: "http://192.168.43.213/F?0"+$('#knob1').val()+"END",
type: "POST",
data: "F",
success: function(){console.log('Success');}
});
}else{
    $.ajax({

url: "http://192.168.43.213/F?"+$('#knob1').val()+"END",
type: "POST",
data: "F",
success: function(){console.log('Success');}
});
     }
document.getElementById("currentSpeed").innerHTML = "Speed: "+$('#knob1').val();
        document.getElementById("currentDirection").innerHTML = "Direction: Forward";
});

     $('#buttonR').click(function(){

if($('#knob1').val().length<3){
$.ajax({

url: "http://192.168.43.213/R?0"+$('#knob1').val()+"END",
type: "POST",
data: "F",
success: function(){console.log('Success');}
});
}else{
    $.ajax({

url: "http://192.168.43.213/R?"+$('#knob1').val()+"END",
type: "POST",
data: "F",
success: function(){console.log('Success');}
});
     }
document.getElementById("currentSpeed").innerHTML = "Speed: "+$('#knob1').val();
        document.getElementById("currentDirection").innerHTML = "Direction: Reverse";
});
     $('#buttonW').click(function(){

$.ajax({

url: "http://192.168.43.213/W?000END",
type: "POST",
data: "F",
success: function(){console.log('Success');}
});

});
    


    $('#buttonS').click(function(){

$.ajax({

url: "http://192.168.43.213/S?000END",
type: "POST",
data: "F",
success: function(){console.log('Success');}
});
document.getElementById("currentSpeed").innerHTML = "Speed: 0";
        document.getElementById("currentDirection").innerHTML = "Direction: Stopped";
});
    


$('#buttonT').click(function(){

$.ajax({

url: "http://192.168.43.213/T?000END",
type: "POST",
data: "F",
success: function(){console.log('Success');}
});

});
    


$('#buttonB').click(function(){

$.ajax({

url: "http://192.168.43.213/B?000END",
type: "POST",
data: "F",
success: function(){console.log('Success');}
});

});

});
