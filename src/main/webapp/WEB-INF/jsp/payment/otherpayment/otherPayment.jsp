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

//page1, 그리드 데이터
var bankGridID;

//page2, 그리드 데이터
var pendingGridID;

var targetRenMstGridID;
var targetRenDetGridID;
var targetOutMstGridID;
var targetSrvcMstGridID;
var targetSrvcDetGridID;
var targetBillMstGridID;
var targetFinalBillGridID;

var maxSeq = 0; //billing ADD 될 시퀀스

var isMapped;
var selectedItem;
//에서 선택된 RowID
var rowId;

//targetFinalBillGridID Grid에서 선택된 RowID
var selectedGridValue = -1;

var payTypeIndicator;

var gridPros = {
        // 편집 가능 여부 (기본값 : false)
        editable : false,
        // 상태 칼럼 사용
        showStateColumn : false,
        
        //체크박스컬럼
        showRowCheckColumn : true,
        showRowAllCheckBox : false,
        rowCheckToRadio : true
};

var gridPros2 = {
        // 편집 가능 여부 (기본값 : false)
        editable : false,
        // 상태 칼럼 사용
        showStateColumn : false,
        height:100
};

var gridPros3 = {                    
		  headerHeight : 35,               // 기본 헤더 높이 지정
		  pageRowCount : 5,              //페이지당 row 수
		  showStateColumn : false      // 상태 칼럼 사용  
};

//Grid Properties 설정 
var targetGridPros = {
  headerHeight : 35,               // 기본 헤더 높이 지정
  pageRowCount : 5,              //페이지당 row 수
  showStateColumn : false ,     // 상태 칼럼 사용
  softRemoveRowMode:false
};

$(document).ready(function(){
	bankGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout,null,gridPros);
	pendingGridID = GridCommon.createAUIGrid("grid_wrap_pending", columnPending,null,gridPros2);
	
	//page2
	targetRenMstGridID = GridCommon.createAUIGrid("target_rental_grid_wrap", targetRenMstColumnLayout,null,gridPros3);
    targetRenDetGridID = GridCommon.createAUIGrid("target_rentalD_grid_wrap", targetRenDetColumnLayout,null,gridPros3);
    targetOutMstGridID = GridCommon.createAUIGrid("target_out_grid_wrap", targetOutMstColumnLayout,null,gridPros3);
    targetSrvcMstGridID = GridCommon.createAUIGrid("target_srvc_grid_wrap", targetSrvcMstColumnLayout,null,gridPros3);
    targetSrvcDetGridID = GridCommon.createAUIGrid("target_srvcD_grid_wrap", targetSrvcDetColumnLayout,null,gridPros3);
    targetBillMstGridID = GridCommon.createAUIGrid("target_bill_grid_wrap", targetBillMstColumnLayout,null,gridPros);
    targetFinalBillGridID = GridCommon.createAUIGrid("target_finalBill_grid_wrap", targetFinalBillColumnLayout,null,targetGridPros);
    
    // Master Grid 셀 클릭시 이벤트
    AUIGrid.bind(targetFinalBillGridID, "cellClick", function( event ){ 
        selectedGridValue = event.rowIndex;
    });
    
    AUIGrid.bind(bankGridID, "rowCheckClick", function( event ) {
        selectedItem = event.item.id;
        isMapped = event.item.stus;
        rowId = event.rowIndex;
    });
    
	var strAcc = '<select id="bankAcc" name="bankAcc" class="w100p" disabled></select>';
	 $("#cash").show();
	 $("#cash").find("#acc").html(strAcc);
	 $("#cash").find("#payType").val($('#payMode').val());
	 doGetCombo('/common/getAccountList.do', 'CASH','', 'bankAcc', 'S', '' );
	 
	 $('#payMode').change(function() {
		
		 //cash일때, online<div>감추고 Cash에 대한 Bank Acc불러옴
		 if($('#payMode').val() == '105'){
			 $("#online").hide();
			 $("#cheque").hide();
			 $("#cash").hide();
             $("#cash").show();
             
             $("#cash").find("#payType").val($('#payMode').val());
             
             $('#cash').find('#acc').html("");
             $('#cheque').find('#acc').html("");
             $('#online').find('#acc').html("");
             $('#cash').find('#acc').html(strAcc);
             doGetCombo('/common/getAccountList.do', 'CASH','', 'bankAcc', 'S', '' );
	     }else if($('#payMode').val() == '106'){//cheque
	    	 $("#online").hide();
             $("#cheque").hide();
             $("#cash").hide();
	         $("#cheque").show();
	         
	         $("#cheque").find("#payType").val($('#payMode').val());
	         
	         $('#cash').find('#acc').html("");
             $('#cheque').find('#acc').html("");
             $('#online').find('#acc').html("");
             $('#cheque').find('#acc').html(strAcc);
	         doGetCombo('/common/getAccountList.do', 'CHQ','', 'bankAcc', 'S', '' );
	     }else if($('#payMode').val() == '108'){//online
	    	 $("#online").hide();
             $("#cheque").hide();
             $("#cash").hide(); 
             $("#online").show();
             
             $("#online").find("#payType").val($('#payMode').val());
             
             $('#cash').find('#acc').html("");
             $('#cheque').find('#acc').html("");
             $('#online').find('#acc').html("");
             $('#online').find('#acc').html(strAcc);
             doGetCombo('/common/getAccountList.do', 'ONLINE','', 'bankAcc', 'S', '' );
        }
		 
	 });
     
	 $('#online').find('#bankType').change(function(){
		 if($('#online').find('#bankType').val() == '2730'){//VA
			//select초기화(BankAccount)
			 $('#online').find('#bankAcc').find('option:first').attr('selected', 'selected');
			 $('#online').find('#bankAcc').prop("disabled", true);
			 $('#online').find('#va').prop("disabled", false);
		 }else{
			 $('#online').find('#bankAcc').prop("disabled", false);
             $('#online').find('#va').prop("disabled", true); 
		 }
	 });
	 
	 $('#cash').find('#bankType').change(function(){
		 if($('#cash').find('#bankType').val() == '2730'){//VA
			//select초기화(BankAccount)
			 $('#cash').find('#bankAcc').find('option:first').attr('selected', 'selected');
			 $('#cash').find('#bankAcc').prop("disabled", true);
             $('#cash').find('#va').prop("disabled", false);
         }else{
             $('#cash').find('#bankAcc').prop("disabled", false);
             $('#cash').find('#va').prop("disabled", true); 
         }
	 });
	 
	 $('#cheque').find('#bankType').change(function(){
         if($('#cheque').find('#bankType').val() == '2730'){//VA
        	//select초기화(BankAccount)
             $('#cheque').find('#bankAcc').find('option:first').attr('selected', 'selected');
        	 $('#cheque').find('#bankAcc').prop("disabled", true);
             $('#cheque').find('#va').prop("disabled", false);
         }else{
             $('#cheque').find('#bankAcc').prop("disabled", false);
             $('#cheque').find('#va').prop("disabled", true); 
         }
     });
	 
	 //page2
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
	    
});

