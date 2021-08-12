<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<style type="text/css">
    /* 커스텀 칼럼 스타일 정의 */
    .aui-grid-user-custom {
        text-align:center;
    }

    .aui-grid-user-custom .aui-checkLabelBox {
        margin-left: 10px;
        text-align:left;
    }

    .my-active-style {
        background:#FFFFFF;
        font-weight:bold;
    }

    .my-inactive-style {
        background:#E5E5E5;
    }
</style>
<script type="text/javaScript">
//AUIGrid 그리드 객체
var myGridID;
var targetRenMstGridID;
var targetRenDetGridID;
var targetNonRenMstGridID;
var targetSvmMstGridID;

//Default Combo Data
var transTypeData = [{"codeId": "1","codeName": "Order Payment"},{"codeId": "2","codeName": "Membership Payment"},{"codeId": "3","codeName": "AS Bill Payment"}];

//AUIGrid 칼럼 설정
var columnLayout = [
    {
        dataField : "btnCheck",
        headerText : " ",
        width: 50,
        renderer : {
            type : "CheckBoxEditRenderer",            
            editable : true, // 체크박스 편집 활성화 여부(기본값 : false)
            checkValue : "1", // true, false 인 경우가 기본
            unCheckValue : "0",

            //사용자가 체크 상태를 변경하고자 할 때 변경을 허락할지 여부를 지정할 수 있는 함수 입니다.
            checkableFunction :  function(rowIndex, columnIndex, value, isChecked, item, dataField ) {
                // 행 아이템의 btnCheckYN이 N이면 수정 불가
                if(item.btnCheckYN == "N") {
                    return false;
                }else{

                    //체크 해제시 : value는 변경전 값
                    if(value == 1){
                        AUIGrid.setCellValue(myGridID, rowIndex, "transferAmt", "0");                       
                        AUIGrid.setCellValue(myGridID, rowIndex, "transferAmtChangeYN", "N");                     
                    }else{                    
                        AUIGrid.setCellValue(myGridID, rowIndex, "transferAmt", item.availAmt);                       
                        AUIGrid.setCellValue(myGridID, rowIndex, "transferAmtChangeYN", "Y");                     
                    }
                }

                recalculateTransferAmt();
                return true;
            },
            
            disabledFunction :  function(rowIndex, columnIndex, value, isChecked, item, dataField ) {
                // 행 아이템의 btnCheckYN이 N이면 수정 불가
                if(item.btnCheckYN == "N") {
                    return true;
                }

                return false;
            }
        }
    },
    { 
        dataField:"allowTrnsfrId",
        headerText:"<spring:message code='pay.head.allowTransfer'/>",
        width: 80 ,
        renderer : {
            type : "CheckBoxEditRenderer",            
            checkValue : "1",
            unCheckValue : "0"
        }    
    },
    { 
        dataField:"isFundTrnsfrItm",
        headerText:"<spring:message code='pay.head.fundTransferItem'/>",
        width: 100 ,
        renderer : {
            type : "CheckBoxEditRenderer",            
            checkValue : "1",
            unCheckValue : "0"
        }    
    },
    { dataField:"payMode" ,headerText:"<spring:message code='pay.head.payMode'/>",editable : false, width: 100 },
    { dataField:"amt" ,headerText:"<spring:message code='pay.head.amt'/>" ,editable : false , width: 100, dataType : "numeric", formatString : "#,##0.00"},
    { dataField:"revAmt" ,headerText:"<spring:message code='pay.head.revAmt'/>" ,editable : false , width: 100, dataType : "numeric", formatString : "#,##0.00"},
    { dataField:"availAmt" ,headerText:"<spring:message code='pay.head.availableAmt'/>" ,editable : false , width: 100, dataType : "numeric", formatString : "#,##0.00"},
    {
        dataField : "transferAmt",
        headerText : "<spring:message code='pay.head.transferAmt'/>",        
        dataType : "numeric",
        editable : true,
        width : 100, 
        formatString : "#,##0.00",
        style : "aui-grid-user-custom-right",
        editRenderer : {
            type : "InputEditRenderer",
            showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 보이기
            onlyNumeric : true, // 0~9만 입력가능
            allowPoint : true, // 소수점( . ) 도 허용할지 여부
            allowNegative : false, // 마이너스 부호(-) 허용 여부
            textAlign : "right", // 오른쪽 정렬로 입력되도록 설정            
            autoThousandSeparator : true // 천단위 구분자 삽입 여부
        },
        styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
            if(item.transferAmtChangeYN == "Y") {
                return "my-active-style";
            } else {              
                return "my-inactive-style";
            }
            return "";
        }
    },
    { dataField:"refNo" ,headerText:"<spring:message code='pay.head.refNo'/>" ,editable : false , width : 100},
    { dataField:"refDt" ,headerText:"<spring:message code='pay.head.refDate'/>" ,editable : false , width : 100 , dataType : "date", formatString : "dd-mm-yyyy"},
    { dataField:"chqNo" ,headerText:"<spring:message code='pay.head.chqNo'/>" ,editable : false , width : 100 },
    { dataField:"bankCode" ,headerText:"<spring:message code='pay.head.issBank'/>" ,editable : false , width : 100 },
    { dataField:"cardType" ,headerText:"<spring:message code='pay.head.cardType'/>" ,editable : false , width : 100 },
    { dataField:"ccType" ,headerText:"<spring:message code='pay.head.crcType'/>" ,editable : false , width : 100 },
    { dataField:"ccNo" ,headerText:"<spring:message code='pay.head.crcNo'/>" ,editable : false , width : 100 },
    { dataField:"ccHolderName" ,headerText:"<spring:message code='pay.head.crcHolder'/>" ,editable : false , width : 100 },
    { dataField:"ccExpr" ,headerText:"<spring:message code='pay.head.crcExpiry'/>" ,editable : false , width : 100 },
    { dataField:"isOnline" ,headerText:"<spring:message code='pay.head.online'/>" ,editable : false , width : 100 },
    { dataField:"accCode" ,headerText:"<spring:message code='pay.head.accCode'/>" ,editable : false , width : 100 },
    { dataField:"rem" ,headerText:"<spring:message code='pay.head.remark'/>" ,editable : false , width : 200 },
    { dataField:"isAllowTrnsfr" ,headerText:"<spring:message code='pay.head.isAllowTransfer'/>",editable : false , visible : false},
    { dataField:"btnCheckYN" ,headerText:"<spring:message code='pay.head.btnCheckYN'/>",editable : false , visible : false},
    { dataField:"transferAmtChangeYN" ,headerText:"<spring:message code='pay.head.btnCheckYN'/>",editable : false , visible : false}
];

