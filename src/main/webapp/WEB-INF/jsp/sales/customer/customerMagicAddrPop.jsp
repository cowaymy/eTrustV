<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javascript">
	//AUIGrid 생성 후 반환 ID
	var mAddrGridID;
	
	$(document).ready(function(){
	    
	    // AUIGrid 그리드를 생성합니다.
	    createAUIGrid();
	    
	    // AUIGrid.setSelectionMode(myGridID, "singleRow");
	    
	    // 셀 더블클릭 이벤트 바인딩
	    //AUIGrid.bind(myGridID, "cellDoubleClick", function(event){
	    //    $("#_custId").val(event.item.custId);
	    //    Common.popupDiv("/sales/order/orderInvestInfoPop.do", $("#popForm").serializeJSON());
	    //});
	    // 셀 클릭 이벤트 바인딩
	
	    fn_searchMagicAddressPopJsonListAjax();
	});
	
	function createAUIGrid() {
        var columnLayout = [ {
            dataField : "state",
            visible : false
        }, {
            dataField : "city",
            visible : false
        }, {
            dataField : "town",
            visible : false
        }, {
            dataField : "postCd",
            visible : false
        }, {
            dataField : "street",
            visible : false
        }, {
            dataField : "fulladdress",
            headerText : "Search Address"
        }];
   
        // 그리드 속성 설정
        var gridPros = {
            
            // 페이징 사용       
            usePaging : false,
            
            // 한 화면에 출력되는 행 개수 20(기본값:20)
            pageRowCount : 20,
            
            editable : true,
            
            fixedColumnCount : 1,
            
            showStateColumn : true, 
            
            displayTreeOpen : true,
            
            selectionMode : "multipleCells",
            
            headerHeight : 30,
            
            // 그룹핑 패널 사용
            useGroupingPanel : true,
            
            // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
            skipReadonlyColumns : true,
            
            // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
            wrapSelectionMove : true,
            
            // 줄번호 칼럼 렌더러 출력
            showRowNumColumn : true,
            
            groupingMessage : "Here groupping"
        };
    
    //myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout, gridPros);
    mAddrGridID = GridCommon.createAUIGrid("#maddr_grid_wrap", columnLayout,'', gridPros);
    }
	
	function fn_searchMagicAddressPopJsonListAjax(){
        Common.ajax("GET", "/sales/customer/searchMagicAddressPopJsonList", $("#searchAddrForm").serialize(), function(result) {
            AUIGrid.setGridData(mAddrGridID, result);
        }
        );
    }
</script>
<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Search Magic Address</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<aside class="title_line"><!-- title_line start -->
<h2>Search Magic Address</h2>
</aside><!-- title_line end -->

<form action="" id="searchAddrForm" name="searchAddrForm" method="POST">
    <input type="hidden" id="searchStreet" name="searchStreet" value="${searchStreet }">
</form>

    <article class="grid_wrap"><!-- grid_wrap start -->
        <div id="maddr_grid_wrap" style="width:100%; height:480px; margin:0 auto;"></div> 
    </article><!-- grid_wrap end -->

<aside class="title_line"><!-- title_line start -->
<h2>Installation Information </h2>
</aside><!-- title_line end -->

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->