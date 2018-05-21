<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script src ="${pageContext.request.contextPath}/resources/js/pdfobject.js" type="text/javascript"></script>
<script type="text/javaScript">

var verCnt = 0;

$(document).ready(function() {

    var memberID = $("#memberID").val();
    var identification = $("#identification").val();

    if (memberID == "") {
        if ($("#popup_wrap").attr("alert") != "Y") {
            Common.alert("<spring:message code='sys.msg.necessary' arguments='ID'/>");
            $("#memberID").focus();
        }

        $("#agreementForm").attr("hidden", true);

        return false;
    }

    if (identification == "") {
        if ($("#popup_wrap").attr("alert") != "Y") {
            Common.alert("<spring:message code='sys.msg.necessary' arguments='TYPE'/>");
            $("#identification").focus();
        }
        return false;
    }

    // Require level 2 NRIC verification to enable elements
    $("#agreementPDF").attr("hidden", true);
    $("#dlPDF").attr("hidden", true);
    $("#acknowledgementDiv").attr("hidden", true);
    $("#personalDataDiv").attr("hidden", true);
    $("#agreementChoices").attr("hidden", true);
});

function fn_aplicantSearch() {
    var memberID = $("#memberID").val();
    var identification = $("#identification").val();
    var nric = $("#icNum").val();

    Common.ajax("GET", "/organization/verifyAccess", {memberID: memberID, identification: identification, nric: nric}, function(result){
        // Verified applicants will only be able to view agreements and terms and condition
        if(result.cnt == "1") {

        	$("#verificationBody").attr("hidden", true);
            $("#acknowledgementDiv").attr("hidden", false);
            $("#personalDataDiv").attr("hidden", false);
            $("#agreementChoices").attr("hidden", false);

            // Upon success, check device type to control elements shown
            var isMobile = false;

            if(/(android|bb\d+|meego).+mobile|avantgo|bada\/|blackberry|blazer|compal|elaine|fennec|hiptop|iemobile|ip(hone|od)|ipad|iris|kindle|Android|Silk|lge |maemo|midp|mmp|netfront|opera m(ob|in)i|palm( os)?|phone|p(ixi|re)\/|plucker|pocket|psp|series(4|6)0|symbian|treo|up\.(browser|link)|vodafone|wap|windows (ce|phone)|xda|xiino/i.test(navigator.userAgent)
            || /1207|6310|6590|3gso|4thp|50[1-6]i|770s|802s|a wa|abac|ac(er|oo|s\-)|ai(ko|rn)|al(av|ca|co)|amoi|an(ex|ny|yw)|aptu|ar(ch|go)|as(te|us)|attw|au(di|\-m|r |s )|avan|be(ck|ll|nq)|bi(lb|rd)|bl(ac|az)|br(e|v)w|bumb|bw\-(n|u)|c55\/|capi|ccwa|cdm\-|cell|chtm|cldc|cmd\-|co(mp|nd)|craw|da(it|ll|ng)|dbte|dc\-s|devi|dica|dmob|do(c|p)o|ds(12|\-d)|el(49|ai)|em(l2|ul)|er(ic|k0)|esl8|ez([4-7]0|os|wa|ze)|fetc|fly(\-|_)|g1 u|g560|gene|gf\-5|g\-mo|go(\.w|od)|gr(ad|un)|haie|hcit|hd\-(m|p|t)|hei\-|hi(pt|ta)|hp( i|ip)|hs\-c|ht(c(\-| |_|a|g|p|s|t)|tp)|hu(aw|tc)|i\-(20|go|ma)|i230|iac( |\-|\/)|ibro|idea|ig01|ikom|im1k|inno|ipaq|iris|ja(t|v)a|jbro|jemu|jigs|kddi|keji|kgt( |\/)|klon|kpt |kwc\-|kyo(c|k)|le(no|xi)|lg( g|\/(k|l|u)|50|54|\-[a-w])|libw|lynx|m1\-w|m3ga|m50\/|ma(te|ui|xo)|mc(01|21|ca)|m\-cr|me(rc|ri)|mi(o8|oa|ts)|mmef|mo(01|02|bi|de|do|t(\-| |o|v)|zz)|mt(50|p1|v )|mwbp|mywa|n10[0-2]|n20[2-3]|n30(0|2)|n50(0|2|5)|n7(0(0|1)|10)|ne((c|m)\-|on|tf|wf|wg|wt)|nok(6|i)|nzph|o2im|op(ti|wv)|oran|owg1|p800|pan(a|d|t)|pdxg|pg(13|\-([1-8]|c))|phil|pire|pl(ay|uc)|pn\-2|po(ck|rt|se)|prox|psio|pt\-g|qa\-a|qc(07|12|21|32|60|\-[2-7]|i\-)|qtek|r380|r600|raks|rim9|ro(ve|zo)|s55\/|sa(ge|ma|mm|ms|ny|va)|sc(01|h\-|oo|p\-)|sdk\/|se(c(\-|0|1)|47|mc|nd|ri)|sgh\-|shar|sie(\-|m)|sk\-0|sl(45|id)|sm(al|ar|b3|it|t5)|so(ft|ny)|sp(01|h\-|v\-|v )|sy(01|mb)|t2(18|50)|t6(00|10|18)|ta(gt|lk)|tcl\-|tdg\-|tel(i|m)|tim\-|t\-mo|to(pl|sh)|ts(70|m\-|m3|m5)|tx\-9|up(\.b|g1|si)|utst|v400|v750|veri|vi(rg|te)|vk(40|5[0-3]|\-v)|vm40|voda|vulc|vx(52|53|60|61|70|80|81|83|85|98)|w3c(\-| )|webc|whit|wi(g |nc|nw)|wmlb|wonu|x700|yas\-|your|zeto|zte\-/i.test(navigator.userAgent.substr(0,4))) {
                isMobile = true;

                $("#dlPDF").attr("hidden", false);
            } else if(!isMobile) {
                $("#agreementPDF").attr("hidden", false);agreementPDF
            }
        } else if (result.cnt == "0") {

        	if(verCnt < 2) {
        		Common.alert("Invalid NRIC, please try again.");
            }

            verCnt = verCnt + 1;

            if(verCnt == 3) {
                Common.alert("You have more than 3 times submission, kindly refer your sponsor.");
                verCnt = 0;
            }
        }
    });
}

