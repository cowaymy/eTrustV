<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>

<script type="text/javaScript">
var  _invoiceResultGridID;

//Grid에서 선택된 RowID
var selectedGridValue;

//페이징에 사용될 변수
var _totalRowCount;

var invoiceResultGridPros = {
		showRowNumColumn : false,
        editable: false,
        showStateColumn: false,
        usePaging : false
};

var invColumnLayout=[
    {dataField:"salesOrdNo", headerText:"Order No", width : 90},
    {dataField:"accBillGrpId", headerText:"Bill Group", width : 90},
    {dataField:"codeName", headerText:"Bill Type", width : 165},
    {dataField:"accBillRefNo", headerText:"Bill No", width : 140},
    {dataField:"name", headerText:"Customer Name", width : 250},
    {dataField:"accBillSchdulPriod", headerText:"Installment", width : 100},
    {dataField:"accBillSchdulAmt", headerText:"Amount" , width : 100},
    {dataField:"accBillAdjAmt", headerText:"Descount Amount", width : 150},
    {dataField:"accBillTxsAmt", headerText:"Taxes Amount", width : 100},
    {dataField:"accBillNetAmt", headerText:"Net Amount", width : 100},
    {dataField:"accBillRefDt", headerText:"Issued", width : 180, dataType : "date", formatString : "yyyy-mm-dd hh:MM:ss"}
];

function fn_initData(){
	fn_getInvoiceList(1);
}

$(document).ready(function(){
    $("#taskId").val("${taskId}");    
    _invoiceResultGridID = GridCommon.createAUIGrid("invoiceResult_grid_wrap", invColumnLayout,null,invoiceResultGridPros);
    
   fn_initData();
   
});

function fn_getInvoiceList(goPage){ 
    //페이징 변수 세팅
   // $("#pageNo").val(goPage);   
    
    Common.ajax("GET", "/payment/selectInvoiceResultList.do", $("#_billingResultPopForm").serialize(), function(result) {
        //AUIGrid.setGridData(myGridID, result);
        console.log(result);
        $("#t_taskId").text(result.master.taskId);
        $("#t_billingMNY").text(result.master.billingMonth + "/" + result.master.billingYear);
        $("#t_count").text(result.master.sum);
        
        //금액 천단위 콤마 + 소수 둘쨰자리 계산
        var tmpAmt = ""+result.master.accBillNetAmt.toFixed(2);
        var temp = tmpAmt.split(".");
        var amt = commaSeparateNumber(temp[0]);
        $("#t_amount").text("RM"+amt+"."+temp[1]);
        AUIGrid.setGridData( _invoiceResultGridID, result.detail);
        
    });
}

function commaSeparateNumber(val){
    while (/(\d+)(\d{3})/.test(val.toString())){
      val = val.toString().replace(/(\d+)(\d{3})/, '$1'+','+'$2');
    }
    return val;
}

//크리스탈 레포트
function fn_billList(){    
    //report 호출
    var option = {
    	    isProcedure : true, // procedure 로 구성된 리포트 인경우 필수.
    };

    Common.report("reportPDFForm", option);    
} 

</script>
<!-- popup_wrap start -->
<div id="popup_wrap" class="popup_wrap">
<!-- pop_header start -->
    <header class="pop_header">
        <h1>Billing Result</h1>
        <ul class="right_opt">
                <li><p class="btn_blue2"><a href="#" id="_close1">CLOSE</a></p></li>
            </ul>
    </header>
     <!-- pop_header end -->
<!-- getParams  -->    
<section class="pop_body">

        <form name="searchForm" id="_billingResultPopForm"  method="post">
            <input type="hidden" name="taskId" id="taskId" value="${taskId }" />            
            <input type="hidden" name="rowCount" id="rowCount" value="10" />
            <input type="hidden" name="pageNo" id="pageNo" />
            
            <ul class="right_btns mb10">
                <li><p class="btn_blue"><a href="javascript:fn_billList();">Final Billing Raw Data</a></p></li>
                <li><p class="btn_blue"><a href="javascript:fn_getInvoiceList(1);"><span class="search"></span>Search</a></p></li>
            </ul>
            
            <table class="type1"><!-- table start -->
                <caption>table</caption>
                <colgroup>
                    <col style="width:140px" />
                    <col style="width:*" />
                    <col style="width:130px" />
                    <col style="width:*" />
                    <col style="width:160px" />
                    <col style="width:*" />
                    <col style="width:140px" />
                    <col style="width:*" />
                </colgroup>
                <tbody>
                    <tr>
                        <th scope="row">Order No</th>
                        <td><input type="text" id="orderNo" name="orderNo" class="w100p"/></td>
                        <th scope="row">Bill No.</th>
                        <td><input type="text" id="billNo" name="billNo" class="w100p"/></td>
                        <th scope="row">Customer Name</th>
                        <td><input type="text" id="custName" name="custName" class="w100p"/></td>
                        <th scope="row">Bill Group</th>
                        <td><input type="text" id="group" name="group"  class="w100p"/></td>
                    </tr>
                    <tr>
                        <th scope="row">Bill Type</th>
                        <td>
                            <select id="billType" name="billType" class="w100p">
                                <option value='' disabled selected hidden></option>
                                <option value="1060">Rental Bill</option>
                                <option value="1061">Handling Fee Bill</option>
                                <option value="1143">Service Membership Bill</option>
                                <option value="1147">Service Membership BS Bill</option>
                            </select>
                        </td>
                        <th scope="row"></th>
                        <td></td>
                        <th scope="row"></th>
                        <td></td>
                        <th scope="row"></th>
                        <td></td>
                    </tr>
                </tbody>
            </table><!-- table end -->
        </form>
    <table class="type1 mt30"><!-- table start -->
        <caption>table</caption>
        <colgroup>
            <col style="width:140px" />
            <col style="width:*" />
            <col style="width:130px" />
            <col style="width:*" />
            <col style="width:160px" />
            <col style="width:*" />
            <col style="width:140px" />
            <col style="width:*" />
        </colgroup>
        <tbody>
            <tr>
                <th scope="row">Task ID</th>
                <td id="t_taskId"></td>
                <th scope="row">Billing Month/Year</th>
                <td id="t_billingMNY"></td>
                <th scope="row">Bill Count</th>
                <td id="t_count"></td>
                <th scope="row">Total Amount</th>
                <td id="t_amount"></td>
            </tr>
        </tbody>
    </table><!-- table end -->
    
    <!-- grid_wrap start -->
    <article id="invoiceResult_grid_wrap" class="grid_wrap"></article>
    <div id="grid_paging" class="aui-grid-paging-panel my-grid-paging-panel"></div>
    <!-- grid_wrap end -->
</section><!-- content end -->
</div>
<form name="reportPDFForm" id="reportPDFForm"  method="post">
    <input type="hidden" id="reportFileName" name="reportFileName" value="/bill/FinalBilling.rpt" />
    <input type="hidden" id="viewType" name="viewType" value="EXCEL" />    
    <input type="hidden" id="v_taskId" name="v_taskId" value="${taskId }" />
</form>
