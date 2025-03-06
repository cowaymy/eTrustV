<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">

var MEM_TYPE = '${SESSION_INFO.userTypeId}';
var roleId = '${SESSION_INFO.roleId}';
var brnch = '${SESSION_INFO.userBranchId}';

var branchDs = [];
var param;
var selectedBranch = [];
<c:forEach var="obj" items="${branchList}">
    branchDs.push({codeId:"${obj.codeId}", codeName:"${obj.codeName}"});
</c:forEach>


$("#dataForm").empty();

$('.multy_select').change(function() {
})
.multipleSelect({
   width: '100%'
});

$(document).ready(
		function() {
		      doDefCombo(branchDs, '', 'sLocation', 'M', 'f_multiCombo');
	});

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
    });
};

function f_multiCombo() {
    $(function() {
        $('#sLocation').change(function() {
            //console.log($(this).val());
        }).multipleSelect({
            selectAll: true, // 전체선택
            width: '100%'
        });
        $('#sLocation').multipleSelect("checkAll");
    });
}

function validRequiredField(){

    var valid = true;
    var message = "";

    if(
            ( !(brnch == "42" || roleId == '180' || roleId == '179' || roleId == '264') && $("#sLocation :selected").val() == '' || $("#sLocation :selected").val() == null || $("#sLocation :selected").length == 0 )
            || ($("#sHolder :selected").val() == '' || $("#sHolder :selected").val() == null || $("#sHolder :selected").length == 0 )
            || ($("#sStatus :selected").val() == '' || $("#sStatus :selected").val() == null || $("#sStatus :selected").length == 0 )
            || ($("#sCondition :selected").val() == '' || $("#sCondition :selected").val() == null || $("#sCondition :selected").length == 0)
            || ($("#fcrtsdt").val() == '' || $("#fcrtsdt").val() == null)
            ){

        valid = false;
        message += 'Please select each of the selection';
    }

    if(valid == false){
        Common.alert('<spring:message code="sal.alert.title.reportGenSummary" />' + DEFAULT_DELIMITER + message);
    }

    return valid;
}

function fn_dateChange(obj) {

	var selectedMth = Number($("#fcrtsdt").val().substring(0,2));
	var selectedYear = Number($("#fcrtsdt").val().substring(3,7));

	var curr = new Date();
	var currMth = curr.getMonth() + 1;
	var currYear = curr.getFullYear();

	if(selectedYear < currYear || (selectedYear == currYear && selectedMth < currMth)){
		Common.alert('Please choose current month and onwards');
		$("#fcrtsdt").val("");
	}
	else if((selectedYear == currYear && selectedMth - currMth > 4) || (selectedYear > currYear && selectedMth > 3)) {
		Common.alert('Please choose within 4 months from current date');
	      $("#fcrtsdt").val("");
	}
	else {
		console.log($("#fcrtsdt").val());
	}

}


function fn_genReport() {
	console.log($("#form").serializeJSON());
	console.log($("#fcrtsdt").val());

	var whereSQL = "";
    var whereSQL2 = "";
    var whereSQL3 = "";
    var period = "";
    var safetyLevel = $("#safetyLvl").val();
    var reportType = $("#sExportType").val();

    $("#reportFileName").val("");
    $("#reportDownFileName").val("");
    $("#viewType").val("");

    if(validRequiredField() == true){

    if($("#fcrtsdt").val() != null){
    	period += "'" + $("#fcrtsdt").val() + "'";
    }

    if($('#sCondition :selected').length > 0){
        whereSQL += " AND aa.condition in (";
        whereSQL2 += " AND ab.condition in (";
        var runNo = 0;

        $('#sCondition :selected').each(function(i, mul){
            if(runNo == 0){
                whereSQL += "'" + $(mul).val() + "'";
                whereSQL2 += "'" + $(mul).val() + "'";

            }else{
                whereSQL += "," + "'" + $(mul).val() + "'";
                whereSQL2 += "," + "'" + $(mul).val() + "'";

            }

            runNo += 1;
        });
        whereSQL += ") ";
        whereSQL2 += ") ";

    }

    if($('#sModel :selected').length > 0){
        whereSQL += " AND aa.model in (";
        whereSQL2 += " AND ab.model in (";
        var runNo = 0;

        $('#sModel :selected').each(function(i, mul){
            if(runNo == 0){
                whereSQL += "'" + $(mul).val() + "'";
                whereSQL2 += "'" + $(mul).val() + "'";
            }else{
                whereSQL += "," + "'" + $(mul).val() + "'";
                whereSQL2 += "," + "'" + $(mul).val() + "'";
            }

            runNo += 1;
        });
        whereSQL += ") ";
        whereSQL2 += ") ";
    }


    if($('#sLocation :selected').val() > 0){
        whereSQL3 += " WHERE M1.brnch_id in (";
        var runNo = 0;

        $('#sLocation :selected').each(function(i, mul){
            if(runNo == 0){
            	whereSQL3 += $(mul).val();
            }else{
            	whereSQL3 += "," + $(mul).val();
            }

            runNo += 1;
        });
        whereSQL3 += ") ";
    }

    if($('#sHolder :selected').length < 2){
        if($('#sHolder').val() == '278'){
            whereSQL3 += " AND M1.HOLDER_TYPE = 'MEMBER' ";
        }else if($('#sHolder').val() == '277'){
            whereSQL3 += " AND M1.HOLDER_TYPE = 'BRANCH' ";
        }
    }
    console.log("whereSQL" + whereSQL);
    console.log("whereSQL2" + whereSQL2);
    console.log("whereSQL3" + whereSQL3);

    var date = new Date().getDate();
    if(date.toString().length == 1){
        date = "0" + date;
    }

    $("#reportDownFileName").val("HiCareFilterForecastListing"+date+(new Date().getMonth()+1)+new Date().getFullYear());
    $("#form #reportFileName").val("/logistics/HiCare_filterForecast_Excel.rpt");

    $("#form #viewType").val(reportType);
    $("#form #V_PERIOD").val(period);
    $("#form #V_SAFETYLVL").val(safetyLevel);
    $("#form #V_WHERESQL").val(whereSQL);
    $("#form #V_WHERESQL2").val(whereSQL2);
    $("#form #V_WHERESQL3").val(whereSQL3);

    console.log(period);

    var option = {
            isProcedure : true
    };

    Common.report("form", option);

    }
    else{
    	return false;
    }
}

