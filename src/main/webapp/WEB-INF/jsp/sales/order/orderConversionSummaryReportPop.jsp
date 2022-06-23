<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>


<script type="text/javascript">

var date = new Date().getDate();
if(date.toString().length == 1){
    date = "0" + date;
}


$.fn.clearForm = function() {
    return this.each(function() {
        var type = this.type, tag = this.tagName.toLowerCase();
        if (tag === 'form'){
            return $(':input',this).clearForm();
        }
        if (type === 'text' || type === 'password' || type === 'hidden' || tag === 'textarea'){
            this.value = '';
        }else if (tag === 'select'){
            this.selectedIndex = 0;
        }

        $("#dpDateFr").val(date+"/"+(new Date().getMonth()+1)+"/"+new Date().getFullYear());
        $("#dpDateTo").val(date+"/"+(new Date().getMonth()+1)+"/"+new Date().getFullYear());

        $("#cmbType").removeClass("disabled");
        $("#txtOrderNumberFrom").removeAttr("disabled");
        $("#txtOrderNumberTo").removeAttr("disabled");
        $("#cmbRegion").removeClass("disabled");
        $("#cmbbranch").removeClass("disabled");

        $('#cmbType').prop("disabled", false);
        $('#cmbRegion').prop("disabled", false);
        $('#cmbbranch').prop("disabled", false);

    });
};



function validRequiredField(){

    var valid = true;
    var message = "";

    if(($("#dpDateFr").val() == null || $("#dpDateFr").val().length == 0) || ($("#dpDateTo").val() == null || $("#dpDateTo").val().length == 0)){
        valid = false;
        message += 'Please Keyin Date';
    }

    if( fn_getDateGap($("#dpDateFr").val() , $("#dpDateTo").val()) > 30){
        Common.alert('Start date can not be more than 30 days before the end date.');
        return;
    }


    if(valid == true){
        fn_report();
    }else{
        Common.alert('Conversion Summary Report' + DEFAULT_DELIMITER + message);
    }
}

function fn_getDateGap(sdate, edate){

    var startArr, endArr;

    startArr = sdate.split('/');
    endArr = edate.split('/');

    var keyStartDate = new Date(startArr[2] , startArr[1] , startArr[0]);
    var keyEndDate = new Date(endArr[2] , endArr[1] , endArr[0]);

    var gap = (keyEndDate.getTime() - keyStartDate.getTime())/1000/60/60/24;


    return gap;
}

function fn_report(){
    var date = new Date();
    var month = date.getMonth() + 1;
    var day = date.getDate();
    if (date.getDate() < 10) {
      day = "0" + date.getDate();
    }

    if (month < 10) {
      month = "0" + month;
    }

    var $reportParameter = $("#reportParameter")[0];
    $($reportParameter).empty(); //remove children
    //default input setting
    $($reportParameter).append('<input type="hidden" id="reportFileName" name="reportFileName"  /> ');//report file name
    $($reportParameter).append('<input type="hidden" id="reportDownFileName" name="reportDownFileName" /> '); // download report name
    $($reportParameter).append('<input type="hidden" id="viewType" name="viewType" /> '); // download report  type
    $($reportParameter).append('<input type="hidden" id="V_SDATE" name="V_SDATE"  /> ');//start date
    $($reportParameter).append('<input type="hidden" id="V_EDATE" name="V_EDATE"  /> ');//END DATE
    var reportDownFileName = "ConversionSummaryReport_" + day + month + date.getFullYear(); //report name
    var reportFileName = "/sales/ConversionSummary.rpt"; //reportFileName
    var reportViewType = "EXCEL"; //viewType
    $("#reportParameter #reportFileName").val(reportFileName);
    $("#reportParameter #reportDownFileName").val(reportDownFileName);
    $("#reportParameter #viewType").val(reportViewType);
    $("#reportParameter #V_SDATE").val($('#dpDateFr').val().split("/")[2] + $('#dpDateFr').val().split("/")[1] + $('#dpDateFr').val().split("/")[0]);
    $("#reportParameter #V_EDATE").val($('#dpDateTo').val().split("/")[2] + $('#dpDateTo').val().split("/")[1] + $('#dpDateTo').val().split("/")[0]);
    $("#viewType").val("EXCEL");

    // 프로시져로 구성된 경우 꼭 아래 option을 넘겨야 함.
    var option = {
            isProcedure : true // procedure 로 구성된 리포트 인경우 필수.  => /payment/PaymentListing_Excel.rpt 는 프로시져로 구성된 파일임.
    };

    Common.report("reportParameter", option);



    //set date portion for report download filename - start
    /* */
}



</script>



<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Conversion Summary Report</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#"><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<aside class="title_line"><!-- title_line start -->

</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id="form">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:130px" />
    <col style="width:*" />
</colgroup>
<tbody>

<tr>
    <th scope="row">Convert Date</th>
    <td>
    <div class="date_set"><!-- date_set start -->
    <p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" id="dpDateFr"/></p>
    <span><spring:message code="sal.title.to" /></span>
    <p><input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" id="dpDateTo"/></p>
    </div><!-- date_set end -->
    </td>
</tr>
</table><!-- table end -->

<ul class="right_btns">
    <li><p class="btn_blue"><a href="javascript:void(0);" onclick="javascript: validRequiredField();"><spring:message code="sal.btn.generate" /></a></p></li>
    <li><p class="btn_blue"><a href="#" onclick="javascript:$('#form').clearForm();"><span class="clear"></span><spring:message code="sal.btn.clear" /></a></p></li>
</ul>


<!--
<div id="reportParameter"></div> -->
</form>
<form name="reportParameter" id="reportParameter" method="post"></form>
</section><!-- content end -->

</section><!-- container end -->



</div><!-- popup_wrap end -->