<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javascript"
    src="${pageContext.request.contextPath}/resources/js/jquery.blockUI.min.js"></script>
<script type="text/javaScript">
var resGrid;
var reqGrid;

var rescolumnLayout=[
 {dataField:"rnum", headerText:'<spring:message code="log.head.rnum" />',
	 width : 120,
     height : 30,
     visible : false},
 {dataField:"productId", headerText:'<spring:message code="sal.title.productId" />', width: 120, editable : false},
 {dataField:"productName", headerText:'<spring:message code="sal.title.productName" />', width: 200, editable : false}
];

var reqcolumnLayout;

var resop = {
	    rowIdField : "rnum",
	    showRowCheckColumn : true,
	    usePaging : true,
	    useGroupingPanel : false,
	    Editable : false,

	};

var reqop = {
	    usePaging : true,
	    useGroupingPanel : false,
	    Editable : true
	};

$(document).ready(function(){

     document.getElementById("close").addEventListener("click", function() {

        // Dispatch custom event to refresh the parent
          var event = new Event("refreshAreaManagement");
          window.dispatchEvent(event);
      });

	 reqcolumnLayout = [
	                       {dataField:"productId", headerText:'<spring:message code="sal.title.productId" />', width: 120, editable : false},
	                       {dataField:"productName", headerText:'<spring:message code="sal.title.productName" />', width: 200, editable : false}
	                      ];

      resGrid = GridCommon.createAUIGrid("res_grid_wrap", rescolumnLayout,"", resop);
      reqGrid = GridCommon.createAUIGrid("req_grid_wrap", reqcolumnLayout, "", reqop);

      SearchListAjax();

      AUIGrid.bind(resGrid, "addRow", function(event) {
      });
      AUIGrid.bind(reqGrid, "addRow", function(event) {
      });

      AUIGrid.bind(resGrid, "cellEditBegin", function(event) {
      });
      AUIGrid.bind(reqGrid, "cellEditBegin", function(event) {

      });

      AUIGrid.bind(resGrid, "cellEditEnd", function(event) {
      });
      AUIGrid.bind(reqGrid, "cellEditEnd", function(event) {

          if (event.dataField == "itmcd") {
              $("#svalue").val(AUIGrid.getCellValue(reqGrid, event.rowIndex, "itmcd"));
              $("#sUrl").val("/logistics/material/materialcdsearch.do");
              Common.searchpopupWin("popupForm", "/common/searchPopList.do", "stocklist");
          }

          if (event.dataField == "rqty") {
              if (AUIGrid.getCellValue(reqGrid, event.rowIndex, "rqty") > AUIGrid.getCellValue(reqGrid, event.rowIndex, "aqty")) {
                  Common.alert('The requested quantity is up to ' + AUIGrid.getCellValue(reqGrid, event.rowIndex, "aqty") + '.');
                  AUIGrid.setCellValue(reqGrid, event.rowIndex, "rqty", 0);
                  return false;
              }
              if (AUIGrid.getCellValue(reqGrid, event.rowIndex, "rqty") < 0) {
                  Common.alert('The requested quantity is less than zero.');
                  AUIGrid.setCellValue(reqGrid, event.rowIndex, "rqty", 0);
                  return false;

              }
          }
      });

      AUIGrid.bind(resGrid, "cellClick", function(event) {
      });
      AUIGrid.bind(reqGrid, "cellClick", function(event) {
      });

      AUIGrid.bind(resGrid, "cellDoubleClick", function(event) {
      });
      AUIGrid.bind(reqGrid, "cellDoubleClick", function(event) {
      });

      AUIGrid.bind(resGrid, "ready", function(event) {
      });
      AUIGrid.bind(reqGrid, "ready", function(event) {
      });

    //btn clickevent
      $(function() {
          $('#clear').click(function() {
          });
          $('#reqadd').click(function() {
              f_AddRow();
          });
          $('#reqdel').click(function() {
              AUIGrid.removeRow(reqGrid, "selectedIndex");
              AUIGrid.removeSoftRows(reqGrid);
          });
          $('#save_1').click(function() {

              $("#popAreaId").val("${areaId}");
              $("#popBlckAreaGrpId").val("${blckAreaGrpId}");

              var itemGridList = GridCommon.getGridData(reqGrid);
              var dat = {};

              dat.form = $("#popSForm").serializeJSON();
              dat.itemGridList = itemGridList;

              Common.ajax("POST", "/common/updateBlacklistedArea.do", dat, function(result) {

                     AUIGrid.clearGridData(reqGrid);
                     Common.alert(result.message, SearchListAjax);

                  }, function(jqXHR, textStatus, errorThrown) {
                      try {
                      }
                      catch (e) {
                      }
                      Common.alert("Fail : " + jqXHR.responseJSON.message);
                  });
          });
          $("#rightbtn").click(function() {
              checkedItems = AUIGrid.getCheckedRowItemsAll(resGrid);

              var reqitms = AUIGrid.getGridData(reqGrid);

              var bool = true;
              if (checkedItems.length > 0) {
                  var rowPos = "first";
                  var item = new Object();
                  var rowList = [];

                  var boolitem = true;
                  var k = 0;
                  for (var i = 0; i < checkedItems.length; i++) {

                      for (var j = 0; j < reqitms.length; j++) {

                          if (reqitms[j].productId == checkedItems[i].productId) {
                              boolitem = false;
                              Common.alert("Duplicate Stock Category is not allowed in Blacklisted Area.");
                              break;
                          }
                      }

                      if(reqitms.length == 0 && checkedItems.length > 1){
                          for (var m = i + 1 ; m < checkedItems.length ; m++){
                              if (checkedItems[i].productId == checkedItems[m].productId){
                                  boolitem = false;
                                  alert("Duplicate Stock Category is not allowed in Blacklisted Area.");
                                  break;
                              }
                              break;
                          }
                      }

                      if (boolitem) {
                          rowList[k] = {
                              productId : checkedItems[i].productId,
                              productName : checkedItems[i].productName
                          }
                          k++;
                      }

                      AUIGrid.addUncheckedRowsByIds(resGrid, checkedItems[i].rnum);
                      boolitem = true;
                  }

                  AUIGrid.addRow(reqGrid, rowList, rowPos);
              }
          });
      });
}); //Ready

