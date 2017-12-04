<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javaScript">

$(document).ready(function(){
	/*  $('.multy_select').on("change", function() {
         //console.log($(this).val());
     }).multipleSelect({}); */
	 
	 doGetComboSepa("/common/selectBranchCodeList.do",'1' , '-',''   , 'branch' , 'S', '');
	 $('#sheetType').multipleSelect("checkAll");
});

function fn_validation(){
	if($("#sheetType").val() == ''){
		Common.alert("<spring:message code='sys.common.alert.validation' arguments='type' htmlEscape='false'/>");
        return false;
	}
	if($("#reqDtFr").val() != '' || $("#reqDtTo").val() != ''){
        if($("#reqDtFr").val() == '' || $("#reqDtTo").val() == ''){
            Common.alert("<spring:message code='sys.common.alert.validation' arguments='request date (From & To)' htmlEscape='false'/>");
            return false;
        }
    }
	if($("#settleDtFr").val() != '' || $("#settleDtTo").val() != ''){
        if($("#settleDtFr").val() == '' || $("#settleDtTo").val() == ''){
            Common.alert("<spring:message code='sys.common.alert.validation' arguments='settle date (From & To)' htmlEscape='false'/>");
            return false;
        }
    }
	return true;
}

function fn_openGenerate(){
	var date = new Date();
    var month = date.getMonth()+1;
	if(fn_validation()){
		var YS= 0;
		var nonYS= 0;
		var setDateFrom = "01/01/1900";
		var setDateTo = "01/01/1900";
		var reqDateFrom = "01/01/1900";
		var reqDateTo = "01/01/1900";
		var branchID = "0";
		var YSAging = 0;
		
		if($("#sheetType").val() == '1'){
			YS = 1;
		}else if($("#sheetType").val() == '2'){
			nonYS = 1;
		}else{
			YS = 1;
			nonYS = 1;
		}
		
		if($("#settleDtFr").val() != '' && $("#settleDtTo").val() != ''){
			setDateFrom = $("#settleDtFr").val().substring(6,10) + "-" + $("#settleDtFr").val().substring(3,5) + "-" + $("#settleDtFr").val().substring(0,2);
			setDateTo = $("#settleDtTo").val().substring(6,10) + "-" + $("#settleDtTo").val().substring(3,5) + "-" + $("#settleDtTo").val().substring(0,2);
        }
		if($("#reqDtFr").val() != '' && $("#reqDtTo").val() != ''){
			reqDateFrom =  $("#reqDtFr").val().substring(6,10) + "-" + $("#reqDtFr").val().substring(3,5) + "-" + $("#reqDtFr").val().substring(0,2);
			reqDateTo = $("#reqDtTo").val().substring(6,10) + "-" + $("#reqDtTo").val().substring(3,5) + "-" + $("#reqDtTo").val().substring(0,2);
        }
		if($("#branch").val() != ''){
			branchID = $("#branch").val();
		}
		if($("#aging").val() != ''){
			YSAging = $("#aging").val();
        }
		
		$("#reportForm #V_YS").val(YS);
		$("#reportForm #V_NONYS").val(nonYS);
		$("#reportForm #V_SETDATEFROM").val(setDateFrom);
		$("#reportForm #V_SETDATETO").val(setDateTo);
		$("#reportForm #V_REQDATEFROM").val(reqDateFrom);
		$("#reportForm #V_REQDATETO").val(reqDateTo);
		$("#reportForm #V_BRANCHID").val(branchID);
		$("#reportForm #V_YSAGING").val(YSAging);
		$("#reportForm #reportFileName").val('/services/ASYellowSheet.rpt');
		$("#reportForm #viewType").val("PDF");
		$("#reportForm #reportDownFileName").val("ASYellowSheet_"+date.getDate()+month+date.getFullYear());
		
		var option = {
                isProcedure : true, // procedure 로 구성된 리포트 인경우 필수.
        };
        
        Common.report("reportForm", option);
		
	}
}

