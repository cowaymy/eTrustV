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
            { headerText : "Month",       dataField : "crtDtMm",      width : 120 }
          , { headerText : "Mode",        dataField : "batchMode",    width : 120 }
          , { headerText : "Bank",        dataField : "code"                      }
          , { headerText : "Date Deduct", dataField : "crtDtDd",      width : 150 }
          , { headerText : "Amount",      dataField : "bankDtlAmt",   width : 100 }
          , { headerText : "Success ?",   dataField : "isApproveStr", width : 120 }
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