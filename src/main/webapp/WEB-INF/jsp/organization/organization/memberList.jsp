<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<style type="text/css">

/* 커스텀 행 스타일 */
.my-yellow-style {
    background:#FFE400;
    font-weight:bold;
    color:#22741C;
}

.my-blue-style {
    background:#8FD1FF;
    font-weight:bold;
    color:#22741C;
}

.my-grey-style {
    background:#9DACB7;
    font-weight:bold;
    color:#22741C;
}

.my-orange-style {
    background:#FF9B1D;
    font-weight:bold;
    color:#22741C;
}
</style>

<script type="text/javaScript">
var myGridID;
var excelGridID;
var grpOrgList = new Array(); // Group Organization List
var orgList = new Array(); // Organization List
var selRowIndex;

var selectedGridValue;

function fn_memberListNew(){
     Common.popupDiv("/organization/selectMemberListNewPop.do?isPop=true", "searchForm"  ,null , true  ,'fn_memberListNew');
}

function fn_memberListSearch(){


    if(fn_validSearchList()) {
        selRowIndex = null;
        /* if ($("#memTypeCom").val() == '5' ) {
            AUIGrid.showColumnByDataField(myGridID, "testResult");
            AUIGrid.setColumnProp( myGridID, 5, { width : 130, visible : true } );
        } else {
            AUIGrid.setColumnProp( myGridID, 5, { width : 0, visible : false } );
        } */

        Common.ajax("GET", "/organization/memberListSearch", $("#searchForm").serialize(), function(result) {
            console.log("성공.");
            //console.log("data : " + result);

            var isTrainee = 0;
            var isHp = false;
            for (var i=0; i<result.length; i++) {
                if (result[i]["membertype"] == 5) {
                    isTrainee = 1;

                }else if (result[i]["hpType"] != "" && result[i]["hpType"] != null){
                    isHp = true;
                }
                    else {
                    result[i]["testResult"] = "";
                }
            }

            if(isHp == true){
                AUIGrid.showColumnByDataField(myGridID, "hpType");
            }
            else{
                AUIGrid.hideColumnByDataField(myGridID, "hpType");
            }
            if (isTrainee != 0) {
                AUIGrid.showColumnByDataField(myGridID, "testResult");
                AUIGrid.setColumnProp( myGridID, 5, { width : 130, visible : true } );
            } else {
                AUIGrid.setColumnProp( myGridID, 5, { width : 0, visible : false } );
            }

            // change row color by its vaccination status. Hui Ding, 14/09/2021
            AUIGrid.setProp(myGridID, "rowStyleFunction", function(rowIndex, item){
                if (item.vaccineStatus == "C") { // completed vaccine
                    return "my-yellow-style";
                } else if (item.vaccineStatus == "D"){
                    if (item.reasonId == '6504' || item.reasonId == '6505') {
                        return "my-orange-style";
                    } else {
                        return "my-grey-style";
                    }
                } else if (item.vaccineStatus == "P"){
                    return "my-blue-style";
                } else {
                    return "";
                }
            });


            AUIGrid.setGridData(myGridID, result);

            // EXCEL Set Row Colour and Grid
            AUIGrid.setProp(excelGridID, "rowStyleFunction", function(rowIndex, item){
                if (item.vaccineStatus == "C") { // completed vaccine
                    return "my-yellow-style";
                } else if (item.vaccineStatus == "D"){
                    if (item.reasonId == '6504' || item.reasonId == '6505') {
                        return "my-orange-style";
                    } else {
                        return "my-grey-style";
                    }
                } else if (item.vaccineStatus == "P"){
                    return "my-blue-style";
                } else {
                    return "";
                }
            });


            AUIGrid.setGridData(excelGridID, result);
        });
    }


}

function fn_validSearchList() {
    var isValid = true, msg = "";

    if(FormUtil.isEmpty($('#code').val())
    && FormUtil.isEmpty($('#name').val())
    && FormUtil.isEmpty($('#icNum').val())
    && FormUtil.isEmpty($('#birth').val())
    && FormUtil.isEmpty($('#keyBranch').val())
    && FormUtil.isEmpty($('#nation').val())
    && FormUtil.isEmpty($('#race').val())
    && FormUtil.isEmpty($('#contact').val())
    && FormUtil.isEmpty($('#position').val())
    && FormUtil.isEmpty($('#sponsor').val())
    && FormUtil.isEmpty($('#keyUser').val())
    && FormUtil.isEmpty($('#orgCode').val())
    && FormUtil.isEmpty($('#grpCode').val())
    && FormUtil.isEmpty($('#deptCode').val())
    ) {

        if(FormUtil.isEmpty($('#createDate').val()) || FormUtil.isEmpty($('#endDate').val())) {
            isValid = false;
            msg += '* <spring:message code="sal.alert.msg.selKeyInDt" /><br/>';
        }
        else {
            var diffDay = fn_diffDate($('#createDate').val(), $('#endDate').val());

            if(diffDay > 91 || diffDay < 0) {
                isValid = false;
                msg += '* <spring:message code="sal.alert.msg.srchKeyInDt" />';
            }
        }
    }

    if(!isValid) Common.alert('<spring:message code="sal.title.text.memberSrch" />' + DEFAULT_DELIMITER + "<b>"+msg+"</b>");

    return isValid;
}

function fn_diffDate(startDt, endDt) {
    var arrDt1 = startDt.split("/");
    var arrDt2 = endDt.split("/");

    var dt1 = new Date(arrDt1[2], arrDt1[1]-1, arrDt1[0]);
    var dt2 = new Date(arrDt2[2], arrDt2[1]-1, arrDt2[0]);

    var diff = new Date(dt2 - dt1);
    var day = diff/1000/60/60/24;

    return day;
}

function fn_excelDown(){
    // type : "xlsx", "csv", "txt", "xml", "json", "pdf", "object"
    GridCommon.exportTo("excel_list_grid_wrap", "xlsx", "MemberList");
}

function fn_TerminateResign(val){

console.log( memberType )



    if(val == '1'){
        if (memberType == 1 || memberType == 2 || memberType == 3 || memberType == 4 || memberType ==  7 || memberType ==  5758 || memberType ==  6672) { // ADDED HOMECARE -- BY TOMMY
             var jsonObj = {
                         MemberID :memberid,
                        MemberType : memberType
                };
            console.log("MemberID="+memberid+"&MemberType="+memberType+"&codeValue=1");
            Common.popupDiv("/organization/requestTerminateResign.do?isPop=true&MemberID="+memberid+"&MemberType="+memberType+"&codeValue=1", null ,null , true  ,'_fn_TerminateResignDiv');
        } else {
            Common.alert("Only available to entry with Terminate/Resign Request in regular type of member");
        }
    }else{
       if (memberType == 1 || memberType == 2 || memberType == 3 || memberType == 4 || memberType == 7 || memberType ==  5758 || memberType ==  6672) { // ADDED HOMECARE -- BY TOMMY
            var jsonObj = {
                     MemberID :memberid,
                    MemberType : memberType
            };
            console.log("MemberID="+memberid+"&MemberType="+memberType+"&codeValue=2");
            Common.popupDiv("/organization/requestTerminateResign.do?isPop=true&MemberID="+memberid+"&MemberType="+memberType+"&codeValue=2" , null ,null , true  ,'_fn_TerminateResignDiv');
        } else {
            Common.alert("Only available to entry with Promote/Demote Request in regular type of member");
        }
    }

}

