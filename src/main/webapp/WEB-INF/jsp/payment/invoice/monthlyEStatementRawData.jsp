<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<script type="text/javaScript">
var myGridID;

//Grid에서 선택된 RowID
var selectedGridValue;

$(document).ready(function(){
    myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout,null,gridPros);
    AUIGrid.setSelectionMode(myGridID, "singleRow");  
    
    // Master Grid 셀 클릭시 이벤트
    AUIGrid.bind(myGridID, "cellClick", function( event ){ 
        selectedGridValue = event.rowIndex;
    });
    
    var curDate = new Date();   
    
    fn_setYearList(curDate.getFullYear()-10, curDate.getFullYear());
    fn_setMonthList();
    
});

var gridPros = {
        editable: false,
        showStateColumn: false,
        pageRowCount : 20
};

var columnLayout=[
    {dataField:"invcId", headerText:"<spring:message code='pay.head.taskId'/>", width : 80},
    {dataField:"custName", headerText:"<spring:message code='pay.head.custName'/>", width : 150},
    {dataField:"custEmail", headerText:"<spring:message code='pay.head.email'/>" , width : 150},
    {dataField:"invcDate", headerText:"<spring:message code='pay.head.invoiceDate'/>" , width : 100},
    {dataField:"currCharg", headerText:"<spring:message code='pay.head.currcharges'/>", width : 150},
    {dataField:"prevBal", headerText:"<spring:message code='pay.head.prevBal'/>", width : 150}, 
    {dataField:"totOut", headerText:"<spring:message code='pay.head.totOut'/>", width : 150},
    {dataField:"virtualAcc", headerText:"<spring:message code='pay.head.virtualacc'/>",width : 150},
    {dataField:"invcNo", headerText:"<spring:message code='pay.head.invoiceNo'/>",width : 150},
    {dataField:"billCode", headerText:"<spring:message code='pay.head.billCode'/>",width : 80},
    {dataField:"refNo1", headerText:"<spring:message code='pay.head.ref1'/>",width : 80},
    {dataField:"refNo2", headerText:"<spring:message code='pay.head.ref2'/>",width : 150},
    {dataField:"cowayEmail", headerText:"<spring:message code='pay.head.cowayemail'/>",width : 150}
];


	function fn_setYearList(startYear, endYear) {
		$("#year").append("<option value='' disabled selected hidden>issueYear</option>");
		for (var i = startYear; i <= endYear + 1; i++) {
			$("#year").append("<option value="+i +">" + i + "</option>");
		}
	}

	function fn_setMonthList() {
		$("#month").append("<option value='' disabled selected hidden>issueMonth</option>");
		for (var i = 1; i < 13; i++) {
			$("#month").append("<option value="+i +">" + i + "</option>");
		}
	}

	function validRequiredField() {

		var valid = true;
		var message = "";

		if ($("#year").val() == null || $("#year").val().length == 0) {
			valid = false;
			message += 'Please select the issue Year.|!|';
		}

		if ($("#month").val() == null || $("#month").val().length == 0) {
			valid = false;
			message += 'Please select the issue Month.|!|';
		}

		if (valid == false) {
			Common.alert('<spring:message code="sal.alert.title.warning" />' + DEFAULT_DELIMITER + message);

		}

		return valid;
	}
	
	function fn_geteStatementList() {
		if (validRequiredField() == true) {
			Common.ajax("GET", "/payment/selecteStatementRawList.do", $("#searchForm").serialize(), function(result) {
				AUIGrid.setGridData(myGridID, result);
				selectedGridValue = undefined;
			});
		} else {
			return false;
		}
	}
	
	
	function fn_generateCSVFormat() {
		if (validRequiredField() == true) {
			var date = new Date().getDate();
			if (date.toString().length == 1) {
				date = "0" + date;
			}

			var reportDownFileName = "EStatement_Invoice_" + date + (new Date().getMonth() + 1) + new Date().getFullYear();

			GridCommon.exportTo("grid_wrap", 'csv', reportDownFileName);

		}
		else {
			return false;
		}
	}

	/* commented by vannie due to different method to gen CSV format, but file export with duplicates data at the bottom. 
	function fn_generateCSVFormat() {

		if (validRequiredField() == true) {
			var whereSQL = "";
			var orderBySQL = "";
			var year = "";
			var month = "";

			$("#reportFileName").val("");
			$("#reportDownFileName").val("");
			$("#viewType").val("CSV");

			if ($("#year :selected").val() > 0) {
				whereSQL += " AND EXTRACT (YEAR FROM TAX_INVC_CRT_DT) = '" + $("#year").val() + "'";
				year = $("#year :selected").text();
			}

			if ($("#month :selected").val() > 0) {
				whereSQL += " AND EXTRACT (MONTH FROM TAX_INVC_CRT_DT) = '" + $("#month").val() + "'";
				month = $("#month :selected").text();
			}

			var date = new Date().getDate();
			if (date.toString().length == 1) {
				date = "0" + date;
			}

			$("#searchForm #reportFileName").val("/payment/E-Statement_InvoiceList_CSV.rpt");
			$("#reportDownFileName").val("EStatement_Invoice_" + date + (new Date().getMonth() + 1) + new Date().getFullYear());

			orderBySQL += " ORDER BY TAX_INVC_ID ";

			$("#searchForm #V_YEAR").val(year);
			$("#searchForm #V_MONTH").val(month);
			$("#searchForm #V_SELECTSQL").val("");
			$("#searchForm #V_WHERESQL").val(whereSQL);
			$("#searchForm #V_ORDERBYSQL").val(orderBySQL);
			$("#searchForm #V_FULLSQL").val("");

			var option = {
				isProcedure : true
			};

			Common.report("searchForm", option);

		}
		else {
			return false;
		}
	} */
