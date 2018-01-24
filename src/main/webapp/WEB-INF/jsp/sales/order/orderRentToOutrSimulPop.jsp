<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<head>
<script type="text/javaScript" language="javascript">

    var ORD_NO = '${ordNo}';

    $(document).ready(function(){
        if(FormUtil.isNotEmpty(ORD_NO)) {
            $('#txtOrderNo').val(ORD_NO);
            fn_doConfirm();
        }
    });
    
    $(function(){
        $('#btnConfirmSimul').click(function() {
            fn_doConfirm();
        });
        $('#txtOrderNo').keydown(function (event) {  
            if (event.which === 13) {    //enter  
                fn_doConfirm();
                return false;
            }
        });        $('#btnReselectSimul').click(function() {
            fn_reselect();
        });
        $('#btnViewLedgerSimul').click(function() {
            Common.popupWin("formApprv", "/sales/order/orderLedger2ViewPop.do", {width : "1000px", height : "720", resizable: "no", scrollbars: "no"});
        });
        $('#btnPrintSimul').click(function() {
            Common.alert('<b>The program is under development.</b>');
        });
        
        $('#cmbPercentageInd').change(function(event) {
            fn_calcConvAmount();
        });
        $('#cmbFixAmountInd').change(function(event) {
            fn_calcConvAmount();
        });
        $('#txtPercentage').change(function(event) {
            if(FormUtil.checkReqValue($('#txtPercentage'))) {
                $('#txtPercentage').val(0);
            }
            fn_calcConvAmount();
        });
        $('#txtPercentage').keydown(function (event) {  
            if (event.which === 13) {    //enter  
                fn_calcConvAmount();
                return false;
            }
        });
        $('#txtFixAmount').change(function(event) {
            if(FormUtil.checkReqValue($('#txtFixAmount'))) {
                $('#txtFixAmount').val(0);
            }
            fn_calcConvAmount();
        });
        $('#txtFixAmount').keydown(function (event) {  
            if (event.which === 13) {    //enter  
                fn_calcConvAmount();
                return false;
            }
        });
    });
    
    function fn_doConfirm() {
        
        if(!FormUtil.checkReqValue($('#txtOrderNo'))) {
                
                Common.ajax("GET", "/sales/order/selectOrderSimulatorViewByOrderNo.do", {salesOrdNo : $('#txtOrderNo').val()}, function(result) {
                    if(fn_validInfoSimul()) {
                        
                        var installdate = result.installdate;
                        var today = '${toDay}';                        
                      //var today = Number(todayYMD.substr(0, 4)) * 12;
                        
                        console.log('installdate:'+installdate);
                        console.log('today:'+today);
                        
                        var monthDiff = ((Number(today.substr(0, 4)) * 12) + Number(today.substr(4, 2))) - ((Number(installdate.substr(0, 4)) * 12) + Number(installdate.substr(4, 2)));
                        var totalBillAmt;
                        
                        console.log('monthDiff:'+monthDiff);
                        
                        if(monthDiff >= 1) {
                            totalBillAmt = (result.totalbillamt + result.totaldnbill - result.totalcnbill);
                        }
                        else {
                            totalBillAmt = (result.TotalBillAmt + result.TotalDNBill - result.TotalCNBill) + (result.totalbillrpf + result.totaldnrpf - result.totalcnrpf);
                        }
                        
                        console.log('result.totalbillrpf:'+result.totalbillrpf);
                        console.log('result.totaldnrpf:'+result.totaldnrpf);
                        console.log('result.totalcnrpf:'+result.totalcnrpf);
                        
                        $('#hiddenOrderID').val(result.salesOrdId);
                        $('#hiddenStockID').val(result.itmStkId);
                        $('#hiddenOrderDate').val(result.ordDt2);
                        $('#hiddenInstallDate').val(result.installDt2);
                        $('#hiddenTotalBillRPF').val(result.totalbillrpf + result.totaldnrpf - result.totalcnrpf);
                        $('#hiddenLastBillMth').val(result.lastbillmth);
                        $('#hiddenDiffInstallMonth').val(monthDiff);
                        
                        $('#txtOutrightPrice').val(result.outrightprice);
                        $('#txtTotalBillAmt').val(totalBillAmt);
                        $('#txtCurrentBillMth').val(result.currentbillmth);
                        $('#txtCurrentOutstanding').val(result.totaloutstanding);
                        
                        $('#cmbPercentageInd').removeAttr("disabled");
                        $('#txtPercentage').val('0');
                        $('#txtPercentage').removeAttr("disabled");
                        $('#cmbFixAmountInd').removeAttr("disabled");
                        $('#txtFixAmount').val('0');
                        $('#txtFixAmount').removeAttr("disabled");
                        
                        $('#txtOrderNo').prop("disabled", true);
                        $('#btnConfirmSimul').addClass("blind");
                        $('#btnReselectSimul').removeClass("blind");
                        $('#btnViewLedgerSimul').removeClass("blind");
                        $('#btnPrintSimul').removeClass("blind");
                        
                        fn_calcConvAmount();
                    }
                });
        }
        else {
            Common.alert("Order Number Required" + DEFAULT_DELIMITER + "<b>Please key in the order number.</b>");
        }
    }
    
    function fn_reselect() {

        $('#btnConfirmSimul').removeClass("blind");
        $('#btnReselectSimul').addClass("blind");
        $('#btnViewLedgerSimul').addClass("blind");
        $('#btnPrintSimul').addClass("blind");
        
        $('#txtOrderNo').val('').removeAttr("disabled");

        $('#hiddenOrderID').val('');
        $('#hiddenOrderDate').val('');
        $('#hiddenStockID').val('');
        $('#hiddenTotalBillRPF').val('');
        $('#hiddenInstallDate').val('');
        $('#hiddenLastBillMth').val('');
        $('#hiddenAdjPercent').val('');
        $('#hiddenAdjPercentAmt').val('');
        $('#hiddenAdjPercentInd').val('');
        $('#hiddenAdjFixAmt').val('');
        $('#hiddenAdjFixInd').val('');
        $('#hiddenDiffInstallMonth').val('');

        $('#txtOutrightPrice').val('');
        $('#txtTotalBillAmt').val('');
        $('#txtCurrentBillMth').val('');
        $('#txtCurrentOutstanding').val('');

        $('#cmbPercentageInd option:eq(0)').attr("selected", true);
        $('#cmbPercentageInd').prop("disabled", true);
        $('#txtPercentage').val('').prop("disabled", true);

        $('#cmbFixAmountInd option:eq(0)').attr("selected", true);
        $('#cmbFixAmountInd').prop("disabled", true);
        $('#txtFixAmount').val('').prop("disabled", true);
        
        $('#txtConvertAmt').val('');
        $('#txtTotalAmt').val('');
    }
    
    function fn_calcConvAmount() {
        
        var conversionAmt = 0;
        var monthDiff = Number($('#hiddenDiffInstallMonth').val());
        var OutrightPrice = Number($('#txtOutrightPrice').val());
        var totalBill = Number($('#txtTotalBillAmt').val());
        var totalOutstanding = Number($('#txtCurrentOutstanding').val());
        var adjPercentAmt = 0;
        var adjFixAmt = 0;
        
        if(Number($('#txtPercentage').val()) > 0) {
            adjPercentAmt = OutrightPrice * (Number($('#txtPercentage').val()) / 100);
            if ($("#cmbPercentageInd").val() == "-") {
                adjPercentAmt = -1 * adjPercentAmt;
            }
        }
        
        $('#hiddenAdjPercentInd').val($('#cmbPercentageInd').val());
        $('#hiddenAdjPercent').val($('#txtPercentage').val());
        $('#hiddenAdjPercentAmt').val(adjPercentAmt);

        if(Number($('#txtFixAmount').val()) > 0) {
            adjFixAmt = Number($('#txtFixAmount').val());
            
            if($('#cmbFixAmountInd').val() == "-") {
                adjFixAmt = -1 * adjFixAmt;
            }
        }
        
        $('#hiddenAdjFixInd').val($('#cmbFixAmountInd').val());
        $('#hiddenAdjFixAmt').val(adjFixAmt);
        
        if (monthDiff >= 1) { //Formula 2
            conversionAmt = (OutrightPrice + adjPercentAmt + adjFixAmt) - (totalBill / 2);
        }
        else { // Formula 1
            conversionAmt = (OutrightPrice + adjPercentAmt + adjFixAmt) - (totalBill);
        }
        
        //Ben
        $('#txtConvertAmt').val(Math.floor(conversionAmt));
        $('#txtTotalAmt').val(Math.floor((conversionAmt + totalOutstanding) / 1));
    }
    
    function fn_validInfoSimul() {
        
        var valid = '';
        var msgT = '';
        var msg = '';
        
        Common.ajaxSync("GET", "/sales/order/selectValidateInfoSimul.do", {salesOrdNo : $('#txtOrderNo').val()}, function(rsltInfo) {
            if(rsltInfo != null) {
                valid = rsltInfo.isInValid;
                msgT  = rsltInfo.msgT;
                msg   = rsltInfo.msg;
            }
        });

        if(valid == 'isInValid') {
            Common.alert(msgT + DEFAULT_DELIMITER + "<b>"+msg+"</b>");
            return false;
        }
        
        return true;
    }
