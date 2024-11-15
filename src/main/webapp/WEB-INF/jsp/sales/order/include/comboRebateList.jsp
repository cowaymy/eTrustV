<script type="text/javaScript" language="javascript">

    //AUIGrid 생성 후 반환 ID
    var comboRebateGridID;

    $(document).ready(function(){
        //AUIGrid 그리드를 생성합니다.
        createAUIGrid8();
    });

    function createAUIGrid8() {

        //AUIGrid 칼럼 설정
        var columnLayout = [
            { headerText : '<spring:message code="sal.text.ordNo" />',        dataField : "salesOrdNo",      width : 150}
          , { headerText : 'Rebate Amount',   dataField : "rebateAmt", width : 180 }
          , { headerText : 'Rebate Start',    dataField : "fromPeriod",  width : 180 }
          , { headerText : 'Rebate End',      dataField : "toPeriod",    width : 180 }
          , { headerText : 'Rebate Status',      dataField : "stusDesc",    width : 180 }
          ];

        comboRebateGridID = GridCommon.createAUIGrid("grid_comboReabte_wrap", columnLayout, "", gridPros);
    }

    function fn_selectComboRebateList() {
        Common.ajax("GET", "/sales/order/selectComboRebateList.do", {salesOrderId : '${orderDetail.basicInfo.ordId}'}, function(result) {
            AUIGrid.setGridData(comboRebateGridID, result);
        });
    }

</script>
<article class="tap_area"><!-- tap_area start -->

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="grid_comboReabte_wrap" style="width:100%; height:380px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</article><!-- tap_area end -->