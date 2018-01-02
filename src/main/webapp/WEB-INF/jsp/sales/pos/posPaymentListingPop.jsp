<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">

$(document).ready(function() {

     /*######################## Init Combo Box ########################*/
     
    //PosModuleTypeComboBox
    var moduleParam = {groupCode : 143, codeIn : [2390, 2391]};
    CommonCombo.make('_cmbPosTypeId', "/sales/pos/selectPosModuleCodeList", moduleParam , '', optionModule);
    
    //branch List
    CommonCombo.make('_cmbWhBrnchId', "/sales/pos/selectWhBrnchList", '' , '', '');
    
    /*######################## Init Combo Box ########################*/
    
});

function fn_posPaymentListing(){
    
	//Validation Check
	var rtnVal = fn_chkPayListingValidation(); 
	if(rtnVal == false){
		return;
	}
	
	//Ins Log
	
	
	
    var option = {
            isProcedure : true 
    };
    
    var whereSql = '';
    var showPaymentDate = "";
    var showKeyInBranch = "";
    var showReceiptNo = "";
    var showTrNo = "";
    var showKeyInUser = "";
    var showPosNo = "";
    var showMemberCode = "";
    
    if($("#_frPosNo").val() != null && $("#_frPosNo").val() != '' && $("#_toPosNo").val() != null && $("#_toPosNo").val() != '' ){
    	whereSql += " AND  posM.POS_NO BETWEEN '" + $("#_frPosNo").val().trim() + "'  AND '" + $("#_toPosNo").val().trim() + "' "; 
    	showPosNo += $("#_frPosNo").val().trim() + " To " + 	$("#_toPosNo").val().trim();
    }
    
    if($("#_cmbPosTypeId").val() != null && $("#_cmbPosTypeId").val() != ''){
    	whereSql += " AND posM.POS_MODULE_TYPE_ID = " + $("#_cmbPosTypeId").val(); 
    }
    
    if($("#_sttDate").val() != null && $("#_sttDate").val() != '' && $("#_eddDate").val() != null && $("#_eddDate").val() != ''){
    	whereSql += " AND pm.CRT_DT BETWEEN TO_DATE('"+$("#_sttDate").val()+"' , 'DD/MM/YYYY')  AND TO_DATE('"+$("#_eddDate").val()+"' , 'DD/MM/YYYY') ";
    	showPaymentDate += $("#_sttDate").val() + " To " + $("#_eddDate").val();
    }
    
    if($("#_frReceiptNo").val() != null && $("#_frReceiptNo").val() != '' && $("#_toReceiptNo").val() != null && $("#_toReceiptNo").val() != '' ){
    	whereSql += " AND pm.OR_NO BETWEEN '" + $("#_frReceiptNo").val().trim() + "' AND '" + $("#_toReceiptNo").val().trim() + "'";
    	showReceiptNo += $("#_frReceiptNo").val().trim() + " To " + $("#_toReceiptNo").val().trim();
    }
    
    if($("#_cmbWhBrnchId").val() != null && $("#_cmbWhBrnchId").val() != ''){
    	whereSql += " AND pm.BRNCH_ID = " + $("#_cmbWhBrnchId").val();
    	showKeyInBranch += $("#_cmbWhBrnchId").text();
    }
    
    if($("#_frTrtNo").val() != null && $("#_frTrtNo").val() != '' && $("#_toTrNo").val() != null && $("#_toTrNo").val() != ''){
    	whereSql += " AND pm.TR_NO BETWEEN '" + $("#_frTrtNo").val() + "' AND '" + $("#_toTrNo").val() + "'";
    	showTrNo += $("#_frTrtNo").val() + " To " + $("#_toTrNo").val();
    }
    console.log("salesAgnetId Check : " + $("#_hidSalesAgentId").val());
    if($("#_hidSalesAgentId").val() != null && $("#_hidSalesAgentId").val() != '' ){
    	whereSql += " AND pm.CRT_USER_ID = " + $("#_hidSalesAgentId").val();
    	showKeyInUser += $("#_salesAgent").text().trim();
    }
    console.log("memberCode Check : " + $("#_hidMemberCode").val());
    if($("#_hidMemberCode").val() != null && $("#_hidMemberCode").val() != ''){
    	whereSql += " AND posM.POS_MEM_ID = " + $("#_hidMemberCode").val();
    	showMemberCode += $("#_memberCode").text();
    }

    console.log("whereSql : " + whereSql);
    
    //params Setting
    $("#reportFileName").val("/sales/POSPaymentListing_PDF_New.rpt");
    $("#viewType").val("PDF");
   
    $("#V_WHERESQL").val(whereSql);
    $("#V_SHOWPAYMENTDATE").val(showPaymentDate);
    $("#V_SHOWKEYINBRANCH").val(showKeyInBranch);
    $("#V_SHOWRECEIPTNO").val(showReceiptNo);
    $("#V_SHOWTRNO").val(showTrNo);
    $("#V_SHOWKEYINUSER").val(showKeyInUser);
    $("#V_SHOWPOSNO").val(showPosNo);
    $("#V_SHOWMEMBERCODE").val(showMemberCode);
    
    fn_insTransactionLogPay(whereSql, showPaymentDate, showKeyInBranch, showReceiptNo, showTrNo, showKeyInUser, showPosNo, showMemberCode);
    Common.report("rptForm", option);
    
}

