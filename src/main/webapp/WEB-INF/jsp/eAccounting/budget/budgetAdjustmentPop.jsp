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

var adjPGridID;

$(document).ready(function(){
	
	setInputFile2();
	
    CommonCombo.make("pAdjustmentType", "/common/selectCodeList.do", {groupCode:'347', orderValue:'CODE'}, "", {
        id: "code",
        name: "codeName",
        type:"S",
        isShowChoose:false
    });
	
	$("#btnAdd").click(fn_AddRow);
    
    $("#btnClear").click(function(){
    	$("input").each(function(){
	        $(this).val("");
	    });
    });
    
    $("#stYearMonth").val("${stYearMonth}");
    $("#edYearMonth").val("${edYearMonth}");
    
    $("#sendYearMonth").change(function(){
    	if($("#pAdjustmentType").val() != "01" && $("#pAdjustmentType").val() != "02" 
    			&& $("#pAdjustmentType").val() != "06" && $("#pAdjustmentType").val() != "07" ){

            $("#recvYearMonth").val($("#sendYearMonth").val());
        }
    });
    
    $("#sendAmount").keydown(function (event) {
    	 if (event.keyCode >= 48 && event.keyCode <= 57) { 
         }else if(event.keyCode == 8){
         }else{
        	return false;         
         }
    });
    
    $("#sendAmount").change(function(){
        var str = $("#sendAmount").val().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
        
    	if($("#pAdjustmentType").val() != "01" && $("#pAdjustmentType").val() != "02"){
            $("#recvAmount").val(str);
    	}
    	$("#sendAmount").val(str);
    });
    
    fn_chnCombo('01');   
    
    var adjPLayout = [  {
        dataField : "budgetAdjType",
        headerText : '<spring:message code="budget.AdjustmentType" />',
        visible : false,
        cellMerge : true ,
        width : 150
    },{
        dataField : "signal",
        headerText : '',
        visible : false
    },{
        dataField : "costCentr",
        headerText : '<spring:message code="budget.CostCenter" />',
        cellMerge : true ,
        mergeRef : "budgetAdjType", // 이전 칼럼(대분류) 셀머지의 값을 비교해서 실행함. (mergePolicy : "restrict" 설정 필수)
        mergePolicy : "restrict", 
        width : 130
    },{
        dataField : "adjYearMonth",
        headerText : '<spring:message code="budget.Month" />/<spring:message code="budget.Year" />',
        cellMerge : true ,
        mergeRef : "budgetAdjType", // 이전 칼럼(대분류) 셀머지의 값을 비교해서 실행함. (mergePolicy : "restrict" 설정 필수)
        mergePolicy : "restrict",
        width : 100
    },{
        dataField : "budgetCode",
        headerText : '<spring:message code="budget.BudgetCode" />',
        cellMerge : true ,
        mergeRef : "budgetAdjType", // 이전 칼럼(대분류) 셀머지의 값을 비교해서 실행함. (mergePolicy : "restrict" 설정 필수)
        mergePolicy : "restrict", 
        width : 130
    },{
        dataField : "glAccCode",
        headerText : '<spring:message code="expense.GLAccount" />',
        cellMerge : true ,
        mergeRef : "budgetAdjType", // 이전 칼럼(대분류) 셀머지의 값을 비교해서 실행함. (mergePolicy : "restrict" 설정 필수)
        mergePolicy : "restrict", 
        width : 130
    },{
        dataField : "budgetAdjTypeName",
        headerText : '<spring:message code="budget.AdjustmentType" />',
        width : 150
    },{
        dataField : "adjAmt",
        headerText : '<spring:message code="budget.Amount" />',
        dataType : "numeric",
        formatString : "#,##0",
        style : "my-right-style",
        width : 100
    },{
        dataField : "adjRem",
        headerText : '<spring:message code="budget.Remark" />',
        style : "aui-grid-user-custom-left ",
        cellMerge : true ,
        mergeRef : "budgetAdjType", // 이전 칼럼(대분류) 셀머지의 값을 비교해서 실행함. (mergePolicy : "restrict" 설정 필수)
        mergePolicy : "restrict", 
        width : 200
    }];
         
    var adjPOptions = {
            enableCellMerge : true,
            showStateColumn:true,
            showRowNumColumn : true,
            usePaging : false,
            editable :false,
            softRemovePolicy : "exceptNew" //사용자추가한 행은 바로 삭제
      }; 
    
    adjPGridID = GridCommon.createAUIGrid("#adjPGridID", adjPLayout, "rowId", adjPOptions);
       
});
function setInputFile2(){//인풋파일 세팅하기
    $(".auto_file2").append("<label><input type='text' class='input_text' readonly='readonly' /><span class='label_text'><a href='#'>File</a></span></label><span class='label_text'><a href='#'>Add</a></span><span class='label_text'><a href='#'>Delete</a></span>");
}
function fn_mon(str){

	if(str == "hide"){
	    $("#sendYearMonth").prop("disabled", false); 	    
	    $("#recvYearMonth").prop("disabled", true);  
	}else{
        $("#sendYearMonth").prop("disabled", false); 
        $("#recvYearMonth").prop("disabled", false);
	}    
}

