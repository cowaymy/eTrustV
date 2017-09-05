<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<section id="content"><!-- content start -->
<ul class="path">
  <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
  <li>Sales</li>
  <li>Order list</li>
</ul>

<aside class="title_line main_title"><!-- title_line start -->
<h2>Notice</h2>
<p class="more"><a href="javascript:;">More ></a></p>
</aside><!-- title_line end -->

<article class="grid_wrap"><!-- grid_wrap start -->
그리드 영역
</article><!-- grid_wrap end -->

<aside class="title_line main_title mt40"><!-- title_line start -->
<h2>Trust Ticket Status</h2>
<p class="more"><a href="javascript:;">More ></a></p>
</aside><!-- title_line end -->

<article class="grid_wrap"><!-- grid_wrap start -->
그리드 영역
</article><!-- grid_wrap end -->

<aside class="title_line main_title mt40"><!-- title_line start -->
<h2>Daily Performance</h2>
<p class="more"><a href="javascript:;">More ></a></p>
</aside><!-- title_line end -->

<article class="grid_wrap"><!-- grid_wrap start -->
그리드 영역
</article><!-- grid_wrap end -->

</section><!-- container end -->

세션 정보 객체 : ${SESSION_INFO} <br/><br/>
id : ${SESSION_INFO.userId} <br/><br/>
name : ${SESSION_INFO.userName} <br/><br/>