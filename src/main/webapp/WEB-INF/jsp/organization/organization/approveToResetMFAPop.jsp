<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<div id="popup_wrap" class="popup_wrap">
    <header class="pop_header">
        <h1>MFA Request Approval</h1>
        <ul class="right_opt">
            <li><p class="btn_blue2"><a href="#"><spring:message code="sal.btn.close" /></a></p></li>
        </ul>
    </header>
    <section class="pop_body">
        <div id="approvalGrid"></div>
    </section>
</div>

<script>
	const approvalGrid = GridCommon.createAUIGrid("approvalGrid", [
	    {dataField: "reqno", headerText: "Request No.", editable: false},
	    {dataField: "userName", headerText: "Requestor", editable: false},
	    {dataField: "startDt", headerText: "Start date", editable: false},
	    {dataField: "endDt", headerText: "End Date", editable: false},
	    {dataField: "remark", headerText: "Reason", editable: false},
	    {editable: false, renderer: {
	    	type: "ButtonRenderer",
	    	labelText: "Approve",
	    	onclick: function(r, c, b, i) {
	    		const formData = new FormData();
	            formData.append("data",JSON.stringify({reqId: i.reqId, approve: true}));
	    	    Common.confirm("Are you sure to approve " + i.reqno + "?", () => {
	    	    	Common.showLoader()
	    	    	fetch("/organization/approveToResetMFA.do", {
	                    method: "POST",
	                    body: formData
	                })
	                .then((r) => {
	                    return r.json()
	                })
	                .then(resp => {
	                	if (resp.code == "00") {
	                		Common.alert("Succesfully Approved.")
	                		AUIGrid.removeRow(approvalGrid, r)
	                	} else {
	                		Common.alert("Approval Failed.")
	                	}
	                })
	                .finally(Common.removeLoader)
	    	    })
	    	}
	    }},
        {editable: false, renderer: {
            type: "ButtonRenderer",
            labelText: "Reject",
            onclick: function(r, c, b, i) {
                const formData = new FormData();
                formData.append("data",JSON.stringify({reqId: i.reqId, approve: false}));
                Common.confirm("Are you sure to reject " + i.reqno + "?", () => {
                    Common.showLoader()
                    fetch("/organization/approveToResetMFA.do", {
                        method: "POST",
                        body: formData
                    })
                    .then((r) => {
                        return r.json()
                    })
                    .then(resp => {
                        if (resp.code == "00") {
                            Common.alert("Succesfully Rejected.")
                            AUIGrid.removeRow(approvalGrid, r)
                        } else {
                            Common.alert("Reject Failed.")
                        }
                    })
                    .finally(Common.removeLoader)
                })
            }
        }}
	], '', {
		softRemoveRowMode: false
	})

	AUIGrid.setGridData(approvalGrid, ${requests})
</script>