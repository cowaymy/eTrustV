<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javascript">

//AUIGrid 그리드 객체
var scheduleClaimBatchGridID;

//Grid에서 선택된 RowID
var selectedGridValue;

//Default Combo Data
var statusData = [{"codeId": "4","codeName": "Completed"},
					{"codeId": "21","codeName": "Failed"}];

var claimTypeData = [{"codeId": "131","codeName": "Credit Card"},
						{"codeId": "132","codeName": "Direct Debit"},
						{"codeId": "134","codeName": "FPX"}];

var issueBankData = [{"codeId": "2","codeName": "Alliance Bank"},
						{"codeId": "3","codeName": "CIMB Bank"},
						{"codeId": "5","codeName": "Hong Leong Bank"},
						{"codeId": "21","codeName": "Maybank"},
						{"codeId": "6","codeName": "Public Bank"},
						{"codeId": "7","codeName": "RHB Bank"},
						{"codeId": "9","codeName": "BSN Bank"}];

var claimDayData = [{"codeId": "5","codeName": "5"},
						{"codeId": "10","codeName": "10"}];


//AUIGrid 칼럼 설정
var scheduleClaimBatchLayout = [  
	{ dataField:"schdulClmId" ,headerText:"Process ID",width: 120, editable : false},
    { dataField:"stusCode" ,headerText:"Status",width: 100,editable : false},
    { dataField:"ctrlId" ,headerText:"Batch ID",width: 120,editable : false},
	{ dataField:"payModeCode", headerText:"Claim Type", width : 100,editable : false },
    { dataField:"bankCode" ,headerText:"Issue Bank",width: 100 , editable : false},
    { dataField:"debtDt" ,headerText:"Debit Date",width: 120 , editable : false , dataType : "date", formatString : "dd-mm-yyyy"},
    { dataField:"clmDay" ,headerText:"Claim Day", width: 100,editable : false},
    { dataField:"schdulClmDt" ,headerText:"Create Date", width: 120, editable : false , dataType : "date", formatString : "dd-mm-yyyy"},
    { dataField:"rem" ,headerText:"Remark", editable : false , dataType : "date", formatString : "dd-mm-yyyy"}
    ];


//Grid Properties 설정 
var gridPros = {            
	editable : false,                // 편집 가능 여부 (기본값 : false)
	showStateColumn : false		     // 상태 칼럼 사용
};

//화면 초기화 함수 (jQuery 의 $(document).ready(function() {}); 과 같은 역할을 합니다.
$(document).ready(function(){    

	scheduleClaimBatchGridID = GridCommon.createAUIGrid("grid_schedule_claim_wrap", scheduleClaimBatchLayout,null,gridPros);
	AUIGrid.resize(scheduleClaimBatchGridID);

	// Master Grid 셀 클릭시 이벤트
    AUIGrid.bind(scheduleClaimBatchGridID, "cellClick", function( event ){ 
        selectedGridValue = event.rowIndex;
    });

	//메인 페이지
	doDefCombo(statusData, '' ,'status', 'M', '');
	doDefCombo(claimTypeData, '' ,'claimType', 'M', '');
	doDefCombo(issueBankData, '' ,'issueBank', 'M', '');
	doDefCombo(claimDayData, '' ,'claimDay', 'M', '');

	f_multiCombo();
   
});

function f_multiCombo() {
	$(function() {
		$('#status').multipleSelect({
			width : '100%'
		}).multipleSelect("setSelects", ['4', '21']);

		$('#claimType').multipleSelect({
			width : '100%'
		}).multipleSelect("setSelects", ['131', '132', '134']);

		$('#issueBank').multipleSelect({
			width : '100%'
		});

		$('#claimDay').multipleSelect({
			width : '100%'
		});

		
	});
}

// 리스트 조회.
function fn_selectListAjax() {     
	
	if(FormUtil.checkReqValue($("#createDt1")) &&
		FormUtil.checkReqValue($("#createDt2"))){
		Common.alert('* Please input Create Date <br />');
		return;
	}

	if((!FormUtil.checkReqValue($("#debitDt1")) && FormUtil.checkReqValue($("#debitDt2"))) ||
		(FormUtil.checkReqValue($("#debitDt1")) && !FormUtil.checkReqValue($("#debitDt2"))) ){
		Common.alert('* Please input Debit Date <br />');
		return;
	}

	if((!FormUtil.checkReqValue($("#createDt1")) && FormUtil.checkReqValue($("#createDt2"))) ||
		(FormUtil.checkReqValue($("#createDt1")) && !FormUtil.checkReqValue($("#createDt2"))) ){
		Common.alert('* Please input Create Date <br />');
		return;
	}


    Common.ajax("GET", "/payment/selectScheduleClaimBatchPop.do", $("#_scheduleClaimSearchPopForm").serialize(), function(result) {
        AUIGrid.setGridData(scheduleClaimBatchGridID, result);
    });
}

