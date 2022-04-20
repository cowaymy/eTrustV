<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">
	var  gridID;
	var  detailGridID;
	var reqstNo = "";
	var brnchType = "";

	$(document).ready(function(){
	    //AUIGrid 그리드를 생성합니다.
	    createAUIGrid();
	    createDetailAUIGrid();

	    AUIGrid.bind(gridID, "cellDoubleClick", function(event) {
	        <c:if test="${PAGE_AUTH.funcChange == 'Y'}">
	            fn_selectDetailListAjax();
	        </c:if>
	    });

	    AUIGrid.bind(gridID, "cellClick", function(event) {
	        reqstNo = AUIGrid.getCellValue(gridID, event.rowIndex, "reqstNo");
	        brnchType = AUIGrid.getCellValue(gridID, event.rowIndex, "brnchType");
	    });

	    fn_keyEvent();
	});

	function fn_keyEvent(){
	    $("#SRV_CNTRCT_PAC_CODE").keydown(function(key)  {
	            if (key.keyCode == 13) {
	            	fn_mainSelectListAjax();
	            }
	     });
	}

	function createAUIGrid() {
		var columnLayout = [
		    { dataField : "reqstNo",              headerText : "TCR No",          width : 100,   editable : false},
		    { dataField : "brnchName",         headerText : "Branch Type",    width : 200,   editable : false},
		    { dataField : "reqstDt",               headerText : "Request Date",  width : 100,    dataType : "date", formatString : "dd/mm/yyyy"},
		    { dataField : "reqstUserId",         headerText : "Requester",       width : 0},
		    { dataField : "fullName",             headerText : "Requester",       width : 200},
		    { dataField : "cnfmStusName",     headerText : "Status",            width :100},
		];

        var gridPros = { usePaging : true,  pageRowCount: 20, editable: false, fixedColumnCount : 1, selectionMode : "singleRow",  showRowNumColumn : true, showStateColumn : false};
        gridID = GridCommon.createAUIGrid("list_grid_wrap", columnLayout  ,"" ,gridPros);
    }

	function createDetailAUIGrid() {
	    var columnLayout = [
	        { dataField : "areaId",                  headerText : "Area ID",            width : 100,    editable : false},
	        { dataField : "area",                     headerText : "Area",                width : 200,    editable : false},
	        { dataField : "city",                      headerText : "City",                 width : 200,    editable : false},
	        { dataField : "postcode",              headerText : "Postal Code ",     width : 100,    editable : false},
	        { dataField : "state",                    headerText : "State",                width : 200,    editable : false},
	        { dataField : "dtBrnchCode",         headerText : "DT Branch",         width : 120,    editable : false},
	        { dataField : "dtSubGrp",              headerText : "DT Sub Group",   width : 200,    editable : false}
	    ];

	    var gridPros = { usePaging : true,  pageRowCount: 20, editable: false, fixedColumnCount : 1,selectionMode : "singleRow",  showRowNumColumn : true, showStateColumn : false};
	    detailGridID = GridCommon.createAUIGrid("detail_list_grid_wrap", columnLayout  ,"" ,gridPros);
	}

	//리스트 조회.
	function fn_mainSelectListAjax() {
		// datail 그리드 초기화.
		AUIGrid.setGridData(detailGridID, []);

	    Common.ajax("GET", "/organization/territory/selectList", $("#sForm").serialize(), function(result) {
	        AUIGrid.setGridData(gridID, result);

	        var rowCount = AUIGrid.getRowCount(gridID);
	        if(rowCount <= 0) {
	            AUIGrid.clearGridData("#detail_list_grid_wrap");
	        }
	    });
	}

	//리스트 조회.
	function fn_selectDetailListAjax() {
	    var selectedItems = AUIGrid.getSelectedItems(gridID);
	    if(selectedItems.length <= 0 ) {
	        Common.alert("There Are No selected Items.");
	        return ;
	    }

	    Common.ajax("GET", "/homecare/services/plan/selectHcTerritoryDetailList", { reqstNo: reqstNo, brnchType: brnchType}, function(result) {
	        AUIGrid.setGridData(detailGridID, result);
	    });
	}

	// Clear Button Click Event
	function fn_Clear(){
	    $("#sForm").find("input").val("");
	}

	// Button Click - Current Territory Search
	function fn_CurrentSearch(){
	    Common.popupDiv("/homecare/services/plan/hcTerritorySearchPop.do?memType="+$("#comBranchType").val() ,null, null , true , '_NewAddDiv1');
	}

	// Button Click - update Request
	function fn_New(){
	    if($("#comBranchType").val() == '') {
	        Common.alert("Please Select Branch Type");
			return false;
		}
	    Common.popupDiv("/homecare/services/plan/hcTerritoryNew.do?memType="+$("#comBranchType").val() ,null, null , true , '_NewAddDiv1');
	}

	// Button Click - confirm
	function fn_Comfirm() {
		var selectedItems = AUIGrid.getSelectedItems(gridID);

	    if(selectedItems.length <= 0 ) {
	        Common.alert("There Are No selected Items.");
		    return ;
	    }
	    Common.ajax("GET", "/homecare/services/plan/updateHcTerritoryList.do", { reqstNo: reqstNo, brnchType : brnchType }, function(result) {
	    	Common.alert(result.message);
	    });
	}

