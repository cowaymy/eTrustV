<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">
//AUIGrid 생성 후 반환 ID
var ccpGridID;
var ordGridID;
var timerId = null;

$(document).ready(function() {
	
	createCcpAUIGrid();
	createOrdAUIGrid();
	
//	AUIGrid.resize(ordGridID);
	
	//hidding OrdGrid
	$("#ord_grid_wrap").css("display" , "none");
	
	 // 셀 더블클릭 이벤트 바인딩
    AUIGrid.bind(ccpGridID, "cellDoubleClick", function(event){
        $("#_govAgId").val(event.item.govAgId);
        Common.popupDiv("/sales/ccp/selectAgreementMtcViewEditPop.do", $("#popForm").serializeJSON(), null , true , '_viewEditDiv');
    });
	 
	 //Move to Insert Page
    $("#_goToAddWindow").click(function() {
    	//self.location.href= "/sales/ccp/insertCcpAgreementSearch.do";
    	Common.popupDiv("/sales/ccp/newCcpAgreementSearchPop.do", $("#popForm").serializeJSON(), null , true , '_newDiv');
	});
	
    /* // 셀 클릭 이벤트 바인딩
    AUIGrid.bind(ccpGridID, "cellClick", function(event) {
    	
    	//Grid 데이터 가져오기
    	$("#_ordAgId").val(event.item.govAgId);
    	Common.ajax("GET", "/sales/ccp/selectListOrdersAjax",  $("#ordGridForm").serialize(), function(result) {
            AUIGrid.setGridData(ordGridID, result);
         });
    	//Gird 보여주기
    	$("#ord_grid_wrap").css("display" , "");
    }); */
    
    // 셀 클릭 이벤트 바인딩
    AUIGrid.bind(ccpGridID, "selectionChange", auiGridSelectionChangeHandler);
	 
});//Doc Ready Func End

function auiGridSelectionChangeHandler(event) { 
    
    // 200ms 보다 빠르게 그리드 선택자가 변경된다면 데이터 요청 안함
    if(timerId) {
        clearTimeout(timerId);
    }
    
    timerId = setTimeout(function() {
        var selectedItems = event.selectedItems;
        if(selectedItems.length <= 0)
            return;
        
        var rowItem = selectedItems[0].item; // 행 아이템들
        var govAgId = rowItem.govAgId; // 선택한 행의 고객 ID 값
        
        $("#_ordAgId").val(govAgId);
        
        Common.ajax("GET", "/sales/ccp/selectListOrdersAjax",  $("#ordGridForm").serialize(), function(result) {
            AUIGrid.setGridData(ordGridID, result);
        });
        $("#ord_grid_wrap").css("display" , "");
        
    }, 200);  // 현재 200ms 민감도....환경에 맞게 조절하세요.
};

//TODO 미개발
function fn_underDevelop(){
	Common.alert('The program is under development.');
}

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


function fn_selectCcpAgreementListAjax(){
	
	Common.ajax("GET", "/sales/ccp/selectCcpAgreementJsonList",  $("#searchForm").serialize(), function(result) {
		AUIGrid.setGridData(ccpGridID, result);
		
   });
}

function createCcpAUIGrid(){
	
	var  columnLayout = [
	      {dataField : "govAgBatchNo", headerText : '<spring:message code="sal.title.text.agrNo" />', width : "10%" , editable : false},
	      {dataField : "name", headerText : '<spring:message code="sal.text.custName" />', width : "20%" , editable : false},
	      {dataField : "salesOrdNo", headerText : '<spring:message code="sal.title.ordNo" />', width : "10%" , editable : false},
	      {dataField : "name1", headerText : '<spring:message code="sal.title.status" />', width : "10%" , editable : false},
	      {dataField : "code", headerText : '<spring:message code="sal.title.type" />', width : "10%" , editable : false},
	      {dataField : "govAgPrgrsName", headerText : '<spring:message code="sal.title.text.prgss" />', width : "10%" , editable : false},
	      {dataField : "govAgStartDt", headerText : '<spring:message code="sal.title.text.agrStart" />', width : "10%" , editable : false},
	      {dataField : "govAgEndDt", headerText : '<spring:message code="sal.title.text.agrExpiry" />', width : "10%" , editable : false},
	      {dataField : "govAgCrtDt", headerText : '<spring:message code="sal.text.created" />', width : "10%" , editable : false},
	      {dataField : "govAgId", visible : false}
	]
	
	//그리드 속성 설정
    var gridPros = {
			usePaging           : true,         //페이징 사용
            pageRowCount        : 20,           //한 화면에 출력되는 행 개수 20(기본값:20)            
            editable            : false,            
            fixedColumnCount    : 1,            
            showStateColumn     : true,             
            displayTreeOpen     : false,            
     //       selectionMode       : "singleRow",  //"multipleCells",            
            headerHeight        : 30,       
            useGroupingPanel    : false,        //그룹핑 패널 사용
            skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
            wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
            showRowNumColumn    : true,         //줄번호 칼럼 렌더러 출력    
            noDataMessage       : "No order found.",
            groupingMessage     : "Here groupping"
        };
	
	ccpGridID = GridCommon.createAUIGrid("#ccp_grid_wrap", columnLayout,'', gridPros);
}

