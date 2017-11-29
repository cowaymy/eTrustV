<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">
var gridID1;
$(document).ready(function(){
	mileageCalSchemaList();
    AUIGrid.bind(gridID1, "addRow", auiAddRowHandler);
    AUIGrid.bind(gridID1, "removeRow", auiRemoveRowHandler);
});
function getTypeComboList(){
	   var list = [ "CODY","CT"];
	    return list;
}

function mileageCalSchemaList() { 
    var columnLayout = [
                          { dataField : "memType", headerText  : "Member Type",    width : 100  ,
                              editRenderer : {
                                  type : "ComboBoxRenderer",
                                  showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 보이기
                                  listFunction : function(rowIndex, columnIndex, item, dataField) {
                                      var list = getTypeComboList();
                                      return list;
                                  },
                                  keyField : "id1"
                              }},
                          { dataField : "schemId", headerText  : "Schema Code",width : 100,  editable : false},
                          { dataField : "rangeFrom", headerText  : "Range From",    width : 100 },
                          { dataField : "rangeTo", headerText  : "Range To",    width : 100 },
                          { dataField : "mileageAmt", headerText  : "Mileage Amount",    width : 100 },
                          { dataField : "deductFlag",       headerText  : "Deduct Distance",  width  : 200},
                          { dataField : "multiRate",       headerText  : "Multiple Rate",  width  :100},
                          { dataField : "applyFrom",       headerText  : "Apply From",  width  : 100,
                              editRenderer : {
                                  type : "CalendarRenderer",
                                  showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 출력 여부
                                  onlyCalendar : false, // 사용자 입력 불가, 즉 달력으로만 날짜입력 (기본값 : true)
                                  showExtraDays : true // 지난 달, 다음 달 여분의 날짜(days) 출력
                                }},
                          { dataField : "applyTo",       headerText  : "Apply To",  width  : 100,
                                    editRenderer : {
                                        type : "CalendarRenderer",
                                        showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 출력 여부
                                        onlyCalendar : false, // 사용자 입력 불가, 즉 달력으로만 날짜입력 (기본값 : true)
                                        showExtraDays : true // 지난 달, 다음 달 여분의 날짜(days) 출력
                                      }}
       ];

        var gridPros = { usePaging : true,  pageRowCount: 20, editable: true, selectionMode : "singleRow",  showRowNumColumn : true, showStateColumn : false};  
        
        gridID1 = GridCommon.createAUIGrid("calculation_schema_grid_wap", columnLayout  ,"" ,gridPros);
    }
    
    function addRow(){
    	var item = new Object();
        item.memType = "";
        item.schemaCode = "";
        item.rangeFrom = "";
        item.rangeTo = "";
        item.mileageAmt = "";
        item.deductFlag = "";
        item.multipleRate = "";
        item.applyFrom = "";
        item.applyTo = "";
       
        // parameter
        // item : 삽입하고자 하는 아이템 Object 또는 배열(배열인 경우 다수가 삽입됨)
        // rowPos : rowIndex 인 경우 해당 index 에 삽입, first : 최상단, last : 최하단, selectionUp : 선택된 곳 위, selectionDown : 선택된 곳 아래
        AUIGrid.addRow(gridID1, item, "first");
    }
    
    function save(){
    	if(vaildationCheck()){
	    	Common.ajax("POST", "/services/mileageCileage/saveSchemaMgmt.do", GridCommon.getEditData(gridID1), function(result) {
	            console.log("성공.");
	            console.log("data : " + result);
	        });
    	}
    }
    
    function fn_schemaSearch(){
    	Common.ajax("GET", "/services/mileageCileage/selectSchemaMgmt.do",$("#schemaForm").serialize() , function(result) {
            console.log("성공.");
            console.log("data : " + result);
            AUIGrid.setGridData(gridID1, result);
        });
    }
    function removeRow(){
        AUIGrid.removeRow(gridID1, "selectedIndex");
        AUIGrid.removeSoftRows(gridID1);
    }
    
    function vaildationCheck(){
    	 var result = true;
         var addList = AUIGrid.getAddedRowItems(gridID1);
         var delList = AUIGrid.getRemovedItems(gridID1);
         
         
         if (addList.length == 0 && delList.length == 0) 
         {
           Common.alert("No Change");
           return false;
         }
         

         for (var i = 0; i < addList.length; i++) 
         {
             var memType  = addList[i].memType;
             var applyFrom  = addList[i].applyFrom;
             var applyTo = addList[i].applyTo;
               if (memType == "" || memType.length == 0) {
                 result = false;
                 // {0} is required.
                 Common.alert("<spring:message code='sys.msg.necessary' arguments='Memver Type' htmlEscape='false'/>");
                 break;
               }
               
               if (applyFrom == "" || applyFrom.length == 0) {
                     result = false;
                     // {0} is required.
                     Common.alert("<spring:message code='sys.msg.necessary' arguments='Apply From' htmlEscape='false'/>");
                     break;
                   }
               
               
               if (applyTo == "" || applyTo.length == 0) {
                 result = false;
                 // {0} is required.
                 Common.alert("<spring:message code='sys.msg.necessary' arguments='Apply To' htmlEscape='false'/>");
                 break;
               }
               
         }
         
         return result;
    	
    }
</script>
<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>Sales</li>
    <li>Mileage Calculation Schema Mgmt</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>Mileage Calculation Schema Mgmt</h2>
<ul class="right_btns">
    <li><p class="btn_blue"><a href="#" onclick="javascript:fn_schemaSearch()"><span class="search"></span>Search</a></p></li>
    <li><p class="btn_blue"><a href="#"><span class="clear"></span>Clear</a></p></li>
</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id="schemaForm">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:150px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Member Type</th>
    <td>
    <select class="multy_select w100p" multiple="multiple" id="memType" name="memType">
        <option value="2">CODY</option>
        <option value="3">CT</option>
    </select>
    </td>
    <th scope="row"></th>
    <td></td>
</tr>
<tr>
    <th scope="row">Apply From</th>
    <td><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p" id="applyFrom" name="applyFrom"/></td>
    <th scope="row">Apply To</th>
    <td><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p" id="applyTo" name="applyTo"/></td>
</tr>
</tbody>
</table><!-- table end -->

<ul class="right_btns">
    <li><p class="btn_grid"><a href="#" onclick="javascript:addRow()">ADD</a></p></li>
    <!-- <li><p class="btn_grid"><a href="#">EDIT Schema</a></p></li> -->
    <li><p class="btn_grid"><a href="#" onclick="javascript:removeRow()">DEL</a></p></li>
    <li><p class="btn_grid"><a href="#" onclick="javascript:save()">SAVE</a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="calculation_schema_grid_wap" style="width:100%; height:300px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</form>
</section><!-- search_table end -->

</section><!-- content end -->

