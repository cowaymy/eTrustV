<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">
var optionState = {chooseMessage: " 1.States "};
var optionCity = {chooseMessage: "2. City"};
var optionPostCode = {chooseMessage: "3. Post Code"};
var optionArea = {chooseMessage: "4. Area"};

var myGridID_Doc;
function fn_memberSave(){

                $("#memberType").attr("disabled",false);
	            $("#streetDtl1").val(insAddressForm.streetDtl.value);
	            $("#addrDtl1").val(insAddressForm.addrDtl.value);
	            $("#searchSt1").val(insAddressForm.searchSt.value);
                $("#traineeType").val(($("#traineeType").value));
                
                $("#memberType").attr("disabled",false);
                var jsonObj =  GridCommon.getEditData(myGridID_Doc);
                jsonObj.form = $("#memberAddForm").serializeJSON();
                Common.ajax("POST", "/organization/memberUpdate",  jsonObj, function(result) {
                console.log("message : " + result.message );
                Common.alert(result.message,fn_close);
                
				});
                $("#memberType").attr("disabled",true);
}

function fn_close(){
	$("#popup_wrap").remove();
}
function fn_saveConfirm(){
	if(fn_saveValidation()){
        Common.confirm("<spring:message code='sys.common.alert.save'/>", fn_memberSave);
        /*
        Common.ajax("GET","/organization/memberListUpdate.do", $("#memberAddForm").serialize(), function(result){
            console.log(result);              
            Common.alert("Member Save successfully.",fn_close);
            
        });
        */
        
    }
}
function fn_docSubmission(){
	   	$("#memberType").attr("disabled",false);
	   	var docMemId=$("#MemberID").val();
	    Common.ajax("GET", "/organization/selectHpDocSubmission?memberID=" + docMemId,  $("#memType").serialize(), function(result) {
		console.log("성공.");
        console.log("data : " + result);
        AUIGrid.setGridData(myGridID_Doc, result);
        AUIGrid.resize(myGridID_Doc,1000,400); 
        $("#memberType").attr("disabled",true);
    });
}

function fn_departmentCode(value){
	console.log("fn_departmentCode"); 
	if($("#memberType").val() != 2){
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
           doGetCombo('/common/selectCodeList.do', '7', '','transportCd', 'S' , ''); 
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
           doGetCombo('/common/selectCodeList.do', '7', '','transportCd', 'S' , ''); 
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
           doGetCombo('/common/selectCodeList.do', '7', '','transportCd', 'S' , ''); 
           break;
	}
}

/*
$("#cmbRace").load(function() {
	var race = "${memberView.c40}";
    var race_no = "${memberView.c61}";
    
    alert(race_no);
    $("#cmbRace option[value="+ race_no +"]").attr("selected", true);
    //$("#cmbRace").val(race).attr("selected", true);
    alert($("#cmbRace").val());
});
*/

