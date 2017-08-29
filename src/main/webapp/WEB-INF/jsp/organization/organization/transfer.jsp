<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">

var memberTypeData = [{"codeId": "1","codeName": "Health Planner"},{"codeId": "2","codeName": "Coway Lady"},{"codeId": "3","codeName": "Coway Technician"}];

$(document).ready(function(){
    doDefCombo(memberTypeData, '' ,'memberType', 'S', '');   
    
    $("#memberType").change(function(){
    	doGetCombo('/organization/selectMemberLevel.do', $("#memberType").val() , ''   , 'memberLvl' , 'S', '');
    });
    $("#memberLvl").change(function(){
    	var jsonObj = {
                memberType : $("#memberType").val(),
                memberLevel : $("#memberLvl").val()
        };
    	doGetCombo('/organization/selectFromTransfer.do', jsonObj , ''   , 'fromTransfer' , 'S', '');
    	doGetCombo('/organization/selectFromTransfer.do', jsonObj , ''   , 'toTransfer' , 'S', '');
    });
    
    $("#fromTransfer").change(function(){
        var jsonObj = {
                memberType : $("#memberType").val(),
                memberUpId :  $("#fromTransfer").val(),
        };
        doGetCombo('/organization/selectTransferList.do', jsonObj , ''   , 'transferFromBox' , 'S', '');
    });
    
    
   //버튼 누르면 이동하는거
    $('#btnRight').click(function (e) {
      var selectedOpts = $('#transferFromBox option:selected');
      if (selectedOpts.length == 0) {
          alert("Nothing to move.");
          e.preventDefault();
      }
      $('#transferToBox').append($(selectedOpts).clone());
      $(selectedOpts).remove();
      e.preventDefault();
  });
  $('#btnAllRight').click(function (e) {
      var selectedOpts = $('#transferFromBox option');
      if (selectedOpts.length == 0) {
          alert("Nothing to move.");
          e.preventDefault();
      }
      $('#transferToBox').append($(selectedOpts).clone());
      $(selectedOpts).remove();
      e.preventDefault();
  });
  $('#btnLeft').click(function (e) {
      var selectedOpts = $('#transferToBox option:selected');
      if (selectedOpts.length == 0) {
          alert("Nothing to move.");
          e.preventDefault();
      }
      $('#transferFromBox').append($(selectedOpts).clone());
      $(selectedOpts).remove();
      e.preventDefault();
  });
  $('#btnAllLeft').click(function (e) {
      var selectedOpts = $('#transferToBox option');
      if (selectedOpts.length == 0) {
          alert("Nothing to move.");
          e.preventDefault();
      }
      $('#transferFromBox').append($(selectedOpts).clone());
      $(selectedOpts).remove();
      e.preventDefault();
  });

    
    
    
   
});
</script>
<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>Organization</li>
    <li>Transfer</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>Member Transfer</h2>
<ul class="right_btns">
    <li><p class="btn_blue"><a href="#">Confirm Transfer</a></p></li>
</ul>
</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->
<form action="#" method="post">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Member Type</th>
    <td>
    <select class="w100p" id="memberType" name="memberType">
        
    </select>
    </td>
    <th scope="row">Member Level</th>
    <td>
    <select class="w100p" id="memberLvl" name="memberLvl">
        
    </select>
    </td>
</tr>
<tr>
    <th scope="row">From Transfer</th>
    <td>
    <select class="w100p" id="fromTransfer" name="fromTransfer">
       
    </select>
    </td>
    <th scope="row">To Transfer</th>
    <td>
    <select class="w100p" id="toTransfer" name="toTransfer">
        
    </select>
    </td>
</tr>
<tr>
    <th scope="row">Manual Search</th>
    <td>
    <input type="text" title="Manual Search" placeholder="" class="" /><p class="btn_sky"><a href="#">Confirm</a></p>
    </td>
    <th scope="row"></th>
    <td>
    </td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="link_btns_wrap"><!-- link_btns_wrap start -->
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
</aside><!-- link_btns_wrap end -->

</form>
</section><!-- search_table end -->

<section class="transfer_wrap"><!-- transfer_wrap start -->

<div class="tran_list" style="width:550px; height:300px;"><!-- tran_list start -->
<select multiple="multiple" id="transferFromBox" name="transferFromBox">
   
</select> 
</div><!-- tran_list end -->

<ul class="btns">
    <li><a href="#" id="btnRight"><img src="${pageContext.request.contextPath}/resources/images/common/btn_right.gif" alt="right" /></a></li>
    <li class="sec" id="btnLeft"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_left.gif" alt="left" /></a></li>
    <li><a href="#" id="btnAllRight"><img src="${pageContext.request.contextPath}/resources/images/common/btn_right2.gif" alt="right" /></a></li>
    <li><a href="#" id="btnAllLeft"><img src="${pageContext.request.contextPath}/resources/images/common/btn_left2.gif" alt="left" /></a></li>
</ul>

<div class="tran_list" ><!-- tran_list start -->
<select multiple="multiple" id="transferToBox" name="transferToBox" >
    
</select> 
</div><!-- tran_list end -->

</section><!-- transfer_wrap end -->

<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#">SAVE</a></p></li>
</ul>

</section><!-- content end -->

</html>