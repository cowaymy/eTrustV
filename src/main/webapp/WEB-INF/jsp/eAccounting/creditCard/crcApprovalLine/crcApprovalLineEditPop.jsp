<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<style type="text/css">
/* 커스텀 칼럼 스타일 정의 */
.aui-grid-user-custom-left {
    text-align:left;
}

/* 커스텀 행 스타일 */
.my-yellow-style {
    background:#FFE400;
    font-weight:bold;
    color:#22741C;
}
</style>
<script type="text/javascript">
var docNo;
var approvalInfos;
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
    dataField : "appvPrcssUserId",
    visible:false
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
}, {
    dataField : "name",
    headerText : '<spring:message code="approveLine.name" />',
    style : "aui-grid-user-custom-left"
}, {
    dataField : "appvStus",
	visible:false
}, {
    dataField : "appvStusName",
    headerText : 'Approve Status'
},  {
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
        	if (rowCount > 3) {
        		Common.alert('<spring:message code="approveLine.appvLine.msg" />');
        	} else {
            	var nextRowData = AUIGrid.getItemByRowIndex(approveLineGridID,rowIndex + 1);
            	if(nextRowData){
            		if(nextRowData.appvStus == "J" || nextRowData.appvStus == "A")
            		{
            			Common.alert("Approval Line is not allowed to be added as next approval line has been Approved/Rejected");
            			return false;
            		}
            	}

        		fn_appvLineGridAddRow({},"selectionDown");
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
	docNo = "${docNo}";
	$('#adjustmentNoText').text(docNo);
    approveLineGridID = AUIGrid.create("#approveLine_grid_wrap", approveLineColumnLayout, approveLineGridPros);

    $("#lineDel_btn").click(fn_appvLineDeleteRow);
    $("#submit").click(fn_editSubmit);


    loadExistingApprovalInfo();

    AUIGrid.bind(approveLineGridID, "cellClick", function( event ) {
 	        console.log("CellClick rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex + " clicked");
 	        selectRowIdx = event.rowIndex;
 	    });

    AUIGrid.bind(approveLineGridID, "rowStateCellClick", function(event) {
    	selectRowIdx = event.rowIndex;
    	fn_appvLineDeleteRow();
    	return false;
  });
});

//empty obj - {} if adding empty item, able to accept multiple objects
//rowIndex - last,selectionDown
function fn_appvLineGridAddRow(item,rowIndex) {
    AUIGrid.addRow(approveLineGridID, item, rowIndex);
}

function fn_appvLineDeleteRow() {
	 if(!FormUtil.isEmpty(AUIGrid.getCellValue(approveLineGridID, selectRowIdx, "appvStus"))) {
		 var stus = AUIGrid.getCellValue(approveLineGridID, selectRowIdx, "appvStus");
		 if(stus == "A" || stus == "J"){
			 Common.alert("Approver selected has approve/rejected the record. Unable to remove.");
		 }
		 else{
			AUIGrid.removeRow(approveLineGridID, selectRowIdx);
		 }
	 }
	 else{
			AUIGrid.removeRow(approveLineGridID, selectRowIdx);
	 }
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
                AUIGrid.setCellValue(approveLineGridID, selectRowIdx, "memCode", memInfo.memCode);
                AUIGrid.setCellValue(approveLineGridID, selectRowIdx, "name", memInfo.name);
            }
        });
    } else {
        Common.alert('Not allowed to select same User ID in Approval Line');
    }
}

function loadExistingApprovalInfo() {
	if('${result}' == null || '${result}' == ""){
		approvalInfos = null;
    }
    else{
    	var result = '${result}';
    	approvalInfos = $.parseJSON(result);
        fn_appvLineGridAddRow(approvalInfos,"last");
        fn_setRowStyle();
    }
}

function fn_setRowStyle(){
	AUIGrid.setProp(approveLineGridID, "rowStyleFunction", function(rowIndex, item) {
        if(item.appvStus == "A" || item.appvStus == "J") {
    		return "my-yellow-style";
        }
     });

     // 변경된 rowStyleFunction 이 적용되도록 그리드 업데이트
     AUIGrid.update(approveLineGridID);
}

function fn_editSubmit() {
	var length = AUIGrid.getGridData(approveLineGridID).length;
	var checkMemCode = true;
    if(length > 1) {
        for(var i = 0; i < length; i++) {
            if(FormUtil.isEmpty(AUIGrid.getCellValue(approveLineGridID, i, "memCode"))) {
                Common.alert('<spring:message code="approveLine.userId.msg" />' + (i +1) + ".");
                checkMemCode = false;
            }
        }
    }
	if(checkMemCode) {
		Common.confirm("Are you sure you want to edit the approval line?", fn_approveLineEditFinalApprCheck);
	}
}

function fn_approveLineEditFinalApprCheck() {
	var apprGridList = AUIGrid.getOrgGridData(approveLineGridID);
    var obj = {
            apprGridList : apprGridList,
            docNo : docNo,
            //Final Approval type for crc adjustment
            clmType: "B3"
    };
    console.log(obj);
    Common.ajax("POST", "/eAccounting/creditCard/checkFinAppr.do", obj, function(resultFinAppr) {
        console.log(resultFinAppr);

        if(resultFinAppr.code == "99") {
            Common.alert("Please select the relevant final approver.");
        } else {
        	fn_approvalLineEditSubmission();
        }
    });
}

function fn_approvalLineEditSubmission(){
	var apprGridList = AUIGrid.getOrgGridData(approveLineGridID);
	 var obj = {
	            apprGridList : apprGridList,
	            docNo : docNo,
	            //Final Approval type for crc adjustment
	            clmType: "B3"
	    };

	 	Common.ajaxSync("POST", "/eAccounting/creditCard/editApprovalLineSubmit.do", obj, function (result3) {
        console.log(result3);

        if(result3.code == "00") {
            Common.alert("Approval Line Edit Successfull for Adjustment No: " + docNo);
	        $("#crcApprovalLineEditPop").remove();
	        $("#approveLineSearchPop").remove();
        } else {
            Common.alert("Approval Line Edit Failed for Adjustment No: " + docNo);
        }
    });
    //refresh grid list
    fn_listAdjPln();
}
</script>

<div id="popup_wrap" class="popup_wrap size_mid2"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="approveLine.title" /> Edit </h1>
<ul class="right_opt">
	<li><p class="btn_blue2"><a href="#"><spring:message code="newWebInvoice.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<section class="search_result"><!-- search_result start -->

<div><label>Adjustment No: </label><span id="adjustmentNoText"></span></div>
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