<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript" language="javascript">

	//AUIGrid 생성 후 반환 ID
	var popOrderGridID;

    $(document).ready(function(){
        //AUIGrid 그리드를 생성합니다.
        createAUIGrid();

        // 셀 더블클릭 이벤트 바인딩
        AUIGrid.bind(popOrderGridID, "cellDoubleClick", function(event) {
            fn_setData(AUIGrid.getCellValue(popOrderGridID , event.rowIndex , "ordNo"), AUIGrid.getCellValue(popOrderGridID , event.rowIndex , "ordId"))
            $('#custPopCloseBtn').click();
        });
        
        var selVal = '';
        
        if('SearchTrialNo' == '${indicator}') {
            selVal = '145';
        }

        doGetCombo('/common/selectCodeList.do', '10', selVal, 'popAppType', 'S'); //Common Code
        doGetComboSepa('/common/selectBranchCodeList.do',  '1', ' - ', '', 'popKeyinBrnchId', 'S'); //Branch Code
        
    });
    
	function fn_setData(ordNo , ordId) {
	    if($('#callPrgm').val() == 'ORD_REGISTER_SALE_ORD') {
	        fn_loadTrialNo(ordNo);
	    }
	    else if($('#callPrgm').val() == 'BILLING_ADD_NEW_GROUP' ||
	    		     $('#callPrgm').val() == 'FUND_TRANSFER') {
	        fn_orderInfo(ordNo, ordId);
	    }
	    else if($('#callPrgm').val() == 'RENTAL_PAYMENT') {
	    	fn_callBackRentalOrderInfo(ordNo, ordId);
	    }
	    else if($('#callPrgm').val() == 'OUTRIGHT_PAYMENT') {
	    	fn_callBackOutOrderInfo(ordNo, ordId);
        }
	    else if($('#callPrgm').val() == 'BILLING_DISCOUNT_MGMT') {
            fn_orderInfo(ordNo, ordId);
        }else if($('#callPrgm').val() == 'EARLY_TERMINATION_BILLING') {
        	fn_callbackOrder(ordId);
        }
	    else if($('#callPrgm').val() == 'BILLING_RENTAL_FEE') {
            fn_orderInfo(ordNo, ordId);
        }
	    else if($('#callPrgm').val() == 'BILLING_RENTAL_UNBILL') {
            fn_orderInfo(ordNo, ordId);
        } else if($('#callPrgm').val() == 'PRODUCT_LOST') {
        	fn_callbackOrder(ordId);
        }else if($('#callPrgm').val() == 'BILLING_STATEMENT_PO') {
            fn_callbackOrder(ordId);
        }
        
	}
	
    function createAUIGrid() {
        
    	//AUIGrid 칼럼 설정
        var columnLayout = [{
                dataField   : "ordNo",          headerText  : "<spring:message code='sales.OrderNo'/>",
                width       : 80,               editable    : false,
                style       : 'left_style'
            }, {
                dataField   : "refNo",          headerText  : "<spring:message code='sales.refNo2'/>",
                width       : 120,              editable    : false,
                style       : 'left_style'
            }, {
                dataField   : "ordDt",          headerText  : "<spring:message code='sales.ordDt'/>",
                width       : 100,              editable    : false,
                style       : 'left_style'
            }, {
                dataField   : "appTypeCode",    headerText  : "<spring:message code='sales.AppType'/>",
                width       : 80,               editable    : false,
                style       : 'left_style'
            }, {
                dataField   : "productName",    headerText  : "<spring:message code='sales.prod'/>",
                width       : 170,              editable    : false,
                style       : 'left_style'
            }, {
                dataField   : "custName",       headerText  : "<spring:message code='sales.cusName'/>",
                editable    : false,            style       : 'left_style'
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
          //selectionMode       : "singleRow",  //"multipleCells",            
            headerHeight        : 30,       
            useGroupingPanel    : false,        //그룹핑 패널 사용
            skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
            wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
            showRowNumColumn    : true,         //줄번호 칼럼 렌더러 출력    
            noDataMessage       : "No order found.",
            groupingMessage     : "Here groupping"
        };
        
        popOrderGridID = GridCommon.createAUIGrid("pop_ord_grid_wrap", columnLayout, "", gridPros);
    }

    $(function(){
        $('#btnOrdSearch').click(function() {
        	fn_selectListAjax();
        });
    });
	    // 리스트 조회.
    function fn_selectListAjax() {        
        Common.ajax("GET", "/sales/order/selectOrderJsonList", $("#popSearchForm").serialize(), function(result) {
            AUIGrid.setGridData(popOrderGridID, result);
        });
    }
  
</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code='sales.title.searchOrder'/></h1>
<ul class="right_opt">
	<li><p class="btn_blue2"><a id="custPopCloseBtn" href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<ul class="right_btns">
	<li><p class="btn_blue"><a id="btnOrdSearch"href="#"><span class="search"></span>Search</a></p></li>
	<li><p class="btn_blue"><a href="#"><span class="clear"></span>Clear</a></p></li>
</ul>
<form id="popSearchForm" name="popSearchForm" action="#" method="post">
    <input id="callPrgm" name="callPrgm" value="${callPrgm}" type="hidden" />
    <input id="indicator" name="indicator" value="${indicator}" type="hidden" />
<table class="type1 mt10"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:150px" />
	<col style="width:*" />
	<col style="width:170px" />
	<col style="width:*" />
	<col style="width:120px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row"><spring:message code='sales.OrderNo'/></th>
	<td>
	<input id="popOrdNo" name="ordNo" type="text" title="" placeholder="<spring:message code='sales.OrderNo'/>" class="w100p" />
	</td>
	<th scope="row"><spring:message code='sales.refNo3'/></th>
	<td>
	<input id="popRefNo" name="refNo" type="text" title="" placeholder="<spring:message code='sales.refNo3'/>" class="w100p" />
	</td>
	<th scope="row"><spring:message code='sales.ordDt'/></th>
	<td>
	<input id="popOrdDt" name="ordDt" type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p" />
	</td>
</tr>
<tr>
	<th scope="row"><spring:message code='sales.poNum'/> #</th>
	<td>
	<input id="popPoNo" name="poNo" type="text" title="" placeholder="<spring:message code='sales.poNum'/>" class="w100p" />
	</td>
	<th scope="row"><spring:message code='sales.invPo'/> #</th>
	<td colspan="3">
	<input id="popInvoicePoNo" name="invoicePoNo" type="text" title="" placeholder="<spring:message code='sales.invPo'/>" class="w100p" />
	</td>
</tr>
<tr>
	<th scope="row"><spring:message code='sales.custId2'/></th>
	<td>
	<input id="popCustId" name="custId" type="text" title="" placeholder="<spring:message code='sales.custId2'/>" class="w100p" />
	</td>
	<th scope="row"><spring:message code='sales.cusName'/></th>
	<td colspan="3">
	<input id="popCustName" name="custName" type="text" title="" placeholder="<spring:message code='sales.cusName'/>" class="w100p" />
	</td>
</tr>
<tr>
	<th scope="row"><spring:message code='sales.NRIC2'/></th>
	<td>
	<input id="popCustIc" name="custIc" type="text" title="" placeholder="<spring:message code='sales.NRIC2'/>" class="w100p" />
	</td>
	<th scope="row"><spring:message code='sales.AppType2'/></th>
	<td>
	<select id="popAppType" name="appType" class="multy_select w100p"></select>
	</td>
	<th scope="row"><spring:message code='sales.ordStus'/></th>
	<td>
	<select id="popOrdStusId" name="ordStusId" class="multy_select w100p">
		<option value="">Choose One</option>
		<option value="1">Active</option>
		<option value="4">Completed</option>
		<option value="10">Cancelled</option>
	</select>
	</td>
</tr>
<tr>
	<th scope="row"><spring:message code='sales.keyInBranch'/></th>
	<td colspan="5">
	<select id="popKeyinBrnchId" name="keyinBrnchId" class="multy_select w100p"></select>
	</td>
</tr>
</tbody>
</table><!-- table end -->
</form>
<article class="grid_wrap mt30"><!-- grid_wrap start -->
<div id="pop_ord_grid_wrap" style="width:100%; height:480px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->
