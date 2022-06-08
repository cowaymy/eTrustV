<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">

var instDtMM = new Date().getMonth()+1;
var MEM_TYPE = '${SESSION_INFO.userTypeId}';

instDtMM = FormUtil.lpad(instDtMM, 2, "0");

$("#dataForm").empty();

/* 멀티셀렉트 플러그인 start */
$('.multy_select').change(function() {
   //console.log($(this).val());
})
.multipleSelect({
   width: '100%'
});

var brnch = '${SESSION_INFO.userBranchId}';

$(document).ready(
        function() {
        	if(brnch == '42'){
        		brnch = '';
        	}
        	doGetCombo('/eAccounting/ctDutyAllowance/getBch.do', brnch, brnch,'sBranchCode', 'M' , 'f_multiCombos');
        	//doGetCombo('/services/hiCare/getBch.do', brnch, brnch, 'sBranchCode', 'S', '');

            /* if(brnch == "42" || userName == 'KHSATO'){
                doGetCombo('/services/hiCare/getBch.do', '', brnch, 'sBranchCode', 'S', '');
                $("#sBranchCode option[value='"+ brnch +"']").attr("selected", true);
            }else{
                doGetCombo('/services/hiCare/getBch.do', brnch, brnch, 'sBranchCode', 'S', '');
            } */
        });

$.fn.clearForm = function() {
	//$("#sHolder").multipleSelect("checkAll");
	//$("#sStatus").multipleSelect("checkAll");

    return this.each(function() {
        var type = this.type, tag = this.tagName.toLowerCase();
        if (tag === 'form'){
            return $(':input',this).clearForm();
        }
        if (type === 'text' || type === 'password' || type === 'hidden' || tag === 'textarea'){
            this.value = '';
        }else if (tag === 'select'){
            this.selectedIndex = 0;
        }

        $("#dpInstallDateFrom").val(instDtMM+"/"+new Date().getFullYear());
        $("#dpInstallDateTo").val(instDtMM+"/"+new Date().getFullYear());

        $("#sOrgCode").empty();
        $("#sGrpCode").empty();
        $("#sDeptCode").empty();
        $("#sOrgCode").append("<option value='0' selected>All</option>");
        $("#sGrpCode").append("<option value='0' selected>All</option>");
        $("#sDeptCode").append("<option value='0' selected>All</option>");

        $("#sGrpCode").addClass("disabled");
        $("#sDeptCode").addClass("disabled");
    });
};

function f_multiCombos() {
    $(function() {
        $('#sBranchCode').change(function() {
        }).multipleSelect({
            selectAll : true
        }); /* .multipleSelect("checkAll"); */
    });
}

function validRequiredField(){

    var valid = true;
    var message = "";

    if(
            ( $("#sBranchCode :selected").val() == '' || $("#sBranchCode :selected").val() == null || $("#sBranchCode :selected").length == 0 )
            && ($("#sDutyType :selected").val() == '' || $("#sDutyType :selected").val() == null || $("#sDutyType :selected").length == 0 )
            && ($("#sAppvPrcssStus :selected").val() == '' || $("#sAppvPrcssStus :selected").val() == null || $("#sAppvPrcssStus :selected").length == 0 )
            && ($("#sSvcType :selected").val() == '' || $("#sSvcType :selected").val() == null || $("#sSvcType :selected").length == 0)
            && ($("#sRqtStartDt").val() == '' || $("#sRqtStartDt").val() == null)
            && ($("#sRqtendDt").val() == '' || $("#sRqtendDt").val() == null)
            && ($("#sCtCode").val() == '' || $("#sCtCode").val() == null)
    ){
        valid = false;
        message += 'Please select one of the selection';
    }
    else if( $("#sBranchCode :selected").length > 10){
    	valid = false;
        message += 'DSC Code not allow to select more than 10 branches';
    }
    else if(( $("#sBranchCode :selected").val() == '' || $("#sBranchCode :selected").val() == null || $("#sBranchCode :selected").length == 0 )
    		&& ($("#sCtCode").val() == '' || $("#sCtCode").val() == null)){
    	valid = false;
        message += 'Please key in CT Code, as DSC Code is not selected.';
    }

    if(valid == false){
        Common.alert('<spring:message code="sal.alert.title.reportGenSummary" />' + DEFAULT_DELIMITER + message);
    }

    return valid;
}

