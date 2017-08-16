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
    {dataField:"salesOrdNo", headerText:"Order No"},
    {dataField:"codeName", headerText:"App Type"},
    {dataField:"salesDt", headerText:"Order Date"},
    {dataField:"name", headerText:"customerName"}
];

function fn_getOutrightInvoiceListAjax() {     
	
	console.log("appType : " + $("#appType").val());
	console.log($("searchForm").serialize());
	Common.ajax("GET", "/payment/selectOutrightInvoiceList ", $("#searchForm").serialize(), function(result) {
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
        <li>Outright Invoice</li>
    </ul>
    
    <!-- title_line start -->
    <aside class="title_line">
        <p class="fav"><a href="javascript:;" class="click_add_on">My menu</a></p>
        <h2>Outright Invoice</h2>   
        <ul class="right_btns">
            <li><p class="btn_blue"><a href="javascript:fn_getOutrightInvoiceListAjax();"><span class="search"></span>Search</a></p></li>
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
                        <th scope="row">Order Number</th>
                        <td colspan="3">
                            <input id="orderNo" name="orderNo" type="text" class="w100p" />
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Application Type</th>
                        <td>
                            <select id="appType" name="appType" class="multy_select" multiple="multiple">
                                <option value="67">Outright</option>
                                <option value="68">Installment</option>
                            </select>
                        </td>
                        <th scope="row">Customer Name</th>
                        <td>
                           <input id="custName" name="custName" type="text" class="w100p" />
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
                    </ul>-->
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

