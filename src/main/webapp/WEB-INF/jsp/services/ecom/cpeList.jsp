<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javaScript">
  var gridID;
  var gridIDExcel;
  var cpeReqId;

  function cpeGrid() {

    var columnLayout = [ {
        dataField : "salesOrdNo",
        headerText : "Order Number",
        width : "5%"
    }, {
        dataField : "salesOrdId",
        visible : false
    }, {
      dataField : "customerName",
      headerText : "<spring:message code='service.grid.CustomerName'/>",
      width : "10%"
    }, {
      dataField : "nricCompanyNo",
      headerText : "NRIC/Company No.",
      width : "12%"
    }, {
      dataField : "cpeReqId",
      headerText : "Request ID",
      width : "5%"
    }, {
      dataField : "crtDt",
      headerText : "<spring:message code='cpe.grid.requestDt'/>",
      width : "10%"
    }, {
      dataField : "requestorBranch",
      headerText : "Requestor Branch",
      width : "13%"
    }, {
      dataField : "mainDept",
      headerText : "<spring:message code='service.grid.mainDept'/>",
      width : "15%"
    }, {
      dataField : "subDept",
      headerText : "<spring:message code='service.grid.subDept'/>",
      width : "15%"
    }, {
      dataField : "status",
      headerText : "<spring:message code='service.grid.Status'/>",
      width : "5%"
    }, {
        dataField : "dscBranch",
        headerText : "DSC Branch",
        dataType : "date"
    }, {
        dataField : "requestStage",
        headerText : "Request Stage",
        width : "13%"
    }, {
        dataField : "asNo",
        headerText : "AS No.",
        width : "10%"
    }];

    var excelLayout = [ {
      dataField : "ordNo",
      headerText : "Order Number",
      width : 150,
      height : 80
    }, {
      dataField : "customerName",
      headerText : "<spring:message code='service.grid.CustomerName'/>",
      width : 200,
      height : 80
    }, {
      dataField : "requestStage",
      headerText : "Request Stage",
      width : 200,
      height : 80
    }, {
      dataField : "nricCompanyNo",
      headerText : "NRIC/Company No.",
      width : 200,
      height : 80
    }, {
      dataField : "cpeReqId",
      headerText : "Request ID",
      width : 200,
      height : 80
    }, {
      dataField : "regDate",
      headerText : "<spring:message code='cpe.grid.requestDt'/>",
      width : 200,
      height : 80
    }, {
        dataField : "requestorBranch",
        headerText : "Requestor Branch",
        width : 200,
        height : 80
    }, {
      dataField : "mainDept",
      headerText : "<spring:message code='service.grid.mainDept'/>",
      width : 200,
      height : 80
    }, {
      dataField : "subDept",
      headerText : "<spring:message code='service.grid.subDept'/>",
      width : 200,
      height : 80
    }, {
      dataField : "status",
      headerText : "<spring:message code='service.grid.Status'/>",
      width : 100,
      height : 80
    }, {
      dataField : "dscBranch",
      headerText : "DSC Branch",
      width : 500,
      height : 80
    }, {
        dataField : "requestStage",
        headerText : "Request Stage",
        width : "13%"
    }, {
        dataField : "asNo",
        headerText : "AS No.",
        width : 200,
        height : 80
    }];

    var gridPros = {
      usePaging : true,
      pageRowCount : 20,
      showStateColumn : false,
      displayTreeOpen : false,
      //selectionMode : "singleRow",
      skipReadonlyColumns : true,
      wrapSelectionMove : true,
      showRowNumColumn : true,
      editable : false
    };

    var excelGridPros = {
      enterKeyColumnBase : true,
      useContextMenu : true,
      enableFilter : true,
      showStateColumn : true,
      displayTreeOpen : true,
      wordWrap : true,
      noDataMessage : "<spring:message code='sys.info.grid.noDataMessage' />",
      groupingMessage : "<spring:message code='sys.info.grid.groupingMessage' />",
      exportURL : "/common/exportGrid.do"
    };

    gridID = GridCommon.createAUIGrid("cpe_grid_wrap", columnLayout, "", gridPros);
    gridIDExcelHide = GridCommon.createAUIGrid("grid_wrap_hide", excelLayout, "", excelGridPros);
  }

  $(document).ready(function() {
      cpeGrid();

      $("#search").click(
        function() {
            fn_search();
          });

       // cell click
       AUIGrid.bind(gridID, "cellClick", function(event) {
           cpeReqId = AUIGrid.getCellValue(gridID, event.rowIndex, "cpeReqId");
       });

       $("#main_department").change(
            function() {
              if ($("#main_department").val() == '') {
                $("#sub_department").val('');
                $("#sub_department").find("option").remove();
              } else {
                doGetCombo('/services/ecom/selectSubDept.do', $("#main_department").val(), '', 'sub_department', 'S', '');
              }
        });

       doGetCombo('/services/ecom/selectMainDept.do', '', '', 'main_department', 'S', '');
       doGetComboSepa('/common/selectBranchCodeList.do',  '5', ' - ', '',   'dsc_branch', 'M', 'fn_multiCombo'); //Branch Code
       doGetComboSepa('/common/selectBranchCodeList.do', '1' , ' - ' , '','requestorBranch', 'M' , 'fn_multiCombo');
  });

  function fn_search() {
    Common.ajax("GET", "/services/ecom/selectCpeRequestList", $("#cpeForm").serialize(),
      function(result) {
        AUIGrid.setGridData(gridID, result);
        AUIGrid.setGridData(gridIDExcelHide, result);
      });
  }

  function fn_clear() {
	  location.reload();
  }

  function fn_multiCombo() {
      $('#dsc_branch').change(function() {
          //console.log($(this).val());
      }).multipleSelect({
          selectAll: true,
          width: '100%'
      });

      $('#requestorBranch').change(function() {
          //console.log($(this).val());
      }).multipleSelect({
          selectAll: true,
          width: '100%'
      });
  }

  function fn_cpeRequestPop() {
	  Common.popupDiv("/services/ecom/cpeRequest.do" , null, null , true, 'cpeRequestNewSearchPop');
  }

  function fn_cpeUpdateApprove() {
	  var selectedItems = AUIGrid.getSelectedItems(gridID);
	  if (selectedItems.length <= 0) {
	    Common.alert("<spring:message code='service.msg.NoRcd'/>");
	    return;
	  }

	  var itemCpeReqId = selectedItems[0].item.cpeReqId;
	  var itemSalesOrdId = selectedItems[0].item.salesOrdId;
	  var itemSalesOrdNo = selectedItems[0].item.salesOrdNo;

	  var data = {
			  cpeReqId : itemCpeReqId,
	          salesOrderId : itemSalesOrdId,
	          salesOrderNo : itemSalesOrdNo
	  };

	  Common.popupDiv("/services/ecom/cpeRqstUpdateApprovePop.do", data, null, true, "cpeRqstUpdateApprovePop");
  }

  function fn_generateCpeRaw() {
	  var $reportForm = $("#reportForm")[0];

      var reportDownFileName = "CPERawData"; //report name
      var reportFileName = "/services/CPERawData_Excel.rpt"; //reportFileName
      var reportViewType = "EXCEL"; //viewType

      //default input setting
      $($reportForm).append('<input type="hidden" id="reportFileName" name="reportFileName"  /> ');//report file name
      $($reportForm).append('<input type="hidden" id="reportDownFileName" name="reportDownFileName" /> '); // download report name
      $($reportForm).append('<input type="hidden" id="viewType" name="viewType" /> '); // download report  type

      //default setting
      $("#reportForm #reportFileName").val(reportFileName);
      $("#reportForm #reportDownFileName").val(reportDownFileName);
      $("#reportForm #viewType").val(reportViewType);

      //  report 호출
      var option = {
          isProcedure : false // procedure 로 구성된 리포트 인경우 필수.
      };
      Common.report("reportForm", option);
  }


