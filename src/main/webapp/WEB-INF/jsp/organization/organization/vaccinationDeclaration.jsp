<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script src ="${pageContext.request.contextPath}/resources/js/pdfobject.js" type="text/javascript"></script>
<script type="text/javaScript">

var verCnt = 0;
var supportFileId = 0;
var supportFileName = "";
var myFileCaches = {};

$(document).ready(function() {

    var memberID = $("#memberID").val();

    if (memberID == "") {
        if ($("#popup_wrap").attr("alert") != "Y") {
            Common.alert("Applicantion is invalid");
            $("#memberID").focus();
        }

        $("#agreementForm").attr("hidden", true);

        return false;
    }

    // Require level 2 NRIC verification to enable elements
    $("#agreementPDF").attr("hidden", true);
    $("#dlPDF").attr("hidden", true);
    $("#declarationTbl").attr("hidden", true);
    $("#agreementChoices").attr("hidden", true);

    fn_aplicantSearch();
});

function fn_aplicantSearch() {
    var memberID = $("#memberID").val();

    Common.ajax("GET", "/organization/getVaccineSubmitInfo", {memberID: memberID}, function(result){
        // Verified applicants will only be able to view agreements and terms and condition
        if(result != 0){
	        if(result.cnt == "0") {
	            $("#declarationTbl").attr("hidden", false);
	            $("#agreementChoices").attr("hidden", false);

	            $("#memberID").val(result.memID);
	            $("#memID").val(result.memID);
	            $("#memCode").val(result.memCode);
	            $("#fullname").val(result.name);
	            $("#nric").val(result.nric);
	            $("#position").val(result.position);

	            // Upon success, check device type to control elements shown
	            var isMobile = false;

	            if(/(android|bb\d+|meego).+mobile|avantgo|bada\/|blackberry|blazer|compal|elaine|fennec|hiptop|iemobile|ip(hone|od)|ipad|iris|kindle|Android|Silk|lge |maemo|midp|mmp|netfront|opera m(ob|in)i|palm( os)?|phone|p(ixi|re)\/|plucker|pocket|psp|series(4|6)0|symbian|treo|up\.(browser|link)|vodafone|wap|windows (ce|phone)|xda|xiino/i.test(navigator.userAgent)
	            || /1207|6310|6590|3gso|4thp|50[1-6]i|770s|802s|a wa|abac|ac(er|oo|s\-)|ai(ko|rn)|al(av|ca|co)|amoi|an(ex|ny|yw)|aptu|ar(ch|go)|as(te|us)|attw|au(di|\-m|r |s )|avan|be(ck|ll|nq)|bi(lb|rd)|bl(ac|az)|br(e|v)w|bumb|bw\-(n|u)|c55\/|capi|ccwa|cdm\-|cell|chtm|cldc|cmd\-|co(mp|nd)|craw|da(it|ll|ng)|dbte|dc\-s|devi|dica|dmob|do(c|p)o|ds(12|\-d)|el(49|ai)|em(l2|ul)|er(ic|k0)|esl8|ez([4-7]0|os|wa|ze)|fetc|fly(\-|_)|g1 u|g560|gene|gf\-5|g\-mo|go(\.w|od)|gr(ad|un)|haie|hcit|hd\-(m|p|t)|hei\-|hi(pt|ta)|hp( i|ip)|hs\-c|ht(c(\-| |_|a|g|p|s|t)|tp)|hu(aw|tc)|i\-(20|go|ma)|i230|iac( |\-|\/)|ibro|idea|ig01|ikom|im1k|inno|ipaq|iris|ja(t|v)a|jbro|jemu|jigs|kddi|keji|kgt( |\/)|klon|kpt |kwc\-|kyo(c|k)|le(no|xi)|lg( g|\/(k|l|u)|50|54|\-[a-w])|libw|lynx|m1\-w|m3ga|m50\/|ma(te|ui|xo)|mc(01|21|ca)|m\-cr|me(rc|ri)|mi(o8|oa|ts)|mmef|mo(01|02|bi|de|do|t(\-| |o|v)|zz)|mt(50|p1|v )|mwbp|mywa|n10[0-2]|n20[2-3]|n30(0|2)|n50(0|2|5)|n7(0(0|1)|10)|ne((c|m)\-|on|tf|wf|wg|wt)|nok(6|i)|nzph|o2im|op(ti|wv)|oran|owg1|p800|pan(a|d|t)|pdxg|pg(13|\-([1-8]|c))|phil|pire|pl(ay|uc)|pn\-2|po(ck|rt|se)|prox|psio|pt\-g|qa\-a|qc(07|12|21|32|60|\-[2-7]|i\-)|qtek|r380|r600|raks|rim9|ro(ve|zo)|s55\/|sa(ge|ma|mm|ms|ny|va)|sc(01|h\-|oo|p\-)|sdk\/|se(c(\-|0|1)|47|mc|nd|ri)|sgh\-|shar|sie(\-|m)|sk\-0|sl(45|id)|sm(al|ar|b3|it|t5)|so(ft|ny)|sp(01|h\-|v\-|v )|sy(01|mb)|t2(18|50)|t6(00|10|18)|ta(gt|lk)|tcl\-|tdg\-|tel(i|m)|tim\-|t\-mo|to(pl|sh)|ts(70|m\-|m3|m5)|tx\-9|up(\.b|g1|si)|utst|v400|v750|veri|vi(rg|te)|vk(40|5[0-3]|\-v)|vm40|voda|vulc|vx(52|53|60|61|70|80|81|83|85|98)|w3c(\-| )|webc|whit|wi(g |nc|nw)|wmlb|wonu|x700|yas\-|your|zeto|zte\-/i.test(navigator.userAgent.substr(0,4))) {
	                isMobile = true;
	            } else if(!isMobile) {
	                $("#agreementPDF").attr("hidden", false);
	            }
	        } else if (result.cnt == "1") {
	        	var failMsg = "Member has already submitted declaration.";
	        	// Redirect to login page
                Common.alert(failMsg, function(event) {
                    $("#agreementForm").attr({
                        action: "/login/login.do",
                        method: "POST"
                    }).submit();
                });
	        }
        }else{
        	// Redirect to login page
        	var failMsg = "Applicantion is invalid";
            Common.alert(failMsg, function(event) {
                $("#agreementForm").attr({
                    action: "/login/login.do",
                    method: "POST"
                }).submit();
            });
        }
    });
}

