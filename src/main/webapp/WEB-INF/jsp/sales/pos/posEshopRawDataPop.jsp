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
    var moduleParam = {groupCode : 143, codeIn : [6795]};
    CommonCombo.make('_cmbPosTypeId', "/sales/pos/selectPosModuleCodeList", moduleParam , '', optionModule);

    //PosSystemTypeComboBox
    var systemParam = {groupCode : 140 , codeIn : [ 1353 ]};

    CommonCombo.make('_cmbSalesTypeId', "/sales/pos/selectPosModuleCodeList", systemParam , '', optionModule);

    //branch List
    CommonCombo.make('_cmbWhBrnchId', "/sales/pos/selectWhBrnchList", '' , '', '');

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
// ADDED CHECKING POS MODULE TYPE ID FOR POS RAW DATA REPORT -- TPY
    var posModuleTypeId = "";
    var whereSql = '';

    if($("#_cmbPosTypeId").val() != null && $("#_cmbPosTypeId").val() != '' ){
        whereSql += " AND A.POS_TYPE = " + $("#_cmbPosTypeId").val();
        posModuleTypeId = $("#_cmbPosTypeId").val();
    }

    if($("#_frPosNo").val() != null && $("#_frPosNo").val() != '' && $("#_toPosNo").val() != null && $("#_toPosNo").val() != ''){
        whereSql += " AND A.POS_NO BETWEEN '" + $("#_frPosNo").val()+ "' AND '" + $("#_toPosNo").val() +"' ";
    }

    if($("#_sttDate").val() != null && $("#_sttDate").val() != '' && $("#_eddDate").val() != null && $("#_eddDate").val() != '' ){
        whereSql += " AND (A.CRT_DT BETWEEN TO_DATE('" + $("#_sttDate").val()+ "'||' 00:00:00', 'DD-MM-YYYY HH24:MI:SS') AND TO_DATE('"+ $("#_eddDate").val() +"'||' 23:59:59', 'DD-MM-YYYY HH24:MI:SS'))";
    }

    if($("#_cmbWhBrnchId").val() != null && $("#_cmbWhBrnchId").val() != '' ){
        whereSql += " AND A.ESN_LOC_ID  = " + $("#_cmbWhBrnchId").val();
    }

    if($("#_hidMemberCode").val() != null && $("#_hidMemberCode").val() != ''){
        whereSql += " AND F.USER_NAME LIKE %" + $("#_memberCode").text() + "% ";
    }

    console.log("whereSql : " + whereSql);
    console.log("POS Module Type Id : " + posModuleTypeId);
    //params Setting
    $("#rptForm #reportFileName").val("/sales/POSEshopRawData.rpt");
    $("#rptForm #viewType").val("EXCEL");
    //
    $("#rptForm #V_WHERESQL").val(whereSql);

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


</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>E-Shop Raw Data</h1>
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

<form id="rptForm">
    <input type="hidden" id="reportFileName" name="reportFileName" /><!-- Report Name  -->
    <input type="hidden" id="viewType" name="viewType"  /><!-- View Type  -->
    <!-- <input type="hidden" id="reportDownFileName" name="reportDownFileName" value="123123" /> --><!-- Download Name -->

    <!--Raw Data  -->
    <input type="hidden" id="V_WHERESQL" name="V_WHERESQL"/>

</form>
</section>
</div>