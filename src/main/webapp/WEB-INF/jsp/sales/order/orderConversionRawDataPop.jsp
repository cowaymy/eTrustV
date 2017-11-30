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

function validRequiredField(){
	
	var valid = true;
	var message = "Field below are required : ";
	
	if($("#cmbRentalStatus :selected").index() < 1){
		message += "\n * Current Rental Status.";
        valid = false;
	}
	
	if($("#cmbAgingMonth").val() == null || $("#cmbAgingMonth").val().length == 0){
        message += "\n * Current Aging Month.";
        valid = false;
    }
	
	if(valid == false){
        Common.alert("Report Generate Summary" + DEFAULT_DELIMITER + message);
    }
	
	return valid;
}

function fn_report(){

	if(validRequiredField() == true){
		
		var rentalStatus = $("#cmbRentalStatus :selected").text();
		var rentalAgingMonth = " AND (";
		var text1 = null;
		var text2 = null;
		
		$('#cmbAgingMonth :selected').each(function(i, mul){ 
			if($(mul).val() == "7"){
				text1 = "AA.AGINGMONTH  >= 7";
			}else{
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
		
		$("#V_RENTALSTATUS").val(rentalStatus);
		$("#V_RENTALAGINGMONTH").val(rentalAgingMonth);
		
		var date = new Date().getDate();
		if(date.toString().length == 1){
		    date = "0" + date;
		}
	    $("#reportDownFileName").val("ConversionRawData_"+date+(new Date().getMonth()+1)+new Date().getFullYear());
	    $("#reportFileName").val("/sales/ConversionRawData.rpt");
	    
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
<h1>Order Cancellation Request Raw Data</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
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
    <th scope="row">Current Rental Status</th>
    <td>
    <select class="w100p" id="cmbRentalStatus">
        <option data-placeholder="true" hidden>Rental Status</option>
        <option value="1">REG</option>
        <option value="2">INV</option>
        <option value="3">SUS</option>
        <option value="4">RET</option>
    </select>
    </td>
    <th scope="row">Current Aging Month (B)</th>
    <td>
    <select class="multy_select w100p" multiple="multiple" id="cmbAgingMonth" data-placeholder="Aging Month">
        <option value="0">0</option>
        <option value="1">1</option>
        <option value="2">2</option>
        <option value="3">3</option>
        <option value="4">4</option>
        <option value="5">5</option>
        <option value="6">6</option>
        <option value="7">≥7</option>
    </select>
    </td>
</tr>
</tbody>
</table><!-- table end -->

<ul class="center_btns">
    <li><p class="btn_blue2"><a href="#" onclick="javascript: fn_report()">Generate</a></p></li>
</ul>

<input type="hidden" id="reportFileName" name="reportFileName" value="" />
<input type="hidden" id="viewType" name="viewType" value="EXCEL" />
<input type="hidden" id="reportDownFileName" name="reportDownFileName" value="" />

<input type="hidden" id="V_RENTALSTATUS" name="V_RENTALSTATUS" value="">
<input type="hidden" id="V_RENTALAGINGMONTH" name="V_RENTALAGINGMONTH" value="">

</form>

</section><!-- content end -->
     
</section><!-- container end -->

</div><!-- popup_wrap end -->