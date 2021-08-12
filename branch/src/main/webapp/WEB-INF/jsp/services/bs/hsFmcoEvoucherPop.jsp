<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">
var userId = '${SESSION_INFO.userId}';
var MEM_TYPE     = '${SESSION_INFO.userTypeId}';

$(document).ready(function() {

});


$("#dataForm").empty();

var month = new Date().getMonth();
if(month.toString().length == 1){
	month = "0" + month;
}
$("#hsMonth").val(month+"/"+new Date().getFullYear());

/* 멀티셀렉트 플러그인 start */
$('.multy_select').change(function() {
   //console.log($(this).val());
})
.multipleSelect({
   width: '100%'
});

$.fn.clearForm = function() {
    $("#cmbVoucherType").multipleSelect("checkAll");

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
        var month = new Date().getMonth();
        if(month.toString().length == 1){
            month = "0" + month;
        }
        $("#hsMonth").val(month+"/"+new Date().getFullYear());
    });
};

function btnGenerate_Excel_Click(){
	 if(validRequiredField() == true){
         fn_report("EXCEL");
  }else{
      return false;
  }
}

function validRequiredField(){

    var valid = true;
    var message = "";

    if($('#cmbVoucherType :selected').length < 1){
       valid = false;
        message += '* Please select at least one E-Voucher.';
    }

    if(valid == false){
        alert(message);
    }

    return valid;

}

function fn_report(viewType){

    $("#reportFileName").val("");
    $("#reportDownFileName").val("");
    $("#viewType").val("");

    var orderNoFrom = "";
    var orderNoTo = "";
    var orderDateFrom = "";
    var orderDateTo = "";
    var branchRegion = "";
    var keyInBranch = "";
    var appType = "";
    var sortBy = "";
    var whereSQL = "";
    var extraWhereSQL = "";
    var orderBySQL = "";
    var custName = "";
    var runNo = 0;


    if(!($("#hsMonth").val() == null || $("#hsMonth").val().length == 0)){

        hsDate = $("#hsMonth").val(); //MM/yyyy

        var hsDateArr = $("#hsMonth").val().split("/"); // MM/yyyy

        whereSQL += "and svc.month = '"+hsDateArr[0]+"' and svc.year = '"+hsDateArr[1]+"'";
    }

    if($('#cmbVoucherType :selected').length > 0){
        whereSQL += " AND (";

        $('#cmbVoucherType :selected').each(function(i, mul){
            if(runNo > 0){
                whereSQL += " OR SVCR.VOUCHER_REDEMPTION = '"+$(mul).val()+"' ";
                appType += ", "+$(mul).text();

            }else{
                whereSQL += " SVCR.VOUCHER_REDEMPTION = '"+$(mul).val()+"' ";
                appType += $(mul).text();

            }
            runNo += 1;
        });
        whereSQL += ") ";
    }
    runNo = 0;


    orderBySQL = " ORDER BY SVCR.VOUCHER_REDEMPTION ";

    var date = new Date().getDate();
    var month = new Date().getMonth()+1;
    if(date.toString().length == 1){
        date = "0" + date;
    }
    if(month.toString().length == 1){
    	month = "0" + month;
    }
    $("#reportDownFileName").val("HSFmcoEvoucherRawData_"+date+month+new Date().getFullYear());


     if(viewType == "EXCEL"){
        $("#form #viewType").val("EXCEL");
        $("#form #reportFileName").val("/services/HSFmcoEvoucher.rpt");
    }

/*      $("#form #V_ORDERNOFROM").val(orderNoFrom);
     $("#form #V_ORDERNOTO").val(orderNoTo);
     $("#form #V_ORDERDATEFROM").val(orderDateFrom);
     $("#form #V_ORDERDATETO").val(orderDateTo);
     $("#form #V_BRANCHREGION").val(branchRegion);
     $("#form #V_KEYINBRANCH").val(keyInBranch);
     $("#form #V_APPTYPE").val(appType);
     $("#form #V_CUSTNAME").val(custName); */
     $("#form #V_SORTBY").val(sortBy);
     $("#form #V_WHERESQL").val(whereSQL);
     $("#form #V_EXTRAWHERESQL").val(extraWhereSQL);
     $("#form #V_ORDERBYSQL").val(orderBySQL);
     $("#form #V_SELECTSQL").val("");
     $("#form #V_FULLSQL").val("");


    // 프로시져로 구성된 경우 꼭 아래 option을 넘겨야 함.
    var option = {
            isProcedure : true // procedure 로 구성된 리포트 인경우 필수.  => /payment/PaymentListing_Excel.rpt 는 프로시져로 구성된 파일임.
    };

    Common.report("form", option);

}

CommonCombo.make('cmbVoucherType', '/services/bs/report/selectEVoucherList', {codeId : 10} , '', {type: 'M'});

</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Exchange Body Ambient Assy Report</h1>
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
    <th scope="row">HS Month</th>
    <td>
    <input type="text" title="HS Month" placeholder="MM/YYYY" class="j_date2 w100p" id="hsMonth" name="hsMonth"/>
    </td>
    <th scope="row">E-Voucher</th>
    <td>
    <select class="multy_select w100p" multiple="multiple" id="cmbVoucherType"></select>
    </td>
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

<!-- <input type="hidden" id="V_ORDERNOFROM" name="V_ORDERNOFROM" value="" />
<input type="hidden" id="V_ORDERNOTO" name="V_ORDERNOTO" value="" />
<input type="hidden" id="V_ORDERDATEFROM" name="V_ORDERDATEFROM" value="" />
<input type="hidden" id="V_ORDERDATETO" name="V_ORDERDATETO" value="" />
<input type="hidden" id="V_BRANCHREGION" name="V_BRANCHREGION" value="" />
<input type="hidden" id="V_KEYINBRANCH" name="V_KEYINBRANCH" value="" />
<input type="hidden" id="V_APPTYPE" name="V_APPTYPE" value="" />
<input type="hidden" id="V_CUSTNAME" name="V_CUSTNAME" value="" /> -->
<input type="hidden" id="V_SORTBY" name="V_SORTBY" value="" />
<input type="hidden" id="V_WHERESQL" name="V_WHERESQL" value="" />
<input type="hidden" id="V_EXTRAWHERESQL" name="V_EXTRAWHERESQL" value="" />
<input type="hidden" id="V_ORDERBYSQL" name="V_ORDERBYSQL" value="" />
<input type="hidden" id="V_SELECTSQL" name="V_SELECTSQL" value="" />
<input type="hidden" id="V_FULLSQL" name="V_FULLSQL" value="" />

</form>

</section><!-- content end -->

</section><!-- container end -->

</div><!-- popup_wrap end -->