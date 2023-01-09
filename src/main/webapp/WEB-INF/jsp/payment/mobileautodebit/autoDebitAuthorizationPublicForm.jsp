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
	getData();
	$('.bottom_msg_box').hide();
});

function getData(){
    Common.ajax("GET","/payment/mobileautodebit/selectAutoDebitFormData.do?key=" + "${key}",null, function(result){
        console.log(result);
        var custCrcInfo = result.customerCreditCardEnrollInfo;
		var mobileDetail = result.mobileAutoDebitDetail;
		var product = result.product;
		var signImg = result.signImg;
		$('#padId').val(mobileDetail.padId);
        $('#cust_name').text(mobileDetail.name);
        $('#cust_nric').text(mobileDetail.nric);
        $('#order_no').text(mobileDetail.salesOrdNo);
        if(product != null){
            $('#product_name').text(product.stkDesc);
        }
        $('#cardholder_name').text(custCrcInfo.custCrcOwner);
        $('#card_number').text(custCrcInfo.custOriCrcNo);
        $('#expiry_date').text(custCrcInfo.custCrcExpr);
        $('#card_type').text(custCrcInfo.cardType);
        $('#bank_name').text(custCrcInfo.issueBank);
        $('#nric_Code').text(mobileDetail.nric);
        $('#createdDate').text(mobileDetail.crtDt);

        if(signImg != null){
        	var img = 'data:image/jpg;base64,' + signImg;
            $('#sign_img').attr('src',img);
        }
    });
}

function fileDownload(){
	var padId = $('#padId').val();
    var whereSQL = "AND p0333m.PAD_ID = " + padId;
    $("#reportFileName").val("");
    $("#reportDownFileName").val("");
    $("#viewType").val("");

    $("#reportDownFileName").val("AutoDebitAuthorization_"+(new Date().getMonth()+1)+new Date().getFullYear());

    $("#searchForm #viewType").val("PDF");
    $("#searchForm #reportFileName").val("/payment/AutoDebitAuthorization.rpt");
    $("#searchForm #V_WHERESQL").val(whereSQL);

    var option = {
            isProcedure : false, // procedure 로 구성된 리포트 인경우 필수.
    };

    Common.report("searchForm", option);
}
</script>
	<div class="container">
		<form id="searchForm" action="#" method="post">
			<input type="hidden" id="reportFileName" name="reportFileName" value="" />
			<input type="hidden" id="viewType" name="viewType" value="" />
			<input type="hidden" id="reportDownloadFileName" name="reportDownloadFileName" value="" />
			<input type="hidden" id="V_WHERESQL" name="V_WHERESQL" value="" />
			<input type="hidden" id="value" name="value" value="" />
			<input type="hidden" id="padId" name="padId" value="" />
		</form>
		<div class="row">
			<div class="col-8 col-sm-8">
				<h3>Debit/Credit Card Auto Debit Authorisation</h3>
				<p>Customer &  Payment Information</p>
			</div>
			<div class="col-4 col-sm-4" style="padding-top: 10px;">
				<img width="200px" src="${pageContext.request.contextPath}/resources/images/common/CowayLogo.png"/>
			</div>
		</div>
		<hr style="border-top: 1px solid #000;">
		<div>
		<div style="float:right;">
			<button onclick="javascript:fileDownload()">Download PDF</button>
		</div>
			<table>
				<tbody>
				<tr>
					<td>
						<span>Customer Name</span>
					</td>
					<td>
						<span>: </span><span id="cust_name"></span>
					</td>
				</tr>
				<tr>
					<td>
						<span>Customer NRIC/Passport</span>
					</td>
					<td>
						<span>: </span><span id="cust_nric"></span>
					</td>
				</tr>
				<tr>
					<td>
						<span>Order Number</span>
					</td>
					<td>
						<span>: </span><span id="order_no"></span>
					</td>
				<tr>
					<td>
						<span>Product</span>
					</td>
					<td>
						<span>: </span><span id="product_name"></span>
					</td>
				</tr>
				<tr>
					<td>
						<span>Cardholder Name</span>
					</td>
					<td>
						<span>: </span><span id="cardholder_name"></span>
					</td>
				</tr>
				<tr>
					<td>
						<span>Card Number</span>
					</td>
					<td>
						<span>: </span><span id="card_number"></span>
					</td>
				</tr>
				<tr>
					<td>
						<span>Expiry Date</span>
					</td>
					<td>
						<span>: </span><span id="expiry_date"></span>
					</td>
				</tr>
				<tr>
					<td>
						<span>Card Type</span>
					</td>
					<td>
						<span>: </span><span id="card_type"></span>
					</td>
				</tr>
				<tr>
					<td>
						<span>Bank Name</span>
					</td>
					<td>
						<span>: </span><span id="bank_name"></span>
					</td>
				</tr>
				</tbody>
			</table>
		</div>
		<div style="margin-top:20px;">
			<table>
				<tbody>
					<tr>
						<td>
							<span>YES: Verification code </span><span id="nric_Code"></span>
						</td>
					</tr>
					<tr>
					<td>YES: I/We hereby authorize COWAY (MALAYSIA) SDN BHD (“the Company”) to debit/charge the my/our
