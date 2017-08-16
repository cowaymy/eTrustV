<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
    
<script type="text/javaScript">

//AUIGrid 그리드 객체
var myGridID;

//Grid에서 선택된 RowID
var selectedGridValue;

//Default Combo Data
var invoiceTypeData = [{"codeId": "1267","codeName": "Company Type Invoice"},{"codeId": "1268","codeName": "Individual Type Invoice"}];

// 화면 초기화 함수 (jQuery 의 $(document).ready(function() {}); 과 같은 역할을 합니다.
$(document).ready(function(){    
    //메인 페이지
    doDefCombo(invoiceTypeData, '' ,'invoiceType', 'S', '');        //Claim Type 생성
    
    //Grid Properties 설정 
    var gridPros = {            
            editable : false,                 // 편집 가능 여부 (기본값 : false)
            showStateColumn : false     // 상태 칼럼 사용
    };
    
    // Order 정보 (Master Grid) 그리드 생성
    myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout,null,gridPros);
    
    // Master Grid 셀 클릭시 이벤트
    AUIGrid.bind(myGridID, "cellClick", function( event ){ 
        selectedGridValue = event.rowIndex;
    });  
});


// AUIGrid 칼럼 설정
var columnLayout = [
    { dataField:"taxInvcRefNo" ,headerText:"BR No.",width: 200 , editable : false },
    { dataField:"invcItmOrdNo" ,headerText:"Order No.",width: 200 , editable : false },
    { dataField:"taxInvcCustName" ,headerText:"Customer Name", editable : false },
    { dataField:"taxInvcRefDt" ,headerText:"Invoice Date",width: 200 ,editable : false , dataType : "date", formatString : "dd-mm-yyyy"},
    { dataField:"invcItmRentalFee" ,headerText:"Invoice Amount",width: 200 , dataType : "numeric", formatString : "#,##0.#"},
    { dataField:"invcItmInstlmtNo" ,headerText:"Inst No.",width: 200 , editable : false }
    ];
      
                          
// 리스트 조회.
function fn_getTaxInvoiceListAjax() {   
	
	if(FormUtil.checkReqValue($("#invoiceType option:selected")) ){
        Common.alert('* Please select the Invoice Type. <br/>');
        return;
    }
	
    Common.ajax("POST", "/payment/selectTaxInvoiceRentalList.do", $("#searchForm").serializeJSON(), function(result) {
        AUIGrid.setGridData(myGridID, result);
    });
}

</script>

<!-- content start -->
<section id="content">
    <ul class="path">
        <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
        <li>Billing</li>
        <li>Billing Group</li>
        <li>Tax Invoice - Rental</li>
    </ul>

    <!-- title_line start -->
    <aside class="title_line">
        <p class="fav"><a href="#" class="click_add_on">My menu</a></p>
        <h2>Tax Invoice - Rental</h2>
        <ul class="right_btns">
            <li><p class="btn_blue"><a href="javascript:fn_getTaxInvoiceListAjax();"><span class="search"></span>Search</a></p></li>
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
                    <col style="width:140px" />
                    <col style="width:*" />                    
                </colgroup>
                <tbody>
                    <tr>
                        <th scope="row">Invoice Type</th>
                        <td colspan="3">
                            <select id="invoiceType" name="invoiceType" class="w100p"></select>
                        </td>                        
                    </tr>
                    <tr>
                        <th scope="row">BR No.</th>
                        <td>
                            <input type="text" id="brNo" name="brNo" title="BR No." placeholder="BR No." class="w100p" />                           
                        </td>
                       <th scope="row">Invoice Period</th>
                        <td>
                           <input type="text" id="invoicePeriod" name="invoicePeriod"  title="Invoice Period" placeholder="Invoice Period" class="j_date2 w100p" />
                        </td>                        
                    </tr>
                    <tr>
                        <th scope="row">Order No.</th>
                        <td>
                           <input type="text" id="orderNo" name="orderNo" title="Order No." placeholder="Order No." class="w100p" />
                        </td>
                        <th scope="row">Customer Name</th>
                        <td>
                            <input type="text" id="custName" name="custName" title="Customer Name" placeholder="Customer Name." class="w100p" />
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
                        <li><p class="link_btn"><a href="javascript:fn_openDivPop('VIEW');">Generate Invoice</a></p></li>                                                                
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
<!-- content end --> 
