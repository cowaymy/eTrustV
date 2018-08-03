<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">


var selCodeAccBankId = $("#accBank").val();

doGetCombo('/common/selectCodeList.do', '20', '','_insCmbBankType', 'S' , '');                              // Add Bank Type Combo Box
doGetCombo('/sales/customer/selectAccBank.do', '', selCodeAccBankId, '_insCmbAccBank', 'S', '') //Issue Bank)


    function fn_addBankAccount(){
        var accType = document.insAccountForm.bankType.value;
 //       var accBank = document.insAccountForm.cmbAccBank.value;
        var accBank = $("#_insCmbAccBank").val();
        var accNo = document.insAccountForm.accNo.value;
        var bankBranch = document.insAccountForm.accBankBranch.value;
        var accOwner = document.insAccountForm.accName.value;
        var accRem = document.insAccountForm.accRemark.value;

        if(accType == ''){
            Common.alert("<spring:message code='sal.alert.msg.pleaseSelectTheAccType' />");
            return false;
        }
        if(accBank == ''){
            Common.alert("<spring:message code='sal.alert.msg.pleaseSelectTheIssueBank' />");
            return false;
        }
        if(accNo == ''){
            Common.alert("<spring:message code='sal.alert.msg.pleaseKeyInTheBankAccNum' />");
            return false;
        }else{
            //number check
            if(FormUtil.checkNum($("#_insAccNo"))){
                Common.alert("<spring:message code='sys.common.alert.validation' arguments='Account Number'/>");
                return false;
            }

            var lengResult = true; // true/false
            var availableResult = false; // true/false

            // 2. Account No Validation
            /* length validation  */
            lengResult = fn_lengthCheck(accBank, accNo);
            if(lengResult == false){
                Common.alert("* <spring:message code='sal.alert.msg.invalidBankAccNum' />");
                return false;
            }

            /* availability validation */
            availableResult = fn_availabilityCheck(accBank, accNo);
            if(availableResult == true){
                Common.alert("* <spring:message code='sal.alert.msg.invalidBankAccNum' />");
                return false;
            }
        }
        if(accOwner == ''){
            Common.alert("<spring:message code='sal.alert.msg.pleaseKeyBankAccOwnName' />");
            return false;
        }

        //insert
        //fn_addBankAccountInfo(accType,accBank,accNo,bankBranch,accOwner,accRem);
        fn_doSaveBankAcc();
        //close
        $("#_bankInsCloseBtn").click();
    }

    /* ########## length Check Start ##########*/
    function fn_lengthCheck(bankId, AccNo){

        var valid = true; //result
        var lengthOfAccNo = AccNo.length;

        //MAYBANK
        if(bankId == 21 || bankId == 30){
            if(lengthOfAccNo != 12){
                valid = false;
                return valid;
            }
        }
        //CIMB BANK
        if(bankId == 3 || bankId == 36){

            if(lengthOfAccNo != 14 && lengthOfAccNo != 10){
                valid = false;
                return valid;
            }
        }
        //PUBLIC BANK
        if(bankId == 6 || bankId == 32){
            if(lengthOfAccNo != 10){
                valid = false;
                return valid;
            }
        }
        //RHB BANK
        if(bankId == 7 || bankId == 33){
            if(lengthOfAccNo != 14){
                valid = false;
                return valid;
            }
        }
        //ALLIANCE BANK
        if(bankId == 2 || bankId == 35){
            if(lengthOfAccNo != 15){
                valid = false;
                return valid;
            }
        }
        //HONG LEONG BANK
        if(bankId == 5 || bankId == 29){
            if(lengthOfAccNo != 11){
                valid = false;
                return valid;
            }
        }
        //BANK SIMPANAN NASIONAL
        if(bankId == 9 || bankId ==26){
            if(lengthOfAccNo != 16){
                valid = false;
                return valid;
            }
        }
        //MY CLEAR - BANK RAKYAT
        if(bankId == 25){
            if(lengthOfAccNo != 12){
                valid = false;
                return valid;
            }
        }
        //MY CLEAR - BANK ISLAM
        if(bankId == 10){
            if(lengthOfAccNo != 14){
                valid = false;
                return valid;
            }
        }
        //MY CLEAR - HSBC
        if(bankId == 17){
            if(lengthOfAccNo != 12){
                valid = false;
                return valid;
            }
        }
        //MY CLEAR - OCBC
        if(bankId == 18){
            if(lengthOfAccNo != 10){
                valid = false;
                return valid;
            }
        }
        //MY CLEAR - STANDARD CHARTED
        if(bankId == 19 || bankId == 34){
            if(lengthOfAccNo < 5 || lengthOfAccNo > 17){
                valid = false;
                return valid;
            }
        }
        //MY CLEAR - CITIBANK
        if(bankId == 16){
            if(lengthOfAccNo < 9 || lengthOfAccNo > 16){
                valid = false;
                return valid;
            }
        }
        //MY CLEAR - DEUTCHE BANK
        if(bankId == 27){
            if(lengthOfAccNo < 10 || lengthOfAccNo > 14){
                valid = false;
                return valid;
            }
        }
        //MY CLEAR - BANK OF AMARICA
        if(bankId == 13){
            if(lengthOfAccNo != 12){
                valid = false;
                return valid;
            }
        }
        //MY CLEAR - J.P MORGAN
        if(bankId == 45){
            if(lengthOfAccNo != 10){
                valid = false;
                return valid;
            }
        }

        return valid;
    }
    /*########## length Check End ##########*/

    /*########## availability Check Start ##########*/
    function fn_availabilityCheck(bankId, AccNo){

        var isReject = false; //result

        //MAYBANK
        if(bankId == 21 || bankId == 30){
            if(AccNo.substr(0,1).trim() ==  '4'){
                isReject = true;
                return isReject;
            }
        }

        //CIMB BANK
        if(bankId == 3 || bankId == 36){
            if(AccNo.length == 14){
                console.log (AccNo.substr(11,1).trim());
                if(AccNo.substr(11,1).trim() == 9 || AccNo.substr(11,1).trim() == 2 || AccNo.substr(11,1).trim() == 1){
                    isReject = true;
                    return isReject;
                }
            }
        }

        //PUBLIC BANK
        if(bankId == 6 || bankId == 32){
            if(AccNo.substr(0,1).trim() == '2' || AccNo.substr(0,1).trim() == '8'){
                isReject = true;
                return isReject;
            }
        }

        //RHB BANK
        if(bankId == 7 || bankId == 33){
            if(AccNo.substr(0,1).trim() == '7'){
                isReject = true;
                return isReject;
            }
        }

        //HONG LEONG BANK
        if(bankId == 5 || bankId == 29){
            if(AccNo.substr(3,1).trim() == '8' || AccNo.substr(3,1).trim() == '9'){
                 isReject = true;
                 return isReject;
            }
        }
        return isReject;
    }
    /*########## availability Check End ##########*/
        function fn_doSaveBankAcc() {
        console.log('fn_doSaveBankAcc() START');

        Common.ajax("POST", "/sales/customer/insertBankAccountInfo2.do", $('#insAccountForm').serializeJSON(), function(result) {

                Common.alert("<spring:message code='sal.alert.title.bankAccAdded' />" + DEFAULT_DELIMITER + "<b><spring:message code='sal.alert.msg.successfully' /></b>");

                if('${callPrgm}' == 'ORD_REGISTER_BANK_ACC' || '${callPrgm}' == 'PRE_ORD') {
                    fn_loadBankAccountPop(result.data);
                    $('#addDdCloseBtn').click();
                }
            }, function(jqXHR, textStatus, errorThrown) {
                try {
                    Common.alert("<spring:message code='sal.alert.title.failedToAdd' />" + DEFAULT_DELIMITER + "<b><spring:message code='sal.alert.msg.failedToAddNewbankAcc' />"+"Error message : " + jqXHR.responseJSON.message + "</b>");
                }
                catch(e) {
                    console.log(e);
                }
            }
        );
    }
