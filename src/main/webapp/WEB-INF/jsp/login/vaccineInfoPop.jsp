<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script src ="${pageContext.request.contextPath}/resources/js/pdfobject.js" type="text/javascript"></script>

<script type="text/javaScript">

var myFileCaches = {};

$(document).ready(function(){
	doGetComboOrder('/common/selectCodeList.do', 480, 'CODE_ID', '','typeOfVaccine', 'S', 'fn_setDefault'); //Vaccine type
	doGetComboOrder('/common/selectCodeList.do', 481, 'CODE_ID', '','reason', 'S', ''); //reason type

	var vacStatus = "${vacInfo.vaccineStatus}";
	console.log("vacStatus: " + vacStatus);
	console.log("vaccineType: " + "${vacInfo.vaccineType}");

	if (vacStatus == "P"){
		Common.alert("Please fill up your Second Dose details.")
		$("#firstDose_yes_div").attr("style", "display:block");
	    $("#firstDose_no_div").attr("style", "display:none");
	    $("#sav_div").attr("style", "display:block");
	    $("#firstDoseNo").attr("disabled", true);
	    $("#firstDoseYes").attr("checked", true);

	    $("#1stDoseDt").attr("disabled", true);
	    $("#1stDoseDt").val("${vacInfo.firstDoseDt}");
	    $("#typeOfVaccine").attr("disabled", true);

	    /* var vacType = parseInt("${vacInfo.vaccineType}");

	    //$("#typeOfVaccine option[value='" + vacType + "']").attr("selected", true);
	    var v = "#typeOfVaccine option[value=" + vacType + "]";
	    $(v).attr("selected", true);
	    debugger; */
	}

});

function fn_setDefault() {
	var vacType = parseInt("${vacInfo.vaccineType}");
	$("#typeOfVaccine option[value='" + vacType + "']").attr("selected", true);
}

$(function() {
	$('#upload1').change(function(evt) {
        var file = evt.target.files[0];
        if(file == null && myFileCaches[1] != null){
            delete myFileCaches[1];
        }else if(file != null){
            myFileCaches[1] = {file:file};
        }
        console.log(myFileCaches);
    });
	$('#upload2').change(function(evt) {
        var file = evt.target.files[0];
        if(file == null && myFileCaches[2] != null){
            delete myFileCaches[2];
        }else if(file != null){
            myFileCaches[2] = {file:file};
        }
        console.log(myFileCaches);
    });

	$('.sample1').hover(function() {
		$('#digitalCertSample').css("display", "block");
	}, function(){
		$('#digitalCertSample').css("display", "none");
	});

	$('.sample2').hover(function() {
        $('#bukuKesihatanSample').css("display", "block");
    }, function(){
        $('#bukuKesihatanSample').css("display", "none");
    });

	$('.sample3').hover(function() {
        $('#pendingApptSample').css("display", "block");
    }, function(){
        $('#pendingApptSample').css("display", "none");
    });
})

function fn_close(){
    $("#vaccineInfoPop").hide();
}

