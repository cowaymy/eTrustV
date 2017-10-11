<script type="text/javaScript" language="javascript">

    //AUIGrid 생성 후 반환 ID
    var discountGridID;
    
    $(document).ready(function(){
        //AUIGrid 그리드를 생성합니다.
        createAUIGrid8();
    });

    function createAUIGrid8() {
        
        //AUIGrid 칼럼 설정
        var columnLayout = [
            { headerText : "Order No",          dataField : "salesOrdNo",      width : 100 }
          , { headerText : "DiscountType",      dataField : "codeDesc",        width : 180 }
          , { headerText : "AmtPerInstalment",  dataField : "dcAmtPerInstlmt", width : 120 }
          , { headerText : "Start Installment", dataField : "dcStartInstlmt",  width : 120 }
          , { headerText : "End Installment",   dataField : "dcEndInstlmt",    width : 120 }
          , { headerText : "Remark",            dataField : "rem"                          }
          ];

        discountGridID = GridCommon.createAUIGrid("grid_discount_wrap", columnLayout, "", gridPros);
    }

    // 리스트 조회.
    function fn_selectDiscountList() {        
        Common.ajax("GET", "/sales/order/selectDiscountJsonList.do", {salesOrderId : '${orderDetail.basicInfo.ordId}'}, function(result) {
            AUIGrid.setGridData(discountGridID, result);
        });
    }
    
</script>
<article class="tap_area"><!-- tap_area start -->

<ul class="right_btns">
    <li><p class="btn_grid"><a href="#">EXCEL UP</a></p></li>
    <li><p class="btn_grid"><a href="#">EXCEL DW</a></p></li>
    <li><p class="btn_grid"><a href="#">DEL</a></p></li>
    <li><p class="btn_grid"><a href="#">INS</a></p></li>
    <li><p class="btn_grid"><a href="#">ADD</a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="grid_discount_wrap" style="width:100%; height:380px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</article><!-- tap_area end -->