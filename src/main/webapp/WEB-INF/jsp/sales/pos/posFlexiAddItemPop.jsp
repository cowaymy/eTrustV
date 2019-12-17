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
var columnLayoutPOS = [
    {
        dataField : "itemCode",
        headerText : "Item Code",
        width: 150
    }, {
        dataField : "itemDesc",
        headerText : "Item Description",
        width: 200
    }, {
        dataField : "itemCategory",
        headerText : "Item Type",
        width: 200
    },  {
        dataField : "status",
        headerText : "Status",
        width: 100
    },  {dataField : "itmId", visible : false}
];

//그리드 속성 설정
var gridProsPOS = {
        usePaging : true,
        pageRowCount : 20,
        editable : false,
        showRowCheckColumn : true
};

var myGridIDPOS;

//Init Option
var ComboOption = {
        type: "S",
        chooseMessage: "Select Item Type",
        isShowChoose: false  // Choose One 등 문구 보여줄지 여부.
};

$(document).ready(function () {
    myGridIDPOS = AUIGrid.create("#grid_wrapPOS", columnLayoutPOS, gridProsPOS);

/*     var codes = [1346 ,1348];
    var codeM = {codeM : 11 , codes : codes};
    CommonCombo.make('_purcItemType', "/sales/pos/selectPosTypeList", codeM , '', ComboOption); */

});

function fn_searchPOSFlexiItem() {
    Common.ajax("GET", "/sales/pos/selectPOSFlexiItem.do", $("#form_POSFlexiItem").serializeJSON(), function(result) {
        AUIGrid.setGridData(myGridIDPOS, result);
    });
}


function fn_activePOSFlexiItem() {
      var checkedItems = AUIGrid.getCheckedRowItemsAll(myGridIDPOS);
      if (checkedItems.length <= 0) {
          Common.alert('No data selected.');
          return;
        }
      else {
          var rowItem;
          var stkId = "";


          for (var i = 0, len = checkedItems.length; i < len; i++) {
              rowItem = checkedItems[i];
              stkId += rowItem.itemId;

              if (i != len - 1) {
                  stkId += ",";
                }

            }
          }

      var  saveForm ={
              "stkId":                 stkId
      }
                  Common.ajax("POST", "/sales/pos/updatePOSFlexiItemActive.do", saveForm, function(result) {
                      console.log("saved.");
                      console.log( result);

                      Common.alert("<b>POS Flexi Item update successfully.</b>", null);
                      fn_searchPOSFlexiItem();
                  });
  }


function fn_inactivePOSFlexiItem() {
    var checkedItems = AUIGrid.getCheckedRowItemsAll(myGridIDPOS);
    if (checkedItems.length <= 0) {
        Common.alert('No data selected.');
        return;
      }
    else {
        var rowItem;
        var stkId = "";


        for (var i = 0, len = checkedItems.length; i < len; i++) {
            rowItem = checkedItems[i];
            stkId += rowItem.itemId;

            if (i != len - 1) {
                stkId += ",";
              }

          }
        }

    var  saveForm ={
            "stkId":                 stkId
    }
                Common.ajax("POST", "/sales/pos/updatePOSFlexiItemInactive.do", saveForm, function(result) {
                    console.log("saved.");
                    console.log( result);

                    Common.alert("<b>POS Flexi Item update successfully.</b>", null);
                    fn_searchPOSFlexiItem();

                });
}

function fn_close(){
    $("#popup_wrap").remove();
}


function fn_excelDown(){
    // type : "xlsx", "csv", "txt", "xml", "json", "pdf", "object"
    GridCommon.exportTo("grid_wrapPOS", "xlsx", "POS Flexi Item Search");
}
</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>POS - Flexi Item</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="javascript:void(0);" onclick="javascript:fn_close()">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body" style="min-height: auto;"><!-- pop_body start -->

<ul class="right_btns mb10">
<li><p class="btn_blue"><a href="javascript:void(0);" onclick="javascript:fn_activePOSFlexiItem()">Active</a></p></li>
 <li><p class="btn_blue"><a href="javascript:void(0);" onclick="javascript:fn_inactivePOSFlexiItem()">Inactive</a></p></li>
    <li><p class="btn_blue"><a href="javascript:void(0);" onclick="javascript:fn_searchPOSFlexiItem()"><span class="search"></span>Search</a></p></li>
</ul>

<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id="form_POSFlexiItem">
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
    <th scope="row"><spring:message code="sal.title.itmType" /></th>
    <td>       <select id="itemTypeCategory" name="itemTypeCategory" class="w100p">
        <option value="1346">Merchandise Item</option>
        <option value="1348">Misc Item</option>
    </select></td>
    <th scope="row"><spring:message code="sal.title.itemCode" /></th>
    <td><input type="text" title="" placeholder="" class="w100p" id="stkCode" name="stkCode" /></td>
</tr>
<tr>
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
    <div id="grid_wrapPOS"
     style="width: 100%; height: 800px; margin: 0 auto;"></div>
   </article>

</section><!-- search_result end -->

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->