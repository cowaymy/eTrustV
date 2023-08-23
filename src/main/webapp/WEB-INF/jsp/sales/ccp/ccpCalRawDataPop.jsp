<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>


<script type="text/javascript">
document.querySelector("#date").innerText = "Order Date";
var date = new Date().getDate();
if(date.toString().length == 1){
    date = "0" + date;
}
$("#dpDateFr").val(date+"/"+(new Date().getMonth()+1)+"/"+new Date().getFullYear());
$("#dpDateTo").val(date+"/"+(new Date().getMonth()+1)+"/"+new Date().getFullYear());

$.fn.clearForm = function() {
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

        $("#dpDateFr").val(date+"/"+(new Date().getMonth()+1)+"/"+new Date().getFullYear());
        $("#dpDateTo").val(date+"/"+(new Date().getMonth()+1)+"/"+new Date().getFullYear());

        $("#cmbType").removeClass("disabled");
        $("#txtOrderNumberFrom").removeAttr("disabled");
        $("#txtOrderNumberTo").removeAttr("disabled");
        $("#cmbRegion").removeClass("disabled");
        $("#cmbbranch").removeClass("disabled");

        $('#cmbType').prop("disabled", false);
        $('#cmbRegion').prop("disabled", false);
        $('#cmbbranch').prop("disabled", false);

    });
};