//AUIGrid 칼럼 설정 : targetRenMstGridID
var targetRenMstColumnLayout = [
    
    { dataField:"custBillId" ,headerText:"<spring:message code='pay.head.billingGroup'/>" ,editable : false , width : 100},
    { dataField:"salesOrdId" ,headerText:"<spring:message code='pay.head.orderId'/>" ,editable : false , width : 100, visible : false },
    { dataField:"salesOrdNo" ,headerText:"<spring:message code='pay.head.orderNo'/>" ,editable : false , width : 100 },
    { dataField:"rpf" ,headerText:"<spring:message code='pay.head.rpf'/>" ,editable : false , width : 100 , dataType : "numeric", formatString : "#,##0.##"},      
    { dataField:"rpfPaid" ,headerText:"<spring:message code='pay.head.rpfPaid'/>" ,editable : false , width : 100 , dataType : "numeric", formatString : "#,##0.##"},      
    { dataField:"mthRentAmt" ,headerText:"<spring:message code='pay.head.mothlyRf'/>" ,editable : false , width : 100 , dataType : "numeric", formatString : "#,##0.##"},      
    { dataField:"balance" ,headerText:"<spring:message code='pay.head.balance'/>" ,editable : false , width : 100 , dataType : "numeric", formatString : "#,##0.##"},      
    { dataField:"unBilledAmount" ,headerText:"<spring:message code='pay.head.unbill'/>" ,editable : false , width : 100 },
    { dataField:"lastPayment" ,headerText:"<spring:message code='pay.head.lastPayment'/>" ,editable : false , width : 120 , dataType : "date", formatString : "yyyy-mm-dd"},
    { dataField:"custNm" ,headerText:"<spring:message code='pay.head.customerName'/>" ,editable : false , width : 250 }
];

