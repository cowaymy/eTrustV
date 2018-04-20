<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">

$.fn.clearForm = function() {

    return this.each(function() {
        var type = this.type, tag = this.tagName.toLowerCase();
        if (tag === 'form'){
            return $(':input',this).clearForm();
        }
        if (type === 'text' || type === 'password' || type === 'hidden' || tag === 'textarea'){
            this.value = '';
        }else if(type === 'checkbox') {
            this.checked = false;
        }
        else if (tag === 'select'){
            this.selectedIndex = 0;
        }

    });
};

function fn_report(){

    $("#reportFileName").val("");
    $("#reportDownFileName").val("");
    $("#viewType").val("");

    var ordDtFrom = '';
    var ordDtTo = '';
    var keyInBranch = '';
    var orderBy = '';
    var sortBy = '';

    // Ordering Date
    if(($("#listOrdStartDt").val()!= "" || $("#listOrdStartDt").val() != null) && ($("#listOrdEndDt").val()!= "" || $("#listOrdEndDt").val() != null)) {

    	ordDtFrom = $("#listOrdStartDt").val();
    	ordDtTo = $("#listOrdEndDt").val();

    	var arrOrdDtFr = ordDtFrom.split("/");
    	var arrOrdDtTo = ordDtTo.split("/");

    	ordDtFrom = arrOrdDtFr[2] + "/" + arrOrdDtFr[1] + "/" + arrOrdDtFr[0];
    	ordDtTo = arrOrdDtTo[2] + "/" + arrOrdDtTo[1] + "/" + arrOrdDtTo[0];
    }

    if($("#listKeyinBrnchId").val() != null ) {
    	keyInBranch = $("#listKeyinBrnchId").val();
    }

    if($('#sortBy').val() != "" || $('#sortBy').val() != null) {
    	if($('#sortBy').val() == "1") {
    		orderBy = " som.SALES_ORD_NO ASC ";
    		sortBy = "Order No (Ascending)";
    	} else if($('#sortBy').val() == "2") {
    		orderBy = " som.SALES_ORD_NO DESC ";
    		sortBy = "Order No (Descending)";
    	} else if($('#sortBy').val() == "3") {
    		orderBy = " som.SALES_DT ASC ";
    		sortBy = "Order Date (Ascending)";
    	} else if($('#sortBy').val() == "4") {
    		orderBy = " som.SALES_DT DESC ";
    		sortBy = "Order Date (Descending)";
    	} else if($('#sortBy').val() == "5") {
    		orderBy = " som.REF_NO ";
    		sortBy = "Key-In Branch";
    	} else if($('#sortBy').val() == "6") {
    		orderBy = " mem.MEM_CODE ";
    		sortBy = "HP/Cody Code";
    	}
    }

    var date = new Date().getDate();
    if(date.toString().length == 1){
        date = "0" + date;
    }

    $("#reportDownFileName").val("eDeduction_FailedListing_"+date+(new Date().getMonth()+1)+new Date().getFullYear());
    $("#form #reportFileName").val("/payment/eDeduction_FailedListing_PDF.rpt");

    $("#form #viewType").val("PDF");

    $("#form #PRINT_BY").val("");
    $("#form #SORT_BY").val(sortBy);

    $("#form #V_ORDDTFROM").val(ordDtFrom);
    $("#form #V_ORDDTTO").val(ordDtTo);
    $("#form #V_KEYINBRANCH").val(keyInBranch);
    $("#form #V_ORDERBY").val(orderBy);

    // 프로시져로 구성된 경우 꼭 아래 option을 넘겨야 함.
    var option = {
            isProcedure : true // procedure 로 구성된 리포트 인경우 필수.  => /payment/PaymentListing_Excel.rpt 는 프로시져로 구성된 파일임.
    };

    Common.report("form", option);

}

function fn_multiCombo(){
	$('#listKeyinBrnchId').change(function() {
        //console.log($(this).val());
    }).multipleSelect({
        selectAll: true, // 전체선택
        width: '100%'
    });
}

doGetComboSepa('/common/selectBranchCodeList.do',  '1', ' - ', '', 'listKeyinBrnchId', 'M', 'fn_multiCombo'); //Branch Code

var sortBy = [{"codeId":"1","codeName":"Order No (Ascending)"},{"codeId":"2","codeName":"Order No (Descending)"},{"codeId":"3","codeName":"Order Date (Ascending)"},{"codeId":"4","codeName":"Order Date(Descending)"},{"codeId":"5","codeName":"Key-In Branch"},{"codeId":"6","codeName":"HP/Cody Code"}]
doDefCombo(sortBy, '', 'sortBy', 'S', '');

</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Failed eCash Listing</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#"><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<aside class="title_line"><!-- title_line start -->

</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id="form" name="form">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
    <col style="width:180px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Order Date</th>
    <td>
        <div class="date_set w100p"><!-- date_set start -->
            <p><input id="listOrdStartDt" name="ordDtFr" type="text" value="" title="Start Date" placeholder="DD/MM/YYYY" class="j_date" required/></p>
            <span><spring:message code="sal.title.to" /></span>
            <p><input id="listOrdEndDt" name="ordDtTo" type="text" value="" title="End Date" placeholder="DD/MM/YYYY" class="j_date" required/></p>
        </div><!-- date_set end -->
    </td>
    <th scope="row">Key-In Branch</th>
    <td>
        <select id="listKeyinBrnchId" name="keyinBrnchId" class="multy_select w100p" multiple="multiple"></select>
    </td>
</tr>
<tr>
    <th scope="row">Sort By</th>
    <td>
        <select id="sortBy" name="sortBy" class="w100p"></select>
    </td>
</tr>
</tbody>
</table><!-- table end -->

<ul class="center_btns">
    <li><p class="btn_blue2"><a href="#" onclick="javascript:fn_report();"><spring:message code="sal.btn.genPDF" /></a></p></li>
    <li><p class="btn_blue2"><a href="#" onclick="javascript:$('#form').clearForm();"><spring:message code="sal.btn.clear" /></a></p></li>
</ul>

<input type="hidden" id="reportFileName" name="reportFileName" value="" />
<input type="hidden" id="viewType" name="viewType" value="" />
<input type="hidden" id="reportDownFileName" name="reportDownFileName" value="" />

<input type="hidden" id="PRINT_BY" name="PRINT_BY" value="" />
<input type="hidden" id="SORT_BY" name="SORT_BY" value="" />

<input type="hidden" id="V_ORDDTFROM" name="V_ORDDTFROM" value="" />
<input type="hidden" id="V_ORDDTTO" name="V_ORDDTTO" value="" />
<input type="hidden" id="V_KEYINBRANCH" name="V_KEYINBRANCH" value="" />
<input type="hidden" id="V_ORDERBY" name="V_ORDERBY" value="" />

</form>

</section><!-- content end -->

</section><!-- container end -->

</div><!-- popup_wrap end -->