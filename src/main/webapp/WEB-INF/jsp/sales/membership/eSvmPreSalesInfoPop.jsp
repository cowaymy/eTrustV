<script type="text/javaScript" language="javascript">

    var oriNric = "${preSalesInfo.custNric}";

    var oriAddr = "${preSalesInfo.instlAddr}";
    var oriMaskAddr1 = "${preSalesInfo.maskAddr1}";
    var oriMaskAddr2 = "${preSalesInfo.maskAddr2}";

    $(document).ready(function(){

     // Masking pen (display last 4)
     var maskedNric = oriNric.substr(-4).padStart(oriNric.length, '*');
     $("#spanNric").html(maskedNric);
     // Appear NRIC on hover over field
     $("#spanNric").hover(function() {
         $("#spanNric").html(oriNric);
     }).mouseout(function() {
         $("#spanNric").html(maskedNric);
     });
     $("#imgHover").hover(function() {
         $("#spanNric").html(oriNric);
     }).mouseout(function() {
         $("#spanNric").html(maskedNric);
     });

     var maskedAddr = oriMaskAddr1 + " ********** " + oriMaskAddr2;
     $("#presales_instlAdd").html(maskedAddr);
     // Appear NRIC on hover over field
     $("#presales_instlAdd").hover(function() {
         $("#presales_instlAdd").html(oriAddr);
     }).mouseout(function() {
         $("#presales_instlAdd").html(maskedAddr);
     });
     $("#imgHoverAddr").hover(function() {
         $("#presales_instlAdd").html(oriAddr);
     }).mouseout(function() {
         $("#presales_instlAdd").html(maskedAddr);
     });
    });

</script>

<article class="tap_area"><!-- tap_area start -->
<aside class="title_line"><!-- title_line start -->
<h3>Pre Sales Info</h3>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:160px" />
    <col style="width:*" />
    <col style="width:170px" />
    <col style="width:*" />

</colgroup>
<tbody>
<tr>
    <th scope="row" colspan='1'>Customer Name</th>
    <td><input id="presales_custName" name="presales_custName" type="text" value="${preSalesInfo.custName}" title="" placeholder="" class="w100p readonly" readonly /></td>
    <th scope="row">Type of Package</th>
    <td><input id="presales_typeOfPackage" name="presales_typeOfPackage" type="text" value="${preSalesInfo.packageType}" title="" placeholder="" class="w100p readonly" readonly /></td>
</tr>
<tr>
    <th scope="row">NRIC / Company No</th>
    <td><a href="#" class="search_btn" id="imgHover"><img style="height:70%" src="${pageContext.request.contextPath}/resources/images/common/nricEye2.png" /></a>
        <span id="spanNric"></span>
    </td>
    <!-- <td><input id="presales_nricCompNo" name="presales_nricCompNo" type="text" value="${preSalesInfo.custNric}" title="" placeholder="" class="w100p readonly" readonly /></td>  -->
    <th scope="row">Duration</th>
    <td><input id="presales_duration" name="presales_duration" type="text" value="${preSalesInfo.duration} month(s)" title="" placeholder="" class="w100p readonly" readonly /></td>
</tr>
<tr>
    <th scope="row">Order Type</th>
    <td><input id="presales_orderType" name="presales_orderType" type="text" value="${preSalesInfo.orderType}" title="" placeholder="" class="w100p readonly" readonly /></td>
    <th scope="row">Subscription</th>
    <td><input id="presales_subscription" name="presales_subscription" type="text" value="${preSalesInfo.subsription}" title="" placeholder="" class="w100p readonly" readonly /></td>
</tr>
<tr>
    <th scope="row">Order Outstanding</th>
    <td><input id="presales_orderOutstd" name="presales_orderOutstd" type="text" value="RM ${preSalesInfo.ordOtstnd}" title="" placeholder="" class="w100p readonly" readonly /></td>
    <th scope="row">Package Amount</th>
    <td><input id="presales_packAmt" name="presales_packAmt" type="text" value="RM ${preSalesInfo.packageAmt}" title="" placeholder="" class="w100p readonly" readonly /></td>
</tr>
<tr>
    <th scope="row">AS Outstanding</th>
    <td><input id=presales_asOutstd name="presales_asOutstd" type="text" value="RM ${preSalesInfo.asOtstnd}" title="" placeholder="" class="w100p readonly" readonly /></td>
    <th scope="row">Package Promotion</th>
    <td><input id=presales_packPromo name="presales_packPromo" type="text" value="${preSalesInfo.packagePromo}" title="" placeholder="" class="w100p readonly" readonly /></td>
</tr>
<tr>
    <th scope="row">Stock Name</th>
    <td><input id=presales_stockName name="presales_stockName" type="text" value="${preSalesInfo.stockName}" title="" placeholder="" class="w100p readonly" readonly /></td>
    <th scope="row">Filter Amount</th>
    <td><input id='presales_filterAmt' name="'presales_filterAmt'" type="text" value="RM ${preSalesInfo.filterAmt}" title="" placeholder="" class="w100p readonly" readonly /></td>
</tr>
<tr>
    <th scope="row">Term</th>
    <td><input id=presales_term name="presales_term" type="text" value="${preSalesInfo.terms}" title="" placeholder="" class="w100p readonly" readonly /></td>
    <th scope="row">Filter Promotion</th>
    <td><input id=presales_filterPromo name="presales_filterPromo" type="text" value="${preSalesInfo.filterPromoDesc}" title="" placeholder="" class="w100p readonly" readonly /></td>
</tr>
<tr>
    <th scope="row">Sales Person Code</th>
    <td><input id=presales_salesPersonCode name="presales_salesPersonCode" type="text" value="${preSalesInfo.salespersonCode}" title="" placeholder="" class="w100p readonly" readonly /></td>
    <th scope="row">HS Frequency</th>
    <td><input id=presales_frequency name="presales_frequency" type="text" value="${preSalesInfo.hsFreq} months(s)" title="" placeholder="" class="w100p readonly" readonly /></td>
</tr>
<tr>
    <th scope="row">Sales Person Name</th>
    <td colspan=3><input id=presales_salesPersonName name="presales_salesPersonName" type="text" value="${preSalesInfo.salespersonName}" title="" placeholder="" class="w100p readonly" readonly /></td>
</tr>
<tr>
    <th scope="row">Installation Address</th>
    <td colspan=3><a href="#" class="search_btn" id="imgHoverAddr"><img style="height:70%" src="${pageContext.request.contextPath}/resources/images/common/nricEye2.png" /></a>
        <span id="presales_instlAdd"></span>
    </td>
</tr>
</tbody>
</table><!-- table end -->
</article><!-- tap_area end -->