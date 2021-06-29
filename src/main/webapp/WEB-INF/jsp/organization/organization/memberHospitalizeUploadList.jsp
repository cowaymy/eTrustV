<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<script type="text/javaScript">
    var hsptlzGridID;
    var itemGridID;
    var uploadId;
    var stusId;
    var typeId;

    var dCreator;
    var dUploadType;
    var dActionDt;
    var totalCnt;
    var totalValid;
    var totalInvalid;
    var dOrgType;

    var memType = [{"codeId": "1","codeName": "Health Planner"}
    ,{"codeId": "2","codeName": "Coway Lady"}
    ,{"codeId": "7","codeName": "Homecare Techincian"}];

    var stusType = [{"codeId": "1","codeName": "Active"}
    ,{"codeId": "4","codeName": "Completed"}
    ,{"codeId": "8","codeName": "Inactivte"}];

    $(document).ready(function() {

        doDefCombo(stusType, '' ,'statusList', 'M', 'fn_multiCombo');
        doDefCombo(memType, '' ,'memberTypeList', 'M', 'fn_multiCombo');
        doGetComboOrder('/common/selectCodeList.do', '470', 'CODE_ID',   '', 'typeList', 'M', 'fn_multiCombo');


        createAUIGrid();

        AUIGrid.bind(hsptlzGridID, "cellClick", function(event) {
              uploadId = AUIGrid.getCellValue(hsptlzGridID, event.rowIndex, "uploadId");
              stusId   = AUIGrid.getCellValue(hsptlzGridID, event.rowIndex, "stusId");
              typeId   = AUIGrid.getCellValue(hsptlzGridID, event.rowIndex, "memTypeId");
        });

        AUIGrid.bind(hsptlzGridID, "cellDoubleClick", function(event) {
        	if(uploadId == null || uploadId == ""){
                Common.alert('<spring:message code="commission.alert.incentive.noSelect"/>');
            }else{

                 /* if(stusId != 1){
                	 $('#btnConfirm').hide();
                     $('#btnDeactive').hide();
                 } */

                $('#details_uploadId').text(uploadId);
                $('#details_status').text(AUIGrid.getCellValue(hsptlzGridID, event.rowIndex, "name"));
                $('#details_creator').text( AUIGrid.getCellValue(hsptlzGridID, event.rowIndex, "c1") +
                       " (" + AUIGrid.getCellValue(hsptlzGridID, event.rowIndex, "crtDt") + ")"
                );
                $('#details_updator').text( AUIGrid.getCellValue(hsptlzGridID, event.rowIndex, "c2") +
                        " (" + AUIGrid.getCellValue(hsptlzGridID, event.rowIndex, "updDt") + ")"
                );
                $('#details_uploadType').text(AUIGrid.getCellValue(hsptlzGridID, event.rowIndex, "codeName"));
                $('#details_actionDate').text(AUIGrid.getCellValue(hsptlzGridID, event.rowIndex, "actnDt"));
                $('#totalCntTxt').text(AUIGrid.getCellValue(hsptlzGridID, event.rowIndex, "totalUpload"));
                $('#totalValidTxt').text(AUIGrid.getCellValue(hsptlzGridID, event.rowIndex, "totalValid"));
                $('#totalInvalidTxt').text(AUIGrid.getCellValue(hsptlzGridID, event.rowIndex, "totalInvalid"));
                $('#details_orgType').text(AUIGrid.getCellValue(hsptlzGridID, event.rowIndex, "codename1"));

                $('#conForm #conForm_uploadId').val(uploadId);

                $('#popupDetails_wrap').show();
                fn_createItemGrid();
            }
        });


        $("#search").click(function(){
            Common.ajax("GET", "/organization/selectHospitalizeUploadList.do", $("#myForm").serialize(), function(result) {
                AUIGrid.setGridData(hsptlzGridID, result);
            });
        });

        $('#actionDate').click(function () { $("#actionDate").val(""); });
        $('#uploadDateFr').click(function () { $("#uploadDateFr").val(""); });
        $('#uploadDateTo').click(function () { $("#uploadDateTo").val(""); });

    });

    function createAUIGrid() {
        var columnLayout = [ {
            dataField : "uploadId",
            headerText : "Batch ID",
            style : "my-column",
            editable : false
        },{
            dataField : "name",
            headerText : "Status",
            style : "my-column",
            editable : false
        },{
            dataField : "codeName",
            headerText : "Type",
            style : "my-column",
            editable : false
        },{
            dataField : "actnDt",
            headerText : "Target Month",
            style : "my-column",
            editable : false
        },{
            dataField : "c1",
            headerText : "UpLoader",
            style : "my-column",
            editable : false
        },{
            dataField : "crtDt",
            headerText : "Upload Date",
            style : "my-column",
            editable : false
        },{
            dataField : "stusId",
            style : "my-column",
            editable : false,
            visible : false

       },{
           dataField : "memTypeId;",
           style : "my-column",
           editable : false,
           visible : false
       },{
           dataField : "upDt",
           style : "my-column",
           editable : false,
           visible : false
       },{
           dataField : "c2",
           style : "my-column",
           editable : false,
           visible : false
       },{
           dataField : "codename1",
           style : "my-column",
           editable : false,
           visible : false
       },{
           dataField : "totalUpload",
           style : "my-column",
           editable : false,
           visible : false
       },{
           dataField : "totalValid",
           style : "my-column",
           editable : false,
           visible : false
       },{
           dataField : "totalInvalid",
           style : "my-column",
           editable : false,
           visible : false
      }];
        var gridPros = {

            usePaging : true,
            pageRowCount : 20,
            skipReadonlyColumns : true,
            wrapSelectionMove : true,
            showRowNumColumn : true


        };

        hsptlzGridID = AUIGrid.create("#grid_wrap", columnLayout,gridPros);

   }

    function fn_multiCombo(){
    	$(function() {
            $('#memberTypeList').change(function() {
            }).multipleSelect({
                selectAll : true,
                width : '80%'
            }).multipleSelect("checkAll");
        });
    	$(function() {
            $('#statusList').change(function() {
            }).multipleSelect({
                selectAll : true,
                width : '80%'
            }).multipleSelect("setSelects", [1]);
        });
    	$(function() {
            $('#typeList').change(function() {
            }).multipleSelect({
                selectAll : true,
                width : '80%'
            }).multipleSelect("checkAll");
        });

    }

    function newUploadPop(){

    	var today = new Date().getDate();
    	if(today < 6){
	        doDefCombo(memType, '' ,'cmbMemberType', 'S', '');
	        doGetComboOrder('/common/selectCodeList.do', '470', 'CODE_ID',   '', 'cmbType', 'S', '');
	        $('#popup_wrap').show();
	    }else{
	    	Common.alert("No upload allowed after 5th day of the month.");
	    }
    }

    function confirmUploadPop(){
        if(uploadId == null || uploadId == ""){
            Common.alert('<spring:message code="commission.alert.incentive.noSelect"/>');
        }else{
            if(stusId != "1"){
                Common.alert('<spring:message code="commission.alert.incentive.noActive"/>');
            }else{
                var valTemp = {"uploadId" : uploadId, "typeId" : typeId};
                Common.popupDiv("/commission/calculation/commIncntiveConfirmPop.do",valTemp);
            }
        }
    }


    function fn_closePopDetails(){
        $('#popupDetails_wrap').hide();
        AUIGrid.destroy("#grid_wrap_confirm");
    }

    function fn_clearSearchForm(){
        $("#myForm")[0].reset();
        fn_multiCombo();
    }

    // New Uploads
    function fn_uploadValid(){
        if( $("#cmbType").val() == null || $("#cmbType").val() == ""){
            Common.alert('<spring:message code="sys.msg.first.Select" arguments="upload type" htmlEscape="false"/>');
            return false;
        }
        if( $("#cmbMemberType").val() == null || $("#cmbMemberType").val() == ""){
            Common.alert('<spring:message code="commission.alert.incentive.new.noSample"/>');
            return false;
        }
        if( $("#uploadfile").val() == null || $("#uploadfile").val() == ""){
            Common.alert('<spring:message code="sys.alert.upload.csv"/>');
            return false;
        }
        return true;
    }


    function fn_uploadCsvFile(){
        if(fn_uploadValid()){
            Common.ajax("GET", "/organization/hospitalizeExistedCnt.do", $("#uploadForm").serialize(), function(result) {
                if( result >0 ){
                    Common.alert('<spring:message code="commission.alert.incentive.new.nonUpload"/>');
                }else{
                    var formData = new FormData();
                    formData.append("csvFile", $("input[name=uploadfile]")[0].files[0]);
                    formData.append("type", $("#cmbType").val());
                    formData.append("memberType", $("#cmbMemberType").val());

                    Common.ajaxFile("/organization/hospitalizeUploadFile.do", formData, function (result) {
                        $("#search").click();
                      ment.newForm.reset();
                        Common.alert('<spring:message code="commission.alert.incentive.new.success" arguments="'+result+'" htmlEscape="false"/>');

                    });
                }
            });
        }
    }

    function fn_createItemGrid(){

    	var columnLayout2 = [{
            dataField : "userMemCode",
            headerText : "<spring:message code='commission.text.search.memCode'/>",
            style : "my-column",
            editable : false,
            width : '15%'
        },{
            dataField : "memType",
            headerText : "<spring:message code='commission.text.search.type'/>",
            style : "my-column",
            editable : false,
            width : '15%'
        },{
            dataField : "memNm",
            headerText : "<spring:message code='commission.text.grid.memberName'/>",
            style : "my-column",
            editable : false,
            width : '20%'
        },{
            dataField : "validStus",
            headerText : "<spring:message code='commission.text.search.status'/>",
            style : "my-column",
            editable : false,
            width : '15%'
        },{
            dataField : "validRem",
            headerText : "<spring:message code='commission.text.grid.remark'/>",
            style : "my-column",
            editable : false,
            width : '35%'
        },{
            dataField : "uploadDetId",
            style : "my-column",
            visible : false,
            editable : false
        }];

        var gridPros2 = {
            usePaging : true,
            pageRowCount : 20,
            skipReadonlyColumns : true,
            wrapSelectionMove : true,
            showRowNumColumn : true,
            height : 280

        };

        itemGridID = AUIGrid.create("#grid_wrap_confirm", columnLayout2,gridPros2);
        AUIGrid.resize(itemGridID);

        Common.ajax("GET", "/organization/selectHospitalizeDetails.do", $("#conForm").serialize(), function(result) {
            AUIGrid.setGridData(itemGridID, result);
        });

    }

    $(function(){
        $('#btnConfirm').click(function() {

        	var data = {uploadId :uploadId, statusId :1};

        	Common.ajax("GET", "/organization/hospitalizeExistedCnt.do", data, function(result) {
                if( result > 0 ){
                        Common.ajax("GET", "/organization/hspitalizeConfirm.do", data, function(result) {
                            Common.alert("Batch confirmed");
                            fn_closePopDetails();
                        });
                }else{
                	Common.alert('Batch is not in ACTIVE status.');
                }
            });
        });

        $('#btnDeactive').click(function() {

        	var data = {uploadId :uploadId, statusId :1};

            Common.ajax("GET", "/organization/hospitalizeExistedCnt.do", data, function(result) {
            	if( result > 0 ){
                        Common.ajax("GET", "/organization/deactivateHspitalize.do", data, function(result) {
                            Common.alert("Batch deactivated.");
                            fn_closePopDetails();
                        });
                }else{
                	Common.alert('Batch is not in ACTIVE status.');
                }
            });
        });
    });
