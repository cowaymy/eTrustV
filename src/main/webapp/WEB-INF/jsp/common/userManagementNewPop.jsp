<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javaScript">
/********************************Global Variable Start***********************************/
/********************************Global Variable End************************************/
/********************************Function  Start***************************************
 *
 */
function removePopupCallback(){
	userManagementNewPop.remove();
}

function chkPwd(str){
    var regPwd = /^.*(?=.{6,20})(?=.*[0-9])(?=.*[a-zA-Z]).*$/;
    if(regPwd.test(str)){
        return true;
    }

    return false;
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


/****************************Function  End***********************************
 *
 */
/****************************Transaction Start********************************/

function fn_userTypeCodesearch(){
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
            }
    )
};

/* function fn_brnchCodesearch(){
    Common.ajax(
            "GET",
            "/common/userManagement/selectBranchList.do",
            "",
            function(data, textStatus, jqXHR){ // Success
                for(var idx=0; idx < data.length ; idx++){
                    $("#saveForm #userBrnchId").append("<option value='"+data[idx].brnchId+"'>"+data[idx].name+"</option>");
                }
            },
            function(jqXHR, textStatus, errorThrown){ // Error
                alert("Fail : " + jqXHR.responseJSON.message);
            }
    )
}; */

/* function fn_departmentCodesearch(divCd){
    Common.ajax(
            "GET",
            "/common/userManagement/selectDeptList.do",
            "divCd="+divCd,
            function(data, textStatus, jqXHR){ // Success
            	if(divCd == "2"){
            		for(var idx=0; idx < data.length ; idx++){
                        $("#saveForm #userDeptId1").append("<option value='"+data[idx].deptId+"'>"+data[idx].deptName+"</option>");
                    }
            	}else{
            		for(var idx=0; idx < data.length ; idx++){
                        $("#saveForm #userDeptId").append("<option value='"+data[idx].deptId+"'>"+data[idx].deptName+"</option>");
                    }
            	}

            },
            function(jqXHR, textStatus, errorThrown){ // Error
                alert("Fail : " + jqXHR.responseJSON.message);
            }
    )
}; */

function fn_roleCodesearch(roleLev,parentRole){
    if(roleLev == "2" && parentRole == ""){
        $("#saveForm select[id='roleId2'] option").remove();
        $("#saveForm select[id='roleId3'] option").remove();


        $("#saveForm #roleId2").append("<option value=''>- Select -</option>");
        $("#saveForm #roleId3").append("<option value=''>- Select -</option>");
        return;
     }

     if(roleLev == "3" && parentRole == ""){
        $("#saveForm select[id='roleId3'] option").remove();
        $("#saveForm #roleId3").append("<option value=''>- Select -</option>");
        return;
     }
	 Common.ajax(
	            "GET",
	            "/common/userManagement/selectRoleList.do",
	            "roleLev="+roleLev+"&parentRole="+parentRole,
	            function(data, textStatus, jqXHR){ // Success
	                if(roleLev == "1"){
	                	$("#saveForm select[id='roleId1'] option").remove();
	                	$("#saveForm select[id='roleId2'] option").remove();
                        $("#saveForm select[id='roleId3'] option").remove();

                        $("#saveForm #roleId1").append("<option value=''>- Select -</option>");
                        $("#saveForm #roleId2").append("<option value=''>- Select -</option>");
                        $("#saveForm #roleId3").append("<option value=''>- Select -</option>");

	                	for(var idx=0; idx < data.length ; idx++){
	                        $("#saveForm #roleId1").append("<option value='"+data[idx].roleId+"'>"+data[idx].roleCode+"</option>");
	                    }

	                }else if(roleLev == "2"){

                        $("#saveForm select[id='roleId2'] option").remove();
                        $("#saveForm select[id='roleId3'] option").remove();

                        $("#saveForm #roleId2").append("<option value=''>- Select -</option>");
                        $("#saveForm #roleId3").append("<option value=''>- Select -</option>");

                        for(var idx=0; idx < data.length ; idx++){
                            $("#saveForm #roleId2").append("<option value='"+data[idx].roleId+"'>"+data[idx].roleCode+"</option>");
                        }
                    }else{

                        $("#saveForm select[id='roleId3'] option").remove();

                        $("#saveForm #roleId3").append("<option value=''>- Select -</option>");

	                    for(var idx=0; idx < data.length ; idx++){
	                        $("#saveForm #roleId3").append("<option value='"+data[idx].roleId+"'>"+data[idx].roleCode+"</option>");
	                    }
	                }

	            },
	            function(jqXHR, textStatus, errorThrown){ // Error
	                alert("Fail : " + jqXHR.responseJSON.message);
	            },
	            {async:false , isShowLoader : false}
	    )
};


