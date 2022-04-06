<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">

var salesOrgSummaryList, salesOrgWeeklyList,salesOrgDailyList1,salesOrgDailyList2;

var previous3month = new Date(), previous2month = new Date(), previousmonth = new Date(), currentmonth = new Date();

previous3month.setMonth(previous3month.getMonth()-5);
previous3month = previous3month.toLocaleString('default', { month: 'long' });

previous2month.setMonth(previous2month.getMonth()-4);
previous2month = previous2month.toLocaleString('default', { month: 'long' });

previousmonth.setMonth(previousmonth.getMonth()-3);
previousmonth = previousmonth.toLocaleString('default', { month: 'long' });

currentmonth.setMonth(currentmonth.getMonth()-2);
currentmonth = currentmonth.toLocaleString('default', { month: 'long' });


var salesWeeklyDashboard = [{
    dataField: "codeName",
    headerText: "Index",
    width : "20%"
    }, {
    headerText: previous3month,
    width : "20%",
    children:
        [
            {
                dataField: "aW1",
                headerText: "W1",
                width: "5%",
                editable: false
            },
            {
                dataField: "aW2",
                headerText: "W2",
                width: "5%",
                editable: false
            },
            {
                dataField: "aW3",
                headerText: "W3",
                width: "5%",
                editable: false
            },
            {
                dataField: "aW4",
                headerText: "W4",
                width: "5%",
                editable: false
            }
       ]
    }, {
    headerText: previous2month,
    dataType : "numeric",
    width : "20%",
    children:
        [
            {
                dataField: "bW1",
                headerText: "W1",
                width: "5%",
                editable: false
            },
            {
                dataField: "bW2",
                headerText: "W2",
                width: "5%",
                editable: false
            },
            {
                dataField: "bW3",
                headerText: "W3",
                width: "5%",
                editable: false
            },
            {
                dataField: "bW4",
                headerText: "W4",
                width: "5%",
                editable: false
            }
       ]
}, {
    dataField: "",
    headerText: previousmonth,
    dataType : "numeric",
    width : "20%",
    children:
        [
            {
                dataField: "cW1",
                headerText: "W1",
                width: "5%",
                editable: false
            },
            {
                dataField: "cW2",
                headerText: "W2",
                width: "5%",
                editable: false
            },
            {
                dataField: "cW3",
                headerText: "W3",
                width: "5%",
                editable: false
            },
            {
                dataField: "cW4",
                headerText: "W4",
                width: "5%",
                editable: false
            }
       ]
}, {
    headerText: currentmonth,
    dataType : "numeric",
    width : "20%",
    children:
        [
            {
                dataField: "dW1",
                headerText: "W1",
                width: "5%",
                editable: false
            },
            {
                dataField: "dW2",
                headerText: "W2",
                width: "5%",
                editable: false
            },
            {
                dataField: "dW3",
                headerText: "W3",
                width: "5%",
                editable: false
            },
            {
                dataField: "dW4",
                headerText: "W4",
                width: "5%",
                editable: false
            }
       ]
}];


var salesDailyDashboard_1 = [
   {
    dataField: "codeName",
    headerText: currentmonth,
    width : "10%"
    }
   ,{
	dataField: "1",
	headerText: "1",
	width : "8%"
	}
   ,{
	 dataField: "2",
	 headerText: "2",
	 width : "8%"
	}
   ,{
	  dataField: "3",
	  headerText: "3",
	  width : "8%"
	}
   ,{
	   dataField: "4",
	   headerText: "4",
	   width : "8%"
	}
   ,{
       dataField: "5",
       headerText: "5",
       width : "8%"
    }
   ,{
       dataField: "6",
       headerText: "6",
       width : "8%"
    }
   ,{
       dataField: "7",
       headerText: "7",
       width : "8%"
    }
   ,{
       dataField: "8",
       headerText: "8",
       width : "8%"
    }
   ,{
       dataField: "9",
       headerText: "9",
       width : "8%"
    }
   ,{
       dataField: "10",
       headerText: "10",
       width : "8%"
    }
   ,{
       dataField: "11",
       headerText: "11",
       width : "8%"
    }
   ,{
       dataField: "12",
       headerText: "12",
       width : "8%"
    }
   ,{
       dataField: "13",
       headerText: "13",
       width : "8%"
    }
   ,{
       dataField: "14",
       headerText: "14",
       width : "8%"
    }
   ,{
       dataField: "15",
       headerText: "15",
       width : "8%"
    }
   ,{
       dataField: "16",
       headerText: "16",
       width : "8%"
    }
];

