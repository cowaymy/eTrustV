<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<!--
 DATE        BY     VERSION        REMARK
 ----------------------------------------------------------------
 21/04/2021  YONGJH  1.0.0      Initial creation. Note: Ajax is not used for populating calendar search result because each non-Ajax
                                           search request will "automatically" clear the calendar contents (this is desired). If I use Ajax to populate
                                           calendar search result, it will require additional Javascript for clearing and resetting calendar contents.
                                           Refactor to use Ajax if required in the future.
 04/06/2021  YONGJH  1.0.1      Move inline styling to <style> tag. Add CSS to show pop up for calendar events.
 01/07/2021  YONGJH  1.0.1      Refactored to use Ajax (refer first remark). Due to authorization issues

-->

<style type="text/css">

:root .event-text {
    --cal-event-text-width: attr(width);
}

.cal-result  {
    border-left: 1px solid #d3d9dd;
    border-right: 1px solid #d3d9dd;
}

.cal-header-month {
    font-size: 20px !important;
    background-color: #25527c !important;
    height: 40px !important;
    color: white !important;
}

.cal-header-year {
    font-size: 20px !important;
    background-color:white !important;
}

th.day-of-week {
    border: 1px solid #d3d9dd;
    padding-left: 8px !important;
}

td.cal-date, td.empty-cell {
    border: 1px solid #d3d9dd;
    height: 60px !important;
}

.cal-date-number {
    width: 100%;
    margin-bottom: 8px;
}

.cal-event-list {
    position: relative;
    width: 100%;
}

.event-text {
    height: 40px;
    white-space: nowrap;
    text-overflow: ellipsis;
    width: inherit;
    display: block;
    overflow: hidden;
    font-size: 12px;
    line-height: 1.6;
}

.cal-tooltip {
    visibility: hidden;
    border: 3px solid #25527c;
    border-radius: 5px;
    padding: 15px;
    background-color: #e9f0f4;
    position: absolute;
    z-index: 1;
    bottom: 100%;
    display: inline-block;
    width: var(--cal-event-text-width);
    line-height: 1.6;
    white-space: nowrap;
    box-shadow: 2px 2px 3px 1px #dddddd;
}

td:first-child .cal-tooltip, td:nth-child(2) .cal-tooltip {
    left: 0;
}

td:nth-child(6) .cal-tooltip, td:nth-child(7) .cal-tooltip {
    right: 0;
}

.cal-event-list:hover .cal-tooltip:not(:empty) {
    visibility: visible;
}

</style>

<script type="text/javaScript" language="javascript">

$(document).ready(function(){

	// *** set initial values when Calendar first loaded - start
	var eventList = JSON.parse('${eventListJsonStr}');

	var initData = {
		     "eventList" : eventList ,
		     "dayOfWeekFirstDt" : "${dayOfWeekFirstDt}" ,
		     "lastDateOfMonth" : "${lastDateOfMonth}" ,
		     "displayMth" : "${displayMth}" ,
		     "displayYear" : "${displayYear}" ,
		     "calMemType" : "${calMemType}"
		     };

	fn_setupCalendar(initData);
	fn_setSearchAttr();
	// *** set initial values when Calendar first loaded - end

});

function fn_searchCalendar() {
	if (fn_validateSearch()) {
        var param =  $("#calSearchForm").serialize();
        Common.ajax("GET", "/logistics/calendar/selectCalendarEvents.do", param, function(result) {
        	console.log("result.eventList JSON stringify:" +JSON.stringify(result.eventList));
            fn_setupCalendar(result);
        });
	}
}

function fn_setupCalendar(result) {
    $(".cal-row").remove();
    fn_populateCalendarHeader(result);
    fn_constructCalendar(result);
    fn_populateCalendarEvents(result);
    fn_setMemTypeVisibility();
}

function fn_populateCalendarHeader(rData) {
    const monthNames = ["January", "February", "March", "April", "May", "June",
                        "July", "August", "September", "October", "November", "December"];

    $("#displayMth").text(monthNames[rData.displayMth - 1]);
    $("#displayYear").text(rData.displayYear);

}

