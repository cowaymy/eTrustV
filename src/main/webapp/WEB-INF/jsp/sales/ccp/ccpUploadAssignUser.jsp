<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javascript">

var batchGrid;

$(document).ready(function() {

	createBatchGrid();

	// 셀 더블클릭 이벤트 바인딩
    AUIGrid.bind(batchGrid, "cellDoubleClick", function(event){
        $("#batchId").val(event.item.batchId);
        Common.popupDiv("/sales/ccp/ccpUploadAssignUserDtlPop.do", {batchId : event.item.batchId}, null, true, 'detailPop');
    });

})

function createBatchGrid(){
	var  columnLayout = [
                        {dataField : "batchId", headerText : "Batch No", width : "10%" , editable : false},
                        {dataField : "remarks", headerText : "Assignment Batch", width : "15%" , editable : false},
                        {dataField : "status", headerText : "Batch Status", width : "15%" , editable : false},
                        {dataField : "fileName", headerText : "File Name", width : "20%" , editable : false, visible : false},
                        {dataField : "qty", headerText : "Batch Quantity", width : "15%" , editable : false},
                        {dataField : "crtDt", headerText : "Batch Upload Date", width : "20%" , editable : false, dataType : "date", formatString : "dd/mm/yyyy"},
                        {dataField : "crtUser", headerText : "Creator", width : "20%" , editable : false}
	                     ]

	var gridPros = {
			 usePaging : true,
	            // 한 화면에 출력되는 행 개수 20(기본값:20)
	            pageRowCount : 20,
	            editable : true,
	            fixedColumnCount : 1,
	            showStateColumn : false,
	            displayTreeOpen : true,
	            selectionMode : "multipleCells",
	            headerHeight : 30,
	            // 그룹핑 패널 사용
	            useGroupingPanel : false,
	            // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
	            skipReadonlyColumns : true,
	            // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
	            wrapSelectionMove : true,
	            // 줄번호 칼럼 렌더러 출력
	            showRowNumColumn : false,

	            groupingMessage : "Here groupping"
        };

	batchGrid = AUIGrid.create("#batch_grid_wrap", columnLayout, gridPros);

}

function fn_searchListAjax(){
    Common.ajax("GET", "/sales/ccp/selectCcpUploadAssignUserList.do", $("#searchForm").serialize(), function(result) {
        AUIGrid.setGridData(batchGrid, result);
    });
}

function fn_upload(){
    Common.popupDiv("/sales/ccp/ccpUploadAssignUserPop.do", $("#searchForm").serializeJSON(), null, true, 'savePop');
}

function fn_reassign(){
	var selectedItems = AUIGrid.getSelectedItems(batchGrid);
	var batchId = selectedItems[0].item.batchId;
    Common.popupDiv("/sales/ccp/ccpUploadReAssignUserDtlPop.do", {batchId : batchId}, null, true, 'ReassignPop');
	}

$.fn.clearForm = function() {
    return this.each(function() {
        var type = this.type, tag = this.tagName.toLowerCase();
        if (tag === 'form'){
            return $(':input',this).clearForm();
        }
        if (type === 'text' || type === 'password' || type === 'hidden' || tag === 'textarea'){
            this.value = '';
        }else if (type === 'checkbox' || type === 'radio'){
            this.checked = false;
        }else if (tag === 'select'){
            this.selectedIndex = -1;
        }
    });
};

</script>

<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>Sales</li>
    <li>CCP</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>CCP Upload Assign User</h2>
<ul class="right_btns">
    <c:if test="${PAGE_AUTH.funcChange == 'Y'}">
    <li><p class="btn_blue"><a href="#" onClick="fn_reassign()">Reassign</a></p></li>
    <li><p class="btn_blue"><a href="#" onClick="fn_upload()">Upload</a></p></li>
    </c:if>
    <c:if test="${PAGE_AUTH.funcView == 'Y'}">
    <%-- <li><p class="btn_blue type2"><a id="_calSearch"><span class="search"></span><spring:message code="sal.btn.search" /></a></p></li> --%>
    <li><p class="btn_blue"><a href="#" onClick="fn_searchListAjax()"><span class="search"></span><spring:message code="sal.btn.search" /></a></p></li>
    </c:if>
    <li><p class="btn_blue type2"><a href="#" onclick="javascript:$('#searchForm').clearForm();"><span class="clear"></span><spring:message code="sal.btn.clear" /></a></p></li>
</ul>
</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->
<form id="searchForm" name="searchForm" method="post">
<input type="hidden" id="batchId" />
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:160px" />
    <col style="width:*" />
    <col style="width:170px" />
    <col style="width:*" />
</colgroup>

<tbody>
<tr>
    <th scope="row">Batch No</th>
    <td><input type="text" title="" id="srBatchId" name="srBatchId" placeholder="Upload Batch Number" class="w100p" /></td>
    <th scope="row"><spring:message code="sal.text.createDate" /></th>
    <td>
	    <div class="date_set w100p"><!-- date_set start -->
	    <p><input type="text" id="srCrtStDate" name="srCrtStDate" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
	    <span>To</span>
	    <p><input type="text" id="srCrtEnDate" name="srCrtEnDate" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
	    </div><!-- date_set end -->
    </td>
    <th scope="row"><spring:message code="sal.text.creator" /></th>
    <td>
        <input type="text" title="" id="srCrtUserName" name="srCrtUserName" placeholder="Upload (Username)" class="w100p" />
    </td>
</tr>

<tr>
     <th scope="row"><spring:message code="sal.title.text.batchStus" /></th>
     <td>
     <select class="w100p" id="srBatchStatus" name="srBatchStatus" >
         <option value="1" ><spring:message code="sal.combo.text.active" /></option>
         <option value="4" selected><spring:message code="sal.combo.text.compl" /></option>
         <option value="8"><spring:message code="sal.combo.text.inactive" /></option>
     </select>
     </td>
     <th></th><td></td>
     <th></th><td></td>

            </tr>
</tbody>
</table> <!-- table end -->

</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="batch_grid_wrap" style="width:100%; height:480px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!--  content end -->
