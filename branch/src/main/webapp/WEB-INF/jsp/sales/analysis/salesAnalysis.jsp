<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript" >

$(document).ready(function() {
	 //$("#titleYear").hide();
	 $("#accReportYear").hide();



 	  $("#reportType").change(function (){
		  if($("#reportType").val() != "16" && $("#reportType").val() != "19" && $("#reportType").val() != "20" && $("#reportType").val() != "21"){
			  console.log("reportType : " + $("#reportType").val() );
			  //$("#titleYear").hide();
			  $("#accReportYear").hide();
			  $("#yyyymmDate").show();
			  //$("#titleDate").show();


		  }else{
			  //$("#titleYear").show();
		        $("#accReportYear").show();
		        $("#yyyymmDate").hide();
		        //$("#titleDate").hide();

		  }

	  });


});

function fn_report(type) {

	if($("#reportType").val() != "16" && $("#reportType").val() != "19" && $("#reportType").val() != "20" && $("#reportType").val() != "21"){
    if($("#yyyymmDate").val() == null || $("#yyyymmDate").val() == ''){
        Common.alert('<spring:message code="sal.alert.msg.keyInDate" />');
        return;
    }
	}
    var yyyymmDate = $("#dataForm #yyyymmDate").val();
    var month = Number(yyyymmDate.substring(0, 2));
    var year = Number(yyyymmDate.substring(3));
    var year2 = $("#accReportYear").val();



   // $("#viewType").val('EXCEL');



    if(dataForm.reportType.value=="0"){
        $("#reportFileName").val('/sales/D_Ren_Sales_By_Category.rpt');
        $("#reportDownFileName").val("D_Ren_Sales_By_Category_" + $("#yyyymmDate").val());
        $("#Month").val(month);
        $("#Year").val(year);
        $("#viewType").val('EXCEL');

        var option = {
                isProcedure : false
            };

            Common.report("dataForm", option);
    }
    else if(dataForm.reportType.value=="1"){
         $("#reportFileName").val('/sales/D_Ren_Sales_By_Channel.rpt');
         $("#reportDownFileName").val("D_Ren_Sales_By_Channel_" + $("#yyyymmDate").val());
         $("#Month").val(month);
         $("#Year").val(year);
         $("#viewType").val('EXCEL');

         var option = {
                 isProcedure : false
             };

             Common.report("dataForm", option);
     }
    else if(dataForm.reportType.value=="2"){
        $("#reportFileName").val('/sales/D_Ren_Sales_By_Category_Channel.rpt');
        $("#reportDownFileName").val("D_Ren_Sales_By_Category_Channel_" + $("#yyyymmDate").val());
        $("#Month").val(month);
        $("#Year").val(year);
        $("#viewType").val('EXCEL');

        var option = {
                isProcedure : false
            };

            Common.report("dataForm", option);
    }
    else if(dataForm.reportType.value=="3"){
        $("#reportFileName").val('/sales/D_Ren_Sales_Details.rpt');
        $("#reportDownFileName").val("D_Ren_Sales_Details_" + $("#yyyymmDate").val());
        $("#Month").val(month);
        $("#Year").val(year);
        $("#viewType").val('EXCEL');

        var option = {
                isProcedure : false
            };

            Common.report("dataForm", option);
    }
    else if(dataForm.reportType.value=="4"){
        $("#reportFileName").val('/sales/D_Out_Sales_By_Category.rpt');
        $("#reportDownFileName").val("D_Out_Sales_By_Category_" + $("#yyyymmDate").val());
        $("#Month").val(month);
        $("#Year").val(year);
        $("#viewType").val('EXCEL');

        var option = {
                isProcedure : false
            };

            Common.report("dataForm", option);
    }
    else if(dataForm.reportType.value=="5"){
        $("#reportFileName").val('/sales/D_Out_Sales_By_Channel.rpt');
        $("#reportDownFileName").val("D_Out_Sales_By_Channel_" + $("#yyyymmDate").val());
        $("#Month").val(month);
        $("#Year").val(year);
        $("#viewType").val('EXCEL');

        var option = {
                isProcedure : false
            };

            Common.report("dataForm", option);
    }
    else if(dataForm.reportType.value=="6"){
        $("#reportFileName").val('/sales/D_Out_Sales_By_Category_Channel.rpt');
        $("#reportDownFileName").val("D_Out_Sales_By_Category_Channel_" + $("#yyyymmDate").val());
        $("#Month").val(month);
        $("#Year").val(year);
        $("#viewType").val('EXCEL');

        var option = {
                isProcedure : false
            };

            Common.report("dataForm", option);
    }
    else if(dataForm.reportType.value=="7"){
        $("#reportFileName").val('/sales/D_Mem_Sales_By_Category.rpt');
        $("#reportDownFileName").val("D_Mem_Sales_By_Category_" + $("#yyyymmDate").val());
        $("#Month").val(month);
        $("#Year").val(year);
        $("#viewType").val('EXCEL');

        var option = {
                isProcedure : false
            };

            Common.report("dataForm", option);
    }
    else if(dataForm.reportType.value=="8"){
        $("#reportFileName").val('/sales/M_Ren_Sales_By_Category.rpt');
        $("#reportDownFileName").val("M_Ren_Sales_By_Category_" + $("#yyyymmDate").val());
        $("#Month").val(month);
        $("#Year").val(year);
        $("#viewType").val('EXCEL');

        var option = {
                isProcedure : false
            };

            Common.report("dataForm", option);
    }
    else if(dataForm.reportType.value=="9"){
        $("#reportFileName").val('/sales/M_Ren_Sales_By_Channel.rpt');
        $("#reportDownFileName").val("M_Ren_Sales_By_Channel_" + $("#yyyymmDate").val());
        $("#Month").val(month);
        $("#Year").val(year);
        $("#viewType").val('EXCEL');

        var option = {
                isProcedure : false
            };

            Common.report("dataForm", option);
    }
    else if(dataForm.reportType.value=="10"){
        $("#reportFileName").val('/sales/M_Ren_Sales_By_Category_Channel.rpt');
        $("#reportDownFileName").val("M_Ren_Sales_By_Category_Channel_" + $("#yyyymmDate").val());
        $("#Month").val(month);
        $("#Year").val(year);
        $("#viewType").val('EXCEL');

        var option = {
                isProcedure : false
            };

            Common.report("dataForm", option);
    }
    else if(dataForm.reportType.value=="11"){
        $("#reportFileName").val('/sales/M_Ren_Sales_Details.rpt');
        $("#reportDownFileName").val("M_Ren_Sales_Details_" + $("#yyyymmDate").val());
        $("#Month").val(month);
        $("#Year").val(year);
        $("#viewType").val('EXCEL');

        var option = {
                isProcedure : false
            };

            Common.report("dataForm", option);
    }
    else if(dataForm.reportType.value=="12"){
        $("#reportFileName").val('/sales/M_Out_Sales_By_Category.rpt');
        $("#reportDownFileName").val("M_Out_Sales_By_Category_" + $("#yyyymmDate").val());
        $("#Month").val(month);
        $("#Year").val(year);
        $("#viewType").val('EXCEL');

        var option = {
                isProcedure : false
            };

            Common.report("dataForm", option);
    }
    else if(dataForm.reportType.value=="13"){
        $("#reportFileName").val('/sales/M_Out_Sales_By_Channel.rpt');
        $("#reportDownFileName").val("M_Out_Sales_By_Channel_" + $("#yyyymmDate").val());
        $("#Month").val(month);
        $("#Year").val(year);
        $("#viewType").val('EXCEL');

        var option = {
                isProcedure : false
            };

            Common.report("dataForm", option);
    }
    else if(dataForm.reportType.value=="14"){
        $("#reportFileName").val('/sales/M_Out_Sales_By_Category_Channel.rpt');
        $("#reportDownFileName").val("M_Out_Sales_By_Category_Channel_" + $("#yyyymmDate").val());
        $("#Month").val(month);
        $("#Year").val(year);
        $("#viewType").val('EXCEL');

        var option = {
                isProcedure : false
            };

            Common.report("dataForm", option);
    }
    else if(dataForm.reportType.value=="15"){
        $("#reportFileName").val('/sales/M_Mem_Sales_By_Category.rpt');
        $("#reportDownFileName").val("M_Mem_Sales_By_Category_" + $("#yyyymmDate").val());
        $("#Month").val(month);
        $("#Year").val(year);
        $("#viewType").val('EXCEL');

        var option = {
                isProcedure : false
            };

            Common.report("dataForm", option);
    }
    else if(dataForm.reportType.value=="16"){
        $("#reportFileName").val('/sales/Sales_Analysis_Process_PDF.rpt');
        $("#reportDownFileName").val("Sales_Analysis_" + $("#accReportYear").val());
        $("#v_Year").val(year2);
        $("#viewType").val('PDF');

        var option = {
                isProcedure : false
            };

            Common.report("dataForm", option);
    }
    else if(dataForm.reportType.value=="17"){
        $("#reportFileName").val('/sales/Net_Sales_Daily_Report.rpt');
        $("#reportDownFileName").val("Net_Sales_Daily_Report_" + $("#yyyymmDate").val());
        $("#NSD_MONTH").val(month);
        $("#NSD_YEAR").val(year);
        $("#viewType").val('EXCEL');

        var option = {
                isProcedure : false
            };

            Common.report("dataForm", option);
    }
    else if(dataForm.reportType.value=="18"){
        $("#reportFileName").val('/sales/Net_Sales_Daily_Report_V2.rpt');
        $("#reportDownFileName").val("Net_Sales_Daily_Report_V2_" + $("#yyyymmDate").val());
        $("#NSD_MONTH").val(month);
        $("#NSD_YEAR").val(year);
        $("#viewType").val('EXCEL');

        var option = {
                isProcedure : false
            };

            Common.report("dataForm", option);
    }

    else if(dataForm.reportType.value=="19"){
        $("#reportFileName").val('/sales/M_Sales_Report_Plan_By_Channel_and_Type.rpt');
        $("#reportDownFileName").val("M_Sales_Report_Plan_By_Channel_and_Type_" + $("#accReportYear").val());
        console.log ("month::" + month);
        console.log ("year::" + year);
        console.log ("year2::" + year2);
        $("#NSD_MONTH").val(month);
        $("#NSD_YEAR").val(year2);
        $("#viewType").val('EXCEL');

        var option = {
                isProcedure : true
            };

            Common.report("dataForm", option);
    }

    else if(dataForm.reportType.value=="20"){
        $("#reportFileName").val('/sales/M_Sales_Report_Plan_By_GM.rpt');
        $("#reportDownFileName").val("M_Sales_Report_Plan_By_GM_" + $("#accReportYear").val());
        $("#NSD_MONTH").val(month);
        $("#NSD_YEAR").val(year2);
        $("#viewType").val('EXCEL');

        var option = {
                isProcedure : true
            };

            Common.report("dataForm", option);
    }

      else if(dataForm.reportType.value=="21"){
        $("#reportFileName").val('/sales/M_Sales_Report_Plan_By_Category.rpt');
        $("#reportDownFileName").val("M_Sales_Report_Plan_By_Category_" + $("#accReportYear").val());
        $("#NSD_MONTH").val(month);
        $("#NSD_YEAR").val(year2);
        $("#viewType").val('EXCEL');

        var option = {
                isProcedure : true
            };

            Common.report("dataForm", option);

    }

/*     var option = {
        isProcedure : true
    };

    Common.report("dataForm", option); */
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
    <input type="hidden" id="NSD_MONTH" name="NSD_MONTH" />
    <input type="hidden" id="NSD_YEAR" name="NSD_YEAR" />
    <input type="hidden" id="Month" name="@Month" />
    <input type="hidden" id="Year" name="@Year" />
    <input type="hidden" id="v_Year" name="v_Year" />
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
        <option value="1">D_Ren_Sales_By_Channel</option>
        <!-- <option value="2">D_Ren_Sales_By_Category_Channel</option> -->
        <option value="3">D_Ren_Sales_Details</option>
        <option value="4">D_Out_Sales_By_Category</option>
        <option value="5">D_Out_Sales_By_Channel</option>
        <!-- <option value="6">D_Out_Sales_By_Category_Channel</option> -->
        <option value="7">D_Mem_Sales_By_Category</option>
        <option value="8">M_Ren_Sales_By_Category</option>
        <option value="9">M_Ren_Sales_By_Channel</option>
        <option value="10">M_Ren_Sales_By_Category_Channel</option>
        <option value="11">M_Ren_Sales_Details</option>
        <option value="12">M_Out_Sales_By_Category</option>
        <option value="13">M_Out_Sales_By_Channel</option>
        <option value="14">M_Out_Sales_By_Category_Channel</option>
        <option value="15">M_Mem_Sales_By_Category</option>
        <option value="16">Sales Analysis Report</option>
        <option value="17">Net Sales Daily Report</option>
        <option value="18">Net Sales Daily Report V2</option>
        <option value="19">M_Sales_Report_Plan_By_Channel_and_Type</option>
        <option value="20">M_Sales_Report_Plan_By_GM</option>
        <option value="21">M_Sales_Report_Plan_By_Category</option>
    </select>
    </td>
</tr>
<tr>
    <th scope="row" id = "titleDate"><spring:message code="sal.title.date" /></th>
    <td><input type="text" id="yyyymmDate" name="yyyymmDate"  placeholder="DD/MM/YYYY" class="j_date2 w100p" /></td>
</tr>
<tr>
    <th scope="row" id = "titleYear">Year</th>
    <td>
    <select class="w100p" id="accReportYear" name="report">
        <option value="2020" selected>2020</option>
        <option value="2021" >2021</option>
        <option value="2022" >2022</option>
    </select>
    </td>
</tr>

</tbody>
</table><!-- table end -->





</form>


</section><!-- search_table end -->

<ul class="center_btns">
    <li><p class="btn_blue2"><a href="#" onclick="javascript:fn_report('EXCEL');">Generate
    </a></p></li>
</ul>

</section><!-- content end -->