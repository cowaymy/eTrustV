<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javaScript">
$(document).ready(function(){
	var curDate = new Date();
   
	$("#year").val(curDate.getFullYear());
	
	var tmp = curDate.getMonth()+1;
	if(tmp < 10)
		tmp = "0" + tmp;
	else
		tmp = "" +tmp;

	$("#month").val(tmp);
	
});

function fn_generateClick(){
	var curDate = new Date();
	var inputDate = new Date($("#year").val(), $("#month").val(), 01, 0, 0, 0);
    var cutDate = new Date(2015,04,01, 0, 0,  0);

	if(inputDate < cutDate){
		Common.alert("Sorry. Bill raw data before April 2015 cannot be generated.");
	}else if(inputDate > curDate){
		Common.alert("Sorry. Bill raw data beyond current date cannot be generated.");
	}else{
		
		var year = $("#year").val();
		var month = $("#month").val();
		
		Common.ajax("GET", "/payment/countMonthlyRawData.do", $("#searchForm").serialize(), function(result) {
	       var cnt = result;
		   alert(cnt);
	       if(cnt > 0){

				Common.showLoader();
		        $.fileDownload("/payment/selectMonthlyRawDataExcelList.do?year=" + year + "&month="+month)
				.done(function () {
			        Common.alert('File download a success!');                
					Common.removeLoader();            
		        })
			    .fail(function () {
					Common.alert('File download failed!');                
		            Common.removeLoader();            
				});
		   }else{
	    	   Common.alert("<spring:message code='sys.info.grid.noDataMessage'/>"); 
	       }
       });

	}
	
	//report 안쓴다.
	//report form에 parameter 세팅
	//$("#reportPDFForm #v_ScheduleYear").val($("#year").val());
	//$("#reportPDFForm #v_ScheduleMonth").val($("#month").val());			        
	
	//report 호출
	//var option = {
	//		isProcedure : true, // procedure 로 구성된 리포트 인경우 필수.
	//};

	//Common.report("reportPDFForm", option);
	
}

</script>

<!-- content start -->
<section id="content">
    <ul class="path">
        <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
        <li>Monthly Bill Raw Data</li>
    </ul>
    
    <!-- title_line start -->
    <aside class="title_line">
        <p class="fav"><a href="javascript:;" class="click_add_on">My menu</a></p>
        <h2>Monthly Bill Raw Data</h2>   
        <ul class="right_btns">
        
           <c:if test="${PAGE_AUTH.funcPrint == 'Y'}">
            <li><p class="btn_blue"><a href="javascript:fn_generateClick();"><spring:message code='pay.btn.generate'/></a></p></li>
           </c:if>
        </ul>    
    </aside>
    <!-- title_line end -->


 <!-- search_table start -->
    <section class="search_table">
        <form name="searchForm" id="searchForm"  method="post">
             <table class="type1"><!-- table start -->
                <caption>table</caption>
                <colgroup>
                    <col style="width:144px" />
                    <col style="width:*" />
                </colgroup>
                <tbody>
                    <tr>
                        <th scope="row">Schedule Year</th>
                        <td>
                            <input type="text" id="year" name="year" class="w100p"/>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Schedule Month</th>
                        <td>
                            <select id="month" name="month" class="w100p">
                                <option value="01">JANUARY</option>
                                <option value="02">FEBUARY</option>
                                <option value="03">MARCH</option>
                                <option value="04">APRIL</option>
                                <option value="05">MAY</option>
                                <option value="06">JUNE</option>
                                <option value="07">JULY</option>
                                <option value="08">AUGUST</option>
                                <option value="09">SEPTEMBER</option>
                                <option value="10">OCTOBER</option>
                                <option value="11">NOVEMBER</option>
                                <option value="12">DECEMBER</option>
                            </select>
                        </td>
                    </tr>                    
                 </tbody>
              </table>
        </form>
        </section>
</section>
<!-- popup_wrap end -->

<form name="reportPDFForm" id="reportPDFForm"  method="post">
    <input type="hidden" id="reportFileName" name="reportFileName" value="/payment/MonthlyBillRawData.rpt" />
    <input type="hidden" id="viewType" name="viewType" value="EXCEL" />
    <input type="hidden" id="v_ScheduleMonth" name="v_ScheduleMonth" />
    <input type="hidden" id="v_ScheduleYear" name="v_ScheduleYear" />
</form>