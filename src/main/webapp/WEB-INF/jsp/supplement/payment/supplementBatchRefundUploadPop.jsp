<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">
$(document).ready(function () {
	setInputFile();

	$("#close_btn").click(fn_closePop);

	CommonCombo.make("pPayMode", "/supplement/payment/selectCodeList.do", null, "", {
        id: "code",
        name: "codeName",
        type:"S"
    });

	fn_setAccNo();

});

function setInputFile(){
    $(".auto_file").append("<label><span class='label_text'><a href='#'>File</a></span><input type='text' class='input_text' readonly='readonly' /></label>");
}

function fn_closePop() {
    $("#bRefundUploadPop").remove();
}

function fn_setAccNo() {
	CommonCombo.make("accNo", "/supplement/payment/selectAccNoList.do", {payMode:$("#pPayMode").val()}, "", {
        id: "codeId",
        name: "codeName",
        type:"S"
    });
}

function fn_uploadFile(){
    var formData = new FormData();
    var payMode = $("#pPayMode option:selected").val();
    var accNo = $("#accNo").val();
    var remark = $("#remark").val();

    if(payMode == ""){
        Common.alert('<spring:message code="pay.alert.selectPayMode"/>');
        return;
    }

    if(FormUtil.isEmpty($("#uploadfile").val())) {
    	Common.alert('<spring:message code="pay.alert.selectCsvFile"/>');
        return;
    }

    formData.append("csvFile", $("input[name=uploadfile]")[0].files[0]);
    formData.append("payMode", payMode);
    formData.append("accNo", accNo);
    formData.append("remark", remark);

    Common.ajaxFile("/supplement/payment/bRefundCsvFileUpload.do", formData, function(result){
        $('#paymentMode option[value=""]').attr('selected', 'selected');
        Common.alert(result.message);
        fn_closePop();
        fn_selectBatchRefundList();
    });
}
</script>

<div id="upload_popup_wrap" class="popup_wrap"><!-- popup_wrap start -->
    <header class="pop_header"><!-- pop_header start -->
        <h1><spring:message code='supplement.title.batchRefundUpload'/></h1>
        <ul class="right_opt">
            <li><p class="btn_blue2"><a href="#" id="close_btn"><spring:message code='sys.btn.close'/></a></p></li>
        </ul>
    </header><!-- pop_header end -->
    <section class="pop_body"><!-- pop_body start -->
        <form action="#" method="post">
            <table class="type1"><!-- table start -->
                <caption>table</caption>
                <colgroup>
                    <col style="width:150px" />
                    <col style="width:*" />
                </colgroup>
                <tbody>
                    <tr>
                        <th scope="row"><spring:message code='supplement.text.selectCsvFile'/></th>
                        <td>
                        <div class="auto_file"><!-- auto_file start -->
                            <input type="file" title="file add" id="uploadfile" name="uploadfile" accept=".csv"/>
                        </div><!-- auto_file end -->
                        </td>
                    </tr>
                    <tr>
                        <th scope="row"><spring:message code='supplement.head.paymode'/></th>
                        <td>
                        <select class="" id="pPayMode" name="payMode" onchange="javascript:fn_setAccNo()"></select>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row"><spring:message code='supplement.head.accountNo'/></th>
                        <td>
                        <select class="" id="accNo" name="accNo"></select>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row"><spring:message code='supplement.text.remark'/></th>
                        <td>
                        <textarea class="w100p" rows="2" style="height:auto" id="remark" name="remark"></textarea>
                        </td>
                    </tr>
                </tbody>
            </table><!-- table end -->
        </form>
        <ul class="center_btns mt20">
            <li><p class="btn_blue2 big"><a href="javascript:fn_uploadFile();"><spring:message code='supplement.btn.uploadFile'/></a></p></li>
            <li><p class="btn_blue2 big"><a href="${pageContext.request.contextPath}/resources/download/supplement/SupplementBatchRefundFormat.csv"><spring:message code='supplement.btn.downloadCsvFormat'/></a></p></li>
        </ul>
    </section>
    <!-- pop_body end -->
</div>
<!-- popup_wrap end -->
