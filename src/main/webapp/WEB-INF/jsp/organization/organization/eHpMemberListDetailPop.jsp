<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javaScript">

var myGridID4;/* promote */
//var myGridID1;/* doc */
var myGridID2;
var myGridID3;
var grpOrgList = new Array(); // Group Organization List
var orgList = new Array(); // Organization List

var myFileCaches = {};

var nricFileId = 0;
var statementFileId = 0;
var passportFileId = 0;
var paymentFileId = 0;
var hpAppFormFileId = 0;
var otherFileId = 0;
var otherFileId2 = 0;
var terminateFileId = 0;

var nricFileName = "";
var statementFileName = "";
var passportFileName = "";
var paymentFileName = "";
var hpAppFormFileName = "";
var otherFileName = "";
var otherFileName2 = "";
var terminateFileName = "";

var FailedRemarkGridID;
var userType = '${SESSION_INFO.userTypeId}';

//Start AUIGrid
$(document).ready(function() {

    // AUIGrid 그리드를 생성합니다.
    createAUIGrid4();
    //createAUIGrid1();
    createAUIGrid2();
    createAUIGrid3();
    createAUIGridFailedRemark();
    fn_selectFailedRemarkList();

    fn_selectPromote();
    //fn_selectDocSubmission();
    fn_selectPaymentHistory();
    fn_selectRenewalHistory();

    console.log("atchFileGrpId : " + '${atchFileGrpId}' );
    var atchFileGrpIdTemp = '${atchFileGrpId}';
    if(atchFileGrpIdTemp > 0){
        fn_loadAtchment('${atchFileGrpId}');
    }

    doGetCombo('/organization/selectHpMeetPoint.do', '', '', 'meetingPoint', 'S', '');

    //cody 를 제외하고 Pa Renewal History 와 Cody PA Expired 안보이기 숨긴다
    if($("#memtype").val() != 2){
        $("#hideContent").hide();
        $(".hideContent").hide();
    }

    var bankId = $("#bank").val();
    $('#bankSelect option[value="'+bankId+'"]').attr('selected', 'selected');

    if( $("#hsptlz").val() == 1){
        $('input:checkbox[id="hsptlzCheck"]').attr("checked", true);
    }
    //member list에서 Request Terminate/Resign, Request Promote/Demote를 detail화면에 붙여서 같이 사용
    if($("#codeValue").val() == 1){//Request Terminate/Resign
        $("#requestTerminateResign").show();
    }
    if($("#codeValue").val() == 2){//Request Promote/Demote
        $("#requestPromoteDemote").show();

         if($("#memberLvl").val() == 0){
             $("#action1").append('<option value=748>Demote</option>');
         }else if($("#memberLvl").val() == 1){
             $("#action1").append('<option value=748>Demote</option>');
         }else if($("#memberLvl").val() == 2){
             $("#action1").append('<option value=747>Promote</option>');
             $("#action1").append('<option value=748>Demote</option>');
         }else if($("#memberLvl").val() == 3){
             $("#action1").append('<option value=747>Promote</option>');
             $("#action1").append('<option value=748>Demote</option>');
         }else{
             $("#action1").append('<option value=747>Promote</option>');
         }
    }

        $('#action1').change(function (){
        var memberId = $("#memberid").val() != null ? $("#memberid").val() : 0;
        $('#cmbSuperior').empty();
        $('#branchCode').empty();

        if($('#action1').val() > -1){
               var positionTo = "";
               var lvlTo = 0;
               var superiorLvl = 0;
               var currentLvl = $("#memberLvl").val();
               var memberTypeId = $("#memtype").val();

               if($('#action1').val() == "747"){
                   console.log("promote");
                   //Promote
                  lvlTo = parseInt(currentLvl) - 1;
                  superiorLvl = parseInt(currentLvl) - 2;
                  //$("select[name=cmbSuperior]").removeAttr('disabled');
                   //desc =
               }else{
                   console.log("demote");
                   lvlTo = parseInt(currentLvl) + 1;
                   superiorLvl = currentLvl;
                   //desc =
               }
               $("#lvlTo").val(lvlTo);
               //글씨 붙이기

               if(superiorLvl >= 0 && superiorLvl < 4)
               {
                   var jsonObj = {
                            memberID : $("#memberid").val(),
                            memberType : $("#memtype").val(),
                            memberLvl : superiorLvl
                    };
                   var jsonObj1 = {
                           kind : 4,
                           separator : ":"
                   };

                    doGetCombo("/organization/selectSuperiorTeam", jsonObj , ''   , 'cmbSuperior' , 'S', '');
                    //doGetComboSepa("/common/selectBranchCodeList.do",4 , ':',''   , 'branchCode' , 'S', '');
                    doGetCombo("/organization/selectAllBranchCode.do", '' , '' , 'branchCode' , 'S', '');

                }
              // if(lvlTo == 3 && memberTypeID == 2) $("select[name=branchCode]").removeAttr('disabled')

       }
    });

      var maskedNric;
      if ('${memberView.name}' == 'Rejected' || '${memberView.name}' == 'Approved'){
          if(userType == 1 || userType == 2 || userType == 7){
              maskedNric = "${memberView.nric}".substr(-4).padStart("${memberView.nric}".length, '*');
          }
          else{
              maskedNric = "${memberView.nric}";
          }
      }
      else{
          maskedNric = "${memberView.nric}";
      }
      document.getElementById('nric').innerText=maskedNric;


});
function createAUIGrid4() {
    //AUIGrid 칼럼 설정
    var columnLayout = [ {
        dataField : "codeDesc",
        headerText : "Action",
        editable : false,
        width : 120
    }, {
        dataField : "memOrgDesc",
        headerText : "From",
        editable : false,
        width : 130
    }, {
        dataField : "deptCodeFrom",
        headerText : "Code",
        editable : false,
        width : 130
    }, {
        dataField : "memorgdescription1",
        headerText : "To",
        editable : false,
        width : 130
    }, {
        dataField : "parentDeptCodeTo",
        headerText : "Code",
        editable : false,
        width : 180
    }, {
        dataField : "deptCodeTo",
        headerText : "Superior Team",
        editable : false,
        width : 130
    }, {
        dataField : "rem",
        headerText : "Remark",
        editable : false,
        width : 180

    }, {
        dataField : "crtDt",
        headerText : "Create Date",
        width : 130
    },{
        dataField : "userName",
        headerText : "Creator",
        editable : false,
        width : 130

    }];
     // 그리드 속성 설정
    var gridPros = {

        // 페이징 사용
        usePaging : true,

        // 한 화면에 출력되는 행 개수 20(기본값:20)
        pageRowCount : 20,

        editable : true,

        showStateColumn : true,

        displayTreeOpen : true,


        headerHeight : 30,

        // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
        skipReadonlyColumns : true,

        // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
        wrapSelectionMove : true,

        // 줄번호 칼럼 렌더러 출력
        showRowNumColumn : true

    };

    //myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout, gridPros);
    myGridID4 = AUIGrid.create("#grid_wrap4", columnLayout, gridPros);
}

