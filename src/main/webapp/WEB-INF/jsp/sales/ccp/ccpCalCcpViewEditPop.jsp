<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javascript">

var optionUnit = { isShowChoose: false};
var optionModule = {
        type: "S",                  
        isShowChoose: false  
};


$(function() {
    $('#_updSmsMsg').keyup(function (e){
        
        var content = $(this).val();
        
       // $(this).height(((content.split('\n').length + 1) * 2) + 'em');
        
        $('#_charCounter').html('Total Character(s) : '+content.length);
    });
    $('#_updSmsMsg').keyup();
});


$(document).ready(function() {
    
    //to List
    $("#_btnList").click(function() {
    	window.close();
    });
    
    $("#_btnClose").click(function() {
    	window.close();
	});
    
    //Init
    var mst = getMstId();
    var ordUnitSelVal = $("#_ordUnitSelVal").val();
    var rosUnitSelVal = $("#_rosUnitSelVal").val();
    var susUnitSelVal = $("#_susUnitSelVal").val();
    var custUnitSelVal = $("#_custUnitSelVal").val();
    
    getUnitCombo(mst, 212  , ordUnitSelVal , '_ordUnit');
    getUnitCombo(mst, 213  , rosUnitSelVal , '_ordMth');
    getUnitCombo(mst, 216  , susUnitSelVal , '_ordSuspen');
    getUnitCombo(mst, 210  , custUnitSelVal , '_ordExistingCust');  
   
    //Income Range ComboBox
    var ccpId = $("#_editCcpId").val();
    
    var rentPayModeId = $("#_rentPayModeId").val();
    var applicantTypeId = $("#_applicantTypeId").val();
    console.log("applicantTypeId : " + applicantTypeId);
    console.log("rentPayModeId : " + rentPayModeId);
    var selVal = '';
    if(rentPayModeId == 131){
        if(applicantTypeId == 964){
            selVal = '29';
        }else{
            selVal = '22';
        }
    }
    //doGetCombo('/sales/ccp/getLoadIncomeRange', {editCcpId : ccpId} , selVal ,'_incomeRangeEdit', 'S');
    CommonCombo.make('_incomeRangeEdit', '/sales/ccp/getLoadIncomeRange' , {editCcpId : ccpId}, selVal , optionModule);
    
    //Ccp Status
    var ccpStus = $("#_ccpStusId").val();
    doGetCombo('/sales/ccp/getCcpStusCodeList', '', ccpStus,'_statusEdit', 'S'); 
    //Reject
    doGetCombo('/sales/ccp/getCcpRejectCodeList', '', '','_rejectStatusEdit', 'S'); //Status
    //Feedback
    var selReasonCode = $("#_ccpResnId").val();
    doGetCombo('/sales/ccp/selectReasonCodeFbList', '', selReasonCode,'_reasonCodeEdit', 'S'); //Reason
    
    //Bind Filed
    bind_RetrieveData();
    
    //Disabled ComboBox
    $("#_ordUnit").attr({"disabled" : "disabled" , "class" : "w100p disabled"});
    $("#_ordMth").attr({"disabled" : "disabled" , "class" : "w100p disabled"});
    $("#_ordSuspen").attr({"disabled" : "disabled" , "class" : "w100p disabled"});
    $("#_ordExistingCust").attr({"disabled" : "disabled" , "class" : "w100p disabled"});
     
    //SMS Checked
    // Consignment Change
    $("#_updSmsChk").change(function() {
        
        //Init
        $("#_updSmsMsg").val('');
        $("#_updSmsMsg").attr("disabled" , "disabled");
        if($("#_updSmsChk").is(":checked") == true){
            
            if(isAllowSendSMS() == true){
                
                $("#_updSmsMsg").attr("disabled" , false);
                setSMSMessage();
            }
        }
        
    });
    
    //Save
    $("#_calBtnSave").click(function() {
    
        //Validation
        if( null == $("#_statusEdit").val() || '' == $("#_statusEdit").val()){
             Common.alert("<spring:message code='sys.common.alert.validation' arguments='CCP Status'/>");
             return;
        }else{
            if( '6' == $("#_statusEdit").val()){
                if(null == $("#_rejectStatusEdit").val() || '' == $("#_rejectStatusEdit").val()){
                    Common.alert("<spring:message code='sys.common.alert.validation' arguments='CCP Reject Status'/>");
                    return;
                }
            }
            if( '6' == $("#_statusEdit").val() || '1' == $("#_statusEdit").val()){
                if(null == $("#_reasonCodeEdit").val() || '' == $("#_reasonCodeEdit").val()){
                    Common.alert("<spring:message code='sys.common.alert.validation' arguments='CCP Feedback Code'/>");
                    return;
                }
            }
        }
        if( null == $("#_incomeRangeEdit").val() || '' == $("#_incomeRangeEdit").val()){
            Common.alert("<spring:message code='sys.common.alert.validation' arguments='Income Range'/>");
            return;
        }
        if( null == $("#_ficoScore").val() || '' == $("#_ficoScore").val()){
            Common.alert("<spring:message code='sys.common.alert.validation' arguments='Fico Score' />");
            return;
        }else{
            if( $("#_ficoScore").val() > 850 || $("#_ficoScore").val() < 300 && $("#_ficoScore").val() !=  0){
                Common.alert("* Please key in FICO score range between 300 to 850 points.");
                return;
            }
        }
        
        //Validation (Call Entry Count)
        var ccpOrdEditId = $("#_editOrdId").val();
        var salData = {salesOrdId : ccpOrdEditId};
        console.log(salData);
        var callEntCount = 0;
        Common.ajax("GET", "/sales/ccp/countCallEntry", salData , function(result) {
            callEntCount = result.totCount;
            console.log("Call Entry Count : " + callEntCount);
        });
        
        if(callEntCount > 0){
            Common.alert(" * Order already exists in call entry.");
            return;
        }
       //Validation Success - Save
       //Check box params Setting 
       //_letterOfUdt
       if($("#_letterOfUdt").is(":checked") == true){
           $("#_letterOfUdt").val("1");
       }else{
           $("#_letterOfUdt").val("0");
       }
       //_summon  
       if($("#_summon").is(":checked") == true){
           $("#_summon").val("1");
       }else{
           $("#_summon").val("0");
       } 
       //_onHoldCcp
       if($("#_onHoldCcp").is(":checked") == true){
           $("#_onHoldCcp").val("1");
       }else{
           $("#_onHoldCcp").val("0");
       }
       //SMS
       if($("#_updSmsChk").is(":checked") == true){
           $("#_isChkSms").val("1");
           
           //msg setting
           var realMsg =   $("#_updSmsMsg").val();
           $("#_hiddenUpdSmsMsg").val(realMsg); //msg contents
           var salesmanPhNum = $("#_editSalesManTelMobile").val();
           $("#_hiddenSalesMobile").val(salesmanPhNum);
           
       }else{
           $("#_isChkSms").val("0");
       }
       calSave();
        
    });//Save End
    
    
});//Doc Ready Func End

