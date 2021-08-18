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


var keyValueList = [{"code":"", "value":"Choose One"} ,{"code":"D", "value":"Defect/Damage"}, {"code":"B", "value":"Broken"}, {"code":"OTH", "value":"Others"}];


var columnLayout = [
                    {dataField: "itemCode",headerText :"Item Code"           ,width:  100   ,height:30 , visible:false, editable : false},
                    {dataField: "itemDesc",headerText :"Item Description"     ,width: 280    ,height:30 , visible:true, editable : false},
                    {dataField: "itemInvtQty" ,headerText :"Quantity"                ,width:120   ,height:30 , visible:true, editable : true,dataType : "numeric", formatString : "#,##0"},
                    {dataField: "itemReqQty" ,headerText :"Return Quantity"                ,width:140   ,height:30 , visible:true, editable : true,dataType : "numeric", formatString : "#,##0"},
                    {dataField: "itemType" ,headerText :"itemType"                ,width:120   ,height:30 , visible:false, editable : false},
                    {dataField: "itemPurhOrdNo" ,headerText :"itemPoOrdNo"                ,width:120   ,height:30 , visible:false, editable : false},
                    {dataField: "scnFromLocId" ,headerText :"itemFromBrnchId"                ,width:120   ,height:30 , visible:false, editable : false},
                    {dataField: "itemCtgryId" ,headerText :"itemCategory"                ,width:120   ,height:30 , visible:false, editable : false},
                    {dataField: "atchFileName",headerText :"Attachement"      ,width:180   ,height:30 , visible:true,editable : false,
                        renderer :
                        {
                              type : "IconRenderer",
                              iconWidth : 23, // icon 가로 사이즈, 지정하지 않으면 24로 기본값 적용됨
                              iconHeight : 23,
                              iconPosition : "aisleRight",
                              iconFunction : function(rowIndex, columnIndex, value, item)
                              {
                                return "${pageContext.request.contextPath}/resources/images/common/normal_search.png";
                              } ,// end of iconFunction
                              onclick : function(rowIndex, columnIndex, value, item) {
                            	  deleteAttachUpLoad(rowIndex, columnIndex, value, item);
                              }
                          } // IconRenderer
                       }


                    ,{dataField: "itemRtnReason",headerText :"Reason"  ,width:120    ,height:30 , visible:true ,
                        renderer : {
                            type : "DropDownListRenderer",
                            list : keyValueList, //key-value Object 로 구성된 리스트
                            keyField : "code", // key 에 해당되는 필드명
                            valueField : "value" // value 에 해당되는 필드명
                        }
                    }
                    ,{dataField: "itemRejAttchGrpId",headerText :"Reject AttachementId"      ,width:120   ,height:30 , visible:false}
                    ,{dataField: "physiclFileName",headerText :"Reject physiclFileName"      ,width:120   ,height:30 , visible:false}
                    ,{dataField: "atchFileId",headerText :"atchFileId"      ,width:120   ,height:30 , visible:false}
                    ,{dataField: "fileSubPath",headerText :"fileSubPath"      ,width:120   ,height:30 , visible:false}




 ];

function deleteAttachUpLoad(rowIndex, columnIndex, value, item){

   // if (AUIGrid.getCellValue(myRecivedGridIDPOS, rowIndex, "itemStatus") == "R" ){
           attchIndex = rowIndex;
            $("#uploadfile").click();
   // }
}

//그리드 속성 설정
var gridProsPOS = {
        selectionMode : "singleRow",
        editable : true
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



    CommonCombo.make('fromAddBrnchId', "/sales/pos/selectWhSOBrnchList", '' , '', '',initCallback);

    //Itm List
    var itmType = {itemType : 1346 , posItm : 1};
    CommonCombo.make('purcItems', "/sales/pos/selectPosItmList", itmType , '', ItmOption);


    myGridIDPOS = GridCommon.createAUIGrid("#grid_wrapPOS", columnLayout, gridProsPOS);

});

function initCallback(){


    $('#fromAddBrnchId').val('${branchId}');

}

var attchIndex =0;

