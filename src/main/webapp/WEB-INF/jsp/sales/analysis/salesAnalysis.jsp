<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript" language="javascript">

function fn_report(type) {

    if($("#yyyymmDate").val() == null || $("#yyyymmDate").val() == ''){
        Common.alert('<spring:message code="sal.alert.msg.keyInDate" />');
        return;
    }
    var yyyymmDate = $("#dataForm #yyyymmDate").val();
    var month = Number(yyyymmDate.substring(0, 2));
    var year = Number(yyyymmDate.substring(3));



    $("#viewType").val('EXCEL');



    if(dataForm.reportType.value=="0"){
        $("#reportFileName").val('/sales/D_Ren_Sales_By_Category.rpt');
        $("#reportDownFileName").val("D_Ren_Sales_By_Category_" + $("#yyyymmDate").val());
        $("#Month").val(month);
        $("#Year").val(year);
    }
//     }else if(dataForm.reportType.value=="1"){
//         $("#reportFileName").val('/sales/AccumulatedAccReport_REN_Opt_Details_PDF.rpt');
//         $("#reportDownFileName").val("AccumulatedAccReportRenOperationLeaseDetails_" + $("#yyyymmDate").val());
//     }else if(dataForm.reportType.value=="2"){
//         $("#reportFileName").val('/sales/AccumulatedAccReport_REN_Fin_Details_PDF.rpt');
//         $("#reportDownFileName").val("AccumulatedAccReportRenFinanceLeaseDetails_" + $("#yyyymmDate").val());
//     }else if(dataForm.reportType.value=="3"){
//         $("#reportFileName").val('/sales/AccMembershipDetail_PDF.rpt');
//         $("#reportDownFileName").val("AccumulatedMembershipReportDetails_" + $("#yyyymmDate").val());
//     }

//  alert($("#V_INPUTDATE").val());

    var option = {
        isProcedure : false
    };

    Common.report("dataForm", option);
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
<h2>Sales Analysis Report</h2>
</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->
<form id="dataForm" method="post">
    <input type="hidden" id="reportFileName" name="reportFileName" />
    <input type="hidden" id="viewType" name="viewType" />
    <input type="hidden" id="Month" name="@Month" />
    <input type="hidden" id="Year" name="@Year" />
    <input type="hidden" id="reportDownFileName" name="reportDownFileName"  />
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sal.text.reportType" /></th>
    <td>
    <select class="w100p" id="reportType" name="reportType">
        <option value="0">D_Ren_Sales_By_Category</option>

    </select>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.date" /></th>
    <td><input type="text" id="yyyymmDate" name="yyyymmDate"  placeholder="DD/MM/YYYY" class="j_date2 w100p" /></td>
</tr>

</tbody>
</table><!-- table end -->





</form>


</section><!-- search_table end -->

<ul class="center_btns">
    <li><p class="btn_blue2"><a href="#" onclick="javascript:fn_report('EXCEL');"><spring:message code="sal.btn.genExcel" /></a></p></li>
</ul>

</section><!-- content end -->