function calSave(){
    
    var ordUnit = $("#_ordUnit").val();
    var rosUnit = $("#_ordMth").val();
    var susUnit = $("#_ordSuspen").val();
    var custUnit = $("#_ordExistingCust").val();
    
    $("#_saveOrdUnit").val(ordUnit);
    $("#_saveRosUnit").val(rosUnit);
    $("#_saveSusUnit").val(susUnit);
    $("#_saveCustUnit").val(custUnit);
    
    Common.ajax("POST", "/sales/ccp/calSave", $("#calSaveForm").serializeJSON() , function(result) {
        
        var msg = "";
        
        msg += "success <br/>";
        msg += result.message; //SMS Result
        
        Common.alert(msg);
        //Btn Disabled
        $("#_calBtnSave").css("display" , "none");
        
        //Make View
        $("#_ordUnit").attr({"disabled" : "disabled" , "class" : "w100p disabled"});
        $("#_ordMth").attr({"disabled" : "disabled" , "class" : "w100p disabled"});
        $("#_ordSuspen").attr({"disabled" : "disabled" , "class" : "w100p disabled"});
        $("#_ordExistingCust").attr({"disabled" : "disabled" , "class" : "w100p disabled"});
        
        $("#_statusEdit").attr({"disabled" : "disabled" , "class" : "w100p disabled"});
        $("#_incomeRangeEdit").attr({"disabled" : "disabled" , "class" : "w100p disabled"});
        $("#_rejectStatusEdit").attr({"disabled" : "disabled" , "class" : "w100p disabled"});
        $("#_reasonCodeEdit").attr({"disabled" : "disabled" , "class" : "w100p disabled"});
        $("#_spcialRem").attr({"disabled" : "disabled" , "class" : "w100p disabled"});
        $("#_pncRem").attr({"disabled" : "disabled" , "class" : "w100p disabled"});
        
        $("#_letterOfUdt").attr({"disabled" : "disabled" , "class" : "w100p disabled"});
        $("#_summon").attr({"disabled" : "disabled" , "class" : "w100p disabled"});
        $("#_onHoldCcp").attr({"disabled" : "disabled" , "class" : "w100p disabled"});
        $("#_updSmsChk").attr({"disabled" : "disabled" , "class" : "w100p disabled"});
        $("#_updSmsMsg").attr({"disabled" : "disabled" , "class" : "w100p disabled"});
        $("#_ficoScore").attr({"disabled" : "disabled" , "class" : "w100p disabled"});
        
        $("#_calSearch").click();
    });
    
}




