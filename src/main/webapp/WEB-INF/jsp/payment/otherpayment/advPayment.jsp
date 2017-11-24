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

.my_div_text_box {
    display: inline-block;
    border: 1px solid #aaa;
    text-align: left;
    width: 140px;
    padding: 4px;
}

.my_div_btn {
    color: #fff !important;
    background: #a1c4d7;
    font-weight: bold;
    margin: 2px 4px;
    padding : 2px 4px;
    line-height:2em;
    cursor: pointer;
}
</style>
<script type="text/javaScript">

var maxSeq = 0; //billing ADD 될 시퀀스

//targetFinalBillGridID Grid에서 선택된 RowID
var selectedGridValue = -1;

var targetRenMstGridID;
var targetRenDetGridID;
var targetOutMstGridID;
var targetSrvcMstGridID;
var targetSrvcDetGridID;
var targetBillMstGridID;
var targetFinalBillGridID;

//Tenure Combo Data
var tenureTypeData = [];
var tenureTypeData1 = [{"codeId": "6","codeName": "6 Months"},{"codeId": "12","codeName": "12 Months"},{"codeId": "24","codeName": "24 Months"}];
var tenureTypeData2 = [{"codeId": "6","codeName": "6 Months"},{"codeId": "12","codeName": "12 Months"},{"codeId": "18","codeName": "18 Months"},{"codeId": "24","codeName": "24 Months"},{"codeId": "36","codeName": "36 Months"}];
var tenureTypeData3 = [{"codeId": "6","codeName": "6 Months"},{"codeId": "12","codeName": "12 Months"},{"codeId": "18","codeName": "18 Months"},{"codeId": "24","codeName": "24 Months"}];
var tenureTypeData4 = [{"codeId": "12","codeName": "12 Months"},{"codeId": "18","codeName": "18 Months"},{"codeId": "24","codeName": "24 Months"}];
var tenureTypeData5 = [{"codeId": "12","codeName": "12 Months"},{"codeId": "24","codeName": "24 Months"}];


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
    { dataField:"custNm" ,headerText:"Customer Name" ,editable : false , width : 250 },
    {
        dataField : "btnCheck",
        headerText : "Include",
        width: 80,
        renderer : {
            type : "CheckBoxEditRenderer",            
            editable : true, // 체크박스 편집 활성화 여부(기본값 : false)
            checkValue : "1", // true, false 인 경우가 기본
            unCheckValue : "0"            
        }
    }
];

//AUIGrid 칼럼 설정 : targetRenDetGridID
var targetRenDetColumnLayout = [
    { dataField:"billGrpId" ,headerText:"Bill Group ID" ,editable : false , width : 120, visible : false },
    { dataField:"billTypeId" ,headerText:"BILL_TYPE_ID" ,editable : false , width : 120, visible : false },
    { dataField:"stusCode" ,headerText:"STUS_CODE" ,editable : false , width : 120, visible : false },
    { dataField:"custNm" ,headerText:"CUST_NM" ,editable : false , width : 120, visible : false },
    
    { dataField:"billId" ,headerText:"Bill ID" ,editable : false , width : 100, visible : false },
    { dataField:"billNo" ,headerText:"Bill No" ,editable : false , width : 150 },
    { dataField:"ordId" ,headerText:"Order ID" ,editable : false , width : 100 , visible : false },  
    { dataField:"ordNo" ,headerText:"Order No" ,editable : false , width : 100 },      
    { dataField:"billTypeNm" ,headerText:"Bill Type" ,editable : false , width : 180 },      
    { dataField:"installment" ,headerText:"Installment" ,editable : false , width : 100 },      
    { dataField:"billAmt" ,headerText:"Amount" ,editable : false , width : 100 , dataType : "numeric", formatString : "#,##0.##"},  
    { dataField:"paidAmt" ,headerText:"Paid" ,editable : false , width : 100 , dataType : "numeric", formatString : "#,##0.##"},
    { dataField:"targetAmt" ,headerText:"Target<br>Amount" ,editable : true , width : 100 , dataType : "numeric", formatString : "#,##0.##"},
    { dataField:"billDt" ,headerText:"Bill Date" ,editable : false , width : 100},
    { dataField:"stusCodeName" ,headerText:"Bill Status" ,editable : false , width : 100},
    {
        dataField : "btnCheck",
        headerText : "Include",
        width: 80,
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
    { dataField:"appTypeNm" ,headerText:"AppTypeNm" ,editable : false , width : 100, visible : false },
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
   { dataField:"salesOrdId" ,headerText:"Sales Order ID" ,editable : false , width : 100, visible : false },
   { dataField:"salesOrdNo" ,headerText:"Sales Order No" ,editable : false , width : 100, visible : false },
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
    { dataField:"custName" ,headerText:"Customer Name" ,editable : false , width : 250 },
    {
        dataField : "btnCheck",
        headerText : "Include",
        width: 50,
        renderer : {
            type : "CheckBoxEditRenderer",            
            editable : true, // 체크박스 편집 활성화 여부(기본값 : false)
            checkValue : "1", // true, false 인 경우가 기본
            unCheckValue : "0"            
        }
    }
];

//AUIGrid 칼럼 설정 : targetSrvcDetGridID
var targetSrvcDetColumnLayout = [
    { dataField:"srvLdgrCntrctId" ,headerText:"Srv Ldgr Cntrct ID" ,editable : false , width : 150  , visible : false },
    { dataField:"srvLdgrRefNo" ,headerText:"Bill No" ,editable : false , width : 120},
    { dataField:"srvCntrctRefNo" ,headerText:"SCS No." ,editable : false , width : 100},
    { dataField:"srvCntrctOrdId" ,headerText:"Order ID" ,editable : false , width : 150  , visible : false },
    { dataField:"salesOrdNo" ,headerText:"Order No" ,editable : false , width : 100},  
    { dataField:"srvLdgrTypeId" ,headerText:"Bill Type ID" ,editable : false , width : 100  , visible : false },      
    { dataField:"srvLdgrTypeNm" ,headerText:"Bill Type" ,editable : false , width : 180 },      
    { dataField:"srvPaySchdulNo" ,headerText:"Schedule No." ,editable : false , width : 100 },
    { dataField:"srvLdgrAmt" ,headerText:"Bill No." ,editable : false , width : 100 },
    { dataField:"paidTotal" ,headerText:"Paid" ,editable : false , width : 100 , dataType : "numeric", formatString : "#,##0.##"},  
    { dataField:"targetAmt" ,headerText:"Target Amount" ,editable : false , width : 100 , dataType : "numeric", formatString : "#,##0.##"},    
    { dataField:"srvLdgrRefDt" ,headerText:"Bill Date" ,editable : false , width : 100},
    {
        dataField : "btnCheck",
        headerText : "Include",
        width: 50,
        renderer : {
            type : "CheckBoxEditRenderer",            
            editable : true, // 체크박스 편집 활성화 여부(기본값 : false)
            checkValue : "1", // true, false 인 경우가 기본
            unCheckValue : "0"            
        }
    }
];

//AUIGrid 칼럼 설정 : targetBillMstGridID
var targetBillMstColumnLayout = [
    { dataField:"appType" ,headerText:"appType" ,editable : false , width : 150 , visible : false },
    { dataField:"billSoId" ,headerText:"Bill Sales Order ID" ,editable : false , width : 150 , visible : false },
    { dataField:"salesOrdNo" ,headerText:"Sales Order No" ,editable : false , width : 150 , visible : false },
    { dataField:"billAsId" ,headerText:"Bill AS Id" ,editable : false , width : 150 , visible : false },
    
    
    { dataField:"billId" ,headerText:"Bill ID" ,editable : false , width : 120 },
    { dataField:"billNo" ,headerText:"Bill No" ,editable : false , width : 100},
    { dataField:"billTypeId" ,headerText:"Bill Type ID" ,editable : false , width : 150 , visible : false },
    { dataField:"billTypeNm" ,headerText:"Bill Type" ,editable : false , width : 100},  
    { dataField:"custNm" ,headerText:"Cust Name" ,editable : false , width : 250},      
    { dataField:"nric" ,headerText:"Cust NRIC" ,editable : false , width : 120 },      
    { dataField:"billMemNm" ,headerText:"HP Name." ,editable : false , width : 250 , visible : false },
    { dataField:"billMemCode" ,headerText:"HP Code." ,editable : false , width : 100 , visible : false },
    { dataField:"ruleDesc" ,headerText:"Pay Type" ,editable : false , width : 200 },  
    { dataField:"billDt" ,headerText:"Date" ,editable : false , width : 100 },  
    { dataField:"billAmt" ,headerText:"Amount" ,editable : false , width : 100 , dataType : "numeric", formatString : "#,##0.##"},
    { dataField:"paidAmt" ,headerText:"Paid Amount" ,editable : false , width : 100 , dataType : "numeric", formatString : "#,##0.##"},
    { dataField:"billRem" ,headerText:"Remark" ,editable : false , width : 100 },
    { dataField:"billIsPaid" ,headerText:"Paid?" ,editable : false , width : 100 },
    { dataField:"billIsComm" ,headerText:"Commission?" ,editable : false , width : 100 },
    { dataField:"stusNm" ,headerText:"Status" ,editable : false , width : 100 },
    {
        dataField : "btnCheck",
        headerText : "Include",
        width: 50,
        renderer : {
            type : "CheckBoxEditRenderer",            
            editable : true, // 체크박스 편집 활성화 여부(기본값 : false)
            checkValue : "1", // true, false 인 경우가 기본
            unCheckValue : "0"            
        }
    }
];


//AUIGrid 칼럼 설정 : targetFinalBillGridID
var targetFinalBillColumnLayout = [
{ dataField:"procSeq" ,headerText:"Process Seq" ,editable : false , width : 120 , visible : false },
{ dataField:"appType" ,headerText:"AppType" ,editable : false , width : 120 , visible : false },
{ dataField:"advMonth" ,headerText:"AdvanceMonth" ,editable : false , width : 120 , dataType : "numeric", formatString : "#,##0.##" , visible : false },
{ dataField:"billGrpId" ,headerText:"Bill Group ID" ,editable : false , width : 120},
{ dataField:"billId" ,headerText:"Bill ID" ,editable : false , width : 100, visible : false },
{ dataField:"ordId" ,headerText:"Order ID" ,editable : false , width : 100  , visible : false },
{ dataField:"mstRpf" ,headerText:"Master RPF" ,editable : false , width : 100  , dataType : "numeric", formatString : "#,##0.##" , visible : false },
{ dataField:"mstRpfPaid" ,headerText:"Master RPF Paid" ,editable : false , width : 100  , dataType : "numeric", formatString : "#,##0.##" , visible : false },
{ dataField:"billNo" ,headerText:"Bill No" ,editable : false , width : 150 },      
{ dataField:"ordNo" ,headerText:"Order No" ,editable : false , width : 100 },
{ dataField:"billTypeId" ,headerText:"Bill TypeID" ,editable : false , width : 100 , visible : false },
{ dataField:"billTypeNm" ,headerText:"Bill Type" ,editable : false , width : 180 },      
{ dataField:"installment" ,headerText:"Installment" ,editable : false , width : 100 },      
{ dataField:"billAmt" ,headerText:"Amount" ,editable : false , width : 100 , dataType : "numeric", formatString : "#,##0.##"},  
{ dataField:"paidAmt" ,headerText:"Paid" ,editable : false , width : 100 , dataType : "numeric", formatString : "#,##0.##"},
{ dataField:"targetAmt" ,headerText:"Target<br>Amount" ,editable : true , width : 100 , dataType : "numeric", formatString : "#,##0.##"},
{ dataField:"billDt" ,headerText:"Bill Date" ,editable : false , width : 100 },
{ dataField:"assignAmt" ,headerText:"assignAmt" ,editable : false , width : 100 , dataType : "numeric", formatString : "#,##0.##" , visible : false },
{ dataField:"billStatus" ,headerText:"billStatus" ,editable : false , width : 100 , visible : false },
{ dataField:"custNm" ,headerText:"custNm" ,editable : false , width : 300},
{ dataField:"srvcContractID" ,headerText:"SrvcContractID" ,editable : false , width : 100 , visible : false },
{ dataField:"billAsId" ,headerText:"Bill AS Id" ,editable : false , width : 150 , visible : false },
{ dataField:"discountAmt" ,headerText:"discountAmt" ,editable : false , width : 100 , dataType : "numeric", formatString : "#,##0.##" , visible : false }
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
    targetBillMstGridID = GridCommon.createAUIGrid("target_bill_grid_wrap", targetBillMstColumnLayout,null,gridPros);
    targetFinalBillGridID = GridCommon.createAUIGrid("target_finalBill_grid_wrap", targetFinalBillColumnLayout,null,gridPros);
    
    //Rental Billing Grid 에서 체크/체크 해제시
    AUIGrid.bind(targetRenDetGridID, "cellClick", function( event ){
        if(event.dataField == "btnCheck"){
            
            var chkVal = AUIGrid.getCellValue(targetRenDetGridID, event.rowIndex, "btnCheck");
            var chkOrdNo = AUIGrid.getCellValue(targetRenDetGridID, event.rowIndex, "ordNo");
            var rowCnt = AUIGrid.getRowCount(targetRenMstGridID);
            
            if(chkVal == 1){
                if(rowCnt > 0){
                    for(i = 0 ; i < rowCnt ; i++){
                        if(AUIGrid.getCellValue(targetRenMstGridID, i, "salesOrdNo") ==  chkOrdNo){
                            AUIGrid.setCellValue(targetRenMstGridID, i, "btnCheck", chkVal);
                        }
                    }
                }
            }
            
            recalculateRentalTotalAmt();
        }
    });
    
    //Rental Order Info 선택시 해당 Billing 정보 bold 로 표시하기
    AUIGrid.bind(targetRenMstGridID, "cellClick", function(event) {
        if(event.dataField == "btnCheck"){
            var chkVal = AUIGrid.getCellValue(targetRenMstGridID, event.rowIndex, "btnCheck");
            var chkOrdNo = AUIGrid.getCellValue(targetRenMstGridID, event.rowIndex, "salesOrdNo");
            var rowCnt = AUIGrid.getRowCount(targetRenDetGridID);
            
            if(rowCnt > 0){
                for(i = 0 ; i < rowCnt ; i++){
                    if(AUIGrid.getCellValue(targetRenDetGridID, i, "ordNo") ==  chkOrdNo){
                        AUIGrid.setCellValue(targetRenDetGridID, i, "btnCheck", chkVal);
                    }
                }
            }
            
            recalculateRentalTotalAmt();
        }else{
            rentalChangeRowStyleFunction(AUIGrid.getCellValue(targetRenMstGridID, event.rowIndex, "salesOrdNo"));
        }
    }); 
    
    //Rental Membership Billing Grid 에서 체크/체크 해제시
    AUIGrid.bind(targetSrvcDetGridID, "cellClick", function( event ){
        if(event.dataField == "btnCheck"){
            var chkVal = AUIGrid.getCellValue(targetSrvcDetGridID, event.rowIndex, "btnCheck");
            var srvCntrctRefNo = AUIGrid.getCellValue(targetSrvcDetGridID, event.rowIndex, "srvCntrctRefNo");
            var rowCnt = AUIGrid.getRowCount(targetSrvcMstGridID);
            
            if(chkVal == 1){
                if(rowCnt > 0){
                    for(i = 0 ; i < rowCnt ; i++){
                        if(AUIGrid.getCellValue(targetSrvcMstGridID, i, "srvCntrctRefNo") ==  srvCntrctRefNo){
                            AUIGrid.setCellValue(targetSrvcMstGridID, i, "btnCheck", chkVal);
                        }
                    }
                }
            }
            
            recalculateSrvcTotalAmt();
        }
    });
    
    //Rental Order Info 선택시 해당 Billing 정보 bold 로 표시하기
    AUIGrid.bind(targetSrvcMstGridID, "cellClick", function(event) {
        if(event.dataField == "btnCheck"){
            var chkVal = AUIGrid.getCellValue(targetSrvcMstGridID, event.rowIndex, "btnCheck");
            var srvCntrctRefNo = AUIGrid.getCellValue(targetSrvcMstGridID, event.rowIndex, "srvCntrctRefNo");
            var rowCnt = AUIGrid.getRowCount(targetSrvcDetGridID);
            
            if(rowCnt > 0){
                for(i = 0 ; i < rowCnt ; i++){
                    if(AUIGrid.getCellValue(targetSrvcDetGridID, i, "srvCntrctRefNo") ==  srvCntrctRefNo){
                        AUIGrid.setCellValue(targetSrvcDetGridID, i, "btnCheck", chkVal);
                    }
                }
            }
            
            recalculateSrvcTotalAmt();
        }else{
            srvcChangeRowStyleFunction(AUIGrid.getCellValue(targetSrvcMstGridID, event.rowIndex, "srvCntrctRefNo"));
        }
    });
    
    //Bill Payment 체크박스 선택시 금액 계산
    AUIGrid.bind(targetBillMstGridID, "cellClick", function(event) {
        if(event.dataField == "btnCheck"){
            recalculateBillTotalAmt();
        }
    });
    
    //Cell Edit Event : 최종 Final 금액 변경시 금액 재 계산
    AUIGrid.bind(targetFinalBillGridID, "cellEditEnd", function( event ) {        
        var billAmt = AUIGrid.getCellValue(targetFinalBillGridID, event.rowIndex, "billAmt"); //invoice charge
        var paidAmt = AUIGrid.getCellValue(targetFinalBillGridID, event.rowIndex, "paidAmt"); //transfer amount
        var targetAmt = AUIGrid.getCellValue(targetFinalBillGridID, event.rowIndex, "targetAmt"); //transfer amount

        if(targetAmt > billAmt - paidAmt){
            AUIGrid.setCellValue(targetFinalBillGridID, event.rowIndex, 'targetAmt', billAmt - paidAmt);
        }

        //그리드에서 수정된 총 금액 계산
        recalculatePaymentTotalAmt();
    });
    
    //Credit Card Type 생성
    //doGetCombo('/common/selectCodeList.do', '21' , ''   , 'keyInCrcType' , 'S', '');
    
    //CreditCardMode 생성
    //doGetCombo('/common/selectCodeList.do', '130' , ''   ,'keyInCardMode', 'S' , '');
    
    //Bank Account 조회 : Merchant Bank 
    //doGetCombo('/common/getAccountList.do', 'CRC' , ''   , 'keyInMerchantBank' , 'S', '');    
    //doGetCombo('/common/getAccountList.do', 'CASH' , ''   , 'bankAccount' , 'S', '');
    //doGetCombo('/common/getAccountList.do', 'CHQ' , ''   , 'bankAccount' , 'S', '');
    //doGetCombo('/common/getAccountList.do', 'ONLINE' , ''   , 'bankAccount' , 'S', '');
    
    // Master Grid 셀 클릭시 이벤트
    AUIGrid.bind(targetFinalBillGridID, "cellClick", function( event ){ 
        selectedGridValue = event.rowIndex;
    });
    
    doGetCombo('/common/getAccountList.do', 'CASH','', 'cashBankAcc', 'S', '' );
    doGetCombo('/common/getAccountList.do', 'CHQ','', 'chequeBankAcc', 'S', '' );
    doGetCombo('/common/getAccountList.do', 'ONLINE','', 'onlineBankAcc', 'S', '' );
    
});

