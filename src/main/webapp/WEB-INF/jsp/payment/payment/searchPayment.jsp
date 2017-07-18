<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
    
<script type="text/javaScript">

//AUIGrid 그리드 객체
var myGridID,subGridID;

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
    
   
    
    //Grid Properties 설정 
    var gridPros = {            
            editable : false,                 // 편집 가능 여부 (기본값 : false)
            showStateColumn : false     // 상태 칼럼 사용
    };
    
    // Order 정보 (Master Grid) 그리드 생성
    myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout,null,gridPros);
    
    
    // Master Grid 셀 클릭시 이벤트
    AUIGrid.bind(myGridID, "cellClick", function( event ){ 
    	
    	// Payment (Slave Grid) 그리드 생성
        subGridID = GridCommon.createAUIGrid("grid_sub_wrap", slaveColumnLayout,null,gridPros);
    	
    	$("#payId").val(AUIGrid.getCellValue(myGridID , event.rowIndex , "payId"));
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
	{ dataField:"keyinUserName" ,headerText:"UserName" ,editable : false }
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


// 리스트 조회.
function fn_getOrderListAjax() {        
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
				        <li><p class="link_btn"><a href="#">RC By BS</a></p></li>
				        <li><p class="link_btn"><a href="#">Daily Collection Raw</a></p></li>
				        <li><p class="link_btn"><a href="#">Late Submission Raw</a></p></li>
				        <li><p class="link_btn"><a href="#">Official Receipt</a></p></li>				        
				    </ul>
				    <ul class="btns">
				        <li><p class="link_btn type2"><a href="#">Veiw Details</a></p></li>
				        <li><p class="link_btn type2"><a href="#">Edit Details</a></p></li>
				        <li><p class="link_btn type2"><a href="#">Fund Transfer</a></p></li>
				        <li><p class="link_btn type2"><a href="#">Reverse Payment(Void)</a></p></li>
				        <li><p class="link_btn type2"><a href="#">Refund</a></p></li>				        
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
<!-- content end -->
<form name="detailForm" id="detailForm"  method="post">
    <input type="hidden" name="payId" id="payId" />
</form>      
