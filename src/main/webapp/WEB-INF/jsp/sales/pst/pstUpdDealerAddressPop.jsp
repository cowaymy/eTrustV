<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">
 
    //Combo Box Choose Message    
    var optionState = {chooseMessage: " 1.States "};
    var optionCity = {chooseMessage: "2. City"};
    var optionPostCode = {chooseMessage: "3. Post Code"};
    var optionArea = {chooseMessage: "4. Area"};

     $(document).ready(function() {
        
    	 //Init Field
         var tempState = $("#getState").val();
         var tempCity = $("#getCity").val();
         var tempPostCode = $("#getPostCode").val();
         var tempArea = $("#getArea").val();
         
         fn_updateInitField(tempState, tempCity , tempPostCode , tempArea);
         
//         CommonCombo.make('mState', "/sales/customer/selectMagicAddressComboList", '' , '', optionState);

        /* #### Btn Action  #### */
         $("#_updBtn").click(function() {
                
             /* addr1 addr2 null check */
             if( ( "" == $("#addrDtl").val() || null == $("#addrDtl").val())){
                 Common.alert('<spring:message code="sal.alert.msg.plzKeyinAddr" />');
                 return;
             }
             
             if($("#mState").val() == ''){
                 Common.alert('<spring:message code="sal.alert.msg.plzKeyinState" />');
                 return;
             }
             if($("#mCity").val() == ''){
                 Common.alert('<spring:message code="sal.alert.msg.plzKeyinCity" />');
                 return ;
             }
             if($("#mTown").val() == ''){
                  Common.alert('<spring:message code="sal.alert.msg.plzKeyinTown" />');
                  return ;
             }
             if($("#mStreet").val() == ''){
                  Common.alert('<spring:message code="sal.alert.msg.plzKeyinStreet" />');
                  return ;
             }
             if($("#mPostCd").val() == ''){
                  Common.alert('<spring:message code="sal.alert.msg.plzKeyinPostcode" />');
                  return ;
             }
             
             fn_updDealerAddressInfo();
             
         }) ;
         
        //Enter Event
        $('#searchSt').keydown(function (event) {  
            if (event.which === 13) {    //enter  
                fn_addrSearch();
            }  
        });
         
    });//Document Ready Func End
    
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
    
    // Call Ajax - DB Insert
    function fn_updDealerAddressInfo(){
        Common.ajax("GET", "/sales/pst/updateDealerAddressInfo.do",$("#updAddressForm").serialize(), function(result) {

            Common.alert(result.message, fn_parentReload);

        });
    }
    
    function fn_parentReload() {
        fn_selectPstRequestDOListAjax(); //parent Method (Reload) List
        $("#_close1").click();
        $("#_close").click();
        Common.popupDiv('/sales/pst/editAddrDtPop.do' , $('#getParamForm').serializeJSON(), null , true, '_editDiv2'); 
//        Common.popupDiv('/sales/customer/updateCustomerNewAddressPop.do', $('#popForm').serializeJSON(), null , true, '_editDiv2New'); 
    }
    
        /*####### Magic Address #########*/
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
                
                $("#mPostCd").attr({"disabled" : "disabled"  , "class" : "w100p disabled"});
                $("#mPostCd").val('');
                
                $("#mArea").attr({"disabled" : "disabled"  , "class" : "w100p disabled"});
                $("#mArea").val('');
                
                //Call ajax
                var cityJson = {state : tempVal}; //Condition
                CommonCombo.make('mCity', "/sales/customer/selectMagicAddressComboList", cityJson, '' , optionCity);
            }
            
        }
        
        function fn_selectCity(selVal){
            
            var tempVal = selVal;
            
            if('' == selVal || null == selVal){
               
                $("#mPostCd").attr({"disabled" : "disabled"  , "class" : "w100p disabled"});
                $("#mPostCd").val('');
                
                $("#mArea").attr({"disabled" : "disabled"  , "class" : "w100p disabled"});
                $("#mArea").val('');
                
            }else{
                
                $("#mPostCd").attr({"disabled" : false  , "class" : "w100p"});
                
                $("#mArea").attr({"disabled" : "disabled"  , "class" : "w100p disabled"});
                $("#mArea").val('');
                
                //Call ajax
                var postCodeJson = {state : $("#mState").val() , city : tempVal}; //Condition
                CommonCombo.make('mPostCd', "/sales/customer/selectMagicAddressComboList", postCodeJson, '' , optionPostCode);
            }
            
        }
        
        
        function fn_selectPostCode(selVal){
            
            var tempVal = selVal;
            
            if('' == selVal || null == selVal){
               
                $("#mArea").attr({"disabled" : "disabled"  , "class" : "w100p disabled"});
                $("#mArea").val('');
                
            }else{
                
                $("#mArea").attr({"disabled" : false  , "class" : "w100p"});
                
                //Call ajax
                var areaJson = {state : $("#mState").val(), city : $("#mCity").val() , postcode : tempVal}; //Condition
                CommonCombo.make('mArea', "/sales/customer/selectMagicAddressComboList", areaJson, '' , optionArea);
            }
            
        }
        
        
        /*####### Magic Address #########*/
     
     
    function fn_parentReload() {
        fn_selectPstRequestDOListAjax(); //parent Method (Reload) List
        $("#_close1").click();
        $("#_close").click();
        Common.popupDiv('/sales/pst/editAddrDtPop.do' , $('#getParamForm').serializeJSON(), null , true, '_editDiv2'); 
//        Common.popupDiv('/sales/customer/updateCustomerNewAddressPop.do', $('#popForm').serializeJSON(), null , true, '_editDiv2New'); 
    }
    
    function fn_addrSearch(){
        if($("#searchSt").val() == ''){
            Common.alert('<spring:message code="sal.alert.msg.plzSearch" />');
            return false;
        }
        Common.popupDiv('/sales/customer/searchMagicAddressPop.do' , $('#insAddressForm').serializeJSON(), null , true, '_searchDiv');
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
            Common.alert('<spring:message code="sal.alert.msg.addrCheck" />');
        }
    }
    
    
    
    //Delete
    $("#_delBtn").click(function() {
       
       Common.confirm('<spring:message code="sal.alert.msg.wantDeleteAddrQ" />', fn_deleteAddressAjax);
    });
    
    /* ####### delete Func ########### */
    //delete call Ajax
    function fn_deleteAddressAjax(){
        
        Common.ajax("GET", "/sales/pst/delDealerAddress.do", $("#updAddressForm").serialize(), function(result){
            //result alert and closePage
            Common.alert(result.message, fn_parentReload);
        });
    }
    
 // Parent Reload And Page Close
    function fn_closePage(){
        fn_selectPstRequestDOListAjax(); //parent Method (Reload)
        $("#_close1").click();
        $("#_close").click();
//        Common.popupDiv('/sales/pst/updateCustomerAddressPop.do' , $('#popForm').serializeJSON(), null , true, '_editDiv2'); 
    }
