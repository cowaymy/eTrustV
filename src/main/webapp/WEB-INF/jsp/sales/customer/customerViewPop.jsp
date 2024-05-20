<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javascript">
    // 중앙 정렬
   /*  fn_moveCenter(); */
    //AUIGrid 생성 후 반환 ID
    var addrGridID; // address list
    var contactGridID; // contact list
    var bankAccountGirdID; // bank account list
    var creditCardGridID; // credit card list
    var ownOrderGridID; // own order list
    var thirdPartyGridID; // third party list
    var cowayRewardsGridID; // coway rewards list
    var custStusHistGridID; //customer status history log list
    var custBasicInfoHistGridID; //customer basic info edit history log list

    $(document).ready(function(){

    	createAddrGrid();
    	createContactGrid();
    	createBankGrid();
    	createCardGrid();
    	createOwnOrderGrid();
    	createThirdPartyGrid();
    	createCowayRewardsGrid();
    	createCustStusHistGrid();
    	createCustBasicInfoHistGrid();

        //Call Ajax
        fn_getCustomerAddressAjax(); // address list
        fn_getCustomerContactAjax(); // contact list
        fn_getCustomerBankAjax(); // bank account list
        fn_getCustomerCreditCardAjax(); // credit card list
        fn_getCustomerOwnOrderAjax(); // own order list
        fn_getCustomerThirdPartyAjax(); // third party list
        fn_getCustomerCowayRewardsAjax(); // coway rewards list
        fn_getCustStatusHistoryLogAjax(); // customer status history log list
        fn_getCustBasicInfoHistoryLogAjax(); // customer basic info edit history log list
    });

    function createAddrGrid(){

    	// Address Column
        var addrColumnLayout = [
             {dataField : "name", headerText : '<spring:message code="sal.title.status" />', width : '10%'},
             {dataField : "addr", headerText : '<spring:message code="sal.title.address" />', width : '80%'},
             {dataField : "custAddId", visible : false},
             {
                 dataField : "undefined",
                 headerText : '<spring:message code="sal.title.text.view" />',
                 width : '10%',
                 renderer : {
                          type : "ButtonRenderer",
                          labelText : '<spring:message code="sal.title.text.view" />',
                          onclick : function(rowIndex, columnIndex, value, item) {
                              //pupupWin
                             $("#getparam").val(item.custAddId);
                             Common.popupDiv("/sales/customer/selectCustomerAddrDetailViewPop.do", $("#detailForm").serializeJSON());
                        }
                 }
        }];

        //그리드 속성 설정
        var gridPros = {

                usePaging           : true,         //페이징 사용
                pageRowCount        : 20,           //한 화면에 출력되는 행 개수 20(기본값:20)
                editable            : false,
                fixedColumnCount    : 1,
                showStateColumn     : true,
                displayTreeOpen     : false,
      //          selectionMode       : "singleRow",  //"multipleCells",
                headerHeight        : 30,
                useGroupingPanel    : false,        //그룹핑 패널 사용
                skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
                wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
                showRowNumColumn    : true
            };

        // custInfoGridID = GridCommon.createAUIGrid("grid_custInfo_wrap", columnLayout, "", gridPros);
    	addrGridID = GridCommon.createAUIGrid("address_grid_wrap", addrColumnLayout,'', gridPros);   // address list
    }


    function createContactGrid() {
    	// Contact Column
        var contactColumnLayout= [
              {dataField : "name", headerText : '<spring:message code="sal.title.status" />', width : '10%'},
              {dataField : "name1", headerText : '<spring:message code="sal.text.name" />', width : '40%'},
              {dataField : "telM1", headerText : '<spring:message code="sal.text.telM" />', width : '10%'},
              {dataField : "telO", headerText : '<spring:message code="sal.text.telO" />',width : '10%'},
              {dataField : "telR", headerText : '<spring:message code="sal.text.telR" />', width : '10%' },
              {dataField : "telf",headerText : '<spring:message code="sal.text.telF" />',width : '10%'},
              {dataField : "custCntcId", visible: false },
              {
                  dataField : "undefined",
                  headerText : '<spring:message code="sal.title.text.view" />',
                  width : '10%',
                  renderer : {
                        type : "ButtonRenderer",
                        labelText : '<spring:message code="sal.title.text.view" />',
                        onclick : function(rowIndex, columnIndex, value, item) {
                             //pupupWin
                            $("#getparam").val(item.custCntcId);
                            Common.popupDiv("/sales/customer/selectCustomerContactDetailViewPop.do", $("#detailForm").serializeJSON());
                        }
                 }
             }];

        //그리드 속성 설정
        var gridPros = {

                usePaging           : true,         //페이징 사용
                pageRowCount        : 20,           //한 화면에 출력되는 행 개수 20(기본값:20)
                editable            : false,
                fixedColumnCount    : 1,
                showStateColumn     : true,
                displayTreeOpen     : false,
      //          selectionMode       : "singleRow",  //"multipleCells",
                headerHeight        : 30,
                useGroupingPanel    : false,        //그룹핑 패널 사용
                skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
                wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
                showRowNumColumn    : true
            };

        contactGridID = GridCommon.createAUIGrid("#contact_grid_wrap", contactColumnLayout,'',gridPros); // contact list
	}

    function createBankGrid(){
    	// Bank Column
        var bankColumnLayout= [
               {dataField : "custAccOwner", headerText : '<spring:message code="sal.title.accountHolder" />', width : '30%'},
               {dataField : "codeName", headerText : '<spring:message code="sal.text.type" />', width : '20%'},
               {dataField : "bankName", headerText : '<spring:message code="sal.text.issueBank" />', width : '20%'},
               {dataField : "custAccNo", headerText : '<spring:message code="sal.text.accNo" />', width : '20%'},
               {dataField : "custAccId" , visible : false},
               {
                   dataField : "undefined",
                   headerText : '<spring:message code="sal.title.text.view" />',
                   width : '10%',
                   renderer : {
                      type : "ButtonRenderer",
                      labelText : '<spring:message code="sal.title.text.view" />',
                      onclick : function(rowIndex, columnIndex, value, item) {

                          $("#getparam").val(item.custAccId);
                          Common.popupDiv("/sales/customer/selectCustomerBankDetailViewPop.do", $("#detailForm").serializeJSON());
                      }
               }
           }];

         var gridPros = {

                usePaging           : true,         //페이징 사용
                pageRowCount        : 20,           //한 화면에 출력되는 행 개수 20(기본값:20)
                editable            : false,
                fixedColumnCount    : 1,
                showStateColumn     : true,
                displayTreeOpen     : false,
 //               selectionMode       : "singleRow",  //"multipleCells",
                headerHeight        : 30,
                useGroupingPanel    : false,        //그룹핑 패널 사용
                skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
                wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
                showRowNumColumn    : true
            };

         bankAccountGirdID = GridCommon.createAUIGrid("#bank_grid_wrap", bankColumnLayout,'',gridPros); // bank account list
    }

    function createCardGrid(){

    	// CreditCard Column
        var creditCardColumnLayout = [
               {dataField : "custCrcOwner", headerText : '<spring:message code="sal.text.nameOnCard" />', width : '15%'},
               {dataField : "codeName", headerText : '<spring:message code="sal.text.cardType" />', width : '10%'},
               {dataField : "codeName1", headerText : '<spring:message code="sal.title.type" />', width : '10%'},
               {dataField : "bankName", headerText : '<spring:message code="sal.text.issueBank" />', width : '30%'},
               {dataField : "custOriCrcNo", headerText : '<spring:message code="sal.text.creditCardNo" />', width : '15%'},
               {dataField : "custCrcExpr", headerText : '<spring:message code="sal.title.text.expiry" />', width : '10%'},
               {dataField : "custCrcId", visible : false},
               {
                   dataField : "undefined",
                   headerText : '<spring:message code="sal.title.text.view" />',
                   width : '10%',
                   renderer : {
                       type : "ButtonRenderer",
                       labelText : '<spring:message code="sal.title.text.view" />',
                       onclick : function(rowIndex, columnIndex, value, item) {

                           $("#getparam").val(item.custCrcId);
                           Common.popupDiv("/sales/customer/selectCustomerCreditCardDetailViewPop.do", $("#detailForm").serializeJSON());
                       }
                }
        }];

        var gridPros = {

                usePaging           : true,         //페이징 사용
                pageRowCount        : 20,           //한 화면에 출력되는 행 개수 20(기본값:20)
                editable            : false,
                fixedColumnCount    : 1,
                showStateColumn     : true,
                displayTreeOpen     : false,
    //            selectionMode       : "singleRow",  //"multipleCells",
                headerHeight        : 30,
                useGroupingPanel    : false,        //그룹핑 패널 사용
                skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
                wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
                showRowNumColumn    : true
            };

        creditCardGridID = GridCommon.createAUIGrid("#creditcard_grid_wrap", creditCardColumnLayout,'',gridPros); // credit card list

    }

    function createOwnOrderGrid(){
    	// Own Order Column
        var ownOrderColumnLayout = [
               { dataField : "salesOrdNo", headerText : '<spring:message code="sal.text.ordNo" />', width : 100},
               { dataField : "salesDt", headerText : '<spring:message code="sal.text.ordDate" />', width : 100},
               { dataField : "code", headerText : '<spring:message code="sal.title.text.appType" />', width : 100},
               { dataField : "code1", headerText : '<spring:message code="sal.title.status" />', width : 100},
               { dataField : "stkDesc", headerText : '<spring:message code="sal.title.text.product" />', width : 100},
               { dataField : "code2", headerText : '<spring:message code="sal.title.paymode" />', width : 100 },
               { dataField : "bankCode", headerText : '<spring:message code="sal.title.issueBank" />', width : 100},
               { dataField : "rentAmt", headerText : '<spring:message code="sal.title.outstanding" />', width : 100},
               {dataField : "custBillGrpNo",headerText : 'RBG group No>', width : 100},

               {
                   dataField : "undefined",
                   headerText : '<spring:message code="sal.title.text.viewLedger" />',
                   width : 100,
                   renderer : {
                       type : "ButtonRenderer",
                       labelText : '<spring:message code="sal.btn.link.ledger" />',
                       onclick : function(rowIndex, columnIndex, value, item) {
                           $("#_ordId").val(item.salesOrdId);
                           var option = {
                                      width : "1200px",   // 창 가로 크기
                                      height : "700px"    // 창 세로 크기
                              };
                    	   Common.popupWin('legderParam', "/sales/order/orderLedgerViewPop.do", option);
                       }
                    }
               },
               {
                   dataField : "undefined",
                   headerText : '<spring:message code="sal.title.text.viewOrder" />',
                   width : 100,
                   renderer : {
                       type : "ButtonRenderer",
                       labelText : '<spring:message code="sal.title.text.order" />',
                       onclick : function(rowIndex, columnIndex, value, item) {
                    	    //$("#_ordId").val(item.salesOrdId);
                    	    //Common.popupWin('legderParam', "/sales/order/orderLedger2ViewPop.do", option);
                    	    Common.popupDiv("/sales/order/orderDetailPop.do", { salesOrderId : item.salesOrdId }, null, true, "_divIdOrdDtl");
                   }
            }
        }];

        var gridPros = {

                usePaging           : true,         //페이징 사용
                pageRowCount        : 20,           //한 화면에 출력되는 행 개수 20(기본값:20)
                editable            : false,
                fixedColumnCount    : 1,
                showStateColumn     : true,
                displayTreeOpen     : false,
     //           selectionMode       : "singleRow",  //"multipleCells",
                headerHeight        : 30,
                useGroupingPanel    : false,        //그룹핑 패널 사용
                skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
                wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
                showRowNumColumn    : true
            };

        ownOrderGridID = GridCommon.createAUIGrid("#ownorder_grid_wrap", ownOrderColumnLayout,'',gridPros); // own order list
    }

    function createThirdPartyGrid(){
    	// Thrid Party Order Column
        var thirdPartyColumnLayout = [
             {dataField : "salesOrdNo",headerText : '<spring:message code="sal.text.ordNo" />', width : '10%'},
             {dataField : "salesDt", headerText : '<spring:message code="sal.text.ordDate" />', width : '10%'},
             {dataField : "code", headerText : '<spring:message code="sal.title.text.appType" />', width : '10%'},
             {dataField : "code1", headerText : '<spring:message code="sal.title.status" />', width : '5%'},
             {dataField : "stkDesc", headerText : '<spring:message code="sal.title.text.product" />', width : '15%'},
             {dataField : "code2", headerText : '<spring:message code="sal.title.paymode" />',width : '10%'},
             {dataField : "bankCode", headerText : '<spring:message code="sal.title.issueBank" />', width : '10%'},
             {dataField : "rentAmt",headerText : '<spring:message code="sal.title.outstanding" />', width : '10%'},

             {
                 dataField : "undefined",
                 headerText : '<spring:message code="sal.title.text.viewLedger" />',
                 width : '10%',
                 renderer : {
                     type : "ButtonRenderer",
                     labelText : '<spring:message code="sal.btn.link.ledger" />',
                     onclick : function(rowIndex, columnIndex, value, item) {
	                    	 $("#_ordId").val(item.salesOrdId);
	                         Common.popupWin('legderParam', "/sales/order/orderLedgerViewPop.do", option);
                         }
                 }
             },{
                 dataField : "undefined",
                 headerText : '<spring:message code="sal.title.text.viewOrder" />',
                 width : '10%',
                 renderer : {
                     type : "ButtonRenderer",
                     labelText : '<spring:message code="sal.title.text.order" />',
                     onclick : function(rowIndex, columnIndex, value, item) {
                    	 //$("#_ordId").val(item.salesOrdId);
                         //Common.popupWin('legderParam', "/sales/order/orderLedger2ViewPop.do", option);
                         Common.popupDiv("/sales/order/orderDetailPop.do", { salesOrderId : item.salesOrdId }, null, true, "_divIdOrdDtl");
                   }
            }
        }];

        var gridPros = {

                usePaging           : true,         //페이징 사용
                pageRowCount        : 20,           //한 화면에 출력되는 행 개수 20(기본값:20)
                editable            : false,
                fixedColumnCount    : 1,
                showStateColumn     : true,
                displayTreeOpen     : false,
  //              selectionMode       : "singleRow",  //"multipleCells",
                headerHeight        : 30,
                useGroupingPanel    : false,        //그룹핑 패널 사용
                skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
                wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
                showRowNumColumn    : true
            };

        thirdPartyGridID = GridCommon.createAUIGrid("#thirdparty_grid_wrap", thirdPartyColumnLayout,'',gridPros);// third party list
    }

    function createCowayRewardsGrid(){
        // Coway Rewards Column
        var cowayRewardsColumnLayout = [
             {dataField : "tireType",headerText : '<spring:message code="sal.text.pointType" />', width : '40%'},
             {dataField : "refNo", headerText : '<spring:message code="sal.text.refNo" />', width : '20%'},
             {dataField : "refDate", headerText : '<spring:message code="sal.title.date" />', width : '20%'},
             {dataField : "rewrdPoint", headerText : '<spring:message code="sal.text.earnedPoint" />', width : '20%'}
        ];

        var gridPros = {

                usePaging           : true,         //페이징 사용
                pageRowCount        : 20,           //한 화면에 출력되는 행 개수 20(기본값:20)
                editable            : false,
                fixedColumnCount    : 1,
                showStateColumn     : true,
                displayTreeOpen     : false,
  //              selectionMode       : "singleRow",  //"multipleCells",
                headerHeight        : 30,
                useGroupingPanel    : false,        //그룹핑 패널 사용
                skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
                wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
                showRowNumColumn    : true
            };

        cowayRewardsGridID = GridCommon.createAUIGrid("#cowayrewards_grid_wrap", cowayRewardsColumnLayout,'',gridPros);// coway Rewards list
    }

    function createCustStusHistGrid(){
        // Coway Rewards Column
        var custStusHistColumnLayout = [
             {dataField : "name",headerText : '<spring:message code="sal.text.custName" />', width : '40%'},
             {dataField : "codeName", headerText : '<spring:message code="sal.text.custStus" />', width : '30%'},
             {dataField : "createDt", headerText : '<spring:message code="sal.text.updateDate" />', width : '30%'},
        ];

        var gridPros = {

                usePaging           : true,         //페이징 사용
                pageRowCount        : 20,           //한 화면에 출력되는 행 개수 20(기본값:20)
                editable            : false,
                fixedColumnCount    : 1,
                showStateColumn     : true,
                displayTreeOpen     : false,
  //              selectionMode       : "singleRow",  //"multipleCells",
                headerHeight        : 30,
                useGroupingPanel    : false,        //그룹핑 패널 사용
                skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
                wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
                showRowNumColumn    : true
            };

        custStusHistGridID = GridCommon.createAUIGrid("#cust_stus_hist_grid_wrap", custStusHistColumnLayout,'',gridPros);// customer status history log
    }

    function createCustBasicInfoHistGrid(){
        // Coway Rewards Column
        var custBasicInfoHistColumnLayout = [
             {dataField : "custName",headerText : '<spring:message code="sal.text.custName" />', width : '30%'},
             {dataField : "custType", headerText : '<spring:message code="sal.text.custType" />', width : '20%'},
             {dataField : "corpType", headerText : '<spring:message code="sal.text.companyType" />', width : '20%'},
             {dataField : "nric",headerText : '<spring:message code="sal.text.nricCompanyNo" />', width : '20%'},
             {dataField : "email", headerText : '<spring:message code="sal.text.email" />', width : '30%'},
             {dataField : "nation", headerText : '<spring:message code="sal.text.nationality" />', width : '10%'},
             {dataField : "gender",headerText : '<spring:message code="sal.text.gender" />', width : '10%'},
             {dataField : "dob", headerText : '<spring:message code="sal.text.dob" />', width : '10%'},
             {dataField : "race", headerText : '<spring:message code="sal.text.race" />', width : '10%'},
             {dataField : "passportExpr", headerText : '<spring:message code="sal.text.passportExpire" />', width : '15%'},
             {dataField : "visaExpr", headerText : '<spring:message code="sal.text.visaExpire" />', width : '10%'},
             {dataField : "sstNo", headerText : '<spring:message code="sal.text.sstRegistrationNo" />', width : '20%'},
             {dataField : "custTin", headerText : '<spring:message code="sal.text.tin" />', width : '30%'},
             {dataField : "eInvFlg", headerText : '<spring:message code="sal.text.eInvoicFlag" />', width : '10%'},
             {dataField : "remark", headerText : '<spring:message code="sal.text.remark" />', width : '30%'},
             {dataField : "updDt", headerText : '<spring:message code="sal.text.updateAt" />', width : '20%'},
             {dataField : "updUser", headerText : '<spring:message code="sal.text.updateBy" />', width : '20%'},
        ];

        var gridPros = {

                usePaging           : true,         //페이징 사용
                pageRowCount        : 20,           //한 화면에 출력되는 행 개수 20(기본값:20)
                editable            : false,
                showStateColumn     : true,
                displayTreeOpen     : false,
  //              selectionMode       : "singleRow",  //"multipleCells",
                headerHeight        : 30,
                useGroupingPanel    : false,        //그룹핑 패널 사용
                skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
                wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
                showRowNumColumn    : true
            };

        custBasicInfoHistGridID = GridCommon.createAUIGrid("#cust_basic_info_hist_grid_wrap", custBasicInfoHistColumnLayout,'',gridPros);// customer basic info history log list
    }

    // ajax View 조회.
    // address Ajax
    function fn_getCustomerAddressAjax() {
        Common.ajax("GET", "/sales/customer/selectCustomerAddressJsonList",$("#getParamForm").serialize(), function(result) {
            AUIGrid.setGridData(addrGridID, result);
        });
    }

    // contact Ajax
    function fn_getCustomerContactAjax(){
        Common.ajax("GET", "/sales/customer/selectCustomerContactJsonList",$("#getParamForm").serialize(), function(result) {
            AUIGrid.setGridData(contactGridID, result);
        });
    }

    // bank Ajax
    function fn_getCustomerBankAjax(){
        Common.ajax("GET", "/sales/customer/selectCustomerBankAccJsonList",$("#getParamForm").serialize(), function(result) {
            AUIGrid.setGridData(bankAccountGirdID, result);
        });
    }

    // creaditcard Ajax
    function fn_getCustomerCreditCardAjax(){
        Common.ajax("GET", "/sales/customer/selectCustomerCreditCardJsonList",$("#getParamForm").serialize(), function(result) {
            AUIGrid.setGridData(creditCardGridID, result);
        });
    }

    // own Order Ajax
    function fn_getCustomerOwnOrderAjax(){
        Common.ajax("GET", "/sales/customer/selectCustomerOwnOrderJsonList",$("#getParamForm").serialize(), function(result) {
            AUIGrid.setGridData(ownOrderGridID, result);
        });
    }

    // third party Ajax
    function fn_getCustomerThirdPartyAjax(){
        Common.ajax("GET", "/sales/customer/selectCustomerThirdPartyJsonList",$("#getParamForm").serialize(), function(result) {
            AUIGrid.setGridData(thirdPartyGridID, result);
        });
    }

    // coway rewards  Ajax
    function fn_getCustomerCowayRewardsAjax (){
        Common.ajax("GET", "/sales/customer/selectCustomerCowayRewardsJsonList",$("#getParamForm").serialize(), function(result) {
            AUIGrid.setGridData(cowayRewardsGridID, result);
        });
    }

    function fn_getCustStatusHistoryLogAjax() {
        Common.ajax("GET", "/sales/customer/selectCustomerStatusHistoryLogJsonList",$("#getParamForm").serialize(), function(result) {
            AUIGrid.setGridData(custStusHistGridID, result);
        });
    }

    function fn_getCustBasicInfoHistoryLogAjax() {
        Common.ajax("GET", "/sales/customer/selectCustomerBasicInfoHistoryLogJsonList",$("#getParamForm").serialize(), function(result) {
            AUIGrid.setGridData(custBasicInfoHistGridID, result);
        });
    }

    //resize func (tab click)
     function fn_resizefunc(obj, gridName){ //

         var $this = $(obj);
         var width = $this.width();

    	  AUIGrid.resize(gridName, width, $(".grid_wrap").innerHeight());

//         setTimeout(function(){
//             AUIGrid.resize(gridName);
//         }, 100);
    }

