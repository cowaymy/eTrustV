<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<style type="text/css">
/* 커스텀 칼럼 스타일 정의 */
.aui-grid-user-custom-left {
    text-align:left;
}
/* 커스텀 칼럼 스타일 정의 */
.aui-grid-user-custom-right {
    text-align:right;
}
/* 특정 칼럼 드랍 리스트 왼쪽 정렬 재정의*/
#my_grid_wrap-aui-grid-drop-list-taxCode .aui-grid-drop-list-ul {
     text-align:left;
 }

 .edit-column {
    visibility:hidden;
}
</style>
<script type="text/javascript">
var clmSeq = 0;
var atchFileGrpId;
var attachList;
var callType = "${callType}";
var selectRowIdx;
var deleteRowIdx;
var newGridID;
var clmNo = '${clmNo}';
//file action list
var update = new Array();
var remove = new Array();
var myFileCaches = {};
var myGridID;

var myGridColumnLayout = [ {
    dataField : "clmSubNo",
    headerText : '<spring:message code="newWebInvoice.seq" />'
}
, {
    dataField : "clmSeq",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}
, {
    dataField : "dutyAllDt",
    headerText : 'Duty Allowance Date'
}
, {
    dataField : "salesOrderNo",
    headerText : 'Order No.'
}
, {
    dataField : "dutyType",
    visible : false
}
, {
    dataField : "dutyTypeName",
    headerText : 'Duty Allowance Type'
}
, {
    dataField : "svcType",
    visible : false
}
, {
    dataField : "svcTypeName",
    headerText : 'Service Type'
}
, {
    dataField : "totalAmt",
    headerText : 'Total Amount',
    dataType: "numeric",
    formatString : "#,##0.00",
}
/* , {
    dataField : "remark",
    headerText : 'Remark'
} */
, {
    dataField : "atchFileGrpId",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}
, {
    dataField : "isAttach",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}
, {dataField : "atchFileId",  headerText : '<spring:message code="sal.title.text.download" />', width : '10%', styleFunction : cellStyleFunction,
    renderer : {
      type : "ButtonRenderer",
      labelText : "Download",
      onclick : function(rowIndex, columnIndex, value, item) {

          Common.showLoader();
           var fileId = value;
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

//그리드 속성 설정
var myGridPros = {
		usePaging : true,
    softRemoveRowMode : false,
    rowIdField : "clmSeq",
    headerHeight : 40,
    height : 160,
    // 셀 선택모드 (기본값: singleCell)
    selectionMode : "multipleCells"
};

$(document).ready(function () {

	myGridID = AUIGrid.create("#my_grid_wrap", myGridColumnLayout, myGridPros);
	if(callType == 'edit'){
		var data = {clmNo : clmNo};
		Common.ajaxSync("GET", "/eAccounting/ctDutyAllowance/selectCtDutyAllowanceItemList.do?_cacheId=" + Math.random(), data, function(result) {
	        console.log(result);
	        $("#newMemAccId").val(result[0].memAccId);
	        $("#newDscCode").val(result[0].dscCode);
	        AUIGrid.setGridData(myGridID, result);
	    });

		$("#newMemAccId").addClass("readonly");
        $("#supplier_search_btn").hide();

		fn_getAllTotAmt();
	}

    $("#add_row").click(fn_addMyGridRow);

    $("#remove_row").click(fn_removeMyGridRow);

    $("#newMemAccId").change(
		function() {
            var param = {memAccId:$('#newMemAccId').val()};
            if($('#newMemAccId').val() != ""){
            	Common.ajaxSync("GET", "/eAccounting/ctDutyAllowance/selectSupplier.do", param, function(result) {
            		console.log("ctsuty here");
            		var row = result[0];
            		if(result.length == 1){
            			$("#newMemAccId").val(row.memAccId);
                        $("#newDscCode").val(row.dscCode);
                        $("#newDscName").val(row.dscName);
            		}else{
            			alert("CT CODE NOT FOUND");
            			$("#newMemAccId").val("");
            		}
                    //AUIGrid.setGridData(supplierGridID, result);

                });
            }
      });

    $("#orderNo_search_btn").click(
   		function() {
   			if(fn_orderValidation()){
   				$("#svcTypeName").val($("#svcType option:selected").text());
   				fn_popGoOrderSearch();
   			}
   		});

    $("#_salesOrderNo").change(
    function() {
    	if(fn_orderValidation()){

         if($('#newMemAccId').val() != ""){
         	var params =
             {searchOrdNo:$('#_salesOrderNo').val()
             ,searchSvcType:$('#svcType').val()
             ,searchCtCode:$('#newMemAccId').val()
             ,searchDutyDt:$('#dutyAllDt').val()
             };
         	Common.ajax("GET", "/eAccounting/ctDutyAllowance/selectSearchOrderNo",params, function(result) {
         		var row = result[0];
         		if(row == null || row == ""){
         			alert("Invalid order.");
         			$('#_salesOrderNo').val("");
         		}
             });
         }
    	}else{
    		$('#_salesOrderNo').val("");
    	}
  });

    $("#supplier_search_btn").click(fn_popSubSupplierSearchPop);

    $("#svcType").change(
	function() {
		$("#labelFileInput").val("");
		$("#_salesOrderNo").val("");

		if($('#svcType').val() == 'SB' || $('#svcType').val() == 'SV' ){
			$("#labelFileInput").removeClass("readonly");
               $("#labelFile").show();
               $("#_salesOrderNo").addClass("readonly");
               $("#orderNo_search_btn").hide();
		}else{
			$("#labelFileInput").addClass("readonly");
               $("#labelFile").hide();
               $("#_salesOrderNo").removeClass("readonly");
               $("#orderNo_search_btn").show();
		}


	});

    $("#tempSave_btn").click(
    		function() {
    				fn_insertStaffClaimExp("temp");
    		});

    $("#request_btn").click(function() {
    	var date = new Date().getDate();
        if(date.toString().length == 1){
            date = "0" + date;
        }
        console.log("what day? " + date);
        if(date > 15){
            Common.alert('Before 15th of the month just able to SUBMIT Claim.');
            return;
        }
    	fn_approveLinePop($("#newMemAccId").val(), $("#newClmMonth").val());
    });

    fn_setEvent();

    fn_setToMonth();

    $("#labelFileInput").addClass("readonly");
    $("#labelFile").hide();
});

$(function(){
	$('#fileName').change(function(evt) {

        var file = evt.target.files[0];
        if(file == null && myFileCaches[1] != null){
            delete myFileCaches[1];
        }else if(file != null){
            myFileCaches[1] = {file:file};
        }
    });
});

function fn_setEvent() {
	AUIGrid.bind(myGridID, "cellClick", function( event )
    {
        console.log("CellClick rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex + " clicked");
        selectRowIdx = event.rowIndex;
    });

     // 파일 선택하기
    $('#file').on('change', function(evt) {
        var data = null;
        var file = evt.target.files[0];
        if (typeof file == "undefined") {
            console.log("파일 선택 시 취소!!");

            delete myFileCaches[selectRowIdx + 1];

            AUIGrid.updateRow(mileageGridID, {
                atchFileName :  ""
            }, selectRowIdx);
            return;
        }

        /* if(file.size > 2048000) {
            alert("개별 파일은 2MB 를 초과해선 안됩니다.");
            return;
        } */

        console.log(recentGridItem);

        // 서버로 보낼 파일 캐시에 보관
        myFileCaches[selectRowIdx + 1  ] = {
            file : file
        };

        // 파일 수정이라면 수정하는 파일 아이디 보관
        if(!FormUtil.isEmpty(recentGridItem.atchFileGrpId)) {
            update.push(recentGridItem.atchFileId);
            console.log(JSON.stringify(update));
        }

        console.log("업로드 할 파일 선택 : \r\n" + file.name);
        console.log('myFileCaches1' + myFileCaches);

        // 선택 파일명 그리드에 출력 시킴
        AUIGrid.updateRow(mileageGridID, {
            atchFileName :  file.name
        }, selectRowIdx);
    });
}

function fn_setToMonth() {
    var month = new Date();

    var mm = month.getMonth() + 1;
    var yyyy = month.getFullYear();

    if(mm < 10){
        mm = "0" + mm
    }

    month = mm + "/" + yyyy;
    $("#newClmMonth").val(month);
}

function fn_popSubSupplierSearchPop() {
    Common.popupDiv("/eAccounting/ctDutyAllowance/ctCodeSearchPop.do", {pop:"pop",accGrp:"VM08"}, null, true, "supplierSearchPop");
}

function fn_setPopSupplier() {
    $("#newMemAccId").val($("#search_memAccId").val());
    $("#newDscCode").val($("#search_dscCode").val());
    $("#newDscName").val($("#search_dscName").val());

    /* $("#newMemAccName").val($("#search_memAccName").val());
    $("#bankCode").val($("#search_bankCode").val());
    $("#bankName").val($("#search_bankName").val());
    $("#bankAccNo").val($("#search_bankAccNo").val());
    $("#bankName").val($("#search_dscCode").val());
    $("#bankAccNo").val($("#search_dscName").val()); */
}

function fn_popGoOrderSearch() {
    Common.popupDiv('/eAccounting/ctDutyAllowance/searchOrderNoPop.do', $('#form_newStaffClaim').serializeJSON(), null, true, '_searchDiv');
}

/* 인풋 파일(멀티) */
function setInputFile2(){//인풋파일 세팅하기
    //$(".auto_file2").append("<label><input type='text' class='input_text' readonly='readonly' /><span class='label_text'><a href='#'>File</a></span></label><span class='label_text'><a href='#'>Add</a></span><span class='label_text'><a href='#'>Delete</a></span>");
}

//그리드의 셀 버턴 클릭 처리
function fn_myButtonClick(item){
	console.log("fn_myButtonClick Action")
    recentGridItem = item; // 그리드의 클릭한 행 아이템 보관
    var input = $("#file");
    input.trigger('click'); // 파일 브라우저 열기
};

function fn_addMyGridRow() {

	if(!fn_addValidation()){
		return false;
	}

	var fileName = $("#fileName").val().split('\\');
    var dutyTypeName = '';
    var atchFileGrpId = '';
    var atchFileId = '';
    var isAttach = 'No';
    if($(":input:radio[name=dutyType]:checked").val() == 'p'){
        dutyTypeName = 'Public Holiday';
    }else if($(":input:radio[name=dutyType]:checked").val() == 'r'){
        dutyTypeName = 'Rest Day';
    }

	var formData = new FormData();
    $.each(myFileCaches, function(n, v) {
        console.log("n : " + n + " v.file : " + v.file);
        formData.append(n, v.file);
    });

    if(fileName != null && fileName != ""){
    	Common.ajaxFile("/eAccounting/ctDutyAllowance/attachFileUpload.do", formData, function(result) {
            console.log(result);
            atchFileGrpId = result.data.fileGroupKey;
            atchFileId = result.data.atchFileId;
            isAttach = 'Yes';

            Common.ajaxSync("GET", "/eAccounting/ctDutyAllowance/selectCtDutyAllowanceSubSeq.do", {docNoId:"185"}, function(result1) {
                console.log(result1);
                AUIGrid.addRow(myGridID,
                        {clmSubNo:result1.data.subSeq
                        ,dutyAllDt:$("#dutyAllDt").val()
                        ,salesOrderNo:$("#_salesOrderNo").val()
                        ,dutyType:$(":input:radio[name=dutyType]:checked").val()
                        ,dutyTypeName:dutyTypeName
                        ,svcType:$("#svcType option:selected").val()
                        ,svcTypeName:$("#svcType option:selected").text()
                        ,totalAmt:50.00
                        /* ,remark:$("#dutyAllDesc").val() */
                        ,atchFileGrpId:atchFileGrpId
                        ,atchFileId:atchFileId
                        ,isAttach:isAttach
                        }
                    , "last");

                fn_getAllTotAmt();
                fn_clearData();
            });
    	});


    }else{
    	Common.ajaxSync("GET", "/eAccounting/ctDutyAllowance/selectCtDutyAllowanceSubSeq.do", {docNoId:"185"}, function(result1) {
            console.log(result1);
            AUIGrid.addRow(myGridID,
                    {clmSubNo:result1.data.subSeq
                    ,dutyAllDt:$("#dutyAllDt").val()
                    ,salesOrderNo:$("#_salesOrderNo").val()
                    ,dutyType:$(":input:radio[name=dutyType]:checked").val()
                    ,dutyTypeName:dutyTypeName
                    ,svcType:$("#svcType option:selected").val()
                    ,svcTypeName:$("#svcType option:selected").text()
                    ,totalAmt:50.00
                    /* ,remark:$("#dutyAllDesc").val() */
                    ,atchFileGrpId:atchFileGrpId
                    ,atchFileId:atchFileId
                    ,isAttach:isAttach
                    }
                , "last");

            fn_getAllTotAmt();
            fn_clearData();
        });
    }
}

function fn_getAllTotAmt() {
    // allTotAmt GET, SET
    var allTotAmt = 0.00;
    var totAmtList = AUIGrid.getColumnValues(myGridID, "totalAmt", true);
    console.log("totAmtList " +totAmtList.length);
    for(var i = 0; i < totAmtList.length; i++) {
        allTotAmt += totAmtList[i];
    }
    console.log($.number(allTotAmt,2,'.',''));
    allTotAmt = $.number(allTotAmt,2,'.',',');
    //allTotAmt += "";
    console.log(allTotAmt);
    //$("#allTotAmt_text").text(allTotAmt.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,'));
    $("#allTotAmt_text").text(allTotAmt);
}

function fn_clearData() {
    // $("#form_newStaffClaim").each(function() {
    //    this.reset();
    //});

    $("#dutyAllDt").val("");
    $("#_salesOrderNo").val("");
    $("#svcType").val("");
    $("#labelFileInput").val("");
    $("#dutyAllDesc").val("");
    $("#labelFileInput").addClass("readonly");
    $("#labelFile").hide();
    $("#_salesOrderNo").removeClass("readonly");
    $("#orderNo_search_btn").show();

}

function fn_removeFile(name){
    if(name == "atchFile") {
         $("#atchFile").val("");
         $('#atchFile').change();
    }
}

function fn_removeMyGridRow() {
    // Grid Row 삭제
    AUIGrid.removeRow(myGridID, selectRowIdx);
    fn_getAllTotAmt();

}

function fn_orderValidation(){

	if(null == $("#newMemAccId").val() || '' == $("#newMemAccId").val()){
		Common.alert('CT Code is required in order to search order.');
        return false;
	}

	if(null == $("#dutyAllDt").val() || '' == $("#dutyAllDt").val()){
        Common.alert('Duty Allowance Date is required in order to search order.');
        return false;
    }

	if(null == $("#svcType").val() || '' == $("#svcType").val()){
        Common.alert('ServiceType is required in order to search order.');
        return false;
    }
    return true;
}

function fn_addValidation(){

    if(null == $("#dutyAllDt").val() || '' == $("#dutyAllDt").val()){
        Common.alert('Duty Allowance Date is required.');
        return false;
    }

    if(null == $("#svcType").val() || '' == $("#svcType").val()){
        Common.alert('ServiceType is required.');
        return false;
    }

    if(null != $("#dutyAllDt").val() || '' != $("#dutyAllDt").val()){
    	var ExistingDutyDtArray = AUIGrid.getColumnValues(myGridID, "dutyAllDt");
        console.log(jQuery.inArray($("#dutyAllDt").val(),ExistingDutyDtArray));
        if(jQuery.inArray($("#dutyAllDt").val(),ExistingDutyDtArray) == 0){
            Common.alert('Duplicate OT Claim.');
            return false;
        }
    }

    if(null != $("#_salesOrderNo").val() && '' != $("#_salesOrderNo").val()){
    	var ExistingOrderArray = AUIGrid.getColumnValues(myGridID, "salesOrderNo");
    	console.log('ExistingOrderArray ' + ExistingOrderArray);
    	console.log('$("#_salesOrderNo").val() ' + $("#_salesOrderNo").val());
    	console.log(jQuery.inArray($("#_salesOrderNo").val(),ExistingOrderArray));
        if(jQuery.inArray($("#_salesOrderNo").val(),ExistingOrderArray) == 0){
            Common.alert('Duplicate Order No.');
            return false;
        }
    }

    if($('#svcType').val() == 'SB' || $('#svcType').val() == 'SV' ){
    	var validate = true;
    	 if(null == $("#fileName").val() || '' == $("#fileName").val()){
    	        Common.alert('Attachement is required.');
    	        validate = false;
    	 }
    	 return validate;
    }else{
    	var validate = true;
        if(null == $("#_salesOrderNo").val() || '' == $("#_salesOrderNo").val()){
               Common.alert('Sales Order Number is required.');
               validate = false;
           }
        return validate;
    }

    return true;
}

//addcolum button hidden
function cellStyleFunction(rowIndex, columnIndex, value, headerText, item, dataField){
    console.log("attach ma " + item.isAttach);
    if(item.isAttach == 'Yes'){
        return '';
    }else{
        return "edit-column";
    }
}

function fn_insertStaffClaimExp(action) {
    // row의 수가 0개 이상일때만 insert
    var gridDataList = AUIGrid.getOrgGridData(myGridID);

    $("#claimMonth").val($("#newClmMonth").val())

    if(gridDataList.length > 0){
    	if(callType == 'new'){
    		var data = {
                    form : $("#form_newStaffClaim").serializeJSON()
                    ,gridDataList : gridDataList
                    ,totAmt : Number($("#allTotAmt_text").text().replace(/,/gi, ""))
                    ,docNoId:"185"
            }
            console.log(data);
            Common.ajax("POST", "/eAccounting/ctDutyAllowance/insertCtDutyAllowanceExp.do", data, function(result) {
                console.log(result);
                clmNo = result.data.clmNo;
                //fn_selectStaffClaimItemList();

                if(action == "temp"){
                    Common.alert('<spring:message code="newWebInvoice.tempSave.msg" />');
                    $("#newCtDutyAllowancePop").remove();
                }
                fn_selectStaffClaimList();
            });
    	}else{
  	        var gridDataObj = GridCommon.getEditData(myGridID);
  	        gridDataObj.clmNo = clmNo;
  	      gridDataObj.newClaimMonth = $("#newClmMonth").val();
  	        gridDataObj.allTotAmt = Number($("#allTotAmt_text").text().replace(/,/gi, ""));
  	        console.log(gridDataObj);
  	        Common.ajax("POST", "/eAccounting/ctDutyAllowance/updateCtDutyAllowanceExp.do", gridDataObj, function(result) {
  	            console.log(result);
  	            clmNo = result.data.clmNo;
  	            //fn_selectStaffClaimItemList();
  	            if(action == "temp"){
  	                Common.alert('<spring:message code="newWebInvoice.tempSave.msg" />');
  	                $("#editCtDutyAllowancePop").remove();
  	            }
  	            fn_selectStaffClaimList();
  	        });
    	}
    } else {
        Common.alert('<spring:message code="pettyCashExp.noData.msg" />');
    }
}

function fn_approveLinePop(memAccId, clmMonth) {
    // check request - Request once per user per month
    Common.ajax("POST", "/eAccounting/ctDutyAllowance/checkOnceAMonth.do?_cacheId=" + Math.random(), {clmType:"CTA", newMemAccId:$("#newMemAccId").val(), clmMonth:$("#clmMonth").val()}, function(result) {
        console.log(result);
        if(result.data > 0) {
            Common.alert(result.message);
        } else {
            // tempSave를 하지 않고 바로 submit인 경우
            fn_insertStaffClaimExp();

            var data = {
                    clmNo : clmNo
                    ,totAmt : Number($("#allTotAmt_text").text().replace(/,/gi, ""))
                    ,memAccId : $("#newMemAccId").val()
            };

            Common.popupDiv("/eAccounting/ctDutyAllowance/approveLinePop.do", data, null, true, "approveLineSearchPop");
        }
    });
}

function closeApproveLine(){
	if(callType == 'new'){
		$("#approveLineSearchPop").remove();
		$("#newCtDutyAllowancePop").remove();
		fn_selectStaffClaimList();
	}else{
		$("#approveLineSearchPop").remove();
		$("#editCtDutyAllowancePop").remove();
		fn_selectStaffClaimList();
	}
}
</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="newStaffClaim.title" /></h1>
<ul class="right_opt">
	<li><p class="btn_blue2"><a href="#"><spring:message code="newWebInvoice.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id="form_newStaffClaim">
<input type="hidden" id="claimMonth" name="newClaimMonth">

<ul class="right_btns mb10">
	<li><p class="btn_blue2"><a href="#" id="tempSave_btn"><spring:message code="newWebInvoice.btn.tempSave" /></a></p></li>
	<li><p class="btn_blue2"><a href="#" id="request_btn"><spring:message code="newWebInvoice.btn.submit" /></a></p></li>
</ul>

<table class="type1"><!-- table start -->
<caption><spring:message code="webInvoice.table" /></caption>
<colgroup>
	<col style="width:130px" />
	<col style="width:*" />
	<col style="width:150px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row"><spring:message code="ctClaim.cdCode" /></th>
	<td><input type="text" title="" placeholder="" class="" id="newMemAccId" name="newMemAccId"/><a href="#" class="search_btn" id="supplier_search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a></td>
	<th scope="row">DSC code</th>
    <td><input type="text" title="" placeholder="" class="readonly" id="newDscCode" name="dscCode" value="${dscCode}" readonly="readonly" />
    <%-- <a href="#" class="search_btn" id="dscCode_search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a> --%>
    </td>
    <input type="hidden" id="newDscName" name="dscName">
</tr>
<tr>
	<th scope="row"><spring:message code="pettyCashExp.clmMonth" /></th>
	<td><input type="text" title="Claim Month" placeholder="MM/YYYY" class="j_date2 readonly " id="newClmMonth" name="clmMonth" disabled="disabled"/></td>
</tr>
</tbody>
</table><!-- table end -->

<table class="type1 mt10" id="dutyDetails"><!-- table start -->
<caption><spring:message code="webInvoice.table" /></caption>
<colgroup>
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:150px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Duty Allowance Date</th>
    <td colspan="1"><input type="text" title="Duty Allowance Date" placeholder="DD/MM/YYYY" class="j_date " id="dutyAllDt" name="dutyAllDt" /></td>
    <th scope="row">Service Type</th>
    <td>
    <select class="" id="svcType" name="svcType">
        <option value="">Choose One</option>
        <option value="INS">INSTALLATION</option>
        <option value="AS">AFTER SERVICE</option>
        <option value="PR">PRODUCT RETURN</option>
        <option value="SB">STANDBY *REQUIRE MONTHLY SCHEDULE*</option>
        <option value="SV">SITE VISIT *REQUIRE ATTACHMENT*</option>
    </select>
    </td>
    <input type="hidden" id="svcTypeName" name="svcTypeName">
</tr>
<tr>
    <th scope="row">Duty Allowance Type</th>
    <td>
    <label><input type="radio" id="dutyType" name="dutyType" checked="checked" value="p" data="Public Holiday"/><span>Public Holiday</span></label>
    <label><input type="radio" id="dutyType" name="dutyType" value="r" data="Rest Day"/><span>Rest Day</span></label>
    </td>
    <th scope="row">Order No.</th>
    <td><input type="text" title="" placeholder="" class="" id="_salesOrderNo" name="salesOrderNo" value="${orderNo}"/><a href="#" class="search_btn" id="orderNo_search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a></td>
</tr>
<tr>
    <th scope="row"><spring:message code="newWebInvoice.attachment" /></th>
    <td id="attachTd" colspan="3">
<!--     <div class="auto_file2 auto_file3">auto_file start
    <input type="file" title="file add" id="fileName" name="fileName" />
    <label ><input type='text' class='input_text' id="labelFileInput" readonly='readonly' /><span class='label_text' id="labelFile"><a href='#'>File</a></span></label>
    </div>auto_file end -->
<!--           <div class="auto_file2">
            <input type="file" title="file add" id="sofFile" accept="image/*"/>
            <label>
                <input type='text' class='input_text' readonly='readonly' id='labelFileInput'/>
                <span class='label_text'><a href='#'>Upload</a></span>
            </label>
        </div> -->

        <div class="auto_file2">
            <input type="file" title="file add" id="fileName" />
            <label>
                <input type='text' class='input_text' id='labelFileInput'/>
                <span class='label_text' id="labelFile"><a href='#'>Upload</a></span>
            </label>
        </div>


    </td>
    <input type="hidden" id="atchFileId" name="atchFileId">

</tr>
<tr style="display: none;">
    <th scope="row">Remarks</th>
    <td colspan="3"><input type="text" title="" placeholder="" class="w100p" id="dutyAllDesc" name="dutyAllDesc" /></td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="title_line" id="myGird_btn"><!-- title_line start -->
<ul class="right_btns">
    <li><p class="btn_grid"><a href="#" id="add_row"><spring:message code="newWebInvoice.btn.add" /></a></p></li>
    <li><p class="btn_grid"><a href="#" id="remove_row"><spring:message code="newWebInvoice.btn.delete" /></a></p></li>
</ul>
</aside><!-- title_line end -->

<article class="grid_wrap" id="my_grid_wrap"><!-- grid_wrap start -->
</article><!-- grid_wrap end -->
<input type="file" id="file" style="display: none;"></input>

<%-- <aside class="title_line" id="mileage_btn" style="display: none;"><!-- title_line start -->
<ul class="right_btns">
    <li><p class="btn_grid"><a href="#" id="mileage_add"><spring:message code="newWebInvoice.btn.add" /></a></p></li>
    <li><p class="btn_grid"><a href="#" id="mileage_remove"><spring:message code="newWebInvoice.btn.delete" /></a></p></li>
</ul>
</aside><!-- title_line end -->
<article class="grid_wrap" id="mileage_grid_wrap"><!-- grid_wrap start -->
</article><!-- grid_wrap end --> --%>
<!-- 파일 input , 감춰놓기 -->

<%-- <ul class="center_btns">
    <li><p class="btn_blue2"><a href="#" id="add_btn"><spring:message code="newWebInvoice.btn.add" /></a></p></li>
    <li><p class="btn_blue2"><a href="#" id="delete_btn"><spring:message code="newWebInvoice.btn.delete" /></a></p></li>
    <li><p class="btn_blue2"><a href="#" id="clear_btn"><spring:message code="pettyCashNewCustdn.clear" /></a></p></li>
</ul> --%>

<aside class="title_line"><!-- title_line start -->
<h2 class="total_text"><spring:message code="newWebInvoice.total" /><span id="allTotAmt_text"></span></h2>
</aside><!-- title_line end -->

</form>
</section><!-- search_table end -->

<%-- <section class="search_result"><!-- search_result start -->
--%>

<%--
<article class="grid_wrap" id="newStaffCliam_grid_wrap"><!-- grid_wrap start -->
</article><!-- grid_wrap end -->

</section><!-- search_result end --> --%>

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->