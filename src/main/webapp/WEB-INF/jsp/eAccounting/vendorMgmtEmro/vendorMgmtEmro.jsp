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

console.log("vendorMgmtEmro");

var checkBoxOptions = {
        type : "CheckBoxEditRenderer",
        checkValue : 1,
        unCheckValue : 0,
        editable : true
    };

var gridDetailDataLength=0;

var vendorMgmtEmroColumnLayout = [ {
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
    width : "35%"
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
}, {
    dataField : "syncEmro",
    headerText : "Sync to eMRO <br/><input type='checkbox' id='syncroCb' style='width:15px;height:15px;''>",
    width : "5%",
    renderer: checkBoxOptions
}
];



var vendorMgmtEmroGridPros = {
    usePaging : true,
    pageRowCount : 20,
    //showStateColumn : true,
    headerHeight : 50,
    displayTreeOpen : true
};

var vendorMgmtEmroGridID;
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
};

$(document).ready(function () {
	vendorMgmtEmroGridID = AUIGrid.create("#vendorMgmtEmro_grid_wrap", vendorMgmtEmroColumnLayout, vendorMgmtEmroGridPros);

	$("#search_supplier_btn").click(fn_supplierSearchPop);
	$("#search_regNo_btn").click(fn_supplierSearchPop);
	$("#search_costCenter_btn").click(fn_costCenterSearchPop);
	$("#excelGridDown_btn").click(fn_getVendorAppvExcelInfo);
	$("#save_btn").click(fn_save);


	var userId = "${SESSION_INFO.userId}";
	console.log("crtUserID: " + userId);

	AUIGrid.bind(vendorMgmtEmroGridID, "cellDoubleClick", function(event){
		        if(event.item.flg == 'M')
		        {
		        	var vendorAccId = event.item.vendorAccId;
		        	console.log("vendor acc id: " + vendorAccId);
                    var costCenterName = event.item.costCenterName;
                    var costCenter = event.item.costCenter;
                    fn_MvendorRequestPop(event.item.appvPrcssNo, clmType, costCenterName, costCenter, vendorAccId);
		        }
		         else {
		        	var reqNo = event.item.reqNo;
		        	var clmType = reqNo.substr(0, 2);
		        	var costCenterName = event.item.costCenterName;
		        	var costCenter = event.item.costCenter;
		        	fn_vendorRequestPop(event.item.appvPrcssNo, clmType, costCenterName, costCenter, reqNo);
		        }

		    });

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


function fn_vendorRequestPop(appvPrcssNo, clmType, costCenterName, costCenter, reqNo) {
    var data = {
            clmType : clmType
            ,appvPrcssNo : appvPrcssNo
            ,costCenterName : costCenterName
            ,costCenter : costCenter
            ,reqNo : reqNo
            ,viewType : "VIEW"
    };
    Common.popupDiv("/eAccounting/vendorMgmtEmro/vendorRqstViewPop.do", data, null, true, "vendorRqstViewPop");
}

function fn_MvendorRequestPop(appvPrcssNo, clmType, costCenterName, costCenter, vendorAccId) {
    var data = {
            clmType : clmType
            ,appvPrcssNo : appvPrcssNo
            ,costCenterName : costCenterName
            ,costCenter : costCenter
            ,vendorAccId : vendorAccId
    };
    Common.popupDiv("/eAccounting/vendorMgmtEmro/MvendorRqstViewPop.do", data, null, true, "vendorRequestViewMasterPop");
}

function fn_selectVendorList() {

    Common.ajax("GET", "/eAccounting/vendorMgmtEmro/selectVendorList.do?_cacheId=" + Math.random(), $("#form_vendor").serialize(), function(result) {
    	console.log(result);
    	AUIGrid.bind(vendorMgmtEmroGridID, "headerClick", headerClickHandler);
        AUIGrid.setGridData(vendorMgmtEmroGridID, result);
        gridDetailDataLength = AUIGrid.getGridData(vendorMgmtEmroGridID).length;
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
	        dataField : "vendorType",
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

	function headerClickHandler(event) {
        let headerName = event.dataField;
        let pid = event.pid;
        let isChecked = !document.getElementById(event.orgEvent.target.id).checked;
        for(idx = 0 ; idx < gridDetailDataLength ; idx++){
            updateRows(pid,isChecked,headerName,idx);
        }
       return false;
   };

	function updateRows(pid, isChecked,name,rowIndex){
        let checkedValue = !isChecked ? 1 : 0;
        let checkItem = new Object();
        checkItem[name] = checkedValue;

        if(pid == "#vendorMgmtEmro_grid_wrap"){
            AUIGrid.updateRow(vendorMgmtEmroGridID, checkItem, rowIndex);
        }/* else{
            AUIGrid.updateRow(vendorMgmtEmroGridID, checkItem, rowIndex);
        } */
    }

	function fn_save(){
		let updateList = AUIGrid.getEditedRowItems(vendorMgmtEmroGridID);
        let insertNewList = AUIGrid.getAddedRowItems(vendorMgmtEmroGridID);
        let data = {};
        data.update = updateList;
        data.add = insertNewList;
        var editArray = [];

        if(data.update.length < 1 && data.add.length < 1){
            Common.alert("No Changes");
            return;
        }

        Common.ajax("POST", "/eAccounting/vendorMgmtEmro/saveEmroData.do" , data , function(result){
            Common.alert("Data is being saved successfully", function() {
            });
        });
	}


</script>

<style>
.cRange,
.cRange.w100p,
.w100p{width:100%!important;}
</style>

<form id="dataForm">
    <input type="hidden" id="viewType" name="viewType" value="PDF" /><!-- View Type  -->
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
<h2>Sync to eMRO</h2>
<ul class="right_btns">
    <c:if test="${PAGE_AUTH.funcView == 'Y'}">
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
		        <!-- <option value="T">Draft</option>
		        <option value="R">Request</option>
		        <option value="P">Pending for Approval</option> -->
		        <option value="A">Approved</option>
<!-- 		        <option value="J">Rejected</option> -->
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
<tr>
    <th scope="row">Sync Status</th>
    <td>
           <select class="multy_select" multiple="multiple" id="syncStatus" name="syncStatus">
                <option value="0">None</option>
                <option value="1">Sync</option>
           </select>
    </td>
    <th></th>
    <td></td>
</tr>
</tbody>
</table><!-- table end -->

</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<ul class="right_btns">
    <c:if test="${PAGE_AUTH.funcPrint == 'Y'}">
        <li><p class="btn_grid"><a href="#" id="excelGridDown_btn">Excel Filter</a></p></li>
    </c:if>
    <c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
        <li><p class="btn_grid"><a href="#" id="save_btn">Save</a></p></li>
    </c:if>
</ul>

<article class="grid_wrap" id="vendorMgmtEmro_grid_wrap"><!-- grid_wrap start -->
</article><!-- grid_wrap end -->

<article class="grid_wrap" id="excel_vendor_grid_wrap" style="display: none;"><!-- grid_wrap start -->
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- content end -->