function fn_save(){

    if($("#saveForm #userTypeId").val() == "" || typeof($("#saveForm #userTypeId").val()) == "undefined"){
        Common.alert("<spring:message code='sys.msg.necessary' arguments='User Type' htmlEscape='false'/>");
        return;
    }
    if($("#saveForm #userName").val() == "" || typeof($("#saveForm #userName").val()) == "undefined"){
        Common.alert("<spring:message code='sys.msg.necessary' arguments='User Name' htmlEscape='false'/>");
        return;
    }
    if($("#saveForm #userFullName").val() == "" || typeof($("#saveForm #userFullName").val()) == "undefined"){
        Common.alert("<spring:message code='sys.msg.necessary' arguments='Full Name' htmlEscape='false'/>");
        return;
    }
    if($("#saveForm #userPasswd").val() == "" || typeof($("#saveForm #userPasswd").val()) == "undefined"){
        Common.alert("<spring:message code='sys.msg.necessary' arguments='Password' htmlEscape='false'/>");
        return;
    }
    if($("#saveForm #userPasswdConfirm").val() == "" || typeof($("#saveForm #userPasswdConfirm").val()) == "undefined"){
        Common.alert("<spring:message code='sys.msg.necessary' arguments='Re-Key Password' htmlEscape='false'/>");
        return;
    }
    if($("#saveForm #userBrnchId").val() == "" || typeof($("#saveForm #userBrnchId").val()) == "undefined"){
        Common.alert("<spring:message code='sys.msg.necessary' arguments='Branch' htmlEscape='false'/>");
        return;
    }
    if($("#saveForm #userDeptId").val() == "" || typeof($("#saveForm #userDeptId").val()) == "undefined"){
        Common.alert("<spring:message code='sys.msg.necessary' arguments='Department' htmlEscape='false'/>");
        return;
    }
    if($("#saveForm #userValIdFrom").val() == "" || typeof($("#saveForm #userValIdFrom").val()) == "undefined"){
        Common.alert("<spring:message code='sys.msg.necessary' arguments='Valid Date From' htmlEscape='false'/>");
        return;
    }
    if($("#saveForm #userValIdTo").val() == "" || typeof($("#saveForm #userValIdTo").val()) == "undefined"){
        Common.alert("<spring:message code='sys.msg.necessary' arguments='Valid Date To' htmlEscape='false'/>");
        return;
    }
    if($("#saveForm #userEmail").val() == "" || typeof($("#saveForm #userEmail").val()) == "undefined"){
        Common.alert("<spring:message code='sys.msg.necessary' arguments='Valid Date To' htmlEscape='false'/>");
        return;
    }

    if($("#saveForm #roleId1").val() == "" || typeof($("#saveForm #roleId1").val()) == "undefined"){
        Common.alert("<spring:message code='sys.msg.necessary' arguments='Role Id 1' htmlEscape='false'/>");
        return;
    }
    if($("#saveForm #roleId2").val() == "" || typeof($("#saveForm #roleId2").val()) == "undefined"){
        Common.alert("<spring:message code='sys.msg.necessary' arguments='Role Id 2' htmlEscape='false'/>");
        return;
    }
    if($("#saveForm #roleId3").val() == "" || typeof($("#saveForm #roleId3").val()) == "undefined"){
        Common.alert("<spring:message code='sys.msg.necessary' arguments='Role Id 3' htmlEscape='false'/>");
        return;
    }

    if(chkEmail($("#saveForm #userEmail").val()) == false){
        Common.alert("User Email is not email form");
        return;
    }

    if($("#saveForm #userPasswd").val() !=  $("#saveForm #userPasswdConfirm").val()){
        Common.alert("Password and Password Confirm is not equal to each other.");
        return;
    }

    if(chkPwd($("#saveForm #userPasswd").val()) == false){
    	Common.alert("6 ~ 20 digits in English and numbers");
        return;
    }

    if(chkDate($("#saveForm #userValIdFrom").val()) == false){
        Common.alert("Valid_From_Date is not date form");
        return;
    }

    if(chkDate($("#saveForm #userValIdTo").val()) == false){
        Common.alert("Valid_To_Date is not date form");
        return;
    }

    if(convDateForm($("#saveForm #userValIdFrom").val()) > convDateForm($("#saveForm #userValIdTo").val())){
       	Common.alert("<spring:message code='commission.alert.dateGreaterCheck' htmlEscape='false'/>");
       	return;
    }

    if(chkDate($("#saveForm #userDtJoin").val()) == false){
        Common.alert("User Join Date is not date form");
        return;
    }

    var userIsExtrnl = 0;
    var userIsPartTm = 0;
    var userIsCallCenter = N;

    if($("#saveForm input[id=userIsPartTm]").is(":checked")) userIsPartTm = 1;
    if($("#saveForm input[id=userIsExtrnl]").is(":checked")) userIsExtrnl = 1;
    if($("#saveForm input[id=userIsCallCenter]").is(":checked")) userIsCallCenter = Y;

    Common.confirm("<spring:message code='sys.common.alert.save'/>",function(){
        Common.ajax(
                "GET",
                "/common/userManagement/saveUserManagementList.do",
                $("#saveForm").serialize()+"&userIsPartTm="+userIsPartTm+"&userIsExtrnl="+userIsExtrnl+"&userIsCallCenter="+userIsCallCenter+"&userStusId=1"+"&roleId="+$("#saveForm #roleId3").val(), //Init status is 1
                function(data, textStatus, jqXHR){ // Success
                    Common.alert("<spring:message code='sys.msg.success' htmlEscape='false'/>",removePopupCallback);
                },
                function(jqXHR, textStatus, errorThrown){ // Error
                    Common.alert("Fail : " + jqXHR.responseJSON.message);
                }
        )
    });
};

