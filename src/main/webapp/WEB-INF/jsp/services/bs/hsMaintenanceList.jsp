<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javaScript" language="javascript">
var TODAY_DD      = "${toDay}";
var BEFORE_DD = "${bfDay}";
var blockDtFrom = "${hsBlockDtFrom}";
var blockDtTo = "${hsBlockDtTo}";

  var StatusTypeData = [ {
    "codeId" : "1",
    "codeName" : "Active"
  }, {
    "codeId" : "4",
    "codeName" : "Completed"
  }, {
    "codeId" : "21",
    "codeName" : "Failed"
  }, {
    "codeId" : "10",
    "codeName" : "Cancelled"
  } ];

  var gradioVal = $("input:radio[name='searchDivCd']:checked").val();
  var myGridID;
  var gridValue;

  var option = {
    width : "1000px", // 창 가로 크기
    height : "600px" // 창 세로 크기
  };

  var columnManualLayout = [ {
    dataField : "rnum",
    headerText : "RowNum",
    width : 120,
    height : 30,
    visible : false
  }, {
    dataField : "name",
    headerText : "Customer Name",
    width : 120
  }, {
    dataField : "salesOrdNo",
    headerText : "Sales Order",
    width : 120
  }, {
    dataField : "hsDate",
    headerText : "HS Date",
    width : 120,
    visible : false
  }, {
    dataField : "no",
    headerText : "HS Order",
    width : 120
  }, {
    dataField : "c5",
    headerText : "Assign Cody",
    width : 120
  }, {
    dataField : "codyStatus",
    headerText : "Cody Status",
    width : 120
  }, {
    dataField : "code",
    headerText : "HS Status",
    width : 120
  }, {
    dataField : "month",
    headerText : "Complete Cody",
    width : 120,
    visible : false
  }, {
    dataField : "brnchId",
    headerText : "Branch",
    width : 120,
    visible : false
  }, {
    dataField : "schdulId",
    headerText : "schdulId",
    width : 120,
    visible : false
  }, {
    dataField : "salesOrdId",
    headerText : "salesOrdId",
    width : 120,
    visible : false
  }, {
    dataField : "codyBrnchCode",
    headerText : "Branch Code",
    width : 120
  }, {
    dataField : "codyMangrUserId",
    headerText : "Cody Manager",
    width : 120
  }, {
    dataField : "address",
    headerText : "Installation Address",
    width : 120
  },
  {
    dataField : "stkDesc",
    headerText : "Stock Name",
    width : 120
  }, {
    dataField : "hsFreq",
    headerText : "HS Frequency",
    width : 120
  }, {
    dataField : "prevMthHsStatus",
    headerText : "Previous Month Hs Result",
    width : 120
  } , {
    dataField : "serialRequireChkYn",
    headerText : "serialRequireChkYn",
    width : 0}];

  var columnAssiinLayout = [
      {
        dataField : "rnum",
        headerText : "RowNum",
        width : 120,
        height : 30,
        visible : false
      },
     /*  {
        dataField : "custId",
        headerText : "Customer ID",
        width : 120
      }, */
      {
        dataField : "name",
        headerText : "Customer Name",
        width : 120
      },
      {
        dataField : "salesOrdNo",
        headerText : "Sales Order",
        width : 120
      },
      {
        dataField : "hsDate",
        headerText : "HS Period",
        width : 120
      },
      {
        dataField : "no",
        headerText : "HS Order",
        width : 120
      },
      {
        dataField : "c5",
        headerText : "Assign Cody",
        width : 120
      },
      {
        dataField : "deptCode",
        headerText : "Department",
        width : 120
      },
      {
        dataField : "codyStatusNm",
        headerText : "Cody Status",
        width : 120
      },
      {
        dataField : "code",
        headerText : "HS Status",
        width : 120
      },
      {
        dataField : "branchCd",
        headerText : "Branch CD",
        width : 120
      },
      {
        dataField : "codyMangrUserId",
        headerText : "Cody Manager",
        width : 120
      },
      {
          dataField : "crtUserId",
          headerText : "Create User ID",
          width : 200
       },

////////////////ADDITIONAL FIELD//////////////////// Alex-20072020
////// order management >> Installation Info >> Install Date
       /* {
           dataField : "installDt",
           headerText : "Install Month",
           width : 120
        }, */

       {
           dataField : "area",
           headerText : "Install Area",
           width : 120
        },

       {
           dataField : "state",
           headerText : "Install State",
           width : 120
        },

        {
           dataField : "addrDtl",
           headerText : "Installation Full Address",
           width : 300
        },

////////////////ADDITIONAL FIELD////////////////////

      {
        dataField : "stusCodeId",
        headerText : "HS Statuscd",
        width : 120,
        visible : false
      },
      {
        dataField : "brnchId",
        headerText : "Branch",
        width : 120,
        visible : false
      },
      {
        dataField : "schdulId",
        headerText : "schdulId",
        width : 120,
        visible : false
      },
      {
        dataField : "salesOrdId",
        headerText : "salesOrdId",
        width : 120,
        visible : false
      },
      {
        dataField : "result",
        headerText : "result",
        width : 120,
        visible : false
      }, {
          dataField : "serialRequireChkYn",
          headerText : "serialRequireChkYn",
          width : 0}
      , {
        dataField : "undefined",
        headerText : "Edit",
        width : 170,
        renderer : {
          type : "ButtonRenderer",
          labelText : "Edit",
          onclick : function(rowIndex, columnIndex, value, item) {

            if (item.code == "ACT") {
              Common
                  .alert('Not able to EDIT for the HS order status in Active.');
              return false;
            }

            $("#_schdulId").val(item.schdulId);
            $("#_salesOrdId").val(item.salesOrdId);
            $("#_openGb").val("edit");
            $("#_brnchId").val(item.brnchId);

            Common.popupDiv(
                "/services/bs/hsBasicInfoPop.do?MOD=EDIT&ROW="
                    + rowIndex, $("#popEditForm")
                    .serializeJSON(), null, true, '');
          }
        }
      } ];

  function fn_close() {
    window.close();
  }

  function fn_getBSListAjax() {

    var radioVal = $("input:radio[name='searchDivCd']:checked").val();

    if (radioVal == 1) { //HS NO CREATE BEFORE
      // HS PRERIOD ARE OPTIONAL IF SALES ORDER OR HS ORDER PROVIDED
      if ($("#myBSMonth").val() == "") {
        if ($("#txtSalesOrder").val() == "" && $("#txtHsOrderNo").val() == "") {
          Common.alert("HS Period or HS Order or Sales Order are required.");
          return false;
        }
      }

      if ($("#userType").val() != "4" && $("#userType").val() != "6" && $("#userType").val() != "2") {
        if ($("#cmdBranchCode").val() == ''
            || $("#cmdBranchCode").val() == null) {
          Common.alert("Please Select 'Cody Branch'");
          return false;
        }
      }

      if ($("#userType").val() == "2") {
        if ($("#memberLevel").val() == "3"
            || $("#memberLevel").val() == "4") {
          if ($("#cmdCdManager").val() == ''
              || $("#cmdCdManager").val() == null) {
            Common.alert("Please Select 'Cody Manager'");
            return false;
          }
        }
      }

      Common.ajax("GET", "/services/hs/selectCurrMonthHsList.do", $(
          "#searchForm").serialize(), function(result) {
        AUIGrid.setGridData(myGridID, result);

        if($("#userType").val() == "2" && $("#memberLevel").val() == "3") {
            AUIGrid.hideColumnByDataField(myGridID, "undefined");
        }
      });
    } else { //HS NO CREATE AFTER
      if ($("#ManuaMyBSMonth").val() == "") {
        if ($("#ManuaSalesOrder").val() == "") {
          Common.alert("HS Period or Sales Order are required.");
          return false;
        }
      }

      $("#brnchId1").val($("#cmdBranchCode1 option:selected").text());
      var HsCdBranch = $('#brnchId1').val();
      if ($('#brnchId1').val().substring(0, 3) != "CDB") {
        HsCdBranch = "";
      }

      $("#memId1").val($("#cmdCdManager1 option:selected").text());

      var memId = $("#memId1").val();
      if ($("#memId1").val().substring(0, 3) != "CCS") {
        memId = "";
      }

      if ($("#userType").val() != "4" && $("#userType").val() != "6" && $("#userType").val() != "2") {
        if ($("#cmdBranchCode1").val() == ''
            || $("#cmdBranchCode1").val() == null) {
          Common.alert("Please Select 'Branch'");
          return false;
        }
      }

      if ($("#userType").val() == "2") {
        if ($("#memberLevel").val() == "3"
            || $("#memberLevel").val() == "4") {
          if ($("#cmdCdManager1").val() == ''
              || $("#cmdCdManager1").val() == null) {
            Common.alert("Please Select 'Cody Manager'");
            return false;
          }
        }
      }

      // Common.ajax("GET", "/services/bs/selectHsManualList.do", {ManuaSalesOrder:$("#ManuaSalesOrder").val(),ManuaMyBSMonth:$("#ManuaMyBSMonth").val(),ManualCustomer:$("#manualCustomer").val(),cmdBranchCode1:$("#brnchId1").val(),cmdCdManager1:$("#memId1").val()}, function(result) {

    }

  }

  function fn_codyChangeHQ() {
    $("#_openGb").val("codyChange");

    /* var todayDD = Number(TODAY_DD.substr(0, 2));
    var todayYY = Number(TODAY_DD.substr(6, 4));

    var strBlockDtFrom = blockDtFrom + BEFORE_DD.substr(2);
    var strBlockDtTo = blockDtTo + TODAY_DD.substr(2);

    console.log("todayDD: " + todayDD);
    console.log("blockDtFrom : " + blockDtFrom);
    console.log("blockDtTo : " + blockDtTo);

     if(todayDD >= blockDtFrom || todayDD <= blockDtTo) { // Block if date > 22th of the month
         var msg = "Not allow to Assign CODY Transfer within period " + strBlockDtFrom + " to " + strBlockDtTo;
         Common.alert('<spring:message code="sal.alert.msg.actionRestriction" />' + DEFAULT_DELIMITER + "<b>" + msg + "</b>", '');
         return;
     } */


    var radioVal = $("input:radio[name='searchDivCd']:checked").val();
    if (radioVal == '2') {
      Common.alert("'Assign Cody Transfer' is not allow in Manual HS");
      return false;
    }

    var checkedItems = AUIGrid.getCheckedRowItemsAll(myGridID);

    if (checkedItems.length <= 0) {
      Common.alert('No data selected.');
      return false;
    } else {

      var str = "";
      var custStr = "";
      var rowItem;
      var brnchId = "";
      var saleOrdList = "";
      var list = "";
      var brnchCnt = 0;
      var ctBrnchCodeOld = "";
      var dept = "";
      var deptList = "";
      var hsNo = "";
      var hsNoList = "";

      //var saleOrdList = [];
      var saleOrd = {
        salesOrdNo : ""
      };

      for (var i = 0, len = checkedItems.length; i < len; i++) {
        rowItem = checkedItems[i];
        saleOrdList += rowItem.salesOrdNo;
        deptList = deptList + rowItem.deptCode + ","
            + rowItem.codyMangrUserId

        if (i != len - 1) {
          saleOrdList += ",";
          deptList += ",";
        }

        if (i == 0) {
          brnchId = rowItem.branchCd;
        }

        if (rowItem.stusCodeId == "4") {
          Common
              .alert('Not Allow to Cody Transfer for Complete HS Order');
          return;
        }

        dept = rowItem.deptCode;
        hsNoList += rowItem.no; // get checked HS no

      }

      Common
          .confirmCustomizingButton(
              "Do you want to transfer an assign cody<br>with this CM group?",
              "Yes", "No", fn_originBrnchAssign, fn_selectBrnchCM);


      function fn_originBrnchAssign() {
        var jsonObj = {
          "SaleOrdList" : saleOrdList,
          "BrnchId" : brnchId,
          "ManualCustId" : $("#manualCustomer").val(),
          "ManuaMyBSMonth" : $("#ManuaMyBSMonth").val(),
          "department" : dept

        };

        Common
            .popupDiv("/services/hs/selectTrfCody.do?isPop=true&JsonObj="
                + jsonObj
                + "&CheckedItems="
                + saleOrdList
                + "&BrnchId="
                + brnchId
                + "&ManuaMyBSMonth="
                + $("#ManuaMyBSMonth").val()
                + "&deptList="
                + deptList
                + "&hsNoList="
                + hsNoList);
      }

      function fn_selectBrnchCM() {
        var jsonObj = {
          "SaleOrdList" : saleOrdList,
          "BrnchId" : brnchId,
          "ManualCustId" : $("#manualCustomer").val(),
          "ManuaMyBSMonth" : $("#ManuaMyBSMonth").val(),
          "department" : dept

        };

        Common.popupDiv("/services/bs/assignBrnchCMPop.do?JsonObj="
            + jsonObj + "&CheckedItems=" + saleOrdList
            + "&BrnchId=" + brnchId + "&ManuaMyBSMonth="
            + $("#ManuaMyBSMonth").val() + "&deptList=" + deptList);
      }

    }

  }

  function fn_codyChange() {
    $("#_openGb").val("codyChange");

     var radioVal = $("input:radio[name='searchDivCd']:checked").val();
    if (radioVal == '2') {
      Common.alert("'Assign Cody Transfer' is not allow in Manual HS");
      return false;
    }

    var checkedItems = AUIGrid.getCheckedRowItemsAll(myGridID);

    if (checkedItems.length <= 0) {
      Common.alert('No data selected.');
      return false;
    } else {

    	console.log("checkedItems: " + checkedItems);

      var str = "";
      var custStr = "";
      var rowItem;
      var brnchId = "";
      var saleOrdList = "";
      var list = "";
      var brnchCnt = 0;
      var ctBrnchCodeOld = "";
      var dept = "";
      var deptList = "";

      var saleOrd = {
        salesOrdNo : ""
      };

      for (var i = 0, len = checkedItems.length; i < len; i++) {
        rowItem = checkedItems[i];
        saleOrdList += rowItem.salesOrdNo;
        deptList = deptList + rowItem.deptCode + ","
            + rowItem.codyMangrUserId

        if (i != len - 1) {
          saleOrdList += ",";
          deptList += ",";
        }

        if (i == 0) {
          brnchId = rowItem.branchCd;
        }

        if (rowItem.stusCodeId == "4") {
          Common
              .alert('Not Allow to Cody Transfer for Complete HS Order');
          return;
        }

        dept = rowItem.deptCode;

      }

      fn_originBrnchAssign();
      function fn_originBrnchAssign() {
          var jsonObj = {
            "SaleOrdList" : saleOrdList,
            "BrnchId" : brnchId,
            "ManualCustId" : $("#manualCustomer").val(),
            "ManuaMyBSMonth" : $("#ManuaMyBSMonth").val(),
            "department" : dept
          };


        Common
            .popupDiv("/services/hs/selectTrfCody.do?isPop=true&JsonObj="
                + jsonObj
                + "&CheckedItems="
                + saleOrdList
                + "&BrnchId="
                + brnchId
                + "&ManuaMyBSMonth="
                + $("#ManuaMyBSMonth").val()
                + "&deptList="
                + deptList);
      }
    }
  }

  function fn_createHSOrderChecking(salesOrdNo){
        Common.ajaxSync("GET", "/services/bs/createHSOrderChecking.do", { salesOrderNo : salesOrdNo
        }, function(result) {
          msg = result.message;
        });
        return msg;
  }

  function fn_selectHSConfigListPop(jsonObj, saleOrdList, brnchId) {

      Common
      .popupDiv("/services/bs/selectHSConfigListPop.do?isPop=true&JsonObj="
          + jsonObj
          + "&CheckedItems="
          + saleOrdList
          + "&BrnchId="
          + brnchId
          + "&ManuaMyBSMonth="
          + $(
              "#ManuaMyBSMonth")
              .val());
  }

  $(document).ready(
      function() {
        doDefCombo(StatusTypeData, '', 'cmbStatusType', 'S', '');


        $("#orgCode").val($("#orgCode").val().trim());

        if($("#userType").val() == 1 || $("#userType").val() == 2 || $("#userType").val() == 7){
           if("${SESSION_INFO.memberLevel}" =="0"){

           }else if("${SESSION_INFO.memberLevel}" =="1"){

               $("#orgCode").val("${orgCode}".trim());
               $("#orgCode").attr("class", "w100p readonly");
               $("#orgCode").attr("readonly", "readonly");

           }else if("${SESSION_INFO.memberLevel}" =="2"){

               $("#orgCode").val("${orgCode}".trim());
               $("#orgCode").attr("class", "w100p readonly");
               $("#orgCode").attr("readonly", "readonly");

               $("#grpCode").val("${grpCode}");
               $("#grpCode").attr("class", "w100p readonly");
               $("#grpCode").attr("readonly", "readonly");

           }else if("${SESSION_INFO.memberLevel}" =="3"){
               $("#orgCode").val("${orgCode}".trim());
               $("#orgCode").attr("class", "w100p readonly");
               $("#orgCode").attr("readonly", "readonly");

               $("#grpCode").val("${grpCode}");
               $("#grpCode").attr("class", "w100p readonly");
               $("#grpCode").attr("readonly", "readonly");

               $("#deptCode").val("${deptCode}");
               $("#deptCode").attr("class", "w100p readonly");
               $("#deptCode").attr("readonly", "readonly");

           }else if("${SESSION_INFO.memberLevel}" =="4"){

               $("#orgCode").val("${orgCode}".trim());
               $("#orgCode").attr("class", "w100p readonly");
               $("#orgCode").attr("readonly", "readonly");

               $("#grpCode").val("${grpCode}");
               $("#grpCode").attr("class", "w100p readonly");
               $("#grpCode").attr("readonly", "readonly");

               $("#deptCode").val("${deptCode}");
               $("#deptCode").attr("class", "w100p readonly");
               $("#deptCode").attr("readonly", "readonly");
           }
       }


        $('#myBSMonth').val(
            $.datepicker.formatDate('mm/yy', new Date()));
        $('#ManuaMyBSMonth').val(
            $.datepicker.formatDate('mm/yy', new Date()));

        $("#cmdBranchCode").click(
            function() {
              $("#cmdCdManager").find('option').each(function() {
                $(this).remove();
              });


              if ($(this).val().trim() == "") {
                return;
              }

              if ($("#userType").val() != "3") {
                doGetCombo('/services/bs/getCdUpMemList.do', $(
                    this).val(), '', 'cmdCdManager', 'S',
                    'fn_cmdBranchCode');
              }
            });

        $("#cmdBranchCode1").click(
            function() {
              $("#cmdCdManager1").find('option').each(function() {
                $(this).remove();
              });


              if ($(this).val().trim() == "") {
                return;
              }
              if ($("#userType").val() != "3") {
                doGetCombo('/services/bs/getCdDeptList.do', $(
                    this).val(), '', 'cmdCdManager1', 'S',
                    'fn_cmdBranchCode1');
              }
            });


        fn_checkRadioButton();

        AUIGrid.bind(myGridID, "cellClick", function(event) {
          schdulId = AUIGrid.getCellValue(myGridID, event.rowIndex, "schdulId");
          salesOrdId = AUIGrid.getCellValue(myGridID, event.rowIndex, "salesOrdId");
          hsStuscd = AUIGrid.getCellValue(myGridID, event.rowIndex, "stusCodeId");
          result = AUIGrid.getCellValue(myGridID, event.rowIndex, "result");
        });

        AUIGrid.bind(myGridID, "cellDoubleClick", function(event) {
          var radioVal = $("input:radio[name='searchDivCd']:checked").val();

          if (radioVal == 1) {

            $("#_schdulId").val(
                AUIGrid.getCellValue(myGridID, event.rowIndex,
                    "schdulId"));
            $("#_salesOrdId").val(
                AUIGrid.getCellValue(myGridID, event.rowIndex,
                    "salesOrdId"));
            $("#_brnchId").val(
                AUIGrid.getCellValue(myGridID, event.rowIndex,
                    "brnchId"));
            $("#_openGb").val("view");
            $("#_manuaMyBSMonth").val($("#ManuaMyBSMonth").val());

            var stid = AUIGrid.getCellValue(myGridID,
                event.rowIndex, "stusCodeId");

            if (stid != 1) {
              Common.popupDiv(
                  "/services/bs/hsBasicInfoPop.do?MOD=VIEW",
                  $("#popEditForm").serializeJSON(), null,
                  true, '');
            }
          }
        });

        if ($("#memberLevel").val() != "") {
          if ($("#memberLevel").val() == "4") {
            $("#txtAssigncodyCode").val($("#userName").val());
            $("#txtAssigncodyCode").attr("readOnly", true)
          }

          $("#cmdBranchCode option:eq(1)", '#searchForm').attr(
              "selected", true);
          $("#cmdBranchCode1 option:eq(1)", '#searchForm').attr(
              "selected", true);

          $('#cmdBranchCode').trigger('click');
          $('#cmdBranchCode1').trigger('click');

          $('#cmdBranchCode', '#searchForm').attr("readonly", true);
          $('#cmdBranchCode1', '#searchForm').attr("readonly", true);

          $('#cmdBranchCode', '#searchForm').attr('class',
              'w100p readonly ');
          $('#cmdBranchCode1', '#searchForm').attr('class',
              'w100p readonly ');

        }
      });

    function fn_checkRadioButton(objName) {

    if (document.searchForm.elements['searchDivCd'][0].checked == true) {
      var divhsManuaObj = document.querySelector("#hsManua");
      divhsManuaObj.style.display = "none";
      $('#hSConfiguration').attr('disabled', true); //hSConfiguration

      var divhsManagementObj = document.querySelector("#hsManagement");
      divhsManagementObj.style.display = "block";

      fn_destroyGridA();

    } else {

      var divhsManagementObj = document.querySelector("#hsManagement");
      divhsManagementObj.style.display = "none";
      $('#hSConfiguration').attr('disabled', false);

      var divhsManuaObj = document.querySelector("#hsManua");
      divhsManuaObj.style.display = "block";

      $("#addResult").attr("disabled", true);

      //1번영역 데이터 클리어
      $("#ManuaSalesOrder").val('');
      //$("#ManuaMyBSMonth").val('');
      $("#manualCustomer").val('');

      //fn_checkboxChangeHandler();
      fn_destroyGridM();
      //myGridID = GridCommon.createAUIGrid("grid_wrap", columnManualLayout ,gridProsManual);

    }
  }

  var gridProsAssiin = {
    usePaging : true,
    pageRowCount : 20,
    editable : false,
    showRowCheckColumn : true
  };

  var gridProsManual = {
    showRowCheckColumn : true,
    usePaging : true,
    pageRowCount : 20,
    showRowAllCheckBox : true,
    editable : false
  }

  function createAssinAUIGrid(columnAssiinLayout) {
    myGridID = AUIGrid.create("#grid_wrap", columnAssiinLayout,
        gridProsAssiin);

    if($("#userType").val() == "2" && $("#memberLevel").val() == "3") {
        AUIGrid.hideColumnByDataField(myGridID, "undefined");
    }
  }

  // AUIGrid 를 생성합니다.
  function createManualAUIGrid(columnManualLayout) {
    myGridID = AUIGrid.create("#grid_wrap", columnManualLayout,
        gridProsManual);
  }

  function fn_destroyGridA() {
    myGridID = null;

    AUIGrid.setProp(myGridID, gridProsAssiin);
    AUIGrid.destroy("#grid_wrap");
    createAssinAUIGrid(columnAssiinLayout);

  }

  function fn_destroyGridM() {

    myGridID = null;

    AUIGrid.setProp(myGridID, gridProsManual);
    AUIGrid.destroy("#grid_wrap");
    createManualAUIGrid(columnManualLayout);

  }

  function fn_checkboxChangeHandler(event) {

    var radioVal = $("input:radio[name='searchDivCd']:checked").val();

    if (radioVal == 1) {
      fn_destroyGrid();
      myGridID = GridCommon.createAUIGrid("grid_wrap",
          columnAssiinLayout, gridProsAssiin);
    } else {
      fn_destroyGrid();
      myGridID = GridCommon.createAUIGrid("grid_wrap",
          columnManualLayout, gridProsManual);
    }
  }

    function fn_hsCountForecastListing() {
    Common.popupDiv("/services/bs/report/hsCountForecastListingPop.do",
        null, null, true, '');
  }

  function fn_hsReportSingle() {
    Common.popupDiv("/services/bs/report/hsReportSinglePop.do", null, null,
        true, '');
  }
  function fn_hsReportGroup() {
    Common.popupDiv("/services/bs/report/hsReportGroupPop.do", null, null,
        true, '');
  }

  function fn_hsReportIndividualGroup(){
        Common.popupDiv("/services/bs/hsReportIndividualGroupPop.do", null, null,
                true, '');
  }

  function fn_hsSummary() {
    Common.popupDiv("/services/bs/report/bSSummaryList.do", null, null,
        true, '');
  }

  function fn_filterForecastList() {
    Common.popupDiv("/services/bs/report/filterForecastListingPop.do",
        null, null, true, '');
  }

  function fn_cmdBranchCode() {
    if ($("#memberLevel").val() == "3" || $("#memberLevel").val() == "4") {
      $("#cmdCdManager option:eq(1)", '#searchForm').attr("selected",
          true);
      $('#cmdCdManager', '#searchForm').attr("readonly", true);
      $('#cmdCdManager', '#searchForm').attr('class', 'w100p readonly ');
    }

  }

  function fn_cmdBranchCode1() {
    if ($("#memberLevel").val() == "3" || $("#memberLevel").val() == "4") {

      $("#cmdCdManager1 option:eq(1)", '#searchForm').attr("selected",
          true);
      $('#cmdCdManager1', '#searchForm').attr("readonly", true);
      $('#cmdCdManager1', '#searchForm').attr('class', 'w100p readonly ');
    }
  }

  function fn_htMultipleChange(){
      var checkedItems = AUIGrid.getCheckedRowItemsAll(myGridID);
       var radioVal = $("input:radio[name='searchDivCd']:checked").val();


        if (checkedItems.length <= 0) {
          Common.alert('No data selected.');
          return;
        } else if (radioVal == 2) {
             Common.alert('Not allow to Assign HT in Manual CS');
              return;
        } else if (checkedItems[0]["code"] != "ACT") {
          Common.alert('Only allow to enter result<br/>for Active HS order.');
          return;
        } else {
          var str = "";
          var custStr = "";
          var rowItem;
          var brnchId = "";
          var saleOrdList = "";
          var list = "";
          var brnchCnt = "";
          var schdulId = "";



          for (var i = 0, len = checkedItems.length; i < len; i++) {
              rowItem = checkedItems[i];
              hsStuscd = rowItem.stusCodeId;
              schdulId += rowItem.schdulId;
              saleOrdList += rowItem.salesOrdId;
              custId = rowItem.custId;
              brnchId = rowItem.brnchId;
              codyMangrUserId = rowItem.c5 ;

              if (i != len - 1) {
                  saleOrdList += ",";
                  schdulId +=",";
                }

              if (hsStuscd == 4) {
                Common.alert("CS result already COM. Assign HT Member is disallowed.");
                return;
              }
            }
          }
        /* Common.popupDiv("/homecare/services/htConfigBasicMultiplePop.do?isPop=true&schdulId="+ schdulId + "&salesOrdId="+saleOrdList  +"&indicator=1", null, null , true , '_ConfigBasicPop'); */
                  Common.popupDiv("/homecare/services/hsAccConfigBasicMultiplePop.do?isPop=true&schdulId="+ schdulId + "&salesOrdId="+saleOrdList  +"&indicator=1", null, null , true , '_ConfigBasicPop');
  }//hsAccConfigBasicMultiplePop.jsp


  function fn_hsConfigOld() {
    window.open("/services/bs/hsManualOld.do", '_self');
  }

  function fn_hsMonthlySetting() {
    window.open("/services/bs/hsMonthlyConfigOldVer.do", '_self');
  }

  function fn_cMyBSMonth(field) {
    $("#" + field + "").val("");
  }

  function fn_selfClose() {
      $('#_close1').click();

  }

  function fn_parentReload() {
      fn_getBSListAjax(); //parent Method (Reload)
  }

