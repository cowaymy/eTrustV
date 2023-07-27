<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<style type="text/css">
/* 커스텀 칼럼 스타일 정의 */
.aui-grid-user-custom-left {
    text-align:left;
}
</style>
<script type="text/javascript">
// var isNew = "${isNew}";
// var isBulk = "${isBulk}";
var selectRowIdx;
var approveLineGridID;
var approveLineColumnLayout = [ {
    dataField : "approveNo",
    headerText : '<spring:message code="approveLine.approveNo" />',
    dataType: "numeric",
    expFunction : function( rowIndex, columnIndex, item, dataField ) { // 여기서 실제로 출력할 값을 계산해서 리턴시킴.
        // expFunction 의 리턴형은 항상 Number 여야 합니다.(즉, 수식만 가능)
        return rowIndex + 1;
    }
}, {
    dataField : "memCode",
    headerText : '<spring:message code="approveLine.userId" />',
    colSpan : 2
}, {
    dataField : "",
    headerText : '',
    width: 30,
    renderer : {
        type : "IconRenderer",
        iconTableRef :  {
            "default" : "${pageContext.request.contextPath}/resources/images/common/normal_search.png"// default
        },
        iconWidth : 24,
        iconHeight : 24,
        onclick : function(rowIndex, columnIndex, value, item) {
            console.log("selectRowIdx : " + selectRowIdx);
            selectRowIdx = rowIndex;
            fn_searchUserIdPop();
            }
        },
    colSpan : -1
},{
    dataField : "name",
    headerText : '<spring:message code="approveLine.name" />',
    style : "aui-grid-user-custom-left"
}, {
    dataField : "",
    headerText : '<spring:message code="approveLine.addition" />',
    renderer : {
        type : "IconRenderer",
        iconTableRef :  {
            "default" : "${pageContext.request.contextPath}/resources/images/common/btn_plus.gif" // default
        },
        iconWidth : 12,
        iconHeight : 12,
        onclick : function(rowIndex, columnIndex, value, item) {
            var rowCount = AUIGrid.getRowCount(approveLineGridID);
            if (rowCount > 4) {
                Common.alert('Approval lines can be up to 5 levels.');
            } else {
                fn_appvLineGridAddRow();
            }
        }
     }
}];

//그리드 속성 설정
var approveLineGridPros = {
    // 페이징 사용
    usePaging : true,
    // 한 화면에 출력되는 행 개수 20(기본값:20)
    pageRowCount : 20,
    showStateColumn : true,
    // 셀, 행 수정 후 원본으로 복구 시키는 기능 사용 가능 여부 (기본값:true)
    enableRestore : true,
    showRowNumColumn : false,
    softRemovePolicy : "exceptNew", //사용자추가한 행은 바로 삭제
    softRemoveRowMode : false,
    // 셀 선택모드 (기본값: singleCell)
    selectionMode : "multipleCells"
};

