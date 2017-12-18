<script type="text/javaScript" language="javascript">

    //AUIGrid 생성 후 반환 ID
    var ecashGridID;
    
    $(document).ready(function(){
        //AUIGrid 그리드를 생성합니다.
        createAUIGrid9();
    });

    function createAUIGrid9() {
        
        //AUIGrid 칼럼 설정
        var columnLayout = [
            { headerText : "Deduction Date", dataField : "fileItmCrt",    width : 120 }
          , { headerText : "Payment Type",   dataField : "codeName" }
          , { headerText : "Amount",         dataField : "fileItmAmt",    width : 120 }
          , { headerText : "Success ?",      dataField : "isSuccess",     width : 120 }
          , { headerText : "Reason",         dataField : "fileItmRem",    width : 260 }
          ];

        ecashGridID = GridCommon.createAUIGrid("grid_ecash_wrap", columnLayout, "", gridPros);
    }

    // 리스트 조회.
    function fn_selectEcashList() {        
        Common.ajax("GET", "/sales/order/selectEcashList.do", {salesOrderId : '${orderDetail.basicInfo.ordId}'}, function(result) {
            AUIGrid.setGridData(ecashGridID, result);
        });
    }

</script>
<article class="tap_area"><!-- tap_area start -->

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="grid_ecash_wrap" style="width:100%; height:380px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->
<ul class="left_opt">
    <li><span class="red_text">**</span> <span class="brown_text">Disclaimer : This data is subject to Coway private information property which is not meant to view by any public other than coway internal staff only.</span></li>
</ul>
</article><!-- tap_area end -->