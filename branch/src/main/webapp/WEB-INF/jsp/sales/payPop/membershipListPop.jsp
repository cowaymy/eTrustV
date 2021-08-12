<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>


<script type="text/javaScript" language="javascript">
	
	//AUIGrid 생성 후 반환 ID
	var  gridID;
	var  membershipList;
	
	$(document).ready(function(){
        
        if('${membershipList}'=='' || '${membershipList}' == null){
        }else{
        	membershipList = JSON.parse('${membershipList}');      
            console.log(membershipList);
        }   
		
        //AUIGrid 그리드를 생성합니다.
        createAUIGrid();

    });


	
	function createAUIGrid() {
	        
	        //AUIGrid 칼럼 설정
	        var columnLayout = [
               {     dataField  : "mbrshNo",     headerText  : "Membership<br/>No",   width          : 100,   editable       : false}, 
               {     dataField  : "mbrshOtstnd",   headerText  : "Outstanding",  width          : 95,    editable       : false}, 
               {     dataField  : "ordNo",   headerText  : "Order No",     width          : 75,  editable       : false}, 
               {     dataField  : "custName",     headerText  : "Customer Name",      width          : 150,    editable       : false}, 
               {     dataField  : "mbrshStusCode",    headerText   : "Status",    width           : 55,    editable        : false}, 
               {     dataField  : "mbrshStartDt", headerText  : "Start Date",  width       : 90,  editable    : false, dataType : "date", formatString : "dd/mm/yyyy"}, 
               {     dataField   : "mbrshExprDt",  headerText  : "Expire Date",   width       : 90,    editable    : false, dataType : "date", formatString : "dd/mm/yyyy"}, 
               {     dataField   : "pacName",  headerText  : "Package",  width       : 150, editable    : false}, 
               {     dataField   : "mbrshDur", headerText  : "Duration<br/>(Mth)", width       : 75,   editable    : false}, 
               {     dataField   : "mbrshCrtDt",  headerText  : "Create Date",  width       : 90,  editable    : false,dataType : "date", formatString : "dd/mm/yyyy"}, 
               {     dataField   : "mbrshCrtUserId",  headerText  : "Creator", width       : 100, editable    : false},
               {     dataField : "mbrshId", visible : false },
               {     dataField : "ordId",visible : false}	                            
	       ];

	        //그리드 속성 설정
	        var gridPros = {
	            usePaging           : true,             //페이징 사용
	            pageRowCount        : 20,           //한 화면에 출력되는 행 개수 20(기본값:20)            
	            editable                : false,            
	            fixedColumnCount    : 1,            
	            showStateColumn     : true,             
	            displayTreeOpen     : false,            
	            //selectionMode       : "singleRow",  //"multipleCells",            
	            headerHeight        : 30,       
	            useGroupingPanel    : false,        //그룹핑 패널 사용
	            skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
	            wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
	            showRowNumColumn    : true,         //줄번호 칼럼 렌더러 출력    
	            noDataMessage       : "No order found.",
	            groupingMessage     : "Here groupping"
	        };
	        
	        gridID = GridCommon.createAUIGrid("list_grid_wrap", columnLayout, "", gridPros);
	        
	        if(membershipList != '' ){
	               AUIGrid.setGridData(gridID, membershipList);
	           } 
	    }
	

</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->
<header class="pop_header"><!-- pop_header start -->
<h1>Order Outrigth Membership Listing </h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#"  id="pcl_close">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body win_popup"  ><!-- pop_body start -->

<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="list_grid_wrap" style="width:100%; height:360px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->



