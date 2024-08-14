<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javaScript">
  //AUIGrid
  var listGridId, viewGridID, stckGridID, giftGridID, priceHistoryGrid, histGridID;

  //Grid에서 선택된 RowID
  var selectedGridValue;

  // Empty Set
  var emptyData = [];

  var arrSrvTypeCode = [{"codeId": "SS"  ,"codeName": "Self Service"},
                        {"codeId": "HS" ,"codeName": "Heart Service"},
                        {"codeId": "BOTH","codeName": "Both"}];

  var stkSizeData = [{"codeId": "KING"  ,"codeName": "KING"},
                     {"codeId": "QUEEN" ,"codeName": "QUEEN"},
                     {"codeId": "SINGLE","codeName": "SINGLE"}];

  var pricehiscolumn2=[{dataField:    "promoReqstId"   ,headerText:    "Seq"     ,width:    "10%"    , visible : true},
                       {dataField:    "promoCode"   ,headerText:    "Promo Code"     ,width:    "10%"    , visible : true},
                       {dataField:    "promoDesc"   ,headerText:    "Promo Name"        ,width:    "10%"    , visible : true},
                       {dataField:    "promoDtFrom"  ,headerText:    "From"        ,width:    "15%"    , visible : true},
                       {dataField:    "promoDtEnd"   ,headerText:    "To"       ,width:    "15%"    , visible : true},
                       {dataField:    "custType" ,headerText:"Customer Type"         ,width:    "18%"    , visible : true},
                       {dataField:    "extrade",headerText :"Ex-Trade"                   ,width:  "10%"    , visible : true},
                       {dataField:    "employee"   ,headerText:    "Employee"     ,width:    "18%"    , visible : true},
                       {dataField:    "discType"   ,headerText:    "Discount Type"     ,width:    "18%"    , visible : true},
                       {dataField:    "prcnt"   ,headerText:    "Discount Value"     ,width:    "18%"    , visible : true},
                       {dataField:    "rpf"   ,headerText:    "RPF Discount"     ,width:    "18%"    , visible : true},
                       {dataField:    "periodType"   ,headerText:    "Period type"     ,width:    "18%"    , visible : true},
                       {dataField:    "discPeriod"   ,headerText:    "Discount Period"     ,width:    "18%"    , visible : true},
                       {dataField:    "addDiscPrc"   ,headerText:    "Additional Discount(RM)"     ,width:    "18%"    , visible : true},
                       {dataField:    "addDiscPv"   ,headerText:    "Additional Discount(PV)"     ,width:    "18%"    , visible : true},
                       {dataField:    "megaDeal"   ,headerText:    "Mega Deal"     ,width:    "10%"    , visible : true},
                       {dataField:    "preBook"   ,headerText:    "Pre Book"     ,width:    "10%"    , visible : true},
                       {dataField:    "applyTo"   ,headerText:    "Apply To"     ,width:    "18%"    , visible : true},
                       {dataField:    "advDisc"   ,headerText:    "Advance Discount"     ,width:    "10%"    , visible : true},
                       {dataField:    "stkSize"   ,headerText:    "Mattress Size"     ,width:    "18%"    , visible : true}
                   ];

  var subgridpros2 = {
          // 페이지 설정
          usePaging : true,
          pageRowCount : 10,
          editable : false,
          noDataMessage : "<spring:message code='sys.info.grid.noDataMessage' />",
          enableSorting : true,
          softRemoveRowMode:false,
          reverseRowNum : true
          };

  $(document)
      .ready(
          function() {

              createAUIGrid();

              doGetComboOrder('/common/selectCodeList.do', '320', 'CODE_ID', '', 'list_promoAppTypeId', 'M', 'fn_multiCombo'); //Common Code
              doGetCombo('/common/selectCodeList.do',  '76', '', 'list_promoTypeId',    'M', 'fn_multiCombo'); //Promo Type


               $("#appvRemark").keyup(function(){
                  $("#characterCount").text($(this).val().length + " of 100 max characters");
            });

              // Master Grid
              AUIGrid.bind(listGridId, "cellClick", function(event) {
                selectedGridValue = event.rowIndex;
              });

              AUIGrid.bind(listGridId, "cellDoubleClick", function(event) {
                  fn_openDivPop('VIEW');
              });

          });

  function createAUIGrid(){
	  //AUIGrid 칼럼 설정
      var columnLayout = [
        { headerText : "promoReqstId",        dataField : "promoReqstId",   visible : false }
        , { headerText : "<spring:message code='sales.AppType2'/>",        dataField : "promoAppTypeName", editable : false }
        , { headerText : "<spring:message code='sales.promo.promoType'/>", dataField : "promoTypeName",    editable : false }
        , { headerText : "<spring:message code='sales.promo.promoNm'/>",   dataField : "promoDesc",        editable : false }
        , { headerText : "<spring:message code='sales.StartDate'/>",       dataField : "promoDtFrom",      editable : false }
        , { headerText : "<spring:message code='sales.EndDate'/>",         dataField : "promoDtEnd",       editable : false }
        , { headerText : "Approval Status",          dataField : "status",      editable : false}
        , { headerText : "Action Tab",          dataField : "actionTab",      editable : false}
        ,{
            dataField : "approver",
            headerText : "Approved By",
            width : 140,
            editable : false,
            style: 'left_style'
        },{
            dataField : "appvDt",
            headerText : "Approval Date",
            width : 110,
            dataType : "date",
            formatString : "dd/mm/yyyy" ,
            editable : false,
            style: 'left_style'
        }, {
            dataField : "creator",
            headerText : "Created By",
            width : 140,
            editable : false,
            style: 'left_style'
        },{
            dataField : "crtDt",
            headerText : "<spring:message code='sal.text.createDate' />",
            width : 110,
            dataType : "date",
            formatString : "dd/mm/yyyy" ,
            editable : false,
            style: 'left_style'
        },
         { headerText : "promoId",        dataField : "promoId",        visible : false}
        , { headerText : "promoAppTypeId", dataField : "promoAppTypeId", visible : false}
        ];

      //그리드 속성 설정
      var gridPros = {
          usePaging           : true,         //페이징 사용
          pageRowCount        : 20,           //한 화면에 출력되는 행 개수 20(기본값:20)
          editable            : true,
          fixedColumnCount    : 1,
          showStateColumn     : false,
          displayTreeOpen     : false,
        //selectionMode       : "singleRow",  //"multipleCells",
          headerHeight        : 30,
          useGroupingPanel    : false,        //그룹핑 패널 사용
          skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
          wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
          showRowNumColumn    : true,         //줄번호 칼럼 렌더러 출력
          noDataMessage       : "No order found.",
          groupingMessage     : "Here groupping"
      };

      listGridId = GridCommon.createAUIGrid("list_promo_grid_wrap", columnLayout, "", gridPros);

  }


  function fn_getSearchList() {
    Common.ajax("GET", "/sales/promotion/selectPromotionApprovalList.do", $("#searchForm").serialize(), function(result) {
      AUIGrid.setGridData(listGridId, result);
    });
  }


  function fn_multiCombo() {
      $(function() {
          $('#list_promoAppTypeId').change(function() {
              //console.log($(this).val());
          }).multipleSelect({
              selectAll: true, // 전체선택
              width: '100%'
          });
          $('#list_promoAppTypeId').multipleSelect("checkAll");
          $('#list_promoTypeId').change(function() {
              //console.log($(this).val());
          }).multipleSelect({
              selectAll: true, // 전체선택
              width: '100%'
          });
          $('#list_promoTypeId').multipleSelect("checkAll");

      });
  }

  function createAUIGridStk() {

      //AUIGrid 칼럼 설정
      var columnLayout1 = [
          { headerText : "<spring:message code='sales.prodCd'/>", dataField  : "itmcd",   editable : false,   width : 100 }
        , { headerText : "<spring:message code='sales.prodNm'/>", dataField  : "itmname", editable : false                  }
        , { headerText : "<spring:message code='sales.normal'/>"
          , children   : [{ headerText : "<spring:message code='sales.mthFeePrc'/>", dataField : "amt",    editable : false, width : 100 }
                        , { headerText : "<spring:message code='sales.rpf'/>",       dataField : "prcRpf", editable : false, width : 100 }
                        , { headerText : "<spring:message code='sales.pv'/>",        dataField : "prcPv",  editable : false, width : 100 }]}
        , { headerText : "<spring:message code='sales.title.Promotion'/>"
          , children   : [{ headerText : "<spring:message code='sales.mthFeePrc'/>", dataField : "promoAmt",    editable : true, width : 100 }
                        , { headerText : "<spring:message code='sales.rpf'/>",       dataField : "promoPrcRpf", editable : false, width : 100 }
                        , { headerText : "<spring:message code='sales.pv'/>",        dataField : "promoItmPv",  editable : true,  width : 100 }]}
        , { headerText : "itmid",         dataField   : "promoItmStkId",    visible  : false, width : 80 }
        , { headerText : "promoReqstItmId",    dataField   : "promoReqstItmId",       visible  : false, width : 80 }
        , { headerText : "savedPvYn",     dataField   : "savedPvYn",        visible  : false, width : 80 }
        , { headerText : "newItm",     dataField   : "newItm",        visible  : false, width : 80 }
        , {dataField: "stkCtgryId", visible: false}
        , {dataField : "srvType", headerText : "<spring:message code='sales.srvType'/>", width : '10%',
        	labelFunction : function( rowIndex, columnIndex, value, headerText, item) {
              var retStr = "Heart Service";
              for(var i=0,len=arrSrvTypeCode.length; i<len; i++) {
                  if(arrSrvTypeCode[i]["codeId"] == value) {
                      retStr = arrSrvTypeCode[i]["codeName"];
                      break;
                  }
              }
              return retStr;
        },
        editRenderer : {
      		 type : "DropDownListRenderer",
               list : arrSrvTypeCode,
               keyField   : "codeId", // key 에 해당되는 필드명
               valueField : "codeName", // value 에 해당되는 필드명
               easyMode : false
        }
      }
        ];

      //그리드 속성 설정
      var gridPros = {
          usePaging           : true,         //페이징 사용
          pageRowCount        : 10,           //한 화면에 출력되는 행 개수 20(기본값:20)
          editable            : false,
          fixedColumnCount    : 1,
          showStateColumn     : false,
          displayTreeOpen     : false,
        //selectionMode       : "singleRow",  //"multipleCells",
          showRowCheckColumn  : false,
          showEditedCellMarker: false,
          softRemoveRowMode   : false,
          headerHeight        : 30,
          useGroupingPanel    : false,        //그룹핑 패널 사용
          skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
          wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
          showRowNumColumn    : true,         //줄번호 칼럼 렌더러 출력
          noDataMessage       : "No order found.",
          groupingMessage     : "Here groupping"
      };

      stckGridID = GridCommon.createAUIGrid("pop_stck_grid_wrap", columnLayout1, "", gridPros);

      //Cell Edit - Promo Amount field is not allowed to edit if it is not a new item.
      AUIGrid.bind(stckGridID, ["cellEditBegin"], function(event) {
          if(event.dataField == "promoAmt" ) {
              if(event.item.newItm != "NEW") {
                  return false;
              }
          }
      });
  }

  function createAUIGridStkView() {

      //AUIGrid 칼럼 설정
      var columnLayout2 = [
          { headerText : "<spring:message code='sales.prodCd'/>", dataField  : "itmcd",   editable : false,   width : 100 }
        , { headerText : "<spring:message code='sales.prodNm'/>", dataField  : "itmname", editable : false                  }
        , { headerText : "<spring:message code='sales.normal'/>"
          , children   : [{ headerText : "<spring:message code='sales.mthFeePrc'/>", dataField : "amt",    editable : false, width : 100 }
                        , { headerText : "<spring:message code='sales.rpf'/>",       dataField : "prcRpf", editable : false, width : 100 }
                        , { headerText : "<spring:message code='sales.pv'/>",        dataField : "prcPv",  editable : false, width : 100 }]}
        , { headerText : "<spring:message code='sales.title.Promotion'/>"
          , children   : [{ headerText : "<spring:message code='sales.mthFeePrc'/>", dataField : "promoAmt",    editable : true, width : 100 }
                        , { headerText : "<spring:message code='sales.rpf'/>",       dataField : "promoPrcRpf", editable : false, width : 100 }
                        , { headerText : "<spring:message code='sales.pv'/>",        dataField : "promoItmPv",  editable : true,  width : 100 }]}
        , { headerText : "itmid",         dataField   : "promoItmStkId",    visible  : false, width : 80 }
        , { headerText : "promoReqstItmId",    dataField   : "promoReqstItmId",       visible  : false, width : 80 }
        , { headerText : "savedPvYn",     dataField   : "savedPvYn",        visible  : false, width : 80 }
        , { headerText : "newItm",     dataField   : "newItm",        visible  : false, width : 80 }
        , {dataField: "stkCtgryId", visible: false}
        , {dataField : "srvType", headerText : "<spring:message code='sales.srvType'/>", width : '10%',
        	labelFunction : function( rowIndex, columnIndex, value, headerText, item) {
              var retStr = "Heart Service";
              for(var i=0,len=arrSrvTypeCode.length; i<len; i++) {
                  if(arrSrvTypeCode[i]["codeId"] == value) {
                      retStr = arrSrvTypeCode[i]["codeName"];
                      break;
                  }
              }
              return retStr;
        },
        editRenderer : {
      		 type : "DropDownListRenderer",
               list : arrSrvTypeCode,
               keyField   : "codeId", // key 에 해당되는 필드명
               valueField : "codeName", // value 에 해당되는 필드명
               easyMode : false
        }
      }
        ];


      //그리드 속성 설정
      var v_gridPros = {
          usePaging           : true,         //페이징 사용
          pageRowCount        : 10,           //한 화면에 출력되는 행 개수 20(기본값:20)
          editable            : false,
          fixedColumnCount    : 1,
          showStateColumn     : false,
          displayTreeOpen     : false,
        //selectionMode       : "singleRow",  //"multipleCells",
          showRowCheckColumn  : false,
          showEditedCellMarker: false,
          softRemoveRowMode   : false,
          headerHeight        : 30,
          useGroupingPanel    : false,        //그룹핑 패널 사용
          skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
          wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
          showRowNumColumn    : true,         //줄번호 칼럼 렌더러 출력
          noDataMessage       : "No order found.",
          groupingMessage     : "Here groupping"
      };

      viewGridID = GridCommon.createAUIGrid("v_pop_stck_grid_wrap", columnLayout2, "", v_gridPros);

      //Cell Edit - Promo Amount field is not allowed to edit if it is not a new item.
      AUIGrid.bind(viewGridID, ["cellEditBegin"], function(event) {
          if(event.dataField == "promoAmt" ) {
              if(event.item.newItm != "NEW") {
                  return false;
              }
          }
      });
  }


  function createAUIGridStkHist() {

      //AUIGrid 칼럼 설정
      var columnLayout3 = [
          { headerText : "Seq", dataField  : "promoReqstId",   editable : false,   width : 50 }
        ,  { headerText : "<spring:message code='sales.prodCd'/>", dataField  : "itmcd",   editable : false,   width : 100 }
        , { headerText : "<spring:message code='sales.prodNm'/>", dataField  : "itmname", editable : false                  }
        , { headerText : "<spring:message code='sales.normal'/>"
          , children   : [{ headerText : "<spring:message code='sales.mthFeePrc'/>", dataField : "amt",    editable : false, width : 100 }
                        , { headerText : "<spring:message code='sales.rpf'/>",       dataField : "prcRpf", editable : false, width : 100 }
                        , { headerText : "<spring:message code='sales.pv'/>",        dataField : "prcPv",  editable : false, width : 100 }]}
        , { headerText : "<spring:message code='sales.title.Promotion'/>"
          , children   : [{ headerText : "<spring:message code='sales.mthFeePrc'/>", dataField : "promoAmt",    editable : true, width : 100 }
                        , { headerText : "<spring:message code='sales.rpf'/>",       dataField : "promoPrcRpf", editable : false, width : 100 }
                        , { headerText : "<spring:message code='sales.pv'/>",        dataField : "promoItmPv",  editable : true,  width : 100 }]}
        , { headerText : "itmid",         dataField   : "promoItmStkId",    visible  : false, width : 80 }
        , { headerText : "promoReqstItmId",    dataField   : "promoReqstItmId",       visible  : false, width : 80 }
        , { headerText : "savedPvYn",     dataField   : "savedPvYn",        visible  : false, width : 80 }
        , { headerText : "newItm",     dataField   : "newItm",        visible  : false, width : 80 }
        , {dataField: "stkCtgryId", visible: false}
        , {dataField : "srvType", headerText : "<spring:message code='sales.srvType'/>", width : '10%',
        	labelFunction : function( rowIndex, columnIndex, value, headerText, item) {
              var retStr = "Heart Service";
              for(var i=0,len=arrSrvTypeCode.length; i<len; i++) {
                  if(arrSrvTypeCode[i]["codeId"] == value) {
                      retStr = arrSrvTypeCode[i]["codeName"];
                      break;
                  }
              }
              return retStr;
        },
        editRenderer : {
      		 type : "DropDownListRenderer",
               list : arrSrvTypeCode,
               keyField   : "codeId", // key 에 해당되는 필드명
               valueField : "codeName", // value 에 해당되는 필드명
               easyMode : false
        }
      }
        ];


      //그리드 속성 설정
      var histGridPros = {
          usePaging           : true,         //페이징 사용
          pageRowCount        : 10,           //한 화면에 출력되는 행 개수 20(기본값:20)
          editable            : false,
          fixedColumnCount    : 1,
          showStateColumn     : false,
          displayTreeOpen     : false,
        //selectionMode       : "singleRow",  //"multipleCells",
          showRowCheckColumn  : false,
          showEditedCellMarker: false,
          softRemoveRowMode   : false,
          headerHeight        : 30,
          useGroupingPanel    : false,        //그룹핑 패널 사용
          skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
          wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
          showRowNumColumn    : true,         //줄번호 칼럼 렌더러 출력
          reverseRowNum : true,

          noDataMessage       : "No order found.",
          groupingMessage     : "Here groupping"
      };

      histGridID = GridCommon.createAUIGrid("hist_stck_grid_wrap", columnLayout3, "", histGridPros);

      //Cell Edit - Promo Amount field is not allowed to edit if it is not a new item.
      AUIGrid.bind(histGridID, ["cellEditBegin"], function(event) {
          if(event.dataField == "promoAmt" ) {
              if(event.item.newItm != "NEW") {
                  return false;
              }
          }
      });
  }

  function fn_addOption(x) {
      $("#promoCustType option:eq(0)").replaceWith("<option value='0'>ALL</option>");
      $("#promoCustType").val(x);
      $("#v_promoCustType option:eq(0)").replaceWith("<option value='0'>ALL</option>");
      $("#v_promoCustType").val(x);

      console.log($("#promoCustType").val());
      console.log($("#v_promoCustType").val());
  }

  function fn_export() {

      var grdLength = "0";
      grdLength = AUIGrid.getGridData(listGridId).length;

      if(Number(grdLength) > 0){
          GridCommon.exportTo("#list_promo_grid_wrap", "xlsx", "PromotionApprovalList");

      }else{
          Common.alert('* <spring:message code="sal.alert.msg.noExport" />');
      }

  }

  function fn_close(){
      $("#editForm")[0].reset();
      $("#modifyForm")[0].reset();
      $("#v_editForm")[0].reset();
      $("#viewForm")[0].reset();
      $("#editPrice_popup").hide();
      $("#viewPrice_popup").hide();

      AUIGrid.destroy(stckGridID);
      AUIGrid.destroy(viewGridID);
      AUIGrid.destroy(priceHistoryGrid);
      AUIGrid.destroy(histGridID);
  }

  function fn_clear() {
    $("#searchForm")[0].reset();
  }

  //View Claim Pop-UP
  function fn_openDivPop(val) {

   selectedItem = null;

          var selectedItem = AUIGrid.getSelectedIndex(listGridId);
          console.log(selectedItem);
          console.log(AUIGrid.getCellValue(listGridId, selectedGridValue,
          "promoReqstId"));

          if (selectedItem[0] > -1) {

              if(AUIGrid.getCellValue(listGridId, selectedGridValue,
              "status") != "In Progress" && val == 'APPV'){
                  Common.alert("Only In Progress request are allowed to do approval");
              }

              else{

              var promoReqstId = AUIGrid.getCellValue(listGridId, selectedGridValue,"promoReqstId");

              var promoId = AUIGrid.getCellValue(listGridId, selectedGridValue,"promoId");

              Common.ajax("GET", "/sales/promotion/selectPromoReqstInfo.do", {
                  "promoReqstId" : promoReqstId
                }, function(promoInfo) {
                    console.log(promoInfo);

                  if(val == 'APPV'){
                      $("#editPrice_popup").show();
                      $("#promoReqstId").val(promoReqstId);
                      $("#promoId").val(promoInfo.promoId);
                      $("#promoDesc").val(promoInfo.promoDesc);
                      $("#promoCode").val(promoInfo.promoCode);
                      $("#promoDtFrom").val(promoInfo.promoDtFrom);
                      $("#promoDtEnd").val(promoInfo.promoDtEnd);
                      $("#promoAddDiscPrc").val(promoInfo.promoAddDiscPrc);
                      $("#promoAddDiscPv").val(promoInfo.promoAddDiscPv);
                      $("#promoDiscPeriod").val(promoInfo.promoDiscPeriod);
                      $("#promoDiscPeriodTp").val(promoInfo.promoDiscPeriodTp);
                      $("#promoFreesvcPeriodTp").val(promoInfo.promoFreesvcPeriodTp);
                      $("#promoIsTrialCnvr").val(promoInfo.promoIsTrialCnvr);
                      $("#promoPrcPrcnt").val(promoInfo.promoPrcPrcnt);
                      $("#promoRpfDiscAmt").val(promoInfo.promoRpfDiscAmt);
                      $("#promoSrvMemPacId").val(promoInfo.promoSrvMemPacId);
                      $("#promoTypeId").val(promoInfo.promoTypeId);
                      $("#stkSize").val(promoInfo.stkSize);
                      $("#empChk").val(promoInfo.empChk);
                      $("#exTrade").val(promoInfo.exTrade);
                      $("#promoAddDiscPrc").val(promoInfo.promoAddDiscPrc);
                      $("#promoAddDiscPv").val(promoInfo.promoAddDiscPv);
                      $("#promoAppTypeId").val(promoInfo.promoAppTypeId);
                      $("#promoCustType").val(promoInfo.promoCustType);
                      $("#actionTab").val(promoInfo.actionTab);
                      $("#chgRemark").val(promoInfo.chgRemark);
                      $("#extradeMonthFrom").val(promoInfo.extradeFr);
                      $("#extradeMonthTo").val(promoInfo.extradeTo);
                      $("#extradeAppType").val(promoInfo.extradeAppType);

                      if(promoInfo.custStatusNew == '1') {
                          $('#custStatusNew').prop("checked", true);
                      }else{
                          $('#custStatusNew').prop("checked", false);
                      }
                      if(promoInfo.custStatusDisen == '1') {
                          $('#custStatusDisen').prop("checked", true);
                      }else{
                          $('#custStatusDisen').prop("checked", false);
                      }
                      if(promoInfo.custStatusEn == '1') {
                          $('#custStatusEn').prop("checked", true);
                      }else{
                          $('#custStatusEn').prop("checked", false);
                      }
                      if(promoInfo.custStatusEnWoutWp == '1') {
                          $('#custStatusEnWoutWp').prop("checked", true);
                      }else{
                          $('#custStatusEnWoutWp').prop("checked", false);
                      }
                      if(promoInfo.custStatusEnWp6m == '1') {
                          $('#custStatusEnWp6m').prop("checked", true);
                      }else{
                          $('#custStatusEnWp6m').prop("checked", false);
                      }

                      doGetComboOrder('/common/selectCodeList.do', '320', 'CODE_ID', promoInfo.promoAppTypeId,    'promoAppTypeId', 'S'); //Promo Application
                      doGetCombo('/common/selectCodeList.do', '76',  promoInfo.promoTypeId,       'promoTypeId',       'S'); //Promo Type
/*                       doGetCombo('/common/selectCodeList.do', '8',   '',     'promoCustType',     'S', 'fn_addOption()'); //Customer Type
 */                      doGetComboOrder('/common/selectCodeList.do', '322', 'CODE_ID', promoInfo.promoDiscPeriodTp, 'promoDiscPeriodTp', 'S'); //Discount period
                      doGetComboData('/common/selectCodeList.do', {groupCode :'325'}, promoInfo.exTrade,              'exTrade',              'S'); //EX_Trade
                      doGetComboData('/common/selectCodeList.do', {groupCode :'324'}, promoInfo.empChk,               'empChk',               'S'); //EMP_CHK
                      doGetComboData('/common/selectCodeList.do', {groupCode :'323'}, promoInfo.promoDiscType,        'promoDiscType',        'S'); //Discount Type
                    //doGetComboData('/common/selectCodeList.do', {groupCode :'321'}, ${promoInfo.promoFreesvcPeriodTp}, 'promoFreesvcPeriodTp', 'S'); //Free SVC Period
                      doGetComboData('/common/selectCodeList.do', {groupCode :'451', orderValue:'CODE_ID'}, promoInfo.eSales,        'eSales',        'S'); //Discount Type
                    //doGetCombo('/sales/promotion/selectMembershipPkg.do', ${promoInfo.promoSrvMemPacId}, '9', 'promoSrvMemPacId', 'S'); //Common Code
                      doGetComboCodeId('/sales/promotion/selectMembershipPkg.do', {promoAppTypeId : promoInfo.promoAppTypeId}, promoInfo.promoSrvMemPacId, 'promoSrvMemPacId', 'S'); //Common Code
                      doGetCombo('/common/selectCodeList.do', '568',  promoInfo.promoDiscOnBill, 'promoSpecialDisId',       'S'); //Discount on billing
                     doGetCombo('/common/selectCodeList.do', '581', promoInfo.extradeAppType, 'extradeAppType', 'S'); //Extrade App Type

                      doDefCombo(stkSizeData, promoInfo.stkSize ,'stkSize', 'S', '');

                      if(promoInfo.megaDeal == '1') {
                          $('#megaDealY').prop("checked", true);
                      }
                      else {
                          $('#megaDealN').prop("checked", true);
                      }

                      if(promoInfo.advDisc == '1') {
                          $('#advDiscY').prop("checked", true);
                      }
                      else {
                          $('#advDiscN').prop("checked", true);
                      }

                      if(promoInfo.preBook == '1') {
                          $('#preBookY').prop("checked", true);
                      }
                      else {
                          $('#preBookN').prop("checked", true);
                      }

                      if(promoInfo.voucherPromotion == '1') {
                          $('#voucherPromotionY').prop("checked", true);
                      }
                      else {
                          $('#voucherPromotionN').prop("checked", true);
                      }

                      if(promoInfo.woHs == '1'){
                          $('#woHsY').prop("checked", true);
                      }
                      else{
                          $('#woHsN').prop("checked", true);
                      }

                      $('#modifyForm').find(':input').prop("disabled", true);

                      fn_selectPromotionPrdListAjax(promoReqstId, val);

                      createAUIGridStk();

                  } else {

                	  AUIGrid.destroy(histGridID);

                      $("#viewPrice_popup").show();
                      $("#v_promoReqstId").val(promoReqstId);
                      $("#v_promoId").val(promoInfo.promoId);
                      $("#v_promoDesc").val(promoInfo.promoDesc);
                      $("#v_promoCode").val(promoInfo.promoCode);
                      $("#v_promoDtFrom").val(promoInfo.promoDtFrom);
                      $("#v_promoDtEnd").val(promoInfo.promoDtEnd);
                      $("#v_promoAddDiscPrc").val(promoInfo.promoAddDiscPrc);
                      $("#v_promoAddDiscPv").val(promoInfo.promoAddDiscPv);
                      $("#v_promoDiscPeriod").val(promoInfo.promoDiscPeriod);
                      $("#v_promoDiscPeriodTp").val(promoInfo.promoDiscPeriodTp);
                      $("#v_promoFreesvcPeriodTp").val(promoInfo.promoFreesvcPeriodTp);
                      $("#v_promoIsTrialCnvr").val(promoInfo.promoIsTrialCnvr);
                      $("#v_promoPrcPrcnt").val(promoInfo.promoPrcPrcnt);
                      $("#v_promoRpfDiscAmt").val(promoInfo.promoRpfDiscAmt);
                      $("#v_promoSrvMemPacId").val(promoInfo.promoSrvMemPacId);
                      $("#v_promoTypeId").val(promoInfo.promoTypeId);
                      $("#v_stkSize").val(promoInfo.stkSize);
                      $("#v_empChk").val(promoInfo.empChk);
                      $("#v_exTrade").val(promoInfo.exTrade);
                      $("#v_promoAddDiscPrc").val(promoInfo.promoAddDiscPrc);
                      $("#v_promoAddDiscPv").val(promoInfo.promoAddDiscPv);
                      $("#v_promoAppTypeId").val(promoInfo.promoAppTypeId);
                      $("#v_promoCustType").val(promoInfo.promoCustType);
                      $("#v_actionTab").val(promoInfo.actionTab);
                      $("#v_appvRemark").val(promoInfo.appvRemark);
                      $("#v_appvStatus").val(promoInfo.appvStatus);
                      $("#v_chgRemark").val(promoInfo.chgRemark);
                      $("#v_extradeMonthFrom").val(promoInfo.extradeFr);
                      $("#v_extradeMonthTo").val(promoInfo.extradeTo);
                      $("#v_extradeAppType").val(promoInfo.extradeAppType);

                      if(promoInfo.custStatusNew == '1') {
                          $('#v_custStatusNew').prop("checked", true);
                      }else{
                          $('#v_custStatusNew').prop("checked", false);
                      }
                      if(promoInfo.custStatusDisen == '1') {
                          $('#v_custStatusDisen').prop("checked", true);
                      }else{
                          $('#v_custStatusDisen').prop("checked", false);
                      }
                      if(promoInfo.custStatusEn == '1') {
                          $('#v_custStatusEn').prop("checked", true);
                      }else{
                          $('#v_custStatusEn').prop("checked", false);
                      }
                      if(promoInfo.custStatusEnWoutWp == '1') {
                          $('#v_custStatusEnWoutWp').prop("checked", true);
                      }else{
                          $('#v_custStatusEnWoutWp').prop("checked", false);
                      }
                      if(promoInfo.custStatusEnWp6m == '1') {
                          $('#v_custStatusEnWp6m').prop("checked", true);
                      }else{
                          $('#v_custStatusEnWp6m').prop("checked", false);
                      }

                      doGetComboOrder('/common/selectCodeList.do', '320', 'CODE_ID', promoInfo.promoAppTypeId,    'v_promoAppTypeId', 'S'); //Promo Application
                      doGetCombo('/common/selectCodeList.do', '76',  promoInfo.promoTypeId,       'v_promoTypeId',       'S'); //Promo Type
/*                       doGetCombo('/common/selectCodeList.do', '8',   '',     'v_promoCustType',     'S', 'fn_addOption'); //Customer Type
 */                      doGetComboOrder('/common/selectCodeList.do', '322', 'CODE_ID', promoInfo.promoDiscPeriodTp, 'v_promoDiscPeriodTp', 'S'); //Discount period
                      doGetComboData('/common/selectCodeList.do', {groupCode :'325'}, promoInfo.exTrade,              'v_exTrade',              'S'); //EX_Trade
                      doGetComboData('/common/selectCodeList.do', {groupCode :'324'}, promoInfo.empChk,               'v_empChk',               'S'); //EMP_CHK
                      doGetComboData('/common/selectCodeList.do', {groupCode :'323'}, promoInfo.promoDiscType,        'v_promoDiscType',        'S'); //Discount Type
                    //doGetComboData('/common/selectCodeList.do', {groupCode :'321'}, ${promoInfo.promoFreesvcPeriodTp}, 'promoFreesvcPeriodTp', 'S'); //Free SVC Period
                      doGetComboData('/common/selectCodeList.do', {groupCode :'451', orderValue:'CODE_ID'}, promoInfo.eSales,        'v_eSales',        'S'); //Discount Type
                      doGetCombo('/common/selectCodeList.do', '568',  promoInfo.promoDiscOnBill, 'v_promoSpecialDisId',       'S'); //Discount on billing
                    //doGetCombo('/sales/promotion/selectMembershipPkg.do', ${promoInfo.promoSrvMemPacId}, '9', 'promoSrvMemPacId', 'S'); //Common Code
                      doGetComboCodeId('/sales/promotion/selectMembershipPkg.do', {promoAppTypeId : promoInfo.promoAppTypeId}, promoInfo.promoSrvMemPacId, 'v_promoSrvMemPacId', 'S'); //Common Code
                      doGetCombo('/common/selectCodeList.do', '581', promoInfo.extradeAppType, 'v_extradeAppType', 'S'); //Extrade App Type

                      doDefCombo(stkSizeData, promoInfo.stkSize ,'v_stkSize', 'S', '');

                      if(promoInfo.megaDeal == '1') {
                          $('#v_megaDealY').prop("checked", true);
                      }
                      else {
                          $('#v_megaDealN').prop("checked", true);
                      }

                      if(promoInfo.advDisc == '1') {
                          $('#v_advDiscY').prop("checked", true);
                      }
                      else {
                          $('#v_advDiscN').prop("checked", true);
                      }

                      if(promoInfo.preBook == '1') {
                          $('#v_preBookY').prop("checked", true);
                      }
                      else {
                          $('#v_preBookN').prop("checked", true);
                      }

                      if(promoInfo.voucherPromotion == '1') {
                          $('#v_voucherPromotionY').prop("checked", true);
                      }
                      else {
                          $('#v_voucherPromotionN').prop("checked", true);
                      }

                      if(promoInfo.woHs == '1'){
                          $('#v_woHsY').prop("checked", true);
                      }
                      else{
                          $('#v_woHsN').prop("checked", true);
                      }

                      $('#viewForm').find(':input').prop("disabled", true);
                      $('#v_editForm').find(':input').prop("disabled", true);

                      fn_selectPromotionPrdListAjax(promoReqstId, val);

                      createAUIGridStkView();

                      fn_selectPromoHistList(promoId);

                      priceHistoryGrid = AUIGrid.create("#histList_grid_wrap", pricehiscolumn2, subgridpros2);

                      createAUIGridStkHist();
                      fn_selectPromotionPrdHistListAjax(promoId);

                  }
                });
              }

            } else {
              Common.alert("Please select a request");
            }

  }

  function fn_selectPromoHistList(promoId){
	  Common.ajax("GET", "/sales/promotion/selectPromoHistList.do", { promoId : promoId }, function(result) {
		  AUIGrid.setGridData(priceHistoryGrid, result);

	  });
  }

  function fn_selectPromotionPrdListAjax(promoReqstId, opt) {
      console.log('fn_selectPromotionPrdListAjax START');
      Common.ajax("GET", "/sales/promotion/selectPromoReqstPrdList.do", { promoReqstId : promoReqstId }, function(result) {


          if(opt == 'APPV'){

        	  AUIGrid.setGridData(stckGridID, result);
              fn_getPrdPriceInfo();
          }
          else {
              AUIGrid.setGridData(viewGridID, result);
              fn_getPrdPriceInfoView();
          }
      });
  }

  function fn_selectPromotionPrdHistListAjax(promoId, opt) {
      Common.ajax("GET", "/sales/promotion/selectPromoReqstPrdHistList.do", { promoId : promoId }, function(result) {

    	  console.log(result);
           AUIGrid.setGridData(histGridID, result);

           for(var i = 0; i < result.length; i++) {
               for(var j = 0; j < AUIGrid.getRowCount(histGridID) ; j++) {
                   var stkId = AUIGrid.getCellValue(histGridID, j, "promoItmStkId");
                   if(stkId == result[i].promoItmStkId) {
                       AUIGrid.setCellValue(histGridID, j, "amt",    result[i].amt);
                       AUIGrid.setCellValue(histGridID, j, "prcRpf", result[i].prcRpf);
                       AUIGrid.setCellValue(histGridID, j, "prcPv",  result[i].prcPv);
                       AUIGrid.setCellValue(histGridID, j, "stkCtgryId",  result[i].stkCtgryId);

                       var orgPrcVal = AUIGrid.getCellValue(histGridID, j, "amt");
                       var promoDiscType = AUIGrid.getCellValue(histGridID, j, "promoDiscType");
                       var appType = AUIGrid.getCellValue(histGridID, j, "promoAppTypeId");
                       var dscPrcVal = AUIGrid.getCellValue(histGridID, j, "promoPrcPrcnt");
                       var addPrcVal = AUIGrid.getCellValue(histGridID, j, "promoAddDiscPrc");
                       var newPrcVal = 0;

                       if(promoDiscType == '0') {//%
                           newPrcVal = orgPrcVal - (orgPrcVal * (dscPrcVal / 100)) - addPrcVal;
                       }
                       else {
                           newPrcVal = orgPrcVal - dscPrcVal - addPrcVal;
                       }

                       newPrcVal = Math.floor(newPrcVal);

                       if(newPrcVal < 0) newPrcVal = 0;
                       if((!(AUIGrid.getCellValue(histGridID, j, "stkCtgryId") == 7177) || dscPrcVal != 0) && appType == '2285' ) newPrcVal = (Math.trunc(newPrcVal / 10)) * 10  ; // if App Tye = Outright , trunc amount 0 -- edited by TPY 01/06/2018

                       AUIGrid.setCellValue(histGridID, j, "promoAmt", newPrcVal);

                       var orgRpfVal = 0;
                       var dscRpfVal = AUIGrid.getCellValue(histGridID, j, "promoRpfDiscAmt");
                       var newRpfVal = 0;
                       var extrade = AUIGrid.getCellValue(histGridID, j, "exTrade");

                       orgRpfVal = AUIGrid.getCellValue(histGridID, j, "prcRpf");

                           if(appType != 2284 || extrade == '1') {
                               newRpfVal = 0;
                           }
                           else {
                               newRpfVal = orgRpfVal - dscRpfVal;
                           }

                           if(newRpfVal < 0) newRpfVal = 0;

                           AUIGrid.setCellValue(histGridID, j, "promoPrcRpf", newRpfVal);

                           var orgPvVal = 0;
                           var dscPvVal = 0;
                           var addPvVal = AUIGrid.getCellValue(histGridID, j, "promoAddDiscPv");
                           var newPvVal = 0;
                           var gstPvVal = 0;
                           var savedPvYn;

                               savedPvYn = AUIGrid.getCellValue(histGridID, j, "savedPvYn");

                               if(savedPvYn == "Y") {
                                   continue;
                               }

                               orgPvVal  = AUIGrid.getCellValue(histGridID, j, "prcPv");

                               if($('#exTrade').val() == '1') {
                                   orgPvVal = orgPvVal * (70/100);
                               }

                               if(appType == '2284') {
                                   dscPvVal = dscRpfVal;
                               }
                               else if(appType == '2285' || appType == '2287'){
                                   dscPvVal = AUIGrid.getCellValue(histGridID, j, "amt") - AUIGrid.getCellValue(histGridID, j, "promoAmt");
                               }

                               newPvVal = fn_calcPvVal(orgPvVal - dscPvVal - addPvVal);
                               gstPvVal = fn_calcPvVal(orgPvVal - Math.floor(dscPvVal*(1/1.06)) - addPvVal);

                               console.log('dscPvVal   :'+dscPvVal);
                               console.log('dscPvValGST:'+Math.floor(dscPvVal*(1/1.06)));

                               if(newPvVal < 0) newPvVal = 0;
                               if(gstPvVal < 0) gstPvVal = 0;

                               AUIGrid.setCellValue(histGridID, i, "promoItmPv", newPvVal);
                               AUIGrid.setCellValue(histGridID, i, "promoItmPvGst", gstPvVal);

                   }
               }
           }

      });
  }

  function fn_getPrdPriceInfo() {

      var promotionVO = {
          salesPromoMVO : {
              promoAppTypeId         : $('#promoAppTypeId').val(),
              promoSrvMemPacId       : $('#promoSrvMemPacId').val()
          },
          salesPromoDGridDataSetList : GridCommon.getGridData(stckGridID)
      };

      Common.ajax("POST", "/sales/promotion/selectPriceInfo.do", promotionVO, function(result) {

          var arrGridData = AUIGrid.getGridData(stckGridID);

          for(var i = 0; i < result.length; i++) {
              for(var j = 0; j < AUIGrid.getRowCount(stckGridID) ; j++) {
                  var stkId = AUIGrid.getCellValue(stckGridID, j, "promoItmStkId");
                  if(stkId == result[i].promoItmStkId) {
                      AUIGrid.setCellValue(stckGridID, j, "amt",    result[i].amt);
                      AUIGrid.setCellValue(stckGridID, j, "prcRpf", result[i].prcRpf);
                      AUIGrid.setCellValue(stckGridID, j, "prcPv",  result[i].prcPv);
                      AUIGrid.setCellValue(stckGridID, j, "stkCtgryId",  result[i].stkCtgryId);
                  }
              }
          }

          fn_calcDiscountPrice();

          fn_calcDiscountRPF();

          fn_calcDiscountPV();
      });
  }

  function fn_calcDiscountPrice() {

      var orgPrcVal = 0;
      var dscPrcVal = FormUtil.isEmpty($('#promoPrcPrcnt').val())  ? 0 : $('#promoPrcPrcnt').val().trim();
      var addPrcVal = FormUtil.isEmpty($('#promoAddDiscPrc').val()) ? 0 : $('#promoAddDiscPrc').val().trim();
      var newPrcVal = 0;

      for(var i = 0; i < AUIGrid.getRowCount(stckGridID) ; i++) {

          orgPrcVal = AUIGrid.getCellValue(stckGridID, i, "amt");

          if($('#promoDiscType').val() == '0') {//%
              newPrcVal = orgPrcVal - (orgPrcVal * (dscPrcVal / 100)) - addPrcVal;
          }
          else {
              newPrcVal = orgPrcVal - dscPrcVal - addPrcVal;
          }

          newPrcVal = Math.floor(newPrcVal);

          if(newPrcVal < 0) newPrcVal = 0;
          if((!(AUIGrid.getCellValue(stckGridID, i, "stkCtgryId") == 7177) || dscPrcVal != 0) && $('#promoAppTypeId').val() == '2285' ) newPrcVal = (Math.trunc(newPrcVal / 10)) * 10  ; // if App Tye = Outright , trunc amount 0 -- edited by TPY 01/06/2018

          AUIGrid.setCellValue(stckGridID, i, "promoAmt", newPrcVal);
      }
  }

  function fn_calcDiscountRPF() {

      var orgRpfVal = 0;
      var dscRpfVal = FormUtil.isEmpty($('#promoRpfDiscAmt').val()) ? 0 : $('#promoRpfDiscAmt').val().trim();
      var newRpfVal = 0;

      for(var i = 0; i < AUIGrid.getRowCount(stckGridID) ; i++) {

          orgRpfVal = AUIGrid.getCellValue(stckGridID, i, "prcRpf");

          if($('#promoAppTypeId').val() != 2284 || $('#exTrade').val() == '1') {
              newRpfVal = 0;
          }
          else {
              newRpfVal = orgRpfVal - dscRpfVal;
          }

          if(newRpfVal < 0) newRpfVal = 0;

          AUIGrid.setCellValue(stckGridID, i, "promoPrcRpf", newRpfVal);
      }
  }

  function fn_calcDiscountPV() {
      console.log('fn_calcDiscountPV() START');
      var orgPvVal = 0;
      var dscPvVal = 0;
      var addPvVal = FormUtil.isEmpty($('#promoAddDiscPv').val()) ? 0 : $('#promoAddDiscPv').val().trim();
      var newPvVal = 0;
      var gstPvVal = 0;
      var savedPvYn;

      for(var i = 0; i < AUIGrid.getRowCount(stckGridID) ; i++) {

          savedPvYn = AUIGrid.getCellValue(stckGridID, i, "savedPvYn");

          if(savedPvYn == "Y") {
              continue;
          }

          orgPvVal  = AUIGrid.getCellValue(stckGridID, i, "prcPv");

          if($('#exTrade').val() == '1') {
              orgPvVal = orgPvVal * (70/100);
          }

          if($('#promoAppTypeId').val() == '2284') {
              dscPvVal = FormUtil.isEmpty($('#promoRpfDiscAmt').val()) ? 0 : $('#promoRpfDiscAmt').val().trim();
          }
          else if($('#promoAppTypeId').val() == '2285' || $('#promoAppTypeId').val() == '2287'){
              dscPvVal = AUIGrid.getCellValue(stckGridID, i, "amt") - AUIGrid.getCellValue(stckGridID, i, "promoAmt");
          }

          newPvVal = fn_calcPvVal(orgPvVal - dscPvVal - addPvVal);
          gstPvVal = fn_calcPvVal(orgPvVal - Math.floor(dscPvVal*(1/1.06)) - addPvVal);

          console.log('dscPvVal   :'+dscPvVal);
          console.log('dscPvValGST:'+Math.floor(dscPvVal*(1/1.06)));

          if(newPvVal < 0) newPvVal = 0;
          if(gstPvVal < 0) gstPvVal = 0;

          AUIGrid.setCellValue(stckGridID, i, "promoItmPv", newPvVal);
          AUIGrid.setCellValue(stckGridID, i, "promoItmPvGst", gstPvVal);
      }
  }

  function fn_getPrdPriceInfoView() {

      var promotionVO = {
          salesPromoMVO : {
              promoAppTypeId         : $('#v_promoAppTypeId').val(),
              promoSrvMemPacId       : $('#v_promoSrvMemPacId').val()
          },
          salesPromoDGridDataSetList : GridCommon.getGridData(viewGridID)
      };

      Common.ajax("POST", "/sales/promotion/selectPriceInfo.do", promotionVO, function(result) {

          var arrGridData = AUIGrid.getGridData(viewGridID);

          for(var i = 0; i < result.length; i++) {
              for(var j = 0; j < AUIGrid.getRowCount(viewGridID) ; j++) {
                  var stkId = AUIGrid.getCellValue(viewGridID, j, "promoItmStkId");
                  if(stkId == result[i].promoItmStkId) {
                      AUIGrid.setCellValue(viewGridID, j, "amt",    result[i].amt);
                      AUIGrid.setCellValue(viewGridID, j, "prcRpf", result[i].prcRpf);
                      AUIGrid.setCellValue(viewGridID, j, "prcPv",  result[i].prcPv);
                      AUIGrid.setCellValue(viewGridID, j, "stkCtgryId",  result[i].stkCtgryId);
                  }
              }
          }

          fn_calcDiscountPriceView();

          fn_calcDiscountRPFView();

          fn_calcDiscountPVView();
      });
  }

  function fn_calcDiscountPriceView() {

      var orgPrcVal = 0;
      var dscPrcVal = FormUtil.isEmpty($('#v_promoPrcPrcnt').val())  ? 0 : $('#v_promoPrcPrcnt').val().trim();
      var addPrcVal = FormUtil.isEmpty($('#v_promoAddDiscPrc').val()) ? 0 : $('#v_promoAddDiscPrc').val().trim();
      var newPrcVal = 0;

      for(var i = 0; i < AUIGrid.getRowCount(viewGridID) ; i++) {

          orgPrcVal = AUIGrid.getCellValue(viewGridID, i, "amt");

          if($('#v_promoDiscType').val() == '0') {//%
              newPrcVal = orgPrcVal - (orgPrcVal * (dscPrcVal / 100)) - addPrcVal;
          }
          else {
              newPrcVal = orgPrcVal - dscPrcVal - addPrcVal;
          }

          newPrcVal = Math.floor(newPrcVal);

          if(newPrcVal < 0) newPrcVal = 0;
          if((!(AUIGrid.getCellValue(viewGridID, i, "stkCtgryId") == 7177) || dscPrcVal != 0) && $('#v_promoAppTypeId').val() == '2285' ) newPrcVal = (Math.trunc(newPrcVal / 10)) * 10  ; // if App Tye = Outright , trunc amount 0 -- edited by TPY 01/06/2018

          AUIGrid.setCellValue(viewGridID, i, "promoAmt", newPrcVal);
      }
  }

  function fn_calcDiscountRPFView() {

      var orgRpfVal = 0;
      var dscRpfVal = FormUtil.isEmpty($('#v_promoRpfDiscAmt').val()) ? 0 : $('#v_promoRpfDiscAmt').val().trim();
      var newRpfVal = 0;

      for(var i = 0; i < AUIGrid.getRowCount(viewGridID) ; i++) {

          orgRpfVal = AUIGrid.getCellValue(viewGridID, i, "prcRpf");

          if($('#v_promoAppTypeId').val() != 2284 || $('#v_exTrade').val() == '1') {
              newRpfVal = 0;
          }
          else {
              newRpfVal = orgRpfVal - dscRpfVal;
          }

          if(newRpfVal < 0) newRpfVal = 0;

          AUIGrid.setCellValue(viewGridID, i, "promoPrcRpf", newRpfVal);
      }
  }

  function fn_calcDiscountPVView() {
      console.log('fn_calcDiscountPV() START');
      var orgPvVal = 0;
      var dscPvVal = 0;
      var addPvVal = FormUtil.isEmpty($('#v_promoAddDiscPv').val()) ? 0 : $('#v_promoAddDiscPv').val().trim();
      var newPvVal = 0;
      var gstPvVal = 0;
      var savedPvYn;

      for(var i = 0; i < AUIGrid.getRowCount(viewGridID) ; i++) {

          savedPvYn = AUIGrid.getCellValue(viewGridID, i, "savedPvYn");

          if(savedPvYn == "Y") {
              continue;
          }

          orgPvVal  = AUIGrid.getCellValue(viewGridID, i, "prcPv");

          if($('#v_exTrade').val() == '1') {
              orgPvVal = orgPvVal * (70/100);
          }

          if($('#v_promoAppTypeId').val() == '2284') {
              dscPvVal = FormUtil.isEmpty($('#v_promoRpfDiscAmt').val()) ? 0 : $('#v_promoRpfDiscAmt').val().trim();
          }
          else if($('#v_promoAppTypeId').val() == '2285' || $('#v_promoAppTypeId').val() == '2287'){
              dscPvVal = AUIGrid.getCellValue(viewGridID, i, "amt") - AUIGrid.getCellValue(viewGridID, i, "promoAmt");
          }

          newPvVal = fn_calcPvVal(orgPvVal - dscPvVal - addPvVal);
          gstPvVal = fn_calcPvVal(orgPvVal - Math.floor(dscPvVal*(1/1.06)) - addPvVal);

          console.log('dscPvVal   :'+dscPvVal);
          console.log('dscPvValGST:'+Math.floor(dscPvVal*(1/1.06)));

          if(newPvVal < 0) newPvVal = 0;
          if(gstPvVal < 0) gstPvVal = 0;

          AUIGrid.setCellValue(viewGridID, i, "promoItmPv", newPvVal);
          AUIGrid.setCellValue(viewGridID, i, "promoItmPvGst", gstPvVal);
      }
  }


  hideNewPopup = function(val) {

        $(val).hide();
   }

  function fn_save() {

      var isValid = true, msg = "";

      if(FormUtil.isEmpty($('#appvStatus').val())) {
          isValid = false;
          msg += "Please choose a status";
      }
     if(FormUtil.isEmpty($('#appvRemark').val()) && $("#appvStatus").val() == '6') {
          isValid = false;
          msg += "Please enter remark";
      }

      if(!isValid) {
          Common.alert("Promotion Approval" + DEFAULT_DELIMITER + "<b>"+msg+"</b>");
          return false;
      }

      else {
           Common
           .confirm(
               "Do you want to proceed to save this request approval?",
               function() {
            	   if($('#actionTab').val() == 'NEW'){
            		   fn_doSaveNew();
            	   }

            	   else {
            		   fn_doSaveModify();
            	   }

               });
      }
    }

  function fn_doSaveNew() {
	  console.log($('#appvStatus').val());
	   console.log($('#appvStatus').val().trim());

       var vCustStatusNew = "";
       var vCustStatusDisen = "";
       var vCustStatusEn = "";
       var vCustStatusEnWoutWp = "";
       var vCustStatusEnWp6m = "";
       if($('#custStatusNew').is(":checked")) {
           vCustStatusNew = 1;
       }else{
           vCustStatusNew = 0;
       }
       if($('#custStatusDisen').is(":checked")) {
           vCustStatusDisen = 1;
       }else{
           vCustStatusDisen = 0;
       }
       if($('#custStatusEn').is(":checked")) {
           vCustStatusEn = 1;
       }else{
           vCustStatusEn = 0;
       }
       if($('#custStatusEnWoutWp').is(":checked")) {
    	   vCustStatusEnWoutWp = 1;
       }else{
    	   vCustStatusEnWoutWp = 0;
       }
       if($('#custStatusEnWp6m').is(":checked")) {
       		vCustStatusEnWp6m = 1;
       }else{
       		vCustStatusEnWp6m = 0;
       }

      var promotionVO = {

              salesPromoMVO : {
                  promoReqstId            : $('#promoReqstId').val(),
                  promoId                 : $('#promoId').val(),
                  promoCode               : $('#promoCode').val(),
                  promoDesc               : $('#promoDesc').val().trim(),
                  promoTypeId             : $('#promoTypeId').val(),
                  promoAppTypeId          : $('#promoAppTypeId').val(),
                  promoSrvMemPacId        : $('#promoSrvMemPacId').val(),
                  promoDtFrom             : $('#promoDtFrom').val().trim(),
                  promoDtEnd              : $('#promoDtEnd').val().trim(),
                  promoPrcPrcnt           : $('#promoPrcPrcnt').val().trim(),
                  promoCustType           : $('#promoCustType').val().trim(),
                  promoDiscType           : $('#promoDiscType option:selected').val(),
                  promoRpfDiscAmt         : $('#promoRpfDiscAmt').val(),
                  promoDiscPeriodTp       : $('#promoDiscPeriodTp').val(),
                  promoDiscPeriod         : $('#promoDiscPeriod').val().trim(),
                //promoFreesvcPeriodTp    : $('#promoFreesvcPeriodTp').val(),
                  promoAddDiscPrc         : $('#promoAddDiscPrc').val().trim(),
                  promoAddDiscPv          : $('#promoAddDiscPv').val().trim(),
                  exTrade                 : $('#exTrade').val(),
                  empChk                  : $('#empChk').val(),
                  megaDeal                : $('input:radio[name="megaDeal"]:checked').val(),
                  advDisc                : $('input:radio[name="advDisc"]:checked').val(),
                  stkSize                 : $('#stkSize').val(),
                  promoESales             :$('#eSales').val().trim(),
                  appvStus                :$('#appvStatus').val(),
                  appvRemark              :$('#appvRemark').val(),
                  preBook                : $('input:radio[name="preBook"]:checked').val(),
                  voucherPromotion      : $('input:radio[name="voucherPromotion"]:checked').val(),
                  custStatusNew : vCustStatusNew,
                  custStatusDisen : vCustStatusDisen,
                  custStatusEn : vCustStatusEn,
                  custStatusEnWoutWp : vCustStatusEnWoutWp,
                  custStatusEnWp6m : vCustStatusEnWp6m,
                  promoDiscOnBill : $('#promoSpecialDisId').val(),
                  extradeFr: $('#extradeMonthFrom').val(),
                  extradeTo: $('#extradeMonthTo').val(),
                  extradeAppType: $('#extradeAppType').val()
              },
              salesPromoDGridDataSetList  : GridCommon.getEditData(stckGridID)
/*               freeGiftGridDataSetList     : GridCommon.getEditData(giftGridID)
 */          };

          //console.log(JSON.stringify(promotionVO));
          Common.ajax("POST", "/sales/promotion/registerNewPromo.do", promotionVO, function(result) {



              Common.alert("New Promotion" + DEFAULT_DELIMITER + "<b>"+result.message+"</b>");

              $("#modifyForm")[0].reset();
              $("#editForm")[0].reset();
              hideNewPopup('#editPrice_popup');
              fn_getSearchList();


          },  function(jqXHR, textStatus, errorThrown) {
              try {
                  console.log("status : " + jqXHR.status);
                  console.log("code : " + jqXHR.responseJSON.code);
                  console.log("message : " + jqXHR.responseJSON.message);
                  console.log("detailMessage : " + jqXHR.responseJSON.detailMessage);

                  Common.alert("<spring:message code='sal.alert.title.saveFail'/>" + DEFAULT_DELIMITER + "<b><spring:message code='sales.fail.msg'/></b>");
              }
              catch (e) {
                  console.log(e);
              }

          });


  }

  function fn_doSaveModify() {
      console.log('!@# fn_doSavePromtion START');

      $('#exTrade').removeAttr("disabled");

      var vCustStatusNew = "";
      var vCustStatusDisen = "";
      var vCustStatusEn = "";
      var vCustStatusEnWoutWp = "";
      var vCustStatusEnWp6m = "";
      if($('#custStatusNew').is(":checked")) {
          vCustStatusNew = 1;
      }else{
          vCustStatusNew = 0;
      }
      if($('#custStatusDisen').is(":checked")) {
          vCustStatusDisen = 1;
      }else{
          vCustStatusDisen = 0;
      }
      if($('#custStatusEn').is(":checked")) {
          vCustStatusEn = 1;
      }else{
          vCustStatusEn = 0;
      }
      if($('#custStatusEnWoutWp').is(":checked")) {
    	  vCustStatusEnWoutWp = 1;
      }else{
    	  vCustStatusEnWoutWp = 0;
      }
      if($('#custStatusEnWp6m').is(":checked")) {
      	vCustStatusEnWp6m = 1;
      }else{
      	vCustStatusEnWp6m = 0;
      }

      var promotionVO = {

          salesPromoMVO : {
              promoReqstId            : $('#promoReqstId').val(),
              promoId                 : $('#promoId').val(),
//            promoCode               : $('#promoCode').val().trim(),
              promoDesc               : $('#promoDesc').val().trim(),
              promoTypeId             : $('#promoTypeId').val(),
              promoAppTypeId          : $('#promoAppTypeId').val(),
              promoSrvMemPacId        : $('#promoSrvMemPacId').val(),
              promoDtFrom             : $('#promoDtFrom').val().trim(),
              promoDtEnd              : $('#promoDtEnd').val().trim(),
              promoPrcPrcnt           : $('#promoPrcPrcnt').val().trim(),
              promoCustType           : $('#promoCustType').val().trim(),
              promoDiscType           : $('#promoDiscType option:selected').val(),
              promoRpfDiscAmt         : $('#promoRpfDiscAmt').val(),
              promoDiscPeriodTp       : $('#promoDiscPeriodTp').val(),
              promoDiscPeriod         : $('#promoDiscPeriod').val().trim(),
//            promoFreesvcPeriodTp    : $('#promoFreesvcPeriodTp').val(),
              promoAddDiscPrc         : $('#promoAddDiscPrc').val().trim(),
              promoAddDiscPv          : $('#promoAddDiscPv').val().trim(),
              exTrade                 : $('#exTrade').val(),
              empChk                  : $('#empChk').val(),
              megaDeal                : $('input:radio[name="megaDeal"]:checked').val(),
              advDisc                 : $('input:radio[name="advDisc"]:checked').val(),
              stkSize                 : $('#stkSize').val(),
              promoESales             :$('#eSales').val().trim(),
              appvStus                :$('#appvStatus').val(),
              appvRemark              :$('#appvRemark').val(),
              preBook                : $('input:radio[name="preBook"]:checked').val(),
              voucherPromotion      : $('input:radio[name="voucherPromotion"]:checked').val(),
              custStatusNew : vCustStatusNew,
              custStatusDisen : vCustStatusDisen,
              custStatusEn : vCustStatusEn,
              custStatusEnWoutWp : vCustStatusEnWoutWp,
              custStatusEnWp6m : vCustStatusEnWp6m,
              promoDiscOnBill : $('#promoSpecialDisId').val(),
              extradeFr: $('#extradeMonthFrom').val(),
              extradeTo: $('#extradeMonthTo').val(),
              woHs: $('input:radio[name="woHs"]:checked').val(),
              extradeAppType: $('#extradeAppType').val()
          },
          salesPromoDGridDataSetList  : GridCommon.getEditData(stckGridID)
/*           freeGiftGridDataSetList     : GridCommon.getEditData(giftGridID)
 */      };

      //console.log(JSON.stringify(promotionVO));
      Common.ajax("POST", "/sales/promotion/updatePromoInfo.do", promotionVO, function(result) {

          Common.alert("Update Promotion" + DEFAULT_DELIMITER + "<b>"+result.message+"</b>");

          $("#modifyForm")[0].reset();
          $("#editForm")[0].reset();
          hideNewPopup('#editPrice_popup');
          fn_getSearchList();

      },  function(jqXHR, textStatus, errorThrown) {
          try {
              console.log("status : " + jqXHR.status);
              console.log("code : " + jqXHR.responseJSON.code);
              console.log("message : " + jqXHR.responseJSON.message);
              console.log("detailMessage : " + jqXHR.responseJSON.detailMessage);

              Common.alert("<spring:message code='sal.alert.title.saveFail'/>" + DEFAULT_DELIMITER + "<b><spring:message code='sales.fail.msg'/></b>");
          }
          catch (e) {
              console.log(e);
//            alert("Saving data prepration failed.");
          }

//        alert("Fail : " + jqXHR.responseJSON.message);
      });
  }

