<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<!--
 DATE        BY     VERSION        REMARK
 ----------------------------------------------------------------
 26/04/2019  ONGHC  1.0.0          ADD RECALL STATUS
 -->

<script type="text/javaScript">
  $(document).ready(
    function() {
      $('.multy_select').on("change", function() {
      }).multipleSelect({});

      doGetComboSepa("/common/selectBranchCodeList.do", '1', '-', '', 'branch', 'S', '');
      $('#sheetType').multipleSelect("checkAll");
    });

  function fn_validation() {
    if ($("#sheetType").val() == '') {
      var text = "<spring:message code='service.grid.Type' />";
      Common.alert("* <spring:message code='sys.msg.necessary' arguments='"+ text + "' htmlEscape='false'/>");
      return false;
    }
    if ($("#reqDtFr").val() != '' || $("#reqDtTo").val() != '') {
      if ($("#reqDtFr").val() == '' || $("#reqDtTo").val() == '') {
        var text = "<spring:message code='service.grid.ReqstDt' />";
        Common.alert("* <spring:message code='sys.msg.necessary' arguments='"+ text + "' htmlEscape='false'/>");
        return false;
      }
    }
    if ($("#settleDtFr").val() != '' || $("#settleDtTo").val() != '') {
      if ($("#settleDtFr").val() == '' || $("#settleDtTo").val() == '') {
        var text = "<spring:message code='service.grid.SettleDate' />";
        Common.alert("* <spring:message code='sys.msg.necessary' arguments='"+ text + "' htmlEscape='false'/>");
        return false;
      }
    }
    return true;
  }

  function fn_openGenerate() {
    var date = new Date();
    var month = date.getMonth() + 1;
    var day = date.getDate();
    if (date.getDate() < 10) {
      day = "0" + date.getDate();
    }
    if (fn_validation()) {
      var YS = 0;
      var nonYS = 0;
      var setDateFrom = "01/01/1900";
      var setDateTo = "01/01/1900";
      var reqDateFrom = "01/01/1900";
      var reqDateTo = "01/01/1900";
      var branchID = "0";
      var YSAging = 0;

      if ($("#sheetType").val() == '1') {
        YS = 1;
      } else if ($("#sheetType").val() == '2') {
        nonYS = 1;
      } else {
        YS = 1;
        nonYS = 1;
      }

      if ($("#settleDtFr").val() != '' && $("#settleDtTo").val() != ''
          && $("#settleDtFr").val() != null
          && $("#settleDtTo").val() != null) {
        setDateFrom = $("#settleDtFr").val().substring(6, 10) + "-"
            + $("#settleDtFr").val().substring(3, 5) + "-"
            + $("#settleDtFr").val().substring(0, 2);
        setDateTo = $("#settleDtTo").val().substring(6, 10) + "-"
            + $("#settleDtTo").val().substring(3, 5) + "-"
            + $("#settleDtTo").val().substring(0, 2);
      }
      if ($("#reqDtFr").val() != '' && $("#reqDtTo").val() != ''
          && $("#reqDtFr").val() != null
          && $("#reqDtTo").val() != null) {
        reqDateFrom = $("#reqDtFr").val().substring(6, 10) + "-"
            + $("#reqDtFr").val().substring(3, 5) + "-"
            + $("#reqDtFr").val().substring(0, 2);
        reqDateTo = $("#reqDtTo").val().substring(6, 10) + "-"
            + $("#reqDtTo").val().substring(3, 5) + "-"
            + $("#reqDtTo").val().substring(0, 2);
      }
      if ($("#branch").val() != '' && $("#branch").val() != null) {
        branchID = $("#branch").val();
      }
      if ($("#aging").val() != '' && $("#aging").val() != null) {
        YSAging = $("#aging").val();
      }

      // SP_CR_GEN_YEL_SHT_AS_HC
      $("#reportFormYS #V_YS").val(YS);
      $("#reportFormYS #V_NONYS").val(nonYS);
      $("#reportFormYS #V_SETDATEFROM").val(setDateFrom);
      $("#reportFormYS #V_SETDATETO").val(setDateTo);
      $("#reportFormYS #V_REQDATEFROM").val(reqDateFrom);
      $("#reportFormYS #V_REQDATETO").val(reqDateTo);
      $("#reportFormYS #V_BRANCHID").val(branchID);
      $("#reportFormYS #V_YSAGING").val(YSAging);
      $("#reportFormYS #reportFileName").val('/homecare/hcASYellowSheet.rpt');
      $("#reportFormYS #viewType").val("PDF");
      $("#reportFormYS #reportDownFileName").val(
          "ASYellowSheet_" + day + month + date.getFullYear());

      var option = {
        isProcedure : true, // procedure 로 구성된 리포트 인경우 필수.
      };

      Common.report("reportFormYS", option);

    }
  }

  function fn_openExcel() {
    var date = new Date();
    var month = date.getMonth() + 1;
    var day = date.getDate();
    if (date.getDate() < 10) {
      day = "0" + date.getDate();
    }
    if (fn_validation) {
      var YS = 0;
      var nonYS = 0;
      var setDateFrom = "01/01/1900";
      var setDateTo = "01/01/1900";
      var reqDateFrom = "01/01/1900";
      var reqDateTo = "01/01/1900";
      var branchID = "0";
      var YSAging = 0;

      if ($("#sheetType").val() == '1') {
        YS = 1;
      } else {
        nonYS = 1;
      }

      if ($("#settleDtFr").val() != '' && $("#settleDtTo").val() != ''
          && $("#settleDtFr").val() != null
          && $("#settleDtTo").val() != null) {
        setDateFrom = $("#settleDtFr").val().substring(6, 10) + "-"
            + $("#settleDtFr").val().substring(3, 5) + "-"
            + $("#settleDtFr").val().substring(0, 2);
        setDateTo = $("#settleDtTo").val().substring(6, 10) + "-"
            + $("#settleDtTo").val().substring(3, 5) + "-"
            + $("#settleDtTo").val().substring(0, 2);
      }
      if ($("#reqDtFr").val() != '' && $("#reqDtTo").val() != ''
          && $("#reqDtFr").val() != null
          && $("#reqDtTo").val() != null) {
        reqDateFrom = $("#reqDtFr").val().substring(6, 10) + "-"
            + $("#reqDtFr").val().substring(3, 5) + "-"
            + $("#reqDtFr").val().substring(0, 2);
        reqDateTo = $("#reqDtTo").val().substring(6, 10) + "-"
            + $("#reqDtTo").val().substring(3, 5) + "-"
            + $("#reqDtTo").val().substring(0, 2);
      }
      if ($("#branch").val() != '' && $("#branch").val() != null) {
        branchID = $("#branch").val();
      }
      if ($("#aging").val() != '' && $("#aging").val() != null) {
        YSAging = $("#aging").val();
      }

      $("#reportFormYS #V_YS").val(YS);
      $("#reportFormYS #V_NONYS").val(nonYS);
      $("#reportFormYS #V_SETDATEFROM").val(setDateFrom);
      $("#reportFormYS #V_SETDATETO").val(setDateTo);
      $("#reportFormYS #V_REQDATEFROM").val(reqDateFrom);
      $("#reportFormYS #V_REQDATETO").val(reqDateTo);
      $("#reportFormYS #V_BRANCHID").val(branchID);
      $("#reportFormYS #V_YSAGING").val(YSAging);
      $("#reportFormYS #reportFileName").val('/services/ASYellowSheet_RawData.rpt');
      $("#reportFormYS #viewType").val("EXCEL");
      $("#reportFormYS #reportDownFileName").val("ASYellowSheet_" + day + month + date.getFullYear());

      var option = {
        isProcedure : true, // procedure 로 구성된 리포트 인경우 필수.
      };

      Common.report("reportFormYS", option);
    }
  }

  $.fn.clearForm = function() {
    return this.each(function() {
      var type = this.type, tag = this.tagName.toLowerCase();
      if (tag === 'form') {
        return $(':input', this).clearForm();
      }
      if (type === 'text' || type === 'password' || type === 'hidden'
          || tag === 'textarea') {
        this.value = '';
      } else if (type === 'checkbox' || type === 'radio') {
        this.checked = false;
      } else if (tag === 'select') {
        this.selectedIndex = 0;
      }
      $('#sheetType').multipleSelect("checkAll");

    });
  };
