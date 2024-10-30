<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">

$(document).ready(function() {

	if("${SESSION_INFO.userTypeId}" == "1" ){
        $("#cmbCodyStatus").prop("disabled", true);
	}

    $("#reportInvoiceForm").empty();

    /* 멀티셀렉트 플러그인 start */
    $('.multy_select').change(function() {
       //console.log($(this).val());
    })
    .multipleSelect({
       width: '100%'
    });

    var date = new Date().getDate();
    if(date.toString().length == 1){
        date = "0" + date;
    }
    $("#mypExpireMonthFr").val((new Date().getMonth()+1)+"/"+new Date().getFullYear());
    var month = new Date();
    month.setMonth(month.getMonth()+6);
    var year = new Date().getFullYear();
    if(new Date().getMonth() > month.getMonth()){
    	year += 1;
    }
    $("#mypExpireMonthTo").val((month.getMonth()+1)+"/"+year); //now+AddMonths(6)

});


function validRequiredField(){

	var valid = true;
	var message = "";
	/*
	if(!($("#dpOrderDateFr").val() == null || $("#dpOrderDateFr").val().length == 0) || !($("#dpOrderDateTo").val() == null || $("#dpOrderDateTo").val().length == 0)){
		if(($("#dpOrderDateFr").val() == null || $("#dpOrderDateFr").val().length == 0) || ($("#dpOrderDateTo").val() == null || $("#dpOrderDateTo").val().length == 0)){
	        valid = false;
	        message += "* Please select the order date (From & To).\n";
	    }
	}

	if(!($("#mypExpireMonthFr").val() == null || $("#mypExpireMonthFr").val().length == 0) || !($("#mypExpireMonthTo").val() == null || $("#mypExpireMonthTo").val().length == 0)){
        if(($("#mypExpireMonthFr").val() == null || $("#mypExpireMonthFr").val().length == 0) || ($("#mypExpireMonthTo").val() == null || $("#mypExpireMonthTo").val().length == 0)){
            valid = false;
            message += "* Please select the expired month (From & To).\n";
        }
    }
	*/

	if(($("#mypExpireMonthFr").val() == null || $("#mypExpireMonthFr").val().length == 0) || ($("#mypExpireMonthTo").val() == null || $("#mypExpireMonthTo").val().length == 0)){
        valid = false;
        message += "<spring:message code="sal.alert.msg.expiredMonth" />";
    }

	var frArr = $("#mypExpireMonthFr").val().split("/");
    var toArr = $("#mypExpireMonthTo").val().split("/");
	var mypExpireMonthFr = new Date(frArr[1]+"-"+frArr[0]+"-01");
	mypExpireMonthFr.setMonth(mypExpireMonthFr.getMonth() + 6) //AddMonths(6)
	var mypExpireMonthTo = new Date(toArr[1]+"-"+toArr[0]+"-01");

	if(mypExpireMonthFr < mypExpireMonthTo){
		valid = false;
        message += "<spring:message code='sal.alert.msg.monthInterval6' />";
	}

	if(valid == false){
		Common.alert("<spring:message code="sal.alert.title.reportGenSummary" />" + DEFAULT_DELIMITER + message);
	}

	return valid;
}

