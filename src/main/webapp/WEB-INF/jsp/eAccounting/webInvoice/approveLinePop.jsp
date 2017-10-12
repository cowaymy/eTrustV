<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">
var approveLineColumnLayout = [ {
    dataField : "approveNo",
    headerText : '<spring:message code="approveLine.approveNo" />'
}, {
    dataField : "userId",
    headerText : '<spring:message code="approveLine.userId" />',
    renderer : {
        type : "IconRenderer",
        iconTableRef :  {
            "default" : "${pageContext.request.contextPath}/resources/images/common/normal_search.png"// default
        },         
        iconWidth : 24,
        iconHeight : 24,
        iconPosition : "aisleRight",
        onclick : function(rowIndex, columnIndex, value, item) {
            fn_expenseTypeSearchPop();
            }
        }

}, {
    dataField : "name",
    headerText : '<spring:message code="approveLine.name" />'
}, {
    dataField : "addition",
    headerText : '<spring:message code="approveLine.addition" />',
    renderer : {
        type : "IconRenderer",
        iconTableRef :  {
            "default" : "${pageContext.request.contextPath}/resources/images/common/btn_plus.gif"// default
        },         
        iconWidth : 12,
        iconHeight : 12,
        onclick : function(rowIndex, columnIndex, value, item) {
        	fn_addRow();
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
};

var approveLineGridID;

$(document).ready(function () {
    approveLineGridID = AUIGrid.create("#approveLine_grid_wrap", approveLineColumnLayout, approveLineGridPros);
    
    $("#delete_btn").click(fn_deleteRow);
    $("#submit").click(fn_approveLineSubmit);
    
    AUIGrid.bind(approveLineGridID, "cellClick", function( event ) {
    	        console.log("CellClick rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex + " clicked");
    	        selectRowIdx = event.rowIndex;
    	    });
    
    fn_addRow();
});

function fn_addRow() {
    AUIGrid.addRow(approveLineGridID, {}, "last");
}

function fn_deleteRow() {
    AUIGrid.removeRow(approveLineGridID, selectRowIdx);
    // remove한 row를 화면상에서도 지우도록 구현 필요
    // totalAmount를 할때 값이 포함된다
    // TO DO
    AUIGrid.update(); // update 해본 결과 : 실패
}

function fn_selectApproveLine() {
    AUIGrid.showAjaxLoader(approveLineGridID);
    
    Common.ajax("POST", "/eAccounting/webInvoice/selectApproveLine.do", null, function(result) {
        
        console.log(result);
        
        AUIGrid.removeAjaxLoader(approveLineGridID);
        
        AUIGrid.setGridData(approveLineGridID, result);
    });
}

function fn_approveLineSubmit() {
	//var data = AUIGrid.exportToObject(approveLineGridID);
    var gridData = GridCommon.getEditData(approveLineGridID);
    
    console.log(gridData);
    
    /* Common.ajax("POST", "/eAccounting/webInvoice/saveGridInfo.do?clmNo=" + clmNo, GridCommon.getEditData(myGridID), function(result) {
        console.log(result);
        Common.alert("Temporary save succeeded.");
        //fn_SelectMenuListAjax() ;

    }); */
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
	<li><p class="btn_grid"><a href="#" id="delete_btn"><spring:message code="newWebInvoice.btn.delete" /></a></p></li>
</ul>

<article class="grid_wrap" id="approveLine_grid_wrap"><!-- grid_wrap start -->
</article><!-- grid_wrap end -->

<ul class="center_btns">
	<li><p class="btn_blue2"><a href="#" id="submit"><spring:message code="newWebInvoice.btn.submit" /></a></p></li>
</ul>

</section><!-- search_result end -->

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->