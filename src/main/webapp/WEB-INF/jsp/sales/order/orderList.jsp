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
        
        doGetCombo('/common/selectCodeList.do',       '10', '',   'listAppType', 'M', 'fn_multiCombo'); //Common Code
        doGetProductCombo('/common/selectProductCodeList.do', '', '', 'listProductId', 'S'); //Product Code

        doGetComboSepa('/common/selectBranchCodeList.do',  '1', ' - ', '', 'listKeyinBrnchId', 'M', 'fn_multiCombo'); //Branch Code
        doGetComboSepa('/common/selectBranchCodeList.do',  '5', ' - ', '',   'listDscBrnchId', 'M', 'fn_multiCombo'); //Branch Code
    });

    // 컬럼 선택시 상세정보 세팅.
    function fn_setDetail(gridID, rowIdx){
        Common.popupDiv("/sales/order/orderDetailPop.do", { salesOrderId : AUIGrid.getCellValue(gridID, rowIdx, "ordId") });
    }
    
    // 리스트 조회.
    function fn_selectListAjax() {        
        Common.ajax("GET", "/sales/order/selectOrderJsonList", $("#listSearchForm").serialize(), function(result) {
            AUIGrid.setGridData(listMyGridID, result);
        });
    }

    $(function(){
        $('#btnNew').click(function() {
            //Common.popupWin("listSearchForm", "/sales/order/orderRegisterPop.do", _option);
            //Common.popupDiv("/sales/order/orderRegisterPop.do", $("#listSearchForm").serializeJSON());
            Common.popupDiv("/sales/order/orderRegisterPop.do");
        });
        $('#btnEdit').click(function() {
            fn_orderModifyPop();
        });
        $('#btnSrch').click(function() {
        	fn_selectListAjax();
        });
    });
    
    function fn_orderModifyPop() {
        var selIdx = AUIGrid.getSelectedIndex(listMyGridID)[0];
        if(selIdx > -1) {
            Common.popupDiv("/sales/order/orderModifyPop.do", { salesOrderId : AUIGrid.getCellValue(listMyGridID, selIdx, "ordId"), custId : AUIGrid.getCellValue(listMyGridID, selIdx, "custId") }, null , true);
        }
        else {
            Common.alert("Sales Order Missing" + DEFAULT_DELIMITER + "<b>No sales order selected.</b>");
        }
    }
    
    function createAUIGrid() {
        
    	//AUIGrid 칼럼 설정
        var columnLayout = [{
                dataField   : "ordNo",          headerText  : "Order No",
                width       : 80,               editable    : false,
                style       : 'left_style'
            }, {
                dataField   : "ordStusCode",    headerText  : "Status",
                width       : 80,               editable    : false,
                style           : 'left_style'
            }, {
                dataField   : "appTypeCode",    headerText  : "App Type",
                width       : 80,               editable        : false,
                style       : 'left_style'
            }, {
                dataField   : "ordDt",          headerText  : "Order Date",
                width       : 100,              editable    : false,
                style       : 'left_style'
            }, {
                dataField   : "refNo",          headerText  : "Ref No",
                width       : 60,               editable    : false,
                style       : 'left_style'
            }, {
                dataField   : "productName",    headerText  : "Product",
                width       : 150,              editable    : false,
                style       : 'left_style'
            }, {
                dataField   : "custId",         headerText  : "Cust ID",
                width       : 70,               editable    : false,
                style       : 'left_style'
            }, {
                dataField   : "custName",       headerText  : "Customer Name",
                width       : 100,              editable    : false,
                style       : 'left_style'
            }, {
                dataField   : "custIc",         headerText  : "NRIC/Company No",
                width       : 100,              editable    : false,
                style       : 'left_style'
            }, {
                dataField   : "crtUserId",      headerText  : "Creator",
                width       : 100,              editable    : false,
                style       : 'left_style'
            }, {
                dataField   : "pvYear",         headerText  : "PV Year",
                width       : 60,               editable    : false,
                style       : 'left_style'
            }, {
                dataField   : "pvMonth",        headerText  : "PV Mth",
                width       : 60,               editable    : false,
                style       : 'left_style'
            }, {
                dataField   : "ordId",          visible     : false //salesOrderId
            }];

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
    
    function fn_multiCombo(){
//        $('#cmbCategory').change(function() {
//            //console.log($(this).val());
//        }).multipleSelect({
//            selectAll: true, // 전체선택 
//            width: '100%'
//        });            
        $('#listAppType').change(function() {
            //console.log($(this).val());
        }).multipleSelect({
            selectAll: true, // 전체선택 
            width: '100%'
        });            
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
    }
    
    function fn_createEvent(objId, eventType) {
        var e = jQuery.Event(eventType);
        $('#'+objId).trigger(e);
    }

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
    <li><p class="btn_blue"><a id="btnNew" href="#" >New</a></p></li>
    <li><p class="btn_blue"><a id="btnEdit" href="#">Edit</a></p></li>
	<li><p class="btn_blue"><a id="btnSrch" href="#" onClick="javascript:fn_selectListAjax();"><span class="search"></span>Search</a></p></li>
</ul>
</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->

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
	<p><input id="listOrdStartDt" name="ordStartDt" type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
	<span>To</span>
	<p><input id="listOrdEndDt" name="ordEndDt" type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
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
	<select id="listRentStus" name="rentStus" class="multy_select w100p" multiple="multiple">
		<option value="REG">Regular</option>
		<option value="INV">Investigate</option>
        <option value="SUS">Suspend</option>
        <option value="RET">Returned</option>
        <option value="CAN">Cancelled</option>
        <option value="TER">Terminated</option>
        <option value="WOF">Write Off</option>
	</select>
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
		<li><p class="link_btn"><a href="#">menu1</a></p></li>
		<li><p class="link_btn"><a href="#">menu2</a></p></li>
		<li><p class="link_btn"><a href="#">menu3</a></p></li>
		<li><p class="link_btn"><a href="#">menu4</a></p></li>
		<li><p class="link_btn"><a href="#">Search Payment</a></p></li>
		<li><p class="link_btn"><a href="#">menu6</a></p></li>
		<li><p class="link_btn"><a href="#">menu7</a></p></li>
		<li><p class="link_btn"><a href="#">menu8</a></p></li>
	</ul>
	<ul class="btns">
		<li><p class="link_btn type2"><a href="#">menu1</a></p></li>
		<li><p class="link_btn type2"><a href="#">Search Payment</a></p></li>
		<li><p class="link_btn type2"><a href="#">menu3</a></p></li>
		<li><p class="link_btn type2"><a href="#">menu4</a></p></li>
		<li><p class="link_btn type2"><a href="#">Search Payment</a></p></li>
		<li><p class="link_btn type2"><a href="#">menu6</a></p></li>
		<li><p class="link_btn type2"><a href="#">menu7</a></p></li>
		<li><p class="link_btn type2"><a href="#">menu8</a></p></li>
	</ul>
	<p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
	</dd>
</dl>
</aside><!-- link_btns_wrap end -->

</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<ul class="right_btns">
	<li><p class="btn_grid"><a href="#">Rental to Outright Simulator</a></p></li>
	<li><p class="btn_grid"><a href="#">EXCEL UP</a></p></li>
	<li><p class="btn_grid"><a href="#">EXCEL DW</a></p></li>
	<li><p class="btn_grid"><a href="#">DEL</a></p></li>
	<li><p class="btn_grid"><a href="#">INS</a></p></li>
	<li><p class="btn_grid"><a href="#">ADD</a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="list_grid_wrap" style="width:100%; height:480px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- content end -->

