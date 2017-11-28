<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<style type="text/css">
/* 커스텀 칼럼 스타일 정의 */
.my-right-style {
    text-align:right;
}
.aui-grid-user-custom-left {
    text-align:left;
}
.aui-grid-pointer {
    cursor:pointer;
}
/* 커스텀 행 스타일 */
.my-row-style {
    background:#9FC93C;
    font-weight:bold;
    color:#22741C;
}
</style>
<script  type="text/javascript">
var adjMGridID;
var rowIndex = 0;

$(document).ready(function(){
	
    CommonCombo.make("budgetAdjType", "/common/selectCodeList.do", {groupCode:'347', orderValue:'CODE'}, "", {
        id: "code",
        name: "codeName",
        type:"M"
    });

    $("#stYearMonth").val("${stYearMonth}");
    $("#edYearMonth").val("${edYearMonth}");
    
    $("#btnSearch").click(fn_selectListAjax);
    
    
    var adjLayout = [ {
        dataField : "checkId",
        headerText : '<input type="checkbox" id="allCheckbox" style="width:15px;height:15px;">',
        cellMerge : true ,
        mergeRef : "budgetDocNo", // 이전 칼럼(대분류) 셀머지의 값을 비교해서 실행함. (mergePolicy : "restrict" 설정 필수)
        mergePolicy : "restrict",
        width : 50,
        renderer : {        	
        	type : "CheckBoxEditRenderer",
            showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
            editable : true, // 체크박스 편집 활성화 여부(기본값 : false)
            checkValue : "Y", // true, false 인 경우가 기본
            unCheckValue : "N",
            disabledFunction : function(rowIndex, columnIndex, value, isChecked, item, dataField) {
                if(item.status == "Close" || item.status == "Open")
                    return true; // true 반환하면 disabled 시킴
                return false;                    
            }
      }
    },{
        dataField : "status",
        headerText : '<spring:message code="budget.Status" />',
        cellMerge : true ,
        mergeRef : "budgetDocNo", // 이전 칼럼(대분류) 셀머지의 값을 비교해서 실행함. (mergePolicy : "restrict" 설정 필수)
        mergePolicy : "restrict",
        width : 70
    },{
        dataField : "budgetDocNo",
        headerText : '<spring:message code="budget.BudgetDoc" />',
        cellMerge : true ,
        style :"aui-grid-pointer",
        width : 100
    },{
        dataField : "costCenterText",
        headerText : '<spring:message code="budget.CostCenter" />',
        style : "aui-grid-user-custom-left ",
        cellMerge : true ,
        mergeRef : "budgetDocNo", // 이전 칼럼(대분류) 셀머지의 값을 비교해서 실행함. (mergePolicy : "restrict" 설정 필수)
        mergePolicy : "restrict",
        width : 130
    },{
        dataField : "adjYearMonth",
        headerText : '<spring:message code="budget.Month" />/<spring:message code="budget.Year" />',
        cellMerge : true ,
        mergeRef : "budgetDocNo", // 이전 칼럼(대분류) 셀머지의 값을 비교해서 실행함. (mergePolicy : "restrict" 설정 필수)
        mergePolicy : "restrict",
        width : 100
    },{
        dataField : "budgetCode",
        headerText : '<spring:message code="expense.Activity" />',
        cellMerge : true ,
        mergeRef : "budgetDocNo", // 이전 칼럼(대분류) 셀머지의 값을 비교해서 실행함. (mergePolicy : "restrict" 설정 필수)
        mergePolicy : "restrict",
        width : 100
    },{
        dataField : "budgetCodeText",
        headerText : '<spring:message code="expense.ActivityName" />',
        cellMerge : true ,
        mergeRef : "budgetDocNo", // 이전 칼럼(대분류) 셀머지의 값을 비교해서 실행함. (mergePolicy : "restrict" 설정 필수)
        mergePolicy : "restrict",
        width : 100
    }, {
        dataField : "glAccCode",
        headerText : '<spring:message code="expense.GLAccount" />',
        cellMerge : true ,
        mergeRef : "budgetDocNo", // 이전 칼럼(대분류) 셀머지의 값을 비교해서 실행함. (mergePolicy : "restrict" 설정 필수)
        mergePolicy : "restrict",
        width : 100
    },{
        dataField : "glAccDesc",
        headerText : '<spring:message code="expense.GLAccountName" />',
        cellMerge : true ,
        mergeRef : "budgetDocNo", // 이전 칼럼(대분류) 셀머지의 값을 비교해서 실행함. (mergePolicy : "restrict" 설정 필수)
        mergePolicy : "restrict",
        width : 100
    },{
        dataField : "budgetAdjType",
        headerText : '<spring:message code="budget.AdjustmentType" />',
        visible : false,
        cellMerge : true ,
        width : 150
    },{
        dataField : "budgetAdjTypeName",
        headerText : '<spring:message code="budget.AdjustmentType" />',
        width : 150
    },{
        dataField : "adjAmt",
        headerText : '<spring:message code="budget.Amount" />',
        dataType : "numeric",
        formatString : "#,##0.00",
        style : "my-right-style",
        width : 100
    },{
        dataField : "adjRem",
        headerText : '<spring:message code="budget.Remark" />',
        style : "aui-grid-user-custom-left ",
        cellMerge : true ,
        mergeRef : "budgetDocNo", // 이전 칼럼(대분류) 셀머지의 값을 비교해서 실행함. (mergePolicy : "restrict" 설정 필수)
        mergePolicy : "restrict",
        width : 150
    },{
        dataField : "fileSubPath",
        headerText : '<spring:message code="budget.View" />',
        cellMerge : true ,
        mergeRef : "budgetDocNo", // 이전 칼럼(대분류) 셀머지의 값을 비교해서 실행함. (mergePolicy : "restrict" 설정 필수)
        mergePolicy : "restrict",
        style :"aui-grid-pointer",
        width : 150
    },{
        dataField : "filePath",
        headerText : '',
        cellMerge : true ,
        mergeRef : "budgetDocNo", // 이전 칼럼(대분류) 셀머지의 값을 비교해서 실행함. (mergePolicy : "restrict" 설정 필수)
        mergePolicy : "restrict",
        visible :false
    },{
        dataField : "atchFileGrpId",
        headerText : '',
        cellMerge : true ,
        mergeRef : "budgetDocNo", // 이전 칼럼(대분류) 셀머지의 값을 비교해서 실행함. (mergePolicy : "restrict" 설정 필수)
        mergePolicy : "restrict",
        visible :false
    },{
        dataField : "availableAmt",
        headerText : '',
        dataType : "numeric",
        formatString : "#,##0.00",
        style : "my-right-style",
        width : 100,
        visible :false
    },{
        dataField : "seq",
        headerText : '',
        visible : false
    },{
        dataField : "overBudgetFlag",
        headerText : '',
        visible : false,
    }];
         
    var adjOptions = {
            enableCellMerge : true,
            showStateColumn:false,
//            selectionMode       : "singleRow", 
            selectionMode       : "singleCell", 
            showRowNumColumn    : false,
            usePaging : false,
            editable :false
      }; 
    
    adjMGridID = GridCommon.createAUIGrid("#adjMGridID", adjLayout, "seq", adjOptions);
    
    // 헤더 클릭 핸들러 바인딩
    AUIGrid.bind(adjMGridID, "headerClick", headerClickHandler);
    
    //셀 클릭 핸들러 바인딩
    AUIGrid.bind(adjMGridID, "cellClick", auiCellClikcHandler);
    
    $("#appvStus").multipleSelect("checkAll");
       
});