function fn_Cost(str){
	if( str=="hide" ){
		$("#recvCost").hide();
	    
	    $("#recvCostCenterName").prop("readonly", true);
	    $("#recvCostCenterName").attr("class", "readonly");
	}else if ( str=="show" ){
		$("#recvCost").show();
	    
	    $("#recvCostCenterName").prop("readonly", false);
	    $("#recvCostCenterName").attr("class", "");
	}
}
function fn_budget(str){
	if( str=="hide" ){
		$("#recvBudget").hide();
        
        $("#recvBudgetCodeName").prop("readonly", true);
        $("#recvBudgetCodeName").attr("class", "readonly");
	}else if ( str=="show" ){
		$("#recvBudget").show();
	    
	    $("#recvBudgetCodeName").prop("readonly", false);
	    $("#recvBudgetCodeName").attr("class", "");
	}
}
function fn_glAcc(str){
	
	if( str=="hide" ){
        $("#recvGlAcc").hide();
        
        $("#recvGlAccCodeName").prop("readonly", true);
        $("#recvGlAccCodeName").attr("class", "readonly");
	}else if ( str=="show" ){
		$("#recvGlAcc").show();
	    
	    $("#recvGlAccCodeName").prop("readonly", false);
	    $("#recvGlAccCodeName").attr("class", "");
	}
}


var budgetStr ;
//Budget Code Pop 호출
function fn_budgetCodePop(str){
  budgetStr = str;
  Common.popupDiv("/eAccounting/expense/budgetCodeSearchPop.do",null, null, true, "budgetCodeSearchPop");
}  


function  fn_setBudgetData(){
  if(budgetStr == "send"){
	  
	  $("#sendBudgetCode").val($("#pBudgetCode").val());
      $("#sendBudgetCodeName").val( $("#pBudgetCodeName").val());
	  
	  if($("#pAdjustmentType").val() != "04"){
		  if($("#pAdjustmentType").val() != "01" && $("#pAdjustmentType").val() != "02"){

	          $("#recvBudgetCode").val($("#pBudgetCode").val());
	          $("#recvBudgetCodeName").val( $("#pBudgetCodeName").val());
          }
	      
	  }
  }else{
      $("#recvBudgetCode").val($("#pBudgetCode").val());
      $("#recvBudgetCodeName").val( $("#pBudgetCodeName").val());
  }
  
}

//Gl Account Pop 호출
var glStr ;
function fn_glAccountSearchPop(str){
  glStr = str;
  Common.popupDiv("/eAccounting/expense/glAccountSearchPop.do", null, null, true, "glAccountSearchPop");
}

function fn_setGlData (str){
  
  if(glStr =="send"){
      $("#sendGlAccCode").val($("#pGlAccCode").val());
      $("#sendGlAccCodeName").val( $("#pGlAccCodeName").val());
      
      if($("#pAdjustmentType").val() != "05"){
    	  if($("#pAdjustmentType").val() != "01" && $("#pAdjustmentType").val() != "02"){

    		  $("#recvGlAccCode").val($("#pGlAccCode").val());
              $("#recvGlAccCodeName").val( $("#pGlAccCodeName").val());
          }
         
      }
  }else{
      $("#recvGlAccCode").val($("#pGlAccCode").val());
      $("#recvGlAccCodeName").val( $("#pGlAccCodeName").val());
  }
      
}

