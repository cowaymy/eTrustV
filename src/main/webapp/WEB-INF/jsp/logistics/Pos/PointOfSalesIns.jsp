<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<!--
 DATE        BY     VERSION        REMARK
 ----------------------------------------------------------------
 09/10/2019  ONGHC  1.0.0          AMEND FOR LATEST CHANGES
 -->

<script type="text/javascript"
 src="${pageContext.request.contextPath}/resources/js/combodraw.js"></script>
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

.aui-grid-link-renderer1 {
  text-decoration:underline;
  color: #4374D9 !important;
  cursor: pointer;
  text-align: right;
}

/* 커스텀 열 스타일 */
.my-column-style2 {
    background:#FFEBFE;
    color:#0000ff;
}

/*
  .my-row-style {
    background:#9FC93C;
    font-weight:bold;
    color:#22741C;
  } */
</style>

<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery.blockUI.min.js"></script>
<script type="text/javaScript" language="javascript">
  var resGrid;
  var reqGrid;
  var userCode;
  var UserBranchId;
  var checkedItems;
  var itm_qty = 0;
  var searchReqType;

  var rescolumnLayout = [ {
    dataField : "rnum",
    headerText : "<spring:message code='log.head.rnum'/>",
    width : 120,
    height : 30,
    visible : false
  }, {
    dataField : "codeName",
    headerText : "<spring:message code='log.head.materialtype'/>",
    width : 120,
    height : 30,
    visible : true
  }, {
    dataField : "stkCode",
    headerText : "<spring:message code='log.head.materialcode'/>",
    width : 120,
    height : 30,
    visible : true
  }, {
    dataField : "stkDesc",
    headerText : "<spring:message code='log.head.text'/>",
    width : 120,
    height : 30,
    visible : true
  }, {
    dataField : "qty",
    headerText : "<spring:message code='log.head.availableqty'/>",
    width : 120,
    height : 30,
    style: "aui-grid-user-custom-right",
    visible : true
  }, {
    dataField : "serialChk",
    headerText : "<spring:message code='log.head.serial'/>",
    width : 120,
    height : 30,
    visible : true
  }, {
    dataField : "uom",
    headerText : "<spring:message code='log.head.uom'/>",
    width : 120,
    height : 30,
    visible : false
  } , {
	    dataField : "serialRequireChkYn",
	    headerText : "serialRequireChkYn",
	    width : 120,
	    height : 30,
	    visible : false
  }, {
      dataField : "whLocId",
      headerText : "whLocId",
      width : 120,
      height : 30,
      visible : false
  }, {
    dataField : "whLocGb",
    headerText : "whLocGb",
    width : 120,
    height : 30,
    visible : false
  }];

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

  var reqcolumnLayout;

  var resop = {
    rowIdField : "rnum",
    // 페이지 설정
    usePaging : true,
    pageRowCount : 20,
    editable : false,
    noDataMessage : gridMsg["sys.info.grid.noDataMessage"],
    //enableSorting : true,
    //selectionMode : "multipleRows",
    //selectionMode : "multipleCells",
    //  useGroupingPanel : true,
    // 체크박스 표시 설정
    showRowCheckColumn : true,
    // 전체 체크박스 표시 설정
    showRowAllCheckBox : true,
    softRemoveRowMode : false
  };
  var reqop = {
    rowIdField : "itmrnum",
    editable : true,
    softRemoveRowMode : false,
    showRowCheckColumn : true,
    // 체크박스 표시 설정
    // 전체 체크박스 표시 설정
    //showRowAllCheckBox : true,
    //displayTreeOpen : true,
    //showRowCheckColumn : true ,
    //enableCellMerge : true,
    //showStateColumn : false,
    //showBranchOnGrouping : false
  };

  var serialop = {
    editable : true
    //rowIdField : "rnum",
    //displayTreeOpen : true,
    //showRowCheckColumn : true ,
    //enableCellMerge : true,
    //showStateColumn : false,
    //showBranchOnGrouping : false
  };

  //var uomlist = f_getTtype('42' , '');

  var uomlist = [ {
    code : "EA",
    codeId : 71,
    codeName : "Each"
  }, {
    code : "PCS",
    codeId : 72,
    codeName : "Piece"
  }, {
    code : "OTH",
    codeId : 75,
    codeName : "Others"
  }, {
    code : "SET",
    codeId : 74,
    codeName : "Set"
  }, {
    code : "PKT",
    codeId : 73,
    codeName : "Packet"
  } ];

  /*var comboDatas = [ {
    "codeId" : "OI",
    "codeName" : "OH_GI"
  }, {
    "codeId" : "OG",
    "codeName" : "OH_GR"
  } ];*/

  // var paramdata;

  $(document).ready(function() {
    /**********************************
     * Header Setting
     ***********************************/
    SearchSessionAjax();
    $('#reqadd').hide();

    $('#m1').hide();
    $('#m2').show();
    $('#m3').show();
    $('#m4').show();
    $('#m5').show();
    $('#m6').show();
    $('#m7').show();
    $('#m8').show();
    $('#m9').show();
    $('#m10').show();

    $('#m11').show();
    $('#m14').show();

    // var paramdatas = { groupCode : '306' ,Codeval: 'OH' , orderValue : 'CODE' , likeValue:''};
    // doGetComboData('/common/selectCodeList.do', paramdatas, '','smtype', 'S' , '');
    //var paramdata = { groupCode : '308' , orderValue : 'CODE' , likeValue:'OH'};

    var LocData = {
      sLoc : UserCode
    };
    var LocData2 = {
      brnch : UserBranchId
    };
    var paramdata2 = {
      stkGrade : $("#locationType").val()
    };
    //doGetComboData('/common/selectCodeList.do', paramdata, '','insReqType', 'S' , '');
    //doGetComboCodeId('/common/selectStockLocationList.do',LocData, '','insReqLoc', 'S' , 'f_LocMultiCombo');
    //doGetComboCodeId('/common/selectStockLocationList.do',LocData2, '','insReqLoc', 'S' , 'f_LocMultiCombo');

    //doGetComboCodeId('/common/selectStockLocationList.do', paramdata2, '', 'insReqLoc', 'S', 'f_LocMultiCombo'); // REQUEST LOCATION
    doGetCombo('/common/selectCodeList.do', '15', '', 'PosItemType', 'M', 'f_multiCombo'); // ITEM TYPE
    doGetCombo('/common/selectCodeList.do', '11', '', 'catetype', 'M', 'f_multiCombos'); // CATEGORY

    //doDefCombo(comboDatas, '', 'insTransType', 'S', ''); // TRANSACTION TYPE

    doSysdate(0, 'insReqDate'); // SET TODAY'S DATE TO REQEST DATE


    // $("#giopenwindow").hide();
    // **********************************
    // * Header Setting End
    // ***********************************/

    reqcolumnLayout = [
    {
      dataField : "itmrnum",
      headerText : "<spring:message code='log.head.rnum'/>",
      width : 120,
      height : 30,
      visible : false
    },
    {
      dataField : "itmcode",
      headerText : "<spring:message code='log.head.code'/>",
      width : 120,
      height : 30,
      editable : false
    },
    {
      dataField : "itmdesc",
      headerText : "<spring:message code='log.head.text'/>",
      width : 120,
      height : 30,
      editable : false
    },
    {
      dataField : "itemqty",
      headerText : "<spring:message code='log.head.availableqty'/>",
      width : 120,
      height : 30,
      editable : false,
      style: "aui-grid-user-custom-right",
      styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField){
          if(item.serialRequireChkYn== "Y" && item.itemserialChk== "Y") {
              return "aui-grid-link-renderer1";
          }
      },
    },
    /* {dataField: "rqty",headerText :"<spring:message code='log.head.requestqty'/>"       ,width:120    ,height:30 }, */
    {
      dataField : "rqty",
      headerText : "<spring:message code='log.head.requestqty'/>",
      width : 120,
      height : 30,
      editable : true,
      dataType : "numeric",
      headerStyle : "aui-grid-header-input-icon aui-grid-header-input-essen",
      style: "aui-grid-user-custom-right",
      styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField){
          if(item.serialRequireChkYn== "Y" && item.itemserialChk== "Y") {
              return "aui-grid-link-renderer1";
          } else{
        	  return "my-column-style2";
          }
      },
      editRenderer : {
        type : "InputEditRenderer",
        onlyNumeric : true, // 0~9 까지만 허용
        allowPoint : false
      // onlyNumeric 인 경우 소수점(.) 도 허용
      }
    },
    {
      dataField : "itemserialChk",
      headerText : "<spring:message code='log.head.serial'/>",
      width : 120,
      height : 30,
      editable : false
    },
    {
      dataField : "itemuom",
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
    }, {
        dataField : "serialRequireChkYn",
        headerText : "serialRequireChkYn",
        width : 120,
        height : 30,
        visible : false
  }, {
      dataField : "whLocId",
      headerText : "whLocId",
      width : 120,
      height : 30,
      visible : false
  }, {
    dataField : "whLocGb",
    headerText : "whLocGb",
    width : 120,
    height : 30,
    visible : false
  }];

    resGrid = GridCommon.createAUIGrid("res_grid_wrap", rescolumnLayout, "", resop);
    reqGrid = GridCommon.createAUIGrid("req_grid_wrap", reqcolumnLayout, "", reqop);
    // serialGrid = AUIGrid.create("#serial_grid_wrap", serialcolumn, serialop);

    AUIGrid.bind(resGrid, "cellEditEnd", function(event) {});
    AUIGrid.bind(reqGrid, "cellEditEnd", function(event) {
      if (event.dataField == "rqty") {
        if (AUIGrid.getCellValue(reqGrid, event.rowIndex, "rqty") > AUIGrid.getCellValue(reqGrid, event.rowIndex, "itemqty")) {
          Common.alert('The requested quantity is up to ' + AUIGrid.getCellValue(reqGrid, event.rowIndex, "itemqty") + '.');
          return false;
        }
      }

      if (event.dataField == "itmcode") {
        $("#svalue").val(AUIGrid.getCellValue(reqGrid, event.rowIndex, "itmcd"));
        $("#sUrl").val("/logistics/material/materialcdsearch.do");
        Common.searchpopupWin("popupForm", "/common/searchPopList.do", "stocklist");
      }
    });

    AUIGrid.bind(reqGrid, "cellEditEnd", function(event) {
      var serialChkFlag = AUIGrid.getCellValue(reqGrid, event.rowIndex, "itemserialChk");
      if (event.dataField != "rqty") {
        return false;
      } else {
        var del = AUIGrid.getCellValue(reqGrid, event.rowIndex, "rqty");
        if (del > 0) {
          if ((Number(AUIGrid.getCellValue(reqGrid, event.rowIndex, "itemqty")) < Number(AUIGrid.getCellValue(reqGrid, event.rowIndex, "rqty")))
           || (Number(AUIGrid.getCellValue(reqGrid, event.rowIndex, "itemqty")) < Number(AUIGrid.getCellValue(reqGrid, event.rowIndex, "rqty")))) {
            Common.alert('Available Qty can not be greater than Request Qty.');
            //AUIGrid.getCellValue(listGrid, event.rowIndex, "reqstqty")
            AUIGrid.restoreEditedRows(reqGrid, "selectedIndex");
          } else {
            AUIGrid.addCheckedRowsByIds(reqGrid, event.item.itmrnum);
          }
        } else {
          AUIGrid.restoreEditedRows(reqGrid, "selectedIndex"); AUIGrid.addUncheckedRowsByIds(reqGrid, event.item.rqty);
        }
      }
    });

  //  AUIGrid.bind(serialGrid, "cellEditEnd", function (event) {
  //    var tvalue = true;
  //    var serial = AUIGrid.getCellValue(serialGrid, event.rowIndex, "serial");
  //    serial = serial.trim();
  //    if("" == serial || null == serial) {
  //      alert(" ( " + event.rowIndex + ", " + event.columnIndex + ") : clicked!!");
  //      AUIGrid.setSelectionByIndex(serialGrid,event.rowIndex, event.columnIndex);
  //      Common.alert('Please input Serial Number.');
  //      return false;
  //    } else {
  //      for (var i = 0 ; i < AUIGrid.getRowCount(serialGrid) ; i++) {
  //        if (event.rowIndex != i) {
  //          if (serial == AUIGrid.getCellValue(serialGrid, i, "serial")){
  //            tvalue = false;
  //            break;
  //          }
  //        }
  //      }

  //      if (tvalue) {
  //        fn_serialChck(event.rowIndex ,event.item , serial)
  //      } else {
  //        AUIGrid.setCellValue(serialGrid , event.rowIndex , "statustype" , 'N' );
  //        AUIGrid.setProp(serialGrid, "rowStyleFunction", function(rowIndex, item) {
  //          if (item.statustype  == 'N'){
  //            return "my-row-style";
  //          }
  //        });
  //        AUIGrid.update(serialGrid);
  //      }

  //      if ($("#serialqty").val() > AUIGrid.getRowCount(serialGrid)) {
  //        var serialstus=$("#serialstus").val();
  //        if ($("#serialstus").val() =="Y"){
  //          f_addrow();
  //        }
  //      }

  //    }
  //  });

    AUIGrid.bind(resGrid, "cellClick", function(event) {});
    //AUIGrid.bind(reqGrid, "cellClick", function(event) {});

    // KR-OHK Serial Check add
    AUIGrid.bind(reqGrid, "cellClick", function( event ) {
        var rowIndex = event.rowIndex;
        var dataField = AUIGrid.getDataFieldByColumnIndex(reqGrid, event.columnIndex);
        var serialRequireChkYn = AUIGrid.getCellValue(reqGrid, rowIndex, "serialRequireChkYn");
        var itemserialChk = AUIGrid.getCellValue(reqGrid, rowIndex, "itemserialChk");

        if(dataField == "itemqty"){
            var rowIndex = event.rowIndex;
            if(serialRequireChkYn == "Y" && itemserialChk == "Y"){
                $('#frmSearchSerial #pLocationType').val( AUIGrid.getCellValue(reqGrid, rowIndex, "whLocGb") );
                $('#frmSearchSerial #pLocationCode').val( AUIGrid.getCellValue(reqGrid, rowIndex, "whLocId") );
                $('#frmSearchSerial #pItemCodeOrName').val( AUIGrid.getCellValue(reqGrid, rowIndex, "itmcode") );

                fn_serialSearchPop();
            }
        }

       if(dataField == "rqty"){
           if(serialRequireChkYn == "Y" && itemserialChk == "Y"){
               $("#serialForm #pRequestNo").val(AUIGrid.getCellValue(reqGrid, rowIndex, "reqno"));
               $("#serialForm #pRequestItem").val(AUIGrid.getCellValue(reqGrid, rowIndex, "reqnoitm"));
               $("#serialForm #pStatus").val("I");    // $("#serialForm #pStatus").val("O");
               fn_scanSearchPop();
           }
       }
   });

    AUIGrid.bind(resGrid, "cellDoubleClick", function(event) {});
    AUIGrid.bind(reqGrid, "cellDoubleClick", function(event) {});

    AUIGrid.bind(resGrid, "ready", function(event) {});
    AUIGrid.bind(reqGrid, "ready", function(event) {});

    // KR-OHK Serial Check add
    $("#btnAllDel").click(function(){
        if($(this).parent().hasClass("btn_disabled") == true){
            return false;
        }

        var msg = "Do you want to delete scaned serial of Request No ["+$("#zRstNo").val()+"]?";

        Common
            .confirm(msg,
                function(){
                    var itemDs = {"allYn":"Y"
                            , "rstNo":$("#zRstNo").val()
                            , "locId":$("#zFromLoc").val()
                            , "ioType":$("#zIoType").val()
                            , "transactionType":$("#zTrnscType").val()};

                        Common.ajax("POST", "/logistics/serialMgmtNew/deleteOgOiSerial.do"
                                , itemDs
                                , function(result){
                                    $("#btnPopSearch").click();
                                }
                                , function(jqXHR, textStatus, errorThrown){
                                    try{
                                        if (FormUtil.isNotEmpty(jqXHR.responseJSON)) {
                                            console.log("code : "  + jqXHR.responseJSON.code);
                                            Common.alert("Fail : " + jqXHR.responseJSON.message);
                                        }else{
                                            console.log("Fail Status : " + jqXHR.status);
                                            console.log("code : "        + jqXHR.responseJSON.code);
                                            console.log("message : "     + jqXHR.responseJSON.message);
                                            console.log("detailMessage : "  + jqXHR.responseJSON.detailMessage);
                                        }
                                    }catch (e){
                                        console.log(e);
                                    }
                       });
                }
        );
    });

    $("#btnPopSerial").click(function(){
        if($(this).parent().hasClass("btn_disabled") == true){
            return false;
        }

        if(Common.checkPlatformType() == "mobile") {
            popupObj = Common.popupWin("serialForm", "/logistics/serialMgmtNew/serialScanCommonPop.do", {width : "1000px", height : "720", resizable: "no", scrollbars: "yes"});
        } else{
            Common.popupDiv("/logistics/serialMgmtNew/serialScanCommonPop.do", null, null, true, '_serialScanPop');
        }
    });

    $("#btnPopSearch").click(function(){
    	SearchReqItemListAjax();
    });

  });

  // BUTTON CLICK EVENT
  // SEARCH
  $(function() { $('#search').click(function() {
    if (searchReqType != 'OG53') {
      if (f_validatation('search')) {
        //  $("#slocation").val($("#tlocation").val());
        SearchListAjax();
      }
    } else {
      Common.alert("Click The ADD Button");
    }
  });

  // CHANGE TRANSACTION TYPE TO TRIGGER REQUEST TYPE
  $('#insReqType').change(function() {
    searchReqType = $('#insReqType').val();
    if ('OG53' == searchReqType
     || 'OG51' == searchReqType
     || 'OG71' == searchReqType
     || 'OG72' == searchReqType) {
      $('#lirightBtn').hide();
      $('#reqadd').show();
      AUIGrid.setGridData(resGrid, []);
      AUIGrid.clearGridData(reqGrid);
    } else {
      $('#lirightBtn').show();
      $('#reqadd').hide();
    }

    /*if ("OI21" == searchReqType) {
      $('#m6').show();
    } else {
      $('#m6').show();
    }*/

    if ("OG53" == searchReqType) {
      $('#m11').hide();
    } else {
      $('#m11').show();
    }
  });

  // ADD BUTTON WHEN REQUEST TYPE ARE FOLLOWING
  // OG53, OG51, OG71, OG72
  $('#reqadd').click(function() {
	  // KR-OHK serial Check add
	  if (FormUtil.isEmpty($("#insReqLoc").val())) {
          var text = "<spring:message code='log.label.rqstlct'/>";
          Common.alert("<spring:message code='sys.msg.necessary' arguments='" + text + "' htmlEscape='false'/>");
          return false;
      }

     $("#svalue").val('');
     $("#sUrl").val("/logistics/material/materialcdsearch.do");
     Common.searchpopupWin("popupForm", "/common/searchPopList.do", "stocklist");
  });

  $('#clear').click(function() {});

  $('#save').click(function() {
    var chkfalg;
    var checkDelqty = false;
    var checkedItems = AUIGrid.getCheckedRowItemsAll(reqGrid);
    //  for (var i = 0 ; i < checkedItems.length ; i++){

    //    if (checkedItems[i].itemserialChk == 'Y'){
    //      chkfalg="Y";
    //      break;
    //    } else {
    //      chkfalg ="N";
    //    }

    //  }

    //  if(chkfalg == "Y") {
    //    var checkedItems = AUIGrid.getCheckedRowItems(reqGrid);
    //    var str = "";
    //    var rowItem;
    //    for (var i=0, len = checkedItems.length; i<len; i++) {
    //      rowItem = checkedItems[i];
    //      if(rowItem.item.rqty==0){
    //        str += "Please Check Delivery Qty of  " + rowItem.item.itmcode   + ", " + rowItem.item.itmdesc + "<br />";
    //      checkDelqty= true;
    //    }
    //  }

    //  if (checkDelqty){
    //    var option = {
    //      content : str,
    //      isBig:true
    //    };

    //    Common.alertBase(option);
    //  } else {
    //   $("#giopenwindow").show();
    //     AUIGrid.clearGridData(serialGrid);
    //     AUIGrid.resize(serialGrid);
    //     fn_itemSerialPopList(checkedItems);
    //     //fn_itempopList_T(checkedItems);
    //   }

    // } else {
    if (f_validatation('save')) {
      /*if ($("#fileYn").val() == 'Y') {
        fileSaveAjax();
      } else {
        insPosInfo();
      }*/
      insPosInfo();
    }
    //  }
  });

  $('#reqdel').click(function() {
    AUIGrid.removeCheckedRows(reqGrid);
    //  AUIGrid.removeRow(reqGrid, "selectedIndex");
    //  AUIGrid.removeSoftRows(reqGrid);
  });

  $('#list').click(function() {
    document.location.href = '/logistics/pos/PointOfSalesList.do';
  });

  $("#rightbtn").click(function() {
    checkedItems = AUIGrid.getCheckedRowItemsAll(resGrid);
    var reqitms = AUIGrid.getGridData(reqGrid);
    var bool = true;

    if (checkedItems.length > 0) {
      var rowPos = "first";
      var item = new Object();
      var rowList = [];
      var boolitem = true;
      var k = 0;
      for (var i = 0; i < checkedItems.length; i++) {
        for (var j = 0; j < reqitms.length; j++) {

          if (reqitms[j].itmcode == checkedItems[i].stkCode) {
            boolitem = false;
            break;
          }
        }

        if (boolitem) {
          rowList[k] = {
            itmrnum : checkedItems[i].rnum,
            itmtype : checkedItems[i].codeName,
            itmcode : checkedItems[i].stkCode,
            itmdesc : checkedItems[i].stkDesc,
            itemqty : checkedItems[i].qty,
            itemserialChk : checkedItems[i].serialChk,
            itemuom : checkedItems[i].uom,
            serialRequireChkYn : checkedItems[i].serialRequireChkYn,
            whLocId : checkedItems[i].whLocId,
            whLocGb : checkedItems[i].whLocGb,

            rqty : 0
          }
          k++;
        }

        AUIGrid.addUncheckedRowsByIds(resGrid, checkedItems[i].rnum);
        boolitem = true;
      }

      AUIGrid.addRow(reqGrid, rowList, rowPos);
    }
  });

  $("#attachment").click(function() {
    $("#UploadFilePopUp_wrap").show();
  });

  $("#newUp").click(function() {
    if ("" == $("input[id=fileSelector]").val()) {
      var text = "<spring:message code='log.label.atchmnt'/>";
      Common.alert("<spring:message code='sys.msg.necessary' arguments='" + text + "' htmlEscape='false'/>");
      return false;
    } else {
      $("#fileYn").val('Y');
      $("#UploadFilePopUp_wrap").hide();
      fileSaveAjax(); // REACTIVE BACK THIS FUNCTION
    }
  });

  // ONCHANGE TRANSACTION TYPE
  $("#insTransType").change(function() {
     var trxTyp = $("#insTransType").val();

     // REVERT BACK
     $('#lirightBtn').show();
     $('#reqadd').hide();
     AUIGrid.setGridData(resGrid, []);
     AUIGrid.clearGridData(reqGrid);

     if (trxTyp == "" || trxTyp == null) {
       trxTyp = "-";
     }

     var paramdata = {
       groupCode : '308',
       orderValue : 'CODE_NAME',
       likeValue : trxTyp
     };

     var code = "";
     if (trxTyp == 'OG') { // ADJ. OUT
       code = '433';
     } else if (trxTyp == 'OI') { // ADJ. IN
       code = '434';
     } else {
       code = '-';
     }

     var paramdata2 = {
       groupCode : code,
       orderValue : 'CODE_NAME'
     };

     doGetComboData('/logistics/pos/selectTypeList.do', paramdata, '', 'insReqType', 'S', '');
     doGetComboData('/logistics/pos/selectAdjRsn.do', paramdata2, '', 'insAdjRsn', 'S', '');
    });
  });

  // CHANGE LOCATION
  function fn_changeLocation() {
    //var paramdata2 = {
      //stkGrade : $("#locationType").val()
    //};
    //doGetComboCodeId('/common/selectStockLocationList.do', paramdata2, '', 'insReqLoc', 'S', 'f_LocMultiCombo');
  }

  function fn_serialChck(rowindex, rowitem, str) {
    var schk = true;
    var ichk = true;
    var slocid = '';
    //session.locid;
    var data = {
      serial : str,
      locid : slocid
    };

    Common.ajaxSync("GET", "/logistics/pos/PointOfSalesSerialCheck.do", data, function(result) {
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

        if (result.data[0].L62CNT == 0 || result.data[0].L63CNT > 0) {
          schk = false;
        } else {
          schk = true;
        }

        var checkedItems = AUIGrid.getCheckedRowItemsAll(reqGrid);

        for (var i = 0; i < checkedItems.length; i++) {
          if (result.data[0].STKCODE == checkedItems[i].itmcode) {
            // AUIGrid.setCellValue(serialGrid , rowindex , "statustype" , 'Y' );
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

  function f_validatation(v) {
    var text = "";
    if (v == 'search') {
      if ($("#PosItemType").val() == null
        || $("#PosItemType").val() == undefined
        || $("#PosItemType").val() == "") {
        text = "<spring:message code='log.label.itmTyp'/>";
        Common.alert("<spring:message code='sys.msg.necessary' arguments='" + text + "' htmlEscape='false'/>");
        return false;
      }

      if ($("#insReqLoc").val() == null
       || $("#insReqLoc").val() == undefined
       || $("#insReqLoc").val() == "") {
        text = "<spring:message code='log.label.rqstlct'/>";
        Common.alert("<spring:message code='sys.msg.necessary' arguments='" + text + "' htmlEscape='false'/>");
        return false;
      }
    }
    if (v == 'save') {
      if ($("#insTransType").val() == "") {
        text = "<spring:message code='log.label.trxTyp'/>";
        Common.alert("<spring:message code='sys.msg.necessary' arguments='" + text + "' htmlEscape='false'/>");
        $("#insTransType").focus();
          return false;
      }
      if ($("#insReqType").val() == "") {
        text = "<spring:message code='log.label.rqstTyp'/>";
        Common.alert("<spring:message code='sys.msg.necessary' arguments='" + text + "' htmlEscape='false'/>");
        $("#insReqType").focus();
        return false;
      }
      if ($("#insReqDate").val() == "") {
        text = "<spring:message code='log.label.rqstDt'/>";
        Common.alert("<spring:message code='sys.msg.necessary' arguments='" + text + "' htmlEscape='false'/>");
        $("#insReqDate").focus();
        return false;
      }
      if ($("#insRequestor").val() == "") {
        text = "<spring:message code='log.label.rqster'/>";
        Common.alert("<spring:message code='sys.msg.necessary' arguments='" + text + "' htmlEscape='false'/>");
        $("#insRequestor").focus();
        return false;
      }
      if ($("#insReqLoc").val() == "") {
        text = "<spring:message code='log.label.rqstlct'/>";
        Common.alert("<spring:message code='sys.msg.necessary' arguments='" + text + "' htmlEscape='false'/>");
        $("#insReqLoc").focus();
        return false;
      }
      if ($("#insRemark").val() == "") {
        text = "<spring:message code='log.label.hdrTxt'/>";
        Common.alert("<spring:message code='sys.msg.necessary' arguments='" + text + "' htmlEscape='false'/>");
        return false;
      }
      if ($("#insRemark").val().length > 50) {
        Common.alert("Header Text can be up to 50 digits.");
        return false;
      }
      //if ($('#insReqType').val() == "OI21" && $("#insSmo").val() == "") {
      if ($("#insSmo").val() == "") {
        text = "<spring:message code='log.label.refDocNo'/>";
        Common.alert("<spring:message code='sys.msg.necessary' arguments='" + text + "' htmlEscape='false'/>");
        return false;
      }
      if ($("#insAdjRsn").val() == "") {
        text = "<spring:message code='log.label.adjRsn'/>";
        Common.alert("<spring:message code='sys.msg.necessary' arguments='" + text + "' htmlEscape='false'/>");
        $("#insAdjRsn").focus();
        return false;
      }

      if ($("#fileYn").val() != 'Y'){
        text = "<spring:message code='log.label.atchmnt'/>";
        Common.alert("<spring:message code='sys.msg.necessary' arguments='" + text + "' htmlEscape='false'/>");
        return false;
      }
    }

    if (v == 'save') {
      var checkedItems = AUIGrid.getCheckedRowItemsAll(reqGrid);
      var reqRowCnt = AUIGrid.getRowCount(reqGrid);
      var checkedRowCnt = checkedItems.length;
      var uncheckedRowCnt = reqRowCnt - checkedRowCnt;
      if (uncheckedRowCnt > 0 || reqRowCnt == 0) {
          //text = "<spring:message code='log.label.rqstQty'/>";
          //Common.alert("<spring:message code='sys.msg.necessary' arguments='" + text + "' htmlEscape='false'/>");
          Common.alert("Please select checkBox."); // KR-OHK
        return false;
      }
      for (var i = 0; i < checkedItems.length; i++) {
        // KR-OHK Serial Check add
    	if (checkedItems[i].serialRequireChkYn != 'Y' || checkedItems[i].itemserialChk != 'Y') {
    	  if (FormUtil.isEmpty(checkedItems[i].rqty) || checkedItems[i].rqty == 0) {
  	        text = "<spring:message code='log.head.requestqty'/>";
  	        Common.alert("["+ checkedItems[i].itmcode + "] <spring:message code='sys.msg.necessary' arguments='" + text + "' htmlEscape='false'/>");
  	        return false;
    	  }
  	    }
        if (checkedItems[i].itemuom == ""
         || checkedItems[i].itemuom == undefined) {
            text = "UOM";
            Common.alert("<spring:message code='sys.msg.necessary' arguments='" + text + "' htmlEscape='false'/>");
          return false;
        }
      }
    }

    //  if (v == 'saveSerial'){
    //    var serialRowCnt = AUIGrid.getRowCount(serialGrid);
    //    var reqcheckedItems = AUIGrid.getCheckedRowItemsAll(reqGrid);
    //    var serialcheckedItems = AUIGrid.getCheckedRowItemsAll(serialGrid);

    //    if(serialRowCnt != itm_qty){
    //      Common.alert("The quantity is not equal Request Qty");
    //      return false;
    //    }

    //    for (var j = 0 ; j < reqcheckedItems.length ; j++){
    //      var bool = false;
    //      if (reqcheckedItems[j].itemserialChk == 'Y'){
    //        for (var i = 0 ; i < AUIGrid.getRowCount(serialGrid) ; i++){
    //          alert(reqcheckedItems[i].itmcode);
    //          if(reqcheckedItems[j].itmcode == AUIGrid.getCellValue(serialGrid , i , "itmcd")){
    //            bool = true;
    //            break;
    //          }
    //        }
    //        if(!bool){
    //          Common.alert("The Material Code No Same");
    //          return false;
    //        }
    //      }
    //    }
    //  }

    return true;
  }

  function SearchListAjax() {
    var url = "/logistics/pos/PosItemList.do";
    var param = $('#searchForm').serialize();

    Common.ajax("GET", url, param, function(result) {
      AUIGrid.setGridData(resGrid, result.data);
    });
  }

  // TO GET REQUESTOR NAME
  function SearchSessionAjax() {
    var url = "/logistics/pos/SearchSessionInfo.do";
    Common.ajaxSync("GET", url, '', function(result) {
      UserCode = result.UserCode;
      UserBranchId = result.UserBranchId;
      $("#insRequestor").val(result.UserName);
    });
  }

  function f_multiCombo() {
    $(function() {
      $('#PosItemType').change(function() {
      }).multipleSelect({
        selectAll : true,
        width : '100%'
      })
    });
  }

  function f_multiCombos() {
    $(function() {
      $('#catetype').change(function() {
      }).multipleSelect({
        selectAll : true,
        width : '100%'
      })
    });
  }

  function f_LocMultiCombo() {
    $(function() {
      $('#insReqLoc').change(function() {
        $("#reqLoc").val($("#insReqLoc").val());
      });
    });
  }

  function fn_itemSerialPopList(data) {
    checkedItems = AUIGrid.getCheckedRowItemsAll(reqGrid);

    var rowPos = "first";
    var rowList = [];
    var reqQty;
    var item = new Object();
    var itm_qty = 0;

    for (var i = 0; i < data.length; i++) {
      if (data[i].item.itemserialChk == 'Y') {
        reqQty = data[i].item.rqty;
        itm_qty += parseInt(reqQty)
      }
    }
    $("#serialqty").val(itm_qty);
    f_addrow();
  }

  function fn_itempopList(data) {
    var rowPos = "first";
    var rowList = [];

    var reqitms = AUIGrid.getGridData(reqGrid);

    //  AUIGrid.removeRow(reqGrid, "selectedIndex");
    //  AUIGrid.removeSoftRows(reqGrid);
    //  for (var i = 0 ; i < data.length ; i++){
    //    rowList[i] = {
    //      //itmid : data[i].item.itemid,
    //      itmcode : data[i].item.itemcode,
    //      itmdesc : data[i].item.itemname,
    //      itemserialChk : data[i].item.serialchk,
    //      itemuom       : data[i].item.uom
    //    }
    //  }

    if (data.length > 0) {
      var rowPos = "first";
      var item = new Object();
      var rowList = [];
      var boolitem = true;
      var k = 0;
      // KR-OHK Serial Check add'
      var serialChk = 'N';
      var serialRequireChkYn = 'N';
      var serialPdChk = 'N';
      var serialFtChk = 'N';
      var serialPtChk = 'N';

      for (var i = 0; i < data.length; i++) {
        for (var j = 0; j < reqitms.length; j++) {
          if (reqitms[j].itmcode == data[i].item.itemcode) {
            Common.alert("Product number already selected.");
            boolitem = false;
            break;
          }
        }

        serialRequireChkYn = $("#serialRequireChkYn").val();
        serialPdChk = $("#serialPdChk").val();
        serialFtChk = $("#serialFtChk").val();
        serialPtChk = $("#serialPtChk").val();

        if(data[i].item.typeid == '61' && data[i].item.serialchk == 'Y' && serialPdChk == 'Y') {
        	serialChk = 'Y';
        } else if(data[i].item.typeid == '62' && data[i].item.serialchk == 'Y' && serialFtChk == 'Y') {
        	serialChk = 'Y';
        }else if(data[i].item.typeid == '63' && data[i].item.serialchk == 'Y' && serialPtChk == 'Y') {
        	serialChk = 'Y';
        } else {
        	serialChk = 'N';
        }

        if (boolitem) {
          rowList[k] = {
            itmcode : data[i].item.itemcode,
            itmdesc : data[i].item.itemname,
            //itemserialChk : data[i].item.serialchk,
            itemserialChk : serialChk,                     // KR-OHK add
            serialRequireChkYn : serialRequireChkYn,   // KR-OHK add
            itemuom : data[i].item.uom,
            rqty : 0

          }
          k++;
        }
        //  else {
        //    return boolitem;
        //  }

        //AUIGrid.addUncheckedRowsByIds(resGrid, checkedItems[i].rnum);
        //boolitem = true;

      }
      AUIGrid.addRow(reqGrid, rowList, rowPos);
    }

    //  AUIGrid.addRow(reqGrid, rowList, rowPos);
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
        Common.alert("Draw ComboBox['" + obj + "'] is failed. \n\n Please try again.");
      },
      complete : function() {
      }
    });

    return rData;
  }

  function fn_itempopList_T(data) {
    var itm_temp = "";
    var itm_qty = 0;
    var itmdata = [];
    for (var i = 0; i < data.length; i++) {
      itm_qty = itm_qty + data[i].item.rqty;
      // $("#reqstno").val(data[i].item.reqstno)
    }

    $("#serialqty").val(itm_qty);
  }

  function f_addrow() {
    var rowPos = "last";
    var item = new Object();
    AUIGrid.addRow(serialGrid, item, rowPos);
    return false;
  }

  function insPosInfo() {
    var data = {};
    var checkdata = AUIGrid.getCheckedRowItemsAll(reqGrid);
    //  var serials = AUIGrid.getAddedRowItems(serialGrid);
    //  console.log(serials);
    //  data.add = serials;
    data.checked = checkdata;
    data.form = $("#headForm").serializeJSON();

    Common.ajaxSync("POST", "/logistics/pos/insertPosInfo.do", data,
      function(result) {
        Common.alert("" + result.message + "</br> Created : " + result.data);
        locationList(result.data);
        //Common.alert(result.message);
        // KR-OHK Serial Check add
        //$("#giopenwindow").hide();
      }, function(jqXHR, textStatus, errorThrown) {
        try {
        } catch (e) {
        }
        Common.alert("Fail : " + jqXHR.responseJSON.message);
      });

    for (var i = 0; i < checkdata.length; i++) {
      AUIGrid.addUncheckedRowsByIds(reqGrid, checkdata[i].itmrnum);
    }
  }

  function fileSaveAjax() {
    var url;
    var formData = new FormData();
    url = "/logistics/pos/insertFile.do";
    formData.append("excelFile", $("input[name=zipUpload]")[0].files[0]);
    formData.append("upId", $("#upId").val());
    Common.ajaxFile(url, formData, function(result) {
      console.log(result)
      $("#keyvalue").val(result.keyvalue);
      $("#fileKeyGrpId").val(result.keyvalue);
      $("#fileName").val(result.list[0].fileName);
      console.log(JSON.stringify(result.list));

      if (result.keyvalue != "") {
        $("#att").prop( "checked", true )
      }

      //insPosInfo();
    });
  }

  function saveSerialInfo() {
    if ($("#fileYn").val() == 'Y') {
      fileSaveAjax();
    } else {
      insPosInfo();
    }

    //  if(f_validatation("save") && f_validatation("saveSerial")){
    //    if(f_validatation("save")){
    //      if ($("#fileYn").val() == 'Y'){
    //        fileSaveAjax();
    //      } else {
    //        insPosInfo();
    //      }
    //    }
    $("#giopenwindow").hide();
  }

  function locationList(reqstNo) {
	// KR-OHK Serial Check add
	$("#zRstNo").val(reqstNo);
	SearchReqItemListAjax();
  }

  function getAdjLoc(){
    Common.popupDiv("/logistics/pos/getAdjLoc.do", {}, null, true);
  }

  function fn_setRqstLoc(itm) {
    if (itm != null) {
      $("#insReqLoc").val(itm.locId);
      $("#insReqLocText").val(itm.locDesc);
      $("#locationType").val(itm.locGrade);
      $("#locationTypeText").val(itm.locGrade);

      $("#reqLoc").val(itm.locId);

      // KR-OHK Serial Check add
      $("#serialRequireChkYn").val(itm.serialRequireChkYn);
      $("#serialPdChk").val(itm.serialPdChk);
      $("#serialFtChk").val(itm.serialFtChk);
      $("#serialPtChk").val(itm.serialPtChk);
    }
  }

  function fn_downloadFile(fileGrpId, fileId) {
    if ($("#keyvalue").val() == "" || $("#keyvalue").val() == null) {
      Common.alert('There are no file to download.');
      return false;
    }
    var data = {
      atchFileGrpId : $("#keyvalue").val()//,
      //atchFileId : fileId
    };

    Common.ajax("GET", "/logistics/pos/getAttch.do", data, function(result) {
      console.log(result);

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

	// KR-OHK Serial Check add
	function SearchReqItemListAjax() {
	    var url = "/logistics/pos/selectReqItemList.do";

	    var param = {"taskType":'INS', "reqstNo":$("#zRstNo").val()};

	    Common.ajax("GET", url, param, function(result) {
	        AUIGrid.setGridData(reqGrid, result);

	        var requireCnt = 0;
            var itemCnt = 0;

            if(result.length > 0) {
                for(var i = 0; i < result.length; i++) {
                    if(result[i].serialRequireChkYn == 'Y') {// SERIAL_REQUIRE_CHK_YN
                        requireCnt ++;
                    }
                    if(result[i].itemserialChk == 'Y') {// ITEM SERIAL CHECK YN
                        itemCnt ++;
                    }
                }
            }

            if(requireCnt > 0 && itemCnt > 0) {
            	$("#zRstNo").val(result[0].reqno);
            	$("#zFromLoc").val(result[0].whLocId);
                $("#zTrnscType").val(result[0].trnscType);
            	$("#zIoType").val(result[0].ioType);

            	$("#insOthersReq").val(result[0].reqno);

            	$("#btnPopSerial").attr("style", "");
                $("#btnAllDel").attr("style", "");

                $("#save").parent().addClass("btn_disabled");
            } else {
            	$('#list').click();
                $("#giopenwindow").hide();
            }
	    });
	}

	//Serial Scan Search Pop
	function fn_scanSearchPop(){
	    if(Common.checkPlatformType() == "mobile") {
	        popupObj = Common.popupWin("serialForm", "/logistics/SerialMgmt/scanSearchPop.do", {width : "1000px", height : "1000px", height : "720", resizable: "no", scrollbars: "yes"});
	    } else{
	        Common.popupDiv("/logistics/SerialMgmt/scanSearchPop.do", $("#serialForm").serializeJSON(), null, true, '_scanSearchPop');
	    }
	}

	//Serial Search Pop
	function fn_serialSearchPop(){
	    Common.popupWin("frmSearchSerial", "/logistics/SerialMgmt/serialSearchPop.do", {width : "1000px", height : "580", resizable: "no", scrollbars: "no"});
	}

	function fnSerialSearchResult(data) {
	    data.forEach(function(dataRow) {
	        console.log("serialNo : " + dataRow.serialNo);
	    });
	}

</script>
<section id="content">
 <!-- content start -->
 <ul class="path">
  <li><img
   src="${pageContext.request.contextPath}/resources/images/common/path_home.gif"
   alt="Home" /></li>
  <li><spring:message code='log.title.log'/></li>
  <li><spring:message code='log.title.othRqst'/></li>
 </ul>
 <aside class="title_line">
  <!-- title_line start -->
  <p class="fav">
   <a href="#" class="click_add_on">My menu</a>
  </p>
  <h2><spring:message code='log.title.othRqst'/></h2>
 </aside>
 <!-- title_line end -->
 <aside class="title_line">
  <!-- title_line start -->
  <h3><spring:message code='log.title.hdrInfo'/></h3>
 </aside>
 <!-- title_line end -->
 <section class="search_table">
  <!-- search_table start -->
    <form id="frmSearchSerial" name="frmSearchSerial" method="post">
       <input id="pGubun" name="pGubun" type="hidden" value="SEARCH" />
       <input id="pFixdYn" name="pFixdYn" type="hidden" value="N" />
       <input id="pLocationType" name="pLocationType" type="hidden" value="" />
       <input id="pLocationCode" name="pLocationCode" type="hidden" value="" />
       <input id="pItemCodeOrName" name="pItemCodeOrName" type="hidden" value="" />
       <input id="pStatus" name="pStatus" type="hidden" value="" />
       <input id="pSerialNo" name="pSerialNo" type="hidden" value="" />
   </form>
   <form id="serialForm" name="serialForm" method="POST">
       <input type="hidden" name="zTrnscType" id="zTrnscType"/>
       <input type="hidden" name="zRstNo" id="zRstNo"/>
       <input type="hidden" name="zFromLoc" id="zFromLoc"/>
       <input type="hidden" name="zIoType" id="zIoType"/>
       <input type="hidden" name="pRequestNo" id="pRequestNo" />
       <input type="hidden" name="pRequestItem" id="pRequestItem" />
       <input type="hidden" name="pStatus" id="pStatus" />
   </form>
  <form id="headForm" name="headForm" method="post">
   <input type='hidden' id='pridic' name='pridic' value='M' /> <input
    type='hidden' id='headtitle' name='headtitle' value='SOH' /> <input
    type="hidden" id="keyvalue" name="keyvalue" />
   <input type="hidden" name="serialRequireChkYn" id="serialRequireChkYn" />
   <input type="hidden" name="serialPdChk" id="serialPdChk" />
   <input type="hidden" name="serialFtChk" id="serialFtChk" />
   <input type="hidden" name="serialPtChk" id="serialPtChk" />
   <!--<input type='hidden' id='trnscType' name='trnscType' value='OH'/> -->
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
      <th scope="row"><spring:message code='log.title.othRqst'/><span id='m1' name='m1' class='must' style='display:none'>*</span></th>
      <td colspan="3">
       <input id="insOthersReq" name="insOthersReq" type="text" title="" placeholder="<spring:message code='log.title.othRqst'/>" class="readonly w100p" readonly="readonly" /></td>
      <th scope="row"><spring:message code='log.label.rqstDt'/><span id='m2' name='m2' class='must' style='display:none'>*</span></th>
      <td colspan="3">
       <input id="insReqDate" name="insReqDate" type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p" />
      </td>
     </tr>
     <tr>
      <th scope="row"><spring:message code='log.label.trxTyp'/><span id='m3' name='m3' class='must' style='display:none'>*</span></th>
      <td colspan="3">
       <select class="w100p" id="insTransType" name="insTransType">
        <option value=''><spring:message code='sal.combo.text.chooseOne'/></option>
        <c:forEach var="list" items="${trxTyp}" varStatus="status">
          <option value="${list.codeId}">${list.codeName}</option>
        </c:forEach>
       </select>
      </td>
      <th scope="row"><spring:message code='log.label.rqstTyp'/><span id='m4' name='m4' class='must' style='display:none'>*</span></th>
      <td colspan="3">
       <select class="w100p" id="insReqType" name="insReqType">
        <option value=''><spring:message code='sal.combo.text.chooseOne'/></option>
       </select>
      </td>
     </tr>
     <tr>
      <th scope="row"><spring:message code='log.label.rqster'/><span id='m5' name='m5' class='must' style='display:none'>*</span></th>
      <td colspan="3">
       <input id="insRequestor" name="insRequestor" type="text" title="" placeholder="<spring:message code='log.label.rqster'/>" class="readonly w100p" readonly="readonly" />
      </td>
      <th scope="row"><spring:message code='log.label.refDocNo'/><span id='m6' name='m6' class='must' style='display:none'>*</span></th>
      <td colspan="3">
       <input id="insSmo" name="insSmo" type="text" title="" placeholder="<spring:message code='log.label.refDocNo'/>" class="w100p" maxlength="16" />
      </td>
     </tr>
     <tr>
      <th scope="row">
       <spring:message code='log.label.rqstlct'/><span id='m7' name='m7' class='must' style='display:none'>*</span>
      </th>
      <td colspan="2">
       <!-- <select class="w100p" id="insReqLoc" name="insReqLoc"></select>  -->
       <input type="hidden" id="insReqLoc" name="insReqLoc" title="" placeholder="<spring:message code='log.label.rqstlct'/>" />
       <input id="insReqLocText" name="insReqLocText" type="text" title="" placeholder="<spring:message code='log.label.rqstlct'/>" class="w100p readonly" />
      </td>
      <td><a class="search_btn" id="src" name="src" onclick="getAdjLoc()"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a></td>
      <th scope="row"><spring:message code='log.label.lctTyp'/><span id='m8' name='m8' class='must' style='display:none'>*</span></th>
      <td colspan="3">
       <!-- <select class="w100p readonly" id="locationType" name="locationType" onchange="fn_changeLocation()" disabled>
        <option value=""><spring:message code='sal.combo.text.chooseOne'/></option>
        <option value="A">A</option>
        <option value="B">B</option>
       </select>  -->
       <input type="hidden" id="locationType" name="locationType" title="" placeholder="<spring:message code='log.label.lctTyp'/>" />
       <input id="locationTypeText" name="locationTypeText" type="text" title="" placeholder="<spring:message code='log.label.lctTyp'/>" class="w100p readonly" />
      </td>
     </tr>
     <tr>
      <th scope="row"><spring:message code='log.label.hdrTxt'/><span id='m9' name='m9' class='must' style='display:none'>*</span></th>
      <td colspan="7">
       <input id="insRemark" name="insRemark" type="text" title="" placeholder="<spring:message code='log.label.hdrTxt'/>" class="w100p" maxlength="50" />
      </td>
     </tr>
     <tr>
      <th scope="row"><spring:message code='log.label.rmk'/><span id='m10' name='m10' class='must' style='display:none'>*</span></th>
      <td colspan="7">
       <textarea cols="20" name="insRemark2" id="insRemark2" rows="5" placeholder="<spring:message code='log.label.rmk'/>"></textarea>
      </td>
     </tr>
     <tr>
      <th scope="row"><spring:message code='log.label.adjRsn'/><span id='m15' name='m15' class='must'>*</span></th>
      <td colspan="7">
       <select class="w100p" id="insAdjRsn" name="insAdjRsn">
        <option value=''><spring:message code='sal.combo.text.chooseOne'/></option>
       </select>
      </td>
     </tr>
    </tbody>
   </table>
   <!-- table end -->
  </form>
 </section>
 <!-- search_table end -->
 <aside class="title_line">
  <!-- title_line start -->
  <h3><spring:message code='log.title.itmInfo'/></h3>
  <ul class="right_btns">
   <%-- <c:if test="${PAGE_AUTH.funcChange == 'Y'}"> --%>
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
   <input type="hidden" id="reqLoc" name="reqLoc">
   <table class="type1">
    <!-- table start -->
    <caption>table</caption>
    <colgroup>
     <col style="width: 140px" />
     <col style="width: *" />
     <col style="width: 140px" />
     <col style="width: *" />
     <col style="width: 140px" />
    </colgroup>
    <tbody>
     <tr>
      <th scope="row"><spring:message code='log.label.itmTyp' /><span id='m11' name='m11' class='must' style='display:none'>*</span></th>
      <td colspan="3">
       <select class="w100p" id="PosItemType" name="PosItemType"></select>
      </td>
      <th scope="row"><spring:message code='log.label.itmCat' /><span id='m12' name='m12' class='must' style='display:none'>*</span></th>
      <td colspan="3">
       <select class="w100p" id="catetype" name="catetype"></select>
      </td>
     </tr>
     <tr>
      <th scope="row"><spring:message code='log.label.mtrlCde' /><span id='m13' name='m13' class='must' style='display:none'>*</span></th>
      <td colspan="3">
       <input type="text" class="w100p" id="materialCode" name="materialCode" />
      </td>
      <th scope="row"><spring:message code='log.label.atchmnt' /><span id='m14' name='m14' class='must' style='display:none'>*</span></th>
      <td colspan="3">
       <input type="hidden" name="fileKeyGrpId" id='fileKeyGrpId'/>
       <input type="hidden" name="fileKeyId" id='fileKeyId' />
       <input type="checkbox" name="att" id='att' disabled="disabled" />
       <input type="text" name="fileName" id='fileName' class='readonly' disabled="disabled" />
       <p class="btn_grid">
        <a href="#" onclick="fn_downloadFile()"><spring:message code='pay.btn.download' /></a>
       </p>
      </td>
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
     <h3><spring:message code='log.label.mtrlCde' /></h3>
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
     <h3><spring:message code='log.title.rqstItm' /></h3>
     <ul class="right_btns">
      <li><p class="btn_blue2">
        <a id="btnAllDel" style="display:none;">Clear Serial</a>
       </p></li>
      <%-- <c:if test="${PAGE_AUTH.funcChange == 'Y'}"> --%>
      <li><p class="btn_blue2">
        <a id="attachment"><spring:message code='log.label.atchmnt' /></a><input type="hidden"
         id="fileYn" name="fileYn">
       </p></li>
      <%-- </c:if> --%>
     </ul>
    </aside>
    <!-- title_line end -->
    <div class="border_box" style="height: 340px;">
     <!-- border_box start -->
     <ul class="right_btns">
      <%-- <c:if test="${PAGE_AUTH.funcChange == 'Y'}"> --%>
      <li><p class="btn_grid">
        <a id="reqadd"><spring:message code='sys.btn.add' /></a>
       </p></li>
      <li><p class="btn_grid">
        <a id="reqdel"><spring:message code='sys.btn.delete' /></a>
       </p></li>
      <%-- </c:if> --%>
     </ul>
     <article class="grid_wrap">
      <!-- grid_wrap start -->
      <div id="req_grid_wrap"></div>
     </article>
     <!-- grid_wrap end -->
     <ul class="btns">
      <li id="lirightBtn">
       <a id="rightbtn">
        <img src="${pageContext.request.contextPath}/resources/images/common/btn_right2.gif" alt="right" /></a></li>
        <%-- <li><a id="rightbtn"><img src="${pageContext.request.contextPath}/resources/images/common/btn_right2.gif" alt="right" /></a></li> --%>
        <%-- <li><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_left2.gif" alt="left" /></a></li> --%>
     </ul>
    </div>
    <!-- border_box end -->
   </div>
   <!-- 50% end -->
  </div>
  <!-- divine_auto end -->
  <ul class="center_btns mt20">
   <li>
    <p class="btn_blue2 big">
     <a id="list"><spring:message code='sales.Back' /></a>
    </p></li>&nbsp;&nbsp;
   <%-- <c:if test="${PAGE_AUTH.funcChange == 'Y'}"> --%>
   <li>
    <p class="btn_blue2 big">
     <a id="save"><spring:message code='sys.btn.save' /></a>
    </p></li>
    <li>
    <p class="btn_blue2 big">
     <a id="btnPopSerial" style="display:none;">Serial Scan</a>
    </p></li>
    <li style="display:none;"><p class="btn_grid"><a id="btnPopSearch">Search</a></p></li>
   <%-- </c:if> --%>
   <!-- <li><p class="btn_blue2 big"><a id="list">List</a></p></li>&nbsp;&nbsp;<li><p class="btn_blue2 big"><a onclick="javascript:insPosInfo();">SAVE</a></p></li> -->
  </ul>
  <div class="popup_wrap" id="giopenwindow" style="display: none">
   <!-- popup_wrap start -->
   <header class="pop_header">
    <!-- pop_header start -->
    <h1><spring:message code='log.label.serialChk' /></h1>
    <ul class="right_opt">
     <li><p class="btn_blue2">
       <a href="#"><spring:message code='sys.btn.close' /></a>
      </p></li>
    </ul>
   </header>
   <!-- pop_header end -->
   <section class="pop_body">
    <!-- pop_body start -->
    <form id="giForm" name="giForm" method="POST">
     <input type="hidden" name="gtype" id="gtype" value="GI" /> <input
      type="hidden" name="serialqty" id="serialqty" /> <input
      type="hidden" name="serialno" id="serialno" /> <input
      type="hidden" name="serialstus" id="serialstus" />
     <!-- <input type="hidden" name="ttype" id="ttype" value="OH"/> -->
     <!-- <input type="hidden" id="posReqSeq" name="posReqSeq"> -->
     <table class="type1">
      <caption>search table</caption>
      <colgroup id="serialcolgroup">
      </colgroup>
      <tbody id="dBody">
      </tbody>
     </table>
     <!-- <article class="grid_wrap">grid_wrap start -->
     <!-- <div id="serial_grid_wrap" class="mt10" style="width:100%;"></div> -->
     <!-- </article>grid_wrap end -->
     <ul class="center_btns">
      <%-- <c:if test="${PAGE_AUTH.funcChange == 'Y'}"> --%>
      <li><p class="btn_blue2 big">
        <a onclick="javascript:saveSerialInfo();"><spring:message code='sys.btn.save' /></a>
       </p></li>
      <%-- </c:if> --%>
     </ul>
    </form>
   </section>
  </div>
  <div id="UploadFilePopUp_wrap" class="popup_wrap"
   style="display: none;">
   <!-- popup_wrap start -->
   <header class="pop_header">
    <!-- pop_header start -->
    <h1><spring:message code='log.title.updFile' /></h1>
    <ul class="right_opt">
     <li><p class="btn_blue2">
       <a href="#"><spring:message code='sys.btn.close' /></a>
      </p></li>
    </ul>
   </header>
   <!-- pop_header end -->
   <section class="pop_body">
    <!-- pop_body start -->
    <form id="FileSpaceForm2" name="FileSpaceForm2"
     enctype="multipart/form-data">
     <input type="hidden" id="upId" name="upId" />
     <table class="type1">
      <!-- table start -->
      <caption>table</caption>
      <colgroup>
       <col style="width: 160px" />
       <col style="width: *" />
       <col style="width: 160px" />
       <col style="width: *" />
      </colgroup>
      <tbody>
       <tr>
        <th scope="row"><spring:message code='log.label.atchmnt' /></th>
        <td colspan="5">
         <div class="auto_file">
          <!-- auto_file start -->
          <input type="file" id="fileSelector" name="zipUpload"
           title="file add" />
         </div>
         <!-- auto_file end -->
        </td>
       </tr>
      </tbody>
     </table>
     <!-- table end -->
    </form>
    <ul class="center_btns">
     <%-- <c:if test="${PAGE_AUTH.funcChange == 'Y'}"> --%>
     <li><p class="btn_blue2 big">
       <a id="newUp"><spring:message code='sal.title.text.upload' /></a>
      </p></li>
     <%-- </c:if> --%>
    </ul>
   </section>
   <!-- pop_body end -->
  </div>
  <!-- popup_wrap end -->
 </section>
 <!-- search_result end -->
 <form id='popupForm'>
  <input type="hidden" id="sUrl" name="sUrl">
  <input type="hidden" id="svalue" name="svalue">
 </form>
</section>