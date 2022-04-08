<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<style type="text/css">
/* 커스텀 칼럼 스타일 정의 */
</style>
<script  type="text/javascript">
    var clmYyyy, clmMm;

    $(document).ready(function(){
        console.log("crcAdjustmentRejectPop.jsp")
    });

    $.fn.clearForm = function() {
        return this.each(function() {
            var type = this.type, tag = this.tagName.toLowerCase();
            if (tag === 'form'){
                return $(':input',this).clearForm();
            }
            if (type === 'text' || type === 'password' || type === 'hidden' || type === 'file' || tag === 'textarea'){
                this.value = '';
            }else if (type === 'checkbox' || type === 'radio'){
                this.checked = false;
            }else if (tag === 'select'){
                this.selectedIndex = 0;
            }
        });
    };

    function fn_rejectProceed(v) {
        console.log("crcAdjustmentRejectPop :: fn_rejectProceed");
        if(v == "P") {
            // v = P (Proceed)
            if($("#rejctResn").val() == null && $("#rejctResn").val() == "") {
                Common.alert("Reject reason cannot be empty");
                return false;
            }

            var data = {
                action : "J",
                rejResn : $("#rejctResn").val(),
                adjNo : $("#adjNo").val()
            };

            Common.ajax("POST", "/eAccounting/creditCard/approvalUpdate.do", data, function(result) {
                $("#adjForm").clearForm();
                $("#rejctResn").val("");
                $("#crcAdjustmentRejectPop").remove();

                if(result.code == "00") {
                    Common.alert("Allowance adjustment successfully rejected");
                } else {
                    Common.alert("Allowance adjustment fail to reject");
                }
            });

        } else {
            // v = C (Cancel)
            $("#adjForm").clearForm();
            $("#rejctResn").val("");
            $("#crcAdjustmentRejectPop").remove();
        }
    }
    // ========== Approve/Reject - End ==========

</script>

<div id="popup_wrap" class="popup_wrap msg_box">
    <header class="pop_header">
        <h1>Reject Reason</h1>
        <ul class="right_opt">
            <li><p class="btn_blue2"><a href="#"><spring:message code="expense.CLOSE" /></a></p></li>
        </ul>
    </header>

    <section class="pop_body">
        <input type="hidden" id="adjNo" name="adjNo">
        <p class="msg_txt">
            <spring:message code="rejectionWebInvoiceMsg.registMsg" />
            <textarea cols="20" rows="5" id="rejctResn" placeholder="Reject reason max 400 characters"></textarea>
        </p>

        <ul class="center_btns">
            <li><p class="btn_blue"><a href="#" onclick="javascript:fn_rejectProceed('P')">Proceed</a></p></li>
            <li><p class="btn_blue"><a href="#" onclick="javascript:fn_rejectProceed('C')">Cancel</a></p></li>
        </ul>
    </section>
</div>