function cmbType_SelectedIndexChanged(){
	document.querySelector("#date").innerText = "Order Date";

	 if($("#cmbType :selected").val() == "1"){
		$("#cmbType").prop('disabled', true);
		$("#cmbType").addClass("disabled");
		$("#txtOrderNumberFrom").prop('disabled', true);
		$("#txtOrderNumberFrom").addClass("disabled");
		$("#txtOrderNumberTo").prop('disabled', true);
		$("#txtOrderNumberTo").addClass("disabled");
		$("#dpDateFr").prop('disabled', false);
		$("#dpDateTo").prop('disabled', false);
		$("#tpTimeFr").prop('disabled', false);
		$("#tpTimeTo").prop('disabled', false);
		$("#cmbRegion").prop('disabled', true);
		$("#cmbRegion").addClass("disabled");
		$("#cmbbranch").prop('disabled', true);
		$("#cmbbranch").addClass("disabled");

	}else if($("#cmbType :selected").val() == "2"){
		$("#cmbType").prop('disabled', true);
		$("#cmbType").addClass("disabled");
        $("#txtOrderNumberFrom").prop('disabled', true);
        $("#txtOrderNumberFrom").addClass("disabled");
        $("#txtOrderNumberTo").prop('disabled', true);
        $("#txtOrderNumberTo").addClass("disabled");
        $("#dpDateFr").prop('disabled', false);
        $("#dpDateTo").prop('disabled', false);
        $("#tpTimeFr").prop('disabled', false);
        $("#tpTimeTo").prop('disabled', false);
        $("#cmbRegion").prop('disabled', true);
        $("#cmbRegion").addClass("disabled");
        $("#cmbbranch").prop('disabled', true);
        $("#cmbbranch").addClass("disabled");

    }else if($("#cmbType :selected").val() == "3"){
    	$("#cmbType").prop('disabled', true);
    	$("#cmbType").addClass("disabled");
        $("#txtOrderNumberFrom").prop('disabled', true);
        $("#txtOrderNumberFrom").addClass("disabled")
        $("#txtOrderNumberTo").prop('disabled', true);
        $("#txtOrderNumberTo").addClass("disabled")
        $("#dpDateFr").prop('disabled', false);
        $("#dpDateTo").prop('disabled', false);
        $("#tpTimeFr").prop('disabled', false);
        $("#tpTimeTo").prop('disabled', false);
        $("#cmbRegion").prop('disabled', true);
        $("#cmbRegion").addClass("disabled");
        $("#cmbbranch").prop('disabled', true);
        $("#cmbbranch").addClass("disabled");

    }else if($("#cmbType :selected").val() == "4"){
    	$("#cmbType").prop('disabled', true);
    	$("#cmbType").addClass("disabled");
        $("#txtOrderNumberFrom").prop('disabled', true);
        $("#txtOrderNumberFrom").addClass("disabled");
        $("#txtOrderNumberTo").prop('disabled', true);
        $("#txtOrderNumberTo").addClass("disabled");
        $("#dpDateFr").prop('disabled', false);
        $("#dpDateTo").prop('disabled', false);
        $("#tpTimeFr").prop('disabled', false);
        $("#tpTimeTo").prop('disabled', false);
        $("#cmbRegion").prop('disabled', true);
        $("#cmbRegion").addClass("disabled");
        $("#cmbbranch").prop('disabled', true);
        $("#cmbbranch").addClass("disabled");

    }else if($("#cmbType :selected").val() == "5"){
        $("#cmbType").prop('disabled', true);
        $("#cmbType").addClass("disabled");
        $("#txtOrderNumberFrom").prop('disabled', true);
        $("#txtOrderNumberFrom").addClass("disabled");
        $("#txtOrderNumberTo").prop('disabled', true);
        $("#txtOrderNumberTo").addClass("disabled");
        $("#dpDateFr").prop('disabled', false);
        $("#dpDateTo").prop('disabled', false);
        $("#tpTimeFr").prop('disabled', false);
        $("#tpTimeTo").prop('disabled', false);
        $("#cmbRegion").prop('disabled', true);
        $("#cmbRegion").addClass("disabled");
        $("#cmbbranch").prop('disabled', true);
        $("#cmbbranch").addClass("disabled");

    }else if($("#cmbType :selected").val() == "6"){
        $("#cmbType").prop('disabled', true);
        $("#cmbType").addClass("disabled");
        $("#txtOrderNumberFrom").prop('disabled', true);
        $("#txtOrderNumberFrom").addClass("disabled");
        $("#txtOrderNumberTo").prop('disabled', true);
        $("#txtOrderNumberTo").addClass("disabled");
        $("#dpDateFr").prop('disabled', false);
        $("#dpDateTo").prop('disabled', false);
        $("#tpTimeFr").prop('disabled', false);
        $("#tpTimeTo").prop('disabled', false);
        $("#cmbRegion").prop('disabled', true);
        $("#cmbRegion").addClass("disabled");
        $("#cmbbranch").prop('disabled', true);
        $("#cmbbranch").addClass("disabled");

    }else if($("#cmbType :selected").val() == "7"){
        $("#txtOrderNumberFrom").prop('disabled', true);
        $("#txtOrderNumberFrom").addClass("disabled");
        $("#txtOrderNumberTo").prop('disabled', true);
        $("#txtOrderNumberTo").addClass("disabled");
        $("#dpDateFr").prop('disabled', false);
        $("#dpDateTo").prop('disabled', false);
        $("#tpTimeFr").prop('disabled', true);
        $("#tpTimeTo").prop('disabled', true);
        $("#cmbRegion").prop('disabled', true);
        $("#cmbRegion").addClass("disabled");
        $("#cmbbranch").prop('disabled', true);
        $("#cmbbranch").addClass("disabled");
        document.querySelector("#date").innerText = "";
        document.querySelector("#date").innerText = "Pre-CCP Created Date";
    }

}


function validRequiredField(){

	var valid = true;
	var message = "";

	if($("#cmbType :selected").index() < 1){
		valid = false;
		message += '<spring:message code="sal.alert.msg.plzSelReportType" />';
	}

	if(($("#dpDateFr").val() == null || $("#dpDateFr").val().length == 0) || ($("#dpDateTo").val() == null || $("#dpDateTo").val().length == 0)){
		valid = false;
		 if($("#cmbType :selected").val() == "7"){
			 message += '* Please key in Pre-CCP Created Date';
		 }else{
			message += '<spring:message code="sal.alert.msg.plzKeyinOrdDt" />';
		 }
	}

	if(valid == true){
        fn_report();
    }else{
    	Common.alert('<spring:message code="sal.alert.msg.ccpGenSummry" />' + DEFAULT_DELIMITER + message);
    }
}