</script>
<section id="content">
    <!-- content start -->
    <ul class="path">
        <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
        <li>Organization</li>
        <li>Member Event</li>
        <li>Hospitalize Upload</li>
    </ul>

    <aside class="title_line">
        <!-- title_line start -->
        <p class="fav">
            <a href="#" class="click_add_on">My menu</a>
        </p>
        <h2>Hospitalize Upload</h2>
        <ul class="right_btns">
            <%-- <c:if test="${PAGE_AUTH.funcView == 'Y'}"> --%>
            <li><p class="btn_blue"><a href="javascript:newUploadPop();">New Upload</a></p></li>
            <%-- </c:if> --%>
            <%-- <c:if test="${PAGE_AUTH.funcView == 'Y'}"> --%>
                <li><p class="btn_blue"><a href="#" id="search"><span class="search"></span><spring:message code='sys.btn.search'/></a></p></li>
            <%-- </c:if> --%>
            <li><p class="btn_blue"><a href="javascript:fn_clearSearchForm();"><span class="clear"></span><spring:message code='sys.btn.clear'/></a></p></li>
        </ul>
    </aside>
    <!-- title_line end -->

    <section class="search_table">
        <!-- search_table start -->
        <form action="#" method="post" name="myForm" id="myForm">

            <table class="type1">
                <!-- table start -->
                <caption>table</caption>
                <colgroup>
                    <col style="width: 120px" />
                    <col style="width: *" />
                    <col style="width: 120px" />
                    <col style="width: *" />
                    <col style="width: 120px" />
                    <col style="width: *" />
                </colgroup>
                <tbody>
                    <tr>
                        <th scope="row"><spring:message code='commission.text.search.batchId'/></th>
                        <td><input type="text" title="" placeholder="Batch ID" class="w100p" name="uploadId" id="uploadId" ' maxlength="20"/></td>
                        <th scope="row"><spring:message code='commission.text.search.batchStatus'/></th>
                        <td>
                            <select class="multy_select w100p" multiple="multiple" name="statusList" id="statusList"></select>
                        </td>
                        <th scope="row"><spring:message code='commission.text.search.uploadType'/></th>
                        <td>
                            <select class="multy_select w100p" multiple="multiple" name="typeList" id="typeList"></select>
                        </td>
                    </tr>
                    <tr>
                        <th><spring:message code='commission.text.search.targetMonth'/></th>
                        <td><input type="text" placeholder="MM/YY" class="j_date2 w100p" name="actionDate" id="actionDate" /></td>
                        <th><spring:message code='commission.text.search.uploadDate'/></th>
                        <td><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date " name="uploadDateFr" id="uploadDateFr" />
                        <p>To</p> <input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date " name="uploadDateTo" id="uploadDateTo" /></td>
                        <th><spring:message code='commission.text.search.uploader'/></th>
                        <td><input type="text" title="" placeholder="Uploader (Username)" class="w100p" name="creator" id="creator" / maxlength="20"></td>
                    </tr>
                    <tr>
                        <th><spring:message code='commission.text.search.orgType'/></th>
                        <td>
                            <select class="multy_select w100p" multiple="multiple" name="memberTypeList" id="memberTypeList"></select>
                        </td>
                        <th></th>
                        <td></td>
                        <th></th>
                        <td></td>
                    </tr>
                </tbody>
            </table>
            <!-- table end -->

        </form>
    </section>
    <!-- search_table end -->

    <section class="search_result">
        <article class="grid_wrap">
            <div id="grid_wrap" style="width: 100%; height: 334px; margin: 0 auto;"></div>
        </article>
    </section>

