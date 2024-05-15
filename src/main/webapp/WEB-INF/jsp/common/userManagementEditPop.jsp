<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javaScript">
/********************************Global Variable Start***********************************/

var userRoleData = null;
/********************************Global Variable End************************************/
/********************************Function  Start***************************************
 *
 */
/****************************Function  End***********************************
 *
 */
/****************************Transaction Start********************************/
function removePopupCallback(){
	userManagementEditPop.remove();
}

function chkPwd(str){
    var regPwd = /^.*(?=.{6,20})(?=.*[0-9])(?=.*[a-zA-Z]).*$/;
    //var regPwd =/^(?=.*[0-9])(?=.*[a-zA-Z])([a-zA-Z0-9]+)$/;
    if(regPwd.test(str)){
     // LaiKW - 20211202 - ITGC Password configuration, special character required for new passwords
        var format = /[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]+/;
        if(format.test(str)) {
            return true;
        } else {
            Common.alert("Special character is required.");
            return false;
        }
    } else {
        Common.alert("6 ~ 20 digits in English and numbers");
        return false;
    }
}

function chkDate(str){
    var regStr = /^(0?[1-9]|[12]\d|3[01])[\/](0?[1-9]|1[0-2])[\/](19|20)\d{2}$/;
    if(regStr.test(str)){
        return true;
    }

    return false;
}

