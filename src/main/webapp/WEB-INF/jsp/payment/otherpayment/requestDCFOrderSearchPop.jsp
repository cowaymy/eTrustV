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

//targetFinalBillGridID Grid에서 선택된 RowID
var selectedGridValue = -1;

var targetRenMstGridID;
var targetRenDetGridID;
var targetOutMstGridID;
var targetSrvcMstGridID;
var targetSrvcDetGridID;
var targetBillMstGridID;
var targetOutSrvcMstGridID;
var targetFinalBillGridID;
var targetCareSrvcMstGridID;


//AUIGrid 칼럼 설정 : targetRenMstGridID
var targetRenMstColumnLayout = [

    { dataField:"custBillId" ,headerText:"<spring:message code='pay.head.billingGroup'/>" ,editable : false , width : 100},
    { dataField:"salesOrdId" ,headerText:"<spring:message code='pay.head.orderId'/>" ,editable : false , width : 100, visible : false },
    { dataField:"salesOrdNo" ,headerText:"<spring:message code='pay.head.orderNo'/>" ,editable : false , width : 100 },
    { dataField:"rpf" ,headerText:"<spring:message code='pay.head.rpf'/>" ,editable : false , width : 100 , dataType : "numeric", formatString : "#,##0.00"},
    { dataField:"rpfPaid" ,headerText:"<spring:message code='pay.head.rpfPaid'/>" ,editable : false , width : 100 , dataType : "numeric", formatString : "#,##0.00"},
    { dataField:"mthRentAmt" ,headerText:"<spring:message code='pay.head.monthlyRf'/>" ,editable : false , width : 100 , dataType : "numeric", formatString : "#,##0.00"},
    { dataField:"balance" ,headerText:"<spring:message code='pay.head.balance'/>" ,editable : false , width : 100 , dataType : "numeric", formatString : "#,##0.00"},
    { dataField:"unBilledAmount" ,headerText:"<spring:message code='pay.head.unbill'/>" ,editable : false , width : 100 , dataType : "numeric", formatString : "#,##0.00"},
    { dataField:"lastPayment" ,headerText:"<spring:message code='pay.head.lastPayment'/>" ,editable : false , width : 120 , dataType : "date", formatString : "yyyy-mm-dd", visible : false },
    { dataField:"custNm" ,headerText:"<spring:message code='pay.head.customerName'/>" ,editable : false , width : 250 ,visible : false },
    {
        dataField : "btnCheck",
        headerText : "<spring:message code='pay.head.include'/>",
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
    { dataField:"billGrpId" ,headerText:"<spring:message code='pay.head.billGroupId'/>" ,editable : false , width : 120, visible : false },
    { dataField:"billTypeId" ,headerText:"<spring:message code='pay.head.billTypeId'/>" ,editable : false , width : 120, visible : false },
    { dataField:"stusCode" ,headerText:"<spring:message code='pay.head.stusCode'/>" ,editable : false , width : 120, visible : false },
    { dataField:"custNm" ,headerText:"<spring:message code='pay.head.custNm'/>" ,editable : false , width : 120, visible : false },

    { dataField:"billId" ,headerText:"<spring:message code='pay.head.billId'/>" ,editable : false , width : 100, visible : false },
    { dataField:"billNo" ,headerText:"<spring:message code='pay.head.billNo'/>" ,editable : false , width : 150 },
    { dataField:"ordId" ,headerText:"<spring:message code='pay.head.orderId'/>" ,editable : false , width : 100 , visible : false },
    { dataField:"ordNo" ,headerText:"<spring:message code='pay.head.orderNo'/>" ,editable : false , width : 100 },
    { dataField:"billTypeNm" ,headerText:"<spring:message code='pay.head.billType'/>" ,editable : false , width : 180 },
    { dataField:"installment" ,headerText:"<spring:message code='pay.head.installment'/>" ,editable : false , width : 100 },
    { dataField:"billAmt" ,headerText:"<spring:message code='pay.head.amount'/>" ,editable : false , width : 100 , dataType : "numeric", formatString : "#,##0.00"},
    { dataField:"paidAmt" ,headerText:"<spring:message code='pay.head.paid'/>" ,editable : false , width : 100 , dataType : "numeric", formatString : "#,##0.00"},
    { dataField:"targetAmt" ,headerText:"<spring:message code='pay.head.targetAmount'/>" ,editable : false , width : 100 , dataType : "numeric", formatString : "#,##0.00"},
    { dataField:"billDt" ,headerText:"<spring:message code='pay.head.billDate'/>" ,editable : false , width : 100},
    { dataField:"stusCodeName" ,headerText:"<spring:message code='pay.head.billStatus'/>" ,editable : false , width : 100},
    {
        dataField : "btnCheck",
        headerText : "<spring:message code='pay.head.include'/>",
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
	{ dataField:"appTypeNm" ,headerText:"<spring:message code='pay.head.appTypeNm'/>" ,editable : false , width : 100, visible : false },
	{ dataField:"salesOrdId" ,headerText:"<spring:message code='pay.head.orderId'/>" ,editable : false , width : 100, visible : false },
	{ dataField:"salesOrdNo" ,headerText:"<spring:message code='pay.head.orderNumber'/>" ,editable : false , width : 120 },
	{ dataField:"custNm" ,headerText:"<spring:message code='pay.head.customerName'/>" ,editable : false , width : 180},
	{ dataField:"productPrice" ,headerText:"<spring:message code='pay.head.productPrice'/>" ,editable : false , width : 100 , dataType : "numeric", formatString : "#,##0.00"},
	{ dataField:"totalPaid" ,headerText:"<spring:message code='pay.head.paid'/>" ,editable : false , width : 100 , dataType : "numeric", formatString : "#,##0.00"},
	{ dataField:"balance" ,headerText:"<spring:message code='pay.head.balanceLongText'/>" ,editable : true , width : 200 , dataType : "numeric", formatString : "#,##0.00"},
	{ dataField:"reverseAmount" ,headerText:"<spring:message code='pay.head.reversed'/>" ,editable : false , width : 100, dataType : "numeric", formatString : "#,##0.00" },
	{ dataField:"lastPayment" ,headerText:"<spring:message code='pay.head.lastPayment'/>" ,editable : false , width : 120 , dataType : "date", formatString : "yyyy-mm-dd"},
	{ dataField:"userName" ,headerText:"<spring:message code='pay.head.creatorName'/>" ,editable : false , width : 200 }
];

//AUIGrid 칼럼 설정 : targetSrvcMstGridID
var targetSrvcMstColumnLayout = [
    { dataField:"srvCntrctId" ,headerText:"<spring:message code='pay.head.srvContractId'/>" ,editable : false , width : 100, visible : false },
	{ dataField:"salesOrdId" ,headerText:"<spring:message code='pay.head.salesOrderId'/>" ,editable : false , width : 100, visible : false },
	{ dataField:"salesOrdNo" ,headerText:"<spring:message code='pay.head.salesOrderNo'/>" ,editable : false , width : 100, visible : false },
    { dataField:"custBillId" ,headerText:"<spring:message code='pay.head.billingGroup'/>" ,editable : false , width : 100},
    { dataField:"srvCntrctRefNo" ,headerText:"<spring:message code='pay.head.refNo'/>" ,editable : false , width : 100},
    { dataField:"cntrctRentalStus" ,headerText:"<spring:message code='pay.head.rentalStatus'/>" ,editable : false , width : 100 },
    { dataField:"filterCharges" ,headerText:"<spring:message code='pay.head.filterCharges'/>" ,editable : false , width : 100 , dataType : "numeric", formatString : "#,##0.00"},
    { dataField:"filterChargesPaid" ,headerText:"<spring:message code='pay.head.filterPaid'/>" ,editable : false , width : 100 , dataType : "numeric", formatString : "#,##0.00"},
    { dataField:"penaltyCharges" ,headerText:"<spring:message code='pay.head.penaltyCharges'/>" ,editable : false , width : 100 , dataType : "numeric", formatString : "#,##0.00"},
    { dataField:"penaltyChargesPaid" ,headerText:"<spring:message code='pay.head.penaltyPaid'/>" ,editable : false , width : 100 , dataType : "numeric", formatString : "#,##0.00"},
    { dataField:"srvCntrctRental" ,headerText:"<spring:message code='pay.head.monthlyFees'/>" ,editable : false , width : 100 , dataType : "numeric", formatString : "#,##0.00"},
    { dataField:"balance" ,headerText:"<spring:message code='pay.head.balance'/>" ,editable : false , width : 120 , dataType : "numeric", formatString : "#,##0.00"},
    { dataField:"unBillAmount" ,headerText:"<spring:message code='pay.head.unbill'/>" ,editable : false , width : 120 , dataType : "numeric", formatString : "#,##0.00"},
    { dataField:"lastPayment" ,headerText:"<spring:message code='pay.head.lastPayment'/>" ,editable : false , width : 120 , dataType : "date", formatString : "yyyy-mm-dd"},
    { dataField:"custName" ,headerText:"<spring:message code='pay.head.customerName'/>" ,editable : false , width : 250 },
    {
	    dataField : "btnCheck",
	    headerText : "<spring:message code='pay.head.include'/>",
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
	{ dataField:"srvLdgrCntrctId" ,headerText:"<spring:message code='pay.head.srvLdgrCntrctId'/>" ,editable : false , width : 150  , visible : false },
	{ dataField:"srvLdgrRefNo" ,headerText:"<spring:message code='pay.head.billNo'/>" ,editable : false , width : 120},
	{ dataField:"srvCntrctRefNo" ,headerText:"<spring:message code='pay.head.scsNo'/>" ,editable : false , width : 100},
	{ dataField:"srvCntrctOrdId" ,headerText:"<spring:message code='pay.head.orderId'/>" ,editable : false , width : 150  , visible : false },
	{ dataField:"salesOrdNo" ,headerText:"<spring:message code='pay.head.orderNo'/>" ,editable : false , width : 100},
	{ dataField:"srvLdgrTypeId" ,headerText:"<spring:message code='pay.head.billTypeId'/>" ,editable : false , width : 100  , visible : false },
	{ dataField:"srvLdgrTypeNm" ,headerText:"<spring:message code='pay.head.billType'/>" ,editable : false , width : 180 },
	{ dataField:"srvPaySchdulNo" ,headerText:"<spring:message code='pay.head.scheduleNo'/>" ,editable : false , width : 100 },
	{ dataField:"srvLdgrAmt" ,headerText:"<spring:message code='pay.head.billNo'/>" ,editable : false , width : 100, dataType : "numeric", formatString : "#,##0.00" },
	{ dataField:"paidTotal" ,headerText:"<spring:message code='pay.head.paid'/>" ,editable : false , width : 100 , dataType : "numeric", formatString : "#,##0.00"},
	{ dataField:"targetAmt" ,headerText:"<spring:message code='pay.head.targetAmount'/>" ,editable : false , width : 100 , dataType : "numeric", formatString : "#,##0.00"},
	{ dataField:"srvLdgrRefDt" ,headerText:"<spring:message code='pay.head.billDate'/>" ,editable : false , width : 100},
	{
	    dataField : "btnCheck",
	    headerText : "<spring:message code='pay.head.include'/>",
	    width: 80,
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
	{ dataField:"appType" ,headerText:"<spring:message code='pay.head.appType'/>" ,editable : false , width : 150 , visible : false },
	{ dataField:"billSoId" ,headerText:"<spring:message code='pay.head.billSalesOrderId'/>" ,editable : false , width : 150 , visible : false },
	{ dataField:"salesOrdNo" ,headerText:"<spring:message code='pay.head.salesOrderNo'/>" ,editable : false , width : 150 , visible : false },
	{ dataField:"billAsId" ,headerText:"<spring:message code='pay.head.billAsId'/>" ,editable : false , width : 150 , visible : false },


	{ dataField:"billId" ,headerText:"<spring:message code='pay.head.billId'/>" ,editable : false , width : 120 },
	{ dataField:"billNo" ,headerText:"<spring:message code='pay.head.billNo'/>" ,editable : false , width : 100},
	{ dataField:"billTypeId" ,headerText:"<spring:message code='pay.head.billTypeId'/>" ,editable : false , width : 150 , visible : false },
	{ dataField:"billTypeNm" ,headerText:"<spring:message code='pay.head.billType'/>" ,editable : false , width : 100},
	{ dataField:"custNm" ,headerText:"<spring:message code='pay.head.custName'/>" ,editable : false , width : 250},
	{ dataField:"nric" ,headerText:"<spring:message code='pay.head.custNric'/>" ,editable : false , width : 120 , visible : false },
	{ dataField:"billMemNm" ,headerText:"<spring:message code='pay.head.hpName'/>" ,editable : false , width : 250 , visible : false },
	{ dataField:"billMemCode" ,headerText:"<spring:message code='pay.head.hpCode'/>" ,editable : false , width : 100 , visible : false },
	{ dataField:"ruleDesc" ,headerText:"<spring:message code='pay.head.payType'/>" ,editable : false , width : 200 },
	{ dataField:"billDt" ,headerText:"<spring:message code='pay.head.date'/>" ,editable : false , width : 100 },
	{ dataField:"billAmt" ,headerText:"<spring:message code='pay.head.amount'/>" ,editable : false , width : 100 , dataType : "numeric", formatString : "#,##0.00"},
	{ dataField:"paidAmt" ,headerText:"<spring:message code='pay.head.paidAmount'/>" ,editable : false , width : 100 , dataType : "numeric", formatString : "#,##0.00"},
	{ dataField:"billRem" ,headerText:"<spring:message code='pay.head.remark'/>" ,editable : false , width : 100 },
	{ dataField:"billIsPaid" ,headerText:"<spring:message code='pay.head.paid'/>" ,editable : false , width : 100 },
	{ dataField:"billIsComm" ,headerText:"<spring:message code='pay.head.commission'/>" ,editable : false , width : 100 },
	{ dataField:"stusNm" ,headerText:"<spring:message code='pay.head.status'/>" ,editable : false , width : 100 },
	{
	    dataField : "btnCheck",
	    headerText : "<spring:message code='pay.head.include'/>",
	    width: 80,
	    renderer : {
	        type : "CheckBoxEditRenderer",
	        editable : true, // 체크박스 편집 활성화 여부(기본값 : false)
	        checkValue : "1", // true, false 인 경우가 기본
	        unCheckValue : "0"
	    }
	}
];

//AUIGrid 칼럼 설정 : targetOutSrvcMstGridID
var targetOutSrvcMstColumnLayout = [
    { dataField:"quotId" ,headerText:"<spring:message code='pay.head.quotationId'/>" ,editable : false , width : 100, visible : false },
    { dataField:"cnvrMemId" ,headerText:"<spring:message code='pay.head.serviceMembershipId'/>" ,editable : false , width : 100, visible : false },
    { dataField:"ordId" ,headerText:"<spring:message code='pay.head.orderId'/>" ,editable : false , width : 100, visible : false },
    { dataField:"quotNo" ,headerText:"<spring:message code='pay.head.quotationNumber'/>" ,editable : false , width : 150},
    { dataField:"ordNo" ,headerText:"<spring:message code='pay.head.orderNumber'/>" ,editable : false , width : 150 },
    { dataField:"custName" ,headerText:"<spring:message code='pay.head.customerName'/>" ,editable : false , width : 250},
    { dataField:"totAmt" ,headerText:"<spring:message code='pay.head.totalAmount'/>" ,editable : false , width : 150 , dataType : "numeric", formatString : "#,##0.00"},
    { dataField:"packageCharge" ,headerText:"<spring:message code='pay.head.packageAmount'/>" ,editable : false , width : 150 , dataType : "numeric", formatString : "#,##0.00"},
    { dataField:"packagePaid" ,headerText:"<spring:message code='pay.head.packagePaid'/>" ,editable : false , width : 150 , dataType : "numeric", formatString : "#,##0.00"},
    { dataField:"filterCharge" ,headerText:"<spring:message code='pay.head.filterAmount'/>" ,editable : false , width : 150 , dataType : "numeric", formatString : "#,##0.00"},
    { dataField:"filterPaid" ,headerText:"<spring:message code='pay.head.filterPaid'/>" ,editable : false , width : 150 , dataType : "numeric", formatString : "#,##0.00"}
];

//AUIGrid 칼럼 설정 : targetCareSrvcMstGridID
var targetCareSrvcMstColumnLayout = [
	{ dataField:"quotId" ,headerText:"<spring:message code='pay.head.quotationId'/>" ,editable : false , width : 100, visible : false },
	{ dataField:"cnvrMemId" ,headerText:"<spring:message code='pay.head.serviceMembershipId'/>" ,editable : false , width : 100, visible : false },
	{ dataField:"srvOrdId" ,headerText:"<spring:message code='pay.head.orderId'/>" ,editable : false , width : 100, visible : false },
	{ dataField:"quotNo" ,headerText:"<spring:message code='pay.head.quotationNumber'/>" ,editable : false , width : 150, visible : false },
	{ dataField:"srvOrdNo" ,headerText:"<spring:message code='pay.head.orderNumber'/>" ,editable : false , width : 150 },
	{ dataField:"custNm" ,headerText:"<spring:message code='pay.head.customerName'/>" ,editable : false , width : 250},
	{ dataField:"appTypeNm" ,headerText:"Application Type" ,editable : false , width : 200},
	{ dataField:"totAmt" ,headerText:"<spring:message code='pay.head.totalAmount'/>" ,editable : false , width : 150 , dataType : "numeric", formatString : "#,##0.00"},
	{ dataField:"packageCharge" ,headerText:"<spring:message code='pay.head.packageAmount'/>" ,editable : false , width : 150 , dataType : "numeric", formatString : "#,##0.00"},
	{ dataField:"packagePaid" ,headerText:"<spring:message code='pay.head.packagePaid'/>" ,editable : false , width : 150 , dataType : "numeric", formatString : "#,##0.00"},
	{ dataField:"filterCharge" ,headerText:"<spring:message code='pay.head.filterAmount'/>" ,editable : false , width : 150 , dataType : "numeric", formatString : "#,##0.00"},
	{ dataField:"filterPaid" ,headerText:"<spring:message code='pay.head.filterPaid'/>" ,editable : false , width : 150 , dataType : "numeric", formatString : "#,##0.00"}
];

//AUIGrid 칼럼 설정 : targetFinalBillGridID
var targetFinalBillColumnLayout = [
    { dataField:"procSeq" ,headerText:"<spring:message code='pay.head.processSeq'/>" ,editable : false , width : 120 , visible : false },
    { dataField:"appType" ,headerText:"<spring:message code='pay.head.appType'/>" ,editable : false , width : 120 , visible : false },
    { dataField:"advMonth" ,headerText:"<spring:message code='pay.head.advanceMonth'/>" ,editable : false , width : 120 , dataType : "numeric", formatString : "#,##0.00" , visible : false },
    { dataField:"billGrpId" ,headerText:"<spring:message code='pay.head.billGroupId'/>" ,editable : false , width : 120},
    { dataField:"billId" ,headerText:"<spring:message code='pay.head.billId'/>" ,editable : false , width : 100, visible : false },
    { dataField:"ordId" ,headerText:"<spring:message code='pay.head.orderId'/>" ,editable : false , width : 100  , visible : false },
    { dataField:"mstRpf" ,headerText:"<spring:message code='pay.head.masterRpf'/>" ,editable : false , width : 100  , dataType : "numeric", formatString : "#,##0.00" , visible : false },
    { dataField:"mstRpfPaid" ,headerText:"<spring:message code='pay.head.masterRpfPaid'/>" ,editable : false , width : 100  , dataType : "numeric", formatString : "#,##0.00" , visible : false },
    { dataField:"billNo" ,headerText:"<spring:message code='pay.head.billNo'/>" ,editable : false , width : 150 },
    { dataField:"ordNo" ,headerText:"<spring:message code='pay.head.orderNo'/>" ,editable : false , width : 100 },
    { dataField:"billTypeId" ,headerText:"<spring:message code='pay.head.billTypeId'/>" ,editable : false , width : 100 , visible : false },
    { dataField:"billTypeNm" ,headerText:"<spring:message code='pay.head.billType'/>" ,editable : false , width : 180 },
    { dataField:"installment" ,headerText:"<spring:message code='pay.head.installment'/>" ,editable : false , width : 100 },
    { dataField:"billAmt" ,headerText:"<spring:message code='pay.head.amount'/>" ,editable : false , width : 100 , dataType : "numeric", formatString : "#,##0.00"},
    { dataField:"paidAmt" ,headerText:"<spring:message code='pay.head.paid'/>" ,editable : false , width : 100 , dataType : "numeric", formatString : "#,##0.00"},
    { dataField:"targetAmt" ,headerText:"<spring:message code='pay.head.targetAmount'/>" ,editable : true , width : 100 , dataType : "numeric", formatString : "#,##0.00"},
    { dataField:"billDt" ,headerText:"<spring:message code='pay.head.billDate'/>" ,editable : false , width : 100 },
    { dataField:"assignAmt" ,headerText:"<spring:message code='pay.head.assignAmt'/>" ,editable : false , width : 100 , dataType : "numeric", formatString : "#,##0.00" , visible : false },
    { dataField:"billStatus" ,headerText:"<spring:message code='pay.head.billStatus'/>" ,editable : false , width : 100 , visible : false },
    { dataField:"custNm" ,headerText:"<spring:message code='pay.head.custName'/>" ,editable : false , width : 300},
    { dataField:"srvcContractID" ,headerText:"<spring:message code='pay.head.srvcContractId'/>" ,editable : false , width : 100 , visible : false },
    { dataField:"billAsId" ,headerText:"<spring:message code='pay.head.billAsId'/>" ,editable : false , width : 150 , visible : false },
    { dataField:"discountAmt" ,headerText:"<spring:message code='pay.head.discountAmt'/>" ,editable : false , width : 100 , dataType : "numeric", formatString : "#,##0.00" , visible : false },
    { dataField:"srvMemId" ,headerText:"<spring:message code='pay.head.serviceMembershipId'/>" ,editable : false , width : 150 , visible : false },
    { dataField:"refDtlsJPayRef" ,headerText:"Ref Details/JomPay Ref" ,editable : false , width : 150 },
    { dataField:"trNo" ,headerText:"TR No" ,editable : true , width : 150 },
    { dataField:"trDt" ,headerText:"TR Issue Date" ,editable : false , width : 150 },
    { dataField:"collectorCode" ,headerText:"Collector Code" ,editable : false , width : 250 },
    { dataField:"collectorId" ,headerText:"Collector Id" ,editable : false , width : 150 ,visible : false},
    { dataField:"allowComm" ,headerText:"Commission" ,editable : false , width : 150}
];

//Grid Properties 설정
var gridPros = {
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
    targetRenMstGridID = GridCommon.createAUIGrid("target_rental_grid_wrap", targetRenMstColumnLayout,null,gridPros);
    targetRenDetGridID = GridCommon.createAUIGrid("target_rentalD_grid_wrap", targetRenDetColumnLayout,null,gridPros);
    targetOutMstGridID = GridCommon.createAUIGrid("target_out_grid_wrap", targetOutMstColumnLayout,null,gridPros);
    targetSrvcMstGridID = GridCommon.createAUIGrid("target_srvc_grid_wrap", targetSrvcMstColumnLayout,null,gridPros);
    targetSrvcDetGridID = GridCommon.createAUIGrid("target_srvcD_grid_wrap", targetSrvcDetColumnLayout,null,gridPros);
    targetBillMstGridID = GridCommon.createAUIGrid("target_bill_grid_wrap", targetBillMstColumnLayout,null,gridPros);
    targetOutSrvcMstGridID = GridCommon.createAUIGrid("target_outSrvc_grid_wrap", targetOutSrvcMstColumnLayout,null,gridPros);
    targetFinalBillGridID = GridCommon.createAUIGrid("target_finalBill_grid_wrap", targetFinalBillColumnLayout,null,targetGridPros);
    targetCareSrvcMstGridID = GridCommon.createAUIGrid("target_careSrvc_grid_wrap", targetCareSrvcMstColumnLayout,null,gridPros);

    //Payment Type을 설정한다. : Source Target에 해당하는 order로 Transfer 가능함
    var keyInAppTypeId = $("#keyInAppTypeId").val();
    fn_chgAppType(keyInAppTypeId);
    $("#appType").val(keyInAppTypeId);

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


    // Master Grid 셀 클릭시 이벤트
    AUIGrid.bind(targetFinalBillGridID, "cellClick", function( event ){
        selectedGridValue = event.rowIndex;
    });

    $("#genAdvAmt").blur(function() {
        fn_checkAdvAmt();
    });
});

//USING X3
function fn_chgAppType(){
	 var appType = $("#appType").val();
     //AUIGrid.clearGridData(targetFinalBillGridID);

     //div all hide
     $("#rentalSearch").hide();
     $("#outSearch").hide();
     $("#srvcSearch").hide();
     $("#billSearch").hide();
     $("#outSrvcSearch").hide();
     $("#careSrvcSearch").hide();

     //Form 초기화
     $("#rentalSearchForm")[0].reset();
     $("#outSearchForm")[0].reset();
     $("#srvcSearchForm")[0].reset();
     $("#billSearchForm")[0].reset();
     $("#outSrvcSearchForm")[0].reset();
     $("#careSrvcSearchForm")[0].reset();

     //그리드 초기화
     resetRentalGrid();
     resetOutGrid();
     resetSrvcGrid();
     resetBillGrid();
     resetOutSrvcGrid();
     resetCareSrvcGrid();

     //금액 표시 초기화
     $("#rentalTotalAmtTxt").text("RM " + $.number(0,2));
     $("#outTotalAmtTxt").text("RM " + $.number(0,2));
     $("#srvcTotalAmtTxt").text("RM " + $.number(0,2));
     $("#billTotalAmtTxt").text("RM " + $.number(0,2));
     $("#outSrvcTotalAmtTxt").text("RM " + $.number(0,2));
     $("#careSrvcTotalAmtTxt").text("RM " + $.number(0,2));


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
     }else if(appType == 5){
         $("#outSrvcSearch").show();
         AUIGrid.resize(targetOutSrvcMstGridID);
     } else if(appType == 6){
         $("#careSrvcSearch").show();
         AUIGrid.resize(targetCareSrvcMstGridID);
     }
}

//USING X3
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


//USING X3
//추가된 최종 그리드 삭제
function removeFromFinal(){

    if (selectedGridValue  > -1){
        Common.confirm("<spring:message code='pay.alert.selectedRow'/>"
        ,function (){
            //csv 파일이 header가 있는 파일이면 첫번째 행(header)은 삭제한다.
            AUIGrid.removeRow(targetFinalBillGridID,selectedGridValue);
            selectedGridValue = -1;

            recalculatePaymentTotalAmt();
        });
    }else{
        Common.alert("<spring:message code='pay.alert.removeRowData'/>");
    }
}

function resetFinalGrid(){
    AUIGrid.clearGridData(targetFinalBillGridID);
    maxSeq = 0;
}

// 적용 버튼 클릭시 add된 항목을 세팅한다.
function fn_apply(){

    //param data array
    var data = {};

    var gridList = AUIGrid.getGridData(targetFinalBillGridID);       //그리드 데이터
    var formList = $("#paymentForm").serializeArray();       //폼 데이터

    //array에 담기
    if(gridList.length > 0) {
        data.all = gridList;
    }  else {
        Common.alert("There is no DCF Row Data");
        return;
    }

    if(formList.length > 0) data.form = formList;
    else data.form = [];

    fn_newOrderSearchPopCallBack(gridList);

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

//Rental Amount 선납금 할인율 적용
function rentalDiscountValue(){
    var discountValue = 0.0;
    var discountrate = 0;
    var originalprice = 0.0;

    //Advance Specification 관련 금액 계산
    var advMonth = $("#rentalTxtAdvMonth").val();
    var rows = AUIGrid.getRowIndexesByValue(targetRenMstGridID, "salesOrdId", $("#rentalOrdId").val());
    var mthRentAmt = AUIGrid.getCellValue(targetRenMstGridID, rows, "mthRentAmt");
    var megaDeal = $("#rentalMegaDeal").val();
    var cnvrScheme = $("#rentalCnvrScheme").val(); // CREDIT CARD IS NOT USING THIS PART
    var advDisc = $("#rentalAdvDisc").val();

    if(megaDeal == 0 && cnvrScheme == 0 && advDisc == 1){ // NEED TO CHECK CREDIT CARD WILL GET AFFECTED BY THIS PART OR NOT
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
            if(advMonth == 0) {
                discountValue = parseFloat($("#genAdvAmt").val());
                originalprice = parseFloat($("#genAdvAmt").val());
            } else {
                discountValue = mthRentAmt * advMonth;
                originalprice = mthRentAmt * advMonth;
            }
            discountrate = 0;
        }
    }else{
        if(advMonth == 0) {
            discountValue = parseFloat($("#genAdvAmt").val());
            originalprice = parseFloat($("#genAdvAmt").val());
        } else {
            discountValue = mthRentAmt * advMonth;
            originalprice = mthRentAmt * advMonth;
        }
        discountrate = 0;
    }

    //선납금 할인을 적용한 금액 표시
    recalculateRentalTotalAmtWidthAdv(discountValue,originalprice,discountrate);
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
    var megaDeal;

    if($("#isRentalBillGroup").is(":checked")){
        data = {"billGrpId" : $("#rentalBillGrpId").val() };
    }else{
        data = {"orderId" : $("#rentalOrdId").val() };
    }

    //Order ID로 MegaDeal 여부를 조회한다.
    megaDeal = {"orderId" : $("#rentalOrdId").val() };
    Common.ajax("GET", "/payment/common/selectMegaDealByOrderId.do", megaDeal, function(result) {

        $("#rentalMegaDeal").val(result.megaDeal);
        $("#rentalCnvrScheme").val(result.cnvrSchemeId); // CREDIT CARD IS NOT USING THIS PART
        $("#rentalAdvDisc").val(result.advDisc);
    });

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

    if(advMonth != '' && advMonth >= 0){     //advMonth가 입력되어 있는 경우
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
    $("#rentalAdvAmt").val($.number(discountValue,2,'.',''));
    var megaDeal = $("#rentalMegaDeal").val();
    var cnvrScheme = $("#rentalCnvrScheme").val();
    console.log("discountrate: " + discountrate);

    if(megaDeal == 0 && cnvrScheme == 0 ){ // CREDIT CARD NOT USING CNVRSCHEME
        if (tot > 0) {
            $("#rentalTotalAmtTxt").text("RM " + $.number(tot,2) + " + (RM " + $.number(originalPrice,2)  + " - " + discountrate + "%) = RM " + $.number(grandtotal,2));
        } else {
            $("#rentalTotalAmtTxt").text("(RM " + $.number(originalPrice,2) + " - " + discountrate + "%) = RM " + $.number(grandtotal,2));
        }
    }else{
        if (tot > 0) {
            $("#rentalTotalAmtTxt").text("RM " + $.number(tot,2) + " + (RM " + $.number(originalPrice,2)  + ") = RM " + $.number(grandtotal,2));
        } else {
            $("#rentalTotalAmtTxt").text("(RM " + $.number(originalPrice,2) + ") = RM " + $.number(grandtotal,2));
        }
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
        $("#rentalTxtAdvMonth").val(0);
        $('#rentalTxtAdvMonth').removeClass("readonly");
        $("#rentalTxtAdvMonth").prop("readonly",false);
        $("#genAdvAmt").val(0);
        $("#genAdvAmt").removeClass("readonly");
        $("#genAdvAmt").prop("readonly",false);
    }else{
        $("#rentalTxtAdvMonth").val(advMonth);
        $('#rentalTxtAdvMonth').addClass("readonly");
        $("#rentalTxtAdvMonth").prop("readonly",true);
        $('#genAdvAmt').val("");
        $('#genAdvAmt').addClass("readonly");
        $("#genAdvAmt").prop("readonly",true);
    }

    //Rental Adv Month가 0보다 크면 billing group 선택못합
    if($("#rentalTxtAdvMonth").val() != '' && $("#rentalTxtAdvMonth").val() >= 0){
        $("#genAdvAmt").focus();
        /*$("#isRentalBillGroup").attr("checked", false);
        $("#isRentalBillGroup").attr("disabled", true);

        if($("#rentalOrdNo").val() != ''){
            fn_rentalConfirm();
        }*/
    }else{
        $("#isRentalBillGroup").attr("disabled", false);
        recalculateRentalTotalAmt();
    }
}

function fn_checkAdvAmt() {
    var advAmt = $("#genAdvAmt").val();
    if($("#rentalAdvMonthType").val() == 99 && $("#rentalTxtAdvMonth").val() == 0) {
        if(advAmt > 10000 || advAmt <= 0) {
            Common.alert("Amount must be greater than RM0.00 and lesser than RM10,000.00");
            $("#genAdvAmt").val(0);
            //return false;
        } else if(advAmt <= 10000 && advAmt > 0){
            $("#isRentalBillGroup").attr("checked", false);
            $("#isRentalBillGroup").attr("disabled", true);

            if($("#rentalOrdNo").val() != ''){
                fn_rentalConfirm();
            }
        }
    }
}

//Advance Month 변경시 이벤트
function fn_rentalAdvMonthChangeTxt(){
  //Rental Membership Adv Month가 0보다 크면 billing group 선택못합
  if($("#rentalTxtAdvMonth").val() != '' && $("#rentalTxtAdvMonth").val() >= 0){
       $("#genAdvAmt").focus();
          /*$("#isRentalBillGroup").attr("checked", false);
          $("#isRentalBillGroup").attr("disabled", true);

          if($("#rentalOrdNo").val() != ''){
              fn_rentalConfirm();
          }*/
  }else{
      $("#isRentalBillGroup").attr("disabled", false);
      recalculateRentalTotalAmt();
  }
}

function addRentalToFinal(){
    var addedCount = 0;

    if($("#rentalAdvMonthType").val() == 99 && $("#rentalTxtAdvMonth").val() == 0) {
        if($("#genAdvAmt").val() <= 0 || $("#genAdvAmt").val() > 10000) {
            Common.alert("Amount must be greater than RM0.00 and lesser than RM10,000.00");
            return;
        }
    }

    if(isDupRentalToFinal() > 0){
        Common.alert("<spring:message code='pay.alert.keyin.add.dup'/>");
        return;
    }

    if($("#rentalcashIsCommChk").is(":checked") == true){
        $("#rentalcashIsCommChk").val("1");
    }else{
        $("#rentalcashIsCommChk").val("0");
    }

    var rowCnt = AUIGrid.getRowCount(targetRenMstGridID);
    maxSeq = maxSeq + 1;

    if(rowCnt > 0){
        for(i = 0 ; i < rowCnt ; i++){

            if(rowCnt < 2){
                var salesOrdId = AUIGrid.getCellValue(targetRenMstGridID, i ,"salesOrdId");
                Common.ajax("GET", "/payment/common/checkOrderOutstanding.do", {salesOrdId : salesOrdId}, function(RESULT) {

                    if(RESULT.rootState == 'ROOT_1') {

                        Common.alert('No Outstanding' + DEFAULT_DELIMITER + RESULT.msg);
                    }
                });
            }

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
                     item.srvMemId  =0;
                     item.trNo =  $("#rentalkeyInTrNo").val() ;
                     item.trDt =  $("#rentalkeyInTrIssueDate").val() ;
                     item.collectorCode =  $("#rentalkeyInCollMemCd").val() ;
                     item.collectorId = $("#rentalkeyInCollMemId").val() ;
                     item.allowComm = $("#rentalcashIsCommChk").val() ;
                     item.refDtlsJPayRef = $("#rentalRefDtlsJompay").val(); //CREDIT CARD IS NOT USING THIS PART

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
                        item.srvMemId   =0;
                        item.trNo =  $("#rentalkeyInTrNo").val() ;
                        item.trDt =  $("#rentalkeyInTrIssueDate").val() ;
                        item.collectorCode =  $("#rentalkeyInCollMemCd").val() ;
                        item.collectorId = $("#rentalkeyInCollMemId").val() ;
                        item.allowComm = $("#rentalcashIsCommChk").val() ;
                        item.refDtlsJPayRef = $("#rentalRefDtlsJompay").val(); // CREDIT CARD IS NOT USING THIS PART

                        AUIGrid.addRow(targetFinalBillGridID, item, "last");

                        addedCount++;
                    }
                }

                //Advance Month
                if($("#rentalTxtAdvMonth").val() != '' && $("#rentalTxtAdvMonth").val() >= 0){
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
                    item.srvMemId   =0;
                    item.trNo =  $("#rentalkeyInTrNo").val() ;
                    item.trDt =  $("#rentalkeyInTrIssueDate").val() ;
                    item.collectorCode =  $("#rentalkeyInCollMemCd").val() ;
                    item.collectorId = $("#rentalkeyInCollMemId").val() ;
                    item.allowComm = $("#rentalcashIsCommChk").val() ;
                    item.refDtlsJPayRef = $("#rentalRefDtlsJompay").val(); // CREDIT CARD IS NOT USING THIS PART

                    AUIGrid.addRow(targetFinalBillGridID, item, "last");

                    addedCount++;

               }
            }
        }
    }

    if(addedCount == 0){
        Common.alert("<spring:message code='pay.alert.noBillingData'/>");
    }

    recalculatePaymentTotalAmt();
    $("#rentalkeyInTrNo").clearForm() ;
    $("#rentalkeyInTrIssueDate").clearForm() ;
}

