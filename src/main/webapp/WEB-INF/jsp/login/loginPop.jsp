<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script src ="${pageContext.request.contextPath}/resources/js/pdfobject.js" type="text/javascript"></script>
<script type="text/javaScript">
var verCnt = 0;
var userType = "";

$(document).ready(function() {
	debugger;
console.log("loginPop.jsp");
    //$("#PDF").attr("hidden", true);
    //$("#dlPDF").attr("hidden", true);
    //$("#staffPDF").attr("hidden", true);
    //$("#staffDlPDF").attr("hidden", true);

    userType = ${userType};

    var isMobile = false;

    /*
    if(/(android|bb\d+|meego).+mobile|avantgo|bada\/|blackberry|blazer|compal|elaine|fennec|hiptop|iemobile|ip(hone|od)|ipad|iris|kindle|Android|Silk|lge |maemo|midp|mmp|netfront|opera m(ob|in)i|palm( os)?|phone|p(ixi|re)\/|plucker|pocket|psp|series(4|6)0|symbian|treo|up\.(browser|link)|vodafone|wap|windows (ce|phone)|xda|xiino/i.test(navigator.userAgent)
        || /1207|6310|6590|3gso|4thp|50[1-6]i|770s|802s|a wa|abac|ac(er|oo|s\-)|ai(ko|rn)|al(av|ca|co)|amoi|an(ex|ny|yw)|aptu|ar(ch|go)|as(te|us)|attw|au(di|\-m|r |s )|avan|be(ck|ll|nq)|bi(lb|rd)|bl(ac|az)|br(e|v)w|bumb|bw\-(n|u)|c55\/|capi|ccwa|cdm\-|cell|chtm|cldc|cmd\-|co(mp|nd)|craw|da(it|ll|ng)|dbte|dc\-s|devi|dica|dmob|do(c|p)o|ds(12|\-d)|el(49|ai)|em(l2|ul)|er(ic|k0)|esl8|ez([4-7]0|os|wa|ze)|fetc|fly(\-|_)|g1 u|g560|gene|gf\-5|g\-mo|go(\.w|od)|gr(ad|un)|haie|hcit|hd\-(m|p|t)|hei\-|hi(pt|ta)|hp( i|ip)|hs\-c|ht(c(\-| |_|a|g|p|s|t)|tp)|hu(aw|tc)|i\-(20|go|ma)|i230|iac( |\-|\/)|ibro|idea|ig01|ikom|im1k|inno|ipaq|iris|ja(t|v)a|jbro|jemu|jigs|kddi|keji|kgt( |\/)|klon|kpt |kwc\-|kyo(c|k)|le(no|xi)|lg( g|\/(k|l|u)|50|54|\-[a-w])|libw|lynx|m1\-w|m3ga|m50\/|ma(te|ui|xo)|mc(01|21|ca)|m\-cr|me(rc|ri)|mi(o8|oa|ts)|mmef|mo(01|02|bi|de|do|t(\-| |o|v)|zz)|mt(50|p1|v )|mwbp|mywa|n10[0-2]|n20[2-3]|n30(0|2)|n50(0|2|5)|n7(0(0|1)|10)|ne((c|m)\-|on|tf|wf|wg|wt)|nok(6|i)|nzph|o2im|op(ti|wv)|oran|owg1|p800|pan(a|d|t)|pdxg|pg(13|\-([1-8]|c))|phil|pire|pl(ay|uc)|pn\-2|po(ck|rt|se)|prox|psio|pt\-g|qa\-a|qc(07|12|21|32|60|\-[2-7]|i\-)|qtek|r380|r600|raks|rim9|ro(ve|zo)|s55\/|sa(ge|ma|mm|ms|ny|va)|sc(01|h\-|oo|p\-)|sdk\/|se(c(\-|0|1)|47|mc|nd|ri)|sgh\-|shar|sie(\-|m)|sk\-0|sl(45|id)|sm(al|ar|b3|it|t5)|so(ft|ny)|sp(01|h\-|v\-|v )|sy(01|mb)|t2(18|50)|t6(00|10|18)|ta(gt|lk)|tcl\-|tdg\-|tel(i|m)|tim\-|t\-mo|to(pl|sh)|ts(70|m\-|m3|m5)|tx\-9|up(\.b|g1|si)|utst|v400|v750|veri|vi(rg|te)|vk(40|5[0-3]|\-v)|vm40|voda|vulc|vx(52|53|60|61|70|80|81|83|85|98)|w3c(\-| )|webc|whit|wi(g |nc|nw)|wmlb|wonu|x700|yas\-|your|zeto|zte\-/i.test(navigator.userAgent.substr(0,4))) {
        isMobile = true;

        $("#dlPDF").attr("hidden", false);

    } else if(!isMobile) {
        $("#PDF").attr("hidden", false);
    }
    */
    $("#PDF").attr("hidden", false);

    $("#agreementLogoutBtn").attr("hidden", true);
    $("#hmAboveNewA").attr("hidden", true);

    // Memo or Notice
    if("${popType}" == "M" || "${popType}" == "N") {
    	console.log("memo notice");
        $("#memoButton").attr("hidden", false);
        $("#agreementButton").attr("hidden", true);
        $("#popButton").attr("hidden", true);

        $("#acknowledgement").attr("hidden", true);
        $("#popAcknowledgement").attr("hidden", true);
        $("#PDF").css("height", "600px");
    }
    // Organization's Agreement
    if("${popType}" == "B") {
    	console.log("agreement B");
        $("#agreementButton").attr("hidden", false);
        $("#memoButton").attr("hidden", true);
        $("#popButton").attr("hidden", true);
        $("#acknowledgement").attr("hidden", false);
        $("#popAcknowledgement").attr("hidden", true);
        $("#hmAboveNewA").attr("hidden", false);


        if("${popRejectFlg}" == "X") {
            $("#agreementRejectBtn").attr("hidden", false);
        } else {
            $("#agreementRejectBtn").attr("hidden", true);
        }
    }else
    	if("${popType}" == "A") {
    	console.log("agreement A");
        $("#agreementButton").attr("hidden", false);
        $("#memoButton").attr("hidden", true);
        $("#popButton").attr("hidden", true);
        $("#acknowledgement").attr("hidden", false);
        $("#popAcknowledgement").attr("hidden", true);

        $("#acknowledgement").attr("hidden", false);

        if("${popRejectFlg}" == "X") {
            $("#agreementRejectBtn").attr("hidden", false);
        } else {
            $("#agreementRejectBtn").attr("hidden", true);
        }

        if(userType == "2") {
            $("#agreementLogoutBtn").attr("hidden", false);
            $("#agreementRejectBtn").attr("hidden", true);
        }

        if(userType == "7") {
            $("#agreementLogoutBtn").attr("hidden", false);
            $("#agreementRejectBtn").attr("hidden", true);
        }
    }


    // Consent Letter/Additional Pop Up type
    if("${popType}" != "A" && "${popType}" != "M" && "${popType}" != "B" && "${popType}" != "N") {
    	console.log("letter");
        $("#agreementButton").attr("hidden", true);
        $("#memoButton").attr("hidden", true);
        $("#popButton").attr("hidden", false);
        $("#acknowledgement").attr("hidden", true);
        $("#popAcknowledgement").attr("hidden", false);
    }

});

