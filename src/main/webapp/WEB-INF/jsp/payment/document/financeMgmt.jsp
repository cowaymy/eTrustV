<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>

<script type="text/javaScript">


$(document).ready(function(){

});

//크리스탈 레포트
function fn_generateStatement(){
	
	if(FormUtil.checkReqValue($("#orderNo")) &&  FormUtil.checkReqValue($("#billNo"))){
        Common.alert('* Please key in either RET No or Order No. <br>');
        return;
    }
	
	Common.ajax("POST", "/payment/selectPenaltyBillDate.do", $("#searchForm").serializeJSON(), function(result) {
		if(result != null && result.length > 0) {
			var year = result[0].billDtYear;
			var month = result[0].billDtMonth;
			
			if(year < 2017 || (year == 2015 && month < 4)){
				//report form에 parameter 세팅
			    $("#reportPDFForm #v_orderNo").val($('#orderNo').val());
			    $("#reportPDFForm #v_billNo").val($('#billNo').val());
			    
			    //report 호출
			    var option = {
			           isProcedure : true, // procedure 로 구성된 리포트 인경우 필수.
			    };
			    
			    Common.report("reportPDFForm", option);
			
			}else{
				location.href = "/payment/initTaxInvoiceMiscellaneous.do";				
			}
        }else{
        	location.href = "/payment/initTaxInvoiceMiscellaneous.do";
        }			    
	    
    });
}
</script>
<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="../images/common/path_home.gif" alt="Home" /></li>
    <li>Sales</li>
    <li>Order list</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>Finance Management</h2>
</aside><!-- title_line end -->


<article class="acodi_wrap"><!-- acodi_wrap start -->
<dl>
    <dt class="click_add_on on"><a href="#">Receive List Management</a></dt>
    <dd>
    <ul class="right_btns">
        <li><p class="btn_blue"><a href="#"><span class="search"></span>Search</a></p></li>
        <li><p class="btn_blue"><a href="#"><span class="clear"></span>Clear</a></p></li>
    </ul>

    <table class="type1 mt10"><!-- table start -->
    <caption>table</caption>
    <colgroup>
        <col style="width:170px" />
        <col style="width:*" />
        <col style="width:170px" />
        <col style="width:*" />
        <col style="width:160px" />
        <col style="width:*" />
    </colgroup>
    <tbody>
    <tr>
        <th scope="row">Paymode</th>
        <td>
        <select class="w100p disabled" disabled="disabled">
            <option value="">11</option>
            <option value="">22</option>
            <option value="">33</option>
        </select>
        </td>
        <th scope="row">Is Online</th>
        <td>
        <select class="multy_select w100p" multiple="multiple">
            <option value="1">11</option>
            <option value="2">22</option>
            <option value="3">33</option>
        </select>
        </td>
        <th scope="row">Merchant ID</th>
        <td>
        <input type="text" title="" placeholder="Merchant ID" class="w100p" />
        </td>
    </tr>
    <tr>
        <th scope="row">Reference Date</th>
        <td>
        <input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p" />
        </td>
        <th scope="row">Credit Card Number</th>
        <td>
        <input type="text" title="" placeholder="Credit Card Number" class="w100p" />
        </td>
        <th scope="row">Card Holder Name</th>
        <td>
        <input type="text" title="" placeholder="Card Holder Name" class="w100p" />
        </td>
    </tr>
    <tr>
        <th scope="row">Approval Number</th>
        <td>
        <input type="text" title="" placeholder="Approval Number" class="w100p" />
        </td>
        <th scope="row">Credit Card Type</th>
        <td>
        <select class="w100p">
            <option value="">11</option>
            <option value="">22</option>
            <option value="">33</option>
        </select>
        </td>
        <th scope="row">Issue Bank</th>
        <td>
        <select class="w100p">
            <option value="">11</option>
            <option value="">22</option>
            <option value="">33</option>
        </select>
        </td>
    </tr>
    <tr>
        <th scope="row">Payment Date</th>
        <td colspan="3">

        <div class="date_set"><!-- date_set start -->
        <p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
        <span>To</span>
        <p><input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
        </div><!-- date_set end -->

        </td>
        <th scope="row">Key-In Branch</th>
        <td>
        <select class="w100p">
            <option value="">11</option>
            <option value="">22</option>
            <option value="">33</option>
        </select>
        </td>
    </tr>
    <tr>
        <th scope="row">Batch No</th>
        <td>
        <input type="text" title="" placeholder="Batch No" class="w100p" />
        </td>
        <th scope="row">Batch Status</th>
        <td>
        <select class="multy_select w100p" multiple="multiple">
            <option value="1">11</option>
            <option value="2">22</option>
            <option value="3">33</option>
        </select>
        </td>
        <th scope="row">Item Status</th>
        <td>
        <select class="multy_select w100p" multiple="multiple">
            <option value="1">11</option>
            <option value="2">22</option>
            <option value="3">33</option>
        </select>
        </td>
    </tr>
    <tr>
        <th scope="row">Batch Create Date</th>
        <td colspan="3">

        <div class="date_set"><!-- date_set start -->
        <p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
        <span>To</span>
        <p><input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
        </div><!-- date_set end -->

        </td>
        <th scope="row">Batch Creator</th>
        <td>
        <input type="text" title="" placeholder="Batch Creator" class="w100p" />
        </td>
    </tr>
    <tr>
        <th scope="row">Settlement Account</th>
        <td colspan="5">
        <select>
            <option value="">11</option>
            <option value="">22</option>
            <option value="">33</option>
        </select>
        </td>
    </tr>
    </tbody>
    </table><!-- table end -->

    </dd>
    <dt class="click_add_on"><a href="#">Pending List Management</a></dt>
    <dd>
    <ul class="right_btns">
        <li><p class="btn_blue"><a href="#"><span class="search"></span>Search</a></p></li>
        <li><p class="btn_blue"><a href="#"><span class="clear"></span>Clear</a></p></li>
    </ul>

    <table class="type1 mt10"><!-- table start -->
    <caption>table</caption>
    <colgroup>
        <col style="width:170px" />
        <col style="width:*" />
        <col style="width:170px" />
        <col style="width:*" />
        <col style="width:160px" />
        <col style="width:*" />
    </colgroup>
    <tbody>
    <tr>
        <th scope="row">Paymode</th>
        <td>
        <select class="w100p disabled" disabled="disabled">
            <option value="">11</option>
            <option value="">22</option>
            <option value="">33</option>
        </select>
        </td>
        <th scope="row">Is Online</th>
        <td>
        <select class="multy_select w100p" multiple="multiple">
            <option value="1">11</option>
            <option value="2">22</option>
            <option value="3">33</option>
        </select>
        </td>
        <th scope="row">Merchant ID</th>
        <td>
        <input type="text" title="" placeholder="Merchant ID" class="w100p" />
        </td>
    </tr>
    <tr>
        <th scope="row">Reference Date</th>
        <td>
        <input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p" />
        </td>
        <th scope="row">Credit Card Number</th>
        <td>
        <input type="text" title="" placeholder="Credit Card Number" class="w100p" />
        </td>
        <th scope="row">Card Holder Name</th>
        <td>
        <input type="text" title="" placeholder="Card Holder Name" class="w100p" />
        </td>
    </tr>
    <tr>
        <th scope="row">Approval Number</th>
        <td>
        <input type="text" title="" placeholder="Approval Number" class="w100p" />
        </td>
        <th scope="row">Credit Card Type</th>
        <td>
        <select class="w100p">
            <option value="">11</option>
            <option value="">22</option>
            <option value="">33</option>
        </select>
        </td>
        <th scope="row">Issue Bank</th>
        <td>
        <select class="w100p">
            <option value="">11</option>
            <option value="">22</option>
            <option value="">33</option>
        </select>
        </td>
    </tr>
    <tr>
        <th scope="row">Payment Date</th>
        <td colspan="3">

        <div class="date_set"><!-- date_set start -->
        <p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
        <span>To</span>
        <p><input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
        </div><!-- date_set end -->

        </td>
        <th scope="row">Key-In Branch</th>
        <td>
        <select class="w100p">
            <option value="">11</option>
            <option value="">22</option>
            <option value="">33</option>
        </select>
        </td>
    </tr>
    <tr>
        <th scope="row">Settlement Account</th>
        <td colspan="5">
        <select>
            <option value="">11</option>
            <option value="">22</option>
            <option value="">33</option>
        </select>
        </td>
    </tr>
    </tbody>
    </table><!-- table end -->

    </dd>
