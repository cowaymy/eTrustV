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
                var msg = "* Please key in the Order Qty";
                Common.alert("Save Sales Order Summary" + DEFAULT_DELIMITER + "<b>"+msg+"</b>");
                return false;
            }
            if($('#_copyQty').val() <= 1) {
                var msg = "* Please key in a number greater than 1";
                Common.alert("Save Sales Order Summary" + DEFAULT_DELIMITER + "<b>"+msg+"</b>");
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
<h1>New Order(Bulk)</h1>
<ul class="right_opt">
	<li><p class="btn_blue2"><a href="#" id="btnCnfmOrderClose">CLOSE</a></p></li>
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
	<th scope="row">Customer Name</th>
	<td><input id="_custNm" name="custNm" type="text" value="${orderInfo.custName}" title="" placeholder="" class="w100p readonly" readonly/></td>
</tr>
<tr>
	<th scope="row">Application Type</th>
	<td><input id="_appType" name="appType" type="text" value="${orderInfo.appTypeDesc}" title="" placeholder="" class="w100p readonly" readonly/></td>
</tr>
<tr>
	<th scope="row">Order Copy Qty</th>
	<td><input id="_copyQty" name="copyQty" type="text" title="" placeholder="Order Copy Qty" class="w100p" onkeydown="return FormUtil.onlyNumber(event)"/></td>
</tr>
</tbody>
</table><!-- table end -->
</form>
<ul class="center_btns">
	<li><p class="btn_blue2 big"><a id="btnBulk" href="#">Ok</a></p></li>
</ul>
</section><!-- pop_body end -->

</div><!-- popup_wrap end -->

</body>
</html>