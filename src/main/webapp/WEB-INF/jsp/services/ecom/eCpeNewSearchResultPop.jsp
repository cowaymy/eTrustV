<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<style>
    .modalCnt {
       font-size:16px !important;
       line-height:1.5 !important;
    }

    .myModalAlert{
        width:100% !importanrt;
    }

</style>

<script type="text/javascript">

let interval;
let areaJson;

function setModalContent(content){
    return `<div class="row">
                    <div class="col-sm-12 logo" style="display: flex; justify-content: center;">
                    <img src="${pageContext.request.contextPath}/resources/images/common/trueaddress_logo.png" alt="Coway">
                  </div>
                </div>
                <div class="text-danger p-3 modalCnt">` + content + `</div>`;
}

let twoTimesSubmission = "Dear customer, you have submitted multiple submissions. Do you need further assistance? <br/><br/>  For more information, kindly reach our support team on Livechat. Thank you.";

let notREG = "Dear customer, the selected order number has a high outstanding bill. Please remit your payment in order to proceed for detail updates. <br/><br/> For more information, kindly reach our support team on Livechat. Thank you";

let outOfWarranty = "Dear customer, kindly be informed that your product warranty has expired. <br/><br/> For more information, kindly reach our support team on Livechat. Thank you."

let completeSubmission = "Dear customer, your request has been received. <br/><br/>  It will be updated after the next working day. Thank you.";

function resize(){
    $("#banner").width(screen.width + "px");
    $("#banner").height(screen.height *0.7+ "px");
}