</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->
<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="sal.page.title.custNewBankAcc" /></h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a id="_bankInsCloseBtn"><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->
<form action="" id="insAccountForm" name="insAccountForm" method="GET">
<input type="hidden" id="custId" name="custId" value="${custId}" />
    <table class="type1"><!-- table start -->
    <caption>table</caption>
    <colgroup>
        <col style="width:180px" />
        <col style="width:*" />
        <col style="width:180px" />
        <col style="width:*" />
    </colgroup>
        <tbody>
            <tr>
                <th scope="row"><spring:message code="sal.text.type" /><span class="must">*</span></th>
                <td>
                    <select class="w100p" id="_insCmbBankType" name="bankType">
                    </select>
                </td>
                <th scope="row"><spring:message code="sal.text.issueBank" /><span class="must">*</span></th>
                <td>
                    <select class="w100p" id="_insCmbAccBank" name="accBank">
                    </select>
                </td>
            </tr>
            <tr>
                <th scope="row"><spring:message code="sal.text.accNo" /><span class="must">*</span></th>
                <td>
                    <input type="text" id="_insAccNo" name="accNo" title="" placeholder="Account No" class="w100p" />
                </td>
                <th scope="row"><spring:message code="sal.text.bankBranch" /></th>
                <td>
                    <input type="text" id="_insBankBranch" name="accBankBranch" title="" placeholder="Bank Branch" class="w100p" />
                </td>
            </tr>
            <tr>
                <th scope="row"><spring:message code="sal.text.accountOwner" /><span class="must">*</span></th>
                <td colspan="3">
                    <input type="text" id="_insAccOwner" name="accName" title="" placeholder="Account Owner" class="w100p" />
                </td>
            </tr>
            <tr>
                <th scope="row"><spring:message code="sal.text.remark" /></th>
                <td colspan="3">
                    <textarea cols="20" rows="5" id="_insAccRem" name="accRemark" placeholder="Remark"></textarea>
                </td>
            </tr>
        </tbody>
    </table><!-- table end -->

    <ul class="center_btns">
        <li><p class="btn_blue2 big"><a href="#" onclick="fn_addBankAccount()"><spring:message code="sal.btn.addBankAccout" /></a></p></li>
    </ul>
</form>
</section><!-- pop_body end -->

</div>
