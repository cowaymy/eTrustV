<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">
//AUIGrid 생성 후 반환 ID
var ccpGridID;


$(document).ready(function() {
	
	createCcpAUIGrid();
	
	 // 셀 더블클릭 이벤트 바인딩
    AUIGrid.bind(ccpGridID, "cellDoubleClick", function(event){
        $("#_govAgId").val(event.item.govAgId);
        Common.popupDiv("/sales/ccp/selectAgreementMtcViewEditPop.do", $("#popForm").serializeJSON(), null , true , '_viewEditDiv');
    });
	 
	 //Move to Insert Page
    $("#_goToAddWindow").click(function() {
    	self.location.href= "/sales/ccp/insertCcpAgreementSearch.do";
	});
	
});


function fn_selectCcpAgreementListAjax(){
	
	Common.ajax("GET", "/sales/ccp/selectCcpAgreementJsonList",  $("#searchForm").serialize(), function(result) {
		AUIGrid.setGridData(ccpGridID, result);
		
   });
}

function createCcpAUIGrid(){
	
	var  columnLayout = [
	      {dataField : "govAgBatchNo", headerText : "Agreement No", width : "10%" , editable : false},
	      {dataField : "name", headerText : "Customer Name", width : "20%" , editable : false},
	      {dataField : "salesOrdNo", headerText : "Order No", width : "10%" , editable : false},
	      {dataField : "name1", headerText : "Status", width : "10%" , editable : false},
	      {dataField : "code", headerText : "Type", width : "10%" , editable : false},
	      {dataField : "govAgPrgrsName", headerText : "Progress", width : "10%" , editable : false},
	      {dataField : "govAgStartDt", headerText : "Agreement Start", width : "10%" , editable : false},
	      {dataField : "govAgEndDt", headerText : "Agreement Expiry", width : "10%" , editable : false},
	      {dataField : "govAgCrtDt", headerText : "Created", width : "10%" , editable : false},
	      {dataField : "govAgId", visible : false}
	]
	
	//그리드 속성 설정
    var gridPros = {
            usePaging           : true,         //페이징 사용
            pageRowCount        : 10,           //한 화면에 출력되는 행 개수 20(기본값:20)            
            editable            : false,            
            fixedColumnCount    : 0,            
            showStateColumn     : false,             
            displayTreeOpen     : true,            
            selectionMode       : "singleRow",  //"multipleCells",            
            headerHeight        : 30,       
            rowHeight           : 150,   
            wordWrap            : true, 
            useGroupingPanel    : false,        //그룹핑 패널 사용
            skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
            wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
            showRowNumColumn    : false,         //줄번호 칼럼 렌더러 출력    
            noDataMessage       : "No order found.",
            groupingMessage     : "Here groupping"
        };
	
	ccpGridID = GridCommon.createAUIGrid("#ccp_grid_wrap", columnLayout, gridPros);
}
</script>
<div id="wrap"><!-- wrap start -->
<form id="popForm">
    <input type="hidden" id="_govAgId" name="govAgId" >
</form>
<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>Sales</li>
    <li>Order list</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>Government Agreement List</h2>
<ul class="right_btns">
    <li><p class="btn_blue"><a href="#" onclick="javascript : fn_selectCcpAgreementListAjax()"><span class="search" ></span>Search</a></p></li>
    <li><p class="btn_blue"><a href="#" id="_goToAddWindow" ><span class="add"></span>Add</a></p></li>
    <li><p class="btn_blue"><a href="#"><span class="clear"></span>Clear</a></p></li>
</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form action="#" method="get"  id="searchForm">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:200px" />
    <col style="width:*" />
    <col style="width:190px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Agreement No.</th>
    <td><input type="text" title="" placeholder="" class="w100p"  name="govAgBatchNo"/></td>
    <th scope="row">Create Date (From)</th>
    <td><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p"  name="govAgCrtDtFrom" readonly="readonly"/></td>
    <th scope="row">Create Date (To)</th>
    <td><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p" name="govAgCrtDtTo" readonly="readonly"/></td>
</tr>
<tr>
    <th scope="row">Order No.</th>
    <td><input type="text" title="" placeholder="" class="w100p" name="salesOrdNo"/></td>
    <th scope="row">Agreement Start From</th>
    <td><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p" name="govAgStartDtFrom" readonly="readonly"/></td>
    <th scope="row">Agreement Start To</th>
    <td><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p" name="govAgStartDtTo" readonly="readonly"/></td>