function fn_chgAppType(){
     var appType = $("#appType").val();
     
     //div all hide
     $("#rentalSearch").hide();
     $("#outSearch").hide();
     $("#srvcSearch").hide();
     $("#billSearch").hide();
     
     //Form 초기화
     $("#rentalSearchForm")[0].reset();
     $("#outSearchForm")[0].reset();
     $("#srvcSearchForm")[0].reset();
     $("#billSearchForm")[0].reset();
     
     //그리드 초기화
     resetRentalGrid();
     resetOutGrid();
     resetSrvcGrid();
     resetBillGrid();
     
     //금액 표시 초기화     
     $("#rentalTotalAmtTxt").text("RM " + $.number(0,2));
     $("#outTotalAmtTxt").text("RM " + $.number(0,2));
     $("#srvcTotalAmtTxt").text("RM " + $.number(0,2));
     $("#billTotalAmtTxt").text("RM " + $.number(0,2));
     
     if(appType == 1 ){
         $("#rentalSearch").show();
         AUIGrid.resize(targetRenMstGridID); 
         AUIGrid.resize(targetRenDetGridID); 
     }else if(appType == 2){
         $("#outSearch").show();
         AUIGrid.resize(targetOutMstGridID); 
     }else if(appType == 3){
         $("#srvcSearch").show();
         AUIGrid.resize(targetSrvcMstGridID); 
         AUIGrid.resize(targetSrvcDetGridID); 
     }else if(appType == 4){
         $("#billSearch").show();
         AUIGrid.resize(targetBillMstGridID);
     }
}

//크레딧 카드 입력시 Card Mode 변경에 따라 Issue Bank와 Merchant Bank Combo를 갱신한다.
function fn_changeCrcMode(){
    var cardModeVal = $("#keyInCardMode").val();
    
    if(cardModeVal == 2710){
        //IssuedBank 생성 : PBB, HLB, MBB, AMBank, HSBC, SCB, UOB
        doGetCombo('/common/getIssuedBankList.do', 'CRC2710' , ''   , 'keyInIssueBank' , 'S', '');

        //Merchant Bank 생성 : CIMB, PBB, HLB, MBB, AM BANK, HSBC, SCB, UOB
        doGetCombo('/common/getAccountList.do', 'CRC2710' , ''   , 'keyInMerchantBank' , 'S', '');   

    }else if(cardModeVal == 2712){      //MPOS IPP
        //IssuedBank 생성 : PBB, HLB, MBB, AMBank, HSBC, SCB, UOB
        doGetCombo('/common/getIssuedBankList.do', 'CRC2712' , ''   , 'keyInIssueBank' , 'S', '');

        //Merchant Bank 생성 : CIMB, PBB, HLB, MBB, AM BANK, HSBC, SCB, UOB
        doGetCombo('/common/getAccountList.do', 'CRC2712' , ''   , 'keyInMerchantBank' , 'S', '');
    }else{
        //IssuedBank 생성 : ALL 
        doGetCombo('/common/getIssuedBankList.do', '' , ''   , 'keyInIssueBank' , 'S', '');

        //Merchant Bank 생성
        if(cardModeVal == 2708){      //POS
            doGetCombo('/common/getAccountList.do', 'CRC2708' , ''   , 'keyInMerchantBank' , 'S', '');
        }else if(cardModeVal == 2709){      //MOTO
            doGetCombo('/common/getAccountList.do', 'CRC2709' , ''   , 'keyInMerchantBank' , 'S', '');
        }else if(cardModeVal == 2711){      //MPOS
            doGetCombo('/common/getAccountList.do', 'CRC2711' , ''   , 'keyInMerchantBank' , 'S', '');
        }
    }
}

