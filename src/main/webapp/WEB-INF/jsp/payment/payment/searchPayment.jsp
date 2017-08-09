<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
    
<script type="text/javaScript">

//AUIGrid 그리드 객체
var myGridID,subGridID;
var viewHistoryGridID;

//Grid에서 선택된 RowID
var selectedGridValue;

var gridPros_popList = {            
        editable : false,                 // 편집 가능 여부 (기본값 : false)
        showStateColumn : false     // 상태 칼럼 사용
};

//Grid Properties 설정 
var gridPros = {            
        editable : false,                 // 편집 가능 여부 (기본값 : false)
        showStateColumn : false     // 상태 칼럼 사용
};

// 화면 초기화 함수 (jQuery 의 $(document).ready(function() {}); 과 같은 역할을 합니다.
$(document).ready(function(){
	
	//Issue Bank 조회
    doGetCombo('/common/getAccountList.do', 'CASH' , ''   , 'bankAccount' , 'S', '');
	
	//Application Type 생성
    doGetCombo('/common/selectCodeList.do', '10' , ''   , 'applicationType' , 'S', '');
	
	//Payment Type 코드 조회
    doGetCombo('/common/selectCodeList.do', '48' , ''   ,'paymentType', 'S' , '');  
  
	//Branch Combo 생성
	doGetComboSepa('/common/selectBranchCodeList.do', '1' , ' - ' , '','branchId', 'S' , '');
	
	//EDIT POP Branch Combo 생성
    doGetComboSepa('/common/selectBranchCodeList.do', '1' , ' - ' , '','edit_branchId', 'S' , '');
    
	//CreditCardType 생성
    doGetCombo('/common/selectCodeList.do', '21' , ''   ,'cmbCreditCardTypeCC', 'S' , '');
	
    //IssuedBank 생성
    doGetCombo('/common/getIssuedBankList.do', '' , ''   , 'sIssuedBankCh' , 'S', '');
    doGetCombo('/common/getIssuedBankList.do', '' , ''   , 'cmbIssuedBankCC' , 'S', '');
    doGetCombo('/common/getIssuedBankList.do', '' , ''   , 'cmbIssuedBankOn' , 'S', '');
	
    //Branch Combo 변경시 User Combo 생성
    $('#branchId').change(function (){
    	doGetCombo('/common/getUsersByBranch.do', $(this).val() , ''   , 'userId' , 'S', '');
    });

    // Order 정보 (Master Grid) 그리드 생성
    myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout,null,gridPros);
    
    
    // Master Grid 셀 클릭시 이벤트
    AUIGrid.bind(myGridID, "cellClick", function( event ){ 
    	selectedGridValue = event.rowIndex;
    	AUIGrid.destroy(subGridID); 
    	// Payment (Slave Grid) 그리드 생성
        subGridID = GridCommon.createAUIGrid("grid_sub_wrap", slaveColumnLayout,null,gridPros);
    	
    	$("#payId").val(AUIGrid.getCellValue(myGridID , event.rowIndex , "payId"));
    	$("#salesOrdId").val(AUIGrid.getCellValue(myGridID , event.rowIndex , "salesOrdId"));
    	
    	fn_getPaymentListAjax();

    });
});

// AUIGrid 칼럼 설정
var columnLayout = [ 
    { dataField:"trxId" ,headerText:"TrxNo",editable : false },
	{ dataField:"trxDt" ,headerText:"TrxDate",editable : false , dataType : "date", formatString : "dd-mm-yyyy"},
	{ dataField:"trxAmt" ,headerText:"TrxTotal" ,editable : false , dataType : "numeric", formatString : "#,##0.#"},
	{ dataField:"payId" ,headerText:"PID" ,editable : false },
	{ dataField:"orNo" ,headerText:"ORNo" ,editable : false },
	{ dataField:"payTypeName" ,headerText:"PayType" ,editable : false },
	{ dataField:"AdvMonth" ,headerText:"AdvMonth" ,editable : false },
	{ dataField:"trNo" ,headerText:"TRNo" ,editable : false },
	{ dataField:"orAmt" ,headerText:"ORTotal" ,editable : false , dataType : "numeric", formatString : "#,##0.#"},
	{ dataField:"salesOrdNo" ,headerText:"OrderNo" ,editable : false },
	{ dataField:"appTypeName" ,headerText:"AppType" ,editable : false },
	{ dataField:"productDesc" ,headerText:"Product" ,editable : false },
	{ dataField:"custName" ,headerText:"Customer" ,editable : false },
	{ dataField:"custIc" ,headerText:"IC/CO No." ,editable : false },
	{ dataField:"virtlAccNo" ,headerText:"VANo" ,editable : false },
	{ dataField:"clctrBrnchName" ,headerText:"Branch" ,editable : false },
	{ dataField:"keyinUserName" ,headerText:"UserName" ,editable : false },
	{ dataField:"salesOrdId" ,headerText:"SalesOrdId" ,editable : false, visible : true}
    ];

var slaveColumnLayout = [ 
	{ dataField:"payId" ,headerText:"PayID",editable : false ,visible : false },
	{ dataField:"payItmId" ,headerText:"ItemId",editable : false ,visible : false },
	{ dataField:"codeName" ,headerText:"Mode",editable : false },
	{ dataField:"payItmRefNo" ,headerText:"RefNo",editable : false },
	{ dataField:"c7" ,headerText:"CardType" ,editable : false },
	{ dataField:"codeName1" ,headerText:"CCType" ,editable : false },
	{ dataField:"payItmCcHolderName" ,headerText:"CCHolder" ,editable : false },
	{ dataField:"payItmCcExprDt" ,headerText:"CCExpiryDate" ,editable : false , dataType : "date", formatString : "dd-mm-yyyy"},
	{ dataField:"payItmChqNo" ,headerText:"ChequeNo" ,editable : false },
	{ dataField:"name" ,headerText:"IssueBank" ,editable : false },
	{ dataField:"payItmAmt" ,headerText:"Amount" ,editable : false , dataType : "numeric", formatString : "#,##0.#"},                   
	{ dataField:"c8" ,headerText:"CRCMode" ,editable : false },
	{ dataField:"accDesc" ,headerText:"Bank Account" ,editable : false },
	{ dataField:"c3" ,headerText:"Account Code" ,editable : false },
	{ dataField:"payItmRefDt" ,headerText:"RefDate" ,editable : false , dataType : "date", formatString : "dd-mm-yyyy"},
	{ dataField:"payItmAppvNo" ,headerText:"ApprNo." ,editable : false },
	{ dataField:"c4" ,headerText:"EFT" ,editable : false },
	{ dataField:"c5" ,headerText:"Running No" ,editable : false },
	{ dataField:"payItmRem" ,headerText:"Remark" ,editable : false },
	{ dataField:"payItmBankChrgAmt" ,headerText:"BankCharge" ,editable : false , dataType : "numeric", formatString : "#,##0.#"}
    ];
              
