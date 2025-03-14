<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javaScript" language="javascript">
var custNricOri, bankAccOri;

    $(document).ready(function(){
    	$('#memInfo').hide();
    });

    function fn_searchOutStandView(){

    	if($('#ordNo').val() == ""){
    		Common.alert("<spring:message code='pay.alert.orderNumber.'/>");
    		return;
    	}

        Common.ajax("GET","/payment/selectOrderOutstandingView.do", $("#orderForm").serialize(), function(result){

            if(result.orderOutstandingView.length > 0){
            	$("#ledgerForm #ordId").val(result.orderOutstandingView[0].orderid);
            	$('#orderId').val(result.orderOutstandingView[0].orderid);
            	$('#custName').val(result.orderOutstandingView[0].customername);
            	$('#orderStatus').val(result.orderOutstandingView[0].orderstatus);
            	$('#appType').val(result.orderOutstandingView[0].apptype);
                $('#productName').val(result.orderOutstandingView[0].productname);
                $('#thirdPartyName').val(result.orderOutstandingView[0].thirdpartyname);
                $('#rentalPayMode').val(result.orderOutstandingView[0].rentalpaymode);
                $('#custVANo').val(result.orderOutstandingView[0].custvano);
                $('#jomPayRefNo1').val(result.orderOutstandingView[0].jompayrefno1);
                $('#outrightFees').val($.number(result.orderOutstandingView[0].outrightfees, 2));

                $('#rpfFees').val($.number(result.orderOutstandingView[0].rpffees, 2));
                $('#rpfPaid').val($.number(result.orderOutstandingView[0].rpfpaid, 2));
                $('#rentalFees').val($.number(result.orderOutstandingView[0].rentalfees, 2));
                $('#ASOutstanding').val($.number(result.orderOutstandingView[0].astotalamount, 2));
                $('#penaltyCharges').val($.number(result.orderOutstandingView[0].totalpenaltycharge, 2));
                $('#penaltyPaid').val($.number(result.orderOutstandingView[0].totalpenaltypaid, 2));
                $('#penaltyAdjustment').val($.number(result.orderOutstandingView[0].totalpenaltyadj, 2));
                $('#penaltyBalance').val($.number(result.orderOutstandingView[0].totalpenaltybal, 2));

                $('#unbillAmount').val($.number(result.orderOutstandingView[0].orderUnbillamt, 2));
                $('#totalOutstanding').val($.number(result.orderOutstandingView[0].orderTotaloutstanding, 2));
                $('#outstandingMonth').val($.number(result.orderOutstandingView[0].orderOutstandingmth, 2));

                var rentalGrandTotal = Number(0.00);
                rentalGrandTotal = result.orderOutstandingView[0].orderUnbillamt + result.orderOutstandingView[0].orderTotaloutstanding;
                $('#rentalGrandTotal').val($.number(rentalGrandTotal, 2));

                //SVM Quotation
                if(Number(result.orderOutstandingView[0].srvmemquotpackageamount) == 0 && Number(result.orderOutstandingView[0].srvmemquotid) == 0){
                	$('#svmQuotPacAmount').val("");
                }else{
                	$('#svmQuotPacAmount').val($.number(result.orderOutstandingView[0].srvmemquotpackageamount, 2));
                }

                if(Number(result.orderOutstandingView[0].srvmemquotfilteramount) == 0 && Number(result.orderOutstandingView[0].srvmemquotid) == 0){
                    $('#svmQuotFilterAmount').val("");
                }else{
                    $('#svmQuotFilterAmount').val($.number(result.orderOutstandingView[0].srvmemquotfilteramount, 2));
                }

                if(Number(result.orderOutstandingView[0].srvmemquottotalamount) == 0 && Number(result.orderOutstandingView[0].srvmemquottotalamount) == 0){
                    $('#svmQuotFilterAmount').val("");
                }else{
                    $('#svmQuotTotalAmount').val($.number(result.orderOutstandingView[0].srvmemquottotalamount, 2));
                }

                $('#svmQuotNo').val(result.orderOutstandingView[0].srvmemquotno);
                $('#svmQuotStatus').val(result.orderOutstandingView[0].srvmemquotstatus);
                $('#svmQuotCreateDate').val(result.orderOutstandingView[0].srvmemquotcreated);

                //SVM
                if(Number(result.orderOutstandingView[0].srvmempackageamount) == 0 && Number(result.orderOutstandingView[0].srvmemid) == 0){
                    $('#svmPacAmount').val("");
                }else{
                    $('#svmPacAmount').val($.number(result.orderOutstandingView[0].srvmempackageamount,2));
                }

                if(Number(result.orderOutstandingView[0].srvmemfilteramount) == 0 && Number(result.orderOutstandingView[0].srvmemid) == 0){
                    $('#svmFilterAmount').val("");
                }else{
                    $('#svmFilterAmount').val($.number(result.orderOutstandingView[0].srvmemfilteramount,2));
                }

                $('#svmStatus').val(result.orderOutstandingView[0].srvmemstatus);
                $('#svmValidDate').val(result.orderOutstandingView[0].srvmemvaliddate);


                if(Number(result.orderOutstandingView[0].srvmemduration) > 0){
                	$('#svmDuration').val(result.orderOutstandingView[0].srvmemduration);
                }else{
                	$('#svmDuration').val("");
                }
                $('#svmCreateDate').val(result.orderOutstandingView[0].srvmemcreated);
                $('#svmTotalOutstanding').val($.number(result.orderOutstandingView[0].outsvmoutstndtotal, 2));

                //(REN) SVM
                if(Number(result.orderOutstandingView[0].srvcontractpackageamount) == 0 && Number(result.orderOutstandingView[0].srvcontractid) == 0){
                    $('#srvContractPacAmount').val("");
                }else{
                    $('#srvContractPacAmount').val($.number(result.orderOutstandingView[0].srvcontractpackageamount, 2));
                }

                if(Number(result.orderOutstandingView[0].srvcontractfilteramount) == 0 && Number(result.orderOutstandingView[0].srvcontractid) == 0){
                    $('#srvContractFilterAmount').val("");
                }else{
                    $('#srvContractFilterAmount').val($.number(result.orderOutstandingView[0].srvcontractfilteramount,2));
                }

                $('#srvContractStatus').val(result.orderOutstandingView[0].srvcontractstatus);
                $('#srvContractValidDate').val(result.orderOutstandingView[0].srvcontractvaliddate);

                if(Number(result.orderOutstandingView[0].srvcontractduration) > 0){
                    $('#srvContractDuration').val(result.orderOutstandingView[0].srvcontractduration);
                }else{
                    $('#srvContractDuration').val("");
                }
                $('#srvContractCreateDate').val(result.orderOutstandingView[0].srvcontractcreated);
                $('#srvContractTotalOutstanding').val($.number(result.orderOutstandingView[0].srvcontracttotalamount, 2));

                $('#custId').val(result.orderOutstandingView[0].custid);
                $('#custType').val(result.orderOutstandingView[0].custtype);
                custNricOri = result.orderOutstandingView[0].custnric;

                // Masking nric (display last 4)
                if($('#custType').val() == "Individual") {

                	maskedNric = custNricOri.substr(-4).padStart(custNricOri.length, '*');
                	$("#spanNric").html(maskedNric);
                    // Appear NRIC on hover over field
                    $("#spanNric").hover(function() {
                        $("#spanNric").html(custNricOri);
                    }).mouseout(function() {
                        $("#spanNric").html(maskedNric);
                    });
                    $("#imgHover").hover(function() {
                        $("#spanNric").html(custNricOri);
                    }).mouseout(function() {
                        $("#spanNric").html(maskedNric);
                    });
                } else{
                	maskedNric = custNricOri;
                	$("#spanNric").html(custNricOri);
                }

                $('#rentalStus').val(result.orderOutstandingView[0].rentalstatus);
                $('#obligationPeriod').val(result.orderOutstandingView[0].obligationyear);
                $('#advDisc').val(result.orderOutstandingView[0].advancediscount);
                $('#memStus').val(result.orderOutstandingView[0].memstatus);


                if($('#memStus').val() != null){
                    $('#memInfo').show();
                } else{
                	$('#memInfo').hide();
                }

                bankAccOri = result.orderOutstandingView[0].bankaccno;
                if(bankAccOri != null && bankAccOri != ''){
                    maskedBankAcc = bankAccOri.substr(-4).padStart(bankAccOri.length, '*');
                    $("#spanBankAcc").html(maskedBankAcc);
                    $("#spanBankAcc").hover(function() {
                        $("#spanBankAcc").html(bankAccOri);
                    }).mouseout(function() {
                        $("#spanBankAcc").html(maskedBankAcc);
                    });
                    $("#imgHover2").hover(function() {
                        $("#spanBankAcc").html(bankAccOri);
                    }).mouseout(function() {
                        $("#spanBankAcc").html(maskedBankAcc);
                    });
                }
                else {
                    maskedBankAcc = bankAccOri;
                    $("#spanBankAcc").html(bankAccOri);
                }

                $('#memIssueBank').val(result.orderOutstandingView[0].bankname);
                $('#svmTotalOutstandingAmt').val($.number(result.orderOutstandingView[0].outsvmoutstndtotal, 2));
                $('#srvContractTotalOutstandingAmt').val($.number(result.orderOutstandingView[0].rensvmoutstndtotal,2));
            }else{
            	Common.alert("<spring:message code='pay.alert.enterValidOrderNo'/>");
            }

        });
    }

    //Ledger 1
    function viewRentalLedger(){
        if($("#ordId").val() != ''){
            Common.popupWin("ledgerForm", "/sales/order/orderLedgerViewPop.do", {width : "1000px", height : "720", resizable: "no", scrollbars: "no"});
        }else{
            Common.alert("<spring:message code='pay.alert.enterOrderNo'/>");
            return;
        }
    }

    //Ledger 2
    function viewRentalLedger2(){
        if($("#ordId").val() != ''){
            Common.popupWin("ledgerForm", "/sales/order/orderLedger2ViewPop.do", {width : "1000px", height : "720", resizable: "no", scrollbars: "no"});
        }else{
            Common.alert("<spring:message code='pay.alert.enterOrderNo'/>");
            return;
        }
    }

    //PaymentListing
    function viewOrderPaymentListing(){
        if($("#ordId").val() != ''){
            Common.popupWin("ledgerForm", "/payment/initOrderPaymentListingPop.do", {width : "1200px", height : "720", resizable: "no", scrollbars: "no"});
        }else{
            Common.alert("<spring:message code='pay.alert.enterOrderNo'/>");
            return;
        }
    }

    //ASListing
    function viewASListing(){
        if($("#ordId").val() != ''){
            Common.popupWin("ledgerForm", "/payment/initOrderASListingPop.do", {width : "1200px", height : "720", resizable: "no", scrollbars: "no"});
        }else{
            Common.alert("<spring:message code='pay.alert.enterOrderNo'/>");
            return;
        }
    }

    //QuotationListing
    function viewQuotationListing(){
        if($("#ordNo").val() != ''){
            Common.popupDiv('/sales/payPop/quotationListPop.do', {"ordNo": $("#ordNo").val()}, null , true , null);
        }else{
            Common.alert("<spring:message code='pay.alert.enterOrderNo'/>");
            return;
        }
    }

    //Outright Membership
    function viewOutrightMrsh(){
        if($("#ordNo").val() != ''){
        	Common.popupDiv('/sales/payPop/membershipListPop.do', {"ordNo": $("#ordNo").val()}, null , true , null);
        }else{
            Common.alert("<spring:message code='pay.alert.enterOrderNo'/>");
            return;
        }
    }

    //Rental Membership
    function viewRentalMrsh(){
        if($("#ordNo").val() != ''){
        	Common.popupDiv('/sales/payPop/rentalMembershipListPop.do', {"ordNo": $("#ordNo").val()}, null , true , null);
        }else{
            Common.alert("<spring:message code='pay.alert.enterOrderNo'/>");
            return;
        }
    }

    //Transfer History
    function viewTransferHistory(){
        if($("#ordNo").val() != ''){
        	Common.popupDiv('/sales/payPop/transferHistoryListPop.do', {"ordNo": $("#ordNo").val()}, null , true , null);
        }else{
            Common.alert("<spring:message code='pay.alert.enterOrderNo'/>");
            return;
        }
    }

    //View HP and Cody List
    function viewHPCody(){
        if($("#ordNo").val() != ''){
            Common.popupDiv('/sales/payPop/viewHPCodyList.do', {"salesOrderId": $("#ordId").val()}, null , true , null);
        }else{
            Common.alert("<spring:message code='pay.alert.enterOrderNo'/>");
            return;
        }
    }

    // Grouping Order
    function viewGroupOrder(){
        if($("#ordNo").val() != ''){
            Common.popupDiv('/sales/payPop/viewGroupOrdList.do', {"ordNo": $("#ordNo").val()}, null , true , null);
        }else{
            Common.alert("<spring:message code='pay.alert.enterOrderNo'/>");
            return;
        }
    }

    // Billing Schedule
    function viewBillSchedule(){
        if($("#ordNo").val() != ''){
            Common.popupDiv('/sales/payPop/viewBillScheduleList.do', {"ordId": $("#ordId").val()}, null , true , null);
        }else{
            Common.alert("<spring:message code='pay.alert.enterOrderNo'/>");
            return;
        }
    }

    function fn_clear(){
    	$("#orderForm")[0].reset();
    	$("#ledgerForm")[0].reset();
    	bankAccOri = null;
    	custNricOri = null;

    	$("#spanBankAcc").html(bankAccOri);
    	$("#spanNric").html(custNricOri);
    }

