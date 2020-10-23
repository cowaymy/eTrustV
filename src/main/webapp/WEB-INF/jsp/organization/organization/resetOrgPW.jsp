<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>


<script type="text/javaScript">

    $(document).ready(function() {
    });

    function chkPwd(str) {
        var regPwd = /^.*(?=.{6,20})(?=.*[0-9])(?=.*[a-zA-Z]).*$/;
        if(regPwd.test(str)){
            return true;
        }
        Common.alert("Password has to be alphanumeric and between 6 to 20 length.");
        return false;
    }

    function checkCnfmPwd() {
        var pw = $("#userPasswd").val();
        var cnfmPw = $("#userPasswdConfirm").val();

        if(cnfmPw != pw) {
            Common.alert("Incorrect Confirm Password!");
            $("#userPasswdConfirm").val("");
            return false;
        }

        return true;
    }

    function fn_updatePw() {
        console.log("fn_updatePw");

        var pw = $("#userPasswd").val();
        var cnfmPw = $("#userPasswdConfirm").val();

        if(!FormUtil.isEmpty(pw) && !FormUtil.isEmpty(cnfmPw)) {
            if(chkPwd(pw) && checkCnfmPwd()) {
                Common.ajax("POST", "/organization/updateOrgUserPW.do", $("#pwUpdForm").serializeJSON(), function(result) {
                    console.log(result);

                    if(result.code != "00") {
                        Common.alert("Password update failed!");
                    } else {
                        Common.alert("Successfully updated password.");
                        $("#popup_wrap").remove();
                    }
                });
            }
        } else {
            Common.alert("Password cannot be empty!");
            return false;
        }
    }

</script>

<div id="popup_wrap" class="popup_wrap size_mid"><!-- popup_wrap start -->
	<header class="pop_header"><!-- pop_header start -->
	<h1>Organization Member eTrust/Mobile Password</h1>
	<ul class="right_opt">
	    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
	</ul>
	</header><!-- pop_header end -->

	<section class="pop_body"><!-- pop_body start -->
		<form action="#" id="pwUpdForm" name="pwUpdForm">
		    <input type="hidden" id="memberID" name="memberID" value="${memberID}">
		    <input type="hidden" id="updUserId" name="updUserId" value="${updUserId}">
		    <table class="type1">
		        <caption>table</caption>
		        <colgroup>
		            <col style="width: 200px" />
		            <col style="width: *" />
		        </colgroup>

		        <tbody>
		            <tr>
		                <th scope="row">New Password</th>
		                <td>
		                    <input id="userPasswd" type="password" name="userPasswd" title="" placeholder="" class="w100p" />
		                </td>
		            </tr>
		            <tr>
                        <th scope="row">Confirm Password</th>
                        <td>
                            <input id="userPasswdConfirm" type="password" name="userPasswdConfirm" title="" placeholder="" class="w100p" />
                        </td>
                    </tr>
		        </tbody>
		    </table>
		</form>
		<ul class="center_btns">
		    <li><p class="btn_blue2 big"><a href=" javascript: fn_updatePw();" >SAVE</a></p></li>
		</ul>
	</section>
</div><!-- popup_wrap end -->