<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<style type="text/css">

/* Cell -셀력션 백그라운드 스타일 재정의 */
#experian_detail_grid_wrap .aui-grid-selection-bg {
    background: #99CCFF !important;
    color:#000 !important;
    font-weight:normal !important;
}

/* 셀렉션의 대표 셀 보더 색상 스타일 재정의*/
#experian_detail_grid_wrap .aui-grid-selection-cell-border-lines {
    ackground: #2e6da4;
}
</style>

<script type="text/javascript">

var experianListGridID;
var experianDetailGridID;

$(document).ready(function() {

	//experian
	createExpGrid();
    createExpDetailGrid();

	//Search
	$("#_search").click(function() {

		//Validation
		if( null == $("#_sDate").val() || '' == $("#_sDate").val()){
			Common.alert('<spring:message code="sal.alert.msg.plzKeyInFromDt" />');
			return;
		}

		Common.ajax("GET", "/sales/ccp/selectEXPERIANB2BList", $("#_searchForm").serialize(), function(Result){
            //set Grid
            AUIGrid.setGridData(experianListGridID, Result);
        });
	});

	//Cell Double Click
	AUIGrid.bind(experianListGridID, "cellDoubleClick", function(event){
        var expdetailParam = {batchId : event.item.batchId};
        Common.ajax("GET", "/sales/ccp/getExpDetailList", expdetailParam , function(Result){
            $("#_ordNo").attr("disabled" , false);
            $("#_filterChange").attr("disabled" , false);
            AUIGrid.setGridData(experianDetailGridID, Result);
        });
    });

	//Order Search
	$("#_ordSrchBtn").click(function() {

		$("#_filterChange").val("0");
		clearDetailFilterAll();

		if( null == $("#_ordNo").val() || '' == $("#_ordNo").val()){
            Common.alert('<spring:message code="sal.alert.msg.plzKeyInOrdNumb" />');
            return;
        }

		var options = {
		        direction : true, // 검색 방향  (true : 다음, false : 이전 검색)
		        caseSensitive : false, // 대소문자 구분 여부 (true : 대소문자 구별, false :  무시)
		        wholeWord : true, // 온전한 단어 여부
		        wrapSearch : true, // 끝에서 되돌리기 여부
		};

		AUIGrid.search(experianDetailGridID, "ordNo", $("#_ordNo").val() , options);
	});

	$("#_filterChange").change(function() {
		if(this.value == 0){
			clearDetailFilterAll();
		}
	    if(this.value == 1){
	    	fn_detailAct();
        }
		if(this.value == 2){
			fn_detailComplete();
		}
		if(this.value == 3){
			fn_detailPrev();
		}
		if(this.value == 4){
			fn_scoreZero();
		}
		if(this.value == 5){
			fn_scoreGT();
		}
		if(this.value == 6){
            fn_scoreLT();
        }

	});
	// Search Not Found Binding Event
    AUIGrid.bind(experianDetailGridID, "notFound", searchNotFoundHandler);
});//Document Ready Func End

function searchNotFoundHandler(event) {
    var term = event.term;
    var wrapFound = event.wrapFound;

    if(wrapFound) {
        Common.alert('<spring:message code="sal.alert.msg.notFoundBrOrdNo" />' + term);
    } else {
    	Common.alert('<spring:message code="sal.alert.msg.notFoundBrOrdNo" />' + term);
    }
};

function createExpGrid(){
    var  columnLayout = [
                         {dataField : "batchId", headerText : '<spring:message code="sal.title.text.batchNo" />', width : "7%" , editable : false},
                         {dataField : "fileName", headerText : '<spring:message code="sal.title.text.fileName" />', width : "15%" , editable : false},
                         {dataField : "rowCnt", headerText : '<spring:message code="sal.title.text.tot" />', width : "7%" , editable : false},
                         {dataField : "comple", headerText : '<spring:message code="sal.combo.text.compl" />', width : "7%" , editable : false},
                         {dataField : "act", headerText : '<spring:message code="sal.title.text.act" />', width : "7%" , editable : false},
                         {dataField : "zero", headerText : '<spring:message code="sal.title.text.zero" />', width : "6%" , editable : false},
                         {dataField : "lt500", headerText : '<spring:message code="sal.title.text.lt500" />', width : "6%" , editable : false},
                         {dataField : "gt501", headerText : '<spring:message code="sal.title.text.gt500" />', width : "6%" , editable : false},
                         {dataField : "stus", headerText : '<spring:message code="sal.title.status" />', width : "6%" , editable : false},
                         {dataField : "updDt", headerText : '<spring:message code="sal.title.text.uploadTime" />', width : "15%" , editable : false},
                         {dataField : "updUserId", headerText : '<spring:message code="sal.title.text.uploadUser" />', width : "9%" , editable : false},
                         {
                             dataField : "",
                             headerText : "",
                             renderer : {
                                 type : "ButtonRenderer",
                                 labelText : "Download",
                                 onclick : function(rowIndex, columnIndex, value, item) {
                                   efileDown(item.batchId);
                                 }
                             }
                         , width : "9%"
                         , editable : false
                         },
                   ]
    //그리드 속성 설정
    var gridPros = {
            usePaging           : true,         //페이징 사용
            pageRowCount        : 9,           //한 화면에 출력되는 행 개수 20(기본값:20)
            editable            : false,
            fixedColumnCount    : 1,
            showStateColumn     : false,
            displayTreeOpen     : false,
     //       selectionMode       : "singleRow",  //"multipleCells",
            headerHeight        : 30,
            useGroupingPanel    : false,        //그룹핑 패널 사용
            skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
            wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
            showRowNumColumn    : false
        };
    experianListGridID = GridCommon.createAUIGrid("#experian_grid_wrap", columnLayout,'', gridPros);
}

