<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javaScript">

//Default Combo Data
var reportTypeData = [{"codeId": "1","codeName": "Advance Billing Raw Data"},{"codeId": "2","codeName": "Voided Billing Raw Data"}];

// 화면 초기화 함수 (jQuery 의 $(document).ready(function() {}); 과 같은 역할을 합니다.
$(document).ready(function(){    
    
	//메인 페이지
    doDefCombo(reportTypeData, '' ,'reportType', 'S', '');        //Report Type 생성      
    
    //현재 년월 세팅
    var today = new Date();
    $("#issueMonth").val(FormUtil.lpad((today.getMonth()+1),2,"0") + "/" + today.getFullYear());
    
    
    
});



//크리스탈 레포트
function fn_generate(){
	
	if(FormUtil.checkReqValue($("#reportType option:selected"))){
        Common.alert("<spring:message code='pay.alert.selectReportType'/>");
        return;
    }
	
    if(FormUtil.checkReqValue($("#issueMonth"))){
        Common.alert("<spring:message code='pay.alert.selectIssueMonth'/>");
        return;
    }
    
    //report form에 parameter 세팅
	var issueMonth = $("#issueMonth").val().split("/");
	
    if($("#reportType").val() == 1){
        $("#reportPDFForm #reportFileName").val('/bill/AdvanceBill.rpt');
    }else{
    	$("#reportPDFForm #reportFileName").val('/bill/VoidedBill.rpt');
    }
    
    $("#reportPDFForm #v_billYear").val(issueMonth[1] );    
    $("#reportPDFForm #v_billMonth").val(issueMonth[0]);
    
    //report 호출
    var option = {
            isProcedure : true, // procedure 로 구성된 리포트 인경우 필수.
    };

    Common.report("reportPDFForm", option);
}

</script>

<!-- content start -->
<section id="content">
    <ul class="path">
        <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
        <li>Billing</li>
        <li>Billing Raw Data</li>
    </ul>

    <!-- title_line start -->
    <aside class="title_line">
        <p class="fav"><a href="#" class="click_add_on">My menu</a></p>
        <h2>Billing Raw Data</h2>        
        <ul class="right_btns">            
            <li><p class="btn_blue2"><a href="javascript:fn_generate();"><spring:message code='pay.btn.generate'/></a></p></li>
        </ul>
    </aside>
    <!-- title_line end -->

    <!-- search_table start -->
    <section class="search_table">
        <form name="searchForm" id="searchForm"  method="post">
            <table class="type1"><!-- table start -->
                <caption>table</caption>
                <colgroup>
                    <col style="width:140px" />
                    <col style="width:*" />                                 
                </colgroup>
                <tbody>
                    <tr>
                        <th scope="row">Report Type</th>
                        <td >
                            <select id="reportType" name="reportType" class="w100p"></select>
                        </td>                        
                    </tr>
                    <tr>
                        <th scope="row">Issue Month</th>
                        <td>                            
                            <input type="text" id="issueMonth" name="issueMonth" class="j_date2 w100p" />                           
                        </td>               
                    </tr>                    
                </tbody>
            </table>
            <!-- table end -->            
        </form>
    </section>
    <!-- search_table end -->
</section>
<!-- content end --> 
<form name="reportPDFForm" id="reportPDFForm"  method="post">
    <input type="hidden" id="reportFileName" name="reportFileName" value="" />
    <input type="hidden" id="viewType" name="viewType" value="EXCEL" />    
    <input type="hidden" id="v_billYear" name="v_billYear" />
    <input type="hidden" id="v_billMonth" name="v_billMonth"/>
    
</form>
