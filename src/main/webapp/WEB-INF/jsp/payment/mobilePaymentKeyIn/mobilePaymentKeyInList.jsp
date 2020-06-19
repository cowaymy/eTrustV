<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<!--
 DATE           BY        VERSION        REMARK
 ----------------------------------------------------------------
 09/03/2020  ONGHC  1.0.0             Add TR Ref.No and TR Issue Date
                                                   Add Application Type, PV Month and Year to GridView.
 13/04/2020  ONGHC  1.0.1             Add Order Ledger Button and Highlighted no Outstanding Order
 24/04/2020  ONGHC  1.0.2             Amend fn_validateLdg to change confirmation to alert
 30/04/2020  ONGHC  1.0.3             Amend to Highlighted Advance Payment order
 09/06/2020  FANNIE  1.0.4             Amend to hide the order ledger, update and reject with authorization
 17/06/2020  ONGHC  1.0.5             Amend Credit Card No. Auto Tab Feature.
 19/06/2020  FARUQ   1.0.6             Amend Branch Code to Multiple Selection
 -->

<style type="text/css">
/* 커스텀 칼럼 스타일 정의 */
.aui-grid-user-custom-left {
    text-align:left;
}
/* 커스텀 칼럼 스타일 정의 */
.aui-grid-user-custom-right {
    text-align:right;
}
.my-pink-style {
    background:#FFA7A7;
    font-weight:bold;
    color:#22741C;
}
</style>