</script>
<!-- content start -->
<section id="content">
 <ul class="path">
  <li><img
   src="${pageContext.request.contextPath}/resources/images/common/path_home.gif"
   alt="Home" /></li>
 </ul>
 <!-- title_line start -->
 <aside class="title_line">
  <p class="fav">
   <a href="#" class="click_add_on"><spring:message
     code='pay.text.myMenu' /></a>
  </p>
  <h2>Promotion Approval</h2>
   <c:if test="${PAGE_AUTH.funcView == 'Y'}">
  <ul class="right_btns">
  <li><p class="btn_blue"><a href="javascript:fn_getSearchList();"><span class="search"></span> <spring:message code='sys.btn.search' /></a></p></li>
  <li><p class="btn_blue"><a href="javascript:fn_clear();"><span class="clear"></span> <spring:message code='sys.btn.clear' /></a></p></li>
  </ul>
  </c:if>
 </aside>
 <!-- title_line end -->
 <!-- search_table start -->
 <section class="search_table">
  <form name="searchForm" id="searchForm" method="post">
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code='sales.promo.promoApp'/></th>
    <td>
    <select id="list_promoAppTypeId" name="promoAppTypeId" class="multy_select w100p" multiple="multiple"></select>
    </td>
    <th scope="row"><spring:message code='sales.promo.promoType'/></th>
    <td>
    <select id="list_promoTypeId" name="promoTypeId" class="multy_select w100p" multiple="multiple"></select>
    </td>
    <th scope="row"><spring:message code='sales.EffectDate'/></th>
    <td>
    <input id="list_promoDt" name="promoDt" type="text" title="<spring:message code='sales.EffetDate'/>" value="${toDay}" placeholder="DD/MM/YYYY" class="j_date w100p" />
    </td>
