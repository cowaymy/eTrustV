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
var columnLayout1 = [
    {
        dataField : "area1",
        headerText : "Area",
        width: 150
    }, {
        dataField : "areaId1",
        headerText : "Area ID",
        width: 100
    }, {
        dataField : "city1",
        headerText : "City",
        width: 100
    }, {
        dataField : "state1",
        headerText : "State",
        width: 100
    }, {
        dataField : "postcode1",
        headerText : "Postcode",
        width: 100
    }, {
        dataField : "htCode1",
        headerText : "HT Code",
        width: 120
    },  {
        dataField : "status1",
        headerText : "Status",
        width: 100
    }
];

//그리드 속성 설정
var gridPros1 = {
        usePaging : true,
        pageRowCount : 20,
        editable : false,
        showRowCheckColumn : true
};

var myGridID1;

$(document).ready(function () {
    myGridID1 = AUIGrid.create("#grid_wrap2", columnLayout1, gridPros1);

    doGetCombo('/organization/territory/selectState.do', '', '','stateArea', 'S' , '');

});

function fn_searchCoverageArea() {
    Common.ajax("GET", "/homecare/sales/selectCovrgAreaListByGrp.do", $("#form_coverageArea").serializeJSON(), function(result) {
        AUIGrid.setGridData(myGridID1, result);
    });
}

function fn_activeCoverageArea() {
      var checkedItems = AUIGrid.getCheckedRowItemsAll(myGridID1);
      if (checkedItems.length <= 0) {
          Common.alert('No data selected.');
          return;
        }
      else {
          var rowItem;
          var areaId = "";


          for (var i = 0, len = checkedItems.length; i < len; i++) {
              rowItem = checkedItems[i];
              areaId += rowItem.areaId1;

              if (i != len - 1) {
                  areaId += ",";
                }

            }
          }

      var  saveForm ={
              "areaId":                 areaId
      }
                  Common.ajax("POST", "/homecare/sales/updateCoverageAreaActive.do", saveForm, function(result) {
                      console.log("saved.");
                      console.log( result);

                      Common.alert("<b>Coverage Area update successfully.</b>", null);
                      fn_searchCoverageArea();
                  });
  }


function fn_inactiveCoverageArea() {
    var checkedItems = AUIGrid.getCheckedRowItemsAll(myGridID1);
    if (checkedItems.length <= 0) {
        Common.alert('No data selected.');
        return;
      }
    else {
        var rowItem;
        var areaId = "";


        for (var i = 0, len = checkedItems.length; i < len; i++) {
            rowItem = checkedItems[i];
            areaId += rowItem.areaId1;

            if (i != len - 1) {
                areaId += ",";
              }

          }
        }

    var  saveForm ={
            "areaId":                 areaId
    }
                Common.ajax("POST", "/homecare/sales/updateCoverageAreaInactive.do", saveForm, function(result) {
                    console.log("saved.");
                    console.log( result);

                    Common.alert("<b>Coverage Area update successfully.</b>", null);
                    fn_searchCoverageArea();

                });
}

function fn_close(){
    $("#popup_wrap").remove();
    fn_searchCurrentCovrgArea();
}


function fn_excelDown(){
    // type : "xlsx", "csv", "txt", "xml", "json", "pdf", "object"
    GridCommon.exportTo("grid_wrap2", "xlsx", "Current Coverage Area Search");
}
</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Coverage Area Edit (Group)</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="javascript:void(0);" onclick="javascript:fn_close()">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body" style="min-height: auto;"><!-- pop_body start -->

<ul class="right_btns mb10">
 <li><p class="btn_blue"><a href="javascript:void(0);" onclick="javascript:fn_activeCoverageArea()">Active</a></p></li>
 <li><p class="btn_blue"><a href="javascript:void(0);" onclick="javascript:fn_inactiveCoverageArea()">Inactive</a></p></li>
    <li><p class="btn_blue"><a href="javascript:void(0);" onclick="javascript:fn_searchCoverageArea()"><span class="search"></span>Search</a></p></li>
</ul>

<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id="form_coverageArea">
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
    <td><input type="text" title="" placeholder="" class="w100p" id="area1" name="area" /></td>
    <th scope="row">Area ID</th>
    <td><input type="text" title="" placeholder="" class="w100p" id="areaID1" name="areaID" /></td>
    <th scope="row">Postcode</th>
    <td><input type="text" title="" placeholder="" class="w100p" id="postcode1" name="postcode" /></td>
</tr>
<tr>
    <th scope="row">City</th>
    <td><input type="text" title="" placeholder="" class="w100p" id="city1" name="city" /></td>
    <th scope="row">State</th>
    <td>
        <select class="w100p"  id="stateArea" name="state">
        </select>
    </td>
    <th scope="row">Status</th>
    <td>
        <select id="statusId" name="statusId" class="w100p">
        <option value="1">Active</option>
        <option value="8">Inactive</option>
    </select>

</tr>

</tbody>
</table><!-- table end -->

</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->
<ul class="right_btns">
    <li><p class="btn_grid"><a href="javascript:void(0);" onclick="fn_excelDown()">Excel Download</a></p></li>
</ul>

   <article class="grid_wrap">
    <!-- grid_wrap start -->
    <div id="grid_wrap2"
     style="width: 100%; height: 800px; margin: 0 auto;"></div>
   </article>

</section><!-- search_result end -->

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->