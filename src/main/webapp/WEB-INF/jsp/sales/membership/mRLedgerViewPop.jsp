

<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript" language="javascript">

var mRLedgerGrid;


$(document).ready(function(){

	fn_getmRLedgerGridAjax ();

	createMRLedgerGrid();
    //AUIGrid.resize(mRLedgerGrid, 960,330);
    fn_getmRLedgerProcessGridAjax();


});



function fn_goLedgerPrint(){

    $("#reportDownFileName").val($("#OrderID").val());
    var option = {
        isProcedure : true // procedure 로 구성된 리포트 인경우 필수.  => /payment/PaymentListing_Excel.rpt 는 프로시져로 구성된 파일임.
    };

    Common.report("dataForm", option);
	//alert('goPrint');
}


function vChange(obj){
	   fn_getmRLedgerProcessGridAjax ();
 }


function createMRLedgerGrid(){

    var cLayout = [
         {dataField : "refDt",headerText : "<spring:message code="sal.title.date" />", width : 80 ,dataType : "date", editable : false},
         {dataField : "instno", headerText : "<spring:message code="sal.title.instBrNo" />", width : 38 ,editable : false},
         {dataField : "doctypename", headerText : "<spring:message code="sal.title.type" />", width :130 ,editable : false},
         {dataField : "srvLdgrRefNo", headerText : "<spring:message code="sal.title.docNo" />", width :110 ,editable : false},
         {dataField : "resnDesc", headerText : "<spring:message code="sal.title.adjReason" />", width :100 ,editable : false},
         {dataField : "payMode", headerText : "<spring:message code="sal.title.payBrMode" />", width :48 ,editable : false},
         {dataField : "payDt", headerText : "<spring:message code="sal.title.RefDate" />", width :80 ,dataType : "date", editable : false},
         {dataField : "chqrefno", headerText : "<spring:message code="sal.title.refNo" />", width :100 ,editable : false},
         {dataField : "accCode", headerText : "<spring:message code="sal.title.accCode" />", width :80 ,editable : false},
         {dataField : "debitamt", headerText : "<spring:message code="sal.title.debit" />", width :60 ,dataType : "number", formatString : "#,000.00"  ,editable : false},
         {dataField : "creditamt", headerText : "<spring:message code="sal.title.credit" />", width :60 ,dataType : "number", formatString : "#,000.00"  ,editable : false},
         {dataField : "balanceamt", headerText : "<spring:message code="sal.title.balance" />", width :60 ,dataType : "number", formatString : "#,000.00"  ,editable : false}

   ];

    var gridPros = {
    		usePaging : false,
    		pageRowCount: 10,
    		editable: false,
    		//selectionMode : "singleRow",
    		headerHeight : 30,
    		showRowNumColumn : false,
            showStateColumn     : false,
    		};
    mRLedgerGrid = GridCommon.createAUIGrid("#ledger_grid_wrap", cLayout,'' ,gridPros);
}




function fn_getmRLedgerGridAjax (){
      Common.ajax("GET", "/sales/membershipRental/getMRLedgerInfo",{SRV_CNTRCT_ID: '${srvCntrctId}' ,ORD_ID: '${srvCntrctOrdId}'}, function(result) {
         console.log(result);
         //AUIGrid.setGridData(mRLedgerGrid, result);


         $("#txtCust").html(result.baseInfo.custName);
         $("#txtOrderNo").html(result.baseInfo.ordNo);

         $("#ContractID").val('${srvCntrctId}');
         $("#OrderID").val('${srvCntrctOrdId}');
         //$("#V_CUTOFFDATE").val($("#vsalesDate").val());

         $("#txtContractRefNo").html(result.salesInfo.srvCntrctRefNo );
         $("#txtProduct").html("("+result.baseInfo.stockCode+") "+result.baseInfo.stockDesc);


         $("#txtAddrInst").html(result.addressInfo.fullAddr);
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

	       mailAddress += " " + result.orderMailingInfo.addrDtl ;
	       mailAddress += " " + result.orderMailingInfo.street ;
	       mailAddress += " " + result.orderMailingInfo.mailArea ;
	       mailAddress += " " + result.orderMailingInfo.mailCity ;
	       mailAddress += " " + result.orderMailingInfo.mailPostCode;
	       mailAddress += " " + result.orderMailingInfo.mailCnty;

		 $("#txtAddrMail").html(mailAddress);

         $("#txtTelM").html(result.orderMailingInfo.mailCntTelM);
         $("#txtTelR").html(result.orderMailingInfo.mailCntTelR);
         $("#txtTelO").html(result.orderMailingInfo.mailCntTelO);
         $("#txtTelF").html(result.orderMailingInfo.mailCntTelF);
         $("#txtCustVano").html(result.baseInfo.custVaNo);


      });
}