var gridPros = {

    // 페이징 사용
    usePaging : true,

    // 한 화면에 출력되는 행 개수 20(기본값:20)
    pageRowCount : 20,

    editable : true,

    fixedColumnCount : 1,

    showStateColumn : true,

    displayTreeOpen : true,

    selectionMode : "singleRow",

    headerHeight : 30,

    // 그룹핑 패널 사용
    useGroupingPanel : true,

    // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
    skipReadonlyColumns : true,

    // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
    wrapSelectionMove : true,

    // 줄번호 칼럼 렌더러 출력
    showRowNumColumn : false,

};

/* function createAUIGrid1() {
    //AUIGrid 칼럼 설정
    var columnLayout = [ {
        dataField : "codeName",
        headerText : "Document",
        editable : false,
        width : 700
    }, {
        dataField : "docQty",
        headerText : "Qty",
        editable : false,
        width : 150
    }];
     // 그리드 속성 설정
    var gridPros = {

        // 페이징 사용
        usePaging : true,

        // 한 화면에 출력되는 행 개수 20(기본값:20)
        pageRowCount : 20,

        editable : true,

        showStateColumn : true,

        displayTreeOpen : true,


        headerHeight : 30,

        // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
        skipReadonlyColumns : true,

        // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
        wrapSelectionMove : true,

        // 줄번호 칼럼 렌더러 출력
        showRowNumColumn : true

    };

    //myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout, gridPros);
    myGridID1 = AUIGrid.create("#grid_wrap1", columnLayout, gridPros);
} */

/* var gridPros = {

    // 페이징 사용
    usePaging : true,

    // 한 화면에 출력되는 행 개수 20(기본값:20)
    pageRowCount : 20,

    editable : true,

    fixedColumnCount : 1,

    showStateColumn : true,

    displayTreeOpen : true,

    selectionMode : "singleRow",

    headerHeight : 30,

    // 그룹핑 패널 사용
    useGroupingPanel : true,

    // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
    skipReadonlyColumns : true,

    // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
    wrapSelectionMove : true,

    // 줄번호 칼럼 렌더러 출력
    showRowNumColumn : false,

}; */

