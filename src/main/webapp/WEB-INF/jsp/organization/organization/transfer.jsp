<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">

var memberTypeData = [{"codeId": "1","codeName": "Health Planner"},{"codeId": "2","codeName": "Coway Lady"},{"codeId": "3","codeName": "Coway Technician"}];


function fn_saveConfirm(){
	if(fn_ValidationCheck()){
        Common.confirm("<spring:message code='sys.common.alert.save'/>", fn_transferSave);
    }
}
function fn_transferSave(){
	$("#transferToBox > option").attr("selected", "selected")
	$("#selectValue").val(($("#transferToBox").val()));
	$("#selectText").val(($("#transferToBox").text()));
	$("#selectDate").val(($("#transferDate").text()));
	Common.ajax("POST", "/organization/insertTransfer.do", $("#transferForm").serializeJSON() , function(result) {
		Common.alert(result.message);
	});
}

function fn_ValidationCheck(){
	if($("#toTransfer").val() == ''){
        Common.alert("Please select TO Transfer");
        return false;
    }

	if($("#transferDate").val() == ''){
        Common.alert("Please select Planned Transfer Date");
        return false;
    }
	return true;
}


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


   //Button Transfer
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
<!-- <ul class="right_btns">
    <li><p class="btn_blue"><a href="#">Confirm Transfer</a></p></li>
</ul> -->
</aside><!-- title_line end -->

<form action="#" method="post" id="transferForm">
<input type="hidden" id="selectValue" name="selectValue">
<input type="hidden" id="selectText" name="selectText">
<input type="hidden" id="selectDate" name="selectDate">
<section class="search_table"><!-- search_table start -->

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
<th scope="row">Transfer Date</th>
    <td>
    <p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" id="transferDate" name="transferDate" /></p>
    </td>
    <th scope="row"></th>
    <td>
    </td>
   <!--  <th scope="row">Manual Search</th>
    <td>
    <input type="text" title="Manual Search" placeholder="" class="" /><p class="btn_sky"><a href="#">Confirm</a></p>
    </td> -->

</tr>
</tbody>
</table><!-- table end -->
</section><!-- search_table end -->

<section class="transfer_wrap"><!-- transfer_wrap start -->

<div class="tran_list"><!-- tran_list start -->
<select multiple="multiple" id="transferFromBox" name="transferFromBox" style="height:300px; width:100%">

</select>
</div><!-- tran_list end -->

<ul class="btns">
    <li><a href="#" id="btnRight"><img src="${pageContext.request.contextPath}/resources/images/common/btn_right.gif" alt="right" /></a></li>
    <li class="sec" id="btnLeft"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_left.gif" alt="left" /></a></li>
    <li><a href="#" id="btnAllRight"><img src="${pageContext.request.contextPath}/resources/images/common/btn_right2.gif" alt="right" /></a></li>
    <li><a href="#" id="btnAllLeft"><img src="${pageContext.request.contextPath}/resources/images/common/btn_left2.gif" alt="left" /></a></li>
</ul>

<div class="tran_list"><!-- tran_list start -->
<select multiple="multiple" id="transferToBox" name="transferToBox" style="height:300px; width:100%">

</select>
</div><!-- tran_list end -->

<%-- <div class="tran_list" ><!-- tran_list start -->
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
</div><!-- tran_list end --> --%>

</section><!-- transfer_wrap end -->

<ul class="center_btns">
<c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
    <li><p class="btn_blue2 big"><a href="#" onclick="javascript:fn_saveConfirm();">Request Transfer</a></p></li>
</c:if>    
</ul>
</form>
</section><!-- content end -->