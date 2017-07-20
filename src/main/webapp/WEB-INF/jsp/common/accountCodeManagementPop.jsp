<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<script type="text/javaScript">

$(function()
{
  //doGetCombo('/common/selectCodeList.do',            '11',        '','cmbCategory', 'A' , ''); //Single COMBO => ALL

  doGetComboAddr('/common/selectAddrSelCodeList.do'  // url
		              , 'country'  // code 
		              , ''         // value
			            , ''         // selectedItem
			            , 'mcountry' // setting-Object
			            , 'S'        // single Type ComboBox
			            , ''         // callBack Function
		            );
  
});

function fnSaveAccount() 
{

	  var flag = "INSERT";

	
	  if (flag == "INSERT")
		{
		  Common.ajax("POST", "/common/insertAccount.do"  
				      , $("#PopUpForm").serializeJSON({checkboxUncheckedValue: "false"})  // post 시 serializeJSON
			        , function(result) 
			         {
			            alert(result.data + " Count Save Success!");
			            console.log("성공." + JSON.stringify(result));
			            console.log("data : " + result.data);
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
			            console.log(e);
			          }
			          alert("Fail : " + jqXHR.responseJSON.message);
			        }); 			
		}
  
}


</script>

<div id="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Account Code Management - <c:choose>
                                <c:when test = "${inputParams.parmAddEditFlag eq 'ADD' }" >
                                  ADD Account Code
                                </c:when>                              
                                <c:otherwise>
                                  EDIT Account Code
                                </c:otherwise>
                              </c:choose>
</h1>
<ul class="right_opt">
	<li><p class="btn_blue2"><a href="javascript:;" >CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->
<form id="PopUpForm" name="PopUpForm" method="" action="">
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
	<input type="text" title="" id="popUpAccCode" name="popUpAccCode"  placeholder='${inputParams.paramAccCode}' class="w100p" />
	</td>
	<th scope="row">SAP CODE</th>
	<td>
	<input type="text" title="SAP CODE" id="popUpSapAccCode" name="popUpSapAccCode" placeholder='${inputParams.paramSapAccCode}' class="w100p" />
	</td>
</tr>
<tr>
	<th scope="row">Account Description<span class="must">*</span></th>
	<td colspan="3">
	<input type="text" id="popUpAccDesc" name="popUpAccDesc" title="" placeholder='${inputParams.paramAccDesc}' class="w100p" />
	</td>
</tr>
<tr>
	<th scope="row">Payment Account</th>
	<td colspan="3">  
	  <label><input type="checkbox" id="popUpIsPayCash" name="popUpIsPayCash" <c:if test="${inputParams.parmIsPayCash eq '1' }"> checked </c:if> /><span>Cash</span></label>
		<label><input type="checkbox" id="popUpIsPayChq" name="popUpIsPayChq" <c:if test="${inputParams.parmIsPayChq  eq '1' }"> checked </c:if> /><span>Cheque</span></label>
		<label><input type="checkbox" id="popUpIsPayOnline" name="popUpIsPayOnline" <c:if test="${inputParams.parmIsPayOnline eq '1' }"> checked </c:if> /><span>Online</span></label>
		<label><input type="checkbox" id="popUpIsPayCrc" name="popUpIsPayCrc" <c:if test="${inputParams.parmIsPayCrc    eq '1' }"> checked </c:if> /><span>Credit Card</span></label>
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
	 <select id="mcountry" name="mcountry" class="w100p" onchange="getAddrRelay('mstate' , this.value , 'state', '')"></select>
	</td>
	<th scope="row">State</th>
	<td>
	 <select id="mstate" name="mstate" class="w100p" onchange="getAddrRelay('marea' , this.value , 'area', this.value)" disabled=true><option>Choose One</option></select>
	</td> 
	
</tr>
<tr>
	<th scope="row">Area</th>
	<td>
	 <select id="marea" name="marea" class="w100p" onchange="getAddrRelay('mpostcd' , this.value , 'post', this.value)" disabled=true><option>Choose One</option></select>
	</td>
	<th scope="row">Postcode</th>
	<td>
    <select id="mpostcd" name="mpostcd"  class="w100p" disabled=true><option>Choose One</option></select>
	</td>
</tr>
<tr>
	<th scope="row">Tel(1)</th>
	<td>
	<input type="text" id="tel1" name="tel1" title="" placeholder="Tel(1)" class="w100p" />
	</td>
	<th scope="row">Tel(2)</th>
	<td>
	<input type="text" id="tel2" name="tel2" title="" placeholder="Tel(2)" class="w100p" />
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