</section>


<!--  New Upload - Popup Start -->
<div id="popup_wrap" class="popup_wrap size_mid" style="display:none">

    <header class="pop_header">
        <h1>Hospitalization - New Uploads</h1>
        <ul class="right_opt">
            <li><p class="btn_blue2"><a href="#"><spring:message code='sys.btn.close'/></a></p></li>
        </ul>
    </header>

    <section class="pop_body">

        <form id="newForm" name="newForm">
        <table class="type1 mt10">
            <caption>table</caption>
            <colgroup>
                <col style="width:150px" />
                <col style="width:*" />
            </colgroup>
            <tbody>
                <tr>
                    <th scope="row"><spring:message code='commission.text.search.type'/></th>
                    <td>
                        <select class="" name="cmbType" id="cmbType">
                        </select>
                    </td>
                </tr>
                <tr>
                    <th scope="row"><spring:message code='commission.text.search.orgType'/></th>
                    <td>
                        <select class="" name="cmbMemberType" id="cmbMemberType">
                        </select>
                    </td>
                </tr>
                <tr>
                    <th scope="row"><spring:message code='commission.text.search.file'/></th>
                    <td>
                         <div class="auto_file attachment_file ">
                            <input type="file" title="file add"  id="uploadfile" name="uploadfile"/>
                         </div>
                    </td>
                </tr>
            </tbody>
        </table>
        </form>
        <ul class="center_btns">
            <li><p class="btn_blue"><a href="javascript:fn_uploadCsvFile();"><spring:message code='commission.button.uploadFile'/></a></p></li>
            <li><p class="btn_blue"><a href="${pageContext.request.contextPath}/resources/download/organization/HospitalizeUploadFormat.csv"><spring:message code='commission.button.dwCsvFormat'/></a></p></li>
        </ul>

    </section>

