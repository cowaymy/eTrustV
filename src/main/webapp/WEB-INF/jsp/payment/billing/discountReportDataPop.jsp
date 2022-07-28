<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javascript">
function fn_validation(){
    if($("#applicationType").val() == '1'){
        if($("#dateStr").val() == '' || $("#dateEnd").val() == ''){
                Common.alert("<spring:message code='sys.common.alert.validation' arguments='date (From & To)' htmlEscape='false'/>");
                return false;
            }
    }
    return true;
}

function fn_openExcel(){
    if(fn_validation()){

        var date = new Date();
        var monthDay = date.getMonth()+1;
        var day = date.getDate();
        if(date.getDate() < 10){
            day = "0"+date.getDate();
        }
        if(monthDay < 10){
        	monthDay = "0"+monthDay;
        }

        var startDate = "";
        var endDate = "";
        var startDateArray = $("#dateStr").val().split('/');
        var endDateArray = $("#dateEnd").val().split('/');

        startDate = $("#dateStr").val().substring(6, 10)
				        + $("#dateStr").val().substring(3, 5)
				        + $("#dateStr").val().substring(0, 2);
	    endDate = $("#dateEnd").val().substring(6, 10)
				        + $("#dateEnd").val().substring(3, 5)
				        + $("#dateEnd").val().substring(0, 2);


	    //set parameters
        $("#reportFormDiscount").append('<input type="hidden" id="StartDate" name="@StartDate" value="" /> ');
        $("#reportFormDiscount").append('<input type="hidden" id="EndDate" name="@EndDate" value="" /> ');

        $("#reportFormDiscount #StartDate").val(startDate);
        $("#reportFormDiscount #EndDate").val(endDate);
        $("#reportFormDiscount #reportFileName").val('/payment/DiscountReport_Excel.rpt');
        $("#reportFormDiscount #viewType").val("EXCEL");
        $("#reportFormDiscount #reportDownFileName").val("DiscountforAdvanceCollectionReport_" +day+monthDay+date.getFullYear());

        Common.report("reportFormDiscount");
    }
}


function fn_close(){
    $("#popup_wrap").remove();
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
        $("#applicationType").val('1');
        $("#dateStr").val('');
        $("#dateEnd").val('');
    });
};
</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Discount for Advance Collection Report</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#"><spring:message code='expense.CLOSE'/></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id="reportFormDiscount">
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
    <th scope="row"><spring:message code='service.title.ApplicationType'/></th>
    <td>
    <select id="applicationType" name="applicationType">
        <option value="1">Rental</option>
    </select>
    </td>
</tr>
<tr>
    <th scope="row">Invoice Date</th>
    <td>

    <div class="date_set"><!-- date_set start -->
    <p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" id="dateStr" name="dateStr"/></p>
    <span>To</span>
    <p><input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" id="dateEnd" name="dateEnd"/></p>
    </div><!-- date_set end -->

    </td>
</tr>
</tbody>
</table><!-- table end -->

<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#" onclick="javascript:fn_openExcel()"><spring:message code='service.btn.GenerateToExcel'/></a></p></li>
    <li><p class="btn_blue2 big"><a href="#" onclick="javascript:$('#reportFormDiscount').clearForm();"><spring:message code='service.btn.Clear'/></a></p></li>
</ul>

</section><!-- search_table end -->

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->
