<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<style type="text/css">
/* 커스텀 행 스타일 */
.my-row-style {
    background:#9FC93C;
    font-weight:bold;
    color:#22741C;
}
/* 커스텀 칼럼 스타일 정의 */
.aui-grid-user-custom-left {
    text-align:left;
}
/* 커스텀 칼럼 스타일 정의 */
.aui-grid-user-custom-right {
    text-align:right;
}
</style>
<script type="text/javascript">

console.log("vendorManagement");
var vendorManagementColumnLayout = [ {
    dataField : "isActive",
    headerText : '<input type="checkbox" id="allCheckbox" style="width:15px;height:15px;">',
    width: 30,
    renderer : {
        type : "CheckBoxEditRenderer",
        showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
        editable : true, // 체크박스 편집 활성화 여부(기본값 : false)
        checkValue : "Active", // true, false 인 경우가 기본
        unCheckValue : "Inactive"
    }
}, {
	dataField : "reqNo",
    headerText : 'Vendor Request No',
    width : "10%"
}, {
    dataField : "vendorAccId",
    headerText : 'Supplier Code',
    width : "13.5%"
}, {
    dataField : "vendorName",
    headerText : 'Name',
    width : "40%"
}, {
    dataField : "vendorRegNoNric",
    headerText : 'Company Registration No/IC',
    width : "15%"
}, {
    dataField : "appvPrcssStus",
    headerText : 'Status',
    width : "10%"
}, {
    dataField : "appvPrcssDt",
    headerText : 'Approval Date',
    dataType : "date",
    //formatString : "dd/mm/yyyy",
    width : "10%"
}, {
    dataField : "flg",
    headerText : 'Flag',
    visible : false
}
];

//그리드 속성 설정
var vendorManagementGridPros = {
    // 페이징 사용
    usePaging : true,
    // 한 화면에 출력되는 행 개수 20(기본값:20)
    pageRowCount : 20,
    // 셀 선택모드 (기본값: singleCell)
    selectionMode : "multipleCells",
    showRowCheckColumn : false,
    showRowAllCheckBox : false
};

var vendorManagementGridID;
var vendorExcelGridID;
var gridDataLength = 0;
var bulkRptInt;

doGetCombo('/eAccounting/vendor/selectVendorType.do', '612', '','vendorTypeCmb', 'M', 'f_multiCombo');

function f_multiCombo(){
    $(function() {
        $('#vendorTypeCmb').change(function() {

        }).multipleSelect({
            selectAll: true
        });
    });
}