Third-Party’s credit/debit card account for all payments due to the Company. In the event that I/we are using the Third Party’s credit/debit card, I/we undertake and agree that I/we have obtained the above stated Third Party Cardholder’s authorization and prior consent to debit/charge the Third Party credit/debit card account for all payments due to the Company.
YES: I/We confirm that all particulars stated above are true and accurate. I/We have read the Terms and Conditions stated in this
Selfcare portal and hereby agree to be bound by the said Terms and Conditions.</td>
					</tr>
				</tbody>
			</table>
		</div>
		<hr style="border-top: 1px solid #000;">
			<div>
				<span>Signature</span>
			</div>
		<div style="height:200px;display:flex;">
			<div style="align-self: flex-end;">
				<table>
					<tbody>
					<tr>
						<td>
							<img style="width:240px;" id="sign_img"  />
						</td>
					</tr>
						<tr>
							<td><span>Customer Signature:</span></td>
						</tr>
						<tr>
							<td><span>Date: </span><span id="createdDate"></span></td>
						</tr>
					</tbody>
				</table>
			</div>
		</div>
		<div style="margin-top:100px; margin-bottom:100px;">
		<hr style="border-top: 1px solid #000;">
			<h3>Terms & Condition</h1>
			<table>
				<tbody>
					<tr valign="top">
						<td>1.</td>
						<td>For the purpose of these Terms and Conditions, ‘Card Centre’ refers to the Company’s credit/debit card centre which processes debit/charge transactions on the Designated Card (hereinafter defined); 'Company' refers to Coway (Malaysia) Sdn Bhd (735420-H) (AJL931694); ‘Customer’ refers to the person or organisation renting the Company’s product(s) and/or service(s); ‘Designated Card’ refers to the credit/debit (as applicable) card, either belonging to the Customer or a Third Party (hereinafter defined), nominated by the Customer for the Services and accepted by the Company; ‘Payment Date’ refers to the date the Company debits/charges the Designated Card through its Card Centre as authorised by the Customer; ‘Services’ refers to the auto-debit bill payment services offered herein by the Company and accepted by the Customer; “Third Party” or “Third Party Cardholder” refers to a third party who has authorised the Customer to register his/her/its credit/debit card for the Services.</td>
					</tr>
					<tr valign="top">
						<td>2.</td>
						<td>
							<span>In consideration of the Company agreeing to accept the Customer’s authorisation to debit/charge the Designated Card for payments due to the Company, the Customer expressly declares and undertakes:</span>
							<table>
								<tbody>
									<tr valign="top">
										<td>i.</td>
										<td>to accept full responsibility for all transactions arising from the usage of the Designated Card towards the settlement of payments due to the Company;</td>
									</tr>
									<tr valign="top">
										<td>ii.</td>
										<td>to be bound by all rules imposed by the issuer of the Designated Card (the “Said Issuer”) for pre-authorized  debit and credit card transactions,and be responsible for all fees charged by the Said Issuer associated with the Services;</td>
									</tr>
									<tr valign="top">
										<td>iii.</td>
										<td>that where the Company approves the usage of a Third Party’s credit/debit card, the Customer has obtained the authorisation and prior consent of that Third Party to the use of the same for the Services; and further acknowledges that the Company shall not be obliged to inquire into whether the Third Party Cardholder has indeed authorized the Customer to use his/her/its credit/debit card;</td>
									</tr>
									<tr valign="top">
										<td>iv.</td>
										<td>if required by the Company, to produce the Third Party Cardholder/a written authorisation duly signed by the Third Party Cardholder for the Company’s verification;</td>
									</tr>
									<tr valign="top">
										<td>v.</td>
										<td>to notify the Company in writing of any changes, termination, loss or replacement of the Designated Card or cancellation of this authorisation at least one (1) month before next the payment due date. Such changes or cancellation will become effective only after the Company has duly acknowledged receipt of such notification;</td>
									</tr>
									<tr valign="top">
										<td>vi.</td>
										<td>to not hold the Company responsible, in any event or circumstance, for any fraud or negligence committed in using the Third Party’s credit/debit card wherein it is presumed by the Company that such usage is legitimate and permitted by the Third Party;</td>
									</tr>
									<tr valign="top">
										<td>vii.</td>
										<td>to indemnify and keep the Company indemnified against any claims, fines, losses, damages, costs and expenses which the Company may suffer or incur arising from the Customer’s authorisation to debit/charge the Designated Card’s account as aforesaid;</td>
									</tr>
									<tr valign="top">
										<td>viii.</td>
										<td>to allow the Company to appropriate a sufficient amount from the Designated Card’s account to settle any balance owing, at a later date, if the Company does not receive full payment due from the Customer by reason of insufficient funds in the </td>
									</tr>
								</tbody>
							</table>
						</td>
					</tr>
					<tr valign="top">
						<td>3.</td>
						<td><span>The Customer hereby expressly authorizes the Company to:-</span>
							<table>
								<tbody>
									<tr valign="top">
										<td>i.</td>
										<td>verify the information supplied in this self-care portal with the Said Issuer or any third parties (including the Third Party) as may be necessary;<br/> and</td>
									</tr>
									<tr valign="top">
										<td>ii.</td>
										<td>forward the Customer’s transactions, billings and other details to the Said Issuer and other relevant parties for and in connection with the Services.</td>
									</tr>
								</tbody>
							</table>
						</td>
					</tr>
					<tr valign="top">
						<td>4.</td>
						<td><span>The Customer further acknowledges and accept that:</span>
							<table>
								<tbody>
									<tr valign="top">
										<td>i.</td>
										<td>the Company shall not be responsible or liable for any claims, losses, damages, costs or expenses arising from the successful processing of the debit/charge or the unsuccessful processing of the debit/charge due to exceeding credit limits, insufficient funds in the Designated Card’s account, electricity failure, malfunction of computer or telecommunications systems or payment devices, or any other factors beyond the Company’s control;</td>

									</tr>
									<tr valign="top">
										<td>ii.</td>
										<td>the Company is only responsible for making arrangements to debit/charge the Designated Card’s account through its Card Centre as authorised by the Customer; and therefore, the Customer shall be solely responsible for resolving any problems or disputes arising from the processing of any debit/charge on the Designated Card’s account with the Said Issuer;</td>

									</tr>
									<tr valign="top">
										<td>iii.</td>
										<td>the Company may at its absolute discretion at any time suspend or terminate the Services without assigning any reasons by giving seven (7) days’ notice in writing;</td>

									</tr>
									<tr valign="top">
										<td>iv.</td>
										<td>the Company reserves the right at its absolute discretion to approve or reject the Customer’s application for the Services without assigning any reason whatsoever;</td>
									</tr>
									<tr valign="top">
										<td>v.</td>
										<td>payments due will only be deemed paid upon successful processing of the debit/charge by the Card Centre;</td>
									</tr>
									<tr valign="top">
										<td>vi.</td>
										<td>save for negligence on the part of the Company, the Company shall bear no liability or responsibility for losses or damages of any kind that the Customer may incur as a result of incorrect debits/charges to the Designated Card’s account;</td>
									</tr>
									<tr valign="top">
										<td>vii.</td>
										<td>The Customer’s primary obligations under the terms and conditions in the Sales Order Form to make monthly rental payment to the Company in a timely manner shall continue and shall not be waived, extended nor suspended in any manner whatsoever by the mere approval or agreement of the Company to provide the Services to the Customer;</td>
									</tr>
									<tr valign="top">
										<td>viii.</td>
										<td>Notwithstanding any of the foregoing provisions, the Customer agrees that the use of the Services is undertaken at his/her/its sole risk. The Customer hereby expressly assumes all the risk arising out of the Services or incidental to the use thereof and shall not hold the Company liable for any loss arising therefrom.</td>
									</tr>
									<tr valign="top">
										<td>ix.</td>
										<td>the Company reserves the right to vary or add to the Terms & Conditions set out herein at any time and from time to time when circumstances warrant without prior notice to the Customer;</td>
									</tr>
									<tr valign="top">
										<td>x.</td>
										<td>he/she/it is solely responsible to notify the Third Party of the Terms and Conditions herein and the Company is entitled to presume that the Third Party has agreed to be bound by the Terms and Conditions herein, where applicable.</td>
									</tr>
								</tbody>
							</table>
						</td>
					</tr>
					<tr valign="top">
						<td>5.</td>
						<td>The Customer shall allow a grace period of at least fourteen (14) days from receipt by the Company of the completed registration form for processing the application and activation of the Service.</td>
					</tr>
					<tr valign="top">
						<td>6.</td>
						<td>The Terms and Conditions herein shall be read in conjunction with the terms and conditions in the Sales Order Form or the Corporate Rental Agreement, as the case may be. In the event of any conflict, the terms and conditions in the Sales Order Form or the Corporate Rental Agreement, whichever applicable, shall prevail.</td>
					</tr>
				</tbody>
			</table>
		</div>
	</div>