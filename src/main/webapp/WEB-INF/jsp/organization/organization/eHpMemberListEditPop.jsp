<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">
var optionState = {chooseMessage: " 1.States "};
var optionCity = {chooseMessage: "2. City"};
var optionPostCode = {chooseMessage: "3. Post Code"};
var optionArea = {chooseMessage: "4. Area"};

var update = new Array();
var remove = new Array();
var myFileCaches = {};

var nricFileId = 0;
var statementFileId = 0;
var passportFileId = 0;
var paymentFileId = 0;
var otherFileId = 0;
var otherFileId2 = 0;

var nricFileName = "";
var statementFileName = "";
var passportFileName = "";
var paymentFileName = "";
var otherFileName = "";
var otherFileName2 = "";


$(document).ready(function() {

    //doGetComboAddr('/common/selectAddrSelCodeList.do', 'country' , '' , '','country', 'S', '');

    //doGetComboAddr('/common/selectAddrSelCodeList.do', 'country' , '' , '','national', 'S', '');
            $("#eHPstatusID").attr("disabled",true);
            $("#eHPreligion").attr("disabled", true);
            $("#eHPcourse").attr("disabled", true);
            $("#eHPtotalVacation").attr("disabled", true);
            $("#eHPapplicationStatus").attr("disabled", true);
            $("#eHPremainVacation").attr("disabled", true);
            $("#eHPsearchdepartment").attr("disabled", true);
            $("#eHPinputSubDept").attr("disabled", true);
            $("#eHPeducationLvl").attr("disabled", true);
            $("#eHPlanguage").attr("disabled", true);


    doGetCombo('/sales/customer/getNationList', '338' , '' ,'eHPcountry' , 'S');
    doGetCombo('/sales/customer/getNationList', '338' , '' ,'eHPnational' , 'S');
    doGetCombo('/common/selectCodeList.do', '2', '','eHPcmbRace', 'S' , '');
    doGetCombo('/common/selectCodeList.do', '4', '','eHPmarrital', 'S' , '');
    doGetCombo('/common/selectCodeList.do', '3', '','eHPlanguage', 'S' , '');
    doGetCombo('/common/selectCodeList.do', '5', '','eHPeducationLvl', 'S' , '');
    doGetCombo('/sales/customer/selectAccBank.do', '', '', 'eHPissuedBank', 'S', '')
    doGetCombo('/organization/selectHpMeetPoint.do', '', '', 'eHPmeetingPoint', 'S', '');

    console.log("atchFileGrpId : " + '${atchFileGrpId}' );
    var atchFileGrpIdTemp = '${atchFileGrpId}';
    if(atchFileGrpIdTemp > 0){
    	fn_loadAtchment('${atchFileGrpId}');
    }

    //fn_getMemInfo();


  /*   if('${atchFileGrpId}' != 0 || '${atchFileGrpId}' != null || '${atchFileGrpId}' != undefined ){
        fn_loadAtchment('${atchFileGrpId}');
    } */


    var memID = $("#eHPMemberID").val();
    Common.ajax("GET", "/organization/getEHPMemberListMemberView", {MemberID : memID}, function(result) {
    	   if(result != null ){

               console.log(result[0]);
               $("#eHPmemberType option[value="+ result[0].aplicntType +"]").attr("selected", true);
               fn_departmentCode(result[0].aplicntType);

               $("#eHPmemberNm").val(result[0].aplicntName);
               $("#eHPnric").val(result[0].aplicntNric);

               if(result[0].aplicntGender=="F"){
                   $("#eHPgender_f").prop("checked", true)
               }
               if(result[0].aplicntGender=="M"){
                   $("#eHPgender_m").prop("checked", true)
               }

               $("#eHPemail").val(result[0].aplicntEmail);

               $("#eHPmobileNo").val(result[0].aplicntTelMobile);

               $("#eHPofficeNo").val(result[0].aplicntTelOffice);

               $("#eHPresidenceNo").val(result[0].aplicntTelHuse);

               $("#eHPsponsorCd").val(result[0].aplicntSponsCode);

               $("#eHPsponsorNm").val(result[0].aplicntSponsNm);

               $("#eHPsponsorNric").val(result[0].aplicntSponsNric);

               $("#eHPmeetingPoint option[value="+ result[0].aplicntMeetpoint +"]").attr("selected", true);

               $("#eHPissuedBank option[value="+ result[0].aplicntBankId +"]").attr("selected", true);

               $("#eHPcollctionBrnch option[value='"+ result[0].aplicntColBrnch +"']").attr("selected", true);

               $("#eHPmarrital option[value="+ result[0].aplicntMartl +"]").attr("selected", true);

               $("#eHPcmbRace").val(result[0].aplicntRace);

               $("#eHPbankAccNo").val(result[0].aplicntBankAccNo);

               $("#eHPstatusID").val(result[0].stusId);

               //$("#eHPmArea").val(data.area);
               //$("#eHPmArea option[value='"+ data.area +"']").attr("selected", true);

               //$("#eHPmPostCd").val(data.postcode);
               //$("#eHPmPostCd option[value='"+ data.postcode +"']").attr("selected", true);

               //$("#eHPmState").val(data.state);
               //$("#eHPmState option[value='"+ data.state +"']").attr("selected", true);

               //$("#eHPmCity").val(data.city);
               //$("#eHPmCity option[value='"+ data.city +"']").attr("selected", true);


               var marea = result[0].area;
               var mcity = result[0].city;
               var mpostcode = result[0].postcode;
               var mstate = result[0].state;
               var areaid = result[0].areaId
               fn_addMaddr(marea, mcity, mpostcode, mstate, areaid);

           }else{
               console.log("ERROR - NULL VALUE");
           }
    });



    doGetCombo('/organization/selectBusinessType.do', '', '','eHPbusinessType', 'S' , '');


    //fn_departmentCode();
    $("#eHPstate").change(function (){
        var state = $("#eHPstate").val();
        doGetComboAddr('/common/selectAddrSelCodeList.do', 'area' ,state ,'eHParea', 'S', '');
    });
    $("#eHParea").change(function (){
        var area = $("#eHParea").val();
        doGetComboAddr('/common/selectAddrSelCodeList.do', 'post' ,area ,'','eHPpostCode', 'S', '');
    });


    $("#eHPsearchdepartment").change(function(){
        doGetCombo('/organization/selectSubDept.do',  $("#eHPsearchdepartment").val(), '','eHPinputSubDept', 'S' ,  '');
    });

    if ($("#eHPjoinDate").val() == "") {
        $("#eHPjoinDate").attr("disabled", false);
    } else {
        $("#eHPjoinDate").attr("disabled", true);
    }

    $('#eHPbankAccNo').blur(function() {
        if($("#eHPmemberType").val() != "5") {
           console.log("not trainee with -/0")
           fmtNumber("#eHPbankAccNo"); // 2018-06-21 - LaiKW - Added removal of special characters from bank account number
           checkBankAccNo();
        } else if($("#eHPmemberType").val() == "5") {
           console.log("5");
           console.log("bankaccno :: " + $("#eHPbankAccNo").val());
           if($("#eHPbankAccNo").val() != "-"){
               checkBankAccNo();
           }
        }
    });

    // 2020-02-04 - LaiKW - Added to block CDB Sales admin to self change branch
    if('${userRoleId}' == 256) {
        $("#eHPselectBranch").attr("disabled", true);
    }


    $('#nricFile').change( function(evt) {
        var file = evt.target.files[0];
        if(file == null){
            remove.push(nricFileId);
        }else if(file.name != nricFileName){
             myFileCaches[1] = {file:file};
             if(nricFileName != ""){
                 update.push(nricFileId);
             }
         }
    });
    $('#statementFile').change( function(evt) {
        var file = evt.target.files[0];
        if(file == null){
            remove.push(statementFileId);
        }else if(file.name != statementFileName){
            myFileCaches[2] = {file:file};
            if(statementFileName != ""){
                update.push(statementFileId);
            }
        }
    });
    $('#passportFile').change(function(evt) {
        var file = evt.target.files[0];
        if(file == null){
            remove.push(passportFileId);
        }else if(file.name != passportFileName){
            myFileCaches[3] = {file:file};
            if(passportFileName != ""){
                update.push(passportFileId);
            }
        }
    });

    $('#paymentFile').change(function(evt) {
        var file = evt.target.files[0];
        if(file == null){
            remove.push(paymentFileId);
        }else if(file.name != paymentFileName){
            myFileCaches[4] = {file:file};
            if(paymentFileName != ""){
                update.push(paymentFileId);
           }
        }
    });

    $('#otherFile').change(function(evt) {
        var file = evt.target.files[0];
        if(file == null){
            remove.push(otherFileId);
        }else if(file.name != otherFileName){
            myFileCaches[5] = {file:file};
            if(otherFileName != ""){
                update.push(otherFileId);
            }
        }
    });

    $('#otherFile2').change(function(evt) {
        var file = evt.target.files[0];
        if(file == null){
            remove.push(otherFileId2);
        }else if(file.name != otherFileName2){
            myFileCaches[6] = {file:file};
            if(otherFileName2 != ""){
                update.push(otherFileId2);
            }
        }
    });

});



