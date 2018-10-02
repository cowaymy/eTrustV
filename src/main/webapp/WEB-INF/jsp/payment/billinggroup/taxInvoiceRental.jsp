<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>

<script type="text/javaScript">

//AUIGrid 그리드 객체
var myGridID;

//Grid에서 선택된 RowID
var selectedGridValue;

//Default Combo Data
var invoiceTypeData = [{"codeId": "1267","codeName": "Company Type Invoice"},{"codeId": "1268","codeName": "Individual Type Invoice"}];

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
    { dataField:"taxInvcId" ,headerText:"Tax Invoice ID",width: 100 , editable : false ,visible : false},
    { dataField:"month" ,headerText:"Month",width: 100 , editable : false ,visible : false},
    { dataField:"year" ,headerText:"Year",width: 100 , editable : false ,visible : false},
    { dataField:"taxInvcType" ,headerText:"Tax Invoice Type",width: 100 , editable : false ,visible : false},
    { dataField:"taxInvcRefNo" ,headerText:"BR No.",width: 200 , editable : false },
    { dataField:"invcItmOrdNo" ,headerText:"Order No.",width: 200 , editable : false },
    { dataField:"taxInvcCustName" ,headerText:"Customer Name", editable : false },
    { dataField:"taxInvcRefDt" ,headerText:"Invoice Date",width: 200 ,editable : false , dataType : "date", formatString : "dd-mm-yyyy"},
    { dataField:"invcItmRentalFee" ,headerText:"Invoice Amount",width: 200 , dataType : "numeric", formatString : "#,##0.#"},
    { dataField:"invcItmInstlmtNo" ,headerText:"Inst No.",width: 200 , editable : false }
    ];

// 리스트 조회.
function fn_getTaxInvoiceListAjax() {

	if(FormUtil.checkReqValue($("#invoiceType option:selected")) ){
        Common.alert('* Please select the Invoice Type. <br/>');
        return;
    }

	if(FormUtil.checkReqValue($("#brNo")) && FormUtil.checkReqValue($("#orderNo"))){
        Common.alert('* Please Input BR No OR Order No.<br/>');
        return;
    }

    Common.ajax("POST", "/payment/selectTaxInvoiceRentalList.do", $("#searchForm").serializeJSON(), function(result) {
        AUIGrid.setGridData(myGridID, result);
    });
}

//크리스탈 레포트
function fn_generateInvoice(){
    var selectedItem = AUIGrid.getSelectedIndex(myGridID);

    if (selectedItem[0] > -1){
        //report form에 parameter 세팅
        var taxInvcId = AUIGrid.getCellValue(myGridID, selectedGridValue, "taxInvcId");
        var month = AUIGrid.getCellValue(myGridID, selectedGridValue, "month");
        var year = AUIGrid.getCellValue(myGridID, selectedGridValue, "year");
        var taxInvcType = AUIGrid.getCellValue(myGridID, selectedGridValue, "taxInvcType");

        if(parseInt(year) == 2015 && parseInt(month) < 4){
        	$("#reportPDFForm #reportFileName").val('/statement/TaxInvoice_Rental_NOGST_PDF.rpt');
        }else{
        	if( parseInt(year)*100 + parseInt(month) >= 201602){
                $("#reportPDFForm #reportFileName").val('/statement/TaxInvoice_Rental_PDF_JOMPAY_201602.rpt');
            }
            if( parseInt(year)*100 + parseInt(month) >= 201809){
                $("#reportPDFForm #reportFileName").val('/statement/TaxInvoice_Rental_PDF_JOMPAY_SST.rpt');
            }else{
                $("#reportPDFForm #reportFileName").val('/statement/TaxInvoice_Rental_PDF_JOMPAY.rpt');
            }
        }

        $("#reportPDFForm #V_REFERENCEID").val(taxInvcId);
        $("#reportPDFForm #V_TYPE").val(133);

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
        <li>Tax Invoice - Rental</li>
    </ul>

    <!-- title_line start -->
    <aside class="title_line">
        <p class="fav"><a href="#" class="click_add_on">My menu</a></p>
        <h2>Tax Invoice - Rental</h2>
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
                        <th scope="row">BR No.</th>
                        <td>
                            <input type="text" id="brNo" name="brNo" title="BR No." placeholder="BR No." class="w100p" />
                        </td>
                       <th scope="row">Invoice Period</th>
                        <td>
                           <input type="text" id="invoicePeriod" name="invoicePeriod"  title="Invoice Period" placeholder="Invoice Period" class="j_date2 w100p" placeholder="MM/YYYY"/>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Order No.</th>
                        <td>
                           <input type="text" id="orderNo" name="orderNo" title="Order No." placeholder="Order No." class="w100p" />
                        </td>
                        <th scope="row">Customer Name</th>
                        <td>
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
    <input type="hidden" id="V_TYPE" name="V_TYPE" />
    <input type="hidden" id="V_TASKID" name="V_TASKID" value="0"/>
    <input type="hidden" id="V_REFMONTH" name="V_REFMONTH" value="0" />
    <input type="hidden" id="V_REFYEAR" name="V_REFYEAR" value="0" />
    <input type="hidden" id="V_REFERENCEID" name="V_REFERENCEID" />
</form>
