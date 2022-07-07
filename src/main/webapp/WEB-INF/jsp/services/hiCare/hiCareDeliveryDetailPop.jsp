<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript" language="javascript">

    //AUIGrid 생성 후 반환 ID
    var gridHistID;
    var gridTrfID;
    var update = new Array();
    var remove = new Array();
    var myFileCaches = {};
    var deactAtchFileId = 0;
    var deactAtchFileName = "";

    var MEM_TYPE = '${SESSION_INFO.userTypeId}';
    var BranchId = '${SESSION_INFO.userBranchId}';
    $(document).ready(function(){

    	hiCareGrid();

    	setText();

    	$("#returnStatus").change(function() {
    		var returnStatus = $("#returnStatus").val();
    		console.log("returnStatus " + returnStatus);
    		if(FormUtil.isNotEmpty(returnStatus)) {
    			doGetComboOrder('/common/selectCodeList.do', returnStatus, 'CODE_ID', '', 'returnReason', 'S', ''); //Common Code
    		}
        });
    });

    function hiCareGrid() {

        var bodyLayout = [ {
          dataField : "serialNo",
          headerText : "Serial No.",
          width : "20%"
        }, {
          dataField : "modelName",
          headerText : "Model",
          width : "20%"
        }, {
            dataField : "statusDesc",
            headerText : "status",
            width : "10%"
        }, {
            dataField : "conditionDesc",
            headerText : "<spring:message code='service.grid.condition'/>",
            width : "10%"
        }
        ];

        var bodyGridPros = {
          usePaging : true,
          pageRowCount : 8,
          showStateColumn : false,
          displayTreeOpen : false,
          //selectionMode : "singleRow",
          skipReadonlyColumns : true,
          wrapSelectionMove : true,
          showRowNumColumn : true,
          editable : false
        };

        gridHistID = GridCommon.createAUIGrid("transitDetails_grid_wrap", bodyLayout, "", bodyGridPros);
    }

    function setText(result){
    	 $("#transitNoTxt").html('${headerDetail.transitNo}');
    	 $("#transitStatus").html('${headerDetail.status}');
    	 $("#transFrom").html('${headerDetail.fromLocation}');
    	 $("#transTo").html('${headerDetail.toLocation}');
    	 $("#transDate").html('${headerDetail.crtDt}');
    	 $("#receiveDate").html('${headerDetail.receiveDt}');
    	 $("#qty").html('${headerDetail.qty}');
    	 $("#courier").html('${headerDetail.courier}');

    	 AUIGrid.setGridData(gridHistID, $.parseJSON('${bodyDetail}'));
    }

    function fn_loadAtchment(atchFileGrpId) {
        Common.ajax("Get", "/sales/order/selectAttachList.do", {atchFileGrpId :atchFileGrpId} , function(result) {
            //console.log(result);
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
        $('#excPop').remove();
    }
</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Transit Receive View</h1>
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
                    <col style="width: 140px" />
                    <col style="width: *" />
                </colgroup>
                <tbody>
                    <tr>
                        <th scope="row">Transit No.</th>
                        <td colspan="2"><span id='transitNoTxt' ></span></td>
                        <th scope="row">Transit Status</th>
                        <td colspan="2"><span id='transitStatus' ></span></td>
                    </tr>
                    <tr>
                        <th scope="row">Transit From</th>
                        <td colspan="2"><span id='transFrom' ></span></td>
                        <th scope="row">Transit To</th>
                        <td colspan="2"><span id='transTo' ></span></td>
                    </tr>
                    <tr>
                        <th scope="row">Transit Date</th>
                        <td colspan="2"><span id='transDate' ></span></td>
                        <th scope="row">Receive Date</th>
                        <td colspan="2"><span id='receiveDate' ></span></td>
                    </tr>
                    <tr>
                        <th scope="row">Total Transit</th>
                        <td colspan="2"><span id='qty' ></span></td>
                        <th scope="row">Courier</th>
                        <td colspan="2"><span id='courier' ></span></td>
                    </tr>
                </tbody>
            </table>
            <!-- table end -->
        </form>

</section>

<aside class="title_line">
        <h3>Transit Details</h3>
    </aside>
<article class="grid_wrap" id="hi_grid_wrap">
<!-- grid_wrap start  그리드 영역-->
    <div id="transitDetails_grid_wrap" style="width: 100%; margin: 0 auto;"></div>
</article>

<input type="hidden" name="movementType" id="movementType" value="${movementType}"/>
<input type="hidden" name="serialNoChg" id="serialNoChg" value="${headerDetail.serialNo}"/>
</section><!-- pop_body end -->

</div><!-- popup_wrap end -->
