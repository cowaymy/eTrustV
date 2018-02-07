<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">

	//Choose Message
	var optionCountry = {chooseMessage: " Country "};
	var optionState = {chooseMessage: " 1.States "};
	var optionCity = {chooseMessage: "2. City"};
	var optionPostCode = {chooseMessage: "3. Post Code"};
	var optionArea = {chooseMessage: "4. Area"};

    doGetCombo('/common/selectCodeList.do', '17', '', 'cmbInitialTypeId', 'S' , '');                     // Initial Type Combo Box
    doGetCombo('/common/selectCodeList.do', '2', '', 'cmbRaceTypeId', 'S' , '');                        // Race Type Combo Box
    doGetCombo('/common/selectCodeList.do', '357', '2575','newDealerType', 'S' , '');    // Dealer Type Combo Box
    doGetCombo('/sales/pst/dealerBrnchJsonList', '','','dealerBranch', 'S' , '');                 // Branch Combo Box
    
    $(document).ready(function(){
    	CommonCombo.make('mCountry', "/sales/pst/pstDealerAddrComboList", '' , '', optionCountry);
    });
    
    // 조회조건 combo box
    function f_multiCombo(){
        $(function() {
            $('#newDealerType').change(function() {
            
            }).multipleSelect({
                selectAll: true, // 전체선택 
                width: '80%'
            });
        });
    }
 
    function fn_initAddress(){
        
    	$('#mState').append($('<option>', { value: '', text: '1. State' }));
        $('#mState').val('');
        $("#mState").attr({"disabled" : "disabled"  , "class" : "w100p disabled"});
        
        $('#mCity').append($('<option>', { value: '', text: '2. City' }));
        $('#mCity').val('');
        $("#mCity").attr({"disabled" : "disabled"  , "class" : "w100p disabled"});
        
        $('#mPostCd').append($('<option>', { value: '', text: '3. Post Code' }));
        $('#mPostCd').val('');
        $("#mPostCd").attr({"disabled" : "disabled"  , "class" : "w100p disabled"});
        
        $('#mArea').append($('<option>', { value: '', text: '4. Area' }));
        $('#mArea').val('');
        $("#mArea").attr({"disabled" : "disabled"  , "class" : "w100p disabled"});
        
	 }
	 
	 /*####### Dealer Magic Address #########*/
	 function fn_selectCountry(selVal){
         
         var tempVal = selVal;
         
         if('' == selVal || null == selVal){
             //전체 초기화
             fn_initAddress();   
             
         }else{
             
             $("#mState").attr({"disabled" : false  , "class" : "w100p"});
             
             $('#mCity').append($('<option>', { value: '', text: '3. Post Code' }));
             $('#mCity').val('');
             $("#mCity").attr({"disabled" : "disabled"  , "class" : "w100p disabled"});
             
             $('#mPostCd').append($('<option>', { value: '', text: '3. Post Code' }));
             $('#mPostCd').val('');
             $("#mPostCd").attr({"disabled" : "disabled"  , "class" : "w100p disabled"});
             
             $('#mArea').append($('<option>', { value: '', text: '4. Area' }));
             $('#mArea').val('');
             $("#mArea").attr({"disabled" : "disabled"  , "class" : "w100p disabled"});
             
             //Call ajax
             var stateJson = {country : tempVal}; //Condition
             CommonCombo.make('mState', "/sales/pst/pstDealerAddrComboList", stateJson, '' , optionState);
         }
         
     }
	 
	 function fn_selectState(selVal){
	     
	     var tempVal = selVal;
	     
	     if('' == selVal || null == selVal){
	         //전체 초기화
	         fn_initAddress();   
	         
	     }else{
	         
	         $("#mCity").attr({"disabled" : false  , "class" : "w100p"});
	         
	         $('#mPostCd').append($('<option>', { value: '', text: '3. Post Code' }));
	         $('#mPostCd').val('');
	         $("#mPostCd").attr({"disabled" : "disabled"  , "class" : "w100p disabled"});
	         
	         $('#mArea').append($('<option>', { value: '', text: '4. Area' }));
	         $('#mArea').val('');
	         $("#mArea").attr({"disabled" : "disabled"  , "class" : "w100p disabled"});
	         
	         //Call ajax
	         var cityJson = {country : $("#mCountry").val(), state : tempVal}; //Condition
	         CommonCombo.make('mCity', "/sales/pst/pstDealerAddrComboList", cityJson, '' , optionCity);
	     }
	     
	 }
	 
	 function fn_selectCity(selVal){
	     
	     var tempVal = selVal;
	     
	     if('' == selVal || null == selVal){
	        
	          $('#mPostCd').append($('<option>', { value: '', text: '3. Post Code' }));
	          $('#mPostCd').val('');
	          $("#mPostCd").attr({"disabled" : "disabled"  , "class" : "w100p disabled"});
	         
	          $('#mArea').append($('<option>', { value: '', text: '4. Area' }));
	          $('#mArea').val('');
	          $("#mArea").attr({"disabled" : "disabled"  , "class" : "w100p disabled"});
	         
	     }else{
	         
	         $("#mPostCd").attr({"disabled" : false  , "class" : "w100p"});
	         
	         $('#mArea').append($('<option>', { value: '', text: '4. Area' }));
	         $('#mArea').val('');
	         $("#mArea").attr({"disabled" : "disabled"  , "class" : "w100p disabled"});
	         
	         //Call ajax
	         var postCodeJson = {country : $("#mCountry").val(), state : $("#mState").val() , city : tempVal}; //Condition
	         CommonCombo.make('mPostCd', "/sales/pst/pstDealerAddrComboList", postCodeJson, '' , optionPostCode);
	     }
	     
	 }
	 
	 
	 function fn_selectPostCode(selVal){
	     
	     var tempVal = selVal;
	     
	     if('' == selVal || null == selVal){
	        
	         $('#mArea').append($('<option>', { value: '', text: '4. Area' }));
	         $('#mArea').val('');
	         $("#mArea").attr({"disabled" : "disabled"  , "class" : "w100p disabled"});
	         
	     }else{
	         
	         $("#mArea").attr({"disabled" : false  , "class" : "w100p"});
	         
	         //Call ajax
	         var areaJson = {country : $("#mCountry").val(), state : $("#mState").val(), city : $("#mCity").val() , postcode : tempVal}; //Condition
	         CommonCombo.make('mArea', "/sales/pst/pstDealerAddrComboList", areaJson, '' , optionArea);
	     }
	     
	 }
	 
	//Get Area Id
	    function fn_getAreaId(){
	        
	    	var countryValue = $("#mCountry").val();
	        var statValue = $("#mState").val();
	        var cityValue = $("#mCity").val();
	        var postCodeValue = $("#mPostCd").val();
	        var areaValue = $("#mArea").val();
	        
	        
	        
	        if('' != countryValue && '' != statValue && '' != cityValue && '' != postCodeValue && '' != areaValue){
	            
	            var jsonObj = { countryValue : countryValue ,
	            		              statValue : statValue ,
	                                  cityValue : cityValue,
	                                  postCodeValue : postCodeValue,
	                                  areaValue : areaValue
	                                };
	            Common.ajax("GET", "/sales/pst/getDealerAreaId.do", jsonObj, function(result) {
	                
	                 $("#areaId").val(result.areaId);
	                
	            });
	        }
	    }
