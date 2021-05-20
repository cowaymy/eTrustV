<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<!-- TODO Yong: tidy up calendar CSS styling -->
<script type="text/javaScript" language="javascript">

$(document).ready(function(){

    var eventListJson = JSON.parse('${eventListJsonStr}');

    var i;
    var j = eventListJson.length;
    for (i = 0; i < j; i++) {
        var selectorDt = '#calDt' + eventListJson[i].dayOfMonth;
        $(selectorDt).append("<br>- " + eventListJson[i].eventDesc);
    }

    const monthNames = ["January", "February", "March", "April", "May", "June",
                        "July", "August", "September", "October", "November", "December"];

    $("#displayMth").text(monthNames[ "${displayMth}" - 1]);
    $("#displayYear").text("${displayYear}");

    fn_setSearchAttr(); //20210430 Yong: set fields back to values used in previous search, because ajax not used. Consider refactoring to use ajax
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
<c:if test="${sessionScope.calAllowUpload eq 'Y'}">
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
<c:set var="mainCounter" value="1"/>
<c:set var="createNewRow" value="true"/>
<table class="type1">
    <tr>
        <th id="displayMth" scope="column" style="border: 1px solid black; height: 40px; color:white; font-size:20px; background-color:#25527c"></th>
        <th id="displayYear" scope="column" style="border: 1px solid; height: 40px; font-size:20px; background-color:white" colspan="6"></th>
    </tr>
    <th style="border: 1px solid">Monday</th>
    <th style="border: 1px solid">Tuesday</th>
    <th style="border: 1px solid">Wednesday</th>
    <th style="border: 1px solid">Thursday</th>
    <th style="border: 1px solid">Friday</th>
    <th style="border: 1px solid">Saturday</th>
    <th style="border: 1px solid">Sunday</th>
        <tr> <%--Populate Calendar first row --%>
            <c:forEach begin="1" end="7" varStatus="columnCounter">
                        <c:choose>
                            <c:when test="${columnCounter.count eq dayOfWeekFirstDt}">
                                <td style="border: 1px solid; vertical-align:top">${mainCounter}<br>
                                    <div style="height: 50px; overflow: hidden;">
                                        <span style="border:0; id="calDt${mainCounter}"></span>
                                    </div>
                                </td>
                            </c:when>
                            <c:when test="${columnCounter.count gt dayOfWeekFirstDt}">
                                <c:set var="mainCounter" value="${mainCounter + 1}"/>
                                <td style="border: 1px solid; vertical-align:top">${mainCounter}<br>
                                    <div style="height: 50px; overflow: hidden;">
                                         <span style="border:0; id="calDt${mainCounter}"></span>
                                    </div>
                                </td>
                            </c:when>
                            <c:otherwise>
                                <td style="border: 1px solid"></td>
                            </c:otherwise>
                        </c:choose>
               </c:forEach>
        </tr>

        <c:forEach begin="0" end="4"> <%--Populate Calendar subsequent rows --%>
            <c:if test="${createNewRow}">
                <tr>
                    <c:forEach begin="1" end="7">
                            <c:set var="mainCounter" value="${mainCounter + 1}"/>
                            <c:choose>
                                <c:when test="${mainCounter le lastDateOfMonth}">
                                    <td style="border: 1px solid; vertical-align:top">${mainCounter}<br>
                                        <div style="height: 50px; overflow: hidden;">
                                             <span style="border:0;" id="calDt${mainCounter}"></span>
                                        </div>
                                    </td>
                                    <c:if test="${mainCounter eq lastDateOfMonth}">
                                        <c:set var="createNewRow" value="false"/>
                                    </c:if>
                                </c:when>
                                <c:otherwise>
                                    <td style="border: 1px solid"></td>
                                </c:otherwise>
                            </c:choose>
                    </c:forEach>
                </tr>
            </c:if>
        </c:forEach>
</table>
</section><!-- search_result end -->
</section><!-- content end -->