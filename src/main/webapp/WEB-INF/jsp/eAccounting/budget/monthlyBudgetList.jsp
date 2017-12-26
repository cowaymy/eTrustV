<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<style type="text/css">
/* 커스텀 칼럼 스타일 정의 */
.aui-grid-user-custom-left {
    text-align:left;
}
.my-right-style {
    text-align:right;
    cursor:pointer;
}
.my-custom-style1 {
    text-align:right;
    background:rgba(206, 251, 201, 0.2);
    font-weight:bold;
}
.my-custom-style2 {
    text-align:right;
    background:rgba(206, 251, 201, 0.2);
    font-weight:bold;
}
.my-custom-style3 {
    text-align:right;
    color:#4641D9;
    font-weight:bold;
}
</style>
<script  type="text/javascript">
var budgetMGrid;

$(document).ready(function(){
    
    //엑셀 다운
    $('#excelDown').click(function() {        
       GridCommon.exportTo("budgetMGrid", 'xlsx', "<spring:message code='budget.MonthlyBudgetInterchange' />");
    });
    
    //그리드 생성
    fn_makeGrid();
     
});


//리스트 조회.
function fn_selectListAjax() {  
    var stMsg = '<spring:message code="fcm.startValue" />'; //시작값
    var edMsg = '<spring:message code="fcm.endValue" />'; //종료값 
        
     if ($("#budgetPlanYear").val() == "")
     {       
         var msg = '<spring:message code="budget.Year" />';
         Common.alert("<spring:message code='sys.msg.necessary' arguments='"+msg+"' htmlEscape='false'/>" , function(){
             $("#budgetPlanYear").focus();
         });
         return;
     }
     
     if ($("#stCostCentr").val() != "" || $("#edCostCentr").val() != "")
     {
         var msg = '<spring:message code="budget.CostCenter" />';
             if($("#stCostCentr").val() == "" ){
                 Common.alert("<spring:message code='sys.msg.necessary' arguments='"+msg+"' htmlEscape='false'/>" , function(){
                         $("#stCostCentr").focus();
                 });
                 return;
             }
             /* else if($("#edCostCentr").val() == "" ){

                 Common.alert("<spring:message code='sys.msg.necessary' arguments='"+msg+"' htmlEscape='false'/>" , function(){
                         $("#edCostCentr").focus();
                 });
                 return;
             } */

             if ($("#stCostCentr").val() != "" && $("#edCostCentr").val() != "")
             {       
                     if($("#stCostCentr").val() > $("#edCostCentr").val() ){

                         Common.alert("<spring:message code='sys.msg.mustMore' arguments='"+stMsg+" ; "+edMsg+"' htmlEscape='false' argumentSeparator=';' />");

                         return; 
                     }
             }
        
     }
     
    
       if ($("#stGlAccCode").val() != "" || $("#edGlAccCode").val() != "")
         {
             var msg = '<spring:message code="expense.GLAccount" />';
                 
                 if($("#stGlAccCode").val() == "" ){
                     Common.alert("<spring:message code='sys.msg.necessary' arguments='"+msg+"' htmlEscape='false'/>" , function(){
                           $("#stGlAccCode").focus();
                     });
                     return;
                 }
                 /* else if($("#edGlAccCode").val() == "" ){
                     Common.alert("<spring:message code='sys.msg.necessary' arguments='"+msg+"' htmlEscape='false'/>" , function(){
                           $("#edGlAccCode").focus()
                     });
                     return;
                 }   */    
                 
                 if ($("#stGlAccCode").val() != "" && $("#edGlAccCode").val() != ""){
                     
                     if($("#stGlAccCode").val() >   $("#edGlAccCode").val() ){
                         Common.alert("<spring:message code='sys.msg.mustMore' arguments='"+stMsg+" ; "+edMsg+"' htmlEscape='false' argumentSeparator=';' />");
                         return;
                     }
                 }             
         }

       if ($("#stBudgetCode").val() != "" || $("#edBudgetCode").val() != "")
       {
           var msg = '<spring:message code="expense.Activity" />';
           
           if($("#stBudgetCode").val() == "" ){
               Common.alert("<spring:message code='sys.msg.necessary' arguments='"+msg+"' htmlEscape='false'/>" , function(){
                    $("#stBudgetCode").focus();
               });
               return;
           }
           /* else if($("#edBudgetCode").val() == "" ){

               Common.alert("<spring:message code='sys.msg.necessary' arguments='"+msg+"' htmlEscape='false'/>" , function(){
                    $("#edBudgetCode").focus();
               });
               return;
           } */  
           
           if ($("#stBudgetCode").val() != "" && $("#edBudgetCode").val() != ""){
               
               if($("#stBudgetCode").val() >   $("#edBudgetCode").val() ){
                   Common.alert("<spring:message code='sys.msg.mustMore' arguments='"+stMsg+" ; "+edMsg+"' htmlEscape='false' argumentSeparator=';' />");
                   return;
               }
           }
       }
    
    Common.ajax("GET", "/eAccounting/budget/selectMonthlyBudgetList", $("#listSForm").serialize(), function(result) {
            
        console.log("성공.");
        console.log( result);

        if($("#stMonth").val() !="" && $("#edMonth").val() !=""){
                
            AUIGrid.destroy(budgetMGrid);// 그리드 삭제
                 
            var index = parseInt($("#edMonth").val())  - parseInt($("#stMonth").val()) ;
                
            fn_makeGrid();

        }            
           
        AUIGrid.setGridData(budgetMGrid, result);
         
        fn_total(); //total 값 계산
    }); 
}

