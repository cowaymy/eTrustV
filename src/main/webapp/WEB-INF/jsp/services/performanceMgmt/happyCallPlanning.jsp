<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">
// Make AUIGrid 
var myGridID;
var callTypeList = new Array();
var evalCriteriaList = new Array();
var feedbackTypeList = new Array();

$(document).ready(function() {
    
    happyCallGrid();
    fn_selectCallType();
    fn_selectEvalCriteria();
    fn_selectFeedbackType();

    doGetCombo('/services/performanceMgmt/selectCodeNameList.do', 80, '', 'cmbCallType', 'S', '');
    doGetCombo('/services/performanceMgmt/selectCodeNameList.do', 386, '', 'cmbEvalCriteria', 'S', '');
    doGetCombo('/services/performanceMgmt/selectCodeNameList.do', 102, '', 'cmbFeedbackType', 'S', '');

                    
    //search
    $("#search").click(function() {
        //var cmbMemberTypeId22 = $("#cmbMemberTypeId").val();
        //alert(cmbMemberTypeId22);
                                        
        Common.ajax("GET","/services/performanceMgmt/selectSurveyEventList",$("#listSForm").serialize(),function(result) {
            console.log("성공.");
            console.log("data : "+ result);
            AUIGrid.setGridData(myGridID,result);
        });
                                    
    });
                
});

function happyCallGrid() {
    
	// AUIGrid 칼럼 설정
    var columnLayout = [ {
		        dataField : "callType",
		        headerText : 'Call Type',
		        width : 150,
		        editRenderer : {
		        	type : "DropDownListRenderer",
                    showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 보이기
                    listFunction : function(rowIndex, columnIndex, item, dataField) {
                        var list = callTypeList;
                        return list;
                    }, 
                    keyField : "callType",
                    valueField : "callType"
                }
		    }, {
		        dataField : "questionNumber",
		        headerText : 'Question <br/>Number',
		        width : 100,
                editRenderer : {
                    type : "DropDownListRenderer",
                    showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 보이기
                    listFunction : function(rowIndex, columnIndex, item, dataField) {
                    	var list = fn_selectQuestionNum();
                        return list;
                    }, 
                    keyField : "questionNumber",
                    //valueField : "questionNumber"
                }
		    }, {
		        dataField : "feedbackType",
		        headerText : 'Feedback Type',
		        width : 200,
		        editRenderer : {
                    type : "DropDownListRenderer",
                    showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 보이기
                    listFunction : function(rowIndex, columnIndex, item, dataField) {
                        var list = feedbackTypeList;
                        return list;
                    }, 
                    keyField : "feedbackType",
                    valueField : "feedbackType"
                }
		    }, {
		        dataField : "evaluationCriteria",
		        headerText : 'Evaluation Criteria',
		        width : 150,
		        editable : true, 
		        editRenderer : {
                    type : "DropDownListRenderer",
                    showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 보이기
                    listFunction : function(rowIndex, columnIndex, item, dataField) {
                        var list = evalCriteriaList;
                        return list;
                    }, 
                    keyField : "evaluationCriteria",
                    valueField : "evaluationCriteria"
                }
		    }, {
		        dataField : "question",
		        headerText : 'Question',
		        width : 400,
		        editable : true
		    }, {
		        dataField : "periodFrom",
		        headerText : 'Period From',
		        width : 200,
		        dataType : "date",
		        formatString : "dd/mm/yyyy",
		        editable : true, 
		        editRenderer : {
                    type : "CalendarRenderer",
                    showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 출력 여부
                    showExtraDays : true // 지난 달, 다음 달 여분의 날짜(days) 출력
                  },
                onlyCalendar : false // 사용자 입력 불가, 즉 달력으로만 날짜입력 (기본값 : true)
		    }, {
		        dataField : "periodTo",
		        headerText : 'Period To',
		        width : 200,
		        dataType : "date",
		        formatString : "dd/mm/yyyy",
		        editable : true, 
		        editRenderer : {
                    type : "CalendarRenderer",
                    showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 출력 여부
                    showExtraDays : true // 지난 달, 다음 달 여분의 날짜(days) 출력
                  },
                onlyCalendar : false // 사용자 입력 불가, 즉 달력으로만 날짜입력 (기본값 : true)
		    }, {
                dataField : "status",
                headerText : 'Status',
                width : 100,
                editable : true, 
                editRenderer : {
                    type : "DropDownListRenderer",
                    showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 보이기
                    listFunction : function(rowIndex, columnIndex, item, dataField) {
                        var list = fn_selectStatus();
                        return list;
                    }, 
                    keyField : "status",
                    //valueField : "status"
                }
            }, {
                dataField : "hcId",
                headerText : 'HC ID',
                editable : false, 
                visible : true
            } ];
	
	//그리드 속성 설정
    var gridPros = {
        usePaging           : true,         //페이징 사용
        pageRowCount        : 20,           //한 화면에 출력되는 행 개수 20(기본값:20)            
        showStateColumn     : false,             
        displayTreeOpen     : false,            
        selectionMode       : "singleRow",  //"multipleCells",            
        skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
        wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
        showRowNumColumn    : true,         //줄번호 칼럼 렌더러 출력    
        headerHeight : 30
    };
	
	// Create AUIGrid
    myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout, "hcId", gridPros);
	
	AUIGrid.bind(myGridID, "cellEditBegin", function (event){
        if (event.columnIndex == 0 || event.columnIndex == 1 || event.columnIndex == 2){
            if(AUIGrid.isAddedById(myGridID, event.item.hcId)) {
                return true;
            }else{
                return false;
            }
        }       
    });
	
    /* // 에디팅 정상 종료 이벤트 바인딩
    AUIGrid.bind(myGridID, "cellEditEnd", auiCellEditingHandler); */

}

