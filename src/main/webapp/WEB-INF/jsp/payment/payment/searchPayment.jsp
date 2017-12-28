<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<script type="text/javaScript">

//AUIGrid 그리드 객체
var myGridID,subGridID;
var viewHistoryGridID;

//Grid에서 선택된 RowID
var selectedGridValue;

//Edit 등록 화면에 파라미터로 넘길 변수
var reconLock;

var gridPros_popList = {            
        editable : false,                 // 편집 가능 여부 (기본값 : false)
        showStateColumn : false     // 상태 칼럼 사용
};

//Grid Properties 설정 
var gridPros = {            
        editable : false,                 // 편집 가능 여부 (기본값 : false)
        showStateColumn : false     // 상태 칼럼 사용
};

//Grid Properties 설정 : 마스터 그리드용 
var gridProsMaster = {
        editable : false,                 // 편집 가능 여부 (기본값 : false)
        showStateColumn : false,     // 상태 칼럼 사용
        showRowNumColumn : false,
        usePaging : false
};

//페이징에 사용될 변수
var _totalRowCount;

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
    myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout,null,gridProsMaster);
    
    
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
    { dataField:"payDt" ,headerText:"<spring:message code='pay.head.trxNo'/>",editable : false  , visible:false, dataType : "date", formatString : "dd-mm-yyyy"},
    { dataField:"payTypeId" ,headerText:"<spring:message code='pay.head.trxNo'/>",editable : false ,visible:false},

    {dataField:"rnum", headerText:"<spring:message code='pay.head.no'/>", width : 80,editable : false },
    { dataField:"trxId" ,headerText:"<spring:message code='pay.head.trxNo'/>",editable : false },
	{ dataField:"trxDt" ,headerText:"<spring:message code='pay.head.trxDate'/>",editable : false , dataType : "date", formatString : "dd-mm-yyyy"},
	{ dataField:"trxAmt" ,headerText:"<spring:message code='pay.head.trxTotal'/>" ,editable : false , dataType : "numeric", formatString : "#,##0.#"},
	{ dataField:"payId" ,headerText:"<spring:message code='pay.head.PID'/>" ,editable : false },
	{ dataField:"orNo" ,headerText:"<spring:message code='pay.head.ORNo'/>" ,editable : false },
	{ dataField:"payTypeName" ,headerText:"<spring:message code='pay.head.payType'/>" ,editable : false },
	{ dataField:"AdvMonth" ,headerText:"<spring:message code='pay.head.advMonth'/>" ,editable : false },
	{ dataField:"trNo" ,headerText:"<spring:message code='pay.head.TRNo'/>" ,editable : false },
	{ dataField:"orAmt" ,headerText:"<spring:message code='pay.head.ORTotal'/>" ,editable : false , dataType : "numeric", formatString : "#,##0.#"},
	{ dataField:"salesOrdNo" ,headerText:"<spring:message code='pay.head.orderNo'/>" ,editable : false },
	{ dataField:"appTypeName" ,headerText:"<spring:message code='pay.head.appType'/>" ,editable : false },
	{ dataField:"productDesc" ,headerText:"<spring:message code='pay.head.product'/>" ,editable : false },
	{ dataField:"custName" ,headerText:"<spring:message code='pay.head.customer'/>" ,editable : false },
	{ dataField:"custIc" ,headerText:"<spring:message code='pay.head.ICCONo'/>" ,editable : false },
	{ dataField:"virtlAccNo" ,headerText:"<spring:message code='pay.head.VANo'/>" ,editable : false },
	{ dataField:"clctrBrnchName" ,headerText:"<spring:message code='pay.head.branch'/>" ,editable : false },
	{ dataField:"keyinUserName" ,headerText:"<spring:message code='pay.head.userName'/>" ,editable : false },
	{ dataField:"salesOrdId" ,headerText:"<spring:message code='pay.head.salesOrdId'/>" ,editable : false, visible : true}
    ];

