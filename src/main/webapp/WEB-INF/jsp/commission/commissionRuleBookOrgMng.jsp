<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp" %>

<script type="text/javaScript">

$(function(){
    //doGetCombo('/common/selectCodeList.do', '11', '','cmbCategory', 'S' , 'f_multiCombo'); //Single COMBO => Choose One
    //doGetCombo('/common/selectCodeList.do', '11', '','cmbCategory', 'A' , 'f_multiCombo'); //Single COMBO => ALL
    //doGetCombo('/common/selectCodeList.do', '11', '','cmbCategory', 'M' , 'f_multiCombo'); //Multi COMBO
    // f_multiCombo 함수 호출이 되어야만 multi combo 화면이 안깨짐.
   // doGetCombo('/common/selectCodeList.do', '11', '','cmbCategory', 'S' , 'fn_multiCombo'); 
});

function fn_multiCombo(){
    $('#cmbCategory').change(function() {
        //console.log($(this).val());
    }).multipleSelect({
        selectAll: true, // 전체선택 
        width: '100%'
    });            
}

// AUIGrid 생성 후 반환 ID
var myGridID;
var grpOrgList = new Array();
var orgList = new Array();

$(document).ready(function(){
    
    // AUIGrid 그리드를 생성합니다.
    myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout);
    
    // cellClick event.
    AUIGrid.bind(myGridID, "cellClick", function( event ) {
        console.log("rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex + " clicked");
        fn_setDetail(myGridID, event.rowIndex);
    });
    
    // 에디팅 시작 이벤트 바인딩
    AUIGrid.bind(myGridID, "cellEditBegin", auiCellEditingHandler);

    // 에디팅 정상 종료 이벤트 바인딩
    AUIGrid.bind(myGridID, "cellEditEnd", auiCellEditingHandler);
    
    // 에디팅 취소 이벤트 바인딩
    AUIGrid.bind(myGridID, "cellEditCancel", auiCellEditingHandler);
    
    // 행 추가 이벤트 바인딩 
    AUIGrid.bind(myGridID, "addRow", auiAddRowHandler);
    
    // 행 삭제 이벤트 바인딩 
    AUIGrid.bind(myGridID, "removeRow", auiRemoveRowHandler);
    
    
    //change orgCombo List
    $("#orgRgCombo").change(function(){
        if($(this).val().trim()==""){
            return;
        }
        $("#orgCombo").find('option').each(function(){
                $(this).remove();
        });            
        $("#orgGubun").val("");
        fn_getOrgListAjax();    //call orgList
    });      

});

function auiCellEditingHandler(event) {
    
    //end edit
     if(event.type == "cellEditEnd") {
         if(event.columnIndex==0){
             var val = event.value;
             var valNm = getOrgRgName(val);
             $("#orgGubun").val("G");
             AUIGrid.setCellValue(myGridID,  event.rowIndex,event.columnIndex+1, valNm);
             AUIGrid.setCellValue(myGridID,  event.rowIndex,event.columnIndex+2, "");
             /* $("#orgGrCd").val(val);
             fn_getOrgListAjax(); */
             console.debug(event.columnIndex+"==========cellEditEnd========");              
         }else  if(event.columnIndex==2){
             var val = event.value;
         //    var valNm = getOrgRgName(val);
             $("#orgGubun").val("G");
             var orgNm= AUIGrid.getCellFormatValue(myGridID, event.rowIndex, event.columnIndex);
             var data = getOrgData(val);              
             AUIGrid.setCellValue(myGridID,  event.rowIndex,event.columnIndex+1, data.split(",")[0]);
             AUIGrid.setCellValue(myGridID,  event.rowIndex,event.columnIndex+2, data.split(",")[1]);
          
             console.debug(event.columnIndex+"==========cellEditEnd========"+orgNm);   
         }
         
   //      start edit
     }else if(event.type == "cellEditBegin") {
         console.debug(event.columnIndex+"==========cellEditBegin========");     
         var orgSeq =  AUIGrid.getCellValue(myGridID,  event.rowIndex , 7);
         console.debug(orgSeq+"==========orgSeq========");     
         if( orgSeq != null && orgSeq!="" &&  event.columnIndex != 5 ){
        	 return false;
         }
         if(event.columnIndex==2){
             var val =  AUIGrid.getCellValue(myGridID,  event.rowIndex,event.columnIndex-2);
             if(val == null ||val =="" ||val=="Plese Select"){
                 alert("Please select ORG GR CD");
                 return false;
             }
             $("#orgGubun").val("G");
             var val =  AUIGrid.getCellValue(myGridID,  event.rowIndex,event.columnIndex-2);
             $("#orgGrCd").val(val);
             fn_getOrgListAjax(); 
             console.debug(event.columnIndex+"==========cellEditBegin========"+val);
         }
     }
     
/*      if(event.type == "cellEditBegin") {
        document.getElementById("editBeginDesc").innerHTML = "에디팅 시작(cellEditBegin) : ( " + event.rowIndex + ", " + event.columnIndex + " ) " + event.headerText + ", value : " + event.value + ", which : " + event.which;
    } else if(event.type == "cellEditEnd") {
        document.getElementById("editBeginEnd").innerHTML = "에디팅 종료(cellEditEnd) : ( " + event.rowIndex + ", " + event.columnIndex + " ) " + event.headerText + ", value : " + event.value + ", which : " + event.which;
    } else if(event.type == "cellEditCancel") {
        document.getElementById("editBeginEnd").innerHTML = "에디팅 취소(cellEditCancel) : ( " + event.rowIndex + ", " + event.columnIndex + " ) " + event.headerText + ", value : " + event.value + ", which : " + event.which;
    } else if(event.type == "cellEditEndBefore") {
        // 여기서 반환하는 값이 곧 에디팅 완료 값입니다.
        // 개발자가 입력한 값을 변경할 수 있습니다.
        return event.value; // 원래 값으로 적용 시킴
    } */
};

