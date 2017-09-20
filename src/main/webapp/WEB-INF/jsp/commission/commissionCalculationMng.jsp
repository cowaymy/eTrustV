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

	//Defalut MultiCombo
	function fn_multiCombo() {
		$('#cmbCategory').change(function() {
		}).multipleSelect({
			selectAll : true, // 전체선택 
			width : '100%'
		});
	}
	
	
	
	  
	// Make AUIGrid 
	var myGridID;
	var orgList = new Array(); //그룹 리스트
	var orgGridCdList = new Array(); //그리드 등록 그룹 리스트
	var orgItemList = new Array();   //그리드 등록 아이템 리스트
	
	var date = new Date();
    var year  = date.getFullYear();
    var month = date.getMonth() + 1; // 0부터 시작하므로 1더함 더함


	//Start AUIGrid
	$(document).ready(function() {
		//change orgCombo List
        $("#orgRgCombo").change(function() {
            $("#ItemGrCd").val($(this).find("option[value='" + $(this).val() + "']").text());
        });
		
		// AUIGrid 그리드를 생성합니다.
		//myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout);
		createAUIGrid();

		// cellClick event.
		AUIGrid.bind(myGridID, "cellClick", function(event) {
			console.log("rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex + " clicked");			
		});		
		
		AUIGrid.bind(myGridID, "cellEditBegin", auiCellEditingHandler);      // 에디팅 시작 이벤트 바인딩
		AUIGrid.bind(myGridID, "cellEditEnd", auiCellEditingHandler);        // 에디팅 정상 종료 이벤트 바인딩
		AUIGrid.bind(myGridID, "cellEditCancel", auiCellEditingHandler);    // 에디팅 취소 이벤트 바인딩
		AUIGrid.bind(myGridID, "addRow", auiAddRowHandler);               // 행 추가 이벤트 바인딩 
		AUIGrid.bind(myGridID, "removeRow", auiRemoveRowHandler);     // 행 삭제 이벤트 바인딩 
		
		//Rule Book Item search
		$("#search").click(function(){	
			if(Number(year) < Number($("#searchDt").val().substr(3,7))){
				alert("검색 날짜 오류");
			}else if(Number(year) == Number($("#searchDt").val().substr(3,7)) && Number(month) < Number($("#searchDt").val().substr(0,2))){
				alert("검색 날짜 오류");
			}else{
				Common.ajax("GET", "/commission/calculation/selectCalculationList", $("#searchForm").serialize(), function(result) {
					$("#batchYn").val("");
					console.log("성공.");
					console.log("data : " + result);
					AUIGrid.setGridData(myGridID, result);
				});
			}
	   });
		
		$("#runBatch").click(function(){
			if(Number(year) < Number($("#searchDt").val().substr(3,7))){
                alert("검색 날짜 오류");
            }else if(Number(year) == Number($("#searchDt").val().substr(3,7)) && Number(month) < Number($("#searchDt").val().substr(0,2))){
                alert("검색 날짜 오류");
            }else{
				var  myGridIdLength = AUIGrid.getGridData(myGridID).length;
				
				for(var i=0;i<myGridIdLength ;i++){
					if(AUIGrid.getCellValue(myGridID, i, 2) == "1"){
						alert("실행 중 입니다.");
                        return false;
					}
				}
				$("#batchYn").val("Y");
				//array에 담기        
				var gridList = AUIGrid.getGridData(myGridID);       //그리드 데이터
				var formList = $("#searchForm").serializeArray();       //폼 데이터
				
				//param data array
				var data = {};
				
			    data.all = gridList;
			    data.form = formList;
			    
				Common.ajax("POST", "/commission/calculation/callCommissionProcedureBatch", data, function(result) {
	                $("#search").trigger("click");
	            }); 
			}
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

	//그리드 그룹 리스트
	function getOrgCdData(val) {
		var retStr = "";
		$.each(orgGridCdList, function(key, value) {
			var id = value.id;
			if (id == val) {
				retStr = value.orgSeq + "," + value.orgGrCd + "," + value.id + "," + value.value + "," + value.cdDs;
			}
		});
		return retStr;
	}

	// 아이템 AUIGrid 칼럼 설정
	function createAUIGrid() {
		var columnLayout = [ { 
			dataField : "codeName",
	        headerText : "Procedure Name",
	        style : "my-column",
	        editable : false,
	        width : 160
		}, {
			dataField : "cdds",
	        headerText : "Description",
	        style : "my-column",
	        editable : false
		}, {
            dataField : "calState",
            headerText : "result",
            style : "my-column",
            editable : false,
            visible : false
        },{
            dataField : "statenm",
            headerText : "result",
            style : "my-column",
            editable : false,
            width : 100
        },{
	        dataField : "calStartTime",
	        headerText : "date",
	        style : "my-column",
	        editable : false,
	        width : 160
	    },{
	        dataField : "DATA",
	        headerText : "조회",
	        style : "my-column",
	        renderer : {
	            type : "ButtonRenderer",
	            labelText : "SEARCH",
	            onclick : function(rowIndex, columnIndex, value, item) {
	            	$("#codeId").val(AUIGrid.getCellValue(myGridID, rowIndex, 8));
	            	$("#code").val(AUIGrid.getCellValue(myGridID, rowIndex, 9));
	                Common.popupDiv("/commission/calculation/calCommDataPop.do", $("#searchForm").serializeJSON());
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
	            	$("#codeId").val(AUIGrid.getCellValue(myGridID, rowIndex, 8));
	            	Common.popupDiv("/commission/calculation/calCommLogPop.do", $("#searchForm").serializeJSON());
	            }
	        },
	        editable : false,
	        width : 105
	    },{
			dataField : "exBtn",
	        headerText : "Execute",
	        style : "my-column",
	        renderer : {
	            type : "ButtonRenderer",
	            labelText : "EXECUTE",
	            onclick : function(rowIndex, columnIndex, value, item) {
	            	$("#procedureNm").val(AUIGrid.getCellValue(myGridID, rowIndex, 0));
	            	$("#codeId").val(AUIGrid.getCellValue(myGridID, rowIndex, 8));
	            	$("#batchYn").val("N");
	            	var  myGridIdLength = AUIGrid.getGridData(myGridID).length;
	            	var failCnt = "0";
	            	var state;
	            	for(var i=0;i<myGridIdLength;i++){
	            		state= AUIGrid.getCellValue(myGridID, i, "calState");
	            		if(state == "9"){
	            			failCnt = i;
	            		}
	            	}
	            	for(var i=0;i<rowIndex;i++){
	            		state= AUIGrid.getCellValue(myGridID, i, "calState");
	            		if(state != "0"){
	            			alert("선행 프로시저를 먼저 실행해주세요."); 	
	            			return false;
	            		}
	            	}
	            	
	            	if((AUIGrid.getCellValue(myGridID, rowIndex, 2))=="1"){
	            		alert("실행 중 입니다.");
	            		return false;
	            	}else if((AUIGrid.getCellValue(myGridID, rowIndex, 2))=="8" && (AUIGrid.getCellValue(myGridID, failCnt, 2))=="9" ){
	            		alert("에러가 난 프로시저를 먼저 실행해주세요."); 
	            		return false;
	            	}else{
		            	Common.ajax("GET", "/commission/calculation/callCommissionProcedure", $("#searchForm").serialize(), function(result) {
		            		$("#search").trigger("click");
		                }); 
	            	}
	            }
	        },
	        editable : false,
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
    
        };
        myGridID = AUIGrid.create("#grid_wrap", columnLayout,gridPros);
	}
    
</script>


<section id="content">
	<!-- content start -->
	<ul class="path">
		<li><img src="image/path_home.gif" alt="Home" /></li>
		<li>Sales</li>
		<li>Order list</li>
	</ul>

	<aside class="title_line">
		<!-- title_line start -->
		<p class="fav">
			<a href="#" class="click_add_on">My menu</a>
		</p>
		<h2>RUN Commission</h2>

		<ul class="right_btns">
			<li><p class="btn_gray">			
					<a href="#"  id="search" ><span class="search"></span><spring:message code='sys.btn.search'/></a>
				</p></li>
		</ul>

	</aside>
	<!-- title_line end -->

	<section class="search_table">
		<!-- search_table start -->
		<form id="searchForm" action="" method="post">
      <input type="hidden" id="ItemGrCd" name="ItemGrCd"/>
      <input type="hidden" id="dataDt" name="dataDt" value="${searchDt }"/>
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
					<col style="width: 110px" />
					<col style="width: *" />
				</colgroup>
				<tbody>
					<tr>
					    <th scope="row">Month/Year</th>
                        <td><input type="text" id="searchDt" name="searchDt" title="Month/Year" class="j_date2" value="${searchDt }" style="width: 200px;" /></td>
						<th scope="row">ORG Group</th>
						<td><select id="orgRgCombo" name="orgRgCombo" style="width: 100px;">
								<option value=""></option>
								<c:forEach var="list" items="${orgGrList }">
									<option value="${list.code}">${list.code}</option>
								</c:forEach>
						</select>
						<label><input type="radio" name="use_yn" checked/><span>Actual</span></label>
                        <label><input type="radio" name="use_yn" /><span>Simulation</span></label></td>
						<input type="hidden" id="orgGrCd" name="orgGrCd" value="">
					</tr>
				</tbody>
			</table>
			<!-- table end -->
	       <input type="hidden" name="procedureNm" id="procedureNm"/>
	       <input type="hidden" name="codeId" id="codeId"/>
	       <input type="hidden" name="code" id="code"/>
	       <input type="hidden" name="batchYn" id="batchYn"/>
	       
			<ul class="right_btns">
				<li><p class="btn_grid"><a href="#" id="runBatch">RUN BATCH</a></p></li>
			</ul>
			
			<article class="grid_wrap">
				<!-- grid_wrap start -->
				<div id="grid_wrap" style="width: 100%; height: 500px; margin: 0 auto;"></div>
			</article>
			<!-- grid_wrap end -->
        </form>
	</section>
	<aside class="bottom_msg_box">
		<!-- bottom_msg_box start -->
		<p></p>
	</aside>
	<!-- bottom_msg_box end -->
	<!-- search_result end -->

</section>
<!-- content end -->

</section>
<!-- container end -->
<hr />

</div>
<!-- wrap end -->
</body>
</html>



