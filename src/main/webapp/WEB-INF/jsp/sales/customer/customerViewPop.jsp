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
    
    $(document).ready(function(){
        
    	createAddrGrid();
    	createContactGrid();
    	createBankGrid();
    	createCardGrid();
    	createOwnOrderGrid();
    	createThirdPartyGrid();
    	
        //Call Ajax
        fn_getCustomerAddressAjax(); // address list
        fn_getCustomerContactAjax(); // contact list
        fn_getCustomerBankAjax(); // bank account list
        fn_getCustomerCreditCardAjax(); // credit card list
        fn_getCustomerOwnOrderAjax(); // own order list
        fn_getCustomerThirdPartyAjax(); // third party list
    });

    function createAddrGrid(){
    	
    	// Address Column
        var addrColumnLayout = [ 
             {dataField : "name", headerText : "Status", width : '10%'}, 
             {dataField : "addr", headerText : "Address", width : '80%'},
             {dataField : "custAddId", visible : false},
             {
                 dataField : "undefined", 
                 headerText : "View", 
                 width : '10%',
                 renderer : {
                          type : "ButtonRenderer", 
                          labelText : "View", 
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
                showRowNumColumn    : true,         //줄번호 칼럼 렌더러 출력    
                noDataMessage       : "No order found.",
                groupingMessage     : "Here groupping"
            };
        
        // custInfoGridID = GridCommon.createAUIGrid("grid_custInfo_wrap", columnLayout, "", gridPros);
    	addrGridID = GridCommon.createAUIGrid("address_grid_wrap", addrColumnLayout,'', gridPros);   // address list
    }
    
    
    function createContactGrid() {
    	// Contact Column
        var contactColumnLayout= [ 
              {dataField : "name", headerText : "Status", width : '10%'},
              {dataField : "name1", headerText : "Name", width : '40%'},
              {dataField : "telM1", headerText : "Tel(Mobile)", width : '10%'},
              {dataField : "telO", headerText : "Tel(Office)",width : '10%'},
              {dataField : "telR", headerText : "Tel(Residence)", width : '10%' },
              {dataField : "telf",headerText : "Tel(Fax)",width : '10%'},
              {dataField : "custCntcId", visible: false },
              {
                  dataField : "undefined",
                  headerText : "View",
                  width : '10%',
                  renderer : {
                        type : "ButtonRenderer",
                        labelText : "View",
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
                showRowNumColumn    : true,         //줄번호 칼럼 렌더러 출력    
                noDataMessage       : "No order found.",
                groupingMessage     : "Here groupping"
            };
        
        contactGridID = GridCommon.createAUIGrid("#contact_grid_wrap", contactColumnLayout,'',gridPros); // contact list
	}
    
    function createBankGrid(){
    	// Bank Column
        var bankColumnLayout= [
               {dataField : "custAccOwner", headerText : "Account Holder", width : '30%'}, 
               {dataField : "codeName", headerText : "Type", width : '20%'}, 
               {dataField : "bankName", headerText : "Issue Bank", width : '20%'},
               {dataField : "custAccNo", headerText : "Account No", width : '20%'},
               {dataField : "custAccId" , visible : false},
               {
                   dataField : "undefined",
                   headerText : "View",
                   width : '10%',
                   renderer : {
                      type : "ButtonRenderer",
                      labelText : "View",
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
                showRowNumColumn    : true,         //줄번호 칼럼 렌더러 출력    
                noDataMessage       : "No order found.",
                groupingMessage     : "Here groupping"
            };
         
         bankAccountGirdID = GridCommon.createAUIGrid("#bank_grid_wrap", bankColumnLayout,'',gridPros); // bank account list
    }
    
    function createCardGrid(){
    	
    	// CreditCard Column
        var creditCardColumnLayout = [
               {dataField : "custCrcOwner", headerText : "Name On Card", width : '15%'}, 
               {dataField : "codeName", headerText : "Card Type", width : '10%'}, 
               {dataField : "codeName1", headerText : "Type", width : '10%'},
               {dataField : "bankName", headerText : "Issue Bank", width : '30%'},
               {dataField : "custOriCrcNo", headerText : "Credit Card No", width : '15%'},
               {dataField : "custCrcExpr", headerText : "Expiry", width : '10%'},
               {dataField : "custCrcId", visible : false},
               {
                   dataField : "undefined",
                   headerText : "View",
                   width : '10%',
                   renderer : {
                       type : "ButtonRenderer",
                       labelText : "View",
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
                showRowNumColumn    : true,         //줄번호 칼럼 렌더러 출력    
                noDataMessage       : "No order found.",
                groupingMessage     : "Here groupping"
            };
        
        creditCardGridID = GridCommon.createAUIGrid("#creditcard_grid_wrap", creditCardColumnLayout,'',gridPros); // credit card list
    	
    }
    
    function createOwnOrderGrid(){
    	// Own Order Column
        var ownOrderColumnLayout = [
               { dataField : "salesOrdNo", headerText : "Order No", width : '10%'},
               { dataField : "salesDt", headerText : "Order Date", width : '10%'},
               { dataField : "code", headerText : "App Type", width : '10%'},
               { dataField : "code1", headerText : "Status", width : '5%'},
               { dataField : "stkDesc", headerText : "Product", width : '15%'},
               { dataField : "code2", headerText : "Paymode", width : '10%' },
               { dataField : "bankCode", headerText : "Issue Bank", width : '10%'},
               { dataField : "rentAmt", headerText : "Outstanding", width : '10%'},
               { 
                   dataField : "undefined", 
                   headerText : "View Ledger", 
                   width : '10%',
                   renderer : {
                       type : "ButtonRenderer",
                       labelText : "Ledger",
                       onclick : function(rowIndex, columnIndex, value, item) {
                           $("#_ordId").val(item.salesOrdId);
                    	   Common.popupWin('legderParam', "/sales/order/orderLedgerViewPop.do", option);
                       }
                    }
               },
               {
                   dataField : "undefined",
                   headerText : "View Order",
                   width : '10%',
                   renderer : {
                       type : "ButtonRenderer",
                       labelText : "Order",
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
                showRowNumColumn    : true,         //줄번호 칼럼 렌더러 출력    
                noDataMessage       : "No order found.",
                groupingMessage     : "Here groupping"
            };
        
        ownOrderGridID = GridCommon.createAUIGrid("#ownorder_grid_wrap", ownOrderColumnLayout,'',gridPros); // own order list
    }
    
    function createThirdPartyGrid(){
    	// Thrid Party Order Column
        var thirdPartyColumnLayout = [
             {dataField : "salesOrdNo",headerText : "Order No", width : '10%'},
             {dataField : "salesDt", headerText : "Order Date", width : '10%'},
             {dataField : "code", headerText : "App Type", width : '10%'},
             {dataField : "code1", headerText : "Status", width : '5%'},
             {dataField : "stkDesc", headerText : "Product", width : '15%'},
             {dataField : "code2", headerText : "Paymode",width : '10%'},
             {dataField : "bankCode", headerText : "Issue Bank", width : '10%'},
             {dataField : "rentAmt",headerText : "Outstanding", width : '10%'},
             {
                 dataField : "undefined",
                 headerText : "View Ledger",
                 width : '10%',
                 renderer : {
                     type : "ButtonRenderer",
                     labelText : "Ledger",
                     onclick : function(rowIndex, columnIndex, value, item) {
	                    	 $("#_ordId").val(item.salesOrdId);
	                         Common.popupWin('legderParam', "/sales/order/orderLedgerViewPop.do", option);
                         }
                 }
             },{
                 dataField : "undefined",
                 headerText : "View Order",
                 width : '10%',
                 renderer : {
                     type : "ButtonRenderer",
                     labelText : "Order",
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
                showRowNumColumn    : true,         //줄번호 칼럼 렌더러 출력    
                noDataMessage       : "No order found.",
                groupingMessage     : "Here groupping"
            };
        
        thirdPartyGridID = GridCommon.createAUIGrid("#thirdparty_grid_wrap", thirdPartyColumnLayout,'',gridPros);// third party list 
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
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->
<article class="acodi_wrap"><!-- acodi_wrap start -->
<dl>
    <dt class="click_add_on on"><a href="#">Customer Information</a></dt>
    <dd>
    
    <section class="tap_wrap mt0"><!-- tap_wrap start -->
    <ul class="tap_type1">
        <li><a href="#" class="on">Basic Info</a></li>
        <li><a href="#">Main Address</a></li>
        <li><a href="#">Main Contact</a></li>
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
        <th scope="row">Customer ID</th>
        <td><span>${result.custId}</span></td>
        <th scope="row">Customer Type</th>
        <td>
            <span> 
                ${result.codeName1}
                <!-- not Individual -->  
                <c:if test="${ result.typeId ne 964}">
                    (${result.codeName})
                </c:if>
            </span>
        </td>
        <th scope="row">Create At</th>
        <td><span>${result.crtDt}</span></td>
    </tr>
    <tr>
        <th scope="row">Customer Name</th>
        <td colspan="3">${result.name}</td>
        <th scope="row">Create By</th>
        <td>
            <c:if test="${result.crtUserId ne 0}">
                ${result.userName1}
            </c:if>
        </td>
    </tr>
    <tr>
        <th scope="row">NRIC/Company Number</th>
        <td>${result.nric}</td>
        <th scope="row">GST Registration No</th>
        <td>${result.gstRgistNo}</td>
        <th scope="row">Update By</th>
        <td>${result.userName1}</td>
    </tr>
    <tr>
        <th scope="row">Email</th>
        <td>${result.email}</td>
        <th scope="row">Nationality</th>
        <td>${result.cntyName}</td>
        <th scope="row">Update At</th>
        <td>${result.updDt}</td>
    </tr>
    <tr>
        <th scope="row">Gender</th>
        <td>${result.gender}</td>
        <th scope="row">DOB</th>
        <td>
            <c:if test="${result.dob ne '01-01-1900'}">
                ${result.dob}
            </c:if>
        </td>
        <th scope="row">Race</th>
        <td>${result.codeName2 }</td>
    </tr>
    <tr>
        <th scope="row">Passport Expire</th>
        <td>
            <c:if test="${result.pasSportExpr ne '01-01-1900'}">
                ${result.pasSportExpr}
            </c:if>
        </td> 
        <th scope="row">Visa Expire</th>
        <td>
           <c:if test="${result.visaExpr ne '01-01-1900'}">
                ${result.visaExpr}
            </c:if>
         </td>
        <th scope="row">VA Number</th>
        <td>${result.custVaNo}</td>
    </tr>
    <tr>
        <th scope="row">Remark</th>
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
         <th scope="row">Full Address</th>
         <td><span>${addresinfo.fullAddress}</span></td>
     </tr>
     <tr>
         <th scope="row">Remark</th>
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
        <th scope="row">Name</th>
        <td><span>${contactinfo.name1}</span></td>
        <th scope="row">Initial</th>
        <td>${contactinfo.code}</td>
        <th scope="row">Gender</th>
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
        <th scope="row">NRIC</th>
        <td>${contactinfo.nric}</td>
        <th scope="row">DOB</th>
        <td>
            <c:if test="${contactinfo.dob ne  '01-01-1900'}">
                ${contactinfo.dob}
            </c:if> 
        </td>
        <th scope="row">Race</th>
        <td>${contactinfo.codeName}</td>
    </tr>
    <tr>
        <th scope="row">Email</th>
        <td>${contactinfo.email}</td>
        <th scope="row">Department</th>
        <td>${contactinfo.dept}</td>
        <th scope="row">Post</th>
        <td>${contactinfo.pos}</td>
    </tr>
    <tr>
        <th scope="row">Tel (Mobile)</th>
        <td>${contactinfo.telM1}</td>
        <th scope="row">Tel (Residence)</th>
        <td>${contactinfo.telR}</td>
        <th scope="row">Tel (Office)</th>
        <td>${contactinfo.telO }</td>
    </tr>
    <tr>
        <th scope="row">Tel (Fax)</th>
        <td colspan="5">${contactinfo.telf}</td>
    </tr>
    </tbody>
    </table><!-- table end -->
    </article><!-- tap_area end -->
    </section><!-- tap_wrap end -->
    </dd>
    <!-- ######### Tab Area #########  -->
    <!-- ######### Customer Address List ######### -->
    <dt class="click_add_on"><a href="#" onclick="javascript: fn_resizefunc(this, addrGridID)">Customer Address List</a></dt>
    <dd>
    <article class="grid_wrap"><!-- grid_wrap start -->
        <div id="address_grid_wrap" style="width:100%; height:480px; margin:0 auto;"></div>
    </article><!-- grid_wrap end -->
    </dd>
    <!-- ######### Customer Contact List ######### -->
    <dt class="click_add_on"><a href="#" onclick="javascript: fn_resizefunc(this, contactGridID)">Customer Contact List</a></dt>
    <dd>
    <article class="grid_wrap"><!-- grid_wrap start -->
        <div id="contact_grid_wrap" style="width:100%; height:480px; margin:0 auto;"></div>
    </article><!-- grid_wrap end -->
    </dd>
    <!-- ######### Customer Bank Account List ######### -->
    <dt class="click_add_on"><a href="#" onclick="javascript: fn_resizefunc(this, bankAccountGirdID)">Customer Bank Account List</a></dt>
    <dd>
    <article class="grid_wrap"><!-- grid_wrap start -->
        <div id="bank_grid_wrap" style="width:100%; height:480px; margin:0 auto;"></div>
    </article><!-- grid_wrap end -->
    </dd>
    <!-- ######### Customer Credit Card List ######### -->
    <dt class="click_add_on"><a href="#" onclick="javascript: fn_resizefunc(this, creditCardGridID)">Customer Credit Card List</a></dt>
    <dd> 
    <article class="grid_wrap"><!-- grid_wrap start -->
        <div id="creditcard_grid_wrap" style="width:100%; height:480px; margin:0 auto;"></div>
    </article><!-- grid_wrap end -->
    </dd>
    <!-- ######### Own Order(s) List ######### -->
    <dt class="click_add_on"><a href="#" onclick="javascript: fn_resizefunc(this, ownOrderGridID)">Own Order(s)</a></dt>
    <dd>
    <article class="grid_wrap"><!-- grid_wrap start -->
        <div id="ownorder_grid_wrap" style="width:100%; height:480px; margin:0 auto;"></div>
    </article><!-- grid_wrap end -->
    </dd>
    <!-- #########hird Party Order(s) List ######### -->
    <dt class="click_add_on"><a href="#" onclick="javascript: fn_resizefunc(this, thirdPartyGridID)">Third Party Order(s)</a></dt>
    <dd>
    <article class="grid_wrap"><!-- grid_wrap start -->
        <div id="thirdparty_grid_wrap" style="width:100%; height:480px; margin:0 auto;"></div>
    </article><!-- grid_wrap end -->
    </dd>
</dl>
</article><!-- acodi_wrap end -->
</section><!-- pop_body end -->
</div>