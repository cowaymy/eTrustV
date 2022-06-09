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

var myGridIDItem;

//Init Option
var ComboOption = {
        type: "S",
        chooseMessage: "Select Item Type",
        isShowChoose: false  // Choose One 등 문구 보여줄지 여부.
};

var ItmOption = {
        type: "S",
        isCheckAll: false
};



$(document).ready(function () {

    setInputFile();
    selectEditItemList();

    //PosModuleTypeComboBox
    var modulePopParam = {groupCode : 143, codeIn : [6795]};
    CommonCombo.make('posType_editItem', "/sales/pos/selectPosModuleCodeList", modulePopParam , '', ItmOption);

    //SellingTypeComboBox
    var sellingTypePopParam = {groupCode : 507, codeIn :[6796,6797]};
    CommonCombo.make('sellingType_editItem', "/sales/pos/selectPosModuleCodeList", sellingTypePopParam , '', ItmOption);

    AUIGrid.bind(myGridIDItem, "cellDoubleClick", function(event) {

		    var id  = AUIGrid.getCellValue(myGridIDItem, event.rowIndex, 'id');
		    var posType  = AUIGrid.getCellValue(myGridIDItem, event.rowIndex,  'posType');
		    var sellingType  = AUIGrid.getCellValue(myGridIDItem, event.rowIndex,  'sellingType');
		    var itemId  = AUIGrid.getCellValue(myGridIDItem, event.rowIndex,  'itemId');
		    var stkCode  = AUIGrid.getCellValue(myGridIDItem, event.rowIndex,  'stkCode');
		    var itemSize  = AUIGrid.getCellValue(myGridIDItem, event.rowIndex,  'itemSize');
		    var itemQty  = AUIGrid.getCellValue(myGridIDItem,  event.rowIndex, 'itemQty');
		    var itemCtgry  = AUIGrid.getCellValue(myGridIDItem, event.rowIndex,  'itemCtgry');
		    var totalPrice  = AUIGrid.getCellValue(myGridIDItem,  event.rowIndex, 'totalPrice');
		    var totalWeight  = AUIGrid.getCellValue(myGridIDItem,  event.rowIndex, 'totalWeight');
		    var atchFileName  = AUIGrid.getCellValue(myGridIDItem,  event.rowIndex, 'atchFileName');
		    var itemAttchGrpId  = AUIGrid.getCellValue(myGridIDItem,  event.rowIndex, 'itemAttchGrpId');

		    $("#pricePerCarton_editItem").val(totalPrice);
		    $("#unitWeight_editItem").val(totalWeight);
		    $("#size_editItem").val(itemSize);
		    $("#qtyPerCarton_editItem").val(itemQty);
		    $("#category_editItem").val(itemCtgry);
		    $("#sellingType_editItem2").val(sellingType);
		    $("#purcItems_editItem").val(stkCode);
		    $("#uploadImg").val(atchFileName);
		    $("#id_editItem").val(id);
		    $("#attachGrpId_editItem").val(itemAttchGrpId);

		    itemCodeChange(itemId);

		    $("#table_updateitem").show();
    });

});



