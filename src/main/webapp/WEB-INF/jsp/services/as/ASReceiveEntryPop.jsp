<script type="text/javaScript">
function fn_ASSave(){
	Common.ajax("POST", "/services/as/searchOrderNo.do", $("#orderNo").serialize(), function(result) {
        console.log("성공.");
        console.log("data : " + result.serialize());
 
    });
}
function fn_searchOrderNo(){
	Common.ajax("GET", "/services/as/addASNo.do", $("#saveASForm").serializeJSON(), function(result) {
        console.log("성공.");
        console.log("data : " + result.serialize());
       
        var a = "${result.ordId}";
        $('input[name=hiddenOrderID]').attr('value',"${result.ordId}");
    });
}
</script>
<div id="popup_wrap"><!-- popup_wrap start -->
<section id="content"><!-- content start -->

<header class="pop_header"><!-- pop_header start -->
<h1>AS ReceiveEntry</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id="saveASForm">
<input type="hidden" value="" id="hiddenOrderID" name="hiddenOrderID"/>
<input type="hidden" value="${result.ordNo}" id="hiddenOrderNo" name="hiddenOrderNo"/>
<input type="hidden" value="${result.custName}" id="hiddenCustName" name="hiddenCustName"/>
<input type="hidden" value="${result.stockCode}" id="hiddenStkCode" name="hiddenStkCode"/>
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:100px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Order No</th>
    <td><input type="text" title="" placeholder="" class="" id="orderNo" name="orderNo"/><p class="btn_sky"><a href="#" onClick="fn_searchOrderNo()">Confirm</a></p><p class="btn_sky"><a href="#">Search</a></p></td>
</tr>
</tbody>
</table><!-- table end -->
</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<section class="tap_wrap"><!-- tap_wrap start -->
<ul class="tap_type1">
    <li><a href="#" class="on">Order Info</a></li>
    <li><a href="#">After Service</a></li>
    <li><a href="#">Before Service</a></li>
</ul>

<article class="tap_area"><!-- tap_area start -->