<script type="text/javaScript">
  var TODAY_DD      = "${toDay}";

  //AUIGrid 생성 후 반환 ID
  var myGridID ;
  // 소팅 정보 보관 객체
  var sortingInfo;
  // popup 크기
  var option = {
    width : "1200px",   // 창 가로 크기
    height : "500px"    // 창 세로 크기
  };

  var basicAuth = false;

  $(document).ready(function(){
    // AUIGrid 그리드를 생성합니다.
    createAUIGrid();

    //AUIGrid.setSelectionMode(myGridID , "singleRow");
    //Search
    $("#_listSearchBtn").click(function() {
      //Validation
      // ticketNo  _reqstStartDt _reqstEndDt ticketType ticketStatus branchCode memberCode orderNo
      if((null == $("#_reqstStartDt").val() || '' == $("#_reqstStartDt").val())
         && (null == $("#_reqstEndDt").val() || '' == $("#_reqstEndDt").val())){
          //VA number
         /*
           if($("#custVaNo").val() == null || $("#custVaNo").val() == ''){
             Common.alert('<spring:message code="sal.alert.msg.plzKeyInAtleastOneOfTheCondition" />');
             return;
           }
        */
      }
      fn_selectPstRequestDOListAjax();
    });

    //Basic Auth (update Btn)
    if('${PAGE_AUTH.funcUserDefine2}' == 'Y'){
      basicAuth = true;
    }
  });

  // 엑셀다운로드
  function fn_excelDown(){
    // type : "xlsx", "csv", "txt", "xml", "json", "pdf", "object"
    GridCommon.exportTo("grid_wrap", "xlsx", "Mobile Payment Key-in Search");
  }

  // reject 처리
  function fn_reject(){
    var selectedItems = AUIGrid.getCheckedRowItems(myGridID);
    if (selectedItems.length <= 0) {
      Common.alert("<b>No request selected.</b>");
      return;
    }

    // 2020.02.26 : Valid Add
    var isValidReject = true;
    $.each(selectedItems, function(idx, row){
      if(row.item.payStusId != "1" ){
        isValidReject = false;
      }
    });

    if(!isValidReject){
      Common.alert("<b>Check the Request Status value.</b>");
      return false;
    }

    var data = {};
    if(selectedItems.length > 0)
      data.all = selectedItems;

      Common.prompt("<spring:message code='pay.prompt.reject'/>", "", function(){
        if( FormUtil.isEmpty($("#promptText").val()) ){
         Common.alert("<spring:message code='pay.check.rejectReason'/>");
        } else {
          data.etc = $("#promptText").val();

          Common.ajaxSync("POST", "/mobilePaymentKeyIn/saveMobilePaymentKeyInReject.do", data, function(result) {
          if(result !=""  && null !=result ){
            Common.alert("<spring:message code='pay.alert.reject'/>", function(){
            fn_selectPstRequestDOListAjax();
          });
        }
      });
    }
  });

/*
  var indexArr = AUIGrid.getSelectedIndex(myGridID);
  if( indexArr[0] == -1 ){
    Common.alert("<spring:message code='pay.check.noRowsSelected'/>");
  } else {
    var mobPayNo = AUIGrid.getCellValue(myGridID, indexArr[0], "mobPayNo");
    var billStatus = AUIGrid.getCellValue(myGridID, indexArr[0], "billStatus");
    Common.prompt("<spring:message code='pay.prompt.reject'/>", "", function(){
      if( FormUtil.isEmpty($("#promptText").val()) ){
        Common.alert("<spring:message code='pay.check.rejectReason'/>");
      } else {
        var rejectData = AUIGrid.getSelectedItems(myGridID)[0].item;
        rejectData.etc = $("#promptText").val();
        Common.ajaxSync("POST", "/mobilePaymentKeyIn/saveMobilePaymentKeyInReject.do", rejectData, function(result) {
          if(result !=""  && null !=result ){
            Common.alert("<spring:message code='pay.alert.reject'/>", function(){
              fn_selectPstRequestDOListAjax();
            });
          }
        });
      }
    });
  }
*/
  }

  function fn_validateLdg(){
    var selectedItems = AUIGrid.getCheckedRowItems(myGridID);

    if (selectedItems.length == 0){
      /* Common.alert("Please select a row."); */
      Common.alert("<spring:message code='service.msg.NoRcd' />");
      return false;
    }

    var list = AUIGrid.getCheckedRowItems(myGridID);
    var rowCnt = list.length;
    var crntLdgStat = false;
    if(rowCnt > 0){
        for(i = 0 ; i < rowCnt ; i++){
            var crntLdg = list[i].item.crntLdg;
            var payStusId = list[i].item.payStusId;
            var advAmt = list[i].item.advAmt;
            if (!crntLdgStat) {
              if (crntLdg <= 0 && payStusId == "1" && (advAmt == "" || typeof(advAmt) == "undefined")) {
                crntLdgStat = true;
                break;
              }
            }
        }
    }

    if (crntLdgStat) {
        //Common.confirm("<spring:message code='pay.msg.payMobNoOut' />",fn_update);
        Common.alert("<spring:message code='pay.msg.payMobNoOut' />");
        return;
    } else {
      fn_update();
    }
  }

  function fn_update(){
    var selectedItems = AUIGrid.getCheckedRowItems(myGridID);

   // if (selectedItems.length == 0){
     /* Common.alert("Please select a row."); */
      //Common.alert("<b>No request selected.</b>");
      //return false;
    //}

    var isValidReject = true;
    $.each(selectedItems, function(idx, row){
      if(row.item.payStusId != "1" ){
        isValidReject = false;
      }
    });

    if(!isValidReject){
     Common.alert("<b>Check the Request Status value.</b>");
     return false;
    }

    // 유효성 추가
    var list = AUIGrid.getCheckedRowItems(myGridID);
    var rowCnt = list.length;
    var asIssalesOrdId = "";
    if(rowCnt > 0){
      for(i = 0 ; i < rowCnt ; i++){
        var salesOrdId = list[i].item.ordId;
         if(i == 0){
           asIssalesOrdId = salesOrdId;
           Common.ajax("GET", "/payment/common/checkOrderOutstanding.do", {salesOrdId : salesOrdId}, function(RESULT) {
           if(RESULT.rootState == 'ROOT_1') {
             Common.alert('No Outstanding' + DEFAULT_DELIMITER + RESULT.msg);
           }
         });
       } else {
         if( asIssalesOrdId != salesOrdId ){
           Common.ajax("GET", "/payment/common/checkOrderOutstanding.do", {salesOrdId : salesOrdId}, function(RESULT) {
             if (RESULT.rootState == 'ROOT_1') {
               Common.alert('No Outstanding' + DEFAULT_DELIMITER + RESULT.msg);
             }
           });
         }
         asIssalesOrdId = salesOrdId;
       }
       /*
         Common.ajax("GET", "/payment/common/checkOrderOutstanding.do", {salesOrdId : salesOrdId}, function(RESULT) {
           if(RESULT.rootState == 'ROOT_1') {
             Common.alert('No Outstanding' + DEFAULT_DELIMITER + RESULT.msg);
           }
         });
       */
       }
     }

     var isValid = true;
     var isValid_1 = true;
     var isValid_2 = true;
     var reqList = [];
     var payMode = "";

     $.each(selectedItems, function(idx, row){
       if (idx == 0){
         payMode = row.item.payMode;
         slipNo = row.item.slipNo;
       } else {
         if(payMode != row.item.payMode ){
           isValid = false;
         }

         if(slipNo != row.item.slipNo ){
           isValid_1 = false;
         }
       }

       if(row.item.payStusId != "1" ){
         isValid = false;
       } else {
         reqList.push(row.item);
       }

       if( row.item.payMode == "5698" ){
         if( FormUtil.isEmpty( row.item.slipNo ) == true ){
           isValid_1 = false;
         }
       }
     });

     if(!isValid){
       //Common.alert("<spring:message code='pay.alert.payStatus'/>");
       Common.alert("Check Payment Mode.");
       return false;
    }

    if(!isValid_1){
      //Common.alert("<spring:message code='pay.alert.payStatus'/>");
      Common.alert("Check Slip No.");
      return false;
    }

    if(!isValid_2){
      //Common.alert("<spring:message code='pay.alert.payStatus'/>");
      Common.alert("Check Slip No.");
      return false;
    }

    // 초기화
    $("#paymentForm")[0].reset();
    $("#paymentForm1")[0].reset();

    var gridList = reqList;
    //var rejectData = AUIGrid.getSelectedItems(myGridID)[0].item;

    if( payMode == "5696" ){
      // 카드 셋팅시 금액 셋팅
      var totPayAmt = 0;
      $.each(selectedItems, function(idx, row){
        totPayAmt += row.item.payAmt;
      });

      $("#keyInAmount").val(totPayAmt)
      $("#PopUp2_wrap").show(); // Update [ Card ] Key-in
    } else {
      $("#PopUp1_wrap").show(); // Update [ Cash, Cheque, Bank-In Slip ] Key-in
    }

/*
  var indexArr = AUIGrid.getSelectedIndex(myGridID);
  if( indexArr[0] == -1 ){
    Common.alert("<spring:message code='pay.check.noRowsSelected'/>");
  } else {
    var payStusId = AUIGrid.getCellValue(myGridID, indexArr[0], "payStusId");

    if( payStusId != "1" ){
      Common.alert("<spring:message code='pay.alert.payStatus'/>");
      return afalse;
    }

    // 초기화
    $("#paymentForm")[0].reset();
    $("#paymentForm1")[0].reset();

    var gridList = AUIGrid.getSelectedIndex(myGridID);
    var rejectData = AUIGrid.getSelectedItems(myGridID)[0].item;

    if( rejectData.payMode == "40" ){
      $("#PopUp2_wrap").show(); // Update [ Card ] Key-in
    } else {
      $("#PopUp1_wrap").show(); // Update [ Cash, Cheque, Bank-In Slip ] Key-in
    }
  }
*/

  }

  function createAUIGrid() {
    // AUIGrid 칼럼 설정
    // 데이터 형태는 다음과 같은 형태임,
    //[{"id":"#Cust0","date":"2014-09-03","name":"Han","country":"USA","product":"Apple","color":"Red","price":746400}, { .....} ];
    var columnLayout = [{ dataField : "mobTicketNo",
                                     headerText : '<spring:message code="pay.title.ticketNo" />',
                                     width : 100,
                                     editable : false
                                  }, {
                                     dataField : "crtDt",
                                     headerText : '<spring:message code="pay.grid.requestDate" />',
                                     width : 120,
                                     editable : false
                                  }, {
                                     dataField : "payStusNm",
                                     width : 120,
                                     headerText : '<spring:message code="pay.grid.status" />',
                                     editable : false,
                                     style : "aui-grid-user-custom-left"
                                  }, {
                                     dataField : "payModeNm",
                                     width : 160,
                                     headerText : '<spring:message code="sal.text.payMode" />',
                                     editable : false,
                                     style : "aui-grid-user-custom-left"
                                  }, {
                                     dataField : "salesOrdNo",
                                     headerText : '<spring:message code="pay.title.orderNo" />',
                                     width : 120,
                                     editable : false
                                  }, {
                                      dataField : "apptyp",
                                      headerText : '<spring:message code="sal.text.appType" />',
                                      width : 130,
                                      editable : false
                                  }, {
                                      dataField : "pvYear",
                                      headerText : '<spring:message code="sal.title.text.pvYear" />',
                                      width : 120,
                                      editable : false
                                  }, {
                                      dataField : "pvMth",
                                      headerText : '<spring:message code="service.title.PVMonth" />',
                                      width : 120,
                                      editable : false
                                  }, {
                                     dataField : "name",
                                     headerText : '<spring:message code="pay.head.customerName" />',
                                     width : 200,
                                     editable : false,
                                     style : "aui-grid-user-custom-left"
                                  }, {
                                     dataField : "advMonth",
                                     headerText : '<spring:message code="pay.head.advanceMonth2" />',
                                     width : 80,
                                     editable : false
                                  }, {
                                     dataField : "advAmt",
                                     headerText : '<spring:message code="pay.head.advanceAmount" />',
                                     width : 100,
                                     editable : false,
                                     style : "aui-grid-user-custom-right"
                                  }, {
                                     dataField : "otstndAmt",
                                     headerText : '<spring:message code="pay.head.outstandingAmount" />',
                                     width : 100,
                                     editable : false,
                                     style : "aui-grid-user-custom-right"
                                  }, {
                                     dataField : "payAmt",
                                     headerText : '<spring:message code="pay.head.paymentAmount" />',
                                     width : 100,
                                     editable : false,
                                     dataType : "numeric",
                                     style : "aui-grid-user-custom-right"
                                  }, {
                                     dataField : "slipNo",
                                     headerText : '<spring:message code="pay.head.slipNo" />',
                                     width : 140,
                                     editable : false
                                  }, {
                                     dataField : "chequeNo",
                                     headerText : '<spring:message code="pay.title.chequeNo" />',
                                     width : 140,
                                     editable : false
                                  },{
                                     dataField : "issuBankId",
                                     visible : false
                                  }, {
                                     dataField : "bankNm",
                                     headerText : '<spring:message code="pay.text.issBnk" />',
                                     width : 180,
                                     editable : false,
                                     style : "aui-grid-user-custom-left"
                                  }, {
                                     dataField : "chequeDt",
                                     headerText : '<spring:message code="service.text.IssueDt" />',
                                     width : 120,
                                     editable : false
                                  }, {
                                     dataField : "uploadImg",
                                     /* headerText : '<spring:message code=" " />', */
                                     headerText : 'Attachment',
                                     width : 120,
                                     editable : false
                                  }, {
                                    dataField : "attchImgUrl",
                                    width:100,
                                    headerText : "<spring:message code='pay.head.attachment'/>",
                                    renderer : { type : "ImageRenderer",
                                                     width : 20,
                                                     height : 20,
                                                     imgTableRef : {
                                                       "DOWN": "${pageContext.request.contextPath}/resources/AUIGrid/images/arrow-down-black-icon.png"
                                                     }
                                    }
                                  }, {
                                     dataField : "email1",
                                     headerText : '<spring:message code="pay.head.email" />',
                                     width : 180,
                                     editable : false,
                                     style : "aui-grid-user-custom-left"
                                  }, {
                                     dataField : "email2",
                                     headerText : '<spring:message code="pay.head.addEmail" />',
                                     width : 180,
                                     editable : false
                                  }, {
                                     dataField : "sms1",
                                     headerText : '<spring:message code="pay.head.sms" />',
                                     width : 140,
                                     editable : false
                                  }, {
                                     dataField : "sms2",
                                     headerText : '<spring:message code="pay.head.addSms" />',
                                     width : 140,
                                     editable : false
                                  }, {
                                     dataField : "payRem",
                                     headerText : '<spring:message code="pay.head.remark" />',
                                     width : 160,
                                     editable : false,
                                     style : "aui-grid-user-custom-left"
                                  }, {
                                     dataField : "crtUserBrnchNm",
                                     headerText : '<spring:message code="pay.title.branchCode" />',
                                     width : 160,
                                     editable : false
                                  }, {
                                     dataField : "crtUserNm",
                                     headerText : '<spring:message code="pay.head.memberCode" />',
                                     width : 160,
                                     editable : false,
                                     style : "aui-grid-user-custom-left"
                                  }, {
                                     dataField : "updDt",
                                     headerText : '<spring:message code="pay.text.updDt" />',
                                     width : 160,
                                     editable : false
                                  }, {
                                     dataField : "updUserNm",
                                     headerText : '<spring:message code="pay.head.updateUser" />',
                                     width : 160,
                                     editable : false,
                                     style : "aui-grid-user-custom-left"
                                  }, {
                                     dataField : "payStusId",
                                     visible : false
                                  }, {
                                     dataField : "mobPayNo",
                                     visible : false
                                  }, {
                                     dataField : "custBillId",
                                     visible : false
                                  }, {
                                     dataField : "ordId",
                                     visible : false
                                  }, {
                                     dataField : "bill_no",
                                     visible : false
                                  }, {
                                     dataField : "billTypeId",
                                     visible : false
                                  }, {
                                     dataField : "billTypeNm",
                                     visible : false
                                  }, {
                                     dataField : "installment",
                                     visible : false
                                  }, {
                                     dataField : "billDt",
                                     visible : false
                                  }, {
                                     dataField : "billStatus",
                                     visible : false
                                  }, {
                                     dataField : "payMode",
                                     visible : false
                                  }, {
                                      dataField : "crntLdg",
                                      visible : false
                                  }
                                  ]
    // 그리드 속성 설정
    var gridPros = { // 페이징 사용
                            usePaging : true,
                            // 한 화면에 출력되는 행 개수 20(기본값:20)
                            pageRowCount : 20,
                            editable : true,
                             /* fixedColumnCount : 1, */
                            showStateColumn : false,
                            displayTreeOpen : true,
                            //selectionMode : "singleRow",
                            headerHeight : 30,
                            // 그룹핑 패널 사용
                            useGroupingPanel : false,
                            // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
                            skipReadonlyColumns : true,
                            // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
                            wrapSelectionMove : true,
                            // 줄번호 칼럼 렌더러 출력
                            showRowNumColumn : true,
                            showRowCheckColumn : true
    };

    //myGridID  = GridCommon.createAUIGrid("grid_wrap", columnLayout, gridPros);
    myGridID  = AUIGrid.create("#grid_wrap", columnLayout, gridPros);

    AUIGrid.bind(myGridID, "cellClick", function( event ) {
      if( event.dataField == "attchImgUrl" ){
        if( FormUtil.isEmpty(event.value) == false){
          var rowVal = AUIGrid.getItemByRowIndex(myGridID, event.rowIndex);
          if( FormUtil.isEmpty(rowVal.atchFileName) == false && FormUtil.isEmpty(rowVal.physiclFileName) == false){
            window.open("/file/fileDownWasMobile.do?subPath=" + rowVal.fileSubPath + "&fileName=" + rowVal.physiclFileName + "&orignlFileNm=" + rowVal.atchFileName);
          }
        }
      }
    });
  }

  // 리스트 조회.
  function fn_selectPstRequestDOListAjax() {
	console.log($("#searchForm").serialize());
    Common.ajax("GET", "/mobilePaymentKeyIn/selectMobilePaymentKeyInJsonList.do", $("#searchForm").serialize(), function(result) {
      AUIGrid.setGridData(myGridID , result);

      AUIGrid.setProp(myGridID, "rowStyleFunction", function(rowIndex, item) {
          if(item.crntLdg <= 0 && item.payStusId == "1" && (item.advAmt == "" || typeof(item.advAmt) == "undefined")) {
            return "my-pink-style";
          }
       });

       AUIGrid.update(myGridID);
    });
  }

  // f_multiCombo 함수 호출이 되어야만 multi combo 화면이 안깨짐.
  doGetCombo('/common/selectCodeList.do', '435', '','ticketType', 'S' , '');  // Ticket Type
  doGetCombo('/common/selectCodeList.do', '439', '','payMode', 'S' , '');  // Pay Mode
  doGetCombo('/mobileAppTicket/selectMobileAppTicketStatus.do', '', '','ticketStatus', 'S' , '');
  doGetCombo('/common/selectCodeList.do', '130' , ''   ,'keyInCardMode', 'S' , ''); //CreditCardMode 생성
  doGetCombo('/common/selectCodeList.do', '21' , ''   , 'keyInCrcType' , 'S', ''); //Credit Card Type 생성

  // 조회조건 combo box
  function f_multiCombo(){
    $(function() {
      $('#cmbTypeId').change(function() {
      }).multipleSelect({
          selectAll: true, // 전체선택
          width: '80%'
      });
      $('#cmbCorpTypeId').change(function() {
      }).multipleSelect({
          selectAll: true, // 전체선택
          width: '80%'
      });
    });
  }

  function fn_clear(){
    $("#searchForm")[0].reset();
  }

  //크레딧 카드 입력시 Card Mode 변경에 따라 Issue Bank와 Merchant Bank Combo를 갱신한다.
  function fn_changeCrcMode(){
    var cardModeVal = $("#keyInCardMode").val();

    if(cardModeVal == 2710){
      //IssuedBank 생성 : PBB, HLB, MBB, AMBank, HSBC, SCB, UOB
      doGetCombo('/common/getIssuedBankList.do', 'CRC2710' , '' , 'keyInIssueBank' , 'S', '');

      //Merchant Bank 생성 : CIMB, PBB, HLB, MBB, AM BANK, HSBC, SCB, UOB
      doGetCombo('/common/getAccountList.do', 'CRC2710' , '' , 'keyInMerchantBank' , 'S', '');

    } else if (cardModeVal == 2712){      //MPOS IPP
      //IssuedBank 생성 : PBB, HLB, MBB, AMBank, HSBC, SCB, UOB
      doGetCombo('/common/getIssuedBankList.do', 'CRC2712' , '' , 'keyInIssueBank' , 'S', '');

      //Merchant Bank 생성 : CIMB, PBB, HLB, MBB, AM BANK, HSBC, SCB, UOB
      doGetCombo('/common/getAccountList.do', 'CRC2712' , '' , 'keyInMerchantBank' , 'S', '');
    } else {
      //IssuedBank 생성 : ALL
      doGetCombo('/common/getIssuedBankList.do', '' , '' , 'keyInIssueBank' , 'S', '');

      //Merchant Bank 생성
      if(cardModeVal == 2708){ //POS
        doGetCombo('/common/getAccountList.do', 'CRC2708' , '' , 'keyInMerchantBank' , 'S', '');
      } else if (cardModeVal == 2709){ //MOTO
        doGetCombo('/common/getAccountList.do', 'CRC2709' , '' , 'keyInMerchantBank' , 'S', '');
      } else if (cardModeVal == 2711){ //MPOS
        doGetCombo('/common/getAccountList.do', 'CRC2711' , '' , 'keyInMerchantBank' , 'S', '');
      }
    }

    //Tenure Dialble 처리
    $("#keyInTenure").attr("disabled", false);
    $("#keyInTenure").val("");

    if(cardModeVal == 2708 || cardModeVal == 2709 || cardModeVal == 2711){
      $("#keyInTenure").attr("disabled", true);
    } else {
      $("#keyInTenure").attr("disabled", false);
    }
  }

  //Merchant Bank 변경시 Tenure 다시 세팅한다.
  function fn_changeMerchantBank(){
    var keyInMerBank = $("#keyInMerchantBank").val();
    if(keyInMerBank == 102 || keyInMerBank == 104){ //HSBC OR CIMB
      doDefCombo(tenureTypeData1, '' ,'keyInTenure', 'S', '');
    } else if (keyInMerBank == 100 || keyInMerBank == 106 || keyInMerBank == 553) { // MBB OR AMB OR UOB
      doDefCombo(tenureTypeData2, '' ,'keyInTenure', 'S', '');
    } else if (keyInMerBank == 105) { //HLB
      doDefCombo(tenureTypeData3, '' ,'keyInTenure', 'S', '');
    } else if (keyInMerBank == 107 ) { //PBB
      doDefCombo(tenureTypeData4, '' ,'keyInTenure', 'S', '');
    } else if (keyInMerBank == 563){ //SCB
      doDefCombo(tenureTypeData5, '' ,'keyInTenure', 'S', '');
    } else { //OTHER
      doDefCombo(tenureTypeData, '' ,'keyInTenure', 'S', '');
    }
  }

  function savePayment() { // CREDIT CARD
    //Validation Start !!!!!!
    //금액 체크
    if(FormUtil.checkReqValue($("#keyInAmount")) ||$("#keyInAmount").val() <= 0 ){
      Common.alert("<spring:message code='pay.alert.noAmount'/>");
      return;
    }

    if($("#keyInAmount").val() > 200000 ){
      Common.alert("Amount exceed RM 200000");
      return;
    }

    //카드번호 체크
    if(FormUtil.checkReqValue($("#keyInCardNo1")) ||
       FormUtil.checkReqValue($("#keyInCardNo2")) ||
       FormUtil.checkReqValue($("#keyInCardNo3"))  ||
       FormUtil.checkReqValue($("#keyInCardNo4"))){
         Common.alert("<spring:message code='pay.head.noCrcNo'/>");
         return;
    } else {
      var cardNo1Size = $("#keyInCardNo1").val().length;
      var cardNo2Size = $("#keyInCardNo2").val().length;
      var cardNo3Size = $("#keyInCardNo3").val().length;
      var cardNo4Size = $("#keyInCardNo4").val().length;
      var cardNoAllSize = cardNo1Size  + cardNo2Size + cardNo3Size + cardNo4Size;

       if(cardNoAllSize != 16){
         Common.alert("<spring:message code='pay.alert.ivalidCrcNo'/>");
         return;
       }
     }

      //Card Holder 체크
      //금액 체크
      //if(FormUtil.checkReqValue($("#keyInHolderNm"))){
      //    Common.alert("<spring:message code='pay.alert.noCrcHolderName'/>");
      //    return;
      //}

      //카드 유효일자 체크
      if(FormUtil.checkReqValue($("#keyInExpiryMonth")) || FormUtil.checkReqValue($("#keyInExpiryYear"))){
        Common.alert("<spring:message code='pay.alert.noCrcExpiryDate'/>");
        return;
      } else {
        var expiry1Size = $("#keyInExpiryMonth").val().length;
        var expiry2Size = $("#keyInExpiryYear").val().length;

        var expiryAllSize = expiry1Size  + expiry2Size;
        if (expiryAllSize != 4) {
          Common.alert("<spring:message code='pay.alert.invalidCrcExpiryDate'/>");
          return;
        }

         if(Number($("#keyInExpiryMonth").val()) > 12){
           Common.alert("<spring:message code='pay.alert.invalidCrcExpiryDate'/>");
           return;
        }
      }

      //카드 브랜드 체크
      if(FormUtil.checkReqValue($("#keyInCrcType option:selected"))){
        Common.alert("<spring:message code='pay.alert.noCrcBrand'/>");
        return;
      } else {
        var crcType = $("#keyInCrcType").val();
        var cardNo1st1Val = $("#keyInCardNo1").val().substr(0,1);
        var cardNo1st2Val = $("#keyInCardNo1").val().substr(0,2);
        var cardNo1st4Val = $("#keyInCardNo1").val().substr(0,4);

        if(cardNo1st1Val == 4){
          if(crcType != 112){
            Common.alert("<spring:message code='pay.alert.invalidCrcType'/>");
            return;
          }
        }

        if((cardNo1st2Val >= 51 && cardNo1st2Val <= 55) || (cardNo1st4Val >= 2221 && cardNo1st4Val <= 2720)){
          if(crcType != 111){
            Common.alert("<spring:message code='pay.alert.invalidCrcType'/>");
            return;
          }
        }
      }

      //카드 모드 체크
      if(FormUtil.checkReqValue($("#keyInCardMode option:selected"))){
        Common.alert("<spring:message code='pay.alert.noCrcMode'/>");
        return;
      }

      //승인 번호 체크
      if(FormUtil.checkReqValue($("#keyInApprovalNo"))){
        Common.alert("<spring:message code='pay.alert.noApprovalNumber'/>");
        return;
      } else {
        var appValSize = $("#keyInApprovalNo").val().length;

        if(appValSize != 6){
          Common.alert("<spring:message code='pay.alert.invalidApprovalNoLength '/>");
          return;
        }
      }

      //Issue Bank 체크
      if(FormUtil.checkReqValue($("#keyInIssueBank option:selected"))){
        Common.alert("<spring:message code='pay.alert.noIssueBankSelected'/>");
        return;
      }

      //Merchant Bank 체크
      if(FormUtil.checkReqValue($("#keyInMerchantBank option:selected"))){
       Common.alert("<spring:message code='pay.alert.noMerchantBankSelected'/>");
       return;
      }

      //Transaction Date 체크
      if(FormUtil.checkReqValue($("#keyInTrDate"))){
        Common.alert("<spring:message code='pay.head.transDateEmpty'/>");
        return;
      }

      //TR No 체크
      //if(FormUtil.checkReqValue($("#keyInTrNo"))){
      //    Common.alert("<spring:message code='pay.alert.trNoIsEmpty'/>");
      //    return;
      //}

      //TR Issue Date 체크
      //if(FormUtil.checkReqValue($("#keyInTrIssueDate"))){
      //    Common.alert("<spring:message code='pay.alert.trDateIsEmpty'/>");
      //    return;
      //}

      if ($("#trRefNo2").val() != "") {
        if ($("#trIssDt2").val() == "") {
          Common.alert("<spring:message code='sys.msg.necessary' arguments='TR Issued Date' htmlEscape='false'/>");
          return;
        }
      }

      if ($("#trIssDt2").val() != "") {
        if ($("#trRefNo2").val() == "") {
          Common.alert("<spring:message code='sys.msg.necessary' arguments='TR Ref No.' htmlEscape='false'/>");
          return;
        }
      }
      //Validation End !!!!!!

      //param data array
      var data = {};
      //var gridList = AUIGrid.getSelectedIndex(myGridID);
      //var rejectData = AUIGrid.getSelectedItems(myGridID)[0].item;

      var selectedItems = AUIGrid.getCheckedRowItems(myGridID);
      var selPayType = "";
      var reqList = [];
      $.each(selectedItems, function(idx, row){
          if ( idx == 0 ){
            selPayType = row.item.payMode;
          }

          if(row.item.payStusId != "1" ){
            isValid = false;
          } else {
            reqList.push(row.item);
          }
      });

      data.all = reqList;
      var formList = $("#paymentForm").serializeArray();       //폼 데이터

      // array에 담기
      /*
      if(gridList.length > 0) {
            // data.all = rejectData;
            data.all = reqList;
      }  else {
          Common.alert("<spring:message code='pay.alert.noRowData'/>");
          return;
      }
       */

      if(formList.length > 0) data.form = formList;
      else data.form = [];

      //Bill Payment : Order 정보 조회
      /* Common.ajax("POST", "/payment/common/savePayment.do", data, function(result) { */
      Common.ajax("POST", "/mobilePaymentKeyIn/saveMobilePaymentKeyInPayment.do", data, function(result) {

      var message = "<spring:message code='pay.alert.successProc'/>";

      if(result != null && result.length > 0){
        for(i=0 ; i < result.length ; i++){
          message += "<font color='red'>" + result[i].orNo + " (Order No: " + result[i].salesOrdNo +  ")</font><br>";
        }
      }

      fn_clearCrcDtls();

      Common.alert(message, function(){
         //document.location.href = '/payment/initCardKeyInPayment.do';
         fn_selectPstRequestDOListAjax();

         $("#PopUp2_wrap").hide(); // Update [ Card ] Key-in
         $("#PopUp1_wrap").hide(); // Update [ Cash, Cheque, Bank-In Slip ] Key-in

       });
     });
  }

  function fn_clearCrcDtls() {
    $("#keyCrcCardType").val("");
    $("#keyInCrcType").val("");
    $("#keyInCardNo1").val("");
    $("#keyInCardNo2").val("");
    $("#keyInCardNo3").val("");
    $("#keyInCardNo4").val("");
    $("#keyInHolderNm").val("");
    $("#keyInExpiryMonth").val("");
    $("#keyInExpiryYear").val("");
  }

  // NORMAL PAYMENT CASH, CHEQUE, BANK IN SLIP
  function saveNormalPayment(){
    //param data array
    var data = {};
    var msg = "";

    if ($("#transactionId").val() == "") {
      msg += "* <spring:message code='sys.msg.necessary' arguments='Transaction ID' htmlEscape='false'/><br/>";
    }

    if ($("#trRefNo").val() != "") {
      if ($("#trIssDt").val() == "") {
        msg += "* <spring:message code='sys.msg.necessary' arguments='TR Issued Date' htmlEscape='false'/><br/>";
      }
    }

    if ($("#trIssDt").val() != "") {
      if ($("#trRefNo").val() == "") {
       msg += "* <spring:message code='sys.msg.necessary' arguments='TR Ref No.' htmlEscape='false'/><br/>";
      }
    }

    if (msg != "") {
      Common.alert(msg);
      return false;
    }

    /*
       var gridList = AUIGrid.getSelectedIndex(myGridID);
       var rejectData = AUIGrid.getSelectedItems(myGridID)[0].item;
       var gridList = rejectData;
        var selPayType = rejectData.payMode;
    */

    var selectedItems = AUIGrid.getCheckedRowItems(myGridID);
    var selPayType = "";
    var reqList = [];
    $.each(selectedItems, function(idx, row){
       if( idx == 0 ){
         selPayType = row.item.payMode;
       }

       if(row.item.payStusId != "1" ){
         isValid = false;
       } else {
         reqList.push(row.item);
       }
    });

    if( selPayType == "20" ){ // Cash
      selPayType = "105";
    } else if ( selPayType == "5697" ){ // Cheque
      selPayType = "106";
    } else {
      selPayType = "105";
    }

    if(selPayType == "105") {
      /* $("#searchPayType").val("CSH"); */
    } else if(selPayType == "106") {
      /* $("#searchPayType").val("CHQ"); */
    } else if(selPayType == "108") {
      /* $("#searchPayType").val("ONL"); */
    }
    $("#payType").val(selPayType);

    /*
    if(selPayType == '105'){
      $("#cash").find("#bankType").prop("disabled", false);
      // if($("#cash").find("#bankType").val() == '2730'){
           $("#cash").find("#va").prop("disabled", false);
      // }else{
           $("#cash").find("#bankAccCash").prop("disabled", false);
      //}
      } else if (selPayType=='106'){
        $("#cheque").find("#bankType").prop("disabled", false);
        // if($("#cheque").find("#bankType").val() == '2730'){
             $("#cheque").find("#va").prop("disabled", false);
        // } else {
             $("#cheque").find("#bankAccCheque").prop("disabled", false);
        // }
      } else if (selPayType == '108'){
        $("#online").find("#bankType").prop("disabled", false);
        // if($("#online").find("#bankType").val() == '2730'){
             $("#online").find("#va").prop("disabled", false);
        // }else{
             $("#online").find("#bankAccOnline").prop("disabled", false);
        //}
      }
    */

    // var mode = $('#payMode').val() ;
    var mode = selPayType;
    var formList;//폼 데이터

    if(mode == '105' ){
      //formList = $("#cashForm").serializeArray();
    } else if (mode == '106'){
      //formList = $("#chequeForm").serializeArray();
    } else if(mode == '108'){
      //formList = $("#onlineForm").serializeArray();
    }

    formList = $("#paymentForm1").serializeArray();
    data.form = formList;

    data.all = reqList;

    data.key =  $("#transactionId").val();

    //Bill Payment : Order 정보 조회
    Common.ajax("POST", "/mobilePaymentKeyIn/saveMobilePaymentKeyInNormalPayment.do", data, function(result) {
      if(result.p1 == 99){
        Common.alert("<spring:message code='pay.alert.bankstmt.mapped'/>", function(){
          // document.location.href = '/payment/initOtherPayment.do';
          fn_selectPstRequestDOListAjax();
        });
      } else if (result.appType == "CARE_SRVC"){
        Common.ajax("GET", "/payment/common/selectProcessCSPaymentResult.do", {seq : result.seq}, function(resultInfo) {
        var message = "<spring:message code='pay.alert.successProc'/>";

        if(resultInfo != null && resultInfo.length > 0){
           for(i=0 ; i < resultInfo.length ; i++){
             message += "<font color='red'>" + resultInfo[i].orNo + " (Order No: " + resultInfo[i].salesOrdNo +  ")</font><br>";
           }
         }

          Common.alert(message, function(){
            //document.location.href = '/payment/initOtherPayment.do';
            fn_selectPstRequestDOListAjax();
          });
        });
      } else {
        Common.ajax("GET", "/payment/common/selectProcessPaymentResult.do", {seq : result.seq}, function(resultInfo) {
        var message = "<spring:message code='pay.alert.successProc'/>";

         if(resultInfo != null && resultInfo.length > 0){
           for(i=0 ; i < resultInfo.length ; i++){
             message += "<font color='red'>" + resultInfo[i].orNo + " (Order No: " + resultInfo[i].salesOrdNo +  ")</font><br>";
           }
         }

         Common.alert(message, function(){
           // document.location.href = '/payment/initOtherPayment.do';
           fn_selectPstRequestDOListAjax();
         });
       });
     }

     $("#PopUp2_wrap").hide(); // Update [ Card ] Key-in
     $("#PopUp1_wrap").hide(); // Update [ Cash, Cheque, Bank-In Slip ] Key-in
    });
  }

  //카드번호 입력시 번호에 따라 Card Brand 선택
  function fn_changeCardNo1(){
     var cardNo1Size = $("#keyInCardNo1").val().length;

     if(cardNo1Size >= 4){
       var cardNo1st1Val = $("#keyInCardNo1").val().substr(0,1);
       var cardNo1st2Val = $("#keyInCardNo1").val().substr(0,2);
       var cardNo1st4Val = $("#keyInCardNo1").val().substr(0,4);

       if (cardNo1st1Val == 4) {
         $("#keyInCrcType").val(112);
       }

       if((cardNo1st2Val >= 51 && cardNo1st2Val <= 55) || (cardNo1st4Val >= 2221 && cardNo1st4Val <= 2720)){
         $("#keyInCrcType").val(111);
       }
     }
  }

  function fn_viewLdg() {
    var selectedItems = AUIGrid.getCheckedRowItems(myGridID);
    if (selectedItems.length != 1) {
      Common.alert("<spring:message code='sys.msg.oneRcdOnly'/>");
      return;
    }

    var ordId = selectedItems[0].item.ordId;
    $("#ordId").val(ordId);
    Common.popupWin("frmLedger", "/sales/order/orderLedger2ViewPop.do", {width : "1000px", height : "720", resizable: "no", scrollbars: "no"});
  }

  function nextTab (a, e) {
    if (e.keyCode!=8) {
      if (a.value.length == a.size) {
        var no = parseInt(a.name.substring(a.name.length - 1, a.name.length)) + 1;;
        var name = a.name.substring(0, a.name.length - 1);
        $("#" + a.name.substring(0, a.name.length - 1) + no).focus();
      }
    }
  }

