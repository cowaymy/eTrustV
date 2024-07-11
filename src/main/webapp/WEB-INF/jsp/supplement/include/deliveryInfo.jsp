<script type="text/javascript">
  var deliveryInfoGridID;
  var canDeliveryInfoGridID;

  $(document).ready(function() {
    createDelDetailGrid();
    createCancDelDetailGrid();

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
      fixedColumnCount : 1,
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
      dataField : "cdelDt",
      headerText : "<spring:message code='log.head.deliverydate'/>",
      width : '20%',
      editable : false
    }, {
      dataField : "cdelStus",
      headerText : "<spring:message code='supplement.text.delStat'/>",
      width : '30%',
      editable : false
    }, {
      dataField : "cdelLoc",
      headerText : "<spring:message code='supplement.text.delLoc'/>",
      width : '20%',
      editable : false
    }, {
      dataField : "crmk",
      headerText : "<spring:message code='sal.title.remark'/>",
      width : '30%',
      editable : false,
    } ];

    var canDelRcdGridPros = {
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

    canDeliveryInfoGridID = GridCommon.createAUIGrid("canc_delivery_rec_grid_wrap", canColumnLayout, "", canDelRcdGridPros);
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
          <td>${orderInfo.parcelTrackNo}</td>
          <th scope="row"><spring:message code="supplement.text.supplementDeliveryStatus" /></th>
          <td>${orderInfo.supRefDelStus}</td>
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
        <col style="width: 180px" />
        <col style="width: *" />
        <col style="width: 180px" />
        <col style="width: *" />
        <col style="width: 180px" />
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
          <td>${cancellationDelInfo.rtnStat}</td>
          <th scope="row"><spring:message code="sal.title.text.recvDate" /></th>
          <td>${cancellationDelInfo.rtnDt}</td>
        </tr>
        <tr>
          <th scope="row"><spring:message code="supplement.text.supplementTtlRtnGoodCondQty" /></th>
          <td>${cancellationDelInfo.rtnGds}</td>
          <th scope="row"><spring:message code="supplement.text.supplementTtlRtnDefectCondQty" /></th>
          <td>${cancellationDelInfo.rtnBadGds}</td>
          <th scope="row"><spring:message code="supplement.text.supplementTtlRtnMissCondQty" /></th>
          <td>${cancellationDelInfo.rtnMiaGds}</td>
        </tr>
      </tbody>
    </table>
    <br/>
    <article class="">
      <article class="grid_wrap">
        <div id="canc_delivery_rec_grid_wrap"
          style="width: 100%; height: 350px; margin: 0 auto;"></div>
      </article>
    </article>
  </article>
</article>