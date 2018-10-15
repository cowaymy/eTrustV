<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">

var staffClaimGridID;

/* =============================================
 * Staff Claim List Grid Design -- Start
 * =============================================
 */
var staffClaimGridPros = {
    usePaging : true,
    pageRowCount : 20,
    headerHeight : 40,
    selectionMode : "multipleCells"
};

var staffClaimColumnLayout = [ {
    dataField : "memAccId",
    headerText : '<spring:message code="staffClaim.staffCode" />'
}, {
    dataField : "memAccName",
    headerText : '<spring:message code="staffClaim.staffName" />',
    style : "aui-grid-user-custom-left"
}, {
    dataField : "clmMonth",
    headerText : '<spring:message code="pettyCashExp.clmMonth" />',
    dataType : "date",
    formatString : "mm/yyyy"
}, {
    dataField : "clmNo",
    headerText : '<spring:message code="invoiceApprove.clmNo" />'
}, {
    dataField : "reqstDt",
    headerText : '<spring:message code="pettyCashRqst.rqstDt" />',
    dataType : "date",
    formatString : "dd/mm/yyyy"
}, {
    dataField : "cur",
    headerText : '<spring:message code="newWebInvoice.cur" />'
}, {
    dataField : "totAmt",
    headerText : '<spring:message code="webInvoice.amount" />',
    style : "aui-grid-user-custom-right",
    dataType: "numeric",
    formatString : "#,##0.00"
}, {
    dataField : "appvPrcssNo",
    visible : false
}, {
    dataField : "appvPrcssStusCode",
    visible : false
}, {
    dataField : "appvPrcssStus",
    headerText : '<spring:message code="webInvoice.status" />',
    style : "aui-grid-user-custom-left"
}, {
    dataField : "appvPrcssDt",
    headerText : '<spring:message code="pettyCashRqst.appvalDt" />',
    dataType : "date",
    formatString : "dd/mm/yyyy"
}
];

/* =============================================
 * Staff Claim List Grid Design -- End
 * =============================================
 */

$(document).ready(function() {
    console.log("testList :: ready :: start");

    staffClaimGridID = AUIGrid.create("#staffClaim_grid_wrap", staffClaimColumnLayout, staffClaimGridPros);

    $("#newExpStaffClaim").click(fn_NewClaimPop);
    console.log("testList :: ready :: end");
});

function fn_NewClaimPop() {
    console.log("testList :: fn_NewClaimPop :: start");

    Common.popupDiv("/test/newPop.do", {callType:"new"}, null, true, "newStaffClaimPop");

    console.log("testList :: fn_NewClaimPop :: end");
}

function fn_closeNewClaimPop() {
    console.log("testList :: fn_closeNewClaimPop :: start");

    $("#newStaffClaimPop").remove();

    console.log("testList :: fn_closeNewClaimPop :: end");
}

function fn_selectStaffClaimList() {
    console.log("testList :: fn_selectStaffClaimList :: start");

    Common.ajax("GET", "/eAccounting/staffClaim/selectStaffClaimList.do?_cacheId=" + Math.random(), $("#form_staffClaim").serialize(), function(result) {
        console.log(result);
        AUIGrid.setGridData(staffClaimGridID, result);
    });

    console.log("testList :: fn_selectStaffClaimList :: end");
}

</script>

<!-- --------------------------------------DESIGN------------------------------------------------ -->

<form id="dataForm">
    <input type="hidden" id="reportFileName" name="reportFileName" value="/e-accounting/StaffClaim.rpt" /><!-- Report Name  -->
    <input type="hidden" id="viewType" name="viewType" value="PDF" /><!-- View Type  -->

    <input type="hidden" id="_repClaimNo" name="v_CLM_NO" />
</form>

<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on"><spring:message code="webInvoice.fav" /></a></p>
<h2><spring:message code="staffClaim.title" /></h2>
<ul class="right_btns">
    <%-- <c:if test="${PAGE_AUTH.funcView == 'Y'}"> --%>
    <li><p class="btn_blue"><a href="#" onclick="javascript:fn_selectStaffClaimList()"><span class="search"></span><spring:message code="webInvoice.btn.search" /></a></p></li>
    <%-- </c:if> --%>
    <!-- <li><p class="btn_blue"><a href="#"><span class="clear"></span>Clear</a></p></li> -->
</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id="form_staffClaim">
<input type="hidden" id="memAccName" name="memAccName">

<table class="type1"><!-- table start -->
<caption><spring:message code="webInvoice.table" /></caption>
<colgroup>
    <col style="width:110px" />
    <col style="width:*" />
    <col style="width:110px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="pettyCashExp.clmMonth" /></th>
    <td><input type="text" title="Create start Date" placeholder="MM/YYYY" class="j_date2" id="clmMonth" name="clmMonth"/></td>
    <th scope="row"><spring:message code="staffClaim.staffCode" /></th>
    <td><input type="text" title="" placeholder="" class="" id="memAccId" name="memAccId"/><a href="#" class="search_btn" id="search_supplier_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a></td>
</tr>
<tr>
    <th scope="row" ><spring:message code="webInvoice.status" /></th>
    <td>
    <select class="multy_select" multiple="multiple" id="appvPrcssStus" name="appvPrcssStus">
        <option value="T"><spring:message code="webInvoice.select.tempSave" /></option>
        <option value="R"><spring:message code="webInvoice.select.request" /></option>
        <option value="P"><spring:message code="webInvoice.select.progress" /></option>
        <option value="A"><spring:message code="webInvoice.select.approved" /></option>
        <option value="J"><spring:message code="pettyCashRqst.rejected" /></option>
    </select>
    </td>
    <th scope="row"><spring:message code="invoiceApprove.clmNo" /></th>
    <td><input type="text" title="" placeholder="" class="" id="clmNo" name="clmNo"/></td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="link_btns_wrap"><!-- link_btns_wrap start -->
    <p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
    <dl class="link_list">
        <dt>Link</dt>
        <dd>
        <ul class="btns">
            <%-- <c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}"> --%>
            <li><p class="link_btn"><a href="#" id="_staffClaimBtn">Staff Claim</a></p></li>
            <%-- </c:if> --%>
            <li><p class="link_btn"><a href="#" id="newExpStaffClaim">New Staff Claim (Submission Only)</a></p></li>
        </ul>
        <ul class="btns">
        </ul>
        <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
        </dd>
    </dl>
    </aside><!-- link_btns_wrap end -->

</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<ul class="right_btns">
    <%-- <c:if test="${PAGE_AUTH.funcChange == 'Y'}"> --%>
    <li><p class="btn_grid"><a href="#" id="newClaimBtn"><spring:message code="pettyCashExp.newExpClm" /></a></p></li>
    <%-- </c:if> --%>
</ul>

<article class="grid_wrap" id="staffClaim_grid_wrap"><!-- grid_wrap start -->
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- content end -->