</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Hi-Care Filter Forecast List</h1>
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
   <th scope="row">Change Period<span class="must">*</span></th>
   <td>
      <div class="date_set w100p">
       <!-- date_set start -->
       <p>
        <input id="fcrtsdt" name="namecrtsdt" type="text"
         title="Create start Date" placeholder="MM/YYYY" onchange="fn_dateChange(this)"
         class="j_date2 mtz-monthpicker-widgetcontainer" />
       </p>
      </div>
  <!-- date_set end -->
  </td>
</tr>
<tr>
    <th scope="row">Export Type<span class="must">*</span></th>
    <td>
    <select class="w100p" id="sExportType" name="sExportType">
        <option value="EXCEL">Excel</option>
    </select>
    </td>
</tr>
<tr>
    <th scope="row">Safety Level<span class="must">*</span></th>
    <td>
    <select class="w100p" id="safetyLvl" name="safetyLvl">
        <option value="0">0%</option>
        <option value="20">20%</option>
        <option value="30">30%</option>
        <option value="40">40%</option>
        <option value="50">50%</option>
        <option value="60">60%</option>
        <option value="70">70%</option>
        <option value="80">80%</option>
    </select>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code='service.grid.BranchCode'/><span class="must">*</span></th>
             <td>
                <select id="sLocation" name="sLocation" class="multy_select w100p" multiple="multiple"></select>

            </td>
</tr>
<tr>
    <th scope="row"><spring:message code='service.grid.holderType'/><span class="must">*</span></th>
    <td>
        <select class="multy_select w100p" multiple="multiple" id="sHolder" name="sHolder">
            <option value="277" selected="selected">Branch</option>
            <option value="278" selected="selected">Member</option>
        </select>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code='service.grid.Status'/><span class="must">*</span></th>
    <td>
    <select class="w100p" id="sStatus" name="sStatus">
        <option value="1">Active</option>
    </select>
<%--     </td>
        <select class="multy_select w100p" multiple="multiple" id="sStatus" name="sStatus">
            <option value="1" selected><spring:message code="sal.combo.text.active" /></option>
            <option value="36" selected><spring:message code="sal.combo.text.closed" /></option>
        </select> --%>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code='service.grid.condition'/><span class="must">*</span></th>
    <td>
        <select class="multy_select w100p" multiple="multiple" id="sCondition" name="sCondition">
            <option value="33" selected="selected"><spring:message code="sal.combo.text.new" /></option>
            <option value="111" selected="selected"><spring:message code="sal.combo.text.used" /></option>
            <option value="112" selected="selected"><spring:message code="sal.combo.text.defect" /></option>
            <option value="122" selected="selected"><spring:message code="sal.combo.text.repair" /></option>
            <option value="7" selected="selected">Obsolete</option>
        </select>
    </td>
</tr>
<tr>
    <th scope="row">Model<span class="must">*</span></th>
    <td>
        <select class="multy_select w100p" multiple="multiple" id="sModel" name="sModel">
             <c:forEach var="list" items="${modelList}" varStatus="status">
               <option value="${list.codeId}" selected>${list.codeDesc}</option>
             </c:forEach>
         </select>
    </td>
</tr>
</tbody>
</table><!-- table end -->

<ul class="center_btns">
    <li><p class="btn_blue2"><a href="#" onclick="javascript: fn_genReport()">Generate</a></p></li>
</ul>
<input type="hidden" id="reportFileName" name="reportFileName" value="" />
<input type="hidden" id="viewType" name="viewType" value="" />
<input type="hidden" id="reportDownFileName" name="reportDownFileName" value="" />
<input type="hidden" id="V_PERIOD" name="V_PERIOD" value="" />
<input type="hidden" id="V_SAFETYLVL" name="V_SAFETYLVL" value="" />
<input type="hidden" id="V_WHERESQL" name="V_WHERESQL" value="" />
<input type="hidden" id="V_WHERESQL2" name="V_WHERESQL2" value="" />
<input type="hidden" id="V_WHERESQL3" name="V_WHERESQL3" value="" />

</form>

</section><!-- content end -->

</section><!-- container end -->

<section class="search_result"><!-- search_result start -->
</section>

</div><!-- popup_wrap end -->