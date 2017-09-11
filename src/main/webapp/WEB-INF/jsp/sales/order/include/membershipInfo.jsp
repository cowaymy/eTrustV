<script type="text/javaScript" language="javascript">

    //AUIGrid 생성 후 반환 ID
    var memInfoGridID;
    
    $(document).ready(function(){
        //AUIGrid 그리드를 생성합니다.
        createAUIGrid2();
    });
    
    function createAUIGrid2() {
        
        //AUIGrid 칼럼 설정
        var columnLayout = [
            { headerText : "Membership<br>No",    dataField : "mbrshNo",       width   : 120   }
          , { headerText : "Bill No",             dataField : "mbrshBillNo",   width   : 100   }
          , { headerText : "Date",                dataField : "mbrshCrtDt",    width   : 70    }
          , { headerText : "Status",              dataField : "mbrshStusCode", width   : 70    }
          , { headerText : "Package",             dataField : "pacName"                        }
          , { headerText : "Start",               dataField : "mbrshStartDt",  width   : 70    }
          , { headerText : "End",                 dataField : "mbrshExprDt",   width   : 70    }
          , { headerText : "Duration<br>(month)", dataField : "mbrshDur",      width   : 100   }
          , { headerText : "salesOrdId",          dataField : "salesOrdId",    visible : false }
          ];

        memInfoGridID = GridCommon.createAUIGrid("grid_memInfo_wrap", columnLayout, "", gridPros);
    }
    
    // 리스트 조회.
    function fn_selectMembershipInfoList() {        
        Common.ajax("GET", "/sales/order/selectMembershipInfoJsonList.do", {salesOrderId : '${orderDetail.basicInfo.ordId}'}, function(result) {
            AUIGrid.setGridData(memInfoGridID, result);
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
<div id="grid_memInfo_wrap" style="width:100%; height:380px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</article><!-- tap_area end -->