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
//파일 저장 캐시
var myFileCaches = {};
var roleId = '${SESSION_INFO.roleId}';
var brnch = '${SESSION_INFO.userBranchId}';
var memId = '${SESSION_INFO.memId}';
var ctDutyClaimGridID;
var selectRowIdx;
// 최근 그리드 파일 선택 행 아이템 보관 변수
var recentGridItem = null;
var ctDutyClaimColumnLayout = [
{
        dataField : "isActive",
        headerText : '<input type="checkbox" id="allCheckbox" style="width:15px;height:15px;">',
        width: 30,
        renderer : {
            type : "CheckBoxEditRenderer",
            showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
            editable : true, // 체크박스 편집 활성화 여부(기본값 : false)
            checkValue : "Active", // true, false 인 경우가 기본
            unCheckValue : "Inactive",
            // 체크박스 disabled 함수
            disabledFunction : function(rowIndex, columnIndex, value, isChecked, item, dataField) {
                if(item.curAppvUserId == memId){
                	console.log("saeeeee");
                	return false;
                }else{
                	return true;
                }
            }
        }
    },{
    dataField : "memAccId",
    headerText : '<spring:message code="ctClaim.ctId" />'
}, {
    dataField : "memAccName",
    headerText : '<spring:message code="ctClaim.ctBrName" />',
    style : "aui-grid-user-custom-left"
}, {
    dataField : "clmMonth",
    headerText : '<spring:message code="pettyCashExp.clmMonth" />',
    dataType : "date",
    formatString : "mm/yyyy"
}, {
    dataField : "clmNo",
    headerText : '<spring:message code="invoiceApprove.clmNo" />'
}, {
    dataField : "reqstDt",
    headerText : '<spring:message code="pettyCashRqst.rqstDt" />',
    dataType : "date",
    formatString : "dd/mm/yyyy"
}, {
    dataField : "cur",
    headerText : '<spring:message code="newWebInvoice.cur" />'
}, {
    dataField : "totAmt",
    headerText : '<spring:message code="webInvoice.amount" />',
    style : "aui-grid-user-custom-right",
    dataType: "numeric",
    formatString : "#,##0.00"
}, {
    dataField : "appvPrcssNo",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField : "appvLineSeq",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField : "appvPrcssStusCode",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField : "appvPrcssStus",
    headerText : '<spring:message code="webInvoice.status" />',
    style : "aui-grid-user-custom-left"
}, {
    dataField : "appvPrcssDt",
    headerText : '<spring:message code="pettyCashRqst.appvalDt" />',
    dataType : "date",
    formatString : "dd/mm/yyyy"
}, {
    dataField : "curAppvUserId",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}
];

//그리드 속성 설정
var ctDutyClaimGridPros = {
    // 페이징 사용
    usePaging : true,
    // 한 화면에 출력되는 행 개수 20(기본값:20)
    pageRowCount : 20,
    //showRowCheckColumn : true,
 // 헤더 높이 지정
    headerHeight : 40,
    // 셀 선택모드 (기본값: singleCell)
    selectionMode : "multipleCells"
};