function fn_close(){
    $("#popup_wrap").remove();
}

function fn_saveConfirm(){
	 //checkNRIC();
    if(fn_saveValidation()){
        Common.confirm("<spring:message code='sys.common.alert.save'/>", fn_memberSave);

    }
}


function fn_departmentCode(value){
    console.log("fn_departmentCode");
    if($("#eHPmemberType").val() != 2){
            $("#hideContent").hide();
        }else{
            $("#hideContent").show();
        }
    var action = value;
    switch(action){
       /* case 1 :
           $("#groupCode[memberLvl]").val(3);
           $("#groupCode[flag]").val("%CRS%");
           var jsonObj = {
                memberLvl : 3,
                flag :  "%CRS%"
        };
           doGetCombo("/organization/selectDeptCode", jsonObj , ''   , 'deptCd' , 'S', '');
           break; */
       case 2 :
           $("#groupCode[memberLvl]").val(3);
           $("#groupCode[flag]").val("%CCS%");
           var jsonObj = {
                memberLvl : 3,
                flag :  "%CCS%"
        };
           //doGetCombo("/organization/selectDeptCode", jsonObj , ''   , 'deptCd' , 'S', '');
           //doGetComboSepa("/common/selectBranchCodeList.do",4 , '-',''   , 'branch' , 'S', '');
           doGetCombo('/common/selectCodeList.do', '7', '','eHPtransportCd', 'S' , '');
           break;
       case 3 :
           $("#groupCode[memberLvl]").val(3);
           $("#groupCode[flag]").val("%CTS%");
           var jsonObj = {
                memberLvl : 3,
                flag :  "%CTS%"
        };
           //doGetCombo("/organization/selectDeptCode", jsonObj , ''   , 'deptCd' , 'S', '');
           //doGetComboSepa("/common/selectBranchCodeList.do",2 , '-',''   , 'branch' , 'S', '');
           doGetCombo('/common/selectCodeList.do', '7', '','eHPtransportCd', 'S' , '');
           break;

       case 4 :
           $("#groupCode[memberLvl]").val(100);
           $("#groupCode[flag]").val("-");
           var jsonObj = {
                memberLvl : 100,
                flag :  "-"
        };
           //doGetComboSepa("/common/selectBranchCodeList.do",100 , '-',''   , 'branch' , 'S', '');
           break;

       case 5 :
           $("#groupCode[memberLvl]").val(3);
           $("#groupCode[flag]").val("%CCS%");
           var jsonObj = {
                memberLvl : 3,
                flag :  "%CCS%"
        };
           //doGetCombo("/organization/selectDeptCode", jsonObj , ''   , 'deptCd' , 'S', '');
           //doGetComboSepa("/common/selectBranchCodeList.do",4 , '-',''   , 'branch' , 'S', '');
           doGetCombo('/common/selectCodeList.do', '7', '','eHPtransportCd', 'S' , '');
           break;
    }
}

 function fn_getMemInfo(){
    console.log("fn_setMemInfo  " );
    $("#eHPmemberType").attr("disabled",false);
    var memID = $("#eHPMemberID").val();
    Common.ajax("GET", "/organization/getEHPMemberListMemberView", {MemberID : memID}, function(result) {
        console.log(result);
        if(result != null ){
            fn_setMemInfo(result[0]);
            console.log(result[0]);
        }else{
            console.log("ERROR - NULL VALUE");
        }
    });
    $("#eHPmemberType").attr("disabled",true);
}

function fn_setMemInfo(data){

          $("#eHPmemberType option[value="+ data.aplicntType +"]").attr("selected", true);
            fn_departmentCode(data.aplicntType);

            $("#eHPmemberNm").val(data.aplicntName);
            $("#eHPnric").val(data.aplicntNric);

            if(data.aplicntGender=="F"){
                $("#eHPgender_f").prop("checked", true)
            }
            if(data.aplicntGender=="M"){
                $("#eHPgender_m").prop("checked", true)
            }

            $("#eHPemail").val(data.aplicntEmail);

            $("#eHPmobileNo").val(data.aplicntTelMobile);

            $("#eHPofficeNo").val(data.aplicntTelOffice);

            $("#eHPresidenceNo").val(data.aplicntTelHuse);

            $("#eHPsponsorCd").val(data.aplicntSponsCode);

            $("#eHPsponsorNm").val(data.aplicntSponsNm);

            $("#eHPsponsorNric").val(data.aplicntSponsNric);

            $("#eHPmeetingPoint option[value="+ data.aplicntMeetpoint +"]").attr("selected", true);

            $("#eHPissuedBank option[value="+ data.aplicntBankId +"]").attr("selected", true);

            $("#eHPcollctionBrnch option[value='"+ data.aplicntColBrnch +"']").attr("selected", true);

            $("#eHPmarrital option[value="+ data.aplicntMartl +"]").attr("selected", true);

            $("#eHPcmbRace").val(data.aplicntRace);

            $("#eHPbankAccNo").val(data.aplicntBankAccNo);

            $("#eHPstatusID").val(data.stusId);

            //$("#eHPmArea").val(data.area);
            //$("#eHPmArea option[value='"+ data.area +"']").attr("selected", true);

            //$("#eHPmPostCd").val(data.postcode);
            //$("#eHPmPostCd option[value='"+ data.postcode +"']").attr("selected", true);

            //$("#eHPmState").val(data.state);
            //$("#eHPmState option[value='"+ data.state +"']").attr("selected", true);

            //$("#eHPmCity").val(data.city);
            //$("#eHPmCity option[value='"+ data.city +"']").attr("selected", true);


            var marea = data.area;
            var mcity = data.city;
            var mpostcode = data.postcode;
            var mstate = data.state;
            var areaid = data.areaId
            fn_addMaddr(marea, mcity, mpostcode, mstate, areaid);


}



