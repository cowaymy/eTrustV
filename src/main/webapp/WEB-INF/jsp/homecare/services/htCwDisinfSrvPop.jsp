<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">
  var userId = '${SESSION_INFO.userId}';
  var MEM_TYPE = '${SESSION_INFO.userTypeId}';

  $(document).ready(function() {

  });

  $("#dataForm").empty();

  var date = new Date().getDate();
  if (date.toString().length == 1) {
    date = "0" + date;
  }
  $("#dpOrderDateFr").val(date + "/" + (new Date().getMonth()) + "/" + new Date().getFullYear());
  $("#dpOrderDateTo").val(date + "/" + (new Date().getMonth() + 1) + "/" + new Date().getFullYear());

  /* 멀티셀렉트 플러그인 start */
  $('.multy_select').change(function() {
    //console.log($(this).val());
  }).multipleSelect({
    width : '100%'
  });

  $.fn.clearForm = function() {
    //$("#cmbAppType").multipleSelect("checkAll");

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
      $("#dpOrderDateFr").val(date + "/" + (new Date().getMonth() + 1) + "/" + new Date().getFullYear());
      $("#dpOrderDateTo").val(date + "/" + (new Date().getMonth() + 1) + "/" + new Date().getFullYear());
      $("#cmbSort").prop("selectedIndex", 2);
    });
  };

  function validRequiredField() {
    var valid = true;
    var message = "";

    if (($("#dpOrderDateFr").val() == null || $("#dpOrderDateFr").val().length == 0) || ($("#dpOrderDateTo").val() == null || $("#dpOrderDateTo").val().length == 0)) {
      valid = false;
      message += '<spring:message code="sal.alert.msg.keyInOrdDateFromTo" />';
    }

    //if ($('#cmbAppType :selected').length < 1) {
    //  valid = false;
    //  message += '<spring:message code="sal.alert.msg.selAtLeastOnAppType" />';
    //}
    //if (!($("#txtOrderNoFr").val().trim() == null || $("#txtOrderNoFr").val().trim().length == 0) || !($("#txtOrderNoTo").val().trim() == null || $("#txtOrderNoTo").val().trim().length == 0)) {
    //  if (($("#txtOrderNoFr").val().trim() == null || $("#txtOrderNoFr").val().trim().length == 0) || ($("#txtOrderNoTo").val().trim() == null || $("#txtOrderNoTo").val().trim().length == 0)) {
    //    valid = false;
    //    message += '<spring:message code="sal.alert.msg.keyInOrdNoFromTo" />';
    //  }
    //}

    if (valid == false) {
      alert(message);
    }

    return valid;

  }

  function btnGenerate_Excel_Click() {
    if (validRequiredField() == true) {
      fn_report("EXCEL");
    } else {
      return false;
    }
  }

  function fn_report(viewType) {

    $("#reportFileName").val("");
    $("#reportDownFileName").val("");
    $("#viewType").val("");

    var orderNoFrom = "";
    var orderNoTo = "";
    var orderDateFrom = "";
    var orderDateTo = "";
    var branchRegion = "";
    var keyInBranch = "";
    var appType = "";
    var sortBy = "";
    var whereSQL = "";
    var extraWhereSQL = "";
    var orderBySQL = "";
    var custName = "";
    var runNo = 0;

    if (!($("#dpOrderDateFr").val() == null || $("#dpOrderDateFr").val().length == 0) && !($("#dpOrderDateTo").val() == null || $("#dpOrderDateTo").val().length == 0)) {

      orderDateFrom = $("#dpOrderDateFr").val(); //dd/MM/yyyy
      orderDateTo = $("#dpOrderDateTo").val();

      var frArr = $("#dpOrderDateFr").val().split("/");
      var toArr = $("#dpOrderDateTo").val().split("/");
      var dpOrderDateFr = frArr[1] + "/" + frArr[0] + "/" + frArr[2]; // MM/dd/yyyy
      var dpOrderDateTo = toArr[1] + "/" + toArr[0] + "/" + toArr[2];

      whereSQL += " AND (A.DISINF_SRV_DT BETWEEN TO_DATE('" + dpOrderDateFr + " 00:00:00', 'MM/dd/YY HH24:MI:SS') AND TO_DATE('" + dpOrderDateTo + " 23:59:59', 'MM/dd/YY HH24:MI:SS'))";
    }

    //if ($('#cmbAppType :selected').length > 0) {
    //  whereSQL += " AND (";

    //  $('#cmbAppType :selected').each(
    //      function(i, mul) {
    //        if (runNo > 0) {
    //          whereSQL += " OR som.APP_TYPE_ID = '" + $(mul).val() + "' ";
    //          appType += ", " + $(mul).text();
    //        } else {
    //          whereSQL += " som.APP_TYPE_ID = '" + $(mul).val() + "' ";
    //          appType += $(mul).text();
    //        }
    //        runNo += 1;
    //      });
    //  whereSQL += ") ";
    //}
    runNo = 0;

    //var txtOrderNoFr = $("#txtOrderNoFr").val().trim();
    //var txtOrderNoTo = $("#txtOrderNoTo").val().trim();
    //if (!(txtOrderNoFr == null || txtOrderNoFr.length == 0) && !(txtOrderNoTo == null || txtOrderNoTo.length == 0)) {
    //  orderNoFrom = txtOrderNoFr;
    //  orderNoTo = txtOrderNoTo;
    //  whereSQL += " AND (som.SALES_ORD_NO BETWEEN '" + txtOrderNoFr + "' AND '" + txtOrderNoTo + "')";
    //}
    if ($("#cmbKeyBranch :selected").index() > 0) {
      keyInBranch = $("#cmbKeyBranch :selected").val();
      whereSQL += " AND C.BRNCH = '" + $("#cmbKeyBranch :selected").val() + "'";
    }

    if ($("#cmbSort :selected").index() > -1) {
      sortBy = $("#cmbSort :selected").text();

      if ($("#cmbSort :selected").val() == "1") {
        orderBySQL = " ORDER BY som.SRV_ORD_NO ";
      } else if ($("#cmbSort :selected").val() == "2") {
        orderBySQL = " ORDER BY D.CODE, D.NAME, som.SRV_ORD_NO ";
      } else if ($("#cmbSort :selected").val() == "3") {
        orderBySQL = " ORDER BY A.DISINF_SRV_DT, som.SRV_ORD_NO ";
      } else if ($("#cmbSort :selected").val() == "4") {
        orderBySQL = " ORDER BY som.SRV_ORD_NO ";
      }
    }

    var date = new Date().getDate();
    if (date.toString().length == 1) {
      date = "0" + date;
    }
    $("#reportDownFileName").val("CDSRawData_" + date + (new Date().getMonth() + 1) + new Date().getFullYear());

    if (viewType == "EXCEL") {
      $("#form #viewType").val("EXCEL");
      $("#form #reportFileName").val("/homecare/htCDSRaw_Excel.rpt");
    }

    $("#form #V_ORDERNOFROM").val(orderNoFrom);
    $("#form #V_ORDERNOTO").val(orderNoTo);
    $("#form #V_ORDERDATEFROM").val(orderDateFrom);
    $("#form #V_ORDERDATETO").val(orderDateTo);
    $("#form #V_BRANCHREGION").val(branchRegion);
    $("#form #V_KEYINBRANCH").val(keyInBranch);
    $("#form #V_APPTYPE").val(appType);
    $("#form #V_CUSTNAME").val(custName);
    $("#form #V_SORTBY").val(sortBy);
    $("#form #V_WHERESQL").val(whereSQL);
    $("#form #V_EXTRAWHERESQL").val(extraWhereSQL);
    $("#form #V_ORDERBYSQL").val(orderBySQL);
    $("#form #V_SELECTSQL").val("");
    $("#form #V_FULLSQL").val("");

    // 프로시져로 구성된 경우 꼭 아래 option을 넘겨야 함.
    var option = {
      isProcedure : true
    // procedure 로 구성된 리포트 인경우 필수.  => /payment/PaymentListing_Excel.rpt 는 프로시져로 구성된 파일임.
    };

    Common.report("form", option);

  }

  CommonCombo.make('cmbKeyBranch', '/sales/ccp/getBranchCodeList', '', '');
  //CommonCombo.make('cmbAppType', '/services/bs/getAppTypeList', {
  //  codeId : 10
  //}, '', {
  //  type : 'M'
  //});