</script>
<form id="popEditForm" method="post">
 <input type="hidden" name="schdulId" id="_schdulId" />
 <!-- schdulId  -->
 <input type="hidden" name="salesOrdId" id="_salesOrdId" />
 <!-- salesOrdId  -->
 <input type="hidden" name="openGb" id="_openGb" />
 <!--   salesOrdId  -->
 <input type="hidden" name="brnchId" id="_brnchId" />
 <!-- salesOrdId  -->
 <input type="hidden" name="manuaMyBSMonth" id="_manuaMyBSMonth" />
 <!-- salesOrdId  -->
 <input type="hidden" id="brnchId1" name="brnchId1">
 <!-- Manual branch -->
 <input type="hidden" id="memId1" name="memId1">
 <!-- Manual branch -->
 <input type="hidden" id="memberLevel" name="memberLevel"
  value="${memberLevel}">
 <!-- Manual branch -->
 <input type="hidden" id="userName" name="userName" value="${userName}">
 <input type="hidden" id="userType" name="userType" value="${userType}">
</form>
  <form id='reportFormHSLst' method="post" name='reportFormHSLst' action="#">
    <input type='hidden' id='reportFileName' name='reportFileName'/>
    <input type='hidden' id='viewType' name='viewType'/>
    <input type='hidden' id='reportDownFileName' name='reportDownFileName'/>
    <input type='hidden' id='V_TEMP' name='V_TEMP'/>
  </form>

