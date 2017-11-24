<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">
var branchList = new Array();
var gridID1;
$(document).ready(function(){
	DCPMasterGrid();
    AUIGrid.bind(gridID1, "addRow", auiAddRowHandler);
    AUIGrid.bind(gridID1, "removeRow", auiRemoveRowHandler);
    //fn_selectArea();
   
    doGetCombo('/services/mileageCileage/selectBranch', '', '','brnch', 'M' ,  'f_multiCombo');
    $("#memType").change(function (){
        var memType = $("#memType").val();
        if(memType == 2){
             doGetCombo('/services/mileageCileage/selectBranch', 42, '','brnch', 'M' ,  'f_multiCombo');
        }else if(memType == 3){
            doGetCombo('/services/mileageCileage/selectBranch', 43, '','brnch', 'M' ,  'f_multiCombo');
        }else if(memType == ""){
        	doGetCombo('/services/mileageCileage/selectBranch', '', '','brnch', 'M' ,  'f_multiCombo');
        }
     });
    
    //doGetCombo('/services/mileageCileage/selectArea', '', '','mcpFrom', 'M' ,  'f_multiCombo');
    //doGetCombo('/services/mileageCileage/selectArea', '', '','mcpTo', 'M' ,  'f_multiCombo');
});

function f_multiCombo() {
    $(function() {
       
        $('#brnch').change(function() {
        }).multipleSelect({
            selectAll : true,
            width : '80%'
        });
        $('#mcpFrom').change(function() {
        }).multipleSelect({
            selectAll : true,
            width : '80%'
        }); 
        $('#mcpTo').change(function() {
        }).multipleSelect({
            selectAll : true,
            width : '80%'
        }); 
    });
}
function getTypeComboList() {
    //var list = [ {"codeId": "P","codeName": "PUBLIC"}, {"codeId": "S","codeName": "STATE"}];
   var list = [ "CODY","CT"];
    return list;
}

function fn_selectArea(){
	Common.ajax("GET", "/services/mileageCileage/selectArea", '', function(result) {
        console.log("성공.");
        console.log("AREA data : " + result);
        //AUIGrid.setGridData(gridID1, result);
    });
}
function getBrnchComboList(){
	   var list = [ "CDB-04","CDB-02"];
	    return list;
}

function getAreaComboList(){
    var list = [ "CDB-Ampang","Bentong", "Raub"];
     return list;
}
function DCPMasterGrid() { 
    var columnLayout = [
                          { dataField : "memType", headerText  : "Member Type",    width : 100 ,
                              editRenderer : {
                                  type : "ComboBoxRenderer",
                                  showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 보이기
                                  listFunction : function(rowIndex, columnIndex, item, dataField) {
                                      var list = getTypeComboList();
                                      return list;
                                  },
                                  keyField : "id1"
                              }},
                          { dataField : "brnchCode", headerText  : "Branch",width : 100,
                                  editRenderer : {
                                      type : "ComboBoxRenderer",
                                      showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 보이기
                                      listFunction : function(rowIndex, columnIndex, item, dataField) {
                                          var list = getBrnchComboList();
                                          return list;
                                      },
                                      onchange : function(rowIndex, columnIndex, value, item) {
                                    	 alert(222); 
                                      },
                                      keyField : "id1"
                                  }},
                          { dataField : "dcpFrom", headerText  : "DCP From",  width  : 200,
                                      editRenderer : {
                                          type : "ComboBoxRenderer",
                                          showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 보이기
                                          listFunction : function(rowIndex, columnIndex, item, dataField) {
                                              var list = getAreaComboList();
                                              return list;
                                          },
                                          keyField : "id1"
                                      }},
                          { dataField : "dcpTo",       headerText  : "DCP TO",  width  : 200,
                                          editRenderer : {
                                              type : "ComboBoxRenderer",
                                              showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 보이기
                                              listFunction : function(rowIndex, columnIndex, item, dataField) {
                                                  var list = getAreaComboList();
                                                  return list;
                                              },
                                              keyField : "id1"
                                          }},
                          { dataField : "distance",       headerText  : "Distance",  width  :100},
                          { dataField : "memType1",       headerText  : "memType1",  width  : 0},
                          { dataField : "brnchCode1",       headerText  : "brnchCode1",  width  : 0},
                          { dataField : "dcpFrom1",       headerText  : "dcpFrom1",  width  : 0},
                          { dataField : "dcpTo1",       headerText  : "dcpTo1",  width  : 0},
                          { dataField : "distance1",       headerText  : "distance1",  width  : 0},
       ];

        var gridPros = { usePaging : true,  pageRowCount: 20, editable: true, selectionMode : "singleRow",  showRowNumColumn : true, showStateColumn : false};  
        
        gridID1 = GridCommon.createAUIGrid("calculation_DCPMaster_grid_wap", columnLayout  ,"" ,gridPros);
    }
    
    function addRow(){
    	var item = new Object();
        item.memType = "";
        item.brnch = "";
        item.dcpForm = "";
        item.dcpTo = "";
        item.distance = "";
        // parameter
        // item : 삽입하고자 하는 아이템 Object 또는 배열(배열인 경우 다수가 삽입됨)
        // rowPos : rowIndex 인 경우 해당 index 에 삽입, first : 최상단, last : 최하단, selectionUp : 선택된 곳 위, selectionDown : 선택된 곳 아래
        AUIGrid.addRow(gridID1, item, "first");
    }
    function auiAddRowHandler(){
    	
    }
    function auiRemoveRowHandler(){
    	
    }
    function save(){
    	Common.ajax("POST", "/services/mileageCileage/saveDCPMaster.do", GridCommon.getEditData(gridID1), function(result) {
            console.log("성공.");
            console.log("data : " + result);
        });
    }
    
    function fn_DCPMasterSearch(){
    	Common.ajax("GET", "/services/mileageCileage/selectDCPMaster.do", $("#DCPMasteForm").serialize(), function(result) {
            console.log("성공.");
            console.log("data : " + result);
            AUIGrid.setGridData(gridID1, result);
        });
    }
    
    function removeRow(){
        AUIGrid.removeRow(gridID1, "selectedIndex");
        AUIGrid.removeSoftRows(gridID1);
    }
    
	 // 171123 :: 선한이
	 // 엑셀 내보내기(Export);
	 function fn_exportTo() {
		 GridCommon.exportTo("calculation_DCPMaster_grid_wap", 'xlsx', "Mileage Claim Master");
	 };
	 
	 // 엑셀 업로드
	 function fn_uploadFile() {
		 var formData = new FormData();
		   console.log("read_file: " + $("input[name=uploadfile]")[0].files[0]);
		   formData.append("excelFile", $("input[name=uploadfile]")[0].files[0]);
		 
		 Common.ajaxFile("/services/mileageCileage/excel/saveDCPMasterByExcel.do"
	               , formData
	               , function (result) 
	                {
	                     //Common.alert(result.data  + "<spring:message code='sys.msg.savedCnt'/>");
	                     if(result.code == "99"){
	                         Common.alert(" ExcelUpload "+DEFAULT_DELIMITER + result.message);
	                     }else{
	                         Common.alert(result.message);
	                     }
	            });
     };
