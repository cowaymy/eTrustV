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
    var subItmDetailGridID;

    $(document).ready(function() {
        createSubItmDetailGrid();
    });

    function createSubItmDetailGrid() {
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

        subItmDetailGridID = GridCommon.createAUIGrid("sub_itm_detail_grid_wrap_1", columnLayout, "", paymentGridPros);

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

        AUIGrid.setFooter(subItmDetailGridID, footerLayout);

    }

    var supRefId = '${orderInfo.supRefId}';
    var param = {supRefId : supRefId };
    Common.ajax("GET", "/supplement/getSupplementDetailList", param, function(result) {
      AUIGrid.setGridData(subItmDetailGridID, result);
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
        <th scope="row"><spring:message
            code="supplement.text.supplementReferenceProgressStage" /></th>
        <td colspan="5"><span>${orderInfo.supRefStg}</span></td>
      </tr>
      <tr>
        <th scope="row"><spring:message code="supplement.text.supplementReferenceNo" /></th>
        <td>${orderInfo.supRefNo}</td>
        <th scope="row"><spring:message code="supplement.text.eSOFno" /></th>
        <td>${orderInfo.sofNo}</td>
        <th scope="row"><spring:message code="supplement.text.submissionBranch" /></th>
        <td>${orderInfo.submBrch}</td>
      </tr>
      <tr>
        <th scope="row"><spring:message code="supplement.text.supplementReferenceStatus" /></th>
        <td>
          <c:choose>
            <c:when test="${orderInfo.supRefStusId=='1'}">
              <span class="status-active">${orderInfo.supRefStus}</span>
            </c:when>
            <c:when test="${orderInfo.supRefStusId=='4'}">
              <span class="status-complete">${orderInfo.supRefStus}</span>
            </c:when>
            <c:when test="${orderInfo.supRefStusId=='10'}">
              <span class="status-cancel">${orderInfo.supRefStus}</span>
            </c:when>
            <c:otherwise>
              <span>${orderInfo.supRefStus}</span>
            </c:otherwise>
          </c:choose>
        </td>
        <!-- <th scope="row"><spring:message code="sal.text.appType" /></th>
        <td>${orderInfo.supApplTyp}</td> -->
        <th scope="row"><spring:message code="supplement.text.supplementTotalAmount" /></th>
        <td>${orderInfo.supTtlAmt}</td>
        <th scope="row"><spring:message code="supplement.text.isRefund" /></th>
        <td>
          <c:choose>
            <c:when test="${orderInfo.isRefund=='Y'}">
              <input type="checkbox" value="Y" id="isRefund" name="isRefund" checked disabled/>
            </c:when>
            <c:otherwise>
              <input type="checkbox" value="Y" id="isRefund" name="isRefund" disabled/>
            </c:otherwise>
          </c:choose>
        </td>
      </tr>
      <tr>
        <th scope="row"><spring:message code="supplement.title.supplementType"/></th>
        <td><span>${orderInfo.supTyp}</span></td>
        <th scope="row"><spring:message code="supplement.title.freeGiftOrdNo"/></th>
        <td><span>${orderInfo.salesOrdNo}</span></td>
        <th></th>
        <td></td>
      </tr>
      <tr>
        <th scope="row"><spring:message code="sal.text.createDate" /></th>
        <td>${orderInfo.supRefDate}</td>
        <th scope="row"><spring:message
            code="supplement.text.submissionApproval" /></th>
        <td>${orderInfo.refCreateBy}</td>
        <th scope="row"><spring:message
            code="supplement.text.supplementSubmissionApprovalDate" /></th>
        <td>${orderInfo.refCreateDate}</td>
      </tr>
      <tr>
        <th scope="row"><spring:message code="supplement.text.remark" /></th>
        <td colspan="5">${orderInfo.rmk}</td>
      </tr>
      <tr>
        <td></td>
      </tr>
      <tr>
        <th scope="row" colspan="6"><span class="must">* <spring:message
            code="supplement.text.supplementPvRemark" /></span></th>
      </tr>
      <tr>
        <th scope="row"><spring:message code="sal.title.text.pv" /></th>
        <td>${orderInfo.totPv}</td>
        <th scope="row"><spring:message code="sal.title.text.pvYear" /></th>
        <td>${orderInfo.pvYear}</td>
        <th scope="row"><spring:message code="service.title.PVMonth" /></th>
        <td>${orderInfo.pvMonth}</td>
      </tr>
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
      <!-- <tr>
        <th scope="row"><spring:message code="supplement.text.supplementProductReturnConsigNo" /></th>
        <td>${orderInfo.supConsgNo}</td>
        <th></th>
        <td></td>
         <th></th>
        <td></td>
      </tr> -->
       <tr>
         <th scope="row"><spring:message code="supplement.text.supplementProductReturnConsigNo" /></th>
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
    </tbody>
    </br>
  </table>
  <aside class="title_line">
    <h3><spring:message code="sal.title.itmList" /></h3>
  </aside>
  <article class="tap_area">
    <article class="grid_wrap">
      <div id="sub_itm_detail_grid_wrap_1" style="width: 100%; height: 200px; margin: 0 auto;"></div>
    </article>
  </article>
</article>
