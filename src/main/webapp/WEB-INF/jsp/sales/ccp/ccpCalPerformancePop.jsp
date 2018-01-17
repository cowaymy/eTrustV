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
    
    
    if($("#cmbType option:selected").index() < 1){
    	valid = false;
    	message += "* Please select a report type.\n";
    }else{
    	if(cmbTypeVal == '1' || cmbTypeVal == '2' || cmbTypeVal == '3' || cmbTypeVal == '4'){
    		if(($("#dpDateFr").val() == null || $("#dpDateFr").val().length == 0) || ($("#dpDateTo").val() == null || $("#dpDateTo").val().length == 0)){	
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
    	}else if(cmbTypeVal == '8'){
            if($("#dpDateTo").val() == null || $("#dpDateTo").val().length == 0){
                valid = false;
                message += "* Please key in the Order Date.\n";
            }
        }else if(cmbTypeVal == "9" || cmbTypeVal == "10" || cmbTypeVal == "11" || cmbTypeVal == "12" || cmbTypeVal == "13"){
        	if(($("#dpDateFr").val() == null || $("#dpDateFr").val().length == 0) || ($("#dpDateTo").val() == null || $("#dpDateTo").val().length == 0)){   
                valid = false;
                message += "* Please key in the Order Date.\n";
            }
        	if($("#dpOrderMonth").val() == null || $("#dpOrderMonth").val().length == 0){
                valid = false;
                message += "* Please select the order month.\n";
            }
        }
    }

    if(valid == true){
        fn_report();
    }else{
    	Common.alert("CCP Generate Summary" + DEFAULT_DELIMITER + message);
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
	
	$("#reportParameter").append('<input type="hidden" id="V_ORDERDATEFROM" name="V_ORDERDATEFROM" value="" />');
    $("#reportParameter").append('<input type="hidden" id="V_ORDERDATETO" name="V_ORDERDATETO" value="" />'); 
    $("#reportParameter").append('<input type="hidden" id="V_BRANCHREGION" name="V_BRANCHREGION" value="" />');
    $("#reportParameter").append('<input type="hidden" id="V_SELECTSQL" name="V_SELECTSQL" value="" />');
    $("#reportParameter").append('<input type="hidden" id="V_WHERESQL" name="V_WHERESQL" value="" />'); 
    $("#reportParameter").append('<input type="hidden" id="V_REGIONWHERESQL" name="V_REGIONWHERESQL" value="" />');
    $("#reportParameter").append('<input type="hidden" id="V_ORDERBYSQL" name="V_ORDERBYSQL" value="" />');
    $("#reportParameter").append('<input type="hidden" id="V_FULLSQL" name="V_FULLSQL" value="" />'); 

    var date = new Date().getDate();
    if(date.toString().length == 1){
        date = "0" + date;
    }
    
    var dpDateFr = $("#dpDateFr").val();
    var dpDateTo = $("#dpDateTo").val();
    var frArr = dpDateFr.split("/");
    var toArr = dpDateTo.split("/");
    
    var orderDateFrom = frArr[1]+"/"+frArr[0]+"/"+frArr[2]; // MM/dd/yyyy
    var orderDateTo = toArr[1]+"/"+toArr[0]+"/"+toArr[2];
    var branchRegion = "-";
    var orderDateToSQL = "";
    var selectSQL = "";
    var whereSQL = "";
    var extraWhereSQL = "";
    var orderSQL = "";
    var fullSQL = "";
    
	if(!(dpDateFr == null || dpDateFr.length == 0) && !(dpDateTo == null || dpDateTo.length == 0)){
		
		orderDateFrom = frArr[0]+"/"+frArr[1]+"/"+frArr[2]; // dd/MM/yyyy
		orderDateTo = toArr[0]+"/"+toArr[1]+"/"+toArr[2];

		whereSQL += " AND (som.SALES_DT BETWEEN TO_DATE('"+$("#dpDateFr").val()+" 00:00:00', 'dd/MM/yyyy HH24:MI:SS') AND TO_DATE('"+$("#dpDateTo").val()+" 23:59:59', 'dd/MM/yyyy HH24:MI:SS'))";
    }
	
	if($("#cmbType :selected").val() == "1"){
		$("#reportDownFileName").val("CCPPerformance_KeyInBranch_"+date+(new Date().getMonth()+1)+new Date().getFullYear());
        $("#reportFileName").val("/sales/CCPPerformanceReportByBranch_PDF.rpt");
        
	}else if($("#cmbType :selected").val() == "2"){
		$("#reportDownFileName").val("CCPPerformance_ServiceBranch_"+date+(new Date().getMonth()+1)+new Date().getFullYear());
        $("#reportFileName").val("/sales/CCPPerformanceReportByServiceBranch.rpt");
        
	}
	
	$("#viewType").val("PDF");

	$("#V_ORDERDATEFROM").val(orderDateFrom);
    $("#V_ORDERDATETO").val(orderDateTo);
    $("#V_BRANCHREGION").val(branchRegion);
    $("#V_SELECTSQL").val("");
    $("#V_WHERESQL").val(whereSQL);
    $("#V_REGIONWHERESQL").val("");
    $("#V_ORDERBYSQL").val("");
    $("#V_FULLSQL").val("");
    
   
    // 프로시져로 구성된 경우 꼭 아래 option을 넘겨야 함.
    var option = {
            isProcedure : true // procedure 로 구성된 리포트 인경우 필수. 
    };
    
    Common.report("form", option);
    
}

function fn_report_2(){ 
	
	$("#reportFileName").val("");
    $("#reportDownFileName").val("");
    
	$("#reportParameter").append('<input type="hidden" id="V_ORDERDATEFR" name="V_ORDERDATEFR" value="" />');
	$("#reportParameter").append('<input type="hidden" id="V_ORDERDATETO" name="V_ORDERDATETO" value="" />'); 
	$("#reportParameter").append('<input type="hidden" id="V_WHERESQL" name="V_WHERESQL" value="" />');
	
	var whereSQL = "";
	
	var date = new Date().getDate();
    if(date.toString().length == 1){
        date = "0" + date;
    }
    
    var dpDateFr = $("#dpDateFr").val();
    var frArr = dpDateFr.split("/");
    var yyyy = frArr[2];
    var mm = frArr[1];
    var dd = frArr[0];
    dpDateFr = yyyy+"-"+mm+"-"+dd+" 00:00:00";
    var dpDateTo = $("#dpDateTo").val();
    var toArr = dpDateTo.split("/");
    dpDateTo = toArr[2]+"-"+toArr[1]+"-"+toArr[0]+" 00:00:00";
    
    // "yyyy-mm-dd hh:mm:ss" 형식
    if(!(dpDateFr == null || dpDateFr.length == 0)){
    	whereSQL += " AND som.SALES_DT >= TO_DATE('"+dpDateFr+"', 'yyyy-MM-DD HH24:MI:SS')";
    }
    if(!(dpDateTo == null || dpDateTo.length == 0)){
    	whereSQL += " AND som.SALES_DT <= TO_DATE('"+dpDateTo+"', 'yyyy-MM-DD HH24:MI:SS')";
    }
    if($("#cmbType :selected").val() == "3"){
    	$("#reportDownFileName").val("CCPDailyProductivity_"+date+(new Date().getMonth()+1)+new Date().getFullYear());
        $("#reportFileName").val("/sales/CCPSummary_CcpAdminProductivity.rpt");
        
    }else if($("#cmbType :selected").val() == "4"){
    	$("#reportDownFileName").val("CCPSummary_ByRegion_"+date+(new Date().getMonth()+1)+new Date().getFullYear());
        $("#reportFileName").val("/sales/CCPSummary_ByRegion.rpt");
        
    }
    
    $("#viewType").val("PDF");

    $("#V_ORDERDATEFR").val(dpDateFr);
    $("#V_ORDERDATETO").val(dpDateTo);
    $("#V_WHERESQL").val(whereSQL);
	
   
	// 프로시져로 구성된 경우 꼭 아래 option을 넘겨야 함.
	var option = {
	        isProcedure : true // procedure 로 구성된 리포트 인경우 필수.
	};
	
    Common.report("form", option);
}


function fn_report_3(){  
	
	$("#reportFileName").val("");
    $("#reportDownFileName").val("");
	
	$("#reportParameter").append('<input type="hidden" id="V_PASSDATE" name="V_PASSDATE" value="" />');
    //YYYY-MM-DD"형식 
    var passDate = "";
    
    var date = new Date().getDate();
    if(date.toString().length == 1){
        date = "0" + date;
    }
    
	if($("#cmbType :selected").val() == "5"){
	   
	    passDate = $("#dpOrderMonth").val();
	    passDate = passDate.substring(3, 7)+"-"+passDate.substring(0,2)+"-01";
	
        $("#reportDownFileName").val("CCPSummary_ByNationwide_"+date+(new Date().getMonth()+1)+new Date().getFullYear());
        $("#reportFileName").val("/sales/CCPSummary_ByNationwide.rpt");
    }else if($("#cmbType :selected").val() == "6"){
        
        passDate = $("#dpDateFr").val();
        passDate = passDate.substring(6,10)+"-"+passDate.substring(3,5)+"-"+passDate.substring(0,2);
    
        $("#reportDownFileName").val("CCPSummary_ByKeyInTime_"+date+(new Date().getMonth()+1)+new Date().getFullYear());
        $("#reportFileName").val("/sales/CCPSummary_ByDayTime.rpt");
    }
    
	$("#viewType").val("PDF");
	
	$("#V_PASSDATE").val(passDate);
	
	// 프로시져로 구성된 경우 꼭 아래 option을 넘겨야 함.
    var option = {
        isProcedure : true // procedure 로 구성된 리포트 인경우 필수. 
    };

    Common.report("form", option);
}


function fn_report_4(){ 
	
	$("#reportFileName").val("");
    $("#reportDownFileName").val("");
    var passDate = "";
    
    $("#reportParameter").append('<input type="hidden" id="V_PASSDATE" name="V_PASSDATE" value="" />');

    var date = new Date().getDate();
    if(date.toString().length == 1){
        date = "0" + date;
    }

    passDate = $("#dpOrderMonth").val();
    passDate = passDate.substring(3, 7)+"-"+passDate.substring(0,2)+"-01";

    $("#viewType").val("PDF");

    $("#V_PASSDATE").val(passDate);
    $("#reportDownFileName").val("CCPSummary_ByStandardRemark_"+date+(new Date().getMonth()+1)+new Date().getFullYear());
    $("#reportFileName").val("/sales/CCPSummary_ByStandardRemark.rpt");
    
    
    // 프로시져로 구성된 경우 꼭 아래 option을 넘겨야 함.
    var option = {
        isProcedure : true // procedure 로 구성된 리포트 인경우 필수.
    };

    Common.report("form", option);
	
	
}

function fn_report_5(){ 
	
	$("#reportFileName").val("");
    $("#reportDownFileName").val("");
    var passDate = "";
    
    $("#reportParameter").append('<input type="hidden" id="V_PASSDATE" name="V_PASSDATE" value="" />');
    
    passDate = $("#dpDateTo").val();
    passDate = passDate.substring(6,10)+"-"+passDate.substring(3,5)+"-"+passDate.substring(0,2);

    var date = new Date().getDate();
    if(date.toString().length == 1){
        date = "0" + date;
    }
    $("#viewType").val("PDF");
    
    $("#V_PASSDATE").val(passDate);
    $("#reportDownFileName").val("CCP3_Days_Summary_"+date+(new Date().getMonth()+1)+new Date().getFullYear());
    $("#reportFileName").val("/sales/RptCCPCurrentStatus.rpt");
	
	// 프로시져로 구성된 경우 꼭 아래 option을 넘겨야 함.
    var option = {
        isProcedure : true // procedure 로 구성된 리포트 인경우 필수
    };

    Common.report("form", option);
    
}

function fn_report_6(){ 
	
	$("#reportFileName").val("");
    $("#reportDownFileName").val("");
    
    var dpDateTo = $("#dpDateTo").val();
    var cmbTypeVal = $("#cmbType :selected").val();
    
    var month = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    var strdate = dpDateTo.substring(6,10)+"-"+month[parseInt(dpDateTo.substring(3,5))-1]+"-"+dpDateTo.substring(0,2);
	var date1 = dpDateTo.substring(6,10)+"-"+dpDateTo.substring(3,5)+"-"+dpDateTo.substring(0,2);

	var date = new Date().getDate();
    if(date.toString().length == 1){
        date = "0" + date;
    }
	
	if(cmbTypeVal == "9"){
		
		$("#reportParameter").append('<input type="hidden" id="V_INPUTDATE" name="V_INPUTDATE" value="" />');
		$("#reportParameter").append('<input type="hidden" id="V_DATESTRING" name="V_DATESTRING" value="" />');

		$("#V_INPUTDATE").val(date1);
		$("#V_DATESTRING").val(strdate);
		
		$("#reportDownFileName").val("CCP_Turn_Around_Time_"+date+(new Date().getMonth()+1)+new Date().getFullYear());
	    $("#reportFileName").val("/sales/RptCCPPerformance_ByHours.rpt");
		
	}else if(cmbTypeVal == "10"){
		
		$("#reportParameter").append('<input type="hidden" id="V_INPUTDATE" name="V_INPUTDATE" value="" />');
        $("#reportParameter").append('<input type="hidden" id="V_DATESTRING" name="V_DATESTRING" value="" />');
        
        $("#V_INPUTDATE").val(date1);
        $("#V_DATESTRING").val(strdate);
		
		$("#reportDownFileName").val("CCP_DailyRentalSales_Summary_"+date+(new Date().getMonth()+1)+new Date().getFullYear());
	    $("#reportFileName").val("/sales/RptCCPSummary_ByMonth.rpt");
		
	}else if(cmbTypeVal == "11"){
        
		$("#reportParameter").append('<input type="hidden" id="V_INPUTDATE" name="V_INPUTDATE" value="" />');
        $("#reportParameter").append('<input type="hidden" id="V_DATESTRING" name="V_DATESTRING" value="" />');

        $("#V_INPUTDATE").val(date1);
        $("#V_DATESTRING").val(strdate);
		
		$("#reportDownFileName").val("CCP_ScoringPerformance_"+date+(new Date().getMonth()+1)+new Date().getFullYear());
	    $("#reportFileName").val("/sales/RptCCPSummary_ByDay.rpt");
		
    }else if(cmbTypeVal == "12"){ 
        
    	var dpDateFr = $("#dpDateFr").val();
    	var strdate2 = dpDateFr.substring(6,10)+"-"+month[parseInt(dpDateFr.substring(3,5))-1]+"-"+dpDateFr.substring(0,2);
    	var date2 = dpDateFr.substring(6,10)+"-"+dpDateFr.substring(3,5)+"-"+dpDateFr.substring(0,2);
    	
    	$("#reportParameter").append('<input type="hidden" id="V_ORDERDATEFROMSQL" name="V_ORDERDATEFROMSQL" value="" />');
        $("#reportParameter").append('<input type="hidden" id="V_ORDERDATETOSQL" name="V_ORDERDATETOSQL" value="" />');
        $("#reportParameter").append('<input type="hidden" id="V_STRFROMDATE" name="V_STRFROMDATE" value="" />');
        $("#reportParameter").append('<input type="hidden" id="V_STRTODATE" name="V_STRTODATE" value="" />');

        $("#V_ORDERDATEFROMSQL").val(date2);
        $("#V_ORDERDATETOSQL").val(date1);
        $("#V_STRFROMDATE").val(strdate2);
        $("#V_STRTODATE").val(strdate);
    	
    	$("#reportDownFileName").val("CCP_Active_Installation_Status_"+date+(new Date().getMonth()+1)+new Date().getFullYear());
        $("#reportFileName").val("/sales/RptCCPDSCAchiveStatus_ByProduct.rpt");
    	
    }else if(cmbTypeVal == "13"){
        
    	$("#reportParameter").append('<input type="hidden" id="V_INPUTDATE" name="V_INPUTDATE" value="" />');
        $("#reportParameter").append('<input type="hidden" id="V_DATESTRING" name="V_DATESTRING" value="" />');

        $("#V_INPUTDATE").val(date1);
        $("#V_DATESTRING").val(strdate);
    	
    	$("#reportDownFileName").val("Monthly_CCP_Active_by_DSC_"+date+(new Date().getMonth()+1)+new Date().getFullYear());
        $("#reportFileName").val("/sales/RptCCPDSCDailyUpdate.rpt");
    	
    }
	
	$("#viewType").val("PDF");
	
	// 프로시져로 구성된 경우 꼭 아래 option을 넘겨야 함.
    var option = {
        isProcedure : true // procedure 로 구성된 리포트 인경우 필수
    };

    Common.report("form", option);
    
	
}

</script>


<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>CCP Performance</h1>
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
    <col style="width:130px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Report Type</th>
    <td>
    <select class="" id="cmbType">
        <option data-placeholder="true" hidden>Report/Raw Data Type</option>
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