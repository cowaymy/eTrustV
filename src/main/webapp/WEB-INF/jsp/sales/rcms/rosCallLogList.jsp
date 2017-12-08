<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>


<script type="text/javascript">

//Create and Return Grid Id
var rosGridID;

var optionModule = {
        type: "M",     
        isCheckAll: false,
        isShowChoose: false  
};


$(document).ready(function() {/////////////////////////////////////////////////////////////// Document Ready Func Start
	
	createRosCallGrid();
	
	CommonCombo.make("_appType", "/sales/rcms/getAppTypeList", {codeMasterId : '10'}, "66", optionModule);
	
	
	//Search
	$("#_searchBtn").click(function() {
		
		Common.ajax("GET","/sales/rcms/selectRosCallLogList" , $("#_searchForm").serialize(),function(result){
			//set Grid Data
			AUIGrid.setGridData(rosGridID, result);
		})
	});
});////////////////////////////////////////////////////////////////////////////////////////////////// Document Ready Func End

function fn_underDevelop(){
	Common.alert("This Program is Under Development.");
}

function createRosCallGrid(){
	 var rosColumnLayout =  [ 
	                            {dataField : "ordNo", headerText : "Order No", width : '10%' , editable : false}, 
	                            {dataField : "ordDt", headerText : "Order Date", width : '10%', editable : false},
	                            {dataField : "appTypeCode", headerText : "App Type", width : '10%' , editable : false},
	                            {dataField : "stockDesc", headerText : "Product", width : '20%' , editable : false},
	                            {dataField : "custName", headerText : "Customer Name", width : '20%' , editable : false},
	                            {dataField : "custNric", headerText : "NRIC/Company No", width : '20%' , editable : false}, 
	                            {dataField : "rentalStus", headerText : "Rental Status", width : '10%' , editable : false},
	                           ];
	    
	    //그리드 속성 설정
	    var gridPros = {
	            
	            usePaging           : true,         //페이징 사용
	            pageRowCount        : 20,           //한 화면에 출력되는 행 개수 20(기본값:20)            
	            fixedColumnCount    : 1,            
	            showStateColumn     : true,             
	            displayTreeOpen     : false,            
	            selectionMode       : "singleRow",  //"multipleCells",            
	            headerHeight        : 30,       
	            useGroupingPanel    : false,        //그룹핑 패널 사용
	            skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
	            wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
	            showRowNumColumn    : true,         //줄번호 칼럼 렌더러 출력    
	            noDataMessage       : "No Ros Call found.",
	            groupingMessage     : "Here groupping"
	    };
	    
	    rosGridID = GridCommon.createAUIGrid("#rosCall_grid_wrap", rosColumnLayout,'', gridPros);  // address list
}
</script>



<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>Sales</li>
    <li>Order list</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>ROS Call Log</h2>
<ul class="right_btns">
    <li><p class="btn_blue"><a onclick="javascript:fn_underDevelop()"><span ></span>NEW ROS Call</a></p></li>
    <li><p class="btn_blue"><a onclick="javascript:fn_underDevelop()"><span ></span>Change Order Billing Type</a></p></li>
    <li><p class="btn_blue"><a onclick="javascript:fn_underDevelop()"><span ></span>Order Remark Upload Batch</a></p></li>
    <li><p class="btn_blue"><a id="_searchBtn"><span class="search"></span>Search</a></p></li>
    <li><p class="btn_blue"><a onclick="javascript:fn_underDevelop()"><span class="clear"></span>Clear</a></p></li>
</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form id="_searchForm">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:170px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Order No</th>
    <td>
    <input type="text" title="" placeholder="Order No" class="w100p" id="_ordNo" name="ordNo"/>
    </td>
    <th scope="row">Application Type</th>
    <td>
    <select class="multy_select w100p" multiple="multiple" id="_appType" name="appType"></select>
    </td>
    <th scope="row">Rental Status</th>
    <td>
    <select class="multy_select w100p" multiple="multiple" id="_rentalStatus" name="rentalStatus">
        <option value="ACT">Active</option>
        <option value="REG">Regular</option>
        <option value="INV">Investigate</option>
        <option value="SUS">Suspend</option>
        <option value="RET">Return</option>
        <option value="CAN">Cancel</option>
        <option value="TER">Terminate</option>
        <option value="WOF">Write Off</option>
    </select>
    </td>
</tr>
<tr>
    <th scope="row">Customer ID</th>
    <td>
    <input type="text" title="" placeholder="Customer ID (Number Only)" class="w100p" id="_custId" name="custId" />
    </td>
    <th scope="row">Customer Name</th>
    <td>
    <input type="text" title="" placeholder="Customer Name" class="w100p" id="_custName" name="custName"/>
    </td>
    <th scope="row">NRIC/Company No</th>
    <td>
    <input type="text" title="" placeholder="NRIC/Company Number" class="w100p" id="_custNric" name="custNric" />
    </td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="link_btns_wrap"><!-- link_btns_wrap start -->
<p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
<dl class="link_list">
    <dt>Link</dt>
    <dd>
    <ul class="btns">
        <li><p class="link_btn"><a onclick="javascript:fn_underDevelop()">Feedback List</a></p></li>
    </ul>
    <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
    </dd>
</dl>
</aside><!-- link_btns_wrap end -->

</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="rosCall_grid_wrap" style="width:100%; height:480px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- content end -->