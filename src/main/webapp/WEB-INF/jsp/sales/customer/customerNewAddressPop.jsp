<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">
    
	 $(document).ready(function() {
		/* ### Get Cust AddrID ####*/
		 fn_getCustAddrId();
		/* ###  Page Param #### */
         fn_selectPage();
		/* #### Btn Action  #### */
		 $("#_saveBtn").click(function() {
			    
			 
			 /* addr1 addr2 null check */
			 if( ( "" == $("#mAddr1").val() || null == $("#mAddr1").val()) &&  ( "" == $("#mAddr2").val() || null == $("#mAddr2").val()) ){
				 Common.alert("* Please key in the address.");
				 return;
			 }
			 
			 if($("#mState").val() == ''){
		         Common.alert("Please key in the state.");
		         return;
	         }
	         if($("#mCity").val() == ''){
	             Common.alert("Please key in the city.");
	             return ;
	         }
	         if($("#mTown").val() == ''){
	              Common.alert("Please key in the town.");
	              return ;
	         }
	         if($("#mStreet").val() == ''){
	              Common.alert("Please key in the street.");
	              return ;
	         }
	         if($("#mPostCd").val() == ''){
	              Common.alert("Please key in the postcode.");
	              return ;
	         }
	         
	         fn_customerAddressInfoAddAjax();
			 
		 })	;
		 
		 $("#_copyBtn").click(function() {
			
			 //custAddrId
			 var addid = $("#tempAddrId").val();
			 $("#streetId").val($("#tempStreetId").val());			 
			 
			 $.ajax({
				 type : "GET",
				 url : getContextPath() + "/sales/customer/selectCustomerCopyAddressJson",
				 data : { getparam : addid}, 
				 dataType: "json",
				 contentType : "application/json;charset=UTF-8",
	             success : function(data) {
	                    $("#mAddr1").val(data.add1);
	                    $("#mAddr2").val(data.add2);
	                    $("#mCountry").val(data.country);
	                    $("#mState").val(data.region1);
	                    $("#mCity").val(data.region2);
	                    $("#mTown").val(data.locality);
	                    $("#mStreet").val(data.street);
	                    $("#mPostCd").val(data.postCode);
	                    $("#addrRem").val(data.rem);
	            	 
	             },
	             error: function(){
	                alert("Get Address Detail was Failed!");
	             },
	             complete: function(){
	             }
				 
			 });
		});
		
	});
	
	 function fn_selectPage(){
		 
		 if("" != $("#_callParam").val() && null != $("#_callParam").val()){
			  $("#_copyBtn").css("display" , "");
		 }
	 }
	 
	function fn_getCustAddrId(){
		
		var getparam = $("#_insCustId").val();
		
		$.ajax({
			
			type: "GET",
			url : getContextPath() + "/sales/customer/selectCustomerMainAddr",
			data : {getparam : getparam},
			dataType : "json",
			contentType : "application/json;charset=UTF-8",
			success : function(data) {
		            $("#tempAddrId").val(data.custAddId);
		            $("#tempStreetId").val(data.streetId);
		            
		    },
		    error: function(){
	            alert("Get Address Id was Failed!");
	        },
	        complete: function(){
	        }
		});
		
	}
	 
	// Call Ajax - DB Insert
    function fn_customerAddressInfoAddAjax(){
        Common.ajax("GET", "/sales/customer/insertCustomerAddressInfoAf.do",$("#insAddressForm").serialize(), function(result) {
            
        	if( null != $("#_callParam").val() && "" != $("#_callParam").val()){
        		Common.alert(result.message);
        	}else{
        		Common.alert(result.message, fn_parentReload);
        	}
        });
    }
	 
    function fn_parentReload() {
        fn_selectPstRequestDOListAjax(); //parent Method (Reload)
        $("#_close1").click();
        $("#_close").click();
        $("#_selectParam").val('2');
        Common.popupDiv('/sales/customer/updateCustomerAddressPop.do' , $('#popForm').serializeJSON(), null , true, '_editDiv2'); 
        Common.popupDiv('/sales/customer/updateCustomerNewAddressPop.do', $('#popForm').serializeJSON(), null , true, '_editDiv2New'); 
    }
    
    function fn_addrSearch(){
        if($("#searchSt").val() == ''){
            Common.alert("Please search.");
            return false;
        }
        Common.popupDiv('/sales/customer/searchMagicAddressPop.do' , $('#insAddressForm').serializeJSON(), null , true, '_searchDiv');
    }
    
    
     function fn_addMaddr(mstate,mcity,mtown,mpostCd,mstreet,miso,mstreetId){
         
            if(mstate != "" && mcity != "" && mtown != "" && mpostCd != "" && mstreet != "" && mstreetId != ""){
                $("#mState").val(mstate);
                $("#mCity").val(mcity);
                $("#mTown").val(mtown);
                $("#mPostCd").val(mpostCd);
                $("#mStreet").val(mstreet);
                $("#mCountry").val(miso);
                $("#streetId").val(mstreetId);
                $("#_searchDiv").remove();
            }else{
                Common.alert("Please check your address.");
            }
        }
