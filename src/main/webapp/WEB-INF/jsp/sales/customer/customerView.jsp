<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javascript">
//AUIGrid 생성 후 반환 ID
var addrGridID; // address list
var contactGridID; // contact list
var bankAccountGirdID; // bank account list
var creditCardGridID; // credit card list
var ownOrderGridID; // own order list
var thirdPartyGridID; // third party list

$(document).ready(function(){
	//AUIGrid 그리드를 생성합니다. (address, contact , bank, creditcard, ownorder, thirdparty )
    addrGridID = GridCommon.createAUIGrid("#address_grid_wrap", addrColumnLayout, '', gridPros);  // address list
    contactGridID = GridCommon.createAUIGrid("#contact_grid_wrap", contactColumnLayout, gridPros); // contact list
    bankAccountGirdID = GridCommon.createAUIGrid("#bank_grid_wrap", bankColumnLayout, gridPros); // bank account list
    creditCardGridID = GridCommon.createAUIGrid("#creditcard_grid_wrap", creditCardColumnLayout, gridPros); // credit card list
    ownOrderGridID = GridCommon.createAUIGrid("#ownorder_grid_wrap", ownOrderColumnLayout,gridPros); // own order list
    thirdPartyGridID = GridCommon.createAUIGrid("#thirdparty_grid_wrap", thirdPartyColumnLayout,gridPros);// third party list 
    
    //
   /*  AUIGrid.setSelectionMode(addrGridID, "singleRow"); */
    //Call Ajax
    fn_getCustomerAddressAjax(); // address list
    fn_getCustomerContactAjax(); // contact list
    fn_getCustomerBankAjax(); // bank account list
    fn_getCustomerCreditCardAjax(); // credit card list
    fn_getCustomerOwnOrderAjax(); // own order list
    fn_getCustomerThirdPartyAjax(); // third party list
});
 // ajax View 조회.
    // address Ajax
    function fn_getCustomerAddressAjax() {        
        Common.ajax("GET", "/sales/customer/selectCustomerAddressJsonList",null, function(result) {
            AUIGrid.setGridData(addrGridID, result);
        });
    }
    // contact Ajax
    function fn_getCustomerContactAjax(){
        Common.ajax("GET", "/sales/customer/selectCustomerContactJsonList",null, function(result) {
            AUIGrid.setGridData(contactGridID, result);
        });
    }
    // bank Ajax
    function fn_getCustomerBankAjax(){
        Common.ajax("GET", "/sales/customer/selectCustomerBankAccJsonList",null, function(result) {
            AUIGrid.setGridData(bankAccountGirdID, result);
        });
    }
    // creaditcard Ajax
    function fn_getCustomerCreditCardAjax(){
        Common.ajax("GET", "/sales/customer/selectCustomerCreditCardJsonList",null, function(result) {
            AUIGrid.setGridData(creditCardGridID, result);
        });
    }
    // own Order Ajax
    function fn_getCustomerOwnOrderAjax(){
        Common.ajax("GET", "/sales/customer/selectCustomerOwnOrderJsonList",null, function(result) {
            AUIGrid.setGridData(ownOrderGridID, result);
        });
    }
    // third party Ajax
    function fn_getCustomerThirdPartyAjax(){
        Common.ajax("GET", "/sales/customer/selectCustomerThirdPartyJsonList",null, function(result) {
            AUIGrid.setGridData(thirdPartyGridID, result);
        });
    }