var popColumnLayout = [ 
    { dataField:"history" ,
    	headerText:" ", 
    	//headerTooltip :{ show : true, tooltipHtml : "View History" },
    	renderer : {
            type : "IconRenderer",
            iconTableRef :  { // icon 값 참조할 테이블 레퍼런스
                "default" : "./assets/office_man.png"// default
            },
            iconWidth : 20, // icon 가로 사이즈, 지정하지 않으면 24로 기본값 적용됨
            iconHeight : 20,
            //altField : "View History",
            onclick : function(rowIndex, columnIndex, value, item) {
                alert("( " + rowIndex + ", " + columnIndex + " ) " + item.payItmId + "  클릭, " + value);
                showDetailHistory(item.payItmId);
            }
    	}
    },
    { dataField:"payId" ,headerText:"TEST",editable : false  },
    { dataField:"codeName" ,headerText:"Mode",editable : false},
    { dataField:"payItmRefNo" ,headerText:"RefNo",editable : false },
    { dataField:"c7" ,headerText:"CardType",editable : false },
    { dataField:"codeName1" ,headerText:"CCType" ,editable : false },
    { dataField:"codeName1" ,headerText:"CCType" ,editable : false },
    { dataField:"payItmCcHolderName" ,headerText:"CCHolder" ,editable : false },
    { dataField:"payItmCcExprDt" ,headerText:"CCExpiryDate" ,editable : false , dataType : "date", formatString : "dd-mm-yyyy"},
    { dataField:"" ,headerText:"CRCNo" ,editable : false },
    { dataField:"payItmChqNo" ,headerText:"ChequeNo" ,editable : false },
    { dataField:"name" ,headerText:"IssueBank" ,editable : false },                   
    { dataField:"payItmAmt" ,headerText:"Amount" ,editable : false },
    { dataField:"c8" ,headerText:"CRCMode" ,editable : false },
    { dataField:"accDesc" ,headerText:"BankAccount" ,editable : false },
    { dataField:"payItmRefDt" ,headerText:"RefDate" ,editable : false , dataType : "date", formatString : "dd-mm-yyyy"},
    { dataField:"payItmAppvNo" ,headerText:"ApprNo." ,editable : false },
    { dataField:"payItmRem" ,headerText:"Remark" ,editable : false },
    { dataField:"c4" ,headerText:"EFT" ,editable : false },
    { dataField:"payItmRem" ,headerText:"Running No" ,editable : false },
    { dataField:"payItmBankChrgAmt" ,headerText:"BankCharge" ,editable : false },
    { dataField:"payItmId" ,headerText:"payItemId" ,editable : false, visible:false }
    ];

var popSlaveColumnLayout = [ 
    { dataField:"trxId" ,headerText:"TrxNo",editable : false},
    { dataField:"trxDt" ,headerText:"TrxDate",editable : false  },
    { dataField:"trxAmt" ,headerText:"TrxTotal",editable : false },
    { dataField:"payId" ,headerText:"PID",editable : false },
    { dataField:"orNo" ,headerText:"ORNo" ,editable : false },
    { dataField:"trNo" ,headerText:"TRNo" ,editable : false },
    { dataField:"orAmt" ,headerText:"ORTotal" ,editable : false },
    { dataField:"salesOrdNo" ,headerText:"OrderNo" ,editable : false },
    { dataField:"appTypeName" ,headerText:"AppType" ,editable : false },
    { dataField:"productDesc" ,headerText:"Product" ,editable : false },
    { dataField:"custName" ,headerText:"Customer" ,editable : false },                   
    { dataField:"custIc" ,headerText:"IC/CO No." ,editable : false },
    { dataField:"keyinBrnchName" ,headerText:"Branch" ,editable : false },
    { dataField:"keyinUserName" ,headerText:"UserName" ,editable : false },
    ];

var viewHistoryLayout=[
    { dataField:"typename" ,headerText:"Type" ,editable : false },
    { dataField:"valuefr" ,headerText:"From" ,editable : false },
    { dataField:"valueto" ,headerText:"To" ,editable : false },
    { dataField:"createdate" ,headerText:"Update Date" ,editable : false, formatString : "dd-mm-yyyy" },
    { dataField:"creator" ,headerText:"Updator" ,editable : false }
    ];



// 리스트 조회.
function fn_getOrderListAjax() {
	AUIGrid.destroy(subGridID);//subGrid 초기화
    Common.ajax("GET", "/payment/selectOrderList", $("#searchForm").serialize(), function(result) {
        AUIGrid.setGridData(myGridID, result);
    });
}

//리스트 조회.
function fn_getPaymentListAjax() {        
    Common.ajax("GET", "/payment/selectPaymentList", $("#detailForm").serialize(), function(result) {
        AUIGrid.setGridData(subGridID, result);
    });
}



