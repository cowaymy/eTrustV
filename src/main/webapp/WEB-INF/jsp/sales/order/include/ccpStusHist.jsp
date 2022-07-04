<script type="text/javaScript" language="javascript">

    //AUIGrid 생성 후 반환 ID
    var ccpStusHistGridID;

    $(document).ready(function(){
        createAUIGridCcpStusHist();
    });

    function createAUIGridCcpStusHist() {

        //AUIGrid 칼럼 설정
        var columnLayoutCcpStusHist = [
            { headerText : '<spring:message code="sal.title.text.ccpStatus" />',    dataField : "stusCode",         width : 120 }
          , { headerText : '<spring:message code="sal.title.feedbackCode" />',   dataField : "feedbackCode", width : 120 }
          , { headerText : '<spring:message code="sal.title.text.specialRem" />',       dataField : "specialRemark",      width : 360  }
          , { headerText : '<spring:message code="pay.head.updatedBy" />',      dataField : "updatedBy",     width : 120 }
          , { headerText : '<spring:message code="sys.title.date" />',    dataField : "updateDate",      width : 160 }
          , { headerText : '<spring:message code="sal.title.text.time" />', dataField : "updateTime",         width : 120  }
          ];

        ccpStusHistGridID = GridCommon.createAUIGrid("grid_ccp_wrap", columnLayoutCcpStusHist, "", gridPros);
    }

    // 리스트 조회.
    function fn_selectCcpStusHistList() {
    	Common.ajax("GET", "/sales/ccp/selectCcpStusHistJsonList.do", {salesOrderId : '${orderDetail.basicInfo.ordId}'}, function(result) {
            AUIGrid.setGridData(ccpStusHistGridID, result);
        });
    }
</script>

<article class="tap_area"><!-- tap_area start -->

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="grid_ccp_wrap" style="width:100%; height:380px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</article><!-- tap_area end -->
