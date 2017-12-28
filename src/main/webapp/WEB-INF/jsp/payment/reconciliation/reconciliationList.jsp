<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<script type="text/javaScript">

var myGridID;

$(document).ready(function(){
    var gridPros = {
            // 편집 가능 여부 (기본값 : false)
            editable : false,
            
            // 상태 칼럼 사용
            showStateColumn : false
    };
    
	myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout,null,gridPros);

	doGetComboSepa('/common/selectBranchCodeList.do', '1' , ' - '  ,'' , 'branchList' , 'S', '');//Branch생성
    doGetCombo('/common/getAccountList.do', 'CASH' , ''   , 'bankAccount' , 'S', '');
});

// AUIGrid 칼럼 설정
var columnLayout = [ 
    {
        dataField : "reconciliationNo",
        headerText : "<spring:message code='pay.head.transactionNo'/>",
        editable : false
    }, {
        dataField : "depositPaymentDate",
        headerText : "<spring:message code='pay.head.refDate'/>",
        editable : false
    }, {
        dataField : "depositBranchCode",
        headerText : "<spring:message code='pay.head.branch'/>",
        editable : true
    }, {
        dataField : "depositAccountCode",
        headerText : "<spring:message code='pay.head.account'/>",
        editable : true
    }, {
        dataField : "reconciliationStatus",
        headerText : "<spring:message code='pay.head.status'/>",
        editable : true
    }, {
        dataField : "reconciliationRemark",
        headerText : "<spring:message code='pay.head.remark'/>",
        editable : true
    }, {
        dataField : "reconciliationCreated",
        headerText : "<spring:message code='pay.head.created'/>",
        editable : true
    }, {
        dataField : "reconciliationCreatorName",
        headerText : "<spring:message code='pay.head.creator'/>",
        editable : true
    }, {
        dataField : "reconciliationApproveAt",
        headerText : "<spring:message code='pay.head.updated'/>",
        editable : true
    }, {
        dataField : "reconciliationApproverName",
        headerText : "<spring:message code='pay.head.updator'/>",
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
    </ul>

    <!-- title_line start -->
    <aside class="title_line">
        <p class="fav"><a href="#" class="click_add_on"><spring:message code='pay.text.myMenu'/></a></p>
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
                        <td><input type="text" title="Reference No." id="tranNo" name="tranNo" class="w100p"/></td>
                        <th scope="row">Bank Account</th>
                        <td>
                            <select id="bankAccount" name="bankAccount" class="w100p">                               
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Branch Code</th>
                        <td>
                            <select id="branchList" name="branchList" class="w100p"></select>
                        </td>
                        <th scope="row">Payment Date</th>
                        <td>
                            <div class="date_set w100p"><!-- date_set start -->
                                <p><input type="text"  name="paymentDate1" id="paymentDate1" title="Payment Date From" placeholder="DD/MM/YYYY" class="j_date" /></p>
                            <span>To</span>
                            <p><input type="text"  name="paymentDate2" id="paymentDate2" title="Payment Date To" placeholder="DD/MM/YYYY" class="j_date" /></p>
                            </div><!-- date_set end -->
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Status</th>
                        <td>
                            <select  id="status" name="status" class="multy_select w100p" multiple="multiple">
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
                <li><p class="btn_gray"><a href="#" onClick="searchList()"><span class="search"></span><spring:message code='sys.btn.search'/></a></p></li>
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