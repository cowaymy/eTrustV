<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javascript">
//get Order Id
$(document).ready(function() {
    
    //confirm click
    $("#_confirm").click(function() {
        
     //   Common.showLoader();
        var inputNum = $("#_salesOrderNo").val();
      //  fn_getOrderId(inputNum);
        var ordParam = {salesOrderNo : inputNum};
        var ajaxOpt = {
        		async : false
        };
        Common.ajax("GET", "/sales/ccp/getOrderId", ordParam, function(result){
            var ordId = result.ordId;
            $("#salesOrderId").val(ordId);
        },'',ajaxOpt);
        
        Common.popupDiv("/sales/ccp/newCcpAgreementSearchResultPop.do", $("#_searchForm_").serializeJSON(), null , true , '_newInsDiv');
        
    });
    
    //Order No Search
    $("#_ordSearch").click(function() {
        Common.popupDiv('/sales/ccp/searchOrderNoPop.do' , $('#_searchForm_').serializeJSON(), null , true, '_searchDiv');
    });
    
});

/* function fn_getOrderId(ordNum){
    
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
            
            //$("#_searchForm_").attr({"target": "_self" , "action" : getContextPath()+"/sales/ccp/getOrderDetailInfo.do" }).submit();
            
            
            
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
} */
</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->
<header class="pop_header"><!-- pop_header start -->
<h1>CCP Agreement New Search</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->
<section class="pop_body"><!-- pop_body start -->

<!-- <aside class="title_line">title_line start
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>New Government Agreement</h2>
</aside>title_line end -->

<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id="_searchForm_">
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

</div><!-- popup_wrap end -->