$(document).ready(function() {
	
	//doGetComboAddr('/common/selectAddrSelCodeList.do', 'country' , '' , '','country', 'S', '');
	  
    //doGetComboAddr('/common/selectAddrSelCodeList.do', 'country' , '' , '','national', 'S', '');
    
    doGetCombo('/sales/customer/getNationList', '338' , '' ,'country' , 'S');
    doGetCombo('/sales/customer/getNationList', '338' , '' ,'national' , 'S'); 
    doGetCombo('/common/selectCodeList.do', '2', '','cmbRace', 'S' , '');
    doGetCombo('/common/selectCodeList.do', '4', '','marrital', 'S' , '');
    doGetCombo('/common/selectCodeList.do', '3', '','language', 'S' , '');
    doGetCombo('/common/selectCodeList.do', '5', '','educationLvl', 'S' , '');
    doGetCombo('/sales/customer/selectAccBank.do', '', '', 'issuedBank', 'S', '')
    doGetCombo('/organization/selectCourse.do', '', '','course', 'S' , '');
    doGetCombo('/organization/selectBusinessType.do', '', '','businessType', 'S' , '');
    /*fill edit field*/
    /*
    var memberType = "${memberView.memType}";
    var gender = "${memberView.gender}";
    
    $("#memberType option[value="+ memberType +"]").attr("selected", true);
    
    var race_no = "${memberView.c61}";
    alert(race_no);
    $("#cmbRace option[value="+ race_no +"]").attr("selected", true);
    
    if(gender=="F"){
        $("#gender_f").prop("checked", true)
    }
    if(gender=="M"){
        $("#gender_m").prop("checked", true)
    }
    */
    //var race = "${memberView.c40}";
    //var race_no = "${memberView.c61}";
    //$("#cmbRace option[value="+ String(race_no) +"]").attr("selected", true);
    //$("#cmbRace option:contains("+race+")").attr('selected',true);
    //$("#cmbRace").val(race_no).attr("selected", true);
    /**/
    
    /*
    $("#deptCd").change(function (){
    	doGetComboSepa("/common/selectBranchCodeList.do",$("#deptCd").val() , '-',''   , 'branch' , 'S', '');
    });
    */
    
	createAUIGridDoc();
	fn_docSubmission();
	//fn_departmentCode();
	$("#state").change(function (){
		var state = $("#state").val();
		doGetComboAddr('/common/selectAddrSelCodeList.do', 'area' ,state ,'area', 'S', '');  
	});
	$("#area").change(function (){
        var area = $("#area").val();
        doGetComboAddr('/common/selectAddrSelCodeList.do', 'post' ,area ,'','postCode', 'S', '');  
    });
	
	/* $("#memberType").change(function (){
        var memberType = $("#memberType").val();
        //fn_departmentCode(memberType);
     }); */
	
	
	fn_getMemInfo();

    $("#searchdepartment").change(function(){
        doGetCombo('/organization/selectSubDept.do',  $("#searchdepartment").val(), '','inputSubDept', 'S' ,  ''); 
    });
});


function fn_getMemInfo(){
	console.log("fn_setMemInfo. sss");
	$("#memberType").attr("disabled",false);
    Common.ajax("GET", "/organization/getMemberListMemberView", $("#memberAddForm").serialize(), function(result) {
        console.log("fn_setMemInfo.");
        console.log(result);
        if(result != null ){
        	fn_setMemInfo(result[0]);
        	console.log("1111111111");
        	console.log(result[0]);
        }else{
        	console.log("========result null=========");
        }
    });
    $("#memberType").attr("disabled",true);
}

