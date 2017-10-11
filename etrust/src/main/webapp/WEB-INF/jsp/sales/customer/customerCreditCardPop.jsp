<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">


    doGetCombo('/common/selectCodeList.do', '21', '','cmbCreditCardType', 'S' , '');           // Add Card Type Combo Box
    doGetCombo('/common/selectCodeList.do', '115', '','cmbCardType', 'S' , '');           // Add Card Type Combo Box
    
    // card number에 따라 card type 변경
    function fn_selectCreditCardType(){
    	if($("#cardNo").val().substr(0,1) == '4'){
    		$("#cmbCreditCardType").val('112');
    	}else if($("#cardNo").val().substr(0,1) == '5'){
    		$("#cmbCreditCardType").val('111');
    	}else{
    		$("#cmbCreditCardType").val('');
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
			Common.alert("Please select credit card type.");
            return false;
        }
        if(iBank == ""){
            Common.alert("Please select issue bank.");
            return false;
        }
        if(cardNo == ""){
            Common.alert("Please key in credit card number.");
            return false;
        }else{
        	// number Check
            if(FormUtil.checkNum($("#cardNo"))){ 
                Common.alert("* Invalid credit card number.");
                return false;
            }
            
            //digit 16
            if(16 != $("#cardNo").val().length){
                Common.alert("* Credit card number must in 16 digits.");
                return false;
            }
        }
        if(expDate == ""){
            Common.alert("Please select credit card expiry date.");
            return false;
        }
        if(nameCard == ""){
            Common.alert("Please key in name on card.");
            return false;
        }
        if(cType == ""){
            Common.alert("Please select the card type.");
            return false;
        }

		opener.fn_addCreditCardInfo(ccType,iBank,cardNo,expDate,nameCard,cType,bankRem);
		self.close();
	}
</script>

<section class="pop_body"><!-- pop_body start -->
<form action="" id="insCardForm" name="insCardForm" method="GET">
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
			    <th scope="row">Type<span class="must">*</span></th>
			    <td>
				    <select class="w100p disabled" id="cmbCreditCardType" name="cmbCreditCardType" disabled="disabled">
				    </select>
			    </td>
			    <th scope="row">Issue Bank<span class="must">*</span></th>
			    <td>
				    <select class="w100p" id="issueBank" name="issueBank">
				       <option value="">Choose One</option>
				       <c:forEach var="list" items="${bankList }">
			               <option value="${list.bankId}">${list.code} - ${list.codeName}</option>
			           </c:forEach>
				    </select>
			    </td>
			</tr>
			<tr>
			    <th scope="row">Credit Card No<span class="must">*</span></th>
			    <td>
			    <input type="text" title="" id="cardNo" name="cardNo" maxlength="16" placeholder="Credit Card No" onBlur="fn_selectCreditCardType()" class="w100p" />
			    </td>
			    <th scope="row">Expiry Date<span class="must">*</span></th>
			    <td>
			    <input type="text" title="Create start Date" id="expDate" name="expDate" placeholder="MM/YYYY" class="j_date2" />
			    </td>
			</tr>
			<tr>
			    <th scope="row">Name On Card<span class="must">*</span></th>
			    <td>
			    <input type="text" title="" id="nameCard" name="nameCard" placeholder="Name On Card" class="w100p" />
			    </td>
			    <th scope="row">Card Type<span class="must">*</span></th>
			    <td>
                    <select class="w100p" id="cmbCardType" name="cmbCardType">
                    </select>
			    </td>
			</tr>
			<tr>
			    <th scope="row">Remarks</th>
			    <td colspan="3">
			    <textarea cols="20" rows="5" id="bankRem" name="bankRem" placeholder="Remark"></textarea>
			    </td>
			</tr>
		</tbody>
	</table><!-- table end -->
	</form>
	<ul class="center_btns">
	    <li><p class="btn_blue2 big"><a href="#" onclick="fn_addCreditCard()">Add Credit Card</a></p></li>
	</ul>
</section><!-- pop_body end -->