// 화면 초기화
function fn_clear(){
	$("#_scheduleClaimSearchPopForm")[0].reset();
	f_multiCombo();
}


//View Claim Pop-UP
function fn_openDivPop(){
	
	var selectedItem = AUIGrid.getSelectedIndex(scheduleClaimBatchGridID);
	
	if (selectedItem[0] > -1){
		
		var ctrlId = AUIGrid.getCellValue(scheduleClaimBatchGridID, selectedGridValue, "ctrlId");

		if(ctrlId > 0){
			Common.ajax("GET", "/payment/selectClaimMasterById.do", {"batchId":ctrlId}, function(result) {
            		$("#view_wrap").show();
                
                    $("#view_batchId").text(result.ctrlId);
                    $("#view_status").text(result.stusName);
                    $("#view_type").text(result.ctrlIsCrcName);
                    $("#view_creator").text(result.crtUserName);
                    $("#view_issueBank").text(result.bankCode + ' - ' + result.bankName);
                    $("#view_createDt").text(result.crtDt);
                    $("#view_totalItem").text(result.ctrlTotItm);
                    $("#view_debitDate").text(result.ctrlBatchDt);
                    $("#view_targetAmount").text(result.ctrlBillAmt);
                    $("#view_updator").text(result.crtUserName);
                    $("#view_receiveAmount").text(result.ctrlBillPayAmt);
                    $("#view_updateDate").text(result.updDt);
                    $("#view_totalSuccess").text(result.ctrlTotSucces);
                    $("#view_totalFail").text(result.ctrlTotFail);
			});  

		}else{
			Common.alert('<b>This process does not has successful claim batch.</b>');
			return;
		}
	}else{
		Common.alert('<b>No process selected.</b>');
		return;
	}	
}


//Layer close
hideViewPopup=function(val){
    $(val).hide();
}

</script>  
<div id="popup_wrap" class="popup_wrap pop_win"><!-- popup_wrap start -->
	<header class="pop_header"><!-- pop_header start -->
		<h1>Schedule Claim Batch</h1>
		<ul class="right_opt">
			<li><p class="btn_blue2"><a href="javascript:fn_selectListAjax();"><span class="search"></span>Search</a></p></li>
			<li><p class="btn_blue2"><a href="javascript:fn_clear();">Clear</a></p></li>
			<li><p class="btn_blue2"><a href="#" onclick="window.close()">CLOSE</a></p></li>
		</ul>
	</header><!-- pop_header end -->

	<section class="pop_body"><!-- pop_body start -->
		<form id="_scheduleClaimSearchPopForm"> <!-- Form Start  -->
			<section class="search_table mt10"><!-- search_table start -->

				<table class="type1"><!-- table start -->
					<caption>table</caption>
					<colgroup>
						<col style="width:140px" />
						<col style="width:*" />
						<col style="width:140px" />
						<col style="width:*" />
					</colgroup>
					<tbody>
						<tr>
							<th scope="row">Status</th>
							<td>
								<select class="multy_select w100p" multiple="multiple" id="status" name="status"></select>
							</td>
							<th scope="row">Claim Type</th>
							<td>
								<select class="multy_select w100p" multiple="multiple" id="claimType" name="claimType"></select>
							</td>
						</tr>
						<tr>
							<th scope="row">Issue Bank</th>
							<td>
								<select class="multy_select w100p" multiple="multiple" id="issueBank" name="issueBank"></select>							
							</td>
							<th scope="row">Claim Day</th>
							<td>
								<select class="multy_select w100p" multiple="multiple" id="claimDay" name="claimDay"></select>														
							</td>
						</tr>
						<tr>
							<th scope="row">Debit Date</th>
							<td>
								<!-- date_set start -->
		                        <div class="date_set w100p">
			                        <p><input id="debitDt1" name="debitDt1" type="text" title="Debit Date From" placeholder="DD/MM/YYYY" class="j_date" readonly /></p>
				                    <span>~</span>
					                <p><input id="debitDt2" name="debitDt2" type="text" title="Debit Date To" placeholder="DD/MM/YYYY" class="j_date" readonly /></p>
						        </div>
							    <!-- date_set end -->
							</td>
							<th scope="row">Create Date</th>
							<td>
								<!-- date_set start -->
		                        <div class="date_set w100p">
			                        <p><input id="createDt1" name="createDt1" type="text" title="Create Date From" placeholder="DD/MM/YYYY" class="j_date" readonly /></p>
				                    <span>~</span>
					                <p><input id="createDt2" name="createDt2" type="text" title="Create Date To" placeholder="DD/MM/YYYY" class="j_date" readonly /></p>
						        </div>
							    <!-- date_set end -->							
							</td>
						</tr>
					</tbody>
				</table><!-- table end -->
			</section>
		</form>		

		 <!-- link_btns_wrap start -->
            <aside class="link_btns_wrap">
                <p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
                <dl class="link_list">
                    <dt>Link</dt>
                    <dd>
                    <ul class="btns">
                        <li><p class="link_btn"><a href="javascript:fn_openDivPop();">View Claim Batch</a></p></li>
                    </ul>
                    <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
                    </dd>
                </dl>
            </aside>
            <!-- link_btns_wrap end -->

		<article id="grid_schedule_claim_wrap" class="grid_wrap"><!-- grid_wrap start -->
		</article><!-- grid_wrap end -->

			
	</section><!-- pop_body end -->
