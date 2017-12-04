<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javaScript">
$(document).ready(function(){
	$('.multy_select').on("change", function() {
        //console.log($(this).val());
    }).multipleSelect({});
    
	
	doGetComboSepa("/common/selectBranchCodeList.do",5 , '-',''   , 'branch' , 'S', '');
	doGetCombo('/services/as/report/selectMemberCodeList.do', '', '','CTCodeFrom', 'S' ,  '');
	doGetCombo('/services/as/report/selectMemberCodeList.do', '', '','CTCodeTo', 'S' ,  '');
	
});


function fn_validation(){
	
		if($("#reqStrDate").val() != '' && $("#asAppDtFr").val() != ''){
	        Common.alert("<spring:message code='sys.common.alert.validation' arguments='either AS request date or AS Appointment date (From & To)' htmlEscape='false'/>");
	        return false;
	    }
        if($("#orderNumFrom").val() == '' || $("#orderNumTo").val() == ''){
            Common.alert("<spring:message code='sys.common.alert.validation' arguments='order number (From & To)' htmlEscape='false'/>");
            return false;
        }
        if($("#CTCodeFrom").val() == '' || $("#CTCodeTo").val() == ''){
            Common.alert("<spring:message code='sys.common.alert.validation' arguments='CT code (From & To)' htmlEscape='false'/>");
            return false;
        }
        return true;
}

function fn_openGenerate(){
	if(fn_validation()){
		var fSONO1 = $("#orderNumFrom").val();
		var fSONO2 = $("#orderNumTo").val();
		var fMemCTID1 = $("#CTCodeFrom").val();
		var fMemCTID2 = $("#CTCodeTo").val();
		var reqDate1 = "";
		var reqDate2 = "";
		var appDate1 = "";
		var appDate2 = "";
		var whereSql = "";
		var dscBranch = "";
		var orderBy = " t1.f_Mem_Code ";
		
		if($("#asAppDtFr").val() != ''){
			appDate1 = $("#asAppDtFr").val();
			appDate2 = $("#asAppDtTo").val();
			whereSql += " and (AE.AS_APPNT_DT between to_date('" + appDate1 + "', 'DD/MM/YYYY') and to_date('" + appDate2 + "' , 'DD/MM/YYYY')) ";
		}else{
			reqDate1 = $("#reqStrDate").val();
			reqDate2 = $("#reqEndDate").val();
			whereSql += " and (AE.AS_REQST_DT between to_date('" + reqDate1 + "', 'DD/MM/YYYY') and to_date('" + reqDate2 + "' , 'DD/MM/YYYY')) ";
		}
		
		if($("#sortType").val() == 'AS'){
			orderBy = " t1.As_no ";
		}
		
		if($("#branch").val() != ''){
			dscBranch = " WHERE t1.Brnch_Code like '" + $("#branch option:selected").text().substring(0,6)  + "%' ";
		}
		
		
		var date = new Date();
	    var month = date.getMonth()+1;
	    $("#reportForm #V_FSONO1").val(fSONO1);
	    $("#reportForm #V_FSONO2").val(fSONO2);
	    $("#reportForm #V_FMEMCTID1").val(fMemCTID1);
	    $("#reportForm #V_FMEMCTID2").val(fMemCTID2);
	    $("#reportForm #V_ORDERBY").val(orderBy);
	    $("#reportForm #V_DSCBRANCH").val(dscBranch);
	    $("#reportForm #V_WHERESQL").val(whereSql);
	    $("#reportForm #reportFileName").val('/services/ASReport.rpt');
	    $("#reportForm #viewType").val("PDF");
	    $("#reportForm #reportDownFileName").val("ASReport_" +date.getDate()+month+date.getFullYear());
	    
	    var option = {
	            isProcedure : true, // procedure 로 구성된 리포트 인경우 필수.
	    };
	    
	    Common.report("reportForm", option);
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
<h1>AS Report</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<section class="search_table"><!-- search_table start -->
<form action="#" id="reportForm">
<input type="hidden" id="V_FSONO1" name="V_FSONO1" />
<input type="hidden" id="V_FSONO2" name="V_FSONO2" />
<input type="hidden" id="V_FMEMCTID1" name="V_FMEMCTID1" />
<input type="hidden" id="V_FMEMCTID2" name="V_FMEMCTID2" />
<input type="hidden" id="V_ORDERBY" name="V_ORDERBY" />
<input type="hidden" id="V_DSCBRANCH" name="V_DSCBRANCH" />
<input type="hidden" id="V_WHERESQL" name="V_WHERESQL" />
<!--reportFileName,  viewType 모든 레포트 필수값 -->
<input type="hidden" id="reportFileName" name="reportFileName" />
<input type="hidden" id="viewType" name="viewType" />
<input type="hidden" id="reportDownFileName" name="reportDownFileName" value="DOWN_FILE_NAME" />

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:190px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">AS Request Date</th>
    <td>

    <div class="date_set"><!-- date_set start -->
    <p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" id="reqStrDate" name="reqStrDate"/></p>
    <span>To</span>
    <p><input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" id="reqEndDate" name="reqEndDate"/></p>
    </div><!-- date_set end -->

    </td>
    <th scope="row">Order Number</th>
    <td>

    <div class="date_set"><!-- date_set start -->
    <p><input type="text" title="" placeholder="" class="w100p" id="orderNumFrom" name="orderNumFrom" value="${orderNum.c1}"/></p>
    <span>To</span>
    <p><input type="text" title="" placeholder="" class="w100p" id="orderNumTo" name="orderNumTo" value="${orderNum.c2}"/></p>
    </div><!-- date_set end -->

    </td>
</tr>
<tr>
    <th scope="row">CT Code</th>
    <td>
    <select id="CTCodeFrom" name="CTCodeFrom">
    </select>
    </td>
    <th scope="row">To</th>
    <td>
    <select id="CTCodeTo" name="CTCodeTo">
    </select>
    </td>
</tr>
<tr>
    <th scope="row">AS Appointment Date</th>
    <td>

    <div class="date_set"><!-- date_set start -->
    <p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" id="asAppDtFr" name="asAppDtFr"/></p>
    <span>To</span>
    <p><input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" id="asAppDtTo" name="asAppDtTo"/></p>
    </div><!-- date_set end -->

    </td>
    <th scope="row">DSC Branch</th>
    <td>
    <select id="branch" name="branch">
    </select>
    </td>
</tr>
<tr>
    <td colspan="2">
    <p><span>*Please Choose either Appointment Date or Request Date</span></p>
    </td>
    <th scope="row">Sort By</th>
    <td>
    <select id="sortType" name="sortType">
        <option value="AS">AS Number</option>
        <option value="CT">CT Code</option>
    </select>
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
