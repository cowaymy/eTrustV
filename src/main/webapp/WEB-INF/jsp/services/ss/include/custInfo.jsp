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

    fn_maskingData('_nric', '${orderDetail.basicInfo.custNric}');
    fn_maskingData('_email', '${orderDetail.basicInfo.custEmail}');
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
        <td><span>${orderDetail.basicInfo.custId}</span></td>
        <th scope="row"><spring:message code="sal.text.custName" /></th>
        <td colspan="3"><span>${orderDetail.basicInfo.custName} ${orderDetail.basicInfo.memInfo}</span></td>
      </tr>
      <tr>
        <th scope="row"><spring:message code="sal.text.custType" /></th>
        <td><span>${orderDetail.basicInfo.custType}</span></td>
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
        <td><span>${orderDetail.basicInfo.custNation}</span></td>
      </tr>
      <tr>
        <th scope="row"><spring:message code="service.title.Gender" /></th>
        <td><span></span>${orderDetail.basicInfo.custGender}</td>
        <th scope="row"><spring:message code="sal.title.race" /></th>
       <td><span>${orderDetail.basicInfo.custRace}</span></td>
        <th scope="row"><spring:message code="supplement.text.passportExpiryDate" /></th>
        <td><span>${orderDetail.basicInfo.custPassportExpr}</span></td>
      </tr>
      <tr>
        <th scope="row"><spring:message code="sal.text.visaExpire" /></th>
        <td><span>${orderDetail.basicInfo.custVisaExpr}</span></td>
        <th scope="row"><spring:message code="sal.text.custStus" /></th>
        <td><span>${orderDetail.basicInfo.custStatus}</span></td>
        <th ></th>
        <td></td>
      </tr>

      <tr>
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