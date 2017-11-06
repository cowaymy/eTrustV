<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<style type="text/css">
.my-custom-up div{
    color:#FF0000;
}

/* 커스텀 행 스타일 */
.my-row-style {
    background:#EFEFEF;
    font-weight:bold;
    color:#22741C;
}
</style>
<script type="text/javaScript">

var targetRenMstGridID;
var targetRenDetGridID;
var targetOutMstGridID;
var targetSrvcMstGridID;
var targetSrvcDetGridID;

//AUIGrid 칼럼 설정 : targetRenMstGridID
var targetRenMstColumnLayout = [
    
    { dataField:"custBillId" ,headerText:"Billing Group" ,editable : false , width : 100},
    { dataField:"salesOrdId" ,headerText:"Order ID" ,editable : false , width : 100, visible : false },
    { dataField:"salesOrdNo" ,headerText:"Order No" ,editable : false , width : 100 },
    { dataField:"rpf" ,headerText:"RPF" ,editable : false , width : 100 , dataType : "numeric", formatString : "#,##0.##"},      
    { dataField:"rpfPaid" ,headerText:"RPF Paid" ,editable : false , width : 100 , dataType : "numeric", formatString : "#,##0.##"},      
    { dataField:"mthRentAmt" ,headerText:"Monthly RF" ,editable : false , width : 100 , dataType : "numeric", formatString : "#,##0.##"},      
    { dataField:"balance" ,headerText:"Balance" ,editable : false , width : 100 , dataType : "numeric", formatString : "#,##0.##"},      
    { dataField:"unBilledAmount" ,headerText:"UnBill" ,editable : false , width : 100 , dataType : "numeric", formatString : "#,##0.##"},  
    { dataField:"lastPayment" ,headerText:"Last Payment" ,editable : false , width : 120 , dataType : "date", formatString : "yyyy-mm-dd"},
    { dataField:"custNm" ,headerText:"Customer Name" ,editable : false , width : 250 }
];

//AUIGrid 칼럼 설정 : targetRenDetGridID
var targetRenDetColumnLayout = [
    
    { dataField:"billGrpId" ,headerText:"Bill Group ID" ,editable : false , width : 120, visible : false },
    { dataField:"billId" ,headerText:"Bill ID" ,editable : false , width : 100, visible : false },
    { dataField:"billNo" ,headerText:"Bill No" ,editable : false , width : 150 },
    { dataField:"ordId" ,headerText:"Order ID" ,editable : false , width : 100 , visible : false },  
    { dataField:"ordNo" ,headerText:"Order No" ,editable : false , width : 100 },      
    { dataField:"billTypeNm" ,headerText:"Bill Type" ,editable : false , width : 180 },      
    { dataField:"installment" ,headerText:"Installment" ,editable : false , width : 100 },      
    { dataField:"billAmt" ,headerText:"Amount" ,editable : false , width : 100 , dataType : "numeric", formatString : "#,##0.##"},  
    { dataField:"paidAmt" ,headerText:"Paid" ,editable : false , width : 100 , dataType : "numeric", formatString : "#,##0.##"},
    { dataField:"targetAmt" ,headerText:"Target Amount" ,editable : false , width : 100 , dataType : "numeric", formatString : "#,##0.##"},
    { dataField:"billDt" ,headerText:"Bill Date" ,editable : false , width : 100 , dataType : "date", formatString : "yyyy-mm-dd"},
    { dataField:"stusCodeName" ,headerText:"Bill Status" ,editable : false , width : 100},
    {
        dataField : "btnCheck",
        headerText : " ",
        width: 50,
        renderer : {
            type : "CheckBoxEditRenderer",            
            editable : true, // 체크박스 편집 활성화 여부(기본값 : false)
            checkValue : "1", // true, false 인 경우가 기본
            unCheckValue : "0"            
        }
    }
];

