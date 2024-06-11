<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>


<script type="text/javaScript" language="javascript">

    //AUIGrid 생성 후 반환 ID
    var  ordLedgerGridID;
    var  agreGridID;
    var orderLdgrList;
    var agreList;

    $(document).ready(function(){

       if('${orderLdgrList}'=='' || '${orderLdgrList}' == null){
       }else{
    	   orderLdgrList = JSON.parse('${orderLdgrList}');
       }

       if('${agreList}'=='' || '${agreList}' == null){
       }else{
    	   agreList = JSON.parse('${agreList}');
       }

        //AUIGrid 그리드를 생성합니다.
        createAUIGrid();
        createAUIGrid_agre();

    });

    function createAUIGrid(){
        //AUIGrid 칼럼 설정
        var ordLedgerLayout = [
          {   dataField : "docdate",  headerText : 'Date',         width : 85 }
         ,{   dataField : "doctype",  headerText : 'Type',         width : 105 }
         ,{   dataField : "docNo",    headerText : 'Doc No',        width : 95 }
         ,{   dataField : "adjreason", headerText : 'Adj Reason',   width : 100 }
         ,{   dataField : "payMode",  headerText : 'Pay</br>mode',     width : 50  }
         ,{   dataField : "refDt",       headerText : 'Ref Date',      width : 85 }
         ,{  dataField : "refNo",        headerText : 'Ref No',        width : 100}
         ,{  dataField : "accCode",    headerText : 'Acc Code',    width : 75 }
         ,{  dataField : "debitamt",   headerText : 'Debit',      width : 75, dataType : "numeric", formatString : "#,##0.00" }
         ,{  dataField : "creditamt",  headerText : 'Credit',   width : 75, dataType : "numeric", formatString : "#,##0.00"}
         ,{  dataField : "balanceamt", headerText : 'Balance', width : 75, dataType : "numeric", formatString : "#,##0.00"}
        ];

     //그리드 속성 설정
     var ordLedgerGridPros = {
         usePaging           : false,             //페이징 사용
         pageRowCount        : 10,           //한 화면에 출력되는 행 개수 20(기본값:20)
         editable                : false,
         showStateColumn     : false,
         showRowNumColumn    : false,
         headerHeight : 30
       //selectionMode       : "singleRow"  //"multipleCells",
     };

     ordLedgerGridID = GridCommon.createAUIGrid("ord_ledger_grid", ordLedgerLayout, "", ordLedgerGridPros);

     if(orderLdgrList != '' ){
         AUIGrid.setGridData(ordLedgerGridID, orderLdgrList);
     }
 }

    function createAUIGrid_agre(){
        //AUIGrid 칼럼 설정
        var agreLayout = [
          {   dataField : "govAgBatchNo",  headerText : 'Agreement No.',         width : 150 }
         ,{   dataField : "name",     headerText : 'Agreement Status',     width : 150 }
         ,{   dataField : "govAgPrgrsName",  headerText : 'Agreement Progress',         width : 150 }
         ,{   dataField : "code",    headerText : 'Agreement Type',        width : 150 }
         ,{   dataField : "govAgStartDt", headerText : 'Start Date',   width : 150 }
         ,{   dataField : "govAgEndDt",  headerText : 'Expired Date',     width : 150  }
        ];

     //그리드 속성 설정
     var agreGridPros = {
         usePaging           : true,             //페이징 사용
         pageRowCount        : 20,           //한 화면에 출력되는 행 개수 20(기본값:20)
         editable                : false,
         showStateColumn     : false,
         showRowNumColumn    : false,
//         selectionMode       : "singleRow"  //"multipleCells",
     };

     agreGridID = GridCommon.createAUIGrid("agre_grid", agreLayout, "", agreGridPros);

     if(agreList != '' ){
         AUIGrid.setGridData(agreGridID, agreList);
     } else{

         $("#agreDiv").hide();
     }
 }

    function fn_report1(){
    	//CURRENT DATE
        var date = new Date().getDate();
        var mon = new Date().getMonth()+1;

        if(date.toString().length == 1){
            date = "0" + date;
        }

        if(mon.toString().length == 1){
            mon = "0" + mon;
        }

    	var inputDate = dataForm.cutOffDate.value;

    	if($("#cutOffDate").val() == ""){
    		$("#V_CUTOFFDATE").val('01/01/1900');
    	}else{
    		$("#V_CUTOFFDATE").val('01/'+inputDate.substring(0,2)+'/'+inputDate.substring(3,7));
    	}

    	$("#reportDownFileName").val($("#V_ORDERNO").val()+"_"+date+mon+new Date().getFullYear());

    	var option = {
  	        isProcedure : true // procedure 로 구성된 리포트 인경우 필수.  => /payment/PaymentListing_Excel.rpt 는 프로시져로 구성된 파일임.
  	    };

    	Common.report("dataForm", option);
    }
