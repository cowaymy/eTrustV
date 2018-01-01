<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->
<header class="pop_header"><!-- pop_header start -->
<h1>CUSTOMER ADDRESS</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->
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
        <td><span>${detailaddr.userName}
            <c:if test="${not empty detailaddr.crtDt}">
                <c:if test="${detailaddr.crtDt ne '01-01-1900' }">
                    (${detailaddr.crtDt})
                </c:if>
            </c:if>
            </span>
        </td>
    </tr>
    <tr>
        <th scope="row"></th>
        <td></td>
        <th scope="row">Update by</th>
        <td>${detailaddr.userName1}
            <c:if test="${not empty detailaddr.updDt}">
                <c:if test="${detailaddr.updDt ne '01-01-1900'}">
                    (${detailaddr.updDt})
                </c:if>
            </c:if>
        </td>
    </tr>
    <tr>
        <th scope="row">Address</th>
        <td colspan="3"><span>${detailaddr.add3}</span></td>
    </tr>
    <tr>
        <th scope="row">Area</th>
        <td colspan="3"><span>${detailaddr.area}</span></td>
    </tr>
    <tr>
        <th scope="row">City</th>
        <td>${detailaddr.city }</td>
        <th scope="row">Postcode</th>
        <td>${detailaddr.postcode}</td>
    </tr>
    <tr>
        <th scope="row">State</th>
        <td>${detailaddr.state}</td>
        <th scope="row">Country</th>
        <td>${detailaddr.country}</td>
    </tr>
    <tr>
        <th scope="row">Remark</th>
        <td colspan="3">${detailaddr.rem}</td>
    </tr>
    </tbody>
    </table><!-- table end -->
</section><!-- pop_body end -->
</div>