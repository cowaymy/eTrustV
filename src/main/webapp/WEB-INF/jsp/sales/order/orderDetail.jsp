<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<head>
<script type="text/javaScript" language="javascript">

    //AUIGrid 생성 후 반환 ID
    var custInfoGridID;
    
    $(document).ready(function(){
        //AUIGrid 그리드를 생성합니다.
        createAUIGrid();
        
        fn_selectOrderSameRentalGroupOrderList();
    });
    
    function createAUIGrid() {
        
        //AUIGrid 칼럼 설정
        var columnLayout = [{
                dataField   : "salesOrdNo", headerText  : "Order No",
                width       : 100,          editable    : false,
                style       : 'left_style'
            }, {
                dataField   : "code",       headerText  : "Status",
                width       : 100,          editable    : false,
                style       : 'left_style'
            }, {
                dataField   : "code1",      headerText  : "App Type",
                width       : 100,          editable        : false,
                style       : 'left_style'
            }, {
                dataField   : "salesDt",    headerText  : "Order Date",
                width       : 120,          editable    : false,
                style       : 'left_style'
            }, {
                dataField   : "name",       headerText  : "Customer Name",
                width       : 250,          editable    : false,
                style       : 'left_style'
            }, {
                dataField   : "nric",       headerText  : "NRIC/Company No",
                width       : 150,          editable    : false,
                style       : 'left_style'
            }, {
                dataField   : "salesOrdId", visible     : false //salesOrderId
            }];

        //그리드 속성 설정
        var gridPros = {
            usePaging           : true,         //페이징 사용
            pageRowCount        : 20,           //한 화면에 출력되는 행 개수 20(기본값:20)            
            editable            : false,            
            fixedColumnCount    : 0,            
            showStateColumn     : true,             
            displayTreeOpen     : false,            
            selectionMode       : "singleRow",  //"multipleCells",            
            headerHeight        : 30,       
            useGroupingPanel    : false,        //그룹핑 패널 사용
            skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
            wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
            showRowNumColumn    : true,         //줄번호 칼럼 렌더러 출력    
            noDataMessage       : "No order found.",
            groupingMessage     : "Here groupping"
        };
        
        custInfoGridID = GridCommon.createAUIGrid("grid_customerInfo_wrap", columnLayout, "", gridPros);
    }
    
    // 리스트 조회.
    function fn_selectOrderSameRentalGroupOrderList() {        
        Common.ajax("GET", "/sales/order/selectSameRentalGrpOrderJsonList.do", $("#searchForm").serialize(), function(result) {
            AUIGrid.setGridData(custInfoGridID, result);
        });
    }
    
    function chgTab(num) {
        if(num == 3) {
        	AUIGrid.resize(custInfoGridID, 900, 450);
        };	
    }
</script>
</head>
<body>

<div id="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Order View</h1>
<ul class="right_opt">
	<li><p class="btn_blue2"><a href="#">Order Ledger(1)</a></p></li>
	<li><p class="btn_blue2"><a href="#">Order Ledger(2)</a></p></li>
	<li><p class="btn_blue2"><a href="#" onClick="javascript:self.close();">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<form id="searchForm" name="searchForm" action="#" method="post">

    <input id="salesOrderId" name="salesOrderId" type="hidden" value="${orderDetail.basicInfo.ordId}">

</form>

<section class="tap_wrap"><!-- tap_wrap start -->
<ul class="tap_type1 num4">
	<li><a href="#" class="on">Basic Info</a></li>
	<li><a href="#">HP / Cody</a></li>
	<li><a href="#" onClick="javascript:chgTab(3)">Customer Info</a></li>
	<li><a href="#">Installation Info</a></li>
	<li><a href="#">Mailling Info</a></li>
	<li><a href="#">Payment Channel</a></li>
	<li><a href="#">Membership Info</a></li>
	<li><a href="#">Document Submission</a></li>
	<li><a href="#">Call Log</a></li>
	<li><a href="#">Quarantee Info</a></li>
	<li><a href="#">Payment Listing</a></li>
	<li><a href="#">Last 6 Months Transaction</a></li>
	<li><a href="#">Order Configuration</a></li>
	<li><a href="#">Auto Debit Result</a></li>
	<li><a href="#">Relief Certificate</a></li>
	<li><a href="#">Discount</a></li>