function fn_SubmitAgreement() {

    var memberID = $("#memberID").val();

    if($("#reason").val() == '' || $("#isSelect").val() == '' ){
    	Common.alert("* Please fill in all the details");
        return false;
    }

    if ($("#upload1Desc").val() == ""){
        Common.alert("* Supportive document is required.");
        return false;
    }

    if($("#ackMemInfoCheckbox").prop('checked') == false) {
        Common.alert("* Please acknowledge the details");
        return false;
    }

    console.log("submit");

    var data = "",formData = new FormData();

    formData.append(1, myFileCaches[1].file);

    Common.ajax("GET", "/organization/getVaccineSubmitInfo", {memberID: memberID}, function(result){
        console.log(result);

        var cnt = result.cnt;

        if(cnt == "0" ) {
            Common.confirm("Are you sure want to confirm this application?", function() {
                // Update applicant status
            	Common.ajaxFile("/login/attachFileUpload.do", formData, function(result) {
            		console.log("result" + result);
                    if(result != 0 && result.code == 00){
                        $("#form #atchFileGrpId").val(result.data.fileGroupKey);
                        $("#atchFileGrpId").val(result.data.fileGroupKey);
                        console.log("result.data.fileGroupKey" + result.data.fileGroupKey);
                        console.log("atchFileGrpId " + $("#atchFileGrpId").val());
                        Common.ajax("POST", "/organization/updateVaccineDeclaration.do", $("#agreementForm").serializeJSON(), function(result) {
                        	if(result.message == "success.") {
                                var successMsg = "Vaccination info updated successfully";

                                // Redirect to login page
                                Common.alert(successMsg, function(event) {
                                    $("#agreementForm").attr({
                                        action: "/login/login.do",
                                        method: "POST"
                                    }).submit();
                                });
                            }

                        },
                        function(jqXHR, textStatus, errorThrown) {
                            try {
                                Common.alert("Failed To Save" + DEFAULT_DELIMITER + "<b>Failed to update vaccination info.</b>");
                                Common.removeLoader();
                            }
                            catch (e) {
                                console.log(e);
                            }
                        });

                    }else{
                        Common.alert("Attachment Upload Failed" + DEFAULT_DELIMITER + result.message);
                    }
                },function(result){
                    Common.alert("Upload Failed. Please check with System Administrator.");
                });
            })
        } else if(cnt == "1" ) {
            Common.alert("Member has already submitted declaration.");
        }
    });


}

$(function() {
    $('#upload1').change(function(evt) {
        console.log("upload1");
        var file = evt.target.files[0];
        if(file == null && myFileCaches[1] != null){
            delete myFileCaches[1];
        }else if(file != null){
            myFileCaches[1] = {file:file};
        }
        console.log(myFileCaches);
    });

})

</script>

<style>
/* label {
    display: block;
    padding-left: 15px;
    text-indent: -15px;
    text-align: justify;
} */
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
<h2 style="padding-top: 15px;text-align: center;width: 100%;">Notice of Safety Compliance for Non-Vaccinated Individual</h2>
</aside><!-- title_line end -->

<section id = "body">
<%-- <form id="applicantInfo" name="applicantInfo" method="post">
    <input type="hidden" id="memberID" name="memberID" value="${memberID}">
    <input type="hidden" id="atchFileGrpId" name="atchFileGrpId"/>

