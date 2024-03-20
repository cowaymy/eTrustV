<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<style type="text/css">
/* 커스텀 행 스타일 */
.my-cell-style {
    background:#FF0000;
    color:#005500;
    font-weight:bold;
}
/* 커스텀 칼럼 스타일 정의 */
.aui-grid-user-custom-left {
    text-align:left;
}
/* 커스텀 칼럼 스타일 정의 */
.aui-grid-user-custom-right {
    text-align:right;
}
/* 특정 칼럼 드랍 리스트 왼쪽 정렬 재정의*/
#newVendor_grid_wrap-aui-grid-drop-list-taxCode .aui-grid-drop-list-ul {
     text-align:left;
 }
</style>
<script type="text/javascript">
var cycleGridID;

var newGridID;
var selectRowIdxCycle = 0;
//var callType = "${callType}";
var update = new Array();
var remove = new Array();
var contractFileId = 0;
var contractFileName = "";
var action = "${action}";
var cycleItemList = "";
var recentGridItem = null;
var myFileCaches = {};
var fileId = 0;
var fileName = "";
var cycleResult;
//var attachList;

var cycleGridPros = {
	    usePaging : true,
	    pageRowCount : 3,
	    editable : true,
	    /* softRemovePolicy : "exceptNew",  *///사용자추가한 행은 바로 삭제
	    softRemoveRowMode : false,
	    /*  showStateColumn : true, */
    /* softRemoveRowMode : true, */
	    headerHeight : 40,
	    height : 160
	    ,showRowNumColumn : false

	   /* , rowIdField: "id" */
	};

var cycleColumnLayout = [
  /* { headerText : 'Renewal Cycle', dataField : "cycleNo", width : 150}
,  */
{ headerText : 'Renewal Cycle', dataField : "seq",  width : 110}
,{ headerText : 'Commencement Date', dataField : "contractCommDt", width : 180, dataType : "date",formatString : "dd/mm/yyyy",editable : true,
    editRenderer : {type : "CalendarRenderer",showEditorBtnOver : true, onlyCalendar : true, showExtraDays : true}
    }
, { headerText : 'Contract Expiry Date', dataField : "contractCommExpDt", width : 160 , dataType : "date", formatString : "dd/mm/yyyy",editable : true,
    editRenderer : {type : "CalendarRenderer",showEditorBtnOver : true, onlyCalendar : true, showExtraDays : true}
}
, { headerText : 'Contract Term', dataField : "contractTerm",  width : 150 }
, { headerText : 'Renewal Cut-Off Date', dataField : "noticePeriod",  width : 180, dataType : "date", formatString : "dd/mm/yyyy",editable : true,
    editRenderer : {type : "CalendarRenderer",showEditorBtnOver : true, onlyCalendar : true, showExtraDays : true}
}
, { headerText : 'Renewal Date', dataField : "contractRenewDt",  width : 150, dataType : "date",formatString : "dd/mm/yyyy",editable : true,
    editRenderer : {type : "CalendarRenderer",showEditorBtnOver : true, onlyCalendar : true, showExtraDays : true}
}
, { dataField : "atchFileGrpId", visible : false}
, { dataField : "atchFileId", visible : false}
, { dataField : "isAttach", visible : false}
, {
    dataField: "selectedFile",
    headerText: "Select File Name" ,editable : false
    ,width: 160
    ,styleFunction: function (rowIndex, columnIndex, value, headerText, item, dataField) {
        if (typeof value == "undefined" || value == "") {
            return null;
        }
        return "my-file-selected";
    },
    labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
        if (typeof value == "undefined" || value == "") {
            return "no file selected";
        }
        return value;
    }
}
, {dataField : "atchFile",  headerText : 'Upload Renewal Letter', width : '10%', /* styleFunction : cellStyleFunction, */
    renderer : {
      type : "ButtonRenderer",
      labelText : "Upload",
      editable : false,
      onclick : function(rowIndex, columnIndex, value, item) {
    	  recentGridItem = item; // 그리드의 클릭한 행 아이템 보관
    	  recentGridItem.rowIndex = rowIndex;
    	  recentGridItem.columnIndex = columnIndex-1;
          var input = $("#file1");
          input.trigger('click');
      }
    }
}
];

