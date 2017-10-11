<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">
var approveLineColumnLayout = [ {
    dataField : "approveNo",
    headerText : "Approve No"
}, {
    dataField : "userId",
    headerText : "User ID",
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
    headerText : "Name"
}, {
    dataField : "addition",
    headerText : "Addition"
}
];

//그리드 속성 설정
var approveLineGridPros = {
    // 페이징 사용       
    usePaging : true,
    // 한 화면에 출력되는 행 개수 20(기본값:20)
    pageRowCount : 20,
    showStateColumn : true
};

var approveLineGridID;

$(document).ready(function () {
    approveLineGridID = AUIGrid.create("#approveLine_grid_wrap", approveLineColumnLayout, approveLineGridPros);
    
    AUIGrid.bind(approveLineGridID, "cellDoubleClick", function( event ) {
        console.log(event.item);
        
        if($("#newSupplier").length > 0) {
            $("#newSupplier").val(event.item.memAccId);
            $("#gstRegistrationNo").val(event.item.memAccId)
            $("#bank").val(event.item.bankName)
            $("#bankAccount").val(event.item.bankAccNo)
        } else {
            $("#supplier").val(event.item.memAccId);
        }
        
        $("#supplierSearchPop").remove();
  });
    
    fn_addRow();
});

function fn_addRow() {
    AUIGrid.addRow(approveLineGridID, {}, "last");
}

function fn_selectApproveLine() {
    AUIGrid.showAjaxLoader(approveLineGridID);
    
    Common.ajax("POST", "/eAccounting/webInvoice/selectApproveLine.do", null, function(result) {
        
        console.log(result);
        
        AUIGrid.removeAjaxLoader(approveLineGridID);
        
        AUIGrid.setGridData(approveLineGridID, result);
    });
}
</script>

<div id="popup_wrap" class="popup_wrap size_mid2"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Approve Line</h1>
<ul class="right_opt">
	<li><p class="btn_blue2"><a href="#"><spring:message code="newWebInvoice.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<section class="search_result"><!-- search_result start -->

<ul class="right_btns">
	<!--li><p class="btn_grid"><a href="#">Add</a></p></li-->
	<li><p class="btn_grid"><a href="#">Delete</a></p></li>
</ul>

<article class="grid_wrap" id="approveLine_grid_wrap"><!-- grid_wrap start -->
</article><!-- grid_wrap end -->

<ul class="center_btns">
	<li><p class="btn_blue2"><a href="#" id="submit"><spring:message code="newWebInvoice.btn.submit" /></a></p></li>
</ul>

</section><!-- search_result end -->

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->