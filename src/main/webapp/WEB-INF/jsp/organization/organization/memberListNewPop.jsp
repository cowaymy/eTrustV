<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">
var optionState = {chooseMessage: " 1.States "};
var optionCity = {chooseMessage: "2. City"};
var optionPostCode = {chooseMessage: "3. Post Code"};
var optionArea = {chooseMessage: "4. Area"};

var myGridID_Doc;
function fn_memberSave(){

                if( $("#userType").val() == "1") {
                    $('#memberType').attr("disabled", false);
                    $('#searchdepartment').attr("disabled", false);
                    $('#searchSubDept').attr("disabled", false);
			    }

	            $("#streetDtl1").val(insAddressForm.streetDtl.value);
	            $("#addrDtl1").val(insAddressForm.addrDtl.value);
	            $("#traineeType").val(($("#traineeType1").value));
	            $("#subDept").val(($("#searchSubDept").value));
			    var jsonObj =  GridCommon.getEditData(myGridID_Doc);
			    jsonObj.form = $("#memberAddForm").serializeJSON();

			    console.log("-------------------------" + JSON.stringify(jsonObj));
			    Common.ajax("POST", "/organization/memberSave",  jsonObj, function(result) {
			        console.log("message : " + result.message );

			        // Only applicable to HP Applicant
			        if($("#memberType").val() == "2803") {
			            $("#aplcntNRIC").val($("#nric").val());
			            $("#aplcntName").val($("#memberNm").val());
			            $("#aplcntMobile").val($("#mobileNo").val());

			            console.log("NRIC :: " + $("#aplcntNRIC").val());
			            console.log("Name :: " + $("#aplcntName").val());
			            console.log("Mobile :: " + $("#aplcntMobile").val());



			            // Get ID and identification
			            Common.ajax("GET", "/organization/getApplicantInfo", $("#applicantDtls").serialize(), function(result) {
			                console.log("saving member details");
			                console.log(result);

                            var aplcntId = result.id;

                            // Construct Agreement URL via SMS
                            var cnfmSms = "RM0.00 COWAY: COMPULSORY click " +
                                                 "http://etrust.my.coway.com/organization/agreementListing.do?MemberID=2803" + aplcntId +
                                                 " for confirmation of HP agreement. TQ!";

                            if($("#mobileNo").val() != "") {
                                var rTelNo = $("#mobileNo").val();

                                Common.ajax("GET", "/services/as/sendSMS.do",{rTelNo:rTelNo , msg :cnfmSms} , function(result) {
                                    console.log("sms.");
                                    console.log( result);
                                });
                            }

                            if($("#email").val() != "") {
                                var recipient = $("#email").val();
                                var file = "/resources/report/dev/agreement/CowayHealthPlannerAgreement.pdf";

                                var url = "http://etrust.my.coway.com/organization/agreementListing.do?MemberID=2803" + aplcntId;

                                // Send Email file, recipient
                                Common.ajax("GET", "/organization/sendEmail.do", {url:url, recipient:recipient}, function(result) {
                                    console.log("email.");
                                    console.log(result);
                                })
                            }

			            });
			        }
			        Common.alert(result.message,fn_close);
		});
}

function fn_close(){
	$("#popup_wrap").remove();
}
function fn_saveConfirm(){

	if(fn_saveValidation()){
        Common.confirm("<spring:message code='sys.common.alert.save'/>", fn_memberSave);
    }
}
function fn_docSubmission(){
	    Common.ajax("GET", "/organization/selectHpDocSubmission", { memType : $("#memberType").serialize() , trainType : $("#traineeType1").val()}, function(result) {
		console.log("성공.");
        console.log("data : " + result);
        AUIGrid.setGridData(myGridID_Doc, result);
        AUIGrid.resize(myGridID_Doc,1000,400);
    });
}

