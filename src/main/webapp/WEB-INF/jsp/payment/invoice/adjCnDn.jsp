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
    { dataField:"code" ,headerText:"Type" ,editable : false , visible : false},
    { dataField:"memoItmTxs" ,headerText:"Adjustment Taxes" ,editable : false  , visible : false},
    { dataField:"memoItmChrg" ,headerText:"Adjustment Charges" ,editable : false  , visible : false},
    { dataField:"memoAdjRptNo" ,headerText:"Report No." ,editable : false  , visible : false},

    { dataField:"memoAdjRefNo" ,headerText:"CN/DN No." ,editable : false },
    { dataField:"memoAdjInvcNo" ,headerText:"Invoice No." ,editable : false },
    { dataField:"invcItmOrdNo" ,headerText:"Order No." ,editable : false},
    { dataField:"memoItmAmt" ,headerText:"Adjustment Amount(RM)" ,editable : false },
    { dataField:"resnDesc" ,headerText:"Reason" ,editable : false },
    { dataField:"userName" ,headerText:"Requestor" ,editable : false },
    { dataField:"deptName" ,headerText:"Department" ,editable : false },
    { dataField:"memoAdjCrtDt" ,headerText:"Request Create Date" ,editable : false },    
    { dataField:"code1" ,headerText:"Status" ,editable : false },
    { dataField:"memoAdjRem" ,headerText:"Remark" ,editable : false }
    ];

// 리스트 조회.
function fn_getAdjustmentListAjax() {
	AUIGrid.destroy(subGridID);//subGrid 초기화
    Common.ajax("GET", "/payment/selectAdjustmentList.do", $("#searchForm").serialize(), function(result) {
        AUIGrid.setGridData(myGridID, result);
    });
}

function fn_cmmSearchInvoicePop(){
    Common.popupDiv('/payment/common/initCommonSearchInvoicePop.do', null, null , true ,'_searchInvoice');
}

function _callBackInvoicePop(searchInvoicePopGridID,rowIndex, columnIndex, value, item){
    alert(AUIGrid.getCellValue(searchInvoicePopGridID, rowIndex, "taxInvcId"));
    alert(AUIGrid.getCellValue(searchInvoicePopGridID, rowIndex, "taxInvcRefNo"));
    
    $('#_searchInvoice').hide();
    
}
</script>

<!-- content start -->
<section id="content">
    <ul class="path">
        <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
        <li>Payment</li>
        <li>Invoice/Statement</li>
        <li>Adjustment (CN/DN)</li>
    </ul>

    <!-- title_line start -->
    <aside class="title_line">
        <p class="fav"><a href="#" class="click_add_on">My menu</a></p>
        <h2>Invoice Adjustment (CN / DN)</h2>
        <ul class="right_btns">
            <li><p class="btn_blue"><a href="javascript:fn_getAdjustmentListAjax();"><span class="search"></span>Search</a></p></li>
        </ul>
    </aside>
    <!-- title_line end -->

    <!-- search_table start -->
    <section class="search_table">
        <form name="searchForm" id="searchForm"  method="post">
            <table class="type1"><!-- table start -->
                <caption>table</caption>
				<colgroup>
				    <col style="width:180px" />
				    <col style="width:*" />
				    <col style="width:180px" />
				    <col style="width:*" />				    
				</colgroup>
				<tbody>
				    <tr>
				        <th scope="row">Order No.</th>
					    <td>
					       <input id="orderNo" name="orderNo" type="text" placeholder="Order No." class="w100p" />
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
					    <th scope="row">Adjustment No.</th>
                        <td>
                           <input id="adjNo" name="adjNo" type="text" placeholder="Adjustment No." class="w100p" />
                        </td>
                    </tr>
                    <tr>
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
                        <li><p class="link_btn"><a href="javascript:fn_cmmSearchInvoicePop();">New CN/DN request</a></p></li>
                        <li><p class="link_btn"><a href="/payment/initRentalCollectionBySales.do">New Batch request</a></p></li>
                        <li><p class="link_btn"><a href="/payment/initRentalCollectionByBS.do">Generate Summary List</a></p></li>
                        <li><p class="link_btn"><a href="/payment/initDailyCollection.do">Approval</a></p></li>                                                                      
                    </ul>
                    <ul class="btns">                                 
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