function fn_report(){

	$("#reportFileName").val("");
    $("#reportDownFileName").val("");

    var date = new Date().getDate();
    if(date.toString().length == 1){
        date = "0" + date;
    }

    var dpDateFr = $("#dpDateFr").val();
    var dpDateTo = $("#dpDateTo").val();

    var frArr = dpDateFr.split("/");
    var toArr = dpDateTo.split("/");

    var orderNoFr = "";
    var orderNoTo = "";
    var orderDateFr = frArr[1]+"/"+frArr[0]+"/"+frArr[2]; // MM/dd/yyyy
    var orderDateTo = toArr[1]+"/"+toArr[0]+"/"+toArr[2];
    var orderTimeFr = "";
    var orderTimeTo = "";
    var branch = "";
    var region = "";

    var orderDateToSQL = "";
    var selectSQL = "";
    var whereSQL = "";
    var extraWhereSQL = "";
    var orderBySQL = "";
    var fullSQL = "";


	if($("#cmbType :selected").val() == "1"){

		if(!(dpDateFr == null || dpDateFr.length == 0) && !(dpDateTo == null || dpDateTo.length == 0)){

		    dpDateFr = frArr[2]+"/"+frArr[1]+"/"+frArr[0]; // yyyy/MM/dd
		    dpDateTo = toArr[2]+"/"+toArr[1]+"/"+toArr[0];

		    whereSQL += " AND (som.SALES_DT BETWEEN TO_DATE('"+$("#dpDateFr").val()+" 00:00:00', 'dd/MM/yyyy HH24:MI:SS') AND TO_DATE('"+$("#dpDateTo").val()+" 23:59:59', 'dd//MM/yyyy HH24:MI:SS'))";

		}

		$("#V_ORDERDATETOSQL").val(orderDateTo);
	    $("#V_SELECTSQL").val(selectSQL);
	    $("#V_WHERESQL").val(whereSQL);
	    $("#V_EXTRAWHERESQL").val(extraWhereSQL);
        $("#V_ORDERBYSQL").val(orderBySQL);
        $("#V_FULLSQL").val(fullSQL);

		$("#reportDownFileName").val("CCPRawCustInfo_Excel_"+date+(new Date().getMonth()+1)+new Date().getFullYear());
        $("#reportFileName").val("/sales/CCPRawCustInfo_Excel.rpt");

	}else if($("#cmbType :selected").val() == "2"){

		if(!(dpDateFr == null || dpDateFr.length == 0) && !(dpDateTo == null || dpDateTo.length == 0)){
			//whereSQL += " AND (NVL(som.SALES_DT, TO_DATE('01/01/1900', 'dd/MM/YY')) BETWEEN TO_DATE('"+$("#dpDateFr").val()+" 00:00:00', 'dd/MM/yyyy HH24:MI:SS') AND TO_DATE('"+$("#dpDateTo").val()+" 23:59:59', 'dd/MM/yyyy HH24:MI:SS'))";
			whereSQL += " AND som.SALES_DT BETWEEN TO_DATE('"+$("#dpDateFr").val()+"', 'dd/MM/yyyy') AND TO_DATE('"+$("#dpDateTo").val()+"', 'dd/MM/yyyy')+1 ";
		}
		if(!($("#txtOrderNumberFrom").val() == null || $("#txtOrderNumberFrom").val().length == 0) && !($("#txtOrderNumberTo").val() == null || $("#txtOrderNumberTo").val().length == 0)){
			whereSQL += " AND (som.SALES_ORD_NO BETWEEN '"+$("#txtOrderNumberFrom").val()+"' AND '"+$("#txtOrderNumberTo").val()+"')";
        }
	    if($("#cmbRegion :selected").index() > 0){
	    	whereSQL += " AND br.REGN_ID = '"+$("#cmbRegion :selected").val()+"'";
        }
	    if($("#cmbbranch :selected").index() > 0){
	    	whereSQL += " AND som.BRNCH_ID = '"+$("#cmbbranch :selected").val()+"'";
        }

		$("#V_ORDERDATETOSQL").val(orderDateTo);
        $("#V_SELECTSQL").val(selectSQL);
        $("#V_WHERESQL").val(whereSQL);
        $("#V_EXTRAWHERESQL").val(extraWhereSQL);
        $("#V_ORDERBYSQL").val(orderBySQL);
        $("#V_FULLSQL").val(fullSQL);

		$("#reportDownFileName").val("CCPRawOrderInfo_Excel_"+date+(new Date().getMonth()+1)+new Date().getFullYear());
        $("#reportFileName").val("/sales/CCPRawOrderInfo_Excel.rpt");

	}else if($("#cmbType :selected").val() == "3"){

		if(!(dpDateFr == null || dpDateFr.length == 0) && !(dpDateTo == null || dpDateTo.length == 0)){
			whereSQL += " AND som.SALES_DT BETWEEN TO_DATE('"+$("#dpDateFr").val()+" 00:00:00', 'dd/MM/yyyy HH24:MI:SS') AND TO_DATE('"+$("#dpDateTo").val()+" 23:59:59', 'dd/MM/yyyy HH24:MI:SS')";
		}
        if(!($("#txtOrderNumberFrom").val() == null || $("#txtOrderNumberFrom").val().length == 0) && !($("#txtOrderNumberTo").val() == null || $("#txtOrderNumberTo").val().length == 0)){
            whereSQL += " AND (som.SALES_ORD_NO BETWEEN '"+$("#txtOrderNumberFrom").val()+"' AND '"+$("#txtOrderNumberTo").val()+"')";
        }
        if($("#cmbRegion :selected").index() > 0){
            whereSQL += " AND br.REGN_ID = '"+$("#cmbRegion :selected").val()+"'";
        }
        if($("#cmbbranch :selected").index() > 0){
            whereSQL += " AND som.BRNCH_ID = '"+$("#cmbbranch :selected").val()+"'";
        }

		$("#V_ORDERDATETOSQL").val(orderDateTo);
        $("#V_SELECTSQL").val(selectSQL);
        $("#V_WHERESQL").val(whereSQL);
        $("#V_EXTRAWHERESQL").val(extraWhereSQL);
        $("#V_ORDERBYSQL").val(orderBySQL);
        $("#V_FULLSQL").val(fullSQL);

		$("#reportDownFileName").val("CCPRawCCPInfo_Excel_"+date+(new Date().getMonth()+1)+new Date().getFullYear());
        $("#reportFileName").val("/sales/CCPRawCCPInfo_Excel_2.rpt");

	}else if($("#cmbType :selected").val() == "4"){

		if(!(dpDateFr == null || dpDateFr.length == 0) && !(dpDateTo == null || dpDateTo.length == 0)){
			orderDateFr = frArr[2]+"/"+frArr[1]+"/"+frArr[0]; // yyyy/MM/dd
			orderDateTo =	toArr[2]+"/"+toArr[1]+"/"+toArr[0];
		}
        if(!($("#tpTimeFr").val() == null || $("#tpTimeFr").val().length == 0) && !($("#tpTimeTo").val() == null || $("#tpTimeTo").val().length == 0)){
        	orderTimeFr = $("#tpTimeFr").val();
        	orderTimeTo = $("#tpTimeTo").val();
        }

		$("#V_ORDERDATEFR").val(orderDateFr);
        $("#V_ORDERDATETO").val(orderDateTo);
        $("#V_ORDERTIMEFR").val(orderTimeFr);
        $("#V_ORDERTIMETO").val(orderTimeTo);

		$("#reportDownFileName").val("CCPAssignB2BRaw_Excel_"+date+(new Date().getMonth()+1)+new Date().getFullYear());
        $("#reportFileName").val("/sales/CCPAssignB2BRaw.rpt");

	}else if($("#cmbType :selected").val() == "5"){

        if(!(dpDateFr == null || dpDateFr.length == 0) && !(dpDateTo == null || dpDateTo.length == 0)){
            orderDateFr = frArr[2]+"/"+frArr[1]+"/"+frArr[0]; // yyyy/MM/dd
            orderDateTo =   toArr[2]+"/"+toArr[1]+"/"+toArr[0];
        }
        if(!($("#tpTimeFr").val() == null || $("#tpTimeFr").val().length == 0) && !($("#tpTimeTo").val() == null || $("#tpTimeTo").val().length == 0)){
            orderTimeFr = $("#tpTimeFr").val();
            orderTimeTo = $("#tpTimeTo").val();
        }

        $("#V_ORDERDATEFR").val(orderDateFr);
        $("#V_ORDERDATETO").val(orderDateTo);
        $("#V_ORDERTIMEFR").val(orderTimeFr);
        $("#V_ORDERTIMETO").val(orderTimeTo);

        $("#reportDownFileName").val("CCPAssignRaw_Excel_"+date+(new Date().getMonth()+1)+new Date().getFullYear());
        $("#reportFileName").val("/sales/CCPAssignRaw.rpt");

    }else if($("#cmbType :selected").val() == "6"){

        if(!(dpDateFr == null || dpDateFr.length == 0) && !(dpDateTo == null || dpDateTo.length == 0)){
            //whereSQL += " AND (NVL(som.SALES_DT, TO_DATE('01/01/1900', 'dd/MM/YY')) BETWEEN TO_DATE('"+$("#dpDateFr").val()+" 00:00:00', 'dd/MM/yyyy HH24:MI:SS') AND TO_DATE('"+$("#dpDateTo").val()+" 23:59:59', 'dd/MM/yyyy HH24:MI:SS'))";
            whereSQL += " AND som.SALES_DT BETWEEN TO_DATE('"+$("#dpDateFr").val()+"', 'dd/MM/yyyy') AND TO_DATE('"+$("#dpDateTo").val()+"', 'dd/MM/yyyy')+1 ";
        }
        if(!($("#txtOrderNumberFrom").val() == null || $("#txtOrderNumberFrom").val().length == 0) && !($("#txtOrderNumberTo").val() == null || $("#txtOrderNumberTo").val().length == 0)){
            whereSQL += " AND (som.SALES_ORD_NO BETWEEN '"+$("#txtOrderNumberFrom").val()+"' AND '"+$("#txtOrderNumberTo").val()+"')";
        }
        if($("#cmbRegion :selected").index() > 0){
            whereSQL += " AND br.REGN_ID = '"+$("#cmbRegion :selected").val()+"'";
        }
        if($("#cmbbranch :selected").index() > 0){
            whereSQL += " AND som.BRNCH_ID = '"+$("#cmbbranch :selected").val()+"'";
        }

        $("#V_ORDERDATETOSQL").val(orderDateTo);
        $("#V_SELECTSQL").val(selectSQL);
        $("#V_WHERESQL").val(whereSQL);
        $("#V_EXTRAWHERESQL").val(extraWhereSQL);
        $("#V_ORDERBYSQL").val(orderBySQL);
        $("#V_FULLSQL").val(fullSQL);

        $("#reportDownFileName").val("CCPRawExtradeSales_Excel_"+date+(new Date().getMonth()+1)+new Date().getFullYear());
        $("#reportFileName").val("/sales/CCPRawExtradeSales_Excel.rpt");

    }else if($("#cmbType :selected").val() == "7"){

   		whereSQL += " AND TRUNC(A.CRT_DT) BETWEEN ";
   		whereSQL += " TO_DATE('" + moment($("#dpDateFr").val(), "DD/MM/YYYY").format("YYYY/MM/DD") + "','YYYY/MM/DD')";
   		whereSQL += " AND ";
   		whereSQL += " TO_DATE('" + moment($("#dpDateTo").val(), "DD/MM/YYYY").format("YYYY/MM/DD") + "','YYYY/MM/DD')";
        $("#V_WHERESQL").val(whereSQL);
        $("#reportDownFileName").val("Pre-Check CCP Raw_"+ moment().format("YYYYMMDD"));
        $("#reportFileName").val("/sales/preccpRawData.rpt");

    }


	$("#viewType").val("EXCEL");

	// 프로시져로 구성된 경우 꼭 아래 option을 넘겨야 함.
    var option = {
            isProcedure : true // procedure 로 구성된 리포트 인경우 필수.  => /payment/PaymentListing_Excel.rpt 는 프로시져로 구성된 파일임.
    };

    Common.report("form", option);
}