//	 function fn_addrSearch(){
//	        if($("#searchSt").val() == ''){
//	            Common.alert("Please search.");
//	            return false;
//	        }
//	        Common.popupDiv('/sales/customer/searchMagicAddressPop.do' , $('#insAddressForm').serializeJSON(), null , true, '_searchDiv'); //searchSt
//	    }

    function fn_newDealerConfirm(){
    	if(newForm.dealerName.value==""){
    		Common.alert('<spring:message code="sal.alert.msg.plzKeyInDealerName" />');
    		return false;
    	}
    	if(newForm.newDealerType.value==""){
            Common.alert('<spring:message code="sal.alert.msg.plzKeyInDealerName" />');
            return false;
        }
    	if(newForm.dealerNric.value==""){
            Common.alert('<spring:message code="sal.alert.msg.plzKeyinNricCompNum" />');
            return false;
        }
    	if(newForm.dealerBranch.value==""){
            Common.alert('<spring:message code="sal.alert.msg.selectBranch" />');
            return false;
        }
    	if(newForm.addrDtl.value==""){
            Common.alert('<spring:message code="sal.alert.msg.plzKeyinAddr" />');
            return false;
        }
    	if(newForm.mCountry.value==""){
            Common.alert('<spring:message code="sal.alert.msg.plzSelTheCountry" />');
            return false;
        }
    	if(newForm.cmbRaceTypeId.value==""){
            Common.alert('<spring:message code="sal.alert.msg.plzSelCntcPersonRace" />');
            return false;
        }
    	if(newForm.cntcName.value==""){
            Common.alert('<spring:message code="sal.alert.msg.plzKeyInCntcPersonName" />');
            return false;
        }
    	if(newForm.cmbInitialTypeId.value==""){
            Common.alert('<spring:message code="sal.alert.msg.plzSelCntcPersonInitial" />');
            return false;
        }
    	if(newForm.cntcTelm1.value==""){
            Common.alert('<spring:message code="sal.alert.msg.plzKeyinAtLeastOneConNum" />');
            return false;
        }
    	if(newForm.userName.value==""){
            Common.alert('<spring:message code="sal.alert.msg.plzKeyInUserName" />');
            return false;
        }
    	if(newForm.userPw.value==""){
            Common.alert('<spring:message code="sal.alert.msg.plzKeyInPassword" />');
            return false;
        }
    	if(newForm.userRePw.value==""){
            Common.alert('<spring:message code="sal.alert.msg.plzKeyInreTypePassword" />');
            return false;
        }
    	
    	Common.ajax("GET", "/sales/pst/newDealer.do", $("#newForm").serializeJSON(), function(result) {
            Common.alert('<spring:message code="sal.alert.msg.newDealerSuccessfullySaved" />' , fn_winClose);

        }, function(jqXHR, textStatus, errorThrown) {
            Common.alert("실패하였습니다.");
            console.log("실패하였습니다.");
            console.log("error : " + jqXHR + " \n " + textStatus + "\n" + errorThrown);
            
            alert(jqXHR.responseJSON.message);
            console.log("jqXHR.responseJSON.message" + jqXHR.responseJSON.message);
            
        });
    }
    
    function fn_winClose(){
    	$("#newDealerClose").click();
    	fn_pstDealerListAjax();
    }
