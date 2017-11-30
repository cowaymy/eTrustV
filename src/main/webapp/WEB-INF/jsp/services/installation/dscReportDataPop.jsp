<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javaScript">
$(document).ready(function(){
    $('.multy_select').on("change", function() {
        //console.log($(this).val());
    }).multipleSelect({});
});

function fn_validation(){
	if($("#reportType").val() == '1' || $("#reportType").val() == '3' || $("#reportType").val() == '4'){
		
		
        if($("#dateStr").val() == '' || $("#dateEnd").val() == ''){
                Common.alert("<spring:message code='sys.common.alert.validation' arguments='date (From & To)' htmlEscape='false'/>");
                return false;
            }
		
		
		/* if($("#dateStr").val() != '' || $("#dateEnd").val() != ''){
	        if($("#dateStr").val() == '' || $("#dateEnd").val() == ''){
	            Common.alert("<spring:message code='sys.common.alert.validation' arguments='date (From & To)' htmlEscape='false'/>");
	            return false;
	        }
	    } */
	}
	else if($("#reportType").val() == '2' || $("#reportType").val() == '5'  ){
		if($("#yearMonth").val() == '' ){
			Common.alert("<spring:message code='sys.common.alert.validation' arguments='date' htmlEscape='false'/>");
            return false;
		}
	}
	return true;
}

function fn_openReport(){
	if(fn_validation()){
		var date = new Date();
        var month = date.getMonth()+1;
		 if($("#reportType").val() == '1' ){
			var startDate = "";
			var endDate="";
			if($("#dateStr").val() != '' || $("#dateEnd").val() != ''){
				
				var s_year = $("#dateStr").val().substring(6,10);
		        var s_month= $("#dateStr").val().substring(3,5);
		        var s_day = $("#dateStr").val().substring(0,2);
		        
		        var v_year = $("#dateEnd").val().substring(6,10);
		        var v_month= $("#dateEnd").val().substring(3,5);
		        var v_day = $("#dateEnd").val().substring(0,2);
		        
		        
				startDate = s_year + "-" + s_month + "-" + s_day;
				endDate =  v_year + "-" + v_month + "-" + v_day;
			
			 $("#reportForm").append('<input type="hidden" id="v_startdate" name="v_startdate" value="" /> ');
			 $("#reportForm").append('<input type="hidden" id="v_enddate" name="v_enddate" value="" /> ');
			 
			 $("#reportForm #v_startdate").val(startDate);
			 $("#reportForm #v_enddate").val(endDate);
			 $("#reportForm #reportFileName").val('/services/DSCNetSalesReportD_1_PDF.rpt');
		     $("#reportForm #viewType").val("PDF");
		     $("#reportForm #reportDownFileName").val("DSCReportD1_" +date.getDate()+month+date.getFullYear());
		        
			 Common.report("reportForm");
			}
		}
		
		else if($("#reportType").val() == '2' ){
            var month = $("#yearMonth").val().substring(0,2);
            var  year= $("#yearMonth").val().substring(3,7);
			
            $("#reportForm").append('<input type="hidden" id="PVMonth" name="PVMonth" value="" /> ');
            $("#reportForm").append('<input type="hidden" id="PVYear" name="PVYear" value="" /> ');
            
			 $("#reportForm #PVMonth").val(month);
             $("#reportForm #PVYear").val(year);
             $("#reportForm #reportFileName").val('/services/DSCNetSalesReportD_5_PDF.rpt');
             $("#reportForm #viewType").val("PDF");
             $("#reportForm #reportDownFileName").val("DSCReportD5_" +date.getDate()+month+date.getFullYear());

             Common.report("reportForm");
		}
		
		else if($("#reportType").val() == '3' ){
            var strDt = "";
            var endDt="";
            if($("#dateStr").val() != '' || $("#dateEnd").val() != ''){
            	var s_year = $("#dateStr").val().substring(6,10);
                var s_month= $("#dateStr").val().substring(3,5);
                var s_day = $("#dateStr").val().substring(0,2);
                
                var v_year = $("#dateEnd").val().substring(6,10);
                var v_month= $("#dateEnd").val().substring(3,5);
                var v_day = $("#dateEnd").val().substring(0,2);
                
                
                strDt = s_year + "-" + s_month + "-" + s_day;
                endDt =  v_year + "-" + v_month + "-" + v_day;
                
            
            $("#reportForm").append('<input type="hidden" id="StartDate" name="StartDate" value="" /> ');
            $("#reportForm").append('<input type="hidden" id="EndDate" name="EndDate" value="" /> ');
            
             $("#reportForm #StartDate").val(strDt);
             $("#reportForm #EndDate").val(endDt);
             $("#reportForm #reportFileName").val('/services/DSCPerformanceReport_PDF.rpt');
              $("#reportForm #viewType").val("PDF");
                $("#reportForm #reportDownFileName").val("DSCPerfomamnceReport_" +date.getDate()+month+date.getFullYear());
            
             
             Common.report("reportForm");
            }
        }
	}
}

