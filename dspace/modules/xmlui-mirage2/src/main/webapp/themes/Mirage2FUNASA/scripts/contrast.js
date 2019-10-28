$(document).ready(function() {

	if (getCookie("contrast")=="true")
	{
		$('body, footer').toggleClass('bodyBlack');
		$('.fa-soundcloud').toggleClass('fa-inverse');
	}


	$('#btnContrast, #btnContrast2').on('click', function(){
		$('body, footer').toggleClass('bodyBlack');
		$('.fa-soundcloud').toggleClass('fa-inverse');
		if ($('body').hasClass('bodyBlack'))
		{
			setCookie("contrast","true");
		}
		else
		{
			setCookie("contrast","false");

		}

	});

});


function setCookie(cname, cvalue, exdays) {
  var d = new Date();
  //d.setTime(d.getTime() + (exdays * 24 * 60 * 60 * 1000));
  //var expires = "expires="+d.toUTCString();
  
  var expires = "expires=Fri, 31 Dec 9999 23:59:59 GMT";
  document.cookie = cname + "=" + cvalue + ";" + expires + ";path=/";
}

function getCookie(cname) {
  var name = cname + "=";
  var ca = document.cookie.split(';');
  for(var i = 0; i < ca.length; i++) {
    var c = ca[i];
    while (c.charAt(0) == ' ') {
      c = c.substring(1);
    }
    if (c.indexOf(name) == 0) {
      return c.substring(name.length, c.length);
    }
  }
  return "";
}

function acessibilidade(){
    var url = location.href;

    var pressedCtrl = false;
    document.onkeyup=function(e){
        if(e.which == 17)
            pressedCtrl =false;
    }

    document.onkeydown=function(e){
        if(e.which == 18){
            pressedCtrl = true;
        }

        if(e.which == 49 && pressedCtrl == true) {
            window.location.assign("#main_container");
        }

        if(e.which == 50 && pressedCtrl == true) {
            if(url.indexOf("handle")==-1) {
                window.location.assign("#wrapper-barra-brasil");
            } else {
                window.location.assign("#sidebar");
            }
        }

        if(e.which == 51 && pressedCtrl == true) {
            if ( window.location.assign("#ds-search-form") ){
                window.location.assign("#ds-search-form");
            } else {
                window.location.assign("#aspect_discovery_SimpleSearch_list_primary-search");
            }
        }
    }
}
