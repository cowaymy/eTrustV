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

function ValidRequiredField(){
    var valid = true;
    var message = "";
    var cmbTypeVal = $("#cmbType :selected").val();
    
    
    if($("#cmbType option:selected").index() <= 0){
    	valid = false;
    	message += "* Please select a report type.\n";
    }else{
    	if(cmbTypeVal == '1' || cmbTypeVal == '2' || cmbTypeVal == '3' || cmbTypeVal == '4'){
    		if(($("#dpDateFr").val() == null || $("#dpDateFr").val().length == 0) && !($("#dpDateTo").val() == null || $("#dpDateTo").val().length == 0)){	
    			valid = false;
                message += "* Please key in the Order Date.\n";
    		}
    	}else if(cmbTypeVal == '5' || cmbTypeVal == '7'){
    		if($("#dpOrderMonth").val() == null || $("#dpOrderMonth").val().length == 0){
    			valid = false;
                message += "* Please select the order month.\n";
            }
    	}else if(cmbTypeVal == '6'){
    		if($("#dpDateFr").val() == null || $("#dpDateFr").val().length == 0){
    			valid = false;
                message += "* Please key in the Order Date.\n";
            }
    	}
    }

    if(valid == true){
        fn_report();
    }else{
    	alert(message);
    }
}


function fn_report(){
	
	var cmbTypeVal = $("#cmbType :selected").val();
	
	if(cmbTypeVal == "1" || cmbTypeVal == "2"){
		fn_report_1();
	}else if(cmbTypeVal == "3" || cmbTypeVal == "4"){
		fn_report_2();
	}else if(cmbTypeVal == "5" || cmbTypeVal == "6"){
		fn_report_3();
	}else if(cmbTypeVal == "7"){
		fn_report_4();
	}else if(cmbTypeVal == "8"){
		fn_report_5();
	}else if(cmbTypeVal == "9" || cmbTypeVal == "10" || cmbTypeVal == "11" || cmbTypeVal == "12" || cmbTypeVal == "13"){
		fn_report_6();
	}
}

function fn_report_1(){
	$("#reportFileName").val("");
	$("#reportDownFileName").val("");
	
	//.rpt파일들의 테이블들이 두개씩있는경우라서 ..
}

