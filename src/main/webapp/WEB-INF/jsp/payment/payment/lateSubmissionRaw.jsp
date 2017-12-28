<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<script type="text/javaScript">


// 화면 초기화 함수 (jQuery 의 $(document).ready(function() {}); 과 같은 역할을 합니다.
$(document).ready(function(){
	
   
});

function fn_genDocument(){
	
	if(FormUtil.checkReqValue($('#V_INPUTDATE'))){
		Common.alert('* Please select the input month.');
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
    </ul>

    <!-- title_line start -->
    <aside class="title_line">
        <p class="fav"><a href="#" class="click_add_on"><spring:message code='pay.text.myMenu'/></a></p>
        <h2>Late Submission Raw</h2>
        <ul class="right_btns">
            <c:if test="${PAGE_AUTH.funcPrint == 'Y'}">
                <li><p class="btn_blue"><a href="javascript:fn_genDocument();"><spring:message code='pay.btn.createBills'/></a></p></li>
            </c:if>
            <li><p class="btn_blue"><a href="javascript:fn_clear();"><span class="clear"></span><spring:message code='sys.btn.clear'/></a></p></li>
        </ul>
    </aside>
    <!-- title_line end -->

    <!-- search_table start -->
    <section class="search_table">
        <form name="searchForm" id="searchForm"  method="post">
            <input type="hidden" id="reportFileName" name="reportFileName" value="/payment/PaymentLateSubmitList.rpt" />                                                                                                                              
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
				        <th scope="row">Input Month</th>
					    <td>
					           <input type="text" id="V_INPUTDATE" name="V_INPUTDATE"  title="InputMonth" placeholder="MM/YYYY" class="j_date2" />
					    </td>
					    <td></td>
                    </tr>
                </tbody>
            </table>
            <!-- table end -->            
        </form>
    </section>
    <!-- search_table end -->
</section>
