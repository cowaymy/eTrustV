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
                    <td>Flyer</td>
                    <td >Bunting</td>
                </tr>
                <tr>

               <%--      <td width="313px"><img ID="RadImageTile1" Shape="Wide" BackColor="Black" src="${pageContext.request.contextPath}/resources/images/Artwork/Social-Media-Image-Preview.png" style="top: 1px; left: 0px; width: 380px; height: 190px"></td>
                    <td width="313px"><img ID="RadImageTile2" Shape="Wide" BackColor="Black" src="${pageContext.request.contextPath}/resources/images/Artwork/Flyer-Image-Preview.png" style="top: 1px; left: 0px; width: 380px; height: 190px"></td>           --%>
                    <td width="313px"><img ID="RadImageTile2" Shape="Wide" BackColor="Black" src="${pageContext.request.contextPath}/resources/WebShare/Artwork/Flyer-Image-Preview.png" style="top: 1px; left: 0px; width: 380px; height: 190px"></td>
                    <td width="313px"><img ID="RadImageTile4" Shape="Wide" BackColor="Black" src="${pageContext.request.contextPath}/resources/WebShare/Artwork/Bunting-Image-Preview.png" style="top: 1px; left: 0px; width: 380px; height: 190px"></td>
                </tr>
                <tr>
	                <td>
	                    <a href="https://drive.google.com/drive/folders/1qBQ6VpK0_gGMX96KMUKTt_biU0grw3Qr?usp=sharing" target="_blank"><font class="tblFontCongf">Roadshow Flyer</font></a>
                        <br />
                        <br />
                        <a href="https://drive.google.com/open?id=1a4gSm3Zz5CjtJ-R7W-1kn9hzcxjXBE5e" target="_blank"><font class="tblFontCongf">Recruitment Flyer</font></a>
                        <br />
                        <br />
	                </td>
	                <td>
                        <a href="https://drive.google.com/open?id=1dvfgIUXnzBkgq-_baeZaxk3SGEJRHmuv" target="_blank"><font class="tblFontCongf">Branding Bunting</font></a>
                        <br />
                        <br />
                        <a href="https://drive.google.com/open?id=1fn1fgPHgtSGo_MAN_JfIBp95N4Kj5YqX" target="_blank"><font class="tblFontCongf">Recruitment Bunting</font></a>
                        <br />
                        <br />
                     </td>
                </tr>
                <tr>
                    <td>Banner</td>
                    <td>Card</td>
                </tr>
                <tr>
                  <%--   <td width="313px"><img ID="RadImageTile3" Shape="Wide" BackColor="Black" src="${pageContext.request.contextPath}/resources/images/Artwork/Banner-Image-Preview.png" style="top: 1px; left: 0px; width: 380px; height: 190px" style="top: 1px; left: 0px; width: 380px; height: 190px"></td>
                    <td width="313px"><img ID="RadImageTile4" Shape="Wide" BackColor="Black" src="${pageContext.request.contextPath}/resources/images/Artwork/Bunting-Image-Preview.png" style="top: 1px; left: 0px; width: 380px; height: 190px"></td>                     --%>
                    <td width="313px"><img ID="RadImageTile3" Shape="Wide" BackColor="Black" src="${pageContext.request.contextPath}/resources/WebShare/Artwork/Banner-Image-Preview.png" style="top: 1px; left: 0px; width: 380px; height: 190px" style="top: 1px; left: 0px; width: 380px; height: 190px"></td>
                    <td width="313px"><img ID="RadImageTile5" Shape="Wide" BackColor="Black" src="${pageContext.request.contextPath}/resources/WebShare/Artwork/Thank-You-Card-Mockup-eTrust.png" style="top: 1px; left: 0px; width: 380px; height: 190px" style="top: 1px; left: 0px; width: 380px; height: 190px"></td>
                </tr>
                <tr>
	                <td>
	                    <!-- <a href="https://drive.google.com/open?id=1EMiS3xJhGthcAi2w2auPjJZXtPzubYbb" target="_blank"><font class="tblFontCongf">Branding Banner</font></a> changed at 2021-12-14. Hui Ding-->
	                    <a href="https://drive.google.com/drive/folders/1ggAloUasPFGsSnp_cf0NwcBMecHO_BfE?usp=sharing" target="_blank"><font class="tblFontCongf">Branding Banner</font></a>
                        <br />
                        <br />
                        <a href="https://drive.google.com/open?id=0B2Nvq8toyZOOdkFqN2ozR0dfWWc" target="_blank"><font class="tblFontCongf">Recruitment Banner</font></a>
                        <br />
                        <br />
                    </td>
                    <td>
                        <a href="https://drive.google.com/drive/folders/1Y9kL3gn86IehPbz4sQeia40PceaU7qs3?usp=sharing" target="_blank"><font class="tblFontCongf">Thank You Card</font></a>
                        <br />
                        <br />
                        <a></a>
                        <br />
                        <br />
                    </td>
                </tr>
            </tbody>
         </table>
        </div>
    </section><!-- search_result end -->
</section>