<section class="tap_wrap mt0"><!-- tap_wrap start -->
    <ul class="tap_type1 num4">
        <li><a href="#" class="on">Basic Info</a></li>
        <li><a href="#">HP / Cody</a></li>
        <li><a href="#">Customer Info</a></li>
        <li><a href="#">Installation Info</a></li>
        <li><a href="#">Mailing Info</a></li>
        <li><a href="#">Payment Channel</a></li>
        <li><a href="#">Membership Info</a></li>
        <li><a href="#">Document Submission</a></li>
        <li><a href="#">Call Log</a></li>
        <li><a href="#">Guarantee Info</a></li>
        <li><a href="#">Payment Listing</a></li>
        <li><a href="#">Last 6 Months Transaction</a></li>
        <li><a href="#">Order Configuration</a></li>
        <li><a href="#">Auto Debit Result</a></li>
        <li><a href="#">Relief Certificate</a></li>
        <li><a href="#">Discount</a></li>
    </ul>

    <article class="tap_area"><!-- tap_area start -->

    <table class="type1"><!-- table start -->
    <caption>table</caption>
    <colgroup>
        <col style="width:130px" />
        <col style="width:*" />
        <col style="width:130px" />
        <col style="width:*" />
        <col style="width:130px" />
        <col style="width:*" />
    </colgroup>
    <tbody>
    <tr>
        <th scope="row">Progress Status</th>
        <td>
        <span></span>
        </td>
        <th scope="row">Agreement No</th>
        <td>
        </td>
        <th scope="row">Agreement Expiry</th>
        <td>
        </td>
    </tr>
    <tr>
        <th scope="row">Order No</th>
        <td>
        </td>
        <th scope="row">Order Date</th>
        <td>
        </td>
        <th scope="row">Status</th>
        <td>
        </td>
    </tr>
    <tr>
        <th scope="row">Application Type</th>
        <td>
        </td>
        <th scope="row">Reference No</th>
        <td>
        </td>
        <th scope="row">Key At (By)</th>
        <td>
        </td>
    </tr>
    <tr>
        <th scope="row">Product</th>
        <td>
        </td>
        <th scope="row">PO Number</th>
        <td>
        </td>
        <th scope="row">Key-In Branch</th>
        <td>
        </td>
    </tr>
    <tr>
        <th scope="row">PV</th>
        <td>
        </td>
        <th scope="row">Price/RPF</th>
        <td>
        </td>
        <th scope="row">Rental Fees</th>
        <td>
        </td>
    </tr>
    <tr>
        <th scope="row">Installment Duration</th>
        <td>
        </td>
        <th scope="row">PV Month (month/year)</th>
        <td>
        </td>
        <th scope="row">Rental Status</th>
        <td>
        </td>
    </tr>
    <tr>
        <th scope="row">Promotion</th>
        <td colspan="3">
        </td>
        <th scope="row">Related No</th>
        <td>
        </td>
    </tr>
    <tr>
        <th scope="row">Serial Number</th>
        <td>
        </td>
        <th scope="row">Sirim Number</th>
        <td>
        </td>
        <th scope="row">Update At (By)</th>
        <td>
        </td>
    </tr>
    <tr>
        <th scope="row">Obligation Period</th>
        <td colspan="5">
        </td>
    </tr>
    <tr>
        <th scope="row">Remark</th>
        <td colspan="5">
        </td>
    </tr>
    <tr>
        <th scope="row">CCP Feedback Code</th>
        <td colspan="5">
        </td>
    </tr>
    <tr>
        <th scope="row">CCP Remark</th>
        <td colspan="5">
        </td>
    </tr>
    </tbody>
    </table><!-- table end -->

    </article><!-- tap_area end -->

    <article class="tap_area"><!-- tap_area start -->

    <div class="divine_auto"><!-- divine_auto start -->

    <div style="width:50%;">

    <div class="border_box"><!-- border_box start -->

    <aside class="title_line"><!-- title_line start -->
    <h3 class="pt0">Salesman Info</h3>
    </aside><!-- title_line end -->
    
    <table class="type1"><!-- table start -->
    <caption>table</caption>
    <colgroup>
        <col style="width:150px" />
        <col style="width:*" />
    </colgroup>
    <tbody>
    <tr>
        <th scope="row" rowspan="3">Order Made By</th>
        <td><span></span></td>
    </tr>
    <tr>
        <td><span></span></td>
    </tr>
    <tr>
        <td><span></span></td>
    </tr>
    <tr>
        <th scope="row">Salesman Code</th>
        <td><span></span></td>
    </tr>
    <tr>
        <th scope="row">Salesman Name</th>
        <td><span></span></td>
    </tr>
    <tr>
        <th scope="row">Salesman NRIC</th>
        <td><span></span></td>
    </tr>
    <tr>
        <th scope="row">Mobile No</th>
        <td><span></span></td>
    </tr>
    <tr>
        <th scope="row">Office No</th>
        <td><span></span></td>
    </tr>
    <tr>
        <th scope="row">House No</th>
        <td><span></span></td>
    </tr>
    </tbody>
    </table><!-- table end -->

    </div><!-- border_box end -->

    </div>

    <div style="width:50%;">

    <div class="border_box"><!-- border_box start -->

    <aside class="title_line"><!-- title_line start -->
    <h3 class="pt0">Cody Info</h3>
    </aside><!-- title_line end -->

    <table class="type1"><!-- table start -->
    <caption>table</caption>
    <colgroup>
        <col style="width:150px" />
        <col style="width:*" />
    </colgroup>
    <tbody>
    <tr>
        <th scope="row" rowspan="3">Service By</th>
        <td><span></span></td>
    </tr>
    <tr>
        <td><span></span></td>
    </tr>
    <tr>
        <td><span></span></td>
    </tr>
    <tr>
        <th scope="row">Cody Code</th>
        <td><span></span></td>
    </tr>
    <tr>
        <th scope="row">Cody Name</th>
        <td><span></span></td>
    </tr>
    <tr>
        <th scope="row">Cody NRIC</th>
        <td><span></span></td>
    </tr>
    <tr>
        <th scope="row">Mobile No</th>
        <td><span></span></td>
    </tr>
    <tr>
        <th scope="row">Office No</th>
        <td><span></span></td>
    </tr>
    <tr>
        <th scope="row">House No</th>
        <td><span></span></td>
    </tr>
    </tbody>
    </table><!-- table end -->

    </div><!-- border_box end -->

    </div>

    </div><!-- divine_auto end -->

    </article><!-- tap_area end -->

    <article class="tap_area"><!-- tap_area start -->
    <table class="type1"><!-- table start -->
    <caption>table</caption>
    <colgroup>
        <col style="width:140px" />
        <col style="width:*" />
        <col style="width:140px" />
        <col style="width:*" />
        <col style="width:130px" />
        <col style="width:*" />
    </colgroup>
    <tbody>
    <tr>
        <th scope="row">Customer ID</th>
        <td>
        <span></span>
        </td>
        <th scope="row">Customer Name</th>
        <td colspan="3">
        </td>
    </tr>
    <tr>
        <th scope="row">Customer Type</th>
        <td>
        </td>
        <th scope="row">NRIC/Company No</th>
        <td>
        </td>
        <th scope="row">JomPay Ref-1</th>
        <td>
        </td>
    </tr>
    <tr>
        <th scope="row">Nationality</th>
        <td>
        </td>
        <th scope="row">Gender</th>
        <td>
        </td>
        <th scope="row">Race</th>
        <td>
        </td>
    </tr>
    <tr>
        <th scope="row">VA Number</th>
        <td>
        </td>
        <th scope="row">Passport Expire</th>
        <td>
        </td>
        <th scope="row">Visa Expire</th>
        <td>
        </td>
    </tr>
    </tbody>
    </table><!-- table end -->

    <aside class="title_line"><!-- title_line start -->
    <h3>Same Rental Group Order(s)</h3>
    </aside><!-- title_line end -->

    <article class="grid_wrap"><!-- grid_wrap start -->
    그리드 영역
    </article><!-- grid_wrap end -->

    </article><!-- tap_area end -->

    <article class="tap_area"><!-- tap_area start -->

    <table class="type1"><!-- table start -->
    <caption>table</caption>
    <colgroup>
        <col style="width:140px" />
        <col style="width:*" />
        <col style="width:140px" />
        <col style="width:*" />
        <col style="width:140px" />
        <col style="width:*" />
    </colgroup>
    <tbody>
    <tr>
        <th scope="row" rowspan="3">Installation Address</th>
        <td colspan="3"></td>
        <th scope="row">Country</th>
        <td></td>
    </tr>
    <tr>
        <td colspan="3"></td>
        <th scope="row">State</th>
        <td></td>
    </tr>
    <tr>
        <td colspan="3"></td>
        <th scope="row">Area</th>
        <td></td>
    </tr>
    <tr>
        <th scope="row">Prefer Install Date</th>
        <td>
        </td>
        <th scope="row">Prefer Install Time</th>
        <td>
        </td>
        <th scope="row">Postcode</th>
        <td>
        </td>
    </tr>
    <tr>
        <th scope="row">Instruction</th>
        <td colspan="5">
        </td>
    </tr>
    <tr>
        <th scope="row">DSC Verification Remark</th>
        <td colspan="5">
        </td>
    </tr>
    <tr>
        <th scope="row">DSC Branch</th>
        <td colspan="3">
        </td>
        <th scope="row">Installed Date</th>
        <td>
        </td>
    </tr>
    <tr>
        <th scope="row">CT Code</th>
        <td>
        </td>
        <th scope="row">CT Name</th>
        <td colspan="3">
        </td>
    </tr>
    <tr>
        <th scope="row">Contact Name</th>
        <td colspan="3">
        </td>
        <th scope="row">Gender</th>
        <td>
        </td>
    </tr>
    <tr>
        <th scope="row">Contact NRIC</th>
        <td>
        </td>
        <th scope="row">Email</th>
        <td>
        </td>
        <th scope="row">Fax No</th>
        <td>
        </td>
    </tr>
    <tr>
        <th scope="row">Mobile No</th>
        <td>
        </td>
        <th scope="row">Office No</th>
        <td>
        </td>
        <th scope="row">House No</th>
        <td>
        </td>
    </tr>
    <tr>
        <th scope="row">Post</th>
        <td>
        </td>
        <th scope="row">Department</th>
        <td colspan="3">
        </td>
    </tr>
    </tbody>
    </table><!-- table end -->

    </article><!-- tap_area end -->

    <article class="tap_area"><!-- tap_area start -->

    <table class="type1"><!-- table start -->
    <caption>table</caption>
    <colgroup>
        <col style="width:140px" />
        <col style="width:*" />
        <col style="width:140px" />
        <col style="width:*" />
        <col style="width:140px" />
        <col style="width:*" />
    </colgroup>
    <tbody>
    <tr>
        <th scope="row" rowspan="3">Mailing Address</th>
        <td colspan="3"></td>
        <th scope="row">Country</th>
        <td></td>
    </tr>
    <tr>
        <td colspan="3"></td>
        <th scope="row">State</th>
        <td></td>
    </tr>
    <tr>
        <td colspan="3"></td>
        <th scope="row">Area</th>
        <td></td>
    </tr>
    <tr>
        <th scope="row">Billing Group</th>
        <td>
        </td>
        <th scope="row">Billing Type</th>
        <td>
        <label><input type="checkbox" /><span>SMS</span></label>
        <label><input type="checkbox" /><span>Post</span></label>
        <label><input type="checkbox" /><span>E-statement</span></label>
        </td>
        <th scope="row">Postcode</th>
        <td>
        </td>
    </tr>   
    <tr>
        <th scope="row">Contact Name</th>
        <td colspan="3">
        </td>
        <th scope="row">Gender</th>
        <td>
        </td>
    </tr>
    <tr>
        <th scope="row">Contact NRIC</th>
        <td>
        </td>
        <th scope="row">Email</th>
        <td>
        </td>
        <th scope="row">Fax No</th>
        <td>
        </td>
    </tr>
    <tr>
        <th scope="row">Mobile No</th>
        <td>
        </td>
        <th scope="row">Office No</th>
        <td>
        </td>
        <th scope="row">House No</th>
        <td>
        </td>
    </tr>
    <tr>
        <th scope="row">Post</th>
        <td>
        </td>
        <th scope="row">Department</th>
        <td colspan="3">
        </td>
    </tr>
    </tbody>
    </table><!-- table end -->

    </article><!-- tap_area end -->

    <article class="tap_area"><!-- tap_area start -->
    
    <table class="type1"><!-- table start -->
    <caption>table</caption>
    <colgroup>
        <col style="width:150px" />
        <col style="width:*" />
        <col style="width:140px" />
        <col style="width:*" />
        <col style="width:150px" />
        <col style="width:*" />
    </colgroup>
    <tbody>
    <tr>
        <th scope="row">Rental Paymode</th>
        <td>
        </td>
        <th scope="row">Direct Debit Mode</th>
        <td>
        </td>
        <th scope="row">Auto Debit Limit</th>
        <td>
        </td>
    </tr>
    <tr>
        <th scope="row">Issue Bank</th>
        <td>
        </td>
        <th scope="row">Card Type</th>
        <td>
        </td>
        <th scope="row">Claim Bill Date</th>
        <td>
        </td>
    </tr>
    <tr>
        <th scope="row">Credit Card No</th>
        <td>
        </td>
        <th scope="row">Name On Card</th>
        <td>
        </td>
        <th scope="row">Expiry Date</th>
        <td>
        </td>
    </tr>
    <tr>
        <th scope="row">Bank Account No</th>
        <td>
        </td>
        <th scope="row">Account Name</th>
        <td>
        </td>
        <th scope="row">Issue NRIC</th>
        <td>
        </td>
    </tr>
    <tr>
        <th scope="row">Apply Date</th>
        <td>
        </td>
        <th scope="row">Submit Date</th>
        <td>
        </td>
        <th scope="row">Start Date</th>
        <td>
        </td>
    </tr>
    <tr>
        <th scope="row">Reject Date</th>
        <td>
        </td>
        <th scope="row">Reject Code</th>
        <td>
        </td>
        <th scope="row">Payment Term</th>
        <td>
        </td>
    </tr>
    <tr>
        <th scope="row">Pay By Third Party</th>
        <td>
        </td>
        <th scope="row">Third Party ID</th>
        <td>
        </td>
        <th scope="row">Third Party Type</th>
        <td>
        </td>
    </tr>
    <tr>
        <th scope="row">Third Party Name</th>
        <td colspan="3">
        </td>
        <th scope="row">Third Party NRIC</th>
        <td>
        </td>
    </tr>
    </tbody>
    </table><!-- table end -->

    </article><!-- tap_area end -->

    <article class="tap_area"><!-- tap_area start -->

    <article class="grid_wrap"><!-- grid_wrap start -->
    그리드 영역
    </article><!-- grid_wrap end -->

    </article><!-- tap_area end -->

    <article class="tap_area"><!-- tap_area start -->

    <article class="grid_wrap"><!-- grid_wrap start -->
    그리드 영역
    </article><!-- grid_wrap end -->

    </article><!-- tap_area end -->

    <article class="tap_area"><!-- tap_area start -->

    <article class="grid_wrap"><!-- grid_wrap start -->
    그리드 영역
    </article><!-- grid_wrap end -->

    </article><!-- tap_area end -->

    <article class="tap_area"><!-- tap_area start -->

    <table class="type1"><!-- table start -->
    <caption>table</caption>
    <colgroup>
        <col style="width:155px" />
        <col style="width:*" />
        <col style="width:155px" />
        <col style="width:*" />
    </colgroup>
    <tbody>
    <tr>
        <th scope="row">Guarantee Status</th>
        <td colspan="3"></td>
    </tr>
    <tr>
        <th scope="row">HP Code</th>
        <td></td>
        <th scope="row">HP Name (NRIC)</th>
        <td></td>
    </tr>
    <tr>
        <th scope="row">HM Code</th>
        <td></td>
        <th scope="row">HM Name (NRIC)</th>
        <td></td>
    </tr>
    <tr>
        <th scope="row">SM Code</th>
        <td></td>
        <th scope="row">SM Name (NRIC)</th>
        <td></td>
    </tr>
    <tr>
        <th scope="row">GM Code</th>
        <td></td>
        <th scope="row">GM Name (NRIC)</th>
        <td></td>
    </tr>
    </tbody>
    </table><!-- table end -->

    </article><!-- tap_area end -->

    <article class="tap_area"><!-- tap_area start -->

    <article class="grid_wrap"><!-- grid_wrap start -->
    그리드 영역
    </article><!-- grid_wrap end -->

    </article><!-- tap_area end -->

    <article class="tap_area"><!-- tap_area start -->

    <article class="grid_wrap"><!-- grid_wrap start -->
    그리드 영역
    </article><!-- grid_wrap end -->

    </article><!-- tap_area end -->

    <article class="tap_area"><!-- tap_area start -->

    <table class="type1"><!-- table start -->
    <caption>table</caption>
    <colgroup>
        <col style="width:140px" />
        <col style="width:*" />
        <col style="width:140px" />
        <col style="width:*" />
        <col style="width:140px" />
        <col style="width:*" />
    </colgroup>
    <tbody>
    <tr>
        <th scope="row">BS Availability</th>
        <td>
        <span></span>
        </td>
        <th scope="row">BS Frequency</th>
        <td></td>
        <th scope="row">3Last BS Date</th>
        <td></td>
    </tr>
    <tr>
        <th scope="row">BS Cody Code</th>
        <td colspan="5"></td>
    </tr>
    <tr>
        <th scope="row">Config Remark</th>
        <td colspan="5"></td>
    </tr>
    <tr>
        <th scope="row">Happy Call Service</th>
        <td colspan="5">
        <label><input type="checkbox" /><span>Installation Type</span></label>
        <label><input type="checkbox" /><span>BS Type</span></label>
        <label><input type="checkbox" /><span>AS Type</span></label>
        </td>
    </tr>
    <tr>
        <th scope="row">Prefer BS Week</th>
        <td colspan="5">
        <label><input type="radio" name="week" /><span>None</span></label>
        <label><input type="radio" name="week" /><span>Week 1</span></label>
        <label><input type="radio" name="week" /><span>Week 2</span></label>
        <label><input type="radio" name="week" /><span>Week 3</span></label>
        <label><input type="radio" name="week" /><span>Week 4</span></label>
        </td>
    </tr>
    </tbody>
    </table><!-- table end -->

    </article><!-- tap_area end -->

    <article class="tap_area"><!-- tap_area start -->

    <article class="grid_wrap"><!-- grid_wrap start -->
    그리드 영역
    </article><!-- grid_wrap end -->
    <span class="red_text">Disclaimer : This data is subject to Coway private information property which is not meant to view by any public other than coway internal staff only.</span>

    </article><!-- tap_area end -->

    <article class="tap_area"><!-- tap_area start -->

    <table class="type1"><!-- table start -->
    <caption>table</caption>
    <colgroup>
        <col style="width:180px" />
        <col style="width:*" />
        <col style="width:150px" />
        <col style="width:*" />
    </colgroup>
    <tbody>
    <tr>
        <th scope="row">Reference No</th>
        <td>
        <input type="text" title="" placeholder="Reference No" class="w100p" />
        </td>
        <th scope="row">Certificate Date</th>
        <td>
        <input type="text" title="" placeholder="Certificate Date" class="w100p" />
        </td>
    </tr>
    <tr>
        <th scope="row">GST Registration No</th>
        <td colspan="3">
        <input type="text" title="" placeholder="GST Registration No" class="w100p" />
        </td>
    </tr>
    <tr>
        <th scope="row">Remark</th>
        <td colspan="3">
        <textarea cols="20" rows="5"></textarea>
        </td>
    </tr>
    </tbody>
    </table><!-- table end -->

    </article><!-- tap_area end -->

    <article class="tap_area"><!-- tap_area start -->

    <article class="grid_wrap"><!-- grid_wrap start -->
    그리드 영역
    </article><!-- grid_wrap end -->

    </article><!-- tap_area end -->

    </section><!-- tap_wrap end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<article class="grid_wrap"><!-- grid_wrap start -->
