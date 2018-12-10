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
    $("#V_YEAR").val( yyyyStr.substring(3,7));  //MM/YYYY
    var mmStr =  $("#yyyymmDate").val();
    $("#V_MONTH").val( mmStr.substring(1,2)); //

    if(type == "PDF"){
        $("#viewType").val('PDF');
    }else if(type == "EXCEL"){
        $("#viewType").val('EXCEL');
    }else{
        return false;
    }

     if(dataForm.reportType.value=="3"){
        $("#reportFileName").val('/logistics/StockAMovementSummaryByModel_PDF.rpt');
        $("#reportDownFileName").val("StkAMovSumByModel_PDF_" + $("#V_YEAR").val());
    }
    else if(dataForm.reportType.value=="4"){
        $("#reportFileName").val('/logistics/StockBMovementSummaryByModel_PDF.rpt');
        $("#reportDownFileName").val("StkBMovSumByModel_PDF_" + $("#V_YEAR").val());
    }



    else{
    	return false;
    }

 // alert($("#V_YEAR").val());

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
<!--                                     <option value="1">Stock A Movement Summary In By Month</option>
                                   <option value="2">Stock B Movement Summary In By Month</option> -->
                                   <option value="3">Stock A Movement Summary By Model</option>
                                   <option value="4">Stock B Movement Summary By Model</option>
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


