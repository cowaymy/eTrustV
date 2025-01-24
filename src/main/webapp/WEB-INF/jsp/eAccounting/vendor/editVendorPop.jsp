<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<style type="text/css">
/* 커스텀 행 스타일 */
.my-cell-style {
    background:#FF0000;
    color:#005500;
    font-weight:bold;
}
/* 커스텀 칼럼 스타일 정의 */
.aui-grid-user-custom-left {
    text-align:left;
}
/* 커스텀 칼럼 스타일 정의 */
.aui-grid-user-custom-right {
    text-align:right;
}
/* 특정 칼럼 드랍 리스트 왼쪽 정렬 재정의*/
#editVendorPop_grid_wrap-aui-grid-drop-list-taxCode .aui-grid-drop-list-ul {
     text-align:left;
 }
</style>
<script type="text/javascript">
console.log("editVendorPop");
var newGridID;
var selectRowIdx;
var callType = "${callType}";
var flg = "${flg}";
var atchFileGrpId = "${atchFileGrpId}";
var appvPrcssStusCode = "${appvPrcssStusCode}";
var vendorAccId = "${vendorAccId}";
var conditionalCheck = 0; //0:No need to check; 1:Need to check
var removeOriFileName = new Array();
var gridDataList = new Array();
var currList = ["MYR", "USD"];
<c:forEach var="data" items="${venforInfo}">
var obj = {
		newReqNo : "${data.reqNo}"
        ,vendorGroup : "${data.vendorGroup}"
        ,keyDate : "${data.keyDate}" //change
        ,newCostCenter : "${data.newCostCenter}"
        ,userName : "${data.userName}"
        ,regCompName : "${data.regCompName}"
        ,regCompNo : "${data.regCompNo}"
        ,street : "${data.addStreet}"
        ,houseNo : "${data.addHouseLotNo}"
        ,postalCode : "${data.addPostalCode}"
        ,city : "${data.addCity}"
        ,vendorCountry : "${data.addCountry}"
        ,paymentTerms : "${data.payTerm}"
        ,others : "${data.payOth}"
        ,bankCountry : "${data.bankCountry}"
        ,bankAccHolder : "${data.bankAccHolder}"
        ,bankList : "${data.bank}"
        ,bankAccNo : "${data.bankAccNo}"
        ,bankBranch : "${data.bankBranch}"
        ,swiftCode : "${data.swiftCode}"
        ,designation : "${data.contactDesignation}"
        ,vendorName : "${data.vendorName}"
        ,vendorPhoneNo : "${data.vendorPhoneNo}"
        ,vendorEmail : "${data.vendorEmail}"
        ,vendorType : "${data.vendorType}"
};

</c:forEach>
//file action list
var update = new Array();
var remove = new Array();
var attachmentList = new Array();
<c:forEach var="file" items="${attachmentList}">
var obj = {
		atchFileGrpId : "${file.atchFileGrpId}"
		,atchFileId : "${file.atchFileId}"
		,atchFileName : "${file.atchFileName}"
};
attachmentList.push(obj);
</c:forEach>


//그리드 속성 설정
var myGridPros = {
    // 페이징 사용
    usePaging : true,
    // 한 화면에 출력되는 행 개수 20(기본값:20)
    pageRowCount : 20,
    editable : true,
    showStateColumn : true,
    softRemovePolicy : "exceptNew", //사용자추가한 행은 바로 삭제
    softRemoveRowMode : false,
    rowIdField : "clmSeq",
    headerHeight : 40,
    height : 160,
    // 셀 선택모드 (기본값: singleCell)
    selectionMode : "multipleCells"

};

$(document).ready(function () {
	var appvPrccNo = "${vendorInfo.appvPrcssNo}";
	var vendorCountry = "${vendorInfo.addCountry}";
	var bankCountry = "${vendorInfo.bankCountry}";
	var bankList = "${vendorInfo.bank}";
	var paymentMethod = "${vendorInfo.payType}";
	var designation = "${vendorInfo.contactDesignation}";
	var editorCostCenter = "${SESSION_INFO.costCentr}";

	var txtPaymentMethod = $("#paymentMethod :selected").val();
    if(txtPaymentMethod == 'CASH' || txtPaymentMethod == 'CHEQ')
    {
          $("#bankListHeader").replaceWith('<th id="bankListHeader" scope="row"> Bank</th>');
          $("#bankAccHolderHeader").replaceWith('<th id="bankAccHolderHeader" scope="row">Account Holder</th>');
          $("#bankAccNoHeader").replaceWith('<th id="bankAccNoHeader" scope="row">Bank Account Number</th>');
          headerCheck = 0;

    }
    else
    {
        $("#bankListHeader").replaceWith('<th id="bankListHeader" scope="row"> Bank<span class="must">*</span></th>');
        $("#bankAccHolderHeader").replaceWith('<th id="bankAccHolderHeader" scope="row">Account Holder<span class="must">*</span></th>');
        $("#bankAccNoHeader").replaceWith('<th id="bankAccNoHeader" scope="row">Bank Account Number<span class="must">*</span></th>');
        headerCheck = 1;
    }

	if(flg == 'M')
	{
		setInputFile2();
	}
	$("#vendorCountry option[value='"+ vendorCountry +"']").attr("selected", true);
	$("#bankCountry option[value='"+ bankCountry +"']").attr("selected", true);
	$("#bankList option[value='"+ bankList +"']").attr("selected", true);
	$("#paymentMethod option[value='"+ paymentMethod +"']").attr("selected", true);
	$("#designation option[value='"+ designation +"']").attr("selected", true);


	//doGetCombo('/common/selectCodeList.do', '17', designation, 'designation', 'S' , ''); // Customer Initial Type Combo Box

    $("#tempSave").click(fn_tempSave);
    $("#submitPop").click(fn_submit);
    $("#supplier_search_btn").click(fn_popSupplierSearchPop);
    $("#costCenter_search_btn").click(fn_popCostCenterSearchPop);

    fn_setCostCenterEvent();
    fn_setSupplierEvent();

   // if(gridDataList.length > 0) {
     //   fn_setGridData(gridDataList);
   // }
    // 수정시 첨부파일이 없는경우 디폴트 파일태그 생성
    console.log(attachmentList);
    if(flg != 'M')
    {
    	if(attachmentList.length <= 0) {
            setInputFile2();
        }
    }

    // 파일 다운
    $(".input_text").dblclick(function() {
    	var oriFileName = $(this).val();
    	var fileGrpId;
    	var fileId;
    	for(var i = 0; i < attachmentList.length; i++) {
    		if(attachmentList[i].atchFileName == oriFileName) {
    			fileGrpId = attachmentList[i].atchFileGrpId;
    			fileId = attachmentList[i].atchFileId;
    		}
    	}
    	fn_atchViewDown(fileGrpId, fileId);
    });
    // 파일 수정
    $("#form_newVendor :file").change(function() {
        var div = $(this).parents(".auto_file2");
        var oriFileName = div.find(":text").val();
        console.log(oriFileName);
        for(var i = 0; i < attachmentList.length; i++) {
            if(attachmentList[i].atchFileName == oriFileName) {
                update.push(attachmentList[i].atchFileId);
                console.log(JSON.stringify(update));
            }
        }
    });
    // 파일 삭제
    $(".auto_file2 a:contains('Delete')").click(function() {
        var div = $(this).parents(".auto_file2");
        var oriFileName = div.find(":text").val();
        console.log(oriFileName);
        for(var i = 0; i < attachmentList.length; i++) {
            if(attachmentList[i].atchFileName == oriFileName) {
                remove.push(attachmentList[i].atchFileId);
                console.log(JSON.stringify(remove));
            }
        }
    });

    /*$('#vendorCountry').change(function() {
        $("#vendorCountry").remove();
        $("#form_newVendor").append("<input type='hidden' name='vendorCountryUpd' id='vendorCountryUpd'>");
        $("#vendorCountryUpd").val($("#vendorCountry").val());
    });*/

    if(bankCountry != 'MY')
   	{
    	fn_jsFunction();
    	$("#bankList").val('${vendorInfo.bank}');
   	}
});

