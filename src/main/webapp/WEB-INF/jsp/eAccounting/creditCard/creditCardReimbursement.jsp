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
var clickType = "";
var clmNo = "";
var reimbursementColumnLayout = [ {
    dataField : "crditCardUserId",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField : "crditCardUserName",
    headerText : 'Card Holder',
    style : "aui-grid-user-custom-left"
}, {
    dataField : "crditCardNo",
    headerText : 'Card no.'
}, {
    dataField : "chrgUserId",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField : "chrgUserName",
    headerText : 'Charge Name',
    style : "aui-grid-user-custom-left"
}, {
    dataField : "costCentr",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField : "costCentrName",
    headerText : 'Cost Center',
    style : "aui-grid-user-custom-left"
}, {
    dataField : "clmMonth",
    headerText : 'Claim Month',
    dataType : "date",
    formatString : "mm/yyyy"
}, {
    dataField : "clmNo",
    headerText : 'Claim No'
}, {
    dataField : "reqstDt",
    headerText : 'Request Date',
    dataType : "date",
    formatString : "dd/mm/yyyy"
}, {
    dataField : "allTotAmt",
    headerText : '<spring:message code="webInvoice.amount" />',
    style : "aui-grid-user-custom-right",
    dataType: "numeric",
    formatString : "#,##0.00"
},{
    dataField : "appvPrcssStusCode",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField : "appvPrcssStus",
    headerText : '<spring:message code="webInvoice.status" />',
    style : "aui-grid-user-custom-left"
}, {
    dataField : "appvPrcssDt",
    headerText : 'Approval Date',
    dataType : "date",
    formatString : "dd/mm/yyyy"
} 
];

//그리드 속성 설정
var reimbursementGridPros = {
    // 페이징 사용       
    usePaging : true,
    // 한 화면에 출력되는 행 개수 20(기본값:20)
    pageRowCount : 20
};

var reimbursementGridID;

$(document).ready(function () {
	reimbursementGridID = AUIGrid.create("#reimbursement_grid_wrap", reimbursementColumnLayout, reimbursementGridPros);
    
    $("#search_holder_btn").click(function() {
        clickType = "holder";
        fn_searchUserIdPop();
    });
    $("#search_charge_btn").click(function() {
        clickType = "charge";
        fn_searchUserIdPop();
    });
    $("#search_depart_btn").click(fn_costCenterSearchPop);
    $("#registration_btn").click();
    
    AUIGrid.bind(reimbursementGridID, "cellDoubleClick", function( event ) 
            {
                console.log("cellDoubleClick rowIndex : " + event.rowIndex + ", cellDoubleClick : " + event.columnIndex + " cellDoubleClick");
                console.log("cellDoubleClick clmNo : " + event.item.clmNo);
                clmNo = event.item.clmNo;
            });
    
    $("#appvPrcssStus").multipleSelect("checkAll");
    
    fn_setToDay();
});

function fn_setToDay() {
    var today = new Date();
    
    var dd = today.getDate();
    var mm = today.getMonth() + 1;
    var yyyy = today.getFullYear();
    
    if(dd < 10) {
        dd = "0" + dd;
    }
    if(mm < 10){
        mm = "0" + mm
    }
    
    today = dd + "/" + mm + "/" + yyyy;
    $("#startDt").val(today)
    $("#endDt").val(today)
}

function fn_searchUserIdPop() {
    Common.popupDiv("/common/memberPop.do", null, null, true);
}

// 그리드에 set 하는 function
function fn_loadOrderSalesman(memId, memCode) {

    Common.ajax("GET", "/sales/order/selectMemberByMemberIDCode.do", {memId : memId, memCode : memCode}, function(memInfo) {

        if(memInfo == null) {
            Common.alert('<b>Member not found.</br>Your input member code : '+memCode+'</b>');
        }
        else {
            console.log(memInfo);
            console.log(memInfo.memCode);
            console.log(memInfo.name);
            console.log(clickType);
            if(clickType == "holder") {
                $("#crditCardUserId").val(memInfo.memCode);
                $("#crditCardUserName").val(memInfo.name);
            } else if(clickType == "charge") {
                $("#chrgUserId").val(memInfo.memCode);
                $("#chrgUserName").val(memInfo.name);
            } else if(clickType == "newHolder") {
                $("#newCrditCardUserId").val(memInfo.memCode);
                $("#newCrditCardUserName").val(memInfo.name);
            } else if(clickType == "newCharge") {
                $("#newChrgUserId").val(memInfo.memCode);
                $("#newChrgUserName").val(memInfo.name);
            }
        }
    });
}

