<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<style type="text/css">
/* 커스텀 칼럼 스타일 정의 */
.aui-grid-user-custom-left {
    text-align:left;
}
</style>
<script type="text/javascript">
var isNew = "${isNew}";
var isBulk = "${isBulk}";
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
            "default" : "${pageContext.request.contextPath}/resources/images/common/btn_plus.gif"// default
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
}
];

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
	console.log(length);

    if(length > 1) {
        for(var i = 0; i < length; i++) {
            if(FormUtil.isEmpty(AUIGrid.getCellValue(approveLineGridID, i, "memCode"))) {
                Common.alert('<spring:message code="approveLine.userId.msg" />' + (i +1) + ".");
                checkMemCode = false;
            }
        }
    }
	console.log(checkMemCode);
	if(checkMemCode) {
		Common.confirm("Are you sure you want to submit the adjustment?", fn_approveLineSubmit);
	}
}

function fn_approveLineSubmit() {
	var adjGridList;
	if(isBulk == "true"){
		adjGridList = AUIGrid.getOrgGridData(adjGridID);
	}
	else{
		adjGridList = AUIGrid.getOrgGridData(allowanceAdjGridID);
	}
	var apprGridList = AUIGrid.getOrgGridData(approveLineGridID);
    var obj = {
    		adjGridList : adjGridList,
            apprGridList : apprGridList,
            adjNo : "",
            //Final Approval type for crc adjustment
            clmType: "B3"
    };
    console.log(obj);
    Common.ajax("POST", "/eAccounting/creditCard/checkFinAppr.do", obj, function(resultFinAppr) {
        console.log(resultFinAppr);

        if(resultFinAppr.code == "99") {
            Common.alert("Please select the relevant final approver.");
        } else {
        	if(isBulk == "true"){
        		fn_bulkApprovalLineSubmission();
        	}
        	else{
            	fn_approvalLineSubmission();
        	}
        }
    });
}

function fn_bulkApprovalLineSubmission(){
	//Bulk Approval Line Submission from Allowance Limit Adjustment Page crcAdjustment.jsp
    var adjGridList = AUIGrid.getItemsByValue(adjGridID, "isActive", "Active");
	var apprGridList = AUIGrid.getOrgGridData(approveLineGridID);

        var obj = {
                apprGridList : apprGridList,
        		adjGridList : adjGridList
        };

        Common.ajax("POST", "/eAccounting/creditCard/submitBulkAdjustmentWithApprovalLine.do", obj, function(result) {
            if(result.code == "99") {
                Common.alert("Adjustment submit failed");
            } else {
            	$("#crcApprovalLineCreatePop").remove();
                $("#approveLineSearchPop").remove();
                //refresh grid list
                fn_listAdjPln();

                Common.alert("Adjustment(s) submitted " + result.data);

            }
        });
}

function fn_approvalLineSubmission(){
	//if new approval submit
	if(isNew == "true"){
		fn_submitNewAdjustmentWithApprovalLine();
	}
	//edit approval submit
	else {
        var formData = Common.getFormData("adjForm");
		 formData.append("atchFileGrpId", $("#atchFileGrpId").val());
         formData.append("update", JSON.stringify(update).replace(/[\[\]\"]/gi, ''));
         formData.append("remove", JSON.stringify(remove).replace(/[\[\]\"]/gi, ''));

         if(fileClick > 0) {
             Common.ajaxFile("/eAccounting/creditCard/adjFileUpdate.do"), formData, function(result) {
                 if(result.code == "00") {
                     //fn_editRequest(val);
                	 fn_submitEditAdjustmentWithApprovalLine();
                 } else {
                     Common.alert("File update failed");
                 }
             }
         } else {
        	 fn_submitEditAdjustmentWithApprovalLine();
         }
	}
}

function fn_submitEditAdjustmentWithApprovalLine(){
	console.log($("#adjForm").serializeJSON());
	var apprGridList = AUIGrid.getOrgGridData(approveLineGridID);
	 var obj = {
	            apprGridList : apprGridList,
	            //Final Approval type for crc adjustment
	            clmType: "B3",
	            editData: $("#adjForm").serializeJSON()
	    };

	 	Common.ajaxSync("POST", "/eAccounting/creditCard/submitEditAdjustmentWithApprovalLine.do", obj, function (result3) {
         console.log(result3);

         if(result3.code == "00") {
             Common.alert("Allowance adjustment submitted document number : " + result3.data);
 	        $("#crcApprovalLineCreatePop").remove();
 	        $("#approveLineSearchPop").remove();
 	        $("#crcAdjustmentPop").remove();
         } else {
             Common.alert("Allowance adjustment fail to submit");
         }
     });
     //refresh grid list
     fn_listAdjPln();
}

function fn_submitNewAdjustmentWithApprovalLine(){
	//Submit button clicked, foward to approval line page
    var adjGridList = AUIGrid.getOrgGridData(allowanceAdjGridID);
	var apprGridList = AUIGrid.getOrgGridData(approveLineGridID);
    var obj = {
    		adjGridList: adjGridList,
            apprGridList : apprGridList,
            //Final Approval type for crc adjustment
            clmType: "B3"
    };

	if(adjGridList.length > 0){
        Common.ajaxSync("POST", "/eAccounting/creditCard/submitNewAdjustmentWithApprovalLine.do", obj, function (result3) {
            console.log(result3);

            if(result3.code == "00") {
                Common.alert("Allowance adjustment submitted document number : " + result3.data);
 	        	$("#crcApprovalLineCreatePop").remove();
    	        $("#approveLineSearchPop").remove();
    	        $("#crcAdjustmentPop").remove();
            } else {
                Common.alert("Allowance adjustment fail to submit");
            }
        });

        //refresh grid list
        fn_listAdjPln();
	}
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
	<li><p class="btn_grid"><a href="#" id="lineDel_btn"><spring:message code="newWebInvoice.btn.delete" /></a></p></li>
</ul>

<article class="grid_wrap" id="approveLine_grid_wrap"><!-- grid_wrap start -->
</article><!-- grid_wrap end -->

<ul class="center_btns">
	<li><p class="btn_blue2"><a href="#" id="submit"><spring:message code="newWebInvoice.btn.submit" /></a></p></li>
</ul>

</section><!-- search_result end -->

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->