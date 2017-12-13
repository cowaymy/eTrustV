<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript" language="javascript">

	//AUIGrid 생성 후 반환 ID
	var listMyGridID;

    var _option = {
    	width : "1200px", // 창 가로 크기
        height : "800px" // 창 세로 크기
    };
    
    $(document).ready(function(){
        //AUIGrid 그리드를 생성합니다.
        createAUIGrid();

        // 셀 더블클릭 이벤트 바인딩
        AUIGrid.bind(listMyGridID, "cellDoubleClick", function(event) {
            fn_setDetail(listMyGridID, event.rowIndex);
        });
        
        doGetComboOrder('/common/selectCodeList.do', '10', 'CODE_ID',   '', 'listAppType',     'M', 'fn_multiCombo'); //Common Code
        //doGetCombo('/common/selectCodeList.do',       '10', '',   'listAppType', 'M', 'fn_multiCombo'); //Common Code
        doGetProductCombo('/common/selectProductCodeList.do', '', '', 'listProductId', 'S'); //Product Code

        doGetComboSepa('/common/selectBranchCodeList.do',  '1', ' - ', '', 'listKeyinBrnchId', 'M', 'fn_multiCombo'); //Branch Code
        doGetComboSepa('/common/selectBranchCodeList.do',  '5', ' - ', '',   'listDscBrnchId', 'M', 'fn_multiCombo'); //Branch Code
        
        doGetComboData('/status/selectStatusCategoryCdList.do', {selCategoryId : 5, parmDisab : 0}, '', 'listRentStus', 'M', 'fn_multiCombo')
    });

    // 컬럼 선택시 상세정보 세팅.
    function fn_setDetail(gridID, rowIdx){
        //(_url, _jsonObj, _callback, _isManualClose, _divId, _initFunc)
        Common.popupDiv("/sales/order/orderDetailPop.do", { salesOrderId : AUIGrid.getCellValue(gridID, rowIdx, "ordId") }, null, true, "_divIdOrdDtl");
    }
    
    // 리스트 조회.
    function fn_selectListAjax() {        
        Common.ajax("GET", "/sales/order/selectOrderJsonList", $("#listSearchForm").serialize(), function(result) {
            AUIGrid.setGridData(listMyGridID, result);
        });
    }
    
    function fn_copyChangeOrderPop() {
        var selIdx = AUIGrid.getSelectedIndex(listMyGridID)[0];
        if(selIdx > -1) {
            Common.popupDiv("/sales/order/copyChangeOrder.do", { salesOrderId : AUIGrid.getCellValue(listMyGridID, selIdx, "ordId") }, null , true);
        }
        else {
            Common.alert("Pre-Order Missing" + DEFAULT_DELIMITER + "<b>No pre-order selected.</b>");
        }
    }

    $(function(){
        $('#btnCopy').click(function() {
            fn_copyChangeOrderPop();
        });
        $('#btnCopyBulk').click(function() {
            Common.popupDiv("/sales/order/bulkOrderPop.do");
        });
        $('#btnNew').click(function() {
            Common.popupDiv("/sales/order/orderRegisterPop.do");
        });
        $('#btnEdit').click(function() {
            fn_orderModifyPop();
        });
        $('#btnReq').click(function() {
            fn_orderRequestPop();
        });
        $('#btnSimul').click(function() {
            fn_orderSimulPop();
        });
        $('#btnSrch').click(function() {
        	if(fn_validSearchList()) fn_selectListAjax();
        });
        $('#btnClear').click(function() {
        	$('#listSearchForm').clearForm();
        });
        $('#btnVaLetter').click(function() {

        	$("#dataForm").show();
        	//Param Set
            var gridObj = AUIGrid.getSelectedItems(listMyGridID);
            
            if(gridObj == null || gridObj.length <= 0 ){
                Common.alert("* No order Selected. ");
                return;
            }
            
            var custID = gridObj[0].item.custId;
            $("#_repCustId").val(custID);
            
            var date = new Date().getDate();
            if(date.toString().length == 1){
                date = "0" + date;
            } 
            $("#downFileName").val("CustomerVALetter_"+custID+"_"+date+(new Date().getMonth()+1)+new Date().getFullYear());
            
            fn_letter_report();
        	
        });
        $('#btnExport').click(function() {
        	
        	var grdLength = "0";
        	grdLength = AUIGrid.getGridData(listMyGridID).length;
        	
        	if(Number(grdLength) > 0){
        	    GridCommon.exportTo("#list_grid_wrap", "xlsx", "SalesSearchResultList");
        		
	        }else{
	            Common.alert("* No record to export. ");
	        }
     
        });
        $('#btnSim').click(function() {
            Common.alert('<b>The program is under development.</b>');
        });
        $('#btnRentalPaySet').click(function() {
        	Common.popupDiv("/sales/order/orderRentalPaySettingUpdateListPop.do", null, null, true);
        });
        $('#btnSof').click(function() {
        	Common.popupDiv("/sales/order/orderSOFListPop.do", null, null, true);
        });
        $('#btnDdCrc').click(function() {
        	Common.popupDiv("/sales/order/orderDDCRCListPop.do", null, null, true);
        });
        $('#btnAsoSales').click(function() {
        	Common.popupDiv("/sales/order/orderASOSalesReportPop.do", null, null, true);
        });
        $('#btnYsListing').click(function() {
        	Common.popupDiv("/sales/order/orderSalesYSListingPop.do", null, null, true);
        });
    });
    
    function fn_letter_report() {
        var option = {
            isProcedure : false 
        };
        Common.report("dataForm", option);
    }
    
    function fn_validSearchList() {
        var isValid = true, msg = "";

        if(FormUtil.isEmpty($('#listOrdNo').val())
        && FormUtil.isEmpty($('#listCustId').val())
        && FormUtil.isEmpty($('#listCustName').val())
        && FormUtil.isEmpty($('#listCustIc').val())) {
            
            if(FormUtil.isEmpty($('#listOrdStartDt').val()) || FormUtil.isEmpty($('#listOrdEndDt').val())) {
                isValid = false;
                msg += "* Please select order date<br/>";
            }
            else {
                var diffDay = fn_diffDate($('#listOrdStartDt').val(), $('#listOrdEndDt').val());
                 
                if(diffDay > 31) {
                    isValid = false;
                    msg += "* Please enter search period within one month.";
                }
            }
        }

        if(!isValid) Common.alert("Order Search" + DEFAULT_DELIMITER + "<b>"+msg+"</b>");

        return isValid;
    }
    
    function fn_diffDate(startDt, endDt) {
        var arrDt1 = startDt.split("/");
        var arrDt2 = endDt.split("/");

        var dt1 = new Date(arrDt1[2], arrDt1[1]-1, arrDt1[0]);
        var dt2 = new Date(arrDt2[2], arrDt2[1]-1, arrDt2[0]);

        var diff = dt2 - dt1;
        var day = 1000*60*60*24;
        
        return (diff/day);
    }
    
    function fn_orderModifyPop() {
        var selIdx = AUIGrid.getSelectedIndex(listMyGridID)[0];
        if(selIdx > -1) {
            Common.popupDiv("/sales/order/orderModifyPop.do", { salesOrderId : AUIGrid.getCellValue(listMyGridID, selIdx, "ordId") }, null , true);
        }
        else {
            Common.alert("Sales Order Missing" + DEFAULT_DELIMITER + "<b>No sales order selected.</b>");
        }
    }
    
    function fn_orderRequestPop() {
        var selIdx = AUIGrid.getSelectedIndex(listMyGridID)[0];
        if(selIdx > -1) {
            Common.popupDiv("/sales/order/orderRequestPop.do", { salesOrderId : AUIGrid.getCellValue(listMyGridID, selIdx, "ordId") }, null , true);
        }
        else {
            Common.alert("Sales Order Missing" + DEFAULT_DELIMITER + "<b>No sales order selected.</b>");
        }
    }
    
    function fn_orderSimulPop() {
        var selIdx = AUIGrid.getSelectedIndex(listMyGridID)[0];
        if(selIdx > -1) {
            Common.popupDiv("/sales/order/orderRentToOutrSimulPop.do", { ordNo : AUIGrid.getCellValue(listMyGridID, selIdx, "ordNo") }, null , true);
        }
        else {
            Common.popupDiv("/sales/order/orderRentToOutrSimulPop.do", { ordId : '' }, null, true);
        }
    }
    
    function createAUIGrid() {
        
    	//AUIGrid 칼럼 설정
        var columnLayout = [
            { headerText : "Order No",        dataField : "ordNo",       editable : false, width : 80  }
          , { headerText : "Status",          dataField : "ordStusCode", editable : false, width : 80  }
          , { headerText : "App Type",        dataField : "appTypeCode", editable : false, width : 80  }
          , { headerText : "Order Date",      dataField : "ordDt",       editable : false, width : 100 }
          , { headerText : "Ref No",          dataField : "refNo",       editable : false, width : 60  }
          , { headerText : "Product",         dataField : "productName", editable : false, width : 150 }
          , { headerText : "Cust ID",         dataField : "custId",      editable : false, width : 70  }
          , { headerText : "Customer Name",   dataField : "custName",    editable : false}
          , { headerText : "NRIC/Company No", dataField : "custIc",      editable : false, width : 100 }
          , { headerText : "Creator",         dataField : "crtUserId",   editable : false, width : 100 }
          , { headerText : "PV Year",         dataField : "pvYear",      editable : false, width : 60  }
          , { headerText : "PV Mth",          dataField : "pvMonth",     editable : false, width : 60  }
          , { headerText : "ordId",           dataField : "ordId",       visible  : false }
            ];

        //그리드 속성 설정
        var gridPros = {
            usePaging           : true,         //페이징 사용
            pageRowCount        : 20,           //한 화면에 출력되는 행 개수 20(기본값:20)            
            editable            : false,            
            fixedColumnCount    : 1,            
            showStateColumn     : false,             
            displayTreeOpen     : false,            
            selectionMode       : "singleRow",  //"multipleCells",            
            headerHeight        : 30,       
            useGroupingPanel    : false,        //그룹핑 패널 사용
            skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
            wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
            showRowNumColumn    : true,         //줄번호 칼럼 렌더러 출력    
            noDataMessage       : "No order found.",
            groupingMessage     : "Here groupping"
        };
        
        listMyGridID = GridCommon.createAUIGrid("list_grid_wrap", columnLayout, "", gridPros);
    }
    
    function fn_calcGst(amt) {
        var gstAmt = 0;
        if(FormUtil.isNotEmpty(amt) || amt != 0) {
            gstAmt = Math.floor(amt*(1/1.06));
        }
        return gstAmt;
    }
    
    function fn_multiCombo(){
        $('#listAppType').change(function() {
            //console.log($(this).val());
        }).multipleSelect({
            selectAll: true, // 전체선택 
            width: '100%'
        });
        $('#listAppType').multipleSelect("checkAll");
        $('#listKeyinBrnchId').change(function() {
            //console.log($(this).val());
        }).multipleSelect({
            selectAll: true, // 전체선택 
            width: '100%'
        });
        $('#listDscBrnchId').change(function() {
            //console.log($(this).val());
        }).multipleSelect({
            selectAll: true, // 전체선택 
            width: '100%'
        });
        $('#listOrdStusId').multipleSelect("checkAll");
        $('#listRentStus').change(function() {
            //console.log($(this).val());
        }).multipleSelect({
            selectAll: true, // 전체선택 
            width: '100%'
        });
//      $('#listRentStus').multipleSelect("checkAll");
    }

    $.fn.clearForm = function() {
        return this.each(function() {
            var type = this.type, tag = this.tagName.toLowerCase();
            if (tag === 'form'){
                return $(':input',this).clearForm();
            }
            if (type === 'text' || type === 'password' || type === 'hidden' || tag === 'textarea'){
                this.value = '';
            }else if (type === 'checkbox' || type === 'radio'){
                this.checked = false;
            }else if (tag === 'select'){
                this.selectedIndex = 0;
            }
        });
    };
