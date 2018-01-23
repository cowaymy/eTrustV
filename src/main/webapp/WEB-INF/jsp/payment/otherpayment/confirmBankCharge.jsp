<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<style type="text/css">
.my-custom-up{
    text-align: left;
}
</style>
<script type="text/javaScript">

var bankStmtGridId;
var selectedGridValue;

var gridPros = {
	editable : false,				// 편집 가능 여부 (기본값 : false)
	showRowCheckColumn : true,		// 체크박스 표시 설정
	softRemoveRowMode:false,
	headerHeight : 35,				// 기본 헤더 높이 지정
	showStateColumn : false			// 상태 칼럼 사용
};


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
	{dataField : "fTrnscRefVaNo",headerText : "<spring:message code='pay.head.vaNumber'/>", editable : false},
	{dataField : "count",headerText : "", editable : false, visible : false},
	{dataField : "accCode",headerText : "", editable : false, visible : false}
	];


$(document).ready(function(){
    
	//CASH Bank Account combo box setting
	doGetCombo('/common/getAccountList.do', 'CASH','', 'bankAccount', 'S', '' );
    
	bankStmtGridId = GridCommon.createAUIGrid("bank_stmt_grid_wrap", bankStmtLayout,"",gridPros);
    
});

//조회버튼 클릭시 처리    
function fn_searchBankChgMatchList(){

	if(FormUtil.checkReqValue($("#transDateFr")) ||
		FormUtil.checkReqValue($("#transDateTo"))){
		Common.alert("<spring:message code='pay.alert.inputTransDate'/>");
		return;
	}

	Common.ajax("POST","/payment/selectBankChgMatchList.do", $("#searchForm").serializeJSON(), function(result){

		console.log(result);
		AUIGrid.setGridData(bankStmtGridId, result.stateList);
	});
}
    
function fn_clear(){
	$("#searchForm")[0].reset();
}


function fn_mapping(){	
	var bankStmtItem = AUIGrid.getCheckedRowItemsAll(bankStmtGridId);
	var stateRowItem;
	var keyInAmount = 0;
	var stmtAmount =0;
	var groupSeq =0;
	var fTrnscId =0;
	var data = {};

	if(bankStmtItem.length < 1){
		Common.alert("<spring:message code='Please check Bank Statement List'/>");
		return;
	}else{
		
		//stateRowItem = bankStmtItem[0];
		//stmtAmount = Number(stateRowItem.item.fTrnscCrditAmt);
		//fTrnscId = stateRowItem.item.fTrnscId;
		
		if(bankStmtItem.length > 0)
			data.all = bankStmtItem;
		
		Common.confirm("<spring:message code='pay.alert.wantToSave'/>",function (){
		      
			Common.ajax("POST", "/payment/saveBankChgMapping.do", data, function(result) {
				
				var message = "<spring:message code='pay.alert.mappingSuccess'/>";
				Common.alert(message, function(){
					fn_searchBankChgMatchList();
					//$("#journal_entry_wrap").hide();                    
				});        
			});
		});
	}
}

/* function fn_saveMapping(){

	Common.confirm("<spring:message code='pay.alert.wantToSave'/>",function (){
	    Common.ajax("POST", "/payment/saveBankChgMapping.do", $("#entryForm").serializeJSON(), function(result) {
			var message = "<spring:message code='pay.alert.mappingSuccess'/>";

    		Common.alert(message, function(){
				fn_searchBankChgMatchList();
				$("#journal_entry_wrap").hide();                    
    		});        
	    });
	});
} */



</script>
<section id="content"><!-- content start -->
    <ul class="path">
        <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    </ul>
    
    <aside class="title_line"><!-- title_line start -->
        <p class="fav"><a href="#" class="click_add_on"><spring:message code='pay.text.myMenu'/></a></p>
        <h2>Confirm Bank Charge</h2>
        <ul class="right_btns">
            <li><p class="btn_blue"><a href="javascript:fn_mapping();"><spring:message code='pay.btn.mapping'/></a></p></li>
            <li><p class="btn_blue"><a href="javascript:fn_searchBankChgMatchList();"><span class="search"></span><spring:message code='sys.btn.search'/></a></p></li>
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
                            <p><input type="text" id="transDateFr" name="tranDateFr" title="Transaction Start Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
                            <span>To</span>
                            <p><input type="text" id="transDateTo" name="tranDateTo" title="Transaction End Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
                            </div>
                            <!-- date_set end -->
                        </td>
						            <th scope="row">Upload By</th>
                        <td><input type="text" id="uploadUserNm" name="uploadUserNm" title="" placeholder="Upload User Name" class="w100p" /></td>
                    </tr>
					          <tr>
                        <th scope="row">Bank Account</th>
                        <td>  
                            <select id="bankAccount" name="bankAccount" class="w100p">                                                               
                            </select>
                        </td>
                        <th scope="row">Upload Date</th>
                        <td>
                            <!-- date_set start -->
                            <div class="date_set w100p">
                            <p><input type="text" id="uploadDateFr" name="uploadDateFr" title="Upload Start Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
                            <span>To</span>
                            <p><input type="text" id="uploadDateTo" name="uploadDateTo" title="Upload End Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
                            </div>
                            <!-- date_set end -->
                        </td>
					         </tr>
                </tbody>
            </table><!-- table end -->
        </form> 
    </section><!-- search_table end -->

    <div class="divine_auto"><!-- divine_auto start -->
        <div style="width:100%;">
            <!-- <aside class="title_line">title_line start
                <h3>Bank Statement</h3>
            </aside>title_line end -->
            <article id="bank_stmt_grid_wrap" class="grid_wrap"></article>
        </div>
    </div>
</section><!-- content end -->	

<!--------------------------------------------------------------- 
    POP-UP (JOURNAL ENTRY)
---------------------------------------------------------------->
<!-- popup_wrap start -->
<%-- <div class="popup_wrap" id="journal_entry_wrap" style="display:none;">
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
</div> --%>
<!-- popup_wrap end -->