<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">
  var regGridID;

  $(document).ready(function() {

    createAUIGrid();

    fn_getASOrderInfo();
    fn_getASEvntsInfo();
    fn_getCallLog();
  });

  function createAUIGrid() {

    var columnLayout = [ {
      dataField : "callRem",
      headerText : "<spring:message code='service.grid.Remark' />",
      editable : false
    }, {
      dataField : "c2",
      headerText : "<spring:message code='service.grid.CrtBy' />",
      width : 80,
      editable : false
    }, {
      dataField : "callCrtDt",
      headerText : "<spring:message code='service.grid.CrtDt' />",
      width : 120,
      dataType : "date",
      formatString : "dd/mm/yyyy"
    }

    ];

    var gridPros = {
      usePaging : true,
      pageRowCount : 20,
      editable : false,
      fixedColumnCount : 1,
      selectionMode : "singleRow",
      showRowNumColumn : true,
      showStateColumn : false
    };
    regGridID = GridCommon.createAUIGrid("reg_grid_wrap", columnLayout, "",
        gridPros);
  }

  function fn_getASOrderInfo() {
    Common.ajax("GET", "/services/as/getASOrderInfo.do", $("#resultASForm")
        .serialize(), function(result) {

      $("#txtASNo").text($("#AS_NO").val());
      $("#txtOrderNo").text(result[0].ordNo);
      $("#txtAppType").text(result[0].appTypeCode);
      $("#txtCustName").text(result[0].custName);
      $("#txtCustIC").text(result[0].custNric);
      $("#txtContactPerson").text(result[0].instCntName);

      $("#txtTelMobile").text(result[0].instCntTelM);
      $("#txtTelResidence").text(result[0].instCntTelR);
      $("#txtTelOffice").text(result[0].instCntTelO);
      //$("#txtInstallAddress").text(result[0].instCntName);
      $("#txtInstallAddress").text(result[0].instAddrDtl);

      $("#txtProductCode").text(result[0].stockCode);
      $("#txtProductName").text(result[0].stockDesc);
      $("#txtSirimNo").text(result[0].lastInstallSirimNo);
      $("#txtSerialNo").text(result[0].lastInstallSerialNo);

      $("#txtCategory").text(result[0].c2);
      $("#txtInstallNo").text(result[0].lastInstallNo);
      $("#txtInstallDate").text(result[0].c1);
      $("#txtInstallBy").text(result[0].lastInstallCtCode);
      $("#txtInstruction").text(result[0].instct);
      $("#txtMembership").text(result[0].c5);
      $("#txtExpiredDate").text(result[0].c6);

      //$("#txtASKeyBy").text(result[0].userFullName);

    });
  }

  function fn_getASEvntsInfo() {
    Common.ajax("GET", "/services/as/getASEvntsInfo.do", $("#resultASForm")
        .serialize(), function(result) {

      $("#txtASStatus").text(result[0].code);
      $("#txtRequestDate").text(result[0].asReqstDt);
      $("#txtRequestTime").text(result[0].asReqstTm);

      $("#txtAppDt").text(result[0].asAppntDt);
      $("#txtAppTm").text(result[0].asAppntTm);

      //$("#txtMalfunctionCode").text('에러코드 정의값');
      //$("#txtMalfunctionReason").text('에러코드 desc');

      $("#txtMalfunctionCode").text(result[0].asMalfuncId);
      $("#txtMalfunctionReason").text(result[0].asMalfuncResnId);

      /* $("#txtDSCCode").text(result[0].c7 +"-" +result[0].c8 ); */
      $("#txtInchargeCT").text(result[0].c10 + "-" + result[0].c11);

      $("#txtRequestor").text(result[0].c3);
      $("#txtASKeyBy").text(result[0].c1);
      $("#txtRequestorContact").text(result[0].asRemReqsterCntc);
      $("#txtASKeyAt").text(result[0].asCrtDt);
      $("#prevServiceArea").text(result[0].prevSvcArea);
      $("#nextServiceArea").text(result[0].nextSvcArea);
      $("#distance").text(result[0].distance);



    });
  }
  function fn_getCallLog() {
    Common.ajax("GET", "/services/as/getCallLog", $("#resultASForm")
        .serialize(), function(result) {
      AUIGrid.setGridData(regGridID, result);
    });
  }