function fn_requestVacationPop(){
     var jsonObj = {
             MemberID :memberid,
            MemberType : memberType
    };

    console.log("MemberID="+memberid+"&MemberType="+memberType);

    if (memberType == 3 ) {
        Common.popupDiv("/organization/requestVacationPop.do?isPop=true&MemberID="+memberid+"&MemberType="+memberType ,  null ,null , true  ,'_fn_requestVacationPopDiv');
    }else {
        Common.alert("Only available to entry with request vacation in case of CT member");
    }
}

 function fn_confirmMemRegisPop(){
     var jsonObj = {
             MemberID :memberid,
            MemberType : memberType,
            MemberCode : membercode
    };
    //Common.popupDiv("/organization/confirmMemRegisPop.do?isPop=true&MemberID="+memberid+"&MemberType="+memberType);

    console.log(memberid + " :: " + memberType + " :: " + traineeType)

    if ( memberType == 5 && (traineeType == 2 || traineeType == 3 || traineeType == 7 || traineeType == 5758|| traineeType == 6672 )) { // ADDED LT BY KEYI

        //alert(testResult);

        if ( testResult == 'Fail' || testResult == 'Absent' ) {
            Common.alert("Can't register the trainee due to test result in Fail/Absent");
            return;
        } else if ( testResult == '' || typeof(testResult) == 'undefined') {
            Common.alert("Please register the test result first");
            return;
        }

        console.log("traineeType :: " + traineeType);

     Common.ajax("GET", "/organization/traineeUpdate.do", {memberId:memberid ,memberType:memberType, memberCode : membercode, traineeType : traineeType }, function(result) {
         console.log("성공.");
         console.log("result1111.");

         if(result.message.code =="99" ) {
             Common.alert(result.message.message);
         }
         else {

                var telMobile = result.telMobile;
                var sms;

             //Common.alert(" New Cody registration has been completed from "+membercode+" to "+ result.message);
                 if ( traineeType == 2) {
                    Common.alert(" Cody registration has been completed. "+membercode+" to "+ result.memCode);
                    sms = 'Your Cody Code: ' + result.memCode + ' is created. PW: Last 6 digits of your NRIC No. Kindly login to e-Trust for activation & confirm Bank acc. no. in 2 days. TQ';
                }

                if ( traineeType == 3) {
                    Common.alert(" CT  registration has been completed. "+membercode+" to "+ result.memCode);
                }

                if ( traineeType == 7) { // ADDED HOMECARE -- BY TOMMY
                    Common.alert(" HT  registration has been completed. "+membercode+" to "+ result.memCode);
                    sms = 'Your HT Code: ' + result.memCode + ' is successfully created. Password: Last 6 digits of your NRIC No. Kindly log in to e-Trust for activation in 2 days. TQ.';
                }

                if ( traineeType == 5758) { // ADDED HOMECARE DELIVERY TECHNICIAN -- BY TOMMY
                    Common.alert(" DT  registration has been completed. "+membercode+" to "+ result.memCode);
                    sms = 'Your DT Code: ' + result.memCode + ' is successfully created. Password: Last 6 digits of your NRIC No. Kindly log in to e-Trust for activation in 2 days. TQ.';
                }

                if ( traineeType == 6672) { // ADDED LOGISTIC TECHNICIAN - BY KEYI
                    Common.alert(" LT  registration has been completed. "+membercode+" to "+ result.memCode);
                    sms = 'Your LT Code: ' + result.memCode + ' is successfully created. Password: Last 6 digits of your NRIC No. Kindly log in to e-Trust for activation in 2 days. TQ.';
                }

                if(telMobile != "") {
                    Common.ajax("GET", "/services/as/sendSMS.do",{rTelNo : telMobile, msg : sms} , function(result) {
                        console.log("sms.");
                        console.log( result);
                    });
                }
              fn_memberListSearch();
         }
     });
    }else {
        Common.alert("Only available to entry with Confirm Member Registration in Case of Trainee Type");
    }
}

function fn_clickHpApproval(){

    $("#aplcntCode").val(membercode);
    $("#aplcntNRIC").val(nric);

    // Added checking if applicant agreed agreement - Kit Wai
    Common.ajax("GET", "/organization/getApplicantInfo", $("#applicantValidateForm").serialize(), function(result) {
        console.log(result);

        if(result.stus == "102" && result.cnfm == "1" && result.cnfm_dt != "1900-01-01") {
            //Common.confirm("Do you want to approve the HP? <br/> Member Code :  "+membercode+"  <br/> Name :"+ memberName , fn_hpMemRegisPop );
            Common.confirm(result.aplicntName + "</br>" +
                                   result.aplicntNric + "</br>" +
                                   result.bnkNm + "</br>" +
                                   "A/C : " + result.aplicntBankAccNo + "</br></br>" +
                                   "Do you want to approve with above information?", fn_hpMemRegisPop);
        } else if (result.stus == "44" && result.cnfm == "0" && result.cnfm_dt == "1900-01-01") {
            Common.alert("Applicant has not accepted agreement.");
        } else if(result.stus == "6") {
            Common.alert("Aplicant has rejected agreement");
        } else if(result.stus == "5") {
            Common.alert("Aplicant has already been approved.");
        } else if(result.stus == "98") {
            Common.alert("Aplicant has been automatically cancelled.");
        }


        if(result.stus == "44" && result.cnfm == "0" && result.cnfm_dt == "1900-01-01") {
            Common.alert("Only accepted agreement applicants may become members.")
        } else {
            //Common.confirm("Do you want to approve the HP? <br/> Member Code :  "+membercode+"  <br/> Name :"+ memberName , fn_hpMemRegisPop );
            Common.confirm(result.aplicntName + "</br>" +
                                   result.aplicntNric + "</br>" +
                                   result.bnkNm + "</br>" +
                                   "A/C : " + result.aplicntBankAccNo + "</br></br>" +
                                   "Do you want to approve with above information?", fn_hpMemRegisPop);
        }
    })
}

function fn_addMemberValidDate(){ // cyc

    /* var selectedItems = AUIGrid.getCheckedRowItems(myGridID);


    if(selectedItems.length  >  0) {
        membercode  =selectedItems[0].item.membercode;
    } */


    Common.popupDiv("/organization/memberValidDateEdit.do" ,{membercode:membercode},null, true,'_editDiv3New' );

}

function fn_clickHpReject(){
      Common.confirm("Do you want to reject the HP? <br/> Member Code :  "+membercode+"  <br/> Name :"+ memberName , function() {
          if($("#userRole").val() == 111 || $("#userRole").val() == 112 || $("#userRole").val() == 113 || $("#userRole").val() == 114) {
              if(statusName == "Pending") {
                  fn_RejectHPMem();
              } else {
                  Common.alert("Member cancellation is not allowed under READY / APPROVED status");
              }
          } else if($("#userRole").val() != 111 || $("#userRole").val() != 112 || $("#userRole").val() != 113 || $("#userRole").val() != 114) {
              if(statusName == "Pending" || statusName == "Ready") {
                  fn_RejectHPMem();
              } else {
                  Common.alert("Member cancellation is not allowed under READY / APPROVED status");
              }
          }
      });
}

