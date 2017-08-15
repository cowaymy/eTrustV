<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<script type="text/javaScript">
//AUIGrid 그리드 객체
var myGridID;

// 화면 초기화 함수 (jQuery 의 $(document).ready(function() {}); 과 같은 역할을 합니다.
$(document).ready(function(){
    // AUIGrid 그리드를 생성합니다.
    //myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout);
    
    /*var auiGridProps = {
            selectionMode : "multipleCells",
            enableSorting : true,               // 정렬 사용            
            editable : true,                       // 편집 가능 여부 (기본값 : false)
            enableMovingColumn : true,      // 칼럼 이동 가능 설정
            wrapSelectionMove : true         // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부            
    };

    // 그리드 생성
    myGridID = AUIGrid.create("#grid_wrap", columnLayout, auiGridProps);*/
    
    var gridPros = {
            // 편집 가능 여부 (기본값 : false)
            editable : false,
            
            // 상태 칼럼 사용
            showStateColumn : false
    };
	myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout,null,gridPros);
    
});

// AUIGrid 칼럼 설정
var columnLayout = [ 
    {
        dataField : "reconciliationNo",
        headerText : "Transaction No",
        editable : false
    }, {
        dataField : "depositPaymentDate",
        headerText : "Ref Date",
        editable : false
    }, {
        dataField : "depositBranchCode",
        headerText : "Branch",
        editable : true
    }, {
        dataField : "depositAccountCode",
        headerText : "Account",
        editable : true
    }, {
        dataField : "reconciliationStatus",
        headerText : "Status",
        editable : true
    }, {
        dataField : "reconciliationRemark",
        headerText : "Remark",
        editable : true
    }, {
        dataField : "reconciliationCreated",
        headerText : "Created",
        editable : true
    }, {
        dataField : "reconciliationCreatorName",
        headerText : "Creator",
        editable : true
    }, {
        dataField : "reconciliationApproveAt",
        headerText : "Updated",
        editable : true
    }, {
        dataField : "reconciliationApproverName",
        headerText : "Updator",
        editable : true
    }];
    
// ajax list 조회.
    function searchList()
    {
    	   Common.ajax("GET","/payment/searchReconciliationList.do",$("#searchForm").serialize(), function(result){
    		AUIGrid.setGridData(myGridID, result);
    	});
    }
</script>

<!-- content start -->
<section id="content">
    <ul class="path">
        <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
        <li>Payment</li>
        <li>Reconciliation</li>
        <li>Reconciliation Search</li>
    </ul>

    <!-- title_line start -->
    <aside class="title_line">
        <p class="fav"><a href="#" class="click_add_on">My menu</a></p>
        <h2>Reconciliation Search</h2>       
    </aside>
    <!-- title_line end -->
    
    <!-- search_table start -->
    <section class="search_table">
        <form name="searchForm" id="searchForm">
            <!-- table start -->
            <table class="type1">
                <caption>search table</caption>
                <colgroup>
                    <col style="width:144px" />
                    <col style="width:*" />
                    <col style="width:144px" />
                    <col style="width:*" />
                </colgroup>
                <tbody>
                    <tr>
                        <th scope="row">Transaction No.</th>
                        <td><input type="text" title="Reference No." id="tranNo" name="tranNo" /></td>
                        <th scope="row">Bank Account</th>
                        <td>
                            <select id="bankAccount" name="bankAccount">
                                <option value="" selected>Select Account</option>
                                <c:forEach var="bankList" items="${ bankComboList}" varStatus="status">
                                    <option value="${bankList.accId}">${bankList.accDesc2}</option>
                                </c:forEach>                                
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Branch Code</th>
                        <td>
                            <select id="branchList" name="branchList">
                                    <option value="" selected>Branch</option>
                                    <c:forEach var="brnList" items="${ branchList}" varStatus="status">
                                        <option value="${brnList.brnchId}">${brnList.codeAndName}</option>
                                    </c:forEach>
                                </select>
                        </td>
                        <th scope="row">Payment Date</th>
                        <td>
                            <div class="date_set"><!-- date_set start -->
                                <p><input type="text"  name="paymentDate1" id="paymentDate1" title="Payment Date From" placeholder="DD/MM/YYYY" class="j_date" /></p>
                            <span>To</span>
                            <p><input type="text"  name="paymentDate2" id="paymentDate2" title="Payment Date To" placeholder="DD/MM/YYYY" class="j_date" /></p>
                            </div><!-- date_set end -->
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Status</th>
                        <td>
                            <select  id="status" name="status" class="multy_select" multiple="multiple">
						        <option value="44">Pending</option>
						        <option value="6">Rejected</option>
						        <option value="10">Cancelled</option>
						        <option value="5">Approved</option>
						    </select>
                        </td>
                        <th scope="row"></th>
                        <td>
                        </td>
                    </tr>
                </tbody>
            </table>
            <!-- table end -->

            <ul class="right_btns">
                <li><p class="btn_gray"><a href="#" onClick="searchList()"><span class="search"></span>Search</a></p></li>
            </ul>
        </form>
    </section>
    <!-- search_table end -->

    <!-- search_result start -->
    <section class="search_result">
        
        <!-- link_btns_wrap start -->
        <aside class="link_btns_wrap">
            <p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
            <dl class="link_list">
                <dt>Link</dt>
                <dd>
                    <ul class="btns">
                        <li><p class="link_btn"><a href="#">menu1</a></p></li>
                        <li><p class="link_btn"><a href="#">menu2</a></p></li>
                        <li><p class="link_btn"><a href="#">menu3</a></p></li>
                        <li><p class="link_btn"><a href="#">menu4</a></p></li>
                        <li><p class="link_btn"><a href="#">Search Payment</a></p></li>
                        <li><p class="link_btn"><a href="#">menu6</a></p></li>
                        <li><p class="link_btn"><a href="#">menu7</a></p></li>
                        <li><p class="link_btn"><a href="#">menu8</a></p></li>
                    </ul>
                    <ul class="btns">
                        <li><p class="link_btn type2"><a href="#">menu1</a></p></li>
                        <li><p class="link_btn type2"><a href="#">Search Payment</a></p></li>
                        <li><p class="link_btn type2"><a href="#">menu3</a></p></li>
                        <li><p class="link_btn type2"><a href="#">menu4</a></p></li>
                        <li><p class="link_btn type2"><a href="#">Search Payment</a></p></li>
                        <li><p class="link_btn type2"><a href="#">menu6</a></p></li>
                        <li><p class="link_btn type2"><a href="#">menu7</a></p></li>
                        <li><p class="link_btn type2"><a href="#">menu8</a></p></li>
                    </ul>
                    <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
                </dd>
            </dl>
        </aside>
        <!-- link_btns_wrap end -->
        
        <!-- grid_wrap start -->
        <article id="grid_wrap" class="grid_wrap"></article>
        <!-- grid_wrap end -->

    </section>
    <!-- search_result end -->

</section>
<!-- content end -->