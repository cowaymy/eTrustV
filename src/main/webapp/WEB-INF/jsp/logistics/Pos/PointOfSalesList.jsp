<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<!--
 DATE        BY     VERSION        REMARK
 ----------------------------------------------------------------
 09/10/2019  ONGHC  1.0.0          AMEND FOR LATEST CHANGES
 -->

<style type="text/css">

/* Define Custom Column Styles */
.aui-grid-user-custom-left {
  text-align: left;
}

/* Custom disable style */
.mycustom-disable-color {
  color: #cccccc;
}

/* Create a row selector on grid over time */
.aui-grid-body-panel table tr:hover {
  background: #D9E5FF;
  color: #000;
}

.aui-grid-main-panel .aui-grid-body-panel table tr td:hover {
  background: #D9E5FF;
  color: #000;
}

.my-row-style {
  background: #9FC93C;
  font-weight: bold;
  color: #22741C;
}
</style>

<script type="text/javascript"
 src="${pageContext.request.contextPath}/resources/js/jquery.blockUI.min.js"></script>
<script type="text/javaScript" language="javascript">
  var listGrid;
  var subGrid;
  var serialChkfalg;
  var decedata = [ {
    "code" : "H",
    "codeName" : "Credit"
  }, {
    "code" : "S",
    "codeName" : "Debit"
  } ];
  var comboDatas = [ {
    "codeId" : "OI",
    "codeName" : "OH_GI"
  }, {
    "codeId" : "OG",
    "codeName" : "OH_GR"
  } ];

  var otherType;
  var rescolumnLayout = [
      {
        dataField : "rnum",
        headerText : "<spring:message code='log.head.rownum'/>",
        width : 120,
        height : 30,
        visible : false
      }, {
        dataField : "status",
        headerText : "<spring:message code='log.head.status'/>",
        width : 100,
        height : 30,
        visible : false
      }, {
        dataField : "reqstFile",
        headerText : "<spring:message code='pay.head.fileID'/>",
        width : 100,
        height : 30,
        visible : false
      }, {
        dataField : "undefined",
        headerText : "<spring:message code='log.label.atchmnt'/>",
        width : 150,
        renderer : {
          type : "ButtonRenderer",
          labelText : "<spring:message code='pay.btn.download'/>",
          onclick : function(rowIndex, columnIndex, value, item) {
            var reqstFile = AUIGrid.getCellValue(listGrid, rowIndex, "reqstFile");
            if (reqstFile == "" || reqstFile == null) {
                Common.alert('There are no file to download.');
                return false;
              }
              var data = {
                atchFileGrpId : reqstFile
              };

              Common.ajax("GET", "/logistics/pos/getAttch.do", data, function(result) {
                if (result != null) {
                  var fileSubPath = result.fileSubPath;
                  fileSubPath = fileSubPath.replace('\', '/'');
                  window.open("/file/fileDownWeb.do?subPath=" + fileSubPath
                      + "&fileName=" + result.physiclFileName + "&orignlFileNm=" + result.atchFileName);
                } else {
                  Common.alert('There are no file to download.');
                  return false;
                }
              });
          }
        }
      }, {
        dataField : "reqstno",
        headerText : "<spring:message code='log.title.othRqst'/>",
        width : 150,
        height : 30
      }, {
        dataField : "ttext",
        headerText : "<spring:message code='log.head.transactiontypetext'/>",
        width : 120,
        height : 30,
        visible : false
      }, {
        dataField : "mtext",
        headerText : "<spring:message code='log.head.movementtype'/>",
        width : 160,
        height : 30
      }, {
        dataField : "adjrsn",
        headerText : "<spring:message code='log.label.adjRsn'/>",
        width : 300,
        height : 30
      }, {
        dataField : "staname",
        headerText : "<spring:message code='log.head.status'/>",
        width : 100,
        height : 30
      }, {
        dataField : "reqitmno",
        headerText : "<spring:message code='log.head.stockmovementrequestitem'/>",
        width : 120,
        height : 30,
        visible : false
      }, {
        dataField : "ttype",
        headerText : "<spring:message code='log.head.transactiontype'/>",
        width : 120,
        height : 30,
        visible : false
      }, {
        dataField : "mtype",
        headerText : "<spring:message code='log.head.movementtype'/>",
        width : 120,
        height : 30,
        visible : false
      }, {
        dataField : "froncy",
        headerText : "<spring:message code='log.head.auto/manual'/>",
        width : 120,
        height : 30,
        visible : false
      }, {
        dataField : "reqdt",
        headerText : "Reqst. Require Date",
        width : 150,
        height : 30
      }, {
        dataField : "crtdt",
        headerText : "Reqst. Create Date",
        width : 150,
        height : 30
      }, {
        dataField : "rcvloc",
        headerText : "<spring:message code='log.head.fromlocation'/>",
        width : 150,
        height : 30
      }, {
        dataField : "rcvlocnm",
        headerText : "<spring:message code='log.head.fromlocation'/>",
        width : 120,
        height : 30,
        visible : false
      }, {
        dataField : "reqloc",
        headerText : "<spring:message code='log.label.rqstlct'/>",
        width : 200,
        height : 30
      }, {
        dataField : "reqlocnm",
        headerText : "<spring:message code='log.head.tolocation'/>",
        width : 120,
        height : 30,
        visible : false
      }, {
        dataField : "itmcd",
        headerText : "<spring:message code='log.head.matcode'/>",
        width : 120,
        height : 30,
        visible : true
      }, {
        dataField : "itmname",
        headerText : "<spring:message code='log.head.matNm'/>",
        width : 250,
        height : 30
      }, {
        dataField : "reqstqty",
        headerText : "<spring:message code='log.head.reqqty'/>",
        width : 100,
        height : 30
      }, {
        dataField : "rciptqty",
        headerText : "<spring:message code='log.head.remainqty'/>",
        width : 100,
        height : 30
      }, {
        dataField : "delvno",
        headerText : "<spring:message code='log.head.delvno'/>",
        width : 120,
        height : 30,
        visible : false
      }, {
        dataField : "delyqty",
        headerText : "<spring:message code='log.head.delvno'/>",
        width : 120,
        height : 30,
        visible : false
      }, {
        dataField : "greceipt",
        headerText : "<spring:message code='log.head.goodreceipt'/>",
        width : 120,
        height : 30,
        visible : false
      }, {
        dataField : "uom",
        headerText : "<spring:message code='log.head.unitofmeasure'/>",
        width : 120,
        height : 30,
        visible : false
      }, {
        dataField : "serialChk",
        headerText : "Serial Check",
        width : 100,
        height : 30
      }, {
        dataField : "serialRequireChkYn",
        headerText : "Serial Require Check Y/N",
        width : 180,
        height : 30
     }, {
        dataField : "uomnm",
        headerText : "<spring:message code='log.head.uom'/>",
        width : 100,
        height : 30
      }, {
        dataField : "reqstRem",
        headerText : "<spring:message code='log.label.rmk'/>",
        width : 120,
        height : 30,
      }, {
        dataField : "crtUsr",
        headerText : "<spring:message code='log.head.createuser'/>",
        width : 120,
        height : 30,
      }, {
          dataField : "reqstCdcRdc",
          headerText : "reqstCdcRdc",
          width : 120,
          height : 30,
          visible : false
      }
      ];

  var mtrcolumnLayout = [
      {
        dataField : "matrlDocNo",
        headerText : "<spring:message code='log.label.matDocNo'/>",
        width : 200,
        height : 30
      },
      {
        dataField : "matrlDocItm",
        headerText : "<spring:message code='log.label.matDocItm'/>",
        width : 100,
        height : 30
      },
      {
        dataField : "invntryMovType",
        headerText : "<spring:message code='log.label.mvtTyp'/>",
        width : 100,
        height : 30
      },
      {
        dataField : "movtype",
        headerText : "<spring:message code='log.label.mvtTypDesc'/>",
        width : 120,
        height : 30
      },
      {
        dataField : "reqStorgNm",
        headerText : "<spring:message code='log.label.rqstlct'/>",
        width : 150,
        height : 30
      },
      {
        dataField : "matrlNo",
        headerText : "<spring:message code='log.head.matcode'/>",
        width : 120,
        height : 30
      },
      {
        dataField : "stkDesc",
        headerText : "<spring:message code='log.label.mtrlNm'/>",
        width : 300,
        height : 30
      },
      {
        dataField : "debtCrditIndict",
        headerText : "<spring:message code='log.head.debit/credit'/>",
        width : 120,
        height : 30,
        labelFunction : function(rowIndex, columnIndex, value,
            headerText, item) {

          var retStr = "";

          for (var i = 0, len = decedata.length; i < len; i++) {

            if (decedata[i]["code"] == value) {
              retStr = decedata[i]["codeName"];
              break;
            }
          }
          return retStr == "" ? value : retStr;
        },
        editRenderer : {
          type : "ComboBoxRenderer",
          showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 보이기
          list : decedata,
          keyField : "code",
          valueField : "code"
        }

      }, {
        dataField : "autoCrtItm",
        headerText : "<spring:message code='log.label.auto'/>",
        width : 100,
        height : 30
      }, {
        dataField : "qty",
        headerText : "<spring:message code='log.head.qty'/>",
        width : 120,
        height : 30
      }, {
        dataField : "trantype",
        headerText : "<spring:message code='log.label.trxTyp'/>",
        width : 120,
        height : 30
      }, {
        dataField : "postingdate",
        headerText : "<spring:message code='log.label.postDt'/>",
        width : 120,
        height : 30
      }, {
        dataField : "codeName",
        headerText : "<spring:message code='log.head.uom'/>",
        width : 120,
        height : 30
      } ];

  var serialcolumn = [ {
    dataField : "itmcd",
    headerText : "<spring:message code='log.head.materialcode'/>",
    width : "20%",
    height : 30
  }, {
    dataField : "itmname",
    headerText : "<spring:message code='log.head.materialname'/>",
    width : "25%",
    height : 30
  }, {
    dataField : "serial",
    headerText : "<spring:message code='log.head.serial'/>",
    width : "30%",
    height : 30,
    editable : true
  }, {
    dataField : "cnt61",
    headerText : "<spring:message code='log.head.serial'/>",
    width : "30%",
    height : 30,
    visible : false
  }, {
    dataField : "cnt62",
    headerText : "<spring:message code='log.head.serial'/>",
    width : "30%",
    height : 30,
    visible : false
  }, {
    dataField : "cnt63",
    headerText : "<spring:message code='log.head.serial'/>",
    width : "30%",
    height : 30,
    visible : false
  }, {
    dataField : "statustype",
    headerText : "<spring:message code='log.head.status'/>",
    width : "30%",
    height : 30,
    visible : false
  } ];

  var options = {
    usePaging : false,
    editable : false,
    useGroupingPanel : false,
    showStateColumn : false
  };

  var resop = {
    rowIdField : "rnum",
    editable : false,
    fixedColumnCount : 10,
    // groupingFields : ["reqstno"],
    displayTreeOpen : false,
    showRowCheckColumn : true,
    showStateColumn : false,
    showRowAllCheckBox : true,
    showBranchOnGrouping : false
  };

  var serialop = {
    //rowIdField : "rnum",
    editable : true
    //displayTreeOpen : true,
    //showRowCheckColumn : true ,
    //enableCellMerge : true,
    //showStateColumn : false,
    //showBranchOnGrouping : false
  };

  //var paramdata;

  $(document).ready(
    function() {
      /**********************************
       * Header Setting
       **********************************/
      doGetComboData('/common/selectCodeList.do', { groupCode : '309' }, 'O', 'searchStatus', 'S', '');
      /* doGetCombo('/common/selectStockLocationList.do', '', '','searchLoc', 'S' , ''); */
      // var paramdata = { groupCode : '308' , orderValue : 'CODE_NAME' , likeValue:'OH'};
      // doGetComboData('/logistics/pos/selectTypeList.do', paramdata, '','searchReqType', 'S' , '');
      //doGetComboData('/common/selectCodeList.do', paramdata, '','searchReqType', 'S' , '');
      //doDefCombo(comboDatas, '', 'searchTransType', 'S', '');

      var today = new Date();
      var dd = today.getDate();
      var mm = today.getMonth() + 1;
      var yyyy = today.getFullYear();

      //if (dd < 10) {
        //dd = '0' + dd;
      //}
      dd = "01";

      if (mm < 10) {
        mm = '0' + mm;
      }

      $("#reqsdt").val(dd + '/' + mm + '/' + yyyy);

      var today2 = new Date();
      today2.setDate(today2.getDate() + 6);
      var dd2 = today2.getDate();
      var mm2 = today2.getMonth() + 1;
      var yyyy2 = today2.getFullYear();

      if (dd2 < 10) {
        dd2 = '0' + dd2;
      }

      if (mm2 < 10) {
        mm2 = '0' + mm2;
      }

      $("#reqedt").val(dd2 + '/' + mm2 + '/' + yyyy2);

      /**********************************
       * Header Setting End
       ***********************************/

      //listGrid = AUIGrid.create("#main_grid_wrap", rescolumnLayout, subgridpros);
      listGrid = AUIGrid.create("#main_grid_wrap", rescolumnLayout, resop);
      mdcGrid = GridCommon.createAUIGrid("#mdc_grid", mtrcolumnLayout, "", options);
      serialGrid = AUIGrid.create("#serial_grid_wrap", serialcolumn, serialop);
      $("#mdc_grid").hide();

      AUIGrid.bind(listGrid, "cellDoubleClick", function(event) {

        $("#rStcode").val(AUIGrid.getCellValue(listGrid, event.rowIndex, "reqstno"));
        document.searchForm.action = '/logistics/pos/PosView.do';
        document.searchForm.submit();
      });

      AUIGrid.bind(listGrid, "cellClick", function(event) {

        $("#mdc_grid").hide();

        if (event.dataField == "reqstno") {
          SearchMaterialDocListAjax(event.value)
        }
      });

      AUIGrid.bind(listGrid, "ready", function(event) {
      });

      AUIGrid.bind(listGrid, "rowCheckClick", function(event) {
        var reqno = AUIGrid.getCellValue(listGrid, event.rowIndex, "reqstno");

    	if (AUIGrid.isCheckedRowById(listGrid, event.item.rnum)) {
          AUIGrid.addCheckedRowsByValue(listGrid, "reqstno", reqno);
        } else {
          var rown = AUIGrid.getRowIndexesByValue(listGrid, "reqstno", reqno);
          for (var i = 0; i < rown.length; i++) {
            AUIGrid.addUncheckedRowsByIds(listGrid, AUIGrid.getCellValue(listGrid, rown[i], "rnum"));
          }
        }

    	// KR-OHK Serial Require Check add start
        var checked = AUIGrid.getCheckedRowItems(listGrid);
        for (var i = 0; i < checked.length; i++) {
             if(checked[i].item.serialRequireChkYn !=event.item.serialRequireChkYn){
                 Common.alert("'Serial Require Check Y/N' is different.");
                 var rown = AUIGrid.getRowIndexesByValue(listGrid, "reqstno" , reqno);
                 for (var i = 0 ; i < rown.length ; i++){
                     AUIGrid.addUncheckedRowsByIds(listGrid, AUIGrid.getCellValue(listGrid, rown[i], "rnum"));
                 }
                 return false;
             }
        }
        // KR-OHK Serial Require Check add end
      });

      AUIGrid.bind(serialGrid, "cellEditEnd",
        function(event) {
          var tvalue = true;
          var serial = AUIGrid.getCellValue(serialGrid, event.rowIndex, "serial");
          serial = serial.trim();

          if ("" == serial || null == serial) {
            //alert(" ( " + event.rowIndex + ", " + event.columnIndex + ") : clicked!!");
            //AUIGrid.setSelectionByIndex(serialGrid,event.rowIndex, event.columnIndex);
            Common.alert('Please input Serial Number.');
            return false;
          } else {
            for (var i = 0; i < AUIGrid.getRowCount(serialGrid); i++) {
              if (event.rowIndex != i) {
                if (serial == AUIGrid.getCellValue(serialGrid, i, "serial")) {
                  tvalue = false;
                  break;
                }
              }
            }

            if (tvalue) {
              fn_serialChck(event.rowIndex, event.item, serial)
            } else {
              AUIGrid.setCellValue(serialGrid, event.rowIndex, "statustype", 'N');
              AUIGrid.setProp(serialGrid, "rowStyleFunction", function(rowIndex, item) {
                if (item.statustype == 'N') {
                  return "my-row-style";
                }
              });
              AUIGrid.update(serialGrid);
            }

            if ($("#serialqty").val() > AUIGrid.getRowCount(serialGrid)) {
              f_addrow();
              //      var serialstus=$("#serialstus").val();
              //      if($("#serialstus").val() =="Y"){
              //         f_addrow();
              //         }
            }
          }
        });
    });

    // BUTTON CLICK EVENT
    $(function() {
      // SEARCH BUTTON
      $('#search').click(function() {
        if (valiedcheck('search')) {
          SearchListAjax();
        }
      });

      // DOWNLOAD BUTTTON
      $("#download").click(
        function() {
          GridCommon.exportTo("main_grid_wrap", 'xlsx', "Other GI/GR Request List");
        });

      $("#download2").click(
        function() {
          GridCommon.exportTo("mdc_grid", 'xlsx', "Material Document Listing");
        });

      // ADJUSTMENT NOTE BUTTTON
      $("#adjNote").click(
        function() {
            var checkedItems = AUIGrid.getCheckedRowItems(listGrid);
            if (checkedItems.length <= 0) {
              Common.alert("<spring:message code='service.msg.NoRcd'/>");
              return false;
            } else {
              /*if (checkedItems.length > 1) {
                Common.alert("<spring:message code='service.msg.onlyPlz'/>");
                return false;
              }*/
              var param = "";
              for (var i = 0; i < checkedItems.length; i++) {
                if (i == 0) {
                  param = "'" + checkedItems[i].item.reqstno + "'";
                } else {
                  param = param + ", '" + checkedItems[i].item.reqstno + "'";
                }
              }

              var date = new Date();
              var month = date.getMonth() + 1;
              var day = date.getDate();
              if (date.getDate() < 10) {
                day = "0" + date.getDate();
              }

              $("#searchForm #V_REQNO").val(param);
              $("#searchForm #reportFileName").val('/logistics/AdjustmentNoteRpt.rpt');
              $("#searchForm #viewType").val("PDF");
              $("#searchForm #reportDownFileName").val("AdjustmentNote_" + day + month + date.getFullYear());

              var option = {
                isProcedure : false, // procedure 로 구성된 리포트 인경우 필수.
              };

              Common.report("searchForm", option);
            }
        });


      // NEW BUTTON
      $('#insert').click(function() {
        document.searchForm.action = '/logistics/pos/PosOfSalesIns.do';
        document.searchForm.submit();
      });

      // GI/GR BUTTON
      $("#goodIssue").click(function() {
        $("#giForm")[0].reset();
        var checkedItems = AUIGrid.getCheckedRowItems(listGrid);
        if (checkedItems.length <= 0) {
          Common.alert("<spring:message code='service.msg.NoRcd'/>");
          return false;
        } else {
          otherType = "GI";
          for (var i = 0; i < checkedItems.length; i++) {
            if (checkedItems[i].item.status != 'O') {
              Common.alert("<spring:message code='log.msg.rcdPrc'/>");
              return false;
              break;
            } else if (checkedItems[i].item.status == 'C') {
              Common.alert("<spring:message code='log.msg.rcdPrcCom'/>");
              return false;
              break;
            }

            // KR-OHK Serial check add
            if (checkedItems[i].item.reqstqty == 0) {
            	Common.alert("Req Qty is zero.<br/>Please scan the serial on the detail page.");
            	return false;
            }
          }

          for (var i = 0; i < checkedItems.length; i++) {
            if (checkedItems[i].item.serialChk == 'Y') {
              serialChkfalg = "Y";
              break;
            } else {
              serialChkfalg = "N";
            }
          }

          // 2018.01.01 김덕호 요청사항
          // serial check 강제 처리
          serialChkfalg = "N";

          if (serialChkfalg == "Y") {
            document.giForm.gitype.value = "GI";
            $("#dataTitle").text("GI/GR");
            $("#giptdate").val("");
            $("#gipfdate").val("");
            $("#doctext").val("");
            doSysdate(0, 'giptdate');
            doSysdate(0, 'gipfdate');
            $("#giopenwindow").show();
            $("#serial_grid_wrap").show();
            AUIGrid.clearGridData(serialGrid);
            AUIGrid.resize(serialGrid);
            fn_itemSerialPopList(checkedItems);
          } else {
            document.giForm.gitype.value = "GI"
            $("#dataTitle").text("GI/GR");
            $("#giptdate").val("");
            $("#gipfdate").val("");
            $("#doctext").val("");
            doSysdate(0, 'giptdate');
            doSysdate(0, 'gipfdate');
            $("#giopenwindow").show();
            $("#serial_grid_wrap").hide();
          }

          // document.giForm.gitype.value="GI";
          // $("#dataTitle").text("Good Issue Posting Data");
          // $("#giptdate").val("");
          // $("#gipfdate").val("");
          // $("#doctext").val("");
          // doSysdate(0, 'giptdate');
          // doSysdate(0, 'gipfdate');
          // $("#giopenwindow").show();
        }
      });

      //GI/GR CANCEL BUTTON
      $("#issueCancel").click(function() {
        var checkedItems = AUIGrid.getCheckedRowItems(listGrid);
        if (checkedItems.length <= 0) {
          Common.alert("<spring:message code='service.msg.NoRcd'/>");
          return false;
        } else {
          otherType = "GC";
          for (var i = 0; i < checkedItems.length; i++) {
            if (checkedItems[i].item.status == 'O') {
              Common.alert("<spring:message code='log.msg.rcdPrcFail'/>");
              return false;
              break;
            }
          }

          document.giForm.gitype.value = "GC";
          $("#dataTitle").text("GI/GR Cancel");
          $("#giptdate").val("");
          $("#gipfdate").val("");
          $("#doctext").val("");
          doSysdate(0, 'giptdate');
          doSysdate(0, 'gipfdate');
          $("#giopenwindow").show();
          AUIGrid.clearGridData(serialGrid);
          AUIGrid.resize(serialGrid);
          $("#serial_grid_wrap").hide();
        }
      });

      // REQUEST LOCATION PRESS
      $("#tlocationnm").keypress(
        function(event) {
          $('#tlocation').val('');
          if (event.which == '13') {
            $("#stype").val('tlocation');
            $("#svalue").val($('#tlocationnm').val());
            $("#sUrl").val("/logistics/organization/locationCdSearch.do");

            Common.searchpopupWin("searchForm", "/common/searchPopList.do", "location");
          }
        });

      // CLEAR BUTTON
      $("#clear").click(
        function() {
          doGetComboData('/common/selectCodeList.do', { groupCode : '309' }, 'O', 'searchStatus', 'S', '');
          var paramdata = {
            groupCode : '308',
            orderValue : 'CODE_NAME',
            likeValue : 'OH'
          };
          doGetComboData('/logistics/pos/selectTypeList.do', paramdata, '', 'searchReqType', 'S', '');
          $("#searchOthersReq1").val('');
          $("#tlocationnm").val('');
          $("#tlocation").val('');
          $("#flocationnm").val('');
          $("#flocation").val('');
          $("#crtsdt").val('');
          $("#crtedt").val('');
          $("#reqsdt").val('');
          $("#reqedt").val('');
          $("#searchReqType").val('');
          $("#searchTransType").val('');
          $("#tlocationGrd").val('');
          $("#tlocationGrdNm").val('');
        });

      // ONCHANGE TRANSACTION TYPE
      $("#searchTransType").change(
        function() {
          var paramdata = {
            groupCode : '308',
            orderValue : 'CODE_NAME',
            likeValue : $("#searchTransType").val()
          };
          doGetComboData('/logistics/pos/selectTypeList.do', paramdata, '', 'searchReqType', 'S', '');
        });

      // DELETE BUTTON
      $('#delete').click(
        function() {
          var checkedItems = AUIGrid.getCheckedRowItems(listGrid);
          if (checkedItems.length <= 0) {
            Common.alert("<spring:message code='service.msg.NoRcd'/>");
            return;
          } else {
            if (checkedItems[0].item.status != 'O') {
              Common.alert("<spring:message code='log.msg.rcdDltFail'/>");
            } else {
              var reqstono = checkedItems[0].item.reqstno;
              Common.confirm("<spring:message code='sys.common.alert.delete'/></br> <b>" + reqstono + "</b>", fn_delete);
            }
          }
        });
  });

  function fn_itempopList(data) {
    var rtnVal = data[0].item;

    if ($("#stype").val() == "flocation") {
      $("#flocation").val(rtnVal.locid);
      $("#flocationnm").val(rtnVal.locdesc);
    } else {
      $("#tlocation").val(rtnVal.locid);
      $("#tlocationnm").val(rtnVal.locdesc);
    }

    $("#svalue").val();
  }

  function SearchListAjax() {
    // if ($("#flocationnm").val() == ""){
    //   $("#flocation").val('');
    // }

    if ($("#tlocationnm").val() == "") {
      $("#tlocation").val('');
    }

    // if ($("#flocation").val() == ""){
    //   $("#flocation").val($("#flocationnm").val());
    // }

    if ($("#tlocation").val() == "") {
      $("#tlocation").val($("#tlocationnm").val());
    }

    var url = "/logistics/pos/PosSearchList.do";
    var param = $('#searchForm').serializeJSON();

    Common.ajax("POST", url, param, function(data) {
      AUIGrid.setGridData(listGrid, data.data);
    });
  }

  function GiSaveAjax() {
    var data = {};
    var checkdata = AUIGrid.getCheckedRowItems(listGrid);
    data.checked = checkdata;
    data.form = $("#giForm").serializeJSON();
    var serials = AUIGrid.getAddedRowItems(serialGrid);
    data.add = serials;

    if (serialChkfalg == 'Y' && otherType == 'GI') {
      for (var i = 0; i < AUIGrid.getRowCount(serialGrid); i++) {
        if (AUIGrid.getCellValue(serialGrid, i, "statustype") == 'N') {
          Common.alert("Please check the serial.")
          return false;
        }

        if (AUIGrid.getCellValue(serialGrid, i, "serial") == undefined || AUIGrid.getCellValue(serialGrid, i, "serial") == "undefined") {
          Common.alert("Please check the serial.")
          return false;
        }
      }

      if ($("#serialqty").val() != AUIGrid.getRowCount(serialGrid)) {
        Common.alert("Please check the serial.")
        return false;
      }
    }

    // KR-OHK Serial check add
    var serialRequireChkYn = checkdata[0].item.serialRequireChkYn;
    var url = "";

    if(serialRequireChkYn == 'Y') {
    	url = "/logistics/pos/PosGiSaveSerial.do";
    } else {
    	url = "/logistics/pos/PosGiSave.do";
    }

    Common.ajaxSync("POST", url, data, function(result) {

      if (result.data.poschk == 0) {
        Common.alert(result.message + " <br/>" + "MaterialDocumentNo : " + result.data.reVal);
      } else {
        Common.alert("<spring:message code='log.msg.rcdPrc'/>");
        return false;
      }

      // AUIGrid.resetUpdatedItems(listGrid, "all");
      $("#giptdate").val("");
      $("#gipfdate").val("");
      $("#giopenwindow").hide();
      $('#search').click();

    }, function(jqXHR, textStatus, errorThrown) {
      try {
      } catch (e) {
      }
      Common.alert("Fail : " + jqXHR.responseJSON.message);
    });
  }

  function giSave() {
    if (valiedcheck('save')) {
      GiSaveAjax();
    }
  }

  function valiedcheck(v) {
    var ReqType;
    var Location;
    var Status;
    var text;

    if (v == 'search') {
      //if ($("#searchTransType").val() == "") {
        //text = "<spring:message code='log.label.trxTyp'/>";
        //Common.alert("<spring:message code='sys.msg.necessary' arguments='" + text + "' htmlEscape='false'/>");
        //return false
      //}

      if ($("#reqsdt").val() == "" || $("#reqsdt").val() == null) {
        text = "<spring:message code='log.head.requestdate'/>";
        Common.alert("<spring:message code='sys.msg.necessary' arguments='" + text + "' htmlEscape='false'/>");
        return false;
      }

      if ($("#reqedt").val() == "" || $("#reqedt").val() == null) {
          text = "<spring:message code='log.head.requestdate'/>";
          Common.alert("<spring:message code='sys.msg.necessary' arguments='" + text + "' htmlEscape='false'/>");
        return false;
      }

      //  if ($("#searchReqType").val() == "") {
      //    ReqType = false;
      //  } else{
      //    ReqType = true;
      //  }
      //  if ($("#searchLoc").val() == "") {
      //    Location = false;
      //  } else{
      //    Location = true;
      //  }
      //  if ($("#searchStatus").val() == "") {
      //    Status = false;
      //  } else{
      //    Status = true;
      //  }

      //  if (ReqType == false && Location == false && Status == false){
      //    alert("Please select the Request Type. \nPlease select the Location.\nPlease key in the Status.");
      //    return false;
      //  }
      //  if(ReqType == true || Location == true || Status == true){
      //    return true;
      //  }

    } else if (v == 'save') {
      if ($("#giptdate").val() == "") {
        text = "<spring:message code='log.label.postDt'/>";
        Common.alert("<spring:message code='sys.msg.necessary' arguments='" + text + "' htmlEscape='false'/>");
        $("#giptdate").focus();
        return false;
      }
      if ($("#gipfdate").val() == "") {
        text = "<spring:message code='log.label.docDt'/>";
        Common.alert("<spring:message code='sys.msg.necessary' arguments='" + text + "' htmlEscape='false'/>");
        $("#gipfdate").focus();
        return false;
      }
      if ($("#doctext").val() == "") {
        text = "<spring:message code='log.label.hdrTxt'/>";
        Common.alert("<spring:message code='sys.msg.necessary' arguments='" + text + "' htmlEscape='false'/>");
        $("#doctext").focus();
        return false;
      }
    }
    return true;
  }

  function SearchMaterialDocListAjax(reqno) {
    var url = "/logistics/pos/MaterialDocumentList.do";
    var param = "reqstno=" + reqno;
    $("#mdc_grid").show();

    Common.ajax("GET", url, param, function(data) {
      //AUIGrid.resize(mdcGrid,1620,150);
      AUIGrid.resize(mdcGrid);
      AUIGrid.setGridData(mdcGrid, data.data2);
    });
  }

  function f_getTtype(g, v) {
    var rData = new Array();
    $.ajax({
      type : "GET",
      url : "/common/selectCodeList.do",
      data : {
        groupCode : g,
        orderValue : 'CRT_DT',
        likeValue : v
      },
      dataType : "json",
      contentType : "application/json;charset=UTF-8",
      async : false,
      success : function(data) {
        $.each(data, function(index, value) {
          var list = new Object();
          list.code = data[index].code;
          list.codeId = data[index].codeId;
          list.codeName = data[index].codeName;
          rData.push(list);
        });
      },
      error : function(jqXHR, textStatus, errorThrown) {
        alert("Draw ComboBox['" + obj
            + "'] is failed. \n\n Please try again.");
      },
      complete : function() {
      }
    });

    return rData;
  }

  function fn_serialChck(rowindex, rowitem, str) {
    var schk = true;
    var ichk = true;
    var slocid = '';//session.locid;
    var data = {
      serial : str,
      locid : slocid
    };
    Common.ajaxSync("GET", "/logistics/pos/PointOfSalesSerialCheck.do", data,
      function(result) {
        if (result.data[0] == null) {
          AUIGrid.setCellValue(serialGrid, rowindex, "itmcd", "");
          AUIGrid.setCellValue(serialGrid, rowindex, "itmname", "");
          AUIGrid.setCellValue(serialGrid, rowindex, "cnt61", 0);
          AUIGrid.setCellValue(serialGrid, rowindex, "cnt62", 0);
          AUIGrid.setCellValue(serialGrid, rowindex, "cnt63", 0);

          schk = false;
          ichk = false;

        } else {
          AUIGrid.setCellValue(serialGrid, rowindex, "itmcd", result.data[0].STKCODE);
          AUIGrid.setCellValue(serialGrid, rowindex, "itmname", result.data[0].STKDESC);
          AUIGrid.setCellValue(serialGrid, rowindex, "cnt61", result.data[0].L61CNT);
          AUIGrid.setCellValue(serialGrid, rowindex, "cnt62", result.data[0].L62CNT);
          AUIGrid.setCellValue(serialGrid, rowindex, "cnt63", result.data[0].L63CNT);

          if (result.data[0].L62CNT == 0) {//63제외
            schk = false;
          } else {
            schk = true;
          }

          var checkedItems = AUIGrid.getCheckedRowItemsAll(listGrid);

          for (var i = 0; i < checkedItems.length; i++) {
            if (result.data[0].STKCODE == checkedItems[i].itmcd) {
              //AUIGrid.setCellValue(serialGrid , rowindex , "statustype" , 'Y' );
              ichk = true;
              break;
            } else {
              ichk = false;
            }
          }
        }

        if (schk && ichk) {
          AUIGrid.setCellValue(serialGrid, rowindex, "statustype", 'Y');
        } else {
          AUIGrid.setCellValue(serialGrid, rowindex, "statustype", 'N');
        }

        AUIGrid.setProp(serialGrid, "rowStyleFunction", function(rowIndex, item) {
          $("#serialstus").val(item.statustype);
          if (item.statustype == 'N') {
            return "my-row-style";
          }
        });
        AUIGrid.update(serialGrid);

      }, function(jqXHR, textStatus, errorThrown) {
        try {
        } catch (e) {
        }
        Common.alert("Fail : " + jqXHR.responseJSON.message);
      });
  }

  function fn_itemSerialPopList(data) {
    //checkedItems = AUIGrid.getCheckedRowItemsAll(reqGrid);
    var rowPos = "first";
    var rowList = [];
    var reqQty;
    var item = new Object();
    var itm_qty = 0;

    for (var i = 0; i < data.length; i++) {
      if (data[i].item.serialChk == 'Y') {
        reqQty = data[i].item.reqstqty;
        itm_qty += parseInt(reqQty);
        $("#reqstno").val(data[i].item.reqstno)
      }
    }
    $("#serialqty").val(itm_qty);

    f_addrow();

  }

  function f_addrow() {
    var rowPos = "last";
    var item = new Object();
    AUIGrid.addRow(serialGrid, item, rowPos);
    return false;
  }

  function fn_delete() {
    var getCheckedRowItems = AUIGrid.getCheckedRowItems(listGrid);
    var reqstono = getCheckedRowItems[0].item.reqstno;
    //alert("reqstono ???  "+reqstono);

    // KR-OHK Serial check add
    var ttype = getCheckedRowItems[0].item.ttype;
    var locId = getCheckedRowItems[0].item.reqstCdcRdc;
    var serialRequireChkYn = getCheckedRowItems[0].item.serialRequireChkYn;

    if(serialRequireChkYn == 'Y') {
    	Common.ajax("GET", "/logistics/pos/deleteStoNoSerial.do", { "reqstono" : reqstono, "ttype" : ttype, "locId" : locId }, function(result) {
          Common.alert("" + result.message + "</br> Delete : " + reqstono, locationList);
        });
    } else {
    	fn_deleteAjax(reqstono);
    }
  }

  function fn_deleteAjax(reqstono) {
    var url = "/logistics/pos/deleteStoNo.do";
    Common.ajax("GET", url, { "reqstono" : reqstono }, function(result) {
      Common.alert("" + result.message + "</br> Delete : " + reqstono, locationList);
    });
  }

  function locationList() {
    $('#search').click();
  }

  function getAdjLoc(){
    Common.popupDiv("/logistics/pos/getAdjLoc.do", {}, null, true);
  }

  function fn_setRqstLoc(itm) {
    if (itm != null) {
      $("#tlocation").val(itm.locId);
      $("#tlocationnm").val(itm.locDesc);
      $("#tlocationGrd").val(itm.locGrade);
      $("#tlocationGrdNm").val(itm.locGrade);

     //$("#reqLoc").val(itm.locId);
    }
  }