</ul>

<article class="tap_area"><!-- tap_area start -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:130px" />
	<col style="width:*" />
	<col style="width:130px" />
	<col style="width:*" />
	<col style="width:110px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row">Progress Status</th>
	<td><span>${orderDetail.logView.prgrs}</span></td>
	<th scope="row">Agreement No</th>
	<td><span>${orderDetail.agreementView.govAgItmBatchNo}</span></td>
	<th scope="row">Agreement Expiry</th>
	<td><span>${orderDetail.agreementView.govAgEndDt}</span></td>
</tr>
<tr>
	<th scope="row">Order No</th>
	<td>${orderDetail.basicInfo.ordNo}</td>
	<th scope="row">Order Date</th>
	<td>${orderDetail.basicInfo.ordDt}</td>
	<th scope="row">Status</th>
	<td>${orderDetail.basicInfo.ordStusName}</td>
</tr>
<tr>
	<th scope="row">Application Type</th>
	<td>${orderDetail.basicInfo.appTypeName}</td>
	<th scope="row">Reference No</th>
	<td>${orderDetail.basicInfo.refNo}</td>
	<th scope="row">Key At(By)</th>
	<td>${orderDetail.basicInfo.ordCrtUserId}</td>
</tr>
<tr>
	<th scope="row">Product</th>
	<td>${orderDetail.basicInfo.stockDesc}</td>
	<th scope="row">PO Number</th>
	<td>${orderDetail.basicInfo.ordPoNo}</td>
	<th scope="row">Key-inBranch</th>
	<td>(${orderDetail.basicInfo.keyinBrnchCode} )${orderDetail.basicInfo.keyinBrnchName}</td>
</tr>
<tr>
	<th scope="row">PV</th>
	<td>${orderDetail.basicInfo.ordPv}</td>
	<th scope="row">Price/RPF</th>
	<td>${orderDetail.basicInfo.ordAmt}</td>
	<th scope="row">Rental Fees</th>
	<td>${orderDetail.basicInfo.mthRentalFees}</td>
</tr>
<tr>
	<th scope="row">Installment Duration</th>
	<td>${orderDetail.basicInfo.installmentDuration}</td>
	<th scope="row">PV Month(Month/Year)</th>
	<td>${orderDetail.basicInfo.ordPvMonth}/${orderDetail.basicInfo.ordPvYear}</td>
	<th scope="row">Rental Status</th>
	<td>${orderDetail.basicInfo.rentalStatus}</td>
</tr>
<tr>
	<th scope="row">Promotion</th>
	<td colspan="3"><c:if test="${orderDetail.basicInfo.ordPromoId > 0}">(${orderDetail.basicInfo.ordPromoCode}) ${orderDetail.basicInfo.ordPromoDesc}</c:if></td>
	<th scope="row">Related No</th>
	<td>${orderDetail.basicInfo.ordPromoRelatedNo}</td>
</tr>
<tr>
	<th scope="row">Serial Number</th>
	<td>${orderDetail.installationInfo.lastInstallSerialNo}</td>
	<th scope="row">Sirim Number</th>
	<td>${orderDetail.installationInfo.lastInstallSirimNo}</td>
	<th scope="row">Update At(By)</th>
	<td>${orderDetail.basicInfo.updDt}( ${orderDetail.basicInfo.updUserId})</td>
</tr>
<tr>
	<th scope="row">Obligation Period</th>
	<td colspan="5">${orderDetail.basicInfo.obligtYear}</td>
</tr>
<tr>
	<th scope="row">Remark</th>
	<td colspan="5">${orderDetail.basicInfo.ordRem}</td>
</tr>
<tr>
	<th scope="row">CCP Feedback Code</th>
	<td colspan="5">${orderDetail.ccpFeedbackCode.code}-${orderDetail.ccpFeedbackCode.resnDesc}</td>