function onClickSelectMyMenuPop(){
	mymenuPopSelect($("#select_myMenu option:selected").val());
}
/**************************** Transaction End    ********************************/
/**************************** Grid setting Start  ******************************/
/**************************** Program Init Start *******************************/
$(document).ready(function(){
    // AUIGrid 그리드를 생성
	fn_userTypeCodesearch();
	//fn_brnchCodesearch("1");
	//fn_departmentCodesearch("1");
	//fn_departmentCodesearch("2");
	   $("#userName_add").focusout(function(){
        Common.ajax("GET", "/common/userManagement/selectUserNameInfoList.do",   { userName :  $("#userName_add").val() }  , function(result) {
           console.log("selectUserNameInfoList >>> .");
           console.log(  JSON.stringify(result));
           
           if(result.length>0){
                $("#userBrnchId_add").val(result[0].branch)
                //$("#Installation").val(result[0].department)
           }
         
       }); 
        
    }); 
	   
	fn_roleCodesearch("1","");
	
});
/****************************Program Init End********************************/
</script>
<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>User Management - Add New User</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->
<form id="saveForm" action="#" method="GET">
<aside class="title_line"><!-- title_line start -->
<h2>User Information</h2>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:140px" />
    <col style="width:*" />
    <col style="width:170px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">User Type<span class="must">*</span></th>
    <td colspan="3">
    <select id="userTypeId" name="userTypeId">
        <option value="">- Select -</option>
    </select>
    <label><input id="userIsPartTm" type="checkbox" name="userExtType" value=""/><span>Part-Timer</span></label>
    <label><input id="userIsExtrnl" type="checkbox" name="userExtType" value="" /><span>External User</span></label>
    <label><input id="userIsCallCenter" type="checkbox" name="userExtType" value="" /><span>Call Center User</span></label>
    </td>
