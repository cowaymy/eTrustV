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
        headerText : "Area",
        width: 250
    }, {
        dataField : "areaId",
        headerText : "Area ID",
        width: 200
    }, {
        dataField : "city",
        headerText : "City",
        width: 150
    }, {
        dataField : "state",
        headerText : "State",
        width: 150
    }, {
        dataField : "postcode",
        headerText : "Postcode",
        width: 100
    },  {
        dataField : "name",
        headerText : "Status",
        width: 100
    },  {
        dataField : "htCode",
        headerText : "HT Code",
        width: 100
    }, {
        dataField : "areaRem",
        headerText : "Remark",
        width: 200
    },  {
        dataField : "areaCovrgId",
        headerText : "ID",
        width: 100,
        visible : false
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
    myGridID = AUIGrid.create("#grid_wrap", columnLayout, gridPros);

    doGetCombo('/organization/territory/selectState.do', '', '','state', 'S' , '');
});

function fn_searchCurrentCovrgArea() {
    Common.ajax("GET", "/homecare/sales/selectCovrgAreaList.do", $("#searchForm").serializeJSON(), function(result) {
        AUIGrid.setGridData(myGridID, result);
    });
}

function fn_updateCurrentCovrgArea() {
	  var selIdx = AUIGrid.getSelectedIndex(myGridID)[0];
	    if(selIdx > -1) {
	        Common.popupDiv("/homecare/sales/htUpdateCovrgAreaStatusPop.do", { areaId : AUIGrid.getCellValue(myGridID, selIdx, "areaId")}, null , true);
	    }
	    else {
	    	Common.alert('No data selected.');
	    }
}

function fn_updateCovrgAreaByGrp(){
    Common.popupDiv("/homecare/sales/htUpdateCovrgAreaStatusByGrpPop.do", null, null , true);

}

function fn_excelDown(){
    // type : "xlsx", "csv", "txt", "xml", "json", "pdf", "object"
    GridCommon.exportTo("grid_wrap", "xlsx", "Coverage Area Search");
}

</script>

<form action="#" id="searchForm" name="searchForm">

<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>Sales</li>
    <li>Order list</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>Coverage Area Management</h2>
<ul class="right_btns">
<li><p class="btn_blue"><a href="javascript:void(0);" onclick="javascript:fn_updateCurrentCovrgArea()"><span class="update"></span>Update Status</a></p></li>

<li><p class="btn_blue"><a href="javascript:void(0);" onclick="javascript:fn_updateCovrgAreaByGrp()"><span class="update"></span>Update Status (Group)</a></p></li>
<%-- <c:if test="${PAGE_AUTH.funcView == 'Y'}"> --%>
  <li><p class="btn_blue"><a href="javascript:void(0);" onclick="javascript:fn_searchCurrentCovrgArea()"><span class="search"></span>Search</a></p></li>
<%-- </c:if> --%>
</ul>

</aside>


<div id="covrgAreaMgmt" style="display:block;">
            <section class="search_table"><!-- search_table start -->
            <table class="type1"><!-- table start -->
            <caption>table</caption>
            <colgroup>
                <col style="width:100px" />
                <col style="width:*" />
                <col style="width:100px" />
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
    <td>
        <select class="w100p"  id="state" name="state">
        </select>
    </td>
    <th scope="row">Status</th>
    <td><!-- <input type="text" title="" placeholder="" class="w100p" id="status" name="status" /> -->
        <select class="w100p"  id="status" name="status">
           <option value="" selected>Choose One</option>
           <option value="1">Active</option>
           <option value="8">Inactive</option>

        </select>
    </td>
</tr>
            </tbody>
            </table><!-- table end -->

            </section><!-- search_table end -->

</div>
    <ul class="right_btns">


    </ul>

<section class="search_result"><!-- search_result start -->

<ul class="right_btns">
    <li><p class="btn_grid"><a href="javascript:void(0);" onclick="fn_excelDown()">Excel Download</a></p></li>
</ul>
<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="grid_wrap" style="width: 100%; height: 500px; margin: 0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

<ul class="center_btns">
<!--     <li><p class="btn_blue2"><a href="#">Cody Assign</a></p></li> -->
</ul>

</section><!-- content end -->
</form>