<script type="text/javaScript" language="javascript">

    var callLogGridID;

    $(document).ready(function(){
        createAUIGrid4();
    });

    function createAUIGrid4() {
        
        //AUIGrid 칼럼 설정
        var columnLayout = [
            { headerText : "No",          dataField : "rownum",            visible  : false }
          , { headerText : "Type",        dataField : "codeName",          width : 150 }
          , { headerText : "Feedback",    dataField : "resnDesc",          width : 120 }
          , { headerText : "Action",      dataField : "stusName",          width : 120 }
          , { headerText : "Amount",      dataField : "callRosAmt",        width : 70  }
          , { headerText : "Remark",      dataField : "callRem",           width : 250 }
          , { headerText : "Caller",      dataField : "rosCallerUserName", width : 120 }
          , { headerText : "Creator",     dataField : "callCrtUserName",   width : 80  }
          , { headerText : "Create Date", dataField : "callCrtDt",         width : 130 }
          ];

        callLogGridID = GridCommon.createAUIGrid("grid_callLog_wrap", columnLayout, "", gridPros);
    }

    // 리스트 조회.
    function fn_selectCallLogList() {        
        Common.ajax("GET", "/sales/order/selectCallLogJsonList.do", {salesOrderId : '${orderDetail.basicInfo.ordId}'}, function(result) {
            AUIGrid.setGridData(callLogGridID, result);
        });
    }
</script>
    
<article class="tap_area"><!-- tap_area start -->

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="grid_callLog_wrap" style="width:100%; height:380px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</article><!-- tap_area end -->