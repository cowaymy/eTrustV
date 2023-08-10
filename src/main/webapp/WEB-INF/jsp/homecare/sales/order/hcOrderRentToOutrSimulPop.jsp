<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<head>
<script type="text/javaScript" language="javascript">

    var ORD_NO = '${ordNo}';

    $(document).ready(function(){
        if(FormUtil.isNotEmpty(ORD_NO)) {
            $('#txtOrderNoMat').val(ORD_NO);
            fn_doConfirm();
        }
    });

    $(function(){
        $('#btnConfirmSimulMat').click(function() {
            fn_doConfirm();
        });
        $('#txtOrderNoMat').keydown(function (event) {
            if (event.which === 13) {    //enter
                fn_doConfirm();
                return false;
            }
        });

        $('#btnReselectSimulMat').click(function() {
            fn_reselect();
        });
        $('#btnViewLedgerSimulMat').click(function() {
        	$('#hiddenOrderID').val($('#hiddenOrderIDMat').val());
            Common.popupWin("formApprv", "/sales/order/orderLedger2ViewPop.do", {width : "1000px", height : "720", resizable: "no", scrollbars: "no"});
        });
        $('#btnViewLedgerSimulFrame').click(function() {
        	$('#hiddenOrderID').val($('#hiddenOrderIDFrame').val());
            Common.popupWin("formApprv", "/sales/order/orderLedger2ViewPop.do", {width : "1000px", height : "720", resizable: "no", scrollbars: "no"});
        });
        $('#btnGenerate').click(function() {
            fn_generateReport();
        });

        $('#cmbPercentageInd').change(function(event) {
            fn_calcConvAmountMat();
        });
        $('#cmbFixAmountInd').change(function(event) {
            fn_calcConvAmountMat();
        });
        $('#txtPercentage').change(function(event) {
            if(FormUtil.checkReqValue($('#txtPercentage'))) {
                $('#txtPercentage').val(0);
            }
            fn_calcConvAmountMat();
        });
        $('#txtPercentage').keydown(function (event) {
            if (event.which === 13) {    //enter
                fn_calcConvAmountMat();
                return false;
            }
        });
        $('#txtFixAmount').change(function(event) {
            if(FormUtil.checkReqValue($('#txtFixAmount'))) {
                $('#txtFixAmount').val(0);
            }
            fn_calcConvAmountMat();
        });
        $('#txtFixAmount').keydown(function (event) {
            if (event.which === 13) {    //enter
                fn_calcConvAmountMat();
                return false;
            }
        });
    });

    //Print Report Start
    function fn_generateReport(){

        //Essential Params
        $("#reportFileName").val('/homecare/hcRentalToOutrightSimulatorForm.rpt');
        $("#viewType").val('PDF');

            //File Title
        var date = new Date().getDate();
        if(date.toString().length == 1){
            date = "0" + date;
        }
        var downFileName = "hcRentalToOutright_"+$("#txtOrderNoMat").val().trim() + "_" +  date+(new Date().getMonth()+1)+new Date().getFullYear();
        $("#reportDownFileName").val(downFileName);

        console.log($("#reportDownFileName").val());

        console.log("reportFileName : " + $("#reportFileName").val());

        console.log("_printOrdId : " + $("#hiddenOrderID").val());
        console.log("_printUserName : " + '${userName}');
        console.log("_printBranchCode : " + '${brnchCode}');
        console.log("_printOutrightPrice : " + $("#txtOutrightPrice").val());
        console.log("_printLastBillMth : " + $("#hiddenLastBillMth").val());
        console.log("_printTotalBillAmt : " + $("#txtTotalBillAmtMat").val());
        console.log("_printTotalOutstanding : " + $("#hiddenTotalOutstandingTotal").val());
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
        $("#_printTotalBillAmt").val($("#txtTotalBillAmtMat").val()); //decimal TotalBillAmt = decimal.Parse(txtTotalBillAmt.Text.Trim());
        $("#_printTotalOutstanding").val($("#hiddenTotalOutstandingTotal").val());  //decimal TotalOutstanding = decimal.Parse(txtCurrentOutstanding.Text.Trim());
        $("#_printAdjPercent").val($("#hiddenAdjPercent").val());  //decimal AdjPercent = decimal.Parse(hiddenAdjPercent.Value);
        $("#_printAdjPercentAmt").val($("#hiddenAdjPercentAmt").val()); //decimal AdjPercentAmt = decimal.Parse(hiddenAdjPercentAmt.Value);
        $("#_printAdjFixAmt").val($("#hiddenAdjFixAmt").val());  //decimal AdjFixAmt = decimal.Parse(hiddenAdjFixAmt.Value);
        $("#_printAdjPercentInd").val($("#hiddenAdjPercentInd").val());  //string AdjPercentInd = hiddenAdjPercentInd.Value;
        $("#_printAdjFixInd").val($("#hiddenAdjFixInd").val());  //string AdjFixInd = hiddenAdjFixInd.Value;
        $("#_printConversionAmt").val($("#txtConvertAmt").val());  //decimal ConversionAmt = decimal.Parse(txtConvertAmt.Text.Trim());
        $("#_printTotalAmt").val($("#txtTotalAmt").val());  //decimal TotalAmt = decimal.Parse(txtTotalAmt.Text.Trim()); */

        if($('#txtOrderNoFrame').val() != '' && $('#txtOrderNoFrame').val() != null){
            console.log("NOTempty111");
        	 $("#_printLastBillMthFrame").val($("#hiddenLastBillMthFrame").val());  //int LastBillMth = int.Parse(hiddenLastBillMth.Value);
             $("#_printTotalBillFrame").val($("#txtTotalBillAmtFrame").val()); //decimal TotalBillAmt = decimal.Parse(txtTotalBillAmt.Text.Trim());
        }
        else{
        	console.log("empty111");
        	var zero = "0";
        	 $("#_printLastBillMthFrame").val(zero);  //int LastBillMth = int.Parse(hiddenLastBillMth.Value);
             $("#_printTotalBillFrame").val(zero); //decimal TotalBillAmt = decimal.Parse(txtTotalBillAmt.Text.Trim());
        }

        console.log("txtOrderNoFrame : " + $("#txtOrderNoFrame").val());
        console.log("_printLastBillMthFrame : " + $("#hiddenLastBillMthFrame").val());
        console.log("_printTotalBillFrame : " + $("#txtTotalBillAmtFrame").val());

        //Generate Report
        var option = { isProcedure : false};
        Common.report("_printForm", option);

    }



    function fn_doConfirm() {

        if(!FormUtil.checkReqValue($('#txtOrderNoMat'))) {

                Common.ajax("GET", "/homecare/sales/order/selectOrderSimulatorViewByOrderNo.do", {salesOrdNo : $('#txtOrderNoMat').val()}, function(result) {
                	if(result!= null){
	                    if(fn_validInfoSimul()) {
	                    	console.log("result111");
	                    	console.log(result);

	                        var installdate = result.installdate;
	                        var today = '${toDay}';
	                      //var today = Number(todayYMD.substr(0, 4)) * 12;

	                        console.log('installdate:'+installdate);
	                        console.log('today:'+today);

	                        var monthDiff = ((Number(today.substr(0, 4)) * 12) + Number(today.substr(4, 2))) - ((Number(installdate.substr(0, 4)) * 12) + Number(installdate.substr(4, 2)));
	                        var totalBillAmt,
	                        totalBillAmtFrame = 0;

	                        console.log('monthDiff:'+monthDiff);

	                        console.log('framNo111:'+ $('#txtOrderNoFrame').val());
	                        if(monthDiff >= 1 && result.lastbillmth > 1) {
	                            totalBillAmt = (result.totalbillamt + result.totaldnbill - result.totalcnbill);
	                        }
	                        else {
	                            totalBillAmt = (result.totalbillamt + result.totaldnbill - result.totalcnbill) + (result.totalbillrpf + result.totaldnrpf - result.totalcnrpf);
	                        }

	                        $('#hiddenOrderID').val(result.salesOrdId);
	                        $('#hiddenOrderIDMat').val(result.salesOrdId);
	                        $('#hiddenStockID').val(result.itmStkId);
	                        $('#hiddenOrderDate').val(result.ordDt2);
	                        $('#hiddenInstallDate').val(result.installDt2);
	                        $('#hiddenTotalBillRPF').val(result.totalbillrpf + result.totaldnrpf - result.totalcnrpf);
	                        $('#hiddenLastBillMth').val(result.lastbillmth);
	                        $('#hiddenDiffInstallMonth').val(monthDiff);
	                        $('#txtOutrightPrice').val(result.outrightprice);
                            $('#txtTotalBillAmtMat').val(totalBillAmt);
                            $('#txtCurrentBillMthMat').val(result.currentbillmth);
                            $('#txtCurrentOutstandingMat').val(result.totaloutstanding);

                            $('#cmbPercentageInd').removeAttr("disabled");
                            $('#txtPercentage').val('0');
                            $('#txtPercentage').removeAttr("disabled");
                            $('#cmbFixAmountInd').removeAttr("disabled");
                            $('#txtFixAmount').val('0');
                            $('#txtFixAmount').removeAttr("disabled");

                            //FRAME
                            if(result.fraOrdNo != '0'){
                            	if(monthDiff >= 1 && result.lastbillmth > 1) {
                            	    totalBillAmtFrame = (result.totalbillamtFrame + result.totaldnbill - result.totalcnbill);
                                }
                                else {
                                    totalBillAmtFrame = (result.totalbillamtFrame + result.totaldnbillFrame - result.totalcnbillFrame) + (result.totalbillrpfFrame + result.totaldnrpfFrame - result.totalcnrpfFrame);
                                }

                            	$('#txtOrderNoFrame').val(result.fraOrdNo);
                                $('#hiddenOrderIDFrame').val(result.fraOrdId);
                                $('#hiddenLastBillMthFrame').val(result.lastbillmthFrame);
                                $('#hiddenTotalOutstandingTotal').val(result.totaloutstanding + result.totaloutstandingFrame);

                                $('#txtTotalBillAmtFrame').val(totalBillAmtFrame);
                                $('#txtCurrentBillMthFrame').val(result.currentbillmthFrame);
                                $('#txtCurrentOutstandingFrame').val(result.totaloutstandingFrame);
                            }
                            else{
                            	$('#txtOrderNoFrame').val('');
                                $('#hiddenOrderIDFrame').val('');
                                $('#hiddenLastBillMthFrame').val('');
                                $('#hiddenTotalOutstandingTotal').val(result.totaloutstanding);

                                $('#txtTotalBillAmtFrame').val('');
                                $('#txtCurrentBillMthFrame').val('');
                                $('#txtCurrentOutstandingFrame').val('');
                            }

	                        console.log('result.totaloutstandingFrame:'+result.totaloutstandingFrame);
	                        console.log('result.totaloutstanding:'+result.totaloutstanding);
	                        console.log('hiddenTotalOutstandingTotal:'+ $('#hiddenTotalOutstandingTotal').val());

	                        $('#txtOrderNoMat').prop("disabled", true);
	                        $('#txtOrderNoFrame').prop("disabled", true);
	                        $('#btnConfirmSimulMat').addClass("blind");
	                        $('#btnReselectSimulMat').removeClass("blind");
	                        $('#btnViewLedgerSimulMat').removeClass("blind");
	                        //$('#btnPrintSimulMat').removeClass("blind");

	                        fn_calcConvAmountMat();
	                    }
	                }
                });

        }
        else {
            Common.alert("Order Number Required" + DEFAULT_DELIMITER + "<b>Please key in the order number.</b>");
        }
    }

    function fn_reselect() {

        $('#btnConfirmSimulMat').removeClass("blind");
        $('#btnReselectSimulMat').addClass("blind");
        $('#btnViewLedgerSimulMat').addClass("blind");
        //$('#btnPrintSimulMat').addClass("blind");

        $('#txtOrderNoMat').val('').removeAttr("disabled");
        $('#txtOrderNoFrame').val('').removeAttr("disabled");

        $('#hiddenOrderID').val('');
        $('#hiddenOrderIDMat').val('');
        $('#hiddenOrderIDFrame').val('');
        $('#hiddenOrderDate').val('');
        $('#hiddenStockID').val('');
        $('#hiddenTotalBillRPF').val('');
        $('#hiddenInstallDate').val('');
        $('#hiddenLastBillMth').val('');
        $('#hiddenLastBillMthFrame').val('');
        $('#hiddenAdjPercent').val('');
        $('#hiddenAdjPercentAmt').val('');
        $('#hiddenAdjPercentInd').val('');
        $('#hiddenAdjFixAmt').val('');
        $('#hiddenAdjFixInd').val('');
        $('#hiddenDiffInstallMonth').val('');

        $('#txtOutrightPrice').val('');
        $('#txtTotalBillAmtMat').val('');
        $('#txtCurrentBillMthMat').val('');
        $('#txtCurrentOutstandingMat').val('');
        $('#txtTotalBillAmtFrame').val('');
        $('#txtCurrentBillMthFrame').val('');
        $('#txtCurrentOutstandingFrame').val('');

        $('#cmbPercentageInd option:eq(0)').attr("selected", true);
        $('#cmbPercentageInd').prop("disabled", true);
        $('#txtPercentage').val('').prop("disabled", true);

        $('#cmbFixAmountInd option:eq(0)').attr("selected", true);
        $('#cmbFixAmountInd').prop("disabled", true);
        $('#txtFixAmount').val('').prop("disabled", true);

        $('#txtConvertAmt').val('');
        $('#txtTotalAmt').val('');
    }

    function fn_calcConvAmountMat() {

        var conversionAmt = 0;
        var monthDiff = Number($('#hiddenDiffInstallMonth').val());
        var OutrightPrice = Number($('#txtOutrightPrice').val());
        var totalBillMat = Number($('#txtTotalBillAmtMat').val());
        var totalBillFrame = Number($('#txtTotalBillAmtFrame').val());
        var totalOutstandingMat = Number($('#txtCurrentOutstandingMat').val());
        var totalOutstandingFrame = Number($('#txtCurrentOutstandingFrame').val());
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
            conversionAmt = (OutrightPrice + adjPercentAmt + adjFixAmt) - ((totalBillMat + totalBillFrame)/ 2);
        }
        else { // Formula 1
            conversionAmt = (OutrightPrice + adjPercentAmt + adjFixAmt) - (totalBillMat + totalBillFrame);
        }

        //Ben
        $('#txtConvertAmt').val(Math.floor(conversionAmt));
        $('#txtTotalAmt').val(Math.floor((conversionAmt + (totalOutstandingMat + totalOutstandingFrame)) / 1));
    }

    function fn_validInfoSimul() {

        var valid = '';
        var msgT = '';
        var msg = '';

        Common.ajaxSync("GET", "/sales/order/selectValidateInfoSimul.do", {salesOrdNo : $('#txtOrderNoMat').val()}, function(rsltInfo) {
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
    <input type="hidden" id="reportFileName" name="reportFileName" value="/homecare/hcRentalToOutrightSimulatorForm.rpt" /><!-- Report Name  -->
    <input type="hidden" id="viewType" name="viewType" value="PDF" /><!-- View Type  -->
    <input type="hidden" id="reportDownFileName" name="reportDownFileName" value="" /> <!-- Download Name -->

    <!-- params -->
    <input type="hidden" id="_printOrdId" name="OrderID" />
    <input type="hidden" id="_printUserName" name="Username">
    <input type="hidden" id="_printBranchCode" name="BranchCode">
    <input type="hidden" id="_printOutrightPrice" name="OutrightPrice">
    <input type="hidden" id="_printLastBillMth" name="LastBillMth">
    <input type="hidden" id="_printLastBillMthFrame" name="LastBillMthFrame">
    <input type="hidden" id="_printTotalBillAmt" name="TotalBillAmt">
    <input type="hidden" id="_printTotalBillFrame" name="TotalBillAmtFrame">
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
<input id="hiddenOrderIDMat" name="ordIdMat" type="hidden" />
<input id="hiddenOrderIDFrame" name="ordIdFrame" type="hidden" />
<input id="hiddenStockID"           type="hidden" />
<input id="hiddenOrderDate"         type="hidden" />
<input id="hiddenTotalBillRPF"      type="hidden" />
<input id="hiddenInstallDate"       type="hidden" />
<input id="hiddenLastBillMth"       type="hidden" />
<input id="hiddenLastBillMthFrame"       type="hidden" />
<input id="hiddenAdjPercentInd"     type="hidden" />
<input id="hiddenAdjPercent"        type="hidden" />
<input id="hiddenAdjPercentAmt"     type="hidden" />
<input id="hiddenAdjFixAmt"         type="hidden" />
<input id="hiddenAdjFixInd"         type="hidden" />
<input id="hiddenDiffInstallMonth"  type="hidden" />
<input id="hiddenTotalOutstandingTotal"  type="hidden" />

<aside class="title_line"><!-- title_line start -->
<h3 style="margin-right:170px">Order Information (Mattress Only/ Mattress Set)</h3>
<h3>Order Information (Frame Only)</h3>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:150px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Order Number</th>
    <td><input id="txtOrderNoMat" name="txtOrderNoMat" type="text" title="" placeholder="" class="" />
        <p class="btn_sky"><a id="btnConfirmSimulMat" href="#">Confirm</a></p>
        <p class="btn_sky"><a id="btnReselectSimulMat" href="#" class="blind">Reselect</a></p>
        <p class="btn_sky"><a id="btnViewLedgerSimulMat" href="#" >View Ledger</a></p>
        <!-- <p class="btn_sky"><a id="btnPrintSimulMat" href="#" class="blind">Print</a></p> -->
    </td>
    <th scope="row">Order Number</th>
    <td><input id="txtOrderNoFrame" name="txtOrderNoFrame" type="text" title="" placeholder="" class="" />
        <p class="btn_sky"><a id="btnConfirmSimulFrame" href="#" class="blind">Confirm</a></p>
        <p class="btn_sky"><a id="btnViewLedgerSimulFrame" href="#" >View Ledger</a></p>
    </td>
</tr>
<tr>
    <th scope="row">Outright Price</th>
    <td><input id="txtOutrightPrice" name="txtOutrightPrice" type="text" title="" placeholder="" class="readonly" readonly="readonly" /></td>
    <th scope="row"</th>
    <td></td>

</tr>
<tr>
    <th scope="row">Total Billed Amount</th>
    <td><input id="txtTotalBillAmtMat" name="txtTotalBillAmtMat" type="text" title="" placeholder="" class="readonly" readonly="readonly" /></td>
<th scope="row">Total Billed Amount</th>
    <td><input id="txtTotalBillAmtFrame" name="txtTotalBillAmtFrame" type="text" title="" placeholder="" class="readonly" readonly="readonly" /></td>

</tr>
<tr>
    <th scope="row">Current Bill Month</th>
    <td><input id="txtCurrentBillMthMat" name="txtCurrentBillMthMat" type="text" title="" placeholder="" class="readonly" readonly="readonly" /></td>
    <th scope="row">Current Bill Month</th>
    <td><input id="txtCurrentBillMthFrame" name="txtCurrentBillMthFrame" type="text" title="" placeholder="" class="readonly" readonly="readonly" /></td>
</tr>
<tr>
    <th scope="row">Current Outstanding</th>
    <td><input id="txtCurrentOutstandingMat" name="txtCurrentOutstandingMat" type="text" title="" placeholder="" class="readonly" readonly="readonly" /></td>
    <th scope="row">Current Outstanding</th>
    <td><input id="txtCurrentOutstandingFrame" name="txtCurrentOutstandingFrame" type="text" title="" placeholder="" class="readonly" readonly="readonly" /></td>
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
<div id="generateRpt" class="hideContent3" style="display: table-cell; float: right; width: 10%; "><p class="btn_sky"><a id="btnGenerate" href="#" >Generate</a></p></div>
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