function getOrgRgName(val){
    var retStr="";
      $("#orgRgCombo").find('option').each(function(){
        if(val==$(this).val()){
            retStr=$(this).text();
        }              
     });
      return retStr;
}

function getOrgData(val){
    var retStr="";
      $.each(orgList,function(key,value){
          var id = value.id;
          if(id==val){
              retStr=value.value+","+value.cdnm;
          }
          console.debug("id:"+value.id+",cd:"+value.value+",cdnm:"+value.cdnm);
     });
      return retStr;
}

// 행 추가 이벤트 핸들러
function auiAddRowHandler(event) {
   
}

// 행 삭제 이벤트 핸들러
function auiRemoveRowHandler(event) {
    
}

//Make orgRgComboList
function getOrgRgComboList(){
    grpOrgList= new Array();
   $("#orgRgCombo").find('option').each(function(){
       var list = new Object();
       list.id= $(this).val();
       list.value= $(this).text();
       grpOrgList.push(list);
  });
  return grpOrgList;
}

//Make Use_yn ComboList
function getUseYnComboList(){     
 var list =  ["Y", "N"];   
  return list;
}

// AUIGrid 칼럼 설정
// 데이터 형태는 다음과 같은 형태임,
//[{"id":"#Cust0","date":"2014-09-03","name":"Han","country":"USA","product":"Apple","color":"Red","price":746400}, { .....} ];
var columnLayout = [ {
        dataField : "orgGrCd",
        headerText : "ORG GR CD",
        width : 120,
        editRenderer : {
            type : "ComboBoxRenderer",
            showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 보이기
            listFunction : function(rowIndex, columnIndex, item, dataField) {
               var list = getOrgRgComboList();
               return list;                 
            },
            keyField : "id",
            valueField : "value",
        }
    }, {
        dataField : "orgGrNm",
        headerText : "ORG GR NM",
        editable : false,
        width : 120
    }, {
        dataField : "orgCd",
        headerText : "ORG CD",
        width : 120,
      /*   labelFunction : function(rowIndex, columnIndex, value,
                headerText, item) {
            var retStr = "";
            for (var i = 0, len = orgList.length; i < len; i++) {
                if (orgList[i]["value"] == value) {
                    retStr = orgList[i]["id"];
                    break;
                }
            }
            return retStr == "" ? value : retStr;
        }, */
        editRenderer : {
            type : "ComboBoxRenderer",
            showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 보이기
            listFunction : function(rowIndex, columnIndex, item, dataField) {                
               console.debug("==========ComboBoxRenderer========"+orgList.length);                 
               return orgList;   
            },
            keyField : "id",
            valueField : "value"
        }
    }, {
        dataField : "orgNm",
        headerText : "ORG NAME",
        editable : false,
        width : 120
    },{
        dataField : "cdDs",
        headerText : "Description",
        editable : false,
        width : 180
    }, {
        dataField : "useYn",
        headerText : "USE YN",
        width : 120,
        editRenderer : {
            type : "ComboBoxRenderer",
            showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 보이기
            listFunction : function(rowIndex, columnIndex, item, dataField) {
               var list = getUseYnComboList();
               return list;                 
            },
            keyField : "id"
        }
    }, {
        dataField : "endDt",
        headerText : "END DATE",
        width : 120
    }, {
        dataField : "orgSeq",
        headerText : "",            
        width : 0
    }];


 // ajax list 조회.
function fn_getOrgListAjax(callBack) {      
     
    Common.ajaxSync("GET", "/commission/system/selectOrgList", $("#searchForm").serialize(), function(result) {
        orgList = new Array();
        var orgGubun = $("#orgGubun").val();            
        if(orgGubun=="G"){
            for(var i=0;i<result.length;i++){
                 var list = new Object();
                  list.id= result[i].cdid;
                  list.value= result[i].cd;
                  list.cdnm= result[i].cdnm;
                  orgList.push(list);                    
            }
        }else{
                $("#orgCombo").append("<option value='' ></option>");
            for(var i=0;i<result.length;i++){
                $("#orgCombo").append("<option value='"+result[i].cdid + "' > "+result[i].cd+"</option>");
            }   
        }
        if(callBack){               
            callBack(orgList);
        }
       // AUIGrid.setGridData(myGridID, result);
    });
} 