var cycleColumnLayoutView = [
  /* { headerText : 'Renewal Cycle', dataField : "cycleNo", width : 150}
,  */
{ headerText : 'Renewal Cycle', dataField : "seq",  width : 110,editable : false}
,{ headerText : 'Commencement Date', dataField : "contractCommDt", width : 180, dataType : "date",
    formatString : "dd-mm-yyyy",editable : false}
, { headerText : 'Contract Expiry Date', dataField : "contractCommExpDt", width : 160 , dataType : "date"
    , formatString : "dd-mm-yyyy",editable : false}
, { headerText : 'Contract Term', dataField : "contractTerm",  width : 150 ,editable : false}
, { headerText : 'Renewal Cut-Off Date', dataField : "noticePeriod",  width : 180, dataType : "date"
    , formatString : "dd-mm-yyyy",editable : false}
, { headerText : 'Renewal Date', dataField : "contractRenewDt",  width : 150, dataType : "date"
    ,formatString : "dd-mm-yyyy",editable : false}
, { dataField : "atchFileGrpId", visible : false}
, { dataField : "atchFileId", visible : false}
, { dataField : "isAttach", visible : false}
, {
	    dataField: "selectedFile",
	    headerText: "Select File Name",editable : false
	    ,width: 160
	    ,styleFunction: function (rowIndex, columnIndex, value, headerText, item, dataField) {
	        if (typeof value == "undefined" || value == "") {
	            return null;
	        }
	        return "my-file-selected";
	    },
	    labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
	        if (typeof value == "undefined" || value == "") {
	            return "no file selected";
	        }
	        return value;
	    }
	}
, {dataField : "atchFile",  headerText : 'Upload Renewal Letter', width : '10%',
    renderer : {
      type : "ButtonRenderer",
      labelText : "Download",
      onclick : function(rowIndex, columnIndex, value, item) {
          Common.showLoader();
           var fileId = item.atchFileId;
           console.log('file path ' + '${pageContext.request.contextPath}');
         $.fileDownload("${pageContext.request.contextPath}/file/fileDown.do", {
              httpMethod: "POST",
              contentType: "application/json;charset=UTF-8",
              data: {
                  fileId: fileId
              },
              failCallback: function (responseHtml, url, error) {
                  Common.alert($(responseHtml).find("#errorMessage").text());
              }
          }).done(function () {
                  Common.removeLoader();
                  console.log('File download a success!');
          }).fail(function () {
                  Common.alert('<spring:message code="sal.alert.msg.fileMissing" />');
                  Common.removeLoader();
          });
      }
    }
}
];
$(document).ready(function () {
	if(action == 'new'){
		$("#edit").hide();
		$("#delete").hide();
		cycleGridID = AUIGrid.create("#grid_cycle_wrap", cycleColumnLayout, cycleGridPros);

		var today = new Date();

	    var dd = today.getDate();
	    var mm = today.getMonth() + 1;
	    var yyyy = today.getFullYear();

	    if(dd < 10) {
	        dd = "0" + dd;
	    }
	    if(mm < 10){
	        mm = "0" + mm
	    }

	    today = dd + "/" + mm + "/" + yyyy;
	    $("#keyDate").val(today);
	    $("#createdBy").val('${userName}');
	}else{//view or edit

	    console.log('details ' + "${details}");

		fn_setDetails();
		fn_viewOnly();
		cycleGridID = AUIGrid.create("#grid_cycle_wrap", cycleColumnLayoutView, cycleGridPros);

		console.log('cycleResult ' + "${cycleResult}");
	    //cycleItemList = "${cycleResult}";
	    cycleItemList = '$.parseJSON("${cycleResult}")';
	    fn_searchRenewalCycleDetails();
	}

    $("#add_row").click(fn_addCycleGridRow);
    $("#remove_row").click(fn_removeCycleGridRow);


});

function fn_close(){
    $("#_contractNewPop").remove();
}

