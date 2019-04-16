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
        dataField: "pvValue",
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
        dataField: "rc",
        headerText: "SHI Index",
        formatString : "#,##0.00"
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
        dataField: "actMem",
        headerText: "Active HP",
        dataType : "numeric",
        formatString : "#,##0"
    }, {
        dataField: "productivity",
        headerText: "Productivity",
        dataType : "numeric",
        formatString : "#,##0.0"
    }, {
        dataField: "sales",
        headerText: "Group Sales",
        dataType : "numeric",
        formatString : "#,##0"
    }, {
        dataField: "pvValue",
        headerText: "PV Value",
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
        dataField: "rc",
        headerText: "SHI Index",
        formatString : "#,##0.00"
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
        formatString : "#,##0.0"
    }, {
        dataField: "sales",
        headerText: "Group Sales",
        dataType : "numeric",
        formatString : "#,##0"
    }, {
        dataField: "pvValue",
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
        dataField: "rc",
        headerText: "SHI Index",
        formatString : "#,##0.00"
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

     var memoColumnLayout = [
                    {dataField: "memoid",headerText :"<spring:message code='log.head.memoid'/>"           ,width:120    ,height:30 , visible:false},
                    {dataField: "memotitle",headerText :"<spring:message code='log.head.title'/>"              ,width:"30%"    ,height:30 , visible:true},
                    {dataField: "stusname",headerText :"<spring:message code='log.head.statuscode'/>"        ,width:"20$"    ,height:30 , visible:false},
                    {dataField: "crtdt",headerText :"<spring:message code='log.head.createdate'/>"           ,width:"20%"    ,height:30 , visible:true},
                    {dataField: "crtusernm",headerText :"<spring:message code='log.head.creator'/>"          ,width:"20%"   ,height:30 , visible:true},
                    {dataField: "department",headerText :"<spring:message code='log.head.department'/>"          ,width:"20%"    ,height:30 , visible:true},
               ];

    //AUIGrid 생성 후 반환 ID
    var noticeGridID, detailGridID, statusCodeGridID, memoGridID;

    var gridOption = {
        showStateColumn : false,
        usePaging : false
    };

    var memoGridOption = {showStateColumn : false
            , editable : false
            , pageRowCount : 10
            , usePaging : true
            , useGroupingPanel : false
            , fixedColumnCount:2};

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

        		$("#memo").show();
        		memoGridID = GridCommon.createAUIGrid("memoGridID", memoColumnLayout, null, memoGridOption);

        	} else {
        		noticeGridID = GridCommon.createAUIGrid("noticeGrid", noticeLayout, null, gridOption);
        		// 셀 더블클릭 이벤트 바인딩

        		if(result.userTypeId == 2){
        			$("#memo").show();
        			memoGridID = GridCommon.createAUIGrid("memoGridID", memoColumnLayout, null, memoGridOption);
        		}


                AUIGrid.bind(noticeGridID, "cellDoubleClick", function (event) {

                    var data = {
                        ntceNo: event.item.ntceNo
                    };
                    Common.popupDiv("/notice/readNoticePop.do", data, null, true, "readNoticePop");
                });

                fn_selectNoticeListAjax();
        	}

            AUIGrid.bind(memoGridID, "cellDoubleClick", function(event){
                        $("#viewwindow").show();
                        var itm = event.item;
                        $("#vtitle").html(itm.memotitle);
                        $("#vcrtnm").html(itm.crtusernm);
                        $("#vcrtdt").html(itm.fcrtdt);
                        $("#vupdnm").html(itm.updusernm);
                        $("#vupddt").html(itm.upddt);
                        $("#vmemo").html(itm.memocntnt);
            });
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

        fn_selectMemoDashboard();

    });   //$(document).ready


    // 리스트 조회.
    function fn_selectNoticeListAjax() {
        Common.ajax("GET", "/common/getMainNotice.do", {}, function (result) {
            AUIGrid.setGridData(noticeGridID, result);
        });
    }

    function fn_selectSalesDashboard(userRole) {
        Common.ajax("GET", "/common/getSalesOrgPerf.do", {}, function (result) {
            AUIGrid.setGridData(noticeGridID, result);
        });
    }

    function fn_selectMemoDashboard() {
        var url = "/logistics/memorandum/memoSearchList.do";

	    Common.ajax("POST", "/logistics/memorandum/memoSearchList.do", {}, function (result) {
	    	AUIGrid.setGridData(memoGridID, result.data);
	    });


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

        <aside id="memo" class="title_line main_title mt30" style="display:none;">
            <h2>Memorandum</h2>
        </aside>

        <article class="grid_wrap">
             <div id="memoGridID" style="height:210px;"></div>
        </article>



    </form>

<div class="popup_wrap" id="viewwindow" style="display:none"><!-- popup_wrap start -->
        <header class="pop_header"><!-- pop_header start -->
            <h1 id="dataTitle">MEMORANDUM VIEW</h1>
            <ul class="right_opt">
                <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
            </ul>
        </header><!-- pop_header end -->

        <section class="pop_body"><!-- pop_body start -->
            <form id="grForm" name="grForm" method="POST">
            <table class="type1">
            <caption>search table</caption>
            <colgroup>
                <col style="width:150px" />
                <col style="width:*" />
                <col style="width:180px" />
                <col style="width:*" />
               <!--  <col style="width:30px" /> -->
            </colgroup>
            <tbody>
                <tr>
                    <th scope="row">Title</th>
                    <td id="vtitle" colspan="2"></td>
                   <td align="right"><div class="search_100p" align="right"><input name="pdf" type="button" value="PDF" /></div></td>
                </tr>
                <tr>
                    <th scope="row">Creator</th>
                    <td id="vcrtnm"></td>
                    <th scope="row">Create Date</th>
                    <td id="vcrtdt"></td>
                </tr>
                <tr>
                    <th scope="row">Updator</th>
                    <td id="vupdnm"></td>
                    <th scope="row">Update Date</th>
                    <td id="vupddt" ></td>
                </tr>
                <tr>
                    <td id="vmemo" colspan="4"></td>
                </tr>
            </tbody>
            </table>

           <!--  <ul class="center_btns">
                <li><p class="btn_blue2 big"><a id="vclose">CLOSE</a></p></li>
            </ul> -->
            </form>

        </section>
    </div>

</section>
<!-- container end -->