function createAUIGrid2() {
    //AUIGrid 칼럼 설정
    var columnLayout = [ {
        dataField : "orNo",
        headerText : "Receipt No",
        editable : false,
        width : 120
    }, {
        dataField : "c3",
        headerText : "Payment Date",
        editable : false,
        width : 130
    }, {
        dataField : "billNo",
        headerText : "Bill No.",
        editable : false,
        width : 130
    }, {
        dataField : "codeName",
        headerText : "Pay Type",
        editable : false,
        width : 130
    }, {
        dataField : "c2",
        headerText : "Amount",
        editable : false,
        width : 180
    }, {
        dataField : "c4",
        headerText : "User",
        editable : false,
        width : 130
    }];
     // 그리드 속성 설정
    var gridPros = {

        // 페이징 사용
        usePaging : true,

        // 한 화면에 출력되는 행 개수 20(기본값:20)
        pageRowCount : 20,

        editable : true,

        showStateColumn : true,

        displayTreeOpen : true,


        headerHeight : 30,

        // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
        skipReadonlyColumns : true,

        // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
        wrapSelectionMove : true,

        // 줄번호 칼럼 렌더러 출력
        showRowNumColumn : true

    };

    //myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout, gridPros);
    myGridID2 = AUIGrid.create("#grid_wrap2", columnLayout, gridPros);
}

var gridPros = {

    // 페이징 사용
    usePaging : true,

    // 한 화면에 출력되는 행 개수 20(기본값:20)
    pageRowCount : 20,

    editable : true,

    fixedColumnCount : 1,

    showStateColumn : true,

    displayTreeOpen : true,

    selectionMode : "singleRow",

    headerHeight : 30,

    // 그룹핑 패널 사용
    useGroupingPanel : true,

    // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
    skipReadonlyColumns : true,

    // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
    wrapSelectionMove : true,

    // 줄번호 칼럼 렌더러 출력
    showRowNumColumn : false,

};

function createAUIGrid3() {
    //AUIGrid 칼럼 설정
    var columnLayout = [ {
        dataField : "c1",
        headerText : "Action",
        editable : false,
        width : 120
    }, {
        dataField : "c2",
        headerText : "Detail",
        editable : false,
        width : 130
    }, {
        dataField : "agExprDt",
        headerText : "Expiry Date",
        editable : false,
        width : 130
    }, {
        dataField : "agCrtDt",
        headerText : "Last Update",
        editable : false,
        width : 130
    }, {
        dataField : "memCode",
        headerText : "updator",
        editable : false,
        width : 180
    }];
     // 그리드 속성 설정
    var gridPros = {

        // 페이징 사용
        usePaging : true,

        // 한 화면에 출력되는 행 개수 20(기본값:20)
        pageRowCount : 20,

        editable : true,

        showStateColumn : true,

        displayTreeOpen : true,


        headerHeight : 30,

        // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
        skipReadonlyColumns : true,

        // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
        wrapSelectionMove : true,

        // 줄번호 칼럼 렌더러 출력
        showRowNumColumn : true

    };

    //myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout, gridPros);
    myGridID3 = AUIGrid.create("#grid_wrap3", columnLayout, gridPros);
}

var gridPros = {

    // 페이징 사용
    usePaging : true,

    // 한 화면에 출력되는 행 개수 20(기본값:20)
    pageRowCount : 20,

    editable : true,

    fixedColumnCount : 1,

    showStateColumn : true,

    displayTreeOpen : true,

    selectionMode : "singleRow",

    headerHeight : 30,

    // 그룹핑 패널 사용
    useGroupingPanel : true,

    // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
    skipReadonlyColumns : true,

    // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
    wrapSelectionMove : true,

    // 줄번호 칼럼 렌더러 출력
    showRowNumColumn : false,

};

/* function fn_selectDocSubmission(){

    var jsonObj = {
            memberID : $("#memberid").val(),
            memType : $("#memtype").val()

    };


    Common.ajax("GET", "/organization/selectHpDocSubmission",jsonObj, function(result) {
        console.log("성공.");
        console.log("data : " + result);
        AUIGrid.setGridData(myGridID1, result);
        AUIGrid.resize(myGridID1,1000,400);

    });
} */

function fn_selectPaymentHistory(){

    var jsonObj = {
            MemberID : $("#hpid").val(),
            MemberType : $("#memtype").val()

    };


    Common.ajax("GET", "/organization/selectPaymentHistory",jsonObj, function(result) {
        console.log("성공.");
        console.log("data : " + result);
        AUIGrid.setGridData(myGridID2, result);
        AUIGrid.resize(myGridID2,1000,400);

    });
}

function fn_selectRenewalHistory(){

    var jsonObj = {
            MemberID : $("#hpid").val(),
            MemberType : $("#memtype").val()

    };


    Common.ajax("GET", "/organization/selectRenewalHistory",jsonObj, function(result) {
        console.log("성공.");
        console.log("data : " + result);
        AUIGrid.setGridData(myGridID3, result);
        AUIGrid.resize(myGridID3,1000,400);

    });
}

function fn_selectPromote(){

    var jsonObj = {
            MemberID : $("#hpid").val(),
            MemberType : $("#memtype").val()

    };


    Common.ajax("GET", "/organization/selectPromote",jsonObj, function(result) {
        console.log("성공.");
        console.log("data : " + result);
        AUIGrid.setGridData(myGridID4, result);
        AUIGrid.resize(myGridID4,1000,400);

    });
}

function fn_tabSize(){
    AUIGrid.resize(myGridID,1000,400);
}

