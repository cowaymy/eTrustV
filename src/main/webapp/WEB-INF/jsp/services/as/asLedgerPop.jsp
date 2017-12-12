<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">
var myGridID_ledger;
$(document).ready(function(){
     $('.multy_select').on("change", function() {
           //console.log($(this).val());
       }).multipleSelect({}); 
    
    fn_ledgerGrid();
    fn_ledgerSearch();
    
});

function fn_ledgerSearch(){
	Common.ajax("GET", "/services/as/report/getViewLedger.do", {ASRNO : "${ASRNo}" }, function(result) {
        console.log("성공.");
        console.log( result);
        AUIGrid.setGridData(myGridID_ledger, result);
    });
}
function fn_ledgerGrid() {
    //AUIGrid 칼럼 설정
    var columnLayout = [ {
        dataField : "asDocNo",
        headerText : "No",
        editable : false,
        width : 130
    }, {
        dataField : "codeName",
        headerText : "Type",
        editable : false,
        width : 130
    }, {
        dataField : "c1",
        headerText : "Date",
        editable : false,
        width : 130
    }, {
        dataField : "c2",
        headerText : "Debit Amount",
        editable : false,
        width : 130
    }, {
        dataField : "c3",
        headerText : "Credit Amount",
        editable : false,
        style : "my-column",
        width : 130
    }, {
        dataField : "c4",
        headerText : "Advance Payment",
        editable : false,
        width : 130,
        renderer : {
            type : "CheckBoxEditRenderer",
            showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
            editable : false, // 체크박스 편집 활성화 여부(기본값 : false)
            checkValue : "1", // true, false 인 경우가 기본
            unCheckValue : "0"
        }
    }];
     // 그리드 속성 설정
    var gridPros = {
        
             usePaging           : true,         //페이징 사용
             pageRowCount        : 20,           //한 화면에 출력되는 행 개수 20(기본값:20)            
             editable            : false,            
             displayTreeOpen     : false,            
             selectionMode       : "singleRow",  //"multipleCells",            
             headerHeight        : 30,       
             useGroupingPanel    : false,        //그룹핑 패널 사용
             skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
             wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
             showRowNumColumn    : true,         //줄번호 칼럼 렌더러 출력    

    };
    
    //myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout, gridPros);
    myGridID_ledger = AUIGrid.create("#grid_wrap_ledger", columnLayout, gridPros);
}

var gridPros = {
    
    // 페이징 사용       
    usePaging : true,
    
    // 한 화면에 출력되는 행 개수 20(기본값:20)
    pageRowCount : 20,
    
    editable : true,
    
    fixedColumnCount : 1,
    
    showStateColumn : true, 
    
    displayTreeOpen : true,
    
    selectionMode : "singleRow",
    
    headerHeight : 30,
    
    // 그룹핑 패널 사용
    useGroupingPanel : true,
    
    // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
    skipReadonlyColumns : true,
    
    // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
    wrapSelectionMove : true,
    
    // 줄번호 칼럼 렌더러 출력
    showRowNumColumn : false
    
};

</script>
<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>AS LEDGER</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->
<article class="grid_wrap"><!-- grid_wrap start -->
<div id="grid_wrap_ledger" style="width: 100%; height: 300px; margin: 0 auto;"></div>
</article><!-- grid_wrap end -->


</section><!-- pop_body end -->

</div><!-- popup_wrap end -->