</script>
<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>Sales</li>
    <li>Mileage Claim Master</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>Mileage Claim Master</h2>
<ul class="right_btns">

    <!-- 171123 :: 선한이 -->
    <li>
    <div class="auto_file"><!-- auto_file start -->
    <input type="file" title="file add" id="uploadfile" name="uploadfile" accept=".xlsx"/>
    </div><!-- auto_file end -->
    </li>
    <li><p class="btn_blue"><a onclick="javascript:fn_uploadFile()">Update Request</a></p></li>

    <li><p class="btn_blue"><a href="#" onclick="javascript:fn_DCPMasterSearch()"><span class="search"></span>Search</a></p></li>
    <li><p class="btn_blue"><a href="#"><span class="clear"></span>Clear</a></p></li>
</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id="DCPMasteForm">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
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
   <th scope="row">Branch</th>
    <td>
        <div class="search_100p"><!-- search_100p start -->
        <select class="multy_select w100p" multiple="multiple"id="brnch" name="brnch" >
       <%-- <c:forEach var="list" items="${branchList }">
             <option value="${list.codeId}">${list.codeName}</option>
         </c:forEach> --%>
        </select>
        </div><!-- search_100p end -->
    </td>
    <th scope="row"></th>
    <td></td>
</tr>
<tr>
    <th scope="row">DCP From</th>
    <td>
        <select class="multy_select w100p" multiple="multiple" id="mcpFrom" name="mcpFrom">
            <%-- <c:forEach var="list" items="${selectArea}">
             <option value="${list.codeId}">${list.codeName}</option>
         </c:forEach> --%>
        </select>
    </td>
    <th scope="row">DCP To</th>
    <td>
        <select class="multy_select w100p" multiple="multiple" id="mcpTo" name="mcpTo">
           <%-- <c:forEach var="list" items="${selectArea}">
             <option value="${list.codeId}">${list.codeName}</option>
         </c:forEach> --%>
        </select>
    </td>
    <th scope="row"></th>
    <td></td>
</tr>
</tbody>
</table><!-- table end -->

<ul class="right_btns">
    <!-- <li><p class="btn_grid"><a href="#">EDIT</a></p></li>
    <li><p class="btn_grid"><a href="#">NEW</a></p></li>
    <li><p class="btn_grid"><a href="#">EXCEL UP</a></p></li>
    <li><p class="btn_grid"><a href="#">EXCEL DW</a></p></li> -->
    <li><p class="btn_grid"><a href="#" onclick="javascript:fn_exportTo()">EXCEL DW</a></p></li>
    <li><p class="btn_grid"><a href="#" onclick="javascript:removeRow()">DEL</a></p></li>
    <li><p class="btn_grid"><a href="#" onclick="javascript:save()">SAVE</a></p></li>
    <li><p class="btn_grid"><a href="#" onclick="javascript:addRow()">ADD</a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="calculation_DCPMaster_grid_wap" style="width:100%; height:300px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</form>
</section><!-- search_table end -->

</section><!-- content end -->
