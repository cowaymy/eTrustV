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
	var myGridID_7002HPG;
	
	$(document).ready(function() {
		createAUIGrid();
		// cellClick event.
		AUIGrid.bind(myGridID_7002HPG, "cellClick", function(event) {
			  console.log("rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex + " clicked");          
		});
		 
		//Rule Book Item search
		$("#search_7002HP").click(function(){  
			Common.ajax("GET", "/commission/calculation/selectData7002HP", $("#form7002HP").serialize(), function(result) {
				console.log("성공.");
				console.log("data : " + result);
				AUIGrid.setGridData(myGridID_7002HPG, result);
			});
		});
		
		$('#memBtn').click(function() {
            //Common.searchpopupWin("searchForm", "/common/memberPop.do","");
            Common.popupDiv("/common/memberPop.do", $("#form7002HP").serializeJSON(), null, true);
        });
	});
	
	function fn_loadOrderSalesman(memId, memCode) {
        $("#memberCd_7002HP").val(memCode);
        console.log(' memId:'+memId);
        console.log(' memCd:'+memCode);
    }
	
   function createAUIGrid() {
	var columnLayout_7002HP = [ {
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
        dataField : "emplyCode",
        headerText : " MEMBER CODE",
        style : "my-column",
        editable : false
    },{
        dataField : "r2",
        headerText : "sales Cmm",
        style : "my-column",
        editable : false
    },{
        dataField : "r3",
        headerText : "Personal Rental Cmm",
        style : "my-column",
        editable : false
    },{
        dataField : "r4",
        headerText : "Bonus",
        style : "my-column",
        editable : false
    },{
        dataField : "r13",
        headerText : "Mem Amt",
        style : "my-column",
        editable : false
    },{
        dataField : "r18",
        headerText : "Sales Cmm<br>overidding",
        style : "my-column",
        editable : false
    },{
        dataField : "r19",
        headerText : "SM Overidding",
        style : "my-column",
        editable : false
    },{
        dataField : "r20",
        headerText : "performance incentives<br>neopro",
        style : "my-column",
        editable : false
    },{
        dataField : "r21",
        headerText : "sales Cmm",
        style : "my-column",
        editable : false
    },{
        dataField : "r22",
        headerText : "HM Overidding",
        style : "my-column",
        editable : false
    },{
        dataField : "r25",
        headerText : "TBB_Amt",
        style : "my-column",
        editable : false
    },{
        dataField : "r28",
        headerText : "Incentive",
        style : "my-column",
        editable : false
    },{
        dataField : "r29",
        headerText : "SHI_Amt",
        style : "my-column",
        editable : false
    },{
        dataField : "r30",
        headerText : "R30",
        style : "my-column",
        editable : false
    },{
        dataField : "r32",
        headerText : "R32",
        style : "my-column",
        editable : false
    },{
        dataField : "r33",
        headerText : "R33",
        style : "my-column",
        editable : false
    },{
        dataField : "r34",
        headerText : "RentalMembership<br>Amt",
        style : "my-column",
        editable : false
    },{
        dataField : "r39",
        headerText : "Personal Outright<br>Plus Cmm",
        style : "my-column",
        editable : false
    },{
        dataField : "r40",
        headerText : "Outright Plus<br>Overidding",
        style : "my-column",
        editable : false
    },{
        dataField : "r41",
        headerText : "SM Overidding",
        style : "my-column",
        editable : false
    },{
        dataField : "r42",
        headerText : "R42",
        style : "my-column",
        editable : false
    },{
        dataField : "r99",
        headerText : "Adjust_Amt",
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
        
        headerHeight : 40

    };
	myGridID_7002HPG = AUIGrid.create("#grid_wrap_7002HPG", columnLayout_7002HP,gridPros);
   }
   
   function fn_downFile() {
	   Common.ajax("GET", "/commission/calculation/cntData7002HP", $("#form7002HP").serialize(), function(result) {
           var cnt = result;
           if(cnt > 0){
			   //excel down load name 형식 어떻게 할지?
		       var fileName = $("#fileName").val();
		       var searchDt = $("#7002HP_Dt").val();
		       var year = searchDt.substr(searchDt.indexOf("/")+1,searchDt.length);
		       var month = searchDt.substr(0,searchDt.indexOf("/"));
		       var code = $("#code").val();
		       var memberCd = $("#memberCd_7002HP").val();
		       //window.open("<c:url value='/sample/down/excel-xls.do?aaa=" + fileName + "'/>");
		       //window.open("<c:url value='/sample/down/excel-xlsx.do?aaa=" + fileName + "'/>");
		       window.location.href="<c:url value='/commExcelFile.do?fileName=" + fileName + "&year="+year+"&month="+month+"&code="+code+"&memberCd="+memberCd+"'/>";
           }else{
               Common.alert("<spring:message code='sys.info.grid.noDataMessage'/>"); 
           }
	   });
   }
   
   function fn_AlldownFile() {
        var fileName = $("#fileName").val();
        var searchDt = $("#7002HP_Dt").val();
        var year = searchDt.substr(searchDt.indexOf("/")+1,searchDt.length);
        var month = searchDt.substr(0,searchDt.indexOf("/"));
        var code = $("#code").val();
        window.location.href="<c:url value='/commExcelFile.do?fileName=" + fileName + "&year="+year+"&month="+month+"&code="+code+"'/>";
   }
</script>

<div id="popup_wrap2" class="popup_wrap"><!-- popup_wrap start -->

	<header class="pop_header"><!-- pop_header start -->
		<h1>${prdDec }</h1>
		<ul class="right_opt">
		    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
		</ul>
	</header><!-- pop_header end -->
	
	<section class="pop_body" style="max-height:600px;"><!-- pop_body start -->
	   <aside class="title_line"><!-- title_line start -->
          <h2>${prdNm } - ${prdDec }</h2>
        </aside><!-- title_line end -->
		<form id="form7002HP">
		   <input type="hidden" name="codeId" id="codeId" value="${codeId}"/>
		   <input type="hidden" name="code" id="code" value="${code}"/>
		   <input type="hidden" id="fileName" name="fileName" value="excelDownName"/>
		   <ul class="right_btns">
			  <li><p class="btn_blue"><a href="#" id="search_7002HP"><span class="search"></span><spring:message code='sys.btn.search'/></a></p></li>
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
						<input type="text" title="Create start Date" placeholder="DD/MM/YYYY" name="searchDt" id="7002HP_Dt" class="j_date2" value="${searchDt_pop }" />
						</td>
						<th scope="row">Member CODE</th>
						<td>
						      <input type="text" id="memberCd_7002HP" name="memberCd" style="width: 100px;">
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
                    <a href="javascript:fn_AlldownFile()" id="addRow"><span class="search"></span>ALL Excel</a>
                </p></li>
				<li><p class="btn_grid">
				    <a href="javascript:fn_downFile()" id="addRow"><span class="search"></span><spring:message code='sys.btn.excel.dw' /></a>
				</p></li>
			</ul>
			<!-- grid_wrap start -->
			<div id="grid_wrap_7002HPG" style="width: 100%; height: 334px; margin: 0 auto;"></div>
		</article><!-- grid_wrap end -->
	</section>
	
</div>
