<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<style type="text/css">
/* 커스텀 칼럼 스타일 정의 */
.aui-grid-user-custom-left {
    text-align:left;
}
</style>
<script type="text/javascript">
var selectRowIdx;
var approveLineColumnLayout = [
{
    dataField : "approveNo",
    headerText : '<spring:message code="approveLine.approveNo" />',
    dataType: "numeric",
    expFunction : function( rowIndex, columnIndex, item, dataField ) { // 여기서 실제로 출력할 값을 계산해서 리턴시킴.
        // expFunction 의 리턴형은 항상 Number 여야 합니다.(즉, 수식만 가능)
    	return rowIndex + 1;
    }
},{
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
            //console.log("selectRowIdx : " + selectRowIdx);
        	selectRowIdx = rowIndex;
            fn_searchUserIdPop();
            }
        },
    colSpan : -1
},{
    dataField : "name",
    headerText : '<spring:message code="approveLine.name" />',
    style : "aui-grid-user-custom-left"
}
/*
, {
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
        		fn_appvLineGridAddRow();
        	}

        }
       }
}
*/
];

//그리드 속성 설정
var approveLineGridPros = {
    // 페이징 사용
    usePaging : true,
    // 한 화면에 출력되는 행 개수 20(기본값:20)
    pageRowCount : 20,
    //showStateColumn : true,
    // 셀, 행 수정 후 원본으로 복구 시키는 기능 사용 가능 여부 (기본값:true)
    enableRestore : true,
    showRowNumColumn : false,
    //softRemovePolicy : "exceptNew", //사용자추가한 행은 바로 삭제
    //softRemoveRowMode : false,
    // 셀 선택모드 (기본값: singleCell/multipleCells)
    selectionMode : "singleCell"
};

var approveLineGridID;

$(document).ready(function () {

	 resetGrid();

    //approveLineGridID = AUIGrid.create("#approveLine_grid_wrap", approveLineColumnLayout, approveLineGridPros);

    $("#submit").click(fn_reqstSubmit);

    AUIGrid.bind(approveLineGridID, "cellClick", function( event ) {
    	        //console.log("CellClick rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex + " clicked");
    	        selectRowIdx = event.rowIndex;
    	    });

    fn_appvLineGridAddRow();
});

function fn_appvLineGridAddRow() {
    AUIGrid.addRow(approveLineGridID, {}, "first");
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
                //console.log(memInfo);
                AUIGrid.setCellValue(approveLineGridID, selectRowIdx, "memCode", memInfo.memCode);
                AUIGrid.setCellValue(approveLineGridID, selectRowIdx, "name", memInfo.name);
            }
        });
    } else {
        Common.alert('Not allowed to select same User ID in Approval Line');
    }
}

function fn_reqstSubmit() {
    // Get the grid data from the popup
    var gridData = AUIGrid.getGridData(approveLineGridID);
    var selectedRow = gridData[selectRowIdx];
    var memCode = selectedRow ? selectedRow.memCode : null;

    if (memCode) {

        window.close();  // Close the popup window
    } else {
        //alert("Please select Approval Line to proceed.");

        window.close();
    }
}

//Function to reset the grid properly by destroying it and recreating it
function resetGrid() {
    // Check if the grid is initialized and destroy it
    if (approveLineGridID) {
        AUIGrid.destroy(approveLineGridID);  // Destroy the existing grid
        //console.log("Grid destroyed");
    }

    // Reinitialize the grid
    approveLineGridID = AUIGrid.create("#approveLine_grid_wrap", approveLineColumnLayout, approveLineGridPros);
    //console.log("Grid reinitialized");
}
</script>

<div id="popup_wrap" class="popup_wrap size_mid2"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="approveLine.title" /></h1>
<ul class="right_opt">
	<li><p class="btn_blue2"><a href="#" id="closepop"><spring:message code="newWebInvoice.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<section class="search_result"><!-- search_result start -->

<article class="grid_wrap" id="approveLine_grid_wrap"><!-- grid_wrap start -->
</article><!-- grid_wrap end -->

<ul class="center_btns">
	<li><p class="btn_blue2"><a href="#" id="submit"><spring:message code="newWebInvoice.btn.submit" /></a></p></li>
</ul>

</section><!-- search_result end -->

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->