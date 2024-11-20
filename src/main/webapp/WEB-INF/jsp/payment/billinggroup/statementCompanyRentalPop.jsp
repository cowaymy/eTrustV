<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">

//AUIGrid 그리드 객체
var myGridID;

//Grid에서 선택된 RowID
var selectedGridValue;

// 화면 초기화 함수 (jQuery 의 $(document).ready(function() {}); 과 같은 역할을 합니다.
$(document).ready(function(){

    //Grid Properties 설정
    var gridPros = {
            editable : false,                 // 편집 가능 여부 (기본값 : false)
            showStateColumn : false     // 상태 칼럼 사용
    };

 // AUIGrid 칼럼 설정
 var columnLayout = [
     { dataField:"stateId" ,headerText:"StatementId",width: 100 , editable : false ,visible : false},
     { dataField:"year" ,headerText:"<spring:message code='pay.head.year'/>",width: 100 , editable : false },
     { dataField:"month" ,headerText:"<spring:message code='pay.head.month'/>",width: 80  , editable : false },
     { dataField:"stateItmRefNo" ,headerText:"<spring:message code='pay.head.billNo'/>",width: 200  , editable : false },
     { dataField:"stateItmOrdNo" ,headerText:"<spring:message code='pay.head.orderNo'/>",width: 200  , editable : false },
     { dataField:"stateCustName" ,headerText:"<spring:message code='pay.head.custName'/>" , editable : false },
     { dataField:"stateCustId" ,headerText:"Customer ID", editable : false } //added by keyi 20211013

     ];

    // Order 정보 (Master Grid) 그리드 생성
    myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout,null,gridPros);

    // Master Grid 셀 클릭시 이벤트
    AUIGrid.bind(myGridID, "cellClick", function( event ){
        selectedGridValue = event.rowIndex;
    });
});


// 리스트 조회.
function fn_getTaxInvoiceListAjax() {
	var roleId = '${SESSION_INFO.roleId}';
	var userTypeId = '${SESSION_INFO.userTypeId}';
    if(roleId == 256){
        $("#searchForm #userBranchId").val('${SESSION_INFO.userBranchId}');
    }
    
    if(userTypeId == 2){
        $("#searchForm #userTypeId").val(userTypeId);
        $("#searchForm #memLevel").val('${SESSION_INFO.memberLevel}');
        $("#searchForm #memId").val('${SESSION_INFO.memId}');
        $("#searchForm #deptCode").val('${SESSION_INFO.deptCode}');
        $("#searchForm #grpCode").val('${SESSION_INFO.groupCode}');
        $("#searchForm #orgCode").val('${SESSION_INFO.orgCode}');
    }

    if(FormUtil.checkReqValue($("#billingNo")) && FormUtil.checkReqValue($("#orderNo")) && FormUtil.checkReqValue($("#custID"))){
    	//Common.alert("<spring:message code='pay.alert.billNoOROrderNo'/>");
    	 Common.alert('* Please Input Billing No OR Order No OR Customer ID.<br/>');
        return;
    }

    Common.ajax("POST", "/payment/selectStatementCompanyRental.do", $("#searchForm").serializeJSON(), function(result) {
        AUIGrid.setGridData(myGridID, result);
    });
}

//크리스탈 레포트
function fn_generateInvoice(){
    var selectedItem = AUIGrid.getSelectedIndex(myGridID);

    if (selectedItem[0] > -1){
        //report form에 parameter 세팅
        $("#reportPDFForm #V_STATEMENTID").val(AUIGrid.getCellValue(myGridID, selectedGridValue, "stateId"));

        //Added by keyi 20211013
        var stateItmOrdNo = AUIGrid.getCellValue(myGridID,selectedGridValue, "stateItmOrdNo");
        var year = AUIGrid.getCellValue(myGridID,selectedGridValue, "year");
        var month = AUIGrid.getCellValue(myGridID,selectedGridValue, "month");
        month = (month < 10) ? ('0' + month) : month;
        var reportDownFileName = "";

        reportDownFileName = 'PUBLIC_SOA_' + stateItmOrdNo + '_StatementPeriod(' + month + year + ')';
        $("#reportPDFForm #reportDownFileName").val(reportDownFileName);

        //report 호출
        var option = {
                isProcedure : true, // procedure 로 구성된 리포트 인경우 필수.
        };

        Common.report("reportPDFForm", option);

    }else{
    	Common.alert("<spring:message code='pay.alert.noPrintType'/>");
    }
}

