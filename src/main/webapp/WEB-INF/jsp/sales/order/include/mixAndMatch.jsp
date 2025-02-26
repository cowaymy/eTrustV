<script type="text/javaScript" language="javascript">

    //AUIGrid 생성 후 반환 ID
    var mixAndMatchGridID;

    $(document).ready(function(){
        //AUIGrid 그리드를 생성합니다.
        createAUIGrid8();
    });

    function createAUIGrid8() {

        //AUIGrid 칼럼 설정
        var columnLayout = [
            { headerText : 'Grouping ID',        dataField : "grpId"}
          , { headerText : 'Sales Order No',   dataField : "salesOrdNo"}
          , { headerText : 'Group Order Status',      dataField : "stusDesc"}
          ];

        mixAndMatchGridID = GridCommon.createAUIGrid("grid_mixAndMatch_wrap", columnLayout, "", gridPros);
    }

    function fn_selectMixAndMatchList() {
        Common.ajax("GET", "/sales/order/selectMixAndMatchList.do", {salesOrderId : '${orderDetail.basicInfo.ordId}'}, function(result) {
            AUIGrid.setGridData(mixAndMatchGridID, result);
        });
    }

</script>
<article class="tap_area"><!-- tap_area start -->

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="grid_mixAndMatch_wrap" style="width:100%; height:380px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</article><!-- tap_area end -->