$(document).ready(function () {
	ctDutyClaimGridID = AUIGrid.create("#ctDutyClaim_grid_wrap", ctDutyClaimColumnLayout, ctDutyClaimGridPros);

	if(brnch == "42"){
		doGetCombo('/eAccounting/ctDutyAllowance/getBch.do', '', brnch, 'cmbDscCode', 'S', '');
	}else{
		doGetCombo('/eAccounting/ctDutyAllowance/getBch.do', brnch, brnch, 'cmbDscCode', 'S', '');
		$("#cmbDscCode option[value='"+ brnch +"']", '#form_staffClaim').attr("selected", true);
	    $('#cmbDscCode').trigger('click');
	}

    $("#search_supplier_btn").click(fn_supplierSearchPop);
    $("#registration_btn").click(fn_newCTDutyAllowPop);

    //CTM and above
    $("#approve_btn").click(fn_approvalSubmit);
    $("#reject_btn").click(fn_RejectSubmit);

    $("#_staffClaimBtn").click(function() {

        //Param Set
        var gridObj = AUIGrid.getSelectedItems(ctDutyClaimGridID);


        if(gridObj == null || gridObj.length <= 0 ){
            Common.alert("* No Record Selected. ");
            return;
        }

        var claimno = gridObj[0].item.clmNo;
        $("#_repClaimNo").val(claimno);
        console.log("clmNo : " + $("#_repClaimNo").val());

        fn_report();
        //Common.alert('The program is under development.');
    });

    $("#staffRaw").click(function() {
    	Common.popupDiv("/eAccounting/ctDutyAllowance/ctDutyRawPop.do", null, null, true);
    });

    AUIGrid.bind(ctDutyClaimGridID, "cellClick", function( event ) {
        console.log("CellClick rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex + " clicked");
        selectRowIdx = event.rowIndex;
    });

    AUIGrid.bind(ctDutyClaimGridID, "cellDoubleClick", function( event )
    {
        console.log("CellDoubleClick rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex + " clicked");
        console.log("CellDoubleClick clmNo : " + event.item.clmNo);
        console.log("CellDoubleClick appvPrcssNo : " + event.item.appvPrcssNo);
        console.log("CellDoubleClick appvPrcssStusCode : " + event.item.appvPrcssStusCode);
        // TODO detail popup open
        if(event.item.appvPrcssStusCode == "T") {
        	fn_editStaffClaimPop(event.item.clmNo);
        } else {
        	var clmNo = event.item.clmNo;
            var clmType = clmNo.substr(0, 3);
        	fn_webInvoiceRequestPop(event.item.appvPrcssNo, clmType);
        }

    });

    AUIGrid.bind(ctDutyClaimGridID, "headerClick", headerClickHandler);

    AUIGrid.bind(ctDutyClaimGridID, "ready", function(event) {
        gridDataLength = AUIGrid.getGridData(ctDutyClaimGridID).length; // 그리드 전체 행수 보관
    });

    AUIGrid.bind(ctDutyClaimGridID, "cellEditEnd", function(event) {

        // isActive 칼럼 수정 완료 한 경우
        if(event.dataField == "isActive") {

            // 그리드 데이터에서 isActive 필드의 값이 Active 인 행 아이템 모두 반환
            var activeItems = AUIGrid.getItemsByValue(ctDutyClaimGridID, "isActive", "Active");

            // 헤더 체크 박스 전체 체크 일치시킴.
            if(activeItems.length != gridDataLength) {
                document.getElementById("allCheckbox").checked = false;
            } else if(activeItems.length == gridDataLength) {
                 document.getElementById("allCheckbox").checked = true;
            }
        }
    });

    $("#appvPrcssStus").multipleSelect("checkAll");

    fn_setToMonth();
});

function headerClickHandler(event) {

    // isActive 칼럼 클릭 한 경우
    if(event.dataField == "isActive") {
        if(event.orgEvent.target.id == "allCheckbox") { // 정확히 체크박스 클릭 한 경우만 적용 시킴.
            var  isChecked = document.getElementById("allCheckbox").checked;
            checkAll(isChecked);
        }
        return false;
    }
}

function checkAll(isChecked) {
    var idx = AUIGrid.getRowCount(ctDutyClaimGridID);
   // 그리드의 전체 데이터를 대상으로 isActive 필드를 "Active" 또는 "Inactive" 로 바꿈.
   if(isChecked) {
       for(var i = 0; i < idx; i++){
           if(AUIGrid.getCellValue(ctDutyClaimGridID, i, "curAppvUserId") == memId){
               AUIGrid.setCellValue(ctDutyClaimGridID, i, "isActive", "Active")
           }
       }
   } else {
       AUIGrid.updateAllToValue(ctDutyClaimGridID, "isActive", "Inactive");
   }

   // 헤더 체크 박스 일치시킴.
   document.getElementById("allCheckbox").checked = isChecked;
}

function fn_setToMonth() {
    var month = new Date();

    var mm = month.getMonth() + 1;
    var yyyy = month.getFullYear();

    if(mm < 10){
        mm = "0" + mm
    }

    month = mm + "/" + yyyy;
    $("#clmMonth").val(month);
}

function fn_newCTDutyAllowPop() {
    Common.popupDiv("/eAccounting/ctDutyAllowance/newCtDutyAllowancePop.do", {callType:"new"}, null, true, "newCtDutyAllowancePop");
}

function fn_supplierSearchPop() {
    Common.popupDiv("/eAccounting/ctDutyAllowance/ctCodeSearchPop.do", {accGrp:"VM08"}, null, true, "supplierSearchPop");
}

function fn_setSupplier() {
    $("#memAccId").val($("#search_memAccId").val());
    $("#memAccName").val($("#search_memAccName").val());
}

function fn_selectStaffClaimList() {

	if(FormUtil.isEmpty($("#cmbDscCode").val()) && roleId != '127' && brnch != "42") {
        Common.alert('Plesae select DSC Code');
    }else{
    	Common.ajax("GET", "/eAccounting/ctDutyAllowance/selectCtDutyAllowanceList.do?_cacheId=" + Math.random(), $("#form_staffClaim").serialize(), function(result) {
            console.log(result);
            AUIGrid.setGridData(ctDutyClaimGridID, result);
        });
    }
}

function fn_editStaffClaimPop(clmNo) {
    var data = {
            clmNo : clmNo,
            callType : "edit"
    };
    Common.popupDiv("/eAccounting/ctDutyAllowance/newCtDutyAllowancePop.do", data, null, true, "editCtDutyAllowancePop");
}

function fn_report() {
    var option = {
        isProcedure : true
    };
    Common.report("dataForm", option);
}

function fn_webInvoiceRequestPop(appvPrcssNo, clmType) {
    var data = {
            clmType : clmType
            ,appvPrcssNo : appvPrcssNo
    };
    Common.popupDiv("/eAccounting/ctDutyAllowance/webInvoiceRqstViewPop.do", data, null, true, "webInvoiceRqstViewPop");
}

function fn_approvalSubmit() {

	var date = new Date().getDate();
    if(date.toString().length == 1){
        date = "0" + date;
    }
    console.log("what day? " + date);
    if(date > 15){
    	Common.alert('Before 15th of the month just able to APPROVE Claims.');
        return;
    }

	var checkedItems = AUIGrid.getItemsByValue(ctDutyClaimGridID, "isActive", "Active");
	if(checkedItems.length <= 0) {
        Common.alert('No data selected.');
        return;
    }

	Common.confirm("Are you sure you want to approve this Claim submit form?",function (){
        console.log("click yes");
        fn_appvRejctSubmit("appv", "");
    });
}

function fn_RejectSubmit() {

	var checkedItems = AUIGrid.getItemsByValue(ctDutyClaimGridID, "isActive", "Active");
	if(checkedItems.length <= 0) {
        Common.alert('No data selected.');
        return;
    }

	Common.popupDiv("/eAccounting/ctDutyAllowance/rejectRegistPop.do", null, null, true, "rejectMsgPop");

    /* var rows = AUIGrid.getRowIndexesByValue(invoAprveGridID, "clmNo", [$("#viewClmNo").text()]);
    AUIGrid.setCellValue(invoAprveGridID, rows, "isActive", "Active");
    fn_rejectRegistPop(); */
}

function fn_appvRejctSubmit(type, rejctResn) {
    // 그리드 데이터에서 isActive 필드의 값이 Active 인 행 아이템 모두 반환
    var checkedItems = AUIGrid.getItemsByValue(ctDutyClaimGridID, "isActive", "Active");
    var gridDataLength = AUIGrid.getGridData(ctDutyClaimGridID).length;

    console.log('gridDataLength ' + gridDataLength);
    //console.log('gridData ' + checkedItems);

    var data = {
            invoAppvGridList : checkedItems
            ,rejctResn : rejctResn
    };

    if(type == "appv") {
        url = "/eAccounting/ctDutyAllowance/approvalSubmit.do";
    }else if(type == "rejct") {
        url = "/eAccounting/ctDutyAllowance/rejectionSubmit.do";
    }

    Common.ajax("POST", url, data, function(result) {
    	console.log(result);
    	if(result.code == "99") {

    	}else{
    		if(type == "appv") {
    			fn_selectStaffClaimList();
    			Common.alert("The Claim has been approved.");
            }else if(type == "rejct") {
            	Common.alert("The Claim has been rejected.");
            }
    	}

    });

   }

</script>

<!-- report Form -->
<form id="dataForm">
    <input type="hidden" id="reportFileName" name="reportFileName" value="/e-accounting/CTClaim.rpt" /><!-- Report Name  -->
    <input type="hidden" id="viewType" name="viewType" value="PDF" /><!-- View Type  -->

    <input type="hidden" id="_repClaimNo" name="v_CLM_NO" />
</form>

<section id="content"><!-- content start -->
<ul class="path">
	<li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on"><spring:message code="webInvoice.fav" /></a></p>
<h2>CT Duty Allowance</h2>
<ul class="right_btns">
	<!-- <li><p class="btn_blue"><a href="#"><span class="clear"></span>Clear</a></p></li> -->
    <c:if test="${PAGE_AUTH.funcView == 'Y'}">
	<li><p class="btn_blue"><a href="#" onclick="javascript:fn_selectStaffClaimList()"><span class="search"></span><spring:message code="webInvoice.btn.search" /></a></p></li>
	</c:if>
</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id="form_staffClaim">
<input type="hidden" id="memAccName" name="memAccName">

<table class="type1"><!-- table start -->
<caption><spring:message code="webInvoice.table" /></caption>
<colgroup>
	<col style="width:110px" />
	<col style="width:*" />
	<col style="width:110px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row"><spring:message code="pettyCashExp.clmMonth" /></th>
    <td><input type="text" title="Create start Date" placeholder="MM/YYYY" class="j_date2" id="clmMonth" name="clmMonth"/></td>
	<th scope="row"><spring:message code="ctClaim.ctId" /></th>
	<td><input type="text" title="" placeholder="" class="" id="memAccId" name="memAccId"/><a href="#" class="search_btn" id="search_supplier_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a></td>
</tr>
<tr>
	<th scope="row" ><spring:message code="webInvoice.status" /></th>
	<td>
	<select class="multy_select" multiple="multiple" id="appvPrcssStus" name="appvPrcssStus">
		<option value="T"><spring:message code="webInvoice.select.tempSave" /></option>
        <option value="R"><spring:message code="webInvoice.select.request" /></option>
        <option value="P"><spring:message code="webInvoice.select.progress" /></option>
        <option value="A"><spring:message code="webInvoice.select.approved" /></option>
        <option value="J"><spring:message code="pettyCashRqst.rejected" /></option>
	</select>
	</td>
	<th scope="row"><spring:message code="invoiceApprove.clmNo" /></th>
    <td><input type="text" title="" placeholder="" class="" id="clmNo" name="clmNo"/></td>
</tr>
<c:if test="${PAGE_AUTH.funcUserDefine2 == 'Y'}">
    <th scope="row">DSC Code</th>
    <td>
        <select id="cmbDscCode" name="cmbDscCode" class=""></select>
    </td>
</c:if>
<c:if test="${PAGE_AUTH.funcUserDefine3 == 'Y'}">
    <input type="hidden" id="apprvUserId" name="apprvUserId" value='${SESSION_INFO.memId}'>
</c:if>
</tbody>
</table><!-- table end -->

<aside class="link_btns_wrap"><!-- link_btns_wrap start -->
    <p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
    <dl class="link_list">
        <dt>Link</dt>
        <dd>
        <ul class="btns">
            <c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
            <!-- <li><p class="link_btn"><a href="#" id="_staffClaimBtn">CT Claim</a></p></li> -->
            <li><p class="link_btn"><a href="#" id="staffRaw">CT DUTY ALLOWANCE RAW DATA</a></p></li>
            </c:if>
        </ul>
        <ul class="btns">
        </ul>
        <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
        </dd>
    </dl>
    </aside><!-- link_btns_wrap end -->

</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<ul class="right_btns">
    <c:if test="${PAGE_AUTH.funcChange == 'Y'}">
	<li><p class="btn_grid"><a href="#" id="registration_btn"><spring:message code="pettyCashExp.newExpClm" /></a></p></li>
	</c:if>
	   <c:if test="${PAGE_AUTH.funcUserDefine2 == 'Y'}">
        <li><p class="btn_grid"><a href="#" id="approve_btn"><spring:message code="invoiceApprove.title" /></a></p></li>
        <li><p class="btn_grid"><a href="#" id="reject_btn"><spring:message code="webInvoice.select.reject" /></a></p></li>
    </c:if>
</ul>

<article class="grid_wrap" id="ctDutyClaim_grid_wrap"><!-- grid_wrap start -->
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- content end -->