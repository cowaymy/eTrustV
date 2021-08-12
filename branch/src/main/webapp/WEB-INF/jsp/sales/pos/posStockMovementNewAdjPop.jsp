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
var keyValueList = [{"code":"", "value":"Choose One"} ,{"code":"SUR", "value":"Surplus"}, {"code":"SHO", "value":"Shortage"}, {"code":"DEF", "value":"Defect/Damage"}, {"code":"OTH", "value":"Others"}];
var columnLayout = [
                    {dataField: "itemCode",headerText :"Item Code"           ,width:  100   ,height:30 , visible:true, editable : false},
                    {dataField: "itemDesc",headerText :"Item Description"     ,width: 280    ,height:30 , visible:true, editable : false},
                    {dataField: "itemInvtQty" ,headerText :"Stock In"                ,width:120   ,height:30 , visible:true, editable : false,dataType : "numeric", formatString : "#,##0"},
                    {dataField: "itemAdjQty" ,headerText :"Adjustment"                ,width:120   ,height:30 , visible:true, editable : true,dataType : "numeric", formatString : "#,##0"},
                    {dataField: "itemVariQty" ,headerText :"Variance"                ,width:120   ,height:30 , visible:false, editable : false},
                    {dataField: "itemType" ,headerText :"itemType"                ,width:120   ,height:30 , visible:false, editable : false},
                    {dataField: "scnFromLocId" ,headerText :"itemFromBrnchId"                ,width:120   ,height:30 , visible:false, editable : false},
                    {dataField: "itemCtgryId" ,headerText :"itemCategory"                ,width:120   ,height:30 , visible:false, editable : false},
                    {dataField: "itemReason",headerText :"Reason"  ,width:120    ,height:30 , visible:true ,

                    	editRenderer : {
                            type : "ComboBoxRenderer",
                            list : keyValueList, //key-value Object 로 구성된 리스트
                            keyField : "code", // key 에 해당되는 필드명
                            valueField : "value" // value 에 해당되는 필드명
                        }


                    }


 ];


//그리드 속성 설정
var gridProsPOS = {
        selectionMode : "singleRow",
        editable : true
};

var myNewAjGridIDPOS;



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



    CommonCombo.make('fromNewAddBrnchId', "/sales/pos/selectWhSOBrnchList", '' , '', '');


    //Itm List
    var itmType = {itemType : 1346 , posItm : 1};
    CommonCombo.make('purcItems', "/sales/pos/selectPosFlexiItmList", itmType , '', ItmOption);


    myNewAjGridIDPOS = GridCommon.createAUIGrid("#grid_wrapPOS", columnLayout, gridProsPOS);

    AUIGrid.bind(myNewAjGridIDPOS, ["cellEditEnd", "cellEditCancel"], auiNewAdjCellEditingHandler);


});




function itemCategoryChange(){
	var val = $("#category").val();
	var itmType = {itemType : val , posItm : 1};
    CommonCombo.make('purcItems', "/sales/pos/selectPosFlexiItmList", itmType , '', ItmOption);

}


function itemCodeChange(){
	$("#itemInvtQty").val("");
	selectInventoryQty();
}




function newAdjFromBrnchChange(){

    if  (AUIGrid.getRowCount(myNewAjGridIDPOS) ==0 )  return ;

    var msg = "Grid will be initialized \n"+" Do you still want to change it?" ;
    Common.confirm(msg, function (){
          AUIGrid.clearGridData(myNewAjGridIDPOS);
    }, function(){return;})
}