function fn_AcceptAgreement() {
console.log("accept");
    // 2018-05-04 - LaiKW - Start
    // Add validation checking

    if($("#acknowledgeAgreement").prop('checked') == false) {
        Common.alert("* Please agree the terms and conditions.");
        return false;
    }

    if($("#personalDataAgreement").prop('checked')  == false) {
        Common.alert("* Please agree the personal data protection.");
        return false;
    }

    Common.ajax("GET", "/organization/getApplicantInfo", $("#applicantValidateForm").serialize(), function(result) {
        console.log(result);

        var cnfm = result.cnfm;
        var cnfm_dt = result.cnfm_dt;
        var stus = result.stus;

        if(cnfm == "0" && cnfm_dt == "1900-01-01" && stus == "44") {
            Common.confirm("Are you sure want to confirm this application?", function() {
                // Update applicant status
                Common.ajax("GET", "/organization/updateHpCfm.do", {choice:"Y"}, function(result) {
                    if(result.message == "success.") {
                        var successMsg = "Thank you for signing up as Coway Malaysia Health Planner. <br /><br />" +
                                                  "Kindly proceed to make payment of RM120 and supporting documents within 7 days from application date to complete your Health Planner registration. <br /><br />"+
                                                  "Thank you.";

                        // Redirect to login page
                        Common.confirm(successMsg, function(event) {
                            $("#applicantInfo").attr({
                                action: "/login/login.do",
                                method: "POST"
                            }).submit();
                        });
                    }
                });
            })
        } else if(cnfm != "0" && cnfm_dt != "1900-01-01" && (stus == "44" || stus == "102" || stus == "5")) {
            Common.alert("Member has already accepted agreement.");
        } else if(cnfm == "0" && cnfm_dt != "1900-01-01" && stus == "6") {
            Common.alert("Member has already rejected agreement.");
        }
    });

    //window.location.replace("/login/login.do");
    // 2018-05-04 - LaiKW - End
}