</script>

<section id="content"><!-- content start -->
<ul class="path">
	<li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
	<li>Organization</li>
	<li>Territory Management</li>
</ul>

<aside class="title_line"><!-- title_line start -->
	<p class="fav"><a href="javascript:void(0);" class="click_add_on">My menu</a></p>
	<h2>Territory Management</h2>
	<ul class="right_btns">
	<c:if test="${PAGE_AUTH.funcView == 'Y'}">
	    <li><p class="btn_blue"><a href="javascript:void(0);" onclick="javasclipt:fn_CurrentSearch()">Current Territory Search</a></p></li>
	</c:if>
	<c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
	    <li><p class="btn_blue"><a href="javascript:void(0);" onclick="javasclipt:fn_New()"><span class="Update Request"></span>Update Request</a></p></li>
	</c:if>
	<c:if test="${PAGE_AUTH.funcChange == 'Y'}">
	    <li><p class="btn_blue"><a href="javascript:void(0);" onclick="javasclipt:fn_Comfirm()"><span class="Comfirm"></span>Confirm</a></p></li>
	</c:if>
	<c:if test="${PAGE_AUTH.funcView == 'Y'}">
		<li><p class="btn_blue"><a href="javascript:void(0);" onclick="javascript:fn_mainSelectListAjax()"><span class="search"></span>Search</a></p></li>
	</c:if>
		<li><p class="btn_blue"><a href="javascript:void(0);" onclick="javascript:fn_Clear()"><span class="clear"></span>Clear</a></p></li>
	</ul>
</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->
	<form action="#" method="post" id="sForm" autocomplete=off>
		<aside class="title_line"><!-- title_line start -->
		<h4>Search Options</h4>
		</aside><!-- title_line end -->
	    <!-- table start -->
		<table class="type1">
			<caption>table</caption>
			<colgroup>
				<col style="width:130px" />
				<col style="width:*" />
				<col style="width:150px" />
				<col style="width:*" />
				<col style="width:90px" />
				<col style="width:*" />
				<col style="width:120px" />
				<col style="width:*" />
			</colgroup>
			<tbody>
			<tr>
				<th scope="row">Branch Type<span class="must">*</span></th>
				<td>
					<select class="w100p"  id="comBranchType" name="comBranchType">
					   <option value="${branchTypeId}">HomeCare Delivery Canter</option>
					</select>
				</td>
				<th scope="row">Assign Request Code</th>
				<td><input type="text" title="" placeholder="Assign Request Code" class="w100p" id="requestNo" name="requestNo" /></td>
				<th scope="row">Requester</th>
				<td>
					 <input type="text" title="" placeholder="Requester" class="w100p" id="requestUserId" name="requestUserId"  />
				</td>
				<th scope="row">Request Date</th>
				<td>
					<input type="text" title="Request Date" class="j_dateHc w100p" id="requestDt" name="requestDt"  placeholder="DD/MM/YYYY" />
				</td>
			</tr>
			<tr>
			<th scope="row">Member Type<span class="must">*</span></th>
                <td>
                    <select class="w100p"  id="comMemType" name="comMemType">
                       <option value="11">Choose One</option>
                       <option value="5758">Homecare Delivery Technician</option>
                       <option value="6672">Logistics Technician</option>
                    </select>
                </td>
                <th></th><td></td>
                <th></th><td></td>
                <th></th><td></td>
            </tr>
			</tbody>
		</table>
        <!-- table end -->
	</form>
</section><!-- search_table end -->

<section class="search_table"><!-- search_table start -->
<form action="#" method="post">

<%-- <aside class="link_btns_wrap"><!-- link_btns_wrap start -->
<p class="show_btn"><a href="javascript:void(0);"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
<dl class="link_list">
	<dt>Link</dt>
	<dd>
	<ul class="btns">
		<li><p class="link_btn type2"><a href="javascript:void(0);">Magic Address Download</a></p></li>
	</ul>
	<p class="hide_btn"><a href="javascript:void(0);"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
	</dd>
</dl>
</aside><!-- link_btns_wrap end --> --%>

</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<ul class="right_btns">


</ul>

<aside class="title_line"><!-- title_line start -->
<h4>Information Display</h4>
</aside><!-- title_line end -->

<article class="grid_wrap"><!-- grid_wrap start -->
      <div id="list_grid_wrap" style="width:100%; height:200px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

<aside class="title_line"><!-- title_line start -->
<h4>Detail Information</h4>
</aside><!-- title_line end -->

<article class="grid_wrap"><!-- grid_wrap start -->
      <div id="detail_list_grid_wrap" style="width:100%; height:200px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- content end -->

