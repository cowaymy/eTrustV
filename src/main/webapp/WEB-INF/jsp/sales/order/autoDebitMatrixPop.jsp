<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>


<script type="text/javaScript" language="javascript">

    var histGridID;
    var histInfo;

    ordNo = "${headerInfo.ordNo}";
    ordId = "${ordId}";
    today = "${today}";

    var oriMailMobileNo = "${headerInfo.mailCntTelM}";
    var oriMailOfficeNo = "${headerInfo.mailCntTelO}";
    var oriMailHouseNo = "${headerInfo.mailCntTelR}";
    var oriMailFaxNo = "${headerInfo.mailCntTelF}";

	$(document).ready(function(){
		 if('${histInfo}'=='' || '${histInfo}' == null){
	       }else{
	    	   histInfo = JSON.parse('${histInfo}');
	       }

		createAUIGrid();

		var maskedMobileNo = oriMailMobileNo.substr(0,3) + oriMailMobileNo.substr(3,oriMailMobileNo.length-7).replace(/[0-9]/g, "*") + oriMailMobileNo.substr(-4);
		var maskedFaxNo = oriMailFaxNo.substr(0,3) + oriMailFaxNo.substr(3,oriMailFaxNo.length-7).replace(/[0-9]/g, "*") + oriMailFaxNo.substr(-4);
	    var maskedOfficeNo = oriMailOfficeNo.substr(0,2) + oriMailOfficeNo.substr(3,oriMailOfficeNo.length-7).replace(/[0-9]/g, "*") + oriMailOfficeNo.substr(-4);
	    var maskedHouseNo = oriMailHouseNo.substr(0,2) + oriMailHouseNo.substr(3,oriMailHouseNo.length-7).replace(/[0-9]/g, "*") + oriMailHouseNo.substr(-4);

	    if(oriMailMobileNo.replace(/\s/g,"") != ""){
            $("#spanMailMobileNo").html(maskedMobileNo);
            // Appear Mobile No on hover over field
            $("#spanMailMobileNo").hover(function() {
                $("#spanMailMobileNo").html(oriMailMobileNo);
            }).mouseout(function() {
                $("#spanMailMobileNo").html(maskedMobileNo);
            });
        }else{
            $("#imgHoverMobileNo").hide();
        }

	    if(oriMailFaxNo.replace(/\s/g,"") != ""){
            $("#spanMailFaxNo").html(maskedFaxNo);
            // Appear Fax No on hover over field
            $("#spanMailFaxNo").hover(function() {
                $("#spanMailFaxNo").html(oriMailFaxNo);
            }).mouseout(function() {
                $("#spanMailFaxNo").html(maskedFaxNo);
            });
        } else{
           $("#imgHoverFax").hide();
        }

        if(oriMailOfficeNo.replace(/\s/g,"") != ""){
            $("#spanMailOfficeNo").html(maskedOfficeNo);
            // Appear Office No on hover over field
            $("#spanMailOfficeNo").hover(function() {
                $("#spanMailOfficeNo").html(oriMailOfficeNo);
            }).mouseout(function() {
                $("#spanMailOfficeNo").html(maskedOfficeNo);
            });
        } else{
            $("#imgHoverOfficeNo").hide();
        }

        if(oriMailHouseNo.replace(/\s/g,"") != ""){
            $("#spanMailHouseNo").html(maskedHouseNo);
            // Appear House No on hover over field
            $("#spanMailHouseNo").hover(function() {
                $("#spanMailHouseNo").html(oriMailHouseNo);
            }).mouseout(function() {
                $("#spanMailHouseNo").html(maskedHouseNo);
            });
        } else{
                $("#imgHoverHouseNo").hide();
        }

		$('#btnPrint').click(function() {
            fn_matrixRptPop();
        });

	});

    function createAUIGrid(){
        //AUIGrid 칼럼 설정
        var histLayout = [
          {   dataField : "dt", headerText : 'Date', width : 85 }
         ,{   dataField : "custAccNo", headerText : 'Crc/Acc No', width : 200 }
         ,{   dataField : "expDt", headerText : 'Expiry Date',  width : 110 }
         ,{   dataField : "paymode", headerText : 'Paymode', width : 95 }
         ,{   dataField : "issuerBank", headerText : 'Issuer Bank', width : 150 }
         ,{   dataField : "cardType", headerText : 'Card Type', width : 100 }
         ,{   dataField : "transactionType", headerText : 'Transaction<br>Type', width : 120  }
         ,{   dataField : "result", headerText : 'Result', width : 250 }
         ,{   dataField : "trxAmt", headerText : 'Transaction<br>Amount', width : 100 , dataType : "numeric", formatString : "#,##0.00"}
         ,{   dataField : "approvalCodeReceiptNo", headerText : 'Approval Code / Receipt No', width : 250 }
        ];

	     //그리드 속성 설정
	     var histGridPros = {
	         usePaging           : false,             //페이징 사용
	         //pageRowCount        : 10,           //한 화면에 출력되는 행 개수 20(기본값:20)
	         editable                : false,
	         showStateColumn     : false,
	         showRowNumColumn    : false,
	         headerHeight : 30
	       //selectionMode       : "singleRow"  //"multipleCells",
	     };

	     histGridID = GridCommon.createAUIGrid("hist_grid", histLayout, "", histGridPros);


	      if(histInfo != '' ){
	          AUIGrid.setGridData(histGridID, histInfo);
	      }
    }

    function fn_matrixRptPop(){
        var reportDownFileName = ""; //download report name
        var reportFileName = ""; //reportFileName
        var reportViewType = ""; //viewType

        //default input setting
        $("#reportForm").append('<input type="hidden" id="reportFileName" name="reportFileName"  /> ');//report file name
        $("#reportForm").append('<input type="hidden" id="reportDownFileName" name="reportDownFileName" /> '); // download report name
        $("#reportForm").append('<input type="hidden" id="viewType" name="viewType" /> '); // download report  type

        reportFileName = "/sales/AutoDebitMatrixReport.rpt"; //reportFileName
        reportDownFileName = "AD_Report_" + ordNo + "_" + today;  //report name
        reportViewType = "PDF"; //viewType

        //set parameters
        $("#reportForm").append('<input type="hidden" id="ORDID" name="ORDID" value="" /> ');
        $("#reportForm #ORDID").val(ordId);
        console.log($("#reportForm #ORDID").val());

        //report info
        if (reportFileName == "" || reportDownFileName == "" || reportViewType == "") {
            Common.alert("<spring:message code='sys.common.alert.validation' arguments='Report Info' htmlEscape='false'/>");
            return;
        }

       //default setting
       $("#reportForm #reportFileName").val(reportFileName);
       $("#reportForm #reportDownFileName").val(reportDownFileName);
       $("#reportForm #viewType").val(reportViewType);

       //  report 호출
       var option = { isProcedure : false };

       Common.report("reportForm", option);
    }
