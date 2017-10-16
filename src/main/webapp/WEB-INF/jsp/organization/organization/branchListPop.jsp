<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>


     <script type="text/javaScript" language="javascript">

		var optionState = {chooseMessage: " 1.States "};
		var optionCity = {chooseMessage: "2. City"};
		var optionPostCode = {chooseMessage: "3. Post Code"};
		var optionArea = {chooseMessage: "4. Area"};

	    var option = {
	            width : "1000px", // 창 가로 크기
	            height : "600px" // 창 세로 크기
	        };

	    
        
        //doGetCombo('/common/selectCodeList.do', '45', '','branchType', 'S' , ''); //branchType
        doGetCombo('/common/selectCodeList.do', '49', '','region', 'S' , ''); //region
         
		//Start AUIGrid
	    $(document).ready(function() {

/* 	           var branchId = "${branchDetail.typeId}";
	               console.log("branchId : " + branchId);
		           $("#branchType option[value="+ branchId +"]").attr("selected", true); */
/* 		           $("#branchType option[value='41']").attr("selected", true); */



            $('#nation').change(function (){
                 if ($("#nation").val()== 1){
                    doGetCombo('/organization/getStateList.do', $(this).val() , ''   , 'state' , 'S', '');
                }
                
            });
            
            
            $('#state').change(function (){
                    doGetCombo('/organization/getAreaList.do', $(this).val() , ''   , 'area' , 'S', '');
            });
            
            
            $('#area').change(function (){
                    doGetCombo('/organization/getPostcodeList.do', $(this).val() , ''   , 'postcode' , 'S', '');
            });
            
        });
	    
	    
	    
        //Update
        function fn_branchSave() {

            if (validRequiredField()){
                alert("성공:" );
            
	            Common.ajax("GET","/organization/branchListUpdate.do", $("#branchForm").serialize(), function(result){
	                console.log(result);
	                Common.alert("Branch successfully updated.");
	            });
            
            }else {
                Common.alert("<b>Failed to update. Please try again later.</b>");
            }

        }
        
	    




    function  validRequiredField() {
        var  valid = "true";
        //var  valid = false;
        var  message = "";
        
        var  newBranchName = $("#branchName").val();
        var txtAddress1 = $("#txtAddress1").val();
        var txtAddress2 = $("#txtAddress2").val();
        var txtAddress3 = $("#txtAddress3").val();
        var nation = $("#nation").val();
        var state = $("#state").val();
        var area = $("#area").val();
        var postcode = $("#postcode").val();
        var contact   = $("#contact").val();    
        var txtFax      = $("#txtFax").val();    
        var txtTel1      = $("#txtTel1").val();    
        var txtTel2      = $("#txtTel2").val();    
        
        
        
        if($("#branchType").val() <= -1){
            valid = false;
            message += "* Please select the branch type.<br />";
        }
                

         if(newBranchName ==  ""){
            valid = false;
            message += "* Please key in the branch name.<br />";
        }
        else{
            if (newBranchName.length > 50) {
                valid = false;
                message += "* Branch name cannot exceed 50 characters.<br />";
            }
        }
        
        if ($.trim(txtAddress1) != "") {
	        if (txtAddress1.length > 50) {
	            valid = false;
	            message += "* Address (1) cannot exceed 50 characters.<br />";
	        }
        }
        
        if ($.trim(txtAddress2) != "") {
	        if (txtAddress2.length > 50) {
	            valid = false;
	            message += "* Address (2) cannot exceed 50 characters.<br />";
	        }
	    }    
       
        if ($.trim(txtAddress3) != "") {
	        if (txtAddress3.length > 50) {
	            valid = false;
	            message += "* Address (2) cannot exceed 50 characters.<br />";
	        }
        }        
        
        
         if (nation == "1") {
            if (state <= -1) {
                valid = false;
                message += "* Please select the state.<br />";
            }
            if (area <= -1) {
                valid = false;
                message += "* Please select the area.<br />";
            }

            if (postcode <= -1) {
                valid = false;
                message += "* Please select the postcode.<br />";
            }
        }
        
        if ($.trim(contact) != "") {
            if (contact.length > 50) {
                valid = false;
                message += "* Contact person cannot exceed 50 characters.<br />";
            }
        }

        if ($.trim(txtFax) != "") {
            if (txtFax.length > 15) {
                valid = false;
                message += "* Tel (F) cannot exceed 15 characters.<br />";
            }
        }

        if ($.trim(txtTel1) != "") {
            if (txtTel1.length > 15) {
                valid = false;
                message += "* Tel (1) cannot exceed 15 characters.<br />";
            }
        }

        if ($.trim(txtTel2) != "") {
            if (txtTel2.length > 15) {
                valid = false;
                message += "* Tel (2) cannot exceed 15 characters.<br />";
            }
        }

        if (!valid) alert(message + "</b> Add Branch Summary"); 
        return valid;
    }




		//Validation Check
		function fn_saveValidation(){
		    if($("#memberNm").val() == ''){
		        Common.alert("Please key  in Member Name");
		        return false;
		    }
		    
		    if($("#joinDate").val() == ''){
		        Common.alert("Please select Joined Date");
		        return false;
		    }
		
		    if($('input[name=gender]:checked', '#memberAddForm').val() == null){
		          Common.alert("Please select Gender");
		            return false;
		    }
		    
		    /* if(!$("#gender").is(":radio")){
		      
		    } */
		    
		    if($("#Birth").val() == ''){
		        Common.alert("Please select Date of Birth");
		        return false;
		    }
		    
		    if($("#cmbRace").val() == ''){
		        Common.alert("Please select race");
		        return false;
		    }
		    
		    if($("#national").val() == ''){
		        Common.alert("Please select Nationality");
		        return false;
		    }
		    
		    if($("#nric").val() == ''){
		        Common.alert("Please key  in NRIC");
		        return false;
		    }
		    
		    
		    if($("#marrital").val() == ''){
		        Common.alert("Please select marrital");
		        return false;
		    }
		    
		    if($("#issuedBank").val() == ''){
		        Common.alert("Please select the issued bank");
		        return false;
		    }
		    if($("#bankAccNo").val() == ''){
		        Common.alert("Please key in the bank account no");
		        return false;
		    }
		    //type 별로 다르게 해야됨
		    if($("#deptCd").val() == ''){
		        Common.alert("Please select the department code");
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
		    Common.popupDiv('/sales/customer/searchMagicAddressPop.do' , $('#insAddressForm').serializeJSON(), null , true, '_searchDiv'); //searchSt
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
    <li><p class="btn_blue2"><a href=" javascript:fn_close();">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->
<form id="branchForm" name="branchForm">    
<input type='hidden' id ='branchNo' name='branchNo'  value= "${branchDetail.brnchId}"/>

<section class="tap_wrap"><!-- tap_wrap start -->
<ul class="tap_type1 num4">
    <li><a href="#" class="on">Basic Info</a></li>
    <li><a href="#">Member Address</a></li>
</ul>

<article class="tap_area"><!-- tap_area start -->


<aside class="title_line"><!-- title_line start -->
<h2>Basic Information</h2>
</aside><!-- title_line end -->
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
    <select id="branchType" name="branchType" class="w100p" >
        <%-- <option value="${branchDetail.typeId}"  selected></option> --%>
           <c:forEach var="list" items="${branchType }" varStatus="status">
           <option value="${list.branchId}">${list.c1}</option>
           </c:forEach>
    </select>
    </td>
    <th scope="row">Branch Code<span class="must">*</span></th>
    <td>
    <input id="branchCd" name="branchCd" type="text" title="" placeholder="Branch Type" class="w100p"  value= "${branchDetail.code}"/>
    </td>
</tr>
<tr>
    <th scope="row">Branch Name<span class="must">*</span></th>
    <td>
    <input type="text" title="" placeholder="Branch Name" class="w100p" id="branchName" name="branchName" value= "${branchDetail.name}" />
    </td>
    <th scope="row">Region</th>
    <td>
    <select id="region" name="region" class="w100p" >
    </select>
    </td>
</tr>
<%-- <tr>
    <th scope="row" rowspan="3">Address</th>
    <td colspan="3">
    <input type="text" title="" placeholder="Address (1)" class="w100p"  id= "txtAddress1" name = "txtAddress1" value= "${branchDetail.c1}" />
    </td>
</tr>
<tr>
    <td colspan="3">
    <input type="text" title="" placeholder="Address (2)" class="w100p"   id= "txtAddress2" name = "txtAddress2" value= "${branchDetail.c2}"/>
    </td>
</tr>
<tr>
    <td colspan="3">
    <input type="text" title="" placeholder="Address (3)" class="w100p"   id= "txtAddress3" name = "txtAddress3" value= "${branchDetail.c3}" />
    </td>
</tr> --%>
<%-- <tr>
    <th scope="row">Country</th>
    <td>
    <select id="nation" name="nation" class="w100p">
        <option value="" selected>--- Country ---</option>
         <c:forEach var="list" items="${nationality }" varStatus="status">
           <option value="${list.countryid}">${list.name}</option>
        </c:forEach>
    </select>
    </td>
    <th scope="row">State<span class="must">*</span></th>
    <td>
    <select id="state" name="state" class="w100p">
        <option value="">11</option>
        <option value="">22</option>
        <option value="">33</option>
    </select>
    </td>
</tr> --%>
<!-- <tr>
    <th scope="row">Area<span class="must">*</span></th>
    <td>
    <select id="area" name="area" class="w100p">
        <option value="">11</option>
        <option value="">22</option>
        <option value="">33</option>
    </select>
    </td>
    <th scope="row">Postcode<span class="must">*</span></th>
    <td>
    <select id="postcode" name="postcode" class="w100p">
        <option value="">11</option>
        <option value="">22</option>
        <option value="">33</option>
    </select>
    </td>
</tr> -->
<tr>
    <th scope="row">Contact Person</th>
    <td>
    <input id="contact" name="contact" type="text" title="" placeholder="Contact Person" class="w100p" />
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
</tbody>
</table><!-- table end -->

<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#" onClick="javascript:fn_branchSave();" >SAVE</a></p></li>
</ul>

</article><!-- tap_area end -->
</form>

<article class="tap_area"><!-- tap_area start -->

<aside class="title_line"><!-- title_line start -->
<h2>Installation Address</h2>
</aside><!-- title_line end -->

<form id="insAddressForm" name="insAddressForm" method="POST">
    
    <table class="type1"><!-- table start -->
    <caption>table</caption>
    <colgroup>
        <col style="width:135px" />
        <col style="width:*" />
        <col style="width:130px" />
        <col style="width:*" />
    </colgroup>
         <tbody>
            <tr>
                <th scope="row">Area search<span class="must">*</span></th>
                <td colspan="3">
                <input type="text" title="" id="searchSt" name="searchSt" placeholder="" class="" /><a href="#" onclick="fn_addrSearch()" class="search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
                </td>
            </tr>
            <tr>
                <th scope="row" >Address Detail<span class="must">*</span></th>
                <td colspan="3">
                <input type="text" title="" id="addrDtl" name="addrDtl" placeholder="Detail Address" class="w100p"  />
                </td>
            </tr>
            <tr>
                <th scope="row" >Street</th>
                <td colspan="3">
                <input type="text" title="" id="streetDtl" name="streetDtl" placeholder="Detail Address" class="w100p"  />
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
        </tbody>
    </table><!-- table end -->
</form>
<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#" onClick="javascript:fn_saveConfirm()">SAVE</a></p></li>
    <li><p class="btn_blue2 big"><a href="#">CANCEL</a></p></li>
</ul>

</article><!-- tap_area end -->

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->