/* //편집 핸들러
function auiCellEditingHandler(event) {
    if(event.columnIndex == 0 && event.value == "Public Holiday"){
        AUIGrid.setCellValue(gridID, event.rowIndex,  1, "");
        AUIGrid.setColumnProp( gridID, 1, { editable : false } );
    } else if(event.columnIndex == 0 && event.value != "Public Holiday") {
        AUIGrid.setColumnProp( gridID, 1, { editable : true } );
    }
}; */

function fn_clear(){
	$("#cmbCallType").val('');
    $("#cmbFeedbackType").val('');
    $("#cmbEvalCriteria").val('');
    $("#periodMonth").val('');
}

function fn_exportTo(){
    GridCommon.exportTo("grid_wrap", 'xlsx',"Happy Call Planning");
}

function fn_addRow(){
    var item = new Object();
    item.callType = "";
    item.questionNumber = "";
    item.feedbackType = "";
    item.evaluationCriteria = "";
    item.question = "";
    item.periodFrom = "";
    item.periodTo = "";
    item.hcId = "";
   
    // parameter
    // item : 삽입하고자 하는 아이템 Object 또는 배열(배열인 경우 다수가 삽입됨)
    // rowPos : rowIndex 인 경우 해당 index 에 삽입, first : 최상단, last : 최하단, selectionUp : 선택된 곳 위, selectionDown : 선택된 곳 아래
    AUIGrid.addRow(myGridID, item, "first");
}

function fn_removeRow(){
    AUIGrid.removeRow(myGridID, "selectedIndex");
    AUIGrid.removeSoftRows(myGridID);
}

function fn_save(){
    if(GridCommon.getEditData(myGridID) != null){
        Common.ajax("POST", "/services/performanceMgmt/saveHappyCallList.do", GridCommon.getEditData(myGridID), function(result) {
            console.log("Save 성공.");
            console.log("data : " + result);
        });
    } else {
    	alert("null");
    }
}

/* function fn_validationCheck(){
	var result = true;
	return result;
} */

function fn_selectCallType(){
    Common.ajax("GET", "/services/performanceMgmt/selectCodeNameList.do",{groupCode : 80}, function(result) {
        console.log("성공.");
        console.log("data : " + result);
        
        for (var i = 0; i < result.length; i++) {
            var list = new Object();
            list.callType = result[i].codeName;
            //list.callTypeId = result[i].codeId;
            callTypeList.push(list);
            }
        });
    return callTypeList;
}

function fn_selectQuestionNum(){
	var list = [ "1", "2", "3", "4", "5", "6", "7", "8", "9"];
    return list;
}

function fn_selectFeedbackType(){
    Common.ajax("GET", "/services/performanceMgmt/selectCodeNameList.do",{groupCode : 102}, function(result) {
        console.log("성공.");
        console.log("data : " + result);
        
        for (var i = 0; i < result.length; i++) {
            var list = new Object();
            list.feedbackType = result[i].codeName;
            //list.feedbackTypeId = result[i].codeId;
            feedbackTypeList.push(list);
            }
        });
    return feedbackTypeList;
}

function fn_selectEvalCriteria(){
    Common.ajax("GET", "/services/performanceMgmt/selectCodeNameList.do",{groupCode : 103}, function(result) {
        console.log("성공.");
        console.log("data : " + result);
        
        for (var i = 0; i < result.length; i++) {
            var list = new Object();
            list.evaluationCriteria = result[i].codeName;
            //list.evaluationCriteriaId = result[i].codeId;
            evalCriteriaList.push(list);
            }
        });
    return evalCriteriaList;
}

