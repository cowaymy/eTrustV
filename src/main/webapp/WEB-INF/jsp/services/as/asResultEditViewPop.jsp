<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<!--
 DATE        BY     VERSION        REMARK
 ----------------------------------------------------------------
 01/04/2019  ONGHC  1.0.0          RE-STRUCTURE JSP
 26/04/2019  ONGHC  1.0.1          ADD RECALL STATUS
 17/09/2019  ONGHC  1.0.2          AMEND DEFECT DETAIL SECTION
 -->

<!-- AS ORDER > AS MANAGEMENT > VIEW / EDIT AS ENTRY -->
<script type="text/javaScript">
  var regGridID;
  var actPrdCode;

  $(document).ready(function() {

    createAUIGrid();

    fn_getASOrderInfo();
    fn_getASEvntsInfo();
    fn_getASHistoryInfo();
    fn_selectASDataInfo();
  });

  function createAUIGrid() {

    var columnLayout = [ {
      dataField : "asNo",
      headerText : "<spring:message code='service.grid.ASTyp'/>",
      editable : false
    }, {
      dataField : "c2",
      headerText : "<spring:message code='service.grid.ASRs'/>",
      width : 80,
      editable : false,
      dataType : "date",
      formatString : "dd/mm/yyyy"
    }, {
      dataField : "code",
      headerText : "<spring:message code='service.grid.Status'/>",
      width : 80
    },
    //{ dataField : "asReqstDt",       headerText  : "Request Date",  width  : 100 ,editable       : false  ,dataType : "date", formatString : "dd/mm/yyyy"},
    //{ dataField : "asSetlDt",       headerText  : "Settle Date",  width  : 100 ,editable       : false  ,dataType : "date", formatString : "dd/mm/yyyy"},
    {
      dataField : "asReqstDt",
      headerText : "<spring:message code='service.grid.ReqstDt'/>",
      width : 100,
      editable : false
    }, {
      dataField : "asSetlDt",
      headerText : "<spring:message code='service.grid.SettleDate'/>",
      width : 100,
      editable : false
    }, {
      dataField : "c3",
      headerText : "<spring:message code='service.grid.ErrCde'/>",
      width : 150,
      editable : false
    }, {
      dataField : "c4",
      headerText : "<spring:message code='service.grid.ErrDesc'/>",
      width : 150,
      editable : false
    }, {
      dataField : "c5",
      headerText : "<spring:message code='service.grid.CTCode'/>",
      width : 150,
      editable : false
    }, {
      dataField : "c6",
      headerText : "<spring:message code='service.grid.Solution'/>",
      width : 150,
      editable : false
    }, {
      dataField : "c7",
      headerText : "<spring:message code='service.grid.ASAmt'/>",
      width : 150,
      dataType : "numeric",
      formatString : "#,##0.00",
      editable : false
    } ];

    var gridPros = {
      usePaging : true,
      pageRowCount : 20,
      editable : true,
      fixedColumnCount : 1,
      selectionMode : "singleRow",
      showRowNumColumn : true
    };
    regGridID = GridCommon.createAUIGrid("reg_grid_wrap", columnLayout, "",
        gridPros);
  }

  var aSOrderInfo;
  function fn_getASOrderInfo() {
    Common.ajax("GET", "/services/as/getASOrderInfo.do", $("#resultASForm").serialize(), function(result) {
      aSOrderInfo = result[0];

      $("#txtASNo").text($("#AS_NO").val());
      $("#txtOrderNo").text(result[0].ordNo);
      $("#txtAppType").text(result[0].appTypeCode);
      $("#txtCustName").text(result[0].custName);
      $("#txtCustIC").text(result[0].custNric);
      $("#txtContactPerson").text(result[0].instCntName);

      $("#txtTelMobile").text(result[0].instCntTelM);
      $("#txtTelResidence").text(result[0].instCntTelR);
      $("#txtTelOffice").text(result[0].instCntTelO);
      $("#txtInstallAddress").text(result[0].instCntName);

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

      actPrdCode = result[0].stockCode;
      $("#PROD_CDE").val(result[0].stockCode);

      // KR-OHK Serial Check
      $("#pItmCode").val(result[0].stockCode);
      $("#PROD_CAT").val(result[0].c2code);

      doGetCombo('/services/as/getASFilterInfo.do?prdctCd=' + actPrdCode, '', '', 'ddlFilterCode', 'S', '');
    });
  }

  function fn_getASEvntsInfo() {
    Common.ajax("GET", "/services/as/getASEvntsInfo.do", $("#resultASForm")
        .serialize(), function(result) {;

      $("#txtASStatus").text(result[0].code);
      $("#txtRequestDate").text(result[0].asReqstDt);
      $("#txtRequestTime").text(result[0].asReqstTm);

      $("#txtAppDt").text(result[0].asAppntDt);
      $("#txtAppTm").text(result[0].asAppntTm);

      $("#txtMalfunctionCode").text(result[0].asMalfuncId);
      $("#txtMalfunctionReason").text(result[0].asMalfuncResnId);

      //$("#txtMalfunctionCode").text('에러코드 정의값');
      //$("#txtMalfunctionReason").text('에러코드 desc');

      $("#txtDSCCode").text(result[0].c7 + "-" + result[0].c8);
      $("#txtInchargeCT").text(result[0].c10 + "-" + result[0].c11);

      $("#txtRequestor").text(result[0].c3);
      $("#txtASKeyBy").text(result[0].c1);
      $("#txtRequestorContact").text(result[0].asRemReqsterCntc);
      $("#txtASKeyAt").text(result[0].asCrtDt);

      // KR-OHK Serial Check
      $("#hidSerialRequireChkYn").val(result[0].serialRequireChkYn);
      if( $("#hidSerialRequireChkYn").val() == 'Y' ) {
          $("#btnSerialEdit").attr("style", "");
          $("#serialSearch").attr("style", "");

          $("#pLocationType").val(result[0].whLocGb);
          $('#pLocationCode').val(result[0].ctWhLocId);
      }
    });
  }

  function fn_getASHistoryInfo() {

    Common.ajax("GET", "/services/as/getASHistoryInfo.do", $(
        "#resultASForm").serialize(), function(result) {
      AUIGrid.setGridData(regGridID, result);
    });
  }

  var asDataInfo = {};

  function fn_selectASDataInfo() {

    Common.ajax("GET", "/services/as/selectASDataInfo", $("#resultASForm")
        .serialize(), function(result) {
      asDataInfo = result;
    });
  }

  function setPopData() {

    var options = {
      AS_ID : '${AS_ID}',
      AS_SO_ID : '${ORD_ID}',
      AS_RESULT_ID : '${AS_RESULT_ID}',
      AS_RESULT_NO : '${AS_RESULT_NO}',
      MOD : '${MOD}',
      ORD_NO : '${ORD_NO}'
    };

    fn_setASDataInit(options);
    fn_asResult_editPageContral("RESULTEDIT");

    if ('${MOD}' == "RESULTVIEW") {
      $("#btnSaveDiv").attr("style", "display:none");

      $("#btnSaveDiv").attr("style", "display:none");
      $("#addDiv").attr("style", "display:none");

      // KR-OHK Serial Check
      $("#serialSearch").attr("style", "display:none");
      $("#serialEdit").attr("style", "display:none");

      $('#dpSettleDate').attr("disabled", true);
      $('#ddlFailReason').attr("disabled", true);
      $('#tpSettleTime').attr("disabled", true);
      $('#ddlDSCCode').attr("disabled", true);

      $('#ddlErrorCode').attr("disabled", true);
      $('#ddlCTCode').attr("disabled", true);
      $('#ddlErrorDesc').attr("disabled", true);
      $('#ddlWarehouse').attr("disabled", true);
      $('#txtRemark').attr("disabled", true);
      $("#iscommission").attr("disabled", true);
      $("#ddlFilterCode").attr("disabled", true);
      $("#ddlFilterQty").attr("disabled", true);
      $("#ddlFilterPayType").attr("disabled", true);
      $("#ddlFilterExchangeCode").attr("disabled", true);
      $("#txtFilterRemark").attr("disabled", true);
      $("#txtLabourCharge").attr("disabled", true);
      $("#txtFilterCharge").attr("disabled", true);

      $('#def_type').attr("disabled", true);
      $('#def_code').attr("disabled", true);
      $('#def_part').attr("disabled", true);
      $('#def_def').attr("disabled", true);

      $('#def_type_text').attr("disabled", true);
      $('#def_code_text').attr("disabled", true);
      $('#def_part_text').attr("disabled", true);
      $('#def_def_text').attr("disabled", true);

      $('#solut_code').attr("disabled", true);
      $('#solut_code_text').attr("disabled", true);

    }
  };