</script>
</head>
<body>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Rental To Outright Simulator</h1>
<ul class="right_opt">
	<li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->
<form id="formApprv" action="#" method="post">
    
<input id="hiddenOrderID" name="ordId" type="hidden" />
<input id="hiddenStockID"           type="hidden" />
<input id="hiddenOrderDate"         type="hidden" />
<input id="hiddenTotalBillRPF"      type="hidden" />
<input id="hiddenInstallDate"       type="hidden" />
<input id="hiddenLastBillMth"       type="hidden" />
<input id="hiddenAdjPercentInd"     type="hidden" />
<input id="hiddenAdjPercent"        type="hidden" />
<input id="hiddenAdjPercentAmt"     type="hidden" />
<input id="hiddenAdjFixAmt"         type="hidden" />
<input id="hiddenAdjFixInd"         type="hidden" />
<input id="hiddenDiffInstallMonth"  type="hidden" />
    
<aside class="title_line"><!-- title_line start -->
<h3>Order Information</h3>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:200px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row">Order Number</th>
	<td><input id="txtOrderNo" name="txtOrderNo" type="text" title="" placeholder="" class="" />
	    <p class="btn_sky"><a id="btnConfirmSimul" href="#">Confirm</a></p>
	    <p class="btn_sky"><a id="btnReselectSimul" href="#" class="blind">Reselect</a></p>
	    <p class="btn_sky"><a id="btnViewLedgerSimul" href="#" class="blind">VIew Ledger</a></p>
	    <p class="btn_sky"><a id="btnPrintSimul" href="#" class="blind">Print</a></p>
	</td>