function fn_selectStatus(){
    var list = [ "Active", "Inactive"];
    return list;
}

function fn_search(){
    Common.ajax("GET", "/services/performanceMgmt/selectHappyCallList.do", $('#searchForm').serialize(), function(result) {
        console.log("성공.");
        console.log("data : " + result);
        AUIGrid.setGridData(myGridID, result);
    });
}
	
</script>

<section id="content">
<!-- content start -->
<ul class="path">
	<li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
	<li>Service</li>   
	<li>Performance Mgmt.</li>   
	<li>Happy Call Planning</li>
</ul>

<aside class="title_line">
	<!-- title_line start -->
	<p class="fav">
		<a href="#" class="click_add_on">My menu</a>
	</p>
	<h2>Happy Call Planning</h2>
	<ul class="right_btns">
<c:if test="${PAGE_AUTH.funcView == 'Y'}">	
		<li><p class="btn_blue"><a href="#" onclick="fn_search()"><span class="search"></span>Search</a></p></li>
</c:if>		
		<li><p class="btn_blue"><a href="#" onclick="fn_clear()"><span class="clear"></span>Clear</a></p></li>
	</ul>
</aside>
<!-- title_line end -->

<section class="search_table"><!-- search_table start -->
<form action="#" id="popSForm" name="popSForm" method="post">
	<input type="hidden" id="popEvtTypeDesc" name="popEvtTypeDesc" /> 
	<input type="hidden" id="popMemCode" name="popMemCode" /> 
	<input type="hidden" id="popCodeDesc" name="popCodeDesc" /> 
	<input type="hidden" id="popEvtDt" name="popEvtDt" /> 
	<input type="hidden" id="popServeyStatus" name="popServeyStatus" />
</form>

<form action="#" method="post" id="searchForm" name="searchForm">
<table class="type1"><!-- table start -->
	<caption>table</caption>
	<colgroup>
		<col style="width: 180px" />
		<col style="width: *" />
		<col style="width: 180px" />
		<col style="width: *" />
		<col style="width: 160px" />
		<col style="width: *" />
	</colgroup>
	<tbody>
		<tr>
			<th scope="row">Call Type</th>
			<td><select id="cmbCallType" name="cmbCallType" class="w100p"></select>
			</td>
			<th scope="row">Feedback Type</th>
			<td><select id="cmbFeedbackType" name="cmbFeedbackType" class="w100p"></select>
			</td>
			<th scope="row">Evaluation Criteria</th>
			<td><select id="cmbEvalCriteria" name="cmbEvalCriteria" class="w100p"></select>
			</td>
		</tr>
		<tr>
			<th scope="row">Period Month</th>
			<td><input id="periodMonth" name="periodMonth" type="text" title="Period Month" placeholder="MM/YYYY" class="j_date2 w100p" readonly /></td>
			<th scope="row">Status</th>
            <td>
            <select id="cmbStatus" name="cmbStatus" class="w100p">
                <option value="">All</option>
                <option value="1">Active</option>
                <option value="8">Inactive</option>
            </select>
			<th scope="row"></th>
			<td></td>
		</tr>
	</tbody>
</table><!-- table end -->

<aside class="link_btns_wrap"><!-- link_btns_wrap start -->
</aside><!-- link_btns_wrap end -->

</form>
</section><!-- search_table end -->


<section class="search_result"><!-- search_result start -->

	<ul class="right_btns">
<%-- <c:if test="${PAGE_AUTH.funcChange == 'Y'}"> --%>	
		<li><p class="btn_grid"><a href="#" onclick="fn_addRow()">Add</a></p></li>
		<li><p class="btn_grid"><a href="#" onclick="fn_removeRow()">Delete</a></p></li>
		<li><p class="btn_grid"><a href="#" onclick="fn_save()">Save</a></p></li>
<%-- </c:if> --%>
<c:if test="${PAGE_AUTH.funcPrint == 'Y'}">
		<li><p class="btn_grid"><a href="#" onclick="fn_exportTo()">GENERATE</a></p></li>
</c:if>	
		<!-- <li><p class="btn_grid"><a href="#" onClick="javascript:fn_newEvent();">New Event</a></p></li> -->
		<!-- <li><p class="btn_grid"><a href="#">Edit Event</a></p></li> -->
	</ul>

	<article class="grid_wrap"><!-- grid_wrap start -->
		<div id="grid_wrap" style="width: 100%; height: 380px; margin: 0 auto;"></div>
	</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- content end -->