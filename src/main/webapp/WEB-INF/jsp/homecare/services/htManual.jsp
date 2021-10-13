<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javaScript" language="javascript">
var TODAY_DD      = "${toDay}";

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
	    dataField : "custId",
	    headerText : "Customer ID",
	    width : 120
	  }, {
	    dataField : "name",
	    headerText : "Customer Name",
	    width : 120
	  }, {
	    dataField : "salesOrdNo",
	    headerText : "Sales Order No",
	    width : 120
	  }, {
	        dataField : "ccsOrdNo",
	        headerText : "Care Service Order",
	        width : 120
	      }, {
	    dataField : "hsDate",
	    headerText : "CS Date",
	    width : 120,
	    visible : false
	  }, {
	    dataField : "no",
	    headerText : "HCS Order",
	    width : 120
	  }, {
	        dataField : "apptype",
	        headerText : "Application Type",
	        width : 120
	      }, {
	            dataField : "salesProdSz",
	            headerText : "Bed Size",
	            width : 120
	          },{
	    dataField : "c5",
	    headerText : "Assign HT",
	    width : 120
	  }, {
	    dataField : "htStatus",
	    headerText : "HT Status",
	    width : 120
	  }, {
	    dataField : "code",
	    headerText : "CS Status",
	    width : 120
	  }, {
	    dataField : "month",
	    headerText : "Complete HT",
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
	    dataField : "htBrnchCode",
	    headerText : "Branch Code",
	    width : 120
	  }, {
	    dataField : "htMgrCode",
	    headerText : "HT Manager",
	    width : 120
	  }, {
	    dataField : "address",
	    headerText : "Service Address",
	    width : 120
	  }, {
	    dataField : "stkDesc",
	    headerText : "Mattress Size",
	    width : 120
	  }, {
	    dataField : "hsFreq",
	    headerText : "CS Frequency",
	    width : 120
	  }, {
	    dataField : "prevMthHsStatus",
	    headerText : "Previous Month CS Result",
	    width : 120
	  } ];

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
          dataField : "apptype",
          headerText : "Application Type",
          width : 120
        },
        {
            dataField : "salesProdSz",
            headerText : "Bed Size",
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
          dataField : "crtUserId",
          headerText : "Create User ID",
          width : 200
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

              //var todayMMYYYY = String(TODAY_DD.substr(3, 7));
              var todayMM = Number(TODAY_DD.substr(3, 2));
              var todayYYYY = Number(TODAY_DD.substr(6, 4));

              //console.log("todayMMYYYY : "+ todayMMYYYY);
              console.log("todayMM : "+ todayMM);
              console.log("todayYYYY : "+ todayYYYY);
              console.log("item.hsDate : "+ item.hsDate);

            if (item.code == "ACT") {
              Common
                  .alert('Not able to EDIT for the CS Order status in Active.');
              return false;
            }

            if(item.hsDate != todayMM + "/" + todayYYYY) {
            	Common.alert("Not able to EDIT previous month CS Order.");
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

	   var radioVal = $("input:radio[name='searchDivCd']:checked").val();
	    if (radioVal == 1) { //HS NO CREATE BEFORE
	        // HS PRERIOD ARE OPTIONAL IF SALES ORDER OR HS ORDER PROVIDED
      if ($("#myBSMonth").val() == "") {
        if ($("#txtSalesOrder").val() == "" && $("#txtHsOrderNo").val() == "") {
          Common.alert("CS Period or CS Order or Care Service Order are required.");
          return false;
        }
      }

//       if ($("#userType").val() != "4" && $("#userType").val() != "6") {
//         if ($("#cmdBranchCode").val() == ''
//             || $("#cmdBranchCode").val() == null) {
//           Common.alert("Please Select 'HT Branch'");
//           return false;
//         }
//       }

      if ($("#orgCode").val() =='' && $("#grpCode").val() =='' && $("#deptCode").val() =='') {
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

      Common.ajax("GET", "/homecare/services/selectHsAssiinlList.do", $(
      "#searchForm").serialize(), function(result) {
        AUIGrid.setGridData(myGridID, result);
      });

	    }else { //HS NO CREATE AFTER
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
	          if ($("#memId1").val().substring(0, 3) != "CHT") {
	            memId = "";
	          }

	          if ($("#userType").val() != "4" && $("#userType").val() != "6") {
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
	                Common.alert("Please Select 'HT Manager'");
	                return false;
	              }
	            }
	          }

	          // Common.ajax("GET", "/services/bs/selectHsManualList.do", {ManuaSalesOrder:$("#ManuaSalesOrder").val(),ManuaMyBSMonth:$("#ManuaMyBSMonth").val(),ManualCustomer:$("#manualCustomer").val(),cmdBranchCode1:$("#brnchId1").val(),cmdCdManager1:$("#memId1").val()}, function(result) {
	          Common.ajax("GET", "/homecare/services/selectHsManualList.do", {
	            ManuaSalesOrder : $("#ManuaSalesOrder").val(),
	            ManuaMyBSMonth : $("#ManuaMyBSMonth").val(),
	            ManualCustomer : $("#manualCustomer").val(),
	            ManuaSalesOrderNo : $("#manuaOrderNo").val(),
	            cmdBranchCode1 : HsCdBranch,
	            cmdCdManager1 : memId
	          }, function(result) {
	            AUIGrid.setGridData(myGridID, result);
	          });
	        }


    }

  function fn_htChange(){
	  var checkedItems = AUIGrid.getCheckedRowItemsAll(myGridID);
	   var radioVal = $("input:radio[name='searchDivCd']:checked").val();


	    if (checkedItems.length <= 0) {
	      Common.alert('No data selected.');
	      return;
	    } else if (radioVal == 2) {
	    	 Common.alert('Not allow to Assign HT in Manual CS');
	          return;
	    }else if (checkedItems.length >= 2) {
	      Common.alert('Only allow to entry a result with single CS Order');
	      return;
	    } else if (checkedItems[0]["code"] != "ACT") {
	      Common.alert('Only allow to entry a result<br/>for the CS Order status in Active');
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
	          custId = rowItem.custId;
	          brnchId = rowItem.brnchId;
	          codyMangrUserId = rowItem.c5 ;

	          if (hsStuscd == 4) {
	            Common.alert("CS result already COM. Assign HT Member is disallowed.");
	            return;
	          }
	        }
	      }

	    		  Common.popupDiv("/homecare/services/htConfigBasicPop.do?isPop=true&schdulId="+ schdulId + "&salesOrdId="+salesOrdId +"&brnchId="+brnchId +"&codyMangrUserId="+codyMangrUserId+"&custId="+custId +"&indicator=1", null, null , true , '_ConfigBasicPop');

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
          Common.alert('Only allow to entry a result<br/>for the CS Order status in Active');
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

                  Common.popupDiv("/homecare/services/htConfigBasicMultiplePop.do?isPop=true&schdulId="+ schdulId + "&salesOrdId="+saleOrdList  +"&indicator=1", null, null , true , '_ConfigBasicPop');
  }

  function fn_getHSAddListAjax() {
    // Common.popupDiv("/services/addInstallationPopup.do?isPop=true&installEntryId=" + installEntryId+"&codeId=" + codeid1);
    var checkedItems = AUIGrid.getCheckedRowItemsAll(myGridID);
    var radioVal = $("input:radio[name='searchDivCd']:checked").val();


    if (checkedItems.length <= 0) {
      Common.alert('No data selected.');
      return;
    } else if (radioVal == 2) {
        Common.alert('Not allow to Add CS Result in Manual CS');
        return;
        }else if (checkedItems.length >= 2) {
      Common.alert('Only allow to entry a result with single CS Order');
      return;
        }else if (checkedItems[0]["c5"] == null || checkedItems[0]["c5"] == "") {
            Common.alert('Please assign HT member.');
            return;
    } else if (checkedItems[0]["code"] != "ACT") {
      Common.alert('Only allow to entry a result<br/>for the CS Order status in Active');
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
          Common.alert("CS result already COM. Result entry is disallowed.");
          return;
        }
      }
    }

    Common.popupDiv(
        "/homecare/services/selectCsInitDetailPop.do?isPop=true&schdulId="
            + schdulId + "&salesOrdId=" + salesOrdId, null, null,
        true, '_hsDetailPopDiv');
  }

  function fn_selfClose(){
      $('#closeHtConfigPop').click();
      }

  $(function() {
	    $("#hSConfiguration")
	        .click(
	            function() {
	              $("#_openGb").val("hsConfig");

	              var todayDD = Number(TODAY_DD.substr(0, 2));
	              var todayYY = Number(TODAY_DD.substr(6, 4));

/* 	                  if(todayYY >= 2018) {
	                      if(todayDD > 22) { // Block if date > 22th of the month
	                          var msg = 'Disallow Create CS Order After 22nd of the Month.';
	                          Common.alert('<spring:message code="sal.alert.msg.actionRestriction" />' + DEFAULT_DELIMITER + "<b>" + msg + "</b>", '');
	                          return;
	                      }
	                  } */

	              var checkedItems = AUIGrid
	                  .getCheckedRowItemsAll(myGridID);

	              if (checkedItems.length <= 0) {
	                Common.alert('No data selected.');
	                return false;
	               } else if (checkedItems.length >= 2) {
	                  Common.alert('Only allow single CS Order created. ');
	                  return;
	                }else {
	                var str = "";
	                var custStr = "";
	                var rowItem;
	                var brnchId = "";
	                var saleOrdList = "";
	                var saleOrdIdList = "";
	                var list = "";
	                var brnchCnt = 0;
	                var ctBrnchCodeOld = "";
	                var saleOrd = {
	                  salesOrdNo : ""
	                };

	                for (var i = 0, len = checkedItems.length; i < len; i++) {
	                  rowItem = checkedItems[i];
	                  saleOrdList += rowItem.ccsOrdNo;
	                  saleOrdIdList += rowItem.salesOrdId;
	                  var brnchId = rowItem.brnchId;
                      var custStr = rowItem.custId;
                      var hsStatus = rowItem.code;

	                  var hsStatus = rowItem.code;
	                  if (hsStatus == "COM") {
	                    Common.alert("<b>Create CS Order disallow due to CS Status is COM.");
	                    return;
	                  }

	                  if (i != len - 1) {
	                    saleOrdList += ",";
	                  }

	                  if (i != len - 1) {
	                        saleOrdIdList += ",";
	                      }

	                  if (i != 0) {
	                    if (ctBrnchCodeOld != rowItem.htBrnchCode) {
	                      brnchCnt += 1;
	                    }
	                  }

	                  ctBrnchCodeOld = rowItem.htBrnchCode;

	                  if (i == 0) {
	                    brnchId = rowItem.brnchId;
	                  }

	                }

	                if (brnchCnt > 0) {
	                  Common.alert("Not Available to Create CS Order With Several CDB in Single Time.");
	                  return;
	                }

	                var jsonObj = {
	                  "SaleOrdList" : saleOrdList,
	                  "SaleOrdIdList" : saleOrdIdList,
	                  "BrnchId" : brnchId,
	                  "ManualCustId" : custStr,
	                  "ManuaMyBSMonth" :  $.datepicker.formatDate('mm/yy', new Date())
	                };

	                Common
	                    .ajax(
	                        "GET",
	                        "/homecare/services/selectHsOrderInMonth.do?saleOrdList="
	                            + saleOrdList
	                            + "&ManuaMyBSMonth="
	                            + $.datepicker.formatDate('mm/yy', new Date())
	                            + "&saleOrdIdList="
	                            + saleOrdIdList,
	                        "",
	                        function(result) {
	                          console.log ('BS Month : ' +  $.datepicker.formatDate('mm/yy', new Date()));
	                          if (result.message == "fail") {
	                            Common.alert("<b>Manual create CS Order disallow due to already exist for current month.");
	                            return;
	                          } else if (result.message == "warning") {
	                                Common.alert("<b>Manual create CS Order (CS1T & FT1T) disallow due to already completed / cancel on previous month.");
	                                return;
	                              }
	                          else if (result.message == "block") {
                                  Common.alert("<b>Manual create CS Order (CS1Y & FT1Y) disallow due to already completed with total 3 times.");
                                  return;
                                }
	                          else {
	                              Common
                                  .popupDiv("/homecare/services/selectCSConfigListPop.do?isPop=true&JsonObj="
                                      + jsonObj
                                      + "&CheckedItems="
                                      + saleOrdList
                                      + "&BrnchId="
                                      + brnchId
                                      + "&ManuaMyBSMonth="
                                      +  $.datepicker.formatDate('mm/yy', new Date())
                                      + "&SalesOrderNo="
                                      +  saleOrdList
                                  );

	                              Common
	                              .ajax(
	                                  "GET",
	                                  "/homecare/services/selectTotalCS.do?saleOrdIdList="
	                                      + saleOrdIdList
	                                      + "&ManuaMyBSMonth="
	                                      + $.datepicker.formatDate('mm/yy', new Date()),
	                                  "",
	                                  function(result) {
	                        	   var msg = "";
	                                  msg += '<br/> '+ result.message +' Do you sure want to manual create the order ? <br/>';
	                                  Common.confirm('Manual create CS Confirmation '
	                                                  + DEFAULT_DELIMITER
	                                                  + "<b>" + msg
	                                                  + "</b>",
	                                                          "" ,
	                                                      fn_selfClose);
	                                  });
	                          }
	                        });
	              }
	            });
	  });


  $(document).ready(
      function() {

    	    AUIGrid.setProp(myGridID, gridProsAssiin);
    	    createAssinAUIGrid(columnAssiinLayout);

    	$('#cmblistAppType').multipleSelect("checkAll");

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
                //doGetCombo('/homecare/services/getCdDeptList.do', $(
                doGetCombo('/homecare/services/getCdUpMemList.do', $(
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
                  "/homecare/services/htBasicInfoPop.do?MOD=VIEW",
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

        console.log("SalesmanCode: " + '${SESSION_INFO.memberLevel}');

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

            $("#memCode").val("${memCode}");
            $("#memCode").attr("class", "w100p readonly");
            $("#memCode").attr("readonly", "readonly");

            $("#listSalesmanCode").val(salesmanCode);
            $("#listSalesmanCode").attr("readonly", true);
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


  function fn_cMyBSMonth(field) {
    $("#" + field + "").val("");
  }

  function fn_checkRadioButton(objName) {

	    if (document.searchForm.elements['searchDivCd'][0].checked == true) {
	      var divhsManuaObj = document.querySelector("#hsManua");
	      divhsManuaObj.style.display = "none";
	      $('#hSConfiguration').attr('disabled', true); //hSConfiguration 버튼 비활성화

	      var divhsManagementObj = document.querySelector("#hsManagement");
	      divhsManagementObj.style.display = "block";

	      //$('#hSConfiguration').attr('disabled',true);
	      //$('#hSConfiguration').attr('disabled',false);
	      //

	      //2번영역 데이터 클리어
	      //fn_checkboxChangeHandler();
	      fn_destroyGridA();

	      //myGridID = GridCommon.createAUIGrid("grid_wrap", columnAssiinLayout ,gridProsAssiin);
	      //createAssinAUIGrid(columnAssiinLayout);
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
	      $("#manuaOrderNo").val('');

	      //fn_checkboxChangeHandler();
	      fn_destroyGridM();
	      //myGridID = GridCommon.createAUIGrid("grid_wrap", columnManualLayout ,gridProsManual);

	    }
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
       <li><p class="btn_blue">
       <a href="#" onclick="javascript:fn_htChange();" id="htChange">Assign
        HT Member</a>
      </p></li>
      <li><p class="btn_blue">
       <a href="#" onclick="javascript:fn_htMultipleChange();" id="htMultipleChange">Assign
        HT Member (Group)</a>
      </p></li>
     <li><p class="btn_blue">
       <a href="#" onclick="javascript:fn_getHSAddListAjax();"
        id="addResult">Add CS Result</a>
      </p></li>
     <li><p class="btn_blue">
       <a id="hSConfiguration" >Create CS
        Order</a>
      </p></li>
      </c:if>
           <li><p class="btn_blue">
       <a href="#" onclick="javascript:fn_getBSListAjax();"><span
        class="search"></span>
       <spring:message code='sys.btn.search' /></a>
      </p></li>

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
         <th scope="row">HT Branch</th>
         <td><select id="cmdBranchCode" name="cmdBranchCode"
          class="w100p readOnly ">
           <option value="">Choose One</option>
           <c:forEach var="list" items="${branchList }"
            varStatus="status">
            <option value="${list.codeId}">${list.codeName}</option>
           </c:forEach>
         </select></td>
         <th scope="row">HT Manager</th>
         <td><select id="cmdCdManager" name="cmdCdManager" class="w100p">
         </select></td>
         <th scope="row">Assign HT</th>
         <td><input id="txtAssigncodyCode" name="txtAssigncodyCode"
          type="text" title="" placeholder="HT" class="w100p" /> <!-- By Kv - Change cmbBox to text Box -->
          <!-- <select class="w100p" id="cmdcodyCode" name="cmdcodyCode" > -->
          <!-- <option value="">cody</option> --></td>
         <th scope="row">Complete HT</th>
         <td><input id="txtComcodyCode" name="txtComcodyCode"
          type="text" title="" placeholder="HT" class="w100p" /></td>
        </tr>
        <tr>
         <th scope="row">HCS Order</th>
         <td><input id="txtHsOrderNo" name="txtHsOrderNo"
          type="text" title="" placeholder="HCS Order" class="w100p" />
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
           <option value="">CS Status</option>
           </select></td>
         <th scope="row">Customer ID</th>
         <td><input id="txtCustomer" name="txtCustomer" type="text"
          title="" placeholder="Customer ID" class="w100p" /></td>
        </tr>

        <tr>
         <th scope="row">Care Service Order</th>
         <td><input id="txtSalesOrder" name="txtSalesOrder"
          type="text" title="" placeholder="CS Order" class="w100p" />
         </td>




         <th scope="row"><spring:message code='sales.AppType2'/></th>
      <td><select class="multy_select w100p" multiple="multiple"
       id="cmblistAppType" name="cmblistAppType">
         <option value="3216">CS 1-Time</option>
        <option value="3217">CS 1-Year</option>
        <option value="5701">FT 1-Time</option>
        <option value="5702">FT 1-Year</option>
        <option value="66">Rental</option>
        <option value="67">Outright</option>
        <option value="68">Installment</option>
      </select></td>
      <th scope="row"></th>
      <td></td>
      <th scope="row"></th>
<td></td>
        </tr>
        <th scope="row">Org. Code</th>
         <td><input id="orgCode" name="orgCode" type="text"
          title="" placeholder="Org. Code" class="w100p" /></td>
          <th scope="row">Grp. Code</th>
         <td><input id="grpCode" name="grpCode" type="text"
          title="" placeholder="Grp. Code" class="w100p" /></td>
          <th scope="row">Dept. Code</th>
         <td><input id="deptCode" name="deptCode" type="text"
          title="" placeholder="Dept. Code" class="w100p" /></td>
        <th scope="row"></th>
<td></td>
       </tbody>
      </table>
      <!-- table end -->
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

          <li><p class="link_btn type2">
             <a href="#" onclick="javascript:fn_hsSummary()">CS
              Summary Listing</a>
            </p></li>
           <li><p class="link_btn type2">
             <a href="#" onclick="javascript:fn_hsReportSingle()">CS
              Report(Single)</a>
            </p></li>

          <c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
              <li><p class="link_btn type2">
             <a href="#" onclick="javascript:fn_hsReportGroup()">CS
              Report(Group)</a>
            </p></li>
          </c:if>
              <c:if test="${PAGE_AUTH.funcUserDefine3 == 'Y'}">

             </c:if>

         </ul>
         <!--
           <ul class="btns">
             <li><p class="link_btn"><a href="#">menu1</a></p></li>
             <li><p class="link_btn"><a href="#">menu2</a></p></li>
             <li><p class="link_btn"><a href="#">menu3</a></p></li>
             <li><p class="link_btn"><a href="#">menu4</a></p></li>
             <li><p class="link_btn"><a href="#">Search Payment</a></p></li>
             <li><p class="link_btn"><a href="#">menu6</a></p></li>
             <li><p class="link_btn"><a href="#">menu7</a></p></li>
             <li><p class="link_btn"><a href="#">menu8</a></p></li>
           </ul>
           <ul class="btns">
           </ul>
         -->
         <p class="hide_btn">
          <a href="#"><img
           src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif"
           alt="hide" /></a>
         </p>
        </dd>
       </dl>
      </aside>
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
         <th scope="row">Care Service Order</th>
         <td><input id="ManuaSalesOrder" name="ManuaSalesOrder"
          type="text" title="" placeholder="CS Order" class="w100p" />
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
        <th scope="row">Sales Order No</th>
         <td><input id="manuaOrderNo" name="manuaOrderNo"
          type="text" title="" placeholder="Sales Order" class="w100p" />
         </td>

         <th scope="row">Branch<span class="must">*</span></th>
         <td><select id="cmdBranchCode1" name="cmdBranchCode1"
          class="w100p">
           <option value="">Choose One</option>
           <c:forEach var="list" items="${branchList }"
            varStatus="status">
            <option value="${list.codeId}">${list.codeName}</option>
           </c:forEach>
         </select></td>
         <th scope="row">HT Manager</th>
         <td ><select id="cmdCdManager1"
          name="cmdCdManager1" class=""></select></td>
        </tr>
       </tbody>
      </table>
      <!-- table end -->
      <aside class="link_btns_wrap">
       <!-- link_btns_wrap start -->
       <%-- <p class="show_btn"><a href="#"><br><br><br><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p> --%>
       <%-- <p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p> --%>
       <p class="show_btn">
        <a href="#"><img
         src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif"
         alt="link show" /></a>
       </p>
       <dl class="link_list">
        <dt>Link</dt>
        <dd>
         <ul class="btns">
         </ul>
         <ul class="btns">
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
     </form>
    </section>
    <!-- search_table end -->
   </form>
  </div>
  <table class="type1">
   <!-- table start -->
   <tbody>
    <tr>
     <td><label><input type="radio" name="searchDivCd"
       value="1" onClick="fn_checkRadioButton('comm_stat_flag')" checked />CS
       Order Search</label> <label><input type="radio"
       name="searchDivCd" value="2"
       onClick="fn_checkRadioButton('comm_stat_flag')" />Manual CS</label></td>
    </tr>
   </tbody>
  </table>
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
<!--
<div class="popup_wrap" id="confiopenwindow" style="display:none">popup_wrap start
  <header class="pop_header">pop_header start
    <section id="content">content start
      <ul class="path">
        <li><img src="../images/common/path_home.gif" alt="Home" /></li>
        <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
      </ul>
  </header>pop_header end
  <aside class="title_line">title_line start
  <p class="fav"><a href="#" class="click_add_on">My menu</a></p>
  <h2>BS Management</h2>
  </aside>title_line end
    <div class="divine_auto">divine_auto start
      <div style="width:20%;">
        <aside class="title_line">title_line start
        <h3>Cody List</h3>
        </aside>title_line end
        <div class="border_box" style="height:400px">border_box start
          <ul class="right_btns">
            <li><p class="btn_grid"><a href="#">EDIT</a></p></li>
            <li><p class="btn_grid"><a href="#">NEW</a></p></li>
          </ul>
        <article class="grid_wrap">grid_wrap start
        </article>grid_wrap end
      </div>border_box end
    </div>

    <div style="width:50%;">
      <aside class="title_line">title_line start
      <h3>HS Order List</h3>
      </aside>title_line end
        <div class="border_box" style="height:400px">border_box start
          <ul class="right_btns">
            <li><p class="btn_grid"><a href="#">EDIT</a></p></li>
            <li><p class="btn_grid"><a href="#">NEW</a></p></li>
          </ul>
        <article class="grid_wrap">grid_wrap start
        </article>grid_wrap end
        <ul class="center_btns">
          <li><p class="btn_blue2"><a href="#">Assign Cody Change</a></p></li>
          <li><p class="btn_blue2"><a href="#">Cody Assign</a></p></li>
          <li><p class="btn_blue2"><a href="#">HS Transfer</a></p></li>
        </ul>
      </div>border_box end
    </div>

    <div style="width:30%;">
      <aside class="title_line">title_line start
      <h3>Cody – HS Order</h3>
      </aside>title_line end
        <div class="border_box" style="height:400px">border_box start
          <ul class="right_btns">
            <li><p class="btn_grid"><a href="#">EDIT</a></p></li>
            <li><p class="btn_grid"><a href="#">NEW</a></p></li>
          </ul>
          <article class="grid_wrap">grid_wrap start
          </article>grid_wrap end
          <ul class="center_btns">
            <li><p class="btn_blue2"><a href="#">Confirm</a></p></li>
          </ul>
        </div>border_box end
      </div>
    </div>divine_auto end
  </section>content end
</div>
-->