</tr>
<tr>
	<th scope="row">CCP Remark</th>
	<td colspan="5">${orderDetail.ccpInfo.ccpRem}</td>
</tr>
</tbody>
</table><!-- table end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<section class="divine2"><!-- divine3 start -->

<article>
<h3>Salesman Info</h3>

<input id="salesmanMemTypeID" name="salesmanMemTypeID" type="hidden" value="${orderDetail.salesmanInfo.memType}">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:140px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th rowspan="3" scope="row">Order Made By</th>
	<td><span class="txt_box">${orderDetail.salesmanInfo.orgCode} (Organization Code)<i>(${orderDetail.salesmanInfo.memCode1}) ${orderDetail.salesmanInfo.name1} - ${orderDetail.salesmanInfo.telMobile1}</i></span></td>
</tr>
<tr>
	<td><span class="txt_box">${orderDetail.salesmanInfo.grpCode} (Group Code)<i>(${orderDetail.salesmanInfo.memCode2}) ${orderDetail.salesmanInfo.name2} - ${orderDetail.salesmanInfo.telMobile2}</i></span></td>
</tr>
<tr>
	<td><span class="txt_box">${orderDetail.salesmanInfo.deptCode} (Department Code)<i>(${orderDetail.salesmanInfo.memCode3}) ${orderDetail.salesmanInfo.name3} - ${orderDetail.salesmanInfo.telMobile3}</i></span></td>
</tr>
<tr>
	<th scope="row">Salesman Code</th>
	<td><span>${orderDetail.salesmanInfo.memCode}</span></td>
</tr>
<tr>
	<th scope="row">Salesman Name</th>
	<td><span>${orderDetail.salesmanInfo.name}</span></td>
</tr>
<tr>
	<th scope="row">Salesman NRIC</th>
	<td><span>${orderDetail.salesmanInfo.nric}</span></td>
</tr>
<tr>
	<th scope="row">Mobile No</th>
	<td><span>${orderDetail.salesmanInfo.telMobile}</span></td>
</tr>
<tr>
	<th scope="row">Office No</th>
	<td><span>${orderDetail.salesmanInfo.telOffice}</span></td>
</tr>
<tr>
	<th scope="row">House No</th>
	<td><span>${orderDetail.salesmanInfo.telHuse}</span></td>
</tr>
</tbody>
</table><!-- table end -->
</article>

<article>
<h3>Cody Info</h3>

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:140px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th rowspan="3" scope="row">Service By</th>
	<td><span class="txt_box">${orderDetail.codyInfo.orgCode} (Organization Code)<i>(${orderDetail.codyInfo.memCode1}) ${orderDetail.codyInfo.name1} - ${orderDetail.codyInfo.telMobile1}</i></span></td>
</tr>
<tr>
	<td><span class="txt_box">${orderDetail.codyInfo.grpCode} (Group Code)<i>(${orderDetail.codyInfo.memCode2}) ${orderDetail.codyInfo.name2} - ${orderDetail.codyInfo.telMobile2}</i></span></td>
</tr>
<tr>
	<td><span class="txt_box">${orderDetail.codyInfo.deptCode} (Department Code)<i>(${orderDetail.codyInfo.memCode3}) ${orderDetail.codyInfo.name3} - ${orderDetail.codyInfo.telMobile3}</i></span></td>
</tr>
<tr>
	<th scope="row">Cody Code</th>
	<td><span>${orderDetail.salesmanInfo.memCode}</span></td>
</tr>
<tr>
	<th scope="row">Cody Name</th>
	<td><span>${orderDetail.salesmanInfo.name}</span></td>
</tr>
<tr>
	<th scope="row">Cody NRIC</th>
	<td><span>${orderDetail.salesmanInfo.nric}</span></td>
</tr>
<tr>
	<th scope="row">Mobile No</th>
	<td><span>${orderDetail.salesmanInfo.telMobile}</span></td>
</tr>
<tr>
	<th scope="row">Office No</th>
	<td><span>${orderDetail.salesmanInfo.telOffice}</span></td>