<form id="searchForm" name="searchForm">
 <section id="content">
  <!-- content start -->
  <ul class="path">
   <li><img
    src="${pageContext.request.contextPath}/resources/images/common/path_home.gif"
    alt="Home" /></li>
   <li>Sales</li>
   <li>Order list</li>
  </ul>
  <aside class="title_line">
   <!-- title_line start -->
   <p class="fav">
    <a href="#" class="click_add_on">My menu</a>
   </p>
   <h2>HS Maintenance</h2>
   <ul class="right_btns">

     <li><p class="btn_blue">
       <a href="#" onclick="javascript:fn_codyChangeHQ();" id="trfCody">Assign Cody Transfer HQ</a>
      </p></li>
     <li><p class="btn_blue">
       <a href="#" onclick="javascript:fn_getBSListAjax();"><span
        class="search"></span>
       <spring:message code='sys.btn.search' /></a>
      </p></li>
   </ul>
  </aside>
  <!-- title_line end -->
  <div id="hsManagement" style="display: block;">
   <form id="hsManagement" method="post">
    <section class="search_table">
     <!-- search_table start -->
     <form action="#" method="post">
      <table class="type1">
       <!-- table start -->
       <caption>table</caption>
       <colgroup>
        <col style="width: 110px" />
        <col style="width: *" />
        <col style="width: 110px" />
        <col style="width: *" />
        <col style="width: 100px" />
        <col style="width: *" />
        <col style="width: 120px" />
        <col style="width: *" />
       </colgroup>
       <tbody>
        <tr>
         <th scope="row">Cody Branch