//DB에서 값 가져오기
CommonCombo.make('cmbRegion', '/sales/ccp/getRegionCodeList', {codeId : 49} , '', '');
CommonCombo.make('cmbbranch', '/sales/ccp/getBranchCodeList', '' , '');

</script>



<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="sal.title.text.ccpRawData" /></h1>
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
    <col style="width:130px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sal.text.reportType" /></th>
    <td>
    <select class="" id="cmbType" onchange="cmbType_SelectedIndexChanged()">
        <option data-placeholder="true" hidden><spring:message code="sal.title.text.rptRawDataType" /></option>
        <option value="1"><spring:message code="sal.combo.text.ccpCustInfoRawData" /></option>
        <option value="2"><spring:message code="sal.combo.text.ccpOrderInfoRawData" /></option>
        <option value="3"><spring:message code="sal.combo.text.ccpCcpInfoRawData" /></option>
        <option value="4"><spring:message code="sal.combo.text.ccpCcpAssignB2BRawData" /></option>
        <option value="5"><spring:message code="sal.combo.text.ccpCcpAssignRawData" /></option>
        <option value="6"><spring:message code="sal.combo.text.ccpCcpExtradeSalesRawData" /></option>
        <option value="7"><spring:message code="preccp.rawData" /></option>
    </select>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.ordNo" /></th>
    <td>
    <div class="date_set"><!-- date_set start -->
    <p><input type="text" title="" placeholder="" class="w100p" id="txtOrderNumberFrom"/></p>
    <span><spring:message code="sal.title.to" /></span>
    <p><input type="text" title="" placeholder="" class="w100p" id="txtOrderNumberTo"/></p>
    </div><!-- date_set end -->
    </td>
