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
var confirmGridID;
var confirmColumnLayout = [ {
    dataField : "validStusId",
    headerText : 'Valid Status'
}, {
    dataField : "validRem",
    headerText : 'Valid Remark',
    style : "aui-grid-user-custom-left"
}, {
	dataField : "salesOrdNo",
    headerText : 'Order No'
}, {
	dataField : "worNo",
    headerText : 'WOR No'
}, {
	dataField : "amt",
    headerText : 'Amount',
    style : "aui-grid-user-custom-right",
    dataType: "numeric",
    formatString : "#,##0.00"
}, {
	dataField : "bankAcc",
    headerText : 'Bank Acc',
    style : "aui-grid-user-custom-left"
}, {
    dataField : "refNo",
    headerText : 'Ref No'
}, {
    dataField : "chqNo",
    headerText : 'Chq No'
}, {
    dataField : "name",
    headerText : 'Issue Bank',
    style : "aui-grid-user-custom-left"
}, {
    dataField : "refDtMonth",
    headerText : 'Ref Date (Month)'
}, {
    dataField : "refDtDay",
    headerText : 'Ref Date (Day)'
}, {
    dataField : "refDtYear",
    headerText : 'Ref Date (Year)'
}
];

//그리드 속성 설정
var confirmGridPros = {
    // 페이징 사용       
    usePaging : true,
    // 한 화면에 출력되는 행 개수 20(기본값:20)
    pageRowCount : 20,
    headerHeight : 40,
    height : 480,
    enableFilter : true
};

$(document).ready(function () {
	confirmGridID = AUIGrid.create("#bRefund_confirm_grid_wrap", confirmColumnLayout, confirmGridPros);
	
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
	
	$("#deactivate_btn").click(fn_deactivate);
	
	$("#pConfirm_btn").click(fn_confirm);
	
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
	AUIGrid.setGridData(confirmGridID, $.parseJSON('${bRefundItem}'));
});

function fn_closePop() {
	$("#bRefundConfirmPop").remove();
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
    	AUIGrid.setFilterByValues(confirmGridID, "validStusId", [4]);
    } else if(validStusId == 21) {
    	AUIGrid.setFilterByValues(confirmGridID, "validStusId", [21]);
    } else {
    	AUIGrid.clearFilterAll(confirmGridID);
    }
    
}

function fn_deactivate() {
	Common.confirm('Are you sure want to deactivate this refund batch ?',function (){
		Common.ajax("GET", "/payment/batchRefundDeactivate.do", $("#form_bRefundConfirm").serialize(), function(result) {
	        console.log(result);
	        
	        Common.alert(result.message);
	        
	        fn_closePop();
	        
	        fn_selectBatchRefundList();
	    });
	});
}

function fn_confirm() {
	Common.confirm('Are you sure want to confirm this refund batch ?',function (){
		if(Number($("#totInvalidCount").text()) > 0) {
	        Common.alert('There is some invalid item exist.<br />Batch confirm is disallowed.');
	    } else {
	        if(Number($("#totValidCount").text()) > 0) {
	            Common.ajax("GET", "/payment/batchRefundConfirm.do", $("#form_bRefundConfirm").serialize(), function(result) {
	                console.log(result);
	                
	                //$('#btnConf').hide();
                    //$('#btnDeactivate').hide();
	                
	                Common.alert(result.message);
	                
	                fn_closePop();
	                
	                fn_selectBatchRefundList();
	            });
	        } else {
	            Common.alert('No valid item found.<br />Batch confirm is disallowed.');
	        }
	    }
	});
}
</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Batch Refund Confirmation</h1>
<ul class="right_opt">
	<li><p class="btn_blue2"><a href="#" id="close_btn">Close</a></p></li>
</ul>

</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<section class="search_table"><!-- search_table start -->

<form action="#" id="form_bRefundConfirm">
<input type="hidden" id="batchId" name="batchId">

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
	<td id="totItemCount">${bRefundInfo.totalItem}</td>
	<th scope="row">Total Valid</th>
	<td id="totValidCount">${bRefundInfo.totalValid}</td>
	<th scope="row">Total Invalid</th>
    <td id="totInvalidCount">${bRefundInfo.totalInvalid}</td>
</tr>
</tbody>
</table><!-- table end -->
</form>

</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<aside class="title_line"><!-- title_line start -->
<ul class="right_btns">
	<li><p class="btn_grid"><a href="#" id="allItem_btn">All Items</a></p></li>
	<li><p class="btn_grid"><a href="#" id="validItem_btn">Valid Items</a></p></li>
	<li><p class="btn_grid"><a href="#" id="invalidItem_btn">Invalid Items</a></p></li>
</ul>
</aside><!-- title_line end -->

<article class="grid_wrap" id="bRefund_confirm_grid_wrap"><!-- grid_wrap start -->
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

<c:if test="${bRefundInfo.batchStusId ne 4 && bRefundInfo.cnfmStusId ne 77}">
<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#" id="pConfirm_btn">Confirm</a></p></li>
    <li><p class="btn_blue2 big"><a href="#" id="deactivate_btn">Deactivate</a></p></li>
</ul>
</c:if>

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->
