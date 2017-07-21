<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="utf-8"/>
<meta content="width=1280px,user-scalable=yes,target-densitydpi=device-dpi" name="viewport"/>
<title>eTrust system</title>
<link rel="stylesheet" type="text/css" href="../css/master.css" />
<link rel="stylesheet" type="text/css" href="../css/common.css" />
<link rel="stylesheet" type="text/css" href="../css/multiple-select.css" />
<script type="text/javascript" src="../js/jquery-2.2.4.min.js"></script>
<script type="text/javascript" src="../js/jquery-ui.min.js"></script>
<script type="text/javascript" src="../js/jquery.ui.core.min.js"></script>
<script type="text/javascript" src="../js/jquery.ui.datepicker.min.js"></script>
<script type="text/javascript" src="../js/multiple-select.js"></script>
<script type="text/javascript" src="../js/jquery.mtz.monthpicker.js"></script>
<script type="text/javascript" src="../js/common_pub.js"></script>
</head>
<body>

<div id="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Member List - Add New Member</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->
<!-- 
<table class="type1">table start
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Member Type</th>
    <td>
    <select class="w100p">
        <option value="">11</option>
        <option value="">22</option>
        <option value="">33</option>
    </select>
    </td>
</tr>
</tbody>
</table>table end
 -->
<section class="tap_wrap"><!-- tap_wrap start -->
<ul class="tap_type1 num4">
    <li><a href="#" class="on">Basic Info</a></li>
    <li><a href="#">Spouse Info</a></li>
    <li><a href="#">Organization Info</a></li>
    <li><a href="#">Document Submission</a></li>
    <li><a href="#">Member Payment History</a></li>
    <li><a href="#">Promote/Demote History</a></li>
    <li><a href="#">Pa Renewal History</a></li>
</ul>

<article class="tap_area"><!-- tap_area start -->

<aside class="title_line"><!-- title_line start -->
<h2>Basic Information</h2>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:160px" />
    <col style="width:*" />
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:150px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Member Name<span class="must">*</span></th>
    <td colspan="3">
    <input type="text" title="" placeholder="Member Name" class="w100p" />
    </td>
    <th scope="row">Joined Date<span class="must">*</span></th>
    <td>
    <input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" />
    </td>
</tr>
<tr>
    <th scope="row">Gender<span class="must">*</span></th>
    <td>
    <label><input type="radio" name="gender" /><span>Male</span></label>
    <label><input type="radio" name="gender" /><span>Female</span></label>
    </td>
    <th scope="row">Date of Birth<span class="must">*</span></th>
    <td>
    <input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" />
    </td>
    <th scope="row">Race<span class="must">*</span></th>
    <td>
    <select class="w100p">
        <option value="">11</option>
        <option value="">22</option>
        <option value="">33</option>
    </select>
    </td>
</tr>
<tr>
    <th scope="row">Nationality<span class="must">*</span></th>
    <td>
    <select class="w100p">
        <option value="">11</option>
        <option value="">22</option>
        <option value="">33</option>
    </select>
    </td>
    <th scope="row">NRIC (New)<span class="must">*</span></th>
    <td>
    <input type="text" title="" placeholder="NRIC (New)" class="w100p" />
    </td>
    <th scope="row">Marrital Status<span class="must">*</span></th>
    <td>
    <select class="w100p">
        <option value="">11</option>
        <option value="">22</option>
        <option value="">33</option>
    </select>
    </td>
</tr>
<tr>
    <th scope="row" rowspan="3">Address<span class="must">*</span></th>
    <td colspan="5">
    <input type="text" title="" placeholder="Address(1)" class="w100p" />
    </td>
</tr>
<tr>
    <td colspan="5">
    <input type="text" title="" placeholder="Address(2)" class="w100p" />
    </td>
</tr>
<tr>
    <td colspan="5">
    <input type="text" title="" placeholder="Address(3)" class="w100p" />
    </td>
