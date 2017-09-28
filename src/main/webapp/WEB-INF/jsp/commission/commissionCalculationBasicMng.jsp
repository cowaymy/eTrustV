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

	//Defalut MultiCombo
	function fn_multiCombo() {
		$('#cmbCategory').change(function() {
		}).multipleSelect({
			selectAll : true, // 전체선택 
			width : '100%'
		});
	}
	
	// Make AUIGrid 
	var myGridID_Basic;
	var orgList = new Array(); //그룹 리스트
	var orgGridCdList = new Array(); //그리드 등록 그룹 리스트
	var orgItemList = new Array();   //그리드 등록 아이템 리스트

	//Start AUIGrid
	$(document).ready(function() {
		
		// AUIGrid 그리드를 생성합니다.
		myGridID_Basic = GridCommon.createAUIGrid("grid_wrap", columnLayout,"itemSeq");

		// cellClick event.
		AUIGrid.bind(myGridID_Basic, "cellClick", function(event) {
			console.log("rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex + " clicked");			
		});		
		
		AUIGrid.bind(myGridID_Basic, "cellEditBegin", auiCellEditingHandler);      // 에디팅 시작 이벤트 바인딩
		AUIGrid.bind(myGridID_Basic, "cellEditEnd", auiCellEditingHandler);        // 에디팅 정상 종료 이벤트 바인딩
		AUIGrid.bind(myGridID_Basic, "cellEditCancel", auiCellEditingHandler);    // 에디팅 취소 이벤트 바인딩
		AUIGrid.bind(myGridID_Basic, "addRow", auiAddRowHandler);               // 행 추가 이벤트 바인딩 
		AUIGrid.bind(myGridID_Basic, "removeRow", auiRemoveRowHandler);     // 행 삭제 이벤트 바인딩 
		
		//Rule Book Item search
		$("#search").click(function(){	
			Common.ajax("GET", "/commission/calculation/selectBasicCalculationList", $("#basicForm").serialize(), function(result) {
				console.log("성공.");
				console.log("data : " + result);
				AUIGrid.setGridData(myGridID_Basic, result);
			});
			Common.ajax("GET", "/commission/calculation/selectBasicStatus", $("#basicForm").serialize(), function(result) {
				if(result == null){
					$("#status").text("");
                    $("#exDate").text("");
				}else{
					$("#status").text(result.STATENM);
					$("#exDate").text(result.CAL_START_TIME);
				}
			});
			
	   });
		
		$("#logSearch").click(function(){ 
			Common.popupDiv("/commission/calculation/calBasicLogPop.do", $("#basicForm").serializeJSON());
		});
		
	});//Ready
	

	//event management
	function auiCellEditingHandler(event) {
		if (event.type == "cellEditEnd") {
			
		} else if (event.type == "cellEditBegin") {
			
		}
	}
	// 행 추가 이벤트 핸들러
    function auiAddRowHandler(event) {
	}
    // 행 삭제 이벤트 핸들러
    function auiRemoveRowHandler(event) {
    }


	// 아이템 AUIGrid 칼럼 설정
	var columnLayout = [ { 
		dataField : "codeName",
        headerText : "Procedure Name",
        style : "my-column",
        editable : false,
        width : 200
	}, {
		dataField : "cdds",
        headerText : "Description",
        style : "my-column",
        editable : false
	}, {
        dataField : "DATA",
        headerText : "조회",
        style : "my-column",
        renderer : {
            type : "ButtonRenderer",
            labelText : "SEARCH",
            onclick : function(rowIndex, columnIndex, value, item) {
            	$("#codeId").val(AUIGrid.getCellValue(myGridID_Basic, rowIndex, 5));
            	$("#prdNm").val(AUIGrid.getCellValue(myGridID_Basic, rowIndex, 0));
            	$("#prdDec").val(AUIGrid.getCellValue(myGridID_Basic, rowIndex, 1));
                Common.popupDiv("/commission/calculation/calBasicDataPop.do", $("#basicForm").serializeJSON());
            }
        },
        editable : false,
        width : 105
    },{
        dataField : "LOGE",
        headerText : "로그 조회",
        style : "my-column",
        renderer : {
            type : "ButtonRenderer",
            labelText : "SEARCH",
            onclick : function(rowIndex, columnIndex, value, item) {
            	$("#codeId").val(AUIGrid.getCellValue(myGridID_Basic, rowIndex, 4));
            	Common.popupDiv("/commission/calculation/calBasicLogPop.do", $("#basicForm").serializeJSON());
            }
        },
        editable : false,
        visible : false,
        width : 105
    }, {
		dataField : "codeId",
        headerText : "CODE ID",
       visible : false
	},  {
        dataField : "code",
        headerText : "CODE",
        visible : false
    }];
    
</script>


<section id="content">
	<!-- content start -->
	<ul class="path">
		<li><img src="${pageContext.request.contextPath}/resources/images/path_home.gif" alt="Home" /></li>
		<li>Sales</li>
		<li>Order list</li>
	</ul>

	<aside class="title_line">
		<!-- title_line start -->
		<p class="fav">
			<a href="#" class="click_add_on">My menu</a>
		</p>
		<h2>Commission Basic Data Collection</h2>

		<ul class="right_btns">
		<li><p class="btn_gray">          
                    <a href="#"  id="logSearch" ><span class="search"></span>LOG Data</a>
                </p></li>
			<li><p class="btn_gray">			
					<a href="#"  id="search" ><span class="search"></span><spring:message code='sys.btn.search'/></a>
				</p></li>
		</ul>

	</aside>
	<!-- title_line end -->

	<section class="search_table">
		<!-- search_table start -->
		<form id="basicForm" action="" method="post">
			<input type="hidden" name="procedureNm" id="procedureNm"/>
			<input type="hidden" name="codeId" id="codeId"/>
			<input type="hidden" name="prdNm" id="prdNm"/>
			<input type="hidden" name="prdDec" id="prdDec"/>
			
			<table class="type1">
				<!-- table start -->
				<caption>search table</caption>
				<colgroup>
					<col style="width: 110px" />
					<col style="width: *" />
					<col style="width: 110px" />
					<col style="width: *" />
					<col style="width: 110px" />
					<col style="width: *" />
				</colgroup>
				<tbody>
					<tr>
						<th scope="row">Month/Year</th>
						<td><input type="text" id="searchDt" name="searchDt" title="Month/Year" class="j_date2" value="${searchDt }" style="width: 200px;" /></td>
						
						<th scope="row">Status</th>
						<td><span id="status"></span></td>
						<th scope="row">Execute Date</th>
						<td><span id="exDate"></span></td>
					</tr>
				</tbody>
			</table>
			<!-- table end -->
		     
			<article class="grid_wrap">
				<!-- grid_wrap start -->
				<div id="grid_wrap" style="width: 100%; height: 500px; margin: 0 auto;"></div>
			</article>
			<!-- grid_wrap end -->
		</form>
    </section>
	
	<!-- bottom_msg_box end -->
	<!-- search_result end -->

</section>
<!-- content end -->

<!-- container end -->
<hr />

<!-- wrap end -->
</body>
</html>



