<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<head>
<script type="text/javaScript" language="javascript">

    var ORD_NO = '${ordNo}';
    var userBranchId = null;
    if("${SESSION_INFO.roleId}" == 256) {
    	userBranchId = '${SESSION_INFO.userBranchId}';
    }
    

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
            //Common.alert('<b>The program is under development.</b>');
            fn_generateReport();

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

    //Print Report Start
    function fn_generateReport(){

    	//Essential Params
    	$("#reportFileName").val('/sales/RentalToOutrightSimulatorForm.rpt');
    	$("#viewType").val('PDF');

    	    //File Title
    	var date = new Date().getDate();
    	if(date.toString().length == 1){
    	    date = "0" + date;
    	}
    	var downFileName = "RentalToOutright_"+$("#txtOrderNo").val().trim() + " _ " +  date+(new Date().getMonth()+1)+new Date().getFullYear();
    	$("#downFileName").val(downFileName);


    	console.log("reportFileName : " + $("#reportFileName").val());

    	console.log("_printOrdId : " + $("#hiddenOrderID").val());
    	console.log("_printUserName : " + '${userName}');
    	console.log("_printBranchCode : " + '${brnchCode}');
    	console.log("_printOutrightPrice : " + $("#txtOutrightPrice").val());
    	console.log("_printLastBillMth : " + $("#hiddenLastBillMth").val());
    	console.log("_printTotalBillAmt : " + $("#txtTotalBillAmt").val());
    	console.log("_printTotalOutstanding : " + $("#txtCurrentOutstanding").val());
    	console.log("_printAdjPercent : " + $("#hiddenAdjPercent").val());
    	console.log("_printAdjPercentAmt : "+ $("#hiddenAdjPercentAmt").val());
    	console.log("_printAdjFixAmt : " + $("#hiddenAdjFixAmt").val());
    	console.log("_printAdjPercentInd : " + $("#hiddenAdjPercentInd").val());
    	console.log("_printAdjFixInd : " + $("#hiddenAdjFixInd").val());
    	console.log("_printConversionAmt : " + $("#txtConvertAmt").val());
    	console.log("_printTotalAmt : " + $("#txtTotalAmt").val());

    	//Params Setting

    	$("#_printOrdId").val($("#hiddenOrderID").val());  // int OrderID = int.Parse(hiddenOrderID.Value);
    	$("#_printUserName").val('${userName}');  // string Username = li.LoginID;
    	$("#_printBranchCode").val('${brnchCode}');  //string BranchCode = li.BranchCode;
    	$("#_printOutrightPrice").val($("#txtOutrightPrice").val());  // decimal OutrightPrice = decimal.Parse(txtOutrightPrice.Text.Trim());
    	$("#_printLastBillMth").val($("#hiddenLastBillMth").val());  //int LastBillMth = int.Parse(hiddenLastBillMth.Value);
    	$("#_printTotalBillAmt").val($("#txtTotalBillAmt").val()); //decimal TotalBillAmt = decimal.Parse(txtTotalBillAmt.Text.Trim());
    	$("#_printTotalOutstanding").val($("#txtCurrentOutstanding").val());  //decimal TotalOutstanding = decimal.Parse(txtCurrentOutstanding.Text.Trim());
    	$("#_printAdjPercent").val($("#hiddenAdjPercent").val());  //decimal AdjPercent = decimal.Parse(hiddenAdjPercent.Value);
    	$("#_printAdjPercentAmt").val($("#hiddenAdjPercentAmt").val()); //decimal AdjPercentAmt = decimal.Parse(hiddenAdjPercentAmt.Value);
    	$("#_printAdjFixAmt").val($("#hiddenAdjFixAmt").val());  //decimal AdjFixAmt = decimal.Parse(hiddenAdjFixAmt.Value);
    	$("#_printAdjPercentInd").val($("#hiddenAdjPercentInd").val());  //string AdjPercentInd = hiddenAdjPercentInd.Value;
    	$("#_printAdjFixInd").val($("#hiddenAdjFixInd").val());  //string AdjFixInd = hiddenAdjFixInd.Value;
    	$("#_printConversionAmt").val($("#txtConvertAmt").val());  //decimal ConversionAmt = decimal.Parse(txtConvertAmt.Text.Trim());
    	$("#_printTotalAmt").val($("#txtTotalAmt").val());  //decimal TotalAmt = decimal.Parse(txtTotalAmt.Text.Trim()); */

        //Generate Report
    	var option = { isProcedure : false};
    	Common.report("_printForm", option);

    }



    function fn_doConfirm() {

        if(!FormUtil.checkReqValue($('#txtOrderNo'))) {

                Common.ajax("GET", "/sales/order/selectOrderSimulatorViewByOrderNo.do", {salesOrdNo : $('#txtOrderNo').val(), userBranchId: userBranchId}, function(result) {
                    if(fn_validInfoSimul()) {

                        var installdate = result.installdate;
                        var today = '${toDay}';
                      //var today = Number(todayYMD.substr(0, 4)) * 12;

                        console.log('installdate:'+installdate);
                        console.log('today:'+today);

                        var monthDiff = ((Number(today.substr(0, 4)) * 12) + Number(today.substr(4, 2))) - ((Number(installdate.substr(0, 4)) * 12) + Number(installdate.substr(4, 2)));
                        var totalBillAmt;

                        console.log('monthDiff:'+monthDiff);

                        if(monthDiff >= 1 ) {
                            totalBillAmt = (result.totalbillamt + result.totaldnbill - result.totalcnbill);
                        }
                        else {
                            totalBillAmt = (result.totalbillamt + result.totaldnbill - result.totalcnbill) + (result.totalbillrpf + result.totaldnrpf - result.totalcnrpf);
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

        if (monthDiff >= 1 && Number($('#hiddenLastBillMth').val()) > 1) { //Formula 2
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

        Common.ajaxSync("GET", "/sales/order/selectValidateInfoSimul.do", {salesOrdNo : $('#txtOrderNo').val(), userBranchId: userBranchId}, function(rsltInfo) {
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
<!-- Print Report Form -->
<form id="_printForm">
    <!--essential Params -->
    <input type="hidden" id="reportFileName" name="reportFileName" value="/sales/RentalToOutrightSimulatorForm.rpt" /><!-- Report Name  -->
    <input type="hidden" id="viewType" name="viewType" value="PDF" /><!-- View Type  -->
    <input type="hidden" id="downFileName" name="reportDownFileName" value="" /> <!-- Download Name -->

    <!-- params -->
    <input type="hidden" id="_printOrdId" name="OrderID" />
    <input type="hidden" id="_printUserName" name="Username">
    <input type="hidden" id="_printBranchCode" name="BranchCode">
    <input type="hidden" id="_printOutrightPrice" name="OutrightPrice">
    <input type="hidden" id="_printLastBillMth" name="LastBillMth">
    <input type="hidden" id="_printTotalBillAmt" name="TotalBillAmt">
    <input type="hidden" id="_printTotalOutstanding" name="TotalOutstanding">
    <input type="hidden" id="_printAdjPercent" name="AdjPercent">
    <input type="hidden" id="_printAdjPercentAmt" name="AdjPercentAmt">
    <input type="hidden" id="_printAdjFixAmt" name="AdjFixAmt">
    <input type="hidden" id="_printAdjPercentInd" name="AdjPercentInd">
    <input type="hidden" id="_printAdjFixInd" name="AdjFixInd">
    <input type="hidden" id="_printConversionAmt" name="ConversionAmt">
    <input type="hidden" id="_printTotalAmt" name="TotalAmt">
</form>

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