function fn_costCenterSearchPop() {
    Common.popupDiv("/eAccounting/webInvoice/costCenterSearchPop.do", null, null, true, "costCenterSearchPop");
}

function fn_popCostCenterSearchPop() {
    Common.popupDiv("/eAccounting/webInvoice/costCenterSearchPop.do", {pop:"pop"}, null, true, "costCenterSearchPop");
}

function fn_setCostCenter() {
    $("#costCenter").val($("#search_costCentr").val());
    $("#costCenterText").val($("#search_costCentrName").val());
}

function fn_setPopCostCenter() {
    $("#newCostCenter").val($("#search_costCentr").val());
    $("#newCostCenterText").val($("#search_costCentrName").val());
}

function fn_selectReimbursementList() {
    Common.ajax("GET", "/eAccounting/creditCard/selectReimbursementList.do", $("#form_reimbursement").serialize(), function(result) {
        console.log(result);
        AUIGrid.setGridData(reimbursementGridID, result);
    });
}
</script>

<section id="content"><!-- content start -->
<ul class="path">
	<li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
	<li>Sales</li>
	<li>Order list</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>Credit Card Reimbursement</h2>
<ul class="right_btns">
	<li><p class="btn_blue"><a href="#" onclick="javascript:fn_selectReimbursementList()"><span class="search"></span>Search</a></p></li>
	<!-- <li><p class="btn_blue"><a href="#"><span class="clear"></span>Clear</a></p></li> -->
</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id="form_reimbursement">
<input type="hidden" id="crditCardUserId" name="crditCardUserId">
<input type="hidden" id="chrgUserId" name="chrgUserId">
<input type="hidden" id="costCenter" name="costCentr">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:170px" />
	<col style="width:*" />
	<col style="width:210px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row">Credit cardholder name</th>
	<td><input type="text" title="" placeholder="" class="" id="crditCardUserName" name="crditCardUserName"/><a href="#" class="search_btn" id="search_holder_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a></td>
	<th scope="row">Credit card no.</th>
	<td><input type="text" title="" placeholder="Credit card No" class="" id="crditCardNo" name="crditCardNo" autocomplete=off/></td>
</tr>
<tr>
	<th scope="row">Person-in-charge name</th>
	<td><input type="text" title="" placeholder="" class="" id="chrgUserName" name="chrgUserName"/><a href="#" class="search_btn" id="search_charge_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a></td>
	<th scope="row">Person-in-charge department</th>
	<td><input type="text" title="" placeholder="" class="" id="costCenterText" name="costCentrName"/><a href="#" class="search_btn" id="search_depart_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a></td>
</tr>
	<th scope="row">Request Date</th>
	<td>

	<div class="date_set"><!-- date_set start -->
	<p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date"  id="startDt" name="startDt"/></p>
	<span>To</span>
	<p><input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" id="endDt" name="endDt"/></p>
	</div><!-- date_set end -->

	</td>
	<th scope="row">Status</th>
	<td>
	<select class="multy_select" multiple="multiple" id="appvPrcssStus" name="appvPrcssStus">
		<option value="T"><spring:message code="webInvoice.select.save" /></option>
        <option value="R"><spring:message code="webInvoice.select.request" /></option>
        <option value="P"><spring:message code="webInvoice.select.progress" /></option>
        <option value="A"><spring:message code="webInvoice.select.approved" /></option>
        <option value="J"><spring:message code="webInvoice.select.reject" /></option>
	</select>
	</td>
</tr>
</tbody>
</table><!-- table end -->

</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<ul class="right_btns">
	<li><p class="btn_grid"><a href="#" id="registration_btn">New Expense Claim</a></p></li>
</ul>

<article class="grid_wrap" id="reimbursement_grid_wrap"><!-- grid_wrap start -->
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- content end -->