<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<!--
 DATE        BY     VERSION        REMARK
 ----------------------------------------------------------------
 25/06/2019  ONGHC  1.0.0          Amend Report Condition
 20/08/2019  ONGHC  1.0.1          Add Date Option Filter
 17/09/2019  ONGHC  1.0.2          AMEND DEFECT DETAIL SECTION
 03/10/2019  ONGHC  1.0.3          Set Date Range Control
 03/10/2019  ONGHC  1.0.4          Add AS Raw Report for 31Days
 17/10/2019  ONGHC  1.0.5          Add After Service (AS) Spare Part Exchange Raw Data [New]
 25/06/2021  YONGJH 1.0.6          Change AS Raw PQC report from using ASRawDataSprPrtKOR.rpt to ASRawPQCNew.rpt. Also added search filters
 -->

<script type="text/javaScript">
  $(document).ready(function() {

      doGetCombo('/services/as/report/selectProductTypeList.do', '', '', 'cmbProductType', 'S', '');
      doGetCombo('/services/as/report/selectProductList.do', '', '', 'cmbProductCode', 'S', '');
      doGetCombo('/services/as/report/selectDefectTypeList.do', '', '', 'cmbDefectType', 'S', '');
      doGetCombo('/services/as/report/selectDefectRmkList.do', '', '', 'cmbDefectRmk', 'S', '');
      doGetCombo('/services/as/report/selectDefectDescList.do', '', '', 'cmbDefectDesc', 'S', '');
      doGetCombo('/services/as/report/selectDefectDescSymptomList.do', '', '', 'cmbDefectDescSym', 'S', '');

  });

  function fn_toggleAdditionalFilter(selVal) {
	  if(selVal == '3') {
          $("#reportForm1 .tr_toggle_display").show();
	  } else {
		  $('#reportForm1').clearForm();
          $("#reportForm1 .tr_toggle_display").hide();
	  }
  }

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
    if ($("#settleDateFr").val() != '' && $("#settleDateTo").val() == '') {
        Common.alert("<spring:message code='sys.common.alert.validation' arguments='settle date (To)' htmlEscape='false'/>");
        return false;
    }
    if ($("#settleDateFr").val() == '' && $("#settleDateTo").val() != '') {
        Common.alert("<spring:message code='sys.common.alert.validation' arguments='settle date (From)' htmlEscape='false'/>");
        return false;
    }

    var dtRange = 0;

    if ($("#ind").val() == 1) {
      dtRange = 31;
    } else {
      dtRange = 7;
    }

    // VALIDATE DATE RANGE OF 7 DAYS OR 31 DAYS
    if ($("#reportType").val() == '1' || $("#reportType").val() == '5' || $("#reportType").val() == '3' || $("#reportType").val() == '4' || $("#reportType").val() == '6' || $("#reportType").val() == '7') {
      if ($("#reqstDateFr").val() != '' || $("#reqstDateTo").val() != '') {
        var keyInDateFrom = $("#reqstDateFr").val().substring(3, 5) + "/"
                          + $("#reqstDateFr").val().substring(0, 2) + "/"
                          + $("#reqstDateFr").val().substring(6, 10);

        var keyInDateTo = $("#reqstDateTo").val().substring(3, 5) + "/"
                        + $("#reqstDateTo").val().substring(0, 2) + "/"
                        + $("#reqstDateTo").val().substring(6, 10);

        var date1 = new Date(keyInDateFrom);
        var date2 = new Date(keyInDateTo);

        var diff_in_time = date2.getTime() - date1.getTime();

        var diff_in_days = diff_in_time / (1000 * 3600 * 24);

        if (diff_in_days > dtRange) {
          Common.alert("<spring:message code='sys.common.alert.dtRangeNtMore' arguments='" + dtRange + "' htmlEscape='false'/>");
          return false;
        }
      }
    }

    // VALIDATE AS STATUS ONLY FOR AS RAW (PQC)
    if ($("#reportType").val() == '3') {
    	if ($("#cmbAsStatus").val() == '') {
            Common.alert("<spring:message code='sys.common.alert.validation' arguments='AS Status' htmlEscape='false'/>");
            return false;
    	}

        if ($("#numAsAging").val() < 1 || $("#numAsAging").val() > 200) {
            Common.alert("<spring:message code='sys.common.alert.validationNumberRange' arguments='AS Aging,1,200' htmlEscape='false'/>");
            return false;
        }
    }

    return true;
  }

  function fn_openGenerate() {
    if (fn_validation()) {
      var whereSql = "";
      var whereSql2 = "";
      var whereSql2LeftJoin = "";

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

      var settleDateFrom = $("#settleDateFr").val().substring(6, 10) + "-"
      + $("#settleDateFr").val().substring(3, 5) + "-"
      + $("#settleDateFr").val().substring(0, 2);

      var settleDateTo = $("#settleDateTo").val().substring(6, 10) + "-"
      + $("#settleDateTo").val().substring(3, 5) + "-"
      + $("#settleDateTo").val().substring(0, 2);

      if ($("#reqstDateFr").val() != '' && $("#reqstDateTo").val() != ''
       && $("#reqstDateFr").val() != null
       && $("#reqstDateTo").val() != null) {

        if ($("#dateType").val() == '1') {
          whereSql += " AND (TO_CHAR(A.AS_CRT_DT,'YYYY-MM-DD')) >= '" + keyInDateFrom1 + "' AND (TO_CHAR(A.AS_CRT_DT,'YYYY-MM-DD')) <= '" + keyInDateTo1 + "' ";
        } else {
          whereSql += " AND (TO_CHAR(A.AS_REQST_DT,'YYYY-MM-DD')) >= '" + keyInDateFrom1 + "' AND (TO_CHAR(A.AS_REQST_DT,'YYYY-MM-DD')) <= '" + keyInDateTo1 + "' ";
        }
      }

      if ($("#settleDateFr").val() != '' && $("#settleDateTo").val() != ''
          && $("#settleDateFr").val() != null
          && $("#settleDateTo").val() != null) {
          whereSql2 = " AND (TO_CHAR(B.AS_SETL_DT,'YYYY-MM-DD')) >= '" + settleDateFrom + "' AND (TO_CHAR(B.AS_SETL_DT,'YYYY-MM-DD')) <= '" + settleDateTo + "' ";
      } else {
          whereSql2LeftJoin = " LEFT ";
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

        whereSql += " AND H.TYPE_ID = 339 ";

        // Homecare Remove(except)
        whereSql += " AND B.BNDL_ID IS NULL";

        $("#reportForm1 #V_SELECTSQL").val(" ");
        $("#reportForm1 #V_ORDERBYSQL").val(" ");
        $("#reportForm1 #V_FULLSQL").val(" ");
        $("#reportForm1 #V_WHERESQL").val(whereSql);
        $("#reportForm1 #reportFileName").val('/services/ASRawData.rpt');
        $("#reportForm1 #viewType").val("EXCEL");
        $("#reportForm1 #reportDownFileName").val("ASRawData_" + day + month + date.getFullYear());

        var option = {
          isProcedure : true, // procedure 로 구성된 리포트 인경우 필수.
        };

        Common.report("reportForm1", option);
      } else if ($("#reportType").val() == '3') {
          var date = new Date();
          var month = date.getMonth() + 1;
          var day = date.getDate();
          if (date.getDate() < 10) {
            day = "0" + date.getDate();
          }

          var whereSql3 = "";

          if ($("#cmbAsStatus").val() != '') {
              var whereAsStatus = " AND AS_STATUS = '" + $("#cmbAsStatus").val() + "' ";
              whereSql3 += whereAsStatus;
          }

          if ($("#cmbProductCategory").val() != '') {
              var wherePrdCat = " AND PRODUCT_CATEGORY = '" + $("#cmbProductCategory").val() + "' ";
              whereSql3 += wherePrdCat;
          }

          if ($("#cmbProductType").val() != '') {
              var wherePrdType = " AND PRODUCT_TYPE = '" + $("#cmbProductType").val() + "' ";
              whereSql3 += wherePrdType;
          }

          if ($("#cmbProductCode").val() != '') {
              var wherePrdCode = " AND PRODUCT_CODE = '" + $("#cmbProductCode").val() + "' ";
              whereSql3 += wherePrdCode;
          }

          if ($("#numAsAging").val() != '') {
              var whereAsAging = " AND AS_AGING = '" + $("#numAsAging").val() + "' ";
              whereSql3 += whereAsAging;
          }

          if ($("#cmbDefectType").val() != '') {
              var whereDefType = " AND AS_SOLUTION_LARGE = '" + $("#cmbDefectType").val() + "' ";
              whereSql3 += whereDefType;
          }

          if ($("#cmbDefectRmk").val() != '') {
              var whereDefRmk = " AND AS_DEFECT_PART_LARGE = '" + $("#cmbDefectRmk").val() + "' ";
              whereSql3 += whereDefRmk;
          }

          if ($("#cmbDefectDesc").val() != '') {
              var whereDefDesc = " AND AS_DEFECT_PART_SMALL = '" + $("#cmbDefectDesc").val() + "' ";
              whereSql3 += whereDefDesc;
          }

          if ($("#cmbDefectDescSym").val() != '') {
        	  var whereDefDescSym = " AND AS_PROBLEM_SYMPTOM_LARGE = '" + $("#cmbDefectDescSym").val() + "' ";
        	  whereSql3 += whereDefDescSym;
          }

          //SP_CR_GEN_AS_RAW_PQC
          $("#reportForm1").append('<input type="hidden" id="V_SELECTSQL" name="V_SELECTSQL"  /> ');
          $("#reportForm1").append('<input type="hidden" id="V_WHERESQL" name="V_WHERESQL" /> ');
          $("#reportForm1").append('<input type="hidden" id="V_WHERESQL2" name="V_WHERESQL2" /> ');
          $("#reportForm1").append('<input type="hidden" id="V_WHERESQL2LEFTJOIN" name="V_WHERESQL2LEFTJOIN" /> ');
          $("#reportForm1").append('<input type="hidden" id="V_WHERESQL3" name="V_WHERESQL3" /> ');
          $("#reportForm1").append('<input type="hidden" id="V_ORDERBYSQL" name="V_ORDERBYSQL" /> ');
          $("#reportForm1").append('<input type="hidden" id="V_FULLSQL" name="V_FULLSQL" /> ');

          // Homecare Remove(except)
          whereSql += " AND EXISTS( SELECT 1 "
                                + "   FROM SAL0001D C "
                                + "  WHERE A.AS_SO_ID = C.SALES_ORD_ID "
                                + "    AND C.BNDL_ID IS NULL ) ";

          $("#reportForm1 #V_SELECTSQL").val(" ");
          $("#reportForm1 #V_ORDERBYSQL").val(" ");
          $("#reportForm1 #V_FULLSQL").val(" ");
          $("#reportForm1 #V_WHERESQL").val(whereSql);
          console.log("V_WHERESQL " + toString($("#reportForm1 #V_WHERESQL").val()));
          $("#reportForm1 #V_WHERESQL2").val(whereSql2);
          $("#reportForm1 #V_WHERESQL2LEFTJOIN").val(whereSql2LeftJoin);
          $("#reportForm1 #V_WHERESQL3").val(whereSql3);
          //$("#reportForm1 #reportFileName").val('/services/ASRawDataSprPrtKOR.rpt');
          $("#reportForm1 #reportFileName").val('/services/ASRawPQCNew.rpt');
          $("#reportForm1 #viewType").val("EXCEL");
          $("#reportForm1 #reportDownFileName").val("ASRawPQCData_" + day + month + date.getFullYear());

          var option = {
            isProcedure : true, // procedure 로 구성된 리포트 인경우 필수.
          };

          Common.report("reportForm1", option);
      } else if ($("#reportType").val() == '4') {
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

        whereSql += " AND A.AS_TYPE_ID IN (3154) ";

        // Homecare Remove(except)
        whereSql += " AND B.BNDL_ID IS NULL";

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

        Common.report("reportForm1", option);
      } else if ($("#reportType").val() == '5') {
        var date = new Date();
        var month = date.getMonth() + 1;
        var day = date.getDate();
        if (date.getDate() < 10) {
          day = "0" + date.getDate();
        }
        $("#reportForm1").append('<input type="hidden" id="V_SELECTSQL" name="V_SELECTSQL"  /> ');
        $("#reportForm1").append('<input type="hidden" id="V_WHERESQL" name="V_WHERESQL" /> ');
        $("#reportForm1").append('<input type="hidden" id="V_WHERESQL2" name="V_WHERESQL2" /> ');
        $("#reportForm1").append('<input type="hidden" id="V_WHERESQL2LEFTJOIN" name="V_WHERESQL2LEFTJOIN" /> ');
        $("#reportForm1").append('<input type="hidden" id="V_ORDERBYSQL" name="V_ORDERBYSQL" /> ');
        $("#reportForm1").append('<input type="hidden" id="V_FULLSQL" name="V_FULLSQL" /> ');

        //whereSql += " AND A.AS_TYPE_ID = 339 ";
        // Homecare Remove(except)
        whereSql += " AND EXISTS ( SELECT 1 "
                               + "   FROM SAL0001D C "
                               + "  WHERE A.AS_SO_ID = C.SALES_ORD_ID "
                               + "    AND C.BNDL_ID IS NULL ) ";

        $("#reportForm1 #V_SELECTSQL").val(" ");
        $("#reportForm1 #V_ORDERBYSQL").val(" ");
        $("#reportForm1 #V_FULLSQL").val(" ");
        $("#reportForm1 #V_WHERESQL").val(whereSql);
        $("#reportForm1 #V_WHERESQL2").val(whereSql2);
        $("#reportForm1 #V_WHERESQL2LEFTJOIN").val(whereSql2LeftJoin);
        $("#reportForm1 #reportFileName").val('/services/ASRawDataKOR.rpt');
        $("#reportForm1 #viewType").val("EXCEL");
        $("#reportForm1 #reportDownFileName").val("ASRawDataKOR_" + day + month + date.getFullYear());

        var option = {
          isProcedure : true, // procedure 로 구성된 리포트 인경우 필수.
        };

        Common.report("reportForm1", option);
      } else if ($("#reportType").val() == '6') {
          var date = new Date();
          var month = date.getMonth() + 1;
          var day = date.getDate();
          if (date.getDate() < 10) {
            day = "0" + date.getDate();
          }
          $("#reportForm1").append('<input type="hidden" id="V_SELECTSQL" name="V_SELECTSQL"  /> ');
          $("#reportForm1").append('<input type="hidden" id="V_WHERESQL" name="V_WHERESQL" /> ');
          $("#reportForm1").append('<input type="hidden" id="V_WHERESQL2" name="V_WHERESQL2" /> ');
          $("#reportForm1").append('<input type="hidden" id="V_WHERESQL2LEFTJOIN" name="V_WHERESQL2LEFTJOIN" /> ');
          $("#reportForm1").append('<input type="hidden" id="V_ORDERBYSQL" name="V_ORDERBYSQL" /> ');
          $("#reportForm1").append('<input type="hidden" id="V_FULLSQL" name="V_FULLSQL" /> ');

          whereSql += " AND A.AS_TYPE_ID IN (3154) ";

          // Homecare Remove(except)
          whereSql += " AND EXISTS( SELECT 1 "
                                + "   FROM SAL0001D C "
                                + "  WHERE A.AS_SO_ID = C.SALES_ORD_ID "
                                + "    AND C.BNDL_ID IS NULL ) ";

          $("#reportForm1 #V_SELECTSQL").val(" ");
          $("#reportForm1 #V_ORDERBYSQL").val(" ");
          $("#reportForm1 #V_FULLSQL").val(" ");
          $("#reportForm1 #V_WHERESQL").val(whereSql);
          $("#reportForm1 #V_WHERESQL2").val(whereSql2);
          $("#reportForm1 #V_WHERESQL2LEFTJOIN").val(whereSql2LeftJoin);
          $("#reportForm1 #reportFileName").val('/services/ASRawDataKOR.rpt');
          $("#reportForm1 #viewType").val("EXCEL");
          $("#reportForm1 #reportDownFileName").val("ASRawDataAOASKOR_" + day + month + date.getFullYear());

          var option = {
            isProcedure : true, // procedure 로 구성된 리포트 인경우 필수.
          };

          Common.report("reportForm1", option);
      } else if ($("#reportType").val() == '7') {
          var date = new Date();
          var month = date.getMonth() + 1;
          var day = date.getDate();
          if (date.getDate() < 10) {
            day = "0" + date.getDate();
          }
          $("#reportForm1").append('<input type="hidden" id="V_SELECTSQL" name="V_SELECTSQL"  /> ');
          $("#reportForm1").append('<input type="hidden" id="V_WHERESQL" name="V_WHERESQL" /> ');
          $("#reportForm1").append('<input type="hidden" id="V_WHERESQL2" name="V_WHERESQL2" /> ');
          $("#reportForm1").append('<input type="hidden" id="V_WHERESQL2LEFTJOIN" name="V_WHERESQL2LEFTJOIN" /> ');
          $("#reportForm1").append('<input type="hidden" id="V_ORDERBYSQL" name="V_ORDERBYSQL" /> ');
          $("#reportForm1").append('<input type="hidden" id="V_FULLSQL" name="V_FULLSQL" /> ');

          //whereSql += " AND A.AS_TYPE_ID = 339 ";

          // Homecare Remove(except)
          whereSql += " AND EXISTS( SELECT 1 "
                                + "   FROM SAL0001D C "
                                + "  WHERE A.AS_SO_ID = C.SALES_ORD_ID "
                                + "    AND C.BNDL_ID IS NULL ) ";

          $("#reportForm1 #V_SELECTSQL").val(" ");
          $("#reportForm1 #V_ORDERBYSQL").val(" ");
          $("#reportForm1 #V_FULLSQL").val(" ");
          $("#reportForm1 #V_WHERESQL").val(whereSql);
          console.log("V_WHERESQL " + toString($("#reportForm1 #V_WHERESQL").val()));
          $("#reportForm1 #V_WHERESQL2").val(whereSql2);
          $("#reportForm1 #V_WHERESQL2LEFTJOIN").val(whereSql2LeftJoin);
          $("#reportForm1 #reportFileName").val('/services/ASRawDataSprPrtKOR.rpt');
          $("#reportForm1 #viewType").val("EXCEL");
          $("#reportForm1 #reportDownFileName").val("ASRawDataSprPrtKOR_" + day + month + date.getFullYear());

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

        if ($("#settleDateFr").val() != '' && $("#settleDateTo").val() != ''
            && $("#settleDateFr").val() != null
            && $("#settleDateTo").val() != null) {
        	settleDateFrom = settleDateFrom + " 12:00:00 AM";
        	settleDateTo = settleDateTo + " 12:00:00 AM";
        } else {
            settleDateFrom = "1900-01-01 12:00:00 AM";
            settleDateTo = "9999-12-31 12:00:00 AM";
        }

        // SP_CR_PART_DLVY_ORD_RAW
        $("#reportForm1").append('<input type="hidden" id="V_KEYINDATEFROM" name="V_KEYINDATEFROM" /> ');
        $("#reportForm1").append('<input type="hidden" id="V_KEYINDATETO" name="V_KEYINDATETO"  /> ');
        $("#reportForm1").append('<input type="hidden" id="V_DSCBRANCHID" name="V_DSCBRANCHID" /> ');
        $("#reportForm1").append('<input type="hidden" id="V_SETTLEDATEFROM" name="V_SETTLEDATEFROM" /> ');
        $("#reportForm1").append('<input type="hidden" id="V_SETTLEDATETO" name="V_SETTLEDATETO" /> ');
        $("#reportForm1 #V_KEYINDATEFROM").val(keyInDateFrom);
        $("#reportForm1 #V_KEYINDATETO").val(keyInDateTo);
        $("#reportForm1 #V_DSCBRANCHID").val(0);
        $("#reportForm1 #V_SETTLEDATEFROM").val(settleDateFrom);
        $("#reportForm1 #V_SETTLEDATETO").val(settleDateTo);
        $("#reportForm1 #reportFileName").val('/services/ASSparePartRaw.rpt');
        $("#reportForm1 #viewType").val("EXCEL");
        $("#reportForm1 #reportDownFileName").val("ASSparePartRaw_" + day + month + date.getFullYear());

        var option = {
          isProcedure : true, // procedure 로 구성된 리포트 인경우 필수.
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
          || tag === 'textarea' || type === 'number') {
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
  <h1>AS Raw Data
   <c:choose>
    <c:when test="${ind=='1'}">
     <span style="color:red">( <spring:message code='service.message.dtRange31'/> )</span>
    </c:when>
    <c:otherwise>
     <span style="color:red">( <spring:message code='service.message.dtRange7'/> )</span>
    </c:otherwise>
   </c:choose>
  </h1>
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
    <input type="hidden" id="ind" name="ind" value="${ind}"/>
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
       <td><select id="reportType" class="w100p" onchange="javascript : fn_toggleAdditionalFilter(this.value)">
<!--          <option value="1">After Service (AS) Raw Data</option> -->
         <option value="5" selected>After Service (AS) Raw Data [New]</option>
         <option value="2">After Service (AS) Spare Part Exchange Raw Data</option>
         <option value="7">After Service (AS) Spare Part Exchange Raw Data [New]</option>
         <option value="3">After Service (AS) Raw Data (PQC)</option>
<!--          <option value="4">After Service (AS) Raw Data (AOAS)</option> -->
         <option value="6">After Service (AS) Raw Data (AOAS) [New]</option>
       </select></td>
       <th scope="row">Date Option<span id='m3' name='m3' class='must'> *</span></th>
       <td><select id="dateType" class="w100p" >
         <option value="1" selected>Register Date</option>
         <option value="2">Request Date</option>
       </select></td>
      </tr>
      <tr>
      <th scope="row">Request Date<span id='m2' name='m2' class='must'> *</span></th>
       <td>
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
       <th scope="row">Settle Date</th>
       <td>
        <div class="date_set">
         <!-- date_set start -->
         <p>
          <input type="text" title="Settle start Date"
           placeholder="DD/MM/YYYY" class="j_date" id="settleDateFr" />
         </p>
         <span>To</span>
         <p>
          <input type="text" title="Settle end Date"
           placeholder="DD/MM/YYYY" class="j_date" id="settleDateTo" />
         </p>
        </div>
        <!-- date_set end -->
       </td>
      </tr>
      <tr class="tr_toggle_display" style="display:none;">
        <th scope="row">AS Status<span id='m4' name='m4' class='must'> *</span></th>
        <td><select id="cmbAsStatus" class="w100p">
          <option value="">Choose One</option>
          <option value="ACT">Active</option>
          <option value="CAN">Cancelled</option>
          <option value="COM">Completed</option>
          <option value="RCL">Recall</option>
        </select></td>
        <th scope="row">Product Category</th>
        <td><select id="cmbProductCategory" class="w100p">
          <option value="">Choose One</option>
          <option value="AIR PURIFIER">Air Purifier</option>
          <option value="BIDET">Bidet</option>
          <option value="JUICER">Juicer</option>
          <option value="POINT OF ENTRY">Point of Entry</option>
          <option value="SOFTENER">Softener</option>
          <option value="WATER PURIFIER">Water Purifier</option>
        </select></td>
      </tr>
      <tr class="tr_toggle_display" style="display:none;">
        <th scope="row">Product Type</th>
        <td><select id="cmbProductType" class="w100p" /></td>
        <th scope="row">Product Code</th>
        <td><select id="cmbProductCode" class="w100p" /></td>
      </tr>
      <tr class="tr_toggle_display" style="display:none;">
        <th scope="row">AS Aging</th>
        <td><input id="numAsAging" name="numAsAging" class="w100p" type="number" min="1" max="200" placeholder="min 1 ; max 200"/></td>
        <th scope="row">AS Solution Large</th>
        <td><select id="cmbDefectType" class="w100p" /></td>
      </tr>
      <tr class="tr_toggle_display" style="display:none;">
        <th scope="row">AS Defect Part Large</th>
        <td><select id="cmbDefectRmk" class="w100p" /></td>
        <th scope="row">AS Defect Part Small</th>
        <td><select id="cmbDefectDesc" class="w100p" /></td>
      </tr>
      <tr class="tr_toggle_display" style="display:none;">
        <th scope="row">AS Problem Symptom Large</th>
        <td><select id="cmbDefectDescSym" class="w100p" /></td>
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