//AUIGrid 칼럼 설정 : targetOutMstGridID
var targetOutMstColumnLayout = [
    { dataField:"salesOrdId" ,headerText:"Order ID" ,editable : false , width : 100, visible : false },
    { dataField:"salesOrdNo" ,headerText:"Order Number" ,editable : false , width : 120 },
    { dataField:"custNm" ,headerText:"Customer Name" ,editable : false , width : 180},      
    { dataField:"productPrice" ,headerText:"Product Price" ,editable : false , width : 100 , dataType : "numeric", formatString : "#,##0.##"},      
    { dataField:"totalPaid" ,headerText:"Paid" ,editable : false , width : 100 , dataType : "numeric", formatString : "#,##0.##"},      
    { dataField:"balance" ,headerText:"Balance<br>(-:Overpaid, +:Outstanding)" ,editable : false , width : 200 , dataType : "numeric", formatString : "#,##0.##"},      
    { dataField:"reverseAmount" ,headerText:"Reversed" ,editable : false , width : 100 },
    { dataField:"lastPayment" ,headerText:"Last Payment" ,editable : false , width : 120 , dataType : "date", formatString : "yyyy-mm-dd"},
    { dataField:"userName" ,headerText:"Creator Name" ,editable : false , width : 200 }
];

//AUIGrid 칼럼 설정 : targetSrvcMstGridID
var targetSrvcMstColumnLayout = [
   { dataField:"srvCntrctId" ,headerText:"SrvContractID" ,editable : false , width : 100, visible : false },

    { dataField:"custBillId" ,headerText:"Billing Group" ,editable : false , width : 100},
    { dataField:"srvCntrctRefNo" ,headerText:"Ref No." ,editable : false , width : 100},
    { dataField:"cntrctRentalStus" ,headerText:"Rental Status" ,editable : false , width : 100 },
    { dataField:"filterCharges" ,headerText:"Filter Charges" ,editable : false , width : 100 , dataType : "numeric", formatString : "#,##0.##"},      
    { dataField:"filterChargesPaid" ,headerText:"Filter Paid" ,editable : false , width : 100 , dataType : "numeric", formatString : "#,##0.##"},      
    { dataField:"penaltyCharges" ,headerText:"Penalty Charges" ,editable : false , width : 100 , dataType : "numeric", formatString : "#,##0.##"},      
    { dataField:"penaltyChargesPaid" ,headerText:"Penalty Paid" ,editable : false , width : 100 , dataType : "numeric", formatString : "#,##0.##"},      
    { dataField:"srvCntrctRental" ,headerText:"Monthly Fees" ,editable : false , width : 100 , dataType : "numeric", formatString : "#,##0.##"},  
    { dataField:"balance" ,headerText:"Balance" ,editable : false , width : 120 , dataType : "numeric", formatString : "#,##0.##"},
    { dataField:"unBillAmount" ,headerText:"Unbill" ,editable : false , width : 120 , dataType : "numeric", formatString : "#,##0.##"},
    { dataField:"lastPayment" ,headerText:"Last Payment" ,editable : false , width : 120 , dataType : "date", formatString : "yyyy-mm-dd"},
    { dataField:"custName" ,headerText:"Customer Name" ,editable : false , width : 250 }
];

//AUIGrid 칼럼 설정 : targetSrvcDetGridID
var targetSrvcDetColumnLayout = [
    
    { dataField:"billGrpId" ,headerText:"Bill Group ID" ,editable : false , width : 120, visible : false },
    { dataField:"billId" ,headerText:"Bill ID" ,editable : false , width : 100, visible : false },
    { dataField:"billNo" ,headerText:"Bill No" ,editable : false , width : 150 },
    { dataField:"ordId" ,headerText:"Order ID" ,editable : false , width : 100 , visible : false },  
    { dataField:"ordNo" ,headerText:"Order No" ,editable : false , width : 100 },      
    { dataField:"billTypeNm" ,headerText:"Bill Type" ,editable : false , width : 180 },      
    { dataField:"installment" ,headerText:"Installment" ,editable : false , width : 100 },      
    { dataField:"billAmt" ,headerText:"Amount" ,editable : false , width : 100 , dataType : "numeric", formatString : "#,##0.##"},  
    { dataField:"paidAmt" ,headerText:"Paid" ,editable : false , width : 100 , dataType : "numeric", formatString : "#,##0.##"},
    { dataField:"targetAmt" ,headerText:"Target Amount" ,editable : false , width : 100 , dataType : "numeric", formatString : "#,##0.##"},
    { dataField:"billDt" ,headerText:"Bill Date" ,editable : false , width : 100 , dataType : "date", formatString : "yyyy-mm-dd"},
    { dataField:"stusCodeName" ,headerText:"Bill Status" ,editable : false , width : 100},
    {
        dataField : "btnCheck",
        headerText : " ",
        width: 50,
        renderer : {
            type : "CheckBoxEditRenderer",            
            editable : true, // 체크박스 편집 활성화 여부(기본값 : false)
            checkValue : "1", // true, false 인 경우가 기본
            unCheckValue : "0"            
        }
    }
];