function btnGeneratePDF_Click(){
	fn_insertLog();
	if(validRequiredField()){

		$("#reportFileName").val("");
        $("#viewType").val("");
        $("#reportDownFileName").val("");

		var appType = "-";
	    var rentalStatus = "-";
	    var expireMonth = "-";
	    var codyStatus = "-";
	    var userName = $("#userName").val();
	    var whereSQL = "";


	    if(!($("#txtOrderNo").val().trim() == null || $("#txtOrderNo").val().trim().length == 0)){
	    	whereSQL += " AND som.SALES_ORD_NO = '"+$("#txtOrderNo").val().trim()+"' ";
	    }
	    /*
	    if(!($("#dpOrderDateFr").val() == null || $("#dpOrderDateFr").val().length == 0) && !($("#dpOrderDateTo").val() == null || $("#dpOrderDateTo").val().length == 0)){
	    	whereSQL += " AND som.SALES_DT BETWEEN TO_DATE('"+$("#dpOrderDateFr").val()+"', 'dd/MM/YY') AND TO_DATE('"+$("#dpOrderDateTo").val()+"', 'dd/MM/YY')";
	    }
	    */
	    if(!($("#mypExpireMonthFr").val() == null || $("#mypExpireMonthFr").val().length == 0)){
	    	whereSQL += " AND TRUNC(sm.SRV_EXPR_DT, 'month') >= TRUNC(TO_DATE('"+$("#mypExpireMonthFr").val()+"','MM/yyyy'), 'month')"; //GetFirstDayOfMonth
	    	expireMonth = " FROM "+$("#mypExpireMonthFr").val();
	    }
	    if(!($("#mypExpireMonthTo").val() == null || $("#mypExpireMonthTo").val().length == 0)){
            whereSQL += " AND TRUNC(sm.SRV_EXPR_DT, 'month') <= TRUNC(TO_DATE('"+$("#mypExpireMonthTo").val()+"','MM/yyyy'), 'month')";
            expireMonth += " TO "+$("#mypExpireMonthTo").val();
        }
	    if($("input:checkbox[id='btnOnlyExpire']").is(":checked")){
	    	whereSQL += " AND LAST_DAY(sm.SRV_EXPR_DT) < sysdate"; //GetLastDayOfMonth
	    }

	    if($('#cmbAppType :selected').length > 0){
	    	whereSQL += " AND (";
	    	 var runNo = 0;
	    	 $('#cmbAppType :selected').each(function(i, mul){
	    		 if(runNo == 0){
	    			 whereSQL += "som.APP_TYPE_ID = "+$(mul).val();
	    			 appType = $(mul).val();
	    		 }else{
	    			 whereSQL += " OR som.APP_TYPE_ID = "+$(mul).val();
                     appType = ", "+$(mul).val();
	    		 }
	    		 runNo += 1;
	    	 });
	    	 whereSQL += ") ";
	    }
	    if($('#cmbRentalStatus :selected').length > 0){
            whereSQL += " AND (";
             var runNo = 0;
             $('#cmbRentalStatus :selected').each(function(i, mul){
                 if(runNo == 0){
                     whereSQL += "RenSch.STUS_CODE_ID = '"+$(mul).val()+"' ";
                     rentalStatus = $(mul).val();
                 }else{
                     whereSQL += " OR RenSch.STUS_CODE_ID = '"+$(mul).val()+"' ";
                     rentalStatus = ", "+$(mul).val();
                 }
                 runNo += 1;
             });
             whereSQL += ") ";
        }
	    if($('#cmbCodyStatus :selected').length > 0){
            whereSQL += " AND (";
             var runNo = 0;
             $('#cmbCodyStatus :selected').each(function(i, mul){
                 if(runNo == 0){
                     whereSQL += "mem.STUS = "+$(mul).val();
                     codyStatus = $(mul).val();
                 }else{
                     whereSQL += " OR mem.STUS = "+$(mul).val();
                     codyStatus = ", "+$(mul).val();
                 }
                 runNo += 1;
             });
             whereSQL += ") ";
        }

	 // ADDED BY TPY - 25/07/2019 [SCR]
	  var memType = "${SESSION_INFO.userTypeId}";
	  var memLevel = "${SESSION_INFO.memberLevel}";
	  var orgCode =  $('#orgCode').val();
      var grpCode =  $('#grpCode').val();
      var deptCode =  $('#deptCode').val();
      var memCode = $('#memCode').val();

	  if(memType == 2 || memType == 3){ // CHECK MEMBER TYPE

	  if(orgCode == null || orgCode == ""){
		  whereSQL += " ";
	  }else{
		  whereSQL += " AND v.ORG_CODE = '" + orgCode + "' ";
	  }

	  if(grpCode == null || grpCode == ""){
		  whereSQL += " ";
      }else{
    	  whereSQL += " AND v.GRP_CODE = '" + grpCode + "' ";
      }

      if(deptCode == null || deptCode == ""){
    	  whereSQL += " ";
      }else{
    	  whereSQL += " AND v.DEPT_CODE = '" + deptCode + "' ";
      }

       if(memLevel == 4){
    	  whereSQL += " AND v.MEM_CODE = '" + memCode + "' ";
      }else{
    	  whereSQL += " ";
      }

	  }


	    $("#V_WHERESQL").val(whereSQL);
		$("#V_APPTYPE").val(appType);
		$("#V_RENTALSTATUS").val(rentalStatus);
		$("#V_EXPIREMONTH").val(expireMonth);
		$("#V_CODYSTATUS").val(codyStatus);
		$("#V_USERNAME").val(userName);

		var date = new Date().getDate();
	    if(date.toString().length == 1){
	        date = "0" + date;
	    }
		$("#reportDownFileName").val("MembershipExpireList_"+date+(new Date().getMonth()+1)+new Date().getFullYear());
	    $("#viewType").val("PDF");
		$("#reportFileName").val("/membership/MembershipExpiredSummaryListingPDF.rpt");
	//  $("#reportFileName").val("/membership/MembershipExpireList.rpt");

		// 프로시져로 구성된 경우 꼭 아래 option을 넘겨야 함.
		var option = {
		        isProcedure : true // procedure 로 구성된 리포트 인경우 필수.
		};

		Common.report("form", option);
	}
}