var slaveColumnLayout = [ 
	{ dataField:"payId" ,headerText:"<spring:message code='pay.head.payID'/>",editable : false ,visible : false },
	{ dataField:"payItmId" ,headerText:"<spring:message code='pay.head.itemId'/>",editable : false ,visible : false },
	{ dataField:"codeName" ,headerText:"<spring:message code='pay.head.mode'/>",editable : false },
	{ dataField:"payItmRefNo" ,headerText:"<spring:message code='pay.head.refNo'/>",editable : false },
	{ dataField:"c7" ,headerText:"<spring:message code='pay.head.cardType'/>" ,editable : false },
	{ dataField:"codeName1" ,headerText:"<spring:message code='pay.head.CCType'/>" ,editable : false },
	{ dataField:"payItmCcHolderName" ,headerText:"<spring:message code='pay.head.CCHolder'/>" ,editable : false },
	{ dataField:"payItmCcExprDt" ,headerText:"<spring:message code='pay.head.CCExpiryDate'/>" ,editable : false , dataType : "date", formatString : "dd-mm-yyyy"},
	{ dataField:"payItmChqNo" ,headerText:"<spring:message code='pay.head.chequeNo'/>" ,editable : false },
	{ dataField:"name" ,headerText:"<spring:message code='pay.head.issueBank'/>" ,editable : false },
	{ dataField:"payItmAmt" ,headerText:"<spring:message code='pay.head.amount'/>" ,editable : false , dataType : "numeric", formatString : "#,##0.#"},                   
	{ dataField:"c8" ,headerText:"<spring:message code='pay.head.CRCMode'/>" ,editable : false },
	{ dataField:"accDesc" ,headerText:"<spring:message code='pay.head.bankAccount'/>" ,editable : false },
	{ dataField:"c3" ,headerText:"<spring:message code='pay.head.account'/>" ,editable : false },
	{ dataField:"payItmRefDt" ,headerText:"<spring:message code='pay.head.refDate'/>" ,editable : false , dataType : "date", formatString : "dd-mm-yyyy"},
	{ dataField:"payItmAppvNo" ,headerText:"<spring:message code='pay.head.apprNo'/>" ,editable : false },
	{ dataField:"c4" ,headerText:"<spring:message code='pay.head.eft'/>" ,editable : false },
	{ dataField:"c5" ,headerText:"<spring:message code='pay.head.runningNo'/>" ,editable : false },
	{ dataField:"payItmRem" ,headerText:"<spring:message code='pay.head.remark'/>" ,editable : false },
	{ dataField:"payItmBankChrgAmt" ,headerText:"<spring:message code='pay.head.bankCharge'/>" ,editable : false , dataType : "numeric", formatString : "#,##0.#"}
    ];
              
var popEditColumnLayout = [    
    { dataField:"history" ,
        width: 30,
        headerText:" ", 
        colSpan : 2,
       renderer : 
               {
              type : "IconRenderer",
              iconTableRef :  {
                  "default" : "${pageContext.request.contextPath}/resources/images/common/search.png"// default
              },         
              iconWidth : 16,
              iconHeight : 16,
             onclick : function(rowIndex, columnIndex, value, item) {
            	 showDetailHistory(item.payItmId, reconLock);
             }
           }
    },
    { dataField:"history" ,
        width: 30,
        headerText:" ", 
        colSpan : -1,        
        renderer : 
               {
              type : "IconRenderer",
              iconTableRef :  {
                  "default" : "${pageContext.request.contextPath}/resources/images/common/modified_icon.png"// default
              },         
              iconWidth : 16, // icon 가로 사이즈, 지정하지 않으면 24로 기본값 적용됨
              iconHeight : 16,              
              onclick : function(rowIndex, columnIndex, value, item) {   
                	showItemEdit(item.payItmId);
             }
           }
    },    
    { dataField:"payId" ,headerText:" ",editable : false , visible : false },
    { dataField:"codeName" ,headerText:"<spring:message code='pay.head.mode'/>",editable : false},
    { dataField:"payItmRefNo" ,headerText:"<spring:message code='pay.head.refNo'/>",editable : false },
    { dataField:"c7" ,headerText:"<spring:message code='pay.head.cardType'/>",editable : false },
    { dataField:"codeName1" ,headerText:"<spring:message code='pay.head.CCType'/>" ,editable : false },
    { dataField:"codeName1" ,headerText:"<spring:message code='pay.head.CCType'/>" ,editable : false },
    { dataField:"payItmCcHolderName" ,headerText:"<spring:message code='pay.head.CCHolder'/>" ,editable : false },
    { dataField:"payItmCcExprDt" ,headerText:"<spring:message code='pay.head.CCExpiryDate'/>" ,editable : false , dataType : "date", formatString : "dd-mm-yyyy"},
    { dataField:"" ,headerText:"<spring:message code='pay.head.CRCNo'/> ,editable : false }", editable : false},
    { dataField:"payItmChqNo" ,headerText:"<spring:message code='pay.head.chequeNo'/>" ,editable : false },
    { dataField:"name" ,headerText:"<spring:message code='pay.head.issueBank'/>" ,editable : false },                   
    { dataField:"payItmAmt" ,headerText:"<spring:message code='pay.head.amount'/>" ,editable : false },
    { dataField:"c8" ,headerText:"<spring:message code='pay.head.CRCMode'/>" ,editable : false },
    { dataField:"accDesc" ,headerText:"<spring:message code='pay.head.bankAccount'/>" ,editable : false },
    { dataField:"payItmRefDt" ,headerText:"<spring:message code='pay.head.refDate'/>" ,editable : false , dataType : "date", formatString : "dd-mm-yyyy"},
    { dataField:"payItmAppvNo" ,headerText:"<spring:message code='pay.head.apprNo'/>" ,editable : false },
    { dataField:"payItmRem" ,headerText:"<spring:message code='pay.head.remark'/>" ,editable : false },
    { dataField:"c4" ,headerText:"<spring:message code='pay.head.eft'/>" ,editable : false },
    { dataField:"payItmRem" ,headerText:"<spring:message code='pay.head.runningNo'/>" ,editable : false },
    { dataField:"payItmBankChrgAmt" ,headerText:"<spring:message code='pay.head.bankCharge'/>" ,editable : false },
    { dataField:"payItmId" ,headerText:"<spring:message code='pay.head.payItemId'/>" ,editable : false, visible:false }
    ];