function fn_openDivPop(val){
	
	if(val == "VIEW"){
		if(selectedGridValue !=  undefined){
	        $("#popup_wrap").show();
	        popGridID = GridCommon.createAUIGrid("popList_wrap", popColumnLayout, null, gridPros_popList);
	        popSlaveGridID = GridCommon.createAUIGrid("popSlaveList_wrap", popSlaveColumnLayout, null, gridPros_popList);
	        
	        Common.ajax("GET", "/payment/selectPaymentDetailViewer.do", $("#detailForm").serialize(), function(result) {
	            console.log(result);
	            
	            //Payment Information
	            $('#txtORNo').text(result.viewMaster.orNo);$("#txtORNo").css("color","red");
	            $('#txtLastUpdator').text(result.viewMaster.lastUpdUserName);$("#txtLastUpdator").css("color","red");
	            $('#txtKeyInUser').text(result.viewMaster.keyinUserName);$("#txtKeyInUser").css("color","red");
	            $('#txtOrderNo').text(result.viewMaster.salesOrdNo);$("#txtOrderNo").css("color","red");
	            $('#txtTRRefNo').text(result.viewMaster.trNo);
	            $('#txtTRIssueDate').text(result.viewMaster.trIssuDt);
	            $('#txtProductCategory').text(result.viewMaster.productCtgryName);
	            $('#txtProductName').text(result.viewMaster.productDesc);
	            $('#txtAppType').text(result.viewMaster.appTypeName);
	            $('#txtCustomerName').text(result.viewMaster.custName);
	            $('#txtCustomerType').text(result.viewMaster.custTypeName);
	            $('#txtCustomerID').text(result.viewMaster.custId);
	            if(result.orderProgressStatus.name != null){
	            	$('#txtOrderProgressStatus').text(result.orderProgressStatus.name);
	            }else{
	            	$('#txtOrderProgressStatus').text("");
	            }
	            
	            $('#txtInstallNo').text('');
	            $('#txtNRIC').text(result.viewMaster.custIc);
	            $('#txtPayType').text(result.viewMaster.payTypeName);
	            $('#txtAdvMth').text(result.viewMaster.advMonth);
	            $('#txtPayDate').text(result.viewMaster.payDt);
	            $('#txtHPCode').text(result.viewMaster.hpCode);
	            $('#txtHPName').text(result.viewMaster.hpName);
	            $('#txtBatchPaymentID').text(result.viewMaster.batchPayId);
	             
	            //Collector Information
	            $('#txtCollectorCode').text(result.viewMaster.clctrCode);
	            $('#txtSalesPerson').text(result.viewMaster.salesMemCode + "(" + result.viewMaster.salesMemName+")");
	            $('#txtBranch').text(result.viewMaster.clctrBrnchCode + "(" + result.viewMaster.clctrBrnchName+")");
	            $('#txtDebtor').text(result.viewMaster.debtorAccCode + "(" + result.viewMaster.debtorAccDesc+")");
	             
	            
	            $("#gridTitle").css("color","red");
	            //팝업그리드 뿌리기
	            AUIGrid.setGridData(popGridID, result.selectPaymentDetailView);
	            AUIGrid.setGridData(popSlaveGridID, result.selectPaymentDetailSlaveList);
	            
	        },function(jqXHR, textStatus, errorThrown) {
	            Common.alert("실패하였습니다.");

	        });
	        
	   }else{
	       $("#popup_wrap").hide();
	       Common.alert("search records first");
	       return;
	   }
		
	}else if(val == "EDIT"){
		if(selectedGridValue !=  undefined){
            $("#popup_wrap2").show();
            editPopGridID = GridCommon.createAUIGrid("editPopList_wrap", popColumnLayout, null, gridPros_popList);
            
            Common.ajax("GET", "/payment/selectPaymentDetailViewer.do", $("#detailForm").serialize(), function(result) {
                console.log(result);
                
                //Payment Information
                $('#edit_txtORNo').text(result.viewMaster.orNo);$("#edit_txtORNo").css("color","red");
                $('#edit_txtLastUpdator').text(result.viewMaster.lastUpdUserName);$("#edit_txtLastUpdator").css("color","red");
                $('#edit_txtKeyInUser').text(result.viewMaster.keyinUserName);$("#edit_txtKeyInUser").css("color","red");
                $('#edit_txtOrderNo').text(result.viewMaster.salesOrdNo);$("#edit_txtOrderNo").css("color","red");
                $('#edit_txtTRRefNo').val(result.viewMaster.trNo);$("#edit_txtTRRefNo").css("backgroundColor","#F5F6CE");
                
                $("#edit_txtTRIssueDate").css("backgroundColor","#F5F6CE");
                var refDate = new Date(result.viewMaster.trIssuDt);
                var defaultDate = new Date("01/01/1900");
                if((refDate.getTime() > defaultDate.getTime())){
                    $("#edit_txtTRIssueDate").val(result.viewMaster.trIssuDt);
                }
                
                $('#edit_txtProductCategory').text(result.viewMaster.productCtgryName);
                $('#edit_txtProductName').text(result.viewMaster.productDesc);
                $('#edit_txtAppType').text(result.viewMaster.appTypeName);
                $('#edit_txtCustomerName').text(result.viewMaster.custName);
                $('#edit_txtCustomerType').text(result.viewMaster.custTypeName);
                $('#edit_txtCustomerID').text(result.viewMaster.custId);
                $('#edit_txtOrderProgressStatus').text(result.orderProgressStatus.name);
                $('#edit_txtInstallNo').text('');
                $('#edit_txtNRIC').text(result.viewMaster.custIc);
                $('#edit_txtPayType').text(result.viewMaster.payTypeName);
                $('#edit_txtAdvMth').text(result.viewMaster.advMonth);
                $('#edit_txtPayDate').text(result.viewMaster.payDt);
                $('#edit_txtHPCode').text(result.viewMaster.hpId);
                $('#edit_txtHPName').text(result.viewMaster.orNo);
                $('#edit_txtBatchPaymentID').text(result.viewMaster.batchPayId);
                 
                //Collector Information
                $('#edit_txtSalesPerson').text(result.viewMaster.salesMemCode + "(" + result.viewMaster.salesMemName+")");
                $('#edit_txtBranch').text(result.viewMaster.clctrBrnchCode + "(" + result.viewMaster.clctrBrnchName+")");
                $('#edit_txtDebtor').text(result.viewMaster.debtorAccCode + "(" + result.viewMaster.debtorAccDesc+")");
                
                $('#edit_branchId').val(result.viewMaster.clctrBrnchId);$("#edit_branchId").css("backgroundColor","#F5F6CE");
                $('#edit_txtCollectorCode').val(result.viewMaster.clctrCode);
                $('#edit_txtClctrName').text(result.viewMaster.clctrName);
                
                
                
                if(result.viewMaster.allowComm != "1"){
                	$("#btnAllowComm").attr('checked', false);
                }else{
                	$("#btnAllowComm").attr('checked', true);
                }
                
                if(result.passReconSize  > 0 ){
                	$("#edit_branchId").attr('disabled', true);
                }else{
                	$("#edit_branchId").attr('disabled', false);
                }
                 
                //팝업그리드 뿌리기
                AUIGrid.setGridData(editPopGridID, result.selectPaymentDetailView);
            },function(jqXHR, textStatus, errorThrown) {
                Common.alert("실패하였습니다.");

            });
            
       }else{
           $("#popup_wrap2").hide();
           Common.alert("search records first");
           return;
       }
    }
	
}

function fn_close() {
    $('#popup_wrap').hide();
    AUIGrid.destroy(popGridID); 
    AUIGrid.destroy(popSlaveGridID); 
}

function fn_close2() {
    $('#popup_wrap2').hide();
    AUIGrid.destroy(editPopGridID); 
}

function showViewHistory(){
	$("#view_history_wrap").show();
	viewHistoryGridID = GridCommon.createAUIGrid("grid_view_history", viewHistoryLayout,null,gridPros);
	 Common.ajax("GET", "/payment/selectViewHistoryList", $("#detailForm").serialize(), function(result) {
	        AUIGrid.setGridData(viewHistoryGridID, result);
	 });
}

function showDetailHistory(payItemId){
	$("#view_detail_wrap").show();
	viewHistoryGridID = GridCommon.createAUIGrid("grid_detail_history", viewHistoryLayout,null,gridPros);
	Common.ajax("GET", "/payment/selectDetailHistoryList", {"payItemId" : payItemId} , function(result) {
       AUIGrid.setGridData(viewHistoryGridID, result);
    });
}