</dl>
</article><!-- acodi_wrap end -->

<div class="divine_auto mt30"><!-- divine_auto start -->

<div style="width:55%;">

<div class="border_box"><!-- border_box start -->

<aside class="title_line"><!-- title_line start -->
<h3 class="pt0">WReceive List - Credit Card (Offline) </h3>
</aside><!-- title_line end -->

<article class="grid_wrap"><!-- grid_wrap start -->
그리드 영역
</article><!-- grid_wrap end -->

<div class="side_btns"><!-- side_btns start -->
<ul class="left_btns">
    <li>New</li>
    <li class="yellow_text">Resend </li>
    <li class="pink_text">Review </li>
    <li class="green_text">Complete </li>
    <li class="orange_text">Incomplete</li>
</ul>
<ul class="right_btns">
    <li>Ctrl + Click : for multiple selection</li>
</ul>
</div><!-- side_btns end -->

</div><!-- border_box end -->

</div>

<div style="width:45%;">

<div class="border_box"><!-- border_box start -->

<aside class="title_line"><!-- title_line start -->
<h3 class="pt0">Credit Card (Online/Offline)</h3>
</aside><!-- title_line end -->

<article class="grid_wrap"><!-- grid_wrap start -->
그리드 영역
</article><!-- grid_wrap end -->

<ul class="right_btns">
    <li>Pending : Waiting for admin management</li>
</ul>

</div><!-- border_box end -->

</div>

</div><!-- divine_auto end -->

<aside class="title_line mt30"><!-- title_line start -->
<h3 class="pt0">Document Control Log</h3>
</aside><!-- title_line end -->

<article class="grid_wrap"><!-- grid_wrap start -->
그리드 영역
</article><!-- grid_wrap end -->

<aside class="link_btns_wrap"><!-- link_btns_wrap start -->
<p class="show_btn"><a href="#"><img src="../images/common/btn_link.gif" alt="link show" /></a></p>
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
    <p class="hide_btn"><a href="#"><img src="../images/common/btn_link_close.gif" alt="hide" /></a></p>
    </dd>
</dl>
</aside><!-- link_btns_wrap end -->

</section><!-- content end -->

<aside class="bottom_msg_box"><!-- bottom_msg_box start -->
<p>Information Message Area</p>
</aside><!-- bottom_msg_box end -->

