<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javascript">
  var listMyGridID_1;
  var prdRtnMand = false;
  var ORD_ID = "${orderDetail.basicInfo.ordId}";
  var PROMO_ID = "${orderDetail.basicInfo.ordPromoId}";
  var PROMO_CODE = "${orderDetail.basicInfo.ordPromoCode}";
  var STOCK_ID = "${orderDetail.basicInfo.stockId}";
  var CUST_ID = "${orderDetail.basicInfo.custId}";

  $(document).ready(function(){
      createAUIGrid();
      setInputFile2();

      if("${typ}" == "10") {
        $('#mstOrd').show();
      } else {
        $('#mstOrd').hide();
      }

      fn_loadListCanc();
      fn_loadOrderInfoCanc();
      fn_isLockOrder();

      $('#OrdNoTagBtn').click(function() {
        Common.popupDiv("/sales/order/orderComboSearchPop.do", {promoNo:PROMO_ID, prod:STOCK_ID, custId : CUST_ID, ord_id : ORD_ID});
      });

      // j_date
      var dateToday = new Date();
      $("#dpCallLogDate").val(dateToday.getDate() + "/" + (dateToday.getMonth()+1) + "/" + dateToday.getFullYear());
      var pickerOpts = { changeMonth:true,
                         changeYear:true,
                         dateFormat: "dd/mm/yy",
                         minDate: dateToday
                       };

      $("#dpCallLogDate").datepicker(pickerOpts);

      // ATTACHMENT
      $(".auto_file").append("<label><span class='label_text'><a href='#'>File</a></span><input type='text' class='input_text' readonly='readonly' /></label>");
  });

  function createAUIGrid() {

    //AUIGrid 칼럼 설정
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
    }, {
      headerText : "salesmanCode",
      dataField : "salesmanCode",
      visible : false
    } ];

    //그리드 속성 설정
    var gridPros = {
      usePaging : true, //페이징 사용
      pageRowCount : 20, //한 화면에 출력되는 행 개수 20(기본값:20)
      editable : false,
      fixedColumnCount : 1,
      showStateColumn : false,
      displayTreeOpen : false,
      //selectionMode       : "singleRow",  //"multipleCells",
      headerHeight : 30,
      useGroupingPanel : false, //그룹핑 패널 사용
      skipReadonlyColumns : true, //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
      wrapSelectionMove : true, //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
      showRowNumColumn : true, //줄번호 칼럼 렌더러 출력
      noDataMessage : "No order found.",
      groupingMessage : "Here groupping"
    };

    listMyGridID_1 = GridCommon.createAUIGrid("grid_wrap_1", columnLayout, "", gridPros);

    if("${typ}" == "10") {
      Common.ajax("GET", "/sales/order/selectCboPckLinkOrdSub2", $("#frmReqCanc").serialize(), function(result) {
        AUIGrid.setGridData(listMyGridID_1, result);
      });
    } else {
      Common.ajax("GET", "/sales/order/selectCboPckLinkOrdSub", $("#frmReqCanc").serialize(), function(result) {
        AUIGrid.setGridData(listMyGridID_1, result);
      });
    }
  }

  function fn_loadListCanc() {
    //doGetComboOrder('/common/selectCodeList.do', '52', 'CODE_ID', '', 'cmbRequestor', 'S', ''); //Common Code
    doGetComboOrder('/sales/order/selectCodeList.do', '52', 'CODE_ID', '', 'cmbRequestor', 'S', ''); //Common Code
    doGetComboData('/sales/order/selectResnCodeList.do', {
      resnTypeId : '536',
      stusCodeId : '1'
    }, '2301', 'cmbReason2', 'S', 'fn_removeOpt'); //Reason Code
  }

  function fn_removeOpt() {
    $('#cmbReason2').find("option").each(
        function() {
          if ($(this).val() == '1638' || $(this).val() == '1979'
              || $(this).val() == '1980'
              || $(this).val() == '1994') {
            $(this).remove();
          }
        });
  }

  function setInputFile2(){//인풋파일 세팅하기
   $(".auto_file2").append("<label><input type='text' class='input_text' readonly='readonly' /><span class='label_text'><a href='#'><spring:message code='commission.text.search.file' /></a></span></label><span class='label_text'><a href='#'><spring:message code='sys.btn.add' /></a></span><span class='label_text'><a href='#'><spring:message code='sys.btn.delete' /></a></span>");
  }

  function goSave() {
    if (!fn_validate()) {
      return;
    } else {
      Common.confirm("<spring:message code='sal.msg.cfmCboPckUnlink'/>" + " <br/> " +  "<spring:message code='sal.msg.cfmCboPckUnlink_2'/>" ,goNext);
    }
  }

  function goNext() {
    Common.ajax("POST", "/sales/order/cboPckReqCanOrd.do", $('#frmReqCanc').serializeJSON(), function(result) {
      Common.alert('<spring:message code="sal.alert.msg.cancReqSum" />' + DEFAULT_DELIMITER + "<b>" + result.message + "</b>", fn_selfClose);
    }, function(jqXHR, textStatus, errorThrown) {
      try {
        Common.alert("Data Preparation Failed" + DEFAULT_DELIMITER + "<b>Saving data prepration failed.</b>");
      } catch (e) {
        console.log(e);
      }
    });
    return;
  }

  function fn_selfClose() {
    $('#btnCloseReq').click();
  }

  function fn_validate() {
    var isValid = true;
    var msg = "";
    var text = "";
    if ($('#cmbRequestor').val() == null || $('#cmbRequestor').val() == "") {
      text = "<spring:message code='sal.text.requestor'/>";
      msg += "<spring:message code='sys.msg.necessary' arguments='" + text + "' htmlEscape='false'/></br/>";
      isValid = false;
    }

    if ($('#dpCallLogDate').val() == null || $('#dpCallLogDate').val() == "") {
      text = "<spring:message code='sal.text.callLogDate'/>";
      msg += "<spring:message code='sys.msg.necessary' arguments='" + text + "' htmlEscape='false'/></br/>";
      isValid = false;
    }

    if ($('#cmbReason').val() == null || $('#cmbReason').val() == "") {
      text = "<spring:message code='sal.text.reason'/>";
      msg += "<spring:message code='sys.msg.necessary' arguments='" + text + "' htmlEscape='false'/></br/>";
      isValid = false;
    }

    if (prdRtnMand) {
      if ($('#dpReturnDate').val() == null || $('#dpReturnDate').val() == "") {
        text = "<spring:message code='sal.alert.msg.prefRtrnDt'/>";
        msg += "<spring:message code='sys.msg.necessary' arguments='" + text + "' htmlEscape='false'/></br/>";
        isValid = false;
      }
    }

    if ($('#txtRemark').val() == null || $('#txtRemark').val() == "") {
      text = "<spring:message code='sal.text.ocrRem'/>";
      msg += "<spring:message code='sys.msg.necessary' arguments='" + text + "' htmlEscape='false'/></br/>";
      isValid = false;
    }

    if("${typ}" == "10") {
      if ($('#hiddenCboOrdNoTag').val() == null || $('#hiddenCboOrdNoTag').val() == "") {
        text = "<spring:message code='sales.OrderNo' />";
        msg += "<spring:message code='sys.msg.necessary' arguments='" + text + "' htmlEscape='false'/></br/>";
        isValid = false;
      }
    }

    if (!isValid) {
      Common.alert(msg);
      return false;
    }

    return true;
  }

  function fn_loadOrderInfoCanc() {
    if ($('#ordStat').val() == '4') {
      $('#spPrfRtnDt').removeClass("blind");
      //$('#dpReturnDate').removeAttr("disabled");
      prdRtnMand = true;

      var dateToday = new Date();
      $('#dpReturnDate').val(dateToday.getDate() + "/" + (dateToday.getMonth()+1) + "/" + dateToday.getFullYear());

      if ($('#appTypeId').val() == '66') {
        $('#scOP').removeClass("blind");
      }
    }

    var vObligtPriod = fn_getObligtPriod();
    $('#txtObPeriod').val(vObligtPriod);
    fn_loadOutstandingPenaltyInfo();
  }


  function fn_getObligtPriod() {
    var vObligtPriod = 0;
    Common.ajaxSync("GET", "/sales/order/selectObligtPriod.do", {
      salesOrdId : $('#salesOrdId').val()
    }, function(result) {
      if (result != null) {
        vObligtPriod = result.obligtPriod;
      }
    });

    return vObligtPriod;
  }

  function fn_loadOutstandingPenaltyInfo() {
    if ($('#appTypeId').val() == '66' && $('#ordStat').val() == '4') {
      var vTotalUseMth = fn_getOrderLastRentalBillLedger1();

      if (FormUtil.isNotEmpty(vTotalUseMth)) {
        $('#txtTotalUseMth').val(vTotalUseMth);
      }
      //TOCHECK
      $('#txtRentalFees').val("${orderDetail.basicInfo.ordMthRental}");

      var vCurrentOutstanding = fn_getOrderOutstandingInfo();

      if (FormUtil.isNotEmpty(vCurrentOutstanding)) {
        $('#txtCurrentOutstanding').val(vCurrentOutstanding);
      }

      fn_calculatePenaltyAndTotalAmount();
    }
  }

  function fn_getOrderLastRentalBillLedger1() {
    var vTotalUseMth = 0;

    Common.ajaxSync("GET", "/sales/order/selectOrderLastRentalBillLedger1.do", {
      salesOrderId : $('#salesOrdId').val()
    }, function(result) {
      if (result != null) {
        vTotalUseMth = result.rentInstNo;
      }
    });
    return vTotalUseMth;
  }

  function fn_getOrderOutstandingInfo() {
    var vCurrentOutstanding = 0;

    Common.ajaxSync("GET", "/sales/order/selectOderOutsInfo.do", {
      ordId : $('#salesOrdId').val()
    }, function(result) {
      if (result != null && result.length > 0) {
        vCurrentOutstanding = result[0].ordTotOtstnd;
      }
    });
    return vCurrentOutstanding;
  }

  function fn_calculatePenaltyAndTotalAmount() {
    var TotalMthUse = Number($('#txtTotalUseMth').val());
    var ObPeriod = Number($('#txtObPeriod').val());
    var RentalFees = Number($('#txtRentalFees').val());
    var currentOutstandingVal = $('#txtCurrentOutstanding').val();

    currentOutstandingVal = currentOutstandingVal.replace(',', '');

    var CurrentOutstanding = parseFloat(currentOutstandingVal);
    var PenaltyAdj = Number($('#txtPenaltyAdj').val());
    var PenaltyAmt = 0;

    if ("${orderDetail.isNewVer}" == 'N') {
      if (TotalMthUse < ObPeriod) {
        PenaltyAmt = ((RentalFees * (ObPeriod - TotalMthUse)) / 2);
      }
    } else {
      PenaltyAmt = fn_getPenaltyAmt(TotalMthUse, ObPeriod);
    }

    $('#txtPenaltyCharge').val(PenaltyAmt);

    var TotalAmt = CurrentOutstanding + PenaltyAmt + PenaltyAdj;

    $('#txtTotalAmount').val(TotalAmt);
    $('#spTotalAmount').text(TotalAmt);
  }

  function fn_getPenaltyAmt(usedMnth, obPeriod) {
    var vPenaltyAmt = 0;

    Common.ajaxSync("GET", "/sales/order/selectPenaltyAmt.do", {
      salesOrdId : $('#salesOrdId').val(),
      usedMnth : usedMnth,
      obPeriod : obPeriod
    }, function(result) {
      if (result != null) {
        vPenaltyAmt = result.penaltyAmt;
      }
    });
    return vPenaltyAmt;
  }

  function fn_setBindComboOrd(ordNo, ordId) {
    $('#cboOrdNoTag').val(ordNo);
    $('#hiddenCboOrdNoTag').val(ordId);
  }

  function fn_isLockOrder() {
    var isLock = false;
    var msg = "";
    var ORD_ID = '${orderDetail.logView.salesOrdId}';
    if (("${orderDetail.logView.isLok}" == '1' && "${orderDetail.logView.prgrsId}" != 2) || "${orderDetail.logView.prgrsId}" == 1) {

      if ("${orderDetail.logView.prgrsId}" == 1) {
        Common.ajaxSync("GET", "/sales/order/checkeAutoDebitDeduction.do",
        {
          salesOrdId : ORD_ID
        },
        function(rsltInfo) {
          if (rsltInfo.ccpStus == 1 || rsltInfo.eCashStus == 1) {
            isLock = true;
            msg = 'This order is under progress [ eCash Deduction ].<br />' + rsltInfo.msg + '.<br/>';
          }
        });
      } else {
        isLock = true;
        msg = 'This order is under progress [' + "${orderDetail.logView.prgrs}" + '].<br />';
      }
    }

    //BY KV order installation no yet complete (CallLog Type - 257, CCR0001D - 20, SAL00046 - Active )
    Common.ajaxSync("GET", "/sales/order/validOCRStus.do",
    {
      salesOrdId : ORD_ID
    },
    function(result) {
      if (result.callLogResult == 1) {
        isLock = true;
        msg = 'This order is under progress [ Call for Install ].<br />' + result.msg + '.<br/>';
      }
    });

    /*BY KV - waiting call for installation, cant do product return , ccr0006d active but SAL0046D no record */
    //Valid OCR Status - (CallLog Type - 257, CCR0001D - 1, SAL00046 - NO RECORD  )
    Common.ajaxSync("GET", "/sales/order/validOCRStus2.do",
    {
      salesOrdId : ORD_ID
    },
    function(result) {
      if (result.callLogResult == 1) {
        isLock = true;
        msg = 'This order is under progress [ Call for Install ].<br />' + result.msg + '.<br/>';
      }
    });

    //BY KV -order cancellation no yet complete sal0020d)
    Common.ajaxSync("GET", "/sales/order/validOCRStus3.do", {
      salesOrdId : ORD_ID
    }, function(result) {
      if (result.callLogResult == 1) {
        isLock = true;
        msg = 'This order is under progress [ Call for Cancel ].<br />' + result.msg + '.<br/>';
      }
    });

    //By KV - Valid OCR Status - (CallLog Type - 259, SAL0020D - 32 LOG0038D Stus - Active )
    Common.ajaxSync("GET", "/sales/order/validOCRStus4.do",
    {
      salesOrdId : ORD_ID
    },
    function(result) {
      if (result.callLogResult == 1) {
        isLock = true;
        msg = 'This order is under progress [Confirm To Cancel ].<br />' + result.msg + '.<br/>';
      }
    });

    if (isLock) {
      msg += '<spring:message code="sal.alert.msg.cancDisallowed" />';
      fn_disableControlCanc();
      Common.alert('<spring:message code="sal.alert.msg.ordLock" />' + DEFAULT_DELIMITER + "<b>" + msg + "</b>");
      return isLock;
    }
  }

  function fn_disableControlCanc() {
    $('#attchOrd').hide();
    $('#mstOrd').hide();
    $('#detailsOrd').hide();
    $('#scOP').hide();
    $('#sBtn').hide();
  }
