<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<style type="text/css">
/* 커스텀 칼럼 스타일 정의 */
.my-right-style {
    text-align:right;
}
.aui-grid-user-custom-left {
    text-align:left;
}
</style>
<script  type="text/javascript">

var myGridID;

$(document).ready(function(){
	console.log('monthlyAllowanceDetailDisplayPop.jsp');
	var penPopColumnLayout;
    var footerObject;
    var result;
    var type;
    if('${result}' == null || '${result}' == ""){
    	result = null;
    }
    else{
    	result = $.parseJSON('${result}');
    }
    type = '${item.type}';
	if(type=='adjustment'){
		penPopColumnLayout = [{
	         dataField : "appvPrcssDt",
	         headerText : 'Approval Date',
	         width : 150
	     },{
	         dataField : "crditCardAdjNo",
	         headerText : 'Adjustment Doc No',
	         width : 150
	     },{
	         dataField : "adjTypeDesc",
	         headerText : 'Adjustment Type',
	         width : 150
	     },{
	         dataField : "signal",
	         headerText : 'Signal (+/-)',
	         width : 50
	     },{
	         dataField : "crcLimitAdjYyyy",
	         headerText : 'Year/Month',
	         width : 150,
	         labelFunction : function(rowIndex, columnIndex, value, headerText, item) {
	         	var year = item.crcLimitAdjYyyy;
	         	var month = item.crcLimitAdjMm;
	         	if(month.toString().length == 1){
	         		month = "0"+month.toString();
	         	}

	         	return year + "/" + month;
	        }
	     },{
	         dataField : "adjAmt",
	         headerText : 'Adjustment Amount',
	         width : 150,
	         labelFunction : function(rowIndex, columnIndex, value, headerText, item) {
	        	 if(value != null && value != ""){
	        		 return value.toFixed(2);
	        	 }
	         }
	     },{
	         dataField : "adjRem",
	         headerText : 'Remark',
	         width : 150
	     },{
	         dataField : '',
	         headerText : '',
	         width : 100
	     },{
	         dataField : "adjType",
	         visible: false
	     }];

	     footerObject = [ {
	         labelText : "<spring:message code='budget.Total' />",
	         positionField : "appvPrcssDt"
	     	},{
	         positionField : "crditCardAdjNo",
	         dataField : "adjAmt",
	         dataType : "numeric",
	         formatString : "#,##0.00",
	         style : "my-right-style",
	         expFunction : function(columnValues) {
	             var idx = AUIGrid.getRowCount(myGridID);
	             var amt = 0;
	             for(var i = 0; i < idx; i++){
		        	 var adjType = AUIGrid.getCellValue(myGridID, i, "adjType");
		        	 var signal = AUIGrid.getCellValue(myGridID, i, "signal");
		        	 if(signal == '+'){
	                     amt += AUIGrid.getCellValue(myGridID, i, "adjAmt");
	            	 }
	            	 if(signal == '-'){
	                     amt -= AUIGrid.getCellValue(myGridID, i, "adjAmt");
	            	 }
	             }
	             return amt;
	         }
	     },{
	         labelText : "Increase",
	         positionField : "adjTypeDesc"
	     },{
	         positionField : "signal",
	         dataField : "adjAmt",
	         dataType : "numeric",
	         formatString : "#,##0.00",
	         style : "my-right-style",
	         expFunction : function(columnValues) {
	             var idx = AUIGrid.getRowCount(myGridID);
	             var amt = 0;
	             for(var i = 0; i < idx; i++){
		        	 var adjType = AUIGrid.getCellValue(myGridID, i, "adjType");
		        	 var signal = AUIGrid.getCellValue(myGridID, i, "signal");
					if(adjType == '3'){
		                     amt += AUIGrid.getCellValue(myGridID, i, "adjAmt");
					}
	             }
	             return amt;
	         }
	     },{
	         labelText : "Decrease",
	         positionField : "crcLimitAdjYyyy"
	     },{
	         positionField : "adjAmt",
	         dataField : "adjAmt",
	         dataType : "numeric",
	         formatString : "#,##0.00",
	         style : "my-right-style",
	         expFunction : function(columnValues) {
	             var idx = AUIGrid.getRowCount(myGridID);
	             var amt = 0;
	             for(var i = 0; i < idx; i++){
	            	 var adjType = AUIGrid.getCellValue(myGridID, i, "adjType");
	            	 var signal = AUIGrid.getCellValue(myGridID, i, "signal");

	            	 if(adjType == '4'){
		                     amt += AUIGrid.getCellValue(myGridID, i, "adjAmt");
					}
	             }
	             return amt;
	         }
	     },{
	         labelText : "Transfer",
	         positionField : "adjRem"
	     },{
	         positionField : "",
	         dataField : "adjType",
	         dataType : "numeric",
	         formatString : "#,##0.00",
	         style : "my-right-style",
	         expFunction : function(columnValues) {
	             var idx = AUIGrid.getRowCount(myGridID);
	             var amt = 0;
	             for(var i = 0; i < idx; i++){
	            	 var adjType = AUIGrid.getCellValue(myGridID, i, "adjType");
	            	 var signal = AUIGrid.getCellValue(myGridID, i, "signal");
	            	 if(adjType == '1' || adjType == '2'){
		            	 if(signal == '+'){
		                     amt += AUIGrid.getCellValue(myGridID, i, "adjAmt");
		            	 }
		            	 if(signal == '-'){
		                     amt -= AUIGrid.getCellValue(myGridID, i, "adjAmt");
		            	 }
	            	 }
	             }
	             return amt.toFixed(2);
	         }
	     }];
	}
	else{
	     penPopColumnLayout = [{
	         dataField : "appvReqKeyNo",
	         headerText : 'Claim No',
	         width : 120
	     },{
	         dataField : "crditCardUserName",
	         headerText : 'Credit Card Holder Name',
	         width : 150
	     },{
	         dataField : "requestor",
	         headerText : 'Requestor',
	         width : 130
	     },{
	         dataField : "crtDt",
	         headerText : 'Submission Date',
	         width : 130
	     },{
	         dataField : "appvAmt",
	         headerText : 'Amount',
	         width : 100,
	         labelFunction : function(rowIndex, columnIndex, value, headerText, item) {
	        	 if(value != null && value != ""){
	        		 return value.toFixed(2);
	        	 }
	         }
	     },{
	         dataField : "expType",
	         headerText : 'Expenses Type',
	         width : 80
	     },{
	         dataField : "expTypeName",
	         headerText : 'Expenses Type Name',
	         width : 130
	     },{
	         dataField : "expDesc",
	         headerText : 'Remark',
	         width : 240
	     }];

	     footerObject = [ {
	         labelText : "<spring:message code='budget.Total' />",
	         positionField : "crtDt"
	     },{
	         positionField : "appvAmt",
	         dataField : "appvAmt",
	         dataType : "numeric",
	         formatString : "#,##0.00",
	         style : "my-right-style",
	         expFunction : function(columnValues) {
	             var idx = AUIGrid.getRowCount(myGridID);
	             var amt = 0;
	             for(var i = 0; i < idx; i++){
	               	amt += AUIGrid.getCellValue(myGridID, i, "appvAmt");
	             }
	             return amt;
	         }
	     }];
	}

     var penOptions = {
                showStateColumn:false,
                showRowNumColumn    : true,
                usePaging : true,
                editable : false,
                showFooter : true
          };

		myGridID = GridCommon.createAUIGrid("#myGridID", penPopColumnLayout, "", penOptions);
		AUIGrid.setFooter(myGridID, footerObject);
		AUIGrid.setGridData(myGridID, result);
});

function comma(str) {
    str = String(str);
    return str.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
}
</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<c:if test="${item.type == 'pending' }" >
<h1><spring:message code="budget.Pending" /> <spring:message code="budget.Amount" /></h1>
</c:if>
<c:if test="${item.type == 'utilised' }" >
<h1><spring:message code="budget.Utilised" /> <spring:message code="budget.Amount" /></h1>
</c:if>
<c:if test="${item.type == 'adjustment' }" >
<h1>Adjustment <spring:message code="budget.Amount" /></h1>
</c:if>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#"><spring:message code="expense.CLOSE" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body" style="min-height: auto;"><!-- pop_body start -->

<form action="#" method="post" id="penPForm" name="penPForm">
    <table class="type1 mt10"><!-- table start -->
    <caption>table</caption>
    <colgroup>
        <col style="width:120px" />
        <col style="width:*" />
    </colgroup>
    <tbody>
    </tbody>
    </table><!-- table end -->
</form>

<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="myGridID" style="width:100%; height:410px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->
