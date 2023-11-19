<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>


<div id="popup_wrap" class="popup_wrap">
	<header class="pop_header">
		<h1>MFA Request</h1>
		<ul class="right_opt">
		    <li><p class="btn_blue2"><a href="#"><spring:message code="sal.btn.close" /></a></p></li>
		</ul>
	</header>
    <section class="pop_body">
        <section class="tap_wrap">
            <ul class="tap_type1 num4 myTab">
                <li><a id="aTabBI" href="#" class="on">Requests</a></li>
                <li><a id="aTabBI" href="#">Submit Requests</a></li>
            </ul>
            <div class="tab" data-tab="Requests">
                <div id="requestsGrid"></div>
            </div>
            <div class="tab" data-tab="Submit Requests">
		        <form id="mfaRequestForm">
			         <table class="type1">
			            <colgroup>
			                <col style="width: 130px;"/>
			                <col style="width: *;"/>
			                <col style="width: 130px;"/>
			                <col style="width: *;"/>
			            </colgroup>
			            <tbody>
			                <tr>
			                    <th>Start Date</th>
			                    <td><input type="text" id="mfaStartDt" class="j_date w100p" name="mfaStartDt" placeholder="DD/MM/YYYY" /></td>

			                    <th>End Date</th>
			                    <td><input type="text" id="mfaEndDt" class="j_date w100p" name="mfaEndDt" placeholder="DD/MM/YYYY" /></td>
			                </tr>
			                <tr >
			                    <th scope="row">Purpose / Remark</th>
			                    <td colspan="3"><textarea id="mfaRemark" maxlength="200" placeholder="Enter up to 200 characters"></textarea></td>
			                </tr>
			            </tbody>
			        </table>
		        </form>
		        <br/>
		        <h1 class="pop_header">MFA Approval line</h1>
		        <br/>
		        <article class="tap_area">

		            <table class="type1"><tbody><th><span class="must">* Approval doesn't have to be filled completely, final approval will be the last entry.</span></th></tbody></table>
		            <div id="approvalGrid"></div>
		        </article>

			    <ul class="center_btns">
				    <li><p class="btn_blue2 big"><a id="mfaSubmit">Save</a></p></li>
				    <li><p class="btn_blue2 big"><a href="javascript:void(0);" onclick="javascript:fn_close()">Cancel</a></p></li>
			    </ul>
            </div>
        </section>
    </section>
</div>


<script>

    const changeTab = (e) => {
    	$(".tap_wrap .tab").hide()
        $('*[data-tab="' + e.target.innerText + '"]').show()
        AUIGrid.resize(requestsGrid)
        AUIGrid.resize(approvalGrid)
    }

    $(".myTab li a").click(changeTab)

    let apprvRow;

    const requestsGrid = GridCommon.createAUIGrid("requestsGrid", [
        {dataField: "reqno", headerText: "Request No.", editable: false},
        {dataField: "userName", headerText: "Requestor", editable: false},
        {dataField: "startDt", headerText: "Start date", editable: false, dataType: "date", formatString: "yyyy/mm/dd"},
        {dataField: "endDt", headerText: "End Date", editable: false, dataType: "date", formatString: "yyyy/mm/dd"},
        {dataField: "remark", headerText: "Reason", editable: false},
        {dataField: "status", headerText: "Status", editable: false, filter: {
        	enable: true,
        	showIcon: true,
        	displayFormatValues: true
        }},
        {dataField: "name", headerText: "Pending PIC Approval", editable: false}
    ])

    AUIGrid.setGridData(requestsGrid, ${requests}.map(item => ({...item, status: item.reject ? "Rejected" : item.active ? "In Progress" : "Approved"})))

	const approvalGrid = GridCommon.createAUIGrid("approvalGrid", [
	    {dataField: "memCode", headerText: 'User ID', editable: false, renderer: {
	        type: "TemplateRenderer"
	    },
	    labelFunction: function (rowIndex, _x, value) {
	        return `<div class="apprvContainer" style='display: flex; justify-content: center; align-items: center;'><p style="flex: 1;">` + value + `</p><img onclick="bindApprovalEvent(` + rowIndex + `)" src="${pageContext.request.contextPath}/resources/images/common/normal_search.png"/></div>`
	    }},
	    {dataField: "name", headerText: 'Name', editable: false},
	    {editable: false, renderer: {
	        type: "ButtonRenderer",
	        labelText: "Clear",
	        onclick: function (e) {
	            if (e != 4) {
	                AUIGrid.updateRow(approvalGrid, {memCode: "", name: ""}, e)
	            }
	        }
	    }}
	], '', {
	    usePaging: true,
	    pageRowCount: 20,
	    editable: true,
	    headerHeight: 60,
	    showRowNumColumn: true,
	    wordWrap: true,
	    showStateColumn: false,
	    softRemoveRowMode: false,
	    enableSorting: false
	});


    function bindApprovalEvent(i) {
        if (i == 4) return
        apprvRow = i
        Common.popupDiv("/common/memberPop.do", {callPrgm:"TR_BOOK_ASSIGN"}, null, true)
    }

    AUIGrid.setGridData(approvalGrid, [{},{},{},{}])
    function fn_loadOrderSalesman(_x, _y, _z, memCode, name) {
        if (!AUIGrid.getColumnValues(approvalGrid, "memCode", true).find((m) => m == memCode)) {
            AUIGrid.updateRow(approvalGrid, {memCode, name}, apprvRow)
        } else {
            Common.alert("User already in approval line.")
        }
    }

    const mfaValidation = () => {
    	let mfaStartDt = $("#mfaStartDt").val() , mfaEndDt = $("#mfaEndDt").val() , mfaRemark = $("#mfaRemark").val();
        let members = AUIGrid.getGridData(approvalGrid).filter(i => i.memCode);
    	if (!mfaStartDt || mfaStartDt.trim().length == 0) {
            Common.alert("Please fill in Start Date");
            return false;
        }

        if (!mfaEndDt || mfaEndDt.trim().length == 0) {
            Common.alert("Please fill in End Date");
            return false;
        }

        if (!mfaRemark || mfaEndDt.trim().length == 0) {
            Common.alert("Please fill in Purpose / Remark");
            return false;
        }

        if (members.length < 1) {
        	 Common.alert("Please choose your approval.");
             return false;
        }

        return true;

    }

    $("#mfaSubmit").click(() => {
        if(mfaValidation()){
        	Common.showLoader();
            let [startDt, endDt, remark, members] = [moment($("#mfaStartDt").val(), "DD/MM/YYYY").format("YYYY/MM/DD") , moment($("#mfaEndDt").val(), "DD/MM/YYYY").format("YYYY/MM/DD"), $("#mfaRemark").val(), AUIGrid.getGridData(approvalGrid).filter(i => i.memCode)];
            const formData = new FormData();
            formData.append("data",JSON.stringify({startDt, endDt, remark, members}));

            fetch("/organization/submitMfaResetRequest.do", {
                method: "POST",
                body: formData
            })
            .then((r) => {
                return r.json()
            })
           .then(resp => {
        	   Common.alert(resp.message,()=>{location.reload()})
            })
            .finally(Common.removeLoader)
        }
    });

    changeTab({target: {innerText: "Requests"}})

</script>