function fn_openExcel(){
	if(fn_validation()){
        var date = new Date();
        var month = date.getMonth()+1;
        
        if($("#reportType").val() == '2' ){
            var month = $("#yearMonth").val().substring(0,2);
            var  year= $("#yearMonth").val().substring(3,7);
            
            $("#reportForm").append('<input type="hidden" id="PVMonth" name="PVMonth" value="" /> ');
            $("#reportForm").append('<input type="hidden" id="PVYear" name="PVYear" value="" /> ');
            
             $("#reportForm #PVMonth").val(month);
             $("#reportForm #PVYear").val(year);               
             $("#reportForm #reportFileName").val('/services/DSCNetSalesReportD_5_PDF.rpt');
             $("#reportForm #viewType").val("PDF");
             $("#reportForm #reportDownFileName").val("DSCReportD5_" +date.getDate()+month+date.getFullYear());
             
         
          
          Common.report("reportForm");
        }
        
        else if($("#reportType").val() == '5' ){
        	var month = $("#yearMonth").val().substring(0,2);
            var  year= $("#yearMonth").val().substring(3,7);
            
             $("#reportForm").append('<input type="hidden" id="PVMonth" name="PVMonth" value="" /> ');
             $("#reportForm").append('<input type="hidden" id="PVYear" name="PVYear" value="" /> ');
             
             $("#reportForm #PVMonth").val(month);
             $("#reportForm #PVYear").val(year);               
             $("#reportForm #reportFileName").val('/services/DSCNetSalesReportD_5_ByStock.rpt');
             $("#reportForm #viewType").val("PDF");
             $("#reportForm #reportDownFileName").val("DSCReportD5ByStock_" +date.getDate()+month+date.getFullYear());
             
             Common.report("reportForm");
        }
    }
}

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
            this.selectedIndex = -1;
        }
        $("#reportType").val('1');
        $("#dateStr").val('');
        $("#dateEnd").val('');
        $("#yearMonth").val('');
    });
};
</script>
<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>DSC Report Data</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id="reportForm">
<input type="hidden" id="reportFileName" name="reportFileName" />
<input type="hidden" id="viewType" name="viewType" />
<input type="hidden" id="reportDownFileName" name="reportDownFileName" value="DOWN_FILE_NAME" />
</form>
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Report Type</th>
    <td>
    <select id="reportType" name="reportType">
        <option value="1">DSC Report D+1</option>
        <option value="2">DSC Report D+5</option>
        <option value="3">DSC Performance Report</option>
        <option value="5">DSC Report D+5 (By Stock)</option>
    </select>
    </td>
</tr>
<tr>
    <th scope="row">Date</th>
    <td>

    <div class="date_set"><!-- date_set start -->
    <p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" id="dateStr" name="dateStr"/></p>
    <span>To</span>
    <p><input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" id="dateEnd" name="dateEnd"/></p>
    </div><!-- date_set end -->

    </td>
</tr>
<tr>
    <th scope="row">PV Month & PV Year</th>
    <td>
    <input type="text" title="기준년월" class="j_date2" id="yearMonth" name="yearMonth"/>
    </td>
</tr>
</tbody>
</table><!-- table end -->

<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#" onclick="javascript:fn_openReport()">Generate PDF</a></p></li>
    <li><p class="btn_blue2 big"><a href="#" onclick="javascript:fn_openExcel()">Generate EXCEL</a></p></li>
    <li><p class="btn_blue2 big"><a href="#" onclick="javascript:$('#reportForm').clearForm();">Clear</a></p></li>
</ul>


</section><!-- search_table end -->

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->