</script>
<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->
<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="sal.title.text.addDealerAddress" /></h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#" id="_close1"><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->
<section class="pop_body"><!-- pop_body start -->

<form id="updAddressForm" name="updAddressForm" method="POST">
    <input type="hidden" id="areaId" name="areaId" value="${updAddrInfo.areaId}">
    <input type="hidden" value="${insDealerId}" id="insDealerId" name="insDealerId"> 
    <input type="hidden" name="addrDealerAddId" value="${updAddrInfo.dealerAddId}" id="addrDealerAddId">
    <input type="hidden" id="getState"  value="${updAddrInfo.state}">
    <input type="hidden" id="getCity"  value="${updAddrInfo.city}">
    <input type="hidden" id="getPostCode"  value="${updAddrInfo.postcode}">
    <input type="hidden" id="getArea"  value="${updAddrInfo.area}">
    <!-- Temp Address Id -->
    <input type="hidden" name="tempAddrId" id="tempAddrId">
    <input type="hidden" name="tempAreaId" id="tempAreaId">
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
                <th scope="row"><spring:message code="sal.text.streetSearch" /><span class="must">*</span></th>
                <td colspan="3">
                <input type="text" title="" id="searchSt" name="searchSt" placeholder="" class="" /><a href="#" onclick="fn_addrSearch()" class="search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
                </td>
            </tr>
            <tr>
                <th scope="row" ><spring:message code="sal.text.addressDetail" /><span class="must">*</span></th>
                <td colspan="3">
                <input type="text" title="" id="addrDtl" name="addrDtl" value="${updAddrInfo.addrDtl}" placeholder="Detail Address" class="w100p"  />
                </td>
            </tr>
            <tr>
                <th scope="row" ><spring:message code="sal.text.street" /></th>
                <td colspan="3">
                <input type="text" title="" id="streetDtl" name="streetDtl" value="${updAddrInfo.street}" placeholder="Detail Address" class="w100p"  />
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
                <input type="text" title="" id="mCountry" name="mCountry" placeholder="" class="w100p readonly" readonly="readonly" value="Malaysia"/>
                </td>
            </tr>
            <tr>
                <th scope="row"><spring:message code="sal.text.remarks" /></th>
                <td colspan="3">
                <textarea cols="20" rows="5" id="addrRem" name="addrRem" placeholder="Remark">${updAddrInfo.rem}</textarea>
                </td>
            </tr>
        </tbody>
    </table><!-- table end -->
</form>

<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#" id="_updBtn"><spring:message code="sal.title.text.updateAddress" /></a></p></li>
    <li><p class="btn_blue2 big"><a href="#" id="_delBtn"><spring:message code="sal.btn.deleteAddress" /></a></p></li>
</ul>

</section>
</div>