function fn_hpMemRegisPop(){
     var jsonObj = {
             MemberID :memberid,
            MemberType : memberType,
            MemberCode : membercode
    };

    if (memberType == "2803" ) {
        if ( statusName == "Ready" ) {

         Common.ajax("GET", "/organization/hpMemRegister.do", {memberId:memberid ,memberType:memberType, nric:nric, MemberCode : membercode }, function(result) {
             console.log("성공.");
             console.log( result);

             if(result !="" ){
                 if (result.message == "There is no address information to the HP applicant code") {
                     Common.alert(result.message);
                 } else if (result.message.substr(0, 33) == "This member is already registered") {
                     Common.alert(result.message);
                 } else {
                     Common.alert(" Health Planner registration has been completed. <br/>Member Code : "+membercode+"  to  "+ result.message );
                     fn_memberListSearch();

                     var newMemCode = result.message;

                     var today = new Date();
                     var dd = today.getDate();
                     var mm = today.getMonth() + 1;
                     var yy = today.getFullYear();
                     if(dd < 10) {
                         dd = '0' + dd;
                     }
                     if(mm < 10) {
                         mm = '0' + mm;
                     }
                     today = dd + '/' + mm + '/' + yy;

                    // Construct approved SMS
                     var apprSms = " COWAY: WELCOME to COWAY family! " +
                                          "Your application for COWAY HP is completed. Your COWAY HP code " + newMemCode + " is ACTIVATED on " + today + ". TQ!";

                     Common.ajax("GET", "/organization/getHPCtc", {src: "member", memCode: newMemCode}, function(result1) {
                         var mobile = result1.mobile;
                         //var email = result1.email;

                         if(mobile != "") {
                             Common.ajax("GET", "/services/as/sendSMS.do",{rTelNo:mobile , msg :apprSms} , function(result) {
                                 console.log("sms.");
                                 console.log( result);
                             });
                         }
                     })
                 }
             }

         });
        } else {
            Common.alert("Only available to entry Ready is in a case of Status");
        }
    } else {
        Common.alert("Only available to entry with HP Approval is in a case of HP Applicant");
    }
}
function fn_RejectHPMem(){
     if (memberType == "2803" ) {
         Common.ajax("GET", "/organization/hpMemReject.do", {memberId:memberid ,memberType:memberType, nric:nric }, function(result) {
             if(result.message == "success"){
                   Common.alert("Successfully reject HP Applicant :" + membercode);

                   var today = new Date();
                    var dd = today.getDate();
                    var mm = today.getMonth() + 1;
                    var yy = today.getFullYear();
                    if(dd < 10) {
                        dd = '0' + dd;
                    }
                    if(mm < 10) {
                        mm = '0' + mm;
                    }
                    today = dd + '/' + mm + '/' + yy;

                     // Construct approved SMS
                    var apprSms = " COWAY: Sorry to inform that your application for " +
                                         "COWAY HP has been REJECTED on " + today + ". Kindly refer to your sponsor for enquiry. TQ!";

                    Common.ajax("GET", "/organization/getHPCtc", {src: "aplicant", memCode: membercode}, function(result1) {
                        var mobile = result1.mobile;
                        //var email = result1.email;

                        if(mobile != "") {
                            Common.ajax("GET", "/services/as/sendSMS.do",{rTelNo:mobile , msg :apprSms} , function(result) {
                                console.log("sms.");
                                console.log( result);
                            });
                        }
                    })
                 }
             });
        } else {
            Common.alert("Only available to entry with HP Reject is in a case of HP Applicant");
        }
}

//Start AUIGrid --start Load Page- user 1st click Member
$(document).ready(function() {

    if("${SESSION_INFO.memberLevel}" =="1"){

        $("#orgCode").val("${orgCode}");
        $("#orgCode").attr("class", "w100p readonly");
        $("#orgCode").attr("readonly", "readonly");

    }else if("${SESSION_INFO.memberLevel}" =="2"){

        $("#orgCode").val("${orgCode}");
        $("#orgCode").attr("class", "w100p readonly");
        $("#orgCode").attr("readonly", "readonly");

        $("#grpCode").val("${grpCode}");
        $("#grpCode").attr("class", "w100p readonly");
        $("#grpCode").attr("readonly", "readonly");

    }else if("${SESSION_INFO.memberLevel}" =="3"){

        $("#orgCode").val("${orgCode}");
        $("#orgCode").attr("class", "w100p readonly");
        $("#orgCode").attr("readonly", "readonly");

        $("#grpCode").val("${grpCode}");
        $("#grpCode").attr("class", "w100p readonly");
        $("#grpCode").attr("readonly", "readonly");

        $("#deptCode").val("${deptCode}");
        $("#deptCode").attr("class", "w100p readonly");
        $("#deptCode").attr("readonly", "readonly");

    }else if("${SESSION_INFO.memberLevel}" =="4"){

        $("#orgCode").val("${orgCode}");
        $("#orgCode").attr("class", "w100p readonly");
        $("#orgCode").attr("readonly", "readonly");

        $("#grpCode").val("${grpCode}");
        $("#grpCode").attr("class", "w100p readonly");
        $("#grpCode").attr("readonly", "readonly");

        $("#deptCode").val("${deptCode}");
        $("#deptCode").attr("class", "w100p readonly");
        $("#deptCode").attr("readonly", "readonly");

        $("#code").val("${memCode}");
        $("#code").attr("class", "w100p readonly");
        $("#code").attr("readonly", "readonly");


        $("#memLvl").attr("class", "w100p readonly");
        $("#memLvl").attr("readonly", "readonly");
    }

    // AUIGrid 그리드를 생성합니다.
    createAUIGrid();
    createAUIGridExcel();

   // AUIGrid.setSelectionMode(myGridID, "singleRow");

 // 셀 더블클릭 이벤트 바인딩
     AUIGrid.bind(myGridID, "cellDoubleClick", function(event) {
            //alert(event.rowIndex+ " - double clicked!! : " + event.value + " - rowValue : " + AUIGrid.getCellValue(myGridID, event.rowIndex, "memberid"));
            Common.popupDiv("/organization/selectMemberListDetailPop.do?isPop=true&MemberID=" + AUIGrid.getCellValue(myGridID, event.rowIndex, "memberid")+"&MemberType=" + AUIGrid.getCellValue(myGridID, event.rowIndex, "membertype"), "");
     });

     AUIGrid.bind(myGridID, "cellClick", function(event) {
        selRowIndex = event.rowIndex;
        //alert(event.rowIndex+ " -cellClick : " + event.value + " - rowValue : " + AUIGrid.getCellValue(myGridID, event.rowIndex, "memberid"));

        /* memberid =  AUIGrid.getCellValue(myGridID, event.rowIndex, "memberid");
        memberType = AUIGrid.getCellValue(myGridID, event.rowIndex, "membertype");
        membercode = AUIGrid.getCellValue(myGridID, event.rowIndex, "membercode");
        statusName = AUIGrid.getCellValue(myGridID, event.rowIndex, "statusName");
        traineeType = AUIGrid.getCellValue(myGridID, event.rowIndex, "traineeType");
        nric = AUIGrid.getCellValue(myGridID, event.rowIndex, "nric");
        memberName = AUIGrid.getCellValue(myGridID, event.rowIndex, "name");
        testResult = AUIGrid.getCellValue(myGridID, event.rowIndex, "testResult"); */

        memberid =  event.item.memberid;
        memberType = event.item.membertype;
        membercode = event.item.membercode;
        statusName = event.item.statusName;
        traineeType = event.item.traineeType;
        nric = event.item.nric;
        memberName = event.item.name;
        testResult = event.item.testResult;

        //Common.popupDiv("/organization/requestTerminateResign.do?isPop=true&MemberID=" + AUIGrid.getCellValue(myGridID, event.rowIndex, "memberid")+"&MemberType=" + AUIGrid.getCellValue(myGridID, event.rowIndex, "membertype"), "");
    });

    $("#position").attr("disabled",true);

    //20211020 - HLTANG - show non vaccine declaration form start
    $("#getNonVaccineDeclare").hide();
    var userRole = $('input:hidden[name="userRole"]').val();
    var username1 = "${SESSION_INFO.userName}";
    console.log("userole" + $("#userRole").val());
    console.log("usertypeid" + "${SESSION_INFO.userTypeId}");
    if(userRole == "130 " || userRole == "137 " // Administrator
        || userRole == "141 " || userRole == "142 " || userRole == "160 " // HR
    //|| userRole =="342 " || userRole =="343 " || userRole =="344 "
        || username1 == "PSLEONG" || username1 == "SHAWN" || username1 == "WAZIEN01" ) {
       console.log("userole1 " + userRole);
       $("#getNonVaccineDeclare").show();
   }else if("${SESSION_INFO.userTypeId}" == "4" || "${SESSION_INFO.userTypeId}" == "6" ){
       var memberID = "${SESSION_INFO.memId}";
       console.log("memberID: " + memberID);

       Common.ajax("GET", "/organization/getVaccineSubmitInfo", {memberID: memberID}, function(result){
           if(result != 0){
               $("#getNonVaccineDeclare").show();
           }
       });
   }
    else{
      var userId = "${SESSION_INFO.userId}";
      var username = "${SESSION_INFO.userName}";
       console.log("userId: " + userId);
       console.log("username: " + username);

       Common.ajax("POST", "/organization/getVaccineListing.do", {MemberID : username}, function(result){
           console.log(result);

           if(result.message == "success." || result.message == "PENDING") {
               $("#getNonVaccineDeclare").show();
               console.log("non vaccine exist");
           }


        });
   }
  //20211020 - HLTANG - show non vaccine declaration form end


    if($("#userRole").val() == "130 " || $("#userRole").val() == "137 " // Administrator
      || $("#userRole").val() == "141 " || $("#userRole").val() == "142 " || $("#userRole").val() == "160 " // HR
    ) {
    }



 });