</script>
<div id="popup_wrap" class="popup_wrap pop_win"><!-- popup_wrap start -->
	<header class="pop_header"><!-- pop_header start -->
	<h1>Order Summary Page</h1>
	<ul class="right_opt">
		<li><p class="btn_blue2"><a href="#" onclick="window.close()"><spring:message code='sys.btn.close'/></a></p></li>
	</ul>
	</header><!-- pop_header end -->
	<section class="pop_body"><!-- pop_body start -->
	    <form action="#" method="post" id="orderForm">
	        <input type="hidden" id="orderId" name="orderId">
			<table class="type1"><!-- table start -->
				<caption>table</caption>
				<colgroup>
				    <col style="width:150px" />
				    <col style="width:*" />
				    <col style="width:130px" />
				    <col style="width:*" />
				    <col style="width:130px" />
				    <col style="width:*" />
				    <col style="width:150px" />
				    <col style="width:*" />
				</colgroup>
				<tbody>
					<tr>
					    <th scope="row">ORDER NUMBER</th>
					    <td colspan="3">
						    <input type="text" title="" placeholder="Order Number" class="" id="ordNo" name="ordNo"/>
						    <p class="btn_sky"><a href="javascript:fn_searchOutStandView();"><spring:message code='sys.btn.search'/></a></p>
						    <p class="btn_sky"><a href="javascript:fn_clear();"><spring:message code='sys.btn.clear'/></a></p>
					    </td>
					    <th scope="row">Application Type</th>
                        <td>
                            <input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" id="appType" name="appType"/>
                        </td>
					    <th scope="row">Order Status</th>
					    <td>
					        <input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" id="orderStatus" name="orderStatus" />
					    </td>
					</tr>
					<tr>
					    <th scope="row">Summary</th>
					    <td colspan="7">
						    <p class="btn_sky"><a href="javascript:viewRentalLedger();"><spring:message code='pay.btn.viewLedger1'/></a></p>
						    <p class="btn_sky"><a href="javascript:viewRentalLedger2();"><spring:message code='pay.btn.viewLedger2'/></a></p>
						    <p class="btn_sky"><a href="javascript:viewOrderPaymentListing();"><spring:message code='pay.btn.paymentListing'/></a></p>
						    <p class="btn_sky"><a href="javascript:viewQuotationListing();"><spring:message code='pay.btn.quotationListing'/></a></p>
						    <p class="btn_sky"><a href="javascript:viewOutrightMrsh();"><spring:message code='pay.btn.outrightMembership'/></a></p>
						    <p class="btn_sky"><a href="javascript:viewRentalMrsh();"><spring:message code='pay.btn.rentalMembership'/></a></p>
						    <p class="btn_sky"><a href="javascript:viewASListing();"><spring:message code='pay.btn.asListing'/></a></p>
						    <p class="btn_sky"><a href="javascript:viewTransferHistory();"><spring:message code='pay.btn.transferHistory'/></a></p>
						    <p class="btn_sky"><a href="javascript:viewHPCody();">HP/Cody</a></p>
                            <p class="btn_sky"><a href="javascript:viewGroupOrder();">Grouping Order</a></p>
                            <p class="btn_sky"><a href="javascript:viewBillSchedule();">Billing Schedule</a></p>

					    </td>
					</tr>
					<tr>
                        <th scope="row">NRIC/Company No</th>
                         <td><a href="#" class="search_btn" id="imgHover"><img style="height:70%" src="${pageContext.request.contextPath}/resources/images/common/nricEye2.png" /></a>
                         <span id="spanNric"></span>
                        </td>
                        <th scope="row">Customer ID</th>
                        <td>
                            <input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" id="custId" name="custId"/>
                        </td>
                        <th scope="row">Customer Name</th>
                        <td>
                            <input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" id="custName" name="custName"/>
                        </td>
                        <th scope="row">Customer Type</th>
                        <td>
                            <input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" id="custType" name="custType"/>
                        </td>
                    </tr>
					<tr>
					    <th scope="row">Product</th>
					    <td>
					        <input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" id="productName" name="productName"/>
					    </td>
					    <th scope="row">*Pay by 3rd Party Name</th>
					    <td>
					        <input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" id="thirdPartyName" name="thirdPartyName"/>
					    </td>
					    <th scope="row">Rental Status</th>
                        <td>
                            <input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" id="rentalStus" name="rentalStus"/>
                        </td>
					    <th scope="row">Rental Paymode</th>
					    <td>
					        <input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" id="rentalPayMode" name="rentalPayMode"/>
					    </td>
					</tr>
					<tr>
					    <th scope="row">VA Number</th>
					    <td>
					        <input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" id="custVANo" name="custVANo"/>
					    </td>
					    <th scope="row">JOMPay Ref 1</th>
					    <td>
					        <input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" id="jomPayRefNo1" name="jomPayRefNo1"/>
					    </td>
					    <th scope="row">Outright Fees</th>
					    <td colspan="3">
					        <input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" id="outrightFees" name="outrightFees"/>
					    </td>
					</tr>
					<tr>
                        <th scope="row">Eligible Advance Disc</th>
                        <td colspan="3">
                            <input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" id="advDisc" name="advDisc"/>
                        </td>
                        <th scope="row">Obligation Period</th>
                        <td colspan="3">
                            <input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" id="obligationPeriod" name="obligationPeriod"/>
                        </td>
                    </tr>
				</tbody>
			</table><!-- table end -->

