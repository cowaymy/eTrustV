<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
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

    //fn_getBillingList();

    var curDate = new Date();

    fn_setYearList(curDate.getFullYear()-10, curDate.getFullYear());
    fn_setMonthList();

    AUIGrid.bind(myGridID, "rowCheckClick", function(event){
    	var checklist = AUIGrid.getCheckedRowItems(myGridID);
    	console.log("check " + checklist.length);
    	if(checklist.length > 3){
    		Common.alert("Unable to select more than 3 records.");
            AUIGrid.addUncheckedRowsByValue(myGridID,"taskId", event.item.taskId);
            return false;
    	}
    });
});

var gridPros = {
        editable: false,
        showStateColumn: false,
        pageRowCount : 10
         ,showRowCheckColumn : true,
        rowCheckDisabledFunction : function(rowIndex, isChecked, item)
        {
          if(item.isInvcGenrt == 1) { // Approve시 disabled
            return false; // false 반환하면 disabled 처리됨
          }

          return true;
        },
        independentAllCheckBox : true,
};

var columnLayout=[
    {dataField:"taskId", headerText:"<spring:message code='pay.head.taskId'/>", width : 150},
    {dataField:"taskType", headerText:"<spring:message code='pay.head.taskType'/>"},
    {dataField:"billingYear", headerText:"<spring:message code='pay.head.year'/>" , width : 150},
    {dataField:"billingMonth", headerText:"<spring:message code='pay.head.month'/>", width : 150},
    {dataField:"sum", headerText:"<spring:message code='pay.head.bills'/>" , width : 150, dataType : "numeric", formatString : "#,##0"},
    {dataField:"accBillNetAmt", headerText:"<spring:message code='pay.head.amount'/>", width : 150, dataType : "numeric", formatString : "#,##0.00"},
    {dataField:"startDt", headerText:"<spring:message code='pay.head.requestDate'/>", width : 200, dataType : "date", formatString : "yyyy-mm-dd hh:MM:ss"},
    /* {dataField:"endDt", headerText:"<spring:message code='pay.head.ended'/>", width : 200, dataType : "date", formatString : "yyyy-mm-dd hh:MM:ss"}, */
    {dataField:"isInvcGenrt", headerText:"<spring:message code='pay.head.generate'/>",width : 80,
        renderer:{
        	type : "CheckBoxEditRenderer",
        	showLabel : false,
        	editable : false,
        	checkValue : "1",
        	unCheckValue : "0"
        }
    },
    {dataField:"username", headerText:"<spring:message code='pay.head.userName'/>", width : 150}
];

function fn_setYearList(startYear, endYear){
	$("#year").append("<option value='' disabled selected hidden>issueYear</option>");
	for(var i=startYear; i<=endYear+1; i++){
		$("#year").append("<option value="+i +">"+i+"</option>");
	}
}

function fn_setMonthList(){
	$("#month").append("<option value='' disabled selected hidden>issueMonth</option>");
	for(var i=1; i<13; i++){
		$("#month").append("<option value="+i +">"+i+"</option>");
	}
}

function fn_getInvoiceList(){
	if($("#year").val() != null && $("#month").val() != null){
		Common.ajax("GET", "/payment/selectInvoiceStmtMgmtList.do", $("#searchForm").serialize(), function(result) {
	        AUIGrid.setGridData(myGridID, result);
	        selectedGridValue = undefined;
	    });
	}else{
		Common.alert("<spring:message code='pay.alert.yearMonthFirst'/>");
	}
}

function fn_view(){
	if(selectedGridValue != undefined){
		var value = AUIGrid.getCellValue(myGridID , selectedGridValue , "taskId");

		//location.href="/payment/initBillingConfirmedResult.do?taskId="+value;
		Common.popupDiv('/payment/initBillingConfirmedResultPop.do', {taskId:value}, null , true ,'_billingDetailViewPop')
	}else{
		Common.alert("<spring:message code='pay.alert.noTaskId'/>");
	}
}

function fn_report(){

	var whereSQL = "";
	if($("#year").val() == null || $("#month").val() == null){
		Common.alert("Please choose year and month.");
        return false;
	}

	whereSQL += "MONTH = '" + $("#year").val() + "' AND YEAR = '" + $("#year").val() + "'" ;

	var date = new Date().getDate();
    if(date.toString().length == 1){
        date = "0" + date;
    }

	$("#reportDownFileName").val("InvoiceRawData"+date+(new Date().getMonth()+1)+new Date().getFullYear());
    $("#form #reportFileName").val("/bill/InvoiceRawData.rpt");
    $("#form #viewType").val('EXCEL');
    $("#form #V_YEAR").val($("#year").val());
    $("#form #V_MONTH").val($("#month").val());

    // 프로시져로 구성된 경우 꼭 아래 option을 넘겨야 함.
    var option = {
            isProcedure : true // procedure 로 구성된 리포트 인경우 필수.  => /payment/PaymentListing_Excel.rpt 는 프로시져로 구성된 파일임.
    };

    Common.report("form", option);
}

