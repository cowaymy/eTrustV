<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<style>
@font-face {
  font-family: Avenir;
  src: url(/resources/font/Avenir.ttc);
}
</style>

<script>
$(document).ready(function() {
	  var status = ${data.status};
	  var payId = ${data.payId};

	  $('#status').val(status);
	  $('#payId').val(payId);

});
</script>

<div id="respond" class="respondPage">
    <h1 id="status"></h1>
    <h1 id="payId"></h1>
</div>