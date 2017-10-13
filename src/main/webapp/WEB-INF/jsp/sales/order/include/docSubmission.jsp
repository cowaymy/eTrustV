<script type="text/javaScript" language="javascript">

    var docGridID;

    $(document).ready(function(){
        createAUIGrid3();
    });

    function createAUIGrid3() {
        
        //AUIGrid 칼럼 설정
        var columnLayout = [
            { headerText : "Type of Document", dataField : "codeName"                }
          , { headerText : "Submit Date",      dataField : "docSubDt",   width : 120 }
          , { headerText : "Quantity",         dataField : "docCopyQty", width : 120 }
          ];
        
        docGridID = GridCommon.createAUIGrid("grid_doc_wrap", columnLayout, "", gridPros);
    }
    
    // 리스트 조회.
    function fn_selectDocumentList() {        
        Common.ajax("GET", "/sales/order/selectDocumentJsonList.do", {salesOrderId : '${orderDetail.basicInfo.ordId}'}, function(result) {
            AUIGrid.setGridData(docGridID, result);
        });
    }
</script>

<article class="tap_area"><!-- tap_area start -->

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="grid_doc_wrap" style="width:100%; height:380px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</article><!-- tap_area end -->