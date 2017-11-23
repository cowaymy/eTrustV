<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<style type="text/css">
/* 커스텀 칼럼 스타일 정의 */
.aui-grid-user-custom-left {
    text-align:left;
}
</style>
<script  type="text/javascript">

var expPopGridID;

$(document).ready(function(){
	
	 var expPopColumnLayout = [ {     /* PK , rowid 용 칼럼*/
         dataField : "rowId",
         dataType : "string",
         visible : false
     },{
         dataField : "clmType",
         headerText : '',
         visible : false,
         editable : false
     },{
         dataField : "expType",
         headerText : '<spring:message code="expense.ExpenseType" />',
         editable : false
     },{
         dataField : "expTypeName",
         headerText : '<spring:message code="expense.ExpenseTypeName" />',
         style : "aui-grid-user-custom-left",
         editable : true
     }, {
         dataField : "budgetCode",
         headerText : '<spring:message code="expense.Activity" />',
         visible : false,
         editable : false
     }, {
         dataField : "budgetCodeName",
         headerText : '<spring:message code="expense.ActivityName" />',
         style : "aui-grid-user-custom-left",
         editable : false,
         colSpan : 2
     }, {
         dataField : "",
         headerText : '',
         width: 30,
         editable : false,
         renderer : {
             type : "IconRenderer",
             iconTableRef :  {
                 "default" : "${pageContext.request.contextPath}/resources/images/common/search.png"// default
                     },         
                     iconWidth : 16,
                     iconHeight : 16,
                     onclick : function(rowIndex, columnIndex, value, item) {
                         fn_budgetCodePop(rowIndex);
                         }
                     },
         colSpan : -1
     }, {
         dataField : "glAccCode",
         headerText : '<spring:message code="expense.GLAccount" />',
         visible : false,
         editable : false
     }, {
         dataField : "glAccCodeName",
         headerText : '<spring:message code="expense.GLAccountName" />',
         style : "aui-grid-user-custom-left",
         editable : false,
         colSpan : 2
     }, {
         dataField : "",
         headerText : '<spring:message code="expense.GLAccountName" />',
         width: 30,
         editable : false,
         renderer : {
             type : "IconRenderer",
             iconTableRef :  {
                 "default" : "${pageContext.request.contextPath}/resources/images/common/search.png"// default
                     },         
                     iconWidth : 16,
                     iconHeight : 16,
                     onclick : function(rowIndex, columnIndex, value, item) {
                         fn_glAccountSearchPop(rowIndex);
                         }
                     },
        colSpan : -1
     }];
 
 var options = {
     softRemovePolicy : "exceptNew", //사용자추가한 행은 바로 삭제
     selectionMode : "multipleRows",
     autoEditCompleteMode : true
   };

    
    // AUIGrid 그리드를 생성합니다.
    //createAUIGrid();
    
  //  AUIGrid.setSelectionMode(expPopGridID, "singleRow");
    
    CommonCombo.make("claimTypeCombo", "/common/selectCodeList.do", {groupCode:'343', orderValue:'CODE'}, "", {
        id: "code",
        name: "codeName"
    }
    //, calback
    );
    
    expPopGridID = GridCommon.createAUIGrid("#addExpenseGrid", expPopColumnLayout,"rowId", options);
    
    // 행 추가 이벤트 바인딩
    AUIGrid.bind(expPopGridID, "addRow", auiAddRowHandler); 
   
    
    // 에디팅 시작 이벤트 바인딩
    AUIGrid.bind(expPopGridID, "cellEditBegin", auiCellEditignHandler);

    // 에디팅 정상 종료 이벤트 바인딩
    AUIGrid.bind(expPopGridID, "cellEditEnd", auiCellEditignHandler);

    // 에디팅 취소 이벤트 바인딩
   AUIGrid.bind(expPopGridID, "cellEditCancel", auiCellEditignHandler); 
   
    // 행 삭제 이벤트 바인딩
    AUIGrid.bind(expPopGridID, "removeRow", auiRemoveRowHandler);
    
});