function fn_setMemInfo(data){
	console.log("fn_setMemInfo");
	if(data.isHP == "NO"){
		$("#memberType option[value="+ data.memType +"]").attr("selected", true);
		console.log("1 : " +data.memType);
		fn_departmentCode(data.memType);
	
	
	
	/* var memType = "${memberView.memType}";
    alert("memType : " + memType);
    $("#memberType option:eq("+memType+")").attr("selected", true);
    $("#memberType").attr("disabled", true); */
	
	var jsonObj =  GridCommon.getEditData(myGridID_Doc);
    //doGetCombo("/organization/selectDeptCode", jsonObj , ''   , 'deptCd' , 'S', '');
    //doGetComboSepa("/common/selectBranchCodeList.do",4 , '-',''   , 'branch' , 'S', '');


	if(data.gender=="F"){
        $("#gender_f").prop("checked", true)
    }
    if(data.gender=="M"){
        $("#gender_m").prop("checked", true)
    }

    $("#cmbRace option[value="+ data.c61 +"]").attr("selected", true);
    
    
    //$("#national option[value="+ data.c35 +"]").attr("selected", true);
    
    $("#nric").val(data.nric);
    
    $("#fullName").val(data.c65);
    
    $("#marrital option[value="+ data.c27 +"]").attr("selected", true);
    
    $("#email").val(data.email);
    
    $("#mobileNo").val(data.telMobile);
    
    $("#officeNo").val(data.telOffice);
    
    $("#residenceNo").val(data.telHuse);
    
    $("#sponsorCd").val(data.c51);
    
    $("#sponsorNm").val(data.c52);
    
    $("#sponsorNric").val(data.c53);
    //alert(data.c68);
    $("#searchSt").val(data.c68);
    
    /*
    if(data.c4!=null&&jQuery.trim(data.c4).length>0){
        $("#branch option[value="+ data.c4 +"]").attr("selected", true);
    }
    */
    if(data.c41!=null&&jQuery.trim(data.c41).length>0){
        $("#deptCd option[value="+ data.c41 +"]").attr("selected", true);
    }
    
    if(data.c62!=null&&jQuery.trim(data.c62).length>0){
        $("#transportCd option[value="+ data.c62 +"]").attr("selected", true);
    }
    
    if(data.bank!=null&&jQuery.trim(data.bank).length>0){
        $("#issuedBank option[value="+ data.bank +"]").attr("selected", true);
    }
    
    $("#bankAccNo").val(data.bankAccNo);
    
    if(data.c8!=null&&jQuery.trim(data.c8).length>0){
        $("#educationLvl option[value="+ data.c8 +"]").attr("selected", true);
    }
    
    if(data.c10!=null&&jQuery.trim(data.c10).length>0){
        $("#language option[value="+ data.c10 +"]").attr("selected", true);
    }
    
    if(data.religion!=null&&jQuery.trim(data.religion).length>0){
        $("#religion option[value="+ data.religion +"]").attr("selected", true);
    }
    
    $("#trNo").val(data.trNo);
    
    $("#userId").val(data.c64);
    
    
    
    
    $("#searchdepartment option[value='"+ data.mainDept +"']").attr("selected", true);
    
    $("#inputSubDept option[value='"+ data.subDept +"']").attr("selected", true);
    
    $("#course option[value='"+ data.course +"']").attr("selected", true);
    
    $("#selectBranch option[value='"+ data.c3 +"']").attr("selected", true);
    
    
    }
	else{
		  $("#memberType option[value="+ data.memType +"]").attr("selected", true);
	        console.log("1 : " +data.memType);
	        fn_departmentCode(data.memType);
	        
	        $("#memberNm").val(data.memName);
	        $("#nric").val(data.nric);
	        
	        if(data.gender=="F"){
	            $("#gender_f").prop("checked", true)
	        }
	        if(data.gender=="M"){
	            $("#gender_m").prop("checked", true)
	        }
	        
	        $("#email").val(data.email);
	        
	        $("#mobileNo").val(data.telMobile);
	        
	        $("#officeNo").val(data.telOffice);
	        
	        $("#sponsorCd").val(data.sponCd);
	        
	        $("#residenceNo").val(data.telHuse);
	        
	        if(data.bank !=null){
	            $("#issuedBank option[value="+ data.bank +"]").attr("selected", true);
	            $("#issuedBank").val(data.bank);	        
	         }
	        
	        $("#marrital option[value="+ data.marrital +"]").attr("selected", true);
	        $("#cmbRace").val(data.aplicntRace);
	        $("#bankAccNo").val(data.bankAccNo);
	        $("#statusID").val(data.stusId);
	        
		
	}
	
	
	
    doGetCombo('/common/selectCodeList.do', '7', '','transportCd', 'S' , '');
    
    
}


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
        
    }

    ];
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
	var message = "";
	var action = $("#memType").val();
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
	if($("#joinDate").val() == ''){    
        valid = false;
        message += "* Please select joined date. \n ";        
    }
	if($("#memberNm").val() == ''){
        valid = false;
        message += "* Please key in member name. \n ";
    }
	if($("#national").val() == ''){
        valid = false;
        message += "* Please select the nationality. \n ";
    }
	if($("#nric").val() == ''){
        valid = false;
        message += "* Please key in the NRIC. \n ";
    }
    //else
    //{
    //    if (this.IsExistingMember())
    //    {
    //        valid = false;
    //        message += "* This is existing member.<br/>";
    //    }
    //}
	if($('input[name=gender]:checked', '#memberAddForm').val() == null){
        valid = false;
        message += "* Please select gender. \n ";
    }
	if($("#cmbRace").val() == ''){
        valid = false;
        message += "* Please select race. \n ";
    }
	//if($("#marrital").index(this) <=-1){    
	if($("#marrital").val()==""){
        valid = false;
        message += "* Please select marrital. \n ";
    }
    if ($("#Birth").val() == ""){
        valid = false;
        message += "* Please select DOB. \n ";
    }
    else
    {
        var DOBDate = new Date();
        var d = new Date();
        DOBDate = $("#Birth").val() == "" ? defaultDate : new Date($("#Birth").val());
        if ($("#Birth").val() == "")
        {
            var Age = d.getFullYear() - DOBDate.getFullYear();
            if (Age < 18)
            {
                valid = false;
                message += "* Member must 18 years old and above. \n ";
            }
            if (DOBDate==$("#nric").val().substring(0, 6))
            {
                valid = false;
                message += "* The NRIC is mismatch with member's DOB. \n ";
            }
        }
    }
    //endregion

    //region Check Address
    /*
    if (string.IsNullOrEmpty(txtMemAdd1.Text.Trim()) &&
        string.IsNullOrEmpty(txtMemAdd2.Text.Trim()) &&
        string.IsNullOrEmpty(txtMemAdd3.Text.Trim()))
    {
        valid = false;
        message += "* Please key in the address.<br />";
    }
    */
    if ($("#mCountry").val() == "")
    {
        valid = false;
        message += "* Please select the country. \n ";
    }
    else
    {
    	if ($("#mCountry").val() != "")  //mState
        {
    		if ($("#mState").val() == "") //mArea
            {
                valid = false;
                message += "* Please select the state. \n ";
            }
    		if ($("#mArea").val() == "")  //mPostCd
            {
                valid = false;
                message += "* Please select the area. \n ";
            }
    		if ($("#mPostCd").val() == "")
            {
                valid = false;
                message += "* Please select the postcode. \n ";
            }
        }
    }
    
    //endregion

    //region Check Phone No
    if (!(jQuery.trim($("#mobileNo").val()).length>0) &&
        !(jQuery.trim($("#officeNo").val()).length>0) &&
        !(jQuery.trim($("#residenceNo").val()).length>0))
    {
        valid = false;
        message += "* Please key in the at least one contact no. \n ";
    }
    else
    {
        if (jQuery.trim($("#officeNo").val()).length>0)
        {
        	
            if(!jQuery.isNumeric(jQuery.trim($("#mobileNo").val())))            
            {
                valid = false;
                message += "* Invalid telephone number (Mobile).  \n ";
            }
        }
        if ((jQuery.trim($("#officeNo").val())).length>0)
        {
        	if(!jQuery.isNumeric(jQuery.trim($("#officeNo").val())))
            {
                valid = false;
                message += "* Invalid telephone number (Office). \n ";
            }
        }
        if ((jQuery.trim($("#residenceNo").val())).length>0)
        {
        	if(!jQuery.isNumeric(jQuery.trim($("#residenceNo").val())))
            {
                valid = false;
                message += "* Invalid telephone number (Residence). \n ";
            }
        }
    }
    
    if ((jQuery.trim($("#spouseContat").val())).length>0)
    {
    	if(!jQuery.isNumeric(jQuery.trim($("#spouseContat").val())))
        {
            valid = false;
            message += "* Invalid spouse contant number. \n ";
        }
    }
    //endregion

    //region Check Email
    if ((jQuery.trim($("#email").val())).length>0)
    {
        if (!regEmail.test($("#email").val()))
        {
            valid = false;
            message += "* Invalid contact person email.\n ";
        }
    }
    //endregion

    //region Check Bank Account && Department && Branch && Transport
    //issuedBank
    switch (action)
    {
        case "1":
        	if($("#issuedBank").val()=="")
            {
                valid = false;
                message += "* Please select the issued bank. \n ";
            }
            if (!(jQuery.trim($("#bankAccNo").val())).length>0)
            {
                valid = false;
                message += "* Please key in the bank account no. \n ";
            }
        	
            //if (cmbMemDepCode.SelectedIndex <= -1)
            //{
            //    valid = false;
            //    message += "* Please select the department code.<br />";
            //}
            break;
        case "2":
        	if($("#issuedBank").val()=="")
            {
                valid = false;
                message += "* Please select the issued bank. \n ";
            }
        	if (!(jQuery.trim($("#bankAccNo").val())).length>0)
            {
                valid = false;
                message += "* Please key in the bank account no. \n ";
            }
        	if($("#transportCd").val()=="")
            {
                valid = false;
                message += "* Please select the transport code. \n ";
            }
        	
            //if (cmbMemDepCode.SelectedIndex <= -1)
            //{
            //    valid = false;
            //    message += "* Please select the department code.<br />";
            //}
            break;
        case "3":
        
            //if (cmbMemDepCode.SelectedIndex <= -1)
            //{
            //    valid = false;
            //    message += "* Please select the department code.<br />";
            //}
            break;
        case "4":

        	
            break;
        default:
            break;
    }
    //endregion

    //region Document Submission
    /*
    if(action !="1"){
    	
    }else
    {
        RadNumericTextBox RadNumtxt = new RadNumericTextBox();
        List<CodeDetail> DocSubmission = new List<CodeDetail>();
        int i = 0;
        foreach (GridDataItem dataItem in this.RadGrid_Document.MasterTableView.Items)
        {
            if ((dataItem.FindControl("chkSubmission") as RadButton).Checked)
            {
                RadNumtxt = dataItem.FindControl("txtQty") as RadNumericTextBox;
                if (RadNumtxt.Text.Trim().Equals("0") || RadNumtxt.Text.Trim().Equals(string.Empty))
                {
                    i++;
                }
            }
            else
            {
                RadNumtxt = dataItem.FindControl("txtQty") as RadNumericTextBox;
                if (RadNumtxt.Text.Trim() != "0")
                {
                    i++;
                }
            }
        }
        if (i > 0)
        {
            valid = false;
            message += "* Document submission quantity invalid. <br/>";
        }
    }
    */
    //endregion

    //region Check Cody PA Date  codyPaExpr
    if (action == "2") //cyc 01/03/2017
    {
    	if ((jQuery.trim($("#codyPaExpr").val())).length<0)
        {
            valid = false;
            message = "Cody agreement PA date are compulsory";
        }
    }
    //endregion
    //Display Message
    if (!valid)
    {
        //RadWindowManager1.RadAlert("<b>" + message + "</b>", 450, 160, "Save Member Summary", "callBackFn", null);
        Common.alert(message);
    }
    
	return valid;
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
</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Member List - Edit Member</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->
<form action="#" id="memberAddForm" method="post">
<input type="hidden" id="areaId" name="areaId">
<input type="hidden" id="searchSt1" name="searchSt1">
<input type="hidden" id="streetDtl1" name="streetDtl1">
<input type="hidden" id="addrDtl1" name="addrDtl1">
<input type="hidden" id="traineeType" name="traineeType">
<input type="hidden" id="memType" name="memType" value="${memType}">
<input type="hidden"id="MemberID" name="MemberID" value="${memId}">