function fn_departmentCode(value){
	 if($("#memberType").val() != 2){
	        $("#hideContent").hide();
	    }else{
	    	$("#hideContent").show();
	    }
	 if($("#memberType").val() == 5){
		  $("#trTrainee").show();
     }else{
        $("#trTrainee").hide();
     }

     $("#joinDate").val($.datepicker.formatDate('dd/mm/yy', new Date()));

     $("#joinDate").attr("readOnly", true);



     if($("#memberType").val() == 2803){

         var spouseCode = "${spouseInfoView[0].memCode}";
         var spouseName = "${spouseInfoView[0].name}";
         var spouseNric = "${spouseInfoView[0].nric}";
         var spouseDob = "${spouseInfoView[0].dob}";
         var spouseTel = "${spouseInfoView[0].telMobile}";

        /* $('#sponsorCd').val(spouseCode);
        $('#sponsorNm').val(spouseName);
        $('#sponsorNric').val(spouseNric);  */

		$("#branch").find('option').each(function() {
		    $(this).remove();
		});
        $("#branch").append("<option value=''>Choose One</option>");

        $("#branch").attr("disabled", true);
        $("#transportCd").attr("disabled", true);
        $("#applicationStatus").attr("disabled", true);
        $("#searchdepartment").attr("disabled", true);
        $("#searchSubDept").attr("disabled", true);

        /*
        $('#spouseCode').val(spouseCode);
        $('#spouseName').val(spouseName);
        $('#spouseNRIC').val(spouseNric);
        $('#spouseDOB').val(spouseDob);
        $('#spouseContat').val(spouseTel);

        $('#spouseCode', '#memberAddForm').attr("readonly", true );
        $('#spouseName', '#memberAddForm').attr("readonly",  true );
        $('#spouseNRIC', '#memberAddForm').attr("readonly", true );
        $('#spouseDOB', '#memberAddForm').attr("readonly", true );
        $('#spouseContat', '#memberAddForm').attr("readonly",  true );

        $('#spouseCode', '#memberAddForm').attr('class','w100p readonly ');
        $('#spouseName', '#memberAddForm').attr('class','w100p readonly ');
        $('#spouseNRIC', '#memberAddForm').attr('class','w100p readonly ');
        $('#spouseDOB', '#memberAddForm').attr('class','w100p readonly ');
        $('#spouseContat', '#memberAddForm').attr('class','w100p readonly ');
        */
     } else {
        $('#spouseCode').val('');
        $('#spouseName').val('');
        $('#spouseNric').val('');
        $('#spouseDob').val('');
        $('#spouseContat').val('');

        $('#spouseCode', '#memberAddForm').attr("readonly", false);
        $('#spouseName', '#memberAddForm').attr("readonly", false);
        $('#spouseNric', '#memberAddForm').attr("readonly", false);
        $('#spouseDob', '#memberAddForm').attr("readonly", false);
        $('#spouseContat', '#memberAddForm').attr("readonly", false);

        $('#spouseCode', '#memberAddForm').attr('class','w100p  ');
        $('#spouseName', '#memberAddForm').attr('class','w100p  ');
        $('#spouseNric', '#memberAddForm').attr('class','w100p  ');
        $('#spouseDob', '#memberAddForm').attr('class','w100p  ');
        $('#spouseContat', '#memberAddForm').attr('class','w100p  ');

        $("#branch").attr("disabled", false);
        $("#transportCd").attr("disabled", false);
        $("#applicationStatus").attr("disabled", false);
        $("#searchdepartment").attr("disabled", false);
        $("#searchSubDept").attr("disabled", false);

     }


	var action = value;
	console.log("fn_departmentCode >> " + action)
	switch(action){
	   case "1" :
		   var jsonObj = {
	            memberLvl : 3,
	            flag :  "%CRS%"
	    };
		   doGetCombo("/organization/selectDeptCodeHp", jsonObj , ''   , 'deptCd' , 'S', '');
		   break;
	   case "2" :
           var jsonObj = {
                memberLvl : 3,
                flag :  "%CCS%"
        };
           doGetCombo("/organization/selectDeptCode", jsonObj , ''   , 'deptCd' , 'S', '');
           doGetComboSepa("/common/selectBranchCodeList.do",4 , '-',''   , 'branch' , 'S', '');
           doGetCombo('/common/selectCodeList.do', '7', '','transportCd', 'S' , '');
           break;
	   case "3" :
           var jsonObj = {
                memberLvl : 3,
                flag :  "%CTS%"
        };
           doGetCombo("/organization/selectDeptCode", jsonObj , ''   , 'deptCd' , 'S', '');
           doGetComboSepa("/common/selectBranchCodeList.do",2 , '-',''   , 'branch' , 'S', '');
           doGetCombo('/common/selectCodeList.do', '7', '','transportCd', 'S' , '');
           break;

	   case "4" :
           var jsonObj = {
                memberLvl : 100,
                flag :  "-"
        };
           doGetComboSepa("/common/selectBranchCodeList.do",100 , '-',''   , 'branch' , 'S', '');
           break;

	   case "5" :

           $("#branch").find('option').each(function() {
               $(this).remove();
           });
           $("#deptCd").find('option').each(function() {
               $(this).remove();
           });

           $("#traineeType1").change(function(){

        	   var traineeType =  $("#traineeType1").val();

        	   fn_docSubmission()
        	   console.log("fn_departmentCode traineeType>> " + traineeType)

        	   if( traineeType == '2'){
        		    doGetComboSepa("/common/selectBranchCodeList.do",'4' , '-',''   , 'branch' , 'S', '');

		           $("#branch").change(function(){
		               var jsonObj = {
		                       memberLvl : 3,
		                       flag :  "%CCS%",
		                       branchVal : $("#branch").val()
		               };

		               doGetCombo("/organization/selectDeptCode", jsonObj , ''   , 'deptCd' , 'S', '');
		           });

		           //Training Course ajax콜 위치
		           //doGetCombo("/organization/selectCoureCode.do", traineeType , ''   , 'course' , 'S', '');
                   var groupCode  = {groupCode : traineeType};
		           Common.ajax("GET", "/organization/selectCoureCode.do", groupCode, function(result) {

			            $("#course").find('option').each(function() {
			                $(this).remove();
			            });
			             console.log("-------------------------" + JSON.stringify(result));
			             if (result!= null) {
			             $("#course").append("<option value=''>Choose One</option>");
			                for( var i=0; i< result.length; i++) {
			                 $("#course").append("<option value="+result[i].codeId+">"+result[i].codeName+"</option>");
			                }
			             }
		             });

        	   }
        	   else if(traineeType == '3'){

		           $("#branch").change(function(){
		               var jsonObj = {
		                       memberLvl : 3,
		                       flag :  "%CTS%",
		                       branchVal : $("#branch").val()
		               };

		               doGetCombo("/organization/selectDeptCode", jsonObj , ''   , 'deptCd' , 'S', '');
		           });

        		   doGetComboSepa("/common/selectBranchCodeList.do",'5' , '-',''   , 'branch' , 'S', '');

        		   //Training Course ajax콜 위치
        		   //doGetCombo("/organization/selectCoureCode.do", traineeType , ''   , 'course' , 'S', '');
        		   var groupCode  = {groupCode : traineeType};
                   Common.ajax("GET", "/organization/selectCoureCode.do", groupCode, function(result) {

                        $("#course").find('option').each(function() {
                            $(this).remove();
                        });
                         console.log("-------------------------" + JSON.stringify(result));
                         if (result!= null) {
                         $("#course").append("<option value=''>Choose One</option>");
                            for( var i=0; i< result.length; i++) {
                             $("#course").append("<option value="+result[i].codeId+">"+result[i].codeName+"</option>");
                            }
                         }
                     });
        	   }
           });

           doGetCombo('/common/selectCodeList.do', '7', '','transportCd', 'S' , '');
           break;

        case "2803" :



	        if ( $("#userType").val() == "1" ) {

	            Common.ajax("GET", "/organization/selectDeptCodeHp", null, function(result) {

					$("#deptCd").find('option').each(function() {
					    $(this).remove();
					});

					console.log("------selectDeptCodeHp-------------------" + JSON.stringify(result));
					if (result!= null) {
					   $("#deptCd").append("<option value="+result[0].codeId+">"+result[0].codeId+"</option>");
					}

	            });


	        } else {
	           //doGetCombo('/organization/selectDepartmentCode', '', '','deptCd', '' , '');

                Common.ajax("GET", "/organization/selectDepartmentCode", null, function(result) {

                    $("#deptCd").find('option').each(function() {
                        $(this).remove();
                    });

                    console.log("------selectDepartmentCode-------------------" + JSON.stringify(result));
                    if (result!= null) {
                       $("#deptCd").append("<option value="+result[0].codeId+">"+result[0].codeId+"</option>");
                        for(var z=0; z< result.length;z++) {
                            $("#deptCd").append("<option value="+result[z].codeId+">"+result[z].codeName+"</option>");
                       }
                    }

                });
	        }
	        /*
	        $("#branch").find('option').each(function() {
                    $(this).remove();
                });

                //branch combo 다시 그림.
                //doGetCombo('/organization/selectBranchCode', '', '','branch', '' , '');

                Common.ajax("GET", "/organization/selectBranchCode", null, function(result) {

                    console.log("-----selectBranchCode--------------------" +result.length + JSON.stringify(result));
                    if (result!= null) {
                        for(var z=0; z< result.length;z++) {
                            $("#branch").append("<option value="+result[z].codeId+">"+result[z].codeName+"</option>");
                       }
                    }

                });
	           */
        break;

	/*     case "2803" :   // this is temp code  that   add by hgham

	    	     $("#deptCd option").remove();
	             $("#deptCd option").remove();
                 $("#deptCd").append("<option value='CRS3001'>CRS3001</option>");
            break; */
	}


}
$(document).ready(function() {

	//doGetComboAddr('/common/selectAddrSelCodeList.do', 'country' , '' , '','country', 'S', '');

    //doGetComboAddr('/common/selectAddrSelCodeList.do', 'country' , '' , '','national', 'S', '');

    //doGetCombo('/sales/customer/getNationList', '338' , '' ,'country' , 'S', '' );
    //doGetCombo('/sales/customer/getNationList', '338' , '' ,'national' , 'S' , '');

    //doGetCombo('/common/selectCodeList.do', '2', '','cmbRace', 'S' , '');
    doGetCombo('/common/selectCodeList.do', '4', '','marrital', 'S' , '');
    doGetCombo('/common/selectCodeList.do', '3', '','language', 'S' , '');
    doGetCombo('/common/selectCodeList.do', '5', '','educationLvl', 'S' , '');
    doGetCombo('/sales/customer/selectAccBank.do', '', '', 'issuedBank', 'S', '')
    //doGetCombo('/organization/selectCourse.do', '', '','course', 'S' , '');

    $("#deptCd").change(function (){
    	//modify hgham 2017-12-25  주석 처리
    	//doGetComboSepa("/common/selectBranchCodeList.do",$("#deptCd").val() , '-',''   , 'branch' , 'S', '');
    });
	createAUIGridDoc();
	fn_docSubmission();
	fn_departmentCode('2');  //modify  hgham 25-12 -2017    as is code  fn_departmentCode();

	$("#state").change(function (){
		var state = $("#state").val();
		doGetComboAddr('/common/selectAddrSelCodeList.do', 'area' ,state ,'area', 'S', '');
	});
	$("#area").change(function (){
        var area = $("#area").val();
        doGetComboAddr('/common/selectAddrSelCodeList.do', 'post' ,area ,'','postCode', 'S', '');
    });

	// Member Type 바꾸면 입력한 NRIC 비우기, doc 새로불러오기
	$("#memberType").change(function (){
		$("#nric").val('');
		  fn_docSubmission();
		  if ($("#memberType").val() == "4") {
			  $("#memberCd").attr("disabled", false);
		  } else {
			  $("#memberCd").attr("disabled", true);
		  }

    });

	$("#memberType").click(function (){

	console.log("================" +  $("#memberType").val());
        var memberType = $("#memberType").val();

        if ( memberType ==  "2803") {
            $('#course').attr("disabled", true);
            $('#email').prop('required', true);
            $('#mobileNo').prop('required', true);
            $('#emailLbl').append("<span class='must'>*</span>");
            $('#mobileNoLbl').append("<span class='must'>*</span>");
        } else {
            $('#course').removeAttr('disabled');
        }
        fn_departmentCode(memberType);


     });

     $("#searchdepartment").change(function(){

        doGetCombo('/organization/selectSubDept.do',  $("#searchdepartment").val(), '','searchSubDept', 'S' ,  '');

     });

    //var nationalStatusCd = "1";
    $("#national option[value=1]").attr('selected', 'selected');

    //var cmbRacelStatusCd = "10";
    $("#cmbRace option[value=10]").attr('selected', 'selected');

     if( $("#userType").val() == "1") {
        $("#memberType option[value=2803]").attr('selected', 'selected');
        $('#memberType').attr("disabled", true);
     }


     $('#memberType').trigger('click');

     $('#nric').blur(function() {
    	 if ($('#nric').val().length == 12) {
    		 checkNRIC();
    		 /* if ($('#nric').val().length == 12) {
    			 autofilledbyNRIC();
    		 } */
         }
     });

     $('#sponsorCd').blur(function() {
    	 if ($('#sponsorCd').val().length > 0) {
    		 fn_sponsorCd();
    	 }
     });

     if ($("#memberType").val() == "4") {
         $("#memberCd").attr("disabled", false);
     } else {
         $("#memberCd").attr("disabled", true);
     }

});
function createAUIGridDoc() {
    //AUIGrid 칼럼 설정
    var columnLayout = [
        {
            dataField : "codeId",
            headerText : "DocumentId",
            editable : false,
            width : 0
        }
       ,{
        dataField : "codeName",
        headerText : "Document",
        editable : false,
        width : 220
    }, {
        dataField : "submission",
        headerText : "Submission",
        editable : false,
        width : 130,
        renderer : {
            type : "CheckBoxEditRenderer",
            showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
            editable : false, // 체크박스 편집 활성화 여부(기본값 : false)
            checkValue : "1", // true, false 인 경우가 기본
            unCheckValue : "0",
         // 체크박스 Visible 함수
            checkableFunction  : function(rowIndex, columnIndex, value, isChecked, item, dataField) {
                if(item.docQty == 0){
                    AUIGrid.updateRow(myGridID_Doc, {
                         "docQty" : "1"

                        }, rowIndex);
                }
                return true;
            }

        }
    }, {
        dataField : "docQty",
        headerText : "Qty",
        dataType : "numeric",
        editRenderer : {
            type : "NumberStepRenderer",
            min : 0,
            max : 10,
            step : 1,
            textEditable : true
        },
        width : 130,
        checkableFunction  : function(rowIndex, columnIndex, value, isChecked, item, dataField) {
            if(item.docQty != 0){
                AUIGrid.updateRow(myGridID_Doc, {
                      "submission" : "1"

                    }, rowIndex);
            }else{
                AUIGrid.updateRow(myGridID_Doc, {
                    "submission" : "0"
                  }, rowIndex);
            }
            return true;
        }

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
        showRowNumColumn : false,

    };

    //myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout, gridPros);
    myGridID_Doc = AUIGrid.create("#grid_wrap_doc", columnLayout, gridPros);
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

//Validation Check
function fn_saveValidation(){

	if($("#memberNm").val() == ''){
        Common.alert("Please key  in Member Name");
        return false;
    }

	if($("#joinDate").val() == ''){
        Common.alert("Please select Joined Date");
        return false;
    }

	if($("#sponsorCd").val() == ''){
        Common.alert("Please select 'Sponsor's Code'");
        return false;
    }

	if($('input[name=gender]:checked', '#memberAddForm').val() == null){
		  Common.alert("Please select Gender");
	        return false;
	}

/*	if($("#memberType").val() == 5){
		if($("#traineeType").val() == 0){
			  common.alert("Please select Trainee Type");
			  return false;
		}
	}*/
    /* if(!$("#gender").is(":radio")){

    } */

	if($("#Birth").val() == ''){
        Common.alert("Please select Date of Birth");
        return false;
    }

	if($("#cmbRace").val() == ''){
        Common.alert("Please select race");
        return false;
    }

	if($("#national").val() == ''){
        Common.alert("Please select Nationality");
        return false;
    }

	if($("#nric").val() == ''){
        Common.alert("Please key  in NRIC");
        return false;
    }

    if (  $("#nric").val().length != 12 ) {
        Common.alert("NRIC should be in 12 digit");
        return false;
    }

	if($("#marrital").val() == ''){
        Common.alert("Please select marrital");
        return false;
    }

	if($("#issuedBank").val() == ''){
        Common.alert("Please select the issued bank");
        return false;
    }
	if($("#bankAccNo").val() == ''){
        Common.alert("Please key in the bank account no");
        return false;
    }
	//type 별로 다르게 해야됨
	if($("#deptCd").val() == ''){
        Common.alert("Please select the department code");
        return false;
    }

	if($("#areaId").val() == ''){
        Common.alert("Please key in the address.");
        return false;
    }

	if($("#addrDtl").val() == ''){
        Common.alert("Please key in the address detail.");
        return false;
    }

    if($("#mArea").val() == ''){
            Common.alert("Please key in the area.");
            return false;
    }

    if($("#mCity").val() == ''){
        Common.alert("Please key in the city.");
        return false;
    }

    if($("#mPostCd").val() == ''){
        Common.alert("Please key in the postcode.");
        return false;
    }

    if($("#mState").val() == ''){
        Common.alert("Please key in the state.");
        return false;
    }

    if($("#memberNm").val() == '5'){ //Training Course
	    if($("#course").val() == ''){
	        Common.alert("Please key  in Training Course");
	        return false;
	    }
    }
    if($("#memberType").val() =='5'){
    	if($("#traineeType1").val() ==''){
    		   Common.alert("Please key in Trainee type");
    		   return false;
    	}
    }

    if($("#memberType").val() == "2803") {
        if($("#mobileNo").val() == '') {
            if($("#email").val() == '') {
                Common.alert("Please key in Mobile No. or Email Address");
                return false;
            }
        }
    }

	return true;
}

function fn_addrSearch(){
    if($("#searchSt").val() == ''){
        Common.alert("Please search.");
        return false;
    }
    Common.popupDiv('/sales/customer/searchMagicAddressPop.do' , $('#insAddressForm').serializeJSON(), null , true, '_searchDiv'); //searchSt
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
        Common.alert("Please check your address.");
    }
}



function fn_sponsorPop(){
    Common.popupDiv("/organization/sponsorPop.do" , $('#memberAddForm').serializeJSON(), null , true,  '_searchSponDiv'); //searchSt
}


function fn_addSponsor(msponsorCd, msponsorNm, msponsorNric) {


    $("#sponsorCd").val(msponsorCd);
    $("#sponsorNm").val(msponsorNm);
    $("#sponsorNric").val(msponsorNric);

    $("#_searchSponDiv").remove();

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

function fn_sponsorCheck(){
	if(event.keyCode == 13) {
		fn_sponsorCd();
	}
}

function fn_sponsorCd(){
	Common.ajax("GET", "/organization/checkSponsor.do", $("#memberAddForm").serializeJSON(), function(result) {
		// add jgkim
        console.log("checkSponsor.do Action");
        console.log(result);
        if (result.message != "ok") {
        	Common.alert(result.message);
        } else {
        	// add jgkim
        	$("#sponsorNm").val(result.data.name);
        	$("#sponsorNric").val(result.data.nric);
        }
	});
}

function checkNRICEnter(){
    if(event.keyCode == 13) {
    	checkNRIC();
    }
}



function checkNRIC(){
	var returnValue;

   	var jsonObj = { "nric" : $("#nric").val() };

   	if ($("#memberType").val() == '2803' || $("#memberType").val() == '4' || $("#memberType").val() == '5') {
	   	Common.ajax("GET", "/organization/checkNRIC1.do", jsonObj, function(result) {
	           console.log("data : " + result);
	           if (result.message != "pass") {
	           	Common.alert(result.message);
	           	$("#nric").val('');
	           	returnValue = false;
	           	return false;
	           } else {    // 조건1 통과 -> 조건2 수행

	           	Common.ajax("GET", "/organization/checkNRIC2.do", jsonObj, function(result) {
	                   console.log("data : " + result);
	                   if (result.message != "pass") {
	                       Common.alert(result.message);
	                       $("#nric").val('');
	                       returnValue = false;
	                       return false;
	                   } else {    // 조건2 통과 -> 조건3 수행

	                   	Common.ajax("GET", "/organization/checkNRIC3.do", jsonObj, function(result) {
	                           console.log("data : " + result);
	                           if (result.message != "pass") {
	                               Common.alert(result.message);
	                               $("#nric").val('');
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


    return returnValue;

}

function autofilledbyNRIC(){

    //if ($("#memberType").val() == '4') {
    	var nric = $("#nric").val().replace('-', '');
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
            $("#Birth").val(autoDOB_date+"/"+autoDOB_month+"/"+"20"+autoDOB_year);
        } else {
        	$("#Birth").val(autoDOB_date+"/"+autoDOB_month+"/"+"19"+autoDOB_year);
        }
    //}

}
</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Member List - Add New Member</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<form id="applicantDtls" method="post">
    <div style="display:none">
        <input type="text" name="aplcntNRIC"  id="aplcntNRIC"/>
        <input type="text" name="aplcntName"  id="aplcntName"/>
        <input type="text" name="aplcntMobile"  id="aplcntMobile"/>
    </div>
</form>

<section class="pop_body"><!-- pop_body start -->
<form action="#" id="memberAddForm" method="post">
<input type="hidden" id="areaId" name="areaId">
<input type="hidden" id="streetDtl1" name="streetDtl">
<input type="hidden" value ="addrDtl" id="addrDtl1" name="addrDtl">
<input type="hidden" id="traineeType" name="traineeType">
<input type="hidden" id="subDept" name="subDept">
<input type="hidden" id="userType" name="userType" value="${userType}">
<input type="hidden" id="memType" name="memType" value="${memType}">

<!--<input type="hidden" id = "memberType" name="memberType"> -->
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
    <select class="w100p" id="memberType" name="memberType">
        <!-- <option value="1">Health Planner (HP)</option> -->
     <%--    <option value="2">Coway Lady (Cody)</option>
        <option value="3">Coway Technician (CT)</option>--%>
        <option value="4">Coway Staff (Staff)</option>
        <option value="5" selected="selected">Trainee</option>
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
    <li><a href="#">Document Submission</a></li>
    <li><a href="#">Member Address</a></li>
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
<!-- <tr>
    <th scope="row">Member Code</th>
    <td colspan="5">
    <input type="text" title="" id="memberCd" name="memberCd" placeholder="Member Code" class="w100p" disabled="disabled" />
    </td>
</tr> -->
<tr>
    <th scope="row">Member Name<span class="must">*</span></th>
    <td colspan="3">
    <input type="text" title="" id="memberNm" name="memberNm" placeholder="Member Name" class="w100p" />
    </td>
    <th scope="row">Joined Date<span class="must">*</span></th>
    <td>
    <input type="text" title="Create start Date" id="joinDate" name="joinDate" placeholder="DD/MM/YYYY" class="w100p" />
    </td>
</tr>
<tr>
    <th scope="row">Gender<span class="must">*</span></th>
    <td>
    <label><input type="radio" name="gender" id="gender" value="M" /><span>Male</span></label>
    <label><input type="radio" name="gender" id="gender" value="F"/><span>Female</span></label>
    </td>
    <th scope="row">Date of Birth<span class="must">*</span></th>
    <td>
    <input type="text" title="Create start Date" id="Birth" name="Birth"placeholder="DD/MM/YYYY" class="j_date" />
    </td>
    <th scope="row">Race<span class="must">*</span></th>
    <td>
    <select class="w100p" id="cmbRace" name="cmbRace">
        <c:forEach var="list" items="${race}" varStatus="status">
            <option value="${list.detailcodeid}">${list.detailcodename } </option>
        </c:forEach>
    </select>
    </td>
</tr>
<tr>
    <th scope="row">Nationality<span class="must">*</span></th>
    <td>
    <select class="w100p" id="national" name="national">
     <c:forEach var="list" items="${nationality}" varStatus="status">
             <option value="${list.countryid}">${list.name } </option>
        </c:forEach>
    </select>
    </td>
    <th scope="row">NRIC (New)<span class="must">*</span></th>
    <td>
    <input type="text" title="" placeholder="NRIC (New)" id="nric" name="nric" class="w100p"  maxlength="12" onKeyDown="checkNRICEnter()"
        onKeypress="if(event.keyCode < 45 || event.keyCode > 57) event.returnValue = false;" style = "IME-MODE:disabled;"/>
    </td>
    <th scope="row">Marrital Status<span class="must">*</span></th>
    <td>
    <select class="w100p" id="marrital" name="marrital">
    </select>
    </td>
</tr>
<%-- <tr>
    <th scope="row" rowspan="3">Address<span class="must">*</span></th>
    <td colspan="5">
    <input type="text" title="" placeholder="Address(1)" class="w100p" id="address1" name="address1"/>
    </td>
</tr>
<tr>
    <td colspan="5">
    <input type="text" title="" placeholder="Address(2)" class="w100p" id="address2" name="address2"/>
    </td>
</tr>
<tr>
    <td colspan="5">
    <input type="text" title="" placeholder="Address(3)" class="w100p" id="address3" name="address3"/>
    </td>
</tr>
<tr>
    <th scope="row">Country<span class="must">*</span></th>
    <td>
    <select class="w100p" id="country" name="country">
    </select>
    </td>
    <th scope="row">State<span class="must">*</span></th>
    <td>
    <select class="w100p" id="state" name="state">
        <c:forEach var="list" items="${state }" varStatus="status">
           <option value="${list.codeId}">${list.codeName}</option>
        </c:forEach>
    </select>
    </td>
    <th scope="row">Area<span class="must">*</span></th>
    <td>
    <select class="w100p" id="area" name="area">

    </select>
    </td>
</tr>
<tr>
    <th scope="row">Postcode<span class="must">*</span></th>
    <td>
    <select class="w100p" id="postCode" name="postCode">
    </select>
    </td>
    <th scope="row">Email</th>
    <td colspan="3">
    <input type="text" title="" placeholder="Email" class="w100p" id="email" name="email"/>
    </td>
</tr> --%>
<tr>
    <th scope="row" id="emailLbl" name="emailLbl">Email</th>
    <td colspan="5">
    <input type="text" title="" placeholder="Email" class="w100p" id="email" name="email" />
    </td>
</tr>
<tr>
    <th scope="row" id="mobileNoLbl" name="mobileNoLbl">Mobile No.</th>
    <td>
    <input type="text" title="" placeholder="Numberic Only" class="w100p" id="mobileNo" name="mobileNo"
        onKeypress="if(event.keyCode < 45 || event.keyCode > 57) event.returnValue = false;" style = "IME-MODE:disabled;"/>
    </td>
    <th scope="row">Office No.</th>
    <td>
    <input type="text" title="" placeholder="Numberic Only" class="w100p"  id="officeNo" name="officeNo"
        onKeypress="if(event.keyCode < 45 || event.keyCode > 57) event.returnValue = false;" style = "IME-MODE:disabled;"/>
    </td>
    <th scope="row">Residence No.</th>
    <td>
    <input type="text" title="" placeholder="Numberic Only" class="w100p" id="residenceNo"  name="residenceNo"
        onKeypress="if(event.keyCode < 45 || event.keyCode > 57) event.returnValue = false;" style = "IME-MODE:disabled;"/>
    </td>
</tr>
<tr>
    <th scope="row">Sponsor's Code<span class="must">*</span></th>
    <td>

    <div class="search_100p"><!-- search_100p start -->
    <input type="text" title="" placeholder="Sponsor's Code" class="w100p" id="sponsorCd" name="sponsorCd" onKeyDown="fn_sponsorCheck()"/>
    <a href="javascript:fn_sponsorPop();" class="search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
    </div><!-- search_100p end -->

    </td>
    <th scope="row">Sponsor's Name</th>
    <td>
    <input type="text" title="" placeholder="Sponsor's Name" class="w100p"  id="sponsorNm" name="sponsorNm"/>
    </td>
    <th scope="row">Sponsor's NRIC</th>
    <td>
    <input type="text" title="" placeholder="Sponsor's NRIC" class="w100p" id="sponsorNric" name="sponsorNric"
        onKeypress="if(event.keyCode < 45 || event.keyCode > 57) event.returnValue = false;" style = "IME-MODE:disabled;"/>
    </td>
</tr>
<tr>
    <th scope="row">Branch<span class="must">*</span></th>
    <td>
    <select class="w100p" id="branch" name="branch">
    </select>
    </td>
    <th scope="row">Department Code<span class="must">*</span></th>
    <td>
    <select class="w100p" id="deptCd" name="deptCd">
        <c:forEach var="list" items="${DeptCdList}" varStatus="status">
            <option value="${list.codeId}">${list.codeName } </option>
        </c:forEach>

    </select>
    </td>
    <th scope="row">Transport Code</th>
    <td>
    <select class="w100p"  id="transportCd" name="transportCd">
    </select>
    </td>
</tr>
<tr>
    <th scope="row">e-Approval Status</th>
    <td colspan="5">
    <input type="text" title="" placeholder="e-Approval Status" class="w100p" />
    </td>
</tr>
<tr>
    <th scope="row">Religion</th>
    <td colspan="2">
    <select class="w100p" id="religion" name="religion">
            <option value="">Choose One</option>
        <c:forEach var="list" items="${Religion}" varStatus="status">
            <option value="${list.detailcodeid}">${list.detailcodename } </option>
        </c:forEach>
    </select>
    </td>
    <th scope="row">e-Approval Status</th>
    <td colspan="2">
    <select class="w100p">
        <option value="">Choose One</option>
        <option value="">Pending</option>
        <option value="">Approved</option>
        <option value="">Rejected</option>
    </select>
    </td>
</tr>
<tr>
    <th scope="row">Training Course</th>
    <td colspan="2">
    <select class="w100p" id="course" name="course">
    </select>
    </td>
    <th scope="row">Total Vacation</th>
    <td colspan="2">
    <input type="text" title="" placeholder="Total Vacation" class="w100p" />
    </td>
</tr>
<tr>
    <th scope="row">Application Status</th>
    <td colspan="2">
    <select class="w100p" id="applicationStatus">
        <option value="">Choose One</option>
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
    <input type="text" title="" placeholder="Remain Vacation" class="w100p" />
    </td>
</tr>
<tr id = "trTrainee" >
    <th scope="row">Trainee Type </th>
    <td colspan="2">
        <select class= "w100p" id="traineeType1" name="traineeType1">
        <option value="">Choose One</option>
        <option value= "2">Cody</option>
        <option value = "3">CT</option>
    </select>
    </td>
    <th scope="row"></th>
    <td colspan="2">
    </td>
</tr>
<tr>
    <th scope="row">Main Department</th>
    <td colspan="2">
    <select class="w100p" id="searchdepartment" name="searchdepartment"  >
            <option value="">Choose One</option>
         <c:forEach var="list" items="${mainDeptList}" varStatus="status">
             <option value="${list.deptId}">${list.deptName } </option>
        </c:forEach>
    </select>
    </td>
    <th scope="row">Sub Department</th>
    <td colspan="2">
    <select class="w100p" id="searchSubDept" name="searchSubDept">
             <option value="">Choose One</option>
       <%-- <c:forEach var="list" items="${subDeptList}" varStatus="status">
             <option value="${list.deptId}">${list.deptName} </option>
        </c:forEach>  --%>
    </select>
    </td>
</tr>
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
    <select class="w100p" id="issuedBank" name="issuedBank">
    </select>
    </td>
    <th scope="row">Bank Account No<span class="must">*</span></th>
    <td>
    <input type="text" title="" placeholder="Bank Account No" class="w100p" id="bankAccNo"  name="bankAccNo"/>
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
<tr>
    <th scope="row">Education Level</th>
    <td>
    <select class="w100p" id="educationLvl" name="educationLvl">
    </select>
    </td>
    <th scope="row">Language</th>
    <td>
    <select class="w100p" id="language" name="language">
    </select>
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
    <input type="text" title="" placeholder="TR No." class="w100p" id="trNo" name="trNo"/>
    </td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="title_line" ><!-- title_line start -->
<h2>Agreedment</h2>
</aside><!-- title_line end -->

<table class="type1" id="hideContent"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"  class="hideContent">Cody PA Expiry<span class="must">*</span></th>
    <td  class="hideContent">
    <input type="text" title="" placeholder="DD/MM/YYYY" class="j_date" id="codyPaExpr" name="codyPaExpr"/>
    </td>
</tr>
</tbody>
</table><!-- table end -->

<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#" onClick="javascript:fn_saveConfirm()">SAVE</a></p></li>
    <li><p class="btn_blue2 big"><a href="#">CANCEL</a></p></li>
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
    <input type="text" title="" placeholder="MCode" class="w100p readonly " id="spouseCode" readonly="readonly" name="spouseCode" value=""/>
    </td>
    <th scope="row">Spouse Name</th>
    <td>
    <input type="text" title="" placeholder="Spouse Nam" class="w100p readonly " id="spouseName" readonly="readonly"  name="spouseName" value=""/>
    </td>
    <th scope="row">NRIC / Passport No.</th>
    <td>
    <input type="text" title="" placeholder="NRIC / Passport No." class="w100p readonly " id="spouseNric" readonly="readonly"  name="spouseNric"  value=""/>
    </td>
</tr>
<tr>
    <th scope="row">Occupation</th>
    <td>
    <input type="text" title="" placeholder="Occupation" class="w100p" id="spouseOcc" name="spouseOcc" value=""/>
    </td>
    <th scope="row">Date of Birth</th>
    <td>
    <input type="text" title="" placeholder="DD/MM/YYYY" class="j_date readonly" id="spouseDob" readonly="readonly"  name="spouseDob" value=""/>
    </td>
    <th scope="row">Contact No.</th>
    <td>
    <input type="text" title="" placeholder="Contact No. (Numberic Only)" class="w100p readonly" id="spouseContat" readonly="readonly"  name="spouseContat"  value=""/>
    </td>
</tr>
</tbody>
</table><!-- table end -->

<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#" onClick="javascript:fn_saveConfirm()">SAVE</a></p></li>
    <li><p class="btn_blue2 big"><a href="#">CANCEL</a></p></li>
</ul>

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->
<div id="grid_wrap_doc" style="width: 100%; height:430px; margin: 0 auto;"></div>

<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#" onClick="javascript:fn_saveConfirm()">SAVE</a></p></li>
    <li><p class="btn_blue2 big"><a href="#">CANCEL</a></p></li>
</ul>
</article><!-- tap_area end -->


</form>
<article class="tap_area"><!-- tap_area start -->

<aside class="title_line"><!-- title_line start -->
<h2>Installation Address</h2>
</aside><!-- title_line end -->

<form id="insAddressForm" name="insAddressForm" method="POST">

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
                <input type="text" title="" id="searchSt" name="searchSt" placeholder="" class="" /><a href="#" onclick="fn_addrSearch()" class="search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
                </td>
            </tr>
            <tr>
                <th scope="row" >Address Detail<span class="must">*</span></th>
                <td colspan="3">
                <input type="text" title="" id="addrDtl" name="addrDtl" placeholder="Detail Address" class="w100p"  />
                </td>
            </tr>
            <tr>
                <th scope="row" >Street</th>
                <td colspan="3">
                <input type="text" title="" id="streetDtl" name="streetDtl" placeholder="Street" class="w100p"  />
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
                <input type="text" title="" id="mCountry" name="mCountry" placeholder="" class="w100p readonly" readonly="readonly" value="Malaysia"/>
                </td>
            </tr>
        </tbody>
    </table><!-- table end -->
</form>
<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#" onClick="javascript:fn_saveConfirm()">SAVE</a></p></li>
    <li><p class="btn_blue2 big"><a href="#">CANCEL</a></p></li>
</ul>

</article><!-- tap_area end -->

</section><!-- tap_wrap end -->


</div><!-- popup_wrap end -->
