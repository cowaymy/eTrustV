<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<style type="text/css">
.my-custom-up{
    text-align: left;
}
</style>
<script type="text/javaScript">

var advKeyInGridId;
var bankStmtGridId;

var selectedGridValue;

var gridPros2 = {
	editable : false,				// 편집 가능 여부 (기본값 : false)
	showRowCheckColumn : true,		// 체크박스 표시 설정
	rowCheckToRadio : true,			// 체크박스 대신 라디오버튼 출력함
	softRemoveRowMode:false,
    headerHeight : 35,				// 기본 헤더 높이 지정
	showStateColumn : false			// 상태 칼럼 사용
};



var gridPros1 = {
    editable : false,               // 편집 가능 여부 (기본값 : false)
    showRowCheckColumn : true,      // 체크박스 표시 설정
    rowCheckToCheck : true,         // 체크박스 대신 라디오버튼 출력함
    softRemoveRowMode:false,
    headerHeight : 35,              // 기본 헤더 높이 지정
    showStateColumn : false         // 상태 칼럼 사용
};

var advKeyInLayout = [
	{dataField : "groupSeq",headerText : "<spring:message code='pay.head.paymentGroupNo'/>",width : 90 , editable : false},
	{dataField : "payItmModeNm",headerText : "<spring:message code='pay.head.paymentMode'/>",width : 90 , editable : false},
	{dataField : "payItmRefDt",headerText : "<spring:message code='pay.head.transactionDate'/>",width : 100 , editable : false},
	{dataField : "payItmBankAccNm",headerText : "<spring:message code='pay.head.bankAccount'/>",editable : false},
	{dataField : "payItmBankInSlipNo",headerText : "<spring:message code='pay.head.slipNo'/>",width : 120 , editable : false},
	{dataField : "refDtl",headerText : "<spring:message code='pay.head.refDetailsJompayRef'/>",width : 120 , editable : false},
	{dataField : "totAmt",headerText : "<spring:message code='pay.head.amount'/>",width : 100 , editable : false, dataType:"numeric", formatString : "###0.00" },
	{dataField : "bankChgAmt",headerText : "<spring:message code='pay.head.bankCharge'/>",width : 100 , editable : false, dataType:"numeric", formatString : "###0.00" }
];

var bankStmtLayout = [
    {dataField : "bankId",headerText : "<spring:message code='pay.head.bankId'/>",editable : false, visible : false},
    {dataField : "bankAcc",headerText : "<spring:message code='pay.head.bankAccountCode'/>", editable : false, visible : false},
    {dataField : "count",headerText : "", editable : false, visible : false},
    {dataField : "fTrnscId",headerText : "<spring:message code='pay.head.tranxId'/>", editable : false},
    {dataField : "bankName",headerText : "<spring:message code='pay.head.bank'/>", editable : false},
    {dataField : "bankAccName",headerText : "<spring:message code='pay.head.bankAccount'/>",editable : false},
    {dataField : "fTrnscDt",headerText : "<spring:message code='pay.head.dateTime'/>", editable : false, dataType:"date",formatString:"dd/mm/yyyy"},
    {dataField : "fTrnscTellerId",headerText : "<spring:message code='pay.head.refCheqNo'/>", editable : false},
    {dataField : "fTrnscRef3",headerText : "<spring:message code='pay.head.description1'/>",editable : false},
    {dataField : "fTrnscRefChqNo",headerText : "<spring:message code='pay.head.description2'/>", editable : false},
    {dataField : "fTrnscRef1",headerText : "<spring:message code='pay.head.ref5'/>", editable : false},
    {dataField : "fTrnscRef2",headerText : "<spring:message code='pay.head.ref6'/>", editable : false},
    {dataField : "fTrnscRef6",headerText : "<spring:message code='pay.head.ref7'/>", editable : false},
    {dataField : "fTrnscRem",headerText : "<spring:message code='pay.head.type'/>", editable : false},
    {dataField : "fTrnscDebtAmt",headerText : "<spring:message code='pay.head.debit'/>", editable : false, dataType:"numeric", formatString:"#,##0.00"},
    {dataField : "fTrnscCrditAmt",headerText : "<spring:message code='pay.head.credit'/>", editable : false, dataType:"numeric", formatString:"#,##0.00"},
    {dataField : "fTrnscRef4",headerText : "<spring:message code='pay.head.depositSlipNoEftMid'/>", editable : false},
    {dataField : "fTrnscNewChqNo",headerText : "<spring:message code='pay.head.chqNo'/>", editable : false},
    {dataField : "fTrnscRefVaNo",headerText : "<spring:message code='pay.head.vaNumber'/>", editable : false}
];


