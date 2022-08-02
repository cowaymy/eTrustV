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
	selectItemList();


    //Itm List
    var itmType = {itemType : 1346 , posItm : 1};
    CommonCombo.make('purcItems_addItem', "/sales/pos/selectPosItmList", itmType , '', ItmOption);

    //PosModuleTypeComboBox
    var modulePopParam = {groupCode : 143, codeIn : [6795]};
    CommonCombo.make('posType_addItem', "/sales/pos/selectPosModuleCodeList", modulePopParam , '', ItmOption);

    //SellingTypeComboBox
    var sellingTypePopParam = {groupCode : 507, codeIn :[6796,6797]};
    CommonCombo.make('sellingType_addItem', "/sales/pos/selectPosModuleCodeList", sellingTypePopParam , '', ItmOption);

});

function selectItemList(){

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
		        showRowCheckColumn : true, //checkBox
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
		                    {dataField: "posType_addItem" ,headerText :"posType_addItem" ,width:120   ,height:30 , visible:false, editable : false},
		                    {dataField: "sellingType_addItem" ,headerText :"sellingType_addItem" ,width:120   ,height:30 , visible:false, editable : false},
		                    {dataField: "category_addItem" ,headerText :"category_addItem" ,width:120   ,height:30 , visible:false, editable : false},
		                    {dataField: "itemType_addItem" ,headerText :"itemType_addItem" ,width:120   ,height:30 , visible:false, editable : false},
		                    {dataField: "purcItems_addItem" ,headerText :"purcItems_addItem" ,width:120   ,height:30 , visible:false, editable : false},
		                    {dataField: "qtyPerCarton_addItem" ,headerText :"qtyPerCarton_addItem" ,width:120   ,height:30 , visible:false, editable : false},
		                    {dataField: "sellingPrice_addItem" ,headerText :"sellingPrice_addItem" ,width:120   ,height:30 , visible:false, editable : false},
		                    {dataField: "pricePerCarton_addItem" ,headerText :"pricePerCarton_addItem" ,width:120   ,height:30 , visible:false, editable : false},
		                    {dataField: "unitWeight_addItem" ,headerText :"unitWeight_addItem" ,width:120   ,height:30 , visible:false, editable : false},
		                    {dataField: "weightPerCarton_addItem" ,headerText :"weightPerCarton_addItem" ,width:120   ,height:30 , visible:false, editable : false},
		                    {dataField: "size_addItem" ,headerText :"size_addItem" ,width:120   ,height:30 , visible:false, editable : false},
		                    {dataField: "attachGrpId_addItem" ,headerText :"attachGrpId_addItem" ,width:120   ,height:30 , visible:false, editable : false}
		 ];

	   myGridIDItem = GridCommon.createAUIGrid("#item_grid_wrap", columnLayout,'', gridProsItem);
	   AUIGrid.resize(myGridIDItem , 960, 300);
}


function itemCategoryChange(){
    var val = $("#category_addItem").val();
    var itmType = {itemType : val , posItm : 1};
    CommonCombo.make('purcItems_addItem', "/sales/pos/selectPosItmList", itmType , '', ItmOption);

}


function setInputFile(){//인풋파일 세팅하기
    $(".auto_file").append("<label><span class='label_text'><a href='#'>File</a></span><input type='text' class='input_text' readonly='readonly' /></label>");
}


function itemCodeChange(){
    selectInventoryQty();
}

