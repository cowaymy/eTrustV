<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<style type="text/css">
/* 커스텀 칼럼 스타일 정의 */
.aui-grid-user-custom-left {
    text-align:left;
}
</style>
<script type="text/javascript">

var myGridID;

$(document).ready(function(){
    
    // AUIGrid 그리드를 생성합니다.
    createAUIGrid();
    
    AUIGrid.setSelectionMode(myGridID, "singleRow");
          $('#claimType').on("change", function () {

              var $this = $(this);
             CommonCombo.initById("expType");

             if (FormUtil.isNotEmpty($this.val())) {

                 CommonCombo.make("expType", "/eAccounting/expense/selectExpenseList", $("#listSForm").serialize(), "", {
                     id: "expType",
                     name: "expTypeName",
                     type:"M"
                 });

             } 
         });

        CommonCombo.make("expType", "/eAccounting/expense/selectExpenseList", $("#listSForm").serialize(), "", {
            id: "expType",
            name: "expTypeName",
            type:"M"
        });
        
        CommonCombo.make("claimType", "/common/selectCodeList.do", {groupCode:'343', orderValue:'CODE'}, "", {
            id: "code",
            name: "codeName",
            type:"M"
        }
        //, calback
        );

});

// 조회조건 combo box
function f_multiCombo(){
    $(function() {
        $('#claimType').change(function() {
        
        }).multipleSelect({
            selectAll: true, // 전체선택 
            width: '80%'
        });       
    });
}

// 리스트 조회.
function fn_selectListAjax() {        
    Common.ajax("GET", "/eAccounting/expense/selectExpenseList", $("#listSForm").serialize(), function(result) {
        
         console.log("성공.");
         console.log( result);
         
        AUIGrid.setGridData(myGridID, result);
    });
}

//Expense Type Pop 호출
function fn_expenseTypePop(){
	
   Common.popupDiv("/eAccounting/expense/addExpenseTypePop.do", null, null, true, "addExpenseTypePop");
}


function createAUIGrid() {
    // AUIGrid 칼럼 설정
    
    // 데이터 형태는 다음과 같은 형태임,
    //[{"id":"#Cust0","date":"2014-09-03","name":"Han","country":"USA","product":"Apple","color":"Red","price":746400}, { .....} ];
    var columnLayout = [ {
	        dataField : "clmType",
	        headerText : '<spring:message code="expense.ClaimType" />',
	        width : 150,
	        editable : false
	    }, {
	        dataField : "expTypeName",
	        headerText : '<spring:message code="expense.ExpenseType" />',
            style : "aui-grid-user-custom-left",
	        width : 100,
	        editable : false
	    },{
            dataField : "glAccCode",
            headerText : '<spring:message code="expense.GLAccount" />',
            width : 100,
            editable : false
        }, {
            dataField : "glAccCodeName",
            headerText : '<spring:message code="expense.GLAccountName" />',
            style : "aui-grid-user-custom-left",
            width : 200,
            editable : false
        }, {
            dataField : "budgetCode",
            headerText : '<spring:message code="expense.Activity" />',
            width : 100,
            editable : false
        }, {
            dataField : "budgetCodeName",
            headerText : '<spring:message code="expense.ActivityName" />',
            style : "aui-grid-user-custom-left",
            width : 200,
            editable : false
        }, {
            dataField : "crtDt",
            headerText : '<spring:message code="expense.CreateDate" />',
            width : 100,
            editable : false
        }, {
            dataField : "crtUserId",
            headerText : '<spring:message code="expense.CreateUserID" />',
            width : 100,
            editable : false
        }, {
            dataField : "updDt",
            headerText : '<spring:message code="expense.ChangeDate" />',
            width : 100,
            editable : false
        }, {
            dataField : "updUserId",
            headerText : '<spring:message code="expense.ChangeUserID" />',
            width : 100,
            editable : false
        }];
   
    //그리드 속성 설정
    var gridPros = {
        usePaging           : true,             //페이징 사용
        pageRowCount        : 20,           //한 화면에 출력되는 행 개수 20(기본값:20)            
        editable                : false,            
        fixedColumnCount    : 1,            
        showStateColumn     : true,             
        displayTreeOpen     : false,            
        selectionMode       : "singleRow",  //"multipleCells",            
        headerHeight        : 30,       
        useGroupingPanel    : false,        //그룹핑 패널 사용
        skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
        wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
        showRowNumColumn    : true,         //줄번호 칼럼 렌더러 출력    
        noDataMessage       :  gridMsg["sys.info.grid.noDataMessage"],
        groupingMessage     : gridMsg["sys.info.grid.groupingMessage"]
    };
    
    //myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout, gridPros);
    myGridID = AUIGrid.create("#grid_wrap", columnLayout, gridPros);
}

</script>

<div id="wrap"><!-- wrap start -->
		
<section id="content"><!-- content start -->
<ul class="path">
	<li><img src="${pageContext.request.contextPath}/images/common/path_home.gif" alt="Home" /></li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2><spring:message code="expense.title" /></h2>
<ul class="right_btns">
	<li><p class="btn_blue"><a id="btnSrch" href="#" onClick="javascript:fn_selectListAjax();"></span><spring:message code="expense.btn.Search" /></a></p></li>
</ul>
</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->
<form action="#"  id="listSForm" name="listSForm" method="post">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:110px" />
	<col style="width:*" />
	<col style="width:120px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row"><spring:message code="expense.ClaimType" /></th>
	<td>
	<select class="multy_select w100p" id="claimType" name="claimType" multiple="multiple">
	</select>
	</td>
	<th scope="row"><spring:message code="expense.ExpenseType" /></th>
	<td>
	<select class="multy_select w100p" id="expType" name="expType" multiple="multiple">
	</select>
	</td>
</tr>
</tbody>
</table><!-- table end -->

</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<ul class="right_btns">
	<li><p class="btn_grid"><a href="#" onClick="javascript:fn_expenseTypePop();"><spring:message code="expense.AddExpenseType" /></a></p></li>
	<li><p class="btn_grid"><a href="#"><spring:message code="expense.Edit" /></a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="grid_wrap" style="width:100%; height:480px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- content end -->
		
</div><!-- wrap end -->