//total 값 계산
function fn_total(){

    var index = parseInt($("#edMonth").val())  - parseInt($("#stMonth").val()) ;
    var mon = parseInt($("#stMonth").val());
    
    var idx = AUIGrid.getRowCount(budgetMGrid); 
    
    for(var i= 0 ; i < idx ; i++) { //

        var total = 0;    
        for(var j= mon ; j <= mon+index; j++) {
            total += parseInt(AUIGrid.getCellValue(budgetMGrid , i , "m"+j));
        }

        AUIGrid.setCellValue(budgetMGrid, i, "total", total);
    }
    

    AUIGrid.setCellMerge(budgetMGrid, true);
}

function fn_makeGrid(){

    var monPop = [];
    
    monPop[0] = {dataField : "costCentr",
            headerText : '<spring:message code="budget.CostCenter" />',
            width : 100,
            cellMerge : true 
    }
    
    monPop.push({
                    dataField : "budgetPlanYear",
                    headerText : '',
                    width : 100,
                    visible : false
                },{
                    dataField : "costCenterText",
                    headerText : '<spring:message code="budget.costCenterName" />',
                    width : 100,
                    cellMerge : true 
                },{
                    dataField : "budgetCode",
                    headerText : '<spring:message code="expense.Activity" />',
                    width : 100
                },{
                    dataField : "budgetCodeText",
                    headerText : '<spring:message code="budget.budgetName" />',
                    width : 100
                },{
                    dataField : "glAccCode",
                    headerText : '<spring:message code="expense.GLAccount" />',
                    width : 100
                },{
                    dataField : "glAccDesc",
                    headerText : '<spring:message code="budget.GLDescription" />',
                    width : 100
                },{
                    dataField : "cntrlType",
                    headerText : '<spring:message code="budget.ControlType" />',
                    width : 50
                });
    
    
    
    if($("#stMonth").val() !="" && $("#edMonth").val() !=""){
        var index = parseInt($("#edMonth").val())  - parseInt($("#stMonth").val()) ;
        var mon = parseInt($("#stMonth").val());
               
        for(var i= mon ; i <= mon+index; i++) { //
                var msg ;               
            if(i == 1){
                msg = "<spring:message code='budget.1' />";
            }else if(i == 2){
                msg = "<spring:message code='budget.2' />";
            }else if(i == 3){
                msg = "<spring:message code='budget.3' />";
            }else if(i == 4){
                msg = "<spring:message code='budget.4' />";
            }else if(i == 5){
                msg = "<spring:message code='budget.5' />";
            }else if(i == 6){
                msg = "<spring:message code='budget.6' />";
            }else if(i == 7){
                msg = "<spring:message code='budget.7' />";
            }else if(i == 8){
                msg = "<spring:message code='budget.8' />";
            }else if(i == 9){
                msg = "<spring:message code='budget.9' />";
            }else if(i == 10){
                msg = "<spring:message code='budget.10' />";
            }else if(i == 11){
                msg = "<spring:message code='budget.11' />";
            }else if(i == 12){
                msg = "<spring:message code='budget.12' />";
            }
            
            
            monPop.push( {
                 dataField : "m"+i,
                 headerText :msg,
                 width : 80,
                 dataType : "numeric",
                 formatString : "#,##0.00",
                 style : "my-right-style",
                 editable : false
            });
        }
    } 
    
    monPop.push( {
        editable : false,
        headerText : "<spring:message code='budget.Total' />",
        dataField : "total", // 임의로 지정하십시오. expFunction 에서 반환된 값이 여기에 보관됩니다.
        headerStyle : "my-right-style",
        style : "my-custom-style1",
        dataType : "numeric",
        formatString : "#,##0.00",
        width:120
    });
    
    
	 var monFooter = [];
	    
	 monFooter[0] = {
		        labelText : "<spring:message code='budget.Total' />",
		        positionField : "glAccDesc"
		    }
 
 
	for(var i= mon ; i <= mon+index; i++) {
		 monFooter.push( {
	         dataField : "m"+i,
	         positionField : "m"+i,
	         operation : "SUM",
	         formatString : "#,##0.00"
	    });
	 }
	 
	 monFooter.push( {
	        dataField : "total", // 임의로 지정하십시오. expFunction 에서 반환된 값이 여기에 보관됩니다.
            positionField : "total",
            operation : "SUM",
            formatString : "#,##0.00"
	    });
	    
     var monOptions = {
            enableCellMerge : true,
            showStateColumn:false,
            fixedColumnCount    : 7,
            showRowNumColumn    : false,
            usePaging : false,
            showFooter : true
      }; 
    
    budgetMGrid = GridCommon.createAUIGrid("#budgetMGrid", monPop, "", monOptions);
    // 푸터 객체 세팅
    AUIGrid.setFooter(budgetMGrid, monFooter);
    
    AUIGrid.bind(budgetMGrid, "cellClick", auiCellClikcHandler);
}
      
