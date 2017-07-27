<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javascript">
    // 중앙 정렬
    fn_moveCenter();
    //AUIGrid 생성 후 반환 ID
    var addrGridID; // address list
    var contactGridID; // contact list
    var bankAccountGirdID; // bank account list
    var creditCardGridID; // credit card list
    var ownOrderGridID; // own order list
    var thirdPartyGridID; // third party list
    
    $(document).ready(function(){
        //AUIGrid 그리드를 생성합니다. (address, contact , bank, creditcard, ownorder, thirdparty )
        addrGridID = GridCommon.createAUIGrid("#address_grid_wrap", addrColumnLayout,'', gridPros);  // address list
        contactGridID = GridCommon.createAUIGrid("#contact_grid_wrap", contactColumnLayout,'',gridPros); // contact list
        bankAccountGirdID = GridCommon.createAUIGrid("#bank_grid_wrap", bankColumnLayout,'',gridPros); // bank account list
        creditCardGridID = GridCommon.createAUIGrid("#creditcard_grid_wrap", creditCardColumnLayout,'',gridPros); // credit card list
        ownOrderGridID = GridCommon.createAUIGrid("#ownorder_grid_wrap", ownOrderColumnLayout,'',gridPros); // own order list
        thirdPartyGridID = GridCommon.createAUIGrid("#thirdparty_grid_wrap", thirdPartyColumnLayout,'',gridPros);// third party list 
        
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
    
    //AUIGrid 칼럼 설정
    //데이터 형태는 다음과 같은 형태임,
    //[{"id":"#Cust0","date":"2014-09-03","name":"Han","country":"USA","product":"Apple","color":"Red","price":746400}, { .....} ];
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
                          Common.popupWin("detailForm", "/sales/customer/selectCustomerAddrDetailView.do", option);
                    }
             }
    }];
    
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
                        Common.popupWin("detailForm", "/sales/customer/selectCustomerContactDetailView.do", option);
                    }
             }
         }];
    
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
                       Common.popupWin("detailForm", "/sales/customer/selectCustomerBankDetailView.do", option);
                   }
            }
        }]; 
    
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
                       Common.popupWin("detailForm", "/sales/customer/selectCustomerCreditCardDetailView.do", option);
                   }
            }
    }];
    
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
                   /* value 에 해당 키값 가져가야함 */
                   alert(rowIndex +"번째 "+item.name + " 상세보기 클릭");
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
                   /* value 에 해당 키값 가져가야함 */
                   alert(rowIndex +"번째 "+item.name + " 상세보기 클릭");
               }
        }
    }];
    
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
                     /* value 에 해당 키값 가져가야함 */
                     alert(rowIndex +"번째 "+item.name + " 상세보기 클릭");
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
            
            editable : true,
            
            fixedColumnCount : 1,
            
            showStateColumn : false, //true 
            
            displayTreeOpen : false, //true
            
            selectionMode : "multipleCells",
            
            headerHeight : 30,
            
            // 그룹핑 패널 사용
            useGroupingPanel : false, //true
            
            // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
            skipReadonlyColumns : true,
            
            // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
            wrapSelectionMove : false, //false
            
            // 줄번호 칼럼 렌더러 출력
            showRowNumColumn : false,
            
            groupingMessage : "Here groupping"
        };
    // Popup Option     
    var option = {
            winName : "popup",
            isDuplicate : false, // 계속 팝업을 띄울지 여부.
            fullscreen : "no", // 전체 창. (yes/no)(default : no)
            location : "no", // 주소창이 활성화. (yes/no)(default : yes)
            menubar : "no", // 메뉴바 visible. (yes/no)(default : yes)
            titlebar : "yes", // 타이틀바. (yes/no)(default : yes)
            toolbar : "no", // 툴바. (yes/no)(default : yes)
            resizable : "yes", // 창 사이즈 변경. (yes/no)(default : yes)
            scrollbars : "yes", // 스크롤바. (yes/no)(default : yes)
            width : "1200px", // 창 가로 크기
            height : "330px" // 창 세로 크기
        };
    
    //resize func (tab click)
    function fn_resizefunc(){
        window.resizeTo(1200, 681);
        //resize original
        $( window ).resize(function() {
            window.resizeTo(1200, 680);
        });
    }
    
    function fn_moveCenter() {
           var sw = screen.width;
           var sh = screen.height;
           var cw = document.body.clientWidth;
           var ch = document.body.clientHeight;
           var top  = sh / 2 - ch / 2 - 100;
           var left = sw / 2 - cw / 2;
           window.moveTo(left, top);
    }

