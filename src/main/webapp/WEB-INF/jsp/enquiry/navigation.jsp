<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<script>
$(function(){
	let custSession = sessionStorage.getItem("cust");

	$('#home').click(function(evt) {
		sessionStorage.setItem("cust", "0");
	});
	$('#logout').click(function(evt) {
        sessionStorage.setItem("cust", "0");
    });

	if(custSession == 0){
		 window.top.Common.showLoader();
         window.top.location.href = '/enquiry/trueaddress.do';
	}

});
</script>

<nav class="navbar navbar-expand-lg navbar-dark" style="background-color:#B1D4E7;">
    <a class="navbar-brand" href="javascript:void(0);">COWAY</a>
    <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarToggler8"
        aria-controls="navbarToggler8" aria-expanded="false" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="navbarToggler8" style=" float: right;">
        <ul class="navbar-nav">
            <li class="nav-item">
                <a class="nav-link" href="${pageContext.request.contextPath}/enquiry/trueaddress.do" id="home">Home</a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="${pageContext.request.contextPath}/enquiry/selectCustomerInfo.do" ja>Customer Info</a>
            </li>
        </ul>
        <ul class="nav navbar-nav navbar-right" >
           <li class="nav-item"><a class="nav-link" href="javascript:void(0);">Welcome , ${SESSION_INFO.custName}</a></li>
            <li class="nav-item"><a  class="nav-link"  href="${pageContext.request.contextPath}/enquiry/trueaddress.do" id="logout">Log Out</a></li>
      </ul>
    </div>
</nav>