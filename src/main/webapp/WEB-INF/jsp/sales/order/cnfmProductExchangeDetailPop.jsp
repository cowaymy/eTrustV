<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<head>
<script type="text/javaScript" language="javascript">
var srvTypePexcFrom = "";
var srvTypePexcTo = "";

  $(document).ready(function(){
	  $('#txtCustNamePexc').text(CUST_NAME);
	  $('#txtOrderNumberPexc').text(ORD_NO);
	  $('#txtTypePexc').text('Product Exchange');
	  $('#txtReasonPexc').text($('#cmbReasonExch option:selected').text());
	  $('#txtProductFromPexc').text(STOCK_CDE + ' - ' + STOCK_DESC);
	  $('#txtProductToPexc').text($('#cmbOrderProduct option:selected').text());

	  $('#txtPromotionFromPexc').text(PROMO_CODE + ' - ' + PROMO_DESC);
	  $('#txtPromotionToPexc').text($('#cmbPromotion option:selected').text());

	  if(SRV_TYPE == 'SS'){
		  srvTypePexcFrom = 'Self Service';
	  }else{
		  srvTypePexcFrom = 'Heart Service';
	  }

	  if($(':radio[name="reqSrvType"]:checked').val() == 'SS'){
		  srvTypePexcTo = 'Self Service';
	  }else{
		  srvTypePexcTo = 'Heart Service';
	  }
	  $('#txtSrvTypeFromPexc').text(srvTypePexcFrom);
	  $('#txtSrvTypeToPexc').text(srvTypePexcTo);

  });

  $(function(){
	  $('#btnConfirmProductExchange').click(function() {
	        fn_doSaveReqPexc();
	    });
  });

</script>
</head>
<body>

<div id="popup_wrap" class="popup_wrap size_small"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="sal.alert.msg.prodExchSum" /></h1>
<ul class="right_opt">
	<li><p class="btn_blue2"><a href="#" id="btnCnfmProductExchangeClose"><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:160px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row"><spring:message code="sal.text.custName" /></th>
	<td><span id="txtCustNamePexc"></span></td>
</tr>
<tr>
	<th scope="row"><spring:message code="sal.text.ordNum" /></th>
	<td><span id="txtOrderNumberPexc"></span></td>
</tr>
<tr>
	<th scope="row"><spring:message code="sales.type" /></th>
	<td><span id="txtTypePexc"></span></td>
</tr>
<tr>
	<th scope="row"><spring:message code="sales.reason" /></th>
	<td><span id="txtReasonPexc"></span></td>
</tr>
<tr>
	<th scope="row"><spring:message code="sal.title.text.productFrom" /></th>
	<td><span id="txtProductFromPexc"></span></td>
</tr>
<tr>
	<th scope="row"><spring:message code="sal.title.text.productTo" /></th>
	<td><span id="txtProductToPexc"></span></td>
</tr>
<tr>
	<th scope="row"><spring:message code="sal.title.text.promotionFrom" /></th>
	<td><span id="txtPromotionFromPexc"></span></td>
</tr>
<tr>
	<th scope="row"><spring:message code="sal.title.text.promotionTo" /></th>
	<td><span id="txtPromotionToPexc"></span></td>
</tr>
<tr>
	<th scope="row"><spring:message code="sales.srvTypeFrom" /></th>
	<td><span id="txtSrvTypeFromPexc"></span></td>
</tr>
<tr>
	<th scope="row"><spring:message code="sales.srvTypeTo" /></th>
	<td><span id="txtSrvTypeToPexc"></span></td>
</tr>
</tbody>
</table><!-- table end -->

<ul class="center_btns">
	<li><p><span style="line-height:34px;"><spring:message code="sal.msg.ordRegDtl" /></span></p></li>
	<li><p class="btn_blue2 big"><a id="btnConfirmProductExchange" href="#"><spring:message code="sal.btn.ok" /></a></p></li>

</ul>
</section><!-- pop_body end -->

</div><!-- popup_wrap end -->

</body>
</html>