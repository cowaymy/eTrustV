<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<head>
<!-- BING MAP -->
<!--
<script type="text/javascript" src="https://www.bing.com/api/maps/mapcontrol?key=<c:out value="${params.BING_KEY}" />"></script>
<script type="text/javascript" src="https://www.bing.com/api/maps/mapcontrol?callback=initMap" async defer></script>
-->

<meta charset="utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="stylesheet" href="https://unpkg.com/leaflet/dist/leaflet.css" />
<link rel="stylesheet" href="https://unpkg.com/leaflet-control-geocoder/dist/Control.Geocoder.css" />
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/leaflet.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/Control.Geocoder.js"></script>

<style>
  #map {
    height: 600px;
    width: 100%;
  }

  /* Override default blue marker color to red */
  .leaflet-marker-icon.leaflet-div-icon {
    background-color: red !important;
    border-color: red !important;
  }

  /* Extend the search box */
  .leaflet-control-geocoder-form input[type="text"] {
    width: 500px; /* Adjust the width as needed */
  }

  .leaflet-control-geocoder {
    padding: 5px; /* Add padding */
   }

   .leaflet-control-geocoder-result {
            display: flex;
            flex-direction: column;
        }

        .leaflet-control-geocoder-search-results {
            width: 100%;
        }
</style>

<!-- BING MAP -->
<!--
<script type="text/javaScript" language="javascript">
  var map;
  var pin;
  var defaultPinColor = 'red';
  function initMap() {
    const apiKey = '${params.BING_KEY}';
    const mapContainer = document.getElementById("mapContainer");
    const coordinate = JSON.parse('${params.coordinate}');
    const passLattitude = coordinate[0].lattitude;
    const passLongitude = coordinate[0].longtitude;

    map = new Microsoft.Maps.Map(mapContainer, {
      credentials: apiKey,
      center: new Microsoft.Maps.Location(passLattitude == '' ? '${params.MAP_CENTER_LAT}' : passLattitude,  passLongitude == '' ? '${params.MAP_CENTER_LONG}' : passLongitude),
      zoom: 15
    });

    for (var a = 0; a < coordinate.length; a++) {
      if (passLattitude != '' && passLongitude != '') {
        pin = new Microsoft.Maps.Pushpin(new Microsoft.Maps.Location(coordinate[a].lattitude, coordinate[a].longtitude), {
          color: coordinate[a].color = 'undefined' ? this.defaultPinColor : coordinate[a].color,
          text: (a+1).toString(),
          title: coordinate[a].text
        });
        map.entities.push(pin);
      }
    }

    $('#lblLatitude').text(passLattitude);
    $('#lblLongtitude').text(passLongitude);

    if ('${params.callBack}' != null && '${params.callBack}' != "") {
      Microsoft.Maps.Events.addHandler(map, 'click', function (e) {
        var latitude = e.location.latitude;
        var longitude = e.location.longitude;

        var pin = new Microsoft.Maps.Pushpin(new Microsoft.Maps.Location(latitude, longitude), {
          color: 'red',
        });

        map.entities.clear();
        map.entities.push(pin);

        $('#lblLatitude').text(latitude);
        $('#lblLongtitude').text(longitude);
      });

      Microsoft.Maps.loadModule(['Microsoft.Maps.AutoSuggest', 'Microsoft.Maps.Search'], function () {
        var manager = new Microsoft.Maps.AutosuggestManager({ map: map });
        manager.attachAutosuggest('#searchBox', '#searchBoxContainer', suggestionSelected);

        searchManager = new Microsoft.Maps.Search.SearchManager(map);
      });
    }
  }

  function suggestionSelected(result) {
    map.entities.clear();

    var pin = new Microsoft.Maps.Pushpin(result.location);
    map.entities.push(pin);

    map.setView({ bounds: result.bestView });

    $('#lblLatitude').text('');
    $('#lblLongtitude').text('');
  }

  function geocode() {
    map.entities.clear();
    var query = document.getElementById('searchBox').value;
    var searchRequest = {
        where: query,
        callback: function (r) {
            if (r && r.results && r.results.length > 0) {
                var pin, pins = [], locs = [], output = 'Results:<br/>';

                for (var i = 0; i < r.results.length; i++) {
                    pin = new Microsoft.Maps.Pushpin(r.results[i].location, {
                        text: i + ''
                    });
                    pins.push(pin);
                    locs.push(r.results[i].location);
                }

                map.entities.push(pins);
                document.getElementById('output').innerHTML = output;
                var bounds;

                if (r.results.length == 1) {
                    bounds = r.results[0].bestView;
                } else {
                    bounds = Microsoft.Maps.LocationRect.fromLocations(locs);
                }

                map.setView({ bounds: bounds, padding: 30 });
            }
        },
        errorCallback: function (e) {
          Common.alert("<spring:message code='sys.msg.noRcdAvai'/>");
        }
    };
    searchManager.geocode(searchRequest);
  }

  function fn_getLocation() {
    if ($('#lblLatitude').text() == '' || $('#lblLongtitude').text() == '') {
      label = "<spring:message code='sys.msg.gpsLoc' />";
      Common.alert("<spring:message code='sys.msg.necessary' arguments='" + label + "' htmlEscape='false'/>");
      return;
    }
    const params = {"latitude" : $('#lblLatitude').text(), "longitude" : $('#lblLongtitude').text()};
    const callback = '${params.callBack}({params})';
    eval(callback);
    $('#mapPopCloseBtn').click();
  }

  $(document).ready(function() {
    if ( '${params.callBack}' == null ||  '${params.callBack}' == "") {
      $('#searchBoxContainer').hide();
      $('#buttonBoxContainer').hide();
    } else {
      $('#searchBoxContainer').show();
      $('#buttonBoxContainer').show();
    }
  });