</tr>
<tr>
    <th scope="row" id="date"></th>
    <td>
    <div class="date_set"><!-- date_set start -->
    <p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" id="dpDateFr"/></p>
    <span><spring:message code="sal.title.to" /></span>
    <p><input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" id="dpDateTo"/></p>
    </div><!-- date_set end -->
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.keyInHour" /></th>
    <td>
    <div class="date_set"><!-- date_set start -->

    <div class="time_picker"><!-- time_picker start -->
    <input type="text" title="" placeholder="" class="time_date" id="tpTimeFr"/>
    <ul>
        <li>Time Picker</li>
        <li><a href="#">12:00 AM</a></li>
        <li><a href="#">01:00 AM</a></li>
        <li><a href="#">02:00 AM</a></li>
        <li><a href="#">03:00 AM</a></li>
        <li><a href="#">04:00 AM</a></li>
        <li><a href="#">05:00 AM</a></li>
        <li><a href="#">06:00 AM</a></li>
        <li><a href="#">07:00 AM</a></li>
        <li><a href="#">08:00 AM</a></li>
        <li><a href="#">09:00 AM</a></li>
        <li><a href="#">10:00 AM</a></li>
        <li><a href="#">11:00 AM</a></li>
        <li><a href="#">12:00 PM</a></li>
        <li><a href="#">01:00 PM</a></li>
        <li><a href="#">02:00 PM</a></li>
        <li><a href="#">03:00 PM</a></li>
        <li><a href="#">04:00 PM</a></li>
        <li><a href="#">05:00 PM</a></li>
        <li><a href="#">06:00 PM</a></li>
        <li><a href="#">07:00 PM</a></li>
        <li><a href="#">08:00 PM</a></li>
        <li><a href="#">09:00 PM</a></li>
        <li><a href="#">10:00 PM</a></li>
        <li><a href="#">11:00 PM</a></li>
    </ul>
    </div><!-- time_picker end -->

    <span><spring:message code="sal.title.to" /></span>

    <div class="time_picker"><!-- time_picker start -->
    <input type="text" title="" placeholder="" class="time_date" id="tpTimeTo"/>
    <ul>
        <li>Time Picker</li>
        <li><a href="#">12:00 AM</a></li>
        <li><a href="#">01:00 AM</a></li>
        <li><a href="#">02:00 AM</a></li>
        <li><a href="#">03:00 AM</a></li>
        <li><a href="#">04:00 AM</a></li>
        <li><a href="#">05:00 AM</a></li>
        <li><a href="#">06:00 AM</a></li>
        <li><a href="#">07:00 AM</a></li>
        <li><a href="#">08:00 AM</a></li>
        <li><a href="#">09:00 AM</a></li>
        <li><a href="#">10:00 AM</a></li>
        <li><a href="#">11:00 AM</a></li>
        <li><a href="#">12:00 PM</a></li>
        <li><a href="#">01:00 PM</a></li>
        <li><a href="#">02:00 PM</a></li>
        <li><a href="#">03:00 PM</a></li>
        <li><a href="#">04:00 PM</a></li>
        <li><a href="#">05:00 PM</a></li>
        <li><a href="#">06:00 PM</a></li>
        <li><a href="#">07:00 PM</a></li>
        <li><a href="#">08:00 PM</a></li>
        <li><a href="#">09:00 PM</a></li>
        <li><a href="#">10:00 PM</a></li>
        <li><a href="#">11:00 PM</a></li>
    </ul>
    </div><!-- time_picker end -->

    </div><!-- date_set end -->

    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.region" /></th>
    <td>
    <select class="" id="cmbRegion"></select>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.branch" /></th>
    <td>
    <select class="" id="cmbbranch"></select>
    </td>
