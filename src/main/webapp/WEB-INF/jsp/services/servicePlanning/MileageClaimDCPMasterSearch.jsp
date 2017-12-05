<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">
var branchList = new Array();
var gridID1;

//페이징에 사용될 변수
var _totalRowCount;

$(document).ready(function(){
    DCPMasterGrid();
    AUIGrid.bind(gridID1, "addRow", auiAddRowHandler);
    AUIGrid.bind(gridID1, "removeRow", auiRemoveRowHandler);
    //fn_selectArea();
   
    //doGetCombo('/services/mileageCileage/selectBranch', '', '','brnch', 'S' ,  '');
    $("#memType").change(function (){
        var memType = $("#memType").val();
        var brnch = $("#brnch").val();
        if(memType == 2){
             doGetCombo('/services/mileageCileage/selectBranch', 42, '','brnch', 'S' ,  '');
             doGetCombo('/services/mileageCileage/selectCity.do', String(brnch), '','cityFrom', 'S' ,  '');
             doGetCombo('/services/mileageCileage/selectCity.do', String(brnch), '','cityTo', 'S' ,  '');
        }else if(memType == 3){
            doGetCombo('/services/mileageCileage/selectBranch', 43, '','brnch', 'S' ,  '');
            doGetCombo('/services/mileageCileage/selectCity.do', String(brnch), '','cityFrom', 'S' ,  '');
            doGetCombo('/services/mileageCileage/selectCity.do', String(brnch), '','cityTo', 'S' ,  '');
        }else{
            doGetCombo('/services/mileageCileage/selectBranch', '', '','brnch', 'S' ,  '');
            doGetCombo('/services/mileageCileage/selectCity.do', String(brnch), '','cityFrom', 'S' ,  '');
            doGetCombo('/services/mileageCileage/selectCity.do', String(brnch), '','cityTo', 'S' ,  '');
        }
     });
    
    $('#brnch').change(function() {
        var brnch = $("#brnch").val();
        //doGetCombo('/services/mileageCileage/selectDCPFrom.do', String(brnch), '','mcpFrom', 'S' ,  '');
        //doGetCombo('/services/mileageCileage/selectDCPTo.do', String(brnch), '','mcpTo', 'S' ,  '');
        doGetCombo('/services/mileageCileage/selectCity.do', String(brnch), '','cityFrom', 'S' ,  '');
        doGetCombo('/services/mileageCileage/selectCity.do', String(brnch), '','cityTo', 'S' ,  '');
    });
    
});

function getTypeComboList() {
    //var list = [ {"codeId": "P","codeName": "PUBLIC"}, {"codeId": "S","codeName": "STATE"}];
    var list = [ "CODY","CT"];
    return list;
}

