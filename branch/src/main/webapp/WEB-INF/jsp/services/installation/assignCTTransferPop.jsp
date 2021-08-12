<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<!--
 DATE        BY     VERSION        REMARK
 ----------------------------------------------------------------
 01/07/2020  ONGHC  1.0.0       RE-STRUCTURE JSP.
 -->

<script type="text/javaScript">
  var assignCtListGridID;
  var assignCOrdtListGridID;
  var serialList = new Array();

  $(document).ready(function() {

    createAssignCtListAUIGrid();
    createAssignCtOrderListAUIGrid();

    fn_asaAssignCtList();
    fn_asaAssignCtOderList();
  });

  function createAssignCtListAUIGrid() {

    var columnLayout = [
        {
          dataField : "ctCode",
          headerText : "<spring:message code='service.grid.CTCode'/> ",
          width : 100,
          editable : false
        }, {
          dataField : "ctName",
          headerText : "<spring:message code='service.grid.CTName'/> ",
          width : 120,
          editable : false
        }, {
          dataField : "branchName",
          headerText : "<spring:message code='service.grid.bch'/> ",
          width : 120
        }, {
          dataField : "ctSubGrp",
          headerText : "<spring:message code='service.title.CTGroup'/> ",
          width : 120
        }, {
          dataField : "ctId",
          headerText : "<spring:message code='service.grid.CTCode'/> ",
          width : 120,
          visible : true
        }, {
          dataField : "serialRequireChkYn",
          headerText : "<spring:message code='service.grid.serialCheck'/> ",
          width : 180,
          visible : true,
          editable : false
        }];

    var gridPros = {
      usePaging : true,

      editable : true,
      displayTreeOpen : true,
      headerHeight : 30,
      skipReadonlyColumns : true,
      wrapSelectionMove : true,
      showRowNumColumn : true,
      showRowCheckColumn : true,
      rowCheckToRadio : true
    };
    assignCtListGridID = GridCommon.createAUIGrid("aCtL_grid_wrap", columnLayout, "", gridPros);
  }

  // 체크된 아이템 얻기
  function fn_getAssionCTListCheckedRowItems() {

    var checkedItems = AUIGrid.getCheckedRowItems(assignCtListGridID);

    console.log(checkedItems);

    if (checkedItems.length == 0 || checkedItems == null) {
      Common.alert("<spring:message code='service.msg.selectCT'/> ");
      return false;
    }

    var str = [];
    var rowItem = checkedItems[0].item;

    str[0] = rowItem.ctCode;
    str[1] = rowItem.ctId;
    str[2] = rowItem.serialRequireChkYn;

    return str;
  }

  function createAssignCtOrderListAUIGrid() {

    var columnLayout = [
        {
          renderer : {
            type : "CheckBoxEditRenderer",
            showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
            editable : false, // 체크박스 편집 활성화 여부(기본값 : false)
            checkValue : "1", // true, false 인 경우가 기본
            width : 30,
            unCheckValue : "0",
            // 체크박스 Visible 함수
            checkableFunction : function(rowIndex, columnIndex, value, isChecked, item, dataField) {

              var assiinCd = fn_getAssionCTListCheckedRowItems();
              if (assiinCd == false)
                return false;

              if (assiinCd[2] != item.serialRequireChkYn) {
                Common.alert("<b>'Serial Require Check Y/N' is different.</b>");
                return false;
              }

              if (item.serialRequireChkYn == 'Y' && assiinCd[0] == item.ctCode) {
                Common.alert("<b>You cannot select the current CT Code.</b>");
                return false;
              }

              if (item.c1 == 1) {
                AUIGrid.updateRow(assignCOrdtListGridID, {
                  "memCode" : "",
                  "insstallCtId" : ""
                }, rowIndex);
              } else {
                AUIGrid.updateRow(assignCOrdtListGridID, {
                  "memCode" : assiinCd[0],
                  "insstallCtId" : assiinCd[1]
                }, rowIndex);
              }
              return true;
            }
          }
        }, {
          dataField : "custName",
          headerText : "<spring:message code='service.grid.Customer'/> ",
          width : 150
        }, {
          dataField : "salesOrdNo",
          headerText : "<spring:message code='service.title.SalesOrder'/> ",
          width : 90
        }, {
          dataField : "serialNo",
          headerText : "<spring:message code='service.title.SerialNo'/> ",
          width : 180,
          height : 30,
          headerStyle : "aui-grid-header-input-icon",
          editRenderer : {
            type : "DropDownListRenderer",
            showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 보이기
            listFunction : function(rowIndex, columnIndex, item, dataField) {
              if (item.serialChk == "Y") {
                fn_ctSerialNoList(item);
              } else {
                serialList = null;
              }
              return serialList;
            },
            keyField : "code",
            valueField : "codeName"
          }
        }, {
          dataField : "memCode",
          headerText : "<spring:message code='service.grid.CTCode'/> ",
          width : 80
        }, {
          dataField : "custSubGrp",
          headerText : "<spring:message code='service.title.CTGroup'/> ",
          width : 100
        }, {
          dataField : "insstallCtId",
          headerText : "<spring:message code='service.grid.CTCode'/> ",
          width : 80,
          visible : true
        }, {
          dataField : "ctId",
          headerText : "Previous CT ID",
          width : 100,
          visible : false
        }, {
          dataField : "ctCode",
          headerText : "Previous CT Code",
          width : 100,
          visible : false
        }, {
          dataField : "installEntryNo",
          headerText : "<spring:message code='service.title.InstallationNo'/> ",
          width : 100,
          visible : false
        }, {
          dataField : "stkCode",
          headerText : "<spring:message code='sales.stkCd'/> ",
          width : 80,
          editable : false
        }, {
          dataField : "stkDesc",
          headerText : "<spring:message code='service.grid.Product'/> ",
          width : 180,
          editable : false,
          style : "aui-grid-user-custom-left"
        }, {
          dataField : "serialChk",
          headerText : "<spring:message code='service.grid.serialCheck'/> ",
          width : 80,
          editable : false
        }, {
          dataField : "serialRequireChkYn",
          headerText : "<spring:message code='service.grid.serialCheck'/> ",
          width : 180,
          editable : false
        }, {
          dataField : "rcdTms",
          headerText : "Record Timestamp",
          width : 180,
          editable : false,
          visible : true
        }

    ];

    var gridPros = {
      usePaging : true,
      editable : true,
      displayTreeOpen : true,
      headerHeight : 30,
      skipReadonlyColumns : true,
      wrapSelectionMove : true,
      showRowNumColumn : true
    };
    assignCOrdtListGridID = GridCommon.createAUIGrid("aCtOrd_grid_wrap", columnLayout, "", gridPros);
  }

  function fn_ctChange() {

    var selectedItems = AUIGrid.getCheckedRowItems(assignCtListGridID);
    //수정된 행 아이템들(배열)
    var editedRowItems = AUIGrid.getEditedRowItems(assignCOrdtListGridID);
    var serialObj = new Array();

    if (selectedItems.length == 0 || selectedItems == null) {
      Common.alert("<spring:message code='service.msg.selectCT'/> ");
      return false;
    }

    if (editedRowItems.length == 0 || editedRowItems == null) {
      Common.alert("<spring:message code='service.msg.selectOrder'/> ");
      return false;
    }

    var ctSerialRequireChkYn = editedRowItems[0].serialRequireChkYn;

    for (var i = 0; i < editedRowItems.length; i++) {
      if (FormUtil.isEmpty(editedRowItems[i].insstallCtId)) {
        Common.alert("<spring:message code='service.msg.selectOrder'/> ");
        return false;
      }

      //if(ctSerialRequireChkYn != editedRowItems[i].serialRequireChkYn) {
      //    Common.alert("<b>'Serial Require Check Y/N' is different.</b>");
      //    return  false ;
      //}

      if (editedRowItems[i].serialChk == 'Y' && editedRowItems[i].serialRequireChkYn == 'Y') {
        if (FormUtil.isEmpty(editedRowItems[i].serialNo)) {
          Common.alert("<b>Serial No is required.( SalesOrder : " + editedRowItems[i].salesOrdNo + " )</b>");
          return false;
        }
      }

      if (FormUtil.isNotEmpty(editedRowItems[i].serialNo)) {
        serialObj.push(editedRowItems[i].serialNo);
      }
    }

    for (var k = 0; k < editedRowItems.length; k++) {
      var serialCnt = 0;
      for (var j = 0; j < serialObj.length; j++) {
        if (editedRowItems[k].serialNo == serialObj[j]) {
          serialCnt++;
        }
      }

      if (serialCnt > 1) {
        Common.alert("<spring:message code='service.msg.serialDup'/> ");
        return false;
      }
    }

    var updateForm = {
      "update" : editedRowItems
    }

    var url = "";

    if (ctSerialRequireChkYn == 'Y') {
      url = "/services/assignCtOrderListSaveSerial.do";
    } else {
      url = "/services/assignCtOrderListSave.do";
    }

    Common.ajax("POST", url, updateForm, function(result) {
      console.log("updateAssignCT.");
      console.log(result);

      if (result != "") {
        Common.alert(result.message);
        fn_installationListSearch();
        $("#_assginCTTransferDiv").remove();
      }
    });

  }

  function fn_asaAssignCtList() {

    var selectedItems = AUIGrid.getCheckedRowItems(myGridID);

    var brnch_id;
    brnch_id = selectedItems[0].item.brnchId;

    Common.ajax("GET", "/services/assignCtList.do", {
      BRNCH_ID : brnch_id
    }, function(result) {
      console.log("fn_asaAssignCtList.");
      console.log(result);
      AUIGrid.setGridData(assignCtListGridID, result);
    });
  }

  function fn_asaAssignCtOderList() {

    var selectedItems = AUIGrid.getCheckedRowItems(myGridID);

    var installNoArray = [];

    for ( var i in selectedItems) {
      installNoArray.push(selectedItems[i].item.installEntryNo)
    }
    //asfsdf
    var obj = JSON.stringify(installNoArray).replace(/[\[\]\"]/gi, '');

    Common.ajax("GET", "/services/assignCtOrderList.do", {
      installNo : obj
    }, function(result) {
      console.log("fn_asaAssignCtOderList.");
      console.log(result);

      AUIGrid.setGridData(assignCOrdtListGridID, result);

    });
  }

  function fn_ctSerialNoList(item) {
    Common.ajaxSync("GET", "/services/selectCtSerialNoList.do", {
      ctCode : item.ctCode,
      stkCode : item.stkCode
    }, function(result) {
      serialList = new Array();
      for (var i = 0; i < result.length; i++) {
        serialList.push(result[i]);
      }
    });
  }
</script>
<div id="popup_wrap" class="popup_wrap">
  <!-- popup_wrap start -->
  <header class="pop_header">
    <!-- pop_header start -->
    <h1><spring:message code='service.title.ctTrans'/> </h1>
    <ul class="right_opt">
      <li><p class="btn_blue2"><a href="javascript:fn_ctChange();"><spring:message code='sys.btn.confirm'/></a></p></li>
      <li><p class="btn_blue2"><a href="#"><spring:message code='sys.btn.close'/></a></p></li>
    </ul>
  </header>
  <!-- pop_header end -->
  <section class="pop_body">
    <!-- pop_body start -->
    <div class="divine_auto">
      <!-- divine_auto start -->
      <div style="width: 50%;">
        <aside class="title_line">
          <!-- title_line start -->
          <h2><spring:message code='service.title.ctList'/></h2>
        </aside>
        <!-- title_line end -->
        <div class="border_box" style="height: 400px">
          <!-- border_box start -->
          <ul class="right_btns">
            <!--     <li><p class="btn_grid"><a href="#">EDIT</a></p></li>
            <li><p class="btn_grid"><a href="#">NEW</a></p></li> -->
          </ul>
          <article class="grid_wrapCd">
            <!-- grid_wrap start -->
            <div id="aCtL_grid_wrap" style="width: 100%; height: 334px; margin: 0 auto;"></div>
          </article>
          <!-- grid_wrap end -->
        </div>
        <!-- border_box end -->
      </div>
      <div style="width: 50%;">
        <aside class="title_line">
          <!-- title_line start -->
          <h2><spring:message code='service.title.ordList'/></h2>
        </aside>
        <!-- title_line end -->
        <div class="border_box" style="height: 400px; width: 450px">
          <!-- border_box start -->
          <ul class="right_btns">
            <!--     <li><p class="btn_grid"><a href="#">EDIT</a></p></li>
            <li><p class="btn_grid"><a href="#">NEW</a></p></li> -->
          </ul>
          <article class="grid_wrapCust">
            <!-- grid_wrap start -->
            <div id="aCtOrd_grid_wrap" style="width: 100%; height: 334px; margin: 0 auto;"></div>
          </article>
          <!-- grid_wrap end -->
        </div>
        <!-- border_box end -->
      </div>
    </div>
</div>
<!-- divine_auto end -->
</section>
<!-- pop_body end -->
</div>
<!-- popup_wrap end -->