function createOrdAUIGrid(){
	
	var orderColumnLayout = [
                             
                             {dataField : "salesOrdNo" , headerText :'<spring:message code="sal.title.ordNo" />' , width : "15%"},  
                             {dataField : "codeName" , headerText : '<spring:message code="sal.title.status" />' , width : "15%"},
                             {dataField : "govAgItmStartDt" , headerText : '<spring:message code="sal.text.startDate" />' , width : "10%"},
                             {dataField : "govAgItmExprDt" , headerText : '<spring:message code="sal.text.expiryDate" />', width : "10%"},
                             {dataField : "name" , headerText : '<spring:message code="sal.title.text.customer" />' , width : "10%"},
                             {dataField : "govAgItmInstResult" , headerText : '<spring:message code="sal.title.text.installResult" />' , width : "10%"},    
                             {dataField : "govAgItmRentResult" , headerText : '<spring:message code="sal.text.rentalStatus" />' , width : "10%"},
                             {dataField : "userFullName" , headerText : '<spring:message code="sal.text.creator" />' , width : "10%"}, 
                             {dataField : "govAgItmCrtDt" , headerText : 'Created', width : "10%"}
       ];
      
       //그리드 속성 설정
      var gridPros = {
              
              usePaging           : true,         //페이징 사용
              pageRowCount        : 10,           //한 화면에 출력되는 행 개수 20(기본값:20)            
              editable            : false,            
              fixedColumnCount    : 1,            
              showStateColumn     : true,             
              displayTreeOpen     : false,            
 //             selectionMode       : "singleRow",  //"multipleCells",            
              headerHeight        : 30,       
              useGroupingPanel    : false,        //그룹핑 패널 사용
              skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
              wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
              showRowNumColumn    : true
          };
      
      ordGridID = GridCommon.createAUIGrid("ord_grid_wrap", orderColumnLayout,'', gridPros);
	
}

function popup(location){
	if(location == "rowData"){
        Common.popupDiv("/sales/ccp/ccpAgreementRawPop.do", $("#popForm").serializeJSON(), null, true);
	}else if(location == 'listing'){
		Common.popupDiv("/sales/ccp/ccpAgreementListingPop.do", $("#popForm").serializeJSON(), null, true);
	}else if(location == 'summary'){
		Common.popupDiv("/sales/ccp/ccpAgreementSummaryReportPop.do", $("#popForm").serializeJSON(), null, true);
	}else if(location == 'consignmentCourier'){
		Common.popupDiv("/sales/ccp/ccpAgreementConsignmentCourierListingPop.do", $("#popForm").serializeJSON(), null, true);
	}
	
}


</script>
<form id="ordGridForm">
    <input type="hidden" id="_ordAgId" name="ordAgId">    
</form>
<form id="popForm">
    <input type="hidden" id="_govAgId" name="govAgId" >
</form>
<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>Sales</li>
    <li>Order list</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2><spring:message code="sal.title.text.govAgrList" /></h2>
<ul class="right_btns">
    <c:if test="${PAGE_AUTH.funcChange == 'Y'}">
    <li><p class="btn_blue"><a href="#" id="_goToAddWindow" ><span class="add"></span><spring:message code="sal.title.text.new" /></a></p></li>
    </c:if>
    <c:if test="${PAGE_AUTH.funcView == 'Y'}">
    <li><p class="btn_blue"><a href="#" onclick="javascript : fn_selectCcpAgreementListAjax()"><span class="search" ></span><spring:message code="sal.btn.search" /></a></p></li>
    </c:if>
    <li><p class="btn_blue"><a href="#" onclick="javascript:$('#searchForm').clearForm();"><span class="clear"></span><spring:message code="sal.btn.clear" /></a></p></li>
