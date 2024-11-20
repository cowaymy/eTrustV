<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">

$("#dataForm").empty();

var date = new Date().getDate();
if(date.toString().length == 1){
    date = "0" + date;
}
$("#dpSubmitDateFr").val(date+"/"+(new Date().getMonth()+1)+"/"+new Date().getFullYear());
$("#dpSubmitDateTo").val(date+"/"+(new Date().getMonth()+1)+"/"+new Date().getFullYear());

/* 멀티셀렉트 플러그인 start */
$('.multy_select').change(function() {
   //console.log($(this).val());
})
.multipleSelect({
   width: '100%'
});

function fn_multiCombo(){

    $('#_brnchId').change(function() {
        //console.log($(this).val());
    }).multipleSelect({
        selectAll: true, // 전체선택
        width: '100%'
    });
    $('#_brnchId').multipleSelect("checkAll");


}

$.fn.clearForm = function() {
    $("#_brnchId").multipleSelect("checkAll");

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
        $("#dpSubmitDateFr").val(date+"/"+(new Date().getMonth()+1)+"/"+new Date().getFullYear());
        $("#dpSubmitDateTo").val(date+"/"+(new Date().getMonth()+1)+"/"+new Date().getFullYear());
    });
};

function validRequiredField(){

    var valid = true;
    var message = "";

    if(($("#dpSubmitDateFr").val() == null || $("#dpSubmitDateFr").val().length == 0) || ($("#dpSubmitDateTo").val() == null || $("#dpSubmitDateTo").val().length == 0)){
        valid = false;
        message += 'Please key in submit date';
    }

    if($('#_brnchId :selected').length < 1){
       valid = false;
        message += 'Please select at least one branch';
    }


    if(valid == false){
        alert(message);
    }

    return valid;

}


function btnGenerate_Click(){
    if(validRequiredField() == true){
        fn_report("PDF");
    }else{
        return false;
    }
}

function btnGenerate_Excel_Click(){
    if(validRequiredField() == true){
           fn_report("EXCEL");
    }else{
        return false;
    }
}

