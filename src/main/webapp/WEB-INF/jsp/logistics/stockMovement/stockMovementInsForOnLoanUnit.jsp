<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<style type="text/css">

/* 커스텀 칼럼 스타일 정의 */
.aui-grid-user-custom-left {
  text-align: left;
}

/* 커스컴 disable 스타일*/
.mycustom-disable-color {
  color: #cccccc;
}

/* 그리드 오버 시 행 선택자 만들기 */
.aui-grid-body-panel table tr:hover {
  background: #D9E5FF;
  color: #000;
}

.aui-grid-main-panel .aui-grid-body-panel table tr td:hover {
  background: #D9E5FF;
  color: #000;
}
</style>
<script type="text/javascript"
 src="${pageContext.request.contextPath}/resources/js/jquery.blockUI.min.js"></script>
<script type="text/javaScript" language="javascript">
  var headerTxt = "Request On-Loan Unit";
  var resGrid;
  var reqGrid
  var rescolumnLayout = [ {
    dataField : "rnum",
    headerText : "<spring:message code='log.head.rnum'/>",
    width : 120,
    height : 30,
    visible : false
  }, {
    dataField : "locid",
    headerText : "<spring:message code='log.head.location'/>",
    width : 120,
    height : 30,
    visible : false
  }, {
    dataField : "stkid",
    headerText : "<spring:message code='log.head.itemcd'/>",
    width : 120,
    height : 30,
    visible : false
  }, {
    dataField : "stkcd",
    headerText : "<spring:message code='log.head.matcode'/>",
    width : 120,
    height : 30,
    editable : false
  }, {
    dataField : "stknm",
    headerText : "Mat. Name",
    width : 120,
    height : 30,
    editable : false
  }, {
    dataField : "typeid",
    headerText : "<spring:message code='log.head.typeid'/>",
    width : 120,
    height : 30,
    visible : false
  }, {
    dataField : "typenm",
    headerText : "<spring:message code='log.head.type'/>",
    width : 120,
    height : 30,
    editable : false
  }, {
    dataField : "cateid",
    headerText : "<spring:message code='log.head.cateid'/>",
    width : 120,
    height : 30,
    visible : false
  }, {
    dataField : "catenm",
    headerText : "<spring:message code='log.head.category'/>",
    width : 120,
    height : 30,
    editable : false
  }, {
    dataField : "qty",
    headerText : "<spring:message code='log.head.availableqty'/>",
    width : 120,
    height : 30,
    editable : false
  }, {
    dataField : "uom",
    headerText : "<spring:message code='log.head.uom'/>",
    width : 120,
    height : 30,
    visible : false
  }, {
    dataField : "serialChk",
    headerText : "<spring:message code='log.head.serial'/>",
    width : 120,
    height : 30,
    editable : false
  } ];

  var reqcolumnLayout;

  var resop = {
    rowIdField : "rnum",
    showRowCheckColumn : true,
    usePaging : true,
    useGroupingPanel : false,
    Editable : false
  };
  var reqop = {
    usePaging : true,
    useGroupingPanel : false,
    Editable : true
  };

  var uomlist = f_getTtype('42', '');
  var paramdata;
  var movpathdata;

  $(document)
      .ready(
          function() {
            /**********************************
             * Header Setting
             ***********************************/
            paramdata = {
              groupCode : '306',
              orderValue : 'CRT_DT',
              likeValue : 'UM'
            };
            doGetComboData('/common/selectCodeList.do', paramdata,
                'UM', 'sttype', 'S', '');
            movpathdata = [ {
              "codeId" : "02",
              "codeName" : "RDC to CT/Cody"
            }, {
              "codeId" : "CTOR",
              "codeName" : "CT/Cody to RDC"
            } ];
            doDefCombo(movpathdata, '', 'movpath', 'S', '');
            doGetCombo('/common/selectCodeList.do', '15', '61',
                'cType', 'M', 'f_multiCombo');
            doGetCombo('/common/selectCodeList.do', '11', '54',
                'catetype', 'M', 'f_multiCombo'); //청구처 리스트 조회
            doSysdate(0, 'docdate');
            doSysdate(0, 'reqcrtdate');

            //$("#cancelTr").hide();
            /**********************************
             * Header Setting End
             ***********************************/

            reqcolumnLayout = [
                {
                  dataField : "itmid",
                  headerText : "<spring:message code='log.head.itemid'/>",
                  width : 120,
                  height : 30,
                  visible : false
                },
                {
                  dataField : "itmcd",
                  headerText : "<spring:message code='log.head.matcode'/>",
                  width : 120,
                  height : 30,
                  editable : false
                },
                {
                  dataField : "itmname",
                  headerText : "Mat. Name",
                  width : 120,
                  height : 30,
                  editable : false
                },
                {
                  dataField : "aqty",
                  headerText : "<spring:message code='log.head.availableqty'/>",
                  width : 120,
                  height : 30,
                  editable : false
                },
                {
                  dataField : "rqty",
                  headerText : "<spring:message code='log.head.requestqty'/>",
                  width : 120,
                  height : 30,
                  editable : false
                },
                {
                  dataField : "uom",
                  headerText : "<spring:message code='log.head.uom'/>",
                  width : 120,
                  height : 30,
                  editable : false,
                  labelFunction : function(rowIndex,
                      columnIndex, value, headerText,
                      item) {
                    var retStr = "";

                    for (var i = 0, len = uomlist.length; i < len; i++) {
                      if (uomlist[i]["codeId"] == value) {
                        retStr = uomlist[i]["codeName"];
                        break;
                      }
                    }
                    return retStr == "" ? value : retStr;
                  },
                  editRenderer : {
                    type : "ComboBoxRenderer",
                    showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 보이기
                    list : uomlist,
                    keyField : "codeId",
                    valueField : "codeName"
                  }
                },
                {
                  dataField : "itmserial",
                  headerText : "<spring:message code='log.head.serial'/>",
                  width : 120,
                  height : 30,
                  editable : false
                },
                {
                  dataField : "itmtype",
                  headerText : "<spring:message code='log.head.type'/>",
                  width : 120,
                  height : 30,
                  editable : true
                } ];

            resGrid = GridCommon.createAUIGrid("res_grid_wrap",
                rescolumnLayout, "", resop);
            reqGrid = GridCommon.createAUIGrid("req_grid_wrap",
                reqcolumnLayout, "", reqop);

            AUIGrid.bind(resGrid, "addRow", function(event) {
            });
            AUIGrid.bind(reqGrid, "addRow", function(event) {
            });

            AUIGrid.bind(resGrid, "cellEditBegin", function(event) {
            });
            AUIGrid.bind(reqGrid, "cellEditBegin", function(event) {

            });

            AUIGrid.bind(resGrid, "cellEditEnd", function(event) {
            });
            AUIGrid
                .bind(
                    reqGrid,
                    "cellEditEnd",
                    function(event) {

                      if (event.dataField == "itmcd") {
                        $("#svalue").val(
                            AUIGrid.getCellValue(
                                reqGrid,
                                event.rowIndex,
                                "itmcd"));
                        $("#sUrl")
                            .val(
                                "/logistics/material/materialcdsearch.do");
                        Common
                            .searchpopupWin(
                                "popupForm",
                                "/common/searchPopList.do",
                                "stocklist");
                      }

                      if (event.dataField == "rqty") {
                        if (AUIGrid.getCellValue(
                            reqGrid,
                            event.rowIndex, "rqty") > AUIGrid
                            .getCellValue(reqGrid,
                                event.rowIndex,
                                "aqty")) {
                          Common
                              .alert('The requested quantity is up to '
                                  + AUIGrid
                                      .getCellValue(
                                          reqGrid,
                                          event.rowIndex,
                                          "aqty")
                                  + '.');
                          AUIGrid.setCellValue(
                              reqGrid,
                              event.rowIndex,
                              "rqty", 0);
                          return false;
                        }
                        if (AUIGrid.getCellValue(
                            reqGrid,
                            event.rowIndex, "rqty") < 0) {
                          Common
                              .alert('The requested quantity is less than zero.');
                          AUIGrid.setCellValue(
                              reqGrid,
                              event.rowIndex,
                              "rqty", 0);
                          return false;

                        }
                      }
                    });

            AUIGrid.bind(resGrid, "cellClick", function(event) {
            });
            AUIGrid.bind(reqGrid, "cellClick", function(event) {
            });

            AUIGrid.bind(resGrid, "cellDoubleClick",
                function(event) {
                });
            AUIGrid.bind(reqGrid, "cellDoubleClick",
                function(event) {
                });

            AUIGrid.bind(resGrid, "ready", function(event) {
            });
            AUIGrid.bind(reqGrid, "ready", function(event) {
            });

          });

  //btn clickevent
  $(function() {
    $('#search').click(function() {
      //if (f_validatation('search')){
      $("#slocation").val($("#tlocation").val());
      SearchListAjax();
      //}
    });
    $('#clear').click(function() {
    });
    $('#reqadd').click(function() {
      f_AddRow();
    });
    $('#reqdel').click(function() {
      AUIGrid.removeRow(reqGrid, "selectedIndex");
      AUIGrid.removeSoftRows(reqGrid);
    });
    $('#list')
        .click(
            function() {
              document.location.href = '/logistics/stockMovement/StockMovementList.do';
            });
    $('#save')
        .click(
            function() {
              var items = GridCommon.getEditData(reqGrid);
              var bool = true;

              for (var i = 0; i < items.add.length; i++) {
                if (items.add.length > 1) {
                  Common
                      .alert("Only allow request one Material.");
                  bool = false;
                  break;
                }
                if (items.add[i].rqty == 0) {
                  Common
                      .alert('Please enter the Request Qty.');
                  bool = false;
                  break;
                }
                if (items.add[i].rqty > 1) {
                  Common
                      .alert('Only allow to request 1 Qty.');
                  bool = false;
                  break;
                }
              }
              if (bool && f_validatation('save')) {

                fn_enablecomboField('save');

                var dat = GridCommon.getEditData(reqGrid);
                dat.form = $("#headForm").serializeJSON();
                Common
                    .ajax(
                        "POST",
                        "/logistics/stockMovement/StockMovementForOnLoanUnit.do",
                        dat,
                        function(result) {
                          if (result.code == '99') {
                            AUIGrid
                                .clearGridData(reqGrid);
                            Common.alert(
                                result.message,
                                SearchListAjax);
                          } else {
                            Common
                                .alert(
                                    ""
                                        + result.message
                                        + "</br> Created : "
                                        + result.data,
                                    locationList);
                            AUIGrid
                                .resetUpdatedItems(
                                    reqGrid,
                                    "all");
                          }

                        },
                        function(jqXHR, textStatus,
                            errorThrown) {
                          try {
                          } catch (e) {
                          }
                          Common
                              .alert("Fail : "
                                  + jqXHR.responseJSON.message);
                        });
              }
            });

    $("#movpath").change(
        function() {
          var brnch = '${SESSION_INFO.userBranchId}';
          var paramdata;
          var paramdata2;
          var paramdata3;

          if ($("#movpath").val() == "") {
            doDefCombo([], '', 'tlocation', 'S', '');
            doDefCombo([], '', 'flocation', 'S', '');
          } else {
            if (($("#movpath").val() == 'CTOR')) {
              paramdata3 = {
                groupCode : '308',
                orderValue : 'CODE_NAME',
                likeValue : $("#sttype").val()
              };
              doGetComboData('/common/selectCodeList.do',
                  paramdata3, 'UM93', 'smtype', 'S', '');
              if (brnch != '42' && brnch != '0') {
                paramdata2 = {
                  stoIn : '01,02,05,06,07',
                  grade : $("#locationType").val()
                };
                doGetComboCodeId(
                    '/common/selectStockLocationList.do',
                    paramdata2, '', 'flocation', 'S',
                    'fn_setDefaultSelection');

                paramdata = {
                  locgb : $("#movpath").val(),
                  brnch : brnch
                };
                doGetComboCodeId(
                    '/common/selectStockLocationList.do',
                    paramdata, '', 'tlocation', 'S', '');
              } else {

                paramdata = {
                  locgb : $("#movpath").val(),
                  grade : 'A'
                };
                doGetComboCodeId(
                    '/common/selectStockLocationList.do',
                    paramdata, '', 'tlocation', 'S', '');

                paramdata2 = {
                  stoIn : '02,05',
                  endlikeValue : $("#locationType").val(),
                  grade : $("#locationType").val()
                };
                doGetComboCodeId(
                    '/common/selectStockLocationList.do',
                    paramdata2, '', 'flocation', 'S', '');
              }

            }
            if ($("#movpath").val() == '02') {
              paramdata = {
                stoIn : '02,05',
                endlikeValue : $("#locationType").val(),
                grade : $("#locationType").val()
              };
              doGetComboCodeId(
                  '/common/selectStockLocationList.do',
                  paramdata, '', 'tlocation', 'S',
                  'fn_setDefaultToSelection');

              paramdata2 = {
                brnch : brnch,
                locgb : 'CT',
                ctloc : $("#tlocation").val()
              };
              doGetComboCodeId(
                  '/common/selectStockLocationList.do',
                  paramdata2, '', 'flocation', 'S', '');

              paramdata3 = {
                groupCode : '308',
                orderValue : 'CODE_NAME',
                likeValue : $("#sttype").val()
              };
              doGetComboData('/common/selectCodeList.do',
                  paramdata3, 'UM03', 'smtype', 'S', '');
            }

          }
        });

    $("#tlocation").change(
        function() {
          if ($("#movpath").val() == "02") {
            var paramdata = {
              ctloc : $("#tlocation").val(),
              locgb : 'CT'
            };
            doGetComboCodeId('/common/selectStockLocationList.do',
                paramdata, '', 'flocation', 'S', '');
          }
        });

    $("#flocation").change(
        function() {
          if ($("#movpath").val() == "CTOR") {
            var paramdata = {
              ctloc : $("#flocation").val(),
              locgb : 'CT'
            };
            doGetComboCodeId('/common/selectStockLocationList.do',
                paramdata, '', 'tlocation', 'S', '');
          }
        });

    $("#rightbtn")
        .click(
            function() {
              checkedItems = AUIGrid
                  .getCheckedRowItemsAll(resGrid);
              //console.log("checkedItems is " + checkedItems);

              var reqitms = AUIGrid.getGridData(reqGrid);

              if (reqitms.length + checkedItems.length > 5){
                  Common.alert("Maximum 5 Material Code per SMO request.");
                  return false;
              }

              var bool = true;
              if (checkedItems.length > 0) {
                var rowPos = "first";
                var item = new Object();
                var rowList = [];

                var boolitem = true;
                var k = 0;

                for (var i = 0; i < checkedItems.length; i++) {
                  if (checkedItems.length > 1) {
                    boolitem = false;
                    Common
                        .alert("Only allow to select one Material.");
                    break;
                  }

                  if (checkedItems[i].qty == 0) {
                    boolitem = false;
                    Common
                        .alert("Stock is insufficient to request.");
                    break;
                  }
                  if (reqitms.length >= 1) {
                    boolitem = false;
                    Common
                        .alert("Only allow to request one Material.");
                    break;
                  }

                  for (var j = 0; j < reqitms.length; j++) {

                    if (reqitms[j].itmid == checkedItems[i].stkid) {
                      boolitem = false;
                      break;
                    }

                  }

                  if (boolitem) {
                    rowList[k] = {
                      itmid : checkedItems[i].stkid,
                      itmcd : checkedItems[i].stkcd,
                      itmname : checkedItems[i].stknm,
                      aqty : checkedItems[i].qty,
                      rqty : 1,
                      uom : checkedItems[i].uom,
                      itmserial : checkedItems[i].serialChk,
                      itmtype : checkedItems[i].typeid
                    }
                    k++;
                  }

                  AUIGrid.addUncheckedRowsByIds(resGrid,
                      checkedItems[i].rnum);
                  boolitem = true;
                }

                AUIGrid.addRow(reqGrid, rowList, rowPos);
              }
            });
  });

  function locationList() {
    $('#list').click();
  }
  function f_validatation(v) {
    if ($("#sttype").val() == null || $("#sttype").val() == undefined
        || $("#sttype").val() == "") {
      Common.alert("Please select one of Transaction Type.");
      return false;
    }
    if ($("#smtype").val() == null || $("#smtype").val() == undefined
        || $("#smtype").val() == "") {
      Common.alert("Please select one of Movement Type Detail.");
      return false;
    }
    if ($("#tlocation").val() == null || $("#tlocation").val() == undefined
        || $("#tlocation").val() == "") {
      Common.alert("Please select one of From Location.");
      return false;
    }
    if ($("#flocation").val() == null || $("#flocation").val() == undefined
        || $("#flocation").val() == "") {
      Common.alert("Please select one of To Location.");
      return false;
    }
    if (v == 'save') {
      if ($("#reqcrtdate").val() == null
          || $("#reqcrtdate").val() == undefined
          || $("#reqcrtdate").val() == "") {
        Common.alert("Please enter Document Date.");
        return false;
      }

      if ($("#dochdertxt").val().length > 50) {
        Common.alert("Header Text can be up to 50 digits.");
        return false;
      }

      if ($("#asno").val() == null || $("#asno").val() == undefined
          || $("#asno").val() == "") {
        Common.alert("Please enter AS No.");
        return false;
      }

      if ($("#orderno").val() == null || $("#orderno").val() == undefined
          || $("#orderno").val() == "") {
        Common.alert("Please enter Order No.");
        return false;
      }

    }
    return true;

  }

  function SearchListAjax() {

    fn_enablecomboField('search');

    var url = "/logistics/stockMovement/StockMovementTolocationItemList.do";
    var param = $('#searchForm').serialize();

    //     Common.ajax("GET" , url , param , function(result){
    //         AUIGrid.setGridData(resGrid, result.data);
    //     });
    $.ajax({
      type : "GET",
      url : url + "?" + param,
      //url : "/stock/StockList.do",
      //data : param,
      dataType : "json",
      contentType : "application/json;charset=UTF-8",
      beforeSend : function(request) {
        Common.showLoader();
      },
      success : function(data) {
        var gridData = data;

        AUIGrid.setGridData(resGrid, gridData.data);
      },
      error : function(jqXHR, textStatus, errorThrown) {
        Common.setMsg("Fail ........ ");
      },
      complete : function() {
        Common.removeLoader();
      }
    });
  }

  function addRow() {
    var rowPos = "first";

    var item = new Object();

    AUIGrid.addRow(reqGrid, item, rowPos);
  }

  function fn_itempopList(data) {

    var rowPos = "first";
    var rowList = [];

    AUIGrid.removeRow(reqGrid, "selectedIndex");
    AUIGrid.removeSoftRows(reqGrid);
    for (var i = 0; i < data.length; i++) {
      rowList[i] = {
        itmid : data[i].item.itemid,
        itmcd : data[i].item.itemcode,
        itmname : data[i].item.itemname
      }
    }

    AUIGrid.addRow(reqGrid, rowList, rowPos);

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
  function f_AddRow() {
    var rowPos = "first";

    var item = new Object();

    AUIGrid.addRow(reqGrid, item, rowPos);
  }

  function f_multiCombo() {
    $(function() {
      $('#catetype').change(function() {

      }).multipleSelect({
        selectAll : true
      });
      $('#cType').change(function() {

      }).multipleSelect({
        selectAll : true
      });
    });
  }

  function fn_setDefaultSelection() {

    Common.ajax("GET",
            "/logistics/stockMovement/selectDefToLocationB.do", '',
            function(result) {
              //console.log(result.data);
              if (result.data != null || result.data != "") {
                $(
                    "#flocation option[value='"
                        + result.data + "']").attr(
                    "selected", true);

              } else {
                $("#flocation option[value='']").attr(
                    "selected", true);
              }
            });
  }

  function fn_setDefaultToSelection() {
    Common.ajax("GET",
            "/logistics/stockMovement/selectDefToLocationB.do", '',
            function(result) {
              if (result.data != null || result.data != "") {
                $(
                    "#tlocation option[value='"
                        + result.data + "']").attr(
                    "selected", true);

              } else {
                $("#tlocation option[value='']").attr(
                    "selected", true);
              }
            });
  }

  function fn_enablecomboField(ind) {
    if (ind == "search") {
      $("#cType").prop("disabled", false);
      $("#catetype").prop("disabled", false);
    }
    if (ind == "save") {
      $("#sttype").prop("disabled", false);
      $("#smtype").prop("disabled", false);
    }
  }

  function fn_ASChk(obj) {
    var solCde = "";
    var err = false;
    if ($("#movpath").val() != "") {
      if ($("#movpath").val() == "02") {
        solCde = "1";
      } else {
        solCde = "2";
      }
    } else {
      Common.alert("Movement Path is required.");
      obj.value = "";
      return;
    }

    if (obj.value != "" && obj.value != null) {
      //Common.ajax("GET", "/logistics/stockMovement/chkASNoExist.do", { ASNO : obj.value }, function(result) {
        //if (result >= 1) {
          //Common.alert("AS No. already exist.");
          //obj.value = "";
          //return;
        //} else {
          Common.ajax("GET", "/logistics/stockMovement/chkASNo.do", { ASNO : obj.value, SOLCDE : solCde, IND : 0 }, function(result) {
            if (result == 0) {
              Common.ajax("GET", "/logistics/stockMovement/chkASNo.do", { ASNO : obj.value, SOLCDE : solCde , IND : 1 }, function(result) {
                 if (result == 0) {
                   Common.alert("Invalid AS No. Please check its Solution Code and Status.");
                   obj.value = "";
                 } else {
                   return;
                 }
              });
            } else {
             return;
            }
          });
        //}
      //});
    }
  }
</script>
<section id="content">
 <!-- content start -->
 <ul class="path">
  <li><img
   src="${pageContext.request.contextPath}/resources/images/common/path_home.gif"
   alt="Home" /></li>
  <li>Logistics</li>
  <li>Stock Movement Request</li>
 </ul>
 <aside class="title_line">
  <!-- title_line start -->
  <p class="fav">
   <a href="#" class="click_add_on">My menu</a>
  </p>
  <h2>Request/Return On-Loan Unit</h2>
 </aside>
 <!-- title_line end -->
 <aside class="title_line">
  <h3>Header Info</h3>
 </aside>
 <!-- search_table start -->
 <section class="search_table">
  <form id="headForm" name="headForm" method="post">
   <input type='hidden' id='pridic' name='pridic' value='M' /> <input
    type='hidden' id='headtitle' name='headtitle' value='SMO' />
   <table class="type1">
    <!-- table start -->
    <caption>table</caption>
    <colgroup>
     <col style="width: 140px" />
     <col style="width: *" />
     <col style="width: 140px" />
     <col style="width: *" />
     <col style="width: 180px" />
     <col style="width: *" />
    </colgroup>
    <tbody>
     <tr>
      <th scope="row">SMO No.</th>
      <td colspan="3"><input id="reqno" name="reqno" type="text"
       title="" placeholder="Automatic billing" class="readonly w100p"
       readonly="readonly" /></td>
      <th scope="row">Movement Path</th>
      <td colspan="3"><select class="w100p" id="movpath"
       name="movpath"></select></td>
     </tr>
     <tr>
      <th scope="row">Transaction Type</th>
      <td colspan="3"><select class="w100p" id="sttype"
       name="sttype" disabled></select></td>
      <th scope="row">Movement Type</th>
      <td colspan="3"><select class="w100p" id="smtype"
       name="smtype" disabled><option>Movement Type
         Selected</option></select></td>
     </tr>
     <tr>
      <th scope="row">Document Date</th>
      <td colspan="3"><input id="docdate" name="docdate"
       type="text" title="Create start Date" placeholder="DD/MM/YYYY"
       class="j_date" /></td>
      <th scope="row">Delivery Required Date</th>
      <td colspan="3"><input id="reqcrtdate" name="reqcrtdate"
       type="text" title="Create start Date" placeholder="DD/MM/YYYY"
       class="j_date" /></td>
     </tr>
     <tr>
      <th scope="row">Order No.</th>
      <td colspan="3"><input id="orderno" name="orderno"
       type="text" placeholder="Order No" class="w100p" /></td>
      <th scope="row">AS No.</th>
      <td colspan="3"><input id="asno" name="asno" type="text"
       placeholder="AS No" class="w100p" onblur="fn_ASChk(this);"/></td>
     </tr>
     <tr>
      <th scope="row">Location Type</th>
      <td><select class="w100p" id="locationType" disabled
       name="locationType">
        <option value="">All</option>
        <option value="A">A</option>
        <option value="B" selected>B</option>
      </select></td>
      <th scope="row">From Location</th>
      <td colspan="2"><select class="w100p" id="tlocation"
       name="tlocation"></select></td>
      <th scope="row">To Location</th>
      <td colspan="2"><select class="w100p" id="flocation"
       name="flocation"></select></td>
     </tr>
     <tr>
      <th scope="row">Remark</th>
      <td colspan="7"><input id="dochdertxt" name="dochdertxt"
       type="text" title="" placeholder="" class="w100p" maxlength="50" /></td>
     </tr>
    </tbody>
   </table>
   <!-- table end -->
  </form>
 </section>
 <!-- search_table end -->
 <aside class="title_line">
  <!-- title_line start -->
  <h3>Item Info</h3>
  <ul class="right_btns">
   <c:out value="${PAGE_AUTH}"></c:out>
   <%-- <c:if test="${PAGE_AUTH.funcView == 'Y'}"> --%>
   <li><p class="btn_blue2">
     <a id="search"><spring:message code='sys.btn.search' /></a>
    </p></li>
   <%-- </c:if> --%>
  </ul>
 </aside>
 <!-- title_line end -->
 <section class="search_table">
  <!-- search_table start -->
  <form id="searchForm" name="searchForm">
   <input type="hidden" id="slocation" name="slocation">
   <table class="type1">
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
      <th scope="row">Type</th>
      <td colspan="3"><select class="w100p" id="cType" name="cType"
       disabled></select></td>
      <th scope="row">Category</th>
      <td colspan="3"><select class="w100p" id="catetype"
       name="catetype" disabled></select></td>
     </tr>
     <tr>
      <th scope="row">Material Code</th>
      <td colspan="3"><input type="text" class="w100p"
       id="materialCode" name="materialCode" /></td>
      <td colspan="4"></td>
     </tr>
    </tbody>
   </table>
   <!-- table end -->
  </form>
 </section>
 <!-- search_table end -->
 <section class="search_result">
  <!-- search_result start -->
  <div class="divine_auto type2">
   <!-- divine_auto start -->
   <div style="width: 50%">
    <!-- 50% start -->
    <aside class="title_line">
     <!-- title_line start -->
     <h3>Material Code</h3>
    </aside>
    <!-- title_line end -->
    <div class="border_box" style="height: 340px;">
     <!-- border_box start -->
     <article class="grid_wrap">
      <!-- grid_wrap start -->
      <div id="res_grid_wrap"></div>
     </article>
     <!-- grid_wrap end -->
    </div>
    <!-- border_box end -->
   </div>
   <!-- 50% end -->
   <div style="width: 50%">
    <!-- 50% start -->
    <aside class="title_line">
     <!-- title_line start -->
     <h3>Request Item</h3>
     <ul class="right_btns">
      <%-- <c:if test="${PAGE_AUTH.funcChange == 'Y'}"> --%>
      <!--     <li><p class="btn_grid"><a id="reqadd">ADD</a></p></li> -->
      <li><p class="btn_grid">
        <a id="reqdel">DELETE</a>
       </p></li>
      <%-- </c:if> --%>
     </ul>
    </aside>
    <!-- title_line end -->
    <div class="border_box" style="height: 340px;">
     <!-- border_box start -->
     <article class="grid_wrap">
      <!-- grid_wrap start -->
      <div id="req_grid_wrap"></div>
     </article>
     <!-- grid_wrap end -->
     <ul class="btns">
      <li><a id="rightbtn"><img
        src="${pageContext.request.contextPath}/resources/images/common/btn_right2.gif"
        alt="right" /></a></li>
      <%--     <li><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_left2.gif" alt="left" /></a></li> --%>
     </ul>
    </div>
    <!-- border_box end -->
   </div>
   <!-- 50% end -->
  </div>
  <!-- divine_auto end -->
  <ul class="center_btns mt20">
   <li><p class="btn_blue2 big">
     <a id="list">List</a>
    </p></li>&nbsp;&nbsp;
   <%-- <c:if test="${PAGE_AUTH.funcChange == 'Y'}"> --%>
   <li><p class="btn_blue2 big">
     <a id="save">Save</a>
    </p></li>
   <%-- </c:if>         --%>
  </ul>
 </section>
 <!-- search_result end -->
 <form id='popupForm'>
  <input type="hidden" id="sUrl" name="sUrl"> <input
   type="hidden" id="svalue" name="svalue">
 </form>
</section>