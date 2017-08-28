<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
    
<script type="text/javaScript">

var myGridID,subGridID;

//Grid Properties 설정 
var gridPros = {            
        editable : false,                 // 편집 가능 여부 (기본값 : false)
        showStateColumn : false     // 상태 칼럼 사용
};

// 화면 초기화 함수 (jQuery 의 $(document).ready(function() {}); 과 같은 역할을 합니다.
$(document).ready(function(){
	myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout,null,gridPros);
});

var columnLayout=[
    { dataField:"memoAdjRefNo" ,headerText:"Adjustment No." ,editable : false },
    { dataField:"code" ,headerText:"Type" ,editable : false },
    { dataField:"memoAdjInvcNo" ,headerText:"Invoice No." ,editable : false },
    { dataField:"invcItmOrdNo" ,headerText:"Order No." ,editable : false, formatString : "dd-mm-yyyy" },
    { dataField:"code1" ,headerText:"Status" ,editable : false },
    { dataField:"memoItmTxs" ,headerText:"Adjustment Taxes" ,editable : false },
    { dataField:"memoItmChrg" ,headerText:"Adjustment Charges" ,editable : false },
    { dataField:"memoItmAmt" ,headerText:"Adjustment Amount" ,editable : false },
    { dataField:"resnDesc" ,headerText:"Reason" ,editable : false },
    { dataField:"memoAdjRptNo" ,headerText:"Report No." ,editable : false },
    { dataField:"userName" ,headerText:"Creator" ,editable : false },
    { dataField:"memoAdjCrtDt" ,headerText:"Created" ,editable : false }
    ];

// 리스트 조회.
function fn_getOrderListAjax() {
	AUIGrid.destroy(subGridID);//subGrid 초기화
    Common.ajax("GET", "/payment/selectAdjustmentList.do", $("#searchForm").serialize(), function(result) {
        AUIGrid.setGridData(myGridID, result);
    });
}
</script>

<!-- content start -->
<section id="content">
    <ul class="path">
        <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
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
						    <input id="orderNo" name="orderNo" type="text" placeholder="Order No." class="w100p" />
					    </td>
					    <th scope="row">Adjustment No.</th>
					    <td>
					       <input id="adjNo" name="adjNo" type="text" placeholder="Adjustment No." class="w100p" />
					    </td>
					    <th scope="row">Adjustment Status</th>
					    <td>
					       <select id="status" name="status" class="w100p">		
					           <option value="1">Active</option>
					           <option value="4">Completed</option>
					           <option value="21">Failed</option>		          
                           </select>
					    </td>
					</tr>
					<tr>
					    <th scope="row">Invoice No.</th>
					    <td>
					       <input id="invoiceNo" name="invoiceNo" type="text" placeholder="Invoice No." class="w100p" />
					    </td>
					   <th scope="row">Report No.</th>
                        <td>
                           <input id="reportNo" name="reportNo" type="text" placeholder="report No." class="w100p" />
                        </td>
					    <th scope="row">Creator</th>
					    <td>
					       <input id="creator" name="creator" type="text" placeholder="Creator" class="w100p">                               
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
                        <li><p class="link_btn"><a href="/payment/initPaymentListing.do">Payment Listing</a></p></li>
                        <li><p class="link_btn"><a href="/payment/initRentalCollectionBySales.do">RC By Sales</a></p></li>
                        <li><p class="link_btn"><a href="/payment/initRentalCollectionByBS.do">RC By BS</a></p></li>
                        <li><p class="link_btn"><a href="/payment/initDailyCollection.do">Daily Collection Raw</a></p></li>
                        <li><p class="link_btn"><a href="/payment/initLateSubmission.do">Late Submission Raw</a></p></li>
                        <li><p class="link_btn"><a href="javascript:fn_officialReceiptReport();">Official Receipt</a></p></li>                                              
                    </ul>
                    <ul class="btns">
                        <li><p class="link_btn type2"><a href="javascript:fn_openDivPop('VIEW');">Veiw Details</a></p></li>
                        <li><p class="link_btn type2"><a href="javascript:fn_openDivPop('EDIT');">Edit Details</a></p></li>
                        <li><p class="link_btn type2"><a href="#">Fund Transfer</a></p></li>                        
                        <li><p class="link_btn type2"><a href="#">Refund</a></p></li>         
                    </ul>
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
        <!-- grid_wrap end -->
    </section>
    <!-- search_result end -->
</section>


