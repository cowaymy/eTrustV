<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@3.3.7/dist/css/bootstrap.min.css" integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">
<script type="text/javascript" language="javascript">
$(document).ready(function(){
	$('#value').val('');

	var styleSheets = document.styleSheets;
	var href = 'https://cdn.jsdelivr.net/npm/bootstrap@3.3.7/dist/css/bootstrap.min.css';
	for (var i = 0; i < styleSheets.length; i++) {
		if (styleSheets[i].href != href) {
	        styleSheets[i].disabled = true;
		}
	}
	//getData();
	$('.bottom_msg_box').hide();
});

function getData(){
    Common.ajax("GET","/payment/mobileLumpSumPayment/selectLumpSumReceiptData.do?key=" + "${key}",null, function(result){
        console.log(result);

    });
}
</script>
<div class="container">
<div style="width:1200px">
        <div>
            <img src="../../resources/images/common/coway_header.png" width="380" height="80">
        </div>
        <br><br>

        <table style="width:1200px;font-family:Calibri;font-size:14px">
            <colgroup>
                <col style="width:15%"/>
                <col style="width:60%; padding-right: 50px"/>
                <col style="width:10%"/>
                <col style="width:15%; align:right"/>
            </colgroup>
            <tr>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td colspan="2" style="text-align:center;color:white;background-color:black;font-weight:bold;padding-left:5px;padding-right:5px;padding-top:3px;padding-bottom:3px">E-Temporary Receipt</td>
            </tr>
            <tr>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
            </tr>
            <tr>
                <td style="font-weight:bold">Received from </td>
                <td>: ${info.custName}</td>
                <td style="font-weight:bold">Receipt Date </td>
                <td>: ${info.crtDt}</td>
            </tr>
        </table>
        <br><br>

        <table style="width:1200px;font-family:Calibri;font-size:14px;border-collapse:collapse">
            <tr style="background-color:black;font-weight:bold;color:white">
                <th scope="col" style="border:1px solid black;padding-left:10px;text-align:left">Order No.</th>
                <th scope="col" style="border:1px solid black;padding-left:10px;text-align:left">Product Model</th>
                <th scope="col" style="border:1px solid black;padding-left:10px;text-align:left">Pay Type</th>
                <th scope="col" style="border:1px solid black;padding:0 10px 0 10px;text-align:center">Amount (RM)</th>
            </tr>
			${info.orderListTableInfo}
            <tr>
                <td colspan="3" style="border:1px solid">&nbsp;</td>
                <td style="border:1px solid;text-align:center">${info.totPayAmt}</td>
            </tr>
        </table>
        <br>
        <br>
        <div>
        		<p><b>Collector Name:</b> ${info.crtUserFullName}</p>
        		<p><b>Collector Code:</b> ${info.crtUserName}</p>
                <p><b>Note:</b> Thank you for your payment. Your payment records shall be updated within 3 working days upon verification.</p>
        </div>
    </div>
</div>