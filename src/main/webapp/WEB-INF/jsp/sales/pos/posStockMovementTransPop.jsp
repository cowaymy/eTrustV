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
var keyValueList = [{"code":"N", "value":"New"}, {"code":"R", "value":"Replacement"}];
var columnLayout = [
                    {dataField: "itemCode",headerText :"Item Code",width: 100,height:30 , visible:false, editable : false},
                    {dataField: "itemDesc",headerText :"Item Description",width: 280 , height:30 , visible:true, editable : false},
                    {dataField: "itemInvtQty" ,headerText :"Quantity(F)",width:120 , height:30 , visible:true, editable : false ,dataType : "numeric", formatString : "#,##0"},
                    {dataField: "itemToInvtQty" ,headerText :"Quantity(T)",width:120, height:30 , visible:false, editable : false ,dataType : "numeric", formatString : "#,##0"},
                    {dataField: "scnItemMoveType" ,headerText :"itemType",width:120, height:30 , visible:false, editable : false},
                    {dataField: "itemPurhOrdNo" ,headerText :"itemPoOrdNo" ,width:120, height:30 , visible:false, editable : false},
                    {dataField: "scnFromLocId" ,headerText :"itemFromBrnchId",width:120 , height:30 , visible:false, editable : false},
                    {dataField: "itemCtgryId" ,headerText :"itemCategory",width:120 , height:30 , visible:false, editable : false},
                    {dataField: "itemTranQty" ,headerText :"Transfer Quantity",width:150, height:30 , visible:true, editable : false,dataType : "numeric", formatString : "#,##0"},
                    {dataField: "itemRecvQty" ,headerText :"itemRecvQty",width:120, height:30 , visible:false, editable : false},
                    {dataField: "itemVariQty" ,headerText :"itemVariQty",width:120, height:30 , visible:false, editable : false},
                    {dataField: "itemReason" ,headerText :"itemReason" ,width:120, height:30 , visible:false, editable : false},
//                     {dataField: "itemCond" ,headerText :"itemCond",width:120 , height:30 , visible:false, editable : false},
                    {dataField: "itemCond",headerText :"Condition"  ,width:150    ,height:30 , visible:true ,
                        renderer : {
                            type : "DropDownListRenderer",
                            list : keyValueList, //key-value Object 로 구성된 리스트
                            keyField : "code", // key 에 해당되는 필드명
                            valueField : "value" // value 에 해당되는 필드명
                        }
                    },
 ];


//그리드 속성 설정
var gridProsPOS = {
        selectionMode : "singleRow",
        editable : false
};

var myGridIDPOS;

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
    //branch List
    var selVal = '${branchId}';
    document.querySelector("#fromTransBrnchId").innerHTML = document.querySelector("#scnFromLocId").getInnerHTML();
    document.querySelector("#toTransBrnchId").innerHTML = document.querySelector("#scnFromLocId").getInnerHTML();
    $('#toTransBrnchId').val("");

    //Itm List
    var itmType = {itemType : 1346 , posItm : 1};
    CommonCombo.make('purcItems', "/sales/pos/selectPosItmList", itmType , '', ItmOption);

    myGridIDPOS = GridCommon.createAUIGrid("#grid_wrapPOS", columnLayout, gridProsPOS);

});

function initCallback(){
	$('#toTransBrnchId').val("");
}

function itemCategoryChange(){
    var val = $("#category").val();
    var itmType = {itemType : val , posItm : 1};
    CommonCombo.make('purcItems', "/sales/pos/selectPosItmList", itmType , '', ItmOption);
}


function itemCodeChange(){
//     $("#itemCond").val("");
    $("#itemTransQty").val("");

    selectInventoryQty();

}

function selectInventoryQty(){
	  //it is going to get  inventory qty
      $("#itemQty").val(0);

	  var param ={ "itemCode" : $("#purcItems").val() , "locId" : $("#fromTransBrnchId").val()  };

	    Common.ajax("POST", "/sales/posstock/selectItemInvtQty.do",param, function(result) {

	     if(result.dataInfo != null){
	         $("#itemQty").val(result.dataInfo.itemInvQty);
	     }

	    },  function(jqXHR, textStatus, errorThrown) {
	        try {
	            console.log("status : " + jqXHR.status);
	            console.log("code : " + jqXHR.responseJSON.code);
	            console.log("message : " + jqXHR.responseJSON.message);
	            console.log("detailMessage : " + jqXHR.responseJSON.detailMessage);
	        } catch (e) {
	            console.log(e);
	        }
	        Common.alert("Fail : " + jqXHR.responseJSON.message);
	    });

}




function transFromBrnchChange(){

    if  (AUIGrid.getRowCount(myGridIDPOS) ==0 )  return ;

    var msg = "Grid will be initialized \n"+" Do you still want to change it?" ;
    Common.confirm(msg, function (){
          AUIGrid.clearGridData(myGridIDPOS);
    }, function(){return;})
}

function transToBrnchChange(){

	if  (AUIGrid.getRowCount(myGridIDPOS) ==0 )  return ;
	var msg = "Grid will be initialized \n"+" Do you still want to change it?" ;
	Common.confirm(msg, function (){ AUIGrid.clearGridData(myGridIDPOS);}, function(){return;})
}