function fn_submit() {
	var valid = true, formData = new FormData();

	/* $.each(myFileCaches, function(n, v) {
        console.log("n : " + n + " v.file : " + v.file);
        formData.append(n, v.file);
    }); */

	if ($("#firstDoseYes").is(":checked")){
		if ($("#1stDoseDt").val() == ""){
			Common.alert("Please fill up [First Dose Date]");
            return false;
		}

		if ($("#typeOfVaccine").val() == ""){
            Common.alert("Please select [Vaccine Type]");
            return false;
        }

		if ($("#typeOfVaccine :selected").val() != '6500' && $("#typeOfVaccine :selected").val() != '6511' && $("#typeOfVaccine :selected").val() != '6514'){
			if (!$("#2ndDoseNo").is(":checked") && $("#2ndDoseDt").val() == ""){
	            Common.alert("Please fill up [Second Dose Date]");
	            return false;
	        }
		}

		if ($("#typeOfVaccine :selected").val() == '6514' && $("#otherVacType").val() == "") {
			Common.alert("Please fill up [Other Vaccine Type]");
            return false;
		}

		if ($("#upload1Desc").val() == ""){
            Common.alert("supportive document is required.");
            return false;
        }

		if (!$("#declareChk").is(":checked")){
			Common.alert("Please confirm the declaration ");
            return false;
		}

		formData.append(1, myFileCaches[1].file);
	} else {

		if ($("#reason :selected").val() != '6504' && $("#reason :selected").val() != '6505' ){
            if ($("#reason :selected").val() == '6501'){ // pregnancy
            	if ($("#pregnancyWeek").val() == ''){
            		Common.alert("Please fill in [Pregnancy Week]");
                    return false;
            	}
            }

            if ($("#reason :selected").val() == '6502'){ // allergic
                if ($("#allergicType").val() == ''){
                    Common.alert("Please fill in [Allergic Type]");
                    return false;
                }
            }

            if ($("#upload2Desc").val() == ""){
                Common.alert("supportive document is required.");
                return false;
            }

            formData.append(1, myFileCaches[2].file);
        } else {
            if ($("#reasonDtl").val() == ''){
                Common.alert("Please fill in reason details");
                return false;
            }
        }

		if (!$("#declareChk").is(":checked")){
            Common.alert("Please confirm the declaration ");
            return false;
        }
    }


	Common.ajaxFile("/login/attachFileUpload.do", formData, function(result) {
        if(result != 0 && result.code == 00){
            //atchFileGrpId = result.data.fileGroupKey;
            //orderVO["atchFileGrpId"] = result.data.fileGroupKey;
            $("#form #atchFileGrpId").val(result.data.fileGroupKey);

            Common.ajax("POST", "/login/vaccineInfoSave.do", $("#form").serializeJSON(), function(result) {
                Common.alert("Vaccination info updated" + DEFAULT_DELIMITER + "<b>"+result.message+"</b>", fn_goMain()); //fn_goMain()
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

}

$("#reason").change(function(){
    if ($("#reason :selected").val() == '6504' || $("#reason :selected").val() == '6505' ){
    	$(".reasonDtlRow").show();
    	$(".pregnantRow").hide();
    	$(".allergyRow").hide();
    	$(".uploadStatusRow").hide();

    } else if ($("#reason :selected").val() == '6501'){ // pregnancy
    	$(".reasonDtlRow").hide();
    	$(".pregnantRow").show();
    	$(".allergyRow").hide();
    	$(".uploadStatusRow").show();
    	$("#upload2Desc").attr("placeholder", "Doctor Letter");
    	$("#sample2").css("display", "block");
    	$("#sample3").css("display", "none");

    } else if ($("#reason :selected").val() == '6502'){ // allergic
        $(".reasonDtlRow").hide();
        $(".pregnantRow").hide();
        $(".allergyRow").show();
        $(".uploadStatusRow").show();
        $("#upload2Desc").attr("placeholder", "Doctor Letter");
        $("#sample2").css("display", "block");
        $("#sample3").css("display", "none");

    } else if ($("#reason :selected").val() == '6503'){ // Pending appointment
        $(".reasonDtlRow").hide();
        $(".pregnantRow").hide();
        $(".allergyRow").hide();
        $(".uploadStatusRow").show();
        $("#upload2Desc").attr("placeholder", "MySejahtera Status");
        $("#sample3").css("display", "block");
        $("#sample2").css("display", "none");
    }
})


$("#firstDoseYes").change(function(){
	if( $(this).is(":checked") ){
		$("#firstDose_yes_div").attr("style", "display:block");
		$("#firstDose_no_div").attr("style", "display:none");
		$("#sav_div").attr("style", "display:block");
	}
})

$("#firstDoseNo").change(function(){
    if( $(this).is(":checked") ){
        $("#firstDose_yes_div").attr("style", "display:none");
        $("#firstDose_no_div").attr("style", "display:block");
        $("#sav_div").attr("style", "display:block");
    }
})

function fn_2ndDoseChk(chk){
	if (chk.checked || $("#typeOfVaccine :selected").val() == '6500' || $("#typeOfVaccine :selected").val() == '6511'){ // johnson & johnson || CanSino
        //$("#2ndDoseDiv").hide();
        $("#2ndDoseDt").val("");
        $("#2ndDoseDt").prop("disabled", true);
  } else {
	  $("#2ndDoseDt").prop("disabled", false);
	  //$("#2ndDoseDiv").show();
  }
}

function fn_vaccineTypeChange(type){

	if (type.value == "6500" || type.value == '6511') { // Johnson & Johnson || CanSino
        $("#2ndDoseNo").prop("disabled", true);
        $("#2ndDoseDt").prop("disabled", true);
        $("#2ndDoseDt").val("");
        $(".otherVac").attr("style", "display:none");

	} else if (type.value == '6514') { // other vaccine type
		$(".otherVac").attr("style", "display:block");

    } else {
    	$("#2ndDoseNo").prop("disabled", false);
    	$(".otherVac").attr("style", "display:none");

    	if ($('#2ndDoseNo').is(':checked')){
            $("#2ndDoseDt").prop("disabled", true);

    	}else {
	        $("#2ndDoseDt").prop("disabled", false);
    	}
    }
}



</script>

</script>

<style>
.option {font-size:18px;font-weight:bold;display:table; margin:0 auto;color:#25527c;}
.pop_body1{height: -webkit-calc(90vh - 70px);height: -moz-calc(90vh - 70px);height: calc(90vh - 70px); padding:30px; background:#fff; border: 2px solid #fff;
                border-radius: 25px;}
.hide1 {  display: none;
    width: auto;
    height: auto;
    position: absolute;
    left: 70%;
    top: 20%;
    z-index: 1001;
}
.submit{margin-top:10%; display:none;}

.otherVac{display:none; margin-top:5px;}

</style>

<div id="vaccineInfoPop" class="popup_wrap size_mid2"><!-- popup_wrap start -->


<section class="pop_body1"><!-- pop_body start -->
<form action="#" method="post" id="form" name="form">
<input type="hidden" id="atchFileGrpId" name="atchFileGrpId"/>
<input type="hidden" id="currVacStatus" name="currVacStatus" value="${vacInfo.vaccineStatus }"/>
        <br/>
        <h1 class="big_text" align="center">Have You Vaccinated?</h1>
        <!--  first dose yes -->
        <br/><br/>
        <span class="option">
            <input type="radio" id="firstDoseYes" name="firstDoseChk" value="yes"/>Yes
            <input type="radio" id="firstDoseNo" name="firstDoseChk" value="no"/>No
        </span>
        <br/><br/><br/>
        <div id="firstDose_yes_div" style="display:none;">
            <table class="type1">
                <caption>table</caption>
				<colgroup>
				    <col style="width:35%" />
				    <col style="width:65%" />
				</colgroup>
				<tbody>
				<tr><th scope="row" colspan="2"><b>Please fill up details:</b></th></tr>
                <tr>
	                <th scope="row" class="firstDose">1st Dose Date <span class="must">*</span></th>
                    <td>
                        <p><input id="1stDoseDt" name="1stDoseDt" type="text" value="" title="1st Dose Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
                    </td>
                </tr>
                <tr>
	                <th scope="row" class="firstDose">Type of Vaccine <span class="must">*</span></th>
	                <td style="margin:10px">
	                   <select id="typeOfVaccine" name="typeOfVaccine" class="w100p" onchange="fn_vaccineTypeChange(this)"></select>

	                   <p class="otherVac"><input id="otherVacType" name="otherVacType" type="text" value="" title="Other Type Of Vaccine" placeholder="Other Type Of Vaccine" class="w100p" /></p>
	                </td>
	            </tr>

	           </tbody>
            </table>

            <br/><br/>
	            <input type="checkbox" id="2ndDoseNo" name="2ndDoseNo" onChange="fn_2ndDoseChk(this)"/> <span  class="bold_text">I have not taken my 2nd dose yet</span>
	            <table class="type1">
	               <caption>table</caption>
	                <colgroup>
	                    <col style="width:35%" />
	                    <col style="width:65%" />
	                </colgroup>
	                <tbody>
			            <tr>
		                    <th scope="row">2nd Dose Date</th>
		                    <td>
		                        <p><input id="2ndDoseDt" name="2ndDoseDt" type="text" value="" title="2nd Dose Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
		                    </td>
		                </tr>
		                <tr><td colspan='2'></td></tr>
		                <tr>
		                    <th scope="row">Supportive Doc.</th>
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
		             </tbody>
                </table>
        </div>

        <!-- first dose yes end -->

        <!-- first dose no -->

        <div id="firstDose_no_div" style="display:none;">
            <table class="type1">
            <caption>table</caption>
                <colgroup>
                    <col style="width:35%" />
                    <col style="width:65%" />
                </colgroup>
                <tbody>
                <tr>
                    <th scope="row">Reason</th>
                    <td>
                        <select id="reason" name="reason"/>
                    </td>
                </tr>
                <tr class="pregnantRow" style="display:none">
                    <th scope="row">Week of Pregnancy <span class="must">*</span></th>
                    <td><input type="text" id="pregnancyWeek" name="pregnancyWeek"/></td>
                </tr>
                <tr class="allergyRow" style="display:none">
                    <th scope="row">Type of Allergic <span class="must">*</span></th>
                    <td><input type="text" id="allergicType" name="allergicType"/></td>
                </tr>
                <tr class="uploadStatusRow" style="display:none">
                    <th scope="row">Supportive Doc. <span class="must">*</span></th>
                    <td>
                       <div class="auto_file2">
                            <input type="file" title="upload document" id="upload2" accept="image/*" />
                            <label>
                                <input type='text' class='input_text' id="upload2Desc" readonly='readonly' placeholder=""/>
                                <span class='label_text'><a href='#'>Upload</a></span>
                            </label>
                            <label>
                                <span style="font-style:italic; font-size:11px;">* Only allow picture format (JPG, PNG, JPEG)</span>

                            </label>
                            <span id="sample2" class="sample2" style="display:none;"><img src="${pageContext.request.contextPath}/resources/images/common/top_btn_help.gif" alt="Sample"/></span>
                                <span id="sample3" class="sample3" style="display:none;"><img src="${pageContext.request.contextPath}/resources/images/common/top_btn_help.gif" alt="Sample"/></span>
                        </div>
                    </td>
                </tr>
                <tr class="reasonDtlRow" style="display:none">
                    <th scope="row">Detail of Reason <span class="must">*</span></th>
                    <td>
                       <textarea cols="20" rows="5" placeholder="please write down your reason" id="reasonDtl" name="reasonDtl"/>
                    </td>
                </tr>
                </tbody>
            </table>
        </div>
        <div id='sav_div' class="submit">
            <p style="font-weight:bold; text-decoration: underline; margin-bottom: 5px;">Declaration and acknowledgement: </p>
            <table>
                <tr>
                    <td rowspan="2" width="30px">
                        <input type="checkbox" id="declareChk" name="declareChk" />
                    </td>
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
            <br/><br/>
	      <ul class="center_btns">
	        <li><p class="btn_blue2">
	            <a href="#" onclick="javascript:fn_submit()">Submit</a>
	          </p></li>
	      </ul>
	    </div>
        </div>

</form>


</section>
<div class="hide1" id="digitalCertSample">
      <img src="${pageContext.request.contextPath}/resources/images/common/vaccination/digital_cert.jpg" alt="DigitalCert" style="height: 450px;width: auto;"/>
</div>
<div class="hide1" id="pendingApptSample" >
      <img src="${pageContext.request.contextPath}/resources/images/common/vaccination/vac_pending_appt.jpg" alt="Pending Appointment" style="height: 450px;width: auto;"/>
</div>
<div class="hide1" id="bukuKesihatanSample">
      <img src="${pageContext.request.contextPath}/resources/images/common/vaccination/buku-b-all.jpg" alt="Buku Kesihatan" style="height: 450px;width: auto;"/>
</div>
</div>