function selectEditItemList(){

	$("#table_updateitem").hide();

        var gridProsItem = {
                usePaging           : true,         //페이징 사용
                pageRowCount        : 10,           //한 화면에 출력되는 행 개수 20(기본값:20)
                editable            : false,
                fixedColumnCount    : 1,
                showStateColumn     : true,
                displayTreeOpen     : false,
                headerHeight        : 30,
                useGroupingPanel    : false,        //그룹핑 패널 사용
                skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
                wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
                showRowNumColumn    : true,         //줄번호 칼럼 렌더러 출력
                showRowCheckColumn : false, //checkBox
                softRemoveRowMode : false
        };

        var columnLayout = [
                            {dataField: "stkCode",headerText :"Item" ,width: 100   ,height:30 , visible:true, editable : false},
                            {dataField: "sellingType",headerText :"Sales Type", width: 280    ,height:30 , visible:true, editable : false},
                            {dataField: "itemSize" ,headerText :"Size" , width:120 ,height:30 , visible:true, editable : true},
                            {dataField: "itemQty" ,headerText :"Quantity (Carton)" ,width:140 ,height:30 , visible:true, editable : false, dataType : "numeric", formatString : "#,##0"},
                            {dataField: "totalPrice" ,headerText :"Price (Carton)"  ,width:120 ,height:30 , visible:true, editable : false, dataType : "numeric", formatString : "#,##0.00"},
                            {dataField: "totalWeight" ,headerText :"Weight (Carton)" ,width:120 ,height:30 , visible:true, editable : false, dataType : "numeric", formatString : "#,##0.00"},
                            {dataField: "id" ,headerText :"ID" ,width:120   ,height:30 , visible:false, editable : false},
                            {dataField: "posType" ,headerText :"Pos Type" ,width:120   ,height:30 , visible:false, editable : false},
                            {dataField: "itemId" ,headerText :"Item Id" ,width:120   ,height:30 , visible:false, editable : false},
                            {dataField: "atchFileName" ,headerText :"Attachment" ,width:120   ,height:30 , visible:false, editable : false},
                            {dataField: "itemCtgry" ,headerText :"Item Ctgry" ,width:120   ,height:30 , visible:false, editable : false},
                            {dataField: "itemAttchGrpId" ,headerText :"Attachment Group Id" ,width:120   ,height:30 , visible:false, editable : false}
         ];


       $("#item_grid_wrap2").html("");
       myGridIDItem = GridCommon.createAUIGrid("#item_grid_wrap2", columnLayout,'', gridProsItem);
       AUIGrid.resize(myGridIDItem , 960, 300);

       Common.ajax("GET", "/sales/posstock/selectItemList", $("#form_searchitem").serializeJSON(), function(result) {
                   AUIGrid.setGridData(myGridIDItem, result);
       });

       AUIGrid.bind(myGridIDItem, "cellDoubleClick", function(event) {

               var id  = AUIGrid.getCellValue(myGridIDItem, event.rowIndex, 'id');
               var posType  = AUIGrid.getCellValue(myGridIDItem, event.rowIndex,  'posType');
               var sellingType  = AUIGrid.getCellValue(myGridIDItem, event.rowIndex,  'sellingType');
               var itemId  = AUIGrid.getCellValue(myGridIDItem, event.rowIndex,  'itemId');
               var stkCode  = AUIGrid.getCellValue(myGridIDItem, event.rowIndex,  'stkCode');
               var itemSize  = AUIGrid.getCellValue(myGridIDItem, event.rowIndex,  'itemSize');
               var itemQty  = AUIGrid.getCellValue(myGridIDItem,  event.rowIndex, 'itemQty');
               var itemCtgry  = AUIGrid.getCellValue(myGridIDItem, event.rowIndex,  'itemCtgry');
               var totalPrice  = AUIGrid.getCellValue(myGridIDItem,  event.rowIndex, 'totalPrice');
               var totalWeight  = AUIGrid.getCellValue(myGridIDItem,  event.rowIndex, 'totalWeight');
               var atchFileName  = AUIGrid.getCellValue(myGridIDItem,  event.rowIndex, 'atchFileName');
               var itemAttchGrpId  = AUIGrid.getCellValue(myGridIDItem,  event.rowIndex, 'itemAttchGrpId');



               $("#pricePerCarton_editItem").val(totalPrice);
               $("#unitWeight_editItem").val(totalWeight);
               $("#size_editItem").val(itemSize);
               $("#qtyPerCarton_editItem").val(itemQty);
               $("#category_editItem").val(itemCtgry);
               $("#sellingType_editItem2").val(sellingType);
               $("#purcItems_editItem").val(stkCode);
               $("#uploadImg").val(atchFileName);
               $("#id_editItem").val(id);
               $("#attachGrpId_editItem").val(itemAttchGrpId);

               itemCodeChange(itemId);

               $("#table_updateitem").show();
       });
}




function itemCategoryChange(){
    var val = $("#category_editItem").val();
    var itmType = {itemType : val , posItm : 1};
    CommonCombo.make('purcItems_editItem', "/sales/pos/selectPosItmList", itmType , '', ItmOption);

}


function setInputFile(){//인풋파일 세팅하기
    $(".auto_file").append("<label><span class='label_text'><a href='#'>Reupload</a></span><input type='text' id='uploadImg' class='input_text' readonly='readonly' /></label>");
}


