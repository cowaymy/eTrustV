<script type="text/javaScript" language="javascript">

    //AUIGrid 생성 후 반환 ID
    var fmcoEvoucherGridID;

    $(document).ready(function(){
        //AUIGrid 그리드를 생성합니다.
        createAUIGrid8();
    });

    function createAUIGrid8() {

        //AUIGrid 칼럼 설정
        var columnLayout = [
            { headerText : 'HS No.', dataField : "hsno",      width : 180}
          , { headerText : 'HS Result', dataField : "hsresult", width : 180 }
          , { headerText : 'E-voucher Selection', dataField : "voucher",  width : 355 }
          ];

        fmcoEvoucherGridID = GridCommon.createAUIGrid("grid_fmcoEvoucher_wrap", columnLayout, "", gridPros);
    }

    function fn_selectMCORemarkList() {
        Common.ajax("GET", "/sales/order/selectFmcoEvoucherList.do", {salesOrderId : '${orderDetail.basicInfo.ordId}'}, function(result) {
            AUIGrid.setGridData(fmcoEvoucherGridID, result);
        });
    }

</script>
<article class="tap_area"><!-- tap_area start -->

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="grid_fmcoEvoucher_wrap" style="width:100%; height:380px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</article><!-- tap_area end -->