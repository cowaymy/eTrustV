<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<!--
 DATE        BY     VERSION        REMARK
 ----------------------------------------------------------------
 08/02/2019  ONGHC  1.0.0       RE-STRUCTURE JSP.
 07/08/2020  FANNIE  1.0.1       Add Order View Tab
 -->

<script type="text/javaScript">
  var myGridID_view;
  $(document).ready(
    function() {
      createInstallationViewAUIGrid();
      fn_viewInstallResultSearch();

      var callType = "${callType.typeId}";
      if (callType == 0) {
        // * Installation information data error. Please contact to IT Department.
        $(".red_text").text("<spring:message code='service.msg.InstallationInformation'/>");
      } else {
        if (callType == 258) {
          //$(".tap_type1").li[1].text("Product Exchange Info");
        } else {}

        if ("${orderInfo.c9}" == 21) {
          //* This installation status is failed. Please do the call log process again.
          $(".red_text").text("<spring:message code='service.msg.InstallationStatus'/>");
        } else if ("${orderInfo.c9}" == 4) {
          // * This installation status is completed.<br />  To reverse this order installation result, please proceed to order installation result reverse.
          $(".red_text").text("<spring:message code='service.msg.InstallationCompleted'/>");
        } else {}
      }

      AUIGrid.bind(myGridID_view, "cellDoubleClick",
        function(event) {
          var statusCode = AUIGrid.getCellValue(myGridID_view, event.rowIndex, "resultId");
          Common.popupDiv("/services/installationResultPop.do?isPop=true&resultId="+ AUIGrid.getCellValue(myGridID_view, event.rowIndex, "resultId"));
        });
  });

  function fn_viewInstallResultSearch() {
    var jsonObj = {
      installEntryId : $("#installEntryId").val()
    };

    Common.ajax("GET", "/services/viewInstallationSearch.do", jsonObj,
        function(result) {
          AUIGrid.setGridData(myGridID_view, result);
        });
  }

  function createInstallationViewAUIGrid() {
    var columnLayout = [ {
      dataField : "resultId",
      headerText : '<spring:message code="service.grid.ID" />',
      editable : false,
      width : 130
    }, {
      dataField : "code",
      headerText : '<spring:message code="service.grid.Status" />',
      editable : false,
      width : 180
    }, {
      dataField : "installDt",
      headerText : '<spring:message code="service.grid.InstallDate" />',
      editable : false,
      width : 180
    }, {
      dataField : "memCode",
      headerText : '<spring:message code="service.grid.CTCode" />',
      editable : false,
      width : 250
    }, {
      dataField : "name",
      headerText : '<spring:message code="service.grid.CTName" />',
      editable : false,
      width : 180
    } ];

    var gridPros = {
      usePaging : true,
      pageRowCount : 20,
      editable : true,
      showStateColumn : true,
      displayTreeOpen : true,
      headerHeight : 30,
      skipReadonlyColumns : true,
      wrapSelectionMove : true,
      showRowNumColumn : false,
    };

    //myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout, gridPros);
    myGridID_view = AUIGrid.create("#grid_wrap_view", columnLayout, gridPros);
  }

  var gridPros = {
    usePaging : true,
    pageRowCount : 20,
    editable : true,
    fixedColumnCount : 1,
    showStateColumn : true,
    displayTreeOpen : true,
    selectionMode : "singleRow",
    headerHeight : 30,
    useGroupingPanel : true,
    skipReadonlyColumns : true,
    wrapSelectionMove : true,
    showRowNumColumn : false
  };

