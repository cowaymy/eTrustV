<script type="text/javaScript" language="javascript">

    //AUIGrid 생성 후 반환 ID
    var gstRebateGridID;
    
    $(document).ready(function(){
        //AUIGrid 그리드를 생성합니다.
        createAUIGrid8();
    });

    function createAUIGrid8() {
        
        //AUIGrid 칼럼 설정
        var columnLayout = [
            { headerText : '<spring:message code="sal.text.ordNo" />',        dataField : "salesOrdNo",      width : 150}
          , { headerText : '<spring:message code="sal.text.amtPerInst" />',   dataField : "rebateAmtPerInstlmt", width : 180 }
          , { headerText : '<spring:message code="sal.text.startInst" />',    dataField : "rebateStartInstlmt",  width : 180 }
          , { headerText : '<spring:message code="sal.text.endInst" />',      dataField : "rebateEndInstlmt",    width : 180 }
          ];

        gstRebateGridID = GridCommon.createAUIGrid("grid_gstReabte_wrap", columnLayout, "", gridPros);
    }

    function fn_selectGstRebateList() {        
        Common.ajax("GET", "/sales/order/selectGSTRebateList.do", {salesOrderId : '${orderDetail.basicInfo.ordId}'}, function(result) {
            AUIGrid.setGridData(gstRebateGridID, result);
        });
    }
    
</script>
<article class="tap_area"><!-- tap_area start -->

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="grid_gstReabte_wrap" style="width:100%; height:380px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</article><!-- tap_area end -->