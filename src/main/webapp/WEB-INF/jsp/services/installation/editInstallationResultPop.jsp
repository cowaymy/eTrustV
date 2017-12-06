<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">
$(document).ready(function() {
	   
	   var allcom = ${installInfo.c1};
	   var istrdin = ${installInfo.c7};
	   var reqsms = ${installInfo.c9};
	   
	   
	   
	   if(allcom==1){
		   $("#allwcom").prop("checked",true);
	   }
	   
	   if(istrdin==1){
           $("#trade").prop("checked",true);
       }
	   
	   if(reqsms==1){
           $("#reqsms").prop("checked",true);
       }
	   
});

function fn_saveInstall(){
    Common.ajax("POST", "/services/editInstallation.do", $("#editInstallForm").serializeJSON(), function(result) {
        console.log("성공.");
        console.log("data : " + result);
        Common.alert(result.message);
    });
}
</script>
<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->
<header class="pop_header"><!-- pop_header start -->
<h1>Edit Installation Result</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<section class="tap_wrap"><!-- tap_wrap start -->
<!-- 
<ul class="tap_type1">
    <li><a href="#" class="on">Order Info</a></li>
</ul>
 -->


<form action="#" id="editInstallForm" method="post">
<input type="hidden" value="<c:out value="${installInfo.resultId}"/> "  id="resultId" name="resultId"/>
<table class="type1 mb1m"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:130px" />
    <col style="width:350px" />
    <col style="width:170px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Installation No</th>
    <td>
    </td>
    <th scope="row">Install Status</th>
    <td>
    </td>
</tr>
<tr>
    <th scope="row">Creator</th>
    <td>
        <span><c:out value="${installInfo.crtUserId}" /></span>
    </td>
    <th scope="row">Create Date</th>
    <td>
        <span><c:out value="${installInfo.crtDt}" /></span>
    </td>
</tr>
<tr>
    <th scope="row">Action CT</th>
    <td colspan="3">
        <span><c:out value="${installInfo.c3} - ${installInfo.c4}" /></span>
    </td>
</tr>
<tr>
    <th scope="row">Sirim No</th>
    <td>
        <input type="text" id="sirimNo" name="sirimNo" value="<c:out value="${installInfo.sirimNo}"/>" />
        
    </td>
    <th scope="row">Serial No</th>
    <td>
        <input type="text" id="serialNo" name="serialNo" value="<c:out value="${installInfo.serialNo}" />" />
    </td>
</tr>
<tr>
    <th scope="row">Ref No.(1)</th>
    <td>
        <input type="text" id="refNo1" name="refNo1" value="<c:out value="${installInfo.docRefNo1}" />" />
    </td>
    <th scope="row">Ref No.(2)</th>
    <td>
        <input type="text" id="refNo2" name="refNo2" value="<c:out value="${installInfo.docRefNo2}" />" />
    </td>
</tr>
<tr>
    <th scope="row">Remark</th>
    <td colspan="3">
        <textarea id="remark" name="remark" cols="5" rows="5" style="width:100%; height:100px" ><c:out value="${installInfo.rem}"/></textarea>
    </td>
</tr>
<tr>
    <td colspan="4">
        <input id="allwcom" type="checkbox" value="1" disabled/><span>Allow Commission ?</span>
        <input id="trade" type="checkbox" value="1" disabled/><span>Is trade in ?</span>
        <input id="reqsms" type="checkbox" value="1" disabled/><span>Required SMS ?</span>
    </td>
</tr>
</tbody>
</table><!-- table end -->
</form>
<ul class="center_btns">
    <li><p class="btn_blue2"><a href="#" onclick="fn_saveInstall()">Save Installation Result</a></p></li>
</ul>
</section><!-- pop_body end -->

</div><!-- popup_wrap end -->
