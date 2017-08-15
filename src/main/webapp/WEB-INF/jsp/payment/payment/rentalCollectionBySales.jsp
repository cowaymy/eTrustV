<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
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
    {dataField:"orgCode", headerText:"Org Code"},
    {dataField:"grpCode", headerText:"Grp Code"},
    {dataField:"deptCode", headerText:"Dept Code"},
    {dataField:"memberCode", headerText:"Cody Code"},
    {dataField:"sUnit", headerText:"Unit", dataType:"numeric"},
    {dataField:"sLMOS", headerText:"Pre-Out", dataType:"numeric", formatString:"###0.#"},
    {dataField:"sCMCHG", headerText:"Charges", dataType:"numeric", formatString:"###0.#"},
    {dataField:"sCLCTG", headerText:"Target", dataType:"numeric", formatString:"###0.#"},
    {dataField:"sCOL", headerText:"Collection", dataType:"numeric", formatString:"###0.#"},
    {dataField:"sADJ", headerText:"Adjsutment", dataType:"numeric"},
    {dataField:"sOUT", headerText:"Outstanding", dataType:"numeric", formatString:"###0.#"},
    {dataField:"sRate", headerText:"Out Rate", dataType:"numeric", formatString:"###0.##", style:"my-column-style2"}
    ];

//리스트 조회.
function fn_getOrderListAjax() {        
    Common.ajax("GET", "/payment/selectSalesList", $("#salesForm").serialize(), function(result) {
        AUIGrid.setGridData(myGridID, result);
    });
}
</script>

<!-- content start -->
<section id="content">
    <ul class="path">
        <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
        <li>Payment</li>
        <li>Rental Collection</li>
        <li>Organization By Sales Account</li>
    </ul>
    
    <!-- title_line start -->
    <aside class="title_line">
        <p class="fav"><a href="#" class="click_add_on">My menu</a></p>
        <h2>Organization By Sales Account</h2>   
        <ul class="right_btns">
            <li><p class="btn_blue"><a href="javascript:fn_getOrderListAjax();"><span class="search"></span>Search</a></p></li>
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