function createExpDetailGrid(){
    var  columnLayout = [
                         {dataField : "batchId", headerText : '<spring:message code="sal.title.text.batchNo" />', width : "8%" , editable : false},
                         {dataField : "ordNo", headerText : '<spring:message code="sal.text.ordNo" />', width : "8%" , editable : false},
                         {dataField : "custIc", headerText : '<spring:message code="sal.title.text.custIC" />', width : "10%" , editable : false},
                         {dataField : "custName", headerText : '<spring:message code="sal.text.custName" />', width : "16%" , editable : false},
                         {dataField : "prcName", headerText : '<spring:message code="sal.title.status" />', width : "7%" , editable : false},
                         {dataField : "experianScre", headerText : 'Score', width : "5%" , editable : false},
                         {dataField : "experianRisk", headerText : 'Risk', width : "5%" , editable : false},
                         {dataField : "codeName", headerText : '<spring:message code="sal.title.text.bankrupt" />', width : "8%" , editable : false},
                         {dataField : "experianDt", headerText : '<spring:message code="sal.title.text.updateTime" />', width : "9%" , editable : false},
             //            {dataField : "confirmEntity", headerText : '<spring:message code="sal.text.confirmEntity" />', width : "9%" , editable : false},
                         {dataField : "updUserId", headerText : '<spring:message code="sal.title.text.updateUser" />', width : "9%" , editable : false, visible : false},
                         {
                             dataField : "undefined",
                             headerText : "Experian Report",
                             width : '9%',
                             renderer : {
                                      type : "ButtonRenderer",
                                      labelText : "View",
                                      onclick : function(rowIndex, columnIndex, value, item) {
                                          console.log("item.batchId : " + item.batchId);
                                          fn_displayReport("EXPERIAN_VIEW" , item.batchId , item.ordNo);
                                    }
                             }
                         },
                         {dataField : "prcss", visible: false}
                         ]
    //그리드 속성 설정
    var gridPros = {
            usePaging           : true,         //페이징 사용
            pageRowCount        : 9,           //한 화면에 출력되는 행 개수 20(기본값:20)
            editable            : false,
            fixedColumnCount    : 1,
            showStateColumn     : false,
            displayTreeOpen     : false,
   //         selectionMode       : "multipleCells",  //"multipleCells",
            headerHeight        : 30,
            useGroupingPanel    : false,        //그룹핑 패널 사용
            skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
            wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
            showRowNumColumn    : false
        };

    experianDetailGridID = GridCommon.createAUIGrid("#experian_detail_grid_wrap", columnLayout,'', gridPros);
}

//TODO 미개발
function fn_underDevelop(){
    Common.alert('The program is under development.');
}

//Filter Clear
function clearDetailFilterAll() {

    AUIGrid.clearFilterAll(experianDetailGridID);
};
//score == 0
function fn_scoreZero() {
    clearDetailFilterAll();
    AUIGrid.setFilter(experianDetailGridID, "experianScre",  function(dataField, value, item) {
        if(item.experianScre == 0){
            return true;
        }
        return false;
    });
};

//score > 500
function fn_scoreGT() {
    clearDetailFilterAll();
    AUIGrid.setFilter(experianDetailGridID, "experianScre",  function(dataField, value, item) {
        if(item.experianScre > 500){
            return true;
        }
        return false;
    });
};

//score <= 500 and score != 0
function fn_scoreLT() {
    clearDetailFilterAll();
    AUIGrid.setFilter(experianDetailGridID, "experianScre",  function(dataField, value, item) {
        if(item.experianScre <= 500 && item.experianScre > 0){
            return true;
        }
        return false;
    });
};

//Active
function fn_detailAct() {
    clearDetailFilterAll();
    AUIGrid.setFilter(experianDetailGridID, "prcss",  function(dataField, value, item) {
        if(item.prcss  == '0'){
            return true;
        }
        return false;
    });
};

//Complete
function fn_detailComplete() {
    clearDetailFilterAll();
    AUIGrid.setFilter(experianDetailGridID, "prcss",  function(dataField, value, item) {
        if(item.prcss  == '1'){
            return true;
        }
        return false;
    });
};

//Previous Score
function fn_detailPrev() {
    clearDetailFilterAll();
    AUIGrid.setFilter(experianDetailGridID, "prcss",  function(dataField, value, item) {
        if(item.prcss  == '2'){
            return true;
        }
        return false;
    });
};

