<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">
var myGridID_order;
var complianceList;
$(document).ready(function(){
	
	        $("#salesOrdNo").focusout(function(){
             alert($("#salesOrdNo").val())
             if (  $("#salesOrdNo").val().length > 6) {
             
             Common.ajax("GET", "/organization/compliance/selectSalesOrdNoInfo.do",   { salesOrdNo :  $("#salesOrdNo").val() }  , function(result) {
                console.log("selectSalesOrdNoInfo >>> .");
                console.log(  JSON.stringify(result));

                 $("#reqstCntnt").val(result[0].serialNo)
                 $("#customerName").val(result[0].custId)
              
            }); 
             }
         }); 
	
	   //doGetComboCodeId('/common/selectReasonCodeList.do', {typeId : 1389, inputId : 1, separator : '-'}, '', 'caseCategory', 'S'); //Reason Code
	   //doGetComboCodeId('/common/selectReasonCodeList.do', {typeId : 1390, inputId : 1, separator : '-'}, '', 'docType', 'S'); //Reason Code
/* 	   
	   $("#caseCategory").change(function(){
	   
	       alert($(this).val());
	   
	       if($("#caseCategory").val() == '2144' ){
	    	   $("select[name=docType]").removeAttr("disabled");
	    	   $("select[name=docType]").removeClass("w100p disabled");
	    	   $("select[name=docType]").addClass("w100p");
	        }else{
	        	 $("#docType").val("");
	        	 $("select[name=docType]").attr('disabled', 'disabled');
	             $("select[name=docType]").addClass("disabled");
	             //$("select[name=docType]").addClass("w100p");
	        }   
		   
	   }); */
	  
	   
});

/* 
function fn_validation(){
    console.log(JSON.stringify( $("#saveForm").serializeJSON() ))
    
    alert("customerName >>  " + $("#customerName").val() );

    if($("#customerName").val() == ''){
        Common.alert("<spring:message code='sys.common.alert.validation' arguments='Customer Name' htmlEscape='false'/>");
        return false;
    }
    if($("#salesOrdNo").val() == ''){
        Common.alert("<spring:message code='sys.common.alert.validation' arguments='Order No' htmlEscape='false'/>");
        return false;
    }
    if($("#reqstRefDt").val() == ''){
        Common.alert("<spring:message code='sys.common.alert.validation' arguments='Complaint Date' htmlEscape='false'/>");
        return false;
    }
    
    return true;
} */

function fn_saveConfirm(){
	//if(fn_validation()){
		 var jsonObj =  {};
         jsonObj.form = $("#saveForm").serializeJSON();
         
		Common.ajax("POST", "/organization/compliance/saveGuardian.do", jsonObj, function(result) {
	        console.log("성공.");
	        Common.alert("Guardian of Compliance saved.");
	    });	
	//}
}

function fn_uploadfile(){
	Common.popupDiv("/organization/compliance/uploadGuardianAttachPop.do"  , null, null , true , 'fileUploadPop');
}


function fn_caseChange (val) {

    if(val == '2144' ){
        $("select[name=docType]").removeAttr("disabled");
        $("select[name=docType]").removeClass("w100p disabled");
        $("select[name=docType]").addClass("w100p");
     }else{
          $("#docType").val("");
          $("select[name=docType]").attr('disabled', 'disabled');
          $("select[name=docType]").addClass("disabled");
          //$("select[name=docType]").addClass("w100p");
     }   

}
  
</script>
<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Guardian of Compliance New</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->


<article class="tap_area"><!-- tap_area start -->
<form action="#" method="post" id="saveForm">
<input type="hidden" title="" placeholder="" class="" id="memberId" name="memberId"/>
<input type="hidden" title="" placeholder="" class="" id="hidFileName" name="hidFileName"/>

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:110px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Case Category</th>
    <td colspan="3">
        <select class="w100p" id="caseCategory" name="caseCategory" onchange="fn_caseChange(this.value);">
	         <c:forEach var="list" items="${caseCategoryCodeList}" varStatus="status">
	             <option value="${list.codeId}">${list.codeName } </option>
	        </c:forEach> 
        </select>
    </td>
    <th scope="row">Types of Documents</th> 
    <td colspan="3">
    <select class="w100p disabled" disabled="disabled" id="docType" name="docType">
             <c:forEach var="list" items="${documentsCodeList}" varStatus="status">
                 <option value="${list.codeId}">${list.codeName } </option>
            </c:forEach>     
    </select>
    </td>
</tr>
<tr>
    <th scope="row">Customer Name</th>
    <td colspan="3">
    <input type="text" title="" placeholder="Customer Name" class="" id="customerName" name="customerName" value=""/>
    </td>
    <th scope="row">Order No</th>
    <td colspan="3">
        <input type="text" title="" placeholder="Order No" class="" id="salesOrdNo" name="salesOrdNo" value=""/>
    </td>
</tr>
<tr>
    <th scope="row">Customer Contact</th>
    <td colspan="3">
    <input type="text" title="" placeholder="Customer Contact" class="" id="reqstCntnt" name="reqstCntnt" value=""/>
    </td>
    <th scope="row">Complaint Date</th>
    <td colspan="3">
      <input type="text" title="Complaint Date" placeholder="DD/MM/YYYY" name="reqstRefDt" id="reqstRefDt" class="j_date"/>
    </td>
</tr>
<tr>
    <th scope="row">Involved Person Code</th>
    <td colspan="7">
    <input type="text" title="" placeholder="Involved Person Code" class="" id="reqstMemId" name="reqstMemId" value=""/>
    </td>
</tr>
<tr>
    <th scope="row">Complaint Content</th>
    <td colspan="7">
    <textarea cols="20" rows="5" placeholder="Complaint Content" id="complianceRem" name="complianceRem"></textarea>
    </td>
</tr>
</tbody>
</table><!-- table end -->
</form>

<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#" onClick="javascript:fn_uploadfile()">Upload Attachment</a></p></li>
    <li><p class="btn_blue2 big"><a href="#" onClick="javascript:fn_saveConfirm()">SAVE</a></p></li>
</ul>


</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->
 
</section><!-- pop_body end -->

</div><!-- popup_wrap end -->
