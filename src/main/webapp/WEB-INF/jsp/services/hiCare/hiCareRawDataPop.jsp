<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">

var instDtMM = new Date().getMonth()+1;
var MEM_TYPE = '${SESSION_INFO.userTypeId}';
var brnch = '${SESSION_INFO.userBranchId}';
var roleId = '${SESSION_INFO.roleId}';

var userName = '${SESSION_INFO.userName}';
instDtMM = FormUtil.lpad(instDtMM, 2, "0");
$("#dataForm").empty();

/* 멀티셀렉트 플러그인 start */
$('.multy_select').change(function() {
   //console.log($(this).val());
})
.multipleSelect({
   width: '100%'
});

$(document).ready(
        function() {
            if(brnch == "42" || roleId == '180' || roleId == '179' || roleId == '250'){
                doGetCombo('/services/hiCare/getBch.do', '', brnch, 'sBranchCode', 'S', '');
                $("#sBranchCode option[value='"+ brnch +"']").attr("selected", true);
            }else{
                doGetCombo('/services/hiCare/getBch.do', brnch, brnch, 'sBranchCode', 'S', '');
            }
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

        $("#dpInstallDateFrom").val(instDtMM+"/"+new Date().getFullYear());
        $("#dpInstallDateTo").val(instDtMM+"/"+new Date().getFullYear());

        $("#sOrgCode").empty();
        $("#sGrpCode").empty();
        $("#sDeptCode").empty();
        $("#sOrgCode").append("<option value='0' selected>All</option>");
        $("#sGrpCode").append("<option value='0' selected>All</option>");
        $("#sDeptCode").append("<option value='0' selected>All</option>");

        $("#sGrpCode").addClass("disabled");
        $("#sDeptCode").addClass("disabled");
    });
};

function validRequiredField(){

    var valid = true;
    var message = "";

    if(
            ( !(brnch == "42" || roleId == '180' || roleId == '179' || roleId == '250') && $("#sBranchCode :selected").val() == '' || $("#sBranchCode :selected").val() == null || $("#sBranchCode :selected").length == 0 )
            || ($("#sHolder :selected").val() == '' || $("#sHolder :selected").val() == null || $("#sHolder :selected").length == 0 )
            || ($("#sStatus :selected").val() == '' || $("#sStatus :selected").val() == null || $("#sStatus :selected").length == 0 )
            || ($("#sCondition :selected").val() == '' || $("#sCondition :selected").val() == null || $("#sCondition :selected").length == 0)
            ){

        valid = false;
        message += 'Please select each of the selection';
    }

    if(valid == false){
        Common.alert('<spring:message code="sal.alert.title.reportGenSummary" />' + DEFAULT_DELIMITER + message);
    }

    return valid;
}

