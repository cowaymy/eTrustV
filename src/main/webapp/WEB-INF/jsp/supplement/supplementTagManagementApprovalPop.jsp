<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javascript">
//생성 후 반환 ID
var purchaseGridID;
var serialTempGridID;
var memGridID;
var paymentGridID;
var myFileCaches = {};
var atchFileGrpId = 0;

$(document).ready(function() {



        $("#btnLedger").click(function() {
            //Common.popupDiv("/sales/pos/posSystemPop.do", '', null , true , '_insDiv');
            Common.popupDiv("/supplement/orderLedgerViewPop.do", '', null , true , '_insDiv');
        });


    //Member Search Popup
    $('#memBtnPop').click(function() {
        var callParam = {callPrgm : "1"};
        Common.popupDiv("/common/memberPop.do", callParam, null, true);
    });

    $('#salesmanPopCd').change(function(event) {

        var memCd = $('#salesmanPopCd').val().trim();

        if(FormUtil.isNotEmpty(memCd)) {
            fn_loadOrderSalesman(0, memCd, 1);
        }
    });

    //Save Btn
    $("#_saveBtn").click(function() {


    	var inchgDeptList =  $("#inchgDeptList").val();
        var ddlSubDeptUpd =  $("#ddlSubDeptUpd").val();
        var tagStus =  $("#tagStusPop").val();
        var attachment = $("#attch").val().trim();
        var remark = $("#_remark").val().trim();
        var counselingNo = $("#_infoCounselingNo").val();
        var ccr0006dCallEntryIdSeq = $("#_infoCcr0006dCallEntryIdSeq").val();
        var attchFilePathName = "attchFilePathName";
        var preTagStatus =  $("#_infoTagStatus").val();
        var preTagStatusId =  $("#_infoTagStatusId").val();
        var subTopicId =  $("#_infoSubTopicId").val();
        var subTopic =  $("#_infoSubTopic").val();

        var supRefId =  $("#_infoSupRefId").val();
        var supRefNo = $("#_infoSupRefNo").val();




        console.log("inchgDeptList :: " + inchgDeptList);
        console.log("ddlSubDeptUpd :: " + ddlSubDeptUpd);
        console.log("tagStus :: " + tagStus);
        console.log("attachment :: " + attachment);
        console.log("remark :: " + remark);
        console.log("counselingNo :: " + counselingNo);
        console.log("ccr0006dCallEntryIdSeq :: " + ccr0006dCallEntryIdSeq);
        console.log("preTagStatus :: " + preTagStatus);
        console.log("preTagStatusId :: " + preTagStatusId);
        console.log("subTopicId :: " + subTopicId);
        console.log("subTopic :: " + subTopic);

        console.log("supRefId :: " + supRefId);
        console.log("supRefNo :: " + supRefNo);


        var param = {supRefId: supRefId, supRefNo: supRefNo, mainDept: inchgDeptList,  subDept : ddlSubDeptUpd, tagStus : tagStus, remark : remark, counselingNo : counselingNo, ccr0006dCallEntryIdSeq : ccr0006dCallEntryIdSeq , preTagStatusId : preTagStatusId , subTopicId : subTopicId};


    	 if (!fn_validInpuInfo()) {
             return false;
         }


    	 if (FormUtil.isNotEmpty($('#attch').val().trim())) {

    		 console.log("Attachment found...");

    	     var formData = new FormData();
    	      $.each(myFileCaches, function(n, v) {
    	        //console.log("n : " + n + " v.file : " + v.file);
    	        formData.append(n, v.file);
    	        formData.append(attchFilePathName, "tagApproval");
    	      });

    		 var orderVO = {
    	              supRefId :  $("#_infoSupRefId").val(),
    	              mainDept : $('#inchgDeptList').val().trim(),
    	              subDept : $('#ddlSubDept').val(),
    	              callRemark : $('#_remark').val().trim(),
    	              atchFileGrpId : atchFileGrpId,
    	              attchFilePathName : "attchFilePathName"
    	      };

    		 if (!fn_validFile()) {
                 return false;
             }

    		 console.log("Attachment value::" + $("#attch").val());

             Common.ajaxFile("/supplement/attachFileUploadId.do", formData, function(result) {

                 console.log("result attachFileUploadId:: " + result.code);

                   if (result != 0 && result.code == 00) {
                       orderVO["atchFileGrpId"] = result.data.fileGroupKey;
                     } else {
                       Common.alert('Save Tag Approval'+ DEFAULT_DELIMITER + result.message);
                     }

                   Common.ajax("POST", "/supplement/updateTagInfo.do", param, function(result) {
                       if(result.code == "00") {//successful update
                           console.log("Success");
                           Common.alert(" The tracking number for "+ supRefNo + " has been update successfully." , fn_popClose());

                       } else {
                           console.log("failed");
                           Common.alert(result.message,fn_popClose);
                          }
                    });
             },

                 function(result) {
                   Common.alert("Upload Failed. Please check with System Administrator.");
                 });

         }else {
        console.log("no attachment found... ELSE case");

        Common.ajax("POST", "/supplement/updateTagInfo.do", param, function(result) {
            if(result.code == "00") {//successful update
                console.log("Success");
                Common.alert(" The tracking number for "+ supRefNo + " has been update successfully." , fn_popClose());
            } else {
                console.log("failed");
                Common.alert(result.message,fn_popClose);
               }
            });
         }
    });
});

