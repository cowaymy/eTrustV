<script type="text/javaScript" language="javascript">

    //AUIGrid 생성 후 반환 ID
    var transGridID;
    
    $(document).ready(function(){
    	createAUIGrid6();
    });
    
    function createAUIGrid6() {
        
        //AUIGrid 칼럼 설정
        var columnLayout = [{
                dataField   : "colType",      headerText  : "colType",
                width       : 120,            editable    : false,
                style       : 'left_style'
            }, {
                dataField   : "colCurMth",    headerText  : "colCurMth",
                width       : 120,            editable    : false,
                style       : 'left_style'
            }, {
                dataField   : "colPrev1Mth",  headerText  : "colPrev1Mth",
                width       : 120,            editable    : false,
                style       : 'left_style'
            }, {
                dataField   : "colPrev2Mth",  headerText  : "colPrev2Mth",
                width       : 120,            editable    : false,
                style       : 'left_style'
            }, {
                dataField   : "colPrev3Mth",  headerText  : "colPrev3Mth",
                width       : 120,            editable    : false,
                style       : 'left_style'
            }, {
                dataField   : "colPrev4Mth",  headerText  : "colPrev4Mth",
                width       : 120,            editable    : false,
                style       : 'left_style'
            }, {
                dataField   : "colPrev5Mth", headerText  : "colPrev5Mth",
                width       : 120,            editable    : false,
                style       : 'left_style'
            }];

        transGridID = GridCommon.createAUIGrid("grid_trans_wrap", columnLayout, "", gridPros);
    }

    // 리스트 조회.
    function fn_selectTransList() {        
        Common.ajax("GET", "/sales/order/selectLast6MonthTransJsonList.do", {salesOrderId : '${orderDetail.basicInfo.ordId}'}, function(result) {
            AUIGrid.setGridData(transGridID, result);
        });
    }
</script>

<article class="tap_area"><!-- tap_area start -->

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="grid_trans_wrap" style="width:100%; height:380px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</article><!-- tap_area end -->