</tr>
<tr>
	<th scope="row">House No</th>
	<td><span>${orderDetail.salesmanInfo.telHuse}</span></td>
</tr>
</tbody>
</table><!-- table end -->
</article>

</section><!-- divine2 start -->


</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:140px" />
	<col style="width:*" />
	<col style="width:160px" />
	<col style="width:*" />
	<col style="width:140px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row">Customer ID</th>
	<td><span>${orderDetail.basicInfo.custId}</span></td>
	<th scope="row">Customer Name</th>
	<td colspan="3"><span>${orderDetail.basicInfo.custName}</span></td>
</tr>
<tr>
	<th scope="row">Customer Type</th>
	<td><span>${orderDetail.basicInfo.custType}</span></td>
	<th scope="row">NRIC/Company No</th>
	<td><span>${orderDetail.basicInfo.custNric}</span></td>
	<th scope="row">JomPay Ref-1</th>
	<td><span>${orderDetail.basicInfo.jomPayRef}</span></td>
</tr>
<tr>
	<th scope="row">Nationality</th>
	<td><span>${orderDetail.basicInfo.custNation}</span></td>
	<th scope="row">Gender</th>
	<td><span>${orderDetail.basicInfo.custGender}</span></td>
	<th scope="row">Race</th>
	<td><span>${orderDetail.basicInfo.custRace}</span></td>
</tr>
<tr>
	<th scope="row">VA Number</th>
	<td><span>${orderDetail.basicInfo.custVaNo}</span></td>
	<th scope="row">Passport Exprire</th>
	<td><span>${orderDetail.basicInfo.custPassportExpr}</span></td>
	<th scope="row">Visa Exprire</th>
	<td><span>${orderDetail.basicInfo.custVisaExpr}</span></td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h2>Same Rental Group Order(s)</h2>
</aside><!-- title_line end -->

<section class="search_result"><!-- search_result start -->

<ul class="right_btns">
	<li><p class="btn_grid"><a href="#">EDIT</a></p></li>
	<li><p class="btn_grid"><a href="#">NEW</a></p></li>
	<li><p class="btn_grid"><a href="#">EXCEL UP</a></p></li>
	<li><p class="btn_grid"><a href="#">EXCEL DW</a></p></li>
	<li><p class="btn_grid"><a href="#">DEL</a></p></li>
	<li><p class="btn_grid"><a href="#">INS</a></p></li>
	<li><p class="btn_grid"><a href="#">ADD</a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="grid_customerInfo_wrap" style="width:100%; height:480px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:140px" />
	<col style="width:*" />
	<col style="width:160px" />
	<col style="width:*" />
	<col style="width:140px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th rowspan="3" scope="row">Installation Address</th>
	<td colspan="3"><span>${orderDetail.installationInfo.instAddr1}</span></td>
	<th scope="row">Country</th>
	<td><span>${orderDetail.installationInfo.instCnty}</span></td>
</tr>
<tr>
	<td colspan="3"><span>${orderDetail.installationInfo.instAddr2}</span></td>
	<th scope="row">State</th>
	<td><span>${orderDetail.installationInfo.instState}</span></td>
</tr>
<tr>
	<td colspan="3"><span>${orderDetail.installationInfo.instAddr3}</span></td>
	<th scope="row">Area</th>
	<td><span>${orderDetail.installationInfo.instArea}</span></td>
</tr>
<tr>
	<th scope="row">Prefer Install Date</th>
	<td><span>${orderDetail.installationInfo.preferInstDt}</span></td>
	<th scope="row">Prefer Install Time</th>
	<td><span>${orderDetail.installationInfo.preferInstTm}</span></td>
	<th scope="row">Postcode</th>
	<td><span>${orderDetail.installationInfo.instPostCode}</span></td>
</tr>
<tr>
	<th scope="row">Instruction</th>
	<td colspan="5"><span>${orderDetail.installationInfo.instct}</span></td>