function btnGenerate_Click(){
    if(validRequiredField() == true){
        var whereSQL = "";
        var orderSQL = "";

        $("#reportFileName").val("");
        $("#reportDownFileName").val("");
        $("#viewType").val("");

        if($("#sRqtStartDt").val() != '' && $("#sRqtStartDt").val() != null && $("#sRqtendDt").val() != '' && $("#sRqtendDt").val() != null){
        	whereSQL += " and f35.UPD_DT between TO_DATE( '" + $("#sRqtStartDt").val() + "','DD/MM/YYYY') and TO_DATE( '" + $("#sRqtendDt").val() + "','DD/MM/YYYY') ";
        	/* if(listingType == '1'){
        	//whereSQL += " and a.FILTER_NXT_CHG_DT between TO_DATE( '" + $("#fcrtsdt").val() + "','DD/MM/YYYY') and TO_DATE( '" + $("#fcrtedt").val() + "','DD/MM/YYYY') ";
        	whereSQL += " and a.FILTER_NXT_CHG_DT <= TO_DATE( '" + $("#fcrtedt").val() + "','DD/MM/YYYY') ";
        	}else if(listingType == '2'){

            } */
        }

        if($('#sBranchCode :selected').length > 0){
            whereSQL += " and s5.BRNCH_ID in (";
            var runNo = 0;

            $('#sBranchCode :selected').each(function(i, mul){
                if(runNo == 0){
                	whereSQL += $(mul).val();
                }else{
                	whereSQL += "," + $(mul).val();
                }

                runNo += 1;
            });
            whereSQL += ") ";
        }

        if($('#sSvcType :selected').length > 0){
            whereSQL += " and f36.SVC_TYPE in (";
            var runNo = 0;

            $('#sSvcType :selected').each(function(i, mul){
                if(runNo == 0){
                    whereSQL += "'" + $(mul).val() + "'";
                }else{
                    whereSQL += ",'" + $(mul).val() + "'";
                }

                runNo += 1;
            });
            whereSQL += ") ";
        }

        if($('#sAppvPrcssStus :selected').length > 0){
            whereSQL += " and NVL(f04.APPV_PRCSS_STUS, 'T') in (";
            var runNo = 0;

            $('#sAppvPrcssStus :selected').each(function(i, mul){
                if(runNo == 0){
                    whereSQL += "'" + $(mul).val() + "'";
                }else{
                    whereSQL += ",'" + $(mul).val() + "'";
                }

                runNo += 1;
            });
            whereSQL += ") ";
        }

        if($('#sDutyType :selected').length > 0){
            whereSQL += " and f36.DUTY_TYPE in (";
            var runNo = 0;

            $('#sDutyType :selected').each(function(i, mul){
                if(runNo == 0){
                    whereSQL += "'" + $(mul).val() + "'";
                }else{
                    whereSQL += ",'" + $(mul).val() + "'";
                }

                runNo += 1;
            });
            whereSQL += ") ";
        }

        if(!($("#sCtCode").val() == '' || $("#sCtCode").val() == null)){
        	whereSQL += " AND f35.MEM_ACC_ID = '" + $("#sCtCode").val() + "'";
        }

        console.log("whereSQL" + whereSQL);


        var date = new Date().getDate();
        if(date.toString().length == 1){
            date = "0" + date;
        }

        $("#reportDownFileName").val("CtOtRawData"+date+(new Date().getMonth()+1)+new Date().getFullYear());
        $("#form #reportFileName").val("/e-accounting/CtOtRawData.rpt");
        $("#form #viewType").val('EXCEL');
        $("#form #V_WHERESQL").val(whereSQL);
        orderSQL = ' ORDER BY f35.CLM_NO,f36.CLM_SEQ ';
        $("#form #V_ORDERBYSQL").val(orderSQL);

        console.log($("#V_WHERESQL").val());
        // 프로시져로 구성된 경우 꼭 아래 option을 넘겨야 함.
        var option = {
                isProcedure : true // procedure 로 구성된 리포트 인경우 필수.  => /payment/PaymentListing_Excel.rpt 는 프로시져로 구성된 파일임.
        };

        Common.report("form", option);

    }else{
        return false;
    }
}

