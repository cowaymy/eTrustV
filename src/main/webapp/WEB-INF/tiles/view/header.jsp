<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

	<!-- main 업무 팝업인 경우 class="solo"로 top, left 안보이게 처리 -->
	<div id="wrap" <c:if test="${param.isPop}"> class="solo" </c:if>><!-- wrap start -->

	<header id="header"><!-- header start -->
	<ul class="left_opt">
	    <li>Neo(Mega Deal): <span>2394</span></li> 
	    <li>Sales(Key In): <span>9304</span></li> 
	    <li>Net Qty: <span>310</span></li>
	    <li>Outright : <span>138</span></li>
	    <li>Installment: <span>4254</span></li>
	    <li>Rental: <span>4702</span></li>
	    <li>Total: <span>45080</span></li>
	</ul>
	<ul class="right_opt">
	    <li>Login as <span>KRHQ9001-HQ</span></li>
	    <li><a href="#" class="logout">Logout</a></li>
	    <li><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/top_btn_home.gif" alt="Home" /></a></li>
	    <li><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/top_btn_set.gif" alt="Setting" /></a></li>
	</ul>
	</header><!-- header end -->
	
	<hr />        
        
<script type="text/javascript">
    
   /*  $(function() {
    	
    }); */

</script>
    
    