</script>
<div id="popup_wrap" class="popup_wrap">
 <!-- popup_wrap start -->
 <section id="content">
  <!-- content start -->
  <form id="resultASForm" method="post">
   <div style="display: none">
    <input type="text" name="ORD_ID" id="ORD_ID" value="${ORD_ID}" />
    <input type="text" name="ORD_NO" id="ORD_NO" value="${ORD_NO}" />
    <input type="text" name="AS_NO" id="AS_NO" value="${AS_NO}" />
    <input type="text" name="AS_ID" id="AS_ID" value="${AS_ID}" />
    <input type="text" name="MOD" id="MOD" value="${MOD}" />
    <input type="text" name="AS_RESULT_NO" id="AS_RESULT_NO" value="${AS_RESULT_NO}" />
    <input type="text" name="AS_RESULT_ID" id="AS_RESULT_ID" value="${AS_RESULT_ID}" />
    <input type="text" name="PROD_CDE" id="PROD_CDE" />
    <input type="text" name="PROD_CAT" id="PROD_CAT" />
   </div>
  </form>
  <header class="pop_header">
   <!-- pop_header start -->
   <h1>
    <spain id='title_spain'> <c:if
     test="${MOD eq  'RESULTVIEW' }"> <spring:message code='service.btn.viewAs' /> </c:if> <c:if
     test="${MOD eq  'RESULTEDIT' }"> <spring:message code='service.btn.editAs' /> </c:if> </spain>
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
      <li><a href="#" class="on"><spring:message code='service.title.General' /></a></li>
      <li><a href="#"><spring:message code='service.title.OrderInformation' /></a></li>
      <li><a href="#" onclick=" javascirpt:AUIGrid.resize(regGridID, 950,300); "><spring:message code='service.title.asPassEvt' /></a></li>
    </ul>
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
         <td><span id='txtMalfunctionCode'></span></td>
         <th scope="row">Malfunction Reason</th>
         <td><span id='txtMalfunctionReason'></span></td>
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
         <td><span id='txtDSCCode'></span></td>
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
     <!-- table end -->
    </article>
    <!-- tap_area end -->
    <article class="tap_area">
       <!------------------------------------------------------------------------------
          Order Detail Page Include START
         ------------------------------------------------------------------------------->
         <%@ include file="/WEB-INF/jsp/sales/order/orderDetailContent.jsp"%>
       <!------------------------------------------------------------------------------
          Order Detail Page Include END
         ------------------------------------------------------------------------------->
     </article>
    <!-- tap_area end -->
    <article class="grid_wrap">
       <!-- grid_wrap start -->
      </article>
      <!-- grid_wrap end -->
     </article>
     <!-- tap_area end -->
     <article class="tap_area">
      <!-- tap_area start -->
      <article class="grid_wrap">
       <!-- grid_wrap start -->
       <div id="reg_grid_wrap"
        style="width: 100%; height: 300px; margin: 0 auto;"></div>
      </article>
      <!-- grid_wrap end -->
     </article>
    <!-- tap_area end -->
   </section>
   <!-- tap_wrap end -->
   <aside class="title_line">
    <!-- title_line start -->
    <h3 class="red_text"><spring:message code='service.msg.msgFillIn' /></h3>
   </aside>
   <!-- title_line end -->
   <!-- asResultInfo info tab  start...-->
   <jsp:include page='${pageContext.request.contextPath}/services/as/asResultInfoEdit.do' />
   <!-- asResultInfo info tab  end...-->
   <script>
   </script>
   </article>
   <!-- acodi_wrap end -->
   <div id='btnSaveDiv'>
   <ul class="center_btns mt20">
    <li><p class="btn_blue2 big">
      <a href="#" onclick="fn_doSave()"><spring:message code='sys.btn.save' /></a>
     </p></li>
    <li><p class="btn_blue2 big">
      <a href="#" onClick="fn_doClear()"><spring:message code='sys.btn.clear' /></a>
     </p></li>
   </ul>
   </div>
  </section>
  <!-- content end -->
 </section>
 <!-- content end -->
</div>
<!-- popup_wrap end -->
