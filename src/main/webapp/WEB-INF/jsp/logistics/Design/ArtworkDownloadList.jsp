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
    <li>Artwork Download</li>

</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>Artwork Download</h2>
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
                    <td>Web & Social Media</td>
                    <td></td>
                </tr>
                <tr>

               <%--      <td width="313px"><img ID="RadImageTile1" Shape="Wide" BackColor="Black" src="${pageContext.request.contextPath}/resources/images/Artwork/Social-Media-Image-Preview.png" style="top: 1px; left: 0px; width: 380px; height: 190px"></td>
                    <td width="313px"><img ID="RadImageTile2" Shape="Wide" BackColor="Black" src="${pageContext.request.contextPath}/resources/images/Artwork/Flyer-Image-Preview.png" style="top: 1px; left: 0px; width: 380px; height: 190px"></td>           --%>
                    <td width="313px"><img ID="RadImageTile1" Shape="Wide" BackColor="Black" src="${pageContext.request.contextPath}/resources/WebShare/Artwork/Social-Media-Image-Preview.png" style="top: 1px; left: 0px; width: 380px; height: 190px"></td>
                    <td></td>
                </tr>
                <tr>
	                <td >
	                    <a href="https://drive.google.com/drive/folders/1FWBm7eMu0t31sLmCaFKCX2TmoA_ri63U?usp=sharing" target="_blank"><font class="tblFontCongf">Promotion</font></a>
	                    <br />
	                    <br />
	                    <a href="https://drive.google.com/open?id=1s-1rApHlYW3XbI9voT02SbqoZRilhmNG" target="_blank"><font class="tblFontCongf">Product USP</font></a>
	                    <br />
	                    <br />
	                    <a href="https://drive.google.com/open?id=1ThDlCyUPZC2AtR-P9op8ePP3BzXg_fcO" target="_blank"><font class="tblFontCongf">Company Profile</font></a>
	                    <br />
	                    <br />
	                    <a href="https://drive.google.com/open?id=1w1Js3kDZ9MRBbBReFp8xAFpwAomwAiS0" target="_blank"><font class="tblFontCongf">Social Media</font></a>
	                    <br />
	                </td>
	                <td></td>
                </tr>
            </tbody>
         </table>
        </div>
    </section><!-- search_result end -->
</section>