function showItemEdit(payItemId){
	
	//var payId = 166; var payItemId = 170; //cash
	var payId = 2273; var payItemId = 2222; // online
	//var payId = 3877; var payItemId = 3853; //credit card
    //var payId = 21; var payItemId = 22; //cheque
	
	var defaultDate = new Date("01-01-1900");    
	 Common.ajax("GET", "/payment/selectPaymentItem", {"payItemId" : payItemId}, function(result) {
		 var payMode = result[0].payItmModeId;
		 if(payMode == 105){ //cash
			 $("#item_edit_cash").show();
			 $("#payItemId").val(payItemId);
			 $("#payId").val(payId);
			 $("#paymentCa").text(result[0].codeName);
	         $("#amountCa").text(result[0].payItmAmt);
	         $("#bankAccCa").text(result[0].accId + result[0].accDesc);
		 }else if(payMode == 106){//cheque
			 $("#item_edit_cheque").show();
			 $("#payItemIdCh").val(payItemId);
             $("#payIdCh").val(payId);
			 $("#paymentCh").text(result[0].codeName);
			 $("#amountCh").text(result[0].payItmAmt);
			 $("#bankAccCh").text(result[0].accId + result[0].accDesc);
			 $("#sIssuedBankCh").val(result[0].payItmIssuBankId);
			 $("#chequeNumberCh").text(result[0].payItmChqNo);
			 $("#chequeNo").val(result[0].payItmChqNo);
			 $("#txtRefNumberCh").val(result[0].payItmRefNo);
			 var refDate = new Date(result[0].payItmRefDt);
			 if((refDate.getTime() > defaultDate.getTime()))
			{    
				 console.log("refDate > defaultDate : " + (refDate.getTime() > defaultDate.getTime()));
				 $("#txtRefDateCh").val(refDate.getDate() + "/" + (refDate.getMonth()+1) + "/" + refDate.getFullYear());
			}
			 $("#txtRunNoCh").val(result[0].payItmRunngNo);
			 $("#tareaRemarkCh").val(result[0].payItmRem);
		}else if(payMode == 107){//creditcard
			  $("#payItemIdCC").val(payItemId);
			  $("#payIdCC").val(payId);
			  $("#item_edit_credit").show();
			  $("#paymentCC").text(result[0].codeName);
			  $("#amountCC").text(result[0].payItmAmt);
	          $("#bankAccCC").text(result[0].accId + result[0].accDesc);
	          $("#cmbIssuedBankCC").val(result[0].payItmIssuBankId);
	          $("#CCNo").text(result[0].payItmOriCcNo);
	          $("#txtCrcNo").val(result[0].payItmOriCcNo);
	          console.log("txtCrcNo : " + $("#txtCrcNo").val());
	          $("#txtCCHolderName").val(result[0].payItmCcHolderName);
	          var exDt =  result[0].payItmCcExprDt;
	          //exDt = '03/15';
	          var exMonth = 0;
	          var exYear = 0;
	          var exDate = new Date();
	          if(exDt != undefined){
	        	  var expiryDate = exDt.split('/');
	        	  console.log("expiryDate : " + expiryDate); 
	        	  exMonth = expiryDate[0];
	        	  exYear = expiryDate[1];
	        	  
	        	  if(exYear >= 90){
	        		  exYear = 1900 + Number(exYear);
	        	  }else{
	        		  exYear = 2000 + Number(exYear);
	        	  }
	        	  
	        	  exDate.setFullYear(exYear);
	        	  exDate.setMonth(exMonth);
	        	  exDate.setDate("01");
	        	  
	        	  var exMonthStr = exDate.getMonth() < 10 ? "0" + exDate.getMonth() : exDate.getMonth();
	          
	        	  console.log("exDate : " + exDate + ", exDate > defaultDate" + (exDate > defaultDate)); 
	              
	              if((exDate > defaultDate))
	                  $("#txtCCExpiry").val("01" + "/" + (exMonthStr) + "/" + exDate.getFullYear());
	              else
	                  $("#txtCCExpiry").val();
	          }
	          
	          if(result[0].payItmCardTypeId > 0)
	        	  $("#cmbCardTypeCC").val(result[0].payItmCardTypeId).prop("selected", true);
	          console.log("cmbCreditCardTypeCC : " + result[0].payItmCcTypeId + ", " + $("#cmbCreditCardTypeCC").val());
	          $("#cmbCreditCardTypeCC").val(result[0].payItmCcTypeId).prop("selected", true);
	          if(result[0].isOnline == 'On')
	        	  $("#creditCardModeCC").text('Online');
	          else
	        	  $("#creditCardModeCC").text('Offline');
	          $("#approvalNumberCC").text(result[0].payItmAppvNo);
	          $("#txtRefNoCC").val(result[0].payItmRefNo);
	          var refDt = new Date(result[0].payItmRefDt);
	          if(refDt > defaultDate){
	        	  var tmpMonth = refDt.getMonth() < 10 ? "0" + (refDt.getMonth()+1) : (refDt.getMonth() + 1);
	        	  var tmpDate = refDt.getDate() < 10 ? "0" + (refDt.getDate()+1) : (refDt.getDate() + 1);
	        	  $("#txtRefDateCC").val(refDt.getDate() + "/" + tmpMonth + "/" + refDt.getFullYear());
	          }
	          $("#tareaRemarkCC").val(result[0].payItmRem);
		 }else if(payMode == 108){//online
			 $("#item_edit_online").show();
			 $("#payItemIdOn").val(payItemId);
             $("#payIdOn").val(payId);
			 $("#paymentOn").text(result[0].codeName);
             $("#amountOn").text(result[0].payItmAmt);
             $("#bankAccOn").text(result[0].accId + result[0].accDesc);
             $("#cmbIssuedBankOn").val(result[0].payItmIssuBankId);
             $("#txtRefNoOn").val(result[0].payItmRefNo);
             var refDate = new Date(result[0].payItmRefDt);
             if((refDate.getTime() > defaultDate.getTime()))
            {
                 console.log("refDate > defaultDate : " + (refDate.getTime() > defaultDate.getTime()));
                 $("#txtRefDateOn").val(refDate.getDate() + "/" + (refDate.getMonth()+1) + "/" + refDate.getFullYear());
            }
             $("#txtEFTNoOn").val(result[0].payItmEftNo);
             $("#txtRunNoOn").val(result[0].payItmRunngNo);
             $("#tareaRemarkOn").val(result[0].payItmRem);
		 }
	 });
}

function hideViewPopup(){
	$("#view_history_wrap").hide();
	AUIGrid.destroy("#grid_view_history");
	
}

function hideDetailPopup(){
	$("#view_detail_wrap").hide();
    AUIGrid.destroy("#grid_detail_history");
}

function saveCash(){
	 Common.ajax("GET", "/payment/saveCash", $("#cashForm").serialize(), function(result) {
		 //Common.setMsg(result.message);  
		 Common.alert(result.message);
	 });
}

function saveCreditCard(){
	Common.ajax("GET", "/payment/saveCreditCard", $("#creditCardForm").serialize(), function(result) {
		Common.alert(result.message);
    });
}

function saveCheque(){
	Common.ajax("GET", "/payment/saveCheque", $("#ChequeForm").serialize(), function(result) {
		Common.alert(result.message);
    });
}

function saveOnline(){
    Common.ajax("GET", "/payment/saveOnline", $("#OnlineForm").serialize(), function(result) {
    	Common.alert(result.message);
    });
}
function saveChanges() {
	
	var payId = $("#payId").val();
	var trNo = $("#edit_txtTRRefNo").val();
	var branchId = $("#edit_branchId").val();
	
	if($.trim(trNo).length > 10 ){
        Common.alert("* The TR number cannot exceed length of 10.");
        return;
    }
	
	if($.trim(branchId ) == ""){
		Common.alert("* Please select the key-in branch.");
		return;
	}
	
	
	if($("#btnAllowComm").is(":checked")){
		$("#allowComm").val(1);
	}else{
		$("#allowComm").val(0);
	}
	
	$("#hiddenPayId").val(payId);
	
	Common.ajax("POST", "/payment/saveChanges", $('#myForm').serializeJSON(), function(result) {
		
		var msg = result.message;
        Common.alert(msg);
        // 공통 메세지 영역에 메세지 표시.
        Common.setMsg("<spring:message code='sys.msg.success'/>");

	}, function(jqXHR, textStatus, errorThrown) {
        Common.alert("실패하였습니다.");
    });
}

function goRcByBs() {
	location.href = "initRentalCollectionByBS.do";
}
</script>

