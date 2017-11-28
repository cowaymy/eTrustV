<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javaScript">
$(document).ready(function(){
	 $('.multy_select').on("change", function() {
		    //console.log($(this).val());
		}).multipleSelect({});
	 
	 //doGetCombo('/common/selectCodeList.do', '10', '','appliType', 'S' , ''); 
	 //doGetComboSepa("/common/selectBranchCodeList.do",5 , '-',''   , 'branch' , 'S', '');
	
	 doGetCombo('/services/mileageCileage/selectBranch', 42, '','brnch', 'S');

	 $("#brnch").change(function (){
	 doGetCombo('/services/serviceGroup/selectCTMByDSC',  $("#brnch").val(), '','memCode', 'S' ,  ''); 
	        });
	 
	 
});

function fn_validation(){
	 if($("#brnch option:selected").length < 1)
	    {
		    Common.alert("<spring:message code='sys.common.alert.validation' arguments='branch' htmlEscape='false'/>");
	        return false;
	    }
	 
	 if($("#cmdCdManager option:selected").length < 1)
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
	    
	    var forecastMonth = $("#forecastMonth").val();
	    var branchid = $("#brnch option:selected").val();
	    var cmid = $("#cmdCdManager option:selected").val();
	    alert(forecastMonth+","+branchid+","+cmid);
	    if(cmid==0){
        	$("#reportForm #reportFileName").val('/services/BSCountForecastByBranch.rpt');
        	$("#reportForm #reportDownFileName").val("BSCountForecastByBranch_"+date.getDate()+month+date.getFullYear());
	    }else{
        	$("#reportForm #reportFileName").val('/services/BSCountForecastByCMGroup.rpt');
        	$("#reportForm #reportDownFileName").val("BSCountForecastByCMGroup_"+date.getDate()+month+date.getFullYear());
	    }
	    /*
	     $("#installationNoteForm #V_WHERESQL").val(whereSeq);
	     $("#installationNoteForm #V_INSTALLSTATUS").val(installStatus);
	     $("#installationNoteForm #V_ORDERBYSQL").val(orderBySql);
	     $("#installationNoteForm #V_SELECTSQL").val(SelectSql);
	     $("#installationNoteForm #V_FULLSQL").val(FullSql);
	     */
//	     $("#installationNoteForm #reportFileName").val('/services/InstallationNote_WithOldOrderNo.rpt');
	     
	     $("#reportForm #V_FORCECASTDATE").val(forecastMonth);
	     $("#reportForm #V_BRANCHID").val(branchid);
	     $("#reportForm #V_CMID").val(cmid);
	     
	     $("#reportForm #viewType").val("PDF");
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
	$("#cmdCdManager").val('');
		
}

</script>
<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>BS Management - BS REPORT(GROUP)</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<section class="search_table"><!-- search_table start -->
<form action="#" id="reportForm">
<input type="hidden" id="V_DSCCODE" name="V_DSCCODE" />
<input type="hidden" id="V_APPDATE" name="V_APPDATE" />
<input type="hidden" id="V_ORDERDATE" name="V_ORDERDATE" />
<input type="hidden" id="V_WHERESQL" name="V_WHERESQL" />
<input type="hidden" id="V_ORDERBYSQL" name="V_ORDERBYSQL" />
<!--reportFileName,  viewType 모든 레포트 필수값 -->
<input type="hidden" id="reportFileName" name="reportFileName" />
<input type="hidden" id="viewType" name="viewType" />
<input type="hidden" id="reportDownFileName" name="reportDownFileName" value="DOWN_FILE_NAME" />

<aside class="title_line"><!-- title_line start -->
<ul class="right_btns">
    <li><p class="btn_blue"><a href="#"><span class="search"></span>Search</a></p></li>
    <li><p class="btn_blue"><a href="#"><span class="clear"></span>Clear</a></p></li>
</ul>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:150px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Organization Code</th>
    <td><input type="text" title="Organization Code" placeholder="Organization Code" class="w100p" /></td>
    <th scope="row">Group Code</th>
    <td><input type="text" title="Group Code" placeholder="Group Code" class="w100p" /></td>
    <th scope="row">Department Code</th>
    <td><input type="text" title="Department Code" placeholder="Department Code" class="w100p" /></td>
</tr>
</tbody>
</table><!-- table end -->

<article class="grid_wrap"><!-- grid_wrap start -->
그리드 영역
</article><!-- grid_wrap end -->

</form>
</section><!-- search_table end -->

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->
