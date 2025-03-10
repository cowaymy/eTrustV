<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%> 

<script type="text/javascript">

$(document).ready(function(){
	$("#dataForm").empty();

	var date = new Date().getDate();
	if(date.toString().length == 1){
	    date = "0" + date;
	}
	$("#dpOrderDateFr").val(date+"/"+(new Date().getMonth()+1)+"/"+new Date().getFullYear());
	$("#dpOrderDateTo").val(date+"/"+(new Date().getMonth()+1)+"/"+new Date().getFullYear());

	$('.multy_select').change(function() {
		
	})
	.multipleSelect({
	   width: '100%'
	});
	$("#cmbAppType").multipleSelect("checkAll");
	$("#cmbSalesBy").multipleSelect("checkAll");
	$("#cmbGtoMonthYear").val("0"+(new Date().getMonth()+1)+"/"+new Date().getFullYear());

	doGetComboData('/common/selectStoreList.do', '', '1', 'cowayStoreCode', 'M', 'fn_multiCombo2');
});

function fn_multiCombo2(){
    $('#cowayStoreCode').change(function() {
    }).multipleSelect({
        selectAll: true, // 전체선택
        width: '100%'
    });
    $('#cowayStoreCode').multipleSelect("checkAll");
}

$.fn.clearForm = function() {
	var date = new Date().getDate();
    if(date.toString().length == 1){
        date = "0" + date;
    }	
    $("#cmbAppType").multipleSelect("checkAll");
    $("#cmbSalesBy").multipleSelect("checkAll");
    $("#cowayStoreCode").multipleSelect("checkAll");
    
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
        $("#dpOrderDateFr").val(date+"/"+(new Date().getMonth()+1)+"/"+new Date().getFullYear());
        $("#dpOrderDateTo").val(date+"/"+(new Date().getMonth()+1)+"/"+new Date().getFullYear());
        $("#cmbGtoMonthYear").val("0"+(new Date().getMonth()+1)+"/"+new Date().getFullYear());
    }); 
};

function validRequiredField(){

    var valid = true;
    var message = "";

    if(($("#dpOrderDateFr").val() == null || $("#dpOrderDateFr").val().length == 0) || ($("#dpOrderDateTo").val() == null || $("#dpOrderDateTo").val().length == 0)){
        valid = false;
        message += '<spring:message code="sal.alert.msg.keyInOrdDateFromTo" />';
    }
    else {
        var diffDay = fn_diffDate($('#dpOrderDateFr').val(), $('#dpOrderDateTo').val());

        if(diffDay > 91 || diffDay < 0) {
        	valid = false;
        	message += '* <spring:message code="sal.alert.msg.srchPeriodDt" />';
        }
    }

    if(valid == false){
        alert(message);
    }

    return valid;
}

function fn_diffDate(startDt, endDt) {
    var arrDt1 = startDt.split("/");
    var arrDt2 = endDt.split("/");

    var dt1 = new Date(arrDt1[2], arrDt1[1]-1, arrDt1[0]);
    var dt2 = new Date(arrDt2[2], arrDt2[1]-1, arrDt2[0]);

    var diff = new Date(dt2 - dt1);
    var day = diff/1000/60/60/24;

    return day;
}

function btnGenerate_Excel_Click(){
    if(validRequiredField() == true){
           fn_report("EXCEL");
    }else{
        return false;
    }
}

