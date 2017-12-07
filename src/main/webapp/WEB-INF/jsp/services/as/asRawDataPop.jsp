<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javaScript">
$(document).ready(function(){

});


function fn_validation(){
    
        if($("#reportType").val == ''){
        	 Common.alert("<spring:message code='sys.common.alert.validation' arguments='type' htmlEscape='false'/>");
             return false;
        }
        if($("#reqstDateFr").val == '' || $("#reqstDateTo").val == ''){
            Common.alert("<spring:message code='sys.common.alert.validation' arguments='request date (From & To)' htmlEscape='false'/>");
            return false;
       }
        return true;
}

function fn_openGenerate(){
	
    if(fn_validation()){
    	
        var whereSql = "";
        var keyInDateFrom =$("#reqstDateFr").val().substring(6,10) + "-" + $("#reqstDateFr").val().substring(3,5) + "-" + $("#reqstDateFr").val().substring(0,2) + " 12:00:00 AM";
        var keyInDateTo = $("#reqstDateTo").val().substring(6,10) + "-" + $("#reqstDateTo").val().substring(3,5) + "-" + $("#reqstDateTo").val().substring(0,2)+ " 12:00:00 AM";;
        
        if($("#reqstDateFr").val() != '' && $("#reqstDateTo").val() != ''){
            whereSql += " and (a.AS_CRT_DT between to_date('" + $("#reqstDateFr").val() + "', 'DD/MM/YYYY') and to_date('" + $("#reqstDateTo").val() + "' , 'DD/MM/YYYY')) ";
        }
        
        
        if($("#reportType").val() == '1'){
        	var date = new Date();
            var month = date.getMonth()+1;
            var day = "";
            if(date.getDate() < 10){
                day = "0"+date.getDate();
            }
            $("#reportForm").append('<input type="hidden" id="V_SELECTSQL" name="V_SELECTSQL"  /> ');
            $("#reportForm").append('<input type="hidden" id="V_WHERESQL" name="V_WHERESQL" /> ');
            $("#reportForm").append('<input type="hidden" id="V_ORDERBYSQL" name="V_ORDERBYSQL" /> ');
            $("#reportForm").append('<input type="hidden" id="V_FULLSQL" name="V_FULLSQL" /> ');
            
            $("#reportForm #V_SELECTSQL").val("");
            $("#reportForm #V_ORDERBYSQL").val("");
            $("#reportForm #V_FULLSQL").val("");
            $("#reportForm #V_WHERESQL").val(whereSql);
            $("#reportForm #reportFileName").val('/services/ASRawData.rpt');
            $("#reportForm #viewType").val("EXCEL");
            $("#reportForm #reportDownFileName").val("ASRawData_" +day+month+date.getFullYear());
            
            var option = {
                    isProcedure : true, // procedure 로 구성된 리포트 인경우 필수.
            };
            
            Common.report("reportForm", option);
        }
        
        else{
            var date = new Date();
            var month = date.getMonth()+1;
            var day = "";
            if(date.getDate() < 10){
                day = "0"+date.getDate();
            }
           
            $("#reportForm").append('<input type="hidden" id="V_KEYINDATEFROM" name="V_KEYINDATEFROM" /> ');
            $("#reportForm").append('<input type="hidden" id="V_KEYINDATETO" name="V_KEYINDATETO"  /> ');
            $("#reportForm").append('<input type="hidden" id="V_DSCBRANCHID" name="V_DSCBRANCHID" /> ');
            
            
           
            $("#reportForm #V_KEYINDATEFROM").val(keyInDateFrom);
            $("#reportForm #V_KEYINDATETO").val(keyInDateTo);
            $("#reportForm #V_DSCBRANCHID").val(0);
            $("#reportForm #reportFileName").val('/services/ASSparePartRaw.rpt');
            $("#reportForm #viewType").val("EXCEL");
            $("#reportForm #reportDownFileName").val("ASSparePartRaw_" +day+month+date.getFullYear());
            
            var option = {
                    isProcedure : true, // procedure 로 구성된 리포트 인경우 필수.
            };
            
            Common.report("reportForm", option);
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
        
    });
};
</script>
<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>AS Raw Data</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<section class="search_table"><!-- search_table start -->
<form action="#" id="reportForm">
<!--reportFileName,  viewType 모든 레포트 필수값 -->
<input type="hidden" id="reportFileName" name="reportFileName" />
<input type="hidden" id="viewType" name="viewType" />
<input type="hidden" id="reportDownFileName" name="reportDownFileName" value="DOWN_FILE_NAME" />

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Report Type</th>
    <td>
    <select id="reportType"> 
        <option value="1">After Service (AS) Raw Data</option>
        <option value="2">After Service (AS) Spare Part Exchage Raw Data</option>
    </select>
    </td>
    <th scope="row">Request Date</th>
    <td>

    <div class="date_set"><!-- date_set start -->
    <p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" id="reqstDateFr"/></p>
    <span>To</span>
    <p><input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" id="reqstDateTo"/></p>
    </div><!-- date_set end -->

    </td>
</tr>
</tbody>
</table><!-- table end -->

</form>
</section><!-- search_table end -->
<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#" onclick="javascript:fn_openGenerate()">Generate</a></p></li>
    <li><p class="btn_blue2 big"><a href="#" onclick="javascript:$('#reportForm').clearForm();">Clear</a></p></li>
</ul>
</section><!-- pop_body end -->

</div><!-- popup_wrap end -->
