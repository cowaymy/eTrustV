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
	    AUIGrid.bind(mAddrGridID, "cellDoubleClick", function(event){
	    	/* var mstate = event.item.state;
	    	var mcity = event.item.city;
	    	var mtown = event.item.town;
	    	var mpostCd = event.item.postcd;
	    	var mstreet = event.item.street;
	    	var miso = event.item.iso;
	    	var mstreetId = event.item.streetId; */
	    	
	    	var marea = event.item.area;
	    	var mcity = event.item.city;
	    	var mpostcode = event.item.postcode;
	    	var mstate = event.item.state;
	    	var areaid = event.item.areaId;
	    	var miso = event.item.iso;

	    	fn_addMaddr(marea, mcity, mpostcode, mstate, areaid, miso);

	    });
	    // 셀 클릭 이벤트 바인딩
	
	    fn_searchMagicAddressPopJsonListAjax();
	});
	
	function createAUIGrid() {
        var columnLayout = [ {
            dataField : "area",
            headerText : "AREA",
            editable : false
        }, {
            dataField : "postcode",
            headerText : "POSTCODE",
            width : 90,
            editable : false
        }, {
            dataField : "city",
            headerText : "CITY",
            width : 160,
            editable : false
        }, {
            dataField : "state",
            headerText : "STATE",
            width : 180,
            editable : false
        },{
            dataField : "areaId",
            visible : false
        }, {
            dataField : "iso",
            visible : false
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
            
      //      selectionMode : "multipleCells",
            
            headerHeight : 30,
            
            // 그룹핑 패널 사용
            useGroupingPanel : true,
            
            // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
            skipReadonlyColumns : true,
            
            // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
            wrapSelectionMove : true,
            
            // 줄번호 칼럼 렌더러 출력
            showRowNumColumn : false,
            
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
<h1>Search Address</h1>
<ul class="right_opt">
    <li id="mClose"><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<aside class="title_line"><!-- title_line start -->
<h2>Search Address</h2>
</aside><!-- title_line end -->

<form action="" id="searchAddrForm" name="searchAddrForm" method="POST">
    <input type="hidden" id="searchStreet" name="searchStreet" value="${searchStreet }">
</form>
<form id="mAddrForm" method="post">
    <input type="hidden" name="custId"  id="_custId"/>  <!-- Cust Id  -->
    <input type="hidden" name="custAddId"   id="_custAddId"/><!-- Address Id  -->
    <input type="hidden" name="custCntcId"   id="_custCntcId"> <!--Contact Id  -->
    <input type="hidden" name="custAccId"   id="_custAccId">
    <input type="hidden" name="selectParam"  id="_selectParam" value="${selectParam}"/> <!-- Page Param  -->
</form>
    <article class="grid_wrap"><!-- grid_wrap start -->
        <div id="maddr_grid_wrap" style="width:100%; height:480px; margin:0 auto;"></div> 
    </article><!-- grid_wrap end -->

<aside class="title_line"><!-- title_line start -->
<h2>Installation Information </h2>
</aside><!-- title_line end -->

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->