그리드 영역
</article><!-- grid_wrap end -->

</article><!-- tap_area end -->

</section><!-- tap_wrap end -->

<aside class="title_line"><!-- title_line start -->
<h3>AS Application Information</h3>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:140px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Request Date<span class="must">*</span></th>
    <td>
    <input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p" id="requestDate" name="requestDate"/>
    </td>
    <th scope="row">Request Time<span class="must">*</span></th>
    <td>

    <div class="time_picker w100p"><!-- time_picker start -->
    <input type="text" title="" placeholder="" class="time_date w100p" id="requestTime" name="requestTime"/>
    <ul>
        <li>Time Picker</li>
        <li><a href="#">12:00 AM</a></li>
        <li><a href="#">01:00 AM</a></li>
        <li><a href="#">02:00 AM</a></li>
        <li><a href="#">03:00 AM</a></li>
        <li><a href="#">04:00 AM</a></li>
        <li><a href="#">05:00 AM</a></li>
        <li><a href="#">06:00 AM</a></li>
        <li><a href="#">07:00 AM</a></li>
        <li><a href="#">08:00 AM</a></li>
        <li><a href="#">09:00 AM</a></li>
        <li><a href="#">10:00 AM</a></li>
        <li><a href="#">11:00 AM</a></li>
        <li><a href="#">12:00 PM</a></li>
        <li><a href="#">01:00 PM</a></li>
        <li><a href="#">02:00 PM</a></li>
        <li><a href="#">03:00 PM</a></li>
        <li><a href="#">04:00 PM</a></li>
        <li><a href="#">05:00 PM</a></li>
        <li><a href="#">06:00 PM</a></li>
        <li><a href="#">07:00 PM</a></li>
        <li><a href="#">08:00 PM</a></li>
        <li><a href="#">09:00 PM</a></li>
        <li><a href="#">10:00 PM</a></li>
        <li><a href="#">11:00 PM</a></li>
    </ul>
    </div><!-- time_picker end -->

    </td>
    <th scope="row">Appointment Date<span class="must">*</span></th>
    <td>
    <input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p" id="appDate" name="appDate"/>
    </td>
    <th scope="row">Appointment Time<span class="must">*</span></th>
    <td>

    <div class="time_picker w100p"><!-- time_picker start -->
    <input type="text" title="" placeholder="" class="time_date w100p" id="appTime" name="appTime"/>
    <ul>
        <li>Time Picker</li>
        <li><a href="#">12:00 AM</a></li>
        <li><a href="#">01:00 AM</a></li>
        <li><a href="#">02:00 AM</a></li>
        <li><a href="#">03:00 AM</a></li>
        <li><a href="#">04:00 AM</a></li>
        <li><a href="#">05:00 AM</a></li>
        <li><a href="#">06:00 AM</a></li>
        <li><a href="#">07:00 AM</a></li>
        <li><a href="#">08:00 AM</a></li>
        <li><a href="#">09:00 AM</a></li>
        <li><a href="#">10:00 AM</a></li>
        <li><a href="#">11:00 AM</a></li>
        <li><a href="#">12:00 PM</a></li>
        <li><a href="#">01:00 PM</a></li>
        <li><a href="#">02:00 PM</a></li>
        <li><a href="#">03:00 PM</a></li>
        <li><a href="#">04:00 PM</a></li>
        <li><a href="#">05:00 PM</a></li>
        <li><a href="#">06:00 PM</a></li>
        <li><a href="#">07:00 PM</a></li>
        <li><a href="#">08:00 PM</a></li>
        <li><a href="#">09:00 PM</a></li>
        <li><a href="#">10:00 PM</a></li>
        <li><a href="#">11:00 PM</a></li>
    </ul>
    </div><!-- time_picker end -->

    </td>
