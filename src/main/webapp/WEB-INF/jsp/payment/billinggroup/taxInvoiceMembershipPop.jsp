<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">

//AUIGrid 그리드 객체
var myGridID;

//Grid에서 선택된 RowID
var selectedGridValue;

//Default Combo Data
var invoiceTypeData = [{"codeId": "119","codeName": "Service Membership Invoice"}];

// 화면 초기화 함수 (jQuery 의 $(document).ready(function() {}); 과 같은 역할을 합니다.
$(document).ready(function(){
	$("#searchForm #table1").hide();
    //메인 페이지
    doDefCombo(invoiceTypeData, '' ,'invoiceType', 'S', '');
    $("#invoiceType option:eq(1)").prop("selected", true);

    //Grid Properties 설정
    var gridPros = {
            editable : false,                 // 편집 가능 여부 (기본값 : false)
            showStateColumn : false,     // 상태 칼럼 사용
            showFooter: false
    };

 // AUIGrid 칼럼 설정
 var columnLayout = [
     { dataField:"taxInvcType" ,headerText:"<spring:message code='pay.head.taxInvoiceType'/>",width: 100 , editable : false ,visible : false},
     { dataField:"taxInvcRefNo" ,headerText:"<spring:message code='pay.head.invoiceNo'/>",width: 180 , editable : false },
     { dataField:"taxInvcSvcNo" ,headerText:"<spring:message code='pay.head.serviceNo'/>",width: 180 , editable : false },
     { dataField:"salesOrdNo" ,headerText:"<spring:message code='pay.head.orderNo'/>",width: 200, editable : false },
     { dataField:"taxInvcCustName" ,headerText:"<spring:message code='pay.head.custName'/>" , editable : false },
     { dataField:"taxInvcCustId" ,headerText:"Customer ID", editable : false }, //added by keyi 20211013
     { dataField:"taxInvcRefDt" ,headerText:"<spring:message code='pay.head.invoiceDate'/>",width: 180 , editable : false , dataType : "date", formatString : "dd-mm-yyyy"},
     { dataField:"invcItmAmtDue" ,headerText:"<spring:message code='pay.head.invoiceAmt'/>",width: 200 , editable : false, dataType : "numeric", formatString : "#,##0.00"},
     { dataField:"month" ,headerText:"Month",width: 100 , editable : false ,visible : false},
     { dataField:"year" ,headerText:"Year",width: 100 , editable : false ,visible : false},
     { dataField:"genEInv" ,headerText:"Generate e-Invoice",width: 10 , editable : false ,visible : false}
     ];

    	// Order 정보 (Master Grid) 그리드 생성
        myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout,null,gridPros);

        // Master Grid 셀 클릭시 이벤트
        AUIGrid.bind(myGridID, "cellClick", function( event ){
            selectedGridValue = event.rowIndex;
        });
        
        var roleId = '${SESSION_INFO.roleId}';
        var userTypeId = '${SESSION_INFO.userTypeId}';
        if(roleId == 256){
            $("#searchForm #userBranchId").val('${SESSION_INFO.userBranchId}');
        }
    
        if(userTypeId == 2){
            $("#searchForm #table1").show();
            $("#searchForm #userTypeId").val(userTypeId);
            
            if ("${SESSION_INFO.memberLevel}" =="1") {
                $("#searchForm #orgCode").val('${SESSION_INFO.orgCode}');
                $("#searchForm #orgCode").attr("class", "w100p readonly");
                $("#searchForm #orgCode").attr("readonly", "readonly");
              } else if ("${SESSION_INFO.memberLevel}" =="2") {
                $("#searchForm #orgCode").val('${SESSION_INFO.orgCode}');
                $("#searchForm #orgCode").attr("class", "w100p readonly");
                $("#searchForm #orgCode").attr("readonly", "readonly");

                $("#searchForm #grpCode").val('${SESSION_INFO.groupCode}');
                $("#searchForm #grpCode").attr("class", "w100p readonly");
                $("#searchForm #grpCode").attr("readonly", "readonly");
              } else if ("${SESSION_INFO.memberLevel}" =="3") {
                $("#searchForm #orgCode").val('${SESSION_INFO.orgCode}');
                $("#searchForm #orgCode").attr("class", "w100p readonly");
                $("#searchForm #orgCode").attr("readonly", "readonly");

                $("#searchForm #grpCode").val('${SESSION_INFO.groupCode}');
                $("#searchForm #grpCode").attr("class", "w100p readonly");
                $("#searchForm #grpCode").attr("readonly", "readonly");

                $("#searchForm #deptCode").val('${SESSION_INFO.deptCode}');
                $("#searchForm #deptCode").attr("class", "w100p readonly");
                $("#searchForm #deptCode").attr("readonly", "readonly");

              } else if ("${SESSION_INFO.memberLevel}" =="4") {
                $("#searchForm #orgCode").val('${SESSION_INFO.orgCode}');
                $("#searchForm #orgCode").attr("class", "w100p readonly");
                $("#searchForm #orgCode").attr("readonly", "readonly");

                $("#searchForm #grpCode").val('${SESSION_INFO.groupCode}');
                $("#searchForm #grpCode").attr("class", "w100p readonly");
                $("#searchForm #grpCode").attr("readonly", "readonly");

                $("#searchForm #deptCode").val('${SESSION_INFO.deptCode}');
                $("#searchForm #deptCode").attr("class", "w100p readonly");
                $("#searchForm #deptCode").attr("readonly", "readonly");

                $("#searchForm #memCode").val('${SESSION_INFO.userMemCode}');
                $("#searchForm #memCode").attr("class", "w100p readonly");
                $("#searchForm #memCode").attr("readonly", "readonly");
              }
          }

});


