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
    <td colspan="3"><span>${orderDetail.basicInfo.custName}</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.custType" /></th>
    <td><span>${orderDetail.basicInfo.custType}</span></td>
    <th scope="row"><spring:message code="sal.text.nricCompanyNo" /></th>
    <td><span>${orderDetail.basicInfo.custNric}</span></td>
    <th scope="row"><spring:message code="sal.text.jomPayRef1" /></th>
    <td><span>${orderDetail.basicInfo.jomPayRef}</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.nationality" /></th>
    <td><span>${orderDetail.basicInfo.custNation}</span></td>
    <th scope="row"><spring:message code="sal.text.gender" /></th>
    <td><span>${orderDetail.basicInfo.custGender}</span></td>
    <th scope="row"><spring:message code="sal.text.race" /></th>
    <td><span>${orderDetail.basicInfo.custRace}</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.vaNumber" /></th>
    <td><span>${orderDetail.basicInfo.custVaNo}</span></td>
    <th scope="row"><spring:message code="sal.text.passportExpire" /></th>
    <td><span>${orderDetail.basicInfo.custPassportExpr}</span></td>
    <th scope="row"><spring:message code="sal.text.visaExpire" /></th>
    <td><span>${orderDetail.basicInfo.custVisaExpr}</span></td>
</tr>
</tbody>
</table><!-- table end -->
</article><!-- tap_area end -->