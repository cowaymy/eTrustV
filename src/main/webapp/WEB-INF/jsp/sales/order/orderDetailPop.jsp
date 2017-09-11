<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<head>
<script type="text/javaScript" language="javascript">

    //AUIGrid 생성 후 반환 ID
    var custInfoGridID;
    var memInfoGridID;
    var docGridID;
    var callLogGridID;
    var payGridID;
    var transGridID;
    var autoDebitGridID;
    var discountGridID;
    
    $(document).ready(function(){
        //AUIGrid 그리드를 생성합니다.
        createAUIGrid();
        createAUIGrid2();
        createAUIGrid3();
        createAUIGrid4();
        createAUIGrid5();
        createAUIGrid6();
        createAUIGrid7();
        createAUIGrid8();
        
        fn_selectOrderSameRentalGroupOrderList();
        fn_selectMembershipInfoList();
        fn_selectDocumentList();
        fn_selectCallLogList();
        fn_selectPaymentList();
        fn_selectTransList();
        fn_selectAutoDebitList();
        fn_selectDiscountList();
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
            pageRowCount        : 10,           //한 화면에 출력되는 행 개수 20(기본값:20)            
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
        
        custInfoGridID = GridCommon.createAUIGrid("grid_custInfo_wrap", columnLayout, "", gridPros);
    }
    
    function createAUIGrid2() {
        
        //AUIGrid 칼럼 설정
        var columnLayout = [{
                dataField   : "mbrshNo",        headerText  : "Membership<br>No",
                width       : 120,              editable    : false,
                style       : 'left_style'
            }, {
                dataField   : "mbrshBillNo",    headerText  : "Bill No",
                width       : 100,              editable        : false,
                style       : 'left_style'
            }, {
                dataField   : "mbrshCrtDt",     headerText  : "Date",
                width       : 70,               editable    : false,
                style       : 'left_style'
            }, {
                dataField   : "mbrshStusCode",  headerText  : "Status",
                width       : 70,               editable    : false,
                style       : 'left_style'
            }, {
                dataField   : "pacName",        headerText  : "Package",
                style       : 'left_style'
            }, {
                dataField   : "mbrshStartDt",   headerText  : "Start",
                width       : 70,               editable    : false,
                style       : 'left_style'
            }, {
                dataField   : "mbrshExprDt",    headerText  : "End",
                width       : 70,               editable    : false,
                style       : 'left_style'
            }, {
                dataField   : "mbrshDur",       headerText  : "Duration<br>(month)",
                width       : 100,              editable    : false,
                style       : 'left_style'
            }, {
                dataField   : "salesOrdId", visible     : false //salesOrderId
            }];

        //그리드 속성 설정
        var gridPros = {
            usePaging           : true,         //페이징 사용
            pageRowCount        : 10,           //한 화면에 출력되는 행 개수 20(기본값:20)            
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
        
        memInfoGridID = GridCommon.createAUIGrid("grid_memInfo_wrap", columnLayout, "", gridPros);
    }
    
    function createAUIGrid3() {
        
        //AUIGrid 칼럼 설정
        var columnLayout = [{
                dataField   : "codeName",   headerText  : "Type of Document",
                                            editable    : false,
                style       : 'left_style'
            }, {
                dataField   : "docSubDt",   headerText  : "Submit Date",
                width       : 120,          editable        : false,
                style       : 'left_style'
            }, {
                dataField   : "docCopyQty", headerText  : "Quantity",
                width       : 120,           editable    : false,
                style       : 'left_style'
            }];

        //그리드 속성 설정
        var gridPros = {
            usePaging           : true,         //페이징 사용
            pageRowCount        : 10,           //한 화면에 출력되는 행 개수 20(기본값:20)            
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
        
        docGridID = GridCommon.createAUIGrid("grid_doc_wrap", columnLayout, "", gridPros);
    }
    
    function createAUIGrid4() {
        
        //AUIGrid 칼럼 설정
        var columnLayout = [{
                dataField   : "rownum",             headerText  : "No",
                width       : 60,                  editable    : false,
                style       : 'left_style'
            }, {
                dataField   : "codeName",           headerText  : "Type",
                width       : 120,                  editable    : false,
                style       : 'left_style'
            }, {
                dataField   : "resnDesc",           headerText  : "Feedback",
                width       : 120,                  editable    : false,
                style       : 'left_style'
            }, {
                dataField   : "stusName",           headerText  : "Action",
                width       : 120,                  editable    : false,
                style       : 'left_style'
            }, {
                dataField   : "callRosAmt",         headerText  : "Amount",
                width       : 70,                   editable    : false,
                style       : 'left_style'
            }, {
                dataField   : "callRem",            headerText  : "Remark",
                width       : 250,                  editable    : false,
                style       : 'left_style'
            }, {
                dataField   : "rosCallerUserName",  headerText  : "Caller",
                width       : 120,                  editable    : false,
                style       : 'left_style'
            }, {
                dataField   : "callCrtUserName",    headerText  : "Creator",
                width       : 80,                  editable    : false,
                style       : 'left_style'
            }, {
                dataField   : "callCrtDt",          headerText  : "Create Date",
                width       : 100,                  editable    : false,
                style       : 'left_style'
            }];

        //그리드 속성 설정
        var gridPros = {
            usePaging           : true,         //페이징 사용
            pageRowCount        : 10,           //한 화면에 출력되는 행 개수 20(기본값:20)            
            editable            : false,            
            fixedColumnCount    : 0,            
            showStateColumn     : false,             
            displayTreeOpen     : false,            
            selectionMode       : "singleRow",  //"multipleCells",            
            headerHeight        : 30,       
            rowHeight           : 150,   
            wordWrap            : true, 
            useGroupingPanel    : false,        //그룹핑 패널 사용
            skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
            wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
            showRowNumColumn    : false,         //줄번호 칼럼 렌더러 출력    
            noDataMessage       : "No order found.",
            groupingMessage     : "Here groupping"
        };
        
        callLogGridID = GridCommon.createAUIGrid("grid_callLog_wrap", columnLayout, "", gridPros);
    }
    
    function createAUIGrid5() {
        
        //AUIGrid 칼럼 설정
        var columnLayout = [{
                dataField   : "orNo",           headerText  : "Receipt No",
                width       : 120,              editable    : false,
                style       : 'left_style'
            }, {
                dataField   : "revReceiptNo",   headerText  : "Reverse For",
                width       : 120,              editable    : false,
                style       : 'left_style'
            }, {
                dataField   : "payData",        headerText  : "Payment Date",
                width       : 120,              editable    : false,
                style       : 'left_style'
            }, {
                dataField   : "codeDesc",       headerText  : "Payment Type",
                width       : 150,              editable    : false,
                style       : 'left_style'
            }, {
                dataField   : "accCode",        headerText  : "Debtor Acc",
                width       : 100,              editable    : false,
                style       : 'left_style'
            }, {
                dataField   : "code",           headerText  : "Key-In Branch<br>(Code)",
                width       : 120,              editable    : false,
                style       : 'left_style'
            }, {
                dataField   : "name1",          headerText  : "Key-In Branch<br>(Name)",
                width       : 120,              editable    : false,
                style       : 'left_style'
            }, {
                dataField   : "totAmt",         headerText  : "Total Amount",
                width       : 100,              editable    : false,
                style       : 'left_style'
            }, {
                dataField   : "userName",       headerText  : "Creator",
                width       : 80,               editable    : false,
                style       : 'left_style'
            }];

        //그리드 속성 설정
        var gridPros = {
            usePaging           : true,         //페이징 사용
            pageRowCount        : 10,           //한 화면에 출력되는 행 개수 20(기본값:20)            
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
        
        payGridID = GridCommon.createAUIGrid("grid_pay_wrap", columnLayout, "", gridPros);
    }
    
    function createAUIGrid6() {
        
        //AUIGrid 칼럼 설정
        var columnLayout = [{
	            dataField   : "colType",      headerText  : "colType",
	            width       : 120,            editable    : false,
	            style       : 'left_style'
	        }, {
	            dataField   : "colCurMth",    headerText  : "colCurMth",
	            width       : 120,            editable    : false,
	            style       : 'left_style'
	        }, {
                dataField   : "colPrev1Mth",  headerText  : "colPrev1Mth",
                width       : 120,            editable    : false,
                style       : 'left_style'
            }, {
                dataField   : "colPrev2Mth",  headerText  : "colPrev2Mth",
                width       : 120,            editable    : false,
                style       : 'left_style'
            }, {
                dataField   : "colPrev3Mth",  headerText  : "colPrev3Mth",
                width       : 120,            editable    : false,
                style       : 'left_style'
            }, {
                dataField   : "colPrev4Mth",  headerText  : "colPrev4Mth",
                width       : 120,            editable    : false,
                style       : 'left_style'
            }, {
                dataField   : "colPrev5Mth", headerText  : "colPrev5Mth",
                width       : 120,            editable    : false,
                style       : 'left_style'
            }];

        //그리드 속성 설정
        var gridPros = {
            usePaging           : false,         //페이징 사용
            pageRowCount        : 10,           //한 화면에 출력되는 행 개수 20(기본값:20)            
            editable            : false,            
            fixedColumnCount    : 0,            
            showStateColumn     : true,             
            displayTreeOpen     : false,            
            selectionMode       : "singleRow",  //"multipleCells",
            showHeader          : false,
          //headerHeight        : 30,       
            useGroupingPanel    : false,        //그룹핑 패널 사용
            skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
            wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
            showRowNumColumn    : false,        //줄번호 칼럼 렌더러 출력    
            noDataMessage       : "No order found.",
            groupingMessage     : "Here groupping"
        };
        
        transGridID = GridCommon.createAUIGrid("grid_trans_wrap", columnLayout, "", gridPros);
    }
    
    function createAUIGrid7() {
        
        //AUIGrid 칼럼 설정
        var columnLayout = [{
                dataField   : "crtDtMm",      headerText  : "Month",
                width       : 120,            editable    : false,
                style       : 'left_style'
            }, {
                dataField   : "batchMode",    headerText  : "Mode",
                width       : 120,            editable    : false,
                style       : 'left_style'
            }, {
                dataField   : "code",         headerText  : "Bank",
                                              editable    : false,
                style       : 'left_style'
            }, {
                dataField   : "crtDtDd",      headerText  : "Date Deduct",
                width       : 150,            editable    : false,
                style       : 'left_style'
            }, {
                dataField   : "bankDtlAmt",   headerText  : "Amount",
                width       : 100,            editable    : false,
                style       : 'left_style'
            }, {
                dataField   : "isApproveStr", headerText  : "Success ?",
                width       : 120,            editable    : false,
                style       : 'left_style'
            }];

        //그리드 속성 설정
        var gridPros = {
            usePaging           : true,         //페이징 사용
            pageRowCount        : 10,           //한 화면에 출력되는 행 개수 20(기본값:20)            
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
        
        autoDebitGridID = GridCommon.createAUIGrid("grid_autoDebit_wrap", columnLayout, "", gridPros);
    }
    
    function createAUIGrid8() {
        
        //AUIGrid 칼럼 설정
        var columnLayout = [{
                dataField   : "salesOrdNo",      headerText  : "Order No",
                width       : 100,               editable    : false,
                style       : 'left_style'
            }, {
                dataField   : "codeDesc",        headerText  : "DiscountType",
                width       : 180,               editable    : false,
                style       : 'left_style'
            }, {
                dataField   : "dcAmtPerInstlmt", headerText  : "AmtPerInstalment",
                width       : 120,               editable    : false,
                style       : 'left_style'
            }, {
                dataField   : "dcStartInstlmt",  headerText  : "Start Installment",
                width       : 120,               editable    : false,
                style       : 'left_style'
            }, {
                dataField   : "dcEndInstlmt",    headerText  : "End Installment",
                width       : 120,               editable    : false,
                style       : 'left_style'
            }, {
                dataField   : "rem",             headerText  : "Remark",
                                                 editable    : false,
                style       : 'left_style'
            }];

        //그리드 속성 설정
        var gridPros = {
            usePaging           : true,         //페이징 사용
            pageRowCount        : 10,           //한 화면에 출력되는 행 개수 20(기본값:20)            
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
        
        discountGridID = GridCommon.createAUIGrid("grid_discount_wrap", columnLayout, "", gridPros);
    }
    
    // 리스트 조회.
    function fn_selectOrderSameRentalGroupOrderList() {        
        Common.ajax("GET", "/sales/order/selectSameRentalGrpOrderJsonList.do", $("#searchForm").serialize(), function(result) {
            AUIGrid.setGridData(custInfoGridID, result);
        });
    }
    
    // 리스트 조회.
    function fn_selectMembershipInfoList() {        
        Common.ajax("GET", "/sales/order/selectMembershipInfoJsonList.do", $("#searchForm").serialize(), function(result) {
            AUIGrid.setGridData(memInfoGridID, result);
        });
    }
    
    // 리스트 조회.
    function fn_selectDocumentList() {        
        Common.ajax("GET", "/sales/order/selectDocumentJsonList.do", $("#searchForm").serialize(), function(result) {
            AUIGrid.setGridData(docGridID, result);
        });
    }
    
    // 리스트 조회.
    function fn_selectCallLogList() {        
        Common.ajax("GET", "/sales/order/selectCallLogJsonList.do", $("#searchForm").serialize(), function(result) {
            AUIGrid.setGridData(callLogGridID, result);
        });
    }
    
    // 리스트 조회.
    function fn_selectPaymentList() {        
        Common.ajax("GET", "/sales/order/selectPaymentJsonList.do", $("#searchForm").serialize(), function(result) {
            AUIGrid.setGridData(payGridID, result);
        });
    }
    
    // 리스트 조회.
    function fn_selectTransList() {        
        Common.ajax("GET", "/sales/order/selectLast6MonthTransJsonList.do", $("#searchForm").serialize(), function(result) {
            AUIGrid.setGridData(transGridID, result);
        });
    }
    
    // 리스트 조회.
    function fn_selectAutoDebitList() {        
        Common.ajax("GET", "/sales/order/selectAutoDebitJsonList.do", $("#searchForm").serialize(), function(result) {
            AUIGrid.setGridData(autoDebitGridID, result);
        });
    }
    
    // 리스트 조회.
    function fn_selectDiscountList() {        
        Common.ajax("GET", "/sales/order/selectDiscountJsonList.do", $("#searchForm").serialize(), function(result) {
            AUIGrid.setGridData(discountGridID, result);
        });
    }
    
    
    
    function chgTab(tabNm) {
    	switch(tabNm) {
	        case 'custInfo' :
	            AUIGrid.resize(custInfoGridID, 900, 380);
	            break;
            case 'memInfo' :
                AUIGrid.resize(memInfoGridID, 900, 380);
                break;
            case 'docInfo' :
                AUIGrid.resize(docGridID, 900, 380);
                break;
            case 'callLogInfo' :
                AUIGrid.resize(callLogGridID, 900, 380);
                break;
            case 'payInfo' :
                AUIGrid.resize(payGridID, 900, 380);
                break;
            case 'transInfo' :
                AUIGrid.resize(transGridID, 900, 380);
                break;
            case 'autoDebitInfo' :
                AUIGrid.resize(autoDebitGridID, 900, 380);
                break;
            case 'discountInfo' :
                AUIGrid.resize(discountGridID, 900, 380);
                break;
        };
    }
</script>
</head>
<body>

<form id="searchForm" name="searchForm" action="#" method="post">
    <input id="salesOrderId" name="salesOrderId" type="hidden" value="${orderDetail.basicInfo.ordId}">
</form>

<div id="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Order View</h1>
<ul class="right_opt">
	<li><p class="btn_blue2"><a href="#">Order Ledger(1)</a></p></li>
	<li><p class="btn_blue2"><a href="#">Order Ledger(2)</a></p></li>
	<li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<section class="tap_wrap"><!-- tap_wrap start -->
<ul class="tap_type1 num4">
	<li><a href="#" class="on">Basic Info</a></li>
	<li><a href="#">HP / Cody</a></li>
	<li><a href="#" onClick="javascript:chgTab('custInfo');">Customer Info</a></li>
	<li><a href="#">Installation Info</a></li>
	<li><a href="#">Mailling Info</a></li>
<c:if test="${orderDetail.basicInfo.appTypeCode == 'REN'}">
	<li><a href="#">Payment Channel</a></li>
</c:if>
	<li><a href="#" onClick="javascript:chgTab('memInfo');">Membership Info</a></li>
	<li><a href="#" onClick="javascript:chgTab('docInfo');">Document Submission</a></li>
	<li><a href="#" onClick="javascript:chgTab('callLogInfo');">Call Log</a></li>
<c:if test="${orderDetail.basicInfo.appTypeCode == 'REN' && orderDetail.basicInfo.rentChkId == '122'}">
	<li><a href="#">Quarantee Info</a></li>
</c:if>
	<li><a href="#" onClick="javascript:chgTab('payInfo');">Payment Listing</a></li>
	<li><a href="#" onClick="javascript:chgTab('transInfo');">Last 6 Months Transaction</a></li>
	<li><a href="#">Order Configuration</a></li>
	<li><a href="#" onClick="javascript:chgTab('autoDebitInfo');">Auto Debit Result</a></li>
	<li><a href="#">Relief Certificate</a></li>
	<li><a href="#" onClick="javascript:chgTab('discountInfo');">Discount</a></li>
</ul>
<!------------------------------------------------------------------------------
    Basic Info
------------------------------------------------------------------------------->
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
<!------------------------------------------------------------------------------
    HP / Cody
------------------------------------------------------------------------------->
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
<!------------------------------------------------------------------------------
    Customer Info
------------------------------------------------------------------------------->
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
<div id="grid_custInfo_wrap" style="width:100%; height:380px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</article><!-- tap_area end -->
<!------------------------------------------------------------------------------
    Installation Info
------------------------------------------------------------------------------->
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
	<td><span>${orderDetail.installationInfo.firstInstallDt}</span></td>
</tr>
<tr>
	<th scope="row">CT Code</th>
	<td><span>${orderDetail.installationInfo.lastInstallCtCode}</span></td>
	<th scope="row">CT Name</th>
	<td colspan="3"><span>${orderDetail.installationInfo.lastInstallCtName}</span></td>
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
	<td colspan="3"><span>${orderDetail.installationInfo.instCntName}</span></td>
	<th scope="row">Gender</th>
	<td><span>${orderDetail.installationInfo.instCntGender}</span></td>
</tr>
<tr>
	<th scope="row">Contact NRIC</th>
	<td><span>${orderDetail.installationInfo.instCntNric}</span></td>
	<th scope="row">Email</th>
	<td><span>${orderDetail.installationInfo.instCntEmail}</span></td>
	<th scope="row">Fax No</th>
	<td><span>${orderDetail.installationInfo.instCntTelF}</span></td>
</tr>
<tr>
	<th scope="row">Mobile No</th>
	<td><span>${orderDetail.installationInfo.instCntTelM}</span></td>
	<th scope="row">Office No</th>
	<td><span>${orderDetail.installationInfo.instCntTelO}</span></td>
	<th scope="row">House No</th>
	<td><span>${orderDetail.installationInfo.instCntTelR}</span></td>
</tr>
<tr>
	<th scope="row">Post</th>
	<td><span>${orderDetail.installationInfo.instCntPost}</span></td>
	<th scope="row">Department</th>
	<td><span>${orderDetail.installationInfo.instCntDept}</span></td>
	<th scope="row"></th>
	<td></td>
</tr>
</tbody>
</table><!-- table end -->

</article><!-- tap_area end -->
<!------------------------------------------------------------------------------
    Mailling Info
------------------------------------------------------------------------------->
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
	<td colspan="3"><span>${orderDetail.mailingInfo.mailAdd1}</span></td>
	<th scope="row">Country</th>
	<td><span>${orderDetail.mailingInfo.mailCnty}</span></td>
</tr>
<tr>
	<td colspan="3"><span>${orderDetail.mailingInfo.mailAdd2}</span></td>
	<th scope="row">State</th>
	<td><span>${orderDetail.mailingInfo.mailState}</span></td>
</tr>
<tr>
	<td colspan="3"><span>${orderDetail.mailingInfo.mailAdd3}</span></td>
	<th scope="row">Area</th>
	<td><span>${orderDetail.mailingInfo.mailArea}</span></td>
</tr>
<tr>
	<th scope="row">Billing Group</th>
	<td><span>${orderDetail.mailingInfo.billGrpNo}</span></td>
	<th scope="row">Billing Type</th>
	<td>
	<label>
  <c:choose>
    <c:when test="${orderDetail.mailingInfo.billSms != 0}">
	   <input type="checkbox" onClick="return false" checked/>
	   <span class="txt_box">SMS<i>${orderDetail.mailingInfo.mailCntTelM}</i></span>
	</c:when>
	<c:otherwise>
       <input type="checkbox" onClick="return false"/>
       <span>SMS</span>
	</c:otherwise>
  </c:choose>
	</label>
	<label>
  <c:choose>
    <c:when test="${orderDetail.mailingInfo.billPost != 0}">
       <input type="checkbox" onClick="return false" checked/>
       <span class="txt_box">Post<i>${orderDetail.mailingInfo.fullAddress}</i></span>
    </c:when>
    <c:otherwise>
       <input type="checkbox" onClick="return false"/>
       <span>Post</span>
    </c:otherwise>
  </c:choose>
	</label>
	<label>
  <c:choose>
    <c:when test="${orderDetail.mailingInfo.billState != 0}">
       <input type="checkbox" onClick="return false" checked/>
       <span class="txt_box">E-statement><i>${orderDetail.mailingInfo.billStateEmail}</i></span>
    </c:when>
    <c:otherwise>
       <input type="checkbox" onClick="return false"/>
       <span>E-statement</span>
    </c:otherwise>
  </c:choose>
	 </label>
	</td>
	<th scope="row">Postcode</th>
	<td><span>${orderDetail.mailingInfo.mailPostCode}</span></td>
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
	<td colspan="3"><span>${orderDetail.mailingInfo.mailCntName}</span></td>
	<th scope="row">Gender</th>
	<td><span>${orderDetail.mailingInfo.mailCntGender}</span></td>
</tr>
<tr>
	<th scope="row">Contact NRIC</th>
	<td><span>${orderDetail.mailingInfo.mailCntNric}</span></td>
	<th scope="row">Email</th>
	<td><span>${orderDetail.mailingInfo.mailCntEmail}</span></td>
	<th scope="row">Fax No</th>
	<td><span>${orderDetail.mailingInfo.mailCntTelF}</span></td>
</tr>
<tr>
	<th scope="row">Mobile No</th>
	<td><span>${orderDetail.mailingInfo.mailCntTelM}</span></td>
	<th scope="row">Office No</th>
	<td><span>${orderDetail.mailingInfo.mailCntTelO}</span></td>
	<th scope="row">House No</th>
	<td><span>${orderDetail.mailingInfo.mailCntTelR}</span></td>
</tr>
<tr>
	<th scope="row">Post</th>
	<td><span>${orderDetail.mailingInfo.mailCntPost}</span></td>
	<th scope="row">Departiment</th>
	<td><span>${orderDetail.mailingInfo.mailCntDept}</span></td>
	<th scope="row"></th>
	<td></td>
</tr>
</tbody>
</table><!-- table end -->

</article><!-- tap_area end -->

<!------------------------------------------------------------------------------
    Payment Channel
------------------------------------------------------------------------------->
<c:if test="${orderDetail.basicInfo.appTypeCode == 'REN'}">
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
	<td><span>${orderDetail.rentPaySetInf.rentPayModeDesc}</span></td>
	<th scope="row">Direct Debit Mode</th>
	<td><span>${orderDetail.rentPaySetInf.clmDdMode}</span></td>
	<th scope="row">Auto Debit Limit</th>
	<td><span>${orderDetail.rentPaySetInf.clmLimit}</span></td>
</tr>
<tr>
	<th scope="row">Issue Bank</th>
	<td><span>${orderDetail.rentPaySetInf.rentPayIssBank}</span></span></td>
	<th scope="row">Card Type</th>
	<td><span>${orderDetail.rentPaySetInf.cardType}</span></td>
	<th scope="row">Claim Bill Date</th>
	<td><span></span></td>
</tr>
<tr>
	<th scope="row">Credit Card No</th>
	<td><span>${orderDetail.rentPaySetInf.rentPayCrcNo}</span></td>
	<th scope="row">Name On Card</th>
	<td><span>${orderDetail.rentPaySetInf.rentPayCrOwner}</span></td>
	<th scope="row">Expiry Date</th>
	<td><span>${orderDetail.rentPaySetInf.rentPayCrcExpr}</span></td>
</tr>
<tr>
	<th scope="row">Bank Account No</th>
	<td><span>${orderDetail.rentPaySetInf.rentPayAccNo}</span></td>
	<th scope="row">Account Name</th>
	<td><span>${orderDetail.rentPaySetInf.rentPayAccOwner}</span></td>
	<th scope="row">Issure NRIC</th>
	<td><span>${orderDetail.rentPaySetInf.issuNric}</span></td>
</tr>
<tr>
	<th scope="row">Apply Date</th>
	<td><span>${orderDetail.rentPaySetInf.rentPayApplyDt}</span></td>
	<th scope="row">Submit Date</th>
	<td><span>${orderDetail.rentPaySetInf.rentPaySubmitDt}</span></td>
	<th scope="row">Start Date</th>
	<td><span>${orderDetail.rentPaySetInf.rentPayStartDt}</span></td>
</tr>
<tr>
	<th scope="row">Reject Date</th>
	<td><span>${orderDetail.rentPaySetInf.rentPayRejctDt}</span></td>
	<th scope="row">Reject Code</th>
	<td><span>${orderDetail.rentPaySetInf.rentPayRejct}</span></td>
	<th scope="row">Payment Team</th>
	<td><span>${orderDetail.rentPaySetInf.payTrm} month(s)</span></td>
</tr>
<tr>
	<th scope="row">Pay By Third Party</th>
	<td><span>${orderDetail.rentPaySetInf.is3party}</span></td>
	<th scope="row">Third Party ID</th>
	<td><span>${orderDetail.thirdPartyInfo.customerid}</span></td>
	<th scope="row">Third Party Type</th>
	<td><span>${orderDetail.thirdPartyInfo.c7}</span></td>
</tr>
<tr>
	<th scope="row">Third Party Name</th>
	<td colspan="3"><span>${orderDetail.thirdPartyInfo.name}</span></td>
	<th scope="row">Third Party NRIC</th>
	<td><span>${orderDetail.thirdPartyInfo.nric}</span></td>
</tr>
</tbody>
</table><!-- table end -->

</article><!-- tap_area end -->
</c:if>

<!------------------------------------------------------------------------------
    Membership Info
------------------------------------------------------------------------------->
<article class="tap_area"><!-- tap_area start -->

<ul class="right_btns">
	<li><p class="btn_grid"><a href="#">EXCEL UP</a></p></li>
	<li><p class="btn_grid"><a href="#">EXCEL DW</a></p></li>
	<li><p class="btn_grid"><a href="#">DEL</a></p></li>
	<li><p class="btn_grid"><a href="#">INS</a></p></li>
	<li><p class="btn_grid"><a href="#">ADD</a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="grid_memInfo_wrap" style="width:100%; height:380px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</article><!-- tap_area end -->

<!------------------------------------------------------------------------------
    Document Submission
------------------------------------------------------------------------------->
<article class="tap_area"><!-- tap_area start -->

<ul class="right_btns">
	<li><p class="btn_grid"><a href="#">EXCEL UP</a></p></li>
	<li><p class="btn_grid"><a href="#">EXCEL DW</a></p></li>
	<li><p class="btn_grid"><a href="#">DEL</a></p></li>
	<li><p class="btn_grid"><a href="#">INS</a></p></li>
	<li><p class="btn_grid"><a href="#">ADD</a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="grid_doc_wrap" style="width:100%; height:380px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</article><!-- tap_area end -->

<!------------------------------------------------------------------------------
    Call Log
------------------------------------------------------------------------------->
<article class="tap_area"><!-- tap_area start -->

<ul class="right_btns">
	<li><p class="btn_grid"><a href="#">EXCEL UP</a></p></li>
	<li><p class="btn_grid"><a href="#">EXCEL DW</a></p></li>
	<li><p class="btn_grid"><a href="#">DEL</a></p></li>
	<li><p class="btn_grid"><a href="#">INS</a></p></li>
	<li><p class="btn_grid"><a href="#">ADD</a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="grid_callLog_wrap" style="width:100%; height:380px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</article><!-- tap_area end -->

<!------------------------------------------------------------------------------
    Quarantee Info
------------------------------------------------------------------------------->
<c:if test="${orderDetail.basicInfo.appTypeCode == 'REN' && orderDetail.basicInfo.rentChkId == '122'}">
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
	<td colspan="3"><span>${orderDetail.grntnfo.grntStatus}</span></td>
</tr>
<tr>
	<th scope="row">HP Code</th>
	<td><span>${orderDetail.grntnfo.grntHPCode}</span></td>
	<th scope="row">HP Name(NRIC)</th>
	<td><span>${orderDetail.grntnfo.grntHPName}</span></td>
</tr>
<tr>
	<th scope="row">HM Code</th>
	<td><span>${orderDetail.grntnfo.grntHMCode}</span></td>
	<th scope="row">HM Name(NRIC)</th>
	<td><span>${orderDetail.grntnfo.grntHMName}</span></td>
</tr>
<tr>
	<th scope="row">SM Code</th>
	<td><span>${orderDetail.grntnfo.grntSMCode}</span></td>
	<th scope="row">SM Name(NRIC)</th>
	<td><span>${orderDetail.grntnfo.grntSMName}</span></td>
</tr>
<tr>
	<th scope="row">GM Code</th>
	<td><span>${orderDetail.grntnfo.grntGMCode}</span></td>
	<th scope="row">GM Name(NRIC)</th>
	<td><span>${orderDetail.grntnfo.grntGMName}</span></td>
</tr>
</tbody>
</table><!-- table end -->

</article><!-- tap_area end -->
</c:if>

<!------------------------------------------------------------------------------
    Payment Listing
------------------------------------------------------------------------------->
<article class="tap_area"><!-- tap_area start -->

<ul class="right_btns">
	<li><p class="btn_grid"><a href="#">EXCEL UP</a></p></li>
	<li><p class="btn_grid"><a href="#">EXCEL DW</a></p></li>
	<li><p class="btn_grid"><a href="#">DEL</a></p></li>
	<li><p class="btn_grid"><a href="#">INS</a></p></li>
	<li><p class="btn_grid"><a href="#">ADD</a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="grid_pay_wrap" style="width:100%; height:380px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</article><!-- tap_area end -->

<!------------------------------------------------------------------------------
    Last 6 Months Transaction
------------------------------------------------------------------------------->
<article class="tap_area"><!-- tap_area start -->

<ul class="right_btns">
	<li><p class="btn_grid"><a href="#">EXCEL UP</a></p></li>
	<li><p class="btn_grid"><a href="#">EXCEL DW</a></p></li>
	<li><p class="btn_grid"><a href="#">DEL</a></p></li>
	<li><p class="btn_grid"><a href="#">INS</a></p></li>
	<li><p class="btn_grid"><a href="#">ADD</a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="grid_trans_wrap" style="width:100%; height:380px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</article><!-- tap_area end -->

<!------------------------------------------------------------------------------
    Order Configuration
------------------------------------------------------------------------------->
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
	<td><span>${orderDetail.orderCfgInfo.configBsGen}</span></td>
	<th scope="row">BS Frequency</th>
	<td><span>${orderDetail.orderCfgInfo.srvMemFreq} month(s)</span></td>
	<th scope="row">Last BS Date</th>
	<td><span>${orderDetail.orderCfgInfo.setlDt}</span></td>
</tr>
<tr>
	<th scope="row">BS Cody Code</th>
	<td colspan="5"><span>${orderDetail.orderCfgInfo.memCode} - ${orderDetail.orderCfgInfo.name}</span></td>
</tr>
<tr>
	<th scope="row">Config Remark</th>
	<td colspan="5"><span>${orderDetail.orderCfgInfo.configBsRem}</span></td>
</tr>
<tr>
	<th scope="row">Happy Call Service</th>
	<td colspan="5">
	<label>
  <c:choose>
    <c:when test="${orderDetail.orderCfgInfo.configSettIns == 1}">
       <input type="checkbox" onClick="return false" checked/>
    </c:when>
    <c:otherwise>
       <input type="checkbox" onClick="return false"/>
    </c:otherwise>
  </c:choose>
	<span>Installation Type</span></label>
	<label>
  <c:choose>
    <c:when test="${orderDetail.orderCfgInfo.configSettBs == 1}">
       <input type="checkbox" onClick="return false" checked/>
    </c:when>
    <c:otherwise>
       <input type="checkbox" onClick="return false"/>
    </c:otherwise>
  </c:choose>
	<span>BS Type</span></label>
	<label>
  <c:choose>
    <c:when test="${orderDetail.orderCfgInfo.configSettAs == 1}">
       <input type="checkbox" onClick="return false" checked/>
    </c:when>
    <c:otherwise>
       <input type="checkbox" onClick="return false"/>
    </c:otherwise>
  </c:choose>
	<span>AS Type</span></label>
	</td>
</tr>
<tr>
	<th scope="row">Prefer BS Week</th>
	<td colspan="5">
	<label><input type="radio" name="week" <c:if test="${orderDetail.orderCfgInfo.configBsWeek == 0 || orderDetail.orderCfgInfo.configBsWeek > 4}">checked</c:if> disabled/><span>None</span></label>
	<label><input type="radio" name="week" <c:if test="${orderDetail.orderCfgInfo.configBsWeek == 1}">checked</c:if> disabled/><span>Week1</span></label>
	<label><input type="radio" name="week" <c:if test="${orderDetail.orderCfgInfo.configBsWeek == 2}">checked</c:if> disabled/><span>Week2</span></label>
	<label><input type="radio" name="week" <c:if test="${orderDetail.orderCfgInfo.configBsWeek == 3}">checked</c:if> disabled/><span>Week3</span></label>
	<label><input type="radio" name="week" <c:if test="${orderDetail.orderCfgInfo.configBsWeek == 4}">checked</c:if> disabled/><span>Week4</span></label>
	</td>
</tr>
</tbody>
</table><!-- table end -->

</article><!-- tap_area end -->

<!------------------------------------------------------------------------------
    Auto Debit Result
------------------------------------------------------------------------------->
<article class="tap_area"><!-- tap_area start -->

<ul class="right_btns">
	<li><p class="btn_grid"><a href="#">EXCEL UP</a></p></li>
	<li><p class="btn_grid"><a href="#">EXCEL DW</a></p></li>
	<li><p class="btn_grid"><a href="#">DEL</a></p></li>
	<li><p class="btn_grid"><a href="#">INS</a></p></li>
	<li><p class="btn_grid"><a href="#">ADD</a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="grid_autoDebit_wrap" style="width:100%; height:380px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</article><!-- tap_area end -->

<!------------------------------------------------------------------------------
    Relief Certificate
------------------------------------------------------------------------------->
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
	<td><span>${orderDetail.gstCertInfo.eurcRefNo}</span></td>
	<th scope="row">Certificate Date</th>
	<td><span>${orderDetail.gstCertInfo.eurcRefDt}</span></td>
</tr>
<tr>
	<th scope="row">GST Registration No</th>
	<td colspan="3"><span>${orderDetail.gstCertInfo.eurcCustRgsNo}</span></td>
</tr>
<tr>
	<th scope="row">Remark</th>
	<td colspan="3"><span>${orderDetail.gstCertInfo.eurcRem}</span></td>
</tr>
</tbody>
</table><!-- table end -->

</article><!-- tap_area end -->

<!------------------------------------------------------------------------------
    Discount
------------------------------------------------------------------------------->
<article class="tap_area"><!-- tap_area start -->

<ul class="right_btns">
	<li><p class="btn_grid"><a href="#">EXCEL UP</a></p></li>
	<li><p class="btn_grid"><a href="#">EXCEL DW</a></p></li>
	<li><p class="btn_grid"><a href="#">DEL</a></p></li>
	<li><p class="btn_grid"><a href="#">INS</a></p></li>
	<li><p class="btn_grid"><a href="#">ADD</a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="grid_discount_wrap" style="width:100%; height:380px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</article><!-- tap_area end -->

</section><!-- tap_wrap end -->

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->

</body>
</html>