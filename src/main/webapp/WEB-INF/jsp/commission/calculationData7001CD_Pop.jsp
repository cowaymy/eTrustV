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
	$(function() {
		//doGetCombo('/common/selectCodeList.do', '11', '','cmbCategory', 'S' , 'f_multiCombo'); //Single COMBO => Choose One
		//doGetCombo('/common/selectCodeList.do', '11', '','cmbCategory', 'A' , 'f_multiCombo'); //Single COMBO => ALL
		//doGetCombo('/common/selectCodeList.do', '11', '','cmbCategory', 'M' , 'f_multiCombo'); //Multi COMBO
		// f_multiCombo 함수 호출이 되어야만 multi combo 화면이 안깨짐.
		// doGetCombo('/common/selectCodeList.do', '11', '','cmbCategory', 'S' , 'fn_multiCombo'); 
	});
	
	
	var myGridID_7001CD;
	$(document).ready(function() {
		createAUIGrid();
		// cellClick event.
		AUIGrid.bind(myGridID_7001CD, "cellClick", function(event) {
			  console.log("rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex + " clicked");          
		});
		 
		//Rule Book Item search
		$("#search_7001CD").click(function(){  
			Common.ajax("GET", "/commission/calculation/selectData7001CD", $("#form7001CD").serialize(), function(result) {
				console.log("성공.");
				console.log("data : " + result);
				AUIGrid.setGridData(myGridID_7001CD, result);
			});
		});
		
	});
	
   function createAUIGrid() {
	var columnLayout_7001CD = [ {
        dataField : "runId",
        headerText : "RUN ID",
        style : "my-column",
        editable : false
    },{
        dataField : "emplyId",
        headerText : " MEMBER ID",
        style : "my-column",
        editable : false
    },{
        dataField : "v1",
        headerText : "V1",
        style : "my-column",
        editable : false
    },{
        dataField : "v2",
        headerText : "V2",
        style : "my-column",
        editable : false
    },{
        dataField : "v3",
        headerText : "V3",
        style : "my-column",
        editable : false
    },{
        dataField : "v4",
        headerText : "V4",
        style : "my-column",
        editable : false
    },{
        dataField : "v5",
        headerText : "V5",
        style : "my-column",
        editable : false
    },{
        dataField : "v6",
        headerText : "V6",
        style : "my-column",
        editable : false
    },{
        dataField : "v7",
        headerText : "V7",
        style : "my-column",
        editable : false
    },{
        dataField : "v8",
        headerText : "V8",
        style : "my-column",
        editable : false
    },{
        dataField : "v9",
        headerText : "V9",
        style : "my-column",
        editable : false
    },{
        dataField : "v10",
        headerText : "V10",
        style : "my-column",
        editable : false
    },{
        dataField : "v11",
        headerText : "V11",
        style : "my-column",
        editable : false
    },{
        dataField : "v12",
        headerText : "V12",
        style : "my-column",
        editable : false
    },{
        dataField : "v13",
        headerText : "V13",
        style : "my-column",
        editable : false
    },{
        dataField : "v14",
        headerText : "v14",
        style : "my-column",
        editable : false
    },{
        dataField : "v15",
        headerText : "v15",
        style : "my-column",
        editable : false
    },{
        dataField : "v16",
        headerText : "v16",
        style : "my-column",
        editable : false
    },{
        dataField : "v17",
        headerText : "v17",
        style : "my-column",
        editable : false
    },{
        dataField : "v18",
        headerText : "v18",
        style : "my-column",
        editable : false
    },{
        dataField : "v19",
        headerText : "v19",
        style : "my-column",
        editable : false
    },{
        dataField : "v20",
        headerText : "v20",
        style : "my-column",
        editable : false
    },{
        dataField : "v21",
        headerText : "v21",
        style : "my-column",
        editable : false
    },{
        dataField : "v22",
        headerText : "v22",
        style : "my-column",
        editable : false
    },{
        dataField : "v23",
        headerText : "v23",
        style : "my-column",
        editable : false
    },{
        dataField : "v24",
        headerText : "v24",
        style : "my-column",
        editable : false
    },{
        dataField : "v25",
        headerText : "v25",
        style : "my-column",
        editable : false
    },{
        dataField : "v26",
        headerText : "v26",
        style : "my-column",
        editable : false
    },{
        dataField : "v27",
        headerText : "v27",
        style : "my-column",
        editable : false
    },{
        dataField : "v29",
        headerText : "v29",
        style : "my-column",
        editable : false
    },{
        dataField : "v30",
        headerText : "v30",
        style : "my-column",
        editable : false
    },{
        dataField : "v31",
        headerText : "v31",
        style : "my-column",
        editable : false
    },{
        dataField : "v32",
        headerText : "v32",
        style : "my-column",
        editable : false
    },{
        dataField : "v33",
        headerText : "v33",
        style : "my-column",
        editable : false
    }];
	// 그리드 속성 설정
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
        showRowNumColumn : true
    };
	myGridID_7001CD = AUIGrid.create("#grid_wrap_7001CD", columnLayout_7001CD,gridPros);
   }
   
   function fn_downFile() {
	   Common.ajax("GET", "/commission/calculation/cntData7001CD", $("#form7001CD").serialize(), function(result) {
           var cnt = result;
           if(cnt > 0){
			   //excel down load name 형식 어떻게 할지?
		       var fileName = $("#fileName").val();
		       var searchDt = $("#7001CD_Dt").val();
		       var year = searchDt.substr(searchDt.indexOf("/")+1,searchDt.length);
		       var month = searchDt.substr(0,searchDt.indexOf("/"));
		       var code = $("#code").val();
		       var memberId = $("#memberId").val();
		       //window.open("<c:url value='/sample/down/excel-xls.do?aaa=" + fileName + "'/>");
		       //window.open("<c:url value='/sample/down/excel-xlsx.do?aaa=" + fileName + "'/>");
		       window.open("<c:url value='/commission/down/excel-xlsx-streaming.do?fileName=" + fileName + "&year="+year+"&month="+month+"&code="+code+"&memberId="+memberId+"'/>");
		   }else{
               Common.alert("<spring:message code='sys.info.grid.noDataMessage'/>"); 
           }
	   });
   }