</tr>
<tr>

<%--     <th scope="row"><spring:message code='sales.promo.promoCd'/></th>
    <td><input id="list_promoCode" name="promoCode" type="text" title="" placeholder="" class="w100p" /></td> --%>
    <th scope="row"><spring:message code='sales.promo.promoNm'/></th>
    <td><input id="list_promoDesc" name="promoDesc" type="text" title="" placeholder="" class="w100p" /></td>
        <th scope="row">Approval Status</th>
     <td>
                    <select class="w100p" id="promoStusId" name="promoStusId">
                    <option value="">Choose One</option>
                    <option value="5">Approved</option>
                    <option value="60" selected>In Progress</option>
                    <option value="6">Rejected</option>
                    </select>    </td>
</tr>
</tbody>
</table><!-- table end -->
      <!-- link_btns_wrap start -->
   <aside class="link_btns_wrap">
     <p class="show_btn">
      <a href="#"><img
       src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif"
       alt="link show" /></a>
     </p>
     <dl class="link_list">
      <dt>Link</dt>
      <dd>
       <ul class="btns">
         <c:if test="${PAGE_AUTH.funcChange == 'Y'}">
        <li><p class="link_btn">
          <a href="javascript:fn_openDivPop('APPV');">Approval</a>
         </p></li>
         </c:if>
         <c:if test="${PAGE_AUTH.funcPrint == 'Y'}">
         <li><p class="link_btn"><a href="javascript:fn_export();" id="btnExport"><spring:message code='sales.btn.exptSrchList'/></a></p></li>
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
  </form>
 </section>
 <!-- search_table end -->
 <!-- search_result start -->
 <section class="search_result">
  <!-- grid_wrap start -->
