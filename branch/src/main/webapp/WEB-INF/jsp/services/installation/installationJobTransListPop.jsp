<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<!--
 DATE        BY     VERSION        REMARK
 ----------------------------------------------------------------
 01/07/2020  ONGHC  1.0.0       Create Installation Job Transfer Failure Listing
 -->
<script type="text/javaScript">
  $(document).ready(function() {

  });

  function fn_validation() {
    var msg = "";
    var text = "";

    if ($("#transDtFrom").val() == '') {
      text = "<spring:message code='service.title.transDt' />";
      msg += "* <spring:message code='sys.msg.necessary' arguments='" + text + "' htmlEscape='false'/> </br>";
    } else if ($("#transDtTo").val() == '') {
      text = "<spring:message code='service.title.transDt' />";
      msg += "* <spring:message code='sys.msg.necessary' arguments='" + text + "' htmlEscape='false'/> </br>";
    }

    if (msg != '') {
      Common.alert(msg);
      return false;
    }

    msg = "";
    text = "";

    if ($("#transDtFrom").val() != '' || $("#transDtTo").val() != '') {
      if ($("#transDtFrom").val() == '' || $("#transDtTo").val() == '') {
        text = "<spring:message code='service.title.transDt' />";
        msg += "* <spring:message code='sys.msg.necessary' arguments='" + text + "' htmlEscape='false'/> </br>";
      }
    }

    if (msg != '') {
      Common.alert(msg);
      return false;
    }

    return true;
  }

  function fn_openReport() {
    if (fn_validation()) {
      var date = new Date();
      var SelectSql = "";
      var whereSeq = "";
      var month = date.getMonth() + 1;
      var day = date.getDate();

      if (date.getDate() < 10) {
        day = "0" + date.getDate();
      }

      if ($("#transDtFrom").val() != '' && $("#transDtTo").val() != '' && $("#transDtFrom").val() != null && $("#transDtTo").val() != null) {
        var tranDtFrom = $("#transDtFrom").val().substring(6, ($("#transDtFrom").val()).length) + $("#transDtFrom").val().substring(3, 5) + $("#transDtFrom").val().substring(0, 2);
        var tranDtTo = $("#transDtTo").val().substring(6, ($("#transDtTo").val()).length) + $("#transDtTo").val().substring(3, 5) + $("#transDtTo").val().substring(0, 2);

        whereSeq += "AND (TO_CHAR(CRT_DT, 'YYYYMMDD') >= '" + tranDtFrom + "'  " +
                            "AND TO_CHAR(CRT_DT, 'YYYYMMDD') <= '" + tranDtTo + "') ";
      }

      if ($("#instalNo").val() != '' && $("#instalNo").val() != null) {
        whereSeq += " AND INST_NO = '" + $("#instalNo").val() + "' ";
      }

      $("#installationNoteForm #V_WHERESQL").val(whereSeq);
      $("#installationNoteForm #reportFileName").val('/services/InstJobTransList.rpt');
      $("#installationNoteForm #viewType").val("PDF");
      $("#installationNoteForm #reportDownFileName").val("InstallationJobTransferFailuerListing_" + day + month + date.getFullYear());

      var option = {
        isProcedure : true,
      };

      Common.report("installationNoteForm", option);
    }
  }

  function fn_clear() {
    $("#transDtFrom").val('');
    $("#transDtTo").val('');
    $("#instalNo").val('');
    $("#V_WHERESQL").val('');
    $("#V_SELECTSQL").val('');
    $("#reportFileName").val('');
    $("#viewType").val('');
  }
</script>
<div id="popup_wrap" class="popup_wrap">
  <!-- popup_wrap start -->
  <header class="pop_header">
    <!-- pop_header start -->
    <h1>
      <spring:message code='service.title.InstallationNote' />
    </h1>
    <ul class="right_opt">
      <li><p class="btn_blue2"><a href="#"><spring:message code='expense.CLOSE' /></a></p></li>
    </ul>
  </header>
  <!-- pop_header end -->
  <section class="pop_body">
    <!-- pop_body start -->
    <section class="search_table">
      <!-- search_table start -->
      <table class="type1">
        <!-- table start -->
        <caption>table</caption>
        <colgroup>
          <col style="width: 150px" />
          <col style="width: *" />
          <col style="width: 160px" />
          <col style="width: *" />
        </colgroup>
        <tbody>
          <tr>
            <th scope="row"><spring:message code='service.title.InstallationNo' /></th>
            <td>
              <input type="text" title="" placeholder="<spring:message code='service.title.InstallationNo' />" class="w100p" id="instalNo" name="instalNo" />
            </td>
            <th scope="row"><spring:message code='service.title.transDt' /></th>
            <td>
              <div class="date_set">
                <p><input type="text" title="Transfer start Date" placeholder="DD/MM/YYYY" class="j_date" id="transDtFrom" name="transDtFrom" /></p> <span><spring:message code='sal.text.to' /></span>
                <p><input type="text" title="Transfer end Date" placeholder="DD/MM/YYYY" class="j_date" id="transDtTo" name="transDtTo" /></p>
              </div>
            </td>
          </tr>
        </tbody>
      </table>
      <!-- table end -->
      <form method="post" id="installationNoteForm" name="installationNoteForm">
        <input type="hidden" id="V_WHERESQL" name="V_WHERESQL" />
        <input type="hidden" id="V_WHERESQL2" name="V_WHERESQL2" />
        <input type="hidden" id="V_INSTALLSTATUS" name="V_INSTALLSTATUS" />
        <input type="hidden" id="V_ORDERBYSQL" name="V_ORDERBYSQL" />
        <input type="hidden" id="V_SELECTSQL" name="V_SELECTSQL" />
        <input type="hidden" id="V_FULLSQL" name="V_FULLSQL" />
        <!--reportFileName,  viewType 모든 레포트 필수값 -->
        <input type="hidden" id="reportFileName" name="reportFileName" /> <input type="hidden" id="viewType" name="viewType" /> <input type="hidden" id="reportDownFileName" name="reportDownFileName" value="DOWN_FILE_NAME" />
      </form>
    </section>
    <!-- search_table end -->
    <ul class="center_btns">
      <li><p class="btn_blue2 big"><a href="#" onclick="javascript:fn_openReport()"><spring:message code='service.btn.Generate' /></a></p></li>
      <li><p class="btn_blue2 big"><a href="#" onclick="javascript:fn_clear()"><spring:message code='service.btn.Clear' /></a></p></li>
    </ul>
  </section>
  <!-- pop_body end -->
</div>
<!-- popup_wrap end -->
