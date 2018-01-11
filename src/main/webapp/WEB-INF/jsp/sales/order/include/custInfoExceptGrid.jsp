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
    <th scope="row">Customer ID</th>
    <td><span>${orderDetail.basicInfo.custId}
    <c:if test="${not empty orderDetail.basicInfo.crtDur}">
        (${orderDetail.basicInfo.crtDur} month)    
    </c:if>
    </span></td>
    <th scope="row">Customer Name</th>
    <td colspan="3"><span>${orderDetail.basicInfo.custName}</span></td>
</tr>
<tr>
    <th scope="row">Customer Type</th>
    <td><span>${orderDetail.basicInfo.custType}</span></td>
    <th scope="row">NRIC/Company No</th>
    <td><span>${orderDetail.basicInfo.custNric}</span></td>
    <th scope="row">JomPay Ref-1</th>
    <td><span>${orderDetail.basicInfo.jomPayRef}</span></td>
</tr>
<tr>
    <th scope="row">Nationality</th>
    <td><span>${orderDetail.basicInfo.custNation}</span></td>
    <th scope="row">Gender</th>
    <td><span>${orderDetail.basicInfo.custGender}</span></td>
    <th scope="row">Race</th>
    <td><span>${orderDetail.basicInfo.custRace}</span></td>
</tr>
<tr>
    <th scope="row">VA Number</th>
    <td><span>${orderDetail.basicInfo.custVaNo}</span></td>
    <th scope="row">Passport Exprire</th>
    <td><span>${orderDetail.basicInfo.custPassportExpr}</span></td>
    <th scope="row">Visa Exprire</th>
    <td><span>${orderDetail.basicInfo.custVisaExpr}</span></td>
</tr>
</tbody>
</table><!-- table end -->
</article><!-- tap_area end -->