<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>


<script type="text/javascript">

$.fn.clearForm = function() {
    return this.each(function() {
        var type = this.type, tag = this.tagName.toLowerCase();
        if (tag === 'form'){
            return $(':input',this).clearForm();
        }
        if (type === 'text' || type === 'password' || type === 'hidden' || tag === 'textarea'){
            this.value = '';
        }else if (type === 'checkbox' || type === 'radio'){
            this.checked = false;
        }else if (tag === 'select'){
            this.selectedIndex = 0;
        }
    });
};


CommonCombo.make('branch', '/sales/ccp/getBranchCodeList', '' , '');
CommonCombo.make('dscBranch', '/sales/ccp/selectDscCodeList', '', '');


</script>


<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>CCP Listing</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<aside class="title_line"><!-- title_line start -->

</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id="form">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Order No</th>
    <td>
    <div class="date_set"><!-- date_set start -->
    <p><input type="text" title="" placeholder="Order No (From)" class="w100p" /></p>
    <span>To</span>
    <p><input type="text" title="" placeholder="Order No (To)" class="w100p" /></p>
    </div><!-- date_set end -->
    </td>
</tr>
<tr>
    <th scope="row">Order Date</th>
    <td>
    <div class="date_set"><!-- date_set start -->
    <p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
    <span>To</span>
    <p><input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
    </div><!-- date_set end -->
    </td>
</tr>
<tr>
    <th scope="row">Region</th>
    <td>
    <select class="">
        <option value="">11</option>
        <option value="">22</option>
        <option value="">33</option>
    </select>
    </td>
</tr>
<tr>
    <th scope="row">Branch</th>
    <td>
    <select class="" id="branch" name="branch"></select>
    </td>
</tr>
<tr>
    <th scope="row">Group Code</th>
    <td><input type="text" title="" placeholder="Group Code" class="" /></td>
</tr>
<tr>
    <th scope="row">CCP Status</th>
    <td>
    <select class="">
        <option value="" hidden>CCP Progress</option>
        <option value="1">ACT - Active (Including Pending)</option>
        <option value="5">APV - Approved</option>
        <option value="6">RJT - Rejected</option>
    </select>
    </td>
</tr>
<tr>
    <th scope="row">CC Point</th>
    <td>
    <div class="date_set"><!-- date_set start -->
    <p><input type="text" title="" placeholder="CCP Ponit (From)" class="w100p" /></p>
    <span>To</span>
    <p><input type="text" title="" placeholder="CCP Ponit (To)" class="w100p" /></p>
    </div><!-- date_set end -->
    </td>
</tr>
<tr>
    <th scope="row">On Hold Case</th>
    <td>
    <select class="">
        <option value="" hidden>CCP On-hold Case</option>
        <option value="Yes">Yes</option>
        <option value="No">No</option>
    </select>
    </td>
</tr>
<tr>
    <th scope="row">Reject Status</th>
    <td>
    <select class="">
        <option value="" hidden>Reject Status</option>
        <option value="18">CANF - Cancel Fund Transfer</option>
        <option value="10">CAN - Cancelled</option>
        <option value="13">CA1Y - Convert To Advance 1 Year</option>
        <option value="17">CANR - Cancel Refund</option>
        <option value="Yes">CA2Y - Convert To Advance 2 Years</option>
    </select>
    </td>
</tr>
<tr>
    <th scope="row">CCP Feedback Code</th>
    <td>
    <select class="">
        <option value="">11</option>
        <option value="">22</option>
        <option value="">33</option>
    </select>
    </td>
</tr>
<tr>
    <th scope="row">Last Updator</th>
    <td><input type="text" title="" placeholder="Last Updator (Username)" class="" /></td>
</tr>
<tr>
    <th scope="row">Customer Type</th>
    <td>
    <select class="">
        <option value="" hidden>Customer Type</option>
        <option value="965">Company</option>
        <option value="964">Individual</option>
    </select>
    </td>
</tr>
<tr>
    <th scope="row">DSC Branch</th>
    <td>
    <select class="" id="dscBranch" name="dscBranch"></select>
    </td>
</tr>
<tr>
    <th scope="row">Product</th>
    <td>
    <select class="">
        <option value="">11</option>
        <option value="">22</option>
        <option value="">33</option>
    </select>
    </td>
</tr>
<tr>
    <th scope="row">Key in Hour</th>
    <td>
    <div class="time_picker"><!-- time_picker start -->
    <input type="text" title="" placeholder="Key in Hour(hh:mm:tt)" class="time_date" />
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
    <th scope="row">Sorting</th>
    <td>
    <select class="">
        <option value="" hidden>Sorting By</option>
        <option value="1">Sorting By Region</option>
        <option value="2">Sorting By Branch</option>
        <option value="3">Sorting By Order Date</option>
        <option value="4">Sorting By Order Number</option>
        <option value="5">Sorting By CCP Progress Status</option>
        <option value="6">Sorting By Username</option>
        <option value="7">Sorting By Customer Name</option>
    </select>
    </td>
</tr>
</tbody>
</table><!-- table end -->

<ul class="right_btns">
    <li><p class="btn_blue"><a href="#">Generate PDF</a></p></li>
    <li><p class="btn_blue"><a href="#">Generate Excel</a></p></li>
    <li><p class="btn_blue"><a href="#" onclick="javascript:$('#form').clearForm();"><span class="clear"></span>Clear</a></p></li>
</ul>


</form>

</section><!-- content end -->
     
</section><!-- container end -->

</div><!-- popup_wrap end -->