</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form action="#" method="get"  id="searchForm">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:200px" />
    <col style="width:*" />
    <col style="width:190px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sal.title.text.agrNo" /></th>
    <td><input type="text" title="" placeholder="" class="w100p"  name="govAgBatchNo"/></td>
    <th scope="row"><spring:message code="sal.title.text.crtDateFrom" /></th>
    <td><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p"  name="govAgCrtDtFrom" readonly="readonly"/></td>
    <th scope="row"><spring:message code="sal.title.text.crtDateTo" /></th>
    <td><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p" name="govAgCrtDtTo" readonly="readonly"/></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.ordNo" /></th>
    <td><input type="text" title="" placeholder="" class="w100p" name="salesOrdNo"/></td>
    <th scope="row"><spring:message code="sal.title.text.agrStartFrom" /></th>
    <td><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p" name="govAgStartDtFrom" readonly="readonly"/></td>
    <th scope="row"><spring:message code="sal.title.text.agrStartTo" /></th>
    <td><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p" name="govAgStartDtTo" readonly="readonly"/></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.custName" /></th>
    <td><input type="text" title="" placeholder="" class="w100p"  name="name"/></td>
    <th scope="row"><spring:message code="sal.title.text.agrExpFrom" /></th>
    <td><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p" name="govAgEndDtFrom" readonly="readonly"/></td>
    <th scope="row"><spring:message code="sal.title.text.agrExpTo" /></th>
    <td><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p" name="govAgEndDtTo" readonly="readonly"/></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.prgss" /></th>
    <td>
    <select class="multy_select w100p" multiple="multiple" name="progressVal">
        <option value="7" selected="selected"><spring:message code="sal.title.text.submissPrgss" /></option>
        <option value="8" selected="selected"><spring:message code="sal.title.text.verifyPrgss" /></option>
        <option value="9" selected="selected"><spring:message code="sal.title.text.stampingConfPrgss" /></option>
        <option value="10" selected="selected"><spring:message code="sal.title.text.fillingPrgss" /></option>
    </select>
    </td>
    <th scope="row"><spring:message code="sal.title.text.agrStatus" /></th>
    <td>
    <select class="multy_select w100p" multiple="multiple" name="statusVal">
        <option value="1" selected="selected"><spring:message code="sal.btn.active" /></option>
        <option value="4" selected="selected"><spring:message code="sal.combo.text.compl" /></option>
        <option value="10" selected="selected"><spring:message code="sal.combo.text.cancelled" /></option>
    </select>
    </td>
    <th scope="row"><spring:message code="sal.title.text.agreeType" /></th>
    <td>
    <select class="multy_select w100p" multiple="multiple" name="typeVal">
        <option value="949" selected="selected"><spring:message code="sal.title.text.new" /></option>
        <option value="950" selected="selected"><spring:message code="sal.title.text.reNew" /></option>
    </select>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.agmReqstor" /></th>
    <td>
    <select class="multy_select w100p" disabled="disabled"></select>
    </td>
    <th scope="row"><spring:message code="sal.text.memberCode" /></th>
    <td><input type="text" title="" placeholder="" class="w100p" name="memCode"/></td>
    <th scope="row"><spring:message code="sal.title.text.agrCrtor" /></th>
    <td><input type="text" title="" placeholder="" class="w100p" name="userName"/></td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="link_btns_wrap"><!-- link_btns_wrap start -->
<p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
<dl class="link_list">
    <dt><spring:message code="sal.title.text.link" /></dt>
    <dd>
    <ul class="btns">
        <c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
        <li><p class="link_btn type2"><a href="#" onclick="javascript : popup('rowData')"><spring:message code="sal.title.text.rawData" /></a></p></li>
        </c:if>
        <c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
        <li><p class="link_btn type2"><a href="#" onclick="javascript : popup('listing')"><spring:message code="sal.title.text.listing" /></a></p></li>
        </c:if>
        <c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
        <li><p class="link_btn type2"><a href="#" onclick="javascript : popup('summary')"><spring:message code="sal.title.text.summary" /></a></p></li>
        </c:if>
        <c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
        <li><p class="link_btn type2"><a href="#" onclick="javascript : popup('consignmentCourier')"><spring:message code="sal.title.text.consCourier" /></a></p></li>
        </c:if>
    </ul>
    <ul class="btns">
    </ul>
    <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
    </dd>
</dl>
</aside><!-- link_btns_wrap end -->

</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<!-- <ul class="right_btns">
    <li><p class="btn_grid"><a href="#">EXCEL UP</a></p></li>
    <li><p class="btn_grid"><a href="#">EXCEL DW</a></p></li>
    <li><p class="btn_grid"><a href="#">DEL</a></p></li>
    <li><p class="btn_grid"><a href="#">INS</a></p></li>
    <li><p class="btn_grid"><a href="#">ADD</a></p></li>
</ul> -->

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="ccp_grid_wrap" style="width:100%; height:480px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

<hr/>

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="ord_grid_wrap" style="width:100%; height:480px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->
</section><!-- search_result end -->

</section><!-- content end -->
<hr />