function itemCodeChange(itemId){
    selectInventoryQty(itemId);
}

function selectInventoryQty(itemId){

      //it is going to get  inventory qty
      $("#sellingPrice_editItem").val(0);

      var param ={ "itemCode" : itemId};

        Common.ajax("POST", "/sales/posstock/selectItemPrice.do",param, function(result) {

         if(result.dataInfo != null){
             $("#sellingPrice_editItem").val(result.dataInfo.sellingPrice);
             autoCalculation();
         }
        },  function(jqXHR, textStatus, errorThrown) {
            try {
                console.log("status : " + jqXHR.status);
                console.log("code : " + jqXHR.responseJSON.code);
                console.log("message : " + jqXHR.responseJSON.message);
                console.log("detailMessage : "
                        + jqXHR.responseJSON.detailMessage);
            } catch (e) {
                console.log(e);
            }
            Common.alert("Fail : " + jqXHR.responseJSON.message);
        });

}

function autoCalculation(){
     $("#pricePerCarton_editItem").val(0);
     $("#weightPerCarton_editItem").val(0);

     var pricePerCarton = $("#qtyPerCarton_editItem").val() *  $("#sellingPrice_editItem").val();
     var weightPerCarton = $("#qtyPerCarton_editItem").val() * $("#unitWeight_editItem").val();

     $("#pricePerCarton_editItem").val(pricePerCarton);
     $("#weightPerCarton_editItem").val(weightPerCarton);

}


function fn_close(){
    $("#popup_wrap2").remove();
}

function fn_saveGrid(){

    var isVal = true;

    //Validation
    isVal = fn_chkItemVal();

    //Save
    if(isVal == false){
        return;
    }else{

          Common.ajax("POST", "/sales/posstock/updatePosEshopItemList.do", $("#form_updateitem").serializeJSON(), function(result) {
                Common.alert('Success to update');
                fn_close();

            }, function(jqXHR, textStatus, errorThrown) {
                try {
                    console.log("status : " + jqXHR.status);
                    console.log("code : " + jqXHR.responseJSON.code);
                    console.log("message : " + jqXHR.responseJSON.message);
                    console.log("detailMessage : "
                            + jqXHR.responseJSON.detailMessage);
                } catch (e) {
                    console.log(e);
                }
            });
    }
}

$(function() {

    $("#uploadfile_editItem").change(function(e){

       var formData = Common.getFormData("form_item");
       formData.append("param01", $("#param01").val());


       Common.ajaxFile("/sales/posstock/eShopItemUpload.do", formData, function(result) {
           console.log(result);
              $("#attachGrpId_editItem").val(result.atchFileGrpId);
          });
     });
});



function fn_chkItemVal(){
    var isVal = true;

    if(FormUtil.isEmpty($('#qtyPerCarton_editItem').val())) {
        Common.alert("Please key in Quantity Per Carton.");
        return false;
     }

    if(FormUtil.isEmpty($('#unitWeight_editItem').val())) {
        Common.alert("Please key in Unit Weight (KG).");
        return false;
     }

    if(FormUtil.isEmpty($('#size_editItem').val())) {
        Common.alert("Please key in Size.");
        return false;
     }

    if(FormUtil.isEmpty($('#attachGrpId_editItem').val())) {
        Common.alert("Please upload Item Image.");
        return false;
     }
}


</script>

<div id="popup_wrap2" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Edit Item</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="javascript:void(0);" onclick="javascript:fn_close()">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->



<section class="pop_body" style="min-height: auto;"><!-- pop_body start -->

<aside class=""><!-- title_line start -->
    <ul class="right_btns">
       <li><p class="btn_grid"><a id="searchBtn" onclick="javascript:selectEditItemList();"  ><span class="search"></span>Search</a></p></li>
    </ul>
</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id="form_searchitem">

<table class="type1"><!-- table start -->
<caption>table</caption>
        <colgroup>
            <col style="width:150px" />
            <col style="width:*" />
            <col style="width:150px" />
            <col style="width:*" />
        </colgroup>
    <tbody>
    <tr>
            <th scope="row">POS Type</th>
            <td><select class="w100p" id="posType_editItem"  name="posType_editItem"></select></td>

            <th scope="row">Selling Type</th>
            <td ><select class="w100p" id="sellingType_editItem"  name="sellingType_editItem"></select></td>
    </tr>
    </tbody>
