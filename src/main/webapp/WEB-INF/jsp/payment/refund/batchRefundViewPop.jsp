<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<style type="text/css">
/* 커스텀 칼럼 스타일 정의 */
.aui-grid-user-custom-left {
    text-align:left;
}
/* 커스텀 칼럼 스타일 정의 */
.aui-grid-user-custom-right {
    text-align:right;
}
</style>
<script type="text/javascript">
var viewGridID;
var viewColumnLayout = [ {
    dataField : "validStusId",
    headerText : "<spring:message code='pay.head.validStatus'/>"
}, {
    dataField : "validRem",
    headerText : "<spring:message code='pay.head.validRemark'/>",
    style : "aui-grid-user-custom-left"
}, {
	dataField : "salesOrdNo",
    headerText : "<spring:message code='pay.head.orderNo'/>"
}, {
	dataField : "worNo",
    headerText : "<spring:message code='pay.head.worNo'/>"
}, {
	dataField : "amt",
    headerText : "<spring:message code='pay.head.amount'/>",
    style : "aui-grid-user-custom-right",
    dataType: "numeric",
    formatString : "#,##0.00"
}, {
	dataField : "bankAcc",
    headerText : "<spring:message code='pay.head.bankAcc'/>",
    style : "aui-grid-user-custom-left"
}, {
    dataField : "refNo",
    headerText : "<spring:message code='pay.head.refNo'/>"
}, {
    dataField : "chqNo",
    headerText : "<spring:message code='pay.head.chqNo'/>"
}, {
    dataField : "name",
    headerText : "<spring:message code='pay.head.issueBank'/>",
    style : "aui-grid-user-custom-left"
}, {
    dataField : "refDtMonth",
    headerText : "<spring:message code='pay.head.refDateMonth'/>"
}, {
    dataField : "refDtDay",
    headerText : "<spring:message code='pay.head.refDateDay'/>"
}, {
    dataField : "refDtYear",
    headerText : "<spring:message code='pay.head.refDateYear'/>"
}
];

//그리드 속성 설정
var viewGridPros = {
    // 페이징 사용       
    usePaging : true,
    // 한 화면에 출력되는 행 개수 20(기본값:20)
    pageRowCount : 20,
    headerHeight : 40,
    height : 240,
    enableFilter : true,
    // 셀 선택모드 (기본값: singleCell)
    selectionMode : "multipleCells"
};

$(document).ready(function () {
	viewGridID = AUIGrid.create("#bRefund_view_grid_wrap", viewColumnLayout, viewGridPros);
	
	$("#close_btn").click(fn_closePop);
	$("#allItem_btn").click(function() {
		setFilterByValues(0);
	});
	$("#validItem_btn").click(function() {
        setFilterByValues(4);
    });
	$("#invalidItem_btn").click(function() {
        setFilterByValues(21);
    });
	$('#excelDown').click(function() {    
		GridCommon.exportTo("bRefund_view_grid_wrap", 'xlsx', 'Batch Refund Item List');
	});
	
	console.log('${bRefundInfo.totalValidAmt}');
	var str =""+ Number('${bRefundInfo.totalValidAmt}').toFixed(2);
    
    var str2 = str.split(".");
   
    if(str2.length == 1){           
        str2[1] = "00";
    }
    
    str = str2[0].replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,')+"."+str2[1];
    console.log(str);
    
    $("#totAmt").text(str);
	
	console.log($.parseJSON('${bRefundItem}'));
	AUIGrid.setGridData(viewGridID, $.parseJSON('${bRefundItem}'));
});

function fn_closePop() {
	$("#bRefundViewPop").remove();
}

//값에 따라 필터링을 지정합니다.
function setFilterByValues(validStusId) {

    // 참고 : 단순 값에 따른 필터링이 아닌 복잡한 형태(예: 정규식등) 로 필터링 하려면
    // AUIGrid.setFiler() 메소드를 사용하십시오.
    
    // 이름이 "Anna", "Emma" 인 행으로 필터링합니다.
    // 4 : valid, 21 : invalid
    console.log("setFilterByValues");
    console.log(validStusId);
    if(validStusId == 4) {
    	AUIGrid.setFilterByValues(viewGridID, "validStusId", [4]);
    } else if(validStusId == 21) {
    	AUIGrid.setFilterByValues(viewGridID, "validStusId", [21]);
    } else {
    	AUIGrid.clearFilterAll(viewGridID);
    }
    
}
</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Batch Refund View</h1>
<ul class="right_opt">
	<li><p class="btn_blue2"><a href="#" id="close_btn"><spring:message code='sys.btn.close'/></a></p></li>
</ul>

</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<section class="search_table"><!-- search_table start -->

<form action="#" id="form_bRefundView">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:140px" />
	<col style="width:*" />
	<col style="width:130px" />
	<col style="width:*" />
	<col style="width:170px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row">Batch ID</th>
	<td>${bRefundInfo.batchId}</td>
	<th scope="row">Batch Status</th>
	<td>${bRefundInfo.name}</td>
	<th scope="row">Confirm Status</th>
    <td>${bRefundInfo.name1}</td>
</tr>
<tr>
	<th scope="row">Paymode</th>
	<td>${bRefundInfo.codeName}</td>
	<th scope="row">Upload By</th>
	<td>${bRefundInfo.username1}</td>
	<th scope="row">Upload At</th>
    <td>${bRefundInfo.updDt}</td>
</tr>
<tr>
	<th scope="row">Confirm By</th>
	<td>${bRefundInfo.c1}</td>
	<th scope="row">Confirm At</th>
	<td>${bRefundInfo.cnfmDt}</td>
	<th scope="row"></th>
    <td></td>
</tr>
<tr>
	<th scope="row">Convert By</th>
	<td>${bRefundInfo.c2}</td>
	<th scope="row">Convert At</th>
	<td>${bRefundInfo.cnvrDt}</td>
	<th scope="row">Total Amount (Valid)</th>
    <td id="totAmt"></td>
</tr>
<tr>
	<th scope="row">Total Item</th>
	<td>${bRefundInfo.totalItem}</td>
	<th scope="row">Total Valid</th>
	<td>${bRefundInfo.totalValid}</td>
	<th scope="row">Total Invalid</th>
    <td>${bRefundInfo.totalInvalid}</td>
</tr>
</tbody>
</table><!-- table end -->
</form>

</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<aside class="title_line"><!-- title_line start -->
<ul class="right_btns">
	<li><p class="btn_grid"><a href="#" id="allItem_btn"><spring:message code='pay.btn.allItems'/></a></p></li>
	<li><p class="btn_grid"><a href="#" id="validItem_btn"><spring:message code='pay.btn.validItems'/></a></p></li>
	<li><p class="btn_grid"><a href="#" id="invalidItem_btn"><spring:message code='pay.btn.invalidItems'/></a></p></li>
</ul>
</aside><!-- title_line end -->

<article class="grid_wrap" id="bRefund_view_grid_wrap"><!-- grid_wrap start -->
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#" id="excelDown"><spring:message code='pay.btn.exceldw'/></a></p></li>
</ul>

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->
