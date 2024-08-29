<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<head>
<script type="text/javaScript" language="javascript">

	$(function(){
	    $('#btnRWok').click(function() {
	        fn_onClickBtnRWok();
	    });
        $('#rwMainPwpOrder').keydown(function (event) {
            if (event.which === 13) {    //enter
                fn_onClickBtnRWok();
                return false;
            }
        });
	});

	function fn_onClickBtnRWok() {
        $('#lblMainPwpOrderNo').text('');
        $('#txtMainPwpOrderID').val('');

        if(FormUtil.checkReqValue($('#rwMainPwpOrder'))) {
            $('#lblMainPwpOrderNo').text('* Please key in main order no.');
            return;
        }

        console.log('/sales/order/checkPwpOrderId.do CALL START');
        console.log('param salesOrdId:'+$('#pwpNo').val());
        console.log('param custId:'+$('#custId').val());

        Common.ajax("GET", "/homecare/sales/order/checkPwpOrderId.do", {salesOrdNo : $('#rwMainPwpOrder').val(), custId : $('#custId').val()}, function(RESULT) {

            $('#pwpNo').val($('#rwMainPwpOrder').val());
            $('#txtMainPwpOrderID').val(RESULT.mainOrderId);

            if(RESULT.ispass == true){
            	Common.confirm('<spring:message code="sal.alert.msg.cnfrmToSave" />', fn_popOrderDetail(),fn_apprvPopClose());

            }else{
            	$('#rwMainPwpOrder').clearForm();
                $('#lblMainPwpOrderNo').text(RESULT.msg);
            }
        });
	}

	function fn_apprvPopClose() {
	    $('#mainPwpOrderCloseBtn').click();
	}

	$(document).ready(function(){
        $('#rwMainPwpOrder').val($('#pwpNo').val());
    });

</script>
</head>
<body>

<div id="popup_wrap" class="popup_wrap size_small"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Please Key In Main Order</h1>
<ul class="right_opt">
	<li><p class="btn_blue2"><a id="mainPwpOrderCloseBtn" href="#"><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->
<form action="#" method="post">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:110px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row">Main Order No.</th>
	<td>
	<input id="rwMainPwpOrder" name="rwMainPwpOrder" type="text" title=""  placeholder="" class="w100p readonly" readonly/>
	</td>
</tr>
</tbody>
</table><!-- table end -->

<ul class="left_btns mb10">
	<li><p><span id="lblMainPwpOrderNo" class="red_text"></span></p></li>
</ul>

<ul class="center_btns">
	<li><p class="btn_blue2 big"><a id="btnRWok" href="#"><spring:message code="sal.btn.ok" /></a></p></li>
</ul>

</form>
</section><!-- pop_body end -->

</div><!-- popup_wrap end -->

</body>
</html>