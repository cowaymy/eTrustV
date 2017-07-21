<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javascript">

// AUIGrid 생성 후 반환 ID
var addrGridID;
var contactGridID;

$(document).ready(function(){
    
    // AUIGrid 그리드를 생성합니다. (address, contact , )
    addrGridID = GridCommon.createAUIGrid("#address_grid_wrap", addrColumnLayout, gridPros);
    contactGridID = GridCommon.createAUIGrid("#contact_grid_wrap", contactColumnLayout, gridPros);
    //Call Ajax
    fn_getCustomerAddressAjax(); // address
    fn_getCustomerContactAjax(); // contact
    //
    AUIGrid.setSelectionMode(addrGridID, "singleRow");
});



// ajax View 조회.
	// address Ajax
	function fn_getCustomerAddressAjax() {        
	    Common.ajax("GET", "/sales/customer/selectCustomerAddressJsonList",$("#searchForm").serialize(), function(result) {
	       
	        console.log("성공.");
	        console.log("address data : " + result);
	        AUIGrid.setGridData(addrGridID, result);
	    });
	}
	// contact Ajax
	function fn_getCustomerContactAjax(){
		Common.ajax("GET", "/sales/customer/selectCustomerContactJsonList",$("#searchForm").serialize(), function(result) {
	           
            console.log("성공.");
            console.log("Customer data : " + result);
            AUIGrid.setGridData(contactGridID, result);
        });
	}

//AUIGrid 칼럼 설정
//데이터 형태는 다음과 같은 형태임,
//[{"id":"#Cust0","date":"2014-09-03","name":"Han","country":"USA","product":"Apple","color":"Red","price":746400}, { .....} ];
	// Address Column
	var addrColumnLayout = [ {
		  dataField : "c1",
		  headerText : "Address",
		  width : 100
		 }, {
		  dataField : "c2",
		  headerText : "Address",
		  width : 100
		 }, {
		  dataField : "c3",
		  headerText : "Address",
		  width : 100
	}];
	
	// Contact Column
	var contactColumnLayout= [ {
        dataField : "c5",
        headerText : "Name",
        width : 100
       }, {
        dataField : "c9",
        headerText : "c9",
        width : 100
       }, {
        dataField : "c13",
        headerText : "c13",
        width : 100
	}];

//그리드 속성 설정
var gridPros = {
        
        // 페이징 사용       
        usePaging : true,
        
        // 한 화면에 출력되는 행 개수 10(기본값:10)
        pageRowCount : 10,
        
        editable : true,
        
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
        <td>${result.c1}</td>
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
        <td>${result.c8}</td>
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
        <td colspan="5">${result.reamrk}</td>
    </tr>
    </tbody>
    </table><!-- table end -->
    </article><!-- tap_area end -->

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
                <td></td>
            </tr>
    </c:if>
    
    </tbody>
    </table><!-- table end -->
    </article><!-- tap_area end -->

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
            <c:if test="${contactinfo.c6 eq 'M'}">
                Male
            </c:if>
            <c:if test="${contactinfo.c6 eq 'F'}">
                Female
            </c:if>
        </td>
    </tr>
    <tr>
        <th scope="row">NRIC</th>
        <td>${contactinfo.c10}</td>
        <th scope="row">DOB</th>
        <td>${contactinfo.c4}</td>
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
        <div id="address_grid_wrap" style="width:100%; height:480px; margin:0 auto;"></div>
    </article><!-- grid_wrap end -->

    </dd>
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
        <div id="cust_bank_grid_wrap" style="width:100%; height:480px; margin:0 auto;"></div>
    </article><!-- grid_wrap end -->

    </dd>
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
        <div id="cust_card_grid_wrap" style="width:100%; height:480px; margin:0 auto;"></div>
    </article><!-- grid_wrap end -->

    </dd>
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
        <div id="own_order_grid_wrap" style="width:100%; height:480px; margin:0 auto;"></div>
    </article><!-- grid_wrap end -->

    </dd>
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
        <div id="third_party_grid_wrap" style="width:100%; height:480px; margin:0 auto;"></div>
    </article><!-- grid_wrap end -->

    </dd>
</dl>
</article><!-- acodi_wrap end -->

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->
</body>
</html>