<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">

$(document).ready(function() {
   //doGetComboData('/organization/selectMemberTypeHP.do','', '', 'cmbMemType', 'S','');
   // CommonCombo.make('cmbDepartmentCode', '/organization/organization/getDeptCodeList', {memLvl : 3, memType : 2} , '');
    //CommonCombo.make('searchBranch', '/logistics/returnusedparts/selectBranchList.do', '' , '');
   // doGetComboData('/organization/selectApprovalBranch.do', '' , '', 'cmbBranchCode', 'M','');
    CommonCombo.make('cmbBranchCode', '/organization/selectApprovalBranch.do', '', '', {type:'M', isCheckAll:true});



});

function f_multiComboType() {
    $(function() {
        $('#cmbBranchCode').change(function() {
        }).multipleSelect({
            selectAll : true
        });
    });
}

/* 멀티셀렉트 플러그인 start */
$('.multy_select').change(function() {
   //console.log($(this).val());
})
.multipleSelect({
   width: '100%'
});

$.fn.clearForm = function() {
    $("#cmbBranchCode").multipleSelect("checkAll");

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



        $("#dpJoinedDateFrom").empty();
        $("#dpJoinedDateTo").empty();



    });
};

function validRequiredField(){

    var valid = true;
    var message = "";

    if(($("#dpJoinedDateFrom").val() == null || $("#dpJoinedDateFrom").val().length == 0) || ($("#dpJoinedDateTo").val() == null || $("#dpJoinedDateTo").val().length == 0)){

        valid = false;
        message += 'Please select Joined Date';
    }


   /*  if($("#cmbBranchCode").val() == null || $("#cmbBranchCode").val().length == 0){
        valid = false;
        message += 'Please select Branch Code';
   } */

    if(valid == false){
        Common.alert('<spring:message code="sal.alert.title.reportGenSummary" />' + DEFAULT_DELIMITER + message);

    }

    return valid;
}



function btnGeneratePDF_Click(){
    if(validRequiredField() == true){

        var memType = "";
        var approvalBranch = "";
        var joinedDateFrom = "";
        var joinedDateTo = "";
        var whereSQL = "";
        var orderBySQL = "";

        $("#reportFileName").val("");
        $("#reportDownFileName").val("");
        $("#viewType").val("");

        if($("#cmbMemType :selected").val() > 0){

            whereSQL += " AND A.MEM_TYPE = '"+$("#cmbMemType").val()+"'";
            memType = $("#cmbMemType :selected").text();

        }

        if(!($("#dpJoinedDateFrom").val() == null || $("#dpJoinedDateFrom").val().length == 0)){
            whereSQL += " AND TO_DATE(A.CRT_DT) >= TO_DATE('"+$("#dpJoinedDateFrom").val()+"', 'dd/MM/YYYY')";
            joinedDateFrom = $("#dpJoinedDateFrom").val();

        }

        if(!($("#dpJoinedDateTo").val() == null || $("#dpJoinedDateTo").val().length == 0)){
            whereSQL += " AND TO_DATE(A.CRT_DT) <= TO_DATE('"+$("#dpJoinedDateTo").val()+"', 'dd/MM/YYYY')";
            joinedDateTo = $("#dpJoinedDateTo").val();

        }


            if($('#cmbBranchCode :selected').length > 0){
                whereSQL += " AND ";
            var cnt = 0;
            $('#cmbBranchCode :selected').each(function(j, mul){
                if(cnt == 0){
                	approvalBranch += $(mul).val();
                }else{
                	approvalBranch += ", "+$(mul).val();
                }
                cnt += 1;

            });
            whereSQL += " A.BRNCH IN ("+approvalBranch+") ";
        }





        var date = new Date().getDate();
        if(date.toString().length == 1){
            date = "0" + date;
        }

        $("#form #viewType").val("EXCEL");
        $("#form #reportFileName").val("/organization/HPRawData_Excel.rpt");
        $("#reportDownFileName").val("HPRawData"+date+(new Date().getMonth()+1)+new Date().getFullYear());
        orderBySQL += " ORDER BY H.UPD_DT ";




        $("#form #V_WHERESQL").val(whereSQL);
        $("#form #V_MEMTYPE").val(memType);
        $("#form #V_APPVBRANCH").val(approvalBranch);
        $("#form #V_JOINEDDATEFROM").val(joinedDateFrom);
        $("#form #V_JOINEDDATETO").val(joinedDateTo);
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

<div id="popup_wrap" class="popup_wrap size_small"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>HP Raw Listing</h1>
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
    <col style="width:100px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Member Type</th>
    <td>
    <select class="w100p disabled" id="cmbMemType" >
        <option value="1" selected>Health Planner</option>
    </select>
    </td>

</tr>
<tr>
    <th scope="row">Approval Branch</th>
    <td>
        <select class="multy_select w100p" multiple="multiple" id="cmbBranchCode" data-placeholder="Branch Code"></select>
    </td>
</tr>
<tr>
    <th scope="row">Joined Date</th>
    <td>
    <div class="date_set w100p"><!-- date_set start -->
    <p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" id="dpJoinedDateFrom"/></p>
    <span><spring:message code="sal.title.to" /></span>
    <p><input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" id="dpJoinedDateTo"/></p>
    </div><!-- date_set end -->
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
<input type="hidden" id="V_MEMTYPE" name="V_MEMTYPE" value="" />
<input type="hidden" id="V_APPVBRANCH" name="V_APPVBRANCH" value="" />
<input type="hidden" id="V_JOINEDDATEFROM" name="V_JOINEDDATEFROM" value="" />
<input type="hidden" id="V_JOINEDDATETO" name="V_JOINEDDATETO" value="" />
<input type="hidden" id="V_ORDERBYSQL" name="V_ORDERBYSQL" value="" />
<input type="hidden" id="V_SELECTSQL" name="V_SELECTSQL" value="" />
<input type="hidden" id="V_FULLSQL" name="V_FULLSQL" value="" />


</form>

</section><!-- content end -->

</section><!-- container end -->

</div><!-- popup_wrap end -->