<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript" language="javascript">

    //AUIGrid 생성 후 반환 ID
    var listGridID;
    var excelGridID;
    var listStckGridID, listGiftGridID;

    var arrSrvTypeCode = [{"codeId": "SS"  ,"codeName": "Self Service"},
                          {"codeId": "HS" ,"codeName": "Heart Service"},
                          {"codeId": "BOTH","codeName": "Both"}];

    var keyValueList = [];

    var timerId = null;

    var AUTH_CHNG = "${PAGE_AUTH.funcChange}";

    $(document).ready(function(){

        fn_statusCodeSearch();

        //AUIGrid 그리드를 생성합니다.
        createAUIGrid();
        createAUIGridExcel();
        createAUIGridStk();

        $("#chgRemark").keyup(function(){
            $("#characterCount").text($(this).val().length + " of 100 max characters");
      });

        // 셀 더블클릭 이벤트 바인딩
        AUIGrid.bind(listGridID, "cellDoubleClick", function(event) {
        	if(AUIGrid.getCellValue(listGridID, event.rowIndex, "promoId") != null && AUIGrid.getCellValue(listGridID, event.rowIndex, "promoId") != ''){
                Common.popupDiv("/sales/promotion/promotionModifyPop.do", { promoId : AUIGrid.getCellValue(listGridID, event.rowIndex, "promoId") });
        	}
        	else {
        		Common.alert("This item is pending approval");
        	}
        });

        // 셀 클릭 이벤트 바인딩
        AUIGrid.bind(listGridID, "selectionChange", auiGridSelectionChangeHandler);

        doGetComboOrder('/common/selectCodeList.do', '320', 'CODE_ID', '', 'list_promoAppTypeId', 'M', 'fn_multiCombo'); //Common Code
        doGetCombo('/common/selectCodeList.do',  '76', '', 'list_promoTypeId',    'M', 'fn_multiCombo'); //Promo Type
        doGetComboDataStatus('/status/selectStatusCategoryCdList.do',  {selCategoryId : 3, parmDisab : 0}, '', 'list_promoStusId', 'M', 'fn_multiCombo'); //Promo Type
    });

    function auiGridSelectionChangeHandler(event) {

        // 200ms 보다 빠르게 그리드 선택자가 변경된다면 데이터 요청 안함
        if(timerId) {
            clearTimeout(timerId);
        }

        timerId = setTimeout(function() {
            var selectedItems = event.selectedItems;
            if(selectedItems.length <= 0)
                return;

            var rowItem = selectedItems[0].item; // 행 아이템들
            var promoId = rowItem.promoId; // 선택한 행의 고객 ID 값
            var promoAppTypeId = rowItem.promoAppTypeId; // 선택한 행의 고객 ID 값

            fn_selectPromotionPrdListForList2(promoId, promoAppTypeId);
            fn_selectPromotionFreeGiftListForList2(promoId);

        }, 200);  // 현재 200ms 민감도....환경에 맞게 조절하세요.
    };

    function fn_calcPvVal(num1) {
        var num2 = parseFloat(num1/10);
        var num3 = Math.floor(num2);
        var num4;
        if((num2 - num3) > 0) {
            num4 = num3 + 1;
        }
        else {
            num4 = num3;
        }

        return (num4*10);
    }

    function fn_delApptype() {
        $("#promoAppTypeId").find("option").each(function() {
            if(this.value == '2286') {
                $(this).remove();
            }
        });
    }
    function fn_delApptype2() {
        $("#list_promoAppTypeId").find("option").each(function() {
            if(this.value == '2286') {
                $(this).remove();
            }
        });
    }

    function fn_statusCodeSearch(){
        Common.ajaxSync("GET", "/status/selectStatusCategoryCdList.do", {selCategoryId : 3, parmDisab : 0}, function(result) {
            keyValueList = result;
        });
    }

    function fn_excelDown(){
        // type : "xlsx", "csv", "txt", "xml", "json", "pdf", "object"
        GridCommon.exportTo("excel_list_grid_wrap", "xlsx", "PromotionList");
    }

    function createAUIGrid() {

        //AUIGrid 칼럼 설정
        var columnLayout = [
            { headerText : "<spring:message code='sal.text.promotionId'/>",        dataField : "promoId", editable : false,   width : 100 }
          , { headerText : "<spring:message code='sales.AppType2'/>",        dataField : "promoAppTypeName", editable : false,   width : 100 }
          , { headerText : "<spring:message code='sales.promo.promoType'/>", dataField : "promoTypeName",    editable : false,   width : 100 }
          , { headerText : "<spring:message code='sales.promo.promoCd'/>",   dataField : "promoCode",        editable : false,   width : 140 }
          , { headerText : "<spring:message code='sales.promo.promoNm'/>",   dataField : "promoDesc",        editable : false }
          , { headerText : "<spring:message code='sales.StartDate'/>",       dataField : "promoDtFrom",      editable : false,   width : 100 }
          , { headerText : "<spring:message code='sales.EndDate'/>",         dataField : "promoDtEnd",       editable : false,   width : 100 }
          , { headerText : "<spring:message code='sales.Status'/>",          dataField : "promoStusId",      editable : true,    width : 80
            , labelFunction : function( rowIndex, columnIndex, value, headerText, item) {
                                  var retStr = "";
                                  for(var i=0,len=keyValueList.length; i<len; i++) {
                                      if(keyValueList[i]["stusCodeId"] == value) {
                                          retStr = keyValueList[i]["codeName"];
                                          break;
                                      }
                                  }
                                  return retStr == "" ? value : retStr;
                              }
            , editRenderer : {
                  type       : "ComboBoxRenderer",
                  list       : keyValueList, //key-value Object 로 구성된 리스트
                  keyField   : "stusCodeId", // key 에 해당되는 필드명
                  valueField : "codeName" // value 에 해당되는 필드명
              }}
          , { headerText : "Approval Status",         dataField : "appvStus",       editable : false,   width : 100 }
          , { headerText : "promoId",        dataField : "promoId",        visible : false}
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

        listGridID = GridCommon.createAUIGrid("list_promo_grid_wrap", columnLayout, "", gridPros);
    }

    function createAUIGridExcel(){

        //AUIGrid 칼럼 설정
        var excelColumnLayout = [
            { headerText : "<spring:message code='sal.text.promotionId'/>",        dataField : "promoId", editable : false,   width : 100 }
            , { headerText : "<spring:message code='sales.AppType2'/>",        dataField : "promoAppTypeName", editable : false,   width : 100 }
            , { headerText : "<spring:message code='sales.promo.promoType'/>", dataField : "promoTypeName",    editable : false,   width : 100 }
            , { headerText : "<spring:message code='sales.promo.promoCd'/>",   dataField : "promoCode",        editable : false,   width : 140 }
            , { headerText : "<spring:message code='sales.promo.promoNm'/>",   dataField : "promoDesc",        editable : false }
            , { headerText : "<spring:message code='sales.StartDate'/>",       dataField : "promoDtFrom",      editable : false,   width : 100 }
            , { headerText : "<spring:message code='sales.EndDate'/>",         dataField : "promoDtEnd",       editable : false,   width : 100 }
            , { headerText : "<spring:message code='sales.Status'/>",          dataField : "promoStusId",      editable : true,    width : 80
              , labelFunction : function( rowIndex, columnIndex, value, headerText, item) {
                                    var retStr = "";
                                    for(var i=0,len=keyValueList.length; i<len; i++) {
                                        if(keyValueList[i]["stusCodeId"] == value) {
                                            retStr = keyValueList[i]["codeName"];
                                            break;
                                        }
                                    }
                                    return retStr == "" ? value : retStr;
                                }
              , editRenderer : {
                    type       : "ComboBoxRenderer",
                    list       : keyValueList, //key-value Object 로 구성된 리스트
                    keyField   : "stusCodeId", // key 에 해당되는 필드명
                    valueField : "codeName" // value 에 해당되는 필드명
                }}
            , { headerText : "Approval Status",         dataField : "appvStus",       editable : false,   width : 100 }
            , { headerText : "Voucher Promotion",         dataField : "voucherPromotion",       editable : false,   width : 100 }
            , { headerText : "Customer Type",         dataField : "promoCustTypeDesc",       editable : false,   width : 100 }
            , { headerText : "Ex-Trade",         dataField : "exTradeDesc",       editable : false,   width : 100 }
            , { headerText : "Employee",         dataField : "empChkDesc",       editable : false,   width : 100 }
            , { headerText : "Discount Type",         dataField : "promoDiscTypeDesc",       editable : false,   width : 100 }
            , { headerText : "Discount Value",         dataField : "promoPrcPrcnt",       editable : false,   width : 100 }
            , { headerText : "RPF Discount",         dataField : "promoRpfDiscAmt",       editable : false,   width : 100 }
            , { headerText : "Discount Period Type",         dataField : "promoDiscPeriodTpDesc",       editable : false,   width : 100 }
            , { headerText : "Discount Period Value",         dataField : "promoDiscPeriod",       editable : false,   width : 100 }
            , { headerText : "Service Package",         dataField : "codeName",       editable : false,   width : 100 }
            , { headerText : "Additional Discount (RM)",         dataField : "promoAddDiscPrc",       editable : false,   width : 100 }
            , { headerText : "Additional Discount (PV)",         dataField : "promoAddDiscPv",       editable : false,   width : 100 }
            , { headerText : "Mega Deal",         dataField : "megaDeal",       editable : false,   width : 100 }
            , { headerText : "Pre-Book",         dataField : "preBook",       editable : false,   width : 100 }
            , { headerText : "Apply To",        dataField : "eSales",        visible : false}
            , { headerText : "Advance Discount",         dataField : "advDisc",       editable : false,   width : 100 }
            , { headerText : "Mattress Size",         dataField : "stkSize",       editable : false,   width : 100 }
            , { headerText : "promoAppTypeId", dataField : "promoAppTypeId", visible : false}
        ];

        var excelGridPros = {
             enterKeyColumnBase : true,
             useContextMenu : true,
             enableFilter : true,
             showStateColumn : true,
             displayTreeOpen : true,
             noDataMessage : "<spring:message code='sys.info.grid.noDataMessage' />",
             groupingMessage : "<spring:message code='sys.info.grid.groupingMessage' />",
             exportURL : "/common/exportGrid.do"
         };

        excelGridID = GridCommon.createAUIGrid("excel_list_grid_wrap", excelColumnLayout, "", excelGridPros);
    }

    function createAUIGridStk() {

        //AUIGrid 칼럼 설정
        var columnLayoutPrd = [
            { headerText : "<spring:message code='sales.prodCd'/>", dataField : "itmcd",   width : 100 }
          , { headerText : "<spring:message code='sales.prodNm'/>", dataField : "itmname"              }
          , { headerText : "<spring:message code='sales.normal'/>"
            , children   : [{ headerText : "<spring:message code='sales.mthFeePrc'/>", dataField : "amt",         width : 100 }
                          , { headerText : "<spring:message code='sales.rpf'/>",       dataField : "prcRpf",      width : 100 }
                          , { headerText : "<spring:message code='sales.pv'/>",        dataField : "prcPv",       width : 100 }]}
          , { headerText : "<spring:message code='sales.title.Promotion'/>"
            , children   : [{ headerText : "<spring:message code='sales.mthFeePrc'/>", dataField : "promoAmt",    width : 100 }
                          , { headerText : "<spring:message code='sales.rpf'/>",       dataField : "promoPrcRpf", width : 100 }
                          , { headerText : "<spring:message code='sales.pv'/>",        dataField : "promoItmPv",  width : 100 }]}
          , { headerText : "itmid",      dataField   : "promoItmStkId", visible : false, width : 80 }
          , { headerText : "promoItmId", dataField   : "promoItmId",    visible : false, width : 80 }
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

        //AUIGrid 칼럼 설정
        var columnLayoutGft = [
            { headerText : "<spring:message code='sales.prodCd'/>", dataField : "itmcd",              width : 180 }
          , { headerText : "<spring:message code='sales.prodNm'/>", dataField : "itmname" }
          , { headerText : "<spring:message code='sales.prdQty'/>", dataField : "promoFreeGiftQty",   width : 180 }
          , { headerText : "itmid",        dataField : "promoFreeGiftStkId", visible : false}
          , { headerText : "promoItmId",   dataField : "promoItmId",         visible : false}
          ];

        //그리드 속성 설정
        var listGridPros = {
            usePaging           : true,         //페이징 사용
            pageRowCount        : 10,           //한 화면에 출력되는 행 개수 20(기본값:20)
            editable            : false,
            fixedColumnCount    : 1,
            showStateColumn     : false,
            displayTreeOpen     : false,
          //selectionMode       : "singleRow",  //"multipleCells",
            softRemoveRowMode   : false,
            headerHeight        : 30,
            useGroupingPanel    : false,        //그룹핑 패널 사용
            skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
            wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
            showRowNumColumn    : true,         //줄번호 칼럼 렌더러 출력
            noDataMessage       : "No order found.",
            groupingMessage     : "Here groupping"
        };

        listStckGridID = GridCommon.createAUIGrid("pop_list_stck_grid_wrap", columnLayoutPrd, "", listGridPros);
        listGiftGridID = GridCommon.createAUIGrid("pop_list_gift_grid_wrap", columnLayoutGft, "", listGridPros);
    }

    // 컬럼 선택시 상세정보 세팅.
    function fn_setDetail(gridID, rowIdx){
        console.log('cellDoubleClick');
        Common.popupDiv("/sales/promotion/promotionModifyPop.do", { promoId : AUIGrid.getCellValue(gridID, rowIdx, "promoId") });
    }

    // 컬럼 선택시 상세정보 세팅.
    function fn_setDetail2(gridID, rowIdx){
        console.log('cellClick');
        fn_selectPromotionPrdListForList2(AUIGrid.getCellValue(gridID, rowIdx, "promoId"), AUIGrid.getCellValue(gridID, rowIdx, "promoAppTypeId"));
        fn_selectPromotionFreeGiftListForList2(AUIGrid.getCellValue(gridID, rowIdx, "promoId"));
    }

    // 리스트 조회.
    function fn_selectPromoListAjax() {
        console.log('fn_selectPromoListAjax START');
        Common.ajax("GET", "/sales/promotion/selectPromotionList.do", $("#listSearchForm").serialize(), function(result) {
            AUIGrid.setGridData(listGridID, result);
        });

        Common.ajax("GET", "/sales/promotion/selectExcelPromoList.do", $("#listSearchForm").serialize(), function(resultExcel) {
        	AUIGrid.setGridData(excelGridID, resultExcel);
        });
    }

    function fn_doSaveStatus() {
        console.log('!@# fn_doSaveStatus START');

        var promotionVO = {
            salesPromoMGridDataSetList : GridCommon.getEditData(listGridID)
        };

        Common.ajax("POST", "/sales/promotion/updatePromoStatus.do", promotionVO, function(result) {

            Common.alert("<spring:message code='sales.promo.msg1'/>" + DEFAULT_DELIMITER + "<b>"+result.message+"</b>");

            fn_selectPromoListAjax();

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
//              alert("Saving data prepration failed.");
            }

//          alert("Fail : " + jqXHR.responseJSON.message);
        });
    }

    $(function(){
        $('#btnNew').click(function() {
            Common.popupDiv("/sales/promotion/promotionRegisterPop.do");
        });
        $('#btnSaveStatus').click(function() {
            fn_doSaveStatus();
        });
        $('#btnSrch').click(function() {
            fn_selectPromoListAjax();
        });
        $('#btnClear').click(function() {
            $('#listSearchForm').clearForm();
        });
    });

    function fn_selectPromotionPrdListForList2(promoId, promoAppTypeId) {
        console.log('fn_selectPromotionPrdListAjax START');
        Common.ajax("GET", "/sales/promotion/selectPromotionPrdWithPriceList.do", { promoId : promoId, promoAppTypeId : promoAppTypeId }, function(result) {
            AUIGrid.setGridData(listStckGridID, result);
        });
    }

    function fn_selectPromotionFreeGiftListForList2(promoId) {
        console.log('fn_selectPromotionFreeGiftListAjax START');
        Common.ajax("GET", "/sales/promotion/selectPromotionFreeGiftList.do", { promoId : promoId }, function(result) {
            AUIGrid.setGridData(listGiftGridID, result);
        });
    }

    function fn_multiCombo(){
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
        $('#list_promoStusId').change(function() {
            //console.log($(this).val());
        }).multipleSelect({
            selectAll: true, // 전체선택
            width: '100%'
        });
        $('#list_promoStusId').multipleSelect("checkAll");

        fn_delApptype2();
    }

    $.fn.clearForm = function() {
        return this.each(function() {
            var type = this.type, tag = this.tagName.toLowerCase();
            if (tag === 'form'){
                return $(':input',this).clearForm();
            }
            if (type === 'text' || type === 'password' || type === 'hidden' || tag === 'textarea'){
                this.value = '';
            }else if (type === 'checkbox' || type === 'radio'){
                this.checked = false;
            }else if (tag === 'select'){
                this.selectedIndex = -1;
            }
        });
    };
</script>

<!--****************************************************************************
    CONTENT START
*****************************************************************************-->
<section id="content">
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
	<li><spring:message code='sales.path.sales'/></li>
	<li><spring:message code='sales.path.Promotion'/></li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2><spring:message code='sales.title.promoList'/></h2>
<ul class="right_btns">
  <c:if test="${PAGE_AUTH.funcChange == 'Y'}">
    <li><p class="btn_blue"><a id="btnNew" href="#" ><spring:message code='sales.btn.new'/></a></p></li>
    <li><p class="btn_blue"><a id="btnSaveStatus" href="#"><spring:message code='sales.btn.save'/></a></p></li>
  </c:if>
    <li><p class="btn_blue"><a id="btnSrch" href="#"><span class="search"></span><spring:message code='sales.btn.search'/></a></p></li>
    <li><p class="btn_blue"><a id="btnClear" href="#"><span class="clear"></span><spring:message code='sales.btn.clear'/></a></p></li>
</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form id="listSearchForm" name="listSearchForm" action="#" method="post">

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
    <th scope="row"><spring:message code='sales.Status'/></th>
    <td>
    <select id="list_promoStusId" name="promoStusId" class="w100p"></select>
    </td>
    <th scope="row"><spring:message code='sales.promo.promoCd'/></th>
    <td><input id="list_promoCode" name="promoCode" type="text" title="" placeholder="" class="w100p" /></td>
    <th scope="row"><spring:message code='sales.promo.promoNm'/></th>
    <td><input id="list_promoDesc" name="promoDesc" type="text" title="" placeholder="" class="w100p" /></td>
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
         <c:if test="${PAGE_AUTH.funcPrint == 'Y'}">
         <li><p class="link_btn"><a href="javascript:fn_excelDown();" id="btnExport"><spring:message code='sales.btn.exptSrchList'/></a></p></li>
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
<!-- link_btns_wrap start -->
<!--
<aside class="link_btns_wrap">
<p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
<dl class="link_list">
    <dt>Link</dt>
    <dd>
    <ul class="btns">
        <li><p class="link_btn"><a href="#">menu1</a></p></li>
        <li><p class="link_btn"><a href="#">menu2</a></p></li>
    </ul>
    <ul class="btns">
        <li><p class="link_btn type2"><a href="#">menu1</a></p></li>
        <li><p class="link_btn type2"><a href="#">Search Payment</a></p></li>
    </ul>
    <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
    </dd>
</dl>
</aside>
-->
<!-- link_btns_wrap end -->

</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->
<!--
<ul class="right_btns">
    <li><p class="btn_grid"><a href="#">CANCEL</a></p></li>
    <li><p class="btn_grid"><a href="#">ADD</a></p></li>
    <li><p class="btn_grid"><a href="#">SAVE</a></p></li>
</ul>
-->
<article class="grid_wrap"><!-- grid_wrap start -->
<div id="list_promo_grid_wrap" style="width:100%; height:480; margin:0 auto;"></div>
<div id="excel_list_grid_wrap" style="display: none;"></div>
</article><!-- grid_wrap end -->

<aside class="title_line"><!-- title_line start -->
<h2><spring:message code='sales.title.promoList2'/></h2>
</aside><!-- title_line end -->

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="pop_list_stck_grid_wrap" style="width:100%; height:240px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

<aside class="title_line"><!-- title_line start -->
<h2><spring:message code='sales.title.promoList3'/></h2>
</aside><!-- title_line end -->

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="pop_list_gift_grid_wrap" style="width:100%; height:240px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- content end -->
