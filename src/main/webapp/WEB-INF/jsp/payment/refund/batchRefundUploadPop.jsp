<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">
$(document).ready(function () {
	setInputFile();
	
	$("#close_btn").click(fn_closePop);
	
	$("#payMode").multipleSelect("checkAll");
	
	fn_setAccNo();
	
});

function setInputFile(){//인풋파일 세팅하기
    $(".auto_file").append("<label><span class='label_text'><a href='#'>File</a></span><input type='text' class='input_text' readonly='readonly' /></label>");
}

function fn_closePop() {
    $("#bRefundUploadPop").remove();
}

function fn_setAccNo() {
	CommonCombo.make("accNo", "/payment/selectAccNoList.do", {payMode:$("#pPayMode").val()}, "", {
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
        Common.alert('Please select the payment mode.');
        return;
    }
    
    if(FormUtil.isEmpty($("#uploadfile").val())) {
    	Common.alert('Please select your CSV file.');
        return;
    }
    
    formData.append("csvFile", $("input[name=uploadfile]")[0].files[0]);
    formData.append("payMode", payMode);
    formData.append("accNo", accNo);
    formData.append("remark", remark);
    
    Common.ajaxFile("/payment/bRefundCsvFileUpload.do", formData, function(result){
        $('#paymentMode option[value=""]').attr('selected', 'selected');

        Common.alert(result.message);
        
        fn_closePop();
        
        fn_selectBatchRefundList();
    });
}
</script>

<div id="upload_popup_wrap" class="popup_wrap"><!-- popup_wrap start -->
    <header class="pop_header"><!-- pop_header start -->
        <h1>Batch Refund Upload</h1>
        <ul class="right_opt">
            <li><p class="btn_blue2"><a href="#" id="close_btn">CLOSE</a></p></li>
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
                        <th scope="row">Select your CSV File</th>
                        <td>
                        <div class="auto_file"><!-- auto_file start -->
                            <input type="file" title="file add" id="uploadfile" name="uploadfile" accept=".csv"/>
                        </div><!-- auto_file end -->
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Payment Mode</th>
                        <td>
                        <select class="" id="pPayMode" name="payMode" onchange="javascript:fn_setAccNo()">
                            <option value="106">Cheque (CHQ)</option>
                            <option value="107">Credit Card (CRC)</option>
                            <option value="108">Online Payment (ONL)</option>
                        </select>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Account No</th>
                        <td>
                        <select class="" id="accNo" name="accNo"></select>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Remark</th>
                        <td>
                        <textarea class="w100p" rows="2" style="height:auto" id="remark" name="remark"></textarea>
                        </td>
                    </tr>
                </tbody>
            </table><!-- table end -->
        </form>
        <ul class="center_btns mt20">
            <li><p class="btn_blue2 big"><a href="javascript:fn_uploadFile();">Upload File</a></p></li>
            <li><p class="btn_blue2 big"><a href="${pageContext.request.contextPath}/resources/download/payment/BatchRefundFormat.csv">Download CSV Format</a></p></li>
        </ul>
    </section>
    <!-- pop_body end -->
</div>
<!-- popup_wrap end -->
