<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">

$(document).ready(function() {
	
	//doGetCombo('/common/selectCodeList.do', '8', '','_cmbTypeId_', 'S' , '');   // Customer Type Combo Box
	CommonCombo.make("_custType", '/common/selectCodeList.do', {groupCode: '8'}, '' ,{type: "M", isShowChoose: false});
});

function fn_setParameter(method){
    
	//validation
	if($("#_inputDate").val() == null || $("#_inputDate").val() == ''){
		Common.alert('<spring:message code="sal.alert.msg.keyInDate" />');
		return;
	}
	
	//variable
    var runNo = 0;
    var whereSQL = '';
    var customerType = '';
    var year = '';
    var month = '';
	
	//VIEW
	if(method == "PDF"){
		$("#viewType").val("PDF");//method	
	}
	if(method == "EXCEL"){
		$("#viewType").val("EXCEL");//method
	}
	
	//Param Setting
	
	 //Params
    //Where Sql
    if($("#_custType :selected").length > 0){
           whereSQL += " AND (";
           $('#_custType :selected').each(function(i, e){ 
               if(runNo > 0){
                   whereSQL += " OR c.TYPE_ID = "+ $(e).val() +" ";
                   customerType += "," + $(e).text().trim();
               }else{
                   whereSQL += " c.TYPE_ID = "+ $(e).val() +" ";
                   customerType += $(e).text().trim();
               }
               runNo += 1;
           });
           whereSQL += ") ";
    }
    runNo = 0;
    
    //YEAR and MONTH
     var inputDate = '';
     var inputArr;
     inputDate = $("#_inputDate").val();
     inputArr = inputDate.split("/");
     year = inputArr[1]+'';
     month = inputArr[0]+'';
	
     //CURRENT DATE
     var date = new Date().getDate();
     if(date.toString().length == 1){
         date = "0" + date;
     }
     
	//FILE NAME
	if($("#_rptType").val() == '0'){
		$("#reportFileName").val("/sales/AutoDebitAccountBased.rpt"); //File Name	
		$("#reportDownFileName").val("AutoDebitAccountBased_"+date+(new Date().getMonth()+1)+new Date().getFullYear()); ////DOWNLOAD FILE NAME
		
		//params
	    $("#V_CUSTOMERTYPE").val(customerType);
	    $("#V_PVMONTH").val(month);
	    $("#V_PVYEAR").val(year);
	    $("#V_WHERESQL").val(whereSQL);
	}
	if($("#_rptType").val() == '1'){      
		$("#reportFileName").val("/sales/RegDailyAgingMonthMov.rpt"); //File Name
		$("#reportDownFileName").val("RegularDailyAgeingMovemet"+date+(new Date().getMonth()+1)+new Date().getFullYear()); ////DOWNLOAD FILE NAME
		
		//params
	    $("#V_CUSTOMERTYPE").val(customerType);
	    $("#V_PVMONTH").val(month);
	    $("#V_PVYEAR").val(year);
	    $("#V_WHERESQL").val(whereSQL);
	}
	if($("#_rptType").val() == '2'){
        $("#reportFileName").val("/sales/CCPDailySuccessKeyIn.rpt"); //File Name
        $("#reportDownFileName").val("CCPDailySuccessMonReport"+date+(new Date().getMonth()+1)+new Date().getFullYear()); ////DOWNLOAD FILE NAME
        
        //params
        $("#V_PVMONTH").val(month);
        $("#V_PVYEAR").val(year);
    }
	if($("#_rptType").val() == '3'){
        $("#reportFileName").val("/sales/RegDailyAgingMonthMovByState.rpt"); //File Name
        $("#reportDownFileName").val("RegularDailyAgeingMovemetByState"+date+(new Date().getMonth()+1)+new Date().getFullYear()); ////DOWNLOAD FILE NAME
        
        //params
        $("#V_CUSTOMERTYPE").val(customerType);
        $("#V_PVMONTH").val(month);
        $("#V_PVYEAR").val(year);
        $("#V_WHERESQL").val(whereSQL);
    }
	
	var option = {
            isProcedure : true // procedure 로 구성된 리포트 인경우 필수.  => /payment/PaymentListing_Excel.rpt 는 프로시져로 구성된 파일임.
        };

        Common.report("dataForm", option);
}


</script>

<form id="dataForm">
    
    <input type="hidden" id="reportFileName" name="reportFileName"  />
    <input type="hidden" id="viewType" name="viewType" />
    <!--param  -->
    <!-- 1 -->
    <input type="hidden" id="V_CUSTOMERTYPE" name="V_CUSTOMERTYPE"  />
    <input type="hidden" id="V_PVMONTH" name="V_PVMONTH"  />
    <input type="hidden" id="V_PVYEAR" name="V_PVYEAR"  />
    
    
    <!--common param  -->
    <input type="hidden" id="V_WHERESQL" name="V_WHERESQL"  />
    <input type="hidden" id="reportDownFileName" name="reportDownFileName" />
</form>


<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li><spring:message code="sal.title.analysis" /></li>
    <li><spring:message code="sal.title.autoDebAndAgeing" /></li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2><spring:message code="sal.title.autoDebMonthAgCcp" /></h2>
</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->
<form action="#" method="post">

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
    <select class="w100p" id="_rptType">
	    <option value="0" selected="selected"><spring:message code="sal.combo.text.autoDebAccBase" /></option>
	    <option value="1"><spring:message code="sal.combo.text.ageing" /></option>
	    <option value="2"><spring:message code="sal.combo.text.ccpSucsMonitor" /></option>
	    <option value="3"><spring:message code="sal.combo.text.agMovByState" /></option>
    </select>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sales.promo.custType"/></th>
    <td>
    <select class="multy_select w100p" multiple="multiple" id="_custType"></select>
    </td>
</tr>
<tr>
    <th scope="row">Date</th>
     <td><input type="text"  placeholder="DD/MM/YYYY" class="j_date2 w100p" readonly="readonly" id="_inputDate"/></td>
</tr>
</tbody>
</table><!-- table end -->

</form>
</section><!-- search_table end -->
<ul class="center_btns">
    <li><p class="btn_blue2"><a onclick="javascript: fn_setParameter('PDF')"><spring:message code="sal.btn.genPDF" /></a></p></li>
    <li><p class="btn_blue2"><a onclick="javascript: fn_setParameter('EXCEL')"><spring:message code="sal.btn.genExcel" /></a></p></li>
</ul>

</section><!-- content end -->