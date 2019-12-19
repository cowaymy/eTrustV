<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<!--
 DATE        BY     VERSION        REMARK
 ----------------------------------------------------------------
 18/12/2019  ONGHC  1.0.0          Create AS Used Filter
 19/12/2019  ONGHC  1.0.1          Add AS Type Selection
 -->

<script type="text/javascript">
  var locGrd = [ {
    "codeId" : "A",
    "codeName" : "A"
  }, {
    "codeId" : "B",
    "codeName" : "B"
  } ];

  $(document).ready( function() {
     doGetComboData('/logistics/returnasusedparts/getBchBrowse.do', '', '', 'cmbBranchCode', 'S', '');
     doDefCombo(locGrd, 'A', 'cmbDepartmentCode', 'S', '');
  });

  $('.multy_select').change(function() {
  }).multipleSelect({
    width : '100%'
  });

  $('#cmbBranchCode').change(function() {
    cmbDepartmentCode_SelectedIndexChanged();
  });

  $('#cmbListingType').change(function() {
    if ($('#cmbListingType').val() == "2") {
      $('#m6').show();
    } else {
      $('#m6').hide();
    }
  });

  $.fn.clearForm = function() {
    $("#cmbReturnStatus").multipleSelect("checkAll");

    return this.each(function() {
      var type = this.type, tag = this.tagName.toLowerCase();
      if (tag === 'form') {
        return $(':input', this).clearForm();
      }
      if (type === 'text' || type === 'password' || type === 'hidden'
          || tag === 'textarea') {
        this.value = '';
      } else if (tag === 'select') {
        this.selectedIndex = 0;
      }

      $('#m6').hide();
      $("#cmbListingType").val("1");
      $("#cmbDepartmentCode").val("A");
      $('#cmbCodyCode').empty();
      $("#cmbBranchCode").val("");
      $("#dpHSSettleDateFrom").empty();
      $("#dpHSSettleDateTo").empty();

    });
  };

  function validRequiredField() {
    var valid = true;
    var message = "";

    if ($("#cmbListingType").val() == null || $("#cmbListingType").val().length == 0) {
      valid = false;
      message += "<spring:message code='sys.msg.necessary' arguments='Report Type' htmlEscape='false'/> <br/>";
    }

    if ($("#cmbReturnStatus").val() == null || $("#cmbReturnStatus").val().length == 0) {
      valid = false;
      message += "<spring:message code='sys.msg.necessary' arguments='Return Status' htmlEscape='false'/> <br/>";
    }

    if (($("#dpHSSettleDateFrom").val() == null || $("#dpHSSettleDateFrom").val().length == 0)
     || ($("#dpHSSettleDateTo").val() == null || $("#dpHSSettleDateTo").val().length == 0)) {
      valid = false;
      message += "<spring:message code='sys.msg.necessary' arguments='Settle Date' htmlEscape='false'/> <br/>";
    }

    if ($("#cmbBranchCode").val() == null || $("#cmbBranchCode").val().length == 0) {
        valid = false;
        message += "<spring:message code='sys.msg.necessary' arguments='Branch' htmlEscape='false'/> <br/>";
      }

    if ($("#cmbListingType").val() == 2) {
      if ($("#cmbCodyCode").val() == null || $("#cmbCodyCode").val().length == 0) {
        valid = false;
        message += "<spring:message code='sys.msg.necessary' arguments='Location' htmlEscape='false'/> <br/>";
      }
    }

    if ($("#cmbDepartmentCode").val() == null || $("#cmbDepartmentCode").val().length == 0) {
      valid = false;
      message += "<spring:message code='sys.msg.necessary' arguments='Location Grade' htmlEscape='false'/> <br/>";
    }

    if (valid == false) {
      //Common.alert('<spring:message code="sal.alert.title.reportGenSummary" />' + DEFAULT_DELIMITER + message);
      Common.alert(message);
    }

    return valid;
  }

  function cmbDepartmentCode_SelectedIndexChanged() {
    if ($('#cmbBranchCode').val() != null && $('#cmbBranchCode').val() != "") {
        var searchlocgb = "03";
        var searchBranch = $('#cmbBranchCode').val();

        if ($('#cmbDepartmentCode').val() == null || $('#cmbDepartmentCode').val() == "") {
        	Common.alert("<spring:message code='sys.msg.necessary' arguments='Location Grade' htmlEscape='false'/>");
          //doGetComboData('/logistics/totalstock/selectTotalBranchList.do', '', '', 'searchBranch', 'S', '');
          return false;
        }

        var param = { searchlocgb : searchlocgb,
                      grade : $('#cmbDepartmentCode').val(),
                      searchBranch : searchBranch
                    }

        doGetComboData('/logistics/returnasusedparts/getLoc.do', param, '', 'cmbCodyCode', 'S', '');
      }
  }

  function f_multiComboType() {
    $(function() {
      $('#cmbCodyCode').change(function() {
      }).multipleSelect({
        selectAll : true
      });
    });
  }

  function btnGeneratePDF_Click() {
    if (validRequiredField()) {

      var listingType = "";
      var hsSettleDateFrom = "";
      var hsSettleDateTo = "";
      var retStatus = "";
      var warehouseCode = "";
      var deptCode = "";
      var codyCode = "";
      var asTyp = "";
      var whereSQL = "";
      var orderBySQL = "";

      $("#reportFileName").val("");
      $("#reportDownFileName").val("");
      $("#viewType").val("");

      asTyp = $("input[name='asTypPop']:checked").val();
      warehouseCode = $("#cmbBranchCode :selected").text();

      if (!($("#dpHSSettleDateFrom").val() == null || $("#dpHSSettleDateFrom").val().length == 0)) {
        whereSQL += " AND TO_CHAR(A.SVC_DT, 'yyyymmdd') >= TO_CHAR(TO_DATE('"
                 + $("#dpHSSettleDateFrom").val()
                 + "', 'dd/MM/YYYY'), 'yyyymmdd')";
        hsSettleDateFrom = $("#dpHSSettleDateFrom").val();
      }

      if (!($("#dpHSSettleDateTo").val() == null || $("#dpHSSettleDateTo")
          .val().length == 0)) {
        whereSQL += " AND TO_CHAR(A.SVC_DT, 'yyyymmdd') <= TO_CHAR(TO_DATE('"
            + $("#dpHSSettleDateTo").val()
            + "', 'dd/MM/YYYY'), 'yyyymmdd')";
        hsSettleDateTo = $("#dpHSSettleDateTo").val();

      }

      if ($('#cmbReturnStatus :selected').length > 0) {
        whereSQL += " AND (";
        var runNo = 0;

        $('#cmbReturnStatus :selected').each(
            function(i, mul) {
              if (runNo == 0) {
                if ($(mul).val() == "N") {
                  whereSQL += " A.CMPLT_YN is null ";
                } else {
                  whereSQL += " A.CMPLT_YN = '"
                      + $(mul).val() + "' ";
                }
                retStatus += "'" + $(mul).val() + "'";
              } else {
                if ($(mul).val() == "N") {
                  whereSQL += " OR A.CMPLT_YN is null ";
                } else {
                  whereSQL += " OR A.CMPLT_YN = '"
                      + $(mul).val() + "' ";
                }
                retStatus += ", '" + $(mul).val() + "'";
              }

              runNo += 1;
            });
        whereSQL += ") ";
      }

      if ($("#cmbBranchCode :selected").val() != null || $("#cmbBranchCode :selected").val() != "") {
        whereSQL += " AND C.BRNCH = '" + $("#cmbBranchCode").val() + "'";
        warehouseCode = $("#cmbBranchCode :selected").text();
      }

      /*if ($("#cmbDepartmentCode :selected").val() > 0) {

        whereSQL += " AND ov.MEM_UP_ID = '"
            + $("#cmbDepartmentCode").val() + "'";
        deptCode = $("#cmbDepartmentCode :selected").text();
      }*/

      if ($("#cmbCodyCode").val() != null && $("#cmbCodyCode").val() != '') {
        whereSQL += " AND A.MEM_ID = (SELECT MEM_ID FROM ORG0001D WHERE MEM_CODE = '" + $("#cmbCodyCode").val() + "')";
        codyCode = $("#cmbCodyCode :selected").text();
      }

      /*var ctCode = $("#cmbCodyCode").val();
      var ctCodeLst = "";
      if (ctCode != null) {
        if (ctCode.length > 0) {
          for (var a = 0; a < ctCode.length; a++) {
            if (a == 0) {
              ctCodeLst += "'" + ctCode[a] + "'"
            } else {
              ctCodeLst += ", '" + ctCode[a] + "'"
            }
          }
          whereSQL += " AND A.MEM_ID IN (SELECT MEM_ID FROM ORG0001D WHERE MEM_CODE IN ("
              + ctCodeLst + ")) ";
        }
      }*/

      var date = new Date().getDate();
      if (date.toString().length == 1) {
        date = "0" + date;
      }

      $("#form #viewType").val("PDF");
      if ($("#cmbListingType :selected").val() == 1) {
        $("#form #reportFileName").val( "/logistics/ASUsedFilterListing_PDF.rpt");
        $("#reportDownFileName").val("ASUsedFilterListing" + date + (new Date().getMonth() + 1) + new Date().getFullYear());
        orderBySQL += " ORDER BY A.MATERIAL_CODE, A.MATERIAL_NAME, A.ORDER_NO, A.SERVICE_DATE ";
      }

      if ($("#cmbListingType :selected").val() == 2) {
        $("#form #reportFileName").val("/logistics/ASUsedFilterSummaryListing_PDF.rpt");
        $("#reportDownFileName").val("ASUsedFilterSummaryListing" + date + (new Date().getMonth() + 1) + new Date().getFullYear());
      }

      $("#form #V_WHERESQL").val(whereSQL);
      $("#form #V_HSSETTLEDATEFROM").val(hsSettleDateFrom);
      $("#form #V_HSSETTLEDATETO").val(hsSettleDateTo);
      $("#form #V_RETSTATUS").val(retStatus);
      $("#form #V_WAREHOUSECODE").val(warehouseCode);
      $("#form #V_DEPTCODE").val(deptCode);
      $("#form #V_CODYCODE").val(codyCode);
      $("#form #V_ASTYP").val(asTyp);
      $("#form #V_ORDERBYSQL").val(orderBySQL);
      $("#form #V_SELECTSQL").val("");
      $("#form #V_FULLSQL").val("");

      // 프로시져로 구성된 경우 꼭 아래 option을 넘겨야 함.
      var option = {
        isProcedure : true
      // procedure 로 구성된 리포트 인경우 필수.  => /payment/PaymentListing_Excel.rpt 는 프로시져로 구성된 파일임.
      };

      Common.report("form", option);

    } else {
      return false;
    }
  }
