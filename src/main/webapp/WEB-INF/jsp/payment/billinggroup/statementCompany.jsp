<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>

<script type="text/javaScript">
var myGridID;

$(document).ready(function(){
    myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout,null,gridPros);
    
});

var gridPros = {
        editable: false,
        showStateColumn: false,
        pageRowCount : 25
};

var columnLayout=[              
    {dataField:"year", headerText:"Year"},
    {dataField:"month", headerText:"Month"},
    {dataField:"stateItmRefNo", headerText:"Bill No."},
    {dataField:"stateItmOrdNo", headerText:"Order No."},
    {dataField:"stateCustName", headerText:"Customer No"}
];

function fn_getOrderListAjax() {        
	Common.ajax("GET", "/payment/selectStatementCompanyList", $("#searchForm").serialize(), function(result) {
    	AUIGrid.setGridData(myGridID, result);
    });
}

</script>

<!-- content start -->
<section id="content">
    <ul class="path">
        <li><img src="/resources/images/common/path_home.gif" alt="Home" /></li>
        <li>Billing</li>
        <li>Billing Group</li>
        <li>Company Invoice</li>
    </ul>
    
    <!-- title_line start -->
    <aside class="title_line">
        <p class="fav"><a href="javascript:;" class="click_add_on">My menu</a></p>
        <h2>Company Rental Statement of Account</h2>   
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
                    <col style="width:144px" />
                    <col style="width:*" />
                    <col style="width:144px" />
                    <col style="width:*" />
                </colgroup>
                <tbody>
                    <tr>
                        <th scope="row">Billing No.</th>
                        <td>
                            <input id="billNo" name="billNo" type="text" class="w100p" placeholder="Billing No. (EG: BR No./AOR No. /ACN No. /WOR No.)" />
                        </td>
                        <th scope="row">Statement Period</th>
                        <td>
                           <input type="text" name="period" title="기준년월" class="j_date2 w100p" placeholder="Statement Period"/>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Order No.</th>
                        <td>
                            <input id="orderNo" name="orderNo" type="text" class="w100p" placeholder="Order No."/>
                        </td>
                        <th scope="row" colspan="2"></th>
                    </tr>
                    <tr>
                        <th scope="row">Customer Name</th>
                        <td colspan="3">
                            <input id="custName" name="custName" type="text" class="w100p" placeholder="Customer Name"/>
                        </td>
                    </tr>
                    </tbody>
              </table>
        </form>
        </section>

 <!-- search_result start -->
<section class="search_result">     

    <!-- link_btns_wrap start -->
        <aside class="link_btns_wrap">
            <p class="show_btn"><a href="#"><img src="/resources/images/common/btn_link.gif" alt="link show" /></a></p>
            <dl class="link_list">
                <dt>Link</dt>
                <dd>
                    <ul class="btns">
                        <li><p class="link_btn"><a href="#">Statement Generate</a></p></li>
                    </ul>
                    <!-- <ul class="btns">
                        <li><p class="link_btn type2"><a href="#" onclick="javascript:showViewPopup()">Send E-Invoice</a></p></li>
                    </ul> -->
                    <p class="hide_btn"><a href="#"><img src="/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
                </dd>
            </dl>
        </aside>
        <!-- link_btns_wrap end -->
        
    <!-- grid_wrap start -->
    <article id="grid_wrap" class="grid_wrap"></article>
    <!-- grid_wrap end -->
</section>
</section>