function fn_setDetails(){

	var contType = '${details.contType}';
	console.log('contType ' + contType);
    $("#form_newContract #contractType option[value='"+ contType +"']").prop("selected", true);
    $('#contractType').trigger("change");
    var contractStus = '${details.contStatus}';
    $("#contractStus option[value='"+ contractStus +"']").attr("selected", true);
    var isOptToRenew = '${details.isOptRenew}';
    $("#isOptToRenew option[value='"+ isOptToRenew +"']").attr("selected", true);
    var vendorType = '${details.venType}';
    $("#vendorType option[value='"+ vendorType +"']").attr("selected", true);
}

function fn_viewOnly(){

	/* var inputs = document.getElementsByTagName('input');

    for(var i = 0; i < inputs.length; i++) {
        if(inputs[i].type.toLowerCase() == 'text') {
            alert(inputs[i].value);
        }
    } */

    var elements = document.getElementsByClassName("manCheck");
    if(elements.length > 0){
        for(i=0;i<elements.length;i++){
            var element = $(elements[i]);
            var elementName = elements[i].name;
            //console.log("elementName " + elementName);
            if(elementName == 'contractType' || elementName == 'contractStus'
                    || elementName =='isOptToRenew' || elementName == 'vendorType'){
                element.attr("disabled","disabled");
            }else{
                element.attr("readonly","readonly").addClass("readonly");
            }
        }
    }

    $('#form_newContract .label_text').hide();
    $("#add_row").hide();
    $("#remove_row").hide();
    $("#btnSave").hide();


    fn_loadAtchment('${details.atchFileGrpId}','detail');
}