</div>

<!--  New Upload - Popup Start -->
<div id="popupDetails_wrap" class="popup_wrap" style="display:none">

    <header class="pop_header">
        <h1>Hospitalization Uploads - Confirm Upload Batch</h1>
        <ul class="right_opt">
            <li><p class="btn_blue2"><a href="#" onclick="fn_closePopDetails();"><spring:message code='sys.btn.close'/></a></p></li>
        </ul>
    </header>

	<section class="pop_body"><!-- pop_body start -->

	<table class="type1"><!-- table start -->
	<caption>table</caption>
	<colgroup>
	    <col style="width:160px" />
	    <col style="width:*" />
	    <col style="width:210px" />
	    <col style="width:*" />
	</colgroup>
	<tbody>
	<tr>
	    <th scope="row"><spring:message code='commission.text.search.batchId'/></th>
	    <td id="details_uploadId"></td>
	    <th scope="row"><spring:message code='commission.text.search.uploadBy'/></th>
	    <td id="details_creator"></td>
	</tr>
	<tr>
	    <th scope="row"><spring:message code='commission.text.search.status'/></th>
	    <td id="details_status"></td>
	    <th scope="row"><spring:message code='commission.text.search.updateBy'/></th>
	    <td id="details_updator"></td>
	</tr>
	<tr>
	    <th scope="row"><spring:message code='commission.text.search.uploadType'/></th>
	    <td id="details_uploadType"></td>
	    <th scope="row"><spring:message code='commission.text.search.targetMonth'/></th>
	    <td id="details_actionDate"></td>
	</tr>
	<tr>
	    <th scope="row"><spring:message code='commission.text.search.totalItem'/></th>
	    <td><p id="totalCntTxt"></p></td>
	    <th scope="row"><spring:message code='commission.text.search.totalVaild'/></th>
	    <td><p id="totalValidTxt"></p><p> / </p><p id="totalInvalidTxt"></p>
	</tr>
	<tr>
	    <th scope="row"><spring:message code='commission.text.search.orgType'/></th>
	    <td id="details_orgType"></td>
	    <th></th>
	    <td></td>
	</tr>
	</tbody>
	</table><!-- table end -->

	<form id="conForm" name="conForm">
	    <input type="hidden" name="conForm_uploadId" id="conForm_uploadId">
	    <input type="hidden" name="vStusId" id="vStusId">
	</form>

	<ul class="right_btns">
	    <li><p class="btn_grid"><a href="javascript:fn_itemDetailSearch('0');"><spring:message code='commission.button.allItem'/></a></p></li>
	    <li><p class="btn_grid"><a href="javascript:fn_itemDetailSearch('4');"><spring:message code='commission.button.viildItem'/></a></p></li>
	    <li><p class="btn_grid"><a href="javascript:fn_itemDetailSearch('21');"><spring:message code='commission.button.invaildItem'/></a></p></li>
	</ul>

	<article class="grid_wrap"><!-- grid_wrap start -->
	    <div id="grid_wrap_confirm" style="width: 100%; height: 300px; margin: 0 auto;"></div>
	</article><!-- grid_wrap end -->

	<ul class="center_btns">
	    <li><p class="btn_blue"><a id="btnConfirm"><spring:message code='commission.button.confirm'/></a></p></li>
	    <li><p class="btn_blue"><a id="btnDeactive"><spring:message code='commission.button.deactivate'/></a></p></li>
	</ul>

	</section><!-- pop_body end -->

</div><!-- popup_wrap end -->