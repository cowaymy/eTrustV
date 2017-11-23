<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javaScript">
$(document).ready(function(){
	 $('.multy_select').on("change", function() {
		    //console.log($(this).val());
		}).multipleSelect({});
	 
	 doGetCombo('/common/selectCodeList.do', '10', '','appliType', 'S' , ''); 
	 doGetComboSepa("/common/selectBranchCodeList.do",5 , '-',''   , 'branch' , 'S', '');
});

function fn_validation(){
	 if($("#instalType option:selected").length < 1)
	    {
		    Common.alert("<spring:message code='sys.common.alert.validation' arguments='installation type' htmlEscape='false'/>");
	        return false;
	    }
	if($("#orderNoFrom").val() != '' || $("#orderNoTo").val() != ''){
        if($("#orderNoFrom").val() == '' || $("#orderNoTo").val() == ''){
            Common.alert("<spring:message code='sys.common.alert.validation' arguments='order number (From & To)' htmlEscape='false'/>");
            return false;
        }
    }
	if($("#instalNoFrom").val() != '' || $("#instalNoTo").val() != ''){
        if($("#instalNoFrom").val() == '' || $("#instalNoTo").val() == ''){
            Common.alert("<spring:message code='sys.common.alert.validation' arguments='installation number (From & To)' htmlEscape='false'/>");
            return false;
        }
    }
	if($("#instalDtFrom").val() != '' || $("#instalDtTo").val() != ''){
        if($("#instalDtFrom").val() == '' || $("#instalDtTo").val() == ''){
            Common.alert("<spring:message code='sys.common.alert.validation' arguments='install date (From & To)' htmlEscape='false'/>");
            return false;
        }
    }
	if($("#CTCodeFrom").val() != '' || $("#CTCodeTo").val() != ''){
        if($("#CTCodeFrom").val() == '' || $("#CTCodeTo").val() == ''){
            Common.alert("<spring:message code='sys.common.alert.validation' arguments='CT code (From & To)' htmlEscape='false'/>");
            return false;
        }
    }
	 if($("#instalStatus option:selected").length < 1)
     {
         Common.alert("<spring:message code='sys.common.alert.validation' arguments='install status' htmlEscape='false'/>");
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
	    if($("#instalStatus").val() != ''){
	        whereSeq += "AND ientry.stus_code_id = " + $("#instalStatus").val() + "  ";
	    }
	    if($("#orderNoFrom").val() != '' && $("#orderNoTo").val() != ''){
	        whereSeq += "AND (som.Sales_Ord_No between '" + $("#orderNoFrom").val() + "' AND '" + $("#orderNoTo").val() + "') ";
	    }
	    if($("#instalDtFrom").val() != '' && $("#instalDtTo").val() != ''){
	        whereSeq +="AND (ientry.Install_Dt between  to_date('"  + $("#instalDtFrom").val() + "' , 'DD/MM/YYYY') AND to_date('" +$("#instalDtTo").val()  + "', 'DD/MM/YYYY') ) ";
	    }
	    if($("#appliType").val() != '' ){
	        whereSeq += "AND som.App_Type_ID = " + $("#appliType").val() + "  ";
	    }
	    if($("#branch").val() != '' ){
	        whereSeq += "AND install.brnch_ID = " + $("#branch").val() + "  ";
	    }
	    if($("#instalNoFrom").val() != '' && $("#instalNoTo").val() != ''){
	        whereSeq += "AND (ientry.Install_Entry_No between '" + $("#instalNoFrom").val() + "' AND '" + $("#instalNoTo").val() + "') ";
	    }
	    if($("#CTCodeFrom").val() != '' && $("#CTCodeTo").val() != ''){
	        whereSeq += "AND (CTMem.mem_Code between '" + $("#CTCodeFrom").val() + "' AND '" + $("#CTCodeTo").val() + "') ";
	    }
	    if($("#instalType").val() != ''){
	        whereSeq += "AND ce.Type_ID In (" + $("#instalType").val() + ") ";
	    }
	    
	    if($("#sortType").val() == "2"){
	        orderBySql = "ORDER BY CTMem.mem_Code ";
	    }else{
	        orderBySql = "ORDER BY ientry.Install_Entry_ID ";
	    }
	     $("#installationNoteForm #V_WHERESQL").val(whereSeq);
	     $("#installationNoteForm #V_INSTALLSTATUS").val(installStatus);
	     $("#installationNoteForm #V_ORDERBYSQL").val(orderBySql);
	     $("#installationNoteForm #V_SELECTSQL").val(SelectSql);
	     $("#installationNoteForm #V_FULLSQL").val(FullSql);
	     $("#installationNoteForm #reportFileName").val('/services/InstallationNote_WithOldOrderNo.rpt');
	     $("#installationNoteForm #viewType").val("PDF");
	     $("#installationNoteForm #reportDownFileName").val("InstallationNote_"+date.getDate()+month+date.getFullYear());
	  
	   //report 호출
	     var option = {
	             isProcedure : true, // procedure 로 구성된 리포트 인경우 필수.
	     };
	     
	     Common.report("installationNoteForm", option);
	}
	
}

