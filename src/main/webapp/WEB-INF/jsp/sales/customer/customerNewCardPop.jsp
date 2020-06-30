<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
<script src="https://www.onlinepayment.com.my/MOLPay/API/cse/checkout_dev.js"></script>
<script type="text/javascript">

console.log("custNewCardPop.jsp");

    $(document).ready(function() {

        //j_date
        var pickerOpts={
                changeMonth:true,
                changeYear:true,
                dateFormat: "dd/mm/yy"
        };

        $(".j_date").datepicker(pickerOpts);

        var monthOptions = {
            pattern: 'mm/yyyy',
            selectedYear: 2017,
            startYear: 2007,
            finalYear: 2027
        };

        $(".j_date2").monthpicker(monthOptions);

        var tempDate;
        //Date TransForm
        if("" !=$("#tempCrcExpr").val() && null != $("#tempCrcExpr").val()){
            tempDate = fn_transDateDBtoView($("#tempCrcExpr").val());
            $("#expDate").val(tempDate);
        }


        doGetCombo('/common/selectCodeList.do', '21', '', 'cmbCrcTypeId', 'S', '');      // cmbCrcTypeId(Card Type)
        doGetCombo('/sales/customer/selectCrcBank.do', '', '', 'cmbCrcBankId', 'S', ''); //cmbCrcBankId(Issue Bank<Card>)
        doGetCombo('/common/selectCodeList.do','115', '', 'cmbCardTypeId', 'S', '');  //cmbCardTypeId

        /*
        $("#custOriCrcNo").change(function() {
            $("#ccNumMPay").val($("#custOriCrcNo").val());
        });
        */

        $("#expDate").change(function() {
            var expDt =  $("#expDate").val();

            var expMth = expDt.substring(0, 1);
            var expYear = expDt.substring(3);

            $("#expMonthMPay").val(expMth);
            $("#expYearMPay").val(expYear);
        });

        //Update
        $("#_saveBtn").click(function() {

            /* disable params  */
            $("#custCrcTypeId").val($("#cmbCrcTypeId").val());

            /* Validation */
            //Credit Card Type
            if("" == $("#cmbCrcTypeId").val() || null == $("#cmbCrcTypeId").val()){
                Common.alert("<spring:message code='sal.alert.msg.pleaseSelectCreditCardType' />");
                return;
            }

            //Issue Bank
            if("" == $("#cmbCrcBankId").val() || null == $("#cmbCrcBankId").val()){
                Common.alert("<spring:message code='sal.alert.msg.pleaseSelectTheIssueBank' />");
                return;
            }

            //Name On Card (Card Owner)
            if("" == $("#custCrcOwner").val() || null == $("#custCrcOwner").val()){
                Common.alert("<spring:message code='sal.alert.msg.pleaseKeyInNameOnCard' />");
                return;
            }else{ // not null and not empty

                //special character
                var regExp = /^[a-zA-Z0-9 ]*$/i;
                if( regExp.test($("#custCrcOwner").val()) == false ){
                     Common.alert("* <spring:message code='sal.alert.NameOnCardCannotContainOfSpecChr' />");
                     return;
                }
            }

            //Card Type
            if("" == $("#cmbCardTypeId").val() || null == $("#cmbCardTypeId").val()){
                Common.alert("<spring:message code='sal.alert.pleaseSelectTheCardType' />");
                return;
            }

            //Token ID
            if("" == $("tknId").val() || null == $("#tknId").val()) {
                Common.alert("Credit card has not been encrypted!");
                return;
            }

            /* Update  */
            fn_customerCardInfoAddAjax();

        });

    });// document Ready Func End

    //date Form Translate(DB -> View)
    function fn_transDateDBtoView(tempCrcExpr){

        var crcMonth;
        var crcYear;
        var crcExpr;

        crcMonth = tempCrcExpr.substr(0, 2); //month
        crcYear = tempCrcExpr.substr(2, 2); //year

        if(crcYear >= 80){
            crcYear = '19' + crcYear;
        }else{
            crcYear = '20' + crcYear;
        }

        crcExpr = crcMonth + '/' + crcYear;
        return crcExpr;
    }

    //date Form Translate( View -> DB )
    function fn_transDateViewtoDB(insertCrcExpr){
        var insMonth;
        var insYear
        var expDate;

        insMonth = insertCrcExpr.substr(0, 2);
        insYear = insertCrcExpr.substr(5, 7);

        expDate = insMonth + insYear;

        return expDate;
    }

     //update Call Ajax
    function fn_customerCardInfoAddAjax(){
        $("#oriCustCrcNo").val($("#custOriCrcNo").val());

        Common.ajax("GET", "/sales/customer/insertCustomerCardAddAf.do", $("#addForm").serialize(), function(result) {
            Common.alert(result.message, fn_parentReload);
        })

        /*
        Common.ajax("GET", "/sales/customer/tokenPubKey.do", "", function(result) {
            var pub = "-----BEGIN PUBLIC KEY-----" + result.pubKey + "-----END PUBLIC KEY-----";
            var molpay = MOLPAY.encrypt( pub );

            $("#nameCard").val($("#custCrcOwner").val());

            form = document.getElementById('addForm');
            molpay.encryptForm(form);
            var form = $("#addForm").serialize();

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

                        Common.ajax("GET", "/sales/customer/tokenizationProcess.do", $("#addForm").serialize(), function(tResult) {
                            if(tResult.stus == "1" && tResult.crcCheck == "0") {
                                console.log("edit :: " + tResult.crcNo);
                                $("#custCrcExpr").val($("#_expMonth_").val() + $("#_expYear_").val().substring(2));
                                $("#custCrcNoMask").val(tResult.crcNo);
                                $("#token").val(tResult.token);

                                Common.ajax("GET", "/sales/customer/insertCustomerCardAddAf.do", $("#addForm").serialize(), function(uResult) {
                                    Common.alert(uResult.message, fn_parentReload);
                                });
                                $("#_cardPopCloseBtn").click();
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

    // Parent Reload Func
    function fn_parentReload() {
        fn_selectPstRequestDOListAjax(); //parent Method (Reload)
        $("#_close1").click();
        $("#_close").click();
        $("#_selectParam").val('5');
        Common.popupDiv('/sales/customer/updateCustomerCreditCardPop.do', $('#popForm').serializeJSON(), null , true , '_editDiv5');
        //Common.popupDiv('/sales/customer/updateCustomerNewCardPop.do', $("#popForm").serializeJSON(), null , true ,'_editDiv5New');
    }


    //카드번호 변경시 카드 타입 설정 func (Visa / Master)
    function fn_cardNoChangeFunc(custOriCrcNo){

        var crcNo;
        crcNo = custOriCrcNo;

        crcNo = crcNo.trim();
        //select 박스 초기화
        $("#cmbCrcTypeId").val("").prop("selected", true);

        //validation
        if("" != crcNo && null != crcNo){
            if('4' == crcNo.substr(0,1)){
                // 112
                doGetCombo('/common/selectCodeList.do', '21', '112', 'cmbCrcTypeId', 'S', '');   // cmbCrcTypeId(Card Type)
            }
            if('5' == crcNo.substr(0,1)){
                // 111
                doGetCombo('/common/selectCodeList.do', '21', '111', 'cmbCrcTypeId', 'S', '');  // cmbCrcTypeId(Card Type)
            }
        }
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
        //refId = (nric.length < 12 ? pad("0" + nric, 12) : nric) + (custId.length < 12 ? pad("0" + custId, 12) : nric) + crcId;
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
                                    $("#custOriCrcNo").val(r2.data.bin + "******" + r2.data.cclast4);
                                    $("#tknId").val(r2.data.token);
                                    $("#cardExpr").val(r2.data.expr);

                                    fn_cardNoChangeFunc($("#custOriCrcNo").val());
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
        <h1><spring:message code="sal.page.title.addCustCreditCard" /></h1>
        <ul class="right_opt">
            <li><p class="btn_blue2"><a href="#" id="_close1"><spring:message code="sal.btn.close" /></a></p></li>
        </ul>
    </header><!-- pop_header end -->

    <section class="pop_body"><!-- pop_body start -->

    <form id="addForm"><!-- form start  -->
        <input type="hidden" value="${insCustId}" id="custId" name="custId" />
        <input type="hidden" name="custCrcTypeId" id="custCrcTypeId" />

        <input type="hidden" id="nric" name="nric" value="${insNric}">
        <input type="hidden" id="hExpMonth" name="hExpMonth">
        <input type="hidden" id="hExpYear" name="hExpYear">
        <input type="hidden" id="etyPoint" name="etyPoint" value="EN">
        <input type="hidden" id="tknId" name="tknId">
        <input type="hidden" id="refNo" name="refNo">
        <input type="hidden" id="urlReq" name="urlReq">
        <input type="hidden" id="merchantId" name="merchantId">
        <input type="hidden" id="signature" name="signature">

        <input type="hidden" id="nameCard" name="nameCard">
        <input type="hidden" id="custCrcExpr" name="custCrcExpr">
        <input type="hidden" id="custCrcNoMask" name="custCrcNoMask">
        <input type="hidden" id="token" name="token">

        <input type="hidden" id="oriCustCrcNo" name="oriCustCrcNo">

        <table class="type1"><!-- table start -->
            <caption>table</caption>
            <colgroup>
                <col style="width:150px" />
                <col style="width:*" />
                <col style="width:130px" />
                <col style="width:*" />
            </colgroup>

            <tbody>
                <tr>
                    <th scope="row"><spring:message code="sal.text.issueBank" /><span class="must">*</span></th>
                    <td colspan="3">
                        <select class="w100p" id="cmbCrcBankId" name="custCrcBankId"></select>
                    </td>
                </tr>
                <tr>
                    <th scope="row"><spring:message code="sal.text.type" /><span class="must">*</span></th>
                    <td>
                        <select class="disabled w100p" id="cmbCrcTypeId" disabled="disabled" ></select>
                    </td>
                    <th scope="row"><spring:message code="sal.text.cardType" /><span class="must">*</span></th>
                    <td>
                        <select class="w100p" id="cmbCardTypeId" name="cardTypeId"></select>
                    </td>
                </tr>
                <tr>
                <th scope="row"><spring:message code="sal.text.nameOnCard" /><span class="must">*</span></th>
                <td colspan="3">
                    <input type="text" title="" id="custCrcOwner" name="custCrcOwner" placeholder="Name On Card" class="w100p" />
                </td>
            </tr>
            <tr>
                <th scope="row"><spring:message code="sal.text.creditCardNo" /><span class="must">*</span></th>
                <td>
                    <input class="" id="custOriCrcNo" name="custOriCrcNo" type="text" size="36" placeholder="Credit Card No" maxlength="36" style="width:90%" readonly />
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
                        <textarea cols="20" rows="5" name="custCrcRem"></textarea>
                    </td>
                </tr>
            </tbody>
        </table><!-- table end -->
    </form><!-- form end  -->

    <ul class="center_btns">
        <li><p class="btn_blue2 big"><a href="#" id="_saveBtn"><spring:message code="sal.btn.save" /></a></p></li>
    </ul>

</section><!-- pop_body end -->
</div>