</div><!-- popup_wrap end -->


<!------------------------------------------------------------------------------------- 
    POP-UP (VIEW CLAIM / RESULT (Live) / RESULT (NEXT DAY) / FILE GENERATOR  
-------------------------------------------------------------------------------------->
<!-- popup_wrap start -->
<div class="popup_wrap" id="view_wrap" style="display:none;">
    <!-- pop_header start -->
    <header class="pop_header" id="pop_header2">
        <h1>VIEW CLAIM</h1>
        <ul class="right_opt">
            <li><p class="btn_blue2"><a href="#" onclick="hideViewPopup('#view_wrap')">CLOSE</a></p></li>
        </ul>
    </header>
    <!-- pop_header end -->
    
    <!-- pop_body start -->
    <section class="pop_body">
        <!-- search_table start -->
        <section class="search_table">
            <!-- table start -->
            <table class="type1">
                <caption>table</caption>
                 <colgroup>
	                <col style="width:165px" />
	                <col style="width:*" />
	                <col style="width:165px" />
	                <col style="width:*" />
                </colgroup>
                <tbody>
	                <tr>
	                    <th scope="row">Batch ID</th>
	                    <td id="view_batchId"></td>
	                    <th scope="row">Status</th>
	                    <td id="view_status"></td>
	                </tr>
	                 <tr>
	                    <th scope="row">Type</th>
	                    <td id="view_type"></td>
	                    <th scope="row">Creator</th>
	                    <td id="view_creator"></td>
	                </tr>
	                 <tr>
	                    <th scope="row">Issue Bank</th>
	                    <td id="view_issueBank"></td>
	                    <th scope="row">Create Date</th>
	                    <td id="view_createDt"></td>
	                </tr>
	                <tr>
	                    <th scope="row">Total Item</th>
	                    <td id="view_totalItem"></td>
	                    <th scope="row">Debit Date</th>
	                    <td id="view_debitDate"></td>
	                </tr>
	                <tr>
	                    <th scope="row">Target Amount</th>
	                    <td id="view_targetAmount"></td>
	                    <th scope="row">Updator</th>
	                    <td id="view_updator"></td>
	                </tr>
	                <tr>
	                    <th scope="row">Receive Amount</th>
	                    <td id="view_receiveAmount"></td>
	                    <th scope="row">Update Date</th>
	                    <td id="view_updateDate"></td>
	                </tr>
	                <tr>
	                    <th scope="row">Total Success</th>
	                    <td id="view_totalSuccess"></td>
	                    <th scope="row">Total Fail</th>
	                    <td id="view_totalFail"></td>
	                </tr> 
                </tbody>
            </table>
        </section>
        <!-- search_table end -->
    </section>
    <!-- pop_body end -->
</div>
<!-- popup_wrap end -->