//AUIGrid 칼럼 설정 : targetRenDetGridID
var targetRenDetColumnLayout = [
    
    { dataField:"billGrpId" ,headerText:"<spring:message code='pay.head.billGroupId'/>" ,editable : false , width : 120, visible : false },
    { dataField:"billId" ,headerText:"<spring:message code='pay.head.billId'/>" ,editable : false , width : 100, visible : false },
    { dataField:"billNo" ,headerText:"<spring:message code='pay.head.billNo'/>" ,editable : false , width : 150 },
    { dataField:"ordId" ,headerText:"<spring:message code='pay.head.orderId'/>" ,editable : false , width : 100 , visible : false },  
    { dataField:"ordNo" ,headerText:"<spring:message code='pay.head.orderNO'/>" ,editable : false , width : 100 },      
    { dataField:"billTypeNm" ,headerText:"<spring:message code='pay.head.billType'/>" ,editable : false , width : 180 },      
    { dataField:"installment" ,headerText:"<spring:message code='pay.head.installment'/>" ,editable : false , width : 100 },      
    { dataField:"billAmt" ,headerText:"<spring:message code='pay.head.amount'/>" ,editable : false , width : 100 },
    { dataField:"paidAmt" ,headerText:"<spring:message code='pay.head.paid'/>" ,editable : false , width : 100 , dataType : "numeric", formatString : "#,##0.##"},
    { dataField:"targetAmt" ,headerText:"<spring:message code='pay.head.targetAmount'/>" ,editable : false , width : 100 , dataType : "numeric", formatString : "#,##0.##"},
    { dataField:"billDt" ,headerText:"<spring:message code='pay.head.billDate'/>" ,editable : false , width : 100 , dataType : "date", formatString : "yyyy-mm-dd"},
    { dataField:"billStatus" ,headerText:"<spring:message code='pay.head.billStatus'/>" ,editable : false , width : 100},
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

//AUIGrid 칼럼 설정 : targetNonRenMstGridID
var targetNonRenMstColumnLayout = [
    { dataField:"salesOrdId" ,headerText:"<spring:message code='pay.head.orderId'/>" ,editable : false , width : 100, visible : false },
    { dataField:"salesOrdNo" ,headerText:"<spring:message code='pay.head.orderNO'/>" ,editable : false , width : 120 },
    { dataField:"custNm" ,headerText:"<spring:message code='pay.head.customerName'/>" ,editable : false , width : 180},      
    { dataField:"productPrice" ,headerText:"<spring:message code='pay.head.productPrice'/>" ,editable : false , width : 100 , dataType : "numeric", formatString : "#,##0.##"},      
    { dataField:"totalPaid" ,headerText:"<spring:message code='pay.head.paid'/>" ,editable : false , width : 100 , dataType : "numeric", formatString : "#,##0.##"},      
    { dataField:"balance" ,headerText:"<spring:message code='pay.head.balanceLongText'/>" ,editable : false , width : 200 , dataType : "numeric", formatString : "#,##0.##"},      
    { dataField:"reverseAmount" ,headerText:"<spring:message code='pay.head.reversed'/>" ,editable : false , width : 100 },
    { dataField:"lastPayment" ,headerText:"<spring:message code='pay.head.lastPayment'/>" ,editable : false , width : 120 , dataType : "date", formatString : "yyyy-mm-dd"},
    { dataField:"userName" ,headerText:"<spring:message code='pay.head.creatorName'/>" ,editable : false , width : 200 }
];

//AUIGrid 칼럼 설정 : targetSvmMstGridID
var targetSvmMstColumnLayout = [
    { dataField:"memNo" ,headerText:"<spring:message code='pay.head.svmNo'/>" ,editable : false , width : 120 },
    { dataField:"stusCode" ,headerText:"<spring:message code='pay.head.status'/>" ,editable : false , width : 100 },
    { dataField:"startDt" ,headerText:"<spring:message code='pay.head.startDate'/>" ,editable : false , width : 100 , dataType : "date", formatString : "yyyy-mm-dd"},      
    { dataField:"endDt" ,headerText:"<spring:message code='pay.head.endDate'/>" ,editable : false , width : 100 , dataType : "date", formatString : "yyyy-mm-dd"},      
    { dataField:"pckgChrg" ,headerText:"<spring:message code='pay.head.packageCharge'/>" ,editable : false , width : 120 , dataType : "numeric", formatString : "#,##0.##"},      
    { dataField:"pckgOtstnd" ,headerText:"<spring:message code='pay.head.packageOutstanding'/>" ,editable : false , width : 120 , dataType : "numeric", formatString : "#,##0.##"},      
    { dataField:"filterChrg" ,headerText:"<spring:message code='pay.head.filterCharge'/>" ,editable : false , width : 120 , dataType : "numeric", formatString : "#,##0.##"},
    { dataField:"filterOtstnd" ,headerText:"<spring:message code='pay.head.filterOutstanding'/>" ,editable : false , width : 120 , dataType : "numeric", formatString : "#,##0.##"},
    { dataField:"totOtstnd" ,headerText:"<spring:message code='pay.head.totalOutstanding'/>" ,editable : false , width : 120 , dataType : "numeric", formatString : "#,##0.##"},
    {
        dataField : "btnCheck",
        headerText : "<spring:message code='pay.head.exclude'/>",
        width: 80,
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

    // Fund Transfer Item List  그리드 생성
    myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout,null,gridPros);
    targetRenMstGridID = GridCommon.createAUIGrid("target_rental_grid_wrap", targetRenMstColumnLayout,null,targetGridPros);
    targetRenDetGridID = GridCommon.createAUIGrid("target_rentalD_grid_wrap", targetRenDetColumnLayout,null,targetGridPros);
    targetNonRenMstGridID = GridCommon.createAUIGrid("target_non_rental_grid_wrap", targetNonRenMstColumnLayout,null,gridPros);
    targetSvmMstGridID = GridCommon.createAUIGrid("target_svm_grid_wrap", targetSvmMstColumnLayout,null,gridPros);
    
    // 고정 칼럼을 변경합니다.
    AUIGrid.setFixedColumnCount(myGridID, 7);

    //Cell Edit Event : transferAmtChangeYN 값이 N이면 transfer amount는 수정불가
    AUIGrid.bind(myGridID, "cellEditBegin", function( event ) {
        var transferAmtChangeYN = AUIGrid.getCellValue(myGridID, event.rowIndex, "transferAmtChangeYN"); //invoice charge

        if(transferAmtChangeYN == "N" ){
            return false;
        }

        return true;       
    });

    //Cell Edit Event : transfer amount는 avail amount 금액을 초과할수 없음
    AUIGrid.bind(myGridID, "cellEditEnd", function( event ) {
        
        var availAmt = AUIGrid.getCellValue(myGridID, event.rowIndex, "availAmt"); //invoice charge
        var transferAmt = AUIGrid.getCellValue(myGridID, event.rowIndex, "transferAmt"); //transfer amount

        if(availAmt < transferAmt){
            AUIGrid.setCellValue(myGridID, event.rowIndex, 'transferAmt', availAmt);
        }       
        
        recalculateTransferAmt();
    });
    
    //Rental Billing Grid 에서 체크/체크 해제시    
    AUIGrid.bind(targetRenDetGridID, "cellClick", function( event ){
    	if(event.dataField == "btnCheck"){
    		recalculateRentalTotalAmt();	
    	}
    });
    
    //Membership Service Grid 에서 체크/체크 해제시    
    AUIGrid.bind(targetSvmMstGridID, "cellClick", function( event ){
        if(event.dataField == "btnCheck"){
        	recalculateSvmRentalTotalAmt();    
        }
    });
    
    //Type of Transfer  생성
    doDefCombo(transTypeData, '' ,'tranType', 'S', '');    

    //초기 화면에서 조회된 데이터를 마스터 영역에 표기한다.
    if("${masterInfo.orNo }" != ""){
        $("#orNo").text("${masterInfo.orNo }");        
        $("#lastUpdUserName").text("${masterInfo.lastUpdUserName }");
        $("#keyinUserName").text("${masterInfo.keyinUserName }");
        $("#salesOrdNo").text("${masterInfo.salesOrdNo }");
        $("#appTypeName").text("${masterInfo.appTypeName }");        
        $("#productCtgryName").text("${masterInfo.productCtgryName }");
        $("#productDesc").text("${masterInfo.productDesc }");
        $("#custId").text("${masterInfo.custId }");
        $("#custName").text("${masterInfo.custName }");
        $("#custTypeName").text("${masterInfo.custTypeName }");
        $("#custIc").text("${masterInfo.custIc }");
        $("#payDt").text("${masterInfo.payDt }");
        $("#payTypeName").text("${masterInfo.payTypeName }");
        $("#advMonth").text("${masterInfo.advMonth }");
        $("#trNo").text("${masterInfo.trNo }");
        $("#clctrCode").text("${masterInfo.clctrCode }");
        $("#salesMemName").text("${masterInfo.salesMemCode }" + " (" + "${masterInfo.salesMemName }" +")");
        $("#clctrBrnchName").text("${masterInfo.clctrBrnchCode }" + " (" + "${masterInfo.clctrBrnchName }" +")");
        $("#debtorAccDesc").text("${masterInfo.debtorAccCode }" + " (" + "${masterInfo.debtorAccDesc }" +")");
        $("#hpCode").text("${masterInfo.hpCode }");
        $("#hpName").text("${masterInfo.hpName }");         
        $("#progressStatus").text("${masterInfo.progressStatus }");
    }

    // Fund Transfer Item List  데이터 바인딩
    if('${itemList}' !='' && '${itemList}' != null){
        AUIGrid.setGridData(myGridID, JSON.parse('${itemList}'));

        //테스트용 세팅
        AUIGrid.setCellValue(myGridID,0, "allowTrnsfrId", "1");
        AUIGrid.setCellValue(myGridID,0, "isAllowTrnsfr", "1");        
        AUIGrid.setCellValue(myGridID,1, "allowTrnsfrId", "1");
        AUIGrid.setCellValue(myGridID,1, "isAllowTrnsfr", "1");

        //세팅된 그리드 데이터 재정의
        replaceMasterGrid();
        recalculateTransferAmt();
    }

});