function fn_ccpStatusChangeFunc(getVal){
    
    //Init
    $("#_smsDiv").css("display" , "none");
    $("#_updSmsChk").attr("checked" , false);
    $("#_updSmsMsg").val('');
    $("#_updSmsMsg").attr("disabled" , "disabled");
    
    if(getVal != null && getVal != ''){
        
        if(getVal == '1'){
            
            //field 
            $("#_incomeRangeEdit").attr("disabled" , false);
            $("#_rejectStatusEdit").attr({"disabled" : "disabled" , "class" : "w100p disabled"});
            $("#_reasonCodeEdit").attr("disabled" , false);
            $("#_spcialRem").attr("disabled" , false);
            $("#_pncRem").attr("disabled" , false);
            
           if($("#_editCustTypeId").val() == '964' && $("#_editCustNation").val() == 'MALAYSIA'){
               $("#_ficoScore").attr("disabled" , false);
           }else{
               $("#_ficoScore").val("0");
               $("#_ficoScore").attr("disabled" , "disabled");
           }
           
             //chkbox
            $("#_onHoldCcp").attr("disabled" , false);
            $("#_summon").attr("disabled" , false);
            $("#_letterOfUdt").attr("disabled" , false);
            
            if(isAllowSendSMS() == true){
                
                $("#_smsDiv").css("display" , "");
                $("#_updSmsChk").attr("checked" , true);
                $("#_updSmsMsg").attr("disabled" , false);
                setSMSMessage();
            }
            
        }else if(getVal == '5'){
            
             //field //FICO it doesn`t work
             $("#_incomeRangeEdit").attr("disabled" , false);
             $("#_rejectStatusEdit").val('');
             $("#_rejectStatusEdit").attr({"disabled" : "disabled" , "class" : "w100p disabled"});
             $("#_reasonCodeEdit").attr("disabled" , false);
             $("#_spcialRem").attr("disabled" , false);
             $("#_pncRem").attr("disabled" , false);
             
              //chkbox
             $("#_onHoldCcp").attr("checked" , false);
             $("#_onHoldCcp").attr("disabled" , "disabled");
             $("#_summon").attr("disabled" , false);
             $("#_letterOfUdt").attr("disabled" , false);
            
             //Fico Ajax Call
             var ccpid = $("#_editCcpId").val();
             var data = {ccpId : ccpid};
             Common.ajax("GET", "/sales/ccp/getFicoScoreByAjax", data , function(result) {
                 $("#_ficoScore").val(result.ccpFico);
                 $("#_ficoScore").attr("disabled" , false);
             });
             
             if(isAllowSendSMS() == true){
                    
                    $("#_smsDiv").css("display" , "");
                    $("#_updSmsChk").attr("checked" , true);
                    $("#_updSmsMsg").attr("disabled" , false);
                    setSMSMessage();
             }
        }else if(getVal == '6'){
            
            //field
            $("#_incomeRangeEdit").attr("disabled" , false);
            $("#_rejectStatusEdit").attr({"disabled" : false , "class" : "w100p"});
            $("#_reasonCodeEdit").attr("disabled" , false);
            $("#_spcialRem").attr("disabled" , false);
            $("#_pncRem").attr("disabled" , false);
            //chkbox
            $("#_onHoldCcp").attr("checked" , false);
            $("#_onHoldCcp").attr("disabled" , "disabled");
            $("#_summon").attr("disabled" , false);
            $("#_letterOfUdt").attr("disabled" , false);
            
            $("#_ficoScore").val("0");
            $("#_ficoScore").attr("disabled" , "disabled");
            
        }
        
    }
    
}