function addRow() {
    var rowPos = "first";

    var item = new Object();

    AUIGrid.addRow(reqGrid, item, rowPos);
}

function SearchListAjax() {
    var url = "/common/selectProductCatergory.do";
    var param ;

    Common.ajax("GET" , url , param , function(data){
        AUIGrid.setGridData(resGrid, data.data);
    });

    var url2 = "/common/selectBlacklistedArea.do";
    var areaId = "${areaId}";
    var blckAreaGrpId = "${blckAreaGrpId}";
    var currAreaId = { areaId: areaId };
    document.getElementById('area-header').innerText = "AREA-ID: " + currAreaId.areaId;


    Common.ajax("GET" , url2 , currAreaId , function(data){
        AUIGrid.setGridData(reqGrid, data.data);
    });
}



</script>


<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code='sys.blackArea.productCat'/></h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#"  id="close"><spring:message code='sys.btn.close'/></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body">
        <!-- pop_body start -->
<h2 id="area-header"></h2>
        <div class="divine_auto type2">
            <!-- divine_auto start -->

            <div style="width: 50%">
                <!-- 50% start -->

                <aside class="title_line">
                    <!-- title_line start -->
                    <h3><spring:message code='sales.ProductCategory'/></h3>
                </aside>
                <!-- title_line end -->

                <div class="border_box" style="height: 340px;">
                    <!-- border_box start -->

                    <article class="grid_wrap">
                        <!-- grid_wrap start -->
                        <div id="res_grid_wrap"></div>
                    </article>
                    <!-- grid_wrap end -->

                </div>
                <!-- border_box end -->

            </div>
            <!-- 50% end -->

            <div style="width: 50%">
                <!-- 50% start -->

                <aside class="title_line">
                    <!-- title_line start -->
                    <h3><spring:message code='sys.blackListed.ProductCategory'/></h3>
                    <ul class="right_btns">
                        <%-- <c:if test="${PAGE_AUTH.funcChange == 'Y'}"> --%>
                        <!--     <li><p class="btn_grid"><a id="reqadd">ADD</a></p></li> -->
                        <li><p class="btn_grid">
                                <a id="reqdel">DELETE</a>
                            </p></li>
                        <%-- </c:if> --%>
                    </ul>
                </aside>
                <!-- title_line end -->

                <div class="border_box" style="height: 340px;">
                    <!-- border_box start -->

                    <article class="grid_wrap">
                        <!-- grid_wrap start -->
                        <div id="req_grid_wrap"></div>
                    </article>
                    <!-- grid_wrap end -->

                    <ul class="btns">
                        <li><a id="rightbtn"><img
                                src="${pageContext.request.contextPath}/resources/images/common/btn_right2.gif"
                                alt="right" /></a></li>
                        <%--     <li><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_left2.gif" alt="left" /></a></li> --%>
                    </ul>

                </div>
                <!-- border_box end -->

            </div>
            <!-- 50% end -->

        </div>
        <!-- divine_auto end -->

        <ul class="center_btns mt20">
           <li><p class="btn_blue2 big"><a href="#" id="save_1"><spring:message code='sys.btn.save'/></a></p></li>
        </ul>

    <form action="#"  id="popSForm" name="popSForm" method="post">
    <input type="hidden" id="popAreaId" name="popAreaId"/>
    <input type="hidden" id="popBlckAreaGrpId" name="popBlckAreaGrpId"/>
    </form>
    </section>

</div><!-- popup_wrap end -->