<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<!--
 DATE          BY         VERSION        REMARK
 ----------------------------------------------------------------
 24/06/2020  ONGHC  1.0.0             Add Date Checking Feature
 -->

<script type="text/javascript">
  var date = new Date().getDate();
  var mon = new Date().getMonth() + 1;
  if (date.toString().length == 1) {
    date = "0" + date;
  }
  if (mon.toString().length == 1) {
    mon = "0" + mon;
  }
  $("#dpRequestDtFrom").val("01/" + mon + "/" + new Date().getFullYear());
  $("#dpRequestDtTo").val(date + "/" + mon + "/" + new Date().getFullYear());
  $("#dpReturnDtFrom").val("01/" + mon + "/" + new Date().getFullYear());
  $("#dpReturnDtTo").val(date + "/" + mon + "/" + new Date().getFullYear());
  $("#dpAppDtFrom").val("01/" + mon + "/" + new Date().getFullYear());
  $("#dpAppDtTo").val(date + "/" + mon + "/" + new Date().getFullYear());

  doGetCombo('/common/selectCodeList.do', '10', '', 'dpAppType', 'M', 'fn_multiCombo');
  doGetCombo('/services/holiday/selectBranchWithNM', 43, '', 'dpBranch', 'S', ''); // DSC BRANCH

  //$("#dpBranch").change(
  //function() {
  //doGetCombo('/services/as/selectCTByDSC.do', $("#dpBranch").val(), '', 'dpCtCode', 'M', 'fn_multiCombo');
  //});

  /* 멀티셀렉트 플러그인 start */
  $('.multy_select').change(function() {
  }).multipleSelect({
    width : '100%'
  });

  $.fn.clearForm = function() {
    return this.each(function() {
      var type = this.type, tag = this.tagName.toLowerCase();
      if (tag === 'form') {
        return $(':input', this).clearForm();
      }
      if (type === 'text' || type === 'password' || type === 'hidden' || tag === 'textarea') {
        this.value = '';
      } else if (tag === 'select') {
        this.selectedIndex = 0;
      }
      $("#dpRequestDtFrom").val("01/" + (new Date().getMonth() + 1) + "/" + new Date().getFullYear());
      $("#dpRequestDtTo").val(date + "/" + (new Date().getMonth() + 1) + "/" + new Date().getFullYear());

      $("#dpReturnDtFrom").val("01/" + (new Date().getMonth() + 1) + "/" + new Date().getFullYear());
      $("#dpReturnDtTo").val(date + "/" + (new Date().getMonth() + 1) + "/" + new Date().getFullYear());
    });
  };

  function fn_multiCombo() {
    //$('#dpCtCode').change(function() {
    //}).multipleSelect({
    // selectAll : true, // 전체선택
    //  width : '100%'
    //});

    $('#dpAppType').change(function() {
    }).multipleSelect({
      selectAll : false, // 전체선택
      width : '100%'
    }).multipleSelect("checkAll");
    ;
  }

  function btnGenerate_Click() {
    //var from_req_dt = "";
    //var to_req_dt = "";
    //var from_ret_dt = "";
    //var to_ret_dt = "";
    var runNo = 0;
    var where1 = "";
    var where2 = "";
    var where3 = "";

    if (validate()) {
      //if (!($("#dpRequestDtFrom").val() == null || $("#dpRequestDtFrom").val().length == 0)) {
      //from_req_dt = $("#dpRequestDtFrom").val();
      //}

      //if (!($("#dpRequestDtTo").val() == null || $("#dpRequestDtTo").val().length == 0)) {
      //to_req_dt = $("#dpRequestDtTo").val();
      //}

      //if (!($("#dpReturnDtFrom").val() == null || $("#dpReturnDtFrom").val().length == 0)) {
      //from_ret_dt = $("#dpReturnDtFrom").val();
      //}

      //if (!($("#dpReturnDtTo").val() == null || $("#dpReturnDtTo").val().length == 0)) {
      //to_ret_dt = $("#dpReturnDtTo").val();
      //}

      // FORM 1ST CONDITION
      if (($("#dpAppDtFrom").val() != null && $("#dpAppDtFrom").val() != "") && ($("#dpAppDtTo").val() != null && $("#dpAppDtTo").val() != "")) {
        where1 = where1 + " AND TO_CHAR(RE.APP_DT, 'YYYYMMDD') >= TO_CHAR(TO_DATE('" + $("#dpAppDtFrom").val() + "', 'DD/MM/YYYY'), 'YYYYMMDD') AND TO_CHAR(RE.APP_DT, 'YYYYMMDD') <= TO_CHAR(TO_DATE('" + $("#dpAppDtTo").val() + "', 'DD/MM/YYYY'), 'YYYYMMDD') ";
      }

      if ($("#dpAppType").val() != null && $("#dpAppType").val() != "") {
        where1 = where1 + " AND B.APP_TYPE_ID IN (" + $("#dpAppType").val() + ") ";
      }

      if ($("#dpBranch").val() != null && $("#dpBranch").val() != "") {
        where1 = where1 + " AND C.BRNCH_ID = (SELECT BRNCH_ID FROM SYS0005M WHERE CODE = '" + $("#dpBranch").val() + "' AND STUS_ID = 1)";
      }

      // FORM 2ND CONDITION
      if ($("#reqStageIdPop").val() != null && $("#reqStageIdPop").val() != "") {
        where2 = where2 + " AND REQ.SO_REQ_CUR_STUS_ID IN (" + $("#reqStageIdPop").val() + ") ";
      }
      if (($("#dpRequestDtFrom").val() != null && $("#dpRequestDtFrom").val() != "") && ($("#dpRequestDtTo").val() != null && $("#dpRequestDtTo").val() != "")) {
        where2 = where2 + " AND TO_CHAR(REQ.SO_REQ_CRT_DT, 'YYYYMMDD') >= TO_CHAR(TO_DATE('" + $("#dpRequestDtFrom").val() + "', 'DD/MM/YYYY'), 'YYYYMMDD') AND TO_CHAR(REQ.SO_REQ_CRT_DT, 'YYYYMMDD') <= TO_CHAR(TO_DATE('" + $("#dpRequestDtTo").val() + "', 'DD/MM/YYYY'), 'YYYYMMDD') ";
      }
      if (($("#dpReturnDtFrom").val() != null && $("#dpReturnDtFrom").val() != "") && ($("#dpReturnDtTo").val() != null && $("#dpReturnDtTo").val() != "")) {
        where2 = where2 + " AND TO_CHAR(RR.STK_RETN_DT, 'YYYYMMDD') >= TO_CHAR(TO_DATE('" + $("#dpReturnDtFrom").val() + "', 'DD/MM/YYYY'), 'YYYYMMDD') AND TO_CHAR(RR.STK_RETN_DT, 'YYYYMMDD') <= TO_CHAR(TO_DATE('" + $("#dpReturnDtTo").val() + "', 'DD/MM/YYYY'), 'YYYYMMDD') ";
      }

      if ($("#V_TYPE").val() != "") {
        if ($("#V_TYPE").val() == "HA") {
          where3 = "AND E.STK_CTGRY_ID NOT IN ('5706', '5707') ";
        } else if ($("#V_TYPE").val() == "HC") {
          where3 = "AND E.STK_CTGRY_ID IN ('5706', '5707') ";
        }
      }

      //$("#V_REQUESTDTFROM").val(from_req_dt);
      //$("#V_REQUESTDTTO").val(to_req_dt);
      //$("#V_RETURNDTFROM").val(from_ret_dt);
      //$("#V_RETURNDTTO").val(to_ret_dt);

      $("#V_WHERE_1").val(where1);
      $("#V_WHERE_2").val(where2);
      $("#V_WHERE_3").val(where3);

      $("#reportDownFileName").val("OrderCancellationProductReturnRawData_" + date + (new Date().getMonth() + 1) + new Date().getFullYear());
      $("#reportFileName").val("/sales/OrderCancellationProductReturnRawData_2.rpt");
      $("#viewType").val("EXCEL");

      var option = {
        isProcedure : true
      };

      Common.report("form", option);
    } else {
      return false;
    }
  }

  function validate() {
    var status = true;
    var msg = "";
    var text = "";
    var dtRange = 0;

    if ($("#ind").val() == 1) {
      dtRange = 124; // HQ
    } else {
      dtRange = 31; // OTHER ADMIN
    }

    if (($("#dpRequestDtFrom").val() == null || $("#dpRequestDtFrom").val() == "") || ($("#dpRequestDtTo").val() == null || $("#dpRequestDtTo").val() == "")) {
      if (($("#dpReturnDtFrom").val() == null || $("#dpReturnDtFrom").val() == "") || ($("#dpReturnDtTo").val() == null || $("#dpReturnDtTo").val() == "")) {
        if (($("#dpAppDtFrom").val() == null || $("#dpAppDtFrom").val() == "") || ($("#dpAppDtTo").val() == null || $("#dpAppDtTo").val() == "")) {
          text = "<spring:message code='sal.text.requestDate' />" + " OR " + "<spring:message code='sal.text.returnDate' />" + " OR " + "<spring:message code='service.title.AppointmentDate' />";
          msg = msg + "<spring:message code='sys.common.alert.validation' arguments='" + text + "' htmlEscape='false'/><br/>";
        } else {
          // PASS
        }
      } else {
        // PASS
      }
    } else {
      // PASS
    }

    if (($("#dpRequestDtFrom").val() != null && $("#dpRequestDtFrom").val() != "") && ($("#dpRequestDtTo").val() != null && $("#dpRequestDtTo").val() != "")) {
      var keyInDateFrom = $("#dpRequestDtFrom").val().substring(3, 5) + "/"
                                  + $("#dpRequestDtFrom").val().substring(0, 2) + "/"
                                  + $("#dpRequestDtFrom").val().substring(6, 10);

      var keyInDateTo = $("#dpRequestDtTo").val().substring(3, 5) + "/"
                              + $("#dpRequestDtTo").val().substring(0, 2) + "/"
                              + $("#dpRequestDtTo").val().substring(6, 10);

      var date1 = new Date(keyInDateFrom);
      var date2 = new Date(keyInDateTo);

      var diff_in_time = date2.getTime() - date1.getTime();

      var diff_in_days = diff_in_time / (1000 * 3600 * 24);

      if (diff_in_days > dtRange) {
        Common.alert("<spring:message code='sys.common.alert.dtRangeNtMore' arguments='" + dtRange + "' htmlEscape='false'/>");
        return false;
      }
    }

    if (($("#dpReturnDtFrom").val() != null && $("#dpReturnDtFrom").val() != "") && ($("#dpReturnDtTo").val() != null && $("#dpReturnDtTo").val() != "")) {
      var keyInDateFrom = $("#dpReturnDtFrom").val().substring(3, 5) + "/"
                                  + $("#dpReturnDtFrom").val().substring(0, 2) + "/"
                                  + $("#dpReturnDtFrom").val().substring(6, 10);

      var keyInDateTo = $("#dpReturnDtTo").val().substring(3, 5) + "/"
                              + $("#dpReturnDtTo").val().substring(0, 2) + "/"
                              + $("#dpReturnDtTo").val().substring(6, 10);

      var date1 = new Date(keyInDateFrom);
      var date2 = new Date(keyInDateTo);

      var diff_in_time = date2.getTime() - date1.getTime();

      var diff_in_days = diff_in_time / (1000 * 3600 * 24);

      if (diff_in_days > dtRange) {
        Common.alert("<spring:message code='sys.common.alert.dtRangeNtMore' arguments='" + dtRange + "' htmlEscape='false'/>");
        return false;
      }
    }

    if (($("#dpAppDtFrom").val() != null && $("#dpAppDtFrom").val() != "") && ($("#dpAppDtTo").val() != null && $("#dpAppDtTo").val() != "")) {
      var keyInDateFrom = $("#dpAppDtFrom").val().substring(3, 5) + "/"
                                  + $("#dpAppDtFrom").val().substring(0, 2) + "/"
                                  + $("#dpAppDtFrom").val().substring(6, 10);

      var keyInDateTo = $("#dpAppDtTo").val().substring(3, 5) + "/"
                              + $("#dpAppDtTo").val().substring(0, 2) + "/"
                              + $("#dpAppDtTo").val().substring(6, 10);

      var date1 = new Date(keyInDateFrom);
      var date2 = new Date(keyInDateTo);

      var diff_in_time = date2.getTime() - date1.getTime();

      var diff_in_days = diff_in_time / (1000 * 3600 * 24);

      if (diff_in_days > dtRange) {
        Common.alert("<spring:message code='sys.common.alert.dtRangeNtMore' arguments='" + dtRange + "' htmlEscape='false'/>");
        return false;
      }
    }

    if ($("#dpAppType").val() == null || $("#dpAppType").val() == "") {
      text = "<spring:message code='service.title.ApplicationType' />";
      msg = msg + "<spring:message code='sys.common.alert.validation' arguments='" + text + "' htmlEscape='false'/><br/>";
    }

    if ($("#reqStageIdPop").val() == null || $("#reqStageIdPop").val() == "") {
      text = "<spring:message code='sal.title.text.requestStage' />";
      msg = msg + "<spring:message code='sys.common.alert.validation' arguments='" + text + "' htmlEscape='false'/><br/>";
    }

    if (msg != "") {
      Common.alert(msg);
      return false
    }

     return true;
  }
