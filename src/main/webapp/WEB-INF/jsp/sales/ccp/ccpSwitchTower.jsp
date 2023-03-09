<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<style type="text/css">
/* 커스텀 행 스타일 */
.my-row-style {
    background:#9FC93C;
    font-weight:bold;
    color:#22741C;
}
</style>
<script type="text/javascript">

function fn_save() {
	console.log($('#form').serializeJSON());

	if($('#towerChannel').val() == ''){
	    Common.alert("Please select one option.");
	}
	/* else if(FormUtil.isEmpty($("#ageGroup").val())){
        Common.alert("Please key in Age Group");
    } */
	else{
		Common.ajax("GET", "/sales/ccp/updateCurrentTower.do", $('#form').serializeJSON(), function(result) {
			console.log(result);
	        Common.alert("Saved",function(){fn_closePop()});
	    });
	}
}



function fn_closePop() {
    $("#ccpSwitchTowerClose").click();
}

$(document).ready(function(){
	doGetComboData('/common/selectCodeList.do', {groupCode:'539',orderValue:'CODE'}, '${currentTower.ccpFlag}', 'towerChannel', 'S');

	$("#ageGroup").unbind().bind("keyup", function(){
	    $(this).val($(this).val().replace(/[^0-9]/g,""));
	});


});


</script>

<div id="popup_wrap" class="popup_wrap size_mid"><!-- popup_wrap start -->
<form id="form">

<header class="pop_header"><!-- pop_header start -->
<h1>CCP - Config Tower</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a id="ccpSwitchTowerClose" href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:200px" />
    <col style="width:*" />
</colgroup>

<tbody>
<tr>
<th scope="row" colspan="2"><b>Age Group Pick-up For CTOS<b/></th>
</tr>

<tr>
<th scope="row">Age Group 1</th>
<td>
    <div class="date_set">
         <p><input type="text" title="" placeholder="" class="w100p" id="CtosAgeFr1" name="CtosAgeFr1" value="${currentTower.ctosagefr1}" /></p>
         <span>To</span>
         <p><input type="text" title="" placeholder="" class="w100p" id="CtosAgeTo1" name="CtosAgeTo1" value="${currentTower.ctosageto1}"/></p>
    </div>
</td>
</tr>
<tr>
<th scope="row">Age Group 2</th>
<td>
    <div class="date_set">
         <p><input type="text" title="" placeholder="" class="w100p" id="CtosAgeFr2" name="CtosAgeFr2" value="${currentTower.ctosagefr2}"/></p>
         <span>To</span>
         <p><input type="text" title="" placeholder="" class="w100p" id="CtosAgeTo2" name="CtosAgeTo2" value="${currentTower.ctosageto2}"/></p>
    </div>
</td>
</tr>

<th scope="row" colspan="2"><b>Age Group Pick-up For Experian</b></th>
<tr>
<th scope="row">Age Group 1</th>
<td>
    <div class="date_set">
         <p><input type="text" title="" placeholder="" class="w100p" id="ExprAgeFr1" name="ExprAgeFr1" value="${currentTower.expragefr1}"/></p>
         <span>To</span>
         <p><input type="text" title="" placeholder="" class="w100p" id="ExprAgeTo1" name="ExprAgeTo1" value="${currentTower.exprageto1}"/></p>
    </div>
</td>
</tr>
<tr>
<th scope="row">Age Group 2</th>
<td>
    <div class="date_set">
         <p><input type="text" title="" placeholder="" class="w100p" id="ExprAgeFr2" name="ExprAgeFr2" value="${currentTower.expragefr2}"/></p>
         <span>To</span>
         <p><input type="text" title="" placeholder="" class="w100p" id="ExprAgeTo2" name="ExprAgeTo2" value="${currentTower.exprageto2}"/></p>
    </div>
</td>
</tr>


<th scope="row" colspan="2"><b>General Setting</b></th>
<tr>
    <th scope="row">Switch CRA Channel</th>
    <td>
        <select id="towerChannel" name="towerChannel" class="w100p"></select>
    </td>
</tr>
<tr>
    <th scope="row">Last Updated Date</th>
    <td>
        ${currentTower.updDt}
    </td>
</tr>
<tr>
    <th scope="row">Last Updated User</th>
    <td>
        ${currentTower.userName}
    </td>
</tr>
</tbody>

</table><!-- table end -->
  <ul class="center_btns mt20">

            <li><p class="btn_blue2 big"><a href="javascript:fn_save();"><spring:message code='sys.btn.save'/></a></p></li>
        </ul>
</section><!-- pop_body end -->
</form>

</div><!-- popup_wrap end -->