</script>
-->
<script>
  const coordinate = JSON.parse('${params.coordinate}');
  const passLattitude = coordinate[0].lattitude;
  const passLongitude = coordinate[0].longtitude;

  // INITIALIZE THE MAP AND SET THE DEFAULT LOCATION
  var defaultLat = passLattitude == '' ? '${params.MAP_CENTER_LAT}' : passLattitude;
  var defaultLng = passLongitude == '' ? '${params.MAP_CENTER_LONG}' : passLongitude;
  var map = L.map('mapContainer').setView([defaultLat, defaultLng], 16); // INCREASED ZOOM LEVEL TO 18

  var redIcon = L.icon({
      iconUrl: 'https://unpkg.com/leaflet@1.9.4/dist/images/marker-icon.png',
      iconSize: [25, 41],
      iconAnchor: [12, 41],
      popupAnchor: [1, -34],
      tooltipAnchor: [16, -28],
      shadowSize: [41, 41]
  });

  // SET UP THE OSM LAYER
  L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
    maxZoom: 19,
  }).addTo(map);

  // ADD A REFERENCE MARKER AT THE DEFAULT LOCATION
  var refMarker = L.marker([defaultLat, defaultLng], { icon: redIcon }).addTo(map);

  $('#lblLatitude').text(defaultLat);
  $('#lblLongtitude').text(defaultLng);

  // ADD A SEARCH BOX TO THE MAP
  var geocoder = L.Control.geocoder({
    defaultMarkGeocode: false
  })
  .on('markgeocode', function(e) {
    var latlng = e.geocode.center;
    updateReferenceMarker(latlng.lat, latlng.lng);
    map.setView(latlng, 16); // SET ZOOM LEVEL TO 16 WHEN A LOCATION IS SERACHED
      // document.getElementById('coordinates').innerHTML = "Latitude: " + latlng.lat + ", Longitude: " + latlng.lng;
      $('#lblLatitude').text(latlng.lat);
      $('#lblLongtitude').text(latlng.lng);
    })
    .addTo(map);

  // ADD A CLICK EVENT LISTENER TO THE MAP
  map.on('click', function(e) {
    var lat = e.latlng.lat;
    var lng = e.latlng.lng;
    updateReferenceMarker(lat, lng);
    //document.getElementById('coordinates').innerHTML = "Latitude: " + lat + ", Longitude: " + lng;
    $('#lblLatitude').text(lat);
    $('#lblLongtitude').text(lng);
  });

  // Function to update the reference marker
  function updateReferenceMarker(lat, lng) {
    // Remove the existing reference marker
    map.removeLayer(refMarker);
    // Add a new reference marker at the clicked location
    refMarker = L.marker([lat, lng]).addTo(map)
      .bindPopup("Reference Location:<br>Latitude: " + lat + "<br>Longitude: " + lng)
      .openPopup();
  }

  function fn_getLocation() {
    if ($('#lblLatitude').text() == '' || $('#lblLongtitude').text() == '') {
      label = "<spring:message code='sys.msg.gpsLoc' />";
      Common.alert("<spring:message code='sys.msg.necessary' arguments='" + label + "' htmlEscape='false'/>");
      return;
    }
    const params = {"latitude" : $('#lblLatitude').text(), "longitude" : $('#lblLongtitude').text()};
    const callback = '${params.callBack}({params})';
    eval(callback);
    $('#mapPopCloseBtn').click();
  }

  $(document).ready(function() {
    if ( '${params.callBack}' == null ||  '${params.callBack}' == "") {
      $('#searchBoxContainer').hide();
      $('#buttonBoxContainer').hide();
    } else {
      $('#searchBoxContainer').show();
      $('#buttonBoxContainer').show();
    }
  });
</script>
</head>

<div id="popup_wrap" class="popup_wrap">

  <header class="pop_header">
    <h1>MAP</h1>
    <ul class="right_opt">
      <li><p class="btn_blue2"><a id="mapPopCloseBtn" href="#">CLOSE</a></p></li>
    </ul>
  </header>

  <section class="pop_body">
    <!-- <div id='searchBoxContainer'>
      <table>
        <tr>
         <td width="90%">
           <input type='text' id='searchBox' class="w100p"/>
         </td>
         <td width="10%">
           <input type='button' value='Search' onclick='geocode()' />
         </td>
        </tr>
      </table>
    </div>
    </br> -->
    <div id="mapContainer" style="position:relative;width:auto;height:80%;"></div>
    <br/>
    <div id='latLongBoxContainer'>
      <table class="type1">
        <caption>table</caption>
        <colgroup>
          <col style="width: 140px" />
          <col style="width: *" />
          <col style="width: 140px" />
          <col style="width: *" />
        </colgroup>
        <tbody>
          <tr>
            <th scope="row"><spring:message code='txtLatitude' /><span class="must">**</span></th>
            <td>
              <span id="lblLatitude"></span>
            </td>
            <th scope="row"><spring:message code='txtLongtitude' /><span class="must">**</span></th>
            <td>
              <span id="lblLongtitude"></span>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
    <br/>
    <div id='buttonBoxContainer'>
      <ul class="center_btns">
        <li><p class="btn_blue2 big"><a href="javascript:fn_getLocation();"><spring:message code='newCpeRegistMsg.ok' /></a></p></li>
      </ul>
    </div>
  </section>

</div>
