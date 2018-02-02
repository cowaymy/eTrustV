<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script  type="text/javascript">

var ordRemDetailGridID;

$(document).ready(function() {
    
    createOrderRemDetailGrid();
    
    fn_getConfirmList();
});


function createOrderRemDetailGrid(){
    
    var ordRemDtColumnLayout =  [ 
							{
							    dataField : "undefined",
							    headerText : " ",
							    width : '10%',
							    renderer : {
							           type : "ButtonRenderer",
							           labelText : "Del",
							           onclick : function(rowIndex, columnIndex, value, item) {
							        	   Common.ajax("POST", "/sales/rcms/updOrdNo", {batchId : item.uploadDetId}, function(result){
							        		   if(result != null){
							        			   Common.alert('<spring:message code="sal.title.text.itmHasbeenRemov" />', fn_reLoadPage);
							        		   }else{
							        			   Common.alert('<spring:message code="sal.title.text.failToRemov" />');
							        		   }
							        	   });
							           }
							    }
							},
                            {dataField : "ordNo", headerText : '<spring:message code="sal.title.text.ordNop" />', width : '10%' , editable : false}, 
                            {dataField : "rem", headerText : '<spring:message code="sal.title.remark" />', width : '30%', editable : false},
                            {dataField : "name1", headerText : '<spring:message code="sal.text.status" />', width : '10%' , editable : false},
                            {dataField : "validRem", headerText : '<spring:message code="sal.title.text.sysRem" />', width : '30%' , editable : false},
                            {dataField : "ordId", headerText : '<spring:message code="sal.title.text.ordId" />', width : '10%' , editable : false},
                            {dataField : "validStusId", visible : false},
                            {dataField : "uploadDetId", visible : false}
                           ];
    
    //그리드 속성 설정
    var gridPros = {
            
            usePaging           : true,         //페이징 사용
            pageRowCount        : 20,           //한 화면에 출력되는 행 개수 20(기본값:20)            
            fixedColumnCount    : 1,            
            showStateColumn     : false,             
            displayTreeOpen     : false,            
  //          selectionMode       : "singleRow",  //"multipleCells",            
            headerHeight        : 30,       
            useGroupingPanel    : false,        //그룹핑 패널 사용
            skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
            wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
            showRowNumColumn    : false
    };
    
    ordRemDetailGridID = GridCommon.createAUIGrid("#dt_grid_wrap", ordRemDtColumnLayout,'', gridPros);  
}

//Confirm
function fn_confirmList(){
	//Validation
	var ordList = AUIGrid.getColumnValues(ordRemDetailGridID, 'validStusId');
	
	if(ordList.length < 1){
		Common.alert('<spring:message code="sal.alert.msg.noValidItmThisBatch" />');
		return;
	}
	
	var valCnt = 0;
	$(ordList).each(function(idx, el){
		if(el == '21'){
			valCnt++;
		}
	});
	
	if(valCnt > 0){
		console.log("valCnt : " + valCnt);
		Common.alert('<spring:message code="sal.alert.msg.plzRemovFailItm" />');
		return;
	}
	
	//Validation Pass
	Common.ajax("POST", "/sales/rcms/confirmBatch", {batchId : '${batchId}'}, function(result){
		 if(result != null){
             Common.alert('<spring:message code="sal.alert.msg.uploadFileConfirmAndSaved" />', fn_closePage);
         }else{
             Common.alert('<spring:message code="sal.alert.msg.failToConfirmBatch" />');
         }
	});
	
	
}

//Deactive
function fn_deactiveList(){
	 Common.ajax("POST", "/sales/rcms/updBatch", {batchId : '${batchId}'}, function(result){
         if(result != null){
             Common.alert('<spring:message code="sal.alert.msg.hasbeenDeactived" />', fn_closePage);
         }else{
             Common.alert('<spring:message code="sal.alert.msg.failToDeactivItm" />');
         }
     });
}

function fn_reLoadPage(){
	$("#_confirmCloseBtn").click();
	$("#_confirmUpload").click();
	
}

function fn_closePage(){
	$("#_confirmCloseBtn").click();
	$("#_srchBtn").click();
}

function fn_getConfirmList(){
	 Common.ajax("GET", "/sales/rcms/getBatchDetailInfoList", {batchId : '${batchId}'}, function(result){
	        AUIGrid.setGridData(ordRemDetailGridID, result);
	    });
}

//Filter Clear
function fn_all(){
    AUIGrid.clearFilterAll(ordRemDetailGridID);
};

function fn_valid(){
    AUIGrid.setFilter(ordRemDetailGridID, "validStusId",  function(dataField, value, item) {
        if(item.validStusId  == '4'){
            return true;
        }
        return false;
    });
};

function fn_invalid(){
     AUIGrid.setFilter(ordRemDetailGridID, "validStusId",  function(dataField, value, item) {
         if(item.validStusId  == '21'){
             return true;
         }
         return false;
     });
};

function fn_addItem(){
	 Common.popupDiv("/sales/rcms//addOrderRemBatch.do", {batchId : '${batchId}'} , null , true, '_addBatchDiv');
}

</script>


<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="sal.title.text.ordRemUploadViewUploadBatch" /></h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#" id="_confirmCloseBtn"><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<aside class="title_line"><!-- title_line start -->
<h3><spring:message code="sal.title.text.ordRemBatchInfo" /></h3>
</aside><!-- title_line end -->


<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
    <col style="width:160px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sal.title.text.batchId" /></th>
    <td><span>${infoMap.uploadMid}</span></td>
    <th scope="row"><spring:message code="sal.title.status" /></th>
    <td><span>${infoMap.name}</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.uploadBy" /></th>
    <td><span>${infoMap.updUserName}</span></td>
    <th scope="row"><spring:message code="sal.text.updateBy" /></th>
    <td><span>${infoMap.updDt}</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.totItem" /></th>
    <td><span>${infoMap.totCnt}</span></td>
    <th scope="row"><spring:message code="sal.title.text.totValidInvalid" /></th>
    <td><span>${infoMap.validCnt}/${infoMap.inValidCnt}</span></td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h3><spring:message code="sal.title.text.batchItem" /></h3>
</aside><!-- title_line end -->

<ul class="left_btns">
    <li><p class="btn_grid"><a  onclick="fn_all()"><spring:message code="sal.combo.text.allItm" /></a></p></li>
    <li><p class="btn_grid"><a  onclick="fn_valid()"><spring:message code="sal.combo.text.validItm" /></a></p></li>
    <li><p class="btn_grid"><a  onclick="fn_invalid()"><spring:message code="sal.combo.text.invalidItm" /></a></p></li>
    <li><p class="btn_grid"><a  onclick="fn_addItem()"><spring:message code="sal.title.text.addItm" /></a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="dt_grid_wrap" style="width:100%; height:280px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

<ul class="center_btns">
    <li><p class="btn_blue2 big"><a onclick="javascript: fn_confirmList()"><spring:message code="sal.btn.confirm" /></a></p></li>
    <li><p class="btn_blue2 big"><a onclick="javascript: fn_deactiveList()"><spring:message code="sal.btn.deactive" /></a></p></li>
</ul>

</section><!-- pop_body end -->

</div><!-- popup_wrap end-->
