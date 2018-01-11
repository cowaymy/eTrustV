<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<script type="text/javaScript">

//AUIGrid 그리드 객체
var viewHistoryGridID_V;
var payItemId = '${payItemId}';

//Grid Properties 설정 
var gridPros = {            
        editable : false,                 // 편집 가능 여부 (기본값 : false)
        showStateColumn : false     // 상태 칼럼 사용
};

// 화면 초기화 함수 (jQuery 의 $(document).ready(function() {}); 과 같은 역할을 합니다.
$(document).ready(function(){
	
	//IssuedBank 생성
  doGetCombo('/common/getIssuedBankList.do', '' , ''   , 'sIssuedBankCh' , 'S', '');
  doGetCombo('/common/getIssuedBankList.do', '' , ''   , 'cmbIssuedBankCC' , 'S', '');
  doGetCombo('/common/getIssuedBankList.do', '' , ''   , 'cmbIssuedBankOn' , 'S', '');
	
  //CreditCardType 생성
  doGetCombo('/common/selectCodeList.do', '21' , ''   ,'cmbCreditCardTypeCC', 'S' , '');
  
	showViewDetailHistory(payItemId);

});


function showViewDetailHistory(payItemId){
	
	  var defaultDate = new Date("01-01-1900");    
    Common.ajax("GET", "/payment/selectPaymentItem", {"payItemId" : payItemId}, function(result) {

      if(reconLock == 1){
        $("#txtRunNoCa").attr("readonly", true);
        $("#txtRunNoCh").attr("readonly", true);
        $("#txtRunningNoCC").attr("readonly", true);
        $("#txtRunNoOn").attr("readonly", true);
      }
      
      var payMode = result[0].payItmModeId;
      if(payMode == 105){ //cash
        $("#item_edit_cash").show();
        $("#payItemId").val(payItemId);    
        
        $("#paymentCa").text(result[0].codeName);
            $("#amountCa").text(result[0].payItmAmt);
            $("#bankAccCa").text(result[0].accId + result[0].accDesc);
            $("#txtReferenceNoCa").val(result[0].payItmRefNo);
            var refDate = new Date(result[0].payItmRefDt)
            if((refDate.getTime() > defaultDate.getTime()))
              $("#txtRefDateCa").val(refDate.getDate() + "/" + (refDate.getMonth()+1) + "/" + refDate.getFullYear());
            $("#txtRunNoCa").val(result[0].payItmRunngNo);
            $("#tareaRemarkCa").val(result[0].payItmRem);
      }else if(payMode == 106){//cheque
        $("#item_edit_cheque").show();
      
        $("#payItemIdCh").val(payItemId);  
        
        $("#paymentCh").text(result[0].codeName);
        $("#amountCh").text(result[0].payItmAmt);
        $("#bankAccCh").text(result[0].accId + result[0].accDesc);
        
        $("#sIssuedBankCh").val(result[0].payItmIssuBankId);
        $("#chequeNumberCh").text(result[0].payItmChqNo);
        $("#chequeNoCh").val(result[0].payItmChqNo);//parameter
        $("#txtRefNumberCh").val(result[0].payItmRefNo);
        var refDate = new Date(result[0].payItmRefDt);
        if((refDate.getTime() > defaultDate.getTime())){
          $("#txtRefDateCh").val(refDate.getDate() + "/" + (refDate.getMonth()+1) + "/" + refDate.getFullYear());
       }
        $("#txtRunNoCh").val(result[0].payItmRunngNo);
        $("#tareaRemarkCh").val(result[0].payItmRem);
     }else if(payMode == 107){//creditcard
         $("#payItemIdCC").val(payItemId);
     
         $("#item_edit_credit").show();
         
         $("#paymentCC").text(result[0].codeName);
         $("#amountCC").text(result[0].payItmAmt);
             $("#bankAccCC").text(result[0].accId + result[0].accDesc);
             
             $("#cmbIssuedBankCC").val(result[0].payItmIssuBankId);
             $("#CCNo").text(result[0].payItmOriCcNo);
             $("#txtCrcNo").val(result[0].payItmOriCcNo);
             $("#txtCCHolderName").val(result[0].payItmCcHolderName);
             
             var exDt =  result[0].payItmCcExprDt;
             var exMonth = 0;
             var exYear = 0;
             var exDate = new Date();
             if(exDt != undefined){
               var expiryDate = exDt.split('/');
               exMonth = expiryDate[0];
               exYear = expiryDate[1];
               
               if(exYear >= 90){
                 exYear = 1900 + Number(exYear);
               }else{
                 exYear = 2000 + Number(exYear);
               }
               
               exDate.setFullYear(exYear);
               exDate.setMonth(exMonth);
               exDate.setDate("01");
               
               var exMonthStr = exDate.getMonth() < 10 ? "0" + exDate.getMonth() : exDate.getMonth();
               
                 if((exDate > defaultDate))
                     $("#txtCCExpiry").val("01" + "/" + (exMonthStr) + "/" + exDate.getFullYear());
                 else
                     $("#txtCCExpiry").val("");
             }
             
             if(result[0].payItmCardTypeId > 0)
               $("#cmbCardTypeCC").val(result[0].payItmCardTypeId).prop("selected", true);
             
             $("#cmbCreditCardTypeCC").val(result[0].payItmCcTypeId).prop("selected", true);
             if(result[0].isOnline == 'On')
               $("#creditCardModeCC").text('Online');
             else
               $("#creditCardModeCC").text('Offline');
             $("#approvalNumberCC").text(result[0].payItmAppvNo);
             $("#txtRefNoCC").val(result[0].payItmRefNo);
             var refDt = new Date(result[0].payItmRefDt);
             if(refDt > defaultDate){
               var tmpMonth = refDt.getMonth() < 10 ? "0" + (refDt.getMonth()+1) : (refDt.getMonth() + 1);
               var tmpDate = refDt.getDate() < 10 ? "0" + (refDt.getDate()+1) : (refDt.getDate() + 1);
               $("#txtRefDateCC").val(refDt.getDate() + "/" + tmpMonth + "/" + refDt.getFullYear());
             }
             $("#txtRunningNoCC").val(result[0].payItmRunngNo);
             $("#tareaRemarkCC").val(result[0].payItmRem);
      }else if(payMode == 108){//online
        $("#item_edit_online").show();
      
        $("#payItemIdOn").val(payItemId);
        
              $("#paymentOn").text(result[0].codeName);
              $("#amountOn").text(result[0].payItmAmt);
              $("#bankAccOn").text(result[0].accId + result[0].accDesc);
              
              $("#cmbIssuedBankOn").val(result[0].payItmIssuBankId);
              $("#txtRefNoOn").val(result[0].payItmRefNo);
              
              var refDate = new Date(result[0].payItmRefDt);
              if((refDate.getTime() > defaultDate.getTime())){
                  $("#txtRefDateOn").val(refDate.getDate() + "/" + (refDate.getMonth()+1) + "/" + refDate.getFullYear());
              }
              
              $("#txtEFTNoOn").val(result[0].payItmEftNo);
              $("#txtRunNoOn").val(result[0].payItmRunngNo);
              $("#tareaRemarkOn").val(result[0].payItmRem);
      }
    });
}

