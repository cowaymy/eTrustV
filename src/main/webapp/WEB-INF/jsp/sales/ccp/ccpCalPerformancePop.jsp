<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">

$(document).ready(function() {

	$("#_rptType").change(function() {
		  
		//1. Init     
		$("#_dateFr").val('');
		$("#_dateTo").val('');
		$("#_dateMonth").val('');
		
		$("#_dateFr").attr("disabled" , "disabled");
        $("#_dateTo").attr("disabled" , "disabled");
        $("#_dateMonth").attr("disabled" , "disabled");
        
        
        //2. Chage Setting
        if(this.value == "1"){
        	$("#_dateFr").attr("disabled" , false);
        	$("#_dateTo").attr("disabled" , false);
        	
        	$("#_dateFr").val('${toDay}');
            $("#_dateTo").val('${toDay}');
        }
        if(this.value == "2"){
        	$("#_dateFr").attr("disabled" , false);
            $("#_dateTo").attr("disabled" , false);
            
            $("#_dateFr").val('${toDay}');
            $("#_dateTo").val('${toDay}');
        }
        if(this.value == "3"){
        	$("#_dateFr").attr("disabled" , false);
            $("#_dateTo").attr("disabled" , false);
            
            $("#_dateFr").val('${toDay}');
            $("#_dateTo").val('${toDay}');
        }
        if(this.value == "4" || this.value == "12"){
        	$("#_dateFr").attr("disabled" , false);
            $("#_dateTo").attr("disabled" , false);
            
            $("#_dateFr").val('${toDay}');
            $("#_dateTo").val('${toDay}');
        }
        if(this.value == "5"){
        	$("#_dateMonth").attr("disabled" , false);
        	$("#_dateMonth").val('${toMonth}');
        }
        if(this.value == "6"){
        	$("#_dateFr").attr("disabled" , "");
        	$("#_dateFr").val('${toDay}');
        }
        if(this.value == "7"){
        	$("#_dateMonth").attr("disabled" , false);
            $("#_dateMonth").val('${toMonth}');
        }
        if(this.value == "8" || this.value == "9" || this.value == "10" || this.value == "11" || this.value == "13"){
        	$("#_dateTo").attr("disabled" , false);
        	$("#_dateTo").val('${toDay}');
        }
	});
	
	
	//DownLoad
	$("#_genRtpBtn").click(function() {
		
		var rptType = $("#_rptType").val();
		var sDate = $("#_dateFr").val();
		var eDate = $("#_dateTo").val();
		var month = $("#_dateMonth").val();
		
		//1.Validation
		
		//Null Check
		if( null == rptType || '' == rptType){
			Common.alert("* Please select a report type.<br />");
			return;
		}
		//Date Check
		if(rptType == '1' || rptType == '2'  || rptType == '3'  || rptType == '4' ){
			if(null == sDate || '' == sDate || null == eDate || '' == eDate){
				Common.alert("* Please key in the Order Date.<br />");
				return;
			}
		}
		
		if(rptType == '5' || rptType == '7' ){
			
			if(null == month || '' == month){
				Common.alert("* Please select the order month.<br />");
				return;
			}
		}
		
		if(rptType == '6'){
			if(null == sDate || '' == sDate){
				Common.alert("* Please key in the Order Date.<br />");
				return;
			} 
		}
		
		//2. Validation Pass and DownLoad
		
		 if(rptType == "1" || rptType == "2"){
			 //Rtp Path
			 $("#reportFileName").val("/sales/CCPPerformanceReportByBranch_PDF.rpt"); 
			 //View Type
			 $("#viewType").val("PDF");
			 //Rtp Title
			 $("#reportDownFileName").val("CCPPerformance_KeyInBranch_" + $("#_currDate").val());
			 
			 //Parameter
			 $("#_vOrderDateFrom").val(sDate);
			 $("#_vOrderDateTo").val(sDate);
			 $("#_vOrderBrnchRegion").val('-');
			 $("#_vOrderSelectSql").val('');
			 
			 var whereSql = "";
			 whereSql += " AND som.SALES_DT  >=  TO_DATE('"+sDate +"' || '00:00:00' , 'DD-MM-YYYY HH24:MI:SS')";
			 whereSql += " AND som.SALES_DT  <=  TO_DATE('"+eDate+"'  || '23:59:59' , 'DD-MM-YYYY HH24:MI:SS')";
			 $("#_vOrderWhereSql").val(whereSql);
			 
			 $("#_vOrderRegionWhereSql").val('');
			 $("#_vOrderBySql").val('');
			 $("#_vOrderFullSql").val('');
			 
			 //Gen Rpt
			 fn_report();
			 
		 }
         if(rptType == "3" || rptType == "4"){
        	 this.DoPrintDocument2(li);
         }
         if (rptType == "5" || rptType == "6"){
        	 this.DoPrintDocument3(li);
         }
         if (rptType == "7"){
        	 this.DoPrintDocument4(li);
         }
         if (rptType== "8"){
        	 this.DoPrintDocument5(li);
         }
         if (rptType == "9" || rptType == "10" || rptType == "11" || rptType == "12" || rptType == "13"){
        	 this.DoPrintDocument6(li);
         }
		
	});
	
	
	
	
	
	function fn_report() {
        var option = {
            isProcedure : true 
        };
        Common.report("dataForm", option);
    }
});//Doc Ready Func End

