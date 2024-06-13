<script type="text/javaScript" language="javascript">
  var custInfoGridID;
  var oriNric = "${orderDetail.basicInfo.custNric}";

  $(document).ready(function(){
    if('${orderDetail.basicInfo.custType}' == "Individual") {
        var maskedNric = oriNric.substr(-4).padStart(oriNric.length, '*');
        $("#spanNric").html(maskedNric);
        // Appear NRIC on hover over field
        $("#spanNric").hover(function() {
            $("#spanNric").html(oriNric);
        }).mouseout(function() {
            $("#spanNric").html(maskedNric);
        });
        $("#imgHover").hover(function() {
            $("#spanNric").html(oriNric);
        }).mouseout(function() {
            $("#spanNric").html(maskedNric);
        });
    } else {
        $("#spanNric").html(oriNric);
    }

    fn_maskingData('_nric', '${orderInfo.custNric}');
    fn_maskingData('_mbNo', '${orderInfo.custMobileNo}');
    fn_maskingData('_offNo', '${orderInfo.custOfficeNo}');
    fn_maskingData('_resNo', '${orderInfo.custResidentNo}');
    fn_maskingData('_email', '${orderInfo.custEmail}');
  });

  function fn_maskingData(ind, obj) {
    var maskedVal = (obj).substr(-4).padStart((obj).length, '*');
      $("#span" + ind).html(maskedVal);
      $("#span" + ind).hover(function() {
          $("#span" + ind).html(obj);
      }).mouseout(function() {
          $("#span" + ind).html(maskedVal);
      });
      $("#imgHover" + ind).hover(function() {
          $("#span" + ind).html(obj);
      }).mouseout(function() {
          $("#span" + ind).html(maskedVal);
      });
  }

</script>
<article class="tap_area">
  <table class="type1">
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
        <td><span>${orderInfo.custId}</span></td>
        <th scope="row"><spring:message code="sal.text.custName" /></th>
        <td colspan="3"><span>${orderInfo.custName}</span></td>
      </tr>
      <tr>
        <th scope="row"><spring:message code="sal.text.custType" /></th>
        <td><span>${orderInfo.custTypeName}</span></td>
        <th scope="row"><spring:message code="sal.text.nricCompanyNo" /></th>
        <td>
          <table>
           <tr>
             <td width="80%"><span id='span_nric'></span></td>
             <td width="20%">
               <a href="#" class="search_btn" id="imgHover_nric">
                 <img style="height:70%" src="${pageContext.request.contextPath}/resources/images/common/nricEye2.png" />
               </a>
             </td>
           </tr>
          </table>
        </td>
        <th scope="row"><spring:message code="sal.text.nationality" /></th>
        <td><span>${orderInfo.nationName}</span></td>
      </tr>
      <tr>
        <th scope="row"><spring:message code="service.title.Gender" /></th>
        <td><span></span>${orderInfo.custGender}</td>
        <th scope="row"><spring:message code="sal.title.race" /></th>
       <td><span>${orderInfo.raceName}</span></td>
        <th scope="row"><spring:message code="supplement.text.passportExpiryDate" /></th>
        <td><span>${orderInfo.pasSportExpr}</span></td>
      </tr>
      <tr>
        <th scope="row"><spring:message code="sal.text.visaExpire" /></th>
        <td><span>${orderInfo.visaExpr}</span></td>
        <th scope="row"><spring:message code="sal.text.custStus" /></th>
        <td><span>${orderInfo.custStatus}</span></td>
        <th ></th>
        <td></td>
      </tr>
      <tr>
        <th scope="row"><spring:message code="sales.MobileNo" /></th>
        <td>
          <table>
           <tr>
             <td width="80%"><span id='span_mbNo'></span></td>
             <td width="20%">
               <a href="#" class="search_btn" id="imgHover_mbNo">
                 <img style="height:70%" src="${pageContext.request.contextPath}/resources/images/common/nricEye2.png" />
               </a>
             </td>
           </tr>
          </table>
        </td>
        <th scope="row"><spring:message code="sales.OfficeNo" /></th>
        <td>
          <table>
           <tr>
             <td width="80%"><span id='span_offNo'></span></td>
             <td width="20%">
               <a href="#" class="search_btn" id="imgHover_offNo">
                 <img style="height:70%" src="${pageContext.request.contextPath}/resources/images/common/nricEye2.png" />
               </a>
             </td>
           </tr>
          </table>
        </td>
        <th scope="row"><spring:message code="supplement.title.text.ResidentNo" /></th>
        <td>
          <table>
           <tr>
             <td width="80%"><span id='span_resNo'></span></td>
             <td width="20%">
               <a href="#" class="search_btn" id="imgHover_resNo">
                 <img style="height:70%" src="${pageContext.request.contextPath}/resources/images/common/nricEye2.png" />
               </a>
             </td>
           </tr>
          </table>
        </td>
      </tr>
      <tr>
        <th scope="row"><spring:message code="service.title.FaxNo" /></th>
        <td><span id='span_faxNo'>${orderInfo.custFaxNo}</span></td>
        <th scope="row"><spring:message code="sal.text.email" /></th>
        <td colspan="3">
          <table>
           <tr>
             <td width="95%"><span id='span_email'></span></td>
             <td width="5%">
               <a href="#" class="search_btn" id="imgHover_email">
                 <img style="height:70%" src="${pageContext.request.contextPath}/resources/images/common/nricEye2.png" />
               </a>
             </td>
           </tr>
          </table>
        </td>
      </tr>
    </tbody>
  </table>
</article>