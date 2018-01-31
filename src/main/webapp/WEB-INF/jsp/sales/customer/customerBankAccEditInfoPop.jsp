<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javascript">

    $(document).ready(function() {
		
    	var selCodeAccType = $("#selCodeAccType").val();
    	var selCodeAccBankId = $("#selCodeAccBankId").val();
    	
    	doGetCombo('/common/selectCodeList.do', '20', selCodeAccType, 'bankCmbAccTypeId', 'S', ''); // cmbAccTypeId(Type) 
    	doGetCombo('/sales/customer/selectAccBank.do', '', selCodeAccBankId, 'bankCmbAccBankId', 'S', '')//selCodeAccBankId(Issue Bank)
    	
    	
    	$("#_updBtn").click(function(){
           
    		//Account Type
    		if("" == $("#bankCmbAccTypeId").val() || null == $("#bankCmbAccTypeId").val()){
    			Common.alert("<spring:message code='sys.common.alert.validation' arguments='Account Type'/>");
    			return;
    		}
    		
    		//Issue Bank
    		if("" == $("#bankCmbAccBankId").val() || null == $("#bankCmbAccBankId").val()){
    			Common.alert("<spring:message code='sys.common.alert.validation' arguments='Issue Bank'/>");
                return;
    		}
    		
    		//Account No. IssueBankId = $("#cmbAccBankId").val() , AccountNo = $("#accountNo").val()
    		if("" == $("#bankAccountNo").val() || null == $("#bankAccountNo").val()){
    			Common.alert("<spring:message code='sys.common.alert.validation' arguments='Account Number'/>");
    			return;
    		}else{ //not Null or Empty
    			
    			//number check
    			if(FormUtil.checkNum($("#bankAccountNo"))){
    				Common.alert("<spring:message code='sys.common.alert.validation' arguments='Account Number'/>");
    				return;
    			}
    			
    			var bankId; //bank Account Id
    			var AccNo; //Account Number
    			var lengResult = true; // true/false
    			var availableResult = false; // true/false
    			
    			// 1.get Params
    			bankId =  $("#bankCmbAccBankId").val();
    			AccNo = $("#bankAccountNo").val();
    			
    			// 2. Account No Validation
    			/* length validation  */
    			lengResult = fn_lengthCheck(bankId, AccNo);
    			if(lengResult == false){
    				Common.alert("<spring:message code='sal.alert.msg.invalidBankAccNum' />");
    				return;
    			} 
    			
    			/* availability validation */
    			availableResult = fn_availabilityCheck(bankId, AccNo);
    			if(availableResult == true){
    				Common.alert("<spring:message code='sal.alert.msg.invalidBankAccNum' />");
                    return;
    			}
    		}
    		
    		//Account Owner
    		if("" == $("#bankCustAccOwner").val() || null == $("#bankCustAccOwner").val()){
    			Common.alert("<spring:message code='sys.common.alert.validation' arguments='Account Owner'/>");
                return;
    		}
    		
    		//update 
    		 fn_customerBankInfoUpdateAjax();
        });
    	
    	 $("#_delBtn").click(function() {
    	       Common.confirm("<spring:message code='sal.alert.msg.areYouSureWannaDelThisBankAcc' />", fn_deleteBankAjax);
   	     });
	});
    
    //update Call Ajax
    function fn_customerBankInfoUpdateAjax(){
    	Common.ajax("GET", "/sales/customer/updateCustomerBankInfoAf.do", $("#updForm").serialize(), function(result) {
    		Common.alert("<spring:message code='sal.alert.msg.successfully' />", fn_parentReload);
    	});
    }
    
    // Parent Reload Func
    function fn_parentReload() {
    	fn_selectPstRequestDOListAjax(); //parent Method (Reload)
        $("#_close1").click();
        $("#_close").click();
        $("#_selectParam").val('4');
        Common.popupDiv('/sales/customer/updateCustomerBankAccountPop.do', $('#popForm').serializeJSON(), null , true, '_editDiv4');
        Common.popupDiv("/sales/customer/updateCustomerBankAccEditInfoPop.do", $('#editForm').serializeJSON(), null , true, '_editDiv4Pop');
    }
    
    //delete
    function fn_deleteBankAjax(){
        
        Common.ajax("GET", "/sales/customer/deleteCustomerBank.do", $("#updForm").serialize(), function(result){
            //result alert and closePage
            Common.alert(<spring:message code='sal.alert.msg.successfully' />, fn_closePage);
        });
    }
    
    //Parent Reload and PageClose Func
    function fn_closePage(){
    	fn_selectPstRequestDOListAjax(); //parent Method (Reload)
        $("#_close1").click();
        $("#_close").click();
        $("#_selectParam").val('4');
        Common.popupDiv('/sales/customer/updateCustomerBankAccountPop.do', $('#popForm').serializeJSON(), null , true, '_editDiv4');
    }
    
    
    /* ########## length Check Start ##########*/
    function fn_lengthCheck(bankId, AccNo){
    	
    	var valid = true; //result
    	var lengthOfAccNo = AccNo.length;
    	
    	//MAYBANK
    	if(bankId == 21 || bankId == 30){
    		if(lengthOfAccNo != 12){
    			valid = false;
    			return valid;
    		}
    	}
    	//CIMB BANK
    	if(bankId == 3 || bankId == 36){
    		
    		if(lengthOfAccNo != 14 && lengthOfAccNo != 10){
    			valid = false;
    			return valid;
    		}
    	}
    	//PUBLIC BANK
    	if(bankId == 6 || bankId == 32){
    		if(lengthOfAccNo != 10){
    			valid = false;
    			return valid;
    		}
    	}
    	//RHB BANK
    	if(bankId == 7 || bankId == 33){
    		if(lengthOfAccNo != 14){
    			valid = false;
    			return valid;
    		}
    	}
    	//ALLIANCE BANK
    	if(bankId == 2 || bankId == 35){
    		if(lengthOfAccNo != 15){
    			valid = false;
    			return valid;
    		}
    	}
    	//HONG LEONG BANK
    	if(bankId == 5 || bankId == 29){
    		if(lengthOfAccNo != 11){
    			valid = false;
    			return valid;
    		}
    	}
    	//BANK SIMPANAN NASIONAL
    	if(bankId == 9 || bankId ==26){
    		if(lengthOfAccNo != 16){
    			valid = false;
    			return valid;
    		}
    	}
    	//MY CLEAR - BANK RAKYAT
    	if(bankId == 25){
    		if(lengthOfAccNo != 12){
    			valid = false;
    			return valid;
    		}
    	}
    	//MY CLEAR - BANK ISLAM
    	if(bankId == 10){
    		if(lengthOfAccNo != 14){
                valid = false;
                return valid;
            }
    	}
    	//MY CLEAR - HSBC
    	if(bankId == 17){
            if(lengthOfAccNo != 12){
                valid = false;
                return valid;
            }
        }
    	//MY CLEAR - OCBC
    	if(bankId == 18){
            if(lengthOfAccNo != 10){
                valid = false;
                return valid;
            }
        }
    	//MY CLEAR - STANDARD CHARTED
    	if(bankId == 19 || bankId == 34){
            if(lengthOfAccNo < 5 || lengthOfAccNo > 17){
                valid = false;
                return valid;
            }
        }
    	//MY CLEAR - CITIBANK
    	if(bankId == 16){
            if(lengthOfAccNo < 9 || lengthOfAccNo > 16){
                valid = false;
                return valid;
            }
        }
    	//MY CLEAR - DEUTCHE BANK
    	if(bankId == 27){
            if(lengthOfAccNo < 10 || lengthOfAccNo > 14){
                valid = false;
                return valid;
            }
        }
    	//MY CLEAR - BANK OF AMARICA
    	if(bankId == 13){
            if(lengthOfAccNo != 12){
                valid = false;
                return valid;
            }
        }
    	//MY CLEAR - J.P MORGAN
    	if(bankId == 45){
            if(lengthOfAccNo != 10){
                valid = false;
                return valid;
            }
        }
    	
    	return valid;
    }
    /*########## length Check End ##########*/
    
    /*########## availability Check Start ##########*/
    function fn_availabilityCheck(bankId, AccNo){
    	
    	var isReject = false; //result
    	
    	//MAYBANK
    	if(bankId == 21 || bankId == 30){
    		if(AccNo.substr(0,1).trim() ==  '4'){
    			isReject = true;
    			return isReject;
    		}
    	}
    	
    	//CIMB BANK
    	if(bankId == 3 || bankId == 36){
    		if(AccNo.length == 14){
    			console.log (AccNo.substr(11,1).trim());
    			if(AccNo.substr(11,1).trim() == 9 || AccNo.substr(11,1).trim() == 2 || AccNo.substr(11,1).trim() == 1){
    				isReject = true;
                    return isReject;
    			}
    		}
    	}
    	
    	//PUBLIC BANK
    	if(bankId == 6 || bankId == 32){
    		if(AccNo.substr(0,1).trim() == '2' || AccNo.substr(0,1).trim() == '8'){
    			isReject = true;
                return isReject;
    		}
    	}
    	
    	//RHB BANK
    	if(bankId == 7 || bankId == 33){
            if(AccNo.substr(0,1).trim() == '7'){
                isReject = true;
                return isReject;
            }
        }
    	
    	//HONG LEONG BANK
    	if(bankId == 5 || bankId == 29){
    		if(AccNo.substr(3,1).trim() == '8' || AccNo.substr(3,1).trim() == '9'){
    			 isReject = true;
                 return isReject;
    		}
    	}
    	return isReject;
    }
    /*########## availability Check End ##########*/
    
