<script type="text/javaScript" language="javascript">

    var custInfoGridID;
    var oriNric = "${orderDetail.basicInfo.custNric}";

    $(document).ready(function(){

     // Masking pen (display last 4)
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
    });


</script>

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
    <td><span>${orderInfo.custId}</span></td>
    <th scope="row"><spring:message code="sal.text.custName" /></th>
    <td colspan="3"><span>${orderInfo.custName}</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.custType" /></th>
    <td><span>${orderInfo.custTypeName}</span></td>
    <th scope="row"><spring:message code="sal.text.nricCompanyNo" /></th>
    <td><span>${orderInfo.custNric}</span></td>
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
    <td><span>${orderInfo.custMobileNo}</span></td>
    <th scope="row"><spring:message code="sales.OfficeNo" /></th>
    <td><span>${orderInfo.custOfficeNo}</span></td>
    <th scope="row"><spring:message code="supplement.title.text.ResidentNo" /></th>
    <td><span>${orderInfo.custResidentNo}</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="service.title.FaxNo" /></th>
    <td><span>${orderInfo.custFaxNo}</span></td>
    <th scope="row"><spring:message code="sal.text.email" /></th>
    <td colspan="3"><span>${orderInfo.custEmail}</span></td>
</tr>

</tbody>
</table><!-- table end -->



</article><!-- tap_area end -->