<!--          <span class="must">*</span> -->
         </th>
         <td><select id="cmdBranchCode" name="cmdBranchCode"
          class="w100p readOnly ">
           <option value="">Choose One</option>
           <c:forEach var="list" items="${branchList }"
            varStatus="status">
            <option value="${list.codeId}">${list.codeName}</option>
           </c:forEach>
         </select></td>
         <th scope="row">Cody Manager</th>
         <td><select id="cmdCdManager" name="cmdCdManager"
          class="w100p"></td>
         <th scope="row">Assign Cody</th>
         <td><input id="txtAssigncodyCode" name="txtAssigncodyCode"
          type="text" title="" placeholder="Cody" class="w100p" /> <!-- By Kv - Change cmbBox to text Box -->
          <!-- <select class="w100p" id="cmdcodyCode" name="cmdcodyCode" > -->
          <!-- <option value="">cody</option> --></td>
         <th scope="row">Cody Status</th>
             <td><select class="w100p"id="txtCodyStatus" name="txtCodyStatus">
         <option value="" selected>Choose One</option>
        <option value="ACT" >Active</option>
        <option value="RESI" >Resign</option>
        <option value="TER" >Terminate</option>
    </select></td>
        <!--  <td><input id="txtComcodyCode" name="txtComcodyCode"
          type="text" title="" placeholder="Cody" class="w100p" /></td> -->
        </tr>
        <tr>
         <th scope="row">HS Order</th>
         <td><input id="txtHsOrderNo" name="txtHsOrderNo"
          type="text" title="" placeholder="HS Order" class="w100p" />
         </td>
         <th scope="row">HS Period</th>
         <td><p style="width:70%;">
         <input id="myBSMonth" name="myBSMonth" type="text"
          title="기준년월" placeholder="MM/YYYY" class="j_date2 w100p" disabled/></p>

         <th scope="row">HS Status</th>
         <td><select class="w100p" id="cmbStatusType" name="cmbStatusType">
           <option value="">HS Status</option></td>
           <th></th>
           <td></td>
