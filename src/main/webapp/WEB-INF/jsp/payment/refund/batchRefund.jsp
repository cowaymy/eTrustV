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
var batchId = 0;
var bRefundColumnLayout = [ {
    dataField : "batchId",
    headerText : "<spring:message code='pay.head.batchId'/>",
    dataType : "numeric"
}, {
    dataField : "codeName",
    headerText : "<spring:message code='pay.head.payType'/>"
}, {
    dataField : "name",
    headerText : "<spring:message code='pay.head.batchStatus'/>"
}, {
    dataField : "name1",
    headerText : "<spring:message code='pay.head.confirmStatus'/>"
}, {
    dataField : "updDt",
    headerText : "<spring:message code='pay.head.uploadDate'/>",
    dataType : "date",
    formatString : "dd/mm/yyyy"
}, {
    dataField : "username1",
    headerText : "<spring:message code='pay.head.uploadBy'/>"
}, {
    dataField : "cnfmDt",
    headerText : "<spring:message code='pay.head.confirmDate'/>"
}, {
    dataField : "c1",
    headerText : "<spring:message code='pay.head.confirmBy'/>"
}, {
    dataField : "cnvrDt",
    headerText : "<spring:message code='pay.head.convertDate'/>"
}, {
    dataField : "c2",
    headerText : "<spring:message code='pay.head.convertBy'/>"
}
];

//그리드 속성 설정
var bRefundGridPros = {
    // 페이징 사용       
    usePaging : true,
    // 한 화면에 출력되는 행 개수 20(기본값:20)
    pageRowCount : 20,
    // 셀 선택모드 (기본값: singleCell)
    selectionMode : "multipleCells",
    showStateColumn : true
};

var bRefundGridID;

$(document).ready(function () {
	bRefundGridID = AUIGrid.create("#bRefund _grid_wrap", bRefundColumnLayout, bRefundGridPros);
	
	$("#viewPop_btn").click(fn_bRefundViewPop);
	$("#uploadPop_btn").click(fn_bRefundUploadPop);
	$("#confirm_btn").click(fn_bRefundConfirmPop);
	
	/* $("#payMode").multipleSelect("checkAll");
    $("#confirmStatus").multipleSelect("setSelects", [44]);
    $("#batchStatus").multipleSelect("setSelects", [1]); */
	
    CommonCombo.make("payMode", "/payment/selectCodeList.do", null, "", {
        id: "code",
        name: "codeName",
        type:"M"
    });
    
	$("#batchStus").multipleSelect("checkAll");
	$("#cnfmStus").multipleSelect("checkAll");
	
	fn_setToDay();
	
	AUIGrid.bind(bRefundGridID, "cellClick", function( event ) {
        console.log("CellClick rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex + " clicked");
        console.log("CellClick batchId : " + event.item.batchId);
        // TODO pettyCash Expense Info GET
        batchId = event.item.batchId;
    });
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

function fn_bRefundViewPop() {
	if(batchId > 0) {
		Common.popupDiv("/payment/batchRefundViewPop.do", {batchId:batchId}, null, true, "bRefundViewPop");
		
	} else {
		Common.alert('No batch selected.');
	}
}

function fn_selectBatchRefundList() {
	Common.ajax("GET", "/payment/selectBatchRefundList.do?_cacheId=" + Math.random(), $("#form_bRefund").serialize(), function(result) {
        console.log(result);
        AUIGrid.setGridData(bRefundGridID, result);
    });
}

function fn_formClear() {
	$("#form_bRefund").each(function() {
        this.reset();
    });
}

function fn_bRefundUploadPop() {
	Common.popupDiv("/payment/batchRefundUploadPop.do", null, null, true, "bRefundUploadPop");
	
}

function fn_bRefundConfirmPop() {
	if(batchId > 0) {
		Common.popupDiv("/payment/batchRefundConfirmPop.do", {batchId:batchId}, null, true, "bRefundConfirmPop");
		
    } else {
        Common.alert('No batch selected.');
    }
}
</script>

<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>Batch Refund</h2>
<ul class="right_btns">
    <li><p class="btn_blue"><a href="#" onclick="javascript:fn_selectBatchRefundList()"><span class="search"></span><spring:message code='sys.btn.search'/></a></p></li>
    <li><p class="btn_blue"><a href="#" onclick="javascript:fn_formClear()"><span class="clear"></span><spring:message code='sys.btn.clear'/></a></p></li>
</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form action="#" id="form_bRefund">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
    <col style="width:180px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Batch ID</th>
    <td><input type="text" title="Batch ID (Number Only)" placeholder="Batch ID (Number Only)" class="w100p" id="batchId" name="batchId"/></td>
    <th scope="row">Paymode</th>
    <td>
    <select class="multy_select w100p" multiple="multiple" id="payMode" name="payMode"></select>
    </td>
</tr>
<tr>
    <th scope="row">Create Date</th>
    <td>
    <div class="date_set w100p"><!-- date_set start -->
    <p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" id="startDt" name="startDt"/></p>
    <span>To</span>
    <p><input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" id="endDt" name="endDt"/></p>
    </div><!-- date_set end -->
    </td>
    <th scope="row">Confirm Status</th>
    <td>
    <select class="multy_select w100p" multiple="multiple" id="cnfmStus" name="cnfmStus">
    <option value="44">Pending</option>
    <option value="77">Confirm</option>
    </select>
    </td>
</tr>
<tr>
    <th scope="row">Batch Status</th>
    <td>
    <select class="multy_select w100p" multiple="multiple" id="batchStus" name="batchStus">
    <option value="1">Active</option>
    <option value="4">Completed</option>
    <option value="8">Inactive</option>
    </select>
    </td>
    <th scope="row">Creator</th>
    <td>
    <input type="text" title="Creator (Username)" placeholder="Creator (Username)" class="w100p" id="crdUserName" name="crtUserIdName"/>
    </td>
</tr>
</tbody>
</table><!-- table end -->

</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<ul class="right_btns">
    <li><p class="btn_grid"><a href="#" id="confirm_btn"><spring:message code='pay.btn.confirm'/></a></p></li>
    <li><p class="btn_grid"><a href="#" id="uploadPop_btn"><spring:message code='pay.btn.upload'/></a></p></li>
    <li><p class="btn_grid"><a href="#" id="viewPop_btn"><spring:message code='pay.btn.view'/></a></p></li>
</ul>

<article class="grid_wrap" id="bRefund _grid_wrap"><!-- grid_wrap start -->
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- content end -->