//AUIGrid 메소드
function auiCellEditignHandler(event)
{
  if(event.type == "cellEditBegin")
  {
      console.log("에디팅 시작(cellEditBegin) : ( " + event.rowIndex + ", " + event.columnIndex + " ) " + event.headerText + ", value : " + event.value);
      //var menuSeq = AUIGrid.getCellValue(myGridID, event.rowIndex, 9);

      if(event.dataField == "expTypeName")
      {
    	  // 추가된 행 아이템인지 조사하여 추가된 행인 경우만 에디팅 진입 허용
        if(AUIGrid.isAddedById(expPopGridID, event.item.rowId)){  //추가된 Row
              return true; 
          } else {
              return false; // false 반환하면 기본 행위 안함(즉, cellEditBegin 의 기본행위는 에디팅 진입임)
          }
      }
  }
  else if(event.type == "cellEditEnd")
  {
      console.log("에디팅 종료(cellEditEnd) : ( " + event.rowIndex + ", " + event.columnIndex + " ) " + event.headerText + ", value : " + event.value);
  }
  else if(event.type == "cellEditCancel")
  {
      console.log("에디팅 취소(cellEditCancel) : ( " + event.rowIndex + ", " + event.columnIndex + " ) " + event.headerText + ", value : " + event.value);
  }

}

//행 추가 이벤트 핸들러
function auiAddRowHandler(event)
{
      console.log(event.type + " 이벤트\r\n" + "삽입된 행 인덱스 : " + event.rowIndex + "\r\n삽입된 행 개수 : " + event.items.length);
}
//행 삭제 이벤트 핸들러
function auiRemoveRowHandler(event)
{ 
    console.log (event.type + " 이벤트 :  " + ", 삭제된 행 개수 : " + event.items.length + ", softRemoveRowMode : " + event.softRemoveRowMode);
}

function fn_selectPopListAjax(){
	Common.ajax("GET", "/eAccounting/expense/selectExpenseList?_cacheId=" + Math.random(), $("#popAddForm").serialize(), function(result) {
        
        console.log("성공.");
        console.log( result);
        
       AUIGrid.setGridData(expPopGridID, result);
   });
}

  //MstGrid 행 추가, 삽입
function fn_AddRow()
{
    // 버튼 클릭시 cellEditCancel  이벤트 발생 제거. => 편집모드(editable=true)인 경우 해당 input 의 값을 강제적으로 편집 완료로 변경.
    AUIGrid.forceEditingComplete(expPopGridID, null, false);

    var item = new Object();
        
    if($("#claimTypeCombo").val() == ''){
    	var msg = '<spring:message code="expense.ClaimType" />';
    	
    	Common.alert("<spring:message code='sys.msg.first.Select' arguments='"+msg+"' htmlEscape='false'/>");
    	return false;
    }else{
        item.clmType = $("#claimTypeCombo").val();
        item.expType = $("#claimTypeCombo").val() + "xxx";
    } 
          item.expTypeName = "";
          item.budgetCode   ="";
          item.budgetCodeName  ="";
          item.glAccCode  ="";
          item.glAccCodeName  ="";
          item.rowId ="new";
          // parameter
          // item : 삽입하고자 하는 아이템 Object 또는 배열(배열인 경우 다수가 삽입됨)
          // rowPos : rowIndex 인 경우 해당 index 에 삽입, first : 최상단, last : 최하단, selectionUp : 선택된 곳 위, selectionDown : 선택된 곳 아래
          AUIGrid.addRow(expPopGridID, item, 'first');                    
}  

//Budget Code Pop 호출
function fn_budgetCodePop(rowIndex){
	var myValue = AUIGrid.getCellValue(expPopGridID, rowIndex, "expType").substring(2,5);
	
    if(myValue == "xxx"){
    	   Common.popupDiv("/eAccounting/expense/budgetCodeSearchPop.do", null, null, true, "budgetCodeSearchPop");
    }
}  

//Gl Account Pop 호출
function fn_glAccountSearchPop(rowIndex){
	
    var myValue = AUIGrid.getCellValue(expPopGridID, rowIndex, "expType").substring(2,5);
    
    if(myValue == "xxx"){
    	   Common.popupDiv("/eAccounting/expense/glAccountSearchPop.do", null, null, true, "glAccountSearchPop");
    }
}

function fn_save(){
	AUIGrid.forceEditingComplete(expPopGridID, null, false);

    if(fn_validation()){
        Common.confirm("<spring:message code='sys.common.alert.save'/>",fn_saveExpenseType);
    }
}

