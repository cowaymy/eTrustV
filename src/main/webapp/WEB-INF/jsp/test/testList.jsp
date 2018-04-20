<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">

//Start AUIGrid --start Load Page- user 1st click Member
$(document).ready(function() {
	//$("#callPrgm").val("PRE_ORD");
});

function fn_testAgreement() {

	//console.log("callPrgm ====== " + $("#callPrgm").val());

	//Common.popupDiv("/test/customerRegistPop.do?isPop=true&callPrgm="+$("#callPrgm").val(), "testchewkk"  ,null , true  ,'fn_testchewkk');
}

</script>

<!-- --------------------------------------DESIGN------------------------------------------------ -->

<section id="content"><!-- content start -->

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>TEST Agreement</h2>
</aside><!-- title_line end -->

<section id = "body">
<p></p>
<p></p>
<p></p>
<p></p>
<p></p>
<iframe name = "testPdf" width = 100% height = "450px" src = "https://docs.google.com/viewerng/viewer?url=http://etrustdev.my.coway.com/resources/report/dev/agreement/CowayHealthPlannerAgreement.pdf&embedded=true" frameborder = "10"></iframe>

<ul class="right_btns">
    <li><p class="btn_blue"><a href="javascript:fn_testAgreement();">Accept</a></p></li>
    <li><p class="btn_blue"><a href="javascript:fn_testAgreement();">Reject</a></p></li>
</ul>

</section>

</section><!-- content end -->
