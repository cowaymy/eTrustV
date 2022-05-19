<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script  type="text/javascript">
var uploadGrid;
var uploadResultGrid;

$(document).ready(function(){

	setInputFile();
	creatGrid();

	$("#uploadGrid").hide();
    $("#btnPopSave").hide();

    doGetCombo('/common/selectCodeList.do', '418', '2' ,'rcmsUploadType2', 'S' , '');
    doGetCombo('/common/selectCodeList.do', '422', '1' ,'assignUploadType', 'S' , '');

	//**************************************************
	//** 업로드 파일 내용을 Grid에 적용하기
	//**************************************************
	// 파일 선택하기

	$('#rcmsUploadType2').change(function(){
		var val = $('#rcmsUploadType2').val();
		if(val == 5525){
			$('#assignUploadRow').show();
			$('#agentCsv').show();
		}else{
			$('#assignUploadRow').hide();
			$('#agentCsv').hide();

			if(val == 5524){
				$('#etrCsv').show();
				$('#sensitiveCsv').hide();
				$('#agentCsv').hide();
			}else if(val == 5523){
				$('#sensitiveCsv').show();
				$('#etrCsv').hide();
				$('#agentCsv').hide();
			}
		}
		console.log("val :: " + val);
		if((val == 5525 && $('#assignUploadType').val() == '') || (val == '')){
	        $('#csvFile').hide();
	        $('#etrCsv').hide();
            $('#sensitiveCsv').hide();
	        $('#assignUploadType').prop('selectedIndex', 0);
	    }else{
	        $('#csvFile').show();
	    }

		AUIGrid.clearGridData(uploadResultGrid);
	});

	$('#assignUploadType').change(function(){
		if($('#rcmsUploadType2').val() == 5525 && $('#assignUploadType').val() == ''){
			$('#csvFile').hide();
			$('#etrCsv').hide();
            $('#sensitiveCsv').hide();
			$('#assignUploadType').prop('selectedIndex', 0);
		}else{
			$('#csvFile').show();

		}
	});

	$('#uploadfile').on('change', function(evt) {

	        var data = null;
	        var file = evt.target.files[0];
	        if (typeof file == "undefined") {
	            return;
	        }

	        var reader = new FileReader();
	        //reader.readAsText(file); // 파일 내용 읽기
	        reader.readAsText(file, "EUC-KR"); // 한글 엑셀은 기본적으로 CSV 포맷인 EUC-KR 임. 한글 깨지지 않게 EUC-KR 로 읽음
	        reader.onload = function(event) {
	            if (typeof event.target.result != "undefined") {

	            	AUIGrid.clearGridData(uploadResultGrid);

	                // 그리드 CSV 데이터 적용시킴
	                AUIGrid.setCsvGridData(uploadGrid, event.target.result, false);

	                //csv 파일이 header가 있는 파일이면 첫번째 행(header)은 삭제한다.
	                AUIGrid.removeRow(uploadGrid,0);

	                fn_checkAgentList();

	            } else {
	                Common.alert('<spring:message code="sal.alert.msg.noDataToImport" />');
	            }
	        };

	        reader.onerror = function() {
	        	Common.alert('<spring:message code="sal.alert.msg.unableToRead" />' + file.fileName);
	        };

	});

});

function setInputFile(){//인풋파일 세팅하기
    $(".auto_file").append("<label><span class='label_text'><a href='#'>File</a></span><input type='text' class='input_text' readonly='readonly' /></label>");
}

function creatGrid(){

    var upColLayout = [ {
        dataField : "0",
        width : 100
    },{
        dataField : "1",
        width : 150
    },{
        dataField : "2",
        width : 150
    }];

    var agentLayout = [ {
        dataField : "salesOrdId",
        headerText : '<spring:message code="sales.OrderId" />',
        width : '10%',
        visible : false
    },{
        dataField : "ordNo",
        headerText : '<spring:message code="sales.OrderNo" />',
        width : '10%'
    },{
        dataField : "agentId",
        headerText : '<spring:message code="sal.title.agentId" />',
        width : '15%'
    },{
        dataField : "agentGrpId",
        headerText : 'Group Id',
        width : '15%'
    },{
        dataField : "renStus",
        headerText : '<spring:message code="sal.title.text.rentalStatus" />',
        width : '15%'
    },{
        dataField : "itm",
        headerText : '<spring:message code="sal.title.item" />',
        width : '10%'
    },{
        dataField : "rem",
        headerText : '<spring:message code="sal.title.remark" />',
        	width : '20%'
    }, {
        dataField : "stusId",
        headerText : '<spring:message code="sal.title.status" />',
            width : '20%',
            visible : false
    },{
        dataField : "stusCode",
        headerText : '<spring:message code="sal.title.status" />',
            width : '10%'
    }
    /* ,{
        dataField : "undefined",
        headerText : "Action",
        width : '20%',
        renderer : {
              type : "ButtonRenderer",
              labelText : "Remove",
              onclick : function(rowIndex, columnIndex, value, item) {
                  AUIGrid.removeRow(uploadResultGrid, rowIndex);
                  AUIGrid.removeSoftRows(uploadResultGrid);
              }
        }
   }*/];


    var upOptions = {
               showStateColumn:false,
               showRowNumColumn    : false,
               //usePaging : false,
               editable : false,
               headerHeight : 30,
               softRemoveRowMode:false
         };

    uploadGrid = GridCommon.createAUIGrid("#uploadGrid", upColLayout, "", upOptions);
    uploadResultGrid = GridCommon.createAUIGrid("#uploadResultGrid", agentLayout, "", upOptions);
}


