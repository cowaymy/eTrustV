<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<script type="text/javaScript">

//AUIGrid 그리드 객체
var myGridID,subGridID;
var viewHistoryGridID;

//Grid에서 선택된 RowID
var selectedGridValue;

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
	{ dataField:"payItmCcExprDt" ,headerText:"<spring:message code='pay.head.CCExpiryDate'/>" ,editable : false },
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
			Common.popupDiv('/payment/initSearchPaymentViewPop.do', {"payId":$("#payId").val(), "salesOrdId" : $("#salesOrdId").val(),"callPrgm" : "SEARCH_PAYMENT_VIEW"}, null , true);
	   }else{
	       Common.alert("<spring:message code='pay.alert.searchFirst'/>");
	       return;
	   }

	}else if(val == "EDIT"){
		  if(selectedGridValue !=  undefined){
			  Common.popupDiv('/payment/initSearchPaymentEditPop.do', {"payId":$("#payId").val(), "salesOrdId" : $("#salesOrdId").val(),"callPrgm" : "SEARCH_PAYMENT_EDIT"}, null , true);
			 }else{
           Common.alert("<spring:message code='pay.alert.searchFirst'/>");
           return;
       }

    }else if(val == "EDITBASIC"){
        if(selectedGridValue !=  undefined){
            Common.popupDiv('/payment/initSearchPaymentEditBasicPop.do', {"payId":$("#payId").val(), "salesOrdId" : $("#salesOrdId").val(),"callPrgm" : "SEARCH_PAYMENT_EDIT"}, null , true);
           }else{
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

function fn_clear(){
    $("#searchForm")[0].reset();
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
                         <c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
                        <li><p class="link_btn"><a href="javascript:fn_openDivPop('EDITBASIC');">Edit Basic Info</a></p></li>
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

<form name="detailForm" id="detailForm"  method="post">
    <input type="hidden" name="payId" id="payId" />
    <input type="hidden" name="salesOrdId" id="salesOrdId" />
</form>

<!-- content end -->
<form name="reportPDFForm" id="reportPDFForm"  method="post">
    <input type="hidden" id="reportFileName" name="reportFileName" value="/payment/PaymentReceipt_New.rpt" />
    <input type="hidden" id="viewType" name="viewType" value="PDF" />
    <input type="hidden" id="v_ORNo" name="v_ORNo" />
</form>

<form name="trnsferForm" id="trnsferForm"  method="post">
    <input type="hidden" id="popPayId" name="popPayId" />
</form>

