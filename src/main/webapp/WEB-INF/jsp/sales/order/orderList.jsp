<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<script type="text/javaScript" language="javascript">

	//AUIGrid 생성 후 반환 ID
	var myGridID;

    var option = {
    	width : "1180px", // 창 가로 크기
        height : "800px" // 창 세로 크기
    };
    
    $(document).ready(function(){
        //AUIGrid 그리드를 생성합니다.
        createAUIGrid();

        // 셀 더블클릭 이벤트 바인딩
        AUIGrid.bind(myGridID, "cellDoubleClick", function(event) {
            fn_setDetail(myGridID, event.rowIndex);
        });
        
        doGetCombo('/common/selectCodeList.do',       '10', '',   'appType', 'M', 'fn_multiCombo'); //Common Code
        doGetCombo('/common/selectProductCodeList.do',  '', '', 'productId', 'S',              ''); //Product Code

        doGetComboSepa('/common/selectBranchCodeList.do',  '1', ' - ', '', 'keyinBrnchId', 'M', 'fn_multiCombo'); //Branch Code
        doGetComboSepa('/common/selectBranchCodeList.do',  '5', ' - ', '',   'dscBrnchId', 'M', 'fn_multiCombo'); //Branch Code
    });

    // 컬럼 선택시 상세정보 세팅.
    function fn_setDetail(gridID, rowIdx){
        Common.popupWin("searchForm", "/sales/order/orderDetail.do?salesOrderId="+AUIGrid.getCellValue(gridID, rowIdx, "ordId"), option);
    }
    
    function Test() {    	
    	alert('call Test');
    	//alert($("#appType option").length);
    	//$("#appType option:eq(0)").attr("selected","true");
    	AUIGrid.setSelectionMode(myGridID, "singleRow");
    }
    
    // 리스트 조회.
    function fn_selectListAjax() {        
        Common.ajax("GET", "/sales/order/selectOrderJsonList", $("#searchForm").serialize(), function(result) {
            AUIGrid.setGridData(myGridID, result);
        });
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
                dataField   : "ordId",          visible     : true //salesOrderId
            }];

        //그리드 속성 설정
        var gridPros = {
            usePaging           : true,         //페이징 사용
            pageRowCount        : 20,           //한 화면에 출력되는 행 개수 20(기본값:20)            
            editable            : false,            
            fixedColumnCount    : 1,            
            showStateColumn     : true,             
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
        
        myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout, "", gridPros);
    }
    
    function fn_multiCombo(){
        $('#cmbCategory').change(function() {
            //console.log($(this).val());
        }).multipleSelect({
            selectAll: true, // 전체선택 
            width: '100%'
        });            
        $('#appType').change(function() {
            //console.log($(this).val());
        }).multipleSelect({
            selectAll: true, // 전체선택 
            width: '100%'
        });            
        $('#keyinBrnchId').change(function() {
            //console.log($(this).val());
        }).multipleSelect({
            selectAll: true, // 전체선택 
            width: '100%'
        });
        $('#dscBrnchId').change(function() {
            //console.log($(this).val());
        }).multipleSelect({
            selectAll: true, // 전체선택 
            width: '100%'
        });
    }
</script>
</head>
<body>

<div id="wrap"><!-- wrap start -->

<header id="header"><!-- header start -->
<ul class="left_opt">
	<li>Neo(Mega Deal): <span>2394</span></li> 
	<li>Sales(Key In): <span>9304</span></li> 
	<li>Net Qty: <span>310</span></li>
	<li>Outright : <span>138</span></li>
	<li>Installment: <span>4254</span></li>
	<li>Rental: <span>4702</span></li>
	<li>Total: <span>45080</span></li>
</ul>
<ul class="right_opt">
	<li>Login as <span>KRHQ9001-HQ</span></li>
	<li><a href="#" class="logout">Logout</a></li>
	<li><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/top_btn_home.gif" alt="Home" /></a></li>
	<li><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/top_btn_set.gif" alt="Setting" /></a></li>
</ul>
</header><!-- header end -->
<hr />
		
<section id="container"><!-- container start -->

<aside class="lnb_wrap"><!-- lnb_wrap start -->

<header class="lnb_header"><!-- lnb_header start -->
<h1><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/logo.gif" alt="eTrust system" /></a></h1>
<p class="search">
<input type="text" title="검색어 입력" />
<input type="image" src="${pageContext.request.contextPath}/resources/images/common/icon_lnb_search.gif" alt="검색" />
</p>
</header><!-- lnb_header end -->

<section class="lnb_con"><!-- lnb_con start -->
<p class="click_add_on_solo on"><a href="#">All menu</a></p>
<ul class="inb_menu">
	<li class="active">
	<a href="#" class="on">menu 1depth</a>

	<ul>
		<li class="active">
		<a href="#" class="on">menu 2depth</a>

		<ul>
			<li class="active">
			<a href="#" class="on">menu 3depth</a>
			</li>
			<li>
			<a href="#">menu 3depth</a>
			</li>
			<li>
			<a href="#">menu 3depth</a>
			</li>
			<li>
			<a href="#">menu 3depth</a>
			</li>
			<li>
			<a href="#">menu 3depth</a>
			</li>
			<li>
			<a href="#">menu 3depth</a>
			</li>
		</ul>

		</li>
		<li>
		<a href="#">menu 2depth</a>
		</li>
		<li>
		<a href="#">menu 2depth</a>
		</li>
		<li>
		<a href="#">menu 2depth</a>
		</li>
		<li>
		<a href="#">menu 2depth</a>
		</li>
		<li>
		<a href="#">menu 2depth</a>
		</li>
	</ul>

	</li>
	<li>
	<a href="#">menu 1depth</a>
	</li>
	<li>
	<a href="#">menu 1depth</a>
	</li>
	<li>
	<a href="#">menu 1depth</a>
	</li>
	<li>
	<a href="#">menu 1depth</a>
	</li>
	<li>
	<a href="#">menu 1depth</a>
	</li>
