<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javascript">

//AUIGrid 그리드 객체
var scheduleClaimBatchGridID;

//Grid에서 선택된 RowID
var selectedGridValue;

//Default Combo Data
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

//AUIGrid 칼럼 설정
var scheduleClaimBatchLayout = [  
	{ dataField:"schdulId" ,headerText:"Schedule ID",width: 120, editable : false},
    { dataField:"schdulDt" ,headerText:"Schedule Date",width: 120,editable : false, dataType : "date", formatString : "dd/mm/yyyy"},
    { dataField:"codeName" ,headerText:"Claim Type",width: 120,editable : false},
	{ dataField:"bankName", headerText:"Issue Bank", width : 200,editable : false },
	{ dataField:"debtDt" ,headerText:"Debit Date",width: 120 , editable : false , dataType : "date", formatString : "dd/mm/yyyy"},
	{ dataField:"clmDay" ,headerText:"Claim Day", width: 100,editable : false},
    { dataField:"crtUserName" ,headerText:"Creator",width: 100 , editable : false},
    { dataField:"crtDt" ,headerText:"Create Date",width: 120 , editable : false , dataType : "date", formatString : "dd/mm/yyyy"}
    ];


//Grid Properties 설정 
var gridPros = {            
	editable : false,                // 편집 가능 여부 (기본값 : false)
	showStateColumn : false		     // 상태 칼럼 사용
};

//화면 초기화 함수 (jQuery 의 $(document).ready(function() {}); 과 같은 역할을 합니다.
$(document).ready(function(){    

	// 현재 년월 세팅하기
	var curDate = new Date();
	$("#batchMonth").val((curDate.getMonth() +1) +"/" + curDate.getFullYear());

	scheduleClaimBatchGridID = GridCommon.createAUIGrid("grid_schedule_setting_wrap", scheduleClaimBatchLayout,null,gridPros);
	AUIGrid.resize(scheduleClaimBatchGridID);

	// Master Grid 셀 클릭시 이벤트
    AUIGrid.bind(scheduleClaimBatchGridID, "cellClick", function( event ){ 
        selectedGridValue = event.rowIndex;
    });

	//메인 페이지
	doDefCombo(claimTypeData, '' ,'claimType', 'S', '');
	doDefCombo(issueBankData, '' ,'issueBank', 'S', '');

	doDefCombo(claimTypeData, '' ,'new_claimType', 'S', '');
	doDefCombo(issueBankData, '' ,'new_issueBank', 'S', '');
   
});

// 리스트 조회.
function fn_selectListAjax() {     
	
	if(FormUtil.checkReqValue($("#batchMonth"))){
		Common.alert('* Please input Batch Month <br />');
		return;
	}

	if(FormUtil.checkReqValue($("#claimType  option:selected"))){
		Common.alert('* Please select Claim Type <br />');
		return;
	}

    Common.ajax("GET", "/payment/selectScheduleClaimSettingPop.do", $("#_scheduleClaimSearchPopForm").serialize(), function(result) {
        AUIGrid.setGridData(scheduleClaimBatchGridID, result);
    });
}

// 화면 초기화
function fn_clear(){
	$("#_scheduleClaimSearchPopForm")[0].reset();
}


//New Claim Schedule Pop-UP
function fn_openNewDivPop(){
	$("#new_wrap").show();
}

//Layer close
hideViewPopup=function(val){
    $(val).hide();
}

//등록 팝업에서 스케쥴 일자가 등록되면 다른 입력항목을 초기화한다.
function setScheduleDt(){
	$("#new_claimType").val('');
	$("#new_claimDay").val('');
	$("#new_issueBank").val('');
	$("#new_debitDt").val('');
	$("#new_issueBank").prop('disabled', true);
}

