<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javascript">
//get Order Id
$(document).ready(function() {
	
    //confirm click
    $("#_confirm").click(function() {
    	
    	Common.showLoader();
        var inputNum = $("#_salesOrderNo").val();
        fn_getOrderId(inputNum);
        
    });
    
    //Order No Search
    $("#_ordSearch").click(function() {
		Common.popupDiv('/sales/ccp/searchOrderNoPop.do' , $('#_searchForm').serializeJSON(), null , true, '_searchDiv');
	});
	
});

function fn_getOrderId(ordNum){
    
    $.ajax({
        
        type : "GET",
        url : getContextPath() + "/sales/ccp/getOrderId",
        contentType: "application/json;charset=UTF-8",
        crossDomain: true,
        data: {salesOrderNo : ordNum},
        dataType: "json",
        success : function (data) {
            
            var ordId = data.ordId;
            
            $("#salesOrderId").val(ordId);
            $("#_searchForm").attr({"target": "_self" , "action" : getContextPath()+"/sales/ccp/getOrderDetailInfo.do" }).submit();
            
        },
        error : function (data) {
        	Common.removeLoader();
            if(data == null){               //error
                Common.alert("fail to Load DB");
            }else{                            // No data
                Common.alert("No order found or this order.");
            }
            
            
        }
    });
}
</script>
<div id="wrap"><!-- wrap start -->
<hr />
        

<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>Sales</li>
    <li>Order list</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>New Government Agreement</h2>
</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id="_searchForm">
<input id="salesOrderId" name="salesOrderId" type="hidden" >
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Order No</th>
    <td><input type="text" title="" placeholder="" class="" id="_salesOrderNo" name="salesOrderNo" /><p class="btn_sky"><a href="#" id="_confirm">Cofirm</a></p><p class="btn_sky"><a href="#" id="_ordSearch">Search</a></p></td>
</tr>
</tbody>
</table><!-- table end -->

<%-- <aside class="link_btns_wrap"><!-- link_btns_wrap start -->
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
</aside><!-- link_btns_wrap end --> --%>

</form>
</section><!-- search_table end -->

</section><!-- content end -->

<hr />

</div><!-- wrap end -->
