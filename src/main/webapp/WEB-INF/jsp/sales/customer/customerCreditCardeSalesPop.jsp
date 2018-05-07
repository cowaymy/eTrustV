<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">


    doGetCombo('/common/selectCodeList.do', '21', '','_insCmbCreditCardType', 'S' , '');           // Add Card Type Combo Box
    doGetCombo('/common/selectCodeList.do', '115', '','_cmbCardType_', 'S' , '');           // Add Card Type Combo Box

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
		var ccType = document.insCardForm.cmbCreditCardType.value;
		var iBank = document.insCardForm.issueBank.value;
		var cardNo = document.insCardForm.cardNo.value;
		var expDate = document.insCardForm.expDate.value;
		var nameCard = document.insCardForm.nameCard.value;
		var cType = document.insCardForm.cmbCardType.value;
		var bankRem = document.insCardForm.bankRem.value;

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
        if(expDate == ""){
            Common.alert("<spring:message code='sal.alert.msg.pleaseSelectCreditCardExpDate' />");
            return false;
        }
        if(nameCard == ""){
            Common.alert("<spring:message code='sal.alert.msg.pleaseKeyInNameOnCard' />");
            return false;
        }
        if(cType == ""){
            Common.alert("<spring:message code='sal.alert.pleaseSelectTheCardType' />");
            return false;
        }

        //insert
		fn_addCreditCardInfo(ccType,iBank,cardNo,expDate,nameCard,cType,bankRem);
		//close
		$("#_cardPopCloseBtn").click();
	}
</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->
<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="sal.page.title.custNewCreditCard2" /></h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a id="_cardPopCloseBtn"><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->
<section class="pop_body"><!-- pop_body start -->
<form action="" id="insCardForm" name="insCardForm" method="GET">
	<table class="type1"><!-- table start -->
		<caption>table</caption>
		<colgroup>
		    <col style="width:360px" />
		    <col style="width:*" />
		</colgroup>
		<tbody>
		    <tr>
                <th scope="row"><spring:message code="sal.text.creditCardNo2" /><span class="must">*</span></th>
                <td>
                <input type="text" title="" id="_cardNo_" name="cardNo" maxlength="16" placeholder="Credit Card No" onBlur="fn_selectCreditCardType()" class="w100p" />
                </td>
            </tr>
            <tr>
                <th scope="row"><spring:message code="sal.text.issueBank2" /><span class="must">*</span></th>
                <td>
                    <select class="w100p" id="_issueBank_" name="issueBank">
                       <option value="">Choose One</option>
                       <c:forEach var="list" items="${bankList }">
                           <option value="${list.bankId}">${list.code} - ${list.codeName}</option>
                       </c:forEach>
                    </select>
                </td>
            </tr>
            <tr>
                <th scope="row"><spring:message code="sal.text.nameOnCard2" /><span class="must">*</span></th>
                <td>
                <input type="text" title="" id="_nameCard_" name="nameCard" placeholder="Name On Card" class="w100p" />
                </td>
            </tr>
            <tr>
			    <th scope="row"><spring:message code="sal.text.expiryDate2" /><span class="must">*</span></th>
			    <td>
			    <input type="text" title="Create start Date" id="_expDate_" name="expDate" placeholder="MM/YYYY" class="j_date2" />
			    </td>
			</tr>
            <tr>
			    <th scope="row"><spring:message code="sal.text.cardType2" /><span class="must">*</span></th>
			    <td>
                    <select class="w100p" id="_cmbCardType_" name="cmbCardType">
                    </select>
			    </td>
			</tr>
			<tr>
                <th scope="row"><spring:message code="sal.text.type2" /><span class="must">*</span></th>
                <td>
                    <select class="w100p disabled" id="_insCmbCreditCardType" name="cmbCreditCardType" disabled="disabled">
                    </select>
                </td>
            </tr>
			<%-- <tr>
			    <th scope="row"><spring:message code="sal.text.remark" /></th>
			    <td colspan="3">
			    <textarea cols="20" rows="5" id="_bankRem_" name="bankRem" placeholder="Remark"></textarea>
			    </td>
			</tr> --%>
		</tbody>
	</table><!-- table end -->
	</form>
	<ul class="center_btns">
	    <li><p class="btn_blue2 big"><a href="#" onclick="fn_addCreditCard()"><spring:message code="sal.btn.addCreditCard2" /></a></p></li>
	</ul>
</section><!-- pop_body end -->
</div>