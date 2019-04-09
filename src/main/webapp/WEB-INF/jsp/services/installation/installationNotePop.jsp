<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<!--
 DATE        BY     VERSION        REMARK
 ----------------------------------------------------------------
 09/04/2019  ONGHC  1.0.0          RE-STRUCTURE JSP.
 -->
 
<script type="text/javaScript">
  $(document).ready(
    function() {
      $('.multy_select').on("change", function() {
      }).multipleSelect({});

      doGetCombo('/common/selectCodeList.do', '10', '', 'appliType', 'S', '');
      doGetComboSepa("/common/selectBranchCodeList.do", 5, '-', '', 'branch', 'S', '');
    });

  function fn_validation() {
    var msg = "";

    // INSTALLATION TYPE
    if ($("#instalType option:selected").length < 1) {
      msg += "* <spring:message code='sys.msg.necessary' arguments='Installation Type' htmlEscape='false'/> </br>";
    }
    // INSTALL DATE FROM
    if ($("#instalDtFrom").val() == '') {
      msg += "* <spring:message code='sys.msg.necessary' arguments='Installation Date (From)' htmlEscape='false'/> </br>";
    }
    // INSTALL DATE TO
    if ($("#instalDtFrom").val() == '') {
      msg += "* <spring:message code='sys.msg.necessary' arguments='Installation Date (To)' htmlEscape='false'/> </br>";
    }
    // INSTALL STATUS
    if ($("#instalStatus").val() == '') {
      msg += "* <spring:message code='sys.msg.necessary' arguments='Install Status' htmlEscape='false'/> </br>";
    }

    if (msg != '') {
      Common.alert(msg);
      return false;
    }

    msg = "";

    if ($("#orderNoFrom").val() != '' || $("#orderNoTo").val() != '') {
      if ($("#orderNoFrom").val() == '' || $("#orderNoTo").val() == '') {
        msg += "* <spring:message code='sys.common.alert.validation' arguments='Order Number (From & To)' htmlEscape='false'/> ";
      }
    }

    if ($("#instalNoFrom").val() != '' || $("#instalNoTo").val() != '') {
      if ($("#instalNoFrom").val() == '' || $("#instalNoTo").val() == '') {
        msg += "* <spring:message code='sys.common.alert.validation' arguments='Installation Number (From & To)' htmlEscape='false'/> ";
      }
    }

    if ($("#instalDtFrom").val() != '' || $("#instalDtTo").val() != '') {
      if ($("#instalDtFrom").val() == '' || $("#instalDtTo").val() == '') {
        msg += "* <spring:message code='sys.common.alert.validation' arguments='Install Date (From & To)' htmlEscape='false'/>";
      }
    }

    if ($("#CTCodeFrom").val() != '' || $("#CTCodeTo").val() != '') {
      if ($("#CTCodeFrom").val() == '' || $("#CTCodeTo").val() == '') {
        msg += "* <spring:message code='sys.common.alert.validation' arguments='CT code (From & To)' htmlEscape='false'/>";
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
      var installStatus = $("#instalStatus").val();
      var SelectSql = "";
      var whereSeq = "";
      var whereSeq2 = "";
      var orderBySql = "";
      var FullSql = "";
      var month = date.getMonth() + 1;
      var day = date.getDate();

      if (date.getDate() < 10) {
        day = "0" + date.getDate();
      }

      if ($("#instalStatus").val() != '' && $("#instalStatus").val() != null) {
        whereSeq += "AND B.STUS_CODE_ID = " + $("#instalStatus").val() + " ";
      }

      if ($("#orderNoFrom").val() != '' && $("#orderNoTo").val() != '' && $("#orderNoFrom").val() != null && $("#orderNoTo").val() != null) {
        whereSeq += "AND (A.SALES_ORD_NO >= '" + $("#orderNoFrom").val() + "' AND A.SALES_ORD_NO <='" + $("#orderNoTo").val() + "') ";
      }

      if ($("#instalDtFrom").val() != '' && $("#instalDtTo").val() != '' && $("#instalDtFrom").val() != null && $("#instalDtTo").val() != null) {
        whereSeq += "AND (B.INSTALL_DT >= TO_DATE('" + $("#instalDtFrom").val() + "' , 'DD/MM/YYYY') AND B.INSTALL_DT <= TO_DATE('" + $("#instalDtTo").val() + "', 'DD/MM/YYYY') ) ";
      }

      if ($("#appliType").val() != '' && $("#appliType").val() != null) {
        whereSeq += "AND A.APP_TYPE_ID = " + $("#appliType").val() + " ";
      }

      if ($("#instalNoFrom").val() != '' && $("#instalNoTo").val() != '' && $("#instalNoFrom").val() != null && $("#instalNoTo").val() != null) {
        whereSeq += "AND (B.INSTALL_ENTRY_NO >= '" + $("#instalNoFrom").val() + "' AND B.INSTALL_ENTRY_NO <= '" + $("#instalNoTo").val() + "') ";
      }

      if ($("#CTCodeFrom").val() != '' && $("#CTCodeTo").val() != '' && $("#CTCodeFrom").val() != null && $("#CTCodeTo").val() != null) {
        whereSeq2 += "AND (CTMEM.MEM_CODE >= '" + $("#CTCodeFrom").val() + "' AND CTMEM.MEM_CODE <= '" + $("#CTCodeTo").val() + "') ";
      }

      if ($("#instalType").val() != '' && $("#instalType").val() != null) {
        whereSeq2 += "AND CE.TYPE_ID IN (" + $("#instalType").val() + ") ";
      }

      if ($("#branch").val() != '' && $("#branch").val() != null) {
        whereSeq2 += "AND INSTALL.BRNCH_ID = " + $("#branch").val() + "  ";
      }

      if ($("#sortType").val() == "2") {
        orderBySql = "ORDER BY CTMEM.MEM_CODE ";
      } else {
        orderBySql = "ORDER BY MAIN.INSTALL_ENTRY_ID ";
      }

      $("#installationNoteForm #V_WHERESQL").val(whereSeq);
      $("#installationNoteForm #V_WHERESQL2").val(whereSeq2);
      $("#installationNoteForm #V_INSTALLSTATUS").val(installStatus);
      $("#installationNoteForm #V_ORDERBYSQL").val(orderBySql);
      $("#installationNoteForm #V_SELECTSQL").val(SelectSql);
      $("#installationNoteForm #V_FULLSQL").val(FullSql);
      $("#installationNoteForm #reportFileName").val('/services/InstallationNote_WithOldOrderNo.rpt');
      $("#installationNoteForm #viewType").val("PDF");
      $("#installationNoteForm #reportDownFileName").val("InstallationNote_" + day + month + date.getFullYear());

      var option = {
        isProcedure : true,
      };

      Common.report("installationNoteForm", option);
    }
  }

  function fn_clear() {
    $("#instalStatus").val('');
    $("#orderNoFrom").val('');
    $("#orderNoTo").val('');
    $("#instalDtFrom").val('');
    $("#instalDtTo").val('');
    $("#appliType").val('');
    $("#branch").val('');
    $("#instalNoFrom").val('');
    $("#instalNoTo").val('');
    $("#CTCodeFrom").val('');
    $("#CTCodeTo").val('');
    $("#instalType").val('');
    $("#sortType").val('1');
    $("#V_WHERESQL").val('');
    $("#V_WHERESQL2").val('');
    $("#V_INSTALLSTATUS").val('');
    $("#V_ORDERBYSQL").val('');
    $("#V_SELECTSQL").val('');
    $("#V_FULLSQL").val('');
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
   <li><p class="btn_blue2">
     <a href="#"><spring:message code='expense.CLOSE' /></a>
    </p></li>
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
      <th scope="row"><spring:message code='service.title.InstallationType' /><span name="m1" id="m1" class="must">*</span></th>
      <td><select class="multy_select w100p" multiple="multiple"
       id="instalType" name="instalType">
       <c:forEach var="list" items="${instTypeList}" varStatus="status">
         <option value="${list.codeId}" selected>${list.codeName}</option>
        </c:forEach>
      </select></td>
      <th scope="row"><spring:message
        code='service.title.OrderNumber' /></th>
      <td>
       <div class="date_set">
        <!-- date_set start -->
        <p>
         <input type="text" title="" placeholder="From" class="w100p"
          id="orderNoFrom" name="orderNoFrom" />
        </p>
        <span>To</span>
        <p>
         <input type="text" title="" placeholder="To" class="w100p"
          id="orderNoTo" name="orderNoTo" />
        </p>
       </div>
       <!-- date_set end -->
      </td>
     </tr>
     <tr>
      <th scope="row"><spring:message
        code='service.title.ApplicationType' /></th>
      <td><select id="appliType" name="appType">
      </select></td>
      <th scope="row"><spring:message
        code='service.title.InstallationNo' /></th>
      <td>
       <div class="date_set">
        <!-- date_set start -->
        <p>
         <input type="text" title="" placeholder="From" class="w100p"
          id="instalNoFrom" name="instalNoFrom" />
        </p>
        <span>To</span>
        <p>
         <input type="text" title="" placeholder="To" class="w100p"
          id="instalNoTo" name="instalNoTo" />
        </p>
       </div>
       <!-- date_set end -->
      </td>
     </tr>
     <tr>
      <th scope="row"><spring:message
        code='service.title.InstallDate' /><span name="m2" id="m2" class="must">*</span></th>
      <td>
       <div class="date_set">
        <!-- date_set start -->
        <p>
         <input type="text" title="Create start Date"
          placeholder="DD/MM/YYYY" class="j_date" id="instalDtFrom"
          name="instalDtFrom" />
        </p>
        <span>To</span>
        <p>
         <input type="text" title="Create end Date"
          placeholder="DD/MM/YYYY" class="j_date" id="instalDtTo"
          name="instalDtTo" />
        </p>
       </div>
       <!-- date_set end -->
      </td>
      <th scope="row"><spring:message
        code='service.title.InstallStatus' /> <span name="m3" id="m3" class="must">*</span></th>
      <td><select id="instalStatus" name="instalStatus">
        <option value="">Choose One</option>
        <c:forEach var="list" items="${installStatus }"
         varStatus="status">
         <c:choose>
          <c:when test="${list.codeId=='4'}">
            <option value="${list.codeId}" selected>${list.codeName}</option>
          </c:when>
          <c:otherwise>
            <option value="${list.codeId}">${list.codeName}</option>
          </c:otherwise>
         </c:choose>
        </c:forEach>
      </select></td>
     </tr>
     <tr>
      <th scope="row"><spring:message
        code='service.title.DSCBranch' /></th>
      <td><select id="branch" name="branch">
      </select></td>
      <th scope="row"><spring:message code='service.title.CTCode' /></th>
      <td>
       <div class="date_set">
        <!-- date_set start -->
        <p>
         <input type="text" title="" placeholder="From" class="w100p"
          id="CTCodeFrom" name="CTCodeFrom" />
        </p>
        <span>To</span>
        <p>
         <input type="text" title="" placeholder="To" class="w100p"
          id="CTCodeTo" name="CTCodeTo" />
        </p>
       </div>
       <!-- date_set end -->
      </td>
     </tr>
     <tr>
      <th scope="row"><spring:message code='service.title.SortBy' /></th>
      <td colspan="3"><select id="sortType" name="sortType">
        <option value="1">Installation Number</option>
        <option value="2">CT Code</option>
      </select></td>
     </tr>
    </tbody>
   </table>
   <!-- table end -->
   <form method="post" id="installationNoteForm"
    name="installationNoteForm">
    <input type="hidden" id="V_WHERESQL" name="V_WHERESQL" />
    <input type="hidden" id="V_WHERESQL2" name="V_WHERESQL2" />
    <input type="hidden" id="V_INSTALLSTATUS" name="V_INSTALLSTATUS" /> <input
     type="hidden" id="V_ORDERBYSQL" name="V_ORDERBYSQL" /> <input
     type="hidden" id="V_SELECTSQL" name="V_SELECTSQL" /> <input
     type="hidden" id="V_FULLSQL" name="V_FULLSQL" />
    <!--reportFileName,  viewType 모든 레포트 필수값 -->
    <input type="hidden" id="reportFileName" name="reportFileName" /> <input
     type="hidden" id="viewType" name="viewType" /> <input
     type="hidden" id="reportDownFileName" name="reportDownFileName"
     value="DOWN_FILE_NAME" />
   </form>
  </section>
  <!-- search_table end -->
  <ul class="center_btns">
   <li><p class="btn_blue2 big">
     <a href="#" onclick="javascript:fn_openReport()"><spring:message
       code='service.btn.Generate' /></a>
    </p></li>
   <li><p class="btn_blue2 big">
     <a href="#" onclick="javascript:fn_clear()"><spring:message
       code='service.btn.Clear' /></a>
    </p></li>
  </ul>
 </section>
 <!-- pop_body end -->
</div>
<!-- popup_wrap end -->
