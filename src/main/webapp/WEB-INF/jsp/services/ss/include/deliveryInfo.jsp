<style>
  .inventory-statement {
    font-family: Arial, sans-serif;
    line-height: 1.6;
    margin: 10px;
    color: #333;
  }
  .inventory-statement ul  {
    list-style-type: disc;
    margin-left: 10px;
  }
  .inventory-statement ul ul {
    list-style-type: circle;
    margin-left: 20px;
    margin-top: 5px;
    margin-bottom: 5px;
  }
</style>

<script type="text/javascript">
  var deliveryInfoGridID;
  var rtnDeliveryInfoGridID

  $(document).ready(function() {
    createDelDetailGrid();
    createRtnItmDetailGrid();

    fn_maskingData('_addr1', '${orderDetail.installationInfo.instAddrDtl}');
    fn_maskingData('_addr2', '${orderDetail.installationInfo.instStreet}');
  });

  function fn_maskingData(ind, obj) {
    var maskedVal = (obj).substr(-10).padStart((obj).length, '*');
      $("#span" + ind).html(maskedVal);
      $("#span" + ind).hover(function() {
          $("#span" + ind).html(obj);
      }).mouseout(function() {
          $("#span" + ind).html(maskedVal);
      });
      $("#imgHover" + ind).hover(function() {
          $("#span" + ind).html(obj);
      }).mouseout(function() {
          $("#span" + ind).html(maskedVal);
      });
  }

  function createDelDetailGrid() {
    var columnLayout = [ {
      dataField : "delvyDt",
      headerText : "<spring:message code='log.head.deliverydate'/>",
      width : '25%',
      editable : false
    }, {
      dataField : "delvyStus",
      headerText : "<spring:message code='supplement.text.delStat'/>",
      width : '25%',
      editable : false
    }, {
      dataField : "delvyLoc",
      headerText : "<spring:message code='supplement.text.delLoc'/>",
      width : '20%',
      editable : false
    }, {
      dataField : "delvyRmk",
      headerText : "<spring:message code='sal.title.remark'/>",
      width : '30%',
      editable : false,
    } ];

    var delRcdGridPros = {
      usePaging : true,
      pageRowCount : 10,
      showStateColumn : true,
      displayTreeOpen : false,
      headerHeight : 30,
      useGroupingPanel : false,
      skipReadonlyColumns : true,
      wrapSelectionMove : true,
      showRowNumColumn : true
    };

    deliveryInfoGridID = GridCommon.createAUIGrid("delivery_rec_grid_wrap",
        columnLayout, "", delRcdGridPros);
  }


  function createRtnItmDetailGrid() {
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
          editable : false,
          dataType : "numeric"
      }, {
          dataField : "totMiaCond",
          headerText : "<spring:message code='supplement.text.supplementTtlRtnMissCondQty'/>",
          width : '25%',
          editable : false,
          dataType : "numeric"
      } ];

      var rtnItmGridPros = {
          showFooter : false,
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

      rtnDeliveryInfoGridID = GridCommon.createAUIGrid("item_delivery_rec_grid_wrap", columnLayout, "", rtnItmGridPros);
  }

  var schdulId = '${orderInfo.schdulId}';
  var trkNo = '${orderInfo.ssShipmentNo}';
  var param = {
    schdulId : schdulId
  };

  var rtnParam = {
	schdulId : schdulId
  };

  Common.ajax("GET", "/services/ss/getSelfServiceDelivryList", param, function(result) {
    AUIGrid.setGridData(deliveryInfoGridID, result);
  })

  Common.ajax("GET", "/services/ss/getSelfServiceRtnItmList", rtnParam, function(result) {
    AUIGrid.setGridData(rtnDeliveryInfoGridID, result);
  })
</script>

<article class="tap_area">
  <aside class="title_line">
    <h3>
      <spring:message code="sal.title.text.deliveryAddress" />
    </h3>
  </aside>
  <table class="type1">
    <caption>table</caption>
    <colgroup>
      <col style="width: 130px" />
      <col style="width: *" />
      <col style="width: 130px" />
      <col style="width: *" />
      <col style="width: 110px" />
      <col style="width: *" />
    </colgroup>
    <tbody>
      <tr>
        <th scope="row"><spring:message code="sal.text.addressDetail" /></th>
        <td colspan="5">
          <table>
           <tr>
             <td width="95%"><span id='span_addr1'></span></td>
             <td width="5">
               <a href="#" class="search_btn" id="imgHover_addr1">
                 <img style="height:70%" src="${pageContext.request.contextPath}/resources/images/common/nricEye2.png" />
               </a>
             </td>
           </tr>
          </table>
        </td>
      </tr>
      <tr>
        <th scope="row"><spring:message code="sal.text.street" /></th>
        <td colspan="5">
          <table>
           <tr>
             <td width="95%"><span id='span_addr2'></span></td>
             <td width="5">
               <a href="#" class="search_btn" id="imgHover_addr2">
                 <img style="height:70%" src="${pageContext.request.contextPath}/resources/images/common/nricEye2.png" />
               </a>
             </td>
           </tr>
          </table>
        </td>
      </tr>
      <tr>
        <th scope="row"><spring:message code="service.title.Area" /></th>
        <td><span>${orderDetail.installationInfo.instArea}</span></td>
        <th scope="row"><spring:message code="sal.text.city" /></th>
        <td><span>${orderDetail.installationInfo.instCity}</span></td>
        <th scope="row"><spring:message code="sys.title.postcode" /></th>
        <td><span>${orderDetail.installationInfo.instPostcode}</span></td>
      </tr>
      <tr>
        <th scope="row"><spring:message code="service.title.State" /></th>
        <td><span>${orderDetail.installationInfo.instState}</span></td>
        <th scope="row"><spring:message code="sys.country" /></th>
        <td><span>${orderDetail.installationInfo.instCountry}</span></td>
        <th  scope="row"></th>
        <td></td>
      </tr>
    </tbody>
  </table>
  <br/>
  <article class="tap_area">
    <aside class="title_line">
      <h3>
        <spring:message code="supplement.text.delRcd" />
      </h3>
    </aside>
    <table class="type1">
      <caption>table</caption>
      <colgroup>
        <col style="width: 150px" />
        <col style="width: *" />
        <col style="width: 150px" />
        <col style="width: *" />
        <col style="width: 150px" />
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
    <br/>
    <article class="">
      <article class="grid_wrap">
        <div id="delivery_rec_grid_wrap"
          style="width: 100%; height: 350px; margin: 0 auto;"></div>
      </article>
    </article>
    <article class="">
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
        <div id="item_delivery_rec_grid_wrap"
          style="width: 100%; height: 200px; margin: 0 auto;"></div>
      </article>
    </article>
  </article>
</article>