</tr>
<tr>
	<th scope="row">Outright Price</th>
	<td><input id="txtOutrightPrice" name="txtOutrightPrice" type="text" title="" placeholder="" class="readonly" readonly="readonly" /></td>
</tr>
<tr>
	<th scope="row">Total Billed Amount</th>
	<td><input id="txtTotalBillAmt" name="txtTotalBillAmt" type="text" title="" placeholder="" class="readonly" readonly="readonly" /></td>
</tr>
<tr>
	<th scope="row">Current Bill Month</th>
	<td><input id="txtCurrentBillMth" name="txtCurrentBillMth" type="text" title="" placeholder="" class="readonly" readonly="readonly" /></td>
</tr>
<tr>
	<th scope="row">Current Outstanding</th>
	<td><input id="txtCurrentOutstanding" name="txtCurrentOutstanding" type="text" title="" placeholder="" class="readonly" readonly="readonly" /></td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h3>Conversion Adjustment</h3>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:200px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row">Percentage (%)</th>
	<td>
	<select id="cmbPercentageInd" name="cmbPercentageInd" style="width:60px;" class="mr5">
		<option value="-">-</option>
		<option value="+">+</option>
	</select>
	<input id="txtPercentage" name="txtPercentage" type="text" title="" placeholder="" class="" />
	</td>
</tr>
<tr>
	<th scope="row">Fixed Amount</th>
	<td>
	<select id="cmbFixAmountInd" name="cmbFixAmountInd" style="width:60px;" class="mr5">
		<option value="-">-</option>
		<option value="+">+</option>
	</select>
	<input id="txtFixAmount" name="txtFixAmount" type="text" title="" placeholder="" class="" />
	</td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h3>Conversion Information</h3>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:200px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row">Conversion Amount</th>
	<td><input id="txtConvertAmt" name="txtConvertAmt" type="text" title="" placeholder="" class="readonly" readonly="readonly" /></td>
</tr>
<tr>
	<th scope="row">Total Amount</th>
	<td><input id="txtTotalAmt" name="txtTotalAmt" type="text" title="" placeholder="" class="readonly" readonly="readonly" /></td>
</tr>
</tbody>
</table><!-- table end -->
</form>
</section><!-- pop_body end -->

</div><!-- popup_wrap end -->