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
     { dataField:"taxInvcType" ,headerText:"Tax Invoice Type",width: 100 , editable : false ,visible : false},
     { dataField:"taxInvcRefNo" ,headerText:"Invoice No.",width: 180 , editable : false },
     { dataField:"taxInvcSvcNo" ,headerText:"Service No.",width: 180 , editable : false },
     { dataField:"invcItmOrdNo" ,headerText:"Order No.",width: 200, editable : false },
     { dataField:"taxInvcCustName" ,headerText:"Customer Name" , editable : false },
     { dataField:"taxInvcRefDt" ,headerText:"Invoice Date",width: 180 , editable : false , dataType : "date", formatString : "dd-mm-yyyy"},
     { dataField:"invcItmAmtDue" ,headerText:"Invoice Amount",width: 200 , editable : false, dataType : "numeric", formatString : "#,##0.00"}
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
    
    if(FormUtil.checkReqValue($("#invoiceType option:selected")) ){
        Common.alert('* Please select the invoice type. <br />');
        return;
    }
    
    Common.ajax("POST", "/payment/selectTaxInvoiceMembershipList.do", $("#searchForm").serializeJSON(), function(result) {
        AUIGrid.setGridData(myGridID, result);
    });
}


//크리스탈 레포트
function fn_generateInvoice(){
    var selectedItem = AUIGrid.getSelectedIndex(myGridID);

    if (selectedItem[0] > -1){
        //report form에 parameter 세팅
        $("#reportPDFForm #v_serviceNo").val(AUIGrid.getCellValue(myGridID, selectedGridValue, "taxInvcSvcNo"));
        $("#reportPDFForm #v_invoiceType").val(AUIGrid.getCellValue(myGridID, selectedGridValue, "taxInvcType"));
        $("#reportPDFForm #v_invoiceNo").val(AUIGrid.getCellValue(myGridID, selectedGridValue, "taxInvcRefNo"));
    
        //report 호출
        var option = {
            isProcedure : true, // procedure 로 구성된 리포트 인경우 필수.
            };

        Common.report("reportPDFForm", option);
     
    }else{
        Common.alert('<b>No print type selected.</b>');
    }
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
            <li><p class="btn_blue"><a href="javascript:fn_generateInvoice();">Generate Invoice</a></p></li>
            <li><p class="btn_blue"><a href="javascript:fn_getTaxInvoiceListAjax();">Search</a></p></li>
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
    <input type="hidden" id="reportFileName" name="reportFileName" value="/statement/TaxInvoice_Miscellaneous_Membership_PDF.rpt" />
    <input type="hidden" id="viewType" name="viewType" value="PDF" />
    <input type="hidden" id="v_serviceNo" name="v_serviceNo" />
    <input type="hidden" id="v_invoiceType" name="v_invoiceType" />
    <input type="hidden" id="v_invoiceNo" name="v_invoiceNo" />
</form>
</div>