</form> --%>

<section class="search_table"><!-- search_table start -->
<form action="#" id="searchForm" method="post">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:130px" />
    <col style="width:*" />
</colgroup>
</table><!-- table end -->


</form>
</section><!-- search_table end -->

<form id="agreementForm" style="width: 100%">

    <div id="agreementPDF" style="height: 450px">
        <script>PDFObject.embed("/resources/report/prd/organization/NoticeofSafetyComplianceforNon-VaccinatedIndividual(final).pdf", "#agreementPDF");</script>
    </div>

    <%-- <div id="dlPDF" style="padding-left: 5%; padding-right: 5%">
        <b><font size="4">Please tap on the icon to view the agreement:</font></b>
        <a href="/resources/report/prd/organization/CowayHealthPlannerAgreement.pdf">
            <img src="${pageContext.request.contextPath}/resources/images/common/icon_pdf.png" alt="PDF" class="centerPDF">
        </a>
    </div> --%>

    <div id="declarationTbl" style="padding-top:1%; padding-left: 10%; padding-right: 30%">
        <table class="type1" style="border: none">
            <tbody>

                <tr>
                    <th scope="row" style="width: 20%;"><b>Member Code :</b></th>
                    <td><input type="text" title="Member Code" placeholder="" id="memCode" name="memCode" disabled /></td>
                </tr>
                <tr>
                    <th scope="row"><b>Name :</b></th>
                    <td><input type="text" title="Name" placeholder="" id="fullname" name="fullname" disabled /></td>
                </tr>
                <tr>
                    <th scope="row"><b>NRIC :</b></th>
                    <td><input type="text" title="IC Number" placeholder="" id="nric" name="nric" disabled /></td>
                </tr>
                <tr>
                    <th scope="row"><b>Position :</b></th>
                    <td><input type="text" title="Position" placeholder="" id="position" name="position" disabled /></td>
                </tr>
                <tr>
                <th scope="row"><b>Plan to Vaccine : </b><span class="must">*</span></th>
                  <td>
                  <div>
                  <input type="radio" id="isSelect" name="isSelect" value="Y" style="margin-right: 5px;"/>Plan</div>
                  <p>&nbsp;&nbsp;&nbsp;</p>
                  <div>
                  <input type="radio" id="isSelect" name="isSelect" value="N" style="margin-right: 5px;"/>Do not plan</div></td>
                </tr>
                <tr>
                   <th scope="row"><b>Reason :</b><span class="must">*</span></th>
                    <td><input type="text" title="Reason" placeholder="" id="reason" name="reason"  /></td>
                </tr>
                <tr>
                            <th scope="row"><b>Supportive Doc. : </b><span class="must">*</span></th>
                            <td>
                               <div class="auto_file2">
                                    <input type="file" title="file add" id="upload1" accept="image/*" />
                                    <label>
                                        <input type='text' class='input_text' id="upload1Desc" readonly='readonly' placeholder="Digital Certificate/ Vaccination Card"/>
                                        <span class='label_text'><a href='#'>Upload</a></span>
                                    </label>
                                    <label>
                                    <span class="sample1" style="font-style:italic; font-size:11px;">* Only allow picture format (JPG, PNG, JPEG) <img src="${pageContext.request.contextPath}/resources/images/common/top_btn_help.gif" alt="Sample"/></span>
                                    </label>
                                </div>
                            </td>
                        </tr>
                <tr>
                    <table>
		                <tr>
		                    <td rowspan="2" width="30px"><input type="checkbox" id="ackMemInfoCheckbox" name="ackMemInfoCheckbox" value="1" /></td>
		                    <td>
		                        <span> I hereby declare that the information provided is true and correct. I also understand that any willful dishonesty may render for disciplinary action including dismissal.</span>
		                    </td>
		                </tr>
		                <tr>
		                    <td>
		                        <br/><span style="font-style:italic;"> Dengan ini saya mengaku bahawa segala maklumat yang dikongsi adalah betul dan benar. Saya faham akan tindakan disiplin akan diambil termasuklah pemberhentian kerja jika didapati bersalah memberikan maklumat yang tidak tepat.</span>
		                    </td>
		                </tr>
		            </table>
                </tr>
                <br/>
            </tbody>
        </table>
    </div>
<br/><br/>
    <ul class="center_btns" id="agreementChoices">
        <li><p class="btn_blue"><a href="javascript:fn_SubmitAgreement();">Submit</a></p></li>
    </ul>



<input type="hidden" id="memberID" name="memberID" value="${memberID}">
<input type="hidden" id="memID" name="memID"/>
<input type="hidden" id="atchFileGrpId" name="atchFileGrpId"/>
</form>

</section>

</section><!-- content end -->
