<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp" %>

<style type="text/css">

/* 커스텀 칼럼 스타일 정의 */
.aui-grid-user-custom-left {
    text-align:left;
}

/* 커스컴 disable 스타일*/
.mycustom-disable-color {
    color : #cccccc;
}

/* 그리드 오버 시 행 선택자 만들기 */
.aui-grid-body-panel table tr:hover {
    background:#D9E5FF;
    color:#000;
}
.aui-grid-main-panel .aui-grid-body-panel table tr td:hover {
    background:#D9E5FF;
    color:#000;
}

.aui-grid-column-right {
     text-align: right;
 }

.aui-grid-link-renderer1 {
     text-decoration:underline;
     color: #4374D9 !important;
     text-align: right;
 }

</style>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery.blockUI.min.js"></script>
<script type="text/javaScript" language="javascript">
var listGrid;
var subGrid;
var userCode;
var roleId = '${SESSION_INFO.roleId}';
var keyValueList = $.parseJSON('${statusList}');
var keyValueList2 = $.parseJSON('${expenseTyp}');

var rescolumnLayout = [{dataField:    "rnum",headerText :"<spring:message code='log.head.rownum'/>"               ,width:120    ,height:30 , visible:false},
                     {dataField: "budgetCode",headerText :"Budget Code"       ,width:120    ,height:30 },
                     {dataField: "budgetCodeText",headerText :"Budget Code Desc."       ,width:300    ,height:30  , editable : false,             },
                     {dataField: "glAccCode",headerText :"GL Account"            ,width:150    ,height:30,editable : false, },
                     {dataField: "glAccDesc",headerText :"GL Account Name"              ,width:200    ,height:30 ,editable : false,               },
                     {dataField: "natureOfExp",headerText :"Nature of Expenses"               ,width:350    ,height:30, editable:true },
                     {dataField: "stus",headerText :"Status"               ,width:350    ,height:30, editable:true, visible:false },
                     {dataField: "codeId",headerText :"Expense Type"               ,width:100    ,height:30, editable:true,
                    	 renderer : {
                             type : "DropDownListRenderer",
                             list : keyValueList2, //key-value Object 로 구성된 리스트
                             keyField : "codeId", // key 에 해당되는 필드명
                             valueField : "code" // value 에 해당되는 필드명
                         }},
                     {dataField: "stusCodeId",headerText :"Status"               ,width:100    ,height:30, editable:true,
                     renderer : {
                         type : "DropDownListRenderer",
                         list : keyValueList, //key-value Object 로 구성된 리스트
                         keyField : "stusCodeId", // key 에 해당되는 필드명
                         valueField : "name" // value 에 해당되는 필드명
                     }}
                     ];

var hiddenLayout = [{dataField:    "rnum",headerText :"<spring:message code='log.head.rownum'/>"               ,width:120    ,height:30 , visible:false},
                       {dataField: "budgetCode",headerText :"Budget Code"       ,width:120    ,height:30 },
                       {dataField: "budgetCodeText",headerText :"Budget Code Desc."       ,width:300    ,height:30             },
                       {dataField: "glAccCode",headerText :"GL Account"            ,width:150    ,height:30},
                       {dataField: "glAccDesc",headerText :"GL Account Name"              ,width:200    ,height:30               },
                       {dataField: "natureOfExp",headerText :"Nature of Expenses"               ,width:350    ,height:30},
                       {dataField: "stus",headerText :"Status"               ,width:100    ,height:30},
                       {dataField: "codeName",headerText :"Expense Type"               ,width:100    ,height:30},

                       ];


var gridPros2 = {

        // 편집 가능 여부 (기본값 : false)
  //editable : false,
  // 상태 칼럼 사용
  showStateColumn : false,
  // 기본 헤더 높이 지정
  headerHeight : 35,

  softRemoveRowMode:false

}


