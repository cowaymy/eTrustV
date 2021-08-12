<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javascript">

var instGridID;

$(document).ready(function() {

	createInstallGrid();
	
});

function createInstallGrid(){
	
	var  columnLayout = [
                         {dataField : "salesOrdNo", headerText : '<spring:message code="sal.text.ordNo" />', width : "8%" , editable : false},
                         {dataField : "appType", headerText : '<spring:message code="sal.title.text.appType" />', width : "8%" , editable : false},
                         {dataField : "orderStatus", headerText : '<spring:message code="sal.title.text.ordStus" />', width : "10%" , editable : false},
                         {dataField : "stkDesc", headerText : '<spring:message code="sal.title.text.productModel" />', width : "15%" , editable : false},
                         {dataField : "fullAddress", headerText : '<spring:message code="sal.title.text.detailAddr" />', width : "30%" , editable : false},
                         {dataField : "city", headerText : '<spring:message code="sal.text.city" />', width : "9%" , editable : false},
                         {dataField : "state", headerText : '<spring:message code="sal.text.state" />', width : "9%" , editable : false},
                         {dataField : "rentalStatus", headerText : '<spring:message code="sal.text.rentalStatus" />', width : "11%" , editable : false}
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
<h1><spring:message code="sal.title.text.installArea" /></h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a id="_btnClose"><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->
<section class="pop_body"><!-- pop_body start -->
<article class="grid_wrap"><!-- grid_wrap start -->
<div id="inst_grid_wrap" style="width:100%; height:480; margin:0 auto;"></div>
</article><!-- grid_wrap end -->
</section>
</div>