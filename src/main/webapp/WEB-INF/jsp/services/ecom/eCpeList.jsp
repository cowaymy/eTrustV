<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javaScript">
  var gridID;
  var gridIDExcel;
  var cpeReqId;

  function cpeGrid() {

    var columnLayout = [ {
        dataField : "crtDt",
        headerText : "<spring:message code='cpe.grid.requestDt'/>",
        width : "8%"
      },{
          dataField : "dscBranch",
          headerText : "DSC Branch",
          dataType : "date",
          width : "10%"
      },{
        dataField : "salesOrdNo",
        headerText : "Order Number",
        width : "8%"
    }, {
        dataField : "salesOrdId",
        visible : false
    }, {
      dataField : "customerName",
      headerText : "<spring:message code='service.grid.CustomerName'/>",
      width : "10%"
    },{
        dataField : "fullAddress",
        headerText : "Address",
        width : "8%"
    },{
        dataField : "telM1",
        headerText : "Contact No",
        width : "8%"
    },{
        dataField : "email",
        headerText : "Email",
        width : "10%"
      },{
        dataField : "status",
        headerText : "<spring:message code='service.grid.Status'/>",
        width : "6%"
      }, {
        dataField : "reason",
        headerText : "Reason",
        width : "8%"
      }, {
        dataField : "createUserId",
        headerText : "Request ID",
        width : "8%"
      }, {
        dataField : "orgCode",
        headerText : "Org Code",
        width : "10%"
      }, {
          dataField : "grpCode",
          headerText : "Grp Code",
          width : "10%"
      }, {
          dataField : "deptCode",
          headerText : "Dept Code",
          width : "10%"
      }, {
          dataField : "approvalRemark",
          headerText : "Remark",
          width : "8%"
      }
      ];

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
    gridIDExcelHide = GridCommon.createAUIGrid("grid_wrap_hide", columnLayout, "", excelGridPros);
  }

  $(document).ready(function() {

	    $("#cpeReqId").val("${memCode}");

	    if("${SESSION_INFO.memberLevel}" =="1"){

	        $("#orgCode").val("${orgCode}");
	        $("#orgCode").attr("class", "w100p readonly");
	        $("#orgCode").attr("readonly", "readonly");

	    }else if("${SESSION_INFO.memberLevel}" =="2"){

	        $("#orgCode").val("${orgCode}");
	        $("#orgCode").attr("class", "w100p readonly");
	        $("#orgCode").attr("readonly", "readonly");

	        $("#grpCode").val("${grpCode}");
	        $("#grpCode").attr("class", "w100p readonly");
	        $("#grpCode").attr("readonly", "readonly");

	    }else if("${SESSION_INFO.memberLevel}" =="3"){

	        $("#orgCode").val("${orgCode}");
	        $("#orgCode").attr("class", "w100p readonly");
	        $("#orgCode").attr("readonly", "readonly");

	        $("#grpCode").val("${grpCode}");
	        $("#grpCode").attr("class", "w100p readonly");
	        $("#grpCode").attr("readonly", "readonly");

	        $("#deptCode").val("${deptCode}");
	        $("#deptCode").attr("class", "w100p readonly");
	        $("#deptCode").attr("readonly", "readonly");

	    }else if("${SESSION_INFO.memberLevel}" =="4"){

	        $("#orgCode").val("${orgCode}");
	        $("#orgCode").attr("class", "w100p readonly");
	        $("#orgCode").attr("readonly", "readonly");

	        $("#grpCode").val("${grpCode}");
	        $("#grpCode").attr("class", "w100p readonly");
	        $("#grpCode").attr("readonly", "readonly");

	        $("#deptCode").val("${deptCode}");
	        $("#deptCode").attr("class", "w100p readonly");
	        $("#deptCode").attr("readonly", "readonly");

	        $("#code").val("${memCode}");
	        $("#code").attr("class", "w100p readonly");
	        $("#code").attr("readonly", "readonly");


	        $("#memLvl").attr("class", "w100p readonly");
	        $("#memLvl").attr("readonly", "readonly");
	    }

      cpeGrid();

      $("#search").click(
        function() {
            fn_search();
          });

       // cell click
       AUIGrid.bind(gridID, "cellClick", function(event) {
           cpeReqId = AUIGrid.getCellValue(gridID, event.rowIndex, "cpeReqId");
       });

       AUIGrid.bind(gridID, "cellDoubleClick", function(event) {
            cpeReqId = AUIGrid.getCellValue(gridID, event.rowIndex, "cpeReqId");
          var selectedItems = AUIGrid.getSelectedItems(gridID);
          if (selectedItems.length <= 0) {
            Common.alert("<spring:message code='service.msg.NoRcd'/>");
            return;
          }

          var itemCpeReqId = selectedItems[0].item.ecpeReqId;
          var itemSalesOrdId = selectedItems[0].item.salesOrdId;
          var itemSalesOrdNo = selectedItems[0].item.salesOrdNo;

          var data = {
                  cpeReqId : itemCpeReqId,
                  salesOrderId : itemSalesOrdId,
                  salesOrderNo : itemSalesOrdNo
          };

          Common.popupDiv("/services/ecom/ecpeDetailPop.do", data, null, true, "ecpeDetailPop");
       });

       doGetComboSepa('/common/selectBranchCodeList.do',  '5', ' - ', '',   'dsc_branch', 'M', 'fn_multiCombo'); //Branch Code
       doGetComboSepa('/common/selectBranchCodeList.do', '1' , ' - ' , '','requestorBranch', 'M' , 'fn_multiCombo');
       doGetCombo("/services/ecom/selectRequestTypeJsonList", '', '', 'reqType', 'M', 'fn_multiCombo');
  });

  function fn_search() {
    Common.ajax("GET", "/services/ecom/selectEcpeRequestList", $("#cpeForm").serialize(),
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
      }).multipleSelect({
          selectAll: true,
          width: '100%'
      });

      $('#reqType').change(function() {
      }).multipleSelect({
          selectAll: true,
          width: '100%'
      });
  }

  function fn_eCpeRequestPop() {
      Common.popupDiv("/services/ecom/eCpeRequest.do" , null, null , true, 'eCpeRequestNewSearchPop');
  }

  function fn_eCpeUpdateApprove() {
      var selectedItems = AUIGrid.getSelectedItems(gridID);
      if (selectedItems.length <= 0) {
        Common.alert("<spring:message code='service.msg.NoRcd'/>");
        return;
      }

      var itemCpeReqId = selectedItems[0].item.ecpeReqId;
      var itemSalesOrdId = selectedItems[0].item.salesOrdId;
      var itemSalesOrdNo = selectedItems[0].item.salesOrdNo;

      var data = {
              cpeReqId : itemCpeReqId,
              salesOrderId : itemSalesOrdId,
              salesOrderNo : itemSalesOrdNo
      };
      if(selectedItems[0].item.status == 'Active'){
    	  Common.popupDiv("/services/ecom/ecpeRqstUpdateApprovePop.do", data, null, true, "ecpeRqstUpdateApprovePop");
      }
      else{
    	  Common.alert("Now allowed to edit CPE <br> CPE status : " + selectedItems[0].item.status);
      }
  }

  function fn_generateCpeRaw() {
      Common.popupDiv("/services/ecom/ecpeGenerateRawPop.do" , null, null , true, 'cpeGenerateRawPop');
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
      <a href="javascript:fn_eCpeRequestPop()">New CPE</a>
     </p></li>
   </c:if>
   <c:if test="${PAGE_AUTH.funcUserDefine2 == 'Y'}">
    <li><p class="btn_blue">
      <a href="javascript:fn_eCpeUpdateApprove()">Approval</a>
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
  <input type="hidden" id="adminFlag" name="adminFlag" value="${PAGE_AUTH.funcUserDefine3}"/>
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
        <th scope="row"><spring:message code='service.grid.Status'/></th>
        <td><select class="multy_select w100p" multiple="multiple"
         id="statusList" name="statusList">

          <c:forEach var="list" items="${cpeStat}" varStatus="status">
            <option value="${list.code}" selected>${list.codeName}</option>
          </c:forEach>

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
      <th scope="row"><spring:message code='cpe.grid.requestId'/></th>
      <td><input type="text" id="cpeReqId" name="cpeReqId"
       placeholder="<spring:message code='cpe.grid.requestId'/>" class="w100p" /></td>
     </tr>
     <tr>
      <th scope="row">Org Code</th>
      <td><input type="text" title="orgCode" id="orgCode" name="orgCode" placeholder="Org Code" class="w100p" /></td>
      <th scope="row">Grp Code</th>
      <td><input type="text" title="grpCode" id="grpCode" name="grpCode"  placeholder="Grp Code" class="w100p"/></td>
      <th scope="row">Dept Code</th>
      <td><input type="text" title="deptCode" id="deptCode" name="deptCode"  placeholder="Dept Code" class="w100p"/></td>
     </tr>
     <tr>
     <th scope="row"><spring:message code="sal.title.text.dscBrnch" /></th>
     <td><select class="multy_select w100p" id="dsc_branch" name="dsc_branch" multiple="multiple"></select>
     </td>
      <th scope="row">
      <td></td>
      </th>
      <th scope="row">
      <td></td>
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
      <c:if test="${PAGE_AUTH.funcUserDefine4 == 'Y'}">
       <li><p class="link_btn"> <a href="javascript:fn_generateCpeRaw()" id="genCpeEnqRaw">e-CPE Raw Data</a> </p></li>
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