</tr>
<tr>
    <th scope="row">Error Code<span class="must">*</span></th>
    <td colspan="3">
    <select class="w100p" id="errorCode" name="errorCode">
    </select>
    </td>
    <th scope="row">Error Description<span class="must">*</span></th>
    <td colspan="3">
    <select class="w100p" id="errorDesc" name="errorDesc">
    </select>
    </td>
</tr>
<tr>
    <th scope="row">DSC Branch<span class="must">*</span></th>
    <td colspan="3">
    <select class="w100p" id="branchDSC" name="branchDSC">
    </select>
    </td>
    <th scope="row">CT Group<span class="must">*</span></th>
    <td>
    <select class="w100p" id="CTGroup" name="CTGroup">
    </select>
    </td>
    <th scope="row">BS Within 30 Days</th>
    <td>
    <label><input type="checkbox" id="checkBS" name="checkBS"/></label>
    </td>
</tr>
<tr>
    <th scope="row">Assign CT<span class="must">*</span></th>
    <td colspan="3">
    <select class="w100p" id="assignCT" name="assignCT">
    </select>
    </td>
    <th scope="row">Mobile No</th>
    <td>
    <input type="text" title="" placeholder="" class="w100p" id="mobileNo" name="mobileNo"/>
    </td>
    <th scope="row">SMS</th>
    <td>
    <label><input type="checkbox" id="checkSms" name="checkSms"/></label>
    </td>