</script>
<div id="popup_wrap" class="popup_wrap">
 <!-- popup_wrap start -->
 <form id="resultASForm" method="post">
  <div style="display: none">
   <input type="text" name="AS_ID" id="AS_ID" value="${AS_ID}" /> <input
    type="text" name="ORD_ID" id="ORD_ID" value="${ORD_ID}" /> <input
    type="text" name="ORD_NO" id="ORD_NO" value="${ORD_NO}" /> <input
    type="text" name="AS_NO" id="AS_NO" value="${AS_NO}" />
  </div>
 </form>
 <header class="pop_header">
  <!-- pop_header start -->
  <h1><spring:message code='sys.btn.view' /> <spring:message code='service.title.ASApp' /></h1>
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
    <li><a href="#" class="on"><spring:message code='service.title.OrderInformation' /></a></li>
    <li><a href="#"><spring:message code='service.title.General' /></a></li>
    <!-- <li><a href="#"><spring:message code='service.title.asPassEvt' /></a></li> -->
   </ul>

   <article class="tap_area">
     <!------------------------------------------------------------------------------
      Order Detail Page Include START
      ------------------------------------------------------------------------------->
      <%@ include file="/WEB-INF/jsp/sales/order/orderDetailContent.jsp"%>
     <!------------------------------------------------------------------------------
      Order Detail Page Include END
      ------------------------------------------------------------------------------->
   </article>

   <article class="tap_area">
    <!-- tap_area start -->
    <table class="type1">
     <!-- table start -->
     <caption>table</caption>
     <colgroup>
      <col style="width: 150px" />
      <col style="width: *" />
      <col style="width: 150px" />
      <col style="width: *" />
      <col style="width: 150px" />
      <col style="width: *" />
     </colgroup>
     <tbody>
        <tr>
         <th scope="row"><spring:message code='service.grid.ASNo' /></th>
         <td><span id="txtASNo"></span></td>
         <th scope="row"><spring:message code='service.grid.SalesOrder' /></th>
         <td><span id="txtOrderNo"></span></td>
         <th scope="row"><spring:message code='service.title.ApplicationType' /></th>
         <td><span id="txtAppType"></span></td>
        </tr>
        <tr>
         <th scope="row"><spring:message code='service.title.asStatus' /></th>
         <td><span id='txtASStatus'></span></td>
         <th scope="row">Malfunction Code</th>
         <td><span id='txtMalfunctionCode'><c:out
          value="${AsEventInfo.malfuCode}" /></span></td>
         <th scope="row">Malfunction Reason</th>
         <td><span id='txtMalfunctionReason'><c:out
          value="${AsEventInfo.malfuReason}" /></span></td>
        </tr>
        <tr>
         <th scope="row"></th>
         <td><span></span></td>
         <th scope="row"><spring:message code='service.grid.ReqstDt' /></th>
         <td><span id='txtRequestDate'></span></td>
         <th scope="row"><spring:message code='service.title.ReqstTm' /></th>
         <td><span id='txtRequestTime'></span></td>
        </tr>
        <tr>
         <th scope="row"></th>
         <td><span></span></td>
         <th scope="row"><spring:message code='service.title.AppointmentDate' /></th>
         <td><span id='txtAppDt'></span></td>
         <th scope="row"><spring:message code='service.title.AppointmentTm' /></th>
         <td><span id='txtAppTm'></span></td>
        </tr>
        <tr>
         <th scope="row"><spring:message code='service.title.DSCCode' /></th>
         <td><span id='txtDSCCode'><c:out
          value="${AsEventInfo.dsc}" /></span></td>
         <th scope="row"><spring:message code='service.title.InchargeCT' /></th>
         <td colspan="3"><span id='txtInchargeCT'></span></td>
        </tr>
        <tr>
         <th scope="row"><spring:message code='service.title.CustomerName' /></th>
         <td colspan="3"><span id="txtCustName"></span></td>
         <th scope="row"><spring:message code='service.title.NRIC_CompanyNo' /></th>
         <td><span id="txtCustIC"></span></td>
        </tr>
        <tr>
         <th scope="row"><spring:message code='service.title.ContactNo' /></th>
         <td colspan="5"><span id="txtContactPerson"></span></td>
        </tr>
        <tr>
         <th scope="row"><spring:message code='sal.text.telM' /></th>
         <td><span id="txtTelMobile"></span></td>
         <th scope="row"><spring:message code='sal.text.telR' /></th>
         <td><span id="txtTelResidence"></span></td>
         <th scope="row"><spring:message code='sal.text.telO' /></th>
         <td><span id="txtTelOffice"></span></td>
        </tr>
        <tr>
         <th scope="row"><spring:message code='service.title.InstallationAddress' /></th>
         <td colspan="5"><span id="txtInstallAddress"></span></td>
        </tr>
        <tr>
         <th scope="row"><spring:message code='service.title.Rqst' /></th>
         <td colspan="3"><span id="txtRequestor"></span></td>
         <th scope="row"><spring:message code='service.grid.CrtBy' /></th>
         <td></td>
        </tr>
        <tr>
         <th scope="row"><spring:message code='service.title.RqstCtc' /></th>
         <td colspan="3"><span id="txtRequestorContact"></span></td>
         <th scope="row"><spring:message code='sal.text.createDate' /></th>
         <td><span id="txtASKeyAt"></span></td>
        </tr>
       </tbody>
    </table>
   </article>
  </section>
  <!-- tap_wrap end -->
  <aside class="title_line">
   <!-- title_line start -->
   <h2><spring:message code='sal.tap.title.callLogList' /></h2>
  </aside>
  <!-- title_line end -->
  <article class="grid_wrap">
   <!-- grid_wrap start -->
   <div id="reg_grid_wrap"
    style="width: 100%; height: 300px; margin: 0 auto;"></div>
  </article>
  <!-- grid_wrap end -->
 </section>
 <!-- pop_body end -->