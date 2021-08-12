<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script  type="text/javascript">

var ordRemDetailGridID;

$(document).ready(function() {
	
	createOrderRemDetailGrid();
	
});


function createOrderRemDetailGrid(){
	
	var ordRemDtColumnLayout =  [ 
                            {dataField : "ordNo", headerText : '<spring:message code="sal.title.text.ordNop" />', width : '10%' , editable : false}, 
                            {dataField : "rem", headerText : '<spring:message code="sal.title.remark" />', width : '35%', editable : false},
                            {dataField : "name1", headerText : '<spring:message code="sal.title.status" />', width : '10%' , editable : false},
                            {dataField : "validRem", headerText : '<spring:message code="sal.title.text.sysRem" />', width : '35%' , editable : false},
                            {dataField : "ordId", headerText : '<spring:message code="sal.title.text.ordId" />', width : '10%' , editable : false},
                            {dataField : "validStusId", visible : false},   
                           ];
    
    //그리드 속성 설정
    var gridPros = {
            
            usePaging           : true,         //페이징 사용
            pageRowCount        : 20,           //한 화면에 출력되는 행 개수 20(기본값:20)            
            fixedColumnCount    : 1,            
            showStateColumn     : true,             
            displayTreeOpen     : false,            
   //         selectionMode       : "singleRow",  //"multipleCells",            
            headerHeight        : 30,       
            useGroupingPanel    : false,        //그룹핑 패널 사용
            skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
            wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
            showRowNumColumn    : true
    };
    
    ordRemDetailGridID = GridCommon.createAUIGrid("#dt_grid_wrap", ordRemDtColumnLayout,'', gridPros);  
    
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

</script>


<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="sal.title.text.ordRemUploadViewUploadBatch" /></h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#" id="_close"><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<aside class="title_line"><!-- title_line start -->
<h3><spring:message code="sal.title.text.ordRemBatchInfo" /></h3>
<%-- <c:if test="${cnvrInfo.code eq 'ACT'}">
<ul class="right_btns">
    <li><p class="btn_blue"><a href="#" onclick="fn_confirm()">Confirm</a></p></li>
    <li><p class="btn_blue"><a href="#" onclick="fn_deactivate()">Deactivate</a></p></li>
</ul>
</c:if> --%>
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
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="dt_grid_wrap" style="width:100%; height:280px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- pop_body end -->

</div><!-- popup_wrap end-->