function fn_clear(){
    $("#searchForm")[0].reset();
    AUIGrid.clearGridData(myGridID);
}
</script>
<div id="popup_wrap" class="popup_wrap size_large"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Statement Company Rental</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#"><spring:message code="newWebInvoice.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body" style="min-height: auto;"><!-- pop_body start -->
        <ul class="right_btns">
            <li><p class="btn_blue"><a href="javascript:fn_generateInvoice();"><spring:message code='pay.btn.invoice.generate'/></a></p></li>
            <li><p class="btn_blue"><a href="javascript:fn_getTaxInvoiceListAjax();"><span class="search"></span><spring:message code='sys.btn.search'/></a></p></li>
            <li><p class="btn_blue"><a href="javascript:fn_clear();"><span class="clear"></span><spring:message code='sys.btn.clear'/></a></p></li>
        </ul>
    <!-- search_table start -->
    <section class="search_table">
        <form name="searchForm" id="searchForm"  method="post">
			<input id="pdpaMonth" name="pdpaMonth" type="hidden" value='${pdpaMonth}'/>
			<input id="userBranchId" name="userBranchId" type="hidden" value="" />
            <input id="userTypeId" name="userTypeId" type="hidden" value="" />
            <input id="memLevel" name="memLevel" type="hidden" value="" />
            <input id="memId" name="memId" type="hidden" value="" />
            <input id="deptCode" name="deptCode" type="hidden" value="" />
            <input id="grpCode" name="grpCode" type="hidden" value="" />
            <input id="orgCode" name="orgCode" type="hidden" value="" />
            <table class="type1"><!-- table start -->
                <caption>table</caption>
                <colgroup>
                    <col style="width:140px" />
                    <col style="width:*" />
                    <col style="width:180px" />
                    <col style="width:*" />
                </colgroup>
                <tbody>
                    <tr>
                       <th scope="row">Billing No.</th>
                       <td>
                            <input type="text" id="billingNo" name="billingNo" title="Billing No." placeholder="Billing No. (Eg: BR No. / AOR No. / ACN No. / WOR No.)" class="w100p" />
                       </td>
                       <th scope="row">Statement Period</th>
                       <td>
                            <input type="text" id="statementPeriod" name="statementPeriod"  title="Statement Period" placeholder="Statement Period" class="j_date2 w100p" />
                       </td>
                    </tr>
                    <tr>
                       <th scope="row">Order No.</th>
                       <td>
                            <input type="text" id="orderNo" name="orderNo" title="Order No." placeholder="Order No." class="w100p" />
                       </td>
                       <th scope="row">Customer ID</th>
                         <td>
                            <input type="text" id="custID" name="custID" title="Customer ID" placeholder="Customer ID" class="w100p" />
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Customer Name</th>
                        <td colspan="3">
                            <input type="text" id="custName" name="custName" title="Customer Name" placeholder="Customer Name." class="w100p" />
                        </td>
                    </tr>
                </tbody>
            </table>
            <!-- table end -->
        </form>
    </section>
    <!-- search_table end -->

    <!-- search_result start -->
    <section class="search_result">
        <!-- grid_wrap start -->
        <article id="grid_wrap" class="grid_wrap"></article>
        <!-- grid_wrap end -->
    </section>
    <!-- search_result end -->
</section>
<!-- content end -->
<form name="reportPDFForm" id="reportPDFForm"  method="post">
    <input type="hidden" id="reportFileName" name="reportFileName" value="/statement/Official_StatementofAccount_Company_PDF_New.rpt" />
    <input type="hidden" id="reportDownFileName" name="reportDownFileName" />
    <input type="hidden" id="viewType" name="viewType" value="PDF" />
    <input type="hidden" id="V_STATEMENTID" name="V_STATEMENTID" />
</form>
</div>