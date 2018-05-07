<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript" language="javascript">

  	//AUIGrid ���� �� ��ȯ ID

    $(document).ready(function(){
        doGetCombo('/common/selectCodeList.do', '21',  '','cmbCreditCardType', 'S', ''); // Add Card Type Combo Box
        doGetCombo('/sales/customer/selectAccBank.do',  '', '', 'cmbIssBank',  'S', ''); //Issue Bank)
        doGetCombo('/common/selectCodeList.do', '115', '','cmbCardType',       'S', ''); // Add Card Type Combo Box
    });

    $(function(){
        $('#btnAddCreditCard').click(function() {
            if(!fn_validCreditCard()) return false;
            fn_doSaveCreditCard();
        });
        $('#cardNo').change(function() {
            var vCardNo = $('#cardNo').val();
            if(vCardNo.indexOf('5') == 0) {
                $('#cmbCreditCardType').val('111');
            }
            else if(vCardNo.indexOf('4') == 0) {
                $('#cmbCreditCardType').val('112');
            }
            else {
                $('#cmbCreditCardType').val('');
            }
        });
    });

    function fn_validCreditCard() {
        var isValid = true, msg = "";

        $('#cmbCreditCardType').removeAttr("disabled");

        if($("#cmbCreditCardType option:selected").index() <= 0) {
            isValid = false;
            msg += "* <spring:message code='sal.alert.msg.pleaseSelectCreditCardType' /><br/>";
        }

        if($("#cmbIssBank option:selected").index() <= 0) {
            isValid = false;
            msg += "* <spring:message code='sal.alert.msg.pleaseSelectTheIssueBank' /><br/>";
        }

        if(FormUtil.isEmpty($('#cardNo').val())) {
            isValid = false;
            msg += "* <spring:message code='sal.alert.msg.pleaseKeyInCreditCardNum' /><br/>";
        }
        else {
            if($('#cardNo').val().trim().length != 16) {
                isValid = false;
                msg += "* <spring:message code='sal.alert.msg.creditCardNumMustIn16Digits' /><br/>";
            }
            else {
                if(FormUtil.checkNum($('#cardNo'))) {
                    isValid = false;
                    msg += "<spring:message code='sal.alert.msg.invalidCreditCardNum' />";
                }
                else {
                    var isExistCrc = fn_existCrcNo('${custId}', $('#cardNo').val().trim());

                    if(isExistCrc) {
                        isValid = false;
                        msg += "<spring:message code='sal.alert.msg.creditCardIsExisting' />";
                    }
                    else {
                        if($("#cmbCreditCardType option:selected").index() > 0) {
                            if($("#cmbCreditCardType").val() == '111') {
                                //MASTER
                                if($('#cardNo').val().trim().substring(0, 1) != "5") {
                                    isValid = false;
                                    msg += "<spring:message code='sal.alert.msg.invalidCreditCardNum' />";
                                }
                            }
                            else if($("#cmbCreditCardType").val() == '112') {
                                //VISA
                                if($('#cardNo').val().trim().substring(0, 1) != "4") {
                                    isValid = false;
                                    msg += "<spring:message code='sal.alert.msg.invalidCreditCardNum' />";
                                }
                            }
                        }
                    }
                }
            }
        }

        if(FormUtil.isEmpty($('#expDate').val())) {
            isValid = false;
            msg += "<spring:message code='sal.alert.msg.pleaseSelectCreditCardExpDate' />";
        }
        if(FormUtil.isEmpty($('#nameOnCard').val())) {
            isValid = false;
            msg += "<spring:message code='sal.alert.msg.pleaseKeyInNameOnCard' />";
        }
        else {
            if(!FormUtil.checkSpecialChar($('#nameOnCard').val())) {
                isValid = false;
                msg += "<spring:message code='sal.alert.NameOnCardCannotContainOfSpecChr' />";
            }
        }

        if($("#cmbCardType option:selected").index() <= 0) {
            isValid = false;
            msg += "<spring:message code='sal.alert.pleaseSelectTheCardType' />";
        }

        if(!isValid) {
            Common.alert("Order Update Summary" + DEFAULT_DELIMITER + "<b>"+msg+"</b>");
            $('#cmbCreditCardType').prop("disabled", true);
        }

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

                if('${callPrgm}' == 'ORD_REGISTER_PAYM_CRC' || '${callPrgm}' == 'PRE_ORD') {
        	        fn_loadCreditCard2(result.data);
        	        $('#addCrcCloseBtn').click();
        	    }

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
<h1><spring:message code="sal.page.title.custNewCreditCard2" /></h1>
<ul class="right_opt">
	<li><p class="btn_blue2"><a id="addCrcCloseBtn" href="#"><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->
<form id="frmCrCard" method="post">
<input type="hidden" id="custId" name="custId" value="${custId}" />

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:360px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row"><spring:message code="sal.text.type2" /><span class="must">*</span></th>
	<td>
	    <select class="w100p disabled" id="cmbCreditCardType" name="creditCardType" disabled="disabled"></select>
	</td>
</tr>
<tr>
	<th scope="row"><spring:message code="sal.text.issueBank2" /><span class="must">*</span></th>
	<td>
	<select id="cmbIssBank" name="issBank" class="w100p"></select>
	</td>
</tr>
<tr>
	<th scope="row"><spring:message code="sal.text.creditCardNo2" /><span class="must">*</span></th>
	<td>
	    <input id="cardNo" name="cardNo" type="text" title="" placeholder="Credit Card Number" class="w100p" />
	</td>
</tr>
<tr>
	<th scope="row"><spring:message code="sal.text.expiryDate2" /><span class="must">*</span></th>
	<td>
	    <input id="expDate" name="expDate" type="text" title="Create start Date" placeholder="MM/YYYY" class="j_date2" />
	</td>
</tr>
<tr>
	<th scope="row"><spring:message code="sal.text.nameOnCard2" /><span class="must">*</span></th>
	<td>
	    <input id="nameOnCard" name="nameOnCard" type="text" title="" placeholder="Name On Card" class="w100p" />
	</td>
</tr>
<tr>
	<th scope="row"><spring:message code="sal.text.cardType2" /><span class="must">*</span></th>
	<td>
	    <select class="w100p" id="cmbCardType" name="cardType"></select>
	</td>
</tr>
<tr>
	<th scope="row"><spring:message code="sal.text.remark" /></th>
	<td>
	    <textarea id="cardRem" name="cardRem" cols="20" rows="5" placeholder="Remark"></textarea>
	</td>
</tr>
</tbody>
</table><!-- table end -->
</form>

<ul class="center_btns">
	<li><p class="btn_blue2 big"><a id="btnAddCreditCard" href="#"><spring:message code="sal.btn.addCreditCard" /></a></p></li>
</ul>
</section><!-- pop_body end -->

</div><!-- popup_wrap end -->
