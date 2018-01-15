<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>


<script type="text/javaScript">
//Choose Message
  var optionState = {chooseMessage: " 1.States "};
  var optionCity = {chooseMessage: "2. City"};
  var optionPostCode = {chooseMessage: "3. Post Code"};
  var optionArea = {chooseMessage: "4. Area"};
        
    
    
   function fn_updateInitField(tempState, tempCity , tempPostCode , tempArea){
       
       //State
        if( '' != tempState && null != tempState){
            
            CommonCombo.make('mState', "/sales/customer/selectMagicAddressComboList", '' , tempState, optionState);
        }else{
            
            CommonCombo.make('mState', "/sales/customer/selectMagicAddressComboList", '' , '', optionState);
            fn_selectState('');
            return;
            
        }
        
       //City
        var cityJson = {state : tempState}; //Condition
        if('' != tempCity && null != tempCity){
           
            CommonCombo.make('mCity', "/sales/customer/selectMagicAddressComboList", cityJson, tempCity , optionCity);
            
        }else{
            CommonCombo.make('mCity', "/sales/customer/selectMagicAddressComboList", cityJson, '' , optionCity);
          
            fn_selectCity('');
            return;
        }
        
        //PostCode
        var postCodeJson = {state : tempState , city : tempCity}; //Condition
        if('' != tempPostCode && null != tempPostCode){
            
            CommonCombo.make('mPostCd', "/sales/customer/selectMagicAddressComboList", postCodeJson, tempPostCode , optionPostCode);
            
        }else{
            CommonCombo.make('mPostCd', "/sales/customer/selectMagicAddressComboList", postCodeJson, '' , optionPostCode);
           
            fn_selectPostCode('');
            return;
        }
        
        //Area
        var areaJson = {state : tempState, city : tempCity , postcode : tempPostCode}; //Condition
        if('' != tempArea && null != tempArea){
            CommonCombo.make('mArea', "/sales/customer/selectMagicAddressComboList", areaJson, tempArea , optionArea);
           
        }else{
            CommonCombo.make('mArea', "/sales/customer/selectMagicAddressComboList", areaJson, '' , optionArea);
           
            return;
        }
        
    }
           
        //doGetCombo('/common/selectCodeList.do', '45', '','branchType', 'S' , ''); //branchType
         
        //Start AUIGrid
        $(document).ready(function() {
        	
        	 var branchId = "${branchDetail.typeId}";
             $("#branchType option[value='"+ branchId +"']").attr("selected", true);
             var codeId= $("#regionValue").val();
             CommonCombo.make('cmRegion', "/common/selectCodeList.do", '49' , codeId, '');
	         var tempState = $("#getState").val();
	         var tempCity = $("#getCity").val();
	         var tempPostCode = $("#getPostCode").val();
	         var tempArea = $("#getArea").val();
	         
	         fn_updateInitField(tempState, tempCity , tempPostCode , tempArea);
        });
        
        
        
        //Update
        function fn_branchSave() {

            if (validRequiredField()){
            	$("select[name=branchType]").removeAttr("disabled");
                Common.ajax("GET","/organization/branchListUpdate.do", $("#branchForm").serialize(), function(result){
                    console.log(result);
                    Common.alert("Branch Save successfully.",fn_close);
                });
            
            }

        }

     function fn_close(){
         $("#popup_wrap").remove();
         fn_getBranchListAjax();
     }
    function  validRequiredField() {
    	/* if($("#branchCd").val() == ''){
        Common.alert("Please key  in Branch Code");
        return false;
    } */
    if($("#branchName").val() == ''){
        Common.alert("Please key  in Branch Name");
        return false;
    }
    if($("#cmRegion").val() == ''){
        Common.alert("Please key  in Region");
        return false;
    }
    
    if($("#addrDtl").val() == ''){
        Common.alert("Please key in the address.");
        return false;
    }
    
    if($("#mArea").val() == ''){
            Common.alert("Please key in the area.");
            return false;
    }
    
    if($("#mCity").val() == ''){
        Common.alert("Please key in the city.");
        return false;
    }
    
    if($("#mPostCd").val() == ''){
        Common.alert("Please key in the postcode.");
        return false;
    }
    
    if($("#mState").val() == ''){
        Common.alert("Please key in the state.");
        return false;
    }
    return true;
    }

    
    
    function fn_addrSearch(){
        if($("#searchSt").val() == ''){
            Common.alert("Please search.");
            return false;
        }
        Common.popupDiv('/sales/customer/searchMagicAddressPop.do' , $('#branchForm').serializeJSON(), null , true, '_searchDiv'); //searchSt
    }
    function fn_addMaddr(marea, mcity, mpostcode, mstate, areaid, miso){
        
        if(marea != "" && mpostcode != "" && mcity != "" && mstate != "" && areaid != "" && miso != ""){
            
            $("#mArea").attr({"disabled" : false  , "class" : "w100p"});
            $("#mCity").attr({"disabled" : false  , "class" : "w100p"});
            $("#mPostCd").attr({"disabled" : false  , "class" : "w100p"});
            $("#mState").attr({"disabled" : false  , "class" : "w100p"});
            
            //Call Ajax
           
            CommonCombo.make('mState', "/sales/customer/selectMagicAddressComboList", '' , mstate, optionState);
            
            var cityJson = {state : mstate}; //Condition
            CommonCombo.make('mCity', "/sales/customer/selectMagicAddressComboList", cityJson, mcity , optionCity);
            
            var postCodeJson = {state : mstate , city : mcity}; //Condition
            CommonCombo.make('mPostCd', "/sales/customer/selectMagicAddressComboList", postCodeJson, mpostcode , optionCity);
            
            var areaJson = {groupCode : mpostcode};
            var areaJson = {state : mstate , city : mcity , postcode : mpostcode}; //Condition
            CommonCombo.make('mArea', "/sales/customer/selectMagicAddressComboList", areaJson, marea , optionArea);
            
            $("#areaId").val(areaid);
            $("#_searchDiv").remove();
        }else{
            Common.alert("Please check your address.");
        }
    }
    //Get Area Id
    function fn_getAreaId(){
        
        var statValue = $("#mState").val();
        var cityValue = $("#mCity").val();
        var postCodeValue = $("#mPostCd").val();
        var areaValue = $("#mArea").val();
        
        
        
        if('' != statValue && '' != cityValue && '' != postCodeValue && '' != areaValue){
            
            var jsonObj = { statValue : statValue ,
                                  cityValue : cityValue,
                                  postCodeValue : postCodeValue,
                                  areaValue : areaValue
                                };
            Common.ajax("GET", "/sales/customer/getAreaId.do", jsonObj, function(result) {
                
                 $("#areaId").val(result.areaId);
                
            });
            
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
            var postCodeJson = {state : $("#mState").val() , city : tempVal}; //Condition
            CommonCombo.make('mPostCd', "/sales/customer/selectMagicAddressComboList", postCodeJson, '' , optionPostCode);
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
            var areaJson = {state : $("#mState").val(), city : $("#mCity").val() , postcode : tempVal}; //Condition
            CommonCombo.make('mArea', "/sales/customer/selectMagicAddressComboList", areaJson, '' , optionArea);
        }
        
    }

    function fn_initAddress(){
        
        $("#mPostCd").attr({"disabled" : "disabled"  , "class" : "w100p disabled"});
        $("#mPostCd").val('');
        
        $("#mCity").attr({"disabled" : "disabled"  , "class" : "w100p disabled"});
        $("#mCity").val('');
        
        $("#mArea").attr({"disabled" : "disabled"  , "class" : "w100p disabled"});
        $("#mArea").val('');
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
            var cityJson = {state : tempVal}; //Condition
            CommonCombo.make('mCity', "/sales/customer/selectMagicAddressComboList", cityJson, '' , optionCity);
        }
        
    }

    </script>
    
    

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Branch Management - Edit Branch</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<form id="branchForm" name="branchForm">    
<input type="hidden" id ="areaId" name="areaId" value= "${branchDetail.c1}" />
<input type="hidden" id="getState"  value="${branchAddr.state}">
<input type="hidden" id="getCity"  value="${branchAddr.city}">
<input type="hidden" id="getPostCode"  value="${branchAddr.postcode}">
<input type="hidden" id="getArea"  value="${branchAddr.area}">
<input type="hidden" id ='branchNo' name='branchNo'  value= "${branchDetail.brnchId}"/>
<input type="hidden" id ="regionValue" name="regionValue" value= "${branchDetail.regnId}"/>
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
    <th scope="row">Branch Type<span class="must">*</span></th>
    <td>
    <select id="branchType" name="branchType" class="w100p" disabled="true">
        <%-- <option value="${branchDetail.typeId}"  selected></option> --%>
           <c:forEach var="list" items="${branchType }" varStatus="status">
           <option value="${list.branchId}">${list.c1}</option>
           </c:forEach>
    </select>
    </td>
    <th scope="row">Branch Code<span class="must">*</span></th>
    <td>
    <%-- <input id="branchCd" name="branchCd" type="text" title="" placeholder="Branch Type" class="w100p"  class="readonly "  readonly="readonly" value= "${branchDetail.code}"/> --%>
    <input type="text" title="" id="branchCd" name="branchCd" placeholder="" class="w100p readonly" readonly="readonly" value= "${branchDetail.code}"/>
    </td>