function replaceMasterGrid(){
    var rowCnt = AUIGrid.getRowCount(myGridID);

    if(rowCnt > 0){
        for(var i = 0; i < rowCnt; i++){
            var availAmt = AUIGrid.getCellValue(myGridID, i ,"availAmt");
            var isAllowTrnsfr = AUIGrid.getCellValue(myGridID, i, "isAllowTrnsfr");

            // transfer Amount를 Avail Amount로 세팅
            AUIGrid.setCellValue(myGridID, i, "transferAmt", availAmt);
            AUIGrid.setCellValue(myGridID, i, "btnCheckYN", "N");
            AUIGrid.setCellValue(myGridID, i, "transferAmtChangeYN", "N");         

            if(availAmt > 0){
                if(isAllowTrnsfr == 1){
                    AUIGrid.setCellValue(myGridID, i, "btnCheck", "1");
                    AUIGrid.setCellValue(myGridID, i, "btnCheckYN", "Y");      //btnCheck Enable
                    AUIGrid.setCellValue(myGridID, i, "transferAmtChangeYN", "Y");                     
                }else{                     
                    AUIGrid.setCellValue(myGridID, i, "transferAmt", "0");
                    AUIGrid.setCellValue(myGridID, i, "btnCheckYN", "N");      //btnCheck Not Enable
                    AUIGrid.setCellValue(myGridID, i, "transferAmtChangeYN", "N");
                }                  
            }else{                 
                AUIGrid.setCellValue(myGridID, i, "transferAmt", "0");
                AUIGrid.setCellValue(myGridID, i, "btnCheckYN", "N");      //btnCheck Not Enable
                AUIGrid.setCellValue(myGridID, i, "transferAmtChangeYN", "N");                 
            }
        }
    }
}

