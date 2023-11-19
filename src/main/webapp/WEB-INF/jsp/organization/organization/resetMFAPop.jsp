<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<div class="popup_wrap size">
    <header class="pop_header">
        <h1>Reset MFA OTP</h1>
        <ul class="right_opt">
            <li><p class="btn_blue2"><a href="#" id="closeReset"><spring:message code="sal.btn.close" /></a></p></li>
        </ul>
    </header>
    <section class="pop_body">
        <table class="type1">
            <colgroup>
                <col style="width: 130px;"/>
                <col style="width: *;"/>
            </colgroup>
            <tbody>
                <tr>
                    <th>Mem Code</th>
                    <td><input type="text" id="mfaMemCode" class="readonly" readonly="readonly"/><img onclick="bindApprovalEvent()" src="${pageContext.request.contextPath}/resources/images/common/normal_search.png"/></td>
                </tr>
            </tbody>
        </table>
        <ul class="center_btns">
            <li><p class="btn_blue2 big">
                <a href="#" onclick="resetMemberMfa()">Reset</a>
            </p></li>
            <li><p class="btn_blue2 big">
                <a href="#" onclick="getResetHist()">Search History</a>
            </p></li>
        </ul>
        <div id="mfaResetList" style="width: 100%; height: 500px; margin: 0 auto;"></div>
    </section>
</div>


<script>

function resetMemberMfa() {
    const mfaMemCode = $("#mfaMemCode").val().trim()
    if (mfaMemCode) {
        Common.confirm("Are you sure to reset this MFA OTP ? Member Code : " + mfaMemCode, () => {
            Common.showLoader()
            fetch("/organization/resetMfa.do", {
                method: "POST",
                headers: {"Content-Type": "application/json"},
                body: JSON.stringify({memCode: mfaMemCode})
            })
            .then(r => r.json())
            .then(d => {
                 Common.alert(d.message,()=>{$("#closeReset").click()})
            })
            .finally(() => {
                Common.removeLoader()
            })
        })
    }else{
    	Common.alert("Please search member to reset");
    	return;
    }
}

function bindApprovalEvent() {
    Common.popupDiv("/common/memberPop.do", {callPrgm:"TR_BOOK_ASSIGN"}, null, true)
}

function fn_loadOrderSalesman(_x, _y, _z, memCode, name) {
    $("#mfaMemCode").val(memCode);
}

function clearGrid() {
    document.querySelector("#mfaResetList").innerHTML = ""
}

function getResetHist() {
    const mfaMemCode = $("#mfaMemCode").val().trim()
    if (mfaMemCode) {
        Common.showLoader()
        fetch("/organization/getMfaResetHist.do?memCode=" + mfaMemCode)
        .then(r => r.json())
        .then(d => {
        	console.log(d)

                clearGrid()
                AUIGrid.create("#mfaResetList", [
                    {dataField: "resetBy", headerText: "Reset By"},
                    {dataField: "resetDt", headerText: "Reset Date",dataType: "date", formatString: "yyyy/mm/dd hh:mm:ss"}
                ], {
                    editable: false,
                    usePaging: true
                })
                AUIGrid.setGridData("#mfaResetList", d)
        })
        .finally(() => {
            Common.removeLoader()
        })
    }
}

</script>