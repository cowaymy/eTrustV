<article class="tap_area">
  <table class="type1">
    <caption>table</caption>
    <colgroup>
      <col style="width: 400px" />
      <col style="width: *" />
    </colgroup>
    <tbody>
      <tr>
        <th scope="row">Pay By Third Party</th>
        <td>
          <input type="checkbox" id="thirdPartyPayCheckBox" disabled />
          <ul class="right_btns thirdPartySection" style="float: right !important"></ul>
        </td>
      </tr>
      <tr></tr>
    </tbody>
  </table>
  <section class="thirdPartySection">
    <table class="type1">
      <caption>table</caption>
      <colgroup>
        <col style="width: 140px" />
        <col style="width: *" />
        <col style="width: 150px" />
        <col style="width: *" />
      </colgroup>
      <tbody>
        <tr>
          <th scope="row">
            <spring:message code="sal.text.customerId" /><span class="must">*</span>
          </th>
          <td>
            <input id="thrdPartyId" name="thrdPartyId" type="text" title="" placeholder="Third Party ID" class="100p" readonly />
          </td>
          <th scope="row"><spring:message code="sal.text.type" /></th>
          <td><span id="thrdPartyType"></span></td>
        </tr>
        <tr>
          <th scope="row"><spring:message code="sal.text.name" /></th>
          <td><span id="thrdPartyName"></span></td>
          <th scope="row"><spring:message code="sal.text.nricCompanyNo" /></th>
          <td>
            <!-- <span id="txtThrdPartyNric" ></span> -->
            <input id="txtThrdPartyNric" name="txtThrdPartyNric" type="text" title="" placeholder="Third Party ID" class="" readonly style="display:none"/>
            <table id="pThrdPartyNric">
                <tr>
                  <td width="5%">
                    <a href="#" class="search_btn" id="imgHoverThrdPartyNric">
                      <img style="height:70%" src="${pageContext.request.contextPath}/resources/images/common/nricEye2.png" />
                     </a>
                   </td>
                   <td><span id="spanThrdPartyNric"></span></td>
                 </tr>
               </table>
          </td>
        </tr>
      </tbody>
    </table>
  </section>
  <aside class="title_line">
    <h2>
      <spring:message code="sal.title.text.crdCard" />
    </h2>
  </aside>
  <table class="type1">
    <caption table</caption>
    <colgroup>
      <col style="width: 400px" />
      <col style="width: *" />
    </colgroup>
    <tbody>
      <tr>
        <th scope="row">Card Number | No Kad <span class="must">*</span></th>
        <td colspan="3">
          <input type="text" id="cardNumber" class="readonly w100p" readonly />
        </td>
      </tr>
      <tr>
        <th scope="row">Visa/Master</th>
        <td colspan="3">
          <input type="text" id="visaMasterType" class="readonly w100p" readonly />
        </td>
      </tr>
      <tr>
        <th scope="row">Name on Card | Nama pada Kad</th>
        <td colspan="3">
          <input type="text" id="custCrcName" class="readonly w100p" readonly />
        </td>
      </tr>
      <tr>
        <th scope="row">Expiry Date | Tarikh Tamat Kad</th>
        <td colspan="3">
          <input type="text" id="cardExpiryDate" class="readonly w100p" readonly />
        </td>
      </tr>
      <tr>
        <th scope="row">Issue Bank | Bank Pengeluar</th>
        <td colspan="3">
          <input type="text" id="issueBank" class="readonly w100p" readonly />
        </td>
      </tr>
      <tr>
        <th scope="row">Card Type | Jenis Kad</th>
        <td colspan="3">
          <input type="text" id="custCardType" class="readonly w100p" readonly />
        </td>
      </tr>
    </tbody>
  </table>
</article>
