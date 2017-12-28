<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">

$(function()
{
  var cntyId = "${inputParams.parmAddCntyId}";
  var areaId = "${inputParams.paramAddAreaId}";
  var stateId = "${inputParams.paramAddStateId}";
  var postId  = "${inputParams.pramAddPostCodeId}";

  console.log("parmAddCntyId: " + cntyId +" paramAddStateId: " + stateId + " paramAddAreaId: " + areaId +" pramAddPostCodeId: " + postId )
      
  $(document).ready(function() {
	  doGetCombo('/common/selectCountryList.do', '', '','mcountry' , 'S', '');

  })
 
  $("#mcountry").change(function() {
	  doGetCombo('/common/selectStateList.do', cntyId, '' ,'mstate', 'S', '');
  });
  
  $("#mstate").change(function() {
	  doGetCombo('/common/selectAreaList.do', stateId, '' ,'marea', 'S', '');
  });
  
  $("marea").change(function() {
	  doGetCombo('/common/selectPostCdList.do', areaId, '', 'mpostcd', 'S', '');
  });
  

  /*if (cntyId != "" && cntyId != undefined)
  {
    getAddrRelay('mstate' , cntyId , 'state' , stateId);
  }

  if (stateId != "" && stateId != undefined)
  {
      getAddrRelay('marea' , stateId , 'area' , areaId);
  }

  if (areaId != "" && areaId != undefined){
      getAddrRelay('mpostcd' , areaId , 'post', postId);
  }*/

  
});

function fnSaveAccount() 
{
   var countryVal = $("#mcountry option:selected").val();

   if (countryVal == 1)
   {
     if ( parseInt($("#mstate option").index($("#mstate option:selected")))  == 0)
       {           
         Common.alert("<spring:message code='sys.msg.necessary' arguments='state' htmlEscape='false'/>");
         return false;
       }
       
       if (parseInt($("#marea option").index($("#marea option:selected")))  == 0)
       {
           Common.alert("<spring:message code='sys.msg.necessary' arguments='area' htmlEscape='false'/>");
           return false;
       }

       if (parseInt($("#mpostcd option").index($("#mpostcd option:selected"))) == 0)
       {
           Common.alert("<spring:message code='sys.msg.necessary' arguments='postcode' htmlEscape='false'/>");
           return false;
       }
   }


   if ($("#popUpAccCode").val().length == 0)
   {
     Common.alert("<spring:message code='sys.msg.necessary' arguments='Account Code' htmlEscape='false'/>");
     return false;
   }
   
   if ($("#popUpAccDesc").val().length == 0)
   {
     Common.alert("<spring:message code='sys.msg.necessary' arguments='Account Description' htmlEscape='false'/>");
     return false;
   }

    Common.ajax("POST", "/account/insertAccount.do"  
            , $("#PopUpForm").serializeJSON({checkboxUncheckedValue: "false"})  // post 시 serializeJSON
            , function(result) 
             {
                if(result.code == 99){
                  Common.alert(result.message);
                }else{
                  Common.alert(result.data + "<spring:message code='sys.msg.savedCnt'/>");
                  console.log("성공." + JSON.stringify(result));
                  console.log("data : " + result.data);
                  fnGetAccountCdListAjax();                 
                }
             } 
           , function(jqXHR, textStatus, errorThrown) 
            {
              try 
              {
                console.log("Fail Status : " + jqXHR.status);
                console.log("code : "        + jqXHR.responseJSON.code);
                console.log("message : "     + jqXHR.responseJSON.message);
                console.log("detailMessage : "  + jqXHR.responseJSON.detailMessage);
              } 
              catch (e) 
              {
                console.log("error: " + e);
              }
              Common.alert("Fail : " + jqXHR.responseJSON.message);
            });

}

 function fn_close(){
	 $("#accountCodeManagementPop").remove(); // hide();
}


</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->
<header class="pop_header"><!-- pop_header start -->
<h1>Account Code Management - <c:choose>  
                                <c:when test = "${inputParams.parmAddEditFlag eq 'EDIT' }" >
                                  EDIT Account Code
                                </c:when>                              
                                <c:otherwise>
                                  ADD Account Code
                                </c:otherwise>
                              </c:choose>
</h1>
<ul class="right_opt">
  <li><p class="btn_blue2"><a href="javascript:fn_close();" >CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->
<form id="PopUpForm" name="PopUpForm" method="" action="">

<input type ="hidden" id="popUpAccCodeId"  name="popUpAccCodeId"  value='${inputParams.paramAccCodeId}'/>
<input type ="hidden" id="popUpSaveFlag"  name="popUpSaveFlag"  value='${inputParams.parmAddEditFlag}'/>

<section class="pop_body"><!-- pop_body start -->