</script>

<div id="popup_wrap"><!-- popup_wrap start -->
<header class="pop_header"><!-- pop_header start -->
<h1>CCP Performance Report</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a id="_btnClose">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->
<!-- Curr Date -->
<input type="hidden" value="${toDay}" id="_currDate">
<input type="hidden" value="${toMonth}" id="_currMonth">

<form id="dataForm">
    <!-- Required Field -->
    <input type="hidden" id="reportFileName" name="reportFileName" /><!-- Report Name  -->
    <input type="hidden" id="viewType" name="viewType" /><!-- View Type  -->
    <input type="hidden" id="reportDownFileName" name="reportDownFileName" /><!-- TItle --> 
    
    <!-- params -->
    <input type="hidden" id="_vOrderDateFrom" name="V_ORDERDATEFROM" />
    <input type="hidden" id="_vOrderDateTo" name="V_ORDERDATETO"/>
    <input type="hidden" id="_vOrderBrnchRegion" name="V_BRANCHREGION"/>
    <input type="hidden" id="_vOrderSelectSql" name="V_SELECTSQL"/> 
    <input type="hidden" id="_vOrderWhereSql" name="V_WHERESQL">
    <input type="hidden" id="_vOrderRegionWhereSql" name="V_REGIONWHERESQL">
    <input type="hidden" id="_vOrderBySql" name="V_ORDERBYSQL">
    <input type="hidden" id="_vOrderFullSql" name="V_FULLSQL"> 
</form>

<ul class="right_btns">
    <li><p class="btn_blue"><a id="_genRtpBtn">Generate</a></p></li>
    <li><p class="btn_blue"><a href="#"><span class="clear"></span>Clear</a></p></li>
</ul>

<section class="search_table"><!-- search_table start -->
<form action="#" method="post">

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
    <select class="w100p" id="_rptType">
    <optgroup label="CCP Performance Report">
        <option value="1" selected="selected">By Key-In Branch</option>
        <option value="2">By Service Branch</option>
        <option value="7">Monthly CCP Status Report (By Standard Remark)</option>
    </optgroup>
    
    <optgroup label="CCP Summary Report">
        <option value="3">CCP Daily Productivity Report</option>
        <option value="4" hidden="true">Daily Summary By Region</option>
        <option value="5" hidden="true">Daily Summary Nationwide</option>
        <option value="6" hidden="true">Daily Summary By Key-In Time</option>
        <option value="8">3 Days Summary Report</option>
        <option value="9" >CCP Turn Around Time</option>
        <option value="10" >Daily Rental Sales Summary</option>
        <option value="11" >CCP Scoring Performance</option>
        <option value="12" >Active Installation Status</option>
        <option value="13" >Monthly CCP Active by DSC</option>
    </optgroup>
    </select>
    </td>
</tr>
<tr>
    <th scope="row">Order Date</th>
    <td>
    <div class="date_set"><!-- date_set start -->
    <p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date"  id="_dateFr" value="${toDay}"/></p>  
    <span>To</span>
    <p><input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" id="_dateTo" value="${toDay}"/></p>
    </div><!-- date_set end -->
    </td>
</tr>
<tr>
    <th scope="row">Order Month</th>
    <td><input type="text" title="Create end Date" placeholder="MM/YYYY" class="j_date2"  id="_dateMonth" disabled="disabled" /></td>
</tr>
</tbody>
</table><!-- table end -->
</form>
</section><!-- search_table end -->
</section>
</div>