</script>

<section id="content"><!-- content start -->
<ul class="path">
	<li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
	<li>Sales</li>
	<li>Order</li>
	<li>Order</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>Order List</h2>
<ul class="right_btns">
    <li><p class="btn_blue"><a id="btnCopy" href="#" >Copy(Change)</a></p></li>
    <li><p class="btn_blue"><a id="btnCopyBulk" href="#" >Copy(Bulk)</a></p></li>
    <li><p class="btn_blue"><a id="btnNew" href="#" >New</a></p></li>
    <li><p class="btn_blue"><a id="btnEdit" href="#">Edit</a></p></li>
    <li><p class="btn_blue"><a id="btnReq" href="#">Request</a></p></li>
    <li><p class="btn_blue"><a id="btnSimul" href="#">Rent To Outright Simulator</a></p></li>
	<li><p class="btn_blue"><a id="btnSrch" href="#"><span class="search"></span>Search</a></p></li>
	<li><p class="btn_blue"><a id="btnClear" href="#"><span class="clear"></span>Clear</a></p></li>
</ul>
</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->

<!-- report Form -->
<form id="dataForm">
    <input type="hidden" id="fileName" name="reportFileName" value="/sales/CustVALetter.rpt" /><!-- Report Name  -->
    <input type="hidden" id="viewType" name="viewType" value="PDF" /><!-- View Type  -->
    <input type="hidden" id="downFileName" name="reportDownFileName" value="" /> <!-- Download Name -->
    
    <!-- params -->
    <input type="hidden" id="_repCustId" name="@CustID" />