</ul>
<p class="click_add_on_solo"><a href="#"><span></span>My menu</a></p>
<ul class="inb_menu">
	<li>
	<a href="#">My menu 1depth</a>
	</li>
	<li>
	<a href="#">My menu 1depth</a>
	</li>
	<li>
	<a href="#">My menu 1depth</a>
	</li>
	<li>
	<a href="#">My menu 1depth</a>
	</li>
	<li>
	<a href="#">My menu 1depth</a>
	</li>
	<li>
	<a href="#">My menu 1depth</a>
	</li>
</ul>
</section><!-- lnb_con end -->

</aside><!-- lnb_wrap end -->

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
    <li><p class="btn_blue"><a href="#" onClick="javascript:Test();">New</a></p></li>
    <li><p class="btn_blue"><a href="#" onClick="javascript:Test();">Edit</a></p></li>
	<li><p class="btn_blue"><a href="#" onClick="javascript:fn_selectListAjax();"><span class="search"></span>Search</a></p></li>
</ul>
</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->

<form id="searchForm" name="searchForm" action="#" method="post">

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
	<input id="ordNo" name="ordNo"  type="text" title="Order No" placeholder="Order Number" class="w100p" />
	</td>
	<th scope="row">Application Type</th>
	<td>
	<select id="appType" name="appType" class="multy_select w100p" multiple="multiple"></select>
	</td>
	<th scope="row">Order Date</th>
	<td>
	<div class="date_set w100p"><!-- date_set start -->
	<p><input id="ordStartDt" name="ordStartDt" type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
	<span>To</span>
	<p><input id="ordEndDt" name="ordEndDt" type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
	</div><!-- date_set end -->
	</td>
</tr>
<tr>
	<th scope="row">Order Status</th>
	<td>
	<select id="ordStusId" name="ordStusId" class="multy_select w100p" multiple="multiple">
		<option value="1">Active</option>
		<option value="4">Completed</option>
		<option value="10">Cancelled</option>
	</select>
	</td>
	<th scope="row">Key-In Branch</th>
	<td>
	<select id="keyinBrnchId" name="keyinBrnchId" class="multy_select w100p" multiple="multiple"></select>
	</td>
	<th scope="row">DSC Branch</th>
	<td>
    <select id="dscBrnchId" name="dscBrnchId" class="multy_select w100p" multiple="multiple"></select>
	</td>
</tr>
<tr>
	<th scope="row">Customer ID</th>
	<td>
	<input id="custId" name="custId" type="text" title="Customer ID" placeholder="Customer ID (Number Only)" class="w100p" />
	</td>
	<th scope="row">Customer Name</th>
	<td>
	<input id="custName" name="custName" type="text" title="Customer Name" placeholder="Customer Name" class="w100p" />
	</td>
	<th scope="row">NRIC/Company No</th>
	<td>
	<input id="custIc" name="custIc" type="text" title="NRIC/Company No" placeholder="NRIC/Company Number" class="w100p" />
	</td>
</tr>
<tr>
	<th scope="row">Product</th>
	<td>
	<select id="productId" name="productId" class="w100p"></select>
	</td>
	<th scope="row">Salesman</th>
	<td>
	<input id="salesmanCode" name="salesmanCode" type="text" title="Salesman" placeholder="Salesman (Member Code)" class="w100p" />
	</td>
	<th scope="row">Rental Status</th>
	<td>
	<select id="rentStus" name="rentStus" class="multy_select w100p" multiple="multiple">
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
	<input id="refNo" name="refNo" type="text" title="Reference No<" placeholder="Reference Number" class="w100p" />
	</td>
	<th scope="row">PO No</th>
	<td>
	<input id="poNo" name="poNo" type="text" title="PO No" placeholder="PO Number" class="w100p" />
	</td>
	<th scope="row">Contact No</th>
	<td>
	<input id="contactNo" name="contactNo" type="text" title="Contact No" placeholder="Contact No" class="w100p" />
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
	<input id="crtUserId" name="crtUserId" type="text" title="Creator" placeholder="Creator (Username)" class="w100p" />
	</td>
	<th scope="row">Promotion Code</th>
	<td>
	<input id="promoCode" name="promoCode" type="text" title="Promotion Code" placeholder="Promotion Code" class="w100p" />
	</td>
	<th scope="row">Related No(Exchange)</th>
	<td>
	<input id="relatedNo" name="relatedNo" type="text" title="Related No(Exchange)" placeholder="Related No" class="w100p" />
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
    <div id="grid_wrap" style="width:100%; height:480px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- content end -->

<aside class="bottom_msg_box"><!-- bottom_msg_box start -->
<p>Information Message Area</p>
</aside><!-- bottom_msg_box end -->
		
</section><!-- container end -->
<hr />

</div><!-- wrap end -->
</body>
</html>