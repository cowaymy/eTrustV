<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript" language="javascript">
    
    var TAB_NM        = '${ordEditType}';
    var ORD_ID        = '${orderDetail.basicInfo.ordId}';
    var ORD_NO        = '${orderDetail.basicInfo.ordNo}';
    var ORD_STUS_ID   = '${orderDetail.basicInfo.ordStusId}';
    var ORD_STUS_CODE = '${orderDetail.basicInfo.ordStusCode}';
    var CUST_ID       = '${orderDetail.basicInfo.custId}';
    var APP_TYPE_ID   = '${orderDetail.basicInfo.appTypeId}';
    var APP_TYPE_DESC = '${orderDetail.basicInfo.appTypeDesc}';
    var CUST_NRIC     = '${orderDetail.basicInfo.custNric}';
    var PROMO_CODE    = '${orderDetail.basicInfo.ordPromoCode}';
    var PROMO_DESC    = '${orderDetail.basicInfo.ordPromoDesc}';
    var CNVR_SCHEME_ID= '${orderDetail.basicInfo.cnvrSchemeId}';
    var TODAY_DD      = '${toDay}';

    $(document).ready(function(){
        doGetComboData('/common/selectCodeList.do', {groupCode :'348'}, TAB_NM, 'ordReqType', 'S'); //Order Edit Type
        
        if(FormUtil.isNotEmpty(TAB_NM)) {
            fn_changeTab(TAB_NM);
        }
        
    });

    $(function(){
        $('#btnEditType').click(function() {
            var tabNm = $('#ordReqType').val();            
            fn_changeTab(tabNm);
        });
        $('#txtPenaltyAdj').change(function() {
            if(FormUtil.isEmpty($('#txtPenaltyAdj').val().trim())) {
                $('#txtPenaltyAdj').val(0);
            }
            fn_calculatePenaltyAndTotalAmount();
        });
        $('#txtPenaltyAdj').keydown(function (event) {  
            if (event.which == 13) {    //enter
                if(FormUtil.isEmpty($('#txtPenaltyAdj').val().trim())) {
                    $('#txtPenaltyAdj').val(0);
                }
                fn_calculatePenaltyAndTotalAmount();
            }  
        });
        $('#btnReqCancOrder').click(function() {
            if(fn_validReqCancelOrder()) fn_clickBtnReqCancelOrder();
        });
    });
    
    function fn_changeTab(tabNm) {
        
        if(tabNm == 'CANC') {
            if(ORD_STUS_ID != '1' && ORD_STUS_ID != '4') {
                var msg = "[" + ORD_NO + "] is under [" + APP_TYPE_DESC + "] status.<br/>"
                        + "Order cancellation request is disallowed.";
                        
                Common.alert("Action Restriction" + DEFAULT_DELIMITER + "<b>" + msg + "</b>", fn_selfClose);
                
                return false;
            }
            
            var todayDD = Number(TODAY_DD.substr(0, 2));
            
            console.log('todayDD:'+todayDD);
            
            if(todayDD == 26 || todayDD == 27 || todayDD == 1 || todayDD == 2) {
                var msg = "Request for order cancellation is restricted on 26, 27, 1, 2 of every month";
                        
                Common.alert("Action Restriction" + DEFAULT_DELIMITER + "<b>" + msg + "</b>", fn_selfClose);
                
                return false;
            }
        }
        
        var vTit = 'Order Request';
        
        if($("#ordReqType option:selected").index() > 0) {
            vTit += ' - '+$('#ordReqType option:selected').text();
        }
        
        $('#hTitle').text(vTit);

        if(tabNm == 'CANC') {
            $('#scCN').removeClass("blind");
            $('#aTabMI').click();
            console.log('call fn_loadList');
            fn_loadList();
            
            fn_loadOrderInfo();

            fn_isLockOrder();
        } else {
            $('#scCN').addClass("blind");
        }

    }
    
    function fn_isLockOrder() {
        var isLock = false;
        var msg = "";
        
        console.log('isLok:'+'${orderDetail.logView.isLok}');
        console.log('prgrsId:'+'${orderDetail.logView.prgrsId}');
        console.log('prgrs:'+'${orderDetail.logView.prgrs}');
        
        if('${orderDetail.logView.isLok}' == '1' && '${orderDetail.logView.prgrsId}' != 2) {
            isLock = true;
            msg = 'This order is under progress [' + '${orderDetail.logView.prgrs}' + '].<br />'
                + 'Request order cancelltion is disallowed.';
        }

        if(isLock) {
            fn_disableControl();
            Common.alert("Order Locked" + DEFAULT_DELIMITER + "<b>"+msg+"</b>");
        }
        return isLock;
    }
    
    function fn_disableControl() {
        $('#cmbRequestor').prop("disabled", true);
        $('#cmbReason').prop("disabled", true);
        $('#dpCallLogDate').prop("disabled", true);
        $('#dpReturnDate').prop("disabled", true);
        $('#txtRemark').prop("disabled", true);
        $('#txtPenaltyAdj').prop("disabled", true);
        
        $('#btnReqOrder').addClass("blind");
    }
    
    function fn_loadOrderInfo() {
        if(ORD_STUS_ID == '4') {
            $('#spPrfRtnDt').removeClass("blind");
            $('#dpReturnDate').removeAttr("disabled");
            
            if(APP_TYPE_ID == '66') {
                $('#scOP').removeClass("blind");
            }
        }
        if(CNVR_SCHEME_ID == '1') {
            $('#txtObPeriod').val('36');
        }
        
        fn_loadOutstandingPenaltyInfo();
    }

    function fn_loadOutstandingPenaltyInfo() {
        if(APP_TYPE_ID == '66' && ORD_STUS_ID == '4') {
            
            var vTotalUseMth = fn_getOrderLastRentalBillLedger1();
            
            if(FormUtil.isNotEmpty(vTotalUseMth)) {
                $('#txtTotalUseMth').val(vTotalUseMth);
            }
            $('#txtRentalFees').val('${orderDetail.basicInfo.ordMthRental}');
            
            var vCurrentOutstanding = fn_getOrderOutstandingInfo();
            
            if(FormUtil.isNotEmpty(vCurrentOutstanding)) {
                $('#txtCurrentOutstanding').val(vCurrentOutstanding);
            }
            
            fn_calculatePenaltyAndTotalAmount();
        }
    }

    function fn_calculatePenaltyAndTotalAmount() {
        var TotalMthUse = Number($('#txtTotalUseMth').val());
        var ObPeriod    = Number($('#txtObPeriod').val());
        var RentalFees = Number($('#txtRentalFees').val());
        var CurrentOutstanding = Number($('#txtCurrentOutstanding').val());
        var PenaltyAdj = Number($('#txtPenaltyAdj').val());
        var PenaltyAmt = 0;
        
        if (TotalMthUse < ObPeriod) {
            PenaltyAmt = ((RentalFees * (ObPeriod - TotalMthUse)) / 2);
        }
        
        $('#txtPenaltyCharge').val(PenaltyAmt);

        var TotalAmt = CurrentOutstanding + PenaltyAmt + PenaltyAdj;

        $('#txtTotalAmount').val(TotalAmt);        
        $('#spTotalAmount').text(TotalAmt);
    }
    
    function fn_getOrderOutstandingInfo() {

        var vCurrentOutstanding = 0;
/*        
        Common.ajax("GET", "/sales/membership/callOutOutsProcedure", {ORD_ID : ORD_ID}, function(result) {

            if(result != null && result.outSuts.length >0 > 0) {
                console.log('result.outSuts[0].ordTotOtstnd:'+result.outSuts[0].ordTotOtstnd);

                vCurrentOutstanding = result.outSuts[0].ordTotOtstnd;
            }            
       }, null, {async : false});
*/
       return vCurrentOutstanding;
    }
    
    function fn_getOrderLastRentalBillLedger1() {

        var vTotalUseMth = 0;
        
        Common.ajax("GET", "/sales/order/selectOrderLastRentalBillLedger1.do", {salesOrderId : ORD_ID}, function(result) {
            
            console.log('result:'+result);
            
            if(result != null) {
                console.log('result.custId:'+result.rentInstNo);

                vTotalUseMth = result.rentInstNo;
            }            
       }, null, {async : false});

       return vTotalUseMth;
    }
    
    function fn_clickBtnReqCancelOrder() {
        var RequestStage = "Before Install";
        
        if(ORD_STUS_ID == '4') {
            RequestStage = "After Install";
        }
        
        var msg = "";
        msg += "Request Stage : " + RequestStage + "<br />";
        msg += "Requestor : " + $('#cmbRequestor option:selected').text() + "<br />";
        msg += "Reason : " + $('#cmbReason option:selected').text() + "<br />";
        msg += "Call Log Date : " + $('#dpCallLogDate').val() + "<br />";
    
        if(ORD_STUS_ID == '4') {
            msg += "Prefer Return Date : " + $('#dpReturnDate').val() + "<br />";
            
            if(APP_TYPE_ID == 66) {
                msg += "<br />";
                msg += "Total Used Month : "   + $('#txtTotalUseMth').val()      + "<br/>";
                msg += "Obligation Period : "  + $('#txtObPeriod').val()         + "<br/>";
                msg += "Penalty Amount : "     + $('#txtPenaltyCharge').val()    + "<br/>";
                msg += "Penalty Adjustment : " + $('#txtPenaltyAdj').val().trim()+ "<br/>";
                msg += "Total Amount : "       + $('#txtTotalAmount').val()      + "<br/>";
            }
        }
        msg += "<br/>Are you sure want to request order cancellation ?<br/><br/>";

        Common.confirm("Request Cancel Confirmation" + DEFAULT_DELIMITER + "<b>"+msg+"</b>", fn_selfClose);
    }

    function fn_doSaveReqCancelOrder() {
        console.log('!@# fn_doSaveReqCancelOrder START');

        Common.ajax("POST", "/sales/order/requestCancelOrder.do", $('#frmReqCanc').serializeJSON(), function(result) {
                
                Common.alert("Cancellation Request Summary" + DEFAULT_DELIMITER + "<b>"+result.message+"</b>", fn_reloadPage);
            
            }, function(jqXHR, textStatus, errorThrown) {
                try {
                    Common.alert("Data Preparation Failed" + DEFAULT_DELIMITER + "<b>Saving data prepration failed.<br />"+"Error message : " + jqXHR.responseJSON.message + "</b>");
                }
                catch(e) {
                    console.log(e);
                }
            }
        );
    }

    function fn_validReqCancelOrder() {
        var isValid = true, msg = "";

        if($("#cmbRequestor option:selected").index() <= 0) {
            isValid = false;
            msg += "* Please select the requestor.<br>";
        }
        if($("#cmbReason option:selected").index() <= 0) {
            isValid = false;
            msg += "* Please select the reason.<br>";
        }
        if(FormUtil.checkReqValue($('#dpCallLogDate'))) {
            isValid = false;
            msg += "* Please key in the call log date.<br>";
        }
        if(ORD_STUS_ID == '4' && FormUtil.checkReqValue($('#dpReturnDate'))) {
            isValid = false;
            msg += "* Please key in the prefer return date.<br>";
        }
        if(FormUtil.checkReqValue($('#txtRemark'))) {
            isValid = false;
            msg += "* Please key in the remark.<br>";
        }
        
        if(!isValid) Common.alert("Order Cancellation Request Summary" + DEFAULT_DELIMITER + "<b>"+msg+"</b>");

        return isValid;
    }
    
    function fn_loadList() {
        console.log('called fn_loadList');
        doGetComboOrder('/common/selectCodeList.do', '52',  'CODE_ID',  '', 'cmbRequestor', 'S', ''); //Common Code
        doGetComboData('/sales/order/selectResnCodeList.do', '', '', 'cmbReason', 'S', ''); //Reason Code
    }
    
    function fn_selfClose() {
        $('#btnCloseReq').click();
    }
    
	function fn_reloadPage(){
	    Common.popupDiv("/sales/order/orderRequestPop.do", { salesOrderId : ORD_ID, ordReqType : $('#ordReqType').val() }, null , true);
	    $('#btnCloseReq').click();
	}