<article class="grid_wrap"><!-- grid_wrap start -->
<div id="list_promo_grid_wrap" style="width:100%; height:480; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

  <!-- grid_wrap end -->
 </section>
 <!-- search_result end -->
</section>
<!-- content end -->

<!-------------------------------------------------------------------------------------
    POP-UP (APPROVAL )
-------------------------------------------------------------------------------------->
<!-- popup_wrap start -->
<div id="editPrice_popup" class="popup_wrap" style="display:none"><!-- popup_wrap start -->
    <header class="pop_header"><!-- pop_header start -->
        <h1>Promotion Approval Information</h1>
        <ul class="right_opt">
            <li><p class="btn_blue2"><a id = "fclose" onclick="javascript:fn_close();"><spring:message code="expense.CLOSE" /></a></p></li>
        </ul>
    </header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<c:if test="${PAGE_AUTH.funcChange == 'Y'}">
<ul class="right_btns">
    <li><p class="btn_blue"><a id="btnPromoSave" href="#" onclick="javascript:fn_save();"><spring:message code='sys.btn.save'/></a></p></li>
</ul>
</c:if>

<aside class="title_line"><!-- title_line start -->
<h2><spring:message code='sales.title.sub.promo.promoInfo'/></h2>
</aside><!-- title_line end -->
<form id="modifyForm" name="modifyForm">
<input type="hidden" name="promoReqstId" id="promoReqstId" value=""/>
<input type="hidden" name="promoId" id="promoId"/>
<input type="hidden" name="actionTab" id="actionTab"/>
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
    <col style="width:160px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code='sales.promo.promoApp'/><span class="must">*</span></th>
    <td>
    <select id="promoAppTypeId" name="promoAppTypeId" class="w100p"></select>
    </td>
    <th scope="row"><spring:message code='sales.promo.promoType'/><span class="must">*</span></th>
    <td>
    <select id="promoTypeId" name="promoTypeId" class="w100p"></select>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code='sales.promo.period'/><span class="must">*</span></th>
    <td colspan="3">
    <div class="date_set w100p"><!-- date_set start -->
    <p><input id="promoDtFrom" name="promoDtFrom" value="${promoInfo.promoDtFrom}" type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
    <span>To</span>
    <p><input id="promoDtEnd" name="promoDtEnd" value="${promoInfo.promoDtEnd}" type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
    </div><!-- date_set end -->
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code='sales.promo.promoNm'/></th>
    <td><input id="promoDesc" name="promoDesc" type="text" title="" placeholder="" class="w100p" /></td>
    <th scope="row"><spring:message code='sales.promoCd'/><span class="must">*</span></th>
    <td><input id="promoCode" name="promoCode" value="${promoInfo.promoCode}" type="text" title="" placeholder="" class="w100p" disabled/></td>