function fn_chkPayListingValidation(){
	
	var isFalseChk = true;
	
	if(($("#_sttDate").val() != null && $("#_sttDate").val() != '') || ($("#_eddDate").val() != null && $("#_eddDate").val() != '')){ //choice at least one
		if($("#_sttDate").val() == null || $("#_sttDate").val() == '' || $("#_eddDate").val() == null && $("#_eddDate").val() == ''){
			Common.alert("* Please key in the payment date (From & To).<br />");
			return false;
		}
	}
	
	if(($("#_frReceiptNo").val() != null && $("#_frReceiptNo").val() != '') || ($("#_toReceiptNo").val() != null && $("#_toReceiptNo").val() != '')){ //choice at least one
        if($("#_frReceiptNo").val() == null || $("#_frReceiptNo").val() == '' || $("#_toReceiptNo").val() == null && $("#_toReceiptNo").val() == ''){
            Common.alert("* Please key in the payment date (From & To).<br />");
            return false;
        }
    }
	
	if(($("#_frPosNo").val() != null && $("#_frPosNo").val() != '') || ($("#_toPosNo").val() != null && $("#_toPosNo").val() != '')){ //choice at least one
        if($("#_frPosNo").val() == null || $("#_frPosNo").val() == '' || $("#_toPosNo").val() == null && $("#_toPosNo").val() == ''){
            Common.alert("* Please key in the payment date (From & To).<br />");
            return false;
        }
    }
	
	if(($("#_frTrtNo").val() != null && $("#_frTrtNo").val() != '') || ($("#_toTrNo").val() != null && $("#_toTrNo").val() != '')){ //choice at least one
        if($("#_frTrtNo").val() == null || $("#_frTrtNo").val() == '' || $("#_toTrNo").val() == null && $("#_toTrNo").val() == ''){
            Common.alert("* Please key in the payment date (From & To).<br />");
            return false;
        }
    }
	
	if($("#_salesAgent").val() != null && $("#_salesAgent").val() != '' ){
		Common.ajax("GET", "/sales/pos/chkUserIdByUserName", {userName : $("#_salesAgent").val()}, function(result){
			if(result == null){
				Common.alert("* Invalid username.<br />");
				$("#_salesAgent").val('');
				$("#_hidSalesAgentId").val('');
				$("#_salesAgent").focus();
				isFalseChk = false;
			}else{
			    
				$("#_hidSalesAgentId").val(result.userId);
			}
		},'',{async : false});
	}
	
	if(isFalseChk == false){
		return false;
	}
	
	if($("#_memberCode").val() != null && $("#_memberCode").val() != ''){
		Common.ajax("GET", "/sales/pos/chkMemIdByMemCode", {memCode : $("#_memberCode").val()},function(result){
		
			if(result == null){
                Common.alert("* Invalid member code.<br />");  
                $("#_memberCode").val('');
                $("#_hidMemberCode").val('');
                $("#_memberCode").focus();
                isFalseChk = false;
            }else{
            	
            	$("#_hidMemberCode").val(result.memId);
            }
		}, '' , {async : false});
	}
	
	if(isFalseChk == false){
        return false;
    }
	
	
	//validaion Pass
	return true;
}

