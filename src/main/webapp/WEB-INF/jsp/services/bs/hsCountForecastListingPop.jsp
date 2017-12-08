<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javaScript">
$(document).ready(function(){
	 $('.multy_select').on("change", function() {
		    //console.log($(this).val());
		}).multipleSelect({});
	 
	 //doGetCombo('/common/selectCodeList.do', '10', '','appliType', 'S' , ''); 
	 //doGetComboSepa("/common/selectBranchCodeList.do",5 , '-',''   , 'branch' , 'S', '');
	
	 doGetCombo('/services/bs/selectBranch_id', 42, '','brnch', 'S');

	 $("#brnch").change(function (){
	 doGetCombo('/services/bs/selectCTMByDSC_id',  $("#brnch").val(), '','memCode', 'S' ,  ''); 
	        });
	 
	 
});

function fn_validation(){
	 if($("#brnch option:selected").length < 1)
	    {
		    Common.alert("<spring:message code='sys.common.alert.validation' arguments='branch' htmlEscape='false'/>");
	        return false;
	    }
	 
	 if($("#memCode option:selected").length < 1)
     {
         Common.alert("<spring:message code='sys.common.alert.validation' arguments='CM Group' htmlEscape='false'/>");
         return false;
     }
	if($("#forecastMonth").val() == ''){
         Common.alert("<spring:message code='sys.common.alert.validation' arguments='the forecast month' htmlEscape='false'/>");
         return false;
    }
	
	 
	return true;
}
function fn_openReport(){
	if(fn_validation()){
		var date = new Date();
	    var installStatus = $("#instalStatus").val();
	    var SelectSql = "";
	    var whereSeq = "";
	    var orderBySql = "";
	    var FullSql = "";
	    var month = date.getMonth()+1;
	    var day =date.getDate();
        if(date.getDate() < 10){
            day = "0"+date.getDate();
        }
	    var tmpforecastMonth = $("#forecastMonth").val();
	    var forecastMonth =tmpforecastMonth.substring(3,7)+"-"+tmpforecastMonth.substring(0,2)+"-01";
	    var branchid = 0;
	    branchid = Number($("#brnch option:selected").val());
        var cmid = 0;
        cmid = Number($("#memCode option:selected").val());
	    $("#reportForm #viewType").val("PDF");
	    if(cmid==0){
        	$("#reportForm #reportFileName").val('/services/BSCountForecastByBranch.rpt');
        	$("#reportForm #reportDownFileName").val("BSCountForecastByBranch_"+day+month+date.getFullYear());
	    }else{
        	$("#reportForm #reportFileName").val('/services/BSCountForecastByCMGroup.rpt');
        	$("#reportForm #reportDownFileName").val("BSCountForecastByCMGroup_"+day+month+date.getFullYear());
	    }
	    /*
	     $("#installationNoteForm #V_WHERESQL").val(whereSeq);
	     $("#installationNoteForm #V_INSTALLSTATUS").val(installStatus);
	     $("#installationNoteForm #V_ORDERBYSQL").val(orderBySql);
	     $("#installationNoteForm #V_SELECTSQL").val(SelectSql);
	     $("#installationNoteForm #V_FULLSQL").val(FullSql);
	     */
	     //$("#installationNoteForm #reportFileName").val('/services/InstallationNote_WithOldOrderNo.rpt');
	     
	     $("#reportForm #V_FORECASTDATE").val(forecastMonth);
	     $("#reportForm #V_BRANCHID").val(branchid);
	     $("#reportForm #V_CMID").val(cmid);
	     
	     
	     //$("#reportForm #reportDownFileName").val("InstallationNote_"+date.getDate()+month+date.getFullYear());
	  
	   //report 호출
	     var option = {
	             isProcedure : true, // procedure 로 구성된 리포트 인경우 필수.
	     };
	     
	     Common.report("reportForm", option);
	}
	
}

function fn_clear(){
	
	$("#brnch").val('');
	$("#memCode").val('');
		
}

</script>
<div id="popup_wrap" class="popup_wrap size_mid"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>BS Management - BS Count Forecast Listing</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<section class="search_table"><!-- search_table start -->
<form action="#" id="reportForm">
<input type="hidden" id="V_FORECASTDATE" name="V_FORECASTDATE" />
<input type="hidden" id="V_BRANCHID" name="V_BRANCHID" />
<input type="hidden" id="V_CMID" name="V_CMID" />
<!--reportFileName,  viewType 모든 레포트 필수값 -->
<input type="hidden" id="reportFileName" name="reportFileName" />
<input type="hidden" id="viewType" name="viewType" />
<input type="hidden" id="reportDownFileName" name="reportDownFileName" value="DOWN_FILE_NAME" />

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:170px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Forecast Month</th>
    <td><input type="text" title="Forecast Month" id="forecastMonth" placeholder="MM/YYYY" class="j_date2 w100p" /></td>
</tr>
<tr>
    <th scope="row">Branch</th>
    <td>
    <select class="w100p" id = "brnch">
        
    </select>
    </td>
</tr>
<tr>
    <th scope="row">CM Group</th>
    <td>
    <select class="w100p" id = "memCode">
        
    </select>
    </td>
</tr>
<tr>
    <td colspan="2" class="col_all"><span class="red_text fl_right">Forecast is up to 4 months.</span></td>
</tr>
</tbody>
</table><!-- table end -->

<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#" onclick="javascript:fn_openReport()">Generate</a></p></li>
</ul>

</form>
</section><!-- search_table end -->

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->
