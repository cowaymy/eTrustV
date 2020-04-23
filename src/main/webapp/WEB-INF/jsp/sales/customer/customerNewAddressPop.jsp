<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
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
         /* ### Get Cust AddrID ####*/
         fn_getCustAddrId();
        /* ###  Page Param #### */
         fn_selectPage();
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

             if($("#searchSt").val() ==''){
                 Common.alert("Please key in Area search(3). Area search(3) cannot be null.");
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

             if($("#areaId").val() == ''){
                 Common.alert('Area not found. <br/> Please check with System Administrator.');
                 return ;
             }

             console.log($("#insAddressForm").serializeJSON());
             fn_customerAddressInfoAddAjax();

         }) ;

         $("#_copyBtn").click(function() {

             //custAddrId
             var addid = $("#tempAddrId").val();
             $("#areaId").val($("#tempAreaId").val());

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


        //Enter Event
        $('#searchSt').keydown(function (event) {
            if (event.which === 13) {    //enter
                fn_addrSearch();
            }
        });

        $("#addrDtl").bind("keyup", function(){$(this).val($(this).val().toUpperCase());});
        $("#streetDtl").bind("keyup", function(){$(this).val($(this).val().toUpperCase());});

        // 20190925 KR-OHK Moblie Popup Setting
        Common.setMobilePopup(false, false, '');

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

                 //$("#mPostCd").attr({"disabled" : false  , "class" : "w100p"});
                 $('#mPostCd').append($('<option>', { value: '', text: '3. Post Code' }));
                 $('#mPostCd').val('');
                 $("#mPostCd").attr({"disabled" : "disabled"  , "class" : "w100p disabled"});

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
                //Common.alert("Get Address Id was Failed!");
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
            if('${callParam}' == 'ORD_REGISTER_BILL_MTH') {
                fn_loadMailAddr(result.data);
                $("#_close1").click();
            }
            if('${callParam}' == 'PRE_ORD_BILL_ADD') {
                fn_loadBillAddr(result.data);
                $("#_close1").click();
            }
            if('${callParam}' == 'ORD_REGISTER_INST_ADD') {
                fn_loadInstallAddr(result.data);
                $("#_close1").click();
            }
            if('${callParam}' == 'PRE_ORD_INST_ADD'){
                fn_loadInstallAddr(result.data);
                fn_loadBillAddr(result.data);
                $("#_close1").click();
            }
            if('${callParam}' == 'ORD_MODIFY_MAIL_ADR2') {
                fn_loadMailAddress(result.data);
                $("#_close1").click();
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
        // null state
        if (FormUtil.isEmpty($("#mState").val())) {
            Common.alert("<spring:message code='sys.msg.necessary' arguments='State' htmlEscape='false'/>");
            return false;
        }
        // null city
        if (FormUtil.isEmpty($("#mCity").val())) {
            Common.alert("<spring:message code='sys.msg.necessary' arguments='City' htmlEscape='false'/>");
            return false;
        }
        if($("#searchSt").val() == ''){
            Common.alert("Please search.");
            return false;
        }
        Common.popupDiv('/sales/customer/searchMagicAddressPop.do' , $('#insAddressForm').serializeJSON(), null , true, '_searchDiv');

       $("#mPostCd").attr({"disabled" : false  , "class" : "w100p"});

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
<h1><spring:message code="sal.page.title.addCustAddr" /></h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#" id="_close1"><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->
<section class="pop_body"><!-- pop_body start -->

<form id="insAddressForm" name="insAddressForm" method="POST">
    <input type="hidden" id="areaId" name="areaId">
    <input type="hidden" value="${insCustId}" id="_insCustId" name="insCustId">
    <input type="hidden" name="addrCustAddId" value="${detailaddr.custAddId}" id="addrCustAddId">
    <!-- Temp Address Id -->
    <input type="hidden" name="tempAddrId" id="tempAddrId">
    <input type="hidden" name="tempAreaId" id="tempAreaId">
    <!-- Page Param -->
    <input type="hidden" name="callParam" id="_callParam" value="${callParam}">
    <table class="type1"><!-- table start -->
    <caption>table</caption>
    <colgroup>
        <col style="width:40%" />
        <col style="width:*" />
    </colgroup>
         <tbody>
            <tr>
                <th scope="row" ><spring:message code="sal.text.addressDetail" /><span class="must">*</span></th>
                <td>
                <input type="text" title="" id="addrDtl" name="addrDtl" placeholder="Detail Address" class="w100p"  />
                </td>
            </tr>
            <tr>
                <th scope="row" ><spring:message code="sal.text.street" /></th>
                <td>
                <input type="text" title="" id="streetDtl" name="streetDtl" placeholder="Detail Address" class="w100p"  />
                </td>
            </tr>
            <tr>
                <th scope="row"><spring:message code="sal.text.state1" /><span class="must">*</span></th>
                <td>
                <select class="w100p" id="mState"  name="mState" onchange="javascript : fn_selectState(this.value)"></select>
                </td>
            </tr>
            <tr>
                 <th scope="row"><spring:message code="sal.text.city2" /><span class="must">*</span></th>
                <td>
                <select class="w100p" id="mCity"  name="mCity" onchange="javascript : fn_selectCity(this.value)"></select>
                </td>
            </tr>
            <tr>
                <th scope="row"><spring:message code="sal.text.streetSearch3" /><span class="must">*</span></th>
                <td>
                <input type="text" title="" id="searchSt" name="searchSt" placeholder="" class="" style="width:155px;"/><a href="#" onclick="fn_addrSearch()" class="search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
                </td>
            </tr>
            <tr>
                 <th scope="row"><spring:message code="sal.text.postCode4" /><span class="must">*</span></th>
                <td>
                <select class="w100p" id="mPostCd"  name="mPostCd" onchange="javascript : fn_selectPostCode(this.value)"></select>
                </td>
            </tr>
            <tr>
               <th scope="row"><spring:message code="sal.text.area5" /><span class="must">*</span></th>
                <td>
                <select class="w100p" id="mArea"  name="mArea" onchange="javascript : fn_getAreaId()"></select>
                </td>
            </tr>
            <tr>
                <th scope="row"><spring:message code="sal.text.country" /><span class="must">*</span></th>
                <td>
                <input type="text" title="" id="mCountry" name="mCountry" placeholder="" class="w100p readonly" readonly="readonly" value="Malaysia"/>
                </td>
            </tr>
            <tr>
                <th scope="row"><spring:message code="sal.text.remarks" /></th>
                <td>
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