function  bind_RetrieveData(){

    var ccpStus = $("#_ccpStusId").val();
    //pre Value
    $("#_isPreVal").val("1");
    //Fico
     if($("#_editCustTypeId").val() == '964' && $("#_editCustNation").val() == 'MALAYSIA'){
         $("#_ficoScore").attr("disabled" , false);
     }else{
         $("#_ficoScore").val("0");
         $("#_ficoScore").attr("disabled" , "disabled");
     }
    //bind and Setting by CcpStatus
    if(ccpStus == "1"){
        
        //field
        $("#_incomeRangeEdit").attr("disabled" , false);
        $("#_rejectStatusEdit").val('');
        $("#_rejectStatusEdit").attr({"disabled" : "disabled" , "class" : "w100p disabled"});
        $("#_reasonCodeEdit").attr("disabled" , false);
        $("#_spcialRem").attr("disabled" , false);
        $("#_pncRem").attr("disabled" , false);
        //chkbox
        $("#_onHoldCcp").attr("disabled" , false);
        $("#_summon").attr("disabled" , false);
        $("#_letterOfUdt").attr("disabled" , false);
        
        if(isAllowSendSMS() == true){
            
            $("#_smsDiv").css("display" , "");
            $("#_updSmsChk").attr("checked" , true);
            $("#_updSmsMsg").attr("disabled" , false);
            setSMSMessage();
        }
    }else if(ccpStus == "5"){
        
        //field
        $("#_incomeRangeEdit").attr("disabled" , false);
        $("#_rejectStatusEdit").val('');
        $("#_rejectStatusEdit").attr({"disabled" : "disabled" , "class" : "w100p disabled"});
        $("#_reasonCodeEdit").attr("disabled" , false);
        $("#_spcialRem").attr("disabled" , false);
        $("#_pncRem").attr("disabled" , false);
        //chkbox
        $("#_onHoldCcp").attr("checked" , false);
        $("#_onHoldCcp").attr("disabled" , "disabled");
        $("#_summon").attr("disabled" , false);
        $("#_letterOfUdt").attr("disabled" , false);
        
        if(isAllowSendSMS() == true){
            
            $("#_smsDiv").css("display" , "");
            $("#_updSmsChk").attr("checked" , true);
            $("#_updSmsMsg").attr("disabled" , false);
            setSMSMessage();
        }
    }else if(ccpStus == "6"){
        
        //field
        $("#_incomeRangeEdit").attr("disabled" , false);
        $("#_rejectStatusEdit").attr("disabled" , false);
        $("#_reasonCodeEdit").attr("disabled" , false);
        $("#_spcialRem").attr("disabled" , false);
        $("#_pncRem").attr("disabled" , false);
        //chkbox
        $("#_onHoldCcp").attr("checked" , false);
        $("#_onHoldCcp").attr("disabled" , "disabled");
        $("#_summon").attr("disabled" , false);
        $("#_letterOfUdt").attr("disabled" , false);
        
    }
    
    //Set Check Box
    var ccpIsHold = $("#_ccpIsHold").val() == '1' ? true : false;
    var ccpIsSaman = $("#_ccpIsSaman").val() == '1' ? true : false;
    var ccpIsLou = $("#_ccpIsLou").val() == '1' ? true : false;
    
    
    if(ccpIsHold == true){
        $("#_onHoldCcp").attr("checked" , true);
    }
    
    if(ccpIsSaman == true){
        $("#_summon").attr("checked" , true);
    }
    
    if(ccpIsLou == true){
        $("#_letterOfUdt").attr("checked" , true);
    }
    
}// bindData


function setSMSMessage(){
    
    var salesmanMemTypeID  = $("#_editSalesMemTypeId").val();
    
    var custName = $("#_editCustName").val().substr(0 , 15).trim();
    var ordNo = $("#_editOrdNo").val();
    var ccpStatus = $("#_statusEdit").val() == '1' ? "Pending" : "Approved";
    var webSite = salesmanMemTypeID == '1'?  "hp.coway.com.my" : "cody.coway.com.my";
    
    var message = "Order : " + ordNo + "\n" + "Name : " + custName + "\n" + "CCPstatus : " + ccpStatus + "\n" + "Remark :" + "\n" + webSite;
    
    $("#_updSmsMsg").val(message);
    
    //Msg Count Init
    $('#_charCounter').html('Total Character(s) : '+ message.length);
}


