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
	var myGridID_19T;
	
	$(document).ready(function() {
		createAUIGrid();
		// cellClick event.
		AUIGrid.bind(myGridID_19T, "cellClick", function(event) {
			  console.log("rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex + " clicked");          
		});
		 
		//Rule Book Item search
		$("#search_19T").click(function(){  
			Common.ajax("GET", "/commission/calculation/selectDataCMM019T", $("#form_19T").serialize(), function(result) {
				console.log("성공.");
				console.log("data : " + result);
				AUIGrid.setGridData(myGridID_19T, result);
				AUIGrid.addCheckedRowsByValue(myGridID_19T, "isExclude", "1");
			});
		});
		
		$("#save_19T").click(function(){  
			Common.confirm("<spring:message code='sys.common.alert.save'/>",fn_saveExculde);
			
		});
		
		$('#memBtn').click(function() {
            //Common.searchpopupWin("searchForm", "/common/memberPop.do","");
            Common.popupDiv("/common/memberPop.do", $("#form_19T").serializeJSON(), null, true);
        });
		
	});
	
	function fn_loadOrderSalesman(memId, memCode) {
        $("#bsPersonId_19T").val(memId);
        console.log('fn_loadOrderSalesman memId:'+memId);
        console.log('fn_loadOrderSalesman memCd:'+memCode);
    }
	
	function fn_saveExculde(){
		var checkdata = AUIGrid.getCheckedRowItemsAll(myGridID_19T);
        var check     = AUIGrid.getCheckedRowItems(myGridID_19T);
        var formList = $("#form_19T").serializeJSON();       //폼 데이터
        
        //param data array
        var data = {};
        
        data.check   = check;
        data.checked = check;
        data.form = formList;
        
        Common.ajax("POST", "/commission/calculation/updatePrdData_19T.do", data , function(result) {
            // 공통 메세지 영역에 메세지 표시.
            Common.setMsg("<spring:message code='sys.msg.success'/>");
            $("#search_19T").trigger("click");
        });
	}
   function createAUIGrid() {
	var columnLayout3 = [ {
        dataField : "ordId",
        headerText : "ORD ID",
        style : "my-column",
        editable : false
    },{
        dataField : "bsrId",
        headerText : "BSR ID",
        style : "my-column",
        editable : false
    },{
        dataField : "stockId",
        headerText : "STOCK ID",
        style : "my-column",
        editable : false
    },{
        dataField : "appTypeId",
        headerText : "APP TYPE ID",
        style : "my-column",
        editable : false
    },{
        dataField : "bsPersonId",
        headerText : "BS PERSON ID",
        style : "my-column",
        editable : false
    },{
        dataField : "prc",
        headerText : "PRC",
        style : "my-column",
        editable : false
    },{
        dataField : "runId",
        headerText : "RUN ID",
        style : "my-column",
        visible : false,
        editable : false
    },{
        dataField : "taskId",
        headerText : "TASK ID",
        style : "my-column",
        visible : false,
        editable : false
    },{
        dataField : "isExclude",
        headerText : "IS EXCLUDE",
        style : "my-column",
        visible : false,
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
        
        // 체크박스 표시 설정
        showRowCheckColumn : true,
        
        showRowAllCheckBox : true

    };
	myGridID_19T = AUIGrid.create("#grid_wrap_19", columnLayout3,gridPros);
   }
   
   function fn_downFile() {
	   Common.ajax("GET", "/commission/calculation/cntCMM0019T", $("#form_19T").serialize(), function(result) {
           var cnt = result;
           if(cnt > 0){
			   //excel down load name 형식 어떻게 할지?
		       var fileName = $("#fileName").val();
		       var searchDt = $("#CMM0019T_Dt").val();
		       var year = searchDt.substr(searchDt.indexOf("/")+1,searchDt.length);
		       var month = searchDt.substr(0,searchDt.indexOf("/"));
		       var code = $("#code_19T").val();
		       var ordId = $("#ordId_19T").val();
		       var bsPersonId = $("#bsPersonId_19T").val();
		       var useYnCombo = $("#useYnCombo_19T").val();
		       //window.open("<c:url value='/sample/down/excel-xls.do?aaa=" + fileName + "'/>");
		       //window.open("<c:url value='/sample/down/excel-xlsx.do?aaa=" + fileName + "'/>");
		       window.location.href="<c:url value='/commission/down/excel-xlsx-streaming.do?fileName=" + fileName + "&year="+year+"&month="+month+"&code="+code+"&ordId="+ordId+"&bsPersonId="+bsPersonId+"&useYnCombo="+useYnCombo+"'/>";
	       }else{
	           Common.alert("<spring:message code='sys.info.grid.noDataMessage'/>");
	       }
	   });
   }
   
   function onlyNumber(obj) {
       $(obj).keyup(function(){
            $(this).val($(this).val().replace(/[^0-9]/g,""));
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
	
	<section class="pop_body" style="max-height:600px;"><!-- pop_body start -->
	   <aside class="title_line"><!-- title_line start -->
          <h2>Commission calculation Data Collection
          <br>
          ${prdNm } - ${prdDec }</h2>
        </aside><!-- title_line end -->
		<form id="form_19T">
		   <input type="hidden" name="code" id="code_19T" value="${code}"/>
		   <input type="hidden" id="fileName" name="fileName" value="excelDownName"/>
		   <ul class="right_btns">
			  <li><p class="btn_blue"><a href="#" id="search_19T"><span class="search"></span><spring:message code='sys.btn.search'/></a></p></li>
			</ul>
	
			<table class="type1 mt10"><!-- table start -->
				<caption>table</caption>
				<colgroup>
					<col style="width:100px" />
                    <col style="width:*" />
                    <col style="width:100px" />
                    <col style="width:*" />
                    <col style="width:100px" />
                    <col style="width:*" />
				</colgroup>
				<tbody>
					<tr>
						<th scope="row">Month/Year<span class="must">*</span></th>
						<td>
						<input type="text" title="Create start Date" placeholder="DD/MM/YYYY" name="searchDt" id="CMM0019T_Dt" class="j_date2" value="${searchDt_pop }" />
						</td>
						<th scope="row">ORDER ID</th>
						<td>
						      <input type="text" id="ordId_19T" name="ordId" style="width: 100px;" maxlength="10" onkeydown="onlyNumber(this)">
						</td>
						<th scope="row">BS PERSON ID</th>
                        <td>
                              <input type="text" id="bsPersonId_19T" name="bsPersonId" style="width: 100px;" maxlength="10" onkeydown="onlyNumber(this)">
                              <a id="memBtn" href="#" class="search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
                        </td>
                     </tr>
                     <tr>
						<th scope="row">isEx</th>
                        <td colspan="5">
                          <select id="useYnCombo_19T" name="useYnCombo" style="width:100px;">
                            <option value="" selected></option>
                            <option value="1">Y</option>
                            <option value="0">N</option>
                        </select>
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
				<li><p class="btn_grid">
				    <a href="#" id="save_19T"><spring:message code='sys.btn.save'/></a>
				</p></li>
			</ul>
			<!-- grid_wrap start -->
			<div id="grid_wrap_19" style="width: 100%; height: 334px; margin: 0 auto;"></div>
		</article><!-- grid_wrap end -->
	</section>
	
</div>
