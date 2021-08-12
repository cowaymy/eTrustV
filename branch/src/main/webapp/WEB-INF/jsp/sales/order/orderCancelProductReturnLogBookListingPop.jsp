<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>


<script type="text/javascript">

var date = new Date().getDate();
var mon = new Date().getMonth()+1;
if(date.toString().length == 1){
    date = "0" + date;
}
if(mon.toString().length == 1){
    mon = "0" + mon;
}
$("#dpAppointmentDtFrom").val("01/"+mon+"/"+new Date().getFullYear());
$("#dpAppointmentDtTo").val(date+"/"+mon+"/"+new Date().getFullYear());

/* 멀티셀렉트 플러그인 start */
$('.multy_select').change(function() {
   //console.log($(this).val());
})
.multipleSelect({
   width: '100%'
});

$.fn.clearForm = function() {

	$("#cmbProductRetType").multipleSelect("checkAll");
    $("#cmbAppType").multipleSelect("checkAll");


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
        $("#dpAppointmentDtFrom").val("01/"+(new Date().getMonth()+1)+"/"+new Date().getFullYear());
        $("#dpAppointmentDtTo").val(date+"/"+(new Date().getMonth()+1)+"/"+new Date().getFullYear());



    });
};

function btnGenerate_Click(){

	var whereSQL = "";
	var orderBySQL = "";
	var retType = "";
	var appDateFrom = "";
	var appDateTo = "";
	var ctCodeFrom = "";
	var ctCodeTo = "";
	var dscBranch = "";
	var ctGroup = "";
    var runNo = 0;


    if($("#cmbProductRetType :selected").length > 0){
        whereSQL += " AND (";

        $('#cmbProductRetType :selected').each(function(i, mul){
            if(runNo > 0){
                whereSQL += " OR re.TYPE_ID = '"+$(mul).val()+"' ";
                retType = "All"
            }else{
                whereSQL += " re.TYPE_ID = '"+$(mul).val()+"' ";
                retType = $("#cmbProductRetType :selected").text();
            }
            runNo += 1;
        });

        whereSQL += ") ";
        runNo = 0;

    }

    if($("#cmbAppType :selected").length > 0){
        whereSQL += " AND (";

        $('#cmbAppType :selected').each(function(i, mul){
            if(runNo > 0){
                whereSQL += " OR som.APP_TYPE_ID = '"+$(mul).val()+"' ";
            }else{
                whereSQL += " som.APP_TYPE_ID = '"+$(mul).val()+"' ";
            }
            runNo += 1;
        });
        whereSQL += ") ";
        runNo = 0;
    }

    if(!($("#dpAppointmentDtFrom").val() == null || $("#dpAppointmentDtFrom").val().length == 0)){
        whereSQL += " AND re.APP_DT >= TO_DATE('"+$("#dpAppointmentDtFrom").val()+"', 'dd/MM/YY') ";
        appDateFrom = $("#dpAppointmentDtFrom").val();
    }

    if(!($("#dpAppointmentDtTo").val() == null || $("#dpAppointmentDtTo").val().length == 0)){
        whereSQL += " AND re.APP_DT < TO_DATE('"+$("#dpAppointmentDtTo").val()+"', 'dd/MM/YY')+1 "; //AddDays(1)
        appDateTo = $("#dpAppointmentDtTo").val();
    }

    if($("#dscCode :selected").index() > 0){
        whereSQL += " AND i.BRNCH_ID = '"+$("#dscCode :selected").val()+"'";
        dscBranch = $("#dscCode :selected").text();
    }

    if($("#CTGroup :selected").index() > 0){
        whereSQL += " AND re.CT_GRP = '"+$("#dscCode :selected").val()+"'";
        ctGroup = $("#CTGroup :selected").text();
    }

    if(!($("#txtCTCodeFrom").val().trim() == null || $("#txtCTCodeFrom").val().trim().length == 0 || $("#txtCTCodeTo").val().trim() == null || $("#txtCTCodeTo").val().trim().length == 0)){
        whereSQL += " AND (m.MEM_CODE between '"+$("#txtCTCodeFrom").val().trim().replace("'", "''")+"' AND '"+$("#txtCTCodeTo").val().trim().replace("'", "''")+"')";
        ctCodeFrom = $("#txtCTCodeFrom").val().trim();
        ctCodeTo = $("#txtCTCodeTo").val().trim();

    }

    if($("#SortBy :selected").val() == 1) {
    	orderBySQL += " ORDER BY RETNO ";
    }

    if($("#SortBy :selected").val() == 2) {
        orderBySQL += " ORDER BY ORDERNO ";
    }

    if($("#SortBy :selected").val() == 3) {
        orderBySQL += " ORDER BY CTCODE ";
    }



    $("#form #V_WHERESQL").val(whereSQL);
    $("#form #V_ORDERBYSQL").val(orderBySQL);
    $("#form #V_RETTYPE").val(retType);
    $("#form #V_APPDATEFROM").val(appDateFrom);
    $("#form #V_APPDATETO").val(appDateTo);
    $("#form #V_CTCODEFROM").val(ctCodeFrom);
    $("#form #V_CTCODETO").val(ctCodeTo);
    $("#form #V_DSCBRANCH").val(dscBranch);
    $("#form #V_CTGROUP").val(ctGroup);
    $("#form #V_SELECTSQL").val("");
    $("#form #V_SELECTSQL2").val("");
    $("#form #V_FULLSQL").val("");


    $("#reportDownFileName").val("OrderCancellationProductReturnLogBookListing_"+date+(new Date().getMonth()+1)+new Date().getFullYear());
    $("#form #reportFileName").val("/sales/ProductReturnLogBookListing.rpt");
    $("#form #viewType").val("PDF");

    // 프로시져로 구성된 경우 꼭 아래 option을 넘겨야 함.
    var option = {
            isProcedure : true // procedure 로 구성된 리포트 인경우 필수.  => /payment/PaymentListing_Excel.rpt 는 프로시져로 구성된 파일임.
    };

    Common.report("form", option);

}

