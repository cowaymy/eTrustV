<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<script type="text/javaScript">
	
	var gridPros = {            
	        editable : false,                 // 편집 가능 여부 (기본값 : false)
	        showStateColumn : false     // 상태 칼럼 사용
	};
	
	var myGridID;
   
    $(document).ready(function(){
        
        myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout, null, gridPros);
        
        fn_getOrderASListAjax();
    });
    
    // AUIGrid 칼럼 설정
    var columnLayout = [
        { dataField:"payDt" ,headerText:"Type",editable : false},
        { dataField:"payTypeId" ,headerText:"ASNo",editable : false},
        {dataField:"rnum", headerText:"Reques Date", width : 80,editable : false, dataType : "date", formatString : "dd-mm-yyyy"},
        { dataField:"trxId" ,headerText:"Status",editable : false },
        { dataField:"trxDt" ,headerText:"Result No",editable : false},
        { dataField:"AdvMonth" ,headerText:"Key By" ,editable : false },
        { dataField:"trNo" ,headerText:"Order No" ,editable : false },
        { dataField:"salesOrdNo" ,headerText:"App Type" ,editable : false },
        { dataField:"appTypeName" ,headerText:"Cust Name" ,editable : false },
        { dataField:"productDesc" ,headerText:"NRIC/Comp No" ,editable : false }
        ];

    function fn_getOrderASListAjax(){
        Common.ajax("GET", "/payment/selectOrderASList.do", $("#search").serialize(), function(result) {
            AUIGrid.setGridData(myGridID, result);
        });
    }
</script>
<div id="popup_wrap" class="popup_wrap pop_win"><!-- popup_wrap start -->
    <header class="pop_header"><!-- pop_header start -->
        <h1>Order AS Listing</h1>
        <ul class="right_opt">
            <li><p class="btn_blue2"><a href="#" onclick="window.close()">CLOSE</a></p></li>
        </ul>
    </header><!-- pop_header end -->
    <section class="pop_body"><!-- pop_body start -->
       <input id="callPrgm" name="callPrgm" value="${callPrgm}" type="hidden" />
        <!-- search_result start -->
	    <section class="search_result">
	        <!-- grid_wrap start -->
	        <article id="grid_wrap" class="grid_wrap"></article>
	    </section>
        <!-- search_result end -->
    </section><!-- content end -->
    <form name="searchForm" id="searchForm"  method="post">
        <input type="hidden" id="orderId" name="orderId" value="${orderId}">
    </form>
</div>
        