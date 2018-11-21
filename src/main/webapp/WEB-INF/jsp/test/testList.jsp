<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<link href="${pageContext.request.contextPath}/resources/css/select2.min.css" rel="stylesheet">
<script src ="${pageContext.request.contextPath}/resources/js/select2.min.js" type="text/javascript"></script>

<script type="text/javaScript">


/* =============================================
 * Staff Claim List Grid Design -- End
 * =============================================
 */

$(document).ready(function() {
    console.log("testList :: ready :: start");

    //staffClaimGridID = AUIGrid.create("#staffClaim_grid_wrap", staffClaimColumnLayout, staffClaimGridPros);

    //$("#newExpStaffClaim").click(fn_NewClaimPop);

    doGetComboAndGroup2('/common/selectProductCodeList.do', '', '', 'listProductId', 'S', '');//product 생성

    doGetComboAndGroup2('/common/selectProductCodeList.do', '', '', 'select2t1m', 'M', '');//product 생성
    $('.js-example-basic-multiple').select2();

    doGetComboAndGroup2('/common/selectProductCodeList.do', '', '', 'select2t1s', 'S', '');//product 생성
    $('.js-example-basic-single').select2();

    console.log("testList :: ready :: end");
});

function fn_selectStaffClaimList() {
    console.log("testList :: fn_selectStaffClaimList :: start");

    console.log($("#appvPrcssStus").val());
    console.log($("#select2t1").val());

    Common.ajax("GET", "/test/selectStaffClaimList.do?_cacheId=" + Math.random(), $("#form_staffClaim").serialize(), function(result) {
        console.log(result);
        AUIGrid.setGridData(staffClaimGridID, result);
    });

    console.log("testList :: fn_selectStaffClaimList :: end");
}

</script>

<!-- --------------------------------------DESIGN------------------------------------------------ -->

<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on"><spring:message code="webInvoice.fav" /></a></p>
<h2>TEST PAGE</h2>
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
    <col style="width:350px" />
    <col style="width:110px" />
    <col style="width:350px" />
</colgroup>
<tbody>
<tr>
    <th scope="row" >Product Original</th>
    <td>
    <select id="listProductId" name="productId" class="w100p"></select>
    </td>
</tr>
<tr>
    <th scope="row" >Product Multiple</th>
    <td>
    <select class="js-example-basic-multiple" id="select2t1m" name="select2t1m" multiple="multiple">
    </select>
    </td>
    <th scope="row" >Product Single</th>
    <td>
    <select class="js-example-basic-single" id="select2t1s" name="select2t1s">
    </select>
    </td>
</tr>
</tbody>
</table><!-- table end -->

</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

</section><!-- search_result end -->

</section><!-- content end -->