// Add 할때 중복된 건이 있는지 체크한다.
function isDupRentalToFinal(){
    var rowCnt = AUIGrid.getRowCount(targetRenMstGridID);
    var addedRows = AUIGrid.getRowsByValue(targetFinalBillGridID,"appType","RENTAL");
    var dupCnt = 0;

    if(rowCnt > 0){
        for(i = 0 ; i < rowCnt ; i++){

            var mstChkVal = AUIGrid.getCellValue(targetRenMstGridID, i ,"btnCheck");
            var mstSalesOrdNo = AUIGrid.getCellValue(targetRenMstGridID, i ,"salesOrdNo");
            var mstRpf = AUIGrid.getCellValue(targetRenMstGridID, i ,"rpf");
            var mstRpfPaid = AUIGrid.getCellValue(targetRenMstGridID, i ,"rpfPaid");

            if(mstChkVal == 1){
                if(mstRpf - mstRpfPaid > 0){
                    if(addedRows.length > 0) {
                        for(addedIdx = 0 ; addedIdx < addedRows.length ; addedIdx++){
                            if (AUIGrid.getCellValue(targetRenMstGridID, i ,"salesOrdId") == addedRows[addedIdx].ordId && 161 == addedRows[addedIdx].billTypeId) {
                                dupCnt++;
                            }
                        }
                    }
                }

                var detailRowCnt = AUIGrid.getRowCount(targetRenDetGridID);
                for(j = 0 ; j < detailRowCnt ; j++){
                    var detChkVal = AUIGrid.getCellValue(targetRenDetGridID, j ,"btnCheck");
                    var detSalesOrdNo = AUIGrid.getCellValue(targetRenDetGridID, j ,"ordNo");

                    if(mstSalesOrdNo == detSalesOrdNo && detChkVal == 1){

                        if(addedRows.length > 0) {
                            for(addedIdx = 0 ; addedIdx < addedRows.length ; addedIdx++){

                                if (AUIGrid.getCellValue(targetRenMstGridID, j ,"salesOrdId") == addedRows[addedIdx].ordId &&
                                    AUIGrid.getCellValue(targetRenDetGridID, j ,"installment") == addedRows[addedIdx].installment &&
                                    AUIGrid.getCellValue(targetRenDetGridID, j ,"billTypeId") == addedRows[addedIdx].billTypeId) {
                                    dupCnt++;
                                }
                            }
                        }
                    }
                }

                //Advance Month
                if($("#rentalTxtAdvMonth").val() != '' && $("#rentalTxtAdvMonth").val() >= 0){
                    if(addedRows.length > 0) {
                        for(addedIdx = 0 ; addedIdx < addedRows.length ; addedIdx++){
                            if (AUIGrid.getCellValue(targetRenMstGridID, i ,"salesOrdId") == addedRows[addedIdx].ordId && 1032 == addedRows[addedIdx].billTypeId) {
                                dupCnt++;
                            }
                        }
                    }
                }
            }
        }
    }

    return dupCnt;
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

    if(isDupOutToFinal() > 0){
        Common.alert("<spring:message code='pay.alert.keyin.add.dup'/>");
        return;
    }

    if($("#outcashIsCommChk").is(":checked") == true){
        $("#outcashIsCommChk").val("1");
    }else{
        $("#outcashIsCommChk").val("0");
    }

    var rowCnt = AUIGrid.getRowCount(targetOutMstGridID);
    maxSeq = maxSeq + 1;

    if(rowCnt > 0){
        for(i = 0 ; i < rowCnt ; i++){

            if(rowCnt < 2){
                var salesOrdId = AUIGrid.getCellValue(targetOutMstGridID, i ,"salesOrdId");
                Common.ajax("GET", "/payment/common/checkOrderOutstanding.do", {salesOrdId : salesOrdId}, function(RESULT) {

                    if(RESULT.rootState == 'ROOT_1') {

                        Common.alert('No Outstanding' + DEFAULT_DELIMITER + RESULT.msg);
                    }
                });
            }

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
                item.srvMemId   =0;
                item.trNo =  $("#outkeyInTrNo").val() ;
                item.trDt =  $("#outkeyInTrIssueDate").val() ;
                item.collectorCode = $("#outkeyInCollMemCd").val() ;
                item.collectorId = $("#outkeyInCollMemId").val() ;
                item.allowComm = $("#outcashIsCommChk").val() ;
                item.refDtlsJPayRef = $("#outRefDtlsJompay").val(); //  CREDIT CARD IS NOT USING THIS PART

                AUIGrid.addRow(targetFinalBillGridID, item, "last");

                addedCount++;
            }
        }
    }

    if(addedCount == 0){
        Common.alert("<spring:message code='pay.alert.noBillingData'/>");
    }

    recalculatePaymentTotalAmt();
    $("#outkeyInTrNo").clearForm();
    $("#outkeyInTrIssueDate").clearForm();
}


