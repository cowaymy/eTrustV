<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<script type="text/javaScript">

// 화면 초기화 함수 (jQuery 의 $(document).ready(function() {}); 과 같은 역할을 합니다.
$(document).ready(function(){
	
   
});

function fn_genDocument(){
	
	if(FormUtil.checkReqValue($('#V_PAYDATEFROM')) || FormUtil.checkReqValue($('#V_PAYDATETO'))){
		Common.alert('* Please key in the payment date (From & To).');
		return;
	}
   
	var option = {
            isProcedure : true, // procedure 로 구성된 리포트 인경우 필수.  => /payment/PaymentListing_Excel.rpt 는 프로시져로 구성된 파일임.
    };

    Common.report("searchForm", option);	
}
   
function fn_clear(){
    $("#searchForm")[0].reset();
}

</script>

<!-- content start -->
<section id="content">
    <ul class="path">
        <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
        <li>Payment</li>
        <li>Payment</li>
        <li>Daily Collection Raw</li>
    </ul>

    <!-- title_line start -->
    <aside class="title_line">
        <p class="fav"><a href="#" class="click_add_on">My menu</a></p>
        <h2>Daily Collection Raw</h2>
        <ul class="right_btns">
            <c:if test="${PAGE_AUTH.funcPrint == 'Y'}">
            <li><p class="btn_blue"><a href="javascript:fn_genDocument();"><spring:message code='pay.btn.generate'/></a></p></li>
            </c:if>
            <li><p class="btn_blue"><a href="javascript:fn_clear();"><span class="clear"></span><spring:message code='sys.btn.clear'/></a></p></li>
        </ul>
    </aside>
    <!-- title_line end -->

    <!-- search_table start -->
    <section class="search_table">
        <form name="searchForm" id="searchForm"  method="post">
            <input type="hidden" id="reportFileName" name="reportFileName" value="/payment/DailyCollectionReport_Excel.rpt" />
            <input type="hidden" id="viewType" name="viewType" value="EXCEL" />
            <table class="type1"><!-- table start -->
                <caption>table</caption>
				<colgroup>
				    <col style="width:150px" />
				    <col style="width:300px" />
				    <col style="width:*" /> 				   		    
				</colgroup>
				<tbody>
				    <tr>
				        <th scope="row">Payment Date</th>
					    <td>
					           <div class="date_set  w100p"><!-- date_set start -->
					           <p><input id="V_PAYDATEFROM" name="V_PAYDATEFROM" type="text" title="Pay start Date" placeholder="DD/MM/YYYY" class="j_date" readonly />					               
					           </p>
					           <span>~</span>
					           <p><input id="V_PAYDATETO" name="V_PAYDATETO"  type="text" title="Pay end Date" placeholder="DD/MM/YYYY" class="j_date" readonly  /></p>
					           </div><!-- date_set end -->
					    </td>
					    <td>
					    </td>
                    </tr>
                </tbody>
            </table>
            <!-- table end -->            
        </form>
    </section>
    <!-- search_table end -->
</section>
