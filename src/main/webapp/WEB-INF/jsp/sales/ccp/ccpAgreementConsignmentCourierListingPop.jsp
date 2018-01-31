<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">
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
    });
};


function fn_report(){
	
	$("#V_WHERESQL").val("");
    $("#V_ORDERBYSQL").val("");
    var whereSQL = "";
    var orderSQL = "";
	
    var txtOrderNo1 = $("#txtOrderNo1").val().trim();
    var txtOrderNo2 = $("#txtOrderNo2").val().trim();
	
    if(!(txtOrderNo1 == null || txtOrderNo1.length == 0) && !(txtOrderNo2 == null || txtOrderNo2.length == 0)){
        whereSQL += " AND (OrM.SALES_ORD_NO BETWEEN '"+txtOrderNo1+"' AND '"+txtOrderNo2+"')";
    }else{
        if(!(txtOrderNo1 == null || txtOrderNo1.length == 0) && (txtOrderNo2 == null || txtOrderNo2.length == 0)){
            whereSQL += " AND OrM.SALES_ORD_NO >= '"+txtOrderNo1+"'";
        }else if((txtOrderNo1 == null || txtOrderNo1.length == 0) && !(txtOrderNo2 == null || txtOrderNo2.length == 0)){
            whereSQL += " AND OrM.SALES_ORD_NO <= '"+txtOrderNo2+"'";
        }
    }
    
    if($("#cmbAgrType option:selected").index() > 1){
        whereSQL += " AND ArgM.GOV_AG_TYPE_ID = '"+$("#cmbAgrType option:selected").val()+"'";
    }
	if($("#cmbRequestor option:selected").index() > 1){
		whereSQL += " AND Cons.AG_REQSTER_TYPE_ID = '"+$("#cmbRequestor option:selected").val()+"'";
	}
	if(!($("#dpDateFrom").val() == null || $("#dpDateFrom").val().length == 0) && !($("#dpDateTo").val() == null || $("#dpDateTo").val().length == 0)){
        whereSQL += " AND ArgM.GOV_AG_LAST_RCIV_DT BETWEEN TO_DATE('"+$("#dpDateFrom").val()+"', 'dd/MM/yyyy') AND TO_DATE('"+$("#dpDateTo").val()+"', 'dd/MM/yyyy')";
    }
	
	var action = "";
	action = $("#cmbSorting :selected").val();
	if(action == "1"){
		orderSQL = " ORDER BY ArgM.GOV_AG_ID";
	}else if(action == "2"){
	    orderSQL = " ORDER BY OrM.SALES_ORD_NO";
	}else if(action == "3"){
	    orderSQL = " ORDER BY ArgM.GOV_AG_LAST_RCIV_DT";
	}else if(action == "4"){
	    orderSQL = " ORDER BY ArgM.GOV_AG_TYPE_ID";
	}else if(action == "5"){
	    orderSQL = " ORDER BY Cons.AG_REQSTER_TYPE_ID";
	}
	
	
    var date = new Date().getDate();
    if(date.toString().length == 1){
        date = "0" + date;
    } 
    
    $("#viewType").val("PDF");
    $("#reportFileName").val("/sales/GovAgrConsignmentPDF.rpt");
    
    $("#reportDownFileName").val("AgrConsignmentReport_"+date+(new Date().getMonth()+1)+new Date().getFullYear());
    $("#V_WHERESQL").val(whereSQL);
    $("#V_ORDERBYSQL").val(orderSQL);
	
	// 프로시져로 구성된 경우 꼭 아래 option을 넘겨야 함.
    var option = {
        isProcedure : true // procedure 로 구성된 리포트 인경우 필수.  => /payment/PaymentListing_Excel.rpt 는 프로시져로 구성된 파일임.
    };

    Common.report("form", option);
}

