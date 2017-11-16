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

var maxSeq = 0; //billing ADD 될 시퀀스

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
    { dataField:"targetAmt" ,headerText:"Target<br>Amount" ,editable : false , width : 100 , dataType : "numeric", formatString : "#,##0.##"},
    { dataField:"billDt" ,headerText:"Bill Date" ,editable : false , width : 100},
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
   { dataField:"salesOrdId" ,headerText:"Sales Order ID" ,editable : false , width : 100, visible : false },

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

//AUIGrid 칼럼 설정 : targetSrvcDetGridID
var targetSrvcDetColumnLayout = [
    
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
    { dataField:"srvLdgrRefDt" ,headerText:"Bill Date" ,editable : false , width : 100 , dataType : "date", formatString : "yyyy-mm-dd"},
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

//AUIGrid 칼럼 설정 : targetBillMstGridID
var targetBillMstColumnLayout = [
    
    { dataField:"billId" ,headerText:"Bill ID" ,editable : false , width : 120, visible : false },
    { dataField:"billNo" ,headerText:"Bill No" ,editable : false , width : 100},
    { dataField:"billTypeId" ,headerText:"Bill Type ID" ,editable : false , width : 150 , visible : false },
    { dataField:"billTypeNm" ,headerText:"Bill Type" ,editable : false , width : 100},  
    { dataField:"custNm" ,headerText:"Cust Name" ,editable : false , width : 250},      
    { dataField:"nric" ,headerText:"Cust NRIC" ,editable : false , width : 120 },      
    { dataField:"billMemNm" ,headerText:"HP Name." ,editable : false , width : 250 , visible : false },
    { dataField:"billMemCode" ,headerText:"HP Code." ,editable : false , width : 100 , visible : false },
    { dataField:"ruleDesc" ,headerText:"Pay Type" ,editable : false , width : 200 },  
    { dataField:"billDt" ,headerText:"Date" ,editable : false , width : 100 , dataType : "date", formatString : "yyyy-mm-dd"},  
    { dataField:"billAmt" ,headerText:"Amount" ,editable : false , width : 100 , dataType : "numeric", formatString : "#,##0.##"},
    { dataField:"paidAmt" ,headerText:"Paid Amount" ,editable : false , width : 100 , dataType : "numeric", formatString : "#,##0.##"},
    { dataField:"billRem" ,headerText:"Remark" ,editable : false , width : 100 },
    { dataField:"billIsPaid" ,headerText:"Paid?" ,editable : false , width : 100 },
    { dataField:"billIsComm" ,headerText:"Commission?" ,editable : false , width : 100 },
    { dataField:"stusNm" ,headerText:"Status" ,editable : false , width : 100 },
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


//AUIGrid 칼럼 설정 : targetFinalBillGridID
var targetFinalBillColumnLayout = [
    { dataField:"procSeq" ,headerText:"Process Seq" ,editable : false , width : 120},
    { dataField:"appType" ,headerText:"AppType" ,editable : false , width : 120},
    { dataField:"advMonth" ,headerText:"AdvanceMonth" ,editable : false , width : 120 , dataType : "numeric", formatString : "#,##0.##"},
    { dataField:"billGrpId" ,headerText:"Bill Group ID" ,editable : false , width : 120},
    { dataField:"billId" ,headerText:"Bill ID" ,editable : false , width : 100},
    { dataField:"ordId" ,headerText:"Order ID" ,editable : false , width : 100 },
    { dataField:"mstRpf" ,headerText:"Master RPF" ,editable : false , width : 100  , dataType : "numeric", formatString : "#,##0.##"},
    { dataField:"mstRpfPaid" ,headerText:"Master RPF Paid" ,editable : false , width : 100  , dataType : "numeric", formatString : "#,##0.##"},
    { dataField:"billNo" ,headerText:"Bill No" ,editable : false , width : 150 },      
    { dataField:"ordNo" ,headerText:"Order No" ,editable : false , width : 100 },
    { dataField:"billTypeId" ,headerText:"Bill TypeID" ,editable : false , width : 100 },
    { dataField:"billTypeNm" ,headerText:"Bill Type" ,editable : false , width : 180 },      
    { dataField:"installment" ,headerText:"Installment" ,editable : false , width : 100 },      
    { dataField:"billAmt" ,headerText:"Amount" ,editable : false , width : 100 , dataType : "numeric", formatString : "#,##0.##"},  
    { dataField:"paidAmt" ,headerText:"Paid" ,editable : false , width : 100 , dataType : "numeric", formatString : "#,##0.##"},
    { dataField:"targetAmt" ,headerText:"Target Amount" ,editable : false , width : 100 , dataType : "numeric", formatString : "#,##0.##"},
    { dataField:"billDt" ,headerText:"Bill Date" ,editable : false , width : 100 },
    { dataField:"assignAmt" ,headerText:"assignAmt" ,editable : false , width : 100 , dataType : "numeric", formatString : "#,##0.##"},
    { dataField:"billStatus" ,headerText:"billStatus" ,editable : false , width : 100},
    { dataField:"custNm" ,headerText:"custNm" ,editable : false , width : 100},
    { dataField:"discountAmt" ,headerText:"discountAmt" ,editable : false , width : 100 , dataType : "numeric", formatString : "#,##0.##"}
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
    
    //Credit Card Type 생성
    doGetCombo('/common/selectCodeList.do', '21' , ''   , 'keyInCrcType' , 'S', '');
    
    //CreditCardMode 생성
    doGetCombo('/common/selectCodeList.do', '130' , ''   ,'keyInCardMode', 'S' , '');
    
    //Bank Account 조회 : Merchant Bank 
    //doGetCombo('/common/getAccountList.do', 'CRC' , ''   , 'keyInMerchantBank' , 'S', '');    
    //doGetCombo('/common/getAccountList.do', 'CASH' , ''   , 'bankAccount' , 'S', '');
    //doGetCombo('/common/getAccountList.do', 'CHQ' , ''   , 'bankAccount' , 'S', '');
    //doGetCombo('/common/getAccountList.do', 'ONLINE' , ''   , 'bankAccount' , 'S', '');
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

//Merchant Bank 변경시 Tenure 다시 세팅한다. 
function fn_changeIsseBank(){
	var keyInIssueBank = $("#keyInIssueBank").val();
	
	if(keyInIssueBank == 17 || keyInIssueBank == 28 || keyInIssueBank == 3 || keyInIssueBank == 36){        //HSBC OR CIMB
		doDefCombo(tenureTypeData1, '' ,'keyInTenure', 'S', '');  
	}else if(keyInIssueBank == 21 || keyInIssueBank == 30 || keyInIssueBank == 23 || keyInIssueBank == 38 || keyInIssueBank == 20){        // MBB OR AMB OR UOB
        doDefCombo(tenureTypeData2, '' ,'keyInTenure', 'S', '');  
    }else if(keyInIssueBank == 5 || keyInIssueBank == 29){        //HLB
        doDefCombo(tenureTypeData3, '' ,'keyInTenure', 'S', '');  
    }else if(keyInIssueBank == 6 || keyInIssueBank == 32 ){        //PBB
        doDefCombo(tenureTypeData4, '' ,'keyInTenure', 'S', '');  
    }else if(keyInIssueBank == 19 || keyInIssueBank == 34){        //SCB
        doDefCombo(tenureTypeData5, '' ,'keyInTenure', 'S', '');  
    }else {        //OTHER
        doDefCombo(tenureTypeData, '' ,'keyInTenure', 'S', '');  
    }	
}

function savePayment(){
	
	//param data array
	var data = {};
	
	var gridList = AUIGrid.getGridData(targetFinalBillGridID);       //그리드 데이터
	var formList = $("#paymentForm").serializeArray();       //폼 데이터
	
	alert("gridList.length : " + gridList.length);
	
	//array에 담기
	if(gridList.length > 0) {
		data.all = gridList;
	}  else {
		Common.alert("There is no Billing Row Data");
		return;
	}
	    
    if(formList.length > 0) data.form = formList;
    else data.form = [];
    
    //Bill Payment : Order 정보 조회
    Common.ajax("POST", "/payment/common/savePayment.do", data, function(result) {
    	alert("AAAA");
    });
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
    
    if(advMonth != '' && advMonth > 0){     //advMonth가 입력되어 있는 경우
        rentalDiscountValue();
    } else{                                             //advMonth가 입력되어 있지 않은 경우
        var rowCnt = AUIGrid.getRowCount(targetRenDetGridID);
        var totalAmt = Number(0.00);

        if(rowCnt > 0){
            for(var i = 0; i < rowCnt; i++){
                if(AUIGrid.getCellValue(targetRenDetGridID, i ,"btnCheck") == 1){
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
                    
                    if(obj.btnCheck == 1){
                        tot += obj.targetAmt; 
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
    var rowCnt = AUIGrid.getRowCount(targetRenMstGridID);
    maxSeq = maxSeq + 1;

    if(rowCnt > 0){
        for(i = 0 ; i < rowCnt ; i++){

            var mstChkVal = AUIGrid.getCellValue(targetRenMstGridID, i ,"btnCheck");
            var mstSalesOrdNo = AUIGrid.getCellValue(targetRenMstGridID, i ,"salesOrdNo");
            
            var mstRpf = AUIGrid.getCellValue(targetRenMstGridID, i ,"rpf");
            var mstRpfPaid = AUIGrid.getCellValue(targetRenMstGridID, i ,"rpfPaid");
            

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
                     item.billDt   = "";
                     item.billGrpId = 0;
                     item.billId = 0;
                     item.billNo = "0";
                     item.billStatus = "DUMMY";
                     item.billTypeId = 161;
                     item.billTypeNm   = "RPF";
                     item.custNm   = "DUMMY";
                     item.discountAmt = 0;
                     item.installment  = 0;
                     item.ordId = AUIGrid.getCellValue(targetRenMstGridID, i ,"salesOrdId");
                     item.ordNo = mstSalesOrdNo;
                     item.paidAmt     = mstRpfPaid;
                     item.targetAmt   = mstRpf - mstRpfPaid;
                     
                     AUIGrid.addRow(targetFinalBillGridID, item, "last");
            		
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

                        AUIGrid.addRow(targetFinalBillGridID, item, "last");
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
                    item.billDt   = "";
                    item.billGrpId = 0;
                    item.billId = 0;
                    item.billNo = "0";
                    item.billStatus = "DUMMY";
                    item.billTypeId = 1032;
                    item.billTypeNm   = "General Advanced For Rental";
                    item.custNm   = "DUMMY";
                    item.discountAmt = 0;
                    item.installment  = 0;
                    item.ordId = AUIGrid.getCellValue(targetRenMstGridID, i ,"salesOrdId");
                    item.ordNo = mstSalesOrdNo;
                    item.paidAmt     = 0;
                    item.targetAmt   = $("#rentalAdvAmt").val();
                    
                    AUIGrid.addRow(targetFinalBillGridID, item, "last");
                   
               }
            }
        }
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
    var rowCnt = AUIGrid.getRowCount(targetOutMstGridID);
    
    maxSeq = maxSeq + 1;

    if(rowCnt > 0){
        for(i = 0 ; i < rowCnt ; i++){
        	var item = new Object();
        	
        	item.procSeq = maxSeq;
            item.appType = "OUT";
            item.advMonth = 0;
            item.mstRpf = 0;
            item.mstRpfPaid = 0;
            
            item.assignAmt = 0;
            item.billAmt   = AUIGrid.getCellValue(targetOutMstGridID, i ,"productPrice");
            item.billDt   = "";
            item.billGrpId = 0;
            item.billId = 0;
            item.billNo = 0;                        
            item.billStatus = "";   
            item.billTypeId = "";   
            item.billTypeNm   = "";
            item.custNm   = AUIGrid.getCellValue(targetOutMstGridID, i ,"custNm");
            item.discountAmt = 0;
            item.installment  = 0;                        
            item.ordId = AUIGrid.getCellValue(targetOutMstGridID, i ,"salesOrdId");
            item.ordNo = AUIGrid.getCellValue(targetOutMstGridID, i ,"salesOrdNo");
            item.paidAmt     = AUIGrid.getCellValue(targetOutMstGridID, i ,"totalPaid");
            item.targetAmt   = AUIGrid.getCellValue(targetOutMstGridID, i ,"balance");
            
            AUIGrid.addRow(targetFinalBillGridID, item, "last");
        }
    }   
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
  
  if(advMonth != '' && advMonth > 0){     //advMonth가 입력되어 있는 경우
      srvcDiscountValue();
  } else{                                             //advMonth가 입력되어 있지 않은 경우
      var rowCnt = AUIGrid.getRowCount(targetSrvcDetGridID);
      var totalAmt = Number(0.00);

      if(rowCnt > 0){
          for(var i = 0; i < rowCnt; i++){
              if(AUIGrid.getCellValue(targetSrvcDetGridID, i ,"btnCheck") == 1){
                  totalAmt += AUIGrid.getCellValue(targetSrvcDetGridID, i ,"targetAmt");
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
    var tot = 0;
    var mstRowCnt = AUIGrid.getRowCount(targetSrvcMstGridID);
    var srvCntrctRefNo = '';

    if(mstRowCnt > 0){
        for(var i = 0; i < mstRowCnt; i++){
            
        	srvCntrctRefNo = AUIGrid.getCellValue(targetSrvcMstGridID,i,"srvCntrctRefNo");     //마스터 그리드에서 Service Contract Reference No
            filteramount = AUIGrid.getCellValue(targetSrvcMstGridID,i,"filterCharges");
            filteramountpaid = AUIGrid.getCellValue(targetSrvcMstGridID,i,"filterChargesPaid");
            balance = AUIGrid.getCellValue(targetSrvcMstGridID,i,"balance");

            var filtertarget = 0;

            if (filteramount > filteramountpaid) filtertarget = filteramount - filteramountpaid;

            if(balance >= 0){
                tot += filtertarget;

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
                     item.billDt   = "";
                     item.billGrpId = 0;
                     item.billId = AUIGrid.getCellValue(targetSrvcMstGridID, i ,"custBillId");
                     item.billNo = "0";
                     item.billStatus = AUIGrid.getCellValue(targetSrvcMstGridID, i ,"cntrctRentalStus");
                     item.billTypeId = 1307;
                     item.billTypeNm   = "Service Contract BS";
                     item.custNm   = AUIGrid.getCellValue(targetSrvcMstGridID, i ,"custName");
                     item.discountAmt = 0;
                     item.installment  = 0;
                     item.ordId = AUIGrid.getCellValue(targetSrvcMstGridID, i ,"salesOrdId");
                     item.ordNo = AUIGrid.getCellValue(targetSrvcMstGridID, i ,"srvCntrctRefNo");
                     item.paidAmt     = mstFilterChargesPaid;
                     item.targetAmt   = mstFilterCharges - mstFilterChargesPaid;
                     
                     AUIGrid.addRow(targetFinalBillGridID, item, "last");
                    
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
                    item.billDt   = "";
                    item.billGrpId = 0;
                    item.billId = AUIGrid.getCellValue(targetSrvcMstGridID, i ,"custBillId");
                    item.billNo = "0";
                    item.billStatus = AUIGrid.getCellValue(targetSrvcMstGridID, i ,"cntrctRentalStus");
                    item.billTypeId = 1307;
                    item.billTypeNm   = "Service Contract BS";
                    item.custNm   = AUIGrid.getCellValue(targetSrvcMstGridID, i ,"custName");
                    item.discountAmt = 0;
                    item.installment  = 0;
                    item.ordId = AUIGrid.getCellValue(targetSrvcMstGridID, i ,"salesOrdId");
                    item.ordNo = AUIGrid.getCellValue(targetSrvcMstGridID, i ,"srvCntrctRefNo");
                    item.paidAmt     = mstFilterChargesPaid;
                    item.targetAmt   = mstFilterCharges - mstFilterChargesPaid;
                    
                    AUIGrid.addRow(targetFinalBillGridID, item, "last");
                   
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
                    item.billDt   = "";
                    item.billGrpId = 0;
                    item.billId = 0;
                    item.billNo = "0";
                    item.billStatus = AUIGrid.getCellValue(targetSrvcMstGridID, i ,"cntrctRentalStus");
                    item.billTypeId = 154;
                    item.billTypeNm   = "Advanced";
                    item.custNm   = AUIGrid.getCellValue(targetSrvcMstGridID, i ,"custName");
                    item.discountAmt = 0;
                    item.installment  = 0;
                    item.ordId = AUIGrid.getCellValue(targetSrvcMstGridID, i ,"salesOrdId");
                    item.ordNo = AUIGrid.getCellValue(targetSrvcMstGridID, i ,"srvCntrctRefNo");
                    item.paidAmt     = 0;
                    item.targetAmt   = $("#srvcAdvAmt").val();
                    
                    AUIGrid.addRow(targetFinalBillGridID, item, "last");
                   
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
                        //item.billGrpId = AUIGrid.getCellValue(targetSrvcDetGridID, j ,"billGrpId");
                        //item.billId = AUIGrid.getCellValue(targetSrvcDetGridID, j ,"billId");
                        //item.billNo = AUIGrid.getCellValue(targetSrvcDetGridID, j ,"billNo");                        
                        //item.billStatus = AUIGrid.getCellValue(targetSrvcDetGridID, j ,"stusCode");   
                        item.billTypeId = AUIGrid.getCellValue(targetSrvcDetGridID, j ,"srvLdgrTypeId");   
                        item.billTypeNm   = AUIGrid.getCellValue(targetSrvcDetGridID, j ,"srvLdgrTypeNm");
                        //item.custNm   = AUIGrid.getCellValue(targetSrvcDetGridID, j ,"custNm");
                        item.discountAmt = 0;
                        item.installment  = AUIGrid.getCellValue(targetSrvcDetGridID, j ,"srvPaySchdulNo");                        
                        item.ordId = AUIGrid.getCellValue(targetSrvcDetGridID, j ,"srvCntrctOrdId");
                        item.ordNo = AUIGrid.getCellValue(targetSrvcDetGridID, j ,"salesOrdNo");
                        item.paidAmt     = AUIGrid.getCellValue(targetSrvcDetGridID, j ,"paidTotal");
                        item.targetAmt   = AUIGrid.getCellValue(targetSrvcDetGridID, j ,"targetAmt");                        

                        AUIGrid.addRow(targetFinalBillGridID, item, "last");
                    }
                }
                
                
            }
        }
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
            totalAmt += AUIGrid.getCellValue(targetBillMstGridID, i ,"billAmt");
        }
    }

    $("#billTotalAmtTxt").text("RM " + $.number(totalAmt,2));    
}

function resetBillGrid(){
    AUIGrid.clearGridData(targetBillMstGridID);
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
    </aside>
    <!-- title_line end -->
    
	<!-- grid_wrap start -->
	<article class="grid_wrap mt10">
	    <div id="target_finalBill_grid_wrap" style="width: 100%; height: 210px; margin: 0 auto;"></div>
	</article>
	<!-- grid_wrap end -->
	
	<ul class="right_btns">
	   <li><p class="btn_grid"><a href="javascript:savePayment();">SAVE</a></p></li>
    </ul>

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
				        <td>
				            <select id="keyInPayType" name="keyInPayType">
				                <option value="107">Credit Card</option>
				            </select>
				        </td>
				        <th scope="row">Ref No</th>
				        <td>
				            <input type="text" id="keyInRefNo" name="keyInRefNo" class="w100p" />
				        </td>
				    </tr>                    
				    <tr>
				        <th scope="row">Amount</th>
				        <td>
				            <input type="text" id="keyInAmount" name="keyInAmount" class="w100p" onkeydown='return FormUtil.onlyNumber(event)' />
				        </td>
				        <th scope="row">Bank Charge Amount</th>
				        <td>
				            <input type="text" id="keyInBankChrgAmount" name="keyInBankChrgAmount" class="w100p" onkeydown='return FormUtil.onlyNumber(event)' />
				        </td>
				    </tr>
				    <tr>
				        <th scope="row">Card Type</th>
				        <td>
				            <select id="keyCrcCardType" name="keyCrcCardType"  class="w100p">
				                <option value="1241">Credit Card</option>
				                <option value="1240">Debit Card</option>
				            </select>
				        </td>
				        <th scope="row">Card Brand</th>
				        <td>
				            <select id="keyInCrcType" name="keyInCrcType"  class="w100p"></select>
				        </td>
				    </tr>
				    <tr>
				        <th scope="row">Card Mode</th>
				        <td>
				            <select id="keyInCardMode" name="keyInCardMode"  class="w100p" onChange="javascript:fn_changeCrcMode();">
				                <option value="2708">POS</option>
				                <option value="2709">MOTO</option>
				                <option value="2710">MOTO IPP</option>
				                <option value="2711">MPOS</option>
				                <option value="2712">MPOS IPP</option>
				            </select>
				        </td>
				        <th scope="row">Approval No.</th>
				        <td>
				            <input type="text" id="keyInApprovalNo" name="keyInApprovalNo" class="w100p"  />
				        </td>                        
				    </tr>
				    <tr>
				        <th scope="row">Card No</th>
				        <td>
				            <p class="short"><input type="text" id="keyInCardNo1" name="keyInCardNo1" size="6" maxlength="6" class="wAuto" onkeydown='return FormUtil.onlyNumber(event)' /></p>
				            <span>-</span>
				            <p class="short"><input type="password" id="keyInCardNo2" name="keyInCardNo2" size="6" maxlength="6" class="wAuto" onkeydown='return FormUtil.onlyNumber(event)' /></p>
				            <span>-</span>
				            <p class="short"><input type="text" id="keyInCardNo3" name="keyInCardNo3" size="4" maxlength="4" class="wAuto" onkeydown='return FormUtil.onlyNumber(event)' /></p>
				        </td>
				        <th scope="row">Credit Card Holder Name</th>
				        <td>
				            <input type="text" id="keyInHolderNm" name="keyInHolderNm" class="w100p"  />
				        </td>                        
				    </tr>     
				    <tr>
                        <th scope="row">Issue Bank</th>
                        <td>
                            <select id="keyInIssueBank" name="keyInIssueBank" class="w100p" onChange="javascript:fn_changeIsseBank();"></select>
                        </td>
                        <th scope="row">Merchant Bank</th>
                        <td>
                            <select id="keyInMerchantBank" name="keyInMerchantBank" class="w100p" ></select>
                        </td>                       
                    </tr>                  
				    <tr>
				        <th scope="row">Expiry Date(mm/yy)</th>
				        <td>
				            <p class="short"><input type="text" id="keyInExpiryMonth" name="keyInExpiryMonth" size="2" maxlength="2" class="wAuto" onkeydown='return FormUtil.onlyNumber(event)' /></p>
				            <span>/</span>
				            <p class="short"><input type="text" id="keyInExpiryYear" name="keyInExpiryYear" size="2" maxlength="2" class="wAuto" onkeydown='return FormUtil.onlyNumber(event)' /></p>                            
				        </td>
				        <th scope="row">Tenure</th>
				        <td>
				            <select id="keyInTenure" name="keyInTenure"  class="w100p">
                            </select>
				        </td>
				    </tr>
				    <tr>
				        <th scope="row">Running Number</th>
				        <td>
				            <input id="keyInRunNo" name="keyInRunNo" type="text" title="" placeholder="" class="w100p"  />
				        </td>
				        <th scope="row">Transatcion Date</th>
				        <td>
				            <input id="keyInTrDate" name="keyInTrDate" type="text" title="" placeholder="" class="j_date w100p" readonly />
				        </td>
				    </tr>
				    
				    <tr>
				        <th scope="row">Remark</th>
				        <td colspan="3">
				            <textarea id="keyInRemark" name="keyInRemark"  cols="20" rows="5" placeholder=""></textarea>
				        </td>                       
				    </tr>
				    <tr>
				        <th scope="row">TR No.</th>
				        <td>
				            <input id="keyInTrNo" name="keyInTrNo" type="text" title="" placeholder="" class="w100p"  />
				        </td>
				        <th scope="row">TR Issue Date</th>
				        <td>
				            <input id="keyInTrIssueDate" name="keyInTrIssueDate" type="text" title="" placeholder="" class="j_date w100p" readonly />
				        </td>
				    </tr>
				    <tr>
				        <th scope="row">Collector</th>
				        <td>
				            <input id="keyInCollMemId" name="keyInCollMemId" type="text" title="" placeholder="" class="w100p"  />
				        </td>
				        <th scope="row">Pay Date</th>
				        <td>
				            <input id="keyInPayDate" name="keyInPayDate" type="text" title="" placeholder="" class="j_date w100p" readonly />
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