function auiCellClikcHandler(event){
    console.log("dataField : " +event.dataField + " rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex + " clicked"); 
    
    var month = event.dataField.replace("m", "");   
    
     
    
    if(event.columnIndex > 6){
    	if(event.headerText !="Total"){
    		Common.popupDiv("/eAccounting/budget/availableBudgetDisplayPop.do",{item : event.item, month:month}, null, true, "availableBudgetDisplayPop");	
    	}
    }    
    
}      
      
var budgetStr ;
//Budget Code Pop 호출
function fn_budgetCodePop(str){
    budgetStr = str;
    Common.popupDiv("/eAccounting/expense/budgetCodeSearchPop.do",null, null, true, "budgetCodeSearchPop");
}  


function  fn_setBudgetData(){
    if(budgetStr == "st"){
        $("#stBudgetCode").val($("#pBudgetCode").val());
        $("#stBudgetCodeName").val( $("#pBudgetCodeName").val());
    }else{
        $("#edBudgetCode").val($("#pBudgetCode").val());
        $("#edBudgetCodeName").val( $("#pBudgetCodeName").val());
    }
    
}

//Gl Account Pop 호출
var glStr ;
function fn_glAccountSearchPop(str){
    glStr = str;
    Common.popupDiv("/eAccounting/expense/glAccountSearchPop.do", null, null, true, "glAccountSearchPop");
}

function fn_setGlData (str){
    
    if(glStr =="st"){
        $("#stGlAccCode").val($("#pGlAccCode").val());
        $("#stGlAccCodeName").val( $("#pGlAccCodeName").val());
    }else{
        $("#edGlAccCode").val($("#pGlAccCode").val());
        $("#edGlAccCodeName").val( $("#pGlAccCodeName").val());
    }
        
}

//Cost Center
var costStr ;
function fn_costCenterSearchPop(str) {
    costStr = str;
    Common.popupDiv("/eAccounting/webInvoice/costCenterSearchPop.do", null, null, true, "costCenterSearchPop");
}

function fn_setCostCenter (str){
    
    if(costStr =="st"){
        $("#stCostCentr").val($("#search_costCentr").val());
        $("#stCostCentrName").val( $("#search_costCentrName").val());
    }else{
        $("#edCostCentr").val($("#search_costCentr").val());
        $("#edCostCentrName").val( $("#search_costCentrName").val());
    }
        
}

function fn_excelDown(){

    AUIGrid.exportToXlsx(budgetMGrid);
}


function fn_goAdjustMent(){
    location.replace("/eAccounting/budget/budgetAdjustmentList.do");
}

function fn_goApproval(){
    location.replace("/eAccounting/budget/budgetApprove.do");
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
<h2><spring:message code="budget.MonthlyBudgetInterchange" /></h2>
<ul class="right_btns">
    <c:if test="${PAGE_AUTH.funcView == 'Y'}">
    <li><p class="btn_blue"><a href="#" onClick="javascript:fn_selectListAjax();" ><span class="search"></span><spring:message code="expense.btn.Search" /></a></p></li>
    </c:if>
</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id="listSForm">
    <input type="hidden" id = "pBudgetCode" name="pBudgetCode" />
    <input type="hidden" id = "pBudgetCodeName" name="pBudgetCodeName" />
    <input type="hidden" id = "pGlAccCode" name="pGlAccCode" />
    <input type="hidden" id = "pGlAccCodeName" name="pGlAccCodeName" />
    
    <input type="hidden" id = "search_costCentr" name="search_costCentr" />
    <input type="hidden" id = "search_costCentrName" name="search_costCentrName" />

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:10%" />
    <col style="width:15%" />
    <col style="width:10%" />
    <col style="width:15%" />
    <col style="width:110px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="budget.Year" /></th>
    <td><input type="text" title="" id="budgetPlanYear" name="budgetPlanYear" placeholder="" class="w100p" value="${year}" /></td>
    <th scope="row"><spring:message code="budget.Month" /></th>
    <td>
    <div class="date_set w100p"><!-- date_set start -->
    <p class=""><input type="text" id="stMonth" name="stMonth" title="" placeholder="" class="w100p" value="01" /></p>
    <span>~</span>
    <p class=""><input type="text" id="edMonth" name="edMonth" title="" placeholder="" class="w100p" value="12" /></p>
    </div><!-- date_set end -->
    </td>
    <th scope="row"><spring:message code="budget.CostCenter" /></th>
    <td>
    <div class="date_set w100p"><!-- date_set start -->
    <p class="search_type"><input type="hidden" id="stCostCentrName" name="stCostCentrName" title="" placeholder="" class="fl_left" />
    <input type="text" id="stCostCentr" name="stCostCentr" title="" placeholder="" class="fl_left" />
    <a href="#" class="search_btn"  onclick="javascript:fn_costCenterSearchPop('st')"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a></p>
    <span>~</span>
    <p class="search_type"><input type="hidden" id="edCostCentrName" name="edCostCentrName" title="" placeholder="" class="fl_left" />
    <input type="text" id="edCostCentr" name="edCostCentr" title="" placeholder="" class="fl_left" />
    <a href="#" class="search_btn" onclick="javascript:fn_costCenterSearchPop('ed')"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a></p>
    </div><!-- date_set end -->
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="expense.GLAccount" /></th>
    <td colspan="3">
    <div class="date_set w100p"><!-- date_set start -->
    <p class="search_type"><input type="hidden" id= "stGlAccCodeName" name="stGlAccCodeName" title="" placeholder="" class="fl_left" />
    <input type="text" id= "stGlAccCode" name="stGlAccCode" title="" placeholder="" class="fl_left" />
    <a href="#" class="search_btn" onclick="javascript:fn_glAccountSearchPop('st')"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a></p>
    <span>~</span>
    <p class="search_type"><input type="hidden" id= "edGlAccCodeName" name= "edGlAccCodeName" title="" placeholder="" class="fl_left" />
    <input type="text" id= "edGlAccCode" name= "edGlAccCode" title="" placeholder="" class="fl_left" />
    <a href="#" class="search_btn" onclick="javascript:fn_glAccountSearchPop('ed')"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a></p>
    </div><!-- date_set end -->
    </td>
    <th scope="row"><spring:message code="expense.Activity" /></th>
    <td>
    <div class="date_set w100p"><!-- date_set start -->
    <p class="search_type">
    <input type="hidden"title=""  id= "stBudgetCodeName" name= "stBudgetCodeName" placeholder="" class="fl_left" />
    <input type="text"  id= "stBudgetCode" name= "stBudgetCode" placeholder="" class="fl_left" />
    <a href="#" class="search_btn" onclick="javascript:fn_budgetCodePop('st')">
    <img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a></p>
    <span>~</span>
    <p class="search_type">
    <input type="hidden" id= "edBudgetCodeName" name= "edBudgetCodeName" title="" placeholder="" class="fl_left" />
    <input type="text" id= "edBudgetCode" name= "edBudgetCode"  placeholder="" class="fl_left" />
    <a href="#" class="search_btn" onclick="javascript:fn_budgetCodePop('ed')">
    <img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a></p>
    </div><!-- date_set end -->
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="budget.BudgetPlan" /></th>
    <td colspan="3">
    <label><input type="radio" name="budgetPlan" checked="checked" value="0"/><span><spring:message code="budget.All" /></span></label>
    <label><input type="radio" name="budgetPlan" value="1" /><span><spring:message code="budget.OnlyPlan" /></span></label>
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
        <li><p class="link_btn type2"><a href="#" onclick="javascript:fn_goAdjustMent();"><spring:message code="budget.Adjustment" /></a></p></li>
        <li><p class="link_btn type2"><a href="#" onclick="javascript:fn_goApproval();"><spring:message code="budget.Approval" /></a></p></li>
    </ul>
    <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
    </dd>
</dl>
</aside><!-- link_btns_wrap end -->

</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<ul class="right_btns">
    <li><p class="btn_grid"><a href="#" id="excelDown"><spring:message code="budget.ExcelDownload" /></a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->

    <div id="budgetMGrid" style="width:100%; height:380px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- content end -->
