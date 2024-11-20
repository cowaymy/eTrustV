<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">

var instDtMM = new Date().getMonth()+1;

instDtMM = FormUtil.lpad(instDtMM, 2, "0");

$("#dataForm").empty();

/* 멀티셀렉트 플러그인 start */
$('.multy_select').change(function() {
   //console.log($(this).val());
})
.multipleSelect({
   width: '100%'
});

$.fn.clearForm = function() {
	$("#cmbYSAging").multipleSelect("checkAll");
	$("#cmbCustType").multipleSelect("checkAll");

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

        $("#cmbOrgCode").empty();
        $("#cmbGrpCode").empty();
        $("#cmbDeptCode").empty();
        $("#cmbOrgCode").append("<option value='0' selected>All</option>");
        $("#cmbGrpCode").append("<option value='0' selected>All</option>");
        $("#cmbDeptCode").append("<option value='0' selected>All</option>");

        $("#cmbGrpCode").addClass("disabled");
        $("#cmbDeptCode").addClass("disabled");
    });
};

function validRequiredField(){

	var valid = true;
	var message = "";

	if(($("#dpInstallDateFrom").val() == null || $("#dpInstallDateFrom").val().length == 0) || ($("#dpInstallDateTo").val() == null || $("#dpInstallDateTo").val().length == 0)){

		valid = false;
		message += '<spring:message code="sal.alert.msg.selInstallDateFromTo" />';
	}

	if(valid == false){
		Common.alert('<spring:message code="sal.alert.title.reportGenSummary" />' + DEFAULT_DELIMITER + message);

    }

    return valid;
}

function cmbMemberType_SelectedIndexChanged(){

	$("#cmbGrpCode").append("<option value='0' selected>All</option>");
	$("#cmbDeptCode").append("<option value='0' selected>All</option>");

	$("#cmbGrpCode").prop("disabled", true);
	$("#cmbGrpCode").addClass("disabled");
	$("#cmbDeptCode").prop("disabled", true);
	$("#cmbDeptCode").addClass("disabled");

	CommonCombo.make('cmbOrgCode', '/sales/order/getOrgCodeList', {memLvl : 1, memType : $("#cmbMemberType :selected").val()} , '');

	$("#cmbOrgCode").prop("disabled", false);
	$("#cmbOrgCode").removeClass("disabled");
}

function cmbOrgCode_SelectedIndexChanged(){

	CommonCombo.make('cmbGrpCode', '/sales/order/getGrpCodeList', {memLvl : 2, memType : $("#cmbMemberType").val(), upperLineMemberID : $("#cmbOrgCode").val()}, '');

	$("#cmbDeptCode").prop("disabled", false);
	$("#cmbDeptCode").removeClass("disabled");
    $("#cmbGrpCode").prop("disabled", false);
    $("#cmbGrpCode").removeClass("disabled");
    $("#cmbDeptCode").prop("disabled", true);
    $("#cmbDeptCode").addClass("disabled");
}