function saveCash(){
	   Common.ajax("GET", "/payment/saveCash", $("#cashForm").serialize(), function(result) {
	     //Common.setMsg(result.message);  
	     Common.alert(result.message);
	   });
	}

	function saveCreditCard(){
	  Common.ajax("GET", "/payment/saveCreditCard", $("#creditCardForm").serialize(), function(result) {
	    Common.alert(result.message);
	    });
	}

	function saveCheque(){
	  Common.ajax("GET", "/payment/saveCheque", $("#ChequeForm").serialize(), function(result) {
	    console.log("chequeNoCh : " + $("#chequeNoCh").val());
	    Common.alert(result.message);
	    });
	}

	function saveOnline(){
	    Common.ajax("GET", "/payment/saveOnline", $("#OnlineForm").serialize(), function(result) {
	      Common.alert(result.message);
	    });
	}

</script>

<div id="item_edit_cheque" class="popup_wrap size_small" style="display:none;">
    <header class="pop_header">
        <h1><spring:message code='pay.title.payItmEdit'/></h1>
        <ul class="right_opt">
            <li><p class="btn_blue2"><a href="#" onclick=""><spring:message code='sys.btn.close'/></a></p></li>
        </ul>
    </header>
    <!-- pop_body start -->
    <section class="pop_body">
    <form id="ChequeForm" name="ChequeForm">
    <table class="type1">
        <colgroup>
            <col style="width:165px" />
            <col style="width:*" />
        </colgroup>
        <tbody>
        <tr>
            <th>Payment Mode</th>
            <td id="paymentCh"></td>
        </tr>
        <tr>
            <th>Amount</th>
            <td id="amountCh"></td>
        </tr>
        <tr>
            <th>Bank Account</th>
            <td id="bankAccCh"></td>
        </tr>
        <tr>
            <th>Issued Bank</th>
            <td id="issuedBankCh">
                <p><select id="sIssuedBankCh" name="sIssuedBankCh"></select></p>
            </td>
        </tr>
        <tr>
            <th>Cheque Number</th>
            <td id="chequeNumberCh"></td>
        </tr>
        <tr>
            <th>Reference Number</th>
            <td id="referenceNumberCh">
                <p><input type="text" name="txtRefNumberCh" id="txtRefNumberCh" placeholder="Reference Number" /></p>
            </td>
        </tr>
        <tr>
            <th>Reference Date</th>
            <td id="refDateCh">
                 <p><input type="text"  name="txtRefDateCh" id="txtRefDateCh" title="Create Date From" placeholder="DD/MM/YYYY" class="j_date" /></p>
            </td>
        </tr>
        <tr>
            <th>Running No</th>
            <td id="runningNoCh">
                <p><input type="text" name="txtRunNoCh" id="txtRunNoCh" placeholder="runningNo"/></p>
            </td>
        </tr>
        <tr>
            <th>Remark</th>
            <td id="r">
                <p><textarea id="tareaRemarkCh" name="tareaRemarkCh"></textarea></p>
            </td>
        </tr>
        <tr>
            <td colspan="2"> 
                <ul class="center_btns">
                   <li><p class="btn_blue2"><a href="#" onclick="saveCheque()"><spring:message code='sys.btn.save'/></a></p></li>
                 </ul>
             </td>
        </tr>
        </tbody>
    </table>
    <input type="hidden" id="payItemIdCh" name="payItemIdCh"/>
    <input type="hidden" id="chequeNoCh" name="chequeNoCh" />
    </form>
    </section>
    <!-- pop_body end -->
