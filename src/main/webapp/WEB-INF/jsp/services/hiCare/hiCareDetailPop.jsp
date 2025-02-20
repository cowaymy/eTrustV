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
    var returnStatusOption = [{"codeId": "494","codeName": "Stock Return"},{"codeId": "495","codeName": "Condition Update"}];
    var returnConditionOption = [{"codeId": "111","codeName": "Used"},{"codeId": "112","codeName": "Defect"}];

    $(document).ready(function(){

    	$("#temp3").hide();
    	hiCareGrid();

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

    function hiCareGrid() {

        var histLayout = [ {
          dataField : "updDt",
          headerText : "Date",
          width : "11%"
        }, {
          dataField : "condition",
          headerText : "<spring:message code='service.grid.condition'/>",
          width : "10%"
        }, {
            dataField : "holderLoc",
            headerText : "Holder",
            width : "34%"
        }, {
            dataField : "branchCode",
            headerText : "<spring:message code='service.grid.BranchCode'/>",
            width : "14%"
        }, {
          dataField : "creator",
          headerText : "Updated by",
          width : "12%"
        }, {
          dataField : "transTypeDesc",
          headerText : "Transaction Type",
          width : "18%"
        }, {
            dataField : "reasonDesc1",
            headerText : "Reason",
            width : "18%"
          }, {
              dataField : "defectTypeDesc",
              headerText : "Defect Type",
              width : "30%"
            },{
              dataField : "remark1",
              headerText : "Remarks",
              width : "20%"
            }
        ];

        var trfLayout = [ {
            dataField : "filterChgDt",
            headerText : "Last Changed Date",
            width : "11%"
          }, {
            dataField : "filterSn",
            headerText : "Sediment Filter Serial No",
            width : "25%"
          }, {
              dataField : "reason",
              headerText : "Reason",
              width : "30%"
          }, {
              dataField : "isReturn",
              headerText : "Has Return",
              width : "10%"
          }, {
            dataField : "userName",
            headerText : "Created By",
            width : "12%"
          }
          ];

        var histGridPros = {
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

        var trfGridPros = {
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

        gridHistID = GridCommon.createAUIGrid("hiCareHist_grid_wrap", histLayout, "", histGridPros);
        gridTrfID = GridCommon.createAUIGrid("hiCareTrfHist_grid_wrap", trfLayout, "", trfGridPros);
    }

    function setText(result){
    	 var date = new Date(Date.now());
    	 $("#serialNoTxt").html('${headerDetail.serialNo}');
    	 $("#model").html('${headerDetail.model}');
    	 $("#branchLoc").html('${headerDetail.branchLoc}');
    	 $("#status").html('${headerDetail.status}');
    	 $("#condition").html('${headerDetail.condition}');
    	 $("#filterSn").html('${headerDetail.filterSn}');
    	 $("#filterChgDt").html('${headerDetail.filterChgDt}');
    	 $("#filterNxtChgDt").html('${headerDetail.filterNxtChgDt}');
    	 $("#crtUserId").html('${headerDetail.crtUserId}');
    	 $("#crtDt").html('${headerDetail.crtDt}');
    	 $("#updBy").html('${headerDetail.updBy}');
    	 var status = '${headerDetail.status}';
    	 if(status == 'Closed'){
    		 $("#reason").html('${headerDetail.reasonDesc}');
             $("#remarks").html('${headerDetail.remarks}');
             console.log("atchgrp" + '${headerDetail.atchFileGrpId}');
             if('${headerDetail.atchFileGrpId}' != 0){
                 fn_loadAtchment('${headerDetail.atchFileGrpId}');
             }
    	 }
    	 $("#memCode").html('${codyDetail.memCode}');
    	 $("#memName").html("${codyDetail.memName}");
    	 $("#memNric").html('${codyDetail.memNric}');
    	 $("#orgCode").html('${codyDetail.orgCode}');
    	 $("#grpCode").html('${codyDetail.grpCode}');
    	 $("#deptCode").html('${codyDetail.deptCode}');

    	 console.log($.parseJSON('${historyDetailList}'));
    	 AUIGrid.setGridData(gridHistID, $.parseJSON('${historyDetailList}'));
    	 AUIGrid.setGridData(gridTrfID, $.parseJSON('${filterDetailList}'));
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
<h1>View Hi-Care</h1>
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
                        <th scope="row">Serial No.</th>
                        <td colspan="2"><span id='serialNoTxt' ></span></td>
                        <th scope="row">Model</th>
                        <td colspan="2"><span id='model' ></span></td>
                        <th scope="row">Branch Code</th>
                        <td colspan="2"><span id='branchLoc' ></span></td>
                    </tr>
                    <tr>
                        <th scope="row">Status</th>
                        <td colspan="2"><span id='status' ></span></td>
                        <th scope="row">Condition</th>
                        <td colspan="2"><span id='condition' ></span></td>
                    </tr>
                    <tr>
                        <th scope="row">Sediment Filter Serial No.</th>
                        <td colspan="2"><span id='filterSn' ></span></td>
                        <th scope="row">Filter Last Change Date</th>
                        <td colspan="2"><span id='filterChgDt' ></span></td>
                        <th scope="row">Filter Next Change Date</th>
                        <td colspan="2"><span id='filterNxtChgDt' ></span></td>
                    </tr>
                    <tr>
                        <th scope="row">Creator</th>
                        <td colspan="2"><span id='crtUserId' ></span></td>
                        <th scope="row">Create Date</th>
                        <td colspan="2"><span id='crtDt' ></span></td>
                        <th scope="row">Last Updated</th>
                        <td colspan="2"><span id='updBy' ></span></td>
                    </tr>
                    <tr>
	                    <th scope="row">Deactivate Reason</th>
	                    <td colspan="2"><span id='reason' ></span></td>
	                    <th scope="row"><spring:message code="sal.title.remark" /></th>
	                    <td colspan="2"><span id='remarks' ></span></td>
                    </tr>
                    <tr>
                    <input type="text" id="temp3" name="temp3" placeholder="" class="w100p" />
                    <th scope="row">Attachment</th>
			            <td colspan="2">
			                <div name='uploadfiletest' class='auto_file2'>
			                    <input type='file' title='file add'  id='deactAtchFile' accept='image/*''/>
			                    <label>
			                        <input type='text' class='input_text' readonly='readonly' id='deactAtchFileTxt'/>
			                    </label>
			                </div>
			            </td>
			        </tr>
                </tbody>
            </table>
            <!-- table end -->
        </form>

</section>

<section id="holderArea" class="">
<aside class="title_line">
        <h3>Current Holder Info</h3>
    </aside>
<form id="holderForm" name="holderForm" method="post">
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
                <th scope="row">Member Code</th>
                <td colspan="3"><span id='memCode' ></span></td>
                <th scope="row">Organization Code</th>
                <td colspan="3"><span id='orgCode' ></span></td>
            </tr>
            <tr>
                <th scope="row">Member Name</th>
                <td colspan="3"><span id='memName' ></span></td>
                <th scope="row">Group Code</th>
                <td colspan="3"><span id='grpCode' ></span></td>
            </tr>
            <tr>
                <th scope="row">Member NRIC</th>
                <td colspan="3"><span id='memNric' ></span></td>
                <th scope="row">Department Code</th>
                <td colspan="3"><span id='deptCode' ></span></td>
            </tr>
        </tbody>
    </table>
    <!-- table end -->
</form>
</section>

<aside class="title_line">
        <h3>Transaction History</h3>
    </aside>
<article class="grid_wrap" id="hi_grid_wrap">
<!-- grid_wrap start  그리드 영역-->
    <div id="hiCareHist_grid_wrap" style="width: 100%; margin: 0 auto;"></div>
</article>

<aside class="title_line">
        <h3>Filter Exchange History</h3>
    </aside>
<article class="grid_wrap">
<!-- grid_wrap start  그리드 영역-->
    <div id="hiCareTrfHist_grid_wrap" style="width: 100%; margin: 0 auto;"></div>
</article>

<input type="hidden" name="movementType" id="movementType" value="${movementType}"/>
<input type="hidden" name="serialNoChg" id="serialNoChg" value="${headerDetail.serialNo}"/>
</section><!-- pop_body end -->

</div><!-- popup_wrap end -->
