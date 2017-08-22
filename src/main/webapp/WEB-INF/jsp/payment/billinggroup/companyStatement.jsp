<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>

<script type="text/javaScript">
var myGridID;

//Grid에서 선택된 RowID
var selectedGridValue;

$(document).ready(function(){
    myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout,null,gridPros);
    $('input:radio[name=printMethod]').is(':checked');
    
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
    {dataField:"billId" ,headerText:"Bill ID",visible : false},
    {dataField:"custBillGrpNo", headerText:"Group No",width: 200 , editable : false },
    {dataField:"year", headerText:"Year",width: 100 , editable : false },
    {dataField:"month", headerText:"Month",width: 100 , editable : false },
    {dataField:"soNo", headerText:"Order No",width: 250 , editable : false },
    {dataField:"custName", headerText:"Customer Name"}
];

function fn_getCompanyStatementListAjax() {        
	var valid = ValidRequiredField();
	if(!valid){
		 Common.alert("* Please key in either Bill No or Order No.<br />");
	}else{
		Common.ajax("GET", "/payment/selectCompStatementList", $("#searchForm").serialize(), function(result) {
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
function fn_generateStatement(){
  var selectedItem = AUIGrid.getSelectedIndex(myGridID);

  if (selectedItem[0] > -1){
      //report form에 parameter 세팅      
      $("#reportPDFForm #v_billId").val(AUIGrid.getCellValue(myGridID, selectedGridValue, "billId"));
      $("#reportPDFForm #v_year").val(AUIGrid.getCellValue(myGridID, selectedGridValue, "year"));
      $("#reportPDFForm #v_month").val(AUIGrid.getCellValue(myGridID, selectedGridValue, "month"));
    	    
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
        <li>Company Statement</li>
    </ul>
    
    <!-- title_line start -->
    <aside class="title_line">
        <p class="fav"><a href="javascript:;" class="click_add_on">My menu</a></p>
        <h2>Company Statement</h2>   
        <ul class="right_btns">
            <li><p class="btn_blue"><a href="javascript:fn_getCompanyStatementListAjax();"><span class="search"></span>Search</a></p></li>
        </ul>    
    </aside>
    <!-- title_line end -->


 <!-- search_table start -->
    <section class="search_table">
        <form name="searchForm" id="searchForm"  method="post">

            <table class="type1"><!-- table start -->
                <caption>table</caption>
                <colgroup>
                    <col style="width:160px" />
                    <col style="width:*" />
                    <col style="width:160px" />
                    <col style="width:*" />
                </colgroup>
                <tbody>
                    <tr>
                        <th scope="row">Billing Number</th>
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
                        <li><p class="link_btn"><a href="javascript:fn_generateStatement();">Statement Generate</a></p></li>
                    </ul>
                    <!-- <ul class="btns">
                        <li><p class="link_btn type2"><a href="#" onclick="javascript:showViewPopup()">Send E-Invoice</a></p></li>
                    </ul>-->
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
    <input type="hidden" id="reportFileName" name="reportFileName" value="/statement/Official_StatementOfAccount(COMPANY)_PDF.rpt" />
    <input type="hidden" id="viewType" name="viewType" value="PDF" />
    <input type="hidden" id="v_month" name="v_month" />
    <input type="hidden" id="v_year" name="v_year" />
    <input type="hidden" id="v_billId" name="v_billId" />
</form>

