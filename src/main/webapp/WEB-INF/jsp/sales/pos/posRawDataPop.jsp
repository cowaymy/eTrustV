<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">
var reasonOption = {
        type: "M",
        isCheckAll: false
};
$(document).ready(function() {

	 /*######################## Init Combo Box ########################*/

	//PosModuleTypeComboBox
    var moduleParam = {groupCode : 143, codeIn : [2390, 2391]};
    CommonCombo.make('_cmbPosTypeId', "/sales/pos/selectPosModuleCodeList", moduleParam , '', optionModule);

    //PosSystemTypeComboBox
    var systemParam = {groupCode : 140 , codeIn : [1352, 1353 , 1361]};

    CommonCombo.make('_cmbSalesTypeId', "/sales/pos/selectPosModuleCodeList", systemParam , '', optionModule);

    //branch List
    CommonCombo.make('_cmbWhBrnchId', "/sales/pos/selectWhBrnchList", '' , '', '');

    ///getReasonCodeList
    var rsnParam = {masterCode : 1363};
    //CommonCombo.make('_purcReason', "/sales/pos/getReasonCodeList", rsnParam , '', optionReasonChoose); //Reason Code List
    CommonCombo.make('_purcReason', "/sales/pos/getReasonCodeList", rsnParam , '', reasonOption); //Reason Code List
    /*######################## Init Combo Box ########################*/

});

function fn_posRawData(){

	//Validation
	var rtnVal = fn_chkRawData();
	if(rtnVal == false){
		return;
	}

	var option = {
            isProcedure : true
    };

	var whereSql = '';

	if($("#_cmbPosTypeId").val() != null && $("#_cmbPosTypeId").val() != '' ){
		whereSql += " AND M.POS_MODULE_TYPE_ID = " + $("#_cmbPosTypeId").val();
	}

	if($("#_cmbSalesTypeId").val() != null && $("#_cmbSalesTypeId").val() != '' ){
		whereSql += " AND M.POS_TYPE_ID = " + $("#_cmbSalesTypeId").val();
	}

	if($("#_frPosNo").val() != null && $("#_frPosNo").val() != '' && $("#_toPosNo").val() != null && $("#_toPosNo").val() != ''){
		whereSql += " AND M.POS_NO BETWEEN '" + $("#_frPosNo").val()+ "' AND '" + $("#_toPosNo").val() +"' ";
	}

	if($("#_sttDate").val() != null && $("#_sttDate").val() != '' && $("#_eddDate").val() != null && $("#_eddDate").val() != '' ){
		whereSql += " AND (M.POS_CRT_DT BETWEEN TO_DATE('" + $("#_sttDate").val()+ "'||' 00:00:00', 'DD-MM-YYYY HH24:MI:SS') AND TO_DATE('"+ $("#_eddDate").val() +"'||' 23:59:59', 'DD-MM-YYYY HH24:MI:SS'))";
	}

	if($("#_cmbWhBrnchId").val() != null && $("#_cmbWhBrnchId").val() != '' ){
		whereSql += " AND M.BRNCH_ID  = " + $("#_cmbWhBrnchId").val();
	}

    var runReason = 0;
    var resnStr = '';
    if($('#_purcReason :selected').length > 0){
        $('#_purcReason :selected').each(function(idx, el){
            if(runReason > 0){
            	resnStr += ',' + $(el).val();
            }else{
            	resnStr += $(el).val();
            }
            runReason += 1;
        });
    }

    if(resnStr != null && resnStr != ''){
    	whereSql += " AND M.POS_RESN_ID  IN (  "+resnStr+ ") ";
    }

    if($("#_hidSalesAgentId").val() != null && $("#_hidSalesAgentId").val() != '' ){
    	whereSql += " AND M.POS_CRT_USER_ID = " + $("#_salesAgent").text() + " ";
    }

    if($("#_hidMemberCode").val() != null && $("#_hidMemberCode").val() != ''){
    	whereSql += " AND M.POS_MEM_ID = " + $("#_memberCode").text() + " ";
    }

    console.log("whereSql : " + whereSql);

    //params Setting
    $("#reportFileName").val("/sales/POSRawData_Filter.rpt");
    $("#viewType").val("EXCEL");
    //
    $("#V_WHERESQL").val(whereSql);

   //Ins Log
    fn_insTransactionLogRaw(whereSql);
    Common.report("rptForm", option);

}