window.addEventListener('resize', function(event){
    resize();
});

    var gridPros = {
            usePaging           : true,         //페이징 사용
            pageRowCount        : 10,           //한 화면에 출력되는 행 개수 20(기본값:20)
            editable            : false,
            fixedColumnCount    : 0,
            showStateColumn     : true,
            displayTreeOpen     : false,
   //         selectionMode       : "singleRow",  //"multipleCells",
            headerHeight        : 30,
            useGroupingPanel    : false,        //그룹핑 패널 사용
            skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
            wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
            showRowNumColumn    : true,         //줄번호 칼럼 렌더러 출력
            noDataMessage       : "No order found.",
            groupingMessage     : "Here groupping"
        };

    let optionState = {chooseMessage:  "1. States"};
    let optionCity = {chooseMessage: "2. City"};
    let optionPostCode = {chooseMessage: "3. Post Code"};
    let optionArea = {chooseMessage: "4. Area"};

    $(document).ready(function() {

    	fn_setAutoFile2();

        //Reselect(Whole)
        $("#_reSelect").click(function() {
            $("#_cpeResultPopCloseBtn").click();
        });

        //Submit
        $("#_submitBtn").click(function() {
        	fn_saveNewCpeRequest();        //save

        });

        //file Delete
        $("#btnfileDel").click(function() {
            $("#reqAttchFile").val('');
            $(".input_text").val('');
            console.log("fileDel complete.");
        });

        //Populate Request Type List
        doGetCombo("/services/ecom/selectReasonJsonList", '', '', '_inputReqTypeSelect', 'S', '');

        //Populate Request Date
        fn_setKeyInDate();

        let dscCode = "${orderDetail.installationInfo.dscCode2}";
        let jsonObj3 = { dscCode : dscCode};
        Common.ajax("GET", "/services/ecom/getDscbyDscCode.do", jsonObj3, function(result) {

             doGetComboSepa('/common/selectBranchCodeList.do',  '5', ' - ', result.brnchId,   '_inputSubDeptSelect', 'S', ''); //Branch Code
        });

        fn_initAddress();

        CommonCombo.make('mState', "/enquiry/selectMagicAddressComboList.do", '' , "${orderDetail.installationInfo.instState}", optionState, fn_selectState("${orderDetail.installationInfo.instState}"));

        let cityJson2 = {state : "${orderDetail.installationInfo.instState}"}
        CommonCombo.make('mCity', "/enquiry/selectMagicAddressComboList.do", cityJson2, "${orderDetail.installationInfo.instCity}", optionCity, fn_selectCity("${orderDetail.installationInfo.instCity}"));

        let postCodeJson2 = {state : "${orderDetail.installationInfo.instState}" , city : "${orderDetail.installationInfo.instinstCity}"}; //Condition
        CommonCombo.make('mPostCd', "/enquiry/selectMagicAddressComboList.do", postCodeJson2, "${orderDetail.installationInfo.instPostcode}" , optionPostCode, fn_selectDefaultPostCode("${orderDetail.installationInfo.instPostcode}"));

        let areaJson2 = {state : "${orderDetail.installationInfo.instState}", city : "${orderDetail.installationInfo.instinstCity}" , postcode : "${orderDetail.installationInfo.instPostcode}"}; //Condition
        CommonCombo.make('mArea', "/enquiry/selectMagicAddressComboList.do", areaJson2, "${orderDetail.installationInfo.instArea}" , optionArea);
        $('#searchSt').val("${orderDetail.installationInfo.instArea}");

        fn_getDefaultAreaId()
    });//Doc Ready End

    ////////////////////////////////////////////////////////////////////////////////////

    function chgGridTab(tabNm) {
        switch(tabNm) {
            case 'custInfo' :
                AUIGrid.resize(custInfoGridID, 920, 300);
                break;
            case 'memInfo' :
                AUIGrid.resize(memInfoGridID, 920, 300);
                break;
            case 'docInfo' :
                AUIGrid.resize(docGridID, 920, 300);
                if(AUIGrid.getRowCount(docGridID) <= 0) {
                    fn_selectDocumentList();
                }
                break;
            case 'callLogInfo' :
                AUIGrid.resize(callLogGridID, 920, 300);
                if(AUIGrid.getRowCount(callLogGridID) <= 0) {
                    fn_selectCallLogList();
                }
                break;
            case 'payInfo' :
                AUIGrid.resize(payGridID, 920, 300);
                if(AUIGrid.getRowCount(payGridID) <= 0) {
                    fn_selectPaymentList();
                }
                break;
            case 'transInfo' :
                AUIGrid.resize(transGridID, 920, 300);
                if(AUIGrid.getRowCount(transGridID) <= 0) {
                    fn_selectTransList();
                }
                break;
            case 'autoDebitInfo' :
                AUIGrid.resize(autoDebitGridID, 920, 300);
                if(AUIGrid.getRowCount(autoDebitGridID) <= 0) {
                    fn_selectAutoDebitList();
                }
                break;
            case 'discountInfo' :
                AUIGrid.resize(discountGridID, 920, 300);
                if(AUIGrid.getRowCount(discountGridID) <= 0) {
                    fn_selectDiscountList();
                }
                break;
        };
    }

    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    function fn_setKeyInDate() {
        var today = new Date();

        var dd = today.getDate();
        var mm = today.getMonth() + 1;
        var yyyy = today.getFullYear();

        if(dd < 10) {
            dd = "0" + dd;
        }
        if(mm < 10){
            mm = "0" + mm
        }

        today = dd + "/" + mm + "/" + yyyy;
        $("#_inputRequestDate").val(today);
    }

    function fn_setAutoFile2() {
        $(".auto_file2").append("<label><input type='text' class='input_text' readonly='readonly' /><span class='label_text'><a href='#'>File</a></span></label><span class='label_text'><a id='btnfileDel'>Delete</a></span>");
    }

    function fn_saveNewCpeRequest() {

        var checkResult = fn_checkEmptyFields();

        if(!checkResult){
            return false;
        }

        var formData = Common.getFormData("form_newReqst");
        var obj = $("#form_newReqst").serializeJSON();
        console.log(obj)
        $.each(obj, function(key, value) {
          formData.append(key, value);
        });

        Common.ajaxFile("/services/ecom/insertEcpeReqst.do", formData, function(result) {
            console.log(result);
            $("#_cpeReqId").val(result.data.cpeReqId);
            Common.alert('<spring:message code="newCpe.save.msg" /><br/> Request ID: ' + result.data.cpeReqId, fn_closePopNoApprovalRqrd);
        });
    }

    function fn_checkEmptyFields() {
        var checkResult = true;

        if (FormUtil.isEmpty($("#_inputReqTypeSelect").val())) {
            Common.alert('<spring:message code="cpe.requestType.msg" />');
            checkResult = false;
        }

        if (FormUtil.isEmpty($("#_inputMainDeptSelect").val())) {
            Common.alert('<spring:message code="cpe.mainDept.msg" />');
            checkResult = false;
        }

        if (FormUtil.isEmpty($("#_inputSubDeptSelect").val())) {
            Common.alert('<spring:message code="cpe.dscBrnch.msg" />');
            checkResult = false;
        }

        if (FormUtil.isEmpty($('#reqAttchFile').val().trim())) {
            Common.alert('Please upload attachment.');
            checkResult = false;
          }

        if("" != $("#cntcEmail").val() && null != $("#cntcEmail").val()){

            if(FormUtil.checkEmail($("#cntcEmail").val())){
                 Common.alert('<spring:message code="sal.alert.msg.invaildEmailAddr" />');
                 return;
            }
        }

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

        if($("#areaId").val().trim() == ''){
            Common.alert('Area not found. <br/> Please check with System Administrator.');
            return ;
        }

        //Tel
        if(("" != $("#cntcTelm").val().trim() || null != $("#cntcTelm").val().trim()) && ("" != $("#cntcTelr").val().trim() || null != $("#cntcTelr").val().trim())
                && ("" != $("#cntcTelo").val().trim() || null != $("#cntcTelo").val().trim()) && ("" != $("#cntcTelf").val().trim() || null != $("#cntcTelf").val().trim())){


            // telm(Mobile)
            if("" != $("#cntcTelm").val().trim() && null != $("#cntcTelm").val().trim()){
                if(FormUtil.checkNum($("#cntcTelm"))){
                    Common.alert('<spring:message code="sal.alert.msg.invaildTelNumM" />');
                    return;
                }else if($("#cntcTelm").val().substring(0,3) == "015"){
                    Common.alert('<spring:message code="sal.alert.msg.incorrectMobilePrefix" />');
                    return;
                }else if($("#cntcTelm").val().substring(0,2) != "01"){
                    Common.alert('<spring:message code="sal.alert.msg.incorrectMobilePrefix" />');
                    return;
                }else if($("#cntcTelm").val().length < 9 || $("#cntcTelm").val().length > 12){
                    Common.alert('<spring:message code="sal.alert.msg.incorrectMobileNumberLength" />');
                    return;
                }

            }
            // telr(Residence)
            if("" != $("#cntcTelr").val().trim() && null != $("#cntcTelr").val().trim()){
                if(FormUtil.checkNum($("#cntcTelr"))){
                    Common.alert('<spring:message code="sal.alert.msg.invaildTelNumR" />');
                    return;
                }else if($("#cntcTelr").val().length < 9 || $("#cntcTelr").val().length > 12){
                    Common.alert('<spring:message code="sal.alert.msg.incorrectMobileNumberLength" />');
                    return;
                }
            }
            // telo(Office)
            if("" != $("#cntcTelo").val().trim() && null != $("#cntcTelo").val().trim()){
                if(FormUtil.checkNum($("#cntcTelo"))){
                    Common.alert('<spring:message code="sal.alert.msg.invaildTelNumO" />');
                    return;
                }else if($("#cntcTelo").val().length < 9 || $("#cntcTelo").val().length > 12){
                    Common.alert('<spring:message code="sal.alert.msg.incorrectMobileNumberLength" />');
                    return;
                }

            }
            // telf(Fax)
//             if("" != $("#cntcTelf").val() && null != $("#cntcTelf").val()){
//                 if(FormUtil.checkNum($("#cntcTelf"))){
//                     Common.alert('<spring:message code="sal.alert.msg.invaildTelNumF" />');
//                     return;
//                 }else if($("#cntcTelf").val().length < 9 || $("#cntcTelf").val().length > 12){
//                     Common.alert('<spring:message code="sal.alert.msg.incorrectMobileNumberLength" />');
//                     return;
//                 }
//             }
        }

        return checkResult;
    }

    function fn_closePopNoApprovalRqrd() {
        $("#eCpeNewSearchResultPop").remove();
        $("#eCpeRequestNewSearchPop").remove();

    }

    function fn_doMail(v) {
        if (v.checked) {
        	$("#isMailing").val("1");
        }
        else {
        	$("#isMailing").val("0");
        }
    }

    function fn_validHPCodyContactNumber(contactNumber, fieldId){
        if(contactNumber != ""){
            Common.ajax("GET", "/sales/customer/existingHPCodyMobile", {contactNumber : contactNumber} , function(result) {
                if(result != null){
                    Common.
                    alert("<spring:message code='sal.alert.msg.existingHPCodyMobile' arguments = '" + result.fullName + " ; " + result.memCode+"' htmlEscape='false' argumentSeparator=';' />");
                    //$("#" + fieldId).val('');
                    return;
                }
           });
        }
    }

    function fn_selectState(selVal){

        let tempVal = selVal;

        if('' == selVal || null == selVal){
            //전체 초기화
            fn_initAddress();

        }else{

            $("#mCity").attr({"disabled" : false  , "class" : "form-control"});

            $('#mPostCd').append($('<option>', { value: '', text: '3. Post Code' }));
            $('#mPostCd').val('');
            $("#mPostCd").attr({"disabled" : "disabled"  , "class" : "form-control disabled"});

            $('#mArea').append($('<option>', { value: '', text: '4. Area' }));
            $('#mArea').val('');
            $("#mArea").attr({"disabled" : "disabled"  , "class" : "form-control disabled"});

            //Call ajax
            let cityJson = {state : tempVal}; //Condition
            CommonCombo.make('mCity', "/enquiry/selectMagicAddressComboList.do", cityJson, '' , optionCity);
        }
    }

    function fn_selectCity(selVal){
        let tempVal = selVal;

        if('' == selVal || null == selVal){

             $('#mPostCd').append($('<option>', { value: '', text: '3. Post Code' }));
             $('#mPostCd').val('');
             $("#mPostCd").attr({"disabled" : "disabled"  , "class" : "form-control disabled"});

             $('#mArea').append($('<option>', { value: '', text: '4. Area' }));
             $('#mArea').val('');
             $("#mArea").attr({"disabled" : "disabled"  , "class" : "form-control disabled"});

        }else{

             //$("#mPostCd").attr({"disabled" : false  , "class" : "form-control"});
             $('#mPostCd').append($('<option>', { value: '', text: '3. Post Code' }));
             $('#mPostCd').val('');
             $("#mPostCd").attr({"disabled" : "disabled"  , "class" : "form-control disabled"});

             $('#mArea').append($('<option>', { value: '', text: '4. Area' }));
             $('#mArea').val('');
             $("#mArea").attr({"disabled" : "disabled"  , "class" : "form-control disabled"});

            //Call ajax
            let postCodeJson = {state : $("#mState").val() , city : tempVal}; //Condition
            CommonCombo.make('mPostCd', "/enquiry/selectMagicAddressComboList.do", postCodeJson, '' , optionPostCode);
        }
    }

    function fn_selectDefaultPostCode(selVal){
        let tempVal = selVal;

        if('' == selVal || null == selVal){

            $('#mArea').append($('<option>', { value: '', text: '4. Area' }));
            $('#mArea').val('');
            $("#mArea").attr({"disabled" : "disabled"  , "class" : "form-control disabled"});

        }else{
            //$("#mArea").attr({"disabled" : false  , "class" : "form-control"});
            //Call ajax
            areaJson = {state : $("#mState").val(), city : $("#mCity").val() , postcode : tempVal}; //Condition
            CommonCombo.make('mArea', "/enquiry/selectMagicAddressComboList.do", areaJson, '' , optionArea);
        }
    }

    function fn_selectPostCode(selVal){
        let tempVal = selVal;

        if('' == selVal || null == selVal){

            $('#mArea').append($('<option>', { value: '', text: '4. Area' }));
            $('#mArea').val('');
            $("#mArea").attr({"disabled" : "disabled"  , "class" : "form-control disabled"});

        }else{
            $("#mArea").attr({"disabled" : false  , "class" : "form-control"});
            //Call ajax
            areaJson = {state : $("#mState").val(), city : $("#mCity").val() , postcode : tempVal}; //Condition
            CommonCombo.make('mArea', "/enquiry/selectMagicAddressComboList.do", areaJson, '' , optionArea);
        }
    }

    //Get Area Id
    function fn_getDefaultAreaId(){

        let statValue = {state : $("#mState").val()};
        let cityValue = {city : $("#mCity").val()};
        let postCodeValue = {postcode : $("#mPostCd").val()};
        let areaValue = {area : $("#mArea").val()};

            let jsonObj = { statValue : "${orderDetail.installationInfo.instState}" ,
                                  cityValue : "${orderDetail.installationInfo.instCity}",
                                  postCodeValue : "${orderDetail.installationInfo.instPostcode}",
                                  areaValue : "${orderDetail.installationInfo.instArea}"
                                };
            Common.ajax("GET", "/enquiry/getAreaId.do", jsonObj, function(result) {
                 $("#areaId").val(result.areaId);
            });

    }

    //Get Area Id
    function fn_getAreaId(){

        let statValue = $("#mState").val();
        let cityValue = $("#mCity").val();
        let postCodeValue = $("#mPostCd").val();
        let areaValue = $("#mArea").val();

        if('' != statValue && '' != cityValue && '' != postCodeValue && '' != areaValue){

            let jsonObj = { statValue : statValue ,
                                  cityValue : cityValue,
                                  postCodeValue : postCodeValue,
                                  areaValue : areaValue
                                };
            Common.ajax("GET", "/services/ecom/getAreaId.do", jsonObj, function(result) {
                 $("#areaId").val(result.areaId);

                 $("#_inputSubDeptSelect").val(result.brnchId);
                 console.log("ni ma de");
                 doGetComboSepa('/common/selectBranchCodeList.do',  '5', ' - ', $("#_inputSubDeptSelect").val(),   '_inputSubDeptSelect', 'S', ''); //Branch Code

            });
        }
    }

    function fn_initAddress(){

        $('#mCity').append($('<option>', { value: '', text: '2. City' }));
        $('#mCity').val('');
        $("#mCity").attr({"disabled" : "disabled"  , "class" : "form-control disabled"});

        $('#mPostCd').append($('<option>', { value: '', text: '3. Post Code' }));
        $('#mPostCd').val('');
        $("#mPostCd").attr({"disabled" : "disabled"  , "class" : "form-control disabled"});

        $('#mArea').append($('<option>', { value: '', text: '4. Area' }));
        $('#mArea').val('');
        $("#mArea").attr({"disabled" : "disabled"  , "class" : "form-control disabled"});
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
        Common.popupDiv('/sales/customer/searchMagicAddressPop.do' , $('#form_newReqst').serializeJSON(), null , true, '_searchDiv');

       $("#mPostCd").attr({"disabled" : false  , "class" : "w100p"});
    }

    function resetAreaId(){
        $("#areaId").val("");
    }

    function setAreaInfo(){
        fn_addMaddr($("#area").val(), $("#city").val(), $("#postcode").val(), $("#state").val(), $("#areaId").val(), $("#iso").val());
    }

    function goPrevPage(){
        window.location = "/enquiry/selectCustomerInfo.do";
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

            var areaJson = {state : mstate , city : mcity , postcode : mpostcode}; //Condition
            CommonCombo.make('mArea', "/sales/customer/selectMagicAddressComboList", areaJson, marea , optionArea,fn_getAreaId);

            $("#areaId").val(areaid);
            $("#_searchDiv").remove();
        }else{
            Common.alert('<spring:message code="sal.alert.msg.addrCheck" />');
        }
    }