//Grid Properties 설정 
var gridPros = {                    
  headerHeight : 35,               // 기본 헤더 높이 지정
  pageRowCount : 5,              //페이지당 row 수
  showStateColumn : false      // 상태 칼럼 사용
};

//Grid Properties 설정 
var targetGridPros = {                    
  pageRowCount : 5,              //페이지당 row 수
  showStateColumn : false      // 상태 칼럼 사용
};

$(document).ready(function(){ 
	targetRenMstGridID = GridCommon.createAUIGrid("target_rental_grid_wrap", targetRenMstColumnLayout,null,gridPros);
	targetRenDetGridID = GridCommon.createAUIGrid("target_rentalD_grid_wrap", targetRenDetColumnLayout,null,gridPros);
	targetOutMstGridID = GridCommon.createAUIGrid("target_out_grid_wrap", targetOutMstColumnLayout,null,gridPros);
	targetSrvcMstGridID = GridCommon.createAUIGrid("target_srvc_grid_wrap", targetSrvcMstColumnLayout,null,gridPros);
	targetSrvcDetGridID = GridCommon.createAUIGrid("target_srvcD_grid_wrap", targetSrvcDetColumnLayout,null,gridPros);
	
	//Rental Billing Grid 에서 체크/체크 해제시
	AUIGrid.bind(targetRenDetGridID, "cellClick", function( event ){
		if(event.dataField == "btnCheck"){
			recalculateRentalTotalAmt();
		}
	});
	
	//Rental Order Info 선택시 해당 Billing 정보 bold 로 표시하기
	AUIGrid.bind(targetRenMstGridID, "cellClick", function(event) {
		rentalChangeRowStyleFunction(AUIGrid.getCellValue(targetRenMstGridID, event.rowIndex, "salesOrdNo"));
    }); 	
});

//**************************************************
//**************************************************
// Rental 관련 Script 
//**************************************************
//**************************************************

//Search Order confirm
function fn_rentalConfirm(){
	//Rental Grid Clear 처리
	resetRentalGrid();
	
	var ordNo = $("#rentalOrdNo").val();
    
    if(ordNo != ''){
        //Order Basic 정보 조회
        Common.ajax("GET", "/payment/common/selectOrdIdByNo.do", {"ordNo" : ordNo}, function(result) {        
            if(result != null && result.salesOrdId != ''){
            	$("#rentalOrdId").val(result.salesOrdId);
                $("#rentalOrdNo").val(result.salesOrdNo);
                $("#rentalBillGrpId").val(result.custBillId);
                
            	//Order Info 및 Payment Info 조회
            	fn_rentalOrderInfo();
            }            
        });
    }
}


//Search Order 팝업
function fn_rentalOrderSearchPop(){
	resetRentalGrid();
    Common.popupDiv("/sales/order/orderSearchPop.do", {callPrgm : "RENTAL_PAYMENT", indicator : "SearchOrder"});
}

//Search Order 팝업에서 결과값 받기
function fn_callBackRentalOrderInfo(ordNo, ordId){
    
    //Order Basic 정보 조회
    Common.ajax("GET", "/payment/selectOrderBasicInfoByOrderId.do", {"orderId" : ordId}, function(result) {        
        $("#rentalOrdId").val(result.ordId);
        $("#rentalOrdNo").val(result.ordNo);
        $("#rentalBillGrpId").val(result.custBillId);
        
        //Order Info 및 Payment Info 조회
        fn_rentalOrderInfo();
    });
}

//Rental Order Info 조회
function fn_rentalOrderInfo(){
	var data; 
		
    if($("#isRentalBillGroup").is(":checked")){
    	data = {"billGrpId" : $("#rentalBillGrpId").val() };
    }else{		
		data = {"orderId" : $("#rentalOrdId").val() };
	}
    
	//Rental : Order 정보 조회
	Common.ajax("GET", "/payment/common/selectOrderInfoRental.do", data, function(result) {
		//Rental : Order Info 세팅
		AUIGrid.setGridData(targetRenMstGridID, result);
	
		//Rental : Billing Info 조회
        fn_rentalBillingInfoRental();
    });
}


