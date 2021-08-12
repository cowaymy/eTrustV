<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javaScript">
  $(document).ready(function() {
    createHSReportListAUIGrid();

    AUIGrid.bind(myGridID, "cellClick", function(event) {
      BSNo = AUIGrid.getCellValue(myGridID, event.rowIndex, "no");
    });

    $('#hsMonth').val($.datepicker.formatDate('mm/yy', new Date()));

    //fn_HSReportCustSignList();
  });

  var myGridIDCustSign;
  function createHSReportListAUIGrid() {
    //AUIGrid 칼럼 설정
    var columnLayout = [ {
        dataField : "schdulId",
        headerText : "",
        editable : false,
        width : 130,
        visible : false
      }, {
      dataField : "no",
      headerText : "HS No",
      editable : false,
      width : 130
    }, {
      dataField : "month",
      headerText : "BS Month",
      editable : false,
      width : 180
    }, {
      dataField : "year",
      headerText : "HS Year",
      editable : false,
      width : 180
    }, {
      dataField : "code",
      headerText : "BS Status",
      editable : false,
      width : 100
    }, {
      dataField : "c3",
      headerText : "Result No",
      editable : false,
      style : "my-column",
      width : 180
    }, {
      dataField : "salesOrdNo",
      headerText : "Order No",
      editable : false,
      width : 250
    }, {
      dataField : "code1",
      headerText : "App Type",
      editable : false,
      width : 150

    }, {
      dataField : "c8",
      headerText : "Inchange Member",
      editable : false,
      width : 100
    } ];

    var gridPros = {
      usePaging : true,
      pageRowCount : 20,
      editable : false,
      showStateColumn : false,
      displayTreeOpen : false,
      selectionMode : "singleRow",
      headerHeight : 30,
      useGroupingPanel : false,
      skipReadonlyColumns : true,
      wrapSelectionMove : true,
      showRowNumColumn : true,
      showRowCheckColumn : true,
      showRowAllCheckBox : true
    };

    myGridIDCustSign = AUIGrid.create("#grid_wrap_HSReportCustSign", columnLayout, gridPros);
  }

  function fn_HSReportCustSignList() {
    if ($("#hsMonth").val() == "") {
      if ($("#orderNumber").val() == "" && $("#hsNumber").val() == "") {
        Common.alert("HS Month or HS Order or Sales Order are required.");
        return false;
      }
    } else {
      if ($("#orderNumber").val() == "" && $("#hsNumber").val() == "" && ($("#memberCode").val()) == "") {
        if ($("#settleDtFrm").val() == "" && $("#settleDtTo").val() == "") {
          Common.alert("Settle Date are required.");
          return false;
        } else {
          var d1 = ($("#settleDtFrm").val()).split("/");
          var d2 = ($("#settleDtTo").val()).split("/");
          var dt1 = new Date(d1[1] + '/' + d1[0] + '/' + d1[2]);
          var dt2 = new Date(d2[1] + '/' + d2[0] + '/' + d2[2]);
          var Difference_In_Time = dt2.getTime() - dt1.getTime();
          var Difference_In_Days = Difference_In_Time / (1000 * 3600 * 24);

           if(Difference_In_Days > 10) {
              Common.alert("Date range for settle date must within 10 days.");
              return false;
           }
        }
      }
    }

    Common.ajax("GET", "/services/bs/report/selectHSReportCustSign.do", $("#searchHsReport").serialize(), function(result) {
      AUIGrid.setGridData(myGridIDCustSign, result);
    });
  }

  function fn_Generate() {
    var checkedItems = AUIGrid.getCheckedRowItemsAll(myGridIDCustSign);
    var prm1 = "";
    var prm2 = "";
    var prm3 = "";
    var prm4 = "";
    var prm5 = "";
    var prm6 = "";

    var totalRow = AUIGrid.getRowCount(myGridIDCustSign);

   //if (checkedItems.length != totalRow) {
      if (checkedItems.length > 50) {
        Common.alert("Total selected record exist its limit. Please reduce your selected record");
        return;
      }
    //}

    if (checkedItems.length <= 0) {
      Common.alert("<spring:message code='service.msg.selectRcd' />");
      return;
    }

    if (checkedItems.length == totalRow) {
      if ($("#hsMonth").val() != "") {
        prm1 = "AND ( A.YEAR = TO_NUMBER(TO_CHAR(TO_DATE('" + $("#hsMonth").val() + "','mm/yyyy'), 'yyyy')) ) ";
        prm1 += "AND ( A.MONTH = TO_NUMBER(TO_CHAR(TO_DATE('" + $("#hsMonth").val() + "','mm/yyyy'), 'mm')) )";
      }

      if ($("#orderNumber").val() != "") {
        prm2 = "AND C.SALES_ORD_NO = '" + $("#orderNumber").val() + "'";
      }

      if ($("#hsNumber").val()  != "") {
        prm3 = "AND A.NO = UPPER('" + $("#hsNumber").val() +"')";
      }

      if ($("#memberCode").val()  != "") {
        prm4 = "AND E.MEM_CODE = UPPER('" + $("#memberCode").val() + "')";
      }

      if ($("#settleDtFrm").val()  != "" && $("#settleDtTo").val() != "") {
        prm6 = "AND (TO_CHAR(B.SETL_DT, 'yyyymmdd') >= TO_CHAR(TO_DATE('" + $("#settleDtFrm").val() + "', 'dd/mm/yyyy'), 'yyyymmdd') ";
        prm6 += "AND TO_CHAR(B.SETL_DT, 'yyyymmdd') <= TO_CHAR(TO_DATE('" + $("#settleDtTo").val() + "', 'dd/mm/yyyy'), 'yyyymmdd')) ";
      }

    } else {
      var itm = "";
      var rowItem = "";
      var schdulId = "";
      for (var i = 0, len = checkedItems.length; i < len; i++) {
        rowItem = checkedItems[i];
        schdulId = rowItem.schdulId;
        if (i == 0) {
          itm = "'" + schdulId + "'";
        } else {
          itm += ",'" + schdulId + "'";
        }
      }
      prm5 = "AND A.SCHDUL_ID IN (" + itm + ") ";

      if ($("#hsMonth").val() != "") {
        prm1 = "AND ( A.YEAR = TO_NUMBER(TO_CHAR(TO_DATE('" + $("#hsMonth").val() + "','mm/yyyy'), 'yyyy')) )";
        prm1 += "AND ( A.MONTH = TO_NUMBER(TO_CHAR(TO_DATE('" + $("#hsMonth").val() + "','mm/yyyy'), 'mm')) )";
      }
    }

    var date = new Date();
    var month = date.getMonth() + 1;
    var day = date.getDate();
    if (date.getDate() < 10) {
      day = "0" + date.getDate();
    }

    $("#searchHsReport #prm1").val(prm1);
    $("#searchHsReport #prm2").val(prm2);
    $("#searchHsReport #prm3").val(prm3);
    $("#searchHsReport #prm4").val(prm4);
    $("#searchHsReport #prm5").val(prm5);
    $("#searchHsReport #prm6").val(prm6);
    $("#searchHsReport #reportFileName").val('/services/HSRptCustSign.rpt');
    $("#searchHsReport #viewType").val("PDF");
    $("#searchHsReport #reportDownFileName").val("HSRptCustSign" + "_" + day + month + date.getFullYear());

    var option = {
      isProcedure : true, // procedure 로 구성된 리포트 인경우 필수.
    };

    Common.report("searchHsReport", option);
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
      }

      $('#hsMonth').val($.datepicker.formatDate('mm/yy', new Date()));
    });
  };
