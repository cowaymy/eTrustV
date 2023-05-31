<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<div id="popup_wrap" class="popup_wrap">
    <header class="pop_header">
        <h1>ePR Cancellation</h1>
        <ul class="right_opt">
          <li><p class="btn_blue2"><a href="#" id="cancelEPR">Submit</a></p></li>
          <li><p class="btn_blue2"><a href="#" id="btnGuarViewClose">CLOSE</a></p></li>
        </ul>
    </header>
    <section class="pop_body">
        <table class="type1">
            <colgroup>
                <col style="width: 130px;"/>
                <col style="width: *;"/>
                <col style="width: 130px;"/>
                <col style="width: *;"/>
            </colgroup>
            <tr>
                <th>Title</th>
                <td colspan="3" id="ePRTitle"></td>
            </tr>
            <tr>
                <th>ePR No</th>
                <td id="ePRNo"></td>
                <th>Key in date</th>
                <td class="ePRKeyin"></td>
            </tr>
            <tr>
                <th>Purpose / Remark</th>
                <td colspan="3">
                    <textarea maxlength="200" id="remark"></textarea>
                </td>
            </tr>
        </table>
    </section>
</div>

<script>
    const defaultEPR = ${request}

    $("#ePRTitle").text(defaultEPR.title)
    $(".ePRKeyin").text(defaultEPR.submitDt)
    $("#ePRNo").text("PR" + ((defaultEPR.requestId + "").padStart(5, '0')))

    $("#cancelEPR").click(() => {
    	if (!$("#remark").val().trim()) {Common.alert("Kindly insert remark"); return}
    	Common.confirm("Cancelled PR will not be recoverable.<br/>Confirm to Cancel : " + "PR" + ((defaultEPR.requestId + "").padStart(5, '0')), () => {
    		Common.showLoader()
    		fetch("/eAccounting/ePR/cfmCancelEPR.do", {
    			method: "POST",
    			body: JSON.stringify({id: defaultEPR.requestId, remark: $("#remark").val()}),
    			headers: {"Content-Type": "application/json"}
    		})
    		.then(resp => resp.json())
    		.then(res => {
    			if (res.success) {
    				Common.alert("ePR Cancelled", () => {
    					$("#btnGuarViewClose").click()
                        getRequests()
    				})
    			}
    		})
    		.finally(() => {
    			Common.removeLoader()
    		})
    	})
    })
</script>