function btnGenerate_Click(){
    if(validRequiredField() == true){
        var whereSQL = "";
        var holderType = "";
        var condition = "";

        $("#reportFileName").val("");
        $("#reportDownFileName").val("");
        $("#viewType").val("");

        if($("#rcrtsdt").val() != '' && $("#rcrtsdt").val() != null && $("#rcrtedt").val() != '' && $("#rcrtedt").val() != null){
        	whereSQL += " and D.UPD_DT between TO_DATE( '" + $("#rcrtsdt").val() + "','DD/MM/YYYY') and TO_DATE( '" + $("#rcrtedt").val() + "','DD/MM/YYYY') ";
        }

        if($('#sBranchCode :selected').val() > 0){
            whereSQL += "AND A.branch_id in (";
            var runNo = 0;

            $('#sBranchCode :selected').each(function(i, mul){
                if(runNo == 0){
                    whereSQL += $(mul).val();
                }else{
                    whereSQL += "," + $(mul).val();
                }

                runNo += 1;
            });
            whereSQL += ") ";
        }

        if($('#sHolder :selected').length == 2){
            holderType += 'Branch, Member';
        }
        if($('#sHolder :selected').length == 1){
            if($('#sHolder').val() == '278'){
                whereSQL += " AND H.wh_loc_type_id in (278) ";
                holderType += 'Member';
            }else if($('#sHolder').val() == '277'){
                whereSQL += " AND A.loc_id is null and A.branch_id is not null ";
                holderType += 'Branch';
            }
        }

        if($('#sStatus :selected').length > 0){
            whereSQL += " AND A.status in (";

            var runNo = 0;

            $('#sStatus :selected').each(function(i, mul){
                if(runNo == 0){
                    whereSQL += "'" + $(mul).val() + "'";
                }else{
                    whereSQL += "," + "'" + $(mul).val() + "'";
                }

                runNo += 1;
            });
            whereSQL += ") ";
        }

        if($('#sCondition :selected').length > 0){
            whereSQL += " AND A.condition in (";
            var runNo = 0;

            if (document.querySelector("#test>.ms-parent>button>span").innerText == "All selected" ){
                condition = "New, Used, Defect, Repair";
            }else{
                condition = document.querySelector("#test>.ms-parent>button>span").innerText;
            }

            $('#sCondition :selected').each(function(i, mul){
                if(runNo == 0){
                    whereSQL += "'" + $(mul).val() + "'";
                }else{
                    whereSQL += "," + "'" + $(mul).val() + "'";
                }

                runNo += 1;
            });
            whereSQL += ") ";
        }


        if($('#sModel :selected').length > 0){
            whereSQL += " AND A.model in (";
            var runNo = 0;

            $('#sModel :selected').each(function(i, mul){
                if(runNo == 0){
                    whereSQL += "'" + $(mul).val() + "'";
                }else{
                    whereSQL += "," + "'" + $(mul).val() + "'";
                }

                runNo += 1;
            });
            whereSQL += ") ";
        }
        console.log("whereSQL" + whereSQL);
        console.log("holderType" + holderType);
        console.log("condition: " + condition);

        var date = new Date().getDate();
        if(date.toString().length == 1){
            date = "0" + date;
        }

        $("#reportDownFileName").val("HiCareRawData"+date+(new Date().getMonth()+1)+new Date().getFullYear());
        $("#form #reportFileName").val("/logistics/HiCare_rawData_Excel.rpt");
        $("#form #viewType").val("EXCEL");

        $("#form #V_WHERESQL").val(whereSQL);
        $("#form #holderType").val(holderType);

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
	<h1>Hi-Care Raw Data</h1>
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
			   <th scope="row">Transaction Date</th>
			   <td>
			      <div class="date_set w100p">
			       <!-- date_set start -->
			       <p>
			        <input id="rcrtsdt" name="namecrtsdt" type="text"
			         title="Create start Date" placeholder="DD/MM/YYYY"
			         class="j_date" />
			       </p>
			       <span> To </span>
			       <p>
			        <input id="rcrtedt" name="namecrtedt" type="text"
			         title="Create End Date" placeholder="DD/MM/YYYY"
			         class="j_date" />
			       </p>
			      </div>
			  <!-- date_set end -->
			  </td>
			</tr>
			<tr>
			    <th scope="row"><spring:message code='service.grid.BranchCode'/></th>
		             <td>
		                 <select id="sBranchCode" name="sBranchCode" class="w100p"></select>
		             </td>
			</tr>
			<tr>
			    <th scope="row"><spring:message code='service.grid.holderType'/></th>
			    <td>
			        <select class="multy_select w100p" multiple="multiple" id="sHolder" name="sHolder">
			            <option value="277" selected="selected">Branch</option>
			            <option value="278" selected="selected">Member</option>
			        </select>
			    </td>
			</tr>
			<tr>
			    <th scope="row"><spring:message code='service.grid.Status'/></th>
			    <td>
			        <select class="multy_select w100p" multiple="multiple" id="sStatus" name="sStatus">
			            <option value="1" selected><spring:message code="sal.combo.text.active" /></option>
			            <option value="36" selected><spring:message code="sal.combo.text.closed" /></option>
			        </select>
			    </td>
			</tr>
			<tr>
			    <th scope="row"><spring:message code='service.grid.condition'/></th>
			    <td td id="test">
			        <select class="multy_select w100p" multiple="multiple" id="sCondition" name="sCondition">
			            <option value="33" selected="selected"><spring:message code="sal.combo.text.new" /></option>
			            <option value="111" selected="selected"><spring:message code="sal.combo.text.used" /></option>
			            <option value="112" selected="selected"><spring:message code="sal.combo.text.defect" /></option>
			            <option value="122" selected="selected"><spring:message code="sal.combo.text.repair" /></option>
			        </select>
			    </td>
			</tr>
			<tr>
			    <th scope="row">Model</th>
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
			    <li><p class="btn_blue2"><a href="#" onclick="javascript: btnGenerate_Click()">Generate</a></p></li>
			</ul>

			<input type="hidden" id="reportFileName" name="reportFileName" value="" />
			<input type="hidden" id="viewType" name="viewType" value="" />
			<input type="hidden" id="reportDownFileName" name="reportDownFileName" value="" />

			<input type="hidden" id="V_WHERESQL" name="V_WHERESQL" value="" />
			<input type="hidden" id="holderType" name="holderType" value="" />
			<input type="hidden" id="userName" name="userName" value="${SESSION_INFO.userName}">

			</form>
		</section><!-- content end -->
	</section><!-- container end -->
</div><!-- popup_wrap end -->