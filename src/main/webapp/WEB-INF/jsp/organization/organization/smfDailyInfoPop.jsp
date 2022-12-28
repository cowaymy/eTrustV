<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">

var salesOrgSummaryList, salesOrgWeeklyList,salesOrgDailyList1,salesOrgDailyList2,salesOrgDailyList2a,salesOrgDailyList2b,salesOrgDailyList2c,salesOrgDailyList3,salesOrgDailyList4;

var previous3month = getMonthName('${month}'-3), previous2month = getMonthName('${month}'-2), previousmonth = getMonthName('${month}'-1), currentmonth =getMonthName('${month}');
var year =  new Date().getFullYear();

function getMonthName(monthNumber) {
	  const date = new Date();
	  date.setMonth(monthNumber - 1);
	  return date.toLocaleString('en-US', { month: 'long' });
}


const currentM_ex = getDaysInMonth(year, '${month}'-1);
const currentM = getDaysInMonth(year, '${month}');


function getDaysInMonth(year, month) {
  return new Date(year, month, 0).getDate();
}


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
	dataField: "day1",
	headerText: "1",
	width : "8%"
	}
   ,{
	 dataField: "day2",
	 headerText: "2",
	 width : "8%"
	}
   ,{
	  dataField: "day3",
	  headerText: "3",
	  width : "8%"
	}
   ,{
	   dataField: "day4",
	   headerText: "4",
	   width : "8%"
	}
   ,{
       dataField: "day5",
       headerText: "5",
       width : "8%"
    }
   ,{
       dataField: "day6",
       headerText: "6",
       width : "8%"
    }
   ,{
       dataField: "day7",
       headerText: "7",
       width : "8%"
    }
   ,{
       dataField: "day8",
       headerText: "8",
       width : "8%"
    }
   ,{
       dataField: "day9",
       headerText: "9",
       width : "8%"
    }
   ,{
       dataField: "day10",
       headerText: "10",
       width : "8%"
    }
   ,{
       dataField: "day11",
       headerText: "11",
       width : "8%"
    }
   ,{
       dataField: "day12",
       headerText: "12",
       width : "8%"
    }
   ,{
       dataField: "day13",
       headerText: "13",
       width : "8%"
    }
   ,{
       dataField: "day14",
       headerText: "14",
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
       dataField: "day15",
       headerText: "15",
       width : "8%"
    }
   ,{
       dataField: "day16",
       headerText: "16",
       width : "8%"
    }
   ,{
    dataField: "day17",
    headerText: "17",
    width : "8%"
    }
   ,{
     dataField: "day18",
     headerText: "18",
     width : "8%"
    }
   ,{
      dataField: "day19",
      headerText: "19",
      width : "8%"
    }
   ,{
       dataField: "day20",
       headerText: "20",
       width : "8%"
    }
   ,{
       dataField: "day21",
       headerText: "21",
       width : "8%"
    }
   ,{
       dataField: "day22",
       headerText: "22",
       width : "8%"
    }
   ,{
       dataField: "day23",
       headerText: "23",
       width : "8%"
    }
   ,{
       dataField: "day24",
       headerText: "24",
       width : "8%"
    }
   ,{
       dataField: "day25",
       headerText: "25",
       width : "8%"
    }
   ,{
       dataField: "day26",
       headerText: "26",
       width : "8%"
    }
   ,{
       dataField: "day27",
       headerText: "27",
       width : "8%"
    }
   ,{
       dataField: "day28",
       headerText: "28",
       width : "8%"
    }

];

var salesDailyDashboard_2a = [
   {
 	    dataField: "codeName",
 	    headerText: currentmonth,
 	    width : "10%"
  },
  {
    dataField: "day29",
    headerText: "29",
    width : "8%"
 }
];

var salesDailyDashboard_2b = [
   {
       dataField: "codeName",
       headerText: currentmonth,
       width : "10%"
 },
  {
    dataField: "day29",
    headerText: "29",
    width : "8%"
 }
,{
    dataField: "day30",
    headerText: "30",
    width : "8%"
 }
];

var salesDailyDashboard_2c = [
   {
       dataField: "codeName",
       headerText: currentmonth,
       width : "10%"
 },
  {
    dataField: "day29",
    headerText: "29",
    width : "8%"
 }
,{
    dataField: "day30",
    headerText: "30",
    width : "8%"
 }
,{
    dataField: "day31",
    headerText: "31",
    width : "8%"
 }
];

