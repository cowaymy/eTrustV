<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<!--
 DATE        BY     VERSION        REMARK
 ----------------------------------------------------------------
 03/10/2019  ONGHC   1.0.8          Add AS Raw Report for 31Days
 11/12/2019  KR-JIN  1.1.0          COPY AS Order
 -->

<script type="text/javaScript">
// Branch : 5743
var branchDs = [];
<c:forEach var="obj" items="${branchList}">
    branchDs.push({codeId:"${obj.codeId}", codeName:"${obj.codeName}"});
</c:forEach>

  var option = {
    width : "1200px",
    height : "500px"
  };

  var myGridID;
  var gridPros = {
    usePaging : true,
    pageRowCount : 20,
    editable : true,
    fixedColumnCount : 1,
    showStateColumn : true,
    displayTreeOpen : true,
    selectionMode : "singleRow",
    headerHeight : 30,
    useGroupingPanel : true,
    skipReadonlyColumns : true,
    wrapSelectionMove : true,
    showRowNumColumn : false,
  };

  $(document).ready(
      function() {
      if('${SESSION_INFO.isAC}' == 1){
             if("${SESSION_INFO.memberLevel}" =="1"){
                 $("#orgCode").val('${SESSION_INFO.orgCode}');
             }else if("${SESSION_INFO.memberLevel}" =="2"){
                 $("#orgCode").val('${SESSION_INFO.orgCode}');
                 $("#grpCode").val('${SESSION_INFO.groupCode}');
             }else if("${SESSION_INFO.memberLevel}" =="3"){
                 $("#orgCode").val('${SESSION_INFO.orgCode}');
                 $("#grpCode").val('${SESSION_INFO.groupCode}');
                 $("#deptCode").val('${SESSION_INFO.deptCode}');
             }else if("${SESSION_INFO.memberLevel}" =="4"){
                 $("#orgCode").val('${SESSION_INFO.orgCode}');
                 $("#grpCode").val('${SESSION_INFO.groupCode}');
                 $("#deptCode").val('${SESSION_INFO.deptCode}');
                 //$("#memCode").val("${memCode}");
             }
         }

        asManagementGrid();
        //doGetCombo('/services/holiday/selectBranchWithNM', 43, '', 'cmbbranchId', 'S', ''); // DSC BRANCH
        //doDefCombo(branchDs, '', 'cmbbranchId', 'S', '');   // Home Care Branch : 5743

        doGetComboSepa('/common/selectBranchCodeList.do',  '6672', ' - ', '',   'cmbbranchId', 'M', 'fn_multiCombo');
        doGetComboSepa('/common/selectBranchCodeList.do',  '11', ' - ', '',   'cmbbranchId3', 'M', 'fn_multiCombo');

        /* $("#cmbbranchId").change(function() {
            doGetCombo('/homecare/services/as/selectCTByDSC.do', $("#cmbbranchId").val(), '', 'cmbctId', 'S', '');
        });  */// INCHARGE CT

        doGetComboAndGroup2('/common/selectProductCodeList.do', {selProdGubun : 'HC'}, '', 'asProduct', 'M', 'fn_setOptGrpClass');//product 생성 - Only Homecare

        AUIGrid.bind(myGridID, "cellDoubleClick", function(event) { // AS ENTRY VIEW DOUBLE CLICK
          var asid = AUIGrid.getCellValue(myGridID, event.rowIndex, "asId");
          var asNo = AUIGrid.getCellValue(myGridID, event.rowIndex, "asNo");
          var asStusId = AUIGrid.getCellValue(myGridID, event.rowIndex, "asStusId");
          var salesOrdNo = AUIGrid.getCellValue(myGridID, event.rowIndex, "salesOrdNo");
          var salesOrdId = AUIGrid.getCellValue(myGridID, event.rowIndex, "asSoId");

          var param =  "?salesOrderId=" + salesOrdId
                    + "&ord_Id=" + salesOrdId
                    + "&ord_No=" + salesOrdNo
                    + "&as_No=" + asNo
                    + "&as_Id=" + asid
                    + "&IND= 1";

          Common.popupDiv("/services/as/asResultViewPop.do" + param, null, null, true, '_newASResultDiv1');
        });
      });

  function fn_setOptGrpClass() {
      $("optgroup").attr("class" , "optgroup_text");
      fn_multiCombo();
  }

  function fn_disableGroupOption(){
      $('.optgroup').children('input').attr("disabled","disabled");
  }

  function fn_multiCombo() {
      $('#asProduct').change(function(event) {
          event.preventDefault();
          fn_disableGroupOption();
          $('#asProduct').next().find('.placeholder').text('');
          $('#asProduct').next().find('.placeholder').text($("#product option:selected").text());
      }).multipleSelect({
          selectAll : true, // 전체선택
          width : '100%'
      });

      $('#cmbbranchId').change(function() {
          //console.log($(this).val());
      }).multipleSelect({
          selectAll: true, // 전체선택
          width: '100%'
      });

      $('#cmbbranchId3').change(function() {
          //console.log($(this).val());
      }).multipleSelect({
          selectAll: true, // 전체선택
          width: '100%'
      });
  }

  /* By KV - AS Mobile Failure Listing*/
  function fn_ASMobileFailureListing(){
      var date = new Date();
      var month = date.getMonth() + 1;
      var day = date.getDate();

      if (date.getDate() < 10) {
        day = "0" + date.getDate();
      }

      $("#reportFormASLst #reportFileName").val('/services/AS_Mobile_Fail_excel.rpt');
      $("#reportFormASLst #viewType").val("EXCEL");
      $("#reportFormASLst #V_TEMP").val("");
      $("#reportFormASLst #reportDownFileName").val(
          "ASMobileFailureListing_" + day + month + date.getFullYear());

      var option = {
                isProcedure : true, // procedure 로 구성된 리포트 인경우 필수.
              };

    Common.report("reportFormASLst", option);
  }

  function asManagementGrid() {
    var columnLayout = [
        {
          dataField : "code",
          headerText : "<spring:message code='service.grid.ASTyp'/>",
          editable : false,
          width : 100
        },
        {
          dataField : "code2",
          headerText : "<spring:message code='service.title.ApplicationType'/>",
          width : 130
        },
        {
          dataField : "asNo",
          headerText : "<spring:message code='service.grid.ASNo'/>",
          editable : false,
          width : 100
        },
        {
            dataField : "defectDesc",
            headerText : "AS Error Detail",
            editable : false,
            width : 100
        },
        {
            dataField : "resnDesc",
            headerText : "AS Fail Description",
            editable : false,
            width : 100
        },
        {
          dataField : "code1",
          headerText : "<spring:message code='service.grid.Status'/>",
          editable : false,
          width : 80
        },
        {
            dataField : "bndlNo",
            headerText : "BNDL No.",
            editable : false,
            width : 100
        },
        {
          dataField : "salesOrdNo",
          headerText : "<spring:message code='service.title.SalesOrder'/>",
          editable : false,
          width : 100
        },
        {
            dataField : "remark",
            headerText : "Requestor Remark",
            editable : false,
            width : 100
          },
        {
          dataField : "name",
          headerText : "<spring:message code='service.title.CustomerName'/>",
          style:"aui-grid-user-custom-left",
          width : 200
        },
        {
            dataField : "strAsSetlDt",
            visible : false
        },
        {
          dataField : "asReqstDt",
          headerText : "<spring:message code='service.grid.ReqstDt'/>",
          editable : false,
          width : 110,
          dataType : "date",
          formatString : "dd/mm/yyyy"
        },
        {
          dataField : "asAppntDt",
          headerText : "<spring:message code='service.grid.AppntDt'/>",
          editable : false,
          width : 140,
          dataType : "date",
          formatString : "dd/mm/yyyy"
        },
        {
          dataField : "asSetlDt",
          headerText : "<spring:message code='service.grid.SettleData'/>",
          editable : false,
          width : 110,
          dataType : "date",
          formatString : "dd/mm/yyyy"
        },
        {
          dataField : "asResultCrtDt",
          headerText : "<spring:message code='pay.head.lastUpdate'/>",
          editable : false,
          width : 110,
          dataType : "date",
          formatString : "dd/mm/yyyy"
        },
        {
          dataField : "c3",
          headerText : "<spring:message code='service.grid.ResultNo'/>",
          editable : false,
          style : "my-column",
          width : 100
        },
        {
          dataField : "asResultCrtUserId",
          headerText : "<spring:message code='service.grid.asRsltEntCreator'/>",
          editable : false,
          width : 100
        },
        {
          dataField : "memCode",
          headerText : "Technician Code",
          editable : false,
          width : 100
        },
        {
            dataField : "partnerCode",
            headerText : "Pairing Code",
            editable : false,
            width : 100
          },
        {
          dataField : "brnchCode",
          headerText : "<spring:message code='service.title.ASBrch'/>",
          width : 100
        },
        {
            dataField : "dscBrnchCode",
            headerText : "<spring:message code='service.title.DSCBranch'/>",
            width : 100
          },
        {
          dataField : "instCity",
          headerText : "City",
          width : 100
        },
        {
          dataField : "cms",
          headerText : "<spring:message code='service.title.AllowComm'/>",
          width : 100
        },
        {
          dataField : "c4",
          headerText : "<spring:message code='service.grid.asEntCreator'/>",
          editable : false,
          width : 100
        },
        {
          dataField : "totalAs",
          headerText : "<spring:message code='service.grid.asTotalLdg'/>",
          editable : false,
          dataType : "numeric",
          width : 120
        },
        {
          dataField : "undefined",
          headerText : "<spring:message code='sys.btn.edit'/>",
          width : 100,
          renderer : {
                       type : "ButtonRenderer",
                       labelText : "<spring:message code='sys.btn.edit'/>",
                       onclick : function(rowIndex, columnIndex, value, item) {

                           var AS_ID = AUIGrid.getCellValue(myGridID, rowIndex, "asId");
                           var AS_NO = AUIGrid.getCellValue(myGridID, rowIndex, "asNo");
                           var asStusId = AUIGrid.getCellValue(myGridID, rowIndex, "code1");
                           var ordno = AUIGrid.getCellValue(myGridID, rowIndex, "salesOrdNo");
                           var ordId = AUIGrid.getCellValue(myGridID, rowIndex, "asSoId");

                           if (asStusId != "ACT" && asStusId != "RCL") {
                               /*Common.alert("AS Info Edit Restrict</br>"
                               + DEFAULT_DELIMITER
                               + "<b>["
                               + AS_NO
                               + "]  is not in active status.</br> AS information edit is disallowed.</b>");
                               return;*/
                               Common.alert("<spring:message code='service.msg.asEdtChk' arguments='<b>" + AS_NO + "</b>' htmlEscape='false' argumentSeparator=';' />");
                               return;
                           }

                           Common.popupDiv("/homecare/services/as/resultASReceiveEntryPop.do?mod=VIEW&salesOrderId=" + ordId + "&ordNo=" + ordno + "&AS_NO=" + AS_NO + "&IND= 1", null, null, true, '_viewEntryPopDiv1');
                       }
          }
        },
        {
          dataField : "nric",
          headerText : "<spring:message code='service.title.NRIC_CompanyNo'/>",
          width : 100,
          visible : false
        },

        {
          dataField : "asIfFlag",
          headerText : "<spring:message code='service.title.ASFlg'/>",
          width : 80,
          visible : false
        },

        {
          dataField : "asBrnchId",
          headerText : "<spring:message code='service.title.ASBrchId'/>",
          width : 100,
          visible : false
        },
        {
          dataField : "c5",
          headerText : "<spring:message code='service.title.ASAmt'/>",
          width : 100,
          visible : false
        },
        {
          dataField : "asResultId",
          headerText : "<spring:message code='service.title.ASRstId'/>",
          width : 100,
          visible : false
        },
        {
          dataField : "refReqst",
          headerText : "",
          width : 100,
          visible : false
        },
        {
          dataField : "rcdTms",
          headerText : "",
          width : 100,
          visible : false
        },
        {
      	  dataField : "undefined",
            headerText : "AS Image",
            width : 100,
            renderer : {
                         type : "ButtonRenderer",
                         labelText : "View",
                         onclick : function(rowIndex, columnIndex, value, item) {
                             var AS_NO = AUIGrid.getCellValue(myGridID, rowIndex, "asNo") + "_";
                             var asStusId = AUIGrid.getCellValue(myGridID, rowIndex, "code1");

                             if (asStusId == "COM") {
                          	   Common.popupDiv('/sales/order/getInstImg.do', { insNo : AS_NO,  type : 'preInstallation' }, null , true);
                             }
                             else{
                          	   Common.alert("Only Completed AS able to view image.");
                          	   return;
                             }
                         }
            }
      }
    ];

    var gridPros = {
      showRowCheckColumn : true,
      usePaging : true,
      pageRowCount : 20,
      showRowAllCheckBox : true,
      editable : false,
      selectionMode : "multipleCells"
    };

    //myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout, gridPros);
    myGridID = AUIGrid.create("#grid_wrap_asList", columnLayout, gridPros);
  }

  function fn_searchASManagement() { // SEARCH AS
    var startDate = $('#createStrDate').val();
    var endDate = $('#createEndDate').val();
    var dt_range = $('#dt_range').val();

    if (dt_range != "") {
      if (fn_getDateGap(startDate, endDate) > dt_range) {
        var fName = "<b><spring:message code='service.grid.ReqstDt'/></b>";

        Common.alert("<spring:message code='service.msg.asSearchDtRange' arguments='" + fName + " ; <b>" + dt_range +"</b>' htmlEscape='false' argumentSeparator=';' />");
        return false;
      }
    }

    Common.ajax("GET", "/homecare/services/as/searchASManagementList.do", $("#ASForm").serialize(), function(result) {
      AUIGrid.setGridData(myGridID, result);
    });
  }

  function fn_newASPop() { // CREATE AS - 1
      Common.popupDiv("/homecare/services/as/hcASReceiveEntryPop.do", {in_ordNo : ""}, null, true, '_NewEntryPopDiv1', function(){$(".popup_wrap").css("width", '600px');});
  }

  function fn_viewASResultPop() { // VIEW RESULT
    var selectedItems = AUIGrid.getCheckedRowItems(myGridID);

    if (selectedItems.length <= 0) {
      Common.alert("<spring:message code='service.msg.NoRcd'/>");
      return;
    }

    if (selectedItems.length > 1) {
      Common.alert("<spring:message code='service.msg.onlyPlz'/>");
      return;
    }

    var AS_ID = selectedItems[0].item.asId;
    var AS_NO = selectedItems[0].item.asNo;
    var asStusId = selectedItems[0].item.code1;
    var ordno = selectedItems[0].item.salesOrdNo;
    var ordId = selectedItems[0].item.asSoId;

    if (asStusId != "ACT") {
      Common.alert("AS Info Edit Restrict</br>" + DEFAULT_DELIMITER + "<b>[" + AS_NO + "]  is not in active status.</br> AS information edit is disallowed.</b>");
      return;
    }

    Common.popupDiv("/homecare/services/as/resultASReceiveEntryPop.do?mod=VIEW&salesOrderId=" + ordId + "&ordNo=" + ordno + "&AS_NO=" + AS_NO + '&AS_ID=' + AS_ID, null, null, true, '_viewEntryPopDiv1');
  }

  function fn_resultASPop(ordId, ordNo) {
    var selectedItems = AUIGrid.getCheckedRowItems(myGridID);
    var mafuncId = "";
    var mafuncResnId = "";
    var asId = "";

    if (selectedItems.length > 0) {
      mafuncId = selectedItems[0].item.asMalfuncId;
      mafuncResnId = selectedItems[0].item.asMalfuncResnId;
      asId = selectedItems[0].item.asId;
    }

    var pram = "?salesOrderId=" + ordId + "&ordNo=" + ordNo + "&mafuncId=" + mafuncId + "&mafuncResnId=" + mafuncResnId + "&AS_ID=" + asId + "&IND= 1";

    // hcResultASReceiveEntryPop   : CREATE AS - 2
    Common.popupDiv("/homecare/services/as/resultASReceiveEntryPop.do" + pram, null, null, true, '_resultNewEntryPopDiv1');
  }

  function fn_newASResultPop() {
    var selectedItems = AUIGrid.getCheckedRowItems(myGridID);

    if (selectedItems.length <= 0) {
      Common.alert("<spring:message code='service.msg.NoRcd'/>");
      return;
    }

    if (selectedItems.length > 1) {
      Common.alert("<spring:message code='service.msg.onlyPlz'/>");
      return;
    }

    var asId = selectedItems[0].item.asId;
    var asNo = selectedItems[0].item.asNo;
    var asStusId = selectedItems[0].item.code1;
    var salesOrdNo = selectedItems[0].item.salesOrdNo;
    var salesOrdId = selectedItems[0].item.asSoId;
    var refReqst = selectedItems[0].item.refReqst;
    var rcdTms = selectedItems[0].item.rcdTms;
    var asRst = selectedItems[0].item.c3;

    //if (asRst != '-') {
      //Common.alert("<spring:message code='service.msg.asAddHvRst' arguments='<b>" + asNo + "</b>' htmlEscape='false' argumentSeparator=';' />");
      //return;
    //}

    if (asStusId != "ACT") {
      Common.alert("<spring:message code='service.msg.asAddHvRst' arguments='<b>" + asNo + "</b>' htmlEscape='false' argumentSeparator=';' />");
      return;
    }

    // Checking - AS data exists
    Common.ajax("POST", "/services/as/selRcdTms.do", {
        asNo : asNo,
        asId : asId,
        salesOrdNo : salesOrdNo,
        salesOrderId : salesOrdId,
        rcdTms : rcdTms
    }, function(result) {
      if (result.code == "99") {        // no Data
        Common.alert(result.message);
        return;
      } else {                          // hcNewASResultPop
        var param = "?ord_Id=" + salesOrdId + "&ord_No=" + salesOrdNo + "&as_No=" + asNo + "&as_Id=" + asId + "&refReqst=" + refReqst + "&as_Rst=" + asRst + "&rcdTms=" + rcdTms;
        Common.popupDiv("/homecare/services/as/ASNewResultPop.do" + param, null, null, true, '_newASResultDiv1');
      }
    });
  }

  function fn_asAppViewPop() {
    var selectedItems = AUIGrid.getSelectedItems(myGridID);

    if (selectedItems.length <= 0) {
      Common.alert("<spring:message code='service.msg.NoRcd'/>");
      return;
    }

    if (selectedItems.length > 1) {
      Common.alert("<spring:message code='service.msg.onlyPlz'/>");
      return;
    }

    var asid = selectedItems[0].item.asId;
    var asNo = selectedItems[0].item.asNo;
    var asStusId = selectedItems[0].item.code1;
    var salesOrdNo = selectedItems[0].item.salesOrdNo;
    var salesOrdId = selectedItems[0].item.asSoId;

    var param = "?ord_Id=" + salesOrdId + "&ord_No=" + salesOrdNo + "&as_No=" + asNo + "&as_Id=" + asid;
    Common.popupDiv("/services/as/asResultViewPop.do" + param, null, null, true, '_newASResultDiv1');
  }

  function fn_asResultViewPop() {
    var selectedItems = AUIGrid.getCheckedRowItems(myGridID);

    if (selectedItems.length <= 0) {
      Common.alert("<spring:message code='service.msg.NoRcd'/>");
      return;
    }

    if (selectedItems.length > 1) {
      Common.alert("<spring:message code='service.msg.onlyPlz'/>");
      return;
    }

    var asid = selectedItems[0].item.asId;
    var asNo = selectedItems[0].item.asNo;
    var asStusId = selectedItems[0].item.code1;
    var salesOrdNo = selectedItems[0].item.salesOrdNo;
    var salesOrdId = selectedItems[0].item.asSoId;
    var asResultNo = selectedItems[0].item.c3;

    if (asStusId == "ACT") {
      Common.alert("<spring:message code='service.msg.asEdtNoRst' arguments='<b>" + asNo + "</b>' htmlEscape='false' argumentSeparator=';' />");
      return;
    }

    if (asResultNo == "") {
      Common.alert("<spring:message code='service.msg.asEdtNoRst' arguments='<b>" + asNo + "</b>' htmlEscape='false' argumentSeparator=';' />");
      return;
    }

    var param = "?ord_Id=" + salesOrdId + "&ord_No=" + salesOrdNo+ "&as_No=" + asNo + "&as_Id=" + asid + "&mod=RESULTVIEW&as_Result_No=" + asResultNo;

    Common.popupDiv("/homecare/services/as/asResultEditViewPop.do" + param, null, null, true, '_newASResultDiv1');
  }

  function fn_asInhouseAddOrderPop() {
    var selectedItems = AUIGrid.getCheckedRowItems(myGridID);

    if (selectedItems.length <= 0) {
      Common.alert("<spring:message code='service.msg.NoRcd'/>");
      return;
    }

    if (selectedItems.length > 1) {
      Common.alert("<spring:message code='service.msg.onlyPlz'/>");
      return;
    }

    var asid = selectedItems[0].item.asId;
    var asNo = selectedItems[0].item.asNo;

    var asStusId = selectedItems[0].item.code1;
    var salesOrdNo = selectedItems[0].item.salesOrdNo;
    var salesOrdId = selectedItems[0].item.asSoId;
    var apptype = selectedItems[0].item.code;
    var asResultNo = selectedItems[0].item.c3;
    var asResultId = selectedItems[0].item.asResultId;

    if (apptype != "IHR") {
      Common.alert("only select for In-House Repair ");
      return;
    }

    // if(asStusId  !="ACT"){
    //     Common.alert("<b> already has [" + asResultNo + "] result.  .</br> Result entry is disallowed.</b>");
    //    return ;
    //}

    //$("#in_asResultId").val(asResultId);
    //$("#in_asResultNo").val(asResultNo);

    Common.popupDiv("/homecare/services/as/resultASReceiveEntryPop.do?salesOrderId=" + salesOrdId + "&ordNo=" + salesOrdNo + "&asResultId=" + asResultId, null, null, true, '_resultNewEntryPopDiv1');
    //Common.popupDiv("/services/as/ASReceiveEntryPop.do" ,$("#inHOForm").serializeJSON()  , null , true , '_newInHouseEntryDiv1');
  }

  function fn_asResultEditPop(ind) {
    var selectedItems = AUIGrid.getCheckedRowItems(myGridID);

    if (selectedItems.length <= 0) {
      Common.alert("<spring:message code='service.msg.NoRcd'/>");
      return;
    }

    if (selectedItems.length > 1) {
      Common.alert("<spring:message code='service.msg.onlyPlz'/>");
      return;
    }

    var asId = selectedItems[0].item.asId;
    var asNo = selectedItems[0].item.asNo;
    var asStusId = selectedItems[0].item.code1;
    var salesOrdNo = selectedItems[0].item.salesOrdNo;
    var salesOrdId = selectedItems[0].item.asSoId;
    var asResultNo = selectedItems[0].item.c3;
    var asResultId = selectedItems[0].item.asResultId;
    var asTypeID = selectedItems[0].item.code;
    var rcdTms = selectedItems[0].item.rcdTms;
    var updDt = selectedItems[0].item.asSetlDt;
    var lstUpdDt = selectedItems[0].item.asResultCrtDt;

    if (asResultNo == "-") {
      Common.alert("<spring:message code='service.msg.asEdtNoRst' arguments='<b>" + asNo + "</b>' htmlEscape='false' argumentSeparator=';' />");
      return;
    }

    /*if (asStusId == "ACT") {
      if (selectedItems[0].item.asSlutnResnId == '454') {
      } else {
        Common.alert("<spring:message code='service.msg.asEdtNoRst' arguments='<b>" + asNo + "</b>' htmlEscape='false' argumentSeparator=';' />");
        return;
      }
    }*/

    if (ind == 0) {
      if (asStusId != "RCL") {
        if (updDt != "" && updDt != null) {
          var stat = true;
          var sDate = new Date(updDt);
          var tDate = new Date();
          tDate.setDate(tDate.getDate() - 7);

          var tMth = tDate.getMonth();
          var tYear = tDate.getFullYear();
          var tDay = tDate.getDate();
          var sMth = sDate.getMonth();
          var sYear = sDate.getFullYear();
          var sDay = sDate.getDate();

          if (sYear > tYear) {
            stat = true;
          } else {
            if (sMth > tMth) {
              stat = true;
            } else {
              if (sDay > tDay) {
                stat = true;
              } else {
                stat = false;
              }
            }
          }

          if (!stat) {
            Common.alert("<b><spring:message code='service.alert.msg.AsEditPrdChk'/></b>");
            return;
          }
        } else if (lstUpdDt != "" && lstUpdDt != null) {
          var stat = true;
          var sDate = new Date(lstUpdDt);
          var tDate = new Date();
          tDate.setDate(tDate.getDate() - 7);

          var tMth = tDate.getMonth();
          var tYear = tDate.getFullYear();
          var tDay = tDate.getDate();
          var sMth = sDate.getMonth();
          var sYear = sDate.getFullYear();
          var sDay = sDate.getDate();

          if (sYear > tYear) {
            stat = true;
          } else {
            if (sMth > tMth) {
              stat = true;
            } else {
              if (sDay > tDay) {
                stat = true;
               } else {
                stat = false;
              }
            }
          }

          if (!stat) {
            Common.alert("<b><spring:message code='service.alert.msg.AsEditPrdChk2'/></b>");
            return;
          }
        }
      }
    }

    if (asTypeID == "AOAS") {
      // ADD CHECKING
      Common.ajax("GET", "/services/as/checkAOASRcdStat", { ORD_NO : salesOrdNo },
        function(result) {
          var stat = 0;
            if (result != "") {
              if (result.length > 0) {
                for (var a = 0; a < result.length; a++) {
                  if (result[a].occur > 1) {
                    if (result[a].no != "") {
                      Common.alert("<spring:message code='service.msg.asEdtFail' arguments='<b>" + asNo + "</b>' htmlEscape='false' argumentSeparator=';' />");
                      return;
                    }
                  }
                }
              }
            }

            if (asResultNo == "") {
              Common.alert("<spring:message code='service.msg.asEdtNoRst' arguments='<b>" + asNo + "</b>' htmlEscape='false' argumentSeparator=';' />");
              return;
            }

            Common.ajax("POST", "/services/as/selRcdTms.do", {
                asNo : asNo,
                asId : asId,
                salesOrdNo : salesOrdNo,
                salesOrderId : salesOrdId,
                rcdTms : rcdTms
            }, function(result) {
              if (result.code == "99") {
                Common.alert(result.message);
                return;
              } else {
                var param = "?ord_Id=" + salesOrdId
                          + "&ord_No=" + salesOrdNo + "&as_No="
                          + asNo + "&as_Id=" + asId
                          + "&mod=RESULTEDIT&as_Result_No="
                          + asResultNo + "&as_Result_Id="
                          + asResultId;

                Common.popupDiv("/homecare/services/as/asResultEditViewPop.do" + param, null, null, true, '_newASResultDiv1');
              }
            });
        });
    } else {
      if (asResultNo == "") {
        Common.alert("<spring:message code='service.msg.asEdtNoRst' arguments='<b>" + asNo + "</b>' htmlEscape='false' argumentSeparator=';' />");
        return;
      }

      Common.ajax("POST", "/services/as/selRcdTms.do", {
          asNo : asNo,
          asId : asId,
          salesOrdNo : salesOrdNo,
          salesOrderId : salesOrdId,
          rcdTms : rcdTms
      }, function(result) {
        if (result.code == "99") {
          Common.alert(result.message);
          return;
        } else {
          var param = "?ord_Id=" + salesOrdId + "&ord_No=" + salesOrdNo
                    + "&as_No=" + asNo + "&as_Id=" + asId
                    + "&mod=RESULTEDIT&as_Result_No=" + asResultNo
                    + "&as_Result_Id=" + asResultId;

          Common.popupDiv("/homecare/services/as/asResultEditViewPop.do" + param, null, null, true, '_newASResultDiv1');
        }
      });
    }
  }

  function fn_asResultEditBasicPop(ind) {
    var selectedItems = AUIGrid.getCheckedRowItems(myGridID);

    if (selectedItems.length <= 0) {
      Common.alert("<spring:message code='service.msg.NoRcd'/>");
      return;
    }

    if (selectedItems.length > 1) {
      Common.alert("<spring:message code='service.msg.onlyPlz'/>");
      return;
    }

    var asId = selectedItems[0].item.asId;
    var asNo = selectedItems[0].item.asNo;
    var asStusId = selectedItems[0].item.code1;
    var salesOrdNo = selectedItems[0].item.salesOrdNo;
    var salesOrdId = selectedItems[0].item.asSoId;
    var asResultNo = selectedItems[0].item.c3;
    var asResultId = selectedItems[0].item.asResultId;
    var refReqst = selectedItems[0].item.refReqst;
    var rcdTms = selectedItems[0].item.rcdTms;
    var updDt = selectedItems[0].item.asSetlDt;
    var lstUpdDt = selectedItems[0].item.asResultCrtDt;

    // ONLY APPLICABLE TO COMPLETE AND CANCEL AS
    if (asStusId != "CAN" && asStusId != "COM") {
      Common.alert("<spring:message code='service.msg.asEdtBscChk' arguments='<b>" + asNo + "</b>' htmlEscape='false' argumentSeparator=';' />");
      return;
    }

    if (asStusId == "ACT") { // STILL ACTIVE
      if (refReqst == "") {
        Common.alert("<spring:message code='service.msg.asEdtNoRst' arguments='<b>" + asNo + "</b>' htmlEscape='false' argumentSeparator=';' />");
        return;
      }
    }

    if (asResultNo == "") { // NO RESULT
      Common.alert("<spring:message code='service.msg.asEdtNoRst' arguments='<b>" + asNo + "</b>' htmlEscape='false' argumentSeparator=';' />");
      return;
    }

    // CHECKING 7 DAYS ONLY MOD LEVEL CAN HELP EDIT
    if (ind == 0) {
      if (asStusId != "RCL") {
        if (updDt != "" && updDt != null) {
          var stat = true;
          var sDate = new Date(updDt);
          var tDate = new Date();
          tDate.setDate(tDate.getDate() - 7);

          var tMth = tDate.getMonth();
          var tYear = tDate.getFullYear();
          var tDay = tDate.getDate();
          var sMth = sDate.getMonth();
          var sYear = sDate.getFullYear();
          var sDay = sDate.getDate();

          if (sYear > tYear) {
            stat = true;
          } else {
            if (sMth > tMth) {
              stat = true;
            } else {
              if (sDay > tDay) {
                stat = true;
               } else {
                stat = false;
              }
            }
          }

          if (!stat) {
            Common.alert("<b><spring:message code='service.alert.msg.AsEditPrdChk'/></b>");
            return;
          }
        } else if (lstUpdDt != "" && lstUpdDt != null) {
          var stat = true;
          var sDate = new Date(lstUpdDt);
          var tDate = new Date();
          tDate.setDate(tDate.getDate() - 7);

          var tMth = tDate.getMonth();
          var tYear = tDate.getFullYear();
          var tDay = tDate.getDate();
          var sMth = sDate.getMonth();
          var sYear = sDate.getFullYear();
          var sDay = sDate.getDate();

          if (tYear > sYear) {
            stat = false;
          } else {
            if (tMth > sMth) {
              stat = false;
            } else {
              if (tDay > sDay) {
                stat = false;
              } else {
                stat = true;
              }
            }
          }

          if (!stat) {
            Common.alert("<b><spring:message code='service.alert.msg.AsEditPrdChk2'/></b>");
            return;
          }
        }
      }
    }

    Common.ajax("POST", "/services/as/selRcdTms.do", { // CHECK TIMESTAMP
        asNo : asNo,
        asId : asId,
        salesOrdNo : salesOrdNo,
        salesOrderId : salesOrdId,
        rcdTms : rcdTms
    }, function(result) {
      if (result.code == "99") {
        Common.alert(result.message);
        return;
      } else {
        var param = "?ord_Id=" + salesOrdId + "&ord_No=" + salesOrdNo
                  + "&as_No=" + asNo + "&as_Id=" + asId
                  + "&mod=edit&as_Result_No=" + asResultNo + "&as_Result_Id="
                  + asResultId;

        Common.popupDiv("/homecare/services/as/asResultEditBasicPop.do" + param, null, null, true, '_newASResultBasicDiv1');
      }
    });
  }

  function fn_assginCTTransfer() {
    var selectedItems = AUIGrid.getCheckedRowItems(myGridID);

    if (selectedItems.length <= 0) {
      Common.alert("<spring:message code='service.msg.NoRcd'/>");
      return;
    }

    var asBrnchId = selectedItems[0].item.asBrnchId;

    for ( var i in selectedItems) {
      if ("ACT" != selectedItems[i].item.code1 && "RCL" != selectedItems[i].item.code1) {
        Common.alert("<spring:message code='service.msg.asCTTrfChk' arguments='<b>" + selectedItems[i].item.asNo + "</b>' htmlEscape='false' argumentSeparator=';' />");
        return;
      }

      if (asBrnchId != selectedItems[i].item.asBrnchId) {
        Common.alert("<b>Can't CT tranfer in multiple branch selection.</b>");
        return;
      }
    }

    Common.popupDiv("/homecare/services/as/assignCTTransferPop.do", null, null, true, '_assginCTTransferDiv');
  }



  function fn_excelDown() {
    // type : "xlsx", "csv", "txt", "xml", "json", "pdf", "object"
    GridCommon.exportTo("grid_wrap_asList", "xlsx", "AS Management");
  }

  function fn_ASReport() {
    Common.popupDiv("/homecare/services/as/report/asReportPop.do", null, null, true, '');
  }

  function fn_asLogBookList() {
    Common.popupDiv("/homecare/services/as/report/asLogBookListPop.do", null, null, true, '');
  }

  function fn_asRawData(ind) {
    Common.popupDiv("/homecare/services/as/report/asRawDataPop.do", {ind: ind}, null, true, '');
  }

  function fn_asSummaryList() {
    Common.popupDiv("/homecare/services/as/report/asSummaryListPop.do", null, null, true, '');
  }

  function fn_asYsList() {
    Common.popupDiv("/homecare/services/as/report/asYellowSheetPop.do", null, null, true, '');
  }

  function fn_ledger() {
    var selectedItems = AUIGrid.getCheckedRowItems(myGridID);

    if (selectedItems.length <= 0) {
      Common.alert("<spring:message code='service.msg.NoRcd'/>");
      return;
    } else {
      var asStusId = selectedItems[0].item.code1;
      var asrNo = selectedItems[0].item.c3;
      var AS_NO = selectedItems[0].item.asNo;

      if (asStusId == "ACT") {
        Common.alert("<spring:message code='service.msg.asEdtNoRst' arguments='<b>" + AS_NO + "</b>' htmlEscape='false' argumentSeparator=';' />");
      } else {
        Common.popupDiv("/homecare/services/as/report/asLedgerPop.do?ASNO=" + AS_NO, null, null, true, '');
      }
    }
  }

  function fn_invoice() {
    var selectedItems = AUIGrid.getCheckedRowItems(myGridID);

    if (selectedItems.length <= 0) {
      Common.alert("<spring:message code='service.msg.NoRcd'/>");
      return;
    }

    var AS_ID = selectedItems[0].item.asId;
    var AS_NO = selectedItems[0].item.asNo;
    var asStusId = selectedItems[0].item.code1;
    var asrId = selectedItems[0].item.asResultId;
    var asrNo = selectedItems[0].item.c3;
    var asTotalAmt = selectedItems[0].item.c5;
    var asSeltDt = selectedItems[0].item.strAsSetlDt;
    console.log("strAsSetlDt" + asSeltDt);
    var asmonth = Number(asSeltDt.substring(3, 5));
    var asyear = Number(asSeltDt.substring(6, 10));
    console.log("asmonth" + asmonth + "asyear" + asyear);
    var date = new Date();
    var month = date.getMonth() + 1;
    var day = date.getDate();
    if (date.getDate() < 10) {
      day = "0" + date.getDate();
    }

    // SP_CR_AS_INVC_MST : TO-Be 홈케어용으로 변경필요.
    if (asStusId != "COM") {
      Common.alert("<spring:message code='service.msg.asInvCom' arguments='<b>" + AS_NO + "</b>' htmlEscape='false' argumentSeparator=';' />");
    } else {
      if (asTotalAmt <= 0) {
        Common.alert("<spring:message code='service.msg.asInvNoChr' arguments='<b>" + AS_NO + "</b>' htmlEscape='false' argumentSeparator=';' />");
      } else {
        $("#reportForm #V_SERVICENO").val(asrNo);
        $("#reportForm #V_INVOICETYPE").val(118)
        if(asmonth >= 04 && asyear >= 2024){
            $("#reportForm #reportFileName").val('/statement/TaxInvoice_Miscellaneous_AS_PDF_SST_202404.rpt');
        }else{
            $("#reportForm #reportFileName").val('/statement/TaxInvoice_Miscellaneous_AS_PDF_SST.rpt');
        }
        $("#reportForm #viewType").val("PDF");
        $("#reportForm #reportDownFileName").val("ASInvoice_" + day + month + date.getFullYear());

        var option = {
          isProcedure : true,
        };

        Common.report("reportForm", option);
      }
    }
  }

  function fn_getDateGap(sdate, edate) {
    var startArr, endArr;

    startArr = sdate.split('/');
    endArr = edate.split('/');

    var keyStartDate = new Date(startArr[2], startArr[1], startArr[0]);
    var keyEndDate = new Date(endArr[2], endArr[1], endArr[0]);
    var gap = (keyEndDate.getTime() - keyStartDate.getTime()) / 1000 / 60 / 60 / 24;

    return gap;
  }

  $(function(){
      $('#btnClear').click(function() {
          $('#ASForm').clearForm();
      });
  });

  $.fn.clearForm = function() {
        return this.each(function() {
            var type = this.type, tag = this.tagName.toLowerCase();
            if (tag === 'form'){
                return $(':input',this).clearForm();
            }
            switch(type){
                case 'select': this.selectedIndex = 0;
                                   break;
                case 'checkbox':
                case 'radio': this.checked = false;
                                  break;
                default: this.value = '';
            }
        });
    };