</tr>
<tr>
    <th scope="row">Customer Name</th>
    <td><input type="text" title="" placeholder="" class="w100p"  name="name"/></td>
    <th scope="row">Agreement Expiry From</th>
    <td><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p" name="govAgEndDtFrom" readonly="readonly"/></td>
    <th scope="row">Agreement Expiry To</th>
    <td><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p" name="govAgEndDtTo" readonly="readonly"/></td>
</tr>
<tr>
    <th scope="row">Progress</th>
    <td>
    <select class="multy_select w100p" multiple="multiple" name="progressVal">
        <option value="7" selected="selected">Verifying Progress</option>
        <option value="8" selected="selected">Verifying Progress</option>
        <option value="9" selected="selected">Stamping & Confirmation Progress</option>
        <option value="10" selected="selected">Filling Progress</option>
    </select>
    </td>
    <th scope="row">Agreement Status</th>
    <td>
    <select class="multy_select w100p" multiple="multiple" name="statusVal">
        <option value="1" selected="selected">Active</option>
        <option value="4" selected="selected">Completed</option>
        <option value="10" selected="selected">Cancelled</option>
    </select>
    </td>
    <th scope="row">Agreement Type</th>
    <td>
    <select class="multy_select w100p" multiple="multiple" name="typeVal">
        <option value="949" selected="selected">New</option>
        <option value="950" selected="selected">Renew</option>
    </select>
    </td>
</tr>
<tr>
    <th scope="row">AGM Requestor</th>
    <td>
    <select class="multy_select w100p" disabled="disabled"></select>
    </td>
    <th scope="row">Member Code</th>
    <td><input type="text" title="" placeholder="" class="w100p" name="memCode"/></td>
    <th scope="row">Agreement Creator</th>
    <td><input type="text" title="" placeholder="" class="w100p" name="userName"/></td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="link_btns_wrap"><!-- link_btns_wrap start -->
<p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
<dl class="link_list">
    <dt>Link</dt>
    <dd>
    <ul class="btns">
        <li><p class="link_btn"><a href="#">menu1</a></p></li>
        <li><p class="link_btn"><a href="#">menu2</a></p></li>
        <li><p class="link_btn"><a href="#">menu3</a></p></li>
        <li><p class="link_btn"><a href="#">menu4</a></p></li>
        <li><p class="link_btn"><a href="#">Search Payment</a></p></li>
        <li><p class="link_btn"><a href="#">menu6</a></p></li>
        <li><p class="link_btn"><a href="#">menu7</a></p></li>
        <li><p class="link_btn"><a href="#">menu8</a></p></li>
    </ul>
    <ul class="btns">
        <li><p class="link_btn type2"><a href="#">menu1</a></p></li>
        <li><p class="link_btn type2"><a href="#">Search Payment</a></p></li>
        <li><p class="link_btn type2"><a href="#">menu3</a></p></li>
        <li><p class="link_btn type2"><a href="#">menu4</a></p></li>
        <li><p class="link_btn type2"><a href="#">Search Payment</a></p></li>
        <li><p class="link_btn type2"><a href="#">menu6</a></p></li>
        <li><p class="link_btn type2"><a href="#">menu7</a></p></li>
        <li><p class="link_btn type2"><a href="#">menu8</a></p></li>
    </ul>
    <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
    </dd>
</dl>
</aside><!-- link_btns_wrap end -->

</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<ul class="right_btns">
    <li><p class="btn_grid"><a href="#">EXCEL UP</a></p></li>
    <li><p class="btn_grid"><a href="#">EXCEL DW</a></p></li>
    <li><p class="btn_grid"><a href="#">DEL</a></p></li>
    <li><p class="btn_grid"><a href="#">INS</a></p></li>
    <li><p class="btn_grid"><a href="#">ADD</a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="ccp_grid_wrap" style="width:100%; height:480px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- content end -->

<aside class="bottom_msg_box"><!-- bottom_msg_box start -->
<p>Information Message Area</p>
</aside><!-- bottom_msg_box end -->
<hr />
</div><!-- wrap end -->