<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<!--
 DATE        BY     VERSION        REMARK
 ----------------------------------------------------------------
 08/02/2019  ONGHC  1.0.0          RE-STRUCTURE JSP.
 07/10/2019  ONGHC  1.0.1          AMEND CONDITION OF ORDER START AND END DATE
 -->

<script type="text/javaScript">
  $(document).ready(
      function() {
        doGetCombo('/common/selectCodeList.do', '10', '', 'appliType', 'M', 'f_multiCombo');
        $('#orderStrDt').val($.datepicker.formatDate('01/mm/yy', new Date()));
        $('#orderEndDt').val($.datepicker.formatDate('dd/mm/yy', new Date()));
      });

  function f_multiCombo() {
    $('#appliType').change(function() {
    }).multipleSelect({
      selectAll : true,
      width : '80%'
    });
  }

  function fn_validation() {
    if ($("#orderStrDt").val() == '' || $("#orderEndDt").val() == '') {
      Common.alert("<spring:message code='sys.common.alert.validation' arguments='Order date (From & To)' htmlEscape='false'/>");
      return false;
    }
    return true;
  }

  function fn_openReport() {
    if (fn_validation()) {
      var whereSql = "";
      var date = new Date();
      var month = date.getMonth() + 1;
      var day = date.getDate();

      if (date.getDate() < 10) {
        day = "0" + date.getDate();
      }

      if ($("#orderStrDt").val() != ''
          && $("#orderEndDt").val() != ''
          && $("#orderStrDt").val() != null
          && $("#orderEndDt").val() != null) {

        whereSql += " AND TO_DATE(A.SALES_DT) >= TO_DATE('" + $("#orderStrDt").val() + "', 'DD/MM/YYYY') "
                  + " AND TO_DATE(A.SALES_DT) <= TO_DATE('" + $("#orderEndDt").val() + "', 'DD/MM/YYYY') ";

      } else {
        whereSql += "AND TO_DATE(A.SALES_DT) >= TO_DATE(ADD_MONTHS(FN_GET_FIRST_DAY_MONTH(SYSDATE), -2))";
      }

      if ($("#pvMonth").val() != '' && $("#pvMonth").val() != null) {
        whereSql += "AND A.PV_MONTH = '"
                 + $("#pvMonth").val().substring(0, 2)
                 + "' AND A.PV_YEAR = '"
                 + $("#pvMonth").val().substring(3, 7) + "' ";
      }

      if ($("#appliType").val() != '' && $("#appliType").val() != null) {
        whereSql += " AND A.APP_TYPE_ID In (" + $("#appliType").val() + ") ";
      }

      // HomeCare add
      whereSql += " AND A.BNDL_ID IS NOT NULL ";
      //console.log("w " + whereSql);

      //SP_CR_GEN_INS_ACC_RAWDATA_EXCEL
      $("#installationRawDataForm #V_WHERESQL").val(whereSql);
      $("#installationRawDataForm #V_SELECTSQL").val('');
      $("#installationRawDataForm #V_WHERESQL_2").val('');
      $("#installationRawDataForm #reportFileName").val('/services/InstallationAccessoriesRawData_Excel.rpt');
      $("#installationRawDataForm #viewType").val("EXCEL");
      $("#installationRawDataForm #reportDownFileName").val("InstallationAccessoriesRawData_" + day + month + date.getFullYear());

      var option = {
        isProcedure : true, // procedure 로 구성된 리포트 인경우 필수.
      };

      Common.report("installationRawDataForm", option);
    }

  }
  $.fn.clearForm = function() {
    return this.each(function() {
      var type = this.type, tag = this.tagName.toLowerCase();
      if (tag === 'form') {
        return $(':input', this).clearForm();
      }

      if (type === 'text' || type === 'password' || type === 'hidden' || tag === 'textarea') {
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
   <spring:message code='service.btn.InstallationAccRawData' />
  </h1>
  <ul class="right_opt">
   <li><p class="btn_blue2">
     <a href="#none"><spring:message code='expense.CLOSE' /></a>
    </p></li>
  </ul>
 </header>
 <!-- pop_header end -->
 <section class="pop_body">
  <!-- pop_body start -->
  <section class="search_table">
   <!-- search_table start -->
   <form action="#" method="post" id="installationRawDataForm">
    <input type="hidden" id="V_WHERESQL" name="V_WHERESQL" /> <input
     type="hidden" id="V_SELECTSQL" name="V_SELECTSQL" />
    <input type="hidden" id="V_WHERESQL_2" name="V_WHERESQL_2" />
    <!--reportFileName,  viewType 모든 레포트 필수값 -->
    <input type="hidden" id="reportFileName" name="reportFileName" /> <input
     type="hidden" id="viewType" name="viewType" /> <input
     type="hidden" id="reportDownFileName" name="reportDownFileName"
     value="DOWN_FILE_NAME" />
    <table class="type1">
     <!-- table start -->
     <caption>table</caption>
     <colgroup>
      <col style="width: 180px" />
      <col style="width: *" />
     </colgroup>
     <tbody>
      <tr>
       <th scope="row"><spring:message
         code='service.title.OrderDate' /> <span class="must">*</span></th>
       <td>
        <div class="date_set">
         <!-- date_set start -->
         <p>
          <input type="text" title="Create start Date"
           placeholder="DD/MM/YYYY" class="j_date" id="orderStrDt"
           name="orderStrDt" />
         </p>
         <span>To</span>
         <p>
          <input type="text" title="Create end Date"
           placeholder="DD/MM/YYYY" class="j_date" id="orderEndDt"
           name="orderEndDt" />
         </p>
        </div>
        <!-- date_set end -->
       </td>
      </tr>
      <tr>
       <th scope="row"><spring:message
         code='service.title.ApplicationType' /></th>
       <td><select class="multy_select" multiple="multiple"
        id="appliType" name="appliType">
       </select></td>
      </tr>
      <tr>
       <th scope="row"><spring:message
         code='service.title.PVMonth_PVYear' /></th>
       <td><input type="text" title="" class="j_date2"
        id="pvMonth" name="pvMonth" /></td>
      </tr>
     </tbody>
    </table>
    <!-- table end -->
   </form>
  </section>
  <!-- search_table end -->
  <ul class="center_btns">
   <li><p class="btn_blue2 big">
     <a href="#none" onclick="javascript:fn_openReport()"><spring:message
       code='service.btn.Generate' /></a>
    </p></li>
   <li><p class="btn_blue2 big">
     <a href="#none"
      onclick="javascript:$('#installationRawDataForm').clearForm();"><spring:message
       code='service.btn.Clear' /></a>
    </p></li>
  </ul>
  <div id="list_grid_wrap123"
   style="width: 100%; height: 200px; margin: 0 auto;"></div>
 </section>
 <!-- pop_body end -->
</div>
<!-- popup_wrap end -->
