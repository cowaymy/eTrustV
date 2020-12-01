<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript" language="javascript">
    //AUIGrid 생성 후 반환 ID
    var myGridID;

    $(document).ready(function(){

    	doGetCombo('/organization/selectHpMeetPoint.do', '', '', 'meetingPoint', 'S', '');
        // AUIGrid 그리드를 생성합니다.
        createAUIGrid();

    });

    function createAUIGrid() {
        // AUIGrid 칼럼 설정

        // 데이터 형태는 다음과 같은 형태임,
        //[{"id":"#Cust0","date":"2014-09-03","name":"Han","country":"USA","product":"Apple","color":"Red","price":746400}, { .....} ];
        var columnLayout = [{
            dataField : "memCode",
            headerText : "HP Code",
            width : 130,
            editable : false,
            style : 'left_style'
        }, {
            dataField : "name",
            headerText : "HP Name",
            width : 130,
            editable : false,
            style : 'left_style'
        }, {
            dataField : "orgCode",
            headerText : "Org Code",
            width : 130,
            editable : false,
            style : 'left_style'
        }, {
            dataField : "grpCode",
            headerText : "Grp Code",
            width : 130,
            editable : false,
            style : 'left_style'
        }, {
            dataField : "deptCode",
            headerText : "Dept Code",
            width : 130,
            editable : false,
            style : 'left_style'
        }, {
        	dataField : "joinDt",
        	headerText : "Join Date",
        	width : 130,
        	editable : false,
        	style : 'left_style'
        }, {
        	dataField : "meetPointCode",
        	headerText : "Reporting Branch",
        	width : 130,
        	editable : false,
        	style : 'left_style'
        }, {
        	dataField : "m6",
        	headerText : "Prev 6 Mth",
        	width : 130,
        	editable : false,
        	style : 'left_style'
        }, {
            dataField : "m5",
            headerText : "Prev 5 Mth",
            width : 130,
            editable : false,
            style : 'left_style'
        }, {
            dataField : "m4",
            headerText : "Prev 4 Mth",
            width : 130,
            editable : false,
            style : 'left_style'
        }, {
            dataField : "m3",
            headerText : "Prev 3 Mth",
            width : 130,
            editable : false,
            style : 'left_style'
        }, {
            dataField : "m2",
            headerText : "Prev 2 Mth",
            width : 130,
            editable : false,
            style : 'left_style'
        }, {
            dataField : "m1",
            headerText : "Prev 1 Mth",
            width : 130,
            editable : false,
            style : 'left_style'
        }, {
            dataField : "m0",
            headerText : "Current Mth",
            width : 130,
            editable : false,
            style : 'left_style'
        }, {
            dataField : "totSal",
            headerText : "Total Sales",
            width : 130,
            editable : false,
            style : 'left_style'
        }, {
            dataField : "wsAchv",
            headerText : "Last Mth is WS",
            width : 130,
            editable : false,
            style : 'left_style'
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
                selectionMode : "multipleCells",
                headerHeight : 30,
                // 그룹핑 패널 사용
                useGroupingPanel : false,
                // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
                skipReadonlyColumns : true,
                // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
                wrapSelectionMove : true,
                // 줄번호 칼럼 렌더러 출력
                showRowNumColumn : false,
                groupingMessage : "Here grouping"
        };

        myGridID = AUIGrid.create("#list_grid_wrap", columnLayout, gridPros);
    }

    function fn_searchLoyaltyActHPList() {
        Common.ajax("GET", "/organization/selectLoyaltyActiveHPList.do", $("#loyaltyActHPSearchForm").serialize(), function(result) {
            AUIGrid.setGridData(myGridID, result);
        });
    }

    function fn_genExcel() {
        var dd, mm, yy;

        var today = new Date();
        dd = today.getDay();
        mm = today.getMonth();
        yy = today.getFullYear();

        GridCommon.exportTo("list_grid_wrap", 'xlsx', "LOYALTY_HP_ACTIVE_" + yy + mm + dd);
    }

</script>

<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>Organization</li>
    <li>Organization Mgmt.</li>
</ul>

<aside class="title_line"><!-- title_line start -->
    <p class="fav"><a href="#" class="click_add_on">My menu</a></p>
    <h2>Loyalty Active HP Listing</h2>
    <ul class="right_btns">
        <c:if test="${PAGE_AUTH.funcView == 'Y' }">
        <li><p class="btn_blue"><a href="#" onclick="javascript:fn_searchLoyaltyActHPList()"><span class="search"></span><spring:message code="sal.btn.search" /></a></p></li>
        </c:if>
        <li><p class="btn_blue"><a href="#" onclick="javascript:fn_genExcel();" id="genExcelBtn">Generate Excel</a></p></li>
    </ul>
</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->
    <form id="loyaltyActHPSearchForm" name="loyaltyActHPSearchForm" method="post">
        <table class="type1"><!-- table start -->
            <caption>table</caption>
            <colgroup>
                <col style="width:140px" />
                <col style=*" />
                <col style="width:130px" />
                <col style=*" />
                <col style="width:170px" />
                <col style=*" />
            </colgroup>
            <tbody>
                <tr>
                    <th scope="row">HP Code</th>
                    <td>
                        <input type="text" title="HP Code" id="hpCode" name="hpCode" placeholder="HP Code" class="w100p" />
                    </td>
                    <th scope="row">Reporting Branch</th>
                    <td>
                        <select title="Reporting Branch" id="meetingPoint" name="meetingPoint" class="w100p"></select>
                    </td>
                    <th scope="row"></th>
                    <td></td>
                </tr>
                <tr>
                    <th scope="row">Org Code</th>
                    <td>
                        <input type="text" title="Org Code" id="orgCode" name="orgCode" placeholder="Org Code" class="w100p" />
                    </td>
                    <th scope="row">Grp Code</th>
                    <td>
                        <input type="text" title="Grp Code" id="grpCode" name="grpCode" placeholder="Grp Code" class="w100p" />
                    </td>
                    <th scope="row">Dept Code</th>
                    <td>
                        <input type="text" title="Dept Code" id="deptCode" name="deptCode" placeholder="Dept Code" class="w100p" />
                    </td>
                </tr>
            </tbody>
        </table><!-- table end -->

    </form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->
    <article class="grid_wrap"><!-- grid_wrap start -->
        <div id="list_grid_wrap" style="width:100%; height:480px; margin:0 auto;"></div>
    </article><!-- grid_wrap end -->
</section><!-- search_result end -->

</section><!-- content end -->