var popColumnLayout = [    
     { dataField:"history" ,
         width: 30,
         headerText:" ", 
         renderer : {
             type : "IconRenderer",
             iconTableRef :  {
                 "default" : "${pageContext.request.contextPath}/resources/images/common/search.png"// default
             },         
             iconWidth : 16,
             iconHeight : 16,
             onclick : function(rowIndex, columnIndex, value, item) {
                 showDetailHistory(item.payItmId);
                 
             } 
          }
     }, 
     { dataField:"payId" ,headerText:"TEST",editable : false , visible : false },
     { dataField:"codeName" ,headerText:"<spring:message code='pay.head.mode'/>",editable : false},
     { dataField:"payItmRefNo" ,headerText:"<spring:message code='pay.head.refNo'/>",editable : false },
     { dataField:"c7" ,headerText:"<spring:message code='pay.head.cardType'/>",editable : false },
     /* { dataField:"codeName1" ,headerText:"<spring:message code='pay.head.CCType'/>" ,editable : false },
     { dataField:"codeName1" ,headerText:"<spring:message code='pay.head.CCType'/>" ,editable : false }, */
     { dataField:"payItmCcHolderName" ,headerText:"<spring:message code='pay.head.CCHolder'/>" ,editable : false },
     { dataField:"payItmCcExprDt" ,headerText:"<spring:message code='pay.head.CCExpiryDate'/>" ,editable : false , dataType : "date", formatString : "dd-mm-yyyy"},
     { dataField:"payItmCcNo" ,headerText:"<spring:message code='pay.head.CRCNo'/>" ,editable : false },
     { dataField:"payItmChqNo" ,headerText:"<spring:message code='pay.head.chequeNo'/>" ,editable : false },
     { dataField:"name" ,headerText:"<spring:message code='pay.head.issueBank'/>" ,editable : false },                   
     { dataField:"payItmAmt" ,headerText:"<spring:message code='pay.head.amount'/>" ,editable : false },
     { dataField:"c8" ,headerText:"<spring:message code='pay.head.CRCMode'/>" ,editable : false },
     { dataField:"accDesc" ,headerText:"<spring:message code='pay.head.bankAccount'/>" ,editable : false },
     { dataField:"payItmRefDt" ,headerText:"<spring:message code='pay.head.refDate'/>" ,editable : false , dataType : "date", formatString : "dd-mm-yyyy"},
     { dataField:"payItmAppvNo" ,headerText:"<spring:message code='pay.head.apprNo'/>" ,editable : false },
     { dataField:"payItmRem" ,headerText:"<spring:message code='pay.head.remark'/>" ,editable : false },
     { dataField:"c4" ,headerText:"<spring:message code='pay.head.eft'/>" ,editable : false },
     { dataField:"payItmRem" ,headerText:"<spring:message code='pay.head.runningNo'/>" ,editable : false },
     { dataField:"payItmBankChrgAmt" ,headerText:"<spring:message code='pay.head.bankCharge'/>" ,editable : false },
     { dataField:"payItmId" ,headerText:"<spring:message code='pay.head.payItemId'/>" ,editable : false, visible:false }
     ];
     
var popSlaveColumnLayout = [ 
    { dataField:"trxId" ,headerText:"<spring:message code='pay.head.trxNo'/>",editable : false},
    { dataField:"trxDt" ,headerText:"<spring:message code='pay.head.trxDate'/>",editable : false  },
    { dataField:"trxAmt" ,headerText:"<spring:message code='pay.head.trxTotal'/>",editable : false },
    { dataField:"payId" ,headerText:"<spring:message code='pay.head.PID'/>",editable : false },
    { dataField:"orNo" ,headerText:"<spring:message code='pay.head.ORNo'/>" ,editable : false },
    { dataField:"trNo" ,headerText:"<spring:message code='pay.head.TRNo'/>" ,editable : false },
    { dataField:"orAmt" ,headerText:"<spring:message code='pay.head.ORTotal'/>" ,editable : false },
    { dataField:"salesOrdNo" ,headerText:"<spring:message code='pay.head.orderNo'/>" ,editable : false },
    { dataField:"appTypeName" ,headerText:"<spring:message code='pay.head.appType'/>" ,editable : false },
    { dataField:"productDesc" ,headerText:"<spring:message code='pay.head.product'/>" ,editable : false },
    { dataField:"custName" ,headerText:"<spring:message code='pay.head.customer'/>" ,editable : false },                   
    { dataField:"custIc" ,headerText:"<spring:message code='pay.head.ICCONo'/>" ,editable : false },
    { dataField:"keyinBrnchName" ,headerText:"<spring:message code='pay.head.branch'/>" ,editable : false },
    { dataField:"keyinUserName" ,headerText:"<spring:message code='pay.head.userName'/>" ,editable : false }
    ];

var viewHistoryLayout=[
    { dataField:"typename" ,headerText:"<spring:message code='pay.head.type'/>" ,editable : false },
    { dataField:"valuefr" ,headerText:"<spring:message code='pay.head.from'/>" ,editable : false },
    { dataField:"valueto" ,headerText:"<spring:message code='pay.head.to'/>" ,editable : false },
    { dataField:"createdate" ,headerText:"<spring:message code='pay.head.updateDate'/>" ,editable : false, formatString : "dd-mm-yyyy" },
    { dataField:"creator" ,headerText:"<spring:message code='pay.head.updator'/>" ,editable : false }
    ];



