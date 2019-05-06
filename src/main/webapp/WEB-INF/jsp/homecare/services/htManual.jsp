<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javaScript" language="javascript">
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

  var columnAssiinLayout = [
      {
        dataField : "rnum",
        headerText : "RowNum",
        width : 120,
        height : 30,
        visible : false
      },
      {
        dataField : "custId",
        headerText : "Customer ID",
        width : 120
      },
      {
        dataField : "name",
        headerText : "Customer Name",
        width : 120
      },
      {
        dataField : "salesOrdNo",
        headerText : "Care Service Order",
        width : 120
      },
      {
        dataField : "hsDate",
        headerText : "CS Period",
        width : 120
      },
      {
        dataField : "no",
        headerText : "CS Order",
        width : 120
      },
      {
        dataField : "c5",
        headerText : "Assign HT",
        width : 120
      },
      {
        dataField : "deptCode",
        headerText : "Department",
        width : 120
      },
      {
        dataField : "htStatus",
        headerText : "HT Status",
        width : 120
      },
      {
        dataField : "code",
        headerText : "CS Status",
        width : 120
      },
      {
        dataField : "htBrnchCode",
        headerText : "Branch CD",
        width : 120
      },
      {
        dataField : "htMgrCode",
        headerText : "HT Manager",
        width : 120
      },
      {
        dataField : "stusCodeId",
        headerText : "HT Status Code",
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
      },
      {
        dataField : "undefined",
        headerText : "Edit",
        width : 170,
        renderer : {
          type : "ButtonRenderer",
          labelText : "Edit",
          onclick : function(rowIndex, columnIndex, value, item) {

            if (item.code == "ACT") {
              Common
                  .alert('Not able to EDIT for the CS order status in Active.');
              return false;
            }

            $("#_schdulId").val(item.schdulId);
            $("#_salesOrdId").val(item.salesOrdId);
            $("#_openGb").val("edit");
            $("#_brnchId").val(item.brnchId);

            Common.popupDiv(
                "/homecare/services/htBasicInfoPop.do?MOD=EDIT&ROW="
                    + rowIndex, $("#popEditForm")
                    .serializeJSON(), null, true, '');
          }
        }
      } ];



  function fn_close() {
    window.close();
  }



  function fn_getBSListAjax() {

      if ($("#myBSMonth").val() == "") {
        if ($("#txtSalesOrder").val() == "" && $("#txtHsOrderNo").val() == "") {
          Common.alert("CS Period or CS Order or Care Service Order are required.");
          return false;
        }
      }

      if ($("#userType").val() != "4" && $("#userType").val() != "6") {
        if ($("#cmdBranchCode").val() == ''
            || $("#cmdBranchCode").val() == null) {
          Common.alert("Please Select 'HT Branch'");
          return false;
        }
      }

      if ($("#userType").val() == "2") {
        if ($("#memberLevel").val() == "3"
            || $("#memberLevel").val() == "4") {
          if ($("#cmdCdManager").val() == ''
              || $("#cmdCdManager").val() == null) {
            Common.alert("Please Select 'HT Manager'");
            return false;
          }
        }
      }

      Common.ajax("GET", "/homecare/services/selectHsManualList.do", $(
      "#searchForm").serialize(), function(result) {
        AUIGrid.setGridData(myGridID, result);
      });
    }


  function fn_getHSAddListAjax() {
    // Common.popupDiv("/services/addInstallationPopup.do?isPop=true&installEntryId=" + installEntryId+"&codeId=" + codeid1);
    var checkedItems = AUIGrid.getCheckedRowItemsAll(myGridID);

    if (checkedItems.length <= 0) {
      Common.alert('No data selected.');
      return;
    } else if (checkedItems.length >= 2) {
      Common.alert('Only availbale to entry a result with single CS order');
      return;
    } else if (checkedItems[0]["code"] != "ACT") {
      Common.alert('Only availbale to entry a result<br/>for the CS order status in Active');
      return;
    } else {
      var str = "";
      var custStr = "";
      var rowItem;
      var brnchId = "";
      var saleOrdList = "";
      var list = "";
      var brnchCnt = "";

      var saleOrd = {
        salesOrdNo : ""
      };

      for (var i = 0, len = checkedItems.length; i < len; i++) {
        rowItem = checkedItems[i];
        hsStuscd = rowItem.stusCodeId;
        schdulId = rowItem.schdulId;
        salesOrdId = rowItem.salesOrdId;

        if (hsStuscd == 4) {
          Common.alert("already has result. Result entry is disallowed.");
          return;
        }
      }
    }

    Common.popupDiv(
        "/homecare/services/selectCsInitDetailPop.do?isPop=true&schdulId="
            + schdulId + "&salesOrdId=" + salesOrdId, null, null,
        true, '_hsDetailPopDiv');
  }

  /* function fn_codyChangeHQ() {
    $("#_openGb").val("codyChange");

    var radioVal = $("input:radio[name='searchDivCd']:checked").val();
    if (radioVal == '2') {
      Common.alert("'Assign HT Transfer' is not allow in Manual CS");
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

      }

      Common
          .confirmCustomizingButton(
              "Do you want to transfer an assign cody<br>with this CM group?",
              "Yes", "No", fn_originBrnchAssign, fn_selectBrnchCM); */

      /*

      // deptCode의 MEM_UP_ID가 동일한 것만 수정 가능하도록
      Common.ajax("GET", "/services/bs/assignDeptMemUp.do?deptList="+deptList, "" , function(result){
        var memUpId = "";
        var memUpCnt = 0;
        for (var j=0; j<result.length; j++) {
          if (j == 0) {
            memUpId = result[j]["memUpId"];
          } else if (j != 0){
            if(memUpId != result[j]["memUpId"] ){
              memUpCnt += 1 ;
            }
          }
        }

        if (memUpCnt != 0) {
          // Department의 MEM_UP_ID가 다른 걸 한꺼번에 Assign Cody Transfer 하려고 할 때 alert 메시지
          Common.alert("Not Avaialable to Assign Cody Transfer </br>With different assigned Cody's Group in Single Time.");
          return;
        } else {
          Common.confirmCustomizingButton("같은 브랜치?", "Yes", "No", fn_sameBrnchAssign, fn_otherBrnchAssign);
        }
      }); */

      /*
      if(brnchCnt > 0 ){
        Common.alert("Not Avaialable to Assign Cody Transfer With Several CDB in Single Time.");
        return;
      }
      */

    /*   function fn_originBrnchAssign() {
        var jsonObj = {
          "SaleOrdList" : saleOrdList,
          "BrnchId" : brnchId,
          "ManualCustId" : $("#manualCustomer").val(),
          "ManuaMyBSMonth" : $("#ManuaMyBSMonth").val(),
          "department" : dept

        };

        Common
            .popupDiv("/homecare/services/selecthSCodyChangePop.do?isPop=true&JsonObj="
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

      function fn_selectBrnchCM() {
        var jsonObj = {
          "SaleOrdList" : saleOrdList,
          "BrnchId" : brnchId,
          "ManualCustId" : $("#manualCustomer").val(),
          "ManuaMyBSMonth" : $("#ManuaMyBSMonth").val(),
          "department" : dept

        };

        Common.popupDiv("/homecare/services/assignBrnchCMPop.do?JsonObj="
            + jsonObj + "&CheckedItems=" + saleOrdList
            + "&BrnchId=" + brnchId + "&ManuaMyBSMonth="
            + $("#ManuaMyBSMonth").val() + "&deptList=" + deptList);
      }

    }

  } */

