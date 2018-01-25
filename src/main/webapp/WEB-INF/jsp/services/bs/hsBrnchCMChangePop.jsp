<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>

<script type="text/javaScript" language="javascript">

$(document).ready(function() {
	
	doGetCombo('/services/bs/selectBrnchCode.do', '', '' , 'cmbTransBranchCode' , 'S', '');
	
	$("#cmbTransBranchCode").change(function() {
       doGetCombo('/services/bs/selectCMList.do', $("#cmbTransBranchCode").val() , '', 'cmbTransCM' , 'S', '');
    });
	
});

function fn_assignCodyList(){
	
	Common.popupDiv("/services/bs/selecthSCodyChangePop.do?JsonObj=${JsonObj}&CheckedItems=${ordCdList}&BrnchId=${brnchCdList}&ManuaMyBSMonth=${ManuaMyBSMonth}&deptList="+$("#cmbTransCM").val());
	$("#popup_wrap").remove();

}

</script>

<div id="popup_wrap" class="popup_wrap size_mid" style="left: 50%; top: 15%;"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Select Cody Manager to transfer</h1>
<ul class="right_opt">
	<li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->


<br><br>

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:130px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Branch Code</th>
    <td>
            <select class="w100p" id="cmbTransBranchCode"   name="cmbTransBranchCode">
                   <%-- <option value="">Choose One</option>
                   <c:forEach var="list" items="${branchList }" varStatus="status">
                   <option value="${list.codeId}">${list.codeName}</option>
                   </c:forEach> --%>
            </select>
    </td>
</tr>
<tr>
    <th scope="row">Cody Manager</th>
    <td>
            <select class="w100p"  id="cmbTransCM" name="cmbTransCM">
            </select>
    </td>
</tr>
</tbody>
</table><!-- table end -->

<br><br>
<ul class=center_btns>
    <li><p class="btn_blue2 big"><a href="javascript:fn_assignCodyList();">Assign Cody Transfer</a></p></li> 
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
        
        <div id="grid_wrap_hide" style="display: none;"></div>
</article>
</section><!-- pop_body end -->

</div><!-- popup_wrap end -->