</tr>
<tr>
    <th scope="row">Voucher Promotion</th>
    <td>
        <input id="voucherPromotionY" name="voucherPromotion" type="radio" value="1" /><span>Yes</span>
        <input id="voucherPromotionN" name="voucherPromotion" type="radio" value="0"/><span>No</span>
    </td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h2><spring:message code='sales.title.sub.promo.custInfo'/></h2>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:110px" />
    <col style="width:*" />
    <col style="width:120px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code='sales.promo.custType'/><span class="must">*</span></th>
    <td>
    <select id="promoCustType" name="promoCustType" class="w100p">
<option value="0" selected>ALL</option>
<option value=964>Individual</option>
<option value=965>Company</option>
    </select>
    </td>
    <th scope="row"><spring:message code='sales.extrade'/><span class="must">*</span></th>
    <td>
    <select id="exTrade" name="exTrade" class="w100p" disabled></select>
    </td>
    <th>Ex-trade Month</th>
	<td colspan="2">
		<div style="display: flex;">
		    <p><input style="width: 50px" id="extradeMonthFrom" name="extradeMonthFrom" type="number" title="Extrade Month From" value="${promoInfo.extradeFr}"/></p>
		    <span style="padding: 5px;">To</span>
		    <p><input style="width: 50px" id="extradeMonthTo" name="extradeMonthTo" type="number"" title="Extrade Month To" value="${promoInfo.extradeTo}"/></p>
		</div>
	</td>