/*   function fn_codyChange() {
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
    } else { */

      /*
      if(checkedItems.length > 1){
        Common.alert('please choose one data selected.');
        return false;
      }
      */

     /*  var str = "";
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
        } */

        /*
        //동일 brnch 만 수정하도록
        if(i !=0 ){
          if(ctBrnchCodeOld != rowItem.codyBrnchCode ){
            brnchCnt += 1 ;
          }
        }
        ctBrnchCodeOld = rowItem.codyBrnchCode;
        */

      /*   if (i == 0) {
          brnchId = rowItem.branchCd;
        }

        if (rowItem.stusCodeId == "4") {
          Common
              .alert('Not Allow to HT Transfer for Complete HS Order');
          return;
        }

        dept = rowItem.deptCode;

      } */

      //Common.confirmCustomizingButton("Do you want to transfer an assign cody<br>with this CM group?", "Yes", "No", fn_originBrnchAssign, fn_selectBrnchCM);
      //fn_originBrnchAssign();

      /*
      // deptCode의 MEM_UP_ID가 동일한 것만 수정 가능하도록
      Common.ajax("GET", "/services/bs/assignDeptMemUp.do?deptList="+deptList, "" , function(result){
        var memUpId = "";
        var memUpCnt = 0;
        for (var j=0; j<result.length; j++) {
          if (j == 0) {
            memUpId = result[j]["memUpId"];
          } else if (j != 0){
            if(memUpId != result[j]["memUpId"] ){
              memUpCnt += 1 ;
            }
          }
        }

        if (memUpCnt != 0) {
          // Department의 MEM_UP_ID가 다른 걸 한꺼번에 Assign Cody Transfer 하려고 할 때 alert 메시지
          Common.alert("Not Avaialable to Assign Cody Transfer </br>With different assigned Cody's Group in Single Time.");
          return;
        } else {
          Common.confirmCustomizingButton("같은 브랜치?", "Yes", "No", fn_sameBrnchAssign, fn_otherBrnchAssign);
        }
      });
      */

      /*
      if(brnchCnt > 0 ){
        Common.alert("Not Avaialable to Assign Cody Transfer With Several CDB in Single Time.");
        return;
      }
      */

      /* function fn_originBrnchAssign() {
        var jsonObj = {
          "SaleOrdList" : saleOrdList,
          "BrnchId" : brnchId,
          "ManualCustId" : $("#manualCustomer").val(),
          "ManuaMyBSMonth" : $("#ManuaMyBSMonth").val(),
          "department" : dept
        };

        Common
            .popupDiv("/homecare/services/selecthSCodyChangePop.do?isPop=true&JsonObj="
                + jsonObj
                + "&CheckedItems="
                + saleOrdList
                + "&BrnchId="
                + brnchId
                + "&ManuaMyBSMonth="
                + $("#ManuaMyBSMonth").val()
                + "&deptList="
                + deptList);
      } */

      /*
      function fn_selectBrnchCM(){
        var jsonObj = { "SaleOrdList" : saleOrdList,
                        "BrnchId": brnchId,
                        "ManualCustId" : $("#manualCustomer").val(),
                        "ManuaMyBSMonth" : $("#ManuaMyBSMonth").val(),
                        "department" : dept
         };

          Common.popupDiv("/services/bs/assignBrnchCMPop.do?JsonObj="+jsonObj+"&CheckedItems="+saleOrdList+"&BrnchId="+brnchId+"&ManuaMyBSMonth="+$("#ManuaMyBSMonth").val()+"&deptList="+deptList);
      }
      */
   // }
  //}

  /*
  function fn_sameBrnchAssign(){
  var jsonObj = { "SaleOrdList" : saleOrdList,
                  "BrnchId": brnchId,
                  "ManualCustId" : $("#manualCustomer").val(),
                  "ManuaMyBSMonth" : $("#ManuaMyBSMonth").val(),
                  "department" : dept
   };

   Common.popupDiv("/services/bs/selecthSCodyChangePop.do?isPop=true&JsonObj="+jsonObj+"&CheckedItems="+saleOrdList+"&BrnchId="+brnchId +"&ManuaMyBSMonth="+$("#ManuaMyBSMonth").val()  +"&department="+ dept );
  }

  function fn_otherBrnchAssign(){
  }
  */
