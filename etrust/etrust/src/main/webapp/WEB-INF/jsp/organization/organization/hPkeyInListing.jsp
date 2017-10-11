<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

    <script type="text/javaScript" language="javascript">
    
    
        var option = {
        width : "1000px", // 창 가로 크기
        height : "600px" // 창 세로 크기
    };
    
    // 화면 초기화 함수 (jQuery 의 $(document).ready(function() {}); 과 같은 역할을 합니다.
    $(document).ready(function(){
    
    
    
    });
    
    
    function f_multiCombo(){
       $(function() {
	          $('#memberType').change(function() {
	            }).multipleSelect({
	                selectAll: true,
	                width: '80%'
	            });     
               $('#requestStatus').change(function() {
	            }).multipleSelect({
	                selectAll: true, // 전체선택 
	                width: '80%'
	            });
        });    
    }
    
    
    doGetCombo('/common/selectCodeList.do', '18', '','memberType', 'M' , 'f_multiCombo'); //MemberType
    
    </script>
    
<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="../images/common/path_home.gif" alt="Home" /></li>
    <li>Training</li>
    <li>Course</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>Member Key In Listing</h2>
<ul class="right_btns">
    <li><p class="btn_blue"><a href="#">Generate To PDF</a></p></li>
    <li><p class="btn_blue"><a href="#">Generate To Excel</a></p></li>
    <li><p class="btn_blue"><a href="#"><span class="clear"></span>Clear</a></p></li>
</ul>
</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->
<form action="#" method="post">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Member Type</th>
    <td>
    <select  id="memberType" name="memberType" class="multy_select w100p">
    </select>
    </td>
    <th scope="row">Member Code</th>
    <td>
    <div class="date_set w100p"><!-- date_set start -->
    <p><input id ="memberCodeT" name="memberCodeT" type="text" title="" placeholder="" class="w100p" /></p>
    <span>To</span>
    <p><input id ="memberCodeF" name="memberCodeF" type="text" title="" placeholder="" class="w100p" /></p>
    </div><!-- date_set end -->
    </td>
</tr>
<tr>
    <th scope="row">Key In Date</th>
    <td>
    <div class="date_set w100p"><!-- date_set start -->
    <p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
    <span>To</span>
    <p><input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
    </div><!-- date_set end -->
    </td>
    <th scope="row">Key In Branch</th>
    <td>
    <select id="keyInBranch" name="keyInBranch"  class="multy_select w100p" />
            <option value="" selected></option>
	            <c:forEach var="list" items="${ branchComboList}" varStatus="status">
	                 <option value="${list.brnchId}">${list.c1 } </option>
	            </c:forEach>
    </select>        
    </td>
</tr>
<tr>
    <th scope="row">Key In User</th>
    <td>
    <select id = "keyInUser" name = "keyInUser" class="w100p">
        <option value="" selected>Key In User</option>
            <c:forEach var="list" items="${ reqPersonComboList}" varStatus="status">
                 <option value="${list.userId}">${list.userName } </option>
            </c:forEach>
    </select>
    </td>
    <th scope="row">Sorting</th>
    <td>
    <select class="w100p">
        <option value="">11</option>
        <option value="">22</option>
        <option value="">33</option>
    </select>
    </td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="link_btns_wrap"><!-- link_btns_wrap start -->
<p class="show_btn"><a href="#"><img src="../images/common/btn_link.gif" alt="link show" /></a></p>
<dl class="link_list">
    <dt>Link</dt>
    <dd>
    <ul class="btns">
        <li><p class="link_btn"><a href="#">menu1</a></p></li>
        <li><p class="link_btn"><a href="#">menu2</a></p></li>
        <li><p class="link_btn"><a href="#">menu3</a></p></li>
        <li><p class="link_btn"><a href="#">menu4</a></p></li>
        <li><p class="link_btn"><a href="#">Search Payment</a></p></li>
        <li><p class="link_btn"><a href="#">menu6</a></p></li>
        <li><p class="link_btn"><a href="#">menu7</a></p></li>
        <li><p class="link_btn"><a href="#">menu8</a></p></li>
    </ul>
    <ul class="btns">
        <li><p class="link_btn type2"><a href="#">menu1</a></p></li>
        <li><p class="link_btn type2"><a href="#">Search Payment</a></p></li>
        <li><p class="link_btn type2"><a href="#">menu3</a></p></li>
        <li><p class="link_btn type2"><a href="#">menu4</a></p></li>
        <li><p class="link_btn type2"><a href="#">Search Payment</a></p></li>
        <li><p class="link_btn type2"><a href="#">menu6</a></p></li>
        <li><p class="link_btn type2"><a href="#">menu7</a></p></li>
        <li><p class="link_btn type2"><a href="#">menu8</a></p></li>
    </ul>
    <p class="hide_btn"><a href="#"><img src="../images/common/btn_link_close.gif" alt="hide" /></a></p>
    </dd>
</dl>
</aside><!-- link_btns_wrap end -->

</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<ul class="right_btns">
    <li><p class="btn_grid"><a href="#">EXCEL UP</a></p></li>
    <li><p class="btn_grid"><a href="#">EXCEL DW</a></p></li>
    <li><p class="btn_grid"><a href="#">DEL</a></p></li>
    <li><p class="btn_grid"><a href="#">INS</a></p></li>
    <li><p class="btn_grid"><a href="#">ADD</a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
그리드 영역
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- content end -->
    
    
