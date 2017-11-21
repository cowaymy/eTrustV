<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javascript">

</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>DEALER CONTACT</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:160px" />
    <col style="width:*" />
    <col style="width:160px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Status</th>
    <td colspan="3"><span>${cntView.stusCode }</span></td>
</tr>
<tr>
    <th scope="row">Initial</th>
    <td><span>${cntView.dealerInitialCode }</span></td>
    <th scope="row">Create By</th>
    <td><span>${cntView.dealerInitialCode }</span></td>
</tr>
<tr>
    <th scope="row">Name</th>
    <td><span>${cntView.cntName }</span></td>
    <th scope="row">Update By</th>
    <td><span>${cntView.dealerInitialCode }</span></td>
</tr>
<tr>
    <th scope="row">NRIC</th>
    <td><span>${cntView.nric }</span></td>
    <th scope="row">Gender</th>
    <td><span>${cntView.gender }</span></td>
</tr>
<tr>
    <th scope="row">Race</th>
    <td><span>${cntView.raceName }</span></td>
    <th scope="row">Tel (Mobile 1)</th>
    <td><span>${cntView.telM1 }</span></td>
</tr>
<tr>
    <th scope="row">Tel (Mobile 2)</th>
    <td><span>${cntView.telM2 }</span></td>
    <th scope="row">Tel (Office)</th>
    <td><span>${cntView.telO }</span></td>
</tr>
<tr>
    <th scope="row">Tel (Residence)</th>
    <td><span>${cntView.telR }</span></td>
    <th scope="row">Tel (Fax)</th>
    <td><span>${cntView.telf }</span></td>
</tr>
</tbody>
</table><!-- table end -->
</section><!-- pop_body end -->

</div><!-- popup_wrap end -->