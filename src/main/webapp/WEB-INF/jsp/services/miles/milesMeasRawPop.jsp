<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<style type="text/css">
.sub-start-style {
  background: #FFD580;
  font-weight: bold;
  color: #22741C;
}

.sub-end-style {
  background: #90EE90;
  font-weight: bold;
  color: #22741C;
}
</style>

<script type="text/javascript">
  var rawGridID;
  createAUIGrid();

  function validRequiredField(){
    var valid = true;
    var message = "";

    var sDate = $('#dpDateRangeFr').val();
    var eDate = $('#dpDateRangeTo').val();

    var dd = "";
    var mm = "";
    var yyyy = "";

    var dateArr;
    dateArr = sDate.split("/");
    var sDt = new Date(Number(dateArr[2]), Number(dateArr[1]) - 1, Number(dateArr[0]));

    dateArr = eDate.split("/");
    var eDt = new Date(Number(dateArr[2]), Number(dateArr[1]) - 1, Number(dateArr[0]));

    var dtDiff = new Date(eDt - sDt);
    var days = dtDiff / 1000 / 60 / 60 / 24;

    if (days > 31) {
      Common.alert("* Date Range should not more than 31 day(s).");
      return false;
    }

    if (($("#dpDateRangeFr").val() == null || $("#dpDateRangeFr").val().length == 0) || ($("#dpDateRangeTo").val() == null || $("#dpDateRangeTo").val().length == 0)){
      valid = false;
      message += '* Date Range (From & To) is required.';
    }

    if (($("#rawMemTyp").val() == null || $("#rawMemTyp").val() == "")){
      valid = false;
      message += '* Branch Type is required.';
    }

    if (($("#rawBranchId").val() == null || $("#rawBranchId").val() == "")){
      valid = false;
      message += '* Branch is required.';
    }

    if(valid == false){
      Common.alert(message);
    }

    return valid;
  }

  function fn_search() {
    if (validRequiredField()) {
      var params = {};

      params["dpDateRangeFr"] =$("#dpDateRangeFr").val();
      params["dpDateRangeTo"] =$("#dpDateRangeTo").val();
      params["rawBranchId"] =$("#rawBranchId").val();
      params["rawMemCode"] =$("#rawMemCode").val();

      params["rawOrdNo"] =$("#rawOrdNo").val();
      params["rawSrvNo"] =$("#rawSrvNo").val();
      params["rawSrvStat"] =$("#rawSrvStat").val();
      params["rawSrvFailAt"] =$("#rawSrvFailAt").val();

      Common.ajax("GET", "/services/miles/getMilesMeasRaw.do", params, function(result) {
        AUIGrid.setProp(rawGridID, "rowStyleFunction", function( rowIndex, item) {
          if (item.rawSrvNo == "S") {
            return "sub-start-style";
          }
          if (item.rawSrvNo == "E") {
            return "sub-end-style";
          }
        });

        AUIGrid.setGridData(rawGridID, result);
      });
      AUIGrid.update(rawGridID);
    }
  }

  function createAUIGrid() {
    var sofColumnLayout = [
    {
      dataField : "rawDscCde",
      headerText : 'DSC CODE',
      width : '10%',
      editable : false
    }, {
      dataField : "rawCtCde",
      headerText : 'MEMBER CODE',
      width : '15%',
      editable : false
    }, {
      dataField : "rawClaimDt",
      headerText : 'CLAIM DATE',
      width : '15%',
      editable : false
    }, {
      dataField : "rawOrdNo",
      headerText : 'ORDER NO.',
      width : '10%',
      style : 'left_style',
      editable : false
    }, {
      dataField : "rawSrvNo",
      headerText : 'SERVICE NO.',
      width : '15%',
      editable : false
    }, {
      dataField : "rawTtlMiles",
      headerText : 'TOTAL MILEAGE',
      width : '15%',
      editable : false,
      formatString : "#,##0.00"
    }, {
      dataField : "rawTmTrav",
      headerText : 'TIME TRAVEL',
      width : '15%',
      editable : false,
      formatString : "#,##0.00"
    }, {
      dataField : "rawTtlAmt",
      headerText : 'TOTAL AMOUNT',
      width : '15%',
      editable : false,
      formatString : "#,##0.00"
    }, {
      dataField : "rawSrvStat",
      headerText : 'SERVICE STATUS',
      width : '15%',
      editable : false
    }, {
      dataField : "rawSrvFailAt",
      headerText : 'FAIL AT (INST. ONLY)',
      width : '25%',
      editable : false
    }];

    var gridPros = {
      showRowAllCheckBox : false,
      usePaging : true,
      pageRowCount : 20,
      headerHeight : 30,
      showRowNumColumn : true,
      showRowCheckColumn : false,
    };

    rawGridID = GridCommon.createAUIGrid("#rawMilesMeas_grid", sofColumnLayout, '', gridPros);
  }

  function excelDown() {
    const today = new Date();
    const day = String(today.getDate()).padStart(2, '0');
    const month = String(today.getMonth() + 1).padStart(2, '0');
    const year = today.getFullYear();

    const date = year + month + day;
    GridCommon.exportTo("rawMilesMeas_grid", "xlsx", "mileageMeasureRawReport_" + date);
  }


  $(document).ready(function() {
    doGetComboSepa('/common/selectBranchCodeList.do', '5', ' - ', '', 'rawBranchId', 'S', 'f_multiCombo');

    $('#rawMemTyp').change(function() {
      if ($('#rawMemTyp').val() == 'CD') {
        doGetComboSepa('/common/selectBranchCodeList.do', '4', ' - ', '', 'rawBranchId', 'S', '');
      } else if ($('#rawMemTyp').val() == 'CT') {
        doGetComboSepa('/common/selectBranchCodeList.do', '5', ' - ', '', 'rawBranchId', 'S', '');
      } else if ($('#rawMemTyp').val() == 'HP') {
        doGetComboSepa('/common/selectBranchCodeList.do', '45', ' - ', '', 'rawBranchId', 'S', '');
      } else if ($('#rawMemTyp').val() == 'HT') {
        doGetComboSepa('/common/selectBranchCodeList.do', '48', ' - ', '', 'rawBranchId', 'S', '');
      } else {
        doGetComboSepa('/common/selectBranchCodeList.do', '10', ' - ', '', 'rawBranchId', 'S', '');
      }
    });
  });
