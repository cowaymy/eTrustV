<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<head>
<script type="text/javascript" src="https://www.bing.com/api/maps/mapcontrol?key=<c:out value="${params.BING_KEY}" />"></script>
<script type="text/javascript" src="https://www.bing.com/api/maps/mapcontrol?callback=initMap" async defer></script>
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
</head>
<div id="popup_wrap" class="popup_wrap">

  <header class="pop_header">
    <h1>MAP</h1>
    <ul class="right_opt">
      <li><p class="btn_blue2"><a id="mapPopCloseBtn" href="#">CLOSE</a></p></li>
    </ul>
  </header>

  <section class="pop_body">
    <div id='searchBoxContainer'>
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
    </br>
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