function fn_openExcel(){
    var date = new Date();
    var month = date.getMonth()+1;
    if(fn_validation){
        var YS= 0;
        var nonYS= 0;
        var setDateFrom = "01/01/1900";
        var setDateTo = "01/01/1900";
        var reqDateFrom = "01/01/1900";
        var reqDateTo = "01/01/1900";
        var branchID = "0";
        var YSAging = 0;
        
        if($("#sheetType").val() == '1'){
            YS = 1;
        }else{
            nonYS = 1;
        }
        
        if($("#settleDtFr").val() != '' && $("#settleDtTo").val() != ''){
        	setDateFrom = $("#settleDtFr").val().substring(6,10) + "-" + $("#settleDtFr").val().substring(3,5) + "-" + $("#settleDtFr").val().substring(0,2);
            setDateTo = $("#settleDtTo").val().substring(6,10) + "-" + $("#settleDtTo").val().substring(3,5) + "-" + $("#settleDtTo").val().substring(0,2);
        }
        if($("#reqDtFr").val() != '' && $("#reqDtTo").val() != ''){
        	reqDateFrom =  $("#reqDtFr").val().substring(6,10) + "-" + $("#reqDtFr").val().substring(3,5) + "-" + $("#reqDtFr").val().substring(0,2);
            reqDateTo = $("#reqDtTo").val().substring(6,10) + "-" + $("#reqDtTo").val().substring(3,5) + "-" + $("#reqDtTo").val().substring(0,2);
        }
        if($("#branch").val() != ''){
            branchID = $("#branch").val();
        }
        if($("#aging").val() != ''){
            YSAging = $("#aging").val();
        }
        
        $("#reportForm #V_YS").val(YS);
        $("#reportForm #V_NONYS").val(nonYS);
        $("#reportForm #V_SETDATEFROM").val(setDateFrom);
        $("#reportForm #V_SETDATETO").val(setDateTo);
        $("#reportForm #V_REQDATEFROM").val(reqDateFrom);
        $("#reportForm #V_REQDATETO").val(reqDateTo);
        $("#reportForm #V_BRANCHID").val(branchID);
        $("#reportForm #V_YSAGING").val(YSAging);
        $("#reportForm #reportFileName").val('/services/ASYellowSheet_RawData.rpt');
        $("#reportForm #viewType").val("EXCEL");
        $("#reportForm #reportDownFileName").val("ASYellowSheet_"+date.getDate()+month+date.getFullYear());
        
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
        $('#sheetType').multipleSelect("checkAll");
        
    });
};
</script>
<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>AS Yellow Sheet(YS)</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<section class="search_table"><!-- search_table start -->
<form action="#" id="reportForm">
<!--reportFileName,  viewType 모든 레포트 필수값 -->
<input type="hidden" id="V_YS" name="V_YS" />
<input type="hidden" id="V_NONYS" name="V_NONYS" />
<input type="hidden" id="V_SETDATEFROM" name="V_SETDATEFROM" />
<input type="hidden" id="V_SETDATETO" name="V_SETDATETO" />
<input type="hidden" id="V_REQDATEFROM" name="V_REQDATEFROM" />
<input type="hidden" id="V_REQDATETO" name="V_REQDATETO" />
<input type="hidden" id="V_BRANCHID" name="V_BRANCHID" />
<input type="hidden" id="V_YSAGING" name="V_YSAGING" />
<input type="hidden" id="reportFileName" name="reportFileName" />
<input type="hidden" id="viewType" name="viewType" />
<input type="hidden" id="reportDownFileName" name="reportDownFileName" value="DOWN_FILE_NAME" />

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:140px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Type</th>
    <td>
    <select class="multy_select" multiple="multiple" id="sheetType" name="sheetType">
        <option value="1">YS</option>
        <option value="2">Non-YS</option>
    </select>
    </td>
    <th scope="row">* YS Aging</th>
    <td>
    <select id="aging" name="aging">
        <option value="1">< 31 Days</option>
        <option value="2">31 - 60 Days</option>
        <option value="3">61 - 90 Days</option>
        <option value="4">> 90 Days</option>
    </select>
    </td>
</tr>
<tr>
    <th scope="row">Settle Date</th>
    <td>

    <div class="date_set"><!-- date_set start -->
    <p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" id="settleDtFr" name="settleDtFr"/></p>
    <span>To</span> 
    <p><input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" id="settleDtTo" name="settleDtTo"/></p>
    </div><!-- date_set end -->

    </td>
    <th scope="row">Request Date</th>
    <td>

    <div class="date_set"><!-- date_set start -->
    <p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" id="reqDtFr" name="reqDtFr"/></p>
    <span>To</span>
    <p><input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" id="reqDtTo" name="reqDtTo"/></p>
    </div><!-- date_set end -->

    </td>
</tr>
<tr>
    <th scope="row">Branch</th>
    <td colspan="3">
    <select id="branch">
    
    </select>
    </td>
</tr>
<tr>
    <td colspan="4">
    <p><span>(*) Only generate YS list if this field selected.</span></p>
    </td>
</tr>
</tbody>
</table><!-- table end -->

</form>
</section><!-- search_table end -->
<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#" onclick="javascript:fn_openGenerate()">Generate</a></p></li>
    <li><p class="btn_blue2 big"><a href="#" onclick="javascript:fn_openExcel()">Excel</a></p></li>
    <li><p class="btn_blue2 big"><a href="#" onclick="javascript:$('#reportForm').clearForm();">Clear</a></p></li>
</ul>
</section><!-- pop_body end -->

</div><!-- popup_wrap end -->