</tr>
<tr>
    <th scope="row">Branch Name<span class="must">*</span></th>
    <td>
    <input type="text" title="" placeholder="Branch Name" class="w100p" id="branchName" name="branchName" value= "${branchDetail.name}" />
    </td>
    <th scope="row">Region</th>
    <td>
    <select id="cmRegion" name="cmRegion" class="w100p" >
    </select>
    </td>
</tr>
<tr>
  <th scope="row">Area search<span class="must">*</span></th>
  <td colspan="3">
  <input type="text" title="" id="searchSt" name="searchSt" placeholder="" class="" /><a href="#" onclick="fn_addrSearch()" class="search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
    </td>
</tr>
<tr>
    <th scope="row" >Address Detail<span class="must">*</span></th>
    <td colspan="3">
    <input type="text" title="" id="addrDtl" name="addrDtl" placeholder="Detail Address" class="w100p" value= "${branchDetail.c2}" />
    </td>
</tr>
<tr>
    <th scope="row" >Street</th>
    <td colspan="3">
    <input type="text" title="" id="streetDtl" name="streetDtl" placeholder="Detail Address" class="w100p" value= "${branchDetail.c3}" />
    </td>
</tr>
<tr>
   <th scope="row">Area(4)<span class="must">*</span></th>
    <td colspan="3">
    <select class="w100p" id="mArea"  name="mArea" onchange="javascript : fn_getAreaId()"></select> 
    </td>
