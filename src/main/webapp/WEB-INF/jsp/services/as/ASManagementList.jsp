<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<!--
 DATE        BY     VERSION        REMARK
 ----------------------------------------------------------------
 20/03/2019  ONGHC  1.0.0          RE-STRUCTURE JSP AND ADD APPOINTMENT DATE
 01/04/2019  ONGHC  1.0.1          ADD Column CT Code
 01/04/2019  ONGHC  1.0.2          ADD Column Settle and Last Update Date
 03/06/2019  ONGHC  1.0.3          Amend 7 days checking logic
 03/06/2019  ONGHC  1.0.4          Add 2 Button for Manager Level to Handle 7 Days After AS
 26/07/2019  ONGHC  1.0.5          Add Recall Status
 17/09/2019  ONGHC  1.0.6          Amend fn_ledger to Pass AS no. rather than ASR no.
 17/09/2019  ONGHC  1.0.7          Show Total AS Ledger
 03/10/2019  ONGHC  1.0.8          Add AS Raw Report for 31Days
 17/12/2019  ONGHC  1.0.9          Add BS No. Column
 -->

<script>
    document.write('<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/homecare-js-1.0.js?v='+new Date().getTime()+'"><\/script>');
</script>
<script type="text/javaScript">
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
        asManagementGrid();
        doGetCombo('/services/holiday/selectBranchWithNM', 43, '', 'cmbbranchId', 'M', 'f_multiCombo'); // DSC BRANCH

        $("#cmbbranchId").change(function() { doGetCombo('/services/as/selectCTByDSC.do', $("#cmbbranchId").val(), '', 'cmbctId', 'S', ''); }); // INCHARGE CT

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
                    + "&IND= 1";;

          Common.popupDiv("/services/as/asResultViewPop.do" + param, null, null, true, '_newASResultDiv1');
        });
      });
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
          width : 100
        },
        {
          dataField : "stkDesc",
          headerText : "<spring:message code='service.grid.Product'/>",
          width : 200
        },
        {
          dataField : "asNo",
          headerText : "<spring:message code='service.grid.ASNo'/>",
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
          dataField : "asCrtDt",
          headerText : "<spring:message code='service.grid.registerDt'/>",
          editable : false,
          width : 150,
          dataType : "date",
          formatString : "dd/mm/yyyy"
        },
        {
          dataField : "salesOrdNo",
          headerText : "<spring:message code='service.title.SalesOrder'/>",
          editable : false,
          width : 100
        },
        {
          dataField : "name",
          headerText : "<spring:message code='service.title.CustomerName'/>",
          width : 200
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
          width : 110,
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
          headerText : "<spring:message code='service.grid.CTCode'/>",
          editable : false,
          width : 100
        },
        {
          dataField : "brnchCode",
          headerText : "<spring:message code='service.title.ASBrch'/>",
          width : 100
        },
        {
          dataField : "cms",
          headerText : "<spring:message code='service.title.AllowComm'/>",
          width : 80
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
          width : 100
        },
        {
          dataField : "bsNo",
          headerText : "<spring:message code='service.grid.HSNo'/>",
          editable : false,
          width : 100
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

                           Common.popupDiv("/services/as/resultASReceiveEntryPop.do?mod=VIEW&salesOrderId=" + ordId + "&ordNo=" + ordno + "&AS_NO=" + AS_NO + "&IND= 1", null, null, true, '_viewEntryPopDiv1');
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

    console.log("here1");
    var valid = true;
    var msg = "";

    console.log($("#asNum").val());

    if ($("#asNum").val() == '' && $("#resultNum").val() == '' && $("#orderNum").val() == '') {
        if (startDate == '' && endDate == ''){
            msg = "Request Date is required when AS No.,  Result No. and Order No. are empty.";
            valid = false;
        } else if (startDate != '' && endDate == '') {
            msg = "Request End Date is required.";
            valid = false;
        } else if (startDate == '' && endDate != '') {
            msg = "Request Start Date is required.";
            valid = false;
        } else if (startDate != '' && endDate != ''){
        	console.log("here");
             if (!js.date.checkDateRange(startDate,endDate,"Request", "3"))
                valid = false;

        	/* if (!fn_checkDateRange(startDate,endDate,"Request"))
                valid = false; */
        }
    }

   /*  if (dt_range != "") {
      if (fn_getDateGap(startDate, endDate) > dt_range) {
        var fName = "<b><spring:message code='service.grid.ReqstDt'/></b>";

        Common.alert("<spring:message code='service.msg.asSearchDtRange' arguments='" + fName + " ; <b>" + dt_range +"</b>' htmlEscape='false' argumentSeparator=';' />");
        return false;
      }
    } */

    if (valid){
	    Common.ajax("GET", "/services/as/searchASManagementList.do", $("#ASForm").serialize(), function(result) {
	      AUIGrid.setGridData(myGridID, result);
	    });
    } else {
        Common.alert(msg);
    }
  }

  /* function fn_checkDateRange(startDate, endDate, field){

      var arrStDt = startDate.split('/');
      var arrEnDt = endDate.split('/');
      var dat1 = new Date(arrStDt[2], arrStDt[1], arrStDt[0]);
      var dat2 = new Date(arrEnDt[2], arrEnDt[1], arrEnDt[0]);

      var diff = dat2 - dat1;
      if(diff < 0){
          Common.alert(field + " End Date MUST be greater than " + field + " Start Date.");
          return false;
      }

      if(js.date.dateDiff(dat1, dat2) > 92){ // 3 months = 92
          Common.alert("Please keep the " + field + " range within 3 months.");
          return false;
      }

      return true;
  } */

  function fn_newASPop() { // CREATE AS
    Common.popupDiv("/services/as/ASReceiveEntryPop.do", {in_ordNo : ""}, null, true, '_NewEntryPopDiv1');
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

    Common.popupDiv("/services/as/resultASReceiveEntryPop.do?mod=VIEW&salesOrderId=" + ordId + "&ordNo=" + ordno + "&AS_NO=" + AS_NO + '&AS_ID=' + AS_ID, null, null, true, '_viewEntryPopDiv1');
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

    Common.popupDiv("/services/as/resultASReceiveEntryPop.do" + pram, null, null, true, '_resultNewEntryPopDiv1');
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
        var param = "?ord_Id=" + salesOrdId + "&ord_No=" + salesOrdNo + "&as_No=" + asNo + "&as_Id=" + asId + "&refReqst=" + refReqst + "&as_Rst=" + asRst + "&rcdTms=" + rcdTms;
        Common.popupDiv("/services/as/ASNewResultPop.do" + param, null, null, true, '_newASResultDiv1');
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

    Common.popupDiv("/services/as/asResultEditViewPop.do" + param, null, null, true, '_newASResultDiv1');
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

    Common.popupDiv("/services/as/resultASReceiveEntryPop.do?salesOrderId=" + salesOrdId + "&ordNo=" + salesOrdNo + "&asResultId=" + asResultId, null, null, true, '_resultNewEntryPopDiv1');
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

                Common.popupDiv("/services/as/asResultEditViewPop.do" + param, null, null, true, '_newASResultDiv1');
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

          Common.popupDiv("/services/as/asResultEditViewPop.do" + param, null, null, true, '_newASResultDiv1');
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

        Common.popupDiv("/services/as/asResultEditBasicPop.do" + param, null, null, true, '_newASResultBasicDiv1');
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

    Common.popupDiv("/services/as/assignCTTransferPop.do", null, null, true, '_assginCTTransferDiv');
  }



  function fn_excelDown() {
    // type : "xlsx", "csv", "txt", "xml", "json", "pdf", "object"
    GridCommon.exportTo("grid_wrap_asList", "xlsx", "AS Management");
  }

  function fn_ASReport() {
    Common.popupDiv("/services/as/report/asReportPop.do", null, null, true, '');
  }

  function fn_asLogBookList() {
    Common.popupDiv("/services/as/report/asLogBookListPop.do", null, null, true, '');
  }

  function fn_asRawData(ind) {
    Common.popupDiv("/services/as/report/asRawDataPop.do", {ind: ind}, null, true, '');
  }

  function fn_asSummaryList() {
    Common.popupDiv("/services/as/report/asSummaryListPop.do", null, null, true, '');
  }

  function fn_asYsList() {
    Common.popupDiv("/services/as/report/asYellowSheetPop.do", null, null, true, '');
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
        Common.popupDiv("/services/as/report/asLedgerPop.do?ASNO=" + AS_NO, null, null, true, '');
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
    var asTotalAmt = selectedItems[0].item.c5;
    var asrNo = selectedItems[0].item.c3;
    var date = new Date();
    var month = date.getMonth() + 1;
    var day = date.getDate();
    if (date.getDate() < 10) {
      day = "0" + date.getDate();
    }

    if (asStusId != "COM") {
      Common.alert("<spring:message code='service.msg.asInvCom' arguments='<b>" + AS_NO + "</b>' htmlEscape='false' argumentSeparator=';' />");
    } else {
      if (asTotalAmt <= 0) {
        Common.alert("<spring:message code='service.msg.asInvNoChr' arguments='<b>" + AS_NO + "</b>' htmlEscape='false' argumentSeparator=';' />");
      } else {
        //$("#reportForm #V_RESULTID").val(asrId);
        $("#reportForm #v_serviceNo").val(asrNo);
        $("#reportForm #v_invoiceType").val(118);
        //$("#reportForm #reportFileName").val('/services/ASInvoice.rpt');
        $("#reportForm #reportFileName").val('/statement/TaxInvoice_Miscellaneous_AS_PDF_SST.rpt');
        $("#reportForm #viewType").val("PDF");
        $("#reportForm #reportDownFileName").val("ASInvoice_" + day + month + date.getFullYear());

        var option = {
          isProcedure : true,
        };

        Common.report("reportForm", option);
      }
    }
  }

  /*KV*/
  function fn_aoAsDataListing() {
	  Common.popupDiv("/services/as/report/aoAsDataListingPop.do", null, null, true, '');
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

  function f_multiCombo() {
    $(function() {
        $('#cmbbranchId').change(function() {

        }).multipleSelect({
            selectAll : true, // 전체선택
            width : '80%'
        });
    });
}

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
   <a href="#" class="click_add_on">My menu</a>
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
      <a href="#" onclick="fn_newASPop()"><spring:message code='service.btn.crtAs'/></a>
     </p></li>
   </c:if>
   <c:if test="${PAGE_AUTH.funcUserDefine4 == 'Y'}">
    <li><p class="btn_blue">
      <a href="#" onclick="fn_newASResultPop()"><spring:message code='service.btn.addtAs'/></a>
     </p></li>
   </c:if>
   <!-- FUNCTION WHICH ALLOW EDIT RECORD WHICH MORE THAN 7 DAYS -->
   <c:if test="${PAGE_AUTH.funcUserDefine5 == 'Y'}">
    <li><p class="btn_blue">
      <a href="#" onclick="fn_asResultEditBasicPop(0)"><spring:message code='service.btn.edtBsAs'/></a>
     </p></li>
   </c:if>
   <c:if test="${PAGE_AUTH.funcUserDefine9 == 'Y'}">
    <li><p class="btn_blue">
      <a href="#" onclick="fn_asResultEditPop(0)"><spring:message code='service.btn.edtAs'/></a>
     </p></li>
   </c:if>
   <!-- FUNCTION WHICH ALLOW EDIT RECORD WITHIN 7 DAYS -->
   <c:if test="${PAGE_AUTH.funcUserDefine3 == 'Y'}">
    <li><p class="btn_blue">
      <a href="#" onclick="fn_asResultEditBasicPop(1)"><spring:message code='service.btn.edtBsAs'/></a>
     </p></li>
   </c:if>
   <c:if test="${PAGE_AUTH.funcUserDefine3 == 'Y'}">
    <li><p class="btn_blue">
      <a href="#" onclick="fn_asResultEditPop(1)"><spring:message code='service.btn.edtAs'/></a>
     </p></li>
   </c:if>
   <c:if test="${PAGE_AUTH.funcUserDefine6 == 'Y'}">
    <li><p class="btn_blue">
      <a href="#" onclick="fn_asResultViewPop()"><spring:message code='service.btn.viewAS'/></a>
     </p></li>
   </c:if>
   <c:if test="${PAGE_AUTH.funcUserDefine7 == 'Y'}">
    <li><p class="btn_blue">
      <a href="#" onclick="fn_assginCTTransfer()"><spring:message code='service.btn.ctTrans'/></a>
     </p></li>
   </c:if>
   <c:if test="${PAGE_AUTH.funcView == 'Y'}">
    <li><p class="btn_blue">
      <a href="#" onClick="fn_searchASManagement()"><span class="search"></span><spring:message code='sys.btn.search'/></a>
     </p></li>
   </c:if>
   <li><p class="btn_blue">
     <a href="#"><span class="clear"></span><spring:message code='service.btn.Clear'/></a>
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
         <input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" id="createStrDate" name="createStrDate" value="${bfDay}"/>
        </p>
        <span><spring:message code='pay.text.to'/></span>
        <p>
         <input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" id="createEndDate" name="createEndDate" value="${toDay}"/>
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
      <td><select class="multy_select w100p" multiple="multiple" id="cmbbranchId" name="cmbbranchId"></select></td>
      <th scope="row"><spring:message code='service.grid.CTCode'/></th>
      <td><input type="text" title="" placeholder="<spring:message code='service.grid.CTCode'/>"
       class="w100p" id="cmbctId" name="cmbctId" /></td>
      <th scope="row"><spring:message code='service.title.AppointmentDate'/></th>
      <td>
       <div class="date_set w100p">
        <p>
         <input type="text" title="Create start Date"
          placeholder="DD/MM/YYYY" class="j_date" id="appDtFrm"
          name="appDtFrm" />
        </p>
        <span><spring:message code='pay.text.to'/></span>
        <p>
         <input type="text" title="Create end Date"
          placeholder="DD/MM/YYYY" class="j_date" id="appDtTo"
          name="appDtTo" />
        </p>
       </div>
      </td>
     </tr>
     <tr>
      <th scope="row"><spring:message code='service.grid.CustomerName'/></th>
      <td>
        <input type="text" title="" placeholder="<spring:message code='service.grid.CustomerName'/>" class="w100p" id="custName" name="custName" /></td>
      <th scope="row"><spring:message code='service.grid.Product'/></th>
      <td><select class="multy_select w100p" multiple="multiple" id="asProduct" name="asProduct">
        <c:forEach var="list" items="${asProduct}" varStatus="status">
          <option value="${list.stkId}">${list.stkDesc}</option>
        </c:forEach>
      </select></td>
      <th scope="row"><spring:message code='service.title.NRIC_CompanyNo'/></th>
      <td>
        <input type="text" title="" placeholder="<spring:message code='service.title.NRIC_CompanyNo'/>" class="w100p" id="nricNum" name="nricNum" /></td>
     </tr>
    <tr>
      <th scope="row"><spring:message code='service.grid.registerDt'/></th>
      <td>
       <div class="date_set w100p">
        <p>
         <input type="text" title="Create start Date"
          placeholder="DD/MM/YYYY" class="j_date" id="registerDtFrm"
          name="registerDtFrm" />
        </p>
        <span><spring:message code='pay.text.to'/></span>
        <p>
         <input type="text" title="Create end Date"
          placeholder="DD/MM/YYYY" class="j_date" id="registerDtTo"
          name="registerDtTo" />
        </p>
       </div>
      </td>
      <th scope="row"><spring:message code='service.grid.SettleDate'/></th>
      <td>
       <div class="date_set w100p">
        <p>
         <input type="text" title="Create start Date"
          placeholder="DD/MM/YYYY" class="j_date" id="settleDtFrm"
          name="settleDtFrm" />
        </p>
        <span><spring:message code='pay.text.to'/></span>
        <p>
         <input type="text" title="Create end Date"
          placeholder="DD/MM/YYYY" class="j_date" id="settleDtTo"
          name="settleDtTo" />
        </p>
       </div>
      </td>
      <th scope="row"></th>
      <td></td>
     </tr>
    </tbody>
   </table>
   <!-- table end -->
   <aside class="link_btns_wrap">
    <!-- link_btns_wrap start -->
    <p class="show_btn">
     <a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a>
    </p>
    <dl class="link_list">
     <dt><spring:message code='sales.Link'/></dt>
     <dd>
      <ul class="btns">
      </ul>
      <ul class="btns">
       <c:if test="${PAGE_AUTH.funcUserDefine8 == 'Y'}">
        <li><p class="link_btn type2">
          <a href="#" onclick="fn_ASReport()"><spring:message code='service.btn.asRpt'/></a>
         </p></li>
        <li><p class="link_btn type2">
          <a href="#" onclick="fn_asLogBookList()"><spring:message code='service.btn.asLogBook'/></a>
         </p></li>
        <li><p class="link_btn type2">
          <a href="#" onclick="fn_asRawData(0)"><spring:message code='service.btn.asRawData'/></a>
         </p></li>
        <c:if test="${PAGE_AUTH.funcUserDefine11 == 'Y'}">
         <li>
          <p class="link_btn type2">
           <a href="#" onclick="fn_asRawData(1)"><spring:message code='service.btn.asRawData'/> (31 Day(s))</a>
          </p>
         </li>
        </c:if>
        <li><p class="link_btn type2">
          <a href="#" onclick="fn_asSummaryList()"><spring:message code='service.btn.asSumLst'/></a>
         </p></li>
        <li><p class="link_btn type2">
          <a href="#" onclick="fn_asYsList()"><spring:message code='service.btn.asYsLst'/></a>
         </p></li>
        <li><p class="link_btn type2">
          <a href="#" onclick="fn_ledger()"><spring:message code='service.btn.asLdg'/></a>
         </p></li>
        <li><p class="link_btn type2">
          <a href="#" onclick="fn_invoice()"><spring:message code='service.btn.asInvc'/></a>
         </p></li>
          <!-- By KV - AS Mobile Failure Listing -->
         <li><p class="link_btn type2">
               <a href="#" onclick="javascript:fn_ASMobileFailureListing()"><spring:message
                   code='service.btn.MobileFailListAS' /></a>
              </p>
          </li>
          <!-- By KV - AOAS Data Listing -->
         <c:if test="${PAGE_AUTH.funcUserDefine12 == 'Y'}">
         <li>
          <p class="link_btn type2">
           <a href="#" onclick="fn_aoAsDataListing()"><spring:message code='service.btn.aoAsDataListOmbak'/></a>
          </p>
         </li>
        </c:if>

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
    <c:if test="${PAGE_AUTH.funcUserDefine10 == 'Y'}">
     <li><p class="btn_grid">
       <a href="#" onClick="fn_excelDown()"><spring:message code='service.btn.Generate'/></a>
      </p></li>
    </c:if>
   </ul>
   <article class="grid_wrap">
    <!-- grid_wrap start -->
    <div id="grid_wrap_asList"
     style="width: 100%; height: 500px; margin: 0 auto;"></div>
   </article>
   <!-- grid_wrap end -->
  </form>
  <form action="#" id="reportForm" method="post">
   <!--  <input type="hidden" id="V_RESULTID" name="V_RESULTID" /> -->
   <input type="hidden" id="v_serviceNo" name="v_serviceNo" />
   <input type="hidden" id="v_invoiceType" name="v_invoiceType" />
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
