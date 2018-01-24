<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javascript">

var instGridID;

$(document).ready(function() {

	createInstallGrid();
	
});

function createInstallGrid(){
	
	var  columnLayout = [
                         {dataField : "salesOrdNo", headerText : "Order No", width : "8%" , editable : false},
                         {dataField : "appType", headerText : "App Type", width : "8%" , editable : false},
                         {dataField : "orderStatus", headerText : "Order Status", width : "10%" , editable : false},
                         {dataField : "stkDesc", headerText : "Product Model", width : "15%" , editable : false},
                         {dataField : "fullAddress", headerText : "Detail Address", width : "30%" , editable : false},
                         {dataField : "city", headerText : "CITY", width : "9%" , editable : false},
                         {dataField : "state", headerText : "STATE", width : "9%" , editable : false},
                         {dataField : "rentalStatus", headerText : "Rental Status", width : "11%" , editable : false}
                   ]
	 var gridPros = {
            usePaging           : true,         //페이징 사용
            pageRowCount        : 20,           //한 화면에 출력되는 행 개수 20(기본값:20)            
            editable            : false,            
            //fixedColumnCount    : 1,            
            showStateColumn     : false,             
            displayTreeOpen     : false,            
     //       selectionMode       : "singleRow",  //"multipleCells",            
            headerHeight        : 30,       
            useGroupingPanel    : false,        //그룹핑 패널 사용
            skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
            wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
            showRowNumColumn    : false
        };
	instGridID = GridCommon.createAUIGrid("#inst_grid_wrap", columnLayout,'', gridPros);
	
	//Set Grid Data
	Common.ajax("GET", "/sales/ccp/getCcpInstallationList", {custId : $("#_editCustId").val()}, function(result){
        //set Grid
        AUIGrid.setGridData(instGridID, result);
        
    });
}

</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->
<header class="pop_header"><!-- pop_header start -->
<h1>Installation Area</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a id="_btnClose">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->
<section class="pop_body"><!-- pop_body start -->
<article class="grid_wrap"><!-- grid_wrap start -->
<div id="inst_grid_wrap" style="width:100%; height:480; margin:0 auto;"></div>
</article><!-- grid_wrap end -->
</section>
</div>