<input type="hidden" value="<c:out value="${memberView.gender}"/> "  id="gender" name="gender"/>
<input type="hidden" value="<c:out value="${memberView.memCode}"/> "  id="memCode" name="memCode"/>
<input type="hidden" value="<c:out value="${memberView.c64}"/> "  id="userId" name="userId"/>
<input type="hidden" value="<c:out value="${memberView.rank}"/> "  id="rank" name="rank"/>
<input type="hidden" value="<c:out value="${memberView.c65}"/> "  id="fullName" name="fullName"/>
<input type="hidden" value="<c:out value="${memberView.c66}"/> "  id="agrmntNo" name="agrmntNo"/>
<input type="hidden" value="<c:out value="${memberView.c67}"/> "  id="syncChk" name="syncChk"/>
<input type="hidden" value="<c:out value="${memberView.c35}"/> "  id="national" name="national"/>
<input type="hidden" value="<c:out value="${memberView.c3} " /> "  id="branch" name="branch"/>
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
    <select class="w100p" id="memberType" name="memberType">
        <option value="1">Health Planner (HP)</option>
        <option value="2">Coway Lady (Cody)</option>
        <option value="3">Coway Technician (CT)</option>
        <option value="4">Coway Staff (Staff)</option>
        <option value="5">Trainee</option>
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
<tr>
    <th scope="row">Member Name<span class="must">*</span></th>
    <td colspan="3">
    <input type="text" title="" id="memberNm" name="memberNm" placeholder="Member Name" class="w100p"  value="<c:out value="${memberView.name1}"/>"/>
    </td>
    <th scope="row">Joined Date<span class="must">*</span></th>
    <td>
    <input type="text" title="Create start Date" id="joinDate" name="joinDate" placeholder="DD/MM/YYYY" class="j_date"  value="<c:out value="${memberView.c30}"/>"/>
    </td>
