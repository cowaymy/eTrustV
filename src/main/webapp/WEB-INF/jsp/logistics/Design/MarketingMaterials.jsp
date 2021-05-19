<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp" %>

<style type="text/css">

/* 커스텀 칼럼 스타일 정의 */
.aui-grid-user-custom-left {
    text-align:left;
}

/* 커스컴 disable 스타일*/
.mycustom-disable-color {
    color : #cccccc;
}

/* 그리드 오버 시 행 선택자 만들기 */
.aui-grid-body-panel table tr:hover {
    background:#D9E5FF;
    color:#000;
}
.aui-grid-main-panel .aui-grid-body-panel table tr td:hover {
    background:#D9E5FF;
    color:#000;
}

.tblFontCongf {
    font-size:16px;
    color:#0000FF;
}

</style>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery.blockUI.min.js"></script>
<script type="text/javaScript" language="javascript">

$(document).ready(function(){
    /**********************************
    * Header Setting
    **********************************/
    /**********************************
     * Header Setting End
     ***********************************/

});

//btn clickevent
$(function(){

});


</script>

<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>Marketing Materials</li>

</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>Marketing Materials</h2>
</aside><!-- title_line end -->

    <section class="search_result"><!-- search_result start -->
        <div id="main_grid_wrap" class="mt10" style="height:600px">
            <table class="type1"><!-- table start -->
            <colgroup>
                <col style="width:345px" />
                <col style="width:345px" />
            </colgroup>
            <tbody>
                <tr>
	                <td colspan=2>
	                   <br />
	                    <a href="http://bit.ly/MKTbrands" target="_blank"><font class="tblFontCongf">Brands</font></a>
                        <br />
                        <br />
                        <a href="http://bit.ly/MKTproducts" target="_blank"><font class="tblFontCongf">Products</font></a>
                        <br />
                        <br />
                        <a href="http://bit.ly/MKTevents" target="_blank"><font class="tblFontCongf">Events</font></a>
                        <br />
                        <br />
                        <a href="http://bit.ly/MKTpromotion" target="_blank"><font class="tblFontCongf">Promotion</font></a>
                        <br />
                        <br />
                        <a href="http://bit.ly/MKTpr" target="_blank"><font class="tblFontCongf">PR</font></a>
                        <br />
                        <br />
                        <a href="http://bit.ly/MKTgoodmorningcoway" target="_blank"><font class="tblFontCongf">Good Morning Coway</font></a>
                        <br />
                        <br />
	                </td>
                </tr>

            </tbody>
         </table>
        </div>
    </section><!-- search_result end -->
</section>

