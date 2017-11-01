
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>


<script type="text/javaScript">
var CTListGrid;
var CTListGrid2;
$(document).ready(function(){
	CTListGrid();
	fn_CTCode();
	CTListGrid2();
});
function fn_CTCode(){
	Common.ajax("GET", "/services/holiday/selectCTList.do", {brnchCode :'${params.branchName}' }, function(result) {
	      console.log(result);
	      AUIGrid.setGridData(CTListGrid, result);
	   });
}

function CTListGrid() {
    
    var columnLayout = [
							 {
							    dataField : "checkFlag",
							    headerText : '<input type="checkbox" id="allCheckbox" style="width:15px;height:15px;">',
							    width: 65,
							    renderer : {
							        type : "CheckBoxEditRenderer",
						            showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
					                editable : true, // 체크박스 편집 활성화 여부(기본값 : false)
					                checkValue : "1", // true, false 인 경우가 기본
					                unCheckValue : "0"
							    }
							},
                          { dataField : "memCode", headerText  : "CT Code",    width : 100 },
                          { dataField : "name", headerText  : "Name",width : 200 },
                          { dataField : "totalAssignDate", headerText  : "Total Assigned Date Count",  width  : 150},
                          { dataField : "memId", headerText  : "",  width  : 150}
       ];

        var gridPros = { usePaging : true,  pageRowCount: 20, editable: false, fixedColumnCount : 1, selectionMode : "singleRow",  showRowNumColumn : true, showStateColumn : false};  
        
        CTListGrid = GridCommon.createAUIGrid("CTList_grid_wap", columnLayout  ,"" ,gridPros);
    }
    
function CTListGrid2() {
    
    var columnLayout = [
                             {
                                dataField : "checkFlag1",
                                headerText : '<input type="checkbox" id="allCheckbox" style="width:15px;height:15px;">',
                                width: 65,
                                renderer : {
                                    type : "CheckBoxEditRenderer",
                                    showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
                                    editable : true, // 체크박스 편집 활성화 여부(기본값 : false)
                                    checkValue : "1", // true, false 인 경우가 기본
                                    unCheckValue : "0"
                                }
                            },
                          { dataField : "memCode", headerText  : "CT Code",    width : 100 },
                          { dataField : "name", headerText  : "Name",width : 200 },
                          { dataField : "totalAssignDate", headerText  : "Total Assigned Date Count",  width  : 150},
                          { dataField : "memId", headerText  : "",  width  : 150}
       ];

        var gridPros = { usePaging : true,  pageRowCount: 20, editable: false, fixedColumnCount : 1, selectionMode : "singleRow",  showRowNumColumn : true, showStateColumn : false};  
        
        CTListGrid2 = GridCommon.createAUIGrid("CTList2_grid_wap", columnLayout  ,"" ,gridPros);
    }
    
    function fn_CTAssignSave(){
        var jsonObj =  GridCommon.getEditData(CTListGrid2);
        jsonObj.form = $("#assignSaveForm").serializeJSON();
    	Common.ajax("POST", "/services/holiday/CTAssignSave.do", jsonObj,  function(result) {
            console.log(result);
         });
    }
    
    function fn_Assign(){
    	var activeItems = AUIGrid.getItemsByValue(CTListGrid, "checkFlag", "1");
    	 AUIGrid.setGridData(CTListGrid2,activeItems);
    }
    function fn_Del(){
    	var activeItems = AUIGrid.getItemsByValue(CTListGrid2, "checkFlag1", "1");
        for(var i=0; i<activeItems.length; i++){
        	AUIGrid.removeRow(CTListGrid2, i);
        	AUIGrid.removeSoftRows(CTListGrid2);
        }
    }
    $(document).ready(function(){  
        AUIGrid.bind(CTListGrid2, "removeRow", auiRemoveRowHandler);
    	
    });
    
    function auiRemoveRowHandler(){
    	
    }
</script>
<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Replacement CT Entry</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<aside class="title_line"><!-- title_line start -->
<h2>Basic Info</h2>
</aside><!-- title_line end -->
<form action="#" id="assignSaveForm">
<input type="hidden" value="<c:out value="${params.holidayType}"/>" id="holidayType" name="holidayType"/>
<input type="hidden" value="<c:out value="${params.branchName}"/>" id="branchName" name="branchName"/>
<input type="hidden" value="<c:out value="${params.holidayDesc}"/>" id="holidayDesc" name="holidayDesc"/>
<input type="hidden" value="<c:out value="${params.holiday}"/>" id="holiday" name="holiday"/>
<input type="hidden" value="<c:out value="${params.branchId}"/>" id="branchId" name="branchId"/>
<input type="hidden" value="<c:out value="${params.state}"/>" id="state" name="state"/>
<input type="hidden" value="<c:out value="${params.holidaySeq}"/>" id="holidaySeq" name="holidaySeq"/>
</form>
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:140px" />
    <col style="width:*" />
    <col style="width:140px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Holiday Type</th>
    <td>
    <c:if test="${params.holidayType == 'S' }">
    <span>State</span>
    </c:if>
    <c:if test="${params.holidayType == 'P' }">
    <span>Public</span>
    </c:if>
    </td>
    <th scope="row">Branch</th>
    <td><c:out value="${params.branchName}"/></td>
</tr>
<tr>
    <th scope="row">Holiday Name</th>
    <td><c:out value="${params.holidayDesc}"/></td>
    <th scope="row">Date</th>
    <td><c:out value="${params.holiday}"/></td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h2>Assigned CT</h2>
</aside><!-- title_line end -->

<ul class="right_btns">
    <li><p class="btn_grid"><a href="#" onclick="javascript:fn_Del()">DEL</a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="CTList2_grid_wap" style="width:100%; height:200px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

<aside class="title_line"><!-- title_line start -->
<h2>CT List</h2>
</aside><!-- title_line end -->

<ul class="right_btns">
    <li><p class="btn_grid"><a href="#" onclick="javascript:fn_Assign()">Assign</a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="CTList_grid_wap" style="width:100%; height:300px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#" onclick="javascript:fn_CTAssignSave()">Save</a></p></li>
</ul>


</section><!-- pop_body end -->

</div><!-- popup_wrap end -->
