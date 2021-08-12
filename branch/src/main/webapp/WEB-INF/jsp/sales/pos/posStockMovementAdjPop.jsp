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
                    {dataField: "itemCode",headerText :"Item Code"                   ,width:  100   ,height:30 , visible:true, editable : false},
                    {dataField: "itemDesc",headerText :"Item Description"           ,width: 280    ,height:30 , visible:true, editable : false},
                    {dataField: "itemCtgryCode",headerText :"Item Category"      ,width: 180    ,height:30 , visible:false, editable : false},
                    {dataField: "itemToInvtQty",headerText :"Stock In Qty"             ,width:120   ,height:30 , visible:true, editable : false,dataType : "numeric", formatString : "#,##0"},
                    {dataField: "itemAdjQty",headerText :"Adjustment Qty"          ,width:120   ,height:30 , visible:true, editable : true,dataType : "numeric", formatString : "#,##0"},
                    {dataField: "itemVarianceQty",headerText :"Variance Qty"      ,width:120   ,height:30 , visible:true, editable : false ,dataType : "numeric", formatString : "#,##0"},
                    {dataField: "itemStatus",headerText :"itemStatus Qty"      ,width:120   ,height:30 , visible:false, editable : false},

                    {dataField: "itemReason",headerText :"Reason"  ,width:120    ,height:30 , visible:true ,
                        renderer : {
                            type : "DropDownListRenderer",
                            list : keyValueList, //key-value Object 로 구성된 리스트
                            keyField : "code", // key 에 해당되는 필드명
                            valueField : "value" // value 에 해당되는 필드명
                        }
                    }
 ];



//그리드 속성 설정
var gridProsPOS = {
      usePaging : true,
      pageRowCount : 20,
      editable : true,
      showRowCheckColumn : true
};

var myAdjGridIDPOS;

$(document).ready(function () {

	myAdjGridIDPOS = AUIGrid.create("#grid_wrapPOS", columnLayout, gridProsPOS);

	fn_getAdjDataListAjax();

	    AUIGrid.bind(myAdjGridIDPOS, ["cellEditBegin", "cellEditEndBefore", "cellEditEnd", "cellEditCancel"], auiAdjCellEditingHandler);
});



function fn_close(){
    $("#popup_wrap").remove();
}




function auiAdjCellEditingHandler(event) {

    console.log(event)

    if(event.type == "cellEditBegin") {
     //   document.getElementById("editBeginDesc").innerHTML = "에디팅 시작(cellEditBegin) : ( " + event.rowIndex + ", " + event.columnIndex + " ) " + event.headerText + ", value : " + event.value;
    } else if(event.type == "cellEditEnd") {

         if(event.dataField=="itemAdjQty"){
            if(event.value>0){
                var reqQty =event.item.itemInvtQty;
                AUIGrid.setCellValue(myAdjGridIDPOS, event.rowIndex, 5, event.value - reqQty);
                AUIGrid.setCellValue(myAdjGridIDPOS, event.rowIndex, 6,  $("#itemStatus").val());
            }
         }


    //    document.getElementById("editBeginEnd").innerHTML = "에디팅 종료(cellEditEnd) : ( " + event.rowIndex + ", " + event.columnIndex + " ) " + event.headerText + ", value : " + event.value;
    } else if(event.type == "cellEditCancel") {
     //   document.getElementById("editBeginEnd").innerHTML = "에디팅 취소(cellEditCancel) : ( " + event.rowIndex + ", " + event.columnIndex + " ) " + event.headerText + ", value : " + event.value;
    } else if(event.type == "cellEditEndBefore") {
        // 여기서 반환하는 값이 곧 에디팅 완료 값입니다.
        // 개발자가 입력한 값을 변경할 수 있습니다.

                    //AUIGrid.setCellValue(myRecivedGridIDPOS, event.ro wIndex, 5, "9999");

        return event.value; // 원래 값으로 적용 시킴
    }
};




