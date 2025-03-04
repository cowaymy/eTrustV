<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<head>
<script type="text/javaScript" language="javascript">

  $(document).ready(function(){
      $('#txtCustName_RW').text($('#name').val());
      $('#txtCustNRIC_RW').text($('#nric').val());
      // Product
      if(FormUtil.isNotEmpty($('#ordProduct1 option:selected').val().trim())) {
    	  $('#txtProduct_RW1').text($("#ordProduct1 option:selected").text());
    	  $('#txtPromotion_RW1').text($("#ordPromo1 option:selected").text());
      }
      $('#txtMemberCode_RW').text($('#salesmanCd').val());
      $('#txtMemberName_RW').text($('#salesmanNm').val());

      if ($("#compType1 option:selected").val() != undefined) {
          if ($("#compType1 option:selected").val() != "") {
              $('#trAddCmpt1').removeClass("blind");
              $('#txtAddCmpt_RW1').text($("#compType1 option:selected").text());
          }
      }

      if($('input:radio[name="advPay"]:checked').val() == 1) {
          $('#tr1').removeClass("blind");
          $('#txtAdvPayment_RW').text('YES');
      }
  });

  $(function(){
      $('#btnConfirm_RW').click(function() {
	      console.log('!@# fn_doSaveOrder before call');

	      if(fn_checkProductQuota()) return false;
	      fn_doSaveOrder();
      });
  });

</script>
</head>
<body>

<div id="popup_wrap" class="popup_wrap size_small"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="sal.page.title.ordView" /></h1>
<ul class="right_opt">
	<li><p class="btn_blue2"><a href="#" id="btnCnfmOrderClose"><spring:message code="sal.btn.close" /></a></p></li>
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
	<td><span id="txtCustName_RW"></span></td>
</tr>
<tr>
	<th scope="row"><spring:message code="sal.text.nric" /></th>
	<td><span id="txtCustNRIC_RW"></span></td>
</tr>
<tr>
	<th scope="row">Product</th>
	<td><span id="txtProduct_RW1"></span></td>
</tr>
<tr id="trAddCmpt1" class="blind">
	<th scope="row"><spring:message code="sal.text.AddCmpt" /></th>
	<td><span id="txtAddCmpt_RW1"></span></td>
</tr>
<tr>
	<th scope="row"><spring:message code="sal.title.text.promo" /></th>
	<td><span id="txtPromotion_RW1"></span></td>
</tr>
<tr>
	<th scope="row"><spring:message code="sal.text.hpCodyCd" /></th>
	<td><span id="txtMemberCode_RW"></span></td>
</tr>
<tr>
	<th scope="row"><spring:message code="sal.text.hpCodyNm" /></th>
	<td><span id="txtMemberName_RW"></span></td>
</tr>
<tr id="tr1" class="blind">
	<th scope="row"><spring:message code="sal.text.advPay" /></th>
	<td><span id="txtAdvPayment_RW"></span></td>
</tr>
</tbody>
</table><!-- table end -->

<ul class="center_btns">
	<li><p><span style="line-height:34px;"><spring:message code="sal.msg.ordRegDtl" /></span></p></li>
	<li><p class="btn_blue2 big"><a id="btnConfirm_RW" href="#"><spring:message code="sal.btn.ok" /></a></p></li>
<!--
	<li><p class="btn_blue2 big"><a id="btnBack_RW" href="#">Back</a></p></li>
-->
</ul>
</section><!-- pop_body end -->

</div><!-- popup_wrap end -->

</body>
</html>