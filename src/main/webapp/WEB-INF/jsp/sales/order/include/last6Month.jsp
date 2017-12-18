<script type="text/javaScript" language="javascript">

    //AUIGrid 생성 후 반환 ID
    var transGridID;
    
    $(document).ready(function(){
    	createAUIGrid6();
    });
    
    function createAUIGrid6() {
        
        var gridPros6 = {
            usePaging           : true,         //페이징 사용
            pageRowCount        : 10,           //한 화면에 출력되는 행 개수 20(기본값:20)            
            editable            : false,            
            fixedColumnCount    : 0,            
            showHeader          : false,             
            showStateColumn     : false,             
            displayTreeOpen     : false,            
          //selectionMode       : "singleRow",  //"multipleCells",            
            headerHeight        : 30,       
            useGroupingPanel    : false,        //그룹핑 패널 사용
            skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
            wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
            showRowNumColumn    : false,        //줄번호 칼럼 렌더러 출력    
            noDataMessage       : "No order found.",
            groupingMessage     : "Here groupping"
        };
    
        //AUIGrid 칼럼 설정
        var columnLayout = [
            { headerText : "Type",          dataField : "type"  }
          , { headerText : "Current Month", dataField : "curMonth",     width : 120 }
          , { headerText : "prev1Month",    dataField : "prev1Month",   width : 120 }
          , { headerText : "prev2Month",    dataField : "prev2Month",   width : 120 }
          , { headerText : "prev3Month",    dataField : "prev3Month",   width : 120 }
          , { headerText : "prev4Month",    dataField : "prev4Month",   width : 120 }
          , { headerText : "prev5Month",    dataField : "prev5Month",   width : 120 }
          ];

        transGridID = GridCommon.createAUIGrid("grid_trans_wrap", columnLayout, "", gridPros6);

    }

    // 리스트 조회.
    function fn_selectTransList() {        
        Common.ajax("GET", "/sales/order/selectLast6MonthTransJsonList.do", {salesOrdId : '${orderDetail.basicInfo.ordId}', appTypeId : '${orderDetail.basicInfo.appTypeId}'}, function(result) {
            AUIGrid.setGridData(transGridID, result);
        });
    }
</script>

<article class="tap_area"><!-- tap_area start -->

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="grid_trans_wrap" style="width:100%; height:380px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</article><!-- tap_area end -->
