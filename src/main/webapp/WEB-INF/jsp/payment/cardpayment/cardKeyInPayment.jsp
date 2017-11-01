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
	
	//Rental Billing Grid 에서 체크/체크 해제시
	AUIGrid.bind(targetRenDetGridID, "cellClick", function( event ){
		if(event.dataField == "btnCheck"){
			recalculateRentalTotalAmt();
		}
	});
	
	AUIGrid.bind(targetRenMstGridID, "cellClick", function(event) {
		changeRowStyleFunction(AUIGrid.getCellValue(targetRenMstGridID, event.rowIndex, "salesOrdNo"));
    }); 
	
});

//Search Order confirm
function fn_confirm(){
	
	resetGrid();
	
    var ordNo = $("#ordNo").val();
    
    if(ordNo != ''){
        //Order Basic 정보 조회
        Common.ajax("GET", "/payment/common/selectOrdIdByNo.do", {"ordNo" : ordNo}, function(result) {        
            if(result != null && result.salesOrdId != ''){
            	$("#ordId").val(result.salesOrdId);
                $("#ordNo").val(result.salesOrdNo);
                $("#billGrpId").val(result.custBillId);
                
            	//Order Info 및 Payment Info 조회
            	fn_rentalOrderInfo();
            }            
        });
    }
}


//Search Order 팝업
function fn_orderSearchPop(){
	resetGrid();
    Common.popupDiv("/sales/order/orderSearchPop.do", {callPrgm : "PAYMENT", indicator : "SearchOrder"});
}

//Search Order 팝업에서 결과값 받기
function fn_orderInfo(ordNo, ordId){
    
    //Order Basic 정보 조회
    Common.ajax("GET", "/payment/selectOrderBasicInfoByOrderId.do", {"orderId" : ordId}, function(result) {        
        $("#ordId").val(result.ordId);
        $("#ordNo").val(result.ordNo);
        $("#billGrpId").val(result.custBillId);
        
        //Order Info 및 Payment Info 조회
        fn_rentalOrderInfo();
    });
}

//Rental Order Info 조회
function fn_rentalOrderInfo(){
	var data; 
		
    if($("#isBillGroup").is(":checked")){
    	data = {"billGrpId" : $("#billGrpId").val() };
    }else{		
		data = {"orderId" : $("#ordId").val() };
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



function changeRowStyleFunction(srcOrdNo) {
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

function resetGrid(){
	AUIGrid.clearGridData(targetRenMstGridID);
    AUIGrid.clearGridData(targetRenDetGridID);
}

function checkBillGroup(){
	if($("#ordNo").val() != ''){
		fn_confirm();
	}
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
        <ul class="right_btns">
            <li><p class="btn_blue"><a href="javascript:fn_loadTargetOrderInfo();"><span class="search"></span>Search</a></p></li>
        </ul>
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
    
    <!-- search_table start -->
    <section class="search_table" id="rentalSearch">
        <!-- search_table start -->
        <form id="rentalSearchForm" action="#" method="post">
            <input type="text" name="ordId" id="ordId" />
            <input type="text" name="billGrpId" id="billGrpId" />
            <table class="type1">
                <caption>table</caption>
                <colgroup>
                    <col style="width:180px" />
                    <col style="width:200px" />
                    <col style="width:*" />                    
                </colgroup>
                <tbody>
                    <tr>
                        <th scope="row">Sales Order No.</th>
                        <td colspan="2">
                            <input type="text" name="ordNo" id="ordNo" title="" placeholder="Order Number" class="" />
                                <p class="btn_sky">
                                    <a href="javascript:fn_confirm();" id="confirm">Confirm</a>
                                </p>
                                <p class="btn_sky">
                                    <a href="javascript:fn_orderSearchPop();" id="search">Search</a>
                                </p>
                                <p class="btn_sky">
                                    <a href="" id="viewLedger">View Ledger</a>
                                </p>
                                <label><input type="checkbox" id="isBillGroup" name="isBillGroup" onClick="javascript:checkBillGroup();" /><span>include all orders' bills with same billing group </span></label>
                        </td>
                    </tr>
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
        <li><p class="amountTotalSttl">Amount Total :</p></li>
        <li><strong id="rentalTotalAmt">RM 0.00</strong></li>
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