<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<style type="text/css">
.master-style {
  background: #ADD8E6;
  font-weight: bold;
  color: #22741C;
}

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

.master-selected-style {
  background: #FFFF00;
  font-weight: bold;
  color: #22741C;
}

.master-nonselected-style {
  background: #FFFFFF;
  font-weight: normal;
  color: #22741C;
}
</style>

<script type="text/javaScript" language="javascript">
  var myGridID;
  var myMasterGridID;
  var gridValue;

  function createAUIGrid() {
    var columnLayout = [ {
      dataField : "c1",
      headerText : " ",
      width : "5%"
    }, {
      dataField : "ind",
      headerText : "",
      width : 10,
      visible : false,
    }, {
      dataField : "clmNo",
      headerText : "Claim No",
      width : 100
    }, {
      dataField : "clmDt",
      headerText : "Claim Date",
      width : 120
    }, {
      dataField : "memCde",
      headerText : "Member Code",
      width : 120
    }, {
      dataField : "salesOrdNo",
      headerText : "Sales Order No.",
      width : 120
    }, {
      dataField : "brCde",
      headerText : "Branch Code",
      width : 120
    }, {
      dataField : "srvNo",
      headerText : "Service No.",
      width : 120
    }, {
      dataField : "jobLatt",
      headerText : "Job Latitude",
      width : 180
    }, {
      dataField : "jobLongt",
      headerText : "Job Longtitude",
      width : 180
    }, {
      dataField : "instLatt",
      headerText : "Inst. Latitude",
      width : 180,
      visible : false,
    }, {
      dataField : "instLongt",
      headerText : "Inst. Longtitude",
      width : 180,
      visible : false,
    }, {
      dataField : "ttlMil",
      headerText : "Total Mileage",
      width : 120,
      formatString : "#,##0.00"
    }, {
      dataField : "ttlTrvDist",
      headerText : "Total Travel Time",
      width : 120,
      formatString : "#,##0.00"
    }, {
      dataField : "ttlAmt",
      headerText : "Total Amount",
      width : 120,
      formatString : "#,##0.00"
    }, {
      dataField : "rmk",
      headerText : "Remark",
      width : 200
    }, {
      dataField : "undefined",
      headerText : "View",
      width : 150,
      visible : false,

      renderer : {
        type : "ButtonRenderer",
        labelText : "Edit",
        onclick : function(rowIndex, columnIndex, value, item) {
        }
      }
    } ];

    var columnLayoutMaster = [ {
      dataField : "memId",
      headerText : "Member ID",
      width : 120,
      visible : false
    }, {
      dataField : "memCde",
      headerText : "Member Code",
      width : 120
    }, {
      dataField : "memNm",
      headerText : "Member Name",
      width : 300
    }, {
      dataField : "brCde",
      headerText : "Branch Code",
      width : 120
    }, {
      dataField : "brNm",
      headerText : "Branch Name",
      width : 300
    }, {
      dataField : "ttlMil",
      headerText : "Total Mileage",
      width : 200,
      formatString : "#,##0.00"
    }, {
      dataField : "ttlTrvDist",
      headerText : "Total Travel Time",
      width : 200,
      formatString : "#,##0.00"
    }, {
      dataField : "ttlAmt",
      headerText : "Total Amount",
      width : 200,
      formatString : "#,##0.00"
    } ];

    var footerLayout = [ {
      labelText : "∑",
      positionField : "#base",
      style : "aui-grid-my-column"
    }, {
      dataField : "ttlMil",
      positionField : "ttlMil",
      operation : "SUM",
      formatString : "#,##0.00"
    }, {
      dataField : "ttlTrvDist",
      positionField : "ttlTrvDist",
      operation : "SUM",
      formatString : "#,##0.00"
    }, {
      dataField : "ttlAmt",
      positionField : "ttlAmt",
      operation : "SUM",
      formatString : "#,##0.00"
    } ];

    var gridPros = {
      treeLazyMode : true,
      selectionMode : "singleRow",
      displayTreeOpen : true,
      flat2tree : true
    };

    var gridProsMaster = {
      usePaging : true,
      pageRowCount : 20,
      //editable : true,
      showStateColumn : false,
      //displayTreeOpen : true,
      headerHeight : 30,
      skipReadonlyColumns : true,
      wrapSelectionMove : true,
      showRowNumColumn : true,
      showFooter : true
    };

    myGridID = AUIGrid.create("#grid_wrap", columnLayout, gridPros);

    myMasterGridID = AUIGrid.create("#grid_wrapMaster", columnLayoutMaster,
        gridProsMaster);
    AUIGrid.setFooter(myMasterGridID, footerLayout);

    AUIGrid.bind(myGridID, "treeLazyRequest", function(event) {
      var item = event.item;

      $.ajax({
        url : "/services/miles/getMilesMeasDetailList.do?clmNo="
            + item.clmNo,
        success : function(data) {
          event.response(data);
        }
      });
    });
  }

  $(document).ready(
      function() {
        doGetComboSepa('/common/selectBranchCodeList.do', '5', ' - ',
            '', 'branchId', 'M', 'f_multiCombo');

        date();

        createAUIGrid();
        AUIGrid.setSelectionMode(myGridID, "singleRow");

        fn_getMilesMeasList();

        $('#memTyp').change(
            function() {
              if ($('#memTyp').val() == 'CD') {
                doGetComboSepa(
                    '/common/selectBranchCodeList.do', '4',
                    ' - ', '', 'branchId', 'M',
                    'f_multiCombo');
              } else if ($('#memTyp').val() == 'CT') {
                doGetComboSepa(
                    '/common/selectBranchCodeList.do', '5',
                    ' - ', '', 'branchId', 'M',
                    'f_multiCombo');
              } else if ($('#memTyp').val() == 'HP') {
                doGetComboSepa(
                    '/common/selectBranchCodeList.do',
                    '45', ' - ', '', 'branchId', 'M',
                    'f_multiCombo');
              } else if ($('#memTyp').val() == 'HT') {
                doGetComboSepa(
                    '/common/selectBranchCodeList.do',
                    '48', ' - ', '', 'branchId', 'M',
                    'f_multiCombo');
              } else {
                doGetComboSepa(
                    '/common/selectBranchCodeList.do',
                    '10', ' - ', '', 'branchId', 'M',
                    'f_multiCombo');
              }
            });
      });

  function f_multiCombo() {
    $('#branchId').change(function() {
    }).multipleSelect({
      selectAll : true,
      width : '100%'
    });
  }

  function date() {
    var today = new Date();
    var mm = today.getMonth();
    var yyyy = today.getFullYear();

    if (mm < 10) {
      mm = '0' + mm;
    }

    $("#startDt").val('21' + '/' + mm + '/' + yyyy);

    var today2 = new Date();
    today2.setDate(today2.getDate());
    var mm2 = today2.getMonth() + 1;
    var yyyy2 = today2.getFullYear();

    if (mm2 < 10) {
      mm2 = '0' + mm2;
    }

    $("#endDt").val('20' + '/' + mm2 + '/' + yyyy2);
  }

  function fn_getMilesMeasList() {
    if ($('#startDt').val() == "") {
      Common
          .alert("<spring:message code='sys.msg.necessary' arguments='Date Range (Start Date)' htmlEscape='false'/>");
      return;
    }

    if ($('#endDt').val() == "") {
      Common
          .alert("<spring:message code='sys.msg.necessary' arguments='Date Range (End Date)' htmlEscape='false'/>");
      return;
    }

    Common.ajax("GET", "/services/miles/getMilesMeasMasterList.do", $(
        "#searchForm").serialize(), function(result) {
      AUIGrid.clearGridData(myMasterGridID);
      AUIGrid.clearGridData(myGridID);

      AUIGrid.setGridData(myMasterGridID, result);

      AUIGrid.bind(myMasterGridID, "cellDoubleClick", function(event) {
        var memCde = AUIGrid.getCellValue(myMasterGridID,
            event.rowIndex, "memId");
        $("#hidClmNo").val(memCde);

        AUIGrid.setProp(myMasterGridID, "rowStyleFunction", function(
            rowIndex, item) {
          if (rowIndex == event.rowIndex) {
            return "master-selected-style";
          } else {
            return "master-nonselected-style";
          }
        });

        Common.ajax("GET", "/services/miles/getMilesMeasList.do", $(
            "#searchForm").serialize(), function(result) {
          AUIGrid.setGridData(myGridID, result);

          AUIGrid.setProp(myGridID, "rowStyleFunction", function(
              rowIndex, item) {
            if (item.ind == "M") {
              return "master-style";
            }

            if (item.srvNo == "S") {
              return "sub-start-style";
            }

            if (item.srvNo == "E") {
              return "sub-end-style";
            }
          });

        });
        AUIGrid.update(myMasterGridID);
      });
    });
  }

  function fn_excelDown(indicator) {
    GridCommon.exportTo(indicator, "xlsx", "Mileage Measurement");
  }

  function fn_expand(indicator) {
    AUIGrid.expandAll(myGridID);
  }

  function fn_milesMeasRaw() {
    Common.popupDiv("/services/miles/goMilesMeasRaw.do",{ind : 'PDO'},null, true, '_insDiv');
  }
