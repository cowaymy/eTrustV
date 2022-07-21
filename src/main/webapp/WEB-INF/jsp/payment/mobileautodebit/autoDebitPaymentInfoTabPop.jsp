<article class="tap_area">
  <table class="type1">
    <caption>
      table
    </caption>
    <colgroup>
      <col style="width: 400px" />
      <col style="width: *" />
    </colgroup>
    <tbody>
      <tr>
        <th scope="row">Pay By Third Party</th>
        <td>
          <input type="checkbox" id="thirdPartyPayCheckBox" disabled />
          <ul
            class="right_btns thirdPartySection"
            style="float: right !important"
          >
            <li>
              <p class="btn_grid">
                <a id="btnAddThirdPartyCust" href="#">
                  <spring:message code="sal.btn.addNewThirdParty" />
                </a>
              </p>
            </li>
          </ul>
        </td>
      </tr>
      <tr></tr>
    </tbody>
  </table>
  <section class="thirdPartySection">
    <table class="type1">
      <!-- table start -->
      <caption>
        table
      </caption>
      <colgroup>
        <col style="width: 140px" />
        <col style="width: *" />
        <col style="width: 150px" />
        <col style="width: *" />
      </colgroup>
      <tbody>
        <tr>
          <th scope="row">
            <spring:message code="sal.text.customerId" /><span class="must"
              >*</span
            >
          </th>
          <td>
            <input
              id="thrdPartyId"
              name="thrdPartyId"
              type="text"
              title=""
              placeholder="Third Party ID"
              class=""
              readonly
            />
            <a href="#" class="search_btn" id="btnThirdPartyCustSearch"
              ><img
                src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif"
                alt="search"
            /></a>
          </td>
          <th scope="row"><spring:message code="sal.text.type" /></th>
          <td><span id="thrdPartyType"></span></td>
        </tr>
        <tr>
          <th scope="row"><spring:message code="sal.text.name" /></th>
          <td><span id="thrdPartyName"></span></td>
          <th scope="row"><spring:message code="sal.text.nricCompanyNo" /></th>
          <td>
            <span id="txtThrdPartyNric"></span>
          </td>
        </tr>
      </tbody>
    </table>
  </section>
  <!-- title_line start -->
  <aside class="title_line">
    <h2>
      <spring:message code="sal.title.text.crdCard" />
    </h2>
  </aside>
  <!-- title_line end -->
  <table class="type1">
    <caption>
      table
    </caption>
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
          <input
            type="text"
            id="visaMasterType"
            class="readonly w100p"
            readonly
          />
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
          <input
            type="text"
            id="cardExpiryDate"
            class="readonly w100p"
            readonly
          />
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
          <input
            type="text"
            id="custCardType"
            class="readonly w100p"
            readonly
          />
        </td>
      </tr>
    </tbody>
  </table>
</article>
