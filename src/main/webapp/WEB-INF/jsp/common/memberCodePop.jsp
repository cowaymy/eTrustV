<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<script type="text/javaScript">
/********************************Global Variable Start***********************************/
var myPopGridID = "";
/********************************Global Variable End************************************/
/********************************Function  Start***************************************
 *
 */
$("#popMemberCode").change(function(e){
	fn_searchPop();
});

/****************************Function  End***********************************
 *
 */
/****************************Transaction Start********************************/

function fn_searchPop(){
    Common.ajax(
            "GET",
            "/common/userManagement/selectMemberList.do",
            $("#searchPopForm").serialize(),
            function(data, textStatus, jqXHR){ // Success
                AUIGrid.setGridData(myPopGridID, data);
            },
            function(jqXHR, textStatus, errorThrown){  // Error
                alert("Fail : " + jqXHR.responseJSON.message);
            }
    )
};
/****************************Transaction End********************************/
/**************************** Grid setting Start ********************************/
var gridPopColumnLayout =
[
     /* PK , rowid 용 칼럼*/
     {
         dataField : "rowId",
         dataType : "string",
         visible : false
     },
     {
         dataField : "memCode",
         /* dataType : "string", */
         headerText : "Member Code",
         width : "30%"
     },
    {
        dataField : "name",
        headerText : "Member Name",
        style : "aui-grid-user-custom-left"
    }
];

//selectionMode (String) : 설정하고자 하는 selectionMode(유효값 : singleCell, singleRow, multipleCells, multipleRows, none)

var optionsPop =
{
		enabled : true,
        usePaging : true, //페이징 사용
        useGroupingPanel : false, //그룹핑 숨김
        showRowNumColumn : false, // 순번 칼럼 숨김
        //rowIdField : "rowId", // PK행 지정
//         selectionMode : "multipleRows"
        selectionMode : "singleRow"
        //softRemovePolicy : "exceptNew" //사용자추가한 행은 바로 삭제
};

/****************************Program Init Start********************************/
$(document).ready(function(){
    // AUIGrid 그리드를 생성
    myPopGridID = GridCommon.createAUIGrid("grdMyCommon", gridPopColumnLayout,"", optionsPop);

 // click 이벤트 바인딩
    AUIGrid.bind(myPopGridID, ["cellDoubleClick"], function(event) {
    	eval("popupMemberCallback(event.item)");
    	memberCodePop.remove();
    });

});
/****************************Program Init End********************************/
</script>

<div id="popup_wrap" class="popup_wrap size_small"><!-- popup_wrap start -->
<header class="pop_header"><!-- pop_header start -->
<h1>Member Popup</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->
<form id="searchPopForm" action="#" method="post">

<div class="search_100p"><!-- search_100p start -->
<input id="popMemberCode" class="w100p" name="popMemberCode" type="text" />
<a onclick="fn_searchPop()" class="search_btn"><img src="/resources/images/common/normal_search.gif" alt="search" /></a>
</div><!-- search_100p end -->

<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="grdMyCommon" style="height:270px;"></div>
</article><!-- grid_wrap end -->
</form>
</section><!-- pop_body end -->

</div><!-- popup_wrap end -->