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
            $("#_ordNo").val(event.item.salesOrdNo);
            $("#_custId").val(event.item.custId);
            $("#_promoId").val(event.item.promoId);



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
                width : "10%",
                editable : false
            }, {
                dataField : "ordStus",
                headerText : 'Status',
                width : "10%",
                editable : false
            }, {
                dataField : "custName",
                headerText : 'Customer Name',
                width : "15%",
                editable : false
            }, {
                dataField : "product",
                headerText : 'Product',
                width : "15%",
                editable : false
            }, {
                dataField : "appCode",
                headerText : 'App Type',
                width : "10%",
                editable : false
            },{
                dataField : "payModeCode",
                headerText : 'Payment Mode',
                width : "10%",
                editable : false
            },{
                dataField : "pvMonth",
                headerText : 'PV Month',
                width : "10%",
                editable : false
            },{
                dataField : "pvYear",
                headerText : 'PV Year',
                width : "10%",
                editable : false
            },{
                dataField : "chsStus",
                headerText : 'CHS',
                width : "10%",
                editable : false
            }
            ];

     // 그리드 속성 설정
        var gridPros = {
            usePaging : true,
            pageRowCount : 20,
            editable : true,
            fixedColumnCount : 1,
            showStateColumn : false,
            displayTreeOpen : true,
       //     selectionMode : "multipleCells",
            headerHeight : 30,
            useGroupingPanel : false,
            skipReadonlyColumns : true,
            wrapSelectionMove : true,
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
    <input type="hidden" name="salesOrdNo"  id="_ordNo"/>
    <input type="hidden" name="custId"  id="_custId"/>
    <input type="hidden" name="promoId"  id="_promoId"/>
</form>



<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>Sales</li>
    <li>Order</li>
    <li>I-Care Eligibility</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>I-Care Eligibility</h2>

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
    </colgroup>
    <tbody>
    <tr>

        <th scope="row"><spring:message code="sal.title.text.nricCompNo" /></th>
        <td>
        <input type="text" title="NRIC/Company No" id="_nric" name="nric" placeholder="NRIC / Company Number"/>
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