</script>
<div id="popup_wrap" class="popup_wrap">
 <!-- popup_wrap start -->
 <header class="pop_header">
  <!-- pop_header start -->
  <h1><spring:message code='service.btn.asYsLst'/></h1>
  <ul class="right_opt">
   <li><p class="btn_blue2">
     <a href="#none"><spring:message code='sys.btn.close' /></a>
    </p></li>
  </ul>
 </header>
 <!-- pop_header end -->
 <section class="pop_body">
  <!-- pop_body start -->
  <section class="search_table">
   <!-- search_table start -->
   <form action="#" id="reportFormYS">
    <!--reportFileName,  viewType 모든 레포트 필수값 -->
    <input type="hidden" id="V_YS" name="V_YS" /> <input type="hidden"
     id="V_NONYS" name="V_NONYS" /> <input type="hidden"
     id="V_SETDATEFROM" name="V_SETDATEFROM" /> <input type="hidden"
     id="V_SETDATETO" name="V_SETDATETO" /> <input type="hidden"
     id="V_REQDATEFROM" name="V_REQDATEFROM" /> <input type="hidden"
     id="V_REQDATETO" name="V_REQDATETO" /> <input type="hidden"
     id="V_BRANCHID" name="V_BRANCHID" /> <input type="hidden"
     id="V_YSAGING" name="V_YSAGING" /> <input type="hidden"
     id="reportFileName" name="reportFileName" /> <input type="hidden"
     id="viewType" name="viewType" /> <input type="hidden"
     id="reportDownFileName" name="reportDownFileName"
     value="DOWN_FILE_NAME" />
    <table class="type1">
     <!-- table start -->
     <caption>table</caption>
     <colgroup>
      <col style="width: 150px" />
      <col style="width: *" />
      <col style="width: 150px" />
      <col style="width: *" />
     </colgroup>
     <tbody>
      <tr>
       <th scope="row"><spring:message code='service.title.Type' /></th>
       <td><select class="multy_select" id="sheetType" name="sheetType" class='w100p'>
         <c:forEach var="list" items="${asYsTyp}" varStatus="status">
           <option value="${list.codeId}" selected>${list.codeName}</option>
         </c:forEach>
       </select></td>
       <th scope="row"><spring:message code='sal.text.ysAging' /><span class='must'>*</span></th>
       <td><select id="aging" name="aging" class='w100p'>
         <option value=""><spring:message code='sal.combo.text.chooseOne' /></option>
         <c:forEach var="list" items="${asYsAge}" varStatus="status">
           <option value="${list.codeId}">${list.codeName}</option>
         </c:forEach>
       </select></td>
      </tr>
      <tr>
       <th scope="row"><spring:message code='service.grid.SettleDate' /></th>
       <td>
        <div class="date_set">
         <!-- date_set start -->
         <p>
          <input type="text" title="Create start Date"
           placeholder="DD/MM/YYYY" class="j_dateHc" id="settleDtFr"
           name="settleDtFr" />
         </p>
         <span>To</span>
         <p>
          <input type="text" title="Create end Date"
           placeholder="DD/MM/YYYY" class="j_dateHc" id="settleDtTo"
           name="settleDtTo" />
         </p>
        </div>
        <!-- date_set end -->
       </td>
       <th scope="row"><spring:message code='service.grid.ReqstDt' /></th>
       <td>
        <div class="date_set">
         <!-- date_set start -->
         <p>
          <input type="text" title="Create start Date"
           placeholder="DD/MM/YYYY" class="j_dateHc" id="reqDtFr"
           name="reqDtFr" />
         </p>
         <span>To</span>
         <p>
          <input type="text" title="Create end Date"
           placeholder="DD/MM/YYYY" class="j_dateHc" id="reqDtTo"
           name="reqDtTo" />
         </p>
        </div>
        <!-- date_set end -->
       </td>
      </tr>
      <tr>
       <th scope="row"><spring:message code='home.lbl.hdcBranch' /></th>
       <td colspan="3"><select id="branch">
       </select></td>
      </tr>
      <tr>
       <td colspan="4">
        <p>
         <span style='color:red;font-weight:bold'>(*) Only generate YS list if this field selected.</span>
        </p>
       </td>
      </tr>
     </tbody>
    </table>
    <!-- table end -->
   </form>
  </section>
  <!-- search_table end -->
  <ul class="center_btns">
   <li><p class="btn_blue2 big">
     <a href="#none" onclick="javascript:fn_openGenerate()"><spring:message code='service.btn.Generate' /></a>
    </p></li>
   <li><p class="btn_blue2 big">
     <a href="#none" onclick="javascript:fn_openExcel()"><spring:message code='sys.btn.excel' /></a>
    </p></li>
   <li><p class="btn_blue2 big">
     <a href="#none" onclick="javascript:$('#reportFormYS').clearForm();"><spring:message code='service.btn.Clear' /></a>
    </p></li>
  </ul>
 </section>
 <!-- pop_body end -->
</div>
<!-- popup_wrap end -->