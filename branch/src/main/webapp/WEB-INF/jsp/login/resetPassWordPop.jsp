<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<style type="text/css">
/* 칼럼 스타일 전체 재정의 */
.aui-grid-left-column {
  text-align:left;
}
</style>

<script type="text/javaScript">

var setMainRowIdx = 0;

function pswdPopUpClose()
{
	 $("#resetPassWordPop").remove();
}

/***************************************************[ Main GRID] ***************************************************/    
var searchUpperGridID;

$(document).ready(function()
{
   $("#newUserIdTxt").val( $("#loginUserId").val() );

   $("#newPasswordTxt").focus();
  
});   //$(document).ready


</script>

<body>

<div id="popup_wrap" class="popup_wrap size_mid"><!-- popup_wrap start size_big size_all size_small -->

<header class="pop_header"><!-- pop_header start -->
<h1>Reset Password</h1>
<ul class="right_opt">
  <li><p class="btn_blue2"><a onclick="pswdPopUpClose();">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<section class="search_table"><!-- search_table start -->
<form id="resetPopUpForm" name="resetPopUpForm" method="post">
  <input type ="hidden" id="newUserIdTxt" name="newUserIdTxt" value=""/>
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
  <col style="width:180px" />
  <col style="width:*" />
</colgroup>
<tbody>
<tr>
<tr>
  <th scope="row">New Password<span class="must">*</span></th>
  <td>
  <span class="txt_box w100p">
    <input type="password" id="newPasswordTxt" name="newPasswordTxt" title="" placeholder="" class="w100p"  maxlength="20" />
	    <i>
	    &gt; Password length must between 6~20.<br />
	    &gt; Password cannot contains your login ID.<br />
	    &gt; New password cannot same to current password.<br />
	    </i>
  </span>
  </td>
</tr>
<tr>
  <th scope="row">Re-Type New Password<span class="must">*</span></th> 
  <td>
    <input type="password" id="newPasswordConfirmTxt" name="newPasswordConfirmTxt" title="" placeholder="" class="w100p"  maxlength="20"/>
  </td>
</tr>
</tbody>
</table><!-- table end -->

<ul class="center_btns">
  <li>
    <p class="btn_blue2">
      <a onclick="fnSaveResetPassWordPop('A1');">Save Password</a>
    </p>
  </li>
</ul>

</form>
</section><!-- search_table end -->

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->

</body>
</html>