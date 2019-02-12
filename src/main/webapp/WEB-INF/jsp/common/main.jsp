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

    var hpDashboard = [{
        dataField: "period",
        headerText: "Period"
    }, {
        dataField: "ranking",
        headerText: "Rank"
    }, {
        dataField: "sponsor",
        headerText: "Self Sponsor",
        dataType : "numeric",
        formatString : "#,##0"
    }, {
        dataField: "actMem",
        headerText: "Active HP",
        dataType : "numeric",
        formatString : "#,##0"
    }, {
        dataField: "sales",
        headerText: "Own Sales",
        dataType : "numeric",
        formatString : "#,##0"
    }, {
        dataField: "pvVal",
        headerText: "PV Value",
        dataType : "numeric",
        formatString : "#,##0"
    }, {
        dataField: "ys",
        headerText: "YS",
        dataType : "numeric",
        formatString : "#,##0"
    }, {
        dataField: "actOrd",
        headerText: "Active Order",
        dataType : "numeric",
        formatString : "#,##0"
    }, {
        dataField: "rcRate",
        headerText: "RC Rate"
    }];

    var salesManagerDashboard = [{
        dataField: "period",
        headerText: "Period"
    }, {
        dataField: "ranking",
        headerText: "Rank"
    }, {
        dataField: "sponsor",
        headerText: "Sponsor",
        dataType : "numeric",
        formatString : "#,##0"
    }, {
        dataField: "recruit",
        headerText: "Recruit",
        dataType : "numeric",
        formatString : "#,##0"
    }, {
        dataField: "actmem",
        headerText: "Active HP",
        dataType : "numeric",
        formatString : "#,##0"
    }, {
        dataField: "prdtvy",
        headerText: "Productivity",
        dataType : "numeric",
        formatString : "#,##0"
    }, {
        dataField: "sales",
        headerText: "Group Sales",
        dataType : "numeric",
        formatString : "#,##0"
    }, {
        dataField: "pvval",
        headerText: "PV Value",
        dataType : "numeric",
        formatString : "#,##0"
    }, {
        dataField: "actord",
        headerText: "Active Order",
        dataType : "numeric",
        formatString : "#,##0"
    }, {
        dataField: "ys",
        headerText: "YS",
        dataType : "numeric",
        formatString : "#,##0"
    }, {
        dataField: "rc",
        headerText: "RC Rate"
    }];

    var sgmDashboard = [{
        dataField: "period",
        headerText: "Period"
    }, {
        dataField: "sponsor",
        headerText: "Sponsor",
        dataType : "numeric",
        formatString : "#,##0"
    }, {
        dataField: "recruit",
        headerText: "Recruit",
        dataType : "numeric",
        formatString : "#,##0"
    }, {
        dataField: "actMem",
        headerText: "Active HP with Net Sales",
        dataType : "numeric",
        formatString : "#,##0"
    }, {
        dataField: "productivity",
        headerText: "Productivity",
        dataType : "numeric",
        formatString : "#,##0"
    }, {
        dataField: "sales",
        headerText: "Group Sales",
        dataType : "numeric",
        formatString : "#,##0"
    }, {
        dataField: "pvVal",
        headerText: "PV Value (Net Sales)",
        dataType : "numeric",
        formatString : "#,##0"
    }, {
        dataField: "actOrd",
        headerText: "Active Order",
        dataType : "numeric",
        formatString : "#,##0"
    }, {
        dataField: "ys",
        headerText: "YS",
        dataType : "numeric",
        formatString : "#,##0"
    }, {
        dataField: "rcRate",
        headerText: "RC Rate"
    }];
