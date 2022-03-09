<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">
today = "${today}";
  $(document).ready(

  )

  function fn_validation() {

    if (($("#orderDateFrom").val() == '' || $("#orderDateTo").val() == '') /* && $("#reportType").val() == '3' */) {
        Common.alert("<spring:message code='sys.common.alert.validation' arguments='Order date (From & To)' htmlEscape='false'/>");
        return false;
    }

    if ($("#orderDateFrom").val() != '' && $("#orderDateTo").val() == '') {
        Common.alert("<spring:message code='sys.common.alert.validation' arguments='Order date (To)' htmlEscape='false'/>");
        return false;
    }
    if ($("#orderDateFrom").val() == '' && $("#orderDateTo").val() != '') {
        Common.alert("<spring:message code='sys.common.alert.validation' arguments='Order date (From)' htmlEscape='false'/>");
        return false;
    }

    return true;
  }

  function fn_openGenerate() {
    if (fn_validation()) {
      var V_WHEREORDERDTFR = "";
      var V_WHEREORDERDTTO = "";

      if ($("#orderDateFrom").val() != '' && $("#orderDateFrom").val() != null && $("#orderDateTo").val() != '' && $("#orderDateTo").val() != null ) {

          V_WHEREORDERDTFR += $("#orderDateFrom").val();

          V_WHEREORDERDTTO += $("#orderDateTo").val();
      }

          var date = new Date();
          var month = date.getMonth() + 1;
          var day = date.getDate();
          if (date.getDate() < 10) {
            day = "0" + date.getDate();
          }

          //SP_CR_GEN_EZY_CCP_RAW
          $("#reportForm1").append('<input type="hidden" id="V_WHEREORDERDTFR" name="V_WHEREORDERDTFR"  /> ');
          $("#reportForm1").append('<input type="hidden" id="V_WHEREORDERDTTO" name="V_WHEREORDERDTTO"  /> ');

          var option = {
            isProcedure : true, // procedure 로 구성된 리포트 인경우 필수.
          };

          $("#reportForm1 #V_WHEREORDERDTFR").val(V_WHEREORDERDTFR);
          $("#reportForm1 #V_WHEREORDERDTTO").val(V_WHEREORDERDTTO);
          $("#reportForm1 #reportFileName").val('/sales/ezyCCPListing_Excel.rpt');
          $("#reportForm1 #reportDownFileName").val("ezyCCPListing_" + day + month + date.getFullYear());
          $("#reportForm1 #viewType").val("EXCEL");

          Common.report("reportForm1", option);
    }
  }

  $.fn.clearForm = function() {
    return this.each(function() {
      var type = this.type, tag = this.tagName.toLowerCase(); identifier = this.id;
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

      $("#reportForm1 .tr_toggle_display").hide();

    });
  };
</script>
<div id="popup_wrap" class="popup_wrap">
 <!-- popup_wrap start -->
 <header class="pop_header">
  <!-- pop_header start -->
  <h1>Ezy Listing</h1>
  <ul class="right_opt">
   <li><p class="btn_blue2">
     <a href="#">CLOSE</a>
    </p></li>
  </ul>
 </header>
 <!-- pop_header end -->
 <section class="pop_body">
  <!-- pop_body start -->
  <section class="search_table">
   <!-- search_table start -->
   <form action="#" id="reportForm1">
    <!--reportFileName,  viewType 모든 레포트 필수값 -->
    <input type="hidden" id="reportFileName" name="reportFileName" />
    <input type="hidden" id="viewType" name="viewType" />
    <input type="hidden" id="reportDownFileName" name="reportDownFileName" value="DOWN_FILE_NAME" />
    <table class="type1">
     <!-- table start -->
     <caption>table</caption>
     <colgroup>
      <col style="width: 130px" />
      <col style="width: *" />
      <col style="width: 130px" />
      <col style="width: *" />
     </colgroup>
     <tbody>
      <tr>
        <th scope="row">
            <spring:message code='sales.ordDt' />
       </th>
       <td>
          <div class="date_set w100p">
             <p><input type="text" title="Create start Date" id='orderDateFrom' name='orderDateFrom'
                     placeholder="DD/MM/YYYY" class="j_date" /></p>
             <span><spring:message code='pay.text.to' /></span>
            <p><input type="text" title="Create end Date" id='orderDateTo' name='orderDateTo'
                     placeholder="DD/MM/YYYY" class="j_date" /></p>
           </div>
       </td>
     </tbody>
    </table>
    <!-- table end -->
   </form>
  </section>
  <!-- search_table end -->
  <ul class="center_btns">
   <li><p class="btn_blue2 big">
     <a href="#" onclick="javascript:fn_openGenerate()">Generate</a>
    </p></li>
   <li><p class="btn_blue2 big">
     <a href="#" onclick="$('#reportForm1').clearForm();">Clear</a>
    </p></li>
  </ul>
 </section>
 <!-- pop_body end -->
</div>
<!-- popup_wrap end -->

