<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<!--
 DATE        BY     VERSION        REMARK
 ----------------------------------------------------------------
 15/04/2019  ONGHC  1.0.0          RE-STRUCTURE JSP and Add Order Number Search Criteria
 -->

<script type="text/javaScript">
  $(document).ready(
      function() {
        $('.multy_select').on("change", function() {
        }).multipleSelect({});

        doGetCombo('/services/as/report/selectMemberCodeList.do', '',
            '', 'CTCode', 'S', '');
        doGetComboSepa("/common/selectBranchCodeList.do", 5, '-', '',
            'branch', 'S', '');
      });

  function fn_validation() {
    if ($("#asType").val() == '') {
      Common.alert("<spring:message code='sys.common.alert.validation' arguments='AS type' htmlEscape='false'/>");
      return false;
    }

    if ($("#ordNumFr").val() != '' || $("#ordNumTo").val() != '') {
      if ($("#ordNumFr").val() == '' || $("#ordNumTo").val() == '') {
        Common.alert("<spring:message code='sys.common.alert.validation' arguments='Order number (From & To)' htmlEscape='false'/>");
        return false;
      }
    }

    if ($("#asNumFr").val() != '' || $("#asNumTo").val() != '') {
      if ($("#asNumFr").val() == '' || $("#asNumTo").val() == '') {
        Common.alert("<spring:message code='sys.common.alert.validation' arguments='AS number (From & To)' htmlEscape='false'/>");
        return false;
      }
    }

    if ($("#reqDtFr").val() != '' || $("#reqDtTo").val() != '') {
      if ($("#reqDtFr").val() == '' || $("#reqDtTo").val() == '') {
        Common.alert("<spring:message code='sys.common.alert.validation' arguments='request date (From & To)' htmlEscape='false'/>");
        return false;
      }
    }
    if ($("#asResultNoFr").val() != '' || $("#asResultNoTo").val() != '') {
      if ($("#asResultNoFr").val() == '' || $("#asResultNoTo").val() == '') {
        Common.alert("<spring:message code='sys.common.alert.validation' arguments='result number (From & To)' htmlEscape='false'/>");
        return false;
      }
    }
    if ($("#appDtFr").val() != '' || $("#appDtTo2").val() != '') {
      if ($("#appDtFr").val() == '' || $("#appDtTo2").val() == '') {
        Common.alert("<spring:message code='sys.common.alert.validation' arguments='appointment date (From & To)' htmlEscape='false'/>");
        return false;
      }
    }
    return true;
  }

  function fn_openGenerate() {
    var date = new Date();
    var month = date.getMonth() + 1;
    var day = date.getDate();

    /* by KV- change selection button */
    var runNo1 = 0;
    var asStus = "";

    if (date.getDate() < 10) {
      day = "0" + date.getDate();
    }

    if (fn_validation()) {
      var whereSql = "";
      var asNoFrom = "";
      var asNoTo = "";

      /* By KV - change selection button */
      if ($("#asStatus1 :checked").length > 0) {
        $("#asStatus1 :checked").each(function(i, mul) {
          if ($(mul).val() != "0") {
            if (runNo1 > 0) {
              asStus += ", " + $(mul).val() + " ";
            } else {
              asStus += " " + $(mul).val() + " ";
            }
            runNo1 += 1;
          }
        });
      }

      var ordNoFrom = "";
      var ordNoTo = "";
      if ($("#ordNumFr").val() != '' && $("#ordNumTo").val() != ''
          && $("#ordNumFr").val() != null
          && $("#ordNumTo").val() != null) {
        ordNoFrom = $("#ordNumFr").val();
        ordNoTo = $("#ordNumTo").val();
        whereSql += "and (O.SALES_ORD_NO >= '" + ordNoFrom + "' AND O.SALES_ORD_NO <= '"
            + ordNoTo + "') ";
      }

      if ($("#asNumFr").val() != '' && $("#asNumTo").val() != ''
          && $("#asNumFr").val() != null
          && $("#asNumTo").val() != null) {
        asNoFrom = $("#asNumFr").val();
        asNoTo = $("#asNumTo").val();
        whereSql += "and (ae.AS_No >= '" + asNoFrom + "' AND ae.AS_No <= '"
            + asNoTo + "') ";
      }
      var asRnoFrom = "";
      var asRnoTo = "";
      if ($("#asResultNoFr").val() != ''
          && $("#asResultNoTo").val() != ''
          && $("#asResultNoFr").val() != null
          && $("#asResultNoTo").val() != null) {
        asRnoFrom = $("#asResultNoFr").val();
        asRnoTo = $("#asResultNoTo").val();
        whereSql += "and (am.AS_RESULT_NO >= '" + asRnoFrom
            + "' AND am.AS_RESULT_NO <= '" + asRnoTo + "') ";
      }
      var ctCode = "";
      if ($("#CTCode").val() != '' && $("#CTCode").val() != null) {
        ctCode = $("#CTCode option:selected").text();
        whereSql += "AND mr.Mem_ID = " + $("#CTCode").val() + " ";
      }
      var dscCode = "";
      if ($("#branch").val() != '' && $("#branch").val() != null) {
        dscCode = $("#branch  option:selected").text();
        whereSql += "AND ae.AS_BRNCH_ID = " + $("#branch").val() + " ";
      }

      var appointDateFrom = "";
      var appointDateTo = "";
      if ($("#appDtFr").val() != '' && $("#appDtTo2").val() != ''
          && $("#appDtFr").val() != null
          && $("#appDtTo2").val() != null) {
        appointDateFrom = $("#appDtFr").val();
        appointDateTo = $("#appDtTo2").val();
        whereSql += "AND ae.AS_APPNT_DT >= to_date('"
            + $("#appDtFr").val()
            + "', 'DD/MM/YYYY') AND ae.AS_APPNT_DT <= to_date('"
            + $("#appDtTo2").val() + "', 'DD/MM/YYYY')  ";
      }

      var requestDateFrom = "";
      var requestDateTo = "";
      if ($("#reqDtFr").val() != '' && $("#reqDtTo").val() != ''
          && $("#reqDtFr").val() != null
          && $("#reqDtTo").val() != null) {
        requestDateFrom = $("#reqDtFr").val();
        requestDateTo = $("#reqDtTo").val();
        whereSql += "AND ae.AS_REQST_DT >= to_date('"
            + $("#reqDtFr").val()
            + "', 'DD/MM/YYYY') AND ae.AS_REQST_DT <= to_date('"
            + $("#reqDtTo").val() + "', 'DD/MM/YYYY') ";
      }

      /* var asStus = "";
      if($("#asStatus").val() != '' && $("#asStatus").val() != null){
      asStus = $("#asStatus  option:selected").text();
      whereSql +=   "AND ae.AS_STUS_ID IN (" + $("#asStatus").val() + ")";
      }
       */
      if ($("#asStatus1 :selected").val() != ''
          && $("#asStatus1 :selected").val() != null) {
        whereSql += " AND ae.AS_STUS_ID IN (" + asStus + ") ";
      }

      var asType = "";
      asType = $("#asTypeReport :selected").val();
      if (asType != '' && asType != null) {

          whereSql += "AND ae.AS_TYPE_ID IN (" + asType +") "
              + " ";
        }else{
            Common.alert("<spring:message code='sys.common.alert.validation' arguments='AS type' htmlEscape='false'/>");
            return false;
        }

      var asGroup = "";
      if ($("#CTGroup").val() != '' && $("#CTGroup").val() != null) {
        asGroup = $("#CTGroup  option:selected").text();
        whereSql += "AND ae.AS_MEM_GRP = '" + $("#CTGroup").val()
            + "' ";
      }
      var asSort = "";

      $("#reportFormAS #reportFileName").val(
          '/services/ASSummaryList.rpt');
      $("#reportFormAS #reportDownFileName").val(
          "ASSummaryList_" + day + month + date.getFullYear());
      $("#reportFormAS #viewType").val("PDF");
      $("#reportFormAS #V_SELECTSQL").val();
      $("#reportFormAS #V_WHERESQL").val(whereSql);
      $("#reportFormAS #V_GROUPBYSQL").val();
      $("#reportFormAS #V_FULLSQL").val();
      $("#reportFormAS #V_ASNOFORM").val(asNoFrom);
      $("#reportFormAS #V_ASNOTO").val(asNoTo);
      $("#reportFormAS #V_ASRNOFROM").val(asRnoFrom);
      $("#reportFormAS #V_ASRNOTO").val(asRnoTo);
      $("#reportFormAS #V_CTCODE").val(ctCode);
      $("#reportFormAS #V_DSCCODE").val(dscCode);
      $("#reportFormAS #V_REQUESTDATEFROM").val(requestDateFrom);
      $("#reportFormAS #V_REQUESTDATETO").val(requestDateTo);
      $("#reportFormAS #V_APPOINDATEFROM").val(appointDateFrom);
      $("#reportFormAS #V_APPOINDATETO").val(appointDateTo);
      $("#reportFormAS #V_ASTYPEID").val(asType);
      $("#reportFormAS #V_ASSTATUS").val(asStus);
      $("#reportFormAS #V_ASGROUP").val(asGroup);
      $("#reportFormAS #V_ASTEMPSORT").val(asSort);
      $("#reportFormAS #V_ORDNUMTO").val(ordNoTo);
      $("#reportFormAS #V_ORDNUMFR").val(ordNoFrom);


      var option = {
        isProcedure : true, // procedure 로 구성된 리포트 인경우 필수.
      };

      Common.report("reportFormAS", option);

    }
  }