function ValidRequiredField(){
    var valid = true;
    var message = "";
    
    if(($("#dpDateFrom").val() == null || $("#dpDateFrom").val().length == 0) && !($("#dpDateTo").val() == null || $("#dpDateTo").val().length == 0)){
        valid = false;
        message += '<spring:message code="sal.alert.msg.keyInRecvDateFrom" />';
    }else if(!($("#dpDateFrom").val() == null || $("#dpDateFrom").val().length == 0) && ($("#dpDateTo").val() == null || $("#dpDateTo").val().length == 0)){
        valid = false;
        message += '<spring:message code="sal.alert.msg.keyInRecvDateTo" />';
    }

    if(valid == true){
        fn_report();
    }else{
    	Common.alert('<spring:message code="sal.alert.msg.consignCourierGenSum" />'+ DEFAULT_DELIMITER + message);
    }
}


</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="sal.title.text.consignCourierSumRpt" /></h1>
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
    <th scope="row"><spring:message code="sal.text.ordNo" /></th>
    <td>
    <div class="date_set w100p"><!-- date_set start -->
    <p><input type="text" title="" placeholder="Order No (From)" class="w100p" id="txtOrderNo1"/></p>
    <span><spring:message code="sal.title.to" /></span>
    <p><input type="text" title="" placeholder="Order No (To)" class="w100p" id="txtOrderNo2"/></p>
    </div><!-- date_set end -->
    </td>
    <th scope="row"><spring:message code="sal.title.text.agreeType" /></th>
    <td>
    <select class="w100p" id="cmbAgrType">
        <option data-placeholder="true" hidden><spring:message code="sal.title.text.agreeType" /></option>
        <option value="949"><spring:message code="sal.title.text.new" /></option>
        <option value="950"><spring:message code="sal.title.text.reNew" /></option>
    </select>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.recvDate" /></th>
    <td>
    <div class="date_set w100p"><!-- date_set start -->
    <p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" id="dpDateFrom"/></p>
    <span>To</span>
    <p><input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" id="dpDateTo"/></p>
    </div><!-- date_set end -->
    </td>
    <th scope="row"><spring:message code="sal.title.text.agmReqstor" /></th>
    <td>
    <select class="w100p" id="cmbRequestor">
        <option data-placeholder="true" hidden><spring:message code="sal.title.text.agmReqstor" /></option>
        <option value="1"><spring:message code="sal.title.text.hp" /></option>
        <option value="2"><spring:message code="sal.title.text.cody" /></option>
        <option value="1234"><spring:message code="sal.title.text.customer" /></option>
    </select>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.sortingBy" /></th>
    <td colspan="3">
    <select class="w100p" id="cmbSorting">
        <option value="1"><spring:message code="sal.combo.text.sortingByAgmNo" /></option>
        <option value="2"><spring:message code="sal.combo.text.sortingByOrdNo" /></option>
        <option value="3"><spring:message code="sal.combo.text.sortingByRecvDate" /></option>
        <option value="4"><spring:message code="sal.combo.text.sortingByAgreementType" /></option>
        <option value="5"><spring:message code="sal.combo.text.sortingByAgmReqstor" /></option>
    </select>
    </td>
</tr>
</tbody>
</table><!-- table end -->

<ul class="right_btns">
    <li><p class="btn_blue"><a href="javascript:void(0);" onclick="javascript: ValidRequiredField();"><spring:message code="sal.btn.genPDF" /></a></p></li>
    <li><p class="btn_blue"><a href="#" onclick="javascript:$('#form').clearForm();"><span class="clear"></span><spring:message code="sal.btn.clear" /></a></p></li>
</ul>

<input type="hidden" id="reportFileName" name="reportFileName" value="/sales/GovAgrConsignmentPDF.rpt" />
<input type="hidden" id="viewType" name="viewType" value="PDF" />
<input type="hidden" id="reportDownFileName" name="reportDownFileName" value="" />


<input type="hidden" id="V_WHERESQL" name="V_WHERESQL" value="" />
<input type="hidden" id="V_ORDERBYSQL" name="V_ORDERBYSQL" value="" />


</form>


</section><!-- content end -->
     
</section><!-- container end -->

</div><!-- popup_wrap end -->