<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<style type="text/css">

/* 커스텀 칼럼 스타일 정의 */
.my-column {
	text-align: left;
	margin-top: -20px;
}
</style>

<script type="text/javaScript">
	var myGridID2;
	
	$(document).ready(function() {
		createAUIGrid();
		// cellClick event.
        AUIGrid.bind(myGridID2, "cellClick", function(event) {
            console.log("rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex + " clicked");          
        });
		
        Common.ajax("GET", "/commission/calculation/selectCommLog", $("#searchForm").serialize(), function(result) {
        	AUIGrid.setGridData(myGridID2, result);
        });
       
	});
	
   function createAUIGrid() {
	var columnLayout2 = [ {
        dataField : "code",
        headerText : "<spring:message code='commission.text.grid.excuteGroup'/>",
        style : "my-column",
        editable : false,
        width: 60
    },{
        dataField : "calYearMonth",
        headerText : "<spring:message code='commission.text.grid.excuteDate'/>",
        style : "my-column",
        editable : false,
        width: 60
    },{
        dataField : "codeName",
        headerText : "<spring:message code='commission.text.grid.procedureName'/>",
        style : "my-column",
        editable : false,
        width: 140
    },{
        dataField : "codeDesc",
        headerText : "<spring:message code='commission.text.desc'/>",
        style : "my-column",
        editable : false,
        width: 250
    },{
        dataField : "calStartTime",
        headerText : "<spring:message code='commission.text.grid.startDate'/>",
        style : "my-column",
        editable : false,
        width : 160
    },{
        dataField : "calEndTime",
        headerText : "<spring:message code='commission.text.grid.endDate'/>",
        style : "my-column",
        editable : false,
        width : 160
    },{
        dataField : "calState",
        style : "my-column",
        editable : false,
        visible : false
    },{
        dataField : "statenm",
        headerText : "<spring:message code='commission.text.grid.result'/>",
        style : "my-column",
        editable : false,
        width: 70
    },{
        dataField : "calErrorCode",
        headerText : "<spring:message code='commission.text.grid.errorCd'/>",
        style : "my-column",
        editable : false,
        width: 55
    },{
        dataField : "calErrorContents",
        headerText : "<spring:message code='commission.text.grid.errorContens'/>",
        style : "my-column",
        editable : false,
        width: 250
    },{
        dataField : "crtUserId",
        headerText : "<spring:message code='commission.text.grid.userId'/>",
        style : "my-column",
        editable : false
    }];
	
	var gridPros = {
	        
	        // 페이징 사용       
	        usePaging : true,
	        
	        // 한 화면에 출력되는 행 개수 20(기본값:20)
	        pageRowCount : 20,
	        
	        // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
	        skipReadonlyColumns : true,
	        
	        // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
	        wrapSelectionMove : true,
	        
	        // 줄번호 칼럼 렌더러 출력
	        showRowNumColumn : true,
	        
	        headerHeight : 40
	    };
	myGridID2 = AUIGrid.create("#grid_wrap2", columnLayout2,gridPros);
   }
</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

	<header class="pop_header"><!-- pop_header start -->
		<h1><spring:message code='commission.title.pop.head.log'/></h1>
		<ul class="right_opt">
		    <li><p class="btn_blue2"><a href="#"><spring:message code='sys.btn.close'/></a></p></li>
		</ul>
	</header><!-- pop_header end -->
	
	<form id="searchForm">
	   <input type=hidden name="codeId" id="codeId" value="${codeId}"/>
	   <input type=hidden name="calName" id="calName" value="${calName}"/>
	</form>
	
	<section class="pop_body"><!-- pop_body start -->
		<aside class="title_line"><!-- title_line start -->
		  <h2><spring:message code='commission.title.pop.body.log'/></h2>
		</aside><!-- title_line end -->
		<article class="grid_wrap2"><!-- grid_wrap start -->
			<!-- grid_wrap start -->
			<div id="grid_wrap2" style="width: 100%; height: 334px; margin: 0 auto;"></div>
		</article><!-- grid_wrap end -->
	</section>
	
</div>
