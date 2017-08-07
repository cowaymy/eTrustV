<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">


doGetCombo('/common/selectCodeList.do', '20', '','cmbBankType', 'S' , '');                         // Add Bank Type Combo Box

//	function fn_accValidation(){
//	    if($("#cmbBankType").val() == ''){
//	        alert("Please select the account type");
//	        return false;
//	    }
//	    if($("#accBank").val() == ''){
//	        alert("Please select issue bank");
//	        return false;
//	    }
//	    if($("#accNo").val() == ''){
//	        alert("Please key in the bank account number");
//	        return false;
//	    }
//	    if($("#accOwner").val() == ''){
//	        alert("Please key in the bank account owner name");
//	        return false;
//	    }
//	    
//	    return true;
//	}
	
	function fn_addBankAccount(){
        var accType = document.insAccountForm.cmbBankType.value;
        var accBank = document.insAccountForm.accBank.value;
        var accNo = document.insAccountForm.accNo.value;
        var bankBranch = document.insAccountForm.bankBranch.value;
        var accOwner = document.insAccountForm.accOwner.value;
        var accRem = document.insAccountForm.accRem.value;
        
        if(accType == ''){
            alert("Please select the account type");
            return false;
        }
        if(accBank == ''){
            alert("Please select issue bank");
            return false;
        }
        if(accNo == ''){
            alert("Please key in the bank account number");
            return false;
        }
        if(accOwner == ''){
            alert("Please key in the bank account owner name");
            return false;
        }

        opener.fn_addBankAccountInfo(accType,accBank,accNo,bankBranch,accOwner,accRem);
        self.close();
    }
</script>

<!--<div id="popup_wrap"> popup_wrap start --

<header class="pop_header">-- pop_header start --
<h1>Add Bank Account</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->
<form action="" id="insAccountForm" name="insAccountForm" method="GET">
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
				    <select class="w100p disabled" id="cmbBankType" name="cmbBankType">
				    </select>
			    </td>
			    <th scope="row">Issue Bank<span class="must">*</span></th>
			    <td>
				    <select class="w100p" id="accBank" name="accBank">
				        <option value="">Choose One</option>
				        <c:forEach var="list" items="${accBankList }">
                           <option value="${list.bankId}">${list.codeName}</option>
                        </c:forEach>
				    </select>
			    </td>
			</tr>
			<tr>
			    <th scope="row">Account No<span class="must">*</span></th>
			    <td>
			        <input type="text" id="accNo" name="accNo" title="" placeholder="Account No" class="w100p" />
			    </td>
			    <th scope="row">Bank Branch</th>
			    <td>
			        <input type="text" id="bankBranch" name="bankBranch" title="" placeholder="Bank Branch" class="w100p" />
			    </td>
			</tr>
			<tr>
			    <th scope="row">Account Owner<span class="must">*</span></th>
			    <td colspan="3">
			        <input type="text" id="accOwner" name="accOwner" title="" placeholder="Account Owner" class="w100p" />
			    </td>
			</tr>
			<tr>
			    <th scope="row">Remarks</th>
			    <td colspan="3">
			        <textarea cols="20" rows="5" id="accRem" name="accRem" placeholder="Remark"></textarea>
			    </td>
			</tr>
		</tbody>
	</table><!-- table end -->
	
	<ul class="center_btns">
	    <li><p class="btn_blue2 big"><a href="#" onclick="fn_addBankAccount()">Add Bank Account</a></p></li>
	</ul>
</form>
</section><!-- pop_body end -->

<!--</div> popup_wrap end -->
