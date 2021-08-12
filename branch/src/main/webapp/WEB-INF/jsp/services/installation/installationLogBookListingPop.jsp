<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<!--
 DATE        BY     VERSION        REMARK
 ----------------------------------------------------------------
 11/10/2019  ONGHC  1.0.0          AMEND NOT USING BETWEEN FOR SEARCH INSTALLATION DATE
 -->
<script type="text/javaScript">
  $(document).ready(
      function() {
        doGetComboSepa("/common/selectBranchCodeList.do", 5, '-', '',
            'branch', 'S', '');
        doGetCombo('/common/selectCodeList.do', '10', '', 'appliType',
            'M', 'f_multiCombo');

        //$("#branch").change(
                //function() {
                  //doGetComboData('/services/as/selectCTByDSC.do', $("#cmbbranchId2").val(), '', 'cmbctId2', 'M', 'fn_multiCombo');
                  //doGetCombo('/services/as/selectCTByDSC.do', $("#branch").val(), '', 'cmbctId2', 'M', 'fn_multiCombo');
                //}); // INCHARGE CT
      });
  function f_multiCombo() {
    $('#appliType').change(function() {
    }).multipleSelect({
      selectAll : true,
      width : '80%'
    });
    $('#appliType').multipleSelect("checkAll");
  }

  //function fn_multiCombo() {
    //$('#cmbctId2').change(function() {
    //}).multipleSelect({
      //selectAll : true, // 전체선택
      //width : '100%'
    //});
  //}

  function fn_validation() {
    var text = "";
    if ($("#strDt").val() != '' || $("#endDt").val() != '') {
      if ($("#strDt").val() == '' || $("#endDt").val() == '') {
        text = "<spring:message code='service.title.AppointmentDate' />";
        Common.alert("<spring:message code='sys.common.alert.validation' arguments='"+ text +"' htmlEscape='false'/>");
        return false;
      }
    } else {
      text = "<spring:message code='service.title.AppointmentDate' />";
      Common.alert("<spring:message code='sys.common.alert.validation' arguments='"+ text +"' htmlEscape='false'/>");
      return false;
    }

    if ($("#CTCodeFr").val() != '' || $("#CTCodeTo").val() != '') {
      if ($("#CTCodeFr").val() == '' || $("#CTCodeTo").val() == '') {
        Common.alert("<spring:message code='sys.common.alert.validation' arguments='assign CT (From & To)' htmlEscape='false'/>");
        return false;
      }
    }
    return true;
  }

  function fn_openReport() {
    if (fn_validation()) {
      var date = new Date();
      var month = date.getMonth() + 1;
      var day = date.getDate();
      if (date.getDate() < 10) {
        day = "0" + date.getDate();
      }
      var showAppDateFrom = "";
      if ($("#strDt").val() != '' && $("#strDt").val() != null) {
        showAppDateFrom = $("#strDt").val();
      }
      var showAppDateTo = "";
      if ($("#endDt").val() != '' && $("#endDt").val() != null) {
        showAppDateTo = $("#endDt").val();
      }
      var showCTCodeFrom = "";
      if ($("#CTCodeFr").val() != '' && $("#CTCodeFr").val() != null) {
        showCTCodeFrom = $("#CTCodeFr").val();
      }
      var showCTCodeTo = "";
      if ($("#CTCodeTo").val() != '' && $("#CTCodeTo").val() != null) {
        showCTCodeTo = $("#CTCodeTo").val();
      }
      var showBranchCode = "";
      if ($("#branch").val() != '' && $("#branch").val() != null) {
        showBranchCode = $("#branch option:selected").text();
      }
      var showCTGroup = "";
      if ($("#group").val() != '' && $("#group").val() != null) {
        showCTGroup = $("#group").val();
      }
      var showSortBy = "";
      if ($("#sortType").val() != '' && $("#sortType").val() != null) {
        showSortBy = $("#sortType").val();
      }
      var whereSql = "";
      if ($("#strDt").val() != '' && $("#endDt").val() != ''
          && $("#strDt").val() != null && $("#endDt").val() != null) {
        whereSql += " AND (ie.Install_DT >= TO_DATE('"
            + $("#strDt").val() + "', 'DD/MM/YYYY') AND ie.Install_DT <= TO_DATE('"
            + $("#endDt").val() + "', 'DD/MM/YYYY') ) ";
      }
      if ($("#CTCodeFr").val() != '' && $("#CTCodeTo").val() != ''
          && $("#CTCodeFr").val() != null
          && $("#CTCodeTo").val() != null) {
        whereSql += " AND (m.mem_code between'" + $("#CTCodeFr").val()
            + "' AND '" + $("#CTCodeTo").val() + "') ";
      }
      if ($("#branch").val() != '' && $("#branch").val() != null) {
        whereSql += " AND i.BRNCH_ID = " + $("#branch").val() + "  ";
      }
      if ($("#group").val() != '' && $("#group").val() != null) {
        whereSql += " AND ie.CT_GRP = " + " '" + $("#group").val()
            + "' " + "  ";
      }
      if ($("#appliType").val() != '' && $("#appliType").val() != null) {
        appType = $("#appliType").val();
        whereSql += " AND som.App_Type_ID IN(" + $("#appliType").val()
            + ") ";
      }

      // Homecare Remove(except)
      whereSql += " AND som.BNDL_ID IS NULL ";

      var orderSql = "";
      if ($("#sortType").val() == "1") {
        orderBySql = " ORDER BY m.mem_code,ie.Install_Entry_No,som.Sales_Ord_No  ";
      } else if (($("#sortType").val() == "2")) {
        orderBySql = " ORDER BY ie.Install_Entry_No,m.mem_code,som.Sales_Ord_No ";
      } else if (($("#sortType").val() == "3")) {
        orderBySql = " ORDER BY m.mem_code,ie.Install_Entry_No ";
      } else {
        orderBySql = " ORDER BY m.mem_code,ie.Install_Entry_No ";
      }

      $("#reportFormIns #V_SHOWAPPDATEFROM").val(showAppDateFrom);
      $("#reportFormIns #V_SHOWAPPDATETO").val(showAppDateTo);
      $("#reportFormIns #V_SHOWCTCODEFROM").val(showCTCodeFrom);
      $("#reportFormIns #V_SHOWCTCODETO").val(showCTCodeTo);
      $("#reportFormIns #V_SHOWBRANCHCODE").val(showBranchCode);
      $("#reportFormIns #V_SHOWCTGROUP").val(showCTGroup);
      $("#reportFormIns #V_SHOWSORTBY").val(showSortBy);
      $("#reportFormIns #V_WHERESQL").val(whereSql);
      $("#reportFormIns #V_ORDERSQL").val(orderBySql);
      $("#reportFormIns #reportFileName").val(
          '/services/InstallationLogBookList.rpt');
      $("#reportFormIns #viewType").val("PDF");
      $("#reportFormIns #reportDownFileName").val(
          "InstallationLogBook_" + day + month + date.getFullYear());

      var option = {
        isProcedure : true, // procedure 로 구성된 리포트 인경우 필수.
      };

      Common.report("reportFormIns", option);

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
        this.selectedIndex = -1;
        f_multiCombo();
      }
    });
  };
