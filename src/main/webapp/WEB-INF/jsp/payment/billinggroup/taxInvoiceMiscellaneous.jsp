<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>

<script type="text/javaScript">

//AUIGrid 그리드 객체
var myGridID;

//Grid에서 선택된 RowID
var selectedGridValue;

//Default Combo Data
var invoiceTypeData = [{"codeId": "117","codeName": "HP Registration Invoice (BR64)"},
                            {"codeId": "118","codeName": "AS Invoice (BR62)"},
                            {"codeId": "121","codeName": "POS Invoice (BR66)"},
                            {"codeId": "142","codeName": "POS Invoice (BR68)"},
                            {"codeId": "122","codeName": "Item Bank Invoice (BR65)"},
                            {"codeId": "123","codeName": "WholeSales Invoice (BR63)"},
                            {"codeId": "124","codeName": "Product Lost Invoice (BR56)"},
                            {"codeId": "125","codeName": "Early Termination Invoice (BR52)"}
                            ];

// 화면 초기화 함수 (jQuery 의 $(document).ready(function() {}); 과 같은 역할을 합니다.
$(document).ready(function(){
    //메인 페이지
    doDefCombo(invoiceTypeData, '' ,'invoiceType', 'S', '');        //Claim Type 생성

    //Grid Properties 설정
    var gridPros = {
            editable : false,                 // 편집 가능 여부 (기본값 : false)
            showStateColumn : false     // 상태 칼럼 사용
    };

    // Order 정보 (Master Grid) 그리드 생성
    myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout,null,gridPros);

    // Master Grid 셀 클릭시 이벤트
    AUIGrid.bind(myGridID, "cellClick", function( event ){
        selectedGridValue = event.rowIndex;
    });
});


// AUIGrid 칼럼 설정
var columnLayout = [
    { dataField:"taxInvcType" ,headerText:"Tax Invoice Type",width: 100 , editable : false ,visible : false},
    { dataField:"taxInvcRefNo" ,headerText:"Invoice No.",width: 200 , editable : false },
    { dataField:"taxInvcSvcNo" ,headerText:"Service No.",width: 200  , editable : false },
    { dataField:"taxInvcCustName" ,headerText:"Customer Name" , editable : false },
    { dataField:"taxInvcRefDt" ,headerText:"Invoice Date",width: 200 , editable : false , dataType : "date", formatString : "dd-mm-yyyy"},
    { dataField:"taxInvcAmtDue" ,headerText:"Invoice Amount",width: 200 , editable : false, dataType : "numeric", formatString : "#,##0.00"},
    { dataField:"month" ,headerText:"Month",width: 100 , editable : false ,visible : false},
    { dataField:"year" ,headerText:"Year",width: 100 , editable : false ,visible : false}
    ];

// 리스트 조회.
function fn_getTaxInvoiceListAjax() {

	if(FormUtil.checkReqValue($("#invoiceType option:selected"))){
        Common.alert('* Please select the invoice type. <br />');
        return;
    }

    Common.ajax("POST", "/payment/selectTaxInvoiceMiscellaneousList.do", $("#searchForm").serializeJSON(), function(result) {
        AUIGrid.setGridData(myGridID, result);
    });
}


