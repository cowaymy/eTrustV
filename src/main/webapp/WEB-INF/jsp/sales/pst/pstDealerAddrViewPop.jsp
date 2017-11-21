<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javascript">

</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>DEALER ADDRESS</h1>
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
    <td colspan="3">
    <span>${addrView.stusCode}</span>
    </td>
</tr>
<tr>
    <th scope="row">Create By</th>
    <td>${addrView.crtUserName}</td>
    <th scope="row">Update By</th>
    <td>${addrView.updUserName}</td>
</tr>
<tr>
    <th scope="row">Address Detail</th>
    <td colspan="3"><span>${addrView.addrDtl}</span></td>
</tr>
<tr>
    <th scope="row">Street</th>
    <td colspan="3"><span>${addrView.street}</span></td>
</tr>
<tr>
    <th scope="row">Area (4th)</th>
    <td colspan="3">${addrView.area}</td>
</tr>
<tr>
    <th scope="row">City (2nd)</th>
    <td>${addrView.city}</td>
    <th scope="row">Postcode (3rd)</th>
    <td>${addrView.postcode}</td>
</tr>
<tr>
    <th scope="row">State (1st)</th>
    <td>${addrView.state}
    <th scope="row">Country</th>
    <td>${addrView.country}</td>
</tr>
<tr>
    <th scope="row">Remark</th>
    <td colspan="3"><span>${addrView.rem}</span></td>
</tr>
</tbody>
</table><!-- table end -->
</section><!-- pop_body end -->

</div><!-- popup_wrap end -->