<!-- content start -->
<section id="content">
    <ul class="path">
        <li><img src="/resources/images/common/path_home.gif" alt="Home" /></li>
        <li>Payment</li>
        <li>Payment</li>
        <li>Search Payment</li>
    </ul>

    <!-- title_line start -->
    <aside class="title_line">
        <p class="fav"><a href="#" class="click_add_on">My menu</a></p>
        <h2>Search Payment</h2>
        <ul class="right_btns">
            <li><p class="btn_blue"><a href="javascript:fn_getOrderListAjax();"><span class="search"></span>Search</a></p></li>
        </ul>
    </aside>
    <!-- title_line end -->

    <!-- search_table start -->
    <section class="search_table">
        <form name="searchForm" id="searchForm"  method="post">

            <table class="type1"><!-- table start -->
                <caption>table</caption>
				<colgroup>
				    <col style="width:140px" />
				    <col style="width:*" />
				    <col style="width:130px" />
				    <col style="width:*" />
				    <col style="width:170px" />
				    <col style="width:*" />
				</colgroup>
				<tbody>
					<tr>
					    <th scope="row">Order No.</th>
					    <td>
						    <input id="orderNo" name="orderNo" type="text" title="Customer ID" placeholder="Order No." class="w100p" />
					    </td>
					    <th scope="row">Pay Date</th>
					    <td>
					       <div class="date_set w100p"><!-- date_set start -->
						    <p><input id="payDate1" name="payDate1" type="text" title="Pay start Date" placeholder="DD/MM/YYYY" class="j_date" readonly /></p>
						    <span>~</span>
						    <p><input id="payDate2" name="payDate2"  type="text" title="Pay end Date" placeholder="DD/MM/YYYY" class="j_date" readonly  /></p>
						    </div><!-- date_set end -->
					    </td>
					    <th scope="row">Application Type</th>
					    <td>
					       <select id="applicationType" name="applicationType" class="w100p">					          
                           </select>
					    </td>
					</tr>
					<tr>
					    <th scope="row">OR No</th>
					    <td>
					       <input id="orNo" name="orNo" type="text" title="OR No" placeholder="OR No." class="w100p" />
					    </td>
					   <th scope="row">PO No</th>
                        <td>
                           <input id="poNo" name="poNo" type="text" title="PO No" placeholder="PO No." class="w100p" />
                        </td>
					    <th scope="row">Payment Type</th>
					    <td>
					       <select id="paymentType" name="paymentType" class="w100p">                               
                           </select>
					    </td>
					</tr>
					<tr>
					    <th scope="row">Customer ID</th>
					    <td>
					       <input id="customerId" name="customerId" type="text" title="Customer Id" placeholder="Customer ID" class="w100p" />
					    </td>
					    <th scope="row">KeyIn Branch</th>
					    <td>
						    <select id="branchId" name="branchId" class="w100p">
                             </select>
					    </td>
					    <th scope="row">KeyIn User</th>
                        <td>
                            <select id="userId" name="userId" class="w100p">
                                <option value="">Select Branch</option>                                                                 
                             </select>
                        </td>
					</tr>					
					<tr>
                        <th scope="row">Customer Name</th>
                        <td>
                           <input id="customerName" name="customerName" type="text" title="Customer Name" placeholder="Customer Name" class="w100p" />
                        </td>
                        <th scope="row">Customer IC/Company No.</th>
                        <td>
                           <input id="customerIC" name="customerIC" type="text" title="Customer IC/Company No" placeholder="Customer IC/Company No." class="w100p" />
                        </td>
                        <th scope="row">TR No</th>
                        <td>
                           <input id="trNo" name="trNo" type="text" title="TR No" placeholder="TR No." class="w100p" />
                        </td>                        
                    </tr>
                    <tr>
                        <th scope="row">Cheque No</th>
                        <td>
                           <input id="chequeNo" name="chequeNo" type="text" title="Cheque No" placeholder="Cheque No" class="w100p" />
                        </td>
                        <th scope="row">CRC No</th>
                        <td>
                           <input id="crcNo" name="crcNo" type="text" title="CRC No" placeholder="CRC No." class="w100p" />
                        </td>
                        <th scope="row">Issue Bank</th>
                        <td>
                            <select id="bankAccount" name="bankAccount" class="w100p">                                                               
                            </select>
                        </td>                        
                    </tr>
                    <tr>
                        <th scope="row">Batch Payment ID</th>
                        <td>
                           <input id="batchPaymentId" name="batchPaymentId" type="text" title="Batch Payment ID" placeholder="Batch Payment ID" class="w100p" />
                        </td>
                        <th scope="row"></th>
                        <td>                           
                        </td>
                        <th scope="row"></th>
                        <td>                            
                        </td>                        
                    </tr>
                </tbody>
            </table>
            <!-- table end -->

            <!-- link_btns_wrap start -->
            <aside class="link_btns_wrap">
                <p class="show_btn"><a href="#"><img src="/resources/images/common/btn_link.gif" alt="link show" /></a></p>
				<dl class="link_list">
				    <dt>Link</dt>
				    <dd>
				    <ul class="btns">
				        <li><p class="link_btn"><a href="#">Payment Listing</a></p></li>
				        <li><p class="link_btn"><a href="#">RC By Sales</a></p></li>
				        <li><p class="link_btn"><a href="javascript:goRcByBs();">RC By BS</a></p></li>
				        <li><p class="link_btn"><a href="#">Daily Collection Raw</a></p></li>
				        <li><p class="link_btn"><a href="#">Late Submission Raw</a></p></li>
				        <li><p class="link_btn"><a href="#">Official Receipt</a></p></li>				        
				    </ul>
				    <ul class="btns">
				        <li><p class="link_btn type2"><a href="javascript:fn_openDivPop('VIEW');">Veiw Details</a></p></li>
				        <li><p class="link_btn type2"><a href="javascript:fn_openDivPop('EDIT');">Edit Details</a></p></li>
				        <li><p class="link_btn type2"><a href="#">Fund Transfer</a></p></li>
				        <li><p class="link_btn type2"><a href="#">Reverse Payment(Void)</a></p></li>
				        <li><p class="link_btn type2"><a href="#">Refund</a></p></li>		
				        <li><p class="link_btn type2"><a href="#" onclick="showItemEdit();">TEMP1</a></p></li>           
				    </ul>
				    <p class="hide_btn"><a href="#"><img src="/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
				    </dd>
				</dl>
            </aside>
            <!-- link_btns_wrap end -->
        </form>
    </section>
    <!-- search_table end -->

    <!-- search_result start -->
    <section class="search_result">		

        <!-- grid_wrap start -->
        <article id="grid_wrap" class="grid_wrap"></article>
        <!-- grid_wrap end -->
        
        <!-- grid_wrap start -->
        <article id="grid_sub_wrap" class="grid_wrap"></article>
        <!-- grid_wrap end -->

    </section>
    <!-- search_result end -->

</section>

