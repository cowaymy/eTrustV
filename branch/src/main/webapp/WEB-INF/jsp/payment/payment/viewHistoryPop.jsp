<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<script type="text/javaScript">

//AUIGrid 그리드 객체
var viewHistoryGridID_V;
var payId = '${payId}';
//Grid Properties 설정 
var gridPros = {            
        editable : false,                 // 편집 가능 여부 (기본값 : false)
        showStateColumn : false     // 상태 칼럼 사용
};

// 화면 초기화 함수 (jQuery 의 $(document).ready(function() {}); 과 같은 역할을 합니다.
$(document).ready(function(){
	showViewHistory(payId);
});



var viewHistoryLayout=[
    { dataField:"typename" ,headerText:"<spring:message code='pay.head.type'/>" ,editable : false },
    { dataField:"valuefr" ,headerText:"<spring:message code='pay.head.from'/>" ,editable : false },
    { dataField:"valueto" ,headerText:"<spring:message code='pay.head.to'/>" ,editable : false },
    { dataField:"createdate" ,headerText:"<spring:message code='pay.head.updateDate'/>" ,editable : false, formatString : "dd-mm-yyyy" },
    { dataField:"creator" ,headerText:"<spring:message code='pay.head.updator'/>" ,editable : false }
    ];

function showViewHistory(payId){
	
	Common.ajax("GET", "/payment/selectViewHistoryList", {"payId" : payId}, function(result) {
        viewHistoryGridID_V = GridCommon.createAUIGrid("grid_view_history_v", viewHistoryLayout,null,gridPros);
        AUIGrid.setGridData(viewHistoryGridID_V, result);
     });
}

</script>

<div id="view_history_wrap_v" class="popup_wrap size_small" style="display:;">
    <header class="pop_header">
        <h1><spring:message code='pay.title.payMasHis'/></h1>
        <ul class="right_opt">
            <li><p class="btn_blue2"><a href="#" onclick=""><spring:message code='sys.btn.close'/></a></p></li>
        </ul>
    </header>
    <!-- pop_body start -->
    <section class="pop_body">
       
        <!-- grid_wrap start -->
        <article id="grid_view_history_v" class="grid_wrap"></article>
        <!-- grid_wrap end -->
    </section>
    <!-- pop_body end -->
</div>
