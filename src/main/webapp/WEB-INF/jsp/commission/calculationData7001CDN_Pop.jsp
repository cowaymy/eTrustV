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
	var myGridID_7001CDN;
	var today = "${today}";
	
	$(document).ready(function() {
		createAUIGrid();
		// cellClick event.
		AUIGrid.bind(myGridID_7001CDN, "cellClick", function(event) {
			  console.log("rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex + " clicked");          
		});
		 
		//Rule Book Item search
		$("#search_7001CD").click(function(){  
			Common.ajax("GET", "/commission/calculation/selectData7001CD", $("#form7001CD").serialize(), function(result) {
				console.log("성공.");
				console.log("data : " + result);
				AUIGrid.setGridData(myGridID_7001CDN, result);
			});
		});
		
		$('#memBtn').click(function() {
            //Common.searchpopupWin("searchForm", "/common/memberPop.do","");
            Common.popupDiv("/common/memberPop.do", $("#form7001CD").serializeJSON(), null, true);
        });
	});
	
	function fn_loadOrderSalesman(memId, memCode) {
        $("#memberCd_7001CD").val(memCode);
        console.log(' memId:'+memId);
        console.log(' memCd:'+memCode);
    }
	
   function createAUIGrid() {
	var columnLayout_7001CD = [ {
        dataField : "runId",
        headerText : "RUN ID",
        style : "my-column",
        editable : false,
        visible : false
    },{
        dataField : "emplyId",
        headerText : " MEMBER ID",
        style : "my-column",
        editable : false
    },{
        dataField : "emplyCode",
        headerText : " MEMBER CODE",
        style : "my-column",
        editable : false
    },{
        dataField : "v1",
        headerText : "Credit Point",
        style : "my-column",
        editable : false
    },{
        dataField : "v2",
        headerText : "HappyCall<br>Performance",
        style : "my-column",
        editable : false
    },{
        dataField : "v3",
        headerText : "HappyCall Marks",
        style : "my-column",
        editable : false
    },{
        dataField : "v4",
        headerText : "HS Success Rate",
        style : "my-column",
        editable : false
    },{
        dataField : "v5",
        headerText : "HS Marks",
        style : "my-column",
        editable : false
    },{
        dataField : "v6",
        headerText : "Rental Collection Rate",
        style : "my-column",
        editable : false
    },{
        dataField : "v7",
        headerText : "Rental Collection Marks",
        style : "my-column",
        editable : false
    },{
        dataField : "v8",
        headerText : "Net Sales Unit",
        style : "my-column",
        editable : false
    },{
        dataField : "v9",
        headerText : "Net Sales Marks",
        style : "my-column",
        editable : false
    },{
        dataField : "v10",
        headerText : "Rental Collection Amount",
        style : "my-column",
        editable : false
    },{
        dataField : "v12",
        headerText : "Dropped Rate",
        style : "my-column",
        editable : false
    },{
        dataField : "v13",
        headerText : "Dropped Rate <br>Penalty Marks",
        style : "my-column",
        editable : false
    },{
        dataField : "v14",
        headerText : "Net Sales <br>Pv Total",
        style : "my-column",
        editable : false
    },{
        dataField : "v15",
        headerText : "App Rate <br>By Total Pv",
        style : "my-column",
        editable : false
    },{
        dataField : "v16",
        headerText : "sales price total",
        style : "my-column",
        editable : false
    },{
        dataField : "v17",
        headerText : "Mem amount",
        style : "my-column",
        editable : false
    },{
        dataField : "v18",
        headerText : "completed BS count",
        style : "my-column",
        editable : false
    },{
        dataField : "v19",
        headerText : "pv total",
        style : "my-column",
        editable : false
    },{
        dataField : "v20",
        headerText : "price total",
        style : "my-column",
        editable : false
    },{
        dataField : "v21",
        headerText : "collection Cmm <br>App rate",
        style : "my-column",
        editable : false
    },{
        dataField : "v24",
        headerText : "SHI rental Cmm rate",
        style : "my-column",
        editable : false
    },{
        dataField : "v25",
        headerText : "SHI Index",
        style : "my-column",
        editable : false
    },{
        dataField : "v26",
        headerText : "SHI rental Mem<br> collection rate",
        style : "my-column",
        editable : false
    },{
        dataField : "v27",
        headerText : "SHI rental Mem Index",
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
        showRowNumColumn : true,
        
        headerHeight : 40,
        selectionMode : "singleRow"
    };
	myGridID_7001CDN = AUIGrid.create("#grid_wrap_7001CDN", columnLayout_7001CD,gridPros);
   }
   
   function fn_downFile() {
	   Common.ajax("GET", "/commission/calculation/cntData7001CD", $("#form7001CD").serialize(), function(result) {
           var cnt = result;
           if(cnt > 0){
			   //excel down load name 형식 어떻게 할지?
		       var fileName = $("#fileName").val() +"_"+today;
                fileName=fileName+".xlsx";
		       var searchDt = $("#7001CD_Dt").val();
		       var year = searchDt.substr(searchDt.indexOf("/")+1,searchDt.length);
		       var month = searchDt.substr(0,searchDt.indexOf("/"));
		       var code = $("#code").val();
		       
		       var memberCd = $("#memberCd_7001CD").val();
		       
		       var actionType = $("#actionType_7001").val();
		       //window.open("<c:url value='/sample/down/excel-xls.do?aaa=" + fileName + "'/>");
		       //window.open("<c:url value='/sample/down/excel-xlsx.do?aaa=" + fileName + "'/>");
		       //window.location.href="<c:url value='/commExcelFile.do?fileName=" + fileName + "&year="+year+"&month="+month+"&code="+code+"&memberCd="+memberCd+"'/>";
		       
		      Common.showLoader();
              $.fileDownload("/commExcelFile.do?fileName=" + fileName + "&year="+year+"&month="+month+"&code="+code+"&memberCd="+memberCd+"&actionType="+actionType)
              .done(function () {
                  //Common.alert('File download a success!');
                  Common.alert("<spring:message code='commission.alert.report.download.success'/>");
                  Common.removeLoader();            
              })
              .fail(function () {
                  //Common.alert('File download failed!');
                  Common.alert("<spring:message code='commission.alert.report.download.fail'/>");
                  Common.removeLoader();            
               });
		   }else{
               Common.alert("<spring:message code='sys.info.grid.noDataMessage'/>"); 
           }
	   });
   }
   
   function fn_AlldownFile() {
	   var data = { "searchDt" : $("#7001CD_Dt").val() , "code": $("#code").val() ,"actionType":$("#actionType_7001").val()};
	   Common.ajax("GET", "/commission/calculation/cntData7001CD", data, function(result) {
           var cnt = result;
           if(cnt > 0){
        	   var fileName = $("#fileName").val() +"_"+today;
               fileName=fileName+".xlsx";
		      var searchDt = $("#7001CD_Dt").val();
		      var year = searchDt.substr(searchDt.indexOf("/")+1,searchDt.length);
		      var month = searchDt.substr(0,searchDt.indexOf("/"));
		      var code = $("#code").val();
		      
		      var actionType = $("#actionType_7001").val();
		      //window.location.href="<c:url value='/commExcelFile.do?fileName=" + fileName + "&year="+year+"&month="+month+"&code="+code+"'/>";
		      
		      Common.showLoader();
              $.fileDownload("/commExcelFile.do?fileName=" + fileName + "&year="+year+"&month="+month+"&code="+code+"&actionType="+actionType)
              .done(function () {
                  //Common.alert('File download a success!');
                  Common.alert("<spring:message code='commission.alert.report.download.success'/>");
                  Common.removeLoader();            
              })
              .fail(function () {
                  //Common.alert('File download failed!');
                  Common.alert("<spring:message code='commission.alert.report.download.fail'/>");
                  Common.removeLoader();            
               });
           }else{
               Common.alert("<spring:message code='sys.info.grid.noDataMessage'/>"); 
           }
       });
   }
</script>

<div id="popup_wrap2" class="popup_wrap"><!-- popup_wrap start -->

	<header class="pop_header"><!-- pop_header start -->
		<h1>${prdDec }</h1>
		<ul class="right_opt">
		    <li><p class="btn_blue2"><a href="#"><spring:message code='sys.btn.close'/></a></p></li>
		</ul>
	</header><!-- pop_header end -->
	
	<section class="pop_body" style="max-height:600px;"><!-- pop_body start -->
	   <aside class="title_line"><!-- title_line start -->
          <h2>${prdNm } - ${prdDec }</h2>
        </aside><!-- title_line end -->
		<form id="form7001CD">
           <input type="hidden" name="actionType" id="actionType_7001" value="${actionType }"/>
		   <input type="hidden" name="codeId" id="codeId" value="${codeId}"/>
		   <input type="hidden" name="code" id="code" value="${code}"/>
		   <input type="hidden" id="fileName" name="fileName" value="cody_normal_basic.xlsx"/>
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
						<th scope="row"><spring:message code='commission.text.search.monthYear'/></th>
						<td>
						<input type="text" title="Create start Date" placeholder="DD/MM/YYYY" name="searchDt" id="7001CD_Dt" class="j_date2" value="${searchDt_pop }" />
						</td>
						<th scope="row"><spring:message code='commission.text.search.memCode'/></th>
						<td>
						      <input type="text" id="memberCd_7001CD" name="memberCd" style="width: 100px;">
						      <a id="memBtn" href="#" class="search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
						</td>
					</tr>
				</tbody>
			</table><!-- table end -->
		</form>
	
		<article class="grid_wrap3"><!-- grid_wrap start -->
			<!-- search_result start -->
			<ul class="right_btns">
			    <li><p class="btn_grid">
                    <a href="javascript:fn_AlldownFile()" id="addRow"><spring:message code='commission.button.allExcel'/></a>
                </p></li>
				<li><p class="btn_grid">
				    <a href="javascript:fn_downFile()" id="addRow"><spring:message code='sys.btn.excel.dw' /></a>
				</p></li>
			</ul>
			<!-- grid_wrap start -->
			<div id="grid_wrap_7001CDN" style="width: 100%; height: 334px; margin: 0 auto;"></div>
		</article><!-- grid_wrap end -->
	</section>
	
</div>