function addRow() {

    var item = new Object();
    item.itemCode  = $("#purcItems").val() ,
    item.itemDesc  = $( "#purcItems option:selected" ).text(),
    item.itemInvtQty    = $("#itemQty").val(),
    item.itemTranQty    = $("#itemTransQty").val(),
    item.scnFromLocId   = $("#fromTransBrnchId").val(),
    item.scnToLocId   = $("#toTransBrnchId").val(),
    item.itemCtgryId  = $("#category").val(),
    item.scnItemMoveType  = $("#itemType").val();
    item.itemCond = "";


    if($("#purcItems").val() == "" || $("#fromTransBrnchId").val() =="" || $("#toTransBrnchId").val() =="" || $("#itemTransQty").val() =="") {
        Common.alert("Transfer to branch / Item / Transfer Quantity is required.");
        return ;
    }

    if($("#fromTransBrnchId").val() == $("#toTransBrnchId").val() ){
    	   Common.alert("Can't transfer to same brnch.");
           return ;
    }

    if($("#itemQty").val() ==null ||  $("#itemQty").val()   ==""){
        Common.alert("Check the inventory quantity.");
        return ;
    }

    if(parseInt($("#itemTransQty").val()) >  parseInt( $("#itemQty").val())   ){
        Common.alert("Check the inventory quantity.");
        return ;
    }

    if( AUIGrid.isUniqueValue (myGridIDPOS,"itemCode" ,item.itemCode )){
        AUIGrid.addRow(myGridIDPOS, item, "last");
    }
    else{
        Common.alert("<b>"+ item.itemDesc +"  is existing. </br>");
        return ;
    }
}


function removeRow(){
    AUIGrid.removeRow(myGridIDPOS, "selectedIndex");
    AUIGrid.removeSoftRows(myGridIDPOS);
}

function auiRemoveRowHandler(){}

function fn_close(){
    $("#popup_wrap").remove();
}

function fn_saveGrid(){

	let editList = GridCommon.getEditData(myGridIDPOS).add;

    if(!editList.every((e)=> {
            if(FormUtil.isEmpty(e.itemCond)) return false;
        return true;
     })){
        Common.alert("Please fill in Conditions.");
        return;
     }

    Common.ajax("POST", "/sales/posstock/insertTransPosStock.do", GridCommon.getEditData(myGridIDPOS), function(result) {
        Common.alert('SCN Number is : '+result.data);
    }, function(jqXHR, textStatus, errorThrown) {
        try {
            console.log("status : " + jqXHR.status);
            console.log("code : " + jqXHR.responseJSON.code);
            console.log("message : " + jqXHR.responseJSON.message);
            console.log("detailMessage : " + jqXHR.responseJSON.detailMessage);
        } catch (e) {
            console.log(e);
        }
    });
}

</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Stock Transfer</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="javascript:void(0);" onclick="javascript:fn_close()">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body" style="min-height: auto;"><!-- pop_body start -->



<aside class="title_line"><!-- title_line start -->
<h2>Transfer Information</h2>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id="form_view">
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
    <th scope="row">Transfer From</th>
    <td colspan="3">
        <select class="w100p " id="fromTransBrnchId" name="fromTransBrnchId"  onchange="transFromBrnchChange()" ></select>
    </td>
</tr>

<tr>
    <th scope="row">Transfer To</th>
    <td colspan="3">
        <select class="w100p" id="toTransBrnchId" name="toTransBrnchId"  onchange="transToBrnchChange()" ></select>
    </td>
</tr>
<tr>

    <th scope="row">Category</th>
    <td >
            <select class="w100p" id="category" name="category"  onchange="itemCategoryChange();">
                <option value="1346">Merchandise Item</option>
                <option value="1348">Misc Item</option>
                <option value="1347">Uniform</option>
            </select>
    </td>
     <th scope="row">Item Type</th>
    <td>
            <select class="w100p" id="itemType" name="itemType"  >
                <option value="1353">Item Bank</option>
            </select>
   </td>
</tr>

<tr>
   <th scope="row">Item</th>
    <td>
        <select class="w100p" id="purcItems" name="purcItems"  onchange="itemCodeChange();" ></select>
    </td>
    <th scope="row"> Inventory(Qty)</th>

    <td>
           <input type="text" title="" placeholder="" class="w100p disabled"  id="itemQty"  name="itemQty" disabled="disabled" />
    </td>

</tr>

<tr>
<!--    <th scope="row">Condition</th> -->
<!--     <td> -->
<!--            <select class="w100p" id="itemCond" name="itemCond"  > -->
<!--                 <option value="">Choose One</option> -->
<!--                 <option value="N">New</option> -->
<!--                 <option value="R">Replacement</option> -->
<!--             </select> -->
<!--     </td> l -->
    <th scope="row">Transfer Quantity</th>
    <td>
       <input type="text" title="" placeholder="" class="w100p"  id="itemTransQty"  name="itemTransQty"  />
    </td>

    <th></th>
    <td></td>

</tr>



</tbody>
</table><!-- table end -->

</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->
<ul class="right_btns">
    <li><p class="btn_grid"><a href="javascript:void(0);" onclick="javascript:addRow()">Add</a></p></li>
    <li><p class="btn_grid"><a href="javascript:void(0);" onclick="javascript:removeRow()">Delete</a></p></li>
</ul>

   <article class="grid_wrap">
    <!-- grid_wrap start -->
    <div id="grid_wrapPOS"  style="width: 100%; height: 100%; margin: 0 auto;"></div>
   </article>

</section><!-- search_result end -->
<ul class="center_btns">
    <li><p class="btn_blue2 big"><a   href="javascript:void(0);" onclick="javascript:fn_saveGrid()" id="_transconfirm"   >SAVE</a></p></li>
</ul>
</section><!-- pop_body end -->

</div><!-- popup_wrap end -->