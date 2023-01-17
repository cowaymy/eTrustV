<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script>
    fetch("/common/selectCodeList.do?groupCode=545")
    .then(r => r.json())
    .then(resp => {
    	doDefCombo(resp, '', '_ticketType','S')
    })

    $("#saveBtn").click((event) => {
    	event.preventDefault()
        Common.showLoader()

    	const ordNo = $("#_ordNo").val()
    	const content = $("#_content").val()
    	const ticketType = $("#_ticketType").val()

    	if (!ordNo.trim()) {
    		Common.alert('Please keyin Order Number.')
    		return
    	}

    	if (!content.trim()) {
    		Common.alert('Please keyin content.')
    		return
    	}

    	if (!ticketType.trim()) {
            Common.alert('Please choose ticket type.')
            return
        }

    	$.ajax({
    		type: "POST",
    		url: "/sales/ccp/createCCPTicket.do",
    		data: JSON.stringify({ordNo, content, ticketType}),
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
    			$('#newTicketClose').click()
    		}
    	})
    })
</script>

<div id="popup_wrap" class="popup_wrap">
    <header class="pop_header">
        <h1>CCP Ticket</h1>
		<ul class="right_opt">
		    <li><p class="btn_blue2"><a href="#" id="newTicketClose"><spring:message code="sal.btn.close" /></a></p></li>
		</ul>
    </header>
    <section class="pop_body">
        <table class="type1">
            <tbody>
                <tr>
                    <th><spring:message code="sal.text.ordNo" /></th>
                    <td><input type="text" name="ordNo" id="_ordNo"/></td>
                </tr>
                <tr>
                    <th>Ticket Type</th>
                    <td><select name="ticketType" id="_ticketType"></select></td>
                </tr>
                <tr>
                    <th>Ticket Enquiry</th>
                    <td><textarea maxlength=160 placeholder="Max 160 words." name="content" id="_content"/></td>
                </tr>
            </tbody>
        </table>
        <ul class="center_btns">
		    <li><p class="btn_blue"><a id="saveBtn" name="ticketSaveBtn" href="#">Save</a></p></li>
		</ul>
    </section>
</div>