//Clear Btn
$.fn.clearForm = function() {
    return this.each(function() {
        var type = this.type, tag = this.tagName.toLowerCase();
        if (tag === 'form'){
            return $(':input',this).clearForm();
        }
        if (type === 'text' || type === 'password' || type === 'hidden' || tag === 'textarea'){
            this.value = '';
        }else if (type === 'checkbox' || type === 'radio'){
            this.checked = false;
        }else if (tag === 'select'){
            this.selectedIndex = -1;
        }
    });
};

function fn_insTransactionLogPay(whereSql, showPaymentDate, showKeyInBranch, showReceiptNo, showTrNo, showKeyInUser, showPosNo, showMemberCode){
    
	var transacMap = {};
    transacMap.rptChkPoint = "http://etrust.my.coway.com/sales/pos/posPaymentListingPop.do";
    transacMap.rptModule = "POS";
    transacMap.rptName = "POS Listing";
    transacMap.rptSubName = "POS Payment Listing - PDF";
    transacMap.rptEtType = "pdf";
    transacMap.rptPath = getContextPath()+"/sales/POSPaymentListing_PDF_New.rpt";
    transacMap.rptParamtrValu = "@WhereSQL," + whereSql + ";@ShowPaymentDate," + showPaymentDate + 
										    ";@ShowKeyInBranch," + showKeyInBranch +";@ShowReceiptNo," + showReceiptNo + 
										    ";@ShowTRNo," + showTrNo + ";@ShowKeyInUser," + showKeyInUser +
										    ";@ShowPOSNo," + showPosNo + ";@ShowMemberCode," + showMemberCode + ";@WhereSQL," + whereSql;
    transacMap.rptRem = "";
    
    Common.ajax("GET", "/sales/pos/insertTransactionLog", transacMap, function(result){
        if(result == null){
            Common.alert("<b>Failed to save into log file.</b>");
        }else{
            console.log("insert log : " + result.message);
        }
    });
}

</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>POS Payment Listing</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a id="_itmSrchPopClose">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<form action="#" method="post">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:160px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">POS No.</th>
    <td>
    <input type="text" title="" placeholder="From POS No."   style="width: 45%" id="_frPosNo"  />
    <input type="text" title="" placeholder="To POS No."  style="width: 45%" id="_toPosNo" />
    </td>
    <th scope="row">POS Type</th>
    <td>
    <select class="w100p" id="_cmbPosTypeId"></select>
    </td>
</tr>
<tr>
    <th scope="row">Payment Date</th>
    <td>
    <div class="date_set w100p"><!-- date_set start -->
    <p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date"  name="sDate" id="_sttDate" value="${bfDay}"/></p>  
    <span>To</span>
    <p><input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" name="eDate"  id="_eddDate" value="${toDay}"/></p>
    </div><!-- date_set end -->
    </td>
    <th scope="row">Receipt No.</th>
    <td>
    <input type="text" title="" placeholder="From Receipt No."   style="width: 45%" id="_frReceiptNo"  />
    <input type="text" title="" placeholder="To Receipt No."  style="width: 45%" id="_toReceiptNo" />
    </td>
</tr>
<tr>
    <th scope="row">Branch / Warehouse</th>
    <td><select  id="_cmbWhBrnchId"  name="" class="w100p"></select></td>
    <th scope="row">TR No.</th>
    <td>
    <input type="text" title="" placeholder="From TR No."   style="width: 45%" id="_frTrtNo"  />
    <input type="text" title="" placeholder="To TR No."  style="width: 45%" id="_toTrNo" />
    </td>
</tr>
<tr>
    <th scope="row">Sales Agent</th>
    <td>
    <input type="text" title="" placeholder="Sales Agent" class="w100p" id="_salesAgent" />
    <input type="hidden" id="_hidSalesAgentId">
    </td>
    <th scope="row">Member Code</th>
    <td>
    <input type="text" title="" placeholder="Member Code" class="w100p" id="_memberCode" />
    <input type="hidden" id="_hidMemberCode">
    </td>
</tr>
</tbody>
</table><!-- table end -->

<ul class="center_btns">
    <li><p class="btn_blue2 big"><a onclick="javascript: fn_posPaymentListing()" >Generate</a></p></li>
    <li><p class="btn_blue2 big"><a onclick="javascript:$('#searchForm').clearForm();">Clear</a></p></li>
</ul>
</form>
</section>
</div>