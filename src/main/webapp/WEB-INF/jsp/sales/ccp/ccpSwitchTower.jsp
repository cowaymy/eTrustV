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
	}else{
		Common.ajax("GET", "/sales/ccp/updateCurrentTower.do", $('#form').serializeJSON(), function(result) {
	        Common.alert("Saved",function(){fn_closePop()});
	    });
	}
}



function fn_closePop() {
    $("#ccpSwitchTowerClose").click();
}

$(document).ready(function(){
	doGetComboData('/common/selectCodeList.do', {groupCode:'539',orderValue:'CODE'}, '${currentTower.code}', 'towerChannel', 'S');
});


</script>

<div id="popup_wrap" class="popup_wrap size_mid"><!-- popup_wrap start -->
<form id="form">

<header class="pop_header"><!-- pop_header start -->
<h1>CCP - Switch Tower</h1>
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
    <th scope="row">Tower Channel</th>
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