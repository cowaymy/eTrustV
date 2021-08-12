<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">


var nowMonth = new Date().getMonth();

nowMonth = FormUtil.lpad(nowMonth, 2, "0");

$("#mypPVPeriod").val(nowMonth+"/"+new Date().getFullYear());

function btnGenerate_Click(){
	var PVDt = $("#form #mypPVPeriod").val(); // date
	var year = Number(PVDt.substring(3));

	if(year < 2018){
        Common.alert('Only able to download data from 2018 onwards');
        return;
	}

    if(!($("#mypPVPeriod").val() == null || $("#mypPVPeriod").val().length == 0)){
        fn_report();
    }else{
        Common.alert('Please select PV Period');
    }
}

function fn_report(){
	var $reportForm = $("#reportForm")[0];

    $($reportForm).empty(); //remove children

    var reportDownFileName = ""; //download report name
    var reportFileName = ""; //reportFileName
    var reportViewType = ""; //viewType
    var PVDt = $("#form #mypPVPeriod").val(); // date

    //default input setting
    $($reportForm).append('<input type="hidden" id="reportFileName" name="reportFileName"  /> ');//report file name
    $($reportForm).append('<input type="hidden" id="reportDownFileName" name="reportDownFileName" /> '); // download report name
    $($reportForm).append('<input type="hidden" id="viewType" name="viewType" /> '); // download report  type
    var month = Number(PVDt.substring(0, 2));
    var year = Number(PVDt.substring(3));

    var option = {
            isProcedure : false, // procedure 로 구성된 리포트 인경우 필수.
          };



    var date = new Date().getDate();
    if(date.toString().length == 1){
        date = "0" + date;
    }


    reportFileName = "/commission/NeoProRawData_Excel.rpt"; //reportFileName

    //set parameters
    $($reportForm).append('<input type="hidden" id="PvMonth" name="PvMonth" value="" /> ');
    $($reportForm).append('<input type="hidden" id="PvYear" name="PvYear" value="" /> ');

    reportDownFileName = "NeoProRawData_"+date+(new Date().getMonth()+1)+new Date().getFullYear(); //report name
    reportViewType = "EXCEL"; //viewType

    $("#reportForm #PvMonth").val(month);
    $("#reportForm #PvYear").val(year);
    $("#reportForm #reportFileName").val(reportFileName);
    $("#reportForm #reportDownFileName").val(reportDownFileName);
    $("#reportForm #viewType").val(reportViewType);



    Common.report("reportForm", option);

}
</script>


<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>NeoPro Raw Download</h1>
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
    <col style="width:150px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">PV Period</th>
    <td><input type="text" title="기준년월" placeholder="MM/YYYY" class="j_date2 w100p" id="mypPVPeriod"/></td>
</tr>
</tbody>
</table><!-- table end -->

<ul class="center_btns">
    <li><p class="btn_blue"><a href="#" onclick="javascript: btnGenerate_Click();"><spring:message code="sal.btn.generateRpt" /></a></p></li>
</ul>


</form>

</section><!-- content end -->

</section><!-- container end -->

</div><!-- popup_wrap end -->

<form name="reportForm" id="reportForm" method="post"></form>