<div id="popup_wrap" style="display:none;">
<!-- popup_wrap start -->
<header class="pop_header"><!-- pop_header start -->
<h1>VIEW PAYMENT DETAILS</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#" onclick="fn_close();">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->
    <aside class="title_line"><!-- title_line start -->
        <h2>Payment Information</h2>
    </aside><!-- title_line end -->
    <table class="type1"><!-- table start -->
        <caption>table</caption>
                <colgroup>
                    <col style="width:165px" />
                    <col style="width:*" />
                    <col style="width:165px" />
                    <col style="width:*" />
                </colgroup>
                <tbody>
                    <tr>
                        <th scope="row">OR(Official Receipt) No</th>
                        <td id="txtORNo"></td>
                        <th scope="row"> Last Updated By </th>
                        <td id="txtLastUpdator"></td>
                    </tr>
                     <tr>
                        <th scope="row">Payment Key By</th>
                        <td id="txtKeyInUser"></td>
                        <th scope="row">Order No.</th>
                        <td id="txtOrderNo"></td>
                    </tr>
                    <tr>
                        <th scope="row">TR Ref. No.</th>
                        <td id="txtTRRefNo"></td>
                        <th scope="row">TR Issued Date</th>
                        <td id="txtTRIssueDate"></td>
                    </tr>
                     <tr>
                        <th scope="row">Product Category</th>
                        <td id="txtProductCategory"></td>
                        <th scope="row">Product Name</th>
                        <td id="txtProductName"></td>
                        
                    </tr>
                    <tr>
                        <th scope="row">Application Type</th>
                        <td id="txtAppType"></td>
                        <th scope="row">Customer Name</th>
                        <td id="txtCustomerName"></td>
                        
                    </tr>
                    <tr>
                        <th scope="row">Customer Type</th>
                        <td id="txtCustomerType"></td>
                        <th scope="row"> Customer ID </th>
                        <td id="txtCustomerID"></td>
                    </tr>
                    <tr>
                        <th scope="row">Order Progress Status</th>
                        <td id="txtOrderProgressStatus"></td>
                        <th scope="row">Install No.</th>
                        <td id="txtInstallNo"></td>
                    </tr>
                    <tr>
                        <th scope="row">Cust. NRIC/Company No.</th>
                        <td id="txtNRIC"></td>
                        <th scope="row">Payment Type</th>
                        <td id="txtPayType"></td>
                    </tr>
                    <tr>
                        <th scope="row">Advance Month</th>
                        <td id="txtAdvMth"></td>
                        <th scope="row"> Payment Date </th>
                        <td id="txtPayDate"></td>
                    </tr>
                    <tr>
                        <th scope="row">HP Code</th>
                        <td id="txtHPCode"></td>
                        <th scope="row">HP Name</th>
                        <td id="txtHPName"></td>
                    </tr>
                    <tr>
                        <th scope="row">Batch Payment ID</th>
                        <td id="txtBatchPaymentID"></td>
                    </tr>
                </tbody>
    </table>
    <aside class="title_line"><!-- title_line start -->
        <h2>Collector Information</h2>
    </aside><!-- title_line end -->
    <table class="type1"><!-- table start -->
            <caption>table</caption>
                <colgroup>
                    <col style="width:165px" />
                    <col style="width:*" />
                    <col style="width:165px" />
                    <col style="width:*" />
                </colgroup>
                <tbody>
                    <tr>
                        <th scope="row">Payment Collector Code</th>
                        <td id="txtCollectorCode"></td>
                        <th scope="row">HP Code/Dealer</th>
                        <td id="txtSalesPerson"></td>
                    </tr>
                     <tr>
                        <th scope="row">Branch Code</th>
                        <td id="txtBranch"></td>
                        <th scope="row">Debtor Account</th>
                        <td id="txtDebtor"></td>
                    </tr>
                </tbody>
    </table>
    <ul class="center_btns">
        <li><p class="btn_blue2"><a href="javascript:showViewHistory()">View History</a></p></li>
    </ul>
    <section class="search_result"><!-- search_result start -->
	    <article class="grid_wrap"  id="popList_wrap" style="width  : 100%;">
	    </article><!-- grid_wrap end -->
    </section><!-- search_result end -->
    <section class="search_result"><!-- search_result start -->
       <aside class="title_line" ><!-- title_line start -->
        <h2 id="gridTitle">All Related Payments In This Transaction.(Click A Row To View Details) </h2>
        </aside><!-- title_line end -->
	    <article class="grid_wrap"  id="popSlaveList_wrap" style="width  : 100%;">
	    </article><!-- grid_wrap end -->
    </section><!-- search_result end -->
</section><!-- pop_body end -->
</div><!-- popup_wrap end -->
<div id="popup_wrap2" class="popup_wrap" style="display:none;">
<!-- popup_wrap start -->
<header class="pop_header"><!-- pop_header start -->
<h1>PAYMENT EDITOR</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#" onclick="fn_close2();">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->
<form name="myForm" id="myForm">
<section class="pop_body"><!-- pop_body start -->
    <aside class="title_line"><!-- title_line start -->
        <h2>Payment Information</h2>
    </aside><!-- title_line end -->
    <table class="type1"><!-- table start -->
        <caption>table</caption>
                <colgroup>
                    <col style="width:165px" />
                    <col style="width:*" />
                    <col style="width:165px" />
                    <col style="width:*" />
                </colgroup>
                <tbody>
                    <tr>
                        <th scope="row">OR(Official Receipt) No</th>
                        <td id="edit_txtORNo"></td>
                        <th scope="row"> Last Updated By </th>
                        <td id="edit_txtLastUpdator"></td>
                    </tr>
                     <tr>
                        <th scope="row">Payment Key By</th>
                        <td id="edit_txtKeyInUser"></td>
                        <th scope="row">Order No.</th>
                        <td id="edit_txtOrderNo"></td>
                    </tr>
                    <tr>
                        <th scope="row">TR Ref. No.</th>
                        <td><input type="text" name="edit_txtTRRefNo" id="edit_txtTRRefNo"></td>
                        <th scope="row">TR Issued Date</th>
                        <td id="">
                            <div class="date_set"><!-- date_set start -->
                                <p><input type="text"  name="edit_txtTRIssueDate" id="edit_txtTRIssueDate" title="Create Date From"  class="j_date" /></p>
                            </div>
                        </td>
                    </tr>
                     <tr>
                        <th scope="row">Product Category</th>
                        <td id="edit_txtProductCategory"></td>
                        <th scope="row">Product Name</th>
                        <td id="edit_txtProductName"></td>
                        
                    </tr>
                    <tr>
                        <th scope="row">Application Type</th>
                        <td id="edit_txtAppType"></td>
                        <th scope="row">Customer Name</th>
                        <td id="edit_txtCustomerName"></td>
                        
                    </tr>
                    <tr>
                        <th scope="row">Customer Type</th>
                        <td id="edit_txtCustomerType"></td>
                        <th scope="row"> Customer ID </th>
                        <td id="edit_txtCustomerID"></td>
                    </tr>
                    <tr>
                        <th scope="row">Order Progress Status</th>
                        <td id="edit_txtOrderProgressStatus"></td>
                        <th scope="row">Install No.</th>
                        <td id="edit_txtInstallNo"></td>
                    </tr>
                    <tr>
                        <th scope="row">Cust. NRIC/Company No.</th>
                        <td id="edit_txtNRIC"></td>
                        <th scope="row">Payment Type</th>
                        <td id="edit_txtPayType"></td>
                    </tr>
                    <tr>
                        <th scope="row">Advance Month</th>
                        <td id="edit_txtAdvMth"></td>
                        <th scope="row"> Payment Date </th>
                        <td id="edit_txtPayDate"></td>
                    </tr>
                    <tr>
                        <th scope="row">Branch Code</th>
                        <td id="" colspan="3">
                            <select id="edit_branchId" name="edit_branchId" class="w100p">
                             </select>
                        </td>
                    </tr>
                </tbody>
    </table>
    <aside class="title_line"><!-- title_line start -->
        <h2>Collector Information</h2>
    </aside><!-- title_line end -->
    <table class="type1"><!-- table start -->
            <caption>table</caption>
                <colgroup>
                    <col style="width:165px" />
                    <col style="width:*" />
                    <col style="width:165px" />
                    <col style="width:*" />
                </colgroup>
                <tbody>
                    <tr>
                        <th scope="row">Collector Code</th>
                        <td id=""><input type="text" name="edit_txtCollectorCode" id="edit_txtCollectorCode"></td>
                        <th scope="row">HP Code/Dealer</th>
                        <td id="edit_txtSalesPerson"></td>
                    </tr>
                     <tr>
                        <th scope="row">Collector Name</th>
                        <td id="edit_txtClctrName"></td>
                        <th scope="row">Debtor Account</th>
                        <td id="edit_txtDebtor"></td>
                    </tr>
                </tbody>
    </table>
    <ul class="left_btns">
        <li><label><input name="btnAllowComm" id="btnAllowComm" type="checkbox"  /><span>Allow commission for this payment </span></label></li>
    </ul>
    <ul class="center_btns">
        <li><p class="btn_blue2"><a href="javascript:saveChanges()">Update</a></p></li>
        <li><p class="btn_blue2"><a href="javascript:showViewHistory()">View History</a></p></li>
    </ul>
    <section class="search_result"><!-- search_result start -->
        <article class="grid_wrap"  id="editPopList_wrap" style="width  : 100%;">
        </article><!-- grid_wrap end -->
    </section><!-- search_result end -->