</div>
<!-- content end -->

<div id="item_edit_cash" class="popup_wrap size_small" style="display:none;">
    <header class="pop_header">
        <h1><spring:message code='pay.title.payItmEdit'/></h1>
        <ul class="right_opt">
            <li><p class="btn_blue2"><a href="#" onclick=""><spring:message code='sys.btn.close'/></a></p></li>
        </ul>
    </header>
    <!-- pop_body start -->
    <section class="pop_body">
    <form id="cashForm" name="payDetail">
    <table class="type1">
        <colgroup>
            <col style="width:165px" />
            <col style="width:*" />
        </colgroup>
        <tbody>
        <tr>
            <th>Payment Mode</th>
            <td id="paymentCa"></td>
        </tr>
        <tr>
            <th>Amount</th>
            <td id="amountCa"></td>
        </tr>
        <tr>
            <th>Bank Account</th>
            <td id="bankAccCa"></td>
        </tr>
        <tr>
            <th>Reference No</th>
            <td id="referenceNoCa">
                <p><input type="text" name="txtReferenceNoCa" id="txtReferenceNoCa" placeholder="Reference No" /></p>
            </td>
        </tr>
        <tr>
            <th>Reference Date</th>
            <td id="referenceDateCa">
                 <p><input type="text"  name="txtRefDateCa" id="txtRefDateCa" title="Create Date From" placeholder="DD/MM/YYYY" class="j_date" /></p>
            </td>
        </tr>
        <tr>
            <th>Running No</th>
            <td id="runningNoCa">
                <p><input type="text" name="txtRunNoCa" id="txtRunNoCa" placeholder="runningNo"/></p>
            </td>
        </tr>
        <tr>
            <th>Remark</th>
            <td id="r">
                <p><textarea id="tareaRemarkCa" name="tareaRemarkCa"></textarea></p>
            </td>
        </tr>
        <tr>
            <td colspan="2"> 
              <ul class="center_btns">
                 <li><p class="btn_blue2"><a href="#" onclick="saveCash()"><spring:message code='sys.btn.save'/></a></p></li>
               </ul>
             </td>
        </tr>
        </tbody>
    </table>
    <input type="hidden" id="payItemId" name="payItemId"/>    
    </form>
    </section>
    <!-- pop_body end -->