//var reqop = {editable : false,usePaging : false ,showStateColumn : false};
var gridoptions = {
        showStateColumn : false ,
        editable : false,
        useGroupingPanel : false,
        showRowAllCheckBox : true,
        showRowCheckColumn : true
        };

var gridPros = {
	    // showRowCheckColumn : true,
	      usePaging : true,
	      pageRowCount : 20,
	    //  showRowAllCheckBox : true,
	      editable : true
	    };

var gridPros2 = {
        // showRowCheckColumn : true,
          usePaging : true,
          pageRowCount : 20,
        //  showRowAllCheckBox : true,
          editable : false
        };

var paramdata;

$(document).ready(function(){

    //SearchSessionAjax();
    /**********************************
    * Header Setting
    **********************************/

    //

    /**********************************
     * Header Setting End
     ***********************************/

    listGrid = AUIGrid.create("#main_grid_wrap", rescolumnLayout, gridPros);

    hiddenGrid = AUIGrid.create("#hidden_grid_wrap", hiddenLayout, gridPros2);

    AUIGrid.bind(listGrid, "ready", function(event) {
    });



});


//btn clickevent
$(function(){
    $('#search').click(function() {
		SearchListAjax();

    });
    $('#clear').click(function() {
        $('#budgetCode').val('');
        $('#glAccCode').val('');
		$('#searchKey').val('');
		$('#pBudgetCode').val('');
		$('#pGlAccCode').val('');
    });


    $("#download").click(function() {
       GridCommon.exportTo("hidden_grid_wrap", 'xlsx', "Budget Code Listing");
    });

});



function SearchListAjax() {
    var url = "/eAccounting/budget/selectBudgetCodeList.do";
    var param = $('#searchForm').serialize();

    Common.ajax("GET" , url , param , function(data){
        AUIGrid.setGridData(listGrid, data);
        AUIGrid.setGridData(hiddenGrid, data);

    });
}

//save
function fnSaveEdit(obj) {
    if ( true == $(obj).parents().hasClass("btn_disabled") ) {
        return  false;
    }

    if ( false == fnValidation() ) {
        return  false;
    }

    Common.ajax("POST"
            , "/eAccounting/budget/updateBudgetCode.do"
            , GridCommon.getEditData(listGrid)
            , function(result) {
                Common.alert(result.data  + "<spring:message code='sys.msg.savedCnt'/>");
                //fnSalesPlanHeader();
                console.log("Success : " + JSON.stringify(result) + " /data : " + result.data);
            }
            , function(jqXHR, textStatus, errorThrown) {
                try {
                    console.log("HeaderFail Status : " + jqXHR.status);
                    console.log("code : "        + jqXHR.responseJSON.code);
                    console.log("message : "     + jqXHR.responseJSON.message);
                    console.log("detailMessage : "  + jqXHR.responseJSON.detailMessage);
                } catch ( e ) {
                    console.log(e);
                }
                Common.alert("Fail : " + jqXHR.responseJSON.message);
            });
}