function  isValidMobileNo(inputContact){
    if(isNaN(inputContact) == true){
        return false;
    }
    
    if(inputContact.length != 10 && inputContact.length != 11){
        return false;
    }
    if( inputContact.substr(0 , 3) != '010' &&
        inputContact.substr(0 , 3) != '011' &&
        inputContact.substr(0 , 3) != '012' &&
        inputContact.substr(0 , 3) != '013' &&
        inputContact.substr(0 , 3) != '014' &&
        inputContact.substr(0 , 3) != '015' &&
        inputContact.substr(0 , 3) != '016' &&
        inputContact.substr(0 , 3) != '017' &&
        inputContact.substr(0 , 3) != '018' &&
        inputContact.substr(0 , 3) != '019' 
      ){
        return false;
    }
    
    return true;

}


function isAllowSendSMS(){
    
    var salesmanMemTypeID  = $("#_editSalesMemTypeId").val();
    var editSalesManTelMobile = $("#_editSalesManTelMobile").val();
    
    if(salesmanMemTypeID != 1 && salesmanMemTypeID != 2){
        
        Common.alert("This order salesman is not HP/Cody.<br />SMS is disallowed.");
        return false;
    }else{
        
        if(isValidMobileNo(editSalesManTelMobile) == false){
            
            Common.alert("Salesman mobile number is invalid.<br />SMS is disallowed.");
            return false;
        }
    }
    
    return true;
    
}




function getMstId(){
    
    var mstId = $("#_ccpMasterId").val();
    if(mstId == 0){
        mstId = 1;
    }else{
        mstId = 2;
    }
    
    return mstId;
}

function getUnitCombo(mst , ctgryVal, selVal ,comId){
    
    /* var unitJson = {ccpMasterId : mst ,  screCtgryTypeId : ctgryVal};
    var optionUnit = { isShowChoose: false};
    var selectVal = ''; 
    selectVal = selVal.trim();
    CommonCombo.make(comId, "/sales/ccp/getOrderUnitList", unitJson, selectVal , optionUnit);  */
    unitCombo("/sales/ccp/getOrderUnitList", mst, ctgryVal , selVal, comId, 'S');
    
}

function unitCombo(url, mst , ctgryVal , selCode, obj , type, callbackFn){

    $.ajax({
        type : "GET",
        url : getContextPath() + url,
        data : {ccpMasterId : mst ,  screCtgryTypeId : ctgryVal},
        dataType : "json",
        contentType : "application/json;charset=UTF-8",
        success : function(data) {
            var rData = data;
            doDefCombo(rData, selCode, obj , type,  callbackFn);
        },
        error: function(jqXHR, textStatus, errorThrown){
            alert("Draw ComboBox['"+obj+"'] is failed. \n\n Please try again.");
        },
        complete: function(){
        }
    });
} ;

//그리드 속성 설정
var gridPros = {
    usePaging           : true,         //페이징 사용
    pageRowCount        : 10,           //한 화면에 출력되는 행 개수 20(기본값:20)            
    editable            : false,            
    fixedColumnCount    : 0,            
    showStateColumn     : true,             
    displayTreeOpen     : false,            
//    selectionMode       : "singleRow",  //"multipleCells",            
    headerHeight        : 30,       
    useGroupingPanel    : false,        //그룹핑 패널 사용
    skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
    wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
    showRowNumColumn    : true,         //줄번호 칼럼 렌더러 출력    
    noDataMessage       : "No order found.",
    groupingMessage     : "Here groupping"
};
    
function chgTab(tabNm) {
    switch(tabNm) {
        case 'custInfo' :
            AUIGrid.resize(custInfoGridID, 942, 380);
            if(AUIGrid.getRowCount(custInfoGridID) <= 0) {
                fn_selectOrderSameRentalGroupOrderList();
            }
            break;
        case 'memInfo' :
            AUIGrid.resize(memInfoGridID, 942, 380);
            if(AUIGrid.getRowCount(memInfoGridID) <= 0) {
                fn_selectMembershipInfoList();
            }
            break;
        case 'docInfo' :
            AUIGrid.resize(docGridID, 942, 380);
            if(AUIGrid.getRowCount(docGridID) <= 0) {
                fn_selectDocumentList();
            }
            break;
        case 'callLogInfo' :
            AUIGrid.resize(callLogGridID, 942, 380);
            if(AUIGrid.getRowCount(callLogGridID) <= 0) {
                fn_selectCallLogList();
            }
            break;
        case 'payInfo' :
            AUIGrid.resize(payGridID, 942, 380);
            if(AUIGrid.getRowCount(payGridID) <= 0) {
                fn_selectPaymentList();
            }
            break;
        case 'transInfo' :
            AUIGrid.resize(transGridID, 942, 380);
            if(AUIGrid.getRowCount(transGridID) <= 0) {
                fn_selectTransList();
            }
            break;
        case 'autoDebitInfo' :
            AUIGrid.resize(autoDebitGridID, 942, 380);
            if(AUIGrid.getRowCount(autoDebitGridID) <= 0) {
                fn_selectAutoDebitList();
            }
            break;
        case 'discountInfo' :
            AUIGrid.resize(discountGridID, 942, 380);
            if(AUIGrid.getRowCount(discountGridID) <= 0) {
                fn_selectDiscountList();
            }
            break;
    };
}

