<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">

//AUIGrid 그리드 객체
var myGridID;

//Grid에서 선택된 RowID
var selectedGridValue;

//Default Combo Data
var appTypeData = [{"codeId": "67","codeName": "Outright"},{"codeId": "68","codeName": "Installment"}];

// 화면 초기화 함수 (jQuery 의 $(document).ready(function() {}); 과 같은 역할을 합니다.
$(document).ready(function(){
    //메인 페이지
    doDefCombo(appTypeData, '' ,'appType', 'M', 'f_multiCombo');        //Claim Type 생성

    //Grid Properties 설정
    var gridPros = {
            editable : false,                 // 편집 가능 여부 (기본값 : false)
            showStateColumn : false,     // 상태 칼럼 사용
            showFooter : false
    };

 // AUIGrid 칼럼 설정
 var columnLayout = [
     { dataField:"taxInvcId" ,headerText:"<spring:message code='pay.head.taxInvcId'/>",width: 100 , editable : false ,visible : false},
     { dataField:"taxInvcRefNo" ,headerText:"<spring:message code='pay.head.invoiceNo'/>",width: 180 , editable : false },
     { dataField:"taxInvcRefDt" ,headerText:"<spring:message code='pay.head.invoiceDate'/>",width: 180 , editable : false , dataType : "date", formatString : "dd-mm-yyyy"},
     { dataField:"invcItmOrdNo" ,headerText:"<spring:message code='pay.head.orderNo'/>",width: 200, editable : false },
     { dataField:"codeName" ,headerText:"<spring:message code='pay.head.appType'/>",width: 150 ,editable : false },
     { dataField:"invcItmProductModel" ,headerText:"<spring:message code='pay.head.productModel'/>",width: 200 , editable : false },
     { dataField:"taxInvcCustName" ,headerText:"<spring:message code='pay.head.customerName'/>" , editable : false },
     { dataField:"taxInvcCustId" ,headerText:"Customer ID", editable : false }, //added by keyi 20211013
     { dataField:"invcItmAmtDue" ,headerText:"<spring:message code='pay.head.invoiceAmt'/>",width: 200 , editable : false, dataType : "numeric", formatString : "#,##0.#"},
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

});

//멀티 셀렉트 세팅 함수들
function f_multiCombo() {

    $(function() {
        $('#appType').change(function() {

        }).multipleSelect({
            selectAll : true, // 전체선택
            width : '80%'
        }).multipleSelect("checkAll");
    });
}


// 리스트 조회.
function fn_getTaxInvoiceListAjax() {

    if(FormUtil.checkReqValue($("#orderNo")) &&  FormUtil.checkReqValue($("#invoiceNo")) &&  FormUtil.checkReqValue($("#custID"))){
        //Common.alert("<spring:message code='pay.alert.invoiceNoOROrderNo'/>");
        Common.alert('* Please Input Order No OR Invoice No OR Customer ID.<br/>');
        return;
    }

    Common.ajax("POST", "/payment/selectTaxInvoiceOutrightList.do", $("#searchForm").serializeJSON(), function(result) {
        AUIGrid.setGridData(myGridID, result);
    });
}

function fn_generateEInvoice(){
  var selectedItem = AUIGrid.getSelectedIndex(myGridID);

  if (selectedItem[0] > -1){
      //report form에 parameter 세팅
      var month = AUIGrid.getCellValue(myGridID, selectedGridValue, "month");
      var year = AUIGrid.getCellValue(myGridID, selectedGridValue, "year");
      var invcItmOrdNo = AUIGrid.getCellValue(myGridID,selectedGridValue, "invcItmOrdNo");
      var taxInvcRefDt = AUIGrid.getCellValue(myGridID,selectedGridValue, "taxInvcRefDt");
      var reportDownFileName = "";
      var genEInv = AUIGrid.getCellValue(myGridID,selectedGridValue, "genEInv");

      if(genEInv == "Y" && (parseInt(year) * 100 + parseInt(month) >= 202408)){

	      var InvoiceDate = new Date(taxInvcRefDt);
	      var Day = (InvoiceDate.getDate() < 10) ? ('0' + InvoiceDate.getDate()):InvoiceDate.getDate();
	      var Month = InvoiceDate.getMonth() + 1;
	      Month = (Month < 10) ? ('0' + Month) : Month;

	      reportDownFileName = 'PUBLIC_eInvoice_' + invcItmOrdNo + '_InvoiceDate(' + Day + Month + InvoiceDate.getFullYear() + ')';
	      $("#reportPDFForm #reportDownFileName").val(reportDownFileName);
	      $("#reportPDFForm #reportFileName").val('/statement/TaxInvoice_Outright_PDF_EIV.rpt');
	      $("#reportPDFForm #v_taxInvoiceId").val(AUIGrid.getCellValue(myGridID, selectedGridValue, "taxInvcId"));

	      //report 호출
	      var option = {
	          isProcedure : true, // procedure 로 구성된 리포트 인경우 필수.
	      };

	      Common.report("reportPDFForm", option);
	  }else{
		  Common.alert("E-Invoice will not be generated before 01/08/2024.");
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
      var invcItmOrdNo = AUIGrid.getCellValue(myGridID,selectedGridValue, "invcItmOrdNo"); //Added by keyi 20211013
      var taxInvcRefDt = AUIGrid.getCellValue(myGridID,selectedGridValue, "taxInvcRefDt"); //Added by keyi 20211013
      var reportDownFileName = ""; //Added by keyi 20211013

 	   if( parseInt(year)*100 + parseInt(month) >= 201809){
          $("#reportPDFForm #reportFileName").val('/statement/TaxInvoice_Outright_PDF_SST.rpt');
      }else{
    	  $("#reportPDFForm #reportFileName").val('/statement/TaxInvoice_Outright_PDF.rpt');
      }

      $("#reportPDFForm #v_taxInvoiceId").val(AUIGrid.getCellValue(myGridID, selectedGridValue, "taxInvcId"));

    //Added by keyi 20211013
      var InvoiceDate = new Date(taxInvcRefDt);
      var Day = (InvoiceDate.getDate() < 10) ? ('0' + InvoiceDate.getDate()):InvoiceDate.getDate();
      var Month = InvoiceDate.getMonth() + 1;
      Month = (Month < 10) ? ('0' + Month) : Month;

      reportDownFileName = 'PUBLIC_TaxInvoice_' + invcItmOrdNo + '_InvoiceDate(' + Day + Month + InvoiceDate.getFullYear() + ')';
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
<h1>Tax Invoice - Outright</h1>
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
                        <th scope="row">Invoice No</th>
                        <td>
                            <input type="text" id="invoiceNo" name="invoiceNo" title="Invoice No." placeholder="Invoice No." class="w100p" />
                        </td>
                        <th scope="row">Invoice Period</th>
                        <td>
                           <input type="text" id="invoicePeriod" name="invoicePeriod"  title="Invoice Period" placeholder="Invoice Period" class="j_date2 w100p" />
                        </td>
                    </tr>
                    <tr>
                       <th scope="row">Order No.</th>
                       <td>
                            <input type="text" id="orderNo" name="orderNo" title="Order No." placeholder="Order No." class="w100p" />
                       </td>
                       <th scope="row">App Type</th>
                       <td>
                            <select id="appType" name="appType[]" class="w100p"></select>
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
    <input type="hidden" id="v_taxInvoiceId" name="v_taxInvoiceId" />
</form>
</div>