</tr>
<tr>
    <th scope="row">Gender<span class="must">*</span></th>
    <td>
    <label><input type="radio" name="gender" id="gender_m" value="M" /><span>Male</span></label>
    <label><input type="radio" name="gender" id="gender_f" value="F"/><span>Female</span></label>
    </td>
    <th scope="row">Date of Birth<span class="must">*</span></th>
    <td>
    <input type="text" title="Create start Date" id="Birth" name="Birth"placeholder="DD/MM/YYYY" class="j_date" value="<c:out value="${memberView.c29}"/>" />
    </td>
    <th scope="row">Race<span class="must">*</span></th>
    <td>
    <select class="w100p" id="cmbRace" name="cmbRace">
    </select>
    </td>
</tr>
<tr>
    <th scope="row">Nationality<span class="must">*</span></th>
    <td>
    <span><c:out value="${memberView.c36} " /></span>
    <!-- 
    <select class="w100p" id="national" name="national">
    </select>
     -->
    </td>
    <th scope="row">NRIC (New)<span class="must">*</span></th>
    <td>
    <input type="text" title="" placeholder="NRIC (New)" id="nric" name="nric" class="w100p" />
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
    <th scope="row">Email</th>
    <td colspan="5">
    <input type="text" title="" placeholder="Email" class="w100p" id="email" name="email" />
    </td>