</script>

<section id="content"><!-- content start -->
<ul class="path">
  <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
  <li>Sales</li>
  <li>Customer</li>
  <li>Customer</li>
</ul>
<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2><spring:message code="pay.title.text.mobilePaymentKeyIn" /></h2>
<ul class="right_btns">
  <c:if test="${PAGE_AUTH.funcView == 'Y'}">
    <li><p class="btn_blue"><a href="#" id="_listSearchBtn"><span class="search"></span><spring:message code="sal.btn.search" /></a></p></li>
   </c:if>
  <li><p class="btn_blue"><a href="javascript:fn_clear();"><span class="clear"></span><spring:message code='sys.btn.clear'/></a></p></li>
</ul>
</aside><!-- title_line end -->
<section class="search_table"><!-- search_table start -->
  <form id="searchForm" name="searchForm" action="#" method="post">
  <table class="type1"><!-- table start -->
  <caption>table</caption>
  <colgroup>
    <col style="width:140px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:170px" />
    <col style="width:*" />
  </colgroup>
  <tbody>
  <tr>
    <th scope="row"><spring:message code="pay.title.ticketNo" /></th>
    <td>
      <input type="text" title="Ticket No" id="ticketNo" name="ticketNo" placeholder="Ticket No" class="w100p" />
    </td>
    <th scope="row"><spring:message code="pay.grid.requestDate" /></th>
    <td>
      <div class="date_set w100p"><!-- date_set start -->
      <p><input id="_reqstStartDt" name="_reqstStartDt" type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" value="${bfDay}"/></p>
      <span>To</span>
      <p><input id="_reqstEndDt" name="_reqstEndDt" type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" value="${toDay}" /></p>
      </div><!-- date_set end -->
    </td>
    <th scope="row"><spring:message code="pay.title.orderNo" /></th>
    <td>
      <input type="text" title="Order No" id="orderNo" name="orderNo" placeholder="Order No" class="w100p" />
    </td>
  </tr>
  <tr>
  <th scope="row"><spring:message code="pay.title.ticketStatus" /></th>
    <td>
      <select  id="ticketStatus" name="ticketStatus" class="w100p"></select>
    </td>


    <th scope="row"><spring:message code="pay.title.branchCode" /></th>
    <td>
    <select class="multy_select w100p" id="branchCode" name="branchCode" multiple="multiple">
        <c:forEach var="list" items="${userBranch}" varStatus="status">
           <option value="${list.branchid}">${list.c1}</option>
        </c:forEach>
    </select>
       </td>

    <th scope="row"><spring:message code="pay.title.memberCode" /></th>
      <td>
        <input type="text" title="Member Code" id="memberCode" name="memberCode" placeholder="Member Code" class="w100p" />
      </td>
  </tr>
  <tr>
    <th scope="row"><spring:message code="sal.text.payMode" /></th>
      <td>
        <select  id="payMode" name="payMode" class="w100p"></select>
      </td>
      <th scope="row"><spring:message code="pay.head.slipNo" /> / <spring:message code="pay.title.chequeNo" /> </th>
      <td>
        <input type="text" title="Slip No / Cheque No" id=serialNo name="serialNo"  class="w100p" />
      </td>
      <th scope="row"></th>
      <td></td>
  </tr>
  </tbody>
  </table><!-- table end -->
  </form>