<div id=memInfo>
			<aside class="title_line"><!-- title_line start -->
            <h3>Member Info </h3>
            </aside><!-- title_line end -->
			 <table class="type1"><!-- table start -->
                <caption>table</caption>
                <colgroup>
                    <col style="width:150px" />
                    <col style="width:*" />
                    <col style="width:130px" />
                    <col style="width:*" />
                    <col style="width:130px" />
                    <col style="width:*" />
                    <col style="width:150px" />
                    <col style="width:*" />
                </colgroup>
                <tbody>
                    <tr>
                        <th scope="row">Member Status</th>
                        <td>
                            <input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" id="memStus" name="memStus"/>
                        </td>
                        <th scope="row">Bank Acc No</th>
                        <td><a href="#" class="search_btn" id="imgHover2"><img style="height:70%" src="${pageContext.request.contextPath}/resources/images/common/nricEye2.png" /></a>
                         <span id="spanBankAcc"></span>
                                                 </td>
                        <th scope="row">Issue Bank</th>
                        <td colspan="3">
                            <input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" id="memIssueBank" name="memIssueBank"/>
                        </td>
                    </tr>
                </tbody>
            </table>
</div>
			<aside class="title_line"><!-- title_line start -->
			<h3>Outstanding </h3>
			</aside><!-- title_line end -->

			<table class="type1"><!-- table start -->
				<caption>table</caption>
				<colgroup>
				    <col style="width:150px" />
				    <col style="width:*" />
				    <col style="width:130px" />
				    <col style="width:*" />
				    <col style="width:130px" />
				    <col style="width:*" />
				    <col style="width:150px" />
				    <col style="width:*" />
				</colgroup>
				<tbody>
					<tr>
					    <th scope="row">RPF Fees</th>
					    <td>
					        <input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" id="rpfFees" name="rpfFees"/>
					    </td>
					    <th scope="row">RPF Paid</th>
					    <td>
					        <input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" id="rpfPaid" name="rpfPaid"/>
					    </td>
					    <th scope="row">Rental Fees</th>
					    <td>
					        <input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" id="rentalFees" name="rentalFees"/>
					    </td>
					    <th scope="row">AS O/S</th>
					    <td>
					        <input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" id="ASOutstanding" name="ASOutstanding"/>
					    </td>
					</tr>
					<tr>
					    <th scope="row">Penalty Charge</th>
					    <td>
					        <input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" id="penaltyCharges" name="penaltyCharges"/>
					    </td>
					    <th scope="row">Penalty Paid</th>
					    <td>
					        <input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" id="penaltyPaid" name="penaltyPaid"/>
					    </td>
					    <th scope="row">Penalty Adjustment</th>
					    <td>
					        <input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" id="penaltyAdjustment" name="penaltyAdjustment"/>
					    </td>
					    <th scope="row">Balance Penalty</th>
					    <td>
					        <input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" id="penaltyBalance" name="penaltyBalance"/>
					    </td>
					</tr>
					<tr>
					    <th scope="row">Unbill Amount</th>
					    <td>
					        <input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" id="unbillAmount" name="unbillAmount" />
					    </td>
					    <th scope="row">Total O/S Balance</th>
					    <td>
					        <input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" id="totalOutstanding" name="totalOutstanding"/>
					    </td>
					    <th scope="row">Total O/S Month</th>
					    <td>
					        <input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" id="outstandingMonth" name="outstandingMonth"/>
					    </td>
					    <th scope="row">Total :</th>
					    <td>
					        <input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" id="rentalGrandTotal" name="rentalGrandTotal"/>
					    </td>
					</tr>
				</tbody>
			</table><!-- table end -->

			<aside class="title_line"><!-- title_line start -->
			<h3>(OUT) SVM Quotation  </h3>
			</aside><!-- title_line end -->

			<table class="type1"><!-- table start -->
				<caption>table</caption>
				<colgroup>
				    <col style="width:170px" />
				    <col style="width:*" />
				    <col style="width:130px" />
				    <col style="width:*" />
				    <col style="width:120px" />
				    <col style="width:*" />
				</colgroup>
				<tbody>
					<tr>
					    <th scope="row">Package Amount</th>
					    <td>
					        <input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" id="svmQuotPacAmount" name="svmQuotPacAmount"/>
					    </td>
					    <th scope="row">Filter Amount</th>
					    <td>
					        <input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" id="svmQuotFilterAmount" name="svmQuotFilterAmount"/>
					    </td>
					    <th scope="row">Total</th>
					    <td>
					        <input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" id="svmQuotTotalAmount" name="svmQuotTotalAmount"/>
					    </td>
					</tr>
					<tr>
					    <th scope="row">Quotation Number</th>
					    <td>
					        <input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" id="svmQuotNo" name="svmQuotNo"/>
					    </td>
					    <th scope="row">Status</th>
					    <td>
					        <input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" id="svmQuotStatus" name="svmQuotStatus"/>
					    </td>
					    <th scope="row">Create Date</th>
					    <td>
					        <input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" id="svmQuotCreateDate" name="svmQuotCreateDate"/>
					    </td>
					</tr>
				</tbody>
			</table><!-- table end -->

			<aside class="title_line"><!-- title_line start -->
			<h3>(OUT) SVM</h3>
			</aside><!-- title_line end -->

			<table class="type1"><!-- table start -->
				<caption>table</caption>
				<colgroup>
				    <col style="width:170px" />
				    <col style="width:*" />
				    <col style="width:130px" />
				    <col style="width:*" />
				    <col style="width:120px" />
				    <col style="width:*" />
				    <col style="width:120px" />
				    <col style="width:*" />
				</colgroup>
				<tbody>
					<tr>
					    <th scope="row">Package Amount</th>
					    <td>
					       <input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" id="svmPacAmount" name="svmPacAmount"/>
					    </td>
					    <th scope="row">Filter Amount</th>
					    <td>
					       <input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" id="svmFilterAmount" name="svmFilterAmount" />
					    </td>
					    <th scope="row">Status</th>
					    <td>
					       <input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" id="svmStatus" name="svmStatus"/>
					    </td>
					    <th scope="row">Create Date</th>
					    <td>
					       <input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" id="svmCreateDate" name="svmCreateDate"/>
					    </td>
					</tr>
					<tr>
					    <th scope="row">Duration</th>
					    <td>
					       <input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" id="svmDuration" name="svmDuration"/>
					    </td>
					    <th scope="row">Valid Date</th>
					    <td>
					       <input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" id="svmValidDate" name="svmValidDate"/>
					    </td>
					    <th scope="row">Total :</th>
					    <td>
					       <input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" id="svmTotalOutstanding" name="svmTotalOutstanding"/>
					    </td>
					    <th scope="row">Total O/S</th>
                        <td>
                           <input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" id="svmTotalOutstandingAmt" name="svmTotalOutstandingAmt"/>
                        </td>
					</tr>
				</tbody>
			</table><!-- table end -->

			<aside class="title_line"><!-- title_line start -->
			<h3>(REN) SVM</h3>
			</aside><!-- title_line end -->

			<table class="type1"><!-- table start -->
				<caption>table</caption>
				<colgroup>
				    <col style="width:170px" />
				    <col style="width:*" />
				    <col style="width:130px" />
				    <col style="width:*" />
				    <col style="width:120px" />
				    <col style="width:*" />
				    <col style="width:120px" />
				    <col style="width:*" />
				</colgroup>
				<tbody>
					<tr>
					    <th scope="row">Package Amount</th>
					    <td>
					        <input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" id="srvContractPacAmount" name="srvContractPacAmount"/>
					    </td>
					    <th scope="row">Filter Amount</th>
					    <td>
					        <input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" id="srvContractFilterAmount" name="srvContractFilterAmount"/>
					    </td>
					    <th scope="row">Status</th>
					    <td>
					        <input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" id="srvContractStatus" name="srvContractStatus"/>
					    </td>
					    <th scope="row">Create Date</th>
					    <td>
					        <input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" id="srvContractCreateDate" name="srvContractCreateDate" />
					    </td>
					</tr>
					<tr>
					    <th scope="row">Duration (Mth)</th>
					    <td>
					        <input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" id="srvContractDuration" name="srvContractDuration" />
					    </td>
					    <th scope="row">Valid Date</th>
					    <td>
					        <input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" id="srvContractValidDate" name="srvContractValidDate"/>
					    </td>
					    <th scope="row">Total :</th>
					    <td>
					        <input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" id="srvContractTotalOutstanding" name="srvContractTotalOutstanding"/>
					    </td>
					    <th scope="row">Total O/S</th>
                        <td>
                           <input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" id="srvContractTotalOutstandingAmt" name="srvContractTotalOutstandingAmt"/>
                        </td>
					</tr>
				</tbody>
			</table><!-- table end -->
		</form>
	</section><!-- pop_body end -->
</div><!-- popup_wrap end -->
<form id="ledgerForm" action="#" method="post">
    <input type="hidden" id="ordId" name="ordId" />
</form>
</body>
</html>