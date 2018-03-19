<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp" %>

<style type="text/css">

    .aui-grid-user-custom-left { text-align:left; }

    .aui-grid-user-custom-right { text-align:right;}

    .mycustom-disable-color { color : #cccccc; }

    .aui-grid-body-panel table tr:hover { background:#D9E5FF; color:#000; }

    .aui-grid-main-panel .aui-grid-body-panel table tr td:hover {background:#D9E5FF; color:#000;}

    #detailWindow { font-size:13px; }
    #detailWindow label, input { display:inline; }
    #detailWindow input.text { margin-bottom:10px; width:95%; padding: 0.1em;  }
    #detailWindow fieldset { padding:0; border:0; margin-top:10px; }

</style>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery.blockUI.min.js"></script>

<script type="text/javaScript" language="javascript">

    var myGridID;
    var detailGrid;

    var pagestate="";

    var columnLayout = [
				                        {dataField:"stkcode", headerText:"Filter Code", width:"15%", height:30},
				                        {dataField:"stkdesc", headerText:"Filter Description", width:"35%", height:30},
				                        {dataField:"mth0", headerText:"M+0", width:"12.5%", height:30},
				                        {dataField:"mth1", headerText:"M+1", width:"12.5%", height:30},
				                        {dataField:"mth2", headerText:"M+2", width:"12.5%", height:30},
				                        {dataField:"mth3", headerText:"M+3", width:"12.5%", height:30}
			                        ];

    var gridoptions = {
						    		showStateColumn : false,
						    		fixedColumnCount : 2,
						    		editable : false,
						    		useGroupingPanel : false,
						    		selectionMode : "singleRow",
						    	    usePaging : false
						    	 };


    var detailLayout = [
				                      {dataField:"stkcode", headerText:"Filter Code", width:"15%", height:30},
				                      {dataField:"stkdesc", headerText:"Filter Description", width:"30%", height:30},
				                      {dataField:"orderno", headerText:"Order No", width:"15%", height:30},
				                      {dataField:"qty", headerText:"Qty", width:"8%", height:30},
				                      {dataField:"filterexp", headerText:"Service Expiry Date", width:"16%", height:30},
				                      {dataField:"brnchcode", headerText:"Branch Code", width:"10%", height:30},
				                      {dataField:"brnchdesc", headerText:"Branch Description", width:"30%", height:30},


			                      ];

    var detailoptions = {
							           showStateColumn : false,
							           editable : false,
							           useGroupingPanel : false,
							           isFitColumnSizeHeaderText : true,
							           width : '80%',
							           usePaging : false
							       };


    $(document).ready(function() {

    	myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout, "", gridoptions);
    	detailGrid = GridCommon.createAUIGrid("grid_wrap_details", detailLayout, "", detailoptions);

        doGetCombo('/common/selectCodeList.do', '11', '','searchCtgry', 'S' , '');
        doGetComboSepa('/common/selectBranchCodeList.do', '3', ' - ', '', 'brnch', 'M', 'f_multiCombo');
        doGetComboData('/common/selectCodeList.do', { groupCode : 45, orderValue : 'CODE_ID' }, '', 'loctype', 'M', 'f_multiCombo');

        AUIGrid.bind(myGridID, "cellClick", function(event) { });

        AUIGrid.bind(myGridID, "cellDoubleClick", function(event) {

            pagestate = "m";

            if (event.rowIndex > -1)
            {
            	if(event.value == null || event.value == '' || event.value == '0')
            	{
            		Common.alert('Please select a month with value more than 0.');
            	}
                else if(event.columnIndex >= 2)
            	{
                    fn_loadDetails(event.rowIndex, event.columnIndex);
            	}
            	else
            	{
            		Common.alert('Please select a month to display.');
            	}
            }
            else
            {
                Common.alert('Please select a row first.');
            }

        });

        $("#popup_wrap, .popup_wrap").draggable({handle: '.pop_header'});

    });

    $(function() {

        $("#srchCode").keypress(function(event) {

        	$('#itmCode').val('');

            if (event.which == '13')
            {
                $("#svalue").val($("#srchCode").val());
                $("#sUrl").val("/logistics/material/materialcdsearch.do");

                Common.searchpopupWin("searchForm", "/common/searchPopList.do","stock");
            }
        });

        $("#search").click(function() {

            if ($("#srchmaterial").val() == "")
            {
                $("#itmCode").val('');
            }

            if ($("#itmCode").val() == ""){  $("#itmCode").val($("#srchmaterial").val());}

            searchAjax();

        });

        $("#clear").click(function() {

            $("#itmCode").val('');
            $("#srchCode").val('');
            $("#searchCtgry").val('');
            $("#fcastDate").val('');
            $("#mthCount").val('1');

        });

        $("#download").click(function() {
            GridCommon.exportTo("grid_wrap", 'xlsx', "HS Filter Forecast List");
        });

    });

    function fn_loadDetails(rowID, colID) {

        $("#detailStkCode").val(AUIGrid.getCellValue(myGridID, rowID, 'stkcode'));
        $("#selectedMth").val(colID - 2);

        var paramdata = { groupCode : '339', orderValue : 'CODE' };

        fn_searchDetails();

        $("#detailWindow").show();
        AUIGrid.resize(detailGrid);
    }

    function searchAjax() {

        var url = "/logistics/HSFilterForecast/selectHSFilterForecastList.do";
        var param = $('#searchForm').serializeJSON();

        Common.ajax("POST", url, param, function(data) {

            var gridData = data;

            AUIGrid.setGridData(myGridID, gridData.data);

        });

        if($("fcastDate").val() != null || $("fcastDate").val() != '')
        {
            $("hiddenfcastDate").val($("fcastDate").val())
        }
    }

    function f_multiCombo() {

        $(function() {
            $('#loctype').change(function() {

            }).multipleSelect( {
                    selectAll : true,
                    width : '80%'
            });
        });

        $(function() {
            $('#brnch').change(function() {

            }).multipleSelect( {
                    selectAll : true,
                    width : '80%'
            });
        });
    }

     function fn_itempopList(data) {

         var rtnVal = data[0].item;

         $("#itmCode").val(rtnVal.itemcode);
         $("#srchCode").val(rtnVal.itemcode + ' - ' + rtnVal.itemname);

         $("#svalue").val();
     }

     function fn_searchDetails() {

         var url = "/logistics/HSFilterForecast/selectForecastDetailsList.do";
         var param = $('#modForm').serializeJSON();

         Common.ajax("POST", url, param, function(data) {

             var gridData = data;

             AUIGrid.setGridData(detailGrid, gridData.data);

         });
     }

</script>

<section id="content"><!-- content start -->
	<ul class="path">
	    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
	    <li>Logistics</li>
	    <li>Report</li>
	    <li>HS Filter Forecast</li>
	</ul>

	<aside class="title_line"><!-- title_line start -->
	   <p class="fav"><a href="#" class="click_add_on">My menu</a></p>

	   <h2>HS Filter Forecast</h2>

		<ul class="right_btns">
<c:if test="${PAGE_AUTH.funcView == 'Y'}">
		    <li><p class="btn_blue"><a id="search"><span class="search"></span>Search</a></p></li>
</c:if>
		
		    <li><p class="btn_blue"><a id="clear"><span class="clear"></span>Clear</a></p></li>
		</ul>
	</aside><!-- title_line end -->

    <section class="search_table"><!-- search_table start -->

	    <form id="searchForm" name="searchForm" method="post">

	        <input type="hidden" id="sUrl" name="sUrl">
            <input type="hidden" id="sValue" name="sValue">

            <input type="hidden" id="mth2" name="mth2">
            <input type="hidden" id="mth3" name="mth3">
            <input type="hidden" id="mth4" name="mth4">
            <input type="hidden" id="mth5" name="mth5">
            <input type="hidden" id="mth6" name="mth6">
            <input type="hidden" id="mth7" name="mth7">
            <input type="hidden" id="mth8" name="mth8">
            <input type="hidden" id="mth9" name="mth9">
            <input type="hidden" id="mth10" name="mth10">
            <input type="hidden" id="mth11" name="mth11">
            <input type="hidden" id="mth12" name="mth12">

	        <table class="type1"><!-- table start -->

			    <caption>table</caption>

			    <colgroup>
			        <col style="width:130px" />
			        <col style="width:*" />
			        <col style="width:130px" />
			        <col style="width:*" />
			        <col style="width:140px" />
			        <col style="width:*" />
			    </colgroup>

	            <tbody>
	                <tr>
		                <th scope="row">Filter Code</th>
				        <td>
				            <input type="hidden"  id="itmCode" name="itmCode">
				            <input type="text" id="srchCode" name="srchCode" placeholder="Press 'Enter' to Search" class="w100p" />
				        </td>
				        
				        <th scope="row">Forecast Start Date</th>
                        <td>
                           <!-- <input id="fcastDate"  name="fcastDate" type="text" title="Forecast Start Date" placeholder="DD/MM/YYYY" class="j_date"> -->
                           <input id="fcastDate" name="fcastDate" type="text" title="Forecast Start Date" placeholder="MM/YYYY" class="j_date2 w100p"  />
                        </td>
				        
				        <th scope="row">Filter Category</th>
                        <td>
                            <select class="w100p" id="searchCtgry"  name="searchCtgry"></select>
                        </td>

                     </tr>
                       <!-- <th scope="row">No. of Months</th>
                        <td >
                            <select class="w100p"  id="mthCount" name="mthCount">
                            <option value="1">1 Month</option>
                            <option value="2">2 Months</option>
                            <option value="3">3 Months</option>
                            <option value="4">4 Months</option>
                            <option value="5">5 Months</option>
                            <option value="6">6 Months</option>
                            <option value="7">7 Months</option>
                            <option value="8">8 Months</option>
                            <option value="9">9 Months</option>
                            <option value="10">10 Months</option>
                            <option value="11">11 Months</option>
                            <option value="12">12 Months</option>
                            </select>
                        </td> -->
			         
	                <!-- <tr>
                        <th scope="row">Filter Category</th>
                        <td>
                            <select class="w100p" id="searchCtgry"  name="searchCtgry"></select>
                        </td>
				    </tr> -->
			    </tbody>
		    </table><!-- table end -->
	    </form>
	</section><!-- search_table end -->

 	<section class="search_result">
        <ul class="right_btns">
<c:if test="${PAGE_AUTH.funcChange == 'Y'}">
            <li><p class="btn_grid"><a id="download"><spring:message code='sys.btn.excel.dw' /></a></p></li>
</c:if>        
        </ul>
        <div id="grid_wrap" class="mt10" style="height:500px"></div>

    </section>

    <div class="popup_wrap" id="detailWindow" style="display:none"><!-- popup_wrap start -->

        <header class="pop_header">

            <h1>Filter Forecast - Details of the Month</h1>
				<ul class="right_opt">
				    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
				</ul>
        </header>

        <section class="pop_body"><!-- pop_body start -->

            <form id="modForm" name="modForm" method="POST">

                <input type="hidden" id="detailStkCode" name="detailStkCode">
                <input type="hidden" id="selectedMth" name="selectedMth">
                <input type="hidden" id="hiddenfcastDate" name="hiddenfcastDate">

                <table class="type1"><!-- table start -->

					<caption>search table</caption>

					<colgroup>
                    <col style="width:130px" />
                    <col style="width:*" />
                    <col style="width:130px" />
                    <col style="width:*" />
					</colgroup>

					<tbody>
						<tr>
						    <th scope="row">Location Type</th>
						    <td>
						         <select class="multy_select" multiple="multiple" id="loctype" name="loctype[]"  class="w100p" ></select>
						    </td>
						    <th scope="row">Branch</th>
						    <td>
						         <select class="multy_select" multiple="multiple" id="brnch" name="brnch[]"  class="w100p" ></select>
						    </td>
						</tr>
			         </tbody>
				</table><!-- table end -->

				<ul class="center_btns">
<c:if test="${PAGE_AUTH.funcView == 'Y'}">
				    <li><p class="btn_blue2 big"><a onclick="javascript:fn_searchDetails();">Search</a></p></li>
</c:if>				
				    <li></li>
				</ul>
				&nbsp;
                <div id="grid_wrap_details" style="width:100%"></div>

			</form>
		</section>
	</div>

</section><!-- content end -->