//Rental : Bill Info 조회
function fn_rentalBillingInfoRental(){

    var rowCnt = AUIGrid.getRowCount(targetRenMstGridID);

    if(rowCnt > 0){
        for(i = 0 ; i < rowCnt ; i++){
            var salesOrdId = AUIGrid.getCellValue(targetRenMstGridID, i ,"salesOrdId");
            var rpf = AUIGrid.getCellValue(targetRenMstGridID, i, "rpf");
            var rpfPaid = AUIGrid.getCellValue(targetRenMstGridID, i, "rpfPaid");
            var balance = AUIGrid.getCellValue(targetRenMstGridID, i, "balance");

            var  excludeRPF = (rpf > 0 && rpfPaid >= rpf) ? "N" : "Y";
            if (rpf == 0) excludeRPF = "N";

            //Rental : Order 정보 조회
            Common.ajax("GET", "/payment/common/selectBillInfoRental.do", {orderId : salesOrdId, excludeRPF : excludeRPF}, function(result) {
                //Rental : Bill Info 세팅
                //AUIGrid.setGridData(targetRenDetGridID, result);
                AUIGrid.appendData(targetRenDetGridID, result);
                
                recalculateRentalTotalAmt();
            });
        }
    }
}

//Rental Amount 계산
function recalculateRentalTotalAmt(){
    var advMonth = $("#rentalTxtAdvMonth").val();
    
    if(advMonth != '' && advMonth > 0){     //advMonth가 입력되어 있는 경우
        rentalDiscountValue();
    } else{                                             //advMonth가 입력되어 있지 않은 경우
        var rowCnt = AUIGrid.getRowCount(targetRenDetGridID);
        var totalAmt = Number(0.00);

        if(rowCnt > 0){
            for(var i = 0; i < rowCnt; i++){
                if(AUIGrid.getCellValue(targetRenDetGridID, i ,"btnCheck") == 0){
                    totalAmt += AUIGrid.getCellValue(targetRenDetGridID, i ,"targetAmt");
                }
            }
        }
    
        $("#rentalTotalAmtTxt").text("RM " + $.number(totalAmt,2));        
    }
}

//Rental Amount 선납금 할인율 적용
function rentalDiscountValue(){
    var discountValue = 0.0;
    var discountrate = 0;
    var originalprice = 0.0;

    //Advance Specification 관련 금액 계산
    var advMonth = $("#rentalTxtAdvMonth").val();    
    var rows = AUIGrid.getRowIndexesByValue(targetRenMstGridID, "salesOrdId", $("#rentalOrdId").val());
    var mthRentAmt = AUIGrid.getCellValue(targetRenMstGridID, rows, "mthRentAmt");

    if (advMonth >= 6 && advMonth < 12){
        discountValue = mthRentAmt * advMonth * 0.97;
        originalprice = mthRentAmt * advMonth;
        discountrate = 3;
    } else if (advMonth >= 12 && advMonth < 24) {
        discountValue = mthRentAmt * advMonth * 0.95;
        originalprice = mthRentAmt * advMonth;
        discountrate = 5;
    } else if (advMonth >= 24 && advMonth < 61) {
        discountValue = mthRentAmt * advMonth * 0.9;
        originalprice = mthRentAmt * advMonth;
        discountrate = 10;
    } else {
        discountValue = mthRentAmt * advMonth;
        originalprice = mthRentAmt * advMonth;
        discountrate = 0;
    }
    
    //선납금 할인을 적용한 금액 표시
    recalculateRentalTotalAmtWidthAdv(discountValue,originalprice,discountrate);
}