</script>

<div id="popup_wrap" class="popup_wrap">
  <header class="pop_header">
    <h1>Mileage Measurement Raw Report</h1>
    <ul class="right_opt">
      <li><p class="btn_blue2"><a href="#" onclick="javascript:fn_search();"><spring:message code="sales.btn.search" /></a></p></li>
      <li><p class="btn_blue2"><a href="#"><spring:message code="sal.btn.close" /></a></p></li>
    </ul>
  </header>

  <section class="pop_body">
    <aside class="title_line"></aside>
  <section class="search_table">
  <form id="searchForm2">
    <table class="type1">
      <caption>table</caption>
      <colgroup>
        <col style="width:180px" />
        <col style="width:*" />
        <col style="width:180px" />
        <col style="width:*" />
      </colgroup>
      <tbody>
        <tr>
          <th scope="row">Date Range <span class="must">**</span></th>
          <td>
            <div class="date_set w100p">
              <p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" id="dpDateRangeFr" value="${bfDay}"/></p>
              <span><spring:message code="sal.title.to" /></span>
              <p><input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" id="dpDateRangeTo" value="${toDay}"/></p>
            </div>
          </td>
          <th scope="row">Branch Type <span class="must">**</span></th>
          <td>
            <select id="rawMemTyp" name="rawMemTyp" class="w100p">
              <option value="HP">HP - Health Planner</option>
              <option value="CD">CD - Cody</option>
              <option value="CT" selected>CT - Coway Technician</option>
              <option value="HT">HT - Homecare Technician</option>
            </select>
          </td>
        </tr>
        <tr>
          <th scope="row">Branch <span class="must">**</span></th>
          <td>
            <select id="rawBranchId" name="rawBranchId" class="w100p"></select>
          </td>
          <th scope="row">Member Code</th>
          <td>
            <input id="rawMemCode" name="rawMemCode" type="text" title="" placeholder="Member Code" class="w100p" />
          </td>
        </tr>
        <tr>
          <th scope="row">Order No.</th>
          <td>
            <input id="rawOrdNo" name="rawOrdNo" type="text" title="" placeholder="Order No" class="w100p" />
          </td>
          <th scope="row">Service No.</th>
          <td>
            <input id="rawSrvNo" name="rawSrvNo" type="text" title="" placeholder="Service No." class="w100p" />
          </td>
        </tr>
        <tr>
          <th scope="row">Service Status</th>
          <td>
            <select id="rawSrvStat" name="rawSrvStat" class="w100p">
              <option value="">Choose One</option>
              <c:forEach var="list" items="${srvStat}" varStatus="status">
                <option value="${list.stusCodeId}">${list.code}</option>
              </c:forEach>
            </select>
          </td>
          <th scope="row">Fail at (For Installation Only). </th>
          <td>
            <select id="rawSrvFailAt" name="rawSrvFailAt" class="w100p">
              <option value="">Choose One</option>
              <c:forEach var="list" items="${srvFailInst}" varStatus="status">
                <option value="${list.stusCodeId}">${list.code}</option>
              </c:forEach>
            </select>
          </td>
        </tr>
      </tbody>
    </table>

    <section class="search_result">
      <ul class="right_btns">
        <li>
          <p class="btn_grid">
            <a href="#" id="excelDown" onclick="excelDown()"><spring:message code="sal.btn.genExcel" /></a>
          </p>
        </li>
      </ul>
      <aside class="title_line">
      </aside>
      <article class="grid_wrap">
        <div id="rawMilesMeas_grid" style="width: 100%; height: 440px; margin: 0 auto;"></div>
      </article>
    </section>
  </form>
  </section>
  </section>
</div>