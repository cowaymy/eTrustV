<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->
<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="sal.page.title.custAddr" /></h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#"><spring:message code="sal.btn.close" /></a></p></li>
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
        <th scope="row"><spring:message code="sal.text.status" /></th>
        <td><span>${detailaddr.name}</span></td>
        <th scope="row"><spring:message code="sal.text.createBy" /></th>
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
        <th scope="row"><spring:message code="sal.text.updateBy" /></th>
        <td>${detailaddr.userName1}
            <c:if test="${not empty detailaddr.updDt}">
                <c:if test="${detailaddr.updDt ne '01-01-1900'}">
                    (${detailaddr.updDt})
                </c:if>
            </c:if>
        </td>
    </tr>
    <tr>
        <th scope="row"><spring:message code="sal.text.address" /></th>
        <td colspan="3"><span>${detailaddr.add3}</span></td>
    </tr>
    <tr>
        <th scope="row"><spring:message code="sal.text.area" /></th>
        <td colspan="3"><span>${detailaddr.area}</span></td>
    </tr>
    <tr>
        <th scope="row"><spring:message code="sal.text.city" /></th>
        <td>${detailaddr.city }</td>
        <th scope="row"><spring:message code="sal.text.postCode" /></th>
        <td>${detailaddr.postcode}</td>
    </tr>
    <tr>
        <th scope="row"><spring:message code="sal.text.state" /></th>
        <td>${detailaddr.state}</td>
        <th scope="row"><spring:message code="sal.text.country" /></th>
        <td>${detailaddr.country}</td>
    </tr>
    <tr>
        <th scope="row"><spring:message code="sal.text.remark" /></th>
        <td colspan="3">${detailaddr.rem}</td>
    </tr>
    </tbody>
    </table><!-- table end -->
</section><!-- pop_body end -->
</div>