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
    
    // AUIGrid 그리드를 생성합니다.
    createAUIGrid();
    
    AUIGrid.setSelectionMode(expPopGridID, "singleRow");
    
    CommonCombo.make("popClaimType", "/common/selectCodeList.do", {groupCode:'343', orderValue:'CODE'}, "", {
        id: "code",
        name: "codeName"
    }
    //, calback
    );
    
});

function createAUIGrid() {
    // AUIGrid 칼럼 설정
    
    // 데이터 형태는 다음과 같은 형태임,
    //[{"id":"#Cust0","date":"2014-09-03","name":"Han","country":"USA","product":"Apple","color":"Red","price":746400}, { .....} ];
    var columnLayout = [ {
	        dataField : "clmType",
	        headerText : '',
            visible : false,
	        editable : false
	    },{
            dataField : "expType",
            headerText : '<spring:message code="expense.ExpenseType" />',
            width : 100,
            editable : false
        },{
            dataField : "expTypeName",
            headerText : '<spring:message code="expense.ExpenseTypeName" />',
            style : "aui-grid-user-custom-left",
            width : 230,
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
            width : 230,
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
            width : 230,
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
   
    //그리드 속성 설정
    var gridPros = {
        usePaging           : false,             //페이징 사용
        pageRowCount        : 20,           //한 화면에 출력되는 행 개수 20(기본값:20)            
        editable                : true,            
        fixedColumnCount    : 2,            
        showStateColumn     : true,             
        displayTreeOpen     : false,            
        selectionMode       : "singleRow",  //"multipleCells",            
        headerHeight        : 30,       
        useGroupingPanel    : false,        //그룹핑 패널 사용
        skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
        wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
        showRowNumColumn    : true,         //줄번호 칼럼 렌더러 출력   
        noDataMessage       :  gridMsg["sys.info.grid.noDataMessage"],
        groupingMessage     : gridMsg["sys.info.grid.groupingMessage"],
        softRemovePolicy : "exceptNew", //사용자추가한 행은 바로 삭제
    }; 
    
    expPopGridID = AUIGrid.create("#popGrid_wrap", columnLayout, gridPros);
    
     // 행 추가 이벤트 바인딩
    AUIGrid.bind(expPopGridID, "addRow", auiAddRowHandler); 

    /* // 셀 에디팅 바인딩
    AUIGrid.bind(expPopGridID, "cellEditBegin", function(event) {    	
       if(event.dataField == "expTypeName") {
    	   
    	   var str = event.item.expType.substring(2,5);
    	   
            if(str != "xxx") {
                return false;
            }
        } 
    }); */
    
    
    // 에디팅 시작 이벤트 바인딩
    AUIGrid.bind(myGridID, "cellEditBegin", function(event) {
        
        if(event.dataField == "expTypeName") {
            // 추가된 행 아이템인지 조사하여 추가된 행인 경우만 에디팅 진입 허용
            if(AUIGrid.isAddedById(event.pid, event.item.id)) {
                return true; 
            } else {
                return false; // false 반환하면 기본 행위 안함(즉, cellEditBegin 의 기본행위는 에디팅 진입임)
            }
        }
        return false; // 다른 필드들은 편집 허용
    });
    

    // 행 삭제 이벤트 바인딩
    AUIGrid.bind(myGridID, "removeRow", auiRemoveRowHandler);

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
	Common.ajax("GET", "/eAccounting/expense/selectExpenseList", $("#popSForm").serialize(), function(result) {
        
        console.log("성공.");
        console.log( result);
        
       AUIGrid.setGridData(expPopGridID, result);
   });
}

  //MstGrid 행 추가, 삽입
function fn_AddRow()
{
    var item = new Object();
        
    if($("#popClaimType").val() == ''){
    	Common.alert("<spring:message code='sys.msg.first.Select' arguments='clmType' htmlEscape='false'/>");
    	return false;
    }else{
        item.clmType = $("#popClaimType").val();
        item.expType = $("#popClaimType").val() + "xxx";
    } 
          item.expTypeName = "";
          item.budgetCode   ="";
          item.budgetCodeName  ="";
          item.glAccCode  ="";
          item.glAccCodeName  ="";
          // parameter
          // item : 삽입하고자 하는 아이템 Object 또는 배열(배열인 경우 다수가 삽입됨)
          // rowPos : rowIndex 인 경우 해당 index 에 삽입, first : 최상단, last : 최하단, selectionUp : 선택된 곳 위, selectionDown : 선택된 곳 아래
          AUIGrid.addRow(expPopGridID, item, 'last');                    
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
            result = false;
            Common.alert("<spring:message code='sys.common.alert.validation' arguments='Expense Type Name' htmlEscape='false'/>");
            break;
        }
        if (budgetCode == "") {
            result = false;
            Common.alert("<spring:message code='sys.common.alert.validation' arguments='Activity Name' htmlEscape='false'/>");
            break;
        }
        if (glAccCode == "") {
            result = false;
            Common.alert("<spring:message code='sys.common.alert.validation' arguments='Gl Account Name' htmlEscape='false'/>");
            break;
        }
	}
	
	if(result){
	    Common.confirm("<spring:message code='sys.common.alert.save'/>",fn_saveExpenseType);
	}
}

function fn_saveExpenseType(){
	
	Common.ajax("POST", "/eAccounting/expense/insertExpenseInfo", GridCommon.getEditData(expPopGridID), function(result)    {
        Common.alert(result.data  + "<spring:message code='sys.msg.savedCnt'/>");
        fn_selectPopListAjax() ;

        console.log("성공." + JSON.stringify(result));
        console.log("data : " + result.data);
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
  
</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="expense.AddExpenseType" /></h1>
<ul class="right_opt">
	<li><p class="btn_blue2"><a href="#"><spring:message code="expense.CLOSE" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<ul class="right_btns mb10">
	<li><p class="btn_blue2"><a href="#" onClick="javascript:fn_selectPopListAjax();"><spring:message code="expense.btn.Search" /></a></p></li>
</ul>    
<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id="popSForm" name ="popSForm">

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
	<select class="multy_select" id="popClaimType" name="popClaimType">
	</select>
	</td>
</tr>
</tbody>
</table><!-- table end -->

</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<ul class="right_btns">
	<li><p class="btn_grid"><a href="#" onclick="fn_AddRow();"><spring:message code="expense.Add" /></a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="popGrid_wrap" style="width:100%; height:300px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

<ul class="center_btns">
	<li><p class="btn_blue2 big"><a href="#" onClick="javascript:fn_save();"><spring:message code="expense.SAVE" /></a></p></li>
</ul>

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->

</body>
</html>