function fn_report_2(){ ///////////error
	
	$("#reportFileName").val("");
    $("#reportDownFileName").val("");
    
	$("#reportParameter").append('<input type="hidden" id="V_ORDERDATEFR" name="V_ORDERDATEFR" value="" />');
	$("#reportParameter").append('<input type="hidden" id="V_ORDERDATETO" name="V_ORDERDATETO" value="" />');
	$("#reportParameter").append('<input type="hidden" id="V_WHERESQL" name="V_WHERESQL" value="" />');
	
	

//    alert($("#V_ORDERDATEFR").val());
 //   alert($("#V_ORDERDATETO").val());
//    alert($("#V_WHERESQL").val());

    
	
	
	var orderDateFrom = "";
	var orderDateTo = "";
	var whereSQL = "";
	$("#V_ORDERDATEFR").val("");
    $("#V_ORDERDATETO").val("");
    $("#V_WHERESQL").val("");
    
	
	var date = new Date().getDate();
    if(date.toString().length == 1){
        date = "0" + date;
    }
	
    
    var fromDt = $("#dpDateFr").val();
    var toDt = $("#dpDateTo").val();
    
    whereSQL += " AND som.SALES_DT >= TO_DATE("+fromDt+" || '00:00:00', 'dd/MM/YYYY HH24:MI:SS')";
    whereSQL += " AND som.SALES_DT <= TO_DATE("+toDt+" || '23:59:59', 'dd/MM/YYYY HH24:MI:SS')";
    
//	if(!($("#dpDateFr").val() == null || $("#dpDateFr").val().length == 0)){	
	//	orderDateFrom = $("#dpDateFr").val();

	
	//yyyy-mm-dd hh:mm:ss
   
	
	//    orderDateFrom = $("#dpDateFr").val().substring(6, 10)+"-"+$("#dpDateFr").val().substring(3, 5)+"-"+$("#dpDateFr").val().substring(0, 2)+" 00:00:00";
		//whereSQL += " AND som.SALES_DT >= TO_DATE('"+$("#dpDateFr").val()+"', 'dd/MM/yyyy')";
	//   alert(typeof orderDateFrom);
	//	whereSQL += " AND som.SALES_DT >= TO_DATE("+fromDt+" || '00:00:00', 'dd/MM/YYYY HH24:MI:SS')";
//	}
//	if(!($("#dpDateTo").val() == null || $("#dpDateTo").val().length == 0)){
	//	orderDateTo = $("#dpDateTo").val();
    //   orderDateTo = $("#dpDateTo").val().substring(6, 10)+"-"+$("#dpDateTo").val().substring(3, 5)+"-"+$("#dpDateTo").val().substring(0, 2)+" 00:00:00";
	//	whereSQL += " AND som.SALES_DT <= TO_DATE('"+$("#dpDateTo").val()+"', 'dd/MM/yyyy')";
	//	whereSQL += " AND som.SALES_DT <= TO_DATE("++" || '23:59:59', 'dd/MM/YYYY HH24:MI:SS')";
//	}
	if($("#cmbType :selected").val() == "3"){
		$("#reportDownFileName").val("CCPDailyProductivity_"+date+(new Date().getMonth()+1)+new Date().getFullYear());
		$("#reportFileName").val("/sales/CCPSummary_CcpAdminProductivity.rpt");
	}else if($("#cmbType :selected").val() == "4"){
		$("#reportDownFileName").val("CCPSummary_ByRegion_"+date+(new Date().getMonth()+1)+new Date().getFullYear());
		$("#reportFileName").val("/sales/CCPSummary_ByRegion.rpt");
	}
	
	$("#V_ORDERDATEFR").val(fromDt);
	$("#V_ORDERDATETO").val(toDt);
	$("#V_WHERESQL").val(whereSQL);


	// 프로시져로 구성된 경우 꼭 아래 option을 넘겨야 함.
    var option = {
        isProcedure : true // procedure 로 구성된 리포트 인경우 필수.  => /payment/PaymentListing_Excel.rpt 는 프로시져로 구성된 파일임.
    };

	//alert($("#V_ORDERDATEFR").val());
	//alert($("#V_ORDERDATETO").val());
	//alert($("#V_WHERESQL").val());
    var date1 = new Date('2017-11-11');//yyyy/mm/dd
    var date2 = new Date('2017-11-13');
    console.log("date1 : " + date1);
	$("#V_ORDERDATEFR").val(date1);
	$("#V_ORDERDATETO").val(date2);
    Common.report("form", option);
}


function fn_report_3(){  //=> hidden들
	
	$("#reportFileName").val("");
    $("#reportDownFileName").val("");
	
	$("#reportParameter").append('<input type="hidden" id="V_PASSDATE" name="V_PASSDATE" value="" />');
    //YYYY-MM-DD"형식으로 

    var date = new Date().getDate();
    if(date.toString().length == 1){
        date = "0" + date;
    }
    
	if($("#cmbType :selected").val() == "5"){
	//	$("#V_PASSDATE").val($("#dpOrderMonth").val()); => 수정 필요
        $("#reportDownFileName").val("CCPSummary_ByNationwide_"+date+(new Date().getMonth()+1)+new Date().getFullYear());
        $("#reportFileName").val("/sales/CCPSummary_ByNationwide.rpt");
    }else if($("#cmbType :selected").val() == "6"){
    //	$("#V_PASSDATE").val($("#dpDateFr").val()); => 수정 필요
        $("#reportDownFileName").val("CCPSummary_ByKeyInTime_"+date+(new Date().getMonth()+1)+new Date().getFullYear());
        $("#reportFileName").val("/sales/CCPSummary_ByDayTime.rpt");
    }
    
    
	// 프로시져로 구성된 경우 꼭 아래 option을 넘겨야 함.
    var option = {
        isProcedure : true // procedure 로 구성된 리포트 인경우 필수.  => /payment/PaymentListing_Excel.rpt 는 프로시져로 구성된 파일임.
    };

    Common.report("form", option);
}


