<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">
var viewGridID;

var viewColumnLayout = [ {
    dataField : "salesOrdNo",
    headerText : "Order No"
}, {
    dataField : "ccpId",
    headerText : "CCP Id"
},{
    dataField : "stusId",
    headerText : "Status"
}, {
    dataField : "crtDt",
    headerText : "Create Date"
}, {
    dataField : "userName",
    headerText : "User Name"
}
];

var viewGridPros = {
    // 페이징 사용
    usePaging : true,
    // 한 화면에 출력되는 행 개수 20(기본값:20)
    pageRowCount : 20,
    headerHeight : 40,
    height : 240,
    enableFilter : true,
    // 셀 선택모드 (기본값: singleCell)
    selectionMode : "multipleCells"
};
  $(document).ready(function () {
	  viewGridID = AUIGrid.create("#dtl_grid_wrap", viewColumnLayout, viewGridPros);

	    //AUIGrid.setGridData(viewGridID, $.parseJSON('${ccpHistory}'));
  });
  $("#search").click(
	        function() {
	            fn_search();
	            });

  function fn_search() {

          var orderNo = $('#orderNo').val();
          if ( orderNo != null &&  orderNo != '' && orderNo.length > 0){
                console.log('search form',$("#searchForm").serialize())
                Common.ajax("GET", "/sales/ccp/checkHistoryList.do", $("#searchForm").serialize(),
                function(result) {
                AUIGrid.setGridData(viewGridID, result);
                  });
          }
          else{
              Common.alert("Please provide order no.");
              return;
          }

  }

</script>
<div id="popup_wrap" class="popup_wrap">
<section class="pop_body"><!-- search_result start -->
<header class="pop_header"><!-- pop_header start -->
<h1>EZY CCP - History</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#" id="search"><span class="search"></span><spring:message code='sys.btn.search'/></a></p></li>
    <li><p class="btn_blue2"><a href="#" id="close_btn"><spring:message code='sys.btn.close'/></a></p></li>
</ul>
</header><!-- pop_header end -->
 <!-- popup_wrap start -->

<form name="searchForm" id="searchForm"  method="post">
            <table class="type1"><!-- table start -->
                <caption>table</caption>
                <colgroup>
                         <col style="width: 180px" />
                         <col style="width: *" />
                         <col style="width: 180px" />
                         <col style="width: *" />
                         <col style="width: 160px" />
                         <col style="width: *" />
                </colgroup>
                <tbody>
                    <tr>
                        <th scope="row">Order No</th>
                            <td >
                            <input type="text" title="" id="orderNo" name="orderNo" placeholder="Order No" class="w100p" />
                            </td>
                             <td >
                             </td>
                              <td >
                             </td>
                              <td >
                             </td>
                              <td >
                             </td>
                    </tr>
                </tbody>
            </table>
            <!-- table end -->
        </form>

<article class="grid_wrap" id="dtl_grid_wrap"><!-- grid_wrap start -->
</article><!-- grid_wrap end -->

</section><!-- search_result end -->
</div>
<!-- popup_wrap end -->

