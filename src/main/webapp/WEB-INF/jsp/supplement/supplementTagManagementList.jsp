<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javascript">
  //document.write('<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/homecare-js-1.0.js?v=' + new Date().getTime() + '"><\/script>');

  var tagGridID;
  var excelListGridID;

  var ajaxOtp = {
    async : false
  };

  $(document).ready(
    function() {
      createAUIGrid();
      createExcelAUIGrid();

      setTimeout(function() {
        fn_descCheck(0)
      }, 1000);

       $('#excelDown').click(
         function() {
           var excelProps = {
             fileName : "Supplement Tag Management",
             exceptColumnFields : AUIGrid.getHiddenColumnDataFields(excelListGridID)
           };
           AUIGrid.exportToXlsx(excelListGridID, excelProps);
         });

        $("#_search").click(function() {
          AUIGrid.clearGridData(tagGridID);
          fn_getTagMngmtListAjax();
        });

        $("#_new").click(
          function() {
            Common.popupDiv("/supplement/newTagRequestPop.do", '', null, true, '_insDiv');
        });

        $("#_update").click(
          function() {
            var clickChk = AUIGrid.getSelectedItems(tagGridID);
            if (clickChk == null || clickChk.length <= 0) {
              Common.alert('<spring:message code="sal.alert.msg.noOrderSelected" />');
              return;
            }

            var supplementForm = {
              supRefId : clickChk[0].item.supRefId,
              ind : "1"
            };

           var supRefId = clickChk[0].item.supRefId;
           Common.popupDiv("/supplement/tagMngApprovalPop.do", supplementForm, null, true, '_insDiv');
         });

         AUIGrid.bind(tagGridID, "cellClick", function(event) {
           var detailParam = {
             supRefNo : event.item.supRefNo
           };
           var detailParam = {
             supRefId : event.item.supRefId
           };
         });
  });

  function createAUIGrid() {
    var posColumnLayout = [
        {
          dataField : "supRefId",
          visible : false,
          editable : false
        },
        {
          dataField : "counselingNo",
          headerText : '<spring:message code="service.grid.counselingNo" />',
          width : '10%',
          editable : false
        },
        {
          dataField : "supRefNo",
          headerText : '<spring:message code="supplement.text.supplementReferenceNo" />',
          width : '10%',
          editable : false
        },
        {
          dataField : "custName",
          headerText : '<spring:message code="sal.text.custName" />',
          width : '15%',
          style : 'left_style',
          editable : false
        },
        {
          dataField : "tagRegisterDt",
          headerText : '<spring:message code="supplement.text.supplementTagRegisterDt" />',
          width : '10%',
          editable : false
        },
        {
          dataField : "tagStatus",
          headerText : '<spring:message code="supplement.text.supplementTagStus" />',
          width : '10%',
          editable : false
        },
        {
          dataField : "mainTopic",
          headerText : '<spring:message code="supplement.text.supplementMainTopicInquiry" />',
          width : '10%',
          editable : false
        },
        {
          dataField : "subTopic",
          headerText : '<spring:message code="supplement.text.supplementSubTopicInquiry" />',
          width : '10%',
          editable : false
        },
        {
          dataField : "inchgDept",
          headerText : '<spring:message code="service.text.InChrDept" />',
          width : '15%',
          editable : false
        },
        {
          dataField : "subDept",
          headerText : '<spring:message code="service.grid.subDept" />',
          width : '10%',
          editable : false
        } ];

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

    tagGridID = GridCommon.createAUIGrid("#tag_grid_wrap", posColumnLayout, '', gridPros);
  }

  function createExcelAUIGrid() {
    var excelColumnLayout = [
    {
      dataField : "supRefId",
      visible : false,
      editable : false
    }, {
      dataField : "counselingNo",
      headerText : '<spring:message code="service.grid.counselingNo" />',
      width : 100,
      editable : false
    }, {
      dataField : "supRefNo",
      headerText : '<spring:message code="supplement.text.supplementReferenceNo" />',
      width : 100,
      editable : false
    }, {
      dataField : "custName",
      headerText : '<spring:message code="sal.text.custName" />',
      width : 100,
      editable : false
    }, {
      dataField : "tagRegisterDt",
      headerText : '<spring:message code="supplement.text.supplementTagRegisterDt" />',
      width : 100,
      editable : false
    }, {
      dataField : "tagStatus",
      headerText : '<spring:message code="supplement.text.supplementTagStus" />',
      width : 100,
      editable : false
    }, {
      dataField : "mainTopic",
      headerText : '<spring:message code="supplement.text.supplementMainTopicInquiry" />',
      width : 100,
      editable : false
    }, {
      dataField : "subTopic",
      headerText : '<spring:message code="supplement.text.supplementSubTopicInquiry" />',
      width : 100,
      editable : false
    }, {
      dataField : "inchgDept",
      headerText : '<spring:message code="service.text.InChrDept" />',
      width : 100,
      editable : false
    }, {
      dataField : "subDept",
      headerText : '<spring:message code="service.grid.subDept" />',
      width : 100,
      editable : false
    } ];

    var excelGridPros = {
      enterKeyColumnBase : true,
      useContextMenu : true,
      enableFilter : true,
      showStateColumn : true,
      displayTreeOpen : true,
      noDataMessage : "<spring:message code='sys.info.grid.noDataMessage' />",
      groupingMessage : "<spring:message code='sys.info.grid.groupingMessage' />",
      exportURL : "/common/exportGrid.do"
    };

    excelListGridID = GridCommon.createAUIGrid("excel_list_grid_wrap", excelColumnLayout, "", excelGridPros);
  }

  function fn_mainTopic_SelectedIndexChanged() {
    $("#ddSubTopic option").remove();
    doGetCombo('/supplement/getSubTopicList.do?DEFECT_GRP=' + $("#mainTopic").val(), '', '', 'ddSubTopic', 'S', '');
  }

  function fn_inchgDept_SelectedIndexChanged() {
    $("#ddSubDept option").remove();
    doGetCombo('/supplement/getSubDeptList.do?DEFECT_GRP_DEPT='  + $("#inchgDept").val(), '', '', 'ddSubDept', 'S', '');
  }

  function fn_descCheck(ind) {
    var indicator = ind;
    var jsonObj = {
      DEFECT_GRP : $("#mainTopic").val(),
      DEFECT_GRP_DEPT : $("#inchgDept").val(),
      TYPE : "SMI"
    };

    doGetCombo('/supplement/getSubTopicList.do?DEFECT_GRP=' + $("#mainTopic").val(), '', '', 'ddSubTopic', 'S', '');
    doGetCombo('/supplement/getSubDeptList.do?DEFECT_GRP_DEPT=' + $("#inchgDept").val(), '', '', 'ddSubDept', 'S', '');
  }

  function fn_getTagMngmtListAjax() {
    Common.ajax("GET", "/supplement/selectTagManagementList", $("#searchForm").serialize(), function(result) {
      AUIGrid.setGridData(tagGridID, result);
      AUIGrid.setGridData(excelListGridID, result);
    });
  }