//Cost Center
var costStr ;
function fn_costCenterSearchPop(str) {
  costStr = str;
  Common.popupDiv("/eAccounting/webInvoice/costCenterSearchPop.do", null, null, true, "costCenterSearchPop");
}

function fn_setCostCenter (str){

  if(costStr =="send"){
	  
      $("#sendCostCenter").val($("#search_costCentr").val());
      $("#sendCostCenterName").val( $("#search_costCentrName").val());
	  
	  if($("#pAdjustmentType").val() != "03"){
		  if($("#pAdjustmentType").val() != "01" && $("#pAdjustmentType").val() != "02"){

	          $("#recvCostCenter").val($("#search_costCentr").val());
	          $("#recvCostCenterName").val( $("#search_costCentrName").val());
	      }
	  } 
  }else{
      $("#recvCostCenter").val($("#search_costCentr").val());
      $("#recvCostCenterName").val( $("#search_costCentrName").val());
  }
      
}

function fn_chnCombo(str){
	$("#btnClear").click();
	
	if( str =="01" || str =="02"){
        
        fn_mon("hide");
        fn_Cost("hide");
        fn_budget("hide");
        fn_glAcc("hide");               
        
    }else if( str =="03"){

        fn_mon("hide");
        fn_Cost("show");
        fn_budget("hide");
        fn_glAcc("hide");   
        
    }else if( str =="04"){

        fn_mon("hide");
        fn_Cost("hide");
        fn_budget("show");
        fn_glAcc("hide");   
        
    }else if( str =="05"){

        fn_mon("hide");
        fn_Cost("hide");
        fn_budget("hide");
        fn_glAcc("show");   
        
    }else if( str =="06"){

        fn_mon("all");
        fn_Cost("hide");
        fn_budget("hide");
        fn_glAcc("hide");   
        
    }else if( str =="07"){

        fn_mon("all");
        fn_Cost("show");
        fn_budget("show");
        fn_glAcc("show");   
    }
    
    console.log("period_values: " + str);
}