</tr>
<tr>
    <th scope="row">Mobile No.</th>
    <td>
    <input type="text" title="" placeholder="Numberic Only" class="w100p" id="mobileNo" name="mobileNo"/>
    </td>
    <th scope="row">Office No.</th>
    <td>
    <input type="text" title="" placeholder="Numberic Only" class="w100p"  id="officeNo" name="officeNo"/>
    </td>
    <th scope="row">Residence No.</th>
    <td>
    <input type="text" title="" placeholder="Numberic Only" class="w100p" id="residenceNo"  name="residenceNo"/>
    </td>
</tr>
<tr>
    <th scope="row">Sponsor's Code</th>
    <td>

    <div class="search_100p"><!-- search_100p start -->
    <input type="text" title="" placeholder="Sponsor's Code" class="w100p" id="sponsorCd" name="sponsorCd"/>
    <a href="#" class="search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
    </div><!-- search_100p end -->

    </td>
    <th scope="row">Sponsor's Name</th>
    <td>
    <input type="text" title="" placeholder="Sponsor's Name" class="w100p"  id="sponsorNm" name="sponsorNm"/>
    </td>
    <th scope="row">Sponsor's NRIC</th>
    <td>
    <input type="text" title="" placeholder="Sponsor's NRIC" class="w100p" id="sponsorNric" name="sponsorNric"/>
    </td>
