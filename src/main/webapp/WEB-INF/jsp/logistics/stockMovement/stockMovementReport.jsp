<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">


function clearBtn(){

    setDate();
}

function setDate(){

    $("#yyyymmDate").val("");

}

function fn_report(type) {

    if($("#yyyymmDate").val() == null || $("#yyyymmDate").val() == ''){
        Common.alert('<spring:message code="sal.alert.msg.keyInDate" />');
        return;
    }

    var yyyyStr =  $("#yyyymmDate").val();
    var mmStr =  $("#yyyymmDate").val();
    var yyyyStrValue = yyyyStr.substring(3,7);
    var mmStrValue = mmStr.substring(0,2);





    if(type == "PDF"){
        $("#viewType").val('PDF');
    }else if(type == "EXCEL"){
        $("#viewType").val('EXCEL');
    }else{
        return false;
    }

    if(dataForm.reportType.value=="1"){
        $("#reportFileName").val('/logistics/StockTurnOverReport_PDF.rpt');
        $("#reportDownFileName").val("StockTurnOverReport_PDF_" + $("#yyyymmDate").val());
        $("#V_YEAR").val( yyyyStr.substring(3,7));  //YYYY

    }

    else if(dataForm.reportType.value=="2"){
        $("#reportFileName").val('/logistics/StockTurnOverFilter_PDF.rpt');
        $("#reportDownFileName").val("StockTurnOverFilter_PDF_" + $("#yyyymmDate").val());
        $("#V_YEAR").val( yyyyStr.substring(3,7));  //YYYY

    }

    else if(dataForm.reportType.value=="3"){
        $("#reportFileName").val('/logistics/StockTurnOverAllReport_PDF.rpt');
        $("#reportDownFileName").val("StockTurnOverAllReport_PDF_" + $("#yyyymmDate").val());
        $("#V_YEAR").val( yyyyStr.substring(3,7));  //YYYY

    }


    else if(dataForm.reportType.value=="4"){
        $("#reportFileName").val('/logistics/StockAMovementSummaryByModel_PDF.rpt');
        $("#reportDownFileName").val("StkAMovSumByModel_PDF_" + $("#yyyymmDate").val());
        $("#V_YEAR").val( yyyyStr.substring(3,7));  //YYYY
        $("#V_MONTH").val( mmStr.substring(0,2)); //MM

    }
    else if(dataForm.reportType.value=="5"){

    	var displayStkB = "0";
    	var displayLocB = "0";

         if(yyyyStrValue <= "2012"){

        	 if(yyyyStrValue == "2012" && mmStrValue > "7"){

        		 displayLocB = "0";

        	 }else{

        		 displayLocB = "1";
        	 }

         }


         if(yyyyStrValue >= "2012"){

             if(yyyyStrValue == "2012" && mmStrValue < "7"){

                 displayStkB = "0";

             }else{

                 displayStkB = "1";
             }

         }


        $("#reportFileName").val('/logistics/StockBMovementSummaryByModel_PDF.rpt');
        $("#reportDownFileName").val("StkBMovSumByModel_PDF_" + $("#yyyymmDate").val());
        $("#V_YEAR").val( yyyyStr.substring(3,7));  //YYYY
        $("#V_MONTH").val( mmStr.substring(0,2)); //MM
        $("#V_DISPLAYSTKB").val( displayStkB );
        $("#V_DISPLAYLOCB").val( displayLocB );
    }



    else{
    	return false;
    }

  //alert( mmStrValue + "/" + yyyyStrValue + " " + " DISPLAY :  "+ $("#V_DISPLAYSTKB").val() + "|" + $("#V_DISPLAYLOCB").val() );

    var option = {
        isProcedure : true
    };

    Common.report("dataForm", option);
}




   </script>

<section id="content">

    <ul class="path">
        <li><img
            src="${pageContext.request.contextPath}/resources/images/common/path_home.gif"
            alt="Home" /></li>
        <li>Logistics</li>
        <li>Report</li>
        <li>Stock Movement Report</li>
    </ul>

    <aside class="title_line">
        <p class="fav">
            <a href="#" class="click_add_on">My menu</a>
        </p>
        <h2>Stock Movement Report</h2>
    </aside>
    <!-- title_line end -->

    <aside class="title_line">

    </aside>

    <section class="search_table">

    <form id="dataForm" name="searchForm">
    <input type="hidden" id="reportFileName" name="reportFileName" value="/logistics/StockAMovSumByMonth_PDF.rpt" />
    <input type="hidden" id="viewType" name="viewType" />
    <input type="hidden" id="V_YEAR" name="V_YEAR" />
    <input type="hidden" id="V_MONTH" name="V_MONTH" />
    <input type="hidden" id="V_DISPLAYSTKB" name="V_DISPLAYSTKB" />
    <input type="hidden" id="V_DISPLAYLOCB" name="V_DISPLAYLOCB" />
    <input type="hidden" id="reportDownFileName" name="reportDownFileName"  />


            <table summary="search table" class="type1">

                <caption>search table</caption>
                <colgroup>
                <col style="width:180px" />
                <col style="width:*" />
                </colgroup>


                <tbody>
                    <tr>
                  <th scope="row">Report Type</th>
                                    <td><select class="w100p" id="reportType" name="reportType">
                                    <option value="0" selected>Choose One</option>
                                     <option value="1">Turn Over - Stock</option>
                                <option value="2">Turn Over - Filter & Spare Part</option>
                                <option value="3">Turn Over - Stock , Filter & Spare Part</option>
                                   <option value="4">Stock A Movement Summary By Model</option>
                                   <option value="5">Stock B Movement Summary By Model</option>
                            </select></td>
                    </tr>
                                       <tr>
                  <th scope="row">Date</th>
                     <td><input type="text" id="yyyymmDate" name="yyyymmDate"  placeholder="DD/MM/YYYY" class="j_date2 w100p" /></td>
                    </tr>

                </tbody>
            </table>
        </form>
    </section>

    <ul class="center_btns">
    <li><p class="btn_blue2"><a href="#" onclick="javascript:fn_report('PDF');"><spring:message code="sal.btn.genPDF" /></a></p></li>
    <li><p class="btn_blue2"><a href="#" onclick="javascript: clearBtn()"><spring:message code="sal.btn.clear" /></a></p></li>

    </ul>

    </section>


