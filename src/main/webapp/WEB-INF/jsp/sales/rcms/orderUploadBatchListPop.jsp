<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">
//create and return Grid ID
var ordRemGridID;
var comboStatusOption = { isShowChoose: false , type: "M", id: "stusCodeId", name: "codeName"};

var optionModule = {
        type: "M",     
        isCheckAll: false,
        isShowChoose: false  
};

$(document).ready(function() {
	createOrderRemGrid();
	
	CommonCombo.make("_batchStatus", "/status/selectStatusCategoryCdList.do", {selCategoryId : '25'}, '',  comboStatusOption);
	
	//Search
	$("#_srchBtn").click(function() {
		Common.ajax("GET", "/sales/rcms/selectOrderRemList", $("#_srchForm").serialize(), function(result){
			AUIGrid.setGridData(ordRemGridID, result);
		});
		
	});
	
	//New
	$("#_newUpload").click(function() {
		Common.popupDiv("/sales/rcms/ordUploadPop.do", null ,  null , true, '_updFileDiv');
	});
});

function createOrderRemGrid(){
	var ordColumnLayout =  [ 
                            {dataField : "uploadMid", headerText : "Batch ID", width : '25%' , editable : false}, 
                            {dataField : "name", headerText : "Status", width : '25%', editable : false},
                            {dataField : "crtUserName", headerText : "Uploader", width : '25%' , editable : false},
                            {dataField : "crtDt", headerText : "Upload Date", width : '25%' , editable : false}
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
            noDataMessage       : "No Order found.",
            groupingMessage     : "Here groupping"
    };
    
    ordRemGridID = GridCommon.createAUIGrid("#ordRem_grid_wrap", ordColumnLayout,'', gridPros);  // address list
}
</script>


<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->
<header class="pop_header"><!-- pop_header start -->
<h1>ROS Call Log - Order Remark Upload</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a id="_updOrdRemClose">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->
<aside class="title_line"><!-- title_line start -->
<ul class="right_btns">
    <li><p class="btn_blue"><a id="_newUpload"><span ></span>New Upload</a></p></li>
    <li><p class="btn_blue"><a id="_viewUpload"><span ></span>View Upload Batch</a></p></li>
    <li><p class="btn_blue"><a id="_confirmUpload"><span ></span>Confirm Upload</a></p></li>
    <li><p class="btn_blue"><a id="_srchBtn"><span class="search"></span>Search</a></p></li>
    <li><p class="btn_blue"><a onclick="javascript:$('#_srchForm').clearForm();"><span class="clear"></span>Clear</a></p></li>
</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form id="_srchForm">

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
    <th scope="row">Batch ID</th>
    <td>
    <input type="text" title="" placeholder="Order No" class="w100p" id="_batchId" name="batchId"/>
    </td>
    <th scope="row">Batch Status</th>
    <td>
    <select class="multy_select w100p" multiple="multiple" id="_batchStatus" name="batchStatus"></select>
    </td>
    <th scope="row">Uploader</th>
    <td>
        <input type="text" title="" placeholder="Uploader" class="w100p" id="_uploader" name="uploader"/>
    </td>
</tr>
<tr>
    <th scope="row">Upload Date</th>
    <td colspan="5">
   <div class="date_set w100p"><!-- date_set start -->
    <p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date"  name="fromDt" id="_fromDt"  readonly="readonly"/></p>  
    <span>To</span>
    <p><input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" name="toDT"  id="_toDT" readonly="readonly"/></p>
    </div><!-- date_set end -->
    </td>
</tr>
</tbody>
</table><!-- table end -->

</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="ordRem_grid_wrap" style="width:100%; height:480px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section>
</div>