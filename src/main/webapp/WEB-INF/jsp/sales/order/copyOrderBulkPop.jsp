<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<head>
<script type="text/javaScript" language="javascript">

	$(document).ready(function(){
        $('#_custNm').val($('#name').val());
        $('#_appType').val($('#appType option:selected').text());
	});
	
	$(function(){
	    $('#btnBulk').click(function() {
            if(FormUtil.checkReqValue($('#_copyQty'))) {
                var msg = '* <spring:message code="sal.alert.msg.plzKeyInOrdQty" />';
                Common.alert('<spring:message code="sal.alert.msg.saveSalOrdSum" />' + DEFAULT_DELIMITER + "<b>"+msg+"</b>");
                return false;
            }
            if($('#_copyQty').val() <= 1) {
                var msg = '* <spring:message code="sal.alert.msg.plzKeyInNum1" />';
                Common.alert('<spring:message code="sal.alert.msg.saveSalOrdSum" />' + DEFAULT_DELIMITER + "<b>"+msg+"</b>");
                return false;
            }
            else {
                $('#hiddenCopyQty').val($('#_copyQty').val());
                fn_preCheckSave();
                $('#btnCnfmOrderClose').click();
            }
	    });
	});

</script>
</head>
<body>

<div id="popup_wrap" class="popup_wrap size_small"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="sal.title.text.newOrderBulk" /></h1>
<ul class="right_opt">
	<li><p class="btn_blue2"><a href="#" id="btnCnfmOrderClose"><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->
<form id="frmCopyBulk" name="frmCopyBulk" action="#" method="post">
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:160px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row"><spring:message code="sal.text.custName" /></th>
	<td><input id="_custNm" name="custNm" type="text" value="${orderInfo.custName}" title="" placeholder="" class="w100p readonly" readonly/></td>
</tr>
<tr>
	<th scope="row"><spring:message code="sal.text.appType" /></th>
	<td><input id="_appType" name="appType" type="text" value="${orderInfo.appTypeDesc}" title="" placeholder="" class="w100p readonly" readonly/></td>
</tr>
<tr>
	<th scope="row"><spring:message code="sal.text.ordCopyQty" /></th>
	<td><input id="_copyQty" name="copyQty" type="text" title="" placeholder="Order Copy Qty" class="w100p" onkeydown="return FormUtil.onlyNumber(event)"/></td>
</tr>
</tbody>
</table><!-- table end -->
</form>
<ul class="center_btns">
	<li><p class="btn_blue2 big"><a id="btnBulk" href="#"><spring:message code="sal.btn.ok" /></a></p></li>
</ul>
</section><!-- pop_body end -->

</div><!-- popup_wrap end -->

</body>
</html>