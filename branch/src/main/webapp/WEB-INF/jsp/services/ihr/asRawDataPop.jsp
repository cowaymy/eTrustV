<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<!--
 DATE        BY     VERSION        REMARK
 ----------------------------------------------------------------
 28/08/2019  ONGHC  1.0.0          Create IHR
 17/09/2019  ONGHC  1.0.1          AMEND DEFECT DETAIL SECTION
 -->

<script type="text/javaScript">
  $(document).ready(function() {

  });

  function fn_validation() {

    if ($("#reportType").val() == '') {
      Common.alert("<spring:message code='sys.common.alert.validation' arguments='type' htmlEscape='false'/>");
      return false;
    }
    if ($("#dateType").val() == '') {
        Common.alert("<spring:message code='sys.common.alert.validation' arguments='type' htmlEscape='false'/>");
        return false;
      }
    if ($("#reqstDateFr").val() == '' || $("#reqstDateTo").val() == '') {
      Common.alert("<spring:message code='sys.common.alert.validation' arguments='request date (From & To)' htmlEscape='false'/>");
      return false;
    }
    return true;
  }

  function fn_openGenerate() {
    if (fn_validation()) {
      var whereSql = "";
      var keyInDateFrom = $("#reqstDateFr").val().substring(6, 10) + "-"
                        + $("#reqstDateFr").val().substring(3, 5) + "-"
                        + $("#reqstDateFr").val().substring(0, 2) + " 12:00:00 AM";
      var keyInDateTo = $("#reqstDateTo").val().substring(6, 10) + "-"
                      + $("#reqstDateTo").val().substring(3, 5) + "-"
                      + $("#reqstDateTo").val().substring(0, 2) + " 12:00:00 AM";

      var keyInDateFrom1 = $("#reqstDateFr").val().substring(6, 10) + "-"
                         + $("#reqstDateFr").val().substring(3, 5) + "-"
                         + $("#reqstDateFr").val().substring(0, 2);
      var keyInDateTo1 = $("#reqstDateTo").val().substring(6, 10) + "-"
                       + $("#reqstDateTo").val().substring(3, 5) + "-"
                       + $("#reqstDateTo").val().substring(0, 2);

      if ($("#reqstDateFr").val() != '' && $("#reqstDateTo").val() != ''
       && $("#reqstDateFr").val() != null
       && $("#reqstDateTo").val() != null) {

        if ($("#dateType").val() == '1') {
          whereSql += " AND (TO_CHAR(A.AS_CRT_DT,'YYYY-MM-DD')) >= '" + keyInDateFrom1 + "' AND (TO_CHAR(A.AS_CRT_DT,'YYYY-MM-DD')) <= '" + keyInDateTo1 + "' ";
        } else {
          whereSql += " AND (TO_CHAR(A.AS_REQST_DT,'YYYY-MM-DD')) >= '" + keyInDateFrom1 + "' AND (TO_CHAR(A.AS_REQST_DT,'YYYY-MM-DD')) <= '" + keyInDateTo1 + "' ";
        }
      }

      if ($("#reportType").val() == '1') {
        var date = new Date();
        var month = date.getMonth() + 1;
        var day = date.getDate();
        if (date.getDate() < 10) {
          day = "0" + date.getDate();
        }
        $("#reportForm1").append('<input type="hidden" id="V_SELECTSQL" name="V_SELECTSQL"  /> ');
        $("#reportForm1").append('<input type="hidden" id="V_WHERESQL" name="V_WHERESQL" /> ');
        $("#reportForm1").append('<input type="hidden" id="V_ORDERBYSQL" name="V_ORDERBYSQL" /> ');
        $("#reportForm1").append('<input type="hidden" id="V_FULLSQL" name="V_FULLSQL" /> ');

        whereSql += " AND A.AS_TYPE_ID = 2713 ";

        $("#reportForm1 #V_SELECTSQL").val(" ");
        $("#reportForm1 #V_ORDERBYSQL").val(" ");
        $("#reportForm1 #V_FULLSQL").val(" ");
        $("#reportForm1 #V_WHERESQL").val(whereSql);
        $("#reportForm1 #reportFileName").val('/services/IHRawData.rpt');
        $("#reportForm1 #viewType").val("EXCEL");
        $("#reportForm1 #reportDownFileName").val("IHRawData_" + day + month + date.getFullYear());

        var option = {
          isProcedure : true,
        };

        Common.report("reportForm1", option);
      } else if ($("#reportType").val() == '3') {
        var date = new Date();
        var month = date.getMonth() + 1;
        var day = date.getDate();
        if (date.getDate() < 10) {
          day = "0" + date.getDate();
        }
        $("#reportForm1").append('<input type="hidden" id="V_SELECTSQL" name="V_SELECTSQL"  /> ');
        $("#reportForm1").append('<input type="hidden" id="V_WHERESQL" name="V_WHERESQL" /> ');
        $("#reportForm1").append('<input type="hidden" id="V_ORDERBYSQL" name="V_ORDERBYSQL" /> ');
        $("#reportForm1").append('<input type="hidden" id="V_FULLSQL" name="V_FULLSQL" /> ');

        //whereSql += " AND A.AS_TYPE_ID = 339 ";

        $("#reportForm1 #V_SELECTSQL").val(" ");
        $("#reportForm1 #V_ORDERBYSQL").val(" ");
        $("#reportForm1 #V_FULLSQL").val(" ");
        $("#reportForm1 #V_WHERESQL").val(whereSql);
        $("#reportForm1 #reportFileName").val('/services/IHRawDataKOR.rpt');
        $("#reportForm1 #viewType").val("EXCEL");
        $("#reportForm1 #reportDownFileName").val("IHRawDataKOR_" + day + month + date.getFullYear());

        var option = {
          isProcedure : true, // procedure 로 구성된 리포트 인경우 필수.
        };

        Common.report("reportForm1", option);
      }  else if ($("#reportType").val() == '4') {
          /*var date = new Date();
          var month = date.getMonth() + 1;
          var day = date.getDate();
          if (date.getDate() < 10) {
            day = "0" + date.getDate();
          }
          $("#reportForm1").append('<input type="hidden" id="V_SELECTSQL" name="V_SELECTSQL"  /> ');
          $("#reportForm1").append('<input type="hidden" id="V_WHERESQL" name="V_WHERESQL" /> ');
          $("#reportForm1").append('<input type="hidden" id="V_ORDERBYSQL" name="V_ORDERBYSQL" /> ');
          $("#reportForm1").append('<input type="hidden" id="V_FULLSQL" name="V_FULLSQL" /> ');

          whereSql += " AND A.AS_TYPE_ID IN (3154) ";

          $("#reportForm1 #V_SELECTSQL").val(" ");
          $("#reportForm1 #V_ORDERBYSQL").val(" ");
          $("#reportForm1 #V_FULLSQL").val(" ");
          $("#reportForm1 #V_WHERESQL").val(whereSql);
          $("#reportForm1 #reportFileName").val('/services/ASRawData.rpt');
          $("#reportForm1 #viewType").val("EXCEL");
          $("#reportForm1 #reportDownFileName").val("ASRawDataAOAS_" + day + month + date.getFullYear());
          //$("#reportForm1 #V_DEPT").val("PQC");

          var option = {
            isProcedure : true, // procedure 로 구성된 리포트 인경우 필수.
          };

          Common.report("reportForm1", option);*/
      } else if ($("#reportType").val() == '7') {
          var date = new Date();
          var month = date.getMonth() + 1;
          var day = date.getDate();
          if (date.getDate() < 10) {
            day = "0" + date.getDate();
          }
          $("#reportForm1").append('<input type="hidden" id="V_SELECTSQL" name="V_SELECTSQL"  /> ');
          $("#reportForm1").append('<input type="hidden" id="V_WHERESQL" name="V_WHERESQL" /> ');
          $("#reportForm1").append('<input type="hidden" id="V_ORDERBYSQL" name="V_ORDERBYSQL" /> ');
          $("#reportForm1").append('<input type="hidden" id="V_FULLSQL" name="V_FULLSQL" /> ');

          //whereSql += " AND A.AS_TYPE_ID = 339 ";

          $("#reportForm1 #V_SELECTSQL").val(" ");
          $("#reportForm1 #V_ORDERBYSQL").val(" ");
          $("#reportForm1 #V_FULLSQL").val(" ");
          $("#reportForm1 #V_WHERESQL").val(whereSql);
          $("#reportForm1 #reportFileName").val('/services/IHRawDataSprPrtKOR.rpt');
          $("#reportForm1 #viewType").val("EXCEL");
          $("#reportForm1 #reportDownFileName").val("IHRawDataSprPrtKOR_" + day + month + date.getFullYear());

          var option = {
            isProcedure : true, // procedure 로 구성된 리포트 인경우 필수.
          };

          Common.report("reportForm1", option);
      } else {
        var date = new Date();
        var month = date.getMonth() + 1;
        var day = date.getDate();
        if (date.getDate() < 10) {
          day = "0" + date.getDate();
        }

        $("#reportForm1").append('<input type="hidden" id="V_KEYINDATEFROM" name="V_KEYINDATEFROM" /> ');
        $("#reportForm1").append('<input type="hidden" id="V_KEYINDATETO" name="V_KEYINDATETO"  /> ');
        $("#reportForm1").append('<input type="hidden" id="V_DSCBRANCHID" name="V_DSCBRANCHID" /> ');
        $("#reportForm1 #V_KEYINDATEFROM").val(keyInDateFrom);
        $("#reportForm1 #V_KEYINDATETO").val(keyInDateTo);
        $("#reportForm1 #V_DSCBRANCHID").val(0);
        $("#reportForm1 #reportFileName").val('/services/IHSparePartRaw.rpt');
        $("#reportForm1 #viewType").val("EXCEL");
        $("#reportForm1 #reportDownFileName").val("IHSparePartRaw_" + day + month + date.getFullYear());

        var option = {
          isProcedure : true,
        };

        Common.report("reportForm1", option);
      }
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

    });
  };