$('#attch').change(function(evt) {
    handleFileChange(evt, 1);
});

function fn_validFile() {
    var isValid = true, msg = "";

    if (FormUtil.isEmpty($('#attch').val().trim())) {
        isValid = false;
        msg += 'Attachment is required.';
    }

    $.each(myFileCaches,function(i, j) {
                        if (myFileCaches[i].file.checkFileValid == false) {
                            isValid = false;
                            msg += myFileCaches[i].file.name + '<spring:message code="supplement.alert.fileUploadFormat" />';
                        }
                    });

    if (!isValid)
        Common.alert('Save New Tag Submission'+ DEFAULT_DELIMITER + "<b>" + msg + "</b>");

    return isValid;
}

// Define a common function to handle file input changes
function handleFileChange(evt, cacheIndex) {
    var file = evt.target.files[0];
    if (file == null && myFileCaches[cacheIndex] != null) {
        delete myFileCaches[cacheIndex];
    } else if (file != null) {
        myFileCaches[cacheIndex] = {
            file : file
        };
    }

    var msg = '';
    if (file && file.name.length > 30) {
        msg += "*File name wording should be not more than 30 alphabet.<br>";
    }

/*       var fileType = file ? file.type.split('/') : [];
    if (fileType[1] != 'jpg' && fileType[1] != 'jpeg' && fileType[1] != 'png' && fileType[1] != 'pdf') {
        msg += "*Only allow picture format (JPG, PNG, JPEG, PDF).<br>";
    } */

    if (file && file.size > 2000000) {
        msg += "*Only allow .zip file with less than 2MB.<br>";
    }

    if (msg) {
        myFileCaches[cacheIndex].file['checkFileValid'] = false;
        Common.alert(msg);
    } else {
        myFileCaches[cacheIndex].file['checkFileValid'] = true;
    }

    console.log("myFileCaches::" + myFileCaches);
}

function fn_validFile() {
    var isValid = true, msg = "";

    if (FormUtil.isEmpty($('#attch').val().trim())) {
        isValid = false;
        msg += 'Attachment is required.';
    }

    $.each(myFileCaches,function(i, j) {
                        if (myFileCaches[i].file.checkFileValid == false) {
                            isValid = false;
                            msg += myFileCaches[i].file.name + '<spring:message code="supplement.alert.fileUploadFormat" />';
                        }
                    });

    if (!isValid)
        Common.alert('Save New Tag Submission'+ DEFAULT_DELIMITER + "<b>" + msg + "</b>");

    return isValid;
}

//Close
function fn_popClose(){
	myFileCaches = {};
    $("#_systemClose").click();
}

function fn_bookingAndpopClose(){
    $("#_systemClose").click();
}

function fn_validInpuInfo() {
    var isValid = true, msg = "";

    if(null == $("#inchgDeptList").val() || '' == $("#inchgDeptList").val()){
        isValid = false;
        msg += 'InCharge Department is required.';
    }

    else if( null == $("#ddlSubDeptUpd").val() || '' == $("#ddlSubDeptUpd").val()){
        isValid = false;
        msg += 'Sub Department is required.';
    }

    else if( null == $("#tagStusPop").val() || '' == $("#tagStusPop").val()){
        isValid = false;
        msg += 'Tag Status is required.';
    }

    if (!isValid)Common.alert('Update Tag Submission'+ DEFAULT_DELIMITER + "<b>" + msg + "</b>");

    return isValid;
}

