<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
<script src="https://www.onlinepayment.com.my/MOLPay/API/cse/checkout_dev.js"></script>
<script type="text/javaScript" language="javascript">
	var creditCardErrorMessage = "";
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

    $(function(){
        $('#btnAddCreditCard').click(function() {
            if(!fn_validCreditCard()) return false;
            fn_doSaveCreditCard();
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
                msg += "<spring:message code='sal.alert.NameOnCardCannotContainOfSpecChr' /><br/>";
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

        }

        if($("#cmbCardType option:selected").index() <= 0) {
            isValid = false;
            msg += "<spring:message code='sal.alert.pleaseSelectTheCardType' /><br/>";
        }

        //Token ID
        if("" == $("tknId").val() || null == $("#tknId").val()) {
            isValid = false;
            msg += "Credit card has not been encrypted <br/>";
        }

        var isExistCrc = fn_existCrcNo($("#custId").val(), $("#tknId").val().trim());
        if(isExistCrc) {
            isValid = false;
            msg += creditCardErrorMessage;
        }

        if(!isValid) {
            Common.alert("Order Update Summary" + DEFAULT_DELIMITER + "<b>"+msg+"</b>");
            $('#cmbCreditCardType').prop("disabled", true);
        }

        return isValid;
    }

    function fn_existCrcNo(CustID, CrcNo, IssueBankID){
    	creditCardErrorMessage = "";
    	var resultInfo = null;
        var isExist = false;

        Common.ajax("GET", "/sales/customer/selectCustomerCreditCardJsonList", {custId : '', custCrcToken : CrcNo}, function(rsltInfo) {
            if(rsltInfo != null) {
                console.log('rsltInfo.length:'+JSON.stringify(rsltInfo));
                isExist = rsltInfo.length == 0 ? false : true;
                resultInfo = rsltInfo;
            }
        }, null, {async : false});
        console.log('isExist ggg:'+isExist);
        if(isExist){
        	var sameCustIdAndCardCheck = false;

        	for(var i = 0; i < resultInfo.length; i++){
        		if(resultInfo[i].custId == CustID){
        			sameCustIdAndCardCheck = true;
        		}
        	}
        	if(sameCustIdAndCardCheck){
        		creditCardErrorMessage = "<spring:message code='sal.alert.msg.creditCardIsExisting' /><br/>";
        	}
        	else{
        		creditCardErrorMessage = "This bank card is used by another customer.<br/>";
        	}
        }

        return isExist;
    }

    function fn_doSaveCreditCard() {
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
                        width: "768px", // 창 가로 크기
                        height: "250px" // 창 세로 크기
                    };

                if (option.isDuplicate) {
                    option.winName = option.winName + new Date();
                }

                var URL = '${mcPaymentUrl}' + r1.tknRef;

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
                                    if(r2.code == "99") { //FAILED
                                        Common.alert(r2.message);
                                    }
                                    else {
                                    	$("#cardNo").val(r2.data.bin + "******" + r2.data.cclast4);
                                        $("#tknId").val(r2.data.token);
                                        $("#cardExpr").val(r2.data.expr);

                                        fn_cardNoChangeFunc();
                                    }
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

            <input type="hidden" id="oriCustCrcNo" name="oriCustCrcNo">

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
                        <td colspan="3">
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
                        <th scope="row"><spring:message code="sal.text.nameOnCard" /><span class="must">*</span></th>
                        <td colspan="3">
                            <input type="text" title="" id="nameOnCard" name="nameOnCard" placeholder="Name On Card" class="w100p" />
                        </td>
                    </tr>
                    <tr>
                        <th scope="row"><spring:message code="sal.text.creditCardNo" /><span class="must">*</span></th>
                        <td>
                            <input class="" id="cardNo" name="cardNo" type="text" size="36" placeholder="Credit Card No" maxlength="36" style="width:90%" readonly />
                            <a href="javascript:fn_tokenPop();" class="search_btn" id="tokenizationBtn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
                        </td>
                        <th scope="row"><spring:message code="sal.text.expiryDate" /><span class="must">*</span></th>
                        <td>
                            <input type="text" title="" id="cardExpr" name="cardExpr" placeholder="Expiry" class="w100p" readonly />
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