</tr>
<tr>
     <th scope="row">City(2)<span class="must">*</span></th>
    <td>
    <select class="w100p" id="mCity"  name="mCity" onchange="javascript : fn_selectCity(this.value)"></select>  
    </td>
    <th scope="row">PostCode(3)<span class="must">*</span></th>
    <td>
    <select class="w100p" id="mPostCd"  name="mPostCd" onchange="javascript : fn_selectPostCode(this.value)"></select>
    </td>
</tr>
<tr>
    <th scope="row">State(1)<span class="must">*</span></th>
    <td>
    <select class="w100p" id="mState"  name="mState" onchange="javascript : fn_selectState(this.value)"></select>
    </td>
    <th scope="row">Country<span class="must">*</span></th>
    <td>
    <input type="text" title="" id="mCountry" name="mCountry" placeholder="" class="w100p readonly" readonly="readonly" value="Malaysia"/>
    </td>
</tr>
<tr>
    <th scope="row">Contact Person</th>
    <td>
    <input id="contact" name="contact" type="text" title="" placeholder="Contact Person" class="w100p" value= "${branchDetail.c6}"/>
    </td>
    <th scope="row">Tel (F)</th>
    <td>
    <input id="txtFax" name="txtFax" type="text" title="" placeholder="Tel (Fax)" class="w100p"  value= "${branchDetail.c16}"/>
    </td>
</tr>
<tr>
    <th scope="row">Tel (1)</th>
    <td>
    <input id="txtTel1" name="txtTel1" type="text" title="" placeholder="Tel (1)" class="w100p"  value= "${branchDetail.c14}"/>
    </td>
    <th scope="row">Tel (2)</th>
    <td>
    <input id="txtTel2" name="txtTel2" type="text" title="" placeholder="Tel (2)" class="w100p"  value= "${branchDetail.c15}" />
    </td>
</tr>
<tr>
  <th scope="row">Closing Date</th>
    <td>
     <input id="closingDate" name="closingDate" placeholder="DD/MM/YYYY" class="j_date" type="text" title="" />
    </td>
    <th scope="row">Cost Center</th>
    <td>
     <input id="costCenter" name="costCenter" type="text" title="" placeholder="Cost Center" class="w100p"  value= "${branchDetail.costCenter}" />
    </td>

</tr>

</tbody>
</table><!-- table end -->
</form>
<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href=" javascript:fn_branchSave();" >SAVE</a></p></li>
</ul>
</section>
</div><!-- popup_wrap end -->