</tr>
<tr>
    <th scope="row">Country<span class="must">*</span></th>
    <td>
    <select class="w100p">
        <option value="">11</option>
        <option value="">22</option>
        <option value="">33</option>
    </select>
    </td>
    <th scope="row">State<span class="must">*</span></th>
    <td>
    <select class="w100p">
        <option value="">11</option>
        <option value="">22</option>
        <option value="">33</option>
    </select>
    </td>
    <th scope="row">Area<span class="must">*</span></th>
    <td>
    <select class="w100p disabled" disabled="disabled">
        <option value="">11</option>
        <option value="">22</option>
        <option value="">33</option>
    </select>
    </td>
</tr>
<tr>
    <th scope="row">Postcode<span class="must">*</span></th>
    <td>
    <select class="w100p disabled" disabled="disabled">
        <option value="">11</option>
        <option value="">22</option>
        <option value="">33</option>
    </select>
    </td>
    <th scope="row">Email</th>
    <td colspan="3">
    <input type="text" title="" placeholder="Email" class="w100p" />
    </td>
</tr>
<tr>
    <th scope="row">Mobile No.</th>
    <td>
    <input type="text" title="" placeholder="Numberic Only" class="w100p" />
    </td>
    <th scope="row">Office No.</th>
    <td>
    <input type="text" title="" placeholder="Numberic Only" class="w100p" />
    </td>
    <th scope="row">Residence No.</th>
    <td>
    <input type="text" title="" placeholder="Numberic Only" class="w100p" />
    </td>
</tr>
<tr>
    <th scope="row">Sponsor's Code</th>
    <td>

    <div class="search_100p"><!-- search_100p start -->
    <input type="text" title="" placeholder="Sponsor's Code" class="w100p" />
    <a href="#" class="search_btn"><img src="../images/common/normal_search.gif" alt="search" /></a>
    </div><!-- search_100p end -->

    </td>
    <th scope="row">Sponsor's Name</th>
    <td>
    <input type="text" title="" placeholder="Sponsor's Name" class="w100p" />
    </td>
    <th scope="row">Sponsor's NRIC</th>
    <td>
    <input type="text" title="" placeholder="Sponsor's NRIC" class="w100p" />
    </td>
</tr>
<tr>
    <th scope="row">Department Code<span class="must">*</span></th>
    <td>
    <select class="w100p">
        <option value="">11</option>
        <option value="">22</option>
        <option value="">33</option>
    </select>
    </td>
    <th scope="row">Branch<span class="must">*</span></th>
    <td>
    <select class="w100p disabled" disabled="disabled">
        <option value="">11</option>
        <option value="">22</option>
        <option value="">33</option>
    </select>
    </td>
    <th scope="row">Transport Code<span class="must">*</span></th>
    <td>
    <select class="w100p disabled" disabled="disabled">
        <option value="">11</option>
        <option value="">22</option>
        <option value="">33</option>
    </select>
    </td>
</tr>
<tr>
    <th scope="row">e-Approval Status</th>
    <td colspan="5">
    <input type="text" title="" placeholder="e-Approval Status" class="w100p" />
    </td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h2>Bank Account Information</h2>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:180px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Issued Bank<span class="must">*</span></th>
    <td>
    <select class="w100p">
        <option value="">11</option>
        <option value="">22</option>
        <option value="">33</option>
    </select>
    </td>
    <th scope="row">Bank Account No<span class="must">*</span></th>
    <td>
    <input type="text" title="" placeholder="Bank Account No" class="w100p" />
    </td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h2>Language Proficiency</h2>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:180px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Education Level</th>
    <td>
    <select class="w100p">
        <option value="">11</option>
        <option value="">22</option>
        <option value="">33</option>
    </select>
    </td>
    <th scope="row">Language</th>
    <td>
    <select class="w100p">
        <option value="">11</option>
        <option value="">22</option>
        <option value="">33</option>
    </select>
    </td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h2>First TR Consign</h2>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">TR No.</th>
    <td>
    <input type="text" title="" placeholder="TR No." class="w100p" />
    </td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h2>Agreedment</h2>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Cody PA Expiry<span class="must">*</span></th>
    <td>
    <input type="text" title="" placeholder="DD/MM/YYYY" class="j_date" />
    </td>