function fn_report(viewType){

    $("#reportFileName").val("");
    $("#reportDownFileName").val("");
    $("#viewType").val("");


    var submitDateFrom = "";
    var submitDateTo = "";
    var keyInBranch = "";
    var memType ="";
    var whereSQL = "";
    var extraWhereSQL = "";
    var orderBySQL = "";

    var runNo = 0;


    if(!($("#dpSubmitDateFr").val() == null || $("#dpSubmitDateFr").val().length == 0) && !($("#dpSubmitDateTo").val() == null || $("#dpSubmitDateTo").val().length == 0)){

        submitDateFrom = $("#dpSubmitDateFr").val(); //dd/MM/yyyy
        submitDateTo = $("#dpSubmitDateTo").val();

        var frArr = $("#dpSubmitDateFr").val().split("/");
        var toArr = $("#dpSubmitDateTo").val().split("/");
        var dpSubmitDateFr = frArr[1]+"/"+frArr[0]+"/"+frArr[2]; // MM/dd/yyyy
        var dpSubmitDateTo = toArr[1]+"/"+toArr[0]+"/"+toArr[2];

        whereSQL += " AND (doc.DOC_SUB_DT BETWEEN TO_DATE('"+dpSubmitDateFr+" 00:00:00', 'MM/dd/YY HH24:MI:SS') AND TO_DATE('"+dpSubmitDateTo+" 23:59:59', 'MM/dd/YY HH24:MI:SS'))";
    }

   /*  if($('#_brnchId :selected').length > 0){
        whereSQL += " AND (";

        $('#_brnchId :selected').each(function(i, mul){
            if(runNo > 0){
                whereSQL += " OR BRNCH.BRNCH_ID = '"+$(mul).val()+"' ";
                keyInBranch += ", "+$(mul).text();

            }else{
                whereSQL += " BRNCH.BRNCH_ID = '"+$(mul).val()+"' ";
                keyInBranch += $(mul).text();

            }
            runNo += 1;
        });
        whereSQL += ") ";
    }
    runNo = 0; */
    
    if("${SESSION_INFO.roleId}" == 256) {
        whereSQL += " AND BRNCH.BRNCH_ID = "+"${SESSION_INFO.userBranchId}"+" ";
    }
    else {
         if($('#_brnchId :selected').length > 0){
                whereSQL += " AND (";

                $('#_brnchId :selected').each(function(i, mul){
                    if(runNo > 0){
                        whereSQL += " OR BRNCH.BRNCH_ID = '"+$(mul).val()+"' ";
                        keyInBranch += ", "+$(mul).text();

                    }else{
                        whereSQL += " BRNCH.BRNCH_ID = '"+$(mul).val()+"' ";
                        keyInBranch += $(mul).text();

                    }
                    runNo += 1;
                });
                whereSQL += ") ";
            }
            runNo = 0;
    }

    if($("#cmbMemType :selected").index() > 0){
    	memType = $("#cmbMemType :selected").val();
        whereSQL += " AND M.MEM_TYPE = '"+$("#cmbMemType :selected").val()+"'";
    }



    orderBySQL = " ORDER BY som.SALES_ORD_NO";


    var date = new Date().getDate();
    if(date.toString().length == 1){
        date = "0" + date;
    }
    $("#reportDownFileName").val("OrderEKeyInList_"+date+(new Date().getMonth()+1)+new Date().getFullYear());

    if(viewType == "PDF"){
        $("#form #viewType").val("PDF");
        $("#form #reportFileName").val("/sales/OrderEKeyInList.rpt");
    }else if(viewType == "EXCEL"){
        $("#form #viewType").val("EXCEL");
        $("#form #reportFileName").val("/sales/OrderEKeyInList_Excel.rpt");
    }


    $("#form #V_SUBMITDATEFROM").val(submitDateFrom);
    $("#form #V_SUBMITDATETO").val(submitDateTo);
    $("#form #V_KEYINBRANCH").val(keyInBranch);
    $("#form #V_MEMTYPE").val(memType);
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

doGetComboSepa('/common/selectBranchCodeList.do',  '1', ' - ', '', '_brnchId', 'M', 'fn_multiCombo'); //Branch Code

</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>eKey-In Listing</h1>
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

</colgroup>
<tbody>
<tr>
    <th scope="row">Member Type</th>
    <td>
    <select class="w100p" id="cmbMemType">
        <option value="1" selected>Health Planner</option>
    </select>
    </td>

</tr>
<tr>
    <th scope="row">Submit Branch</th>
    <td><select id="_brnchId" name="_brnchId" class="multy_select w100p" multiple="multiple"></select></td>
</tr>
<tr>
    <th scope="row">Submit Date</th>
    <td>
    <div class="date_set w100p"><!-- date_set start -->
    <p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" id="dpSubmitDateFr"/></p>
    <span><spring:message code="sal.title.to" /></span>
    <p><input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" id="dpSubmitDateTo"/></p>
    </div><!-- date_set end -->
    </td>
</tr>

</tbody>
</table><!-- table end -->

<ul class="center_btns">
    <li><p class="btn_blue2"><a href="#" onclick="javascript:btnGenerate_Click();"><spring:message code="sal.btn.genPDF" /></a></p></li>
    <li><p class="btn_blue2"><a href="#" onclick="javascript:btnGenerate_Excel_Click();"><spring:message code="sal.btn.genExcel" /></a></p></li>
    <li><p class="btn_blue2"><a href="#" onclick="javascript:$('#form').clearForm();"><spring:message code="sal.btn.clear" /></a></p></li>
</ul>

<input type="hidden" id="reportFileName" name="reportFileName" value="" />
<input type="hidden" id="viewType" name="viewType" value="" />
<input type="hidden" id="reportDownFileName" name="reportDownFileName" value="" />

<input type="hidden" id="V_SUBMITDATEFROM" name="V_SUBMITDATEFROM" value="" />
<input type="hidden" id="V_SUBMITDATETO" name="V_SUBMITDATETO" value="" />
<input type="hidden" id="V_KEYINBRANCH" name="V_KEYINBRANCH" value="" />
<input type="hidden" id="V_MEMTYPE" name="V_MEMTYPE" value="" />
<input type="hidden" id="V_WHERESQL" name="V_WHERESQL" value="" />
<input type="hidden" id="V_EXTRAWHERESQL" name="V_EXTRAWHERESQL" value="" />
<input type="hidden" id="V_ORDERBYSQL" name="V_ORDERBYSQL" value="" />
<input type="hidden" id="V_SELECTSQL" name="V_SELECTSQL" value="" />
<input type="hidden" id="V_FULLSQL" name="V_FULLSQL" value="" />

</form>

</section><!-- content end -->

</section><!-- container end -->

</div><!-- popup_wrap end -->