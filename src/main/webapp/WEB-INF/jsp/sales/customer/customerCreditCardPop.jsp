<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
<script src="https://sandbox.molpay.com/MOLPay/API/cse/checkout_dev.js"></script>
<script type="text/javaScript">

console.log("customerCreditCardPop");

    doGetCombo('/common/selectCodeList.do', '21', '','_insCmbCreditCardType', 'S' , '');           // Add Card Type Combo Box
    doGetCombo('/common/selectCodeList.do', '115', '','_cmbCardType_', 'S' , '');           // Add Card Type Combo Box

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

    // card number에 따라 card type 변경
    function fn_selectCreditCardType(){
        if($("#_cardNo_").val().substr(0,1) == '4'){
            $("#_insCmbCreditCardType").val('112');
        }else if($("#_cardNo_").val().substr(0,1) == '5'){
            $("#_insCmbCreditCardType").val('111');
        }else{
            $("#_insCmbCreditCardType").val('');
        }
    }

    function fn_addCreditCard(){

        $("#oriCustCrcNo").val($("#_cardNo_").val());

        var ccType = document.insCardForm.cmbCreditCardType.value;
        var iBank = document.insCardForm.issueBank.value;
        var nameCard = document.insCardForm.nameCard.value;
        var cType = document.insCardForm.cmbCardType.value;
        var bankRem = document.insCardForm.bankRem.value;
        var cardNo = $("#_cardNo_").val();
        var encCrcNo = $("#oriCustCrcNo").val();
        var tknId = $("#tknId").val();
        var refNo = document.insCardForm.refNo.value;
        var cardExpr = $("#cardExpr").val();

        // Validation
        if(ccType == ""){
            Common.alert("<spring:message code='sal.alert.msg.pleaseSelectCreditCardType' />");
            return false;
        }

        if(iBank == ""){
            Common.alert("<spring:message code='sal.alert.msg.pleaseSelectTheIssueBank' />");
            return false;
        }

        if(cardNo == ""){
            Common.alert("<spring:message code='sal.alert.msg.pleaseKeyInCreditCardNum' />");
            return false;
        }else{
            //digit 16
            if(16 != $("#_cardNo_").val().length){
                Common.alert("<spring:message code='sal.alert.msg.creditCardNumMustIn16Digits' />");
                return false;
            }
        }
        if(nameCard == ""){
            Common.alert("<spring:message code='sal.alert.msg.pleaseKeyInNameOnCard' />");
            return false;
        }

        if(cType == ""){
            Common.alert("<spring:message code='sal.alert.pleaseSelectTheCardType' />");
            return false;
        }

        if(tknId == "") {
            Common.alert("Credit card information has not been encrypted yet.");
            return false;
        }

        var isExistCrc = fn_existCrcNo('', $("#tknId").val().trim());
        if(isExistCrc) {
            Common.alert("<spring:message code='sal.alert.msg.creditCardIsExisting' />");
            return false;
        }

        fn_addCreditCardInfo(ccType, iBank, cardNo, cardExpr, nameCard, cType, bankRem, tknId, encCrcNo, refNo);
        $("#_cardPopCloseBtn").click();
    }

    function fn_existCrcNo(CustID, CrcNo, IssueBankID){
        var isExist = false;

        Common.ajax("GET", "/sales/customer/selectCustomerCreditCardJsonList", {custId : CustID, custCrcToken : CrcNo}, function(rsltInfo) {
            if(rsltInfo != null) {
                console.log('rsltInfo.length:'+rsltInfo.length);
                isExist = rsltInfo.length == 0 ? false : true;
            }
        }, null, {async : false});
        console.log('isExist ggg:'+isExist);
        return isExist;
    }

    function pad (str, max) {
    	  str = str.toString();
    	  return str.length < max ? pad("0" + str, max) : str;
    }

    function fn_tokenPop() {
        console.log("tokenizationBtn :: click :: fn_tokenPop");

        var refId;

        if($("#nric").val() == "") {
            Common.alert("Please key in NRIC");
            return false;
        }

        var tokenPop, tokenTick;

        var nric = ($("#nric").val()).toString().trim().substr(0,12);
        var custId = "000000000000";
        var crcId = "000000000000";
        refId = (nric.length < 12 ? pad(nric, 12) : nric) + (custId.length < 12 ? pad(custId, 12) : nric) + crcId;
        console.log(refId);
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

                //var URL = "https://services.sandbox.mcpayment.net:8080/newCardForm?apiKey=AKIA5TZ_COWAY_YNAAZ6E&refNo=" + r1.tknRef; // MCP UAT Tokenization URL
                var URL = "https://services.mcpayment.net:8080/newCardForm?apiKey=3fdgsTZ_COWAY_dsaAZ6E&refNo=" + r1.tknRef;

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
                                    $("#_cardNo_").val(r2.data.bin + "******" + r2.data.cclast4);
                                    $("#tknId").val(r2.data.token);
                                    $("#cardExpr").val(r2.data.expr);

                                    fn_selectCreditCardType();
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
<h1><spring:message code="sal.page.title.custNewCreditCard" /></h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a id="_cardPopCloseBtn"><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->
<section class="pop_body"><!-- pop_body start -->

<form action="" id="insCardForm" name="insCardForm" method="POST">

    <input type="hidden" id="nric" name="nric" value="${nric}">
    <input type="hidden" id="hExpMonth" name="hExpMonth">
    <input type="hidden" id="hExpYear" name="hExpYear">
    <input type="hidden" id="etyPoint" name="etyPoint" value="NN">
    <input type="hidden" id="tknId" name="tknId">
    <input type="hidden" id="refNo" name="refNo">
    <input type="hidden" id="urlReq" name="urlReq">
    <input type="hidden" id="merchantId" name="merchantId">
    <input type="hidden" id="signature" name="signature">

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
                    <select class="w100p" id="_issueBank_" name="issueBank">
                       <option value="">Choose One</option>
                       <c:forEach var="list" items="${bankList }">
                           <option value="${list.bankId}">${list.code} - ${list.codeName}</option>
                       </c:forEach>
                    </select>
                </td>
            </tr>
            <tr>
                <th scope="row"><spring:message code="sal.text.type" /><span class="must">*</span></th>
                <td>
                    <select class="w100p disabled" id="_insCmbCreditCardType" name="cmbCreditCardType" disabled="disabled">
                    </select>
                </td>
                <th scope="row"><spring:message code="sal.text.cardType" /><span class="must">*</span></th>
                <td>
                    <select class="w100p" id="_cmbCardType_" name="cmbCardType">
                    </select>
                </td>
            </tr>
            <tr>
                <th scope="row"><spring:message code="sal.text.nameOnCard" /><span class="must">*</span></th>
                <td colspan="3">
                    <input type="text" title="" id="_nameCard_" name="nameCard" placeholder="Name On Card" class="w100p" />
                </td>
            </tr>
            <tr>
                <th scope="row"><spring:message code="sal.text.creditCardNo" /><span class="must">*</span></th>
                <td>
                    <input class="" id="_cardNo_" name="_cardNo_" type="text" size="36" placeholder="Credit Card No" maxlength="36" style="width:90%" readonly />
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
                    <textarea cols="20" rows="5" id="_bankRem_" name="bankRem" placeholder="Remark"></textarea>
                </td>
            </tr>
        </tbody>
    </table><!-- table end -->
    </form>
    <ul class="center_btns">
        <li><p class="btn_blue2 big"><a href="#" onclick="fn_addCreditCard()"><spring:message code="sal.btn.addCreditCard" /></a></p></li>
    </ul>
</section><!-- pop_body end -->
</div>