// Add 할때 중복된 건이 있는지 체크한다.
function isDupOutToFinal(){
    var rowCnt = AUIGrid.getRowCount(targetOutMstGridID);
    var addedRows = AUIGrid.getRowsByValue(targetFinalBillGridID,"appType","OUT");
    var dupCnt = 0;

    if(rowCnt > 0){
        for(i = 0 ; i < rowCnt ; i++){

            var targetAmt = AUIGrid.getCellValue(targetOutMstGridID, i ,"balance");

            if(targetAmt > 0){

                if(addedRows.length > 0) {
                    for(addedIdx = 0 ; addedIdx < addedRows.length ; addedIdx++){
                        if (AUIGrid.getCellValue(targetOutMstGridID, i ,"salesOrdId") == addedRows[addedIdx].ordId) {
                            dupCnt++;
                        }
                    }
                }
            }
        }
    }

    return dupCnt;
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
    $("#srvcAdvAmt").val($.number(discountValue,2,'.',''));

    if (tot > 0) {
        $("#srvcTotalAmtTxt").text("RM " + $.number(tot,2) + " + (RM " + $.number(originalPrice,2)  + " - " + discountrate + "%) = RM " + $.number(grandtotal,2));
    } else {
        $("#srvcTotalAmtTxt").text("(RM " + $.number(originalPrice,2) + " - " + discountrate + "%) = RM " + $.number(grandtotal,2));
    }
}