</script>
<form id='cForm' name='cForm'></form>
<section id="content">
  <!-- content start -->
  <ul class="path">
    <li>Service</li>
    <li>Mileage Measurement</li>
  </ul>
  <aside class="title_line">
    <h2>Mileage Measurement</h2>
    <ul class="right_btns">
      <c:if test="${PAGE_AUTH.funcView == 'Y'}">
        <li><p class="btn_blue">
            <a href="#" onclick="javascript:fn_getMilesMeasList();"><span
              class="search"></span>Search</a>
          </p></li>
      </c:if>
      <!-- <li><p class="btn_blue"><a href="#"><span class="clear"></span>Clear</a></p></li> -->
    </ul>
  </aside>

  <section class="search_table">
    <form id="searchForm" action="#" method="post">
      <input id="hidClmNo" name="hidClmNo" type="hidden" />
      <table class="type1">
        <caption>table</caption>
        <colgroup>
          <col style="width: 130px" />
          <col style="width: *" />
          <col style="width: 160px" />
          <col style="width: *" />
        </colgroup>
        <tbody>
          <tr>
            <th scope="row">Date Range <span class="must">**</span></th>
            <td>
              <div class="date_set w100p">
                <p>
                  <input id="startDt" name="startDt" type="text"
                    title="Create start Date" placeholder="DD/MM/YYYY"
                    class="j_date" />
                </p>
                <span>To</span>
                <p>
                  <input id="endDt" name="endDt" type="text"
                    title="Create end Date" placeholder="DD/MM/YYYY"
                    class="j_date" />
                </p>
              </div>
            </td>
            <th scope="row">Claim No</th>
            <td><input id="claimID" name="claimID" type="text"
              title="Create start Date" placeholder="Claim ID" class="w100p" />
            </td>
          </tr>
          <tr>
            <th scope="row">Branch Type <span class="must">**</span></th>
            <td><select id="memTyp" name="memTyp" class="w100p">
                <option value="HP">HP - Health Planner</option>
                <option value="CD">CD - Cody</option>
                <option value="CT" selected>CT - Coway Technician</option>
                <option value="HT">HT - Homecare Technician</option>
            </select></td>
            <th scope="row">Branch</th>
            <td><select id="branchId" name="branchId"
              class="multy_select w100p" multiple="multiple"></select></td>
          </tr>
          <tr>
            <th scope="row">Member Code</th>
            <td><input id="memCode" name="memCode" type="text" title=""
              placeholder="Member Code" class="w100p" /></td>
            <th scope="row"></th>
            <td></td>
          </tr>
        </tbody>
      </table>
      <aside class="link_btns_wrap">
        <p class="show_btn">
          <a href="#"> <img
            src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif"
            alt="link show" /></a>
        </p>
        <dl class="link_list">
          <dt>
            <spring:message code="sal.title.text.link" />
          </dt>
          <dd>
            <ul class="btns">
              <c:if test="${PAGE_AUTH.funcUserDefine3 == 'Y'}">
                <li>
                  <p class="link_btn type2">
                    <!-- <a href="#" onclick="fn_custDelInfo()"><spring:message code='supplement.btn.custDelInfo'/></a> -->
                    <a href="#" onclick="fn_milesMeasRaw()">Mileage Measurement Raw Report</a>
                  </p>
                </li>
              </c:if>
            </ul>
            <p class="hide_btn">
              <a href="#"> <img
                src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif"
                alt="hide" /></a>
            </p>
          </dd>
        </dl>
      </aside>
    </form>
  </section>

  <ul class="right_btns">
    <c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
      <li><p class="btn_grid">
          <a href="#" onClick="fn_excelDown('grid_wrapMaster')"><spring:message
              code='service.btn.Generate' /></a>
        </p></li>
    </c:if>
  </ul>

  <br />

  <section class="search_resultMaster">
    <section class="">
      <article>
        <div id="grid_wrapMaster" style="width: 100%; height: 300px;"></div>
      </article>
    </section>
  </section>

  <br />

  <ul class="right_btns">
    <c:if test="${PAGE_AUTH.funcUserDefine2 == 'Y'}">
      <li><p class="btn_grid">
          <a href="#" onClick="fn_excelDown('grid_wrap')"><spring:message
              code='service.btn.Generate' /></a>
        </p></li>
    </c:if>
  </ul>

  <br />

  <section class="search_result">
    <section class="">
      <article>
        <div id="grid_wrap" style="width: 100%; height: 450px;"></div>
      </article>
    </section>
  </section>

</section>
<!-- content end -->