<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<style type="text/css">

/* gride 동적 버튼 */
.edit-column {
    visibility:hidden;
}
</style>

<script type="text/javascript">
    //AUIGrid 생성 후 반환 ID
    var viewHistGridIDe;

    $(document).ready(function() {

        // AUIGrid 그리드를 생성합니다.
        createAUIGrid();
        fn_selectListAjax();
    });

    function createAUIGrid() {
        // AUIGrid 칼럼 설정

        // 데이터 형태는 다음과 같은 형태임,
        //[{"id":"#Cust0","date":"2014-09-03","name":"Han","country":"USA","product":"Apple","color":"Red","price":746400}, { .....} ];
        var columnLayoute = [ {
                dataField : "custTokenId",
                headerText : "<spring:message code="sal.title.tokenId" />",
                width : 270,
                editable : false
            }, {
                dataField : "orderNo",
                headerText : "<spring:message code="sys.menumanagement.grid1.Order" />",
                width : 100,
                editable : false
            }, {
                dataField : "customerName",
                headerText : "<spring:message code="sales.cusName" />",
                width : 180,
                editable : false
            }, {
                dataField : "area",
                headerText : "<spring:message code="sales.Area" />",
                width : 180,
                editable : false
            },{
                dataField : "rentalFee",
                headerText : "<spring:message code="sal.title.text.rentalFees" />",
                width : 100,
                editable : false
            },{
                dataField : "thirdParty",
                headerText : "<spring:message code="sal.title.text.thirdParty" />",
                width : 100,
                editable : false
            }];

     // 그리드 속성 설정
        var gridProse = {

            // 페이징 사용
            usePaging : true,
            // 한 화면에 출력되는 행 개수 20(기본값:20)
            pageRowCount : 20,
            editable : true,
            fixedColumnCount : 1,
            showStateColumn : false,
            displayTreeOpen : true,
            selectionMode : "multipleCells",
            headerHeight : 30,
            // 그룹핑 패널 사용
            useGroupingPanel : false,
            // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
            skipReadonlyColumns : true,
            // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
            wrapSelectionMove : true,
            // 줄번호 칼럼 렌더러 출력
            showRowNumColumn : false
        };

        viewHistGridIDe = AUIGrid.create("#grid_wrape", columnLayoute, gridProse);
    }

    function fn_selectListAjax() {

        //if(IS_3RD_PARTY == '1') $("#listAppType").removeAttr("disabled");
console.log("halaosdasd");
        Common.ajax("GET", "/sales/membershipRental/traceBankCardOrderList", {tokenId:tokenId}, function(result) {
        	console.log(result);
            AUIGrid.setGridData(viewHistGridIDe, result);
        });
    }
</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->
<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="Token ID details" /></h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#" id="histClose"><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->
<section class="pop_body"><!-- pop_body start -->
<form id="historyForm" name="historyForm" method="POST">
</form>
<article class="grid_wrape"><!-- grid_wrap start -->
    <div id="grid_wrape" style="width:100%; height:480px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- content end -->

<hr />

</div><!-- popup_wrap end -->