function fn_close(){
    $("#popup_wrap").remove();
}

function fn_jsFunction1(){
    var txtPaymentMethod = $("#paymentMethod :selected").val();
    if(txtPaymentMethod == 'CASH' || txtPaymentMethod == 'CHEQ')
    {
          $("#bankListHeader").replaceWith('<th id="bankListHeader" scope="row"> Bank</th>');
          $("#bankAccHolderHeader").replaceWith('<th id="bankAccHolderHeader" scope="row">Account Holder</th>');
          $("#bankAccNoHeader").replaceWith('<th id="bankAccNoHeader" scope="row">Bank Account Number</th>');
          headerCheck = 0;

    }
    else
    {
        $("#bankListHeader").replaceWith('<th id="bankListHeader" scope="row"> Bank<span class="must">*</span></th>');
        $("#bankAccHolderHeader").replaceWith('<th id="bankAccHolderHeader" scope="row">Account Holder<span class="must">*</span></th>');
        $("#bankAccNoHeader").replaceWith('<th id="bankAccNoHeader" scope="row">Bank Account Number<span class="must">*</span></th>');
        headerCheck = 1;
    }
    }

function fn_jsFunction(){
    var txtBankCountry = $("#bankCountry :selected").val()
    var txtVendorCountry = $("#vendorCountry :selected").val()

    if(txtBankCountry != 'MY')
    {
        $("#bankList").replaceWith('<input type="text" class="w100p" id="bankList" name="bankList" style="text-transform:uppercase"/>');
        $("#swiftCodeHeader").html('Swift Code<span class="must">*</span>');
        $("#bankAccNo").attr('maxLength',100);
        conditionalCheck = 1;
    }
    if(txtBankCountry == 'MY')
    {
        $("#bankList").replaceWith('<select class="w100p" id="bankList" name="bankList"><c:forEach var="list" items="${bankList}" varStatus="status"><option value="${list.code}">${list.name}</option></c:forEach></select>');
        $("#swiftCodeHeader").html('Swift Code');
        conditionalCheck = 0;
        if($("#bankAccNo").val().length > 16)
        {
            var strBankAccNo = $("#bankAccNo").val();
            strBankAccNo = strBankAccNo.substr(0,16);
            $("#bankAccNo").val(strBankAccNo);
        }
        $("#bankAccNo").attr('maxLength',16);
    }

    if(txtVendorCountry != 'MY')
    {
        //$("#paymentMethod option[value='TTRX']").attr('selected', 'selected');
        $("#paymentMethod").val("TTRX").attr("selected", "selected");
    }
    if(txtVendorCountry == 'MY')
    {
        //$("#paymentMethod option[value='OTRX']").attr('selected', 'selected');
        $("#paymentMethod").val("OTRX").attr("selected", "selected");
    }
}

/* 인풋 파일(멀티) */
function setInputFile2(){//인풋파일 세팅하기
    console.log("setInputFile2");
	$(".auto_file2").append("<label><input type='text' class='input_text' readonly='readonly' /><span class='label_text'><a href='#'>File</a></span></label>");
}

