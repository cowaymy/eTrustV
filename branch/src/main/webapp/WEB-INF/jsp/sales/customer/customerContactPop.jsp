<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->
<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="sal.page.title.custContact" /></h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#"><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->
<section class="pop_body"><!-- pop_body start -->

    <table class="type1"><!-- table start -->
    <caption>table</caption>
    <colgroup>
        <col style="width:145px" />
        <col style="width:*" />
        <col style="width:115px" />
        <col style="width:*" />
    </colgroup>
    <tbody>
    <tr>
        <th scope="row"><spring:message code="sal.text.status" /></th>
        <td><span>${detailcontact.name}</span></td>
        <th scope="row"><spring:message code="sal.text.createBy" /></th>
        <td><span>${detailcontact.userName}
            <c:if test="${not empty detailcontact.crtDt}">
                <c:if test="${detailcontact.crtDt ne '01-01-1900'}">
                    (${detailcontact.crtDt})
                </c:if>
            </c:if>
            </span>
         </td>
    </tr>
    <tr>
        <th scope="row"><spring:message code="sal.text.initial" /></th>
        <td><c:if test="${not empty detailcontact.code}">${detailcontact.code}</c:if></td>
        <th scope="row"><spring:message code="sal.text.updateBy" /></th>
        <td>${detailcontact.userName1}
            <c:if test="${not empty detailcontact.updDt}">
                <c:if test="${detailcontact.updDt ne '01-01-1900'}">
                    (${detailcontact.updDt})
                </c:if>
            </c:if>
       </td>
    </tr>
    <tr>
        <th scope="row"><spring:message code="sal.text.name" /></th>
        <td>${detailcontact.name1}</td>
        <th scope="row"><spring:message code="sal.text.nric" /></th>
        <td>${detailcontact.nric}</td>
    </tr>
    <tr>
        <th scope="row"><spring:message code="sal.text.dob" /></th>
        <td><c:if test="${detailcontact.dob ne '01-01-1900'}">${detailcontact.dob}</c:if></td>
        <th scope="row"><spring:message code="sal.text.gender" /></th>
        <td>
            <c:if test="${detailcontact.gender eq 'F'}">
                Female
            </c:if>
            <c:if test="${detailcontact.gender eq 'M'}">
                Male
            </c:if>
        </td>
    </tr>
    <tr>
        <th scope="row"><spring:message code="sal.text.race" /></th>
        <td>${detailcontact.codeName}</td>
        <th scope="row"><spring:message code="sal.text.email" /></th>
        <td>${detailcontact.email}</td>
    </tr>
    <tr>
        <th scope="row"><spring:message code="sal.text.telM" /></th>
        <td>${detailcontact.telM1}</td>
        <th scope="row"><spring:message code="sal.text.telO" /></th>
        <td>${detailcontact.telO }</td>
    </tr>
    <tr>
        <th scope="row"><spring:message code="sal.text.telR" /></th>
        <td>${detailcontact.telR }</td>
        <th scope="row"><spring:message code="sal.text.telF" /></th>
        <td>${detailcontact.telf}</td>
    </tr>
    <tr>
        <th scope="row"><spring:message code="sal.text.dept" /></th>
        <td>${detailcontact.dept}</td>
        <th scope="row"><spring:message code="sal.text.post" /></th>
        <td>${detailcontact.pos}</td>
    </tr>
    </tbody>
    </table><!-- table end -->

</section><!-- pop_body end -->
</div>