<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript" language="javascript">
  var listMyGridID;
  var IS_3RD_PARTY = '${SESSION_INFO.userIsExternal}';
  var MEM_TYPE = '${SESSION_INFO.userTypeId}';

  var _option = {
    width : "1200px",
    height : "800px"
  };

  $(document).ready(
    function() {
      createAUIGrid();

      AUIGrid.bind(listMyGridID, "cellDoubleClick",
        function(event) {
          if (IS_3RD_PARTY == '0') {
            fn_setDetail(listMyGridID, event.rowIndex);
          } else {
            Common.alert('<spring:message code="sal.alert.msg.accRights" />' + DEFAULT_DELIMITER + '<b><spring:message code="sal.alert.msg.noAccRights" /></b>');
          }
        });

        // if($("#memType").val() == 1 || $("#memType").val() == 2){
        if ("${SESSION_INFO.memberLevel}" == "1") {

          $("#orgCode").val("${orgCode}");
          $("#orgCode").attr("class", "w100p readonly");
          $("#orgCode").attr("readonly", "readonly");

        } else if ("${SESSION_INFO.memberLevel}" == "2") {

          $("#orgCode").val("${orgCode}");
          $("#orgCode").attr("class", "w100p readonly");
          $("#orgCode").attr("readonly", "readonly");

          $("#grpCode").val("${grpCode}");
          $("#grpCode").attr("class", "w100p readonly");
          $("#grpCode").attr("readonly", "readonly");

        } else if ("${SESSION_INFO.memberLevel}" == "3") {

          $("#orgCode").val("${orgCode}");
          $("#orgCode").attr("class", "w100p readonly");
          $("#orgCode").attr("readonly", "readonly");

          $("#grpCode").val("${grpCode}");
          $("#grpCode").attr("class", "w100p readonly");
          $("#grpCode").attr("readonly", "readonly");

          $("#deptCode").val("${deptCode}");
          $("#deptCode").attr("class", "w100p readonly");
          $("#deptCode").attr("readonly", "readonly");

        } else if ("${SESSION_INFO.memberLevel}" == "4") {

          $("#orgCode").val("${orgCode}");
          $("#orgCode").attr("class", "w100p readonly");
          $("#orgCode").attr("readonly", "readonly");

          $("#grpCode").val("${grpCode}");
          $("#grpCode").attr("class", "w100p readonly");
          $("#grpCode").attr("readonly", "readonly");

          $("#deptCode").val("${deptCode}");
          $("#deptCode").attr("class", "w100p readonly");
          $("#deptCode").attr("readonly", "readonly");

          $("#memCode").val("${memCode}");
          $("#memCode").attr("class", "w100p readonly");
         $("#memCode").attr("readonly", "readonly");
        }
        // }

        if (IS_3RD_PARTY == '0') {
          doGetComboOrder('/common/selectCodeList.do', '10', 'CODE_ID', '', 'listAppType', 'M', 'fn_multiCombo2'); //Common Code
        }
        /* else {
              doGetComboOrder('/common/selectCodeList.do', '10', 'CODE_ID', '66', 'listAppType',  'S'); //Common Code
           } */

        //doGetCombo('/common/selectCodeList.do',       '10', '',   'listAppType', 'M', 'fn_multiCombo'); //Common Code
        doGetComboAndGroup2('/common/selectProductCodeList.do', '', '', 'listProductId', 'S', 'fn_setOptGrpClass'); //product 생성
        doGetComboSepa('/common/selectBranchCodeList.do', '1', ' - ', '', 'listKeyinBrnchId', 'M', 'fn_multiCombo'); //Branch Code
        doGetComboSepa('/common/selectBranchCodeList.do', '5', ' - ', '', 'listDscBrnchId', 'M', 'fn_multiCombo'); //Branch Code
        doGetComboData('/status/selectStatusCategoryCdList.do', { selCategoryId : 5, parmDisab : 0 }, '', 'listRentStus', 'M', 'fn_multiCombo');
  });

  function fn_setOptGrpClass() {
      $("optgroup").attr("class" , "optgroup_text");
  }

  function fn_setDetail(gridID, rowIdx) {
    //(_url, _jsonObj, _callback, _isManualClose, _divId, _initFunc)
    Common.popupDiv("/sales/order/eRequestCancellationDetailPop.do", { salesOrderId : AUIGrid.getCellValue(gridID, rowIdx, "ordId") }, null, true, "_divIdOrdDtl");
  }

  function fn_selectListAjax() {
    //if(IS_3RD_PARTY == '1') $("#listAppType").removeAttr("disabled");
    Common.ajax("GET", "/sales/order/selectRequestOrderJsonList", $("#listSearchForm").serialize(), function(result) {
      AUIGrid.setGridData(listMyGridID, result);
    });

    //if(IS_3RD_PARTY == '1') $("#listAppType").prop("disabled", true);
  }

  $(function() {
    // REQUESET TRIGGER
    $('#btnReq').click(function() {
      fn_orderRequestPop();
    });
    // SEARCH TRIGGER
    $('#btnSrch').click(function() {
      if (fn_validSearchList())
        fn_selectListAjax();
    });
    // CLEAR TRIGGER
    $('#btnClear').click(function() {
      $('#listSearchForm').clearForm();
    });
  });

  function fn_validSearchList() {
    var isValid = true, msg = "";

    if (FormUtil.isEmpty($('#listOrdNo').val())
        && FormUtil.isEmpty($('#listCustId').val())
        && FormUtil.isEmpty($('#listCustName').val())
        && FormUtil.isEmpty($('#listCustIc').val())
        //&& FormUtil.isEmpty($('#listVaNo').val())
        && FormUtil.isEmpty($('#listSalesmanCode').val())
        //&& FormUtil.isEmpty($('#listPoNo').val())
        && FormUtil.isEmpty($('#listContactNo').val())
        //&& FormUtil.isEmpty($('#listSerialNo').val())
        //&& FormUtil.isEmpty($('#listSirimNo').val())
        //&& FormUtil.isEmpty($('#listRelatedNo').val())
        //&& FormUtil.isEmpty($('#listCrtUserId').val())
        && FormUtil.isEmpty($('#listPromoCode').val())
        && FormUtil.isEmpty($('#listRefNo').val())) {

      if (FormUtil.isEmpty($('#listOrdStartDt').val()) || FormUtil.isEmpty($('#listOrdEndDt').val())) {
        isValid = false;
        msg += '* <spring:message code="sal.alert.msg.selOrdDt" /><br/>';
      } else {
        var diffDay = fn_diffDate($('#listOrdStartDt').val(), $('#listOrdEndDt').val());

        if (diffDay > 31 || diffDay < 0) {
          isValid = false;
          msg += '* <spring:message code="sal.alert.msg.srchPeriodDt" />';
        }
      }
    }

    if (!isValid) {
      Common.alert('<spring:message code="sal.title.text.ordSrch" />' + DEFAULT_DELIMITER + "<b>" + msg + "</b>");
    }

    return isValid;
  }

  function fn_diffDate(startDt, endDt) {
    var arrDt1 = startDt.split("/");
    var arrDt2 = endDt.split("/");

    var dt1 = new Date(arrDt1[2], arrDt1[1] - 1, arrDt1[0]);
    var dt2 = new Date(arrDt2[2], arrDt2[1] - 1, arrDt2[0]);

    var diff = dt2 - dt1;
    var day = 1000 * 60 * 60 * 24;

    return (diff / day);
  }

  function createAUIGrid() {

    var columnLayout = [ {
      headerText : "<spring:message code='sales.OrderNo'/>",
      dataField : "ordNo",
      editable : false,
      width : 80
    }, {
      headerText : "<spring:message code='sales.Status'/>",
      dataField : "ordStusCode",
      editable : false,
      width : 80
    }, {
      headerText : "<spring:message code='sales.AppType'/>",
      dataField : "appTypeCode",
      editable : false,
      width : 80
    }, {
      headerText : "<spring:message code='sales.ordDt'/>",
      dataField : "ordDt",
      editable : false,
      width : 100
    }, {
      headerText : "<spring:message code='sales.refNo2'/>",
      dataField : "refNo",
      editable : false,
      width : 60
    }, {
      headerText : "<spring:message code='sales.prod'/>",
      dataField : "productName",
      editable : false,
      width : 150
    }, {
      headerText : "<spring:message code='sales.custId'/>",
      dataField : "custId",
      editable : false,
      width : 70
    }, {
      headerText : "<spring:message code='sales.cusName'/>",
      dataField : "custName",
      editable : false
    }, {
      headerText : "<spring:message code='sales.NRIC2'/>",
      dataField : "custIc",
      editable : false,
      width : 100
    }, {
      headerText : "<spring:message code='sales.Creator'/>",
      dataField : "crtUserId",
      editable : false,
      width : 100
    }, {
      headerText : "<spring:message code='sales.pvYear'/>",
      dataField : "pvYear",
      editable : false,
      width : 60
    }, {
      headerText : "<spring:message code='sales.pvMth'/>",
      dataField : "pvMonth",
      editable : false,
      width : 60
    }, {
      headerText : "ordId",
      dataField : "ordId",
      visible : false
    } ];

    var gridPros = {
      usePaging : true,
      pageRowCount : 20,
      editable : false,
      fixedColumnCount : 1,
      showStateColumn : false,
      displayTreeOpen : false,
      headerHeight : 30,
      useGroupingPanel : false,
      skipReadonlyColumns : true,
      wrapSelectionMove : true,
      showRowNumColumn : true,
      noDataMessage : "No order found.",
      groupingMessage : "Here groupping"
    };

    listMyGridID = GridCommon.createAUIGrid("list_grid_wrap", columnLayout, "", gridPros);
  }

  function fn_orderRequestPop() {
    var selIdx = AUIGrid.getSelectedIndex(listMyGridID)[0];
    var ordNo = AUIGrid.getCellValue(listMyGridID, selIdx, "ordNo");
    var appType = AUIGrid.getCellValue(listMyGridID, selIdx, "appTypeCode");
    var ordStaCde = AUIGrid.getCellValue(listMyGridID, selIdx, "ordStusCode");

    if (selIdx > -1) {
      if (appType == 'AUX') {
        Common.alert('<spring:message code="sal.alert.msg.actionRestriction" />' + DEFAULT_DELIMITER + "<b>Auxiliary type is not allowed to do eRequest.</b>");
      } else if (ordStaCde == 'CAN') {
        Common.alert('<spring:message code="sal.alert.msg.actionRestriction" />' + DEFAULT_DELIMITER + "<b>Cancelled order is not allowed to do eRequest.</b>");
      } else {
    	  Common.ajax("GET", "/sales/order/selectRequestApprovalList.do", {ordNo : ordNo, reqStusId : 1}, function(result) {
              if(result.length > 0){
            	  Common.alert("<spring:message code='sal.alert.msg.existERequest'/>");
              }else{
            	  Common.popupDiv("/sales/order/eRequestCancellationPop.do", { salesOrderId : AUIGrid.getCellValue(listMyGridID, selIdx, "ordId") }, null, true);
              }
          });
      }
    } else {
      Common.alert('<spring:message code="sal.alert.msg.ordMiss" />' + DEFAULT_DELIMITER + '<b><spring:message code="sal.alert.msg.noOrdSel" /></b>');
    }
  }

  function fn_multiCombo() {
    $('#listKeyinBrnchId').change(function() {
    }).multipleSelect({
      selectAll : true,
      width : '100%'
    });
    $('#listDscBrnchId').change(function() {
    }).multipleSelect({
      selectAll : true,
      width : '100%'
    });
    $('#listOrdStusId').multipleSelect("checkAll");
    $('#listRentStus').change(function() {
    }).multipleSelect({
      selectAll : true,
      width : '100%'
    });
  }

  function fn_multiCombo2() {
    $('#listAppType').change(function() {
    }).multipleSelect({
      selectAll : true,
      width : '100%'
    });
    $('#listAppType').multipleSelect("checkAll");
  }

  $.fn.clearForm = function() {
    return this.each(function() {
      var type = this.type, tag = this.tagName.toLowerCase();
      if (tag === 'form') {
        return $(':input', this).clearForm();
      }
      if (type === 'text' || type === 'password' || type === 'hidden' || type === 'file' || tag === 'textarea') {
        this.value = '';
      } else if (type === 'checkbox' || type === 'radio') {
        this.checked = false;
      } else if (tag === 'select') {
        this.selectedIndex = 0;
      }
    });
  };

  function fn_rawData() {
    Common.popupDiv("/sales/order/eRequestRawDataPop.do", null, null, true);
  }
