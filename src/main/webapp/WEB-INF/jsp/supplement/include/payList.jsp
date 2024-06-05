<script type="text/javaScript" language="javascript">

    //AUIGrid 생성 후 반환 ID
    var payGridID;

    $(document).ready(function(){
        createAUIGrid5();
    });

    function createAUIGrid5() {

        //AUIGrid 칼럼 설정
        var columnLayout = [
            { headerText : '<spring:message code="sal.title.receiptNo" />',    dataField : "orNo",         width : 100 }
          , { headerText : '<spring:message code="sal.title.reverseFor" />',   dataField : "revReceiptNo", width : 100 }
          , { headerText : '<spring:message code="sal.text.payDate" />',       dataField : "payData",      width : 80  }
          , { headerText : '<spring:message code="sal.title.payType" />',      dataField : "codeDesc",     width : 120 }
          , { headerText : '<spring:message code="sal.title.debtorAcc" />',    dataField : "accCode",      width : 100 }
          , { headerText : '<spring:message code="sal.text.keyInBranchCd" />', dataField : "code",         width : 90  }
          , { headerText : '<spring:message code="sal.text.keyInBranchNm" />', dataField : "name1",        width : 140 }
          , { headerText : '<spring:message code="sal.text.totAmt" />',        dataField : "totAmt",       width : 100 }
          ];

        payGridID = GridCommon.createAUIGrid("grid_pay_wrap", columnLayout, "", gridPros);
    }

    // 리스트 조회.
    function fn_selectPaymentList() {
        Common.ajax("GET", "/sales/order/selectPaymentJsonList.do", {salesOrderId : '${orderDetail.basicInfo.ordId}'}, function(result) {
            AUIGrid.setGridData(payGridID, result);
        });
    }
</script>

<article class="tap_area"><!-- tap_area start -->

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="grid_pay_wrap" style="width:100%; height:380px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</article><!-- tap_area end -->