</tr>
<tr>
    <th scope="row"><spring:message code='sales.employee'/><span class="must">*</span></th>
    <td>
    <select id="empChk" name="empChk" class="w100p" disabled></select>
    </td>
    <th scope="row">Prev Ex-trade App Type<span class="must">*</span></th>
    <td>
    	<select id="extradeAppType" name="extradeAppType" class="w100p" disabled></select>
    </td>
</tr>
<tr>
<th scope="row">Customer Status<span class="must">*</span></th>
    <td colspan = "6">
        <input id="custStatusNew" name="custStatus" type="checkbox" value="7465" disabled/><span>New</span>
        <input id="custStatusEn" name="custStatus" type="checkbox" value="7466" disabled/><span>Engaged</span>
        <input id="custStatusEnWoutWp" name="custStatus" type="checkbox" value="7476" /><span>Engaged (New to WP)</span>
        <input id="custStatusEnWp6m" name="custStatus" type="checkbox" value="7502" /><span>Engaged (WP more than 6M)</span>
        <input id="custStatusDisen" name="custStatus" type="checkbox" value="7467" disabled/><span>Disengaged</span>
    </td>
</tr>
</tbody>
</table><!-- table end -->

<section id="sctPromoDetail">
<aside class="title_line"><!-- title_line start -->
<h2><spring:message code='sales.title.sub.promo.dtl'/></h2>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
    <col style="width:160px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code='sales.promo.discTypeVal'/><span class="must">*</span></th>
    <td>
    <div class="date_set w100p"><!-- date_set start -->
    <p>
    <select id="promoDiscType" name="promoDiscType" class="w100p"></select>
    </p>
    <p>
    <input id="promoPrcPrcnt" name="promoPrcPrcnt" value="${promoInfo.promoPrcPrcnt}" type="text" title="" placeholder="" class="w100p" />
    </p>
    </div>
    </td>
    <th scope="row"><spring:message code='sales.promo.rpfDisc'/><span class="must">*</span></th>
    <td>
    <input id="promoRpfDiscAmt" name="promoRpfDiscAmt" value="${promoInfo.promoRpfDiscAmt}" type="text" title="" placeholder="" class="w100p" />
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code='sales.promo.discPeriod'/><span class="must">*</span></th>
    <td>
    <div class="date_set w100p"><!-- date_set start -->
    <p>
    <select id="promoDiscPeriodTp" name="promoDiscPeriodTp" class="w100p"></select>
    </p>
    <p>
    <input id="promoDiscPeriod" name="promoDiscPeriod" value="${promoInfo.promoDiscPeriod}" type="text" title="" placeholder=""  class="w100p" />
    </p>
    </div>
    </td>

    <th scope="row"><spring:message code='sales.promo.svcPack'/><span class="must">*</span></th>
    <td>
    <select id="promoSrvMemPacId" name="promoSrvMemPacId" class="w100p"></select>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code='sales.promo.addDisc'/></th>
    <td><input id="promoAddDiscPrc" name="promoAddDiscPrc" value="${promoInfo.promoAddDiscPrc}" type="text" title="" placeholder="" class="w100p" /></td>
    <th scope="row"><spring:message code='sales.promo.addDiscPV'/></th>
    <td><input id="promoAddDiscPv" name="promoAddDiscPv" value="${promoInfo.promoAddDiscPv}" type="text" title="" placeholder="" class="w100p" /></td>
