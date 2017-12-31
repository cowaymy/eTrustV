<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<head>
<script type="text/javaScript" language="javascript">

	//AUIGrid 생성 후 반환 ID
	var billGrpGridID;

	$(document).ready(function(){
	    //AUIGrid 그리드를 생성합니다.
        createAUIGrid();
        fn_getCustomerBillGrpAjax();

        // 셀 더블클릭 이벤트 바인딩
        AUIGrid.bind(billGrpGridID, "cellDoubleClick", function(event) {
            fn_setData(AUIGrid.getCellValue(billGrpGridID , event.rowIndex , "custBillId")
                     , AUIGrid.getCellValue(billGrpGridID , event.rowIndex , "custBillGrpNo")
                     , AUIGrid.getCellValue(billGrpGridID , event.rowIndex , "billType")
                     , AUIGrid.getCellValue(billGrpGridID , event.rowIndex , "billAddrFull")
                     , AUIGrid.getCellValue(billGrpGridID , event.rowIndex , "custBillRem")
                     , AUIGrid.getCellValue(billGrpGridID , event.rowIndex , "custBillAddId"))
            $('#custPopCloseBtn').click();
        });
	    
	});
    
	function fn_setData(custBillId, custBillGrpNo, billType, billAddrFull, custBillRem, custBillAddId) {
	    if($('#callPrgm').val() == 'ORD_REGISTER_BILL_GRP' 
	    || $('#callPrgm').val() == 'ORD_REQUEST_BILLGRP'
	    || $('#callPrgm').val() == 'PRE_ORD_BILL_GRP') {
	        fn_loadBillingGroup(custBillId, custBillGrpNo, billType, billAddrFull, custBillRem, custBillAddId);
	    }
	}
	
    function createAUIGrid() {
        
        //AUIGrid 칼럼 설정
        var columnLayout = [{
	            dataField  : "custBillGrpNo",
	            headerText : "Group No",
	            width      : 100
	        }, {
	            dataField  : "billAddrFull",
	            headerText : "Billing Address",
	        }, {
	            dataField  : "billType",
	            headerText : "Billing Type",
	            width      : 100
	        },{
	            dataField : "custBillRem",
	            visible : false
	        },{
	            dataField : "custBillAddId",
	            visible : false
	        },{
	            dataField : "custBillId",
	            visible : false
            }];

        //그리드 속성 설정
        var gridPros = {
            usePaging           : true,         //페이징 사용
            pageRowCount        : 10,           //한 화면에 출력되는 행 개수 20(기본값:20)            
            editable            : false,            
            fixedColumnCount    : 0,            
            showStateColumn     : false,             
            displayTreeOpen     : false,            
   //         selectionMode       : "singleRow",  //"multipleCells",            
            headerHeight        : 30,       
            useGroupingPanel    : false,        //그룹핑 패널 사용
            skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
            wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
            showRowNumColumn    : true,         //줄번호 칼럼 렌더러 출력    
            noDataMessage       : "No order found.",
            groupingMessage     : "Here groupping"
        };
        
        billGrpGridID = GridCommon.createAUIGrid("grid_bill_wrap", columnLayout, "", gridPros);
    }

	$(function(){
	    $('#cntcSearchBtn').click(function() {
	        fn_getCustomerBillGrpAjax();
	    });
        $('#searchWord').keydown(function (event) {  
            if (event.which === 13) {    //enter  
                fn_getCustomerBillGrpAjax();
                return false;
            }  
        });
	});
	
    //Get Contact by Ajax
    function fn_getCustomerBillGrpAjax(){
        Common.ajax("GET", "/sales/customer/selectBillingGroupByKeywordCustIDList.do", $("#billGroupSearchForm").serializeJSON(), function(result) {
            AUIGrid.setGridData(billGrpGridID, result);
        });
    }
  
</script>
</head>
<body>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Customer Billing Group</h1>
<ul class="right_opt">
	<li><p class="btn_blue2"><a id="custPopCloseBtn" href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<section class="search_table"><!-- search_table start -->
<form id="billGroupSearchForm" name="cnctSearchForm" action="#" method="post">
<input id="callPrgm" name="callPrgm" value="${callPrgm}" type="hidden" />
<input id="custId" name="custId" value="${custId}" type="hidden" />

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:160px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row">Contact Keyword</th>
	<td ><input id="searchWord" name="searchWord" type="text" title="" placeholder="Keyword" class="w100p" /></td>
</tr>
</tbody>
</table><!-- table end -->
</form>
<section class="search_result"><!-- search_result start -->

<ul class="right_btns">
	<li><p class="btn_grid"><a id="cntcSearchBtn" href="#"">SEARCH</a></p></li>
	<li><p class="btn_grid"><a href="#">CLEAR</a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="grid_bill_wrap" style="width:100%; height:380px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- search_table end -->

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->
</body>
</html>