var salesDailyDashboard_2 = [
                             {
                              dataField: "codeName",
                              headerText: currentmonth,
                              width : "10%"
                              }
                             ,{
                              dataField: "17",
                              headerText: "17",
                              width : "8%"
                              }
                             ,{
                               dataField: "18",
                               headerText: "18",
                               width : "8%"
                              }
                             ,{
                                dataField: "19",
                                headerText: "19",
                                width : "8%"
                              }
                             ,{
                                 dataField: "20",
                                 headerText: "20",
                                 width : "8%"
                              }
                             ,{
                                 dataField: "21",
                                 headerText: "21",
                                 width : "8%"
                              }
                             ,{
                                 dataField: "22",
                                 headerText: "22",
                                 width : "8%"
                              }
                             ,{
                                 dataField: "23",
                                 headerText: "23",
                                 width : "8%"
                              }
                             ,{
                                 dataField: "24",
                                 headerText: "24",
                                 width : "8%"
                              }
                             ,{
                                 dataField: "25",
                                 headerText: "25",
                                 width : "8%"
                              }
                             ,{
                                 dataField: "26",
                                 headerText: "26",
                                 width : "8%"
                              }
                             ,{
                                 dataField: "27",
                                 headerText: "27",
                                 width : "8%"
                              }
                             ,{
                                 dataField: "28",
                                 headerText: "28",
                                 width : "8%"
                              }
                             ,{
                                 dataField: "29",
                                 headerText: "29",
                                 width : "8%"
                              }
                             ,{
                                 dataField: "30",
                                 headerText: "30",
                                 width : "8%"
                              }
                             ,{
                                 dataField: "31",
                                 headerText: "31",
                                 width : "8%"
                              }
                          ];


$(document).ready(function () {
    $(".bottom_msg_box").attr("style","display:none");
    /***********************************************[ NOTICE GRID] ************************************************/

    var roleType, userId, userName, memLvl;

    Common.ajax("GET", "/login/getLoginDtls.do", {}, function (result) {
    console.log(result);


        roleType = result.roleType;
        userId = result.userId;
        userName =  '${SESSION_INFO.userName}';
        memLvl =  '${SESSION_INFO.memberLevel}';



        if(result.userTypeId == 1) {

            $("#salesTable").css('border-top','0');

            var salesGridOption = {
                    usePaging : false,
                    showStateColumn : false,
                    showRowNumColumn : false,
                    pageRowCount : 4,
                    editable : false,
                    headerHeight : 50
                };

            salesOrgWeeklyList = GridCommon.createAUIGrid("salesOrgWeeklyList", salesWeeklyDashboard, null, salesGridOption);
            fn_selectWeeklyDashboard() ;

            salesOrgDailyList1 = GridCommon.createAUIGrid("salesOrgDailyList1", salesDailyDashboard_1, null, salesGridOption);
            salesOrgDailyList2 = GridCommon.createAUIGrid("salesOrgDailyList2", salesDailyDashboard_2, null, salesGridOption);
            fn_selectDailyDashboard() ;
        }
     });
    });   //$(document).ready


    function fn_selectWeeklyDashboard() {
        Common.ajax("GET", "/organization/selectWeekSalesListing.do", {memCode :  '${SESSION_INFO.userName}'}, function (result) {
        AUIGrid.setGridData(salesOrgWeeklyList, result);
     });
    }

    function fn_selectDailyDashboard() {
        Common.ajax("GET", "/organization/selectSmfDailyListing.do", {orgCode : '${orgCode}', grpCode : '${grpCode}', deptCode:'${deptCode}'}, function (result) {
        AUIGrid.setGridData(salesOrgDailyList1, result);
        AUIGrid.setGridData(salesOrgDailyList2, result);
     });
    }








</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Daily Info</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#"><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section>
 <div id="salesOrgWeeklyList" class="grid_wrap" style="width: 100%; height:300px; margin: 0 auto;"></div>
</section>

<section>
 <div id="salesOrgDailyList1" class="grid_wrap" style="width: 100%; height:300px; margin: 0 auto;"></div>
</section>

<section>
 <div id="salesOrgDailyList2" class="grid_wrap" style="width: 100%; height:300px; margin: 0 auto;"></div>
</section>



</div><!-- popup_wrap end -->