</script>
<div id="popup_wrap" class="popup_wrap pop_win"><!-- popup_wrap start -->
<header class="pop_header"><!-- pop_header start -->
<h1>CCP Calculation Edit</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a id="_btnClose">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->
<form id="_editForm">
    <input type="hidden" name="editCcpId" id="_editCcpId" value="${ccpId}"/>
    
    <!--  from Basic -->
    <input type="hidden"  name="editOrdId" id="_editOrdId" value="${orderDetail.basicInfo.ordId}">
    <input type="hidden" name="editAppTypeCode" value="${orderDetail.basicInfo.appTypeCode }">
    <input type="hidden" name="editOrdStusId" value="${orderDetail.basicInfo.ordStusId}">
    <input type="hidden"  id="_editCustName" value="${orderDetail.basicInfo.custName}"> 
    <input type="hidden" id="_editOrdNo" value="${orderDetail.basicInfo.ordNo}">  
    <input type="hidden" id="_editCustTypeId" value="${orderDetail.basicInfo.custTypeId}">
    <input type="hidden" id="_editCustNation" value="${orderDetail.basicInfo.custNation}">
    <!-- from SalesMan (HP/CODY) -->
    <input type="hidden" name="editSalesMemTypeId" id="_editSalesMemTypeId" value="${salesMan.memType}">
    <input type="hidden" id="_editSalesManTelMobile" name="editSalesManTelMobile"  value="${salesMan.telMobile}"> 
    
    <!-- from GSTCertInfo -->
    <input type="hidden" name="editEurcFilePathName" value="${orderDetail.gstCertInfo.eurcFilePathName}">
    
    <!-- Cust Type Id  > Ccp Master Id -->
    <input type="hidden" name="ccpMasterId" value="${ccpMasterId}" id="_ccpMasterId">
    
    <!-- from FieldMap -->
    <input type="hidden" id="_ordUnitSelVal" value="${fieldMap.ordUnitSelVal}">
    <input type="hidden" id="_rosUnitSelVal" value="${fieldMap.rosUnitSelVal}">
    <input type="hidden" id="_susUnitSelVal" value="${fieldMap.susUnitSelVal}">
    <input type="hidden" id="_custUnitSelVal" value="${fieldMap.custUnitSelVal}">
    
     <!-- from IncomMap -->
     <input type="hidden" id="_rentPayModeId" name="rentPayModeId" value="${incomMap.rentPayModeId}">
     <input type="hidden" id="_applicantTypeId" name="applicantTypeId" value="${incomMap.applicantTypeId}">
     
     <!-- from ccpInfoMap  -->
     <input type="hidden" id="_ccpStusId" name="ccpStusId" value="${ccpInfoMap.ccpStusId}">
     <input type="hidden" id="_ccpIncRngId" value="${ccpInfoMap.ccpIncomeRangeId}">
     <input type="hidden" id="_ccpResnId" value="${ccpInfoMap.resnId}"> 
     
     <input type="hidden" id="_ccpIsHold" value="${ccpInfoMap.ccpIsHold}">
     <input type="hidden" id="_ccpIsSaman" value="${ccpInfoMap.ccpIsSaman}">
     <input type="hidden" id="_ccpIsLou" value="${ccpInfoMap.ccpIsLou}">
    
    <!-- previous -->
    <input type="hidden" id="_isPreVal" >
</form>
<section class="tap_wrap"><!-- tap_wrap start -->
<ul class="tap_type1 num5">
    <li><a href="#" class="on">Basic Info</a></li>
    <li><a href="#">Sales Person</a></li>
    <li><a href="#">Customer Info</a></li>
    <li><a href="#">Installation Info</a></li>
    <li><a href="#">Mailing Info</a></li>
    <c:if test="${orderDetail.basicInfo.appTypeCode == 'REN'}">
    <li><a href="#">Payment Channel</a></li>
    </c:if>
    <li><a href="#">Relief Certificate</a></li>
    <li><a href="#" onClick="javascript:chgTab('docInfo');">Document Submission</a></li>
    <li><a href="#" onClick="javascript:chgTab('payInfo');">Payment Listing</a></li>
