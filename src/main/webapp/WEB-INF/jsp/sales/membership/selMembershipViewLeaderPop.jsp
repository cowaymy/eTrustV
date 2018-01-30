<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">

	var gridPopID;
	
	$(document).ready(function(){
	    
		createAUIGrid();
	    fn_getMembershipviewLeaderAjax(); 
	   // AUIGrid.resize(gridID, 900, 300);  
	    
	});

	
	
	 function createAUIGrid(){
		 
	        var columnLayout = [ 
					             {dataField : "c3",            headerText : "<spring:message code="sal.title.date" />",    width :100, editable : false},
					             {dataField : "codeDesc",  headerText : "<spring:message code="sal.title.type" />",    width : 300},
					             {dataField : "c6",            headerText : "<spring:message code="sal.title.docNo" />",  width : 100},
					             {dataField : "c4",            headerText : "<spring:message code="sal.title.debit" />",    width : 100},
					             {dataField : "c5",            headerText : "Credi",   width :100},
					             {dataField : "c7",            headerText : "<spring:message code="sal.title.balance" />", width : 100}
	       ];
	        
	        //그리드 속성 설정
	        var gridPros = {
	                usePaging           : true,         //페이징 사용
	                pageRowCount        : 20,           //한 화면에 출력되는 행 개수 20(기본값:20)            
	                editable            : false,            
	                fixedColumnCount    : 1,            
	                showStateColumn     : true,             
	                displayTreeOpen     : false,            
	              //  selectionMode       : "singleRow",  //"multipleCells",            
	                headerHeight        : 30,       
	                useGroupingPanel    : false,        //그룹핑 패널 사용
	                skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
	                wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
	                showRowNumColumn    : true         //줄번호 칼럼 렌더러 출력    
	            };
	    
	        gridPopID = GridCommon.createAUIGrid("m_popgrid_wrap",columnLayout,'', gridPros);  
	    }
	    
	    
	function fn_getMembershipviewLeaderAjax(){
		 Common.ajax("GET", "/sales/membership/selectMembershipViewLeader",$("#getParamForm").serialize(), function(result) {
			 
			   console.log(result)
	            AUIGrid.setGridData(gridPopID, result);  
	     });
	}

	   
</script>

<!-- get param Form  -->
<form id="getParamForm" method="get">
    <input type="hidden" name="MBRSH_ID"  id="MBRSH_ID" value="${MBRSH_ID}"/>
</form>


<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="sel.page.title.membershipLedger" /></h1>
<ul class="right_opt">
	<li><p class="btn_blue2"><a href="#"><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<article class="grid_wrap"><!-- grid_wrap start -->
   <div id="m_popgrid_wrap" style="width:100%; height:480px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->