function createAUIGrid() {
        //AUIGrid 칼럼 설정
        var columnLayout = [ {
            dataField : "codename",
            headerText : "Type Name",
            editable : true,
            width : 130
        }, {
            dataField : "memberid",
            headerText : "MemberID",
            editable : false,
            width : 0
        }, {
            dataField : "membercode",
            headerText : "Member Code",
            editable : false,
            width : 130
        }, {
            dataField : "name",
            headerText : "Member Name",
            editable : false,
            width : 130
        }, /*{
            dataField : "nric",
            headerText : "Member NRIC",
            editable : false,
            style : "my-column",
            width : 130
        },*/ {
            dataField : "statusName",
            headerText : "Status",
            editable : false,
            width : 130,
            labelFunction : function(rowIndex, columnIndex, value, headerText, item, dataField, cItem) {
                // logic processing
                // Return value here, reprocessed or formatted as desired.
                // The return value of the function is immediately printed in the cell.
                 if(item.trmRejoin == 1) {
                        return item.statusName + " (Rejoin)";
                   } else {
                        return item.statusName;
                   }
             }
        },
        {
            dataField : "uniformSize",
            headerText : "Uniform Size",
            editable : false,
            width : 130
        },
        {
            dataField : "muslimahScarft",
            headerText : "Muslimah Scarft",
            editable : false,
            width : 130
        },
        {
            dataField : "innerType",
            headerText : "Inner Type",
            editable : false,
            width : 130
        },
        {
            dataField : "testResult",
            headerText : "Test Result",
            editable : false,
            width : 0,
            visible : false

        },
        {
            dataField : "hpType",
            headerText : "HP Type",
            editable : false,
            width : 130,
            visible : false
        },
        {
            dataField : "neoProStatus",
            headerText : "Neo Pro",
            editable : false,
            width : 130
        },
        {
            dataField : "updated",
            headerText : "Last Update",
            editable : false,
            width : 130
        },
        {
            dataField : "lastActDt",
            headerText : "Last Active Date",
            editable : false,
            width : 130

        },
        {
            dataField : "positionName",
            headerText : "Position Desc",
            editable : false,
            width : 130

        },
        {
            dataField : "membertype",
            headerText : "Member Type",
            width : 0
        },
        {
            dataField : "traineeType",
            headerText : "Trainee Type",
            width : 0
        },
        {
            dataField : "approvedBy",
            headerText : "Approved by",
            editable : false,
            width : 130
        },
        {
            dataField : "crtDt",
            headerText : "Action Date",
            editable : false,
            width : 130
        },
        {
            dataField : "branch",
            headerText : "Approved Branch",
            editable : false,
            width : 130
        },
        {
            dataField : "address",
            headerText : "Address",
            editable : false,
            width : 130
        },
        {
            dataField : "grpCode",
            headerText : "Group Code",
            editable : false,
            width : 130
        },
        {
            dataField : "email",
            visible : false
        }

        /* this is for put EDIT button in grid ,
        {
            dataField : "undefined",
            headerText : "Edit",
            width : 170,
            renderer : {
                  type : "ButtonRenderer",
                  labelText : "Edit",
                  onclick : function(rowIndex, columnIndex, value, item) {
                       //pupupWin
                      $("#_custId").val(item.custId);
                      $("#_custAddId").val(item.custAddId);
                      $("#_custCntcId").val(item.custCntcId);
                      Common.popupDiv("/sales/customer/updateCustomerBasicInfoPop.do", $("#popForm").serializeJSON(), null , true , '_editDiv1');
                      }
             }
        } */];


         // 그리드 속성 설정
        var gridPros = {

                 usePaging           : true,         //페이징 사용
                 pageRowCount        : 20,           //한 화면에 출력되는 행 개수 20(기본값:20)
                 editable            : false,
                 fixedColumnCount    : 1,
                 showStateColumn     : false,
                 displayTreeOpen     : false,
                // selectionMode       : "singleRow",  //"multipleCells",
                 headerHeight        : 30,
                 useGroupingPanel    : false,        //그룹핑 패널 사용
                 skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
                 wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
                 showRowNumColumn    : true       //줄번호 칼럼 렌더러 출력
        };

        //myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout, gridPros);
        myGridID = AUIGrid.create("#grid_wrap_memList", columnLayout, gridPros);
    }

    function createAUIGridExcel(){

        //AUIGrid 칼럼 설정
        var excelColumnLayout = [ {
            dataField : "codename",
            headerText : "Type Name",
            editable : true,
            width : 130
        }, {
            dataField : "memberid",
            headerText : "MemberID",
            editable : false,
            width : 0
        }, {
            dataField : "membercode",
            headerText : "Member Code",
            editable : false,
            width : 130
        }, {
            dataField : "name",
            headerText : "Member Name",
            editable : false,
            width : 130
        }, {
            dataField : "statusName",
            headerText : "Status",
            editable : false,
            width : 130,
            labelFunction : function(rowIndex, columnIndex, value, headerText, item, dataField, cItem) {
                // logic processing
                // Return value here, reprocessed or formatted as desired.
                // The return value of the function is immediately printed in the cell.
                 if(item.trmRejoin == 1) {
                        return item.statusName + " (Rejoin)";
                   } else {
                        return item.statusName;
                   }
             }
        },
        {
            dataField : "joinDt",
            headerText : "Join Date",
            editable : false,
            width : 130
        },
        {
            dataField : "uniformSize",
            headerText : "Uniform Size",
            editable : false,
            width : 130
        },
        {
            dataField : "muslimahScarft",
            headerText : "Muslimah Scarft",
            editable : false,
            width : 130
        },
        {
            dataField : "innerType",
            headerText : "Inner Type",
            editable : false,
            width : 130
        },
        {
            dataField : "testResult",
            headerText : "Test Result",
            editable : false,
            width : 0,
            visible : false

        },
        {
            dataField : "hpType",
            headerText : "HP Type",
            editable : false,
            width : 130,
            visible : false
        },
        {
            dataField : "neoProStatus",
            headerText : "Neo Pro",
            editable : false,
            width : 130
        },
        {
            dataField : "updated",
            headerText : "Last Update",
            editable : false,
            width : 130
        },
        {
            dataField : "lastActDt",
            headerText : "Last Active Date",
            editable : false,
            width : 130

        },
        {
            dataField : "positionName",
            headerText : "Position Desc",
            editable : false,
            width : 130

        },
        {
            dataField : "membertype",
            headerText : "Member Type",
            width : 0
        },
        {
            dataField : "traineeType",
            headerText : "Trainee Type",
            width : 0
        },
        {
            dataField : "approvedBy",
            headerText : "Approved by",
            editable : false,
            width : 130
        },
        {
            dataField : "crtDt",
            headerText : "Action Date",
            editable : false,
            width : 130
        },
        {
            dataField : "branch",
            headerText : "Approved Branch",
            editable : false,
            width : 130
        },
        {
            dataField : "address",
            headerText : "Address",
            editable : false,
            width : 130
        },
        {
            dataField : "email",
            headerText : "Email",
            editable : false,
            width : 130
        },
        {
            dataField : "grpCode",
            headerText : "Group Code",
            editable : false,
            width : 130
        }];

        var excelGridPros = {
             enterKeyColumnBase : true,
             useContextMenu : true,
             enableFilter : true,
             showStateColumn : true,
             displayTreeOpen : true,
             noDataMessage : "<spring:message code='sys.info.grid.noDataMessage' />",
             groupingMessage : "<spring:message code='sys.info.grid.groupingMessage' />",
             exportURL : "/common/exportGrid.do"
         };

        excelGridID = GridCommon.createAUIGrid("excel_list_grid_wrap", excelColumnLayout, "", excelGridPros);
    }

