<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/tiles/view/common.jsp" %>

<script type="text/javaScript">

    var noticeLayout = [{
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
                console.log(item.imgFlag);

                if (item.imgFlag == 'Y') {
                    return "${pageContext.request.contextPath}/resources/images/common/status_new.gif";
                } else {
                    return null;
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


    var detailColumnLayout =
        [
            {
                dataField: "stusCodeId",
                headerText: "<spring:message code='sys.generalCode.grid1.CODE_ID'/>",
                width: "15%"
                , editable: false
            }, {
            dataField: "codeName",
            headerText: "<spring:message code='sys.statuscode.grid1.CODE_NAME'/>",
            width: "55%"
            , editable: false
        }, {
            dataField: "seqNo",
            headerText: "<spring:message code='sys.statusCdMngment.grid1.seqNo'/>",
            width: "15%"
            , editable: true
        }, {
            dataField: "codeDisab",
            headerText: "<spring:message code='sys.generalCode.grid1.DISABLED'/>",
            width: "15%",
            visible: true,
            editRenderer:
                {
                    type: "ComboBoxRenderer",
                    showEditorBtnOver: true, // 마우스 오버 시 에디터버턴 보이기
                    listFunction: function (rowIndex, columnIndex, item, dataField) {
                        var list = getDisibledComboList();
                        return list;
                    },
                    keyField: "id"
                }
        }

        ];

    var codeIDColumnLayout =
        [
            {
                dataField: "checkFlag",
                headerText: '<input type="checkbox" id="allCheckbox" name="allCheckbox" style="width:15px;height:15px;">',
                width: "10%",
                editable: false,
                renderer:
                    {
                        type: "CheckBoxEditRenderer",
                        showLabel: false, // 참, 거짓 텍스트 출력여부( 기본값 false )
                        editable: true, // 체크박스 편집 활성화 여부(기본값 : false)
                        checkValue: 1, // true, false 인 경우가 기본
                        unCheckValue: 0,
                        // 체크박스 Visible 함수
                        visibleFunction: function (rowIndex, columnIndex, value, isChecked, item, dataField) {
                            if (item.checkFlag == 1)  // 1 이면
                            {
                                return true; // checkbox visible
                            }

                            return true;
                        }
                    }  //renderer
            }, {
            dataField: "stusCodeId",
            headerText: "<spring:message code='sys.generalCode.grid1.CODE_ID'/>",
            width: "20%"
        }, {
            dataField: "codeName",
            headerText: "<spring:message code='sys.statuscode.grid1.CODE_NAME'/>",
            style: "aui-grid-left-column",
            width: "50%"
        }, {
            dataField: "code",
            headerText: "<spring:message code='sys.account.grid1.CODE'/>",
            width: "20%"
        }

        ];

    //AUIGrid 생성 후 반환 ID
    var noticeGridID, detailGridID, statusCodeGridID;

    var gridOption = {
        showStateColumn : false
    };

    $(document).ready(function () {

        /***********************************************[ NOTICE GRID] ************************************************/

        noticeGridID = GridCommon.createAUIGrid("noticeGrid", noticeLayout, null, gridOption);

        // 셀 더블클릭 이벤트 바인딩
        AUIGrid.bind(noticeGridID, "cellDoubleClick", function (event) {

            var data = {
                ntceNo: event.item.ntceNo
            };
            Common.popupDiv("/notice/readNoticePop.do", data, null, true, "readNoticePop");
        });

        fn_selectNoticeListAjax();

        /***********************************************[ DETAIL GRID] ************************************************/

        var dtailOptions =
            {
                usePaging: false,
                showRowNumColumn: false, // 그리드 넘버링
                useGroupingPanel: false,
                editable: true,
            };

        // detailGrid 생성
        detailGridID = GridCommon.createAUIGrid("detailGrid", detailColumnLayout, "stusCodeId", dtailOptions);


        /***********************************************[ CODE_ID GRID] ************************************************/

        var statusCodeOptions =
            {
                usePaging: false,
                useGroupingPanel: false,
                editable: true,
                showRowNumColumn: false  // 그리드 넘버링
            };

        // detailGrid 생성
        statusCodeGridID = GridCommon.createAUIGrid("codeIdGrid", codeIDColumnLayout, "stusCodeId", statusCodeOptions);

    });   //$(document).ready


    // 리스트 조회.
    function fn_selectNoticeListAjax() {
        Common.ajax("GET", "/common/getMainNotice.do", {}, function (result) {
            AUIGrid.setGridData(noticeGridID, result);
        });
    }


</script>

<section id="content"><!-- content start -->

    <aside class="title_line main_title"><!-- title_line start -->
        <h2><spring:message code='sys.label.notice'/></h2>
        <p class="more"><a href="${pageContext.request.contextPath}/notice/noticeList.do"><spring:message code='sys.label.more'/> ></a></p>
    </aside><!-- title_line end -->

    <form id="MainForm" method="get" action="">
        <input type="hidden" id="selCategoryId" name="selCategoryId" value=""/>
        <input type="hidden" id="selStusCtgryName" name="selStusCtgryName" value=""/>

        <article class="grid_wrap"><!-- grid_wrap start -->
            <!-- 그리드 영역1 -->
            <div id="noticeGrid" style="height:200px;"></div>
        </article><!-- grid_wrap end -->

        <aside class="title_line main_title mt40"><!-- title_line start -->
            <h2>Trust Ticket Status</h2>
            <p class="more"><a href="javascript:;"><spring:message code='sys.label.more'/> ></a></p>
        </aside><!-- title_line end -->

        <article class="grid_wrap"><!-- grid_wrap start -->
            <!-- 그리드 영역2 -->
            <div id="codeIdGrid" style="height:200px;"></div>
        </article><!-- grid_wrap end -->

        <aside class="title_line main_title mt40"><!-- title_line start -->
            <h2>Daily Performance</h2>
            <p class="more"><a href="javascript:;"><spring:message code='sys.label.more'/> ></a></p>
        </aside><!-- title_line end -->

        <article class="grid_wrap"><!-- grid_wrap start -->
            <!-- 그리드 영역3 -->
            <div id="detailGrid" style="height:200px;"></div>
        </article><!-- grid_wrap end -->

    </form>

</section>
<!-- container end -->