</section><!-- pop_body end -->
<input type="hidden" name="hiddenPayId" id="hiddenPayId">
<input type="hidden" name="allowComm" id="allowComm">
</form>
</div><!-- popup_wrap end -->
<div id="view_history_wrap" class="popup_wrap size_small" style="display:none;">
    <header class="pop_header">
        <h1>PAYMENT MASTER HISTORY</h1>
        <ul class="right_opt">
            <li><p class="btn_blue2"><a href="#" onclick="hideViewPopup()">CLOSE</a></p></li>
        </ul>
    </header>
    <!-- pop_body start -->
    <section class="pop_body">
       
        <!-- grid_wrap start -->
        <article id="grid_view_history" class="grid_wrap"></article>
        <!-- grid_wrap end -->
    </section>
    <!-- pop_body end -->
</div>

<div id="view_detail_wrap" class="popup_wrap size_small" style="display:none;">
    <header class="pop_header">
        <h1>PAYMENT DETAIL HISTORY</h1>
        <ul class="right_opt">
            <li><p class="btn_blue2"><a href="#" onclick="hideDetailPopup()">CLOSE</a></p></li>
        </ul>
    </header>
    <!-- pop_body start -->
    <section class="pop_body">
       
        <!-- grid_wrap start -->
        <article id="grid_detail_history" class="grid_wrap"></article>
        <!-- grid_wrap end -->
    </section>
    <!-- pop_body end -->
</div>
<!-- content end -->
<form name="detailForm" id="detailForm"  method="post">
    <input type="hidden" name="payId" id="payId" />
    <input type="hidden" name="salesOrdId" id="salesOrdId" />
</form>      

<div id="item_edit_cash" class="popup_wrap size_small" style="display:none;">
    <header class="pop_header">
        <h1>PAYMENT ITEM - EDIT</h1>
        <ul class="right_opt">
            <li><p class="btn_blue2"><a href="#" onclick="hideDetailPopup()">CLOSE</a></p></li>
        </ul>
    </header>
    <!-- pop_body start -->
    <section class="pop_body">
    <form id="cashForm" name="payDetail">
    <table class="type1">
        <colgroup>
            <col style="width:165px" />
            <col style="width:*" />
        </colgroup>
        <tbody>
        <tr>
            <th>Payment Mode</th>
            <td id="paymentCa"></td>
        </tr>
        <tr>
            <th>Amount</th>
            <td id="amountCa"></td>
        </tr>
        <tr>
            <th>Bank Account</th>
            <td id="bankAccCa"></td>
        </tr>
        <tr>
            <th>Reference No</th>
            <td id="referenceNoCa">
                <p><input type="text" name="txtReferenceNoCa" id="txtReferenceNoCa" placeholder="Reference No" /></p>
            </td>
        </tr>
        <tr>
            <th>Reference Date</th>
            <td id="referenceDateCa">
                 <p><input type="text"  name="txtRefDateCa" id="txtRefDateCa" title="Create Date From" placeholder="DD/MM/YYYY" class="j_date" /></p>
            </td>
        </tr>
        <tr>
            <th>Running No</th>
            <td id="runningNoCa">
                <p><input type="text" name="txtRunNoCa" id="txtRunNoCa" placeholder="runningNo"/></p>
            </td>
        </tr>
        <tr>
            <th>Remark</th>
            <td id="r">
                <p><textarea id="tareaRemarkCa" name="tareaRemarkCa"></textarea></p>
            </td>
        </tr>
        <tr>
            <td colspan="2"> 
	            <ul class="center_btns">
	               <li><p class="btn_blue2"><a href="#" onclick="saveCash()">save</a></p></li>
	             </ul>
             </td>
        </tr>
        </tbody>
    </table>
    <input type="hidden" id="payItemId" name="payItemId"/>
    <input type="hidden" id="payId" name="payId"/>
    </form>
    </section>
    <!-- pop_body end -->
</div>
<!-- content end -->

<div id="item_edit_credit" class="popup_wrap size_small" style="display:none;">
    <header class="pop_header">
        <h1>PAYMENT ITEM - EDIT</h1>
        <ul class="right_opt">
            <li><p class="btn_blue2"><a href="#" onclick="hideDetailPopup()">CLOSE</a></p></li>
        </ul>
    </header>
    <!-- pop_body start -->
    <section class="pop_body">
    <form id="creditCardForm" name="creditCardForm">
    <input type="hidden" id="payItemIdCC" name="payItemIdCC"/>
    <input type="hidden" id="payIdCC" name="payIdCC"/>
    <input type="hidden" id="txtCrcNo" name="txtCrcNo" />
    <table class="type1">
        <colgroup>
            <col style="width:165px" />
            <col style="width:*" />
        </colgroup>
        <tbody>
        <tr>
            <th>Payment Mode</th>
            <td id="paymentCC"></td>
        </tr>
        <tr>
            <th>Amount</th>
            <td id="amountCC"></td>
        </tr>
        <tr>
            <th>Bank Account</th>
            <td id="bankAccCC"></td>
        </tr>
        <tr>
            <th>Issued Bank</th>
            <td id="issuedBankCC">
                <select id="cmbIssuedBankCC" name="cmbIssuedBankCC" class="w100p"></select>
            </td>
        </tr>
        <tr>
            <th>Credit Card No</th>
            <td id="CCNo"></td>
        </tr>
        <tr>
            <th>Credit Card Holder</th>
            <td id="cCHolder">
                <p><input type="text" name="txtCCHolderName" id="txtCCHolderName" placeholder="Credit Card Holder Name" /></p>
            </td>
        </tr>
        <tr>
            <th>Credit Card Expiry</th>
            <td id="ccExpiry">
                <p><input type="text"  name="txtCCExpiry" id="txtCCExpiry"  placeholder="DD/MM/YYYY" class="j_date" /></p>
            </td>
        </tr>
        <tr>
            <th>Card Type</th>
            <td id="cardTypeCC">
                <select id="cmbCardTypeCC" name="cmbCardTypeCC" class="w100p">
                    <option value="1241">Credit Card</option>
                    <option value="1240">Debit Card</option>
                </select>
            </td>
        </tr>
        <tr>
            <th>Credit Card Type</th>
            <td id="creditCardTypeCC">
                <select id="cmbCreditCardTypeCC" name="cmbCreditCardTypeCC" class="w100p"></select>
            </td>
        </tr>
        <tr>
            <th>Credit Card Mode</th>
            <td id="creditCardModeCC"></td>
        </tr>
        <tr>
            <th>Approval Number</th>
            <td id="approvalNumberCC"></td>
        </tr>
        <tr>
            <th>Reference No</th>
            <td id="referenceNoCC">
                <p><input type="text" name="txtRefNoCC" id="txtRefNoCC" /></p>
            </td>
        </tr>
        <tr>
            <th>Reference Date</th>
            <td id="referenceDateCC">
                <p><input type="text" name="txtRefDateCC" id="txtRefDateCC" placeholder="DD/MM/YYYY" class="j_date"/></p>
            </td>
        </tr>
        <tr>
            <th>Running No</th>
            <td id="runningNoCC">
                <p><input type="text" name="txtRunningNoCC" id="txtRunningNoCC" placeholder="Running Number"/></p>
            </td>
        </tr>
        <tr>
            <th>Remark</th>
            <td id="remarkCC">
                <p><textarea id="tareaRemarkCC" name="tareaRemarkCC"></textarea></p>
            </td>
        </tr>
        <tr>
            <td colspan="2"> 
                <ul class="center_btns">
                   <li><p class="btn_blue2"><a href="#" onclick="saveCreditCard()">save</a></p></li>
                 </ul>
             </td>
        </tr>
        </tbody>
    </table>

    </form>
    </section>
    <!-- pop_body end -->