function fn_memberEditPop(){
    console.log("/organization/memberListEditPop.do?isPop=true&memberCode=" + membercode+"&MemberID=" + memberid+"&memType=" + memberType, "");
    Common.popupDiv("/organization/memberListEditPop.do?isPop=true&memberCode=" + membercode+"&MemberID=" + memberid+"&memType=" + memberType, "");
}

function fn_branchEditPop(){
     Common.popupDiv("/organization/memberListBranchEditPop.do?isPop=true&memberCode=" + membercode+"&MemberID=" + memberid+"&memType=" + memberType, "");
}

function fn_searchPosition(selectedData){
    $("#position option").remove();
      if(selectedData == "2" || selectedData =="3" || selectedData =="1" || selectedData =="7" || selectedData =="5758" || selectedData =="6672"){
           $("#position").attr("disabled",false);   /*position button enable*/
           Common.ajax("GET",
                    "/organization/positionList.do",
                    "memberType="+selectedData,
                    function(result) {
                        $("#position").append("<option value=''>Select Position</option> " );
                        for(var idx=0; idx < result.length ; idx++){
                            $("#position").append("<option value='" +result[idx].positionLevel+ "'> "+result[idx].positionName+ "</option>");
                        }
                    }
           );
       }else{
           /*position button disable*/
           $("#position").attr("disabled",true);
           /* If you want to set position default value remove under comment.*/
           $("#position").append("<option value=''>Select Account</option> " );

       }
}

function fn_genRawData() {

    var rptNm;
    var rptDownNm;
    var date1;
    var date2;
    var whereSQL;

    var today = new Date();
    var dd = today.getDate();
    var mm = today.getMonth() + 1;
    var yy = today.getFullYear();
    var lastDay = new Date(yy, mm, 0).getDate();
    if(dd < 10) {
        dd = '0' + dd;
    }
    if(mm < 10) {
        mm = '0' + mm;
    }

    if($("#createDate").val() == "" && $("#endDate").val() ==  "") {
        date1 = yy + mm + "01";
        date2 = yy + mm + lastDay;
    } else {
        dt1 = $("#createDate").val().split("/");
        dt2 = $("#endDate").val().split("/");

        date1 = dt1[2] + dt1[1] + dt1[0];
        date2 = dt2[2] + dt2[1] + dt2[0];
    }

    console.log(date1);
    console.log(date2);

    $("#v_dt1").val(date1);
    $("#v_dt2").val(date2);

    if($("#memTypeCom").val() == "") {
        Common.alert("Please select Coway Lady/Health Planner.")
        return false;
    } else if($("#memTypeCom").val() == "1") {
        rptNm = "/organization/HpRawData.rpt";
        rptDownNm = "hpRawData_" + yy + mm + dd;
    } else if($("#memTypeCom").val() == "2") {
        rptNm = "/organization/CodyRawData.rpt";
        rptDownNm = "codyRawData_" + yy + mm + dd;
    }

    $("#reportFileName").val(rptNm);
    $("#reportDownFileName").val(rptDownNm);

    var option = {
            isProcedure : true
        };

    Common.report("rawDataReport", option);
}

function fn_pushCU(){

    let memberId = AUIGrid.getCellValue(myGridID, selRowIndex, "memberid");
    var memEmail = AUIGrid.getCellValue(myGridID, selRowIndex, "email");
    Common.ajax("GET","/organization/selectCntMemSameEmail.do", {email : memEmail}, function(cnt) {
        if(cnt > 1){
            Common.alert("Failed request. Duplicate email");
        }
        else {
            Common.ajax("GET","/organization/pushCU.do", {MemberID : memberId}, function(result) {
                console.log(result);
                if(result.message == 'LMS: User created successfully' || result.status == '00'){
                    Common.alert("Successfully push to CU.");
                }else{
                    Common.alert("Failed Request. Invalid parameter");
                }
            });
        }
    });
}

function fn_pushCU(){

    let memberId = AUIGrid.getCellValue(myGridID, selRowIndex, "memberid");
    var memEmail = AUIGrid.getCellValue(myGridID, selRowIndex, "email");
    Common.ajax("GET","/organization/selectCntMemSameEmail.do", {email : memEmail}, function(cnt) {
        if(cnt > 1){
            Common.alert("Failed request. Duplicate email");
        }
        else {
            Common.ajax("GET","/organization/pushCU.do", {MemberID : memberId}, function(result) {
                console.log(result);
                if(result.message == 'LMS: Successfully create user.'){
                    Common.alert("Successfully push to CU.");
                }else{
                    Common.alert("Failed Request. Invalid parameter");
                }
            });
        }
    });
}

function fn_suspendCU(){

    let memberId = AUIGrid.getCellValue(myGridID, selRowIndex, "memberid");
    var membercode = AUIGrid.getCellValue(myGridID, selRowIndex, "membercode");
    var memEmail = AUIGrid.getCellValue(myGridID, selRowIndex, "email");
    Common.ajax("GET","/organization/suspendCU.do", {username : membercode, email: memEmail, memId: memberId, memCode: membercode}, function(result) {
        console.log(result);
        Common.alert(result.message);
    });
}