</form>


<form id="listSearchForm" name="listSearchForm" action="#" method="post">
    <input id="listSalesOrderId" name="salesOrderId" type="hidden" />
    
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:130px" />
	<col style="width:*" />
	<col style="width:160px" />
	<col style="width:*" />
	<col style="width:190px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row">Order No</th>
	<td>
	<input id="listOrdNo" name="ordNo" type="text" title="Order No" placeholder="Order Number" class="w100p" />
	</td>
	<th scope="row">Application Type</th>
	<td>
	<select id="listAppType" name="appType" class="multy_select w100p" multiple="multiple"></select>
	</td>
	<th scope="row">Order Date</th>
	<td>
	<div class="date_set w100p"><!-- date_set start -->
	<p><input id="listOrdStartDt" name="ordStartDt" type="text" value="" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
	<span>To</span>
	<p><input id="listOrdEndDt" name="ordEndDt" type="text" value="" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
	</div><!-- date_set end -->
	</td>
</tr>
<tr>
	<th scope="row">Order Status</th>
	<td>
	<select id="listOrdStusId" name="ordStusId" class="multy_select w100p" multiple="multiple">
		<option value="1">Active</option>
		<option value="4">Completed</option>
		<option value="10">Cancelled</option>
	</select>
	</td>
	<th scope="row">Key-In Branch</th>
	<td>
	<select id="listKeyinBrnchId" name="keyinBrnchId" class="multy_select w100p" multiple="multiple"></select>
	</td>
	<th scope="row">DSC Branch</th>
	<td>
    <select id="listDscBrnchId" name="dscBrnchId" class="multy_select w100p" multiple="multiple"></select>
	</td>
