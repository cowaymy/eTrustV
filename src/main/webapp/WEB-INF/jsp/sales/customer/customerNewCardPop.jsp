<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
<script src="https://sandbox.molpay.com/MOLPay/API/cse/checkout_dev.js"></script>
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

            //Credit Card No
            if("" == $("#custOriCrcNo").val() || null == $("#custOriCrcNo").val()){
                Common.alert("<spring:message code='sal.alert.msg.pleaseKeyInCreditCardNum' />");
                return;
            }else{// not null and not empty

                // number Check
                if(FormUtil.checkNum($("#custOriCrcNo"))){
                    Common.alert("<spring:message code='sal.alert.msg.invalidCreditCardNum' />");
                    return;
                }

                //digit 16
                if(16 != $("#custOriCrcNo").val().length){
                    Common.alert("<spring:message code='sal.alert.msg.creditCardNumMustIn16Digits' />");
                    return;
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
                }
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

            /* Update  */
            fn_customerCardInfoAddAjax();

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
                    <th scope="row"><spring:message code="sal.text.creditCardNo" /><span class="must">*</span></th>
                    <td>
                        <input class="w100p" id="custOriCrcNo" type="text" size="20" data-encrypted-name="PAN" placeholder="Account Number" maxlength="16" onchange="javascript : fn_cardNoChangeFunc(this.value)" required/>
                    </td>
                    <!-- <th scope="row"><spring:message code="sal.text.expiryDate" /><span class="must">*</span></th>
                    <td>
                        <input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date2 w100p"  readonly="readonly" id="expDate" name="custCrcExpr"/></td>
                    </tr> -->
                    <th scope="row"><spring:message code="sal.text.nameOnCard" /><span class="must">*</span></th>
                    <td>
                        <input type="text" title="" placeholder="" class="w100p"   maxlength="70" name="custCrcOwner" id="custCrcOwner" />
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