<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">
 
    //Combo Box Choose Message    
    var optionCountry = {chooseMessage: " Country "};
    var optionState = {chooseMessage: " 1.States "};
    var optionCity = {chooseMessage: "2. City"};
    var optionPostCode = {chooseMessage: "3. Post Code"};
    var optionArea = {chooseMessage: "4. Area"};

     $(document).ready(function() {
         //Init Field
         var tempCountry = $("#getCountry").val();
         var tempState = $("#getState").val();
         var tempCity = $("#getCity").val();
         var tempPostCode = $("#getPostCode").val();
         var tempArea = $("#getArea").val();
         
         fn_updateInitField(tempCountry, tempState, tempCity , tempPostCode , tempArea);
         
//         CommonCombo.make('mState', "/sales/customer/selectMagicAddressComboList", '' , '', optionState);

        /* #### Btn Action  #### */
         $("#_updBtn").click(function() {
                
             /* addr1 addr2 null check */
             if( ( "" == $("#addrDtl").val() || null == $("#addrDtl").val())){
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
             
             fn_updDealerAddressInfo();
             
         }) ;
         
        //Enter Event
//        $('#searchSt').keydown(function (event) {  
//            if (event.which === 13) {    //enter  
//                fn_addrSearch();
//            }  
//        });
         
    });//Document Ready Func End
    
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
    
    function fn_updateInitField(tempCountry, tempState, tempCity , tempPostCode , tempArea){
        
        //Country
         if( '' != tempCountry && null != tempCountry){
             
             CommonCombo.make('mCountry', "/sales/pst/pstDealerAddrComboList", '' , tempCountry, optionCountry);
         }else{
             
             CommonCombo.make('mCountry', "/sales/pst/pstDealerAddrComboList", '' , '', optionCountry);
             fn_selectState('');
             return;
             
         }
        
       //State
       var stateJson = {country : tempCountry}; 
         if( '' != tempState && null != tempState){
             
             CommonCombo.make('mState', "/sales/pst/pstDealerAddrComboList", stateJson , tempState, optionState);
         }else{
             
             CommonCombo.make('mState', "/sales/pst/pstDealerAddrComboList", stateJson , '', optionState);
             fn_selectState('');
             return;
             
         }
         
        //City
         var cityJson = {country : tempCountry, state : tempState}; //Condition
         if('' != tempCity && null != tempCity){
            
             CommonCombo.make('mCity', "/sales/pst/pstDealerAddrComboList", cityJson, tempCity , optionCity);
             
         }else{
             CommonCombo.make('mCity', "/sales/pst/pstDealerAddrComboList", cityJson, '' , optionCity);
           
             fn_selectCity('');
             return;
         }
         
         //PostCode
         var postCodeJson = {country : tempCountry, state : tempState , city : tempCity}; //Condition
         if('' != tempPostCode && null != tempPostCode){
             
             CommonCombo.make('mPostCd', "/sales/pst/pstDealerAddrComboList", postCodeJson, tempPostCode , optionPostCode);
             
         }else{
             CommonCombo.make('mPostCd', "/sales/pst/pstDealerAddrComboList", postCodeJson, '' , optionPostCode);
            
             fn_selectPostCode('');
             return;
         }
         
         //Area
         var areaJson = {country : tempCountry, state : tempState, city : tempCity , postcode : tempPostCode}; //Condition
         if('' != tempArea && null != tempArea){
             CommonCombo.make('mArea', "/sales/pst/pstDealerAddrComboList", areaJson, tempArea , optionArea);
            
         }else{
             CommonCombo.make('mArea', "/sales/pst/pstDealerAddrComboList", areaJson, '' , optionArea);
            
             return;
         }
         
     }
    
    // Call Ajax - DB Insert
    function fn_updDealerAddressInfo(){
        Common.ajax("GET", "/sales/pst/updateDealerAddressInfo.do",$("#updAddressForm").serialize(), function(result) {

            Common.alert(result.message, fn_parentReload);

        });
    }
    
   
        /*####### Magic Address #########*/
        function fn_initAddress(){

           $("#mState").attr({"disabled" : "disabled"  , "class" : "w100p disabled"});
           $('#mState').val('');
   
           $("#mPostCd").attr({"disabled" : "disabled"  , "class" : "w100p disabled"});
           $("#mPostCd").val('');
           
           $("#mCity").attr({"disabled" : "disabled"  , "class" : "w100p disabled"});
           $("#mCity").val('');
           
           $("#mArea").attr({"disabled" : "disabled"  , "class" : "w100p disabled"});
           $("#mArea").val('');
        }
         
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
        fn_pstDealerListAjax(); //parent Method (Reload) List
        $("#_close1").click();
        $("#autoClose").click();
        $("#_eClose").click();
        Common.popupDiv('/sales/pst/pstDealerDetailPop.do' , $('#searchForm').serializeJSON(), null , true, '_editDiv2'); 
//        Common.popupDiv('/sales/customer/updateCustomerNewAddressPop.do', $('#popForm').serializeJSON(), null , true, '_editDiv2New'); 
    }
    
    //Dealer Edit는 delete 없음.