</script>

  <div id="popup_wrap" class="popup_wrap">
  <header class="pop_header">
    <h1>Coway Disinfection Service (CDS) Report</h1>
    <ul class="right_opt">
      <li><p class="btn_blue2">
          <a href="#"><spring:message code="sal.btn.close" /></a>
        </p></li>
    </ul>
  </header>

  <section class="pop_body">
    <aside class="title_line">
    </aside>

    <section class="search_table">
      <form action="#" method="post" id="form" name="form">
        <table class="type1">
          <caption>table</caption>
          <colgroup>
            <col style="width: 180px" />
            <col style="width: *" />
            <col style="width: 180px" />
            <col style="width: *" />
          </colgroup>
          <tbody>
            <tr>
              <th scope="row"><spring:message code="service.title.UpdateDate" /></th>
              <td>
                <div class="date_set w100p">
                  <p>
                    <input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" id="dpOrderDateFr" />
                  </p>
                  <span><spring:message code="sal.title.to" /></span>
                  <p>
                    <input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" id="dpOrderDateTo" />
                  </p>
                </div>
              </td>
              <!-- <th scope="row"><spring:message code="sal.text.appType" /></th>
              <td>
                <select class="multy_select w100p" multiple="multiple" id="cmbAppType"></select>
              </td> -->
            </tr>
            <tr>
              <!-- <th scope="row"><spring:message code="sal.text.ordNum" /></th>
              <td>
                <div class="date_set w100p">
                  <p>
                    <input type="text" title="" placeholder="" class="w100p" id="txtOrderNoFr" />
                  </p>
                  <span><spring:message code="sal.title.to" /></span>
                  <p>
                    <input type="text" title="" placeholder="" class="w100p" id="txtOrderNoTo" />
                  </p>
                </div>
              </td> -->
              <th scope="row"><spring:message code="service.grid.BranchCode" /></th>
              <td><select class="w100p" id="cmbKeyBranch"></select></td>
            </tr>
            <tr>
              <th scope="row"><spring:message code="sal.title.text.sorting" /></th>
              <td>
                <select class="w100p" id="cmbSort">
                  <!-- <option value="1">By Region</option> -->
                  <option value="2"><spring:message code="service.grid.BranchCode" /></option>
                  <option value="3"><spring:message code="service.title.UpdateDate" /></option>
                  <!--<option value="4" selected><spring:message code="sal.combo.text.byOrdNumber" /></option> -->
                </select>
              </td>
            </tr>
          </tbody>
        </table>

        <ul class="center_btns">
          <%-- <li><p class="btn_blue2"><a href="#" onclick="javascript:btnGenerate_Click();"><spring:message code="sal.btn.genPDF" /></a></p></li> --%>
          <li><p class="btn_blue2">
              <a href="#" onclick="javascript:btnGenerate_Excel_Click();"><spring:message code="sal.btn.genExcel" /></a>
            </p>
          </li>
          <li><p class="btn_blue2">
              <a href="#" onclick="javascript:$('#form').clearForm();"><spring:message code="sal.btn.clear" /></a>
            </p>
          </li>
        </ul>

        <input type="hidden" id="reportFileName" name="reportFileName" value="" />
        <input type="hidden" id="viewType" name="viewType" value="" />
        <input type="hidden" id="reportDownFileName" name="reportDownFileName" value="" />
        <input type="hidden" id="V_ORDERNOFROM" name="V_ORDERNOFROM" value="" />
        <input type="hidden" id="V_ORDERNOTO" name="V_ORDERNOTO" value="" />
        <input type="hidden" id="V_ORDERDATEFROM" name="V_ORDERDATEFROM" value="" />
        <input type="hidden" id="V_ORDERDATETO" name="V_ORDERDATETO" value="" />
        <input type="hidden" id="V_BRANCHREGION" name="V_BRANCHREGION" value="" />
        <input type="hidden" id="V_KEYINBRANCH" name="V_KEYINBRANCH" value="" />
        <input type="hidden" id="V_APPTYPE" name="V_APPTYPE" value="" />
        <input type="hidden" id="V_CUSTNAME" name="V_CUSTNAME" value="" />
        <input type="hidden" id="V_SORTBY" name="V_SORTBY" value="" />
        <input type="hidden" id="V_WHERESQL" name="V_WHERESQL" value="" />
        <input type="hidden" id="V_EXTRAWHERESQL" name="V_EXTRAWHERESQL" value="" />
        <input type="hidden" id="V_ORDERBYSQL" name="V_ORDERBYSQL" value="" />
        <input type="hidden" id="V_SELECTSQL" name="V_SELECTSQL" value="" />
        <input type="hidden" id="V_FULLSQL" name="V_FULLSQL" value="" />
      </form>
    </section>
  </section>
  </div>
