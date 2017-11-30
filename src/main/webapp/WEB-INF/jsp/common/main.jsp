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

    var tagStatusColumnLayout =
	[
		{
		    dataField: "customer",
		    headerText: "Customer",
		    width: "8%"
		},
		{
		    dataField: "mainInquiry",
		    headerText: "Main Inquiry",
		    width: "13%"
		},
		{
		    dataField: "subInquiry",
		    headerText: "Sub Inquiry",
		    style: "aui-grid-user-custom-left ",
		    width: "13%"
		},
		{
		    dataField: "salesOrder",
		    headerText: "Sales Order",
		    width: "10%"
		},
		{
		    dataField: "mainDepartment",
		    headerText: "Main Department",
		    style: "aui-grid-user-custom-left ",
		    width: "13%"
		},
		{
		    dataField: "subDepartment",
		    headerText: "Sub Department",
		    style: "aui-grid-user-custom-left ",
		    width: "15%"
		},
		{
		    dataField: "claimNote",
		    headerText: "Caim Note",
		    style: "aui-grid-user-custom-left ",
		    width: "18%"
		},
		{
		    dataField: "status",
		    headerText: "Status"
		}
	];


    var detailColumnLayout =
    [
		{
		    dataField: "codeName",
		    headerText: "Div",
		    width: "6%",
		    editable: false
		},
		{
            dataField: "codeName",
            headerText: "Period",
            width: "8%",
            editable: false
        },
        {
            dataField: "",
            headerText: "Key-In Qty",
            children:
            [
				{
				    dataField: "keyInQtyToday",
				    headerText: "Today",
				    width: "8%",
				    editable: false
				},
				{
				    dataField: "keyInQtyAccum",
				    headerText: "Accum.",
				    width: "8%",
				    editable: true
				},
				{
                    dataField: "keyInQtyMonthEnd",
                    headerText: "MonthEnd",
                    width: "8%",
                    editable: true
                }
            ],
            width: "20%",
            editable: false
        },
        {
            dataField: "",
            headerText: "By Product Category (Accum. Key-In Qty)",
            children:
            [
                {
                    dataField: "byPrdCtgrWpurifier",
                    headerText: "WPurifier",
                    width: "8%",
                    editable: false
                },
                {
                    dataField: "byPrdCtgrApurifier",
                    headerText: "Apurifier",
                    width: "8%",
                    editable: true
                },
                {
                    dataField: "byPrdCtgrBidet",
                    headerText: "Bidet",
                    width: "8%",
                    editable: true
                },
                {
                    dataField: "byPrdCtgrSoftner",
                    headerText: "Softner",
                    width: "8%",
                    editable: true
                }
            ],
            width: "20%",
            editable: false
        },
        {
            dataField: "",
            headerText: "By Sales Category (Accum. Key-In Qty)",
            children:
            [
                {
                    dataField: "bySalCtryRental",
                    headerText: "Rental",
                    width: "8%",
                    editable: false
                },
                {
                    dataField: "bySalCtryOutIns",
                    headerText: "Out/Ins",
                    width: "8%",
                    editable: true
                },
                {
                    dataField: "bySalCtryMbrShip",
                    headerText: "Mbr.ship",
                    width: "8%",
                    editable: true
                },
                {
                    dataField: "bySalCtryExtrade",
                    headerText: "Extrade",
                    width: "8%",
                    editable: true
                }
            ],
            width: "20%",
            editable: false
        },
        {
            dataField: "",
            headerText: "NetSales",
            children:
            [
                {
                    dataField: "netSalAccum",
                    headerText: "Accum.",
                    width: "8%",
                    editable: false
                },
                {
                    dataField: "netSalMonthEnd",
                    headerText: "MonthEnd",
                    width: "8%",
                    editable: true
                }
            ],
            editable: false
        },
    ];
    //AUIGrid 생성 후 반환 ID
    var noticeGridID, detailGridID, statusCodeGridID;

    var gridOption = {
        showStateColumn : false,
        usePaging : false
    };

    $(document).ready(function () {
    	$(".bottom_msg_box").attr("style","display:none");
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
                editable: false,
                showRowNumColumn: false  // 그리드 넘버링
            };

        // detailGrid 생성
        statusCodeGridID = GridCommon.createAUIGrid("tagStatusGrid", tagStatusColumnLayout, "", statusCodeOptions);

        fn_selectTagStatusListAjax("Y");
    });   //$(document).ready


    // 리스트 조회.
    function fn_selectNoticeListAjax() {
        Common.ajax("GET", "/common/getMainNotice.do", {}, function (result) {
            AUIGrid.setGridData(noticeGridID, result);
        });
    }

    // Tag Status 리스트 조회.
    function fn_selectTagStatusListAjax(_initYn) {
        Common.ajax("GET", "/common/getTagStatus.do", {initYn:_initYn}, function (result) {
            AUIGrid.setGridData(statusCodeGridID, result);
        });
    }

    function fn_openPopup_tagStatus() {
        var popUpObj = Common.popupDiv
        (
             "/common/openTagStatusPopup.do"
             , ""
             , null
             , "false"
             , "openTagStatusPopup"
        );
   }

    function fn_openPopup_dailyPerformance() {
        var popUpObj = Common.popupDiv
        (
             "/common/userManagement/userManagementNew.do"
             , ""
             , null
             , "false"
             , "userManagementNewPop"
        );
   }


</script>
<style type="text/css">
	/* 커스텀 칼럼 스타일 정의 */
	.aui-grid-user-custom-left {
	    text-align:left;
	}
	.aui-grid-user-custom-right {
	    text-align:right;
	}
</style>
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
            <div id="noticeGrid" style="height:132px;"></div>
        </article><!-- grid_wrap end -->

        <aside class="title_line main_title mt30"><!-- title_line start -->
            <h2>Tag Status</h2>
            <p class="more"><a href="javascript:fn_openPopup_tagStatus();"><spring:message code='sys.label.more'/> ></a></p>
        </aside><!-- title_line end -->

        <article class="grid_wrap"><!-- grid_wrap start -->
            <!-- 그리드 영역2 -->
            <div id="tagStatusGrid" style="height:132px;"></div>
        </article><!-- grid_wrap end -->

        <aside class="title_line main_title mt30"><!-- title_line start -->
            <h2>Daily Performance</h2>
            <%-- <p class="more"><a href="javascript:;"><spring:message code='sys.label.more'/> ></a></p> --%>
        </aside><!-- title_line end -->

        <article class="grid_wrap"><!-- grid_wrap start -->
            <!-- 그리드 영역3 -->
            <div id="detailGrid" style="height:195px;"></div>
        </article><!-- grid_wrap end -->

    </form>

</section>
<!-- container end -->
