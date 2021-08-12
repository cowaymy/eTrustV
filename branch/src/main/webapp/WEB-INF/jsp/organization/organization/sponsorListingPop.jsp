<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">

$(document).ready(function() {

    //CommonCombo.make('status', '/organization/selectStatus.do', '', '', {type:'M', isCheckAll:true});

	if("${SESSION_INFO.userTypeId}" == "1"  || "${SESSION_INFO.userTypeId}" == "2" ){


        $("#memCode").val("${memCode}");
        $("#memCode").attr("class", "w100p readonly");
        $("#memCode").attr("readonly", "readonly");

        $("#hiddenName").val("${name}");
        $("#hiddenName").attr("class", "w100p readonly");
        $("#hiddenName").attr("readonly", "readonly");
	}




});

function fn_onChgMemCode() {

    var memCode = $("#memCode").val();

    //if(memCode != '') {

    	Common.ajax("GET", "/organization/selectMemberName.do", $("#searchForm").serialize(), function(result) {
            $("#hiddenName").val(result[0].name);
        });


    //}

    //else{
    //	$("#hiddenName").val('');
    //}

}

function f_multiComboType() {
    $(function() {
        $('#status').change(function() {
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
    $("#status").multipleSelect("checkAll");

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


    if($("#status").val() == null || $("#status").val().length == 0){
        valid = false;
        message += 'Please select Status';
   }

    if($("#memCode").val() == null || $("#memCode").val().length == 0){
        valid = false;
        message += 'Please enter Member Code';
   }

    if(valid == false){
        Common.alert('<spring:message code="sal.alert.title.reportGenSummary" />' + DEFAULT_DELIMITER + message);

    }

    return valid;
}



function btnGeneratePDF_Click(){
    if(validRequiredField() == true){

        var memCode = "";
        var memName = "";
        var memStus = "";
        var memStusName = "";
        var joinedDateFrom = "";
        var joinedDateTo = "";
        var whereSQL = "";
        var orderBySQL = "";

        $("#reportFileName").val("");
        $("#reportDownFileName").val("");
        $("#viewType").val("");

        if(!($("#memCode").val() == null || $("#memCode").val().length == 0)){

            whereSQL += " AND A.SPONS_CODE = '"+$("#memCode").val()+"'";
            memCode = $("#memCode").val();

        }

        if(!($("#hiddenName").val() == null || $("#hiddenName").val().length == 0)){
        	memName = $("#hiddenName").val();

        }

        if(!($("#dpJoinedDateFrom").val() == null || $("#dpJoinedDateFrom").val().length == 0)){
            whereSQL += " AND TO_DATE(A.CRT_DT) >= TO_DATE('"+$("#dpJoinedDateFrom").val()+"', 'dd/MM/YYYY')";
            joinedDateFrom = $("#dpJoinedDateFrom").val();

        }

        if(!($("#dpJoinedDateTo").val() == null || $("#dpJoinedDateTo").val().length == 0)){
            whereSQL += " AND TO_DATE(A.CRT_DT) <= TO_DATE('"+$("#dpJoinedDateTo").val()+"', 'dd/MM/YYYY')";
            joinedDateTo = $("#dpJoinedDateTo").val();

        }


            if($('#status :selected').length > 0){
                whereSQL += " AND ";
            var cnt = 0;
            $('#status :selected').each(function(j, mul){
                if(cnt == 0){
                	memStus += $(mul).val();
                	memStusName += $(mul).text();
                }else{
                	memStus += ", "+$(mul).val();
                	memStusName += ", "+$(mul).text();
                }
                cnt += 1;

            });
            whereSQL += " A.STUS IN ("+memStus+") ";
        }





        var date = new Date().getDate();
        if(date.toString().length == 1){
            date = "0" + date;
        }

        $("#searchForm #viewType").val("PDF");
        $("#searchForm #reportFileName").val("/organization/SponsorListing_PDF.rpt");
        $("#reportDownFileName").val("SponsorListing"+date+(new Date().getMonth()+1)+new Date().getFullYear()+"_"+memCode);
        orderBySQL += " ORDER BY A.MEM_CODE ";




        $("#searchForm #V_WHERESQL").val(whereSQL);
        $("#searchForm #V_MEMCODE").val(memCode);
        $("#searchForm #V_MEMNAME").val(memName);
        $("#searchForm #V_MEMSTUS").val(memStusName);
        $("#searchForm #V_JOINEDDATEFROM").val(joinedDateFrom);
        $("#searchForm #V_JOINEDDATETO").val(joinedDateTo);
        $("#searchForm #V_ORDERBYSQL").val(orderBySQL);
        $("#searchForm #V_SELECTSQL").val("");
        $("#searchForm #V_FULLSQL").val("");

        // 프로시져로 구성된 경우 꼭 아래 option을 넘겨야 함.
        var option = {
                isProcedure : true // procedure 로 구성된 리포트 인경우 필수.  => /payment/PaymentListing_Excel.rpt 는 프로시져로 구성된 파일임.
        };

        Common.report("searchForm", option);

    }else{
        return false;
    }
}

function btnGenerateExcel_Click(){
    if(validRequiredField() == true){

        var memCode = "";
        var memName = "";
        var memStus = "";
        var memStusName = "";
        var joinedDateFrom = "";
        var joinedDateTo = "";
        var whereSQL = "";
        var orderBySQL = "";

        $("#reportFileName").val("");
        $("#reportDownFileName").val("");
        $("#viewType").val("");

        if(!($("#memCode").val() == null || $("#memCode").val().length == 0)){

            whereSQL += " AND A.SPONS_CODE = '"+$("#memCode").val()+"'";
            memCode = $("#memCode").val();

        }

        if(!($("#hiddenName").val() == null || $("#hiddenName").val().length == 0)){
            memName = $("#hiddenName").val();

        }

        if(!($("#dpJoinedDateFrom").val() == null || $("#dpJoinedDateFrom").val().length == 0)){
            whereSQL += " AND TO_DATE(A.CRT_DT) >= TO_DATE('"+$("#dpJoinedDateFrom").val()+"', 'dd/MM/YYYY')";
            joinedDateFrom = $("#dpJoinedDateFrom").val();

        }

        if(!($("#dpJoinedDateTo").val() == null || $("#dpJoinedDateTo").val().length == 0)){
            whereSQL += " AND TO_DATE(A.CRT_DT) <= TO_DATE('"+$("#dpJoinedDateTo").val()+"', 'dd/MM/YYYY')";
            joinedDateTo = $("#dpJoinedDateTo").val();

        }


            if($('#status :selected').length > 0){
                whereSQL += " AND ";
            var cnt = 0;
            $('#status :selected').each(function(j, mul){
                if(cnt == 0){
                    memStus += $(mul).val();
                    memStusName += $(mul).text();
                }else{
                    memStus += ", "+$(mul).val();
                    memStusName += ", "+$(mul).text();
                }
                cnt += 1;

            });
            whereSQL += " A.STUS IN ("+memStus+") ";
        }





        var date = new Date().getDate();
        if(date.toString().length == 1){
            date = "0" + date;
        }

        $("#searchForm #viewType").val("EXCEL");
        $("#searchForm #reportFileName").val("/organization/SponsorListing_Excel.rpt");
        $("#reportDownFileName").val("SponsorListing"+date+(new Date().getMonth()+1)+new Date().getFullYear()+"_"+memCode);
        orderBySQL += " ORDER BY A.MEM_CODE ";




        $("#searchForm #V_WHERESQL").val(whereSQL);
        $("#searchForm #V_MEMCODE").val(memCode);
        $("#searchForm #V_MEMNAME").val(memName);
        $("#searchForm #V_MEMSTUS").val(memStusName);
        $("#searchForm #V_JOINEDDATEFROM").val(joinedDateFrom);
        $("#searchForm #V_JOINEDDATETO").val(joinedDateTo);
        $("#searchForm #V_ORDERBYSQL").val(orderBySQL);
        $("#searchForm #V_SELECTSQL").val("");
        $("#searchForm #V_FULLSQL").val("");

        // 프로시져로 구성된 경우 꼭 아래 option을 넘겨야 함.
        var option = {
                isProcedure : true // procedure 로 구성된 리포트 인경우 필수.  => /payment/PaymentListing_Excel.rpt 는 프로시져로 구성된 파일임.
        };

        Common.report("searchForm", option);

    }else{
        return false;
    }
}


</script>

<div id="popup_wrap" class="popup_wrap size_small"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Sponsor Listing</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#"><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<aside class="title_line"><!-- title_line start -->

</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->

<form id="searchForm" name="searchForm" action="#" method="post">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:100px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Member Code</th>
    <td><input type="text" title="memCode" id="memCode" name="memCode"  placeholder="Member Code" class="w100p" onChange="javascript : fn_onChgMemCode()"/>
    <input id="hiddenName" name="hiddenName"  type="hidden"  title="" placeholder="Name" class="" /></td>


</tr>
<tr>
    <th scope="row">Member Status</th>
    <td>
        <select class="multy_select w100p" multiple="multiple" id="status"  name="status" data-placeholder="Status">
             <option value="1" selected>Active</option>
             <option value="51" selected>Resigned</option>
        </select>

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
    <li><p class="btn_blue2"><a href="#" onclick="javascript: btnGeneratePDF_Click()">Generate PDF</a></p></li>
    <li><p class="btn_blue2"><a href="#" onclick="javascript: btnGenerateExcel_Click()">Generate EXCEL</a></p></li>
    <li><p class="btn_blue2"><a href="#" onclick="javascript:$('#searchForm').clearForm();"><spring:message code="sal.btn.clear" /></a></p></li>
</ul>

<input type="hidden" id="reportFileName" name="reportFileName" value="" />
<input type="hidden" id="viewType" name="viewType" value="" />
<input type="hidden" id="reportDownFileName" name="reportDownFileName" value="" />

<input type="hidden" id="V_WHERESQL" name="V_WHERESQL" value="" />
<input type="hidden" id="V_MEMCODE" name="V_MEMCODE" value="" />
<input type="hidden" id="V_MEMNAME" name="V_MEMNAME" value="" />
<input type="hidden" id="V_MEMSTUS" name="V_MEMSTUS" value="" />
<input type="hidden" id="V_JOINEDDATEFROM" name="V_JOINEDDATEFROM" value="" />
<input type="hidden" id="V_JOINEDDATETO" name="V_JOINEDDATETO" value="" />
<input type="hidden" id="V_ORDERBYSQL" name="V_ORDERBYSQL" value="" />
<input type="hidden" id="V_SELECTSQL" name="V_SELECTSQL" value="" />
<input type="hidden" id="V_FULLSQL" name="V_FULLSQL" value="" />


</form>

</section><!-- content end -->

</section><!-- container end -->

</div><!-- popup_wrap end -->