function fn_report(viewType){

	var cmmDt = $("#cmbGtoMonthYear").val(); 
	var month = Number(cmmDt.substring(1, 2));
    var year = Number(cmmDt.substring(3,7));
    $("#reportFileName").val("");
    $("#reportDownFileName").val("");
    $("#viewType").val("");

    var orderNo= "";
    var orderDateFrom = "";
    var orderDateTo = "";
    var storeCode = "";
    var appType = "";
    var salesBy = "";
    var custIC = "";
    var whereSQL = "";
    var extraWhereSQL = "";
    var runNo = 0;


    if(!($("#dpOrderDateFr").val() == null || $("#dpOrderDateFr").val().length == 0) && !($("#dpOrderDateTo").val() == null || $("#dpOrderDateTo").val().length == 0)){

        orderDateFrom = $("#dpOrderDateFr").val(); //dd/MM/yyyy
        orderDateTo = $("#dpOrderDateTo").val();

        var frArr = $("#dpOrderDateFr").val().split("/");
        var toArr = $("#dpOrderDateTo").val().split("/");
        var dpOrderDateFr = frArr[1]+"/"+frArr[0]+"/"+frArr[2]; // MM/dd/yyyy
        var dpOrderDateTo = toArr[1]+"/"+toArr[0]+"/"+toArr[2];

        whereSQL += " AND (R.ORD_DT BETWEEN TO_DATE('"+dpOrderDateFr+" 00:00:00', 'MM/dd/YY HH24:MI:SS') AND TO_DATE('"+dpOrderDateTo+" 23:59:59', 'MM/dd/YY HH24:MI:SS'))";
    }

    if($('#cmbAppType :selected').length > 0){
        whereSQL += " AND (";

        $('#cmbAppType :selected').each(function(i, mul){
            if(runNo > 0){
                whereSQL += " OR R.APP_TYPE = '"+$(mul).val()+"' ";
                appType += ", "+$(mul).text();

            }else{
                whereSQL += " R.APP_TYPE = '"+$(mul).val()+"' ";
                appType += $(mul).text();

            }
            runNo += 1;
        });
        whereSQL += ") ";
    }
    runNo = 0;

    var txtOrderNo = $("#txtOrderNo").val().trim();

    if(!(txtOrderNo == null || txtOrderNo.length == 0)){
        orderNo = txtOrderNo;
        whereSQL += " AND R.ORD_NO = '"+ txtOrderNo +"' ";
    }
     
     if($('#cowayStoreCode :selected').length > 0){
         whereSQL += " AND (";

         $('#cowayStoreCode :selected').each(function(i, mul){
             if(runNo > 0){
                 whereSQL += " OR M.CW_STORE_ID = '"+$(mul).val()+"' ";
                 storeCode += ", "+$(mul).text();

             }else{
                 whereSQL += " M.CW_STORE_ID = '"+$(mul).val()+"' ";
                 storeCode += $(mul).text();

             }
             runNo += 1;
         });
         whereSQL += ") ";
     }
     runNo = 0;
    
    if(!($("#txtCustIC").val().trim() == null || $("#txtCustIC").val().trim().length == 0)){
    	custIC = $("#txtCustIC").val().trim();
        whereSQL += " AND CUST.NRIC = '"+ custIC +"' ";
    }
    
    if($('#cmbSalesBy :selected').length > 0){
        whereSQL += " AND (";

        $('#cmbSalesBy :selected').each(function(i, mul){
            if(runNo > 0){
                whereSQL += " OR R.SALES_USER_ID = '"+$(mul).val()+"' ";
                salesBy += ", "+$(mul).text();

            }else{
                whereSQL += " R.SALES_USER_ID = '"+$(mul).val()+"' ";
                salesBy += $(mul).text();

            }
            runNo += 1;
        });
        whereSQL += ") ";
    }
    runNo = 0;
    
    whereSQL += " AND R.OY = '"+ year +"' " + " AND R.OM = '" + month +"' ";

    var date = new Date().getDate();
    if(date.toString().length == 1){
        date = "0" + date;
    }
    $("#reportDownFileName").val("CWStoreSalesOrder_"+date+(new Date().getMonth()+1)+new Date().getFullYear());

    if(viewType == "EXCEL"){
        $("#form #viewType").val("EXCEL");
        $("#form #reportFileName").val("/visualcut/CowayStoreSalesOrderRaw.rpt");
    }

    $("#form #V_ORDERNO").val(orderNo);
    $("#form #V_ORDERDATEFROM").val(orderDateFrom);
    $("#form #V_ORDERDATETO").val(orderDateTo);
    $("#form #V_STORECODE").val(storeCode);
    $("#form #V_APPTYPE").val(appType);
    $("#form #V_CUSTIC").val(custIC);
    $("#form #V_SALESBY").val(salesBy);
    $("#form #V_GTOMONTH").val(month);
    $("#form #V_GTOYEAR").val(year);
    $("#form #V_WHERESQL").val(whereSQL);
    $("#form #V_EXTRAWHERESQL").val(extraWhereSQL);
    $("#form #V_SELECTSQL").val("");
    $("#form #V_FULLSQL").val("");


    // 프로시져로 구성된 경우 꼭 아래 option을 넘겨야 함.
    var option = {
            isProcedure : true // procedure 로 구성된 리포트 인경우 필수.  => /payment/PaymentListing_Excel.rpt 는 프로시져로 구성된 파일임.
    };

    Common.report("form", option);

}