</script>
<div id="popup_wrap" class="popup_wrap pop_win"><!-- popup_wrap start -->

	<header class="pop_header"><!-- pop_header start -->
	<h1>Auto Debit Matrix</h1>
	<ul class="right_opt">
	    <li><p class="btn_blue2"><a id="btnPrint" href="#" >Print</a></p></li>
	    <li><p class="btn_blue2"><a href="#" onclick="window.close()">CLOSE</a></p></li>
	</ul>
	</header><!-- pop_header end -->

	<section class="pop_body"><!-- pop_body start -->
		<aside class="title_line"><!-- title_line start -->
		    <h2>${headerInfo.custName}</h2>
		</aside><!-- title_line end -->

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
		    <th scope="row">Order Number</th>
		    <td><span>${headerInfo.ordNo}</span></td>
		    <th scope="row">Product</th>
		    <td>( ${headerInfo.stockCode} ) ${headerInfo.stockDesc}</td>
		</tr>
		<tr>
		    <th scope="row">Install Date</th>
		    <td colspan="3"><span>${headerInfo.firstInstallDt}</span></td>
		</tr>
		<tr>
		    <th scope="row">Install Postcode</th>
		    <td colspan="3"><span>${headerInfo.instPostcode}</span></td>
		</tr>
		<tr>
		    <th scope="row">Install City</th>
		    <td colspan="3"><span>${headerInfo.instCity}</span></td>
		</tr>
		<tr>
		    <th scope="row">Mobile</th>
		    <td><a href="#" class="search_btn" id="imgHoverMobileNo"><img style="height:70%" src="${pageContext.request.contextPath}/resources/images/common/nricEye2.png" /></a>
		        <span id="spanMailMobileNo">${headerInfo.mailCntTelM}</span>
		    </td>
		    <th scope="row">Residence</th>
		    <td><a href="#" class="search_btn" id="imgHoverHouseNo"><img style="height:70%" src="${pageContext.request.contextPath}/resources/images/common/nricEye2.png" /></a>
                <span id="spanMailHouseNo">${headerInfo.mailCntTelR}</span>
            </td>
		</tr>
		<tr>
		    <th scope="row">Office</th>
		    <td><a href="#" class="search_btn" id="imgHoverOfficeNo"><img style="height:70%" src="${pageContext.request.contextPath}/resources/images/common/nricEye2.png" /></a>
                <span id="spanMailOfficeNo">${headerInfo.mailCntTelO}</span>
            </td>
		    <th scope="row">Fax</th>
		    <td><a href="#" class="search_btn" id="imgHoverFax"><img style="height:70%" src="${pageContext.request.contextPath}/resources/images/common/nricEye2.png" /></a>
                <span id="spanMailFaxNo">${headerInfo.mailCntTelF}</span>
            </td>
		</tr>
		<tr>
		    <th scope="row">M2 Status</th>
		    <td><span>${headerInfo.m2Stus}</span></td>
		     <th scope="row">Jom Pay Ref 1</th>
            <td><span>${headerInfo.jompay}</span></td>
		</tr>
		<tr>
            <th scope="row">Customer Type</th>
            <td colspan="3"><span>${headerInfo.custType}</span></td>
        </tr>
		<tr>
		    <th scope="row">Opening Paymode</th>
		    <td><span>${headerInfo.openOdrPaymode}</span></td>
		    <th scope="row">Current Paymode</th>
		    <td><span>${headerInfo.currOdrPaymode}</span></td>
		</tr>
		<tr>
		    <th scope="row">Card Type</th>
		    <td><span>${headerInfo.openCrcType}</span></td>
		    <th scope="row">Card Type</th>
		    <td><span>${headerInfo.currCrcType}</span></td>
		</tr>
		</tbody>
		</table><!-- table end -->

		<aside class="mt40 mb10"><!-- title_line start -->
		    <div style="font-size:20px; color:#808080;text-decoration:underline;">Auto Debit History</div>
		</aside><!-- title_line end -->

		<article class="grid_wrap"><!-- grid_wrap start -->
		    <div id="hist_grid" style="width:100%; height:230px; margin:0 auto;"></div>
		</article><!-- grid_wrap end -->

	</section><!-- pop_body end -->
</div><!-- popup_wrap end -->

<form name="reportForm" id="reportForm" method="post"></form>