$(function() {

    $("#requestToResetMFA").click(function() {
        Common.popupDiv("/organization/requestToResetMFAPop.do", null, null, true);
    });

    $("#approveToResetMFA").click(function() {
        Common.popupDiv("/organization/approveToResetMFAPop.do", null, null, true);
    });

    $("#resetMFA").click(function() {
        Common.popupDiv("/organization/resetMFAPop.do", null, null, true);
    });

    $('#hpYSListingBtn').click(function() {
        Common.popupDiv("/organization/HPYSListingPop.do", null, null, true);
    });

    $('#getHpApplicantURL').click(function() {
        if(selRowIndex >= 0 && selRowIndex != null) {
            if(memberType == "2803") {
                if(memberid == "" || memberid == null) {
                    Common.alert("Please select a applicant.");
                    return false;
                }

                Common.ajax("GET","/organization/getHpAplctUrl.do", {memberID : memberid}, function(result) {
                    console.log(result);
                    Common.confirm("Click OK to copy URL", function() {
                        var url = "http://etrust.my.coway.com/organization/agreementListing.do?MemberID=" + result.aplicntIdntfc + memberid;
                        $("#aplctUrl").val(url);
                        $("#aplctUrl").attr("type", "text").select();
                        document.execCommand("copy");
                        $("#aplctUrl").attr("type", "hidden");
                    });
                });

            } else {
                Common.alert("e-Agreement URL is not required.");
            }
        } else {
            Common.alert("Please select a member!");
        }
    });

    $('#meetingPointMgmt').click(function() {
        Common.popupDiv("/organization/meetingPointMgmt.do?isPop=true", "");
    });

    //hpPwReset
    $("#hpPwReset").click(function() {
        if(selRowIndex >= 0 && selRowIndex != null) {
            if(memberType == "1") {
                Common.popupDiv("/organization/resetOrgPW.do", {memberID : memberid, memType : "1", memberCode : membercode}, null, true, 'editPWHP');
            } else {
                Common.alert("Only HP Member is allowed!");
            }
        } else {
            Common.alert("Please select a member!");
        }
    });

    $("#cdPwReset").click(function() {
        if(selRowIndex >= 0 && selRowIndex != null) {
            if(memberType == "2") {
                Common.popupDiv("/organization/resetOrgPW.do", {memberID : memberid,  memType : "2", memberCode : membercode}, null, true, 'editPWCD');
            } else {
                Common.alert("Only CD Member is allowed!");
            }

        } else {
            Common.alert("Please select a member!");
        }
    });

    $("#htPwReset").click(function() {
        if(selRowIndex >= 0 && selRowIndex != null) {
            if(memberType == "7") {
                Common.popupDiv("/organization/resetOrgPW.do", {memberID : memberid,  memType : "7", memberCode : membercode}, null, true, 'editPWHT');
            } else {
                Common.alert("Only HT Member is allowed!");
            }

        } else {
            Common.alert("Please select a member!");
        }
    });

    $("#htContactList").click(function() {

//       if('${SESSION_INFO.userTypeId}' == "7") {
             Common.popupDiv("/organization/getHTContactList.do", null, null, true);
//          } else {
//              Common.alert("Only HT Member is allowed!");
//          }
    });

    $("#getNonVaccineDeclare").click(function() {
        /* if($("#code").val() == null){
            Common.alert("Admin need to key in value for 'Code' value' ! ");
        } */

        console.log("{SESSION_INFO.userTypeId: " + "${SESSION_INFO.userTypeId}");

        var userRole = $('input:hidden[name="userRole"]').val();
        var userId = "";
        var username = "";
        var username1 = "${SESSION_INFO.userName}";
        console.log("userole" + $("#userRole").val());
        if(userRole == "130 " || userRole == "137 " // Administrator
            || userRole == "141 " || userRole == "142 " || userRole == "160 " // HR
                //|| userRole =="342 " || userRole =="343 " || userRole =="344 "
                || username1 == "PSLEONG" || username1 == "SHAWN" || username1 == "WAZIEN01"
                ) {

            if(selRowIndex >= 0 && selRowIndex != null) {
                Common.ajax("POST", "/organization/getVaccineListing.do", {MemberID : membercode}, function(result){
                    console.log(result);

                    if(result.message == "PENDING") {
                        Common.alert("Pending user fill in declaration form.");
                    }
                    else if(result.message == "success.") {
                        btnGeneratePDF_Click(membercode);
                    }else{
                        Common.alert("No record found for this user.");
                    }


                 });
            }else{
                Common.alert("Please select a member! ");
            }


        }
        else if("${SESSION_INFO.userTypeId}" == "4" || "${SESSION_INFO.userTypeId}" == "6"){
            var memberID = "${SESSION_INFO.memId}";
            console.log("memberID: " + memberID);

            var username2;
            Common.ajax("GET", "/organization/getVaccineSubmitInfo", {memberID: memberID}, function(result){
                if(result.cnt == 1){
                    username = "${SESSION_INFO.userName}";
                    btnGeneratePDF_Click(username);
                }else{
                    Common.alert("Pending user fill in declaration form.");
                }
            });
        }
        else{
            userId = "${SESSION_INFO.userId}";
            username = "${SESSION_INFO.userName}";
            console.log("userId: " + userId);
            console.log("username: " + username);

            Common.ajax("POST", "/organization/getVaccineListing.do", {MemberID : username}, function(result){
                console.log(result);

                if(result.message == "PENDING") {
                    Common.alert("Pending user fill in declaration form.");
                }
                else if(result.message == "success.") {
                    btnGeneratePDF_Click(username);
                }else{
                    Common.alert("No record found for this user.");
                }


             });

        }
    });

    $("#rejoinRawListing").click(function() {
            Common.popupDiv("/organization/rejoinRawReportPop.do", null, null, true);
   });

    $('#paExpiry').click(function() {
         var date = new Date();
         var whereSeq = "";
         var month = date.getMonth() + 1;
         var day = date.getDate();
         var memLvl = "${SESSION_INFO.memberLevel}"


         if (date.getDate() < 10) {
           day = "0" + date.getDate();
         }

          if (memLvl == "1"){
              $("#orgCode").val("${orgCode}");

            if($("#orgCode").val() != '' && $("#orgCode").val() != null) {
             whereSeq += "AND O3.ORG_CODE = '" +  $("#orgCode").val() + "'";
        }else{
               Common.alert('Missing ORG code <br> download failed <br> ');
               return;

        }
          }


         if (memLvl == "2") {
             if ($("#grpCode").val() != '' && $("#grpCode").val() != null) {
                whereSeq += "AND O3.GRP_CODE = '" + $("#grpCode").val() + "'" ;
        }else{
            Common.alert('Missing GRP code <br> download failed ');
            return;

     }
         }


         if (memLvl == "3") {
             if ($("#deptCode").val() != '' && $("#deptCode").val() != null) {
             whereSeq += "AND O3.DEPT_CODE = '" + $("#deptCode").val() +  "'";
        }else{
            Common.alert('Missing DEPT code <br> download failed ');
            return;

     }
         }



         console.log(whereSeq);


         $("#PAExpiryReport #V_WHERESQL").val(whereSeq);
         $("#PAExpiryReport #reportFileName").val('/organization/PAExpiry.rpt');
         $("#PAExpiryReport #viewType").val("EXCEL");
         $("#PAExpiryReport #reportDownFileName").val("PAExpiry_" + day + month + date.getFullYear());

         var option = {
                    isProcedure : true,
                  };

         Common.report("PAExpiryReport", option);
    });

    function btnGeneratePDF_Click(username){
        console.log("report2: " + username);
            var memType = "";
            var whereSQL = "";
            var orderBySQL = "";



            var date = new Date().getDate();
            if(date.toString().length == 1){
                date = "0" + date;
            }

            /* $("#reportFileName").val("/organization/NonVaccinationReport_PDF.rpt");
            $("#reportDownFileName").val("NoticeofSafetyComplianceforNon-VaccinatedIndividual"+date+(new Date().getMonth()+1)+new Date().getFullYear());
            $("#viewType").val("PDF"); */

            $("#nonVaccineReport #viewType").val("PDF");
            $("#nonVaccineReport #reportFileName").val("/organization/NonVaccinationReport_PDF.rpt");
            $("#nonVaccineReport #reportDownFileName").val("NoticeofSafetyComplianceforNon-VaccinatedIndividual"+date+(new Date().getMonth()+1)+new Date().getFullYear());

            $("#nonVaccineReport #V_WHERESQL").val(whereSQL);
            $("#nonVaccineReport #V_ORDERBYSQL").val(orderBySQL);
            $("#nonVaccineReport #V_SELECTSQL").val("");
            $("#nonVaccineReport #V_FULLSQL").val("");
            $("#nonVaccineReport #username").val(username);


            // 프로시져로 구성된 경우 꼭 아래 option을 넘겨야 함.
            var option = {
                    isProcedure : true // procedure 로 구성된 리포트 인경우 필수.  => /payment/PaymentListing_Excel.rpt 는 프로시져로 구성된 파일임.
            };

            Common.report("nonVaccineReport", option);

    }
});