</script>

<form id="rptForm">
  <input type="hidden" id="reportFileName" name="reportFileName" />
  <input type="hidden" id="viewType" name="viewType" />
</form>
<section id="content">
  <ul class="path">
    <li><img
      src="${pageContext.request.contextPath}/resources/images/common/path_home.gif"
      alt="Home" /></li>
    <li>Health Supplement</li>
    <li>Supplement Tag Management</li>
  </ul>
  <aside class="title_line">
    <p class="fav">
      <a href="#" class="click_add_on">My menu</a>
    </p>
    <h2>
      <spring:message code="supplement.title.supplementTagManagement" />
    </h2>
    <ul class="right_btns">
      <c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
        <li>
          <p class="btn_blue">
            <a href="#" id="_new">
              <spring:message code="supplement.btn.newTicket" /></a>
          </p>
        </li>
      </c:if>
      <c:if test="${PAGE_AUTH.funcUserDefine2 == 'Y'}">
        <li>
          <p class="btn_blue">
            <a href="#" id="_update"><spring:message code="pay.btn.approval" /></a>
          </p>
        </li>
      </c:if>
      <c:if test="${PAGE_AUTH.funcView == 'Y'}">
        <li>
          <p class="btn_blue">
            <a href="#" id="_search"><span class="search"></span> <spring:message
                code="sal.btn.search" /></a>
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
            <th scope="row"><spring:message code="service.grid.counselingNo" /></th>
            <td>
              <input type="text" title="" placeholder="Counseling No" class="w100p" id="_counselingNo" name="counselingNo" />
            </td>
            <th scope="row">
              <spring:message code="supplement.text.supplementMainTopicInquiry" /></th>
            <td>
              <select class="select w100p" id="mainTopic" name="mainTopic" onChange="fn_mainTopic_SelectedIndexChanged()">
                <option value="">Choose One</option>
                <c:forEach var="list" items="${mainTopic}" varStatus="status">
                  <option value="${list.codeId}">${list.codeName}</option>
                </c:forEach>
            </select>
            </td>
            <th scope="row">
              <spring:message code="supplement.text.supplementSubTopicInquiry" /></th>
            <td>
              <select id='ddSubTopic' name='ddSubTopic' class="w100p"></select>
            </td>
          </tr>
          <tr>
            <th scope="row"><spring:message code="supplement.text.supplementTagRegisterDt" /><span class="must">*</span></th>
            <td>
              <div class="date_set w100p">
                <p>
                  <input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" name="sDate" id="_sDate" value="${bfDay}" />
                </p>
                <span><spring:message code="sal.title.to" /></span>
                <p>
                  <input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" name="eDate" id="_eDate" value="${toDay}" />
                </p>
              </div>
            </td>
            <th scope="row"><spring:message code="service.text.InChrDept" /></th>
            <td>
              <select class="select w100p" id="inchgDept" name="inchgDept" onChange="fn_inchgDept_SelectedIndexChanged()">
                <option value="">Choose One</option>
                <c:forEach var="list" items="${inchgDept}" varStatus="status">
                  <option value="${list.codeId}">${list.codeName}</option>
                </c:forEach>
              </select>
            </td>
            <th scope="row"><spring:message code="service.grid.subDept" /></th>
            <td>
              <select id='ddSubDept' name='ddSubDept' class="w100p"></select>
            </td>
          </tr>
          <tr>
            <th scope="row"><spring:message code="supplement.text.supplementTagStus" /></th>
            <td>
              <select class="select w100p" id="tagStus" name="tagStus">
                <option value="">Choose One</option>
                <c:forEach var="list" items="${tagStus}" varStatus="status">
                  <option value="${list.codeId}">${list.codeName}</option>
                </c:forEach>
              </select>
            </td>
            <th></th>
            <td></td>
            <th/></th>
            <td></td>
          </tr>
          <tr>
            <th scope="row"><spring:message code="supplement.text.supplementReferenceNo" /></th>
            <td>
              <input type="text" title="" placeholder="Supplement Reference No" class="w100p" id="_supRefNo" " name="supRefNo" />
            </td>
            <th scope="row"><spring:message code="sal.text.custName" /></th>
            <td>
              <input type="text" title="" placeholder="Customer Name" class="w100p" id="_custName" " name="custName" />
            </td>
            <th/></th>
            <td></td>
          </tr>
        </tbody>
      </table>
      <aside class="link_btns_wrap">
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
              <a href="#">
                <img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a>
            </p>
          </dd>
        </dl>
      </aside>
  </section>
  <section class="search_result">
    <c:if test="${PAGE_AUTH.funcUserDefine3 == 'Y'}">
      <ul class="right_btns">
        <li>
          <p class="btn_grid">
            <a href="#" id="excelDown"><spring:message code="sal.btn.generate" /></a>
          </p>
        </li>
      </ul>
    </c:if>
    <aside class="title_line"></aside>
    <article class="grid_wrap">
      <div id="tag_grid_wrap"
        style="width: 100%; height: 300px; margin: 0 auto;"></div>
      <div id="excel_list_grid_wrap" style="display: none;"></div>
    </article>
  </section>
</section>
<hr />
