<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript" language="javascript">

$(document).ready(function(){

    var eventListJson = JSON.parse('${eventListJsonStr}');

    var i;
    var j = eventListJson.length;
    for (i = 0; i < j; i++) {
        var selectorDt = '#calDt' + eventListJson[i].dayOfMonth;
        $(selectorDt).append("<br>- " + eventListJson[i].eventDesc);
    }
});

function fn_searchCalendar() {
	if (fn_validateSearch()) {
	    document.getElementById("calSearchForm").submit();
	}
}

function fn_validateSearch() {
	if ($("#calMonth").val() == "") {
		Common.alert("<spring:message code='sys.common.alert.validation' arguments='Month' htmlEscape='false'/>");
		return false;
	}
	return true;
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
                <td><input type="text" id="calMonth" name="calMonth" title="Month" class="j_date2" placeholder="Choose one" />
                </td>
            </tr>
        </tbody>
    </table><!-- table end -->
</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->
<c:set var="mainCounter" value="1"/>
<c:set var="createNewRow" value="true"/>
<table class="type1">
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
                                                                <span style="border:0;" id="calDt${mainCounter}"></span>
                                </td>
                            </c:when>
                            <c:when test="${columnCounter.count gt dayOfWeekFirstDt}">
                                <c:set var="mainCounter" value="${mainCounter + 1}"/>
                                <td style="border: 1px solid; vertical-align:top">${mainCounter}<br>
                                                                <span style="border:0;" id="calDt${mainCounter}"></span>
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
                                                                <span style="border:0;" id="calDt${mainCounter}"></span>
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