$(document).ready(function(){

	//CASH Bank Account combo box setting
	doGetCombo('/common/getAccountList.do', 'CASH','', 'bankAcc', 'S', '' );
	doGetCombo('/common/selectCodeList.do', '393' , ''   , 'accCode' , 'S', '');

	//Branch Combo 생성
	doGetComboSepa('/common/selectBranchCodeList.do', '1' , ' - ' , '','branchId', 'S' , '');

    advKeyInGridId = GridCommon.createAUIGrid("adv_keyin_grid_wrap", advKeyInLayout,"",gridPros1);
    bankStmtGridId = GridCommon.createAUIGrid("bank_stmt_grid_wrap", bankStmtLayout,"",gridPros2);

	// 셀 더블클릭 이벤트 바인딩 : 상세 팝업
	AUIGrid.bind(advKeyInGridId, "cellDoubleClick", function(event) {

		var groupSeq = AUIGrid.getCellValue(advKeyInGridId , event.rowIndex , "groupSeq");
		Common.popupDiv('/payment/initDetailGrpPaymentPop.do', {"groupSeq" : groupSeq}, null , true ,'_viewDtlGrpPaymentPop');

	});

});

function fn_payTypeChange(){
	var payType = $("#payType").val();

	if(payType == '105'){
		doGetCombo('/common/getAccountList.do', 'CASH','', 'bankAcc', 'S', '' );
	}else if(payType == '106'){
		doGetCombo('/common/getAccountList.do', 'CHQ','', 'bankAcc', 'S', '' );
	}else if(payType == '108'){
		doGetCombo('/common/getAccountList.do', 'ONLINE','', 'bankAcc', 'S', '' );
	}
}

function fn_bankChange(){

	var bankType = $("#bankType").val();

	$("#vaAccount").val('');
	$("#bankAcc").val('');

	if(bankType != "2730"){
		$("#vaAccount").addClass("readonly");
		$("#vaAccount").attr('readonly', true);
		$("#bankAcc").attr('disabled', false);
		$("#bankAcc").removeClass("disabled");
	}else{
		$("#vaAccount").removeClass("readonly");
		$("#vaAccount").attr('readonly', false);
		$("#bankAcc").attr('disabled', true);
		$("#bankAcc").addClass("w100p disabled");
	}

}

//조회버튼 클릭시 처리
function fn_searchAdvMatchList(){

	if(FormUtil.checkReqValue($("#transDateFr")) ||
		FormUtil.checkReqValue($("#transDateTo"))){
		Common.alert("<spring:message code='pay.alert.inputTransactionDate'/>");
		return;
	}

	Common.ajax("POST","/payment/selectPaymentMatchList.do", $("#searchForm").serializeJSON(), function(result){

		AUIGrid.setGridData(advKeyInGridId, result.keyInList);
		AUIGrid.setGridData(bankStmtGridId, result.stateList);
	});
}

function fn_clear(){
	$("#searchForm")[0].reset();
}


function fn_mapping(){
	var advKeyInItems = AUIGrid.getCheckedRowItems(advKeyInGridId);
	var bankStmtItem = AUIGrid.getCheckedRowItems(bankStmtGridId);
	var keyInRowItem;
	var stateRowItem;
	var keyInAmount = 0;
	var stmtAmount =0;
	var groupSeq =0;
	var fTrnscId =0;

	if( advKeyInItems.length < 1 || bankStmtItem.length < 1){
		Common.alert("<spring:message code='pay.alert.keyInListCheck'/>");
		return;
	}else{

		keyInRowItem = advKeyInItems[0];
		stateRowItem = bankStmtItem[0];

		keyInAmount = Number(keyInRowItem.item.totAmt) - Number(keyInRowItem.item.bankChgAmt);
		keyInAmount = $.number(keyInAmount,2,'.','');

		stmtAmount = Number(stateRowItem.item.fTrnscCrditAmt);
		stmtAmount = $.number(stmtAmount,2,'.','');

		groupSeq = keyInRowItem.item.groupSeq;
		fTrnscId = stateRowItem.item.fTrnscId;

		if(keyInAmount != stmtAmount){
           	Common.alert("<spring:message code='pay.alert.transAmtNotSame'/>",
				function (){

					$("#journal_entry_wrap").show();
					$("#groupSeq").val(groupSeq);
					$("#fTrnscId").val(fTrnscId);
					$("#preKeyInAmt").val(keyInAmount);
					$("#bankStmtAmt").val(stmtAmount);
					//$("#variance").val(keyInAmount-stmtAmount);
					$("#variance").val($.number(keyInAmount-stmtAmount,2,'.',''));
					$("#accCode").val('');
					$("#remark").val('');
				}
			);
		} else {
			$("#groupSeq").val(groupSeq);
			$("#fTrnscId").val(fTrnscId);
			$("#preKeyInAmt").val(keyInAmount);
			$("#bankStmtAmt").val(stmtAmount);
			//$("#variance").val(keyInAmount-stmtAmount);
			$("#variance").val($.number(keyInAmount-stmtAmount,2,'.',''));
			$("#accCode").val('');
			$("#remark").val('');

			fn_saveMapping('N');
		}
	}
}