function saveAdvPayment(){
    
	var keyInPayType = $("#keyInPayType").val();
	
	if(keyInPayType == "105"){
		var cashBankType = $("#cashBankType").val();
		var cashVAAccount = $("#cashVAAccount").val();
		var cashBankAcc = $("#cashBankAcc").val();
		
		if(FormUtil.checkReqValue($("#cashAmount")) ||$("#cashAmount").val() <= 0 ){
	        Common.alert('* No Amount ');
	        return;
	    }
		
		if(cashBankType == "2730"){
			if(cashVAAccount.length != 16 || cashVAAccount == "" ){
				Common.alert('* No VA Account ');
				return;
			}
			
		}else{
			if(FormUtil.checkReqValue($("#cashBankAcc"))){
				Common.alert('* No Bank Account Selected');
                return;
			}
		}
		
		if(FormUtil.checkReqValue($("#cashTransDate"))){
	        Common.alert('* Transaction Date is empty');
	        return;
	    }
		
		if(FormUtil.checkReqValue($("#cashSlipNo"))){
            Common.alert('* No Slip No');
            return;
        }
		
		/* if(FormUtil.checkReqValue($("#cashPayName"))){
            Common.alert('* No PayerName');
            return;
        }   
        
		if(FormUtil.checkReqValue($("#cashRefDetails"))){
            Common.alert('* No Ref Details/Jompay Ref ');
            return;
        } */   
		
		if( FormUtil.byteLength($("#cashRemark").val()) > 3000 ){
	        Common.alert('* Please input the Remark below or less than 3000 bytes.');
	        return;
	    }
		
	}else if(keyInPayType == "106"){
		
		var chequeBankType = $("#chequeBankType").val();
        var chequeVAAccount = $("#chequeVAAccount").val();
        var chequeBankAcc = $("#chequeBankAcc").val();
		
		if(FormUtil.checkReqValue($("#chequeAmount")) ||$("#chequeAmount").val() <= 0 ){
            Common.alert('* No Amount ');
            return;
        }
		
		if(chequeBankType == "2730"){
            if(chequeVAAccount.length != 16 || chequeVAAccount == "" ){
                Common.alert('* No VA Account ');
                return;
            }
            
        }else{
            if(FormUtil.checkReqValue($("#chequeBankAcc"))){
            	Common.alert('* No Bank Account Selected');
                return;
            }
        }
        
        if(FormUtil.checkReqValue($("#chequeTransDate"))){
            Common.alert('* Transaction Date is empty');
            return;
        }
        
        if(FormUtil.checkReqValue($("#chequeChqNo"))){
            Common.alert('* No Slip Number');
            return;
        }
        
        /* if(FormUtil.checkReqValue($("#chequePayName"))){
            Common.alert('* No PayerName');
            return;
        }   
        
        if(FormUtil.checkReqValue($("#chequeRefDetails"))){
            Common.alert('* No Ref Details/Jompay Ref ');
            return;
        } */
		
		if( FormUtil.byteLength($("#chequeRemark").val()) > 3000 ){
            Common.alert('* Please input the Remark below or less than 3000 bytes.');
            return;
        }   
		
	}else if(keyInPayType == "108"){
		
		var onlineBankType = $("#onlineBankType").val();
        var onlineVAAccount = $("#onlineVAAccount").val();
        var onlineBankAcc = $("#onlineBankAcc").val();
		
		if(FormUtil.checkReqValue($("#onlineAmount")) ||$("#onlineAmount").val() <= 0 ){
            Common.alert('* No Amount ');
            return;
        }
		
		 if(FormUtil.checkReqValue($("#onlineTransDate"))){
			    Common.alert('* Transaction Date is empty');
	            return;
	     }
	     
		 /* if(FormUtil.checkReqValue($("#onlineEft"))){
             Common.alert('* No EFT No');
             return;
         }
         
         if(FormUtil.checkReqValue($("#onlinePayName"))){
             Common.alert('* No PayerName');
             return;
         }   
         
         if(FormUtil.checkReqValue($("#onlineRefDetails"))){
             Common.alert('* No Ref Details/Jompay Ref ');
             return;
         } */
         
         if(onlineBankType == "2730"){
             if(onlineVAAccount.length != 16 || onlineVAAccount == "" ){
                 Common.alert('* No VA Account ');
                 return;
             }
             
         }else{
             if(FormUtil.checkReqValue($("#onlineBankAcc"))){
            	 Common.alert('* No Bank Account Selected');
                 return;
             }
         }
		
		if( FormUtil.byteLength($("#onlineRemark").val()) > 3000 ){
            Common.alert('* Please input the Remark below or less than 3000 bytes.');
            return;
        }   
	}
	
    //param data array
    var data = {};
    var gridList = AUIGrid.getGridData(targetFinalBillGridID);
    var formList = "";
    
    if(keyInPayType == "105"){
    	$("#keyInPayCashType").val(keyInPayType);
    	formList = $("#cashSearchForm").serializeArray();
    }else if(keyInPayType == "106"){
    	$("#keyInPayChequeType").val(keyInPayType);
    	formList = $("#chequeSearchForm").serializeArray();
    }else if(keyInPayType == "108"){
    	$("#keyInPayOnlineType").val(keyInPayType);
    	formList = $("#onlineSearchForm").serializeArray();
    }
    
    //array에 담기
    if(gridList.length > 0) {
        data.all = gridList;
    }  else {
        Common.alert("There is no Payment Key-In Row Data");
        return;
    }
        
    if(formList.length > 0) data.form = formList;
    else data.form = [];
    
    Common.ajax("POST", "/payment/saveAdvPayment.do", data, function(result) {
        
        var message = "<b>Success Payment Process<br><br></b>";
        
        if(result != null && result.length > 0){
            for(i=0 ; i < result.length ; i++){
                message += "<font color='red'>" + result[i].orNo + "</font><br>";
            }
        }
        
        Common.alert(message, function(){
              document.location.href = '/payment/initAdvPayment.do';
        });
        
    });
}


//전체 Payment Amount 계산
function recalculatePaymentTotalAmt(){
  var rowCnt = AUIGrid.getRowCount(targetFinalBillGridID);
  var totalAmt = 0;

  if(rowCnt > 0){
      for(var i = 0; i < rowCnt; i++){
          totalAmt += AUIGrid.getCellValue(targetFinalBillGridID, i ,"targetAmt");
      }
  }

  $("#paymentTotalAmtTxt").text("RM " + $.number(totalAmt,2));    
}

