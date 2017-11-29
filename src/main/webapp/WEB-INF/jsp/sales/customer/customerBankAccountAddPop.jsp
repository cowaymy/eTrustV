<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript" language="javascript">

  	//AUIGrid 생성 후 반환 ID
	
    $(document).ready(function(){
        doGetCombo('/common/selectCodeList.do',       '20', '', 'cmbBankType', 'S', ''); //Add Bank Type Combo Box
        doGetCombo('/sales/customer/selectAccBank.do',  '', '', 'cmbAccBank',  'S', ''); //Issue Bank)
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
            msg += "* Please select the account type.<br/>";
        }

        if($("#cmbAccBank option:selected").index() <= 0) {
            isValid = false;
            msg += "* Please select the issue bank.<br/>";
        }

        if(FormUtil.isEmpty($('#txtAccNo').val())) {
            isValid = false;
            msg += "* Please key in the bank account number.<br/>";
        }
        else {
            if(FormUtil.checkNum($('#txtAccNo'))) {
                isValid = false;
                msg += "* Invalid bank account number.<br/>";
            }
            else {
                if($("#cmbAccBank option:selected").index() > 0) {
                    if(!FormUtil.IsValidBankAccount($('#cmbAccBank').val(), $('#txtAccNo').val())) {
                        isValid = false;
                        msg += "* Invalid bank account number.<br/>";
                    }
                    else {
                        var isExist = fn_existAccNo('${custId}', $('#txtAccNo').val().trim(), $('#cmbAccBank').val());
                        console.log('xxxxxxisExist:'+isExist);
                        if(isExist) {
                            console.log('xxxxxx');
                            isValid = false;
                            msg += "* Bank account is existing<br/>";
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
                
                Common.alert("Bank Account Added" + DEFAULT_DELIMITER + "<b>"+result.message+"</b>");

        	    if('${callPrgm}' == 'ORD_REGISTER_BANK_ACC' || '${callPrgm}' == 'PRE_ORD') {
        	        fn_loadBankAccountPop(result.data);
        	        $('#addDdCloseBtn').click();
        	    }
            }, function(jqXHR, textStatus, errorThrown) {
                try {
                    Common.alert("Failed To Add" + DEFAULT_DELIMITER + "<b>Failed to add new bank account. Please try again later.<br/>"+"Error message : " + jqXHR.responseJSON.message + "</b>");
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
<h1>Add Bank Account</h1>
<ul class="right_opt">
	<li><p class="btn_blue2"><a id="addDdCloseBtn" href="#">CLOSE</a></p></li>
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
	<th scope="row">Type<span class="must">*</span></th>
	<td>
	<select id="cmbBankType" name="bankType" class="w100p disabled"></select>
	</td>
	<th scope="row">Issue Bank<span class="must">*</span></th>
	<td>
	<select id="cmbAccBank" name="accBank" class="w100p"></select>
	</td>
</tr>
<tr>
	<th scope="row">Account No<span class="must">*</span></th>
	<td>
	<input id="txtAccNo" name="accNo" type="text" title="" placeholder="Account No" class="w100p" />
	</td>
	<th scope="row">Bank Branch</th>
	<td>
	<input id="txtAccBankBranch" name="accBankBranch"type="text" title="" placeholder="Bank Branch" class="w100p" />
	</td>
</tr>
<tr>
	<th scope="row">Account Owner<span class="must">*</span></th>
	<td colspan="3">
	<input id="txtAccName" name="accName" type="text" title="" placeholder="Account Owner" class="w100p" />
	</td>
</tr>
<tr>
	<th scope="row">Remarks</th>
	<td colspan="3">
	<textarea id="txtAccRemark" name="accRemark" cols="20" rows="5" placeholder="Remark"></textarea>
	</td>
</tr>
</tbody>
</table><!-- table end -->
</form>

<ul class="center_btns">
	<li><p class="btn_blue2 big"><a id="btnAddBankAcc" href="#">Add Bank Account</a></p></li>
</ul>
</section><!-- pop_body end -->

</div><!-- popup_wrap end -->
