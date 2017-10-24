<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javascript">

</script>

<div id="popup_wrap" class="popup_wrap msg_box msg_big"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Investigation Result Confirmation</h1>
<p class="pop_close"><a href="#">close</a></p>
</header><!-- pop_header end -->

<form id="saveForm" name="saveForm" method="GET">

</form>
<section class="pop_body"><!-- pop_body start -->
<div class="msg_txt">
Order Number:<span>${salesOrdNo}</span><br />
This month is BS month for this order.<br />
Ticket of BS request will be send to cody divison automatically by system.<br />
<p class="input_area">
<label><input type="radio" name="ticket" /><span>Don't Send Ticket</span></label>
<label><input type="radio" name="ticket" /><span>Ticket Send</span></label><br />
</p><br />
Are you sure want to remain this order to status regular?
</div>
<ul class="center_btns">
    <li><p class="btn_blue2"><a href="#">YES</a></p></li>
</ul>
</section><!-- pop_body end -->

</div><!-- popup_wrap end -->