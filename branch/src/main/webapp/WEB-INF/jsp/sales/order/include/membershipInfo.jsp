<script type="text/javaScript" language="javascript">

    //AUIGrid 생성 후 반환 ID
    var memInfoGridID;
    
    $(document).ready(function(){
        //AUIGrid 그리드를 생성합니다.
        createAUIGrid2();
        
        fn_selectMembershipInfoList();
    });
    
    function createAUIGrid2() {
        
        //AUIGrid 칼럼 설정
        var columnLayout = [
            { headerText : '<spring:message code="sal.title.mbrshNo" />',     dataField : "mbrshNo",       width   : 120   }
          , { headerText : '<spring:message code="sal.text.billNo" />',       dataField : "mbrshBillNo",   width   : 100   }
          , { headerText : '<spring:message code="sal.title.date" />',        dataField : "mbrshCrtDt",    width   : 90    }
          , { headerText : '<spring:message code="sal.text.status" />',       dataField : "mbrshStusCode", width   : 70    }
          , { headerText : '<spring:message code="sal.text.package" />',      dataField : "pacName"                        }
          , { headerText : '<spring:message code="sal.text.start" />',        dataField : "mbrshStartDt",  width   : 90    }
          , { headerText : '<spring:message code="sal.text.end" />',          dataField : "mbrshExprDt",   width   : 90    }
          , { headerText : '<spring:message code="sal.text.durationMnth" />', dataField : "mbrshDur",      width   : 80    }
          , { headerText : "salesOrdId",                                      dataField : "salesOrdId",    visible : false }
          ];

        memInfoGridID = GridCommon.createAUIGrid("grid_memInfo_wrap", columnLayout, "", gridPros);
    }
    
    // 리스트 조회.
    function fn_selectMembershipInfoList() { console.log('fn_selectMembershipInfoList');       
        Common.ajax("GET", "/sales/order/selectMembershipInfoJsonList.do", {salesOrderId : '${orderDetail.basicInfo.ordId}'}, function(result) {
            AUIGrid.setGridData(memInfoGridID, result);
        });
    }
    
</script>
    
<article class="tap_area"><!-- tap_area start -->

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="grid_memInfo_wrap" style="width:100%; height:380px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</article><!-- tap_area end -->