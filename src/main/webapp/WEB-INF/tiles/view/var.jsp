<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>


<input type="hidden" name="_TEMP_" value="<c:out value="${TEMP}"/>" />

<script>
	var javascriptLoglevel = "debug";
	var _SESSION_EXPIRE_MESSAGE ="<spring:message code='sys.msg.session.expired'/>";
	var _CSRF_INVALID_MESSAGE ="<spring:message code='sys.msg.csrf.invalid'/>";
    var DEFAULT_DELIMITER = "|!|";
    var DEFAULT_RESOURCE_FILE = "${pageContext.request.contextPath}" + "/resources/WebShare";
	var DEFAULT_HELP_FILE = "${pageContext.request.contextPath}" + "/help";

	function getContextPath() {
       return "${pageContext.request.contextPath}";
    }

	var gridMsg = new Array();

	gridMsg["sys.info.grid.noDataMessage"] = "<spring:message code='sys.info.grid.noDataMessage'  javaScriptEscape='true'/>";
	gridMsg["sys.info.grid.groupingMessage"] = "<spring:message code='sys.info.grid.groupingMessage'  javaScriptEscape='true'/>";
	gridMsg["sys.info.grid.filterNoValueText"] = "<spring:message code='sys.info.grid.filterNoValueText'  javaScriptEscape='true'/>";
	gridMsg["sys.info.grid.filterCheckAllText"] = "<spring:message code='sys.info.grid.filterCheckAllText'  javaScriptEscape='true'/>";
	gridMsg["sys.info.grid.filterClearText"] = "<spring:message code='sys.info.grid.filterClearText'  javaScriptEscape='true'/>";
	gridMsg["sys.info.grid.filterSearchCheckAllText"] = "<spring:message code='sys.info.grid.filterSearchCheckAllText'  javaScriptEscape='true'/>";
	gridMsg["sys.info.grid.filterSearchPlaceholder"] = "<spring:message code='sys.info.grid.filterSearchPlaceholder'  javaScriptEscape='true'/>";
	gridMsg["sys.info.grid.filterOkText"] = "<spring:message code='sys.info.grid.filterOkText'  javaScriptEscape='true'/>";
	gridMsg["sys.info.grid.filterCancelText"] = "<spring:message code='sys.info.grid.filterCancelText'  javaScriptEscape='true'/>";
	gridMsg["sys.info.grid.filterItemMoreMessage"] = "<spring:message code='sys.info.grid.filterItemMoreMessage'  javaScriptEscape='true'/>";
	gridMsg["sys.info.grid.summaryText"] = "<spring:message code='sys.info.grid.summaryText'  javaScriptEscape='true'/>";
	gridMsg["sys.info.grid.rowNumHeaderText"] = "<spring:message code='sys.info.grid.rowNumHeaderText'  javaScriptEscape='true'/>";
	gridMsg["sys.info.grid.remoterPlaceholder"] = "<spring:message code='sys.info.grid.remoterPlaceholder'  javaScriptEscape='true'/>";
	gridMsg["sys.info.grid.calendar.formatYearString"] = "<spring:message code='sys.info.grid.calendar.formatYearString'  javaScriptEscape='true'/>";
	gridMsg["sys.info.grid.calendar.monthTitleString"] = "<spring:message code='sys.info.grid.calendar.monthTitleString'  javaScriptEscape='true'/>";
	gridMsg["sys.info.grid.calendar.formatMonthString"] = "<spring:message code='sys.info.grid.calendar.formatMonthString'  javaScriptEscape='true'/>";
	gridMsg["sys.info.grid.calendar.todayText"] = "<spring:message code='sys.info.grid.calendar.todayText'  javaScriptEscape='true'/>";
	gridMsg["sys.info.grid.calendar.uncheckDateText"] = "<spring:message code='sys.info.grid.calendar.uncheckDateText'  javaScriptEscape='true'/>";
	gridMsg["sys.info.grid.filterNumberOperatorList.eq"] = "<spring:message code='sys.info.grid.filterNumberOperatorList.eq'  javaScriptEscape='true'/>";
	gridMsg["sys.info.grid.filterNumberOperatorList.gt"] = "<spring:message code='sys.info.grid.filterNumberOperatorList.gt'  javaScriptEscape='true'/>";
	gridMsg["sys.info.grid.filterNumberOperatorList.gte"] = "<spring:message code='sys.info.grid.filterNumberOperatorList.gte'  javaScriptEscape='true'/>";
	gridMsg["sys.info.grid.filterNumberOperatorList.lt"] = "<spring:message code='sys.info.grid.filterNumberOperatorList.lt'  javaScriptEscape='true'/>";
	gridMsg["sys.info.grid.filterNumberOperatorList.lte"] = "<spring:message code='sys.info.grid.filterNumberOperatorList.lte'  javaScriptEscape='true'/>";
	gridMsg["sys.info.grid.filterNumberOperatorList.ne"] = "<spring:message code='sys.info.grid.filterNumberOperatorList.ne'  javaScriptEscape='true'/>";
	gridMsg["sys.info.grid.calendar.titles.sun"] = "<spring:message code='sys.info.grid.calendar.titles.sun'  javaScriptEscape='true'/>";
	gridMsg["sys.info.grid.calendar.titles.mon"] = "<spring:message code='sys.info.grid.calendar.titles.mon'  javaScriptEscape='true'/>";
	gridMsg["sys.info.grid.calendar.titles.tue"] = "<spring:message code='sys.info.grid.calendar.titles.tue'  javaScriptEscape='true'/>";
	gridMsg["sys.info.grid.calendar.titles.wed"] = "<spring:message code='sys.info.grid.calendar.titles.wed'  javaScriptEscape='true'/>";
	gridMsg["sys.info.grid.calendar.titles.thur"] = "<spring:message code='sys.info.grid.calendar.titles.thur'  javaScriptEscape='true'/>";
	gridMsg["sys.info.grid.calendar.titles.fri"] = "<spring:message code='sys.info.grid.calendar.titles.fri'  javaScriptEscape='true'/>";
	gridMsg["sys.info.grid.calendar.titles.sat"] = "<spring:message code='sys.info.grid.calendar.titles.sat'  javaScriptEscape='true'/>";
	gridMsg["sys.info.grid.contextTexts.showonly"] = "<spring:message code='sys.info.grid.contextTexts.showonly'  javaScriptEscape='true'/>";
	gridMsg["sys.info.grid.contextTexts.showall.except"] = "<spring:message code='sys.info.grid.contextTexts.showall.except'  javaScriptEscape='true'/>";
	gridMsg["sys.info.grid.contextTexts.hide"] = "<spring:message code='sys.info.grid.contextTexts.hide'  javaScriptEscape='true'/>";
	gridMsg["sys.info.grid.contextTexts.clear.filter"] = "<spring:message code='sys.info.grid.contextTexts.clear.filter'  javaScriptEscape='true'/>";
	gridMsg["sys.info.grid.contextTexts.fixed.col"] = "<spring:message code='sys.info.grid.contextTexts.fixed.col'  javaScriptEscape='true'/>";
	gridMsg["sys.info.grid.contextTexts.clear.fixed.col"] = "<spring:message code='sys.info.grid.contextTexts.clear.fixed.col'  javaScriptEscape='true'/>";

	gridMsg["sys.warn.grid.pdf"] = "<spring:message code='sys.warn.grid.pdf'  javaScriptEscape='true'/>";
</script>