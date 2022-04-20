<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">

var salesOrgSummaryList, salesOrgWeeklyList,salesOrgDailyList1,salesOrgDailyList2;

var previous3month = new Date(), previous2month = new Date(), previousmonth = new Date(), currentmonth = new Date();

previous3month.setMonth(previous3month.getMonth()-3);
previous3month = previous3month.toLocaleString('default', { month: 'long' });

previous2month.setMonth(previous2month.getMonth()-2);
previous2month = previous2month.toLocaleString('default', { month: 'long' });

previousmonth.setMonth(previousmonth.getMonth()-1);
previousmonth = previousmonth.toLocaleString('default', { month: 'long' });

currentmonth.setMonth(currentmonth.getMonth());
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
];

var salesDailyDashboard_2 = [
   {
    dataField: "codeName",
    headerText: currentmonth,
    width : "10%"
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
   ,{
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

    var salesGridOption = {
            usePaging : false,
            showStateColumn : false,
            showRowNumColumn : false,
            pageRowCount : 4,
            editable : false,
            headerHeight : 50
        };

        if(result.userTypeId == 1) {
        	$("#smfDailyForm").hide();

            salesOrgWeeklyList = GridCommon.createAUIGrid("salesOrgWeeklyList", salesWeeklyDashboard, null, salesGridOption);
            fn_selectWeeklyDashboard() ;

            salesOrgDailyList1 = GridCommon.createAUIGrid("salesOrgDailyList1", salesDailyDashboard_1, null, salesGridOption);
            salesOrgDailyList2 = GridCommon.createAUIGrid("salesOrgDailyList2", salesDailyDashboard_2, null, salesGridOption);
            fn_selectDailyDashboard() ;
        }
        else if(result.userTypeId == 4) {
        	$("#smfDailyForm").show();

        	  salesOrgWeeklyList = GridCommon.createAUIGrid("salesOrgWeeklyList", salesWeeklyDashboard, null, salesGridOption);
        	  salesOrgDailyList1 = GridCommon.createAUIGrid("salesOrgDailyList1", salesDailyDashboard_1, null, salesGridOption);
              salesOrgDailyList2 = GridCommon.createAUIGrid("salesOrgDailyList2", salesDailyDashboard_2, null, salesGridOption);
        }

     });
    });   //$(document).ready


    function fn_selectWeeklyDashboard() {
        Common.ajax("GET", "/organization/selectWeekSalesListing.do", $("#smfDailyForm").serialize(), function (result) {
        AUIGrid.setGridData(salesOrgWeeklyList, result);
     });
    }

    function fn_selectDailyDashboard() {
    	 if($('#userType').val() == 1) {
    	        Common.ajax("GET", "/organization/selectSmfDailyListing.do", {orgCode : '${orgCode}', grpCode : '${grpCode}', deptCode:'${deptCode}'}, function (result) {
    	        AUIGrid.setGridData(salesOrgDailyList1, result);
    	        AUIGrid.setGridData(salesOrgDailyList2, result);
    	     });
    	 }
    	 else if($('#userType').val() == 4) {
    		 Common.ajax("GET", "/organization/selectSimulatedMemberCRSCode.do",  $("#smfDailyForm").serialize(), function (result) {
                 Common.ajax("GET", "/organization/selectSmfDailyListing.do", {orgCode : result[0].orgCode, grpCode : result[0].grpCode, deptCode: result[0].deptCode}, function (result2) {
                	 AUIGrid.setGridData(salesOrgDailyList1, result2);
                     AUIGrid.setGridData(salesOrgDailyList2, result2);
                   });
    		 });
    	 }
    }


    $(function() {
         $('#btnSrchDailyInfo').click(function() {
        	 fn_selectWeeklyDashboard();
        	 fn_selectDailyDashboard();
          });
      });


</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Daily Info</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#"><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->


<section class="pop_body">
  <!-- pop_body start -->
  <section class="search_table">
   <!-- search_table start -->
   <form action="#" method="post" id="smfDailyForm">
    <input type="hidden" id="userType" name="userType" />
   <aside class="title_line"><!-- title_line start -->
    <ul class="right_btns">
    <li><p class="btn_blue"><a id="btnSrchDailyInfo" href="#"><span class="search"></span>Search</a></p></li>
    </ul>
    </aside>
    <table class="type1">
     <!-- table start -->
     <tbody>
    <tr>
    <th scope="row">Simulate Member Code</th>
    <td><input id="memCode" name="memCode" type="text" title="memCode"  class="w100p" value = '${SESSION_INFO.userName}'.trim() /></td>
    </tr>
     </tbody>
    </table>
    <!-- table end -->
   </form>
  </section>

  <div id="salesOrgWeeklyList" class="grid_wrap" style="width: 100%; height:300px; margin: 0 auto;"></div>

 <div id="salesOrgDailyList1" class="grid_wrap" style="width: 100%; height:300px; margin: 0 auto;"></div>

 <div id="salesOrgDailyList2" class="grid_wrap" style="width: 100%; height:300px; margin: 0 auto;"></div>
 </section>


</div><!-- popup_wrap end -->