function cmbGrpCode_SelectedIndexChanged(){

	CommonCombo.make('cmbDeptCode', '/sales/order/getGrpCodeList', {memLvl : 3, memType : $("#cmbMemberType").val(), upperLineMemberID : $("#cmbGrpCode").val()}, '');

	$("#cmbDeptCode").prop("disabled", false);
	$("#cmbDeptCode").removeClass("disabled");
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

	     if($("#cmbMemberType :selected").val() > 0){
	    	if($("#cmbMemberType :selected").val() != 0){
	    		whereSQL += " AND mem.MEM_TYPE = '"+$("#cmbMemberType :selected").val()+"'";
	    		memberType = $("#cmbMemberType :selected").text();
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

	    if($('#cmbYSAging :selected').length > 0){
	    	whereSQL += " AND (";
	    	var runNo = 0;

	    	$('#cmbYSAging :selected').each(function(i, mul){
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

	    if($("#cmbOrgCode :selected").val() > 0){
	    	var memOrgCode = "";
	    	Common.ajax("GET", '/sales/order/getMemberOrgInfo.do', {cmbCode : $("#cmbOrgCode :selected").val()}, function(result){
	    		memOrgCode = result.orgCode;
	    	});
	    	whereSQL += " AND som.ORG_CODE = '"+memOrgCode+"'";
	    	orgCode = memOrgCode;

	    }else if($("#cmbOrgCode :selected").val() == 0){
	    	orgCode = "All";

	    }

	    if($("#cmbGrpCode :selected").val() > 0){
	    	var memGrpCode = "";
	    	Common.ajax("GET", '/sales/order/getMemberOrgInfo.do', {cmbCode : $("#cmbGrpCode :selected").val()}, function(result){
	    		memGrpCode = result.grpCode;
            });
	    	whereSQL += " AND som.GRP_CODE = '"+memGrpCode+"'";
	    	grpCode = memGrpCode;

	    }else if($("#cmbGrpCode :selected").val() == 0){
	    	grpCode = "All";

	    }

	    if($("#cmbDeptCode :selected").val() > 0){
	    	var memDeptCode = "";
	    	Common.ajax("GET", '/sales/order/getMemberOrgInfo.do', {cmbCode : $("#cmbDeptCode :selected").val()}, function(result){
	    		memDeptCode = result.grpCode;
            });
	    	whereSQL += " AND som.DEPT_CODE = '"+memDeptCode+"'";
	    	deptCode = memDeptCode;

	    }else if($("#cmbDeptCode :selected").val() == 0){
	    	deptCode = "All";
	    }
	     
	    if("${SESSION_INFO.roleId}" == 256) {
            whereSQL += " AND som.BRNCH_ID = "+"${SESSION_INFO.userBranchId}"+"";
        }

	    var custTypeList = "";
	    if($('#cmbCustType :selected').length > 0){
	    	var runNo1 = 0;
	    	$('#cmbCustType :selected').each(function(i, mul){
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

        if($("#cmbMemberType :selected").val() > 0){
            whereSQL += " AND mem.MEM_TYPE = '"+$("#cmbMemberType :selected").val()+"'";
            memberType = $("#cmbMemberType :selected").text();
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

        if($('#cmbYSAging :selected').length > 0){
            whereSQL += " AND (";
            var runNo = 0;

            $('#cmbYSAging :selected').each(function(i, mul){
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

        if($("#cmbOrgCode :selected").val() > 0){
            var memOrgCode = "";
            Common.ajax("GET", '/sales/order/getMemberOrgInfo.do', {cmbCode : $("#cmbOrgCode :selected").val()}, function(result){
                memOrgCode = result.orgCode;
            });
            whereSQL += " AND som.ORG_CODE = '"+memOrgCode+"'";
            orgCode = memOrgCode;

        }

        if($("#cmbGrpCode :selected").val() > 0){
            var memGrpCode = "";
            Common.ajax("GET", '/sales/order/getMemberOrgInfo.do', {cmbCode : $("#cmbGrpCode :selected").val()}, function(result){
                memGrpCode = result.grpCode;
            });
            whereSQL += " AND som.GRP_CODE = '"+memGrpCode+"'";
            grpCode = memGrpCode;

        }

        if($("#cmbDeptCode :selected").val() > 0){
            var memDeptCode = "";
            Common.ajax("GET", '/sales/order/getMemberOrgInfo.do', {cmbCode : $("#cmbDeptCode :selected").val()}, function(result){
                memDeptCode = result.grpCode;
            });
            whereSQL += " AND som.DEPT_CODE = '"+memDeptCode+"'";
            deptCode = memDeptCode;

        }

        var custTypeList = "";
        if($('#cmbCustType :selected').length > 0){
            var runNo1 = 0;
            $('#cmbCustType :selected').each(function(i, mul){
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
        $("#form #reportFileName").val("/sales/SalesYSListing_Excel.rpt");

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



$("#dpInstallDateFrom").val(instDtMM+"/"+new Date().getFullYear());
$("#dpInstallDateTo").val(instDtMM+"/"+new Date().getFullYear());
CommonCombo.make('cmbOrgCode', '/sales/order/getOrgCodeList', {memLvl : 1, memType : $("#cmbMemberType :selected").val()} , '');

</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="sal.title.text.ordRptSalesYsListing" /></h1>
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
    <th scope="row"><spring:message code="sal.text.memtype" /></th>
    <td>
    <select class="w100p" id="cmbMemberType" onchange="cmbMemberType_SelectedIndexChanged()">
        <option value="0" selected><spring:message code="sal.btn.all" /></option>
        <option value="1"><spring:message code="sal.text.healthPlanner" /></option>
        <option value="2"><spring:message code="sal.title.text.cody" /></option>
        <option value="4"><spring:message code="sal.text.staff" /></option>
        <option value="3"><spring:message code="sal.text.cowayTechnician" /></option>
    </select>
    </td>
    <th scope="row"><spring:message code="sal.text.orgCode" /></th>
    <td>
    <select class="w100p" id="cmbOrgCode" onchange="cmbOrgCode_SelectedIndexChanged()">
        <option value="0"><spring:message code="sal.btn.all" /></option>
    </select>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.ysAging" /></th>
    <td>
    <select class="multy_select w100p" multiple="multiple" id="cmbYSAging">
        <option value="30" selected>< 31 Days</option>
        <option value="31" selected>31 - 60 Days</option>
        <option value="61" selected>61 - 90 Days</option>
        <option value="91" selected>> 90 Days</option>
        <option value="121" selected>> 120 Days</option>
    </select>
    </td>
    <th scope="row"><spring:message code="sal.text.grpCode" /></th>
    <td>
    <select class="w100p disabled" id="cmbGrpCode" onchange="cmbGrpCode_SelectedIndexChanged()" disabled>
        <option value="0"><spring:message code="sal.btn.all" /></option>
    </select>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.insDate" /></th>
    <td>
    <div class="date_set w100p"><!-- date_set start -->
    <p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date2 w100p" id="dpInstallDateFrom"/></p>
    <span><spring:message code="sal.title.to" /></span>
    <p><input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date2 w100p" id="dpInstallDateTo"/></p>
    </div><!-- date_set end -->
    </td>
    <th scope="row"><spring:message code="sal.text.detpCode" /></th>
    <td>
    <select class="w100p disabled" id="cmbDeptCode" disabled>
        <option value="0"><spring:message code="sal.btn.all" /></option>
    </select>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.custType" /></th>
    <td>
    <select class="multy_select w100p" multiple="multiple" id="cmbCustType">
        <option value="965" selected><spring:message code="sal.combo.text.company" /></option>
        <option value="964" selected><spring:message code="sal.combo.text.individual" /></option>
    </select>
    </td>
    <th scope="row"></th>
    <td></td>
</tr>
</tbody>
</table><!-- table end -->

<ul class="center_btns">
    <li><p class="btn_blue2"><a href="#" onclick="javascript: btnGeneratePDF_Click()"><spring:message code="sal.btn.genPDF" /></a></p></li>
    <li><p class="btn_blue2"><a href="#" onclick="javascript: btnGenerateExcel_Click()"><spring:message code="sal.btn.genExcel" /></a></p></li>
    <li><p class="btn_blue2"><a href="#" onclick="javascript:$('#form').clearForm();"><spring:message code="sal.btn.clear" /></a></p></li>
</ul>

<input type="hidden" id="reportFileName" name="reportFileName" value="" />
<input type="hidden" id="viewType" name="viewType" value="" />
<input type="hidden" id="reportDownFileName" name="reportDownFileName" value="" />

<input type="hidden" id="V_WHERESQL" name="V_WHERESQL" value="" />
<input type="hidden" id="V_USERNAME" name="V_USERNAME" value="" />
<input type="hidden" id="V_MEMBERTYPE" name="V_MEMBERTYPE" value="" />
<input type="hidden" id="V_ORGCODE" name="V_ORGCODE" value="" />
<input type="hidden" id="V_GRPCODE" name="V_GRPCODE" value="" />
<input type="hidden" id="V_DEPTCODE" name="V_DEPTCODE" value="" />
<input type="hidden" id="V_DATE" name="V_DATE" value="" />

<input type="hidden" id="userName" name="userName" value="${SESSION_INFO.userName}">

</form>

</section><!-- content end -->

</section><!-- container end -->

</div><!-- popup_wrap end -->