//리스트 조회.
function fn_getAdjDataListAjax  () {

	Common.ajax("GET", "/sales/posstock/selectPosStockMgmtAdjInfo.do?scnNo="+'${scnNo}', null, function(result) {
	 console.log("성공.");
	 console.log("data : " + result);
	 console.log(result);

	 AUIGrid.setGridData(myAdjGridIDPOS, result.dataList);


	 $("#scnAdjNo").val(result.dataInfo.scnNo);
	 $("#moveAdjType").val(result.dataInfo.scnMoveTypeCode);
	 $("#moveAdjStatus").val(result.dataInfo.scnMoveStatCode);
	 $("#fromAdjBrnchDesc").val(result.dataInfo.scnFromLocDesc);
	 $("#toAdjBrnchDesc").val(result.dataInfo.scnToLocDesc);
	 $("#createDate").val(result.dataInfo.scnMoveDate);
	 $("#adjUpDate").val(result.dataInfo.updDate);
	 $("#adjUpBy").val(result.dataInfo.userName);

	});
}



function fn_saveAdjGrid(){

    var checkList = GridCommon.getGridData(myAdjGridIDPOS);


    for(var i = 0 ; i < checkList.all.length ; i++){
        var itemAdjQty  = checkList.all[i].itemAdjQty;

        if(checkList.all[i].itemAdjQty == 0 ||checkList.all[i].itemAdjQty ==null ){
            Common.alert('* List has "0" Adjustment Qty item(s). ');
            return ;
        }
    }


    Common.ajax("POST", "/sales/posstock/updateAdjPosStock.do", GridCommon.getEditData(myAdjGridIDPOS), function(result) {
        Common.alert("<spring:message code='sys.msg.success' htmlEscape='false'/>");
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
        fn_getAdjDataListAjax();
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
<h2>Adjustment Information</h2>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id="form_view">
<!-- <input type="hidden" id="search_costCentr">
<input type="hidden" id="search_costCentrName"> -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:100px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">SCN Number</th>
    <td>
               <input type="text" title="" placeholder="" class="w100p disabled"  id="scnAdjNo"  name="scnAdjNo" disabled="disabled" />
    </td>
    <th scope="row">Movement Type</th>
    <td>
            <input type="text" title="" placeholder="" class="w100p disabled"  id="moveAdjType"  name="moveAdjType" disabled="disabled" />
    </td>
      <th scope="row">Status</th>
    <td>
        <input type="text" title="" placeholder="" class="w100p disabled"  id="moveAdjStatus"  name="moveAdjStatus" disabled="disabled" />
    </td>
</tr>

<tr>
   <th scope="row">Create Date</th>
    <td>
            <input type="text" title="" placeholder="" class="w100p disabled"  id="createDate"  name="createDate" disabled="disabled" />
    </td>

    <th scope="row">Update Date</th>
    <td>
         <input type="text" title="" placeholder="" class="w100p disabled"  id="adjUpDate"  name="adjUpDate" disabled="disabled" />
    </td>
    <th scope="row">Updated by</th>
    <td><input type="text" title="" placeholder="" class="w100p disabled"  id="adjUpBy"  name="adjUpBy" disabled="disabled" /> </td>
</tr>

<tr>
   <th scope="row">Transfer From</th>
    <td>
        <input type="text" title="" placeholder="" class="w100p disabled" id="fromAdjBrnchDesc" name="fromAdjBrnchDesc"  disabled="disabled"  />
    </td>
    <th scope="row">Transfer To</th>

    <td>
     <input type="text" title="" placeholder="" class="w100p disabled" id="toAdjBrnchDesc" name="toAdjBrnchDesc"  disabled="disabled"  />    </td>
     <th scope="row"></th>
    <td>

     </td>
</tr>



</tbody>
</table><!-- table end -->

</form>
</section><!-- search_table end -->




<section class="search_result"><!-- search_result start -->


   <article class="grid_wrap">
    <!-- grid_wrap start -->
    <div id="grid_wrapPOS"
     style="width: 100%; height: 100%; margin: 0 auto;"></div>
   </article>

</section><!-- search_result end -->

<ul class="center_btns">
    <li><p class="btn_blue2 big"><a id="_adjconfirm" onclick="javascript:fn_saveAdjGrid()" >SAVE</a></p></li>
</ul>
</section><!-- pop_body end -->

</div><!-- popup_wrap end -->