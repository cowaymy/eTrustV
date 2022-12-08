<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<article class="tap_area"><!-- tap_area start -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:140px" />
    <col style="width:*" />
    <col style="width:160px" />
    <col style="width:*" />
    <col style="width:140px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sal.text.customerId" /></th>
    <td><span>${orderDetail.basicInfo.custId}
    <c:if test="${not empty orderDetail.basicInfo.crtDur}">
        (${orderDetail.basicInfo.crtDur} month)
    </c:if>
    </span></td>
    <th scope="row"><spring:message code="sal.text.custName" /></th>
    <td><span>${orderDetail.basicInfo.custName}</span></td>
    <c:if test="${not empty orderDetail.basicInfo.memInfo}">
    <th scope="row">Organization Type</th>
    <td><span>${ownPurchaseInfo.code}</span></td>
    <th scope="row">Organization Status</th>
    <td><span>${ownPurchaseInfo.memStus}</span></td>
    </c:if>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.custType" /></th>
    <td><span>${orderDetail.basicInfo.custType}</span></td>
    <th scope="row"><spring:message code="sal.text.nricCompanyNo" /></th>
    <td><span>${orderDetail.basicInfo.custNric} (${orderDetail.basicInfo.custAge})</span></td>
    <th scope="row"><spring:message code="sal.text.jomPayRef1" /></th>
    <td><span>${orderDetail.basicInfo.jomPayRef}</span></td>
    <c:if test="${not empty orderDetail.basicInfo.memInfo}">
    <td></td>
    <td></td>
    </c:if>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.nationality" /></th>
    <td><span>${orderDetail.basicInfo.custNation}</span></td>
    <th scope="row"><spring:message code="sal.text.gender" /></th>
    <td><span>${orderDetail.basicInfo.custGender}</span></td>
    <th scope="row"><spring:message code="sal.text.race" /></th>
    <td><span>${orderDetail.basicInfo.custRace}</span></td>
    <c:if test="${not empty orderDetail.basicInfo.memInfo}">
    <td></td>
    <td></td>
    </c:if>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.vaNumber" /></th>
    <td><span>${orderDetail.basicInfo.custVaNo}</span></td>
    <th scope="row"><spring:message code="sal.text.passportExpire" /></th>
    <td><span>${orderDetail.basicInfo.custPassportExpr}</span></td>
    <th scope="row"><spring:message code="sal.text.visaExpire" /></th>
    <td><span>${orderDetail.basicInfo.custVisaExpr}</span></td>
    <c:if test="${not empty orderDetail.basicInfo.memInfo}">
    <td></td>
    <td></td>
    </c:if>
</tr>
<c:if test="${not empty orderDetail.basicInfo.memInfo}">
<tr>
    <th scope="row">Is Organization</th>
    <td><span>${ownPurchaseInfo.isOrg}</span></td>
    <th scope="row"><spring:message code="sal.text.memtype" /></th>
    <td><span>${ownPurchaseInfo.code}</span></td>
    <th scope="row"><spring:message code="sal.text.memberCode" /></th>
    <td><span>${ownPurchaseInfo.memCode}</span></td>
    <c:if test="${not empty orderDetail.basicInfo.memInfo}">
    <td></td>
    <td></td>
    </c:if>
</tr>
<tr>
    <th scope="row">Joined Date</th>
    <td><span>${ownPurchaseInfo.joinDt}</span></td>
    <th scope="row">Joined Period</th>
    <td>
    <c:if test="${not empty joinYear}">
    <span>${joinYear} year</span>
    <span>and</span>
    </c:if>
    <span>${joinMonth} months</span>
    </td>
    <th scope="row">Member Status</th>
    <td><span>${ownPurchaseInfo.memStus}</span></td>
    <c:if test="${not empty orderDetail.basicInfo.memInfo}">
    <td></td>
    <td></td>
    </c:if>
</tr>
<tr>
    <th scope="row">SHI</th>
    <td><span>${ownPurchaseInfo.shi} %</span></td>
    <th scope="row"><spring:message code="commissiom.text.excel.rcRate" /></th>
    <td><span>${ownPurchaseInfo.rcRate}</span></td>
<c:if test="${not empty orderDetail.basicInfo.memInfo}">
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    </c:if></tr>
</c:if>
</tbody>
</table><!-- table end -->
</article><!-- tap_area end -->