function selectInventoryQty(){

      //it is going to get  inventory qty
      $("#sellingPrice_addItem").val(0);


      var param ={ "itemCode" : $("#purcItems_addItem").val()};

        Common.ajax("POST", "/sales/posstock/selectItemPrice.do",param, function(result) {

         if(result.dataInfo != null){
             $("#sellingPrice_addItem").val(result.dataInfo.sellingPrice);
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
	 $("#pricePerCarton_addItem").val(0);
	 $("#weightPerCarton_addItem").val(0);

	 var pricePerCarton = $("#qtyPerCarton_addItem").val() *  $("#sellingPrice_addItem").val();
	 var weightPerCarton = $("#qtyPerCarton_addItem").val() * $("#unitWeight_addItem").val();

	 $("#pricePerCarton_addItem").val(pricePerCarton);
     $("#weightPerCarton_addItem").val(weightPerCarton);

}


function fn_close(){
    $("#popup_wrap").remove();
}

function addItemRowToGrid(){

    var isVal = true;

    //Validation
    isVal = fn_chkItemVal();

    //Save
    if(isVal == false){
        return;
    }else{
        var item = new Object();

        var stkCodeSelect = document.getElementById("purcItems_addItem");
        var sellingTypeSelect = document.getElementById("sellingType_addItem");

        item.stkCode = stkCodeSelect.options[stkCodeSelect.selectedIndex].innerText;
        item.sellingType = sellingTypeSelect.options[sellingTypeSelect.selectedIndex].innerText;
        item.itemSize = $("#size_addItem").val();
        item.itemQty = $("#qtyPerCarton_addItem").val();
        item.totalPrice = $("#pricePerCarton_addItem").val();
        item.totalWeight = $("#weightPerCarton_addItem").val();

        item.posType_addItem = $("#posType_addItem").val();
        item.sellingType_addItem = $("#sellingType_addItem").val();
        item.category_addItem = $("#category_addItem").val();
        item.itemType_addItem = $("#itemType_addItem").val();
        item.purcItems_addItem = $("#purcItems_addItem").val();
        item.qtyPerCarton_addItem = $("#qtyPerCarton_addItem").val();
        item.sellingPrice_addItem = $("#sellingPrice_addItem").val();
        item.pricePerCarton_addItem = $("#pricePerCarton_addItem").val();
        item.unitWeight_addItem = $("#unitWeight_addItem").val();
        item.weightPerCarton_addItem = $("#weightPerCarton_addItem").val();
        item.size_addItem = $("#size_addItem").val();
        item.attachGrpId_addItem = $("#attachGrpId_addItem").val();

        item.id = "0";


        Common.ajax("GET", "/sales/posstock/checkDuplicatedStock", item, function(result) {
        	  if(result.length > 0 ){
        		  Common.alert("Same item is not allow duplicated to be added.");
        	  }else{
        		  AUIGrid.addRow(myGridIDItem, item, "first");
        	  }
        });

        //AUIGrid.addRow(myGridIDItem, item, "first");
    }
}

function fn_saveGrid(){

    var editArr = [];
    var data = {};

    editArr = GridCommon.getEditData(myGridIDItem);

    var shippingSize = AUIGrid.getGridData(myGridIDItem);

    if(shippingSize == null || shippingSize.length <= 0){
        Common.alert('<spring:message code="sal.alert.msg.noChngData" />');
        return false;
    }

    if(editArr.add != null || editArr.add.size > 0){
        data.add = editArr.add;
     }

    if(editArr.remove != null || editArr.remove.size > 0){
            data.remove = editArr.remove;
    }

    console.log(data);

    //Save
    Common.ajax("POST", "/sales/posstock/insertPosEshopItemList.do", data, function(result){
          Common.alert(result.message);
          fn_close();
    });
}


$(function() {

    $("#uploadfile_addItem").change(function(e){

       var formData = Common.getFormData("form_item");
       formData.append("param01", $("#param01").val());


       Common.ajaxFile("/sales/posstock/eShopItemUpload.do", formData, function(result) {
    	      $("#attachGrpId_addItem").val(result.atchFileGrpId);
          });
     });

    $("#btnDel_addItem").click(function() {
        AUIGrid.removeCheckedRows(myGridIDItem);
    });

});



function fn_chkItemVal(){
    var isVal = true;

    if(FormUtil.isEmpty($('#posType_addItem').val())) {
        Common.alert("Please choose POS Type.");
    	return false;
    }

    if(FormUtil.isEmpty($('#sellingType_addItem').val())) {
        Common.alert("Please choose Selling Type.");
        return false;
     }

    if(FormUtil.isEmpty($('#category_addItem').val())) {
        Common.alert("Please choose Category.");
        return false;
     }

    if(FormUtil.isEmpty($('#itemType_addItem').val())) {
        Common.alert("Please choose Item Type.");
        return false;
     }

    if(FormUtil.isEmpty($('#purcItems_addItem').val())) {
        Common.alert("Please choose Item.");
        return false;
     }

    if(FormUtil.isEmpty($('#qtyPerCarton_addItem').val())) {
        Common.alert("Please key in Quantity Per Carton.");
        return false;
     }

    if(FormUtil.isEmpty($('#unitWeight_addItem').val())) {
        Common.alert("Please key in Unit Weight (KG).");
        return false;
     }

    if(FormUtil.isEmpty($('#size_addItem').val())) {
        Common.alert("Please key in Size.");
        return false;
     }

    if(FormUtil.isEmpty($('#attachGrpId_addItem').val())) {
        Common.alert("Please upload Item Image.");
        return false;
     }
}


</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Add Item</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="javascript:void(0);" onclick="javascript:fn_close()">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body" style="min-height: auto;"><!-- pop_body start -->

<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id="form_item">
<!-- <input type="hidden" id="search_costCentr">
<input type="hidden" id="search_costCentrName"> -->

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
		    <td>
		    <select class="w100p" id="posType_addItem"  name="posType_addItem"></select>
<!-- 		           <input type="text" title="" placeholder="" class="w100p"  id="posType_addItem"  name="posType_addItem"  value="e-Shop"/> -->
		    </td>

		    <th scope="row">Selling Type</th>
		    <td >
		          <select class="w100p" id="sellingType_addItem"  name="sellingType_addItem"></select>
		    </td>
    </tr>
    </tbody>
</table><!-- table end -->

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
    <th scope="row">Category</th>
    <td >
            <select class="w100p" id="category_addItem" name="category_addItem"  onchange="itemCategoryChange();">
                <option value="1346">Merchandise Item</option>
                <option value="1348">Misc Item</option>
                <option value="1347">Uniform</option>
            </select>
    </td>
     <th scope="row">Item Type</th>
    <td>
            <select class="w100p" id="itemType_addItem" name="itemType_addItem"  >
                <option value="1353">Item Bank</option>
            </select>
   </td>
</tr>

<tr>
   <th scope="row">Item</th>
    <td>
        <select class="w100p" id="purcItems_addItem" name="purcItems_addItem"  onchange="itemCodeChange();" ></select>
    </td>
    <th scope="row"> Quantity Per Carton</th>
    <td>
           <input type="text" title="" placeholder="" class="w100p"  id="qtyPerCarton_addItem"  name="qtyPerCarton_addItem" onkeyup="autoCalculation();"/>
    </td>
</tr>

<tr>
   <th scope="row">Selling Price (RM)</th>
    <td>
           <input type="text" title="" placeholder="" class="w100p readonly"  id="sellingPrice_addItem"  name="sellingPrice_addItem"  readonly="readonly"/>
    </td>
    <th scope="row">Price Per Carton (RM)</th>
    <td>
         <input type="text" title="" placeholder="" class="w100p readonly"  id="pricePerCarton_addItem"  name="pricePerCarton_addItem" readonly="readonly" />
    </td>
</tr>

<tr>
   <th scope="row">Unit Weight (KG)</th>
    <td>
           <input type="text" title="" placeholder="" class="w100p"  id="unitWeight_addItem"  name="unitWeight_addItem" onkeyup="autoCalculation();" />
    </td>
    <th scope="row">Weight Per Carton (KG)</th>
    <td>
         <input type="text" title="" placeholder="" class="w100p readonly"  id="weightPerCarton_addItem"  name="weightPerCarton_addItem"  readonly="readonly"/>
    </td>
</tr>

<tr>
    <th scope="row">Size</th>
    <td>
           <input type="text" title="" placeholder="" class="w100p"  id="size_addItem"  name="size_addItem"  />
    </td>

    <th></th>
    <td></td>
</tr>
<input type="hidden" id="attachGrpId_addItem" name="attachGrpId_addItem"/>

<tr id="">
    <th scope="row">Item Image</th>
    <td colspan="3">
    <!-- auto_file start -->
    <div class="auto_file">
<!--         <form id="fileUploadForm" method="post" enctype="multipart/form-data" action=""> -->
            <input type="file" id="uploadfile_addItem" name="uploadfile_addItem" title="file add" />
<!--        </form> -->
    </div>
    <!-- auto_file end -->
    </td>
</tr>

 </form>
</tbody>
</table><!-- table end -->


</section><!-- search_table end -->

<ul class="center_btns">
    <li><p class="btn_blue2 big"><a id="btnAdd_addItem" onclick="javascript:addItemRowToGrid()"  >Add</a></p></li>
    <li><p class="btn_blue2 big"><a href="javascript:void(0);" onclick="javascript:fn_close()">Cancel</a></p></li>
</ul>


<aside class="title_line"><!-- title_line start -->
<h2>Item List</h2>
</aside><!-- title_line end -->

<ul class="right_btns">
    <li><p class="btn_grid"><a id="btnDel_addItem"><spring:message code="sal.btn.del" /></a></p></li>
</ul>


<article class="grid_wrap"><!-- grid_wrap start -->
<div id="item_grid_wrap" style="width:100%; height:300px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->
<ul class="center_btns">
    <li><p class="btn_blue2 big"><a id="btnSave_AddItem" onclick="javascript:fn_saveGrid()" ><spring:message code="sal.btn.save" /></a></p></li>
</ul>
<form id="form_delArr"><input type="hidden" id="delArr_addItem" name="delArr_addItem"/></form>

</section><!-- pop_body end -->
</div><!-- popup_wrap end -->