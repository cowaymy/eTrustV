<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<style type="text/css">
/* 커스텀 칼럼 스타일 정의 */
.aui-grid-user-custom-left {
    text-align:left;
}
/* 커스텀 칼럼 스타일 정의 */
.aui-grid-user-custom-right {
    text-align:right;
}
</style>
<script type="text/javascript">
var columnLayout = [ 
	{
	    dataField : "area",
	    headerText : "Area"
	}, {
	    dataField : "areaId",
	    headerText : "Area ID",
	    //style : "aui-grid-user-custom-left"
	}, {
        dataField : "city",
        headerText : "City",
    }, {
        dataField : "state",
        headerText : "State",
    }, {
        dataField : "postcode",
        headerText : "Postcode",
    }, {
        dataField : "codyBrnchCode", 
        headerText : "Cody Branch",
    }, {
        dataField : "ctBrnchCode",
        headerText : "CT Branch",
    }, {
        dataField : "codyMangrUserId",
        headerText : "Cody Manager",
    }, {
        dataField : "ctSubGrp",
        headerText : "CT Sub Group",
    }, {
        dataField : "status",
        headerText : "Status",
    }
];

//그리드 속성 설정
var gridPros = {
    // 페이징 사용       
    usePaging : true,
    // 한 화면에 출력되는 행 개수 20(기본값:20)
    pageRowCount : 20,
    // 셀 선택모드 (기본값: singleCell)
    selectionMode : "multipleCells"
};

var myGridID;

$(document).ready(function () {
    myGridID = AUIGrid.create("#currentTerritory_grid_wrap", columnLayout, gridPros);
    
   	doGetCombo('/organization/territory/selectCodyBranch.do', '', '','codyBranch', 'S' , '');
   	doGetCombo('/organization/territory/selectCTBranch.do', '', '','ctBranch', 'S' , '');
});

function fn_searchCurrentTerritory() {
    Common.ajax("GET", "/organization/territory/selectCurrentTerritory.do", $("#form_currentTerritory").serializeJSON(), function(result) {
        AUIGrid.setGridData(myGridID, result);
    });
}
</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Current Territory Search</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body" style="min-height: auto;"><!-- pop_body start -->

<ul class="right_btns mb10">
    <li><p class="btn_blue"><a href="#" onclick="javascript:fn_searchCurrentTerritory()"><span class="search"></span>Search</a></p></li>
</ul>

<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id="form_currentTerritory">
<!-- <input type="hidden" id="search_costCentr">
<input type="hidden" id="search_costCentrName"> -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:100px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Area</th>
    <td><input type="text" title="" placeholder="" class="w100p" id="area" name="area" /></td>
    <th scope="row">Area ID</th>
    <td><input type="text" title="" placeholder="" class="w100p" id="areaID" name="areaID" /></td>
    <th scope="row">Postcode</th>
    <td><input type="text" title="" placeholder="" class="w100p" id="postcode" name="postcode" /></td>
</tr>
<tr>
    <th scope="row">City</th>
    <td><input type="text" title="" placeholder="" class="w100p" id="city" name="city" /></td>
    <th scope="row">State</th>
    <td><input type="text" title="" placeholder="" class="w100p" id="state" name="state" /></td>
    <th scope="row"></th>
    <td></td>
</tr>
<tr>
    <th scope="row">Cody Branch</th>
    <td>
        <!-- <input type="text" title="" placeholder="" class="w100p" id="codyBranch" name="codyBranch" /> -->
        <select class="w100p"  id="codyBranch" name="codyBranch">
           <!-- <option value="" selected>Choose One</option> -->
        </select>
    </td>
    <th scope="row">CT Branch</th>
    <td>
        <!-- <input type="text" title="" placeholder="" class="w100p" id="ctBranch" name="ctBranch" /> -->
        <select class="w100p"  id="ctBranch" name="ctBranch">
           <!-- <option value="" selected>Choose One</option> -->
        </select>
    </td>
    <th scope="row">Status</th>
    <td><!-- <input type="text" title="" placeholder="" class="w100p" id="status" name="status" /> -->
        <select class="w100p"  id="status" name="status">
           <option value="" selected>Choose One</option>
           <option value="Active">Active</option>
           <option value="Complete">Complete</option>
        </select>
    </td>
</tr>
</tbody>
</table><!-- table end -->

</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<article class="grid_wrap" id="currentTerritory_grid_wrap"><!-- grid_wrap start -->
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->