//등록 팝업에서 Claim Type 수정시
function chgClaimType(){
	if( $("#new_scheduleDt").val() == ''){
		Common.alert("<b>Please select the schedule date first.</b>");
		setScheduleDt();

	}else{
		var claimType = $("#new_claimType").val();

		$("#new_issueBank").val('');
		$("#new_claimDay").val('');
		$("#new_debitDt").val('');
		$("#new_issueBank").prop('disabled', true);

		if(claimType == '131' || claimType == '134'){
			
			var schDate =  new Date( $("#new_scheduleDt").datepicker("getDate"));

			if(schDate.getDate() > 9 ){
				$("#new_claimDay").val('10');
			}else{
				$("#new_claimDay").val('5');
			}

			$("#new_debitDt").val(FormUtil.lpad((schDate.getDate()),2,"0") + "/" + FormUtil.lpad((schDate.getMonth()+1),2,"0") + "/" + schDate.getFullYear());
		}else{
            $("#new_issueBank").prop('disabled', false);
		}
	}
}

//등록 팝업에서 Issue Bank Type 수정시
function chgIssueBank(){
	var issueBankType = $("#new_issueBank").val();
	var schDate =  new Date( $("#new_scheduleDt").datepicker("getDate"));

	if(issueBankType == '2' || issueBankType == '21' || issueBankType == '7' || issueBankType == '9'){
		//선택된 날짜에서 + 1 day
		schDate.setDate(schDate.getDate() + 1 );
	}
	
	$("#new_debitDt").val(FormUtil.lpad((schDate.getDate()),2,"0") + "/" + FormUtil.lpad((schDate.getMonth()+1),2,"0") + "/" + schDate.getFullYear());
}

//등록 팝업에서 저장처리
function fn_saveSchedule(){

	if( $("#new_scheduleDt").val() == ''){
		Common.alert("<b>Please select the schedule date </b>");
		return;
	}else{
		var schDate =  new Date( $("#new_scheduleDt").datepicker("getDate"));
		var today = new Date();

		if (schDate <= today){
			Common.alert("<b>Schedule date must be future date.</b>");
			return;
		}
	}

	var claimType = $("#new_claimType").val();

	if( claimType == ''){
		Common.alert("<b>Please select the claim type </b>");
		return;
	}
	
	if(claimType == '131' || claimType == '134'){
		if($("#new_claimDay").val() == ''){
			Common.alert("<b>Please select the claim day </b>");
			return;
		}	
	}else{
		if($("#new_issueBank").val() == ''){
			Common.alert("<b>Please select the issued bank </b>");
			return;
		}	
	}

	if( $("#new_debitDt").val() == ''){
		Common.alert("<b>Please select the debit date </b>");
		return;
	}

	//저장처리
	Common.ajax("GET", "/payment/isScheduleClaimSettingPop.do", $("#_newScheduleForm").serialize(), function(result) {
		if(result > 0 ){
			Common.alert("<b>This schedule date is exist.</b>");
			return;

		} else{
			Common.ajax("GET", "/payment/saveScheduleClaimSettingPop.do", $("#_newScheduleForm").serialize(), function(result) {
				Common.alert("<b>New claim schedule saved.</b>");
			});
		}
    });
}



//Delete Schedule
function fn_deleteSchedule(){
	
	var selectedItem = AUIGrid.getSelectedIndex(scheduleClaimBatchGridID);
	
	if (selectedItem[0] > -1){
		
		var schdulId = AUIGrid.getCellValue(scheduleClaimBatchGridID, selectedGridValue, "schdulId");
		var schdulDt = AUIGrid.getCellValue(scheduleClaimBatchGridID, selectedGridValue, "schdulDt");

		var schDate =  new Date( schdulDt);
		var today = new Date();
		
		if (schDate <= today){
			Common.alert("<b>Unable to delete this schedule due to this is past schedule.</b>");
			return;
		}else{
			Common.confirm("<b/>Are you want to delete this schedule ?</b>",
					function (){
			            Common.ajax("GET", "/payment/removeScheduleClaimSettingPop.do", { "schdulId" : schdulId }, function(result) {
							Common.alert("<b>Schedule has been deleted.</b>");
							fn_selectListAjax();
					});
	        });
		}
	}else{
		Common.alert('<b>No batch selected.</b>');
		return;
	}	
}

