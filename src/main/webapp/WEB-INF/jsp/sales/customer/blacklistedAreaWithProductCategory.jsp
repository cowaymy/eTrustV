<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javaScript">

//AUIGrid 그리드 객체
var myGridID;
var selectedGridValue;
var optionState = {chooseMessage: "States"};

$(document).ready(function(){

    var gridPros = {
            showStateColumn : false,
            softRemoveRowMode:false,
            editable            : false,
    };

	CommonCombo.make('state', "/sales/customer/selectMagicAddressComboList", '' , '', optionState);

    gridPos = {
    		usePaging           : true,             //페이징 사용
            pageRowCount        : 20,           //한 화면에 출력되는 행 개수 20(기본값:20)
            editable                : false,
            fixedColumnCount    : 1,
            displayTreeOpen     : false,
            selectionMode       : "multipleCells",  //"singleRow",
            headerHeight        : 30,
            showRowNumColumn    : true,         //줄번호 칼럼 렌더러 출력
            showStateColumn : false,
            noDataMessage       :  gridMsg["sys.info.grid.noDataMessage"],
            groupingMessage     : gridMsg["sys.info.grid.groupingMessage"]
        };

    myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout,null,gridPros);

    AUIGrid.bind(myGridID, "cellClick", function( event ){
        selectedGridValue = event.rowIndex;
    });

});

var columnLayout = [
                    { dataField:"areaId" ,headerText:"Area ID",width: '15%'},
                    { dataField:"area" ,headerText:"Area",width: '15%'},
                    { dataField:"postcode" ,headerText:"Postcode",width: '10%'},
                    { dataField:"city" ,headerText:"City",width: '15%'},
                    { dataField:"state" ,headerText:"State",width: '15%'},
                    { dataField:"country" ,headerText:"Country",width: '15%'},
                    { dataField:"category" ,headerText:"Category",width: '15%'}
                    ];

$(function(){
    $('#search').click(function() {
    	if(fn_validSearchList()) fn_selectListAjax();
    });

    $('#clear').click(function() {
        $("#searchForm")[0].reset();
    });

});

function fn_selectListAjax() {
	    Common.ajax("GET", "/sales/customer/selectBlacklistedAreawithProductCategoryList.do", $("#searchForm").serialize(), function(result) {
	     AUIGrid.setGridData(myGridID, result);
	 });

}

function fn_excelDown() {
    var dd, mm, yy;

    var today = new Date();
    dd = today.getDay();
    mm = today.getMonth();
    yy = today.getFullYear();

    GridCommon.exportTo("grid_wrap", 'xlsx', "BLACKLISTED_AREA_" + yy + mm + dd);
}

function fn_validSearchList() {
    var isValid = true, msg = "";

     /* if(FormUtil.isEmpty($('#listUpdStartDt').val()) || FormUtil.isEmpty($('#listUpdEndDt').val())) {
         isValid = false;
         msg += '<spring:message code="sal.alert.msg.plzKeyInUpdDtFromTo" /><br/>';
     }
     else {
         var diffDay = fn_diffDate($('#listUpdStartDt').val(), $('#listUpdEndDt').val());

         if(diffDay > 91 || diffDay < 0) {
             isValid = false;
             msg += '* <spring:message code="sal.alert.msg.srchPeriodDt" />';
         }
     }


    if(!isValid) Common.alert('<spring:message code="sal.title.text.ordSrch" />' + DEFAULT_DELIMITER + "<b>"+msg+"</b>"); */

    return isValid;
}


</script>
<!-- content start -->
<section id="content">
  <ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>Payment</li>
    <li>Payment</li>
    <li>Customer VA Exclude</li>
  </ul>
  <!-- title_line start -->
  <aside class="title_line">
    <p class="fav">
      <a href="#" class="click_add_on">My menu</a>
    </p>
    <h2>Blacklisted Area with Product Category</h2>
    <ul class="right_btns">
      <c:if test="${PAGE_AUTH.funcView == 'Y'}">
        <li><p class="btn_blue"><a id="search"><span class="search"></span>Search</a></p></li>
        <li><p class="btn_blue"><a id="clear"><span class="clear"></span>Clear</a></p></li>
      </c:if>
      <c:if test="${PAGE_AUTH.funcPrint == 'Y'}"><li><p class="btn_blue"><a href="javascript:fn_excelDown();">Generate</a></p></li></c:if>
    </ul>
  </aside>
  <!-- title_line end -->
  <!-- search_table start -->
  <section class="search_table">
    <form name="searchForm" id="searchForm" method="post">
      <table class="type1">
        <!-- table start -->
        <caption>table</caption>
        <colgroup>
          <col style="width: 200px" />
          <col style="width: *" />
          <col style="width: 200px" />
          <col style="width: *" />
        </colgroup>
        <tbody>
          <tr>
            <th scope="row"><spring:message code='sys.area'/><span class="must">*</span></th>
            <td>
            <input type="text"  id="area" name="area" title="" placeholder="Area" class="w100p"/>
            </td>
            <th scope="row"><spring:message code='sys.state'/></th>
            <td>
            <select class="w100p" id="state"  name="state"></select>
            </td>
            <th scope="row"><spring:message code='sys.postcode'/><span class="must">*</span></th>
            <td>
            <input type="text" id="postcode" name="postcode" title="" placeholder="Post Code" class="w100p" />
            </td>
          </tr>
        </tbody>
      </table>
      <!-- table end -->
    </form>
  </section>

   <section class="search_result">
    <!-- grid_wrap start -->
    <article>
            <div id="grid_wrap" class="grid_wrap" style="width:100%; height:480px; margin: 0 auto;" class="autoGridHeight"></div>
    </article>
  </section>
  <!-- search_table end -->
</section>
<!-- content end -->