<aside class="title_line"><!-- title_line start -->
<h2>Account Information</h2>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
  <col style="width:180px" />
  <col style="width:*" />
  <col style="width:180px" />
  <col style="width:*" />
</colgroup>
<tbody>
<tr>  
  <th scope="row">Account Code<span class="must">*</span></th>
  <td>
  <input type="text" title="" id="popUpAccCode" name="popUpAccCode"  class="w100p" value='${inputParams.paramAccCode}'  placeholder='9999/999' maxlength="12"
          <c:if test="${inputParams.parmAddEditFlag eq 'EDIT' }"> disabled </c:if>  />
  </td>
  <th scope="row">SAP CODE</th>
  <td>
  <input type="text" title="SAP CODE" id="popUpSapAccCode" name="popUpSapAccCode" value='${inputParams.paramSapAccCode}' placeholder='Sap code' class="w100p" maxlength="50" />
  </td>
</tr>
<tr>
  <th scope="row">Account Description<span class="must"></span></th>
  <td colspan="3">
  <input type="text" id="popUpAccDesc" name="popUpAccDesc" title="" value='${inputParams.paramAccDesc}' class="w100p" placeholder='Account description' maxlength="70" />
  </td>
</tr>
<tr>
  <th scope="row">Payment Account</th>
  <td colspan="3">  
    <label><input type="checkbox" id="popUpIsPayCash" name="popUpIsPayCash" <c:if test="${inputParams.parmIsPayCash eq '1' }"> checked </c:if> /><span>Cash</span></label>
    <label><input type="checkbox" id="popUpIsPayChq"  name="popUpIsPayChq" <c:if test="${inputParams.parmIsPayChq  eq '1' }"> checked </c:if> /><span>Cheque</span></label>
    <label><input type="checkbox" id="popUpIsPayOnline" name="popUpIsPayOnline" <c:if test="${inputParams.parmIsPayOnline eq '1' }"> checked </c:if> /><span>Online</span></label>
    <label><input type="checkbox" id="popUpIsPayCrc"    name="popUpIsPayCrc" <c:if test="${inputParams.parmIsPayCrc    eq '1' }"> checked </c:if> /><span>Credit Card</span></label>
  </td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h2>Account Location Information</h2>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
  <col style="width:180px" />
  <col style="width:*" />
  <col style="width:180px" />
  <col style="width:*" />
</colgroup>
<tbody>
<tr>
  <th scope="row" rowspan="3">Address</th>
  <td colspan="3">
  <input type="text" id="address1" name="address1" title="" placeholder="Address(1)" class="w100p" /> 
  </td>
</tr>
<tr>
  <td colspan="3">
  <input type="text" id="address2" name="address2" title="" placeholder="Address(2)" class="w100p" />
  </td>
</tr>
<tr>
  <td colspan="3">
  <input type="text" id="address3" name="address3" title="" placeholder="Address(3)" class="w100p" />
  </td>
</tr>

<tr>
  <th scope="row">Country</th>
  <td>
   <!-- <select id="mcountry" name="mcountry" onchange="getAddrRelay('mstate' , this.value , 'state', '')"></select> -->
   <select id="mcountry" name= "mcountry"></select>
  </td>
  <th scope="row">State</th>
  <td>
   <!-- <select id="mstate" name="mstate" class="msap" onchange="getAddrRelay('marea' , this.value , 'area', this.value)" disabled=true><option>Choose One</option></select> -->
   <select id="mstate" name = "mstate"></select>
  </td> 
  
</tr>
<tr>
  <th scope="row">Area</th>
  <td>
  <!-- <select id="marea" name="marea" class="msap" onchange="getAddrRelay('mpostcd' , this.value , 'post', this.value)" disabled=true><option>Choose One</option></select> -->
   <select id="marea" name="marea"></select>
  </td>
  <th scope="row">Postcode</th>
  <td>
    <!-- <select id="mpostcd" name="mpostcd"  class="msap" disabled=true><option>Choose One</option></select>  -->
    <select id="mpostcd" name="mpostcd"></select>
  </td>
</tr>
<tr>
  <th scope="row">Tel(1)</th>
  <td>
  <input type="text" id="tel1" name="tel1" title="" placeholder="Tel(1)" class="w100p" maxlength="12" />
  </td>
  <th scope="row">Tel(2)</th>
  <td>
  <input type="text" id="tel2" name="tel2" title="" placeholder="Tel(2)" class="w100p" maxlength="12" />
  </td>
</tr>
</tbody>
</table><!-- table end -->

<ul class="center_btns">
     <li><p class="btn_blue2 big"><a onclick="fnSaveAccount();">SAVE</a></p></li>
</ul>

</section><!-- pop_body end -->

</form>

</div><!-- popup_wrap end -->
