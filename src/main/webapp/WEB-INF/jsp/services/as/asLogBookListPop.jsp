<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javaScript">

$(document).ready(function(){
	$('.multy_select').on("change", function() {
        //console.log($(this).val());
    }).multipleSelect({});
	
	doGetCombo('/services/as/report/selectMemberCodeList.do', '', '','CTCode', 'S' ,  '');
	doGetComboSepa("/common/selectBranchCodeList.do",5 , '-',''   , 'branch' , 'S', '');
});

function fn_validation(){
    if($("#asAppDate").val() == ''){
        Common.alert("<spring:message code='sys.common.alert.validation' arguments='appointment date' htmlEscape='false'/>");
        return false;
    }
    return true;
}

function fn_openGenerate(){
    var date = new Date();
    var month = date.getMonth()+1;
    var day = date.getDate();
    if(date.getDate() < 10){
        day = "0"+date.getDate();
    }
    if(fn_validation()){
        
         var ASAppDate = $("#asAppDate").val() == '' ? "" : $("#asAppDate").val();
         var ASCTCode = $("#CTCode").val() == '' ? "" : $("#CTCode option:selected").text();
         var ASBranch = $("#branch").val() == '' ? "" : $("#branch option:selected").text();
         var ASCTGroup = $("#CTGroup").val() == '' ? "" : $("#CTGroup option:selected").text();
         var whereSql="";
         
         if($("#asType").val() != '' && $("#asType").val() != null){
        	 whereSql+= " AND ae.AS_TYPE_ID IN(" + $("#asType").val() + ") ";
         }
         if($("#asAppDate").val() != ''  && $("#asAppDate").val() != null){
             whereSql+= " AND ae.AS_APPNT_DT = to_date('" + $("#asAppDate").val() + "','DD/MM/YYYY') AND  ae.AS_Stus_ID = 1";
         }
         if($("#CTCode").val() != '' &&  $("#CTCode").val() != null){
             whereSql+= " AND mr.mem_id = " + $("#CTCode").val() + " ";
         }
         if($("#branch").val() != '' &&  $("#branch").val() != null){
             whereSql += " AND ae.AS_BRNCH_ID = " + $("#branch").val() + " ";
         }
         if($("#CTGroup").val() != '' &&  $("#CTGroup").val() != null){
             whereSql += " AND ae.AS_MEM_GRP =  '" + $("#CTGroup").val() + "' ";
         }
        $("#reportFormList #reportFileName").val('/services/ASLogBookList.rpt');
        $("#reportFormList #reportDownFileName").val("ASLogBook_"+day+month+date.getFullYear());
        $("#reportFormList #viewType").val("PDF");
        $("#reportFormList #V_SELECTSQL").val();
        $("#reportFormList #V_WHERESQL").val(whereSql);
        $("#reportFormList #V_ORDERBYSQL").val();
        $("#reportFormList #V_FULLSQL").val();
        $("#reportFormList #V_ASAPPDATE").val(ASAppDate);
        $("#reportFormList #V_ASCTCODE").val(ASCTCode);
        $("#reportFormList #V_ASBRANCH").val(ASBranch);
        $("#reportFormList #V_ASCTGROUP").val(ASCTGroup);
        
        var option = {
                isProcedure : true, // procedure 로 구성된 리포트 인경우 필수.
        };
        
        Common.report("reportFormList", option);
        
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
<h1>AS Log Book List</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<section class="search_table"><!-- search_table start -->
<form action="#" id="reportFormList">
<input type="hidden" id="V_SELECTSQL" name="V_SELECTSQL" />
<input type="hidden" id="V_WHERESQL" name="V_WHERESQL" />
<input type="hidden" id="V_ORDERBYSQL" name="V_ORDERBYSQL" />
<input type="hidden" id="V_FULLSQL" name="V_FULLSQL" />
<input type="hidden" id="V_ASAPPDATE" name="V_ASAPPDATE" />
<input type="hidden" id="V_ASCTCODE" name="V_ASCTCODE" />
<input type="hidden" id="V_ASBRANCH" name="V_ASBRANCH" />
<input type="hidden" id="V_ASCTGROUP" name="V_ASCTGROUP" />
<!--reportFileName,  viewType 모든 레포트 필수값 -->
<input type="hidden" id="reportFileName" name="reportFileName" />
<input type="hidden" id="viewType" name="viewType" />
<input type="hidden" id="reportDownFileName" name="reportDownFileName" value="DOWN_FILE_NAME" />

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:190px" />
    <col style="width:*" />
    <col style="width:110px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">AS Type</th>
    <td>
    <select class="multy_select w100p" multiple="multiple" id="asType" name="asType" >
        <option value="674">Manual AS</option>
        <option value="675">Auto AS</option>
    </select>
    </td>
    <th scope="row"></th>
    <td>
    </td>
</tr>
<tr>
    <th scope="row">AS Appointment Date</th>
    <td>
    <input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" id="asAppDate"/>
    </td>
    <th scope="row">CT Code</th>
    <td>
    <select id="CTCode" name="CTCode">
    </select>
    </td>
</tr>
<tr>
    <th scope="row">DSC Branch</th>
    <td>
    <select id="branch" name="branch">
    </select>
    </td>
    <th scope="row">CT Group</th>
    <td>
    <select id="CTGroup" name="CTGroup">
        <option value="A">A</option>
        <option value="B">B</option>
        <option value="C">C</option>
    </select>
    </td>
</tr>
</tbody>
</table><!-- table end -->
</form>
</section><!-- search_table end -->
<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#" onclick="javascript:fn_openGenerate()">Generate</a></p></li>
    <li><p class="btn_blue2 big"><a href="#" onclick="javascript:$('#reportFormList').clearForm();">Clear</a></p></li>
</ul>
</section><!-- pop_body end -->

</div><!-- popup_wrap end -->