</script>
<!-- Pop up Form -->
<form id="detailForm">
    <input type="hidden"  id="getparam" name="getparam"/>
</form>
<!-- get param Form  -->
<form id="getParamForm" method="get">
    <input type="hidden" name="custAddrId" value="${custAddrId}"/>
    <input type="hidden" name="custId" value="${custId}"/>
</form>

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
        <td><span>${result.custId}</span></td>
        <th scope="row">Custormer Type</th>
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
        <th scope="row">Custormer Name</th>
        <td colspan="3">${result.name}</td>
        <th scope="row">Create By</th>
        <td>
            <c:if test="${result.crtUserId ne 0}">
                ${result.crtUserId}
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
        <th scope="row">nationality</th>
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
        <td>${result.pasSportExpr}</td>
        <th scope="row">Visa Expire</th>
        <td>${result.visaExpr}</td>
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
         <td>
            <span>
                    ${addresinfo.add1}&nbsp;${addresinfo.add2}&nbsp;${addresinfo.add3}&nbsp;
                    ${addresinfo.postCode}&nbsp;${addresinfo.areaName}&nbsp;${addresinfo.name1}&nbsp;${addresinfo.name2}
            </span>
          </td>
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
    <dt class="click_add_on"><a href="#" onclick="javascript: fn_resizefunc()">Customer Address List</a></dt>
    <dd>
    <article class="grid_wrap"><!-- grid_wrap start -->
        <div id="address_grid_wrap" style="width:100%; height:480px; margin:0 auto;"></div>
    </article><!-- grid_wrap end -->
    </dd>
    <!-- ######### Customer Contact List ######### -->
    <dt class="click_add_on"><a href="#" onclick="javascript: fn_resizefunc()">Customer Contact List</a></dt>
    <dd>
    <article class="grid_wrap"><!-- grid_wrap start -->
        <div id="contact_grid_wrap" style="width:100%; height:480px; margin:0 auto;"></div>
    </article><!-- grid_wrap end -->
    </dd>
    <!-- ######### Customer Bank Account List ######### -->
    <dt class="click_add_on"><a href="#" onclick="javascript: fn_resizefunc()">Customer Bank Account List</a></dt>
    <dd>
    <article class="grid_wrap"><!-- grid_wrap start -->
        <div id="bank_grid_wrap" style="width:100%; height:480px; margin:0 auto;"></div>
    </article><!-- grid_wrap end -->
    </dd>
    <!-- ######### Customer Credit Card List ######### -->
    <dt class="click_add_on"><a href="#" onclick="javascript: fn_resizefunc()">Customer Credit Card List</a></dt>
    <dd> 
    <article class="grid_wrap"><!-- grid_wrap start -->
        <div id="creditcard_grid_wrap" style="width:100%; height:480px; margin:0 auto;"></div>
    </article><!-- grid_wrap end -->
    </dd>
    <!-- ######### Own Order(s) List ######### -->
    <dt class="click_add_on"><a href="#" onclick="javascript: fn_resizefunc()">Own Order(s)</a></dt>
    <dd>
    <article class="grid_wrap"><!-- grid_wrap start -->
        <div id="ownorder_grid_wrap" style="width:100%; height:480px; margin:0 auto;"></div>
    </article><!-- grid_wrap end -->
    </dd>
    <!-- #########hird Party Order(s) List ######### -->
    <dt class="click_add_on"><a href="#" onclick="javascript: fn_resizefunc()">Third Party Order(s)</a></dt>
    <dd>
    <article class="grid_wrap"><!-- grid_wrap start -->
        <div id="thirdparty_grid_wrap" style="width:100%; height:480px; margin:0 auto;"></div>
    </article><!-- grid_wrap end -->
    </dd>
</dl>
</article><!-- acodi_wrap end -->
</section><!-- pop_body end -->