</script>
<section id="content">
 <!-- content start -->
 <ul class="path">
  <!-- <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
  <li>Sales</li>
  <li>Order list</li> -->
 </ul>
 <aside class="title_line">
  <!-- title_line start -->
  <p class="fav">
   <a href="#none" class="click_add_on">My menu</a>
  </p>
  <h2><spring:message code='service.title.AsMgmt'/></h2>
  <form action="#" id="inHOForm">
   <div style="display: none">
    <input type="text" id="in_asId" name="in_asId" />
    <input type="text" id="in_asNo" name="in_asNo" />
    <input type="text" id="in_ordId" name="in_ordId" />
    <input type="text" id="in_asResultId" name="in_asResultId" />
    <input type="text" id="in_asResultNo" name="in_asResultNo" />
    <input type="text" id="dt_range" name="dt_range" value="${DT_RANGE}" />
   </div>
  </form>
  <ul class="right_btns">
   <c:if test="${PAGE_AUTH.funcUserDefine2 == 'Y'}">
    <li><p class="btn_blue">
      <a href="#none" onclick="fn_newASPop()"><spring:message code='service.btn.crtAs'/></a>
     </p></li>
   </c:if>
   <c:if test="${PAGE_AUTH.funcUserDefine4 == 'Y'}">
    <li><p class="btn_blue">
      <a href="#none" onclick="fn_newASResultPop()"><spring:message code='service.btn.addtAs'/></a>
     </p></li>
   </c:if>
   <!-- FUNCTION WHICH ALLOW EDIT RECORD WHICH MORE THAN 7 DAYS -->
   <c:if test="${PAGE_AUTH.funcUserDefine5 == 'Y'}">
    <li><p class="btn_blue">
      <a href="#none" onclick="fn_asResultEditBasicPop(0)"><spring:message code='service.btn.edtBsAs'/></a>
     </p></li>
   </c:if>
   <c:if test="${PAGE_AUTH.funcUserDefine9 == 'Y'}">
    <li><p class="btn_blue">
      <a href="#none" onclick="fn_asResultEditPop(0)"><spring:message code='service.btn.edtAs'/></a>
     </p></li>
   </c:if>
   <!-- FUNCTION WHICH ALLOW EDIT RECORD WITHIN 7 DAYS -->
   <c:if test="${PAGE_AUTH.funcUserDefine3 == 'Y'}">
    <li><p class="btn_blue">
      <a href="#none" onclick="fn_asResultEditBasicPop(1)"><spring:message code='service.btn.edtBsAs'/></a>
     </p></li>
   </c:if>
   <c:if test="${PAGE_AUTH.funcUserDefine3 == 'Y'}">
    <li><p class="btn_blue">
      <a href="#none" onclick="fn_asResultEditPop(1)"><spring:message code='service.btn.edtAs'/></a>
     </p></li>
   </c:if>
   <c:if test="${PAGE_AUTH.funcUserDefine6 == 'Y'}">
    <li><p class="btn_blue">
      <a href="#none" onclick="fn_asResultViewPop()"><spring:message code='service.btn.viewAS'/></a>
     </p></li>
   </c:if>
   <c:if test="${PAGE_AUTH.funcUserDefine7 == 'Y'}">
    <li><p class="btn_blue">
      <a href="#none" onclick="fn_assginCTTransfer()"><spring:message code='home.lbl.dtTrans'/></a>
     </p></li>
   </c:if>
   <c:if test="${PAGE_AUTH.funcView == 'Y'}">
    <li><p class="btn_blue">
      <a href="#none" onClick="fn_searchASManagement()"><span class="search"></span><spring:message code='sys.btn.search'/></a>
     </p></li>
   </c:if>
   <li><p class="btn_blue">
       <a id="btnClear"  href="#"><span class="clear"></span><spring:message code='service.btn.Clear'/></a>
    </p></li>
  </ul>
 </aside>
 <!-- title_line end -->
 <section class="search_table">
  <!-- search_table start -->
  <form action="#" method="post" id="ASForm">
   <table class="type1">
    <!-- table start -->
    <caption>table</caption>
    <colgroup>
     <col style="width: 150px" />
     <col style="width: *" />
     <col style="width: 140px" />
     <col style="width: *" />
     <col style="width: 170px" />
     <col style="width: *" />
    </colgroup>
    <tbody>
     <tr>
      <th scope="row"><spring:message code='service.grid.ASTyp'/></th>
      <td><select class="multy_select w100p" multiple="multiple" id="asType" name="asType">
        <c:forEach var="list" items="${asTyp}" varStatus="status">
          <option value="${list.codeId}">${list.codeName}</option>
        </c:forEach>
      </select></td>
      <th scope="row"><spring:message code='service.title.Status'/></th>
      <td><select class="multy_select w100p" multiple="multiple" id="asStatus" name="asStatus">
        <c:forEach var="list" items="${asStat}" varStatus="status">
         <c:choose>
           <c:when test="${list.codeId=='1'}">
             <option value="${list.codeId}" selected>${list.codeName}</option>
           </c:when>
           <c:when test="${list.codeId=='19'}">
             <option value="${list.codeId}" selected>${list.codeName}</option>
           </c:when>
           <c:otherwise>
             <option value="${list.codeId}">${list.codeName}</option>
           </c:otherwise>
         </c:choose>
        </c:forEach>
      </select></td>
      <th scope="row"><spring:message code='service.title.RequestDate'/></th>
      <td>
       <div class="date_set w100p">
        <p>
         <input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_dateHc" id="createStrDate" name="createStrDate" value="${bfDay}"/>
        </p>
        <span><spring:message code='pay.text.to'/></span>
        <p>
         <input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_dateHc" id="createEndDate" name="createEndDate" value="${toDay}"/>
        </p>
       </div>
      </td>
     </tr>
     <tr>
      <th scope="row"><spring:message code='service.grid.ASNo'/></th>
      <td><input type="text" title="" placeholder="<spring:message code='service.grid.ASNo'/>"
       class="w100p" id="asNum" name="asNum" /></td>
      <th scope="row"><spring:message code='service.grid.ResultNo'/></th>
      <td><input type="text" title="" placeholder="<spring:message code='service.grid.ResultNo'/>"
       class="w100p" id="resultNum" name="resultNum" /></td>
      <th scope="row"><spring:message code='service.title.OrderNumber'/></th>
      <td><input type="text" title="" placeholder="<spring:message code='service.title.OrderNumber'/>"
       class="w100p" id="orderNum" name="orderNum" /></td>
     </tr>

     <tr>
      <th scope="row"><spring:message code='service.title.ASBrch'/></th>
      <td><select id="cmbbranchId" name="cmbbranchId" class="w100p">
      </select></td>
      <th scope="row"><spring:message code='service.title.DSCBranch'/></th>
      <td><select id="cmbbranchId3" name="cmbbranchId3" class="w100p">
      </select></td>
      <th scope="row"><spring:message code='home.lbl.dtCode'/></th>
      <td>
      <%-- <select id="cmbctId" name="cmbctId" class="w100p">
        <option value=""><spring:message code='sal.combo.text.chooseOne'/></option>
      </select> --%>
      <input type="text" title="" placeholder="DT/CT code" class="w100p" id=cmbctId name="cmbctId" />
      </td>
     </tr>

     <tr>
      <th scope="row"><spring:message code='service.grid.CustomerName'/></th>
      <td>
        <input type="text" title="" placeholder="<spring:message code='service.grid.CustomerName'/>" class="w100p" id="custName" name="custName" /></td>
      <th scope="row"><spring:message code='service.title.Product' /></th>
      <td><select class="w100p" id="asProduct" name="asProduct"></select>
      <th scope="row"><spring:message code='service.title.NRIC_CompanyNo'/></th>
      <td>
        <input type="text" title="" placeholder="<spring:message code='service.title.NRIC_CompanyNo'/>" class="w100p" id="nricNum" name="nricNum" /></td>
     </tr>
     <tr>
      <th scope="row"><spring:message code='service.grid.registerDt'/></th>
      <td>
        <div class="date_set w100p">
            <p>
            <input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" id="registerDtFrm" name="registerDtFrm" />
            </p> <span><spring:message code='pay.text.to'/></span> <p>
            <input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" id="registerDtTo" name="registerDtTo" />
            </p>
        </div>
      </td>
      <th scope="row"><spring:message code='service.grid.SettleDate'/></th>
      <td>
       <div class="date_set w100p">
            <p>
            <input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" id="settleDtFrm" name="settleDtFrm" />
            </p><span><spring:message code='pay.text.to'/></span><p>
            <input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" id="settleDtTo" name="settleDtTo" />
            </p>
       </div>
      </td>
      <th scope="row"><spring:message code='service.title.AppointmentDate'/></th>
      <td>
       <div class="date_set w100p">
        <p>
         <input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_dateHc" id="appDtFrm" name="appDtFrm" />
        </p>
        <span><spring:message code='pay.text.to'/></span>
        <p>
         <input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_dateHc" id="appDtTo" name="appDtTo" />
        </p>
       </div>
      </td>
     </tr>
     <tr>
        <th scope="row">Bundle Number</th>
        <td><input type="text" title="bndlNo" id="bndlNo" name="bndlNo" placeholder="Bundle Number" class="w100p" /></td>
        <th></th>
        <td></td>
        <th></th>
        <td></td>
     </tr>
    </tbody>
   </table>
   <!-- table end -->
   <aside class="link_btns_wrap">
    <!-- link_btns_wrap start -->
    <p class="show_btn">
     <a href="#none"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a>
    </p>
    <dl class="link_list">
     <dt><spring:message code='sales.Link'/></dt>
     <dd>
      <ul class="btns">
      </ul>
      <ul class="btns">
        <c:if test="${PAGE_AUTH.funcUserDefine12 == 'Y'}">
        <li><p class="link_btn type2">
          <a href="#none" onclick="fn_ASReport()"><spring:message code='service.btn.asRpt'/></a>
         </p></li>
        </c:if>
        <c:if test="${PAGE_AUTH.funcUserDefine8 == 'Y'}">
        <li><p class="link_btn type2">
          <a href="#none" onclick="fn_asLogBookList()"><spring:message code='service.btn.asLogBook'/></a>
         </p></li>
        <li><p class="link_btn type2">
          <a href="#none" onclick="fn_asRawData(0)"><spring:message code='service.btn.asRawData'/></a>
         </p></li>
        <c:if test="${PAGE_AUTH.funcUserDefine11 == 'Y'}">
         <li>
          <p class="link_btn type2">
           <a href="#none" onclick="fn_asRawData(1)"><spring:message code='service.btn.asRawData'/> (31 Day(s))</a>
          </p>
         </li>
        </c:if>
        <li><p class="link_btn type2">
          <a href="#none" onclick="fn_asSummaryList()">AS Summary Listing</a>
         </p></li>
        <li><p class="link_btn type2">
          <a href="#none" onclick="fn_asYsList()"><spring:message code='service.btn.asYsLst'/></a>
         </p></li>
        <li><p class="link_btn type2">
          <a href="#none" onclick="fn_ledger()"><spring:message code='service.btn.asLdg'/></a>
         </p></li>
        <li><p class="link_btn type2">
          <a href="#none" onclick="fn_invoice()"><spring:message code='service.btn.asInvc'/></a>
         </p></li>
          <!-- By KV - AS Mobile Failure Listing -->
         <li><p class="link_btn type2">
               <a href="#none" onclick="javascript:fn_ASMobileFailureListing()"><spring:message
                   code='service.btn.MobileFailListAS' /></a>
              </p>
          </li>
       </c:if>
      </ul>
      <p class="hide_btn">
       <a href="#none"><img
        src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif"
        alt="hide" /></a>
      </p>
     </dd>
    </dl>
   </aside>
   <!-- link_btns_wrap end -->
   <ul class="right_btns">
    <c:if test="${PAGE_AUTH.funcUserDefine10 == 'Y'}">
     <li><p class="btn_grid">
       <a href="#none" onClick="fn_excelDown()"><spring:message code='service.btn.Generate'/></a>
      </p></li>
    </c:if>
   </ul>
   <article class="grid_wrap">
    <!-- grid_wrap start -->
    <div id="grid_wrap_asList"
     style="width: 100%; height: 500px; margin: 0 auto;"></div>
   </article>
   <!-- grid_wrap end -->

   <input type="hidden" id="orgCode" name="orgCode" value="" />
  <input type="hidden" id="grpCode" name="grpCode" value="" />
  <input type="hidden" id="deptCode" name="deptCode" value="" />

  </form>
  <form action="#" id="reportForm" method="post">
   <input type="hidden" id="V_SERVICENO" name="V_SERVICENO" />
   <input type="hidden" id="V_INVOICETYPE" name="V_INVOICETYPE"/>
   <input type="hidden" id="reportFileName" name="reportFileName" />
   <input type="hidden" id="viewType" name="viewType" />
   <input type="hidden" id="reportDownFileName" name="reportDownFileName" value="DOWN_FILE_NAME" />
  </form>
  <form id='reportFormASLst' method="post" name='reportFormASLst' action="#">
    <input type='hidden' id='reportFileName' name='reportFileName'/>
    <input type='hidden' id='viewType' name='viewType'/>
    <input type='hidden' id='reportDownFileName' name='reportDownFileName'/>
    <input type='hidden' id='V_TEMP' name='V_TEMP'/>
  </form>
 </section>
 <!-- search_table end -->
</section>
<!-- content end -->