function recalculateTransferAmt(){
    var rowCnt = AUIGrid.getRowCount(myGridID);
    var totalAmt = Number(0.00);

    if(rowCnt > 0){
        for(var i = 0; i < rowCnt; i++){
        	totalAmt += Number(AUIGrid.getCellValue(myGridID, i ,"transferAmt"));
        }
    }
    
    $("#totalAmt").text("RM " + totalAmt.toFixed(2));    
}

//Search Order 팝업
function fn_orderSearch(){	
	if(FormUtil.checkReqValue($("#tranType option:selected"))){ 
        Common.alert("<spring:message code='pay.alert.selectTransType'/>");
        return;
    }	
	
	Common.popupDiv("/sales/order/orderSearchPop.do", {callPrgm : "FUND_TRANSFER", indicator : "SearchOrder"});
}

//Search Order 팝업 결과값 받기
function fn_orderInfo(ordNo, ordId){
	
	//Order Basic 정보 조회
    Common.ajax("GET", "/payment/selectOrderBasicInfoByOrderId.do", {"orderId" : ordId}, function(result) {        
        $("#ordId").val(result.ordId);
        $("#ordNo").val(result.ordNo);        
        $("#appTypeId").val(result.appTypeId);
        $("#ordMthRental").val(result.ordMthRental);
        $("#ordStusId").val(result.ordStusId);
        $("#ordAmt").val(result.ordAmt);
        $("#appTypeDesc").text(result.appTypeDesc);
        
        //Order Info 및 Payment Info 조회
        fn_loadTargetOrderInfo(result.ordId);
    });
}

//Search Order 팝업 결과값 받기
function fn_loadTargetOrderInfo(ordId){
	var tranType = $("#tranType").val();
	var appTypeId = $("#appTypeId").val();
	
	if(tranType == 1){
		if(appTypeId == 66){
			//Rental : Order 정보 조회
		    Common.ajax("GET", "/payment/common/selectOrderInfoRental.do", {"orderId" : ordId}, function(result) {
		    	//Rental : Order Info 세팅
		    	AUIGrid.setGridData(targetRenMstGridID, result);
		    	
		    	//Rental : Bill Info 조회
		    	fn_loadTargetBillInfoRental();
		    });			
		}else{			
			//Non-Rental : Order 정보 조회
            Common.ajax("GET", "/payment/common/selectOrderInfoNonRental.do", {"orderId" : ordId}, function(result) {
                //Non-Rental : Order Info 세팅
                AUIGrid.setGridData(targetNonRenMstGridID, result);
            
                //총 금액 계산
                recalculateNonRentalTotalAmt();
            });			
		}		
	}else  if(tranType == 2){
		
		//mEMNon-Rental : Order 정보 조회
        Common.ajax("GET", "/payment/common/selectOrderInfoSVM.do", {"orderId" : ordId}, function(result) {
            //Non-Rental : Order Info 세팅
            AUIGrid.setGridData(targetSvmMstGridID, result);
        
            //총 금액 계산
            recalculateSvmRentalTotalAmt();
        }); 
		
	}else{
		
	}
}

