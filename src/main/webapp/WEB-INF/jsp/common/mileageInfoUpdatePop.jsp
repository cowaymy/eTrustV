<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<head>
<script type="text/javaScript" language="javascript">
  $(document).ready(function() {
    getTodayDate();
  });

  function fn_searchLocation() {
    var location = [{
      "lattitude" : $('#latitude').val(),
      "longtitude" : $('#longtitude').val()
    }];

    var prm = {
      "coordinate" : JSON.stringify(location),
      "callFunc" : "1",
      "callBack" : "callBackMap"
    };
    Common.popupDiv("/common/mapPop.do", prm, null, true, '_searchDiv');
  }

  function callBackMap(rtn) {
    $('#latitude').val(rtn.params.latitude);
    $('#longtitude').val(rtn.params.longitude);
  }

  function getTodayDate() {
    const today = new Date();
    const yyyy = today.getFullYear();
    let mm = today.getMonth() + 1;
    let dd = today.getDate();

    if (dd < 10) dd = '0' + dd;
    if (mm < 10) mm = '0' + mm;

    const formattedToday = dd + '/' + mm + '/' + yyyy;

    $('#date').val(formattedToday);
  }

  function fn_next() {
    var text = "";
    var msg = "";

    if ($('#date').val() == "") {
      msg = "* <spring:message code='sys.msg.necessary' arguments='Actual Date' htmlEscape='false' /></br>";
      Common.alert(msg);
      return false;
    }

    if ($('#time').val() == "") {
      msg = "* <spring:message code='sys.msg.necessary' arguments='Actual Time' htmlEscape='false' /></br>";
      Common.alert(msg);
      return false;
    }

    if ($('#latitude').val() == "") {
      msg = "* <spring:message code='sys.msg.necessary' arguments='Latitude' htmlEscape='false' /></br>";
      Common.alert(msg);
      return false;
    }

    if ($('#longtitude').val() == "") {
      msg = "* <spring:message code='sys.msg.necessary' arguments='Longtitude' htmlEscape='false' /></br>";
      Common.alert(msg);
      return false;
    }

    Common.ajax("POST", "/common/updateOnBehalfMileage.do", $("#mileageForm").serializeJSON(),
      function(result) {
        //$("#popup_wrap").remove();
        //fn_installationListSearch();
        console.log(JSON.stringify(result));
        console.log(JSON.stringify(result[0].status));
        if (JSON.stringify(result[0].status)) {
          $("#_commonMileageDiv").remove();
          Common.popupDiv('${params.path}' , "", null, "false", '${params.popId}' );
        } else {
          msg = "Fail to Insert Mileage Information.";
          Common.alert(msg);
        }
      });

  }
</script>
</head>
<div id="popup_wrap" class="popup_wrap">
  <header class="pop_header">
    <h1>Job Mileage Information</h1>
    <ul class="right_opt">
      <li><p class="btn_blue2"><a id="mileagePopCloseBtn" href="#">CLOSE</a></p></li>
    </ul>
  </header>
  <form action="#"  id="mileageForm" method="post">
    <input type='hidden' id='ordNo' name='ordNo' value='${params.salesOrdNo}'/>
    <input type='hidden' id='userName' name='userName' value='${params.memCode}'/>
    <input type='hidden' id='serviceNo' name='serviceNo' value='${params.jobNo}'/>
    <section class="pop_body">
      <div id='dataContainer'>
        <aside class="title_line">
          <h2>
            <spring:message code='service.title.General' />
          </h2>
        </aside>
        <table class="type1">
          <caption>table</caption>
          <colgroup>
            <col style="width: 140px" />
            <col style="width: *" />
            <col style="width: 200px" />
            <col style="width: *" />
          </colgroup>
          <tbody>
            <tr>
              <th scope="row"><spring:message code='sales.OrderNo' /><span class="must">**</span></th>
              <td>
                <span id="lblOrdNo">${params.salesOrdNo}</span>
              </td>
              <th scope="row">Job No.<span class="must">**</span></th>
              <td>
                <span id="lblJobNo">${params.jobNo}</span>
              </td>
            </tr>
            <tr>
              <th scope="row">Agent Code<span class="must">**</span></th>
              <td>
                <span id="lblAgntCde">${params.memCode}</span>
              </td>
              <th scope="row">Agent Name<span class="must">**</span></th>
              <td>
                <span id="lblAgntNm">${params.name}</span>
              </td>
            </tr>
            <tr>
              <th scope="row">Actual Date<span class="must">**</span></th>
              <td>
                <input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p" id="date" name="date" />
              </td>
              <th scope="row">Actual Time<span class="must">**</span></th>
              <td>
                <div class="time_picker">
                  <input type="text" title="" placeholder="" id='time' name='time' class="time_date" />
                  <ul>
                    <li><spring:message code='service.text.timePick' /></li>
                    <c:forEach var="list" items="${timePick}" varStatus="status">
                      <li><a href="#">${list.codeName}</a></li>
                    </c:forEach>
                  </ul>
                </div>
              </td>
            </tr>
            <tr>
              <th scope="row">Address</th>
              <td colspan='3'>
                <span id="lblAddress">${params.address}</span>
              </td>
            </tr>
          </tbody>
        </table>
        <aside class="title_line">
          <h2>
            <spring:message code='txtGPS' />
          </h2>
        </aside>
        <table class="type1">
          <caption>table</caption>
          <colgroup>
            <col style="width: 140px" />
            <col style="width: *" />
            <col style="width: 140px" />
            <col style="width: *" />
            <col style="width: 60px" />
          </colgroup>
          <tbody>
            <tr>
              <th scope="row"><spring:message code='txtLatitude' /><span class="must">**</span></th>
              <td>
                <input type="text" title="<spring:message code='txtLatitude' />" placeholder="<spring:message code='txtLatitude' />" id="latitude" name="latitude" class="w100p" value="${params.latitude}"/>
              </td>
              <th scope="row"><spring:message code='txtLongtitude' /><span class="must">**</span></th>
              <td>
                <input type="text" title="<spring:message code='txtLongtitude' />" placeholder="<spring:message code='txtLongtitude' />" class="w100p" id="longtitude" name="longtitude" value="${params.longitude}"/>
              </td>
              <td>
                <a href="#" onclick="fn_searchLocation()" class=""><img src="${pageContext.request.contextPath}/resources/images/common/normal_Location.gif" alt="Location" width="40px" height='40px' /></a>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
      <br />
      <div id='buttonBoxContainer'>
        <ul class="center_btns">
          <li><p class="btn_blue2 big"><a href="javascript:fn_next();">Next</a></p></li>
        </ul>
      </div>
    </section>
  </form>
</div>