//Rental Amount 선납금 할인을 적용한 금액 표시
function recalculateRentalTotalAmtWidthAdv(discountValue, originalPrice, discountrate) {
    var tot = 0;
    var mstRowCnt = AUIGrid.getRowCount(targetRenMstGridID);
    var mstOrdNo = '';

    if(mstRowCnt > 0){
        for(var i = 0; i < mstRowCnt; i++){
            
            mstOrdNo = AUIGrid.getCellValue(targetRenMstGridID,i,"salesOrdNo");     //마스터 그리드에서 orderNo
            rpf = AUIGrid.getCellValue(targetRenMstGridID,i,"rpf");
            rpfPaid = AUIGrid.getCellValue(targetRenMstGridID,i,"rpfPaid");
            balance = AUIGrid.getCellValue(targetRenMstGridID,i,"balance");

            var rpfTarget = 0;

            if (rpf > rpfPaid) rpfTarget = rpf - rpfPaid;

            if(balance >= 0){
                tot += rpfTarget;

                //상세 그리드에서  마스터 그리드의 orderNo와 동일한 orderNo row만 조회한다. 
                var rows = AUIGrid.getRowsByValue(targetRenDetGridID, "ordNo", mstOrdNo);

                for(var j = 0; j < rows.length; j++){
                    var obj = rows[j];
                    
                    if(obj.btnCheck == 0){
                        tot += obj.targetAmt; 
                    }
                }
            }
        }
    }

    var grandtotal = tot + discountValue;
    
    if (tot > 0) {
        $("#rentalTotalAmtTxt").text("RM " + $.number(tot,2) + " + (RM " + $.number(originalPrice,2)  + " - " + discountrate + "%) = RM " + $.number(grandtotal,2));
    } else {
        $("#rentalTotalAmtTxt").text("RM " + $.number(originalPrice,2) + " - " + discountrate + "%) = RM " + $.number(grandtotal,2));
    }
}

//선택된 Master Grid 데이터의 Slave 데이터 건을 Bold 처리함
function rentalChangeRowStyleFunction(srcOrdNo) {
    // row Styling 함수를 다른 함수로 변경
    AUIGrid.setProp(targetRenDetGridID, "rowStyleFunction", function(rowIndex, item) {
        if(item.ordNo == srcOrdNo) {
            return "my-row-style";
        }
        return "";
    });
    
    // 변경된 rowStyleFunction 이 적용되도록 그리드 업데이트
    AUIGrid.update(targetRenDetGridID);
};

function resetRentalGrid(){
	AUIGrid.clearGridData(targetRenMstGridID);
    AUIGrid.clearGridData(targetRenDetGridID);
}

function rentalCheckBillGroup(){
	if($("#rentalOrdNo").val() != ''){
		fn_rentalConfirm();
	}
}

//Advance Month 변경시 이벤트
function fn_rentalAdvMonth(){    
    var advMonth = $("#rentalAdvMonthType").val();
    
    if(advMonth == 99 ){
        $("#rentalTxtAdvMonth").val(1);
        $('#rentalTxtAdvMonth').removeClass("readonly");
        $("#rentalTxtAdvMonth").prop("readonly",false);
    }else{
        $("#rentalTxtAdvMonth").val(advMonth);
        $('#rentalTxtAdvMonth').addClass("readonly");
        $("#rentalTxtAdvMonth").prop("readonly",true);
    }
    
    recalculateRentalTotalAmt();
}

//**************************************************
//**************************************************
//Outright 관련 Script 
//**************************************************
//**************************************************
//Search Order confirm
function fn_outConfirm(){
    //Outright Grid Clear 처리
    resetOutGrid();
    
    var ordNo = $("#outOrdNo").val();
    
    if(ordNo != ''){
        //Order Basic 정보 조회
        Common.ajax("GET", "/payment/common/selectOrdIdByNo.do", {"ordNo" : ordNo}, function(result) {        
            if(result != null && result.salesOrdId != ''){
                $("#outOrdId").val(result.salesOrdId);
                $("#outOrdNo").val(result.salesOrdNo);
                                
                //Order Info 및 Payment Info 조회
                fn_outOrderInfo();
            }            
        });
    }
}

//Search Order 팝업
function fn_outOrderSearchPop(){
	resetOutGrid();
    Common.popupDiv("/sales/order/orderSearchPop.do", {callPrgm : "OUTRIGHT_PAYMENT", indicator : "SearchOrder"});
}

//Search Order 팝업에서 결과값 받기
function fn_callBackOutOrderInfo(ordNo, ordId){
    
    //Order Basic 정보 조회
    Common.ajax("GET", "/payment/selectOrderBasicInfoByOrderId.do", {"orderId" : ordId}, function(result) {        
        $("#outOrdId").val(result.ordId);
        $("#outOrdNo").val(result.ordNo);
        
        //Order Info 및 Payment Info 조회
        fn_outOrderInfo();
    });
}

