<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">

/* 멀티셀렉트 플러그인 start */
$('.multy_select').change(function() {
   //console.log($(this).val());
})
.multipleSelect({
   width: '100%'
});

$.fn.clearForm = function() {
	$("#cboAgmStatus").multipleSelect("checkAll");
	
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

function validRequiredField(){
	
	var valid = true;
	var message = "";
	
	if($("input[name='searchby']:checked").val() == "btnMonthly"){
		if($("#dpMthYear").val() == null || $("#dpMthYear").val().length == 0){
			
			valid = false;
			message += "* Please select the month/year.\n";
		}
	}
		
	if(valid == false){
        Common.alert('<spring:message code="sal.title.text.cntcAgrSummary" />' + DEFAULT_DELIMITER + message);
    }else{
    	fn_report();
    }
	
}


function fn_report(){
	
	$("#V_WHERESQL").val("");
    $("#V_GROUPBYSQL").val("");
    $("#V_ARGTYPE").val("");
    var whereSQL = "";
    var groupSQL = "";
    var argType = "";
	
	
	if($("input[name='searchby']:checked").val() == "btnDaily"){
	    if(!($("#dpDateFr").val() == null || $("#dpDateFr").val().length == 0)){
	        whereSQL += " AND ArgM.GOV_AG_CRT_DT >= TO_DATE('"+$("#dpDateFr").val()+"', 'dd/MM/yyyy')";
	    }
	    if(!($("#dpDateTo").val() == null || $("#dpDateTo").val().length == 0)){
            whereSQL += " AND ArgM.GOV_AG_CRT_DT <= TO_DATE('"+$("#dpDateTo").val()+"', 'dd/MM/yyyy')";
        }
	    
	    if(!($("#dtStartFr").val() == null || $("#dtStartFr").val().length == 0) && !($("#dtStartTo").val() == null || $("#dtStartTo").val().length == 0)){
            whereSQL += " AND ArgM.GOV_AG_START_DT BETWEEN TO_DATE('"+$("#dtStartFr").val()+"', 'dd/MM/yyyy') AND TO_DATE('"+$("#dtStartTo").val()+"', 'dd/MM/yyyy')";
        }
	    if(!($("#dtExpiryFr").val() == null || $("#dtExpiryFr").val().length == 0) && !($("#dtExpiryTo").val() == null || $("#dtExpiryTo").val().length == 0)){
            whereSQL += " AND ArgM.GOV_AG_END_DT BETWEEN TO_DATE('"+$("#dtExpiryFr").val()+"', 'dd/MM/yyyy') AND TO_DATE('"+$("#dtExpiryTo").val()+"', 'dd/MM/yyyy')";
        }
	}else if($("input[name='searchby']:checked").val() == "btnMonthly"){
		if(!($("#dpMthYear").val() == null || $("#dpMthYear").val().length == 0)){
            whereSQL += " AND YEAR(ArgM.GOV_AG_CRT_DT) ='"+$("#dpMthYear").val().substring(6,10)+"' AND MONTH(ArgM.GOV_AG_CRT_DT) = '"+$("#dpMthYear").val().substring(3,5)+"'";
        }  
	}
	
	 if($('#cboAgmStatus :selected').length > 0){
		  var result = "";
	      $('#cboAgmStatus :selected').each(function(i, mul){ 
	           result += $(mul).val();
	      });

	      if(result == "ACTCOMCAN"){
	          whereSQL += " AND (ArgM.GOV_AG_STUS_ID='1' OR ArgM.GOV_AG_STUS_ID='4' OR ArgM.GOV_AG_STUS_ID='10')";
	      }else if(result == "ACTCOM"){
	          whereSQL += " AND (ArgM.GOV_AG_STUS_ID='1' OR ArgM.GOV_AG_STUS_ID='4')";
	      }else if(result == "ACTCAN"){
	          whereSQL += " AND (ArgM.GOV_AG_STUS_ID='1' OR ArgM.GOV_AG_STUS_ID='10')";
	      }else if(result == "COMCAN"){
	          whereSQL += " AND (ArgM.GOV_AG_STUS_ID='4' OR ArgM.GOV_AG_STUS_ID='10')";
	      }else if(result == "ACT"){
	          whereSQL += " AND ArgM.GOV_AG_STUS_ID='1'";
	      }else if(result == "COM"){
	          whereSQL += " AND ArgM.GOV_AG_STUS_ID='4'";
	      }else if(result == "CAN"){
	          whereSQL += " AND ArgM.GOV_AG_STUS_ID='10'";
	      }
	 }
	
	if($("#cmbAgrType option:selected").index() > 0){
	     whereSQL += " AND ArgM.GOV_AG_TYPE_ID = '"+$("#cmbAgrType option:selected").val()+"'";
		 groupSQL += ", ArgM.GOV_AG_TYPE_ID ";
		 argType = $("#cmbAgrType option:selected").val().trim();
	}else{
		argType = "All";
	}
	
	var date = new Date().getDate();
    if(date.toString().length == 1){
        date = "0" + date;
    } 
    
    $("#viewType").val("PDF");
    $("#reportFileName").val("/sales/GovContractAgrSummaryPDF.rpt");
    
    $("#reportDownFileName").val("ContractArgSummary_"+date+(new Date().getMonth()+1)+new Date().getFullYear());
    $("#V_WHERESQL").val(whereSQL);
    $("#V_GROUPBYSQL").val(groupSQL);
    $("#V_ARGTYPE").val(argType);
	
	// 프로시져로 구성된 경우 꼭 아래 option을 넘겨야 함.
    var option = {
        isProcedure : true // procedure 로 구성된 리포트 인경우 필수.  => /payment/PaymentListing_Excel.rpt 는 프로시져로 구성된 파일임.
    };

    Common.report("form", option);
}


</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="sal.title.text.cntcAgrSumRpt" /></h1>
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
    <th scope="row"><spring:message code="sal.title.text.agreeType" /></th>
    <td>
    <select class="w100p" id="cmbAgrType">
        <option data-placeholder="true" hidden><spring:message code="sal.title.text.agreeType" /></option>
        <option value="949"><spring:message code="sal.title.text.new" /></option>
        <option value="950"><spring:message code="sal.title.text.reNew" /></option>
    </select>
    </td>
    <th scope="row"><spring:message code="sal.title.text.agrStart" /></th>
    <td>
    <div class="date_set w100p"><!-- date_set start -->
    <p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" id="dtStartFr"/></p>
    <span><spring:message code="sal.title.to" /></span>
    <p><input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" id="dtStartTo"/></p>
    </div><!-- date_set end -->
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.searchBy" /></th>
    <td>
    <label><input type="radio" name="searchby" value="btnDaily"/><span><spring:message code="sal.title.text.daily" /></span></label>
    <label><input type="radio" name="searchby" value="btnMonthly"/><span><spring:message code="sal.title.text.monthly" /></span></label>
    </td>
    <th scope="row"><spring:message code="sal.title.text.agrExpiry" /></th>
    <td>
    <div class="date_set w100p"><!-- date_set start -->
    <p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" id="dtExpiryFr"/></p>
    <span><spring:message code="sal.title.to" /></span>
    <p><input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" id="dtExpiryTo"/></p>
    </div><!-- date_set end -->
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.crtDate" /></th>
    <td>
    <div class="date_set w100p"><!-- date_set start -->
    <p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" id="dpDateFr"/></p>
    <span><spring:message code="sal.title.to" /></span>
    <p><input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" id="dpDateTo"/></p>
    </div><!-- date_set end -->
    </td>
    <th scope="row"><spring:message code="sal.title.text.agrStatus" /></th>
    <td>
    <select class="multy_select w100p" multiple="multiple"  data-placeholder="All items selected" id="cboAgmStatus">
        <option value="ACT" selected><spring:message code="sal.btn.active" /></option>
        <option value="COM" selected><spring:message code="sal.combo.text.compl" /></option>
        <option value="CAN" selected><spring:message code="sal.combo.text.cancelled" /></option>
    </select>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.mthYear" /></th>
    <td><input type="text" title="Create start Date" placeholder="Month&Year" class="j_date w100p" id="dpMthYear"/></td>
    <th scope="row"></th>
    <td></td>
</tr>
</tbody>
</table><!-- table end -->

<ul class="right_btns">
    <li><p class="btn_blue"><a href="javascript:void(0);" onclick="javascript: fn_report();"><spring:message code="sal.btn.genPDF" /></a></p></li>
    <li><p class="btn_blue"><a href="#" onclick="javascript:$('#form').clearForm();"><span class="clear"></span><spring:message code="sal.btn.clear" /></a></p></li>
</ul>

<input type="hidden" id="reportFileName" name="reportFileName" value="/sales/GovContractAgrSummaryPDF.rpt" />
<input type="hidden" id="viewType" name="viewType" value="PDF" />
<input type="hidden" id="reportDownFileName" name="reportDownFileName" value="" />

<input type="hidden" id="V_WHERESQL" name="V_WHERESQL" value="" />
<input type="hidden" id="V_GROUPBYSQL" name="V_GROUPBYSQL" value="" />
<input type="hidden" id="V_ARGTYPE" name="V_ARGTYPE" value="" />

</form>

</section><!-- content end -->
     
</section><!-- container end -->

</div><!-- popup_wrap end -->