<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">
 
    //Combo Box Choose Message    
    var optionState = {chooseMessage: " 1.States "};
    var optionCity = {chooseMessage: "2. City"};
    var optionPostCode = {chooseMessage: "3. Post Code"};
    var optionArea = {chooseMessage: "4. Area"};

     $(document).ready(function() {
        
         //Filed Init
         fn_initAddress();
         CommonCombo.make('mState', "/sales/customer/selectMagicAddressComboList", '' , '', optionState);
         /* ### Get Cust AddrID 
         fn_getCustAddrId();####*/
        /* ###  Page Param 
         fn_selectPage();#### */
        /* #### Btn Action  #### */
         $("#_saveBtn").click(function() {
                
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
             
             fn_insertDealerAddressInfo();
             
         }) ;
         
//         $("#_copyBtn").click(function() {
//            
//             //custAddrId
//             var addid = $("#tempAddrId").val();
//             $("#areaId").val($("#tempAreaId").val());           
//             
//             $.ajax({
//                 type : "GET",
//                 url : getContextPath() + "/sales/customer/selectCustomerCopyAddressJson",
//                 data : { getparam : addid}, 
//                 dataType: "json",
//                 contentType : "application/json;charset=UTF-8",
//                 success : function(data) {
//                        $("#mAddr1").val(data.add1);
//                        $("#mAddr2").val(data.add2);
//                        $("#mCountry").val(data.country);
//                        $("#mState").val(data.region1);
//                        $("#mCity").val(data.region2);
//                        $("#mTown").val(data.locality);
//                        $("#mStreet").val(data.street);
//                        $("#mPostCd").val(data.postCode);
//                        $("#addrRem").val(data.rem);
//                     
//                 },
//                 error: function(){
//                    alert("Get Address Detail was Failed!");
//                 },
//                 complete: function(){
//                 }
//                 
//             });
//        });
        
         
        //Enter Event
        $('#searchSt').keydown(function (event) {  
            if (event.which === 13) {    //enter  
                fn_addrSearch();
            }  
        });
         
    });//Document Ready Func End
    
     
        /*####### Magic Address #########*/
        function fn_initAddress(){
            
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
        
        
        /*####### Magic Address #########*/
        
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
                    $("#tempAreaId").val(data.areaId);
            },
            error: function(){
                Common.alert('<spring:message code="sal.title.text.getAddrIdWasFailed" />');
            },
            complete: function(){
            }
        });
        
    }
     
    // Call Ajax - DB Insert
    function fn_insertDealerAddressInfo(){
        Common.ajax("GET", "/sales/pst/insertDealerAddressInfo.do",$("#insAddressForm").serialize(), function(result) {

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
</script>
<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->
<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="sal.title.text.addDealerAddress" /></h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#" id="_close1"><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->
<section class="pop_body"><!-- pop_body start -->

<form id="insAddressForm" name="insAddressForm" method="POST">
    <input type="hidden" id="areaId" name="areaId">
    <input type="hidden" value="${insDealerId}" id="insDealerId" name="insDealerId"> 
    <!-- <input type="hidden" name="addrCustAddId" value="${detailaddr.custAddId}" id="addrCustAddId"> -->
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
                <input type="text" title="" id="mCountry" name="mCountry" placeholder="" class="w100p readonly" readonly="readonly" value="Malaysia"/>
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
</form>

<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#" id="_saveBtn"><spring:message code="sal.btn.save2" /></a></p></li>
</ul>

</section>
</div>