</script>
<div id="popup_wrap" class="popup_wrap">
  <!-- popup_wrap start -->
  <header class="pop_header">
    <!-- pop_header start -->
    <h1>Order Cancellation Product Return Raw</h1>
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
          <tbody>
            <tr>
              <th scope="row"><spring:message code="sal.text.requestDate" /></th>
              <td>
                <div class="date_set w100p">
                  <p><input type="text" title="Request start Date" placeholder="DD/MM/YYYY" class="j_date" id="dpRequestDtFrom" /></p> <span><spring:message code="sal.text.to" /></span>
                  <p><input type="text" title="Request end Date" placeholder="DD/MM/YYYY" class="j_date" id="dpRequestDtTo" /></p>
                </div>
                <!-- date_set end -->
              </td>
              <th scope="row"><spring:message code="sal.text.returnDate" /></th>
              <td>
                <div class="date_set w100p">
                  <!-- date_set start -->
                  <p><input type="text" title="Return start Date" placeholder="DD/MM/YYYY" class="j_date" id="dpReturnDtFrom" /></p> <span><spring:message code="sal.text.to" /></span>
                  <p><input type="text" title="Return end Date" placeholder="DD/MM/YYYY" class="j_date" id="dpReturnDtTo" /></p>
                </div>
                <!-- date_set end -->
              </td>
            </tr>
            <tr>
              <th scope="row"><spring:message code="service.title.AppointmentDate" /></th>
              <td>
                <div class="date_set w100p">
                  <p><input type="text" title="Request start Date" placeholder="DD/MM/YYYY" class="j_date" id="dpAppDtFrom" /></p> <span><spring:message code="sal.text.to" /></span>
                  <p><input type="text" title="Request end Date" placeholder="DD/MM/YYYY" class="j_date" id="dpAppDtTo" /></p>
                </div>
                <!-- date_set end -->
              </td>
              <th scope="row"><spring:message code='service.title.ApplicationType' /><span name="m1" id="m1" class="must">*</span></th>
              <td>
                <select id="dpAppType" name="dpAppType" class="multy_select w100p"></select>
              </td>
            </tr>
            <tr>
              <th scope="row"><spring:message code="sal.title.text.requestStage" /><span name="m2" id="m2" class="must">*</span></th>
              <td>
                <select id="reqStageIdPop" name="reqStageIdPop" class="multy_select w100p" multiple="multiple">
                  <option value="24" selected><spring:message code="sal.text.beforeInstall" /></option>
                  <option value="25" selected><spring:message code="sal.text.afterInstall" /></option>
                </select>
              </td>
              <th scope="row"><spring:message code='service.title.DSCBranch' /></th>
              <td>
                <select id="dpBranch" name="dpBranch" class="w100p"></select>
              </td>
            </tr>
            <!-- <tr>
       <th scope="row"><spring:message code='service.grid.CTCode' /></th>
       <td colspan="3">
        <select id="dpCtCode" name="dpCtCode" class="multy_select w100p" multiple="multiple">
        </select>
       </td>
      </tr>  -->
          </tbody>
        </table>
        <!-- table end -->
        <input type="hidden" id="reportFileName" name="reportFileName" value="" />
        <input type="hidden" id="viewType" name="viewType" value="EXCEL" />
        <input type="hidden" id="reportDownFileName" name="reportDownFileName" value="" />
        <input type="hidden" id="V_REQUESTDTFROM" name="FROM_REQ_DT" value="">
        <input type="hidden" id="V_REQUESTDTTO" name="TO_REQ_DT" value="">
        <input type="hidden" id="V_RETURNDTFROM" name="FROM_RET_DT" value="">
        <input type="hidden" id="V_RETURNDTTO" name="TO_RET_DT" value="">
        <input type="hidden" id="V_WHERE_1" name="WHERE_1" value="">
        <input type="hidden" id="V_WHERE_2" name="WHERE_2" value="">
        <input type="hidden" id="V_WHERE_3" name="WHERE_3" value="">
        <input type="hidden" id="V_TYPE" name="V_TYPE" value="${type}">
        <input type="hidden" id="ind" name="ind" value="${ind}"/>
      </form>
      <div></div>
      <ul class="center_btns">
        <li><p class="btn_blue"><a href="#" onclick="javascript: btnGenerate_Click()"><spring:message code="sal.btn.generate" /></a></p></li>
        <li><p class="btn_blue"><a href="#" onclick="javascript:$('#form').clearForm();"> <spring:message code="sal.btn.clear" /></a></p></li>
      </ul>
    </section>
    <!-- content end -->
  </section>
  <!-- container end -->
</div>
<!-- popup_wrap end -->