function addSrvcToFinal(){
    var addedCount = 0;

    if(isDupSrvcToFinal() > 0){
        Common.alert("<spring:message code='pay.alert.keyin.add.dup'/>");
        return;
    }

    if($("#srvccashIsCommChk").is(":checked") == true){
        $("#srvccashIsCommChk").val("1");
    }else{
        $("#srvccashIsCommChk").val("0");
    }

    var rowCnt = AUIGrid.getRowCount(targetSrvcMstGridID);
    maxSeq = maxSeq + 1;

    if(rowCnt > 0){
        for(i = 0 ; i < rowCnt ; i++){

        	if(rowCnt < 2){
                var salesOrdId = AUIGrid.getCellValue(targetSrvcMstGridID, i ,"salesOrdId");
                Common.ajax("GET", "/payment/common/checkOrderOutstanding.do", {salesOrdId : salesOrdId}, function(RESULT) {

                    if(RESULT.rootState == 'ROOT_1') {

                        Common.alert('No Outstanding' + DEFAULT_DELIMITER + RESULT.msg);
                    }
                });
            }

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
                     item.srvMemId  =0;
                     item.trNo =  $("#srvckeyInTrNo").val() ;
                     item.trDt =  $("#srvckeyInTrIssueDate").val() ;
                     item.collectorCode = $("#srvckeyInCollMemCd").val() ;
                     item.collectorId = $("#srvckeyInCollMemId").val() ;
                     item.allowComm = $("#srvccashIsCommChk").val() ;
                     item.refDtlsJPayRef = $("#srvcRefDtlsJompay").val();

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
                    item.srvMemId   =0;
                    item.trNo =  $("#srvckeyInTrNo").val() ;
                    item.trDt =  $("#srvckeyInTrIssueDate").val() ;
                    item.collectorCode = $("#srvckeyInCollMemCd").val() ;
                    item.collectorId = $("#srvckeyInCollMemId").val() ;
                    item.allowComm = $("#srvccashIsCommChk").val() ;
                    item.refDtlsJPayRef = $("#srvcRefDtlsJompay").val(); // CREDIT CARD KEY IN IS NOT USING THIS PART

                    AUIGrid.addRow(targetFinalBillGridID, item, "last");

                    addedCount++;
               }

                //Advance Month
                if($("#srvcTxtAdvMonth").val() != '' && $("#srvcTxtAdvMonth").val() >= 0){
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
                    item.srvMemId   =0;
                    item.trNo =  $("#srvckeyInTrNo").val() ;
                    item.trDt =  $("#srvckeyInTrIssueDate").val() ;
                    item.collectorCode = $("#srvckeyInCollMemCd").val() ;
                    item.collectorId = $("#srvckeyInCollMemId").val() ;
                    item.allowComm = $("#srvccashIsCommChk").val() ;
                    item.refDtlsJPayRef = $("#srvcRefDtlsJompay").val(); // CREDIT CARD KEY IN IS NOT USING THIS PART

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
                        item.srvMemId   =0;
                        item.trNo =  $("#srvckeyInTrNo").val() ;
                        item.trDt =  $("#srvckeyInTrIssueDate").val() ;
                        item.collectorCode = $("#srvckeyInCollMemCd").val() ;
                        item.collectorId = $("#srvckeyInCollMemId").val() ;
                        item.allowComm = $("#srvccashIsCommChk").val() ;
                        item.refDtlsJPayRef = $("#srvcRefDtlsJompay").val(); // CREDIT CARD KEY IN IS NOT USING THIS PART

                        AUIGrid.addRow(targetFinalBillGridID, item, "last");

                        addedCount++;
                    }
                }
            }
        }
    }

    if(addedCount == 0){
        Common.alert("<spring:message code='pay.alert.noBillingData'/>");
    }

    recalculatePaymentTotalAmt();
    $("#srvckeyInTrNo").clearForm() ;
    $("#srvckeyInTrIssueDate").clearForm() ;
}



