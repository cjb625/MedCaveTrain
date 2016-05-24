$(function(){

$('#start').click(function(){

$.ajax({

url: "http://192.168.43.213/"+$('#direction').val()+"?"+$('#speed').val(),
type: "POST",
data: "F",
success: function(){console.log('Success');}
});
document.getElementById("status").innerHTML = $('#direction').val();
});

});
