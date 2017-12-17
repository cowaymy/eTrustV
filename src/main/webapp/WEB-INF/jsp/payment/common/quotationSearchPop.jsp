<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javascript">

//AUIGrid 그리드 객체
var quotationSearchPopGridID;

//페이징에 사용될 변수
var _totalRowCount;

//AUIGrid 칼럼 설정
var serviceContractSearchPopLayout = [  
	{ dataField:"quotId" ,headerText:"QuotationId",editable : false, visible : false},
    { dataField:"quotStusId" ,headerText:"Quotation Status Id",editable : false, visible : false },
    { dataField:"ordId" ,headerText:"Order Id",editable : false, visible : false },
	{ dataField:"rnum", headerText:"No.", width : 80,editable : false },
    { dataField:"quotNo" ,headerText:"Quotation No.",width: 130 , editable : false},
    { dataField:"ordNo" ,headerText:"Order No",width: 130 , editable : false },
    { dataField:"cntName" ,headerText:"Customer Name", width: 200,editable : false, visible : false},
    { dataField:"quotStusCode" ,headerText:"Status", width: 90, editable : false },
    { dataField:"validDt" ,headerText:"Valid Date",width: 100 , editable : false , dataType : "date", formatString : "dd-mm-yyyy"},
    { dataField:"pacDesc" ,headerText:"Package",width: 230 , editable : false},
    { dataField:"dur" ,headerText:"Duration" , editable : false },
    { dataField:"crtDt" ,headerText:"Create Date" , editable : false , dataType : "date", formatString : "dd-mm-yyyy"}
    ];
    
//화면 초기화 함수 (jQuery 의 $(document).ready(function() {}); 과 같은 역할을 합니다.
$(document).ready(function(){    
	//Grid Properties 설정 
	var gridPros = {            
		editable : false,                 // 편집 가능 여부 (기본값 : false)
		showStateColumn : false,     // 상태 칼럼 사용
        showRowNumColumn : false,
        usePaging : false
	};

	quotationSearchPopGridID = GridCommon.createAUIGrid("grid_quotationPop_wrap", serviceContractSearchPopLayout,null,gridPros);
	AUIGrid.resize(quotationSearchPopGridID);
    
    // 셀 더블클릭 이벤트 바인딩
    AUIGrid.bind(quotationSearchPopGridID, "cellDoubleClick", function(event) {
    	
    	var quotId = AUIGrid.getCellValue(quotationSearchPopGridID , event.rowIndex , "quotId");
    	var ordId = AUIGrid.getCellValue(quotationSearchPopGridID , event.rowIndex , "ordId");    	
    	var quotNo = AUIGrid.getCellValue(quotationSearchPopGridID , event.rowIndex , "quotNo");
    	var ordNo = AUIGrid.getCellValue(quotationSearchPopGridID , event.rowIndex , "ordNo");
    	
    	if($('#callPrgm').val() == 'MEMBERSHIP_PAYMENT') {
    		fn_callBackQuotInfo(quotId, ordId, quotNo,ordNo);
    	} 
    });
   
});

$(function(){
	$('#btnOrderClear').click(function() {
		$("#_serviceContractForm")[0].reset();
		AUIGrid.clearGridData(quotationSearchPopGridID);
	});
});
	
// 리스트 조회.
function fn_selectListAjax(goPage) {        
	//페이징 변수 세팅
    $("#pageNo").val(goPage);   	

    Common.ajax("GET", "/payment/common/selectCommonQuotationSearchPop.do", $("#_quoSearchPopForm").serialize(), function(result) {
        AUIGrid.setGridData(quotationSearchPopGridID, result.resultList);
        
        //전체건수 세팅
        _totalRowCount = result.totalRowCount;
        
        //페이징 처리를 위한 옵션 설정
        var pagingPros = {
                // 1페이지에서 보여줄 행의 수
                rowCount : $("#rowCount").val(),
			    funcName : 'moveToQuotationPage',
				targetId: "grid_quotationPop_wrap_paging"
        };
        
        GridCommon.createPagingNavigator(goPage, _totalRowCount , pagingPros);        
    });
}