</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1 id="hTitle">Order Request</h1>
<ul class="right_opt">
	<li><p class="btn_blue2"><a id="btnCloseReq" href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<section class="search_table"><!-- search_table start -->

<form action="#" method="post">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:110px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row">Edit Type</th>
	<td>
	<select id="ordReqType" class="mr5"></select>
	<p class="btn_sky"><a id="btnEditType" href="#">Confirm</a></p>
	</td>
</tr>
</tbody>
</table><!-- table end -->

</form>
</section><!-- search_table end -->

<!------------------------------------------------------------------------------
    Order Detail Page Include START
------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/jsp/sales/order/orderDetailContent.jsp" %>
<!------------------------------------------------------------------------------
    Order Detail Page Include END
------------------------------------------------------------------------------->

<!------------------------------------------------------------------------------
    Order Cancellation Request START
------------------------------------------------------------------------------->
<section id="scCN" class="blind">
<aside class="title_line"><!-- title_line start -->
<h3>Order Cancellation Request Information</h3>
</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->
<form id="frmReqCanc" action="#" method="post">

<input name="salesOrdId" type="hidden" value="${orderDetail.basicInfo.ordId}"/>

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:180px" />
	<col style="width:*" />
	<col style="width:180px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row">Requestor<span class="must">*</span></th>
	<td>
	<select id="cmbRequestor" name="cmbRequestor" class="w100p"></select>
	</td>
	<th scope="row">Call Log Date<span class="must">*</span></th>
	<td><input id="dpCallLogDate" name="dpCallLogDate" type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p" /></td>