// 리스트 조회.
function fn_getTaxInvoiceListAjax() {

    if(FormUtil.checkReqValue($("#invoiceType option:selected")) && FormUtil.checkReqValue($("#custID"))){
        //Common.alert("<spring:message code='pay.alert.selectInvoiceType'/>");
        Common.alert('* Please Input Invoice Type OR Customer ID.<br/>');
        return;
    }

    Common.ajax("POST", "/payment/selectTaxInvoiceMembershipList.do", $("#searchForm").serializeJSON(), function(result) {
        AUIGrid.setGridData(myGridID, result);
    });
}

function fn_generateEInvoice(){
    var selectedItem = AUIGrid.getSelectedIndex(myGridID);

    if (selectedItem[0] > -1){
        //report form에 parameter 세팅
        var month = AUIGrid.getCellValue(myGridID, selectedGridValue, "month");
        var year = AUIGrid.getCellValue(myGridID, selectedGridValue, "year");
        var salesOrdNo = AUIGrid.getCellValue(myGridID,selectedGridValue, "salesOrdNo");
        var taxInvcRefDt = AUIGrid.getCellValue(myGridID,selectedGridValue, "taxInvcRefDt");
        var reportDownFileName = "";
        var genEInv = AUIGrid.getCellValue(myGridID,selectedGridValue, "genEInv");

        if(genEInv == "Y" && (parseInt(year) * 100 + parseInt(month) >= 202408)){
            $("#reportPDFForm #reportFileName").val('/statement/TaxInvoice_Miscellaneous_Membership_PDF_EIV.rpt');
	        $("#reportPDFForm #v_serviceNo").val(AUIGrid.getCellValue(myGridID, selectedGridValue, "taxInvcSvcNo"));
	        $("#reportPDFForm #v_invoiceType").val(AUIGrid.getCellValue(myGridID, selectedGridValue, "taxInvcType"));
	        $("#reportPDFForm #v_invoiceNo").val(AUIGrid.getCellValue(myGridID, selectedGridValue, "taxInvcRefNo"));

	        var InvoiceDate = new Date(taxInvcRefDt);
	        var Day = (InvoiceDate.getDate() < 10) ? ('0' + InvoiceDate.getDate()):InvoiceDate.getDate();
	        var Month = InvoiceDate.getMonth() + 1;
	        Month = (Month < 10) ? ('0' + Month) : Month;

	        reportDownFileName = 'PUBLIC_eInvoice_' + salesOrdNo + '_InvoiceDate(' + Day + Month + InvoiceDate.getFullYear() + ')';
	        $("#reportPDFForm #reportDownFileName").val(reportDownFileName);

	        //report 호출
	        var option = {
	            isProcedure : true, // procedure 로 구성된 리포트 인경우 필수.
	        };

	        Common.report("reportPDFForm", option);
        }else{
        	Common.alert("The selected invoice is not applicable for E-Invoice.");
        }

    }else{
        Common.alert("<spring:message code='pay.alert.noPrintType'/>");
    }
}

