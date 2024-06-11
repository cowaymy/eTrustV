<script type="text/javaScript" language="javascript">

    var docGridID;

    $(document).ready(function(){
        createAUIGrid3();
    });

    function createAUIGrid3() {

        //AUIGrid 칼럼 설정
        var columnLayout = [
            { headerText : '<spring:message code="sal.text.typeDoc" />',    dataField : "codeName"                }
          , { headerText : '<spring:message code="sal.text.submitDate" />', dataField : "docSubDt",   width : 120 }
          , { headerText : '<spring:message code="sal.text.quantity" />',   dataField : "docCopyQty", width : 120 }
          ];

        docGridID = GridCommon.createAUIGrid("grid_doc_wrap", columnLayout, "", gridPros);
    }

    // 리스트 조회.
    function fn_selectDocumentList() {
        //Common.ajax("GET", "/sales/order/selectDocumentJsonList.do", {salesOrderId : '${orderDetail.basicInfo.ordId}'}, function(result) {
        Common.ajax("GET", "/supplement/selectDocumentJsonList.do", {supRefId : '${orderInfo.supRefId}'}, function(result) {
            AUIGrid.setGridData(docGridID, result);
        });
    }
</script>

<article class="tap_area"><!-- tap_area start -->

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="grid_doc_wrap" style="width:100%; height:380px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</article><!-- tap_area end -->