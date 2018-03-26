<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">

var date = new Date().getDate();
if(date.toString().length == 1){
    date = "0" + date;
}
$("#dpDateFr").val(date+"/"+(new Date().getMonth()+1)+"/"+new Date().getFullYear());
$("#dpDateTo").val(date+"/"+(new Date().getMonth()+1)+"/"+new Date().getFullYear());

$.fn.clearForm = function() {
    return this.each(function() {
        var type = this.type, tag = this.tagName.toLowerCase();
        if (tag === 'form'){
            return $(':input',this).clearForm();
        }
        if (type === 'text' || type === 'password' || type === 'hidden' || tag === 'textarea'){
            this.value = '';
        }else if (type === 'checkbox' || type === 'radio'){
            this.checked = false;
        }else if (tag === 'select'){
            this.selectedIndex = 0;
        }
        $("#dpDateFr").val(date+"/"+(new Date().getMonth()+1)+"/"+new Date().getFullYear());
        $("#dpDateTo").val(date+"/"+(new Date().getMonth()+1)+"/"+new Date().getFullYear());
    });
};

function fn_report(){

	$("#V_WHERESQL").val("");
    var whereSQL = "";

    if(!($("#dpDateFr").val() == null || $("#dpDateFr").val().length == 0)){
        whereSQL += " AND ArgM.GOV_AG_START_DT >= TO_DATE('"+$("#dpDateFr").val()+"', 'dd/MM/yy')";
    }
    if(!($("#dpDateTo").val() == null || $("#dpDateTo").val().length == 0)){
    	whereSQL += " AND ArgM.GOV_AG_START_DT <= TO_DATE('"+$("#dpDateTo").val()+"', 'dd/MM/yy')";
    }

    if(!($("#txtAgrNoFrom").val() == null || $("#txtAgrNoFrom").val().length == 0) && !($("#txtAgrNoTo").val() == null || $("#txtAgrNoTo").val().length == 0)){
    	whereSQL += " AND (ArgM.GOV_AG_BATCH_NO BETWEEN '"+txtOrderNo1.replace("'", "''")+"' AND '"+txtOrderNo2.replace("'", "''")+"')";
    }
    if($("#ddlProgress option:selected").index() > 0){
        whereSQL += " AND ArgM.GOV_AG_PRGRS_ID = '"+$("#ddlProgress option:selected").val()+"'";
    }
    if($("#cmbAgrStatus option:selected").index() > 0){
        whereSQL += " AND ArgM.GOV_AG_STUS_ID = '"+$("#cmbAgrStatus option:selected").val()+"'";
    }
    if(!($("#txtCreator").val() == null || $("#txtCreator").val().length == 0)){
    	whereSQL += " AND Usr1.USER_NAME = '"+$("#txtCreator").val()+"'";
    }

	var date = new Date().getDate();
    if(date.toString().length == 1){
        date = "0" + date;
    }
    $("#form #viewType").val("EXCEL");
    $("#form #reportFileName").val("/sales/GovContratAgrRaw.rpt");
    $("#form #reportDownFileName").val("AgreementRaw_"+date+(new Date().getMonth()+1)+new Date().getFullYear());
    $("#V_WHERESQL").val(whereSQL);

	// 프로시져로 구성된 경우 꼭 아래 option을 넘겨야 함.
    var option = {
        isProcedure : true // procedure 로 구성된 리포트 인경우 필수.  => /payment/PaymentListing_Excel.rpt 는 프로시져로 구성된 파일임.
    };

    Common.report("form", option);
}

function ValidRequiredField(){
	var valid = true;
	var message = "";

	if($("#dpDateFr").val() == null || $("#dpDateFr").val().length == 0){
		valid = false;
		message += "* Please key in the Agreement Start Date.\n";
    }

	if(valid == true){
		fn_report();
	}else{
		Common.alert('<spring:message code="sal.alert.msg.ccpGenSummry" />'+ DEFAULT_DELIMITER + message);
	}
}

</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="sal.title.text.ccpListing" /></h1>
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
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sal.title.text.agrNo" /></th>
    <td>
    <div class="date_set"><!-- date_set start -->
    <p><input type="text" title="" placeholder="" class="w100p" id="txtAgrNoFrom"/></p>
    <span><spring:message code="sal.title.to" /></span>
    <p><input type="text" title="" placeholder="" class="w100p" id="txtAgrNoTo"/></p>
    </div><!-- date_set end -->
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.agrStartDate" /></th>
    <td>
    <div class="date_set"><!-- date_set start -->
    <p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" id="dpDateFr"/></p>
    <span><spring:message code="sal.title.to" /></span>
    <p><input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" id="dpDateTo"/></p>
    </div><!-- date_set end -->
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.combo.text.prgssStus" /></th>
    <td>
    <select id="ddlProgress">
        <option value="" hidden><spring:message code="sal.title.text.prgss" /></option>
        <option value="7"><spring:message code="sal.title.agrSubmission" /></option>
        <option value="8"><spring:message code="sal.title.agrVerifying" /></option>
        <option value="9"><spring:message code="sal.title.argStmpAndConfirm" /></option>
        <option value="10"><spring:message code="sal.title.text.agrFilling" /></option>
    </select>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.agrStatus" /></th>
    <td>
    <select id="cmbAgrStatus">
        <option value="" hidden><spring:message code="sal.title.status" /></option>
        <option value="1"><spring:message code="sal.btn.active" /></option>
        <option value="4"><spring:message code="sal.combo.text.compl" /></option>
        <option value="10"><spring:message code="sal.combo.text.cancelled" /></option>
    </select>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.createBy" /></th>
    <td><input type="text" title="" placeholder="" class="" id="txtCreator"/></td>
</tr>
</tbody>
</table><!-- table end -->

<ul class="right_btns">
    <li><p class="btn_blue"><a href="javascript:void(0);" onclick="javascript: ValidRequiredField();"><spring:message code="sal.btn.generate" /></a></p></li>
    <li><p class="btn_blue"><a href="#" onclick="javascript:$('#form').clearForm();"><span class="clear"></span><spring:message code="sal.btn.clear" /></a></p></li>
</ul>

<input type="hidden" id="reportFileName" name="reportFileName" value="/sales/GovContratAgrRaw.rpt" />
<input type="hidden" id="viewType" name="viewType" value="EXCEL" />
<input type="hidden" id="reportDownFileName" name="reportDownFileName" value="" />

<input type="hidden" id="V_WHERESQL" name="V_WHERESQL" value="" />

</form>


</section><!-- content end -->

</section><!-- container end -->

</div><!-- popup_wrap end -->