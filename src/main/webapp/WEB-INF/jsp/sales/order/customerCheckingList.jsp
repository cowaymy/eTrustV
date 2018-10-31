<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">

    //AUIGrid 생성 후 반환 ID
    var custGridID;

    // popup 크기
    var option = {
            width : "1200px",   // 창 가로 크기
            height : "500px"    // 창 세로 크기
    };

    var basicAuth = false;


    $(document).ready(function(){

        // AUIGrid 그리드를 생성합니다.
        createAUIGrid();

   //     AUIGrid.setSelectionMode(custGridID, "singleRow");

        // 셀 더블클릭 이벤트 바인딩
        AUIGrid.bind(custGridID, "cellDoubleClick", function(event){
            $("#_ordId").val(event.item.salesOrdId);

            Common.popupDiv("/sales/customer/selectCustomerOrderView.do", $("#popForm").serializeJSON());
        });
        // 셀 클릭 이벤트 바인딩



        //Search
        $("#_listSearchBtn").click(function() {

            fn_selectPstRequestDOListAjax();
        });

    });


    function createAUIGrid() {
        // AUIGrid 칼럼 설정

        // 데이터 형태는 다음과 같은 형태임,
        //[{"id":"#Cust0","date":"2014-09-03","name":"Han","country":"USA","product":"Apple","color":"Red","price":746400}, { .....} ];
        var columnLayout = [ {
                dataField : "salesOrdId",
                headerText : 'Order Id',
                width : 140,
                editable : false,
                visible : false
            }, {
                dataField : "salesOrdNo",
                headerText : 'Order No',
                width : 140,
                editable : false
            }, {
                dataField : "ordStus",
                headerText : 'Status',
                width : 120,
                editable : false
            }, {
                dataField : "custName",
                headerText : 'Customer Name',
                width : 180,
                editable : false
            }, {
                dataField : "product",
                headerText : 'Product',
                width : 250,
                editable : false
            }, {
                dataField : "appCode",
                headerText : 'App Type',
                width : 100,
                editable : false
            },{
                dataField : "payModeCode",
                headerText : 'Payment Mode',
                width : 140,
                editable : false
            },{
                dataField : "pvMonth",
                headerText : 'PV Month',
                width : 160,
                editable : false
            },{
                dataField : "pvYear",
                headerText : 'PV Year',
                width : 160,
                editable : false
            }];

     // 그리드 속성 설정
        var gridPros = {

            // 페이징 사용
            usePaging : true,

            // 한 화면에 출력되는 행 개수 20(기본값:20)
            pageRowCount : 20,

            editable : true,

            fixedColumnCount : 1,

            showStateColumn : false,

            displayTreeOpen : true,

       //     selectionMode : "multipleCells",

            headerHeight : 30,

            // 그룹핑 패널 사용
            useGroupingPanel : false,

            // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
            skipReadonlyColumns : true,

            // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
            wrapSelectionMove : true,

            // 줄번호 칼럼 렌더러 출력
            showRowNumColumn : true
        };

        //custGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout, gridPros);
        custGridID = AUIGrid.create("#grid_wrap", columnLayout, gridPros);
    }

    // 리스트 조회.
    function fn_selectPstRequestDOListAjax() {
        Common.ajax("GET", "/sales/customer/selectCustomerCheckingList", $("#searchForm").serialize(), function(result) {
            AUIGrid.setGridData(custGridID, result);
        }
        );
    }







</script>

<form id="popForm" method="post">
    <input type="hidden" name="ordId"  id="_ordId"/> 

</form>



<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>Sales</li>
    <li>Order</li>
    <li>Customer Checking UI</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>Customer Checking UI List</h2>

<ul class="right_btns">


    <li><p class="btn_blue"><a href="#" id="_listSearchBtn"><span class="search"></span><spring:message code="sal.btn.search" /></a></p></li>

</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
    <form id="searchForm" name="searchForm" action="#" method="post">
    <table class="type1"><!-- table start -->
    <caption>table</caption>
    <colgroup>
        <col style="width:140px" />
        <col style="width:*" />
        <col style="width:130px" />
        <col style="width:*" />
        <col style="width:170px" />
        <col style="width:*" />
    </colgroup>
    <tbody>
    <tr>

        <th scope="row"><spring:message code="sal.title.text.nricCompNo" /></th>
        <td>
        <input type="text" title="NRIC/Company No" id="_nric" name="nric" placeholder="NRIC / Company Number" class="w100p" " />
        </td>
    </tr>

    </tbody>
    </table><!-- table end -->



    </form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->
<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="grid_wrap" style="width:100%; height:480px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->
</section><!-- search_result end -->
</section><!-- content end -->