</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->
<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="sal.page.title.editCustBankInfo" /></h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#" id="_close1" ><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->
<input type="hidden" value="${detailbank.custAccTypeId}" id="selCodeAccType"> 
<input type="hidden" value="${detailbank.custAccBankId}" id="selCodeAccBankId"> 
<section class="pop_body"><!-- pop_body start -->
<form id="updForm"> <!-- Form Start  -->
<input type="hidden" value="${detailbank.custAccId }" name="bankCustAccId">
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
    <select class="w100p" id="bankCmbAccTypeId" name="bankCustAccTypeId"></select>
    </td>
    <th scope="row"><spring:message code="sal.text.issueBank" /><span class="must">*</span></th>
    <td>
    <select class="w100p" id="bankCmbAccBankId" name="bankCustAccBankId"></select>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.accNo" /><span class="must">*</span></th>
    <td><input type="text" title="" placeholder="Account Number" class="w100p"  value="${detailbank.custAccNo}" maxlength="16" id="bankAccountNo" name="bankCustAccNo"/></td>
    <th scope="row"><spring:message code="sal.text.bankBranch" /></th>
    <td><input type="text" title="" placeholder="Bank Branch" class="w100p" value="${detailbank.custAccBankBrnch}" maxlength="16" name="bankCustAccBankBrnch"/></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.accountOwner" /><span class="must">*</span></th>
    <td colspan="3"><input type="text" title="" placeholder="Account Owner" class="w100p"  value="${detailbank.custAccOwner}" id="bankCustAccOwner" name="bankCustAccOwner"/></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.remarks" /></th>
    <td colspan="3">
    <textarea cols="20" rows="5" name="bankCustAccRem">${detailbank.custAccRem}</textarea>
    </td>
</tr>
</tbody>
</table><!-- table end -->
</form><!-- Form end  -->
<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#" id="_updBtn"><spring:message code="sal.btn.update" /></a></p></li>
    <li><p class="btn_blue2 big"><a href="#" id="_delBtn"><spring:message code="sal.btn.delete" /></a></p></li>
</ul>

</section><!-- pop_body end -->
</div>