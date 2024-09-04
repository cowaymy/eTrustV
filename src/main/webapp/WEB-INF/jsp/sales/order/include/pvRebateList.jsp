<script type="text/javaScript" language="javascript">

    //AUIGrid 생성 후 반환 ID
    var pvRebateGridID;

    $(document).ready(function(){
        //AUIGrid 그리드를 생성합니다.
        createAUIGrid8();
    });

    function createAUIGrid8() {

        //AUIGrid 칼럼 설정
        var columnLayout = [
            { headerText : '<spring:message code="sal.text.ordNo" />',        dataField : "salesOrdNo",      width : 150}
          , { headerText : '<spring:message code="sal.text.pvRebatePerInst" />',   dataField : "pvRebatePerInstlmt", width : 180 }
          , { headerText : '<spring:message code="sal.text.startInst" />',    dataField : "pvRebateStartInstlmt",  width : 180 }
          , { headerText : '<spring:message code="sal.text.endInst" />',      dataField : "pvRebateEndInstlmt",    width : 180 }
          ];

        pvRebateGridID = GridCommon.createAUIGrid("grid_pvRebate_wrap", columnLayout, "", gridPros);
    }

    function fn_selectPvRebateList() {
        Common.ajax("GET", "/sales/order/selectPvRebateList.do", {salesOrderId : '${orderDetail.basicInfo.ordId}'}, function(result) {
            AUIGrid.setGridData(pvRebateGridID, result);
        });
    }

</script>
<article class="tap_area"><!-- tap_area start -->

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="grid_pvRebate_wrap" style="width:100%; height:380px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</article><!-- tap_area end -->