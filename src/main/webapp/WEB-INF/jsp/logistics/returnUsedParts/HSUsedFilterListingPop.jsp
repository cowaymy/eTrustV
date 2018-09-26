<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">

$(document).ready(function() {
	doGetComboData('/logistics/returnusedparts/selectBranchCodeList.do','', '', 'cmbBranchCode', 'S','');
	CommonCombo.make('cmbDepartmentCode', '/logistics/returnusedparts/getDeptCodeList', {memLvl : 3, memType : 2} , '');
	//CommonCombo.make('searchBranch', '/logistics/returnusedparts/selectBranchList.do', '' , '');

});

/* 멀티셀렉트 플러그인 start */
$('.multy_select').change(function() {
   //console.log($(this).val());
})
.multipleSelect({
   width: '100%'
});

$.fn.clearForm = function() {
    $("#cmbReturnStatus").multipleSelect("checkAll");

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



        $("#cmbDepartmentCode").empty();
        $("#cmbCodyCode").empty();
        $("#cmbBranchCode").empty();
        $("#dpHSSettleDateFrom").empty();
        $("#dpHSSettleDateTo").empty();



    });
};

function validRequiredField(){

    var valid = true;
    var message = "";

    if(($("#dpHSSettleDateFrom").val() == null || $("#dpHSSettleDateFrom").val().length == 0) || ($("#dpHSSettleDateTo").val() == null || $("#dpHSSettleDateTo").val().length == 0)){

        valid = false;
        message += 'Please select HS Settle Date';
    }

    if($("#cmbListingType").val() == 2 ){
    	if($("#cmbCodyCode").val() == null || $("#cmbCodyCode").val().length == 0){
    		 valid = false;
    	     message += 'Please select Cody Code';
    	}
    }

    if($("#cmbDepartmentCode").val() == null || $("#cmbDepartmentCode").val().length == 0){
        valid = false;
        message += 'Please select Department Code';
   }

    if(valid == false){
        Common.alert('<spring:message code="sal.alert.title.reportGenSummary" />' + DEFAULT_DELIMITER + message);

    }

    return valid;
}

function cmbDepartmentCode_SelectedIndexChanged(){
	CommonCombo.make('cmbCodyCode', '/logistics/returnusedparts/getCodyCodeList', {memLvl : 4, memType : 2, upperLineMemberID : $("#cmbDepartmentCode").val()}, '');


}


function btnGeneratePDF_Click(){
    if(validRequiredField() == true){

        var listingType = "";
        var hsSettleDateFrom = "";
        var hsSettleDateTo = "";
        var retStatus = "";
        var warehouseCode = "";
        var deptCode = "";
        var codyCode = "";
        var whereSQL = "";
        var orderBySQL = "";

        $("#reportFileName").val("");
        $("#reportDownFileName").val("");
        $("#viewType").val("");


        if(!($("#dpHSSettleDateFrom").val() == null || $("#dpHSSettleDateFrom").val().length == 0)){
            whereSQL += " AND TO_CHAR(l82.SVC_DT, 'yyyymmdd') >= TO_CHAR(TO_DATE('"+$("#dpHSSettleDateFrom").val()+"', 'dd/MM/YYYY'), 'yyyymmdd')";
            hsSettleDateFrom = $("#dpHSSettleDateFrom").val();

        }

        if(!($("#dpHSSettleDateTo").val() == null || $("#dpHSSettleDateTo").val().length == 0)){
            whereSQL += " AND TO_CHAR(l82.SVC_DT, 'yyyymmdd') <= TO_CHAR(TO_DATE('"+$("#dpHSSettleDateTo").val()+"', 'dd/MM/YYYY'), 'yyyymmdd')";
            hsSettleDateTo = $("#dpHSSettleDateTo").val();

        }

        if($('#cmbReturnStatus :selected').length > 0){
            whereSQL += " AND (";
            var runNo = 0;

            $('#cmbReturnStatus :selected').each(function(i, mul){
                if(runNo == 0){
                    if($(mul).val() == "N"){
                        whereSQL += " l82.CMPLT_YN is null ";
                    }else{
                        whereSQL += " l82.CMPLT_YN = '"+$(mul).val()+"' ";
                    }
                    retStatus += "'"+$(mul).val()+"'";
                }else{
                    if($(mul).val() == "N"){
                        whereSQL += " OR l82.CMPLT_YN is null ";
                    }else{
                        whereSQL += " OR l82.CMPLT_YN = '"+$(mul).val()+"' ";
                    }
                    retStatus += ", '"+$(mul).val()+"'";
                }

                runNo += 1;
            });
            whereSQL += ") ";
        }

        if($("#cmbBranchCode :selected").val() > 0){

            whereSQL += " AND o01.BRNCH = '"+$("#cmbBranchCode").val()+"'";
            warehouseCode = $("#cmbBranchCode :selected").text();

        }

        if($("#cmbDepartmentCode :selected").val() > 0){

            whereSQL += " AND ov.MEM_UP_ID = '"+$("#cmbDepartmentCode").val()+"'";
            deptCode = $("#cmbDepartmentCode :selected").text();
        }

        if($("#cmbCodyCode :selected").val() > 0){

            whereSQL += " AND l82.MEM_ID = '"+$("#cmbCodyCode").val()+"'";
            codyCode = $("#cmbCodyCode :selected").text();

        }

        var date = new Date().getDate();
        if(date.toString().length == 1){
            date = "0" + date;
        }

        $("#form #viewType").val("PDF");
        if($("#cmbListingType :selected").val() == 1){
        	$("#form #reportFileName").val("/logistics/HSUsedFilterListing_PDF.rpt");
        	$("#reportDownFileName").val("HSUsedFilterListing"+date+(new Date().getMonth()+1)+new Date().getFullYear());
        	orderBySQL += " ORDER BY l82.SVC_DT, l82.SVC_ORD_ID ";

        }
        if($("#cmbListingType :selected").val() == 2){
            $("#form #reportFileName").val("/logistics/HSUsedFilterSummaryListing_PDF.rpt");
            $("#reportDownFileName").val("HSUsedFilterSummaryListing"+date+(new Date().getMonth()+1)+new Date().getFullYear());
        }


        $("#form #V_WHERESQL").val(whereSQL);
        $("#form #V_HSSETTLEDATEFROM").val(hsSettleDateFrom);
        $("#form #V_HSSETTLEDATETO").val(hsSettleDateTo);
        $("#form #V_RETSTATUS").val(retStatus);
        $("#form #V_WAREHOUSECODE").val(warehouseCode);
        $("#form #V_DEPTCODE").val(deptCode);
        $("#form #V_CODYCODE").val(codyCode);
        $("#form #V_ORDERBYSQL").val(orderBySQL);
        $("#form #V_SELECTSQL").val("");
        $("#form #V_FULLSQL").val("");

        // 프로시져로 구성된 경우 꼭 아래 option을 넘겨야 함.
        var option = {
                isProcedure : true // procedure 로 구성된 리포트 인경우 필수.  => /payment/PaymentListing_Excel.rpt 는 프로시져로 구성된 파일임.
        };

        Common.report("form", option);

    }else{
        return false;
    }
}


