<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javascript">
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

            //Exp Date
            if("" == $("#expDate").val() || null == $("#expDate").val()){
                Common.alert("<spring:message code='sal.alert.msg.pleaseSelectCreditCardExpDate' />");
                return;
            }else{
                //form Translate
                var trans;
                trans = fn_transDateViewtoDB($("#expDate").val());
                $("#expDate").val(trans);
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
        var checkCrc = {
                ccType : $("#cmbCrcTypeId").val(),
                ccBank : $("#cmbCrcBankId").val(),
                cardNo : $("#custOriCrcNo").val(),
                expDate : $("#expDate").val(),
                nameCard : $("#custCrcOwner").val(),
                cType : $("#cmbCardTypeId").val(),
                nric : "${insNric}",
                src : "EC"
            };

        console.log(checkCrc);

        Common.ajax("GET", "/sales/customer/checkCrc.do", checkCrc, function(result) {
            console.log(result);

            if(result != "0") {
                Common.alert("<b>WARNING!</b></br>This Bank card number is used by another customer.</br>Please inform respective HP/Cody.");
            } else {
                Common.ajax("GET", "/sales/customer/insertCustomerCardAddAf.do", $("#addForm").serialize(), function(result) {
                    Common.alert(result.message, fn_parentReload);
                });
            }
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
<input type="hidden" value="${insCustId}" id="_insCustId" name="insCustId" />
<input type="hidden" name="custCrcTypeId" id="custCrcTypeId" />
<input type="hidden" value="${insNric}" id="_insNric" name="insNric" />
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
    <th scope="row"><spring:message code="sal.text.type" /><span class="must">*</span></th>
    <td>
    <select class="disabled w100p" id="cmbCrcTypeId" disabled="disabled" ></select>
    </td>
    <th scope="row"><spring:message code="sal.text.issueBank" /><span class="must">*</span></th>
    <td>
    <select class="w100p" id="cmbCrcBankId" name="custCrcBankId"></select>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.creditCardNo" /><span class="must">*</span></th>
    <td><input type="text" title="" placeholder="Account Number" class="w100p"   name="custOriCrcNo"
    onchange="javascript : fn_cardNoChangeFunc(this.value)" id="custOriCrcNo" maxlength="16"/></td>
    <th scope="row"><spring:message code="sal.text.expiryDate" /><span class="must">*</span></th>
    <td><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date2 w100p"  readonly="readonly" id="expDate" name="custCrcExpr"/></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.nameOnCard" /><span class="must">*</span></th>
    <td><input type="text" title="" placeholder="" class="w100p"   maxlength="70" name="custCrcOwner" id="custCrcOwner" /></td>
    <th scope="row"><spring:message code="sal.text.cardType" /><span class="must">*</span></th>
    <td><select class="w100p" id="cmbCardTypeId" name="cardTypeId"></select></td>
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