</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="sal.alert.msg.newPstDealer" /></h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#" id="newDealerClose"><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<ul class="right_btns">
    <li><p class="red_text"><spring:message code="sal.title.text.compulsoryField" /></p></li>
</ul>
<form id="newForm" name="newForm" method="get">
<input type="hidden" id="areaId" name="areaId">
<section class="tap_wrap mt0"><!-- tap_wrap start -->
<ul class="tap_type1">
    <li><a href="#" class="on"><spring:message code="sal.tap.title.basicInfo" /></a></li>
    <li><a href="#"><spring:message code="sal.tap.title.mainAddr" /></a></li>
    <li><a href="#"><spring:message code="sal.tap.title.mainContact" /></a></li>
    <li><a href="#"><spring:message code="sal.title.text.userInfo" /></a></li>
</ul>

<article class="tap_area"><!-- tap_area start -->

<section class="search_table"><!-- search_table start -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:180px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sal.title.text.dealerName" /><span class="must">*</span></th>
    <td><input type="text" id="dealerName" name="dealerName" title="" placeholder="" class="w100p" /></td>
    <th scope="row"><spring:message code="sal.title.text.nricCompNo" /><span class="must">*</span></th>
    <td><input type="text" id="dealerNric" name="dealerNric" title="" placeholder="" class="w100p" /></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.email" /></th>
    <td><input type="text" id="dealerEmail" name="dealerEmail" title="" placeholder="" class="w100p" /></td>
    <th scope="row"><spring:message code="sal.text.branch" /><span class="must">*</span></th>
    <td>
	    <select class="w100p" id="dealerBranch" name="dealerBranch">
	    </select>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.dealerType" /><span class="must">*</span></th>
    <td>
        <select class="w100p" id="newDealerType" name="newDealerType">
        </select>
    </td>
    <th scope="row"></th>
    <td></td>
</tr>
</tbody>
</table><!-- table end -->

</section><!-- search_table end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<section class="search_table"><!-- search_table start -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:180px" />
    <col style="width:*" />
</colgroup>
    <tbody>