function efileDown(batchId){
	var date = new Date().getDate();

	if(date.toString().length == 1){
		date = "0" + date;
	}

	$('#v_batchId').val(batchId);
	$('#reportDownFileName').val("B2B Experian RawData_"+date+(new Date().getMonth()+1)+new Date().getFullYear());

	var option = {
			isProcedure : true // procedure 로 구성된 리포트 인경우 필수.  => /payment/PaymentListing_Excel.rpt 는 프로시져로 구성된 파일임.
	};

	Common.report("_searchForm", option);
}

/*****************************Display Report View**********************************************/

function fn_displayReport(viewType, batchId, ordNo){

	var isRe = false;
	console.log("DEFAULT_RESOURCE_FILE : " + DEFAULT_RESOURCE_FILE);
	Common.ajax("GET", "/sales/ccp/getResultRowForExpDisplay", {viewType : viewType , batchId : batchId , ordNo : ordNo}, function(Result){
		console.log("Result : " + Result);
		console.log("content  :  " + JSON.stringify(Result));
		if(Result.subPath != null && Result.subPath !='' && Result.fileName != null && Result.fileName != ''){
			window.open(DEFAULT_RESOURCE_FILE+'/'+Result.subPath+ '/' + Result.fileName, 'report' , "width=800, height=600");
		}else{
			isRe  = true;
		}
    },'',{async : false});

	if(isRe == true){
		Common.alert("No Experian Report available");
		return;
	}
}

</script>

<section id="content"><!-- content start -->
    <ul class="path">
        <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home"/></li>
        <li>Sales</li>
        <li>Order list</li>
    </ul>
    <aside class="title_line"><!-- title_line start -->
        <p class="fav"> <a href="#" class="click_add_on">My menu</a></p>
        <!--  <h2><spring:message code="sal.title.text.ctosB2BResult" /></h2>-->
        <h2>CCP Auto-Approve Config</h2>
        <ul class="right_btns">
            <c:if test="${PAGE_AUTH.funcView == 'Y'}">
                <li><p class="btn_blue"><a id="_search"><span class="search"></span><spring:message code="sal.btn.search"/></a></p></li>
            </c:if>
            <li><p class="btn_blue"><a href="#"><span class="clear"></span><spring:message code="sal.btn.clear"/></a></p></li>
        </ul>
    </aside><!-- title_line end -->
    <section class="search_table"><!-- search_table start -->
        <form id="_searchForm">
            <input type="hidden" id="reportFileName" name="reportFileName" value="/sales/CCPEXPB2BRaw_Excel.rpt"/>
            <input type="hidden" id="v_batchId" name="v_batchId" value=""/>
            <input type="hidden" id="viewType" name="viewType" value="EXCEL"/>
            <input type="hidden" id="reportDownFileName" name="reportDownFileName" value=""/>
            <table class="type1"><!-- table start -->
                <caption>table</caption>
                <colgroup>
                    <col style="width:180px"/>
                    <col style="width:*"/>
                    <col style="width:180px"/>
                    <col style="width:*"/>
                </colgroup>
                <tbody>
                    <tr>
                        <th scope="row"><spring:message code="sal.title.text.fromDate"/></th>
                        <td><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p" id="_sDate" name="sDate" value="${toDay}"/></td>
                        <th scope="row"><spring:message code="sal.title.text.toDate"/></th>
                        <td><input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date w100p" id="_eDate" name="eDate"/></td>
                    </tr>
                </tbody>
            </table><!-- table end -->
        </form>
    </section><!-- search_table end -->
    <section class="search_result"><!-- search_result start -->
        <article class="grid_wrap"><!-- grid_wrap start -->
            <div id="experian_grid_wrap" style="width:100%; height:300; margin:0 auto;"/>
        </article> <!-- grid_wrap end -->
    </section><!-- search_result end -->
    <section class="search_result"><!-- search_result start -->
        <ul class="right_btns">
            <li>
                <select id="_filterChange" disabled="disabled">
                    <option value="0" selected="selected"><spring:message code="sal.btn.all"/></option>
                    <option value="1"><spring:message code="sal.btn.active"/></option>
                    <option value="2"><spring:message code="sal.combo.text.compl"/></option>
                    <option value="3"><spring:message code="sal.title.text.previousScore"/></option>
                    <option value="4"><spring:message code="sal.title.text.noScore"/></option>
                    <option value="5"> <= 500</option>
                    <option value="6"> > 500</option>
                </select>
            </li>
            <li>
                <input type="text" title="" placeholder="search by order number" class="wAuto" id="_ordNo" disabled="disabled"/>
                <a id="_ordSrchBtn" class="search_btn"> <img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search"/></a>
            </li>
        </ul>
            <article class="grid_wrap"><!-- grid_wrap start -->
                <div id="experian_detail_grid_wrap" style="width:100%; height:300; margin:0 auto;"/>
            </article><!-- grid_wrap end -->
    </section><!-- search_result end -->
</section><!-- content end -->