//Validation Check
function fn_saveValidation(){
    var message = "";
    var action = $("#eHPmemType").val();
    var valid = true;
    var defaultDate = new Date("01/01/1900");
    var regEmail = /([\w-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([\w-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$/;
    //region Check Basic Info
    /*
    if (dpUserValidDate.SelectedDate < DateTime.Now.Date)
    {
        valid = false;
        message += "* Please select equal or bigger than today date.<br />";
    }
    */

    if($("#eHPjoinDate").val() == ''){
        valid = false;
        message += "* Please select joined date.<br/>";
    }
    if($("#eHPmemberNm").val() == ''){
        valid = false;
        message += "* Please key in member name.<br/>";
    }
    if($("#eHPnational").val() == ''){
        valid = false;
        message += "* Please select the nationality.<br/>";
    }
     if($("#eHPnric").val() == ''){
        valid = false;
        message += "* Please key in the NRIC.<br/> ";
    }
     if (  $("#eHPnric").val().length != 12 ) {
         Common.alert("NRIC should be in 12 digit");
         return false;
     }
     if($("#eHPcollctionBrnch").val() == ''){
         valid = false;
         message += "* Please select collection branch.<br/>";
     }
    //else
    //{
    //    if (this.IsExistingMember())
    //    {
    //        valid = false;
    //        message += "* This is existing member.<br/>";
    //    }
    //}
    if($('input[name=gender]:checked', '#eHPmemberAddForm').val() == null){
        valid = false;
        message += "* Please select gender.<br/> ";
    }
    if($("#eHPcmbRace").val() == ''){
        valid = false;
        message += "* Please select race.<br/> ";
    }
    //if($("#marrital").index(this) <=-1){
    if($("#eHPmarrital").val()==""){
        valid = false;
        message += "* Please select marrital.<br/> ";
    }
    if ($("#eHPBirth").val() == ""){
        valid = false;
        message += "* Please select DOB.<br/>";
    }
    else
    {
        var DOBDate = new Date();
        var d = new Date();
        DOBDate = $("#eHPBirth").val() == "" ? defaultDate : new Date($("#Birth").val());
        if ($("#eHPBirth").val() == "")
        {
            var Age = d.getFullYear() - DOBDate.getFullYear();
            if (Age < 18)
            {
                valid = false;
                message += "* Member must 18 years old and above.<br/>";
            }
            if (DOBDate==$("#nric").val().substring(0, 6))
            {
                valid = false;
                message += "* The NRIC is mismatch with member's DOB.<br/>";
            }
        }
    }
    //endregion

    if ($("#eHPmCountry").val() == "")
    {
        valid = false;
        message += "* Please select the country.<br/>";
    }
    else
    {
        if ($("#eHPmCountry").val() != "")  //mState
        {
            if ($("#eHPmState").val() == "") //mArea
            {
                valid = false;
                message += "* Please select the state.<br/>";
            }
            if ($("#eHPmArea").val() == "")  //mPostCd
            {
                valid = false;
                message += "* Please select the area.<br/>";
            }
            if ($("#eHPmPostCd").val() == "")
            {
                valid = false;
                message += "* Please select the postcode.<br/>";
            }
        }
    }

    if($("#eHPareaId").val() == ''){
        message += "* Please key in the address.<br/>";
        valid = false;
    }
    //endregion

    //region Check Phone No
    if (!(jQuery.trim($("#eHPmobileNo").val()).length>0) &&
        !(jQuery.trim($("#eHPofficeNo").val()).length>0) &&
        !(jQuery.trim($("#eHPresidenceNo").val()).length>0))
    {
        valid = false;
        message += "* Please key in the at least one contact no.<br/>";
    }
    else
    {
        if (jQuery.trim($("#eHPofficeNo").val()).length>0)
        {

            if(!jQuery.isNumeric(jQuery.trim($("#eHPmobileNo").val())))
            {
                valid = false;
                message += "* Invalid telephone number (Mobile).<br/>";
            }
        }
        if ((jQuery.trim($("#eHPofficeNo").val())).length>0)
        {
            if(!jQuery.isNumeric(jQuery.trim($("#eHPofficeNo").val())))
            {
                valid = false;
                message += "* Invalid telephone number (Office).<br/>";
            }
        }
        if ((jQuery.trim($("#eHPresidenceNo").val())).length>0)
        {
            if(!jQuery.isNumeric(jQuery.trim($("#eHPresidenceNo").val())))
            {
                valid = false;
                message += "* Invalid telephone number (Residence).<br/>";
            }
        }
    }

    if ((jQuery.trim($("#eHPspouseContat").val())).length>0)
    {
        if(!jQuery.isNumeric(jQuery.trim($("#eHPspouseContat").val())))
        {
            valid = false;
            message += "* Invalid spouse contant number.<br/>";
        }
    }
    //endregion

    //region Check Email
    if ((jQuery.trim($("#eHPemail").val())).length>0)
    {
        if (!regEmail.test($("#eHPemail").val()))
        {
            valid = false;
            message += "* Invalid contact person email.<br/>";
        }
    }
    //endregion

    if($("#eHPissuedBank").val()=="")
    {
        valid = false;
        message += "* Please select the issued bank.<br/>";
    }

    if (!(jQuery.trim($("#eHPbankAccNo").val())).length>0)
    {
        valid = false;
        message += "* Please key in the bank account no.<br/>";
    }

    //region Check Cody PA Date  codyPaExpr
    if (action == "2") //cyc 01/03/2017
    {
        if ((jQuery.trim($("#eHPcodyPaExpr").val())).length<0)
        {
            valid = false;
            message = "Cody agreement PA date are compulsory";
        }
    }
    //endregion

        if(!fn_validFile()) {
        return false;
    }

    //Display Message
    if (!valid)
    {
        //RadWindowManager1.RadAlert("<b>" + message + "</b>", 450, 160, "Save Member Summary", "callBackFn", null);
        Common.alert(message);
    }

    return valid;
}

function fn_addrSearch(){
    if($("#eHPsearchSt").val() == ''){
        Common.alert("Please search.");
        return false;
    }
    Common.popupDiv('/sales/customer/searchMagicAddressPop.do' , $('#eHPinsAddressForm').serializeJSON(), null , true, '_searchDiv'); //searchSt
}

function fn_addMaddr(marea, mcity, mpostcode, mstate, areaid){

    if(marea != "" && mpostcode != "" && mcity != "" && mstate != "" && areaid != "" ){

        $("#eHPmArea").attr({"disabled" : false  , "class" : "w100p"});
        $("#eHPmCity").attr({"disabled" : false  , "class" : "w100p"});
        $("#eHPmPostCd").attr({"disabled" : false  , "class" : "w100p"});
        $("#eHPmState").attr({"disabled" : false  , "class" : "w100p"});

        //Call Ajax

        CommonCombo.make('eHPmState', "/sales/customer/selectMagicAddressComboList", '' , mstate, optionState);

        var cityJson = {state : mstate}; //Condition
        CommonCombo.make('eHPmCity', "/sales/customer/selectMagicAddressComboList", cityJson, mcity , optionCity);

        var postCodeJson = {state : mstate , city : mcity}; //Condition
        CommonCombo.make('eHPmPostCd', "/sales/customer/selectMagicAddressComboList", postCodeJson, mpostcode , optionPostCode);

        var areaJson = {groupCode : mpostcode};
        var areaJson = {state : mstate , city : mcity , postcode : mpostcode}; //Condition
        CommonCombo.make('eHPmArea', "/sales/customer/selectMagicAddressComboList", areaJson, marea , optionArea);

        $("#eHPareaId").val(areaid);
        $("#_searchDiv").remove();
    }else{
        Common.alert("Please check your address.");
    }
}
//Get Area Id
function fn_getAreaId(){

    var statValue = $("#eHPmState").val();
    var cityValue = $("#eHPmCity").val();
    var postCodeValue = $("#eHPmPostCd").val();
    var areaValue = $("#eHPmArea").val();



    if('' != statValue && '' != cityValue && '' != postCodeValue && '' != areaValue){

        var jsonObj = { statValue : statValue ,
                              cityValue : cityValue,
                              postCodeValue : postCodeValue,
                              areaValue : areaValue
                            };
        Common.ajax("GET", "/sales/customer/getAreaId.do", jsonObj, function(result) {

             $("#eHPareaId").val(result.areaId);

        });

    }

}

function fn_selectCity(selVal){

    var tempVal = selVal;

    if('' == selVal || null == selVal){

         $('#eHPmPostCd').append($('<option>', { value: '', text: '3. Post Code' }));
         $('#eHPmPostCd').val('');
         $("#eHPmPostCd").attr({"disabled" : "disabled"  , "class" : "w100p disabled"});

         $('#eHPmArea').append($('<option>', { value: '', text: '4. Area' }));
         $('#eHPmArea').val('');
         $("#eHPmArea").attr({"disabled" : "disabled"  , "class" : "w100p disabled"});

    }else{

        $("#eHPmPostCd").attr({"disabled" : false  , "class" : "w100p"});

        $('#eHPmArea').append($('<option>', { value: '', text: '4. Area' }));
        $('#eHPmArea').val('');
        $("#eHPmArea").attr({"disabled" : "disabled"  , "class" : "w100p disabled"});

        //Call ajax
        var postCodeJson = {state : $("#mState").val() , city : tempVal}; //Condition
        CommonCombo.make('eHPmPostCd', "/sales/customer/selectMagicAddressComboList", postCodeJson, '' , optionPostCode);
    }

}

function fn_selectPostCode(selVal){

    var tempVal = selVal;

    if('' == selVal || null == selVal){

        $('#eHPmArea').append($('<option>', { value: '', text: '4. Area' }));
        $('#eHPmArea').val('');
        $("#eHPmArea").attr({"disabled" : "disabled"  , "class" : "w100p disabled"});

    }else{

        $("#eHPmArea").attr({"disabled" : false  , "class" : "w100p"});

        //Call ajax
        var areaJson = {state : $("#eHPmState").val(), city : $("#eHPmCity").val() , postcode : tempVal}; //Condition
        CommonCombo.make('eHPmArea', "/sales/customer/selectMagicAddressComboList", areaJson, '' , optionArea);
    }

}

function fn_selectState(selVal){

    var tempVal = selVal;

    if('' == selVal || null == selVal){
        //전체 초기화
        fn_initAddress();

    }else{

        $("#eHPmCity").attr({"disabled" : false  , "class" : "w100p"});

        $('#eHPmPostCd').append($('<option>', { value: '', text: '3. Post Code' }));
        $('#eHPmPostCd').val('');
        $("#eHPmPostCd").attr({"disabled" : "disabled"  , "class" : "w100p disabled"});

        $('#eHPmArea').append($('<option>', { value: '', text: '4. Area' }));
        $('#eHPmArea').val('');
        $("#eHPmArea").attr({"disabled" : "disabled"  , "class" : "w100p disabled"});

        //Call ajax
        var cityJson = {state : tempVal}; //Condition
        CommonCombo.make('eHPmCity', "/sales/customer/selectMagicAddressComboList", cityJson, '' , optionCity);
    }

}



function fn_sponsorPop(){
    Common.popupDiv("/organization/sponsorPop.do" , $('#eHPmemberAddForm').serializeJSON(), null , true,  '_searchSponDiv'); //searchSt
}


function fn_addSponsor(msponsorCd, msponsorNm, msponsorNric) {


    $("#eHPsponsorCd").val(msponsorCd);
    $("#eHPsponsorNm").val(msponsorNm);
    $("#eHPsponsorNric").val(msponsorNric);

    $("#_searchSponDiv").remove();

}

function fn_checkMobileNo() {
    if(event.keyCode == 13) {
        fmtNumber("#eHPmobileNo");
    }
}

function fmtNumber(field) {
    var fld = $(field).val();
    fld = fld.replace(/[^0-9]/g,"");

    $(field).val(fld);
}

function checkBankAccNoEnter() {
    if(event.keyCode == 13) {
        if($("#eHPmemberType").val() != "5") {
            console.log("not trainee with -/0")
            fmtNumber("#eHPbankAccNo"); // 2018-06-21 - LaiKW - Added removal of special characters from bank account number
            checkBankAccNo();
         } else if($("#eHPmemberType").val() == "5") {
            console.log("eHPbankaccno :: " + $("#eHPbankAccNo").val());
            if($("#eHPbankAccNo").val() != "-"){
                checkBankAccNo();
            }
         }
    }
}

function checkBankAccNo() {
    //var jsonObj = { "bank" : $("#issuedBank").val(), "bankAccNo" : $("#bankAccNo").val() };
    var jsonObj = {
        "bankId" : $("#eHPissuedBank").val(),
        "bankAccNo" : $("#eHPbankAccNo").val()
    };

    if($("#eHPmemberType").val() == "2803") {
        Common.ajax("GET", "/organization/checkAccLen", jsonObj, function(resultM) {
            console.log(resultM);

            if(resultM.message == "F") {
                Common.alert("Invalid Account Length!");
                $("#eHPbankAccNo").val("");
                return false;
            } else if(resultM.message == "S") {

                Common.ajax("GET", "/organization/checkBankAcc", jsonObj, function(result) {
                    console.log(result);
                    if(result.cnt1 == "0" && result.cnt2 == "0") {
                        return true;
                    } else {
                        Common.alert("Bank account number has been registered.");
                        //$("#issuedBank").val("");
                        $("#eHPbankAccNo").val("");
                        return false;
                    }
                });
            }
        });
    } else {
        Common.ajax("GET", "/organization/checkBankAcc", jsonObj, function(result) {
            console.log(result);
            if(result.cnt1 == "0" && result.cnt2 == "0") {
                return true;
            } else {
                Common.alert("Bank account number has been registered.");
                //$("#issuedBank").val("");
                $("#eHPbankAccNo").val("");
                return false;
            }
        });
    }
}

function fn_atchViewDown(fileGrpId, fileId) {
    var data = {
            atchFileGrpId : fileGrpId,
            atchFileId : fileId
    };
    Common.ajax("GET", "/eAccounting/webInvoice/getAttachmentInfo.do", data, function(result) {
        console.log(result)
        var fileSubPath = result.fileSubPath;
        fileSubPath = fileSubPath.replace('\', '/'');

        if(result.fileExtsn == "jpg" || result.fileExtsn == "png" || result.fileExtsn == "gif") {
            console.log(DEFAULT_RESOURCE_FILE + fileSubPath + '/' + result.physiclFileName);
            window.open(DEFAULT_RESOURCE_FILE + fileSubPath + '/' + result.physiclFileName);
        } else {
            console.log("/file/fileDownWeb.do?subPath=" + fileSubPath + "&fileName=" + result.physiclFileName + "&orignlFileNm=" + result.atchFileName);
            window.open("/file/fileDownWeb.do?subPath=" + fileSubPath + "&fileName=" + result.physiclFileName + "&orignlFileNm=" + result.atchFileName);
        }
    });
}



function fn_memberSave(){

    $("#eHPmemberType").attr("disabled",false);
    $("#eHPjoinDate").attr("disabled",false);
    $("#eHPnric").attr("disabled",false);
    $("#eHPstreetDtl1").val(insAddressForm.streetDtl.value);
    $("#eHPaddrDtl1").val(insAddressForm.addrDtl.value);
    $("#eHPsearchSt1").val(insAddressForm.searchSt.value);
    $("#eHPtraineeType").val(($("#eHPtraineeType").value));
    $("#eHPspouseDob").val($.trim($("#eHPspouseDob").val()));

    $("#eHPmemberType").attr("disabled",false);
    //jsonObj.form = $("#eHPmemberAddForm").serializeJSON();

    var cnfm = ${memberView.cnfm};
    var cnfmStatus = "";
    if (cnfm == 1){
        cnfmStatus = "102"; // Ready
    }else{
        cnfmStatus = "44"; // Pending
    }

    var gender = "";
    if( $('input[name=gender]:checked', '#eHPmemberAddForm').val() == "M"){
    	gender = "M";
    }else if( $('input[name=gender]:checked', '#eHPmemberAddForm').val() == "F"){
        gender = "F";
    }

    var jsonObj =  {
             // ADDRESS
              eHPareaId : $("#eHPareaId").val(),
              eHPstreetDtl : $("#eHPstreetDtl").val(),
              eHPaddrDtl : $("#eHPaddrDtl").val(),

              // BASIC INFO
              //eHPtraineeType : $("#eHPtraineeType").val(),
              eHPMemberID : $("#eHPMemberID").val(),
              eHPmemCode : $("#eHPmemCode").val(),
              eHPsubDept : $("#eHPinputSubDept").val(),
              eHPuserType : $("#eHPuserType").val(),
              eHPmemType : $("#eHPmemType").val(),
              eHPmemberType : $("#eHPmemberType").val(),

              eHPmemberNm : $("#eHPmemberNm").val(),
              eHPjoinDate : $("#eHPjoinDate").val(),
              //eHPgender : $("#eHPgender").val().trim(),
              eHPgender : gender,
              eHPBirth : $("#eHPBirth").val(),
              eHPcmbRace : $("#eHPcmbRace").val(),
              eHPnational : $("#eHPnational").val(),
              eHPnric : $("#eHPnric").val(),
              eHPmarrital : $("#eHPmarrital").val(),
              eHPemail : $("#eHPemail").val(),
              eHPmobileNo : $("#eHPmobileNo").val(),
              eHPofficeNo : $("#eHPofficeNo").val(),
              eHPresidenceNo : $("#eHPresidenceNo").val(),
              eHPsponsorCd : $("#eHPsponsorCd").val(),
              eHPsponsorNm : $("#eHPsponsorNm").val(),
              eHPsponsorNric : $("#eHPsponsorNric").val(),
              eHPdeptCd : $("#eHPdeptCd").val(),
              eHPmeetingPoint : $("#eHPmeetingPoint").val(),
              //eHPtraineeType1 : $("#eHPtraineeType1").val(),
              eHPissuedBank : $("#eHPissuedBank").val(),
              eHPbankAccNo : $("#eHPbankAccNo").val(),
              eHPcollectionBrnch : $("#eHPcollctionBrnch").val(),
              //eHPcodyPaExpr : $("#eHPcodyPaExpr").val(),
              eHPstatusId : cnfmStatus ,

              // SPOUSE INFO
              eHPspouseCode : $("#eHPspouseCode").val(),
              eHPspouseName : $("#eHPspouseName").val(),
              eHPspouseNric : $("#eHPspouseNric").val(),
              eHPspouseOcc : $("#eHPspouseOcc").val(),
              eHPspouseDob : $("#eHPspouseDob").val(),
              eHPspouseContat : $("#eHPspouseContat").val(),

              // ATTACHMENT
              atchFileGrpId : '${atchFileGrpId}'
    }



    var formData = new FormData();
    formData.append("atchFileGrpId", '${atchFileGrpId}');
    formData.append("update", JSON.stringify(update).replace(/[\[\]\"]/gi, ''));
    formData.append("remove", JSON.stringify(remove).replace(/[\[\]\"]/gi, ''));
    console.log(JSON.stringify(update).replace(/[\[\]\"]/gi, ''));
    console.log(JSON.stringify(remove).replace(/[\[\]\"]/gi, ''));
    $.each(myFileCaches, function(n, v) {
        console.log("atchFileGrpId - v.file :  " + v.file);
        formData.append(n, v.file);
    });
    console.log("-------------------------" + JSON.stringify(jsonObj));
    Common.ajaxFile("/organization/attachFileUpdate.do", formData, function(result) {
        if(result.code == 99){
            Common.alert("Attachment Upload Failed" + DEFAULT_DELIMITER + result.message);
            //myFileCaches = {};
        }else{


    Common.ajax("POST", "/organization/eHPmemberUpdate",  jsonObj, function(result) {
    console.log("message : " + result.message );
    Common.alert(result.message,fn_close);
    fn_parentReload();

    });
    $("#eHPmemberType").attr("disabled",true);
    $("#eHPjoinDate").attr("disabled",true);
    $("#eHPnric").attr("disabled",true);

        }
    },function(result){
        Common.alert(result.message+"<br/>Upload Failed. Please check with System Administrator.");
    });
}


function fn_loadAtchment(atchFileGrpId) {
    Common.ajax("Get", "/organization/selectAttachList.do", {atchFileGrpId :atchFileGrpId} , function(result) {
        console.log("selectAttachList : " + result);
       if(result) {
            if(result.length > 0) {
                $("#attachTd").html("");
                for ( var i = 0 ; i < result.length ; i++ ) {
                    switch (result[i].fileKeySeq){
                    case '1':
                        nricFileId = result[i].atchFileId;
                        nricFileName = result[i].atchFileName;
                        $(".input_text[id='nricFileTxt']").val(nricFileName);
                        break;
                    case '2':
                        statementFileId = result[i].atchFileId;
                        statementFileName = result[i].atchFileName;
                        $(".input_text[id='statementFileTxt']").val(statementFileName);
                        break;
                    case '3':
                        passportFileId = result[i].atchFileId;
                        passportFileName = result[i].atchFileName;
                        $(".input_text[id='passportFileTxt']").val(passportFileName);
                        break;
                    case '4':
                        paymentFileId = result[i].atchFileId;
                        paymentFileName = result[i].atchFileName;
                        $(".input_text[id='paymentFileTxt']").val(paymentFileName);
                        break;
                    case '5':
                        otherFileId = result[i].atchFileId;
                        otherFileName = result[i].atchFileName;
                        $(".input_text[id='otherFileTxt']").val(otherFileName);
                        break;
                    case '6':
                        otherFileId2 = result[i].atchFileId;
                        otherFileName2 = result[i].atchFileName;
                        $(".input_text[id='otherFileTxt2']").val(otherFileName2);
                        break;

                     default:
                         Common.alert("no files");
                    }
                }

                // 파일 다운
                $(".input_text").dblclick(function() {
                    var oriFileName = $(this).val();
                    var fileGrpId;
                    var fileId;
                    for(var i = 0; i < result.length; i++) {
                        if(result[i].atchFileName == oriFileName) {
                            fileGrpId = result[i].atchFileGrpId;
                            fileId = result[i].atchFileId;
                        }
                    }
                    if(fileId != null) fn_atchViewDown(fileGrpId, fileId);
                });
            }
        }
   });
}

/* function fn_validFile() {
    var isValid = true, msg = "";

    if(nricFileId == null) {
        isValid = false;
        msg += "* Please upload copy of NRIC<br>";
    }
    if(statementFileId == null) {
        isValid = false;
        msg += "* Please upload copy of Bank Passport / Statement<br>";
    }
    if(passportFileId == null) {
        isValid = false;
        msg += "* Please upload copy of Passport photo<br>";
    }


    if(!isValid) Common.alert("Save eHP - Edit Member" + DEFAULT_DELIMITER + "<b>"+msg+"</b>");

    return isValid;
} */

function fn_validFile() {
    var isValid = true, msg = "";

    if(FormUtil.isEmpty($('#nricFileTxt').val().trim())) {
        isValid = false;
        msg += "* Please upload copy of NRIC<br>";
    }
    if(FormUtil.isEmpty($('#statementFileTxt').val().trim())) {
        isValid = false;
        msg += "* Please upload copy of Bank Passport / Statement<br>";
    }
    if(FormUtil.isEmpty($('#passportFileTxt').val().trim())) {
        isValid = false;
        msg += "* Please upload copy of Passport photo<br>";
    }
    if(nricFileId == null) {
        isValid = false;
        msg += "* Please upload copy of NRIC<br>";
    }
    if(statementFileId == null) {
        isValid = false;
        msg += "* Please upload copy of Bank Passport / Statement<br>";
    }
    if(passportFileId == null) {
        isValid = false;
        msg += "* Please upload copy of Passport photo<br>";
    }

    if(!isValid) Common.alert("Save eHP - Add New Member" + DEFAULT_DELIMITER + "<b>"+msg+"</b>");

    return isValid;
}





function fn_removeFile(name){
    if(name == "NRIC") {
         $("#nricFile").val("");
         $(".input_text[name='nricFileTxt']").val("");
         $('#nricFile').change();
    }else if(name == "STAT"){
        $("#statementFile").val("");
        $(".input_text[name='statementFileTxt']").val("");
        $('#statementFile').change();
    }else if(name == "PASS"){
        $("#passportFile").val("");
        $(".input_text[name='passportFileTxt']").val("");
        $('#passportFile').change();
    }else if(name == "PAY"){
        $("#paymentFile").val("");
        $(".input_text[name='paymentFileTxt']").val("");
        $('#paymentFile').change();
    }else if(name == "OTH"){
        $("#otherFile").val("");
        $(".input_text[name='otherFileTxt']").val("");
        $('#otherFile').change();
    }else if(name == "OTH2"){
        $("#otherFile2").val("");
        $(".input_text[name='otherFileTxt2']").val("");
        $('#otherFile2').change();
    }
}

function checkNRICEnter(){
    if(event.keyCode == 13 || event.keyCode == 9) {
        checkNRIC();
    }
}


function checkNRIC(){
    var returnValue;

    var jsonObj = { "nric" : $("#eHPnric").val() };

    if ($("#eHPmemberType").val() == '2803' ) {
        Common.ajax("GET", "/organization/checkNRIC2.do", jsonObj, function(result) {
               console.log("data : " + result);
               if (result.message != "pass") {
                Common.alert(result.message);
                $("#eHPnric").val('');
                returnValue = false;
                return false;
               } else {    // 조건1 통과 -> 조건2 수행

                Common.ajax("GET", "/organization/checkNRIC1.do", jsonObj, function(result) {
                       console.log("data : " + result);
                       if (result.message != "pass") {
                           Common.alert(result.message);
                           $("#eHPnric").val('');
                           returnValue = false;
                           return false;
                       } else {    // 조건2 통과 -> 조건3 수행

                        Common.ajax("GET", "/organization/checkNRIC3.do", jsonObj, function(result) {
                               console.log("data : " + result);
                               if (result.message != "pass") {
                                   Common.alert(result.message);
                                   $("#eHPnric").val('');
                                   returnValue = false;
                                   return false;
                               } else {    // 조건3 통과 -> 끝
                                //Common.alert("Available NRIC");
                                autofilledbyNRIC();
                                returnValue = true;
                                   return true;
                               }

                           });
                       }

                });
               }
           });
    } else {
        autofilledbyNRIC();
    }
}

function autofilledbyNRIC(){

    //if ($("#memberType").val() == '4') {
        var nric = $("#eHPnric").val().replace('-', '');
        var autoGender = nric.substr(11,1);
        //var autoDOB = nric.substr(0,6);
        var autoDOB_year = nric.substr(0,2);
        var autoDOB_month = nric.substr(2,2);
        var autoDOB_date = nric.substr(4,2);

        if (parseInt(autoGender)%2 == 0) {
            $("input:radio[name='gender']:radio[value='F']").prop("checked", true);
        } else {
            $("input:radio[name='gender']:radio[value='M']").prop("checked", true);
        }

        if (parseInt(autoDOB_year) < 20) {
            $("#eHPBirth").val(autoDOB_date+"/"+autoDOB_month+"/"+"20"+autoDOB_year);
        } else {
            $("#eHPBirth").val(autoDOB_date+"/"+autoDOB_month+"/"+"19"+autoDOB_year);
        }
    //}

}

function fn_parentReload() {
	fn_memberListSearch(); //parent Method (Reload)
  }


</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>eHP - Edit Member</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->
<form action="#" id="eHPmemberAddForm" method="post">
<input type="hidden" id="eHPareaId" name="areaId" value="${memberView.areaId}">
<input type="hidden" id="eHPsearchSt1" name="searchSt1">
<input type="hidden" id="eHPstreetDtl1" name="streetDtl1">
<input type="hidden" id="eHPaddrDtl1" name="addrDtl1">
<%-- <input type="hidden" id="eHPtraineeType" name="traineeType" value="${memberView.traineeType}"> --%>
<input type="hidden" id="eHPmemType" name="memType" value="${memType}">
<input type="hidden"id="eHPMemberID" name="MemberID" value="${memberView.aplctnId}">
<input type="hidden" value="<c:out value="${memberView.deptCode}"/> "  id="eHPdeptCd" name="deptCode"/>
<%-- <input type="hidden" value="<c:out value="${memberView.aplicntColBrnch}"/> "  id="eHPcollctionBrnch" name="collctBranch"/> --%>
<input type="hidden" value="<c:out value="${memberView.aplicntGender}"/> "  id="eHPgender" name="gender"/>
<input type="hidden" value="<c:out value="${memberView.memCode}"/> "  id="eHPmemCode" name="memCode"/>
<input type="hidden" value="<c:out value="${memberView.cnfm}"/> "  id="eHPcnfm" name="eHPconfirmation"/>
<%-- <input type="hidden" value="<c:out value="${memberView.c64}"/> "  id="eHPuserId" name="userId"/>
<input type="hidden" value="<c:out value="${memberView.rank}"/> "  id="eHPrank" name="rank"/>
<input type="hidden" value="<c:out value="${memberView.c65}"/> "  id="eHPfullName" name="fullName"/>
<input type="hidden" value="<c:out value="${memberView.c66}"/> "  id="eHPagrmntNo" name="agrmntNo"/>
<input type="hidden" value="<c:out value="${memberView.c67}"/> "  id="eHPsyncChk" name="syncChk"/> --%>
<input type="hidden" value="<c:out value="${memberView.aplicntNational}"/> "  id="eHPnational" name="national"/>
<%-- <input type="hidden" value="<c:out value="${memberView.c3} " /> "  id="eHPbranch" name="branch"/> --%>
<input type="hidden" value="<c:out value="${memberView.atchFileGrpId} " /> "  id="eHPatchFileGrpId" name="atchFileGrpId"/>
<input type="hidden"   id="groupCode[memberLvl]" name="groupCode[memberLvl]"/>
<input type="hidden"   id="groupCode[flag]" name="groupCode[flag]"/>



<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Member Type</th>
    <td>
    <select class="w100p" id="eHPmemberType" name="memberType" disabled="disabled">
      <!--   <option value="1">Health Planner (HP)</option> -->
        <option value="2803">HP Applicant</option>
    </select>
    </td>
</tr>
</tbody>
</table><!-- table end -->

<section class="tap_wrap"><!-- tap_wrap start -->
<ul class="tap_type1 num4">
    <li><a href="#" class="on">Basic Info</a></li>
    <li><a href="#">Spouse Info</a></li>
    <li><a href="#">Member Address</a></li>
     <li><a href="#">Attachment</a></li>
</ul>

<article class="tap_area"><!-- tap_area start -->

<aside class="title_line"><!-- title_line start -->
<h2>Basic Information</h2>
</aside><!-- title_line end -->
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:160px" />
    <col style="width:*" />
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:150px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Member Name<span class="must">*</span></th>
    <td colspan="3">
    <input type="text" title="" id="eHPmemberNm" name="memberNm" placeholder="Member Name" class="w100p"  value="<c:out value="${memberView.aplicntName}"/>"/>
    </td>
    <th scope="row">Joined Date<span class="must">*</span></th>
    <td>
    <input type="text" title="Create start Date" id="eHPjoinDate" name="joinDate" placeholder="DD/MM/YYYY" class="j_date"  disabled="disabled"  value="<c:out value="${memberView.aplicntJoinDt}"/>"/>
    </td>
</tr>
<tr>
    <th scope="row">NRIC<span class="must">*</span></th>
    <td>
        <input type="text" title="" placeholder="NRIC (New)" id="eHPnric" name="nric" class="w100p"  maxlength="12" onKeyDown="checkNRICEnter()"
        onKeypress="if(event.keyCode < 45 || event.keyCode > 57) event.returnValue = false;" style = "IME-MODE:disabled;"/>
    </td>
    <th scope="row">Date of Birth<span class="must">*</span></th>
    <td>
    <input type="text" title="Create start Date" id="eHPBirth" name="Birth"placeholder="DD/MM/YYYY" class="j_date" value="<c:out value="${memberView.aplicntDob}"/>" />
    </td>
    <th scope="row">Race<span class="must">*</span></th>
    <td>
    <select class="w100p" id="eHPcmbRace" name="cmbRace">
    </select>
    </td>
</tr>
<tr>
    <th scope="row">Nationality<span class="must">*</span></th>
    <td>
    <span><c:out value="${memberView.nation} " /></span>
    <!--
    <select class="w100p" id="national" name="national">
    </select>
     -->
    </td>
        <th scope="row">Gender<span class="must">*</span></th>
    <td>
    <label><input type="radio" name="gender" id="eHPgender_m" value="M" /><span>Male</span></label>
    <label><input type="radio" name="gender" id="eHPgender_f" value="F"/><span>Female</span></label>
    </td>
    <th scope="row">Marital Status<span class="must">*</span></th>
    <td>
    <select class="w100p" id="eHPmarrital" name="marrital">
    </select>
    </td>
</tr>
<tr>
    <th scope="row">Email</th>
    <td colspan="5">
    <input type="text" title="" placeholder="Email" class="w100p" id="eHPemail" name="email" />
    </td>
</tr>
<tr>
    <th scope="row">Mobile No.</th>
    <td>
    <input type="text" title="" placeholder="Numeric Only" class="w100p" id="eHPmobileNo" name="mobileNo" maxlength="11" onKeyDown="fn_checkMobileNo()"
        onKeypress="if(event.keyCode < 45 || event.keyCode > 57) event.returnValue = false;" style = "IME-MODE:disabled;"/>
    </td>
    <th scope="row">Office No.</th>
    <td>
    <input type="text" title="" placeholder="Numberic Only" class="w100p"  id="eHPofficeNo" name="officeNo"
        onKeypress="if(event.keyCode < 45 || event.keyCode > 57) event.returnValue = false;" style = "IME-MODE:disabled;"/>
    </td>
    <th scope="row">Residence No.</th>
    <td>
    <input type="text" title="" placeholder="Numberic Only" class="w100p" id="eHPresidenceNo"  name="residenceNo"
        onKeypress="if(event.keyCode < 45 || event.keyCode > 57) event.returnValue = false;" style = "IME-MODE:disabled;"/>
    </td>
</tr>
<tr>
    <th scope="row">Sponsor's Code</th>
    <td>

    <div class="search_100p"><!-- search_100p start -->
    <input type="text" title="" placeholder="Sponsor's Code" class="w100p" id="eHPsponsorCd" name="sponsorCd"/>
    <a href="javascript:fn_sponsorPop();" class="search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
    </div><!-- search_100p end -->

    </td>
    <th scope="row">Sponsor's Name</th>
    <td>
    <input type="text" title="" placeholder="Sponsor's Name" class="w100p"  id="eHPsponsorNm" name="sponsorNm"/>
    </td>
    <th scope="row">Sponsor's NRIC</th>
    <td>
    <input type="text" title="" placeholder="Sponsor's NRIC" class="w100p" id="eHPsponsorNric" name="sponsorNric"/>
    </td>
</tr>
<tr>
    <th scope="row">Branch</th>
    <td>
     <!-- <span><c:out value="${memberView.c4} - ${memberView.c5} " /></span>-->
     <select class="w100p"  id="eHPselectBranch" name="selectBranch">
        <option value="0">Choose One</option>
        <c:forEach var="list" items="${branch}" varStatus="status">
           <option value="${list.brnchId}">${list.branchCode} - ${list.branchName}</option>
        </c:forEach>
    </select>
    </td>
    <th scope="row">Department Code<span class="must">*</span></th>
    <td>
     <span><c:out value="${memberView.deptCode}"/></span>
     </td>
    <th scope="row">Transport Code</th>
    <td>
    <select class="w100p"  id="eHPtransportCd" name="transportCd">
    </select>
    </td>
</tr>
<tr>
    <th scope="row" id="eHPmeetingPointLbl">Reporting Branch</th>
    <td colspan="5">
        <select class="w100p" id="eHPmeetingPoint" name="meetingPoint"></select>
    </td>
</tr>
<%-- <tr>
    <th scope="row">e-Approval Status</th>
    <td colspan="5">
    <input type="text" title="" placeholder="e-Approval Status" class="w100p" />
    </td>
</tr>
<tr>
    <th scope="row">Religion</th>
    <td colspan="2">
    <select class="w100p" id="eHPreligion" name="religion">
            <option value="">Choose One</option>
        <c:forEach var="list" items="${Religion}" varStatus="status">
            <option value="${list.detailcodeid}">${list.detailcodename } </option>
        </c:forEach>
    </select>
    </td>
    <th scope="row">e-Approval Status</th>
    <td colspan="2">
    <select class="w100p" id=eHPstatusID name=statusID>
        <option value="1">Active</option>
        <option value="44">Pending</option>
        <option value="5">Approved</option>
        <option value="6">Rejected</option>
    </select>
    </td>
</tr>
<tr>
    <th scope="row">Training Course</th>
    <td colspan="2">
    <select class="w100p" id="eHPcourse" name="course">
    </select>
    </td>
    <th scope="row">Total Vacation</th>
    <td colspan="2">
    <input type="text" id="eHPtotalVacation" title="" placeholder="Total Vacation" class="w100p" />
    </td>
</tr>
<tr>
    <th scope="row">Application Status</th>
    <td colspan="2">
    <select class="w100p" id= "eHPapplicationStatus">
        <option value="">Register</option>
        <option value="">Training</option>
        <option value="">Result-fail</option>
        <option value="">Pass, Absent</option>
        <option value="">Confirmed</option>
        <option value="">Cancelled</option>
    </select>
    </td>
    <th scope="row">Remain Vacation</th>
    <td colspan="2">
    <input type="text" id = "eHPremainVacation" title="" placeholder="Remain Vacation" class="w100p" />
    </td>
</tr>
<tr>
    <th scope="row">Main Department</th>
    <td colspan="2">
    <select class="w100p" id="eHPsearchdepartment" name="searchdepartment"  >
        <option selected>Choose One</option>
         <c:forEach var="list" items="${mainDeptList}" varStatus="status">
             <option value="${list.deptId}">${list.deptName } </option>
        </c:forEach>
    </select>
    </td>
    <th scope="row">Sub Department</th>
    <td colspan="2">
    <select class="w100p" id="eHPinputSubDept" name="inputSubDept">
        <option selected>Choose One</option>
        <c:forEach var="list" items="${subDeptList}" varStatus="status">
             <option value="${list.codeId}">${list.codeName } </option>
        </c:forEach>
    </select>
    </td>
</tr> --%>
<!-- <tr>
<th scope="row">Businesses Type</th>
      <td>
         <select class="w100p" id="eHPbusinessType" name="businessType" disabled = "disabled">
    </select>
    </td>
  <th scope="row">Hospitalization</th>
<td>
    <span><input type="checkbox" id="eHPhsptlzCheck" name="hsptlzCheck" disabled = "disabled"/></span>
 </td>


 <td>
 </td>
</tr> -->
<%-- <tr id="trMobileUseYn">
    <th scope="row">Mobile App</th>
    <td colspan="4">
        <label><input type="radio" name="mobileUseYn" id="eHPmobileUseYn" value="Y" <c:if test="${memberView.mobileUseYn eq 'Y'}">checked</c:if>/><span>Use</span></label>
        <label><input type="radio" name="mobileUseYn" id="eHPmobileUseYn" value="N" <c:if test="${memberView.mobileUseYn eq 'N'}">checked</c:if>/><span>Unused</span></label>
    </td>
</tr> --%>
</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h2>Bank Account Information</h2>
</aside><!-- title_line end -->

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
    <th scope="row">Issued Bank<span class="must">*</span></th>
    <td>
    <select class="w100p" id="eHPissuedBank" name="issuedBank">
    </select>
    </td>
    <th scope="row">Bank Account No<span class="must">*</span></th>
    <td>
    <input type="text" title="" placeholder="Bank Account No" class="w100p" id="eHPbankAccNo"  name="bankAccNo" onKeyDown="checkBankAccNoEnter()"
        onKeypress="if(event.keyCode < 45 || event.keyCode > 57) event.returnValue = false;" style = "IME-MODE:disabled;"/>
    </td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h2>Language Proficiency</h2>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:180px" />
    <col style="width:*" />
</colgroup>
<tbody>
<!-- <tr>
    <th scope="row">Education Level</th>
    <td>
    <select class="w100p" id="eHPeducationLvl" name="educationLvl">
    </select>
    </td>
    <th scope="row">Language</th>
    <td>
    <select class="w100p" id="eHPlanguage" name="language">
    </select>
    </td>
</tr> -->
</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h2>Starter Kit & ID Tag</h2>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
      <th scope="row">Collection Branch<span class="must">*</span></th>
            <td colspan="5">
       <select class="w100p" id="eHPcollctionBrnch" name="collectionBrnch">
                <option value="" selected>Select Branch</option>
        <c:forEach var="list" items="${SOBranch}" varStatus="status">
           <option value="${list.codeId}">${list.codeName}</option>
        </c:forEach>
        </select>
    </td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="title_line" ><!-- title_line start -->
<h2>Agreement</h2>
</aside><!-- title_line end -->

<table class="type1" id="hideContent"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
</colgroup>
<tbody>
<%-- <tr>
    <th scope="row"  class="hideContent">Cody PA Expiry<span class="must">*</span></th>
    <td  class="hideContent">
    <span><span><c:out value="${PAExpired.agExprDt}"/></span></span>
    <input type="text" title="" placeholder="DD/MM/YYYY" class="j_date" id="eHPcodyPaExpr" name="codyPaExpr"  value="${PAExpired.agExprDt}"/>
    </td>
</tr> --%>
</tbody>
</table><!-- table end -->

<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#" onClick="javascript:fn_saveConfirm()">SAVE</a></p></li>
    <li><p class="btn_blue2 big"><a href="#" onClick="javascript:fn_close()">CANCEL</a></p></li>
</ul>

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:120px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:180px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">MCode</th>
    <td>
    <input type="text" title="" placeholder="MCode" class="w100p" id="eHPspouseCode" name="spouseCode"  value="<c:out value="${memberView.aplicntSpouseCode}"/>"/>
    </td>
    <th scope="row">Spouse Name</th>
    <td>
    <input type="text" title="" placeholder="Spouse Nam" class="w100p" id="eHPspouseName" name="spouseName" value="<c:out value="${memberView.aplicntSpouseName}"/>"/>
    </td>
    <th scope="row">NRIC / Passport No.</th>
    <td>
    <input type="text" title="" placeholder="NRIC / Passport No." class="w100p" id="eHPspouseNric" name="spouseNric" value="<c:out value="${memberView.aplicntSpouseNric}"/>" />
    </td>
</tr>
<tr>
    <th scope="row">Occupation</th>
    <td>
    <input type="text" title="" placeholder="Occupation" class="w100p" id="eHPspouseOcc" value="<c:out value="${memberView.aplicntSpouseOcpat}"/>" />
    </td>
    <th scope="row">Date of Birth</th>
    <td>
    <input type="text" title="" placeholder="DD/MM/YYYY" class="j_date" id="eHPspouseDob" name="spouseDob" value="<c:out value="${memberView.aplicntSpouseDob}"/>" />
    </td>
    <th scope="row">Contact No.</th>
    <td>
    <input type="text" title="" placeholder="Contact No. (Numberic Only)" class="w100p" id="eHPspouseContat" name="spouseContat" value="<c:out value="${memberView.aplicntSpouseTelCntc}"/>" />
    </td>
</tr>
</tbody>
</table><!-- table end -->

<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#" onClick="javascript:fn_saveConfirm()">SAVE</a></p></li>
    <li><p class="btn_blue2 big"><a href="#" onClick="javascript:fn_close()">CANCEL</a></p></li>
</ul>

</article><!-- tap_area end -->

</form>


<article class="tap_area"><!-- tap_area start -->

<aside class="title_line"><!-- title_line start -->
<h2>Installation Address</h2>
</aside><!-- title_line end -->
<form id="eHPinsAddressForm" name="insAddressForm" method="POST">
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
                <input type="text" title="" id="eHPsearchSt" name="searchSt" placeholder="" class="" value="${memberView.area}"/><a href="#" onclick="fn_addrSearch()" class="search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
                </td>
            </tr>
            <tr>
                <th scope="row" >Address Detail<span class="must">*</span></th>
                <td colspan="3">
                <input type="text" title="" id="eHPaddrDtl" name="addrDtl" placeholder="Detail Address" class="w100p" value="<c:out value="${memberView.addrDtl}"/>" />
                </td>
            </tr>
            <tr>
                <th scope="row" >Street</th>
                <td colspan="3">
                <input type="text" title="" id="eHPstreetDtl" name="streetDtl" placeholder="Detail Address" class="w100p" value="<c:out value="${memberView.street}"/>" />
                </td>
            </tr>
            <tr>
               <th scope="row">Area(4)<span class="must">*</span></th>
                <td colspan="3">
                <select class="w100p" id="eHPmArea"  name="mArea" onchange="javascript : fn_getAreaId()" ></select>
                </td>
            </tr>
            <tr>
                 <th scope="row">City(2)<span class="must">*</span></th>
                <td>
                <select class="w100p" id="eHPmCity"  name="mCity" onchange="javascript : fn_selectCity(this.value)"></select>
                </td>
                <th scope="row">PostCode(3)<span class="must">*</span></th>
                <td>
                <select class="w100p" id="eHPmPostCd"  name="mPostCd" onchange="javascript : fn_selectPostCode(this.value)"></select>
                </td>
            </tr>
            <tr>
                <th scope="row">State(1)<span class="must">*</span></th>
                <td>
                <select class="w100p" id="eHPmState"  name="mState" onchange="javascript : fn_selectState(this.value)"></select>
                </td>
                <th scope="row">Country<span class="must">*</span></th>
                <td>
                <input type="text" title="" id="eHPmCountry" name="mCountry" placeholder="" class="w100p readonly" readonly="readonly" value="Malaysia"/>
                </td>
            </tr>
        </tbody>
    </table><!-- table end -->

<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#" onClick="javascript:fn_saveConfirm()">SAVE</a></p></li>
    <li><p class="btn_blue2 big"><a href="#" onClick="javascript:fn_close()">CANCEL</a></p></li>
</ul>
</form>
</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<aside class="title_line"><!-- title_line start -->
<h2>Attachment</h2>
</aside><!-- title_line end -->
<form id="attachmentForm" name="attachmentForm" method="POST">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:30%" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">NRIC<span class="must">*</span></th>
    <td>
        <div class="auto_file2 auto_file3">
            <input type="file" title="file add" id="nricFile" accept="image/*"/>
            <label>
                <input type='text' class='input_text'  id='nricFileTxt' />
                <span class='label_text'><a href='#'>Upload</a></span>
            </label>
               <!--  <span class='label_text'><a href='#' onclick='fn_removeFile("NRIC")'>Remove</a></span> -->
        </div>
    </td>
</tr>
<tr>
    <th scope="row">Bank Passbook/Statement Copy<span class="must">*</span></th>
    <td>
        <div class="auto_file2 auto_file3">
            <input type="file" title="file add" id="statementFile" accept="image/*"/>
            <label>
                <input type='text' class='input_text'  id='statementFileTxt' />
                <span class='label_text'><a href='#'>Upload</a></span>
            </label>
            <!--     <span class='label_text'><a href='#' onclick='fn_removeFile("STAT")'>Remove</a></span> -->
        </div>
    </td>
</tr>
<tr>
    <th scope="row">Passport Photo<span class="must">*</span></th>
    <td>
        <div class="auto_file2 auto_file3">
            <input type="file" title="file add" id="passportFile" accept="image/*"/>
            <label>
                <input type='text' class='input_text' id='passportFileTxt'/>
                <span class='label_text'><a href='#'>Upload</a></span>
            </label>
         <!--        <span class='label_text'><a href='#' onclick='fn_removeFile("PASS")'>Remove</a></span> -->
        </div>
    </td>
</tr>
<tr>
    <th scope="row">Payment RM120</th>
    <td>
        <div class="auto_file2 auto_file3">
            <input type="file" title="file add" id="paymentFile" accept="image/*"/>
            <label>
                <input type='text' class='input_text'   id='paymentFileTxt'/>
                <span class='label_text'><a href='#'>Upload</a></span>
            </label>
               <!--  <span class='label_text'><a href='#' onclick='fn_removeFile("PAY")'>Remove</a></span> -->
        </div>
    </td>
</tr>
<tr>
    <th scope="row">Declaration letter/Others form</th>
    <td>
        <div class="auto_file2 auto_file3">
            <input type="file" title="file add" id="otherFile" accept="image/*"/>
            <label>
                <input type='text' class='input_text'  id='otherFileTxt'/>
                <span class='label_text'><a href='#'>Upload</a></span>
            </label>
            <!--     <span class='label_text'><a href='#' onclick='fn_removeFile("OTH")'>Remove</a></span> -->
        </div>
    </td>
</tr>
<tr>
    <th scope="row">Declaration letter/Others form 2</th>
    <td>
        <div class="auto_file2 auto_file3">
            <input type="file" title="file add" id="otherFile2" accept="image/*"/>
            <label>
                <input type='text' class='input_text'  id='otherFileTxt2'/>
                <span class='label_text'><a href='#'>Upload</a></span>
            </label>
           <!--   <span class='label_text'><a href='#' onclick='fn_removeFile("OTH2")'>Remove</a></span> -->
        </div>
    </td>
</tr>

<tr>
    <td colspan=2><span class="red_text">Only allow picture format (JPG, PNG, JPEG)</span></td>
</tr>
</tbody>
</table>
<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#" onClick="javascript:fn_saveConfirm()">SAVE</a></p></li>
    <li><p class="btn_blue2 big"><a href="#" onClick="javascript:fn_close()">CANCEL</a></p></li>
</ul>
</form>
</article><!-- tap_area end -->
</form>
</section><!-- tap_wrap end -->

</div><!-- popup_wrap end -->