function fn_insertLog(){
	var data = {
			orderNo : $("#txtOrderNo").val(),
			applicationType: $("#cmbAppType").val(),
			rentalStus: $("#cmbRentalStatus").val(),
			onlyExpire: $("#btnOnlyExpire").val(),
			expireMonthFr: $("#mypExpireMonthFr").val(),
			expireMonthTo: $("#mypExpireMonthTo").val(),
			path: "membershipOutrightExpireListPop"
	}
	Common.ajax("POST", "/sales/membership/insertGenerateExpireLog.do", data, function(result){
		console.log("Result: >>" + result);
	});
}

function btnGenerateExcel_Click(){

	fn_insertLog();
	if(validRequiredField()){

		$("#reportFileName").val("");
	    $("#viewType").val("");
	    $("#reportDownFileName").val("");

		var appType = "-";
		var rentalStatus = "-";
		var expireMonth = "-";
		var codyStatus = "-";
		var userName = $("#userName").val();
		var whereSQL = "";


		if(!($("#txtOrderNo").val().trim() == null || $("#txtOrderNo").val().trim().length == 0)){
            whereSQL += " AND som.SALES_ORD_NO = '"+$("#txtOrderNo").val().trim()+"' ";
        }
        /*
        if(!($("#dpOrderDateFr").val() == null || $("#dpOrderDateFr").val().length == 0) && !($("#dpOrderDateTo").val() == null || $("#dpOrderDateTo").val().length == 0)){
            whereSQL += " AND som.SALES_DT BETWEEN TO_DATE('"+$("#dpOrderDateFr").val()+"', 'dd/MM/YY') AND TO_DATE('"+$("#dpOrderDateTo").val()+"', 'dd/MM/YY')";
        }
        */
        if(!($("#mypExpireMonthFr").val() == null || $("#mypExpireMonthFr").val().length == 0)){
            whereSQL += " AND TRUNC(sm.SRV_EXPR_DT, 'month') >= TRUNC(TO_DATE('"+$("#mypExpireMonthFr").val()+"','MM/yyyy'), 'month')"; //GetFirstDayOfMonth
            expireMonth = " FROM "+$("#mypExpireMonthFr").val();
        }
        if(!($("#mypExpireMonthTo").val() == null || $("#mypExpireMonthTo").val().length == 0)){
            whereSQL += " AND TRUNC(sm.SRV_EXPR_DT, 'month') <= TRUNC(TO_DATE('"+$("#mypExpireMonthTo").val()+"','MM/yyyy'), 'month')";
            expireMonth += " TO "+$("#mypExpireMonthTo").val();
        }
        if($("input:checkbox[id='btnOnlyExpire']").is(":checked")){
            whereSQL += " AND LAST_DAY(sm.SRV_EXPR_DT) < sysdate"; //GetLastDayOfMonth
        }

        if($('#cmbAppType :selected').length > 0){
            whereSQL += " AND (";
             var runNo = 0;
             $('#cmbAppType :selected').each(function(i, mul){
                 if(runNo == 0){
                     whereSQL += "som.APP_TYPE_ID = "+$(mul).val();
                     appType = $(mul).val();
                 }else{
                     whereSQL += " OR som.APP_TYPE_ID = "+$(mul).val();
                     appType = ", "+$(mul).val();
                 }
                 runNo += 1;
             });
             whereSQL += ") ";
        }
        if($('#cmbRentalStatus :selected').length > 0){
            whereSQL += " AND (";
             var runNo = 0;
             $('#cmbRentalStatus :selected').each(function(i, mul){
                 if(runNo == 0){
                     whereSQL += "RenSch.STUS_CODE_ID = '"+$(mul).val()+"' ";
                     rentalStatus = $(mul).val();
                 }else{
                     whereSQL += " OR RenSch.STUS_CODE_ID = '"+$(mul).val()+"' ";
                     rentalStatus = ", "+$(mul).val();
                 }
                 runNo += 1;
             });
             whereSQL += ") ";
        }
        if($('#cmbCodyStatus :selected').length > 0){
            whereSQL += " AND (";
             var runNo = 0;
             $('#cmbCodyStatus :selected').each(function(i, mul){
                 if(runNo == 0){
                     whereSQL += "mem.STUS = "+$(mul).val();
                     codyStatus = $(mul).val();
                 }else{
                     whereSQL += " OR mem.STUS = "+$(mul).val();
                     codyStatus = ", "+$(mul).val();
                 }
                 runNo += 1;
             });
             whereSQL += ") ";
        }

        // ADDED BY TPY - 25/07/2019 [SCR]
        var memType = "${SESSION_INFO.userTypeId}";
        var memLevel = "${SESSION_INFO.memberLevel}";
        var orgCode =  $('#orgCode').val();
        var grpCode =  $('#grpCode').val();
        var deptCode =  $('#deptCode').val();
        var memCode = $('#memCode').val();

        if(memType == 2 || memType == 3){ // CHECK MEMBER TYPE

        if(orgCode == null || orgCode == ""){
            whereSQL += " ";
        }else{
            whereSQL += " AND v.ORG_CODE = '" + orgCode + "' ";
        }

        if(grpCode == null || grpCode == ""){
            whereSQL += " ";
        }else{
            whereSQL += " AND v.GRP_CODE = '" + grpCode + "' ";
        }

        if(deptCode == null || deptCode == ""){
            whereSQL += " ";
        }else{
            whereSQL += " AND v.DEPT_CODE = '" + deptCode + "' ";
        }

         if(memLevel == 4){
            whereSQL += " AND v.MEM_CODE = '" + memCode + "' ";
        }else{
            whereSQL += " ";
        }

        }

		$("#V_WHERESQL").val(whereSQL);
		$("#V_APPTYPE").val(appType);
		$("#V_RENTALSTATUS").val(rentalStatus);
		$("#V_EXPIREMONTH").val(expireMonth);
		$("#V_CODYSTATUS").val(codyStatus);
		$("#V_USERNAME").val(userName);

		var date = new Date().getDate();
	    if(date.toString().length == 1){
	        date = "0" + date;
	    }
		$("#reportDownFileName").val("MembershipExpireList_"+date+(new Date().getMonth()+1)+new Date().getFullYear());
		$("#viewType").val("EXCEL");
		$("#reportFileName").val("/membership/MembershipExpireSummaryRawData.rpt");
	//	$("#reportFileName").val("/membership/MembershipExpireList.rpt");

		// 프로시져로 구성된 경우 꼭 아래 option을 넘겨야 함.
		var option = {
		        isProcedure : true // procedure 로 구성된 리포트 인경우 필수.
		};

		Common.report("form", option);
	}
}


