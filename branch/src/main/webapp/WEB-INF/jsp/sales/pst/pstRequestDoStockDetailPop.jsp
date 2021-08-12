<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="utf-8"/>
<meta content="width=1280px,user-scalable=yes,target-densitydpi=device-dpi" name="viewport"/>
<title>eTrust system</title>
<link rel="stylesheet" type="text/css" href="css/master.css" />
<link rel="stylesheet" type="text/css" href="css/common.css" />
<script type="text/javascript" src="js/jquery.min.js"></script>
<script type="text/javascript" src="js/jquery-ui.min.js"></script>
<script type="text/javascript" src="js/jquery.ui.core.min.js"></script>
<script type="text/javascript" src="js/jquery.ui.datepicker.min.js"></script>
<script type="text/javascript" src="js/common.js"></script>
<script type="text/javaScript" language="javascript">

    //AUIGrid 생성 후 반환 ID
    var myGridID;
    
//    var result = ${pstStockList};

    $(document).ready(function(){

//    	AUIGrid.setSelectionMode(myGridID, "singleRow");
    	
        // AUIGrid 그리드를 생성합니다.
        myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout);

       fn_getPstStockListAjax();

//       AUIGrid.setGridData(myGridID, result);


    });
    
 // AUIGrid 칼럼 설정
    // 데이터 형태는 다음과 같은 형태임,
    //[{"id":"#Cust0","date":"2014-09-03","name":"Han","country":"USA","product":"Apple","color":"Red","price":746400}, { .....} ];
    var columnLayout = [ {
//            dataField : "",
//            headerText : "No",
//            width : 40
//        }, {
            dataField : "c2",
            headerText : '<spring:message code="sal.title.text.stockDescription" />',
        }, {
            dataField : "pstItmReqQty",
            headerText : '<spring:message code="sal.title.text.requestBrQty" />',
            width : 105
        }, {
            dataField : "pstItmDoQty",
            headerText : '<spring:message code="sal.title.text.doQuantity" />',
            width : 130
        }, {
            dataField : "pstItmCanQty",
            headerText : '<spring:message code="sal.title.text.cancelQty" />',
            width : 160
        }, {
            dataField : "pstItmBalQty",
            headerText : '<spring:message code="sal.title.text.balanceQty" />',
            width : 170
        }, {
            dataField : "pstItmPrc",
            headerText : '<spring:message code="sal.title.itemPrice" />',
            width : 115
        }];
    
    // 리스트 조회.
    function fn_getPstStockListAjax() {        
        Common.ajax("GET", "/sales/pst/getPstStockJsonDetailPop", $("#searchForm").serialize(), function(result) {
            AUIGrid.setGridData(myGridID, result);
        }
        );
    }
 
    function fn_goPstInfo(){
    	location.href = "/sales/pst/getPstRequestDODetailPop.do?isPop=true&pstSalesOrdId="+${pstSalesOrdId};
    }
    
    function fn_goPstStockEdit(){
        location.href = "/sales/pst/getPstRequestDOEditPop.do?isPop=true&pstSalesOrdId="+${pstSalesOrdId};
    }
    
    function fn_close(){
        window.close();
    }
</script>

</head>
<body>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

	<header class="pop_header"><!-- pop_header start -->
	<h1><spring:message code="sal.title.text.pstReqInfo" /></h1>
	<ul class="right_opt">
<!-- 	    <li><p class="btn_blue2"><a href="#">COPY</a></p></li> -->
	    <li><p class="btn_blue2"><a href="#" onclick="javascript:fn_goPstStockEdit()"><spring:message code="sal.title.text.edit" /></a></p></li>
	    <li><p class="btn_blue2"><a href="#"><spring:message code="sal.title.text.new" /></a></p></li>
 	    <li><p class="btn_blue2"><a href="#" onclick="javascript:fn_close()"><spring:message code="sal.btn.close" /></a></p></li>
	</ul>
	</header><!-- pop_header end -->
	
	<section class="pop_body"><!-- pop_body start -->
		<ul class="tap_type1">
		    <li><a href="#" onclick="javascript:fn_goPstInfo()"><spring:message code="sal.title.text.pstInfo" /></a></li>
		    <li><a href="#"><spring:message code="sal.title.text.pstMailAddress" /></a></li>
		    <li><a href="#"><spring:message code="sal.title.text.pstDeliveryAddress" /></a></li>
		    <li><a href="#"><spring:message code="sal.title.text.pstMailContact" /></a></li>
		    <li><a href="#"><spring:message code="sal.title.text.pstDeliveryContact" /></a></li>
		    <li><a href="#" class="on"><spring:message code="sal.title.text.pstStockList" /></a></li>
		</ul>
		<h2><spring:message code="sal.title.text.requestItemList" /></h2>
		<form name="searchForm" id="searchForm">
            <input type="hidden" id="pstSalesOrdId" name="pstSalesOrdId" value="${pstSalesOrdId}">
		</form>
		
		<!-- search_result start -->
	    <div class="search_result">
	        <!-- grid_wrap start -->
	        <div id="grid_wrap" style="width:100%; height:380px; margin:0 auto;"></div>
	        <!-- grid_wrap end -->
	    </div>
	    <!-- search_result end -->
	
	</section><!-- pop_body end -->

</div><!-- popup_wrap end -->
</body>
</html>