function fn_populateCalendarEvents(rData) {
    var i;
    var j = rData.eventList.length;
    for (i = 0; i < j; i++) {
        var selectorDt = '#calDt' + rData.eventList[i].dayOfMonth;
        $(selectorDt).append("- " + rData.eventList[i].eventDesc + "<br>");

        var selectorDtHidden = '#calDtHidden' + rData.eventList[i].dayOfMonth;
        $(selectorDtHidden).append("- " + rData.eventList[i].eventDesc + "<br>");
    }
}

function fn_constructCalendar(rData) {
	var dateCounter = 1;
	var createNewRow = true;

    // *********  create the first row - start
    var calRowFirstHtml = "<tr class='cal-row'>";
	for (var columnCounter = 1; columnCounter < 8; columnCounter++) {
		if ((rData.dayOfWeekFirstDt == 0 && columnCounter == 7)
				|| (columnCounter == rData.dayOfWeekFirstDt)){
			calRowFirstHtml = calRowFirstHtml + fn_constructHTML(dateCounter);
		} else if ((rData.dayOfWeekFirstDt != 0) && (columnCounter > rData.dayOfWeekFirstDt)) {
			dateCounter += 1;
			calRowFirstHtml = calRowFirstHtml + fn_constructHTML(dateCounter);
		} else {
			calRowFirstHtml = calRowFirstHtml + "<td class='empty-cell'/>";
		}
	}
	calRowFirstHtml = calRowFirstHtml + "</tr>";
	document.getElementById("calTable").innerHTML = document.getElementById("calTable").innerHTML + calRowFirstHtml;
	// *********  create the first row - end

    // *********  create subsequent rows - start
	for (var rowCounter = 0; rowCounter < 5; rowCounter++) {

		if (createNewRow){
		    var calRowNextHtml = "<tr class='cal-row'>";
			for (var columnCounter = 1; columnCounter < 8; columnCounter++) {
				dateCounter += 1;
				if (dateCounter <= rData.lastDateOfMonth) {
					calRowNextHtml = calRowNextHtml + fn_constructHTML(dateCounter);
	                if (dateCounter == rData.lastDateOfMonth) {
	                	createNewRow = false;
	                }
				} else {
					calRowNextHtml = calRowNextHtml + "<td class='empty-cell'/>";
				}
			}
			calRowNextHtml = calRowNextHtml + "</tr>";
		    document.getElementById("calTable").innerHTML = document.getElementById("calTable").innerHTML + calRowNextHtml;
		}
	}
    // *********  create subsequent rows - end

}

function fn_constructHTML(dateCounterVal) {
	var htmlString = "<td class='cal-date'>"
        + "<div class='cal-date-number'>" + dateCounterVal + "</div>"
        + "<div class='cal-event-list'>"
        + "<span class='event-text' id='calDt" + dateCounterVal + "'></span>"
        + "<span class='cal-tooltip' id='calDtHidden" + dateCounterVal + "'></span>"
        + "</div></td>";
	return htmlString;
}

function fn_validateSearch() {
	if ($("#calMonthYear").val() == "") {
		Common.alert("<spring:message code='sys.common.alert.validation' arguments='Month' htmlEscape='false'/>");
		return false;
	}

	if ($("#calMemType").is(":visible") && $("#calMemType").val() == "") {
	        Common.alert("<spring:message code='sys.common.alert.validation' arguments='Member Type' htmlEscape='false'/>");
	    return false;
	}
	return true;
}

function fn_eventUploadPopup() {
    Common.popupDiv("/logistics/calendar/calendarEventFileUploadPop.do", null, fn_searchCalendar, true, 'eventUploadPopup');
}

function fn_eventEditDeletePopup() {
    Common.popupDiv("/logistics/calendar/calendarEventEditDeletePop.do", null, fn_searchCalendar, true, 'eventEditDeletePopup');
}

