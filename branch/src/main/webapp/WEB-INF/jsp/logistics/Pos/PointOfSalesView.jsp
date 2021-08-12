<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<!--
 DATE        BY     VERSION        REMARK
 ----------------------------------------------------------------
 09/10/2019  ONGHC  1.0.0          AMEND FOR LATEST CHANGES
 -->

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
</style>
<script type="text/javascript"
 src="${pageContext.request.contextPath}/resources/js/jquery.blockUI.min.js"></script>
<script type="text/javaScript" language="javascript">
  var resGrid;
  var reqGrid;
  var serialGrid;

  var rescolumnLayout = [ {
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
    dataField : "typenm",
    headerText : "<spring:message code='log.head.materialtype'/>",
    width : 120,
    height : 30
  }, {
    dataField : "stkcd",
    headerText : "<spring:message code='log.head.materialcode'/>",
    width : 120,
    height : 30
  }, {
    dataField : "stknm",
    headerText : "<spring:message code='log.head.materialname'/>",
    width : 250,
    height : 30
  }, {
    dataField : "qty",
    headerText : "<spring:message code='log.head.availableqty'/>",
    width : 120,
    height : 30,
    style: "aui-grid-user-custom-right",
    editable : true
  }, {
    dataField : "serialChk",
    headerText : "<spring:message code='log.head.serial'/>",
    width : 120,
    height : 30
  } ];

  var serialLayout = [ {
    dataField : "reqno",
    headerText : "<spring:message code='log.head.reqst_no'/>",
    width : 120,
    height : 30,
    visible : false
  }, {
    dataField : "itmcd",
    headerText : "<spring:message code='log.head.materialcode'/>",
    width : 120,
    height : 30,
    editable : false
  }, {
    dataField : "itmname",
    headerText : "<spring:message code='log.head.materialname'/>",
    width : 180,
    height : 30,
    editable : false
  }, {
    dataField : "serialNo",
    headerText : "<spring:message code='log.head.serialno'/>",
    width : 160,
    height : 30
  }, {
    dataField : "uom",
    headerText : "<spring:message code='log.head.uom'/>",
    width : 120,
    height : 30,
    labelFunction : function(rowIndex, columnIndex, value, headerText, item) {
      var retStr = "";

      for (var i = 0, len = uomlist.length; i < len; i++) {
        if (uomlist[i]["codeId"] == value) {
          retStr = uomlist[i]["codeName"];
          break;
        }
      }
      return retStr == "" ? value : retStr;
    }
  } ];

  var reqcolumnLayout;

  var resop = {
    showRowCheckColumn : true,
    usePaging : true,
    useGroupingPanel : false,
    Editable : false
  };

  var reqop = {
    showRowCheckColumn : true,
    usePaging : true,
    useGroupingPanel : false,
    Editable : true
  };

  var gridoptions = {
    showStateColumn : false,
    editable : false,
    pageRowCount : 30,
    usePaging : true,
    useGroupingPanel : false
  };

  var uomlist = f_getTtype('42', '');
  var paramdata;
  $(document).ready( function() {
    /**********************************
     * Header Setting
    ***********************************/
    var hdData;

    mainSearchFunc();

    doGetCombo('/common/selectCodeList.do', '15', '', 'cType', 'M', 'f_multiCombo');
    $("#cancelTr").hide();
    /**********************************
     * Header Setting End
     ***********************************/

    AUIGrid.bind(resGrid, "addRow", function(event) { });
    AUIGrid.bind(reqGrid, "addRow", function(event) { });

    AUIGrid.bind(resGrid, "cellEditBegin", function(event) { });
    AUIGrid.bind(reqGrid, "cellEditBegin", function(event) { });

    AUIGrid.bind(resGrid, "cellEditEnd", function(event) { });
    AUIGrid.bind(reqGrid, "cellEditEnd", function(event) { });

    AUIGrid.bind(resGrid, "cellClick", function(event) { });
    //AUIGrid.bind(reqGrid, "cellClick", function(event) { });

    // KR-OHK Serial Check add
    AUIGrid.bind(reqGrid, "cellClick", function( event ) {
        var rowIndex = event.rowIndex;
        var dataField = AUIGrid.getDataFieldByColumnIndex(reqGrid, event.columnIndex);
        var serialRequireChkYn = AUIGrid.getCellValue(reqGrid, rowIndex, "serialRequireChkYn");
        var itemserialChk = AUIGrid.getCellValue(reqGrid, rowIndex, "itemserialChk");

        if(dataField == "rqty"){
           if(serialRequireChkYn == "Y" && itemserialChk == "Y"){
               $("#serialForm #pRequestNo").val(AUIGrid.getCellValue(reqGrid, rowIndex, "reqno"));
               $("#serialForm #pRequestItem").val(AUIGrid.getCellValue(reqGrid, rowIndex, "reqnoitm"));
               $("#serialForm #pStatus").val("I");    // $("#serialForm #pStatus").val("O");
               fn_scanSearchPop();
           }
       }
    });

    AUIGrid.bind(resGrid, "cellDoubleClick", function(event) { });
    AUIGrid.bind(reqGrid, "cellDoubleClick", function(event) {
      var reqno = AUIGrid.getCellValue(reqGrid, event.rowIndex, "reqno");
      var itmcd = AUIGrid.getCellValue(reqGrid, event.rowIndex, "itmcd");

      destory(serialGrid);
      $("#openwindow").show();
      serialGrid = GridCommon.createAUIGrid("serial_grid_wrap", serialLayout, "", gridoptions);
      ItemSerialAjax(reqno, itmcd);
    });

    AUIGrid.bind(resGrid, "ready", function(event) { });
    AUIGrid.bind(reqGrid, "ready", function(event) { });

    AUIGrid.bind(reqGrid, "cellEditBegin", function(event) { });

    // KR-OHK Serial Check add
    var length = AUIGrid.getGridData(reqGrid).length;
    var requireCnt = 0;
    var itemCnt = 0;

    if(length > 0) {
        for(var i = 0; i < length; i++) {
            if(AUIGrid.getCellValue(reqGrid, i, "serialRequireChkYn") == 'Y') {// SERIAL_REQUIRE_CHK_YN
                requireCnt ++;
            }
            if(AUIGrid.getCellValue(reqGrid, i, "itemserialChk") == 'Y') {// ITEM SERIAL CHECK YN
                itemCnt ++;
            }
        }
    }

    if(requireCnt > 0 && itemCnt > 0) {
    	$("#btnPopSerial").attr("style", "");
        $("#btnAllDel").attr("style", "");
    } else {
        $("#btnPopSerial").attr("style", "display:none");
        $("#btnAllDel").attr("style", "display:none");
    }

    $("#btnAllDel").click(function(){
        if($(this).parent().hasClass("btn_disabled") == true){
            return false;
        }

        var msg = "Do you want to All Delete Request No ["+$("#zRstNo").val()+"]?";

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

  // BUTTON CLICK
  $(function() {
    $('#search').click(function() {
      if (f_validatation('search')) {
        //$("#slocation").val($("#tlocation").val());
      }
    });

    $('#clear').click(function() { });

    $('#list').click(function() {
      document.listForm.action = '/logistics/pos/PointOfSalesList.do';
      document.listForm.submit();
    });

    $("#sttype").change( function() {
      paramdata = {
        groupCode : '308',
        orderValue : 'CODE_NAME',
        likeValue : $("#sttype").val()
      };

      doGetComboData('/common/selectCodeList.do', paramdata, '', 'smtype', 'S', '');
    });

    $("#smtype").change(function() { });

    $("#dlAttach").click(function() {
      var reqstFile = $("#reqFileNo").val();
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
    });

  });

  function mainSearchFunc() {
    var param = "rStcode=${rStcode }";
    $.ajax({
      type : "GET",
      //url : "/logistics/stocktransfer/StocktransferDataDetail.do",
      url : "/logistics/pos/PosDataDetail.do",
      data : param,
      dataType : "json",
      contentType : "application/json;charset=UTF-8",
      async : false,
      success : function(data) {
        hdData = data.hValue;
        headFunc(data.hValue);
        requestList(data.iValue);
        reciveList(data.itemto)
      },
      error : function(jqXHR, textStatus, errorThrown) {
        Common.alert("Fail : " + jqXHR.responseJSON.message);
      },
      complete : function() {
      }
    });
  }

  function headFunc(data) {
    $("#reqno").val(data.reqno);
    $("#ReqDate").val(data.reqcrtdt);
    $("#Smo").val(data.refdocno);
    $("#reqtype").val(data.refdocno);
    $("#reqloc").val(data.reqcr);
    $("#Requestor").val(data.userName);
    $("#trxType").val(data.trntype);
    $("#reqFileNo").val(data.reqstFile);

    paramdata = {
      groupCode : '308',
      orderValue : 'CODE_NAME',
      likeValue : data.trntype
    };

    var code = "";
    if (data.trntype == 'OG') { // ADJ. OUT
      code = '433';
    } else if (data.trntype == 'OI') { // ADJ. IN
      code = '434';
    } else {
      code = '-';
    }

    var paramdata2 = {
      groupCode : code,
      orderValue : 'CODE_NAME'
    };

    doGetComboData('/logistics/pos/selectTypeList.do', paramdata, data.trndtl, 'ReqType', 'S', '');
    doGetCombo('/common/selectStockLocationList.do', '', data.rcivcr, 'tlocation', 'S', '');
    doGetComboData('/logistics/pos/selectAdjRsn.do', paramdata2, data.adjRsn, 'insAdjRsn', 'S', '');

    $("#tlocation").attr("disabled", true);

    doGetCombo('/common/selectStockLocationList.do', '', data.reqcr, 'ReqLoc', 'S', '');

    $("#ReqRemark").val(data.doctxt);

    //$("#Smo").prop("readonly", "readonly");
    //$("#Requestor").prop("readonly", "readonly");
    //$("#ReqRemark").prop("readonly", "readonly");
    //$("#dochdertxt").prop("class","readonly w100p");

    $("#Smo").attr("disabled", true);
    $("#Requestor").attr("disabled", true);
    $("#ReqRemark").attr("disabled", true);
    $("#ReqRemark2").attr("disabled", true);
    $("#trxType").attr("disabled", true);
    $("#ReqDate").attr("disabled", true);
    $("#ReqType").attr("disabled", true);
    $("#smtype").attr("disabled", true);
    $("#ReqLoc").attr("disabled", true);
    $("#insAdjRsn").attr("disabled", true);
    $("#pridic").val(data.prifr);
  }

  function requestList(data) {
    reqcolumnLayout = [
    {
      dataField : "resnoitm",
      headerText : "<spring:message code='log.head.item_no'/>",
      width : 120,
      height : 30,
      visible : false
    }, {
      dataField : "itmid",
      headerText : "<spring:message code='log.head.itemid'/>",
      width : 120,
      height : 30,
      visible : false
    }, {
      dataField : "reqno",
      headerText : "<spring:message code='log.head.reqst_no'/>",
      width : 120,
      height : 30,
      visible : false
    }, {
      dataField : "itmcd",
      headerText : "<spring:message code='log.head.materialcode'/>",
      width : 120,
      height : 30,
      editable : false
    }, {
      dataField : "itmname",
      headerText : "<spring:message code='log.head.materialname'/>",
      width : 250,
      height : 30,
      editable : false
    }, {
      dataField : "rqty",
      headerText : "<spring:message code='log.head.requestqty'/>",
      width : 120,
      height : 30,
      style: "aui-grid-user-custom-right",
      styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField){
          if(item.serialRequireChkYn== "Y" && item.itemserialChk== "Y") {
              return "aui-grid-link-renderer1";
          }
      }
    }, {
      dataField : "uom",
      headerText : "<spring:message code='log.head.uom'/>",
      width : 120,
      height : 30,
      labelFunction : function(rowIndex, columnIndex, value, headerText, item) {
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
    } ];

    reqGrid = GridCommon.createAUIGrid("req_grid_wrap", reqcolumnLayout, "", gridoptions);
    AUIGrid.setGridData(reqGrid, data);

    $("#zRstNo").val(AUIGrid.getCellValue(reqGrid, 0, "reqno") );
    $("#zFromLoc").val(AUIGrid.getCellValue(reqGrid, 0, "whLocId"));
    $("#zTrnscType").val(AUIGrid.getCellValue(reqGrid, 0, "trnscType"));
    $("#zIoType").val(AUIGrid.getCellValue(reqGrid, 0, "ioType") );
  }

  function reciveList(data) {
    resGrid = GridCommon.createAUIGrid("res_grid_wrap", rescolumnLayout, "", gridoptions);
    AUIGrid.setGridData(resGrid, data);
  }

  function SearchListAjax() {
    var url = "/logistics/organization/MaintainmovementList.do";
    var param = $('#searchForm').serialize();
    Common.ajax("GET", url, param, function(data) {
    });
  }

  function addRow() {
    var rowPos = "first";
    var item = new Object();
    AUIGrid.addRow(reqGrid, item, rowPos);
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

  function f_multiCombo() {
    $(function() {
      $('#cType').change(function() {

      }).multipleSelect({
        selectAll : true
      });
    });
  }

  function ItemSerialAjax(reqno, itmcd) {
    var param = {
      reqno : reqno,
      itmcd : itmcd
    };
    //  var param = "reqno="+reqno;
    var url = "/logistics/pos/ViewSerial.do";

    Common.ajax("GET", url, param, function(result) {
      AUIGrid.setGridData(serialGrid, result.data);
    });
  }

  function destory(gridNm) {
    AUIGrid.destroy(gridNm);
  }

  //KR-OHK Serial Check add
  function SearchReqItemListAjax() {
      var url = "/logistics/pos/selectReqItemList.do";
      var param = {"taskType":'VIEW', "reqstNo":$("#zRstNo").val()};

      Common.ajax("GET", url, param, function(result) {
          AUIGrid.setGridData(reqGrid, result);
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
  <ul class="right_btns">
   <li>
    <p class="btn_blue">
     <a id="dlAttach"><span class="list"></span><spring:message code='pay.btn.download' /> <spring:message code='log.label.atchmnt' /></a>
    </p>
   </li>
   <li>
    <p class="btn_blue">
     <a id="list"><span class="list"></span><spring:message code='sales.Back' /></a>
    </p>
   </li>
  </ul>
 </aside>
 <!-- title_line end -->
 <section class="search_table">
  <!-- search_table start -->
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
   <input type='hidden' id='pridic' name='pridic' value='M' />
   <input type='hidden' id='headtitle' name='headtitle' value='STO' />
   <input type='hidden' id='reqFileNo' name='reqFileNo' />
   <table class="type1">
    <!-- table start -->
    <caption>table</caption>
    <colgroup>
     <col style="width: 150px" />
     <col style="width: *" />
     <col style="width: 180px" />
     <col style="width: *" />
    </colgroup>
    <tbody>
     <tr>
      <th scope="row"><spring:message code='log.title.othRqst'/><span id='m1' name='m1' class='must'>*</span></th>
      <td>
      <input id="reqno" name="reqno" type="text" title="" placeholder="<spring:message code='log.label.rqstDt'/>" class="readonly w100p" readonly="readonly" /></td>
      <th scope="row"><spring:message code='log.label.rqstDt'/><span id='m2' name='m2' class='must'>*</span></th>
      <td>
       <input id="ReqDate" name="ReqDate" type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" />
      </td>
     </tr>
     <tr>
      <th scope="row"><spring:message code='log.label.trxTyp'/><span id='m3' name='m3' class='must'>*</span></th>
      <td>
       <select class="w100p" id="trxType" name="trxType">
        <option value=''><spring:message code='sal.combo.text.chooseOne'/></option>
        <c:forEach var="list" items="${trxTyp}" varStatus="status">
          <option value="${list.codeId}">${list.codeName}</option>
        </c:forEach>
       </select>
      <th scope="row"><spring:message code='log.label.rqstTyp'/><span id='m4' name='m4' class='must'>*</span></th>
      <td>
       <select class="w100p" id="ReqType" name="ReqType">
      </select>
     </tr>
     <tr>
      <th scope="row"><spring:message code='log.label.rqster'/><span id='m5' name='m5' class='must' style='display:none'>*</span></th>
      <td>
       <input id="Requestor" name="Requestor" type="text" title="" placeholder="" class="w100p" />
      </td>
      <th scope="row"><spring:message code='log.label.refDocNo'/></th>
      <td>
       <input id="Smo" name="Smo" type="text" title="" placeholder="" class="w100p" />
      </td>
     </tr>
     <tr>
      <th scope="row"><spring:message code='log.label.rqstlct'/><span id='m6' name='m6' class='must'>*</span></th>
      <td colspan="3">
       <select class="w100p" id="ReqLoc" name="ReqLoc"></select> <!-- 기존 id="flocation" --></td>
     </tr>
     <tr>
      <th scope="row"><spring:message code='log.label.hdrTxt'/><span id='m7' name='m7' class='must'>*</span></th>
      <td colspan="3">
       <input id="ReqRemark" name="ReqRemark" type="text" title="" placeholder="" class="w100p" />
      </td>
      <!-- 기존 id="dochdertxt" -->
     </tr>
     <tr>
      <th scope="row"><spring:message code='log.label.rmk'/></th>
      <td colspan="3">
       <textarea cols="20" name="ReqRemark2" id="ReqRemark2" rows="5" placeholder="<spring:message code='log.label.rmk'/>"></textarea>
      </td>
      <!-- 기존 id="dochdertxt" -->
     </tr>
     <tr>
      <th scope="row"><spring:message code='log.label.adjRsn'/><span id='m8' name='m8' class='must'>*</span></th>
      <td colspan="3">
       <select class="w100p" id="insAdjRsn" name="insAdjRsn">
        <option value=''><spring:message code='sal.combo.text.chooseOne'/></option>
       </select>
      </td>
     </tr>
     <tr id="cancelTr">
      <th scope="row">Defect Reason</th>
      <td><select class="w100p">
        <option value="">11</option>
        <option value="">22</option>
        <option value="">33</option>
      </select></td>
      <th scope="row">CT/Cody</th>
      <td><select class="w100p">
        <option value="">11</option>
        <option value="">22</option>
        <option value="">33</option>
      </select></td>
     </tr>
    </tbody>
   </table>
   <!-- table end -->
  </form>
 </section>
 <!-- search_table end -->
 <!-- <section class="search_table">search_table start -->
 <!-- <form id="searchFrom" method="post"> -->
 <!-- <input type="hidden" id="slocation"> -->
 <!-- <table class="type1">table start -->
 <!-- <caption>table</caption> -->
 <!-- <colgroup> -->
 <!--     <col style="width:140px" /> -->
 <!--     <col style="width:*" /> -->
 <!--     <col style="width:100px" /> -->
 <!--     <col style="width:*" /> -->
 <!--     <col style="width:90px" /> -->
 <!-- </colgroup> -->
 <!-- <tbody> -->
 <!-- <tr> -->
 <!--     <th scope="row">Material Code</th> -->
 <!--     <td> -->
 <!--     <div class="date_set">date_set start -->
 <!--     <p> -->
 <!--     <select class="w100p"> -->
 <!--         <option value="">11</option> -->
 <!--         <option value="">22</option> -->
 <!--         <option value="">33</option> -->
 <!--     </select> -->
 <!--     </p> -->
 <!--     <span>~</span> -->
 <!--     <p> -->
 <!--     <select class="w100p"> -->
 <!--         <option value="">11</option> -->
 <!--         <option value="">22</option> -->
 <!--         <option value="">33</option> -->
 <!--     </select> -->
 <!--     </p> -->
 <!--     </div>date_set end -->
 <!--     </td> -->
 <!--     <th scope="row">Type</th> -->
 <!--     <td > -->
 <!--     <select class="w100p" id="cType" name="cType"></select> -->
 <!--     </td> -->
 <!--     <td> -->
 <!--     <ul class="left_btns"> -->
 <!--         <li><p class="btn_blue2"><a id="search">Search</a></p></li> -->
 <!--     </ul> -->
 <!--     </td> -->
 <!-- </tr> -->
 <!-- </tbody> -->
 <!-- </table>table end -->
 <!-- </form> -->
 <!-- </section>search_table end -->
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
      <li><p class="btn_blue2"><a id="btnAllDel" style="display:none;">Clear Serial</a></p></li>
      <li><p class="btn_blue2"><a id="btnPopSerial" style="display:none;">Serial Scan</a></p></li>
      <li style="display:none;"><p class="btn_grid"><a id="btnPopSearch">Search</a></p></li>
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
     <%-- <ul class="btns">
    <li><a id="rightbtn"><img src="${pageContext.request.contextPath}/resources/images/common/btn_right2.gif" alt="right" /></a></li>
    <li><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_left2.gif" alt="left" /></a></li>
</ul> --%>
    </div>
    <!-- border_box end -->
   </div>
   <!-- 50% end -->
  </div>
  <!-- divine_auto end -->
  <!-- <ul class="center_btns mt20"> -->
  <!--     <li><p class="btn_blue2 big"><a id="save">Save</a></p></li> -->
  <!-- </ul> -->
  <div class="popup_wrap" id="openwindow" style="display: none">
   <!-- popup_wrap start -->
   <header class="pop_header">
    <!-- pop_header start -->
    <h1>View Serial</h1>
    <ul class="right_opt">
     <li><p class="btn_blue2">
       <a href="#"><spring:message code='sys.btn.close' /></a>
      </p></li>
    </ul>
   </header>
   <!-- pop_header end -->
   <section class="pop_body">
    <!-- pop_body start -->
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
   </section>
  </div>
 </section>
 <!-- search_result end -->
 <form id='popupForm'>
  <input type="hidden" id="sUrl" name="sUrl"> <input
   type="hidden" id="svalue" name="svalue">
 </form>
 <form id="listForm" name="listForm" method="POST">
  <input type="hidden" id="reqno" name="reqno"
   value="${searchVal.reqno}" /> <input type="hidden" id="reqtype"
   name="reqtype" value="${searchVal.reqtype}" /> <input
   type="hidden" id="reqloc" name="reqloc"
   value="${searchVal.reqloc}" />
  <%-- <input type="hidden" id="tlocation" name="tlocation" value="${searchVal.tlocation}"/> --%>
  <%-- <input type="hidden" id="flocation" name="flocation" value="${searchVal.flocation}"/> --%>
  <%-- <input type="hidden" id="crtsdt"    name="crtsdt"    value="${searchVal.crtsdt   }"/> --%>
  <%-- <input type="hidden" id="crtedt"    name="crtedt"    value="${searchVal.crtedt   }"/> --%>
  <%-- <input type="hidden" id="reqsdt"    name="reqsdt"    value="${searchVal.reqsdt   }"/> --%>
  <%-- <input type="hidden" id="reqedt"    name="reqedt"    value="${searchVal.reqedt   }"/> --%>
  <%-- <input type="hidden" id="sam"       name="sam"       value="${searchVal.sam      }"/> --%>
  <%-- <input type="hidden" id="sstatus"   name="sstatus"   value="${searchVal.sstatus  }"/> --%>
 </form>
</section>
