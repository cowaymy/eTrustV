<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript" language="javascript">

function fn_report() {

    if($("#listProductId").val() == null || $("#listProductId").val() == ''){
       Common.alert('<spring:message code="sal.alert.msg.plzSelPrd" />');
       return;
    }

    var reportType = $("#listPltvReportType").val();
    var stkId = $("#listProductId").val();
    var stkDesc = $("#listProductId option:selected").text();
    var rentStus = $("#listRentStus").val();

    if (reportType == 'RAW') {

      $("#dataForm #reportFileName").val("/sales/PLTV_Raw.rpt");
      $("#dataForm #reportDownFileName").val("PLTV_Raw_" + "${maxAccYm}" + "_" + rentStus + "_" + stkDesc);
      $("#dataForm #V_RENTSTUS").val(rentStus);

    } else if (rentStus == 'SUS' && reportType == 'SUS_COUNT') {

        $("#dataForm #reportFileName").val("/sales/PLTV_SUS_Count.rpt");
        $("#dataForm #viewType").val("EXCEL");
        $("#dataForm #reportDownFileName").val("PLTV_SUS_Count_" + "${maxAccYm}" + "_" + rentStus + "_" + stkDesc);

    } else if (rentStus == 'SUS' && reportType == 'LAST_SUS') {

        $("#dataForm #reportFileName").val("/sales/PLTV_Last_SUS.rpt");
        $("#dataForm #viewType").val("EXCEL");
        $("#dataForm #reportDownFileName").val("PLTV_Last_SUS_" + "${maxAccYm}" + "_" + rentStus + "_" + stkDesc);

    } else if (rentStus == 'SUS' && reportType == 'SUS_SUM_YM') {

        $("#dataForm #reportFileName").val("/sales/PLTV_SUS_SumYM.rpt");
        $("#dataForm #viewType").val("EXCEL");
        $("#dataForm #reportDownFileName").val("PLTV_SUS_SumYM_" + "${maxAccYm}" + "_" + rentStus + "_" + stkDesc);

    } else if (rentStus == 'RET_TER' && reportType == 'LAST_TER') {

        $("#dataForm #reportFileName").val("/sales/PLTV_Last_TER.rpt");
        $("#dataForm #viewType").val("EXCEL");
        $("#dataForm #reportDownFileName").val("PLTV_Last_TER_" + "${maxAccYm}" + "_" + rentStus + "_" + stkDesc);

    }


    $("#dataForm #V_STKID").val(stkId);
    $("#dataForm #viewType").val("EXCEL");

    var option = {
        isProcedure : true
    };

    Common.report("dataForm", option);
}

$(function(){

	 doGetComboAndGroup2('/sales/analysis/selectPltvProductCodeList.do', null, '', 'listProductId', 'S', 'fn_setOptGrpClass');//product 생성

});

function fn_setOptGrpClass() {
    $("optgroup").attr("class" , "optgroup_text");
}

</script>

<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>Sales</li>
    <li>Order list</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2><spring:message code="sal.title.pltv" /></h2>
</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->
<form id="dataForm" method="post">
    <input type="hidden" id="reportFileName" name="reportFileName" />
    <input type="hidden" id="viewType" name="viewType" />
    <input type="hidden" id="reportDownFileName" name="reportDownFileName"  />
    <input type="hidden" id="V_STKID" name="V_STKID" />
    <input type="hidden" id="V_RENTSTUS" name="V_RENTSTUS" />
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sales.prod" /></th>
    <td>
        <select class="w100p" id="listProductId" name="listProductId" />
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sales.RentalStatus" /></th>
    <td>
        <select class="w100p" id="listRentStus" name="listRentStus" >
            <option value="SUS">SUS</option>
            <option value="RET_TER">RET, TER</option>
        </select>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sales.pltv.ReportType" /></th>
    <td>
        <select class="w100p" id="listPltvReportType" name="listPltvReportType" >
            <option value="RAW">Raw</option>
            <option value="SUS_COUNT">SUS Count</option>
            <option value="LAST_SUS">Last SUS</option>
            <option value="LAST_TER">Last TER</option>
            <option value="SUS_SUM_YM">Sum of Last SUS by Year and Month</option>
        </select>
    </td>
</tr>
<tr>
    <td colspan="2"><p><span><spring:message code="sal.title.text.latestRentMonthYear" />${maxAccYm}</span></p></td>
</tr>
</tbody>
</table><!-- table end -->

</form>
</section><!-- search_table end -->

<ul class="center_btns">
    <li><p class="btn_blue2"><a href="#" onclick="javascript:fn_report();"><spring:message code="sal.btn.genExcel" /></a></p></li>
</ul>

</section><!-- content end -->