<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script src ="${pageContext.request.contextPath}/resources/js/pdfobject.js" type="text/javascript"></script>
<script type="text/javaScript">

var verCnt = 0;

$(document).ready(function() {

    $("#agreementPDF").attr("hidden", true);
    $("#dlPDF").attr("hidden", true);

    var isMobile = false;

    if(/(android|bb\d+|meego).+mobile|avantgo|bada\/|blackberry|blazer|compal|elaine|fennec|hiptop|iemobile|ip(hone|od)|ipad|iris|kindle|Android|Silk|lge |maemo|midp|mmp|netfront|opera m(ob|in)i|palm( os)?|phone|p(ixi|re)\/|plucker|pocket|psp|series(4|6)0|symbian|treo|up\.(browser|link)|vodafone|wap|windows (ce|phone)|xda|xiino/i.test(navigator.userAgent)
        || /1207|6310|6590|3gso|4thp|50[1-6]i|770s|802s|a wa|abac|ac(er|oo|s\-)|ai(ko|rn)|al(av|ca|co)|amoi|an(ex|ny|yw)|aptu|ar(ch|go)|as(te|us)|attw|au(di|\-m|r |s )|avan|be(ck|ll|nq)|bi(lb|rd)|bl(ac|az)|br(e|v)w|bumb|bw\-(n|u)|c55\/|capi|ccwa|cdm\-|cell|chtm|cldc|cmd\-|co(mp|nd)|craw|da(it|ll|ng)|dbte|dc\-s|devi|dica|dmob|do(c|p)o|ds(12|\-d)|el(49|ai)|em(l2|ul)|er(ic|k0)|esl8|ez([4-7]0|os|wa|ze)|fetc|fly(\-|_)|g1 u|g560|gene|gf\-5|g\-mo|go(\.w|od)|gr(ad|un)|haie|hcit|hd\-(m|p|t)|hei\-|hi(pt|ta)|hp( i|ip)|hs\-c|ht(c(\-| |_|a|g|p|s|t)|tp)|hu(aw|tc)|i\-(20|go|ma)|i230|iac( |\-|\/)|ibro|idea|ig01|ikom|im1k|inno|ipaq|iris|ja(t|v)a|jbro|jemu|jigs|kddi|keji|kgt( |\/)|klon|kpt |kwc\-|kyo(c|k)|le(no|xi)|lg( g|\/(k|l|u)|50|54|\-[a-w])|libw|lynx|m1\-w|m3ga|m50\/|ma(te|ui|xo)|mc(01|21|ca)|m\-cr|me(rc|ri)|mi(o8|oa|ts)|mmef|mo(01|02|bi|de|do|t(\-| |o|v)|zz)|mt(50|p1|v )|mwbp|mywa|n10[0-2]|n20[2-3]|n30(0|2)|n50(0|2|5)|n7(0(0|1)|10)|ne((c|m)\-|on|tf|wf|wg|wt)|nok(6|i)|nzph|o2im|op(ti|wv)|oran|owg1|p800|pan(a|d|t)|pdxg|pg(13|\-([1-8]|c))|phil|pire|pl(ay|uc)|pn\-2|po(ck|rt|se)|prox|psio|pt\-g|qa\-a|qc(07|12|21|32|60|\-[2-7]|i\-)|qtek|r380|r600|raks|rim9|ro(ve|zo)|s55\/|sa(ge|ma|mm|ms|ny|va)|sc(01|h\-|oo|p\-)|sdk\/|se(c(\-|0|1)|47|mc|nd|ri)|sgh\-|shar|sie(\-|m)|sk\-0|sl(45|id)|sm(al|ar|b3|it|t5)|so(ft|ny)|sp(01|h\-|v\-|v )|sy(01|mb)|t2(18|50)|t6(00|10|18)|ta(gt|lk)|tcl\-|tdg\-|tel(i|m)|tim\-|t\-mo|to(pl|sh)|ts(70|m\-|m3|m5)|tx\-9|up(\.b|g1|si)|utst|v400|v750|veri|vi(rg|te)|vk(40|5[0-3]|\-v)|vm40|voda|vulc|vx(52|53|60|61|70|80|81|83|85|98)|w3c(\-| )|webc|whit|wi(g |nc|nw)|wmlb|wonu|x700|yas\-|your|zeto|zte\-/i.test(navigator.userAgent.substr(0,4))) {
        isMobile = true;

        $("#dlPDF").attr("hidden", false);
    } else if(!isMobile) {
        $("#agreementPDF").attr("hidden", false);agreementPDF
    }
});

