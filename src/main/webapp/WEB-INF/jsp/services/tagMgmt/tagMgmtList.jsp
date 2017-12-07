<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">

var gridID;


function tagMgmtGrid() {
    
    var columnLayout = [
	                          { dataField : "", headerText  : "Inquiry Cont Num",    width : 150 },
	                          { dataField : "", headerText  : "Inquiry Cust Name",width : 150 },
	                          { dataField : "", headerText  : "Inquiry Mem Type",  width  : 150},
	                          { dataField : "",       headerText  : "In-charge Sub Dept",  width  : 150},
	                          { dataField : "",       headerText  : "Main Inquiry",  width  : 150},
	                          { dataField : "",       headerText  : "FeedBack Code",  width  : 150},
	                          { dataField : "",       headerText  : "Order Num",  width  : 150},
	                          { dataField : "",       headerText  : "Progress Status",  width  : 150},
                          ];
    
     var gridPros = {  
    		                        usePaging           : true,         //페이징 사용
                        	        pageRowCount        : 20,           //한 화면에 출력되는 행 개수 20(기본값:20)            
                        	        showStateColumn     : false,             
                        	        displayTreeOpen     : false,            
                        	        selectionMode       : "singleRow",  //"multipleCells",            
                        	        skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
                        	        wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
                        	        showRowNumColumn    : true,         //줄번호 칼럼 렌더러 출력    
                          };  
                          
                          gridID = GridCommon.createAUIGrid("tagMgmt_grid_wap", columnLayout  ,"" ,gridPros);
                          
                           

    }
$(document).ready(function(){
	
	tagMgmtGrid(); // tagMgmt 그리드 생성 함수
	
});

</script>




<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/images/common/path_home.gif" alt="Home" /></li>
    <li>Service</li>
    <li>Tag Mgmt</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>Tag Mgmt</h2>
<ul class="right_btns">
    <li><p class="btn_blue"><a href="#" onclick=""><span class="search"></span>Search</a></p></li>
<!--     <li><p class="btn_blue"><a href="#" onclick="javascript:fn_Clear()"><span class="clear"></span>Clear</a></p></li> -->
</ul>


</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form action="#" method="post">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
    <col style="width:180px" />
    <col style="width:*" />
    <col style="width:160px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Inquiry Contact Number</th>
    <td><input type="text" title="" placeholder="" class="w100p" /></td>
    <th scope="row">Inquiry Customer Name</th>
    <td><input type="text" title="" placeholder="" class="w100p" /></td>
    <th scope="row">Inquiry Member Type</th>
    <td><input type="text" title="" placeholder="" class="w100p" /></td>
</tr>
<tr>
    <th scope="row">In-charge Main Dept.</th>
    <td><input type="text" title="" placeholder="" class="w100p" /></td>
    <th scope="row">In-charge Sub Dept.</th>
    <td><input type="text" title="" placeholder="" class="w100p" /></td>
    <th scope="row">Main Inquiry</th>
    <td><input type="text" title="" placeholder="" class="w100p" /></td>
</tr>
<tr>
    <th scope="row">Customer Code</th>
    <td><input type="text" title="" placeholder="" class="w100p" /></td>
    <th scope="row">Order Number</th>
    <td><input type="text" title="" placeholder="" class="w100p" /></td>
    <th scope="row">Sub Main Inquiry</th>
    <td><input type="text" title="" placeholder="" class="w100p" /></td>
</tr>
<tr>
    <th scope="row">Progress Status</th>
    <td><input type="text" title="" placeholder="" class="w100p" /></td>
    <th scope="row">Complete Key-in Date</th>
    <td><input type="text" title="" placeholder="" class="w100p" /></td>
    <th scope="row">Feedback Code</th>
    <td><input type="text" title="" placeholder="" class="w100p" /></td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="link_btns_wrap"><!-- link_btns_wrap start -->
<p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/images/common/btn_link.gif" alt="link show" /></a></p>
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
    <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/images/common/btn_link_close.gif" alt="hide" /></a></p>
    </dd>
</dl>
</aside><!-- link_btns_wrap end -->

</form>
</section><!-- search_table end -->


<section class="search_result"><!-- search_result start -->

<ul class="right_btns">
    <li><p class="btn_grid"><a href="#">EXCEL DW</a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start  그리드 영역-->
    <div id="tagMgmt_grid_wap" style="width:100%; height:300px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- content end -->