//MstGrid 행 추가, 삽입
function fn_AddRow()
{
    var item = new Object();

    if ( $("#sendYearMonth").val() == "") {
        var msg = '<spring:message code="budget.Month" />/<spring:message code="budget.Year" />';
        Common.alert("<spring:message code='sys.common.alert.validation' arguments='"+msg+"' htmlEscape='false'/>", function(){
        	
	        $("#sendYearMonth").focus();
        });
        return false;
    }
    if ( $("#sendCostCenter").val() == "") {
        var msg = '<spring:message code="budget.CostCenter" />';
        Common.alert("<spring:message code='sys.common.alert.validation' arguments='"+msg+"' htmlEscape='false'/>", function(){
        	
	        $("#sendCostCenterName").focus();
        });
        return false;
    }
    
    if ( $("#sendBudgetCode").val() == "") {
        var msg = '<spring:message code="budget.BudgetCode" />';
        Common.alert("<spring:message code='sys.common.alert.validation' arguments='"+msg+"' htmlEscape='false'/>", function(){
        	
	        $("#sendBudgetCodeName").focus();
        });
        return false;
    }
    if ( $("#sendGlAccCode").val() == "") {
        var msg = '<spring:message code="expense.GLAccount" />';
        Common.alert("<spring:message code='sys.common.alert.validation' arguments='"+msg+"' htmlEscape='false'/>", function(){
        	
            $("#sendGlAccCodeName").focus();
        });
        return false;
    }
    if ( $("#sendAmount").val() == "") {
        var msg = '<spring:message code="budget.Send" /> <spring:message code="budget.Amount" />';
        Common.alert("<spring:message code='sys.common.alert.validation' arguments='"+msg+"' htmlEscape='false'/>", function(){

            $("#sendAmount").focus();
        });
        return false;
    }
    
    item.costCentr = $("#sendCostCenter").val();
    item.adjYearMonth = $("#sendYearMonth").val();
    item.budgetCode  = $("#sendBudgetCode").val();
    item.glAccCode  = $("#sendGlAccCode").val();
    item.budgetAdjType  =$("#pAdjustmentType").val();
    item.budgetAdjTypeName  =$("#pAdjustmentType option:selected").text();
    item.adjAmt  = $("#sendAmount").val().replace(",", "");
    item.adjRem  = $("#remark").val();
    
    if($("#pAdjustmentType").val() == '01' ){
        item.signal  = '+';
    }else{
    	item.signal  = '-';
    }
    
    
    if($("#pAdjustmentType").val() != '01' && $("#pAdjustmentType").val() !=''){
    	var item2 = new Object();
    	
        if ( $("#recvYearMonth").val() == "") {
            var msg = '<spring:message code="budget.Month" />/<spring:message code="budget.Year" />';
            Common.alert("<spring:message code='sys.common.alert.validation' arguments='"+msg+"' htmlEscape='false'/>", function(){
            	$("#recvYearMonth").focus();
            });
            //
            return false;
        }
        if ( $("#recvCostCenter").val() == "") {
            var msg = '<spring:message code="budget.CostCenter" />';
            Common.alert("<spring:message code='sys.common.alert.validation' arguments='"+msg+"' htmlEscape='false'/>", function(){
                $("#recvCostCenterName").focus();
            });
            return false;
        }
        
        if ( $("#recvBudgetCode").val() == "") {
            var msg = '<spring:message code="budget.BudgetCode" />';
            Common.alert("<spring:message code='sys.common.alert.validation' arguments='"+msg+"' htmlEscape='false'/>",  function(){

                $("#recvBudgetCodeName").focus();
            });
            return false;
        }
        if ( $("#recvGlAccCode").val() == "") {
            var msg = '<spring:message code="expense.GLAccount" />';
            Common.alert("<spring:message code='sys.common.alert.validation' arguments='"+msg+"' htmlEscape='false'/>", function(){
                $("#recvGlAccCodeName").focus();
            });
            return false;
        }
        if ( $("#recvAmount").val() == "") {
            var msg = '<spring:message code="budget.Send" /> <spring:message code="budget.Amount" />';
            Common.alert("<spring:message code='sys.common.alert.validation' arguments='"+msg+"' htmlEscape='false'/>", function(){
                $("#recvAmount").focus();
            });
            return false;
        }
    	
        item2.costCentr = $("#recvCostCenter").val();
        item2.adjYearMonth   =$("#recvYearMonth").val();
        item2.budgetCode  = $("#recvBudgetCode").val();
        item2.glAccCode  = $("#recvGlAccCode").val();
        item2.budgetAdjType  =$("#pAdjustmentType").val();
        item2.budgetAdjTypeName  =$("#pAdjustmentType option:selected").text();
        item2.adjAmt  = $("#recvAmount").val().replace(",", "");
        item2.adjRem  = $("#remark").val();
        item2.signal  = '+';
    }
    
    // parameter
    // item : 삽입하고자 하는 아이템 Object 또는 배열(배열인 경우 다수가 삽입됨)
    // rowPos : rowIndex 인 경우 해당 index 에 삽입, first : 최상단, last : 최하단, selectionUp : 선택된 곳 위, selectionDown : 선택된 곳 아래
    AUIGrid.addRow(adjPGridID, item, 'last');                    
    AUIGrid.addRow(adjPGridID, item2, 'last');                    
}  

function fn_uploadFile() {
   
        var formData = Common.getFormData("pAdjForm");
        
        Common.ajaxFile("/eAccounting/budget/uploadFile.do", formData, function(result) {//  첨부파일 정보를 공통 첨부파일 테이블 이용 : 웹 호출 테스트

            console.log(result);
          
            $("#atchFileGrpId").val(result.data);
            
            fn_saveAdjustement();
        }); 
        
        
}

