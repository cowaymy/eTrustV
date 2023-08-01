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

var sbrnch = '${SESSION_INFO.userBranchId}';
var sroleId = '${SESSION_INFO.roleId}';

$(document).ready(
        function() {

        	//doGetCombo('/services/hiCare/getBch.do', sbrnch, sbrnch, 'sBranchCode', 'S', '');

        });

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

    if(($("#reqDt1").val() == '' || $("#reqDt1").val() == null)
    		|| ($("#reqDt2").val() == '' || $("#reqDt2").val() == null)
    		|| ($("#sAppvPrcssStus :selected").val() == '' || $("#sAppvPrcssStus :selected").val() == null || $("#sAppvPrcssStus :selected").length == 0 )
    		){
    	valid = false;
        message += 'Please select all selection.';
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

        if($("#reqDt1").val() != '' && $("#reqDt1").val() != null && $("#reqDt2").val() != '' && $("#reqDt2").val() != null){
        	//whereSQL += " and f35.UPD_DT between TO_DATE( '" + $("#sRqtStartDt").val() + "','DD/MM/YYYY') and TO_DATE( '" + $("#sRqtendDt").val() + "','DD/MM/YYYY') ";
        	/* if(listingType == '1'){
        	//whereSQL += " and a.FILTER_NXT_CHG_DT between TO_DATE( '" + $("#fcrtsdt").val() + "','DD/MM/YYYY') and TO_DATE( '" + $("#fcrtedt").val() + "','DD/MM/YYYY') ";
        	whereSQL += " and a.FILTER_NXT_CHG_DT <= TO_DATE( '" + $("#fcrtedt").val() + "','DD/MM/YYYY') ";
        	}else if(listingType == '2'){

            } */
        	whereSQL += " and D.REQST_DT BETWEEN TO_DATE( '" + $("#reqDt1").val() + "','DD/MM/YYYY') AND TO_DATE( '" + $("#reqDt2").val() + "','DD/MM/YYYY') + 1";
        }

        if($('#sAppvPrcssStus :selected').length > 0){
            whereSQL += " and NVL(D.APPV_PRCSS_STUS, 'T') in (";
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

        console.log("whereSQL" + whereSQL);


        var date = new Date().getDate();
        if(date.toString().length == 1){
            date = "0" + date;
        }

        $("#reportDownFileName").val("SMGMClaimRawData"+date+(new Date().getMonth()+1)+new Date().getFullYear());
        $("#form #reportFileName").val("/e-accounting/SMGMClaimRaw.rpt");
        $("#form #viewType").val('EXCEL');
        $("#form #V_WHERESQL").val(whereSQL);
        orderSQL = ' ORDER BY REQST_DT ';
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
<h1>SM/GM Claim Raw Data</h1>
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
    <th scope="row">Requested Date</th>
    <td>
	    <div class="date_set w100p"><!-- date_set start -->
	    <p><input id="reqDt1" name="reqDt1" type="text" title="Request Start Date" placeholder="DD/MM/YYYY" class="j_date"></p>
	    <span> To </span>
	    <p><input id="reqDt2" name="reqDt2" type="text" title="Request End Date" placeholder="DD/MM/YYYY" class="j_date"></p>
	    </div><!-- date_set end -->
    </td>
</tr>
<tr>
    <th scope="row" >Status</th>
    <td>
    <select class="multy_select w100p" multiple="multiple" id="sAppvPrcssStus" name="sAppvPrcssStus">
        <option value="R"><spring:message code="webInvoice.select.request" /></option>
        <option value="P"><spring:message code="webInvoice.select.progress" /></option>
        <option value="A"><spring:message code="webInvoice.select.approved" /></option>
        <option value="J"><spring:message code="pettyCashRqst.rejected" /></option>
    </select>
    </td>
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