/*     function fn_moveCenter() {
           var sw = screen.width;
           var sh = screen.height;
           var cw = document.body.clientWidth;
           var ch = document.body.clientHeight;
           var top  = sh / 2 - ch / 2 - 100;
           var left = sw / 2 - cw / 2;
           window.moveTo(left, top);
    } */
</script>

<form id="legderParam" name="legderParam" method="POST">
    <input type="hidden" id="_ordId" name="ordId" >
</form>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->
<!-- Pop up Form -->
<form id="detailForm">
    <input type="hidden"  id="getparam" name="getparam"/>
</form>
<!-- get param Form  -->
<form id="getParamForm" method="get">
    <input type="hidden" name="custAddrId" value="${custAddrId}"/>
    <input type="hidden" name="custId" value="${custId}"/>
    <input type="hidden" name="custCntcId" value="${custCntcId}">
</form>

<header class="pop_header"><!-- pop_header start -->
<h1>View Customer</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#"><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->
<article class="acodi_wrap"><!-- acodi_wrap start -->
<dl>
    <dt class="click_add_on on"><a href="#"><spring:message code="sal.page.title.custInformation" /></a></dt>
    <dd>

    <section class="tap_wrap mt0"><!-- tap_wrap start -->
    <ul class="tap_type1">
        <li><a href="#" class="on"><spring:message code="sal.tap.title.basicInfo" /></a></li>
        <li><a href="#"><spring:message code="sal.tap.title.mainAddr" /></a></li>
        <li><a href="#"><spring:message code="sal.tap.title.mainContact" /></a></li>
    </ul>
    <!-- ######### basic info ######### -->
    <article class="tap_area"><!-- tap_area start -->
    <table class="type1"><!-- table start -->
    <caption>table</caption>
    <colgroup>
        <col style="width:155px" />
        <col style="width:*" />
        <col style="width:180px" />
        <col style="width:*" />
        <col style="width:110px" />
        <col style="width:*" />
    </colgroup>
    <tbody>
    <tr>
        <th scope="row"><spring:message code="sal.text.customerId" /></th>
        <td><span>${result.custId}</span></td>
        <th scope="row"><spring:message code="sal.text.custType" /></th>
        <td>
            <span>
                ${result.codeName1}
                <!-- not Individual -->
                <c:if test="${ result.typeId ne 964}">
                    (${result.codeName})
                </c:if>
            </span>
        </td>
        <th scope="row"><spring:message code="sal.text.createAt" /></th>
        <td><span>${result.crtDt}</span></td>
    </tr>
    <tr>
        <th scope="row"><spring:message code="sal.text.custName" /></th>
        <td colspan="3">${result.name}</td>
        <th scope="row"><spring:message code="sal.text.createBy" /></th>
        <td>
            <c:if test="${result.crtUserId ne 0}">
                ${result.userName1}
            </c:if>
        </td>
    </tr>
    <tr>
        <th scope="row"><spring:message code="sal.text.nricCompanyNum" /></th>
        <td>${result.nric}</td>
        <th scope="row"><spring:message code="sal.text.gstRegistrationNo" /></th>
        <td>${result.gstRgistNo}</td>
        <th scope="row"><spring:message code="sal.text.updateBy" /></th>
        <td>${result.userName1}</td>
    </tr>
    <tr>
        <th scope="row"><spring:message code="sal.text.email" /></th>
        <td>${result.email}</td>
        <th scope="row"><spring:message code="sal.text.nationality" /></th>
        <td>${result.cntyName}</td>
        <th scope="row"><spring:message code="sal.text.updateAt" /></th>
        <td>${result.updDt}</td>
    </tr>
    <tr>
        <th scope="row"><spring:message code="sal.text.gender" /></th>
        <td>${result.gender}</td>
        <th scope="row"><spring:message code="sal.text.dob" /></th>
        <td>
            <c:if test="${result.dob ne '01-01-1900'}">
                ${result.dob}
            </c:if>
        </td>
        <th scope="row"><spring:message code="sal.title.race" /></th>
        <td>${result.codeName2 }</td>
    </tr>
    <tr>
        <th scope="row"><spring:message code="sal.text.passportExpire" /></th>
        <td>
            <c:if test="${result.pasSportExpr ne '01-01-1900'}">
                ${result.pasSportExpr}
            </c:if>
        </td>
        <th scope="row"><spring:message code="sal.text.visaExpire" /></th>
        <td>
           <c:if test="${result.visaExpr ne '01-01-1900'}">
                ${result.visaExpr}
            </c:if>
         </td>
        <th scope="row"><spring:message code="sal.text.vaNumber" /></th>
        <td>${result.custVaNo}</td>
    </tr>
    <tr>
        <th scope="row"><spring:message code="sal.title.text.tierStatus" /></th>
        <td>${result.tierStatus}</td>
        <th scope="row"><spring:message code="sal.title.text.curPoint" /></th>
        <td>${result.curPoint}</td>
        <th scope="row"><spring:message code="sal.title.text.ExpingPoint" /></th>
        <td>${result.expingPoint}</td>
    </tr>
    <tr>
        <th scope="row"><spring:message code="sal.title.text.onholdPoint" /></th>
        <td>${result.onholdPoint}</td>
        <th scope="row"><spring:message code="sal.title.text.expiredPoint" /></th>
        <td>${result.expiredPoint}</td>
        <th scope="row"><spring:message code="sal.title.text.tin" /></th>
        <td>${result.custTin}</td>
    </tr>
    <tr>
        <th scope="row"><spring:message code="sal.title.text.sstRegistrationNo" /></th>
        <td>${result.sstRgistNo}</td>
        <th scope="row"><spring:message code="sal.title.text.eInvoicFlag" /></th>
        <td>
	        <c:choose>
		    <c:when test="${result.eInvFlg eq '1'}">
		       <input id="isEInvoice" name="isEInvoice" type="checkbox" onClick="return false" checked/>
		    </c:when>
		    <c:otherwise>
		       <input id="isEInvoice" name="isEInvoice" type="checkbox" onClick="return false"/>
		    </c:otherwise>
	        </c:choose>
        </td>

        <th scope="row">Customer Status</th>
        <td><span>${result.custStatus}</span></td>
    </tr>
    <tr>
        <th scope="row"><spring:message code="sal.title.remark" /></th>
        <td colspan="5">${result.rem}</td>
    </tr>
    </tbody>
    </table><!-- table end -->
    </article><!-- tap_area end -->

    <!-- ######### main address info ######### -->
    <article class="tap_area"><!-- tap_area start -->
    <table class="type1"><!-- table start -->
    <caption>table</caption>
    <colgroup>
        <col style="width:120px" />
        <col style="width:*" />
    </colgroup>
    <tbody>
     <tr>
         <th scope="row"><spring:message code="sal.text.fullAddr" /></th>
         <td><span>${addresinfo.fullAddress}</span></td>
     </tr>
     <tr>
         <th scope="row"><spring:message code="sal.title.remark" /></th>
         <td>${addresinfo.rem}</td>
     </tr>
    </tbody>
    </table><!-- table end -->
    </article><!-- tap_area end -->

    <!-- ######### main Contact info ######### -->
    <article class="tap_area"><!-- tap_area start -->
    <table class="type1"><!-- table start -->
    <caption>table</caption>
    <colgroup>
        <col style="width:120px" />
        <col style="width:*" />
        <col style="width:150px" />
        <col style="width:*" />
        <col style="width:115px" />
        <col style="width:*" />
    </colgroup>
    <tbody>
    <tr>
        <th scope="row"><spring:message code="sal.text.name" /></th>
        <td><span>${contactinfo.name1}</span></td>
        <th scope="row"><spring:message code="sal.text.initial" /></th>
        <td>${contactinfo.code}</td>
        <th scope="row"><spring:message code="sal.text.gender" /></th>
        <td>
            <c:choose >
                <c:when test="${contactinfo.gender eq 'M'}">
                     Male
                </c:when>
                <c:when test="${contactinfo.gender eq 'F'}">
                     Female
                </c:when>
                <c:otherwise>
                    <!-- korean : 5  -->
                </c:otherwise>
            </c:choose>
        </td>
    </tr>
    <tr>
        <th scope="row"><spring:message code="sal.text.nric" /></th>
        <td>${contactinfo.nric}</td>
        <th scope="row"><spring:message code="sal.text.dob" /></th>
        <td>
            <c:if test="${contactinfo.dob ne  '01-01-1900'}">
                ${contactinfo.dob}
            </c:if>
        </td>
        <th scope="row"><spring:message code="sal.text.race" /></th>
        <td>${contactinfo.codeName}</td>
    </tr>
    <tr>
        <th scope="row"><spring:message code="sal.text.email" /></th>
        <td>${contactinfo.email}</td>
        <th scope="row"><spring:message code="sal.text.dept" /></th>
        <td>${contactinfo.dept}</td>
        <th scope="row"><spring:message code="sal.text.post" /></th>
        <td>${contactinfo.pos}</td>
    </tr>
    <tr>
        <th scope="row"><spring:message code="sal.text.telM" /></th>
        <td>${contactinfo.telM1}</td>
        <th scope="row"><spring:message code="sal.text.telR" /></th>
        <td>${contactinfo.telR}</td>
        <th scope="row"><spring:message code="sal.text.telO" /></th>
        <td>${contactinfo.telO }</td>
    </tr>
    <tr>
        <th scope="row"><spring:message code="sal.text.telF" /></th>
        <td colspan="5">${contactinfo.telf}</td>
    </tr>
    </tbody>
    </table><!-- table end -->
    </article><!-- tap_area end -->
    </section><!-- tap_wrap end -->
    </dd>
    <!-- ######### Tab Area #########  -->

    <!-- ######### Customer Basic Info History List ######### -->
     <dt class="click_add_on"><a href="#" onclick="javascript: fn_resizefunc(this, custBasicInfoHistGridID)"><spring:message code="sal.title.custBasicInfoHistLog" /></a></dt>
    <dd>
    <article class="grid_wrap"><!-- grid_wrap start -->
        <div id="cust_basic_info_hist_grid_wrap" style="width:100%; height:480px; margin:0 auto;"></div>
    </article><!-- grid_wrap end -->
    </dd>
    <!-- ######### Customer Status History Log List ######### -->
     <dt class="click_add_on"><a href="#" onclick="javascript: fn_resizefunc(this, custStusHistGridID)"><spring:message code="sal.title.custStusHistLog" /></a></dt>
    <dd>
    <article class="grid_wrap"><!-- grid_wrap start -->
        <div id="cust_stus_hist_grid_wrap" style="width:100%; height:480px; margin:0 auto;"></div>
    </article><!-- grid_wrap end -->
    </dd>
    <!-- ######### Customer Address List ######### -->
    <dt class="click_add_on"><a href="#" onclick="javascript: fn_resizefunc(this, addrGridID)"><spring:message code="sal.title.custAddrList" /></a></dt>
    <dd>
    <article class="grid_wrap"><!-- grid_wrap start -->
        <div id="address_grid_wrap" style="width:100%; height:480px; margin:0 auto;"></div>
    </article><!-- grid_wrap end -->
    </dd>
    <!-- ######### Customer Contact List ######### -->
    <dt class="click_add_on"><a href="#" onclick="javascript: fn_resizefunc(this, contactGridID)"><spring:message code="sal.title.custContactList" /></a></dt>
    <dd>
    <article class="grid_wrap"><!-- grid_wrap start -->
        <div id="contact_grid_wrap" style="width:100%; height:480px; margin:0 auto;"></div>
    </article><!-- grid_wrap end -->
    </dd>
    <!-- ######### Customer Bank Account List ######### -->
    <dt class="click_add_on"><a href="#" onclick="javascript: fn_resizefunc(this, bankAccountGirdID)"><spring:message code="sal.title.custBankAccList" /></a></dt>
    <dd>
    <article class="grid_wrap"><!-- grid_wrap start -->
        <div id="bank_grid_wrap" style="width:100%; height:480px; margin:0 auto;"></div>
    </article><!-- grid_wrap end -->
    </dd>
    <!-- ######### Customer Credit Card List ######### -->
    <dt class="click_add_on"><a href="#" onclick="javascript: fn_resizefunc(this, creditCardGridID)"><spring:message code="sal.title.custCrdCardList" /></a></dt>
    <dd>
    <article class="grid_wrap"><!-- grid_wrap start -->
        <div id="creditcard_grid_wrap" style="width:100%; height:480px; margin:0 auto;"></div>
    </article><!-- grid_wrap end -->
    </dd>
    <!-- ######### Own Order(s) List ######### -->
    <dt class="click_add_on"><a href="#" onclick="javascript: fn_resizefunc(this, ownOrderGridID)"><spring:message code="sal.title.ownOrds" /></a></dt>
    <dd>
    <article class="grid_wrap"><!-- grid_wrap start -->
        <div id="ownorder_grid_wrap" style="width:100%; height:480px; margin:0 auto;"></div>
    </article><!-- grid_wrap end -->
    </dd>
    <!-- #########hird Party Order(s) List ######### -->
    <dt class="click_add_on"><a href="#" onclick="javascript: fn_resizefunc(this, thirdPartyGridID)"><spring:message code="sal.title.text.thirdPartyOrds" /></a></dt>
    <dd>
    <article class="grid_wrap"><!-- grid_wrap start -->
        <div id="thirdparty_grid_wrap" style="width:100%; height:480px; margin:0 auto;"></div>
    </article><!-- grid_wrap end -->
    </dd>
    <!-- #########Coway Rewards Point Breakdown List ######### -->
    <dt class="click_add_on"><a href="#" onclick="javascript: fn_resizefunc(this, cowayRewardsGridID)"><spring:message code="sal.title.text.cowayRewards" /></a></dt>
    <dd>
    <article class="grid_wrap"><!-- grid_wrap start -->
        <div id="cowayrewards_grid_wrap" style="width:100%; height:480px; margin:0 auto;"></div>
    </article><!-- grid_wrap end -->
    </dd>
</dl>
</article><!-- acodi_wrap end -->
</section><!-- pop_body end -->
</div>