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
        
        var gridPros = {
                usePaging           : true,         //페이징 사용
                pageRowCount        : 10,           //한 화면에 출력되는 행 개수 20(기본값:20)            
                editable            : false,            
                fixedColumnCount    : 0,            
                showStateColumn     : false,             
                displayTreeOpen     : false,            
              //selectionMode       : "singleRow",  //"multipleCells",            
                headerHeight        : 30,       
                useGroupingPanel    : false,        //그룹핑 패널 사용
                skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
                wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
                showRowNumColumn    : true,         //줄번호 칼럼 렌더러 출력    
                noDataMessage       : "No order found.",
                groupingMessage     : "Here groupping",
                wordWrap :  true
            };
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