<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<head>
<script type="text/javaScript" language="javascript">

	//AUIGrid 생성 후 반환 ID
	var prevOrdNoGridID;

	$(document).ready(function(){
	    //AUIGrid 그리드를 생성합니다.
        createAUIGrid();
        
        fn_getPrevOrderNo();

        // 셀 더블클릭 이벤트 바인딩
        AUIGrid.bind(prevOrdNoGridID, "cellDoubleClick", function(event) {
            fn_setData(AUIGrid.getCellValue(prevOrdNoGridID , event.rowIndex , "salesOrdNo"))
            $('#btnPrevOrderNo').click();
        });
	    
	});
    
	function fn_setData(salesOrdNo) {
	    $('#relatedNo').val(salesOrdNo);
	}
	
    function createAUIGrid() {
        
        //AUIGrid 칼럼 설정
        var columnLayout = [
            { headerText : "Order No",     dataField : "salesOrdNo", width : 120 }
          , { headerText : "App Type",     dataField : "appType",    width : 120 }
          , { headerText : "Product Code", dataField : "stkCode",    width : 120 }
          , { headerText : "Product Name", dataField : "stkDesc"}
            ];

        //그리드 속성 설정
        var gridPros = {
            usePaging           : true,         //페이징 사용
            pageRowCount        : 5,            //한 화면에 출력되는 행 개수 20(기본값:20)            
            editable            : false,            
            fixedColumnCount    : 0,            
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
        
        prevOrdNoGridID = GridCommon.createAUIGrid("grid_prev_ord_wrap", columnLayout, "", gridPros);
    }

	$(function(){

	});
	
    //Get Contact by Ajax
    function fn_getPrevOrderNo(){
        Common.ajax("GET", "/sales/order/selectPrevOrderNoList.do", {custId : '${custId}'}, function(result) {
            AUIGrid.setGridData(prevOrdNoGridID, result);
        });
    }
  
</script>
</head>
<body>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Previous Order No.</h1>
<ul class="right_opt">
	<li><p class="btn_blue2"><a id="btnPrevOrderNo" href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<section class="search_result"><!-- search_result start -->

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="grid_prev_ord_wrap" style="width:100%; height:220px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- search_table end -->

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->
