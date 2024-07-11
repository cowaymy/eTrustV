<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javascript">
  var supplementGridID;
  var supplementItmGridID;
  var excelListGridID;

  $(document).ready(
      function() {
        createAUIGrid();
        createSupplementItmGrid();

        AUIGrid.bind(supplementGridID, "cellClick", function(event) {
          AUIGrid.clearGridData(supplementItmGridID);

          $("#_itmDetailGridDiv").css("display", "");

          var detailParam = {
            supSubmId : event.item.supOrdNo
          };

          Common.ajax("GET","/supplement/cancellation/selectSupplementItmList", detailParam, function(result) {
            AUIGrid.setGridData(supplementItmGridID, result);
            AUIGrid.resize(supplementItmGridID);
          });
        });

      });

  function createAUIGrid() {
    var supplementColumnLayout = [
        {
           dataField : "canReqId",
           headerText : '',
           width : '10%',
           editable : false,
           visible : false
        },
        {
          dataField : "supCancReqNo",
          headerText : '<spring:message code="supplement.text.supplementCanReqNo" />',
          width : '10%',
          editable : false
        },
        {
          dataField : "supCancDt",
          headerText : '<spring:message code="supplement.text.supplementCanDt" />',
          width : '10%',
          editable : false,
          visible : false
        },
        {
          dataField : "supCancBy",
          headerText : '<spring:message code="supplement.text.cancBy" />',
          width : '5%',
          editable : false
        },
        {
          dataField : "supOrdNo",
          headerText : '<spring:message code="supplement.text.supplementReferenceNo" />',
          width : '10%',
          editable : false
        },
        {
          dataField : "supRefStatCde",
          headerText : '',
          width : '15%',
          editable : false,
          visible : false
        },
        {
          dataField : "supRefStat",
          headerText : '<spring:message code="supplement.text.supplementReferenceStatus" />',
          width : '15%',
          editable : false
        },
        {
          dataField : "supRefStgCde",
          headerText : '',
          width : '15%',
          editable : false,
          visible : false
        },
        {
          dataField : "supRefStg",
          headerText : '<spring:message code="supplement.text.supplementReferenceStage" />',
          width : '15%',
          editable : false
        },
        {
          dataField : "supCustNm",
          headerText : '<spring:message code="sal.text.custName" />',
          width : '10%',
          editable : false
        },
        {
          dataField : "supCustNric",
          headerText : '<spring:message code="sal.text.nricCompanyNo" />',
          width : '10%',
          editable : false
        },
        {
          dataField : "supRtnNo",
          headerText : '<spring:message code="sal.title.text.returnNo" />',
          width : '10%',
          editable : false
        },
        {
          dataField : "supRtnStatCde",
          headerText : '',
          width : '5%',
          editable : false,
          visible : false
        },
        {
          dataField : "supRtnStat",
          headerText : '<spring:message code="sal.title.text.returnStatus" />',
          width : '10%',
          editable : false
        },
        {
          dataField : "supPrcTrkNo",
          headerText : '<spring:message code="supplement.text.parcelTrackingNo" />',
          width : '10%',
          editable : false
        },
        {
          dataField : "supRtnPrcTrkNo",
          headerText : '<spring:message code="supplement.text.supplementPrcRtnTrcNo" />',
          width : '10%',
          editable : false
        },
        {
          dataField : "lstUpdBy",
          headerText : '<spring:message code="sal.text.lastUpdateBy" />',
          width : '10%',
          editable : false
        },
        {
          dataField : "lstUpdDt",
          headerText : '<spring:message code="sal.text.lastUpdateAt" />',
          width : '10%',
          editable : false
        }
    ];

    var gridPros = {
      usePaging : true,
      pageRowCount : 10,
      fixedColumnCount : 1,
      showStateColumn : true,
      displayTreeOpen : false,
      headerHeight : 30,
      useGroupingPanel : false,
      skipReadonlyColumns : true,
      wrapSelectionMove : true,
      showRowNumColumn : true
    };

    supplementGridID = GridCommon.createAUIGrid("#supplement_grid_wrap", supplementColumnLayout, '', gridPros);
  }

  function createSupplementItmGrid() {
    var supplementItmColumnLayout = [
        {
          dataField : "stkCode",
          headerText : '<spring:message code="sal.title.itemCode" />',
          width : '10%',
          editable : false
        },
        {
          dataField : "stkDesc",
          headerText : '<spring:message code="sal.title.itemDesc" />',
          width : '60%',
          editable : false
        },
        {
          dataField : "supItmQty",
          headerText : '<spring:message code="sal.title.qty" />',
          width : '10%',
          editable : false
        },
        {
          dataField : "supItmUntprc",
          headerText : '<spring:message code="sal.title.unitPrice" />',
          width : '10%',
          dataType : "numeric",
          formatString : "#,##0.00",
          editable : false
        },
        {
          dataField : "supTotAmt",
          headerText : '<spring:message code="sal.text.totAmt" />',
          width : '10%',
          dataType : "numeric",
          formatString : "#,##0.00",
          editable : false,
          expFunction : function(rowIndex, columnIndex, item,
              dataField) {
            var calObj = fn_calculateAmt(item.supItmUntprc,
                item.supItmQty);
            return Number(calObj.subTotal);
          }
        }, {
          dataField : "supItmId",
          visible : false
        }, {
          dataField : "supRefId",
          visible : false
        } ];

    var itmGridPros = {
      showFooter : true,
      usePaging : true,
      pageRowCount : 10,
      fixedColumnCount : 1,
      showStateColumn : true,
      displayTreeOpen : false,
      headerHeight : 30,
      useGroupingPanel : false,
      skipReadonlyColumns : true,
      wrapSelectionMove : true,
      showRowNumColumn : true
    };

    supplementItmGridID = GridCommon.createAUIGrid("#supplement_itm_grid_wrap", supplementItmColumnLayout, '', itmGridPros);
    AUIGrid.resize(supplementItmGridID, 960, 300);
    var footerLayout = [ {
      labelText : "Total",
      positionField : "#base"
    }, {
      dataField : "supSubmTotAmt",
      positionField : "supSubmTotAmt",
      operation : "SUM",
      formatString : "#,##0.00",
      style : "aui-grid-my-footer-sum-total2"
    } ];

    AUIGrid.setFooter(supplementItmGridID, footerLayout);
  }

  $(function() {
    $('#_btnSearch').click(function() {
      if (fn_validSearchList())
        fn_getSupplementSubmissionList();
    });

    $("#rtnQtyUpd").click(
      function() {
        var rowIdx = AUIGrid.getSelectedIndex(supplementGridID)[0];
        if (rowIdx > -1) {
          var stusCode = AUIGrid.getCellValue(supplementGridID, rowIdx, "supRefStatCde");
          var stgCode = AUIGrid.getCellValue(supplementGridID, rowIdx, "supRefStgCde");
          var rtnStusCode = AUIGrid.getCellValue(supplementGridID, rowIdx, "supRtnStatCde");
          var rtnTckNo = AUIGrid.getCellValue(supplementGridID, rowIdx, "supRtnPrcTrkNo");
          // SUPPLEMENT ORDER STATUS MUST UNDER CANCELLAED
          if (stusCode != '10') {
            Common.alert('<spring:message code="supplement.alert.msg.cancellationDisallow" />' + '<br/><b>Order Status NOT IN Cancel Mode.</b>');
            return false;
          }

          if (stgCode != '6') {
            Common.alert('<spring:message code="supplement.alert.msg.cancellationDisallow" />' + '<br/><b>Order Stage NOT IN Return Product Quantity Update Stage.</b>');
            return false;
          }

          // SUPPLEMENT RETURN STATUS MUST UNDER ACTIVE
          if (rtnStusCode === undefined) {
            Common.alert('<spring:message code="supplement.alert.msg.cancellationDisallow" />' + '<br/><b>No Status Found for Goods Return.</b>');
            return false;
          } else if (rtnStusCode != '1') {
            Common.alert('<spring:message code="supplement.alert.msg.cancellationDisallow" />' + '<br/><b>Return Status NOT IN Active Mode</b>');
            return false;
          }

          // RETURN TRACKING NUMBER MUST HAVE VALUE
          if (rtnTckNo === undefined) {
            Common.alert('<spring:message code="supplement.alert.msg.cancellationDisallow" />'  + '<br/><b>No Return Tracking No. Found.</b>');
            return false;
          }

          Common.popupDiv("/supplement/cancellation/supplementCancellationUpdateReturnQtyPop.do", { supOrdNo : AUIGrid.getCellValue( supplementGridID, rowIdx, "supOrdNo"), cancReqNo : AUIGrid.getCellValue( supplementGridID, rowIdx, "supCancReqNo"), cancReqDt : AUIGrid.getCellValue( supplementGridID, rowIdx, "supCancDt"), cancReqBy : AUIGrid.getCellValue( supplementGridID, rowIdx, "supCancBy"), supRtnStat : AUIGrid.getCellValue( supplementGridID, rowIdx, "supRtnStat") , canReqId : AUIGrid.getCellValue( supplementGridID, rowIdx, "canReqId") }, null, true, '_insDiv');
        } else {
          Common.alert('<spring:message code="sal.alert.msg.noRecordSelected" />');
          return false;
        }
      }
    );

    $("#cancellationDetailView").click(
       function() {
         var rowIdx = AUIGrid.getSelectedIndex(supplementGridID)[0];
         if (rowIdx > -1) {
           Common.popupDiv("/supplement/cancellation/supplementCancellationViewDetailPop.do", { supOrdNo : AUIGrid.getCellValue( supplementGridID, rowIdx, "supOrdNo"), cancReqNo : AUIGrid.getCellValue( supplementGridID, rowIdx, "supCancReqNo"), cancReqDt : AUIGrid.getCellValue( supplementGridID, rowIdx, "supCancDt"), cancReqBy : AUIGrid.getCellValue( supplementGridID, rowIdx, "supCancBy"), supRtnStat : AUIGrid.getCellValue( supplementGridID, rowIdx, "supRtnStat") , canReqId : AUIGrid.getCellValue( supplementGridID, rowIdx, "canReqId") }, null, true, '_insDiv');
         } else {
           Common.alert('<spring:message code="sal.alert.msg.noRecordSelected" />');
           return false;
         }
       }
    );

    $("#congsRtnUpd").click(
      function() {
        var rowIdx = AUIGrid.getSelectedIndex(supplementGridID)[0];
        if (rowIdx > -1) {
         var stusCode = AUIGrid.getCellValue(supplementGridID, rowIdx, "supRefStatCde");
         var stgCode = AUIGrid.getCellValue(supplementGridID, rowIdx, "supRefStgCde");
         var rtnTckNo = AUIGrid.getCellValue(supplementGridID, rowIdx, "supRtnPrcTrkNo");

         // SUPPLEMENT ORDER STATUS MUST UNDER CANCELLAED
         if (stusCode != '10') {
           Common.alert('<spring:message code="supplement.alert.msg.cancellationDisallow" />' + '<br/><b>Order Status NOT IN Cancel Mode.</b>');
           return false;
         }

         if (stusCode != '5') {
           Common.alert('<spring:message code="supplement.alert.msg.cancellationDisallow" />' + '<br/><b>Order Stage NOT IN Return Consignment Number Update Stage.</b>');
           return false;
         }

         Common.popupDiv("/supplement/cancellation/supplementUpdateRtnTrackNoPop.do", { supOrdNo : AUIGrid.getCellValue( supplementGridID, rowIdx, "supOrdNo"), cancReqNo : AUIGrid.getCellValue( supplementGridID, rowIdx, "supCancReqNo"), cancReqDt : AUIGrid.getCellValue( supplementGridID, rowIdx, "supCancDt"), cancReqBy : AUIGrid.getCellValue( supplementGridID, rowIdx, "supCancBy"), supRtnStat : AUIGrid.getCellValue( supplementGridID, rowIdx, "supRtnStat") , canReqId : AUIGrid.getCellValue( supplementGridID, rowIdx, "canReqId") }, null, true, '_insDiv');
       } else {
         Common.alert('<spring:message code="sal.alert.msg.noRecordSelected" />');
         return false;
       }
     }
    );

    $('#excelDown').click(
      function() {
        const today = new Date();
        const day = String(today.getDate()).padStart(2, '0');
        const month = String(today.getMonth() + 1).padStart(2, '0');
        const year = today.getFullYear();

        const date = year + month + day;
        GridCommon.exportTo("supplement_grid_wrap", "xlsx", "Supplement Cancellation Listing-" + date);
    });
  });

  function fn_validSearchList() {
    var isValid = true, msg = "";

    if ((!FormUtil.isEmpty($('#cancelStartDt').val()) && FormUtil
        .isEmpty($('#cancelEndDt').val()))
        || (FormUtil.isEmpty($('#cancelStartDt').val()) && !FormUtil
            .isEmpty($('#cancelEndDt').val()))) {
      msg += '<spring:message code="supplement.alert.msg.selectSupRtnDt" /><br/>';
      isValid = false;
    }

    if (!isValid)
      Common.alert('<spring:message code="supplement.title.supplementCancellation" />' + DEFAULT_DELIMITER + "<b>" + msg + "</b>");
      return isValid;
  }

  function fn_getSupplementSubmissionList() {
    Common.ajax("GET", "/supplement/cancellation/selectSupplementCancellationJsonList.do",
        $("#searchForm").serialize(), function(result) {
          AUIGrid.setGridData(supplementGridID, result);
        });
  }

  function fn_calculateAmt(amt, qty) {

    var subTotal = 0;
    var subChanges = 0;
    var taxes = 0;

    subTotal = amt * qty;
    subChanges = (subTotal * 100) / 100;
    subChanges = subChanges.toFixed(2); //소수점2반올림
    taxes = subTotal - subChanges;
    taxes = taxes.toFixed(2);

    var retObj = {
      subTotal : subTotal,
      subChanges : subChanges,
      taxes : taxes
    };

    return retObj;
  }