</tr>
<tr>
	<th scope="row">Customer ID</th>
	<td>
	<input id="listCustId" name="custId" type="text" title="Customer ID" placeholder="Customer ID (Number Only)" class="w100p" />
	</td>
	<th scope="row">Customer Name</th>
	<td>
	<input id="listCustName" name="custName" type="text" title="Customer Name" placeholder="Customer Name" class="w100p" />
	</td>
	<th scope="row">NRIC/Company No</th>
	<td>
	<input id="listCustIc" name="custIc" type="text" title="NRIC/Company No" placeholder="NRIC/Company Number" class="w100p" />
	</td>
</tr>
<tr>
	<th scope="row">Product</th>
	<td>
	<select id="listProductId" name="productId" class="w100p"></select>
	</td>
	<th scope="row">Salesman</th>
	<td>
	<input id="listSalesmanCode" name="salesmanCode" type="text" title="Salesman" placeholder="Salesman (Member Code)" class="w100p" />
	</td>
	<th scope="row">Rental Status</th>
	<td>
	<select id="listRentStus" name="rentStus" class="multy_select w100p" multiple="multiple"></select>
	</td>
</tr>
<tr>
	<th scope="row">Reference No</th>
	<td>
	<input id="listRefNo" name="refNo" type="text" title="Reference No<" placeholder="Reference Number" class="w100p" />
	</td>
	<th scope="row">PO No</th>
	<td>
	<input id="listPoNo" name="poNo" type="text" title="PO No" placeholder="PO Number" class="w100p" />
	</td>
	<th scope="row">Contact No</th>
	<td>
	<input id="listContactNo" name="contactNo" type="text" title="Contact No" placeholder="Contact No" class="w100p" />
	</td>
