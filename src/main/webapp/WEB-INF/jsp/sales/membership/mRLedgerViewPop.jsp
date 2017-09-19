

<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript" language="javascript">

function fn_doback(){
    
	   $("#_LedgerDiv1").remove();
}



var mRLedgerGrid; 


$(document).ready(function(){  
    
	fn_getmRLedgerGridAjax ();
	
	//createMRLedgerGrid();  
   // AUIGrid.resize(mRLedgerGrid, 940,300);
   
});


function createMRLedgerGrid(){
    
    var cLayout = [
         {dataField : "code",headerText : "Status", width : 100 ,editable : false},
         {dataField : "cnfmLogMsg", headerText : "Call Message", width : 300 ,editable : false},
         {dataField : "cnfmLogSmsMsg", headerText : "SMS Message", width :300 ,editable : false},
         {dataField : "userName", headerText : "Key By", width :100 ,editable : false},
         {dataField : "cnfmLogCrtDt", headerText : "Key At", width :120 ,dataType : "date", formatString : "dd-mm-yyyy" ,editable : false}
   ];
    
    var gridPros = { usePaging : true,  pageRowCount: 20, editable: false, fixedColumnCount :1,selectionMode : "singleRow",  showRowNumColumn : true};  
    mRLedgerGrid = GridCommon.createAUIGrid("#ledger_grid_wrap", cLayout,'' ,gridPros); 
}




function fn_getmRLedgerGridAjax (){
      Common.ajax("GET", "/sales/membershipRental/getMRLedgerInfo",{SRV_CNTRCT_ID: '${srvCntrctId}' ,ORD_ID: '${srvCntrctOrdId}'}, function(result) {
         console.log(result);
         //AUIGrid.setGridData(mRLedgerGrid, result);
         
         
         $("#txtCust").html(result.baseInfo.custName);
         $("#txtOrderNo").html(result.baseInfo.ordNo);         
         $("#txtContractRefNo").html(result.salesInfo.srvCntrctRefNo );
         $("#txtProduct").html("("+result.baseInfo.stockCode+") "+result.baseInfo.stockDesc);
         
        
         $("#txtAddrInst").html();
         $("#txtInstallDate").html();
         
         
         /*  알 수 없는 로직 
	         string startDate = "";
	         if (det.StartDate > defaultDate)
	             det.StartDate.ToString("dd/MM/yyyy");
	         string endDate ="";
	         if(det.ExpireDate > defaultDate)
	             det.ExpireDate.ToString("dd/MM/yyyy");
	         
	         this.txtContractPeriod.Text = "Period : " + startDate + " - " + endDate;
         */
         $("#txtContractPeriod").html("-");
         
         var  mailAddress;
         
	       mailAddress += " " + result.orderMailingInfo.mailAddress1 ;
	       mailAddress += " " + result.orderMailingInfo.mailAddress2 ;
	       mailAddress += " " + result.orderMailingInfo.mailAddress3 ;
	       mailAddress += " " + result.orderMailingInfo.mailPostCode;
	       mailAddress += " " + result.orderMailingInfo.mailArea;
	       mailAddress += " " + result.orderMailingInfo.mailCnty;
		       
		 $("#txtAddrMail").html(mailAddress);  
        
         $("#txtTelM").html(result.orderMailingInfo.mailCntTelM);
         $("#txtTelR").html(result.orderMailingInfo.mailCntTelR);
         $("#txtTelO").html(result.orderMailingInfo.mailCntTelO);
         $("#txtTelF").html(result.orderMailingInfo.mailCntTelF);
         $("#txtCustVano").html(result.baseInfo.custVaNo);
         
		    
      });
}



</script>


<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>RENTAL MEMBERSHIP LEDGER</h1>
<ul class="right_opt">
	<li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:220px" />
	<col style="width:*" />
	<col style="width:140px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row">Customer Name</th>
	<td><span id='txtCust'></span></td>
	<th scope="row">Order Number</th>
	<td ><span id='txtOrderNo'></span></td>
</tr>
<tr>
	<th scope="row">Rental Membership No.</th>
	<td><span id='txtContractRefNo'></span></td>
	<th scope="row">Period</th>
	<td ><span id='txtContractPeriod'></span></td>
</tr>
<tr>
	<th scope="row">Product</th>
	<td><span id='txtProduct' ></span></td>
	<th scope="row">Install Date</th>
	<td ><span id='txtInstallDate'></span></td>
</tr>
<tr>
	<th scope="row">Install Address</th>
	<td><span id='txtAddrMail' ></span></td>
	<th scope="row">Install Address</th>
	<td ><span id='txtAddrInst'></span></td>
</tr>
<tr>
	<th scope="row">Mobile</th>
	<td><span id='txtTelM' ></span></td>
	<th scope="row">Residence</th>
	<td><span id='txtTelR'  ></span></td>
    
</tr>
<tr>
	<th scope="row">Office</th>
	<td><span id='txtTelO'></span></td>
	<th scope="row">Fax</th>
	<td ><span id='txtTelF'></span></td>
</tr>
<tr>
	<th scope="row">CIMB Dedicated Bank Acc</th>
	<td><span id='txtCustVano'  > </span></td>
	<th scope="row"></th>
	<td ><span></span></td>
</tr>
</tbody>
</table><!-- table end -->

<ul class="left_btns ">
     <li><input type="text" title="Create start Date" placeholder="MM/YYYY" class="j_date2 w100p mtz-monthpicker-widgetcontainer"   id="salesDate" name="salesDate" /></li>
    <li><p class="btn_grid"><a href="#" onclick="javascript:fn_goLedgerPopOut()"><span class="search"></span>DO Print</a></p></li>
</ul> 

<article class="grid_wrap"><!-- grid_wrap start -->
   <div id="ledger_grid_wrap" style="width:100%; height:300px; margin:0 auto;"></div>  
</article><!-- grid_wrap end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:160px" />
	<col style="width:*" />
	<col style="width:170px" />
	<col style="width:*" />
	<col style="width:170px" />
	<col style="width:*" />
	<col style="width:150px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row">Total Outstanding</th>
	<td><span>text</span></td>
	<th scope="row">Outstanding Month</th>
	<td><span>text</span></td>
	<th scope="row">Unbill Amount</th>
	<td><span>text</span></td>
	<th scope="row"></th>
	<td><span>text</span></td>
</tr>
<tr>
	<th scope="row">Penalty Charges</th>
	<td><span>text</span></td>
	<th scope="row">Penalty Paid</th>
	<td><span>text</span></td>
	<th scope="row">Penalty Adjustment</th>
	<td><span>text</span></td>
	<th scope="row">Balance Penatly</th>
	<td><span>text</span></td>
</tr>
</tbody>
</table><!-- table end -->

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->