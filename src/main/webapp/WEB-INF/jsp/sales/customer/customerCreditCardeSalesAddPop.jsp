<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
<script src="https://www.onlinepayment.com.my/MOLPay/API/cse/checkout_dev.js"></script>
<script type="text/javaScript" language="javascript">

  	//AUIGrid ���� �� ��ȯ ID

    $(document).ready(function(){
        doGetCombo('/common/selectCodeList.do', '21',  '','cmbCreditCardType', 'S', ''); // Add Card Type Combo Box
        doGetCombo('/sales/customer/selectAccBank.do',  '', '', 'cmbIssBank',  'S', ''); //Issue Bank)
       //doGetCombo('/common/selectCodeList.do', '115', '','cmbCardType',       'S', ''); // Add Card Type Combo Box
        $("#nameOnCard").bind("keyup", function(){$(this).val($(this).val().toUpperCase());});

        // 20190925 KR-OHK Moblie Popup Setting
        Common.setMobilePopup(false, false, '');
    });

    $(function(){
        $('#btnAddCreditCard').click(function() {
        	$("#cmbCardType").val($('input[name=cmbCardType]:checked').val());

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

    function fn_cardNoChangeFunc() {
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
    }

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
            /*
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
            */
        }

        if(FormUtil.isEmpty($('#nameOnCard').val())) {
            isValid = false;
            msg += "<spring:message code='sal.alert.msg.pleaseKeyInNameOnCard' />";
        }
        else {
            if(!FormUtil.checkSpecialChar($('#nameOnCard').val())) {
                isValid = false;
                msg += "<spring:message code='sal.alert.NameOnCardCannotContainOfSpecChr' />";
            } else {
                $("#nameCard").val($("#nameOnCard").val());
            }
        }

        /* if($("#cmbCardType option:selected").index() <= 0) {
            isValid = false;
            msg += "<spring:message code='sal.alert.pleaseSelectTheCardType' />";
        } */

        if($("#cmbCardType").val() <= 0) {
            isValid = false;
            msg += "<spring:message code='sal.alert.pleaseSelectTheCardType' />";
        }

        //Token ID
        if("" == $("tknId").val() || null == $("#tknId").val()) {
            isValid = false;
            msg += "Credit card has not been encrypted";
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

        $("#oriCustCrcNo").val($("#cardNo").val());

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

        /*
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
                                $("#custCrcExpr").val($("#expMonth").val() + $("#expYear").val().substring(2));
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
     */
    }

    function fn_padding(value, length, prefix) {
        var newVal = "";
        var pLength = length - value.length;

        for(var x = 0; x < pLength; x++) {
            newVal += prefix;
        }
        return newVal + value;
    }

    function fn_tokenPop() {
        console.log("tokenizationBtn :: click :: fn_tokenPop");

        var refId;

        if($("#nric").val() == "") {
            Common.alert("Please key in NRIC");
            return false;
        }

        var tokenPop, tokenTick;
        var nric = fn_padding($("#nric").val(), 12, "0");
        var custId = fn_padding($("#custId").val(), 12, "0");
        var crcId = "000000000000";
        refId = nric + custId + crcId;

        Common.ajax("GET", "/sales/customer/getTknId.do", {refId : refId}, function(r1) {
            if(r1.tknId != 0) {
                $("#refNo").val(r1.tknRef);

                // Calls MC Payment pop up
                var option = {
                        winName: "popup",
                        isDuplicate: true, // 계속 팝업을 띄울지 여부.
                        fullscreen: "no", // 전체 창. (yes/no)(default : no)
                        location: "no", // 주소창이 활성화. (yes/no)(default : yes)
                        menubar: "no", // 메뉴바 visible. (yes/no)(default : yes)
                        titlebar: "yes", // 타이틀바. (yes/no)(default : yes)
                        toolbar: "no", // 툴바. (yes/no)(default : yes)
                        resizable: "yes", // 창 사이즈 변경. (yes/no)(default : yes)
                        scrollbars: "yes", // 스크롤바. (yes/no)(default : yes)
                        width: "750px", // 창 가로 크기
                        height: "180px" // 창 세로 크기
                    };

                if (option.isDuplicate) {
                    option.winName = option.winName + new Date();
                }

                var URL = "https://services.sandbox.mcpayment.net:8080/newCardForm?apiKey=AKIA5TZ_COWAY_YNAAZ6E&refNo=" + r1.tknRef; // MCP UAT Tokenization URL
                //var URL = "https://services.mcpayment.net:8080/newCardForm?apiKey=3fdgsTZ_COWAY_dsaAZ6E&refNo=" + r1.tknRef;

                tokenPop = window.open(URL, option.winName,
                        "fullscreen=" + option.fullscreen +
                        ",location=" + option.location +
                        ",menubar=" + option.menubar +
                        ",titlebar=" + option.titlebar +
                        ",toolbar=" + option.toolbar +
                        ",resizable=" + option.resizable +
                        ",scrollbars=" + option.scrollbars +
                        ",width=" + option.width +
                        ",height=" + option.height);

                // Set ticker to check if MC Payment pop up is still opened
                tokenTick = setInterval(
                    function() {
                        if(tokenPop.closed) {
                            console.log("tokenPop is closed!");
                            clearInterval(tokenTick);

                            // Retrieve token ID to be displayed in credit card number field
                            Common.ajax("GET", "/sales/customer/getTokenNumber.do", {refId : r1.tknRef}, function(r2) {
                                console.log(r2);
                                if(r2 != null) {
                                    $("#cardNo").val(r2.data.bin + "******" + r2.data.cclast4);
                                    $("#tknId").val(r2.data.token);
                                    $("#cardExpr").val(r2.data.expr);

                                    fn_cardNoChangeFunc();
                                }
                            });
                        }
                    }, 500);
            }
        });
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
<input type="hidden" id="nric" name="nric" value="${nric}" />

<input type="hidden" id="etyPoint" name="etyPoint" value="EN">
<input type="hidden" id="tknId" name="tknId">
<input type="hidden" id="refNo" name="refNo">
<input type="hidden" id="urlReq" name="urlReq">
<input type="hidden" id="merchantId" name="merchantId">
<input type="hidden" id="signature" name="signature">
<input type="hidden" id="token" name="token">
<input type="hidden" id="expMonth" size="20" data-encrypted-name="EXPMONTH" placeholder="Expiry Month (MM)" maxlength="2" required/>
<input type="hidden" id="expYear" size="20" data-encrypted-name="EXPYEAR" placeholder="Expiry Year (YYYY)" min="4" maxlength="4" required/>
<input type="hidden" id="hExpMonth" name="hExpMonth">
<input type="hidden" id="hExpYear" name="hExpYear">

<input type="hidden" id="custCrcOwner" name="custCrcOwner">
<input type="hidden" id="custCrcNoMask" name="custCrcNoMask">
<input type="hidden" id="nameCard" name="nameCard">

<input type="hidden" id="oriCustCrcNo" name="oriCustCrcNo">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:40%"/>
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sal.text.creditCardNo" /><span class="must">*</span></th>
    <td>
        <input class="" id="cardNo" name="cardNo" type="text" size="36" placeholder="Credit Card No" maxlength="36" style="width:95%" readonly />
        <a href="javascript:fn_tokenPop();" class="search_btn" id="tokenizationBtn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.expiryDate" /><span class="must">*</span></th>
    <td>
        <input class="" id="cardExpr" name="cardExpr" type="text" size="5" placeholder="Credit Card Expiry" maxlength="4" readonly />
    </td>
</tr>
<!--
<tr>
    <th scope="row"><spring:message code="sal.text.creditCardNo2" /><span class="must">*</span></th>
    <td>
        <input type="text" class="w100p" id="cardNo" data-encrypted-name="PAN" placeholder="Credit Card Number" maxlength="16" required/>
    </td>
</tr>
-->
<tr>
	<th scope="row"><spring:message code="sal.text.type2" /><span class="must">*</span></th>
	<td>
	    <select class="w100p disabled" id="cmbCreditCardType" name="creditCardType" disabled="disabled"></select>
	</td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.nameOnCard2" /><span class="must">***</span></th>
    <td>
        <input id="nameOnCard" name="nameOnCard" type="text" title="" placeholder="Name On Card" class="w100p" />
    </td>
</tr>
<tr>
	<th scope="row"><spring:message code="sal.text.issueBank2" /><span class="must">*</span></th>
	<td>
	<select id="cmbIssBank" name="issBank" class="w100p"></select>
	</td>
</tr>
<tr>
	<th scope="row"><spring:message code="sal.text.cardType2" /><span class="must">*</span></th>
	<td>
	    <!-- <select class="w100p" id="cmbCardType" name="cardType"></select> -->
	    <div id="cardTypeForm">
            <label><input type="radio" name="cmbCardType" value="1241" /><span>Credit Card</span></label>
            <label><input type="radio" name="cmbCardType" value="1240" /><span>Debit Card</span></label>
            <input id="cmbCardType" name="cardType" type="hidden"/>
        </div>
	</td>
</tr>
<tr>
    <th scope="row" colspan=2>
        <span class="red_text">
        <br/>
            ***NOTE : Debit Card  - follow customer IC name \ Credit Card - follow display name on card
            <br/><br/>
        </span>
     </th>
</tr>
<tr>
</tr>
<tr>
	<%-- <th scope="row"><spring:message code="sal.text.remark" /></th>
	<td>
	    <textarea id="cardRem" name="cardRem" cols="20" rows="5" placeholder="Remark"></textarea>
	</td> --%>
	<th scope="row" colspan="2" >
	   <span class="must"><br/>
	   The card information provided here is CONFIDENTIAL and/or intended solely for the use of the recurring payment only. Compliance and Legal department may conduct investigations on sale transactions from time to time and may take action against any health planner if he / she is found to have engaged in any activity which constitutes an unethical transaction, violation of the law or misconduct, including but not limited to circumstances where a health planner is found to be paying on behalf of a customer without Coway (M) Sdn. Bhd.'s authorisation.
	   <br/><br/></span>
	</th>
</tr>
</tbody>
</table><!-- table end -->
</form>

<ul class="center_btns">
	<li><p class="btn_blue2 big"><a id="btnAddCreditCard" href="#"><spring:message code="sal.btn.addCreditCard" /></a></p></li>
</ul>
</section><!-- pop_body end -->

</div><!-- popup_wrap end -->
