<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<script type="text/javaScript">
/********************************Global Variable Start***********************************/
var grdIfKey = "";
/********************************Global Variable End************************************/
/********************************Function  Start***************************************
 *
 */

/****************************Function  End***********************************
 *
 */
/****************************Transaction Start********************************/

function fn_searchKeyPop(){

   var selectedMasterRow = AUIGrid.getSelectedItems(grdIf);

   var changeDate = "";
   var param = "";

   changeDate = $("#searchDate").val().replace("/","");
   changeDate = changeDate.substring(2,8) + changeDate.substring(0,2) ;

   if(selectedMasterRow[0].item.ifType == "110" || selectedMasterRow[0].item.ifType == "771"){
       param = "searchDate="+changeDate+"&ifType="+selectedMasterRow[0].item.ifType+"&tranStatusCd="+$("#tranStatusCd").val();
   }else{
	   var selectedRow = AUIGrid.getSelectedItems(grdIfDtm);
	   param = "searchDate="+changeDate+"&searchParam="+selectedRow[0].item.bizCol+"&ifType="+selectedMasterRow[0].item.ifType+"&tranStatusCd="+$("#tranStatusCd").val();
   }
   Common.ajax(
           "GET",

           "/common/selectInterfaceMonitoringKeyList.do",

           param,

           function(data, textStatus, jqXHR){ // Success
               AUIGrid.clearGridData(grdIfKey);
               AUIGrid.setGridData(grdIfKey, data);
           },

           function(jqXHR, textStatus, errorThrown){ // Error
               alert("Fail : " + jqXHR.responseJSON.message);
           }
   )
};
/****************************Transaction End********************************/
/**************************** Grid setting Start ********************************/
var gridIfKeyColumnLayout =
[
 /* PK , rowid 용 칼럼*/
 {
     dataField : "rowId",
     dataType : "string",
     visible : false
 },
 {
     dataField : "ifType",
     headerText : "IF Type",
     width:"5%"
 },
 {
     dataField : "ifTypeNm",
     headerText : "IF Type Name",
     style : "aui-grid-user-custom-left",
     width:"12%"
 },
 {
     dataField : "rgstDt",
     headerText : "Regist Date",
     width:"10%"
 },
 {
     dataField : "tranStatusCd",
     headerText : "Tran Status CD",
     width:"5%"
 },
 {
     dataField : "bizCol",
     headerText : "BIZ Col",
     width:"10%"
 },
{
    dataField : "sndChkCol",
    headerText : "BIZ ChkCol",
    width : "12%",
    style : "aui-grid-user-custom-left"
},
{
    dataField : "rcvChkCol",
    headerText : "ITF ChkCol",
    width : "12%",
    style : "aui-grid-user-custom-left"
},
{
    dataField : "chkCol",
    headerText : "Check Col",
    width:"10%"
},
{
   dataField : "sndChkVal",
   headerText : "BIZ Check Value",
   width : "18%",
   style : "aui-grid-user-custom-right"
},
{
    dataField : "rcvChkVal",
    headerText : "ITF Check Value",
    width : "18%",
    style : "aui-grid-user-custom-right"
}
];

//selectionMode (String) : 설정하고자 하는 selectionMode(유효값 : singleCell, singleRow, multipleCells, multipleRows, none)

var optionsKeyPop =
{
        editable : false,
        usePaging : true, //페이징 사용
        useGroupingPanel : false, //그룹핑 숨김
        showRowNumColumn : false, // 순번 칼럼 숨김
        applyRestPercentWidth  : false,
        rowIdField : "rowId", // PK행 지정
        selectionMode : "singleRow",
        editBeginMode : "click", // 편집모드 클릭
        /* aui 그리드 체크박스 옵션*/
        softRemovePolicy : "exceptNew" //사용자추가한 행은 바로 삭제
};

/****************************Program Init Start********************************/
$(document).ready(function(){
    // AUIGrid 그리드를 생성
    grdIfKey = GridCommon.createAUIGrid("grdIfKey", gridIfKeyColumnLayout,"", optionsKeyPop);

    fn_searchKeyPop();

});
/****************************Program Init End********************************/
</script>

<div id="popup_wrap" class="popup_wrap size_large"><!-- popup_wrap start -->
<header class="pop_header"><!-- pop_header start -->
<h1>Interface Monitoring Key</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->
<form id="searchIfKeyForm" action="#" method="post">

<div class="search_100p"><!-- search_100p start -->
<a onclick="fn_searchKeyPop()" class="search_btn"><img src="/resources/images/common/normal_search.gif" alt="search" /></a>
</div><!-- search_100p end -->

<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="grdIfKey" style="height:400px;"></div>
</article><!-- grid_wrap end -->
</form>
</section><!-- pop_body end -->

</div><!-- popup_wrap end -->