</tr>
<tr>
	<th scope="row">VA Number</th>
	<td>
	<input type="text" title="VA Number" placeholder="Virtual Account (VA) Number" class="w100p" />
	</td>
	<th scope="row">Serial Number</th>
	<td>
	<input type="text" title="Serial Number" placeholder="Serial Number" class="w100p" />
	</td>
	<th scope="row">Sirim Number</th>
	<td>
	<input type="text" title="Sirim Number" placeholder="Sirim Number" class="w100p" />
	</td>
</tr>
<tr>
	<th scope="row">Creator</th>
	<td>
	<input id="listCrtUserId" name="crtUserId" type="text" title="Creator" placeholder="Creator (Username)" class="w100p" />
	</td>
	<th scope="row">Promotion Code</th>
	<td>
	<input id="listPromoCode" name="promoCode" type="text" title="Promotion Code" placeholder="Promotion Code" class="w100p" />
	</td>
	<th scope="row">Related No(Exchange)</th>
	<td>
	<input id="listRelatedNo" name="relatedNo" type="text" title="Related No(Exchange)" placeholder="Related No" class="w100p" />
	</td>
</tr>
</tbody>
</table><!-- table end -->

</form>

<aside class="link_btns_wrap"><!-- link_btns_wrap start -->
<p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
<dl class="link_list">
	<dt>Link</dt>
	<dd>
	<ul class="btns">
		<li><p class="link_btn"><a href="#" id="btnVaLetter">Customer VA Letter</a></p></li>
		<li><p class="link_btn"><a href="#" id="btnExport">Export Search List</a></p></li>
	</ul>
	<ul class="btns">
<!--
		<li><p class="link_btn type2"><a href="#" id="btnSim">Rental to Outright Simulator</a></p></li>
-->
		<li><p class="link_btn type2"><a href="#" id="btnRentalPaySet">Rental Pay Setting Update List</a></p></li>
		<li><p class="link_btn type2"><a href="#" id="btnSof">Sales Order Form (SOF) List</a></p></li>
		<li><p class="link_btn type2"><a href="#" id="btnDdCrc">DD/CRC List</a></p></li>
		<li><p class="link_btn type2"><a href="#" id="btnAsoSales">ASO Sales Report</a></p></li>
		<li><p class="link_btn type2"><a href="#" id="btnYsListing">Sales YS Listing</a></p></li>
	</ul>
	<p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
	</dd>
</dl>
</aside><!-- link_btns_wrap end -->

</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<!--
<ul class="right_btns">
	<li><p class="btn_grid"><a href="#">Rental to Outright Simulator</a></p></li>
	<li><p class="btn_grid"><a href="#">EXCEL UP</a></p></li>
	<li><p class="btn_grid"><a href="#">EXCEL DW</a></p></li>
	<li><p class="btn_grid"><a href="#">DEL</a></p></li>
	<li><p class="btn_grid"><a href="#">INS</a></p></li>
	<li><p class="btn_grid"><a href="#">ADD</a></p></li>
</ul>
-->
<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="list_grid_wrap" style="width:100%; height:480px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- content end -->
