<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<!--
 DATE        BY     VERSION        REMARK
 ----------------------------------------------------------------
 27/06/2019  ONGHC  1.0.0          CREATE FOR SERVICE ITEM MANEGEMENT
 -->

<script type="text/javaScript">
  $(document).ready( function() {
    doGetCombo('/services/sim/getBchTyp.do', '', '42', 'cboBchTypRaw', 'S', 'fn_onChgBch'); // BRANCH TYPE
    doGetCombo('/services/sim/getItm.do', '', '', 'cboItmPopRaw', 'S', ''); // ITEM TYPE

    // SET TRIGGER FUNCTION HERE --
    $("#cboBchTypRaw").change(function() {
      doGetCombo('/services/sim/getBch.do', $("#cboBchTypRaw").val(), '', 'cboBchPopRaw', 'S', '');
    });

  });

  function fn_onChgBch() {
    $("#cboBchTyp").val('42');
    doGetCombo('/services/sim/getBch.do', $("#cboBchTypRaw").val(), '${SESSION_INFO.userBranchId}', 'cboBchPopRaw', 'S', '');
  }

  function fn_openGenerate() {
    var text = "";

    // CLEAR DATA
    $("#srvItmRawForm #TRX_STR_DT").val("");
    $("#srvItmRawForm #TRX_END_DT").val("");
    $("#srvItmRawForm #BR").val("");
    $("#srvItmRawForm #ITM_CDE").val("");

    // SET DATA
    $("#srvItmRawForm #TRX_STR_DT").val($("#trxStrDt").val());
    $("#srvItmRawForm #TRX_END_DT").val($("#trxEndDt").val());
    $("#srvItmRawForm #BR").val($("#cboBchPopRaw").val());
    $("#srvItmRawForm #ITM_CDE").val($("#cboItmPopRaw").val());

    var brCde = "";
    var itmCde = "";

    if ($("#trxStrDt").val() == "" || $("#trxStrDt").val() == null) {
      text = "<spring:message code='service.grid.trxDttFrm'/>";
      Common.alert("<spring:message code='sys.msg.necessary' arguments='" + text + "' htmlEscape='false'/>");
      return;
    }
    if ($("#trxEndDt").val() == "" || $("#trxEndDt").val() == null) {
      text = "<spring:message code='service.grid.trxDttTo'/>";
      Common.alert("<spring:message code='sys.msg.necessary' arguments='" + text + "' htmlEscape='false'/>");
      return;
    }
    if ($("#cboBchPopRaw").val() != "" || $("#cboBchPopRaw").val() != null) {
      brCde = $("#cboBchPopRaw").val();
    }
    if ($("#cboItmPopRaw").val() != "" || $("#cboItmPopRaw").val() != null) {
      itmCde = $("#cboItmPopRaw").val();
    }

    var whereSql = "WHERE 1=1 ";
    var keyInDateFrom = $("#trxStrDt").val().substring(6, 10) + "-"
                      + $("#trxStrDt").val().substring(3, 5) + "-"
                      + $("#trxStrDt").val().substring(0, 2);
    var keyInDateTo = $("#trxEndDt").val().substring(6, 10) + "-"
                    + $("#trxEndDt").val().substring(3, 5) + "-"
                    + $("#trxEndDt").val().substring(0, 2);

    if (keyInDateFrom !=  "" && keyInDateTo != "") {
      whereSql += " AND (TO_CHAR(B.TRX_DT,'YYYY-MM-DD')) >= '" + keyInDateFrom + "' AND (TO_CHAR(B.TRX_DT,'YYYY-MM-DD')) <= '" + keyInDateTo + "' ";
    }

    if (brCde !=  "") {
       whereSql += " AND A.BR_NO = '" + brCde + "' ";
    }
    if (itmCde !=  "") {
       whereSql += " AND A.ITM_CDE = '" + itmCde + "' ";
    }

    var date = new Date();
    var month = date.getMonth() + 1;
    var day = date.getDate();
    if (date.getDate() < 10) {
      day = "0" + date.getDate();
    }

    $("#srvItmRawForm #V_SELECTSQL").val(" ");
    $("#srvItmRawForm #V_ORDERBYSQL").val(" ");
    $("#srvItmRawForm #V_FULLSQL").val(" ");
    $("#srvItmRawForm #V_WHERESQL").val(whereSql);
    $("#srvItmRawForm #V_TRXSTRDT").val(keyInDateFrom);
    $("#srvItmRawForm #V_TRXENDDT").val(keyInDateTo);
    $("#srvItmRawForm #reportFileName").val('/services/SrvItmRawData.rpt');
    $("#srvItmRawForm #viewType").val($("input[name='fileTypOpt']:checked").val());
    $("#srvItmRawForm #reportDownFileName").val("ServiceItemRaw_" + day + month + date.getFullYear());

    var option = {
      isProcedure : true,
    };

    Common.report("srvItmRawForm", option);
  }

