<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javascript">
var ssResultId = '${ssResultId}';
var salesOrdId = '${salesOrdId}';
var schdulId = '${schdulId}';
var hsNo = '${hsNo}';
var ssRtnNo = '${orderInfo.ssRtnNo}'
var ssRtnItmDetailGridID;

  $(document).ready(
    function() {
    	createSelfServiceRtnItmDetailGrid();
      $('#btnLedger').click(function() {
        Common.popupWin("frmLedger", "/sales/order/orderLedgerViewPop.do", {width : "1000px", height : "720", resizable: "no", scrollbars: "no"});
      });


      var param = {	ssResultId : ssResultId ,
    		  		salesOrdId : salesOrdId ,
    		  		schdulId : schdulId };
      Common.ajax("GET", "/services/ss/getSelfServiceRtnItmDetailList", param, function(result) {
        AUIGrid.setGridData(ssRtnItmDetailGridID, result);
      })
  });

  $(function(){
	  $('#btnSaveRtnQty').click(
		      function() {
		    	  if (!verifyReturnQty()) {
		              return;
		            }

		            var rtnItmList = AUIGrid.getGridData(ssRtnItmDetailGridID);
		            var param = {
		              parcelTrackNo : hsNo,
		              ssResultId : ssResultId ,
	    		  	  salesOrdId : salesOrdId ,
	    		  	  schdulId : schdulId ,
	    		  	  ssRtnNo : ssRtnNo ,
		              rtnItmList : rtnItmList
		            };

		            Common.ajax("POST", "/services/ss/updateReturnGoodsQty.do", param,
		              function(result) {
		                if (result.code == "00") {
		                  Common.alert(" Return quantity for " + '${hsNo}' + " has been update successfully.", fn_popClose());
		                } else {
		                  Common.alert(result.message, fn_popClose);
		                }
		              });
		    });


  });

  function verifyReturnQty() {
	    var rowCount = AUIGrid.getRowCount(ssRtnItmDetailGridID);
	    if(rowCount == null || rowCount < 1){
	      Common.alert('<spring:message code="sal.alert.msg.selectItm" />');
	      return;
	    }

	    for (var a=0; a<rowCount; a++) {
	      var itm = AUIGrid.getColumnValues(ssRtnItmDetailGridID, 'itemDesc');
	      var itmQty = AUIGrid.getColumnValues(ssRtnItmDetailGridID, 'quantity');
	      var itmGoodCondQty = AUIGrid.getColumnValues(ssRtnItmDetailGridID, 'totGoodCond');
	      //var itmDefectCondQty = AUIGrid.getColumnValues(ssRtnItmDetailGridID, 'totDefectCond');
	      var itmMiaCondQty = AUIGrid.getColumnValues(ssRtnItmDetailGridID, 'totMiaCond');
	      var msgLabel = "";

	      if (itmGoodCondQty == "") {
	        msgLabel = itm + " (" + "<spring:message code='supplement.text.supplementTtlRtnGoodCondQty'/>" + ") ";
	        Common.alert("<spring:message code='sys.msg.necessary' arguments='" + msgLabel +"' htmlEscape='false'/>");
	        return false;
	      }

	     /*  if (itmDefectCondQty == "") {
	        msgLabel = itm + " (" + "<spring:message code='supplement.text.supplementTtlRtnDefectCondQty'/>" + ") ";
	        Common.alert("<spring:message code='sys.msg.necessary' arguments='" + msgLabel +"' htmlEscape='false'/>");
	        return false;
	      } */

	      if (itmMiaCondQty == "") {
	        msgLabel = itm + " (" + "<spring:message code='supplement.text.supplementTtlRtnMissCondQty'/>" + ") ";
	        Common.alert("<spring:message code='sys.msg.necessary' arguments='" + msgLabel +"' htmlEscape='false'/>");
	        return false;
	      }

	      if (itmMiaCondQty[a] > 0) {
	        // TOTAL QUANTITY MUST EQUAL TO TOTAL MISSING QUANTITY
	        if (itmQty[a] != itmMiaCondQty[a]) {
	          Common.alert("<spring:message code='supplement.alert.msg.rtnQtyNoSame' arguments='"+ itmMiaCondQty[a] + ";" + itmQty[a] + " (" + itm[a] + ")" +"' htmlEscape='false' argumentSeparator=';'/>");
	          return false;
	        }
	      } else {
	        // TOTAL QUANTITY MUST EQUAL TO  TOTAL GOOD CONDITION  AND DEFECTIVE CONDITION GOODS.
	        var insertQty = Number(itmGoodCondQty[a]);
	        if (itmQty[a] != insertQty) {
	          Common.alert("<spring:message code='supplement.alert.msg.rtnQtyNoSame' arguments='"+ insertQty + ";" + itmQty[a] + " (" + itm[a] + ")" +"' htmlEscape='false' argumentSeparator=';'/>");
	          return false;
	        }
	      }
	    }
	    return true;
	  }

  function fn_popClose() {
    $("#_systemClose").click();
    fn_getSelfServiceList();
  }

  function createSelfServiceRtnItmDetailGrid() {
      var columnLayout = [ {
          dataField : "itemCode",
          headerText : "<spring:message code='log.head.itemcode'/>",
          width : '10%',
          editable : false,
          visible : false
      }, {
          dataField : "itemDesc",
          headerText : "<spring:message code='log.head.itemdescription'/>",
          width : '30%',
          editable : false
      }, {
          dataField : "quantity",
          headerText : "<spring:message code='pay.head.quantity'/>",
          width : '10%',
          editable : false
      }, {
          dataField : "totGoodCond",
          headerText : "<spring:message code='supplement.text.supplementTtlRtnGoodCondQty'/>",
          width : '25%',
          editable : true,
          dataType : "numeric"
      }, {
          dataField : "totMiaCond",
          headerText : "<spring:message code='supplement.text.supplementTtlRtnMissCondQty'/>",
          width : '25%',
          editable : true,
          dataType : "numeric"
      } , {
			dataField : "stkId",
			headerText : "Stock ID",
			visible : false
		}, {
			dataField : "ssRtnItmId",
			headerText : "Self Service Return Item ID",
			visible : false
		}];

      var rtnItmGridPros = {
          showFooter : true,
          usePaging : true,
          pageRowCount : 10,
          fixedColumnCount : 1,
          showStateColumn : true,
          displayTreeOpen : false,
          headerHeight : 30,
          useGroupingPanel : false,
          skipReadonlyColumns : true,
          wrapSelectionMove : true,
          showRowNumColumn : true
      };

      ssRtnItmDetailGridID = GridCommon.createAUIGrid("ss_rtn_itm_detail_grid_wrap", columnLayout, "", rtnItmGridPros);
  }