$(document).ready(function () {
    approveLineGridID = AUIGrid.create("#approveLine_grid_wrap", approveLineColumnLayout, approveLineGridPros);

    $("#lineDel_btn").click(fn_appvLineDeleteRow);
    $("#submit").click(fn_reqstSubmit);

    AUIGrid.bind(approveLineGridID, "cellClick", function( event ) {
                console.log("CellClick rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex + " clicked");
                selectRowIdx = event.rowIndex;
            });

    //fn_setTemporaryData();
    fn_appvLineGridAddRow();
});

function fn_appvLineGridAddRow() {
    AUIGrid.addRow(approveLineGridID, {}, "first");
}

function fn_appvLineDeleteRow() {
    AUIGrid.removeRow(approveLineGridID, selectRowIdx);
}

function fn_searchUserIdPop() {
    Common.popupDiv("/common/memberPop.do", {callPrgm:"NRIC_VISIBLE"}, null, true);
}

// 그리드에 set 하는 function
function fn_loadOrderSalesman(memId, memCode) {
    var result = true;
    var list = AUIGrid.getColumnValues(approveLineGridID, "memCode", true);

    if(list.length > 0) {
        for(var i = 0; i < list.length; i ++) {
            if(memCode == list[i]) {
                result = false;
            }
        }
    }

    if(result) {
        Common.ajax("GET", "/sales/order/selectMemberByMemberIDCode.do", {memId : memId, memCode : memCode}, function(memInfo) {

            if(memInfo == null) {
                Common.alert('<b>Member not found.</br>Your input member code : '+memCode+'</b>');
            }
            else {
                console.log(memInfo);
                AUIGrid.setCellValue(approveLineGridID, selectRowIdx, "memCode", memInfo.memCode);
                AUIGrid.setCellValue(approveLineGridID, selectRowIdx, "name", memInfo.name);
            }
        });
    } else {
        Common.alert('Not allowed to select same User ID in Approval Line');
    }
}

function fn_reqstSubmit() {
    var length = AUIGrid.getGridData(approveLineGridID).length;
    var checkMemCode = true;

    if(length > 0) {
        for(var i = 0; i < length; i++) {
            if(FormUtil.isEmpty(AUIGrid.getCellValue(approveLineGridID, i, "memCode"))) {
                Common.alert('<spring:message code="approveLine.userId.msg" />' + (i +1) + ".");
                checkMemCode = false;
            }
        }
    }
    if(length < 4){
    	Common.alert("Please select at least 4 approvers. ");
        checkMemCode = false;
    }
    console.log(checkMemCode);
    if(checkMemCode) {
        Common.confirm("Are you sure you want to submit this request?", fn_submitNewAdjustmentWithApprovalLine);
    }
}

function fn_approveLineSubmit() {
    console.log("data" + data);
    var apprGridList = AUIGrid.getOrgGridData(approveLineGridID);
    var obj = {
            apprGridList : apprGridList
    };
    console.log(obj);
    Common.ajax("POST", "/eAccounting/creditCard/checkFinAppr.do", obj, function(resultFinAppr) {
        console.log(resultFinAppr);

        if(resultFinAppr.code == "99") {
            Common.alert("Please select the relevant final approver.");
        } else {
        	fn_approvalLineSubmission();
        }
    });
}
function fn_approvalLineSubmission(){
        fn_submitNewAdjustmentWithApprovalLine();
}

function fn_submitNewAdjustmentWithApprovalLine(){
	switch(requestType){
		case "DCF" :
			fn_submitRequestDCF();
			break;
		case "FT" :
            fn_submitRequestFT();
            break;
		case "REF" :
			fn_submitRefund();
            break;
		default:
			break;
	}
}


function fn_submitRefund(){

	var data = {};
	var apprGridList = AUIGrid.getOrgGridData(approveLineGridID);
    //var obj = $("#_refundSearchForm").serializeJSON();                           //form data
    var gridList = AUIGrid.getGridData(myRequestRefundFinalGridID);       //grid data
    var formList = $("#_refundSearchForm").serializeArray();                  //form data

    data.apprGridList = apprGridList;

     //array에 담기
     if(gridList.length > 0) {
        data.all = gridList;
        data.form = formList;
    }  else {
        data.form = [];
        Common.alert("<spring:message code='pay.alert.noPaymentData'/>");
        return;
    }

     console.log("data: " + data);

	var formData = new FormData();
    formData.append("atchFileGroupId", atchFileGroupId);
    $.each(myFileCaches, function(n, v) {
    	formData.append(n, v.file);
    });

    console.log("formData: " + formData);

	Common.ajaxFile("/payment/requestRefundUpload.do", formData, function(attchResult) {
		console.log(attchResult);
		$("#atchFileId").val(attchResult.data.atchFileId);
		$("#fileGroupKey").val(attchResult.data.fileGroupKey);
		formList = $("#_refundSearchForm").serializeArray();
		data.form = formList;
		if(attchResult.code == 99){
            Common.alert("Attachment Upload Failed" + DEFAULT_DELIMITER + attchResult.message);
        }
        else{
        	console.log(data);
        	Common.ajax("POST", "/payment/requestRefund.do", data, function(result) {

                if (result.error) {
                    var message = result.error;
                } else {
                    var message = result.success;
                }
                Common.alert(message);
                closeApproveLine();
            });
        }
	});
}

	function fn_submitRequestDCF(){
	     var formData = new FormData();
	     formData.append("atchFileGroupId", atchFileGroupId)
	     $.each(myFileCaches, function(n, v) {
	         formData.append(n, v.file);
	     });

	      formData.append("dcfInfo", JSON.stringify($("#_dcfSearchForm").serializeJSON()));
	      formData.append("oldRequestDcfGrid", JSON.stringify(AUIGrid.getGridData(myRequestDCFGridID)));
	      formData.append("newRequestDcfGrid", JSON.stringify(AUIGrid.getGridData(myRequestNewDCFGridID)));
	      formData.append("cashPayInfoForm", JSON.stringify($("#cashPayInfoForm").serializeJSON()));
	      formData.append("chequePayInfoForm", JSON.stringify($("#chequePayInfoForm").serializeJSON()));
	      formData.append("onlinePayInfoForm", JSON.stringify($("#onlinePayInfoForm").serializeJSON()));
	      formData.append("creditPayInfoForm", JSON.stringify($("#creditPayInfoForm").serializeJSON()));
	      formData.append("apprGridList", JSON.stringify(AUIGrid.getGridData(approveLineGridID)));

	     Common.ajaxFile("/payment/requestDcfFileUpdate.do", formData, function(result){
	         if(result.code == 99){
	             Common.alert("Submit DCF Request Failed" + DEFAULT_DELIMITER + result.message);
	             $("#_requestApprovalLineCreatePop").remove();

	         }else{

	             Common.alert(result.message, function(){
	                 $("#_requestApprovalLineCreatePop").remove();
	                 $("#_requestDCFPop").remove();
	                 searchList();
	             });
	         }
	    });

}
</script>

<div id="popup_wrap" class="popup_wrap size_mid2"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="approveLine.title" /></h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#"><spring:message code="newWebInvoice.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<section class="search_result"><!-- search_result start -->

<ul class="right_btns">
    <!--li><p class="btn_grid"><a href="#">Add</a></p></li-->
    <li><p class="btn_grid"><a href="#" id="lineDel_btn"><spring:message code="pay.btn.delete" /></a></p></li>
</ul>

<article class="grid_wrap" id="approveLine_grid_wrap"><!-- grid_wrap start -->
</article><!-- grid_wrap end -->

<ul class="center_btns">
    <li><p class="btn_blue2"><a href="#" id="submit"><spring:message code="newWebInvoice.btn.submit" /></a></p></li>
</ul>

</section><!-- search_result end -->

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->