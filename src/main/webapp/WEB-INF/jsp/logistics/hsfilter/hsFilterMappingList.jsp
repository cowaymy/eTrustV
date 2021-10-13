<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp" %>

<style type="text/css">



<style type="text/css">

/* 커스텀 칼럼 스타일 정의 */
.aui-grid-user-custom-left {
    text-align:left;
}
.aui-grid-user-custom-right {
    text-align:right;
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



//AUIGrid  ID
var mstGridID;


var keyValueList = [{"code":"", "value":"Choose One"} ,{"code":"Y", "value":"Y"}, {"code":"N", "value":"N"}];

var columnLayout = [
                    {dataField: "hsLoseLoclCode",headerText :"Location Code"          ,width:180   ,height:30 , visible:true,editable : false},
                    {dataField: "hsLoseLoclDesc",headerText :"Location"      ,width:200   ,height:30 , visible:true,editable : false},
                    {dataField: "hsLoseItemCode",headerText :"Code"          ,width:120   ,height:30 , visible:true, editable : false},
                    {dataField: "hsLoseItemDesc",headerText :"Desc"          ,width:200   ,height:30 , visible:true ,editable : false},
                    {dataField: "hsLoseItemCtgryDesc",headerText :"Stock Category"          ,width:180   ,height:30 , visible:true,editable : false},
                    {dataField: "hsLoseItemTypeDesc",headerText :"Stock Type"      ,width:200   ,height:30 , visible:true,editable : false},
                     {dataField: "hsLoseItemFcastQty",headerText :"Forecast Quantity"      ,width:200   ,height:30 , visible:true,editable : false},
                    {dataField: "hsLoseItemReordQty",headerText :"Reorder(20%) Q'ty"      ,width:200   ,height:30 , visible:true,editable : false}
           ];


createAUIGrid =function(columnLayout ){

var auiGridProps = {

            editable : true,

            // 그룹핑 패널 사용
            useGroupingPanel : true,

            // 필터 사용
            enableFilter : true,

            // 차례로 country, product, name 순으로 그룹핑을 합니다.
            // 즉, 각 나라별, 각 제품을 구매한 사용자로 그룹핑
            groupingFields : ["hsLoseLoclCode"],

            // 합계(소계) 설정
            groupingSummary  : {
                // 합계 필드는 price 1개에 대하여 실시 합니다.
                dataFields : [ "hsLoseItemFcastQty" ]
            },

            // 최초 보여질 때 모두 열린 상태로 출력 여부
            displayTreeOpen : true,

            // 그룹핑 후 셀 병합 실행
            enableCellMerge : true,

            // enableCellMerge 할 때 실제로 rowspan 적용 시킬지 여부
            // 만약 false 설정하면 실제 병합은 하지 않고(rowspan 적용 시키지 않고) 최상단에 값만 출력 시킵니다.
            cellMergeRowSpan : true,

            // 브랜치에 해당되는 행을 출력 여부
            showBranchOnGrouping : false,

            // 그리드 ROW 스타일 함수 정의
            rowStyleFunction : function(rowIndex, item) {

                if(item._$isGroupSumField) { // 그룹핑으로 만들어진 합계 필드인지 여부

                    // 그룹핑을 더 많은 필드로 하여 depth 가 많아진 경우는 그에 맞게 스타일을 정의하십시오.
                    // 현재 3개의 스타일이 기본으로 정의됨.(AUIGrid_style.css)
                    switch(item._$depth) {  // 계층형의 depth 비교 연산
                    case 2:
                        return "aui-grid-row-depth1-style";
                    case 3:
                        return "aui-grid-row-depth2-style";
                    case 4:
                        return "aui-grid-row-depth3-style";
                    default:
                        return "aui-grid-row-depth-default-style";
                    }
                }

                return null;
            } // end of rowStyleFunction
    };

    // 실제로 #grid_wrap 에 그리드 생성
    mstGridID = AUIGrid.create("#main_grid_wrap", columnLayout, auiGridProps);
}





var paramdata;

$(document).ready(function(){


    /**********************************
    * Header Setting
    **********************************/

    doGetCombo('/common/selectCodeList.do', '15', '', 'searchType', 'M','f_multiComboType');
    doGetCombo('/common/selectCodeList.do', '11', '','searchCtgry', 'M' , 'f_multiCombos');


   var  notin =[1,3,5]
    doGetComboData('/logistics/HsFilterLoose/selectMappingLocationType.do', { groupCode : 339 }, '', 'searchlocgb', 'M','f_multiCombo');
  // doGetComboData('/common/selectCodeList.do', { groupCode : 383 , orderValue : 'CODE'}, 'A', 'searchlocgrade', 'S','');

    doGetComboData('/logistics/HsFilterLoose/selectMiscBranchList.do', '', '','searchBranch', 'S' , '');

    doGetComboData('/logistics/totalstock/selectCDCList.do', '', '','searchCDC', 'S' , '');

    createAUIGrid(columnLayout);

});


//btn clickevent
$(function(){



    $('#searchMatName').keypress(function(event) {
        $('#searchMatCode').val('');
        if (event.which == '13') {
            $("#stype").val('stock');
            $("#svalue").val($('#searchMatName').val());
            $("#sUrl").val("/logistics/material/materialcdsearch.do");
            Common.searchpopupWin("searchForm", "/common/searchPopList.do","stock");
        }
    });


    $("#mainBt_dw").click(function() {
        GridCommon.exportTo("main_grid_wrap", 'xlsx', "CDC vs CDB Mapping List");
    });

    $("#searchBranch").change(function(){
        if(($('#searchlocgb').val() == "04") && ($('#searchBranch').val() != "")){
            console.log("choose cody and branch is selected.");
            var paramdata = {
                    searchBranch : $("#searchBranch").val(),
                    locgb : 'CT'
                };
            doGetComboData('logistics/HsFilterLoose/selectMappingCdbLocationList.do', paramdata , '', 'searchLoc', 'M','f_multiComboType');
        }
    });
});


function fn_getDataListAjax() {

	 if ($("#forecastMonth").val() == null || $("#forecastMonth").val() == undefined || $("#forecastMonth").val() == ""){
           Common.alert("Please Select Forecast Month.");
           return false;
    }

    var url = "/logistics/HsFilterLoose/selectHSFilterMappingList.do";
    var param = $('#searchForm').serialize();

    Common.ajax("GET" , url , param , function(data){
    	console.log(data)
        AUIGrid.setGridData(mstGridID, data);

    });
}

function f_validatation(){

			   if ($("#forecastMonth").val() == null || $("#forecastMonth").val() == undefined || $("#forecastMonth").val() == ""){
		           Common.alert("Please Select Forecast Month.");
		           return false;
		       }

             if ($("#searchLoc").val() == null || $("#searchLoc").val() == undefined || $("#searchLoc").val() == ""){
                 Common.alert("Please Select Location.");
                 return false;
             }
             else {
                 return true;
             }
}

function f_multiCombo() {
    $(function() {
        $('#searchlocgb').change(function() {
            //console.log('1');
            if ($('#searchlocgb').val() != null && $('#searchlocgb').val() != "" ){
                 var searchlocgb = $('#searchlocgb').val();

                    var locgbparam = "";
                    for (var i = 0 ; i < searchlocgb.length ; i++){
                        if (locgbparam == ""){
                            locgbparam = searchlocgb[i];
                        }else{
                            locgbparam = locgbparam +"∈"+searchlocgb[i];
                        }
                    }
                    var param = {searchlocgb:locgbparam , grade:'A',
                            searchBranch: ($('#searchBranch').val() )}
                    doGetComboData('/logistics/HsFilterLoose/selectMappingCdbLocationList.do', param , '', 'searchLoc', 'M','f_multiComboType');
              }
        })
         .multipleSelect({
            selectAll : true
        });
    });
}
function f_multiComboType() {
    $(function() {
        $('#searchType').change(function() {
        }).multipleSelect({
            selectAll : true
        });  /* .multipleSelect("checkAll"); */

        $('#searchLoc').change(function() {
        }).multipleSelect({
            selectAll : true
        });

    });
}
function f_multiCombos() {
    $(function() {
        $('#searchCtgry').change(function() {
        }).multipleSelect({
            selectAll : true
        }); /* .multipleSelect("checkAll"); */
    });
}

function searchlocationFunc(){
    console.log('111');
}



</script>




<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>logistics</li>
    <li>HS Filter</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>HS Forecast History</h2>

  <ul class="right_btns">

      <li><p class="btn_blue"><a id="search" onclick="javascript:fn_getDataListAjax();"  ><span class="search"   ></span>Search</a></p></li>
    </ul>
</aside><!-- title_line end -->




<section class="search_table"><!-- search_table start -->
    <form id="searchForm" name="searchForm" method="post" onsubmit="return false;">

        <table class="type1"><!-- table start -->
            <caption>search table</caption>
            <colgroup>
                <col style="width:140px" />
                <col style="width:*" />
                <col style="width:140px" />
                <col style="width:*" />
                <col style="width:140px" />
                <col style="width:*" />
            </colgroup>
            <tbody>
              <tr>
                   <th scope="row">Branch</th>
                   <td>
                   <select class="w100p" id=searchBranch  name="searchBranch"></select>
                   </td>
                   <th scope="row">CDC</th>
                   <td>
                        <select class="w100p" id="searchCDC" name="searchCDC"></select>
                   </td>
                   <!-- <th scope="row"></th> -->
                   <td colspan="2">
                   </td>
                </tr>
                <tr>
                   <th scope="row">Location Type</th>
                   <td>
                        <select id="searchlocgb" name="searchlocgb" class="multy_select w100p"multiple="multiple"></select>
<!--                         <INPUT type="hidden" class="w100p" id="searchLoc" name="searchLoc"> -->
<!--                         <INPUT type="text"   class="w100p" id="searchLocNm" name="searchLocNm"> -->
                   </td>

                   <th scope="row">Location</th>
                   <td>
                        <select class="w100p" id="searchLoc" name="searchLoc" class="multy_select w100p"multiple="multiple"></select>
                   </td>
                <th scope="row" > Forecast Month <span class="must">*</span></th>
			    <td>
			    <input type="text" title="기준년월" class="j_date2" id="forecastMonth" name="forecastMonth"/>
			    </td>

                </tr>
                <tr>
                   <th scope="row">Material Code/Name</th>
                   <td >
                      <input type="hidden" title="" placeholder=""  class="w100p" id="searchMatCode" name="searchMatCode"/>
                      <input type="text"   title="" placeholder=""  class="w100p" id="searchMatName" name="searchMatName"/>
                   </td>
                    <th scope="row">Category</th>
                   <td>
                       <select class="w100p" id="searchCtgry"  name="searchCtgry"></select>
                   </td>
                   <th scope="row">Type</th>
                   <td>
                       <select class="w100p" id="searchType" name="searchType"></select>
                   </td>
                </tr>

            </tbody>
        </table><!-- table end -->

    </form>

    </section><!-- search_table end -->



<!-- data body start -->
    <section class="search_result"><!-- search_result start -->





        <ul class="right_btns">
                <li><p class="btn_grid"><a id="mainBt_dw" >Excel Dw</a></p></li>
         </ul>

         <article class="grid_wrap"><!-- grid_wrap start -->
               <div id="main_grid_wrap" class="autoGridHeight"></div>
         </article><!-- grid_wrap end -->


<!--
        <article class="tap_area">

         <ul class="right_btns">
                <li><p class="btn_grid"><a id="subBt_save" >Save</a></p></li>
                <li><p class="btn_grid"><a id="subBt_upload" >Upload</a></p></li>
                <li><p class="btn_grid"><a id="subBt_dw" >Excel Dw</a></p></li>
         </ul>
            <article class="grid_wrap">
                 <div id="sub_grid_wrap"  class="mt10" style="height:450px"></div>
            </article>
        </article>
 -->



    </section><!-- search_result end -->

</section><!-- pop_body end -->