</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Cody HS Used Filter Listing</h1>
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
    <th scope="row">Listing Type</th>
    <td>
    <select class="w100p" id="cmbListingType" >
        <option value="1" selected>HS Used Filter Listing</option>
        <option value="2">HS Used Filter Summary Listing</option>
    </select>
    </td>
    <th scope="row">HS Settle Date</th>
    <td>
    <div class="date_set w100p"><!-- date_set start -->
    <p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" id="dpHSSettleDateFrom"/></p>
    <span><spring:message code="sal.title.to" /></span>
    <p><input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" id="dpHSSettleDateTo"/></p>
    </div><!-- date_set end -->
    </td>
</tr>
<tr>
    <th scope="row">Return Status</th>
    <td>
    <select class="multy_select w100p" multiple="multiple" id="cmbReturnStatus">
        <option value="N" selected>Not Yet</option>
        <option value="Y" selected>Done</option>
    </select>
    </td>
    <th scope="row">Warehouse Code</th>
    <td>
    <select class="w100p" id="cmbBranchCode"  name="cmbBranchCode"></select>
    </td>
</tr>
<tr>
    <th scope="row">Department Code (CM)</th>
    <td>
    <select class="w100p" id="cmbDepartmentCode"  onchange="cmbDepartmentCode_SelectedIndexChanged()"></select>
    </td>
    <th scope="row">Cody Member</th>
    <td>
    <select class="w100p" id="cmbCodyCode"   name="cmbCodyCode"></select>
    </td>
</tr>

</tbody>
</table><!-- table end -->

<ul class="center_btns">
    <li><p class="btn_blue2"><a href="#" onclick="javascript: btnGeneratePDF_Click()">Generate</a></p></li>
    <li><p class="btn_blue2"><a href="#" onclick="javascript:$('#form').clearForm();"><spring:message code="sal.btn.clear" /></a></p></li>
</ul>

<input type="hidden" id="reportFileName" name="reportFileName" value="" />
<input type="hidden" id="viewType" name="viewType" value="" />
<input type="hidden" id="reportDownFileName" name="reportDownFileName" value="" />

<input type="hidden" id="V_WHERESQL" name="V_WHERESQL" value="" />
<input type="hidden" id="V_HSSETTLEDATEFROM" name="V_HSSETTLEDATEFROM" value="" />
<input type="hidden" id="V_HSSETTLEDATETO" name="V_HSSETTLEDATETO" value="" />
<input type="hidden" id="V_RETSTATUS" name="V_RETSTATUS" value="" />
<input type="hidden" id="V_WAREHOUSECODE" name="V_WAREHOUSECODE" value="" />
<input type="hidden" id="V_DEPTCODE" name="V_DEPTCODE" value="" />
<input type="hidden" id="V_CODYCODE" name="V_CODYCODE" value="" />
<input type="hidden" id="V_ORDERBYSQL" name="V_ORDERBYSQL" value="" />
<input type="hidden" id="V_SELECTSQL" name="V_SELECTSQL" value="" />
<input type="hidden" id="V_FULLSQL" name="V_FULLSQL" value="" />


</form>

</section><!-- content end -->

</section><!-- container end -->

</div><!-- popup_wrap end -->