function fn_clear(){
	
	$("#instalStatus").val('1');
	$("#orderNoFrom").val('');
	$("#orderNoTo").val('');
	$("#instalDtFrom").val('');
	$("#instalDtTo").val('');
	$("#appliType").val('');
	$("#branch").val('');
	$("#instalNoFrom").val('');
	$("#instalNoTo").val('');
	$("#CTCodeFrom").val('');
	$("#CTCodeTo").val('');
	$("#instalType").val('');
	$("#sortType").val('1');
	$("#V_WHERESQL").val('');
	$("#V_INSTALLSTATUS").val('');
	$("#V_ORDERBYSQL").val('');
	$("#V_SELECTSQL").val('');
	$("#V_FULLSQL").val('');
	$("#reportFileName").val('');
	$("#viewType").val('');
	
}

</script>
<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Installation Note</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<section class="search_table"><!-- search_table start -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:160px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Installation Type</th>
    <td>
    <select class="multy_select w100p" multiple="multiple" id="instalType" name="instalType">
        <option value="257">New Installation</option>
        <option value="258">Product Exchange</option>
    </select>
    </td>
    <th scope="row">Order Number</th>
    <td>

    <div class="date_set"><!-- date_set start -->
    <p><input type="text" title="" placeholder="" class="w100p" id="orderNoFrom" name="orderNoFrom" /></p>
    <span>To</span>
    <p><input type="text" title="" placeholder="" class="w100p" id="orderNoTo" name="orderNoTo"/></p>
    </div><!-- date_set end -->

    </td>
</tr>
<tr>
    <th scope="row">Application Type</th>
    <td>
    <select id="appliType" name="appType">
    </select>
    </td>
    <th scope="row">Installation No</th>
    <td>

    <div class="date_set"><!-- date_set start -->
    <p><input type="text" title="" placeholder="" class="w100p" id="instalNoFrom" name="instalNoFrom"/></p>
    <span>To</span>
    <p><input type="text" title="" placeholder="" class="w100p" id="instalNoTo" name="instalNoTo"/></p>
    </div><!-- date_set end -->

    </td>
</tr>
<tr>
    <th scope="row">Install Date</th>
    <td>

    <div class="date_set"><!-- date_set start -->
    <p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" id="instalDtFrom" name="instalDtFrom"/></p>
    <span>To</span>
    <p><input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" id="instalDtTo" name="instalDtTo"/></p>
    </div><!-- date_set end -->

    </td>
    <th scope="row">Install Status</th>
    <td>
    <select id="instalStatus" name="instalStatus">
    <option value="1">Active</option>
    <option value="4">Complete</option>
    </select>
    </td>
</tr>
<tr>
    <th scope="row">DSC Branch</th>
    <td>
    <select id="branch" name="branch">
    </select>
    </td>
    <th scope="row">CT Code</th>
    <td>

    <div class="date_set"><!-- date_set start -->
    <p><input type="text" title="" placeholder="" class="w100p" id="CTCodeFrom" name="CTCodeFrom" /></p>
    <span>To</span>
    <p><input type="text" title="" placeholder="" class="w100p" id="CTCodeTo" name="CTCodeTo"/></p>
    </div><!-- date_set end -->

    </td>
</tr>
<tr>
    <th scope="row">Sort By</th>
    <td colspan="3">
    <select id="sortType" name="sortType">
        <option value="1">Installation Number</option>
        <option value="2">CT Code</option>
    </select>
    </td>
</tr>
</tbody>
</table><!-- table end -->
<form  method="post" id="installationNoteForm" name="installationNoteForm">
<input type="hidden" id="V_WHERESQL" name="V_WHERESQL" />
<input type="hidden" id="V_INSTALLSTATUS" name="V_INSTALLSTATUS" />
<input type="hidden" id="V_ORDERBYSQL" name="V_ORDERBYSQL" />
<input type="hidden" id="V_SELECTSQL" name="V_SELECTSQL" />
<input type="hidden" id="V_FULLSQL" name="V_FULLSQL" />
<!--reportFileName,  viewType 모든 레포트 필수값 -->
<input type="hidden" id="reportFileName" name="reportFileName" />
<input type="hidden" id="viewType" name="viewType" />
<input type="hidden" id="reportDownFileName" name="reportDownFileName" value="DOWN_FILE_NAME" />


</form>
</section><!-- search_table end -->

<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#" onclick="javascript:fn_openReport()">Generate</a></p></li>
    <li><p class="btn_blue2 big"><a href="#" onclick="javascript:fn_clear()">Clear</a></p></li>
</ul>

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->
