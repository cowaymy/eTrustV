<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<section class="pop_body"><!-- pop_body start -->
    <table class="type1"><!-- table start -->
    <caption>table</caption>
    <colgroup>
        <col style="width:100px" />
        <col style="width:*" />
        <col style="width:100px" />
        <col style="width:*" />
    </colgroup>
    <tbody>
    <tr>
        <th scope="row">Status</th>
        <td><span>${detailaddr.name}</span></td>
        <th scope="row">Create By</th>
        <td><span><c:if test="${not empty detailaddr.crtdt}">(${detailaddr.crtdt})</c:if></span></td>
    </tr>
    <tr>
        <th scope="row"></th>
        <td></td>
        <th scope="row">Update by</th>
        <td>${detailaddr.username1}(${detailaddr.upddt})</td>
    </tr>
    <tr>
        <th scope="row" rowspan="3">Address</th>
        <td colspan="3"><span>${detailaddr.add1}</span></td>
    </tr>
    <tr>
        <td colspan="3"><span>${detailaddr.add2}</span></td>
    </tr>
    <tr>
        <td colspan="3"><span>${detailaddr.add3}</span></td>
    </tr>
    <tr>
        <th scope="row">Postcode</th>
        <td>${detailaddr.postcode}</td>
        <th scope="row">Area</th>
        <td>${detailaddr.areaname }</td>
    </tr>
    <tr>
        <th scope="row">State</th>
        <td>${detailaddr.statename}</td>
        <th scope="row">Country</th>
        <td>${detailaddr.cntyname}</td>
    </tr>
    <tr>
        <th scope="row">Remark</th>
        <td colspan="3">${detailaddr.rem}</td>
    </tr>
    </tbody>
    </table><!-- table end -->
</section><!-- pop_body end -->