function fn_approveLinePop() {
	var checkResult = fn_checkEmpty();
    if(!checkResult){
        return false;
    }

    var length = AUIGrid.getGridData(newGridID).length;
    if(length > 0) {
        for(var i = 0; i < length; i++) {
            var availableVar = {
                    costCentr : $("#newCostCenter").val(),
                    stYearMonth : $("#keyDate").val().substring(3),
                    stBudgetCode : AUIGrid.getCellValue(newGridID, i, "budgetCode"),
                    stGlAccCode : AUIGrid.getCellValue(newGridID, i, "glAccCode")
                }

            var availableAmtCp = 0;
            Common.ajax("GET", "/eAccounting/webInvoice/checkBgtPlan.do", availableVar, function(result1) {

                if(result1.ctrlType == "Y") {
                    Common.ajax("GET", "/eAccounting/webInvoice/availableAmtCp.do", availableVar, function(result) {
                        console.log(result.totalAvailable);

                        //var finAvailable = result.totalAvilableAdj - result.totalPending - result.totalUtilized;
                        var finAvailable = (parseFloat(result.totalAvilableAdj) - parseFloat(result.totalPending) - parseFloat(result.totalUtilized)).toFixed(2);

                        if(finAvailable < AUIGrid.getCellValue(newGridID, i, "totAmt")) {
                            Common.alert("Insufficient budget amount available for Budget Code : " + AUIGrid.getCellValue(newGridID, i, "budgetCode") + ", GL Code : " + AUIGrid.getCellValue(newGridID, i, "glAccCode") + ". ");
                            AUIGrid.setCellValue(newGridID, event.rowIndex, "netAmt", "0.00");
                            AUIGrid.setCellValue(newGridID, event.rowIndex, "totAmt", "0.00");

                            return false;
                        } else {
                            var data = {
                                    memAccId : $("#newMemAccId").val(),
                                    invcNo : $("#invcNo").val()
                                    //clmNo : $("#newClmNo").val()
                            }

                            Common.ajax("GET", "/eAccounting/webInvoice/selectSameVender.do?_cacheId=" + Math.random(), data, function(result) {
                                console.log(result);
                                if(result.data && result.data != $("#newClmNo").val()) {
                                    Common.alert('<spring:message code="newWebInvoice.sameVender.msg" />');
                                    return false;
                                } else {
                                    // 수정 후 temp save가 아닌 바로 submit
                                    // 고려하여 update 후 approve
                                    // file 업로드를 하지 않은 상태라면 atchFileGrpId가 없을 수 있다
                                    if(FormUtil.isEmpty($("#atchFileGrpId").val())) {
                                        console.log("fn_attachmentUpload Action");
                                        fn_attachmentUpload("");
                                    } else {
                                        console.log("fn_attachmentUpdate Action");
                                        fn_attachmentUpdate("");
                                    }

                                    Common.popupDiv("/eAccounting/webInvoice/approveLinePop.do", null, null, true, "approveLineSearchPop");
                                }
                            });
                        }
                    });
                } else {
                    var data = {
                            memAccId : $("#newMemAccId").val(),
                            invcNo : $("#invcNo").val()
                            //clmNo : $("#newClmNo").val()
                    }

                    Common.ajax("GET", "/eAccounting/webInvoice/selectSameVender.do?_cacheId=" + Math.random(), data, function(result) {
                        console.log(result);
                        if(result.data && result.data != $("#newClmNo").val()) {
                            Common.alert('<spring:message code="newWebInvoice.sameVender.msg" />');
                            return false;
                        } else {
                            // 수정 후 temp save가 아닌 바로 submit
                            // 고려하여 update 후 approve
                            // file 업로드를 하지 않은 상태라면 atchFileGrpId가 없을 수 있다
                            if(FormUtil.isEmpty($("#atchFileGrpId").val())) {
                                console.log("fn_attachmentUpload Action");
                                fn_attachmentUpload("");
                            } else {
                                console.log("fn_attachmentUpdate Action");
                                fn_attachmentUpdate("");
                            }

                            Common.popupDiv("/eAccounting/webInvoice/approveLinePop.do", null, null, true, "approveLineSearchPop");
                        }
                    });
                }
            });
        }
    }
}

/*
function fn_tempSave() {
	var checkResult = fn_checkEmpty();

    if(!checkResult){
        return false;
    }

    var data = {
            memAccId : $("#newMemAccId").val(),
            invcNo : $("#invcNo").val()
    }

    Common.ajax("GET", "/eAccounting/webInvoice/selectSameVender.do?_cacheId=" + Math.random(), data, function(result) {
        console.log(result);
        if(result.data && result.data != $("#newClmNo").val()) {
            Common.alert('<spring:message code="newWebInvoice.sameVender.msg" />');
            return false;
        } else {
        	if(FormUtil.isEmpty($("#atchFileGrpId").val())) {
        		console.log("fn_attachmentUpload Action");
                fn_attachmentUpload(callType);
            } else {
            	console.log("fn_attachmentUpdate Action");
                fn_attachmentUpdate(callType);
            }
        }
    });

}
*/

function fn_tempSave() {

    fn_vendorValidation("ts");
}

function fn_submit() {
    fn_vendorValidation("");
}

