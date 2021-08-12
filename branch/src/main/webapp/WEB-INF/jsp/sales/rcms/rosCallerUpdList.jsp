<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<style type="text/css">
.my-pink-style {
    background:#FFA7A7;
    font-weight:bold;
    color:#22741C;
}
</style>


<script type="text/javascript">


var callerGridID;
var callerDetGridID;

$(document).ready(function() {    
	createRosCallerGrid();
	createRosCallerDetGrid();
	
	//Search
	$("#_searchBtn").click(function() {
		Common.ajax("GET", "/sales/rcms/selectCallerList", $("#_searchForm").serialize(), function(result) {
			AUIGrid.setGridData(callerGridID, result);
		});
	});
	
 	//Cell Click
	AUIGrid.bind(callerGridID, "cellClick", function(event){
		 Common.ajax("GET", "/sales/rcms/getCallerDetailList", {batchId : event.item.id}, function(result) {
	            AUIGrid.setGridData(callerDetGridID, result);
	            AUIGrid.setProp(callerDetGridID, "rowStyleFunction", function(rowIndex, item) {
	            	if(item.itmStusCodeId == '21'){
	            		return "my-pink-style";
	            	}else{
	            		return "";
	            	}
	            });
	            AUIGrid.update(callerDetGridID);
	     });
	});
});

$.fn.clearForm = function() {
    return this.each(function() {
        var type = this.type, tag = this.tagName.toLowerCase();
        if (tag === 'form'){
            return $(':input',this).clearForm();
        }
        if (type === 'text' || type === 'password' || type === 'hidden' || tag === 'textarea'){
            this.value = '';
        }else if (type === 'checkbox' || type === 'radio'){
            this.checked = false;
        }else if (tag === 'select'){
            this.selectedIndex = -1;
        }
    });
};


function fn_newCallerUpdate(){
	Common.popupDiv("/sales/rcms/callerUploadPop.do", null ,  null , true, '_addFileDiv');
}

function createRosCallerGrid(){
	
	 var callerColumnLayout =  [ 
                             
                             {dataField : "id", headerText : '<spring:message code="sal.title.text.batchId" />', width : '10%', editable : false},
                             {dataField : "totUpDt", headerText : '<spring:message code="sal.title.text.totalRows" />', width : '10%' , editable : false},
                             {dataField : "totCmplt", headerText : '<spring:message code="sal.title.text.totalSuccess" />', width : '10%' , editable : false},
                             {dataField : "totFail", headerText : '<spring:message code="sal.title.text.totalFail" />', width : '10%' , editable : false},
                             {dataField : "rosYear", headerText : '<spring:message code="sal.title.text.rosYear" />', width : '10%' , editable : false}, 
                             {dataField : "rosMonth", headerText : '<spring:message code="sal.title.text.rosMonth" />', width : '10%' , editable : false},
                             {dataField : "userName", headerText : '<spring:message code="sal.text.updator" />', width : '20%' , editable : false},
                             {dataField : "crtDt", headerText : '<spring:message code="sal.text.updateAt" />', width : '20%' , editable : false}
                         
                            ];
     
     //그리드 속성 설정
     var gridPros = {
             
             usePaging           : true,         //페이징 사용
             pageRowCount        : 10,           //한 화면에 출력되는 행 개수 20(기본값:20)            
             fixedColumnCount    : 1,            
             showStateColumn     : true,             
             displayTreeOpen     : false,            
      //       selectionMode       : "singleRow",  //"multipleCells",            
             headerHeight        : 30,       
             useGroupingPanel    : false,        //그룹핑 패널 사용
             skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
             wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
             showRowNumColumn    : true,         //줄번호 칼럼 렌더러 출력    
             noDataMessage       : "No Ros Caller found.",
             groupingMessage     : "Here groupping"
     };
     
     callerGridID = GridCommon.createAUIGrid("#caller_grid_wrap", callerColumnLayout,'', gridPros);  // address list
}

 function createRosCallerDetGrid(){
    
    var callerDetColumnLayout =  [ 
                            
                            {dataField : "ordNo", headerText : '<spring:message code="sal.title.text.ordNop" />', width : '20%', editable : false},
                            {dataField : "userName", headerText : '<spring:message code="sal.title.text.userName" />', width : '20%' , editable : false},
                            {dataField : "itmMsg", headerText : '<spring:message code="sal.title.text.msg" />', width : '60%' , editable : false},
                            {dataField : "itmStusCodeId", visible : false}
                           ];
    
    //그리드 속성 설정
    var gridPros = {
            
            usePaging           : true,         //페이징 사용
            pageRowCount        : 10,           //한 화면에 출력되는 행 개수 20(기본값:20)            
            fixedColumnCount    : 1,            
            showStateColumn     : true,             
            displayTreeOpen     : false,            
      //      selectionMode       : "singleRow",  //"multipleCells",            
            headerHeight        : 30,       
            useGroupingPanel    : false,        //그룹핑 패널 사용
            skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
            wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
            showRowNumColumn    : true,         //줄번호 칼럼 렌더러 출력    
            noDataMessage       : "No Ros Caller found.",
            groupingMessage     : "Here groupping"
    };
    
    callerDetGridID = GridCommon.createAUIGrid("#caller_det_grid_wrap", callerDetColumnLayout,'', gridPros);  // address list
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
<h2><spring:message code="sal.title.text.rosCallerUpdate" /></h2>
<ul class="right_btns">
    <li><p class="btn_blue"><a onclick="javascript:fn_newCallerUpdate()"><span ></span><spring:message code="sal.title.text.newRosCallerUpdate" /></a></p></li>
    <li><p class="btn_blue"><a id="_searchBtn"><span class="search"></span><spring:message code="sal.btn.search" /></a></p></li>
    <li><p class="btn_blue"><a onclick="javascript:$('#_searchForm').clearForm();"><span class="clear"></span><spring:message code="sal.btn.clear" /></a></p></li> 
</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form id="_searchForm">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:170px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sal.title.text.batchId" /></th>
    <td>
    <input type="text" title="" placeholder="Batch ID" class="w100p" id="_callBatchId" name="callBatchId" />
    </td>
    <th scope="row"><spring:message code="sal.title.text.updateDate" /></th>
    <td>
    <input type="text" title="key in Date" placeholder="DD/MM/YYYY" class="j_date"  name="srchDt" id="_srchDt"  readonly="readonly"/>
    </td>
    <th scope="row"><spring:message code="sal.text.updator" /></th>
    <td>
    <input type="text" title="" placeholder="Updator" class="w100p" id="_callUpdtor" name="callUpdtor" />
    </td>
</tr>
</tbody>
</table><!-- table end -->

</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="caller_grid_wrap" style="width:100%; height:300px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->
<article class="grid_wrap"><!-- grid_wrap start -->
<div id="caller_det_grid_wrap" style="width:100%; height:300px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->
</section><!-- search_result end -->

</section><!-- content end -->