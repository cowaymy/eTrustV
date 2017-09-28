<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>


<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Customer Address Add/Edit</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<section class="tap_wrap"><!-- tap_wrap start -->
<ul class="tap_type1">
    <li><a href="#" class="on">Basic Info</a></li>
    <li><a href="#">Main Address</a></li>
    <li><a href="#">Main Contact</a></li>
</ul>

<article class="tap_area"><!-- tap_area start -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:160px" />
    <col style="width:*" />
    <col style="width:180px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Customer ID</th>
    <td><span>text</span></td>
    <th scope="row">Customer Type</th>
    <td><span>text</span></td>
    <th scope="row">Create At</th>
    <td><span>text</span></td>
</tr>
<tr>
    <th scope="row">Customer Name</th>
    <td><span>text</span></td>
    <th scope="row">Create By</th>
    <td colspan="3"><span>text</span></td>
</tr>
<tr>
    <th scope="row">NRIC/Company Number</th>
    <td><span>text</span></td>
    <th scope="row">GST Registration No</th>
    <td><span>text</span></td>
    <th scope="row">Update By</th>
    <td><span>text</span></td>
</tr>
<tr>
    <th scope="row">Email</th>
    <td><span>text</span></td>
    <th scope="row">Nationality</th>
    <td><span>text</span></td>
    <th scope="row">Update At</th>
    <td><span>text</span></td>
</tr>
<tr>
    <th scope="row">Gender</th>
    <td><span>text</span></td>
    <th scope="row">DOB</th>
    <td><span>text</span></td>
    <th scope="row">Race</th>
    <td><span>text</span></td>
</tr>
<tr>
    <th scope="row">Passport Expire</th>
    <td><span>text</span></td>
    <th scope="row">Visa Expire</th>
    <td><span>text</span></td>
    <th scope="row">VA Number</th>
    <td><span>text</span></td>
</tr>
<tr>
    <th scope="row">Remark</th>
    <td colspan="5"><span>text</span></td>
</tr>
</tbody>
</table><!-- table end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:130px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Full Address</th>
    <td><span>text</span></td>
</tr>
<tr>
    <th scope="row">Remark</th>
    <td><span>text</span></td>
</tr>
</tbody>
</table><!-- table end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Name</th>
    <td><span>text</span></td>
    <th scope="row">Initial</th>
    <td><span>text</span></td>
    <th scope="row">Gender</th>
    <td><span>text</span></td>
</tr>
<tr>
    <th scope="row">NRIC</th>
    <td><span>text</span></td>
    <th scope="row">DOB</th>
    <td><span>text</span></td>
    <th scope="row">Race</th>
    <td><span>text</span></td>
</tr>
<tr>
    <th scope="row">Email</th>
    <td><span>text</span></td>
    <th scope="row">Department</th>
    <td><span>text</span></td>
    <th scope="row">Post</th>
    <td><span>text</span></td>
</tr>
<tr>
    <th scope="row">Tel (Mobile)</th>
    <td><span>text</span></td>
    <th scope="row">Tel (Residence)</th>
    <td><span>text</span></td>
    <th scope="row">Tel (Office)</th>
    <td><span>text</span></td>
</tr>
<tr>
    <th scope="row">Tel (Fax)</th>
    <td><span>text</span></td>
    <th scope="row"></th>
    <td><span></span></td>
    <th scope="row"></th>
    <td><span></span></td>
</tr>
</tbody>
</table><!-- table end -->

</article><!-- tap_area end -->

</section><!-- tap_wrap end -->

<aside class="title_line"><!-- title_line start -->
<h2>Customer Basic Information</h2>
</aside><!-- title_line end -->

<ul class="right_btns">
    <li><p><span class="red_text">* Compulsory Field</span> <span class="brown_text"># Compulsory Field (For Individual Type)</span></p></li>
</ul>

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
    <col style="width:140px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Customer Type</th>
    <td>
    <select class="w100p">
        <option value="">11</option>
        <option value="">22</option>
        <option value="">33</option>
    </select>
    </td>
    <th scope="row">Company Type</th>
    <td>
    <select class="w100p">
        <option value="">11</option>
        <option value="">22</option>
        <option value="">33</option>
    </select>
    </td>
</tr>
<tr>
    <th scope="row">GST Registration No</th>
    <td colspan="3"><input type="text" title="" placeholder="" class="w100p" /></td>
</tr>
</tbody>
</table><!-- table end -->

<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#">Update</a></p></li>
</ul>

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->