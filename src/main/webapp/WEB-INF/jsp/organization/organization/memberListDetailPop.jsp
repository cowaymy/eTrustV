<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javaScript">

var myGridID4;/* promote */
var myGridID1;/* doc */
var myGridID2;
var myGridID3;
var myGridID5; /* Training */
var myGridID6;
var myGridID7; /* Working History */
var grpOrgList = new Array(); // Group Organization List
var orgList = new Array(); // Organization List

var codyAppFileId = 0;
var nricCopyFileId = 0;
var driveCopyFileId = 0;
var bankStateCopyFileId = 0;
var vaccDigCertFileId = 0;
var fileNameId = 0;
var codyPaCopyFileId = 0;
var compConsCodyFileId = 0;
var codyExtCheckFileId = 0;
var terminationAgreeFileId = 0;

var codyAppFileName = "";
var nricCopyFileName = "";
var driveCopyFileName = "";
var bankStateCopyFileName = "";
var vaccDigCertFileName = "";
var fileNameName = "";
var codyPaCopyFileName = "";
var compConsCodyFileName = "";
var codyExtCheckFileName = "";
var terminationAgreeFileName = "";
var myFileCaches = {};
var checkFileValid = true;

//Start AUIGrid
$(document).ready(function() {
console.log("ter-res-pro-dem pop");
    // AUIGrid 그리드를 생성합니다.
    createAUIGrid4();
    createAUIGrid1();
    createAUIGrid2();
    createAUIGrid3();
    createAUIGrid5();
    createAUIGrid6();
    createAUIGrid7();
    fn_selectPromote();
    fn_selectDocSubmission();

    if(($("#memtype").val() == 5 && "${memberView.traineeType}"  == 2) || ($("#memtype").val() == 2)){
        $("#attachmentTab").show();
        $('#emergencyTabHeader').show();
        $('#emergencyTabDetails').show();
        if( "${memberView.atchFileGrpIdDoc}" != 0 &&  "${memberView.atchFileGrpIdDoc}" != null){
        	  fn_loadAtchment( "${memberView.atchFileGrpIdDoc}");
       }
    }else{
    	  if( "${memberView.atchFileGrpIdDoc}" != 0 &&  "${memberView.atchFileGrpIdDoc}" != null){
              fn_loadAtchment( "${memberView.atchFileGrpIdDoc}");
              $("#attachmentTab").show();
          }else {
        	  $("#attachmentTab").hide();
          }
        $('#emergencyTabHeader').hide();
        $('#emergencyTabDetails').hide();
    }
    fn_selectPaymentHistory();
    fn_selectRenewalHistory();
    fn_selectTraining();
    fn_selectLoyaltyHPUploadDetailListForMember();
    fn_selectMemberPhoto();
    doGetCombo('/organization/selectHpMeetPoint.do', '', '', 'meetingPoint', 'S', '');
    fn_selectMemberWorkingHistory();

    //cody 를 제외하고 Pa Renewal History 와 Cody PA Expired 안보이기 숨긴다
    if($("#memtype").val() != 2){
    	$("#hideContent").hide();
    	$(".hideContent").hide();
    }

    //FB Link and IG Link for HP
    if($("#memtype").val() != 1){
    	$(".hideContent3").hide();
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

    $("#dtTerRes").change(function() {
        console.log("TermRes Change");
        if("${memberView.memType}" == "2") {
            var today = new Date();
            var dd = today.getDate();
            var mm = today.getMonth() + 1;
            var yyyy = today.getFullYear();

            if(dd > 5) {
                var newMM = (mm + 1);
                if(newMM < 10) {
                    newMM = "0" + newMM;
                }
                var newDate = "01/" + newMM + "/" + yyyy;
                console.log(newDate);
                $("#dtTerRes").val(newDate);
            } else {
                var sDD = $("#dtTerRes").val().substring(0, 2);

                if(sDD > 5) {
                    Common.alert("Only till 5th is allowed.")
                    $("#dtTerRes").val("");
                }
            }
        }
    });

    $("#dtProDemote").change(function() {
        console.log("ProDemote Change");
        if("${memberView.memType}" == "2") {
            var today = new Date();
            var dd = today.getDate();
            var mm = today.getMonth() + 1;
            var yyyy = today.getFullYear();

            if(dd > 5) {
                var newMM = (mm + 1);
                if(newMM < 10) {
                    newMM = "0" + newMM;
                }
                var newDate = "01/" + newMM + "/" + yyyy;
                console.log(newDate);
                $("#dtProDemote").val(newDate);
            } else {
                var sDD = $("#dtProDemote").val().substring(0, 2);

                if(sDD > 5) {
                    Common.alert("Only till 5th is allowed.")
                    $("#dtProDemote").val("");
                }
            }
        }
    });

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

function createAUIGrid1() {
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
        headerText : "Create Date",
        editable : false,
        width : 130
    }, {
        dataField : "agUpdDt",
        headerText : "Last Update",
        editable : false,
        width : 130
    }, {
        dataField : "memCode",
        headerText : "Creator",
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

function createAUIGrid5() {

    var columnLayout = [ {
        dataField : "courseCode",
        headerText : "Training Course",
        editable : false,
        width : 575
    }, {
        dataField : "cDate",
        headerText : "Date",
        editable : false,
        width : 130
    }, {
        dataField : "result",
        headerText : "Result",
        editable : false,
        width : 130
    }];

    var gridPros = {
        usePaging : true,
        pageRowCount : 20,
        editable : true,
        showStateColumn : true,
        displayTreeOpen : true,
        headerHeight : 30,
        skipReadonlyColumns : true,
        wrapSelectionMove : true,
        showRowNumColumn : true
    };

    myGridID5 = AUIGrid.create("#grid_wrap5", columnLayout, gridPros);
}




function createAUIGrid6() {

    var columnLayout = [ {
        dataField : "codeName",
        headerText : "HP Status",
        editable : false
    }, {
        dataField : "lotyPeriod",
        headerText : "Period",
        editable : false,
    }, {
        dataField : "lotyYear",
        headerText : "Year",
        editable : false
    }];

    var gridPros = {
        usePaging : true,
        pageRowCount : 20,
        editable : true,
        showStateColumn : true,
        displayTreeOpen : true,
        headerHeight : 30,
        skipReadonlyColumns : true,
        wrapSelectionMove : true,
        showRowNumColumn : true
    };

    myGridID6 = AUIGrid.create("#grid_wrap6", columnLayout, gridPros);
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

function fn_selectDocSubmission(){

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
}

function fn_selectPaymentHistory(){

    var jsonObj = {
            MemberID : $("#memberid").val(),
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
            MemberID : $("#memberid").val(),
            MemberType : $("#memtype").val()

    };


    Common.ajax("GET", "/organization/selectRenewalHistory",jsonObj, function(result) {
        console.log("성공.");
        console.log("data : " + result);
        AUIGrid.setGridData(myGridID3, result);
        AUIGrid.resize(myGridID3,1000,400);

    });
}



function fn_selectLoyaltyHPUploadDetailListForMember(){

    var jsonObj = {
    		memberCode :'${memberView.memCode}'
    };


    Common.ajax("GET", "/organization/selectLoyaltyHPUploadDetailListForMember",jsonObj, function(result) {
        console.log("성공.");
        console.log("data : " + result);
        AUIGrid.setGridData(myGridID6, result);
        AUIGrid.resize(myGridID6,1000,400);

    });
}

function fn_selectPromote(){

    var jsonObj = {
            MemberID : $("#memberid").val(),
            MemberType : $("#memtype").val()

    };

    Common.ajax("GET", "/organization/selectPromote",jsonObj, function(result) {
        console.log("성공.");
        console.log("data : " + result);
        AUIGrid.setGridData(myGridID4, result);
        AUIGrid.resize(myGridID4,1000,400);

    });
}

function fn_selectTraining() {
    var jsonObj = {
            MemberID : $("#memberid").val(),
            MemberType : $("#memtype").val()
    };

    Common.ajax("GET", "/organization/selectTraining", jsonObj, function(result) {
        console.log("data : " + result);
        AUIGrid.setGridData(myGridID5, result);
        AUIGrid.resize(myGridID5, 1000, 400);
    });
}

function fn_tabSize(){
	AUIGrid.resize(myGridID,1000,400);
}

function fn_requestTermiReSave(val){
    if(val == '1'){
        // Request Terminate/Resign
        Common.ajax("POST", "/organization/terminateResignSave.do",  $("#requestTermiReForm").serializeJSON(), function(result) {
            console.log("성공.");
            console.log("data : " + result);
            Common.alert(result.message,fn_winClose);
        });

    } else {
        // Request Promote/Demote
        if(FormUtil.isEmpty($("#dtProDemote").val())) {
            Common.alert("Promote/Demote Date Required.");
            return false;
        } else {
            if($("#memtype").val() == "2") {

            }
        }

        Common.ajax("POST", "/organization/terminateResignSave.do",  $("#requestProDeForm").serializeJSON(), function(result) {
            console.log("성공.");
            console.log("data : " + result);
            Common.alert(result.message,fn_winClose);
        });
    }
}

function fn_winClose(){

    this.close();
}

function fn_selectMemberPhoto(){
	 var data = {
			 memId : '${memberView.memId}'
     };

	Common.ajax("GET", "/organization/getAttachmentInfo.do", data, function(result) {
		 var img = document.createElement("img");
		 var src = document.getElementById("HP_img");

		if(result != null){
			var fileSubPath = result.fileSubPath;
	        fileSubPath = fileSubPath.replace('\', '/'');

	        img.src = DEFAULT_RESOURCE_FILE + fileSubPath + '/' + result.physiclFileName;
	        img.style.height = '10%';
	        img.style.width = '100px';
	        src.appendChild(img);
		}
    });
}

$("#HP_img").dblclick(function(){
    var data = {
            memId : '${memberView.memId}'
    };
   Common.ajax("GET", "/organization/getAttachmentInfo.do", data, function(result) {
       console.log(result);
       var fileSubPath = result.fileSubPath;
       fileSubPath = fileSubPath.replace('\', '/'');
       window.open(DEFAULT_RESOURCE_FILE + fileSubPath + '/' + result.physiclFileName);
   });
});

   function fn_loadAtchment(atchFileGrpId) {
	   console.log("atchFileGrpId : " + atchFileGrpId);
        Common.ajax("Get", "/sales/order/selectAttachList.do", {atchFileGrpId :atchFileGrpId} , function(result) {
           console.log(result);
          if(result) {
               if(result.length > 0) {
                   $("#attachTd").html("");
                   for ( var i = 0 ; i < result.length ; i++ ) {
                       switch (result[i].fileKeySeq){
                       case '1':
                    	   codyAppFileId = result[i].atchFileId;
                           codyAppFileName = result[i].atchFileName;
                           $(".input_text[id='codyAppFileTxt']").val(codyAppFileName);
                           break;
                       case '2':
                    	   nricCopyFileId = result[i].atchFileId;
                           nricCopyFileName = result[i].atchFileName;
                           $(".input_text[id='nricCopyFileTxt']").val(nricCopyFileName);
                           break;
                       case '3':
                    	   driveCopyFileId = result[i].atchFileId;
                           driveCopyFileName = result[i].atchFileName;
                           $(".input_text[id='driveCopyFileTxt']").val(driveCopyFileName);
                           break;
                       case '4':
                    	   bankStateCopyFileId = result[i].atchFileId;
                    	   bankStateCopyFileName = result[i].atchFileName;
                           $(".input_text[id='bankStateCopyFileTxt']").val(bankStateCopyFileName);
                           break;
                       case '5':
                    	   vaccDigCertFileId = result[i].atchFileId;
                           vaccDigCertFileName = result[i].atchFileName;
                           $(".input_text[id='vaccDigCertFileTxt']").val(vaccDigCertFileName);
                           break;
                       case '6':
                    	   fileNameId = result[i].atchFileId;
                           fileNameName = result[i].atchFileName;
                           $(".input_text[id='fileNameTxt']").val(fileNameName);
                           break;
                       case '7':
                    	   codyPaCopyFileId = result[i].atchFileId;
                           codyPaCopyFileName = result[i].atchFileName;
                           $(".input_text[id='codyPaCopyFileTxt']").val(codyPaCopyFileName);
                           break;
                       case '8':
                    	   compConsCodyFileId = result[i].atchFileId;
                           compConsCodyFileName = result[i].atchFileName;
                           $(".input_text[id='compConsCodyFileTxt']").val(compConsCodyFileName);
                           break;
                       case '9':
                    	   codyExtCheckFileId = result[i].atchFileId;
                           codyExtCheckFileName = result[i].atchFileName;
                           $(".input_text[id='codyExtCheckFileTxt']").val(codyExtCheckFileName);
                           break;
                       case '10':
                    	   terminationAgreeFileId = result[i].atchFileId;
                    	   terminationAgreeFileName = result[i].atchFileName;
                           $(".input_text[id='terminationAgreeFileTxt']").val(terminationAgreeFileName);
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
           console.log(result)
           var fileSubPath = result.fileSubPath;
           fileSubPath = fileSubPath.replace('\', '/'');


               console.log("/file/fileDownWeb.do?subPath=" + fileSubPath + "&fileName=" + result.physiclFileName + "&orignlFileNm=" + result.atchFileName);
               window.open("/file/fileDownWeb.do?subPath=" + fileSubPath + "&fileName=" + result.physiclFileName + "&orignlFileNm=" + result.atchFileName);

       });
   }

   function createAUIGrid7() {

	    var columnLayout = [ {
	        dataField : "joinDt",
	        headerText : "Join Date",
	        editable : false
	    }, {
	        dataField : "resignDt",
	        headerText : "Resign/Terminate Date",
	        editable : false,
	        labelFunction : function(rowIndex, columnIndex, value, headerText, item, dataField, cItem) {
	               // logic processing
	               // Return value here, reprocessed or formatted as desired.
	               // The return value of the function is immediately printed in the cell.
	                if(item.stus == '51') {
	                       return item.resignDt;
	                } else {
	                	 if(item.trmDt != '01/01/1900'){
	                		  return item.trmDt;
	                	 }
	                }
	            }
	    }, {
	        dataField : "statusName",
	        headerText : "Status",
	        editable : false,
	        labelFunction : function(rowIndex, columnIndex, value, headerText, item, dataField, cItem) {
	                if(item.trmRejoin == 1) {
	                       return item.statusName + " (Rejoin)";
	                  } else {
	                       return item.statusName;
	                  }
	            }
	    }, {
            dataField : "memType",
            headerText : "Member Type",
            editable : false
        }];

	    var gridPros = {
	        usePaging : true,
	        pageRowCount : 20,
	        editable : true,
	        showStateColumn : true,
	        displayTreeOpen : true,
	        headerHeight : 30,
	        skipReadonlyColumns : true,
	        wrapSelectionMove : true,
	        showRowNumColumn : true
	    };

	    myGridID7 = AUIGrid.create("#grid_wrap7", columnLayout, gridPros);
	}

   function fn_selectMemberWorkingHistory(){

	    var jsonObj = {
	            nric :'${memberView.nric}'
	    };

	    Common.ajax("GET", "/organization/selectMemberWorkingHistory",jsonObj, function(result) {
	        console.log("성공.");
	        console.log("data : " + result);
	        AUIGrid.setGridData(myGridID7, result);
	        AUIGrid.resize(myGridID7,1000,400);
	    });
	}
</script>

<style>
.table_hpimg{
        display:table;
        width:90%;
        table-layout: fixed;
        border-spacing: 10px;
}
</style>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>MEMBERS LIST - VIEW MEMBER</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<aside class="title_line table_hpimg"><!-- title_line start -->
<h1 style="display: table-cell;width: 90%">Member Information</h1>
<!-- HP Photo -->
<div id="HP_img" class="hideContent3" style="display: table-cell; float: right; width: 10%;"></div>
</aside><!-- title_line end -->

 <input type="hidden" value="<c:out value="${codeValue}"/>" id="codeValue"/>
 <input type="hidden" value="<c:out value="${memberView.memId}"/>" id="memberid"/>
 <input type="hidden" value="<c:out value="${memberView.memType}"/> "  id="memtype"/>
 <input type="hidden" value="<c:out value="${memberView.bank}"/> "  id="bank"/>
 <input type="hidden" value="<c:out value="${memberView.hsptlz}"/> "  id="hsptlz"/>
<section class="tap_wrap"><!-- tap_wrap start -->
<ul class="tap_type1 num4">
    <li><a href="#" class="on">Basic Info</a></li>
    <li><a href="#">Spouse Info</a></li>
    <li><a href="#">Organization Info</a></li>
    <li><a href="#" >Document Submission</a></li>
    <li><a href="#"  >Member Payment History</a></li>
    <li><a href="#" >Promote/Demote History</a></li>
    <li id="hideContent" ><a href="#" >Pa Renewal History</a></li>
    <li><a href="#" >Training</a></li>
    <li><a href="#" >HP Loyalty Status</a></li>
    <li><a href="#" >Working History</a></li>
    <li id="awardHistory" style="display:none;"><a>Award History</a></li>
    <li id="attachmentTab" style="display:none;"><a href="#" >Attachment</a></li>
</ul>

<article class="tap_area"><!-- tap_area start -->

<aside class="title_line"><!-- title_line start -->
    <h2>Basic Information</h2>
    <div class="right_chk">
        <label for="suppl">Supplement Sales Qualification</label>
        <input type="checkbox" disabled="disabled" id="isSuppl" <c:if test="${memberView.isSuppl eq 'Y'}">checked</c:if>>

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
    <th scope="row">Member Code</th>
    <td>
    <span><c:out value="${memberView.memCode}"/></span>
    </td>
    <th scope="row">HP Type</th>
    <td>
      <c:if test = "${memberView.memType =='1'}">
    <span><c:out value="${memberView.c59}"/></span>
    </c:if>
    <c:if test = "${memberView.memType =='2803'}">
    <span><c:out value="${memberView.c59}"/></span>
    </c:if>
    </td>
    <th scope="row">User Valid Date</th>
    <td>
    <span><c:out value="${memberView.c31}"/></span>
    </td>
</tr>
<tr>
    <th scope="row">Member Name</th>
    <td colspan="3">
    <span><c:out value="${memberView.name1}"/></span>
    </td>
    <th scope="row">Join Month</th>
    <td>
        <span><c:out value="${memberView.joinMonth}"/></span>
    </td>
</tr>
<tr>
    <th scope="row">NRIC </th>
    <td>
     <span><c:out value="${memberView.nric}"/></span>
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

<!-- ADDED INCOME TAX NO @AMEER 2021-11-02 -->
<th scope="row">Income Tax No</th>
    <td colspan="5">
    <span><c:out value="${memberView.incTax}"/></span>
    </td>
</tr>
<tr>
<th scope="row">Registration Options</th>
       <td colspan="5">
        <span><c:out value="${memberView.aplicntRegOpt}"/></span>
    </td>
</tr>

<tr>
    <th scope="row">Branch</th>
    <td colspan="3">
     <span><c:out value="${memberView.c4} - ${memberView.c5} " /></span>
    </td>
    <th scope="row" >Email</th>
    <td>
     <span style="inline-size: 150px;overflow-wrap: break-word;"><c:out value="${memberView.email}"/></span>
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
    <span><c:out value="${memberView.c51}"/> <c:if test="${memberView.noTbb eq '1'}">No TBB (Discontinue)</c:if></span>
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
    <span><c:out value="${memberView.addrDtl}"/></span>
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
    <span><c:out value="${memberView.areaId}   ${memberView.city} "/></span>
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
<th scope="row" class="hideContent">Cody PA Expired</th>
    <td class="hideContent" colspan="5">
    <span><span><c:out value="${PAExpired.agExprDt}"/></span></span>
    </td>
</tr>
<tr>
<th scope="row">Coway Mall Link</th>
    <td colspan="5">
    <span><span>emall.coway.com.my/?agentcode=<c:out value="${memberView.memCode}"/></span></span>
    <!--  <a href="https://coway-uat.ascentisecommerce.com/?agentcode=" +${memberView.memCode}>https://coway-uat.ascentisecommerce.com/?agentcode=<c:out value="${memberView.memCode}"/></a>-->
    </td>
</tr>
<tr>
<th scope="row"  class="hideContent3">FB Link</th>
    <td class="hideContent3" colspan="5">
    <span><c:out value="${memberView.fbLink}"/></span>
    </td>
</tr>
<tr>
<th scope="row" class="hideContent3">IG Link</th>
    <td class="hideContent3" colspan="5">
    <span><c:out value="${memberView.igLink}"/></span>
    </td>
</tr>
</tbody>
</table><!-- table end -->
<%--
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
<tr>
    <th scope="row">Education Level</th>
    <td>
    <span><c:out value="${memberView.bankAccNo}"/></span>
    </td>
    <th scope="row">Language</th>
    <td>
    <span><c:out value="${memberView.bankAccNo}"/></span>
    </td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h2>First TR Consign</h2>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">TR No.</th>
    <td>
    <input type="text" title="" placeholder="TR No." class="w100p" />
    </td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h2>Agreedment</h2>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Cody PA Expiry<span class="must">*</span></th>
    <td>
    <input type="text" title="" placeholder="DD/MM/YYYY" class="j_date" />
    </td>
</tr>
</tbody>
</table><!-- table end -->

<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#">SAVE</a></p></li>
    <li><p class="btn_blue2 big"><a href="#">CANCEL</a></p></li>
</ul>
 --%>

<aside class="title_line" id="emergencyTabHeader"><!-- title_line start -->
<h2>Emergency Contact</h2>
</aside><!-- title_line end -->

<table class="type1" id="emergencyTabDetails"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:180px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sal.text.initial" /></th>
    <td colspan="3">
        <span><c:out value="${memberView.emrgcyCntcInit}"/></span>
    </td>
</tr>
<tr>
    <th scope="row">Name</th>
    <td colspan="3">
        <span><c:out value="${memberView.emrgcyCntcName}"/></span>
    </td>
</tr>
<tr>
    <th scope="row">Contact No</th>
    <td>
        <span><c:out value="${memberView.emrgcyCntcNo}"/></span>
    </td>
    <th scope="row">Relationship</th>
    <td>
        <span><c:out value="${memberView.emrgcyCntcRltshp}"/></span>
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

<article class="tap_area"><!-- tap_area start -->

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="grid_wrap1" style="width: 100%; height: 500px; margin: 0 auto;"></div>
</article><!-- grid_wrap end -->


</article><!-- tap_area end -->

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

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="grid_wrap5" style="width: 100%; height: 500px; margin: 0 auto;"></div>
</article><!-- grid_wrap end -->

</article><!-- tap_area end -->



<article class="tap_area"><!-- tap_area start -->

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="grid_wrap6" style="width: 100%; height: 500px; margin: 0 auto;"></div>
</article><!-- grid_wrap end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->
    <article class="grid_wrap"><!-- grid_wrap start -->
       <div id="grid_wrap7" style="width: 100%; height: 500px; margin: 0 auto;"></div>
    </article><!-- grid_wrap end -->
</article><!-- tap_area end -->

<article class="tap_area">
    <article class="grid_wrap">
       <div id="grid_wrap_awardHistory" style="width: 100%; height: 500px; margin: 0 auto;"></div>
    </article>
</article>

<article class="tap_area"><!-- tap_area start -->
<h2>Attachment</h2>
<table class="type1 mt10" id="attachmentDiv"><!-- table start -->
<colgroup>
    <col style="width:190px" />
    <col style="width:*" />
    <col style="width:150px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr><th scope="row"></th>
    <td colspan="3" id="attachTd">
    </td>
</tr>
<tr>
    <th scope="row">Cody Application Form</th>
    <td colspan="3" id="attachTd">
        <div class="auto_file2">
            <input type="file" title="file add" id="codyAppFile" accept="application/pdf"/>
            <label>
                <input type='text' class='input_text' readonly='readonly'  id="codyAppFileTxt"/>
                <!-- <span class='label_text'><a href='#'>Upload</a></span>
                <span class='label_text'><a href='#' onclick='fn_removeFile("CAF")'>Remove</a></span> -->
            </label>
        </div>
    </td>
</tr>
<tr>
    <th scope="row">NRIC Copy</th>
    <td colspan="3" id="attachTd">
        <div class="auto_file2">
            <input type="file" title="file add" id="nricCopyFile" accept="image/jpg, image/jpeg, image/png"/>
            <label>
                <input type='text' class='input_text' readonly='readonly' id="nricCopyFileTxt"/>
                <!-- <span class='label_text'><a href='#'>Upload</a></span>
                <span class='label_text'><a href='#' onclick='fn_removeFile("NRIC")'>Remove</a></span> -->
             </label>
        </div>
    </td>
</tr>
<tr>
    <th scope="row">Driving License Copy</th>
    <td colspan="3" id="attachTd">
        <div class="auto_file2">
            <input type="file" title="file add" id="driveCopyFile" accept="image/jpg, image/jpeg, image/png"/>
            <label>
                <input type='text' class='input_text' readonly='readonly' id="driveCopyFileTxt"/>
                <!-- <span class='label_text'><a href='#'>Upload</a></span>
                <span class='label_text'><a href='#' onclick='fn_removeFile("DLC")'>Remove</a></span> -->
             </label>
        </div>
    </td>
</tr>
<tr>
    <th scope="row">Bank Passbook / Statement Copy</th>
    <td colspan="3" id="attachTd">
        <div class="auto_file2">
            <input type="file" title="file add" id="bankStateCopyFile" accept="image/jpg, image/jpeg, image/png"/>
            <label>
                <input type='text' class='input_text' readonly='readonly' id="bankStateCopyFileTxt"/>
                <!-- <span class='label_text'><a href='#'>Upload</a></span>
                <span class='label_text'><a href='#' onclick='fn_removeFile("BPSC")'>Remove</a></span> -->
             </label>
        </div>
    </td>
</tr>
<tr>
    <th scope="row">Vaccination Digital Certificate</th>
    <td colspan="3" id="attachTd">
        <div class="auto_file2 ">
            <input type="file" title="file add" id="vaccDigCertFile"/>
            <label>
                <input type='text' class='input_text' readonly='readonly' accept="application/pdf" id="vaccDigCertFileTxt"/>
                <!-- <span class='label_text'><a href='#'>Upload</a></span>
                <span class='label_text'><a href='#' onclick='fn_removeFile("VDC")'>Remove</a></span> -->
             </label>
        </div>
    </td>
</tr>
<tr>
    <th scope="row">Passport Size Photo (white background)</th>
    <td colspan="3" id="attachTd">
    <div class="auto_file2" >
    <input type="file" title="file add" id="fileName" accept="image/jpg, image/jpeg"/>
        <label>
                <input type='text' class='input_text' readonly='readonly' id="fileNameTxt"/>
                <!-- <span class='label_text'><a href='#'>Upload</a></span>
                <span class='label_text'><a href='#' onclick='fn_removeFile("PSP")'>Remove</a></span> -->
        </label>
    </div>
    </td>
</tr>
<tr>
    <th scope="row">Cody PA Copy</th>
    <td colspan="3" id="attachTd">
        <div class="auto_file2">
            <input type="file" title="file add" id="codyPaCopyFile"/>
            <label>
                <input type='text' class='input_text' readonly='readonly' id="codyPaCopyFileTxt"/>
                <!-- <span class='label_text'><a href='#'>Upload</a></span>
                <span class='label_text'><a href='#' onclick='fn_removeFile("CPC")'>Remove</a></span> -->
             </label>
        </div>
    </td>
</tr>
<tr>
    <th scope="row">Company Consigment Cody Item, Tools, Filter Stock, Spare part</th>
    <td colspan="3" id="attachTd">
        <div class="auto_file2">
            <input type="file" title="file add" id="compConsCodyFile"/>
            <label>
                <input type='text' class='input_text' readonly='readonly' id="compConsCodyFileTxt"/>
                <!-- <span class='label_text' cursor='default'><a href='#'>Upload</a></span>
                <span class='label_text' cursor='default'><a href='#' onclick='fn_removeFile("CCCI")'>Remove</a></span> -->
             </label>
        </div>
    </td>
</tr>
<tr>
    <th scope="row">Cody Exit Checklist</th>
    <td colspan="3" id="attachTd">
        <div class="auto_file2">
            <input type="file" title="file add" id="codyExtCheckFile"/>
            <label>
                <input type='text' class='input_text' readonly='readonly' id="codyExtCheckFileTxt"/>
                <!-- <span class='label_text' disabled="disabled"><a href='#'>Upload</a></span>
                <span class='label_text' disabled="disabled"><a href='#' onclick='fn_removeFile("CEC")'>Remove</a></span> -->
             </label>
        </div>
    </td>
</tr>
<tr>
    <th scope="row">Termination Agreement</th>
    <td colspan="3" id="attachTd">
        <div class="auto_file2">
            <input type="file" title="file add" id="terminationAgreeFile"/>
            <label>
                <input type='text' class='input_text' readonly='readonly' id="terminationAgreeFileTxt"/>
                <!-- <span class='label_text' disabled="disabled"><a href='#'>Upload</a></span>
                <span class='label_text' disabled="disabled"><a href='#' onclick='fn_removeFile("TAF")'>Remove</a></span> -->
             </label>
        </div>
    </td>
</tr>
</tbody>
</table><!-- table end -->
</article><!-- tap_area end -->



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
    <input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" id="dtTerRes" name="dtTerRes"/>
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


<script>

const hpAwardHistoryGrid =   GridCommon.createAUIGrid('grid_wrap_awardHistory',[
      {
          dataField : 'month', headerText : 'Month'
      },
      {
          dataField : 'year', headerText : 'Year'
      },
      {
          dataField : 'description', headerText : 'Description'
      },
      {
          dataField : 'destination', headerText : 'Destination'
      },
      {
          dataField : 'remark', headerText : 'Remark'
      }],'',
	{
	      usePaging: true,
	      pageRowCount: 20,
	      editable: false,
	      showRowNumColumn: true,
	      wordWrap: true,
	      showStateColumn: false
	});

	if('${memberView.memType}' =="1"){
		$("#awardHistory").show();
	    fetch("/organization/selectEachHpAwardHistory.do?memCode="+'${memberView.memCode}')
	    .then(r=>r.json())
	    .then(data => {
	         AUIGrid.setGridData(hpAwardHistoryGrid, data);
	    });
	}
</script>