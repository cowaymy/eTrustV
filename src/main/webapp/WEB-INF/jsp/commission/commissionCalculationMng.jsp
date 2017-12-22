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
	  
	// Make AUIGrid 
	var myGridID_CAL;
	var orgList = new Array(); //그룹 리스트
	var orgGridCdList = new Array(); //그리드 등록 그룹 리스트
	var orgItemList = new Array();   //그리드 등록 아이템 리스트
	
	var date = new Date();
    var year  = date.getFullYear();
    var month = date.getMonth() + 1; // 0부터 시작하므로 1더함 더함


	//Start AUIGrid
	$(document).ready(function() {
		
		// AUIGrid 그리드를 생성합니다.
		//myGridID_CAL = GridCommon.createAUIGrid("grid_wrap", columnLayout);
		createAUIGrid();

        // cellClick event.
        AUIGrid.bind(myGridID_CAL, "cellClick", function(event) {
            console.log("rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex + " clicked");          
        });     
        
        AUIGrid.bind(myGridID_CAL, "cellEditBegin", auiCellEditingHandler);      // 에디팅 시작 이벤트 바인딩
        AUIGrid.bind(myGridID_CAL, "cellEditEnd", auiCellEditingHandler);        // 에디팅 정상 종료 이벤트 바인딩
        AUIGrid.bind(myGridID_CAL, "cellEditCancel", auiCellEditingHandler);    // 에디팅 취소 이벤트 바인딩
        AUIGrid.bind(myGridID_CAL, "addRow", auiAddRowHandler);               // 행 추가 이벤트 바인딩 
        AUIGrid.bind(myGridID_CAL, "removeRow", auiRemoveRowHandler);     // 행 삭제 이벤트 바인딩 
        
        //Rule Book Item search
        $("#search").click(function(){  
            if(Number(year) < Number($("#searchDt").val().substr(3,7))){
                Common.alert("<spring:message code='commission.alert.currentDate'/>");
            }else if(Number(year) == Number($("#searchDt").val().substr(3,7)) && Number(month) < Number($("#searchDt").val().substr(0,2))){
                Common.alert("<spring:message code='commission.alert.currentDate'/>");
            }else{
                Common.ajax("GET", "/commission/calculation/selectCalculationList", $("#searchForm").serialize(), function(result) {
                    $("#batchYn").val("");
                    console.log("<spring:message code='sys.msg.success'/>");
                    console.log("data : " + result);
                    AUIGrid.setGridData(myGridID_CAL, result);
                });
            }
       });
        
        $("#runBatch").click(function(){
            if(Number(year) < Number($("#searchDt").val().substr(3,7))){
                Common.alert("<spring:message code='commission.alert.currentDate'/>");
            }else if(Number(year) == Number($("#searchDt").val().substr(3,7)) && Number(month) < Number($("#searchDt").val().substr(0,2))){
                Common.alert("<spring:message code='commission.alert.currentDate'/>");
            }else{
                /* var  myGridID_CALLength = AUIGrid.getGridData(myGridID_CAL).length;
                
                for(var i=0;i<myGridID_CALLength ;i++){
                    if(AUIGrid.getCellValue(myGridID_CAL, i, 2) == "1"){
                        Common.alert("<spring:message code='commission.alert.calRunning'/>");
                        return false;
                    }
                } */
                
                //Check : Run procedure in 20 minutes
                Common.ajax("GET", "/commission/calculation/runningPrdCheck",$("#searchForm").serializeJSON(), function(result) {
                    if(result.data[0] == null){
                        
                        var gridList = AUIGrid.getGridData(myGridID_CAL);       //그리드 데이터
                        var formList = $("#searchForm").serializeArray();       //폼 데이터
                        
                        //param data array
                        var data = {};
                        data.all = gridList;
                        data.form = formList;
                        
                        var option = {
                                timeout: 60000*3
                            };
                        Common.ajax("POST", "/commission/calculation/callCommissionProcedureBatch", data, function(result) {
                            $("#search").trigger("click");
                        }, function(jqXHR, textStatus, errorThrown) {
                            console.log("실패하였습니다.");
                            console.log("error : " + jqXHR + " \n " + textStatus + "\n" + errorThrown);
                            if(textStatus=="timeout" || jqXHR.status == 503){
                                 //Common.alert("Running... Please wait about 20 minutes ");
                                 Common.alert("<spring:message code='commission.alert.calculation.wait503error'/>");
                         $("#search").trigger("click");
                            }
                        },option);
                } else {
                        Common.alert("<spring:message code='commission.alert.calculation.runningWait' arguments='"+result.data[0].calYearMonth+" ; "+result.data[0].calName+"' htmlEscape='false' argumentSeparator=';' />");
                        //Common.alert(result.data[0].calYearMonth +" - "+result.data[0].calName+ " is running. </br> Please wait about 20 minutes ");
                    }
				});//runningPrdCheck

			}
		});

		$("#actionTypeS").click(function() {
			$("#search").trigger("click");
		});
		$("#actionTypeA").click(function() {
			$("#search").trigger("click");
		});

	});//Ready
	
	//event management
    function auiCellEditingHandler(event) {
    }
    // 행 추가 이벤트 핸들러
    function auiAddRowHandler(event) {
    }
    // 행 삭제 이벤트 핸들러
    function auiRemoveRowHandler(event) {
    }

	// 아이템 AUIGrid 칼럼 설정
	function createAUIGrid() {
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
			dataField : "calState",
			headerText : "result",
			style : "my-column",
			editable : false,
			visible : false
		}, {
			dataField : "statenm",
			headerText : "result",
			style : "my-column",
			editable : false,
			width : 100
		}, {
			dataField : "calStartTime",
			headerText : "date",
			style : "my-column",
			editable : false,
			width : 160
		}, {
			dataField : "DATA",
			headerText : "Data Search",
			style : "my-column",
			renderer : {
				type : "ButtonRenderer",
				labelText : "SEARCH",
				onclick : function(rowIndex, columnIndex, value, item) {
					$("#codeId").val(AUIGrid.getCellValue(myGridID_CAL, rowIndex, "codeId"));
					$("#code").val(AUIGrid.getCellValue(myGridID_CAL, rowIndex, "code"));
					$("#prdNm").val(AUIGrid.getCellValue(myGridID_CAL, rowIndex, "codeName"));
					$("#prdDec").val(AUIGrid.getCellValue(myGridID_CAL, rowIndex, "cdds"));
					Common.popupDiv("/commission/calculation/calCommDataPop.do", $("#searchForm").serializeJSON());
				}
			},
			editable : false,
			width : 105
		}, {
			dataField : "LOGE",
			headerText : "Log Search",
			style : "my-column",
			renderer : {
				type : "ButtonRenderer",
				labelText : "SEARCH",
				onclick : function(rowIndex, columnIndex, value, item) {
					$("#codeId").val(AUIGrid.getCellValue(myGridID_CAL, rowIndex, "codeId"));
					Common.popupDiv("/commission/calculation/calCommLogPop.do", $("#searchForm").serializeJSON());
				}
			},
			editable : false,
			width : 105
		}, {
            dataField : "exBtn",
            headerText : "Execute",
            style : "my-column",
            renderer : {
                type : "ButtonRenderer",
                labelText : "EXECUTE",
                onclick : function(rowIndex, columnIndex, value, item) {
                    $("#procedureNm").val(AUIGrid.getCellValue(myGridID_CAL, rowIndex, "codeName"));
                    $("#codeId").val(AUIGrid.getCellValue(myGridID_CAL, rowIndex, "codeId"));
                    $("#batchYn").val("N");
                    var  myGridID_CALLength = AUIGrid.getGridData(myGridID_CAL).length;
                    var failCnt = "0";
                    var state;
                    for(var i=0;i<myGridID_CALLength;i++){
                        state= AUIGrid.getCellValue(myGridID_CAL, i, "calState");
                        if(state == "9"){
                            failCnt = i;
                        }
                    }
                    for(var i=0;i<rowIndex;i++){
                        state= AUIGrid.getCellValue(myGridID_CAL, i, "calState");
                        if(state != "0"){
                            Common.alert("<spring:message code='commission.alert.calFirstExecute'/>");
                            return false;
                        }
                    }
                    
                    if(Number(year) < Number($("#searchDt").val().substr(3,7))){
                        Common.alert("<spring:message code='commission.alert.currentDate'/>");
                        return false;
                    }else if(Number(year) == Number($("#searchDt").val().substr(3,7)) && Number(month) < Number($("#searchDt").val().substr(0,2))){
                        Common.alert("<spring:message code='commission.alert.currentDate'/>");
                        return false;
                    }else if((AUIGrid.getCellValue(myGridID_CAL, rowIndex, "calState"))=="8" && (AUIGrid.getCellValue(myGridID_CAL, failCnt, "calState"))=="9" ){
                        Common.alert("<spring:message code='commission.alert.calFirstErrorExecute'/>");
                        return false;
                    }else {
                        
                        var data={"actionType":$("input[type=radio][name=actionType]:checked").val(),"ItemGrCd":AUIGrid.getCellValue(myGridID_CAL, rowIndex, "cd") , "prdNm":AUIGrid.getCellValue(myGridID_CAL, rowIndex, "codeName")};
                        Common.ajax("GET", "/commission/calculation/runningPrdCheck",data, function(result) {
                            
                            if(result.data[0] == null){
                                $("#lastLine").val("");
                                if(rowIndex == myGridID_CALLength-1){
                                    $("#lastLine").val("Y");
                                }else{
                                    $("#lastLine").val("N");
                                }
                                var option = {
                                        timeout: 60000*2
                                    }; 
                                Common.ajax("GET", "/commission/calculation/callCommissionProcedure", $("#searchForm").serialize(), function(result) {
                                    $("#search").trigger("click");
                                }, function(jqXHR, textStatus, errorThrown) {
                                      console.log("error : " + jqXHR + " \n " + textStatus + "\n" + errorThrown);                    
                             
                                      if(jqXHR.status==503){
                                          Common.alert("<spring:message code='commission.alert.calculation.wait503error'/>");
                                           //Common.alert("Running... Please wait about 20 minutes ");
                                           $("#search").trigger("click");
                                      }
                                },option); //callPrd
                                
                            }else{
                                Common.alert("<spring:message code='commission.alert.calculation.runningWait' arguments='"+result.data[0].calYearMonth+" ; "+result.data[0].calName+"' htmlEscape='false' argumentSeparator=';' />");
                                //Common.alert(result.data[0].calYearMonth +" - "+result.data[0].calName+ " is running. </br> Please wait about 20 minutes ");
                            }
                        });//runningPrdCheck
                        
                    }
                }
            },
			editable : false,
			width : 105
		}, {
			dataField : "codeId",
			headerText : "CODE ID",
			visible : false
		}, {
			dataField : "code",
			headerText : "CODE",
			visible : false
		}, {
			dataField : "cd",
			visible : false
		} ];
		// 그리드 속성 설정
		var gridPros = {
			usePaging : true, // 페이징 사용       
			pageRowCount : 20, // 한 화면에 출력되는 행 개수 20(기본값:20)
			skipReadonlyColumns : true, // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
			wrapSelectionMove : true, // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
			showRowNumColumn : true, // 줄번호 칼럼 렌더러 출력
			selectionMode : "singleRow"
		};
		myGridID_CAL = AUIGrid.create("#grid_wrap", columnLayout, gridPros);
	}