</table><!-- table end -->
</form>
</section><!-- search_table end -->



<section class="search_table" style="display:none;" id="table_updateitem"><!-- search_table start -->
<form action="#" method="post" id="form_updateitem">

<!-- title_line start -->
<aside class="title_line"><h2>Selling Item Information</h2></aside>
<!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:150px" />
    <col style="width:*" />
</colgroup>
<tbody>
   <tr>
            <th scope="row">POS Type</th>
            <td ><input type="text"  class="w100p readonly"  value="e-Shop" readonly="readonly" /></td>

            <th scope="row">Selling Type</th>
            <td ><input type="text"  placeholder="" class="w100p readonly"  id="sellingType_editItem2"  name="sellingType_editItem2"  readonly="readonly"/></td>
    </tr>
<tr>
    <th scope="row">Category</th>
    <td ><input type="text"  placeholder="" class="w100p readonly"  id="category_editItem"  name="category_editItem"  readonly="readonly"/></td>
     <th scope="row">Item Type</th>
    <td><input type="text"  class="w100p readonly"  value="Item Bank" readonly="readonly" /></td>
</tr>

<tr>
   <th scope="row">Item</th>
    <td><input type="text"  placeholder="" class="w100p readonly"  id="purcItems_editItem"  name="purcItems_editItem"  readonly="readonly"/></td>
    <th scope="row"> Quantity Per Carton</th>
    <td>
           <input type="text" title="" placeholder="" class="w100p"  id="qtyPerCarton_editItem"  name="qtyPerCarton_editItem" onkeyup="autoCalculation();"/>
    </td>
</tr>

<tr>
   <th scope="row">Selling Price (RM)</th>
    <td>
           <input type="text" title="" placeholder="" class="w100p readonly"  id="sellingPrice_editItem"  name="sellingPrice_editItem"  readonly="readonly"/>
    </td>
    <th scope="row">Price Per Carton (RM)</th>
    <td>
         <input type="text" title="" placeholder="" class="w100p readonly"  id="pricePerCarton_editItem"  name="pricePerCarton_editItem" readonly="readonly" />
    </td>
</tr>

<tr>
   <th scope="row">Unit Weight (KG)</th>
    <td>
           <input type="text" title="" placeholder="" class="w100p"  id="unitWeight_editItem"  name="unitWeight_editItem" onkeyup="autoCalculation();" />
    </td>
    <th scope="row">Weight Per Carton (RM)</th>
    <td>
         <input type="text" title="" placeholder="" class="w100p readonly"  id="weightPerCarton_editItem"  name="weightPerCarton_editItem"  readonly="readonly"/>
    </td>
</tr>

<tr>
    <th scope="row">Size</th>
    <td>
           <input type="text" title="" placeholder="" class="w100p"  id="size_editItem"  name="size_editItem"  />
    </td>

    <th></th>
    <td></td>
</tr>
<input type="hidden" id="attachGrpId_editItem" name="attachGrpId_editItem"/>
<input type="hidden" id="id_editItem" name="id_editItem"/>

<tr id="">
    <th scope="row">Item Image</th>
    <td colspan="3">
    <!-- auto_file start -->
    <div class="auto_file">
        <form id="fileUploadForm_edit" method="post" enctype="multipart/form-data" action="">
            <input type="file" id="uploadfile_editItem" name="uploadfile_editItem" title="file add" />
       </form>
    </div>
    <!-- auto_file end -->
    </td>
</tr>

 </form>
</tbody>
</table><!-- table end -->

<ul class="center_btns">
    <li><p class="btn_blue2 big"><a id="btnAdd_editItem" onclick="javascript:fn_saveGrid()"  >Save</a></p></li>
    <li><p class="btn_blue2 big"><a href="javascript:void(0);" onclick="javascript:fn_close()">Cancel</a></p></li>
</ul>
</section><!-- search_table end -->


<aside class="title_line"><!-- title_line start -->
<h2>Item List</h2>
</aside><!-- title_line end -->

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="item_grid_wrap2" style="width:100%; height:300px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->



</section><!-- pop_body end -->
</div><!-- popup_wrap end -->