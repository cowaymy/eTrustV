<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<style type="text/css">

    /* 커스텀 칼럼 스타일 정의 */
    .aui-grid-user-custom-left {
        text-align: left;
    }
</style>
<script type="text/javascript">
    //AUIGrid 생성 후 반환 ID
    var mAddrGridID;

    $(document).ready(function(){

        // AUIGrid 그리드를 생성합니다.
        createAUIGrid();

        // AUIGrid.setSelectionMode(myGridID, "singleRow");

        // 셀 더블클릭 이벤트 바인딩
        AUIGrid.bind(mAddrGridID, "cellDoubleClick", function(event){
            /* var mstate = event.item.state;
            var mcity = event.item.city;
            var mtown = event.item.town;
            var mpostCd = event.item.postcd;
            var mstreet = event.item.street;
            var miso = event.item.iso;
            var mstreetId = event.item.streetId; */

            var marea = event.item.area;
            var mcity = event.item.city;
            var mpostcode = event.item.postcode;
            var mstate = event.item.state;
            var areaid = event.item.areaId;
            var miso = event.item.iso;

            fn_addMaddr(marea, mcity, mpostcode, mstate, areaid, miso);

        });
        // 셀 클릭 이벤트 바인딩

        // 20190925 KR-OHK Moblie Popup Setting
        Common.setMobilePopup(false, true, 'maddr_grid_wrap');

        fn_searchMagicAddressPopJsonListAjax();
    });

    function createAUIGrid() {
        var columnLayout = [ {
            dataField : "area",
            headerText : '<spring:message code="sal.text.area" />',
            width : "50%",
            editable : false,
            style: "aui-grid-user-custom-left"
        }, {
            dataField : "postcode",
            headerText : '<spring:message code="sal.text.postCode" />',
            width : "10%",
            editable : false
        }, {
            dataField : "city",
            headerText : '<spring:message code="sal.text.city" />',
            width : "20%",
            editable : false,
            style: "aui-grid-user-custom-left"
        }, {
            dataField : "state",
            headerText : '<spring:message code="sal.text.state" />',
            width : "20%",
            editable : false,
            style: "aui-grid-user-custom-left"
        },{
            dataField : "areaId",
            visible : false
        }, {
            dataField : "iso",
            visible : false
        }];

        // 그리드 속성 설정
        var gridPros = {
            // 페이징 사용
            usePaging : false,
            // 한 화면에 출력되는 행 개수 20(기본값:20)
            pageRowCount : 20,
            editable : true,
            fixedColumnCount : 1,
            showStateColumn : true,
            displayTreeOpen : true,
      //      selectionMode : "multipleCells",
            headerHeight : 30,
            // 그룹핑 패널 사용
            useGroupingPanel : true,
            // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
            skipReadonlyColumns : true,
            // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
            wrapSelectionMove : true,
            // 줄번호 칼럼 렌더러 출력
            showRowNumColumn : false,
            groupingMessage : "Here groupping"
        };

        var gridPros_mobile = {
                usePaging : false,
                pageRowCount : 20,
                editable : true,
                showStateColumn : true,
                displayTreeOpen : true,
                headerHeight : 30,
                useGroupingPanel : true,
                skipReadonlyColumns : true,
                wrapSelectionMove : true,
                showRowNumColumn : false,
                groupingMessage : "Here groupping"
            };

    //myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout, gridPros);
        if(Common.checkPlatformType() == "mobile") {
            mAddrGridID = GridCommon.createAUIGrid("#maddr_grid_wrap", columnLayout,'', gridPros_mobile);
        } else {
            mAddrGridID = GridCommon.createAUIGrid("#maddr_grid_wrap", columnLayout,'', gridPros);
        }
    }

    function fn_searchMagicAddressPopJsonListAjax(){
        Common.ajax("GET", "/sales/customer/searchMagicAddressPopJsonList", $("#searchAddrForm").serialize(), function(result) {
            AUIGrid.setGridData(mAddrGridID, result);
        }
        );
    }


</script>
<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="sal.title.text.searchAddress" /></h1>
<ul class="right_opt">
    <li id="mClose"><p class="btn_blue2"><a href="#"><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<aside class="title_line"><!-- title_line start -->
<h2><spring:message code="sal.title.text.searchAddress" /></h2>
</aside><!-- title_line end -->

<form action="" id="searchAddrForm" name="searchAddrForm" method="POST">
    <input type="hidden" id="searchStreet" name="searchStreet" value="${searchStreet }">
    <input type="hidden" id="state" name="state" value="${state}">
    <input type="hidden" id="city" name="city" value="${city}">
    <input type="hidden" id="postCode" name="postCode" value="${postCode}">
</form>
<form id="mAddrForm" method="post">
    <input type="hidden" name="custId"  id="_custId"/>  <!-- Cust Id  -->
    <input type="hidden" name="custAddId"   id="_custAddId"/><!-- Address Id  -->
    <input type="hidden" name="custCntcId"   id="_custCntcId"> <!--Contact Id  -->
    <input type="hidden" name="custAccId"   id="_custAccId">
    <input type="hidden" name="selectParam"  id="_selectParam" value="${selectParam}"/> <!-- Page Param  -->
</form>
    <article class="grid_wrap"><!-- grid_wrap start -->
        <div id="maddr_grid_wrap" style="width:100%; height:100%; margin:0 auto;"></div>
    </article><!-- grid_wrap end -->

<aside class="title_line"><!-- title_line start -->
<h2><spring:message code="sal.title.text.installInfomation" /></h2>
</aside><!-- title_line end -->

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->