//크리스탈 레포트
function fn_generateInvoice(){
    var selectedItem = AUIGrid.getSelectedIndex(myGridID);

    if (selectedItem[0] > -1){
        //report form에 parameter 세팅
        var month = AUIGrid.getCellValue(myGridID, selectedGridValue, "month");
        var year = AUIGrid.getCellValue(myGridID, selectedGridValue, "year");
        var salesOrdNo = AUIGrid.getCellValue(myGridID,selectedGridValue, "salesOrdNo"); //Added by keyi 20211013
        var taxInvcRefDt = AUIGrid.getCellValue(myGridID,selectedGridValue, "taxInvcRefDt"); //Added by keyi 20211013
        var reportDownFileName = ""; //Added by keyi 20211013

        if(parseInt(year)*100 + parseInt(month) >= 202404){
        	  $("#reportPDFForm #reportFileName").val('/statement/TaxInvoice_Miscellaneous_Membership_PDF_SST_3.rpt');
        }else if(parseInt(year)*100 + parseInt(month) >= 201809){
            $("#reportPDFForm #reportFileName").val('/statement/TaxInvoice_Miscellaneous_Membership_PDF_SST.rpt');
        }else{
            $("#reportPDFForm #reportFileName").val('/statement/TaxInvoice_Miscellaneous_Membership_PDF.rpt');
        }

        $("#reportPDFForm #v_serviceNo").val(AUIGrid.getCellValue(myGridID, selectedGridValue, "taxInvcSvcNo"));
        $("#reportPDFForm #v_invoiceType").val(AUIGrid.getCellValue(myGridID, selectedGridValue, "taxInvcType"));
        $("#reportPDFForm #v_invoiceNo").val(AUIGrid.getCellValue(myGridID, selectedGridValue, "taxInvcRefNo"));

        //Added by keyi 20211013
        var InvoiceDate = new Date(taxInvcRefDt);
        var Day = (InvoiceDate.getDate() < 10) ? ('0' + InvoiceDate.getDate()):InvoiceDate.getDate();
        var Month = InvoiceDate.getMonth() + 1;
        Month = (Month < 10) ? ('0' + Month) : Month;

        reportDownFileName = 'PUBLIC_TaxInvoice_' + salesOrdNo + '_InvoiceDate(' + Day + Month + InvoiceDate.getFullYear() + ')';
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
<h1>Tax Invoice - Membership</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#"><spring:message code="newWebInvoice.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body" style="min-height: auto;"><!-- pop_body start -->

        <ul class="right_btns">
            <li><p class="btn_blue"><a href="javascript:fn_generateEInvoice();">Generate E-Invoice</a></p></li>
            <li><p class="btn_blue"><a href="javascript:fn_generateInvoice();"><spring:message code='pay.btn.invoice.generate'/></a></p></li>
            <li><p class="btn_blue"><a href="javascript:fn_getTaxInvoiceListAjax();"><span class="search"></span><spring:message code='sys.btn.search'/></a></p></li>
            <li><p class="btn_blue"><a href="javascript:fn_clear();"><span class="clear"></span><spring:message code='sys.btn.clear'/></a></p></li>
        </ul>

    <!-- search_table start -->
    <section class="search_table">
        <form name="searchForm" id="searchForm"  method="post">
			<input id="pdpaMonth" name="pdpaMonth" type="hidden" value='${pdpaMonth}'/>
			<input id="isHc" name="isHc" type="hidden" value='${isHc}'/>
			<input id="userBranchId" name="userBranchId" type="hidden" value="" />
            <input id="userTypeId" name="userTypeId" type="hidden" value="" />
            <table class="type1"><!-- table start -->
                <caption>table</caption>
                <colgroup>
                    <col style="width:140px" />
                    <col style="width:*" />
                    <col style="width:140px" />
                    <col style="width:*" />
                </colgroup>
                <tbody>
                    <tr>
                        <th scope="row">Invoice Type</th>
                        <td colspan="3">
                            <select id="invoiceType" name="invoiceType" class="w100p"></select>
                        </td>
                    </tr>
                    <tr>
                       <th scope="row">Invoice No.</th>
                       <td>
                            <input type="text" id="invoiceNo" name="invoiceNo" title="Invoice No." placeholder="Invoice No." class="w100p" />
                       </td>
                       <th scope="row">Invoice Period</th>
                       <td>
                            <input type="text" id="invoicePeriod" name="invoicePeriod"  title="Invoice Period" placeholder="Invoice Period" class="j_date2 w100p" />
                       </td>
                    </tr>
                    <tr>
                        <th scope="row">Service No.</th>
                       <td>
                            <input type="text" id="serviceNo" name="serviceNo" title="Service No. (Eg: SM No.)" placeholder="Service No. (Eg: SM No.)" class="w100p" />
                       </td>
                       <th scope="row">Order No.</th>
                       <td>
                            <input type="text" id="orderNo" name="orderNo" title="Order No." placeholder="Order No." class="w100p" />
                       </td>
                    </tr>
                    <tr>
                        <th scope="row">Customer Name</th>
                        <td>
                            <input type="text" id="custName" name="custName" title="Customer Name" placeholder="Customer Name." class="w100p" />
                        </td>
                        <th scope="row">Customer ID</th>
                         <td>
                            <input type="text" id="custID" name="custID" title="Customer ID" placeholder="Customer ID" class="w100p" />
                        </td>
                    </tr>
                </tbody>
            </table>
            <!-- table end -->
            <table class="type1" id="table1">
                    <!-- table start -->
                    <caption>table</caption>
                    <colgroup>
                        <col style="width: 140px" />
                        <col style="width: *" />
                        <col style="width: 140px" />
                        <col style="width: *" />
                        <col style="width: 140px" />
                        <col style="width: *" />
                        <col style="width: 140px" />
                        <col style="width: *" />
                    </colgroup>
                    <tbody>
                        <tr>
                            <th scope="row"><spring:message code="sal.text.orgCode" /></th>
                            <td><input type="text" title="" id="orgCode" name="orgCode"
                                class="w100p"/></td>
                            <th scope="row"><spring:message code="sal.text.grpCode" /></th>
                            <td><input type="text" title="" id="grpCode" name="grpCode"
                                class="w100p" /></td>
                            <th scope="row"><spring:message code="sal.text.detpCode" /></th>
                            <td><input type="text" title="" id="deptCode"
                                name="deptCode" class="w100p" /></td>
                            <th scope="row"><spring:message code="sal.text.memberCode" /></th>
                            <td><input type="text" title="" id="memCode" name="memCode"
                                class="w100p" /></td>
                        </tr>
                    </tbody>
                </table>
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
    <input type="hidden" id="reportFileName" name="reportFileName" value="" />
    <input type="hidden" id="reportDownFileName" name="reportDownFileName" />
    <input type="hidden" id="viewType" name="viewType" value="PDF" />
    <input type="hidden" id="v_serviceNo" name="v_serviceNo" />
    <input type="hidden" id="v_invoiceType" name="v_invoiceType" />
    <input type="hidden" id="v_invoiceNo" name="v_invoiceNo" />
</form>
</div>