</script>
<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->
<header class="pop_header"><!-- pop_header start -->
<h1>ADD CUSTOMER ADDRESS</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#" id="_close1">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->
<section class="pop_body"><!-- pop_body start -->

<form id="insAddressForm" name="insAddressForm" method="POST">
    <input type="hidden" id="streetId" name="streetId">
    <input type="hidden" value="${insCustId}" id="_insCustId" name="insCustId"> 
    <input type="hidden" name="addrCustAddId" value="${detailaddr.custAddId}" id="addrCustAddId">
    <!-- Temp Address Id -->
    <input type="hidden" name="tempAddrId" id="tempAddrId">
    <input type="hidden" name="tempStreetId" id="tempStreetId">
    <!-- Page Param -->
    <input type="hidden" name="callParam" id="_callParam" value="${callParam}">
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
                <th scope="row">Street search<span class="must">*</span></th>
                <td colspan="3">
                <input type="text" title="" id="searchSt" name="searchSt" placeholder="" class="" /><a href="#" onclick="fn_addrSearch()" class="search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
                </td>
            </tr>
            <tr>
                <th scope="row" rowspan="2">Address<span class="must">*</span></th>
                <td colspan="3">
                <input type="text" title="" id="mAddr1" name="mAddr1" placeholder="Address(1)" class="w100p"  />
                </td>
            </tr>
            <tr>
                <td colspan="3">
                <input type="text" title="" id="mAddr2" name="mAddr2" placeholder="Address(2)" class="w100p" />
                </td>
            </tr>
            <tr>
                <th scope="row">Country<span class="must">*</span></th>
                <td>
                <input type="text" title="" id="mCountry" name="mCountry" placeholder="" class="w100p readonly" readonly="readonly" />
                </td>
                <th scope="row">Region<span class="must">*</span></th>
                <td>
                <input type="text" title="" id="mState" name="mState" placeholder="" class="w100p readonly" readonly="readonly" />
                </td>
            </tr>
            <tr>
                <th scope="row">City<span class="must">*</span></th>
                <td>
                <input type="text" title="" id="mCity" name="mCity" placeholder="" class="w100p readonly" readonly="readonly" />
                </td>
                <th scope="row">Town<span class="must">*</span></th>
                <td>
                <input type="text" title="" id="mTown" name="mTown" placeholder="" class="w100p readonly" readonly="readonly" />
                </td>
            </tr>
            <tr>
                <th scope="row">Street<span class="must">*</span></th>
                <td>
                <input type="text" title="" id="mStreet" name="mStreet" placeholder="" class="w100p readonly" readonly="readonly" />
                </td>
                <th scope="row">PostCode<span class="must">*</span></th>
                <td>
                <input type="text" title="" id="mPostCd" name="mPostCd" placeholder="" class="w100p readonly" readonly="readonly" />
                </td>
            </tr>
            <tr>
                <th scope="row">Remarks</th>
                <td colspan="3">
                <textarea cols="20" rows="5" id="addrRem" name="addrRem" placeholder="Remark"></textarea>
                </td>
            </tr>
            <tr>
                <td>
                    <ul class="center_btns">
				    <li><p class="btn_blue big"><a href="#" id="_copyBtn" style="display: none;">Copy</a></p></li>
				    </ul>
                </td>
            </tr>
        </tbody>
    </table><!-- table end -->
</form>

<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#" id="_saveBtn">Save</a></p></li>
</ul>

</section>
</div>