</ul>
<!------------------------------------------------------------------------------
    Basic Info
------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/jsp/sales/order/include/basicInfo.jsp" %>
<!------------------------------------------------------------------------------
    Sales Person
------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/jsp/sales/order/include/hpCodySalesOnly.jsp" %>
<!------------------------------------------------------------------------------
    Customer Info
------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/jsp/sales/order/include/custInfoExceptGrid.jsp" %>
<!------------------------------------------------------------------------------
    Installation Info
------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/jsp/sales/order/include/installInfo.jsp" %>
<!------------------------------------------------------------------------------
    Mailling Info
------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/jsp/sales/order/include/mailInfo.jsp" %>
<!------------------------------------------------------------------------------
    Payment Channel
------------------------------------------------------------------------------->
<c:if test="${orderDetail.basicInfo.appTypeCode == 'REN'}">
<%@ include file="/WEB-INF/jsp/sales/order/include/payChannel.jsp" %>
</c:if>
<!------------------------------------------------------------------------------
    Relief Certificate
------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/jsp/sales/order/include/rliefCrtfcat.jsp" %>
<!------------------------------------------------------------------------------
    Document Submission
------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/jsp/sales/order/include/docSubmission.jsp" %>
<!------------------------------------------------------------------------------
    Payment Listing
------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/jsp/sales/order/include/payList.jsp" %>

</section><!-- tap_wrap end -->

<aside class="title_line"><!-- title_line start -->
<h3>CCP Score Point</h3>
<ul class="right_btns">
    <li><p class="btn_blue2"><a onclick="javascript: fn_underDevelop()">FICO Report</a></p></li>
    <li><p class="btn_blue2"><a onclick="javascript: fn_underDevelop()">CTOS Report</a></p></li>
</ul>
</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->


<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:210px" />
    <col style="width:*" />
    <col style="width:80px" />
    <col style="width:*" />
    <col style="width:80px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Order Unit</th>
    <td>
        <select class="w100p" name="ordUnit" id="_ordUnit"></select> 
    </td>
    <th scope="row">Count</th>
    <td><span><b>${fieldMap.ordUnitCount }</b></span></td>
    <th scope="row">Point</th>
    <td><span><b>${fieldMap.orderUnitPoint}</b></span></td>
</tr>
<tr>
    <th scope="row">Avg ROS Mth</th>
    <td> <select class="w100p" name="ordMth" id="_ordMth"></select></td>
    <th scope="row">Count</th>
    <td><span><b>${fieldMap.rosCount}</b></span></td>
    <th scope="row">Point</th>
    <td><span><b>${fieldMap.rosUnitPoint}</b></span></td> 
</tr>
<tr>
    <th scope="row">Suspension/Termination</th> 
    <td> <select class="w100p" name="ordSuspen" id="_ordSuspen"></select></td> 
    <th scope="row">Count</th>
    <td><span><b>${fieldMap.susUnitCount}</b></span></td>
    <th scope="row">Point</th>
    <td><span><b>${fieldMap.susUnitPoint}</b></span></td>
</tr>
<tr>
    <th scope="row">Existing Customer</th>
    <td><select class="w100p" name="ordExistingCust" id="_ordExistingCust"></select></td>
    <th scope="row">Count</th>
    <td><span><b>${fieldMap.custUnitCount}</b></span></td>
    <th scope="row">Point</th>
    <td><span><b>${fieldMap.custUnitPoint}</b></span></td>
</tr>
<tr>
    <th scope="row">Total Point</th>
    <td colspan="5"><b>${fieldMap.totUnitPoint}</b></td>
</tr>
</tbody>
</table><!-- table end -->


</section><!-- search_table end -->

<aside class="title_line"><!-- title_line start -->
<h3>CCP Result</h3>
</aside><!-- title_line end -->
<form  id="calSaveForm">
<input type="hidden" name="saveCcpId" id="_saveCcpId" value="${ccpId}"/>
<input type="hidden" name="ccpTotalScorePoint" value="${fieldMap.totUnitPoint}">
<input type="hidden" id="_saveCustTypeId" name="saveCustTypeId" value="${orderDetail.basicInfo.custTypeId}">
<input type="hidden"  name="saveOrdId" id="_saveOrdId" value="${orderDetail.basicInfo.ordId}">

