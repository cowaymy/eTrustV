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
  var canDeliveryInfoGridID;
  var rtnDeliveryInfoGridID

  $(document).ready(function() {
    createDelDetailGrid();
    createCancDelDetailGrid();
    createRtnItmDetailGrid();

    fn_maskingData('_addr1', '${orderInfo.addressLine1}');
    fn_maskingData('_addr2', '${orderInfo.addressLine2}');
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
      dataField : "delDt",
      headerText : "<spring:message code='log.head.deliverydate'/>",
      width : '25%',
      editable : false
    }, {
      dataField : "delStus",
      headerText : "<spring:message code='supplement.text.delStat'/>",
      width : '25%',
      editable : false
    }, {
      dataField : "delLoc",
      headerText : "<spring:message code='supplement.text.delLoc'/>",
      width : '20%',
      editable : false
    }, {
      dataField : "rmk",
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

  function createCancDelDetailGrid() {
    var canColumnLayout = [ {
      dataField : "delDt",
      headerText : "<spring:message code='log.head.deliverydate'/>",
      width : '25%',
      editable : false
    }, {
      dataField : "delStus",
      headerText : "<spring:message code='supplement.text.delStat'/>",
      width : '25%',
      editable : false
    }, {
      dataField : "delLoc",
      headerText : "<spring:message code='supplement.text.delLoc'/>",
      width : '20%',
      editable : false
    }, {
      dataField : "rmk",
      headerText : "<spring:message code='sal.title.remark'/>",
      width : '30%',
      editable : false,
    } ];

    var canDelRcdGridPros = {
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

    canDeliveryInfoGridID = GridCommon.createAUIGrid("canc_delivery_rec_grid_wrap", canColumnLayout, "", canDelRcdGridPros);
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
          dataField : "ttlGoodCond",
          headerText : "<spring:message code='supplement.text.supplementTtlRtnGoodCondQty'/>",
          width : '25%',
          editable : false,
          dataType : "numeric"
      }, {
          dataField : "ttlDefectCond",
          headerText : "<spring:message code='supplement.text.supplementTtlRtnDefectCondQty'/>",
          width : '25%',
          editable : false,
          dataType : "numeric"
      }, {
          dataField : "ttlMiaCond",
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

  var supRefId = '${orderInfo.supRefId}';
  var trkNo = '${orderInfo.parcelTrackNo}';
  var rtnTrkNo = '${cancellationDelInfo.rtnTckNo}';
  var param = {
    supRefId : supRefId,
    trkNo : trkNo
  };
  var rtnParam = {
    supRefId : supRefId,
    rtnTrkNo : (rtnTrkNo == "" ? "-" : rtnTrkNo)
  };

  Common.ajax("GET", "/supplement/getDelRcdLst", param, function(result) {
    AUIGrid.setGridData(deliveryInfoGridID, result);
  })

  Common.ajax("GET", "/supplement/getDelRcdLst", rtnParam, function(result) {
    AUIGrid.setGridData(canDeliveryInfoGridID, result);
  })

  Common.ajax("GET", "/supplement/getRtnItmRcdLst", rtnParam, function(result) {
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
        <td><span>${orderInfo.area}</span></td>
        <th scope="row"><spring:message code="sal.text.city" /></th>
        <td><span>${orderInfo.city}</span></td>
        <th scope="row"><spring:message code="sys.title.postcode" /></th>
        <td><span>${orderInfo.postcode}</span></td>
      </tr>
      <tr>
        <th scope="row"><spring:message code="service.title.State" /></th>
        <td><span>${orderInfo.state}</span></td>
        <th scope="row"><spring:message code="sys.country" /></th>
        <td><span>${orderInfo.country}</span></td>
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
          <td>${orderInfo.parcelTrackNo}</td>
          <th scope="row"><spring:message code="supplement.text.supplementDeliveryStatus" /></th>
          <td>
            <c:choose>
              <c:when test="${orderInfo.supRefDelStusId=='0'}">
                <span class="status-pending">${orderInfo.supRefDelStus}</span>
              </c:when>
              <c:when test="${orderInfo.supRefDelStusId=='1'}">
                <span class="status-pickup">${orderInfo.supRefDelStus}</span>
              </c:when>
              <c:when test="${orderInfo.supRefDelStusId=='2'}">
                <span class="status-in-transit">${orderInfo.supRefDelStus}</span>
              </c:when>
              <c:when test="${orderInfo.supRefDelStusId=='3'}">
                <span class="status-out-for-delivery">${orderInfo.supRefDelStus}</span>
              </c:when>
              <c:when test="${orderInfo.supRefDelStusId=='4'}">
                <span class="status-delivered">${orderInfo.supRefDelStus}</span>
              </c:when>
              <c:when test="${orderInfo.supRefDelStusId=='5'}">
                <span class="status-returned">${orderInfo.supRefDelStus}</span>
              </c:when>
              <c:otherwise>
                <span>${orderInfo.supRefDelStus}</span>
              </c:otherwise>
            </c:choose>
          </td>
          <th scope="row"><spring:message code="sys.scm.onTimeDelivery.deliveryDate" /></th>
          <td>${orderInfo.supRefDelDt}</td>
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

    <aside class="title_line">
      <h3>
        <spring:message code="supplement.text.cancDelRcd" />
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
          <th scope="row"><spring:message code="supplement.text.supplementCanReqNo" /></th>
          <td>${cancellationDelInfo.cancNo}</td>
          <th scope="row"><spring:message code="sal.title.text.returnNo" /></th>
          <td>${cancellationDelInfo.rtnNo}</td>
          <th scope="row"></th>
          <td></td>
        </tr>
        <tr>
          <th scope="row"><spring:message code="supplement.text.parcelTrackingNo" /></th>
          <td>${cancellationDelInfo.rtnTckNo}</td>
          <th scope="row"><spring:message code="sal.combo.text.recv" /> <spring:message code="sal.text.status" /></th>
          <td>
            <c:choose>
              <c:when test="${cancellationDelInfo.rtnStatId=='0'}">
                <span class="status-pending">${cancellationDelInfo.rtnStat}</span>
              </c:when>
              <c:when test="${cancellationDelInfo.rtnStatId=='1'}">
                <span class="status-active">${cancellationDelInfo.rtnStat}</span>
              </c:when>
              <c:when test="${cancellationDelInfo.rtnStatId=='102'}">
                <span class="status-ready">${cancellationDelInfo.rtnStat}</span>
              </c:when>
              <c:when test="${cancellationDelInfo.rtnStatId=='4'}">
                <span class="status-complete">${cancellationDelInfo.rtnStat}</span>
              </c:when>
              <c:when test="${cancellationDelInfo.rtnStatId=='10'}">
                <span class="status-cancel">${cancellationDelInfo.rtnStat}</span>
              </c:when>
              <c:otherwise>
                <span>${cancellationDelInfo.rtnStat}</span>
              </c:otherwise>
            </c:choose>
          </td>
          <th scope="row"><spring:message code="sal.title.text.recvDate" /></th>
          <td>${cancellationDelInfo.rtnDt}</td>
        </tr>
        <!-- <tr>
          <th scope="row"><spring:message code="supplement.text.supplementTtlRtnGoodCondQty" /></th>
          <td>${cancellationDelInfo.rtnGds}</td>
          <th scope="row"><spring:message code="supplement.text.supplementTtlRtnDefectCondQty" /></th>
          <td>${cancellationDelInfo.rtnBadGds}</td>
          <th scope="row"><spring:message code="supplement.text.supplementTtlRtnMissCondQty" /></th>
          <td>${cancellationDelInfo.rtnMiaGds}</td>
        </tr> -->
      </tbody>
    </table>
    <br/>
    <article class="">
      <article class="grid_wrap">
        <div id="canc_delivery_rec_grid_wrap"
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