function fn_generateInv(){
	if ("true" == $("#allChk").val()) {
        Common.alert("Not Allow to Check All rows");
        return false;
      }

	var selectedchecklist = AUIGrid.getCheckedRowItems(myGridID);

	if (selectedchecklist == 0) {
        Common.alert("No rows selected.");
        return false;
      }

	var rowItem;
	for (var i = 0, len = selectedchecklist.length; i < len; i++) {
		rowItem = selectedchecklist[i];
		var taskInvoiceGenerate = rowItem.item.isInvcGenrt;
		var taskType = rowItem.item.taskType;
		console.log("teasjtype " + taskType);
		console.log("isInvcGenrt " + taskInvoiceGenerate);

		if(taskType == 'BILL' || taskType == 'EARLY BILL' ){
	        Common.alert("BILL / EARLY BILL will be running Procedure by IT team.");
	        return;
	    }

		if(taskInvoiceGenerate == 1){
			Common.alert("<spring:message code='pay.alert.taskIdGenerated'/>");
			return;
		}
	}

	var data = {};
	data.checked = selectedchecklist;

	Common.ajax("POST", "/payment/generateInvoice.do", data, function(result) {
        if(result == false) {
        	Common.alert("<spring:message code='pay.alert.failSaveReqAgain'/>");
        }
        else {
	         fn_getInvoiceList();
	         Common.alert("<spring:message code='pay.alert.billTaskConf'/>");
        }
    });
}
</script>

<!-- content start -->
<section id="content">
    <ul class="path">
        <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    </ul>

	<!-- title_line start -->
	<aside class="title_line">
	    <p class="fav"><a href="javascript:;" class="click_add_on"><spring:message code='pay.text.myMenu'/></a></p>
	    <h2>Invoice/Statement</h2>
	    <ul class="right_btns">
	        <c:if test="${PAGE_AUTH.funcPrint == 'Y'}">
	        <li><p class="btn_blue"><a href="javascript:fn_generateInv()"><spring:message code='pay.btn.generateInvStatement'/></a></p></li>
	        </c:if>
	        <c:if test="${PAGE_AUTH.funcView == 'Y'}">
	        <li><p class="btn_blue"><a href="javascript:fn_getInvoiceList();"><span class="search"></span><spring:message code='sys.btn.search'/></a></p></li>
	        </c:if>
	    </ul>
	</aside>
	<!-- title_line end -->


	<!-- search_table start -->
	<section class="search_table">

    <form name="form" id="form"  method="post">
		<input type="hidden" id="reportFileName" name="reportFileName" value="" />
		<input type="hidden" id="viewType" name="viewType" value="" />
		<input type="hidden" id="reportDownFileName" name="reportDownFileName" value="" />

		<input type="hidden" id="V_YEAR" name="V_YEAR" value="" />
		<input type="hidden" id="V_MONTH" name="V_MONTH" value="" />
    </form>

	    <form name="searchForm" id="searchForm"  method="post">
        <input type="hidden" name="allChk" id="allChk" value="false" />
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
	   <!-- link_btns_wrap start -->
	   <aside class="link_btns_wrap">
	       <p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
	       <dl class="link_list">
	           <dt>Link</dt>
	           <dd>
	               <ul class="btns">
	                   <c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
	                   <li><p class="link_btn"><a href="javascript:fn_view()"><spring:message code='pay.btn.link.viewDetails'/></a></p></li>
	                   </c:if>
	                   <c:if test="${PAGE_AUTH.funcUserDefine2 == 'Y'}">
                       <li><p class="link_btn"><a href="javascript:fn_report()">RAW DATA GENERATE</a></p></li>
                       </c:if>
	               </ul>
	               <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
	           </dd>
	       </dl>
	   </aside>
    </section>

	<!-- search_result start -->
	<section class="search_result">
        <!-- grid_wrap start -->
		<article id="grid_wrap" class="grid_wrap"></article>
		<!-- grid_wrap end -->
	</section>
</section>

<!-- popup_wrap end -->