function fn_getmRLedgerProcessGridAjax (v){

    Common.ajax("GET", "/sales/membershipRental/getMRLedgerProcessInfo",{ContractID: '${srvCntrctId}' ,salesDate: $("#vsalesDate").val()}, function(result) {

    	console.log(result);
        AUIGrid.setGridData(mRLedgerGrid, result.legderList);

       $("#totOtstnd").html(result.outstandingData[0].totOtstnd );
       $("#otstndMonth").html(result.outstandingData[0].otstndMonth);
       $("#unbillAmt").html(result.outstandingData[0].unbillAmt);
       $("#totPnaltyChrg").html(result.outstandingData[0].totPnaltyChrg);
       $("#totPnaltyPaid").html(result.outstandingData[0].totPnaltyPaid);
       $("#totPnaltyAdj").html(result.outstandingData[0].totPnaltyAdj);
       $("#totPnaltyBal").html(result.outstandingData[0].totPnaltyBal);

    });
}



</script>


<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

 <fmt:setLocale value="en_US"/>

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="sal.page.title.rentalMembershipLedger" /></h1>
<ul class="right_opt">
	<li><p class="btn_blue2"><a href="#"><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<form id="dataForm" name="dataForm">
<input type="hidden" id="reportFileName" name="reportFileName" value="/membership/ServiceContractLedger_2.rpt"/>
    <input type="hidden" id="viewType" name="viewType" value="PDF"/>
    <input type="hidden" id="reportDownFileName" name="reportDownFileName"/>
    <!--param  -->
    <input type="hidden" id="ContractID" name="ContractID"/>
    <input type="hidden" id="OrderID" name="OrderID"/>
    <input type="hidden" id="V_CUTOFFDATE" name="V_CUTOFFDATE" value='1900-01-01'/>
</form>
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:150px" />
	<col style="width:*" />
	<col style="width:150px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row"><spring:message code="sal.text.custName" /></th>
	<td><span id='txtCust'></span></td>
	<th scope="row"><spring:message code="sal.text.ordNum" /></th>
	<td ><span id='txtOrderNo'></span></td>
</tr>
<tr>
	<th scope="row"><spring:message code="sal.text.rentalMembershipNo" /></th>
	<td><span id='txtContractRefNo'></span></td>
	<th scope="row"><spring:message code="sal.text.preiod" /></th>
	<td ><span id='txtContractPeriod'></span></td>
</tr>
<tr>
	<th scope="row"><spring:message code="sal.text.product" /></th>
	<td><span id='txtProduct' ></span></td>
	<th scope="row"><spring:message code="sal.text.insDate" /></th>
	<td ><span id='txtInstallDate'></span></td>
</tr>
<tr>
	<th scope="row"><spring:message code="sal.text.insAddr" /></th>
	<td><span id='txtAddrMail' ></span></td>
	<th scope="row"><spring:message code="sal.text.insAddr" /></th>
	<td ><span id='txtAddrInst'></span></td>
</tr>
<tr>
	<th scope="row"><spring:message code="sal.text.mobile" /></th>
	<td><span id='txtTelM' ></span></td>
	<th scope="row"><spring:message code="sal.text.residence" /></th>
	<td><span id='txtTelR'  ></span></td>

</tr>
<tr>
	<th scope="row"><spring:message code="sal.text.office" /></th>
	<td><span id='txtTelO'></span></td>
	<th scope="row"><spring:message code="sal.text.fax" /></th>
	<td ><span id='txtTelF'></span></td>
</tr>
<tr>
	<th scope="row"><spring:message code="sal.text.cimbDedicated" /> <br/><spring:message code="sal.text.bankAcc" /></th>
	<td><span id='txtCustVano'  > </span></td>
	<th scope="row"></th>
	<td ><span></span></td>
</tr>
</tbody>
</table><!-- table end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:150px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sal.text.totalOutstanding" /></th>
    <td><span  id='totOtstnd'></span></td>
    <th scope="row"><spring:message code="sal.text.outstandingMonth" /></th>
    <td><span id='otstndMonth'></span></td>
    <th scope="row"><spring:message code="sal.text.unbillAmount" /></th>
    <td><span id='unbillAmt'></span></td>
    <th scope="row"></th>
    <td><span></span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.penaltyCharges" /></th>
    <td><span id='totPnaltyChrg'></span></td>
    <th scope="row"><spring:message code="sal.text.penaltyPaid" /></th>
    <td><span id='totPnaltyPaid'></span></td>
    <th scope="row"><spring:message code="sal.text.penaltyAdjustment" /></th>
    <td><span id='totPnaltyAdj'></span></td>
    <th scope="row"><spring:message code="sal.text.balancePenalty" /></th>
    <td><span id='totPnaltyBal'></span></td>
</tr>
</tbody>
</table><!-- table end -->

<ul class="left_btns ">

     <li><spring:message code="sal.text.transactionDate" /></li>
     <li><input type="text" title="Create start Date" placeholder="MM/YYYY"  onchange="vChange(this)" class="j_date2 w100p mtz-monthpicker-widgetcontainer"  id="vsalesDate" name="vsalesDate" /></li>
    <li><p class="btn_grid"><a href="#" onclick="javascript:fn_goLedgerPrint();"><spring:message code="sal.btn.doPrint" /></a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
   <div id="ledger_grid_wrap" style="width:100%; height:330px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->