//validation
function fnValidation() {
    var result  = true;
    var updList = AUIGrid.getEditedRowItems(listGrid);

    if ( 0 == updList.length ) {
        Common.alert("No Change");
        result  = false;
    }

    return  result;
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

function fn_clearField(val){
	console.log("val: " + val);
    $("#" + val).val("");

}


</script>

<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>Budget Mgmt</li>
    <li>Budget Code List</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>Budget Code List</h2>
</aside><!-- title_line end -->



<aside class="title_line"><!-- title_line start -->
<h3>Header Info</h3>
    <ul class="right_btns">
<c:if test="${PAGE_AUTH.funcView == 'Y'}">
      <li><p class="btn_blue"><a id="search"><span class="search"></span>Search</a></p></li>

</c:if>
      <li><p class="btn_blue"><a id="clear"><span class="clear"></span>Clear</a></p></li>
    </ul>
</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->
    <form id="searchForm" name="searchForm" method="post">
    <input type="hidden" id = "pBudgetCode" name="pBudgetCode" />
    <input type="hidden" id = "pBudgetCodeName" name="pBudgetCodeName" />
    <input type="hidden" id = "pGlAccCode" name="pGlAccCode" />
    <input type="hidden" id = "pGlAccCodeName" name="pGlAccCodeName" />

        <table class="type1"><!-- table start -->
            <caption>search table</caption>
            <colgroup>
                <col style="width:140px" />
                <col style="width:*" />
                <col style="width:140px" />
                <col style="width:*" />
                <col style="width:140px" />
                <col style="width:*" />
            </colgroup>
            <tbody>
              <tr>
                  <th scope="row"><spring:message code="expense.Activity" /></th>
				    <td colspan="2">
				        <input type="text" id="budgetCode" name="budgetCode" title="" placeholder="" class="fl_left" readonly="readonly"/>
				        <input type="hidden" id="budgetCodeName" name="budgetCodeName" title="" placeholder="" class=""  readonly="readonly" />
				        <a href="#" class="search_btn" onclick="javascript:fn_budgetCodePop();"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
				        <a href="#" class="search_btn" onclick="javascript:fn_clearField('budgetCode')"><img src="${pageContext.request.contextPath}/resources/images/common/icon_gabage_s.png" class="fl_right"/></a>
				    </td>
                   <th scope="row"><spring:message code="expense.GLAccount" /></th>
				    <td colspan="2">
				          <input type="text" id="glAccCode" name="glAccCode" title="" placeholder="" class="fl_left" readonly="readonly"/>
				          <input type="hidden" id="glAccCodeName" name="glAccCodeName" title="" placeholder="" class=""  readonly="readonly" />
				          <a href="#" class="search_btn" onclick="javascript:fn_glAccountSearchPop();"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" class="fl_left"/></a>
				           <a href="#" style="" class="search_btn" onclick="javascript:fn_clearField('glAccCode')"><img src="${pageContext.request.contextPath}/resources/images/common/icon_gabage_s.png" class="fl_right"/></a>
				    </td>
                </tr>
                <tr>

                    <th scope="row">Status</th>
                    <td colspan="2"><select id="stusCodeId" name="stusCodeId" class="multy_select w100p" multiple="multiple">
                        <option value="1">Active</option>
                        <option value="7">Obsolute</option>
                    </select></td>
                     <th scope="row">Expense Type</th>
                    <td colspan="2"><select id="expenseType" name="expenseType" class="multy_select w100p" multiple="multiple">
                        <option value="7293">OPEX</option>
                        <option value="7294">CAPEX</option>
                    </select></td>

                </tr>
                <tr>
                     <th scope="row">Keyword Search</th>
                   <td>
                        <input type = "text"  id="searchKey" name="searchKey" class="" />
                   </td>
                </tr>


            </tbody>
        </table><!-- table end -->

   <!-- link_btns_wrap end -->
    </form>

    </section><!-- search_table end -->

    <!-- data body start -->
    <section class="search_result"><!-- search_result start -->

        <ul class="right_btns">
<c:if test="${PAGE_AUTH.funcChange == 'Y'}">
           <c:if test="${PAGE_AUTH.funcUserDefine5 == 'Y'}">
           <li><p class="btn_grid"><a onclick="fnSaveEdit(this);">Save</a></p></li>
           </c:if>
            <li><p class="btn_grid"><a id="download">Excel Download</a></p></li>
</c:if>
        </ul>
        <article class="grid_wrap"><!-- grid_wrap start -->
        <div id="main_grid_wrap" class="autoGridHeight"></div>
        </article><!-- grid_wrap end -->
        <article class="grid_wrap"><!-- grid_wrap start -->
        <div id="hidden_grid_wrap" class="autoGridHeight"  style="display: none;"></div>
        </article><!-- grid_wrap end -->

    </section><!-- search_result end -->

</section>



