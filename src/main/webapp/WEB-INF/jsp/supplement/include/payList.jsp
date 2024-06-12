<script type="text/javaScript" language="javascript">
  var payGridID;

  $(document).ready(function(){
    createAUIGrid5();
  });

  function createAUIGrid5() {
    var columnLayout = [{ headerText : '<spring:message code="sal.title.receiptNo" />',
                                     dataField : "orNo",
                                     width : 100 }
                                , { headerText : '<spring:message code="sal.title.reverseFor" />',
                                     dataField : "revReceiptNo",
                                     width : 100 }
                                , { headerText : '<spring:message code="sal.text.payDate" />',
                                     dataField : "payData",
                                     width : 80  }
                                , { headerText : '<spring:message code="sal.title.payType" />',
                                     dataField : "codeDesc",
                                     width : 120 }
                                , { headerText : '<spring:message code="sal.title.debtorAcc" />',
                                     dataField : "accCode",
                                     width : 100 }
                                , { headerText : '<spring:message code="sal.text.keyInBranchCd" />',
                                     dataField : "code",
                                     width : 90  }
                                , { headerText : '<spring:message code="sal.text.keyInBranchNm" />',
                                     dataField : "name1",
                                     width : 140 }
                                , { headerText : '<spring:message code="sal.text.totAmt" />',
                                     dataField : "totAmt",
                                     width : 100 }
    ];

    payGridID = GridCommon.createAUIGrid("grid_pay_wrap", columnLayout, "", gridPros);
  }

  function fn_selectPaymentList() {
    //Common.ajax("GET", "/sales/order/selectPaymentJsonList.do", {salesOrderId : '${orderDetail.basicInfo.ordId}'}, function(result) {
    Common.ajax("GET", "/supplement/selectPaymentJsonList.do", {supRefId : '${orderInfo.supRefId}'}, function(result) {
      AUIGrid.setGridData(payGridID, result);
    });
  }
</script>
<article class="tap_area">
  <aside class="title_line">
    <h3><spring:message code="sal.text.billingAddress" /></h3>
  </aside>
  <table class="type1">
  <caption>table</caption>
  <colgroup>
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:110px" />
    <col style="width:*" />
  </colgroup>
  <tbody>
    <tr>
      <th scope="row">Address Line 1</th>
      <td colspan="5"><span>${orderInfo.billAddressLine1}</span></td>
    </tr>
    <tr>
      <th scope="row">Address Line 2</th>
      <td colspan="5"><span>${orderInfo.billAddressLine2}</span></td>
    </tr>
    <tr>
      <th scope="row"><spring:message code="service.title.Area" /></th>
      <td><span>${orderInfo.billArea}</span></td>
      <th scope="row"><spring:message code="sal.text.city" /></th>
      <td><span>${orderInfo.billCity}</span></td>
      <th scope="row"><spring:message code="sys.title.postcode" /></th>
      <td><span>${orderInfo.billPostcode}</span></td>
    </tr>
    <tr>
      <th scope="row"><spring:message code="service.title.State" /></th>
      <td><span>${orderInfo.billState}</span></td>
      <th scope="row"><spring:message code="sys.country"/></th>
      <td><span>${orderInfo.billCountry}</span></td>
      <th </th>
      <td>
      </td>
    </tr>
  </tbody>
  </table>
  <aside class="title_line">
    <h3><spring:message code="pay.btn.paymentListing" /></h3>
  </aside>
  <article class="grid_wrap">
    <div id="grid_pay_wrap" style="width:100%; height:380px; margin:0 auto;"></div>
  </article>
</article>
