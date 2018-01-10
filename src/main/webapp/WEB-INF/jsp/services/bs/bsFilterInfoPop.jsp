<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javaScript">

var myGridID;
//Start AUIGrid
$(document).ready(function() {
    // AUIGrid 그리드를 생성합니다.
    createAUIGrid();
	fn_setFilterInfo()
});

function fn_setFilterInfo() {
    Common.ajax("GET", "/services/bs/filterInfoPop.do", $("#frm").serialize(), function(result) {
    	
        AUIGrid.setGridData(myGridID, result);
    });
}

function createAUIGrid() {
    //AUIGrid 칼럼 설정
    var columnLayout = [ {
        dataField : "no",
        headerText : '<spring:message code="service.grid.No" />',
        editable : false,
        width : 0
    }, {
        dataField : "stkDesc",
        headerText : '<spring:message code="service.grid.FilterDesc" />',
        editable : false,
        width : 300
    }, {
        dataField : "srvFilterPrvChgDt",
        headerText : '<spring:message code="service.grid.LastChgDate" />',
        editable : false,
        width : 200
    }, {
        dataField : "srvFilterPrvNextDt",
        headerText : '<spring:message code="service.grid.NextChgDate" />',
        editable : false,
        width : 200
    }];
     // 그리드 속성 설정
    var gridPros = {

        // 페이징 사용
        usePaging : true,

        // 한 화면에 출력되는 행 개수 20(기본값:20)
        pageRowCount : 20,

        editable : true,

        showStateColumn : true,

        displayTreeOpen : true,


        headerHeight : 30,

        // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
        skipReadonlyColumns : true,

        // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
        wrapSelectionMove : true,

        // 줄번호 칼럼 렌더러 출력
        showRowNumColumn : true

    };

    //myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout, gridPros);
    myGridID = AUIGrid.create("#grid_wrap", columnLayout, gridPros);
}



function fn_winClose(){

    this.close();
}
</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>BS FILTER - HISTORY</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<aside class="title_line"><!-- title_line start -->
<h4></h4>
</aside><!-- title_line end -->

<article class="tap_area"><!-- tap_area start -->

<aside class="title_line"><!-- title_line start -->
<h2>Filter Replacement Particulars</h2>
</aside><!-- title_line end -->
<div id="grid_wrap" style="width: 100%; height:430px; margin: 0 auto;"></div>
</article><!-- tap_area end -->
<form name="frm" id="frm">
<input type="hidden" name="orderId"  id="orderId" value="${orderId}"/>
</form>
</div>
</section><!-- pop_body end -->

</div><!-- popup_wrap end -->