<!--          <th scope="row">Dept. Code</th> -->
<!--          <td><input id="deptCode" name="deptCode" type="text" -->
<!--           title="" placeholder="Dept. Code" class="w100p" /></td> -->
         <!-- <td><input id="txtCustomer" name="txtCustomer" type="text"
          title="" placeholder="Customer ID" class="w100p" /></td> -->
        </tr>
        <tr>
         <th scope="row">Sales Order</th>
         <td><input id="txtSalesOrder" name="txtSalesOrder"
          type="text" title="" placeholder="Sales Order" class="w100p" />
         </td>
         <th scope="row">Install Month</th>
         <td><p style="width:70%"><input id="myInstallMonth" name="myInstallMonth"
          type="text" title="기준년월" placeholder="MM/YYYY"
          class="j_date2 w100p" /></p>
          <p class="btn_gray">
           <a href="#" onclick="fn_cMyBSMonth('myInstallMonth')">Clear</a>
          </p>
          </td>
         <th scope="row">Install Area</th>
         <td><input id="myInstallArea" name="myInstallArea" type="text"
          title="" placeholder="Install Area" class="w100p" /></td>
         <th scope="row">Install State</th>
         <td><input id="myInstallState" name="myInstallState" type="text"
          title="" placeholder="Install State" class="w100p" /></td>
        </tr>
        <tr>
          <th scope="row">Org. Code</th>
          <td><input id="orgCode" name="orgCode" type="text" title="" placeholder="Org Code" class="w100p" /></td>
          <th scope="row">Grp. Code</th>
          <td><input id="grpCode" name="grpCode" type="text" title="" placeholder="Grp Code" class="w100p" /></td>
          <th scope="row">Dept. Code</th>
          <td><input id="deptCode" name="deptCode" type="text" title="" placeholder="Dept. Code" class="w100p" /></td>
          <th></th>
          <td></td>
        </tr>
       </tbody>
      </table>
      <!-- table end -->
      <!-- link_btns_wrap end -->
     </form>
    </section>
    <!-- search_table end -->
   </form>
  </div>
 <div id="hsManua" style="display: block;">
   <form id="hsManua" method="post">
    <section class="search_table">
     <!-- search_table start -->
     <form action="#" method="post">
      <table class="type1">
       <!-- table start -->
       <caption>table</caption>
       <colgroup>
        <col style="width: 100px" />
        <col style="width: *" />
        <col style="width: 100px" />
        <col style="width: *" />
        <col style="width: 100px" />
        <col style="width: *" />
       </colgroup>
       <tbody>
        <tr>
         <th scope="row">Sales Order</th>
         <td><input id="ManuaSalesOrder" name="ManuaSalesOrder"
          type="text" title="" placeholder="Sales Order" class="w100p" />
         </td>
         <th scope="row">HS Period</th>
         <td><p style="width:70%"><input id="ManuaMyBSMonth" name="ManuaMyBSMonth"
          type="text" title="기준년월" placeholder="MM/YYYY"
          class="j_date2 w100p" readonly /></p>
          <p class="btn_gray">
           <a href="#" onclick="fn_cMyBSMonth('ManuaMyBSMonth')">Clear</a>
          </p>
         </td>
         <th scope="row">Customer ID</th>
         <td><input id="manualCustomer" name="manualCustomer"
          type="text" title="" placeholder="Customer ID" class="w100p" />
         </td>
        </tr>
        <tr>
         <th scope="row">Branch<span class="must">*</span></th>
         <td><select id="cmdBranchCode1" name="cmdBranchCode1"
          class="w100p">
           <option value="">Choose One</option>
           <c:forEach var="list" items="${branchList }"
            varStatus="status">
            <option value="${list.codeId}">${list.codeName}</option>
           </c:forEach>
         </select></td>
         <th scope="row">Cody Manager</th>
         <td colspan="3"><select id="cmdCdManager1"
          name="cmdCdManager1" class=""></td>
        </tr>
       </tbody>
      </table>
      <!-- table end -->
      <!-- link_btns_wrap end -->
     </form>
    </section>
    <!-- search_table end -->
   </form>
  </div>
  <table class="type1">
   <!-- table start -->
   <tbody>
    <tr>
     <!--Alex-20072020 -- defaulted value without display radio button-->
     <td><label><input type="radio" name="searchDivCd" style="display:none"
       value="1" onClick="fn_checkRadioButton('comm_stat_flag')" checked /></label>
       <label><input type="radio"
       name="searchDivCd" style="display:none" value="2"
       onClick="fn_checkRadioButton('comm_stat_flag')" /></label></td>
    </tr>
   </tbody>
  </table>
<!--   <ul class="right_btns">
    <li><p class="btn_grid">
      <a href="#" onclick="fn_excelDown()">GENERATE</a>
     </p></li>
  </ul> -->
  <section class="search_result">
   <!-- search_result start -->
   <!-- <ul class="right_btns">
    <li><p class="btn_grid"><a id="hSConfiguration">HS Order Create</a></p></li>
</ul> -->
   <!-- <ul class="right_btns">
    <li><p class="btn_grid"><a href="#" " onclick="javascript:fn_getHSConfAjax();">HS Configuration</a></p></li>
</ul> -->
   <article class="grid_wrap">
    <!-- grid_wrap start -->
    <div id="grid_wrap"
     style="width: 100%; height: 800px; margin: 0 auto;"></div>
   </article>
   <!-- grid_wrap end -->
  </section>
  <!-- search_result end -->
  <ul class="center_btns">
   <!--<li><p class="btn_blue2"><a href="#">Cody Assign</a></p></li> -->
  </ul>
 </section>
 <!-- content end -->
</form>