//크리스탈 레포트
function fn_generateInvoice(){
    var selectedItem = AUIGrid.getSelectedIndex(myGridID);

    if (selectedItem[0] > -1){
        //report form에 parameter 세팅
        var taxInvcType = AUIGrid.getCellValue(myGridID, selectedGridValue, "taxInvcType");             //taxInvoice Id
        var taxInvcSvcNo = AUIGrid.getCellValue(myGridID, selectedGridValue, "taxInvcSvcNo"); //service No
        var taxInvcRefNo = AUIGrid.getCellValue(myGridID, selectedGridValue, "taxInvcRefNo");               //br No. = invoiceNo
        var month = AUIGrid.getCellValue(myGridID, selectedGridValue, "month");
        var year = AUIGrid.getCellValue(myGridID, selectedGridValue, "year");

        switch (taxInvcType){
        case 117 :
            if( parseInt(year)*100 + parseInt(month) >= 201809){
                $("#reportPDFForm #reportFileName").val('/statement/TaxInvoice_Miscellaneous_HPRegistration_PDF_SST.rpt');
            }
            else {
                $("#reportPDFForm #reportFileName").val('/statement/TaxInvoice_Miscellaneous_HPRegistration_PDF.rpt');
            }
            break;
        case 118 :
            if( parseInt(year)*100 + parseInt(month) >= 201809){
                $("#reportPDFForm #reportFileName").val('/statement/TaxInvoice_Miscellaneous_AS_PDF_SST.rpt');
            }
            else {
                $("#reportPDFForm #reportFileName").val('/statement/TaxInvoice_Miscellaneous_AS_PDF.rpt');
            }
            break;
        case 121 :
            if( parseInt(year)*100 + parseInt(month) >= 201809){
                $("#reportPDFForm #reportFileName").val('/statement/TaxInvoice_Miscellaneous_POS_PDF_SST.rpt');
            }
            else {
                $("#reportPDFForm #reportFileName").val('/statement/TaxInvoice_Miscellaneous_POS_PDF.rpt');
            }
            break;
        case 122 :
            if( parseInt(year)*100 + parseInt(month) >= 201809){
                $("#reportPDFForm #reportFileName").val('/statement/TaxInvoice_Miscellaneous_ItemBank_PDF_SST.rpt');
            }
            else {
                $("#reportPDFForm #reportFileName").val('/statement/TaxInvoice_Miscellaneous_ItemBank_PDF.rpt');
            }
            break;
        case 123 :
            if( parseInt(year)*100 + parseInt(month) >= 201809){
                $("#reportPDFForm #reportFileName").val('/statement/TaxInvoice_Miscellaneous_WholeSales_PDF_SST.rpt');
            }
            else {
                $("#reportPDFForm #reportFileName").val('/statement/TaxInvoice_Miscellaneous_WholeSales_PDF.rpt');
            }
            break;
        case 124 :
            if( parseInt(year)*100 + parseInt(month) >= 201809){
                $("#reportPDFForm #reportFileName").val('/statement/TaxInvoice_Miscellaneous_ProductLost_PDF_SST.rpt');
            }
            else {
                $("#reportPDFForm #reportFileName").val('/statement/TaxInvoice_Miscellaneous_ProductLost_PDF.rpt');
            }
            break;
        case 125 :
            if(taxInvcSvcNo.indexOf('SCT') > -1){
                if( parseInt(year)*100 + parseInt(month) >= 201809){
                    $("#reportPDFForm #reportFileName").val('/statement/TaxInvoice_Miscellaneous_Termination_ServiceContract_PDF_SST.rpt');
                }
                else {
                    $("#reportPDFForm #reportFileName").val('/statement/TaxInvoice_Miscellaneous_Termination_ServiceContract_PDF.rpt');
                }
            }else{
                if( parseInt(year)*100 + parseInt(month) >= 201809){
                    $("#reportPDFForm #reportFileName").val('/statement/TaxInvoice_Miscellaneous_Termination_PDF_SST.rpt');
                }
                else {
                    $("#reportPDFForm #reportFileName").val('/statement/TaxInvoice_Miscellaneous_Termination_PDF.rpt');
                }
            }
            break;
        case 142 :
            if( parseInt(year)*100 + parseInt(month) >= 201809){
                $("#reportPDFForm #reportFileName").val('/statement/TaxInvoice_Miscellaneous_ItemBank_PDF_SST.rpt');
            }
            else {
                $("#reportPDFForm #reportFileName").val('/statement/TaxInvoice_Miscellaneous_ItemBank_PDF.rpt');
            }
            break;
        default:
            break;
    }

        $("#reportPDFForm #v_serviceNo").val(taxInvcSvcNo);
        $("#reportPDFForm #v_invoiceType").val(taxInvcType);

        //report 호출
        var option = {
                isProcedure : true, // procedure 로 구성된 리포트 인경우 필수.
        };

        Common.report("reportPDFForm", option);

    }else{
        Common.alert('<b>No print type selected.</b>');
    }
}

function fn_Clear(){
    $("#searchForm")[0].reset();
}

</script>

<!-- content start -->
<section id="content">
    <ul class="path">
        <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
        <li>Billing</li>
        <li>Billing Group</li>
        <li>Tax Invoice - Miscellaneous</li>
    </ul>

    <!-- title_line start -->
    <aside class="title_line">
        <p class="fav"><a href="#" class="click_add_on">My menu</a></p>
        <h2>Tax Invoice - Miscellaneous</h2>
        <ul class="right_btns">
            <li><p class="btn_blue"><a href="javascript:fn_generateInvoice();">Generate Invoice</a></p></li>
            <li><p class="btn_blue"><a href="javascript:fn_getTaxInvoiceListAjax();"><span class="search"></span>Search</a></p></li>
            <li><p class="btn_blue"><a href="javascript:fn_Clear();"><span class="clear"></span>Clear</a></p></li>
        </ul>
    </aside>
    <!-- title_line end -->

    <!-- search_table start -->
    <section class="search_table">
        <form name="searchForm" id="searchForm"  method="post">
			<input id="pdpaMonth" name="pdpaMonth" type="hidden" value='${pdpaMonth}'/>
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
                            <input type="text" id="invoicePeriod" name="invoicePeriod"  title="Invoice Period" placeholder="Invoice Period" class="j_date2 w100p" placeholder="MM/YYYY"/>
                       </td>
                    </tr>
                    <tr>
                       <th scope="row">Service No.</th>
                       <td colspan="3">
                            <input type="text" id="serviceNo" name="serviceNo" title="Service No." placeholder="Service No. (Eg: HP Code / ASR No. /  POS No. / IBB No. / PST No. / OCR No.)" class="w100p" />
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
    <input type="hidden" id="reportFileName" name="reportFileName" value="" />
    <input type="hidden" id="viewType" name="viewType" value="PDF" />
    <input type="hidden" id="v_serviceNo" name="v_serviceNo" />
    <input type="hidden" id="v_invoiceType" name="v_invoiceType" />
</form>