function fn_saveMapping(withPop){
	//Journal Entry 팝업을 띄웠을때만 validation check를 한다.
	if(withPop == 'Y'){
		if(FormUtil.checkReqValue($("#accCode option:selected"))){
			Common.alert("<spring:message code='pay.alert.accountCode'/>");
			return;
		}

		if(FormUtil.checkReqValue($("#remark"))){
			Common.alert("<spring:message code='pay.alert.inputRemark'/>");
			return;
		}

		if( FormUtil.byteLength($("#remark").val()) > 3000 ){
			Common.alert("<spring:message code='pay.alert.inputRemark3000Char'/>");
    		return;
	    }
	}

	Common.confirm("<spring:message code='pay.alert.wantToSave'/>",function (){
	    Common.ajax("POST", "/payment/saveAdvPaymentMapping.do", $("#entryForm").serializeJSON(), function(result) {
			var message = "<spring:message code='pay.alert.mappingSuccess'/>";

    		Common.alert(message, function(){
				fn_searchAdvMatchList();
				$("#journal_entry_wrap").hide();
    		});
	    });
	});
}

//Reverse 처리하기
function fn_requestDCFPop(){
	var advKeyInItems = AUIGrid.getCheckedRowItems(advKeyInGridId);
	var keyInRowItem;
	var groupSeq =0;

	if( advKeyInItems.length < 1){
		Common.alert("<spring:message code='pay.alert.checkKeyInList'/>");
		return;
	}else{

		keyInRowItem = advKeyInItems[0];
		groupSeq = keyInRowItem.item.groupSeq;

		Common.alert("<spring:message code='pay.alert.transAmtNotSame'/>",
			function (){
				Common.popupDiv('/payment/initReqDCFWithAppvPop.do', {"groupSeq" : groupSeq}, null , true ,'_requestDCFWithAppvPop');
			}
		);
	}
}

function fn_saveReverse(){
    if(FormUtil.checkReqValue($("#revReason option:selected"))){
        Common.alert("<spring:message code='pay.alert.NoReasonSelected'/>");
        return;
    }

	if( FormUtil.byteLength($("#revRemark").val()) > 3000 ){
    	Common.alert("<spring:message code='pay.alert.inputRemark3000Char'/>");
    	return;
    }

	//저장처리
	Common.confirm("<spring:message code='pay.alert.wantToReverse'/>",function (){
	    Common.ajax("POST", "/payment/requestDCFWithAppv.do", $("#reverseForm").serializeJSON(), function(result) {


			var message = "<spring:message code='pay.alert.successReverse' arguments='"+result.returnKey+"' htmlEscape='false'/>";

    		Common.alert(message, function(){
				fn_searchAdvMatchList();
				$("#reverse_wrap").hide();
    		});
	    });
	});
}


function fn_debtor(){
	var advKeyInItems = AUIGrid.getCheckedRowItems(advKeyInGridId);
	var keyInRowItem;
	var keyInAmount = 0;
	var groupSeq =0;

	if( advKeyInItems.length < 1){
		Common.alert("<spring:message code='pay.alert.checkKeyInList'/>");
		return;
	}else{
		keyInRowItem = advKeyInItems[0];
		keyInAmount = Number(keyInRowItem.item.totAmt) + Number(keyInRowItem.item.bankChgAmt);
		groupSeq = keyInRowItem.item.groupSeq;

		Common.alert("<spring:message code='pay.alert.bankStatementMissing'/>",
			function (){
				$("#debtor_wrap").show();
				$("#debtorGroupSeq").val(groupSeq);
				$("#debtorRemark").val('');
			}
		);
	}
}