</script>


<section id="content">
	<!-- content start -->
	<ul class="path">
		<li><img src="${pageContext.request.contextPath}/resources/images/path_home.gif" alt="Home" /></li>
		<li><spring:message code='commission.text.head.commission'/></li>
		<li><spring:message code='commission.text.head.calculationMgmt'/></li>
		<li><spring:message code='commission.text.head.calculation'/></li>
	</ul>

    <aside class="title_line">
        <!-- title_line start -->
        <p class="fav">
            <a href="#" class="click_add_on">My menu</a>
        </p>
        <h2><spring:message code='commission.title.calculation'/></h2>

		<ul class="right_btns">
			<li><p class="btn_blue">		
					<a href="#"  id="search" ><span class="search"></span><spring:message code='sys.btn.search'/></a>
				</p></li>
		</ul>

	</aside>
	<!-- title_line end -->

	<section class="search_table">
		<!-- search_table start -->
		<form id="searchForm" action="" method="post">
	      <input type="hidden" id="dataDt" name="dataDt" value="${searchDt }"/>
	      <input type="hidden" name="prdNm" id="prdNm"/>
          <input type="hidden" name="prdDec" id="prdDec"/>
		  <input type="hidden" id="orgGrCd" name="orgGrCd" value=""/>
		  <input type="hidden" id="lastLine" name="lastLine" value=""/>
          
            <table class="type1">
                <!-- table start -->
                <caption>search table</caption>
                <colgroup>
                    <col style="width: 110px" />
                    <col style="width: *" />
                    <col style="width: 110px" />
                    <col style="width: *" />
                </colgroup>
                <tbody>
                    <tr>
                        <th scope="row"><spring:message code='commission.text.search.monthYear'/></th>
                        <td><input type="text" id="searchDt" name="searchDt" title="Month/Year" class="j_date2" value="${searchDt }" style="width: 200px;" /></td>
                        <th scope="row"><spring:message code='commission.text.search.orgGroup'/></th>
                        <td><select id="orgRgCombo" name="ItemGrCd" style="width: 100px;">
                                <c:forEach var="list" items="${orgGrList }">
                                    <option value="${list.code}">${list.code}</option>
                                </c:forEach>
                        </select>
                        <label><input type="radio" name="actionType" id="actionTypeA" value="A"checked/><span><spring:message code='commission.text.search.actual'/></span></label>
                        <label><input type="radio" name="actionType" id="actionTypeS" value="S"/><span><spring:message code='commission.text.search.simulation'/></span></label></td>
					</tr>
				</tbody>
			</table>
			<!-- table end -->
	       <input type="hidden" name="procedureNm" id="procedureNm"/>
	       <input type="hidden" name="codeId" id="codeId"/>
	       <input type="hidden" name="code" id="code"/>
	       <input type="hidden" name="batchYn" id="batchYn"/>
	       
			<ul class="right_btns">
				<li><p class="btn_grid"><a href="#" id="runBatch"><spring:message code='commission.button.runBatch'/></a></p></li>
			</ul>
			
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