function fn_setSearchAttr() {
	if("${calMemType}" != null && "${calMemType}" != "") {
		$("#calMemType").val("${calMemType}");
	}

    if(("${displayMth}" != null && "${displayMth}" != "")
    		&& ("${displayYear}" != null && "${displayYear}" != "")) {
    	var searchedCalMthYear = "${displayMth}" + "/" + "${displayYear}";
        $("#calMonthYear").val(searchedCalMthYear);
    }
}

function fn_setMemTypeVisibility() {
	var userType = '${SESSION_INFO.userTypeId}';

	if(userType == 4) { //Staff view
	    $("#rowMemType").show();
	} else {
		$("#calMemType").val(userType);
	}
}

</script>

<section id="content"><!-- content start -->
  <ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>MISC</li>
  </ul>

  <aside class="title_line"><!-- title_line start -->
    <p class="fav"><a href="#" class="click_add_on">My menu</a></p>
    <h2>Calendar</h2>
    <ul class="right_btns">
      <li><p class="btn_blue"><a href="#" onClick="fn_searchCalendar()"><span class="search"></span><spring:message code="sal.btn.search" /></a></p></li>
    </ul>
  </aside><!-- title_line end -->

  <section class="search_table"><!-- search_table start -->
    <form id="calSearchForm" name="calSearchForm" method="post" action="/logistics/calendar/selectCalendarEvents.do">
      <table class="type1"><!-- table start -->
        <caption>table</caption>
        <colgroup>
          <col style="width:150px" />
          <col style="width:*" />
        </colgroup>
        <tbody>
          <tr>
            <th scope="row"><spring:message code='cal.search.month'/></th>
            <td colspan='3'><input type="text" id="calMonthYear" name="calMonthYear" title="Month" class="j_date2" placeholder="Choose one" /></td>
          </tr>
          <tr id = "rowMemType" style="display:none;">
            <th scope="row"><spring:message code='cal.search.memType'/></th>
            <td colspan='3'>
              <select class="" id="calMemType" name="calMemType">
                <option value="">Choose One</option>
                <option value="1">Health Planner</option>
                <option value="2">Coway Lady</option>
                <option value="4">Staff</option>
                <option value="7">Homecare Technician</option>
              </select>
            </td>
          </tr>
        </tbody>
      </table><!-- table end -->
    </form>
  </section><!-- search_table end -->

  <aside class="link_btns_wrap">
    <%-- <c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'} "> --%>
    <!-- Yong 20210705: PAGE_AUTH not used for validation because it only works when Calendar menu is clicked. When Calendar Search is clicked, the validation will fail -->
    <c:if test="${sessionScope.calAllowUpload == 'Y'}">
      <p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
      <dl class="link_list">
        <dt>Link</dt>
        <dd>
          <ul class="btns">
            <li><p class="link_btn"><a href="javascript:fn_eventUploadPopup();"><spring:message code='cal.btn.link.uploadEvent'/></a></p></li>
            <li><p class="link_btn"><a href="javascript:fn_eventEditDeletePopup();"><spring:message code='cal.btn.link.editDeleteEvent'/></a></p></li>
          </ul>
          <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
        </dd>
      </dl>
    </c:if>
  </aside><!-- link_btns_wrap end -->
  <br>
  <section class="search_result"><!-- search_result start -->
    <c:set var="dateCounter" value="1"/>
    <c:set var="createNewRow" value="true"/>
    <table class="type1 cal-result" id="calTable">
      <tr>
        <th class="cal-header-month" id="displayMth" scope="column"></th>
        <th class="cal-header-year" id="displayYear" scope="column" colspan="6"></th>
      </tr>
      <tr>
        <th class="day-of-week">Monday</th>
        <th class="day-of-week">Tuesday</th>
        <th class="day-of-week">Wednesday</th>
        <th class="day-of-week">Thursday</th>
        <th class="day-of-week">Friday</th>
        <th class="day-of-week">Saturday</th>
        <th class="day-of-week">Sunday</th>
      </tr>
    </table>
  </section><!-- search_result end -->
</section><!-- content end -->