/*
  $(function() {
    $("#hSConfiguration")
        .click(
            function() {
              $("#_openGb").val("hsConfig");

              var checkedItems = AUIGrid
                  .getCheckedRowItemsAll(myGridID);

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
                var saleOrd = {
                  salesOrdNo : ""
                };

                for (var i = 0, len = checkedItems.length; i < len; i++) {
                  rowItem = checkedItems[i];
                  saleOrdList += rowItem.salesOrdNo;

                  var hsStutus = rowItem.code;
                  if (hsStutus == "COM") {
                    Common.alert("<b>  do no has result COM..");
                    return;
                  }

                  if (i != len - 1) {
                    saleOrdList += ",";
                  }

                  if (i != 0) {
                    if (ctBrnchCodeOld != rowItem.codyBrnchCode) {
                      brnchCnt += 1;
                    }
                  }

                  ctBrnchCodeOld = rowItem.codyBrnchCode;

                  if (i == 0) {
                    brnchId = rowItem.brnchId;
                  }

                }

                if (brnchCnt > 0) {
                  Common.alert("Not Avaialable to Create HS Order With Several CDB in Single Time.");
                  return;
                }

                var jsonObj = {
                  "SaleOrdList" : saleOrdList,
                  "BrnchId" : brnchId,
                  "ManualCustId" : $("#manualCustomer").val(),
                  "ManuaMyBSMonth" : $("#ManuaMyBSMonth").val()
                };

                Common
                    .ajax(
                        "GET",
                        "/homecare/services/selectHsOrderInMonth.do?saleOrdList="
                            + saleOrdList
                            + "&ManuaMyBSMonth="
                            + $("#ManuaMyBSMonth").val(),
                        "",
                        function(result) {
                          console.log(result);
                          if (result.message == "success") {
                            Common.alert("There is already exist for HS order for this month");
                            return;
                          } else {
                            Common
                                .popupDiv("/homecare/services/selectHSConfigListPop.do?isPop=true&JsonObj="
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
                        });
              }
            });
  });
 */
  /*
    AUIGrid.bind(myGridID, "cellClick", function(event) {
      custId =  AUIGrid.getCellValue(myGridID, event.rowIndex, "custId");
    });
  */

  $(document).ready(
      function() {

    	    AUIGrid.setProp(myGridID, gridProsAssiin);
    	    createAssinAUIGrid(columnAssiinLayout);


        doDefCombo(StatusTypeData, '', 'cmbStatusType', 'S', '');

        $('#myBSMonth').val(
            $.datepicker.formatDate('mm/yy', new Date()));
        $('#ManuaMyBSMonth').val(
            $.datepicker.formatDate('mm/yy', new Date()));

        $("#cmdBranchCode").click(
            function() {
              $("#cmdCdManager").find('option').each(function() {
                $(this).remove();
              });

              /*
              CHANGE TO TEXTBOX - txtcodyCode
              $("#cmdcodyCode").find('option').each(function() {
                $(this).remove();
              });
              */

              if ($(this).val().trim() == "") {
                return;
              }

              if ($("#userType").val() != "3") {
                doGetCombo('/homecare/services/getCdUpMemList.do', $(
                    this).val(), '', 'cmdCdManager', 'S',
                    'fn_cmdBranchCode');
              }
            });

        $("#cmdBranchCode1").click(
            function() {
              $("#cmdCdManager1").find('option').each(function() {
                $(this).remove();
              });

              /*
              HS ORDEER SEARCH USED ONLY AND CHANGE TO TEXTBOX
              $("#cmdcodyCode").find('option').each(function() {
                $(this).remove();
              });
              */

              if ($(this).val().trim() == "") {
                return;
              }
              if ($("#userType").val() != "3") {
                doGetCombo('/homecare/services/getCdDeptList.do', $(
                    this).val(), '', 'cmdCdManager1', 'S',
                    'fn_cmdBranchCode1');
              }
            });



        //fn_checkRadioButton();

        AUIGrid.bind(myGridID, "cellClick", function(event) {
          schdulId = AUIGrid.getCellValue(myGridID, event.rowIndex, "schdulId");
          salesOrdId = AUIGrid.getCellValue(myGridID, event.rowIndex, "salesOrdId");
          hsStuscd = AUIGrid.getCellValue(myGridID, event.rowIndex, "stusCodeId");
          result = AUIGrid.getCellValue(myGridID, event.rowIndex, "result");
        });

        AUIGrid.bind(myGridID, "cellDoubleClick", function(event) {
          var radioVal = $("input:radio[name='searchDivCd']:checked").val();

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
                  "/homecare/services/htBasicInfoPop.do?MOD=VIEW",
                  $("#popEditForm").serializeJSON(), null,
                  true, '');
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

          //$("#cmdCdManager1 option:eq(1)", '#searchForm').attr("selected", true);

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
  }

  // AUIGrid 를 생성합니다.
  function createManualAUIGrid(columnManualLayout) {
    myGridID = AUIGrid.create("#grid_wrap", columnManualLayout,
        gridProsManual);
  }


/*   function fn_checkboxChangeHandler(event) {

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
  } */

/*   function fn_hsCountForecastListing() {
    Common.popupDiv("/services/bs/report/hsCountForecastListingPop.do",
        null, null, true, '');
  } */

  function fn_hsReportSingle() {
    Common.popupDiv("/homecare/services/htReportSinglePop.do", null, null,
        true, '');
  }
  function fn_hsReportGroup() {
    Common.popupDiv("/homecare/services/htReportGroupPop.do", null, null,
        true, '');
  }
  function fn_hsSummary() {
    Common.popupDiv("/homecare/services/htSummaryList.do", null, null,
        true, '');
  }

/*   function fn_filterForecastList() {
    Common.popupDiv("/services/bs/report/filterForecastListingPop.do",
        null, null, true, '');
  } */

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

  function fn_excelDown() {
    var radioVal = $("input:radio[name='searchDivCd']:checked").val();

    if (radioVal == 1) { // HS Order Search
      GridCommon.exportTo("grid_wrap", "xlsx", "CS Order Search");
    } else { // Manual HS
      GridCommon.exportTo("grid_wrap", "xlsx", "Manual CS");
    }
  }

/*   function fn_hsConfigOld() {
    window.open("/services/bs/hsManualOld.do", '_self');
  } */

/*   function fn_hsMonthlySetting() {
    window.open("/services/bs/hsMonthlyConfigOldVer.do", '_self');
  } */

  function fn_cMyBSMonth(field) {
    $("#" + field + "").val("");
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
<%--
  <form id="popEditViewForm" method="post">
    <input type="hidden" name="schdulId"  id="_schdulIdView"/>  <!-- schdulId  -->
    <input type="hidden" name="salesOrdId"  id="_salesOrdIdView"/>  <!-- salesOrdId  -->
    <input type="hidden" name="openGb"  id="_openGbView"/>  <!--   salesOrdId  -->
    <input type="hidden" name="brnchId"  id="_brnchIdView"/>  <!-- salesOrdId  -->
  </form>
--%>
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
   <h2>Care Service Management</h2>
   <ul class="right_btns">
    <c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
 <!--     <li><p class="btn_blue">
       <a href="#" onclick="javascript:fn_codyChangeHQ();"
        id="codyChangeHQ">Assign Cody Transfer HQ</a>
      </p></li>
     <li><p class="btn_blue">
       <a href="#" onclick="javascript:fn_codyChange();" id="codyChange">Assign
        Cody Transfer</a>
      </p></li> -->
     <li><p class="btn_blue">
       <a href="#" onclick="javascript:fn_getHSAddListAjax();"
        id="addResult">Add CS Result</a>
      </p></li>
     <li><p class="btn_blue">
   <!--     <a id="hSConfiguration" name="hSConfiguration">Create CS
        Order</a> -->
      </p></li>
     <li><p class="btn_blue">
       <a href="#" onclick="javascript:fn_getBSListAjax();"><span
        class="search"></span>
       <spring:message code='sys.btn.search' /></a>
      </p></li>
    </c:if>
   </ul>
   <!--조회조건 추가  -->
   <!--
    <label><input type="radio" name="searchDivCd" value="1" onClick="fn_checkRadioButton('comm_stat_flag')" checked />HS Order Search</label>
    <label><input type="radio" name="searchDivCd" value="2" onClick="fn_checkRadioButton('comm_stat_flag')" />Manual HS</label>
   -->
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
         <th scope="row">HT Branch<span class="must">*</span></th>
         <td><select id="cmdBranchCode" name="cmdBranchCode"
          class="w100p readOnly ">
           <option value="">Choose One</option>
           <c:forEach var="list" items="${branchList }"
            varStatus="status">
            <option value="${list.codeId}">${list.codeName}</option>
           </c:forEach>
         </select></td>
         <th scope="row">HT Manager</th>
         <td><select id="cmdCdManager" name="cmdCdManager"
          class="w100p"></td>
         <th scope="row">Assign HT</th>
         <td><input id="txtAssigncodyCode" name="txtAssigncodyCode"
          type="text" title="" placeholder="Cody" class="w100p" /> <!-- By Kv - Change cmbBox to text Box -->
          <!-- <select class="w100p" id="cmdcodyCode" name="cmdcodyCode" > -->
          <!-- <option value="">cody</option> --></td>
         <th scope="row">Complete HT</th>
         <td><input id="txtComcodyCode" name="txtComcodyCode"
          type="text" title="" placeholder="Cody" class="w100p" /></td>
        </tr>
        <tr>
         <th scope="row">CS Order</th>
         <td><input id="txtHsOrderNo" name="txtHsOrderNo"
          type="text" title="" placeholder="HS Order" class="w100p" />
         </td>
         <th scope="row">CS Period</th>
         <td><p style="width:70%;">
         <input id="myBSMonth" name="myBSMonth" type="text"
          title="기준년월" placeholder="MM/YYYY" class="j_date2 w100p"/></p>
          <p class="btn_gray">
           <a href="#" onclick="fn_cMyBSMonth('myBSMonth')">Clear</a>
          </p></td>
         <th scope="row">CS Status</th>
         <td><select class="w100p" id="cmbStatusType"
          name="cmbStatusType">
           <option value="">CS Status</option></td>
         <th scope="row">Customer ID</th>
         <td><input id="txtCustomer" name="txtCustomer" type="text"
          title="" placeholder="Customer ID" class="w100p" /></td>
        </tr>
        <tr>
         <th scope="row">Care Service Order</th>
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
         <th scope="row">Dept. Code</th>
         <td><input id="deptCode" name="deptCode" type="text"
          title="" placeholder="Dept. Code" class="w100p" /></td>
         <th scope="row"></th>
         <td></td>
        </tr>
       </tbody>
      </table>

  <table class="type1">
   <!-- table start -->
  <tbody>
<!--  <tr>
     <td><label><input type="radio" name="searchDivCd" value="1" onClick="fn_checkRadioButton('comm_stat_flag')" checked />HS Order Search</label>
       <label><input type="radio" name="searchDivCd" value="2" onClick="fn_checkRadioButton('comm_stat_flag')" />Manual HS</label></td>
    </tr> -->
   </tbody>
  </table>
   <aside class="link_btns_wrap">
       <!-- link_btns_wrap start -->
       <!-- <p class="show_btn"><a href="#"><img src="../images/common/btn_link.gif" alt="link show" /></a></p> -->
       <p class="show_btn">
        <a href="#"><img
         src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif"
         alt="link show" /></a>
       </p>
       <dl class="link_list">
        <dt>Link</dt>
        <dd>
         <ul class="btns">

          <c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">

           <li><p class="link_btn type2">
             <a href="#" onclick="javascript:fn_hsSummary()">CS
              Summary Listing</a>
            </p></li>
               <li><p class="link_btn type2">
             <a href="#" onclick="javascript:fn_hsReportSingle()">CS
              Report(Single)</a>
            </p></li>

                   <li><p class="link_btn type2">
             <a href="#" onclick="javascript:fn_hsReportGroup()">CS
              Report(Group)</a>
            </p></li>

          </c:if>

         </ul>

         <p class="hide_btn">
          <a href="#"><img
           src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif"
           alt="hide" /></a>
         </p>
        </dd>
       </dl>
      </aside>
      <!-- link_btns_wrap end -->

  <ul class="right_btns">
   <c:if test="${PAGE_AUTH.funcPrint == 'Y'}">
    <li><p class="btn_grid">
      <a href="#" onclick="fn_excelDown()">GENERATE</a>
     </p></li>
   </c:if>
  </ul>
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