//    function fn_addrSearch(){
//        if($("#searchSt").val() == ''){
//            Common.alert("Please search.");
//            return false;
//        }
//        Common.popupDiv('/sales/customer/searchMagicAddressPop.do' , $('#insAddressForm').serializeJSON(), null , true, '_searchDiv');
//    }
    
    
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
    
    //Delete Dealer Edit는 delete 없음.
//    $("#_delBtn").click(function() {
       
//       Common.confirm("Are you sure want to delete this address ?", fn_deleteAddressAjax);
//    });
    
    /* ####### delete Func ########### */
    //delete call Ajax
//    function fn_deleteAddressAjax(){
        
//        Common.ajax("GET", "/sales/pst/delDealerAddress.do", $("#updAddressForm").serialize(), function(result){
            //result alert and closePage
//            Common.alert(result.message, fn_parentReload);
//        });
//    }
    
 // Parent Reload And Page Close
//    function fn_closePage(){
//        fn_selectPstRequestDOListAjax(); //parent Method (Reload)
//        $("#_close1").click();
//        $("#_close").click();
//        Common.popupDiv('/sales/pst/updateCustomerAddressPop.do' , $('#popForm').serializeJSON(), null , true, '_editDiv2'); 
//    }
</script>
<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->
<header class="pop_header"><!-- pop_header start -->
<h1>ADD DEALER ADDRESS</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#" id="_close1">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->
<section class="pop_body"><!-- pop_body start -->

<form id="updAddressForm" name="updAddressForm" method="POST">
    <input type="hidden" id="areaId" name="areaId" value="${updAddrInfo.areaId}">
    <input type="hidden" value="${insDealerId}" id="insDealerId" name="insDealerId"> 
    <input type="hidden" name="addrDealerAddId" value="${updAddrInfo.dealerAddId}" id="addrDealerAddId">
    <input type="hidden" id="getCountry"  value="${updAddrInfo.country}">
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
                <th scope="row" >Address Detail<span class="must">*</span></th>
                <td colspan="3">
                <input type="text" title="" id="addrDtl" name="addrDtl" value="${updAddrInfo.addrDtl}" placeholder="Detail Address" class="w100p"  />
                </td>
            </tr>
            <tr>
                <th scope="row" >Street</th>
                <td colspan="3">
                <input type="text" title="" id="streetDtl" name="streetDtl" value="${updAddrInfo.street}" placeholder="Detail Address" class="w100p"  />
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
                <select class="w100p" id="mCountry"  name="mCountry" onchange="javascript : fn_selectCountry(this.value)"></select>
                </td>
            </tr>
            <tr>
                <th scope="row">Remarks</th>
                <td colspan="3">
                <textarea cols="20" rows="5" id="addrRem" name="addrRem" placeholder="Remark">${updAddrInfo.rem}</textarea>
                </td>
            </tr>
        </tbody>
    </table><!-- table end -->
</form>

<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#" id="_updBtn">Update Address</a></p></li>
    <!-- <li><p class="btn_blue2 big"><a href="#" id="_delBtn">Delete Address</a></p></li> -->
</ul>

</section>
</div>