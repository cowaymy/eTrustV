<script type="text/javaScript" language="javascript">

    //AUIGrid 생성 후 반환 ID
    var payGridID;
    
    $(document).ready(function(){
        createAUIGrid5();
    });
    
    function createAUIGrid5() {
        
        //AUIGrid 칼럼 설정
        var columnLayout = [
            { headerText : "Receipt No",              dataField : "orNo",         width : 100 }
          , { headerText : "Reverse For",             dataField : "revReceiptNo", width : 100 }
          , { headerText : "Payment<br>Date",         dataField : "payData",      width : 80  }
          , { headerText : "Payment Type",            dataField : "codeDesc",     width : 120 }
          , { headerText : "Debtor Acc",              dataField : "accCode",      width : 100 }
          , { headerText : "Key-In Branch<br>(Code)", dataField : "code",         width : 90  }
          , { headerText : "Key-In Branch<br>(Name)", dataField : "name1",        width : 140 }
          , { headerText : "Total Amount",            dataField : "totAmt",       width : 100 }
          , { headerText : "Creator",                 dataField : "userName",     width : 80  }
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
