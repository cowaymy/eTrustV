<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">
var myGridID;
var grpOrgList = new Array(); // Group Organization List
var orgList = new Array(); // Organization List
var selRowIndex;

var selectedGridValue;

function fn_memberListNew(){
     Common.popupDiv("/organization/selectMemberListNewPop.do?isPop=true", "searchForm"  ,null , true  ,'fn_memberListNew');
}

function fn_memberListSearch(){
    selRowIndex = null;
    /* if ($("#memTypeCom").val() == '5' ) {
        AUIGrid.showColumnByDataField(myGridID, "testResult");
        AUIGrid.setColumnProp( myGridID, 5, { width : 130, visible : true } );
    } else {
        AUIGrid.setColumnProp( myGridID, 5, { width : 0, visible : false } );
    } */

    Common.ajax("GET", "/organization/memberListSearch", $("#searchForm").serialize(), function(result) {
        console.log("성공.");
        console.log("data : " + result);

        var isTrainee = 0;
        for (var i=0; i<result.length; i++) {
            if (result[i]["membertype"] == 5) {
                isTrainee = 1;
            } else {
                result[i]["testResult"] = "";
            }
        }

        if (isTrainee != 0) {
            AUIGrid.showColumnByDataField(myGridID, "testResult");
            AUIGrid.setColumnProp( myGridID, 5, { width : 130, visible : true } );
        } else {
            AUIGrid.setColumnProp( myGridID, 5, { width : 0, visible : false } );
        }

        AUIGrid.setGridData(myGridID, result);
    });

}

function fn_excelDown(){
    // type : "xlsx", "csv", "txt", "xml", "json", "pdf", "object"
    GridCommon.exportTo("grid_wrap_memList", "xlsx", "MemberList");
}

