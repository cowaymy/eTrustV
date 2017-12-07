
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>


<script type="text/javaScript">
var CTListGrid;
var CTListGrid2;
var CTListGridCount;
$(document).ready(function(){
	CTListGrid();
	CTListGrid2();
	fn_CTCode();
	//fn_AssignCTList();
});
function fn_CTCode(){
	Common.ajax("GET", "/services/holiday/selectCTList.do", $("#assignSaveForm").serialize(), function(result) {
	      console.log(result);
	      AUIGrid.setGridData(CTListGrid, result.CTList);
	      AUIGrid.setGridData(CTListGrid2, result.CTAssignList);
	     // CTListGridCount = AUIGrid.getGridData(CTListGrid).length;
	     for(var j=0; j<AUIGrid.getGridData(CTListGrid2).length; j++){
		      for(var i=0; i< AUIGrid.getGridData(CTListGrid).length; i++){
	              if(AUIGrid.getCellValue(CTListGrid, i, "memCode") == AUIGrid.getCellValue(CTListGrid2, j, "memCode")){
	            	  AUIGrid.updateRow(CTListGrid, { "checkFlag" : 1 }, i);
	              }
	              //if(AUIGrid.getCellValue(CTListGrid, i, "memCode"));
	              /* if(result[i].CTAssignList.memCode == AUIGrid.getCellValue(CTListGrid, i, "memCode")){
	                  alert(AUIGrid.getCellValue(CTListGrid, i, "memCode"));
	                  checkFlag.checked;
	              } */ 
	          }       
	     }
	});
}

function fn_AssignCTList(){
    Common.ajax("GET", "/services/holiday/selectAssignCTList.do", {holiday :'${params.holiday}' , holidayType : '${params.holidayType}' }, function(result) {
          console.log(result);
          AUIGrid.setGridData(CTListGrid2, result);
          var grdCnt = AUIGrid.getGridData(CTListGrid).length;
          alert(grdCnt);
          for(var i=0; i< AUIGrid.getGridData(CTListGrid).length; i++){
        	  alert(result.memCode);
              if(result[i].memCode == AUIGrid.getCellValue(CTListGrid, i, "memCode")){
                  alert(AUIGrid.getCellValue(CTListGrid, i, "memCode"));
                  checkFlag.checked;
              }
          }       
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
                          { dataField : "memId", headerText  : "",  width  : 0}
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
                          { dataField : "memId", headerText  : "",  width  : 0},
                          { dataField : "holidaySeq1", headerText  : "",  width  : 0},
                          { dataField : "asignSeq", headerText  : "",  width  : 0}
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
        	AUIGrid.removeRow(CTListGrid2, "selectedIndex");
        	AUIGrid.removeSoftRows(CTListGrid2);
        }
        
        for(var j=0; j<activeItems.length; j++){//위에있는 그리드
            for(var i=0; i< AUIGrid.getGridData(CTListGrid).length; i++){//아래그리드
                if(AUIGrid.getCellValue(CTListGrid, i, "memCode") == activeItems[j].memCode){
                    AUIGrid.updateRow(CTListGrid, { "checkFlag" : 0 }, i);
                }
                //if(AUIGrid.getCellValue(CTListGrid, i, "memCode"));
                /* if(result[i].CTAssignList.memCode == AUIGrid.getCellValue(CTListGrid, i, "memCode")){
                    alert(AUIGrid.getCellValue(CTListGrid, i, "memCode"));
                    checkFlag.checked;
                } */ 
            }       
       }
        
    }
    $(document).ready(function(){  
        AUIGrid.bind(CTListGrid2, "removeRow", auiRemoveRowHandler);
        
        AUIGrid.bind(CTListGrid2, "headerClick", function(event) {
            // isExclude 칼럼 클릭 한 경우
            if(event.dataField == "checkFlag1") {//remove checkrow
                if(event.orgEvent.target.id == "allCheckbox") { // 정확히 체크박스 클릭 한 경우만 적용 시킴.
                    var  isChecked = document.getElementById("allCheckbox").checked;
                    checkAll(isChecked);
                }
                return false;
            }
        });
        
        
    });
    
    function auiRemoveRowHandler(){
    	
    }
   
    function checkAll(isChecked) {
        var rowCount = AUIGrid.getRowCount(CTListGrid2);
        
        if(isChecked){   // checked == true == 1
          for(var i=0; i<rowCount; i++){
             AUIGrid.updateRow(CTListGrid2, { "checkFlag1" : 1 }, i);
          }
        }else{   // unchecked == false == 0
          for(var i=0; i<rowCount; i++){
             AUIGrid.updateRow(CTListGrid2, { "checkFlag1" : 0 }, i);
          }
        }
        
        // 헤더 체크 박스 일치시킴.
        document.getElementById("allCheckbox").checked = isChecked;
    };
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
    <span>${params.holidayType}</span>
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