</div>
<!-- content end -->

<div id="item_edit_credit" class="popup_wrap size_small" style="display:none;">
    <header class="pop_header">
        <h1><spring:message code='pay.title.payItmEdit'/></h1>
        <ul class="right_opt">
            <li><p class="btn_blue2"><a href="#" onclick=""><spring:message code='sys.btn.close'/></a></p></li>
        </ul>
    </header>
    <!-- pop_body start -->
    <section class="pop_body">
    <form id="creditCardForm" name="creditCardForm">
    <input type="hidden" id="payItemIdCC" name="payItemIdCC"/>
    <input type="hidden" id="txtCrcNo" name="txtCrcNo" />
    <table class="type1">
        <colgroup>
            <col style="width:165px" />
            <col style="width:*" />
        </colgroup>
        <tbody>
        <tr>
            <th>Payment Mode</th>
            <td id="paymentCC"></td>
        </tr>
        <tr>
            <th>Amount</th>
            <td id="amountCC"></td>
        </tr>
        <tr>
            <th>Bank Account</th>
            <td id="bankAccCC"></td>
        </tr>
        <tr>
            <th>Issued Bank</th>
            <td id="issuedBankCC">
                <select id="cmbIssuedBankCC" name="cmbIssuedBankCC" class="w100p"></select>
            </td>
        </tr>
        <tr>
            <th>Credit Card No</th>
            <td id="CCNo"></td>
        </tr>
        <tr>
            <th>Credit Card Holder</th>
            <td id="cCHolder">
                <p><input type="text" name="txtCCHolderName" id="txtCCHolderName" placeholder="Credit Card Holder Name" /></p>
            </td>
        </tr>
        <tr>
            <th>Credit Card Expiry</th>
            <td id="ccExpiry">
                <p><input type="text"  name="txtCCExpiry" id="txtCCExpiry"  placeholder="DD/MM/YYYY" class="j_date" /></p>
            </td>
        </tr>
        <tr>
            <th>Card Type</th>
            <td id="cardTypeCC">
                <select id="cmbCardTypeCC" name="cmbCardTypeCC" class="w100p">
                    <option value="1241">Credit Card</option>
                    <option value="1240">Debit Card</option>
                </select>
            </td>
        </tr>
        <tr>
            <th>Credit Card Type</th>
            <td id="creditCardTypeCC">
                <select id="cmbCreditCardTypeCC" name="cmbCreditCardTypeCC" class="w100p"></select>
            </td>
        </tr>
        <tr>
            <th>Credit Card Mode</th>
            <td id="creditCardModeCC"></td>
        </tr>
        <tr>
            <th>Approval Number</th>
            <td id="approvalNumberCC"></td>
        </tr>
        <tr>
            <th>Reference No</th>
            <td id="referenceNoCC">
                <p><input type="text" name="txtRefNoCC" id="txtRefNoCC" /></p>
            </td>
        </tr>
        <tr>
            <th>Reference Date</th>
            <td id="referenceDateCC">
                <p><input type="text" name="txtRefDateCC" id="txtRefDateCC" placeholder="DD/MM/YYYY" class="j_date"/></p>
            </td>
        </tr>
        <tr>
            <th>Running No</th>
            <td id="runningNoCC">
                <p><input type="text" name="txtRunningNoCC" id="txtRunningNoCC" placeholder="Running Number"/></p>
            </td>
        </tr>
        <tr>
            <th>Remark</th>
            <td id="remarkCC">
                <p><textarea id="tareaRemarkCC" name="tareaRemarkCC"></textarea></p>
            </td>
        </tr>
        <tr>
            <td colspan="2"> 
                <ul class="center_btns">
                   <li><p class="btn_blue2"><a href="#" onclick="saveCreditCard()"><spring:message code='sys.btn.save'/></a></p></li>
                 </ul>
             </td>
        </tr>
        </tbody>
    </table>

    </form>
    </section>
    <!-- pop_body end -->