</tr>
<tr>
	<th scope="row">DSC Verification Remark</th>
	<td colspan="5"><span>${orderDetail.installationInfo.vrifyRem}</span></td>
</tr>
<tr>
	<th scope="row">DSC Branch</th>
	<td colspan="3"><span>(${orderDetail.installationInfo.dscCode} )${orderDetail.installationInfo.dscName}</span></td>
	<th scope="row">Installed Date</th>
	<td><span>text</span></td>
</tr>
<tr>
	<th scope="row">CT Code</th>
	<td><span>text</span></td>
	<th scope="row">CT Name</th>
	<td colspan="3"><span>text</span></td>
</tr>
</tbody>
</table><!-- table end -->

<table class="type1 mt40"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:140px" />
	<col style="width:*" />
	<col style="width:160px" />
	<col style="width:*" />
	<col style="width:140px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row">Contact Name</th>
	<td colspan="3"><span>text</span></td>
	<th scope="row">Gender</th>
	<td><span>text</span></td>
</tr>
<tr>
	<th scope="row">Contact NRIC</th>
	<td><span>text</span></td>
	<th scope="row">Email</th>
	<td><span>text</span></td>
	<th scope="row">Fax No</th>
	<td><span>text</span></td>
</tr>
<tr>
	<th scope="row">Mobile No</th>
	<td><span>text</span></td>
	<th scope="row">Office No</th>
	<td><span>text</span></td>
	<th scope="row">House No</th>
	<td><span>text</span></td>
</tr>
<tr>
	<th scope="row">Post</th>
	<td><span>text</span></td>
	<th scope="row">Department</th>
	<td><span>text</span></td>
	<th scope="row"></th>
	<td></td>
</tr>
</tbody>
</table><!-- table end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:140px" />
	<col style="width:*" />
	<col style="width:100px" />
	<col style="width:*" />
	<col style="width:120px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th rowspan="3" scope="row">Mailing Address</th>
	<td colspan="3"><span>text</span></td>
	<th scope="row">Country</th>
	<td><span>text</span></td>
</tr>
<tr>
	<td colspan="3"><span>text</span></td>
	<th scope="row">State</th>
	<td><span>text</span></td>
</tr>
<tr>
	<td colspan="3"><span>text</span></td>
	<th scope="row">Area</th>
	<td><span>text</span></td>
</tr>
<tr>
	<th scope="row">Billing Group</th>
	<td><span>text</span></td>
	<th scope="row">Billing Type</th>
	<td>
	<label><input type="checkbox" /><span>SMS</span></label>
	<label><input type="checkbox" /><span>Post</span></label>
	<label><input type="checkbox" /><span>E-statement</span></label>
	</td>
	<th scope="row">Postcode</th>
	<td><span>text</span></td>
</tr>
</tbody>
</table><!-- table end -->

<table class="type1 mt40"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:140px" />
	<col style="width:*" />
	<col style="width:130px" />
	<col style="width:*" />
	<col style="width:110px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row">Contact Name</th>
	<td colspan="3"><span>text</span></td>
	<th scope="row">Gender</th>
	<td><span>text</span></td>
</tr>
<tr>
	<th scope="row">Contact NRIC</th>
	<td><span>text</span></td>
	<th scope="row">Email</th>
	<td><span>text</span></td>
	<th scope="row">Fax No</th>
	<td><span>text</span></td>
</tr>
<tr>
	<th scope="row">Mobile No</th>
	<td><span>text</span></td>
	<th scope="row">Office No</th>
	<td><span>text</span></td>
	<th scope="row">House No</th>
	<td><span>text</span></td>
</tr>
<tr>
	<th scope="row">Post</th>
	<td><span>text</span></td>
	<th scope="row">Departiment</th>
	<td><span>text</span></td>
	<th scope="row"></th>
	<td></td>
</tr>
</tbody>
</table><!-- table end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:150px" />
	<col style="width:*" />
	<col style="width:140px" />
	<col style="width:*" />
	<col style="width:150px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row">Rental Paymode</th>
	<td><span>text</span></td>
	<th scope="row">Direct Debit Mode</th>
	<td><span>text</span></td>
	<th scope="row">Auto Debit Limit</th>
	<td><span>text</span></td>