doGetComboSepa("/common/selectBranchCodeList.do",'5' , '-',''   , 'dscCode' , 'S', '');
CommonCombo.make('cmbAppType', '/sales/order/getApplicationTypeList', {codeId : 10} , '', {type: 'M'});


</script>


<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Order Cancellation Product Return Log Book Listing</h1>
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

<tbody>
<tr>

    <th scope="row">Product Return Type</th>
    <td>
    <select class="multy_select w100p" multiple="multiple" id="cmbProductRetType">
        <option value="296" selected>Order Cancellation Product Return</option>
        <option value="297" selected>Product Exchange Product Return</option>
    </select>
    </td>
    <th scope="row">Appointment Date</th>
    <td>
    <div class="date_set w100p"><!-- date_set start -->
    <p><input type="text" title="Appointment start Date" placeholder="DD/MM/YYYY" class="j_date" id="dpAppointmentDtFrom"/></p>
    <span><spring:message code="sal.text.to" /></span>
    <p><input type="text" title="Appointment end Date" placeholder="DD/MM/YYYY" class="j_date" id="dpAppointmentDtTo"/></p>
    </div><!-- date_set end -->
    </td>
</tr>

<tr>
    <th scope="row"><spring:message code='service.title.DSCCode'/></th>
    <td>
    <select class="w100p" id="dscCode" name="dscCode">
        <option value="">11</option>
        <option value="">22</option>
        <option value="">33</option>
    </select>
    </td>
    <th scope="row"><spring:message code="sal.text.appType" /></th>
    <td>
    <select class="multy_select w100p" multiple="multiple" id="cmbAppType"></select>
    </td>
</tr>

<tr>
    <th scope="row">CT Group</th>
    <td>
    <select class="w100p" id="CTGroup" >
        <option value="">Choose One</option>
        <option value="A">A</option>
        <option value="B">B</option>
        <option value="C">C</option>
    </select>
    </td>
    <th scope="row">CT Code</th>
    <td>
    <div class="date_set w100p">
    <p><input type="text" title=""  class="w100p" id="txtCTCodeFrom"/></p>
    <span><spring:message code="sal.text.to" /></span>
    <p><input type="text" title=""  class="w100p" id="txtCTCodeTo"/></p>
    </div>
    </td>
</tr>

<tr>
    <th scope="row">Sort By</th>
    <td>
    <select class="w100p" id="SortBy" >
        <option value="1" selected>Ret Number</option>
        <option value="2">Order Number</option>
        <option value="3">CT Code</option>
    </select>
    </td>

</tr>

</tbody>
</table><!-- table end -->



<input type="hidden" id="reportFileName" name="reportFileName" value="" />
<input type="hidden" id="viewType" name="viewType" value="PDF" />
<input type="hidden" id="reportDownFileName" name="reportDownFileName" value="" />

<input type="hidden" id="V_RETTYPE" name="V_RETTYPE" value="">
<input type="hidden" id="V_APPDATEFROM" name="V_APPDATEFROM" value="">
<input type="hidden" id="V_APPDATETO" name="V_APPDATETO" value="">
<input type="hidden" id="V_CTCODEFROM" name="V_CTCODEFROM" value="">
<input type="hidden" id="V_CTCODETO" name="V_CTCODETO" value="">
<input type="hidden" id="V_DSCBRANCH" name="V_DSCBRANCH" value="">
<input type="hidden" id="V_CTGROUP" name="V_CTGROUP" value="">
<input type="hidden" id="V_WHERESQL" name="V_WHERESQL" value="" />
<input type="hidden" id="V_ORDERBYSQL" name="V_ORDERBYSQL" value="" />
<input type="hidden" id="V_SELECTSQL" name="V_SELECTSQL" value="" />
<input type="hidden" id="V_SELECTSQL2" name="V_SELECTSQL2" value="" />
<input type="hidden" id="V_FULLSQL" name="V_FULLSQL" value="" />

</form>



<div style="height: 80px">
</div>
<ul class="right_btns">
    <li><p class="btn_blue"><a href="#" onclick="javascript: btnGenerate_Click()"><spring:message code="sal.btn.generate" /></a></p></li>
    <li><p class="btn_blue"><a href="#" onclick="javascript:$('#form').clearForm();"><span class="clear"></span><spring:message code="sal.btn.clear" /></a></p></li>
</ul>
</section><!-- content end -->

</section><!-- container end -->

</div><!-- popup_wrap end -->