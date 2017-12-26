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
							        			   Common.alert("<b>The item has been removed.</b>", fn_reLoadPage);
							        		   }else{
							        			   Common.alert("<b>Failed to remove item. Please try again later.</b>");
							        		   }
							        	   });
							           }
							    }
							},
                            {dataField : "ordNo", headerText : "Order No.", width : '10%' , editable : false}, 
                            {dataField : "rem", headerText : "Remark", width : '30%', editable : false},
                            {dataField : "name1", headerText : "Status", width : '10%' , editable : false},
                            {dataField : "validRem", headerText : "System Remark", width : '30%' , editable : false},
                            {dataField : "ordId", headerText : "Order ID", width : '10%' , editable : false},
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
            selectionMode       : "singleRow",  //"multipleCells",            
            headerHeight        : 30,       
            useGroupingPanel    : false,        //그룹핑 패널 사용
            skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
            wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
            showRowNumColumn    : false,         //줄번호 칼럼 렌더러 출력    
            noDataMessage       : "No Order found.",
            groupingMessage     : "Here groupping"
    };
    
    ordRemDetailGridID = GridCommon.createAUIGrid("#dt_grid_wrap", ordRemDtColumnLayout,'', gridPros);  
}

//Confirm
function fn_confirmList(){
	//Validation
	var ordList = AUIGrid.getColumnValues(ordRemDetailGridID, 'validStusId');
	
	if(ordList.length < 1){
		Common.alert("* No valid item in this batch.<br />");
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
		Common.alert("* Please remove the failed item.<br />");
		return;
	}
	
	//Validation Pass
	Common.ajax("POST", "/sales/rcms/confirmBatch", {batchId : '${batchId}'}, function(result){
		 if(result != null){
             Common.alert("<b>This upload batch has been confirmed and saved.</b>", fn_closePage);
         }else{
             Common.alert("<b>Failed To confirm batch. Please try again later.</b>");
         }
	});
	
	
}

//Deactive
function fn_deactiveList(){
	 Common.ajax("POST", "/sales/rcms/updBatch", {batchId : '${batchId}'}, function(result){
         if(result != null){
             Common.alert("<b>This upload batch has been deactivated.</b>", fn_closePage);
         }else{
             Common.alert("<b>Failed to deactive item. Please try again later.</b>");
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
<h1>ORDER REMARK UPLOAD - VIEW UPLOAD BATCH</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#" id="_confirmCloseBtn">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<aside class="title_line"><!-- title_line start -->
<h3>Order Remark Batch Info</h3>
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
    <th scope="row">Batch ID</th>
    <td><span>${infoMap.uploadMid}</span></td>
    <th scope="row">Status</th>
    <td><span>${infoMap.name}</span></td>
</tr>
<tr>
    <th scope="row">Upload By</th>
    <td><span>${infoMap.updUserName}</span></td>
    <th scope="row">Update By</th>
    <td><span>${infoMap.updDt}</span></td>
</tr>
<tr>
    <th scope="row">Total Item</th>
    <td><span>${infoMap.totCnt}</span></td>
    <th scope="row">Total Valid / Invalid</th>
    <td><span>${infoMap.validCnt}/${infoMap.inValidCnt}</span></td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h3>Batch Item</h3>
</aside><!-- title_line end -->

<ul class="left_btns">
    <li><p class="btn_grid"><a  onclick="fn_all()">All Item</a></p></li>
    <li><p class="btn_grid"><a  onclick="fn_valid()">Valid Item</a></p></li>
    <li><p class="btn_grid"><a  onclick="fn_invalid()">Invalid Item</a></p></li>
    <li><p class="btn_grid"><a  onclick="fn_addItem()">Add Item</a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="dt_grid_wrap" style="width:100%; height:280px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

<ul class="center_btns">
    <li><p class="btn_blue2 big"><a onclick="javascript: fn_confirmList()">Confirm</a></p></li>
    <li><p class="btn_blue2 big"><a onclick="javascript: fn_deactiveList()">Deactive</a></p></li>
</ul>

</section><!-- pop_body end -->

</div><!-- popup_wrap end-->