</tr>
<tr>
	<th scope="row">Issue Bank</th>
	<td><span>text</span></td>
	<th scope="row">Card Type</th>
	<td><span>text</span></td>
	<th scope="row">Claim Bill Date</th>
	<td><span>text</span></td>
</tr>
<tr>
	<th scope="row">Credit Card No</th>
	<td><span>text</span></td>
	<th scope="row">Name On Card</th>
	<td><span>text</span></td>
	<th scope="row">Expiry Date</th>
	<td><span>text</span></td>
</tr>
<tr>
	<th scope="row">Bank Account No</th>
	<td><span>text</span></td>
	<th scope="row">Account Name</th>
	<td><span>text</span></td>
	<th scope="row">Issure NRIC</th>
	<td><span>text</span></td>
</tr>
<tr>
	<th scope="row">Apply Date</th>
	<td><span>text</span></td>
	<th scope="row">Submit Date</th>
	<td><span>text</span></td>
	<th scope="row">Start Date</th>
	<td><span>text</span></td>
</tr>
<tr>
	<th scope="row">Reject Date</th>
	<td><span>text</span></td>
	<th scope="row">Reject Code</th>
	<td><span>text</span></td>
	<th scope="row">Payment Team</th>
	<td><span>text</span></td>
</tr>
<tr>
	<th scope="row">Pay By Third Party</th>
	<td><span>text</span></td>
	<th scope="row">Third Party ID</th>
	<td><span>text</span></td>
	<th scope="row">Third Party Type</th>
	<td><span>text</span></td>
</tr>
<tr>
	<th scope="row">Third Party Name</th>
	<td colspan="3"><span>text</span></td>
	<th scope="row">Third Party NRIC</th>
	<td><span>text</span></td>
</tr>
</tbody>
</table><!-- table end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<ul class="right_btns">
	<li><p class="btn_grid"><a href="#">EXCEL UP</a></p></li>
	<li><p class="btn_grid"><a href="#">EXCEL DW</a></p></li>
	<li><p class="btn_grid"><a href="#">DEL</a></p></li>
	<li><p class="btn_grid"><a href="#">INS</a></p></li>
	<li><p class="btn_grid"><a href="#">ADD</a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
그리드 영역
</article><!-- grid_wrap end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<ul class="right_btns">
	<li><p class="btn_grid"><a href="#">EXCEL UP</a></p></li>
	<li><p class="btn_grid"><a href="#">EXCEL DW</a></p></li>
	<li><p class="btn_grid"><a href="#">DEL</a></p></li>
	<li><p class="btn_grid"><a href="#">INS</a></p></li>
	<li><p class="btn_grid"><a href="#">ADD</a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
그리드 영역
</article><!-- grid_wrap end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<ul class="right_btns">
	<li><p class="btn_grid"><a href="#">EXCEL UP</a></p></li>
	<li><p class="btn_grid"><a href="#">EXCEL DW</a></p></li>
	<li><p class="btn_grid"><a href="#">DEL</a></p></li>
	<li><p class="btn_grid"><a href="#">INS</a></p></li>
	<li><p class="btn_grid"><a href="#">ADD</a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
그리드 영역
</article><!-- grid_wrap end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:140px" />
	<col style="width:*" />
	<col style="width:150px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row">Guarantee Status</th>
	<td colspan="3"><span>text</span></td>
</tr>
<tr>
	<th scope="row">HP Code</th>
	<td><span>text</span></td>
	<th scope="row">HP Name(NRIC)</th>
	<td><span>text</span></td>
</tr>
<tr>
	<th scope="row">HM Code</th>
	<td><span>text</span></td>
	<th scope="row">HM Name(NRIC)</th>
	<td><span>text</span></td>
</tr>
<tr>
	<th scope="row">SM Code</th>
	<td><span>text</span></td>
	<th scope="row">SM Name(NRIC)</th>
	<td><span>text</span></td>
