<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp" %>

<script type="text/javaScript">

$(function(){
	//doGetCombo('/common/selectCodeList.do', '11', '','cmbCategory', 'S' , 'f_multiCombo'); //Single COMBO => Choose One
	//doGetCombo('/common/selectCodeList.do', '11', '','cmbCategory', 'A' , 'f_multiCombo'); //Single COMBO => ALL
	//doGetCombo('/common/selectCodeList.do', '11', '','cmbCategory', 'M' , 'f_multiCombo'); //Multi COMBO
	// f_multiCombo 함수 호출이 되어야만 multi combo 화면이 안깨짐.
	doGetCombo('/common/selectCodeList.do', '11', '','cmbCategory', 'S' , 'fn_multiCombo');	
});

function fn_multiCombo(){
	$('#cmbCategory').change(function() {
	    //console.log($(this).val());
	}).multipleSelect({
	    selectAll: true, // 전체선택 
	    width: '100%'
	});            
}

</script>


<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/image/path_home.gif" alt="Home" /></li>
    <li>Sales</li>
    <li>Order list</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>Commission Rule Book Management</h2>
<ul class="right_opt">
    <li><p class="btn_blue"><a href="#">Save</a></p></li>
</ul>
</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->
<form action="#" method="post">

<table class="type1"><!-- table start -->
<caption>search table</caption>
<colgroup>
    <col style="width:80px" />
    <col style="width:*" />
    <col style="width:110px" />
    <col style="width:*" />
    <col style="width:100px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">기준년월</th>
    <td>
    <input type="text" title="기준년월" class="j_date2" />
    </td>
    <th scope="row">ORG Group</th>
    <td>
    <select class="w100p" id="cmbCategory" name="cmbCategory">
    </select>
    </td>
    <th scope="row">ORG Code</th>
    <td>
    <select class="w100p">
        <option value="">--Payment Key-in</option>
    </select>
    </td>
</tr>
</tbody>
</table><!-- table end -->

<ul class="right_btns">
    <li><p class="btn_gray"><a href="#"><span class="search"></span>Search</a></p></li>
</ul>
</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->
<ul class="right_btns">
    <li><p class="btn_grid"><a href="#"><span class="search"></span>EXCEL UP</a></p></li>
    <li><p class="btn_grid"><a href="#"><span class="search"></span>EXCEL DW</a></p></li>
    <li><p class="btn_grid"><a href="#"><span class="search"></span>DEL</a></p></li>
    <li><p class="btn_grid"><a href="#"><span class="search"></span>INS</a></p></li>
    <li><p class="btn_grid"><a href="#"><span class="search"></span>ADD</a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
그리드 영역
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- content end -->

        