var columnPending=[
	{
        dataField : "bank",
        headerText : "Bank",
        editable : false
    },{
        dataField : "bankAccount",
        headerText : "Bank Account",
        editable : false
    },{
        dataField : "date",
        headerText : "Date",
        dataType:"date",
        formatString:"yyyy-mm-dd",
        editable : false
    },
    {
        dataField : "mode",
        headerText : "Mode",
        editable : false
    },
    {
    	dataField : "refChequeNo",
    	headerText : "Ref/Cheque No.",
    	editable : false
    },
    {
        dataField : "amount",
        headerText : "Amount",
        editable : false
    },
    {
        dataField : "trId",
        headerText : "Transaction ID",
        editable : false
    },
    {
        dataField : "pendingAmount",
        headerText : "Pending Amount",
        editable : false
    }
];

// AUIGrid 칼럼 설정
var columnLayout = [ 
     {
         dataField : "id",
         headerText : "id",
         editable : false,
         visible : false
     },
    {
        dataField : "bank",
        headerText : "Bank",
        editable : false
    }, {
        dataField : "bankAccName",
        headerText : "Bank Account",
        editable : false
    }, {
        dataField : "trnscDt",
        headerText : "Date",
        editable : false,
        dataType:"date",
        formatString:"yyyy-mm-dd"
    }, 
    {
        dataField : "fTrnscTellerId",
        headerText : "Teller ID",
        editable : false
    }, 
    {
        dataField : "ref3",
        headerText : "Transaction Code",
        editable : false
    }, 
    {
        dataField : "chqNo",
        headerText : "Ref/Cheque No.",
        editable : false
    }, {
        dataField : "ref1",
        headerText : "Description",
        editable : false
    },  {
        dataField : "ref2",
        headerText : "Ref6",
        editable : false
    }, {
        dataField : "ref6",
        headerText : "Ref7",
        editable : false
    },{
        dataField : "type",
        headerText : "Type",
        editable : false
    },{
        dataField : "debt",
        headerText : "Debt",
        editable : false
    },{
        dataField : "crdit",
        headerText : "Crdit",
        editable : false
    },
    {
        dataField : "stus",
        headerText : "stus",
        editable : false,
        visible : false
    },
    {
        dataField : "status",
        headerText : "Status",
        editable : false,
        width : 80,
        renderer : {
            type : "IconRenderer",
            iconWidth : 15, // icon 가로 사이즈, 지정하지 않으면 24로 기본값 적용됨
            iconHeight : 15,
            iconFunction : function(rowIndex, columnIndex, value, item) {
            	var selValue = AUIGrid.getCellValue(bankGridID, rowIndex, "stus");
            	
            	switch(selValue){
            	case "Mapped":
            		return "${pageContext.request.contextPath}/resources/images/common/status_on.gif";
            	default :
            		return "${pageContext.request.contextPath}/resources/images/common/status_off.gif";
            	}
            }
        }
    }
    ,{
        dataField : "othKeyinMappingDt",
        headerText : "Mapped Date",
        editable : false,
        dataType:"date",
        formatString:"yyyy-mm-dd"
    },{
        dataField : "ref4",
        headerText : "Deposit Slip No / EFT /MID",
        editable : false
    },{
        dataField : "fTrnscNewChqNo",
        headerText : "Chq No",
        editable : false
    },{
        dataField : "fTrnscRefVaNo",
        headerText : "VA number",
        editable : false
    }
    ];

	//AUIGrid 칼럼 설정 : targetRenMstGridID
	var targetRenMstColumnLayout = [
	    
	    { dataField:"custBillId" ,headerText:"Billing Group" ,editable : false , width : 100},
	    { dataField:"salesOrdId" ,headerText:"Order ID" ,editable : false , width : 100, visible : false },
	    { dataField:"salesOrdNo" ,headerText:"Order No" ,editable : false , width : 100 },
	    { dataField:"rpf" ,headerText:"RPF" ,editable : false , width : 100 , dataType : "numeric", formatString : "#,##0.00"},      
	    { dataField:"rpfPaid" ,headerText:"RPF Paid" ,editable : false , width : 100 , dataType : "numeric", formatString : "#,##0.00"},      
	    { dataField:"mthRentAmt" ,headerText:"Monthly RF" ,editable : false , width : 100 , dataType : "numeric", formatString : "#,##0.00"},      
	    { dataField:"balance" ,headerText:"Balance" ,editable : false , width : 100 , dataType : "numeric", formatString : "#,##0.00"},      
	    { dataField:"unBilledAmount" ,headerText:"UnBill" ,editable : false , width : 100 , dataType : "numeric", formatString : "#,##0.00"},  
	    { dataField:"lastPayment" ,headerText:"Last Payment" ,editable : false , width : 120 , dataType : "date", formatString : "yyyy-mm-dd"},
	    { dataField:"custNm" ,headerText:"Customer Name" ,editable : false , width : 250 },
	    {
	        dataField : "btnCheck",
	        headerText : "include",
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
	    { dataField:"billAmt" ,headerText:"Amount" ,editable : false , width : 100 , dataType : "numeric", formatString : "#,##0.00"},  
	    { dataField:"paidAmt" ,headerText:"Paid" ,editable : false , width : 100 , dataType : "numeric", formatString : "#,##0.00"},
	    { dataField:"targetAmt" ,headerText:"Target<br>Amount" ,editable : false , width : 100 , dataType : "numeric", formatString : "#,##0.00"},
	    { dataField:"billDt" ,headerText:"Bill Date" ,editable : false , width : 100},
	    { dataField:"stusCodeName" ,headerText:"Bill Status" ,editable : false , width : 100},
	    {
	        dataField : "btnCheck",
	        headerText : "include",
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
	    { dataField:"productPrice" ,headerText:"Product Price" ,editable : false , width : 100 , dataType : "numeric", formatString : "#,##0.00"},      
	    { dataField:"totalPaid" ,headerText:"Paid" ,editable : false , width : 100 , dataType : "numeric", formatString : "#,##0.00"},      
	    { dataField:"balance" ,headerText:"Balance<br>(-:Overpaid, +:Outstanding)" ,editable : false , width : 200 , dataType : "numeric", formatString : "#,##0.00"},      
	    { dataField:"reverseAmount" ,headerText:"Reversed" ,editable : false , width : 100, dataType : "numeric", formatString : "#,##0.00" },
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
	    { dataField:"filterCharges" ,headerText:"Filter Charges" ,editable : false , width : 100 , dataType : "numeric", formatString : "#,##0.00"},      
	    { dataField:"filterChargesPaid" ,headerText:"Filter Paid" ,editable : false , width : 100 , dataType : "numeric", formatString : "#,##0.00"},      
	    { dataField:"penaltyCharges" ,headerText:"Penalty Charges" ,editable : false , width : 100 , dataType : "numeric", formatString : "#,##0.00"},      
	    { dataField:"penaltyChargesPaid" ,headerText:"Penalty Paid" ,editable : false , width : 100 , dataType : "numeric", formatString : "#,##0.00"},      
	    { dataField:"srvCntrctRental" ,headerText:"Monthly Fees" ,editable : false , width : 100 , dataType : "numeric", formatString : "#,##0.00"},  
	    { dataField:"balance" ,headerText:"Balance" ,editable : false , width : 120 , dataType : "numeric", formatString : "#,##0.00"},
	    { dataField:"unBillAmount" ,headerText:"Unbill" ,editable : false , width : 120 , dataType : "numeric", formatString : "#,##0.00"},
	    { dataField:"lastPayment" ,headerText:"Last Payment" ,editable : false , width : 120 , dataType : "date", formatString : "yyyy-mm-dd"},
	    { dataField:"custName" ,headerText:"Customer Name" ,editable : false , width : 250 },
	    {
	        dataField : "btnCheck",
	        headerText : "include",
	        width: 80,
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
	    { dataField:"srvLdgrAmt" ,headerText:"Bill No." ,editable : false , width : 100, dataType : "numeric", formatString : "#,##0.00" },
	    { dataField:"paidTotal" ,headerText:"Paid" ,editable : false , width : 100 , dataType : "numeric", formatString : "#,##0.00"},  
	    { dataField:"targetAmt" ,headerText:"Target Amount" ,editable : false , width : 100 , dataType : "numeric", formatString : "#,##0.00"},    
	    { dataField:"srvLdgrRefDt" ,headerText:"Bill Date" ,editable : false , width : 100},
	    {
	        dataField : "btnCheck",
	        headerText : "include",
	        width: 80,
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
	    /*{ dataField:"trNo", headerText:"TR No.", editable:true, width:120},
	    { dataField:"trIssueDate", headerText:"TR Issue Date", width:120, dataType : "date", formatString:"dd-mm-yyyy",
	       editRenderer:{
	    	   type: "CalendarRenderer",
	    	   showEditorBtnOver : true,
	    	   onlyCalendar : true,
	    	   showExtraDays : true
	       }
	    },
	    { dataField:"collectorId", headerText:"", editable:false, visible:false},
	    { dataField:"collector", headerText:"Collector", editable:false, width:120,
	    	renderer : {
                type:"IconRenderer",
                iconPosition:"aisleRight",
                iconTableRef:{
                    "default" : "${pageContext.request.contextPath}/resources/images/common/icon_id_search.gif"
                },
                onclick:function(rowIndex, columnIndex, value, item){
                	//alert("rowIndex : " + rowIndex + ", value : " + value);
                	finalBillRowId = rowIndex;
                    fn_searchUserIdPop();
                }
            }	
	    },*/
	    { dataField:"procSeq" ,headerText:"Process Seq" ,editable : false , width : 120 , visible : false },
	    { dataField:"appType" ,headerText:"AppType" ,editable : false , width : 120 , visible : false },
	    { dataField:"advMonth" ,headerText:"AdvanceMonth" ,editable : false , width : 120 , dataType : "numeric", formatString : "#,##0.00" , visible : false },
	    { dataField:"billGrpId" ,headerText:"Bill Group ID" ,editable : false , width : 120},
	    { dataField:"billId" ,headerText:"Bill ID" ,editable : false , width : 100, visible : false },
	    { dataField:"ordId" ,headerText:"Order ID" ,editable : false , width : 100  , visible : false },
	    { dataField:"mstRpf" ,headerText:"Master RPF" ,editable : false , width : 100  , dataType : "numeric", formatString : "#,##0.00" , visible : false },
	    { dataField:"mstRpfPaid" ,headerText:"Master RPF Paid" ,editable : false , width : 100  , dataType : "numeric", formatString : "#,##0.00" , visible : false },
	    { dataField:"billNo" ,headerText:"Bill No" ,editable : false , width : 150 },      
	    { dataField:"ordNo" ,headerText:"Order No" ,editable : false , width : 100 },
	    { dataField:"billTypeId" ,headerText:"Bill TypeID" ,editable : false , width : 100 , visible : false },
	    { dataField:"billTypeNm" ,headerText:"Bill Type" ,editable : false , width : 180 },      
	    { dataField:"installment" ,headerText:"Installment" ,editable : false , width : 100 },      
	    { dataField:"billAmt" ,headerText:"Amount" ,editable : false , width : 100 , dataType : "numeric", formatString : "#,##0.00"},  
	    { dataField:"paidAmt" ,headerText:"Paid" ,editable : false , width : 100 , dataType : "numeric", formatString : "#,##0.00"},
	    { dataField:"targetAmt" ,headerText:"Target<br>Amount" ,editable : true , width : 100 , dataType : "numeric", formatString : "#,##0.00"},
	    { dataField:"billDt" ,headerText:"Bill Date" ,editable : false , width : 100 },
	    { dataField:"assignAmt" ,headerText:"assignAmt" ,editable : false , width : 100 , dataType : "numeric", formatString : "#,##0.00" , visible : false },
	    { dataField:"billStatus" ,headerText:"billStatus" ,editable : false , width : 100 , visible : false },
	    { dataField:"custNm" ,headerText:"custNm" ,editable : false , width : 300},
	    { dataField:"srvcContractID" ,headerText:"SrvcContractID" ,editable : false , width : 100 , visible : false },
	    { dataField:"billAsId" ,headerText:"Bill AS Id" ,editable : false , width : 150 , visible : false },
	    { dataField:"discountAmt" ,headerText:"discountAmt" ,editable : false , width : 100 , dataType : "numeric", formatString : "#,##0.00" , visible : false },
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
	    { dataField:"nric" ,headerText:"Cust NRIC" ,editable : false , width : 120 , visible : false },     
	    { dataField:"billMemNm" ,headerText:"HP Name." ,editable : false , width : 250 , visible : false },
	    { dataField:"billMemCode" ,headerText:"HP Code." ,editable : false , width : 100 , visible : false },
	    { dataField:"ruleDesc" ,headerText:"Pay Type" ,editable : false , width : 200 },  
	    { dataField:"billDt" ,headerText:"Date" ,editable : false , width : 100 },  
	    { dataField:"billAmt" ,headerText:"Amount" ,editable : false , width : 100 , dataType : "numeric", formatString : "#,##0.00"},
	    { dataField:"paidAmt" ,headerText:"Paid Amount" ,editable : false , width : 100 , dataType : "numeric", formatString : "#,##0.00"},
	    { dataField:"billRem" ,headerText:"Remark" ,editable : false , width : 100 },
	    { dataField:"billIsPaid" ,headerText:"Paid?" ,editable : false , width : 100 },
	    { dataField:"billIsComm" ,headerText:"Commission?" ,editable : false , width : 100 },
	    { dataField:"stusNm" ,headerText:"Status" ,editable : false , width : 100 },
	    {
	        dataField : "btnCheck",
	        headerText : "include",
	        width: 80,
	        renderer : {
	            type : "CheckBoxEditRenderer",            
	            editable : true, // 체크박스 편집 활성화 여부(기본값 : false)
	            checkValue : "1", // true, false 인 경우가 기본
	            unCheckValue : "0"            
	        }
	    }
	];


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
	  var tempPendingAmt = parseInt(AUIGrid.getCellValue(pendingGridID,1,"pendingAmount"));
	  var tempTot = tempPendingAmt - totalAmt;
	  AUIGrid.updateRow(pendingGridID, { "pendingAmount" : tempTot }, 0);
	}

	//Rental Amount 선납금 할인을 적용한 금액 표시
	function recalculateRentalTotalAmtWidthAdv(discountValue, originalPrice, discountrate) {
	    var tot = 0;
	    var mstRowCnt = AUIGrid.getRowCount(targetRenMstGridID);
	    var mstOrdNo = '';

	    if(mstRowCnt > 0){
	        for(var i = 0; i < mstRowCnt; i++){
	        	mstBtnCheck = AUIGrid.getCellValue(targetRenMstGridID,i,"btnCheck"); 
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
	
	function resetRentalGrid(){
	    AUIGrid.clearGridData(targetRenMstGridID);
	    AUIGrid.clearGridData(targetRenDetGridID);
	}
	
	function resetOutGrid(){
	    AUIGrid.clearGridData(targetOutMstGridID);
	}
	
	function resetSrvcGrid(){
	    AUIGrid.clearGridData(targetSrvcMstGridID);
	    AUIGrid.clearGridData(targetSrvcDetGridID);
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
	
	function addRentalToFinal(){
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
	                   
	               }
	            }
	        }
	    }
	    recalculatePaymentTotalAmt();
	}

	function addOutToFinal(){
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
	            }
	        }
	    } 
	    recalculatePaymentTotalAmt();
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
	                    }
	                }
	            }
	        }
	    }
	    recalculatePaymentTotalAmt();  
	}
    
	function addBillToFinal(){

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
	                    }
	                }
	            }   
	        }
	        
	        recalculatePaymentTotalAmt();
	    }
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
  
    function viewRentalLedger(){
        if($("#rentalOrdId").val() != ''){
            Common.popupDiv("/sales/order/orderLedgerViewPop.do", {ordId : $("#rentalOrdId").val()});
        }else{
            Common.alert('<b>Please Select a Order Info first</b>');
            return;
        }
            
    }
  
    function viewSrvcLedger(){
        if($("#srvcOrdId").val() != ''){
            Common.popupDiv("/sales/order/orderLedgerViewPop.do", {ordId : $("#srvcOrdId").val()});
        }else{
            Common.alert('<b>Please Select a Order Info first</b>');
            return;
        }
            
    }
    
    function fn_clear(){
    	$("#searchForm")[0].reset();
    	AUIGrid.clearGridData();
    }
    
    function fn_searchList(){
    	if($("#bankDateFr").val() != '' && $("#bankDateTo").val() != ''){
	    	Common.ajax("GET","/payment/selectBankStatementList.do",$("#searchForm").serializeJSON(), function(result){         
	            AUIGrid.setGridData(bankGridID, result);
	        });
	    }//else{Common.alert("key in Bank In Date..");}
    }
    
    function fn_mapping(){
    	
    	if(isMapped == 'Mapped'){
    		Common.alert("This item has already been confirmed payment.");
    	}else{

    		var item = new Object();
    		//var rowId = AUIGrid.getSelectedIndex();
    		
            item.bank = AUIGrid.getCellValue(bankGridID,rowId,"bank");
            item.bankAccount = AUIGrid.getCellValue(bankGridID,rowId,"bankAccName");
            item.date = AUIGrid.getCellValue(bankGridID,rowId,"trnscDt");
            item.refChequeNo = AUIGrid.getCellValue(bankGridID,rowId,"chqNo");
            item.mode = AUIGrid.getCellValue(bankGridID,rowId,"type");
            item.trId = AUIGrid.getCellValue(bankGridID,rowId,"ref3");
            item.amount = AUIGrid.getCellValue(bankGridID,rowId,"crdit");
            
            console.log(item);
    		
    		if($('#payMode').val() == '105'){
    			item.pendingAmount = $("#cash").find("#amount").val();
    			
    			//Transaction Date 체크
                if(FormUtil.checkReqValue($("#trDateCash"))){
                    Common.alert('* Transaction Date is empty');
                    return;
                }
    			
                if(FormUtil.checkReqValue($("#cash").find("#amount")) ||$("#cash").find("#amount").val() <= 0 ){
                    Common.alert('* No Amount ');
                    return;
                }
    			
    		}else if($('#payMode').val() == '106'){
    			item.pendingAmount = $("#cheque").find("#amount").val();
    			
    			//Transaction Date 체크
                if(FormUtil.checkReqValue($("#trDateCheque"))){
                    Common.alert('* Transaction Date is empty');
                    return;
                }
    			
                if(FormUtil.checkReqValue($("#cheque").find("#amount")) ||$("#cheque").find("#amount").val() <= 0 ){
                    Common.alert('* No Amount ');
                    return;
                }
                
    		}
    		   else if($('#payMode').val() == '108'){
    			var amt = 0;
    			var chgAmt = 0;
    			amt = parseInt($("#online").find("#amount").val());
    			chgAmt = parseInt($("#online").find("#chargeAmount").val());
    			var tot = amt+chgAmt;
    			item.pendingAmount = tot;
    			
    			//Transaction Date 체크
                if(FormUtil.checkReqValue($("trDateOnline"))){
                    Common.alert('* Transaction Date is empty');
                    return;
                }
    			
                if(FormUtil.checkReqValue($("#online").find("#amount")) ||$("#online").find("#amount").val() <= 0 ){
                    Common.alert('* No Amount ');
                    return;
                }
                
            }
    		
    		AUIGrid.addRow(pendingGridID, item, "last");
    		
    		$("#page1").hide();
    		$("#page2").show();
    		AUIGrid.resize(pendingGridID);
    		
    		$("#rentalSearch").show();
            AUIGrid.resize(targetRenMstGridID); 
            AUIGrid.resize(targetRenDetGridID); 
            
            AUIGrid.resize(targetFinalBillGridID);
            
            
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
  
    function fn_chgAppType(){
        var appType = $("#appType").val();
        //AUIGrid.clearGridData(targetFinalBillGridID);
        
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
  
  function savePayment(){
	    
	    //param data array
	    var data = {};
	    
	    var gridList = AUIGrid.getGridData(targetFinalBillGridID);       //그리드 데이터
	    
	    var mode = $('#payMode').val() ;
	    var formList;//폼 데이터
	    if(mode == '105' ){
	    	formList = $("#cashForm").serializeArray();
	    }else if(mode == '106'){
	    	formList = $("#chequeForm").serializeArray();
	    }
	    else if(mode == '108'){
	    	formList = $("#onlineForm").serializeArray();
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
	    
	    
	    data.key = [AUIGrid.getCellValue(bankGridID, rowId, "id")]; //id값
	    
	    //Bill Payment : Order 정보 조회
	    Common.ajax("POST", "/payment/common/saveNormalPayment.do", data, function(result) {
	        Common.alert("Success Payment Process", function(){
	              document.location.href = '/payment/initOtherPayment.do';
	            
	        });
	        
	    });
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
//Collector 조회 팝업
  function fn_searchUserIdPop(param) {
      Common.popupDiv("/common/memberPop.do", { callPrgm : "PAYMENT_PROCESS" }, null, true);
      console.log(param);
      payTypeIndicator = param;
  }

  //Collector 조회 팝업 결과값 세팅
  function fn_loadOrderSalesman(memId, memCode, memNm){	  
	  if(payTypeIndicator != undefined){
	      payTypeIndicator.find('#keyInCollMemId').val(memId);
	      payTypeIndicator.find('#keyInCollMemNm').val(memNm);
	  }
      //alert("targetFinal : " + AUIGrid.getSelectedIndex(targetFinalBillGridID));
     // var selectedValue = AUIGrid.getSelectedIndex(targetFinalBillGridID);
    //  AUIGrid.updateRow(targetFinalBillGridID, { "collector" : memNm }, selectedValue[0]);
      //AUIGrid.updateRow(targetFinalBillGridID, { "collectorId" : memId }, selectedValue[0]);
      
  }
</script>
<!-- content start -->

<section id="content">
<ul class="path">
        <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
        <li>Payment</li>
        <li>Normal Key-In</li>
    </ul>
<div id="page1">
    <!-- title_line start -->
    <aside class="title_line">
		<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
		<h2>Normal Key-In</h2>
		<ul class="right_btns">
		    <li><p class="btn_blue"><a href="#" onclick="fn_mapping();">Mapping</a></p></li>
		    <li><p class="btn_blue"><a href="#" onclick="fn_searchList();"><span class="search"></span>Search</a></p></li>
		    <li><p class="btn_blue"><a href="#" onclick="fn_clear();"><span class="clear"></span>Clear</a></p></li>
		</ul>
	</aside><!-- title_line end -->
    <!-- search_table start -->
    <section class="search_table"><!-- search_table start -->
		<form id="searchForm" action="#" method="post">
			<table class="type1"><!-- table start -->
				<caption>table</caption>
				<colgroup>
				    <col style="width:170px" />
				    <col style="width:*" />
				    <col style="width:170px" />
                    <col style="width:*" />
				</colgroup>
				<tbody>
                    <tr>
                           <th>Bank In Date</th>
                           <td>
                                <!-- date_set start -->
	                            <div class="date_set">
		                            <p><input type="text" id="bankDateFr" name="bankDateFr" title="Bank In Start Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
		                            <span>To</span>
		                            <p><input type="text" id="bankDateTo" name="bankDateTo" title="Bank In End Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
	                            </div>
	                            <!-- date_set end -->
                           </td>
                           <th>Type</th>
                           <td>
                                <select id="searchPayType" name="searchPayType" class="w100p" >
	                                <option value="ALL">All</option>
	                                <option value="CSH">Cash</option>
	                                <option value="CHQ">Cheque</option>
	                                <option value="ONL">Online</option>
                                </select>
                           </td>
                    </tr>
				</tbody>
			</table>
			<!-- table end -->
		</form>
	</section><!-- search_table end -->
    <!-- search_result start -->
    <section class="search_result">
        <!-- grid_wrap start -->
        <article id="grid_wrap" class="grid_wrap"></article>
        <!-- grid_wrap end -->
    </section>
    <!-- search_result end -->
    <table class="type1"><!-- table start -->
        <caption>table</caption>
        <colgroup>
            <col style="width:170px" />
            <col style="width:*" />
        </colgroup>
        <tbody>
            <tr>
                <th scope="row">Payment Mode</th>
                <td>
                    <select id="payMode" name="payMode" class="w100p">
                        <option value="105" selected>Cash</option>
                        <option value="106">Cheque</option>
                        <option value="108">On-line</option>
                    </select>
                </td>
            </tr>
        </tbody>
    </table>
       
<div id="online" style="display:none;">
    <form id="onlineForm" name="onlineForm">
    <input type="hidden" id="payType" name="payType" />
    <table class="type1"><!-- table start -->
        <caption>table</caption>
        <colgroup>
            <col style="width:170px" />
            <col style="width:*" />
            <col style="width:230px" />
            <col style="width:*" />
        </colgroup>
        <tbody>
            <tr>
                <th scope="row">Amount<span class="must">*</span></th>
                <td>
                    <input type="text" id="amount" name="amount" class="w100p"  maxlength="10" onkeydown='return FormUtil.onlyNumber(event)'/>
                </td>
                <th scope="row">Bank Charge Amount</th>
                <td>
                   <input type="text" id="chargeAmount" name="chargeAmount" class="w100p"  maxlength="10" onkeydown='return FormUtil.onlyNumber(event)' />
                </td>
            </tr>
            <tr>
                <th>Transaction Date<span class="must">*</span></th>
                   <td>
                        <input type="text" id="trDateOnline" name="trDate" placeholder="DD/MM/YYYY" class="j_date w100p" readonly/>
                  </td>
                  <th>EFT</th>
                  <td><input type="text" name="eft" id="eft" class="w100p"/></td>
            </tr>
            <tr>
                <th>PayerName</th>
                <td>
                   <input type="text" id="payerName" name="payerName" class="w100p"  />
                </td>
                <th>Ref Details/Jompay Ref</th>
                <td>
                   <input type="text" id="jomPay" name="jomPay" class="w100p"  />
                </td>
            </tr>
            <tr>
                <th scope="row">Bank Type</th>
                <td>
                    <select id="bankType" name="bankType" class="w100p" >
                        <option value="">Choose One</option>
                        <option value="2728">JomPay</option>
                        <option value="2729">MBB CDM</option>
                        <option value="2730">VA</option>
                        <option value="2731">Others</option>
                    </select>
                </td>
                <th>Bank Account</th>
                <td id="acc"></td>
            </tr>
            <tr>
                   <th>VA Account</th>
                   <td><input type="text" id="va" name="va" class="w100p" maxlength="16" disabled/></td>
                   <th></th>
                   <td></td>
            </tr>
            <tr>
                   <th>Remark</th>
                   <td colspan="3">
                        <textarea name="remark" id="remark" cols="20" rows="5" placeholder=""></textarea>
                   </td>
            </tr>
            <tr>
                 <th scope="row">TR No.</th>
                        <td>
                            <input id="keyInTrNo" name="keyInTrNo" type="text" title="" placeholder="" class="w100p" maxlength="10" />
                        </td>
                        <th scope="row">TR Issue Date</th>
                 <td>
                     <input id="keyInTrIssueDateOnline" name="keyInTrIssueDate" type="text" title="" placeholder="" class="j_date w100p" readonly />
                 </td>
             </tr>
             <tr>
                 <th scope="row">Collector</th>
                 <td>
                     <input id="keyInCollMemId" name="keyInCollMemId" type="hidden" title="" placeholder="" class="readonly" readonly  />                            
                     <input id="keyInCollMemNm" name="keyInCollMemNm" type="text" title="" placeholder="" class="readonly" readonly  />
                     <a id="btnSalesmanPop" href="javascript:fn_searchUserIdPop($('#online'));" class="search_btn">
                         <img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" />
                     </a>
                 </td>
                 <th>Pay Date</th>
                 <td>
                    <input id="keyInPayDateOnline" name="keyInPayDate" type="text" title="" placeholder="" class="j_date w100p" readonly />
                 </td>
             </tr>
        </tbody>
    </table>
    </form>
</div>
<div id="cash" style="display:none;">
    <form id="cashForm" name="cashForm">
    <input type="hidden" id="payType" name="payType" />
    <table class="type1"><!-- table start -->
        <caption>table</caption>
        <colgroup>
            <col style="width:170px" />
            <col style="width:*" />
            <col style="width:230px" />
            <col style="width:*" />
        </colgroup>
        <tbody>
            <tr>
                <th scope="row">Amount<span class="must">*</span></th>
                <td>
                   <input type="text" id="amount" name="amount" class="w100p" maxlength="10" onkeydown='return FormUtil.onlyNumber(event)' />
                </td>
                <th scope="row">Bank Type</th>
                <td>
                    <select id="bankType" name="bankType" class="w100p" >
                        <option value="">Choose One</option>
                        <option value="2728">JomPay</option>
                        <option value="2729">MBB CDM</option>
                        <option value="2730">VA</option>
                        <option value="2731">Others</option>
                    </select>
                </td>
            </tr>
            <tr>
                   <th>Bank Account</th>
                   <td id="acc"></td>
                   <th>VA Account</th>
                   <td><input type="text" id="va" name="va" class="w100p" maxlength="16" disabled/></td>
            </tr>
            <tr>
                <th>Transaction Date<span class="must">*</span></th>
                   <td>
                        <input type="text" id="trDateCash" name="trDate" placeholder="DD/MM/YYYY" class="j_date w100p" readonly/>
                   </td>
                <th scope="row">Slip No.</th>
                <td>
                   <input type="text" id="slipNo" name="slipNo" class="w100p"  />
                </td>
            </tr>
            <tr>
                <th>PayerName</th>
                <td>
                   <input type="text" id="payerName" name="payerName" class="w100p"  />
                </td>
                <th>Ref Details/Jompay Ref</th>
                <td>
                   <input type="text" id="jomPay" name="jomPay" class="w100p"  />
                </td>
            </tr>
            <tr>
                   <th>Remark</th>
                   <td colspan="3">
                        <textarea name="remark" id="remark" cols="20" rows="5" placeholder=""></textarea>
                   </td>
            </tr>
            <tr>
                   <th scope="row">TR No.</th>
                        <td>
                            <input id="keyInTrNo" name="keyInTrNo" type="text" title="" placeholder="" class="w100p" maxlength="10" />
                        </td>
                        <th scope="row">TR Issue Date</th>
                   <td>
                       <input id="keyInTrIssueDateCash" name="keyInTrIssueDate" type="text" title="" placeholder="" class="j_date w100p" readonly />
                   </td>
               </tr>
               <tr>
                   <th scope="row">Collector</th>
                   <td>
                       <input id="keyInCollMemId" name="keyInCollMemId" type="hidden" title="" placeholder="" class="readonly" readonly  />                            
                       <input id="keyInCollMemNm" name="keyInCollMemNm" type="text" title="" placeholder="" class="readonly" readonly  />
                       <a id="btnSalesmanPop" href="javascript:fn_searchUserIdPop($('#cash'));" class="search_btn">
                           <img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" />
                       </a>
                   </td>
                   <th>Pay Date</th>
                  <td>
                       <input id="keyInPayDateCash" name="keyInPayDate" type="text" title="" placeholder="" class="j_date w100p" readonly />
                  </td>
               </tr>
        </tbody>
    </table>
    </form>
    </div>
 <div id="cheque" style="display:none;">
    <form id="chequeForm" name="chequeForm">
    <input type="hidden" id="payType" name="payType" />
    <table class="type1"><!-- table start -->
        <caption>table</caption>
        <colgroup>
            <col style="width:170px" />
            <col style="width:*" />
            <col style="width:230px" />
            <col style="width:*" />
        </colgroup>
        <tbody>
            <tr>
                <th scope="row">Amount<span class="must">*</span></th>
                <td>
                   <input type="text" id="amount" name="amount" class="w100p" maxlength="10" onkeydown='return FormUtil.onlyNumber(event)' />
                </td>
                <th scope="row">Bank Type</th>
                <td>
                    <select id="bankType" name="bankType" class="w100p" >
                        <option value="">Choose One</option>
                        <option value="2728">JomPay</option>
                        <option value="2729">MBB CDM</option>
                        <option value="2730">VA</option>
                        <option value="2731">Others</option>
                    </select>
                </td>
            </tr>
            <tr>
                   <th>Bank Account</th>
                   <td id="acc"></td>
                   <th>VA Account</th>
                   <td><input type="text" id="va" name="va" class="w100p" maxlength="16" disabled/></td>
            </tr>
            <tr>
                <th>Transaction Date<span class="must">*</span></th>
                   <td>
                        <input type="text" id="trDateCheque" name="trDate" placeholder="DD/MM/YYYY" class="j_date w100p" readonly/>
                   </td>
                <th scope="row">Slip No.</th>
                <td>
                   <input type="text" id="chqNo" name="chqNo" class="w100p"  />
                </td>
            </tr>
            <tr>
                <th>PayerName</th>
                <td>
                   <input type="text" id="payerName" name="payerName" class="w100p"  />
                </td>
                <th>Ref Details/Jompay Ref</th>
                <td>
                   <input type="text" id="jomPay" name="jomPay" class="w100p"  />
                </td>
            </tr>
            <tr>
                   <th>Remark</th>
                   <td colspan="3">
                        <textarea name="remark" id="remark" cols="20" rows="5" placeholder=""></textarea>
                   </td>
            </tr>
            <tr>
                  <th scope="row">TR No.</th>
                        <td>
                            <input id="keyInTrNo" name="keyInTrNo" type="text" title="" placeholder="" class="w100p" maxlength="10" />
                        </td>
                        <th scope="row">TR Issue Date</th>
                  <td>
                      <input id="keyInTrIssueDateCheque" name="keyInTrIssueDate" type="text" title="" placeholder="" class="j_date w100p" readonly />
                  </td>
              </tr>
              <tr>
                  <th scope="row">Collector</th>
                  <td>
                      <input id="keyInCollMemId" name="keyInCollMemId" type="hidden" title="" placeholder="" class="readonly" readonly  />                            
                      <input id="keyInCollMemNm" name="keyInCollMemNm" type="text" title="" placeholder="" class="readonly" readonly  />
                      <a id="btnSalesmanPop" href="javascript:fn_searchUserIdPop($('#cheque'));" class="search_btn">
                          <img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" />
                      </a>
                  </td>
                  <th>Pay Date</th>
                  <td>
                        <input id="keyInPayDateCheque" name="keyInPayDate" type="text" title="" placeholder="" class="j_date w100p" readonly /> 
                  </td>
              </tr>
        </tbody>
    </table>
    </form>
    </div>
</div>
 <div id="page2" style="display:none;">
    <aside class="title_line">
        <p class="fav"><a href="#" class="click_add_on">My menu</a></p>
        <h2>Normal Payment</h2>
    </aside>
<!-- grid_wrap start (Pending Amount)-->
        <article id="grid_wrap_pending" class="grid_wrap"></article>
<!-- grid_wrap end (Pending Amount)-->

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
    <article class="grid_wrap mt10" >
        <div id="target_finalBill_grid_wrap" style="width: 100%; height: 220px; margin: 0 auto;"></div>
    </article>
    <!-- grid_wrap end -->
    
    <ul class="right_btns">
            <li><p class="amountTotalSttl">Amount Total :</p></li>
            <li><strong id="paymentTotalAmtTxt">RM 0.00</strong></li>
        </ul>
    
    <ul class="right_btns mt10">
       <li><p class="btn_grid"><a href="javascript:savePayment();">SAVE</a></p></li>
    </ul>

</div>
</section>


