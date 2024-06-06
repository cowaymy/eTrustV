<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javascript">
  document
      .write('<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/homecare-js-1.0.js?v='
          + new Date().getTime() + '"><\/script>');

  var posGridID;
  var deductionCmGridID;
  var posItmDetailGridID;
  var posPaymentDetailGridID;
  var excelListGridID;

  var MEM_TYPE = '${SESSION_INFO.userTypeId}';
  var arrPosStusCode; // POS GRID
  var arrItmStusCode; //ITEM GRID
  var arrMemStusCode; //MEMBER GRID
  var balanceCapped = 0;

  //Ajax async
  var ajaxOtp = {
    async : false
  };

  $(document)
      .ready(
          function() { //*************************************************************************

            createAUIGrid();
            createExcelAUIGrid();
            createPosPaymentDetailGrid();
            girdHide();

            /*######################## Init Combo Box ########################*/

            //branch List
            /*      CommonCombo.make('cmbWhBrnchId', "/supplement/selectWhBrnchList", '' , '', '');

             $("#cmbWhBrnchId").change(function() {

             var tempVal = $(this).val();
             if(tempVal == null || tempVal == '' ){
             $("#cmbWhId").val("");
             }else{
             var paramObj = {brnchId : tempVal};
             Common.ajax('GET', "/supplement/selectSubmBrch", paramObj,function(result){

             if(result != null){
             $("#cmbWhId").val(result.whLocDesc);
             }else{
             $("#cmbWhId").val('');
             }
             });
             }
             }); */

            doGetComboSepa('/common/selectBranchCodeList.do', '10',
                ' - ', '', '_brnchId', 'M',
                'fn_multiComboBranch');

            if (MEM_TYPE == "1" || MEM_TYPE == "2"
                || MEM_TYPE == "7") {

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

                $("#_memCode").val("${SESSION_INFO.userName}");
                $("#_memName").val(
                    "${SESSION_INFO.userFullname}");
                $("#_memCode").attr("class", "w100p readonly");
                $("#_memCode").attr("readonly", "readonly");
                $("#_memBtn").hide();

              }
            }

            /*######################## Init Combo Box ########################*/

            //excel Download
            $('#excelDown')
                .click(
                    function() {
                      var excelProps = {
                        fileName : "Supplement Management",
                        exceptColumnFields : AUIGrid
                            .getHiddenColumnDataFields(excelListGridID)
                      };
                      AUIGrid
                          .exportToXlsx(
                              excelListGridID,
                              excelProps);
                    });

            //Member Search Popup
            $('#memBtn').click(
                function() {
                  Common.popupDiv("/common/memberPop.do", $(
                      "#searchForm").serializeJSON(),
                      null, true);
                });

            $('#salesmanCd').change(function(event) {

              var memCd = $('#salesmanCd').val().trim();

              if (FormUtil.isNotEmpty(memCd)) {
                fn_loadOrderSalesman(0, memCd);
              }
            });

            $('#salesmanPopNm').change(function(event) {

              var memName = $('#salesmanPopNm').val().trim();

              if (FormUtil.isNotEmpty(memName)) {
                fn_loadOrderSalesman(0, memName);
              }
            });

            //Search
            $("#_search")
                .click(
                    function() {

                      console.log("_supRefNo ::"
                          + $("#_supRefNo").val());

                      if ($("#_supRefNo").val() == '') {
                        if ($("#_sDate").val() == ''
                            || $("#_eDate").val() == '') {
                          Common
                              .alert('Reference Date is required when Reference Order No. is empty.')
                          return;
                        } else if ($("#_sDate").val() != ''
                            && $("#_eDate").val() != '') {
                          if (!js.date
                              .checkDateRange(
                                  $("#_sDate")
                                      .val(),
                                  $("#_eDate")
                                      .val(),
                                  "Supplement Reference Date",
                                  "1")) {
                            console
                                .log("not within date rage");
                          }
                        }
                      }

                      //Grid Clear
                      AUIGrid.clearGridData(posGridID);
                      AUIGrid
                          .clearGridData(posItmDetailGridID);
                      fn_getPosListAjax();
                    });

            //Update Shipment Tracking
            $("#_updateShipTrackNoBtn")
                .click(
                    function() {

                      var clickChk = AUIGrid
                          .getSelectedItems(posGridID);

                      //Validation
                      if (clickChk == null
                          || clickChk.length <= 0) {
                        Common
                            .alert('<spring:message code="sal.alert.msg.noOrderSelected" />');
                        return;
                      }

                      var supplementForm = {
                        supRefId : clickChk[0].item.supRefId,
                        ind : "1"
                      };
                      //Common.popupDiv("/supplement/supplementTrackNoPop.do", {salesOrderId : AUIGrid.getCellValue(gridID, rowIdx, "ordId") }, null , true , '_insDiv');
                      Common
                          .popupDiv(
                              "/supplement/supplementTrackNoPop.do",
                              supplementForm,
                              null, true,
                              '_insDiv');

                    });

            $("#_viewBtn")
                .click(
                    function() {

                      var clickChk = AUIGrid
                          .getSelectedItems(posGridID);

                      //Validation
                      if (clickChk == null
                          || clickChk.length <= 0) {
                        Common
                            .alert('<spring:message code="sal.alert.msg.noOrderSelected" />');
                        return;
                      }

                      var supplementForm = {
                        supRefId : clickChk[0].item.supRefId,
                        ind : "1"
                      };
                      //Common.popupDiv("/supplement/supplementTrackNoPop.do", {salesOrderId : AUIGrid.getCellValue(gridID, rowIdx, "ordId") }, null , true , '_insDiv');
                      Common
                          .popupDiv(
                              "/supplement/supplementViewPop.do",
                              supplementForm,
                              null, true,
                              '_insDiv');
                    });

            // UPDATE DELIVERY STATUS HERE
            $("#_updateDeliveryStatBtn").click(function() {
              var selectedItems = AUIGrid.getCheckedRowItems(posGridID);

              var suppOrds = [];

              for (var a=0; a < selectedItems.length; a++) {
                // CHECK TRACKING NO.
                if (selectedItems[a].item.parcelTrackNo === "" || selectedItems[a].item.parcelTrackNo === undefined) {
                    Common.alert('<spring:message code="supplement.alert.updDelStatNoTckNo" />'+ " " + selectedItems[a].item.supRefNo);
                    return;
                }
                var item = {
                  ordNo : selectedItems[a].item.supRefNo,
                  trckNo: selectedItems[a].item.parcelTrackNo
                }

                suppOrds.push(item);
              }

              // GET & UPDATE DELIVERY STATUS
              Common.ajax("POST", "/supplement/updOrdDelStat.do", {ords : suppOrds}, function(result) {
                Common.alert('<spring:message code="supplement.alert.updDelStatDelStatTtl" />'  + " </br>" +result.message);
              });

            });

            /*  AUIGrid.bind(posGridID, "cellDoubleClick", function(event){
             alert("cellDoubleClick...");
             console.log("cellDoubleClick...");
             }); */

            //Cell Click Event
            AUIGrid.bind(posGridID, "cellClick", function(event) {

              //clear data
              AUIGrid.clearGridData(posItmDetailGridID);

              console.log("supRefId :: " + event.item.supRefId);
              console.log("supRefNo :: " + event.item.supRefNo);

              var detailParam = {
                supRefNo : event.item.supRefNo
              };
              var detailParam = {
                supRefId : event.item.supRefId
              };

              //Ajax
              Common.ajax("GET",
                  "/supplement/getSupplementDetailList",
                  detailParam, function(result) {
                    AUIGrid.setGridData(posItmDetailGridID,
                        result);
                    AUIGrid.setGridData(excelListGridID,
                        result);

                  });

            });

            /***************** Status Change  *****************/
            // 1) Pos Master Update
            $("#_headerSaveBtn")
                .click(
                    function() {

                      var rowCnt = AUIGrid
                          .getRowCount(posGridID);
                      if (rowCnt <= 0) {
                        Common
                            .alert("* please Search First.");
                        return;
                      }
                      var updateList = AUIGrid
                          .getEditedRowItems(posGridID);
                      //   console.log("updateList(type) : " + $.type(updateList));

                      if (updateList == null
                          || updateList.length <= 0) {
                        Common
                            .alert('<spring:message code="sal.alert.msg.noDataChange" />');
                        return;
                      }

                      var PosGridVO = {
                        posStatusDataSetList : GridCommon
                            .getEditData(posGridID)
                      }; //  name Careful = PARAM NAME SHOULD BE EQUAL VO`S NAME

                      Common
                          .ajax(
                              "POST",
                              "/sales/pos/updatePosMStatus",
                              PosGridVO,
                              function(result) {

                                Common
                                    .alert(result.message);
                                AUIGrid
                                    .clearGridData(posItmDetailGridID);
                                fn_getPosListAjax();
                              });

                    });

            // 3) Pos Detail Update
            $("#_itemSaveBtn")
                .click(
                    function() {

                      var rowCnt = AUIGrid
                          .getRowCount(posItmDetailGridID);
                      if (rowCnt <= 0) {
                        Common
                            .alert('<spring:message code="sal.alert.msg.selectItm" />');
                        return;
                      }
                      var updateList = AUIGrid
                          .getEditedRowItems(posItmDetailGridID);
                      //  console.log("updateList(type) : " + $.type(updateList));

                      if (updateList == null
                          || updateList.length <= 0) {
                        Common
                            .alert('<spring:message code="sal.alert.msg.noDataChange" />');
                        return;
                      }

                      var PosGridVO = {
                        posDetailStatusDataSetList : GridCommon
                            .getEditData(posItmDetailGridID)
                      }; //  name Careful = PARAM NAME SHOULD BE EQUAL VO`S NAME

                      Common
                          .ajax(
                              "POST",
                              "/sales/pos/updatePosDStatus",
                              PosGridVO,
                              function(result) {

                                Common
                                    .alert(result.message);
                                AUIGrid
                                    .clearGridData(posItmDetailGridID);
                                fn_getPosListAjax();
                              });

                    });

            /***************  Pos Grid Status ********************/
            //1) Master
            AUIGrid
                .bind(
                    posGridID,
                    "cellEditBegin",
                    function(event) {
                      //Reversal
                      if (event.item.posTypeId == 1361) {
                        Common
                            .alert('<spring:message code="sal.alert.msg.canNotChngStatus" />');
                        return false;
                      }
                      // Active NonReceive Only
                      if (event.value != 1
                          && event.value != 96) {
                        Common
                            .alert('<spring:message code="sal.alert.msg.canNotChngStatus" />');
                        return false;
                      }

                      //Others
                      return true;
                    });
            // 2) Detail
            AUIGrid
                .bind(
                    posItmDetailGridID,
                    "cellEditBegin",
                    function(event) {

                      if (event.item.posTypeId == 1361) {
                        Common
                            .alert('<spring:message code="sal.alert.msg.canNotChngStatusByReversal" />');
                        return false;
                      }
                      // Active NonReceive Only
                      if (event.value != 96) {
                        Common
                            .alert('<spring:message code="sal.alert.msg.canNotChngStatus" />');
                        return false;
                      }
                      //Others
                      return true;
                    });
            // 3) Member
            AUIGrid
                .bind(
                    deductionCmGridID,
                    "cellEditBegin",
                    function(event) {

                      if (event.item.posTypeId == 1361) {
                        Common
                            .alert('<spring:message code="sal.alert.msg.canNotChngStatusByReversal" />');
                        return false;
                      }
                      // Active NonReceive Only
                      if (event.value != 96) {
                        Common
                            .alert('<spring:message code="sal.alert.msg.canNotChngStatus" />');
                        return false;
                      }
                      //Others
                      return true;
                    });

            /***  Report ***/
            $("#_posRawDataBtn").click(
                function() {
                  Common.popupDiv(
                      "/sales/pos/posRawDataPop.do", '',
                      null, null, true);
                });

            $("#_posPayListing")
                .click(
                    function() {
                      Common
                          .popupDiv(
                              "/sales/pos/posPaymentListingPop.do",
                              '', null, null,
                              true);
                    });
          });//Doc ready Func End ****************************************************************************************************************************************

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

  /* function fn_getDateGap(sdate, edate){

   var startArr, endArr;

   startArr = sdate.split('/');
   endArr = edate.split('/');

   var keyStartDate = new Date(startArr[2] , startArr[1] , startArr[0]);
   var keyEndDate = new Date(endArr[2] , endArr[1] , endArr[0]);

   var gap = (keyEndDate.getTime() - keyStartDate.getTime())/1000/60/60/24;

   //    console.log("gap : " + gap);

   return gap;
   } */

  function girdHide() {
    //Grid Hide
    $("#_deducGridDiv").css("display", "none");
    $("#_itmDetailGridDiv").css("display", "none");
  }

  function createPosPaymentDetailGrid() {
    var posPaymentColumnLayout = [
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

    posItmDetailGridID = GridCommon.createAUIGrid("#payment_detail_grid_wrap", posPaymentColumnLayout, '', paymentGridPros);

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

        AUIGrid.setFooter(posItmDetailGridID, footerLayout);
  }

  //TODO 미개발 message
  function fn_underDevelop() {
    Common.alert('The program is under development.');
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
    Common
        .ajax(
            "GET",
            "/sales/order/selectMemberByMemberIDCode.do",
            {
              memId : memId,
              memCode : memCode
            },
            function(memInfo) {
              if (memInfo == null) {
                Common
                    .alert('<spring:message code="sal.alert.msg.memNotFound" />'
                        + memCode + '</b>');
                $("#salesmanPopCd").val('');
                $("#hiddenSalesmanPopId").val('');

                //Clear Grid
                fn_clearAllGrid();
              } else {
                // console.log("멤버정보 가꼬옴");
                console.log(memInfo.memId);
                if (isPop == 1) {
                  $('#hiddenSalesmanPopId')
                      .val(memInfo.memId);
                  $('#salesmanPopCd').val(memInfo.memCode);
                  $('#salesmanPopCd').removeClass("readonly");
                  $('#salesmanPopNm').val(memInfo.name);

                  Common
                      .ajax(
                          "GET",
                          "/sales/pos/getMemCode",
                          {
                            memCode : memCode
                          },
                          function(result) {

                            if (result != null) {
                              //$("#_cmbWhBrnchIdPop").val(result.brnch);
                              //$("#_payBrnchCode").val(result.brnch);
                              //getLocIdByBrnchId(result.brnch);
                            } else {
                              Common
                                  .alert('<spring:message code="sal.alert.msg.memHasNoBrnch" />');
                              $("#salesmanPopCd")
                                  .val('');
                              $(
                                  "#hiddenSalesmanPopId")
                                  .val('');
                              $('#salesmanPopNm')
                                  .val('');
                              $(
                                  "#_cmbWhBrnchIdPop")
                                  .val('');
                              $("#cmbWhIdPop")
                                  .val();
                              //Clear Grid
                              fn_clearAllGrid();
                              return;
                            }
                          });
                } else {
                  //  console.log("리스트임");
                  $('#hiddenSalesmanId').val(memInfo.memId);
                  $('#salesmanCd').val(memInfo.memCode);
                  $('#salesmanCd').removeClass("readonly");
                  $('#salesmanPopNm').val(memInfo.name);
                }

                //Load Salesman Loyalty Reward
                Common
                    .ajax(
                        "GET",
                        "/sales/pos/getLoyaltyRewardPointByMemCode.do",
                        {
                          memCode : memCode
                        },
                        function(result) {
                          console.log(result);
                          if (result != null) {

                            $('#_hidLrpId')
                                .val(
                                    result.lrpItmId);
                            $('#_posBalanceCapped')
                                .val(
                                    result.lrpBalanceAmt);
                            $('#_posDiscount')
                                .val(
                                    result.lrpUplDiscountPercent);
                            $('#_posSDate').val(
                                result.startDt);
                            $('#_posEDate').val(
                                result.endDt);

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
      dataField : "supRefStg",
      headerText : '<spring:message code="supplement.text.supplementReferenceStage" />',
      width : '15%',
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
    },

    /*                             {dataField : "stusId", headerText : "Status", width : '10%',
     labelFunction : function( rowIndex, columnIndex, value, headerText, item) {
     var retStr = "";
     for(var i=0,len=arrPosStusCode.length; i<len; i++) {
     if(arrPosStusCode[i]["codeId"] == value) {
     retStr = arrPosStusCode[i]["codeName"];
     break;
     }
     }
     return retStr == "" ? value : retStr;
     },
     editRenderer : {
     type : "DropDownListRenderer",
     list : arrPosStusCode,
     keyField   : "codeId", // key 에 해당되는 필드명
     valueField : "codeName", // value 에 해당되는 필드명
     easyMode : false
     }
     } ,
     {dataField : "posId", visible : false},
     {dataField : "posModuleTypeId", visible : false},
     {dataField : "posTypeId", visible : false} */
    ];

    //그리드 속성 설정
    var gridPros = {
      showRowAllCheckBox : true,
      usePaging : true,
      pageRowCount : 10,
      headerHeight : 30,
      showRowNumColumn : true,
      showRowCheckColumn : true,
    };

    posGridID = GridCommon.createAUIGrid("#pos_grid_wrap", posColumnLayout,
        '', gridPros); // address list
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
    }

    ];

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

    excelListGridID = GridCommon.createAUIGrid("excel_list_grid_wrap",
        excelColumnLayout, "", excelGridPros);
  }

  function fn_getPosListAjax() {

    // Common.ajax("GET", "/sales/pos/selectPosJsonList", $("#searchForm").serialize(), function(result) {
    Common.ajax("GET", "/supplement/selectSupplementList", $("#searchForm")
        .serialize(), function(result) {
      AUIGrid.setGridData(posGridID, result);
      AUIGrid.setGridData(excelListGridID, result);
    });

  }

  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
</script>

<form id="rptForm">
  <input type="hidden" id="reportFileName" name="reportFileName" />
  <input type="hidden" id="viewType" name="viewType" />
  <input type="hidden" id="V_POSREFNO" name="V_POSREFNO" />
  <input type="hidden" id="V_POSMODULETYPEID" name="V_POSMODULETYPEID" />
  <input type="hidden" id="V_POSTYPEID" name="V_POSTYPEID">
  <input type="hidden" id="V_WHERESQL" name="V_WHERESQL" />
  <input type="hidden" id="V_SHOWPAYMENTDATE" name="V_SHOWPAYMENTDATE">
  <input type="hidden" id="V_SHOWKEYINBRANCH" name="V_SHOWKEYINBRANCH">
  <input type="hidden" id="V_SHOWRECEIPTNO" name="V_SHOWRECEIPTNO">
  <input type="hidden" id="V_SHOWTRNO" name="V_SHOWTRNO">
  <input type="hidden" id="V_SHOWKEYINUSER" name="V_SHOWKEYINUSER">
  <input type="hidden" id="V_SHOWPOSNO" name="V_SHOWPOSNO">
  <input type="hidden" id="V_SHOWMEMBERCODE" name="V_SHOWMEMBERCODE">
  <input type="hidden" id="V_SHOWPOSTYPEID" name="V_SHOWPOSTYPEID">
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
      <c:if test="${PAGE_AUTH.funcUserDefine2 == 'Y'}">
        <li>
          <p class="btn_blue">
            <a href="#" id="_updateDeliveryStatBtn"><spring:message code="supplement.btn.updDelStat" /></a>
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
            <th scope="row"><spring:message code="supplement.text.submissionBranch" /></th>
            <td>
              <select id="_brnchId" name="_brnchId" class="multy_select w100p" multiple="multiple"></select>
            </td>
            <th scope="row"><spring:message code="sal.text.createBy" /></th>
            <td>
              <input type="text" title="" placeholder="Supplement Reference Creator" class="w100p" id="_supRefCreator" " name="supRefCreator" />
            </td>
          </tr>
          <tr>
            <th scope="row"><spring:message code="supplement.text.supplementReferenceStage" /></th>
            <td colspan='3'>
              <select class="multy_select w100p" multiple="multiple" id="supRefStg" name="supRefStg">
                <c:forEach var="list" items="${supRefStg}" varStatus="status">
                  <option value="${list.codeId}">${list.codeName}</option>
                </c:forEach>
              </select>
            </td>
            <th scope="row"></th>
            <td></td>
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
            <th/></th>
            <td></td>
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
      <div id="pos_grid_wrap" style="width: 100%; height: 300px; margin: 0 auto;"></div>
      <div id="excel_list_grid_wrap" style="display: none;"></div>
    </article>

    <div id="_paymentDetailGridDiv">
      <aside class="title_line">
        <h3>
          <spring:message code="sal.title.itmList" />
        </h3>
      </aside>
      <article class="grid_wrap">
        <div id="payment_detail_grid_wrap" style="width: 100%; height: 200px; margin: 0 auto;"></div>
      </article>
    </div>
  </section>
</section>
<hr />