</tr>
<tr>
    <th scope="row">Person Incharge</th>
    <td colspan="3">
    <input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" id="perIncharge"  name="perIncharge"/>
    </td>
    <th scope="row">Person Incharge Contact</th>
    <td colspan="3">
    <input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" id="perContact" name="perContact"/>
    </td>
</tr>
<tr>
    <th scope="row" rowspan="3">Requestor<span class="must">*</span></th>
    <td colspan="3">
    <select class="w100p" id="requestor" name="requestor">
    </select>
    </td>
    <th scope="row">Requestor Contact</th>
    <td>
    <input type="text" title="" placeholder="" class="w100p" id="requestorCont" name="requestorCont"/>
    </td>
    <th scope="row">SMS</th>
    <td>
    <label><input type="checkbox" disabled="disabled" id="checkSms1" name="checkSms1"/></label>
    </td>
</tr>
<tr>
    <td colspan="3">
    <input type="text" title="" placeholder="" class="w100p" />
    </td>
    <th scope="row">Additional Contact</th>
    <td>
    <input type="text" title="" placeholder="" class="w100p" id="additionalCont" name="additionalCont"/>
    </td>
    <th scope="row">SMS</th>
    <td>
    <label><input type="checkbox" disabled="disabled" id="checkSms2" name="checkSms2"/></label>
    </td>
</tr>
<tr>
    <td colspan="3">
    <input type="text" title="" placeholder="" class="w100p" />
    </td>
    <th scope="row"> Allow Commission</th>
    <td colspan="3">
    <label><input type="checkbox" id="checkComm" name="checkComm"/></label>
    </td>
</tr>
<tr>
    <th scope="row">Remark</th>
    <td colspan="7">
    <textarea cols="20" rows="5" placeholder="" id="remark"  name="remark"></textarea>
    </td>
</tr>
</tbody>
</table><!-- table end -->


<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#" onClick="fn_ASSave()">Save</a></p></li>
    <li><p class="btn_blue2 big"><a href="#">Clear</a></p></li>
</ul>

</section><!-- search_result end -->

</section><!-- content end -->
</section><!-- pop_body end -->
</div><!-- popup_wrap end -->