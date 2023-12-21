<script type="text/javaScript" language="javascript">

    //AUIGrid 생성 후 반환 ID
    var failRemarkGridID;

    $(document).ready(function(){
        //AUIGrid 그리드를 생성합니다.
        createAUIGrid();
        fn_selectFailRemarkList();
    });

    function createAUIGrid() {

        //AUIGrid 칼럼 설정
        var columnLayout = [
          {dataField : "status", headerText : 'Status', width : "20%" , editable : false},
          {dataField : "failReason", headerText : 'Fail Reason', width : "20%" , editable : false},
          {dataField : "remark", headerText :'Remark', width : "40%" , editable : false},
          {dataField : "creator", headerText : 'Creator', width : "20%" , editable : false}
          ];

        failRemarkGridID = GridCommon.createAUIGrid("grid_failRemark_wrap", columnLayout, "", gridPros);
    }

    function fn_selectFailRemarkList() {
        Common.ajax("GET", "/sales/membership/selectFailRemark.do", {psmId : '${eSvmInfo.psmId}'}, function(result) {
            AUIGrid.setGridData(failRemarkGridID, result);
        });
    }

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
            noDataMessage       : '<spring:message code="sales.msg.noOrdNo" />',
            groupingMessage     : "Here groupping"
        };
</script>
<article class="tap_area"><!-- tap_area start -->

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="grid_failRemark_wrap" style="width:100%; height:380px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</article><!-- tap_area end -->