function fn_socialMediaInfo(){
    var selectedItems = AUIGrid.getSelectedItems(myGridID);

    if(selectedItems == null || selectedItems.length <= 0 ){
        Common.alert('<spring:message code="service.msg.NoRcd"/>');
        return;
    }
    else
    {
        var status = selectedItems[0].item.status;
        var memberid = selectedItems[0].item.memberid;
        var memberType = selectedItems[0].item.membertype;
        var membercode = selectedItems[0].item.membercode;
        var LoginMemCode = "${memCode}";

        if (memberType != 1) {
            Common.alert("Social media info only allowed for HP. ");
            return;
        }

        if (status != 1) {
            Common.alert("Social media info only allowed for active HP. ");
            return;
        }

        if (LoginMemCode != membercode) {
            Common.alert("HP can only edit own social media info. ");
            return;
        }

        Common.popupDiv("/organization/memberSocialMediaPop.do?isPop=true&memberCode=" + membercode+"&MemberID=" + memberid+"&memType=" + memberType, "");

    }
}

</script>

<!-- --------------------------------------DESIGN------------------------------------------------ -->

<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>Organization</li>
    <li>Member</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>Member</h2>
<ul class="right_btns">
<c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
    <li><p class="btn_blue"><a href="javascript:fn_memberListNew();">New</a></p></li>
</c:if>
<%-- <c:if test="${PAGE_AUTH.funcView == 'Y'}"> --%>
    <li><p class="btn_blue"><a href="javascript:fn_memberListSearch();"><span class="search"></span>Search</a></p></li>
<%-- </c:if>    --%>
<c:if test="${PAGE_AUTH.funcUserDefine2 == 'Y'}">
    <li><p class="btn_blue"><a href="javascript:fn_TerminateResign('1')">Request Terminate/Resign</a></p></li>
</c:if>
<c:if test="${PAGE_AUTH.funcUserDefine3 == 'Y'}">
    <li><p class="btn_blue"><a href="javascript:fn_TerminateResign('2')">Request Promote/Demote</a></p></li>
</c:if>
<c:if test="${PAGE_AUTH.funcUserDefine4 == 'Y'}">
    <li><p class="btn_blue"><a href="javascript:fn_memberEditPop()">Member Edit</a></p></li>
</c:if>
<!--
<c:if test="${PAGE_AUTH.funcUserDefine4 == 'Y'}">
    <li><p class="btn_blue"><a href="javascript:fn_branchEditPop()">Branch Edit</a></p></li>
</c:if>
 -->
<c:if test="${PAGE_AUTH.funcUserDefine5 == 'Y'}">
    <li><p class="btn_blue"><a href="javascript:fn_requestVacationPop()">Request Vacation </a></p></li>
</c:if>
 <c:if test="${PAGE_AUTH.funcUserDefine6 == 'Y'}">
    <li><p class="btn_blue"><a href="javascript:fn_confirmMemRegisPop()">Confirm Member Registration </a></p></li>
</c:if>
 <c:if test="${PAGE_AUTH.funcUserDefine7 == 'Y'}">
    <li><p class="btn_blue"><a href="javascript:fn_clickHpApproval()">HP Approval</a></p></li>
</c:if>
 <c:if test="${PAGE_AUTH.funcUserDefine16 == 'Y'}">
    <li><p class="btn_blue"><a href="javascript:fn_socialMediaInfo()">Social Media Info</a></p></li>
</c:if>
 <c:if test="${PAGE_AUTH.funcUserDefine4 == 'Y'}">
    <li><p class="btn_blue"><a href="javascript:fn_addMemberValidDate()">Member Valid date</a></p></li>
</c:if>
 <c:if test="${PAGE_AUTH.funcUserDefine8 == 'Y'}">
    <li><p class="btn_blue"><a href="javascript:fn_clickHpReject()">HP Reject</a></p></li>
</c:if>
 <c:if test="${PAGE_AUTH.funcUserDefine9 == 'Y'}">
    <li><p class="btn_blue"><a href="javascript:fn_genRawData()">Raw Data Download</a></p></li>
</c:if>
 <c:if test="${PAGE_AUTH.funcUserDefine18 == 'Y'}">
    <li><p class="btn_blue"><a href="javascript:fn_pushCU()">Push to CU</a></p></li>
</c:if>
 <c:if test="${PAGE_AUTH.funcUserDefine18 == 'Y'}">
    <li><p class="btn_blue"><a href="javascript:fn_suspendCU()">Request Suspend</a></p></li>
</c:if>

</ul>
</aside><!-- title_line end -->

<input type="hidden" id="userRole" name="userRole" value="${userRole} " />
<input type="hidden" id="aplctUrl" name="aplctUrl" style="visible:false"/>

<form id="rawDataReport" name="rawDataReport">
    <input type="hidden" id="reportFileName" name="reportFileName" value="" />
    <input type="hidden" id="viewType" name="viewType" value="EXCEL" />
    <input type="hidden" id="reportDownFileName" name="reportDownFileName" value="" />

    <input type="hidden" id="v_dt1" name="v_dt1" value="" />
    <input type="hidden" id="v_dt2" name="v_dt2" value="" />
</form>

<form id="nonVaccineReport" name="nonVaccineReport">
    <input type="hidden" id="reportFileName" name="reportFileName" value="" />
    <input type="hidden" id="viewType" name="viewType" value="PDF" />
    <input type="hidden" id="reportDownFileName" name="reportDownFileName" value="" />

    <input type="hidden" id="username" name="username" value="" />

</form>
<form id="PAExpiryReport" name="PAExpiryReport">
    <input type="hidden" id="reportFileName" name="reportFileName" value="" />
    <input type="hidden" id="viewType" name="viewType" value="EXCEL" />
    <input type="hidden" id="reportDownFileName" name="reportDownFileName" value="" />

    <input type="hidden" id="V_WHERESQL" name="V_WHERESQL" value="" />

</form>

<section class="search_table"><!-- search_table start -->
<form action="#" id="searchForm" method="post">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Member Type</th>
    <td>

    <!-- By KV start - when memtypecom selected item then go to fn_searchPosition function-->
    <select class="w100p" id="memTypeCom" name="memTypeCom" onchange="fn_searchPosition(this.value)">
     <!-- By KV end - when memtypecom selected item then go to fn_searchPosition function-->

        <option value="" selected>Select Account</option>
         <c:forEach var="list" items="${memberType }" varStatus="status">
           <option value="${list.codeId}">${list.codeName}</option>
        </c:forEach>
        <option value="Rejoin">Rejoin</option>
    </select>
    </td>
    <th scope="row">Code</th>
    <td>
    <input type="text" title="Code" placeholder="" class="w100p" id="code" name="code" />
    </td>
    <th scope="row">Name</th>
    <td>
    <input type="text" title="Name" placeholder="" class="w100p" id="name" name="name" />
    </td>
    <th scope="row">IC Number</th>
    <td>
    <input type="text" title="IC Number" placeholder="" class="w100p" id="icNum" name="icNum" />
    </td>
