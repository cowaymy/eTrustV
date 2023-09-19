<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<script type="text/javascript">


    async function fn_requestOTP(){
    	let response = await fetch("/test/requestOTP.do?" + $("#userSettingForm").serialize(),{ method : 'POST'});

    	if (response.status === 200) {
            let data = await response.json();

            if(data.code != "00")
            	return Common.alert("User Account or email not exist in the system");


            Common.alert("OTP : " + data.data + ". Valid for 1 min.<br/>Do not share it with anyone."
            ,function(){
            	$("#otpDisplay, #confirmOTP").show();
                $("#requestOTP").hide();
                $("#userName, #email").prop("readonly", true).addClass("readonly");
            });

        } else {
            Common.alert("An error has occured");
        }
    }

    async function fn_confirmOTP(){
        let response = await fetch("/test/confirmOTP.do?" + $("#userSettingForm").serialize(),{method : 'POST'});

        if (response.status === 200) {
            let data = await response.json();
            let message = data.code == '00' ? "Correct OTP. " : "Invalid OTP. "

            Common.alert(message);
        } else {
        	Common.alert("An error has occured");
        }
    }

    </script>


<div id="popup_wrap" class="popup_wrap size_small"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>OTP Testing</h1>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<aside class="title_line"><!-- title_line start -->

</aside><!-- title_line end -->


<form action="#" method="post" id="userSettingForm">
<table class="type1"><!-- table start -->
<colgroup>
    <col style="width:200px" />
    <col style="width:*" />
</colgroup>
<tbody>
    <th scope="row">User Name</th>
    <td><input id="userName" type="text" name="userName" title="" class="w100p"/></td>
</tr>
<tr>
    <th scope="row">Email</th>
    <td><input id="email" type="text" name="email" title="" class="w100p"/></td>
</tr>

<tr id="otpDisplay" style="display:none">
    <th scope="row">OTP</th>
    <td><input id="otpNumber" type="text" name="otpNumber" title="" class="w100p"/></td>
</tr>

</tbody>
</table><!-- table end -->
</form>

<div style="height: 30px">
</div>
<ul class="center_btns">
    <li id="requestOTP"><p class="btn_blue"><a href="#" onclick="fn_requestOTP()">Request OTP</a></p></li>
    <li id="confirmOTP" style="display:none"><p class="btn_blue"><a href="#" onclick="fn_confirmOTP()">Confirm OTP</a></p></li>
</ul>

</section><!-- content end -->
</section><!-- container end -->
</section><!-- tap_wrap end  -->
</div><!-- popup_wrap end -->