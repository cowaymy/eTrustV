<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript" language="javascript">

    //AUIGrid 생성 후 반환 ID
    var listGiftGridID;
    var update = new Array();
    var remove = new Array();
    var myFileCaches = {};
    var deactAtchFileId = 0;
    var deactAtchFileName = "";

    var MEM_TYPE = '${SESSION_INFO.userTypeId}';
    var BranchId = '${SESSION_INFO.userBranchId}';
    var returnStatusOption = [{"codeId": "494","codeName": "Stock Return"},{"codeId": "495","codeName": "Condition Update"}];
    var returnConditionOption = [{"codeId": "111","codeName": "Used"},{"codeId": "112","codeName": "Defect"}];

    $(document).ready(function(){

    	setText();

    	var action = '${movementType}';
    	console.log("action " + action);
    	if(action == '1'){
    		$("#editArea1Form").attr("style","display:inline");

    		var branchId= '${headerDetail.branchId}';
            var param = {searchlocgb:'04' ,
                    searchBranch: (branchId !="" ? branchId : "" )}
            doGetComboData('/common/selectStockLocationList2.do', param , '', 'cmdMemberCode1', 'S','');
    	}else if(action == '2'){
    		$("#editArea2Form").attr("style","display:inline");
    		doDefCombo(returnStatusOption, '', 'returnStatus', 'S', '');
    		doDefCombo(returnConditionOption, '', 'returnCondition', 'S', '');
    	}else if(action == '3'){
            $("#editArea3Form").attr("style","display:inline");
            doGetComboOrder('/common/selectCodeList.do', '496', 'CODE_ID', '', 'deactReason', 'S', ''); //Common Code
        }

    	$("#returnStatus").change(function() {
    		var returnStatus = $("#returnStatus").val();
    		console.log("returnStatus " + returnStatus);
    		if(FormUtil.isNotEmpty(returnStatus)) {
    			doGetComboOrder('/common/selectCodeList.do', returnStatus, 'CODE_ID', '', 'returnReason', 'S', ''); //Common Code
    		}
        });
    });

    function setText(result){
    	 var date = new Date(Date.now());
    	 $("#serialNoTxt").html('${headerDetail.serialNo}');
    	 $("#serialNoChg").val('${headerDetail.serialNo}');
    	 $("#model").html('${headerDetail.model}');
    	 $("#status").html('${headerDetail.status}');
    	 $("#condition").html('${headerDetail.condition}');
    	 $("#filterSn").html('${headerDetail.filterSn}');
    	 $("#filterChgDt").html('${headerDetail.filterChgDt}');
    	 $("#branchLoc").html('${headerDetail.branchLoc}');
    	 $("#holderLoc").html('${headerDetail.holderLoc}');
    	 $("#consignDt").html(date.toLocaleString('en-GB', { hour12:false }));
    	 $("#updateDt").html(date.toLocaleString('en-GB', { hour12:false }));
    }

    function fn_loadAtchment(atchFileGrpId) {
        Common.ajax("Get", "/sales/order/selectAttachList.do", {atchFileGrpId :atchFileGrpId} , function(result) {
           if(result) {
                if(result.length > 0) {
                    $("#attachTd").html("");
                    for ( var i = 0 ; i < result.length ; i++ ) {
                        switch (result[i].fileKeySeq){
                        case '1':
                        	deactAtchFileId = result[i].atchFileId;
                        	deactAtchFileName = result[i].atchFileName;
                            $(".input_text[id='deactAtchFileTxt']").val(deactAtchFileName);
                            break;
                         default:
                             Common.alert("no files");
                        }
                    }

                    // 파일 다운
                    $(".input_text").dblclick(function() {
                        var oriFileName = $(this).val();
                        var fileGrpId;
                        var fileId;
                        for(var i = 0; i < result.length; i++) {
                            if(result[i].atchFileName == oriFileName) {
                                fileGrpId = result[i].atchFileGrpId;
                                fileId = result[i].atchFileId;
                            }
                        }
                        if(fileId != null) fn_atchViewDown(fileGrpId, fileId);
                    });
                }
            }
       });
    }

    function fn_atchViewDown(fileGrpId, fileId) {
        var data = {
                atchFileGrpId : fileGrpId,
                atchFileId : fileId
        };

        console.log(data);
        Common.ajax("GET", "/eAccounting/webInvoice/getAttachmentInfo.do", data, function(result) {
            console.log(result)
            var fileSubPath = result.fileSubPath;
            fileSubPath = fileSubPath.replace('\', '/'');

            if(result.fileExtsn == "jpg" || result.fileExtsn == "png" || result.fileExtsn == "gif") {
                console.log(DEFAULT_RESOURCE_FILE + fileSubPath + '/' + result.physiclFileName);
                window.open(DEFAULT_RESOURCE_FILE + fileSubPath + '/' + result.physiclFileName);
            } else {
                console.log("/file/fileDownWeb.do?subPath=" + fileSubPath + "&fileName=" + result.physiclFileName + "&orignlFileNm=" + result.atchFileName);
                window.open("/file/fileDownWeb.do?subPath=" + fileSubPath + "&fileName=" + result.physiclFileName + "&orignlFileNm=" + result.atchFileName);
            }
        });
    }

    $(function(){
        $('#deactAtchFile').change( function(evt) {
        	console.log("deact change in");
            var file = evt.target.files[0];
            if(file == null){
                remove.push(deactAtchFileId);
            }else if(file.name != deactAtchFileName){
                 myFileCaches[1] = {file:file};
                 if(deactAtchFileName != ""){
                     update.push(deactAtchFileId);
                 }
             }
        });
    });

    function fn_removeFile(name){
        if(name == "DEACT") {
            console.log("deact in");
             $("#deactAtchFile").val("");
             $(".input_text[id='deactAtchFileTxt']").val("");
             $('#deactAtchFile').change();
        }
    }

    function fn_checkEmpty(){
        var checkResult = true;

        var action = $("#movementType").val();
        console.log("save action " + action);
        if(action == '1'){
            if(FormUtil.isEmpty($("#cmdMemberCode1").val()) ) {
                Common.alert('Please select a Cody to proceed.');
                checkResult = false;
                return checkResult;
            }
        }else if(action == '2'){
            if(FormUtil.isEmpty($("#returnStatus").val()) ) {
                Common.alert('Please select status.');
                checkResult = false;
                return checkResult;
            }else if(FormUtil.isEmpty($("#returnReason").val()) ) {
                Common.alert('Please select reason.');
                checkResult = false;
                return checkResult;
            }else if(FormUtil.isEmpty($("#returnCondition").val()) ) {
                Common.alert('Please select condition.');
                checkResult = false;
                return checkResult;
            }else if(FormUtil.isEmpty($("#returnRemark").val()) && $("#returnReason").val() == '6615') {
                Common.alert('Please fill in remark.');
                checkResult = false;
                return checkResult;
            }
        }else if(action == '3'){
            if(FormUtil.isEmpty($("#deactReason").val()) ) {
                Common.alert('Please select reason.');
                checkResult = false;
                return checkResult;
            }else if(FormUtil.isEmpty($("#returnRemark").val()) && $("#deactReason").val() == '6618') {
                Common.alert('Please fill in remark.');
                checkResult = false;
                return checkResult;
            }
        }

        return checkResult;
    }

    $(function(){
        $('#btnSave').click(function() {
            console.log("btnSave clicked")
            var checkResult = fn_checkEmpty();
            if(!checkResult) {
                return false;
            }

            fn_doSaveHiCareEdit();

        });
    });

    function fn_doSaveHiCareEdit(){
    	var action = $("#movementType").val();
        console.log("save action " + action);
        var data;

        if(action == '1'){
        	var data = $("#editArea1Form").serializeJSON();
        	$.extend(data,
                    {
        		"serialNo":$("#serialNoChg").val()
        		,"movementType":$("#movementType").val()
                    }
                    );
        }else if(action == '2'){
        	var data = $("#editArea2Form").serializeJSON();
        	$.extend(data,
                    {
        		"serialNo":$("#serialNoChg").val()
                ,"movementType":$("#movementType").val()
                    }
                    );
        }else if(action == '3'){
        	var data = $("#editArea3Form").serializeJSON();
        	$.extend(data,
                    {
        		"serialNo":$("#serialNoChg").val()
                ,"movementType":$("#movementType").val()
                    }
                    );
        }

        if(action == '3'){
        	debugger;
        	var formData = new FormData();
            //formData.append("atchFileGrpId", '${eSvmInfo.atchFileGrpId}');
            formData.append("update", JSON.stringify(update).replace(/[\[\]\"]/gi, ''));
            formData.append("remove", JSON.stringify(remove).replace(/[\[\]\"]/gi, ''));
            formData.append("serialNo",$("#serialNoChg").val());
            $.each(myFileCaches, function(n, v) {
                console.log(v.file);
                formData.append(n, v.file);
            });


        	Common.ajaxFile("/services/hiCare/attachHiCareFileUpload.do", formData, function(result) {
                if(result.code == 99){
                    Common.alert("Attachment Upload Failed" + DEFAULT_DELIMITER + result.message);
                }else{
                	Common.ajax("POST", "/services/hiCare/saveHiCareEdit.do", data, function(result) {
                        console.log( result);

                        if(result == null){
                            Common.alert("Record cannot be update.");
                        }else{
                            Common.alert("Record has been updated.");
                            $('#editPop').remove();
                            $("#search").click();
                            window.close();
                        }
                   });
                }
            },function(result){
                Common.alert(result.message+"<br/>Upload Failed. Please check with System Administrator.");
            });
        }else{
        	Common.ajax("POST", "/services/hiCare/saveHiCareEdit.do", data, function(result) {
                console.log( result);

                if(result == null){
                    Common.alert("Record cannot be update.");
                }else{
                    Common.alert("Record has been updated.");
                    $('#editPop').remove();
                    $("#search").click();
                    window.close();
                }
           });
        }
    }

    function fn_close() {
        $("#popup_wrap").remove();
    }

    function fn_closePreOrdModPop() {
        myFileCaches = {};
        delete update;
        delete remove;
        $('#editPop').remove();
    }
</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Hi-Care Movement</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a id="btnPreOrdClose" onClick="javascript:fn_closePreOrdModPop();" href="#">CLOSE | TUTUP</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->
<section id="headerArea" class="">
<aside class="title_line">
        <h3>Header Info</h3>
    </aside>
<form id="headForm" name="headForm" method="post">
            <table class="type1">
                <!-- table start -->
                <caption>table</caption>
                <colgroup>
                    <col style="width: 140px" />
                    <col style="width: *" />
                    <col style="width: 140px" />
                    <col style="width: *" />
                    <col style="width: 180px" />
                    <col style="width: *" />
                </colgroup>
                <tbody>
                    <tr>
                        <th scope="row">Serial No.</th>
                        <td colspan="3"><span id='serialNoTxt' ></span></td>
                        <th scope="row">Model</th>
                        <td colspan="3"><span id='model' ></span></td>
                    </tr>
                    <tr>
                        <th scope="row">Status</th>
                        <td colspan="3"><span id='status' ></span></td>
                        <th scope="row">Condition</th>
                        <td colspan="3"><span id='condition' ></span></td>
                    </tr>
                    <tr>
                        <th scope="row">Sediment Filter Serial No.</th>
                        <td colspan="3"><span id='filterSn' ></span></td>
                        <th scope="row">Filter Last Change Date</th>
                        <td colspan="3"><span id='filterChgDt' ></span></td>
                    </tr>
                    <tr>
                        <th scope="row">Branch Code</th>
                        <td colspan="3"><span id='branchLoc' ></span></td>
                        <th scope="row">Member Code</th>
                        <td colspan="3"><span id='holderLoc' ></span></td>
                    </tr>
                    <tr>
                        <th scope="row">Consign Date</th>
                        <td colspan="3"><span id='consignDt' ></span></td>
                        <th scope="row">Update Date</th>
                        <td colspan="3"><span id='updateDt' ></span></td>
                    </tr>
                </tbody>
            </table>
            <!-- table end -->
        </form>

</section>
<section id="editArea" class="">

<aside class="title_line">
    <h3>Edit Info</h3>
</aside>
<form id="editArea1Form" name="editArea1Form" action="#" method="post" style="display:none">
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:160px" />
    <col style="width:*" />
    <col style="width:170px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code='service.grid.memberCode'/></th>
	    <td>
	        <select id="cmdMemberCode1" name="cmdMemberCode1" class="w100p">
	    </td>
</tr>
</tbody>
</table><!-- table end -->
</form>

<form id="editArea2Form" name="editArea2Form" action="#" method="post" style="display:none">
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:160px" />
    <col style="width:*" />
    <col style="width:170px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Status Update<span class="must">*</span></th>
        <td>
            <select id="returnStatus" name="returnStatus" class="w100p">
        </td>
</tr>
<tr>
    <th scope="row">Reason<span class="must">*</span></th>
    <td>
        <select id="returnReason" name="returnReason" class="w100p">
    </td>
</tr>
<tr>
    <th scope="row">Condition<span class="must">*</span></th>
    <td>
        <select id="returnCondition" name="returnCondition" class="w100p">
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.remark" /></th>
    <td>
        <textarea cols="20" id="returnRemark" name="returnRemark" placeholder="Remark"></textarea>
    </td>
</tr>
</tbody>
</table><!-- table end -->
</form>

<form id="editArea3Form" name="editArea3Form" action="#" method="post" style="display:none">
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:160px" />
    <col style="width:*" />
    <col style="width:170px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Deactivate Reason<span class="must">*</span></th>
        <td>
            <select id="deactReason" name="deactReason" class="w100p">
        </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.remark" /></th>
    <td>
        <textarea cols="20" id="deactRemark" name="deactRemark" placeholder="Remark"></textarea>
    </td>
</tr>
<tr>
            <th scope="row">Attachment</th>
            <td>
                <div name='uploadfiletest' class='auto_file2'>
                    <input type='file' title='file add'  id='deactAtchFile' accept='image/*''/>
                    <label style="width: 400px;">
                        <input type='text' class='input_text' readonly='readonly' id='deactAtchFileTxt'/>
                        <span class='label_text attach_mod'><a href='#'>Upload</a></span>
                        <span class='label_text attach_mod'><a href='#' onclick='fn_removeFile("DEACT")'>Remove</a></span>
                    </label>
                </div>
            </td>
        </tr>
</tbody>
</table><!-- table end -->
</form>

<input type="hidden" name="movementType" id="movementType" value="${movementType}"/>
<input type="hidden" name="serialNoChg" id="serialNoChg" value="${headerDetail.serialNo}"/>

<ul class="center_btns mt20">
    <li><p class="btn_blue2 big"><a id="btnSave" href="#">Save</a></p></li>
</ul>
</section>
</section><!-- pop_body end -->

</div><!-- popup_wrap end -->