</script>

<!-- content start -->
<section id="content">
    <ul class="path">
        <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    </ul>

	<!-- title_line start -->
	<aside class="title_line">
	    <p class="fav"><a href="javascript:;" class="click_add_on"><spring:message code='pay.text.myMenu'/></a></p>
	    <h2>Monthly E-Statement Raw Data</h2>   
	    <ul class="right_btns">
	        <c:if test="${PAGE_AUTH.funcPrint == 'Y'}">
	        <li><p class="btn_blue"><a href="javascript:fn_generateCSVFormat()"><spring:message code='pay.btn.downloadCsvFormat'/></a></p></li>
	        </c:if>
	        <c:if test="${PAGE_AUTH.funcView == 'Y'}">
	        <li><p class="btn_blue"><a href="javascript:fn_geteStatementList();"><span class="search"></span><spring:message code='sys.btn.search'/></a></p></li>
	        </c:if>
	    </ul>    
	</aside>
	<!-- title_line end -->


	<!-- search_table start -->
	<section class="search_table">
	    <form name="searchForm" id="searchForm"  method="post" action="#">
	    <input type="hidden" id="reportFileName" name="reportFileName" /> 
	    <input type="hidden" id="viewType" name="viewType" />
	    <input type="hidden" id="V_YEAR" name="V_YEAR" />
	    <input type="hidden" id="V_MONTH" name="V_MONTH" />
	    <input type="hidden" id="V_SELECTSQL" name="V_SELECTSQL" />
	    <input type="hidden" id="V_WHERESQL" name="V_WHERESQL" />
	    <input type="hidden" id="V_ORDERBYSQL" name="V_ORDERBYSQL" />
	    <input type="hidden" id="V_FULLSQL" name="V_FULLSQL" />
	    <input type="hidden" id="reportDownFileName" name="reportDownFileName" />
	
	        <table class="type1"><!-- table start -->
				<caption>table</caption>
				<colgroup>
					<col style="width:144px" />
					<col style="width:200px" />
					<col style="width:144px" />
					<col style="width:200px" />
					<col style="width:*" />
				</colgroup>
		        <tbody>
		            <tr>
		                <th scope="row">Year</th>
		                <td>
		                    <select id="year" name="year" class="w100p"></select>
		                </td>
		                <th scope="row">Month</th>
		                <td>
		                   <select id="month" name="month" class="w100p"></select>
		                </td>
		                <td></td>
		            </tr>
		         </tbody>
	       </table>
	   </form>
    </section>

	<!-- search_result start -->
	<section class="search_result">    
        <!-- grid_wrap start -->
		<article id="grid_wrap" style="height:500px" class="grid_wrap"></article>
		<!-- grid_wrap end -->
	</section>
</section>

<!-- popup_wrap end -->