</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="sal.title.text.cwStoreSalesOrdRawData" /></h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#"><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<aside class="title_line"><!-- title_line start -->

</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id="form" name="form">

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
    <th scope="row"><spring:message code="sal.text.ordDate" /></th>
    <td>
    <div class="date_set w100p"><!-- date_set start -->
    <p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" id="dpOrderDateFr"/></p>
    <span><spring:message code="sal.title.to" /></span>
    <p><input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" id="dpOrderDateTo"/></p>
    </div><!-- date_set end -->
    </td>
    <th scope="row"><spring:message code="sal.text.appType" /></th>
    <td>
    <select class="multy_select w100p" multiple="multiple" id="cmbAppType">
        <option value="Free Trial">Free Trial</option>
        <option value="Instalment">Instalment</option>
        <option value="Rental">Rental</option>
        <option value="Outright">Outright</option>
    </select>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.ordNum" /></th>
    <td>
    <input type="text" title="" placeholder="" class="w100p" id="txtOrderNo"/></p>
    </td>
    <th scope="row"><spring:message code="sal.text.cwStoreCode" /></th>
    <td>
    <select id="cowayStoreCode" name="cowayStoreCode" class="multy_select w100p" multiple="multiple"></select>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.custIC" /></th>
    <td><input type="text" title="" placeholder="" class="w100p" id="txtCustIC"/></td>
    <th scope="row"><spring:message code="sal.text.salesBy" /></th>
    <td>
    <select class="multy_select w100p" multiple="multiple" id="cmbSalesBy">
        <option value="HP">HP</option>
        <option value="Cody">CODY</option>
        <option value="Others">OTHERS</option>
        <option value="Staff">STAFF</option>
    </select>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.gtoMonthYear" /></th>
    <td>
    <input type="text" id="cmbGtoMonthYear" name="cmbGtoMonthYear" title="Date" class="j_date2 w100p" />
    </td>
    <th scope="row"></th>
    <td></td>
</tr>
</tbody>
</table><!-- table end -->

<ul class="center_btns">
    <li><p class="btn_blue2"><a href="#" onclick="javascript:btnGenerate_Excel_Click();"><spring:message code="sal.btn.genExcel" /></a></p></li>
    <li><p class="btn_blue2"><a href="#" onclick="javascript:$('#form').clearForm();"><spring:message code="sal.btn.clear" /></a></p></li>
</ul>

<input type="hidden" id="reportFileName" name="reportFileName" value="" />
<input type="hidden" id="viewType" name="viewType" value="" />
<input type="hidden" id="reportDownFileName" name="reportDownFileName" value="" />

<input type="hidden" id="V_ORDERNO" name="V_ORDERNO" value="" />
<input type="hidden" id="V_ORDERDATEFROM" name="V_ORDERDATEFROM" value="" />
<input type="hidden" id="V_ORDERDATETO" name="V_ORDERDATETO" value="" />
<input type="hidden" id="V_STORECODE" name="V_STORECODE" value="" />
<input type="hidden" id="V_APPTYPE" name="V_APPTYPE" value="" />
<input type="hidden" id="V_CUSTIC" name="V_CUSTIC" value="" />
<input type="hidden" id="V_SALESBY" name="V_SALESBY" value="" />
<input type="hidden" id="V_GTOMONTH" name="V_GTOMONTH" value="" />
<input type="hidden" id="V_GTOYEAR" name="V_GTOYEAR" value="" />
<input type="hidden" id="V_WHERESQL" name="V_WHERESQL" value="" />
<input type="hidden" id="V_EXTRAWHERESQL" name="V_EXTRAWHERESQL" value="" />
<input type="hidden" id="V_SELECTSQL" name="V_SELECTSQL" value="" />
<input type="hidden" id="V_FULLSQL" name="V_FULLSQL" value="" />

</form>

</section><!-- content end -->

</section><!-- container end -->

</div><!-- popup_wrap end -->