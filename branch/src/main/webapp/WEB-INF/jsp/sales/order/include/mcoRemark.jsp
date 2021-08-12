<script type="text/javaScript" language="javascript">

    //AUIGrid 생성 후 반환 ID
    var mcoRemarkGridID;

    $(document).ready(function(){
        //AUIGrid 그리드를 생성합니다.
        createAUIGrid8();
    });

    function createAUIGrid8() {

        //AUIGrid 칼럼 설정
        var columnLayout = [
            { headerText : 'Yes/No', dataField : "flag",      width : 150}
          , { headerText : 'Remark', dataField : "remark", width : 355 }
          , { headerText : 'Creator', dataField : "userName",  width : 180 }
          , { headerText : 'Create Date', dataField : "crtDt",    width : 180 }
          ];

        mcoRemarkGridID = GridCommon.createAUIGrid("grid_mcoRemark_wrap", columnLayout, "", gridPros);
    }

    function fn_selectMCORemarkList() {
        Common.ajax("GET", "/sales/order/selectMCORemarkList.do", {salesOrderId : '${orderDetail.basicInfo.ordId}'}, function(result) {
            AUIGrid.setGridData(mcoRemarkGridID, result);
        });
    }

</script>
<article class="tap_area"><!-- tap_area start -->

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="grid_mcoRemark_wrap" style="width:100%; height:380px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</article><!-- tap_area end -->