function fn_vendorValidation(ts){

    var checkResult = fn_checkEmpty();
    var checkRegex = fn_checkRegex();

    if(!checkResult){
        return false;
    }

    if(!checkRegex){
        return false;
    };


    if(ts == 'ts') // temp_Save
    {
    	if(flg == 'M')
    	{
    		var obj = $("#form_newVendor").serializeJSON();
    		console.log("fn_editVendorMaster_saveDraft");
    		Common.ajax("GET", "/eAccounting/vendor/existingVendorValidation.do?_cacheId=" + Math.random(), obj, function(result) {
    			$("#mem_acc_id").val(result.vendorAccId);

    			if(result.vendorAccId == vendorAccId && result.vendorRegNoNric == $("#regCompNo").val())
    			{
    				if(FormUtil.isEmpty($("#newReqNo").val()))
                    {
                        fn_attachmentUpload("new");
                    }
                    else
                    {
                        fn_attachmentUpdate(callType);
                    }
    			}
    			else
    			{
    				Common.alert('Somthing is wrong. Please contact administrator.');
    			}
    		})

    		/* var obj = $("#form_newVendor").serializeJSON();
            console.log("fn_editVendorMaster_saveDraft");
            Common.ajax("GET", "/eAccounting/vendor/vendorValidation.do?_cacheId=" + Math.random(), obj, function(result){
                $("#isReset").val(result.isReset);
                $("#isPass").val(result.isPass);
                $("#mem_acc_id").val(result.vendorAccId);

                if($("#isReset").val() == 1 && $("#isPass").val() == 0) //isReset=1: false, isPass=1:NotPass
                {
                    // new
                    if(FormUtil.isEmpty($("#newReqNo").val())) {
                        fn_attachmentUpload("new");
                    } else {
                    // update
                        fn_attachmentUpdate(callType);
                     }
                }
                else
                {
                    if($("#mem_acc_id").val() != null && $("#mem_acc_id").val() != ''){

                        Common.alert('Vendor Existed. Member Account ID: ' + $("#mem_acc_id").val());
                        $('#form_newVendor').clearForm();
                    } else {
                        Common.alert('Vendor existed in Pending stage.');
                        $('#form_newVendor').clearForm();
                    }

                }

            }); */
    	}
    	else if(appvPrcssStusCode == 'A' && vendorAccId != '' && vendorAccId != null){
    		var obj = $("#form_newVendor").serializeJSON();
            Common.ajax("GET", "/eAccounting/vendor/vendorValidation.do?_cacheId=" + Math.random(), obj, function(result){
                $("#isReset").val(result.isReset);
                $("#isPass").val(result.isPass);
                //$("#mem_acc_id").val(result.vendorAccId);

                    // new
                    //if(FormUtil.isEmpty($("#newReqNo").val())) {
                        //fn_attachmentUpload("new");
                    //} else {
                    // update
                       // fn_attachmentUpdate(callType);
                    // }
                //var gridObj = AUIGrid.getSelectedItems(vendorManagementGridID);
                //var reqNo = gridObj[0].item.reqNo;
                Common.ajax("POST", "/eAccounting/vendor/editApproved.do", obj, function(result1) {
                    console.log(result1);
                    Common.alert("New Draft Created : " + result1.data.newClmNo);
                    //fn_editVendorPop(result1.data.newClmNo, flg, vendorAccId, appvPrcssStusCode);
                });

            });
    	}
    	else
    	{
    		var obj = $("#form_newVendor").serializeJSON();
            console.log("Edit_fn_vendorValidation_saveDraft");
            Common.ajax("GET", "/eAccounting/vendor/vendorValidation.do?_cacheId=" + Math.random(), obj, function(result){
                $("#isReset").val(result.isReset);
                $("#isPass").val(result.isPass);
                $("#sameReqNo").val(result.sameReqNo);
                $("#mem_acc_id").val(result.vendorAccId);

                if($("#isReset").val() == 1 && $("#isPass").val() == 0) //isReset=1: false, isPass=1:NotPass
                {
                	if(flg)
                    fn_attachmentUpdate(callType);
                }
                else
                {
                    if($("#sameReqNo").val() == 0)
                    {
                        //update
                        fn_attachmentUpdate(callType);
                    }
                    else
                    {
                        Common.alert('Somthing is wrong. Please contact administrator.');
                    }
                }

            });
    	}

    }
    else // Submit
    {
        if(flg == 'M') //edit existing
        {
        	var obj = $("#form_newVendor").serializeJSON();
            Common.ajax("GET", "/eAccounting/vendor/existingVendorValidation.do?_cacheId=" + Math.random(), obj, function(result) {
            	$("#isReset").val(result.isReset);
                $("#isPass").val(result.isPass);
                $("#sameReqNo").val(result.sameReqNo);
                $("#mem_acc_id").val(result.vendorAccId);
                fn_attachmentUpload("");
            })
        }
        else if(appvPrcssStusCode == 'A' && vendorAccId != '' && vendorAccId != null) //edit approved
        {
        	var obj = $("#form_newVendor").serializeJSON();
        	Common.ajax("GET", "/eAccounting/vendor/vendorValidation.do?_cacheId=" + Math.random(), obj, function(result){
        		$("#isReset").val(result.isReset);
                $("#isPass").val(result.isPass);
                $("#sameReqNo").val(result.sameReqNo);
                $("#mem_acc_id").val(result.vendorAccId);
                if($("#isReset").val() == 1 && $("#isPass").val() == 0)
                {
                    Common.ajax("POST", "/eAccounting/vendor/editApproved.do", obj, function(result1) {
                        console.log(result1);
                        var newClmNo = result1.data.newClmNo;
                        obj.newClmNo = newClmNo;
                        $("#newClmNo").val(newClmNo);
                        console.log('newClmNo: ' + $("#newClmNo"));
                        if(FormUtil.isEmpty($("#newReqNo").val())) {
                            Common.popupDiv("/eAccounting/vendor/approveLinePop.do", obj, null, true, "approveLineSearchPop");
                        } else {
                            // update
                            Common.popupDiv("/eAccounting/vendor/approveLinePop.do", obj, null, true, "approveLineSearchPop");
                        }
                    });
                }
                else
                {
                	{
                        //fn_attachmentUpload("");
                        //var gridObj = AUIGrid.getSelectedItems(vendorManagementGridID);
                        //var reqNo = gridObj[0].item.reqNo;
                        Common.ajax("POST", "/eAccounting/vendor/editApproved.do", obj, function(result1) {
                            console.log(result1);
                            var newClmNo = result1.data.newClmNo;
                            obj.newClmNo = newClmNo;
                            $("#newClmNo").val(newClmNo);
                            console.log('newClmNo: ' + $("#newClmNo"));
                            if(FormUtil.isEmpty($("#newReqNo").val())) {
                                Common.popupDiv("/eAccounting/vendor/approveLinePop.do", obj, null, true, "approveLineSearchPop");
                            } else {
                                // update
                                Common.popupDiv("/eAccounting/vendor/approveLinePop.do", obj, null, true, "approveLineSearchPop");
                            }
                            //fn_editVendorPop(result1.data.newClmNo, flg, vendorAccId, appvPrcssStusCode);
                        });
                    }
                }
        	});
        }
        else
        {
        	var obj = $("#form_newVendor").serializeJSON();
        	Common.ajax("GET", "/eAccounting/vendor/vendorValidation.do?_cacheId=" + Math.random(), obj, function(result){
        		$("#isReset").val(result.isReset);
                $("#isPass").val(result.isPass);
                $("#sameReqNo").val(result.sameReqNo);
                $("#mem_acc_id").val(result.vendorAccId);
                if($("#isReset").val() == 1 && $("#isPass").val() == 0)
                {
                	if(FormUtil.isEmpty($("#appvPrcssNo").val()))
                    {
                        fn_attachmentUpdate("");
                    }
                }
                else
                {
                	if($("#sameReqNo").val() == 0)
                    {
                        //update
                        fn_attachmentUpdate("");
                    }
                    else
                    {
                        Common.alert('Somthing is wrong. Please contact administrator.');
                    }
                }

        	});
        }
    }
}

        //old
        /* var obj = $("#form_newVendor").serializeJSON();
            Common.ajax("GET", "/eAccounting/vendor/vendorValidation.do?_cacheId=" + Math.random(), obj, function(result){
            $("#isReset").val(result.isReset);
            $("#isPass").val(result.isPass);
            $("#sameReqNo").val(result.sameReqNo);
            $("#mem_acc_id").val(result.vendorAccId);

            if($("#isReset").val() == 1 && $("#isPass").val() == 0) //isReset=1: false, isPass=1:NotPass
            {
            	if(flg == 'M')
            	{
            		fn_attachmentUpload("");
            	}
            	else if(appvPrcssStusCode == 'A' && vendorAccId != '' && vendorAccId != null)
            	{

            		//fn_attachmentUpload("");
            		//var gridObj = AUIGrid.getSelectedItems(vendorManagementGridID);
            		//var reqNo = gridObj[0].item.reqNo;
            		Common.ajax("POST", "/eAccounting/vendor/editApproved.do", obj, function(result1) {
                        console.log(result1);
                        var newClmNo = result1.data.newClmNo;
                        obj.newClmNo = newClmNo;
                        $("#newClmNo").val(newClmNo);
                        console.log('newClmNo: ' + $("#newClmNo"));
                        if(FormUtil.isEmpty($("#newReqNo").val())) {
                            Common.popupDiv("/eAccounting/vendor/approveLinePop.do", obj, null, true, "approveLineSearchPop");
                        } else {
                            // update
                            Common.popupDiv("/eAccounting/vendor/approveLinePop.do", obj, null, true, "approveLineSearchPop");
                        }
                        //fn_editVendorPop(result1.data.newClmNo, flg, vendorAccId, appvPrcssStusCode);
                    });
            	}
            	else
            	{
            		if(FormUtil.isEmpty($("#appvPrcssNo").val()))
                    {
                        fn_attachmentUpdate("");
                    }
            	}

            }
            else
            {
            	if(appvPrcssStusCode == 'A' && vendorAccId != '' && vendorAccId != null)
                {
                    //fn_attachmentUpload("");
                    //var gridObj = AUIGrid.getSelectedItems(vendorManagementGridID);
                    //var reqNo = gridObj[0].item.reqNo;
                    Common.ajax("POST", "/eAccounting/vendor/editApproved.do", obj, function(result1) {
                        console.log(result1);
                        var newClmNo = result1.data.newClmNo;
                        obj.newClmNo = newClmNo;
                        $("#newClmNo").val(newClmNo);
                        console.log('newClmNo: ' + $("#newClmNo"));
                        if(FormUtil.isEmpty($("#newReqNo").val())) {
                            Common.popupDiv("/eAccounting/vendor/approveLinePop.do", obj, null, true, "approveLineSearchPop");
                        } else {
                            // update
                            Common.popupDiv("/eAccounting/vendor/approveLinePop.do", obj, null, true, "approveLineSearchPop");
                        }
                        //fn_editVendorPop(result1.data.newClmNo, flg, vendorAccId, appvPrcssStusCode);
                    });
                }
            	else if($("#sameReqNo").val() == 0)
                {
                    //update
                    fn_attachmentUpdate("");
                }
                else
                {
                    Common.alert('Somthing is wrong. Please contact administrator.');
                }
            }
        }); */


