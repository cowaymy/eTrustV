<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">

var instDtMM = new Date().getMonth()+1;
var MEM_TYPE = '${SESSION_INFO.userTypeId}';
var roleId = '${SESSION_INFO.roleId}';
var brnch = '${SESSION_INFO.userBranchId}';

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
            if(brnch == "42" || roleId == '180' || roleId == '179' || roleId == '250' ){
                doGetCombo('/services/hiCare/getBch.do', '', brnch, 'sBranchCode', 'S', '');
                $("#sBranchCode option[value='"+ brnch +"']").attr("selected", true);
            }else{
                doGetCombo('/services/hiCare/getBch.do', brnch, brnch, 'sBranchCode', 'S', '');
            }
        });

$.fn.clearForm = function() {
	//$("#sHolder").multipleSelect("checkAll");
	//$("#sStatus").multipleSelect("checkAll");

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
            ( !(brnch == "42" || roleId == '180' || roleId == '179' || roleId == '264') && $("#sBranchCode :selected").val() == '' || $("#sBranchCode :selected").val() == null || $("#sBranchCode :selected").length == 0 )
            || ($("#sHolder :selected").val() == '' || $("#sHolder :selected").val() == null || $("#sHolder :selected").length == 0 )
            || ($("#sStatus :selected").val() == '' || $("#sStatus :selected").val() == null || $("#sStatus :selected").length == 0 )
            || ($("#sCondition :selected").val() == '' || $("#sCondition :selected").val() == null || $("#sCondition :selected").length == 0)
            || ($("#fcrtsdt").val() == '' || $("#fcrtsdt").val() == null)
            || ($("#fcrtedt").val() == '' || $("#fcrtedt").val() == null)
            ){

        valid = false;
        message += 'Please select each of the selection';
    }

    var listingType = $("#sType").val();
    if(listingType == '2'){

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
        var reportType = $("#sExportType").val();
        var listingType = $("#sType").val();

        $("#reportFileName").val("");
        $("#reportDownFileName").val("");
        $("#viewType").val("");

        if($("#fcrtsdt").val() != '' && $("#fcrtsdt").val() != null && $("#fcrtedt").val() != '' && $("#fcrtedt").val() != null){
        	if(listingType == '1'){
        	//whereSQL += " and a.FILTER_NXT_CHG_DT between TO_DATE( '" + $("#fcrtsdt").val() + "','DD/MM/YYYY') and TO_DATE( '" + $("#fcrtedt").val() + "','DD/MM/YYYY') ";
        	whereSQL += " and a.FILTER_NXT_CHG_DT <= TO_DATE( '" + $("#fcrtedt").val() + "','DD/MM/YYYY') ";
        	}else if(listingType == '2'){
        		whereSQL += " and a.FILTER_CHG_DT between TO_DATE( '" + $("#fcrtsdt").val() + "','DD/MM/YYYY') and TO_DATE( '" + $("#fcrtedt").val() + "','DD/MM/YYYY') ";
            }
        }

        if($('#sBranchCode :selected').val() > 0){
            whereSQL += " and a.branch_id in (";
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
        if($('#sHolder :selected').length < 2){
        	if($('#sHolder').val() == '278'){
        		whereSQL += " AND b.wh_loc_type_id in (278) ";
        		holderType += 'Member';
        	}else if($('#sHolder').val() == '277'){
        		whereSQL += " AND a.loc_id is null and a.branch_id is not null ";
        		holderType += 'Branch';
        	}
        }

        if($('#sStatus :selected').length > 0){
            whereSQL += " AND a.status in (";
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
            whereSQL += " AND a.condition in (";
            var runNo = 0;

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
            whereSQL += " AND a.model in (";
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


        var date = new Date().getDate();
        if(date.toString().length == 1){
            date = "0" + date;
        }

        if(listingType == '1'){
        	$("#reportDownFileName").val("HiCareFilterExpiredListing"+date+(new Date().getMonth()+1)+new Date().getFullYear());
        	$("#form #reportFileName").val("/logistics/HiCare_filterExpired_Excel.rpt");
        }else if(listingType == '2'){
        	$("#reportDownFileName").val("HiCareFilterExchangeListing"+date+(new Date().getMonth()+1)+new Date().getFullYear());
        	$("#form #reportFileName").val("/logistics/HiCare_filterExchange_Excel.rpt");
        }
        $("#form #viewType").val(reportType);
        $("#form #V_WHERESQL").val(whereSQL);
        $("#form #holderType").val(holderType);

        console.log($("#V_WHERESQL").val());
        // 프로시져로 구성된 경우 꼭 아래 option을 넘겨야 함.
        var option = {
                isProcedure : true // procedure 로 구성된 리포트 인경우 필수.  => /payment/PaymentListing_Excel.rpt 는 프로시져로 구성된 파일임.
        };

        Common.report("form", option);

    }else{
        return false;
    }
}

function btnGeneratePDF_Click(){
	if(validRequiredField() == true){

		var memberType = "";
		var installDate = "";
		var orgCode = "";
		var grpCode = "";
		var deptCode = "";
		var userName = $("#userName").val();
		var whereSQL = "";

		$("#reportFileName").val("");
	    $("#reportDownFileName").val("");
	    $("#viewType").val("");

	     if($("#sMemberType :selected").val() > 0){
	    	if($("#sMemberType :selected").val() != 0){
	    		whereSQL += " AND mem.MEM_TYPE = '"+$("#sMemberType :selected").val()+"'";
	    		memberType = $("#sMemberType :selected").text();
	    	}else{
	    		memberType = "All";
	    	}
	    }

	    if(!($("#dpInstallDateFrom").val() == null || $("#dpInstallDateFrom").val().length == 0)){
	    	whereSQL += " AND tos.INSTALL_DT >= TO_DATE('01/"+$("#dpInstallDateFrom").val()+"', 'dd/MM/YY')";
	    	installDate = " FROM "+$("#dpInstallDateFrom").val();

	    }

	    if(!($("#dpInstallDateTo").val() == null || $("#dpInstallDateTo").val().length == 0)){
	    	var lastDate = new Date($("#dpInstallDateTo").val().substring(3,7), $("#dpInstallDateTo").val().substring(0,2), 0).getDate();
	    	whereSQL += " AND tos.INSTALL_DT <= TO_DATE('"+lastDate+"/"+$("#dpInstallDateTo").val()+"', 'dd/MM/YY')";
	    	installDate += " TO "+$("#dpInstallDateTo").val();

        }

	    if($('#sYSAging :selected').length > 0){
	    	whereSQL += " AND (";
	    	var runNo = 0;

	    	$('#sYSAging :selected').each(function(i, mul){
	    		if(runNo == 0){
                    if($(mul).val() == "30"){
                        whereSQL += " (SYSDATE - tos.INSTALL_DT) <= "+$(mul).val()+" ";
                    }else{
                        whereSQL += " (SYSDATE - tos.INSTALL_DT) >= "+$(mul).val()+" ";
                    }
                }else{
                    if($(mul).val() == "30"){
                        whereSQL += " OR (SYSDATE - tos.INSTALL_DT) <= "+$(mul).val()+" ";
                    }else{
                        whereSQL += " OR (SYSDATE - tos.INSTALL_DT) >= "+$(mul).val()+" ";
                    }
                }

	            runNo += 1;
	        });
	        whereSQL += ") ";
	    }

	    if($("#sOrgCode :selected").val() > 0){
	    	var memOrgCode = "";
	    	Common.ajax("GET", '/sales/order/getMemberOrgInfo.do', {sCode : $("#sOrgCode :selected").val()}, function(result){
	    		memOrgCode = result.orgCode;
	    	});
	    	whereSQL += " AND som.ORG_CODE = '"+memOrgCode+"'";
	    	orgCode = memOrgCode;

	    }else if($("#sOrgCode :selected").val() == 0){
	    	orgCode = "All";

	    }

	    if($("#sGrpCode :selected").val() > 0){
	    	var memGrpCode = "";
	    	Common.ajax("GET", '/sales/order/getMemberOrgInfo.do', {sCode : $("#sGrpCode :selected").val()}, function(result){
	    		memGrpCode = result.grpCode;
            });
	    	whereSQL += " AND som.GRP_CODE = '"+memGrpCode+"'";
	    	grpCode = memGrpCode;

	    }else if($("#sGrpCode :selected").val() == 0){
	    	grpCode = "All";

	    }

	    if($("#sDeptCode :selected").val() > 0){
	    	var memDeptCode = "";
	    	Common.ajax("GET", '/sales/order/getMemberOrgInfo.do', {sCode : $("#sDeptCode :selected").val()}, function(result){
	    		memDeptCode = result.grpCode;
            });
	    	whereSQL += " AND som.DEPT_CODE = '"+memDeptCode+"'";
	    	deptCode = memDeptCode;

	    }else if($("#sDeptCode :selected").val() == 0){
	    	deptCode = "All";
	    }

	    var custTypeList = "";
	    if($('#sCustType :selected').length > 0){
	    	var runNo1 = 0;
	    	$('#sCustType :selected').each(function(i, mul){
	    		  if($(mul).val() != "0"){
	    			  if(runNo1 > 0){
	    				  custTypeList += ", '"+$(mul).val()+"'";
	    			  }else{
	    				  custTypeList += "'"+$(mul).val()+"'";
	    			  }
	    			  runNo1 += 1;
	    		  }
	    	});
	    }

	    if(!(custTypeList == null || custTypeList.length == 0)){
	    	whereSQL += " AND cust.TYPE_ID IN ("+custTypeList+") ";
	    }

	    var date = new Date().getDate();
	    if(date.toString().length == 1){
	        date = "0" + date;
	    }
	    $("#reportDownFileName").val("SalesYSListing"+date+(new Date().getMonth()+1)+new Date().getFullYear());
	    $("#form #viewType").val("PDF");
	    $("#form #reportFileName").val("/sales/SalesYSListing_PDF.rpt");

	    $("#form #V_WHERESQL").val(whereSQL);
	    $("#form #V_USERNAME").val(userName);
	    $("#form #V_MEMBERTYPE").val(memberType);
	    $("#form #V_ORGCODE").val(orgCode);
	    $("#form #V_GRPCODE").val(grpCode);
	    $("#form #V_DEPTCODE").val(deptCode);
	    $("#form #V_DATE").val(installDate);

	    // 프로시져로 구성된 경우 꼭 아래 option을 넘겨야 함.
	    var option = {
	            isProcedure : true // procedure 로 구성된 리포트 인경우 필수.  => /payment/PaymentListing_Excel.rpt 는 프로시져로 구성된 파일임.
	    };

	    Common.report("form", option);

    }else{
        return false;
    }
}

function btnGenerateExcel_Click(){

    if(validRequiredField() == true){

        var memberType = "";
        var installDate = "";
        var orgCode = "";
        var grpCode = "";
        var deptCode = "";
        var userName = $("#userName").val();
        var whereSQL = "";

        $("#reportFileName").val("");
        $("#reportDownFileName").val("");
        $("#viewType").val("");

        if($("#sMemberType :selected").val() > 0){
            whereSQL += " AND mem.MEM_TYPE = '"+$("#sMemberType :selected").val()+"'";
            memberType = $("#sMemberType :selected").text();
        }
        console.log("memberType"+ memberType);
        if(!($("#dpInstallDateFrom").val() == null || $("#dpInstallDateFrom").val().length == 0)){
            whereSQL += " AND tos.INSTALL_DT >= TO_DATE('01/"+$("#dpInstallDateFrom").val()+"', 'dd/MM/YY')";
            installDate = " FROM "+$("#dpInstallDateFrom").val();

        }

        if(!($("#dpInstallDateTo").val() == null || $("#dpInstallDateTo").val().length == 0)){
            var lastDate = new Date($("#dpInstallDateTo").val().substring(3,7), $("#dpInstallDateTo").val().substring(0,2), 0).getDate();
            whereSQL += " AND tos.INSTALL_DT <= TO_DATE('"+lastDate+"/"+$("#dpInstallDateTo").val()+"', 'dd/MM/YY')";
            installDate += " TO "+$("#dpInstallDateTo").val();

        }

        if($('#sYSAging :selected').length > 0){
            whereSQL += " AND (";
            var runNo = 0;

            $('#sYSAging :selected').each(function(i, mul){
                if(runNo == 0){
                    if($(mul).val() == "30"){
                        whereSQL += " (SYSDATE - tos.INSTALL_DT) <= "+$(mul).val()+" ";
                    }else{
                        whereSQL += " (SYSDATE - tos.INSTALL_DT) >= "+$(mul).val()+" ";
                    }
                }else{
                    if($(mul).val() == "30"){
                        whereSQL += " OR (SYSDATE - tos.INSTALL_DT) <= "+$(mul).val()+" ";
                    }else{
                        whereSQL += " OR (SYSDATE - tos.INSTALL_DT) >= "+$(mul).val()+" ";
                    }
                }

                runNo += 1;
            });
            whereSQL += ") ";
        }

        if($("#sOrgCode :selected").val() > 0){
            var memOrgCode = "";
            Common.ajax("GET", '/sales/order/getMemberOrgInfo.do', {sCode : $("#sOrgCode :selected").val()}, function(result){
                memOrgCode = result.orgCode;
            });
            whereSQL += " AND som.ORG_CODE = '"+memOrgCode+"'";
            orgCode = memOrgCode;

        }

        if($("#sGrpCode :selected").val() > 0){
            var memGrpCode = "";
            Common.ajax("GET", '/sales/order/getMemberOrgInfo.do', {sCode : $("#sGrpCode :selected").val()}, function(result){
                memGrpCode = result.grpCode;
            });
            whereSQL += " AND som.GRP_CODE = '"+memGrpCode+"'";
            grpCode = memGrpCode;

        }

        if($("#sDeptCode :selected").val() > 0){
            var memDeptCode = "";
            Common.ajax("GET", '/sales/order/getMemberOrgInfo.do', {sCode : $("#sDeptCode :selected").val()}, function(result){
                memDeptCode = result.grpCode;
            });
            whereSQL += " AND som.DEPT_CODE = '"+memDeptCode+"'";
            deptCode = memDeptCode;

        }

        var custTypeList = "";
        if($('#sCustType :selected').length > 0){
            var runNo1 = 0;
            $('#sCustType :selected').each(function(i, mul){
                  if($(mul).val() != "0"){
                      if(runNo1 > 0){
                          custTypeList += ", '"+$(mul).val()+"'";
                      }else{
                          custTypeList += "'"+$(mul).val()+"'";
                      }
                      runNo1 += 1;
                  }
            });
        }

        if(!(custTypeList == null || custTypeList.length == 0)){
            whereSQL += " AND cust.TYPE_ID IN ("+custTypeList+") ";
        }

        var date = new Date().getDate();
        if(date.toString().length == 1){
            date = "0" + date;
        }
        $("#form #reportDownFileName").val("SalesYSListing"+date+(new Date().getMonth()+1)+new Date().getFullYear());
        $("#form #viewType").val("EXCEL");
        //$("#form #reportFileName").val("/sales/SalesYSListing_Excel.rpt");

        $("#form #V_WHERESQL").val(whereSQL);
        $("#form #V_USERNAME").val(userName);
        $("#form #V_MEMBERTYPE").val(memberType);
        $("#form #V_ORGCODE").val(orgCode);
        $("#form #V_GRPCODE").val(grpCode);
        $("#form #V_DEPTCODE").val(deptCode);
        $("#form #V_DATE").val(installDate);

        // 프로시져로 구성된 경우 꼭 아래 option을 넘겨야 함.
        var option = {
                isProcedure : true // procedure 로 구성된 리포트 인경우 필수.  => /payment/PaymentListing_Excel.rpt 는 프로시져로 구성된 파일임.
        };

        Common.report("form", option);

	}else{
	    return false;
	}
}



/* $("#dpInstallDateFrom").val(instDtMM+"/"+new Date().getFullYear());
$("#dpInstallDateTo").val(instDtMM+"/"+new Date().getFullYear());
CommonCombo.make('sOrgCode', '/sales/order/getOrgCodeList', {memLvl : 1, memType : $("#sMemberType :selected").val()} , '');
 */
</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Hi-Care Filter Listing</h1>
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
    <select class="w100p" id="sType" name="sType">
        <option value="1">Expired List</option>
        <option value="2">Exchange List</option>
    </select>
</tr>
<tr>
   <th scope="row">Change Date</th>
   <td>
      <div class="date_set w100p">
       <!-- date_set start -->
       <p>
        <input id="fcrtsdt" name="namecrtsdt" type="text"
         title="Create start Date" placeholder="DD/MM/YYYY"
         class="j_date" />
       </p>
       <span> To </span>
       <p>
        <input id="fcrtedt" name="namecrtedt" type="text"
         title="Create End Date" placeholder="DD/MM/YYYY"
         class="j_date" />
       </p>
      </div>
  <!-- date_set end -->
  </td>
</tr>
<tr>
    <th scope="row">Export Type</th>
    <td>
    <select class="w100p" id="sExportType" name="sExportType">
        <option value="PDF">PDF</option>
        <option value="EXCEL">Excel</option>
    </select>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code='service.grid.BranchCode'/></th>
             <td>
                <%-- <select class="multy_select w100p" multiple="multiple" id="sBranchCode" name="sBranchCode">
                         <c:forEach var="list" items="${branchList}" varStatus="status">
                             <option value="${list.codeId}" selected="selected">${list.codeName}</option>
                         </c:forEach> --%>
                 <%-- <select id="sBranchCode" name="sBranchCode" class="w100p readOnly ">
                     <option value="">Choose One</option>
                         <c:forEach var="list" items="${branchList}" varStatus="status">
                             <option value="${list.codeId}">${list.codeName}</option>
                         </c:forEach>
                 </select> --%>
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