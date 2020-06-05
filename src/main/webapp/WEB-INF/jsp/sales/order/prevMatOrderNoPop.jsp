<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<head>
<script type="text/javaScript" language="javascript">
    var prevOrdNoGridID;

    $(document).ready(function(){
        createAUIGrid();

        fn_getMatPrevOrderNo();

        AUIGrid.bind(prevOrdNoGridID, "cellDoubleClick", function(event) {
        	var stus = AUIGrid.getCellValue(prevOrdNoGridID , event.rowIndex , "stusCodeId");
        	if(stus == 4){
	            $('#matRelatedNo').val(AUIGrid.getCellValue(prevOrdNoGridID , event.rowIndex , "salesOrdNo"));
	            $('#matOrdId').val(AUIGrid.getCellValue(prevOrdNoGridID , event.rowIndex , "salesOrdId"));
	            $('#matBndlId').val(AUIGrid.getCellValue(prevOrdNoGridID , event.rowIndex , "bndlId"));
	            $('#matStkId').val(AUIGrid.getCellValue(prevOrdNoGridID , event.rowIndex , "stkId"));
	            $('#btnPrevMatOrderNo').click();
        	}else{
        		Common.alert('Previous Mattress Order' + DEFAULT_DELIMITER +"Only Order with Completed Status is allowed to select");
        	}
        });

    });

    function createAUIGrid() {

        var columnLayout = [
            { headerText : "Order No",     dataField : "salesOrdNo", width : 120 }
          , { headerText : "App Type",     dataField : "appType",    width : 120 }
          , { headerText : "Product Code", dataField : "stkCode",    width : 120 }
          , { headerText : "Status", dataField : "stus",    width : 120 }
          , { headerText : "Product Name", dataField : "stkDesc"}
          , { headerText : "Order Id",     dataField : "salesOrdId" , visible  : false}
          , { headerText : "Bundle Id",     dataField : "bndlId" , visible  : false}
          , { headerText : "Stock Id",     dataField : "stkId" , visible  : false}
          , { headerText : "Status", dataField : "stusCodeId", visible  : false }
            ];

        var gridPros = {
            usePaging           : true,
            pageRowCount        : 5,
            editable            : false,
            fixedColumnCount    : 0,
            showStateColumn     : false,
            displayTreeOpen     : false,
          //selectionMode       : "singleRow",  //"multipleCells",
            headerHeight        : 30,
            useGroupingPanel    : false,
            skipReadonlyColumns : true,
            wrapSelectionMove   : true,
            showRowNumColumn    : true,
            noDataMessage       : "No order found.",
            groupingMessage     : "Here groupping"
        };

        prevOrdNoGridID = GridCommon.createAUIGrid("grid_prev_ord_wrap", columnLayout, "", gridPros);
    }

    function fn_getMatPrevOrderNo(){
        Common.ajax("GET", "/sales/order/selectPrevMatOrderNoList.do", {custId : '${custId}', isHomecare : '${isHomecare}', appTypeId : '${appTypeId}'}, function(result) {
            AUIGrid.setGridData(prevOrdNoGridID, result);
        });
    }

    function fn_selfClose() {
        $('#btnPrevMatOrderNo').click();
      }

</script>
</head>
<body>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Previous Mattress Order No.</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a id=btnPrevMatOrderNo href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->
<section class="pop_body"><!-- pop_body start -->
<section class="search_result"><!-- search_result start -->

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="grid_prev_ord_wrap" style="width:100%; height:220px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

<ul class="left_btns mb10">
    <li><p><span id="lblOldOrderNo" class="red_text"></span></p></li>
</ul>
</section><!-- search_result end -->
</section><!-- search_table end -->
</section><!-- pop_body end -->

</div><!-- popup_wrap end -->
