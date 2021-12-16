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

$(document).ready(function(){
	 CommonCombo.make("customerType", "/common/selectCodeList.do", {groupCode : '8'}, '964', {isShowChoose: false});
	 $(".IndividualMode").show();
     $(".CompanyMode").hide();
});



function fn_customerChng(){
    $("#cmbAgingMonth").multipleSelect("uncheckAll");
    if($("#customerType").val() == "964"){
        $(".IndividualMode").show();
        $(".CompanyMode").hide();
    }else{
    	  $(".IndividualMode").hide();
          $(".CompanyMode").show();
    }
}


function validRequiredField(){

	var valid = true;
	var message = '<spring:message code="sal.alert.msg.fieldBelowReq" />';

	if($("#cmbRentalStatus :selected").index() < 1){
		message += '<spring:message code="sal.alert.msg.currStatus" />';
        valid = false;
	}

	if($("#cmbAgingMonth").val() == null || $("#cmbAgingMonth").val().length == 0){
        message += '<spring:message code="sal.alert.msg.currAgingMonth" />';
        valid = false;
    }

	if(valid == false){
        Common.alert('<spring:message code="sal.alert.title.reportGenSummary" />' + DEFAULT_DELIMITER + message);
    }

	return valid;
}

function fn_report(){

	if(validRequiredField() == true){


		var rentalStatus = $("#cmbRentalStatus :selected").text();
		var rentalAgingMonth = " AND (";
		var rentalCustomerType = '';
		var rentalCompanyType = '';
		var text1 = null;
		var text2 = null;
		var text3 = null;

		$('#cmbAgingMonth :selected').each(function(i, mul){
			if($(mul).val() == "7"){
				text1 = "AA.AGINGMONTH  >= 7";
			}
			else if($(mul).val() == "12"){
                text1 = "AA.AGINGMONTH  <= 12";
            }
			else if($(mul).val() == "13"){
                text1 = "AA.AGINGMONTH  >= 12";
            }
			else{
				if(text2 == null || text2.length == 0){
					text2 = $(mul).val().trim();
				}else{
					text2 += ", "+$(mul).val().trim();
				}
			}
		});

		if(!(text2 == null || text2.length == 0)){
			rentalAgingMonth += "AA.AGINGMONTH IN ("+text2+")";
			if(!(text1 == null || text1.length == 0)){
				rentalAgingMonth += " OR ";
			}
		}

		if(!(text1 == null || text1.length == 0)){
            rentalAgingMonth += text1;
        }

		rentalAgingMonth += ")";


	    rentalCustomerType += " AND (AA.TYPE_ID = " +$("#customerType").val();
	    rentalCustomerType += ")";

	    if($("#customerType").val()=="965"){
	    	rentalCompanyType += " AND (AA.CORP_TYPE_ID IN (1152,1154,1174,1333)";
	    	rentalCompanyType += ")";
	    }
	    else{
	    	rentalCompanyType =null;
	    }

		$("#V_RENTALSTATUS").val(rentalStatus);
		$("#V_RENTALAGINGMONTH").val(rentalAgingMonth);
		$("#V_RENTALCUSTOMERTYPE").val(rentalCustomerType);
		$("#V_RENTALCOMPANYTYPE").val(rentalCompanyType);


		var date = new Date().getDate();
		if(date.toString().length == 1){
		    date = "0" + date;
		}
	    $("#reportDownFileName").val("ConversionRawData_"+date+(new Date().getMonth()+1)+new Date().getFullYear());
	    $("#reportFileName").val("/sales/ConversionRawData.rpt");
	    $("#viewType").val("EXCEL");

	    // 프로시져로 구성된 경우 꼭 아래 option을 넘겨야 함.
	    var option = {
	            isProcedure : true // procedure 로 구성된 리포트 인경우 필수.  => /payment/PaymentListing_Excel.rpt 는 프로시져로 구성된 파일임.
	    };

	    Common.report("form", option);
	}
}


</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="sal.title.text.ordConversionRawData" /></h1>
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
    <col style="width:190px" />
    <col style="width:*" />
    <col style="width:210px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sal.title.text.currRentStatus" /></th>
    <td>
    <select class="w100p" id="cmbRentalStatus">
        <option data-placeholder="true" hidden><spring:message code="sal.title.text.rentalStatus" /></option>
        <option value="1"><spring:message code="sal.combo.text.reg" /></option>
        <option value="2"><spring:message code="sal.combo.text.inv" /></option>
        <option value="3"><spring:message code="sal.combo.text.sus" /></option>
        <option value="4"><spring:message code="sal.combo.text.ret" /></option>
    </select>
    </td>
    <th scope="row"><spring:message code="sal.title.text.currAgingMonthB" /></th>
    <td>
    <select class="multy_select w100p" multiple="multiple" id="cmbAgingMonth" data-placeholder="Aging Month">
        <option value="0" class="IndividualMode">0</option>
        <option value="1" class="IndividualMode">1</option>
        <option value="2" class="IndividualMode">2</option>
        <option value="3" class="IndividualMode">3</option>
        <option value="4" class="IndividualMode">4</option>
        <option value="5" class="IndividualMode">5</option>
        <option value="6" class="IndividualMode">6</option>
        <option value="7" class="IndividualMode">≥7</option>
        <option value="12" class="CompanyMode">≤12</option>
        <option value="13" class="CompanyMode">≥12</option>
    </select>
    </td>
</tr>
    <tr>
        <th scope="row"><spring:message code="sal.text.custType" /></th>
        <td>
         <select  id="customerType" name="customerType" class="w100p" onchange="javascript:fn_customerChng();" ></select>
        </td>
        <th></th>
        <td></td>
    </tr>
</tbody>
</table><!-- table end -->



<input type="hidden" id="reportFileName" name="reportFileName" value="" />
<input type="hidden" id="viewType" name="viewType" value="EXCEL" />
<input type="hidden" id="reportDownFileName" name="reportDownFileName" value="" />

<input type="hidden" id="V_RENTALSTATUS" name="V_RENTALSTATUS" value="">
<input type="hidden" id="V_RENTALAGINGMONTH" name="V_RENTALAGINGMONTH" value="">
<input type="hidden" id="V_RENTALCUSTOMERTYPE" name="V_RENTALCUSTOMERTYPE" value="">
<input type="hidden" id="V_RENTALCOMPANYTYPE" name="V_RENTALCOMPANYTYPE" value="">

</form>
<div style="height : 150px"></div>
<ul class="center_btns">
    <li><p class="btn_blue2"><a href="#" onclick="javascript: fn_report()"><spring:message code="sal.btn.generate" /></a></p></li>
</ul>
</section><!-- content end -->

</section><!-- container end -->

</div><!-- popup_wrap end -->