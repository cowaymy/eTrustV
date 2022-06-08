<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
<script src="https://www.onlinepayment.com.my/MOLPay/API/cse/checkout_dev.js"></script>
<script type="text/javaScript">

console.log("teststeest");
console.log("tokenpoptest");

    doGetCombo('/common/selectCodeList.do', '21', '','_insCmbCreditCardType', 'S' , '');           // Add Card Type Combo Box
    doGetCombo('/common/selectCodeList.do', '115', '','_cmbCardType_', 'S' , '');           // Add Card Type Combo Box

    $(document).ready(function() {
       console.log("tokenCustomerCreditCardTest");
    });

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

    $("#nric").blur(function() {
        //refNo
        if($("#nric").val().length != 12) {
            Common.alert("nric length");
            $("#nric").val("");
            return false;
        }

        var d12 = "000000000000";
        $("#refNo").val($("#nric").val() + d12 + d12);
    });

    function fn_tokenPop() {
        console.log("tokenizationBtn :: click :: fn_tokenPop");

        if($("#refNo").val() == "") {
            Common.alert("refNo Empty");
            return false;
        }

        var tokenPop, tokenTick;
        //var refId = '000101147799000000000000000000000000';
        var refId = $("#refNo").val();
        Common.ajax("GET", "/sales/customer/getTknId.do", {refId : refId}, function(r1) {
            if(r1.tknId != 0) {
                // Requires further discuss with MC Payment if add another 10 space for token ID
                // NRIC/Co. registration no (12) + CID (12) + CRC ID (12);
                //refId = refId + r1.tknId;

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

                var URL = "https://services.uat.mcpayment.net:8080/newCardForm?apiKey=AKIA5TZ_COWAY_YNAAZ6E_ERROR&refNo=" + r1.tknRef; // MCP UAT Tokenization URL
                //var URL = "https://services.mcpayment.net:8080/newCardForm?apiKey=3fdgsTZ_COWAY_dsaAZ6E&refNo=" + r1.tknRef;

                //tokenPop = window.open("https://services.sandbox.mcpayment.net:8080/newCardForm?apiKey=AKIA5TZ_COWAY_YNAAZ6E&refNo=32135" + refId);
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
                                	else{
	                                    $("#crcNo").val(r2.data.bin + "******" + r2.data.cclast4);
	                                    $("#tknId").val(r2.data.tokenNumber);
                                    }
                                }
                            });
                        }
                    }, 500);
            }
        });
    }

    // card number에 따라 card type 변경
    function fn_selectCreditCardType(){
        if($("#_cardNo_").val().substr(0,1) == '4'){
            $("#_insCmbCreditCardType").val('112');
        }else if($("#_cardNo_").val().substr(0,1) == '5'){
            $("#_insCmbCreditCardType").val('111');
        }else{
            $("#_insCmbCreditCardType").val('');
        }

        $("#ccNumMPay").val($("#_cardNo_").val());
    }

    function fn_addCreditCard(){

        $("#oriCrcNo").val($("#_cardNo_").val());

        Common.ajax("GET", "/sales/customer/tokenPubKey.do", "", function(result) {
            var pub = "-----BEGIN PUBLIC KEY-----" + result.pubKey + "-----END PUBLIC KEY-----";
            var molpay = MOLPAY.encrypt( pub );

            var ccType = document.insCardForm.cmbCreditCardType.value;
            var iBank = document.insCardForm.issueBank.value;
            var nameCard = document.insCardForm.nameCard.value;
            var cType = document.insCardForm.cmbCardType.value;
            var bankRem = document.insCardForm.bankRem.value;
            var cardNo = $("#_cardNo_").val();
            var expMonth = $("#_expMonth_").val();
            var expYear = $("#_expYear_").val();

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
                // number Check
                if(FormUtil.checkNum($("#_cardNo_"))){
                    Common.alert("<spring:message code='sal.alert.msg.invalidCreditCardNum' />");
                    return false;
                }

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
                }
            }

            expDate = expMonth + "/" + expYear;

            form = document.getElementById('insCardForm');
            molpay.encryptForm(form);
            var form = $("#insCardForm").serialize();

            console.log(form);

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

                        Common.ajax("GET", "/sales/customer/tokenizationProcess.do", $("#insCardForm").serialize(), function(tResult) {
                            if(tResult.stus == "1" && tResult.crcCheck == "0") {
                                /*fn_addCreditCardInfo(ccType, iBank, tResult.crcNo, expDate, nameCard, cType, bankRem, tResult.token);
                                $("#_cardPopCloseBtn").click();*/
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

    function fn_tknBatch() {
        console.log("fn_tknBatch");
        Common.ajax("GET", "/sales/CustomerCRCController/batchSFTP.do", "", function(result) {
           console.log("batchSFTP");
           console.log(result);
        });
    }
</script>

<style>
    .tap_block{
        margin-top:10px;
        margin-bottom:10px;
        border:1px solid #ccc;
        padding:10px;
        border-radius:3px;
    }
</style>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->
<header class="pop_header"><!-- pop_header start -->
<h1>Token Credit Card Test</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a id="_cardPopCloseBtn"><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->
<section class="pop_body"><!-- pop_body start -->

<form action="" id="insCardForm" name="insCardForm" method="POST">

<!--
    <input type="hidden" id="nric" name="nric" value="${nric}">
    <input type="hidden" id="hExpMonth" name="hExpMonth">
    <input type="hidden" id="hExpYear" name="hExpYear">
    <input type="hidden" id="etyPoint" name="etyPoint" value="NN">
    <input type="hidden" id="tknId" name="tknId">
    <input type="hidden" id="refNo" name="refNo">
    <input type="hidden" id="urlReq" name="urlReq">
    <input type="hidden" id="merchantId" name="merchantId">
    <input type="hidden" id="signature" name="signature">
 -->

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
                <td colspan="3">
                    <input class="" id="crcNo" name="tknNo" type="text" size="36" placeholder="Credit Card ID" maxlength="36" style="width:96%" readonly />
                    <a href="javascript:fn_tokenPop();" class="search_btn" id="tokenizationBtn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
                </td>
            </tr>
            <!--
            <tr>
                <th scope="row"><spring:message code="sal.text.creditCardNo" /><span class="must">*</span></th>
                <td>
                    <input class="w100p" id="_cardNo_" type="text" size="20" data-encrypted-name="PAN" placeholder="Credit Card No" maxlength="16" onBlur="fn_selectCreditCardType()" required/>
                </td>
                <th scope="row"><spring:message code="sal.text.nameOnCard" /><span class="must">*</span></th>
                <td>
                    <input type="text" title="" id="_nameCard_" name="nameCard" placeholder="Name On Card" class="w100p" />
                </td>
            </tr>
            <tr>
                <th scope="row">Expiry Month<span class="must">*</span></th>
                <td>
                    <input class="w100p" id="_expMonth_" type="text" size="20" data-encrypted-name="EXPMONTH" placeholder="Expiry Month (MM)" maxlength="2" required/>
                </td>
                <th scope="row">Expiry Year<span class="must">*</span></th>
                <td>
                    <input class="w100p" id="_expYear_" type="text" size="20" data-encrypted-name="EXPYEAR" placeholder="Expiry Year (YYYY)" min="4" maxlength="4" required/>
                </td>
            </tr>
             -->
            <tr>
                <th scope="row"><spring:message code="sal.text.remark" /></th>
                <td colspan="3">
                    <textarea cols="20" rows="5" id="_bankRem_" name="bankRem" placeholder="Remark"></textarea>
                </td>
            </tr>
        </tbody>
    </table><!-- table end -->

    <article class="tap_block">
        <aside class="title_line">
            <b style="color:#25527c;">Hidden Fields (Encrypted)</b>
        </aside>

        <table class="type1">
        <caption>table</caption>
        <colgroup>
            <col style="width:180px" />
            <col style="width:*" />
            <col style="width:180px" />
            <col style="width:*" />
        </colgroup>

        <tbody>
            <tr>
                <th scope="row">Hidden NRIC</th>
                <td>
                    <input type="text" class="w100p" id="nric" name="nric">
                </td>
                <th scope="row">etyPoint</th>
                <td>
                    <input type="text" class="w100p" id="etyPoint" name="etyPoint" value="NN" readonly />
                </td>
            </tr>
            <tr>
                <th scope="row">hExpMonth</th>
                <td>
                    <input type="text" class="w100p" id="hExpMonth" name="hExpMonth">
                </td>
                <th scope="row">hExpYear</th>
                <td>
                    <input type="text" class="w100p" id="hExpYear" name="hExpYear">
                </td>
            </tr>
            <tr>
                <th scope="row">tknId</th>
                <td>
                    <input type="text" class="w100p" id="tknId" name="tknId">
                </td>
                <th scope="row">refNo</th>
                <td>
                    <input type="text" class="w100p" id="refNo" name="refNo">
                </td>
            </tr>
            <tr>
                <th scope="row">urlReq</th>
                <td>
                    <input type="text" class="w100p" id="urlReq" name="urlReq">
                </td>
                <th scope="row">merchantId</th>
                <td>
                    <input type="text" class="w100p" id="merchantId" name="merchantId">
                </td>
            </tr>
            <tr>
                <th scope="row">OriCrcNo</th>
                <td colspan="3">
                    <input type="text" class="w100p" id="oriCrcNo" name="oriCrcNo">
                </td>
            </tr>
            <tr>
                <th scope="row">signature</th>
                <td colspan="3">
                    <input type="text" class="w100p" id="signature" name="signature">
                </td>
            </tr>
        </tbody>
    </table>
    </article>

    </form>
    <ul class="center_btns">
        <li><p class="btn_blue2 big"><a href="#" onclick="fn_addCreditCard()"><spring:message code="sal.btn.addCreditCard" /></a></p></li>
        <li><p class="btn_blue2 big"><a href="#" onclick="fn_tknBatch()">Test Token Batch</a></p></li>
    </ul>
</section><!-- pop_body end -->
</div>