function fn_AcceptAgreement() {
	console.log("Accept.");

    if($("#acknowledgeAgreement").prop('checked') == false) {
        Common.alert("* Please agree the terms and conditions.");
        return false;
    }

    if($("#personalDataAgreement").prop('checked')  == false) {
        Common.alert("* Please agree the personal data protection.");
        return false;
    }

    Common.ajax("GET", "/organization/getCDInfo", $("#loginForm").serialize(), function(result) {
        console.log(result);

        var cnfm = result.cnfm;
        var cnfm_dt = result.cnfm_dt;
        var stus = result.stus;

        if(cnfm == "0" && cnfm_dt == "1900-01-01" && stus == "44") {
            Common.confirm("Are you sure want to confirm this application?", function() {
                // Update applicant status
                Common.ajax("GET", "/organization/updateCodyCfm.do", {choice:"Y"}, function(result) {
                    if(result.message == "success.") {
                        var successMsg = "Thank you for signing up as Coway Malaysia Lady(Cody). <br /><br />";// +
                                                  //"Kindly proceed to make payment of RM100 and supporting documents within 7 days from application date to complete your Lady(Cody) registration. <br /><br />"+
                                                  //"Thank you.";

                        // Redirect to login page
                        Common.alert(successMsg, function(event) {
                            $("#loginForm").attr({
                                action: getContextPath() + "/common/main.do",
                                method: "POST"
                            }).submit();
                        });
                    }
                });
            })
        } else if(cnfm != "0" && cnfm_dt != "1900-01-01" && (stus == "44" || stus == "5")) {
            Common.alert("Member has already accepted agreement.");
        } else if(cnfm == "0" && cnfm_dt != "1900-01-01" && stus == "6") {
            Common.alert("Member has already rejected agreement.");
        }
    });
}

function fn_RejectAgreement() {
    Common.confirm("Are you sure want to decline this agreement? ", function() {
        Common.ajax("GET", "/organization/getCDInfo", $("#loginForm").serialize(), function(result) {
            console.log(result);

            var cnfm = result.cnfm;
            var cnfm_dt = result.cnfm_dt;
            var stus = result.stus;

            if(cnfm == "0" && cnfm_dt == "1900-01-01" && stus == "44") {
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
            } else if(cnfm != "0" && cnfm_dt != "1900-01-01" && (stus == "44" || stus == "5")) {
                Common.alert("Member has already accepted agreement.");
            } else if(cnfm == "0" && cnfm_dt != "1900-01-01" && stus == "6") {
                Common.alert("Member has already rejected agreement.");
            }
        });
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
</style>

<!-- --------------------------------------DESIGN------------------------------------------------ -->

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->
<section id="content"><!-- content start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Cody Agreement</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<form id="loginForm" method="post">
    <input type="hidden" id="loginUserId" name="loginUserId" value="${loginUserId}"/>
    <input type="hidden" id="loginOs" name="os" value="${os}"/>
    <input type="hidden" id="loginBrowser" name="browser" value="${browser}"/>

    <input type="hidden" title="ID" placeholder="ID" id="userId" name="userId" value="${userId}"/>
    <input type="hidden" title="PASSWORD" placeholder="PASSWORD" id="password" name="password" value="${password}"/>
</form>

<form id="agreementForm" style="width: 100%">

    <div id="agreementPDF" style="height: 375px">`
        <script>PDFObject.embed("/resources/report/prd/organization/CowayCodyAgreement.pdf", "#agreementPDF");</script>
    </div>

    <div id="dlPDF" style="padding-left: 5%; padding-right: 5%">
        <b><font size="4">Please tap on the icon to view the agreement:</font></b>
        <a href="/resources/report/prd/organization/CowayHealthPlannerAgreement.pdf">
            <img src="${pageContext.request.contextPath}/resources/images/common/icon_pdf.png" alt="PDF" class="centerPDF">
        </a>
    </div>

    <div id="acknowledgementDiv" name="acknowledgementDiv" style="padding-top:1%; padding-left: 5%; padding-right: 5%">
        <label for="acknowledgeAgreement">
            <input type="checkbox" id="acknowledgeAgreement" name="acknowledgeAgreement" value="1" />
            I hereby acknowledged that I have read and understood the terms and conditions as stated
            in agree to the above Coway (M) Sdn Bhd Coway Lady(Cody) Agreement and I hereby agree to the terms
            and conditions therein.
        </label>
    </div>

    <div id="personalDataDiv" name="personalDataDiv" style="padding-top:1%; padding-bottom:1%; padding-left: 5%; padding-right: 5%">
        <label for="personalDataAgreement">
            <input type="checkbox" id="personalDataAgreement" name="personalDataAgreement" value="1" />
            I hereby agree and consent that my personal data may be collected, used, processed and
            disclosed by Coway (M) Sdn Bhd as described in Schedule 3 of the Cody Agreement for the purpose
            of processing my registration, as well as for the programme delivery involved with the above
            event, in accordance with the Personal Data Protection Act 2012 and all subsidiary legislation
            related thereto.
        </label>
    </div>

    <ul class="center_btns" id="agreementChoices">
        <li><p class="btn_blue"><a href="javascript:fn_AcceptAgreement();">Accept</a></p></li>
        <li><p class="btn_blue"><a href="javascript:fn_RejectAgreement();">Reject</a></p></li>
    </ul>
</form>

</section><!-- content end -->
</section><!-- pop_body end -->
</div><!-- popup_wrap end -->