</tr>
<tr>
    <th scope="row">User Name<span class="must">*</span></th>
    <td>
    <input id="userName_add" type="text" name="userName_add" title="" placeholder="User Name" class="w100p" maxlength="15" />
    </td>
    <th scope="row">Full Name<span class="must">*</span></th>
    <td>
    <input id="userFullName" type="text" name="userFullName" title="" placeholder="Full Name" class="w100p" maxlength="50"/>
    </td>
</tr>
<tr>
    <th scope="row">Password<span class="must">*</span></th>
    <td>
    <input id="userPasswd" type="password" name="userPasswd" title="" placeholder="" class="w100p" />
    </td>
    <th scope="row">Re-Key Password<span class="must">*</span></th>
    <td>
    <input id="userPasswdConfirm" type="password" name="userPasswdConfirm" title="" placeholder="" class="w100p" />
    </td>
</tr>
<tr>
    <th scope="row">Branch</th>
    <td>
    <!-- <select id="userBrnchId" name="userBrnchId" class="readonly">
        <option value="">- Select -</option>
    </select>-->
        <input type="text" title="" id="userBrnchId_add" name="userBrnchId_add" placeholder="" class="readonly" style="width: 157px; "/>
    </td>
    <th scope="row">Department</th>
    <td>
    <!-- <select id="userDeptId"  name="userDeptId" class="readonly">
        <option value="">- Select -</option>
    </select> -->
        <input type="text" title="" id="userDeptId" name="userDeptId" placeholder="" class="readonly" style="width: 157px; "/>
    </td>
</tr>
<tr>
    <th scope="row">Valid Date<span class="must">*</span></th>
    <td>

    <div class="date_set"><!-- date_set start -->
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
    <th scope="row">Email<span class="must">*</span></th>
    <td>
    <input id="userEmail" type="text" name="userEmail" title="" placeholder="Email (Coway Email Only)" class="w100p" maxlength="50"/>
    </td>
    <th scope="row">Join Date</th>
    <td>
    <input id="userDtJoin" type="text" name="userDtJoin" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" />
    </td>
</tr>
<tr>
    <th scope="row">NRIC</th>
    <td>
    <input id="userNric" type="text" name="userNric" title="" placeholder="NRIC" class="w100p" maxlength="20" />
    </td>
    <th scope="row">Extension No</th>
    <td>
    <input id="userExtNo" type="text" name="userExtNo" title="" placeholder="Extension No" class="w100p" maxlength="10"/>
    </td>
</tr>
<tr>
    <th scope="row">Contact (Work)</th>
    <td>
    <input id="userWorkNo" type="text" name="userWorkNo" title="" placeholder="Contact (Work)" class="w100p" maxlength="15" />
    </td>
    <th scope="row">Contact (Mobile)</th>
    <td>
    <input id="userMobileNo" type="text" name="userMobileNo" title="" placeholder="Contact (Mobile)" class="w100p" maxlength="15"/>
    </td>
</tr>
<tr>
    <td colspan="4" class="col_all">
    <span>* Compulsory Field ** Compulsory Field (Except part-timer & external user)</span>
    </td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h2>User Role Information</h2>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Role (Lvl 1)<span class="must">*</span></th>
    <td>
    <select id="roleId1" name="roleId1" class="w100p" onchange="fn_roleCodesearch('2',this.value)">
        <option value="">- Select -</option>
    </select>
    </td>
</tr>
<tr>
    <th scope="row">Role (Lvl 2)<span class="must">*</span></th>
    <td>
    <select id="roleId2" name="roleId2" class="w100p" onchange="fn_roleCodesearch('3',this.value)">
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
    <li><p class="btn_blue2 big"><a onclick="fn_save()">SAVE</a></p></li>
</ul>
</form>
</section><!-- pop_body end -->

</div><!-- popup_wrap end -->