function fn_TerminateResign(val){

console.log( memberType )



    if(val == '1'){
        if (memberType == 1 || memberType == 2 || memberType == 3 || memberType == 4 || memberType ==  7 || memberType ==  5758 ) { // ADDED HOMECARE -- BY TOMMY
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
       if (memberType == 1 || memberType == 2 || memberType == 3 || memberType == 4 || memberType == 7 || memberType ==  5758 ) { // ADDED HOMECARE -- BY TOMMY
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

/*By KV start - requestVacationPop*/
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
/*By KV end - requestVacationPop*/


/*By KV start - traineeToMemberRegistPop*/
 function fn_confirmMemRegisPop(){
     var jsonObj = {
             MemberID :memberid,
            MemberType : memberType,
            MemberCode : membercode
    };
    //Common.popupDiv("/organization/confirmMemRegisPop.do?isPop=true&MemberID="+memberid+"&MemberType="+memberType);

    console.log(memberid + " :: " + memberType + " :: " + traineeType)

    if ( memberType == 5 && (traineeType == 2 || traineeType == 3 || traineeType == 7 || traineeType == 5758 )) { // ADDED HOMECARE -- BY TOMMY

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
         console.log( result);

         if(result !="" ){

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

/*By KV end - traineeToMemberRegistPop*/

//Start AUIGrid --start Load Page- user 1st click Member
$(document).ready(function() {

    if("${SESSION_INFO.memberLevel}" =="1"){

        /* $("#orgCode").val("${orgCode}");
        $("#orgCode").attr("class", "w100p readonly");
        $("#orgCode").attr("readonly", "readonly"); */

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

        $("#memCode").val("${memCode}");
        $("#memCode").attr("class", "w100p readonly");
        $("#memCode").attr("readonly", "readonly");


        $("#memLvl").attr("class", "w100p readonly");
        $("#memLvl").attr("readonly", "readonly");
    }

    // AUIGrid 그리드를 생성합니다.
    createAUIGrid();

   // AUIGrid.setSelectionMode(myGridID, "singleRow");

 // 셀 더블클릭 이벤트 바인딩
      AUIGrid.bind(myGridID, "cellDoubleClick", function(event) {
            //alert(event.rowIndex+ " - double clicked!! : " + event.value + " - rowValue : " + AUIGrid.getCellValue(myGridID, event.rowIndex, "memberid"));
            Common.popupDiv("/organization/selectMemberListDetailPop.do?isPop=true&MemberID=" + AUIGrid.getCellValue(myGridID, event.rowIndex, "memberid")+"&MemberType=" + AUIGrid.getCellValue(myGridID, event.rowIndex, "membertype"), "");
        });

     AUIGrid.bind(myGridID, "cellClick", function(event) {
        selRowIndex = event.rowIndex;
        //alert(event.rowIndex+ " -cellClick : " + event.value + " - rowValue : " + AUIGrid.getCellValue(myGridID, event.rowIndex, "memberid"));
        memberid =  AUIGrid.getCellValue(myGridID, event.rowIndex, "memberid");
        memberType = AUIGrid.getCellValue(myGridID, event.rowIndex, "membertype");
        membercode = AUIGrid.getCellValue(myGridID, event.rowIndex, "membercode");
        statusName = AUIGrid.getCellValue(myGridID, event.rowIndex, "statusName");
        traineeType = AUIGrid.getCellValue(myGridID, event.rowIndex, "traineeType");
        nric = AUIGrid.getCellValue(myGridID, event.rowIndex, "nric");
        memberName = AUIGrid.getCellValue(myGridID, event.rowIndex, "name");
        testResult = AUIGrid.getCellValue(myGridID, event.rowIndex, "testResult");
        //Common.popupDiv("/organization/requestTerminateResign.do?isPop=true&MemberID=" + AUIGrid.getCellValue(myGridID, event.rowIndex, "memberid")+"&MemberType=" + AUIGrid.getCellValue(myGridID, event.rowIndex, "membertype"), "");
    });

    /*By KV Start  - Position button disable function in selection*/
    $("#position").attr("disabled",true);
    /*By KV End - Position button disable function in selection*/

    if($("#userRole").val() == "130" || $("#userRole").val() == "137" // Administrator
      || $("#userRole").val() == "141" || $("#userRole").val() == "142" || $("#userRole").val() == "160" // HR
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
            width : 130
        }, {
            dataField : "testResult",
            headerText : "Test Result",
            editable : false,
            width : 0,
            visible : false
        }, {
            dataField : "updated",
            headerText : "Last Update",
            editable : false,
            width : 130
        }, {
            dataField : "lastActDt",
            headerText : "Last Active Date",
            editable : false,
            width : 130

        },
        /*BY KV Position*/
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





function fn_memberEditPop(){
         Common.popupDiv("/organization/memberListEditPop.do?isPop=true&memberCode=" + membercode+"&MemberID=" + memberid+"&memType=" + memberType, "");

       }

function fn_branchEditPop(){
     Common.popupDiv("/organization/memberListBranchEditPop.do?isPop=true&memberCode=" + membercode+"&MemberID=" + memberid+"&memType=" + memberType, "");
   }




/*By KV start - Position - This is for display Position data only in Position selection.*/
function fn_searchPosition(selectedData){
    $("#position option").remove();
      if(selectedData == "2" || selectedData =="3" || selectedData =="1" || selectedData =="7" || selectedData =="5758"){
           $("#position").attr("disabled",false);   /*position button enable*/
           Common.ajax("GET",
                    "/organization/positionList.do",
                    "memberType="+selectedData,
                    function(result) {
                        /* By KV - user able use "select account" */
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
/*By KV end - Position - This is for display Position data only in Position selection.*/

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

$(function() {
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
});

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
 <c:if test="${PAGE_AUTH.funcUserDefine4 == 'Y'}">
    <li><p class="btn_blue"><a href="javascript:fn_addMemberValidDate()">Member Valid date</a></p></li>
</c:if>
 <c:if test="${PAGE_AUTH.funcUserDefine8 == 'Y'}">
    <li><p class="btn_blue"><a href="javascript:fn_clickHpReject()">HP Reject</a></p></li>
</c:if>
 <c:if test="${PAGE_AUTH.funcUserDefine9 == 'Y'}">
    <li><p class="btn_blue"><a href="javascript:fn_genRawData()">Raw Data Download</a></p></li>
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
    </select>
    </td>
</tr>
<tr>
    <th scope="row">Contact No</th>
    <td>
    <input type="text" title="Contact No" placeholder="" class="w100p" id="contact" name="contact"/>
    </td>

    <%-- By KV start - Position Selection button --%>
    <th scope="row">Position</th>
    <td>
    <select class="w100p" id="position" name="position">
        <option value="" selected>Select Account</option>
        <c:forEach var="list" items="${position}" varStatus="status">
            <option value="${list.positionLevel}">${list.positionName}</option>
        </c:forEach>
    </select>
    </td>
    <%-- By KV end - Position Selection button --%>

    <th scope="row"></th>
    <td>
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
        <c:forEach var="list" items="${userBranch }" varStatus="status">
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
        <th scope="row"></th>
        <td></td>
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
            <!-- <c:if test="${PAGE_AUTH.funcUserDefine12 == 'Y'}"> -->
                <li><p class="link_btn"><a href="#" id="meetingPointMgmt">Meeting Point Management</a></li>
            <!-- </c:if> -->
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

<article class="grid_wrap">
    <!-- grid_wrap start -->
    <div id="grid_wrap_memList" style="width: 100%; height: 500px; margin: 0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- content end -->

<aside class="bottom_msg_box"><!-- bottom_msg_box start -->
<p>Information Message Area</p>
</aside><!-- bottom_msg_box end -->

</section><!-- container end -->

</div><!-- wrap end -->