</tr>
<tr>
    <th scope="row">Date Of Birth</th>
    <td>
    <input type="text" title="Date Of Birth"  placeholder="DD/MM/YYYY"  class="j_date"  id="birth" name="birth"/>
    </td>
    <th scope="row">Nationality</th>
    <td>
    <select class="w100p" id="nation" name="nation">
        <option value="" selected>Select Account</option>
         <c:forEach var="list" items="${nationality }" varStatus="status">
           <option value="${list.countryid}">${list.name}</option>
        </c:forEach>
    </select>
    </td>
    <th scope="row">Race</th>
    <td>
    <select class="w100p" id="race" name="race">
        <option value="" selected>Select Account</option>
        <c:forEach var="list" items="${race }" varStatus="status">
           <option value="${list.detailcodeid}">${list.detailcodename}</option>
        </c:forEach>
    </select>
    </td>
    <th scope="row">Status</th>
    <td>
    <select class="w100p" id="status" name="status">
        <option value="" selected>Select Account</option>
        <c:forEach var="list" items="${status }" varStatus="status">
           <option value="${list.statuscodeid}">${list.name}</option>
        </c:forEach>
        <option value="Rejoin">Rejoin</option>
    </select>
    </td>
</tr>
<tr>
    <th scope="row">Contact No</th>
    <td>
    <input type="text" title="Contact No" placeholder="" class="w100p" id="contact" name="contact"/>
    </td>
    <th scope="row">Position</th>
    <td>
    <select class="w100p" id="position" name="position">
        <option value="" selected>Select Account</option>
        <c:forEach var="list" items="${position}" varStatus="status">
            <option value="${list.positionLevel}">${list.positionName}</option>
        </c:forEach>
    </select>
    </td>
    <th scope="row">Sponsor's Code</th>
    <td>
     <input type="text" title="Sponsor's Code" placeholder="" class="w100p" id=sponsor name="sponsor"/>
    </td>
    <th scope="row"></th>
    <td>
    </td>
</tr>
<tr>
    <th scope="row">Key-In User</th>
    <td>
    <select class="w100p" id="keyUser" name="keyUser">
        <option value="" selected>Select Account</option>
        <c:forEach var="list" items="${user }" varStatus="status">
           <option value="${list.userid}">${list.username}</option>
        </c:forEach>
    </select>
    </td>
    <th scope="row">Key-In User Branch</th>
    <td>
    <select class="w100p" id="keyBranch" name="keyBranch">
    <option value="" selected>Select Account</option>
        <c:forEach var="list" items="${userBranch}" varStatus="status">
           <option value="${list.branchid}">${list.c1}</option>
        </c:forEach>
    </select>
    </td>
    <th scope="row">Key-In Date</th>
    <td colspan="3">

    <div class="date_set"><!-- date_set start -->
    <p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" id="createDate" name="createDate" /></p>
    <span>To</span>
    <p><input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date"  id="endDate" name="endDate"/></p>
    </div><!-- date_set end -->

    </td>
</tr>
<tr>
      <tr>
        <th scope="row">Org Code</th>
        <td><input type="text" title="orgCode" id="orgCode" name="orgCode" placeholder="Org Code" class="w100p" /></td>
        <th scope="row">Grp Code</th>
        <td><input type="text" title="grpCode" id="grpCode" name="grpCode"  placeholder="Grp Code" class="w100p"/></td>
        <th scope="row">Dept Code</th>
        <td><input type="text" title="deptCode" id="deptCode" name="deptCode"  placeholder="Dept Code" class="w100p"/></td>
        <th scope="row">Email</th>
        <td><input type="text" title="Email" placeholder="" class="w100p" id="email" name="email" /></td>
      </tr>
</tr>
</tbody>
</table><!-- table end -->


</form>
</section><!-- search_table end -->

<form id="applicantValidateForm" method="post">
    <div style="display:none">
        <input type="text" name="aplcntCode"  id="aplcntCode"/>
        <input type="text" name="aplcntNRIC"  id="aplcntNRIC"/>
    </div>
</form>

 <aside class="link_btns_wrap"><!-- link_btns_wrap start -->
    <p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
    <dl class="link_list">
        <dt><spring:message code="sal.title.text.link" /></dt>
        <dd>
        <ul class="btns">
            <c:if test="${PAGE_AUTH.funcUserDefine11 == 'Y'}">
                <li><p class="link_btn"><a href="#" id="hpYSListingBtn">HP Raw Listing</a></p></li>
            </c:if>
            <c:if test="${PAGE_AUTH.funcUserDefine10 == 'Y'}">
                <li><p class="link_btn"><a href="#" id="getHpApplicantURL">HP Applicant e-Agreement URL</a></li>
            </c:if>
            <c:if test="${PAGE_AUTH.funcUserDefine12 == 'Y'}">
                <li><p class="link_btn"><a href="#" id="meetingPointMgmt">Meeting Point Management</a></li>
            </c:if>
            <c:if test="${PAGE_AUTH.funcUserDefine13 == 'Y'}">
                <li><p class="link_btn"><a href="#" id="hpPwReset">HP Password Reset</a></li>
            </c:if>
            <c:if test="${PAGE_AUTH.funcUserDefine14 == 'Y'}">
                <li><p class="link_btn"><a href="#" id="cdPwReset">CD Password Reset</a></li>
            </c:if>

            <c:if test="${PAGE_AUTH.funcUserDefine15 == 'Y'}">
                <li><p class="link_btn"><a href="#" id="htPwReset">HT Password Reset</a></li>
                <li><p class="link_btn"><a href="#" id="htContactList">HT Contact List</a></li>
            </c:if>
               <c:if test="${PAGE_AUTH.funcUserDefine17 == 'Y'}">
                 <li><p class="link_btn"><a href="#" id="paExpiry">PA Expiry Date</a></li>
            </c:if>
            <li><p class="link_btn"><a href="#" id="getNonVaccineDeclare">Non-Vaccination Declaration Form</a></li>
            <li><p class="link_btn"><a href="#" id="rejoinRawListing">Rejoin Raw Listing</a></li>
            <c:if test="${PAGE_AUTH.funcUserDefine19 == 'Y'}">
                <li><p class="link_btn"><a href="#" id="requestToResetMFA">MFA Request</a></li>
            </c:if>
            <c:if test="${PAGE_AUTH.funcUserDefine20 == 'Y'}">
                <li><p class="link_btn"><a href="#" id="approveToResetMFA">MFA Approval</a></li>
            </c:if>
            <c:if test="${isMFAReset}">
	            <li><p class="link_btn"><a href="#" id="resetMFA">MFA Reset</a></li>
            </c:if>
        </ul>
        <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
        </dd>
    </dl>
    </aside><!-- link_btns_wrap end -->

<section class="search_result"><!-- search_result start -->

<ul class="right_btns">
<c:if test="${PAGE_AUTH.funcPrint == 'Y'}">
<li><p class="btn_grid"><a href="javascript:fn_excelDown();">GENERATE</a></p></li>
</c:if>
   <!--  <li><p class="btn_grid"><a href="#">EXCEL UP</a></p></li>

    <li><p class="btn_grid"><a href="#">DEL</a></p></li>
    <li><p class="btn_grid"><a href="#">INS</a></p></li>
    <li><p class="btn_grid"><a href="#">ADD</a></p></li> -->
</ul>

<section>
<span style="color:#8FD1FF;font-weight: bold; font-size:15px;"> Partially Completed Vaccination    </span> |
<span style="color:#FFE400;font-weight: bold; font-size:15px;"> Completed Vaccination    </span> |
<span style="color:#9DACB7;font-weight: bold; font-size:15px;"> Pregnant/Allergy/Pending    </span> |
<span style="color:#FF9B1D;font-weight: bold; font-size:15px;"> Don't want/ Not ready    </span>
</section>

<article class="grid_wrap">
    <!-- grid_wrap start -->
    <div id="grid_wrap_memList" style="width: 100%; height: 500px; margin: 0 auto;"></div>
    <div id="excel_list_grid_wrap" style="display: none;"></div>
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- content end -->

<aside class="bottom_msg_box"><!-- bottom_msg_box start -->
<p>Information Message Area</p>
</aside><!-- bottom_msg_box end -->

</section><!-- container end -->

</div><!-- wrap end -->