function fn_checkAgentList(){
    var formData = new FormData();

    formData.append("csvFile", $("input[name=uploadfile]")[0].files[0]);
    formData.append("assignUploadType", $("#assignUploadType").val());

    	Common.ajaxFile("/sales/rcms/uploadRcmsConversionBulk.do", formData, function(result)    {
        AUIGrid.clearGridData(uploadResultGrid);

        if(result.data.length > 0){
        	$("#btnPopSave").show();
            AUIGrid.setGridData(uploadResultGrid, result.data);
        }else{
        	$("#btnPopSave").hide();
        }


    }
    , function(jqXHR, textStatus, errorThrown){
         try {
        	    console.log("Fail Status : " + jqXHR.status);
        	    console.log("code : "        + jqXHR.responseJSON.code);
                console.log("message : "     + jqXHR.responseJSON.message);
                console.log("detailMessage : "  + jqXHR.responseJSON.detailMessage);
          }
          catch (e)
          {
        	  console.log(e);
          }
     });

}

function fn_save(){
    var data = GridCommon.getGridData(uploadResultGrid);
    var formData = $("#UploadAssignAgentForm").serializeJSON();
    data.formData = formData;

    if(Common.confirm("<spring:message code='sys.common.alert.save'/>", function(){

//        Common.ajax("POST", "/sales/rcms/saveAgentList", data, function(result){
	Common.ajax("POST", "/sales/rcms/saveConversionList", data, function(result){

            Common.alert("Success To Save" + DEFAULT_DELIMITER + "Agency assignment successfully saved.",
                function(){
                     $('#popup_wrap').remove();
                     fn_selectListAjax();
                }
            );
        }
        , function(jqXHR, textStatus, errorThrown){
            try {
                console.log("Fail Status : " + jqXHR.status);
                console.log("code : "        + jqXHR.responseJSON.code);
                console.log("message : "     + jqXHR.responseJSON.message);
                console.log("detailMessage : "  + jqXHR.responseJSON.detailMessage);
                }
            catch (e)
            {
              console.log(e);
            }
            Common.alert('<spring:message code="sal.alert.title.saveFail" />' + DEFAULT_DELIMITER + '<spring:message code="sal.alert.msg.failToUpdateAgentList" />');
        });

    }));
}

</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="sal.title.text.uploadAssignToAssign" /></h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#"><spring:message code="expense.CLOSE" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body" style="min-height: auto;"><!-- pop_body start -->
<form action="#" method="post" id='UploadAssignAgentForm'>

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
    <th scope="row"><spring:message code="sales.SelectRCMSUploadType" /><span class="must">*</span></th>
    <td colspan="3">
        <select class="" name="rcmsUploadType2" id="rcmsUploadType2"></select>
    </td>
</tr>
<tr id = "assignUploadRow" style="display:none">
    <th scope="row"><spring:message code="sales.AssignUploadType" /><span class="must">*</span></th>
    <td colspan="3">
        <select class="" name="assignUploadType" id="assignUploadType"></select>
    </td>
</tr>
<tr id="csvFile" style="display:none">
	<th scope="row"><spring:message code="sales.SelectCSVFile" /><span class="must">*</span></th>
	<td colspan="3">
	<div class="auto_file"><!-- auto_file start -->
	<input type="file" id="uploadfile" name="uploadfile" title="file add"  accept=".csv"/>
	</div><!-- auto_file end -->
	<p id="agentCsv" style="display:none" class="btn_sky"><a href="${pageContext.request.contextPath}/resources/download/sales/AssignToAgent_Format.csv"><spring:message code="sales.DownloadCSVFormat" /> (Agent)</a></p>
    <p id="sensitiveCsv" style="display:none" class="btn_sky"><a href="${pageContext.request.contextPath}/resources/download/sales/AssignSensitive_Format.csv"><spring:message code="sales.DownloadCSVFormat" /> (Sensitive)</a></p>
    <p id="etrCsv" style="display:none" class="btn_sky"><a href="${pageContext.request.contextPath}/resources/download/sales/AssignEtr_Format.csv"><spring:message code="sales.DownloadCSVFormat" /> (eTR)</a></p>
	</td>
</tr>
</tbody>
</table><!-- table end -->

<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="uploadGrid" style="width:100%; height:350px; margin:0 auto;"></div>
    <div id="uploadResultGrid" style="width:100%; height:310px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

<ul class="center_btns">
    <li><p class="btn_blue"><a href="#" id="btnPopSave" onclick="javascript:fn_save();"><spring:message code="sales.SAVE" /></a></p></li>
</ul>

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->