//AUIGrid 칼럼 설정
//데이터 형태는 다음과 같은 형태임,
//[{"id":"#Cust0","date":"2014-09-03","name":"Han","country":"USA","product":"Apple","color":"Red","price":746400}, { .....} ];
    // Address Column
    var addrColumnLayout = [ 
         {dataField : "name", headerText : "Status", width : 100}, 
         {dataField : "addr", headerText : "Address", width : 100},
         {dataField : "custAddId", headerText : "hidden", width:100, visible : false},
         {
        	 dataField : "undefined", 
        	 headerText : "View", 
        	 width : 120,
             renderer : {
            	      type : "ButtonRenderer", 
            	      labelText : "View", 
            	      onclick : function(rowIndex, columnIndex, value, item) {
            	    	  //pupupWin
            	    	  $("#addrparam").val(item.custAddId);
            	    	  Common.popupWin("addrForm", "/sales/customer/selectCustomerAddrDetailView.do");
                    }
             }
         }];
    
    // Contact Column
    var contactColumnLayout= [ 
          {dataField : "name", headerText : "Status", width : 100},
          {dataField : "c9", headerText : "Name", width : 100},
          {dataField : "c16", headerText : "Tel(Mobile)", width : 100},
          {dataField : "c17", headerText : "Tel(Office)",width : 100},
          {dataField : "c18", headerText : "Tel(Residence)", width : 100 },
          {dataField : "c15",headerText : "Tel(Fax)",width : 100},
          {
        	  dataField : "undefined",
        	  headerText : "View",
        	  width : 120,
              renderer : {
                    type : "ButtonRenderer",
                    labelText : "View",
                    onclick : function(rowIndex, columnIndex, value, item) {
                        /* value 에 해당 키값 가져가야함 */
                        alert(rowIndex +"번째 "+item.name + " 상세보기 클릭");
                    }
             }
         }];
    // Bank Column
     var bankColumnLayout= [
            {dataField : "c7", headerText : "Account Holder", width : 100}, 
            {dataField : "c10", headerText : "Type", width : 100}, 
            {dataField : "c5", headerText : "Issue Bank", width : 100},
            {dataField : "c1", headerText : "Account No", width : 100},
            {
            	dataField : "undefined",
            	headerText : "View",
            	width : 120,
            	renderer : {
                   type : "ButtonRenderer",
                   labelText : "View",
                   onclick : function(rowIndex, columnIndex, value, item) {
                       /* value 에 해당 키값 가져가야함 */
                       alert(rowIndex +"번째 "+item.name + " 상세보기 클릭");
                   }
            }
        }]; 
    // CreditCard Column
    var creditCardColumnLayout = [
           {dataField : "c6", headerText : "Name On Card", width : 100}, 
           {dataField : "codeName", headerText : "Card Type", width : 100}, 
           {dataField : "c10", headerText : "Type", width : 100},
           {dataField : "c4", headerText : "Issue Bank", width : 100},
           {dataField : "c8", headerText : "Credit Card No", width : 100},
           {dataField : "c5", headerText : "Expiry", width : 100},
           {
        	   dataField : "undefined",
        	   headerText : "View",
        	   width : 120,
        	   renderer : {
                   type : "ButtonRenderer",
                   labelText : "View",
                   onclick : function(rowIndex, columnIndex, value, item) {
                       /* value 에 해당 키값 가져가야함 */
                       alert(rowIndex +"번째 "+item.name + " 상세보기 클릭");
                   }
            }
    }];
    // Own Order Column
    var ownOrderColumnLayout = [
           { dataField : "c3", headerText : "Order No", width : 100},
           { dataField : "c4", headerText : "Order Date", width : 100},
           { dataField : "c6", headerText : "App Type", width : 100},
           { dataField : "c9", headerText : "Status", width : 100},
           { dataField : "c12", headerText : "Product", width : 100},
           { dataField : "c14", headerText : "Paymode", width : 100 },
           { dataField : "c15", headerText : "Issue Bank", width : 100},
           { dataField : "c16", headerText : "Outstanding", width : 100},
           { 
        	   dataField : "undefined", 
        	   headerText : "View Ledger", 
        	   width : 120,
        	   renderer : {
        		   type : "ButtonRenderer",
        		   labelText : "View Ledger",
        		   onclick : function(rowIndex, columnIndex, value, item) {
                   /* value 에 해당 키값 가져가야함 */
                   alert(rowIndex +"번째 "+item.name + " 상세보기 클릭");
                   }
                }
           },
           {
        	   dataField : "undefined",
        	   headerText : "View Order",
        	   width : 120,
        	   renderer : {
        		   type : "ButtonRenderer",
        		   labelText : "View Order",
        		   onclick : function(rowIndex, columnIndex, value, item) {
                   /* value 에 해당 키값 가져가야함 */
                   alert(rowIndex +"번째 "+item.name + " 상세보기 클릭");
               }
        }
    }];
    // Thrid Party Order Column
    var thirdPartyColumnLayout = [
         {dataField : "salesOrdNo",headerText : "Order No", width : 100},
         {dataField : "c1", headerText : "Order Date", width : 100},
         {dataField : "code", headerText : "App Type", width : 100},
         {dataField : "code1", headerText : "Status", width : 100},
         {dataField : "stkDesc", headerText : "Product", width : 100},
         {dataField : "code2", headerText : "Paymode",width : 100},
         {dataField : "c6", headerText : "Issue Bank", width : 100},
         {dataField : "c7",headerText : "Outstanding", width : 100},
         {
        	 dataField : "undefined",
        	 headerText : "View Ledger",
        	 width : 120,
        	 renderer : {
        		 type : "ButtonRenderer",
        		 labelText : "View Ledger",
        		 onclick : function(rowIndex, columnIndex, value, item) {
        			 /* value 에 해당 키값 가져가야함 */
        			 alert(rowIndex +"번째 "+item.name + " 상세보기 클릭");
        			 }
             }
         },{
        	 dataField : "undefined",
        	 headerText : "View Order",
        	 width : 120,
        	 renderer : {
        		 type : "ButtonRenderer",
        		 labelText : "View Order",
        		 onclick : function(rowIndex, columnIndex, value, item) {
                   /* value 에 해당 키값 가져가야함 */
                   alert(rowIndex +"번째 "+item.name + " 상세보기 클릭");
               }
        }
    }];
    
