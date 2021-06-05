<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<!DOCTYPE html>
<!--
 DATE        BY     VERSION        REMARK
 ----------------------------------------------------------------
 21/04/2021  YONGJH  1.0.0      Initial creation. Note: Ajax is not used for populating calendar search result because each non-Ajax
                                           search request will "automatically" clear the calendar contents (this is desired). If I use Ajax to populate
                                           calendar search result, it will require additional Javascript for clearing and resetting calendar contents.
                                           Refactor to use Ajax if required in the future.

 04/06/2021  YONGJH  1.0.1      Move inline styling to <style> tag. Add CSS to show pop up for calendar events.
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

    var eventListJson = JSON.parse('${eventListJsonStr}');

    var i;
    var j = eventListJson.length;
    for (i = 0; i < j; i++) {
        var selectorDt = '#calDt' + eventListJson[i].dayOfMonth;
        $(selectorDt).append("- " + eventListJson[i].eventDesc + "<br>");

        var selectorDtHidden = '#calDtHidden' + eventListJson[i].dayOfMonth;
        $(selectorDtHidden).append("- " + eventListJson[i].eventDesc + "<br>");
    }

    const monthNames = ["January", "February", "March", "April", "May", "June",
                        "July", "August", "September", "October", "November", "December"];

    $("#displayMth").text(monthNames[ "${displayMth}" - 1]);
    $("#displayYear").text("${displayYear}");

    fn_setSearchAttr(); // set fields back to values used in previous search, because ajax not used. See note at beginning of JSP.
    fn_setMemTypeVisibility();

});

function fn_searchCalendar() {
	if (fn_validateSearch()) {
	    document.getElementById("calSearchForm").submit();
	}
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
    <table class="type1 cal-result">
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

      <%--Populate Calendar first row --%>
      <tr>
        <c:forEach begin="1" end="7" varStatus="columnCounter"> <%-- Check for "dayOfWeekFirstDt == 0" is to handle cases where 1st day of month falls on Sunday --%>
          <c:choose>
            <c:when test="${(dayOfWeekFirstDt == 0) && (columnCounter.count == 7)}">
              <td class="cal-date">
                <div class="cal-date-number">${dateCounter}</div>
                <div class="cal-event-list">
                  <span class="event-text" id="calDt${dateCounter}"></span>
                  <span class="cal-tooltip" id="calDtHidden${dateCounter}"></span>
                </div>
              </td>
            </c:when>
            <c:when test="${columnCounter.count == dayOfWeekFirstDt}">
              <td class="cal-date">
                <div class="cal-date-number">${dateCounter}</div>
                <div class="cal-event-list">
                  <span class="event-text" id="calDt${dateCounter}"></span>
                  <span class="cal-tooltip" id="calDtHidden${dateCounter}"></span>
                </div>
              </td>
            </c:when>
            <c:when test="${((dayOfWeekFirstDt != 0)) && (columnCounter.count gt dayOfWeekFirstDt)}">
              <c:set var="dateCounter" value="${dateCounter + 1}"/>
              <td class="cal-date">
                <div class="cal-date-number">${dateCounter}</div>
                <div class="cal-event-list">
                  <span class="event-text" id="calDt${dateCounter}"></span>
                  <span class="cal-tooltip" id="calDtHidden${dateCounter}"></span>
                </div>
              </td>
            </c:when>
            <c:otherwise>
              <td class="empty-cell"/>
            </c:otherwise>
          </c:choose>
        </c:forEach>
      </tr>

      <%--Populate Calendar subsequent rows --%>
      <c:forEach begin="0" end="4">
        <c:if test="${createNewRow}">
          <tr>
            <c:forEach begin="1" end="7">
            <c:set var="dateCounter" value="${dateCounter + 1}"/>
              <c:choose>
                <c:when test="${dateCounter le lastDateOfMonth}">
                  <td class="cal-date">
                    <div class="cal-date-number">${dateCounter}</div>
                    <div class="cal-event-list">
                      <span class="event-text" id="calDt${dateCounter}"></span>
                      <span class="cal-tooltip" id="calDtHidden${dateCounter}"></span>
                    </div>
                  </td>
                  <c:if test="${dateCounter == lastDateOfMonth}">
                    <c:set var="createNewRow" value="false"/>
                  </c:if>
                </c:when>
                <c:otherwise>
                  <td class="empty-cell"/>
                </c:otherwise>
              </c:choose>
            </c:forEach>
          </tr>
        </c:if>
      </c:forEach>
    </table>
  </section><!-- search_result end -->
</section><!-- content end -->