function fn_attachmentUpload(st) {
    var formData = Common.getFormData("form_newVendor");
    Common.ajaxFile("/eAccounting/vendor/attachmentUpload.do", formData, function(result) {
        // 신규 add return atchFileGrpId의 key = fileGroupKey
         console.log("attachmentUpload: " + result);
        $("#atchFileGrpId").val(result.data.fileGroupKey);
        fn_insertVendorInfo(st);
    });
}
/*
function fn_attachmentUpdate(st) {
    // 신규 add or 추가 add인지 update or delete인지 분기 필요
    // 파일 수정해야 하는 경우 : delete 버튼 클릭 or file 버튼 클릭으로 수정
    // delete 버튼의 파일이름 찾아서 저장
    var formData = Common.getFormData("form_newVendor");
    formData.append("atchFileGrpId", $("#atchFileGrpId").val());
    Common.ajaxFile("/eAccounting/vendor/attachmentUpdate.do", formData, function(result) {
        console.log(result);
        fn_updateVendorInfo(st);
    });
}
*/
function fn_attachmentUpdate(st) {
    // 신규 add or 추가 add인지 update or delete인지 분기 필요
    // 파일 수정해야 하는 경우 : delete 버튼 클릭 or file 버튼 클릭으로 수정
    // delete 버튼의 파일이름 찾아서 저장
    var formData = Common.getFormData("form_newVendor");
    formData.append("atchFileGrpId", $("#atchFileGrpId").val());
    formData.append("update", JSON.stringify(update).replace(/[\[\]\"]/gi, ''));
    console.log(JSON.stringify(update).replace(/[\[\]\"]/gi, ''));
    formData.append("remove", JSON.stringify(remove).replace(/[\[\]\"]/gi, ''));
    console.log(JSON.stringify(remove).replace(/[\[\]\"]/gi, ''));
    Common.ajaxFile("/eAccounting/vendor/attachmentUpdate.do", formData, function(result) {
        console.log(result);
        fn_updateVendorInfo(st);
    });
}

function fn_insertVendorInfo(st) {
    var obj = $("#form_newVendor").serializeJSON();

    if(st == 'new')
    {
        console.log("fn_insertVendorInfo_TempSave");
        Common.ajax("POST", "/eAccounting/vendor/insertVendorInfo.do", obj, function(result) {

        });
        Common.alert('Temporary Save succeeded.');
        fn_close();
        fn_selectVendorList();
    }
    else
    {
        console.log("fn_insertVendorInfoSubmit");
        Common.ajax("POST", "/eAccounting/vendor/insertVendorInfo.do", obj, function(result) {
            console.log(result);

            $("#newReqNo").val(result.data.reqNo);
            $("#appvPrcssNo").val(result.data.appvPrcssNo);

            // new
               if(FormUtil.isEmpty($("#newReqNo").val())) {
                   Common.popupDiv("/eAccounting/vendor/approveLinePop.do", null, null, true, "approveLineSearchPop");
               } else {
                   // update
                   Common.popupDiv("/eAccounting/vendor/approveLinePop.do", null, null, true, "approveLineSearchPop");
               }
        });
    }

}

function fn_updateVendorInfo(st) {
    var obj = $("#form_newVendor").serializeJSON();
    //var gridData = GridCommon.getEditData(newGridID);
    //obj.gridData = gridData;
    console.log(obj);
    Common.ajax("POST", "/eAccounting/vendor/updateVendorInfo.do", obj, function(result) {
        console.log(result);
        //fn_selectWebInvoiceItemList(result.data.clmNo);
        //fn_selectWebInvoiceInfo(result.data.clmNo);
        if(st == "view"){
            Common.alert('Temporary save succeeded.');
            $("#editVendorPop").remove();
            fn_selectVendorList();
        }
        else
        {
        	if(FormUtil.isEmpty($("#appvPrcssNo").val())) {
                Common.popupDiv("/eAccounting/vendor/approveLinePop.do", null, null, true, "approveLineSearchPop");
            } else {
                // update
                Common.popupDiv("/eAccounting/vendor/approveLinePop.do", null, null, true, "approveLineSearchPop");
            }
        }
        //fn_selectWebInvoiceList();
    });

}

function fn_setGridData(data) {
	console.log(data);
	AUIGrid.setGridData(newGridID, data);
}

function fn_checkRegex()
{
     var checkRegexResult = true;
     var regExpSpecChar = /^(?!-)(?!\/)\S{1}[a-zA-Z0-9 ~`!#$%\^&*+=[\]\\(\)\';,{}.|\\":<>\?]*(?!-)(?!\/)\S{1}$/;
     var regExpNum = /^[0-9]*$/;
        if( regExpSpecChar.test($("#regCompName").val()) == false ){
             Common.alert("* Special character or space as the first and last character are not allow for Registered Company/Individual Name. ");
             checkRegexResult = false;;
             return checkRegexResult;
        }
        else if( regExpSpecChar.test($("#bankAccHolder").val()) == false ){
             Common.alert("* Special character or space as the first and last character are not allow for Bank Account Holder. ");
             checkRegexResult = false;;
             return checkRegexResult;
        }
        else if( regExpNum.test($("#bankAccNo").val()) == false ){
            Common.alert("* Only number is allow for Bank Account Number. ");
            checkRegexResult = false;;
            return checkRegexResult;
       }
        else if( regExpNum.test($("#postalCode").val()) == false ){
            Common.alert("* Only number is allow for Postal Code. ");
            checkRegexResult = false;;
            return checkRegexResult;
       }
     return checkRegexResult;
}

$.fn.clearForm = function() {
    return this.each(function() {
        var type = this.type, tag = this.tagName.toLowerCase();
        if (tag === 'form'){
            return $(':input',this).clearForm();
        }
        if (type === 'text' || type === 'password' || type === 'hidden' || type === 'file' || type === 'number' || tag === 'textarea'){
            this.value = '';
        }else if (type === 'checkbox' || type === 'radio'){
            this.checked = false;
        }else if (tag === 'select'){
            this.selectedIndex = 0;
        }

        if(this.id === 'vendorCountry' || this.id === 'bankCountry')
        {
            $("#vendorCountry").val("MY").attr("selected", "selected");
            $("#bankCountry").val("MY").attr("selected", "selected");
        }

    });
};
</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Edit Vendor Registration</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>

</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<ul class="right_btns mb10">
    <li><p class="btn_blue2"><a href="#" id="tempSave">Save Draft</a></p></li>
    <li><p class="btn_blue2"><a href="#" id="submitPop">Submit</a></p></li>
</ul>

<section class="search_table"><!-- search_table start -->

<form action="#" method="post" enctype="multipart/form-data" id="form_newVendor">
<input type="hidden" id="newReqNo" name="newReqNo" value="${vendorInfo.vendorReqNo}">
<input type="hidden" id="atchFileGrpId" name="atchFileGrpId" value="${vendorInfo.atchFileGrpId}">
<input type="hidden" id="appvPrcssNo" name="appvPrcssNo" value="${vendorInfo.reqNo}">
<input type="hidden" id="isReset" name="isReset">
<input type="hidden" id="isPass" name="isPass">
<input type="hidden" id="sameReqNo" name="sameReqNo">
<input type="hidden" id="newClmNo" name="newClmNo">
<input type="hidden" id="mem_acc_id" name="mem_acc_id">
<input type="hidden" id="newCostCenterText" name="costCentrName" value="${vendorInfo.costCenterName}">
<!-- <input type="hidden" id="newMemAccName" name="memAccName"> -->
<input type="hidden" id="crtUserId" name="crtUserId" value="${userId}">


<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
    <col style="width:150px" />
    <col style="width:*" />
</colgroup>
<style>
    .readonly-dropdown {
        pointer-events: none;  /* Disables interaction with the dropdown */
        background-color: #f0f0f0; /* Optional: changes background to indicate it's readonly */
        cursor: not-allowed; /* Change cursor to show that it's not editable */
    }
</style>
<tbody>
<tr id="syncEmroSec">
    <th scope="row">Sync to eMRO
        <c:choose>
        <c:when test="${vendorInfo.syncEmro eq '1'}">
            <input id="syncEmro" name="syncEmro" type="checkbox" onClick="return false" checked/>
        </c:when>
        <c:otherwise>
            <input id="syncEmro" name="syncEmro" type="checkbox" onClick="return false"/>
        </c:otherwise>
        </c:choose></th>
    </th>
    <td colspan="3" id="viewSyncToEmro">${updateUserName}</td>
</tr>
<tr>
    <th scope="row">Claim No / Vendor Code<span class="must">*</span></th>
    <td colspan=3><input type="text" title="" id="newVendorCode" name="vendorCode" placeholder="" class="readonly w100p" readonly="readonly" value="${vendorInfo.vendorReqNo}"/></td><!--  value="${claimNo}"-->
</tr>
<tr>
    <th scope="row">Vendor Type<span class="must">*</span></th>
    <%-- <td colspan=3><input type="text" title="" id="vendorType" name="vendorType" placeholder="" class="readonly w100p" readonly="readonly" value="${vendorInfo.vendorType}"/></td><!--  value="${claimNo}"-->--%>
    <td>
        <select class="readonly w100p readonly-dropdown " id=vendorType name="vendorType" pointer-events: none>
	        <option value="0"<c:if test="${vendorInfo.vendorType eq '0'}">selected="selected"</c:if>>Corporate</option>
	        <option value="1"<c:if test="${vendorInfo.vendorType eq '1'}">selected="selected"</c:if>>Individual</option>
    </td>
</tr>
<tr>
    <th scope="row">Vendor Group<span class="must">*</span></th>
	    <td>
	       <select class="w100p" id=vendorGroup name="vendorGroup">
                  <!--  <option value="VM02"<c:if test="${vendorInfo.vendorGrp eq 'VM02'}">selected="selected"</c:if>>VM02 - Coway_Supplier_Foreign</option>-->
                  <option value="VM02"<c:if test="${vendorInfo.vendorGrp eq 'VM02'}">selected="selected"</c:if>>VM02 - Coway_Supplier_Foreign</option>
                  <option value="VM03"<c:if test="${vendorInfo.vendorGrp eq 'VM03'}">selected="selected"</c:if>>VM03 - Coway_Supplier_Foreign (Related Company)</option>
                  <option value="VM11"<c:if test="${vendorInfo.vendorGrp eq 'VM11'}">selected="selected"</c:if>>VM11 - Coway_Suppliers_Local</option>
           </select>
	    </td>
    <th scope="row">Key in date</th>
    <td>
    <input type="text" title="" id="keyDate" name="keyDate" placeholder="DD/MM/YYYY" value="${vendorInfo.updDate}" class="readonly w100p" readonly="readonly"/>
    </td>
</tr>
<tr>
      <th scope="row">Cost Center</th>
      <c:if test="${flg eq 'M'}">
        <td><input type="text" title="" placeholder="" class="" id="newCostCenter" name="costCentr" value="${SESSION_INFO.costCentr}"/><a href="#" class="search_btn" id="costCenter_search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a></td>
      </c:if>
      <c:if test="${flg ne 'M'}">
        <td><input type="text" title="" placeholder="" class="readonly w100p" id="newCostCenter" name="costCentr" value="${vendorInfo.costCenter}" readonly="readonly"/></td>
      </c:if>
    <th scope="row">Create User ID</th>
    <td><input type="text" title="" placeholder="" class="readonly w100p" id="userName" readonly="readonly" value="${userName} / ${memCode}"/></td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h2></h2>
</aside><!-- title_line end -->


<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
    <col style="width:150px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th colspan=2 scope="row">Registered Company/Individual Name</th>
    <td colspan=3><input style="text-transform: uppercase" type="text" title="" placeholder="" class="w100p" id="regCompName" name="regCompName" value="${vendorInfo.vendorName}"/></td>
</tr>
<tr>
    <th colspan = 2 scope="row">Company Registration No/IC No</th>
    <td colspan="3"><input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" id="regCompNo" name="regCompNo" value="${vendorInfo.vendorRegNoNric}"/></td>
</tr>
<tr>
    <th colspan = 2 scope="row">Email Address (payment advice)<span class="must">*</span></th>
    <td colspan="3">
        <select class="w100p" id=payAdvEmail1 name="payAdvEmail1">
                  <option value="ap@coway.com.my" <c:if test="${vendorInfo.payAdvEmail1 eq 'ap@coway.com.my'}">selected="selected"</c:if>>ap@coway.com.my</option>
                  <option value="ga.payment@coway.com.my" <c:if test="${vendorInfo.payAdvEmail1 eq 'ga.payment@coway.com.my'}">selected="selected"</c:if>>ga.payment@coway.com.my</option>
        </select>
    </td>
</tr>
<tr>
    <th colspan = 2 scope="row">Email Address 2 (payment advice)</th>
    <td colspan="3"><input type="text" title="" placeholder="" class="w100p" id="payAdvEmail2" name="payAdvEmail2" value="${vendorInfo.payAdvEmail2}"/></td>
</tr>

</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h2>Vendor Address</h2>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
    <col style="width:150px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Street</th>
    <td><input style="text-transform: uppercase" type="text" title="" placeholder="" class="w100p" id="street" name="street" value="${vendorInfo.addStreet}"/></td>
    <th scope="row">House/Lot Number</th>
    <td><input style="text-transform: uppercase" type="text" title="" placeholder="" class="w100p" id="houseNo" name="houseNo" value="${vendorInfo.addHouseLotNo}"/></td>
</tr>
<tr>
    <th scope="row">Postal Code</th>
    <td><input style="text-transform: uppercase" type="text" title="" placeholder="" class="w100p" id="postalCode" name="postalCode" value="${vendorInfo.addPostalCode}" maxlength = "10"/></td>
    <th scope="row">City</th>
	    <td><input style="text-transform: uppercase" type="text" title="" placeholder="" class="w100p" id="city" name="city" value="${vendorInfo.addCity}" maxlength = "50"/></td>
</tr>
<tr>
    <th scope="row">Country</th>
	    <td colspan=3>
	       <select onchange="fn_jsFunction()"  style="text-transform:uppercase" class="w100p" id="vendorCountry" name="vendorCountry">
            <c:forEach var="list" items="${countryList}" varStatus="status">
               <option value="${list.code}">${list.name}</option>
            </c:forEach>
        </select>
	    </td>
</tr>

</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h2>Payment Information</h2>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
    <col style="width:150px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th>Payment Terms <b>(Days)</b></th>
    <td><input type="number" min="1"  title="" placeholder="" class="w100p" id="paymentTerms" name="paymentTerms" value="${vendorInfo.payTerm}"/></td>
    <th>Payment Method</th>
    <td>
        <select onchange="fn_jsFunction1()" class="w100p" id=paymentMethod name="paymentMethod">
                  <!--  <option value="CASH">CASH</option>-->
                  <option value="CASH"<c:if test="${vendorInfo.payType eq 'CASH'}">selected="selected"</c:if>>CASH</option>
                  <option value="CHEQ"<c:if test="${vendorInfo.payType eq 'CHEQ'}">selected="selected"</c:if>>CHEQUE</option>
                  <option value="OTRX"<c:if test="${vendorInfo.payType eq 'OTRX'}">selected="selected"</c:if>>ONLINE TRANSFER</option>
                  <option value="TTRX"<c:if test="${vendorInfo.payType eq 'TTRX'}">selected="selected"</c:if>>TELEGRAPHIC TRANSFER</option>
           </select>
    </td>
</tr>
<tr>
    <th>Others (Please State)</th>
    <td colspan=3><input type="text" title="" placeholder="" class="w100p" id="others" name="others" value="${vendorInfo.payOth}" maxlength = "50"/></td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h2>Vendor Bank Details</h2>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
    <col style="width:150px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Country</th>
    <td>
        <select onchange="fn_jsFunction()"  style="text-transform:uppercase" class="w100p" id="bankCountry" name="bankCountry">
            <c:forEach var="list" items="${countryList}" varStatus="status">
               <option value="${list.code}">${list.name}</option>
            </c:forEach>
        </select>
    </td>
    <th id="bankAccHolderHeader" scope="row">Account Holder<span class="must">*</span></th>
    <td><input style="text-transform: uppercase" type="text" title="" placeholder="" class="w100p" id="bankAccHolder" name="bankAccHolder" value="${vendorInfo.bankAccHolder}" maxlength = "100"/></td>
</tr>
<tr>
    <th id="bankListHeader" scope="row"> Bank<span class="must">*</span></th>
    <td>
        <select class="w100p" id="bankList" name="bankList">
            <c:forEach var="list" items="${bankList}" varStatus="status">
               <option value="${list.code}">${list.name}</option>
            </c:forEach>
        </select>
    </td>
    <th id="bankAccNoHeader" scope="row">Bank Account Number<span class="must">*</span></th>
    <td><input style="text-transform: uppercase" type="text" title="" placeholder="" class="w100p" id="bankAccNo" name="bankAccNo" value="${vendorInfo.bankAccNo}" onchange="fn_jsFunction()" maxlength = "16"/></td>
</tr>
<tr>
    <th>Branch</th>
    <td colspan=3><input style="text-transform: uppercase" type="text" title="" placeholder="" class="w100p" id="bankBranch" name="bankBranch" value="${vendorInfo.bankBranch}" maxlength = "50"/></td>
</tr>
<tr>
    <th id="swiftCodeHeader">Swift Code</th>
    <td colspan=3><input style="text-transform: uppercase" type="text" title="" placeholder="" class="w100p" id="swiftCode" name="swiftCode" value="${vendorInfo.swiftCode}" maxlength = "20"/></td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h2>Vendor Contact Information</h2>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
    <col style="width:150px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Designation</th>
    <td>
    <!--  <select class="w100p" id="designation" name="designation"></select>-->
    <select class="w100p" id=designation name="designation">
                  <option value="Company"<c:if test="${vendorInfo.contactDesignation eq 'Company'}">selected="selected"</c:if>>Company</option>
                  <option value="Mr."<c:if test="${vendorInfo.contactDesignation eq 'Mr.'}">selected="selected"</c:if>>Mr.</option>
                  <option value="Mr. and Mrs."<c:if test="${vendorInfo.contactDesignation eq 'Mr. and Mrs.'}">selected="selected"</c:if>>Mr. and Mrs.</option>
                  <option value="Ms."<c:if test="${vendorInfo.contactDesignation eq 'Ms.'}">selected="selected"</c:if>>Ms.</option>
    </select>
    </td>
    <th scope="row"> Name</th>
    <td><input style="text-transform: uppercase" type="text" title="" placeholder="" class="w100p" id="vendorName" name="vendorName" value="${vendorInfo.contactName}" maxlength = "50"/></td>
</tr>
<tr>
    <th>Phone Number</th>
    <td><input style="text-transform: uppercase" type="text" title="" placeholder="" class="w100p" id="vendorPhoneNo" name="vendorPhoneNo" value="${vendorInfo.contactPhoneNo}" maxlength = "20"/></td>
    <th>Email Address</th>
    <td><input type="text" title="" placeholder="" class="w100p" id="vendorEmail" name="vendorEmail" value="${vendorInfo.contactEmail}"/></td>
</tr>

</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h2></h2>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
    <col style="width:150px" />
    <col style="width:*" />
</colgroup>
<tbody>
<c:if test="${flg eq 'M'}">
<tr>
    <th scope="row">Attachment<span class="must">*</span></th>
    <td colspan="3" id="attachTd" name="attachTd">
    <div class="auto_file2 attachment_file w100p"><!-- auto_file start -->
    <input type="file" title="file add" style="width:300px" />
    </div><!-- auto_file end -->
    </td>
</tr>
</c:if>
<c:if test="${flg ne 'M'}">
    <tr>
	    <th scope="row">Attachment<span class="must">*</span></th>
	    <td colspan="3" id="attachTd" name="attachTd">
	        <c:forEach var="files" items="${attachmentList}" varStatus="st">
	            <div class="auto_file2 attachment_file w100p"><!-- auto_file start -->
	                <c:if test="${webInvoiceInfo.appvPrcssNo eq null or webInvoiceInfo.appvPrcssNo eq ''}">
	                <input type="file" title="file add" style="width:300px" />
	                <label>
	                </c:if>
	                <input type='text' class='input_text' readonly='readonly' value="${files.atchFileName}" />
	                <c:if test="${webInvoiceInfo.appvPrcssNo eq null or webInvoiceInfo.appvPrcssNo eq ''}">
	                <span class='label_text'><a href='#'><spring:message code="viewEditWebInvoice.file" /></a></span>
	                </c:if>
	                </label>
	                <c:if test="${fn:length(attachmentList) <= 0}">
					    <c:if test="${webInvoiceInfo.appvPrcssNo eq null or webInvoiceInfo.appvPrcssNo eq ''}">
					    <div class="auto_file2 attachment_file w100p"><!-- auto_file start -->
					    <input type="file" title="file add" style="width:300px" />
					    </div><!-- auto_file end -->
					    </c:if>
					</c:if>
	             </div>
	        </c:forEach>
	        <c:if test="${fn:length(attachmentList) <= 0}">
			    <c:if test="${webInvoiceInfo.appvPrcssNo eq null or webInvoiceInfo.appvPrcssNo eq ''}">
			         <div class="auto_file2 attachment_file w100p"><!-- auto_file start -->
			             <input type="file" title="file add" style="width:300px" />
			         </div><!-- auto_file end -->
			    </c:if>
		    </c:if>
	    </td>
    </tr>
</c:if>


</tbody>
</table><!-- table end -->
</form>

</section><!-- search_table end -->
<%--
<section class="search_result"><!-- search_result start -->


<article class="grid_wrap" id="newVendor_grid_wrap"><!-- grid_wrap start -->
</article><!-- grid_wrap end -->
--%>
</section><!-- search_result end -->

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->