</script>
<section id="content">
 <!-- content start -->
 <ul class="path">
  <li><img
   src="${pageContext.request.contextPath}/images/common/path_home.gif"
   alt="Home" /></li>
  <li><spring:message code='service.title.service'/></li>
  <li><spring:message code='service.title.cpe'/></li>
 </ul>
 <aside class="title_line">
  <!-- title_line start -->
  <p class="fav">
   <a href="#" class="click_add_on">My menu</a>
  </p>
  <h2><spring:message code='service.title.cpe'/></h2>
  <ul class="right_btns">
   <c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
    <li><p class="btn_blue">
      <a href="javascript:fn_cpeRequestPop()">Request</a>
     </p></li>
   </c:if>
   <c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
    <li><p class="btn_blue">
      <a href="javascript:fn_cpeUpdateApprove()"><spring:message code='cpe.text.updateApprove'/></a>
     </p></li>
   </c:if>
   <c:if test="${PAGE_AUTH.funcView == 'Y'}">
    <li><p class="btn_blue">
      <a href="#" id="search"><span class="search"></span><spring:message code='sys.btn.search'/></a>
     </p></li>
     <li><p class="btn_blue"><a id="btnClear" href="javascript:fn_clear()"><span class="clear"></span><spring:message code='sys.btn.clear'/></a>
     </p></li>
   </c:if>
  </ul>
 </aside>
 <!-- title_line end -->
 <section class="search_table">
  <!-- search_table start -->
  <form id="cpeForm" name="cpeForm" method="post">
   <table class="type1">
    <!-- table start -->
    <caption>table</caption>
    <colgroup>
     <col style="width: 180px" />
     <col style="width: *" />
     <col style="width: 180px" />
     <col style="width: *" />
     <col style="width: 160px" />
     <col style="width: *" />
    </colgroup>
    <tbody>
     <tr>
      <th scope="row"><spring:message code='sal.title.ordNo'/></th>
      <td><input type="text" id="order_no" name="order_no"
       placeholder="<spring:message code='sal.title.ordNo'/>" class="w100p" /></td>
      <th scope="row"><spring:message code='service.title.NRIC_CompanyNo'/></th>
      <td><input type="text" id="nric_company_no" name="nric_company_no"
       placeholder="<spring:message code='service.title.NRIC_CompanyNo'/>" class="w100p" /></td>
      <th scope="row"><spring:message code='service.grid.mainDept'/></th>
      <td><select class="w100p" id="main_department" name="main_department">
        <option value=""><spring:message code='sal.combo.text.chooseOne'/></option>
      </select></td>
     </tr>
     <tr>
      <th scope="row"><spring:message code='cpe.grid.asNo'/></th>
      <td><input type="text" id="asNo" name="asNo"
       placeholder="<spring:message code='cpe.grid.asNo'/>" class="w100p" /></td>
      <th scope="row"><spring:message code='cpe.grid.requestId'/></th>
      <td><input type="text" id="cpeReqId" name="cpeReqId"
       placeholder="<spring:message code='cpe.grid.requestId'/>" class="w100p" /></td>
      <th scope="row"><spring:message code='service.grid.subDept'/></th>
      <td><select class="w100p" id="sub_department"
       name="sub_department">
       <option value=""><spring:message code='sal.combo.text.chooseOne'/></option>
       </select></td>
     </tr>
     <tr>
      <th scope="row"><spring:message code='service.title.CustomerName'/></th>
      <td><input type="text" id="customer_name"
       name="customer_name" title="" placeholder="<spring:message code='service.title.CustomerName'/>"
       class="w100p" /></td>
      <th scope="row"><spring:message code='cpe.grid.requestDt'/></th>
      <td>
       <div class="date_set w100p">
        <!-- date_set start -->
        <p>
         <input type="text" title="Create start Date" value="${bfDay}"
          placeholder="DD/MM/YYYY" class="j_date w100p" id="reqStartDt"
          name="reqStartDt" />
        </p>
        <span>To</span>
        <p>
         <input type="text" title="Create end Date" value="${toDay}"
          placeholder="DD/MM/YYYY" class="j_date w100p" id="reqEndDt"
          name="reqEndDt" />
        </p>
       </div>
       <!-- date_set end -->
      </td>
      <th scope="row"><spring:message code='service.grid.Status'/></th>
      <td><select class="multy_select w100p" multiple="multiple"
       id="statusList" name="statusList">

        <c:forEach var="list" items="${cpeStat}" varStatus="status">
          <option value="${list.code}" selected>${list.codeName}</option>
        </c:forEach>

        <!-- <option value="1">Active</option>
        <option value="5">Approved</option>
        <option value="6">Rejected</option>
        <option value="44">Pending</option>
        <option value="34">Solved</option>
        <option value="35">Unsolved</option>
        <option value="36">Closed</option>
        <option value="10">Cancelled</option> -->

      </select></td>
     </tr>
     <tr>
      <th scope="row"><spring:message code="sal.title.text.requestStage" /></th>
      <td><select id="reqStageId" name="reqStageId" class="multy_select w100p" multiple="multiple">
       <option value="24" selected><spring:message code="sal.text.beforeInstall" /></option>
       <option value="25" selected><spring:message code="sal.text.afterInstall" /></option>
       </select>
      </td>
      <th scope="row"><spring:message code="cpe.title.text.requestorBranch" /></th>
      <td><select class="multy_select w100p" id="requestorBranch" name="requestorBranch">
       <option value=""><spring:message code='sal.combo.text.chooseOne'/></option>
       </select></td>
      <th scope="row"><spring:message code="sal.title.text.dscBrnch" /></th>
      <td><select class="multy_select w100p" id="dsc_branch" name="dsc_branch" multiple="multiple"></select>
      </td>
      </td>
     </tr>
    </tbody>
   </table>
   <!-- table end -->
  </form>

  <aside class="link_btns_wrap"><!-- link_btns_wrap start -->
   <p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
   <dl class="link_list">
    <dt>Link</dt>
    <dd>
     <ul class="btns">
      <c:if test="${PAGE_AUTH.funcView == 'Y'}">
       <li><p class="link_btn"> <a href="javascript:fn_generateCpeRaw()" id="genCpeRaw">CPE Raw Data</a> </p></li>
      </c:if>
     </ul>
     <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
    </dd>
   </dl>
  </aside><!-- link_btns_wrap end -->

 </section>
 <!-- search_table end -->
 <section class="search_result">
  <!-- search_result start -->
  <!--
  <c:if test="${PAGE_AUTH.funcPrint == 'Y'}">
   <ul class="right_btns">
    <li><p class="btn_grid">
      <a href="#" id="excelDown"><spring:message code='service.btn.Generate'/></a>
     </p></li>
   </ul>
  </c:if>
  -->
  <article class="grid_wrap">
   <!-- grid_wrap start  그리드 영역-->
   <div id="cpe_grid_wrap"
    style="width: 100%; height: 500px; margin: 0 auto;"></div>
   <div id="grid_wrap_hide" style="display: none;"></div>
  </article>
  <!-- grid_wrap end -->
 </section>
 <!-- search_result end -->
</section>
<!-- content end -->
<form name="reportForm" id="reportForm" method="post"></form>