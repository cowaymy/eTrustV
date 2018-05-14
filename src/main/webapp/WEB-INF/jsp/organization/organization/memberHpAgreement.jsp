<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">
$(document).ready(function() {

    var memberID = $("#memberID").val();
    var identification = $("#identification").val();

    if (memberID == "") {
        if ($("#popup_wrap").attr("alert") != "Y") {
            Common.alert("<spring:message code='sys.msg.necessary' arguments='ID'/>");
            $("#memberID").focus();
        }
        return false;
    }

    if (identification == "") {
        if ($("#popup_wrap").attr("alert") != "Y") {
            Common.alert("<spring:message code='sys.msg.necessary' arguments='TYPE'/>");
            $("#identification").focus();
        }
        return false;
    }

    if("${message}" == "FAILED") {
        Common.alert("${message}");
    }
});

function fn_AcceptAgreement() {

    //$("#choice").val(choice);

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
console.log("accept");
    Common.ajax("GET", "/organization/getApplicantInfo", $("#applicantValidateForm").serialize(), function(result) {
        console.log(result);

        var cnfm = result.cnfm;
        var cnfm_dt = result.cnfm_dt;
        var stus = result.stus;

        if(cnfm == "0" && cnfm_dt == "1900-01-01" && stus == "44") {
            Common.ajax("GET", "/organization/updateHpCfm.do", {choice:"Y"}, function(result1) {
                if(result1.message == "success") {
                    Common.alert("Application success.");
                }
            });
        } else if(cnfm != "0" && cnfm_dt != "1900-01-01" && stus == "44") {
            Common.alert("Member has already accepted agreement.");
        } else if(cnfm == "0" && cnfm_dt != "1900-01-01" && stus == "6") {
            Common.alert("Member has already rejected agreement.");
        }
    });


    // 2018-05-04 - LaiKW - End
}

function fn_RejectAgreement() {
    Common.confirm("Are you sure want to decline this agreement? ", function() {
    	Common.ajax("GET", "/organization/updateHpCfm.do", {choice:"N"}, function(result) {
            if(result.message == "success") {
                Common.alert("Application has successfully rejected.");
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
.agreementiFrame{
    position: relative;
    padding-bottom: 65.25%;
    padding-top: 30px;
    height: 450px;
    overflow: auto;
    -webkit-overflow-scrolling:touch;
    border: solid black 1px;
}
.agreementiFrame embed {
     position: absolute;
     top: 0;
     left: 0;
     width: 100%;
     height: 100%;
}
</style>
<!--  2018-05-04 - LaiKW - End -->

<!-- --------------------------------------DESIGN------------------------------------------------ -->

<section id="content"><!-- content start -->

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>HP Agreement</h2>
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

<form id="agreementForm" style="width: 100%">

    <div class="agreementiFrame">
        <embed width="100%" height="100%" name="plugin" id="plugin" src="/resources/report/dev/agreement/CowayHealthPlannerAgreement.pdf" type="application/pdf" internalinstanceid="4">
    </div>

    <!--  2018-05-04 - LaiKW - Start
    - Add TNC and personal data protection agreement -->
    <div style="padding-top:1%; padding-left: 5%; padding-right: 5%">
        <label for="acknowledgeAgreement">
            <input type="checkbox" id="acknowledgeAgreement" name="acknowledgeAgreement" value="1" />
            I hereby acknowledged that I have read and understood the terms and conditions as stated
            in agree to the above Coway (M) Sdn Bhd Health Planner Agreement and I hereby agree to the terms
            and conditions therein.
        </label>
    </div>

    <div style="padding-top:1%; padding-bottom:1%; padding-left: 5%; padding-right: 5%">
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

    <ul class="center_btns">
        <li><p class="btn_blue"><a href="javascript:fn_AcceptAgreement();">Accept</a></p></li>
        <li><p class="btn_blue"><a href="javascript:fn_RejectAgreement();">Reject</a></p></li>
    </ul>
</form>

</section>

</section><!-- content end -->