</script>
<section id="content">
 <!-- content start -->
 <ul class="path">
  <li><img
   src="${pageContext.request.contextPath}/resources/images/common/path_home.gif"
   alt="Home" /></li>
  <li><spring:message code='log.title.log'/></li>
  <li><spring:message code='log.title.othGIGRMgmt'/></li>
 </ul>
 <aside class="title_line">
  <!-- title_line start -->
  <p class="fav">
   <a href="#" class="click_add_on">My menu</a>
  </p>
  <h2><spring:message code='log.title.othGIGRMgmt'/></h2>
 </aside>
 <!-- title_line end -->
 <aside class="title_line">
  <!-- title_line start -->
  <h3><spring:message code='log.title.hdrInfo'/></h3>
  <ul class="right_btns">
   <c:if test="${PAGE_AUTH.funcView == 'Y'}">
    <li><p class="btn_blue">
      <a id="search"><span class="search"></span><spring:message code='sys.btn.search'/></a>
     </p></li>
   </c:if>
   <li><p class="btn_blue">
     <a id="clear"><span class="clear"></span><spring:message code='sys.btn.clear'/></a>
    </p></li>
  </ul>
 </aside>
 <!-- title_line end -->
 <section class="search_table">
  <!-- search_table start -->
  <form id="searchForm" name="searchForm" method="post" onsubmit="return false;">
   <input type="hidden" name="rStcode" id="rStcode" />
   <input type="hidden" id="svalue" name="svalue" />
   <input type="hidden" id="sUrl" name="sUrl" />
   <input type="hidden" id="stype" name="stype" />
   <input type="hidden" id="reportFileName" name="reportFileName" />
   <input type="hidden" id="viewType" name="viewType" />
   <input type="hidden" id="reportDownFileName" name="reportDownFileName" value="DOWN_FILE_NAME" />
   <input type="hidden" id="V_REQNO" name="V_REQNO" />

   <table class="type1">
    <!-- table start -->
    <caption>search table</caption>
    <colgroup>
     <col style="width: 140px" />
     <col style="width: *" />
     <col style="width: 140px" />
     <col style="width: *" />
    </colgroup>
    <tbody>
     <tr>
      <th scope="row"><spring:message code='log.title.othRqst'/></th>
      <td><input type="text" class="w100p" id="searchOthersReq1" name="searchOthersReq1" /></td>
      <th scope="row"><spring:message code='log.head.status'/></th>
      <td><select class="w100p" id="searchStatus" name="searchStatus"></select></td>
     </tr>
     <tr>
      <th scope="row"><spring:message code='log.label.trxTyp'/><span class="must">*</span></th>
      <td>
       <select class="w100p" id="searchTransType" name="searchTransType">
        <option value=''><spring:message code='sal.combo.text.chooseOne'/></option>
        <c:forEach var="list" items="${trxTyp}" varStatus="status">
         <option value="${list.codeId}">${list.codeName}</option>
        </c:forEach>
       </select>
      </td>
      <th scope="row"><spring:message code='log.head.movementtype'/></th>
      <td>
       <select class="w100p" id="searchReqType" name="searchReqType">
        <option value=''><spring:message code='sal.combo.text.chooseOne'/></option>
       </select>
      </td>
     </tr>
     <tr>
      <th scope="row"><spring:message code='log.label.rqstlct'/></th>
      <td>
       <!-- <select class="w100p" id="searchLoc" name="searchLoc"></select> -->
       <input type="hidden" id="tlocation" name="tlocation">
       <p class="w100p">
         <input type="text" id="tlocationnm" name="tlocationnm" disabled style="width:95%">
         <a id="src" name="src" onclick="getAdjLoc()"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search"/></a>
       </p>
      </td>
      <th scope="row"><spring:message code='log.label.lctTyp'/></th>
      <td>
       <input type="hidden" id="tlocationGrd" name="tlocationGrd">
       <input type="text" class="w100p" id="tlocationGrdNm" name="tlocationGrdNm" disabled>

      </td>
     </tr>
     <tr>
      <th scope="row"><spring:message code='log.head.createdate'/></th>
      <td>
       <div class="date_set w100p">
        <!-- date_set start -->
        <p>
         <input id="crtsdt" name="crtsdt" type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date">
        </p>
        <span> <spring:message code='budget.To'/> </span>
        <p>
         <input id="crtedt" name="crtedt" type="text"
          title="Create End Date" placeholder="DD/MM/YYYY"
          class="j_date">
        </p>
       </div>
       <!-- date_set end -->
      </td>
      <th scope="row"><spring:message code='log.head.requestdate'/></th>
      <td>
       <div class="date_set w100p">
        <!-- date_set start -->
        <p>
         <input id="reqsdt" name="reqsdt" type="text" title="Create Start Date" value="${searchVal.reqsdt}" placeholder="DD/MM/YYYY" class="j_date">
        </p>
        <span> <spring:message code='budget.To'/> </span>
        <p>
         <input id="reqedt" name="reqedt" type="text" title="Create End Date" value="${searchVal.reqedt}" placeholder="DD/MM/YYYY" class="j_date">
        </p>
       </div>
       <!-- date_set end -->
      </td>
     </tr>
    </tbody>
   </table>
   <!-- table end -->
  </form>
 </section>
 <!-- search_table end -->
 <!-- data body start -->
 <section class="search_result">
  <!-- search_result start -->
  <ul class="right_btns">
   <c:if test="${PAGE_AUTH.funcPrint == 'Y'}">
    <li><p class="btn_grid">
      <a id="download"><spring:message code='sys.btn.excel.dw' /></a>
     </p></li>
   </c:if>
   <c:if test="${PAGE_AUTH.funcPrint == 'Y'}">
    <li><p class="btn_grid">
      <a id="adjNote"><spring:message code='log.btn.adjNote' /></a>
     </p></li>
   </c:if>
   <c:if test="${PAGE_AUTH.funcChange == 'Y'}">
    <li><p class="btn_grid">
      <a id="insert"><spring:message code='sales.btn.new'/></a>
     </p></li>
    <li><p class="btn_grid">
      <a id="delete"><spring:message code='sys.btn.delete'/></a>
     </p></li>
   </c:if>
   <c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
    <li>
     <p class="btn_grid">
      <a id="goodIssue"><spring:message code='log.btn.GIGR'/></a>
     </p></li>
     <li>
     <p class="btn_grid">
       <a id="issueCancel" style="display:none"><spring:message code='log.btn.GIGRCancel'/></a>
     </p>
    </li>
   </c:if>
  </ul>
  <div id="main_grid_wrap" class="mt10" style="height: 400px"></div>
 </section>
 <!-- search_result end -->
 <div class="popup_wrap" id="giopenwindow" style="display: none">
  <!-- popup_wrap start -->
  <header class="pop_header">
   <!-- pop_header start -->
   <h1 id="dataTitle"><spring:message code='log.label.postDt'/></h1>
   <ul class="right_opt">
    <li><p class="btn_blue2">
      <a href="#"><spring:message code='sys.btn.close'/></a>
     </p></li>
   </ul>
  </header>
  <!-- pop_header end -->
  <section class="pop_body">
   <!-- pop_body start -->
   <form id="giForm" name="giForm" method="POST">
    <input type="hidden" name="gitype" id="gitype" value="GI" />
    <input type="hidden" name="prgnm" id="prgnm" value="${param.CURRENT_MENU_CODE}" />
    <input type="hidden" name="serialqty" id="serialqty" />
    <input type="hidden" name="reqstno" id="reqstno" />
    <table class="type1">
     <caption>search table</caption>
     <colgroup>
      <col style="width: 150px" />
      <col style="width: *" />
      <col style="width: 150px" />
      <col style="width: *" />
     </colgroup>
     <tbody>
      <tr>
       <th scope="row"><spring:message code='log.label.postDt'/></th>
       <td>
        <input id="giptdate" name="giptdate" type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" />
       </td>
       <th scope="row"><spring:message code='log.label.docDt'/></th>
       <td>
        <input id="gipfdate" name="gipfdate" type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" />
       </td>
      </tr>
      <tr>
       <th scope="row"><spring:message code='log.label.hdrTxt'/><span class="must">*</span></th>
       <td colspan='3'>
        <input type="text" name="doctext" id="doctext" class="w100p" maxlength="50" /></td>
      </tr>
     </tbody>
    </table>
    <table class="type1">
     <caption>search table</caption>
     <colgroup id="serialcolgroup">
     </colgroup>
     <tbody id="dBody">
     </tbody>
    </table>
    <article class="grid_wrap">
     <!-- grid_wrap start -->
     <div id="serial_grid_wrap" class="mt10" style="width: 100%;"></div>
    </article>
    <!-- grid_wrap end -->
    <ul class="center_btns">
     <c:if test="${PAGE_AUTH.funcChange == 'Y'}">
      <li><p class="btn_blue2 big">
        <a onclick="javascript:giSave();"><spring:message code='sys.btn.save'/></a>
       </p></li>
     </c:if>
    </ul>
   </form>
  </section>
 </div>
 <section class="tap_wrap">
  <!-- tap_wrap start -->
  <ul class="tap_type1">
   <li><a href="#" class="on"><spring:message code='log.title.matDocLst'/></a></li>
  </ul>
  <article class="tap_area">
   <!-- tap_area start -->
   <article class="grid_wrap">
    <!-- grid_wrap start -->

    <div id="mdc_grid" class="mt10" style="height: 150px">
     <c:if test="${PAGE_AUTH.funcPrint == 'Y'}">
      <p class="btn_grid" style="width: 100%;text-align:right;">
       <a id="download2"><spring:message code='sys.btn.excel.dw' /></a>
      </p>
      <br/>
     </c:if>
    </div>
   </article>
   <!-- grid_wrap end -->
  </article>
  <!-- tap_area end -->
 </section>
 <!-- tap_wrap end -->
 <form id='popupForm'>
  <input type="hidden" id="sUrl" name="sUrl"> <input
   type="hidden" id="svalue" name="svalue">
 </form>
</section>