function chkEmail(str){
    var regStr = /^([\w-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([\w-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$/;
    if(regStr.test(str) && str.indexOf("@coway.com.my") > -1){
        return true;
    }

    return false;
}



function convDateForm(date){
    var parts = date.split("/");
    return new Date(parts[2], parts[1] - 1, parts[0]);
}


function fn_userTypeCodesearchByEdit(){
    Common.ajax(
            "GET",
            "/common/userManagement/selectUserTypeList.do",
            "",
            function(data, textStatus, jqXHR){ // Success
                for(var idx=0; idx < data.length ; idx++){
                    $("#userTypeId").append("<option value='"+data[idx].codeId+"'>"+data[idx].codeName+"</option>");
                }
            },
            function(jqXHR, textStatus, errorThrown){ // Error
                alert("Fail : " + jqXHR.responseJSON.message);
            },
            {async:false , isShowLoader : false}
    )
};

function fn_brnchCodesearchByEdit(){
    Common.ajax(
            "GET",
            "/common/userManagement/selectBranchList.do",
            "",
            function(data, textStatus, jqXHR){ // Success
                for(var idx=0; idx < data.length ; idx++){
                    $("#userEditForm #userBrnchId").append("<option value='"+data[idx].brnchId+"'>"+data[idx].name+"</option>");
                }
            },
            function(jqXHR, textStatus, errorThrown){ // Error
                alert("Fail : " + jqXHR.responseJSON.message);
            },
            {async:false , isShowLoader : false}
    )
};

function fn_departmentCodesearchByEdit(divCd){
    Common.ajax(
            "GET",
            "/common/userManagement/selectDeptList.do",
            "divCd="+divCd,
            function(data, textStatus, jqXHR){ // Success
                if(divCd == "2"){
                    for(var idx=0; idx < data.length ; idx++){
                        $("#userEditForm #userDeptId1").append("<option value='"+data[idx].deptId+"'>"+data[idx].deptName+"</option>");
                    }
                }else{
                    for(var idx=0; idx < data.length ; idx++){
                        $("#userEditForm #userDeptId").append("<option value='"+data[idx].deptId+"'>"+data[idx].deptName+"</option>");
                    }
                }

            },
            function(jqXHR, textStatus, errorThrown){ // Error
                alert("Fail : " + jqXHR.responseJSON.message);
            },
            {async:false , isShowLoader : false}
    )
};

function fn_roleCodesearchByEdit(roleLev,parentRole){

    if(roleLev == "2" && parentRole == ""){
        $("#roleEditForm select[id='roleId2'] option").remove();
        $("#roleEditForm select[id='roleId3'] option").remove();


        $("#roleEditForm #roleId2").append("<option value=''>- Select -</option>");
        $("#roleEditForm #roleId3").append("<option value=''>- Select -</option>");
        return;
     }

     if(roleLev == "3" && parentRole == ""){
        $("#roleEditForm select[id='roleId3'] option").remove();
        $("#roleEditForm #roleId3").append("<option value=''>- Select -</option>");
        return;
     }
     Common.ajax(
                "GET",
                "/common/userManagement/selectRoleList.do",
                "roleLev="+roleLev+"&parentRole="+parentRole,
                function(data, textStatus, jqXHR){ // Success
                    if(roleLev == "1"){
                        $("#roleEditForm select[id='roleId1'] option").remove();
                        $("#roleEditForm select[id='roleId2'] option").remove();
                        $("#roleEditForm select[id='roleId3'] option").remove();

                        $("#roleEditForm #roleId1").append("<option value=''>- Select -</option>");
                        $("#roleEditForm #roleId2").append("<option value=''>- Select -</option>");
                        $("#roleEditForm #roleId3").append("<option value=''>- Select -</option>");

                        for(var idx=0; idx < data.length ; idx++){
                            $("#roleEditForm #roleId1").append("<option value='"+data[idx].roleId+"'>"+data[idx].roleCode+"</option>");
                        }

                    }else if(roleLev == "2"){

                        $("#roleEditForm select[id='roleId2'] option").remove();
                        $("#roleEditForm select[id='roleId3'] option").remove();

                        $("#roleEditForm #roleId2").append("<option value=''>- Select -</option>");
                        $("#roleEditForm #roleId3").append("<option value=''>- Select -</option>");

                        for(var idx=0; idx < data.length ; idx++){
                            $("#roleEditForm #roleId2").append("<option value='"+data[idx].roleId+"'>"+data[idx].roleCode+"</option>");
                        }
                    }else{

                        $("#roleEditForm select[id='roleId3'] option").remove();

                        $("#roleEditForm #roleId3").append("<option value=''>- Select -</option>");

                        for(var idx=0; idx < data.length ; idx++){
                            $("#roleEditForm #roleId3").append("<option value='"+data[idx].roleId+"'>"+data[idx].roleCode+"</option>");
                        }
                    }

                },
                function(jqXHR, textStatus, errorThrown){ // Error
                    alert("Fail : " + jqXHR.responseJSON.message);
                },
                {async:false , isShowLoader : false}
        )
};

function fn_userRoleList(_userId){
    Common.ajax(
            "GET",
            "/common/userManagement/selectUserRoleList.do",
            "userId="+_userId,
            function(data, textStatus, jqXHR){ // Success
            	userRoleData = data;
            },
            function(jqXHR, textStatus, errorThrown){ // Error
                alert("Fail : " + jqXHR.responseJSON.message);
            },
            {async:false , isShowLoader : false}
    )
};

function fn_openMemberPopup(){
    var popUpObj = Common.popupDiv
    (
         "/common/userManagement/memberCodePop.do"
         , ""
         , null
         , "false"
         , "memberCodePop"
    );
}

function popupMemberCallback(result){
	$("#hrCode").val(result.memCode);
};

function fn_editUser(){

    if(popDivCd == "branch"){
	    if($("#userEditForm #userBrnchId").val() == "" || typeof($("#userEditForm #userBrnchId").val()) == "undefined"){
	        Common.alert("<spring:message code='sys.msg.necessary' arguments='Branch' htmlEscape='false'/>");
	        return;
	    }
    }else{
    	if($("#userEditForm #userTypeId").val() == "" || typeof($("#userEditForm #userTypeId").val()) == "undefined"){
            Common.alert("<spring:message code='sys.msg.necessary' arguments='User Type' htmlEscape='false'/>");
            return;
        }
        if($("#userEditForm #userFullName").val() == "" || typeof($("#userEditForm #userFullName").val()) == "undefined"){
            Common.alert("<spring:message code='sys.msg.necessary' arguments='Full Name' htmlEscape='false'/>");
            return;
        }
        if($("#userEditForm #userBrnchId").val() == "" || typeof($("#userEditForm #userBrnchId").val()) == "undefined"){
            Common.alert("<spring:message code='sys.msg.necessary' arguments='Branch' htmlEscape='false'/>");
            return;
        }
        if($("#userEditForm #userDeptId").val() == "" || typeof($("#userEditForm #userDeptId").val()) == "undefined"){
            Common.alert("<spring:message code='sys.msg.necessary' arguments='Department' htmlEscape='false'/>");
            return;
        }
        if($("#userEditForm #userValIdFrom").val() == "" || typeof($("#userEditForm #userValIdFrom").val()) == "undefined"){
            Common.alert("<spring:message code='sys.msg.necessary' arguments='Valid Date From' htmlEscape='false'/>");
            return;
        }
        if($("#userEditForm #userValIdTo").val() == "" || typeof($("#userEditForm #userValIdTo").val()) == "undefined"){
            Common.alert("<spring:message code='sys.msg.necessary' arguments='Valid Date To' htmlEscape='false'/>");
            return;
        }

        if(chkEmail($("#userEditForm #userEmail").val()) == false){
            Common.alert("User Email is not email form");
            return;
        }

        if(chkDate($("#userEditForm #userValIdFrom").val()) == false){
            Common.alert("Valid_From_Date is not date form");
            return;
        }

        if(chkDate($("#userEditForm #userValIdTo").val()) == false){
            Common.alert("Valid_To_Date is not date form");
            return;
        }

        if(convDateForm($("#userEditForm #userValIdFrom").val()) > convDateForm($("#userEditForm #userValIdTo").val())){
            Common.alert("<spring:message code='commission.alert.dateGreaterCheck' htmlEscape='false'/>");
            return;
        }

        if(chkDate($("#userEditForm #userDtJoin").val()) == false){
            Common.alert("User Join Date is not date form");
            return;
        }

    }
    var userIsExtrnl = 0;
    var userIsPartTm = 0;

    if($("#userEditForm input[id=userIsPartTm]").is(":checked")) userIsPartTm = 1;
    if($("#userEditForm input[id=userIsExtrnl]").is(":checked")) userIsExtrnl = 1;

    var saveParam = "";

    if(popDivCd == "branch"){
    	var userName = $("#userEditForm #userName").text();
    	saveParam = "userId="+$("#userEditForm #userId").val()+"&userBrnchId="+$("#userEditForm #userBrnchId").val() + "&userName=" + encodeURIComponent(userName) + "&hrCode=" + $("#userEditForm #hrCode").val() ;
    }else{
    	var userName = $("#userEditForm #userName").text();
    	saveParam = $("#userEditForm").serialize() + "&userName=" + encodeURIComponent(userName) + "&userIsPartTm="+userIsPartTm+"&userIsExtrnl="+userIsExtrnl + "&hrCode=" +  $("#userEditForm #hrCode").val() ;
    }
//debugger;

    Common.confirm("<spring:message code='sys.common.alert.save'/>",function(){

    	console.log($("#userEditForm #userName").text());
    	console.log($("#userEditForm #hrCode").text());
    	console.log(saveParam);

        Common.ajax(
                "GET",
                "/common/userManagement/editUserManagementList.do",
                saveParam,
                function(data, textStatus, jqXHR){ // Success
                    Common.alert("<spring:message code='sys.msg.success' htmlEscape='false'/>",removePopupCallback);
                },
                function(jqXHR, textStatus, errorThrown){ // Error
                    Common.alert("Fail : " + jqXHR.responseJSON.message);
                }
        )
    });
};


function fn_deactiveUser(){

	var _userStatusId =  $("#userEditForm #userStusId").val();
	if(_userStatusId == "1"){
		_userStatusId = "8";
	}else{
		_userStatusId = "1";
	}
    Common.confirm("<spring:message code='sys.common.alert.save'/>",function(){
        Common.ajax(
                "GET",
                "/common/userManagement/editUserManagementList.do",
                "userId="+$("#userEditForm #userId").val()+"&userStusId="+_userStatusId+ "&hrCode=" + $("#userEditForm #hrCode").val(), //deactive status is 8, active status is 1
                function(data, textStatus, jqXHR){ // Success
                    Common.alert("<spring:message code='sys.msg.success' htmlEscape='false'/>",removePopupCallback);
                },
                function(jqXHR, textStatus, errorThrown){ // Error
                    Common.alert("Fail : " + jqXHR.responseJSON.message);
                }
        )
    });
};

function fn_updateUserPasswd(){

    if($("#passwdEditForm #userPasswd").val() == "" || typeof($("#passwdEditForm #userPasswd").val()) == "undefined"){
        Common.alert("<spring:message code='sys.msg.necessary' arguments='Password' htmlEscape='false'/>");
        return;
    }
    if($("#passwdEditForm #userPasswdConfirm").val() == "" || typeof($("#passwdEditForm #userPasswdConfirm").val()) == "undefined"){
        Common.alert("<spring:message code='sys.msg.necessary' arguments='Re-Key Password' htmlEscape='false'/>");
        return;
    }

    if($("#passwdEditForm #userPasswd").val() !=  $("#passwdEditForm #userPasswdConfirm").val()){
        Common.alert("Password and Password Confirm is not equal to each other.");
        return;
    }

    if(chkPwd($("#passwdEditForm #userPasswd").val()) == false){
        return;
    }

    Common.confirm("<spring:message code='sys.common.alert.save'/>",function(){
        Common.ajax(
                "GET",
                "/common/userManagement/editUserManagementList.do",
                //UserPasswdLastUpdDt doesn't matter anything for updating
                //"userId="+$("#userEditForm #userId").val()+"&userPasswd="+$("#passwdEditForm #userPasswdConfirm").val()+"&userPasswdLastUpdDt=today"+"&userDfltPassWd="+$("#passwdEditForm #userPasswdConfirm").val() ,
                {"userId" : $("#userEditForm #userId").val(),
                	"userName" : $("#userEditForm #userName").text(),
                	"userType" : $("#userEditForm #userTypeId").val(),
                    "userPasswd" : $("#passwdEditForm #userPasswdConfirm").val(),
                    "userDfltPassWd" : $("#passwdEditForm #userPasswdConfirm").val()} ,
                function(data, textStatus, jqXHR){ // Success
                    	if(data.code == '99'){
                    		Common.alert(data.message,removePopupCallback);
                    	}else{
                    		Common.alert("<spring:message code='sys.msg.success' htmlEscape='false'/>",removePopupCallback);
                    	}

                },
                function(jqXHR, textStatus, errorThrown){ // Error
                    Common.alert("Fail : " + jqXHR.responseJSON.message);
                }
        )
    });
};


function fn_updateUserRole(){
    if($("#roleEditForm #roleId1").val() == "" || typeof($("#roleEditForm #roleId1").val()) == "undefined"){
        Common.alert("<spring:message code='sys.msg.necessary' arguments='Role Id 1' htmlEscape='false'/>");
        return;
    }
    if($("#roleEditForm #roleId2").val() == "" || typeof($("#roleEditForm #roleId2").val()) == "undefined"){
        Common.alert("<spring:message code='sys.msg.necessary' arguments='Role Id 2' htmlEscape='false'/>");
        return;
    }
    if($("#roleEditForm #roleId3").val() == "" || typeof($("#roleEditForm #roleId3").val()) == "undefined"){
        Common.alert("<spring:message code='sys.msg.necessary' arguments='Role Id 3' htmlEscape='false'/>");
        return;
    }

    Common.confirm("<spring:message code='sys.common.alert.save'/>",function(){
        Common.ajax(
                "GET",
                "/common/userManagement/saveUserRoleList.do",
                "userId="+$("#userEditForm #userId").val()+"&roleId="+$("#roleEditForm #roleId3").val(), //deactive status is 8
                function(data, textStatus, jqXHR){ // Success
                    Common.alert("<spring:message code='sys.msg.success' htmlEscape='false'/>",removePopupCallback);
                },
                function(jqXHR, textStatus, errorThrown){ // Error
                    Common.alert("Fail : " + jqXHR.responseJSON.message);
                }
        )
    });
};

function fn_searchUser(_userId){
    Common.ajax(
            "GET",
            "/common/userManagement/selectUserList.do",
            "userIdForEdit="+_userId,
            function(data, textStatus, jqXHR){ // Success
                //debugger;
                $("#userEditForm #userId").val(data[0].userId);
                $("#userEditForm #userStusId").val(data[0].userStusId);

                if(data[0].userIsPartTm == "1" ){
                	$("#userEditForm input[id=userIsPartTm]").attr("checked",true);
                }
                if(data[0].userIsExtrnl == "1" ){
                    $("#userEditForm input[id=userIsExtrnl]").attr("checked",true);
                }
                $("#userEditForm #userStusNm").text(data[0].userStusNm);
                $("#userEditForm #userName").text(data[0].userName);

                $("#userEditForm #userTypeId").val(data[0].userTypeId);
                $("#userEditForm #userFullName").val(data[0].userFullName);
                $("#userEditForm #userBrnchId").val(data[0].brnch);
                $("#userEditForm #userDeptId").val(data[0].userDeptCd);
                $("#userEditForm #userValIdFrom").val(data[0].userValIdFrom);
                $("#userEditForm #userValIdTo").val(data[0].userValIdTo);
                $("#userEditForm #userDeptId1").val(data[0].userDeptId1);
                $("#userEditForm #userEmail").val(data[0].userEmail);
                $("#userEditForm #userDtJoin").val(data[0].userDtJoin);
                $("#userEditForm #userNric").val(data[0].userNric);
                $("#userEditForm #userExtNo").val(data[0].userExtNo);
                $("#userEditForm #userWorkNo").val(data[0].userWorkNo);
                $("#userEditForm #userMobileNo").val(data[0].userMobileNo);

                $("#userEditForm #callcenterUseYn").val(data[0].callcenterUseYn);
                $("#userEditForm #hrCode").val(data[0].hrCode);

                if($("#userEditForm #userStusId").val() == "8"){
                    $("#roleEditForm").find("input, textarea, button, select").attr("disabled",true);
                    $("#userEditForm").find("input, textarea, button, select").attr("disabled",true);
                    $("#passwdEditForm").find("input, textarea, button, select").attr("disabled",true);

                    $("#btnSave").attr("style","display:none;");
                    $("#btnRoleUpdate").attr("style","display:none;");
                    $("#btnPasswd").attr("style","display:none;");

                    $("#btnDeactive a").text("activate");
                }
            },
            function(jqXHR, textStatus, errorThrown){ // Error
                alert("Fail : " + jqXHR.responseJSON.message);
            }
    )
};

/**************************** Transaction End    ********************************/
/**************************** Grid setting Start  ******************************/
/**************************** Program Init Start *******************************/
$(document).ready(function(){
    // AUIGrid 그리드를 생성
    //start progress icon
    Common.showLoader();

    fn_userTypeCodesearchByEdit();
    fn_brnchCodesearchByEdit("1");
    fn_departmentCodesearchByEdit("1");
    fn_departmentCodesearchByEdit("2");

    var selectedRow = AUIGrid.getSelectedItems(grdUser);
    fn_searchUser(selectedRow[0].item.userId);
    fn_userRoleList(selectedRow[0].item.userId);

    fn_roleCodesearchByEdit("1","");
    if(userRoleData.length > 0){
    	$("#roleEditForm #roleId1").val(userRoleData[0].roleId);

        fn_roleCodesearchByEdit("2",userRoleData[0].roleId);
        $("#roleEditForm #roleId2").val(userRoleData[1].roleId);

        fn_roleCodesearchByEdit("3",userRoleData[1].roleId);
        $("#roleEditForm #roleId3").val(userRoleData[2].roleId);
    }
    //end progress icon
    Common.removeLoader();

    if(popDivCd == "branch"){
    	$("#roleEditForm").find("input, textarea, button, select").attr("disabled",true);
        $("#userEditForm").find("input, textarea, button, select").attr("disabled",true);
        $("#passwdEditForm").find("input, textarea, button, select").attr("disabled",true);

        $("#btnDeactive").attr("style","display:none;");
        $("#btnRoleUpdate").attr("style","display:none;");
        $("#btnPasswd").attr("style","display:none;");

        $("#userBrnchId").attr("disabled",false);
    }

});
/****************************Program Init End********************************/
</script>
<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->
<header class="pop_header"><!-- pop_header start -->
<h1>User Management - Edit User</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<section class="tap_wrap"><!-- tap_wrap start -->
<ul class="tap_type1">
    <li><a href="#" class="on">User Info</a></li>
    <li><a href="#">User Role</a></li>
    <li><a href="#">Reset Password</a></li>
</ul>

<article class="tap_area"><!-- tap_area start -->
<form id="userEditForm" action="#" method="GET">

<!-- hidden -->
<input id="userId" type="text" name="userId" style="display:none;" title="" placeholder="" class="" />
<input id="userStusId" type="text" name="userStusId" style="display:none;" title="" placeholder="" class="" />
<input id="hrCode" type="text" name="hrCode" style="display:none;" title="" placeholder="" class="" />

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:140px" />
    <col style="width:*" />
    <col style="width:190px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <td colspan="4">
    <label><input id="userIsPartTm" type="checkbox" name="userExtType" value="" /><span>Part-Timer</span></label>
    <label><input id="userIsExtrnl" type="checkbox" name="userExtType" value="" /><span>External User</span></label>
    </td>
</tr>
<tr>
    <th scope="row">Status</th>
    <td><span id="userStusNm" >text</span></td>
    <th scope="row">User Type</th>
    <td>
    <select id="userTypeId" name="userTypeId">
        <option value="">- Select -</option>
    </select>
    </td>
</tr>
<tr>
    <th scope="row">User Name<span class="must">*</span></th>
    <td><span id="userName" name="userName">text</span></td>
    <th scope="row">Full Name<span class="must">*</span></th>
    <td>
    <input id="userFullName" type="text" name="userFullName" title="" placeholder="Full Name" class="w100p" />
    </td>
</tr>
<tr>
    <th scope="row">Branch<span class="must">*</span></th>
    <td>
    <select id="userBrnchId" name="userBrnchId" class="w100p">
        <option value="">- Select -</option>
    </select>
    </td>
    <th scope="row">Department<span class="must">*</span></th>
    <td>
    <select id="userDeptId"  name="userDeptId" class="w100p">
        <option value="">- Select -</option>
    </select>
    </td>
</tr>
<tr>
    <th scope="row">Valid Date<span class="must">*</span></th>
    <td>

    <div class="date_set w100p"><!-- date_set start -->
    <p><input id="userValIdFrom" type="text" name="userValIdFrom" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
    <span>To</span>
    <p><input id="userValIdTo" type="text" name="userValIdTo" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
    </div><!-- date_set end -->

    </td>
    <th scope="row">Department(Call-Center Use)</th>
    <td>
    <select id="userDeptId1" name="userDeptId1" class="w100p">
        <option value="">- Empty -</option>
    </select>
    </td>
</tr>
<tr>
    <th scope="row">Email</th>
    <td>
    <input id="userEmail" type="text" name="userEmail" title="" placeholder="Email (Coway Email Only)" class="w100p" />
    </td>
    <th scope="row">Join Date</th>
    <td>
    <input id="userDtJoin" type="text" name="userDtJoin" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" />
    </td>
</tr>
<tr>
    <th scope="row">NRIC</th>
    <td>
    <input id="userNric" type="text" name="userNric" title="" placeholder="NRIC" class="w100p" />
    </td>
    <th scope="row">Extension No</th>
    <td>
    <input id="userExtNo" type="text" name="userExtNo" title="" placeholder="Extension No" class="w100p" />
    </td>
</tr>
<tr>
    <th scope="row">Contact (Work)</th>
    <td>
    <input id="userWorkNo" type="text" name="userWorkNo" title="" placeholder="Contact (Work)" class="w100p" />
    </td>
    <th scope="row">Contact (Mobile)</th>
    <td>
    <input id="userMobileNo" type="text" name="userMobileNo" title="" placeholder="Contact (Mobile)" class="w100p" />
    </td>
</tr>
<tr>
    <th scope="row">CallCenter</th>
    <td>
    <select id="callcenterUseYn" name="callcenterUseYn" class="w100p">
        <option value="N">No</option>
        <option value="Y">Yes</option>
    </select>
    <!-- <input id="callCenterYn" type="text" name=""callCenterYn"" title="" placeholder="CallCenter Use Y/N" class="w100p" maxlength="15" /> -->
    </td>
    <th scope="row">Member Code</th>
    <td>
    <input id="hrCode" type="text" name="hrCode" title="" placeholder="Member Code" class="w100p" maxlength="30"/>
    <a href="#" class="search_btn" onclick="javascript:fn_openMemberPopup()"><img src="/resources/images/common/normal_search.gif" alt="search"></a>
    </td>
</tr>
<tr>
    <td colspan="4"><p><span>* Compulsory Field ** Compulsory Field (Except part-timer & external user)</span></p></td>
</tr>
</tbody>
</table><!-- table end -->

<ul class="center_btns">
    <li><p id="btnSave" class="btn_blue2 big"><a onclick="fn_editUser()">Save</a></p></li>
    <li><p id="btnDeactive" class="btn_blue2 big"><a onclick="fn_deactiveUser()">Deactivate User</a></p></li>
</ul>
</form>
</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->
<form id="roleEditForm" action="#" method="GET">
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:140px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Role (Lvl 1)<span class="must">*</span></th>
    <td>
    <select id="roleId1" name="roleId1" class="w100p" onchange="fn_roleCodesearchByEdit('2',this.value)">
        <option value="">- Select -</option>
    </select>
    </td>
</tr>
<tr>
    <th scope="row">Role (Lvl 2)<span class="must">*</span></th>
    <td>
<select id="roleId2" name="roleId2" class="w100p" onchange="fn_roleCodesearchByEdit('3',this.value)">
        <option value="">- Select -</option>
    </select>
    </td>
</tr>
<tr>
    <th scope="row">Role (Lvl 3)<span class="must">*</span></th>
    <td>
    <select id="roleId3" name="roleId3" class="w100p">
        <option value="">- Select -</option>
    </select>
    </td>
</tr>
</tbody>
</table><!-- table end -->

<ul class="center_btns">
    <li><p id="btnRoleUpdate" class="btn_blue2 big"><a onclick="fn_updateUserRole()">Update User Role</a></p></li>
</ul>
</form>
</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->
<form id="passwdEditForm" action="#" method="GET">
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:140px" />
    <col style="width:*" />
    <col style="width:190px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Password<span class="must">*</span></th>
    <td><input id="userPasswd" type="password" name="userPasswd" title="" placeholder="" class="w100p" /></td>
    <th scope="row">Re-Key Password<span class="must">*</span></th>
    <td><input id="userPasswdConfirm" type="password" name="userPasswdConfirm" title="" placeholder="" class="w100p" /></td>
</tr>
</tbody>
</table><!-- table end -->

<ul class="center_btns">
    <li><p id="btnPasswd" class="btn_blue2 big"><a onclick="fn_updateUserPasswd()">Reset Password</a></p></li>
</ul>
</form>
</article><!-- tap_area end -->

</section><!-- tap_wrap end -->

</section><!-- pop_body end -->


</div><!-- popup_wrap end -->