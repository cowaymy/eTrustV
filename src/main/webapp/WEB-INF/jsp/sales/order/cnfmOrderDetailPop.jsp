<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<head>
<script type="text/javaScript" language="javascript">

	$(document).ready(function(){
/*
        this.txtCustName_RW.Text = this.txtCustName.Text.ToString();
        this.txtCustNRIC_RW.Text = this.txtCustIC.Text.ToString();
        this.txtProduct_RW.Text = this.cmbOrderProduct.Text.ToString();
        this.txtPromotion_RW.Text = this.cmbOrderPromo.Text.ToString();
        this.txtMemberName_RW.Text = this.txtOrderSalesmanName.Text.ToString();
        this.txtMemberCode_RW.Text = this.txtOrderSalesmanCode.Text.ToString();
        if (this.btnAdvPayYes.Checked)
        {
            this.tr1.Visible = true;
            this.txtAdvPayment_RW.Text = "YES";
        }
*/	    
        $('#txtCustName_RW').text($('#name').val());
        $('#txtCustNRIC_RW').text($('#nric').val());
        $('#txtProduct_RW').text($("#ordProudct option:selected").text());
        $('#txtPromotion_RW').text($("#ordPromo option:selected").text());
        $('#txtMemberCode_RW').text($('#salesmanCd').val());
        $('#txtMemberName_RW').text($('#salesmanNm').val());
        
        if($('input:radio[name="advPay"]:checked').val() == 1) {
            $('#tr1').removeClass("blind");
            $('#txtAdvPayment_RW').text('YES');
        }
	});
	
	$(function(){
	    $('#btnConfirm_RW').click(function() {
console.log('!@# fn_doSaveOrder before call');

//          Data.LoginInfo li = Session["login"] as Data.LoginInfo;
//          if (li != null) {
                fn_doSaveOrder()
//          }
//          else {
//              Common.confirm("Session Expired" + DEFAULT_DELIMITER + "<b>Your login session was expired. Please relogin to system.</b>");
//          }        

	    });
	});

</script>
</head>
<body>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Order View</h1>
<ul class="right_opt">
	<li><p class="btn_blue2"><a href="#" id="btnCnfmOrderClose">CLOSE</a></p></li>
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
	<th scope="row">Customer Name</th>
	<td><span id="txtCustName_RW"></span></td>
</tr>
<tr>
	<th scope="row">NRIC</th>
	<td><span id="txtCustNRIC_RW"></span></td>
</tr>
<tr>
	<th scope="row">Product</th>
	<td><span id="txtProduct_RW"></span></td>
</tr>
<tr>
	<th scope="row">Promotion</th>
	<td><span id="txtPromotion_RW"></span></td>
</tr>
<tr>
	<th scope="row">HP/Code Code</th>
	<td><span id="txtMemberCode_RW"></span></td>
</tr>
<tr>
	<th scope="row">HP/Code Name</th>
	<td><span id="txtMemberName_RW"></span></td>
</tr>
<tr id="tr1" class="blind">
	<th scope="row">Advance Payment</th>
	<td><span id="txtAdvPayment_RW"></span></td>
</tr>
</tbody>
</table><!-- table end -->

<ul class="center_btns">
	<li><p><span style="line-height:34px;">Double check data before save:</span></p></li>
	<li><p class="btn_blue2 big"><a id="btnConfirm_RW" href="#">Ok</a></p></li>
<!--
	<li><p class="btn_blue2 big"><a id="btnBack_RW" href="#">Back</a></p></li>
-->
</ul>
</section><!-- pop_body end -->

</div><!-- popup_wrap end -->

</body>
</html>