</script>
<div id="popup_wrap" class="popup_wrap">
 <!-- popup_wrap start -->
 <header class="pop_header">
  <!-- pop_header start -->
  <h1>
   <spring:message code='service.btn.InstallationLogBookListing' />
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
   <form action="#" method="post" id="reportFormIns">
    <input type="hidden" id="V_SHOWAPPDATEFROM" name="V_SHOWAPPDATEFROM" />
    <input type="hidden" id="V_SHOWAPPDATETO" name="V_SHOWAPPDATETO" />
    <input type="hidden" id="V_SHOWCTCODEFROM" name="V_SHOWCTCODEFROM" />
    <input type="hidden" id="V_SHOWCTCODETO" name="V_SHOWCTCODETO" />
    <input type="hidden" id="V_SHOWBRANCHCODE" name="V_SHOWBRANCHCODE" />
    <input type="hidden" id="V_SHOWCTGROUP" name="V_SHOWCTGROUP" />
    <input type="hidden" id="V_SHOWSORTBY" name="V_SHOWSORTBY" />
    <input type="hidden" id="V_WHERESQL" name="V_WHERESQL" />
    <input type="hidden" id="V_ORDERSQL" name="V_ORDERSQL" />
    <!--reportFileName,  viewType 모든 레포트 필수값 -->
    <input type="hidden" id="reportFileName" name="reportFileName" /> <input
     type="hidden" id="viewType" name="viewType" /> <input
     type="hidden" id="reportDownFileName" name="reportDownFileName"
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
       <th scope="row"><spring:message
         code='service.title.AppointmentDate' /><span class="must">*</span></th>
       <td>
        <div class="date_set">
         <!-- date_set start -->
         <p>
          <input type="text" title="Create start Date"
           placeholder="DD/MM/YYYY" class="j_date" id="strDt"
           name="strDt" />
         </p>
         <span>To</span>
         <p>
          <input type="text" title="Create end Date"
           placeholder="DD/MM/YYYY" class="j_date" id="endDt"
           name="endDt" />
         </p>
        </div>
        <!-- date_set end -->
       </td>
       <th scope="row"><spring:message
         code='service.title.ApplicationType' /></th>
       <td><select class="w100p multy_select" multiple="multiple"
        id="appliType" name="appliType">
       </select></td>
      </tr>
      <tr>
       <th scope="row"><spring:message
         code='service.title.DSCBranch' /></th>
       <td><select id="branch" name="branch" class="w100p"></select></td>
        <th scope="row"><spring:message code='service.title.CTCode' /></th>
       <td>
        <div class="date_set">

         <p>
          <input type="text" title="" placeholder="" class="w100p"
           id="CTCodeFr" name="CTCodeFr" />
         </p>
         <span>To</span>
         <p>
          <input type="text" title="" placeholder="" class="w100p"
           id="CTCodeTo" name="CTCodeTo" />
         </p>
        </div>
       </td>
       <!--<th scope="row"><spring:message code='service.grid.CTCode' /></th>
       <td><select id="cmbctId2" name="cmbctId2" class="multy_select w100p" multiple="multiple">
       </select></td> -->
      </tr>
      <tr>
       <th scope="row"><spring:message code='service.title.CTGroup' /></th>
       <td><select id="group" name="group" class="w100p">
         <option value=""><spring:message code='sal.combo.text.chooseOne'/></option>
         <option value="A">A</option>
         <option value="B">B</option>
         <option value="C">C</option>
       </select></td>
       <th scope="row"><spring:message code='service.title.SortBy' /></th>
       <td><select id="sortType" name="sortType" class="w100p">
         <option value=""><spring:message code='sal.combo.text.chooseOne'/></option>
         <option value="1">CT Code</option>
         <option value="2">Install Number</option>
         <option value="3">Order Number</option>
       </select></td>
      </tr>
     </tbody>
    </table>
    <!-- table end -->
    <ul class="center_btns">
     <li><p class="btn_blue2 big">
       <a href="#" onclick="javascript:fn_openReport()"><spring:message
         code='service.btn.Generate' /></a>
      </p></li>
     <li><p class="btn_blue2 big">
       <a href="#" onclick="javascript:$('#reportFormIns').clearForm();"><spring:message
         code='service.btn.Clear' /></a>
      </p></li>
    </ul>
   </form>
  </section>
  <!-- search_table end -->
 </section>
 <!-- pop_body end -->
</div>
<!-- popup_wrap end -->