</section><!-- search_table end -->
  <ul class="right_btns">
    <c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
       <li><p class="btn_grid"><a href="#" onClick="fn_viewLdg()"><spring:message code="sal.btn.ledger" /> </a></p></li>
    </c:if>
    <c:if test="${PAGE_AUTH.funcUserDefine2 == 'Y'}">
        <li><p class="btn_grid"><a href="#" onClick="fn_validateLdg()"><spring:message code="pay.btn.update" /> </a></p></li>
    </c:if>
    <c:if test="${PAGE_AUTH.funcUserDefine3 == 'Y'}">
        <li><p class="btn_grid"><a href="#" onClick="fn_reject()"><spring:message code="pay.btn.reject" /> </a></p></li>
    </c:if>
    <c:if test="${PAGE_AUTH.funcPrint == 'Y'}">
      <li><p class="btn_grid"><a href="#" onClick="fn_excelDown()"><spring:message code="pay.btn.exceldw" /></a></p></li>
     </c:if>
  </ul>
<section class="search_result"><!-- search_result start -->
<article class="grid_wrap"><!-- grid_wrap start -->
  <div id="grid_wrap" style="width:100%; margin:0 auto;" class="autoGridHeight"></div>
</article><!-- grid_wrap end -->
</section><!-- search_result end -->
 <!-- search_table end -->
 <section class="search_result">
  <!-- search_result start -->
  <div class="divine_auto type2">

  <div id="PopUp1_wrap" class="popup_wrap" style="display: none;">
   <!-- popup_wrap start -->
   <header class="pop_header">
    <!-- pop_header start -->
    <h1> Update [ Cash, Cheque, Bank-In Slip ] Key-in</h1>
    <ul class="right_opt">
     <li><p class="btn_blue2">
       <a href="#"><spring:message code='sys.btn.close' /></a>
      </p></li>
    </ul>
   </header>
   <!-- pop_header end -->
   <section style="max-height:500px; padding:10px; background:#fff; overflow-y:scroll;">
    <!-- pop_body start -->
    <form id="paymentForm1" name="paymentForm1" >
      <input type="hidden" id="payType" name="payType" />
      <input type="hidden" name="keyInPayRoute" id="keyInPayRoute" value="WEB" />
      <input type="hidden" name="keyInScrn" id="keyInScrn" value="NOR" />

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
        <th scope="row">Transaction ID <span class="must">*</span></th>
        <td colspan="3">
         <div >
          <!-- auto_file start -->
            <input type="text" id="transactionId" name="transactionId" placeholder="Transaction ID" value="" />
            <input type="checkbox" name="allowance" value="1" checked><label for="allowance"> Allow commission for this payment</label>
         </div>
         <!-- auto_file end -->
        </td>
       </tr>
       <tr>
         <th scope="row">TR Ref No.</th>
         <td>
           <input type="text" id="trRefNo" name="trRefNo" value="" placeholder="TR Ref.No."/>
         </td>
         <th scope="row">TR Issued Date</th>
         <td>
           <input type="text" title="" placeholder="DD/MM/YYYY" class="j_date" id="trIssDt" name="trIssDt" />
         </td>
       </tr>
      </tbody>
     </table>
     <!-- table end -->
    </form>
    <ul class="center_btns">
     <c:if test="${PAGE_AUTH.funcChange == 'Y'}">
     <li><p class="btn_blue2 big">
       <a id="savePayment1" href="javascript:saveNormalPayment();"><spring:message code='sys.btn.save'/></a>
      </p></li>
     </c:if>
    </ul>
   </section>
   <!-- pop_body end -->