// ajax list 조회.
function fn_getRuleBookMngListAjax() {        
    Common.ajax("GET", "/commission/system/selectRuleBookMngList", $("#searchForm").serialize(), function(result) {
        console.log("성공.");
        console.log("data : " + result);
        AUIGrid.setGridData(myGridID, result);
    });
}

// 컬럼 선택시 상세정보 세팅.
function fn_setDetail(gridID, rowIdx){      
    
  //$("#id").val(GridCommon.getCellValue(gridID, rowIdx, "id"));
    //$("#name").val(GridCommon.getCellValue(gridID, rowIdx, "name"));
    //$("#description").val(GridCommon.getCellValue(gridID, rowIdx, "description"));
    
   $("#id").val(AUIGrid.getCellValue(gridID, rowIdx, "id"));                    
   $("#name").val(AUIGrid.getCellValue(gridID, rowIdx, "name"));
   $("#description").val(AUIGrid.getCellValue(gridID, rowIdx, "description")); 
}

var cnt = 0;
// 행 추가, 삽입
function addRow() {
    
//    var rowPos = document.getElementById("addSelect").value;
    
    var item = new Object();
    item.orgGrCd  ="Plese Select";
    item.orgGrNm ="";
    item.orgCd       ="Plese Select"  ;
    item.orgNm       ="";  
    item.cdDs       ="";
    item.useYn        ="Y";
    item.endDt="";
    item.orgSeq ="";
     
  
    // parameter
    // item : 삽입하고자 하는 아이템 Object 또는 배열(배열인 경우 다수가 삽입됨)
    // rowPos : rowIndex 인 경우 해당 index 에 삽입, first : 최상단, last : 최하단, selectionUp : 선택된 곳 위, selectionDown : 선택된 곳 아래
    AUIGrid.addRow(myGridID, item,"first");
}

//서버로 전송.
function fn_saveGridMap() {
    Common.ajax("POST", "/commission/system/saveCommissionGrid.do",
            GridCommon.getEditData(myGridID), function(result) {
                alert("Success!");
              
                console.log("성공.");
                console.log("data : " + result);
                fn_getRuleBookMngListAjax();
            }, function(jqXHR, textStatus, errorThrown) {
                try {
                    console.log("status : " + jqXHR.status);
                    console
                            .log("code : "
                                    + jqXHR.responseJSON.code);
                    console.log("message : "
                            + jqXHR.responseJSON.message);
                    console.log("detailMessage : "
                            + jqXHR.responseJSON.detailMessage);
                } catch (e) {
                    console.log(e);
                }

                alert("Fail : " + jqXHR.responseJSON.message);

                fn_getSampleListAjax();
            });
}
</script>


<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="image/path_home.gif" alt="Home" /></li>
    <li>Sales</li>
    <li>Order list</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>Commission Rule Book Management</h2>
<ul class="right_opt">
    <li><p class="btn_blue"><a href="javascript:fn_saveGridMap();">Save</a></p></li>
</ul>
</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->
<form id="searchForm" action="" method="post">

<table class="type1"><!-- table start -->
<caption>search table</caption>
<colgroup>
    <col style="width:110px" />
    <col style="width:*" />
    <col style="width:110px" />
    <col style="width:*" />
    <col style="width:100px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Month/Year</th>
    <td>
    <input type="text" id="searchDt" name="searchDt" title="Month/Year" class="j_date2" value="${searchDt }" />
    </td>
    <th scope="row">ORG Group</th>
    <td>   
    <select id="orgRgCombo" name="orgRgCombo" class="w100p">
                     <option value=""></option>
                <c:forEach var="list" items="${orgGrList }">
                    <option value="${list.cdid}">${list.cd}</option>
                </c:forEach>
            </select>
    </td>
    <th scope="row">ORG Code</th>
    <td>   
    <select id="orgCombo" name="orgCombo"  class="w100p">
            <option value=""></option>
                <c:forEach var="list" items="${orgList }">
                    <option value="${list.cdid}">${list.cd}</option>
                </c:forEach>
            </select> 
    </td>
    <input type="hidden" id="orgGubun" name="orgGubun" value="">       
    <input type="hidden" id="orgGrCd" name="orgGrCd" value="">    
</tr>
</tbody>
</table><!-- table end -->

<ul class="right_btns">
    <li><p class="btn_gray"><a href="javascript:fn_getRuleBookMngListAjax();"><span class="search"></span>Search</a></p></li>
</ul>
</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->
<ul class="right_btns">
  <!--   <li><p class="btn_grid"><a href="#"><span class="search"></span>EXCEL UP</a></p></li>
    <li><p class="btn_grid"><a href="#"><span class="search"></span>EXCEL DW</a></p></li>
    <li><p class="btn_grid"><a href="#"><span class="search"></span>DEL</a></p></li>
    <li><p class="btn_grid"><a href="#"><span class="search"></span>INS</a></p></li> -->
    <li><p class="btn_grid"><a href="javascript:addRow();"><span class="search"></span>ADD</a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="grid_wrap" style="width:1600px; height:500px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- content end -->
        
</section><!-- container end -->
<hr />

</div><!-- wrap end -->
</body>
</html>
        