</script>
<section id="content">
  <ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li><spring:message code="supplement.title.healthSupplement" /></li>
    <li><spring:message code="supplement.title.supplementCancellation" /></li>
  </ul>

  <aside class="title_line">
    <p class="fav">
      <a href="#" class="click_add_on">My menu</a>
    </p>
    <h2>
      <spring:message code="supplement.title.supplementCancellation" />
    </h2>
    <ul class="right_btns">
      <c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
        <li>
          <p class="btn_blue">
            <a href="#" id="congsRtnUpd"><spring:message  code="supplement.btn.supplementCongsRtnUpd" /></a>
          </p>
        </li>
      </c:if>
      <c:if test="${PAGE_AUTH.funcUserDefine2 == 'Y'}">
        <li>
          <p class="btn_blue">
            <a href="#" id="rtnQtyUpd"><spring:message code="supplement.btn.supplementRtnQtyUpd" /></a>
          </p>
        </li>
      </c:if>
      <c:if test="${PAGE_AUTH.funcView == 'Y'}">
        <li>
          <p class="btn_blue">
            <a href="#" id="cancellationDetailView"><spring:message code="sys.scm.inventory.ViewDetail" /></a>
          </p>
        </li>
        <li>
          <p class="btn_blue">
            <a href="#" id="_btnSearch"><span class="search"></span>
            <spring:message code="sal.btn.search" /></a>
          </p>
        </li>
      </c:if>
    </ul>
  </aside>

  <section class="search_table">
    <form id="searchForm">
      <table class="type1">
        <caption>table</caption>
        <colgroup>
          <col style="width: 150px" />
          <col style="width: *" />
          <col style="width: 160px" />
          <col style="width: *" />
          <col style="width: 130px" />
          <col style="width: *" />
        </colgroup>
        <tbody>
          <tr>
            <th scope="row"><spring:message code="supplement.text.supplementReferenceNo" /></th>
            <td>
            <input id="supplementOrderNo" name="supplementOrderNo" type="text" title="" placeholder="Supplement Order No" class="w100p" />
            </td>
            <th scope="row"><spring:message code="supplement.text.supplementCanReqNo" /></th>
            <td>
            <input id="supplementCanReqNo" name="supplementCanReqNo" type="text" title="" placeholder="Cancellation Request No" class="w100p" />
            </td>
            <th scope="row"><spring:message code="supplement.text.supplementCanDt" /><span class="must">*</span></th>
            <td>
              <div class="date_set w100p">
                <p>
                  <input id="cancelStartDt" name="cancelStartDt" type="text" value="${bfDay}" title="Create Start Date" placeholder="DD/MM/YYYY" class="j_date" />
                </p>
                <span><spring:message code="sal.title.to" /></span>
                <p>
                  <input id="cancelEndDt" name="cancelEndDt" type="text" value="${toDay}" title="Create End Date" placeholder="DD/MM/YYYY" class="j_date" />
                </p>
              </div>
            </td>
          </tr>
          <tr>
            <th scope="row"><spring:message code="supplement.text.cancBy" /></th>
            <td>
              <input type="text" title="" id="crtBy" name="crtBy" placeholder="Create By" class="w100p" />
            </td>
            <th scope="row"><spring:message code="supplement.text.supplementReferenceStatus" /></th>
            <td>
              <select class="multy_select w100p" multiple="multiple" id="supRefStus" name="supRefStus">
                <c:forEach var="list" items="${supRefStus}" varStatus="status">
                  <option value="${list.codeId}">${list.codeName}</option>
                </c:forEach>
              </select>
            </td>
            <th scope="row"><spring:message code="supplement.text.supplementReferenceStage" /></th>
            <td>
              <select class="multy_select w100p" multiple="multiple" id="supRefStg" name="supRefStg">
                <c:forEach var="list" items="${supRefStg}" varStatus="status">
                  <option value="${list.codeId}">${list.codeName}</option>
                </c:forEach>
              </select>
            </td>
          </tr>
          <tr>
            <th scope="row"><spring:message code="sal.text.customerId" /></th>
            <td>
              <input id="custId" name="custId" type="text" title="" placeholder="Customer ID" class="w100p" />
            </td>
            <th scope="row"><spring:message code="sal.text.custName" /></th>
            <td>
              <input id="custName" name="custName" type="text" title="" placeholder="Customer Name" class="w100p" />
            </td>
            <th scope="row"><spring:message code="sal.text.nricCompanyNo" /></th>
            <td>
              <input id="custNric" name="custNric" type="text" title="" placeholder="NRIC / Company No." class="w100p" />
            </td>
          </tr>
          <tr>
            <th scope="row"><spring:message code="sal.title.text.returnStatus" /></th>
            <td>
              <select class="multy_select w100p" multiple="multiple" id="rtnStat" name="rtnStat">
                <c:forEach var="list" items="${supRtnStus}" varStatus="status">
                  <option value="${list.codeId}">${list.codeName}</option>
                </c:forEach>
              </select>
            </td>
            <th scope="row"><spring:message code="supplement.text.parcelTrackingNo" /></th>
            <td>
              <input id="prcTrkNo" name="prcTrkNo" type="text" title="" placeholder="Parcel tracking No." class="w100p" />
            </td>
            <th scope="row"><spring:message code="supplement.text.supplementPrcRtnTrcNo" /></th>
            <td>
              <input id="prcRtnTrkNo" name="prcRtnTrkNo" type="text" title="" placeholder="Parcel Return Tracking No" class="w100p" /></td>
          </tr>
        </tbody>
      </table>
      <aside class="link_btns_wrap">
        <!-- link_btns_wrap start -->
        <p class="show_btn">
          <a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a>
        </p>
        <dl class="link_list">
          <dt>
            <spring:message code="sal.title.text.link" />
          </dt>
          <dd>
            <ul class="btns">
            </ul>
            <p class="hide_btn">
              <a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a>
            </p>
          </dd>
        </dl>
      </aside>
    </form>
  </section>

  <section class="search_result">
    <c:if test="${PAGE_AUTH.funcUserDefine4 == 'Y'}">
      <ul class="right_btns">
        <li><p class="btn_grid">
            <a href="#" id="excelDown"><spring:message
                code="sal.btn.generate" /></a>
          </p></li>
      </ul>
    </c:if>
    <aside class="title_line">
    </aside>

    <article class="grid_wrap">
      <div id="supplement_grid_wrap"
        style="width: 100%; height: 300px; margin: 0 auto;"></div>
      <div id="excel_list_grid_wrap" style="display: none;"></div>
    </article>
    <div id="_itmDetailGridDiv">
      <aside class="title_line"><!-- title_line start -->
        <h3><spring:message code="sal.title.itmList" /></h3>
      </aside>
      <article class="grid_wrap">
        <div id="supplement_itm_grid_wrap" style="width:100%; height:300px; margin:0 auto;"></div>
      </article>
    </div>
  </section>
</section>
<hr />
