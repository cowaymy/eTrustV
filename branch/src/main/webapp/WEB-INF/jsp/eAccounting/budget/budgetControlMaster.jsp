<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script  type="text/javascript">

var budgetMGrid;
var costStr ;

$(document).ready(function(){
    //그리드 생성
    fn_makeGrid();

});

/*popup 설정*/
function fn_costCenterSearchPop(str) {
    costStr = str;
    Common.popupDiv("/eAccounting/webInvoice/costCenterSearchPop.do", null, null, true, "costCenterSearchPop");
}

function fn_setCostCenter (str){
        $("#costCentr").val($("#search_costCentr").val());
        $("#costCentrName").val( $("#search_costCentrName").val());
}

// 리스트 조회
function fn_selectListAjax() {  
   
    Common.ajax("GET", "/eAccounting/budget/selectBudgetControlList", $("#listSForm").serialize(), function(result) {
            
        console.log("성공.");
        console.log(result);

        AUIGrid.setGridData(budgetMGrid, result);
    }); 
}

function fn_makeGrid(){

    var monPop = [];
    
    monPop[0] = {dataField : "costCentr",
            headerText : '<spring:message code="budget.CostCenter" />',
            width : 100
    }
    
    monPop.push({
                    dataField : "costCenterText",
                    headerText : '<spring:message code="budget.costCenterName" />',
                    width : 160,
                    editable : false
                },{
                    dataField : "budgetCode",
                    headerText : '<spring:message code="budget.BudgetCode" />',
                    width : 100,
                    editable : false
                },{
                    dataField : "budgetCodeText",
                    headerText : '<spring:message code="budget.budgetName" />',
                    width : 220,
                    editable : false
                },{
                    dataField : "glAccCode",
                    headerText : '<spring:message code="budget.GLAccountCode" />',
                    width : 140,
                    editable : false
                },{
                    dataField : "glAccDesc",
                    headerText : '<spring:message code="budget.GLAccountName" />',
                    width : 180,
                    editable : false
                },{
                    dataField : "cntrlType",
                    headerText : '<spring:message code="budget.controlType" />',
                    editable : false
                });
      
        
     var monOptions = {
            enableCellMerge : true,
            editable : true,
            showStateColumn:false,
            fixedColumnCount : 1,    //scroll bar가 움직이는 위치 설정
            showRowNumColumn    : false,
            usePaging : true,
            pageRowCount : 20, //한 화면에 출력되는 행 개수 20(기본값:20)
            showFooter : false
      };
    
    budgetMGrid = GridCommon.createAUIGrid("#budgetMGrid", monPop, "", monOptions);
    
}
</script>

<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>eAccount</li>
    <li>Budget Control Master</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2><spring:message code="budget.ControlMaster" /></h2>
<ul class="right_btns">
    <c:if test="${PAGE_AUTH.funcView == 'Y'}">
    <li><p class="btn_blue"><a href="#" onClick="javascript:fn_selectListAjax();" ><span class="search"></span><spring:message code="expense.btn.Search" /></a></p></li>
    </c:if>
</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id="listSForm" name="listSForm">

<!-- 팝업창에서 클릭한 정보를 TEXTBOX에 입력할 수 있도록 하는 ID값 -->
<input type="hidden" id = "search_costCentr" name="search_costCentr" />
<input type="hidden" id = "search_costCentrName" name="search_costCentrName" />
    

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:140px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="budget.CostCenter" /></th>
    <td>
   
    <input type="text" id="costCentr" name="costCentr" title="" placeholder="" class="fl_left" />
    <a href="#" class="search_btn"  onclick="javascript:fn_costCenterSearchPop()"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
    </td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="link_btns_wrap"><!-- link_btns_wrap start -->
<p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
<dl class="link_list">
    <dt><spring:message code="budget.Link" /></dt>
    <dd>
    <ul class="btns">
        <li><p class="link_btn"><a href="monthlyBudgetList.do"><spring:message code="budget.link.budgetplan" /></a></p></li>
    </ul>
    <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
    </dd>
</dl>
</aside><!-- link_btns_wrap end -->

</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->
    
<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="budgetMGrid" style="width:100%; height:380px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- content end -->

