<article class="tap_area">
  <table class="type1">
    <caption>table</caption>
    <colgroup>
      <col style="width: 200px" />
      <col style="width: *" />
      <col style="width: 130px" />
      <col style="width: *" />
      <col style="width: 110px" />
      <col style="width: *" />
    </colgroup>
    <tbody>
      <tr>
        <th scope="row"><spring:message
            code="service.title.OrganizationCode" /></th>
        <td colspan="5"><span>${orderInfo.orgCode}</span></td>
      </tr>
      <tr>
        <th scope="row"><spring:message code="sal.title.text.groupCode" /></th>
        <td colspan="5"><span>${orderInfo.grpCode}</span></td>
      </tr>
      <tr>
        <th scope="row"><spring:message code="sal.text.departmentCode" /></th>
        <td colspan="5"><span>${orderInfo.deptCode}</span></td>
      </tr>
      <tr>
        <th scope="row"><spring:message code="sal.text.salManCode" /></th>
        <td colspan="5"><span>${orderInfo.salesmanCode}</span></td>
      </tr>
      <tr>
        <th scope="row"><spring:message code="sal.text.salManName" /></th>
        <td colspan="5"><span>${orderInfo.salesmanName}</span></td>
      </tr>
      <tr>
        <th scope="row"><spring:message
            code="sal.title.text.salesmanNric" /></th>
        <td colspan="5"><span>${orderInfo.salesmanNric}</span></td>
      </tr>
      <tr>
        <th scope="row"><spring:message code="service.title.MobileNo" /></th>
        <td colspan="5"><span>${orderInfo.salesmanMobile}</span></td>
      </tr>
      <tr>
        <th scope="row"><spring:message code="service.title.OfficeNo" /></th>
        <td colspan="5"><span>${orderInfo.salesmanOffice}</span></td>
      </tr>
      <tr>
        <th scope="row"><spring:message
            code="supplement.title.text.ResidentNo" /></th>
        <td colspan="5"><span>${orderInfo.salesmanResident}</span></td>
      </tr>
    </tbody>
  </table>
</article>