</script>
<div id="popup_wrap" class="popup_wrap">
 <!-- popup_wrap start -->
 <header class="pop_header">
  <h1>
   <spring:message code='service.title.InstallationResultDetail' />
  </h1>
  <ul class="right_opt">
   <li><p class="btn_blue2">
     <a href="#"><spring:message code='sys.btn.close' /></a>
    </p></li>
  </ul>
 </header>
 <!-- pop_header end -->
 <section class="pop_body">
  <!-- pop_body start -->
  <section class="tap_wrap">
   <!-- tap_wrap start -->
   <ul class="tap_type1">
    <li><a href="#" class="on"><spring:message code='sales.tap.orderView' /></a></li>
    <li><a href="#" ><spring:message code='sales.tap.order' /></a></li>
    <li><a href="#"><spring:message code='sales.tap.customerInfo' /></a></li>
    <li><a href="#"><spring:message code='sales.tap.installationInfo' /></a></li>
    <li><a href="#"><spring:message code='sales.tap.HPInfo' /></a></li>
   </ul>
   <!-- Order View Start -->
   <article class="tap_area">
       <%@ include file="/WEB-INF/jsp/sales/order/orderDetailContent.jsp"%>
   </article>
   <!-- Order View End -->
   <article class="tap_area">
    <!-- tap_area start -->
    <aside class="title_line">
     <!-- title_line start -->
     <h2>
      <spring:message code='service.title.OrderInformation' />
     </h2>
    </aside>
    <!-- title_line end -->
    <input type="hidden" value="<c:out value="${installResult.installEntryId}"/>" id="installEntryId" />
    <table class="type1">
     <!-- table start -->
     <caption>table</caption>
     <colgroup>
      <col style="width: 150px" />
      <col style="width: *" />
      <col style="width: 120px" />
      <col style="width: *" />
      <col style="width: 150px" />
      <col style="width: *" />
     </colgroup>
     <tbody>
      <tr>
       <th scope="row"><spring:message code='service.title.Type' /></th>
       <td><span><c:out value="${installResult.codename1}" /></span>
       </td>
       <th scope="row"><spring:message
         code='service.title.InstallNo' /></th>
       <td><span><c:out
          value="${installResult.installEntryNo}" /></span></td>
       <th scope="row"><spring:message code='service.title.OrderNo' /></th>
       <td><span><c:out value="${installResult.salesOrdNo}" /></span>
       </td>
      </tr>
      <tr>
       <th scope="row"><spring:message code='service.title.RefNo' /></th>
       <td><span><c:out value="${installResult.refNo}" /></span></td>
       <th scope="row"><spring:message
         code='service.title.OrderDate' /></th>
       <td><span><c:out value="${installResult.salesDt}" /></span>
       </td>
       <th scope="row"><spring:message
         code='service.title.ApplicationType' /></th>
       <c:if test="${installResult.codeid1  == '257' }">
        <td><span><c:out value="${orderInfo.codeName}" /></span></td>
       </c:if>
       <c:if test="${installResult.codeid1  == '258' }">
        <td><span><c:out value="${orderInfo.c5}" /></span></td>
       </c:if>
      </tr>
      <tr>
       <th scope="row"><spring:message code='service.title.Remark' /></th>
       <td colspan="5"><span><c:out value="${orderInfo.rem}" /></span>
       </td>
      </tr>
      <tr>
       <th scope="row"><spring:message
         code='service.title.LastUpdatedBy' /></th>
       <td><span><c:out value="${installResult.memCode}" /></span>
       </td>
       <th scope="row"><spring:message code='service.title.Product' /></th>
       <c:if test="${installResult.codeid1  == '257' }">
        <td><span><c:out
           value="${orderInfo.stkCode} - ${orderInfo.stkDesc} " /></span></td>
       </c:if>
       <c:if test="${installResult.codeid1  == '258' }">
        <td><span><c:out
           value="${orderInfo.c6} - ${orderInfo.c7} " /></span></td>
       </c:if>
       <th scope="row"><spring:message
         code='service.title.Promotion' /></th>
       <c:if test="${installResult.codeid1  == '257' }">
        <td><span><c:out
           value="${orderInfo.c3} - ${orderInfo.c4} " /></span></td>
       </c:if>
       <c:if test="${installResult.codeid1  == '258' }">
        <td><span><c:out
           value="${orderInfo.c9} - ${orderInfo.c10} " /></span></td>
       </c:if>
      </tr>
      <tr>
       <th scope="row"><spring:message code='service.title.Price' /></th>
       <c:if test="${installResult.codeid1  == '257' }">
        <td><span><c:out value="${orderInfo.c5}" /></span></td>
       </c:if>
       <c:if test="${installResult.codeid1  == '258' }">
        <td><span><c:out value="${orderInfo.c12}" /></span></td>
       </c:if>
       <th scope="row"><spring:message code='service.title.PV' /></th>
       <c:if test="${installResult.codeid1  == '257' }">
        <td><span><c:out value="${orderInfo.c6}" /></span></td>
       </c:if>
       <c:if test="${installResult.codeid1  == '258' }">
        <td><span><c:out value="${orderInfo.c13}" /></span></td>
       </c:if>
       <th scope="row"></th>
       <td></td>
      </tr>
      <tr>
       <th scope="row"><spring:message
         code='service.title.PrevServiceArea' /></th>
       <c:if test="${installResult.codeid1  == '257' }">
        <td><span><c:out value="${orderInfo.prevSvcArea}" /></span>
        </td>
       </c:if>
       <c:if test="${installResult.codeid1  == '258' }">
        <td><span><c:out value="${orderInfo.prevSvcArea}" /></span>
        </td>
       </c:if>
       <th scope="row"><spring:message
         code='service.title.NextServiceArea' /></th>
       <c:if test="${installResult.codeid1  == '257' }">
        <td><span><c:out value="${orderInfo.nextSvcArea}" /></span>
        </td>
       </c:if>
       <c:if test="${installResult.codeid1  == '258' }">
        <td><span><c:out value="${orderInfo.nextSvcArea}" /></span>
        </td>
       </c:if>
       <th scope="row"><spring:message
         code='service.title.Distance' /></th>
       <c:if test="${installResult.codeid1  == '257' }">
        <td><span><c:out value="${orderInfo.distance}" /></span></td>
       </c:if>
       <c:if test="${installResult.codeid1  == '258' }">
        <td><span><c:out value="${orderInfo.distance}" /></span></td>
       </c:if>
      </tr>
     </tbody>
    </table>
    <!-- table end -->
   </article>
   <!-- tap_area end -->
   <article class="tap_area">
    <!-- tap_area start -->
    <aside class="title_line">
     <!-- title_line start -->
     <h2>
      <spring:message code='service.title.CustomerInformation' />
     </h2>
    </aside>
    <!-- title_line end -->
    <table class="type1">
     <!-- table start -->
     <caption>table</caption>
     <colgroup>
      <col style="width: 150px" />
      <col style="width: *" />
      <col style="width: 140px" />
      <col style="width: *" />
      <col style="width: 130px" />
      <col style="width: *" />
     </colgroup>
     <tbody>
      <tr>
       <th scope="row"><spring:message
         code='service.title.CustomerName' /></th>
       <td><span><c:out value="${customerInfo.name}" /></span></td>
       <th scope="row"><spring:message
         code='service.title.CustomerNRIC' /></th>
       <td><span><c:out value="${customerInfo.nric}" /></span></td>
       <th scope="row"><spring:message code='service.title.Gender' /></th>
       <td><span><c:out value="${customerInfo.gender}" /></span></td>
      </tr>
      <tr>
       <th scope="row" rowspan="4"><spring:message
         code='service.title.MailingAddress' /></th>
       <td colspan="5"><span><c:out
          value="${customerInfo.state}" /></span></td>
      </tr>
      <tr>
       <td colspan="5"><span><c:out
          value="${customerInfo.city}" /></span></td>
      </tr>
      <tr>
       <td colspan="5"><span><c:out
          value="${customerInfo.area}" /></span></td>
      </tr>
      <tr>
       <td colspan="5"><span><c:out
          value="${customerInfo.country}" /></span></td>
      </tr>
      <tr>
       <th scope="row"><spring:message
         code='service.title.ContactPerson' /></th>
       <td><span><c:out value="${customerContractInfo.name}" /></span>
       </td>
       <th scope="row"><spring:message code='service.title.Gender' /></th>
       <td><span><c:out
          value="${customerContractInfo.gender}" /></span></td>
       <th scope="row"><spring:message
         code='service.title.ResidenceNo' /></th>
       <td><span><c:out value="${customerContractInfo.telR}" /></span>
       </td>
      </tr>
      <tr>
       <th scope="row"><spring:message
         code='service.title.MobileNo' /></th>
       <td><span><c:out
          value="${customerContractInfo.telM1}" /></span></td>
       <th scope="row"><spring:message
         code='service.title.OfficeNo' /></th>
       <td><span><c:out value="${customerContractInfo.telO}" /></span>
       </td>
       <th scope="row"><spring:message
         code='service.title.OfficeNo' /></th>
       <td><span><c:out value="${customerContractInfo.telF}" /></span>
       </td>
      </tr>
     </tbody>
    </table>
    <!-- table end -->
   </article>
   <!-- tap_area end -->
   <article class="tap_area">
    <!-- tap_area start -->
    <aside class="title_line">
     <!-- title_line start -->
     <h2>
      <spring:message code='service.title.InstallationInformation' />
     </h2>
    </aside>
    <!-- title_line end -->
    <table class="type1">
     <!-- table start -->
     <caption>table</caption>
     <colgroup>
      <col style="width: 150px" />
      <col style="width: *" />
      <col style="width: 130px" />
      <col style="width: *" />
      <col style="width: 130px" />
      <col style="width: *" />
     </colgroup>
     <tbody>
      <tr>
       <th scope="row"><spring:message
         code='service.title.RequestInstallDate' /></th>
       <td><span><c:out value="${installResult.c3}" /></span></td>
       <th scope="row"><spring:message
         code='service.title.AssignedCT' /></th>
       <td colspan="3"><span id="installResultMember"><c:out
          value="(${installResult.memCode}) ${installResult.name2}" /></span></td>
      </tr>
      <tr>
       <th scope="row" rowspan="4"><spring:message
         code='service.title.InstallationAddress' /></th>
       <td colspan="5"><span><c:out
          value="${customerInfo.state}" /></span></td>
      </tr>
      <tr>
       <td colspan="5"><span><c:out
          value="${installResult.city}" /></span></td>
      </tr>
      <tr>
       <td colspan="5"><span><c:out
          value="${installResult.area}" /></span></td>
      </tr>
      <tr>
       <td colspan="5"><span><c:out
          value="${installResult.country}" /></span></td>
      </tr>
      <tr>
       <th scope="row"><spring:message
         code='service.title.SpecialInstruction' /></th>
       <td><span>1111</span></td>
       <th scope="row"><spring:message
         code='service.title.PreferredDate' /></th>
       <td></td>
       <th scope="row"><spring:message
         code='service.title.PreferredTime' /></th>
       <td></td>
      </tr>
     </tbody>
    </table>
    <!-- table end -->
    <aside class="title_line">
     <!-- title_line start -->
     <h2>
      <spring:message code='service.title.InstallationContactPerson' />
     </h2>
    </aside>
    <!-- title_line end -->
    <table class="type1">
     <!-- table start -->
     <caption>table</caption>
     <colgroup>
      <col style="width: 150px" />
      <col style="width: *" />
      <col style="width: 130px" />
      <col style="width: *" />
      <col style="width: 130px" />
      <col style="width: *" />
     </colgroup>
     <tbody>
      <tr>
       <th scope="row"><spring:message code='service.title.Name' /></th>
       <td><span><c:out value="${installationContract.name}" /></span>
       </td>
       <th scope="row"><spring:message code='service.title.Gender' /></th>
       <td></td>
       <th scope="row"><spring:message
         code='service.title.ResidenceNo' /></th>
       <td><span><c:out value="${installationContract.telR}" /></span>
       </td>
      </tr>
      <tr>
       <th scope="row"><spring:message
         code='service.title.MobileNo' /></th>
       <td><span><c:out
          value="${installationContract.telM1}" /></span></td>
       <th scope="row"><spring:message
         code='service.title.OfficeNo' /></th>
       <td><span><c:out value="${installationContract.telO}" /></span>
       </td>
       <th scope="row"><spring:message code='service.title.FaxNo' /></th>
       <td><span><c:out value="${installationContract.telF}" /></span>
       </td>
      </tr>
     </tbody>
    </table>
    <!-- table end -->
   </article>
   <!-- tap_area end -->
   <article class="tap_area">
    <!-- tap_area start -->
    <aside class="title_line">
     <!-- title_line start -->
     <h2>
      <spring:message code='service.title.HPInformation' />
     </h2>
    </aside>
    <!-- title_line end -->
    <table class="type1">
     <!-- table start -->
     <caption>table</caption>
     <colgroup>
      <col style="width: 150px" />
      <col style="width: *" />
      <col style="width: 135px" />
      <col style="width: *" />
      <col style="width: 130px" />
      <col style="width: *" />
     </colgroup>
     <tbody>
      <tr>
       <th scope="row"><spring:message
         code='service.title.HP_CodyCode' /></th>
       <td><span><c:out value="${hpMember.memCode}" /></span></td>
       <th scope="row"><spring:message
         code='service.title.HP_CodyName' /></th>
       <td><span><c:out value="${hpMember.name1}" /></span></td>
       <th scope="row"><spring:message
         code='service.title.HP_CodyNRIC' /></th>
       <td><span><c:out value="${hpMember.nric}" /></span></td>
      </tr>
      <tr>
       <th scope="row"><spring:message
         code='service.title.MobileNo' /></th>
       <td><span><c:out value="${hpMember.telMobile}" /></span></td>
       <th scope="row"><spring:message code='sales.HouseNo' /></th>
       <td><span><c:out value="${hpMember.telHuse}" /></span></td>
       <th scope="row"><spring:message
         code='service.title.OfficeNo' /></th>
       <td><span><c:out value="${hpMember.telOffice}" /></span></td>
      </tr>
      <tr>
       <th scope="row"><spring:message
         code='service.title.DepartmentCode' /></th>
       <td><span><c:out value="${salseOrder.deptCode}" /></span></td>
       <th scope="row"><spring:message
         code='service.title.GroupCode' /></th>
       <td><span><c:out value="${salseOrder.grpCode}" /></span></td>
       <th scope="row"><spring:message
         code='service.title.OrganizationCode' /></th>
       <td><span><c:out value="${salseOrder.orgCode}" /></span></td>
      </tr>
     </tbody>
    </table>
    <!-- table end -->
   </article>
   <!-- tap_area end -->
  </section>
  <!-- tap_wrap end -->
  <aside class="title_line mt30">
   <!-- title_line start -->
   <h2>
    <spring:message code='service.title.ViewInstallationResult' />
   </h2>
  </aside>
  <!-- title_line end -->
  <article class="grid_wrap">
   <!-- grid_wrap start -->
   <div id="grid_wrap_view"
    style="width: 100%; height: 100px; margin: 0 auto;"></div>
  </article>
  <!-- grid_wrap end -->
  <p class="red_text"></p>
 </section>
 <!-- pop_body end -->
</div>
<!-- popup_wrap end -->