var salesDailyDashboard_3 = [
   {
    dataField: "codeName",
    headerText: previousmonth,
    width : "10%"
    }
   ,{
    dataField: "day1",
    headerText: "1",
    width : "8%"
    }
   ,{
     dataField: "day2",
     headerText: "2",
     width : "8%"
    }
   ,{
      dataField: "day3",
      headerText: "3",
      width : "8%"
    }
   ,{
       dataField: "day4",
       headerText: "4",
       width : "8%"
    }
   ,{
       dataField: "day5",
       headerText: "5",
       width : "8%"
    }
   ,{
       dataField: "day6",
       headerText: "6",
       width : "8%"
    }
   ,{
       dataField: "day7",
       headerText: "7",
       width : "8%"
    }
   ,{
       dataField: "day8",
       headerText: "8",
       width : "8%"
    }
   ,{
       dataField: "day9",
       headerText: "9",
       width : "8%"
    }
   ,{
       dataField: "day10",
       headerText: "10",
       width : "8%"
    }
   ,{
       dataField: "day11",
       headerText: "11",
       width : "8%"
    }
   ,{
       dataField: "day12",
       headerText: "12",
       width : "8%"
    }
   ,{
       dataField: "day13",
       headerText: "13",
       width : "8%"
    }
   ,{
       dataField: "day14",
       headerText: "14",
       width : "8%"
    }

];

var salesDailyDashboard_4 = [

   {
    dataField: "codeName",
    headerText: previousmonth,
    width : "10%"
    }
   ,{
       dataField: "day15",
       headerText: "15",
       width : "8%"
    }
   ,{
       dataField: "day16",
       headerText: "16",
       width : "8%"
    }
   ,{
    dataField: "day17",
    headerText: "17",
    width : "8%"
    }
   ,{
     dataField: "day18",
     headerText: "18",
     width : "8%"
    }
   ,{
      dataField: "day19",
      headerText: "19",
      width : "8%"
    }
   ,{
       dataField: "day20",
       headerText: "20",
       width : "8%"
    }
   ,{
       dataField: "day21",
       headerText: "21",
       width : "8%"
    }
   ,{
       dataField: "day22",
       headerText: "22",
       width : "8%"
    }
   ,{
       dataField: "day23",
       headerText: "23",
       width : "8%"
    }
   ,{
       dataField: "day24",
       headerText: "24",
       width : "8%"
    }
   ,{
       dataField: "day25",
       headerText: "25",
       width : "8%"
    }
   ,{
       dataField: "day26",
       headerText: "26",
       width : "8%"
    }
   ,{
       dataField: "day27",
       headerText: "27",
       width : "8%"
    }
   ,{
       dataField: "day28",
       headerText: "28",
       width : "8%"
    }

];

var salesDailyDashboard_4a = [
   {
        dataField: "codeName",
        headerText: previousmonth,
        width : "10%"
  },
  {
    dataField: "day29",
    headerText: "29",
    width : "8%"
 }
];

var salesDailyDashboard_4b = [
   {
       dataField: "codeName",
       headerText: previousmonth,
       width : "10%"
 },
  {
    dataField: "day29",
    headerText: "29",
    width : "8%"
 }
,{
    dataField: "day30",
    headerText: "30",
    width : "8%"
 }
];

var salesDailyDashboard_4c = [
   {
       dataField: "codeName",
       headerText: previousmonth,
       width : "10%"
 },
  {
    dataField: "day29",
    headerText: "29",
    width : "8%"
 }
,{
    dataField: "day30",
    headerText: "30",
    width : "8%"
 }
,{
    dataField: "day31",
    headerText: "31",
    width : "8%"
 }
];