//마스터 그리드 페이지 이동
function moveToQuotationPage(goPage){
  //페이징 변수 세팅
  $("#pageNo").val(goPage);
  
  Common.ajax("GET", "/payment/common/selectCommonQuotationSearchPagingPop.do", $("#_quoSearchPopForm").serialize(), function(result) {        
      AUIGrid.setGridData(quotationSearchPopGridID, result.resultList);
      
      //페이징 처리를 위한 옵션 설정
        var pagingPros = {
                // 1페이지에서 보여줄 행의 수
                rowCount : $("#rowCount").val(),
			    funcName : 'moveToQuotationPage',
				targetId: "grid_quotationPop_wrap_paging"
        };
        
        GridCommon.createPagingNavigator(goPage, _totalRowCount , pagingPros);         
  });    
}

</script>
<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->
	<header class="pop_header"><!-- pop_header start -->
		<h1>OUTRIGHT MEMBERSHIP QUOTATION SEARCH</h1>
		<ul class="right_opt">
			<li><p class="btn_blue2"><a href="#" id="memberPopCloseBtn"><spring:message code='sys.btn.close'/></a></p></li>
		</ul>
	</header><!-- pop_header end -->
	
	<section class="pop_body"><!-- pop_body start -->
		<form id="_quoSearchPopForm"> <!-- Form Start  -->
			<input id="callPrgm" name="callPrgm" value="${callPrgm}" type="hidden" />
			<input type="hidden" name="rowCount" id="rowCount" value="20" />
            <input type="hidden" name="pageNo" id="pageNo" />
			<input type="hidden" name="status" id="status" value="81" /> <!-- 상태가 Converted 된 데이터만 조회한다. 왜냐면 그래야 bill 정보가 있을테니-->
			<section class="search_table"><!-- search_table start -->
				<table class="type1"><!-- table start -->
					<caption>table</caption>
					<colgroup>
						<col style="width:150px" />
						<col style="width:*" />
						<col style="width:150px" />
						<col style="width:*" />
					</colgroup>
					<tbody>
						<tr>
							<th scope="row">Quotation No</th>
							<td><input type="text" title="" placeholder="Quotation Number" class="w100p" id="quoNo" name="quoNo" /></td>
							<th scope="row">Create Date</th>
							<td>
								<!-- date_set start -->
								<div class="date_set w100p">
								<p><input type="text" id="createDateFr" name="createDateFr" title="Create Start Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
								<span>To</span>
								<p><input type="text" id="createDateTo" name="createDateTo" title="Create End Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
								</div>
								<!-- date_set end -->
							</td>
						</tr>
						<tr>
							<th scope="row">Order No.</th>
							<td><input type="text" title="" placeholder="Order Number" class="w100p" id="ordNo" name="ordNo"/></td>
							<th scope="row">Creator</th>
							<td><input type="text" title="" placeholder="Creator (User Name)" class="w100p" id="creator" name="creator" /></td>
						</tr>
					</tbody>
				</table><!-- table end -->
			</section><!-- search_table end -->
		</form>
		
		<ul class="right_btns">
			<li><p class="btn_blue2 big"><a href="javascript:fn_selectListAjax(1);"><span class="search"></span><spring:message code='sys.btn.search'/></a></p></li>
			<li><p class="btn_blue2 big"><a href="#" id="btnOrderClear"><spring:message code='sys.btn.clear'/></a></p></li>
		</ul>

		<article id="grid_quotationPop_wrap" class="grid_wrap"><!-- grid_wrap start -->
		</article><!-- grid_wrap end -->
		<div id="grid_quotationPop_wrap_paging" class="aui-grid-paging-panel my-grid-paging-panel"></div>
	</section><!-- pop_body end -->
</div><!-- popup_wrap end -->