//Outright Order Info 조회
function fn_outOrderInfo(){
    var data;
    data = {"orderId" : $("#outOrdId").val() };
    
    //Outright : Order 정보 조회
    Common.ajax("GET", "/payment/common/selectOrderInfoNonRental.do", data, function(result) {
        //Outright : Order Info 세팅
        AUIGrid.setGridData(targetOutMstGridID, result);
    
        //총 금액 계산
        recalculateOutTotalAmt();
    });    
}
    
//Outright Amount 계산
function recalculateOutTotalAmt(){
    var rowCnt = AUIGrid.getRowCount(targetOutMstGridID);
    var totalAmt = 0;

    if(rowCnt > 0){
        for(var i = 0; i < rowCnt; i++){
            totalAmt += AUIGrid.getCellValue(targetOutMstGridID, i ,"balance");
        }
    }

    $("#outTotalAmtTxt").text("RM " + $.number(totalAmt,2));    
}

function resetOutGrid(){
    AUIGrid.clearGridData(targetOutMstGridID);
}


//**************************************************
//**************************************************
//Rental Membership 관련 Script 
//**************************************************
//**************************************************
//Search Order 팝업
function fn_srvcOrderSearchPop(){
    Common.popupDiv('/payment/common/initCommonServiceContractSearchPop.do', {callPrgm : "MEMBERSHIP_PAYMENT"}, null , true ,'_serviceContract');
    
}

//Search Order 팝업에서 결과값 받기
function fn_callBackSrvcOrderInfo(srvCntrctId, salesOrdId,srvCntrctRefNo){
	$('#srvcOrdId').val(salesOrdId);
	$('#srvcId').val(srvCntrctId);
	$('#srvcNo').val(srvCntrctRefNo);
	
	//팝업 숨기기 및 remove
	$('#_serviceContract').hide();
    $('#_serviceContract').remove();
    
    //Order Info 및 Payment Info 조회
    fn_srvcOrderInfo();
}

//Rental Mebership Order Info 조회
function fn_srvcOrderInfo(){
    var isSrvcBillGroup = "N"; 
    
    if($("#isSrvcBillGroup").is(":checked")){
    	isSrvcBillGroup = "Y";
    }
    
    //Rental Membership : Order 정보 조회
    Common.ajax("GET", "/payment/common/selectOrderInfoSrvc.do", {"srvcId" : $("#srvcId").val() , "isSrvcBillGroup" : isSrvcBillGroup}, function(result) {
        //Rental Membership : Order Info 세팅
        AUIGrid.setGridData(targetSrvcMstGridID, result);
    
        //Rental Membership : Billing Info 조회
        //fn_rentalBillingInfoRental();
    });
}
    
    
</script>