function selectInventoryQty(){

      var param ={ "itemCode" : $("#purcItems").val() , "locId" : $("#fromNewAddBrnchId").val()  };

        Common.ajax("POST", "/sales/posstock/selectItemInvtQty.do",param, function(result) {


         console.log(result);

         if(result.dataInfo != null){
             $("#itemInvtQty").val(result.dataInfo.itemInvQty);
         }else{
             $("#itemInvtQty").val(0);
         }

        },  function(jqXHR, textStatus, errorThrown) {
            try {s
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



function addRow() {


    if($("#purcItems").val() == ""
        || $("#fromNewAddBrnchId").val() =="") {
      Common.alert("Transfer to branch/Item/ is required.");
      return ;
  }

    var item = new Object();
    item.itemCode           = $("#purcItems").val() ,
    item.itemDesc           = $( "#purcItems option:selected" ).text(),
    item.itemInvtQty       = $("#itemInvtQty").val(),
   // item.itemPurhOrdNo   = $("#poOrdNo").val(),
    item.scnFromLocId    = $("#fromNewAddBrnchId").val(),
    item.itemCtgryId       = $("#category").val(),
    item.itemType          = $("#itemType").val();

    /*
    if($("#purcItems").val() == ""
    	  || $("#fromNewAddBrnchId").val() =="" || $("#itemInvtQty").val() =="") {
        Common.alert("Branch/Item/Inventory  is required.");
        return false;
    }
  */

    if( AUIGrid.isUniqueValue (myNewAjGridIDPOS,"itemCode" ,item.itemCode )){
        AUIGrid.addRow(myNewAjGridIDPOS, item, "last");

    }else{
        Common.alert("<b>"+ item.itemDesc +"  is existing. </br>");
        return ;
    }

}



function auiNewAdjCellEditingHandler(event) {

    console.log(event)

    if(event.type == "cellEditBegin") {
     //   document.getElementById("editBeginDesc").innerHTML = "에디팅 시작(cellEditBegin) : ( " + event.rowIndex + ", " + event.columnIndex + " ) " + event.headerText + ", value : " + event.value;
    } else if(event.type == "cellEditEnd") {

         if(event.dataField=="itemAdjQty"){

            if(event.value>0){
                var reqQty =event.item.itemInvtQty;
                AUIGrid.setCellValue(myNewAjGridIDPOS, event.rowIndex, 4, event.value -reqQty );
                //AUIGrid.setCellValue(myNewAjGridIDPOS, event.rowIndex, 8,""  );
                //AUIGrid.setCellValue(myNewAjGridIDPOS, event.rowIndex, 6, "A");
                //AUIGrid.setCellValue(myNewAjGridIDPOS, event.rowIndex, 7, "A");
            }
         }

         if(event.dataField=="itemReason"){

         }


    //    document.getElementById("editBeginEnd").innerHTML = "에디팅 종료(cellEditEnd) : ( " + event.rowIndex + ", " + event.columnIndex + " ) " + event.headerText + ", value : " + event.value;
    } else if(event.type == "cellEditCancel") {
     //   document.getElementById("editBeginEnd").innerHTML = "에디팅 취소(cellEditCancel) : ( " + event.rowIndex + ", " + event.columnIndex + " ) " + event.headerText + ", value : " + event.value;
    } else if(event.type == "cellEditEndBefore") {
        // 여기서 반환하는 값이 곧 에디팅 완료 값입니다.
        // 개발자가 입력한 값을 변경할 수 있습니다.

                    //AUIGrid.setCellValue(myRecivedGridIDPOS, event.rowIndex, 5, "9999");
        return event.value; // 원래 값으로 적용 시킴
    }
};


function removeRow(){
    AUIGrid.removeRow(myNewAjGridIDPOS, "selectedIndex");
    AUIGrid.removeSoftRows(myNewAjGridIDPOS);
}


function auiRemoveRowHandler(){}


function fn_close(){
    $("#popup_wrap").remove();
}



function fn_saveGrid(){


	var checkList = GridCommon.getGridData(myNewAjGridIDPOS);

    console.log(checkList);

   // if ($("#itemStatus").val() !="R"){
      for(var i = 0 ; i < checkList.all.length ; i++){
          var itemReqQty  = checkList.all[i].itemReason;

          if(checkList.all[i].itemReason == "" || checkList.all[i].itemReason ==null ){
              Common.alert('* There is an empty item in the list for a reason');
              return ;
          }
      }
   // }



    Common.ajax("POST", "/sales/posstock/insertNewAdjPosStock.do", GridCommon.getEditData(myNewAjGridIDPOS), function(result) {
        //resetUpdatedItems(); // 초기화
        console.log( result);
        Common.alert('SCN Number is : '+result.data);

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



       // fn_getSampleListAjax();
    });
}


</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Adjustment</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="javascript:void(0);" onclick="javascript:fn_close()">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body" style="min-height: auto;"><!-- pop_body start -->



<aside class="title_line"><!-- title_line start -->
<h2>New Adjustment Information</h2>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id="form_view">
<!-- <input type="hidden" id="search_costCentr">-->
<input type="hidden" id="tfocus">

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
    <th scope="row">Branch /Warehouse</th>
    <td colspan="3">
                     <select class="w100p" id="fromNewAddBrnchId" name="fromNewAddBrnchId"  onchange="newAdjFromBrnchChange()"  ></select>
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
           <input type="text" title="" placeholder="" class="w100p disabled"  id="itemInvtQty"  name="itemInvtQty"  disabled="disabled"  />
    </td>

</tr>

<tr>
   <th scope="row"></th>
    <td>

    </td>
    <th scope="row"></th>

    <td> </td>

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
    <li><p class="btn_blue2 big"><a id="_addconfirm" onclick="javascript:fn_saveGrid()"  >SAVE</a></p></li>
</ul>

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->