</div>
<!-- content end -->

<div id="item_edit_cheque" class="popup_wrap size_small" style="display:none;">
    <header class="pop_header">
        <h1>PAYMENT ITEM - EDIT</h1>
        <ul class="right_opt">
            <li><p class="btn_blue2"><a href="#" onclick="hideDetailPopup()">CLOSE</a></p></li>
        </ul>
    </header>
    <!-- pop_body start -->
    <section class="pop_body">
    <form id="ChequeForm" name="ChequeForm">
    <table class="type1">
        <colgroup>
            <col style="width:165px" />
            <col style="width:*" />
        </colgroup>
        <tbody>
        <tr>
            <th>Payment Mode</th>
            <td id="paymentCh"></td>
        </tr>
        <tr>
            <th>Amount</th>
            <td id="amountCh"></td>
        </tr>
        <tr>
            <th>Bank Account</th>
            <td id="bankAccCh"></td>
        </tr>
        <tr>
            <th>Issued Bank</th>
            <td id="issuedBankCh">
                <p><select id="sIssuedBankCh" name="sIssuedBankCh"></select></p>
            </td>
        </tr>
        <tr>
            <th>Cheque Number</th>
            <td id="chequeNumberCh"></td>
        </tr>
        <tr>
            <th>Reference Number</th>
            <td id="referenceNumberCh">
                <p><input type="text" name="txtRefNumberCh" id="txtRefNumberCh" placeholder="Reference Number" /></p>
            </td>
        </tr>
        <tr>
            <th>Reference Date</th>
            <td id="refDateCh">
                 <p><input type="text"  name="txtRefDateCh" id="txtRefDateCh" title="Create Date From" placeholder="DD/MM/YYYY" class="j_date" /></p>
            </td>
        </tr>
        <tr>
            <th>Running No</th>
            <td id="runningNoCh">
                <p><input type="text" name="txtRunNoCh" id="txtRunNoCh" placeholder="runningNo" readonly="readonly"/></p>
            </td>
        </tr>
        <tr>
            <th>Remark</th>
            <td id="r">
                <p><textarea id="tareaRemarkCh" name="tareaRemarkCh"></textarea></p>
            </td>
        </tr>
        <tr>
            <td colspan="2"> 
                <ul class="center_btns">
                   <li><p class="btn_blue2"><a href="#" onclick="saveCheque()">save</a></p></li>
                 </ul>
             </td>
        </tr>
        </tbody>
    </table>
    <input type="hidden" id="payItemIdCh" name="payItemIdCh"/>
    <input type="hidden" id="payIdCh" name="payIdCh"/>
    <input type="hidden" id="chequeNo" name="chequeNo" />
    </form>
    </section>
    <!-- pop_body end -->
</div>
<!-- content end -->
<div id="item_edit_online" class="popup_wrap size_small" style="display:none;">
    <header class="pop_header">
        <h1>PAYMENT ITEM - EDIT</h1>
        <ul class="right_opt">
            <li><p class="btn_blue2"><a href="#" onclick="hideDetailPopup()">CLOSE</a></p></li>
        </ul>
    </header>
    <!-- pop_body start -->
    <section class="pop_body">
    <form id="OnlineForm" name="OnlineForm">
    <table class="type1">
        <colgroup>
            <col style="width:165px" />
            <col style="width:*" />
        </colgroup>
        <tbody>
        <tr>
            <th>Payment Mode</th>
            <td id="paymentOn"></td>
        </tr>
        <tr>
            <th>Amount</th>
            <td id="amountOn"></td>
        </tr>
        <tr>
            <th>Bank Account</th>
            <td id="bankAccOn"></td>
        </tr>
        <tr>
            <th>Issued Bank</th>
            <td id="issuedBankOn">
                <p><select id="cmbIssuedBankOn" name="cmbIssuedBankOn"></select></p>
            </td>
        </tr>
        <tr>
            <th>Reference No</th>
            <td id="referenceNoOn">
                <p><input type="text" name="txtRefNoOn" id="txtRefNoOn" placeholder="Reference Number" /></p>
            </td>
        </tr>
        <tr>
            <th>Reference Date</th>
            <td id="refDateCh">
                 <p><input type="text"  name="txtRefDateOn" id="txtRefDateOn" title="Create Date From" placeholder="DD/MM/YYYY" class="j_date" /></p>
            </td>
        </tr>
        <tr>
            <th>EFT No</th>
            <td id="runningNoCh">
                <p><input type="text" name="txtEFTNoOn" id="txtEFTNoOn" /></p>
            </td>
        </tr>
        <tr>
            <th>Running No</th>
            <td id="runningNoCh">
                <p><input type="text" name="txtRunNoOn" id="txtRunNoOn"/></p>
            </td>
        </tr>
        <tr>
            <th>Remark</th>
            <td id="r">
                <p><textarea id="tareaRemarkOn" name="tareaRemarkOn"></textarea></p>
            </td>
        </tr>
        <tr>
            <td colspan="2"> 
                <ul class="center_btns">
                   <li><p class="btn_blue2"><a href="#" onclick="saveOnline()">save</a></p></li>
                 </ul>
             </td>
        </tr>
        </tbody>
    </table>
    <input type="hidden" id="payItemIdOn" name="payItemIdOn"/>
    <input type="hidden" id="payIdOn" name="payIdOn"/>
    </form>
    </section>
    <!-- pop_body end -->
</div>
<!-- content end -->
