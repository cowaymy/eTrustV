
<script type="text/javaScript">

    var salesOrgSummaryList, salesOrgWeeklyList;

    var previous3month = new Date(), previous2month = new Date(), previousmonth = new Date(), currentmonth = new Date();

    previous3month.setMonth(previous3month.getMonth()-3);
    previous3month = previous3month.toLocaleString('default', { month: 'long' });

    previous2month.setMonth(previous2month.getMonth()-2);
    previous2month = previous2month.toLocaleString('default', { month: 'long' });

    previousmonth.setMonth(previousmonth.getMonth()-1);
    previousmonth = previousmonth.toLocaleString('default', { month: 'long' });

    currentmonth.setMonth(currentmonth.getMonth());
    currentmonth = currentmonth.toLocaleString('default', { month: 'long' });


	var salesSummaryDashboard = [{
	    dataField: "codeName",
	    headerText: "Index",
	    width : "20%"
	    }, {
	    headerText: previous3month,
	    width : "20%",
	    children:
            [
                {
                    dataField: "a",
                    headerText: "Result",
                    width: "10%",
                    editable: false
                }]
	    }, {
	    headerText: previous2month,
	    dataType : "numeric",
	    width : "20%",
	    children:
            [
                {
                    dataField: "b",
                    headerText: "Result",
                    width: "10%",
                    editable: false
                }]
	    }, {
	    dataField: "",
	    headerText: previousmonth,
	    dataType : "numeric",
	    width : "20%",
	    children:
            [
                {
                    dataField: "c",
                    headerText: "Result",
                    width: "10%",
                    editable: false
                }]
	    }, {
	    headerText: currentmonth,
	    dataType : "numeric",
	    width : "20%",
	    children:
            [
                {
                    dataField: "d",
                    headerText: "Result",
                    width: "10%",
                    editable: false
                }]
	   }];

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

    $(document).ready(function () {
    $(".bottom_msg_box").attr("style","display:none");
    /***********************************************[ NOTICE GRID] ************************************************/
    $("#simulateTable").hide();
    var roleType, userId, userName, memLvl;

    Common.ajax("GET", "/login/getLoginDtls.do", {}, function (result) {
    console.log(result);

        if(result.userTypeId == 1) {
        	$("#simulateTable").hide();
        	$("#btnSrch").hide();

        	if(result.roleType == 111){
        		$("#simulateTable").show();
                $("#btnSrch").show();
        	}

        }
        else if(result.userTypeId == 4) {
        	$("#simulateTable").show();
        	$("#btnSrch").show();

        }
        var salesGridOption = {
                usePaging : false,
                showStateColumn : false,
                showRowNumColumn : false,
                pageRowCount : 4,
                editable : false,
                headerHeight : 50
            };

        salesOrgSummaryList = GridCommon.createAUIGrid("salesOrgSummaryList", salesSummaryDashboard, null, salesGridOption);
        salesOrgWeeklyList = GridCommon.createAUIGrid("salesOrgWeeklyList", salesWeeklyDashboard, null, salesGridOption);
        fn_selectSummaryDashboard() ;
        fn_selectWeeklyDashboard() ;


     });
    });   //$(document).ready

	function fn_selectSummaryDashboard() {
	        Common.ajax("GET", "/organization/selectSummarySalesListing.do", $("#searchForm").serialize(), function (result) {
	        AUIGrid.setGridData(salesOrgSummaryList, result);

	    });
	}

	function fn_selectWeeklyDashboard() {
	    Common.ajax("GET", "/organization/selectWeekSalesListing.do", $("#searchForm").serialize(), function (result) {
	    AUIGrid.setGridData(salesOrgWeeklyList, result);
	 });
	}

	 $(function() {
		$('#performanceView').click(function() {
		  document.searchForm.action = '/organization/performanceView.do';
		  document.searchForm.submit();
		  });


		 $('#btnSrch').click(function() {
			 fn_selectSummaryDashboard();
			 fn_selectWeeklyDashboard();
	      });

	  });

</script>


<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>Organization</li>
    <li>Organization Mgmt.</li>
    <li>Sales Monitoring File</li>
</ul>


<form id="searchForm" name="searchForm" method="post">
 <section class="search_result">
	<aside class="title_line mt30"><!-- title_line start -->
	<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
	<h2>Sales Organization Performance</h2>
	<ul class="right_btns">
	<li><p class="btn_blue"><a id="performanceView">Performance View</a></p></li>
	<li><p class="btn_blue"><a id="btnSrch" href="#"><span class="search"></span>Search</a></p></li>

	</ul>
	</aside>
 </section>

 <table id="simulateTable" class="type1" ><!-- table start -->
<tbody>
<tr>
    <th scope="row">Simulate Member Code</th>
    <td><input id="memCode" name="memCode" type="text" title="memCode"  class="w100p" value = '${SESSION_INFO.userName}'.trim() /></td>
</tr>
</tbody>
</table><!-- table end -->

 </form>
    <div id="salesOrgSummaryList" class="grid_wrap mt30" style="width: 100%; height:300px; margin: 0 auto;"></div>

    <div id="salesOrgWeeklyList" class="grid_wrap" style="width: 100%; height:300px; margin: 0 auto;"></div>

