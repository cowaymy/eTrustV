<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">

$(document).ready(function() {
	
	CommonCombo.make("_rentalStusType","/sales/rcms/rentalStatusListForBadAcc", {selCategoryId: '5', codeIn : ['29' ,'27' ,'2' ,'69', '3']},'',{
        id: "stusCodeId",
        name:"codeName",
        isShowChoose: false 
      });
});

function fn_genReport(type){
	
	//Validation
	if($("#_rentalStusType").val() == null || $("#_rentalStusType").val() == ''){
		Common.alert("Please Select Rental Status Type.");
		return;
	}
	
	$("#reportFileName").val('/sales/CCD_RentalBadAccRaw.rpt');  //Rpt File Name
	$("#viewType").val(type);  //view Type
	
	//title
	var date = new Date().getDate();
    if(date.toString().length == 1){
        date = "0" + date;
    }
    var title = "RentalBadAccountRaw_"+date+(new Date().getMonth()+1)+new Date().getFullYear();
    
	$("#reportDownFileName").val(title); //Download File Name
	
	var whereSql = '';
	var rtnTypeStr = '';
	rtnTypeStr = fn_changeValueToChar($("#_rentalStusType").val());
	if(rtnTypeStr == null || rtnTypeStr == ''){
		Common.alert("Please Contact IT Team");
		return;
	}
	
	whereSql += "AND RSch.STUS_CODE_ID = '"+rtnTypeStr+"'";
	$("#V_WHERESQL").val(whereSql);// Procedure Param
	
	//Make Report
	var option = {
	        isProcedure : true // procedure 로 구성된 리포트 인경우 필수.  => /payment/PaymentListing_Excel.rpt 는 프로시져로 구성된 파일임.
	};
	Common.report("badReport", option);
}

function fn_changeValueToChar(num){
	if(num == 29){
		return 'INV';
	}
	if(num == 2){
		return 'SUS';
	}
	if(num == 27){
		return 'RET';
	}
	if(num == 3){
		return 'TER';	
	}
    if(num == 69){
        return 'WOF';
    }
    
    //default
    return null; 
}

</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>BAD ACCOUNT</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#" id="_AddPopclose">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->
<aside class="title_line"><!-- title_line start -->
<h3>Bad Account Report</h3>
</aside><!-- title_line end -->

<form id="badReport">

<!-- Essential -->
<input type="hidden" id="reportFileName" name="reportFileName" value="" />
<input type="hidden" id="viewType" name="viewType" />
<input type="hidden" id="reportDownFileName" name="reportDownFileName"  />
<!-- Params -->
<input type="hidden" id="V_WHERESQL" name="V_WHERESQL" />

</form>


<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
</colgroup>
<tbody>
    <tr>
        <th scope="row">Rental Status Type</th>
        <td>
            <select  id="_rentalStusType" name="rentalStusType" class="w100p" >
                <!--  <option value="INV">Investigation</option>
                 <option value="RET">Return</option>
                 <option value="SUS">Suspend</option>
                 <option value="TER">Termination</option>
                 <option value="WOF">Write Off</option> -->
            </select>
        </td>
    </tr>
</tbody>
</table><!-- table end -->

<ul class="center_btns">
    <li><p class="btn_blue2 big"><a onclick="javascript: fn_genReport('EXCEL')">Generate Excel</a></p></li>
    <li><p class="btn_blue2 big"><a onclick="javascript: fn_genReport('PDF')">Generate PDF</a></p></li>
</ul>

</section>
</div>