</div>
<!-- content end -->

<!-- content end -->
<div id="item_edit_online" class="popup_wrap size_small" style="display:none;">
    <header class="pop_header">
        <h1><spring:message code='pay.title.payItmEdit'/></h1>
        <ul class="right_opt">
            <li><p class="btn_blue2"><a href="#" onclick=""><spring:message code='sys.btn.close'/></a></p></li>
        </ul>
    </header>
    <!-- pop_body start -->
    <section class="pop_body">
    <form id="OnlineForm" name="OnlineForm">
    <table class="type1">
        <colgroup>
            <col style="width:165px" />
            <col style="width:*" />
        </colgroup>
        <tbody>
        <tr>
            <th>Payment Mode</th>
            <td id="paymentOn"></td>
        </tr>
        <tr>
            <th>Amount</th>
            <td id="amountOn"></td>
        </tr>
        <tr>
            <th>Bank Account</th>
            <td id="bankAccOn"></td>
        </tr>
        <tr>
            <th>Issued Bank</th>
            <td id="issuedBankOn">
                <p><select id="cmbIssuedBankOn" name="cmbIssuedBankOn"></select></p>
            </td>
        </tr>
        <tr>
            <th>Reference No</th>
            <td id="referenceNoOn">
                <p><input type="text" name="txtRefNoOn" id="txtRefNoOn" placeholder="Reference Number" /></p>
            </td>
        </tr>
        <tr>
            <th>Reference Date</th>
            <td id="refDateCh">
                 <p><input type="text"  name="txtRefDateOn" id="txtRefDateOn" title="Create Date From" placeholder="DD/MM/YYYY" class="j_date" /></p>
            </td>
        </tr>
        <tr>
            <th>EFT No</th>
            <td id="runningNoCh">
                <p><input type="text" name="txtEFTNoOn" id="txtEFTNoOn" /></p>
            </td>
        </tr>
        <tr>
            <th>Running No</th>
            <td id="runningNoCh">
                <p><input type="text" name="txtRunNoOn" id="txtRunNoOn" placeholder="runningNo"/></p>
            </td>
        </tr>
        <tr>
            <th>Remark</th>
            <td id="r">
                <p><textarea id="tareaRemarkOn" name="tareaRemarkOn"></textarea></p>
            </td>
        </tr>
        <tr>
            <td colspan="2"> 
                <ul class="center_btns">
                   <li><p class="btn_blue2"><a href="#" onclick="saveOnline()"><spring:message code='sys.btn.save'/></a></p></li>
                 </ul>
             </td>
        </tr>
        </tbody>
    </table>
    <input type="hidden" id="payItemIdOn" name="payItemIdOn"/>    
    </form>
    </section>
    <!-- pop_body end -->
</div>
