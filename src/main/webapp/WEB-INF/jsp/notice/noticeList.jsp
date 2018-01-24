<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/tiles/view/common.jsp" %>

<style type="text/css">

    /* 커스텀 칼럼 스타일 정의 */
    .aui-grid-user-custom-left {
        text-align: left;
    }
</style>

<script type="text/javascript">

    // var ntceNo;
    //AUIGrid 생성 후 반환 ID

    var myGridID;

    // AUIGrid 칼럼 설정
    // 데이터 형태는 다음과 같은 형태임,
    //[{"id":"#Cust0","date":"2014-09-03","name":"Han","country":"USA","product":"Apple","color":"Red","price":746400}, { .....} ];
    var columnLayout = [{
        dataField: "ntceNo",
        visible: false
    }, {
        dataField: "ntceSubject",  //NTCE_SUBJECT
        headerText: "<spring:message code='sys.title.subject'/>",
        editable: false,
        visible: true,
        style: "aui-grid-user-custom-left",
        renderer: {
            type: "IconRenderer",
            iconPosition: "right",  // 아이콘 위치       aisleLeft
            iconFunction: function (rowIndex, columnIndex, value, item) {

                if(item.imgFlag == 'Y') {
                    return "${pageContext.request.contextPath}/resources/images/common/status_new.gif";
                }
            },
            iconWidth: 24,
            iconHeight: 10
        }
    }, {
        dataField: "rgstUserNm",    //RGST_USER_NM
        headerText: "<spring:message code='sys.title.writer'/>",
        width: 160,
        editable: false,
        visible: true
    }, {
        dataField: "crtDt",     //CRT_DT
        headerText: "<spring:message code='sys.title.issue'/> <spring:message code='sys.title.date'/>",
        width: 170,
        editable: false,
        visible: true,
        dataType: "date",
        formatString: "dd-mm-yyyy"
    }, {
        dataField: "readCnt",     //READ_CNT
        headerText: "<spring:message code='sys.title.read'/> <spring:message code='sys.title.count'/>",
        width: 140,
        editable: false,
        visible: true
    }, {
        dataField: "imgFlag",
        headerText: "<spring:message code='sys.title.image'/> <spring:message code='sys.title.flag'/>",
        width: 140,
        editable: false,
        visible: false
    }];

    // 그리드 속성 설정
    var gridPros = {

        // 페이징 사용       
        usePaging: true,

        // 한 화면에 출력되는 행 개수 20(기본값:20)
        pageRowCount: 20,

        editable: true,

        fixedColumnCount: 1,

        showStateColumn: false,

        displayTreeOpen: true,

        selectionMode: "multipleCells",

        headerHeight: 30,

        // 그룹핑 패널 사용
        useGroupingPanel: false,

        // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
        skipReadonlyColumns: true,

        // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
        wrapSelectionMove: true,

        // 줄번호 칼럼 렌더러 출력
        showRowNumColumn: true,

        groupingMessage: "Notice"
    };

    $(document).ready(function () {

//         $("#openPop").click(fn_openPop());

        myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout,'',gridPros);
        doGetCombo('/notice/selectCodeList', '', '', 'noticeSearch', 'S', '');
        // 리스트 조회.
        fn_selectNoticeListAjax();

        AUIGrid.bind(myGridID, "cellDoubleClick", function (event) {
            console.log("cellDoubleClick ntceNo : " + event.item.ntceNo);
            fn_readNoticePop(event.item.ntceNo);
        });

    });

    // 리스트 조회.
    function fn_selectNoticeListAjax() {
        Common.ajax("GET", "/notice/noticeViewList", $("#searchForm").serialize(), function (result) {
            AUIGrid.setGridData(myGridID, result);
        });
    }


    function fn_readNoticePop(ntceNo) {
        var data = {
            ntceNo: ntceNo
        };
        Common.popupDiv("/notice/readNoticePop.do", data, null, true, "readNoticePop");
    }

    function fn_newNotice() {
        Common.popupDiv("/notice/createNoticePop.do");
    }

</script>

<section id="content"><!-- content start -->
    <ul class="path">
        <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home"/></li>
        <li>Sales</li>
        <li>Order list</li>
    </ul>

    <aside class="title_line"><!-- title_line start -->
        <p class="fav"><a href="#" class="click_add_on">My menu</a></p>
        <h2>Notice</h2>
        <ul class="right_btns">
            <li><p class="btn_blue"><a href="#" onclick="javascript:fn_selectNoticeListAjax();"><span
                    class="search"></span>Search</a></p></li>
        </ul>
    </aside><!-- title_line end -->

    <aside class="title_line"><!-- title_line start -->
        <h3>Select Condition</h3>
    </aside><!-- title_line end -->

    <section class="search_table"><!-- search_table start -->
        <form id="searchForm" name="searchForm" action="#" method="post">
            <!-- table start -->
            <table class="type1">

                <caption>table</caption>
                <colgroup>
                    <col style="width:250px"/>
                    <col style="width:*"/>
                </colgroup>
                <tbody>
                <tr>
                    <td>
                        <select id="noticeSearch" name="noticeSearch" class="w10p"></select>
                    </td>
                    <td><input type="text" name="keyword" id="keyword" placeholder="" class="w20p"/></td>
                </tr>
                </tbody>
            </table><!-- table end -->
        </form>
    </section><!-- search_table end -->

    <section class="search_result"><!-- search_result start -->
        <ul class="right_btns">
            <li><p class="btn_blue"><a id="newPop" onclick="javascript:fn_newNotice();" href="#"><spring:message code='notice.btn.new'/></a></p></li>
        </ul>
        <br>

        <article class="grid_wrap"><!-- grid_wrap start -->
            <div id="grid_wrap" style="width:100%; height:480px; margin:0 auto;"></div>
        </article><!-- grid_wrap end -->

    </section><!-- search_result end -->

</section>
<!-- content end -->