</script>
<div id="popup_wrap" class="popup_wrap">
 <!-- popup_wrap start -->
 <header class="pop_header">
  <!-- pop_header start -->
  <h1><spring:message code='log.title.asUsdFltLst'/></h1>
  <ul class="right_opt">
   <li><p class="btn_blue2">
     <a href="#"><spring:message code="sal.btn.close" /></a>
    </p></li>
  </ul>
 </header>
 <!-- pop_header end -->
 <section class="pop_body">
  <!-- pop_body start -->
  <aside class="title_line">
   <!-- title_line start -->
  </aside>
  <!-- title_line end -->
  <section class="search_table">
   <!-- search_table start -->
   <form action="#" method="post" id="form">
    <table class="type1">
     <!-- table start -->
     <caption>table</caption>
     <colgroup>
      <col style="width: 180px" />
      <col style="width: *" />
      <col style="width: 180px" />
      <col style="width: *" />
     </colgroup>
     <tbody>
      <tr>
       <th scope="row"><spring:message code='service.title.ReportType'/> <span class="must">*</span></th>
       <td><select class="w100p" id="cmbListingType" name="cmbListingType">
         <option value=""><spring:message code='sal.combo.text.chooseOne'/></option>
         <c:forEach var="list" items="${rptTypList}" varStatus="status">
           <c:choose>
             <c:when test="${list.code=='1'}">
               <option value="${list.code}" selected>${list.codeName}</option>
             </c:when>
             <c:otherwise>
               <option value="${list.code}">${list.codeName}</option>
             </c:otherwise>
           </c:choose>
         </c:forEach>
       </select></td>
       <th scope="row"><spring:message code='log.head.settledate'/> <span class="must">*</span></th>
       <td>
        <div class="date_set w100p">
         <p>
          <input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" id="dpHSSettleDateFrom" />
         </p>
         <span><spring:message code="sal.title.to" /></span>
         <p>
          <input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" id="dpHSSettleDateTo" />
         </p>
        </div>
        <!-- date_set end -->
       </td>
      </tr>
      <tr>
       <th scope="row"><spring:message code='sal.title.text.returnStatus'/> <span class="must">*</span></th>
       <!-- <td><select class="multy_select w100p" multiple="multiple" id="cmbReturnStatus">  -->
       <td><select class="multy_select w100p" multiple="multiple" id="cmbReturnStatus" name="cmbReturnStatus">
         <c:forEach var="list" items="${rtnStat}" varStatus="status">
           <option value="${list.code}" selected>${list.codeName}</option>
         </c:forEach>
         </select>
       </td>
       <th scope="row"><spring:message code='service.grid.ASTyp'/></th>
       <td>
         <label><input type="radio" name="asTypPop" value="*" checked="checked" /><span>All</span></label>
         <label><input type="radio" name="asTypPop" value="as" /><span>AS</span></label>
         <label><input type="radio" name="asTypPop" value="ihr" /><span>IHR</span></label>
       </td>
      </tr>
      <tr>
       <th scope="row"><spring:message code='log.head.branch'/> <span class="must">*</span></th>
       <td><select class="w100p" id="cmbBranchCode" name="cmbBranchCode"></select></td>
       <th scope="row"><spring:message code='log.label.lctGrade'/> <span class="must">*</span></th>
       <td><select class="w100p" id="cmbDepartmentCode" onchange="cmbDepartmentCode_SelectedIndexChanged()"></select></td>
      </tr>
      <tr>
       <th scope="row"><spring:message code='log.head.location'/> <span id="m6" name="m6" class="must" style="display:none">*</span></th>
       <td><select class="w100p" id="cmbCodyCode" name="cmbCodyCode"></select></td>
       <th scope="row"></th>
       <td></td>
      </tr>
     </tbody>
    </table>
    <!-- table end -->
    <ul class="center_btns">
     <li><p class="btn_blue2">
       <a href="#" onclick="btnGeneratePDF_Click()"><spring:message
         code="service.btn.Generate" /></a>
      </p></li>
     <li><p class="btn_blue2">
       <a href="#" onclick="javascript:$('#form').clearForm();"><spring:message
         code="sal.btn.clear" /></a>
      </p></li>
    </ul>
    <input type="hidden" id="reportFileName" name="reportFileName" value="" />
    <input type="hidden" id="viewType" name="viewType" value="" />
    <input type="hidden" id="reportDownFileName" name="reportDownFileName" value="" />
    <input type="hidden" id="V_WHERESQL" name="V_WHERESQL" value="" />
    <input type="hidden" id="V_HSSETTLEDATEFROM" name="V_HSSETTLEDATEFROM" value="" />
    <input type="hidden" id="V_HSSETTLEDATETO" name="V_HSSETTLEDATETO" value="" />
    <input type="hidden" id="V_RETSTATUS" name="V_RETSTATUS" value="" />
    <input type="hidden" id="V_WAREHOUSECODE" name="V_WAREHOUSECODE" value="" />
    <input type="hidden" id="V_DEPTCODE" name="V_DEPTCODE" value="" />
    <input type="hidden" id="V_CODYCODE" name="V_CODYCODE" value="" />
    <input type="hidden" id="V_ASTYP" name="V_ASTYP" value="" />
    <input type="hidden" id="V_ORDERBYSQL" name="V_ORDERBYSQL" value="" />
    <input type="hidden" id="V_SELECTSQL" name="V_SELECTSQL" value="" />
    <input type="hidden" id="V_FULLSQL" name="V_FULLSQL" value="" />
   </form>
  </section>
  <!-- content end -->
 </section>
 <!-- container end -->
</div>
<!-- popup_wrap end -->