function fn_saveAdjustement(){
	
	var atchFileGrpId = $("#atchFileGrpId").val();
    
    Common.ajax("POST", "/eAccounting/budget/saveAdjustmentList?atchFileGrpId="+atchFileGrpId, GridCommon.getEditData(adjPGridID), function(result)    {
        Common.alert(result.data  + "<spring:message code='sys.msg.savedCnt'/>");
        //fn_selectPopListAjax() ;

        console.log("성공." + JSON.stringify(result));
        console.log("data : " + result.data);
     }
     , function(jqXHR, textStatus, errorThrown){
            try {
                console.log("Fail Status : " + jqXHR.status);
                console.log("code : "        + jqXHR.responseJSON.code);
                console.log("message : "     + jqXHR.responseJSON.message);
                console.log("detailMessage : "  + jqXHR.responseJSON.detailMessage);
          }
          catch (e)
          {
            console.log(e);
          }
          alert("Fail : " + jqXHR.responseJSON.message);
    });
}

</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="budget.BudgetAdjustment" /></h1>
<ul class="right_opt">
	<li><p class="btn_blue2"><a href="#"><spring:message code="expense.CLOSE" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body" style="min-height:540px;"><!-- pop_body start -->

<form action="#" method="post" id="pAdjForm" name="pAdjForm" enctype="multipart/form-data">
<section class="search_table"><!-- search_table start -->

    <input type="hidden" id = "pBudgetCode" name="pBudgetCode" />
    <input type="hidden" id = "pBudgetCodeName" name="pBudgetCodeName" />
    <input type="hidden" id = "pGlAccCode" name="pGlAccCode" />
    <input type="hidden" id = "pGlAccCodeName" name="pGlAccCodeName" />
    
    <input type="hidden" id = "search_costCentr" name="search_costCentr" />
    <input type="hidden" id = "search_costCentrName" name="search_costCentrName" />
    <input type="hidden" id = "atchFileGrpId" name="atchFileGrpId" />

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:130px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row"><spring:message code="budget.AdjustmentType" /></th>
	<td>
	<select class="" id="pAdjustmentType" name="pAdjustmentType" onchange="javascript:fn_chnCombo(this.value);">
	</select>
	</td>
</tr>
</tbody>
</table><!-- table end -->

</section><!-- search_table end -->

<div class="divine_auto"><!-- divine_auto start -->

<div style="width:50%;">

<aside class="title_line budget"><!-- title_line start -->
<h3><spring:message code="budget.Sender" /></h3>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:130px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row"><spring:message code="budget.Month" />/<spring:message code="budget.Year" /></th>
<%-- 	<td><input type="text" title="" placeholder="" class="" /><a href="#" class="search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a></td> --%>
	<td><input type="text" id="sendYearMonth" name="sendYearMonth" title="" placeholder="MM/YYYY" class="j_date2" /></td>
</tr>
<tr>
	<th scope="row"><spring:message code="budget.CostCenter" /></th>
	<td>
		<input type="hidden" id="sendCostCenter" name="sendCostCenter" title="" placeholder="" class="" />
	    <input type="text" id="sendCostCenterName" name="sendCostCenterName" title="" placeholder="" class="" />
	    <a href="#" class="search_btn"  onclick="javascript:fn_costCenterSearchPop('send')">
	        <img  id="sendCost"   src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" />
	    </a>
    </td>
</tr>
<tr>
	<th scope="row"><spring:message code="budget.BudgetCode" /></th>
	<td>
		<input type="hidden" id="sendBudgetCode" name="sendCostCenter" title="" placeholder="" class="" />
		<input type="text" id="sendBudgetCodeName" name="sendBudgetCodeName" title="" placeholder="" class="" />
		<a href="#" id="sendBudget" class="search_btn" onclick="javascript:fn_budgetCodePop('send')">
		   <img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" />
		</a>
	</td>
</tr>
<tr>
	<th scope="row"><spring:message code="expense.GLAccount" /></th>
	<td>
		<input type="hidden" id="sendGlAccCode" name="sendGlAccCode" title="" placeholder="" class="" />
		<input type="text" id="sendGlAccCodeName" name="sendGlAccCodeName" title="" placeholder="" class="" />
		<a href="#" id="sendGlAcc" class="search_btn" onclick="javascript:fn_glAccountSearchPop('send')">
		   <img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" />
		</a>
	</td>
