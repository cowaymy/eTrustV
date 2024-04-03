<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

  <script>
    $(document).ready(function(){
      // CONTACT INST. ADDRESS
      fn_maskingData('InsAddr', "${contactInfoTab.fullAddr}");
    });

    function fn_maskingData(ind, val) {
      var maskedVal = (val).substr(-4).padStart((val).length, '*');
      $("#span" + ind).html(maskedVal);
      /*$("#span" + ind).hover(function() {
        $("#span" + ind).html(val);
      }).mouseout(function() {
        $("#span" + ind).html(maskedVal);
      });
      $("#imgHover" + ind).hover(function() {
        $("#span" + ind).html(val);
      }).mouseout(function() {
        $("#span" + ind).html(maskedVal);
      });*/
    }
  </script>

  <article class="tap_area">
    <table class="type1">
      <caption>table</caption>
      <colgroup>
        <col style="width:180px" />
        <col style="width:*" />
        <col style="width:180px" />
        <col style="width:*" />
        <col style="width:180px" />
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
          <td colspan="5"><span>${orderInfoTab.custId}</span></td>
          <!-- <th scope="row"><spring:message code="sales.NRIC" />/<spring:message code="sales.CompanyNo" /></th>-->
          <!-- <td colspan="3"><span>${orderInfoTab.custNric}</span></td> -->
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
          <td colspan="5">
            <!-- <span id="ins_full_address">${contactInfoTab.fullAddr}</span> -->
            <!-- <a href="#" class="search_btn" id="imgHoverInsAddr"><img style="height:70%" src="${pageContext.request.contextPath}/resources/images/common/nricEye2.png" /></a> -->
            <span id="spanInsAddr" name='spanInsAddr' style="word-wrap:break-all;display:block;width:95%;"></span>
          </td>
        </tr>
      </tbody>
    </table>
  </article>