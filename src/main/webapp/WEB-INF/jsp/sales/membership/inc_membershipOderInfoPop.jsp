<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<article class="tap_area"><!-- tap_area start -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:100px" />
    <col style="width:*" />
    <col style="width:100px" />
    <col style="width:*" /> 
    <col style="width:100px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sales.OrderNo" /></th>
    <td><span>${orderInfoTab.ordNo}</span></td>
    <th scope="row"><spring:message code="sales.ordDt" /></th>
    <td><span>${orderInfoTab.ordDt}</span></td>
    <th scope="row"><spring:message code="sales.ordStus" /></th>
    <td><span>${orderInfoTab.ordStusName}</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sales.ProductCategory" /></th>
    <td colspan="3"><span>${orderInfoTab.codeName}</span></td>
    <th scope="row"><spring:message code="sal.text.appType" /></th>
    <td><span>${orderInfoTab.appTypeCode}</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.productCode" /></th>
    <td><span id="inc_stockCode">${orderInfoTab.stockCode}</span></td>
    <th scope="row"><spring:message code="sal.text.productName" /></th>
    <td colspan="3"  id="inc_stockDesc" ><span>${orderInfoTab.stockDesc}</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.customerId" /></th>
    <td><span>${orderInfoTab.custId}</span></td>
    <th scope="row"><spring:message code="sales.NRIC" />/<spring:message code="sales.CompanyNo" /></th>
    <td colspan="3"><span>${orderInfoTab.custNric}</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sales.cusName" /></th>
    <td colspan="5"><span>${orderInfoTab.custName}</span></td>
</tr>


<tr id="last_div" >
    <th scope="row"><spring:message code="sales.lastMem" /></th>
    <td colspan="3"><span id='last_membership_text'>&nbsp;</span></td> 
    <th scope="row"><spring:message code="sales.ExpireDate" /></th>
    <td><span id='expire_date_text'></span></td>
</tr>

<tr>
    <th scope="row"><spring:message code="sal.text.insAddr" /></th>
    <td colspan="5"><span id="ins_full_address">${contactInfoTab.instAddr1}&nbsp;${contactInfoTab.instAddr2}&nbsp; ${contactInfoTab.instAddr3}&nbsp;
                            ${contactInfoTab.instPostCode}&nbsp;${contactInfoTab.instArea}&nbsp;${contactInfoTab.instState}&nbsp;${contactInfoTab.instCnty}&nbsp;
     </span></td>
</tr>
</tbody>
</table><!-- table end -->


</article><!-- tap_area end -->