</script>

<div id="popup_wrap" class="popup_wrap">

 <section id="content">

  <form id="srvItmRawForm" method="post">
   <div style="display: none">
    <input type="text" name="TRX_STR_DT" id="TRX_STR_DT" />
    <input type="text" name="TRX_END_DT" id="TRX_END_DT" />
    <input type="text" name="BR" id="BR" />
    <input type="text" name="ITM_CDE" id="ITM_CDE" />
    <!-- REPORT PURPOSE -->
    <input type="text" name="V_SELECTSQL" id="V_SELECTSQL" />
    <input type="text" name="V_WHERESQL" id="V_WHERESQL" />
    <input type="text" name="V_ORDERBYSQL" id="V_ORDERBYSQL" />
    <input type="text" name="V_FULLSQL" id="V_FULLSQL" />
    <input type="text" name="V_TRXSTRDT" id="V_TRXSTRDT" />
    <input type="text" name="V_TRXENDDT" id="V_TRXENDDT" />
    <input type="text" name="reportFileName" id="reportFileName" />
    <input type="text" name="viewType" id="viewType" />
    <input type="text" name="reportDownFileName" id="reportDownFileName" />
   </div>
  </form>

  <header class="pop_header">
   <h1><spring:message code='service.title.srvItmMgmt'/> - <spring:message code='service.title.rawDt'/></h1>
   <ul class="right_opt">
    <li><p class="btn_blue2">
      <a href="#"><spring:message code='sys.btn.close'/></a>
     </p></li>
   </ul>
  </header>

  <section class="pop_body">
    <section class="search_table">
      <form action="#" method="post" id="srvItmEntryForm" onsubmit="return false;">
        <input type="hidden" id="reportFileName" name="reportFileName" />
        <input type="hidden" id="viewType" name="viewType" />
        <input
     type="hidden" id="reportDownFileName" name="reportDownFileName"
     value="DOWN_FILE_NAME" />
        <table class="type1">
        <caption>table</caption>
        <colgroup>
          <col style="width: 150px" />
          <col style="width: *" />
        </colgroup>
        <tbody>
         <tr>
          <th scope="row"><spring:message code='service.grid.trxDt'/><span class="must"> *</span></th>
          <td>
            <div class="date_set w100p">
              <p>
                <input type="text" title="<spring:message code='service.grid.trxDt'/>" placeholder="DD/MM/YYYY" class="j_date" id="trxStrDt" name="trxStrDt" />
              </p>
              <span>To</span>
              <p>
                <input type="text" title="<spring:message code='service.grid.trxDt'/>" placeholder="DD/MM/YYYY" class="j_date" id="trxEndDt" name="trxEndDt" />
              </p>
            </div>
          </td>
         </tr>
         <tr>
           <th scope="row"><spring:message code='service.grid.brchTyp'/></th>
           <td>
            <select id="cboBchTypRaw" name="cboBchTypRaw" class="w100p" disabled />
           </td>
         </tr>
         <tr>
           <th scope="row"><spring:message code='service.grid.bch'/></th>
           <td>
            <select id="cboBchPopRaw" name="cboBchPopRaw" class="w100p" disabled>
              <option value=""><spring:message code='sal.combo.text.chooseOne'/></option>
            </select>
           </td>
         </tr>
         <tr>
           <th scope="row"><spring:message code='sal.title.item'/></th>
           <td>
             <select id="cboItmPopRaw" name="cboItmPopRaw" class="w100p" />
           </td>
         </tr>
         <tr>
           <th scope="row"><spring:message code='service.btn.fileFmt'/></th>
           <td>
             <input type="radio" value="PDF" name="fileTypOpt"> <label for="fileTypOpt">PDF</label>
             <input type="radio" value="EXCEL" name="fileTypOpt" checked> <label for="fileTypOpt">EXCEL</label>
           </td>
         </tr>
      </tbody>
     </table>
      <p class="btn_blue2 big" align="center">
       <a href="#" onclick="fn_openGenerate()"><spring:message code='pay.btn.generate'/></a>
     </p>
     <!-- table end -->
    </form>
   </section>
  </section>
  <!-- content end -->
 </section>
 <!-- content end -->
</div>
<!-- popup_wrap end -->
<script>
</script>