// Add 할때 중복된 건이 있는지 체크한다.
function isDupSrvcToFinal(){
    var rowCnt = AUIGrid.getRowCount(targetSrvcMstGridID);
    var addedRows = AUIGrid.getRowsByValue(targetFinalBillGridID,"appType","MEMBERSHIP");
    var dupCnt = 0;

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

                    if(addedRows.length > 0) {
                        for(addedIdx = 0 ; addedIdx < addedRows.length ; addedIdx++){
                            if (AUIGrid.getCellValue(targetSrvcMstGridID, i ,"srvCntrctOrdId") == addedRows[addedIdx].ordId && 1307 == addedRows[addedIdx].billTypeId) {
                                dupCnt++;
                            }
                        }
                    }
                }

                if(mstPenaltyCharges - mstPenaltyChargesPaid > 0){
                    if(addedRows.length > 0) {
                        for(addedIdx = 0 ; addedIdx < addedRows.length ; addedIdx++){
                            if (AUIGrid.getCellValue(targetSrvcMstGridID, i ,"srvCntrctOrdId") == addedRows[addedIdx].ordId && 1306 == addedRows[addedIdx].billTypeId) {
                                dupCnt++;
                            }
                        }
                    }
                }

                //Advance Month
                if($("#srvcTxtAdvMonth").val() != '' && $("#srvcTxtAdvMonth").val() > 0){
                    if(addedRows.length > 0) {
                        for(addedIdx = 0 ; addedIdx < addedRows.length ; addedIdx++){
                            if (AUIGrid.getCellValue(targetSrvcMstGridID, i ,"srvCntrctOrdId") == addedRows[addedIdx].ordId && 154 == addedRows[addedIdx].billTypeId) {
                                dupCnt++;
                            }
                        }
                    }
                }

                var detailRowCnt = AUIGrid.getRowCount(targetSrvcDetGridID);
                for(j = 0 ; j < detailRowCnt ; j++){
                    var detChkVal = AUIGrid.getCellValue(targetSrvcDetGridID, j ,"btnCheck");
                    var detSrvCntrctRefNo = AUIGrid.getCellValue(targetSrvcDetGridID, j ,"srvCntrctRefNo");

                    if(mstSrvCntrctRefNo == detSrvCntrctRefNo && detChkVal == 1){
                        if(addedRows.length > 0) {
                            for(addedIdx = 0 ; addedIdx < addedRows.length ; addedIdx++){
                                if (AUIGrid.getCellValue(targetSrvcDetGridID, j ,"srvCntrctOrdId") == addedRows[addedIdx].ordId &&
                                        AUIGrid.getCellValue(targetSrvcDetGridID, j ,"srvPaySchdulNo") == addedRows[addedIdx].installment &&
                                        AUIGrid.getCellValue(targetSrvcDetGridID, j ,"srvLdgrTypeId") == addedRows[addedIdx].billTypeId) {
                                    dupCnt++;
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    return dupCnt;
}


//**************************************************
//**************************************************
//Bill Payment  관련 Script
//**************************************************
//**************************************************
// PLEASE DOUBLE CHECK ON THIS PART ,  Seems like no need to care about credit card key in part also can, coz that part is use for searching purpose
//USING X2 -- CREDIT CARD KEY IN HAS DIFFERENT FUNCTION WITH SAME FUNCTION NAME
function fn_changeBillType(){

    if($("#billType").val() == 1){
        AUIGrid.hideColumnByDataField(targetBillMstGridID, "billMemNm" );
        AUIGrid.hideColumnByDataField(targetBillMstGridID, "billMemCode" );
        AUIGrid.showColumnByDataField(targetBillMstGridID, "custNm");
        AUIGrid.showColumnByDataField(targetBillMstGridID, "nric");

    }else if($("#billType").val() == 2){
        AUIGrid.showColumnByDataField(targetBillMstGridID, "billMemNm" );
        AUIGrid.showColumnByDataField(targetBillMstGridID, "billMemCode" );
        AUIGrid.hideColumnByDataField(targetBillMstGridID, "custNm");
        AUIGrid.hideColumnByDataField(targetBillMstGridID, "nric");

    }else{ // added to handle bill type = 3 - POS
    	// ADVANCE KEY IN IS NOT USING THIS PART
          AUIGrid.hideColumnByDataField(targetBillMstGridID, "billMemNm" );
          AUIGrid.hideColumnByDataField(targetBillMstGridID, "billMemCode" );
          AUIGrid.showColumnByDataField(targetBillMstGridID, "custNm");
          AUIGrid.showColumnByDataField(targetBillMstGridID, "nric");
    }
}


function fn_billOrderSearch(){
    if(FormUtil.checkReqValue($("#billSearchTxt"))){
        Common.alert("<spring:message code='pay.alert.searchKeywords'/>");
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

//USING X2
// CREDIT CARD KEY IN HAS SLIGHTLY DIFFERENT WITH OTHERS
function addBillToFinal(){
    var addedCount = 0;
    var checkArray = AUIGrid.getItemsByValue(targetBillMstGridID,"btnCheck","1");

    if($("#billcashIsCommChk").is(":checked") == true){
        $("#billcashIsCommChk").val("1");
    }else{
        $("#billcashIsCommChk").val("0");
    }

    if(checkArray.length > 1){
        Common.alert("<spring:message code='pay.alert.onlyOneBill'/>");
        return;
    }else{

    	 if(isDupHPToFinal() > 0 || isDupASToFinal() > 0 || isDupPOSToFinal() > 0){ // Added POS - TPY 21/06/2018
             Common.alert("<spring:message code='pay.alert.keyin.add.dup'/>");
             return;
         }

        var rowCnt = AUIGrid.getRowCount(targetBillMstGridID);
        maxSeq = maxSeq + 1;

        if(rowCnt > 0){
            for(i = 0 ; i < rowCnt ; i++){

            	 if(rowCnt < 2){
                     var salesOrdId = AUIGrid.getCellValue(targetBillMstGridID, i ,"billSoId");
                     Common.ajax("GET", "/payment/common/checkOrderOutstanding.do", {salesOrdId : salesOrdId}, function(RESULT) {

                         if(RESULT.rootState == 'ROOT_1') {

                             Common.alert('No Outstanding' + DEFAULT_DELIMITER + RESULT.msg);
                         }
//                          // CREDIT CARD KEY IN IS USING THIS PART
//                          else if(RESULT.rootState == 'ROOT_3') {
//                              Common.alert('Point of Sales' + DEFAULT_DELIMITER + RESULT.msg);
//                            }
                     });
                 }

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
                         item.srvMemId   =0;
                         item.trNo =  $("#billkeyInTrNo").val() ;
                         item.trDt =  $("#billkeyInTrIssueDate").val() ;
                         item.collectorCode = $("#billkeyInCollMemCd").val() ;
                         item.collectorId = $("#billkeyInCollMemId").val() ;
                         item.allowComm = $("#billcashIsCommChk").val() ;
                         item.refDtlsJPayRef = $("#billKeyRefDtlsJompay").val(); // CREDIT CARD KEY IN IS NOT USING THIS PART

                         AUIGrid.addRow(targetFinalBillGridID, item, "last");

                         addedCount++;
                     }
                 }
             }
         }

         if(addedCount == 0){
             Common.alert("<spring:message code='pay.alert.noBillingData'/>");
         }

         recalculatePaymentTotalAmt();
         $("#billkeyInTrNo").clearForm() ;
         $("#billkeyInTrIssueDate").clearForm() ;
     }
}

// Add 할때 중복된 건이 있는지 체크한다.
function isDupASToFinal(){
    var rowCnt = AUIGrid.getRowCount(targetBillMstGridID);
    var addedRows = AUIGrid.getRowsByValue(targetFinalBillGridID,"appType","AS");
    var dupCnt = 0;


    if(rowCnt > 0){
        for(i = 0 ; i < rowCnt ; i++){
            if(AUIGrid.getCellValue(targetBillMstGridID, i ,"btnCheck") == 1){
                if(addedRows.length > 0) {
                    for(addedIdx = 0 ; addedIdx < addedRows.length ; addedIdx++){
                        if (AUIGrid.getCellValue(targetBillMstGridID, i ,"billId") == addedRows[addedIdx].billId && AUIGrid.getCellValue(targetBillMstGridID, i ,"appType") == 'AS') {
                            dupCnt++;
                        }
                    }
                }
            }
        }
    }
    return dupCnt;
}

// Add 할때 중복된 건이 있는지 체크한다.
function isDupHPToFinal(){
    var rowCnt = AUIGrid.getRowCount(targetBillMstGridID);
    var addedRows = AUIGrid.getRowsByValue(targetFinalBillGridID,"appType","HP");
    var dupCnt = 0;


    if(rowCnt > 0){
        for(i = 0 ; i < rowCnt ; i++){
            if(AUIGrid.getCellValue(targetBillMstGridID, i ,"btnCheck") == 1){
                var targetAmt = AUIGrid.getCellValue(targetBillMstGridID, i ,"billAmt") - AUIGrid.getCellValue(targetBillMstGridID, i ,"paidAmt");

                if(addedRows.length > 0) {
                    for(addedIdx = 0 ; addedIdx < addedRows.length ; addedIdx++){
                        if (AUIGrid.getCellValue(targetBillMstGridID, i ,"billId") == addedRows[addedIdx].billId && AUIGrid.getCellValue(targetBillMstGridID, i ,"appType") == 'HP') {
                            dupCnt++;
                        }
                    }
                }
            }
        }
    }
    return dupCnt;
}

//USING X2 - ADVANCE KEY IN IS NOT USING THIS PART
//Add to handle Bill Type - POS  - TPY 21/06/2018
function isDupPOSToFinal(){
    var rowCnt = AUIGrid.getRowCount(targetBillMstGridID);
    var addedRows = AUIGrid.getRowsByValue(targetFinalBillGridID,"appType","POS");
    var dupCnt = 0;


    if(rowCnt > 0){
        for(i = 0 ; i < rowCnt ; i++){
            if(AUIGrid.getCellValue(targetBillMstGridID, i ,"btnCheck") == 1){
                var targetAmt = AUIGrid.getCellValue(targetBillMstGridID, i ,"billAmt") - AUIGrid.getCellValue(targetBillMstGridID, i ,"paidAmt");

                if(addedRows.length > 0) {
                    for(addedIdx = 0 ; addedIdx < addedRows.length ; addedIdx++){
                        if (AUIGrid.getCellValue(targetBillMstGridID, i ,"billId") == addedRows[addedIdx].billId && AUIGrid.getCellValue(targetBillMstGridID, i ,"appType") == 'POS') {
                            dupCnt++;
                        }
                    }
                }
            }
        }
    }
    return dupCnt;
}



//**************************************************
//**************************************************
//Outright Membership 관련 Script
//**************************************************
//**************************************************
//Quotation Search 팝업
function fn_quotationSearchPop(){
//     resetFinalGrid();
//     $("#paymentTotalAmtTxt").text("RM " + $.number(0,2));
  Common.popupDiv('/payment/common/initCommonQuotationSearchPop.do', {callPrgm : "MEMBERSHIP_PAYMENT"}, null , true ,'_serviceContract');
}

//USING
//Quotation Search 팝업에서 결과값 받기
function fn_callBackQuotInfo(quotId, ordId, quotNo,ordNo){
  $('#outSrvcQuotId').val(quotId);
  $('#outSrvcOrdId').val(ordId);
  $('#outSrvcQuotNo').val(quotNo);
  $('#outSrvcOrdNo').val(ordNo);

  //팝업 숨기기 및 remove
  $('#_serviceContract').hide();
  $('#_serviceContract').remove();

  //Order Info 및 Payment Info 조회
  fn_outSrvcOrderInfo();
}

//Outright Membership Order Info 조회
function fn_outSrvcOrderInfo(){
    var data;
    data = {"quotId" : $("#outSrvcQuotId").val() };

    //Outright : Order 정보 조회
    Common.ajax("GET", "/payment/common/selectOutSrvcOrderInfo.do", data, function(result) {
        //Outright : Order Info 세팅
        AUIGrid.setGridData(targetOutSrvcMstGridID, result);

        //총 금액 계산
        recalculateOutSrvcTotalAmt();
    });
}

//Outright Amount 계산
function recalculateOutSrvcTotalAmt(){
    var rowCnt = AUIGrid.getRowCount(targetOutSrvcMstGridID);
    var totalAmt = 0;

    if(rowCnt > 0){
        for(var i = 0; i < rowCnt; i++){
            totalAmt += (AUIGrid.getCellValue(targetOutSrvcMstGridID, i ,"packageCharge") - AUIGrid.getCellValue(targetOutSrvcMstGridID, i ,"packagePaid"))
                        +(AUIGrid.getCellValue(targetOutSrvcMstGridID, i ,"filterCharge") - AUIGrid.getCellValue(targetOutSrvcMstGridID, i ,"filterPaid"));
        }
    }

    $("#outSrvcTotalAmtTxt").text("RM " + $.number(totalAmt,2));
}


function resetOutSrvcGrid(){
    AUIGrid.clearGridData(targetOutSrvcMstGridID);
}


function addOutSrvcToFinal(){
    var addedCount = 0;

    if(isDupOutSrvcToFinal() > 0){
        Common.alert("<spring:message code='pay.alert.keyin.add.dup'/>");
        return;
    }

    if($("#outSrvccashIsCommChk").is(":checked") == true){
        $("#outSrvccashIsCommChk").val("1");
    }else{
        $("#outSrvccashIsCommChk").val("0");
    }

    var rowCnt = AUIGrid.getRowCount(targetOutSrvcMstGridID);
    maxSeq = maxSeq + 1;

    if(rowCnt > 0){
        for(i = 0 ; i < rowCnt ; i++){

        	if(rowCnt < 2){
                var salesOrdId = AUIGrid.getCellValue(targetOutSrvcMstGridID, i ,"ordId");
                Common.ajax("GET", "/payment/common/checkOrderOutstanding.do", {salesOrdId : salesOrdId}, function(RESULT) {

                    if(RESULT.rootState == 'ROOT_1') {

                        Common.alert('No Outstanding' + DEFAULT_DELIMITER + RESULT.msg);
                    }
                });
            }

            var packageAmt = AUIGrid.getCellValue(targetOutSrvcMstGridID, i ,"packageCharge") - AUIGrid.getCellValue(targetOutSrvcMstGridID, i ,"packagePaid");

            if(packageAmt > 0){
                var item = new Object();
                item.procSeq = maxSeq;
                item.appType = "OUT_MEM";
                item.advMonth = 0;
                item.mstRpf = 0;
                item.mstRpfPaid = 0;

                item.assignAmt = 0;
                item.billAmt   = AUIGrid.getCellValue(targetOutSrvcMstGridID, i ,"packageCharge");
                item.billDt   = "1900-01-01";
                item.billGrpId = 0;
                item.billId = 0;
                item.billNo = AUIGrid.getCellValue(targetOutSrvcMstGridID, i ,"quotNo");
                item.billStatus = "";
                item.billTypeId = 164;
                item.billTypeNm   = "Membership Package";
                item.custNm   = AUIGrid.getCellValue(targetOutSrvcMstGridID, i ,"custName");
                item.discountAmt = 0;
                item.installment  = 0;
                item.ordId = AUIGrid.getCellValue(targetOutSrvcMstGridID, i ,"ordId");
                item.ordNo = AUIGrid.getCellValue(targetOutSrvcMstGridID, i ,"ordNo");
                item.paidAmt     = AUIGrid.getCellValue(targetOutSrvcMstGridID, i ,"packagePaid");
                item.targetAmt   = packageAmt;
                item.srvcContractID   = 0;
                item.billAsId    = 0;
                item.srvMemId   =AUIGrid.getCellValue(targetOutSrvcMstGridID, i ,"cnvrMemId");
                item.trNo =  $("#outSrvckeyInTrNo").val() ;
                item.trDt =  $("#outSrvckeyInTrIssueDate").val() ;
                item.collectorCode = $("#outSrvckeyInCollMemCd").val() ;
                item.collectorId = $("#outSrvckeyInCollMemId").val() ;
                item.allowComm = $("#outSrvccashIsCommChk").val() ;
                item.refDtlsJPayRef = $("#outSrvcRefDtlsJompay").val(); // CREDIT CARD KEY IN IS NOT USING THIS PART

                AUIGrid.addRow(targetFinalBillGridID, item, "last");
                addedCount++;
            }

            var filterAmt = AUIGrid.getCellValue(targetOutSrvcMstGridID, i ,"filterCharge") - AUIGrid.getCellValue(targetOutSrvcMstGridID, i ,"filterPaid");

            if(filterAmt > 0){
                var item = new Object();
                item.procSeq = maxSeq;
                item.appType = "OUT_MEM";
                item.advMonth = 0;
                item.mstRpf = 0;
                item.mstRpfPaid = 0;

                item.assignAmt = 0;
                item.billAmt   = AUIGrid.getCellValue(targetOutSrvcMstGridID, i ,"filterCharge");
                item.billDt   = "1900-01-01";
                item.billGrpId = 0;
                item.billId = 0;
                item.billNo = AUIGrid.getCellValue(targetOutSrvcMstGridID, i ,"quotNo");
                item.billStatus = "";
                item.billTypeId = 542;
                item.billTypeNm   = "Filter (1st BS)";
                item.custNm   = AUIGrid.getCellValue(targetOutSrvcMstGridID, i ,"custName");
                item.discountAmt = 0;
                item.installment  = 0;
                item.ordId = AUIGrid.getCellValue(targetOutSrvcMstGridID, i ,"ordId");
                item.ordNo = AUIGrid.getCellValue(targetOutSrvcMstGridID, i ,"ordNo");
                item.paidAmt     = AUIGrid.getCellValue(targetOutSrvcMstGridID, i ,"filterPaid");
                item.targetAmt   = filterAmt;
                item.srvcContractID   = 0;
                item.billAsId    = 0;
                item.srvMemId   =AUIGrid.getCellValue(targetOutSrvcMstGridID, i ,"cnvrMemId");
                item.trNo =  $("#outSrvckeyInTrNo").val() ;
	            item.trDt =  $("#outSrvckeyInTrIssueDate").val() ;
	            item.collectorCode = $("#outSrvckeyInCollMemCd").val() ;
	            item.collectorId = $("#outSrvckeyInCollMemId").val() ;
	            item.allowComm = $("#outSrvccashIsCommChk").val() ;
	            item.refDtlsJPayRef = $("#outSrvcRefDtlsJompay").val(); // CREADIT CARD KEY IN IS NOT USING THIS PART

                AUIGrid.addRow(targetFinalBillGridID, item, "last");
                addedCount++;
            }
        }
    }


    if(addedCount == 0){
        Common.alert("<spring:message code='pay.alert.noBillingData'/>");
    }

    recalculatePaymentTotalAmt();
    $("#outSrvckeyInTrNo").clearForm() ;
    $("#outSrvckeyInTrIssueDate").clearForm() ;
}


// Add 할때 중복된 건이 있는지 체크한다.
function isDupOutSrvcToFinal(){
    var rowCnt = AUIGrid.getRowCount(targetOutSrvcMstGridID);
    var addedRows = AUIGrid.getRowsByValue(targetFinalBillGridID,"appType","OUT_MEM");
    var dupCnt = 0;

    if(rowCnt > 0){
        for(i = 0 ; i < rowCnt ; i++){
            var packageAmt = AUIGrid.getCellValue(targetOutSrvcMstGridID, i ,"packageCharge") - AUIGrid.getCellValue(targetOutSrvcMstGridID, i ,"packagePaid");

            if(packageAmt > 0){
                if(addedRows.length > 0) {
                    for(addedIdx = 0 ; addedIdx < addedRows.length ; addedIdx++){
                        if (AUIGrid.getCellValue(targetOutSrvcMstGridID, i ,"quotNo") == addedRows[addedIdx].billNo && 164 == addedRows[addedIdx].billTypeId) {
                            dupCnt++;
                        }
                    }
                }
            }

            var filterAmt = AUIGrid.getCellValue(targetOutSrvcMstGridID, i ,"filterCharge") - AUIGrid.getCellValue(targetOutSrvcMstGridID, i ,"filterPaid");

            if(filterAmt > 0){
                if(addedRows.length > 0) {
                    for(addedIdx = 0 ; addedIdx < addedRows.length ; addedIdx++){
                        if (AUIGrid.getCellValue(targetOutSrvcMstGridID, i ,"quotNo") == addedRows[addedIdx].billNo && 542 == addedRows[addedIdx].billTypeId) {
                            dupCnt++;
                        }
                    }
                }
            }
        }
    }

    return dupCnt;
}

//**************************************************
//**************************************************
//Care Service 관련 Script  -- CREATED BY TPY 28/03/2019
//**************************************************
//USING X2 - ADVANCE KEY IN IS NOT USING THIS PART
//Search Order 팝업
function fn_careSrvcOrderSearchPop(){
    resetOutGrid();
    Common.popupDiv("/homecare/sales/orderSearchPop.do", {callPrgm : "CARESRVC_PAYMENT", indicator : "SearchOrder"});
}

//USING X2 - ADVANCE KEY IN IS NOT USING THIS PART
//Search Order 팝업에서 결과값 받기
function fn_callBackCareSrvcOrderInfo(ordNo, ordId){

    //Order Basic 정보 조회
    Common.ajax("GET", "/payment/selectHTOrderBasicInfoByOrderId.do", {"orderId" : ordId}, function(result) {
        $("#careSrvcOrdId").val(result.ordId);
        $("#careSrvcOrdNo").val(result.ordNo);

        //Order Info 및 Payment Info 조회
        fn_careSrvcOrderInfo();
    });
}

//USING X2 - ADVANCE KEY IN IS NOT USING THIS PART
//Care Service Order Info 조회
function fn_careSrvcOrderInfo(){
    var data;
    data = {"orderId" : $("#careSrvcOrdId").val() };

    //Outright : Order 정보 조회
    Common.ajax("GET", "/payment/common/selectHTOrderInfoNonRental.do", data, function(result) {
        //Outright : Order Info 세팅
        AUIGrid.setGridData(targetCareSrvcMstGridID, result);

        //총 금액 계산
        recalculateCareSrvcTotalAmt();
    });
}


//USING X2 - ADVANCE KEY IN IS NOT USING THIS PART
//Care Service Amount 계산
function recalculateCareSrvcTotalAmt(){
  var rowCnt = AUIGrid.getRowCount(targetCareSrvcMstGridID);
  var totalAmt = 0;

  if(rowCnt > 0){
      for(var i = 0; i < rowCnt; i++){
          totalAmt += (AUIGrid.getCellValue(targetCareSrvcMstGridID, i ,"packageCharge") - AUIGrid.getCellValue(targetCareSrvcMstGridID, i ,"packagePaid"))
                      +(AUIGrid.getCellValue(targetCareSrvcMstGridID, i ,"filterCharge") - AUIGrid.getCellValue(targetCareSrvcMstGridID, i ,"filterPaid"));
      }
  }

  $("#careSrvcTotalAmtTxt").text("RM " + $.number(totalAmt,2));
}

//USING X2 - ADVANCE KEY IN IS NOT USING THIS PART
function resetCareSrvcGrid(){
  AUIGrid.clearGridData(targetCareSrvcMstGridID);
}


//USING X2 - ADVANCE KEY IN IS NOT USING THIS PART
function addCareSrvcToFinal(){
  var addedCount = 0;

  if(isDupCareSrvcToFinal() > 0){
      Common.alert("<spring:message code='pay.alert.keyin.add.dup'/>");
      return;
  }

  if($("#careSrvccashIsCommChk").is(":checked") == true){
      $("#careSrvccashIsCommChk").val("1");
  }else{
      $("#careSrvccashIsCommChk").val("0");
  }

  var rowCnt = AUIGrid.getRowCount(targetCareSrvcMstGridID);
  maxSeq = maxSeq + 1;

  if(rowCnt > 0){
      for(i = 0 ; i < rowCnt ; i++){

          if(rowCnt < 2){
              var salesOrdId = AUIGrid.getCellValue(targetCareSrvcMstGridID, i ,"srvOrdId");
              Common.ajax("GET", "/payment/common/checkHTOrderOutstanding.do", {salesOrdId : salesOrdId}, function(RESULT) {

                  if(RESULT.rootState == 'ROOT_1') {

                      Common.alert('No Outstanding' + DEFAULT_DELIMITER + RESULT.msg);
                  }
              });
          }

          var packageAmt = AUIGrid.getCellValue(targetCareSrvcMstGridID, i ,"packageCharge") - AUIGrid.getCellValue(targetCareSrvcMstGridID, i ,"packagePaid");

          if(packageAmt > 0){
              var item = new Object();
              item.procSeq = maxSeq;
              item.appType = "CARE_SRVC";
              item.advMonth = 0;
              item.mstRpf = 0;
              item.mstRpfPaid = 0;

              item.assignAmt = 0;
              item.billAmt   = AUIGrid.getCellValue(targetCareSrvcMstGridID, i ,"packageCharge");
              item.billDt   = "1900-01-01";
              item.billGrpId = 0;
              item.billId = 0;
              item.billNo = AUIGrid.getCellValue(targetCareSrvcMstGridID, i ,"quotNo");
              item.billStatus = "";
              item.billTypeId = 164;
              item.billTypeNm   = "Membership Package";
              item.custNm   = AUIGrid.getCellValue(targetCareSrvcMstGridID, i ,"custNm");
              item.discountAmt = 0;
              item.installment  = 0;
              item.ordId = AUIGrid.getCellValue(targetCareSrvcMstGridID, i ,"srvOrdId");
              item.ordNo = AUIGrid.getCellValue(targetCareSrvcMstGridID, i ,"srvOrdNo");
              item.paidAmt     = AUIGrid.getCellValue(targetCareSrvcMstGridID, i ,"packagePaid");
              item.targetAmt   = packageAmt;
              item.srvcContractID   = 0;
              item.billAsId    = 0;
              item.srvMemId   =AUIGrid.getCellValue(targetCareSrvcMstGridID, i ,"cnvrMemId");
              item.trNo =  $("#careSrvckeyInTrNo").val() ;
              item.collectorCode = $("#careSrvckeyInCollMemCd").val() ;
              item.collectorId = $("#careSrvckeyInCollMemId").val() ;
              item.allowComm = $("#careSrvccashIsCommChk").val() ;
              item.refDtlsJPayRef = $("#careSrvcRefDtlsJompay").val(); // CREDIT CARD KEY IN IS NOT USING THIS PART

              AUIGrid.addRow(targetFinalBillGridID, item, "last");
              addedCount++;
          }

          var filterAmt = AUIGrid.getCellValue(targetCareSrvcMstGridID, i ,"filterCharge") - AUIGrid.getCellValue(targetCareSrvcMstGridID, i ,"filterPaid");

          if(filterAmt > 0){
              var item = new Object();
              item.procSeq = maxSeq;
              item.appType = "CARE_SRVC";
              item.advMonth = 0;
              item.mstRpf = 0;
              item.mstRpfPaid = 0;

              item.assignAmt = 0;
              item.billAmt   = AUIGrid.getCellValue(targetCareSrvcMstGridID, i ,"filterCharge");
              item.billDt   = "1900-01-01";
              item.billGrpId = 0;
              item.billId = 0;
              item.billNo = AUIGrid.getCellValue(targetCareSrvcMstGridID, i ,"quotNo");
              item.billStatus = "";
              item.billTypeId = 542;
              item.billTypeNm   = "Filter (1st BS)";
              item.custNm   = AUIGrid.getCellValue(targetCareSrvcMstGridID, i ,"custNm");
              item.discountAmt = 0;
              item.installment  = 0;
              item.ordId = AUIGrid.getCellValue(targetCareSrvcMstGridID, i ,"srvOrdId");
              item.ordNo = AUIGrid.getCellValue(targetCareSrvcMstGridID, i ,"srvOrdNo");
              item.paidAmt     = AUIGrid.getCellValue(targetCareSrvcMstGridID, i ,"filterPaid");
              item.targetAmt   = filterAmt;
              item.srvcContractID   = 0;
              item.billAsId    = 0;
              item.srvMemId   =AUIGrid.getCellValue(targetCareSrvcMstGridID, i ,"cnvrMemId");
              item.trNo =  $("#careSrvckeyInTrNo").val() ;
              item.collectorCode = $("#careSrvckeyInCollMemCd").val() ;
              item.collectorId = $("#careSrvckeyInCollMemId").val() ;
              item.allowComm = $("#careSrvccashIsCommChk").val() ;
              item.refDtlsJPayRef = $("#careSrvcRefDtlsJompay").val(); // CREDIT CARD KEY IN IS NOT USING THIS PART

              AUIGrid.addRow(targetFinalBillGridID, item, "last");
              addedCount++;
          }
      }
  }


  if(addedCount == 0){
      Common.alert("<spring:message code='pay.alert.noBillingData'/>");
  }

  recalculatePaymentTotalAmt();

}


//USING X2 - ADVANE KEY IN IS NOT USING THIS PART
// Add 할때 중복된 건이 있는지 체크한다.
function isDupCareSrvcToFinal(){
  var rowCnt = AUIGrid.getRowCount(targetCareSrvcMstGridID);
  var addedRows = AUIGrid.getRowsByValue(targetFinalBillGridID,"appType","CARE_SRVC");
  var dupCnt = 0;

  if(rowCnt > 0){
      for(i = 0 ; i < rowCnt ; i++){
          var packageAmt = AUIGrid.getCellValue(targetCareSrvcMstGridID, i ,"packageCharge") - AUIGrid.getCellValue(targetCareSrvcMstGridID, i ,"packagePaid");

          if(packageAmt > 0){
              if(addedRows.length > 0) {
                  for(addedIdx = 0 ; addedIdx < addedRows.length ; addedIdx++){
                      if (AUIGrid.getCellValue(targetCareSrvcMstGridID, i ,"srvOrdNo") == addedRows[addedIdx].ordNo && 164 == addedRows[addedIdx].billTypeId) {
                          dupCnt++;
                      }
                  }
              }
          }

          var filterAmt = AUIGrid.getCellValue(targetCareSrvcMstGridID, i ,"filterCharge") - AUIGrid.getCellValue(targetCareSrvcMstGridID, i ,"filterPaid");

          if(filterAmt > 0){
              if(addedRows.length > 0) {
                  for(addedIdx = 0 ; addedIdx < addedRows.length ; addedIdx++){
                      if (AUIGrid.getCellValue(targetCareSrvcMstGridID, i ,"srvOrdNo") == addedRows[addedIdx].ordNo && 542 == addedRows[addedIdx].billTypeId) {
                          dupCnt++;
                      }
                  }
              }
          }
      }
  }

  return dupCnt;
}


$.fn.clearForm = function() {
    return this.each(function() {
        var type = this.type, tag = this.tagName.toLowerCase();
        if (tag === 'form'){
            return $(':input',this).clearForm();
        }
        if (type === 'text' || type === 'password' || type === 'hidden' || type === 'file' || tag === 'textarea'){
            this.value = '';
        }else if (type === 'checkbox' || type === 'radio'){
            this.checked = false;
        }else if (tag === 'select'){
            this.selectedIndex = 0;
        }
    });
};
</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->
    <header class="pop_header"><!-- pop_header start -->
        <h1>Search Order</h1>
        <ul class="right_opt">
            <li><p class="btn_blue2"><a href="#"><spring:message code="newWebInvoice.btn.close" /></a></p></li>
        </ul>
    </header><!-- pop_header end -->
    <section class="pop_body" style="min-height: auto;"><!-- pop_body start -->

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
                            <select id="appType" name="appType" onChange="javascript:fn_chgAppType();" class="readonly" >
                                  <option value="1">Rental</option>
					              <option value="2">Outright</option>
					              <option value="3">Rental Membership</option>
					              <option value="4">Bill Payment</option>
					              <option value="5">Outright Membership</option>
					              <option value="6">Care Service</option>
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
                <input type="hidden" name="rentalMegaDeal" id="rentalMegaDeal" />

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
                                <input type="text" id="genAdvAmt" name="genAdvAmt" title="General Advance Amount" size="15" class="wAuto ml5 readonly"  readonly onkeydown='return FormUtil.onlyNumber(event)' />
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
                        </tr>
                        <tr>
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
    *************                                          Outright Membership Payment Area                                      ****
    ***************************************************************************************
    ***************************************************************************************
    -->
    <section id="outSrvcSearch" style="display:none;">
        <!-- search_table start -->
        <section class="search_table">
            <!-- search_table start -->
            <form id="outSrvcSearchForm" action="#" method="post">
                <input type="hidden" name="outSrvcOrdId" id="outSrvcOrdId" />
                <input type="hidden" name="outSrvcQuotId" id="outSrvcQuotId" />
                <input type="hidden" name="outSrvcOrdNo" id="outSrvcOrdNo" />
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
                            <th scope="row">Quotation No</th>
                            <td class="w100p">
                                <input type="text" name="outSrvcQuotNo" id="outSrvcQuotNo" title="" placeholder="Quotation Number" class="readonly" readonly />
                                    <p class="btn_sky">
                                        <a href="javascript:fn_quotationSearchPop();" id="search">Search</a>
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
           <li><p class="btn_grid"><a href="javascript:addOutSrvcToFinal();">ADD</a></p></li>
        </ul>

        <!-- grid_wrap start -->
        <article class="grid_wrap">
            <div id="target_outSrvc_grid_wrap" style="width: 100%; height: 210px; margin: 0 auto;"></div>
        </article>
        <!-- grid_wrap end -->

        <ul class="right_btns">
            <li><p class="amountTotalSttl">Amount Total :</p></li>
            <li><strong id="outSrvcTotalAmtTxt">RM 0.00</strong></li>
        </ul>
    </section>



    <!--
    ***************************************************************************************
    ***************************************************************************************
    *************                                          Care Services Search Area                                                         ****
    ***************************************************************************************
    ***************************************************************************************
    -->
    <section id="careSrvcSearch" style="display:none;">
        <!-- search_table start -->
        <section class="search_table">
            <!-- search_table start -->
            <form id="careSrvcSearchForm" action="#" method="post">
                <input type="hidden" name="careSrvcOrdId" id="careSrvcOrdId" />

                <table class="type1">
                    <caption>table</caption>
                    <colgroup>
                        <col style="width:180px" />
                        <col style="width:*" />
                    </colgroup>
                    <tbody>
                        <tr>
                            <th scope="row">Service Order No.</th>
                            <td>
                                <input type="text" name="careSrvcOrdNo" id="careSrvcOrdNo" title="" placeholder="Order Number" class="" />
                                 <%--    <p class="btn_sky">
                                        <a href="javascript:fn_outConfirm();" id="confirm"><spring:message code='pay.btn.confirm'/></a>
                                    </p> --%>
                                    <p class="btn_sky">
                                        <a href="javascript:fn_careSrvcOrderSearchPop();" id="search"><spring:message code='sys.btn.search'/></a>
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
           <li><p class="btn_grid"><a href="javascript:addCareSrvcToFinal();"><spring:message code='pay.btn.add'/></a></p></li>
        </ul>

        <!-- grid_wrap start -->
        <article class="grid_wrap">
            <div id="target_careSrvc_grid_wrap" style="width: 100%; height: 210px; margin: 0 auto;"></div>
        </article>
        <!-- grid_wrap end -->


        <ul class="right_btns">
            <li><p class="amountTotalSttl">Amount Total :</p></li>
            <li><strong id="careSrvcTotalAmtTxt">RM 0.00</strong></li>
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

    <!-- search_table start -->
    <section class="search_table mt10">
        <!-- search_table start -->
        <form id="paymentForm" action="#" method="post">
            <input type="hidden" name="keyInPayRoute" id="keyInPayRoute" value="WEB" />
            <input type="hidden" name="keyInScrn" id="keyInScrn" value="CRC" />
            <input type="hidden" name="keyInAppTypeId" id="keyInAppTypeId" value="${appTypeId}" />
<!--             <input type="hidden" name="keyInAppTypeId" id="keyInAppTypeId" value="1" /> -->


            <!-- table end -->
        </form>
    </section>

     <!--
    ***************************************************************************************
    ***************************************************************************************
    *************                                          Key In  Area   END          ****
    ***************************************************************************************
    ***************************************************************************************
    -->


        <ul class="center_btns">
            <li><p class="btn_blue"><a href="javascript:fn_apply();"><spring:message code='pay.btn.apply'/></a></p></li>
        </ul>
    </section>
</div>