</script>

<section id="content">
  <ul class="path">
    <li><img
      src="${pageContext.request.contextPath}/resources/images/common/path_home.gif"
      alt="Home" /></li>
    <li><spring:message code='sales.path.sales' /></li>
    <li><spring:message code='sales.path.order' /></li>
  </ul>

  <aside class="title_line">
    <p class="fav">
      <a href="#" class="click_add_on">My menu</a>
    </p>
    <h2><spring:message code='sales.title.eReqCanc' /></h2>
    <ul class="right_btns">
      <c:if test="${SESSION_INFO.userIsExternal == '0'}">
        <li><p class="btn_blue">
            <a id="btnReq" href="#">
              <spring:message code='sales.btn.request' /></a>
          </p></li>
      </c:if>
      <li><p class="btn_blue">
          <a id="btnSrch" href="#"><span class="search"></span>
          <spring:message code='sales.Search' /></a>
        </p></li>
      <li><p class="btn_blue">
          <a id="btnClear" href="#"><span class="clear"></span>
          <spring:message code='sales.Clear' /></a>
        </p></li>
    </ul>
  </aside>

  <section class="search_table">
    <form id="_frmLedger" name="frmLedger" action="#" method="post">
      <input id="_ordId" name="ordId" type="hidden" value="" />
    </form>

    <form id="listSearchForm" name="listSearchForm" action="#" method="post">
      <input id="listSalesOrderId" name="salesOrderId" type="hidden" />
      <input type="hidden" name="memType" id="memType" value="${memType }" />
      <input type="hidden" name="initGrpCode" id="initGrpCode" value="${grpCode }" />
      <input type="hidden" name="memCode" id="memCode" />

      <table class="type1">
        <caption>table</caption>
        <colgroup>
          <col style="width: 130px" />
          <col style="width: *" />
          <col style="width: 160px" />
          <col style="width: *" />
          <col style="width: 190px" />
          <col style="width: *" />
        </colgroup>
        <tbody>
          <tr>
            <th scope="row"><spring:message code='sales.OrderNo' /></th>
            <td>
              <input id="listOrdNo" name="ordNo" type="text" title="Order No" placeholder="<spring:message code='sales.OrderNo'/>" class="w100p" />
            </td>
            <th scope="row"><spring:message code='sales.AppType2' /></th>
            <td>
              <c:if test="${SESSION_INFO.userIsExternal == '0'}">
                <select id="listAppType" name="appType" class="multy_select w100p" multiple="multiple"></select>
              </c:if>
              <c:if test="${SESSION_INFO.userIsExternal == '1'}">
                <!-- <select id="listAppType" name="appType" class="w100p" disabled></select> -->
                <select id="listAppType" name="appType">
                  <option value="66">Rental</option>
                  <option value="1412">Outright</option>
                </select>
              </c:if>
            </td>
            <th scope="row"><spring:message code='sales.ordDt' /></th>
            <td>
              <div class="date_set w100p">
                <p>
                  <input id="listOrdStartDt" name="ordStartDt" type="text" value="${bfDay}" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" />
                </p>
                <span><spring:message code='sal.text.to'/></span>
                <p>
                  <input id="listOrdEndDt" name="ordEndDt" type="text" value="${toDay}" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" />
                </p>
              </div>
            </td>
          </tr>
          <tr>
            <th scope="row"><spring:message code='sales.ordStus' /></th>
            <td>
              <select id="listOrdStusId" name="ordStusId" class="multy_select w100p" multiple="multiple">
                <option value="1">Active</option>
                <option value="4">Completed</option>
                <option value="10">Cancelled</option>
              </select>
            </td>
            <th scope="row"><spring:message code='sales.keyInBranch' /></th>
            <td>
              <select id="listKeyinBrnchId" name="keyinBrnchId" class="multy_select w100p" multiple="multiple"></select>
            </td>
            <th scope="row"><spring:message code='sales.dscBranch' /></th>
            <td>
              <select id="listDscBrnchId" name="dscBrnchId" class="multy_select w100p" multiple="multiple"></select>
            </td>
          </tr>
          <tr>
            <th scope="row"><spring:message code='sales.custId2' /></th>
            <td>
              <input id="listCustId" name="custId" type="text" title="<spring:message code='sales.custId2'/>" placeholder="Customer ID (Number Only)" class="w100p" />
            </td>
            <th scope="row"><spring:message code='sales.cusName' /></th>
            <td>
              <input id="listCustName" name="custName" type="text" title="Customer Name" placeholder="<spring:message code='sales.cusName'/>" class="w100p" />
            </td>
            <th scope="row"><spring:message code='sales.NRIC2' /></th>
            <td>
              <input id="listCustIc" name="custIc" type="text" title="NRIC/Company No" placeholder="<spring:message code='sales.NRIC2'/>" class="w100p" />
            </td>
          </tr>
          <tr>
            <th scope="row"><spring:message code='sales.prod' /></th>
            <td>
              <select id="listProductId" name="productId" class="w100p"></select>
            </td>
            <th scope="row"><spring:message code='sales.salesman' /></th>
            <td>
              <input id="listSalesmanCode" name="salesmanCode" type="text" title="Salesman" placeholder="<spring:message code='sales.salesman'/>" class="w100p" />
           </td>
            <th scope="row"><spring:message code='sales.RentalStatus' /></th>
            <td>
              <select id="listRentStus" name="rentStus" class="multy_select w100p" multiple="multiple"></select>
            </td>
          </tr>
          <tr>
            <th scope="row"><spring:message code='sales.refNo3' /></th>
            <td>
              <input id="listRefNo" name="refNo" type="text" title="Reference No<" placeholder=" <spring:message code='sales.refNo3'/>" class="w100p" />
            </td>
            <th scope="row"><spring:message code='sales.ContactNo' /></th>
            <td>
              <input id="listContactNo" name="contactNo" type="text" title="Contact No" placeholder="<spring:message code='sales.ContactNo'/>" class="w100p" />
            </td>
            <th scope="row"><spring:message code='sales.promoCd' /></th>
            <td>
            <input id="listPromoCode" name="promoCode" type="text" title="Promotion Code" placeholder="<spring:message code='sales.promoCd'/>" class="w100p" />
          </td>
          </tr>
          <tr>
            <th scope="row"><spring:message code="sal.title.text.orgCode" /></th>
            <td>
              <input type="text" title="" id="orgCode" name="orgCode" value="${orgCode}" placeholder="Organization Code" class="w100p" />
            </td>
            <th scope="row"><spring:message code="sal.title.text.groupCode" /></th>
            <td>
              <input type="text" title="" id="grpCode" name="grpCode" placeholder="Group Code" class="w100p" />
            </td>
            <th scope="row"><spring:message code="sal.title.text.deptCode" /></th>
            <td>
              <input type="text" title="" id="deptCode" name="deptCode" placeholder="Department Code" class="w100p" />
            </td>
          </tr>
          <tr>
            <th scope="row" colspan="6"><span class="must"><spring:message code='sales.msg.ordlist.keyin' /></span></th>
          </tr>
        </tbody>
      </table>

      <aside class="link_btns_wrap">
        <p class="show_btn">
          <a href="#">
            <img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a>
        </p>
        <dl class="link_list">
          <dt>Link</dt>
          <dd>
            <ul class="btns">
              <c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
                <li>
                  <p class="link_btn type2">
                    <a href="#" onClick="fn_rawData()">
                      <spring:message code="sal.btn.requestRawData" />
                    </a>
                  </p>
                </li>
              </c:if>
            </ul>
            <p class="hide_btn">
              <a href="#">
                <img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a>
            </p>
          </dd>
        </dl>
      </aside>
    </form>
  </section>

  <section class="search_result">
    <article class="grid_wrap">
      <div id="list_grid_wrap" style="width:100%; height:480px; margin:0 auto;"></div>
    </article>
  </section>
</section>