</script>
<div id="popup_wrap" class="popup_wrap">
  <header class="pop_header">
    <h1><spring:message code='service.title.HSManagement' /> - <spring:message code='service.title.HSRptCustSign' /></h1>
    <ul class="right_opt">
      <li><p class="btn_blue2">
          <a href="#"><spring:message code='sys.btn.close' /></a>
        </p></li>
    </ul>
  </header>

  <section class="pop_body">
    <section class="search_table">
      <form action="#" id="searchHsReport">
        <input type="hidden" id="prm1" name="prm1" />
        <input type="hidden" id="prm2" name="prm2" />
        <input type="hidden" id="prm3" name="prm3" />
        <input type="hidden" id="prm4" name="prm4" />
        <input type="hidden" id="prm5" name="prm5" />
        <input type="hidden" id="prm6" name="prm6" />
        <input type="hidden" id="reportFileName" name="reportFileName" />
        <input type="hidden" id="viewType" name="viewType" />
        <input type="hidden" id="reportDownFileName" name="reportDownFileName" value="DOWN_FILE_NAME" />

        <aside class="title_line">
          <ul class="right_btns">
            <li><p class="btn_blue">
                <a href="#" onclick="fn_HSReportCustSignList()">
                  <span class="search"></span><spring:message code='sys.label.search' /></a>
              </p></li>
            <li><p class="btn_blue">
                <a href="#" onclick="$('#searchHsReport').clearForm();">
                  <span class="clear"></span><spring:message code='sys.btn.clear' /></a>
              </p></li>
          </ul>
        </aside>

        <table class="type1">
          <caption>table</caption>
          <colgroup>
            <col style="width: 150px" />
            <col style="width: *" />
            <col style="width: 150px" />
            <col style="width: *" />
          </colgroup>
          <tbody>
            <tr>
              <th scope="row"><spring:message code='svc.hs.reversal.hsNumber' /><span id="m1" name="m1" class="must"> *</span></th>
              <td>
                <input type="text" title="<spring:message code='svc.hs.reversal.hsNumber' />" placeholder="<spring:message code='svc.hs.reversal.hsNumber' />" class="w100p" id="hsNumber" name="hsNumber" />
              </td>
              <th scope="row"><spring:message code='service.grid.HSMth' /><span id="m2" name="m2" class="must"> *</span></th>
              <td>
                <input type="text" title="<spring:message code='service.grid.HSMth' />" placeholder="MM/YYYY" class="j_date2 w100p" id="hsMonth" name="hsMonth" />
               </td>
            </tr>
            <tr>
              <th scope="row"><spring:message code='service.title.OrderNumber' /><span id="m3" name="m3" class="must"> *</span></th>
              <td>
               <input type="text" title="<spring:message code='service.title.OrderNumber' />" placeholder="<spring:message code='service.title.OrderNumber' />" class="w100p" id="orderNumber" name="orderNumber" />
              </td>
              <th scope="row"><spring:message code='sal.text.memberCode' /></th>
              <td>
                <input type="text" title="<spring:message code='sal.text.memberCode' />" placeholder="<spring:message code='sal.text.memberCode' />" class="w100p" id="memberCode" name="memberCode" />
               </td>
            </tr>
            <tr>
              <th scope="row"><spring:message code='service.grid.SettleDate' /><span id="m4" name="m4" class="must"> *</span></th>
              <td>
                <div class="date_set">
                  <p>
                    <input type="text" title="DD/MM/YYYY" placeholder="DD/MM/YYYY" class="j_date" id="settleDtFrm" name="settleDtFrm" />
                  </p>
                  <span>To</span>
                  <p>
                    <input type="text" title="DD/MM/YYYY" placeholder="DD/MM/YYYY" class="j_date" id="settleDtTo" name="settleDtTo" />
                  </p>
                </div>
              </td>
              <th scope="row"></th>
              <td></td>
            </tr>
          </tbody>
        </table>

        <span id='msg' name='msg' class='must' style="color:red;font-weight:bold;font-style: italic">** You only can generate total maximum of 50 selected record(s)</span>

        <article class="grid_wrap">
          <div id="grid_wrap_HSReportCustSign" style="width: 100%; height: 500px; margin: 0 auto;"></div>
        </article>

      </form>
    </section>
    <!-- search_table end -->
    <ul class="center_btns">
      <li><p class="btn_blue2 big">
          <a href="#" onclick="fn_Generate()"><spring:message code='service.btn.Generate' /></a>
        </p></li>
    </ul>
  </section>
  <!-- pop_body end -->

</div>
<!-- popup_wrap end -->