</script>


<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="sal.page.title.membershipReport" /></h1>
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
    <col style="width:120px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:120px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sal.text.ordNo" /></th>
    <td><input type="text" title="" placeholder="Order Number" class="w100p" id="txtOrderNo"/></td>
    <th scope="row"><spring:message code="sal.text.rentalStatus" /></th>
    <td>
    <select class="multy_select w100p" multiple="multiple" id="cmbRentalStatus">
        <option value="REG" selected>REG</option>
        <option value="INV" selected>INV</option>
    </select>
    </td>
    <th scope="row"><spring:message code="sal.text.expireMonth" /></th>
    <td>
    <div class="date_set w100p"><!-- date_set start -->
    <p><input type="text" title="Create start Date" placeholder="MM/YYYY" class="j_date2 w100p" id="mypExpireMonthFr"/></p>
    <span><spring:message code="sal.text.to" /></span>
    <p><input type="text" title="Create end Date" placeholder="MM/YYYY" class="j_date2 w100p" id="mypExpireMonthTo"/></p>
    </div><!-- date_set end -->
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.appType" /></th>
    <td>
    <select class="multy_select w100p" multiple="multiple" id="cmbAppType" data-placeholder="Application Type">
        <option value="66" selected>Rental</option>
        <option value="67" selected>Outright</option>
        <option value="68" selected>Installment</option>
    </select>
    </td>
    <th scope="row"><spring:message code="sal.text.onlyExpire" /></th>
    <td><label><input type="checkbox" id="btnOnlyExpire"/><span><spring:message code="sal.text.listOnlyExpiredOrder" /></span></label></td>
    <th scope="row"><spring:message code="sal.text.codyStatus" /></th>
    <td>
    <select class="multy_select w100p" multiple="multiple" id="cmbCodyStatus" data-placeholder="Cody Status">
        <option value="1" selected>Active</option>
        <option value="3" selected>Terminated</option>
        <option value="8" selected>Inactive</option>
        <option value="51" selected>Resigned</option>
    </select>
    </td>