function fn_requestTermiReSave(val){
    if(val == '1'){//Request Terminate/Resign
        Common.ajax("POST", "/organization/terminateResignSave.do",  $("#requestTermiReForm").serializeJSON(), function(result) {
        console.log("성공.");
        console.log("data : " + result);
        Common.alert(result.message,fn_winClose);

    });

    }else{//Request Promote/Demote
           Common.ajax("POST", "/organization/terminateResignSave.do",  $("#requestProDeForm").serializeJSON(), function(result) {
            console.log("성공.");
            console.log("data : " + result);
            Common.alert(result.message,fn_winClose);
        });
    }
        //성공했으면.... 팝업 띄워주고.... 인설트한 내용들.... 비활성화....
}

function fn_winClose(){

    this.close();
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
                    	hpAppFormFileId = result[i].atchFileId;
                    	hpAppFormFileName = result[i].atchFileName;
                        $(".input_text[id='hpAppFormTxt']").val(hpAppFormFileName);
                        break;
                    case '6':
                        otherFileId = result[i].atchFileId;
                        otherFileName = result[i].atchFileName;
                        $(".input_text[id='otherFileTxt']").val(otherFileName);
                        break;
                    case '7':
                        otherFileId2 = result[i].atchFileId;
                        otherFileName2 = result[i].atchFileName;
                        $(".input_text[id='otherFileTxt2']").val(otherFileName2);
                        break;
                    case '8':
                        terminateFileId = result[i].atchFileId;
                        terminateFileName = result[i].atchFileName;
                        $(".input_text[id='terminateFileTxt']").val(terminateFileName);
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

function fn_atchViewDown(fileGrpId, fileId) {
    var data = {
            atchFileGrpId : fileGrpId,
            atchFileId : fileId
    };
    Common.ajax("GET", "/eAccounting/webInvoice/getAttachmentInfo.do", data, function(result) {
        var fileSubPath = result.fileSubPath;
        fileSubPath = fileSubPath.replace('\', '/'');

        if ('${memberView.name}' == 'Rejected' || '${memberView.name}' == 'Approved'){
            if(userType != 1 && userType != 2 && userType != 7){
                if(result.fileExtsn == "jpg" || result.fileExtsn == "png" || result.fileExtsn == "gif") {
                    console.log(DEFAULT_RESOURCE_FILE + fileSubPath + '/' + result.physiclFileName);
                    window.open(DEFAULT_RESOURCE_FILE + fileSubPath + '/' + result.physiclFileName);
                } else {
                    console.log("/file/fileDownWeb.do?subPath=" + fileSubPath + "&fileName=" + result.physiclFileName + "&orignlFileNm=" + result.atchFileName);
                    window.open("/file/fileDownWeb.do?subPath=" + fileSubPath + "&fileName=" + result.physiclFileName + "&orignlFileNm=" + result.atchFileName);
                }
            }
        }
        else{
            if(result.fileExtsn == "jpg" || result.fileExtsn == "png" || result.fileExtsn == "gif") {
                console.log(DEFAULT_RESOURCE_FILE + fileSubPath + '/' + result.physiclFileName);
                window.open(DEFAULT_RESOURCE_FILE + fileSubPath + '/' + result.physiclFileName);
            } else {
                console.log("/file/fileDownWeb.do?subPath=" + fileSubPath + "&fileName=" + result.physiclFileName + "&orignlFileNm=" + result.atchFileName);
                window.open("/file/fileDownWeb.do?subPath=" + fileSubPath + "&fileName=" + result.physiclFileName + "&orignlFileNm=" + result.atchFileName);
            }
        }
    });
}

function createAUIGridFailedRemark() {

    //AUIGrid 칼럼 설정
     var columnLayout = [
            { headerText : 'Status', dataField : "stus", width : 150}
          , { headerText : 'Fail Reason', dataField : "rem1", width : 150}
          , { headerText : 'Remark', dataField : "rem2", width : 355 }
          , { headerText : 'Creator', dataField : "crtUserId",  width : 180 }
          , { headerText : 'Create Date', dataField : "crtDt",  width : 180, dataType : "date", formatString : "dd/mm/yyyy"}
          , { headerText : 'Create Time', dataField : "crtTime",  width : 180}
     ];

     var gridPros = {
              usePaging : true,
              pageRowCount : 10,
              editable : false,
              selectionMode : "singleRow",
              showRowNumColumn : true,
              showStateColumn : false,
              wordWrap : true
     };

     FailedRemarkGridID =  GridCommon.createAUIGrid("grid_FailedRemark_wrap", columnLayout, "", gridPros);
 }

function fn_selectFailedRemarkList() {
	Common.ajax("GET", "/organization/selecteHPFailRemark.do", {aplctnId : '${memberView.memId}'}, function(result) {
        AUIGrid.setGridData(FailedRemarkGridID, result);
    });
}
</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>eHP - VIEW MEMBER</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<aside class="title_line"><!-- title_line start -->
<h4>Member Information</h4>
</aside><!-- title_line end -->
 <input type="hidden" value="<c:out value="${codeValue}"/>" id="codeValue"/>
 <input type="hidden" value="<c:out value="${memberView.memId}"/>" id="memberid"/><!-- aplctnId -->
  <input type="hidden" value="<c:out value="${memberView.hpId}"/>" id="hpid"/>
 <input type="hidden" value="<c:out value="${memberView.memType}"/> "  id="memtype"/>
 <input type="hidden" value="<c:out value="${memberView.bank}"/> "  id="bank"/>
 <input type="hidden" value="<c:out value="${memberView.hsptlz}"/> "  id="hsptlz"/>
 <input type="hidden" value="<c:out value="${atchFileGrpId}"/> "  id="atchFileGrpId"/>

<section class="tap_wrap"><!-- tap_wrap start -->
<ul class="tap_type1 num4">
    <li><a href="#" class="on">Basic Info</a></li>
    <li><a href="#">Spouse Info</a></li>
    <li><a href="#">Organization Info</a></li>
  <!--   <li><a href="#" >Document Submission</a></li> -->
    <li><a href="#"  >Member Payment History</a></li>
    <li><a href="#" >Promote/Demote History</a></li>
    <li id="hideContent" ><a href="#" >Pa Renewal History</a></li>
    <li><a href="#" >Attachment</a></li>
    <li><a href="aTabFR" >Failed Remark</a></li>
</ul>

<article class="tap_area"><!-- tap_area start -->

<aside class="title_line"><!-- title_line start -->
    <h2>Basic Information</h2>
    <div class="right_chk">
        <label for="mobileApp">Mobile App</label>
        <input type="checkbox" disabled="disabled" id="mobileUseYn" <c:if test="${memberView.mobileUseYn eq 'Y'}">checked</c:if>>
    </div>
</h2>
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
    <th scope="row">Member Type</th>
    <td>
    <span><c:out value="${memberView.codeName}"/></span>
    </td>
    <th scope="row">Member Status</th>
    <td>
    <span><c:out value="${memberView.name}"/></span>
    </td>
    <th scope="row">Joined Date</th>
    <td>
    <span><c:out value="${memberView.c30}"/></span>
    </td>
</tr>
<tr>
    <th scope="row">Applicant Code</th>
    <td>
    <span><c:out value="${memberView.memCode}"/></span>
    </td>
    <th scope="row">HP Code</th>
    <td>
      <span><c:out value="${memberView.hpCode}"/></span>
    </td>
    <th scope="row">User Valid Date</th>
    <td>
    <span><c:out value="${memberView.c31}"/></span>
    </td>
</tr>
<tr>
    <th scope="row">Member Name</th>
    <td colspan="5">
    <span><c:out value="${memberView.name1}"/></span>
    </td>
</tr>
<tr>
    <th scope="row">NRIC</th>
    <td>
     <span id="nric"></span>
    </td>
    <th scope="row">Date of Birth</th>
    <td>
     <span><c:out value="${memberView.c29}"/></span>
    </td>
    <th scope="row">Gender</th>
    <td>
     <span><c:out value="${memberView.gender}"/></span>
    </td>
</tr>
<tr>
     <th scope="row">Nationality</th>
    <td>
    <span><c:out value="${memberView.c36}"/></span>
    </td>
    <th scope="row">Race</th>
    <td>
    <span><c:out value="${memberView.c40}"/></span>
    </td>
    <th scope="row">Marital Status</th>
    <td>
    <span><c:out value="${memberView.c28}"/></span>
    </td>
</tr>

 <!-- ADDED INCOME TAX NO @AMEER 2021-10-25-->
 <tr>
     <th scope="row">Income Tax No</th>
     <td colspan="5">
    <span><c:out value="${memberView.aplicntIncTax}"/></span>
    </td>
 </tr>

<tr>
    <th scope="row">Branch</th>
    <td colspan="3">
     <span><c:out value="${memberView.c4} - ${memberView.c5} " /></span>
    </td>
    <th scope="row">Email</th>
    <td>
     <span><c:out value="${memberView.email}"/></span>
    </td>
</tr>
<tr>
    <th scope="row">Member Group</th>
    <td colspan="3">
        <c:choose>
            <c:when test = "${memberView.memType =='2803'}">
                <span><c:out value="${memberView.c41}"/></span>
            </c:when>
            <c:otherwise>
                <span><c:out value="${memberView.c41} - ${memberView.c22} - ${memberView.c23} "/></span>
            </c:otherwise>
        </c:choose>
    </td>
    <th scope="row">Transport</th>
    <td>
     <span><c:out value="${memberView.c56}"/></span>
    </td>
</tr>
<tr>
    <th scope="row">Business Area</th>
    <td colspan="3">
        <span><c:out value="${memberView.aplicntMeetpoint}"/></span>
    </td>
</tr>
<tr>
    <th scope="row">Mobile No.</th>
    <td>
    <span><c:out value="${memberView.telMobile}"/></span>
    </td>
    <th scope="row">Office No.</th>
    <td>
    <span><c:out value="${memberView.telOffice}"/></span>
    </td>
    <th scope="row">Residence No.</th>
    <td>
    <span><c:out value="${memberView.telHuse}"/></span>
    </td>
</tr>
<tr>
    <th scope="row">Sponsor's Code</th>
    <td>
    <span><c:out value="${memberView.c51}"/></span>
    </td>
    <th scope="row">Sponsor's Name</th>
    <td>
    <span><c:out value="${memberView.c52}"/></span>
    </td>
    <th scope="row">Sponsor's NRIC</th>
    <td>
    <span><c:out value="${memberView.c53}"/></span>
    </td>
</tr>
<tr>
    <th scope="row" rowspan="3">Address</th>
    <td colspan="3">
    <span><c:out value="${memberView.areaId}   ${memberView.city} "/></span>
     </td>
    <th scope="row">Country</th>
    <td>
    <span><c:out value="${memberView.country}"/></span>
    </td>

</tr>
<tr>
    <td colspan="3">
    <span><c:out value="${memberView.street}"/></span>
     </td>
    <th scope="row">State</th>
    <td>
    <span><c:out value="${memberView.state}"/></span>
    </td>

</tr>
<tr>
    <td colspan="3">
    <span><c:out value="${memberView.addrDtl}"/></span>
   </td>
    <th scope="row">Area<span class="must">*</span></th>
    <td>
    <span><c:out value="${memberView.area}"/></span>
    </td>

</tr>
<tr>
</tr>
<tr>
    <th scope="row">Resign Date</th>
    <td>
    <c:if test = "${memberView.c32 =='51'}">
    <span><c:out value="${memberView.c48}"/></span>
    </c:if>
     <span></span>
    </td>
    <th scope="row">Terminate Date</th>
    <td>
    <c:if test = "${memberView.c54 != '1900-01-01'}">
        <span><c:out value="${memberView.c54}"/></span>
    </c:if>
     <%-- <span>
        <c:out value="${memberView.c54}"/>
    </span> --%>
    </td>
    <th scope="row">Postcode</th>
    <td>
    <span><c:out value="${memberView.postcode}"/></span>
    </td>
</tr>
<tr>
    <th scope="row">Bank Account No</th>
    <td>
    <span><c:out value="${memberView.bankAccNo}"/></span>
    </td>
    <th scope="row">Issued Bank</th>
    <td colspan="3">
    <span><c:out value="${memberView.bankName}"/></span>
    <%-- <select class="w100p" id="bankSelect" disabled="disabled">
        <c:forEach var="list" items="${issuedBank }" varStatus="status">
           <option value="${list.bankId}">${list.c1}</option>
           </c:forEach>
    </select>--%>
    </td>
</tr>

<tr>
    <th scope="row">Education Lvl</th>
    <td>
    <span><c:out value="${memberView.c9}"/></span>
    </td>
    <th scope="row">Language</th>
    <td>
    <span><c:out value="${memberView.c11}"/></span>
    </td>
    <th scope="row">TR No</th>
    <td>
    <span><c:out value="${memberView.trNo}"/></span>
    </td>
</tr>
<tr>
    <th scope="row">Busninesses Type</th>
    <td>
    <span><c:out value="${memberView.c60}"/></span>
    </td>
    <th scope="row">Hospitalization</th>
    <td>
    <span><input type="checkbox" disabled="disabled" id="hsptlzCheck"/></span>
    </td>
    <th scope="row">Religion</th>
    <td>
    <span><c:out value="${memberView.religion}"/></span>
    </td>
</tr>
<tr>
    <th scope="row">Applicant Confirm Date</th>
    <td>
    <span><span><c:out value="${ApplicantConfirm.cnfmDt}"/></span></span>
    </td>
      <th scope="row">Main Department</th>
    <td>
    <span><span><c:out value="${memberView.mainDept}"/></span></span>
    </td>
     <th scope="row">Sub Department</th>
    <td>
    <span><span><c:out value="${memberView.subDept}"/></span></span>
    </td>




</tr>
<tr>
      <th scope="row">Registration Options</th>
       <td colspan="3">
        <span><c:out value="${memberView.aplicntRegOpt}"/></span>
    </td>
</tr>
<tr>
      <th scope="row">Collection Branch</th>
       <td colspan="3">
        <span><c:out value="${memberView.collctBrnchDesc}"/></span>
    </td>
</tr>
<tr>
<th scope="row" class="hideContent">Cody PA Expired</th>
    <td class="hideContent">
    <span><span><c:out value="${PAExpired.agExprDt}"/></span></span>
    </td>
</tr>
</tbody>
</table><!-- table end -->

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
    <span><c:out value="${memberView.spouseCode}"/></span>
    </td>
    <th scope="row">Spouse Name</th>
    <td>
   <span><c:out value="${memberView.spouseName}"/></span>
    </td>
    <th scope="row">NRIC / Passport No.</th>
    <td>
    <span><c:out value="${memberView.spouseNric}"/></span>
    </td>
</tr>
<tr>
    <th scope="row">Occupation</th>
    <td>
    <span><c:out value="${memberView.spouseOcpat}"/></span>
    </td>
    <th scope="row">Date of Birth</th>
    <td>
    <span><c:out value="${memberView.c58}"/></span>
    </td>
    <th scope="row">Contact No.</th>
    <td>
    <span><c:out value="${memberView.spouseTelCntc}"/></span>
    </td>
</tr>
</tbody>
</table><!-- table end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:140px" />
    <col style="width:*" />
    <col style="width:160px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Position</th>
    <td colspan="3">
    <span><c:out value="${memberView.c57}"/></span>
    </td>
    <th scope="row">Member Level</th>
    <td>
    <span><c:out value="${memberView.c44}"/></span>
    </td>
</tr>
<tr>
    <th scope="row">Department Code</th>
    <td> <span><c:out value="${memberView.c41}"/></span></td>
    <th scope="row">Group Code</th>
    <td> <span><c:out value="${memberView.c42}"/></span></td>
    <th scope="row">Organization Code</th>
    <td> <span><c:out value="${memberView.c43}"/></span></td>
</tr>
<tr>
    <th scope="row">Manager</th>
    <td colspan="5"> <span><c:out value="${memberView.c22} - ${memberView.c23}"/></span></td>
</tr>
<tr>
    <th scope="row">Mobile No</th>
    <td><span><c:out value="${memberView.c24}"/></span></td>
    <th scope="row">Residence No</th>
    <td><span><c:out value="${memberView.c26}"/></span></td>
    <th scope="row">Office No</th>
    <td><span><c:out value="${memberView.c25}"/></span></td>
</tr>
<tr>
    <th scope="row">Senior Manager</th>
    <td colspan="5"><span><c:out value="${memberView.c17} - ${memberView.c18}"/></span></td>
</tr>
<tr>
    <th scope="row">Mobile No</th>
    <td><span><c:out value="${memberView.c19}"/></span></td>
    <th scope="row">Residence No</th>
    <td><span><c:out value="${memberView.c21}"/></span></td>
    <th scope="row">Office No</th>
    <td><span><c:out value="${memberView.c20}"/></span></td>
</tr>
</tbody>
</table><!-- table end -->

</article><!-- tap_area end -->

<!-- <article class="tap_area">tap_area start

<article class="grid_wrap">grid_wrap start
<div id="grid_wrap1" style="width: 100%; height: 500px; margin: 0 auto;"></div>
</article>grid_wrap end


</article>tap_area end
 -->
<article class="tap_area"><!-- tap_area start -->

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="grid_wrap2" style="width: 100%; height: 500px; margin: 0 auto;"></div>
</article><!-- grid_wrap end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<article class="grid_wrap"><!-- grid_wrap start -->
<!-- promote 그리드 -->
<div id="grid_wrap4" style="width: 100%; height: 500px; margin: 0 auto;"></div>
</article><!-- grid_wrap end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="grid_wrap3" style="width: 100%; height: 500px; margin: 0 auto;"></div>
</article><!-- grid_wrap end -->

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
                <input type='text' class='input_text'  id='nricFileTxt' readonly="readonly"/>
               <!--  <span class='label_text'><a href='#'>Upload</a></span> -->
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
                <input type='text' class='input_text'  id='statementFileTxt' readonly="readonly"/>
          <!--       <span class='label_text'><a href='#'>Upload</a></span> -->
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
                <input type='text' class='input_text' id='passportFileTxt' readonly="readonly"/>
              <!--   <span class='label_text'><a href='#'>Upload</a></span> -->
            </label>
         <!--        <span class='label_text'><a href='#' onclick='fn_removeFile("PASS")'>Remove</a></span> -->
        </div>
    </td>
</tr>
<tr>
    <th scope="row">Payment</th>
    <td>
        <div class="auto_file2 auto_file3">
            <input type="file" title="file add" id="paymentFile" accept="image/*"/>
            <label>
                <input type='text' class='input_text'   id='paymentFileTxt' readonly="readonly"/>
              <!--   <span class='label_text'><a href='#'>Upload</a></span> -->
            </label>
               <!--  <span class='label_text'><a href='#' onclick='fn_removeFile("PAY")'>Remove</a></span> -->
        </div>
    </td>
</tr>
<tr>
    <th scope="row">HP Application Form<span class="must">*</span></th>
    <td>
        <div class="auto_file2 auto_file3">
            <input type="file" title="file add" id="hpAppForm" accept="image/*"/>
            <label>
                <input type='text' class='input_text'  id='hpAppFormTxt' readonly="readonly"/>
               <!--  <span class='label_text'><a href='#'>Upload</a></span> -->
            </label>
               <!--  <span class='label_text'><a href='#' onclick='fn_removeFile("NRIC")'>Remove</a></span> -->
        </div>
    </td>
</tr>
<tr>
    <th scope="row">Declaration letter/Others form</th>
    <td>
        <div class="auto_file2 auto_file3">
            <input type="file" title="file add" id="otherFile" accept="image/*"/>
            <label>
                <input type='text' class='input_text'  id='otherFileTxt' readonly="readonly"/>
        <!--         <span class='label_text'><a href='#'>Upload</a></span> -->
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
                <input type='text' class='input_text'  id='otherFileTxt2' readonly="readonly"/>
               <!--  <span class='label_text'><a href='#'>Upload</a></span> -->
            </label>
           <!--   <span class='label_text'><a href='#' onclick='fn_removeFile("OTH2")'>Remove</a></span> -->
        </div>
    </td>
</tr>
<tr>
    <th scope="row">Termination Agreement</th>
    <td>
        <div class="auto_file2 auto_file3">
            <input type="file" title="file add" id="terminateFile" accept="image/*"/>
            <label>
                <input type='text' class='input_text'   id='terminateFileTxt' readonly="readonly"/>
              <!--   <span class='label_text'><a href='#'>Upload</a></span> -->
            </label>
               <!--  <span class='label_text'><a href='#' onclick='fn_removeFile("TAF")'>Remove</a></span> -->
        </div>
    </td>
</tr>

<tr>
    <td colspan=2><span class="red_text">Only allow picture format (JPG, PNG, JPEG)</span></td>
</tr>
</tbody>
</table>

</form>
</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="grid_FailedRemark_wrap" style="width:100%; height:380px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</article>

</section><!-- tap_wrap end -->
<div id="requestTerminateResign" style="display:none">
<form  id="requestTermiReForm" method="post">
<input type="hidden" value="<c:out value="${memberView.memId}"/>" id="requestMemberId" name="requestMemberId"/>
<input type="hidden" value="<c:out value="${codeValue}"/>" id="codeValue" name="codeValue"/>
<aside class="title_line"><!-- title_line start -->
<h2>Terminate/Resign Information</h2>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:110px" />
    <col style="width:*" />
    <col style="width:170px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Action</th>
    <td>
    <select class="w100p" id="action" name="action">
        <option value="757">Terminate</option>
        <option value="758">Resign</option>
    </select>
    </td>
    <th scope="row">Terminate/Resign Date</th>
    <td>
    <input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" id="dtT/R" name="dtT/R"/>
    </td>
</tr>
<tr>
    <th scope="row">Remark</th>
    <td colspan="3">
    <textarea cols="20" rows="5" id="remark" name="remark"></textarea>
    </td>
</tr>
</tbody>
</table><!-- table end -->

<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#" onclick="javascript:fn_requestTermiReSave(1)">SAVE</a></p></li>
</ul>
</form>
</div>
<div id="requestPromoteDemote" style="display:none">
<form  id="requestProDeForm" method="post">
<input type="hidden" value="<c:out value="${memberView.memId}"/>" id="requestMemberId" name="requestMemberId"/>
<input type="hidden" value="<c:out value="${memberView.c44}"/>" id="memberLvl" name="memberLvl"/>
<input type="hidden" value="<c:out value="${memberView.memType}"/> "  id="memtype" name="memtype"/>
<input type="hidden" value="<c:out value="${codeValue}"/>" id="codeValue" name="codeValue"/>
<input type="hidden" value="<c:out value="${memberView.memCode}"/>" id="memCode" name="memCode"/>
<input type="hidden" value="" id="lvlTo" name="lvlTo"/>
<aside class="title_line"><!-- title_line start -->
<h2>Promote/Demote Information</h2>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:110px" />
    <col style="width:*" />
    <col style="width:170px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row" rowspan="3">Action</th>
    <td rowspan="3">
    <select class="w100p" id="action1" name="action1">
    <option value="">Action</option>
    </select>
    </td>
 <th scope="row">Branch Code</th>
    <td>
    <select class="w100p" id="branchCode" name="branchCode">
        <option value="">Branch Code</option>
    </select>
    </td>
</tr>
<tr>
<th scope="row">Superior Team</th>
    <td>
    <select class="w100p"  id="cmbSuperior" name="cmbSuperior">
        <option value="">Superior Team</option>
    </select>
    </td>
</tr>
<tr>
<th scope="row">Promo/Demote Date</th>
    <td>
     <input type="text" title="Promo/Demote Date" placeholder="DD/MM/YYYY" class="j_date" id="dtProDemote" name="dtProDemote"/>
    </td>
</tr>

<tr>
    <th scope="row">Remark</th>
    <td colspan="3">
    <textarea cols="20" rows="5" id="remark1" name="remark1" ></textarea>

</tr>
</tbody>
</table><!-- table end -->

<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#" onclick="javascript:fn_requestTermiReSave(2)">Save Request</a></p></li>
</ul>
</form>
</div>
</section><!-- pop_body end -->

</div><!-- popup_wrap end -->
