<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript" language="javascript">

  	//AUIGrid ���� �� ��ȯ ID
	
    $(document).ready(function(){
        doGetCombo('/common/selectCodeList.do', '21',  '','cmbCreditCardType', 'S', ''); // Add Card Type Combo Box
        doGetCombo('/sales/customer/selectAccBank.do', '', '', 'cmbIssBank',   'S', ''); //Issue Bank)
        doGetCombo('/common/selectCodeList.do', '115', '','cmbCardType',       'S', ''); // Add Card Type Combo Box
    });

    $(function(){
        $('#btnAddCreditCard').click(function() {
            if(!fn_validCreditCard()) return false;
            fn_doSaveCreditCard();
        });
    });
    
    function fn_validCreditCard() {
        var isValid = true, msg = "";

        if($("#cmbCreditCardType option:selected").index() <= 0) {
            isValid = false;
            msg += "* Please select credit card type.<br/>";
        }

        if($("#cmbIssBank option:selected").index() <= 0) {
            isValid = false;
            msg += "* Please select issue bank.<br/>";
        }

        if(FormUtil.isEmpty($('#cardNo').val())) {
            isValid = false;
            msg += "* Please key in credit card number.<br/>";
        }
        else {
            if($('#cardNo').val().trim().length != 16) {
                isValid = false;
                msg += "* Credit card number must in 16 digits.<br/>";
            }
            else {
                if(FormUtil.checkNum($('#cardNo'))) {
                    isValid = false;
                    msg += "* Invalid credit card number.<br/>";
                }
                else {
                    var isExistCrc = fn_existCrcNo('${custId}', $('#cardNo').val().trim());
                    
                    if(isExistCrc) {
                        isValid = false;
                        msg += "* Credit card is existing.<br/>";
                    }
                    else {
                        if($("#cmbCreditCardType option:selected").index() > 0) {
                            if($("#cmbCreditCardType").val() == '111') {
                                //MASTER
                                if($('#cardNo').val().trim().substring(0, 1) != "5") {
                                    isValid = false;
                                    msg += "* Invalid credit card number.<br/>";
                                }
                            }
                            else if($("#cmbCreditCardType").val() == '112') {
                                //VISA
                                if($('#cardNo').val().trim().substring(0, 1) != "4") {
                                    isValid = false;
                                    msg += "* Invalid credit card number.<br/>";
                                }
                            }
                        }
                    }
                }
            }
        }
        
        if(FormUtil.isEmpty($('#expDate').val())) {
            isValid = false;
            msg += "* Please select credit card expiry date.<br/>";
        }
        if(FormUtil.isEmpty($('#nameOnCard').val())) {
            isValid = false;
            msg += "* Please key in name on card<br/>";
        }
        else {
            if(!FormUtil.checkSpecialChar($('#nameOnCard').val())) {
                isValid = false;
                msg += "* Name on card cannot contains of special character.<br/>";
            }
        }
        
        if($("#cmbCardType option:selected").index() <= 0) {
            isValid = false;
            msg += "* Please select the card type.<br/>";
        }
        
        if(!isValid) Common.alert("Order Update Summary" + DEFAULT_DELIMITER + "<b>"+msg+"</b>");

        return isValid;
    }
    
    function fn_existCrcNo(CustID, CrcNo, IssueBankID){
        var isExist = false;
        
        Common.ajax("GET", "/sales/customer/selectCustomerCreditCardJsonList", {custId : CustID, custOriCrcNo : CrcNo}, function(rsltInfo) {
            if(rsltInfo != null) {
                console.log('rsltInfo.length:'+rsltInfo.length);
                isExist = rsltInfo.length == 0 ? false : true;
            }
        }, null, {async : false});
        console.log('isExist ggg:'+isExist);
        return isExist;
    }
    
    function fn_doSaveCreditCard() {
        console.log('fn_doSaveBankAcc() START');
        
        Common.ajax("POST", "/sales/customer/insertCreditCardInfo2.do", $('#frmCrCard').serializeJSON(), function(result) {
                
                Common.alert("Credit Card Added" + DEFAULT_DELIMITER + "<b>"+result.message+"</b>");
            
            }, function(jqXHR, textStatus, errorThrown) {
                try {
                    Common.alert("Failed To Save" + DEFAULT_DELIMITER + "<b>Failed to save credit card. Please try again later.<br/>"+"Error message : " + jqXHR.responseJSON.message + "</b>");
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
<h1>Add Credit Card</h1>
<ul class="right_opt">
	<li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->
<form id="frmCrCard" method="post">
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
	    <select class="w100p" id="cmbCreditCardType" name="creditCardType" ></select>
	</td>
	<th scope="row">Issue Bank<span class="must">*</span></th>
	<td>
	<select id="cmbIssBank" name="issBank" class="w100p"></select>
	</td>
</tr>
<tr>
	<th scope="row">Credit Card No<span class="must">*</span></th>
	<td>
	    <input id="cardNo" name="cardNo" type="text" title="" placeholder="Credit Card Number" class="w100p" />
	</td>
	<th scope="row">Expiry Date<span class="must">*</span></th>
	<td>
	    <input id="expDate" name="expDate" type="text" title="Create start Date" placeholder="MM/YYYY" class="j_date2" />
	</td>
</tr>
<tr>
	<th scope="row">Name On Card<span class="must">*</span></th>
	<td>
	    <input id="nameOnCard" name="nameOnCard" type="text" title="" placeholder="Name On Card" class="w100p" />
	</td>
	<th scope="row">Card Type<span class="must">*</span></th>
	<td>
	    <select class="w100p" id="cmbCardType" name="cardType"></select>
	</td>
</tr>
<tr>
	<th scope="row">Remarks</th>
	<td colspan="3">
	    <textarea id="cardRem" name="cardRem" cols="20" rows="5" placeholder="Remark"></textarea>
	</td>
</tr>
</tbody>
</table><!-- table end -->
</form>

<ul class="center_btns">
	<li><p class="btn_blue2 big"><a id="btnAddCreditCard" href="#">Add Credit Card</a></p></li>
</ul>
</section><!-- pop_body end -->

</div><!-- popup_wrap end -->
