<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

  <article class="tap_area">
  <!-- tap_area start -->

  <table class="type1"><!-- table start -->
    <caption>table</caption>
    <colgroup>
      <col style="width:100px" />
      <col style="width:*" />
      <col style="width:100px" />
      <col style="width:*" />
      <col style="width:100px" />
      <col style="width:*" />
      <col style="width:100px" />
      <col style="width:*" />
    </colgroup>
    <tbody>
      <tr>
       <th scope="row"><spring:message code="sales.ContactPerson" /></th>
       <td colspan="7"><span  id="inc_cntName">${membershipInfoTab.cntName}</span></td>
      </tr>
      <tr>
        <th scope="row"><spring:message code="sales.NRIC" /></th>
        <11<td colspan="3">
          <!-- <span  id="inc_cntNric">${membershipInfoTab.cntNric}</span> -->
          <!-- <a href="#" class="search_btn" id="imgHoverNric"><img style="height:70%" src="${pageContext.request.contextPath}/resources/images/common/nricEye2.png" /></a> -->
          <span id="spanNric" name='spanNric'></span>
        </td>
        <th scope="row"><spring:message code="sal.text.gender" /></th>
        <td><span  id="inc_cntGender">${membershipInfoTab.cntGender}</span></td>
        <th scope="row"><spring:message code="sal.text.race" /></th>
        <td><span id="inc_cntRace">${membershipInfoTab.cntRace}</span></td>
      </tr>
      <tr>
        <th scope="row"><spring:message code="sal.text.telM" /></th>
        <td>
          <!-- <span>
            <span  id="inc_cntTelM">${membershipInfoTab.cntTelM}</span>
          </span>
          <input id="inc_cntTelM" name="inc_cntTelM" type="hidden" value="${membershipInfoTab.cntTelM}"/> -->
          <!-- <a href="#" class="search_btn" id="imgHoverCntTelM"><img style="height:70%" src="${pageContext.request.contextPath}/resources/images/common/nricEye2.png" /></a> -->
          <span id="spanCntTelM" name='spanCntTelM'></span>
        </td>
        <th scope="row"><spring:message code="sal.text.telR" /></th>
        <td>
          <!-- <span  id="inc_cntTelR">${membershipInfoTab.cntTelR}</span> -->
          <!-- <a href="#" class="search_btn" id="imgHoverCntTelR"><img style="height:70%" src="${pageContext.request.contextPath}/resources/images/common/nricEye2.png" /></a> -->
          <span id="spanCntTelR" name='spanCntTelR'></span>
        </td>
        <th scope="row"><spring:message code="sal.text.telO" /></th>
        <td>
          <!-- <span id="inc_cntTelO">${membershipInfoTab.cntTelO}</span> -->
          <!-- <a href="#" class="search_btn" id="imgHoverCntTelO"><img style="height:70%" src="${pageContext.request.contextPath}/resources/images/common/nricEye2.png" /></a> -->
          <span id="spanCntTelO" name='spanCntTelO'></span>
        </td>
        <th scope="row"><spring:message code="sal.text.telF" /></th>
        <td>
          <!-- <span id="inc_cntTelF">${membershipInfoTab.cntTelF}</span> -->
          <!-- <a href="#" class="search_btn" id="imgHoverCntTelF"><img style="height:70%" src="${pageContext.request.contextPath}/resources/images/common/nricEye2.png" /></a> -->
          <span id="spanCntTelF" name='spanCntTelF'></span>
        </td>
      </tr>
      <tr>
        <th scope="row"><spring:message code="sal.text.email" /></th>
        <td colspan="7" >
          <!-- <span id="inc_cntEmail" >${membershipInfoTab.cntEmail}</span> -->
          <!-- <a href="#" class="search_btn" id="imgHoverCntEmail"><img style="height:70%" src="${pageContext.request.contextPath}/resources/images/common/nricEye2.png" /></a> -->
          <span id="spanCntEmail" name='spanCntEmail'></span>
        </td>
      </tr>
      </tbody>
    </table><!-- table end -->
  </article><!-- tap_area end -->

  <script>
    $(document).ready(function(){
      // CONTACT TEL
      fn_maskingData('Nric', "${membershipInfoTab.cntNric}");
      // CONTACT TEL
      fn_maskingData('CntTelM', "${membershipInfoTab.cntTelM}");
      // TEL (RESIDENCE)
      fn_maskingData('CntTelR', '${membershipInfoTab.cntTelR}');
      // TEL (OFFICE)
      fn_maskingData('CntTelO', '${membershipInfoTab.cntTelO}');
      // TEL (FAX)
      fn_maskingData('CntTelF', '${membershipInfoTab.cntTelF}');
      // TEL (FAX)
      fn_maskingData('CntEmai', '${membershipInfoTab.cntEmail}');
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
