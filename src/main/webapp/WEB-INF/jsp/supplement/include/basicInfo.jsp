<script type="text/javascript">
    var posItmDetailGridID;

    $(document).ready(function() {
        createPosPaymentDetailGrid();
    });

    function createPosPaymentDetailGrid() {
        var columnLayout = [ {
            dataField : "itemCode",
            headerText : "<spring:message code='log.head.itemcode'/>",
            width : '10%',
            editable : false
        }, {
            dataField : "itemDesc",
            headerText : "<spring:message code='log.head.itemdescription'/>",
            width : '60%',
            editable : false
        }, {
            dataField : "quantity",
            headerText : "<spring:message code='pay.head.quantity'/>",
            width : '10%',
            editable : false
        }, {
            dataField : "unitPrice",
            headerText : "<spring:message code='pay.head.unitPrice'/>",
            width : '10%',
            editable : false,
            dataType : "numeric",
            formatString : "#,##0.00"
        }, {
            dataField : "totalAmount",
            headerText : "<spring:message code='pay.head.totalAmount'/>",
            width : '10%',
            editable : false,
            dataType : "numeric",
            formatString : "#,##0.00"
        } ];

        var paymentGridPros = {
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

        posItmDetailGridID = GridCommon
                .createAUIGrid("payment_detail_grid_wrap_1", columnLayout, "",
                        paymentGridPros);

        var footerLayout = [ {
            labelText : "Total",
            positionField : "#base"
        }, {
            dataField : "totalAmount",
            positionField : "totalAmount",
            operation : "SUM",
            formatString : "#,##0.00",
            style : "aui-grid-my-footer-sum-total2"
        } ];

        AUIGrid.setFooter(posItmDetailGridID, footerLayout);

    }
 //   function fn_selectItemList() {
    var supRefId = ${orderInfo.supRefId};
    var param = {supRefId : supRefId };
    Common.ajax("GET", "/supplement/getSupplementDetailList", param, function(
            result) {
        AUIGrid.setGridData(posItmDetailGridID, result);
    })
  //}
</script>
<article class="tap_area">
  <!-- tap_area start -->
  <input type="hidden" id="_infoSupRefId" value="${orderInfo.supRefId}">
  <table class="type1">
    <!-- table start -->
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
        <th scope="row"><spring:message code="supplement.text.supplementReferenceProgressStage" /></th>
        <td colspan="5"><span>${orderInfo.supRefStg}</span></td>
      </tr>
      <tr>
        <th scope="row"><spring:message code="sal.text.refNo" /></th>
        <td>${orderInfo.supRefNo}</td>
        <th scope="row"><spring:message code="sal.title.refDate" /></th>
        <td>${orderInfo.supRefDate}</td>
        <th scope="row"><spring:message code="supplement.text.supplementReferenceStatus" /></th>
        <td>${orderInfo.supRefStus}</td>
      </tr>
      <tr>
        <th scope="row"><spring:message code="sal.text.appType" /></th>
        <td>${orderInfo.supApplTyp}</td>
        <th scope="row"><spring:message code="supplement.text.supplementTotalAmount" /></th>
        <td>${orderInfo.supTtlAmt}</td>
        <th</th>
        <td></td>
      </tr>
      <tr>
        <th scope="row"><spring:message code="supplement.text.eSOFno" /></th>
        <td>${orderInfo.sofNo}</td>
        <th scope="row"><spring:message code="supplement.text.submissionApproval" /></th>
        <td>${orderInfo.refCreateBy}</td>
        <th scope="row"><spring:message code="supplement.text.submissionBranch" /></th>
        <td>${orderInfo.submBrch}</td>
      </tr>
      <tr>
        <th scope="row"><spring:message code="supplement.text.supplementSubmissionApprovalDate" /></th>
        <td>${orderInfo.refCreateDate}</td>
        <th /></th>
        <td></td>
        <th /></th>
        <td></td>
      </tr>
      <tr>
        <th scope="row"><spring:message code="sal.title.text.pv" /></th>
        <td>${orderInfo.totPv}</td>
        <th scope="row"><spring:message code="sal.title.text.pvYear" /></th>
        <td>${orderInfo.pvYear}</td>
        <th scope="row"><spring:message code="service.title.PVMonth" /></th>
        <td>${orderInfo.pvMonth}</td>
      </tr>
    </tbody>
    </br>
  </table>
  <!-- table end -->
  </br> </br>
  <table class="type1">
    <!-- table start -->
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
    <tbody>
      <tr>
        <th scope="row" colspan="6"><span class="must">* The PV Year & Month is set to be 5 days after the Delivery Date.</span></th>
      </tr>
      <tr>
        <th scope="row"><spring:message code="supplement.text.supplementDeliveryStatus" /></th>
        <td>${orderInfo.supRefDelStus}</td>
        <th scope="row"><spring:message code="sys.scm.onTimeDelivery.deliveryDate" /></th>
        <td>${orderInfo.supRefDelDt}</td>
        <th /></th>
        <td></td>
      </tr>
      <tr>
        <th scope="row"><spring:message code="supplement.text.parcelTrackingNo" /></th>
        <td>${orderInfo.parcelTrackNo}</td>
        <th scope="row"><spring:message code="supplement.text.supplementProductReturnConsigNo" /></th>
        <td>${orderInfo.supConsgNo}</td>
        <th></th>
        <td></td>
      </tr>
    </tbody>
  </table>
  <!-- table end -->
  </br>
  <article class="tap_area">
    <article class="grid_wrap">
      <div id="payment_detail_grid_wrap_1" style="width: 100%;
  height: 200px;
  margin: 0 auto;"></div>
    </article>
  </article>
</article>
<!-- tap_area end -->