<!-- 	       <tr>
	           <th scope="row">Area search<span class="must">*</span></th>
	           <td colspan="3">
	           <input type="text" title="" id="searchSt" name="searchSt" placeholder="" class="" /><a href="#" onclick="fn_addrSearch()" class="search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
	           </td>
	       </tr> -->
	       <tr>
	           <th scope="row" ><spring:message code="sal.text.addressDetail" /><span class="must">*</span></th>
	           <td colspan="3">
	           <input type="text" title="" id="addrDtl" name="addrDtl" placeholder="Detail Address" class="w100p"  />
	           </td>
	       </tr>
	       <tr>
	           <th scope="row" ><spring:message code="sal.text.street" /></th>
	           <td colspan="3">
	           <input type="text" title="" id="streetDtl" name="streetDtl" placeholder="Detail Address" class="w100p"  />
	           </td>
	       </tr>
	       <tr>
	          <th scope="row"><spring:message code="sal.text.area4" /><span class="must">*</span></th>
	           <td colspan="3">
	           <select class="w100p" id="mArea"  name="mArea" onchange="javascript : fn_getAreaId()"></select> 
	           </td>
	       </tr>
	       <tr>
	            <th scope="row"><spring:message code="sal.text.city2" /><span class="must">*</span></th>
	           <td>
	           <select class="w100p" id="mCity"  name="mCity" onchange="javascript : fn_selectCity(this.value)"></select>  
	           </td>
	           <th scope="row"><spring:message code="sal.text.postCode3" /><span class="must">*</span></th>
	           <td>
	           <select class="w100p" id="mPostCd"  name="mPostCd" onchange="javascript : fn_selectPostCode(this.value)"></select>
	           </td>
	       </tr>
	       <tr>
	           <th scope="row"><spring:message code="sal.text.state1" /><span class="must">*</span></th>
	           <td>
	           <select class="w100p" id="mState"  name="mState" onchange="javascript : fn_selectState(this.value)"></select>
	           </td>
	           <th scope="row"><spring:message code="sal.text.country" /><span class="must">*</span></th>
	           <td>
	           <select class="w100p" id="mCountry"  name="mCountry" onchange="javascript : fn_selectCountry(this.value)"></select>
	           </td>
	       </tr>
	       <tr>
	           <th scope="row"><spring:message code="sal.text.remarks" /></th>
	           <td colspan="3">
	           <textarea cols="20" rows="5" id="addrRem" name="addrRem" placeholder="Remark"></textarea>
	           </td>
	       </tr>
	   </tbody>
    </table><!-- table end -->

</section><!-- search_table end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<section class="search_table"><!-- search_table start -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:180px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sal.text.initial" /><span class="must">*</span></th>
    <td>
	    <select class="w100p" id="cmbInitialTypeId" name="cmbInitialTypeId">
	    </select>
    </td>
    <th scope="row"><spring:message code="sal.text.gender" /><span class="must">*</span></th>
    <td>
    <label><input type="radio" name="cntcGender" value="M" checked/><span><spring:message code="sal.title.text.male" /></span></label>
    <label><input type="radio" name="cntcGender" value="F" /><span><spring:message code="sal.title.text.female" /></span></label>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.contactName" /><span class="must">*</span></th>
    <td><input type="text" id="cntcName" name="cntcName" title="" placeholder="" class="w100p" /></td>
    <th scope="row"><spring:message code="sal.text.race" /><span class="must">*</span></th>
    <td>
	    <select class="w100p" id="cmbRaceTypeId" name="cmbRaceTypeId">
	    </select>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.nric" /></th>
    <td><input type="text" title="" id="cntcNric" name="cntcNric" placeholder="" class="w100p" /></td>
    <th scope="row"><spring:message code="sal.title.text.telMobile1" /><span class="must">*</span></th>
    <td><input type="text" title="" id="cntcTelm1" name="cntcTelm1" placeholder="" class="w100p" /></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.telMobile2" /></th>
    <td><input type="text" title="" id="cntcTelm2" name="cntcTelm2" placeholder="" class="w100p" /></td>
    <th scope="row"><spring:message code="sal.text.telO" /></th>
    <td><input type="text" title="" id="cntcTelo" name="cntcTelo" placeholder="" class="w100p" /></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.telR" /></th>
    <td><input type="text" title="" id="cntcTelr" name="cntcTelr" placeholder="" class="w100p" /></td>
    <th scope="row"><spring:message code="sal.text.telF" /></th>
    <td><input type="text" title="" id="cntcTelf" name="cntcTelf" placeholder="" class="w100p" /></td>
</tr>
</tbody>
</table><!-- table end -->


</section><!-- search_table end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<section class="search_table"><!-- search_table start -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sal.title.text.userName" /><span class="must">*</span></th>
    <td><input type="text" title="" id="userName" name="userName" placeholder="" class="" /></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.password" /><span class="must">*</span></th>
    <td><input type="text" title="" id="userPw" name="userPw" placeholder="" class="" /></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.reTypePassword" /><span class="must">*</span></th>
    <td><input type="text" id="userRePw" name="userRePw" title="" placeholder="" class="" /></td>
</tr>
</tbody>
</table><!-- table end -->

</section><!-- search_table end -->

</article><!-- tap_area end -->

</section><!-- tap_wrap end -->
</form>
<ul class="center_btns mt20">
    <li><p class="btn_blue2 big"><a href="#" onclick="fn_newDealerConfirm()"><spring:message code="sal.btn.save" /></a></p></li>
</ul>

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->