$(document).ready(function () {
    $(".bottom_msg_box").attr("style","display:none");
    /***********************************************[ NOTICE GRID] ************************************************/

    var roleType, userId, userName, memLvl;

    Common.ajax("GET", "/login/getLoginDtls.do", {}, function (result) {

    $('#userType').val(result.userTypeId);
    $('#roleType').val(result.roleType);

    var salesGridOption = {
            usePaging : false,
            showStateColumn : false,
            showRowNumColumn : false,
            pageRowCount : 4,
            editable : false,
            headerHeight : 50
        };

                salesOrgWeeklyList = GridCommon.createAUIGrid("salesOrgWeeklyList", salesWeeklyDashboard, null, salesGridOption);
                salesOrgDailyList1 = GridCommon.createAUIGrid("salesOrgDailyList1", salesDailyDashboard_1, null, salesGridOption);
                salesOrgDailyList2 = GridCommon.createAUIGrid("salesOrgDailyList2", salesDailyDashboard_2, null, salesGridOption);

                switch(currentM) {
                case 29:
                	 salesOrgDailyList2a = GridCommon.createAUIGrid("salesOrgDailyList2a", salesDailyDashboard_2a, null, salesGridOption);
                  break;
                case 30:
                	 salesOrgDailyList2a = GridCommon.createAUIGrid("salesOrgDailyList2a", salesDailyDashboard_2b, null, salesGridOption);
                  break;
                default:
                	 salesOrgDailyList2a = GridCommon.createAUIGrid("salesOrgDailyList2a", salesDailyDashboard_2c, null, salesGridOption);
                }

                salesOrgDailyList3 = GridCommon.createAUIGrid("salesOrgDailyList3", salesDailyDashboard_3, null, salesGridOption);
                salesOrgDailyList4 = GridCommon.createAUIGrid("salesOrgDailyList4", salesDailyDashboard_4, null, salesGridOption);

                switch(currentM_ex) {
                case 29:
                     salesOrgDailyList4a = GridCommon.createAUIGrid("salesOrgDailyList4a", salesDailyDashboard_4a, null, salesGridOption);
                  break;
                case 30:
                	salesOrgDailyList4a = GridCommon.createAUIGrid("salesOrgDailyList4a", salesDailyDashboard_4b, null, salesGridOption);
                  break;
                default:
                	salesOrgDailyList4a = GridCommon.createAUIGrid("salesOrgDailyList4a", salesDailyDashboard_4c, null, salesGridOption);
                }

                fn_selectWeeklyDashboard() ;
                fn_selectCurrentMonthDailyDashboard() ;
                fn_selectPreviousMonthDailyDashboard() ;

     });
    });   //$(document).ready

    function fn_selectWeeklyDashboard() {

	      var params_weekly ={
	    		  memCode:'${memCode}',
	    		  currentYm : '${currentYm}',
                  previousYm : '${previousYm}',
                  previousYm2 : '${previousYm2}',
                  previousYm3 : '${previousYm3}'
	       };
          Common.ajax("GET", "/organization/selectWeekSalesListing.do", params_weekly , function (result) {
                AUIGrid.setGridData(salesOrgWeeklyList, result);
          });
    }

    function fn_selectCurrentMonthDailyDashboard() {
        var params_currentM ={
                orgCode : '${orgCode}',
                grpCode : '${grpCode}',
                deptCode : '${deptCode}',
                current : 1,
                position : '${position}',
                memCode : '${memCode}',
                currentYm :  '${currentYm}'
      };

   	  Common.ajax("GET", "/organization/selectSmfDailyListing.do", params_currentM, function (result3) {
             AUIGrid.setGridData(salesOrgDailyList1, result3);
             AUIGrid.setGridData(salesOrgDailyList2, result3);
             AUIGrid.setGridData(salesOrgDailyList2a, result3);

         });
    }

    function fn_selectPreviousMonthDailyDashboard() {
    	 var params_previousM ={
    		 orgCode : '${orgCode}',
    		 grpCode : '${grpCode}',
    		 deptCode : '${deptCode}',
    		 current : 0,
    		 position: '${position}',
    		 memCode: '${memCode}',
    		 currentYm: '${previousYm}'
    	 };
         Common.ajax("GET", "/organization/selectSmfDailyListing.do", params_previousM, function (result3) {
                  AUIGrid.setGridData(salesOrgDailyList3, result3);
                  AUIGrid.setGridData(salesOrgDailyList4, result3);
                  AUIGrid.setGridData(salesOrgDailyList4a, result3);
         });
   }

</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Daily Info (${memCode})</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#"><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->


<section class="pop_body">
  <!-- pop_body start -->

 <div id="salesOrgWeeklyList" class="grid_wrap" style="width: 100%; height:300px; margin: 0 auto;"></div>

 <div id="salesOrgDailyList1" class="grid_wrap" style="width: 100%; height:300px; margin: 0 auto;"></div>

 <div id="salesOrgDailyList2" class="grid_wrap" style="width: 100%; height:300px; margin: 0 auto;"></div>

 <div id="salesOrgDailyList2a" class="grid_wrap" style="width: 100%; height:300px; margin: 0 auto;"></div>

  <div id="salesOrgDailyList3" class="grid_wrap" style="width: 100%; height:300px; margin: 0 auto;"></div>

 <div id="salesOrgDailyList4" class="grid_wrap" style="width: 100%; height:300px; margin: 0 auto;"></div>

 <div id="salesOrgDailyList4a" class="grid_wrap" style="width: 100%; height:300px; margin: 0 auto;"></div>
 </section>


</div><!-- popup_wrap end -->