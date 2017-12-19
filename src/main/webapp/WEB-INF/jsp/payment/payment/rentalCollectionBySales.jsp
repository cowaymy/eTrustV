<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<style type="text/css">
/* 커스텀 행 스타일 */
.my-column-style2 div{
    color:#ff0000;
    font-weight:bold;
}
</style>
<script type="text/javaScript">
var myGridID;

$(document).ready(function(){

    myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout,null,gridPros);
});
var gridPros = {
        editable: false,
        showStateColumn: false
};


var columnLayout=[
    {dataField:"orgcode", headerText:"<spring:message code='pay.head.orgCode'/>"},
    {dataField:"grpcode", headerText:"<spring:message code='pay.head.grpCode'/>"},
    {dataField:"deptcode", headerText:"<spring:message code='pay.head.deptCode'/>"},
    {dataField:"membercode", headerText:"<spring:message code='pay.head.codyCode'/>"},
    {dataField:"sunit", headerText:"<spring:message code='pay.head.unit'/>", dataType:"numeric"},
    {dataField:"slmos", headerText:"<spring:message code='pay.head.preOut'/>", dataType:"numeric", formatString:"###0.#"},
    {dataField:"scmchg", headerText:"<spring:message code='pay.head.charges'/>", dataType:"numeric", formatString:"###0.#"},
    {dataField:"sclctg", headerText:"<spring:message code='pay.head.target'/>", dataType:"numeric", formatString:"###0.#"},
    {dataField:"scol", headerText:"<spring:message code='pay.head.collection'/>", dataType:"numeric", formatString:"###0.#"},
    {dataField:"sadj", headerText:"<spring:message code='pay.head.adjustment'/>", dataType:"numeric"},
    {dataField:"sout", headerText:"<spring:message code='pay.head.outstanding'/>", dataType:"numeric", formatString:"###0.#"},
    {dataField:"srate", headerText:"<spring:message code='pay.head.outRate'/>", dataType:"numeric", formatString:"###0.00", style:"my-column-style2"}
    ];

//리스트 조회.
function fn_getOrderListAjax() {        
    Common.ajax("GET", "/payment/selectSalesList", $("#salesForm").serialize(), function(result) {
        AUIGrid.setGridData(myGridID, result);
    });
}

function fn_clear(){
    $("#salesForm")[0].reset();
}
</script>

<!-- content start -->
<section id="content">
    <ul class="path">
        <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
        <li>Payment</li>
        <li>Rental Collection</li>
        <li>RC By Sales</li>
    </ul>
    
    <!-- title_line start -->
    <aside class="title_line">
        <p class="fav"><a href="#" class="click_add_on">My menu</a></p>
        <h2>RC By Sales</h2>   
        <ul class="right_btns">
            <li><p class="btn_blue"><a href="javascript:fn_getOrderListAjax();"><span class="search"></span><spring:message code='sys.btn.search'/></a></p></li>
            <li><p class="btn_blue"><a href="javascript:fn_clear();"><span class="clear"></span><spring:message code='sys.btn.clear'/></a></p></li>
        </ul>    
    </aside>
    <!-- title_line end -->


 <!-- search_table start -->
    <section class="search_table">
        <form name="salesForm" id="salesForm"  method="post">

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
                        <th scope="row">ORG Code</th>
                        <td>
                            <input id="orgCode" name="orgCode" type="text" title="Org Code" placeholder="Org Code" class="w100p" />
                        </td>
                        <th scope="row">Grp Code</th>
                        <td>
                           <input id="Grp Code" name="grpCode" type="text" title="Grp Code" placeholder="Grp Code" class="w100p" />
                        </td>
                        <th scope="row">Dept Code</th>
                        <td>
                           <input id="dept Code" name="deptCode" type="text" title="Dept Code" placeholder="Dept Code" class="w100p" />
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Member Code</th>
                        <td>
                            <input id="memberCode" name="memberCode" type="text" title="Member Code" placeholder="Member Code" class="w100p" />
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
        </form>
        </section>

 <!-- search_result start -->
<section class="search_result">     
    <!-- grid_wrap start -->
    <article id="grid_wrap" class="grid_wrap"></article>
    <!-- grid_wrap end -->
</section>
</section>
