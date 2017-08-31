<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript" language="javascript">

	//AUIGrid 생성 후 반환 ID
	var listGridID;

/*
    $(document).ready(function(){
        //AUIGrid 그리드를 생성합니다.
        createAUIGrid();

        // 셀 더블클릭 이벤트 바인딩
        AUIGrid.bind(listGridID, "cellDoubleClick", function(event) {
            fn_setDetail(listGridID, event.rowIndex);
        });
        
        doGetCombo('/common/selectCodeList.do',       '10', '',   'listAppType', 'M', 'fn_multiCombo'); //Common Code
        doGetProductCombo('/common/selectProductCodeList.do', '', '', 'listProductId', 'S'); //Product Code

        doGetComboSepa('/common/selectBranchCodeList.do',  '1', ' - ', '', 'listKeyinBrnchId', 'M', 'fn_multiCombo'); //Branch Code
        doGetComboSepa('/common/selectBranchCodeList.do',  '5', ' - ', '',   'listDscBrnchId', 'M', 'fn_multiCombo'); //Branch Code
    });

    // 컬럼 선택시 상세정보 세팅.
    function fn_setDetail(gridID, rowIdx){
        //Common.popupWin("listSearchForm", "/sales/order/orderDetail.do?salesOrderId="+AUIGrid.getCellValue(gridID, rowIdx, "ordId"), _option);
        $('#listSalesOrderId').val(AUIGrid.getCellValue(gridID, rowIdx, "ordId"));
        Common.popupDiv("/sales/order/orderDetailPop.do", $("#listSearchForm").serializeJSON());
    }
    
    // 리스트 조회.
    function fn_selectListAjax() {        
        Common.ajax("GET", "/sales/order/selectOrderJsonList", $("#listSearchForm").serialize(), function(result) {
            AUIGrid.setGridData(listGridID, result);
        });
    }
*/
    $(function(){
        $('#btnNew').click(function() {
            //Common.popupWin("listForm", "/sales/promotion/promotionRegisterPop.do", {width : "1200px",height : "800px"});
            Common.popupDiv("/sales/promotion/promotionRegisterPop.do");
        });
        $('#btnEdit').click(function() {
            alert('Edit');
        });
        $('#btnSrch').click(function() {
        	fn_selectListAjax();
        });
    });
/*
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
        
        listGridID = GridCommon.createAUIGrid("list_grid_wrap", columnLayout, "", gridPros);
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
*/
</script>
		
<!--****************************************************************************
    CONTENT START
*****************************************************************************-->
<section id="content">
<ul class="path">
	<li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
	<li>Sales</li>
	<li>Order list</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>Promotion Maintenance </h2>
<ul class="right_btns">
    <li><p class="btn_blue"><a id="btnNew" href="#" >New</a></p></li>
	<li><p class="btn_blue"><a href="#"><span class="search"></span>Search</a></p></li>
	<li><p class="btn_blue"><a href="#"><span class="clear"></span>Clear</a></p></li>
</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form id="listForm" name="listForm" action="#" method="post">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:180px" />
	<col style="width:*" />
	<col style="width:180px" />
	<col style="width:*" />
	<col style="width:180px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row">Promotion Code</th>
	<td>
	<input type="text" title="" placeholder="Promotion Code" class="w100p" />
	</td>
	<th scope="row">Promotion Name</th>
	<td>
	<input type="text" title="" placeholder="Promotion Name" class="w100p" />
	</td>
	<th scope="row">Promotion Type</th>
	<td>
	<select class="multy_select w100p" multiple="multiple">
		<option value="1">11</option>
		<option value="2">22</option>
		<option value="3">33</option>
	</select>
	</td>
</tr>
<tr>
	<th scope="row">Promotion Date</th>
	<td>
	<div class="date_set w100p"><!-- date_set start -->
	<p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
	<span>To</span>
	<p><input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
	</div><!-- date_set end -->
	</td>
	<th scope="row">Status</th>
	<td>
	<select class="multy_select w100p" multiple="multiple">
		<option value="1">11</option>
		<option value="2">22</option>
		<option value="3">33</option>
	</select>
	</td>
	<th scope="row">Application Type</th>
	<td>
	<select class="multy_select w100p" multiple="multiple">
		<option value="1">11</option>
		<option value="2">22</option>
		<option value="3">33</option>
	</select>
	</td>
</tr>
</tbody>
</table><!-- table end -->

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

</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<ul class="right_btns">
	<li><p class="btn_grid"><a href="#">CANCEL</a></p></li>
	<li><p class="btn_grid"><a href="#">ADD</a></p></li>
	<li><p class="btn_grid"><a href="#">SAVE</a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
그리드 영역
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- content end -->