</script>
<div id="popup_wrap" class="popup_wrap">
 <!-- popup_wrap start -->
 <header class="pop_header">
  <!-- pop_header start -->
  <h1>Unlink Combo Promo. Order</h1>
  <ul class="right_opt">
   <li><p class="btn_blue2">
     <a id="btnCloseReq"  href="#"><spring:message code="sal.btn.close" /></a>
    </p></li>
  </ul>
 </header>
 <!-- pop_header end -->
 <section class="pop_body">
  <!-- pop_body start -->
  <aside class="title_line">
   <!-- title_line start -->
  </aside>
  <!-- title_line end -->

  <%@ include file="/WEB-INF/jsp/sales/order/orderDetailContent.jsp"%>

  <br/>

  <section class="search_table">
   <!-- search_table start -->
   <form action="#" method="post" id="frmReqCanc" name="frmReqCanc">
    <!-- <table class="type1">
     <caption>table</caption>
     <colgroup>
      <col style="width: 180px" />
      <col style="width: *" />
     </colgroup>
     <tbody>
      <tr>
       <th scope="row">Order No.</th>
       <td>
         <input type="text" title="Order No." placeholder="Order No." id="ordNo_1" name="ordNo_1" value="${ordNo}" class="readonly" readonly="readonly"/>
       </td>
      </tr>
     </tbody>
    </table>  -->

    <article class="grid_wrap"><!-- grid_wrap start -->
      <div id="grid_wrap_1" style="width:100%; height:200px; margin:0 auto;"></div>
    </article>

    <table class="type1" id="attchOrd" name="attchOrd">
     <!-- table start -->
     <caption>table</caption>
     <colgroup>
      <col style="width: 180px" />
      <col style="width: *" />
     </colgroup>
     <tbody>
      <tr>
       <th scope="row"><spring:message code='budget.Attathment' /></th>
       <td colspan="3">
        <div class="auto_file attachment_file w100p">
         <!-- auto_file start -->
         <input id="certRefFile" name="certRefFile" type="file" title="file add" />
        </div> <!-- auto_file end -->
       </td>
      </tr>
     </tbody>
    </table>

    <table class="type1" id="mstOrd" name="mstOrd">
     <!-- table start -->
     <caption>table</caption>
     <colgroup>
      <col style="width: 180px" />
      <col style="width: *" />
     </colgroup>
     <tbody>
      <tr>
       <th scope="row"><spring:message code='sales.OrderNo' /> <span class="must">*</span></th>
       <td colspan="3">
        <input id="cboOrdNoTag" name="cboOrdNoTag" type="text" title="" placeholder="" class="" disabled="disabled"/>
        <input id="hiddenCboOrdNoTag" name="hiddenCboOrdNoTag" type="hidden"  />
        <a id="OrdNoTagBtn" href="#" class="search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
       </td>
      </tr>
     </tbody>
    </table>

     <table class="type1" id="detailsOrd" name="detailsOrd">
      <!-- table start -->
      <caption>table</caption>
      <colgroup>
       <col style="width: 180px" />
       <col style="width: *" />
       <col style="width: 180px" />
       <col style="width: *" />
      </colgroup>
      <tbody>
       <tr>
        <th scope="row"><spring:message code="sal.text.requestor" /><span
         class="must"> *</span></th>
        <td><select id="cmbRequestor" name="cmbRequestor"
         class="w100p"></select></td>
        <th scope="row"><spring:message code="sal.text.callLogDate" /><span
         class="must"> *</span></th>
        <td><input id="dpCallLogDate" name="dpCallLogDate"
         type="text" title="Create start Date" placeholder="DD/MM/YYYY"
         class="j_date w100p readonly" readonly = 'readonly'/></td>
       </tr>
       <tr>
        <th scope="row"><spring:message code="sal.text.reason" /><span
         class="must">*</span></th>
        <td><select id="cmbReason2" name="cmbReason2" class="w100p" disabled></select>
        <input id="cmbReason" name="cmbReason" type="hidden" value="2275"/>
        </td>
        <th scope="row"><spring:message
          code="sal.alert.msg.prefRtrnDt" /><span id="spPrfRtnDt"
         class="must blind">*</span></th>
        <td><input id="dpReturnDate" name="dpReturnDate"
         type="text" title="Create start Date" placeholder="DD/MM/YYYY"
         class="j_date w100p" disabled /></td>
       </tr>
       <tr>
        <th scope="row"><spring:message code="sal.text.ocrRem" /><span
         class="must">*</span></th>
        <td colspan="3"><textarea id="txtRemark" name="txtRemark"
          cols="20" rows="5"></textarea></td>
       </tr>
      </tbody>
     </table>

    <section id="scOP" class="blind">
      <aside class="title_line">
       <!-- title_line start -->
       <h3>
        <spring:message code="sal.page.subTitle.outstndPnltyInfo" />
       </h3>
      </aside>
      <!-- title_line end -->
      <table class="type1">
       <!-- table start -->
       <caption>table</caption>
       <colgroup>
        <col style="width: 180px" />
        <col style="width: *" />
        <col style="width: 180px" />
        <col style="width: *" />
        <col style="width: 180px" />
        <col style="width: *" />
       </colgroup>
       <tbody>
        <tr>
         <td colspan="4"></td>
         <th scope="row"><spring:message code="sales.totAmt_RM" /></th>
         <td class="bg-black"><span id="spTotalAmount"></span> <input
          id="txtTotalAmount" name="txtTotalAmount" type="hidden"
          value="0" /></td>
        </tr>
        <tr>
         <th scope="row"><spring:message
           code="sales.TotalUsedMonth" /></th>
         <td><input id="txtTotalUseMth" name="txtTotalUseMth"
          type="text" class="w100p readonly" value="0" readonly></td>
         <th scope="row"><spring:message
           code="sal.text.obligationPeriod" /></th>
         <td><input id="txtObPeriod" name="txtObPeriod" type="text"
          class="w100p readonly" value="24" readonly></td>
         <th scope="row"><spring:message
           code="sal.title.text.rentalFees" /></th>
         <td><input id="txtRentalFees" name="txtRentalFees"
          type="text" value="0" class="w100p readonly" readonly></td>
        </tr>
        <tr>
         <th scope="row"><spring:message code="sales.PenaltyCharge" /></th>
         <td><input id="txtPenaltyCharge" name="txtPenaltyCharge"
          type="text" class="w100p readonly" value="0" readonly></td>
         <th scope="row"><spring:message
           code="sal.text.penaltyAdjustment" /><span class="must">*</span></th>
         <td><input id="txtPenaltyAdj" name="txtPenaltyAdj"
          type="text" value="0" title=""
          placeholder="Penalty Adjustment" class="w100p" /></td>
         <th scope="row"><spring:message
           code="sal.text.currOutstnd" /></th>
         <td><input id="txtCurrentOutstanding"
          name="txtCurrentOutstanding" type="text" value="0"
          class="w100p readonly" readonly></td>
        </tr>
       </tbody>
      </table>
      <!-- table end -->
     </section>

    <!-- table end -->
    <ul class="center_btns">
     <li><p class="btn_blue2">
       <a href="#" onclick="goSave();" id="sBtn" name="sBtn"><spring:message code="sal.btn.save" /></a>
      </p></li>
    </ul>
    <input type="hidden" id="ordNo_1" name="ordNo_1" value="${ordNo}" />
    <input type="hidden" id="salesOrdId" name="salesOrdId" value="${ordId}" />
    <input type="hidden" id="typ" name="typ" value="${typ}" />
    <input type="hidden" id="ordStat" name="ordStat" value="${ordStat}" />
    <input type="hidden" id="appTypeId" name="appTypeId" value="${ordApp}" />
   </form>
  </section>
  <!-- content end -->
 </section>
 <!-- container end -->
</div>
<!-- popup_wrap end -->