//그리드 속성 설정
var gridPros = {
        
        // 페이징 사용       
        usePaging : true,
        
        // 한 화면에 출력되는 행 개수 10(기본값:10)
        pageRowCount : 10,
        
        editable : false,
        
        fixedColumnCount : 1,
        
        showStateColumn : true, 
        
        displayTreeOpen : true,
        
        selectionMode : "multipleCells",
        
        headerHeight : 30,
        
        // 그룹핑 패널 사용
        useGroupingPanel : true,
        
        // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
        skipReadonlyColumns : true,
        
        // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
        wrapSelectionMove : true,
        
        // 줄번호 칼럼 렌더러 출력
        showRowNumColumn : false,
        
        groupingMessage : "Here groupping"
    };
</script>
</head>
<body>
<form id="addrForm">
    <input type="hidden"  id="addrparam" name="addrparam"/>
</form>
<div id="popup_wrap"><!-- popup_wrap start -->
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
        <th scope="row">Custormer ID</th>
        <td><span>${result.customerid}</span></td>
        <th scope="row">Custormer Type</th>
        <td>
            <span> 
                ${result.c7}
                <!-- not Individual -->  
                <c:if test="${result.c7 ne 'Individual'}">
                    (${result.c6})
                </c:if>
            </span>
        </td>
        <th scope="row">Create At</th>
        <td><span>${result.c3}</span></td>
    </tr>
    <tr>
        <th scope="row">Custormer Name</th>
        <td colspan="3">${result.name }</td>
        <th scope="row">Create By</th>
        <td>
            <c:if test="${result.c1 ne 0}">
                ${result.c1}
            </c:if>
        </td>
    </tr>
    <tr>
        <th scope="row">NRIC/Company Number</th>
        <td>${result.nric}</td>
        <th scope="row">GST Registration No</th>
        <td>${result.c23}</td>
        <th scope="row">Update By</th>
        <td>${result.c18}</td>
    </tr>
    <tr>
        <th scope="row">Email</th>
        <td>${result.c9}</td>
        <th scope="row">Nationality</th>
        <td>${result.c12}</td>
        <th scope="row">Update At</th>
        <td>${result.c17}</td>
    </tr>
    <tr>
        <th scope="row">Gender</th>
        <td>${result.c10}</td>
        <th scope="row">DOB</th>
        <td>
            <c:if test="${result.c8 ne '01-01-1900'}">
                ${result.c8}
            </c:if>
        </td>
        <th scope="row">Race</th>
        <td>${result.c14 }</td>
    </tr>
    <tr>
        <th scope="row">Passport Expire</th>
        <td>${result.passportexpire}</td>
        <th scope="row">Visa Expire</th>
        <td>${result.visaexpire}</td>
        <th scope="row">VA Number</th>
        <td>${result.c22}</td>
    </tr>
    <tr>
        <th scope="row">Remark</th>
        <td colspan="5">${result.reMark}</td>
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
    <c:if test="${not empty addresinfo}">
            <tr>
                <th scope="row">Full Address</th>
                <td><span>${addresinfo.c1}&nbsp;${addresinfo.c2}&nbsp;${addresinfo.c3}&nbsp;
                ${addresinfo.c5}&nbsp;${addresinfo.c7}&nbsp;${addresinfo.c9}&nbsp;${addresinfo.c11}</span></td>
            </tr>
            <tr>
                <th scope="row">Remark</th>
                <td>${addresinfo.c12}</td>
            </tr>
    </c:if>
    
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
        <td><span>${contactinfo.c9}</span></td>
        <th scope="row">Initial</th>
        <td></td>
        <th scope="row">Gender</th>
        <td>
            <c:choose >
                <c:when test="${contactinfo.c6 eq 'M'}">
                     Male
                </c:when>
                <c:when test="${contactinfo.c6 eq 'F'}">
                     Female
                </c:when>
                <c:otherwise>
                    ${contactinfo.c6}
                </c:otherwise>
            </c:choose>
        </td>
    </tr>
    <tr>
        <th scope="row">NRIC</th>
        <td>${contactinfo.c10}</td>
        <th scope="row">DOB</th>
        <td>
            <c:if test="${contactinfo.c4 ne  '01-01-1900'}">
                ${contactinfo.c4}
            </c:if> 
        </td>
        <th scope="row">Race</th>
        <td>${contactinfo.c13}</td>
    </tr>
    <tr>
        <th scope="row">Email</th>
        <td>${contactinfo.c5}</td>
        <th scope="row">Department</th>
        <td>${contactinfo.c3}</td>
        <th scope="row">Post</th>
        <td>${contactinfo.c11}</td>
    </tr>
    <tr>
        <th scope="row">Tel (Mobile)</th>
        <td>${contactinfo.c16}</td>
        <th scope="row">Tel (Residence)</th>
        <td>${contactinfo.c18}</td>
        <th scope="row">Tel (Office)</th>
        <td>${contactinfo.c17 }</td>
    </tr>
    <tr>
        <th scope="row">Tel (Fax)</th>
        <td colspan="5">${contactinfo.c15}</td>
    </tr>
    </tbody>
    </table><!-- table end -->
    </article><!-- tap_area end -->
    </section><!-- tap_wrap end -->
    </dd>
    <!-- ######### Customer Address List ######### -->
    <dt class="click_add_on"><a href="#">Customer Address List</a></dt>
    <dd>
    <ul class="right_btns">
        <li><p class="btn_grid"><a href="#">EXCEL UP</a></p></li>
        <li><p class="btn_grid"><a href="#">EXCEL DW</a></p></li>
        <li><p class="btn_grid"><a href="#">DEL</a></p></li>
        <li><p class="btn_grid"><a href="#">INS</a></p></li>
        <li><p class="btn_grid"><a href="#">ADD</a></p></li>
    </ul>

    <article class="grid_wrap"><!-- grid_wrap start -->
        <div id="address_grid_wrap" style="width:500; height:480px; margin:0 auto;"></div>
    </article><!-- grid_wrap end -->
    </dd>
    <!-- ######### Customer Contact List ######### -->
    <dt class="click_add_on"><a href="#">Customer Contact List</a></dt>
    <dd>
    
    <ul class="right_btns">
        <li><p class="btn_grid"><a href="#">EXCEL UP</a></p></li>
        <li><p class="btn_grid"><a href="#">EXCEL DW</a></p></li>
        <li><p class="btn_grid"><a href="#">DEL</a></p></li>
        <li><p class="btn_grid"><a href="#">INS</a></p></li>
        <li><p class="btn_grid"><a href="#">ADD</a></p></li>
    </ul>

    <article class="grid_wrap"><!-- grid_wrap start -->
        <div id="contact_grid_wrap" style="width:100%; height:480px; margin:0 auto;"></div>
    </article><!-- grid_wrap end -->

    </dd>
    <!-- ######### Customer Bank Account List ######### -->
    <dt class="click_add_on"><a href="#">Customer Bank Account List</a></dt>
    <dd>
    
    <ul class="right_btns">
        <li><p class="btn_grid"><a href="#">EXCEL UP</a></p></li>
        <li><p class="btn_grid"><a href="#">EXCEL DW</a></p></li>
        <li><p class="btn_grid"><a href="#">DEL</a></p></li>
        <li><p class="btn_grid"><a href="#">INS</a></p></li>
        <li><p class="btn_grid"><a href="#">ADD</a></p></li>
    </ul>

    <article class="grid_wrap"><!-- grid_wrap start -->
        <div id="bank_grid_wrap" style="width:100%; height:480px; margin:0 auto;"></div>
    </article><!-- grid_wrap end -->

    </dd>
    <!-- ######### Customer Credit Card List ######### -->
    <dt class="click_add_on"><a href="#">Customer Credit Card List</a></dt>
    <dd>
    
    <ul class="right_btns">
        <li><p class="btn_grid"><a href="#">EXCEL UP</a></p></li>
        <li><p class="btn_grid"><a href="#">EXCEL DW</a></p></li>
        <li><p class="btn_grid"><a href="#">DEL</a></p></li>
        <li><p class="btn_grid"><a href="#">INS</a></p></li>
        <li><p class="btn_grid"><a href="#">ADD</a></p></li>
    </ul>

    <article class="grid_wrap"><!-- grid_wrap start -->
        <div id="creditcard_grid_wrap" style="width:100%; height:480px; margin:0 auto;"></div>
    </article><!-- grid_wrap end -->

    </dd>
    <!-- ######### Own Order(s) List ######### -->
    <dt class="click_add_on"><a href="#">Own Order(s)</a></dt>
    <dd>
    
    <ul class="right_btns">
        <li><p class="btn_grid"><a href="#">EXCEL UP</a></p></li>
        <li><p class="btn_grid"><a href="#">EXCEL DW</a></p></li>
        <li><p class="btn_grid"><a href="#">DEL</a></p></li>
        <li><p class="btn_grid"><a href="#">INS</a></p></li>
        <li><p class="btn_grid"><a href="#">ADD</a></p></li>
    </ul>

    <article class="grid_wrap"><!-- grid_wrap start -->
        <div id="ownorder_grid_wrap" style="width:100%; height:480px; margin:0 auto;"></div>
    </article><!-- grid_wrap end -->

    </dd>
    <!-- #########hird Party Order(s) List ######### -->
    <dt class="click_add_on"><a href="#">Third Party Order(s)</a></dt>
    <dd>
    
    <ul class="right_btns">
        <li><p class="btn_grid"><a href="#">EXCEL UP</a></p></li>
        <li><p class="btn_grid"><a href="#">EXCEL DW</a></p></li>
        <li><p class="btn_grid"><a href="#">DEL</a></p></li>
        <li><p class="btn_grid"><a href="#">INS</a></p></li>
        <li><p class="btn_grid"><a href="#">ADD</a></p></li>
    </ul>
    
    <article class="grid_wrap"><!-- grid_wrap start -->
        <div id="thirdparty_grid_wrap" style="width:100%; height:480px; margin:0 auto;"></div>
    </article><!-- grid_wrap end -->

    </dd>
</dl>
</article><!-- acodi_wrap end -->
</section><!-- pop_body end -->
</div><!-- popup_wrap end -->
</body>
</html>