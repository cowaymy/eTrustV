<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javascript">
  document.write('<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/homecare-js-1.0.js?v=' + new Date().getTime() + '"><\/script>');

  var supOrdGridID;
  var supItmDetailGridID;
  var excelListGridID;

  var MEM_TYPE = '${SESSION_INFO.userTypeId}';

  var ajaxOtp = {
    async : false
  };

  $(document).ready(
     function() {
       createAUIGrid();
       createExcelAUIGrid();
       createPosPaymentDetailGrid();
       gridHide();

        doGetComboSepa('/common/selectBranchCodeList.do', '10', ' - ', '', '_brnchId', 'M', 'fn_multiComboBranch');

        if (MEM_TYPE == "1" || MEM_TYPE == "2" || MEM_TYPE == "7") {
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

            $("#salesmanCd").val("${SESSION_INFO.userName}");
            $("#salesmanPopNm").val("${SESSION_INFO.userFullname}");
            $("#salesmanCd").attr("class", "w100p readonly");
            $("#salesmanCd").attr("readonly", "readonly");
            $("#_memBtn").hide();
          }
        }

        $('#excelDown').click(
          function() {
            var excelProps = { fileName : "Supplement Management",
                                       exceptColumnFields : AUIGrid.getHiddenColumnDataFields(excelListGridID)
                                     };

            AUIGrid.exportToXlsx( excelListGridID, excelProps);
        });

        $('#memBtn').click(
          function() {
            Common.popupDiv("/common/memberPop.do", $("#searchForm").serializeJSON(), null, true);
          });

        $('#salesmanCd').change(function(event) {
          var memCd = $('#salesmanCd').val().trim();

          if (FormUtil.isNotEmpty(memCd)) {
            fn_loadOrderSalesman(0, memCd);
          } else {
            $('#salesmanPopNm').val("");
          }
        });

        $('#salesmanPopNm').change(function(event) {
          var memName = $('#salesmanPopNm').val().trim();

          if (FormUtil.isNotEmpty(memName)) {
            fn_loadOrderSalesman(0, memName);
          } else {
            $('#salesmanPopNm').val("");
          }
        });

        $("#_search").click(
          function() {
            if ($("#_supRefNo").val() == '') {
              if ($("#_sDate").val() == '' || $("#_eDate").val() == '') {
                Common.alert('<spring:message code="sal.alert.msg.supplement.alert.refDtRefOrdMust" />')
                return;
              } else if ($("#_sDate").val() != '' && $("#_eDate").val() != '') {
                if (!js.date.checkDateRange($("#_sDate").val(), $("#_eDate").val(), '<spring:message code="sal.text.createDate" />', "1")) {
                  return;
                }
              }
            }

            AUIGrid.clearGridData(supOrdGridID);
            AUIGrid.clearGridData(supItmDetailGridID);
            fn_getSubListAjax();
        });

        $("#_updateShipTrackNoBtn").click(
          function() {
            var clickChk = AUIGrid.getSelectedItems(supOrdGridID);

            if (clickChk == null || clickChk.length <= 0) {
              Common.alert('<spring:message code="sal.alert.msg.noOrderSelected" />');
              return;
            }

            var supplementForm = {
              supRefId : clickChk[0].item.supRefId,
              supRefStus : clickChk[0].item.supRefStus,
              supRefStg : clickChk[0].item.supRefStg,
              ind : "1"
            };

            var supRefId = clickChk[0].item.supRefId;
            var supRefStusId = clickChk[0].item.supRefStusId;
            var supRefStgId = clickChk[0].item.supRefStgId;

            // TEMPORARY CLOSE FOR TESTING
            //if (supRefStusId == 1 && (supRefStgId == 3 || supRefStgId == 4)) {
              Common.popupDiv("/supplement/supplementTrackNoPop.do",supplementForm,null, true, '_insDiv');
            //} else {
            //  Common.alert('<spring:message code="supplement.alert.supplementUpdTrckErr" />');
            //  return;
            //}
          });

          $("#_viewBtn").click(
            function() {
              var clickChk = AUIGrid.getSelectedItems(supOrdGridID);

               if (clickChk == null || clickChk.length <= 0) {
                 Common.alert('<spring:message code="sal.alert.msg.noRecordSelected" />');
                 return;
               }

               var supplementForm = {
                 supRefId : clickChk[0].item.supRefId,
                 ind : "1"
               };

               Common.popupDiv("/supplement/supplementViewPop.do", supplementForm, null, true, '_insDiv');
           });

          $("#_updateDeliveryStatGDexBtn").click(function() {
            var selectedItems = AUIGrid.getCheckedRowItems(supOrdGridID);
            var suppOrds = [];

            if (selectedItems.length <= 0) {
              Common.alert('<spring:message code="sal.alert.msg.noOrderSelected" />');
              return;
            }

            for (var a=0; a < selectedItems.length; a++) {
              // CHECK TRACKING NO.
              if (selectedItems[a].item.parcelTrackNo === "" || selectedItems[a].item.parcelTrackNo === undefined) {
                  Common.alert('<spring:message code="supplement.alert.updDelStatNoTckNo" />'+ " " + selectedItems[a].item.supRefNo);
                  return;
              }

              // NO ACTION IF DELIVERY STATUS AFTER DELIVERED (>4)
              if (selectedItems[a].item.supRefDelStus >= 4) {
                  Common.alert('<spring:message code="supplement.alert.updDelStatDelStatCom" />' + " " + selectedItems[a].item.supRefNo);
                  return;
              }

              var item = {
                ordNo : selectedItems[a].item.supRefNo,
                trckNo: selectedItems[a].item.parcelTrackNo
              }

              suppOrds.push(item);
            }

            // GET & UPDATE DELIVERY STATUS
            Common.ajax("POST", "/supplement/updOrdDelStatGdex.do", {ords : suppOrds}, function(result) {
              Common.alert('<spring:message code="supplement.alert.updDelStatDelStatTtl" />'  + " </br>" +result.message);
              // REFRESH THE GRID
              AUIGrid.clearGridData(supOrdGridID);
              AUIGrid.clearGridData(supItmDetailGridID);
              fn_getSubListAjax();
            });
          });

          $("#_updateDeliveryStatDhlBtn").click(function() {
            var selectedItems = AUIGrid.getCheckedRowItems(supOrdGridID);
            var suppOrds = [];
            var supShptNo = [];

            if (selectedItems.length <= 0) {
              Common.alert('<spring:message code="sal.alert.msg.noOrderSelected" />');
              return;
            }

            for (var a=0; a < selectedItems.length; a++) {
              // CHECK TRACKING NO.
              if (selectedItems[a].item.parcelTrackNo === "" || selectedItems[a].item.parcelTrackNo === undefined) {
                  Common.alert('<spring:message code="supplement.alert.updDelStatNoTckNo" />'+ " " + selectedItems[a].item.supRefNo);
                  return;
              }

              // NO ACTION IF DELIVERY STATUS AFTER DELIVERED (>4)
              if (selectedItems[a].item.supRefDelStus == 4) {
                Common.alert('<spring:message code="supplement.alert.updDelStatDelStatCom" />' + " " + selectedItems[a].item.supRefNo);
                return;
              }

              suppOrds.push(selectedItems[a].item.supRefNo);
              supShptNo.push(selectedItems[a].item.parcelTrackNo);
            }

            // GET & UPDATE DELIVERY STATUS
            Common.ajax("POST", "/supplement/updOrdDelStatDhl.do", {ordNo : suppOrds, consNo : supShptNo}, function(result) {
              Common.alert('<spring:message code="supplement.alert.updDelStatDelStatTtl" />'  + " </br>" +result.message);
              // REFRESH THE GRID
              AUIGrid.clearGridData(supOrdGridID);
              AUIGrid.clearGridData(supItmDetailGridID);
              fn_getSubListAjax();
            });
          });

          AUIGrid.bind(supOrdGridID, "cellClick", function(event) {
            AUIGrid.clearGridData(supItmDetailGridID);

            var detailParam = {
              supRefNo : event.item.supRefNo
            };

            var detailParam = {
              supRefId : event.item.supRefId
            };

            Common.ajax("GET", "/supplement/getSupplementDetailList", detailParam, function(result) {
              AUIGrid.setGridData(supItmDetailGridID, result);
              AUIGrid.setGridData(excelListGridID, result);
            });
          });

          AUIGrid.bind( supOrdGridID,
                             "cellEditBegin",
                              function(event) {
                                if (event.item.posTypeId == 1361) {
                                  Common.alert('<spring:message code="sal.alert.msg.canNotChngStatus" />');
                                  return false;
                                }

                                if (event.value != 1 && event.value != 96) {
                                  Common.alert('<spring:message code="sal.alert.msg.canNotChngStatus" />');
                                  return false;
                                }

                                return true;
          });

          AUIGrid.bind( supItmDetailGridID,
                             "cellEditBegin",
                             function(event) {
                               if (event.item.posTypeId == 1361) {
                                 Common.alert('<spring:message code="sal.alert.msg.canNotChngStatusByReversal" />');
                                 return false;
                               }

                               if (event.value != 96) {
                                 Common.alert('<spring:message code="sal.alert.msg.canNotChngStatus" />');
                                 return false;
                               }
                               return true;
          });

          $("#_posRawDataBtn").click(
            function() {
              Common.popupDiv( "/sales/pos/posRawDataPop.do", '', null, null, true);
          });
  });

  function fn_multiComboBranch() {
    if ($("#_brnchId option[value='${SESSION_INFO.userBranchId}']").val() === undefined) {
      $('#_brnchId').change(function() {
        console.log($(this).val());
      }).multipleSelect({
        selectAll : true, // 전체선택
        width : '100%'
      }).multipleSelect("enable");
      //   $('#_brnchId').multipleSelect("checkAll");
    } else {
      if ('${PAGE_AUTH.funcUserDefine2}' == "Y") {
        $('#_brnchId').change(function() {
          console.log($(this).val());
        }).multipleSelect({
          selectAll : true, // 전체선택
          width : '100%'
        }).multipleSelect("enable");
        //   $('#_brnchId').multipleSelect("checkAll");
      } else {
        $('#_brnchId').change(function() {
          console.log($(this).val());
        }).multipleSelect({
          selectAll : true, // 전체선택
          width : '100%'
        }).multipleSelect("disable");
        $("#_brnchId").multipleSelect("setSelects",
            [ '${SESSION_INFO.userBranchId}' ]);
      }
    }
  }

  function gridHide() {
    $("#_deducGridDiv").css("display", "none");
    $("#_itmDetailGridDiv").css("display", "none");
  }

  function createPosPaymentDetailGrid() {
    var subItmColumnLayout = [
    {
      dataField : "itemCode",
      headerText : "<spring:message code='log.head.itemcode'/>",
      width : '10%',
      editable : false
    }, {
      dataField : "itemDesc",
      headerText : "<spring:message code='log.head.itemdescription'/>",
      width : '60%',
      editable : false
    }, {
      dataField : "quantity",
      headerText : "<spring:message code='pay.head.quantity'/>",
      width : '10%',
      editable : false
    }, {
      dataField : "unitPrice",
      headerText : "<spring:message code='pay.head.unitPrice'/>",
      width : '10%',
      editable : false,
      dataType : "numeric",
      formatString : "#,##0.00"
    }, {
      dataField : "totalAmount",
      headerText : "<spring:message code='pay.head.totalAmount'/>",
      width : '10%',
      editable : false,
      dataType : "numeric",
      formatString : "#,##0.00"
    }
    ];

    var paymentGridPros = {
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

    supItmDetailGridID = GridCommon.createAUIGrid("#sub_itm_detail_grid_wrap", subItmColumnLayout, '', paymentGridPros);

    var footerLayout = [ {
        labelText : "Total",
        positionField : "#base"
      }, {
        dataField : "totalAmount",
        positionField : "totalAmount",
        operation : "SUM",
        formatString : "#,##0.00",
        style : "aui-grid-my-footer-sum-total2"
      } ];

        AUIGrid.setFooter(supItmDetailGridID, footerLayout);
  }

  $.fn.clearForm = function() {
    return this.each(function() {
      var type = this.type, tag = this.tagName.toLowerCase();
      if (tag === 'form') {
        return $(':input', this).clearForm();
      }
      if (type === 'text' || type === 'password' || type === 'hidden'
          || tag === 'textarea') {
        this.value = '';
      } else if (type === 'checkbox' || type === 'radio') {
        this.checked = false;
      } else if (tag === 'select') {
        this.selectedIndex = -1;
      }
    });
  };

  function fn_loadOrderSalesman(memId, memCode, isPop) {
    Common.ajax("GET", "/sales/order/selectMemberByMemberIDCode.do", { memId : memId, memCode : memCode },
      function(memInfo) {
        if (memInfo == null) {
          Common.alert('<spring:message code="sal.alert.msg.memNotFound" />' + memCode + '</b>');
          $("#salesmanPopCd").val('');
          $("#hiddenSalesmanPopId").val('');
        } else {
          if (isPop == 1) {
            $('#hiddenSalesmanPopId').val(memInfo.memId);
            $('#salesmanPopCd').val(memInfo.memCode);
            $('#salesmanPopCd').removeClass("readonly");
            $('#salesmanPopNm').val(memInfo.name);

            Common.ajax( "GET", "/sales/pos/getMemCode", { memCode : memCode },
              function(result) {
                if (result != null) {
                } else {
                  Common.alert('<spring:message code="sal.alert.msg.memHasNoBrnch" />');
                  $("#salesmanPopCd").val('');
                  $("#hiddenSalesmanPopId").val('');
                  $('#salesmanPopNm').val('');
                  $("#_cmbWhBrnchIdPop").val('');
                  $("#cmbWhIdPop").val();
                  fn_clearAllGrid();
                  return;
                }
              });
            } else {
              $('#hiddenSalesmanId').val(memInfo.memId);
              $('#salesmanCd').val(memInfo.memCode);
              $('#salesmanCd').removeClass("readonly");
              $('#salesmanPopNm').val(memInfo.name);
            }

            Common.ajax( "GET", "/sales/pos/getLoyaltyRewardPointByMemCode.do", { memCode : memCode },
               function(result) {
                 console.log(result);
                   if (result != null) {
                     $('#_hidLrpId').val(result.lrpItmId);
                     $('#_posBalanceCapped').val(result.lrpBalanceAmt);
                     $('#_posDiscount').val(result.lrpUplDiscountPercent);
                     $('#_posSDate').val(result.startDt);
                     $('#_posEDate').val(result.endDt);
                   }
                 });
              }
    });
  }

  function createAUIGrid() {
    var posColumnLayout = [
    {
      dataField : "supRefId",
      visible : false,
      editable : false
    }, {
      dataField : "supRefNo",
      headerText : '<spring:message code="supplement.text.supplementReferenceNo" />',
      width : '13%',
      editable : false
    }, {
      dataField : "sofNo",
      headerText : '<spring:message code="supplement.text.eSOFno" />',
      width : '15%',
      editable : false
    }, {
      dataField : "supRefStus",
      headerText : '<spring:message code="supplement.text.supplementReferenceStatus" />',
      width : '15%',
      editable : false
    }, {
        dataField : "supRefStusId",
        width : '15%',
        visible : false,
        editable : false
    }, {
      dataField : "supRefStg",
      headerText : '<spring:message code="supplement.text.supplementReferenceStage" />',
      width : '15%',
      editable : false
    }, {
        dataField : "supRefStgId",
        width : '15%',
        visible : false,
        editable : false
    }, {
        dataField : "supRefDelStus",
        headerText : '<spring:message code="supplement.text.delStat" />',
        width : '5%',
        editable : false,
        visible : false
    }, {
        dataField : "supDelStus",
        headerText : '<spring:message code="supplement.text.delStat" />',
        width : '15%',
        editable : false
    }, {
        dataField : "isRefund",
        headerText :  '<spring:message code="supplement.text.isRefund" />',
        width : '5%',
        editable : false
    }, {
      dataField : "supRefDate",
      headerText :  '<spring:message code="supplement.text.supplementReferenceDate" />',
      width : '15%',
      editable : false
    }, {
      dataField : "submBrch",
      headerText : '<spring:message code="supplement.text.submissionBranch" />',
      width : '10%',
      editable : false
    }, {
      dataField : "parcelTrackNo",
      headerText : '<spring:message code="supplement.text.parcelTrackingNo" />',
      width : '10%',
      editable : false
    }, {
      dataField : "SupConsgNo",
      headerText :  '<spring:message code="supplement.text.supplementConsignmentNo" />',
      width : '15%',
      editable : false
    }, {
      dataField : "salesmanId",
      headerText : '<spring:message code="sal.text.salManCode" />',
      width : '8%',
      editable : false
    }, {
      dataField : "salesmanName",
      headerText : '<spring:message code="sal.text.salManName" />',
      width : '20%',
      style : 'left_style',
      editable : false
    }, {
      dataField : "custName",
      headerText : '<spring:message code="sal.text.custName" />',
      width : '20%',
      style : 'left_style',
      editable : false
    }, {
      dataField : "refCreateBy",
      headerText : '<spring:message code="sal.text.createBy" />',
      width : '8%',
      editable : false
    }, {
      dataField : "refCreateDate",
      headerText : '<spring:message code="sal.text.createDate" />',
      width : '8%',
      editable : false
    }, {
      dataField : "refUpdateBy",
      headerText : '<spring:message code="sal.text.updateBy" />',
      width : '8%',
      editable : false
    }, {
      dataField : "refUpdateDate",
      headerText : '<spring:message code="sal.text.updateDate" />',
      width : '8%',
      editable : false
    }];

    var gridPros = {
      showRowAllCheckBox : true,
      usePaging : true,
      pageRowCount : 10,
      headerHeight : 30,
      showRowNumColumn : true,
      showRowCheckColumn : true,
    };

    supOrdGridID = GridCommon.createAUIGrid("#sub_grid_wrap", posColumnLayout, '', gridPros); // address list
  }

  function createExcelAUIGrid() {
    var excelColumnLayout = [
    {
      dataField : "supRefNo",
      headerText : "Reference No",
      width : 100,
      editable : false
    }, {
      dataField : "sofNo",
      headerText : "eSOF No",
      width : 100,
      editable : false
    }, {
      dataField : "supRefStus",
      headerText : "Reference Status",
      width : 100,
      editable : false
    }, {
      dataField : "supRefStg",
      headerText : "Reference Stage",
      width : 100,
      editable : false
    }, {
      dataField : "supRefDate",
      headerText : "Reference Date",
      width : 100,
      editable : false
    }, {
      dataField : "submBrch",
      headerText : "Branch",
      width : 100,
      editable : false
    }, {
      dataField : "parcelTrackNo",
      headerText : "parcel Tracking No",
      width : 100,
      editable : false
    },
    {
      dataField : "SupConsgNo",
      headerText : "Consignment No",
      width : 100,
      editable : false
    }, {
      dataField : "salesmanId",
      headerText : "salesman Id",
      width : 100,
      editable : false
    }, {
      dataField : "salesmanName",
      headerText : "salesman Name",
      width : 100,
      editable : false
    }, {
      dataField : "custName",
      headerText : "Customer Name",
      width : 100,
      editable : false
    }, {
      dataField : "refCreateBy",
      headerText : "CreateBy",
      width : 100,
      editable : false
    }, {
      dataField : "refCreateDate",
      headerText : "CreateDate",
      width : 100,
      editable : false
    }, {
      dataField : "refUpdateBy",
      headerText : "UpdateBy",
      width : 100,
      editable : false
    }, {
      dataField : "refUpdateDate",
      headerText : "UpdateDate",
      width : 100,
      editable : false
    }];

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

  function fn_getSubListAjax() {
    Common.ajax("GET", "/supplement/selectSupplementList", $("#searchForm").serialize(), function(result) {
      AUIGrid.setGridData(supOrdGridID, result);
      AUIGrid.setGridData(excelListGridID, result);
    });
  }

  function fn_custDelInfo() {
    Common.popupDiv("/supplement/supplementCustDelInfo.do",{ind : 'PDO'},null, true, '_insDiv');
  }

  function fn_dailyOrderReport() {
    Common.popupDiv("/supplement/supplementDailyOrderReportPop.do",{ind : 'MGT'},null, true, '_insDiv');
  }

  function fn_popClose() {
    $("#_closeOrdPop").click();
    fn_getSubListAjax();
  }

  function fn_sofListingReport() {
	  Common.popupDiv("/supplement/supplementSofListingPop.do",{ind : '${SESSION_INFO.userBranchId}', auth : '${PAGE_AUTH.funcUserDefine2}' },null, true, '_insDiv');
  }
</script>

<form id="rptForm">
  <input type="hidden" id="reportFileName" name="reportFileName" />
  <input type="hidden" id="viewType" name="viewType" />
</form>
<section id="content">
  <ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>Health Supplement</li>
    <li>Supplement Management</li>
  </ul>

  <aside class="title_line">
    <p class="fav">
      <a href="#" class="click_add_on">My menu</a>
    </p>
    <h2>
      <spring:message code="supplement.title.supplementManagement" />
    </h2>
    <ul class="right_btns">
      <c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
        <li>
          <p class="btn_blue">
            <a href="#" id="_updateShipTrackNoBtn"><spring:message code="supplement.title.updateShipmentTrackingNo" /></a>
          </p>
        </li>
      </c:if>
      <c:if test="${PAGE_AUTH.funcUserDefine3 == 'Y'}">
        <!-- <li>
          <p class="btn_blue">
            <a href="#" id="_updateDeliveryStatGDexBtn"><spring:message code="supplement.btn.updDelStat" />(GDEX)</a>
          </p>
        </li> -->
        <li>
          <p class="btn_blue">
            <a href="#" id="_updateDeliveryStatDhlBtn"><spring:message code="supplement.btn.updDelStat" />(DHL)</a>
          </p>
        </li>
      </c:if>
      <c:if test="${PAGE_AUTH.funcView == 'Y'}">
        <li>
          <p class="btn_blue">
            <a href="#" id="_viewBtn"><spring:message code="sys.scm.inventory.ViewDetail" /></a>
          </p>
        </li>
        <li>
          <p class="btn_blue">
            <a href="#" id="_search"><span class="search"></span> <spring:message code="sal.btn.search" /></a>
          </p>
        </li>
      </c:if>
      <!-- <li>
        <p class="btn_blue">
          <a href="#" onclick="javascript:$('#searchForm').clearForm();"><span class="clear"></span><spring:message code="sal.btn.clear" /></a>
        </p>
      </li>  -->
    </ul>
  </aside>
  <!-- title_line end -->

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
            <th scope="row"><spring:message  code="supplement.text.supplementReferenceNo" /><span class="must">*</span></th>
            <td>
              <input type="text" title="" placeholder="Supplement Order No" class="w100p" id="_supRefNo" name="supRefNo" />
            </td>
            <th scope="row"><spring:message code="supplement.text.eSOFno" /></th>
            <td>
              <input type="text" title="" placeholder="eSOF No" class="w100p" id="_sofNo" " name="sofNo" />
            </td>
            <th scope="row"><spring:message code="supplement.text.supplementReferenceStatus" /></th>
            <td>
              <select class="multy_select w100p" multiple="multiple" id="supRefStus" name="supRefStus">
                <c:forEach var="list" items="${supRefStus}" varStatus="status">
                  <option value="${list.codeId}">${list.codeName}</option>
                </c:forEach>
              </select>
            </td>
          </tr>
          <tr>
            <th scope="row"><spring:message code="supplement.text.submissionBranch" /></th>
            <td>
              <select id="_brnchId" name="_brnchId" class="multy_select w100p" multiple="multiple"></select>
            </td>
            <th scope="row"><spring:message code="sal.text.createDate" /><span class="must">*</span></th>
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
            <th scope="row"><spring:message code="sal.text.createBy" /></th>
            <td>
              <input type="text" title="" placeholder="Create By" class="w100p" id="_supRefCreator" " name="supRefCreator" />
            </td>
          </tr>
          <tr>
            <th scope="row"><spring:message code="supplement.text.delStat" /></th>
            <td><select class="multy_select w100p" multiple="multiple" id="supDelStus" name="supDelStus">
                <c:forEach var="list" items="${supDelStus}" varStatus="status_dEL">
                  <option value="${list.codeId}">${list.codeName}</option>
                </c:forEach>
              </select>
            </td>
            <th scope="row"><spring:message code="supplement.text.supplementReferenceStage" /></th>
            <td colspan='3'>
              <select class="multy_select w100p" multiple="multiple" id="supRefStg" name="supRefStg">
                <c:forEach var="list" items="${supRefStg}" varStatus="status">
                  <option value="${list.codeId}">${list.codeName}</option>
                </c:forEach>
              </select>
            </td>
          </tr>
          <tr>
            <th scope="row"><spring:message code="supplement.text.parcelTrackingNo" /></th>
            <td>
              <input type="text" title="" placeholder="Parcel Tracking No" class="w100p" id="_parcelTrackNo" " name="parcelTrackNo" />
            </td>
            <th scope="row"><spring:message code="supplement.text.supplementConsignmentNo" /></th>
            <td>
              <input type="text" title="" placeholder="Supplement Consignment No" class="w100p" id="_SupConsgNo" " name="SupConsgNo" />
            </td>
            <th/><spring:message code="supplement.text.isRefund" /></th>
            <td>
              <input type="checkbox" value="Y" id="isRefund" name="isRefund" />
            </td>
          </tr>
          <!-- <tr>
            <th scope="row"><spring:message code="sal.text.salManCode" /></th>
            <td>
              <div class="search_100p">
                <input id="salesmanCd" name="salesmanCd" type="text" title="" placeholder="Salesman Code" class="w100p" />
                <input id="hiddenSalesmanId" name="salesmanId" type="hidden" /> <a id="memBtn" href="#" class="search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
              </div>
            </td>
            <th scope="row"><spring:message code="sal.text.salManName" /></th>
            <td colspan="3">
              <input id="salesmanPopNm" name="salesmanPopNm" type="text" title="" placeholder="Salesman Name" class="w100p" disabled="disabled" />
              <input id="hiddenSalesmanPopNm" name="salesmanPopNm" type="hidden" />
            </td>
          </tr>  -->
          <tr>
            <th scope="row"><spring:message code="sal.text.salManCode" /></th>
            <td colspan = "5" width = "">
              <p><input id="salesmanCd" name="salesmanCd" type="text" title="" placeholder="" style="width:100px;" class="" /></p>
              <p><a id="memBtn" href="#" class="search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a></p>
              <p><input id="salesmanPopNm" name="salesmanPopNm" type="text" title="" placeholder="" style="width:500px;" class="readonly" readonly/></p>
            </td>
          </tr>
          <tr>
            <th scope="row"><spring:message code="sal.text.organizationCode" /></th>
            <td>
              <input type="text" title="orgCode" id="orgCode" name="orgCode" placeholder="Org Code" class="w100p" />
            </td>
            <th scope="row"><spring:message code="sal.text.GroupCode" /></th>
            <td>
              <input type="text" title="grpCode" id="grpCode" name="grpCode" placeholder="Grp Code" class="w100p" />
            </td>
            <th scope="row"><spring:message code="sal.text.departmentCode" /></th>
            <td>
              <input type="text" title="deptCode" id="deptCode" name="deptCode" placeholder="Dept Code" class="w100p" />
            </td>
          </tr>
          <tr>
            <th scope="row"><spring:message code="sal.text.custName" /></th>
            <td>
              <input type="text" title="" placeholder="Customer Name" class="w100p" name="custName" id="_custName" />
            </td>
            <th scope="row"><spring:message code="sal.text.nricCompanyNo" /></th>
            <td>
              <input type="text" title="" placeholder="NRIC / Company No" class="w100p" name="nricCompanyNo" id="_nricCompanyNo" />
            </td>
            <th scope="row"><spring:message code="sal.text.custContactNo" /></th>
            <td>
              <input type="text" title="" placeholder="Customer Contact No" class="w100p" name="custContactNo" id="_custContactNo" />
            </td>
          </tr>
          <tr>
            <th scope="row"><spring:message code="sal.text.custEmail" /></th>
            <td>
              <input type="text" title="" placeholder="Customer Email" class="w100p" id="_custEmail" name="custEmail" />
            </td>
            <th></th>
            <td></td>
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
              <c:if test="${PAGE_AUTH.funcUserDefine5 == 'Y'}">
                <li>
                  <p class="link_btn type2">
                    <a href="#" onclick="fn_custDelInfo()"><spring:message code='supplement.btn.custDelInfo'/></a>
                  </p>
                </li>
              </c:if>
              <c:if test="${PAGE_AUTH.funcUserDefine6 == 'Y'}">
                <li>
                  <p class="link_btn type2">
                    <a href="#" onclick="fn_dailyOrderReport()"><spring:message code='supplement.btn.dailyReportOrder'/></a>
                  </p>
                </li>
              </c:if>
              <c:if test="${PAGE_AUTH.funcUserDefine7 == 'Y'}">
                <li>
                  <p class="link_btn"><a href="#" id="btnSof" onclick="fn_sofListingReport()"><spring:message code='sales.btn.sof'/></a></p>
                </li>
              </c:if>
            </ul>
            <p class="hide_btn">
              <a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a>
            </p>
          </dd>
        </dl>
      </aside>
  </section>

  <section class="search_result">
    <c:if test="${PAGE_AUTH.funcUserDefine4 == 'Y'}">
      <ul class="right_btns">
        <li><p class="btn_grid">
            <a href="#" id="excelDown"><spring:message code="sal.btn.generate" /></a>
          </p></li>
      </ul>
    </c:if>
    <aside class="title_line">
    </aside>
    <article class="grid_wrap">
      <div id="sub_grid_wrap" style="width: 100%; height: 340px; margin: 0 auto;"></div>
      <div id="excel_list_grid_wrap" style="display: none;"></div>
    </article>

    <div id="_paymentDetailGridDiv">
      <aside class="title_line">
        <h3>
          <spring:message code="sal.title.itmList" />
        </h3>
      </aside>
      <article class="grid_wrap">
        <div id="sub_itm_detail_grid_wrap" style="width: 100%; height: 200px; margin: 0 auto;"></div>
      </article>
    </div>
  </section>
</section>
<hr />