function fn_removeFile(name){
    if(name == "attch") {
       $("#attch").val("");
       $('#attch').change();
    }
  }

 function fn_inchgDept_SelectedIndexChanged() {
    $("#ddlSubDeptUpd option").remove();
    doGetCombo('/supplement/getSubDeptList.do?DEFECT_GRP_DEPT=' + $("#inchgDeptList").val(), '', '', 'ddlSubDeptUpd', 'S', '');
    }

</script>
<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<input type="hidden" id="_infoParcelTrackNo" value="${orderInfo.parcelTrackNo}">
<input type="hidden" id="_infoSupRefStus" value="${orderInfo.supRefStusId}">
<input type="hidden" id="_infoSupRefStg" value="${orderInfo.supRefStgId}">
<input type="hidden" id="_infoSupRefId" value="${orderInfo.supRefId}">
<input type="hidden" id="_infoSupRefNo" value="${orderInfo.supRefNo}">
<input type="hidden" id="_infoCustName" value="${orderInfo.custName}">
<input type="hidden" id="_infoCustEmail" value="${orderInfo.custEmail}">
<input type="hidden" id="_infoCounselingNo" value="${tagInfo.counselingNo}">
<input type="hidden" id="_infoTagStatus" value="${tagInfo.tagStatus}">
<input type="hidden" id="_infoTagStatusId" value="${tagInfo.tagStatusId}">
<input type="hidden" id="_infoSubTopicId" value="${tagInfo.subTopicId}">
<input type="hidden" id="_infoSubTopic" value="${tagInfo.subTopic}">

<input type="hidden" id="_infoCcr0006dCallEntryIdSeq" value="${tagInfo.ccr0006dCallEntryIdSeq}">


<header class="pop_header">
<h1>Supplement Tag Management - Approval</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a id="_systemClose"><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->



<section class="tap_wrap">
<!------------------------------------------------------------------------------
    Supplement Detail Page Include START
------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/jsp/supplement/tagManagementContent.jsp" %>
<!------------------------------------------------------------------------------
    Supplement Detail Page Include END
------------------------------------------------------------------------------->
</section>
<br/>

<aside class="title_line"><!-- title_line start -->
<h2>Tag Approval</h2>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
    <col style="width:180px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="service.text.InChrDept" /></th>
    <td colspan="3">
        <select class="select w100p" id="inchgDeptList" name="inchgDeptList" onChange="fn_inchgDept_SelectedIndexChanged()">
                <option value="">Choose One</option>
                <c:forEach var="list" items="${inchgDept}" varStatus="status">
                  <option value="${list.codeId}">${list.codeName}</option>
                </c:forEach>
        </select>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="service.grid.subDept" /></th>
    <td colspan="3">
    <select id='ddlSubDeptUpd' name='ddlSubDeptUpd' class="w100p"></select>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="supplement.text.supplementTagStus" /></th>
    <td colspan="3">
            <select class="select w100p"  id="tagStusPop" name=""tagStusPop"">
            <option value="">Choose One</option>
                <c:forEach var="list" items="${tagStus}" varStatus="status">
                  <option value="${list.codeId}">${list.codeName}</option>
                </c:forEach>
              </select>
            </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.attachment" /></th>
    <!-- <td colspan = "3">
           <div class="auto_file">
                    <input type="file" title="file add" id="payFile" accept="image/jpg, image/jpeg, image/png, application/pdf" />
           </div>
     </td> -->
     <td colspan="3">
              <div class="auto_file2">
                <input type="file" title="" id="attch" accept=".zip" />
                <label>
                  <input type='text' class='input_text' id='labelFileInput' readonly='readonly' />
                  <span class='label_text' id='labelFileInput'><a href='#'><spring:message code='sys.btn.upload' /></a></span>
                </label>
                <span class='label_text'><a href='#' onclick='fn_removeFile("attch")'><spring:message code='sys.btn.remove' /></a></span>
              </div>
            </td>
</tr>
<tr>
    <th scope="row"><spring:message code="service.title.Remark" /></th>
    <td colspan="3">
        <input type="text" title="" placeholder="Remark" class="w100p" id="_remark" " name="remark" />
    </td>
</tr>
</br>
</tbody>
</table><!-- table end -->

<ul class="center_btns">
    <li><p class="btn_blue2"><a id="_saveBtn"><spring:message code="sal.btn.save" /></a></p></li>
</ul>

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->