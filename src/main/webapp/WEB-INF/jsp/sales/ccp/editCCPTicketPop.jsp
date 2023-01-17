<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<div id="popup_wrap" class="popup_wrap">
    <header class="pop_header">
        <h1>CCP Ticket</h1>
        <ul class="right_opt">
            <li><p class="btn_blue2"><a href="#" id="editTicketClose"><spring:message code="sal.btn.close" /></a></p></li>
        </ul>
    </header>
    <section class="pop_body">
        <section class="tap_wrap">
            <ul class="tap_type1 num4">
                <li><a href="#" class="on">Ticket Details</a></li>
                <li><a href="#" onClick="(() => {AUIGrid.resize(logGrid, 942, 380)})()">Ticket Logs</a></li>
            </ul>
	        <article class="tap_area">
		        <table class="type1">
		            <tbody>
		                <tr>
		                    <th>Organization Info</th>
		                    <td>
		                        <c:forEach var="member" items="${orgDetails}">
						            <c:out value="${member.code} ${member.name}"/><br/>
						        </c:forEach>
		                    </td>
		                </tr>
		                <tr>
		                    <th>Ticket Type</th>
		                    <td id="_ticketType"></td>
		                </tr>
		                <tr>
		                    <th>Details of ticket</th>
		                    <td id="_ticketQuery"></td>
		                </tr>
		                <c:if test="${ticketDetails.status != 34}">
			                <tr>
			                    <th>Feedback</th>
			                    <td><textarea name="content" id="_content"></textarea></td>
			                </tr>
			                <tr>
			                    <th>Status</th>
			                    <td><select name="status" id="_status"></select></td>
			                </tr>
			            </c:if>
		            </tbody>
		        </table>
		        <c:if test="${ticketDetails.status != 34}">
			        <ul class="center_btns">
			            <li><p class="btn_blue"><a id="saveBtn" name="ticketSaveBtn" href="#">Save</a></p></li>
			        </ul>
		        </c:if>
	        </article>
	        <c:set var="logs" value="${ticketDetails.logs}" />
	        <%@ include file="/WEB-INF/jsp/sales/ccp/include/ticketLog.jsp" %>
        </section>
    </section>
</div>

<script>
    const ticketStatus = [{codeId: 1, codeName: 'Active'}, {codeId: 34, codeName: 'Solved'}, {codeId: 35, codeName: 'Unsolved'}]

    $("#saveBtn").click((event) => {
        event.preventDefault()
        const seq = `${ticketId}`
        const content = $('#_content').val()
        const status = $('#_status').val()

        if (!content.trim()) {
            Common.alert('Please keyin content.')
            return
        }

        if (!status.trim()) {
            Common.alert('Please choose status.')
            return
        }

        $.ajax({
            type: "POST",
            url: "/sales/ccp/updateCCPTicket.do",
            data: JSON.stringify({seq, content, status}),
            contentType: 'application/json',
            success(res) {
                Common.alert(res.message)
            },
            error(xhr, status, err) {
                Common.alert(xhr.responseJSON.message)
            },
            complete() {
                Common.removeLoader()
                document.getElementById('ccpTicketSearchBtn').click()
                $('#editTicketClose').click()
            }
        })
    })

    const logs = [
        <c:forEach var="log" items="${ticketDetails.logs}">
            {
            	logContent: `<c:out value="${log.logContent}" />`
            },
        </c:forEach>
    ]

    $(() => {
    	$("#_ticketType").text("${ticketDetails.code}")
        $("#_ticketQuery").text(logs[logs.length - 1].logContent)

        <c:if test="${ticketDetails.status != 34}">
	        doDefCombo(ticketStatus.filter(s => s.codeId != 1), '35', '_status','S')
        </c:if>
    })
</script>