<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<script type="text/javaScript">
/********************************Global Variable Start***********************************/
/********************************Global Variable End************************************/
/********************************Function  Start***************************************
 *
 */
/****************************Function  End***********************************
 *
 */
/****************************Transaction Start********************************/

function fn_searchMyMenuCombo(){
    Common.ajax(
            "GET",
            "/common/selectMyMenuList.do",
            "useYn=Y",
            function(data, textStatus, jqXHR){ // Success
                for(var idx=0; idx < data.length ; idx++){
                	$("#select_myMenu").append("<option value='"+data[idx].mymenuCode+"'>"+data[idx].mymenuName+"</option>");
                }
            },
            function(jqXHR, textStatus, errorThrown){ // Error
                alert("Fail : " + jqXHR.responseJSON.message);
            }
    )
};

function onClickSelectMyMenuPop(){
	mymenuPopSelect($("#select_myMenu option:selected").val());
}
/****************************Transaction End********************************/
/**************************** Grid setting Start ******************************/
/****************************Program Init Start********************************/
$(document).ready(function(){
    // AUIGrid 그리드를 생성
	fn_searchMyMenuCombo();
});
/****************************Program Init End********************************/
</script>
<div id="popup_wrap" class="popup_wrap size_small"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>MyMenu</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<div class="search_100p select"><!-- search_100p start -->
<select id="select_myMenu" class="w100p">
</select>
<p class="btn_sky"><a onclick="onClickSelectMyMenuPop()">Select</a></p>
</div><!-- search_100p end -->

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->