// 마스터 그리드 리스트 조회.
function fn_getOrderListAjax(goPage) {
	
	//페이징 변수 세팅
    $("#pageNo").val(goPage);   
	
	AUIGrid.destroy(subGridID);//subGrid 초기화
    Common.ajax("GET", "/payment/selectOrderList", $("#searchForm").serialize(), function(result) {
        AUIGrid.setGridData(myGridID, result.resultList);
        
        //전체건수 세팅
        _totalRowCount = result.totalRowCount;
        
        //페이징 처리를 위한 옵션 설정
        var pagingPros = {
                // 1페이지에서 보여줄 행의 수
                rowCount : $("#rowCount").val()
        };
        
        GridCommon.createPagingNavigator(goPage, _totalRowCount , pagingPros);
        
    });
}


//마스터 그리드 페이지 이동
function moveToPage(goPage){
  //페이징 변수 세팅
  $("#pageNo").val(goPage);
  
  Common.ajax("GET", "/payment/selectOrderListPaging.do", $("#searchForm").serialize(), function(result) {        
      AUIGrid.setGridData(myGridID, result.resultList);
      
      //페이징 처리를 위한 옵션 설정
      var pagingPros = {
              // 1페이지에서 보여줄 행의 수
              rowCount : $("#rowCount").val()
      };
      
      GridCommon.createPagingNavigator(goPage, _totalRowCount , pagingPros);        
  });    
}

//상세 그리드 (Payment) 리스트 조회.
function fn_getPaymentListAjax() {        
    Common.ajax("GET", "/payment/selectPaymentList", $("#detailForm").serialize(), function(result) {
        AUIGrid.setGridData(subGridID, result);
    });
}



function fn_openDivPop(val){
	
	if(val == "VIEW"){
		if(selectedGridValue !=  undefined){
	        
	        Common.ajax("GET", "/payment/selectPaymentDetailViewer.do", $("#detailForm").serialize(), function(result) {
	        	$("#popup_wrap").show();
	        	popGridID = GridCommon.createAUIGrid("popList_wrap", popColumnLayout, null, gridPros_popList);
	            popSlaveGridID = GridCommon.createAUIGrid("popSlaveList_wrap", popSlaveColumnLayout, null, gridPros_popList);
	            
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
	            Common.alert("<spring:message code='pay.alert.invalidItem'/>");

	        });
	        
	   }else{
	       $("#popup_wrap").hide();
	       Common.alert("<spring:message code='pay.alert.searchFirst'/>");
	       return;
	   }
		
	}else if(val == "EDIT"){
		if(selectedGridValue !=  undefined){
            
            Common.ajax("GET", "/payment/selectPaymentDetailViewer.do", $("#detailForm").serialize(), function(result) {
            	$("#popup_wrap2").show();
            	editPopGridID = GridCommon.createAUIGrid("editPopList_wrap", popEditColumnLayout, null, gridPros_popList);
            	
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
                }else{
                	$("#edit_txtTRIssueDate").val("");
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
                
                $('#edit_branchId').val(result.viewMaster.clctrBrnchId);
                $('#edit_txtCollectorCode').val(result.viewMaster.clctrCode);
                $('#edit_txtClctrName').text(result.viewMaster.clctrName);
                $('#edit_txtCollectorId').val(result.viewMaster.clctrId);
                
                if(result.viewMaster.allowComm != "1"){
                	$("#btnAllowComm").prop('checked', false);
                	
                }else{
                	$("#btnAllowComm").prop('checked', true);
                }
                
                if(result.passReconSize  > 0 ){
                	$("#edit_branchId").prop('disabled', true);
                	reconLock = 1;
                	$("#edit_branchId").css("backgroundColor","transparent");
               	
                }else{
                	$("#edit_branchId").prop('disabled', false);
                	$("#edit_branchId").css("backgroundColor","#F5F6CE");
                }
                 
                //팝업그리드 뿌리기
                AUIGrid.setGridData(editPopGridID, result.selectPaymentDetailView);
            },function(jqXHR, textStatus, errorThrown) {
            	Common.alert("<spring:message code='pay.alert.failedUpdate'/>");

            });
            
       }else{
           $("#popup_wrap2").hide();
           Common.alert("<spring:message code='pay.alert.searchFirst'/>");
           return;
       }
    }
	
}

//popup 크기
var winPopOption = {
        width : "1200px",   // 창 가로 크기
        height : "850px"    // 창 세로 크기
};

