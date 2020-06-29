<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javascript">
  var date = new Date().getDate();

  /* 멀티셀렉트 플러그인 start */
  $('.multy_select').change(function() {
    //console.log($(this).val());
  }).multipleSelect({
    width : '100%'
  });

  function btnGenerate_Click() {
    var whereSQL = "";

    if (!($("#dpReqDateFrom").val() == null || $("#dpReqDateFrom").val().length == 0)) {
      whereSQL += " AND A.SO_EXCHG_CRT_DT >= TO_DATE('" + $("#dpReqDateFrom").val() + "', 'dd/MM/YY') ";
    }

    if (!($("#dpReqDateTo").val() == null || $("#dpReqDateTo").val().length == 0)) {
      whereSQL += " AND A.SO_EXCHG_CRT_DT < TO_DATE('" + $("#dpReqDateTo").val() + "', 'dd/MM/YY') ";
    }

    $("#viewType").val("EXCEL");
    $("#V_WHERESQL").val(whereSQL);

    $("#reportDownFileName").val("OrderExchangeRawData_" + date + (new Date().getMonth() + 1) + new Date().getFullYear());
    $("#reportFileName").val("/sales/OrderExchangeRawData2.rpt");

    // 프로시져로 구성된 경우 꼭 아래 option을 넘겨야 함.
    var option = {
      isProcedure : true
    // procedure 로 구성된 리포트 인경우 필수.  => /payment/PaymentListing_Excel.rpt 는 프로시져로 구성된 파일임.
    };

    Common.report("form", option);

  }
</script>
<div id="popup_wrap" class="popup_wrap">
  <!-- popup_wrap start -->
  <header class="pop_header">
    <!-- pop_header start -->
    <h1>
      <spring:message code="sal.title.text.exchangeRawData" /> - (HQ Format)
    </h1>
    <ul class="right_opt">
      <li><p class="btn_blue2"><a href="#"><spring:message code="sal.btn.close" /></a></p></li>
    </ul>
  </header>
  <!-- pop_header end -->
  <section class="pop_body">
    <!-- pop_body start -->
    <aside class="title_line">
      <!-- title_line start -->
    </aside>
    <!-- title_line end -->
    <section class="search_table">
      <!-- search_table start -->
      <form action="#" method="post" id="form">
        <table class="type1">
          <!-- table start -->
          <caption>table</caption>
          <colgroup>
            <col style="width: 140px" />
            <col style="width: *" />
            <col style="width: 150px" />
            <col style="width: *" />
            <col style="width: 130px" />
            <col style="width: *" />
          </colgroup>
          <tbody>
            <tr>
              <th scope="row"><spring:message code="sal.title.text.requestDate" /></th>
              <td colspan="2">
                <div class="date_set w100p">
                  <!-- date_set start -->
                  <p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" id="dpReqDateFrom" value="${bfDay}"/></p> <span><spring:message code="sal.title.to" /></span>
                  <p><input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" id="dpReqDateTo" value="${toDay}"/></p>
                </div>
                <!-- date_set end -->
              </td>
              <th scope="row"></th>
              <td colspan="2">
              </td>
            </tr>

          </tbody>
        </table>
        <!-- table end -->
        <ul class="center_btns">
          <li><p class="btn_blue2"><a href="#" onclick="javascript: btnGenerate_Click()"><spring:message code="sal.btn.generate" /></a></p></li>
        </ul>
        <input type="hidden" id="reportFileName" name="reportFileName" value="" /> <input type="hidden" id="viewType" name="viewType" value="EXCEL" /> <input type="hidden" id="reportDownFileName" name="reportDownFileName" value="" /> <input type="hidden" id="V_WHERESQL" name="V_WHERESQL" value="">
      </form>
    </section>
    <!-- content end -->
  </section>
  <!-- container end -->
</div>
<!-- popup_wrap end -->