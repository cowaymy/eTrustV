<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
<script src="https://www.onlinepayment.com.my/MOLPay/API/cse/checkout_dev.js"></script>
<script type="text/javaScript" language="javascript">

      //AUIGrid ���� �� ��ȯ ID

    $(document).ready(function(){
        doGetCombo('/common/selectCodeList.do', '21',  '','cmbCreditCardType', 'S', ''); // Add Card Type Combo Box
        doGetCombo('/sales/customer/selectAccBank.do',  '', '', 'cmbIssBank',  'S', ''); //Issue Bank)
        doGetCombo('/common/selectCodeList.do', '115', '','cmbCardType',       'S', ''); // Add Card Type Combo Box

        $("#_expMonth_").blur(function() {
            var expMonth = $("#_expMonth_").val();

            if(expMonth.length == "") {
                Common.alert("Please key in expiry month.");
                return false;
            } else {
                if(expMonth.length < 2) {
                    $("#_expMonth_").val("0" + expMonth);
                    $("#hExpMonth").val("0" + expMonth);
                } else {
                    if(parseInt(expMonth) > 12) {
                        Common.alert("Please rekey expiry month");
                    }
                }
            }
        });
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

        if(FormUtil.isEmpty($('#nameOnCard').val())) {
            isValid = false;
            msg += "<spring:message code='sal.alert.msg.pleaseKeyInNameOnCard' /><br/>";
        }
        else {
            if(!FormUtil.checkSpecialChar($('#nameOnCard').val())) {
                isValid = false;
                msg += "<spring:message code='sal.alert.NameOnCardCannotContainOfSpecChr' />";
            } else {
                $("#nameCard").val($("#nameOnCard").val());
            }
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
                if(FormUtil.checkNum($("#cardNo"))) {
                    isValid = false;
                    msg += "<spring:message code='sal.alert.msg.invalidCreditCardNum' />";
                }
                else {
                    var isExistCrc = fn_existCrcNo('${custId}', $("#cardNo").val().trim());

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

        var expMonth = $("#_expMonth_").val();
        var expYear = $("#_expYear_").val();

        //Exp Date
        if(expMonth == ""){
            Common.alert("Please key in expiry month.");
            return false;
        } else {
            if(expMonth.length < 2) {
                $("#_expMonth_").val("0" + expMonth);
                $("#hExpMonth").val("0" + expMonth);
            } else {
                if(parseInt(expMonth) > 12) {
                    Common.alert("Please key in expiry month.");
                    $("#_expMonth_").val("");
                    return false;
                } else {
                    $("#hExpMonth").val(expMonth);
                }
            }
        }

        if(expYear == ""){
            Common.alert("Please key in expiry year.");
            return false;
        } else {
            $("#hExpYear").val(expYear);
        }

        if(expMonth != "" && expYear != "") {
            var cMonYear = new Date();
            cMonYear.setMonth(cMonYear.getMonth() + 3);

            var iMonYear = new Date(expYear + "/" + expMonth + "/" + 01);

            if(cMonYear > iMonYear) {
                Common.alert("Invalid credit card expiry date!");
                $("#_expMonth_").val("");
                $("#_expYear_").val("")
                $("#hExpMonth").val("");;
                $("#hExpYear").val("");
                return false;
            } else {
                $("#expDate").val(expMonth + "/" + expYear);
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

        Common.ajax("GET", "/sales/customer/tokenPubKey.do", "", function(result) {;
            var pub = "-----BEGIN PUBLIC KEY-----" + result.pubKey + "-----END PUBLIC KEY-----";
            var molpay = MOLPAY.encrypt( pub );

            form = document.getElementById('frmCrCard');
            molpay.encryptForm(form);
            var form = $("#frmCrCard").serialize();


            $.ajax({
                url : "/sales/customer/tokenLogging.do",
                data : form,
                success : function(tlResult) {
                    if(result.tknId != 0) {
                        $("#tknId").val(tlResult.tknId);
                        $("#refNo").val(tlResult.refNo);
                        $("#urlReq").val(tlResult.urlReq);
                        $("#merchantId").val(tlResult.merchantId);
                        $("#signature").val(tlResult.signature);

                        Common.ajax("GET", "/sales/customer/tokenizationProcess.do", $("#frmCrCard").serialize(), function(tResult) {
                        	if(tResult.stus == "1" && tResult.crcCheck == "0") {
                                console.log("order edit new :: " + tResult.token);
                                $("#custCrcExpr").val($("#_expMonth_").val() + $("#_expYear_").val().substring(2));
                                $("#custCrcNoMask").val(tResult.crcNo);
                                $("#token").val(tResult.token);

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

                                $("#addCrcCloseBtn").click();
                            } else {
                                Common.alert(tResult.errorDesc);
                            }
                        });
                    } else {
                        console.log("tknId 0");
                        Common.alert("Tokenization error!");
                    }
                }
            });
     });
    }
</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

    <header class="pop_header"><!-- pop_header start -->
        <h1><spring:message code="sal.page.title.addCreditCard" /></h1>
        <ul class="right_opt">
           <li><p class="btn_blue2"><a id="addCrcCloseBtn" href="#"><spring:message code="sal.btn.close" /></a></p></li>
        </ul>
    </header><!-- pop_header end -->

    <section class="pop_body"><!-- pop_body start -->
        <form id="frmCrCard" method="post">
            <input type="hidden" id="custId" name="custId" value="${custId}" />
            <input type="hidden" id="nric" name="nric" value="${nric}" />

            <input type="hidden" id="etyPoint" name="etyPoint" value="EN">
            <input type="hidden" id="tknId" name="tknId">
            <input type="hidden" id="refNo" name="refNo">
            <input type="hidden" id="urlReq" name="urlReq">
            <input type="hidden" id="merchantId" name="merchantId">
            <input type="hidden" id="signature" name="signature">
            <input type="hidden" id="token" name="token">
            <input type="hidden" id="expDate" name="expDate">
            <input type="hidden" id="hExpMonth" name="hExpMonth">
            <input type="hidden" id="hExpYear" name="hExpYear">

            <input type="hidden" id="custCrcOwner" name="custCrcOwner">
            <input type="hidden" id="custCrcExpr" name="custCrcExpr">
            <input type="hidden" id="custCrcNoMask" name="custCrcNoMask">
            <input type="hidden" id="nameCard" name="nameCard">

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
                        <th scope="row"><spring:message code="sal.text.issueBank" /><span class="must">*</span></th>
                        <td>
                            <select id="cmbIssBank" name="issBank" class="w100p"></select>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row"><spring:message code="sal.text.type" /><span class="must">*</span></th>
                        <td>
                            <select class="w100p" id="cmbCreditCardType" name="creditCardType" disabled></select>
                        </td>
                        <th scope="row"><spring:message code="sal.text.cardType" /><span class="must">*</span></th>
                        <td>
                            <select class="w100p" id="cmbCardType" name="cardType"></select>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row"><spring:message code="sal.text.creditCardNo" /><span class="must">*</span></th>
                        <!-- <td>
                            <input id="cardNo" name="cardNo" type="text" title="" placeholder="Credit Card Number" class="w100p" />
                        </td> -->
                        <td>
                            <input type="text" class="w100p" id="cardNo" data-encrypted-name="PAN" placeholder="Credit Card Number" maxlength="16" required/>
                        </td>
                        <th scope="row"><spring:message code="sal.text.nameOnCard" /><span class="must">*</span></th>
                        <td>
                            <input id="nameOnCard" name="nameOnCard" type="text" title="" placeholder="Name On Card" class="w100p" />
                        </td>
                    </tr>
                    <tr>
                        <!-- <th scope="row"><spring:message code="sal.text.expiryDate" /><span class="must">*</span></th>
                        <td>
                            <input id="expDate" name="expDate" type="text" title="Create start Date" placeholder="MM/YYYY" class="j_date2" />
                        </td> -->
                        <th scope="row">Expiry Month<span class="must">*</span></th>
                        <td>
                            <input class="w100p" id="_expMonth_" type="text" size="20" data-encrypted-name="EXPMONTH" placeholder="Expiry Month (MM)" maxlength="2" required/>
                        </td>
                        <th scope="row">Expiry Year<span class="must">*</span></th>
                        <td>
                            <input class="w100p" id="_expYear_" type="text" size="20" data-encrypted-name="EXPYEAR" placeholder="Expiry Year (YYYY)" min="4" maxlength="4" required/>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row"><spring:message code="sal.text.remark" /></th>
                        <td colspan="3">
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
