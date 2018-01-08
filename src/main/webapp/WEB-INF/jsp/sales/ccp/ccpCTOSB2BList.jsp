<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">

var ctosListGridID;
var ctosDetailGridID;

$(document).ready(function() {
    
	//create Grid
	createCtosGrid();
	createCtosDetailGrid();
	
	
	//Search
	$("#_search").click(function() {
		  
		//Validation
		if( null == $("#_sDate").val() || '' == $("#_sDate").val()){
			Common.alert("* please key in from Date");
			return;
		}
		
		/* if(null == $("#_eDate").val() || '' == $("#_eDate").val()){
		    Common.alert("* please key in to Date");
		    return;
		} */
		
		Common.ajax("GET", "/sales/ccp/selectCTOSB2BList", $("#_searchForm").serialize(), function(result){
			//set Grid
			AUIGrid.setGridData(ctosListGridID, result);
			
		});
	});
	
	//Cell Double Click
	AUIGrid.bind(ctosListGridID, "cellDoubleClick", function(event){
        
		var detailParam = {batchId : event.item.batchId};
		Common.ajax("GET", "/sales/ccp/getCTOSDetailList", detailParam , function(result){
			$("#_ordNo").attr("disabled" , false);
			$("#_filterChange").attr("disabled" , false);
			AUIGrid.setGridData(ctosDetailGridID, result);
			
		});
		
    });
	
	//Order Search
	$("#_ordSrchBtn").click(function() {
		
		$("#_filterChange").val("0");
		clearDetailFilterAll();
		
		if( null == $("#_ordNo").val() || '' == $("#_ordNo").val()){
            Common.alert("* Please key in order number. ");
            return;
        }
		
		var options = {
		        direction : true, // 검색 방향  (true : 다음, false : 이전 검색)
		        caseSensitive : false, // 대소문자 구분 여부 (true : 대소문자 구별, false :  무시)
		        wholeWord : true, // 온전한 단어 여부
		        wrapSearch : true, // 끝에서 되돌리기 여부
		};
		
		AUIGrid.search(ctosDetailGridID, "ordNo", $("#_ordNo").val() , options);
		
		
		//Validation
		/* if(AUIGrid.getGridData(ctosListGridID) <= 0 || AUIGrid.getGridData(ctosDetailGridID) <= 0 ){
			Common.alert("* Please search first.");
			return;
		}
		
		if( null == $("#_ordNo").val() || '' == $("#_ordNo").val()){
			Common.alert("* Please key in order number. ");
			return;
		}
		
		var clickObj =  AUIGrid.getSelectedItems(ctosListGridID);
		var batchId = clickObj[0].item.batchId;
		var ordParam = {batchId : batchId , ordNo : $("#_ordNo").val()};
		Common.ajax("GET", "/sales/ccp/getCTOSDetailByOrdNo", ordParam , function(result){
			AUIGrid.setGridData(ctosDetailGridID, result);
		}); */
		
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
    AUIGrid.bind(ctosDetailGridID, "notFound", searchNotFoundHandler);
	
});//Document Ready Func End


function searchNotFoundHandler(event) {
    var term = event.term; 
    var wrapFound = event.wrapFound; 
    
    if(wrapFound) {
        Common.alert("Not Found.  <br/> Order No : " + term);
    } else {
    	Common.alert("Not Found.  <br/> Order No : " + term);
    }
};

function createCtosGrid(){
	var  columnLayout = [
	                     {dataField : "batchId", headerText : "Batch No", width : "7%" , editable : false},
	                     {dataField : "fileName", headerText : "File Name", width : "14%" , editable : false},
	                     {dataField : "rowCnt", headerText : "Total", width : "8%" , editable : false},
	                     {dataField : "comple", headerText : "Complete", width : "8%" , editable : false},
	                     {dataField : "act", headerText : "Act", width : "8%" , editable : false},
	                     {dataField : "zero", headerText : "ZERO", width : "8%" , editable : false},
	                     {dataField : "lt500", headerText : "LT500", width : "8%" , editable : false},
	                     {dataField : "gt501", headerText : "GT501", width : "8%" , editable : false},
	                     {dataField : "stus", headerText : "STATUS", width : "9%" , editable : false},
	                     {dataField : "updDt", headerText : "Upload Time", width : "13%" , editable : false},
	                     {dataField : "updUserId", headerText : "Upload User", width : "9%" , editable : false}
	               ]
	
	
	//그리드 속성 설정
    var gridPros = {
            usePaging           : true,         //페이징 사용
            pageRowCount        : 10,           //한 화면에 출력되는 행 개수 20(기본값:20)            
            editable            : false,            
            fixedColumnCount    : 1,            
            showStateColumn     : false,             
            displayTreeOpen     : false,            
     //       selectionMode       : "singleRow",  //"multipleCells",            
            headerHeight        : 30,       
            useGroupingPanel    : false,        //그룹핑 패널 사용
            skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
            wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
            showRowNumColumn    : false,         //줄번호 칼럼 렌더러 출력    
            noDataMessage       : "No order found.",
            groupingMessage     : "Here groupping"
        };
    
	ctosListGridID = GridCommon.createAUIGrid("#ctos_grid_wrap", columnLayout,'', gridPros);
	
	
}


function createCtosDetailGrid(){
	var  columnLayout = [
                         {dataField : "batchId", headerText : "Batch No", width : "9%" , editable : false},
                         {dataField : "ordNo", headerText : "Order No", width : "9%" , editable : false},
                         {dataField : "custIc", headerText : "Customer IC", width : "10%" , editable : false},
                         {dataField : "custName", headerText : "Customer Name", width : "9%" , editable : false},
                         {dataField : "prcName", headerText : "Status", width : "9%" , editable : false},
                         {dataField : "ficoScre", headerText : "Score", width : "9%" , editable : false},
                         {dataField : "codeName", headerText : "Bankrupt", width : "9%" , editable : false},
                         {dataField : "ctosDt", headerText : "Update Time", width : "9%" , editable : false},
                         {dataField : "updUserId", headerText : "Update User", width : "9%" , editable : false},
                         {
                             dataField : "undefined", 
                             headerText : "Fico Report", 
                             width : '9%',
                             renderer : {
                                      type : "ButtonRenderer", 
                                      labelText : "View", 
                                      onclick : function(rowIndex, columnIndex, value, item) {
                                          
                                    	  console.log("item.batchId : " + item.batchId);
                                    	//  alert("Fico View  batchId : " + item.batchId + " , ordNo : " + item.ordNo );
                                    	  fn_displayReport("FICO_VIEW" , item.batchId , item.ordNo);
                                          
                                    }
                             }
                         },
                         {
                             dataField : "undefined", 
                             headerText : "CTOS Report", 
                             width : '9%',
                             renderer : {
                                      type : "ButtonRenderer", 
                                      labelText : "View", 
                                      onclick : function(rowIndex, columnIndex, value, item) {
                                          
                                    	  fn_displayReport("CTOS_VIEW" , item.batchId , item.ordNo);
                                          
                                    }
                             }
                         },
                         {dataField : "prcss", visible: false}
                         ]
	
	//그리드 속성 설정
    var gridPros = {
            usePaging           : true,         //페이징 사용
            pageRowCount        : 10,           //한 화면에 출력되는 행 개수 20(기본값:20)            
            editable            : false,            
            fixedColumnCount    : 1,            
            showStateColumn     : false,             
            displayTreeOpen     : false,            
   //         selectionMode       : "multipleCells",  //"multipleCells",            
            headerHeight        : 30,       
            useGroupingPanel    : false,        //그룹핑 패널 사용
            skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
            wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
            showRowNumColumn    : false,         //줄번호 칼럼 렌더러 출력    
            noDataMessage       : "No order found.",
            groupingMessage     : "Here groupping"
        };
    
	ctosDetailGridID = GridCommon.createAUIGrid("#ctos_detail_grid_wrap", columnLayout,'', gridPros);
}

//TODO 미개발
function fn_underDevelop(){
    Common.alert('The program is under development.');
}

//Filter Clear
function clearDetailFilterAll() {
    
    AUIGrid.clearFilterAll(ctosDetailGridID);
};
// score == 0
function fn_scoreZero() {
    AUIGrid.setFilter(ctosDetailGridID, "ficoScre",  function(dataField, value, item) {
    	if(item.ficoScre == 0){
    		return true;
    	}
    	return false;
    });
};

//score > 500
function fn_scoreGT() {  
    AUIGrid.setFilter(ctosDetailGridID, "ficoScre",  function(dataField, value, item) {
        if(item.ficoScre > 500){
            return true;
        }
        return false;
    });
};

//score <= 500 and score != 0
function fn_scoreLT() { 
    AUIGrid.setFilter(ctosDetailGridID, "ficoScre",  function(dataField, value, item) {
        if(item.ficoScre <= 500 && item.ficoScre > 0){
            return true;
        }
        return false;
    });
};

//Active
function fn_detailAct() { 
    AUIGrid.setFilter(ctosDetailGridID, "prcss",  function(dataField, value, item) {
        if(item.prcss  == '0'){
            return true;
        }
        return false;
    });
};

//Complete
function fn_detailComplete() {
    AUIGrid.setFilter(ctosDetailGridID, "prcss",  function(dataField, value, item) {
        if(item.prcss  == '1'){
            return true;
        }
        return false;
    });
};

//Previous Score
function fn_detailPrev() {
    AUIGrid.setFilter(ctosDetailGridID, "prcss",  function(dataField, value, item) {
        if(item.prcss  == '2'){
            return true;
        }
        return false;
    });
};


/*****************************Display Report View**********************************************/

function fn_displayReport(viewType, batchId, ordNo){
	
	var isRe = false;
	
	Common.ajax("GET", "/sales/ccp/getResultRowForCTOSDisplay", {viewType : viewType , batchId : batchId , ordNo : ordNo}, function(result){
		
		console.log("result : " + result);
		console.log("content  :  " + JSON.stringify(result));
        console.log("DEFAULT_RESOURCE_FILE : " + DEFAULT_RESOURCE_FILE); 
		 if(result != null){
			 window.open(DEFAULT_RESOURCE_FILE+'/'+result.subPath+ '/' + result.fileName, 'report' , "width=800, height=600");
		}else{
			isRe  = true;
		}
	},'',{async : false});
	
	if(isRe == true){
		Common.alert("No result from CTOS");
		return;
	}
}

</script>


<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>Sales</li>
    <li>Order list</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>CTOS(B2B) Result</h2>
<ul class="right_btns">
    <c:if test="${PAGE_AUTH.funcView == 'Y'}">
    <li><p class="btn_blue"><a id="_search"><span class="search"></span>Search</a></p></li>
    </c:if>
    <li><p class="btn_blue"><a href="#"><span class="clear"></span>Clear</a></p></li>
</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form id="_searchForm">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
    <col style="width:180px" />
    <col style="width:*" />
    <!-- <col style="width:120px" />
    <col style="width:*" /> -->
</colgroup>
<tbody>
<tr>
    <th scope="row">From Date</th>
    <td><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p"  id="_sDate" name="sDate" value="${toDay}"/></td>
    <th scope="row">To Date</th>
    <td><input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date w100p" id="_eDate"  name="eDate"/></td>
   <!--  <th scope="row">Status</th>
    <td>
    <select class="multy_select w100p" multiple="multiple" name="stus">
        <option value="4">4</option>
    </select>
    </td> -->
</tr>
</tbody>
</table><!-- table end -->

</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->


<article class="grid_wrap"><!-- grid_wrap start -->
<div id="ctos_grid_wrap" style="width:100%; height:300; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

<section class="search_result"><!-- search_result start -->

<ul class="right_btns">
    <li>
        <select id="_filterChange" disabled="disabled">
            <option value="0" selected="selected">All</option>
            <option value="1">Active</option>
            <option value="2">Complete</option>
            <option value="3">Previos Score</option>
            <option value="4">No Score(0)</option>
            <option value="5"> <= 500</option>
            <option value="6"> > 500</option>
        </select>
    </li>
    
    <li>  
        <input type="text" title="" placeholder="search by order number" class="wAuto"  id="_ordNo" disabled="disabled" /><a  id="_ordSrchBtn" class="search_btn">
        <img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
    </li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="ctos_detail_grid_wrap" style="width:100%; height:300; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- content end -->

