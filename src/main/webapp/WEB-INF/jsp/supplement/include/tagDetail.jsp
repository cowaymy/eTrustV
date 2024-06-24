<script type="text/javascript">

</script>

<article class="tap_area">
  <table class="type1">
    <!-- table start -->
    <caption>table</caption>
    <colgroup>
      <col style="width: 180px" />
      <col style="width: *" />
      <col style="width: 180px" />
      <col style="width: *" />
      <col style="width: 180px" />
      <col style="width: *" />
    </colgroup>
    <tbody>
      <tr>
        <th scope="row"><spring:message code="service.grid.counselingNo" /></th>
        <td ><span>${tagInfo.counselingNo}</span></td>
        <th scope="row"><spring:message code="service.title.inqCustNm" /></th>
        <td ><span>${tagInfo.custName}</span></td>
        <th scope="row"><spring:message code="service.title.inqMemTyp" /></th>
        <td ><span></span></td>
      </tr>
      <tr>
        <th scope="row"><spring:message code="service.title.initMainDept" /></th>
        <td colspan="2">${tagInfo.inchgDeptName}</td>
        <th scope="row"><spring:message code="service.title.initSubDept" /></th>
        <td colspan="2">${tagInfo.subDeptName}</td>
      </tr>

       <tr>
        <th scope="row"><spring:message code="supplement.text.supplementReferenceNo" /></th>
        <td colspan="2">${tagInfo.supRefNo}</td>
        <th scope="row"><spring:message code="service.title.CustomerID" /></th>
        <td colspan="2">${tagInfo.custId}</td>
      </tr>


      <tr>
        <th scope="row"><spring:message code="supplement.text.supplementTagRegisterDt" /></th>
        <td colspan="2">${tagInfo.tagRegisterDt}</td>
        <th scope="row"><spring:message code="supplement.text.supplementTagStus" /></th>
        <td colspan="2">${tagInfo.tagStatus}</td>
      </tr>
      <tr>
        <th scope="row"><spring:message code="service.text.InChrDept" /></th>
        <td colspan="2">${tagInfo.inchgDeptName}</td>
        <th scope="row"><spring:message code="service.grid.subDept" /></th>
        <td colspan="2">${tagInfo.subDeptName}</td>
      </tr>
      <tr>
        <th scope="row"><spring:message code="supplement.text.supplementMainTopicInquiry" /></th>
        <td colspan="2">${tagInfo.mainTopic}</td>
        <th scope="row"><spring:message code="supplement.text.supplementSubTopicInquiry" /></th>
        <td colspan="2">${tagInfo.subTopic}</td>
      </tr>
      <tr>
          <td colspan="6"></td>
          </tr>
      <tr>
        <th scope="row"><spring:message code="service.title.carelineAttc" /></th>
        <td colspan="5">${tagInfo.carelineAtch}</td>
      </tr>
      <tr>
        <th scope="row"><spring:message code="service.title.hqAttc" /></th>
        <td colspan="5"></td>
      </tr>

    </tbody>
    </br>
  </table>

</article>