function fn_RejectAgreement() {
    Common.confirm("Are you sure want to decline this agreement? ", function() {
        Common.ajax("GET", "/organization/getApplicantInfo", $("#applicantValidateForm").serialize(), function(result) {
            console.log(result);

            var cnfm = result.cnfm;
            var cnfm_dt = result.cnfm_dt;
            var stus = result.stus;

            if(cnfm == "0" && cnfm_dt == "1900-01-01" && stus == "44") {
                Common.ajax("GET", "/organization/updateHpCfm.do", {choice:"N"}, function(result) {
                	console.log(result.message);
                    if(result.message == "success") {
                        Common.confirm("Application has successfully rejected.", function(event) {
                            // Redirect to login page
                            $("#applicantInfo").attr({
                                action: "/login/login.do",
                                method: "POST"
                            }).submit();
                        });
                    }
                });
            } else if(cnfm != "0" && cnfm_dt != "1900-01-01" && (stus == "44" || stus == "102" || stus == "5")) {
                Common.alert("Member has already accepted agreement.");
            } else if(cnfm == "0" && cnfm_dt != "1900-01-01" && stus == "6") {
                Common.alert("Member has already rejected agreement.");
            }
        });
    });
}

</script>

<!--  2018-05-04 - LaiKW - Start
        - Add custom styling -->
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
<!--  2018-05-04 - LaiKW - End -->

<!-- --------------------------------------DESIGN------------------------------------------------ -->

<section id="content"><!-- content start -->

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>HP Agreement</h2>
    <ul class="right_btns">
        <li><p id="submitBtn" class="btn_blue"><a href="javascript:fn_aplicantSearch();"><span class="submit"></span>Submit</a></p></li>
    </ul>
</aside><!-- title_line end -->

<section id = "body">
<form id="applicantInfo" name="applicantInfo" method="post">
    <input type="hidden" id="memberID" name="memberID" value="${memberID}">
    <input type="hidden" id="identification" name="identification" value="${identification}">
</form>

<form id="applicantValidateForm" method="post">
    <div style="display:none">
        <input type="text" name="aplcntId"  id="aplcntId" value="${memberID}"/>
    </div>
</form>

<section class="search_table"><!-- search_table start -->
<form action="#" id="searchForm" method="post">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:130px" />
    <col style="width:*" />
</colgroup>
<tbody id="verificationBody" name="verificationBody">
<tr>
    <th scope="row">IC Number</th>
    <td>
    <input type="text" title="IC Number" placeholder="" id="icNum" name="icNum" />
    </td>
</tr>
</tbody>
</table><!-- table end -->


</form>
</section><!-- search_table end -->

<form id="agreementForm" style="width: 100%">

    <div id="agreementPDF" style="height: 450px">
        <script>PDFObject.embed("/resources/pdf/agreement/CowayHealthPlannerAgreement.pdf", "#agreementPDF");</script>
    </div>

    <div id="dlPDF" style="padding-left: 5%; padding-right: 5%">
        <b><font size="4">Please tap on the icon to view the agreement:</font></b>
        <a href="/resources/pdf/agreement/CowayHealthPlannerAgreement.pdf">
            <img src="${pageContext.request.contextPath}/resources/images/common/icon_pdf.png" alt="PDF" class="centerPDF">
        </a>
    </div>

    <!--  2018-05-04 - LaiKW - Start
    - Add TNC and personal data protection agreement -->
    <div id="acknowledgementDiv" name="acknowledgementDiv" style="padding-top:1%; padding-left: 5%; padding-right: 5%">
        <label for="acknowledgeAgreement">
            <input type="checkbox" id="acknowledgeAgreement" name="acknowledgeAgreement" value="1" />
            I hereby acknowledged that I have read and understood the terms and conditions as stated
            in agree to the above Coway (M) Sdn Bhd Health Planner Agreement and I hereby agree to the terms
            and conditions therein.
        </label>
    </div>

    <div id="personalDataDiv" name="personalDataDiv" style="padding-top:1%; padding-bottom:1%; padding-left: 5%; padding-right: 5%">
        <label for="personalDataAgreement">
            <input type="checkbox" id="personalDataAgreement" name="personalDataAgreement" value="1" />
            I hereby agree and consent that my personal data may be collected, used, processed and
            disclosed by Coway (M) Sdn Bhd as described in Schedule 3 of the HP Agreement for the purpose
            of processing my registration, as well as for the programme delivery involved with the above
            event, in accordance with the Personal Data Protection Act 2012 and all subsidiary legislation
            related thereto.
        </label>
    </div>
    <!--  2018-05-04 - LaiKW - End -->

    <ul class="center_btns" id="agreementChoices">
        <li><p class="btn_blue"><a href="javascript:fn_AcceptAgreement();">Accept</a></p></li>
        <li><p class="btn_blue"><a href="javascript:fn_RejectAgreement();">Reject</a></p></li>
    </ul>
</form>

</section>

</section><!-- content end -->