//편집 핸들러
function auiCellEditingHandler(event) {
   //document.getElementById("ellapse").innerHTML = event.type  + ": ( " + event.rowIndex  + ", " + event.columnIndex + ") : " + event.value;
    
     var item = new Object();
        item.codeId="";
        item.memId="";
        
    if(event.columnIndex  ==0){
        fn_getCtCodeSearch(event.value);
        AUIGrid.setCellValue(myGridID, event.rowIndex , "codeId", event.value);
        AUIGrid.setCellValue(myGridID, event.rowIndex , "memId", "");
        
    }
    
    if(event.columnIndex  ==1){
          AUIGrid.setCellValue(myGridID, event.rowIndex , "memId", event.value);
          if(event.value == '0'){
              //fn_getCtCodeSearch(AUIGrid.getCellValue(myGridID, event.rowIndex ,2));
          }
          //fn_getCtCodeSearch(AUIGrid.getCellValue(myGridID, event.rowIndex ,0));
     }
    console.log(event);
};

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
                          { dataField : "memType", headerText  : "Member Type",    width : 100 , editable: false,
                                  editRenderer : {
                                      type : "ComboBoxRenderer",
                                      showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 보이기
                                      listFunction : function(rowIndex, columnIndex, item, dataField) {
                                          var list = getTypeComboList();
                                          return list;
                                      },
                                      keyField : "id1"
                              }},
                          { dataField : "brnchCode", headerText  : "Branch",width : 100, editable: false,
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
                          { dataField : "cityFrom", headerText  : "CITY From",  width  : 150, editable: false,
                                      editRenderer : {
                                          type : "ComboBoxRenderer",
                                          showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 보이기
                                          listFunction : function(rowIndex, columnIndex, item, dataField) {
                                              var list = getAreaComboList(); // 임의값
                                              return list;
                                          },
                                          keyField : "id1"
                                      }},
                          { dataField : "dcpFrom", headerText  : "DCP From",  width  : 200, editable: false,
                                      editRenderer : {
                                          type : "ComboBoxRenderer",
                                          showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 보이기
                                          listFunction : function(rowIndex, columnIndex, item, dataField) {
                                              var list = getAreaComboList();
                                              return list;
                                          },
                                          keyField : "id1"
                                      }},
                          { dataField : "dcpFromId", headerText  : "DCP From ID",  width  : 100, editable: false,
                                      editRenderer : {
                                          type : "ComboBoxRenderer",
                                          showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 보이기
                                          listFunction : function(rowIndex, columnIndex, item, dataField) {
                                              var list = getAreaComboList(); // 임의값
                                              return list;
                                          },
                                          keyField : "id1"
                                      }},
                          { dataField : "cityTo", headerText  : "CITY TO",  width  : 150, editable: false,
                                          editRenderer : {
                                              type : "ComboBoxRenderer",
                                              showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 보이기
                                              listFunction : function(rowIndex, columnIndex, item, dataField) {
                                                  var list = getAreaComboList(); // 임의값
                                                  return list;
                                              },
                                              keyField : "id1"
                                          }},
                          { dataField : "dcpTo",       headerText  : "DCP TO",  width  : 200, editable: false,
                                          editRenderer : {
                                              type : "ComboBoxRenderer",
                                              showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 보이기
                                              listFunction : function(rowIndex, columnIndex, item, dataField) {
                                                  var list = getAreaComboList();
                                                  return list;
                                              },
                                              keyField : "id1"
                                          }},
                          { dataField : "dcpToId", headerText  : "DCP To ID",  width  : 100, editable: false,
                                          editRenderer : {
                                              type : "ComboBoxRenderer",
                                              showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 보이기
                                              listFunction : function(rowIndex, columnIndex, item, dataField) {
                                                  var list = getAreaComboList(); // 임의값
                                                  return list;
                                              },
                                              keyField : "id1"
                                          }},
                          { dataField : "distance",       headerText  : "Distance",  width  :100, editable: true},
                          { dataField : "memType1",       headerText  : "memType1",  width  : 0, editable: false},
                          { dataField : "brnchCode1",       headerText  : "brnchCode1",  width  : 0, editable: false},
                          { dataField : "dcpFrom1",       headerText  : "dcpFrom1",  width  : 0, editable: false},
                          { dataField : "dcpFromId1",       headerText  : "dcpFromId1",  width  : 0, editable: false},
                          { dataField : "dcpTo1",       headerText  : "dcpTo1",  width  : 0, editable: false},
                          { dataField : "dcpToId1",       headerText  : "dcpToId1",  width  : 0, editable: false},
                          { dataField : "distance1",       headerText  : "distance1",  width  : 0, editable: false},
       ];

        var gridPros = { usePaging : false,  pageRowCount: 20, editable: true, selectionMode : "singleRow",  showRowNumColumn : true, showStateColumn : false};  
        
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
    
    // 171129 :: 선한이
    // Search 결과 조회
    // 마스터 그리드 리스트 조회.
    function fn_DCPMasterSearch(goPage){
        if($('#memType').val() == '') {
            Common.alert("Please Select 'Member Type'");
            return false;
        }
        
        if($('#brnch').val() == '') {
            Common.alert("Please Select 'Branch'");
            return false;
        }
        
        if(($('#mcpFrom').val() == '') && ($('#mcpTo').val() == '')) {
            Common.alert("Please write 'DCP From' or 'DCP To'");
            return false;
        }
        
        //페이징 변수 세팅
        $("#pageNo").val(goPage);   
        
        Common.ajax("GET", "/services/mileageCileage/selectDCPMaster.do", $("#DCPMasteForm").serialize(), function(result) {
            console.log("성공.");
            console.log("data : " + result);
            AUIGrid.setGridData(gridID1, result.resultList);
            
            //전체건수 세팅
            _totalRowCount = result.totalRowCount;

            //페이징 처리를 위한 옵션 설정
            var pagingPros = {
                    // 1페이지에서 보여줄 행의 수
                    rowCount : $("#rowCount").val()
            };
            
            GridCommon.createPagingNavigator(goPage, _totalRowCount , pagingPros);
            
        });
    }
    
    //마스터 그리드 페이지 이동
    function moveToPage(goPage){
      //페이징 변수 세팅
      $("#pageNo").val(goPage);
      
      // selectDCPMasterPaging.do 만드는 거부터 해야댐!!
      Common.ajax("GET", "/services/mileageCileage/selectDCPMasterPaging.do", $("#DCPMasteForm").serialize(), function(result) {
          console.log("성공.");
          console.log("data : " + result);
          AUIGrid.setGridData(gridID1, result.resultList);
          
          //페이징 처리를 위한 옵션 설정
          var pagingPros = {
                  // 1페이지에서 보여줄 행의 수
                  rowCount : $("#rowCount").val()
          };
          
          GridCommon.createPagingNavigator(goPage, _totalRowCount , pagingPros);        
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
     
     // 171204 :: 선한이
     function fn_AlldownFile() {
         var data = { "memType" : $("#memType").val() , "brnchCode": $("#brnchCode").val(), 
                            "cityFrom": $("#cityFrom").val(), "dcpFrom": $("#dcpFrom").val(), 
                            "cityTo": $("#cityTo").val(), "dcpTo": $("#dcpTo").val() };
         //var data = { "searchDt" : $("#CMM0006T_Dt").val() , "code": $("#code_06T").val(), "codeId": $("#codeGroupId").val() };
         Common.ajax("GET", "/services/mileageCileage/excel/downloadExcelFile.do", data, function(result) {
             var cnt = result;
             if(cnt > 0){
                 //var fileName = $("#fileName").val() +"_"+today;
                 var fileName="Mileage Claim Master.xlsx";
                 var searchDt = $("#CMM0006T_Dt").val();
                 var year = searchDt.substr(searchDt.indexOf("/")+1,searchDt.length);
                 var month = searchDt.substr(0,searchDt.indexOf("/"));
                 var code = $("#code_06T").val();
                 var codeId = $("#codeGroupId").val();
                 //window.location.href="<c:url value='/commExcelFile.do?fileName=" + fileName + "&year="+year+"&month="+month+"&code="+code+"&codeId="+codeId+"'/>";
                 
                 Common.showLoader();
                 $.fileDownload("/commExcelFile.do?fileName=" + fileName + "&year="+year+"&month="+month+"&code="+code+"&codeId="+codeId)
                 .done(function () {
                     Common.alert('File download a success!');                
                     Common.removeLoader();            
                 })
                 .fail(function () {
                     Common.alert('File download failed!');                
                     Common.removeLoader();            
                  });
             }
         });
     }
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
    <li><p class="btn_blue"><a href="#" onclick="javascript:fn_AlldownFile()">EXCEL DW</a></p></li>

    <li><p class="btn_blue"><a href="#" onclick="javascript:fn_DCPMasterSearch(1)"><span class="search"></span>Search</a></p></li>
    <li><p class="btn_blue"><a href="#"><span class="clear"></span>Clear</a></p></li>
</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id="DCPMasteForm">
<input type="hidden" name="rowCount" id="rowCount" value="20" />
<input type="hidden" name="pageNo" id="pageNo" />

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
    <select class="w100p" id="memType" name="memType">
        <option value="">Choose One</option>
        <option value="2">CODY</option>
        <option value="3">CT</option>
    </select>
    </td>
   <th scope="row">Branch</th>
    <td>
        <div class="search_100p"><!-- search_100p start -->
        <select class="w100p" id="brnch" name="brnch" >
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
    <th scope="row">City From</th>
    <td>
        <select class="w100p" id="cityFrom" name="cityFrom">
    </td>
    <th scope="row">DCP From</th>
    <td>
        <input type="text" title="" placeholder="DCP From" class="w100p" id="mcpFrom" name="mcpFrom">
        <%-- <select class="w100p" id="mcpFrom" name="mcpFrom">
         <c:forEach var="list" items="${selectArea}">
             <option value="${list.codeId}">${list.codeName}</option>
         </c:forEach>
        </select> --%>
    </td>
    <th scope="row"></th>
    <td></td>
</tr>
<tr>
    <th scope="row">City To</th>
    <td>
        <select class="w100p" id="cityTo" name="cityTo">
    </td>
    <th scope="row">DCP To</th>
    <td>
        <input type="text" title="" placeholder="DCP To" class="w100p" id="mcpTo" name="mcpTo">
        <%-- <select class="w100p" id="mcpTo" name="mcpTo">
         <c:forEach var="list" items="${selectArea}">
             <option value="${list.codeId}">${list.codeName}</option>
         </c:forEach>
        </select> --%>
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
    <!-- <li><p class="btn_grid"><a href="#" onclick="javascript:fn_exportTo()">EXCEL DW</a></p></li> -->
    <!-- <li><p class="btn_grid"><a href="#" onclick="javascript:removeRow()">DEL</a></p></li> -->
    <li><p class="btn_grid"><a href="#" onclick="javascript:save()">SAVE</a></p></li>
    <!-- <li><p class="btn_grid"><a href="#" onclick="javascript:addRow()">ADD</a></p></li> -->
</ul>

<!-- grid_wrap start -->
<article class="grid_wrap">
<div id="calculation_DCPMaster_grid_wap" class="grid_wrap" style="width:100%; height:400px; margin:0 auto;"></div>
<div id="grid_paging" class="aui-grid-paging-panel"></div>
</article>
<!-- grid_wrap end -->

</form>
</section><!-- search_table end -->

</section><!-- content end -->