$(function(){

	$('#contractType').change(function() {
		console.log('contractType change');
		$('#contractOtherRem').val('');
	    if($('#contractType option:selected').text().trim() == 'Others'){
	    	$('#contractOtherRem').removeAttr("readonly").removeClass("readonly");
	    }else{
	    	$('#contractOtherRem').attr("readonly","readonly").addClass("readonly");
	    }
	});

	$('#btnSave').click(function() {
		if(fn_valid()){
			if(action == 'new'){
				//Common.alert("valid");
				fn_attachmentInsertUpdate("new");
			}else{//edit button
				fn_attachmentInsertUpdate("edit");
			}

		}else{
			Common.alert("Please fill up all fields.");
		}
    });

	$('#edit').click(function() {
		var elements = document.getElementsByClassName("manCheck");
        if(elements.length > 0){
            for(i=0;i<elements.length;i++){
                var element = $(elements[i]);
                var elementName = elements[i].name;
                //console.log("elementName " + elementName);
                if(elementName == 'contractType' || elementName == 'contractStus'
                        || elementName =='isOptToRenew' || elementName == 'vendorType'){
                    element.prop("disabled", false);
                }else{
                    element.prop("readonly", false).removeClass("readonly");;
                }
            }
        }

        $('#form_newContract .label_text').show();
        $("#add_row").show();
        $("#remove_row").show();
        $("#btnSave").show();
        $("#edit").hide();
        $("#delete").hide();

        AUIGrid.destroy("#grid_cycle_wrap");
        cycleGridID = null;
        cycleGridID = AUIGrid.create("#grid_cycle_wrap", cycleColumnLayout, cycleGridPros);
        AUIGrid.setGridData(cycleGridID, cycleResult);

        AUIGrid.bind(cycleGridID, "cellClick", function( event ) {
            console.log("CellClick rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex + " clicked");
            selectRowIdxCycle = event.rowIndex;
            console.log('selectRowIdxCycle' + selectRowIdxCycle);
        });

    });

	$('#delete').click(function() {
		Common.confirm("Confirm to delete the contract?",function (){
			$("#sContStatus").val('8');
			var obj = $("#form_newContract").serializeJSON();
		    Common.ajax("POST", "/eAccounting/contract/deleteContractInfo.do", obj, function(result) {
		        console.log(result);
		        //$("#newClmNo").val(result.data.clmNo);
		        //fn_selectWebInvoiceItemList(result.data.clmNo);
		        //fn_selectWebInvoiceInfo(result.data.clmNo);

		            Common.alert('Contract Tracking ' + result.data.contTrackNo +' is deleted.');
		            $("#_contractViewPop").remove();
		            fn_searchContractTrackingList();

		        //fn_selectWebInvoiceList();
		    });
		});
	});

	$('#contractFile').change( function(evt) {
        var file = evt.target.files[0];
         if(file.name != contractFileName) {
             myFileCaches[0] = {file:file};
             if(contractFileName != "") {
                 update.push(contractFileId);
             }
         }
    });

	$('#file1').on('change', function (evt) {
        var data = null;
        var file = evt.target.files[0];
        if (typeof file == "undefined") {
            //alert("파일 선택 시 취소!!");

            delete myFileCaches[recentGridItem.id];

            /* AUIGrid.updateRowsById(cycleGridID, {
            	id: recentGridItem.id,
                selectedFile: ""
            }); */

            AUIGrid.setCellValue(cycleGridID, recentGridItem.rowIndex, recentGridItem.columnIndex, "");
            remove.push(AUIGrid.setCellValue(cycleGridID, recentGridItem.rowIndex, "atchFileId"));
            return;
        }

        if (file.size > 2048000) {
            alert("Files must not exceed 2MB.");
            $(this).val("");
            return;
        }

        if(recentGridItem.seq == null){
        	alert("Please fill in renewal cycle");
        	$(this).val("");
        	return;
        }
        myFileCaches[recentGridItem.seq] = {
        		seq: recentGridItem.seq,
            file: file
        };

        //alert("업로드 할 파일 선택 : \r\n" + file.name + "\r\n" + recentGridItem.contTrackId + ", " + recentGridItem.seq );

        // 선택 파일명 그리드에 출력 시킴
        /* AUIGrid.updateRowsById(cycleGridID, {
        	seq: recentGridItem.seq,
            selectedFile: file.name
        }); */

        AUIGrid.setCellValue(cycleGridID, recentGridItem.rowIndex, recentGridItem.columnIndex, file.name);
        if(AUIGrid.getCellValue(cycleGridID, recentGridItem.rowIndex, "atchFileId") != null){
        	update.push(AUIGrid.getCellValue(cycleGridID, recentGridItem.rowIndex, "atchFileId"));
        }

        $(this).val("");
    });
});

function fn_valid() {
    var isValid = true;
    var errormsg = "";
    var elements = document.getElementsByClassName("manCheck");
    if(elements.length > 0){
        for(i=0;i<elements.length;i++){
            var elementValue = elements[i].value;
            //console.log("elementValue " + elementValue);
            if(elementValue == ''){
            	isValid = false;
            	break;
            }
        }
    }

    /* var rowCount =  AUIGrid.getRowCount(cycleGridID);
    if (rowCount = 0) {

    } */
    return isValid;
}

/* function fn_attachmentUpload(st) {
    var formData = Common.getFormData("form_newContract");
    Common.ajaxFile("/eAccounting/contract/attachFileUpload.do", formData, function(result) {
        console.log(result);
        $("#atchFileGrpId").val(result.data.fileGroupKey);
        fn_insertContractInfo(st);
    });
} */

function fn_insertContractInfo(st) {
    var obj = $("#form_newContract").serializeJSON();
    var gridData = GridCommon.getEditData(cycleGridID);
    obj.gridData = gridData;
    console.log(obj);
    Common.ajax("POST", "/eAccounting/contract/insertContractInfo.do", obj, function(result) {
        console.log(result);
        //$("#newClmNo").val(result.data.clmNo);
        //fn_selectWebInvoiceItemList(result.data.clmNo);
        //fn_selectWebInvoiceInfo(result.data.clmNo);

        if(st == 'new') {
            Common.alert('New Contract Tracking ' + result.data.contTrackNo +' is created.');
            $("#_contractNewPop").remove();
            fn_searchContractTrackingList();
        }
        //fn_selectWebInvoiceList();
    });
}

function fn_attachmentInsertUpdate(st) {
    /* var formData = Common.getFormData("form_newContract");
    formData.append("atchFileGrpId", $("#atchFileGrpId").val());
    formData.append("update", JSON.stringify(update).replace(/[\[\]\"]/gi, ''));
    formData.append("remove", JSON.stringify(remove).replace(/[\[\]\"]/gi, ''));

    Common.ajaxFile("/eAccounting/contract/attachmentUpdate.do", formData, function(result) {
        console.log(result);
        //fn_updateContractInfo(st);
    }); */

    var formData = new FormData();
    var noFile = true;

    $.each(myFileCaches, function(n, v) {
        formData.append(n, v.file);
    });

    if (noFile) {
        console.log("no file.");
    }


    formData.append("atchFileGrpId", $("#atchFileGrpId").val());
    formData.append("update", JSON.stringify(update).replace(/[\[\]\"]/gi, ''));
    formData.append("remove", JSON.stringify(remove).replace(/[\[\]\"]/gi, ''));

    Common.ajaxFile("/eAccounting/contract/attachContractFileUpdate.do", formData, function(result) {
        console.log(result);
        $("#atchFileGrpId").val(result.data.fileGroupKey);

        if(st == 'new') {
        	fn_insertContractInfo(st);
        }else{
        	fn_updateContractInfo(st);
        }

    });



}

function fn_updateContractInfo(st) {
    var obj = $("#form_newContract").serializeJSON();//Common.getFormData("form_newContract");
    var gridData = GridCommon.getEditData(cycleGridID);
    obj.gridData = gridData;
    console.log(obj);
    Common.ajax("POST", "/eAccounting/contract/updateContractInfo.do", obj, function(result) {
        console.log(result);
        //$("#newClmNo").val(result.data.clmNo);
        //fn_selectWebInvoiceItemList(result.data.clmNo);
        //fn_selectWebInvoiceInfo(result.data.clmNo);

        if(st == 'edit') {
        	var renewalCycle = result.data.noOfCycle;
        	$("#numRenewCycle").val(renewalCycle);
        	fn_searchRenewalCycleDetails('view');
            fn_viewOnly();
            Common.alert('Contract Tracking ' + result.data.contTrackNo +' is updated successfully.');
            //$("#_contractViewPop").remove();
        }
        //fn_selectWebInvoiceList();
    });
}


function fn_loadAtchment(atchFileGrpId,action) {
    Common.ajax("Get", "/sales/order/selectAttachList.do", {atchFileGrpId :atchFileGrpId} , function(result) {
        //console.log(result);
       if(result) {
            if(result.length > 0) {
            	if(action == 'detail'){
            		for ( var i = 0 ; i < result.length ; i++ ) {
                        switch (result[i].fileKeySeq){
                        case '0':
                            contractFileId = result[i].atchFileId;
                            contractFileName = result[i].atchFileName;
                            $(".input_text[id='contractFileTxt']").val(contractFileName);

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
                                if(fileId != null) {
                                    fn_atchViewDown(fileGrpId, fileId);
                                }
                            });
                            break;
                         default:
                             console.log("cycle");
                        }
                    }
            	}else{
            		for ( var i = 0 ; i < result.length ; i++ ) {
            			fileId = result[i].atchFileId;
                        fileName = result[i].atchFileName;
                        AUIGrid.setCellValue(cycleGridID, result[i].fileKeySeq-1, "atchFileId", fileId);
            			AUIGrid.setCellValue(cycleGridID, result[i].fileKeySeq-1, "selectedFile", fileName);
                    }
            		cycleResult = AUIGrid.getGridData(cycleGridID);
            	}
            }
        }
   });
}

function fn_atchViewDown(fileGrpId, fileId) {
    var data = {
            atchFileGrpId : fileGrpId,
            atchFileId : fileId
    };
    Common.ajax("GET", "/eAccounting/webInvoice/getAttachmentInfo.do", data, function(result) {
        //console.log(result)
        var fileSubPath = result.fileSubPath;
        fileSubPath = fileSubPath.replace('\', '/'');

        if(result.fileExtsn == "jpg" || result.fileExtsn == "png" || result.fileExtsn == "gif") {
            //console.log(DEFAULT_RESOURCE_FILE + fileSubPath + '/' + result.physiclFileName);
            window.open(DEFAULT_RESOURCE_FILE + fileSubPath + '/' + result.physiclFileName);
        } else {
            //console.log("/file/fileDownWeb.do?subPath=" + fileSubPath + "&fileName=" + result.physiclFileName + "&orignlFileNm=" + result.atchFileName);
            window.open("/file/fileDownWeb.do?subPath=" + fileSubPath + "&fileName=" + result.physiclFileName + "&orignlFileNm=" + result.atchFileName);
        }
    });
}

function fn_removeFile(name){
    if(name == "CONTRACT") {
         $("#contractFile").val("");
         $(".input_text[id='contractFileTxt']").val("");
         $('#contractFile').change();
    }
}

function fn_addCycleGridRow() {
	AUIGrid.addRow(cycleGridID,
            {contractCommDt:""
           ,contractCommExpDt:""
           ,contractTerm:""
           ,noticePeriod:""
           ,contractRenewDt:""}
    , "last");
}

function fn_removeCycleGridRow() {
	console.log('delete cycle row selectRowIdxCycle' + selectRowIdxCycle);
    AUIGrid.removeRow(cycleGridID, selectRowIdxCycle);

    /* var gridData = GridCommon.getEditData(cycleGridID);
     if(gridData.remove.length > 0) {
         for(var i = 0; i < gridData.remove.length; i++) {
             console.log(gridData.remove[i].clmSeq);
         }
     } */
}

function fn_searchRenewalCycleDetails(action) {

	if(action=='view'){
		AUIGrid.destroy("#grid_cycle_wrap");
        cycleGridID = null;
        cycleGridID = AUIGrid.create("#grid_cycle_wrap", cycleColumnLayoutView, cycleGridPros);
	}
    var formData = $("#form_newContract").serialize();

    Common.ajax("GET", "/eAccounting/contract/selectContractCycleDetails.do", formData, function(result) {
        console.log(result);
        cycleResult = result;
        AUIGrid.setGridData(cycleGridID, cycleResult);

        var length = AUIGrid.getGridData(cycleGridID).length;
        if(length > 0) {
            //$("#cycleAtchFileGrpId").val( AUIGrid.getCellValue(cycleGridID, 0, "atchFileGrpId"));

            fn_loadAtchment($("#atchFileGrpId").val(),'cycle');

        }
    });




    //AUIGrid.setGridData(newGridID, $.parseJSON('${itemList}'));

    //console.log(cycleItemList);
    //AUIGrid.setGridData(cycleGridID, cycleItemList);
    //AUIGrid.setGridData(cycleGridID, $.parseJSON('${cycleResult}'));
    //console.log($.parseJSON('${itemList}'))
}

/*

function fn_atchViewDown(fileGrpId, fileId) {
    var data = {
            atchFileGrpId : fileGrpId,
            atchFileId : fileId
    };
    Common.ajax("GET", "/eAccounting/webInvoice/getAttachmentInfo.do", data, function(result) {
        //console.log(result)
        var fileSubPath = result.fileSubPath;
        fileSubPath = fileSubPath.replace('\', '/'');

        if(result.fileExtsn == "jpg" || result.fileExtsn == "png" || result.fileExtsn == "gif") {
            //console.log(DEFAULT_RESOURCE_FILE + fileSubPath + '/' + result.physiclFileName);
            window.open(DEFAULT_RESOURCE_FILE + fileSubPath + '/' + result.physiclFileName);
        } else {
            //console.log("/file/fileDownWeb.do?subPath=" + fileSubPath + "&fileName=" + result.physiclFileName + "&orignlFileNm=" + result.atchFileName);
            window.open("/file/fileDownWeb.do?subPath=" + fileSubPath + "&fileName=" + result.physiclFileName + "&orignlFileNm=" + result.atchFileName);
        }
    });
}

*/
</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Contract Tracking System (Create New Contract Input)</h1>
<ul class="right_opt">
	<li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>

</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<ul class="right_btns mb10">
	<li><p class="btn_blue2"><a href="#" id="edit">Edit</a></p></li>
	<li><p class="btn_blue2"><a href="#" id="delete">Delete</a></p></li>
</ul>

<section class="contractDetailArea"><!-- search_table start -->

<form action="#" method="post" enctype="multipart/form-data" id="form_newContract" name="form_newContract">
<input type="hidden" id="atchFileGrpId" name="atchFileGrpId" value="${details.atchFileGrpId}">
<!-- <input type="hidden" id="cycleAtchFileGrpId" name="cycleAtchFileGrpId" value=""> -->
<input type="hidden" id="contTrackId" name="contTrackId" value="${contTrackId}">
<input type="file" id="file1" style="visibility:hidden;"></input>
<input type="hidden" id="sContStatus" name="sContStatus" >

<table class="type1"  style="margin-bottom: 25;"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:150px" />
    <col style="width:*" />
	<col style="width:150px" />
	<col style="width:*" />
	<col style="width:150px" />
    <col style="width:*" />
</colgroup>
<tbody>

<tr>
    <th scope="row">Automatic Module Generated Running No.</th>
    <td>
        <input type="text" title="" placeholder="" class="w100p readonly" id="contTrackNo" name="contTrackNo" value="${details.contTrackNo}" readonly/>
    </td>
    <th scope="row"></th>
    <td>
    </td>
    <th scope="row"></th>
    <td>
    </td>
</tr>
<tr>
    <th scope="row">Contract Reference No.<span class="must">*</span></th>
    <td>
       <input type="text" title="" placeholder="" class="w100p manCheck edit" id="contractRefNo" value="${details.contractRefNo}" name="contractRefNo"/>
    </td>
    <th scope="row" >Date Created</th>
    <td>
        <input type="text" title="" id="keyDate" name="keyDate" placeholder="DD/MM/YYYY" class="w100p readonly" value="${details.crtDt}" readonly />
    </td>
    <th scope="row">Created By</th>
    <td>
        <input type="text" title="" id="createdBy" name="createdBy"  placeholder="" class="readonly w100p" readonly="readonly" value="${details.userName}"/>
    </td>
</tr>
<tr>
    <th scope="row">Type of Contract<span class="must">*</span></th>
    <td>
		<select id="contractType" name="contractType" class="w100p manCheck">
			<option value="">Choose One</option>
			<c:forEach var="list" items="${contractType}" varStatus="status">
            <option value="${list.codeId}"> ${list.codeName}</option>
            </c:forEach>
		</select>
    </td>
	<th scope="row">Contract Name</th>
	<td>
	   <input type="text" title="" placeholder="" class="w100p manCheck" id="contractName" name="contractName" value="${details.contractName}" />
	</td>
	<th scope="row">Contract Date <span style="font-style: italic">(as per Cover Page)</span></th>
    <td>
       <input type="text" title="" placeholder="DD/MM/YYYY" class="j_date w100p manCheck" id="_contractDt" name="_contractDt" value="${details.contDate}" />
       <!-- <input type="text" title="" placeholder="" class="w100p manCheck" id="contractDt" name="contractDt" oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*?)\..*/g, '$1');"/> -->
    </td>
</tr>
<tr>
    <th scope="row"></th>
    <td>
       <input type="text" title="" placeholder="remark for other" class="w100p readonly" id="contractOtherRem" name="contractOtherRem" value="${details.contTypeOther}" readonly />
    </td>
    <th scope="row">Upload Contract</th>
    <td>
        <div class='auto_file2 auto_file3'>
            <input type='file' title='file add'  id='contractFile' accept='image/*''/>
            <label>
                <input type='text' class='input_text' readonly='readonly' id='contractFileTxt'/>
                <span class='label_text attach_mod'><a href='#'>Upload</a></span>
            </label>
            <span class='label_text attach_mod'><a href='#' onclick='fn_removeFile("CONTRACT")'>Remove</a></span>
        </div>
    </td>
</tr>
<tr>
    <th scope="row">Contract Term</th>
    <td>
        <input type="text" title="" id="contractTerm" name="contractTerm" placeholder="in year unit" class="j_date w100p manCheck" value="${details.contTerm}"  oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*?)\..*/g, '$1');"/>
    </td>
    <th scope="row">Contract Commencement / Effective Date</th>
    <td>
    <div class="date_set w100p">
        <input type="text" title="" placeholder="DD/MM/YYYY" class="j_date w100p manCheck" id="_contractCommDt" name="_contractCommDt" value="${details.commDt}" />
    </div>
    </td>
    <th scope="row">Contract Expiry Date</th>
    <td>
        <input type="text" title="" placeholder="DD/MM/YYYY" class="j_date w100p manCheck" id="_contractExpDt" name="_contractExpDt" value="${details.expDt}" />
    </td>
</tr>
<tr>
    <th scope="row">Contract Status</th>
    <td>
        <select id="contractStus" name="contractStus" class="w100p manCheck" >
	        <option value="">Choose One</option>
	        <option value="1">Active</option>
	        <option value="82">Expired</option>
        </select>
    </td>
    <th scope="row">Option to Renew</th>
    <td>
       <select id="isOptToRenew" name="isOptToRenew" class="w100p manCheck" >
            <option value="">Choose One</option>
            <option value="1">Yes</option>
            <option value="0">No</option>
        </select>
    </td>
    <th scope="row">Number of Renewal Cycle</th>
    <td>
        <input type="text" title="" placeholder="" class="w100p readonly" id="numRenewCycle" name="numRenewCycle" value="${details.renewalCycle}"  readonly='readonly' />
    </td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h2>Renewal Cycle Details</h2>
<ul class="right_btns">
    <li><p class="btn_grid"><a href="#" id="add_row"><spring:message code="newWebInvoice.btn.add" /></a></p></li>
    <li><p class="btn_grid"><a href="#" id="remove_row"><spring:message code="newWebInvoice.btn.delete" /></a></p></li>
</ul>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<article class="grid_wrap"><!-- grid_wrap start -->
<div id="grid_cycle_wrap" style="width:100%; margin:0 auto;"></div>
</article><!-- grid_wrap end -->
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h2>Contract Owner Details</h2>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:150px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Department</th>
    <td>
        <input type="text" title="" placeholder="" class="w100p manCheck" id="deptName" name="deptName" value="${details.deptName}"/>
    </td>
    <th scope="row">Department Email</th>
    <td>
        <input type="text" title="" placeholder="" class="w100p manCheck" id="deptEmail" name="deptEmail" value="${details.deptEmail}"/>
    </td>
</tr>
<tr>
    <th scope="row">Person in Charge (PIC)</th>
    <td>
        <input type="text" title="" placeholder="" class="w100p manCheck" id="picName" name="picName" value="${details.picName}"/>
    </td>
    <th scope="row">PIC Email</th>
    <td>
        <input type="text" title="" placeholder="" class="w100p manCheck" id="picEmail" name="picEmail" value="${details.picEmail}"/>
    </td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h2>Vendor Details</h2>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:150px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Name</th>
    <td>
        <input type="text" title="" placeholder="" class="w100p manCheck" id="vendorName" name="vendorName" value="${details.venName}" />
    </td>
    <th scope="row">Registration/NRIC No.</th>
    <td>
        <input type="text" title="" placeholder="" class="w100p manCheck" id="vendorNric" name="vendorNric" value="${details.venNric}" />
    </td>
    <th scope="row">Vendor Type</th>
    <td>
        <select id="vendorType" name="vendorType" class="w100p manCheck" >
            <option value="">Choose One</option>
            <option value="965">Entity</option>
            <option value="964">Individual</option>
        </select>
    </td>
</tr>
<tr>
    <th scope="row">Department/PIC Name</th>
    <td>
        <input type="text" title="" placeholder="" class="w100p manCheck" id="vendorPicName" name="vendorPicName" value="${details.venPicName}" />
    </td>
    <th scope="row">Department/PIC Email</th>
    <td>
        <input type="text" title="" placeholder="" class="w100p manCheck" id="vendorPicEmail" name="vendorPicEmail" value="${details.venPicEmail}" />
    </td>
    <th scope="row">Department/PIC No.</th>
    <td>
        <input type="text" title="" placeholder="" class="w100p manCheck" id="vendorPicNo" name="vendorPicNo" value="${details.venPicNo}" />
    </td>
</tr>
</tbody>
</table><!-- table end -->
</form>

<ul class="center_btns mt20">
    <li><p class="btn_blue2 big"><a id="btnSave" href="#">Complete</a></p></li>
</ul>

</section><!-- search_result end -->

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->