</script>

<div id="popup_wrap2" class="popup_wrap"><!-- popup_wrap start -->

	<header class="pop_header"><!-- pop_header start -->
		<h1>Basic Data</h1>
		<ul class="right_opt">
		    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
		</ul>
	</header><!-- pop_header end -->
	
	<section class="pop_body"><!-- pop_body start -->
	   <aside class="title_line"><!-- title_line start -->
          <h2>Commission calculation CD Data Collection</h2>
        </aside><!-- title_line end -->
		<form id="form7001CD">
		   <input type="hidden" name="codeId" id="codeId" value="${codeId}"/>
		   <input type="hidden" name="code" id="code" value="${code}"/>
		   <input type="hidden" id="fileName" name="fileName" value="7001CD"/>
		   <ul class="right_btns">
			  <li><p class="btn_blue"><a href="#" id="search_7001CD"><span class="search"></span><spring:message code='sys.btn.search'/></a></p></li>
			</ul>
	
			<table class="type1 mt10"><!-- table start -->
				<caption>table</caption>
				<colgroup>
					<col style="width:130px" />
					<col style="width:200px" />
					<col style="width:130px" />
					<col style="width:*" />
				</colgroup>
				<tbody>
					<tr>
						<th scope="row">Month/Year</th>
						<td>
						<input type="text" title="Create start Date" placeholder="DD/MM/YYYY" name="searchDt" id="7001CD_Dt" class="j_date2" value="${searchDt_pop }" />
						</td>
						<th scope="row">Member Id</th>
						<td>
						      <input type="text" id="memberId" name="memberId" style="width: 100px;">
						</td>
					</tr>
				</tbody>
			</table><!-- table end -->
		</form>
	
		<article class="grid_wrap3"><!-- grid_wrap start -->
			<!-- search_result start -->
			<ul class="right_btns">
				<li><p class="btn_grid">
				    <a href="javascript:fn_downFile()" id="addRow"><span class="search"></span><spring:message code='sys.btn.excel.dw' /></a>
				</p></li>
			</ul>
			<!-- grid_wrap start -->
			<div id="grid_wrap_7001CD" style="width: 100%; height: 334px; margin: 0 auto;"></div>
		</article><!-- grid_wrap end -->
	</section>
	
</div>
