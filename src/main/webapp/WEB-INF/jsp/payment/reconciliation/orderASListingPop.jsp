<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
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
        { dataField:"asTypeCode" ,headerText:"<spring:message code='pay.head.type'/>",editable : false},
        { dataField:"asNo" ,headerText:"<spring:message code='pay.head.asNo'/>",editable : false},
        {dataField:"asReqstDt", headerText:"<spring:message code='pay.head.requesDate'/>", width : 80,editable : false, dataType : "date", formatString : "dd-mm-yyyy"},
        { dataField:"asStusCode" ,headerText:"<spring:message code='pay.head.satatus'/>",editable : false },
        { dataField:"asResultNo" ,headerText:"<spring:message code='pay.head.resultNo'/>",editable : false},
        { dataField:"userName" ,headerText:"<spring:message code='pay.head.keyBy'/>" ,editable : false },
        { dataField:"salesOrdNo" ,headerText:"<spring:message code='pay.head.orderNo'/>" ,editable : false },
        { dataField:"appTypeCode" ,headerText:"<spring:message code='pay.head.appType'/>" ,editable : false },
        { dataField:"custName" ,headerText:"<spring:message code='pay.head.custName'/>" ,editable : false },
        { dataField:"custNric" ,headerText:"<spring:message code='pay.head.nricCompNo'/>" ,editable : false }
        ];

    function fn_getOrderASListAjax(){
        Common.ajax("GET", "/payment/selectOrderASList.do", $("#searchForm").serialize(), function(result) {
            AUIGrid.setGridData(myGridID, result);
        });
    }
</script>
<div id="popup_wrap" class="popup_wrap pop_win"><!-- popup_wrap start -->
    <header class="pop_header"><!-- pop_header start -->
        <h1>Order AS Listing</h1>
        <ul class="right_opt">
            <li><p class="btn_blue2"><a href="#" onclick="window.close()"><spring:message code='sys.btn.close'/></a></p></li>
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
        