</script>  
<div id="popup_wrap" class="popup_wrap pop_win"><!-- popup_wrap start -->
	<header class="pop_header"><!-- pop_header start -->
		<h1>Claim Schedule</h1>
		<ul class="right_opt">
			<li><p class="btn_blue2"><a href="javascript:fn_selectListAjax();"><span class="search"></span><spring:message code='sys.btn.search'/></a></p></li>
			<li><p class="btn_blue2"><a href="javascript:fn_clear();"><spring:message code='sys.btn.clear'/></a></p></li>
			<li><p class="btn_blue2"><a href="#" onclick="window.close()"><spring:message code='sys.btn.close'/></a></p></li>
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
							<th scope="row">Batch Month</th>
							<td>
								<input type="text" id="batchMonth" name="batchMonth" title="Batch Month" class="j_date2 w100p" />
							</td>
							<th scope="row"></th>
							<td></td>
						</tr>
						<tr>
							<th scope="row">Claim Type</th>
							<td>
								<select class="w100p" id="claimType" name="claimType"></select>														
							</td>
							<th scope="row">Issue Bank</th>
							<td>
								<select class="w100p" id="issueBank" name="issueBank" ></select>							
							</td>							
						</tr>
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
                        <li><p class="link_btn"><a href="javascript:fn_deleteSchedule();"><spring:message code='pay.btn.link.deleteSchedule'/></a></p></li>
                    </ul>
                    <ul class="btns">
                        <li><p class="link_btn type2"><a href="javascript:fn_openNewDivPop();"><spring:message code='pay.btn.link.newSchedule'/></a></p></li>
                    </ul>
                    <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
                    </dd>
                </dl>
            </aside>
            <!-- link_btns_wrap end -->

		<article id="grid_schedule_setting_wrap" class="grid_wrap"><!-- grid_wrap start -->
		</article><!-- grid_wrap end -->

			
	</section><!-- pop_body end -->
</div><!-- popup_wrap end -->


<!------------------------------------------------------------------------------------- 
    POP-UP (NEW CLAIM SCHEDULE)  
-------------------------------------------------------------------------------------->
<!-- popup_wrap start -->
<div class="popup_wrap" id="new_wrap" style="display:none;">
    <!-- pop_header start -->
    <header class="pop_header" id="pop_header2">
        <h1>NEW CLAIM SCHEDULE</h1>
        <ul class="right_opt">
            <li><p class="btn_blue2"><a href="#" onclick="hideViewPopup('#new_wrap')"><spring:message code='sys.btn.close'/></a></p></li>
        </ul>
    </header>
    <!-- pop_header end -->
    
    <!-- pop_body start -->
    <section class="pop_body">
        <!-- search_table start -->
        <section class="search_table">
			<form id="_newScheduleForm"> <!-- Form Start  -->
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
							<th scope="row">Schedule Date</th>
							<td>
								<input id="new_scheduleDt" name="new_scheduleDt" type="text" title="" placeholder="DD/MM/YYYY" class="j_date" readonly onchange="javascript:setScheduleDt();"/>
							</td>
							<th scope="row"></th>
							<td></td>
						</tr>
						 <tr>
							<th scope="row">Claim Type</th>
							<td>
								<select class="w100p" id="new_claimType" name="new_claimType" onchange="javascript:chgClaimType();"></select>		
							</td>
							<th scope="row">Claim Day</th>
							<td>
								<input id="new_claimDay" name="new_claimDay" type="text" title="" placeholder="" class="readonly w100p" readonly />
							</td>
						</tr>
						 <tr>
							<th scope="row">Issue Bank</th>
							<td>
								<select class="w100p" id="new_issueBank" name="new_issueBank" disabled="disabled"  onchange="javascript:chgIssueBank();"></select>							
							</td>
							<th scope="row">Debit Date</th>
							<td>
								<input id="new_debitDt" name="new_debitDt" type="text" title="" placeholder="" class="readonly w100p" readonly />
							</td>
						</tr>
					</tbody>
				</table>
			</form>
        </section>
        <!-- search_table end -->
		
		<ul class="center_btns" id="center_btns1">
            <li><p class="btn_blue2"><a href="javascript:fn_saveSchedule();"><spring:message code='pay.btn.saveSchedule'/></a></p></li>
        </ul>

    </section>
    <!-- pop_body end -->
</div>
<!-- popup_wrap end -->