</tr>
</tbody>
</table><!-- table end -->

<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#">SAVE</a></p></li>
    <li><p class="btn_blue2 big"><a href="#">CANCEL</a></p></li>
</ul>

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:120px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:180px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">MCode</th>
    <td>
    <input type="text" title="" placeholder="MCode" class="w100p" />
    </td>
    <th scope="row">Spouse Name</th>
    <td>
    <input type="text" title="" placeholder="Spouse Nam" class="w100p" />
    </td>
    <th scope="row">NRIC / Passport No.</th>
    <td>
    <input type="text" title="" placeholder="NRIC / Passport No." class="w100p" />
    </td>
</tr>
<tr>
    <th scope="row">Occupation</th>
    <td>
    <input type="text" title="" placeholder="Occupation" class="w100p" />
    </td>
    <th scope="row">Date of Birth</th>
    <td>
    <input type="text" title="" placeholder="DD/MM/YYYY" class="j_date" />
    </td>
    <th scope="row">Contact No.</th>
    <td>
    <input type="text" title="" placeholder="Contact No. (Numberic Only)" class="w100p" />
    </td>
</tr>
</tbody>
</table><!-- table end -->

<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#">SAVE</a></p></li>
    <li><p class="btn_blue2 big"><a href="#">CANCEL</a></p></li>
</ul>

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:140px" />
    <col style="width:*" />
    <col style="width:160px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Position</th>
    <td colspan="3">
    <span>Senior General Cody Manager</span>
    </td>
    <th scope="row">Member Level</th>
    <td>
    <span>0</span>
    </td>
</tr>
<tr>
    <th scope="row">Department Code</th>
    <td></td>
    <th scope="row">Group Code</th>
    <td></td>
    <th scope="row">Organization Code</th>
    <td></td>
</tr>
<tr>
    <th scope="row">Manager</th>
    <td colspan="5"></td>
</tr>
<tr>
    <th scope="row">Mobile No</th>
    <td></td>
    <th scope="row">Residence No</th>
    <td></td>
    <th scope="row">Office No</th>
    <td></td>
</tr>
<tr>
    <th scope="row">Senior Manager</th>
    <td colspan="5"></td>
</tr>
<tr>
    <th scope="row">Mobile No</th>
    <td></td>
    <th scope="row">Residence No</th>
    <td></td>
    <th scope="row">Office No</th>
    <td></td>
</tr>
</tbody>
</table><!-- table end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<article class="grid_wrap"><!-- grid_wrap start -->
그리드 영역
</article><!-- grid_wrap end -->

<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#">SAVE</a></p></li>
    <li><p class="btn_blue2 big"><a href="#">CANCEL</a></p></li>
</ul>

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<article class="grid_wrap"><!-- grid_wrap start -->
그리드 영역
</article><!-- grid_wrap end -->

<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#">SAVE</a></p></li>
    <li><p class="btn_blue2 big"><a href="#">CANCEL</a></p></li>
</ul>
</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<article class="grid_wrap"><!-- grid_wrap start -->
그리드 영역
</article><!-- grid_wrap end -->

<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#">SAVE</a></p></li>
    <li><p class="btn_blue2 big"><a href="#">CANCEL</a></p></li>
</ul>
</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<article class="grid_wrap"><!-- grid_wrap start -->
그리드 영역
</article><!-- grid_wrap end -->

<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#">SAVE</a></p></li>
    <li><p class="btn_blue2 big"><a href="#">CANCEL</a></p></li>
</ul>
</article><!-- tap_area end -->

</section><!-- tap_wrap end -->

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->
</body>
</html>