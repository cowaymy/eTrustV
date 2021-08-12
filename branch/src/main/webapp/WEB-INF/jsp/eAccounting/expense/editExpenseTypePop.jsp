<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script  type="text/javascript">
var expensSearchGridID;


$(document).ready(function() {
    
    CommonCombo.make("expTypeCombo", "/eAccounting/expense/selectExpenseList", {popExpType:"${popExpType}"}, "${popExpType}", {
        id: "expType",
        name: "expTypeName"
    });
	    
    CommonCombo.make("claimTypeCombo", "/common/selectCodeList.do", {groupCode:'343', orderValue:'CODE'}, "${popClaimType}", {
        id: "code",
        name: "codeName"
    });
    
    /* CommonCombo.make("taxCodeCombo", "/eAccounting/expense/selectTaxCodeByClmType.do", null, "${taxCode}", {
        id: "taxCode",
        name: "taxName",
        type:"S"
    }); */
    
    $("#pClmType").val("${popClaimType}");
    $("#pExpType").val("${popExpType}");
    
    $("#glAccCode").val("${glAccCode}");
    $("#glAccCodeName").val( "${glAccCodeName}");
    
    $("#budgetCode").val("${budgetCode}");
    $("#budgetCodeName").val( "${budgetCodeName}");  
    
});

//Budget Code Pop 호출
function fn_budgetCodePop(){
    Common.popupDiv("/eAccounting/expense/budgetCodeSearchPop.do", null, null, true, "budgetCodeSearchPop");
}  

//Gl Account Pop 호출
function fn_glAccountSearchPop(){
     Common.popupDiv("/eAccounting/expense/glAccountSearchPop.do", null, null, true, "glAccountSearchPop");
}

function fn_save(){

	if(fn_validation()){
        Common.confirm("<spring:message code='sys.common.alert.save'/>",fn_updateExpenseType);
    }
}


function fn_validation(){
	
    var budget = $("#budgetCode").val();
    var glAcc = $("#glAccCode").val(); 
   
    var msg1 = '<spring:message code="expense.Activity" />';
    var msg2 = '<spring:message code="expense.GLAccount" />';
    
    
    if($("#disabFlag").val() != "Y"){
    	
    	if (budget == "") {
            Common.alert("<spring:message code='sys.common.alert.validation' arguments='"+msg1+"' htmlEscape='false'/>");
            return false;
        } 
       
        if (glAcc == "") {
            Common.alert("<spring:message code='sys.common.alert.validation' arguments='"+msg2+"' htmlEscape='false'/>");
            return false;
        } 
        
    }    
    
   return true;
}


function fn_updateExpenseType(){
    
    Common.ajax("POST", "/eAccounting/expense/updateExpenseInfo", $("#editForm").serializeJSON(), function(result)    {
        Common.alert(result.data  + "<spring:message code='sys.msg.savedCnt'/>");
        
        console.log("성공." + JSON.stringify(result));
        console.log("data : " + result.data);
        
        fn_selectListAjax();

        $("#editExpenseTypePop").remove();
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


function fn_setGlData (){

    $("#glAccCode").val($("#pGlAccCode").val());
    $("#glAccCodeName").val( $("#pGlAccCodeName").val());
}

function  fn_setBudgetData(){

    $("#budgetCode").val($("#pBudgetCode").val());
    $("#budgetCodeName").val( $("#pBudgetCodeName").val());
}

</script>
<div id="popup_wrap" class="popup_wrap size_small"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="expense.ExpenseType" /></h1>
<ul class="right_opt">
	<li><p class="btn_blue2"><a href="#"><spring:message code="expense.CLOSE" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body" style="min-height: auto"><!-- pop_body start -->

<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id="editForm" name="editForm">
    <input type="hidden" id = "pBudgetCode" name="pBudgetCode" />
    <input type="hidden" id = "pBudgetCodeName" name="pBudgetCodeName" />
    <input type="hidden" id = "pGlAccCode" name="pGlAccCode" />
    <input type="hidden" id = "pGlAccCodeName" name="pGlAccCodeName" />
    <input type="hidden" id = "pClmType" name="pClmType" />
    <input type="hidden" id = "pExpType" name="pExpType" />

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:130px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row"><spring:message code="expense.ClaimType" /></th>
	<td>
    <select class="w100p" id="claimTypeCombo" name="claimTypeCombo" disabled="disabled" >
    </select>
	</td>
</tr>
<tr>
	<th scope="row"><spring:message code="expense.ExpenseType" /></th>
	<td>
	   <select class="w100p" id="expTypeCombo" name="expTypeCombo" disabled="disabled" >
    </select>
	</td>
</tr>
<tr>
	<th scope="row"><spring:message code="expense.Activity" /></th>
	<td>
	<input type="hidden" id = "budgetCode" name="budgetCode" />
	<input type="text" id="budgetCodeName" name="budgetCodeName" title='<spring:message code="expense.Activity" />' placeholder="" class="" /><a href="#" onclick="javascript:fn_budgetCodePop();" class="search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
	</td>
</tr>
<tr>
	<th scope="row"><spring:message code="expense.GLAccount" /></th>
	<td>
	<input type="hidden" id = "glAccCode" name="glAccCode" />
	<input type="text" id="glAccCodeName"  name="glAccCodeName" title='<spring:message code="expense.GLAccount" />' placeholder="" class="" /><a href="#" onclick="javascript:fn_glAccountSearchPop();" class="search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
	</td>
</tr>
<%-- <tr>
    <th scope="row"><spring:message code="newWebInvoice.taxCode" /></th>
    <td>
       <select class="w100p" id="taxCodeCombo" name="taxCode">
    </select>
    </td>
</tr> --%>
<tr>
	<th scope="row"><spring:message code="expense.Disable" /></th>
	<td><label><input type="checkbox" value="Y" id="disabFlag" name ="disabFlag"/><span></span></label></td>
</tr>
</tbody>
</table><!-- table end -->

</form>
</section><!-- search_table end -->

<ul class="center_btns">
	<li><p class="btn_blue2 big"><a href="#" onclick="javascript:fn_save();"><spring:message code="expense.SAVE" /></a></p></li>
</ul>

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->