function fn_saveDebtor(){

	if(FormUtil.checkReqValue($("#debtorRemark"))){
		Common.alert("<spring:message code='pay.alert.inputRemark'/>");
		return;
	}

	if( FormUtil.byteLength($("#debtorRemark").val()) > 3000 ){
		Common.alert("<spring:message code='pay.alert.inputRemark3000Char'/>");
		return;
	}


	Common.confirm("<spring:message code='pay.alert.wantToSave'/>",function (){
	    Common.ajax("POST", "/payment/saveAdvPaymentDebtor.do", $("#debtorForm").serializeJSON(), function(result) {
			var message = "<spring:message code='pay.alert.mappingSuccess'/>";

    		Common.alert(message, function(){
				fn_searchAdvMatchList();
				$("#debtor_wrap").hide();
    		});
	    });
	});
}


</script>
<section id="content"><!-- content start -->
    <ul class="path">
        <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    </ul>

    <aside class="title_line"><!-- title_line start -->
        <p class="fav"><a href="#" class="click_add_on"><spring:message code='pay.text.myMenu'/></a></p>
        <h2>Advance Payment Matching</h2>
        <ul class="right_btns">
            <li><p class="btn_blue"><a href="javascript:fn_searchAdvMatchList();"><span class="search"></span><spring:message code='sys.btn.search'/></a></p></li>
            <li><p class="btn_blue"><a href="javascript:fn_clear();"><span class="clear"></span><spring:message code='sys.btn.clear'/></a></p></li>
        </ul>
    </aside><!-- title_line end -->

    <section class="search_table"><!-- search_table start -->
        <form action="#" method="post" id="searchForm">
            <table class="type1"><!-- table start -->
                <caption>table</caption>
                <colgroup>
                    <col style="width:200px" />
                    <col style="width:*" />
                    <col style="width:200px" />
                    <col style="width:*" />
                </colgroup>
                <tbody>
                    <tr>
                        <th scope="row">Transaction Date</th>
                        <td>
                            <!-- date_set start -->
                            <div class="date_set w100p">
                            <p><input type="text" id="transDateFr" name="transDateFr" title="Transaction Start Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
                            <span>To</span>
                            <p><input type="text" id="transDateTo" name="transDateTo" title="Transaction End Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
                            </div>
                            <!-- date_set end -->
                        </td>
                            <th scope="row">KeyIn Branch</th>
                        <td>
                            <select id="branchId" name="branchId"  class="w100p"></select>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Payment Type</th>
                        <td>
                            <select id="payType" name="payType" class="w100p"  onchange="javascript:fn_payTypeChange();">
                                <option value="105">Cash</option>
                                <option value="106">Cheque</option>
                                <option value="108">Online</option>
                            </select>
                        </td>
                        <th scope="row">Bank Type</th>
                        <td>
                            <select id="bankType" name="bankType"  class="w100p" onchange="javascript:fn_bankChange();">
                                <option value="2728">JomPay</option>
                                <option value="2729">MBB CDM</option>
                                <option value="2730">VA</option>
                                <option value="2731">Others</option>
                            </select>
                       </td>
                    </tr>
                    <tr>
                        <th scope="row">Bank Account</th>
                        <td>
                            <select id="bankAcc" name="bankAcc"  class="w100p"></select>
                        </td>
                        <th scope="row">VA Account</th>
                        <td>
                            <input type="text" id="vaAccount" name="vaAccount"  class="w100p readonly" readonly="readonly" />
                        </td>
                    </tr>
                    <tr>
                        <th scope="row"></th>
                        <td></td>
                        <th scope="row">Amount</th>
                        <td>
                            <input type="text" id="bnkCrAmt" name="bnkCrAmt"  class="w100p" />
                        </td>
                    </tr>
                </tbody>
            </table><!-- table end -->
        </form>
    </section><!-- search_table end -->

    <!-- link_btns_wrap start -->
    <aside class="link_btns_wrap">
        <p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
        <dl class="link_list">
            <dt>Link</dt>
            <dd>
                <ul class="btns">
                    <li><p class="link_btn"><a href="javascript:fn_requestDCFPop();"><spring:message code='pay.btn.reverse'/></a></p></li>
                    <li><p class="link_btn"><a href="javascript:fn_debtor();"><spring:message code='pay.btn.debtor'/></a></p></li>
                    <li><p class="link_btn"><a href="javascript:fn_mapping();"><spring:message code='pay.btn.match'/></a></p></li>
                </ul>
                <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
            </dd>
        </dl>
    </aside>
    <!-- link_btns_wrap end -->

    <div class="divine_auto"><!-- divine_auto start -->
        <div style="width:50%;">
            <aside class="title_line"><!-- title_line start -->
                <h3>Advance Key-in List</h3>
            </aside><!-- title_line end -->
            <article id="adv_keyin_grid_wrap" class="grid_wrap"></article>
        </div><!-- border_box end -->
        <div style="width:50%;">
            <aside class="title_line"><!-- title_line start -->
                <h3>Bank Statement</h3>
            </aside><!-- title_line end -->
            <article id="bank_stmt_grid_wrap" class="grid_wrap"></article>
        </div>
    </div>