</script>
<div id="popup_wrap" class="popup_wrap">
 <!-- popup_wrap start -->
 <header class="pop_header">
  <!-- pop_header start -->
  <h1>AS Summary List</h1>
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
   <form action="#" id="reportFormAS" method="post">
    <input type="hidden" id="V_SELECTSQL" name="V_SELECTSQL" /> <input
     type="hidden" id="V_WHERESQL" name="V_WHERESQL" /> <input
     type="hidden" id="V_GROUPBYSQL" name="V_GROUPBYSQL" /> <input
     type="hidden" id="V_FULLSQL" name="V_FULLSQL" /> <input
     type="hidden" id="V_ASNOFORM" name="V_ASNOFORM" /> <input
     type="hidden" id="V_ASNOTO" name="V_ASNOTO" /> <input
     type="hidden" id="V_ASRNOFROM" name="V_ASRNOFROM" /> <input
     type="hidden" id="V_ASRNOTO" name="V_ASRNOTO" /> <input
     type="hidden" id="V_CTCODE" name="V_CTCODE" /> <input
     type="hidden" id="V_DSCCODE" name="V_DSCCODE" /> <input
     type="hidden" id="V_REQUESTDATEFROM" name="V_REQUESTDATEFROM" /> <input
     type="hidden" id="V_REQUESTDATETO" name="V_REQUESTDATETO" /> <input
     type="hidden" id="V_APPOINDATEFROM" name="V_APPOINDATEFROM" /> <input
     type="hidden" id="V_APPOINDATETO" name="V_APPOINDATETO" /> <input
     type="hidden" id="V_ASTYPEID" name="V_ASTYPEID" /> <input
     type="hidden" id="V_ASSTATUS" name="V_ASSTATUS" /> <input
     type="hidden" id="V_ASGROUP" name="V_ASGROUP" /> <input
     type="hidden" id="V_ORDNUMTO" name="V_ORDNUMTO" /> <input
     type="hidden" id="V_ORDNUMFR" name="V_ORDNUMFR" /> <input
     type="hidden" id="V_ASTEMPSORT" name="V_ASTEMPSORT" />

    <!--reportFileName,  viewType 모든 레포트 필수값 -->
    <input type="hidden" id="reportFileName" name="reportFileName" /> <input
     type="hidden" id="viewType" name="viewType" /> <input
     type="hidden" id="reportDownFileName" name="reportDownFileName"
     value="DOWN_FILE_NAME" />
    <table class="type1">
     <!-- table start -->
     <caption>table</caption>
     <colgroup>
      <col style="width: 170px" />
      <col style="width: *" />
      <col style="width: 130px" />
      <col style="width: *" />
     </colgroup>
     <tbody>
      <tr>
       <th scope="row">AS Type <span class="must">*</span></th>
       <td><select class="multy_select w100p" multiple="multiple" id="asTypeReport">
         <option value="674">Normal AS</option>
         <option value="675">Auto AS</option>
          <option value="3154">Add On AS</option>
          <option value="2713">In House Repair AS</option>
       </select></td>
       <th scope="row">Order Number</th>
       <td>
        <div class="date_set">
         <!-- date_set start -->
         <p>
          <input type="text" title="" placeholder="" class="w100p"
           id="ordNumFr" />
         </p>
         <span>To</span>
         <p>
          <input type="text" title="" placeholder="" class="w100p"
           id="ordNumTo" />
         </p>
        </div>
        <!-- date_set end -->
       </td>
      </tr>
      <tr>
       <th scope="row">AS Number</th>
       <td>
        <div class="date_set">
         <!-- date_set start -->
         <p>
          <input type="text" title="" placeholder="" class="w100p"
           id="asNumFr" />
         </p>
         <span>To</span>
         <p>
          <input type="text" title="" placeholder="" class="w100p"
           id="asNumTo" />
         </p>
        </div>
        <!-- date_set end -->
       </td>
       <th scope="row">AS Result No.</th>
       <td>
        <div class="date_set">
         <!-- date_set start -->
         <p>
          <input type="text" title="" placeholder="" class="w100p"
           id="asResultNoFr" />
         </p>
         <span>To</span>
         <p>
          <input type="text" title="" placeholder="" class="w100p"
           id="asResultNoTo" />
         </p>
        </div>
        <!-- date_set end -->
       </td>
      </tr>
      <tr>
       <th scope="row">Request Date</th>
       <td>
        <div class="date_set">
         <!-- date_set start -->
         <p>
          <input type="text" title="Create start Date"
           placeholder="DD/MM/YYYY" class="j_date" id="reqDtFr" />
         </p>
         <span>To</span>
         <p>
          <input type="text" title="Create end Date"
           placeholder="DD/MM/YYYY" class="j_date" id="reqDtTo" />
         </p>
        </div>
        <!-- date_set end -->
       </td>
       <th scope="row">Appointment Date</th>
       <td>
        <div class="date_set">
         <!-- date_set start -->
         <p>
          <input type="text" title="Create start Date"
           placeholder="DD/MM/YYYY" class="j_date" id="appDtFr" />
         </p>
         <span>To</span>
         <p>
          <input type="text" title="Create end Date"
           placeholder="DD/MM/YYYY" class="j_date" id="appDtTo2" />
         </p>
        </div>
        <!-- date_set end -->
       </td>
      </tr>
      <tr>
       <th scope="row">DSC Code</th>
       <td><select ID="branch">
       </select></td>
       <th scope="row">Status</th>
       <td>
        <!-- Edit by KV change to edit button--> <select
        class="multy_select w100p" multiple="multiple" id="asStatus1"
        name="asStatus1">
         <option value="1">Active</option>
         <option value="4">Complete</option>
         <option value="21">Fail</option>
         <option value="10">Cancel</option>
       </select>
       </td>
      </tr>
      <tr>
       <th scope="row">CT Code</th>
       <td><select id="CTCode">
       </select></td>
       <th scope="row">CT Group</th>
       <td><select id="CTGroup">
         <option value="">Choose One</option>
         <option value="A">A</option>
         <option value="B">B</option>
         <option value="C">C</option>
       </select></td>
      </tr>
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
     <a href="#" onclick="javascript:$('#reportFormAS').clearForm();">Clear</a>
    </p></li>
  </ul>
 </section>
 <!-- pop_body end -->
</div>
<!-- popup_wrap end -->