</script>
<div id="popup_wrap" class="popup_wrap pop_win"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Order Ledger</h1>
<ul class="right_opt">
	<li><p class="btn_blue2"><a href="#" onclick="window.close()">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<aside class="title_line"><!-- title_line start -->
<h2>${orderInfo.custName}</h2>
</aside><!-- title_line end -->

<form id="dataForm" name="dataForm">
    <input type="hidden" id="reportFileName" name="reportFileName" value="/sales/OrderLedger.rpt"/>
    <input type="hidden" id="viewType" name="viewType" value="PDF"/>
    <input type="hidden" id="reportDownFileName" name="reportDownFileName"/>
    <!--param  -->
    <input type="hidden" id="V_ORDERID" name="V_ORDERID" value="${orderInfo.ordId}" />
    <input type="hidden" id="V_ORDERNO" name="V_ORDERNO" value="${orderInfo.ordNo}" />
    <input type="hidden" id="V_PAYREFNO" name="V_PAYREFNO" value="${orderInfo.jomPayRef}" />
    <input type="hidden" id="V_CUSTTYPE" name="V_CUSTTYPE"  value="${orderInfo.custType}" />
    <input type="hidden" id="V_CUTOFFDATE" name="V_CUTOFFDATE"  />

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:130px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:110px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row">Reference No.</th>
	<td colspan="5"><span>${orderInfo.supRefNo}</span></td>
</tr>
<tr>
	<th scope="row">Delivery Date</th>
	<td colspan="5"><span>${orderInfo.supRefDelDt}</span></td>
</tr>
</tbody>
</table><!-- table end -->

</br>

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:110px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Address Line 1</th>
    <td colspan="5"><span>${orderInfo.addressLine1}</span></td>
</tr>
<tr>
    <th scope="row">Address Line 2</th>
    <td colspan="5"><span>${orderInfo.addressLine2}</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="service.title.Area" /></th>
    <td><span>${orderInfo.area}</span></td>
    <th scope="row"><spring:message code="sal.text.city" /></th>
    <td><span>${orderInfo.city}</span></td>
    <th scope="row"><spring:message code="sys.title.postcode" /></th>
    <td><span>${orderInfo.postcode}</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="service.title.State" /></th>
    <td><span>${orderInfo.state}</span></td>
    <th scope="row"><spring:message code="sys.country"/></th>
    <td><span>${orderInfo.country}</span></td>
    <th ></th>
    <td></td>
</tr>
</tbody>
</table>

</br>

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:110px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sales.MobileNo" /></th>
    <td><span>${orderInfo.custMobileNo}</span></td>
    <th scope="row"><spring:message code="supplement.title.text.ResidentNo" /></th>
    <td><span>${orderInfo.custResidentNo}</span></td>
    <th scope="row"><spring:message code="sales.OfficeNo" /></th>
    <td><span>${orderInfo.custOfficeNo}</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="service.title.FaxNo" /></th>
    <td><span>${orderInfo.custFaxNo}</span></td>
    <th scope="row"><spring:message code="sal.text.email" /></th>
    <td colspan="3"><span>${orderInfo.custEmail}</span></td>
</tr>
</tbody>
</table>

</br>

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:110px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Total Outstanding</th>
    <td><span>${ordOutInfo.ordTotOtstnd}</span></td>
    <th scope="row">Outstanding Month</th>
    <td><span>${ordOutInfo.ordOtstndMth}</span></td>
    <th scope="row">Unbill Amount</th>
    <td><span>${ordOutInfo.ordUnbillAmt}</span></td>
</tr>
<tr>
    <th scope="row">Penalty Charge</th>
    <td><span>${ordOutInfo.ordTotOtstnd}</span></td>
    <th scope="row">Penalty Paid</th>
    <td><span>${ordOutInfo.ordOtstndMth}</span></td>
    <th scope="row">Penalty Adjustment</th>
    <td><span>${ordOutInfo.ordUnbillAmt}</span></td>
</tr>
<tr>
    <th scope="row">Balance Penalty</th>
    <td><span>${ordOutInfo.totPnaltyChrg}</span></td>
    <th></th>
    <td></td>
    <th ></th>
    <td></td>
</tr>
</tbody>
</table>

<ul class="right_btns mt20">
	<li><p>Transaction Date</p></li>
	<li><input type="text" id="cutOffDate" name="cutOffDate" class="j_date2" /></li>
	<li><p class="btn_blue"><a href="#" onclick="fn_report1()">Print</a></p></li>
</ul>
</form>

<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="ord_ledger_grid" style="width:100%; height:230px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->



<article class="grid_wrap mt20"><!-- grid_wrap start -->
<div id ="agreDiv" >
<aside class="title_line">
<h2> Agreement Info</h2>
</aside>
    <div class = "mt10"id="agre_grid" style="width:100%; height:200px; margin:0 auto;"></div>
</div>
</article><!-- grid_wrap end -->


</section><!-- pop_body end -->

</div><!-- popup_wrap end -->