/*
    var tagStatusColumnLayout =
	[
		{
		    dataField: "customer",
		    headerText: "Customer",
		    editable: false,
		    width: "8%"
		},
		{
		    dataField: "mainInquiry",
		    headerText: "Main Inquiry",
		    editable: false,
		    width: "13%"
		},
		{
		    dataField: "subInquiry",
		    headerText: "Sub Inquiry",
		    style: "aui-grid-user-custom-left ",
		    editable: false,
		    width: "13%"
		},
		{
		    dataField: "salesOrder",
		    headerText: "Sales Order",
		    editable: false,
		    width: "10%"
		},
		{
		    dataField: "mainDepartment",
		    headerText: "Main Department",
		    editable: false,
		    style: "aui-grid-user-custom-left ",
		    width: "13%"
		},
		{
		    dataField: "subDepartment",
		    headerText: "Sub Department",
		    editable: false,
		    style: "aui-grid-user-custom-left ",
		    width: "15%"
		},
		{
		    dataField: "claimNote",
		    headerText: "Claim Note",
		    editable: false,
		    style: "aui-grid-user-custom-left ",
		    width: "18%"
		},
		{
		    dataField: "status",
		    headerText: "Status",
		    editable: false
		}
	];
*/
    var detailColumnLayout =
    [
	     /* PK , rowid 용 칼럼*/
	     {
	         dataField : "divCode",
	         dataType : "string",
	         visible : false
	     },
		{
		    dataField: "divName",
		    headerText: "Div",
		    cellMerge : true,
		    width: "5%",
		    editable: false
		},
		{
            dataField: "period",
            headerText: "Period",
            width: "8.3%",
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
				    style: "aui-grid-user-custom-right ",
				    dataType : "numeric",
                    formatString : "#,##0",
				    width: "6.7%",
				    editable: false
				},
				{
				    dataField: "keyInQtyAccum",
				    headerText: "Accum.",
				    style: "aui-grid-user-custom-right ",
				    dataType : "numeric",
                    formatString : "#,##0",
				    width: "6.7%",
				    editable: false
				},
				{
                    dataField: "keyInQtyMonthEnd",
                    headerText: "M.End",
                    style: "aui-grid-user-custom-right ",
                    dataType : "numeric",
                    formatString : "#,##0",
                    width: "6.7%",
                    editable: false
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
                    dataField: "byPrdCtgryWpurifier",
                    headerText: "W.Purf",
                    style: "aui-grid-user-custom-right ",
                    dataType : "numeric",
                    formatString : "#,##0",
                    width: "6.7%",
                    editable: false
                },
                {
                    dataField: "byPrdCtgryApurifier",
                    headerText: "A.purf",
                    style: "aui-grid-user-custom-right ",
                    dataType : "numeric",
                    formatString : "#,##0",
                    width: "6.7%",
                    editable: false
                },
                {
                    dataField: "byPrdCtgryBidet",
                    headerText: "Bidet",
                    style: "aui-grid-user-custom-right ",
                    dataType : "numeric",
                    formatString : "#,##0",
                    width: "6.7%",
                    editable: false
                },
                {
                    dataField: "byPrdCtgrySoftner",
                    headerText: "Softner",
                    style: "aui-grid-user-custom-right ",
                    dataType : "numeric",
                    formatString : "#,##0",
                    width: "6.7%",
                    editable: false
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
                    dataField: "bySalesCtgryRental",
                    headerText: "Rental",
                    style: "aui-grid-user-custom-right ",
                    dataType : "numeric",
                    formatString : "#,##0",
                    width: "6.7%",
                    editable: false
                },
                {
                    dataField: "bySalesCtgryOutIns",
                    headerText: "Out/Ins",
                    style: "aui-grid-user-custom-right ",
                    dataType : "numeric",
                    formatString : "#,##0",
                    width: "6.7%",
                    editable: false
                },
                {
                    dataField: "bySalesCtgryMbrShip",
                    headerText: "Mbr.ship",
                    style: "aui-grid-user-custom-right gray-field  ",
                    dataType : "numeric",
                    formatString : "#,##0",
                    width: "6.7%",
                    editable: false
                },
                {
                    dataField: "bySalesCtgryExtrade",
                    headerText: "Extrade",
                    style: "aui-grid-user-custom-right gray-field ",
                    dataType : "numeric",
                    formatString : "#,##0",
                    width: "6.7%",
                    editable: false
                }
            ],
            width: "19%",
            editable: false
        },
        {
            dataField: "",
            headerText: "NetSales",
            children:
            [
                {
                    dataField: "netSalesAccum",
                    headerText: "Accum.",
                    style: "aui-grid-user-custom-right ",
                    dataType : "numeric",
                    formatString : "#,##0",
                    width: "6.5%",
                    editable: false
                },
                {
                    dataField: "netSalesMonthEnd",
                    headerText: "M.End",
                    style: "aui-grid-user-custom-right ",
                    dataType : "numeric",
                    formatString : "#,##0",
                    width: "6.5%",
                    editable: false
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

        var roleType;

        Common.ajax("GET", "/login/getLoginDtls.do", {}, function (result) {
        	console.log(result);

        	roleType = result.roleType;

        	if(result.userTypeId == 1) {
        		$("#notice").empty();
        		$("#notice").append("Sales Organization Performance");
        		$("#moreNotice").hide();

        		var salesGridOption = {
        			    usePaging : false,
        			    showStateColumn : false,
        			    pageRowCount : 4,
        			    editable : false
        			};

        		if(result.roleType == 115) {
        			console.log("else :: hpDashboard");
        			noticeGridID = GridCommon.createAUIGrid("noticeGrid", hpDashboard, null, salesGridOption);
        		} else if(result.roleType == 111) {
        			console.log("else :: sgmDashboard");
        			noticeGridID = GridCommon.createAUIGrid("noticeGrid", sgmDashboard, null, salesGridOption);
        		} else {
        			console.log("else :: salesManagerDashboard");
        			noticeGridID = GridCommon.createAUIGrid("noticeGrid", salesManagerDashboard, null, salesGridOption);
        		}
        	} else {
        		noticeGridID = GridCommon.createAUIGrid("noticeGrid", noticeLayout, null, gridOption);

        		// 셀 더블클릭 이벤트 바인딩
                AUIGrid.bind(noticeGridID, "cellDoubleClick", function (event) {

                    var data = {
                        ntceNo: event.item.ntceNo
                    };
                    Common.popupDiv("/notice/readNoticePop.do", data, null, true, "readNoticePop");
                });

                fn_selectNoticeListAjax();
        	}
        });

        /***********************************************[ DETAIL GRID] ************************************************/

        var dtailOptions =
        {
            usePaging: false,
            showRowNumColumn: false, // 그리드 넘버링
            showStateColumn : false,
            useGroupingPanel: false,
            editable: true,
         // 셀 병합 실행
            enableCellMerge : true,
            cellMergePolicy : "withNull",

            rowIdField : "divCode" // PK행 지정
/*             // 고정 칼럼 1개 적용시킴
            fixedColumnCount : 2 */
        };

        // detailGrid 생성
        detailGridID = GridCommon.createAUIGrid("detailGrid", detailColumnLayout, "stusCodeId", dtailOptions);

        /***********************************************[ CODE_ID GRID] ************************************************/
        /*
        var statusCodeOptions =
            {
                usePaging: false,
                useGroupingPanel: false,
                showStateColumn : false,
                editable: false,
                showRowNumColumn: false  // 그리드 넘버링
            };

        // detailGrid 생성
        statusCodeGridID = GridCommon.createAUIGrid("tagStatusGrid", tagStatusColumnLayout, "", statusCodeOptions);

        fn_selectTagStatusListAjax("Y");
        */
        fn_selectDailyPerformanceListAjax();

        fn_selectSalesDashboard(roleType);
    });   //$(document).ready


    // 리스트 조회.
    function fn_selectNoticeListAjax() {
        Common.ajax("GET", "/common/getMainNotice.do", {}, function (result) {
            AUIGrid.setGridData(noticeGridID, result);
        });
    }

    function fn_selectSalesDashboard(userRole) {
        if(userRole == 115) { // hp
            Common.ajax("GET", "/common/getSalesOrgPerf.do", {}, function (result) {
                console.log(result);
                AUIGrid.setGridData(noticeGridID, result);
            });
        } else if(userRole == 111) { // sgm
            Common.ajax("GET", "/common/getSalesOrgPerf.do", {}, function (result) {
                console.log(result);
                AUIGrid.setGridData(noticeGridID, result);
            });
        } else { // hm sm gm
            Common.ajax("GET", "/common/getSalesOrgPerf.do", {}, function (result) {
                console.log(result);
                AUIGrid.setGridData(noticeGridID, result);
            });
        }
    }
/*
    // Tag Status 리스트 조회.
    function fn_selectTagStatusListAjax(_initYn) {
        Common.ajax("GET", "/common/getTagStatus.do", {initYn:_initYn}, function (result) {
            AUIGrid.setGridData(statusCodeGridID, result);
        });
    }
*/
    // Daily Performance 리스트 조회.
    function fn_selectDailyPerformanceListAjax() {
        Common.ajax("GET", "/common/getDailyPerformance.do", {}, function (result) {
            AUIGrid.setGridData(detailGridID, result);
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

</script>
<style type="text/css">
	/* 커스텀 칼럼 스타일 정의 */
	.aui-grid-user-custom-left {
	    text-align:left;
	}
	.aui-grid-user-custom-right {
	    text-align:right;
	}
	.gray-field {
		background : #eeeeee;
		color:#000;
	}
</style>
<section id="content"><!-- content start -->

    <aside class="title_line main_title"><!-- title_line start -->
        <h2 id="notice"><spring:message code='sys.label.notice'/></h2>
        <p class="more" id="moreNotice"><a href="${pageContext.request.contextPath}/notice/noticeList.do"><spring:message code='sys.label.more'/> ></a></p>
    </aside><!-- title_line end -->

    <form id="MainForm" method="get" action="">
        <input type="hidden" id="selCategoryId" name="selCategoryId" value=""/>
        <input type="hidden" id="selStusCtgryName" name="selStusCtgryName" value=""/>

        <article class="grid_wrap"><!-- grid_wrap start -->
            <!-- 그리드 영역1 -->
            <div id="noticeGrid" style="height:132px;"></div>
        </article><!-- grid_wrap end -->
<!--
        <aside class="title_line main_title mt30">
            <h2>Tag Status</h2>
            <p class="more"><a href="javascript:fn_openPopup_tagStatus();"><spring:message code='sys.label.more'/> ></a></p>
        </aside>

        <article class="grid_wrap">
            <div id="tagStatusGrid" style="height:132px;"></div>
        </article>
-->

        <aside class="title_line main_title mt30"><!-- title_line start -->
            <h2>Daily Performance</h2>
            <%-- <p class="more"><a href="javascript:;"><spring:message code='sys.label.more'/> ></a></p> --%>
        </aside><!-- title_line end -->

        <article class="grid_wrap"><!-- grid_wrap start -->
            <!-- 그리드 영역3 -->
            <div id="detailGrid" style="height:210px;"></div>
        </article><!-- grid_wrap end -->

    </form>

</section>
<!-- container end -->