//Rental : Bill Info 조회
function fn_loadTargetBillInfoRental(){
    
	var rowCnt = AUIGrid.getRowCount(targetRenMstGridID);
	
	if(rowCnt > 0){
		 var salesOrdId = AUIGrid.getCellValue(targetRenMstGridID, 0 ,"salesOrdId");
		 var rpf = AUIGrid.getCellValue(targetRenMstGridID, 0, "rpf");
         var rpfPaid = AUIGrid.getCellValue(targetRenMstGridID, 0, "rpfPaid");
         var balance = AUIGrid.getCellValue(targetRenMstGridID, 0, "balance");
         
         var  excludeRPF = (rpf > 0 && rpfPaid >= rpf) ? "N" : "Y";
         if (rpf == 0) excludeRPF = "N";
         
         //Rental : Order 정보 조회
         Common.ajax("GET", "/payment/common/selectBillInfoRental.do", {orderId : salesOrdId, excludeRPF : excludeRPF}, function(result) {
        	 //Rental : Bill Info 세팅
             AUIGrid.setGridData(targetRenDetGridID, result);
         
             recalculateRentalTotalAmt();
             
         });
	}
}

//Rental Amount 계산
function recalculateRentalTotalAmt(){
    var rowCnt = AUIGrid.getRowCount(targetRenDetGridID);
    var totalAmt = Number(0.00);

    if(rowCnt > 0){
        for(var i = 0; i < rowCnt; i++){
            if(AUIGrid.getCellValue(targetRenDetGridID, i ,"btnCheck") == 0){
            	totalAmt += AUIGrid.getCellValue(targetRenDetGridID, i ,"targetAmt");
            }
        }
    }
    
    $("#rentalTotalAmt").text("RM " + totalAmt.toFixed(2));    
}

//Advance Month 변경시 이벤트
function fn_advMonth(){
	
	var advMonth = $("#advMonthType").val();
	
	if(advMonth == 99 ){
		$("#txtAdvMonth").val(1);
		$('#txtAdvMonth').removeClass("readonly");
		$("#txtAdvMonth").prop("readonly",false);
	}else{
		$("#txtAdvMonth").val(advMonth);
		$('#txtAdvMonth').addClass("readonly");
		$("#txtAdvMonth").prop("readonly",true);
	}
}

//Non-Rental Amount 계산
function recalculateNonRentalTotalAmt(){
    var rowCnt = AUIGrid.getRowCount(targetNonRenMstGridID);
    var totalAmt = Number(0.00);

    if(rowCnt > 0){
        for(var i = 0; i < rowCnt; i++){
        	totalAmt += AUIGrid.getCellValue(targetNonRenMstGridID, i ,"balance");
        }
    }
    
    $("#nonRentalTotalAmt").text("RM " + totalAmt.toFixed(2));    
}

//SVM Amount 계산
function recalculateSvmRentalTotalAmt(){
    var rowCnt = AUIGrid.getRowCount(targetSvmMstGridID);
    var totalAmt = Number(0.00);

    if(rowCnt > 0){
        for(var i = 0; i < rowCnt; i++){
            if(AUIGrid.getCellValue(targetSvmMstGridID, i ,"btnCheck") == 0){
                totalAmt += AUIGrid.getCellValue(targetSvmMstGridID, i ,"totOtstnd");
            }
        }
    }
    
    $("#svmTotalAmt").text("RM " + totalAmt.toFixed(2));    
}