</tr>
<tr>
	<th scope="row">GM Code</th>
	<td><span>text</span></td>
	<th scope="row">GM Name(NRIC)</th>
	<td><span>text</span></td>
</tr>
</tbody>
</table><!-- table end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<ul class="right_btns">
	<li><p class="btn_grid"><a href="#">EXCEL UP</a></p></li>
	<li><p class="btn_grid"><a href="#">EXCEL DW</a></p></li>
	<li><p class="btn_grid"><a href="#">DEL</a></p></li>
	<li><p class="btn_grid"><a href="#">INS</a></p></li>
	<li><p class="btn_grid"><a href="#">ADD</a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
그리드 영역
</article><!-- grid_wrap end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<ul class="right_btns">
	<li><p class="btn_grid"><a href="#">EXCEL UP</a></p></li>
	<li><p class="btn_grid"><a href="#">EXCEL DW</a></p></li>
	<li><p class="btn_grid"><a href="#">DEL</a></p></li>
	<li><p class="btn_grid"><a href="#">INS</a></p></li>
	<li><p class="btn_grid"><a href="#">ADD</a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
그리드 영역
</article><!-- grid_wrap end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:130px" />
	<col style="width:*" />
	<col style="width:130px" />
	<col style="width:*" />
	<col style="width:120px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row">BS Availability</th>
	<td><span>text</span></td>
	<th scope="row">BS Frequency</th>
	<td><span>text</span></td>
	<th scope="row">Last BS Date</th>
	<td><span>text</span></td>
</tr>
<tr>
	<th scope="row">BS Cody Code</th>
	<td colspan="5"><span>text</span></td>
</tr>
<tr>
	<th scope="row">Config Remark</th>
	<td colspan="5"><span>text</span></td>
</tr>
<tr>
	<th scope="row">Happy Call Service</th>
	<td colspan="5">
	<label><input type="checkbox" /><span>Installation Type</span></label>
	<label><input type="checkbox" /><span>BS Type</span></label>
	<label><input type="checkbox" /><span>AS Type</span></label>
	</td>
</tr>
<tr>
	<th scope="row">Prefer BS Week</th>
	<td colspan="5">
	<label><input type="radio" name="week" /><span>None</span></label>
	<label><input type="radio" name="week" /><span>Week1</span></label>
	<label><input type="radio" name="week" /><span>Week2</span></label>
	<label><input type="radio" name="week" /><span>Week3</span></label>
	<label><input type="radio" name="week" /><span>Week4</span></label>
	</td>
</tr>
</tbody>
</table><!-- table end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<ul class="right_btns">
	<li><p class="btn_grid"><a href="#">EXCEL UP</a></p></li>
	<li><p class="btn_grid"><a href="#">EXCEL DW</a></p></li>
	<li><p class="btn_grid"><a href="#">DEL</a></p></li>
	<li><p class="btn_grid"><a href="#">INS</a></p></li>
	<li><p class="btn_grid"><a href="#">ADD</a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
그리드 영역
</article><!-- grid_wrap end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:150px" />
	<col style="width:*" />
	<col style="width:150px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row">Reference No</th>
	<td><span>text</span></td>
	<th scope="row">Certificate Date</th>
	<td><span>text</span></td>
</tr>
<tr>
	<th scope="row">GST Registration No</th>
	<td colspan="3"><span>text</span></td>
</tr>
<tr>
	<th scope="row">Remark</th>
	<td colspan="3"><span>text</span></td>
</tr>
</tbody>
</table><!-- table end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<ul class="right_btns">
	<li><p class="btn_grid"><a href="#">EXCEL UP</a></p></li>
	<li><p class="btn_grid"><a href="#">EXCEL DW</a></p></li>
	<li><p class="btn_grid"><a href="#">DEL</a></p></li>
	<li><p class="btn_grid"><a href="#">INS</a></p></li>
	<li><p class="btn_grid"><a href="#">ADD</a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
그리드 영역
</article><!-- grid_wrap end -->

</article><!-- tap_area end -->

</section><!-- tap_wrap end -->

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->

</body>
</html>