$(document).ready(function () {
	vendorManagementGridID = AUIGrid.create("#vendorManagement _grid_wrap", vendorManagementColumnLayout, vendorManagementGridPros);

	$("#search_supplier_btn").click(fn_supplierSearchPop);
	$("#search_regNo_btn").click(fn_supplierSearchPop);
	$("#search_costCenter_btn").click(fn_costCenterSearchPop);
	$("#new_vendor_btn").click(fn_newVendorPop);
	$("#edit_vendor_btn").click(fn_preEdit);
	$("#excelGridDown_btn").click(fn_getVendorAppvExcelInfo);


	var userId = "${SESSION_INFO.userId}";
	console.log("crtUserID: " + userId);

	 AUIGrid.bind(vendorManagementGridID, "cellEditEnd", function(event) {

	        // isActive 칼럼 수정 완료 한 경우
	        if(event.dataField == "isActive") {

	            // 그리드 데이터에서 isActive 필드의 값이 Active 인 행 아이템 모두 반환
	            var activeItems = AUIGrid.getItemsByValue(vendorManagementGridID, "isActive", "Active");

	            // 헤더 체크 박스 전체 체크 일치시킴.
	            if(activeItems.length != gridDataLength) {
	                document.getElementById("allCheckbox").checked = false;
	            } else if(activeItems.length == gridDataLength) {
	                 document.getElementById("allCheckbox").checked = true;
	            }
	        }
	    });
	AUIGrid.bind(vendorManagementGridID, "cellDoubleClick", function( event )
		    {
		        console.log("CellDoubleClick rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex + " clicked");
		        console.log(event);
		        console.log(event.item.userId);
		        console.log("CellDoubleClick reqNo : " + event.item.reqNo);
		        console.log("CellDoubleClick appvPrcssNo : " + event.item.appvPrcssNo);
		        console.log("CellDoubleClick appvPrcssStusCode : " + event.item.appvPrcssStusCode);
		        console.log("CellDoubleClick costCenterName : " + event.item.costCenterName);

		        console.log("crtUserID: " + event.item.userId);
		        console.log("Master table flag: " + event.item.flg);
		        if(event.item.flg == 'M')
		        {
		        	var vendorAccId = event.item.vendorAccId;
		        	console.log("vendor acc id: " + vendorAccId);
                    var costCenterName = event.item.costCenterName;
                    var costCenter = event.item.costCenter;
                    fn_MvendorRequestPop(event.item.appvPrcssNo, clmType, costCenterName, costCenter, vendorAccId);
		        }
		        else if(event.item.appvPrcssStusCode == "T") {
		        	if(userId != event.item.userId)
		        	{
		        		Common.alert("You are not allow to edit the record.");
		        	}
		        	else
		        	{
		        		fn_editVendorPop(event.item.reqNo, event.item.flg, event.item.vendorAccId, event.item.appvPrcssStusCode);
		        	}

		        } else {
		        	var reqNo = event.item.reqNo;
		        	var clmType = reqNo.substr(0, 2);
		        	var costCenterName = event.item.costCenterName;
		        	var costCenter = event.item.costCenter;
		        	fn_vendorRequestPop(event.item.appvPrcssNo, clmType, costCenterName, costCenter, reqNo);
		        }

		    });

	$("#edit_vendor_btn").click(function() {

        //Param Set
        var gridObj = AUIGrid.getSelectedItems(vendorManagementGridID);

        var list = AUIGrid.getCheckedRowItems(vendorManagementGridID);

        var reqNo = '';

        if(gridObj == null || gridObj.length <= 0 ){
            if(list == null || list.length < 1) {
                Common.alert("* No Value Selected. ");
                return;
            } else if(list.length > 1) {
                Common.alert("* Only 1 record can be selected.");
                return
            } else {
                reqNo = list[0].item.reqNo;
            }
        } else {
            reqNo = gridObj[0].item.reqNo;
        }

        $("#_reqNo").val(reqNo);
        console.log("reqNo : " + $("#_reqNo").val());

        $("#reportDownFileName").val(reqNo);

        //fn_report();
        //Common.alert('The program is under development.');
    });

	// Edit rejected web invoice
	$("#editRejBtn").click(fn_editRejected);

	$("#appvPrcssStus").multipleSelect("checkAll");

	fn_setToDay();

});


function fn_setToDay() {
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
   // $("#startDt").val(today)
    //$("#endDt").val(today)
}



function fn_setCostCenterEvent() {
    $("#newCostCenter").change(function(){
        var costCenter = $(this).val();
        console.log(costCenter);
        if(!FormUtil.isEmpty(costCenter)){
        	Common.ajax("GET", "/eAccounting/webInvoice/selectCostCenter.do?_cacheId=" + Math.random(), {costCenter:costCenter}, function(result) {
                console.log(result);
                if(result.length > 0) {
                	var row = result[0];
                    console.log(row);
                    $("#newCostCenterText").val(row.costCenterText);
                    $("#costCentrName").val(row.costCenterText);
                }
            });
        }
   });
}

function fn_setSupplierEvent() {
    $("#newMemAccId").change(function(){
        var memAccId = $(this).val();
        console.log(memAccId);
        if(!FormUtil.isEmpty(memAccId)){
            Common.ajax("GET", "/eAccounting/webInvoice/selectSupplier.do?_cacheId=" + Math.random(), {memAccId:memAccId}, function(result) {
                console.log(result);
                if(result.length > 0) {
                    var row = result[0];
                    console.log(row);
                    $("#newMemAccName").val(row.memAccName);
                    $("#gstRgistNo").val(row.gstRgistNo);
                    $("#bankCode").val(row.bankCode);
                    $("#bankName").val(row.bankName);
                    $("#bankAccNo").val(row.bankAccNo);
                }
            });
        }
   });
}

function fn_supplierSearchPop() {
    Common.popupDiv("/eAccounting/webInvoice/supplierSearchPop.do", {accGrp:"VM04"}, null, true, "supplierSearchPop");
}

function fn_costCenterSearchPop() {
	Common.popupDiv("/eAccounting/webInvoice/costCenterSearchPop.do", null, null, true, "costCenterSearchPop");
}

function fn_popSupplierSearchPop() {
    Common.popupDiv("/eAccounting/webInvoice/supplierSearchPop.do", {pop:"pop",accGrp:"VM04"}, null, true, "supplierSearchPop");
}

function fn_popCostCenterSearchPop() {
    Common.popupDiv("/eAccounting/webInvoice/costCenterSearchPop.do", {pop:"pop"}, null, true, "costCenterSearchPop");
}

function fn_newVendorPop() {
    Common.popupDiv("/eAccounting/vendor/newVendorPop.do", {callType:'new'}, null, true, "newVendorPop");
}


function fn_preEdit() {

	var userId = "${SESSION_INFO.userId}";
	var selectedItems = AUIGrid.getSelectedItems(vendorManagementGridID);
	//console.log('vendorAccId: ' + selectedItems[0].item.vendorAccId);

	if(selectedItems.length <= 0) {
        return;
    }
    else{
    	if(selectedItems[0].item.appvPrcssStusCode == "T")
    	{
    		if(selectedItems[0].item.flg == "M")
   			{
    			var reqNo = selectedItems[0].item.reqNo;
    			var flg = selectedItems[0].item.flg;
    			var vendorAccId = selectedItems[0].item.vendorAccId;
    			var appvPrcssStusCode = selectedItems[0].item.appvPrcssStusCode;
                fn_editVendorPop(reqNo, flg, vendorAccId, appvPrcssStusCode);
   			}
    		else{
    			if(userId != selectedItems[0].item.userId)
                {
                    Common.alert("You are not allow to edit the record.");
                }
                else
                {
                    var reqNo = selectedItems[0].item.reqNo;
                    var flg = selectedItems[0].item.flg;
                    var vendorAccId = selectedItems[0].item.vendorAccId;
                    var appvPrcssStusCode = selectedItems[0].item.appvPrcssStusCode;
                    fn_editVendorPop(reqNo, flg, vendorAccId, appvPrcssStusCode);
                }
    		}

        }
    	else if(selectedItems[0].item.appvPrcssStusCode == "A" && selectedItems[0].item.vendorAccId != null && selectedItems[0].item.vendorAccId != ""){
    		var reqNo = selectedItems[0].item.reqNo;
            var flg = selectedItems[0].item.flg;
            var vendorAccId = selectedItems[0].item.vendorAccId;
            var appvPrcssStusCode = selectedItems[0].item.appvPrcssStusCode;

                fn_editVendorPop(reqNo, flg, vendorAccId, appvPrcssStusCode);
    	}
    	else
    	{
    		var reqNo = selectedItems[0].item.reqNo;
            var clmType = reqNo.substr(0, 2);
            var costCenterName = selectedItems[0].item.costCenterName;
            var costCenter = selectedItems[0].item.costCenter;
            fn_vendorRequestPop(selectedItems[0].item.appvPrcssNo, clmType, costCenterName, costCenter, reqNo);
    	}
    }
}

function fn_editVendorPop(reqNo, flg, vendorAccId, appvPrcssStusCode) {

	 var selectedItems = AUIGrid.getSelectedItems(vendorManagementGridID);

     if(selectedItems.length <= 0) {
         Common.alert("No data selected.");
         return;
     }
     else{
    	 if(reqNo == null || reqNo == '')
    	{
    		 reqNo = selectedItems[0].item.reqNo;
    		 console.log('reqNo: ' + reqNo);
    	}
    	 var data = {
    	            reqNo : reqNo,
    	            callType : 'view',
    	            flg : flg,
    	            vendorAccId : vendorAccId,
    	            appvPrcssStusCode : appvPrcssStusCode
    	    };
    	    Common.popupDiv("/eAccounting/vendor/editVendorPop.do", data, null, true, "editVendorPop");
    	    fn_selectVendorList();
     }
}

function fn_vendorRequestPop(appvPrcssNo, clmType, costCenterName, costCenter, reqNo) {
    var data = {
            clmType : clmType
            ,appvPrcssNo : appvPrcssNo
            ,costCenterName : costCenterName
            ,costCenter : costCenter
            ,reqNo : reqNo
            ,viewType : "VIEW"
    };
    Common.popupDiv("/eAccounting/vendor/vendorRqstViewPop.do", data, null, true, "vendorRqstViewPop");
}

function fn_MvendorRequestPop(appvPrcssNo, clmType, costCenterName, costCenter, vendorAccId) {
    var data = {
            clmType : clmType
            ,appvPrcssNo : appvPrcssNo
            ,costCenterName : costCenterName
            ,costCenter : costCenter
            ,vendorAccId : vendorAccId
    };
    Common.popupDiv("/eAccounting/vendor/MvendorRqstViewPop.do", data, null, true, "vendorRequestViewMasterPop");
}

function fn_selectVendorList() {
    Common.ajax("GET", "/eAccounting/vendor/selectVendorList.do?_cacheId=" + Math.random(), $("#form_vendor").serialize(), function(result) {
    	console.log(result);
        AUIGrid.setGridData(vendorManagementGridID, result);
    });
}

function fn_setCostCenter() {
    $("#costCenter").val($("#search_costCentr").val());
    $("#costCenterText").val($("#search_costCentrName").val());
}

function fn_setSupplier() {
    $("#memAccId").val($("#search_memAccId").val());
    //$("#regNo").val($("#search_gstRgistNo").val());
}

function fn_setPopCostCenter() {
    $("#newCostCenter").val($("#search_costCentr").val());
    $("#newCostCenterText").val($("#search_costCentrName").val());
    $("#costCentrName").val($("#search_costCentrName").val());
}

function fn_setPopSupplier() {
    $("#newMemAccId").val($("#search_memAccId").val());
    $("#newMemAccName").val($("#search_memAccName").val());
    $("#gstRgistNo").val($("#search_gstRgistNo").val());
    $("#bankCode").val($("#search_bankCode").val());
    $("#bankName").val($("#search_bankName").val());
    $("#bankAccNo").val($("#search_bankAccNo").val());
}


function fn_setKeyInDate() {
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
    $("#keyDate").val(today)
}

function fn_checkEmpty() {
	console.log("fn_checkEmpty");
	var checkResult = true;
	/*
	if(FormUtil.isEmpty($("#invcDt").val())) {
        Common.alert('<spring:message code="webInvoice.invcDt.msg" />');
        checkResult = false;
        return checkResult;
    }
	*/

    if(FormUtil.isEmpty($("#vendorType").val())) {
        Common.alert('Please choose a Vendor Type');
        checkResult = false;
        return checkResult;
    }
    if(FormUtil.isEmpty($("#vendorGroup").val())) {
        Common.alert('Please choose a Vendor Group');
        checkResult = false;
        return checkResult;
    }
    if(FormUtil.isEmpty($("#newCostCenter").val())) {
        Common.alert('Please choose a Cost Center');
        checkResult = false;
        return checkResult;
    }
    if(FormUtil.isEmpty($("#regCompName").val())) {
        Common.alert('Please enter the Registered Company / Individual Name');
        checkResult = false;
        return checkResult;
    }
    if(FormUtil.isEmpty($("#regCompNo").val())) {
        Common.alert('Please enter the Company No / IC No');
        checkResult = false;
        return checkResult;
    }
    if(headerCheck == 1 && FormUtil.isEmpty($("#bankAccHolder").val())) {
        Common.alert('Please enter the Account Holder');
        checkResult = false;
        return checkResult;
    }
    if(headerCheck == 1 && FormUtil.isEmpty($("#bankAccNo").val())) {
           Common.alert('Please enter the Bank Account Number');
           checkResult = false;
           return checkResult;
    }
    if(headerCheck == 1 && FormUtil.isEmpty($("#bankList").val())) {
           Common.alert('Please choose a Bank');
           checkResult = false;
           return checkResult;
    }
    if(conditionalCheck == 1 && FormUtil.isEmpty($("#swiftCode").val())) {
           Common.alert('Please enter Swift Code');
           checkResult = false;
           return checkResult;
    }
    console.log("attachTd: " + $('#form_newVendor input[type=file]').get(0).files.length);
    console.log("inputText: " + $(".input_text").val());

    if($("input[name=attachTd]").length == 0 &&  $('#form_newVendor input[type=file]').get(0).files.length == 0 && FormUtil.isEmpty($(".input_text").val()))
    {
    	Common.alert('Please select an Attachment');
        checkResult = false;
        return checkResult;
    }


    $(".input_text").dblclick(function() {
        var oriFileName = $(this).val();
        var fileGrpId;
        var fileId;
        for(var i = 0; i < attachList.length; i++) {
            if(attachList[i].atchFileName == oriFileName) {
                fileGrpId = attachList[i].atchFileGrpId;
                fileId = attachList[i].atchFileId;
            }
        }
        fn_atchViewDown(fileGrpId, fileId);
    });

    //if($('#form_newVendor input[type=file]').get(0).files.length == 0)
    //{
    	//if ($('#attachTd').get(0).files.length === 0) {
    	// if(($("#attachTd").length) - 1 < 0) {
    	//if($('#attachTd').val() == null || $('#attachTd').val() == '')
    	//{
    		//Common.alert('Please select an Attachment');
           // checkResult = false;
           // return checkResult;
    	//}
    	return checkResult;
    //}
}

function fn_atchViewDown(fileGrpId, fileId) {
    var data = {
            atchFileGrpId : fileGrpId,
            atchFileId : fileId
    };
    Common.ajax("GET", "/eAccounting/webInvoice/getAttachmentInfo.do", data, function(result) {
        console.log(result);
        if(result.fileExtsn == "jpg" || result.fileExtsn == "png" || result.fileExtsn == "gif") {
            // TODO View
            var fileSubPath = result.fileSubPath;
            fileSubPath = fileSubPath.replace('\', '/'');
            console.log(DEFAULT_RESOURCE_FILE + fileSubPath + '/' + result.physiclFileName);
            window.open(DEFAULT_RESOURCE_FILE + fileSubPath + '/' + result.physiclFileName);
        } else {
            var fileSubPath = result.fileSubPath;
            fileSubPath = fileSubPath.replace('\', '/'');
            console.log("/file/fileDownWeb.do?subPath=" + fileSubPath
                    + "&fileName=" + result.physiclFileName + "&orignlFileNm=" + result.atchFileName);
            window.open("/file/fileDownWeb.do?subPath=" + fileSubPath
                + "&fileName=" + result.physiclFileName + "&orignlFileNm=" + result.atchFileName);
        }
    });
}

function fn_editRejected() {
    console.log("fn_editRejected");

    var gridObj = AUIGrid.getSelectedItems(vendorManagementGridID);
    var list = AUIGrid.getCheckedRowItems(vendorManagementGridID);

    if(gridObj != "" || list != "") {
        var status;
        var selClmNo;

        if(list.length > 1) {
            Common.alert("* Only 1 record is permitted. ");
            return;
        }

        if(gridObj.length > 0) {
            status = gridObj[0].item.appvPrcssStus;
            selClmNo = gridObj[0].item.reqNo;
        } else {
            status = list[0].item.appvPrcssStus;
            selClmNo = list[0].item.reqNo;
        }

        if(status == "Rejected") {
            Common.ajax("POST", "/eAccounting/vendor/editRejected.do", {clmNo : selClmNo}, function(result1) {
                console.log(result1);

                Common.alert("New claim number : " + result1.data.newClmNo);
                fn_selectVendorList()
            })
        } else {
            Common.alert("Only rejected claims are allowed to edit.");
        }
    } else {
        Common.alert("* No Value Selected. ");
        return;
    }
}

function fn_getVendorAppvExcelInfo() {
/*     var list = AUIGrid.getColumnValues(vendorManagementGridID, "reqNo", true);
    var selectedStatus=[];
     $('#appvPrcssStus :selected').each(function(){
         selectedStatus.push($(this).val());
      });
     if(list.length == 0){
         Common.alert("Please search for record first before download");
         return false;
     } */

     Common.ajax("GET", "/eAccounting/vendor/getAppvExcelInfo.do?_cacheId=" + Math.random(), $("#form_vendor").serialize(), function(result) {
        console.log(result);

        //그리드 생성
        fn_makeVendorGrid();

        AUIGrid.setGridData(vendorExcelGridID, result);

        if(result.length > 0) {
            /* var clmNo = result.data[0].appvReqKeyNo;
            var reqstDt = result.data[0].reqstDt;
            reqstDt = reqstDt.replace(/\//gi, ""); */

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

            today = yyyy+mm+dd;

            GridCommon.exportTo("excel_vendor_grid_wrap", 'xlsx', "VendorManagement" + "_" + today);
        } else {
            Common.alert('There is no data to download.');
        }
    });
}

function fn_makeVendorGrid(){

    var vendorExcelPop = [
    {
	    dataField : "reqNo",
	    headerText : 'Vendor Request No'
	}, {
	    dataField : "keyInDt",
	    headerText : 'Key In Date'
	}, {
	    dataField : "vendorGrp",
	    headerText : 'Vendor Group'
	}, {
	    dataField : "vendorTypeDesc",
	    headerText : 'Vendor Type'
	}, {
	    dataField : "costCenter",
	    headerText : 'Cost Center'
	}, {
	    dataField : "requestor",
	    headerText : 'Create User ID'
	}, {
	    dataField : "vendorAccId",
	    headerText : 'Supplier Code'
	}, {
	    dataField : "vendorName",
	    headerText : 'Name'
	}, {
	    dataField : "vendorRegNoNric",
	    headerText : 'Company Register No/IC'
	}, {
	    dataField : "email",
	    headerText : 'Email Address (Payment Advice)'
	}, {
	    dataField : "email2",
	    headerText : 'Email Address 2 (Payment Advice)'
	}, {
	    dataField : "appvPrcssStus",
	    headerText : 'Status'
	}, {
	    dataField : "appvPrcssDt",
	    headerText : 'Approval Date',
	    dataType : "date"
	    //formatString : "dd/mm/yyyy",
	}
        ];

     var vendorExcelOptions = {
            enableCellMerge : true,
            showStateColumn:false,
            fixedColumnCount    : 4,
            showRowNumColumn    : false,
            //headerHeight : 100,
            usePaging : false
      };

     vendorExcelGridID = GridCommon.createAUIGrid("#excel_vendor_grid_wrap", vendorExcelPop, "", vendorExcelOptions);
}

</script>

<style>
.cRange,
.cRange.w100p,
.w100p{width:100%!important;}
</style>

<form id="dataForm">
    <input type="hidden" id="reportFileName" name="reportFileName" value="/e-accounting/Web_Invoice.rpt" /><!-- Report Name  -->
    <input type="hidden" id="viewType" name="viewType" value="PDF" /><!-- View Type  -->
    <!-- <input type="hidden" id="reportDownFileName" name="reportDownFileName" value="123123" /> --><!-- Download Name -->
    <input type="hidden" id="reportDownFileName" name="reportDownFileName" value="" />
    <input type="hidden" id="displayCostCenterName" name="displayCostCenterName" value="${costCenterName}"/><!-- View Type  -->

    <!-- params -->
    <input type="hidden" id="_reqNo" name="V_REQNO" />
</form>

<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on"></a></p>
<h2>Vendor Management</h2>
<ul class="right_btns">
    <c:if test="${PAGE_AUTH.funcView == 'Y'}">
        <!--  <li><p class="btn_blue"><a href="#" onclick="javascript:fn_newVendorPop()">New</a></p></li>-->
        <li><p class="btn_blue"><a href="#" id="new_vendor_btn">New</a></p></li>
        <li><p class="btn_blue"><a href="#" id="edit_vendor_btn">Edit</a></p></li>
        <li><p class="btn_blue"><a href="#" onclick="javascript:fn_selectVendorList()"><span class="search"></span>Search</a></p></li>
    </c:if>
</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id="form_vendor">
<input type="hidden" id="memAccName" name="memAccName">
<input type="hidden" id="costCenterText" name="costCenterText">

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
    <th scope="row">Supplier</th>
        <td>
		    <input type="text" id="memAccId" name="memAccId" class="search_btn" title="" placeholder="" class="fl_left"/>
		    <a href="#"  id="search_supplier_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
        </td>
    <th scope="row">Company Registration No/IC</th>
        <td>
		    <input type="text" id="regNo" name="regNo" class="search_btn" title="" placeholder="" class="fl_left" />
		    <!--  <a href="#" id="search_regNo_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>-->
        </td>
</tr>
<tr>
    <th scope="row">Request Date</th>
        <td>
            <div class="date_set w100p"><!-- date_set start -->
                <p><input type="text" title="Request Start Date" placeholder="DD/MM/YYYY" class="j_date" id="startDt" name="startDt"/></p>
                    <span>to</span>
                <p><input type="text" title="Request End Date" placeholder="DD/MM/YYYY" class="j_date" id="endDt" name="endDt"/></p>
            </div><!-- date_set end -->
        </td>
    <th scope="row">Cost Centre Code</th>
        <td>
            <input type="text" id="costCenter" name="costCenter" class="search_btn" title="" placeholder="" class="fl_left"/>
            <a href="#"  id="search_costCenter_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
        </td>
</tr>
<tr>
    <th scope="row">Approval Date</th>
	    <td>
	        <div class="date_set w100p"><!-- date_set start -->
	            <p><input type="text" title="Approval Start Date" placeholder="DD/MM/YYYY" class="j_date" id="appStartDt" name="appStartDt"/></p>
	            <span>to</span>
	            <p><input type="text" title="Approval End Date" placeholder="DD/MM/YYYY" class="j_date" id="appEndDt" name="appEndDt"/></p>
	        </div><!-- date_set end -->
	    </td>
    <th scope="row">Status</th>
	    <td>
	       <select class="multy_select" multiple="multiple" id="appvPrcssStus" name="appvPrcssStus">
		        <option value="T">Draft</option>
		        <option value="R">Request</option>
		        <option value="P">Pending for Approval</option>
		        <option value="A">Approved</option>
		        <option value="J">Rejected</option>
           </select>
	    </td>
</tr>
<tr>
    <th scope="row">Vendor Request Number</th>
        <td>
            <div class="date_set w100p"><!-- date_set start -->
            <p><input style="text-transform: uppercase" type="text" title="" id="vendorReqNoFrom" name="vendorReqNoFrom" class="cRange" /></p>
            <span>to</span>
            <p><input style="text-transform: uppercase" type="text" title="" id="vendorReqNoTo" name="vendorReqNoTo" class="cRange"  /></p>
        </div><!-- date_set end -->
        </td>
    <th scope="row">Vendor Type</th>
        <td>
        <select id="vendorTypeCmb" name="vendorTypeCmb" class="multy_select" multiple="multiple">
        </td>
</tr>
</tbody>
</table><!-- table end -->

</form>
</section><!-- search_table end -->

<aside class="link_btns_wrap"><!-- link_btns_wrap start -->
    <p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
    <dl class="link_list">
        <dt>Link</dt>
        <dd>
            <ul class="btns">
                <li><p class="link_btn"><a href="#" id="editRejBtn">Edit Rejected</a></p></li>
            </ul>
            <ul class="btns">
            </ul>
            <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
        </dd>
    </dl>
</aside><!-- link_btns_wrap end -->

<section class="search_result"><!-- search_result start -->

<ul class="right_btns">
    <c:if test="${PAGE_AUTH.funcPrint == 'Y'}">
        <li><p class="btn_grid"><a href="#" id="excelGridDown_btn">Excel Filter</a></p></li>
    </c:if>
</ul>


<article class="grid_wrap" id="vendorManagement _grid_wrap"><!-- grid_wrap start -->
</article><!-- grid_wrap end -->

<article class="grid_wrap" id="excel_vendor_grid_wrap" style="display: none;"><!-- grid_wrap start -->
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- content end -->