</script>
<section id="content"><!-- content start -->
    <ul class="path">
        <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    </ul>

    <aside class="title_line"><!-- title_line start -->
        <p class="fav"><a href="#" class="click_add_on"><spring:message code='pay.text.myMenu'/></a></p>
        <h2>Fund Transfer</h2>
    </aside><!-- title_line end -->
    
    <section class="tap_wrap"><!-- tap_wrap start -->
        <ul class="tap_type1">
            <li><a href="#" class="on">Fund Transfer Item</a></li>
            <li><a href="#">Target Item</a></li>
            <li class="right_opt"><p class="rm">Total Transfer : <span id="totalAmt"></span></p></li>
        </ul>

        <article class="tap_area"><!-- tap_area start -->

            <aside class="title_line"><!-- title_line start -->
                <h3 class="pt0">Payment Information</h3>
            </aside><!-- title_line end -->

            <table class="type1"><!-- table start -->
                <caption>table</caption>
                    <colgroup>
                        <col style="width:170px" />
                        <col style="width:*" />
                        <col style="width:150px" />
                        <col style="width:*" />
                        <col style="width:170px" />
                        <col style="width:*" />
                    </colgroup>
                    <tbody>
                        <tr>
                            <th scope="row">OR(Official Receipt) No</th>
                            <td>
                                <span id="orNo" class="red_text"></span>
                            </td>
                            <th scope="row">Last Updated By</th>
                            <td>
                                <span id="lastUpdUserName" class="red_text"></span>
                            </td>
                            <th scope="row">Payment Key By</th>
                            <td>
                                <span id="keyinUserName" class="red_text"></span>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row">Order No.</th>
                            <td>
                                <span id="salesOrdNo" class="red_text"></span>
                            </td>
                            <th scope="row">TR Ref. No.</th>
                            <td>
                                <span id="trNo" ></span>
                            </td>
                            <th scope="row">Application Type</th>
                            <td>
                                <span id="appTypeName" ></span>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row">Product Category</th>
                            <td>
                                <span id="productCtgryName" ></span>
                            </td>
                            <th scope="row">Product Name</th>
                            <td>
                                <span id="productDesc" ></span>
                            </td>
                            <th scope="row">Customer ID</th>
                            <td>
                                <span id="custId" ></span>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row">Customer Name</th>
                            <td>
                                <span id="custName" ></span>
                            </td>
                            <th scope="row">Customer Type</th>
                            <td>
                                <span id="custTypeName" ></span>
                            </td>
                            <th scope="row">Cust. NRIC/Company No.</th>
                            <td>
                                <span id="custIc" ></span>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row">Order Install Status</th>
                            <td>
                                <span id="progressStatus"></span>
                            </td>
                            <th scope="row">Install No.</th>
                            <td>
                                <span></span>
                            </td>
                            <th scope="row">Payment Date</th>
                            <td>
                                <span id="payDt" ></span>
                            </td>
                        </tr>
                         <tr>
                            <th scope="row">Payment Type</th>
                            <td>
                                <span id="payTypeName" ></span>
                            </td>
                            <th scope="row">Advance Month</th>
                            <td colspan="3">
                                <span id="advMonth" ></span>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row">HP Code</th>
                            <td>
                                <span id="hpCode" ></span>
                            </td>
                            <th scope="row">HP Name</th>
                            <td colspan="3">
                                <span id="hpName" ></span>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row">Payment Collector Code</th>
                            <td>
                                <span id="clctrCode"></span>
                            </td>
                            <th scope="row">HP Code/Dealer</th>
                            <td>
                                <span id="salesMemName"></span>
                            </td>
                            <th scope="row">Branch Code</th>
                            <td>
                                <span id="clctrBrnchName"></span>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row">Debtor Account</th>
                            <td colspan="5">
                                <span id="debtorAccDesc"></span>
                            </td>
                        </tr>
                    </tbody>
                </table><!-- table end -->

                <aside class="title_line"><!-- title_line start -->
                    <h3>Fund Transfer Item Information</h3>
                </aside><!-- title_line end -->
                
                <!-- grid_wrap start -->
                <article class="grid_wrap">
                    <div id="grid_wrap" style="width: 100%; height: 250px; margin: 0 auto;"></div>
                </article>
                <!-- grid_wrap end -->

                <!-- grid_wrap end -->

                <table class="type1"><!-- table start -->
                    <caption>table</caption>
                    <colgroup>
                        <col style="width:170px" />
                        <col style="width:*" />
                    </colgroup>
                    <tbody>
                        <tr>
                            <th scope="row">Remark</th>
                            <td>
                                <textarea cols="20" rows="5" placeholder=""></textarea>
                            </td>
                        </tr>
                    </tbody>
                </table><!-- table end -->

                <ul class="center_btns">
                    <li><p class="btn_blue2 big"><a href="#">Next</a></p></li>
                </ul>

            </article><!-- tap_area end -->

            <article class="tap_area"><!-- tap_area start -->

                <aside class="title_line"><!-- title_line start -->
                    <h3 class="pt0">Target Item Information</h3>
                </aside><!-- title_line end -->
                
                <form name="transForm" id="transForm"  method="post">
                    <input type="hidden" name="ordId" id="ordId" />                    
                    <input type="hidden" name="appTypeId" id="appTypeId" />
                    <input type="hidden" name="ordMthRental" id="ordMthRental" />
                    <input type="hidden" name="ordStusId" id="ordStusId" />
                    <input type="hidden" name="ordAmt" id="ordAmt" />

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
	                            <th scope="row">Type of Transfer</th>
	                            <td>
	                                <select id="tranType" name="tranType" class="w100p" ></select>
	                            </td>
	                            <th scope="row">Order Number</th>
	                            <td>
	                                <div class="search_100p"><!-- search_100p start -->
	                                <input type="text" id="ordNo" name="ordNo" title="Order No" placeholder="" class="readonly w100p" readonly/>
	                                <a href="javascript:fn_orderSearch();" class="search_btn">
	                                    <img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" />
	                                </a> 
	                                </div><!-- search_100p end -->
	                            </td>
	                            <th scope="row"> Application Type </th>
	                            <td id="appTypeDesc"></td>
	                        </tr>
	                    </tbody>
	                </table><!-- table end -->
                </form>	   
                
                <!-- 
                ***************************************************************************************
                ***************************************************************************************
                *************                                           Rental Area                                                                    ****
                ***************************************************************************************
                ***************************************************************************************
                -->
                <!-- Transfer Area start -->
                <div class="mt10">
                    <!-- title_line start -->
                    <aside class="title_line">
                        <h3 class="pt0">Transfer To Order Payment</h3>
                    </aside>
                    <!-- title_line end -->
                    
                    <!-- table start -->
                    <table class="type1">
                        <caption>table</caption>
                            <colgroup>
                                <col style="width:150px" />
                                <col style="width:200px" />
                                <col style="width:*" />
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th scope="row">Advance Specification</th>
                                    <td>
                                        <select id="advMonthType" name="advMonthType" onchange="fn_advMonth();">
                                            <option value="0" selected="selected">Advance Selection</option>
                                            <option value="99">Specific Advance</option>
                                            <option value="12">1 Year</option>
                                            <option value="24">2 Years</option>
                                        </select>
                                    </td>
                                    <td>
                                        <input type="text" id="txtAdvMonth" name="txtAdvMonth" title="Advance Month" size="2" value="" class="readonly" readonly />
                                    </td>
                                </tr>
                            </tbody>
                    </table>
                    <!-- table end -->
                    
                    <!-- grid_wrap start -->
                    <article class="grid_wrap">
                        <div id="target_rental_grid_wrap" style="width: 100%; height: 150px; margin: 0 auto;"></div>
                    </article>
                    <!-- grid_wrap end -->
                    
                    <!-- grid_wrap start -->
                    <article class="grid_wrap mt10">
                        <div id="target_rentalD_grid_wrap" style="width: 100%; height: 250px; margin: 0 auto;"></div>
                    </article>
                    <!-- grid_wrap end -->
                    
                    <ul class="right_btns">
                        <li><p class="amountTotalSttl">Amount Total :</p></li>                        
                        <li><strong id="rentalTotalAmt">RM 0.00</strong></li>
                    </ul>
                </div>
                <!-- Transfer Area end -->  
                
                <!-- 
                ***************************************************************************************
                ***************************************************************************************
                *************                                           Non - Rental Area                                                            ****
                ***************************************************************************************
                ***************************************************************************************
                -->
                <!-- Transfer Area start -->
                <div class="mt10">
                    <!-- title_line start -->
                    <aside class="title_line">
                        <h3 class="pt0">Transfer To Order Payment</h3>
                    </aside>
                    <!-- title_line end -->
                    <!-- grid_wrap start -->
                    <article class="grid_wrap">
                        <div id="target_non_rental_grid_wrap" style="width: 100%; height: 150px; margin: 0 auto;"></div>
                    </article>
                    <!-- grid_wrap end -->
                    
                    <ul class="right_btns">
                        <li><p class="amountTotalSttl">Amount Total :</p></li>                        
                        <li><strong id="nonRentalTotalAmt">RM 0.00</strong></li>
                    </ul>
                </div>
                <!-- Transfer Area end -->  
                
                <!-- 
                ***************************************************************************************
                ***************************************************************************************
                *************                                           Membership Service                                                         ****
                ***************************************************************************************
                ***************************************************************************************
                -->
                <!-- Transfer Area start -->
                <div class="mt10">
                    <!-- title_line start -->
                    <aside class="title_line">
                        <h3 class="pt0">Transfer To Membership Payment</h3>
                    </aside>
                    <!-- title_line end -->
                    <!-- grid_wrap start -->
                    <article class="grid_wrap">
                        <div id="target_svm_grid_wrap" style="width: 100%; height: 150px; margin: 0 auto;"></div>
                    </article>
                    <!-- grid_wrap end -->
                    
                    <ul class="right_btns">
                        <li><p class="amountTotalSttl">Amount Total :</p></li>                        
                        <li><strong id="svmTotalAmt">RM 0.00</strong></li>
                    </ul>
                </div>
                <!-- Transfer Area end --> 
                
                <ul class="center_btns">
                    <li><p class="btn_blue2 big"><a href="#">Bach</a></p></li>
                    <li><p class="btn_blue2 big"><a href="#">Save</a></p></li>
                </ul>
            </article><!-- tap_area end -->
        </section><!-- tap_wrap end -->
    </section><!-- content end --> 