</tr>
</tbody>
</table><!-- table end -->

<ul class="right_btns">
    <li><p class="btn_blue"><a href="javascript:void(0);" onclick="javascript: validRequiredField();"><spring:message code="sal.btn.generate" /></a></p></li>
    <li><p class="btn_blue"><a href="#" onclick="javascript:$('#form').clearForm();"><span class="clear"></span><spring:message code="sal.btn.clear" /></a></p></li>
</ul>

<input type="hidden" id="reportFileName" name="reportFileName" value="" />
<input type="hidden" id="viewType" name="viewType" value="EXCEL" />
<input type="hidden" id="reportDownFileName" name="reportDownFileName" value="" />

<input type="hidden" id="V_ORDERDATETOSQL" name="V_ORDERDATETOSQL" value="" />
<input type="hidden" id="V_SELECTSQL" name="V_SELECTSQL" value="" />
<input type="hidden" id="V_WHERESQL" name="V_WHERESQL" value="" />
<input type="hidden" id="V_EXTRAWHERESQL" name="V_EXTRAWHERESQL" value="" />
<input type="hidden" id="V_ORDERBYSQL" name="V_ORDERBYSQL" value="" />
<input type="hidden" id="V_FULLSQL" name="V_FULLSQL" value="" />

<input type="hidden" id="V_ORDERDATEFR" name="V_ORDERDATEFR" value="" />
<input type="hidden" id="V_ORDERDATETO" name="V_ORDERDATETO" value="" />
<input type="hidden" id="V_ORDERTIMEFR" name="V_ORDERTIMEFR" value="" />
<input type="hidden" id="V_ORDERTIMETO" name="V_ORDERTIMETO" value="" />

<div id="reportParameter"></div>

</form>

</section><!-- content end -->

</section><!-- container end -->

</div><!-- popup_wrap end -->