// Fund Transfer / Refund 팝업
function fn_openWinPop(val){
	if(val == "FUNDTRANS"){
		if(selectedGridValue !=  undefined){
			
			var payId = AUIGrid.getCellValue(myGridID, selectedGridValue, "payId");
			var payTypeId = AUIGrid.getCellValue(myGridID, selectedGridValue, "payTypeId");
			var payTypeName = AUIGrid.getCellValue(myGridID, selectedGridValue, "payTypeName");
			var payDt = AUIGrid.getCellValue(myGridID, selectedGridValue, "payDt");
			
			//allow Fund Transfer
			// CC Easy Payment : 95
			// Deposit Payment : 100
			// Reverse & Refund & Fund Transfer : 101
			// Elite HP Tranining Fees : 102
			// Advanced AS : 103
			// Trial Order Registration Fees : 104
			// HP Business Starter Kit : 224
			// Reverse HP Business Starter Kit : 225
			// HP Business Renewal Kit :226
			// 1 Year Premium SVM : 228
			// 2 Years Regular SVM : 229
			// 2 Years Premium SVM : 230
			// 1 Year Regular SVM : 231
			// Reverse 1 Year Premium SVM : 232
			// Reverse 2 Years Regular SVM : 233
			// Reverse 2 Years Premium SVM : 234
			// Revrse 1 Year Regular SVM : 235
			// POS : 577
			// Fund Transfer : 1141
			var payTypeIdArray = [95,100,101,102,103,104,224,225,226,228,229,230,231,232,233,234,235,577,1141];
			
			if(payTypeIdArray.indexOf(payTypeId) > -1){
                Common.alert("<b>Payment Type : " + payTypeName + "<br />Fund transfer is disallowed for this payment.</b>");
                return;
            }else{
            	var cutOffDate = new Date("01/01/2016");
            	var paymentDate = new Date(payDt);
            	
                if((cutOffDate.getTime() > paymentDate.getTime())){
            		Common.alert("<b>Payment date : " + payDt + "<br />" +
                            "Cut off date : 01/01/2014<br />" +
                            "Fund transfer is disallowed for this payment.</b>");
                    return;
            	}else{            		
            		$("#popPayId").val(payId);
                    Common.popupWin("trnsferForm", "/payment/initFundTransferPop.do", winPopOption);
                    

            	}
            }
		}else{
			Common.alert("<spring:message code='pay.alert.noPay'/>");
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
    
    //EDIT POPUP RESET
    $('#edit_txtORNo').text('');
    $('#edit_txtLastUpdator').text('');
    $('#edit_txtKeyInUser').text('');
    $('#edit_txtOrderNo').text('');
    $('#edit_txtTRRefNo').val('');
    $("#edit_txtTRIssueDate").val('');
    $('#edit_txtProductCategory').text('');
    $('#edit_txtProductName').text('');
    $('#edit_txtAppType').text('');
    $('#edit_txtCustomerName').text('');
    $('#edit_txtCustomerType').text('');
    $('#edit_txtCustomerID').text('');
    $('#edit_txtOrderProgressStatus').text('');
    $('#edit_txtInstallNo').text('');
    $('#edit_txtNRIC').text('');
    $('#edit_txtPayType').text('');
    $('#edit_txtAdvMth').text('');
    $('#edit_txtPayDate').text('');
    $('#edit_txtHPCode').text('');
    $('#edit_txtHPName').text('');
    $('#edit_txtBatchPaymentID').text('');
    $('#edit_txtSalesPerson').text('');
    $('#edit_txtBranch').text('');
    $('#edit_txtDebtor').text('');
    $('#edit_branchId').val('');
    $('#edit_txtCollectorCode').val('');
    $('#edit_txtClctrName').text('');
    $('#edit_txtCollectorId').val('');
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
	
	var defaultDate = new Date("01-01-1900");    
	 Common.ajax("GET", "/payment/selectPaymentItem", {"payItemId" : payItemId}, function(result) {

		 if(reconLock == 1){
			 $("#txtRunNoCa").attr("readonly", true);
			 $("#txtRunNoCh").attr("readonly", true);
			 $("#txtRunningNoCC").attr("readonly", true);
			 $("#txtRunNoOn").attr("readonly", true);
		 }
		 
		 var payMode = result[0].payItmModeId;
		 if(payMode == 105){ //cash
			 $("#item_edit_cash").show();
			 $("#payItemId").val(payItemId);		
			 
			 $("#paymentCa").text(result[0].codeName);
	         $("#amountCa").text(result[0].payItmAmt);
	         $("#bankAccCa").text(result[0].accId + result[0].accDesc);
	         $("#txtReferenceNoCa").val(result[0].payItmRefNo);
	         var refDate = new Date(result[0].payItmRefDt)
	         if((refDate.getTime() > defaultDate.getTime()))
	        	 $("#txtRefDateCa").val(refDate.getDate() + "/" + (refDate.getMonth()+1) + "/" + refDate.getFullYear());
	         $("#txtRunNoCa").val(result[0].payItmRunngNo);
	         $("#tareaRemarkCa").val(result[0].payItmRem);
		 }else if(payMode == 106){//cheque
			 $("#item_edit_cheque").show();
		 
			 $("#payItemIdCh").val(payItemId);  
			 
			 $("#paymentCh").text(result[0].codeName);
			 $("#amountCh").text(result[0].payItmAmt);
			 $("#bankAccCh").text(result[0].accId + result[0].accDesc);
			 
			 $("#sIssuedBankCh").val(result[0].payItmIssuBankId);
			 $("#chequeNumberCh").text(result[0].payItmChqNo);
			 $("#chequeNoCh").val(result[0].payItmChqNo);//parameter
			 $("#txtRefNumberCh").val(result[0].payItmRefNo);
			 var refDate = new Date(result[0].payItmRefDt);
			 if((refDate.getTime() > defaultDate.getTime())){
				 $("#txtRefDateCh").val(refDate.getDate() + "/" + (refDate.getMonth()+1) + "/" + refDate.getFullYear());
			}
			 $("#txtRunNoCh").val(result[0].payItmRunngNo);
			 $("#tareaRemarkCh").val(result[0].payItmRem);
		}else if(payMode == 107){//creditcard
			  $("#payItemIdCC").val(payItemId);
		
			  $("#item_edit_credit").show();
			  
			  $("#paymentCC").text(result[0].codeName);
			  $("#amountCC").text(result[0].payItmAmt);
	          $("#bankAccCC").text(result[0].accId + result[0].accDesc);
	          
	          $("#cmbIssuedBankCC").val(result[0].payItmIssuBankId);
	          $("#CCNo").text(result[0].payItmOriCcNo);
	          $("#txtCrcNo").val(result[0].payItmOriCcNo);
	          $("#txtCCHolderName").val(result[0].payItmCcHolderName);
	          
	          var exDt =  result[0].payItmCcExprDt;
	          var exMonth = 0;
	          var exYear = 0;
	          var exDate = new Date();
	          if(exDt != undefined){
	        	  var expiryDate = exDt.split('/');
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
	            
	              if((exDate > defaultDate))
	                  $("#txtCCExpiry").val("01" + "/" + (exMonthStr) + "/" + exDate.getFullYear());
	              else
	                  $("#txtCCExpiry").val("");
	          }
	          
	          if(result[0].payItmCardTypeId > 0)
	        	  $("#cmbCardTypeCC").val(result[0].payItmCardTypeId).prop("selected", true);
	          
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
	          $("#txtRunningNoCC").val(result[0].payItmRunngNo);
	          $("#tareaRemarkCC").val(result[0].payItmRem);
		 }else if(payMode == 108){//online
			 $("#item_edit_online").show();
		 
			 $("#payItemIdOn").val(payItemId);
			 
             $("#paymentOn").text(result[0].codeName);
             $("#amountOn").text(result[0].payItmAmt);
             $("#bankAccOn").text(result[0].accId + result[0].accDesc);
             
             $("#cmbIssuedBankOn").val(result[0].payItmIssuBankId);
             $("#txtRefNoOn").val(result[0].payItmRefNo);
             
             var refDate = new Date(result[0].payItmRefDt);
             if((refDate.getTime() > defaultDate.getTime())){
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
		console.log("chequeNoCh : " + $("#chequeNoCh").val());
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
        Common.alert("<spring:message code='pay.alert.trNo'/>");
        return;
    }
	
	if($.trim(branchId ) == ""){
		Common.alert("<spring:message code='pay.alert.selectBranch'/>");
		return;
	}
	
	$("#hiddenPayId").val(payId);
	Common.ajax("POST", "/payment/saveChanges", $('#myForm').serializeJSON(), function(result) {
        Common.alert(result.message);

	}, function(jqXHR, textStatus, errorThrown) {
        Common.alert("<spring:message code='pay.alert.failedUpdate'/>");
    });
}

function fn_officialReceiptReport(){
    var selectedItem = AUIGrid.getSelectedIndex(myGridID);
    
    if (selectedItem[0] > -1){    
        var orNo = AUIGrid.getCellValue(myGridID, selectedGridValue, "orNo");        
        $("#reportPDFForm #v_ORNo").val(orNo);        
        Common.report("reportPDFForm");
        
    }else{
        Common.alert("<spring:message code='pay.alert.noPay'/>");
   }
}

function  fn_goSalesPerson(){
    Common.popupDiv("/sales/membership/paymentCollecter.do?resultFun=S");
} 

function fn_doSalesResult(item){
    
    if (typeof (item) != "undefined"){
            
           $("#edit_txtCollectorCode").val(item.memCode);
           $("#edit_txtClctrName").html(item.name);
           $("#edit_txtCollectorId").val(item.memId);
           $("#sale_confirmbt").attr("style" ,"display:none");
           $("#sale_searchbt").attr("style" ,"display:none");
           $("#sale_resetbt").attr("style" ,"display:inline");
           $("#edit_txtCollectorCode").attr("class","readonly");
           
    }else{
           $("#edit_txtCollectorCode").val("");
           $("#edit_txtClctrName").html("");
           $("#edit_txtCollectorCode").attr("class","");
    }
}

function fn_goSalesPersonReset(){

    $("#sale_confirmbt").attr("style" ,"display:inline");
    $("#sale_searchbt").attr("style" ,"display:inline");
    $("#sale_resetbt").attr("style" ,"display:none");
    $("#edit_txtCollectorCode").attr("class","");
    $("#txtClctrName").html("");
    $("#edit_txtCollectorId").val("");
}

function fn_goSalesConfirm(){
    
    if($("#edit_txtCollectorCode").val() =="") {
             
             Common.alert("<spring:message code='pay.alert.salesPersonCode'/>");
             return ;
     }
         
         
     Common.ajax("GET", "/sales/membership/paymentColleConfirm", { COLL_MEM_CODE:   $("#edit_txtCollectorCode").val() } , function(result) {
              console.log( result);
              
              if(result.length > 0){
                  
                  $("#edit_txtCollectorCode").val(result[0].memCode);
                  $("#edit_txtClctrName").html(result[0].name);
                  $("#edit_txtCollectorId").val(result[0].memId);
                  
                  
                  $("#sale_confirmbt").attr("style" ,"display:none");
                  $("#sale_searchbt").attr("style" ,"display:none");
                  $("#sale_resetbt").attr("style" ,"display:inline");
                  $("#edit_txtClctrName").attr("class","readonly");
                  
              }else {
                  
                  $("#edit_txtClctrName").html("");
                  Common.alert(" Unable to find [" +$("#edit_txtCollectorCode").val() +"] in system. <br>  Please ensure you key in the correct member code.   ");
                  return ;
              }
              
      });
}

function fn_clear(){
    $("#searchForm")[0].reset();
}
</script>

<!-- content start -->
<section id="content">
    <ul class="path">
        <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    </ul>

    <!-- title_line start -->
    <aside class="title_line">
        <p class="fav"><a href="#" class="click_add_on"><spring:message code='pay.text.myMenu'/></a></p>
        <h2>Search Payment</h2>
        <ul class="right_btns">
            <c:if test="${PAGE_AUTH.funcPrint == 'Y'}">
            <li><p class="btn_blue"><a href="javascript:fn_officialReceiptReport();"><spring:message code='pay.btn.officialReceipt'/></a></p></li>
            </c:if>      
            <c:if test="${PAGE_AUTH.funcView == 'Y'}">      
            <li><p class="btn_blue"><a href="javascript:fn_getOrderListAjax(1);"><span class="search"></span><spring:message code='sys.btn.search'/></a></p></li>
            </c:if>
            <li><p class="btn_blue"><a href="javascript:fn_clear();"><span class="clear"></span><spring:message code='sys.btn.clear'/></a></p></li>
        </ul>
    </aside>
    <!-- title_line end -->

    <!-- search_table start -->
    <section class="search_table">
        <form name="searchForm" id="searchForm"  method="post">
            <input type="hidden" name="rowCount" id="rowCount" value="20" />
            <input type="hidden" name="pageNo" id="pageNo" />
            
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
                <p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
                <dl class="link_list">
                    <dt>Link</dt>
                    <dd>
                    <ul class="btns">
                        <c:if test="${PAGE_AUTH.funcView == 'Y'}">
                        <li><p class="link_btn"><a href="javascript:fn_openDivPop('VIEW');"><spring:message code='pay.btn.link.viewDetails'/></a></p></li>
                        </c:if>
                        <c:if test="${PAGE_AUTH.funcChange == 'Y'}">
                        <li><p class="link_btn"><a href="javascript:fn_openDivPop('EDIT');"><spring:message code='pay.btn.link.editDetails'/></a></p></li>
                        </c:if>
                        <!-- <li><p class="link_btn"><a href="javascript:fn_openWinPop('FUNDTRANS');">Fund Transfer</a></p></li>  -->                                                                      
                    </ul>
                    <!-- 
                    <ul class="btns">
                        <li><p class="link_btn type2"><a href="#">Fund Transfer</a></p></li>                        
                        <li><p class="link_btn type2"><a href="#">Refund</a></p></li>         
                    </ul>
                     -->
                    <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
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
        <div id="grid_paging" class="aui-grid-paging-panel my-grid-paging-panel"></div>
        <!-- grid_wrap end -->
        
        <!-- grid_wrap start -->
        <article id="grid_sub_wrap" class="grid_wrap mt10"></article>
        <!-- grid_wrap end -->
    </section>
    <!-- search_result end -->

</section>

<div id="popup_wrap" class="popup_wrap" style="display:none;">
	<!-- popup_wrap start -->
	<header class="pop_header"><!-- pop_header start -->
		<h1><spring:message code='pay.title.viewPayDets'/></h1>
		<ul class="right_opt">
		    <li><p class="btn_blue2"><a href="#" onclick="fn_close();"><spring:message code='sys.btn.close'/></a></p></li>
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
	        <li><p class="btn_blue2"><a href="javascript:showViewHistory()"><spring:message code='pay.btn.viewHistory'/></a></p></li>
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
	<h1><spring:message code='pay.title.payEditor'/></h1>
	<ul class="right_opt">
	    <li><p class="btn_blue2"><a href="#" onclick="fn_close2();"><spring:message code='sys.btn.close'/></a></p></li>
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
	                        <td id="">
	                            <input type="text" name="edit_txtCollectorCode" id="edit_txtCollectorCode" style="width:100px">
	                            <p class="btn_sky"  id="sale_confirmbt" ><a href="#" onclick="javascript:fn_goSalesConfirm()"><spring:message code='pay.btn.confirm'/></a></p>    
	                            <p class="btn_sky"  id="sale_searchbt"><a href="#" onclick="javascript:fn_goSalesPerson()" ><spring:message code='sys.btn.search'/></a></p>  
	                            <p class="btn_sky"  id="sale_resetbt" style="display:none"><a href="#" onclick="javascript:fn_goSalesPersonReset()" ><spring:message code='pay.btn.reset'/></a></p>
	                         </td>
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
	        <li><p class="btn_blue2"><a href="javascript:saveChanges()"><spring:message code='pay.btn.update'/></a></p></li>
	        <li><p class="btn_blue2"><a href="javascript:showViewHistory()"><spring:message code='pay.btn.viewHistory'/></a></p></li>
	    </ul>
	    <section class="search_result"><!-- search_result start -->
	        <article class="grid_wrap"  id="editPopList_wrap" style="width  : 100%;">
	        </article><!-- grid_wrap end -->
	    </section><!-- search_result end -->
	</section><!-- pop_body end -->
	<input type="hidden" name="hiddenPayId" id="hiddenPayId">
	<input type="hidden" name="allowComm" id="allowComm">
	<input type="hidden" name="edit_txtCollectorId"  id="edit_txtCollectorId"/> 
	</form>
</div><!-- popup_wrap end -->
<div id="view_history_wrap" class="popup_wrap size_small" style="display:none;">
    <header class="pop_header">
        <h1><spring:message code='pay.title.payMasHis'/></h1>
        <ul class="right_opt">
            <li><p class="btn_blue2"><a href="#" onclick="hideViewPopup()"><spring:message code='sys.btn.close'/></a></p></li>
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
        <h1><spring:message code='pay.title.payDetsHis'/></h1>
        <ul class="right_opt">
            <li><p class="btn_blue2"><a href="#" onclick="hideDetailPopup()"><spring:message code='sys.btn.close'/></a></p></li>
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
        <h1><spring:message code='pay.title.payItmEdit'/></h1>
        <ul class="right_opt">
            <li><p class="btn_blue2"><a href="#" onclick="hideDetailPopup()"><spring:message code='sys.btn.close'/></a></p></li>
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
	               <li><p class="btn_blue2"><a href="#" onclick="saveCash()"><spring:message code='sys.btn.save'/></a></p></li>
	             </ul>
             </td>
        </tr>
        </tbody>
    </table>
    <input type="hidden" id="payItemId" name="payItemId"/>    
    </form>
    </section>
    <!-- pop_body end -->
</div>
<!-- content end -->

<div id="item_edit_credit" class="popup_wrap size_small" style="display:none;">
    <header class="pop_header">
        <h1><spring:message code='pay.title.payItmEdit'/></h1>
        <ul class="right_opt">
            <li><p class="btn_blue2"><a href="#" onclick="hideDetailPopup()"><spring:message code='sys.btn.close'/></a></p></li>
        </ul>
    </header>
    <!-- pop_body start -->
    <section class="pop_body">
    <form id="creditCardForm" name="creditCardForm">
    <input type="hidden" id="payItemIdCC" name="payItemIdCC"/>
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
                   <li><p class="btn_blue2"><a href="#" onclick="saveCreditCard()"><spring:message code='sys.btn.save'/></a></p></li>
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
        <h1><spring:message code='pay.title.payItmEdit'/></h1>
        <ul class="right_opt">
            <li><p class="btn_blue2"><a href="#" onclick="hideDetailPopup()"><spring:message code='sys.btn.close'/></a></p></li>
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
                <p><input type="text" name="txtRunNoCh" id="txtRunNoCh" placeholder="runningNo"/></p>
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
                   <li><p class="btn_blue2"><a href="#" onclick="saveCheque()"><spring:message code='sys.btn.save'/></a></p></li>
                 </ul>
             </td>
        </tr>
        </tbody>
    </table>
    <input type="hidden" id="payItemIdCh" name="payItemIdCh"/>
    <input type="hidden" id="chequeNoCh" name="chequeNoCh" />
    </form>
    </section>
    <!-- pop_body end -->
</div>
<!-- content end -->
<div id="item_edit_online" class="popup_wrap size_small" style="display:none;">
    <header class="pop_header">
        <h1><spring:message code='pay.title.payItmEdit'/></h1>
        <ul class="right_opt">
            <li><p class="btn_blue2"><a href="#" onclick="hideDetailPopup()"><spring:message code='sys.btn.close'/></a></p></li>
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
                <p><input type="text" name="txtRunNoOn" id="txtRunNoOn" placeholder="runningNo"/></p>
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
                   <li><p class="btn_blue2"><a href="#" onclick="saveOnline()"><spring:message code='sys.btn.save'/></a></p></li>
                 </ul>
             </td>
        </tr>
        </tbody>
    </table>
    <input type="hidden" id="payItemIdOn" name="payItemIdOn"/>    
    </form>
    </section>
    <!-- pop_body end -->
</div>
<!-- content end -->
<form name="reportPDFForm" id="reportPDFForm"  method="post">
    <input type="hidden" id="reportFileName" name="reportFileName" value="/payment/PaymentReceipt_New.rpt" />
    <input type="hidden" id="viewType" name="viewType" value="PDF" />
    <input type="hidden" id="v_ORNo" name="v_ORNo" />
</form>

<form name="trnsferForm" id="trnsferForm"  method="post">    
    <input type="hidden" id="popPayId" name="popPayId" />
</form>