//추가된 최종 그리드 삭제
function removeFromFinal(){
    
    if (selectedGridValue  > -1){
        Common.confirm('Are you sure you want to remove the Selected Row?'
        ,function (){
            //csv 파일이 header가 있는 파일이면 첫번째 행(header)은 삭제한다.
            AUIGrid.removeRow(targetFinalBillGridID,selectedGridValue);
            selectedGridValue = -1;
            
            recalculatePaymentTotalAmt();
        });
    }else{
        Common.alert('<b>Please Select a ROW to remove from the Payment Key-In Grid</b>');
    }
}

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
    var mstRowCnt = AUIGrid.getRowCount(targetRenMstGridID);
    var totalAmt = Number(0.00);
    
    if(advMonth != '' && advMonth > 0){     //advMonth가 입력되어 있는 경우
        rentalDiscountValue();
    } else{                                             //advMonth가 입력되어 있지 않은 경우       
        
        if(mstRowCnt > 0){
            for(var i = 0; i < mstRowCnt; i++){
                  
                mstBtnCheck = AUIGrid.getCellValue(targetRenMstGridID,i,"btnCheck");     //마스터 그리드에서 orderNo
                mstOrdNo = AUIGrid.getCellValue(targetRenMstGridID,i,"salesOrdNo");     //마스터 그리드에서 orderNo
                rpf = AUIGrid.getCellValue(targetRenMstGridID,i,"rpf");
                rpfPaid = AUIGrid.getCellValue(targetRenMstGridID,i,"rpfPaid");
                balance = AUIGrid.getCellValue(targetRenMstGridID,i,"balance");
                
                if(mstBtnCheck == 1){

                    var rpfTarget = 0;

                    if (rpf > rpfPaid) rpfTarget = rpf - rpfPaid;

                    if(balance >= 0){
                           totalAmt += rpfTarget;

                            //상세 그리드에서  마스터 그리드의 orderNo와 동일한 orderNo row만 조회한다. 
                            var rows = AUIGrid.getRowsByValue(targetRenDetGridID, "ordNo", mstOrdNo);

                            for(var j = 0; j < rows.length; j++){
                                var obj = rows[j];
                        
                                if(obj.btnCheck == 1){
                                    totalAmt += obj.targetAmt; 
                                }
                           }
                     }
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
            
            mstBtnCheck = AUIGrid.getCellValue(targetRenMstGridID,i,"btnCheck");     //마스터 그리드에서 orderNo
            mstOrdNo = AUIGrid.getCellValue(targetRenMstGridID,i,"salesOrdNo");     //마스터 그리드에서 orderNo
            rpf = AUIGrid.getCellValue(targetRenMstGridID,i,"rpf");
            rpfPaid = AUIGrid.getCellValue(targetRenMstGridID,i,"rpfPaid");
            balance = AUIGrid.getCellValue(targetRenMstGridID,i,"balance");

            if(mstBtnCheck == 1){
                var rpfTarget = 0;
    
                if (rpf > rpfPaid) rpfTarget = rpf - rpfPaid;
    
                if(balance >= 0){
                    tot += rpfTarget;
    
                    //상세 그리드에서  마스터 그리드의 orderNo와 동일한 orderNo row만 조회한다. 
                    var rows = AUIGrid.getRowsByValue(targetRenDetGridID, "ordNo", mstOrdNo);
    
                    for(var j = 0; j < rows.length; j++){
                        var obj = rows[j];
                        
                        if(obj.btnCheck == 1){
                            tot += obj.targetAmt; 
                        }
                    }
                }
            }
        }
    }

    var grandtotal = tot + discountValue;
    $("#rentalAdvAmt").val(discountValue);
    
    if (tot > 0) {
        $("#rentalTotalAmtTxt").text("RM " + $.number(tot,2) + " + (RM " + $.number(originalPrice,2)  + " - " + discountrate + "%) = RM " + $.number(grandtotal,2));
    } else {
        $("#rentalTotalAmtTxt").text("(RM " + $.number(originalPrice,2) + " - " + discountrate + "%) = RM " + $.number(grandtotal,2));
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
    
    //Rental Adv Month가 0보다 크면 billing group 선택못합
    if($("#rentalTxtAdvMonth").val() != '' && $("#rentalTxtAdvMonth").val() > 0){
        $("#isRentalBillGroup").attr("checked", false);
        $("#isRentalBillGroup").attr("disabled", true); 
        
        if($("#rentalOrdNo").val() != ''){
            fn_rentalConfirm();
        }
    }else{
        $("#isRentalBillGroup").attr("disabled", false);
        recalculateRentalTotalAmt(); 
    }
}


//Advance Month 변경시 이벤트
function fn_rentalAdvMonthChangeTxt(){
  //Rental Membership Adv Month가 0보다 크면 billing group 선택못합
  if($("#rentalTxtAdvMonth").val() != '' && $("#rentalTxtAdvMonth").val() > 0){
      $("#isRentalBillGroup").attr("checked", false);
      $("#isRentalBillGroup").attr("disabled", true);
      
      if($("#rentalOrdNo").val() != ''){
          fn_rentalConfirm();
      }
  }else{
      $("#isRentalBillGroup").attr("disabled", false);
      recalculateRentalTotalAmt();  
  }
}



function addRentalToFinal(){
	var addedCount = 0;
    var rowCnt = AUIGrid.getRowCount(targetRenMstGridID);
    maxSeq = maxSeq + 1;

    if(rowCnt > 0){
        for(i = 0 ; i < rowCnt ; i++){

            var mstChkVal = AUIGrid.getCellValue(targetRenMstGridID, i ,"btnCheck");
            var mstSalesOrdNo = AUIGrid.getCellValue(targetRenMstGridID, i ,"salesOrdNo");            
            var mstRpf = AUIGrid.getCellValue(targetRenMstGridID, i ,"rpf");
            var mstRpfPaid = AUIGrid.getCellValue(targetRenMstGridID, i ,"rpfPaid");
            
            var mstCustNm = AUIGrid.getCellValue(targetRenMstGridID, i ,"custNm");
            var mstCustBillId = AUIGrid.getCellValue(targetRenMstGridID, i ,"custBillId");

            if(mstChkVal == 1){
                if(mstRpf - mstRpfPaid > 0){
                     var item = new Object();
                     
                     item.procSeq = maxSeq;
                     item.appType = "RENTAL";
                     item.advMonth =$("#rentalTxtAdvMonth").val();
                     item.mstRpf = mstRpf;
                     item.mstRpfPaid = mstRpfPaid;
                     
                     item.assignAmt = 0;
                     item.billAmt   = mstRpf;
                     item.billDt   = "1900-01-01";
                     item.billGrpId = mstCustBillId;
                     item.billId = 0;
                     item.billNo = "0";
                     item.billStatus = "";
                     item.billTypeId = 161;
                     item.billTypeNm   = "RPF";
                     item.custNm   = mstCustNm;
                     item.discountAmt = 0;
                     item.installment  = 0;
                     item.ordId = AUIGrid.getCellValue(targetRenMstGridID, i ,"salesOrdId");
                     item.ordNo = mstSalesOrdNo;
                     item.paidAmt     = mstRpfPaid;
                     item.targetAmt   = mstRpf - mstRpfPaid;
                     item.srvcContractID   = 0;
                     item.billAsId    = 0;
                     
                     AUIGrid.addRow(targetFinalBillGridID, item, "last");
                     
                     addedCount++;
                    
                }
                
                var detailRowCnt = AUIGrid.getRowCount(targetRenDetGridID);
                for(j = 0 ; j < detailRowCnt ; j++){
                    var detChkVal = AUIGrid.getCellValue(targetRenDetGridID, j ,"btnCheck");
                    var detSalesOrdNo = AUIGrid.getCellValue(targetRenDetGridID, j ,"ordNo");

                    if(mstSalesOrdNo == detSalesOrdNo && detChkVal == 1){
                        var item = new Object();
                        
                        item.procSeq = maxSeq;
                        item.appType = "RENTAL";
                        item.advMonth =$("#rentalTxtAdvMonth").val();
                        item.mstRpf = mstRpf;
                        item.mstRpfPaid = mstRpfPaid;
                        
                        item.assignAmt = 0;
                        item.billAmt   = AUIGrid.getCellValue(targetRenDetGridID, j ,"billAmt");
                        item.billDt   = AUIGrid.getCellValue(targetRenDetGridID, j ,"billDt");
                        item.billGrpId = AUIGrid.getCellValue(targetRenDetGridID, j ,"billGrpId");
                        item.billId = AUIGrid.getCellValue(targetRenDetGridID, j ,"billId");
                        item.billNo = AUIGrid.getCellValue(targetRenDetGridID, j ,"billNo");                        
                        item.billStatus = AUIGrid.getCellValue(targetRenDetGridID, j ,"stusCode");   
                        item.billTypeId = AUIGrid.getCellValue(targetRenDetGridID, j ,"billTypeId");   
                        item.billTypeNm   = AUIGrid.getCellValue(targetRenDetGridID, j ,"billTypeNm");
                        item.custNm   = AUIGrid.getCellValue(targetRenDetGridID, j ,"custNm");
                        item.discountAmt = 0;
                        item.installment  = AUIGrid.getCellValue(targetRenDetGridID, j ,"installment");                        
                        item.ordId = AUIGrid.getCellValue(targetRenDetGridID, j ,"ordId");
                        item.ordNo = AUIGrid.getCellValue(targetRenDetGridID, j ,"ordNo");
                        item.paidAmt     = AUIGrid.getCellValue(targetRenDetGridID, j ,"paidAmt");
                        item.targetAmt   = AUIGrid.getCellValue(targetRenDetGridID, j ,"targetAmt");
                        item.srvcContractID   = 0;
                        item.billAsId    = 0;

                        AUIGrid.addRow(targetFinalBillGridID, item, "last");
                        
                        addedCount++;
                    }
                }
                
                //Advance Month 
                if($("#rentalTxtAdvMonth").val() != '' && $("#rentalTxtAdvMonth").val() > 0){
                    var item = new Object();
                    
                    item.procSeq = maxSeq;
                    item.appType = "RENTAL";
                    item.advMonth =$("#rentalTxtAdvMonth").val();
                    item.mstRpf = mstRpf;
                    item.mstRpfPaid = mstRpfPaid;
                    
                    item.assignAmt = 0;
                    item.billAmt   = $("#rentalAdvAmt").val();
                    item.billDt   = "1900-01-01";
                    item.billGrpId = mstCustBillId;
                    item.billId = 0;
                    item.billNo = "0";
                    item.billStatus = "";
                    item.billTypeId = 1032;
                    item.billTypeNm   = "General Advanced For Rental";
                    item.custNm   = mstCustNm;
                    item.discountAmt = 0;
                    item.installment  = 0;
                    item.ordId = AUIGrid.getCellValue(targetRenMstGridID, i ,"salesOrdId");
                    item.ordNo = mstSalesOrdNo;
                    item.paidAmt     = 0;
                    item.targetAmt   = $("#rentalAdvAmt").val();
                    item.srvcContractID   = 0;
                    item.billAsId    = 0;
                    
                    AUIGrid.addRow(targetFinalBillGridID, item, "last");
                    
                    addedCount++;
                   
               }
            }
        }
    }
    
    if(addedCount == 0){
        Common.alert("There is no billing data and can not be selected.");
    }
    
    recalculatePaymentTotalAmt();
}

function viewRentalLedger(){
    if($("#rentalOrdId").val() != ''){
        Common.popupDiv("/sales/order/orderLedgerViewPop.do", {ordId : $("#rentalOrdId").val()});
    }else{
        Common.alert('<b>Please Select a Order Info first</b>');
        return;
    }
        
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


function addOutToFinal(){
	var addedCount = 0;
    var rowCnt = AUIGrid.getRowCount(targetOutMstGridID);    
    maxSeq = maxSeq + 1;

    if(rowCnt > 0){
        for(i = 0 ; i < rowCnt ; i++){
            
            var targetAmt = AUIGrid.getCellValue(targetOutMstGridID, i ,"balance");
            
            if(targetAmt > 0){
                var item = new Object();
                
                item.procSeq = maxSeq;
                item.appType = "OUT";
                item.advMonth = 0;
                item.mstRpf = 0;
                item.mstRpfPaid = 0;
                
                item.assignAmt = 0;
                item.billAmt   = AUIGrid.getCellValue(targetOutMstGridID, i ,"productPrice");
                item.billDt   = "1900-01-01";
                item.billGrpId = 0;
                item.billId = 0;
                item.billNo = 0;                        
                item.billStatus = "";   
                item.billTypeId = "";   
                item.billTypeNm   = AUIGrid.getCellValue(targetOutMstGridID, i ,"appTypeNm"); 
                item.custNm   = AUIGrid.getCellValue(targetOutMstGridID, i ,"custNm");
                item.discountAmt = 0;
                item.installment  = 0;                        
                item.ordId = AUIGrid.getCellValue(targetOutMstGridID, i ,"salesOrdId");
                item.ordNo = AUIGrid.getCellValue(targetOutMstGridID, i ,"salesOrdNo");
                item.paidAmt     = AUIGrid.getCellValue(targetOutMstGridID, i ,"totalPaid");
                item.targetAmt   = AUIGrid.getCellValue(targetOutMstGridID, i ,"balance");
                item.srvcContractID   = 0;
                item.billAsId    = 0;
                
                AUIGrid.addRow(targetFinalBillGridID, item, "last");
                
                addedCount++;
            }
        }
    } 
    
    if(addedCount == 0){
        Common.alert("There is no billing data and can not be selected.");
    }
    
    recalculatePaymentTotalAmt();
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
function fn_callBackSrvcOrderInfo(srvCntrctId, salesOrdId,srvCntrctRefNo,custBillId){
    $('#srvcOrdId').val(salesOrdId);
    $('#srvcId').val(srvCntrctId);
    $('#srvcNo').val(srvCntrctRefNo);
    $('#srvcCustBillId').val(custBillId);
    
    //팝업 숨기기 및 remove
    $('#_serviceContract').hide();
    $('#_serviceContract').remove();
    
    //Order Info 및 Payment Info 조회
    fn_srvcOrderInfo();
}

//Rental Mebership Order Info 조회
function fn_srvcOrderInfo(){
    //Rental Membership Grid Clear 처리
    resetSrvcGrid();
       
    var data; 
    
    if($("#isSrvcBillGroup").is(":checked")){
        data = {"billGrpId" : $("#srvcCustBillId").val() };
    }else{      
        data = {"srvcId" : $("#srvcId").val() };
    }
    
    //Rental Membership : Order 정보 조회
    Common.ajax("GET", "/payment/common/selectOrderInfoSrvc.do", data, function(result) {
        //Rental Membership : Order Info 세팅
        AUIGrid.setGridData(targetSrvcMstGridID, result);
    
        //Rental Membership : Billing Info 조회
        fn_srvcBillingInfoRental();
    });
}
  

//Rental Membership  : Bill Info 조회
function fn_srvcBillingInfoRental(){

    var rowCnt = AUIGrid.getRowCount(targetSrvcMstGridID);

    if(rowCnt > 0){
        for(i = 0 ; i < rowCnt ; i++){
            var srvCntrctId = AUIGrid.getCellValue(targetSrvcMstGridID, i ,"srvCntrctId");

            //Rental Membership : Bill 정보 조회
            Common.ajax("GET", "/payment/common/selectBillInfoSrvc.do", {"srvCntrctId" : srvCntrctId , "excludeFilterCharges" : "Y" , "excludePenaltyCharges" : "Y"}, function(result) {
                //Rental Membership : Bill Info 세팅
                AUIGrid.appendData(targetSrvcDetGridID, result);
                
                recalculateSrvcTotalAmt();
            });
        }
    }
}

function resetSrvcGrid(){
    AUIGrid.clearGridData(targetSrvcMstGridID);
    AUIGrid.clearGridData(targetSrvcDetGridID);
}

//Rental Membership Amount 계산
function recalculateSrvcTotalAmt(){
    var advMonth = $("#srvcTxtAdvMonth").val();
    var totalAmt = Number(0.00);
    var srvCntrctRefNo = 0;
    var filterCharge = 0;
    var filterChargePaid = 0;
    var penaltyCharges = 0;
    var penaltyChargesPaid = 0;

    if(advMonth != '' && advMonth > 0){     //advMonth가 입력되어 있는 경우
        srvcDiscountValue();
    } else{                                             //advMonth가 입력되어 있지 않은 경우

        var mstRowCnt = AUIGrid.getRowCount(targetSrvcMstGridID);

        if(mstRowCnt > 0){
            for(var i = 0; i < mstRowCnt; i++){
                if(AUIGrid.getCellValue(targetSrvcMstGridID, i ,"btnCheck") == 1){

                    srvCntrctRefNo = AUIGrid.getCellValue(targetSrvcMstGridID,i,"srvCntrctRefNo");     //마스터 그리드에서 Service Contract Reference No
                    filterCharge = AUIGrid.getCellValue(targetSrvcMstGridID, i ,"filterCharges");
                    filterChargePaid = AUIGrid.getCellValue(targetSrvcMstGridID, i ,"filterChargesPaid");                 

                    if(filterCharge > filterChargePaid){
                        totalAmt += filterCharge - filterChargePaid;
                    }

                    penaltyCharges = AUIGrid.getCellValue(targetSrvcMstGridID, i ,"penaltyCharges");
                    penaltyChargesPaid = AUIGrid.getCellValue(targetSrvcMstGridID, i ,"penaltyChargesPaid");

                    if(penaltyCharges > penaltyChargesPaid){
                        totalAmt += penaltyCharges - penaltyChargesPaid;
                    } 

                    //상세 그리드에서  마스터 그리드의 orderNo와 동일한 orderNo row만 조회한다.
                    var rows = AUIGrid.getRowsByValue(targetSrvcDetGridID, "srvCntrctRefNo", srvCntrctRefNo);

                    for(var j = 0; j < rows.length; j++){
                        var obj = rows[j];
                        if(obj.btnCheck == 1){
                            totalAmt += obj.targetAmt; 
                        }
                    }
                }
            }
        }

        $("#srvcTotalAmtTxt").text("RM " + $.number(totalAmt,2));        
    }
}


//선택된 Master Grid 데이터의 Slave 데이터 건을 Bold 처리함
function srvcChangeRowStyleFunction(srvCntrctRefNo) {
  // row Styling 함수를 다른 함수로 변경
  AUIGrid.setProp(targetSrvcDetGridID, "rowStyleFunction", function(rowIndex, item) {
      if(item.srvCntrctRefNo == srvCntrctRefNo) {
          return "my-row-style";
      }
      return "";
  });
  
  // 변경된 rowStyleFunction 이 적용되도록 그리드 업데이트
  AUIGrid.update(targetSrvcDetGridID);
};


function srvcCheckBillGroup(){
    if($("#srvcId").val() != ''){
        fn_srvcOrderInfo();
    }
}


//Advance Month 변경시 이벤트
function fn_srvcAdvMonth(){    
  var advMonth = $("#srvcAdvMonthType").val();
  
  if(advMonth == 99 ){
      $("#srvcTxtAdvMonth").val(1);
      $('#srvcTxtAdvMonth').removeClass("readonly");
      $("#srvcTxtAdvMonth").prop("readonly",false);
  }else{
      $("#srvcTxtAdvMonth").val(advMonth);
      $('#srvcTxtAdvMonth').addClass("readonly");
      $("#srvcTxtAdvMonth").prop("readonly",true);
  }
  
  //Rental Membership Adv Month가 0보다 크면 billing group 선택못합
  if($("#srvcTxtAdvMonth").val() != '' && $("#srvcTxtAdvMonth").val() > 0){
      $("#isSrvcBillGroup").attr("checked", false);
      $("#isSrvcBillGroup").attr("disabled", true); 
      
      if($("#srvcId").val() != ''){
          fn_srvcOrderInfo();
      }
  }else{
      $("#isSrvcBillGroup").attr("disabled", false);
      recalculateSrvcTotalAmt();  
  }
}


//Advance Month 변경시 이벤트
function fn_srvcAdvMonthChangeTxt(){
    //Rental Membership Adv Month가 0보다 크면 billing group 선택못합
    if($("#srvcTxtAdvMonth").val() != '' && $("#srvcTxtAdvMonth").val() > 0){
        $("#isSrvcBillGroup").attr("checked", false);
        $("#isSrvcBillGroup").attr("disabled", true);
        
        if($("#srvcId").val() != ''){
            fn_srvcOrderInfo();
        }
    }else{
        $("#isSrvcBillGroup").attr("disabled", false);
        recalculateSrvcTotalAmt();  
    }
}


//Rental Membership Amount 선납금 할인율 적용
function srvcDiscountValue(){
    var discountValue = 0.0;
    var discountrate = 0;
    var originalprice = 0.0;

    //Advance Specification 관련 금액 계산
    var advMonth = $("#srvcTxtAdvMonth").val();    
    var rows = AUIGrid.getRowIndexesByValue(targetSrvcMstGridID, "srvCntrctId", $("#srvcId").val());
    var srvCntrctRental = AUIGrid.getCellValue(targetSrvcMstGridID, rows, "srvCntrctRental");    
    
    if (advMonth >= 12 && advMonth < 24) {
        discountValue = srvCntrctRental * advMonth * 0.95;
        originalprice = srvCntrctRental * advMonth;
        discountrate = 5;
    } else if (advMonth >= 24 && advMonth < 61) {
        discountValue = srvCntrctRental * advMonth * 0.9;
        originalprice = srvCntrctRental * advMonth;
        discountrate = 10;
    } else {
        discountValue = srvCntrctRental * advMonth;
        originalprice = srvCntrctRental * advMonth;
        discountrate = 0;
    }
    
    //선납금 할인을 적용한 금액 표시
    recalculateSrvcTotalAmtWidthAdv(discountValue,originalprice,discountrate);
}

//Rental Membership Amount 선납금 할인을 적용한 금액 표시
function recalculateSrvcTotalAmtWidthAdv(discountValue, originalPrice, discountrate) {
    
    var mstRowCnt = AUIGrid.getRowCount(targetSrvcMstGridID);
    var tot = Number(0.00);
    
    var srvCntrctRefNo = 0;
    var filterCharge = 0;
    var filterChargePaid = 0;
    var penaltyCharges = 0;
    var penaltyChargesPaid = 0;    

    if(mstRowCnt > 0){
        for(var i = 0; i < mstRowCnt; i++){
            if(AUIGrid.getCellValue(targetSrvcMstGridID, i ,"btnCheck") == 1){

                srvCntrctRefNo = AUIGrid.getCellValue(targetSrvcMstGridID,i,"srvCntrctRefNo");     //마스터 그리드에서 Service Contract Reference No
                filterCharge = AUIGrid.getCellValue(targetSrvcMstGridID, i ,"filterCharges");
                filterChargePaid = AUIGrid.getCellValue(targetSrvcMstGridID, i ,"filterChargesPaid");                 

                if(filterCharge > filterChargePaid){
                    tot += filterCharge - filterChargePaid;
                }

                penaltyCharges = AUIGrid.getCellValue(targetSrvcMstGridID, i ,"penaltyCharges");
                penaltyChargesPaid = AUIGrid.getCellValue(targetSrvcMstGridID, i ,"penaltyChargesPaid");

                if(penaltyCharges > penaltyChargesPaid){
                    tot += penaltyCharges - penaltyChargesPaid;
                } 

                //상세 그리드에서  마스터 그리드의 orderNo와 동일한 orderNo row만 조회한다.
                var rows = AUIGrid.getRowsByValue(targetSrvcDetGridID, "srvCntrctRefNo", srvCntrctRefNo);

                for(var j = 0; j < rows.length; j++){
                    var obj = rows[j];
                    if(obj.btnCheck == 1){
                        tot += obj.targetAmt; 
                    }
                }
            }
        }
    }

    var grandtotal = tot + discountValue;    
    $("#srvcAdvAmt").val(discountValue);
    
    if (tot > 0) {
        $("#srvcTotalAmtTxt").text("RM " + $.number(tot,2) + " + (RM " + $.number(originalPrice,2)  + " - " + discountrate + "%) = RM " + $.number(grandtotal,2));
    } else {
        $("#srvcTotalAmtTxt").text("(RM " + $.number(originalPrice,2) + " - " + discountrate + "%) = RM " + $.number(grandtotal,2));
    }
}




function addSrvcToFinal(){
	var addedCount = 0;
    var rowCnt = AUIGrid.getRowCount(targetSrvcMstGridID);
    maxSeq = maxSeq + 1;
    
    if(rowCnt > 0){
        for(i = 0 ; i < rowCnt ; i++){

            var mstChkVal = AUIGrid.getCellValue(targetSrvcMstGridID, i ,"btnCheck");
            var mstSrvCntrctRefNo = AUIGrid.getCellValue(targetSrvcMstGridID, i ,"srvCntrctRefNo");
            var mstFilterCharges = AUIGrid.getCellValue(targetSrvcMstGridID, i ,"filterCharges");
            var mstFilterChargesPaid = AUIGrid.getCellValue(targetSrvcMstGridID, i ,"filterChargesPaid");            
            var mstPenaltyCharges = AUIGrid.getCellValue(targetSrvcMstGridID, i ,"penaltyCharges");
            var mstPenaltyChargesPaid = AUIGrid.getCellValue(targetSrvcMstGridID, i ,"penaltyChargesPaid");            
            var custBillId = AUIGrid.getCellValue(targetSrvcMstGridID, i ,"custBillId");
            var custNm = AUIGrid.getCellValue(targetSrvcMstGridID, i ,"custName");
            
            if(mstChkVal == 1){
                if(mstFilterCharges - mstFilterChargesPaid > 0){
                     var item = new Object();
                     
                     item.procSeq = maxSeq;
                     item.appType = "MEMBERSHIP";
                     item.advMonth =$("#srvcTxtAdvMonth").val();
                     item.mstRpf = 0;
                     item.mstRpfPaid = 0;
                     
                     item.assignAmt = 0;
                     item.billAmt   = mstFilterCharges;
                     item.billDt   = "1900-01-01";
                     item.billGrpId = custBillId;
                     item.billId = 0;
                     item.billNo = ""; 
                     item.billStatus = AUIGrid.getCellValue(targetSrvcMstGridID, i ,"cntrctRentalStus");
                     item.billTypeId = 1307;
                     item.billTypeNm   = "Service Contract BS";
                     item.custNm   = custNm;
                     item.discountAmt = 0;
                     item.installment  = 0;
                     item.ordId = AUIGrid.getCellValue(targetSrvcMstGridID, i ,"salesOrdId");
                     item.ordNo = AUIGrid.getCellValue(targetSrvcMstGridID, i ,"salesOrdNo");
                     item.paidAmt     = mstFilterChargesPaid;
                     item.targetAmt   = mstFilterCharges - mstFilterChargesPaid;
                     item.srvcContractID   = AUIGrid.getCellValue(targetSrvcMstGridID, i ,"srvCntrctId");
                     item.billAsId    = 0;
                     
                     AUIGrid.addRow(targetFinalBillGridID, item, "last");
                     
                     addedCount++;
                }
                
                if(mstPenaltyCharges - mstPenaltyChargesPaid > 0){
                    var item = new Object();
                    
                    item.procSeq = maxSeq;
                    item.appType = "MEMBERSHIP";
                    item.advMonth =$("#srvcTxtAdvMonth").val();
                    item.mstRpf = 0;
                    item.mstRpfPaid = 0;
                    
                    item.assignAmt = 0;
                    item.billAmt   = mstPenaltyCharges;
                    item.billDt   = "1900-01-01";
                    item.billGrpId = custBillId;
                    item.billId = 0;
                    item.billNo = "";
                    item.billStatus = AUIGrid.getCellValue(targetSrvcMstGridID, i ,"cntrctRentalStus");
                    item.billTypeId = 1306;
                    item.billTypeNm   = "Service Contract Penalty";
                    item.custNm   = custNm;
                    item.discountAmt = 0;
                    item.installment  = 0;
                    item.ordId = AUIGrid.getCellValue(targetSrvcMstGridID, i ,"salesOrdId");
                    item.ordNo = AUIGrid.getCellValue(targetSrvcMstGridID, i ,"salesOrdNo");
                    item.paidAmt     = mstPenaltyChargesPaid;
                    item.targetAmt   = mstPenaltyCharges - mstPenaltyChargesPaid;
                    item.srvcContractID   = AUIGrid.getCellValue(targetSrvcMstGridID, i ,"srvCntrctId");
                    item.billAsId    = 0;
                    
                    AUIGrid.addRow(targetFinalBillGridID, item, "last");
                    
                    addedCount++;
               }
                
                //Advance Month 
                if($("#srvcTxtAdvMonth").val() != '' && $("#srvcTxtAdvMonth").val() > 0){
                    var item = new Object();
                    
                    item.procSeq = maxSeq;
                    item.appType = "MEMBERSHIP";
                    item.advMonth =$("#srvcTxtAdvMonth").val();
                    item.mstRpf = 0;
                    item.mstRpfPaid = 0;
                    
                    item.assignAmt = 0;
                    item.billAmt   = $("#srvcAdvAmt").val();
                    item.billDt   = "1900-01-01";
                    item.billGrpId = custBillId;
                    item.billId = 0;
                    item.billNo = "";
                    item.billStatus = AUIGrid.getCellValue(targetSrvcMstGridID, i ,"cntrctRentalStus");
                    item.billTypeId = 154;
                    item.billTypeNm   = "Advanced";
                    item.custNm   = custNm;
                    item.discountAmt = 0;
                    item.installment  = 0;
                    item.ordId = AUIGrid.getCellValue(targetSrvcMstGridID, i ,"salesOrdId");
                    item.ordNo = AUIGrid.getCellValue(targetSrvcMstGridID, i ,"salesOrdNo");
                    item.paidAmt     = 0;
                    item.targetAmt   = $("#srvcAdvAmt").val();
                    item.srvcContractID   = AUIGrid.getCellValue(targetSrvcMstGridID, i ,"srvCntrctId");
                    item.billAsId    = 0;
                    
                    AUIGrid.addRow(targetFinalBillGridID, item, "last");
                    
                    addedCount++;
                   
               }
                
                var detailRowCnt = AUIGrid.getRowCount(targetSrvcDetGridID);
                for(j = 0 ; j < detailRowCnt ; j++){
                    var detChkVal = AUIGrid.getCellValue(targetSrvcDetGridID, j ,"btnCheck");
                    var detSrvCntrctRefNo = AUIGrid.getCellValue(targetSrvcDetGridID, j ,"srvCntrctRefNo");

                    if(mstSrvCntrctRefNo == detSrvCntrctRefNo && detChkVal == 1){
                        var item = new Object();
                        
                        item.procSeq = maxSeq;
                        item.appType = "MEMBERSHIP";
                        item.advMonth =$("#srvcTxtAdvMonth").val();
                        item.mstRpf = 0;
                        item.mstRpfPaid = 0;
                        
                        item.assignAmt = 0;
                        item.billAmt   = AUIGrid.getCellValue(targetSrvcDetGridID, j ,"srvLdgrAmt");
                        item.billDt   = AUIGrid.getCellValue(targetSrvcDetGridID, j ,"srvLdgrRefDt");
                        item.billGrpId = custBillId;
                        item.billId = 0;
                        item.billNo = AUIGrid.getCellValue(targetSrvcDetGridID, j ,"srvLdgrRefNo");                        
                        //item.billStatus = AUIGrid.getCellValue(targetSrvcDetGridID, j ,"stusCode");   
                        item.billTypeId = AUIGrid.getCellValue(targetSrvcDetGridID, j ,"srvLdgrTypeId");   
                        item.billTypeNm   = AUIGrid.getCellValue(targetSrvcDetGridID, j ,"srvLdgrTypeNm");
                        item.custNm   = custNm;
                        item.discountAmt = 0;
                        item.installment  = AUIGrid.getCellValue(targetSrvcDetGridID, j ,"srvPaySchdulNo");                        
                        item.ordId = AUIGrid.getCellValue(targetSrvcDetGridID, j ,"srvCntrctOrdId");
                        item.ordNo = AUIGrid.getCellValue(targetSrvcDetGridID, j ,"salesOrdNo");
                        item.paidAmt     = AUIGrid.getCellValue(targetSrvcDetGridID, j ,"paidTotal");
                        item.targetAmt   = AUIGrid.getCellValue(targetSrvcDetGridID, j ,"targetAmt");
                        item.srvcContractID   = AUIGrid.getCellValue(targetSrvcDetGridID, j ,"srvLdgrCntrctId");
                        item.billAsId    = 0;

                        AUIGrid.addRow(targetFinalBillGridID, item, "last");
                        
                        addedCount++;
                    }
                }
            }
        }
    }
    
    if(addedCount == 0){
        Common.alert("There is no billing data and can not be selected.");
    }
    
    recalculatePaymentTotalAmt();  
}

function viewSrvcLedger(){
    if($("#srvcOrdId").val() != ''){
        Common.popupDiv("/sales/order/orderLedgerViewPop.do", {ordId : $("#srvcOrdId").val()});
    }else{
        Common.alert('<b>Please Select a Order Info first</b>');
        return;
    }
        
}

//**************************************************
//**************************************************
//Bill Payment  관련 Script 
//**************************************************
//**************************************************
function fn_changeBillType(){
    
    if($("#billType").val() == 1){
        AUIGrid.hideColumnByDataField(targetBillMstGridID, "billMemNm" );
        AUIGrid.hideColumnByDataField(targetBillMstGridID, "billMemCode" );
        AUIGrid.showColumnByDataField(targetBillMstGridID, "custNm");
        AUIGrid.showColumnByDataField(targetBillMstGridID, "nric");
        
    }else{
        AUIGrid.showColumnByDataField(targetBillMstGridID, "billMemNm" );
        AUIGrid.showColumnByDataField(targetBillMstGridID, "billMemCode" );
        AUIGrid.hideColumnByDataField(targetBillMstGridID, "custNm");
        AUIGrid.hideColumnByDataField(targetBillMstGridID, "nric");
    }  
}


function fn_billOrderSearch(){
    
    if(FormUtil.checkReqValue($("#billSearchTxt"))){
        Common.alert("Please Key-In Search Keywords");
        return;
    }
    
    //Bill Payment : Order 정보 조회
    Common.ajax("GET", "/payment/common/selectOrderInfoBillPayment.do", $("#billSearchForm").serialize(), function(result) {
        //Bill Payment : Order Info 세팅
        AUIGrid.setGridData(targetBillMstGridID, result);
    
      //총 금액 계산
        recalculateBillTotalAmt();
    });    
}
    
//Bill Payment Amount 계산
function recalculateBillTotalAmt(){
    var rowCnt = AUIGrid.getRowCount(targetBillMstGridID);
    var totalAmt = 0;

    if(rowCnt > 0){
        for(var i = 0; i < rowCnt; i++){
            if(AUIGrid.getCellValue(targetBillMstGridID, i ,"btnCheck") == 1){
                totalAmt += AUIGrid.getCellValue(targetBillMstGridID, i ,"billAmt") - AUIGrid.getCellValue(targetBillMstGridID, i ,"paidAmt");
            }
        }
    }

    $("#billTotalAmtTxt").text("RM " + $.number(totalAmt,2));    
}

function resetBillGrid(){
    AUIGrid.clearGridData(targetBillMstGridID);
}

function addBillToFinal(){
	var addedCount = 0;
    var checkArray = AUIGrid.getItemsByValue(targetBillMstGridID,"btnCheck","1");

    if(checkArray.length > 1){
        Common.alert("Bill Payment is allowed for only one bill. Exclude other bills excepting target one bill.");
        return;     
    }else{      
        var rowCnt = AUIGrid.getRowCount(targetBillMstGridID);      
        maxSeq = maxSeq + 1;

        if(rowCnt > 0){
            for(i = 0 ; i < rowCnt ; i++){
                if(AUIGrid.getCellValue(targetBillMstGridID, i ,"btnCheck") == 1){
                    var targetAmt = AUIGrid.getCellValue(targetBillMstGridID, i ,"billAmt") - AUIGrid.getCellValue(targetBillMstGridID, i ,"paidAmt");

                    if(targetAmt > 0){
                        var item = new Object();

                        item.procSeq = maxSeq;
                        item.appType = AUIGrid.getCellValue(targetBillMstGridID, i ,"appType");
                        item.advMonth = 0;
                        item.mstRpf = 0;
                        item.mstRpfPaid = 0;

                        item.assignAmt = 0;
                        item.billAmt   = AUIGrid.getCellValue(targetBillMstGridID, i ,"billAmt");
                        item.billDt   = AUIGrid.getCellValue(targetBillMstGridID, i ,"billDt");
                        item.billGrpId = 0;
                        item.billId = AUIGrid.getCellValue(targetBillMstGridID, i ,"billId");
                        item.billNo = AUIGrid.getCellValue(targetBillMstGridID, i ,"billNo");                      
                        item.billStatus = AUIGrid.getCellValue(targetBillMstGridID, i ,"stusNm");   
                        item.billTypeId = AUIGrid.getCellValue(targetBillMstGridID, i ,"billTypeId");    
                        item.billTypeNm   = AUIGrid.getCellValue(targetBillMstGridID, i ,"billTypeNm"); 
                        item.custNm   = AUIGrid.getCellValue(targetBillMstGridID, i ,"custNm");
                        item.discountAmt = 0;
                        item.installment  = 0;                        
                        item.ordId = AUIGrid.getCellValue(targetBillMstGridID, i ,"billSoId");
                        item.ordNo = AUIGrid.getCellValue(targetBillMstGridID, i ,"salesOrdNo");
                        item.paidAmt     = AUIGrid.getCellValue(targetBillMstGridID, i ,"paidAmt");
                        item.targetAmt   = targetAmt;
                        item.srvcContractID   = 0;
                        item.billAsId    = AUIGrid.getCellValue(targetBillMstGridID, i ,"billAsId");

                        AUIGrid.addRow(targetFinalBillGridID, item, "last");
                        
                        addedCount++;
                    }
                }
            }   
        }
        
        if(addedCount == 0){
            Common.alert("There is no billing data and can not be selected.");
        }
        
        recalculatePaymentTotalAmt();
    }
}

function fn_payTypeChange(){
    $("#cashSearchForm")[0].reset();
    $("#chequeSearchForm")[0].reset();
    $("#onlineSearchForm")[0].reset();
    var payType = $("#keyInPayType").val();
    if(payType == "105"){//Cash
        $("#cashSearch").show();
        $("#chequeSearch").hide();
        $("#onlineSearch").hide();
    }else if(payType == "106"){//Cheque
        $("#cashSearch").hide();
        $("#chequeSearch").show();
        $("#onlineSearch").hide();
    }else if(payType == "108"){//Online
        $("#cashSearch").hide();
        $("#chequeSearch").hide();
        $("#onlineSearch").show();
    }
}

function fn_bankChange(bankVal){
    if(bankVal == "CASH"){
        var cashBankType = $("#cashBankType").val();
        $("#cashVAAccount").val('');
        $("#cashBankAcc").val('');
        if(cashBankType != "2730"){
            $("#cashVAAccount").addClass("readonly");
            $("#cashVAAccount").attr('readonly', true);
            $("#cashBankAcc").attr('disabled', false);
            $("#cashBankAcc").removeClass("disabled");
        }else{
            $("#cashVAAccount").removeClass("readonly");
            $("#cashVAAccount").attr('readonly', false);
            $("#cashBankAcc").attr('disabled', true);
            $("#cashBankAcc").addClass("w100p disabled");
        }
    }else if(bankVal == "CHQ"){
        var chequeBankType = $("#chequeBankType").val();
        $("#chequeVAAccount").val('');
        $("#chequeBankAcc").val('');
        if(chequeBankType != "2730"){
            $("#chequeVAAccount").addClass("readonly");
            $("#chequeVAAccount").attr("readonly", true);
            $("#chequeBankAcc").attr('disabled', false);
            $("#chequeBankAcc").removeClass("disabled");
        }else{
            $("#chequeVAAccount").removeClass("readonly");
            $("#chequeVAAccount").attr("readonly", false);
            $("#chequeBankAcc").attr('disabled', true);
            $("#chequeBankAcc").addClass("w100p disabled");
        }
    }else if(bankVal == "ONL"){
        var onlineBankType = $("#onlineBankType").val();
        $("#onlineVAAccount").val('');
        $("#onlineBankAcc").val('');
        if(onlineBankType != "2730"){
            $("#onlineVAAccount").addClass("readonly");
            $("#onlineVAAccount").attr('readonly', true);
            $("#onlineBankAcc").attr('disabled', false);
            $("#onlineBankAcc").removeClass("disabled");
        }else{
            $("#onlineVAAccount").removeClass("readonly");
            $("#onlineVAAccount").attr('readonly', false);
            $("#onlineBankAcc").attr('disabled', true);
            $("#onlineBankAcc").addClass("w100p disabled");
        }
    }
}

//Collector 조회 팝업
function fn_searchUserIdPop(){
    Common.popupDiv("/common/memberPop.do", { callPrgm : "PAYMENT_PROCESS" }, null, true);
}

//Collector 조회 팝업 결과값 세팅
function fn_loadOrderSalesman(memId, memCode, memNm){
	var keyInPayType = $("#keyInPayType").val();
	
	if(keyInPayType == "105"){//Cash
		$("#cashCollMemId").val(memId);
	    $("#cashCollMemNm").val(memNm);
	}else if(keyInPayType == "106"){//Cheque
		$("#chequeCollMemId").val(memId);
	    $("#chequeCollMemNm").val(memNm);
	}else if(keyInPayType == "108"){//Online
		$("#onlineCollMemId").val(memId);
        $("#onlineCollMemNm").val(memNm);
	}
    
}
</script>

<section id="content">
    <ul class="path">
        <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
        <li>Payment</li>
        <li>Advance Key-In</li>
    </ul>

    <!-- title_line start -->
    <aside class="title_line">
        <p class="fav"><a href="#" class="click_add_on">My menu</a></p>
        <h2>Advance Key-In</h2>
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
                        <select id="appType" name="appType" onChange="javascript:fn_chgAppType();">
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
    <section id="rentalSearch">
        <section class="search_table">
            <!-- search_table start -->
            <form id="rentalSearchForm" action="#" method="post">
                <input type="hidden" name="rentalOrdId" id="rentalOrdId" />
                <input type="hidden" name="rentalBillGrpId" id="rentalBillGrpId" />
                <input type="hidden" name="rentalAdvAmt" id="rentalAdvAmt" />
                
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
                                        <a href="javascript:viewRentalLedger();" id="viewLedger">View Ledger</a>
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
                                <input type="text" id="rentalTxtAdvMonth" name="rentalTxtAdvMonth" title="Advance Month" size="3" maxlength="2" class="wAuto ml5 readonly"  readonly onkeydown='return FormUtil.onlyNumber(event)' onblur="javascript:fn_rentalAdvMonthChangeTxt();"/>
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
        
        <ul class="right_btns">
           <li><p class="btn_grid"><a href="javascript:addRentalToFinal();">ADD</a></p></li>
        </ul>

        <!-- grid_wrap start -->
        <article class="grid_wrap mt10">
            <div id="target_rentalD_grid_wrap" style="width: 100%; height: 210px; margin: 0 auto;"></div>
        </article>
        <!-- grid_wrap end -->
        
        <ul class="right_btns">
            <li><p class="amountTotalSttl">Amount Total (RPF + Rental Fee) :</p></li>
            <li><strong id="rentalTotalAmtTxt">RM 0.00</strong></li>
        </ul>
    </section>
    <!-- 
    ***************************************************************************************
    ***************************************************************************************
    *************                                          Outright Search Area                                                         ****
    ***************************************************************************************
    ***************************************************************************************
    -->
    <section id="outSearch" style="display:none;">
        <!-- search_table start -->
        <section class="search_table">
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
        
        <ul class="right_btns">
           <li><p class="btn_grid"><a href="javascript:addOutToFinal();">ADD</a></p></li>
        </ul>
        
        <!-- grid_wrap start -->
        <article class="grid_wrap">
            <div id="target_out_grid_wrap" style="width: 100%; height: 210px; margin: 0 auto;"></div>
        </article>
        <!-- grid_wrap end -->
    
        
        <ul class="right_btns">
            <li><p class="amountTotalSttl">Amount Total :</p></li>
            <li><strong id="outTotalAmtTxt">RM 0.00</strong></li>
        </ul>
    </section>
    
    <!-- 
    ***************************************************************************************
    ***************************************************************************************
    *************                                          Rental Membership Area                                                     ****
    ***************************************************************************************
    ***************************************************************************************
    -->
    <section id="srvcSearch" style="display:none;">
        <!-- search_table start -->
        <section class="search_table">
            <!-- search_table start -->
            <form id="srvcSearchForm" action="#" method="post">
                <input type="hidden" name="srvcOrdId" id="srvcOrdId" />
                <input type="hidden" name="srvcId" id="srvcId" />
                <input type="hidden" name="srvcCustBillId" id="srvcCustBillId" />
                <input type="hidden" name="srvcAdvAmt" id="srvcAdvAmt" />
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
                                        <a href="javascript:viewSrvcLedger();" id="viewLedger">View Ledger</a>
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
                                <input type="text" id="srvcTxtAdvMonth" name="srvcTxtAdvMonth" title="Rental Membership Advance Month" size="3" maxlength="2" class="wAuto ml5 readonly"  readonly onkeydown='return FormUtil.onlyNumber(event)' onblur="javascript:fn_srvcAdvMonthChangeTxt();"/>
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
        
        <ul class="right_btns">
           <li><p class="btn_grid"><a href="javascript:addSrvcToFinal();">ADD</a></p></li>
        </ul>
    
        <!-- grid_wrap start -->
        <article class="grid_wrap mt10">
            <div id="target_srvcD_grid_wrap" style="width: 100%; height: 210px; margin: 0 auto;"></div>
        </article>
        <!-- grid_wrap end -->
        
        <ul class="right_btns">
            <li><p class="amountTotalSttl">Amount Total (1st BS + Rental Fee) :</p></li>
            <li><strong id="srvcTotalAmtTxt">RM 0.00</strong></li>
        </ul>
    </section>    
    
      <!-- 
    ***************************************************************************************
    ***************************************************************************************
    *************                                          Bill Payment Area                                                             ****
    ***************************************************************************************
    ***************************************************************************************
    -->
    <section id="billSearch" style="display:none;">
        <!-- search_table start -->
        <section class="search_table">
            <!-- search_table start -->
            <form id="billSearchForm" action="#" method="post">
                <table class="type1">
                    <caption>table</caption>
                    <colgroup>
                        <col style="width:180px" />
                        <col style="width:*" />                    
                        <col style="width:280px" />
                        <col style="width:*" />
                    </colgroup>
                    <tbody>
                        <tr>
                            <th scope="row">Bill Type</th>
                            <td>
                                <select id="billType" name="billType" onChange="javascript:fn_changeBillType();"> 
                                    <option value="1">AS</option>
                                    <option value="2">HP</option>
                                </select>                                
                            </td>
                            <th scope="row">Search Keywords(BillNo, OrderNo, HPCode)</th>
                            <td>
                                <input type="text" name="billSearchTxt" id="billSearchTxt" title="" placeholder="" class="w100" />
                                <p class="btn_sky">
                                    <a href="javascript:fn_billOrderSearch();" id="search">Search</a>
                                </p>
                            </td>
                        </tr>
                    </tbody>
                </table>
                <!-- table end -->
            </form>
        </section>
        <!-- search_table end -->
        
        <ul class="right_btns">
           <li><p class="btn_grid"><a href="javascript:addBillToFinal();">ADD</a></p></li>
        </ul>
        
        <!-- grid_wrap start -->
        <article class="grid_wrap">
            <div id="target_bill_grid_wrap" style="width: 100%; height: 210px; margin: 0 auto;"></div>
        </article>
        <!-- grid_wrap end -->   
        
        <ul class="right_btns">
            <li><p class="amountTotalSttl">Bill Amount Total :</p></li>
            <li><strong id="billTotalAmtTxt">RM 0.00</strong></li>
        </ul>
    </section>    
    
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
        <ul class="right_btns mt10">
           <li><p class="btn_grid"><a href="javascript:removeFromFinal();">DEL</a></p></li>
        </ul>
    </aside>
    <!-- title_line end -->
    
    <!-- grid_wrap start -->
    <article class="grid_wrap mt10">
        <div id="target_finalBill_grid_wrap" style="width: 100%; height: 220px; margin: 0 auto;"></div>
    </article>
    <!-- grid_wrap end -->
    
     <ul class="right_btns">
            <li><p class="amountTotalSttl">Amount Total :</p></li>
            <li><strong id="paymentTotalAmtTxt">RM 0.00</strong></li>
        </ul>
    
    <ul class="right_btns mt10">
       <li><p class="btn_grid"><a href="javascript:saveAdvPayment();">SAVE</a></p></li>
    </ul>

    <!-- search_table start -->
    <section class="search_table mt10">
        <!-- search_table start -->
        <form id="paymentForm" action="#" method="post">    
            <table class="type1">
                <caption>table</caption>
                <colgroup>  
                    <col style="width:180px" />
                    <col style="width:*" />
                </colgroup>
                <tbody>
                    <tr>
                        <th scope="row">Payment Type</th>
                        <td>
                            <select id="keyInPayType" name="keyInPayType" onchange="fn_payTypeChange();">
                                <option value="105">Cash</option>
                                <option value="106">Cheque</option>
                                <option value="108">Online</option>
                            </select>
                        </td>
                    </tr>                    
                </tbody>
            </table>
            <!-- table end -->
        </form>
    </section>
    <!-- search_table end -->
    
    <!-- 
    ***************************************************************************************
    ***************************************************************************************
    *************                                          Cash Search Area                                                           ****
    ***************************************************************************************
    ***************************************************************************************
    -->
    <!-- search_table start -->
    <section id="cashSearch">
        <section class="search_table">
            <!-- search_table start -->
            <form id="cashSearchForm" action="#" method="post">
                <input type="hidden" name="keyInPayCashType" id="keyInPayCashType" />
                
                <table class="type1">
                    <caption>table</caption>
                    <colgroup>
                        <col style="width:180px" />
                        <col style="width:*" />                    
                    </colgroup>
                    <tbody>
                        <tr>
                            <th scope="row">Amount<span class="must">*</span></th>
                            <td>
                                <input type="text" id="cashAmount" name="cashAmount" class="w100p" maxlength="10" onkeydown='return FormUtil.onlyNumber(event)' />
                            </td>
                            <th scope="row">Bank Type<span class="must">*</span></th>
                            <td>
                                <select id="cashBankType" name="cashBankType"  class="w100p" onchange="fn_bankChange('CASH');">
                                    <option value="2728">JomPay</option>
                                    <option value="2729">MBB CDM</option>
                                    <option value="2730">VA</option>
                                    <option value="2731">Others</option>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row">Bank Account<span class="must">*</span></th>
                            <td>
                                <select id="cashBankAcc" name="cashBankAcc"  class="w100p">
                                </select>
                            </td>
                            <th scope="row">VA Account<span class="must">*</span></th>
                            <td>
                                <input type="text" id="cashVAAccount" name="cashVAAccount" size="22" maxlength="16" class="w100p readonly" readonly="readonly" onkeydown='return FormUtil.onlyNumber(event)' />
                            </td>
                        </tr>
                        <tr>
                           <th scope="row">Transaction Date<span class="must">*</span></th>
                            <td>
                                <input id="cashTransDate" name="cashTransDate" type="text" title="" placeholder="" class="j_date w100p" readonly />
                            </td>
                            <th scope="row">Slip No.<span class="must">*</span></th>
                            <td>
                                <input type="text" id="cashSlipNo" name="cashSlipNo" class="w100p" onkeydown='return FormUtil.onlyNumber(event)' />
                            </td>
                        </tr>
                        <tr>
                           <th scope="row">Payer Name</th>
                            <td>
                                <input type="text" id="cashPayName" name="cashPayName" class="w100p" />
                            </td>
                            <th scope="row">Ref Details/Jompay Ref</th>
                            <td>
                                <input type="text" id="cashRefDetails" name="cashRefDetails" class="w100p" />
                            </td>
                        </tr>
                        <tr>
                            <th scope="row">Remark</th>
                            <td colspan="3">
                                <textarea id="cashRemark" name="cashRemark"  cols="20" rows="5" placeholder=""></textarea>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row">TR No.</th>
                            <td>
                                <input id="cashTrNo" name="cashTrNo" type="text" title="" placeholder="" class="w100p"  />
                            </td>
                            <th scope="row">TR Issue Date</th>
                            <td>
                                <input id="cashTrIssueDate" name="cashTrIssueDate" type="text" title="" placeholder="" class="j_date w100p" readonly />
                            </td>
                        </tr>
                        <tr>
                            <th scope="row">Collector</th>
                            <td>
                                <input id="cashCollMemId" name="cashCollMemId" type="hidden" title="" placeholder="" class="readonly" readonly  />                            
                                <input id="cashCollMemNm" name="cashCollMemNm" type="text" title="" placeholder="" class="readonly" readonly  />
                                <a id="btnCashSalesmanPop" href="javascript:fn_searchUserIdPop();" class="search_btn">
                                    <img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" />
                                </a>
                            </td>
                            <th scope="row">Pay Date</th>
                            <td>
                                <input id="cashPayDate" name="cashPayDate" type="text" title="" placeholder="" class="j_date w100p" readonly />
                            </td>
                        </tr>
                    </tbody>
                </table>
                <!-- table end -->
            </form>
        </section>
        <!-- search_table end -->
    </section>
    
    <!-- 
    ***************************************************************************************
    ***************************************************************************************
    *************                                          Cheque Search Area                                                           ****
    ***************************************************************************************
    ***************************************************************************************
    -->
    <!-- search_table start -->
    <section id="chequeSearch" style="display: none">
        <section class="search_table">
            <!-- search_table start -->
            <form id="chequeSearchForm" action="#" method="post">
                <input type="hidden" name="keyInPayChequeType" id="keyInPayChequeType" />
                
                <table class="type1">
                    <caption>table</caption>
                    <colgroup>
                        <col style="width:180px" />
                        <col style="width:*" />                    
                    </colgroup>
                    <tbody>
                        <tr>
                            <th scope="row">Amount<span class="must">*</span></th>
                            <td>
                                <input type="text" id="chequeAmount" name="chequeAmount" class="w100p" maxlength="10" onkeydown='return FormUtil.onlyNumber(event)' />
                            </td>
                            <th scope="row">Bank Type<span class="must">*</span></th>
                            <td>
                                <select id="chequeBankType" name="chequeBankType"  class="w100p" onchange="fn_bankChange('CHQ');">
                                    <option value="2728">JomPay</option>
                                    <option value="2729">MBB CDM</option>
                                    <option value="2730">VA</option>
                                    <option value="2731">Others</option>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row">Bank Account<span class="must">*</span></th>
                            <td>
                                <select id="chequeBankAcc" name="chequeBankAcc"  class="w100p">
                                </select>
                            </td>
                            <th scope="row">VA Account<span class="must">*</span></th>
                            <td>
                                <input type="text" id="chequeVAAccount" name="chequeVAAccount" maxlength="16"  class="w100p readonly" readonly="readonly" onkeydown='return FormUtil.onlyNumber(event)' />
                            </td>
                        </tr>
                        <tr>
                           <th scope="row">Transaction Date<span class="must">*</span></th>
                            <td>
                                <input id="chequeTransDate" name="chequeTransDate" type="text" title="" placeholder="" class="j_date w100p" readonly />
                            </td>
                            <th scope="row">Slip No.<span class="must">*</span></th>
                            <td>
                                <input type="text" id="chequeChqNo" name="chequeChqNo" class="w100p" onkeydown='return FormUtil.onlyNumber(event)' />
                            </td>
                        </tr>
                        <tr>
                           <th scope="row">Payer Name</th>
                            <td>
                                <input type="text" id="chequePayName" name="chequePayName" class="w100p" />
                            </td>
                            <th scope="row">Ref Details/Jompay Ref<span class="must">*</span></th>
                            <td>
                                <input type="text" id="chequeRefDetails" name="chequeRefDetails" class="w100p" />
                            </td>
                        </tr>
                        <tr>
                            <th scope="row">Remark</th>
                            <td colspan="3">
                                <textarea id="chequeRemark" name="chequeRemark"  cols="20" rows="5" placeholder=""></textarea>
                            </td>                       
                        </tr>
                        <tr>
                            <th scope="row">TR No.</th>
                            <td>
                                <input id="chequeTrNo" name="chequeTrNo" type="text" title="" placeholder="" class="w100p"  />
                            </td>
                            <th scope="row">TR Issue Date</th>
                            <td>
                                <input id="chequeTrIssueDate" name="chequeTrIssueDate" type="text" title="" placeholder="" class="j_date w100p" readonly />
                            </td>
                        </tr>
                        <tr>
                            <th scope="row">Collector</th>
                            <td>
                                <input id="chequeCollMemId" name="chequeCollMemId" type="hidden" title="" placeholder="" class="readonly" readonly  />                            
                                <input id="chequeCollMemNm" name="chequeCollMemNm" type="text" title="" placeholder="" class="readonly" readonly  />
                                <a id="btnChequeSalesmanPop" href="javascript:fn_searchUserIdPop();" class="search_btn">
                                    <img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" />
                                </a>
                            </td>
                            <th scope="row">Pay Date</th>
                            <td>
                                <input id="chequePayDate" name="chequePayDate" type="text" title="" placeholder="" class="j_date w100p" readonly />
                            </td>
                        </tr>
                    </tbody>
                </table>
                <!-- table end -->
            </form>
        </section>
        <!-- search_table end -->
    </section>
    
    <!-- 
    ***************************************************************************************
    ***************************************************************************************
    *************                                          Online Search Area                                                           ****
    ***************************************************************************************
    ***************************************************************************************
    -->
    <!-- search_table start -->
    <section id="onlineSearch" style="display: none">
        <section class="search_table">
            <!-- search_table start -->
            <form id="onlineSearchForm" action="#" method="post">
                <input type="hidden" name="keyInPayOnlineType" id="keyInPayOnlineType" />
                
                <table class="type1">
                    <caption>table</caption>
                    <colgroup>
                        <col style="width:180px" />
                        <col style="width:*" />                    
                    </colgroup>
                    <tbody>
                        <tr>
                            <th scope="row">Amount<span class="must">*</span></th>
                            <td>
                                <input type="text" id="onlineAmount" name="onlineAmount" class="w100p" maxlength="10" onkeydown='return FormUtil.onlyNumber(event)' />
                            </td>
                            <th scope="row">Bank Charge Amount</th>
                            <td>
                                <input type="text" id="onlineBankChgAmt" name="onlineBankChgAmt" class="w100p" maxlength="10"  onkeydown='return FormUtil.onlyNumber(event)' />
                            </td>
                        </tr>
                        <tr>
                           <th scope="row">Transaction Date<span class="must">*</span></th>
                            <td>
                                <input id="onlineTransDate" name="onlineTransDate" type="text" title="" placeholder="" class="j_date w100p" readonly />
                            </td>
                            <th scope="row">EFT</th>
                            <td>
                                <input type="text" id="onlineEft" name="onlineEft" class="w100p" onkeydown='return FormUtil.onlyNumber(event)' />
                            </td>
                        </tr>
                        <tr>
                           <th scope="row">Payer Name</th>
                            <td>
                                <input type="text" id="onlinePayName" name="onlinePayName" class="w100p" />
                            </td>
                            <th scope="row">Ref Details/Jompay Ref</th>
                            <td>
                                <input type="text" id="onlineRefDetails" name="onlineRefDetails" class="w100p" />
                            </td>
                        </tr>
                        <tr>
                            <th scope="row">Bank Type<span class="must">*</span></th>
                            <td>
                                <select id="onlineBankType" name="onlineBankType"  class="w100p" onchange="fn_bankChange('ONL');">
                                    <option value="2728">JomPay</option>
                                    <option value="2729">MBB CDM</option>
                                    <option value="2730">VA</option>
                                    <option value="2731">Others</option>
                                </select>
                            </td>
                            <th scope="row">Bank Account<span class="must">*</span></th>
                            <td>
                                <select id="onlineBankAcc" name="onlineBankAcc"  class="w100p">
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row">VA Account<span class="must">*</span></th>
                            <td >
                                <input type="text" id="onlineVAAccount" name="onlineVAAccount"  maxlength="16"  class="w100p readonly" readonly="readonly" onkeydown='return FormUtil.onlyNumber(event)' />
                            </td>
                            <th scope="row"></th>
                            <td>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row">Remark</th>
                            <td colspan="3">
                                <textarea id="onlineRemark" name="onlineRemark"  cols="20" rows="5" placeholder=""></textarea>
                            </td>                       
                        </tr>
                        <tr>
	                        <th scope="row">TR No.</th>
	                        <td>
	                            <input id="onlineTrNo" name="onlineTrNo" type="text" title="" placeholder="" class="w100p"  />
	                        </td>
	                        <th scope="row">TR Issue Date</th>
	                        <td>
	                            <input id="onlineTrIssueDate" name="onlineTrIssueDate" type="text" title="" placeholder="" class="j_date w100p" readonly />
	                        </td>
	                    </tr>
	                    <tr>
	                        <th scope="row">Collector</th>
	                        <td>
	                            <input id="onlineCollMemId" name="onlineCollMemId" type="hidden" title="" placeholder="" class="readonly" readonly  />                            
	                            <input id="onlineCollMemNm" name="onlineCollMemNm" type="text" title="" placeholder="" class="readonly" readonly  />
	                            <a id="btnOnlineSalesmanPop" href="javascript:fn_searchUserIdPop();" class="search_btn">
	                                <img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" />
	                            </a>
	                        </td>
	                        <th scope="row">Pay Date</th>
	                        <td>
	                            <input id="onlinePayDate" name="onlinePayDate" type="text" title="" placeholder="" class="j_date w100p" readonly />
	                        </td>
	                    </tr>
                    </tbody>
                </table>
                <!-- table end -->
            </form>
        </section>
        <!-- search_table end -->
    </section>

</section>
<!-- content end -->