$(function() {

         $("#uploadfile").change(function(e){

      //  alert($('input[type=file]')[0].files[0].name); //파일이름
     //       alert($("#m_file")[0].files[0].type); // 파일 타임
     //      alert($("#m_file")[0].files[0].size); // 파일 크기
     //  $('input[type=file]')[0].files[0].name;
     //  $("#imgUpload")[0].files[0].type;
     //  $("#imgUpload")[0].files[0].size;


            var formData = Common.getFormData("fileUploadForm");
            formData.append("param01", $("#param01").val());

            Common.ajaxFile("/sales/posstock/rejectFilleUpload.do", formData, function(result) {
                        console.log(result);

                        $("#uploadfile").val("");
                        AUIGrid.setCellValue(myGridIDPOS, attchIndex, "atchFileName",result.files[0].atchFileName);
                        AUIGrid.setCellValue(myGridIDPOS, attchIndex, "physiclFileName",result.files[0].physiclFileName);
                        AUIGrid.setCellValue(myGridIDPOS, attchIndex, "itemRejAttchGrpId",result.atchFileGrpId);
                        Common.alert(result.message);
                        attchIndex=0;           });

          });
    });



function itemCategoryChange(){
	var val = $("#category").val();
	var itmType = {itemType : val , posItm : 1};
    CommonCombo.make('purcItems', "/sales/pos/selectPosItmList", itmType , '', ItmOption);

}


function itemCodeChange(){
	//$("#poOrdNo").val("");
	selectInventoryQty();
}




function selectInventoryQty(){

      //it is going to get  inventory qty

      $("#itemInvtQty").val(0);


      var param ={ "itemCode" : $("#purcItems").val() , "locId" : $("#fromAddBrnchId").val()  };

        Common.ajax("POST", "/sales/posstock/selectItemInvtQty.do",param, function(result) {


         console.log(result);

         if(result.dataInfo != null){
             $("#itemInvtQty").val(result.dataInfo.itemInvQty);
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

    var item = new Object();
    item.itemCode           = $("#purcItems").val() ,
    item.itemDesc           = $( "#purcItems option:selected" ).text(),
    item.itemReqQty       = $("#itemAddQty").val(),
    item.itemPurhOrdNo   = $("#poOrdNo").val(),
    item.scnFromLocId    = $("#fromAddBrnchId").val(),
    item.itemCtgryId       = $("#category").val(),
    item.itemType          = $("#itemType").val();
    item.itemInvtQty      = $("#itemInvtQty").val();


    if($("#itemInvtQty").val()  <= 0 ) {
        Common.alert("Please Check inventory.");
        return false;
    }
    if($("#purcItems").val() == ""   || $("#fromAddBrnchId").val() =="" || $("#itemAddQty").val() =="") {
        Common.alert("Branch/Item/Inventory  is required.");
        return false;
    }


    if( AUIGrid.isUniqueValue (myGridIDPOS,"itemCode" ,item.itemCode )){
        AUIGrid.addRow(myGridIDPOS, item, "last");

    }else{
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


function transFromBrnchChange(){

    if  (AUIGrid.getRowCount(myGridIDPOS) ==0 )  return ;

    var msg = "Grid will be initialized \n"+" Do you still want to change it?" ;
    Common.confirm(msg, function (){
          AUIGrid.clearGridData(myGridIDPOS);
    }, function(){return;})
}


function fn_saveGrid(){

    Common.ajax("POST", "/sales/posstock/insertRetrunPosStock.do", GridCommon.getEditData(myGridIDPOS), function(result) {
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
<h1>Return Information</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="javascript:void(0);" onclick="javascript:fn_close()">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body" style="min-height: auto;"><!-- pop_body start -->



<aside class="title_line"><!-- title_line start -->
<h2>Return In Information</h2>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id="form_view">
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
    <th scope="row">Branch /Warehouse</th>
    <td colspan="3">
                     <select class="w100p" id="fromAddBrnchId" name="fromAddBrnchId"    onchange="transFromBrnchChange();"  ></select>
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
           <input type="text" title="" placeholder="" class="w100p disabled"  id="itemInvtQty"  name="itemInvtQty" disabled="disabled" />
    </td>

</tr>



</tbody>
</table><!-- table end -->

</form>


  <div style="display:none" >
            <form id="fileUploadForm" method="post" enctype="multipart/form-data" action="">
               <input type="file" title="file add"  id="uploadfile" name="uploadfile"/>
            </form>
        </div>

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
    <li><p class="btn_blue2 big"><a id="_addconfirm" onclick="javascript:fn_saveGrid()"  >Request</a></p></li>
</ul>

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->