</section><!-- content end -->

<!---------------------------------------------------------------
    POP-UP (JOURNAL ENTRY)
---------------------------------------------------------------->
<!-- popup_wrap start -->
<div class="popup_wrap" id="journal_entry_wrap" style="display:none;">
    <!-- pop_header start -->
    <header class="pop_header" id="pop_header">
        <h1>JOURNAL ENTRY</h1>
        <ul class="right_opt">
            <li><p class="btn_blue2"><a href="#" onclick="hideViewPopup('#journal_entry_wrap')"><spring:message code='sys.btn.close'/></a></p></li>
        </ul>
    </header>
    <!-- pop_header end -->

    <!-- pop_body start -->
    <form name="entryForm" id="entryForm"  method="post">
	<input type="hidden" id="groupSeq" name="groupSeq" />
	<input type="hidden" id="fTrnscId" name="fTrnscId" />
    <section class="pop_body">
        <!-- search_table start -->
        <section class="search_table">
            <!-- table start -->
            <table class="type1">
                <caption>table</caption>
                 <colgroup>
                    <col style="width:200px" />
                    <col style="width:*" />
                </colgroup>

                <tbody>
                    <tr>
                        <th scope="row">Pre Key In Amount (A)</th>
                        <td>
							<input id="preKeyInAmt" name="preKeyInAmt" type="text" class="readonly" readonly />
                        </td>
                    </tr>
					<tr>
                        <th scope="row">Bank Statement Amount (B)</th>
                        <td>
							<input id="bankStmtAmt" name="bankStmtAmt" type="text" class="readonly" readonly />
                        </td>
                    </tr>
					<tr>
                        <th scope="row">Variance (Variance = A - B)</th>
                        <td>
							<input id="variance" name="variance" type="text" class="readonly" readonly />
                        </td>
                    </tr>
					<tr>
                        <th scope="row">Account Code</th>
                        <td>
                            <select id="accCode" name="accCode" class="w100p"></select>
                        </td>
                    </tr>
					<tr>
                        <th scope="row">Remark</th>
                        <td>
							<textarea id="remark" name="remark"  cols="10" rows="3" placeholder=""></textarea>
                        </td>
                    </tr>
                   </tbody>
            </table>
        </section>
        <ul class="center_btns" >
            <li><p class="btn_blue2"><a href="javascript:fn_saveMapping('Y');"><spring:message code='sys.btn.save'/></a></p></li>
        </ul>
    </section>
    </form>
    <!-- pop_body end -->
</div>
<!-- popup_wrap end -->


<!---------------------------------------------------------------
    POP-UP (Other Debtor With Ticket)
---------------------------------------------------------------->
<!-- popup_wrap start -->
<div class="popup_wrap" id="debtor_wrap" style="display:none;">
    <!-- pop_header start -->
    <header class="pop_header" id="pop_header">
        <h1>Other Debtor with Ticket</h1>
        <ul class="right_opt">
            <li><p class="btn_blue2"><a href="#" onclick="hideViewPopup('#debtor_wrapp')"><spring:message code='sys.btn.close'/></a></p></li>
        </ul>
    </header>
    <!-- pop_header end -->

    <!-- pop_body start -->
    <form name="debtorForm" id="debtorForm"  method="post">
	<input type="hidden" id="debtorGroupSeq" name="debtorGroupSeq" />
    <section class="pop_body">
        <!-- search_table start -->
        <section class="search_table">
            <!-- table start -->
            <table class="type1">
                <caption>table</caption>
                 <colgroup>
                    <col style="width:200px" />
                    <col style="width:*" />
                </colgroup>

                <tbody>
                    <tr>
                        <th scope="row">Remark</th>
                        <td>
							             <textarea id="debtorRemark" name="debtorRemark"  cols="10" rows="3" placeholder=""></textarea>
                        </td>
                    </tr>
                   </tbody>
            </table>
        </section>
        <ul class="center_btns" >
            <li><p class="btn_blue2"><a href="javascript:fn_saveDebtor();"><spring:message code='sys.btn.save'/></a></p></li>
        </ul>
    </section>
    </form>
    <!-- pop_body end -->
</div>
<!-- popup_wrap end -->