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
    <li>Design</li>
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
                    <td>Social Media</td>
                    <td>Flyer</td>
                </tr>
                <tr>

               <%--      <td width="313px"><img ID="RadImageTile1" Shape="Wide" BackColor="Black" src="${pageContext.request.contextPath}/resources/images/Artwork/Social-Media-Image-Preview.png" style="top: 1px; left: 0px; width: 380px; height: 190px"></td>
                    <td width="313px"><img ID="RadImageTile2" Shape="Wide" BackColor="Black" src="${pageContext.request.contextPath}/resources/images/Artwork/Flyer-Image-Preview.png" style="top: 1px; left: 0px; width: 380px; height: 190px"></td>           --%>
                    <td width="313px"><img ID="RadImageTile1" Shape="Wide" BackColor="Black" src="${pageContext.request.contextPath}/resources/WebShare/Artwork/Social-Media-Image-Preview.png" style="top: 1px; left: 0px; width: 380px; height: 190px"></td>
                    <td width="313px"><img ID="RadImageTile2" Shape="Wide" BackColor="Black" src="${pageContext.request.contextPath}/resources/WebShare/Artwork/Flyer-Image-Preview.png" style="top: 1px; left: 0px; width: 380px; height: 190px"></td>
                </tr>
                <tr>
	                <td>
	                    <a href="https://drive.google.com/drive/folders/1lSC4KgzU02pLG52H_UocvO8tvLD-vbjZ?usp=sharing" target="_blank"><font color="#0000FF">Announcement</font></a>
	                    <br />
	                    <a href="https://drive.google.com/drive/folders/1ThDlCyUPZC2AtR-P9op8ePP3BzXg_fcO?usp=sharing" target="_blank"><font color="#0000FF">Company Profile</font></a>
	                    <br />
	                    <a href="https://drive.google.com/drive/folders/1XYAM8XZPN6TSmGOog4DlE97eL1vM6593?usp=sharing" target="_blank"><font color="#0000FF">Cover Photo</font></a>
	                    <br />
	                    <a href="https://drive.google.com/drive/folders/1s-1rApHlYW3XbI9voT02SbqoZRilhmNG?usp=sharing" target="_blank"><font color="#0000FF">Product USP</font></a>
	                    <br />
	                    <a href="https://drive.google.com/drive/folders/1GJWyO9MOESxw0H6tJzbzmiihLmrgzP8z?usp=sharing" target="_blank"><font color="#0000FF">Profile Picture</font></a>
	                    <br />
	                    <a href="https://drive.google.com/drive/folders/1IEW-o9_sSLMTRnVsnMXvDfT1w7YTvbTX?usp=sharing" target="_blank"><font color="#0000FF">Promotion</font></a>
	                    <br />
	                    <br />
	                </td>
	                <td>
	                    <a href="https://drive.google.com/drive/folders/1yK9VBEMDUqlUCHoAWJo_HGXVqHLIB83_?usp=sharing" target="_blank"><font color="#0000FF">Cody Recruitment Flyer</font></a>
	                    <br />
	                    <a href="https://drive.google.com/drive/folders/1a4gSm3Zz5CjtJ-R7W-1kn9hzcxjXBE5e?usp=sharing" target="_blank"><font color="#0000FF">HP Recruitment Flyer</font></a>
	                    <br />
	                    <a href="https://drive.google.com/open?id=0B2Nvq8toyZOOSVBSZTJsajl3ZUE" target="_blank"><font color="#0000FF">Roadshow Flyer 1</font></a>
	                    <br />
	                    <a href="https://drive.google.com/open?id=0B2Nvq8toyZOORjNfSmRoTnFGRkk" target="_blank"><font color="#0000FF">Roadshow Flyer 2</font></a>
	                    <br />
	                    <a href="https://drive.google.com/open?id=0B2Nvq8toyZOOc3Z6Qm9qa19TbTQ" target="_blank"><font color="#0000FF">Roadshow Flyer 3</font></a>
	                    <br />
	                    <br />
	                    <br />
	                </td>
                </tr>
                <tr>
                    <td>BANNER</td>
                    <td >BUNTING</td>
                </tr>
                <tr>
                  <%--   <td width="313px"><img ID="RadImageTile3" Shape="Wide" BackColor="Black" src="${pageContext.request.contextPath}/resources/images/Artwork/Banner-Image-Preview.png" style="top: 1px; left: 0px; width: 380px; height: 190px" style="top: 1px; left: 0px; width: 380px; height: 190px"></td>
                    <td width="313px"><img ID="RadImageTile4" Shape="Wide" BackColor="Black" src="${pageContext.request.contextPath}/resources/images/Artwork/Bunting-Image-Preview.png" style="top: 1px; left: 0px; width: 380px; height: 190px"></td>                     --%>
                    <td width="313px"><img ID="RadImageTile3" Shape="Wide" BackColor="Black" src="${pageContext.request.contextPath}/resources/WebShare/Artwork/Banner-Image-Preview.png" style="top: 1px; left: 0px; width: 380px; height: 190px" style="top: 1px; left: 0px; width: 380px; height: 190px"></td>
                    <td width="313px"><img ID="RadImageTile4" Shape="Wide" BackColor="Black" src="${pageContext.request.contextPath}/resources/WebShare/Artwork/Bunting-Image-Preview.png" style="top: 1px; left: 0px; width: 380px; height: 190px"></td>
                </tr>
                <tr>
	                <td>
	                    <a href="https://drive.google.com/drive/folders/0B2Nvq8toyZOOLXJIeVF3dmQxYkE?usp=sharing" target="_blank"><font color="#0000FF">Branding Banner</font></a>
	                    <br />
	                    <a href="https://drive.google.com/drive/folders/0B2Nvq8toyZOOdG52dTE2OGpnODg?usp=sharing" target="_blank"><font color="#0000FF">Cody Recruitment Banner</font></a>
	                    <br />
	                    <a href="https://drive.google.com/drive/folders/0B2Nvq8toyZOOMEluYm1sSVBQZnM?usp=sharing" target="_blank"><font color="#0000FF">Generic Product Banner</font></a>
	                    <br />
	                    <a href="https://drive.google.com/drive/folders/0B2Nvq8toyZOOdkFqN2ozR0dfWWc?usp=sharing" target="_blank"><font color="#0000FF">HP Recruitment Banner</font></a>
	                </td>
	                <td>
	                    <a href="https://drive.google.com/drive/folders/1Nc6ijqkYCVqqVScciu9hr-njGjVjFcQ7?usp=sharing" target="_blank"><font color="#0000FF">Branding Bunting</font></a>
	                    <br />
	                    <a href="https://drive.google.com/drive/folders/1HkBdsfuComJ-ia2mFaakhM58JLR4i85i?usp=sharing" target="_blank"><font color="#0000FF">Cody Recruitment Bunting</font></a>
	                    <br />
	                    <a href="https://drive.google.com/drive/folders/1wlv4pgRXfZ4tJ3FEYUtA1MgAmoTV3Jx7?usp=sharing" target="_blank"><font color="#0000FF">Generic Product Bunting</font></a>
	                    <br />
	                    <a href="https://drive.google.com/drive/folders/1oPdCiPd8hAFiyQBWovZu_dIGwzA9c7OP?usp=sharing" target="_blank"><font color="#0000FF">HP Recruitment Bunting</font></a>
	                </td>
                </tr>
            </tbody>
         </table>
        </div>
    </section><!-- search_result end -->
</section>