function fn_cont() {
    $("#popForm").attr({
        action: getContextPath() + "/common/main.do",
        method: "POST"
    }).submit();
}

function fn_AcceptAgreement() {
    console.log("Accept.");

    if($("#ackMemInfoCheckbox").is(":checked") == false) {
        Common.alert("* Please check your personal information.");
        return false;
    }

    if($("#ack1Checkbox").is(":checked") == false) {
        Common.alert("* Please agree the terms and conditions.");
        return false;
    }

    if($("#ack2Checkbox").is(":checked")  == false) {
    	if($("#popType").val() == 'B'){
    		Common.alert("* please agree the terms and condition.");
    	}else{
    		Common.alert("* Please agree the personal data protection.");
    	}

        return false;
    }

    if($("#popType").val() == 'B' && $("#ack3Checkbox").is(":checked")  == false){
    	Common.alert("* please agree the terms and condition.");
        return false;
    }

    Common.confirm("Are you sure want to confirm this application?", function() {
        // Update applicant status
        Common.ajax("GET", "/organization/updateCodyCfm.do", {choice:"Y", consentFlg:$("#consentFlg").val()}, function(result) {
            if(result.message == "success.") {
                var successMsg = "";

                if(userType == "1") {
                     successMsg = "Please print the agreement copy for your own record."
                	  //successMsg = "Thank you."
                } else if(userType == "2") {
                    successMsg = "Thank you for signing up as Coway Malaysia Lady(Cody). <br /><br />";// +
                }else if(userType == "7") {
                    successMsg = "Thank you for signing up as Coway Malaysia Homecare Technician (HT). <br /><br />";// +
                }
                // Redirect to login page
                if($("#loginForm #surveyStus").val() <= 0 && $("#loginForm surveyTypeId").val() > 0){
                    $('#popForm').hide();
                    fn_goSurveyForm($("#loginForm surveyTypeId").val());
                }else{
                    Common.alert(successMsg, function(event) {
                    $("#loginForm").attr({
                            action: getContextPath() + "/common/main.do",
                            method: "POST"
                        }).submit();
                    });
                }
            }
        });
    });
}