function fn_report_4(){ //완성
	
	$("#reportFileName").val("");
    $("#reportDownFileName").val("");
    
    $("#reportParameter").append('<input type="hidden" id="V_PASSDATE" name="V_PASSDATE" value="" />');

    var date = new Date().getDate();
    if(date.toString().length == 1){
        date = "0" + date;
    }

    var passDate = $("#dpOrderMonth").val();
    passDate = passDate.substring(3, 7)+"-"+passDate.substring(0,2)+"-01";

    $("#V_PASSDATE").val(passDate);
    $("#reportDownFileName").val("CCPSummary_ByStandardRemark_"+date+(new Date().getMonth()+1)+new Date().getFullYear());
    $("#reportFileName").val("/sales/CCPSummary_ByStandardRemark.rpt");
    
    // 프로시져로 구성된 경우 꼭 아래 option을 넘겨야 함.
    var option = {
        isProcedure : true // procedure 로 구성된 리포트 인경우 필수.  => /payment/PaymentListing_Excel.rpt 는 프로시져로 구성된 파일임.
    };

    Common.report("form", option);
	
	
}

</script>


<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>CCP Listing</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<aside class="title_line"><!-- title_line start -->

</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id="form">
<!-- report1 -->
<input type="hidden">


<!-- report2 -->


<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:130px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Report Type</th>
    <td>
    <select class="" id="cmbType">
        <option value="" hidden>Report/Raw Data Type</option>
        <option value="" style="background-color: DarkGray; font-color:black; font-weight:bold" disabled>CCP Performance Report</option>
        <option value="1">By Key-In Branch</option>
        <option value="2">By Service Branch</option>
        <option value="7">Monthly CCP Status Report (By Standard Remark)</option>
        <option value="" style="background-color: DarkGray; font-color:black; font-weight:bold" disabled>CCP Summary Report</option>
        <option value="3">CCP Daily Productivity Report</option>
        <option value="4" hidden>Daily Summary By Region</option>
        <option value="5" hidden>Daily Summary Nationwide</option>
        <option value="6" hidden>Daily Summary By Key-In Time</option>
        <option value="8">3 Days Summary Report</option>
        <option value="9">CCP Turn Around Time</option>
        <option value="10">Daily Rental Sales Summary</option>
        <option value="11">CCP Scoring Performance</option>
        <option value="12">Active Installation Status</option>
        <option value="13">Monthly CCP Active by DSC</option>
    </select>
    </td>
</tr>
<tr>
    <th scope="row">Order Date</th>
    <td>
    <div class="date_set"><!-- date_set start -->
    <p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" id="dpDateFr"/></p>
    <span>To</span>
    <p><input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" id="dpDateTo"/></p>
    </div><!-- date_set end -->
    </td>
</tr>
<tr>
    <th scope="row">Order Month</th>
    <td><input type="text" title="Create end Date" placeholder="MM/YYYY" class="j_date2" id="dpOrderMonth"/></td>
</tr>
</tbody>
</table><!-- table end -->

<ul class="right_btns">
    <li><p class="btn_blue"><a href="javascript:void(0);" onclick="javascript: ValidRequiredField();">Generate</a></p></li>
    <li><p class="btn_blue"><a href="#" onclick="javascript:$('#form').clearForm();"><span class="clear"></span>Clear</a></p></li>
</ul>


<input type="hidden" id="reportFileName" name="reportFileName" value="" />
<input type="hidden" id="viewType" name="viewType" value="PDF" />
<input type="hidden" id="reportDownFileName" name="reportDownFileName" value="" />

<div id="reportParameter"></div>

</form>

</section><!-- content end -->
     
</section><!-- container end -->

</div><!-- popup_wrap end -->