function fn_chkRawData(){

	var isFalseChk = true;

	if(($("#_sttDate").val() != null && $("#_sttDate").val() != '') || ($("#_eddDate").val() != null && $("#_eddDate").val() != '')){ //choice at least one
        if($("#_sttDate").val() == null || $("#_sttDate").val() == '' || $("#_eddDate").val() == null && $("#_eddDate").val() == ''){
            Common.alert('<spring:message code="sal.alert.msg.keyInPaymentDate" />');
            return false;
        }
    }

	if(($("#_frPosNo").val() != null && $("#_frPosNo").val() != '') || ($("#_toPosNo").val() != null && $("#_toPosNo").val() != '')){ //choice at least one
        if($("#_frPosNo").val() == null || $("#_frPosNo").val() == '' || $("#_toPosNo").val() == null && $("#_toPosNo").val() == ''){
            Common.alert('<spring:message code="sal.alert.msg.posNumber" />');
            return false;
        }
    }

	if(($("#_frPosNo").val() != null && $("#_frPosNo").val() != '') || ($("#_toPosNo").val() != null && $("#_toPosNo").val() != '')){ //choice at least one
        if($("#_frPosNo").val() == null || $("#_frPosNo").val() == '' || $("#_toPosNo").val() == null && $("#_toPosNo").val() == ''){
            Common.alert('<spring:message code="sal.alert.msg.posNumber" />');
            return false;
        }
    }

	if($("#_salesAgent").val() != null && $("#_salesAgent").val() != '' ){
        Common.ajax("GET", "/sales/pos/chkUserIdByUserName", {userName : $("#_salesAgent").val()}, function(result){
            if(result == null){
                Common.alert('<spring:message code="sal.alert.msg.invalidUserName" />');
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
                Common.alert('<spring:message code="sal.alert.msg.invalidMemCode" />');
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

function fn_insTransactionLogRaw(whereSql){

	var transacMap = {};
    transacMap.rptChkPoint = "http://etrust.my.coway.com/sales/pos/posRawDataPop.do";
    transacMap.rptModule = "POS";
    transacMap.rptName = "POS Listing";
    transacMap.rptSubName = "POS Listing - Excel";
    transacMap.rptEtType = "xlsx";
    transacMap.rptPath = getContextPath()+"/sales/POSRawData_Filter.rpt";
    transacMap.rptParamtrValu = "@WhereSQL,"+whereSql;
    transacMap.rptRem = "";

    Common.ajax("GET", "/sales/pos/insertTransactionLog", transacMap, function(result){
        if(result == null){
            Common.alert('<spring:message code="sal.alert.msg.failToSaveLog" />');
        }else{
            console.log("insert log : " + result.message);
        }
    });


}

</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="sal.title.text.posRawData" /></h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a id="_itmSrchPopClose"><spring:message code="sal.btn.close" /></a></p></li>
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
    <th scope="row"><spring:message code="sal.title.posType" /></th>
    <td>
    <select class="w100p" id="_cmbPosTypeId"></select>
    </td>
    <th scope="row"><spring:message code="sal.title.text.posSalesType" /></th>
    <td>
    <select class="w100p" id="_cmbSalesTypeId"></select>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.posNo" /></th>
    <td>
    <input type="text" title="" placeholder="From POS No."   style="width: 45%" id="_frPosNo"  />
    <input type="text" title="" placeholder="To POS No."  style="width: 45%" id="_toPosNo" />
    </td>
    <th scope="row"><spring:message code="sal.title.salDate" /></th>
    <td>
    <div class="date_set w100p"><!-- date_set start -->
    <p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date"  name="sDate" id="_sttDate" value="${bfDay}"/></p>
    <span><spring:message code="sal.title.to" /></span>
    <p><input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" name="eDate"  id="_eddDate" value="${toDay}"/></p>
    </div><!-- date_set end -->
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.brnchWarehouse" /></th>
    <td><select  id="_cmbWhBrnchId"  name="" class="w100p"></select></td>
    <!-- Reason -->
    <th scope="row"><spring:message code="sal.title.text.purcReason" /></th>
    <td><select  id="_purcReason"  name="" class="w100p"></select></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.salesAgent" /></th>
    <td>
    <input type="text" title="" placeholder="Sales Agent" class="w100p" id="_salesAgent" />
    <input type="hidden" id="_hidSalesAgentId">
    </td>
    <th scope="row"><spring:message code="sal.text.memberCode" /></th>
    <td>
    <input type="text" title="" placeholder="Member Code" class="w100p" id="_memberCode" />
    <input type="hidden" id="_hidMemberCode">
    </td>
</tr>
</tbody>
</table><!-- table end -->

<ul class="center_btns">
    <li><p class="btn_blue2 big"><a onclick="javascript: fn_posRawData()" ><spring:message code="sal.btn.generate" /></a></p></li>
    <li><p class="btn_blue2 big"><a onclick="javascript:$('#searchForm').clearForm();" ><spring:message code="sal.btn.clear" /></a></p></li>
</ul>
</form>
</section>
</div>