</script>
<input type="hidden" />
<input type="hidden" />
<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->
    <header class="pop_header"><!-- pop_header start -->
        <h1><spring:message code="sal.title.text.cpeNewSrch" /></h1>
        <ul class="right_opt">
            <li><p class="btn_blue2"><a id="_cpeResultPopCloseBtn"><spring:message code="sal.btn.close" /></a></p></li>
        </ul>
    </header><!-- pop_header end -->

    <section class="pop_body"><!-- pop_body start -->
        <section class="search_table"><!-- search_table start -->
            <form id="_newOrderAddForm">
                <input id="_addOrdId" name="addOrdId" type="hidden" >
            </form>

            <form action="#" method="get" id="_searchForm">
                <input id="salesOrderId" name="salesOrderId" type="hidden" value="${orderDetail.basicInfo.ordId}">
                <table class="type1"><!-- table start -->
                    <caption>table</caption>
                    <colgroup>
                        <col style="width:180px" />
                        <col style="width:*" />
                    </colgroup>
                    <tbody>
                        <tr id="_resultTr" >
                            <th scope="row"><spring:message code="sal.text.ordNo" /></th>
                            <td><input type="text" title="" placeholder="" class=""  value="${salesOrderNo}" readonly="readonly"/><p class="btn_sky"><a href="#" id="_reSelect"><spring:message code="sal.btn.reselect" /></a></p></td>
                        </tr>
                    </tbody>
                </table><!-- table end -->
            </form>
    </section><!-- search_table end -->

    <section class="search_result" id="_searchResultSection" ><!-- search_result start -->


        <aside class="title_line"><!-- title_line start -->
            <h3><spring:message code="cpe.title.helpdeskRequest" /></h3>
        </aside><!-- title_line end -->
        <form id="form_newReqst">
            <input type="hidden" name="salesOrdId" id="_salesOrdId" value="${orderDetail.basicInfo.ordId}" />
            <input type="hidden" name="ordStusId" id="_ordStusId" value="${orderDetail.basicInfo.ordStusId}" />
            <input type="hidden" name="salesOrdNo" id="_salesOrdNo" value="${orderDetail.basicInfo.ordNo}" />
            <input type="hidden" name="custId" id="_custId" value="${orderDetail.basicInfo.custId}" />
            <input type="hidden" name="cpeReqId" id="_cpeReqId" />
            <input type="hidden" name="approvalRequired" id="_approvalRequired" />
            <input type="hidden" id="areaId" name="areaId">
           <input type="hidden" value="${SESSION_INFO.custId}" id="_insCustId" name="insCustId">
           <input type="hidden" name="addrCustAddId" id="addrCustAddId">
           <input type="hidden" name="orderId" id="orderId" value="${orderId}">
           <input type="hidden" name="orderNo"  value="${orderNo}">
           <input type="hidden" id="area" name="area">
           <input type="hidden" id="city" name="city">
           <input type="hidden" id="state" name="state">
           <input type="hidden" id="postcode" name="postcode">
           <input type="hidden" id="iso" name="iso">
            <table class="type1"><!-- table start -->
                <caption>table</caption>
                <colgroup>
                    <col style="width:140px" />
                    <col style="width:260px" />
                    <col style="width:160px" />
                    <col style="width:*" />
                    <col style="width:140px" />
                    <col style="width:*" />
                </colgroup>
                <tbody>
                    <tr>
                        <th scope="row"><spring:message code="sal.text.requestDate" /></th>
                        <td>
                            <div class="date_set w100p"><!-- date_set start -->
                                <p><input type="text" title="Create Request Date" placeholder="DD/MM/YYYY" class="j_date"  name="inputRequestDate" id="_inputRequestDate" readonly="readonly"/></p>
                            </div><!-- date_set end -->
                        </td>
                        <th scope="row"><spring:message code="service.grid.mainDept" /><span class="must">*</span></th>
                        <td colspan="3">
                            <select class="w100p" name="mainDept" id="_inputMainDeptSelect">
                                <c:forEach var="list" items="${mainDeptList}" varStatus="status">
                                    <c:choose>
                                         <c:when test="${list.codeId == 'MD23'}">
                                            <option value="${list.codeId}" selected="selected">${list.codeName} </option>
                                        </c:when>
                                    </c:choose>
                                </c:forEach>
                            </select></td>
                    </tr>
                    <tr>
                        <th scope="row">Reason<span class="must">*</span></th>
                        <td><select class="w100p" name="inputReqTypeSelect" id="_inputReqTypeSelect"></select></td>
                        <th scope="row">DSC Branch<span class="must">*</span></th>
                        <td colspan="3"><select class="w100p" name="subDept" id="_inputSubDeptSelect"></select></td>
                    </tr>
                    <tr>
                        <th scope="row"><spring:message code='cpe.attachment' /><span class="must">*</span></th>
                        <td colspan="5">
                            <div class="auto_file2">
                                <!-- auto_file2 start -->
                                <input id="reqAttchFile" name="reqAttchFile" type="file" title="file add" />
                            </div><!-- auto_file2 end -->
                        </td>

                    </tr>
                </tbody>
            </table><!-- table end -->

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
                        <th scope="row" ><spring:message code="sal.text.addressDetail" /></th>
                        <td>
                        <input type="text" title="" id="addrDtl" name="addrDtl" placeholder="eg. NO 10/UNIT 13-02-05/LOT 33945" class="w100p" maxlength="100" value="${orderDetail.installationInfo.instAddrDtl}" />
                        </td>
                    </tr>
                    <tr>
                        <th scope="row" ><spring:message code="sal.text.street" /></th>
                        <td>
                        <input type="text" title="" id="streetDtl" name="streetDtl" placeholder="eg. TAMAN/JALAN/KAMPUNG" class="w100p" maxlength="100" value="${orderDetail.installationInfo.instStreet}" />
                        </td>
                    </tr>
                    <tr>
                        <th scope="row"><spring:message code="sal.text.state1" /></th>
                        <td>
                        <select class="w100p" id="mState"  name="mState"  onchange="javascript : fn_selectState(this.value)" ></select>
                        </td>
                    </tr>
                    <tr>
                         <th scope="row"><spring:message code="sal.text.city2" /></th>
                        <td>
                        <select class="w100p" id="mCity"  name="mCity" onchange="javascript : fn_selectCity(this.value)" ></select>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row"><spring:message code="sal.text.streetSearch3" /></th>
                        <td>
                        <input type="text" title="" id="searchSt" name="searchSt" placeholder="" class="" style="width:155px;"/><a href="#" onclick="fn_addrSearch()" class="search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
                        </td>
                    </tr>
                    <tr>
                         <th scope="row"><spring:message code="sal.text.postCode4" /></th>
                        <td>
                        <select class="w100p" id="mPostCd"  name="mPostCd" onchange="javascript : fn_selectPostCode(this.value)"></select>
                        </td>
                    </tr>
                    <tr>
                       <th scope="row"><spring:message code="sal.text.area5" /></th>
                        <td>
                        <select class="w100p" id="mArea"  name="mArea" onchange="javascript : fn_getAreaId()"></select>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row"><spring:message code="sal.text.country" /></th>
                        <td>
                        <input type="text" title="" id="mCountry" name="mCountry" placeholder="" class="w100p readonly" readonly="readonly" value="${orderDetail.installationInfo.instCountry}"/>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row"><spring:message code="sal.text.telM" /></th>
                    <td><input type="text" title="" placeholder="" class="w100p"   id="cntcTelm" name="cntcTelm" maxlength="11" onblur="javascript: fn_validHPCodyContactNumber(this.value,this.id);" value="${orderDetail.installationInfo.instCntTelM}" /></td>
                    </tr>
                    <tr>
                        <th scope="row"><spring:message code="sal.text.telO" /></th>
                    <td><input type="text" title="" placeholder="" class="w100p"  id="cntcTelo" name="cntcTelo" maxlength="11" onblur="javascript: fn_validHPCodyContactNumber(this.value,this.id);" value="${orderDetail.installationInfo.instCntTelO}" /></td>
                    </tr>
                    <tr>
                        <th scope="row"><spring:message code="sal.text.telR" /></th>
                    <td><input type="text" title="" placeholder="" class="w100p"   id="cntcTelr" name="cntcTelr" maxlength="11" onblur="javascript: fn_validHPCodyContactNumber(this.value,this.id);" value="${orderDetail.installationInfo.instCntTelR}"/></td>
                    </tr>
                    <tr>
                        <th scope="row"><spring:message code="sal.text.telF" /></th>
                    <td><input type="text" title="" placeholder="Telephone Number(Fax)" class="w100p"   id="cntcTelf" name="cntcTelf" maxlength="11" onblur="javascript: fn_validHPCodyContactNumber(this.value,this.id);" value="${orderDetail.installationInfo.instCntTelF}" /></td>
                    </tr>
                    <tr>
                        <th scope="row"><spring:message code="sal.text.email" /></th>
                        <td><input type="text" title="" placeholder="" class="w100p"  id="cntcEmail" name="cntcEmail" maxlength="70" value="${orderDetail.installationInfo.instCntEmail}" /></td>
                    </tr>
                    <tr>
                        <th scope="row">Mailing Address?</th>
                        <td>
                        <input id="isMailing" name="isMailing" type="checkbox" onclick="fn_doMail(this)" value="1" checked />
                        </td>
                    </tr>
                </tbody>
            </table><!-- table end -->

            <ul class="center_btns">
                <li><p class="btn_blue2 big"><a href="#" id="_submitBtn"><spring:message code="cpe.btn.submit" /></a></p></li>
            </ul>
        </form>

        </section><!-- search_result end -->
    </section><!-- content end -->
</div>