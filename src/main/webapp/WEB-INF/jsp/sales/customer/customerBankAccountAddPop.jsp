<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript" language="javascript">

  	//AUIGrid ���� �� ��ȯ ID
	
    $(document).ready(function(){
        doGetCombo('/common/selectCodeList.do',       '20', '', 'cmbBankType', 'S', ''); //Add Bank Type Combo Box
        doGetComboCodeId('/sales/customer/selectAccBank.do', {isAllowForDd : '1'}, '', 'cmbAccBank',   'S', ''); //Issue Bank)
    });

    $(function(){
        $('#btnAddBankAcc').click(function() {
            if(!fn_validBankAcc()) return false;
            fn_doSaveBankAcc();
        });
    });
    
    function fn_validBankAcc() {
        var isValid = true, msg = "";

        if($("#cmbBankType option:selected").index() <= 0) {
            isValid = false;
            msg += "<spring:message code='sal.alert.msg.pleaseSelectTheAccType' />";
        }

        if($("#cmbAccBank option:selected").index() <= 0) {
            isValid = false;
            msg += "<spring:message code='sal.alert.msg.pleaseSelectTheIssueBank' />";
        }

        if(FormUtil.isEmpty($('#txtAccNo').val())) {
            isValid = false;
            msg += "<spring:message code='sal.alert.msg.pleaseKeyInTheBankAccNum' />";
        }
        else {
            if(FormUtil.checkNum($('#txtAccNo'))) {
                isValid = false;
                msg += "<spring:message code='sal.alert.msg.invalidBankAccNum' /><br/>";
            }
            else {
                if($("#cmbAccBank option:selected").index() > 0) {
                    if(!FormUtil.IsValidBankAccount($('#cmbAccBank').val(), $('#txtAccNo').val())) {
                        isValid = false;
                        msg += "<spring:message code='sal.alert.msg.invalidBankAccNum' /><br/>";
                    }
                    else {
                        var isExist = fn_existAccNo('${custId}', $('#txtAccNo').val().trim(), $('#cmbAccBank').val());
                        console.log('xxxxxxisExist:'+isExist);
                        if(isExist) {
                            console.log('xxxxxx');
                            isValid = false;
                            msg += "<spring:message code='sal.alert.msg.bankAccIsExisting' />";
                        }
                    }
                }
            }
        }

        if(!isValid) Common.alert("Order Update Summary" + DEFAULT_DELIMITER + "<b>"+msg+"</b>");

        return isValid;
    }
    
    function fn_existAccNo(CustID, AccNo, IssueBankID){
        var isExist = false;
        
        Common.ajax("GET", "/sales/customer/selectCustomerBankAccJsonList", {custId : CustID, custAccNo : AccNo, custAccBankId : IssueBankID}, function(rsltInfo) {
            if(rsltInfo != null) {
                isExist = rsltInfo.length == 0 ? false : true;
            }
        }, null, {async : false});
        console.log('isExist ggg:'+isExist);
        return isExist;
    }
    
    function fn_doSaveBankAcc() {
        console.log('fn_doSaveBankAcc() START');
        
        Common.ajax("POST", "/sales/customer/insertBankAccountInfo2.do", $('#frmBankAcc').serializeJSON(), function(result) {
                
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
<h1><spring:message code="sal.title.addBankAccount" /></h1>
<ul class="right_opt">
	<li><p class="btn_blue2"><a id="addDdCloseBtn" href="#"><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->
<form id="frmBankAcc" method="post">
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
	<select id="cmbBankType" name="bankType" class="w100p disabled"></select>
	</td>
	<th scope="row"><spring:message code="sal.text.issueBank" /><span class="must">*</span></th>
	<td>
	<select id="cmbAccBank" name="accBank" class="w100p"></select>
	</td>
</tr>
<tr>
	<th scope="row"><spring:message code="sal.text.accNo" /><span class="must">*</span></th>
	<td>
	<input id="txtAccNo" name="accNo" type="text" title="" placeholder="Account No" class="w100p" />
	</td>
	<th scope="row"><spring:message code="sal.text.bankBranch" /></th>
	<td>
	<input id="txtAccBankBranch" name="accBankBranch"type="text" title="" placeholder="Bank Branch" class="w100p" />
	</td>
</tr>
<tr>
	<th scope="row"><spring:message code="sal.text.accountOwner" /><span class="must">*</span></th>
	<td colspan="3">
	<input id="txtAccName" name="accName" type="text" title="" placeholder="Account Owner" class="w100p" />
	</td>
</tr>
<tr>
	<th scope="row"><spring:message code="sal.text.remark" /></th>
	<td colspan="3">
	<textarea id="txtAccRemark" name="accRemark" cols="20" rows="5" placeholder="Remark"></textarea>
	</td>
</tr>
</tbody>
</table><!-- table end -->
</form>

<ul class="center_btns">
	<li><p class="btn_blue2 big"><a id="btnAddBankAcc" href="#"><spring:message code="sal.btn.addBankAccout" /></a></p></li>
</ul>
</section><!-- pop_body end -->

</div><!-- popup_wrap end -->
