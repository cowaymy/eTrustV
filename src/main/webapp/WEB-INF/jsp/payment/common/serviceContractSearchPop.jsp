<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javascript">

//AUIGrid 그리드 객체
var serviceContractSearchPopGridID;

//Default Combo Data
var SRVContractStatusData = [{"codeId": "ACT","codeName": "Active"},
                       {"codeId": "REG","codeName": "Regular"},
                       {"codeId": "INV","codeName": "Investigate"},
                       {"codeId": "SUS","codeName": "Suspend"},
                       {"codeId": "TER","codeName": "Terminate"}
                       ];

//AUIGrid 칼럼 설정
var serviceContractSearchPopLayout = [   
    { dataField:"srvCntrctRefNo" ,headerText:"<spring:message code='pay.head.scsNo'/>",width: 150 , editable : false},
    { dataField:"cntrctRentalStus" ,headerText:"<spring:message code='pay.head.rentStatus'/>",width: 150 , editable : false },
    { dataField:"srvCntrctPacDesc" ,headerText:"<spring:message code='pay.head.package'/>", width: 200,editable : false},
    { dataField:"code" ,headerText:"<spring:message code='pay.head.status'/>", width: 100, editable : false },
    { dataField:"salesOrdNo" ,headerText:"<spring:message code='pay.head.orderNo'/>",width: 100 , editable : false},
    { dataField:"name" ,headerText:"<spring:message code='pay.head.customerName'/>",width: 230 , editable : false},
    { dataField:"srvCntrctId" ,headerText:"" , visible : false },
    { dataField:"salesOrdId" ,headerText:"" , visible : false },
    { dataField:"custBillId" ,headerText:"<spring:message code='pay.head.custBillId'/>" , visible : false }
    ];
    
//화면 초기화 함수 (jQuery 의 $(document).ready(function() {}); 과 같은 역할을 합니다.
$(document).ready(function(){    
    //메인 페이지
    doDefCombo(SRVContractStatusData, '' ,'contractStatusType', 'M', 'f_multiCombo');
    
    //Grid Properties 설정 
    var gridPros = {            
            editable : false,                 // 편집 가능 여부 (기본값 : false)
            showStateColumn : false     // 상태 칼럼 사용
    };
    
    serviceContractSearchPopGridID = GridCommon.createAUIGrid("grid_serviceContractPop_wrap", serviceContractSearchPopLayout,null,gridPros);
    AUIGrid.resize(serviceContractSearchPopGridID);
    
    // 셀 더블클릭 이벤트 바인딩
    AUIGrid.bind(serviceContractSearchPopGridID, "cellDoubleClick", function(event) {
    	
    	var srvCntrctId = AUIGrid.getCellValue(serviceContractSearchPopGridID , event.rowIndex , "srvCntrctId");
    	var salesOrdId = AUIGrid.getCellValue(serviceContractSearchPopGridID , event.rowIndex , "salesOrdId");    	
    	var srvCntrctRefNo = AUIGrid.getCellValue(serviceContractSearchPopGridID , event.rowIndex , "srvCntrctRefNo");
    	var custBillId = AUIGrid.getCellValue(serviceContractSearchPopGridID , event.rowIndex , "custBillId");
    	
    	if($('#callPrgm').val() == 'MEMBERSHIP_PAYMENT') {
    		fn_callBackSrvcOrderInfo(srvCntrctId, salesOrdId, srvCntrctRefNo,custBillId);
    	} else{
        	fn_callOrderData(srvCntrctId, salesOrdId);
        	fn_createEvent('memberPopCloseBtn', 'click');
        }
    });
   
});

	$(function(){
	    $('#btnOrderSearch').click(function() {
	        fn_selectListAjax();
	    });
	    
	    $('#btnOrderClear').click(function() {
	    	$("#_serviceContractForm")[0].reset();
	    	AUIGrid.clearGridData(serviceContractSearchPopGridID);
        });
	});
	
	// 리스트 조회.
	function fn_selectListAjax() {        
		Common.ajax("GET", "/payment/common/selectCommonContractSearchPop.do", $("#_serviceContractForm ").serialize(), function(result) {
			console.log(result);
	        AUIGrid.setGridData(serviceContractSearchPopGridID, result);
	    });
	}
	
	function f_multiCombo() {
        $(function() {
            $('#contractStatusType').multipleSelect({
                width : '100%'
            }).multipleSelect("setSelects", ['ACT', 'REG', 'INV', 'SUS']);
        });
    }

</script>
<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->
	<header class="pop_header"><!-- pop_header start -->
		<h1>RENTAL MEMBERSHIP SEARCH</h1>
		<ul class="right_opt">
		    <li><p class="btn_blue2"><a href="#" id="memberPopCloseBtn"><spring:message code='sys.btn.close'/></a></p></li>
		</ul>
	</header><!-- pop_header end -->
	<section class="pop_body"><!-- pop_body start -->
		<form id="_serviceContractForm"> <!-- Form Start  -->
			<input id="callPrgm" name="callPrgm" value="${callPrgm}" type="hidden" />
			<section class="search_table"><!-- search_table start -->
				<table class="type1"><!-- table start -->
					<caption>table</caption>
					<colgroup>
					    <col style="width:150px" />
					    <col style="width:*" />
					    <col style="width:150px" />
					    <col style="width:*" />
					    <col style="width:150px" />
					    <col style="width:*" />
					</colgroup>
					<tbody>
						<tr>
						    <th scope="row">Membership No.</th>
						    <td><input type="text" title="" placeholder="Membership No." class="w100p" id="contractRefNo" name="contractRefNo" /></td>
						    <th scope="row">Invoice No.</th>
						    <td><input type="text" title="" placeholder="Invoice No." class="w100p" id="invoiceNo" name="invoiceNo"/></td>
						    <th scope="row">Sales Date</th>
						    <td><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p" id="salesDate" name="salesDate"/></td>
						</tr>
						<tr>
						    <th scope="row">SRV Contract Status</th>
						    <td>
							    <select class="multy_select w100p" multiple="multiple" id="contractStatusType" name="contractStatusType">
							    </select>
						    </td>
						    <th scope="row">Order No.</th>
						    <td><input type="text" title="" placeholder="Order No." class="w100p" id="orderNo" name="orderNo"/></td>
						    <th scope="row"></th>
						    <td></td>
						</tr>
						<tr>
						    <th scope="row">Customer ID</th>
						    <td><input type="text" title="" placeholder="Customer ID (Numberic)" class="w100p" id="custId" name="custId" /></td>
						    <th scope="row">Customer Name</th>
						    <td><input type="text" title="" placeholder="Customer Name" class="w100p" id="custName" name="custName"/></td>
						    <th scope="row">NRIC/Company No.</th>
						    <td><input type="text" title="" placeholder="NRIC/Company No." class="w100p" id="custNric" name="custNric"/></td>
						</tr>
					</tbody>
				</table><!-- table end -->
			</section><!-- search_table end -->
		</form>
		<ul class="right_btns">
		    <li><p class="btn_blue2 big"><a href="#" id="btnOrderSearch"><spring:message code='sys.btn.search'/></a></p></li>
		    <li><p class="btn_blue2 big"><a href="#" id="btnOrderClear"><spring:message code='sys.btn.clear'/></a></p></li>
		</ul>
		<article id="grid_serviceContractPop_wrap" class="grid_wrap"><!-- grid_wrap start -->
		</article><!-- grid_wrap end -->
	</section><!-- pop_body end -->
</div><!-- popup_wrap end -->