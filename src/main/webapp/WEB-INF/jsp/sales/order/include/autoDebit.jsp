<script type="text/javaScript" language="javascript">

    //AUIGrid 생성 후 반환 ID
    var autoDebitGridID;
    
    $(document).ready(function(){
        //AUIGrid 그리드를 생성합니다.
        createAUIGrid7();
    });

    function createAUIGrid7() {
        
        //AUIGrid 칼럼 설정
        var columnLayout = [
            { headerText : '<spring:message code="sal.text.mnth" />',       dataField : "crtDtMm",      width : 120 }
          , { headerText : '<spring:message code="sal.title.text.mode" />', dataField : "batchMode",    width : 120 }
          , { headerText : '<spring:message code="sal.title.text.bank" />', dataField : "code"                      }
          , { headerText : '<spring:message code="sal.text.dateDeduct" />', dataField : "crtDtDd",      width : 150 }
          , { headerText : '<spring:message code="sal.title.amount" />',    dataField : "bankDtlAmt",   width : 100 }
          , { headerText : '<spring:message code="sal.text.isSuccess" />',  dataField : "isApproveStr", width : 120 }
          ];

        autoDebitGridID = GridCommon.createAUIGrid("grid_autoDebit_wrap", columnLayout, "", gridPros);
    }

    // 리스트 조회.
    function fn_selectAutoDebitList() {        
        Common.ajax("GET", "/sales/order/selectAutoDebitJsonList.do", {salesOrderId : '${orderDetail.basicInfo.ordId}'}, function(result) {
            AUIGrid.setGridData(autoDebitGridID, result);
        });
    }

</script>
<article class="tap_area"><!-- tap_area start -->

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="grid_autoDebit_wrap" style="width:100%; height:380px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</article><!-- tap_area end -->