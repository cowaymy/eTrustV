<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>

<script type="text/javaScript">
var myGridID;

//Grid에서 선택된 RowID
var selectedGridValue;

$(document).ready(function(){
    myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout,null,gridPros);
    //$('input:radio[name=printMethod]').is(':checked');
    $('input:radio[name=printMethod]').eq(0).attr("checked", true);  
    
    // Master Grid 셀 클릭시 이벤트
    AUIGrid.bind(myGridID, "cellClick", function( event ){ 
        selectedGridValue = event.rowIndex;
    });  
});

var gridPros = {
        editable: false,
        showStateColumn: false,
        pageRowCount : 25
};

var columnLayout=[
    {dataField:"taskId", headerText:"Task ID",visible : false},
    {dataField:"renDateTimeYear", headerText:"Year",visible : false},
    {dataField:"renDateTimeMonth", headerText:"Month",visible : false},
    {dataField:"salesOrdNo", headerText:"Order No"},
    {dataField:"name", headerText:"Customer Name"},
    {dataField:"rentDocNo", headerText:"Invoice No"}, 
    {dataField:"renDateTime", headerText:"Invoice Date"},
    {dataField:"rentAmt", headerText:"Invoice Amount"},
    {dataField:"rentInstNo", headerText:"Installment No"}
];

function fn_getCompanyInvoiceListtAjax() {        
	var valid = ValidRequiredField();
	if(!valid){
		 Common.alert("* Please key in either Bill No or Order No.<br />");
	}else{
		Common.ajax("GET", "/payment/selectInvoiceList.do", $("#searchForm").serialize(), function(result) {
	    	AUIGrid.setGridData(myGridID, result);
	    });
	}
}

function ValidRequiredField(){
	var valid = true;
	
	if($("#brNumber").val() == "" && $("#orderNo").val() == "")
		valid = false;
	
	return valid;
}



//크리스탈 레포트
function fn_generateInvoice(){
  var selectedItem = AUIGrid.getSelectedIndex(myGridID);

  if (selectedItem[0] > -1){
      //report form에 parameter 세팅
      $("#reportPDFForm #v_month").val(AUIGrid.getCellValue(myGridID, selectedGridValue, "renDateTimeMonth"));
      //$("#reportPDFForm #v_monthDetail").val(AUIGrid.getCellValue(myGridID, selectedGridValue, "renDateTimeMonth"));
      $("#reportPDFForm #v_year").val(AUIGrid.getCellValue(myGridID, selectedGridValue, "renDateTimeYear"));
      //$("#reportPDFForm #v_yearDetail").val(AUIGrid.getCellValue(myGridID, selectedGridValue, "renDateTimeYear"));
      $("#reportPDFForm #v_brNo").val(AUIGrid.getCellValue(myGridID, selectedGridValue, "rentDocNo"));
      $("#reportPDFForm #v_type").val(6);
      $("#reportPDFForm #v_printLive").val(0);
      $("#reportPDFForm #v_taskId").val(AUIGrid.getCellValue(myGridID, selectedGridValue, "taskId"));      
      
      
        
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

<!-- content start -->
<section id="content">
    <ul class="path">
        <li><img src="/resources/images/common/path_home.gif" alt="Home" /></li>
        <li>Billing</li>
        <li>Billing Group</li>
        <li>Company Invoice</li>
    </ul>
    
    <!-- title_line start -->
    <aside class="title_line">
        <p class="fav"><a href="javascript:;" class="click_add_on">My menu</a></p>
        <h2>Company Invoice</h2>   
        <ul class="right_btns">
            <li><p class="btn_blue"><a href="javascript:fn_getCompanyInvoiceListtAjax();"><span class="search"></span>Search</a></p></li>
        </ul>    
    </aside>
    <!-- title_line end -->


 <!-- search_table start -->
    <section class="search_table">
        <form name="searchForm" id="searchForm"  method="post">

            <table class="type1"><!-- table start -->
                <caption>table</caption>
                <colgroup>
                    <col style="width:144px" />
                    <col style="width:*" />
                    <col style="width:144px" />
                    <col style="width:*" />
                </colgroup>
                <tbody>
                    <tr>
                        <th scope="row">BR Number</th>
                        <td>
                            <input id="brNumber" name="brNumber" type="text" class="w100p" />
                        </td>
                        <th scope="row">Statement Period</th>
                        <td>
                           <input type="text" name="period" title="기준년월" class="j_date2 w100p" />
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Order Number</th>
                        <td>
                            <input id="orderNo" name="orderNo" type="text" class="w100p" />
                        </td>
                        <th scope="row">Customer Name</th>
                        <td>
                           <input id="customerName" name="customerName" type="text" class="w100p" />
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Customer NRIC</th>
                        <td>
                            <input id="customerNRIC" name="customerNRIC" type="text" class="w100p" />
                        </td>
                        <th scope="row">Print Method</th>
                        <td>
                           <label><input type="radio" name="printMethod" value="" /><span>With Hearder</span></label>
                           <label><input type="radio" name="printMethod" value="" /><span>No Hearder</span></label>
                        </td>
                    </tr>
                    </tbody>
              </table>
        </form>
        </section>

 <!-- search_result start -->
<section class="search_result">     

    <!-- link_btns_wrap start -->
        <aside class="link_btns_wrap">
            <p class="show_btn"><a href="#"><img src="/resources/images/common/btn_link.gif" alt="link show" /></a></p>
            <dl class="link_list">
                <dt>Link</dt>
                <dd>
                    <ul class="btns">
                        <li><p class="link_btn"><a href="javascript:fn_generateInvoice();">Generate Invoice</a></p></li>
                    </ul>
                    <ul class="btns">
                        <li><p class="link_btn type2"><a href="#">Send E-Invoice</a></p></li>
                    </ul>
                    <p class="hide_btn"><a href="#"><img src="/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
                </dd>
            </dl>
        </aside>
        <!-- link_btns_wrap end -->
        
    <!-- grid_wrap start -->
    <article id="grid_wrap" class="grid_wrap"></article>
    <!-- grid_wrap end -->
</section>
</section>
<form name="reportPDFForm" id="reportPDFForm"  method="post">
    <input type="hidden" id="reportFileName" name="reportFileName" value="/statement/Official_Invoice_PDF.rpt" />
    <input type="hidden" id="viewType" name="viewType" value="PDF" />
    
    v_month: <input type="text" id="v_month" name="v_month" />
    
    <br>v_year: <input type="text" id="v_year" name="v_year" />
    
    <br>v_brNo : <input type="text" id="v_brNo" name="v_brNo" />
    <br>v_type : <input type="text" id="v_type" name="v_type" />
    <br>v_printLive : <input type="text" id="v_printLive" name="v_printLive" />
    <br>v_taskId : <input type="text" id="v_taskId" name="v_taskId" />
    
    
    
    
</form>