</tr>
<tr>
	<th scope="row"><spring:message code="budget.Send" /> <spring:message code="budget.Amount" /></th>
	<td><input type="text" id="sendAmount" name="sendAmount" title="" placeholder="" class="al_right" /></td>
</tr>
</tbody>
</table><!-- table end -->

</div>

<div style="width:50%;">

<aside class="title_line budget"><!-- title_line start -->
<h3><spring:message code="budget.Receiver" /></h3>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:140px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row"><spring:message code="budget.Month" />/<spring:message code="budget.Year" /></th>
<%-- 	<td><input type="text" title="" placeholder="" class="" /><a href="#" class="search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a></td> --%>
	<td><input type="text" id="recvYearMonth" name="recvYearMonth" title="" placeholder="MM/YYYY" class="j_date2" /></td>
</tr>
<tr>
	<th scope="row"><spring:message code="budget.CostCenter" /></th>
	<td>
        <input type="hidden" id="recvCostCenter" name="recvCostCenter" title="" placeholder="" class="" />
		<input type="text" id="recvCostCenterName" name="recvCostCenterName" title="" placeholder="" class="" />
		<a href="#" id="recvCost" class="search_btn" onclick="javascript:fn_costCenterSearchPop('recv')">
		   <img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" />
		</a>
	</td>
</tr>
<tr>
	<th scope="row"><spring:message code="budget.BudgetCode" /></th>
	<td>
		<input type="hidden" id="recvBudgetCode" name="recvBudgetCode" title="" placeholder="" class="" />
		<input type="text" id="recvBudgetCodeName" name="recvBudgetCodeName" title="" placeholder="" class="" />
		<a href="#" id="recvBudget" class="search_btn" onclick="javascript:fn_budgetCodePop('recv')">
		   <img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" />
	   </a>
   </td>
</tr>
<tr>
	<th scope="row"><spring:message code="expense.GLAccount" /></th>
	<td>
        <input type="hidden" id="recvGlAccCode" name="recvGlAccCode" title="" placeholder="" class="" />
		<input type="text"  id="recvGlAccCodeName" name="recvGlAccCodeName" title="" placeholder="" class="" />
		<a href="#" id="recvGlAcc" class="search_btn" onclick="javascript:fn_glAccountSearchPop('recv')">
		   <img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" />
		</a>
	</td>
</tr>
<tr>
	<th scope="row"><spring:message code="budget.Receiver" /> <spring:message code="budget.Amount" /></th>
	<td><input type="text"  id="recvAmount" name="recvAmount" title="" placeholder="" class="readonly al_right" readonly="readonly" /></td>
</tr>
</tbody>
</table><!-- table end -->

</div>

</div><!-- divine_auto end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:130px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row"><spring:message code="budget.REMARK" /></th>
	<td><input type="text" id="remark" name="remark" title="" placeholder="" class="w100p" /></td>
</tr>
</tbody>
</table><!-- table end -->

<ul class="center_btns">
	<li><p class="btn_blue2"><a href="#" id="btnAdd"><spring:message code="expense.Add" /></a></p></li>
	<li><p class="btn_blue2"><a href="#" id="btnClear"><spring:message code="budget.Clear" /></a></p></li>
</ul>

<article class="grid_wrap mt10" style="height:170px"><!-- grid_wrap start -->
    <div id="adjPGridID" style="width:100%; height:150px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

<table class="type1 mt10"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:120px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row"><spring:message code="budget.Attathment" /></th>
	<td>
	<div class="auto_file2"><!-- auto_file start -->
	<input type="file" title="file add" />
	</div><!-- auto_file end -->
	</td>
</tr>
</tbody>
</table><!-- table end -->

<ul class="center_btns mt10">
	<li><p class="btn_blue2"><a href="#" onclick="javascript:fn_uploadFile();"><spring:message code="budget.Temp" /> <spring:message code="budget.Save" /></a></p></li>
	<%-- <li><p class="btn_blue2"><a href="#"><spring:message code="budget.Submit" /></a></p></li> --%>
</ul>

</form>
</section><!-- pop_body end -->

</div><!-- popup_wrap end -->