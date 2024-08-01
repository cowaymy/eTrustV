<script type="text/javaScript" language="javascript">
  var payGridID;

  $(document).ready(function() {
    createPayLstAUIGrid5();

    fn_maskingData('_billAddr1', '${orderInfo.billAddressLine1}');
    fn_maskingData('_billAddr2', '${orderInfo.billAddressLine2}');
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

  function createPayLstAUIGrid5() {
    var columnLayout = [ {
      headerText : '<spring:message code="sal.title.receiptNo" />',
      dataField : "orNo",
      width : "15%"
    }, {
      headerText : '<spring:message code="sal.title.reverseFor" />',
      dataField : "revReceiptNo",
      width : "10%"
    }, {
      headerText : '<spring:message code="sal.text.payDate" />',
      dataField : "payData",
      width : "15%"
    }, {
      headerText : '<spring:message code="sal.title.payType" />',
      dataField : "codeDesc",
      width : "10%"
    }, {
      headerText : '<spring:message code="sal.title.debtorAcc" />',
      dataField : "accCode",
      width : "10%"
    }, {
      headerText : '<spring:message code="sal.text.keyInBranchCd" />',
      dataField : "code",
      width : "10%"
    }, {
      headerText : '<spring:message code="sal.text.keyInBranchNm" />',
      dataField : "name1",
      width : "15%"
    }, {
      headerText : '<spring:message code="sal.text.totAmt" />',
      dataField : "totAmt",
      width : "15%",
      dataType : "numeric",
      formatString : "#,##0.00"
    } ];

    payGridID = GridCommon.createAUIGrid("grid_pay_wrap", columnLayout, "", gridPros);
  }

  function fn_selectPaymentList() {
    Common.ajax("GET", "/supplement/selectPaymentJsonList.do", {
      supRefId : '${orderInfo.supRefId}'
    }, function(result) {
      AUIGrid.setGridData(payGridID, result);
    });
  }
</script>
<article class="tap_area">
  <aside class="title_line">
    <h3>
      <spring:message code="sal.text.billingAddress" />
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
             <td width="95%"><span id='span_billAddr1'></span></td>
             <td width="5">
               <a href="#" class="search_btn" id="imgHover_billAddr1">
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
             <td width="95%"><span id='span_billAddr2'></span></td>
             <td width="5">
               <a href="#" class="search_btn" id="imgHover_billAddr2">
                 <img style="height:70%" src="${pageContext.request.contextPath}/resources/images/common/nricEye2.png" />
               </a>
             </td>
           </tr>
          </table>
        </td>
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
        <th scope="row"><spring:message code="sys.country" /></th>
        <td><span>${orderInfo.billCountry}</span></td>
        <th scope="row"></th>
        <td></td>
      </tr>
    </tbody>
  </table>
  <aside class="title_line">
    <h3>
      <spring:message code="pay.btn.paymentListing" />
    </h3>
  </aside>
  <article class="grid_wrap">
    <div id="grid_pay_wrap"
      style="width: 100%; height: 380px; margin: 0 auto;"></div>
  </article>
</article>