</tr>
<tr>
    <td colspan="6"><p><span class="red_text"><spring:message code="sal.text.onlyListUp" /></span><p></td>
</tr>
<tr>
    <td colspan="6"><p><span class="red_text"><spring:message code="sal.text.orderStatusCom" /></span><p></td>
</tr>
</tbody>
</table><!-- table end -->


<ul class="center_btns">
    <li><p class="btn_blue2"><a href="#" onclick="javascript: btnGeneratePDF_Click()"><spring:message code="sal.btn.genPDF" /></a></p></li>
    <%-- <li><p class="btn_blue2"><a href="#" onclick="javascript: btnGenerateExcel_Click()"><spring:message code="sal.btn.genExcel" /></a></p></li> --%>
</ul>

<input type="hidden" id="reportFileName" name="reportFileName" value="" />
<input type="hidden" id="viewType" name="viewType" value="" />
<input type="hidden" id="reportDownFileName" name="reportDownFileName" value="" />


<input type="hidden" id="V_WHERESQL" name="V_WHERESQL" value="" />
<input type="hidden" id="V_APPTYPE" name="V_APPTYPE" value="" />
<input type="hidden" id="V_RENTALSTATUS" name="V_RENTALSTATUS" value="" />
<input type="hidden" id="V_EXPIREMONTH" name="V_EXPIREMONTH" value="" />
<input type="hidden" id="V_CODYSTATUS" name="V_CODYSTATUS" value="" />
<input type="hidden" id="V_USERNAME" name="V_USERNAME" value="" />

<input type="hidden" id="userName" name="userName" value="${SESSION_INFO.userName}">

</form>

</section><!-- content end -->

</section><!-- container end -->

</div><!-- popup_wrap end -->