/* $("#dpInstallDateFrom").val(instDtMM+"/"+new Date().getFullYear());
$("#dpInstallDateTo").val(instDtMM+"/"+new Date().getFullYear());
CommonCombo.make('sOrgCode', '/sales/order/getOrgCodeList', {memLvl : 1, memType : $("#sMemberType :selected").val()} , '');
 */
</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>CT Duty Allowance Raw Data</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#"><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<aside class="title_line"><!-- title_line start -->

</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id="form">

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
    <th scope="row">Duty Allowance Type</th>
    <td>
    <select class="multy_select w100p" multiple="multiple" id="sDutyType" name="sDutyType">
        <option value="p">Public Holiday</option>
        <option value="r">Rest Day</option>
    </select>
    </td>
    <th scope="row" >Duty Allowance Status</th>
    <td>
    <select class="multy_select w100p" multiple="multiple" id="sAppvPrcssStus" name="sAppvPrcssStus">
        <option value="T"><spring:message code="webInvoice.select.tempSave" /></option>
        <option value="R"><spring:message code="webInvoice.select.request" /></option>
        <option value="P"><spring:message code="webInvoice.select.progress" /></option>
        <option value="A"><spring:message code="webInvoice.select.approved" /></option>
        <option value="J"><spring:message code="pettyCashRqst.rejected" /></option>
    </select>
    </td>
</tr>
<tr>
    <th scope="row">Request Date</th>
   <td>
      <div class="date_set w100p">
       <!-- date_set start -->
       <p>
        <input id="sRqtStartDt" name="namecrtsdt" type="text"
         title="Create start Date" placeholder="DD/MM/YYYY"
         class="j_date" />
       </p>
       <span> To </span>
       <p>
        <input id="sRqtendDt" name="namecrtedt" type="text"
         title="Create End Date" placeholder="DD/MM/YYYY"
         class="j_date" />
       </p>
      </div>
    <!-- date_set end -->
  </td>
<th scope="row">Service Type</th>
    <td>
        <select class="multy_select w100p" multiple="multiple" id="sSvcType" name="sSvcType">
            <option value="INS">INSTALLATION</option>
            <option value="AS">AFTER SERVICE</option>
            <option value="PR">PRODUCT RETURN</option>
            <option value="SB">STANDBY *REQUIRE MONTHLY SCHEDULE*</option>
            <option value="SV">SITE VISIT *REQUIERE ATTACHMENT*</option>
        </select>
    </td>
<tr>
    <th scope="row">CT Code</th>
    <td><input type="text" title="" placeholder="" class="w100p" id="sCtCode" name="sCtCode"/></td>
    <th scope="row">DSC Code</th>
	<td><select id="sBranchCode" name="sBranchCode" class="w100p"></select></td>
</tr>
</tbody>
</table><!-- table end -->

<ul class="center_btns">
    <li><p class="btn_blue2"><a href="#" onclick="javascript: btnGenerate_Click()">Generate</a></p></li>
</ul>

<input type="hidden" id="reportFileName" name="reportFileName" value="" />
<input type="hidden" id="viewType" name="viewType" value="" />
<input type="hidden" id="reportDownFileName" name="reportDownFileName" value="" />

<input type="hidden" id="V_WHERESQL" name="V_WHERESQL" value="" />
<input type="hidden" id="V_ORDERBYSQL" name="V_ORDERBYSQL" value="" />

<input type="hidden" id="userName" name="userName" value="${SESSION_INFO.userName}">

</form>

</section><!-- content end -->

</section><!-- container end -->

</div><!-- popup_wrap end -->