</tr>
<tr>
    <th scope="row">Mega Deal</th>
    <td>
        <input id="megaDealY" name="megaDeal" type="radio" value="1" /><span>Yes</span>
        <input id="megaDealN" name="megaDeal" type="radio" value="0" /><span>No</span>
    </td>
    <th scope="row"><spring:message code='sales.promo.eSales'/><span class="must">*</span></th>
    <td>
        <select id="eSales" name="eSales" class="w100p"></select>
    </td>
</tr>
<tr>
    <th scope="row">Advance Discount</th>
    <td>
        <input id="advDiscY" name="advDisc" type="radio" value="1" /><span>Yes</span>
        <input id="advDiscN" name="advDisc" type="radio" value="0" /><span>No</span>
    </td>
    <th scope="row">Mattress Size</th>
    <td>
        <select id="stkSize" name="stkSize" class="w100p"></select>
    </td>
</tr>
<tr>
	<th scope="row">Without HS/CS</th>
    <td>
        <input id="woHsY" name="woHs" type="radio" value="1" /><span>Yes</span>
        <input id="woHsN" name="woHs" type="radio" value="0"/><span>No</span>
    </td>
</tr>
<tr>
 <th scope="row"><spring:message code="newWebInvoice.remark" /><span style="color:red">*</span></th>
     <td colspan="3"><input id="chgRemark" name="chgRemark" value="${promoInfo.chgRemark}" type="text" title="" placeholder="" class="w100p" disabled/></td>
</tr>
<tr>
    <th scope="row">Discount on Billing<span style="color:red">*</span></th>
    <td>
    <select id="promoSpecialDisId" name="promoSpecialDisId" class="w100p" disabled></select>
    </td>
    <th>
    <td>
        <th scope="row" style="display:none;">Pre Book Promotion</th>
    <td style="display:none;">
        <input id="preBookY" name="preBook" type="radio" value="1" /><span>Yes</span>
        <input id="preBookN" name="preBook" type="radio" value="0" /><span>No</span>
    </td>
</tr>
</tbody>
</table><!-- table end -->
</form>
</section>

<section id="appvPromoDetail">
<aside class="title_line"><!-- title_line start -->
<h2>Approval Detail</h2>
</aside><!-- title_line end -->
<form action="#" method="post" id="editForm" name="editForm">
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
    <col style="width:160px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
<th scope="row">Approval Status<span style="color:red">*</span></th>
<td ><select id="appvStatus" name="appvStatus" class="w100p">
<option value="" selected>Choose One</option>
<option value=5>Approve</option>
<option value=6>Reject</option>
</select></td>
</tr>
<tr>
 <th scope="row">Approval Remark<span style="color:red">*</span></th>
    <td colspan="3">
        <textarea type="text" title="" placeholder="" class="w100p" id="appvRemark" name="appvRemark" maxlength="100"></textarea>
        <span id="characterCount">0 of 100 max characters</span>
    </td>
</tr>
</tbody>
</table>
</form>
<aside class="title_line"><!-- title_line start -->
<h2><spring:message code='sales.title.sub.promo.prodList'/></h2>
</aside><!-- title_line end -->

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="pop_stck_grid_wrap" style="width:100%; height:240px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

<!-- grid_wrap end -->

</section><!-- pop_body end -->

</div>


<!-------------------------------------------------------------------------------------
    POP-UP (VIEW )
