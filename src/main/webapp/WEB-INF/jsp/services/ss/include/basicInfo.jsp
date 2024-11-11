<style>
  .status-active {
    color: green;
    font-weight: bold;
  }
  .status-complete {
    color: blue;
    font-weight: bold;
  }
  .status-cancel {
    color: red;
    font-weight: bold;
  }
  .status-ready {
    color: teal;
    font-weight: bold;
  }
  .status-pending {
    color: orange;
    font-weight: bold;
  }
  .status-pickup {
    color: brown;
    font-weight: bold;
  }
  .status-in-transit {
    color: lightblue;
    font-weight: bold;
  }
  .status-out-for-delivery {
    color: purple;
    font-weight: bold;
  }
  .status-delivered {
    color: green;
    font-weight: bold;
  }
  .status-returned {
    color: #FF6347;
    font-weight: bold;
  }

</style>

<script type="text/javascript">
    var ssItmDetailGridID;

    $(document).ready(function() {
        createSsItmDetailGrid();
    });

    function createSsItmDetailGrid() {
        var columnLayout = [ {
			dataField : "stkCode",
			headerText : '<spring:message code="service.title.FilterCode" />',
			width : '20%',
			editable : false
		}, {
			dataField : "stkDesc",
			headerText : '<spring:message code="sal.title.filterName" />',
			width : '40%',
			editable : false
		}, {
			dataField : "c1",
			headerText : '<spring:message code="sal.title.qty" />',
			width : '10%',
			editable : false
		}, {
			dataField : "serialNo",
			headerText : '<spring:message code="service.title.SerialNo" />',
			width : '30%',
			editable : false
		}, {
			dataField : "schdulId",
			visible : false
		}, {
			dataField : "stkId",
			visible : false
		}, {
			dataField : "ssResultId",
			visible : false
		}, {
			dataField : "ssResultItmId",
			visible : false
		} ];

        var ssGridPros = {
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

        ssItmDetailGridID = GridCommon.createAUIGrid("ss_itm_detail_grid_wrap", columnLayout, "", ssGridPros);

    }

    var ssResultId = '${ssResultId}';
    var salesOrdId = '${salesOrdId}';
    var schdulId = '${schdulId}';
    var param = {ssResultId : ssResultId,
    			 salesOrdId : salesOrdId,
    			 schdulId : schdulId};
    Common.ajax("GET", "/services/ss/getSelfServiceFilterList", param, function(result) {
      AUIGrid.setGridData(ssItmDetailGridID, result);
    })
</script>

<article class="tap_area">
  <table class="type1">
    <caption>table</caption>
    <colgroup>
      <col style="width: 180px" />
      <col style="width: *" />
      <col style="width: 180px" />
      <col style="width: *" />
      <col style="width: 180px" />
      <col style="width: *" />
    </colgroup>
    <tbody>

      <tr>
        <th scope="row"><spring:message code="supplement.text.parcelTrackingNo" /></th>
        <td>${orderInfo.ssShipmentNo}</td>
        <th scope="row"><spring:message code="supplement.text.supplementDeliveryStatus" /></th>
        <td>
          <c:choose>
            <c:when test="${orderInfo.ssDelivryStusId=='0'}">
              <span class="status-pending">${orderInfo.ssDelivryStus}</span>
            </c:when>
            <c:when test="${orderInfo.ssDelivryStusId=='1'}">
              <span class="status-pickup">${orderInfo.ssDelivryStus}</span>
            </c:when>
            <c:when test="${orderInfo.ssDelivryStusId=='2'}">
              <span class="status-in-transit">${orderInfo.ssDelivryStus}</span>
            </c:when>
            <c:when test="${orderInfo.ssDelivryStusId=='3'}">
              <span class="status-out-for-delivery">${orderInfo.ssDelivryStus}</span>
            </c:when>
            <c:when test="${orderInfo.ssDelivryStusId=='4'}">
              <span class="status-delivered">${orderInfo.ssDelivryStus}</span>
            </c:when>
            <c:when test="${orderInfo.ssDelivryStusId=='5'}">
              <span class="status-returned">${orderInfo.ssDelivryStus}</span>
            </c:when>
            <c:otherwise>
              <span>${orderInfo.ssDelivryStus}</span>
            </c:otherwise>
          </c:choose>
        </td>

        <th scope="row"><spring:message code="sys.scm.onTimeDelivery.deliveryDate" /></th>
        <td>${orderInfo.ssDelivryDt}</td>
      </tr>
    </tbody>
  </table>
  <aside class="title_line">
    <h3><spring:message code="sal.title.text.filterList" /></h3>
  </aside>
  <article class="tap_area">
    <article class="grid_wrap">
      <div id="ss_itm_detail_grid_wrap" style="width: 100%; height: 200px; margin: 0 auto;"></div>
    </article>
  </article>
</article>