function fn_RejectAgreement() {
    Common.confirm("Are you sure want to decline this agreement? ", function() {
        Common.ajax("GET", "/organization/updateCodyCfm.do", {choice:"N"}, function(result) {
            console.log(result.message);
            if(result.message == "success.") {
                Common.alert("Application has successfully rejected.", function(event) {
                    // Redirect to login page
                    $("#loginForm").attr({
                        action: "/login/login.do",
                        method: "POST"
                    }).submit();
                });
            }
        });
    });
}

function fn_Logout() {
	$("#loginForm").attr({
        action: "/login/logout.do",
        method: "POST"
    }).submit();
}

function fn_popAccept() {
    console.log("fn_popAccept");

    if($("#popAck1Checkbox").is(":checked") == false) {
        Common.alert("* Please agree the terms and conditions.");
        return false;
    }
    Common.alert("${popId}");

    Common.ajax("GET", "/login/popAccept.do", {choice: "Y", popId: "${popId}", applicantId: "${applicantId}"}, function(result) {
        if(result.message == "success.") {
            $("#loginForm").attr({
                action: getContextPath() + "/common/main.do",
                method: "POST"
            }).submit();
        }
    });
}

</script>

<style>
label {
    display: block;
    padding-left: 15px;
    text-indent: -15px;
    text-align: justify;
}
input {
    width: 13px;
    height: 13px;
    padding: 0;
    margin:0;
    vertical-align: bottom;
    position: relative;
    top: -1px;
    *overflow: hidden;
}
.centerPDF{
    display: block;
    margin-left: auto;
    margin-right: auto;
}