-------------------------------------------------------------------------------------->
<!-- popup_wrap start -->
<div id="viewPrice_popup" class="popup_wrap" style="display:none"><!-- popup_wrap start -->
    <header class="pop_header"><!-- pop_header start -->
        <h1>Promotion Approval Information</h1>
        <ul class="right_opt">
            <li><p class="btn_blue2"><a id = "fclose" onclick="javascript:fn_close();"><spring:message code="expense.CLOSE" /></a></p></li>
        </ul>
    </header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<aside class="title_line"><!-- title_line start -->
<h2><spring:message code='sales.title.sub.promo.promoInfo'/></h2>
</aside><!-- title_line end -->
<form id="viewForm" name="viewForm">
<input type="hidden" name="promoReqstId" id="promoReqstId" value=""/>
<input type="hidden" name="promoId" id="promoId"/>
<input type="hidden" name="actionTab" id="actionTab"/>
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
    <col style="width:160px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code='sales.promo.promoApp'/><span class="must">*</span></th>
    <td>
    <select id="v_promoAppTypeId" name="v_promoAppTypeId" class="w100p"></select>
    </td>
    <th scope="row"><spring:message code='sales.promo.promoType'/><span class="must">*</span></th>
    <td>
    <select id="v_promoTypeId" name="v_promoTypeId" class="w100p"></select>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code='sales.promo.period'/><span class="must">*</span></th>
    <td colspan="3">
    <div class="date_set w100p"><!-- date_set start -->
    <p><input id="v_promoDtFrom" name="v_promoDtFrom" value="${promoInfo.promoDtFrom}" type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
    <span>To</span>
    <p><input id="v_promoDtEnd" name="v_promoDtEnd" value="${promoInfo.promoDtEnd}" type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
    </div><!-- date_set end -->
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code='sales.promo.promoNm'/></th>
    <td><input id="v_promoDesc" name="v_promoDesc" type="text" title="" placeholder="" class="w100p" /></td>
    <th scope="row"><spring:message code='sales.promoCd'/><span class="must">*</span></th>
    <td><input id="v_promoCode" name="v_promoCode" value="${promoInfo.promoCode}" type="text" title="" placeholder="" class="w100p" disabled/></td>
</tr>
<tr>
    <th scope="row">Voucher Promotion</th>
    <td>
        <input id="v_voucherPromotionY" name="v_voucherPromotion" type="radio" value="1" /><span>Yes</span>
        <input id="v_voucherPromotionN" name="v_voucherPromotion" type="radio" value="0"/><span>No</span>
    </td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h2><spring:message code='sales.title.sub.promo.custInfo'/></h2>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:110px" />
    <col style="width:*" />
    <col style="width:120px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code='sales.promo.custType'/><span class="must">*</span></th>
    <td>
    <select id="v_promoCustType" name="v_promoCustType" class="w100p">
<option value="0" selected>ALL</option>
<option value=964>Individual</option>
<option value=965>Company</option>
    </select>

    </td>
    <th scope="row"><spring:message code='sales.extrade'/><span class="must">*</span></th>
    <td>
    <select id="v_exTrade" name="v_exTrade" class="w100p" disabled></select>
    </td>
    <th>Ex-trade Month</th>
	<td colspan="2">
		<div style="display: flex;">
		    <p><input style="width: 50px" id="v_extradeMonthFrom" name="v_extradeMonthFrom" type="number" title="Extrade Month From" value="${promoInfo.extradeFr}"/></p>
		    <span style="padding: 5px;">To</span>
		    <p><input style="width: 50px" id="v_extradeMonthTo" name="v_extradeMonthTo" type="number"" title="Extrade Month To" value="${promoInfo.extradeTo}"/></p>
		</div>
	</td>
</tr>
<tr>
    <th scope="row"><spring:message code='sales.employee'/><span class="must">*</span></th>
    <td>
    <select id="v_empChk" name="v_empChk" class="w100p" disabled></select>
    </td>
    <th scope="row">Prev Ex-trade App Type<span class="must">*</span></th>
    <td>
    	<select id="v_extradeAppType" name="v_extradeAppType" class="w100p" disabled></select>
    </td>
</tr>
<tr>
<th scope="row">Customer Status<span class="must">*</span></th>
    <td colspan = "6">
        <input id="v_custStatusNew" name="custStatus" type="checkbox" value="7465" disabled/><span>New</span>
        <input id="v_custStatusEn" name="custStatus" type="checkbox" value="7466" disabled/><span>Engaged</span>
        <input id="v_custStatusEnWoutWp" name="custStatus" type="checkbox" value="7476" disabled/><span>Engaged (New to WP)</span>
        <input id="v_custStatusEnWp6m" name="custStatus" type="checkbox" value="7502" /><span>Engaged (WP more than 6M)</span>
        <input id="v_custStatusDisen" name="custStatus" type="checkbox" value="7467" disabled/><span>Disengaged</span>
    </td>
</tr>
</tbody>
</table><!-- table end -->

<section id="sctPromoDetailV">
<aside class="title_line"><!-- title_line start -->
<h2><spring:message code='sales.title.sub.promo.dtl'/></h2>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
    <col style="width:160px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code='sales.promo.discTypeVal'/><span class="must">*</span></th>
    <td>
    <div class="date_set w100p"><!-- date_set start -->
    <p>
    <select id="v_promoDiscType" name="v_promoDiscType" class="w100p"></select>
    </p>
    <p>
    <input id="v_promoPrcPrcnt" name="v_promoPrcPrcnt" value="${promoInfo.promoPrcPrcnt}" type="text" title="" placeholder="" class="w100p" />
    </p>
    </div>
    </td>
    <th scope="row"><spring:message code='sales.promo.rpfDisc'/><span class="must">*</span></th>
    <td>
    <input id="v_promoRpfDiscAmt" name="v_promoRpfDiscAmt" value="${promoInfo.promoRpfDiscAmt}" type="text" title="" placeholder="" class="w100p" />
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code='sales.promo.discPeriod'/><span class="must">*</span></th>
    <td>
    <div class="date_set w100p"><!-- date_set start -->
    <p>
    <select id="v_promoDiscPeriodTp" name="v_promoDiscPeriodTp" class="w100p"></select>
    </p>
    <p>
    <input id="v_promoDiscPeriod" name="v_promoDiscPeriod" value="${promoInfo.promoDiscPeriod}" type="text" title="" placeholder=""  class="w100p" />
    </p>
    </div>
    </td>

    <th scope="row"><spring:message code='sales.promo.svcPack'/><span class="must">*</span></th>
    <td>
    <select id="v_promoSrvMemPacId" name="v_promoSrvMemPacId" class="w100p"></select>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code='sales.promo.addDisc'/></th>
    <td><input id="v_promoAddDiscPrc" name="v_promoAddDiscPrc" value="${promoInfo.promoAddDiscPrc}" type="text" title="" placeholder="" class="w100p" /></td>
    <th scope="row"><spring:message code='sales.promo.addDiscPV'/></th>
    <td><input id="v_promoAddDiscPv" name="v_promoAddDiscPv" value="${promoInfo.promoAddDiscPv}" type="text" title="" placeholder="" class="w100p" /></td>
</tr>
<tr>
    <th scope="row">Mega Deal</th>
    <td>
        <input id="v_megaDealY" name="megaDeal" type="radio" value="1" /><span>Yes</span>
        <input id="v_megaDealN" name="megaDeal" type="radio" value="0" /><span>No</span>
    </td>
    <th scope="row"><spring:message code='sales.promo.eSales'/><span class="must">*</span></th>
    <td>
        <select id="v_eSales" name="v_eSales" class="w100p"></select>
    </td>
</tr>
<tr>
    <th scope="row">Advance Discount</th>
    <td>
        <input id="v_advDiscY" name="v_advDisc" type="radio" value="1" /><span>Yes</span>
        <input id="v_advDiscN" name="v_advDisc" type="radio" value="0" /><span>No</span>
    </td>
    <th scope="row">Mattress Size</th>
    <td>
        <select id="v_stkSize" name="v_stkSize" class="w100p"></select>
    </td>
</tr>
<tr>
	<th scope="row">Without HS/CS</th>
    <td>
        <input id="v_woHsY" name="v_woHs" type="radio" value="1" /><span>Yes</span>
        <input id="v_woHsN" name="v_woHs" type="radio" value="0"/><span>No</span>
    </td>
</tr>
<tr>
 <th scope="row"><spring:message code="newWebInvoice.remark" /><span style="color:red">*</span></th>
     <td colspan="3"><input id="v_chgRemark" name="v_chgRemark" value="${promoInfo.chgRemark}" type="text" title="" placeholder="" class="w100p" disabled/></td>
</tr>
<tr>
    <th scope="row">Discount on Billing<span style="color:red">*</span></th>
    <td>
    <select id="v_promoSpecialDisId" name="v_promoSpecialDisId" class="w100p" disabled></select>
    </td>
    <th>
    <td>
    <th scope="row" style="display:none;">Pre Book Promotion</th>
    <td style="display:none;">
        <input id="v_preBookY" name="preBook" type="radio" value="1" /><span>Yes</span>
        <input id="v_preBookN" name="preBook" type="radio" value="0" /><span>No</span>
    </td>
</tr>
</tbody>
</table><!-- table end -->
</form>
</section>

<section id="appvPromoDetailV">
<aside class="title_line"><!-- title_line start -->
<h2>Approval Detail</h2>
</aside><!-- title_line end -->
<form action="#" method="post" id="v_editForm" name="v_editForm">
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
    <col style="width:160px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
<th scope="row">Approval Status<span style="color:red">*</span></th>
<td ><select id="v_appvStatus" name="v_appvStatus" class="w100p">
<option value="" selected>Choose One</option>
<option value=5>Approve</option>
<option value=6>Reject</option>
</select></td>
</tr>
<tr>
 <th scope="row">Approval Remark<span style="color:red">*</span></th>
    <td colspan="3">
        <textarea type="text" title="" placeholder="" class="w100p" id="v_appvRemark" name="v_appvRemark" maxlength="100"></textarea>
        <span id="characterCount">0 of 100 max characters</span>
    </td>
</tr>
</tbody>
</table>
</form>
<aside class="title_line"><!-- title_line start -->
<h2><spring:message code='sales.title.sub.promo.prodList'/></h2>
</aside><!-- title_line end -->

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="v_pop_stck_grid_wrap" style="width:100%; height:240px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->
        <section class="search_result"><!-- search_result start -->
    <aside class="title_line"><!-- title_line start -->
            <h4>Promotion Information History</h3>
        </aside><!-- title_line end -->
        <article class="grid_wrap" id="histList_grid_wrap"><!-- grid_wrap start -->
        </article><!-- grid_wrap end -->

        </section><!-- search_result end -->
        <section class="search_result"><!-- search_result start -->
    <aside class="title_line"><!-- title_line start -->
            <h4>Product List History</h3>
        </aside><!-- title_line end -->
        <article class="grid_wrap" id="hist_stck_grid_wrap"><!-- grid_wrap start -->
        </article><!-- grid_wrap end -->

        </section><!-- search_result end -->
<!-- grid_wrap end -->

</section><!-- pop_body end -->

</div>