</script>
<div id="popup_wrap" class="popup_wrap">
  <form id="frmLedger" name="frmLedger" action="#" method="post">
    <input id="ordId" name="ordId" type="hidden" value="${basicinfo.salesOrdId}" />
  </form>
  <header class="pop_header">
    <h1>
      <spring:message code="service.ss.title.selfServiceManagement" /> - <spring:message code="supplement.title.supplementUpdateRetQty" />
    </h1>
    <ul class="right_opt">
      <li>
        <p class="btn_blue2">
          <a id="btnLedger" href="#"><spring:message code="sal.btn.ledger" /></a>
        </p>
      </li>
      <li>
        <p class="btn_blue2">
          <a id="_systemClose"><spring:message code="sal.btn.close" /></a>
        </p>
      </li>
    </ul>
  </header>
  <section class="pop_body">
    <aside class="title_line">
      <h3><spring:message code="service.ss.text.selfServiceInformation" /></h3>
    </aside>
    <table class="type1">
      <caption>table</caption>
      <colgroup>
        <col style="width: 120px" />
        <col style="width: *" />
        <col style="width: 120px" />
        <col style="width: *" />
        <col style="width: 120px" />
        <col style="width: *" />
      </colgroup>
      <tbody>
      <tr>
    	<th scope="row"><spring:message code="service.grid.HSNo" /></th>
    	<td><span><c:out value="${basicinfo.no}"/></span></td>
    	<th scope="row"><spring:message code="service.ss.title.ssPeriod" /></th>
    	<td><span><c:out value="${basicinfo.monthy}"/></span></td>
    	<th scope="row"><spring:message code="sal.text.bsType" /></th>
    	<td><span><c:out value="${basicinfo.codeName}"/></span></td>
		</tr>
      </tbody>
    </table>

    <section class="tap_wrap">
      <!------------------------------------------------------------------------------
        Detail Page Include START
      ------------------------------------------------------------------------------->
      <%@ include
        file="/WEB-INF/jsp/services/ss/selfServiceDetailContent.jsp"%>
      <!------------------------------------------------------------------------------
        Detail Page Include END
      ------------------------------------------------------------------------------->
    </section>

      <section>
       <aside class="title_line">
      <!-- <h3><spring:message code="sal.title.itmList" /></h3> -->
    </aside>
    <article class="tap_area">
      <div class="inventory-statement">
        <ul>
          <li><strong>Returns in Goods Condition and Defective Goods:</strong>
            <ul>
              <li>The sum of items returned in good condition and items returned as defective must equal the actual order quantity of the item.</li>
            </ul>
          </li>
          <li><strong>Missing Goods:</strong>
            <ul>
              <li>If the quantity of missing goods is reported, it must equal the actual order quantity of the item.</li>
            </ul>
          </li>
        </ul>
      </div>
      <article class="grid_wrap">
        <div id="ss_rtn_itm_detail_grid_wrap" style="width: 100%; height: 200px; margin: 0 auto;"></div>
      </article>
    </article>
    <br/>
      <ul class="center_btns mt20">
        <li>
          <p class="btn_blue2 big">
            <a id="btnSaveRtnQty" href="#"><spring:message code="sys.btn.save" /></a>
          </p>
        </li>
      </ul>
    </section>


  </section>
</div>