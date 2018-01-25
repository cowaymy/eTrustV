<script type="text/javaScript" language="javascript">

    //AUIGrid 생성 후 반환 ID
    var transGridID;
    
    $(document).ready(function(){
    	createAUIGrid6();
    	
        AUIGrid.bind(transGridID, "cellClick", function(event) {
            //alert("rowIndex : " + event.rowIndex + ", " + "columnIndex : " + event.columnIndex + " clicked");
              fn_callSvcPop(event.rowIndex, event.columnIndex);
        });
    });
    
    function fn_callSvcPop(rowIdx, colIdx) {
        if(rowIdx == 0 || colIdx == 0) {
            return false;
        }
        else {
            var cVal = AUIGrid.getCellValue(transGridID, rowIdx, colIdx);
            var aVal = cVal.split("-");
            var sVal = aVal[0].trim();
            
            if(sVal.substr(0, 2) == "AS" || sVal.substr(0, 2) == "AA") {
                
                var asId = 0;
                var asNo, asStusId, asResultNo;
                
                Common.ajaxSync("GET", "/sales/order/selectASInfoList.do", {asNo : sVal}, function(result) {
                    if(result != null && result.length > 0) {
                        console.log('result.outSuts[0].ordTotOtstnd:'+result[0].ordTotOtstnd);
        
                        asId = result[0].asId;
                        asStusId = result[0].asStusId;
                        asResultNo = result[0].asResultNo;
                    }
                });
               
                if(asId != 0) {
                    //var param = "?ord_Id="+salesOrdId+"&ord_No="+salesOrdNo+"&as_No="+asNo+"&as_Id="+asid+"&mod=RESULTVIEW&as_Result_No="+asResultNo;                
                    Common.popupDiv("/services/as/asResultEditViewPop.do" , {ord_Id : '${orderDetail.basicInfo.ordId}', ord_No : '${orderDetail.basicInfo.ordNo}', as_No : sVal, as_Id : asId, mod : 'RESULTVIEW', as_Result_No : asResultNo}, null , true , '_newASResultDiv1');
                }
                else {
                    Common.alert("No Result View" + DEFAULT_DELIMITER + "<b>No AS result to view.</b>");
                }
            }
            else if(sVal.substr(0, 2) == "BS" || sVal.substr(0, 2) == "HS") {
                
                var schdulId = fn_getCurrentBSResultByBSNo(sVal);
                
                console.log('@#### schdulId:'+schdulId);
                
                if(schdulId != 0) {
                    Common.popupDiv("/sales/order/hsBasicInfoPop.do", {schdulId : schdulId, salesOrdId : '${orderDetail.basicInfo.ordId}', MOD : 'VIEW'}, null , true , '_bsBasicPop'); 
                }
                else {
                    Common.alert("No Result View" + DEFAULT_DELIMITER + "<b>No BS result to view.</b>");
                }
            }
            else {
                Common.alert("No Data View" + DEFAULT_DELIMITER + "<b>No information to display.</b>");
            }
        }
    }
    
    function fn_getCurrentBSResultByBSNo(bsNo) {
        var schdulId = 0;
        Common.ajaxSync("GET", "/sales/order/selectCurrentBSResultByBSNo.do", {no : bsNo}, function(result) {
            if(result != null) {
                schdulId = result.schdulId;
            }
       });
       return schdulId;
    }
    
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
<form id="frmBsSrch" name="frmBsSrch" action="#" method="post">
    <input id="MOD"        name="MOD"        type="hidden" value="VIEW" />
    <input id="salesOrdId" name="salesOrdId" type="hidden" value="${orderDetail.basicInfo.ordId}" />
    <input id="schdulId"   name="schdulId"   type="hidden" />
</form>
<article class="grid_wrap"><!-- grid_wrap start -->
<div id="grid_trans_wrap" style="width:100%; height:380px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</article><!-- tap_area end -->