</script>
<div id="popup_wrap" class="popup_wrap">
 <!-- popup_wrap start -->
 <header class="pop_header">
  <!-- pop_header start -->
  <h1>AS Raw Data</h1>
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
    <input type="hidden" id="reportFileName" name="reportFileName" /> <input
     type="hidden" id="viewType" name="viewType" /> <input
     type="hidden" id="reportDownFileName" name="reportDownFileName"
     value="DOWN_FILE_NAME" />
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
       <th scope="row">Report Type<span id='m1' name='m1' class='must'> *</span></th>
       <td><select id="reportType" class="w100p" >
         <option value="1">In-House (IHR) Raw Data</option>
         <option value="3" selected>In-House (IHR) Raw Data [New]</option>
         <option value="2">In-House (IHR) Spare Part Exchange Raw Data</option>
         <option value="7">In-House (IHR) Spare Part Exchange Raw Data [New]</option>
         <!-- <option value="3">After Service (AS) Raw Data (PQC)</option>  -->
         <!-- <option value="4">After Service (AS) Raw Data (AOAS)</option>  -->
       </select></td>
       <th scope="row">Date Option<span id='m3' name='m3' class='must'> *</span></th>
       <td><select id="dateType" class="w100p" >
         <option value="1" selected>Register Date</option>
         <option value="2">Request Date</option>
       </select></td>
      </tr>
      <tr>
      <th scope="row">Request Date<span id='m2' name='m2' class='must'> *</span></th>
       <td colspan='3'>
        <div class="date_set">
         <!-- date_set start -->
         <p>
          <input type="text" title="Create start Date"
           placeholder="DD/MM/YYYY" class="j_date" id="reqstDateFr" />
         </p>
         <span>To</span>
         <p>
          <input type="text" title="Create end Date"
           placeholder="DD/MM/YYYY" class="j_date" id="reqstDateTo" />
         </p>
        </div>
        <!-- date_set end -->
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