function auiCellClikcHandler(event){
    console.log("dataField : " +event.dataField + " rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex + " clicked"); 
    
    var str = AUIGrid.getCellValue(adjMGridID, event.rowIndex, "budgetDocNo");
    var check = AUIGrid.getCellValue(adjMGridID, event.rowIndex, "checkId");
    
    var idx = AUIGrid.getRowCount(adjMGridID); 
        
    if(event.columnIndex == 0){    	
        for(var i = 0; i < idx; i++){
            if(AUIGrid.getCellValue(adjMGridID, i, "budgetDocNo") == str){
                AUIGrid.setCellValue(adjMGridID, i, "checkId", check);
            }
        }  
    }else if(event.columnIndex == 2){  
    	$("#atchFileGrpId").val(AUIGrid.getCellValue(adjMGridID, event.rowIndex, "atchFileGrpId"));
    	$("#gridBudgetDocNo").val(AUIGrid.getCellValue(adjMGridID, event.rowIndex, "budgetDocNo"));
    	fn_budgetAdjustmentPop('grid') ;
    }else if(event.columnIndex == 13){
    	if(AUIGrid.getCellValue(adjMGridID, event.rowIndex, "fileSubPath")== "view"){
            window.open(DEFAULT_RESOURCE_FILE + AUIGrid.getCellValue(adjMGridID, event.rowIndex, "filePath"));
    	}
    }
    
}     


//리스트 조회.
function fn_selectListAjax() {        
    Common.ajax("GET", "/eAccounting/budget/selectAdjustmentList", $("#listSForm").serialize(), function(result) {
        
         console.log("성공.");
         console.log( result);
         
        AUIGrid.setGridData(adjMGridID, result);

    });
}


//Budget Code Pop 호출
function fn_budgetCodePop(){
    $("#budgetCode").val("");
    $("#budgetCodeName").val("");  
    $("#pBudgetCode").val("");
    $("#pBudgetCodeName").val(""); 
    Common.popupDiv("/eAccounting/expense/budgetCodeSearchPop.do",null, null, true, "budgetCodeSearchPop");
}  

function  fn_setBudgetData(){
	$("#budgetCode").val($("#pBudgetCode").val());
	$("#budgetCodeName").val( $("#pBudgetCodeName").val());    
}

//Gl Account Pop 호출
function fn_glAccountSearchPop(){
    $("#glAccCode").val("");
    $("#glAccCodeName").val("");     
    $("#pGlAccCode").val("");
    $("#pGlAccCodeName").val("");
    Common.popupDiv("/eAccounting/expense/glAccountSearchPop.do", null, null, true, "glAccountSearchPop");
}

function fn_setGlData (){    
	$("#glAccCode").val($("#pGlAccCode").val());
	$("#glAccCodeName").val( $("#pGlAccCodeName").val());        
}

//Cost Center
function fn_costCenterSearchPop() {
    $("#costCentr").val("");
    $("#search_costCentr").val("");
    $("#costCentrName").val("");
    $("#search_costCentrName").val("");
    Common.popupDiv("/eAccounting/webInvoice/costCenterSearchPop.do", null, null, true, "costCenterSearchPop");
}

function fn_setCostCenter (){
	$("#costCentr").val($("#search_costCentr").val());
	$("#costCentrName").val( $("#search_costCentrName").val());
}

//adjustment Pop
function fn_budgetAdjustmentPop(value) {
	
	if(value == 'pop'){
        $("#gridBudgetDocNo").val("");   
        $("#atchFileGrpId").val("");   
	}
    Common.popupDiv("/eAccounting/budget/budgetAdjustmentPop.do", $("#listSForm").serializeJSON(), fn_selectListAjax, true, "budgetAdjustmentPop");
}

//그리드 헤더 클릭 핸들러
function headerClickHandler(event) {
    
    // isActive 칼럼 클릭 한 경우
    if(event.dataField == "checkId") {
        if(event.orgEvent.target.id == "allCheckbox") { // 정확히 체크박스 클릭 한 경우만 적용 시킴.
            var  isChecked = document.getElementById("allCheckbox").checked;
        
            checkAll(isChecked);
        }
        return false;
    }
}

//전체 체크 설정, 전체 체크 해제 하기
function checkAll(isChecked) {
    
	
	 var idx = AUIGrid.getRowCount(adjMGridID); 
	
    // 그리드의 전체 데이터를 대상으로 isActive 필드를 "Active" 또는 "Inactive" 로 바꿈.
    if(isChecked) {    	
    	for(var i = 0; i < idx; i++){
            if(AUIGrid.getCellValue(adjMGridID, i, "status") != 'Close' && AUIGrid.getCellValue(adjMGridID, i, "status") != 'Request'){
                AUIGrid.setCellValue(adjMGridID, i, "checkId", "Y")
            }
        }        
    } else {
        AUIGrid.updateAllToValue(adjMGridID, "checkId", "N");
    }
    
    // 헤더 체크 박스 일치시킴.
    document.getElementById("allCheckbox").checked = isChecked;
}

function fn_budgetApproval(){   
    
    // 그리드 데이터에서 checkId 필드의 값이 Y 인 행 아이템 모두 반환
    var activeItems = AUIGrid.getItemsByValue(adjMGridID, "checkId", "Y");
    
    if(activeItems.length == 0){
    	Common.alert("<spring:message code='budget.msg.select' />");
        return;
    }
    
    if(Common.confirm("<spring:message code='sys.common.alert.save'/>", function(){
    	 
    	$("#appvStus").val("O"); // adjustment 
        $("#appvPrcssStus").val("R"); //Approval 
    	
    	 var obj = $("#listSForm").serializeJSON();   
    	 var gridData = GridCommon.getEditData(adjMGridID);
    	 obj.gridData = gridData;
            
    Common.ajax("POST", "/eAccounting/budget/saveBudgetApprovalReq", obj , function(result)    {
    	  console.log("성공." + JSON.stringify(result));
          console.log("data : " + result.data);
          
          var arryList = result.data.resultAmtList;
          var idx = arryList.length;
          
          if(idx > 0){
        	  
        	  for(var i = 0; i < idx; i++){
        		  
                  var budgetDocNo = arryList[i].budgetDocNo;
                  var costCentr = arryList[i].costCentr;
                  var budgetCode = arryList[i].budgetCode;
                  var glAccCode = arryList[i].glAccCode;
                  var adjYearMonth = arryList[i].budgetAdjMonth + "/"+ arryList[i].budgetAdjYear;
                     
                  for(var j=0; j < AUIGrid.getRowCount(adjMGridID); j++){
                      
                     var gridBudgetDoc = AUIGrid.getCellValue(adjMGridID, j, "budgetDocNo"); 
                     var gridCostCentr = AUIGrid.getCellValue(adjMGridID, j, "costCentr"); 
                     var gridBudgetCode = AUIGrid.getCellValue(adjMGridID, j, "budgetCode"); 
                     var gridGlAccCode = AUIGrid.getCellValue(adjMGridID, j, "glAccCode"); 
                     var gridAdjYearMonth = AUIGrid.getCellValue(adjMGridID, j, "adjYearMonth"); 
                     var gridBudgetAdjType = AUIGrid.getCellValue(adjMGridID, j, "budgetAdjType"); 
                     
                      if(budgetDocNo == gridBudgetDoc && gridCostCentr == costCentr && gridBudgetCode == budgetCode 
                                 && gridGlAccCode == glAccCode && gridAdjYearMonth == adjYearMonth && gridBudgetAdjType !='01') {
                          AUIGrid.setCellValue(adjMGridID, j, "overBudgetFlag","Y"); 
                      }                      
                  }
              }
          }else{
        	  fn_selectListAjax();
          }
          
          AUIGrid.setProp(adjMGridID, "rowStyleFunction", function(rowIndex, item) {
              if(item.overBudgetFlag == "Y") {
                     return "my-row-style";
                 }
                 return "";

             }); 

             // 변경된 rowStyleFunction 이 적용되도록 그리드 업데이트
             AUIGrid.update(adjMGridID);
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
         Common.alert("Fail : " + jqXHR.responseJSON.message);
          });
    
    }));
    
}

function fn_goBudgetPlan(){
	location.replace("/eAccounting/budget/monthlyBudgetList.do");
}

function fn_budgetDelete() {
	 
    // 그리드 데이터에서 checkId 필드의 값이 Y 인 행 아이템 모두 반환
    var activeItems = AUIGrid.getItemsByValue(adjMGridID, "checkId", "Y");
    
    if(activeItems.length == 0){
    	Common.alert('<spring:message code="budget.msg.delete" />');
        return;
    }
    
    if(Common.confirm("<spring:message code='sys.common.alert.delete'/>", function(){
         
         var gridData = GridCommon.getEditData(adjMGridID);
            
    Common.ajax("POST", "/eAccounting/budget/deleteBudgetAdjustment", {gridData:gridData} , function(result)    {
          console.log("성공." + JSON.stringify(result));
          console.log("data : " + result.data);
          
          fn_selectListAjax();
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
         Common.alert("Fail : " + jqXHR.responseJSON.message);
          });
    
    }));
}
</script>

<section id="content"><!-- content start -->
<ul class="path">
	<li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
	<li>Sales</li>
	<li>Order list</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2><spring:message code="budget.BudgetAdjustmentList" /></h2>
<ul class="right_btns">
	<li><p class="btn_blue"><a href="#" id="btnSearch" ><span class="search"></span><spring:message code="expense.btn.Search" /></a></p></li>
</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id="listSForm" name="listSForm">
    <input type="hidden" id = "pBudgetCode" name="pBudgetCode" />
    <input type="hidden" id = "pBudgetCodeName" name="pBudgetCodeName" />
    <input type="hidden" id = "pGlAccCode" name="pGlAccCode" />
    <input type="hidden" id = "pGlAccCodeName" name="pGlAccCodeName" />
    
    <input type="hidden" id = "search_costCentr" name="search_costCentr" />
    <input type="hidden" id = "search_costCentrName" name="search_costCentrName" />
    
    <input type="hidden" id = "gridBudgetDocNo" name="gridBudgetDocNo" />
    <input type="hidden" id = "atchFileGrpId" name="atchFileGrpId" />
    <input type="hidden" id = "budgetStatus" name="budgetStatus" />

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:140px" />
	<col style="width:*" />
	<col style="width:160px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row"><spring:message code="budget.Month" />/<spring:message code="budget.Year" /></th>
	<td>
	<div class="date_set"><!-- date_set start -->
	<p><input type="text" id="stYearMonth" name="stYearMonth" title="Create start Date" placeholder="MM/YYYY" class="j_date2"/></p>
	<span><spring:message code="budget.To" /></span>
	<p><input type="text" id="edYearMonth" name="edYearMonth" title="Create end Date" placeholder="MM/YYYY" class="j_date2" /></p>
	</div><!-- date_set end -->
	</td>
	<th scope="row"><spring:message code="budget.CostCenter" /></th>
	<td>
	<input type="text" id="costCentr" name="costCentr" title="" placeholder="" class="" />
	<input type="hidden" id="costCentrName" name="costCentrName" title="" placeholder="" class="" readonly="readonly" />
	<a href="#" class="search_btn" onclick="javascript:fn_costCenterSearchPop();"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
	</td>
</tr>
<tr>
	<th scope="row"><spring:message code="expense.GLAccount" /></th>
	<td>
	      <input type="text" id="glAccCode" name="glAccCode" title="" placeholder="" class="" />
	      <input type="hidden" id="glAccCodeName" name="glAccCodeName" title="" placeholder="" class=""  readonly="readonly" />
	      <a href="#" class="search_btn" onclick="javascript:fn_glAccountSearchPop();"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
	</td>
	<th scope="row"><spring:message code="expense.Activity" /></th>
	<td>
		<input type="text" id="budgetCode" name="budgetCode" title="" placeholder="" class="" />
		<input type="hidden" id="budgetCodeName" name="budgetCodeName" title="" placeholder="" class=""  readonly="readonly" />
		<a href="#" class="search_btn" onclick="javascript:fn_budgetCodePop();"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
	</td>
</tr>
<tr>
	<th scope="row"><spring:message code="budget.AdjustmentType" /></th>
	<td><select class="multy_select w100p" id="budgetAdjType" name="budgetAdjType" multiple="multiple"></select></td>
	<th scope="row"><spring:message code="budget.BudgetDocumentNo" /></th>
	<td><input type="text" id="budgetDocNo" name ="budgetDocNo" title="" placeholder="" class="" /></td>
</tr>
<tr>
	<th scope="row"><spring:message code="budget.Status" /></th>
	<td>
	<select id="appvStus" name="appvStus" class="multy_select w100p" multiple="multiple">
		<option value="T"><spring:message code="budget.Draft" /></option>
		<option value="O"><spring:message code="budget.Open" /></option>
		<option value="C"><spring:message code="budget.Close" /></option>
	</select>
	</td>
	<th scope="row"></th>
	<td></td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="link_btns_wrap"><!-- link_btns_wrap start -->
<p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
<dl class="link_list">
	<dt><spring:message code="budget.Link" /></dt>
	<dd>
	<ul class="btns">
		<li><p class="link_btn type2"><a href="#" onclick="javascript:fn_goBudgetPlan();"><spring:message code="budget.BudgetPlan" /></a></p></li>
	</ul>
	<p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
	</dd>
</dl>
</aside><!-- link_btns_wrap end -->

</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<ul class="right_btns">
	<li><p class="btn_grid"><a href="#" onclick="javascript:fn_budgetDelete();"><spring:message code="budget.Delete" /></a></p></li>
	<li><p class="btn_grid"><a href="#" onclick="javascript:fn_budgetAdjustmentPop('pop');"><spring:message code="budget.NewAdjustment" /></a></p></li>
	<li><p class="btn_grid"><a href="#" onclick="javascript:fn_budgetApproval();"><spring:message code="budget.Submit" /></a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="adjMGridID" style="width:100%; height:360px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- content end -->