<section id="content">
    <ul class="path">
        <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
        <li>Payment</li>
        <li>Credit Card Payment</li>
        <li>Credit Card Key-In (from Admin)</li>
    </ul>

    <!-- title_line start -->
    <aside class="title_line">
        <p class="fav"><a href="#" class="click_add_on">My menu</a></p>
        <h2>Credit Card Key-In (from Admin)</h2>
    </aside>
    <!-- title_line end -->

    <!-- search_table start -->
    <section class="search_table">
        <!-- search_table start -->
        <table class="type1">
            <caption>table</caption>
            <colgroup>
                <col style="width:180px" />
                <col style="width:*" />
            </colgroup>
            <tbody>
                <tr>
                    <th scope="row">Application Type</th>
                    <td>
                        <select id="appType" name="appType">
                            <option value="1">Rental</option>
                            <option value="2">Outright</option>
                            <option value="3">Rental Membership</option>
                            <option value="4">Bill Payment</option>
                        </select>
                    </td>                        
                </tr>
            </tbody>
        </table>
        <!-- table end -->
    </section>
    
    <!-- 
    ***************************************************************************************
    ***************************************************************************************
    *************                                          Rental Search Area                                                           ****
    ***************************************************************************************
    ***************************************************************************************
    -->
    <!-- search_table start -->
    <section class="search_table" id="rentalSearch">
        <!-- search_table start -->
        <form id="rentalSearchForm" action="#" method="post">
            <input type="hidden" name="rentalOrdId" id="rentalOrdId" />
            <input type="hidden" name="rentalBillGrpId" id="rentalBillGrpId" />
            
            <table class="type1">
                <caption>table</caption>
                <colgroup>
                    <col style="width:180px" />
                    <col style="width:*" />                    
                </colgroup>
                <tbody>
                    <tr>
                        <th scope="row">Sales Order No.</th>
                        <td>
                            <input type="text" name="rentalOrdNo" id="rentalOrdNo" title="" placeholder="Order Number" class="" />
                                <p class="btn_sky">
                                    <a href="javascript:fn_rentalConfirm();" id="confirm">Confirm</a>
                                </p>
                                <p class="btn_sky">
                                    <a href="javascript:fn_rentalOrderSearchPop();" id="search">Search</a>
                                </p>
                                <p class="btn_sky">
                                    <a href="" id="viewLedger">View Ledger</a>
                                </p>
                                <label><input type="checkbox" id="isRentalBillGroup" name="isRentalBillGroup" onClick="javascript:rentalCheckBillGroup();" /><span>include all orders' bills with same billing group </span></label>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Advance Specification</th>
                        <td>
                            <select id="rentalAdvMonthType" name="rentalAdvMonthType" onchange="fn_rentalAdvMonth();">
                                <option value="0" selected="selected">Advance Selection</option>
                                <option value="99">Specific Advance</option>
                                <option value="12">1 Year</option>
                                <option value="24">2 Years</option>
                            </select>
                            <input type="text" id="rentalTxtAdvMonth" name="rentalTxtAdvMonth" title="Advance Month" size="3" maxlength="2" class="wAuto ml5 readonly"  readonly onkeydown='return FormUtil.onlyNumber(event)' onblur="javascript:recalculateRentalTotalAmt();"/>
                        </td>
                    </tr>
                </tbody>
            </table>
            <!-- table end -->
        </form>
    </section>
    <!-- search_table end -->
    
    <!-- grid_wrap start -->
    <article class="grid_wrap">
        <div id="target_rental_grid_wrap" style="width: 100%; height: 210px; margin: 0 auto;"></div>
    </article>
    <!-- grid_wrap end -->

    <!-- grid_wrap start -->
    <article class="grid_wrap mt10">
        <div id="target_rentalD_grid_wrap" style="width: 100%; height: 210px; margin: 0 auto;"></div>
    </article>
    <!-- grid_wrap end -->
    
    <ul class="right_btns">
        <li><p class="amountTotalSttl">Amount Total (RPF + Rental Fee) :</p></li>
        <li><strong id="rentalTotalAmtTxt">RM 0.00</strong></li>
    </ul>
    
    <!-- 
    ***************************************************************************************
    ***************************************************************************************
    *************                                          Outright Search Area                                                         ****
    ***************************************************************************************
    ***************************************************************************************
    -->
    <!-- search_table start -->
    <section class="search_table" id="outSearch">
        <!-- search_table start -->
        <form id="outSearchForm" action="#" method="post">
            <input type="hidden" name="outOrdId" id="outOrdId" />            
            
            <table class="type1">
                <caption>table</caption>
                <colgroup>
                    <col style="width:180px" />
                    <col style="width:*" />                    
                </colgroup>
                <tbody>
                    <tr>
                        <th scope="row">Sales Order No.</th>
                        <td>
                            <input type="text" name="outOrdNo" id="outOrdNo" title="" placeholder="Order Number" class="" />
                                <p class="btn_sky">
                                    <a href="javascript:fn_outConfirm();" id="confirm">Confirm</a>
                                </p>
                                <p class="btn_sky">
                                    <a href="javascript:fn_outOrderSearchPop();" id="search">Search</a>
                                </p>
                        </td>
                    </tr>
                </tbody>
            </table>
            <!-- table end -->
        </form>
    </section>
    <!-- search_table end -->
    
    <!-- grid_wrap start -->
    <article class="grid_wrap">
        <div id="target_out_grid_wrap" style="width: 100%; height: 210px; margin: 0 auto;"></div>
    </article>
    <!-- grid_wrap end -->

    
    <ul class="right_btns">
        <li><p class="amountTotalSttl">Amount Total :</p></li>
        <li><strong id="outTotalAmtTxt">RM 0.00</strong></li>
    </ul>
    
    <!-- 
    ***************************************************************************************
    ***************************************************************************************
    *************                                          Rental Membership Area                                                     ****
    ***************************************************************************************
    ***************************************************************************************
    -->
    <!-- search_table start -->
    <section class="search_table" id="srvcSearch">
        <!-- search_table start -->
        <form id="srvcSearchForm" action="#" method="post">
            
            
            <input type="text" name="srvcOrdId" id="srvcOrdId" />
            <input type="text" name="srvcId" id="srvcId" />
            
            <table class="type1">
                <caption>table</caption>
                <colgroup>
                    <col style="width:180px" />
                    <col style="width:*" />                    
                </colgroup>
                <tbody>
                    <tr>
                        <th scope="row">Rental Membership No.</th>
                        <td>
                            <input type="text" name="srvcNo" id="srvcNo" title="" placeholder="SCS No." class="readonly" readonly />
                                <p class="btn_sky">
                                    <a href="javascript:fn_srvcOrderSearchPop();" id="search">Search</a>
                                </p>
                                <p class="btn_sky">
                                    <a href="" id="viewLedger">View Ledger</a>
                                </p>
                                <label><input type="checkbox" id="isSrvcBillGroup" name="isSrvcBillGroup" onClick="javascript:srvcCheckBillGroup();" /><span>include all service contacts' bills with same billing group </span></label>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Advance Specification</th>
                        <td>
                            <select id="srvcAdvMonthType" name="srvcAdvMonthType" onchange="fn_srvcAdvMonth();">
                                <option value="0" selected="selected">Advance Selection</option>
                                <option value="99">Specific Advance</option>
                                <option value="12">1 Year</option>
                                <option value="24">2 Years</option>
                            </select>
                            <input type="text" id="srvcTxtAdvMonth" name="srvcTxtAdvMonth" title="Rental Membership Advance Month" size="3" maxlength="2" class="wAuto ml5 readonly"  readonly onkeydown='return FormUtil.onlyNumber(event)' onblur="javascript:recalculateSrvcTotalAmt();"/>
                        </td>
                    </tr>
                </tbody>
            </table>
            <!-- table end -->
        </form>
    </section>
    <!-- search_table end -->
    
    <!-- grid_wrap start -->
    <article class="grid_wrap">
        <div id="target_srvc_grid_wrap" style="width: 100%; height: 210px; margin: 0 auto;"></div>
    </article>
    <!-- grid_wrap end -->

    <!-- grid_wrap start -->
    <article class="grid_wrap mt10">
        <div id="target_srvcD_grid_wrap" style="width: 100%; height: 210px; margin: 0 auto;"></div>
    </article>
    <!-- grid_wrap end -->
    
    <ul class="right_btns">
        <li><p class="amountTotalSttl">Amount Total (1st BS + Rental Fee) :</p></li>
        <li><strong id="srvcTotalAmtTxt">RM 0.00</strong></li>
    </ul>
    
    <!-- 
    ***************************************************************************************
    ***************************************************************************************
    *************                                          Key In  Area                                                                    ****
    ***************************************************************************************
    ***************************************************************************************
    -->
    <!-- title_line start -->
    <aside class="title_line">
        <h3 class="pt0">Payment Key-In</h3>
    </aside>
    <!-- title_line end -->

    <!-- search_table start -->
    <section class="search_table">
        <!-- search_table start -->
        <form id="paymentForm" action="#" method="post">    
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
                        <th scope="row">Payment Type</th>
                        <td colspan="3">
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Card Mode</th>
                        <td>
                        </td>
                        <th scope="row">Merchant Bank</th>
                        <td>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Transaction Date</th>
                        <td>
                        </td>
                        <th scope="row">Card No.</th>
                        <td>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Card Type</th>
                        <td>
                        </td>
                        <th scope="row">Credit Card Type</th>
                        <td>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Amount</th>
                        <td>
                        </td>
                        <th scope="row">Approval No.</th>
                        <td>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Expiry Date</th>
                        <td>
                        </td>
                        <th scope="row">Tenure</th>
                        <td>
                        </td>
                    </tr>
                </tbody>
            </table>
            <!-- table end -->
        </form>
    </section>
<!-- search_table end -->

</section>
<!-- content end -->