.login_pop{position:fixed; top:20px; left:50%; z-index:1001; margin-left:-500px; width:1000px; background:#fff; border:1px solid #ccc;}
.login_pop:after{content:""; display:block; position:fixed; top:0; left:0; z-index:-1; width:100%; height:100%; background:rgba(0,0,0,0.6);}
.login_pop.size_small{width:500px!important; margin-left:-250px!important;}
.login_pop.size_mid{width:700px!important; margin-left:-350px!important;}
.login_pop.size_mid2{width:600px!important; margin-left:-300px!important;}
.login_pop.size_big{width:1240px!important; margin-left:-620px!important;}
.login_pop.size_all{width:100%!important; margin-left:0!important; left:0!important; top:0!important; box-sizing:border-box;}
.login_header{padding:10px; background:#e5e5e5; border-bottom:2px solid #25527c;cursor: move}
.login_header:after{content:""; display:block; clear:both;}
.login_header h1{position:relative; float:left; height:28px; line-height:28px; padding-left:14px; font-size:20px; color:#111; font-weight:normal;}
.login_header h1:before{content:""; display:block; position:absolute; top:5px; left:0; width:3px; height:18px; background:#25527c;}
.login_header .right_opt{float:right;}
.login_header .right_opt:after{content:""; display:block; clear:both;}
.login_header .right_opt li{float:left; margin-left:5px;}
.login_body{max-height:100%; padding:10px; background:#fff; overflow-y:scroll;}
.login_body.win_popup{max-height:100%;overflow-y:auto;}
.login_pop.no_scroll .login_body{max-height:100%;}
.login_pop.size_small .login_body{max-height:350px;}
.login_body:after{content:""; display:block; height:10px; background:#fff;}
.login_body > *:first-child{margin-top:0!important;}
.login_body form > *:first-child{margin-top:0!important;}
.login_body h2{padding:10px 0 0 0; font-size:12px; color:#25527c;}
.login_body .title_line:first-child h2{padding-top:0;}
.login_body h3{margin:0; line-height:22px; font-size:11px; color:#333;}
.login_pop.msg_box{width:400px; height:auto!important; top:50%; margin:-100px 0 0 -200px; border:1px solid #0c3a65;}
.login_pop.msg_box.msg_big{width:500px; height:300px; margin:-150px 0 0 -250px;}
.login_pop.msg_box .login_header{padding:10px 20px; background:#0c3a65; border-bottom:0 none;cursor: default;}
.login_pop.msg_box .login_header h1{height:auto; font-size:13px; color:#fff; padding-left:0;}
.login_pop.msg_box .login_header h1:before{display:none;}
.login_pop.msg_box .login_header .pop_close{position:absolute; top:9px; right:21px;}
.login_pop.msg_box .login_header .pop_close a{display:block; text-indent:-1000em; overflow:hidden; width:17px; height:17px; background:url(../images/common/btn_pop_close.gif) no-repeat 0 0;}
.login_pop.msg_box .login_body {height:auto; min-height:60px;}
.login_pop.msg_box .msg_txt{display:table-cell; width:360px; height:50px; vertical-align:middle; text-align:center; line-height:1.5;}
.login_pop.msg_box.msg_big .msg_txt{width:460px; height:186px;}
.login_pop.msg_box .msg_txt .input_area{display:inline-block; margin:5px 0; padding:5px 10px 7px 10px; background:#e5e5e5; border-radius:15px;}
.login_pop.msg_box .msg_txt label input[type=checkbox],
.login_pop.msg_box .msg_txt label input[type=radio]{position:relative; top:2px; margin:0 5px 0 0; padding:0; border:1px solid #d2d2d2;}
.login_pop.msg_box .center_btns {margin-top:15px;}
.login_pop.msg_box.msg_big .center_btns {margin-top:0;}
.login_pop .ms-drop ul {max-height:275px !important;}

/* Popup Window*/
.login_pop.pop_win{position:relative;left: 0;top: 0; margin-left:0!important; width:100%!important; border:0 none!important;}
.login_pop.pop_win:after{display:none;}
.login_pop.pop_win .login_header{cursor: default;position: fixed;width:100%;z-index:10}
.login_pop.pop_win .login_header .right_opt{margin-right:20px;}
.login_pop.pop_win .login_body{max-height:none; padding:10px; background:#fff; overflow-y:hidden;padding-top: 60px}

table.type1 tbody th{height:20px; color:#333; font-weight:normal; line-height:15px; background:#e9f0f4; border-bottom:none; border-left:none; border-right:none;}
table.type1 tbody td{height:20px; padding:2px 6px; border-bottom:none; border-left:none; border-right:none;}
</style>

<!-- --------------------------------------DESIGN------------------------------------------------ -->

<div id="login_pop" class="login_pop"><!-- login_pop start -->
<section id="content"><!-- content start -->

<section class="login_body"><!-- login_body start -->

<form id="loginForm" method="post">
    <input type="hidden" id="loginUserId" name="loginUserId" value="${loginUserId}"/>
    <input type="hidden" id="loginOs" name="os" value="${os}"/>
    <input type="hidden" id="loginBrowser" name="browser" value="${browser}"/>

    <input type="hidden" title="ID" placeholder="ID" id="userId" name="userId" value="${userId}"/>
    <input type="hidden" title="PASSWORD" placeholder="PASSWORD" id="password" name="password" value="${password}"/>

    <input type="hidden" id="consentFlg" name="consentFlg" value="${consentFlg}"/>
    <input type="hidden" id="pdfName" name="pdfName" value="${pdfNm}"/>
</form>

<form id="popForm" style="width: 100%">

    <div id="PDF" style="height: 500px">
        <!-- <script>PDFObject.embed("/resources/report/prd/organization/2019_Half_Yearly_Incentive_Trip_v2.pdf", "#PDF");</script> -->
        <embed src="${pdfNm}#toolbar=0" style="overflow: auto; width: 100%; height: 100%;" type="application/pdf">
    </div>

    <div id="acknowledgement" style="padding-top:1%; padding-left: 1%; padding-right: 1%">
        <table class="type1" style="border: none"><!-- table start -->
            <tbody>
                <tr>
                    <td style="width : 10px"><input type="checkbox" id="ackMemInfoCheckbox" name="ackMemInfoCheckbox" value="1" /></td>
                    <td colspan="4">
                        I hereby confirm the below information as stated
                    </td>
                </tr>
                <tr>
                    <td style="width : 10px"></td>
                    <td><b>Name :</b></td>
                    <td>${verName}</td>
                    <td><b>NRIC :</b></td>
                    <td>${verNRIC}</td>
                </tr>
                <tr>
                    <td style="width : 10px"></td>
                    <td style="padding-bottom:0.6%"><b>Commision's Bank-In Account No : </b></td>
                    <td colspan="3">${verBankAccNo} ( ${verBankName} )</td>
                </tr>
                <tr id="hmAboveNewA">
                    <td colspan="4">By clicking the Accept button, I acknowledge and declare that:</td>
                </tr>
                <tr>
                    <td>
                        <input type="checkbox" id="ack1Checkbox" name="ack1Checkbox" value="1" />
                    </td>
                    <td colspan="4" style="padding-top:0.6%; padding-bottom:0.6%;">${popAck1}</td>
                </tr>
                <tr>
                    <td>
                        <input type="checkbox" id="ack2Checkbox" name="ack2Checkbox" value="1" />
                    </td>
                    <td colspan="4" style="padding-top:0.6%; padding-bottom:0.6%;">${popAck2}</td>
                </tr>
                <tr id="hmAboveNewA">
                    <td>
                        <input type="checkbox" id="ack3Checkbox" name="ack3Checkbox" value="1" />
                    </td>
                    <td colspan="4" style="padding-top:0.6%; padding-bottom:0.6%;">${popAck3}</td>
                </tr>
            </tbody>
        </table>
    </div>

    <div id="popAcknowledgement" style="padding-top:1%; padding-left: 1%; padding-right: 1%">
        <table class="type1" style="border: none"><!-- table start -->
            <caption>table</caption>
            <colgroup>
                <col style = "width: 50px"/>
                <col style = "width: *"/>
            </colgroup>

            <tbody>
                <tr>
                    <td>
                        <input type="checkbox" id="popAck1Checkbox" name="popAck1Checkbox" value="1" />
                    </td>
                    <td style="padding-top:0.6%; padding-bottom:0.6%;">${popAck1}</td>
                </tr>
            </tbody>
        </table>
    </div>

    <ul class="center_btns" id="memoButton" style="padding: 10px">
        <li><p class="btn_blue"><a href="javascript:fn_cont();">Close</a></p></li>
    </ul>

    <ul class="center_btns" id="agreementButton">
        <li><p class="btn_blue" id="agreementAcceptBtn"><a href="javascript:fn_AcceptAgreement();">Accept</a></p></li>
        <li><p class="btn_blue" id="agreementRejectBtn"><a href="javascript:fn_RejectAgreement();">Reject</a></p></li>
        <li><p class="btn_blue" id="agreementLogoutBtn"><a href="javascript:fn_Logout();">Logout</a></p></li>
    </ul>

    <ul class="center_btns" id="popButton">
        <li><p class="btn_blue" id="popAcceptBtn"><a href="javascript:fn_popAccept();">Accept</a></p></li>
        <li><p class="btn_blue" id="popLogoutBtn"><a href="javascript:fn_Logout();">Logout</a></p></li>
    </ul>
</form>

</section><!-- content end -->
</section><!-- login_body end -->
</div><!-- login_pop end -->