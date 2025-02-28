<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/homecare-js-1.0.js"></script>

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
    var returnConditionOption = [{"codeId": "111","codeName": "Used"},{"codeId": "112","codeName": "Defect"},{"codeId": "122","codeName": "Repair"},{"codeId": "7","codeName": "Obsolete"}];

    $(document).ready(function(){

    	$("#temp4").hide();

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

    	$("#_filterTxtBarcode").change(function() {
            event.preventDefault();
            $('#_filterTxtBarcode').val($('#_filterTxtBarcode').val().toUpperCase());
            fn_splitUsedBarcode();
        });

        $('#returnCondition').change(function(event){
            var condition = $("#returnCondition").val();
            if(condition == 112){ // Defect
            	 doGetComboOrder('/common/selectCodeList.do', '613', 'CODE_ID', '', 'returnDefectType', 'S', ''); //Defect Type - this part need to be change once COR is done
                $("#defectTypeField").show();

            }else{

                $("#defectTypeField").hide();
                $("#returnDefectType").val("");
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
    	 $("#holderLoc").html("${headerDetail.holderLoc}");
    	 $("#consignDt").html(date.toLocaleString('en-GB', { hour12:false }));
    	 $("#updateDt").html(date.toLocaleString('en-GB', { hour12:false }));


    	 $("#_filterTxtBarcode").val('${headerDetail.filterSn}');
    	 var filterChgDt=$("#filterChgDt").html();
    	 if(filterChgDt){
    		 $("#_chgdt").val('${headerDetail.filterChgDt}');
    	 }else{
    		 $("#_chgdt").val('${headerDetail.filterChgDt}').val(new Date().toLocaleDateString('en-GB', {
                 day: '2-digit',
                 month: '2-digit',
                 year: 'numeric'
             }).split('/').join('/'));
    	 }

    	 if(!($("#_filterTxtBarcode").val() == null || $("#_filterTxtBarcode").val()== "")){
    		 $("#_filterTxtBarcode").attr("disabled" , "disabled");
    		 $("#_chgdt").attr("disabled" , "disabled");
    	 }
    }

    function fn_splitUsedBarcode(){
        if($("#_filterTxtBarcode").val() != null || js.String.strNvl($("#_filterTxtBarcode").val()) != ""){
               var BarCodeArray = $("#_filterTxtBarcode").val().toUpperCase().match(/.{1,18}/g);

               var unitType = "EA";
               var failSound = false;
               var rowData = {};
               var barInfo = [];
               var boxInfo = [];
               var stockCode = "";

               console.log("BarCodeArray " + BarCodeArray);
               console.log("BarCodeArray.length " + BarCodeArray.length);
               for (var i = 0 ; i < BarCodeArray.length ; i++){
                   console.log("BarCodeArray[i] " + BarCodeArray[i]);

                   if( BarCodeArray[i].length < 18 ){
                       failSound = true;
                       Common.alert("Serial No. less than 18 characters.");
                       $("#_filterTxtBarcode").val("");
                       $("#_filterTxtBarcode").focus();
                       continue;
                   }

                   stockCode = BarCodeArray[i].substr(3,5);

                   if(stockCode == "0"){
                       failSound = true;
                       Common.alert("Serial No. Does Not Exist.");
                       $("#_filterTxtBarcode").val("");
                       $("#_filterTxtBarcode").focus();
                       continue;
                   }else if(!(stockCode == "02F5V" || stockCode == "04KNH")){
                       failSound = true;
                       Common.alert("Serial No. is not valid.");
                       $("#_filterTxtBarcode").val("");
                       $("#_filterTxtBarcode").focus();
                       continue;
                   }
               }
           }
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
            }else if(FormUtil.isEmpty($("#_filterTxtBarcode").val()) ) {
                Common.alert('Please fill in Filter Serial No.');
                checkResult = false;
                return checkResult;
            }else if(FormUtil.isEmpty($("#_chgdt").val()) ) {
                Common.alert('Please select Filter Last Changed Date.');
                checkResult = false;
                return checkResult;
            }
        }else if(action == '2'){

        	var holderLoc = $("#holderLocChg").val().trim();

            if(FormUtil.isEmpty($("#returnStatus").val()) ) {
                Common.alert('Please select status.');
                checkResult = false;
                return checkResult;
            }else if(holderLoc == '' &&  $("#returnStatus").val() =='494'){
            	Common.alert("This record haven't assign to Cody. Not allow to Stock Return.");
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
            }else if(FormUtil.isEmpty($("#returnDefectType").val()) && $("#returnCondition").val() == '112') {
                Common.alert('Please select defect type.');
                checkResult = false;
                return checkResult;
            }else if(FormUtil.isEmpty($("#returnRemark").val()) && $("#returnReason").val() == '6615') {
                Common.alert('Please fill in remark.');
                checkResult = false;
                return checkResult;
            }else if(FormUtil.isEmpty($("#returnRemark").val()) && $("#returnDefectType").val() == '7758') {
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
        	if($("#_filterTxtBarcode").val() != "undefined" ){
        		$("#filterTxtBarcode").val($("#_filterTxtBarcode").val());
        	}
        	if($("#_chgdt").val() != "undefined" ){
                $("#chgdt").val($("#_chgdt").val());
            }

        	var data = $("#editArea1Form").serializeJSON();
        	$.extend(data,
                    {
        		"serialNo":$("#serialNoChg").val()
        		,"movementType":$("#movementType").val()
                    }
                    );
        }else if(action == '2'){
        	$("#returnRemark").val($("#returnRemark").val().replace(/(?:\r\n|\r|\n)/g, ' '));
        	var data = $("#editArea2Form").serializeJSON();
        	$.extend(data,
                    {
        		"serialNo":$("#serialNoChg").val()
                ,"movementType":$("#movementType").val()
                    }
                    );
        }else if(action == '3'){
        	$("#deactRemark").val($("#deactRemark").val().replace(/(?:\r\n|\r|\n)/g, ' '));
        	var data = $("#editArea3Form").serializeJSON();
        	$.extend(data,
                    {
        		"serialNo":$("#serialNoChg").val()
                ,"movementType":$("#movementType").val()
                    }
                    );
        }

        if(action == '3'){
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
	<th scope="row">Sediment Filter Serial No.</th>
        <td>
            <!-- <select id="usedFilter" name="usedFilter" class="w100p"> -->
            <input type="text"  id="_filterTxtBarcode" name="filterTxtBarcode" placeholder="Please select here before scanning." style="height:40px;width:99%; text-transform:uppercase;" />
        </td>
    <th scope="row">Filter Last Change Date</th>
            <td>
               <div class="date_set w100p">
                <p>
                 <input id="_chgdt" name="chgdt" type="text"
                  title="Filter Last Change Date" placeholder="DD/MM/YYYY"
                  class="w100p readonly" readonly>
                </p>
               </div>
           <!-- date_set end -->
          </td>
</tr>
<tr>
    <th scope="row"><spring:message code='service.grid.memberCode'/></th>
        <td>
            <select id="cmdMemberCode1" name="cmdMemberCode1" class="w100p">
        </td>
</tr>
</tbody>
<input type="hidden" name="filterTxtBarcode" id="filterTxtBarcode" value="">
<input type="hidden" name="chgdt" id="chgdt" value="">
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
<tr id="defectTypeField" style="display:none">
    <th scope="row">Defect Type<span class="must">*</span></th>
    <td>
        <select id="returnDefectType" name="returnDefectType" class="w100p">
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.remark" /></th>
    <td>
        <textarea cols="20" id="returnRemark" name="returnRemark" placeholder="Remark" maxlength="100"></textarea>
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
        <textarea cols="20" id="deactRemark" name="deactRemark" placeholder="Remark" maxlength="100"></textarea>
    </td>
</tr>
<tr>
<input type="text" id="temp4" name="temp4" placeholder="" class="w100p" />
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
<input type="hidden" name="holderLocChg" id="holderLocChg" value="${headerDetail.holderLoc}"/>

<ul class="center_btns mt20">
    <li><p class="btn_blue2 big"><a id="btnSave" href="#">Save</a></p></li>
</ul>
</section>
</section><!-- pop_body end -->

</div><!-- popup_wrap end -->
