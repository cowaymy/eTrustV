<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/tiles/view/common.jsp" %>
<!-- [Woongjin Jun] Tab -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/jquery-ui.css">

<style>
    #tabs { margin-top: 0; }
    #tabs li .ui-icon-close { float: left; margin: 0.4em 0.2em 0 0; cursor: pointer; }
    #add_tab { cursor: pointer; }
</style>
<!-- [Woongjin Jun] Tab -->

<script type="text/javaScript">

    var roleId = '${SESSION_INFO.roleId}';
    var headers = [{memLvl: "1", dob : "", fullName:"GM",memCode:"", title:"GM", header: "1"},
                   {memLvl: "2", dob : "", fullName:"SM", memCode:"", title:"SM", header: "1"},
                   {memLvl: "3", dob : "", fullName:"HM",memCode:"", title:"HM", header: "1"}];

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
                //console.log(item.imgFlag);

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
        headerText: "Period",
        width : "12.5%"
    }, {
        dataField: "ranking",
        headerText: "Rank",
        width : "12.5%"
    }, {
        dataField: "sponsor",
        headerText: "Self<br/>Sponsor",
        dataType : "numeric",
        formatString : "#,##0",
        width : "15%"
    }, {
        dataField: "actMem",
        headerText: "Active<br/>HP",
        dataType : "numeric",
        formatString : "#,##0",
        width : "15%"
    }, {
        dataField: "sales",
        headerText: "Own<br/>Sales",
        dataType : "numeric",
        formatString : "#,##0",
        width : "15%"
    }, {
        dataField: "pvValue",
        headerText: "PV<br/>Value",
        dataType : "numeric",
        formatString : "#,##0",
        width : "15%"
    }, {
        dataField: "rc",
        headerText: "SHI<br/>Index",
        formatString : "#,##0.00",
        width : "15%"
    }, {
        dataField: "indRc",
        headerText: "Ind SHI<br/>Index",
        formatString : "#,##0.00",
        width : "12.5%"
    }, {
        dataField: "comRc",
        headerText: "Com SHI<br/>Index",
        formatString : "#,##0.00",
        width : "12.5%"
    }, {
        dataField: "haRc",
        headerText: "HA SHI<br/>Index",
        formatString : "#,##0.00",
        width : "12.5%"
    }, {
        dataField: "hcRc",
        headerText: "HC SHI<br/>Index",
        formatString : "#,##0.00",
        width : "12.5%"
    }, {
        dataField: "opc",
        headerText: "Own<br/>Purchase<br/>Collection",
        formatString : "#,##0.00",
        width : "12.5%"
    }];

    var salesManagerDashboard = [{
        dataField: "period",
        headerText: "Period",
        width : "12.5%"
    }, {
        dataField: "ranking",
        headerText: "Rank",
        width : "10.5%"
    }, {
        dataField: "sponsor",
        headerText: "Sponsor",
        dataType : "numeric",
        formatString : "#,##0",
        width : "9%"
    }, {
        dataField: "recruit",
        headerText: "Recruit",
        dataType : "numeric",
        formatString : "#,##0",
        width : "9%"
    }, {
        dataField: "actMem",
        headerText: "Active<br/>HP",
        dataType : "numeric",
        formatString : "#,##0",
        width : "9%"
    }, {
        dataField: "productivity",
        headerText: "Productivity",
        dataType : "numeric",
        formatString : "#,##0.0",
        width : "12.5%"
    }, {
        dataField: "sales",
        headerText: "Group<br/>Sales",
        dataType : "numeric",
        formatString : "#,##0",
        width : "12.5%"
    }, {
        dataField: "pvValue",
        headerText: "PV<br/>Value",
        dataType : "numeric",
        formatString : "#,##0",
        width : "12.5%"
    }, {
        dataField: "rc",
        headerText: "SHI<br/>Index",
        formatString : "#,##0.00",
        width : "12.5%"
    }, {
        dataField: "indRc",
        headerText: "Ind SHI<br/>Index",
        formatString : "#,##0.00",
        width : "12.5%"
    }, {
        dataField: "comRc",
        headerText: "Com SHI<br/>Index",
        formatString : "#,##0.00",
        width : "12.5%"
    }, {
        dataField: "haRc",
        headerText: "HA SHI<br/>Index",
        formatString : "#,##0.00",
        width : "12.5%"
    }, {
        dataField: "hcRc",
        headerText: "HC SHI<br/>Index",
        formatString : "#,##0.00",
        width : "12.5%"
    }, {
        dataField: "opc",
        headerText: "Own<br/>Purchase<br/>Collection",
        formatString : "#,##0.00",
        width : "12.5%"
    }];

    var sgmDashboard = [{
        dataField: "period",
        headerText: "Period",
        width : "12.5%"
    }, {
        dataField: "sponsor",
        headerText: "Sponsor",
        dataType : "numeric",
        formatString : "#,##0",
        width : "12.5%"
    }, {
        dataField: "recruit",
        headerText: "Recruit",
        dataType : "numeric",
        formatString : "#,##0",
        width : "12.5%"
    }, {
        dataField: "actMem",
        headerText: "Active HP<br/>with<br/>Net Sales",
        dataType : "numeric",
        formatString : "#,##0",
        width : "12.5%"
    }, {
        dataField: "productivity",
        headerText: "Productivity",
        dataType : "numeric",
        formatString : "#,##0.0",
        width : "12.5%"
    }, {
        dataField: "sales",
        headerText: "Group<br/>Sales",
        dataType : "numeric",
        formatString : "#,##0",
        width : "12.5%"
    }, {
        dataField: "pvValue",
        headerText: "PV Value<br/>(Net Sales)",
        dataType : "numeric",
        formatString : "#,##0",
        width : "12.5%"
    }, {
        dataField: "rc",
        headerText: "SHI<br/>Index",
        formatString : "#,##0.00",
        width : "12.5%"
    }, {
        dataField: "indRc",
        headerText: "Ind SHI<br/>Index",
        formatString : "#,##0.00",
        width : "12.5%"
    }, {
        dataField: "comRc",
        headerText: "Com SHI<br/>Index",
        formatString : "#,##0.00",
        width : "12.5%"
    }, {
        dataField: "haRc",
        headerText: "HA SHI<br/>Index",
        formatString : "#,##0.00",
        width : "12.5%"
    }, {
        dataField: "hcRc",
        headerText: "HC SHI<br/>Index",
        formatString : "#,##0.00",
        width : "12.5%"
    }, {
        dataField: "opc",
        headerText: "Own<br/>Purchase<br/>Collection",
        formatString : "#,##0.00",
        width : "12.5%"
    }];

    var dailyPerfDashboard = [{
        dataField: "period",
        headerText: "Period",
        width : "45%"
    }, {
        dataField: "actOrd",
        headerText: "Active<br/>Order",
        dataType : "numeric",
        formatString : "#,##0",
        width : "27.5%"
    }, {
        dataField: "ys",
        headerText: "YS",
        dataType : "numeric",
        formatString : "#,##0",
        width : "27.5%"
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

    var customerBdayColumnLayout = [
        {
            dataField: "bdate",
            headerText: "Date",
            width: "20%"
        },
        {
            dataField: "name",
            headerText: "Customer Name",
            width: "80%"
        },
        {
            dataField: "salesOrdNo",
            headerText: "Order No.",
            width: "30%"
        }
    ];

    var hpBdayColumnLayout = [
        {
            dataField: "dob",
            headerText: "Birthday",
            width: "20%"
        },
        {
            dataField: "fullName",
            headerText: "HP Name",
            width: "60%"
        },
        {
            dataField: "memCode",
            headerText: "HP Code",
            width: "30%"
        }];
    var rewardPointColumnLayout = [
          {dataField: "rptYear",headerText :"Year",width:120, height: 30, visible : false},
          {dataField: "orgCode",headerText :"Org Code",width:120, height: 30, visible : false},
          {dataField: "grpCode",headerText :"Grp Code",width:120, height: 30, visible : false},
          {dataField: "deptCode",headerText :"Dept Code",width:120, height: 30, visible : false},
          {dataField: "memCode",headerText :"Member Code",width:120, height: 30},
          {
              dataField: "",
              headerText: "Jan",
              children:
              [
                    {dataField: "nsM1",headerText :"Net Sales(Units)",width:120},
                    {dataField: "rpM1",headerText :"Reward Point",width:120},
              ],
              width: "20%",
              editable: false
          },
          {
              dataField: "",
              headerText: "Feb",
              children:
              [
                    {dataField: "nsM2",headerText :"Net Sales(Units)",width:120},
                    {dataField: "rpM2",headerText :"Reward Point",width:120},
              ],
              width: "20%",
              editable: false
          },{
              dataField: "",
              headerText: "Mar",
              children:
              [
                    {dataField: "nsM3",headerText :"Net Sales(Units)",width:120},
                    {dataField: "rpM3",headerText :"Reward Point",width:120},
              ],
              width: "20%",
              editable: false
          },{
              dataField: "",
              headerText: "Apr",
              children:
              [
                    {dataField: "nsM4",headerText :"Net Sales(Units)",width:120},
                    {dataField: "rpM4",headerText :"Reward Point",width:120},
              ],
              width: "20%",
              editable: false
          },{
              dataField: "",
              headerText: "May",
              children:
              [
                    {dataField: "nsM5",headerText :"Net Sales(Units)",width:120},
                    {dataField: "rpM5",headerText :"Reward Point",width:120},
              ],
              width: "20%",
              editable: false
          },{
              dataField: "",
              headerText: "Jun",
              children:
              [
                    {dataField: "nsM6",headerText :"Net Sales(Units)",width:120},
                    {dataField: "rpM6",headerText :"Reward Point",width:120},
              ],
              width: "20%",
              editable: false
          },{
              dataField: "",
              headerText: "Jul",
              children:
              [
                    {dataField: "nsM7",headerText :"Net Sales(Units)",width:120},
                    {dataField: "rpM7",headerText :"Reward Point",width:120},
              ],
              width: "20%",
              editable: false
          },{
              dataField: "",
              headerText: "Aug",
              children:
              [
                    {dataField: "nsM8",headerText :"Net Sales(Units)",width:120},
                    {dataField: "rpM8",headerText :"Reward Point",width:120},
              ],
              width: "20%",
              editable: false
          },{
              dataField: "",
              headerText: "Sep",
              children:
              [
                    {dataField: "nsM9",headerText :"Net Sales(Units)",width:120},
                    {dataField: "rpM9",headerText :"Reward Point",width:120},
              ],
              width: "20%",
              editable: false
          },{
              dataField: "",
              headerText: "Oct",
              children:
              [
                    {dataField: "nsM10",headerText :"Net Sales(Units)",width:120},
                    {dataField: "rpM10",headerText :"Reward Point",width:120},
              ],
              width: "20%",
              editable: false
          },{
              dataField: "",
              headerText: "Nov",
              children:
              [
                    {dataField: "nsM11",headerText :"Net Sales(Units)",width:120},
                    {dataField: "rpM11",headerText :"Reward Point",width:120},
              ],
              width: "20%",
              editable: false
          },{
              dataField: "",
              headerText: "Dec",
              children:
              [
                    {dataField: "nsM12",headerText :"Net Sales(Units)",width:120},
                    {dataField: "rpM12",headerText :"Reward Point",width:120},
              ],
              width: "20%",
              editable: false
          }
    ];

    var hpManagerBdayColumnLayout = [
          {dataField: "memLvl",headerText :"", visible: false},
          {dataField: "dob",headerText :"Birthday",width:"20%"},
          {dataField: "fullName",headerText :"HP Name",width:"60%"},
          {dataField: "memCode",headerText :"HP Code",width:"30%"}

     ];

    var auiGridProps = {
    		usePaging : false,
            showStateColumn : false,
            showRowNumColumn : false,
            pageRowCount : 4,
            headerHeight: 50,
            editable: true,
            fillValueGroupingSummary: true,
            groupingFields: ["memLvl", "header"],
/*             groupingSummary: {
            	dataFields: ["fullName"]
           }, */
            cellMergeRowSpan: true,
            displayTreeOpen: true,
            enableCellMerge: true,
            showBranchOnGrouping: false,

/*             rowStyleFunction: function (rowIndex, item) {
            	if (item._$isGroupSumField) {
            		switch (item._$depth) {
            		case 2:
            			return "aui-grid-row-depth1-style";
            		case 3:
            			return "aui-grid-row-depth2-style";
            		case 4:
            			return "aui-grid-row-depth3-style";
            		default:
            			return "aui-grid-row-depth-default-style";
            		}}
            	return null;
            } */
};



    //AUIGrid 생성 후 반환 ID
    var noticeGridID, detailGridID, statusCodeGridID, memoGridID, salesOrgPerfM, salesOrgPerfD, customerBdayGrid, hpBdayGrid, rewardPointGridID, hpManagerBdayGrid;

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

        var roleType, userId, userName, memLvl;

        Common.ajax("GET", "/login/getLoginDtls.do", {}, function (result) {
            console.log('result:: ',result);

            roleType = result.roleType;
            userId = result.userId;
            userName =  '${SESSION_INFO.userName}';
            memLvl =  '${SESSION_INFO.memberLevel}';


            if(result.userTypeId == 1) {
                $("#notice").remove();
                $("#noticeGrid").remove();

                $("#salesTable").css('border-top','0');

                var salesGridOption = {
                        usePaging : false,
                        showStateColumn : false,
                        showRowNumColumn : false,
                        pageRowCount : 4,
                        editable : false,
                        headerHeight : 50
                    };

                salesOrgPerfD = GridCommon.createAUIGrid("salesOrgPerfD", dailyPerfDashboard, null, salesGridOption);
                if (result.roleType == 111){
                    $('#custBdayTitle').hide();
                    $('#custBdayDiv').remove();


                     hpManagerBdayGrid = GridCommon.createAUIGrid("hpManagerBday", hpManagerBdayColumnLayout, null, auiGridProps);
                }
                else {
                	$('#hpManagerBdayDiv').remove();
/*                 	$('#hpManagerBdayTitle').hide();
 */
                    $('#custBdayTitle').show();
                    customerBdayGrid = GridCommon.createAUIGrid("salesOrgCustBday", customerBdayColumnLayout, null, salesGridOption);
                }

                if(result.roleType == 111 || result.roleType == 112 || result.roleType == 113 || result.roleType == 114) {
                    hpBdayGrid = GridCommon.createAUIGrid("salesOrgHPBday", hpBdayColumnLayout, null, salesGridOption);
                }
                else{
                    $('#hpBdayTitle').hide();
                }

                if(result.roleType == 115) {
                    console.log("else :: hpDashboard");
                    salesOrgPerfM = GridCommon.createAUIGrid("salesOrgPerfM", hpDashboard, null, salesGridOption);
                } else if(result.roleType == 111) {
                    console.log("else :: sgmDashboard");
                    salesOrgPerfM = GridCommon.createAUIGrid("salesOrgPerfM", sgmDashboard, null, salesGridOption);
                } else {
                    console.log("else :: salesManagerDashboard");
                    salesOrgPerfM = GridCommon.createAUIGrid("salesOrgPerfM", salesManagerDashboard, null, salesGridOption);
                }

                //AUIGrid.resize(salesOrgPerfM, 1200, 160);

                fn_selectSalesDashboard(userId, roleType);
                //fn_getCustomerBday(userId, roleType);

            } else {
                noticeGridID = GridCommon.createAUIGrid("noticeGrid", noticeLayout, null, gridOption);
                // 셀 더블클릭 이벤트 바인딩

                $("#salesOrg").remove();


                AUIGrid.bind(noticeGridID, "cellDoubleClick", function (event) {

                    var data = {
                        ntceNo: event.item.ntceNo
                    };
                    Common.popupDiv("/notice/readNoticePop.do", data, null, true, "readNoticePop");
                });

                fn_selectNoticeListAjax();
            }

            if(result.userTypeId == 1 || result.userTypeId == 2){
                //$("#memo").show();
                //memoGridID = GridCommon.createAUIGrid("memoGridID", memoColumnLayout, null, memoGridOption);
                //fn_selectMemoDashboard();

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
            }

            if(result.roleType == 114 || result.roleType == 115) {
                $("#dailyPerf").remove();
                $("#detailGrid").remove();
            } else {
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

                fn_selectDailyPerformanceListAjax();
            }

            if(result.userTypeId == 2 && memLvl == 4){
            	//$('#accRewardPoint').show();
            	//$('#accRewardPointHeader').html('Monthly Accumulated Reward Points - ' + (new Date().getFullYear() ) );

            	rpOption = {
            			usePaging: false,
                        showRowNumColumn: false, // 그리드 넘버링
                        //showStateColumn : false,
                        fixedColumnCount : 5,
            	}
            	rewardPointGridID = GridCommon.createAUIGrid("rewardPointGridID", rewardPointColumnLayout, null, rpOption);
            	//fn_selectAccRewardPoint(userName);
            }

            //  [Woongjin Jun] Tab
            tabs = $("#mainTabs").tabs();

            tabs.on("click", "span.ui-icon-close", function() {
                var panelId = $(this).closest("li").remove().attr("aria-controls");
                $("#" + panelId).remove();
                tabs.tabs("refresh");

                totTabCount--;

                if (totTabCount == 0) {
                    $("#content2").hide();
                    $("#content").show();

                    mainGridResize();
                }
            });

            $("#btnTabPrev").on("click", function() {
                if ($("#mainTabs").tabs("option", "active") > 0) {
                    $("#mainTabs").tabs("option", "active", ($("#mainTabs").tabs("option", "active") - 1));
                }
            });

            $("#btnTabNext").on("click", function() {
                if ($("#mainTabs").tabs("option", "active") < ($("#mainTabs").find("li").length - 1)) {
                    $("#mainTabs").tabs("option", "active", ($("#mainTabs").tabs("option", "active") + 1));
                }
            });

            // KR-JIN : Other tab close
            $("#btnTabOtherClose").on("click", function() {
                var current = $("#mainTabs").find(".ui-tabs-active>a").attr("href");
                var su = 0, curr = 0;
                $("#mainTabs").find("li").each(function() {
                	var that = $(this).find("a").attr("href");
                    if(current != that){
	                    var panelId = $(this).closest("li").remove().attr("aria-controls");
	                    $("#" + panelId).remove();
	                    tabs.tabs("refresh");
	                    su++;
                    }else{
                    	curr++;
                    }
                });

                totTabCount = curr;
                if(totTabCount == 0){
                    $("#content2").hide();
                    $("#content").show();
                    mainGridResize();
                }
            });

            $("#btnTabAllClose").on("click", function() {
                $("#mainTabs").find("li").each(function() {
                    var panelId = $(this).closest("li").remove().attr("aria-controls");
                    $("#" + panelId).remove();
                    tabs.tabs("refresh");
                });

                totTabCount = 0;

                $("#content2").hide();
                $("#content").show();

                mainGridResize();
            });
            // [Woongjin Jun] Tab
        });

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

    });   //$(document).ready

    function mainGridResize() {
    	if (typeof noticeGridID != "undefined") {
    		AUIGrid.resize(noticeGridID, null, 132);
    	}

    	if (typeof detailGridID != "undefined") {
            AUIGrid.resize(detailGridID, null, 210);
        }

    	if (typeof memoGridID != "undefined") {
            AUIGrid.resize(memoGridID, null, 210);
        }

    	if (typeof salesOrgPerfM != "undefined") {
            AUIGrid.resize(salesOrgPerfM, null, 160);
        }

    	if (typeof salesOrgPerfD != "undefined") {
            AUIGrid.resize(salesOrgPerfD, null, 160);
        }
    }

    // 리스트 조회.
    function fn_selectNoticeListAjax() {
        Common.ajax("GET", "/common/getMainNotice.do", {}, function (result) {
            AUIGrid.setGridData(noticeGridID, result);
        });
    }

    function fn_selectSalesDashboard(userId, userRole) {
        Common.ajax("GET", "/common/getSalesOrgPerf.do", {}, function (result) {
            AUIGrid.setGridData(salesOrgPerfM, result);
            AUIGrid.setGridData(salesOrgPerfD, result);
console.log(result);
            AUIGrid.setProp(salesOrgPerfM, "rowStyleFunction", function(rowIndex, item) {;
                if(item.period == "CURRENT") {
                    return "my-row-style";
                } else {
                    return "";
                }
            });
            AUIGrid.update(salesOrgPerfM);

            AUIGrid.setProp(salesOrgPerfD, "rowStyleFunction", function(rowIndex, item) {
                if(item.period == "CURRENT") {
                    return "my-row-style";
                } else {
                    return "";
                }
            });
            AUIGrid.update(salesOrgPerfD);

            if(userRole != 111){
            	Common.ajax("GET", "/common/getCustomerBday.do", {userId : userId, roleId : userRole}, function(result1) {
            		console.log("fn_getCustomerBday");
            		console.log(result1);
            		AUIGrid.setGridData(customerBdayGrid, result1);
            	});
            }


			if(userRole == 111 || userRole == 112 || userRole == 113 || userRole == 114) {
                Common.ajax("GET", "/common/getHPBirthday.do", {userId : userId, roleId : userRole, isHmBday : "false"}, function(result2) {
                    console.log(result2);
                    AUIGrid.setGridData(hpBdayGrid, result2);
                });
            }
        });


        if(userRole == 111) {
           console.log("Manager Bday");

           Common.ajax("GET", "/common/getHPBirthday.do", {userId : userId, roleId : userRole, isHmBday : "true"}, function(result3) {

               for(var i = 0; i < headers.length; i++) {
                   var item = headers[i];
                    result3.push(item);
                    console.log('new item', item);
               }

               AUIGrid.setGridData(hpManagerBdayGrid, result3);
               AUIGrid.setProp(hpManagerBdayGrid, "rowStyleFunction", function(rowIndex, item) {
                   if(item.header == "1") {
                       return "my-row-style-2";
                   } else {
                       return "";
                   }
               });
               AUIGrid.update(hpManagerBdayGrid);
           });

          }
    }

    function fn_selectMemoDashboard() {
        Common.ajax("POST", "/logistics/memorandum/memoSearchList.do", {}, function (result) {
            AUIGrid.setGridData(memoGridID, result.data);
        });
    }

    function fn_selectAccRewardPoint(userName) {
        Common.ajax("GET", "/common/getAccRewardPoints.do", {userName : userName}, function (result) {
            AUIGrid.setGridData(rewardPointGridID, result);
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
	if( (( '${SESSION_INFO.memberLevel}'== 1 || '${SESSION_INFO.memberLevel}'== 0) && ( '${SESSION_INFO.userTypeId}'== 1 ||  '${SESSION_INFO.userTypeId}'== 2)) || ( '${SESSION_INFO.userTypeId}' == 4) ){
        Common.ajax("GET", "/common/getDailyPerformance.do", {}, function (result) {
            AUIGrid.setGridData(detailGridID, result);
        });
}else{
	 $("#dailyPerf").remove();
	 $("#detailGrid").remove();
}
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

    .my-row-style {
    background:#fff64c;
    color:#f7ea00;
}

    .my-row-style-2 {
    background:#75c6ff;
    color:#addeff;
}
</style>
<!-- [Woongjin Jun] Tab -->
<section id="content2" style="width: 100%; height: auto; border: 1px; color: black; display: none; overflow-x: hidden; overflow-y: auto;">
    <div id="mainTabs" style="width: 100%; height: auto; border: 1px; color: black;">
        <ul id="mainTabTitle" style="padding-right: 300px;">
            <div style="position: absolute; top: 15px; right: 270px;"><a href="javascript:;" id="btnTabPrev" class="ui-state-default" style="padding:3px 10px; font-weight:bold;">&lt;</a></div>
            <div style="position: absolute; top: 15px; right: 232px;"><a href="javascript:;" id="btnTabNext" class="ui-state-default" style="padding:3px 10px; font-weight:bold;">&gt;</a></div>
            <div style="position: absolute; top: 15px; right: 133px;"><a href="javascript:;" id="btnTabAllClose" class="ui-state-default" style="padding:3px 10px; font-weight:bold;">Close All X</a></div>
            <div style="position: absolute; top: 15px; right:  15px;"><a href="javascript:;" id="btnTabOtherClose" class="ui-state-default" style="padding:3px 10px; font-weight:bold;">Other Close X</a></div>
        </ul>
    </div>
</section>
<!-- [Woongjin Jun] Tab -->

<!-- [Woongjin Jun] Tab Style Display -->
<section id="content" style="display:;"><!-- content start -->

    <aside  id="notice" class="title_line main_title"><!-- title_line start -->
        <h2><spring:message code='sys.label.notice'/></h2>
        <%-- <p class="more" id="moreNotice"><a href="${pageContext.request.contextPath}/notice/noticeList.do"><spring:message code='sys.label.more'/> ></a></p> --%>
        <p class="more" id="moreNotice" ><a href="#"  onclick="javascript:fn_menu(this, 'SYS10060100', '/notice/noticeList.do', '|!|System|!|Notice|!|Notice List', '', 'Notice List', '', '', '', '', '', '');"><spring:message code='sys.label.more'/> ></a> </p>

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

        <div id="salesOrg" class="divine_auto">
            <div style="width:50%">
                <aside class="title_line">
                    <h2>Sales Organization Performance</h2>
                </aside>

                <div id="salesOrgPerfM" class="grid_wrap" style="width: 100%; height:160px; margin: 0 auto;"></div>
            </div>

            <div style="width:25%">
                <aside class="title_line">
                    <h2>Daily Organization Performance</h2>
                </aside>

                <div id="salesOrgPerfD" class="grid_wrap" style="width: 100%; height:160px; margin: 0 auto;"></div>
            </div>

            <div style="width:25%">
                <aside class="title_line">
                    <h2>Birthday Information</h2>
                </aside>
                <div id="custBdayDiv">
                <aside class="title_line">
                    <h4 id="custBdayTitle">Customer Birthday</h4>
                </aside>
                <div id="salesOrgCustBday" class="grid_wrap" style="width: 100%; height:160px; margin: 0 auto;"></div>
                </div>

<!--  START HERE  -->
                <div id="hpManagerBdayDiv">
                <aside class="title_line">
                <h4 id="hpManagerBdayTitle">Manager Birthday</h4>
                </aside>
                <div id="hpManagerBday" class="grid_wrap" style="width: 100%; height:160px; margin: 0 auto;"></div>
                </div>
 <!--  ENDS HERE -->

                 <aside class="title_line">
                 <h4 id="hpBdayTitle">HP Birthday</h4>
                </aside>
                <div id="salesOrgHPBday" class="grid_wrap" style="width: 100%; height:160px; margin: 0 auto;"></div>


        </div>
        </div>


        <aside id="dailyPerf"class="title_line main_title mt30"><!-- title_line start -->
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

        <aside id="accRewardPoint" class="title_line main_title mt30" style="display:none;">
            <h2 id='accRewardPointHeader'></h2>
        </aside>

        <article class="grid_wrap">
             <div id="rewardPointGridID" style="height:100px;"></div>
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