<!-- Ord Unit  -->
<input type="hidden" name="saveOrdUnit"  id="_saveOrdUnit">
<input type="hidden" name="saveOrdCount"  value="${fieldMap.ordUnitCount }">
<input type="hidden" name="saveOrdPoint"  value="${fieldMap.orderUnitPoint}">

<!-- Avg ROS Mth -->
<input type="hidden" name="saveRosUnit"  id="_saveRosUnit">
<input type="hidden" name="saveRosCount"  value="${fieldMap.rosCount}">
<input type="hidden" name="saveRosPoint"  value="${fieldMap.rosUnitPoint}">

<!-- Suspension/Termination  -->
<input type="hidden" name="saveSusUnit"  id="_saveSusUnit"> 
<input type="hidden" name="saveSusCount"  value="${fieldMap.susUnitCount}">
<input type="hidden" name="saveSusPoint"  value="${fieldMap.susUnitPoint}">

<!-- Existing Customer -->
<input type="hidden" name="saveCustUnit"  id="_saveCustUnit" >
<input type="hidden" name="saveCustCount"  value="${fieldMap.custUnitCount}">
<input type="hidden" name="saveCustPoint"  value="${fieldMap.custUnitPoint}">

<!-- check box(sms) -->
<input type="hidden" name="isChkSms" id="_isChkSms"> 
<input type="hidden" name="hiddenUpdSmsMsg" id="_hiddenUpdSmsMsg">
<input type="hidden" name="hiddenSalesMobile" id="_hiddenSalesMobile">
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:190px" />
    <col style="width:*" />
    <col style="width:140px" />
    <col style="width:*" />
    <col style="width:140px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">CCP Status</th>
    <td><span><select class="w100p" name="statusEdit" id="_statusEdit" onchange="javascript : fn_ccpStatusChangeFunc(this.value)"></select></span></td>
    <th scope="row">Income Range</th>
    <td><span><select class="w100p" name="incomeRangeEdit" id="_incomeRangeEdit"></select></span></td>
    <th scope="row">Reject Status</th>
    <td><span><select class="w100p" name="rejectStatusEdit" id="_rejectStatusEdit"></select></span></td>
</tr>
<tr>
    <th scope="row">FICO Score</th>
    <td colspan="5"><span><input type="text" id="_ficoScore" name="ficoScore" value="${ccpInfoMap.ccpFico}" disabled="disabled" maxlength="10"></span></td>
</tr>
<tr>
    <th scope="row">CCP Feedback Code</th>
    <td colspan="5"><span><select class="w100p" name="reasonCodeEdit" id="_reasonCodeEdit"></select></span></td>  
</tr>
<tr>
    <th scope="row">Special Remark</th>
    <td colspan="5"><textarea cols="20" rows="5" id="_spcialRem" name="spcialRem" maxlength="4000">${ccpInfoMap.ccpRem}</textarea></td>
</tr>
<tr>
    <th scope="row">P &amp; C Remark</th>
    <td colspan="5"><textarea cols="20" rows="5" id="_pncRem" name="pncRem" maxlength="4000">${ccpInfoMap.ccpPncRem}</textarea></td> 
</tr>
<tr>
    <th scope="row">Letter Of Undertaking</th>
    <td><span><input type="checkbox"  id="_letterOfUdt"  name="letterOfUdt"/></span></td>
    <th scope="row">Summon</th>
    <td><span><input type="checkbox"  id="_summon"  name="summon"/></span></td>
    <th scope="row">On Hold CCP</th>
    <td><span><input type="checkbox"  id="_onHoldCcp"  name="onHoldCcp"/></span></td>
</tr>
</tbody>
</table><!-- table end -->
</form>
<div id="_smsDiv" style="display: none;">
<aside class="title_line"><!-- title_line start -->
<h2>SMS Info</h2>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <td colspan="2">
    <label><input type="checkbox"  id="_updSmsChk"  /><span>Send SMS ?</span></label>
    </td>
</tr>
<tr>
    <th scope="row">SMS Message</th>
    <td><textarea cols="20" rows="5" name="updSmsMsg" id="_updSmsMsg" ></textarea></td>
</tr>
<tr>
    <td colspan="2"><span id="_charCounter">Total Character(s) :</span></td>
</tr>
</tbody>
</table><!-- table end -->

</div>
<ul class="center_btns">
    <li><p class="btn_blue2"><a id="_btnList">List</a></p></li>
    <li><p class="btn_blue2"><a id="_calBtnSave">Save</a></p></li>
</ul>

</section>
</div>