function fn_validation(){

    var result = true;
	var itemsList = AUIGrid.getAddedRowItems(expPopGridID);
	
	if (itemsList.length == 0) {
        Common.alert("<spring:message code='sys.common.alert.noChange'/>");
        return false;
    }
	
	for (var i = 0; i < itemsList.length; i++) {
        var expenseTypeName = itemsList[i].expenseTypeName;
        var glAccCode = itemsList[i].glAccCode;
        var budgetCode = itemsList[i].budgetCode;
        
        if (expenseTypeName == "") {
        	var msg = '<spring:message code="expense.ExpenseTypeName" />';
            result = false;
            Common.alert("<spring:message code='sys.common.alert.validation' arguments='"+msg+"' htmlEscape='false'/>");
            break;
        }
        if (budgetCode == "") {
        	var msg = '<spring:message code="expense.ActivityName" />';
            result = false;
            Common.alert("<spring:message code='sys.common.alert.validation' arguments='"+msg+"' htmlEscape='false'/>");
            break;
        }
        if (glAccCode == "") {
        	var msg = '<spring:message code="expense.GLAccountName" />';
            result = false;
            Common.alert("<spring:message code='sys.common.alert.validation' arguments='"+msg+"' htmlEscape='false'/>");
            break;
        }
	}
	
	return result;
	
	/* if(result){
	    Common.confirm("<spring:message code='sys.common.alert.save'/>",fn_saveExpenseType);
	} */
}

function fn_saveExpenseType(){
	
	Common.ajax("POST", "/eAccounting/expense/insertExpenseInfo", GridCommon.getEditData(expPopGridID), function(result)    {
        Common.alert(result.data  + "<spring:message code='sys.msg.savedCnt'/>");
        fn_selectPopListAjax() ;

        console.log("성공." + JSON.stringify(result));
        console.log("data : " + result.data);
        
        fn_reload();
        
        $("#addExpenseTypePop").remove();
     }
     , function(jqXHR, textStatus, errorThrown){
    	    try {
		        console.log("Fail Status : " + jqXHR.status);
		        console.log("code : "        + jqXHR.responseJSON.code);
		        console.log("message : "     + jqXHR.responseJSON.message);
		        console.log("detailMessage : "  + jqXHR.responseJSON.detailMessage);
	      }
	      catch (e)
	      {
	        console.log(e);
	      }
	      alert("Fail : " + jqXHR.responseJSON.message);
    });
}
  
function fn_setGlData (){
	 var selectedItems = AUIGrid.getSelectedItems(expPopGridID); 
	
	 if(selectedItems.length <= 0) return;
     // singleRow, singleCell 이 아닌 multiple 인 경우 선택된 개수 만큼 배열의 요소가 있음
     var first = selectedItems[0];
	 
	 AUIGrid.setCellValue(expPopGridID , first.rowIndex , "glAccCode", $("#pGlAccCode").val());
	 AUIGrid.setCellValue(expPopGridID , first.rowIndex , "glAccCodeName", $("#pGlAccCodeName").val());
}  

function  fn_setBudgetData(){
	
	var selectedItems = AUIGrid.getSelectedItems(expPopGridID); 
    
    if(selectedItems.length <= 0) return;
    // singleRow, singleCell 이 아닌 multiple 인 경우 선택된 개수 만큼 배열의 요소가 있음
    var first = selectedItems[0];
    
    AUIGrid.setCellValue(expPopGridID , first.rowIndex , "budgetCode", $("#pBudgetCode").val());
    AUIGrid.setCellValue(expPopGridID , first.rowIndex , "budgetCodeName",  $("#pBudgetCodeName").val());
    	
}
  
</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="expense.AddExpenseType" /></h1>
<ul class="right_opt">
	<li><p class="btn_blue2"><a href="#"><spring:message code="expense.CLOSE" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body" style="min-height: auto;"><!-- pop_body start -->

<ul class="right_btns mb10">
	<li><p class="btn_blue"><a href="#" onClick="javascript:fn_selectPopListAjax();"><span class="search"></span><spring:message code="expense.btn.Search" /></a></p></li>
</ul>    
<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id="popAddForm" name ="popAddForm">
    <input type="hidden" id = "pBudgetCode" name="pBudgetCode" />
    <input type="hidden" id = "pBudgetCodeName" name="pBudgetCodeName" />
    <input type="hidden" id = "pGlAccCode" name="pGlAccCode" />
    <input type="hidden" id = "pGlAccCodeName" name="pGlAccCodeName" />

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:100px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row"><spring:message code="expense.ClaimType" /></th>
	<td>
	<select id="claimTypeCombo" name="claimTypeCombo">
	</select>
	</td>
</tr>
</tbody>
</table><!-- table end -->

</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<ul class="right_opt">
	<li><p class="btn_grid"><a href="#" onclick="fn_AddRow();"><spring:message code="expense.Add" /></a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="addExpenseGrid" style="width:100%; height:300px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

<ul class="center_btns">
	<li><p class="btn_blue2 big"><a href="#" onClick="javascript:fn_save();"><spring:message code="expense.SAVE" /></a></p></li>
</ul>

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->