</tr>
<tr>
	<th scope="row">Reason<span class="must">*</span></th>
	<td>
	<select id="cmbReason" name="cmbReason" class="w100p"></select>
	</td>
	<th scope="row">Prefer Return Date<span id="spPrfRtnDt" class="must blind">*</span></th>
	<td><input id="dpReturnDate" name="dpReturnDate" type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p" disabled/></td>
</tr>
<tr>
	<th scope="row">OCR Remark<span class="must">*</span></th>
	<td colspan="3"><textarea id="txtRemark" name="txtRemark" cols="20" rows="5"></textarea></td>
</tr>
</tbody>
</table><!-- table end -->

<!-- Outstanding & Penalty Info Edit START------------------------------------->
<section id="scOP" class="blind">
<aside class="title_line"><!-- title_line start -->
<h3>Outstanding & Penalty Information</h3>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:180px" />
	<col style="width:*" />
	<col style="width:180px" />
	<col style="width:*" />
	<col style="width:180px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<td colspan="4"></td>
	<th scope="row">Total Amount (RM)</th>
	<td class="bg-black"><span id="spTotalAmount"></span>
	<input id="txtTotalAmount" name="txtTotalAmount" type="hidden" />
	</td>
</tr>
<tr>
	<th scope="row">Total Used Month</th>
	<td><input id="txtTotalUseMth" name="txtTotalUseMth" type="text" class="w100p readonly" value="0" readonly></td>
	<th scope="row">Obligation Period</th>
	<td><input id="txtObPeriod" name="txtObPeriod" type="text" class="w100p readonly" value="24" readonly></td>
	<th scope="row">Rental Fees</th>
	<td><input id="txtRentalFees" name="txtRentalFees" type="text" class="w100p readonly" readonly></td>
</tr>
<tr>
	<th scope="row">Penalty Charge</th>
	<td><input id="txtPenaltyCharge" name="txtPenaltyCharge" type="text" class="w100p readonly" readonly></td>
	<th scope="row">Penalty Adjustment<span class="must">*</span></th>
	<td><input id="txtPenaltyAdj" name="txtPenaltyAdj" type="text" title="" placeholder="Penalty Adjustment" class="w100p" value="0" /></td>
	<th scope="row">Current Outstanding</th>
	<td><input id="txtCurrentOutstanding" name="txtCurrentOutstanding" type="text" class="w100p readonly" readonly></td>
</tr>
</tbody>
</table><!-- table end -->

</section>
<!-- Outstanding & Penalty Info Edit END--------------------------------------->

</form>
</section><!-- search_table end -->

<ul class="center_btns">
	<li><p class="btn_blue2"><a id="btnReqCancOrder" name="btnReqOrder" href="#">Request Cancel Order</a></p></li>
</ul>
</section>
<!------------------------------------------------------------------------------
    Order Cancellation Request END
------------------------------------------------------------------------------->

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->