</tr>
<tr>
    <th scope="row">Branch</th>
    <td>
     <!-- <span><c:out value="${memberView.c4} - ${memberView.c5} " /></span>-->
     <select class="w100p"  id="selectBranch" name="selectBranch">
        <c:forEach var="list" items="${branch}" varStatus="status">
           <option value="${list.brnchId}">${list.branchCode} - ${list.branchName}</option>
        </c:forEach>
    </select>
    </td>
    <!-- 
    <td>
    <select class="w100p" id="branch" name="branch">
    </select>
    </td>
    -->
    <th scope="row">Department Code<span class="must">*</span></th>
    <td>
     <span><c:out value="${memberView.c41}"/></span>
     <!-- <span><c:out value="${memberView.c41} - ${memberView.c22} - ${memberView.c23} "/></span> -->
    </td>
    <!-- 
    <td>
    <select class="w100p" id="deptCd" name="deptCd">
    </select>
    </td>
    -->
    <th scope="row">Transport Code<span class="must">*</span></th>
    <td>
    <select class="w100p disabled"  id="transportCd" name="transportCd">
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
    <select class="w100p" id=statusID name=statusID>
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
    <select class="w100p">
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
<tr>
    <th scope="row">Main Department</th>
    <td colspan="2">
    <select class="w100p" id="searchdepartment" name="searchdepartment"  >
        <option selected>Choose One</option>
         <c:forEach var="list" items="${mainDeptList}" varStatus="status">
             <option value="${list.deptId}">${list.deptName } </option>
        </c:forEach>  
    </select>
    </td>
    <th scope="row">Sub Department</th>
    <td colspan="2">
    <select class="w100p" id="inputSubDept" name="inputSubDept">
        <option selected>Choose One</option>
        <c:forEach var="list" items="${subDeptList}" varStatus="status">
             <option value="${list.codeId}">${list.codeName } </option>
        </c:forEach>  
    </select>
    </td>
</tr>   
<tr>
<th scope="row">Businesses Type</th>
      <td>
         <select class="w100p" id="businessType" name="businessType">
    </select>
    </td>
  <th scope="row">Hospitalization</th>
<td>
    <span><input type="checkbox" id="hsptlzCheck" name="hsptlzCheck"/></span>
 </td>
 
 
 <td>
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
    <%-- <span><span><c:out value="${PAExpired.agExprDt}"/></span></span>  --%>
    <input type="text" title="" placeholder="DD/MM/YYYY" class="j_date" id="codyPaExpr" name="codyPaExpr"  value="${PAExpired.agExprDt}"/> 
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
    <input type="text" title="" placeholder="MCode" class="w100p" id="spouseCode" name="spouseCode"  value="<c:out value="${memberView.spouseCode}"/> "/>
    </td>
    <th scope="row">Spouse Name</th>
    <td>
    <input type="text" title="" placeholder="Spouse Nam" class="w100p" id="spouseName" name="spouseName" value="<c:out value="${memberView.spouseName}"/> "/>
    </td>
    <th scope="row">NRIC / Passport No.</th>
    <td>
    <input type="text" title="" placeholder="NRIC / Passport No." class="w100p" id="spouseNRIC" name="spouseNRIC" />
    </td>
</tr>
<tr>
    <th scope="row">Occupation</th>
    <td>
    <input type="text" title="" placeholder="Occupation" class="w100p" id="spouseOcc" value="<c:out value="${memberView.spouseOcpat}"/> " />
    </td>
    <th scope="row">Date of Birth</th>
    <td>
    <input type="text" title="" placeholder="DD/MM/YYYY" class="j_date" id="spouseDOB" name="spouseDOB" value="<c:out value="${memberView.c58}"/> " />
    </td>
    <th scope="row">Contact No.</th>
    <td>
    <input type="text" title="" placeholder="Contact No. (Numberic Only)" class="w100p" id="spouseContat" name="spouseContat" value="<c:out value="${memberView.spouseTelCntc}"/> " />
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
                <input type="text" title="" id="searchSt" name="searchSt" placeholder="" class="" value="<c:out value="${memberView.areaId}"/> "/><a href="#" onclick="fn_addrSearch()" class="search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
                </td>
            </tr>
            <tr>
                <th scope="row" >Address Detail<span class="must">*</span></th>
                <td colspan="3">
                <input type="text" title="" id="addrDtl" name="addrDtl" placeholder="Detail Address" class="w100p" value="<c:out value="${memberView.addrDtl}"/> " />
                </td>
            </tr>
            <tr>
                <th scope="row" >Street</th>
                <td colspan="3">
                <input type="text" title="" id="streetDtl" name="streetDtl" placeholder="Detail Address" class="w100p" value="<c:out value="${memberView.street}"/> " />
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