</div>

  <div id="PopUp2_wrap" class="popup_wrap win_popup" style="display: none;">
   <!-- popup_wrap start -->
   <header class="pop_header">
    <!-- pop_header start -->
    <h1> Update [ Card ] Key-in</h1>
    <ul class="right_opt">
     <li><p class="btn_blue2">
       <a href="#"><spring:message code='sys.btn.close' /></a>
      </p></li>
    </ul>
   </header>
       <!-- search_table start -->
    <section style="max-height:500px; padding:10px; background:#fff; overflow-y:scroll;">
        <!-- search_table start -->
        <form id="paymentForm" action="#" method="post">
            <input type="hidden" name="keyInPayRoute" id="keyInPayRoute" value="WEB" />
            <input type="hidden" name="keyInScrn" id="keyInScrn" value="CRC" />
            <input type="hidden" name="keyInPayType" id="keyInPayType" value="107" />

            <table class="type1">
                <caption>table</caption>
                <colgroup>
                    <col style="width:180px" />
                    <col style="width:*" />
                    <col style="width:180px" />
                    <col style="width:*" />
                </colgroup>
                <tbody>
                    <tr>
                        <th scope="row">Card Type<span class="must">*</span></th>
                        <td>
                            <select id="keyCrcCardType" name="keyCrcCardType"  class="w100p">
                                <option value="1241">Credit Card</option>
                                <option value="1240">Debit Card</option>
                            </select>
                        </td>
                        <th scope="row">Amount<span class="must">*</span></th>
                        <td>
                            <input type="text" id="keyInAmount" name="keyInAmount" class="w100p" maxlength="10" onkeydown='return FormUtil.onlyNumber(event)' readonly="readonly" />
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Card Mode<span class="must">*</span></th>
                        <td>
                            <select id="keyInCardMode" name="keyInCardMode"  class="w100p" onChange="javascript:fn_changeCrcMode();">
                            </select>
                        </td>
                        <th scope="row">Card Brand<span class="must">*</span></th>
                        <td>
                            <select id="keyInCrcType" name="keyInCrcType"  class="w100p"></select>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Card No<span class="must">*</span></th>
                        <td>
                            <p class="short"><input type="text" id="keyInCardNo1" name="keyInCardNo1" size="4" maxlength="4" class="wAuto" onkeydown='return FormUtil.onlyNumber(event)' onkeyup='nextTab(this, event);'  onChange="javascript:fn_changeCardNo1();"/></p>
                            <span>-</span>
                            <p class="short"><input type="text" id="keyInCardNo2" name="keyInCardNo2" size="4" maxlength="4" class="wAuto" onkeydown='return FormUtil.onlyNumber(event)' onkeyup='nextTab(this, event);'/></p>
                            <span>-</span>
                            <p class="short"><input type="text" id="keyInCardNo3" name="keyInCardNo3" size="4" maxlength="4" class="wAuto" onkeydown='return FormUtil.onlyNumber(event)' onkeyup='nextTab(this, event);'/></p>
                            <span>-</span>
                            <p class="short"><input type="text" id="keyInCardNo4" name="keyInCardNo4" size="4" maxlength="4" class="wAuto" onkeydown='return FormUtil.onlyNumber(event)' onkeyup='nextTab(this, event);'/></p>
                        </td>
                        <th scope="row">Approval No.<span class="must">*</span></th>
                        <td>
                            <input type="text" id="keyInApprovalNo" name="keyInApprovalNo" class="w100p"  maxlength="6" placeholder="Approval No."/>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Credit Card Holder Name</th>
                        <td colspan="3">
                            <input type="text" id="keyInHolderNm" name="keyInHolderNm" class="w100p" placeholder="Credit Card Holder Name" />
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Issue Bank<span class="must">*</span></th>
                        <td>
                            <select id="keyInIssueBank" name="keyInIssueBank" class="w100p" ></select>
                        </td>
                        <th scope="row">Merchant Bank<span class="must">*</span></th>
                        <td>
                            <select id="keyInMerchantBank" name="keyInMerchantBank" class="w100p" onChange="javascript:fn_changeMerchantBank();"></select>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Expiry Date(mm/yy)<span class="must">*</span></th>
                        <td>
                            <p class="short"><input type="text" id="keyInExpiryMonth" name="keyInExpiryMonth" size="2" maxlength="2" class="wAuto" onkeydown='return FormUtil.onlyNumber(event)' /></p>
                            <span>/</span>
                            <p class="short"><input type="text" id="keyInExpiryYear" name="keyInExpiryYear" size="2" maxlength="2" class="wAuto" onkeydown='return FormUtil.onlyNumber(event)' /></p>
                        </td>
                        <th scope="row">Transaction Date<span class="must">*</span></th>
                        <td>
                            <input id="keyInTrDate" name="keyInTrDate" type="text" title="" placeholder="" class="j_date w100p" readonly />
                        </td>
                    </tr>
                    <tr>
                     <th scope="row">TR Ref No.</th>
                     <td>
                      <input type="text" id="trRefNo2" name="trRefNo2" value="" />
                     </td>
                     <th scope="row">TR Issued Date</th>
                     <td>
                      <input type="text" title="" placeholder="DD/MM/YYYY" class="j_date" id="trIssDt2" name="trIssDt2" />
                     </td>
                    </tr>
                    <tr>
                      <td colspan="4">
                        <div>
                          <input type="checkbox" name="allowance" value="1" checked><label for="allowance"> Allow commission for this payment</label>
                        </div>
                      </td>
                    </tr>

                </tbody>
            </table>
            <!-- table end -->
        </form>
        <ul class="center_btns">
        <c:if test="${PAGE_AUTH.funcChange == 'Y'}">
         <li><p class="btn_blue2 big">
         <a id="cardSave" href="javascript:savePayment();" ><spring:message code='sys.btn.save'/></a>
        </p></li>
       </c:if>
    </ul>
    </section>
    <form id="frmLedger" name="frmLedger" action="#" method="post">
      <input id="ordId" name="ordId" type="hidden" value="" />
    </form>
<!-- search_table end -->
  </div>
  <!-- popup_wrap end -->
 </section>
 <!-- search_result end -->

</section><!-- content end -->
