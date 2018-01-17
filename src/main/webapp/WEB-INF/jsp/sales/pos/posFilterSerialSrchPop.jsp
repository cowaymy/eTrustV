<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">

//생성 후 반환 ID
var serialGrid;

//그리드 속성 설정
var gridPros = {
        
        usePaging           : true,         //페이징 사용
        pageRowCount        : 10,           //한 화면에 출력되는 행 개수 20(기본값:20)            
        fixedColumnCount    : 1,            
        showStateColumn     : false,             
        displayTreeOpen     : false,            
 //       selectionMode       : "singleRow",  //"multipleCells",            
        headerHeight        : 30,       
        useGroupingPanel    : false,        //그룹핑 패널 사용
        skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
        wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
        showRowNumColumn    : true,         //줄번호 칼럼 렌더러 출력
        softRemoveRowMode : false,
        showRowCheckColumn : true
};

$(document).ready(function() {
    
	/* var tempSerialArr = "${tempSerialArr}";
	var basketStkCode = '${basketStkCode}';
	console.log("basketStkCode :  " + basketStkCode); */
	//Create Grid 
	createSerialGrid();
	//Set
	//setSerialGridData(basketStkCode, tempSerialArr);
	setSerialGridData();
	
	$("#_filterSaveBtn").click(function() {
		var chkArr = AUIGrid.getCheckedRowItems(serialGrid);
		
		//Validation
		if( null == chkArr || chkArr.length <= 0){
			Common.alert('<spring:message code="sal.alert.msg.selSerialNum" />');
			return;
		}
		
		var toArr = [];
		for (var idx = 0; idx < chkArr.length; idx++) {
			//console.log('chkArr['+idx+'].item.serialNo : ' + chkArr[idx].item.serialNo);
			toArr.push(chkArr[idx].item.serialNo);
		}
		//console.log('toArr : ' + toArr);
		
		//Move to Grid
		var rtnObject = {toArr : toArr};
		fn_getConfirmFilterListAjax(rtnObject);
		$("#_filterSrchCloseBtn").click();
		
	});
	
	
});//Doc Ready Func End
//getFilterSerialNum
function setSerialGridData() {
	
	    var basketStkCode  =  '${basketStkCode}';
        var tempString = '${tempString}';
        var tempSerialArr = tempString.split(",");
        
        if(tempString == null || tempString == ''){
        	
        	/* console.log("tempString is null or empty!"); */
        	var filterParamForm = {basketStkCode : basketStkCode};
            Common.ajax('GET', '/sales/pos/getFilterSerialNum', filterParamForm , function(result) {
                 AUIGrid.setGridData(serialGrid, result);
            });
        	
        }else{
        	
        	/* console.log("tempString is not null!");
        	console.log('tempSerialArr type : ' + $.type(tempSerialArr));
        	console.log("tempSerialArr : " + tempSerialArr); */
        	 var filterParamReForm = {basketStkCode : basketStkCode , tempSerialArr : tempSerialArr};
             Common.ajax('GET', '/sales/pos/getFilterSerialReNum', filterParamReForm , function(result) {
                  AUIGrid.setGridData(serialGrid, result);
             });
        	
        }
}

function createSerialGrid() {
	
	 var serialColumnLayout =  [ 
                                {dataField : "matnr", headerText : '<spring:message code="sal.title.filterCode" />', width : '33%' , editable : false} ,
                                {dataField : "stkDesc", headerText : '<spring:message code="sal.title.filterName" />', width : '33%' , editable : false},
                                {dataField : "serialNo", headerText : '<spring:message code="sal.title.serial" />', width : '33%' , editable : false} 
                               ];
     serialGrid = GridCommon.createAUIGrid("#serialList_grid_wrap", serialColumnLayout,'', gridPros);  
     AUIGrid.resize(serialGrid , 960, 300);
}
</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->
<input type="hidden" name="tempString" id="_tempString" value="${tempString}">
<%-- <form id="_filterParamForm">
    <input type="hidden" name="basketStkCode" id="_basketStkCode" value="${basketStkCode}'">
    
</form>
<form id="_filterParamReForm">
    <input type="hidden" name="tempSerialArr" id="_tempSerialArr" value="${tempSerialArr}'">
</form> --%>
<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="sal.title.filterSerialSrch" /></h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a id="_filterSrchCloseBtn"><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<!-- <ul class="right_btns">
    <li><p class="btn_blue"><a href="#"><span class="search"></span>Search</a></p></li>
    <li><p class="btn_blue"><a href="#"><span class="clear"></span>Clear</a></p></li>
</ul> -->
<aside class="title_line"><!-- title_line start -->
<h2><spring:message code="sal.title.filterSerialList" /></h2>
</aside><!-- title_line end -->

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="serialList_grid_wrap" style="width:100%; height:480px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

<ul class="center_btns">
    <li><p class="btn_blue2 big"><a id="_filterSaveBtn"><spring:message code="sal.btn.save" /></a></p></li>
</ul>
</section><!-- pop_body end -->

</div><!-- popup_wrap end -->