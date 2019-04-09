<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<style type="text/css">

/* 커스텀 칼럼 스타일 정의 */
.aui-grid-user-custom-left {
  text-align: left;
}

.aui-grid-user-custom-right {
  text-align: right;
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
  var reqGrid;
  var serialGrid;
  var serialchk = false;
  var rescolumnLayout = [
      {
        dataField : "rnum",
        headerText : "<spring:message code='log.head.rownum'/>",
        width : 120,
        height : 30,
        visible : false
      },
      {
        dataField : "status",
        headerText : "<spring:message code='log.head.status'/>",
        width : 120,
        height : 30,
        visible : false
      },
      {
        dataField : "reqstno",
        headerText : "SMO No.",
        width : 120,
        height : 30
      },
      {
        dataField : "ordno",
        headerText : "Order No.",
        width : 120,
        height : 30
      },
      {
        dataField : "staname",
        headerText : "<spring:message code='log.head.status'/>",
        width : 120,
        height : 30
      },
      {
        dataField : "reqitmno",
        headerText : "<spring:message code='log.head.stockmovementrequestitem'/>",
        width : 120,
        height : 30,
        visible : false
      },
      {
        dataField : "rcvloc",
        headerText : "<spring:message code='log.head.fromlocation'/>",
        width : 120,
        height : 30,
        visible : false
      },
      {
        dataField : "rcvlocnm",
        headerText : "<spring:message code='log.head.fromlocation'/>",
        width : 120,
        height : 30,
        visible : false
      },
      {
        dataField : "rcvlocdesc",
        headerText : "<spring:message code='log.head.fromlocation'/>",
        width : 120,
        height : 30
      },
      {
        dataField : "reqloc",
        headerText : "<spring:message code='log.head.tolocation'/>",
        width : 120,
        height : 30,
        visible : false
      },
      {
        dataField : "reqlocnm",
        headerText : "<spring:message code='log.head.tolocation'/>",
        width : 120,
        height : 30,
        visible : false
      },
      {
        dataField : "reqlocdesc",
        headerText : "<spring:message code='log.head.tolocation'/>",
        width : 120,
        height : 30
      },
      {
        dataField : "itmcd",
        headerText : "<spring:message code='log.head.matcode'/>",
        width : 120,
        height : 30,
        visible : true
      },
      {
        dataField : "itmname",
        headerText : "Mat. Name",
        width : 120,
        height : 30
      },
      {
        dataField : "reqstqty",
        headerText : "<spring:message code='log.head.requestedqty'/>",
        width : 120,
        height : 30
      },
      {
        dataField : "rmqty",
        headerText : "<spring:message code='log.head.remainqty'/>",
        width : 120,
        height : 30
      },
      {
        dataField : "delvno",
        headerText : "<spring:message code='log.head.delvno'/>",
        width : 120,
        height : 30,
        visible : false
      },
      {
        dataField : "delyqty",
        headerText : "<spring:message code='log.head.delvno'/>",
        width : 120,
        height : 30,
        visible : false
      },
      {
        dataField : "indelyqty",
        headerText : "<spring:message code='log.head.deliveredqty'/>",
        width : 120,
        height : 30,
        editable : true,
        dataType : "numeric",
        editRenderer : {
          type : "InputEditRenderer",
          onlyNumeric : true, // 0~9 까지만 허용
          allowPoint : false
        // onlyNumeric 인 경우 소수점(.) 도 허용
        }
      },
      {
        dataField : "serialchk",
        headerText : "<spring:message code='log.head.serialcheck'/>",
        width : 120,
        height : 30,
        visible : false
      },
      {
        dataField : "rciptqty",
        headerText : "<spring:message code='log.head.grqty'/>",
        width : 120,
        height : 30
      },
      {
        dataField : "docno",
        headerText : "<spring:message code='log.head.refdocno'/>",
        width : 120,
        height : 30
      },
      {
        dataField : "uom",
        headerText : "<spring:message code='log.head.unitofmeasure'/>",
        width : 120,
        height : 30,
        visible : false
      },
      {
        dataField : "uomnm",
        headerText : "UOM",
        width : 120,
        height : 30
      },
      {
        dataField : "ttype",
        headerText : "Trans. Type",
        width : 120,
        height : 30,
        visible : false
      },
      {
        dataField : "ttext",
        headerText : "Trans. Type",
        width : 120,
        height : 30
      },
      {
        dataField : "mtype",
        headerText : "<spring:message code='log.head.movementtype'/>",
        width : 120,
        height : 30,
        visible : false
      },
      {
        dataField : "mtext",
        headerText : "Movement Type",
        width : 120,
        height : 30
      },
      {
        dataField : "froncy",
        headerText : "<spring:message code='log.head.auto/manual'/>",
        width : 120,
        height : 30
      },
      {
        dataField : "crtdt",
        headerText : "Reqst. Create Date",
        width : 120,
        height : 30
      },
      {
        dataField : "reqsttype",
        headerText : "<spring:message code='log.head.requestcreatedate'/>",
        width : 120,
        height : 30,
        visible : false
      },
      {
        dataField : "reqsttypedtl",
        headerText : "<spring:message code='log.head.requestcreatedate'/>",
        width : 120,
        height : 30,
        visible : false
      }, {
        dataField : "reqdt",
        headerText : "Reqst. Required Date",
        width : 120,
        height : 30
      } ];
  var reqcolumnLayout;

  var serialcolumnLayout = [
      {
        dataField : "rnum",
        headerText : "<spring:message code='log.head.rownum'/>",
        width : 120,
        height : 30,
        visible : false
      },
      {
        dataField : "status",
        headerText : "<spring:message code='log.head.status'/>",
        width : 120,
        height : 30,
        visible : false
      },
      {
        dataField : "reqstno",
        headerText : "<spring:message code='log.head.stockmovementrequest'/>",
        width : "20%",
        height : 30,
        cellMerge : true
      },
      {
        dataField : "staname",
        headerText : "<spring:message code='log.head.status'/>",
        width : 120,
        height : 30,
        visible : false
      },
      {
        dataField : "reqitmno",
        headerText : "<spring:message code='log.head.stockmovementrequestitem'/>",
        width : 120,
        height : 30,
        visible : false
      },
      {
        dataField : "ttype",
        headerText : "<spring:message code='log.head.transactiontype'/>",
        width : 120,
        height : 30,
        visible : false
      },
      {
        dataField : "ttext",
        headerText : "<spring:message code='log.head.transactiontypetext'/>",
        width : 120,
        height : 30,
        visible : false
      },
      {
        dataField : "mtype",
        headerText : "<spring:message code='log.head.movementtype'/>",
        width : 120,
        height : 30,
        visible : false
      },
      {
        dataField : "mtext",
        headerText : "<spring:message code='log.head.movementtext'/>",
        width : 120,
        height : 30,
        visible : false
      },
      {
        dataField : "froncy",
        headerText : "<spring:message code='log.head.auto/manual'/>",
        width : 120,
        height : 30,
        visible : false
      },
      {
        dataField : "crtdt",
        headerText : "<spring:message code='log.head.requestcreatedate'/>",
        width : 120,
        height : 30,
        visible : false
      },
      {
        dataField : "reqdate",
        headerText : "<spring:message code='log.head.requestrequireddate'/>",
        width : 120,
        height : 30,
        visible : false
      }, {
        dataField : "rcvloc",
        headerText : "<spring:message code='log.head.fromlocation'/>",
        width : 120,
        height : 30,
        visible : false
      }, {
        dataField : "rcvlocnm",
        headerText : "<spring:message code='log.head.fromlocation'/>",
        width : 120,
        height : 30,
        visible : false
      }, {
        dataField : "rcvlocdesc",
        headerText : "<spring:message code='log.head.fromlocation'/>",
        width : 120,
        height : 30,
        visible : false
      }, {
        dataField : "reqloc",
        headerText : "<spring:message code='log.head.tolocation'/>",
        width : 120,
        height : 30,
        visible : false
      }, {
        dataField : "reqlocnm",
        headerText : "<spring:message code='log.head.tolocation'/>",
        width : 120,
        height : 30,
        visible : false
      }, {
        dataField : "reqlocdesc",
        headerText : "<spring:message code='log.head.tolocation'/>",
        width : 120,
        height : 30,
        visible : false
      }, {
        dataField : "itmcd",
        headerText : "<spring:message code='log.head.materialcode'/>",
        width : "20%",
        height : 30,
        cellMerge : true
      }, {
        dataField : "itmname",
        headerText : "<spring:message code='log.head.materialname'/>",
        width : "25%",
        height : 30,
        cellMerge : true
      }, {
        dataField : "num",
        headerText : "<spring:message code='log.head.seq'/>",
        width : "5%",
        height : 30,
        style : "aui-grid-user-custom-right"
      }, {
        dataField : "reqstqty",
        headerText : "<spring:message code='log.head.requestedqty'/>",
        width : 120,
        height : 30,
        visible : false
      }, {
        dataField : "rmqty",
        headerText : "<spring:message code='log.head.remainqty'/>",
        width : 120,
        height : 30,
        visible : false
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
        dataField : "indelyqty",
        headerText : "<spring:message code='log.head.deliveredqty'/>",
        width : 120,
        height : 30,
        editable : true,
        dataType : "numeric",
        editRenderer : {
          type : "InputEditRenderer",
          onlyNumeric : true, // 0~9 까지만 허용
          allowPoint : false
        // onlyNumeric 인 경우 소수점(.) 도 허용
        },
        visible : false
      }, {
        dataField : "greceipt",
        headerText : "<spring:message code='log.head.goodreceipted'/>",
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
        dataField : "uomnm",
        headerText : "<spring:message code='log.head.unitofmeasure'/>",
        width : 120,
        height : 30,
        visible : false
      }, {
        dataField : "serial",
        headerText : "<spring:message code='log.head.serial'/>",
        width : "30%",
        height : 30,
        editable : true,
        editRenderer : {
          type : "InputEditRenderer",
          showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 보이기
          onlyNumeric : false, // 0~9만 입력가능
          allowPoint : false, // 소수점( . ) 도 허용할지 여부
          allowNegative : false, // 마이너스 부호(-) 허용 여부
          textAlign : "center", // 오른쪽 정렬로 입력되도록 설정
          autoThousandSeparator : false
        // 천단위 구분자 삽입 여부
        }
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
  }, {
    dataField : "scanno",
    headerText : "<spring:message code='log.head.serial'/>",
    width : "30%",
    height : 30,
    visible : false
  } ];

  //var resop = {usePaging : true,useGroupingPanel : true , groupingFields : ["reqstno"] ,displayTreeOpen : true, enableCellMerge : true, showBranchOnGrouping : false};
  var resop = {
    rowIdField : "rnum",
    fixedColumnCount : 11,
    editable : true,
    //groupingFields : ["reqstno", "staname"],
    displayTreeOpen : false,
    showRowCheckColumn : true,
    showStateColumn : false,
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

  var paramdata;

  var amdata = [ {
    "codeId" : "A",
    "codeName" : "Auto"
  }, {
    "codeId" : "M",
    "codeName" : "Manaual"
  } ];
  var uomlist = f_getTtype('42', '');
  var paramdata;

  /* Required Date 초기화 */
  var today = new Date();
  var dd = today.getDate();
  var mm = today.getMonth() + 1;
  var yyyy = today.getFullYear();

  if (dd < 10) {
    dd = '0' + dd;
  }

  if (mm < 10) {
    mm = '0' + mm;
  }

  today = (dd + '/' + mm + '/' + yyyy);

  var nextDate = new Date();
  nextDate.setDate(nextDate.getDate() + 6);
  var dd2 = nextDate.getDate();
  var mm2 = nextDate.getMonth() + 1;
  var yyyy2 = nextDate.getFullYear();

  if (dd2 < 10) {
    dd2 = '0' + dd2;
  }

  if (mm2 < 10) {
    mm2 = '0' + mm2;
  }

  nextDate = (dd2 + '/' + mm2 + '/' + yyyy2);

  $(document).ready(
    function() {
      /**********************************
       * Header Setting
       **********************************/

      //paramdata = { groupCode : '306' , orderValue : 'CRT_DT' , likeValue:''};
      paramdata = {
        groupCode : '306',
        orderValue : 'CRT_DT',
        Codeval : 'UM'
      };
      //doGetComboData('/common/selectCodeList.do', paramdata, '${searchVal.sttype}','sttype', 'S' , 'f_change');
      doGetComboData('/common/selectCodeList.do', paramdata,
          ('${searchVal.sttype}' == '' ? 'UM'
              : '${searchVal.sttype}'), 'sttype',
          'S', 'f_change');
      doGetComboData('/common/selectCodeList.do', {
        groupCode : '309'
      }, '${searchVal.sstatus}', 'sstatus', 'S', '');
      //doGetComboData('/logistics/stockMovement/selectStockMovementNo.do', {groupCode:'stock'} , '${searchVal.streq}','streq', 'S' , '');
      //     doGetCombo('/common/selectStockLocationList.do', '', '${searchVal.tlocation}','tlocation', 'S' , '');
      //     doGetCombo('/common/selectStockLocationList.do', '', '${searchVal.flocation}','flocation', 'S' , 'SearchListAjax');
      doDefCombo(amdata, '${searchVal.sam}', 'sam', 'S', '');
      $("#crtsdt").val(today);
      $("#crtedt").val(nextDate);
      $("#reqsdt").val('${searchVal.reqsdt}');
      $("#reqedt").val('${searchVal.reqedt}');

      /**********************************
       * Header Setting End
       ***********************************/

      listGrid = AUIGrid.create("#main_grid_wrap", rescolumnLayout, resop);
      serialGrid = AUIGrid.create("#serial_grid_wrap", serialcolumn, serialop);

      AUIGrid.bind(listGrid, "cellClick", function(event) {});

      AUIGrid.bind(listGrid, "cellEditBegin",
        function(event) {
          if (event.dataField != "indelyqty") {
            return false;
          } else {
            var checklist = AUIGrid.getCheckedRowItemsAll(listGrid);
            for (var i = 0; i < checklist.length; i++) {
              /* if (checklist[i].reqstno != event.item.reqstno){
                   Common.alert("Request number is different.");
                   return false;
                 } */
              if (checklist[i].reqloc != event.item.reqloc) {
                Common.alert("Request To Location is different.");
                AUIGrid.addUncheckedRowsByIds(listGrid, event.item.rnum);
                return false;
              }
            }

            if (AUIGrid.getCellValue(listGrid, event.rowIndex, "rmqty") <= 0) {
              Common.alert('Delivery Qty can not be greater than Request Qty.');
              return false;
            }
          }
        });

      AUIGrid.bind(listGrid, "cellEditEnd",
        function(event) {
          if (event.dataField != "indelyqty") {
            return false;
           } else {
            var del = AUIGrid.getCellValue(listGrid, event.rowIndex, "indelyqty");
            if (del > 0) {
              if ((Number(AUIGrid.getCellValue(listGrid, event.rowIndex, "rmqty")) < Number(AUIGrid.getCellValue(listGrid, event.rowIndex, "indelyqty")))
                  || (Number(AUIGrid.getCellValue(listGrid, event.rowIndex, "rmqty")) < Number(AUIGrid.getCellValue(listGrid, event.rowIndex, "indelyqty")))) {
                Common.alert('Delivery Qty can not be greater than Request Qty.');
                //AUIGrid.getCellValue(listGrid, event.rowIndex, "reqstqty")
                AUIGrid.restoreEditedRows(listGrid, "selectedIndex");
              } else {
                AUIGrid.addCheckedRowsByIds(listGrid, event.item.rnum);
              }
            } else {
              AUIGrid.restoreEditedRows(listGrid, "selectedIndex");
              AUIGrid.addUncheckedRowsByIds(listGrid, event.item.rnum);
            }
          }
        });

        AUIGrid.bind(serialGrid, "cellEditBegin", function(event) {
          if (event.item.scanno != "") {
            return false;
          } else {
            return true;
          }
          // AUIGrid.setSelectionByIndex(serialGrid, AUIGrid.getRowCount(serialGrid) - 1, 2);
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
                 AUIGrid.setProp(serialGrid, "rowStyleFunction",
                   function(rowIndex, item) {
                     if (item.statustype == 'N') {
                       return "my-row-style";
                     }
                   });
                 AUIGrid.update(serialGrid);
               }

               if ($("#serialqty").val() > AUIGrid.getRowCount(serialGrid)) {
                 f_addrow();
               }

             }
           });

           AUIGrid.bind(listGrid, "cellDoubleClick", function(event) {
              //  $("#rStcode").val(AUIGrid.getCellValue(listGrid, event.rowIndex, "reqstno"));
              //  document.searchForm.action = '/logistics/stocktransfer/StocktransferView.do';
              //  document.searchForm.submit();
           });

           AUIGrid.bind(listGrid, "rowCheckClick", function(event){

               var checked = AUIGrid.getCheckedRowItems(listGrid);
               var reqno = AUIGrid.getCellValue(listGrid, event.rowIndex, "reqstno");

                   for (var i = 0; i < checked.length; i++)
                   {
                       if(checked[i].item.reqloc != event.item.reqloc)
                       {
                             Common.alert("Request To Location is different.");

                             var rown = AUIGrid.getRowIndexesByValue(listGrid, "reqstno" , reqno);

                             for (var i = 0; i < rown.length; i++)
                             {
                                 AUIGrid.addUncheckedRowsByIds(listGrid, AUIGrid.getCellValue(listGrid, rown[i], "rnum"));
                             }
                             return false;
                       }
                       else if(AUIGrid.getCellValue(listGrid, event.rowIndex, "rmqty") <= 0 ||
                                  AUIGrid.getCellValue(listGrid, event.rowIndex, "rmqty") < AUIGrid.getCellValue(listGrid, event.rowIndex, "indelyqty"))
                       {
                             Common.alert("Delivery Qty can not be greater than Request Qty.");

                             var rown = AUIGrid.getRowIndexesByValue(listGrid, "reqstno" , reqno);

                             for (var i = 0; i < rown.length; i++)
                             {
                                 AUIGrid.addUncheckedRowsByIds(listGrid, AUIGrid.getCellValue(listGrid, rown[i], "rnum"));
                             }
                             return false;
                       }

                       if (AUIGrid.isCheckedRowById(listGrid, event.item.rnum))
                       {
                           AUIGrid.addCheckedRowsByValue(listGrid, "reqstno" , reqno);
                       }
                       else
                       {
                           var rown = AUIGrid.getRowIndexesByValue(listGrid, "reqstno" , reqno);

                           for (var i = 0; i < rown.length; i++)
                           {
                               AUIGrid.addUncheckedRowsByIds(listGrid, AUIGrid.getCellValue(listGrid, rown[i], "rnum"));
                           }
                       }

                   }
             });

            AUIGrid.bind(serialGrid, "addRowFinish",
              function(event) {
                AUIGrid.setSelectionByIndex(serialGrid, AUIGrid.getRowCount(serialGrid) - 1, 2);
              });

            /*AUIGrid.bind(serialGrid, "keyDown", function(event){

                if (event.keyCode == 13){
                    f_addrow();
                }
            });*/

            AUIGrid.bind(listGrid, "ready", function(event) {
                var rowCnt = AUIGrid.getRowCount(listGrid);
                for (var i = 0 ; i < rowCnt ; i++){
                    var qty = AUIGrid.getCellValue(listGrid , i , 'reqstqty') - AUIGrid.getCellValue(listGrid , i , 'delyqty');
                    AUIGrid.setCellValue(listGrid, i, 'rmqty', qty);
                    AUIGrid.setCellValue(listGrid, i, 'indelyqty', qty);
                }
                AUIGrid.resetUpdatedItems(listGrid, "all");
            });

            //SearchListAjax();
            AUIGrid.bind(listGrid, "rowAllChkClick",
              function(event) {
                //alert("전체 선택  checked 111 : " + event.checked);
                if (true == event.checked) {
                  //alert(111);
                  $("#allChk").val(event.checked);
                } else {
                  //alert(222);
                  $("#allChk").val(event.checked);
                }
              });
            /*
            AUIGrid.bind(listGrid, "rowAllCheckClick", function( checked ) {
                alert("전체 선택  checked 222 : " + checked);
            });
             */
    });

  function f_change() {
    paramdata = {
      groupCode : '308',
      orderValue : 'CODE_ID',
      likeValue : $("#sttype").val(),
      codeIn : 'UM03,UM93'
    };

    doGetComboData('/common/selectCodeList.do', paramdata, '${searchVal.smtype}', 'smtype', 'S', '');
  }

  //btn clickevent
  $(function() {
    $('#search').click(function() {
      if (validation()) {
        SearchListAjax();
      }
    });

    $("#clear").click(function() {
      $("#searchForm")[0].reset();
    });

    $("#sttype").change(function() {
      paramdata = {
        groupCode : '308',
        orderValue : 'CODE_NAME',
        likeValue : $("#sttype").val()
      };
      doGetComboData('/common/selectCodeList.do', paramdata, '${searchVal.smtype}', 'smtype', 'S', '');
    });

    $("#download").click(function() {
      GridCommon.exportTo("main_grid_wrap", 'xlsx', "Movement Out");
    });

    $('#delivery').click(function() {
      if ("true" == $("#allChk").val()) {
        //alert($("#allChk").val());
        Common.alert("Not Allow to Check All rows");
        return false;
      }

      var checkDelqty = false;
      var checkedItems = AUIGrid.getCheckedRowItemsAll(listGrid);

      if (checkedItems.length <= 0) {
        Common.alert('No data selected.');
        return false;
      } else {
        var checkedItems = AUIGrid.getCheckedRowItems(listGrid);
        var str = "";
        var rowItem;

        for (var i = 0, len = checkedItems.length; i < len; i++) {
          rowItem = checkedItems[i];
          if (rowItem.item.indelyqty == 0) {
            str += "Please Check Delivery Qty of  "
                  + rowItem.item.reqstno + ", "
                  + rowItem.item.itmname
                  + "<br />";
             checkDelqty = true;
          }

          // ONGHC - TAKE OUT SERIAL NUMBER CHECKING FOR IN HOUSE REPAIR
          /*if (rowItem.item.docno !='' && rowItem.item.reqsttype =='OD' && rowItem.item.reqsttypedtl =='OD03'){
            serialchk = true;
          }*/

          /*if (rowItem.item.serialchk =='Y'){
            serialchk = true;
          }*//*else{
            serialchk = false;
          }*/
        }

        if (checkDelqty) {
          var option = { content : str,
                         isBig : true
                       };
                  Common.alertBase(option);
        } else {
          $("#giopenwindow").show();
          $("#giptdate").val("");
          $("#gipfdate").val("");
          $("#doctext").val("");
          doSysdate(0, 'giptdate');
          doSysdate(0, 'gipfdate');
          AUIGrid.clearGridData(serialGrid);
          AUIGrid.resize(serialGrid);
          if (serialchk) {
            //fn_itempopListSerial(checkedItems);
            fn_itempopList_T(checkedItems);
            $("#ascall").show();
            $("#serial_grid_wrap_div").show();
            AUIGrid.resize(serialGrid);
          } else {
            $("#serial_grid_wrap_div").hide();
            $("#ascall").hide();
          }
        }
      }
    });

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

    $("#flocationnm").keypress(
        function(event) {
          $('#flocation').val('');
          if (event.which == '13') {
            $("#stype").val('flocation');
            $("#svalue").val($('#flocationnm').val());
            $("#sUrl").val(
                "/logistics/organization/locationCdSearch.do");

            Common.searchpopupWin("searchForm",
                "/common/searchPopList.do", "location");
          }
        });

    $("#ascall").click(
        function() {
          //var checkedItems = AUIGrid.getCheckedRowItemsAll(listGrid);
          var checkedItems = AUIGrid.getCheckedRowItems(listGrid);

          for (var i = 0; i < checkedItems.length; i++) {

            param = "from=" + checkedItems[i].item.rcvloc + "&to="
                + checkedItems[i].item.reqloc;
          }

          //param = "from=14&to=387";
          Common.ajax("GET",
              "/logistics/stockMovement/GetSerialDataCall.do",
              param, function(result) {

                if (result.data.length > 0) {
                  AUIGrid
                      .setGridData(serialGrid,
                          result.data);
                  $("#ascyn").val('Y');
                } else {
                  Common.alert("No Serial No found..");
                  //f_addrow();
                }

              }, function(jqXHR, textStatus, errorThrown) {
                try {
                } catch (e) {
                }
                Common.alert("Fail : "
                    + jqXHR.responseJSON.message);
              });

        });

    $('#serialclose').click(function() {
      serialchk = false;
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

  function validation() {
    if ($("#crtsdt").val() == "" || ($("#crtedt").val() == "")) {
      Common.alert('Please enter Dlvd.Req.Date');
      return false;
    } else {
      return true;
    }
  }
  function SearchListAjax() {
    if ($("#flocationnm").val() == "") {
      $("#flocation").val('');
    }
    if ($("#tlocationnm").val() == "") {
      $("#tlocation").val('');
    }

    if ($("#flocation").val() == "") {
      $("#flocation").val($("#flocationnm").val());
    }
    if ($("#tlocation").val() == "") {
      $("#tlocation").val($("#tlocationnm").val());
    }

    var url = "/logistics/stockMovement/StockMovementSearchList.do";
    var param = $('#searchForm').serializeJSON();
    Common.ajax("POST", url, param, function(data) {
      AUIGrid.setGridData(listGrid, data.data);
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
        alert("Draw ComboBox['" + obj + "'] is failed. \n\n Please try again.");
      },
      complete : function() {
      }
    });

    return rData;
  }

  function fn_itempopListSerial(data) {
    var rowPos = "first";
    var rowList = [];
    var str = "";
    var rowItem;
    var cnt = 0;
    for (var i = 0, len = data.length; i < len; i++) {
      rowItem = data[i];
      var num = 1;

      for (var j = 0; j < rowItem.item.indelyqty; j++) {
        rowList[cnt] = {
          rnum : rowItem.item.rnum,
          reqstno : rowItem.item.reqstno,
          itmcd : rowItem.item.itmcd,
          itmname : rowItem.item.itmname,
          num : num,
          indelyqty : rowItem.item.indelyqty,
          serial : num
        }
        cnt++;
        num++;
      }
    }
    AUIGrid.addRow(serialGrid, rowList, rowPos);
  }

  function fn_itempopList_T(data) {
    var itm_temp = "";
    var itm_qty = 0;
    var itmdata = [];
    for (var i = 0; i < data.length; i++) {
      if (data[i].item.serialchk == 'Y') {
        itm_qty = itm_qty + data[i].item.indelyqty;
        $("#reqstno").val(data[i].item.reqstno);
      }
    }
    $("#serialqty").val(itm_qty);

    f_addrow();
  }

  function f_addrow() {
    var rowPos = "last";
    var item = new Object();
    item = {
      "itmcd" : "",
      "itmname" : "",
      "serial" : "",
      "cnt61" : "",
      "cnt62" : "",
      "cnt63" : "",
      "statustype" : "",
      "scanno" : ""
    };
    AUIGrid.addRow(serialGrid, item, rowPos);
    return false;
  }

  function giFunc() {
    var data = {};
    var checkdata = AUIGrid.getCheckedRowItemsAll(listGrid);
    var check = AUIGrid.getCheckedRowItems(listGrid);
    //var serials   = AUIGrid.getAddedRowItems(serialGrid);
    var serials = AUIGrid.getGridData(serialGrid);

    if (serialchk) {
      if ($("#ascyn").val() == "Y") {
        console.log('111');
      } else {
        for (var i = 0; i < AUIGrid.getRowCount(serialGrid); i++) {
          if (AUIGrid.getCellValue(serialGrid, i, "statustype") == 'N') {
            Common.alert("Please check the serial.")
            return false;
          }

          if (AUIGrid.getCellValue(serialGrid, i, "serial") == undefined
              || AUIGrid.getCellValue(serialGrid, i, "serial") == "undefined") {
            Common.alert("Please check the serial.")
            return false;
          }
        }
      }
      if ($("#serialqty").val() != AUIGrid.getRowCount(serialGrid)) {
        Common.alert("Please check the serial.")
        return false;
      }
    }

    if ($("#giptdate").val() == "") {
      Common.alert("Please select the GI Posting Date.");
      $("#giptdate").focus();
      return false;
    }

    if ($("#giptdate").val() < today) {
        Common.alert("Cannot select back date.");
        $("#giptdate").focus();
        return false;
      }

    if ($("#giptdate").val() > today) {
        Common.alert("Cannot select future date.");
        $("#giptdate").focus();
        return false;
      }

    if ($("#gipfdate").val() == "") {
      Common.alert("Please select the GI Doc Date.");
      $("#gipfdate").focus();
      return false;
    }

    if ($("#gipfdate").val() < today) {
    	Common.alert("Cannot select back date.");
        $("#gipfdate").focus();
        return false;
      }

    if ($("#gipfdate").val() > today) {
    	Common.alert("Cannot select future date.");
        $("#gipfdate").focus();
        return false;
      }

    data.check = check;
    data.checked = check;
    data.add = serials;
    data.form = $("#giForm").serializeJSON();

    Common.ajax("POST",
        "/logistics/stockMovement/StockMovementReqDelivery.do", data,
        function(result) {
          if ("dup" == result.data[1]) {
            Common.alert(" Not enough Qty, Please search again. ");
            $("#giopenwindow").hide();
          } else {
            var msg = result.message + "<br>MDN NO : "
                + result.data[1];
            Common.alert(msg, SearchListAjax);
            AUIGrid.resetUpdatedItems(listGrid, "all");
            $("#giopenwindow").hide();
            $('#search').click();

          }

        }, function(jqXHR, textStatus, errorThrown) {
          try {
          } catch (e) {
          }
          Common.alert("Fail : " + jqXHR.responseJSON.message);
        });
    for (var i = 0; i < checkdata.length; i++) {
      AUIGrid.addUncheckedRowsByIds(listGrid, checkdata[i].rnum);
    }

    serialchk = false;
  }

  function fn_serialChck(rowindex, rowitem, str) {
    var schk = true;
    var ichk = true;
    var slocid = '';//session.locid;
    var checkdata = AUIGrid.getCheckedRowItemsAll(listGrid);

    var data = {
      serial : str,
      locid : slocid
    };
    Common
        .ajaxSync(
            "GET",
            "/logistics/stockMovement/StockMovementSerialCheck.do",
            data,
            function(result) {
              if (result.data[0] == null) {
                AUIGrid.setCellValue(serialGrid, rowindex,
                    "itmcd", "");
                AUIGrid.setCellValue(serialGrid, rowindex,
                    "itmname", "");
                AUIGrid.setCellValue(serialGrid, rowindex,
                    "cnt61", 0);
                AUIGrid.setCellValue(serialGrid, rowindex,
                    "cnt62", 0);
                AUIGrid.setCellValue(serialGrid, rowindex,
                    "cnt63", 0);

                schk = false;
                ichk = false;

              } else {
                AUIGrid.setCellValue(serialGrid, rowindex,
                    "itmcd", result.data[0].STKCODE);
                AUIGrid.setCellValue(serialGrid, rowindex,
                    "itmname", result.data[0].STKDESC);
                AUIGrid.setCellValue(serialGrid, rowindex,
                    "cnt61", result.data[0].L61CNT);
                AUIGrid.setCellValue(serialGrid, rowindex,
                    "cnt62", result.data[0].L62CNT);
                AUIGrid.setCellValue(serialGrid, rowindex,
                    "cnt63", result.data[0].L63CNT);

                if (result.data[0].L61CNT > 0
                    || result.data[0].L62CNT == 0) {//} || result.data[0].L63CNT > 0){
                  schk = false;
                } else {
                  schk = true;
                }

                var checkedItems = AUIGrid
                    .getCheckedRowItemsAll(listGrid);

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
                AUIGrid.setCellValue(serialGrid, rowindex,
                    "statustype", 'Y');
              } else {
                AUIGrid.setCellValue(serialGrid, rowindex,
                    "statustype", 'N');
              }

              //Common.alert("Input Serial Number does't exist. <br /> Please inquire a person in charge. " , function(){AUIGrid.setSelectionByIndex(serialGrid, AUIGrid.getRowCount(serialGrid) - 1, 2);});
              AUIGrid.setProp(serialGrid, "rowStyleFunction",
                  function(rowIndex, item) {

                    if (item.statustype == 'N') {
                      return "my-row-style";
                    }
                  });
              AUIGrid.update(serialGrid);

            }, function(jqXHR, textStatus, errorThrown) {
              try {
              } catch (e) {
              }
              Common
                  .alert("Fail : "
                      + jqXHR.responseJSON.message);

            });
  }
</script>
<section id="content">
 <!-- content start -->
 <ul class="path">
  <li><img
   src="${pageContext.request.contextPath}/resources/images/common/path_home.gif"
   alt="Home" /></li>
  <li>logistics</li>
  <li>Movement-Out</li>
 </ul>
 <aside class="title_line">
  <!-- title_line start -->
  <p class="fav">
   <a href="#" class="click_add_on">My menu</a>
  </p>
  <h2>Movement-Out</h2>
 </aside>
 <!-- title_line end -->
 <aside class="title_line">
  <!-- title_line start -->
  <h3>Header Info</h3>
  <ul class="right_btns">
   <c:if test="${PAGE_AUTH.funcView == 'Y'}">
    <li><p class="btn_blue">
      <a id="search"><span class="search"></span>Search</a>
     </p></li>
   </c:if>
   <li><p class="btn_blue">
     <a id="clear"><span class="clear"></span>Clear</a>
    </p></li>
  </ul>
 </aside>
 <!-- title_line end -->
 <section class="search_table">
  <!-- search_table start -->
  <form id="searchForm" name="searchForm" method="post"
   onsubmit="return false;">
   <input type="hidden" id="svalue" name="svalue" /> <input
    type="hidden" id="sUrl" name="sUrl" /> <input type="hidden"
    id="stype" name="stype" /> <input type="hidden" name="rStcode"
    id="rStcode" /> <input type="hidden" name="allChk" id="allChk"
    value="false" />
   <table summary="search table" class="type1">
    <!-- table start -->
    <caption>search table</caption>
    <colgroup>
     <col style="width: 150px" />
     <col style="width: *" />
     <col style="width: 160px" />
     <col style="width: *" />
     <col style="width: 160px" />
     <col style="width: *" />
    </colgroup>
    <tbody>
     <tr>
      <th scope="row">SMO No</th>
      <td><input type="text" class="w100p" id="streq" name="streq">
      </td>
      <th scope="row">Stock Movement Type</th>
      <td><select class="w100p" id="sttype" name="sttype"></select>
      </td>
      <th scope="row">Movement Type</th>
      <td><select class="w100p" id="smtype" name="smtype"><option
         value=''>Choose One</option></select></td>
     </tr>
     <tr>
      <th scope="row">From Location</th>
      <td>
       <!-- <select class="w100p" id="tlocation" name="tlocation"></select> -->
       <input type="hidden" id="flocation" name="flocation"> <input
       type="text" class="w100p" id="flocationnm" name="flocationnm">
      </td>
      <th scope="row">To Location</th>
      <td>
       <!-- <select class="w100p" id="flocation" name="flocation"></select> -->
       <input type="hidden" id="tlocation" name="tlocation"> <input
       type="text" class="w100p" id="tlocationnm" name="tlocationnm">
      </td>
      <th scope="row">Ref Doc.No</th>
      <td><input type="text" class="w100p" id="sdocno"
       name="sdocno"></td>
     </tr>
     <tr>
      <th scope="row">Dlvd.Req.Date</th>
      <td>
       <div class="date_set w100p">
        <!-- date_set start -->
        <p>
         <input id="crtsdt" name="crtsdt" type="text"
          title="Create start Date" placeholder="DD/MM/YYYY"
          class="j_date">
        </p>
        <span> To </span>
        <p>
         <input id="crtedt" name="crtedt" type="text"
          title="Create End Date" placeholder="DD/MM/YYYY"
          class="j_date">
        </p>
       </div>
       <!-- date_set end -->
      </td>
      <th scope="row">GI Date</th>
      <td>
       <div class="date_set w100p">
        <!-- date_set start -->
        <p>
         <input id="reqsdt" name="reqsdt" type="text"
          title="Create start Date" value="${searchVal.reqsdt}"
          placeholder="DD/MM/YYYY" class="j_date">
        </p>
        <span> To </span>
        <p>
         <input id="reqedt" name="reqedt" type="text"
          title="Create End Date" value="${searchVal.reqedt}"
          placeholder="DD/MM/YYYY" class="j_date">
        </p>
       </div>
       <!-- date_set end -->
      </td>
      <td colspan="2">&nbsp;</td>
     </tr>
     <tr>
      <th scope="row">Status</th>
      <td><select class="w100p" id="sstatus" name="sstatus"></select>
      </td>
      <th scope="row">Auto / Manual</th>
      <td><select class="w100p" id="sam" name="sam"></select></td>
      <th scope="row">Sales Order No.</th>
      <td><input type="text" class="w100p" id="ordno" name="ordno"></td>
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
   <li><p class="btn_grid">
     <a id="delivery">DELIVERY</a>
    </p></li>
  </ul>
  <div id="main_grid_wrap" class="mt10" style="height: 450px"></div>
 </section>
 <!-- search_result end -->
 <div class="popup_wrap" id="giopenwindow" style="display: none">
  <!-- popup_wrap start -->
  <header class="pop_header">
   <!-- pop_header start -->
   <h1>Serial Check</h1>
   <ul class="right_opt">
    <li><p class="btn_blue2">
      <a id="serialclose">CLOSE</a>
     </p></li>
   </ul>
  </header>
  <!-- pop_header end -->
  <section class="pop_body">
   <!-- pop_body start -->
   <form id="giForm" name="giForm" method="POST">
    <input type="hidden" name="gtype" id="gtype" value="GI" /> <input
     type="hidden" name="serialqty" id="serialqty" /> <input
     type="hidden" name="reqstno" id="reqstno" /> <input type="hidden"
     name="prgnm" id="prgnm" value="${param.CURRENT_MENU_CODE}" /> <input
     type="hidden" name="ascyn" id="ascyn" value="" />
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
       <th scope="row">GI Posting Date</th>
       <!-- <td ><input id="giptdate" name="giptdate" type="text" title="Create start Date" value="" readonly/></td> -->
       <td><input id="giptdate" name="giptdate" type="text"
        title="Create start Date" placeholder="DD/MM/YYYY"
        class="j_date" /></td>
       <th scope="row">GI Doc Date</th>
       <td><input id="gipfdate" name="gipfdate" type="text"
        title="Create start Date" placeholder="DD/MM/YYYY"
        class="j_date" /></td>
      </tr>
      <tr>
       <th scope="row">Header Text</th>
       <td colspan='2'><input type="text" name="doctext"
        id="doctext" class="w100p" maxlength="50" /></td>
       <td><p class="btn_blue">
         <a id="ascall"><span class="search"></span>Auto Serial Call</a>
        </p></td>
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
    <article class="grid_wrap" id="serial_grid_wrap_div">
     <!-- grid_wrap start -->
     <div id="serial_grid_wrap" class="mt10" style="width: 100%;"></div>
    </article>
    <!-- grid_wrap end -->
    <ul class="center_btns">
     <c:if test="${PAGE_AUTH.funcChange == 'Y'}">
      <li><p class="btn_blue2 big">
        <a onclick="javascript:giFunc();">SAVE</a>
       </p></li>
     </c:if>
    </ul>
   </form>
  </section>
 </div>
 <form id='popupForm'>
  <input type="hidden" id="sUrl" name="sUrl"> <input
   type="hidden" id="svalue" name="svalue">
 </form>
</section>
