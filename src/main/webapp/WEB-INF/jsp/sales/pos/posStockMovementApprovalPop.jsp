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

var approvalResult = [ {"codeId": "C","codeName": "APPROVED"} ,{"codeId": "R","codeName": "REJECTED"}  ];

var keyValueList = [{"code":"", "value":"Choose One"} ,{"code":"SUR", "value":"Surplus"}, {"code":"SHO", "value":"Shortage"}];
var keyStateValueList = [{"code":"", "value":"Choose One"} ,{"code":"C", "value":"Completed"}, {"code":"R", "value":"Reject"}];


var columnLayout = [
                    {dataField: "stkCode",headerText :"Item Code"           ,width:  100   ,height:30 , visible:true, editable : false},
                    {dataField: "itemCode",headerText :"Item Code"                   ,width:  100   ,height:30 , visible:false, editable : false},
                    {dataField: "itemDesc",headerText :"Item Description"           ,width: 280    ,height:30 , visible:true, editable : false},
                    {dataField: "itemCtgryCode",headerText :"Item Category"      ,width: 180    ,height:30 , visible:false, editable : false},
                    {dataField: "itemRtnQty",headerText :"Return Quantity"             ,width:120   ,height:30 , visible:true, editable : false,dataType : "numeric", formatString : "#,##0"},
                    {dataField: "itemRtnReason",headerText :"Reason"          ,width:120   ,height:30 , visible:true, editable : true},
                    {dataField: "itemRejRemark",headerText :"Retrun Remark"      ,width:220   ,height:30 , visible:true, editable : true},
                    {dataField: "scnMoveType",headerText :"scnMoveType"      ,width:120   ,height:30 , visible:false, editable : false},
                    {dataField: "itemStatus",headerText :"Result"  ,width:120    ,height:30 , visible:true ,
                        renderer : {
                            type : "DropDownListRenderer",
                            list : approvalResult, //key-value Object 로 구성된 리스트
                            keyField : "codeId", // key 에 해당되는 필드명
                            valueField : "codeName" // value 에 해당되는 필드명
                        }
                    },
                    {dataField: "atchFileId",headerText :"Attachement"      ,width:180   ,height:30 , visible:false,editable : false,
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
                                rejectAttachUpLoad(rowIndex, columnIndex, value, item);
                           }
                       } // IconRenderer
                    }
 ];



//그리드 속성 설정
var gridProsPOS = {
        usePaging : true,
        pageRowCount : 20,
        editable : true,
        showRowCheckColumn : true
};

var myRetrunGridIDPOS;



$(document).ready(function () {


	    doDefCombo(approvalResult, '' ,'itemStatus', 'S', '');


	    myRetrunGridIDPOS = AUIGrid.create("#grid_wrapPOS", columnLayout, gridProsPOS);


	    fn_getApprovalDataListAjax();

	    // cellClick event.
        AUIGrid.bind(myRetrunGridIDPOS, "cellClick", function( event ) {
        	fn_setRowInfo( event.item);
        });

        AUIGrid.bind(myRetrunGridIDPOS, ["cellEditBegin", "cellEditEndBefore", "cellEditEnd", "cellEditCancel"], auiRecivedCellEditingHandler);


});





//리스트 조회.
function fn_getApprovalDataListAjax  () {

  Common.ajax("GET", "/sales/posstock/selectPosStockMgmtViewInfo.do?scnNo="+'${scnNo}', null, function(result) {
     console.log("성공.");
     console.log("data : " + result);
     console.log(result);

     AUIGrid.setGridData(myRetrunGridIDPOS, result.dataList);



     $("#rtnScnNo").val(result.dataInfo.scnNo);
     $("#rtnScnMoveType").val(result.dataInfo.scnMoveTypeCode);
     $("#rtnScnMoveStatCode").val(result.dataInfo.scnMoveStatCode);
     $("#viewScnFromLocDesc").val(result.dataInfo.scnFromLocDesc);

 });
}



function fn_setRowInfo(obj){

	//console.log(obj);
    //$("#viewScnFromLocDesc").val(result.dataInfo.scnFromLocDesc);
    $("#itemCtgryDesc").val(obj.itemCtgryDesc);
    $("#itemDesc").val(obj.itemDesc);
    $("#itemRtnReason").val(obj.itemRtnReason);
    $("#itemCode").val(obj.itemCode);
    $("#itemRtnQty").val(obj.itemRtnQty);



    if(obj.itemRejAttchGrpId  !="" && obj.itemRejAttchGrpId !=undefined ){
        $("#itemRejAttchGrpId").val(obj.atchFileId);
         $("#itemAttachmentBt").attr("style", "display:inline");
    }

}

function fn_close(){
    $("#popup_wrap").remove();
}


function fn_saveRtnApproval(){

	var checkList = GridCommon.getGridData(myRetrunGridIDPOS);

    console.log(checkList);

        for(var i = 0 ; i < checkList.all.length ; i++){
            var itemStatus  = checkList.all[i].itemStatus;

            if(checkList.all[i].itemStatus == "" ||checkList.all[i].itemStatus ==null ){
                Common.alert('* List status has "" Result  item(s). ');
                return ;
            }
        }


        var prams ={data:GridCommon.getEditData(myRetrunGridIDPOS) , scnNo:$("#rtnScnNo").val()};


         Common.ajax("POST", "/sales/posstock/updateApprovalPosStock.do", prams, function(result) {
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
            fn_getRecievedDataListAjax();
        });


}

function fn_viewAtachPop(){
	window.open("<c:url value='/file/fileDown.do?fileId="+  $("#itemRejAttchGrpId").val()+ "'/>");

}




function auiRecivedCellEditingHandler(event) {

    if(event.type == "cellEditBegin") {
     //   document.getElementById("editBeginDesc").innerHTML = "에디팅 시작(cellEditBegin) : ( " + event.rowIndex + ", " + event.columnIndex + " ) " + event.headerText + ", value : " + event.value;
    } else if(event.type == "cellEditEnd") {

    	if(event.dataField=="itemStatus"){

    		console.log(event)
    		console.log("===>"+event.value)
    	    $("#itemStatus").val(event.value);
    	}
    	if(event.dataField=="itemRejRemark" ){
    	    $("#itemRejRemark").val(event.value);
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


function fn_setItemStatus(){



	 var rows = AUIGrid.getRowIndexesByValue(myRetrunGridIDPOS, "itemCode", $("#itemCode").val());

	 console.log(rows);

     AUIGrid.setCellValue(myRetrunGridIDPOS, rows,"itemStatus",$("#itemStatus").val() );

}


function fn_setItemRtnRemark(){

    var rows = AUIGrid.getRowIndexesByValue(myRetrunGridIDPOS, "itemCode", $("#itemCode").val());

    console.log(rows);

    AUIGrid.setCellValue(myRetrunGridIDPOS, rows,"itemRejRemark",$("#itemRejRemark").val() );
}
</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Stock Return-Approval</h1>
<ul class="right_opt">
    <li><p class="btn_blue2 big"><a id="_rtnconfirm" onclick="javascript:fn_saveRtnApproval()" >Save</a></p></li>

    <li><p class="btn_blue2"><a href="javascript:void(0);" onclick="javascript:fn_close()">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body" style="min-height: auto;"><!-- pop_body start -->


<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id="form_view">
<!-- <input type="hidden" id="search_costCentr">
<input type="hidden" id="search_costCentrName"> -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:200px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
</colgroup>
<tbody>


<tr>
    <th scope="row">SCN Number</th>
    <td>
               <input type="text" title="" placeholder="" class="w100p disabled"  id="rtnScnNo"  name="rtnScnNo" disabled="disabled" />
    </td>
    <th scope="row">Movement Type</th>
    <td>
             <input type="text" title="" placeholder="" class="w100p disabled"  id="rtnScnMoveType"  name="rtnScnMoveType" disabled="disabled" />
    </td>
      <th scope="row">Status</th>
    <td>
        <input type="text" title="" placeholder="" class="w100p disabled"  id="rtnScnMoveStatCode"  name="rtnScnMoveStatCode" disabled="disabled" />
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


<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id="form_view">
<!-- <input type="hidden" id="search_costCentr">
<input type="hidden" id="search_costCentrName"> -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:200px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
</colgroup>
<tbody>


<tr>
    <th scope="row">Branch/Warehouse</th>
    <td colspan="3">
            <input type="text" title="" placeholder="" class="w100p disabled"  id="viewScnFromLocDesc"  name="viewScnFromLocDesc" disabled="disabled" />
    </td>

</tr>

<tr>
    <th scope="row">Category</th>
    <td>
               <input type="text" title="" placeholder="" class="w100p disabled"  id="itemCtgryDesc"  name="itemCtgryDesc" disabled="disabled" />
    </td>
    <th scope="row">Item Type</th>
    <td>
            <input type="text" title="" placeholder="" class="w100p disabled"  id="itemType"  name="itemType" disabled="disabled" value="Item Bank"/>
    </td>
</tr>


<tr>
    <th scope="row">Item</th>
    <td>
               <input type="text" title="" placeholder="" class="w100p disabled"  id="itemDesc"  name="itemDesc" disabled="disabled"  />
               <input type="hidden" title="" placeholder="" class="w100p disabled"  id="itemCode"  name="itemCode" disabled="disabled"  />

    </td>
    <th scope="row">Return Quantity</th>
    <td>
            <input type="text" title="" placeholder="" class="w100p disabled"  id="itemRtnQty"  name="itemRtnQty" disabled="disabled" />
    </td>
</tr>

<tr>
    <th scope="row">Reason</th>
    <td colspan="3">
            <input type="text" title="" placeholder="" class="w100p disabled"  id="itemRtnReason"  name="itemRtnReason" disabled="disabled"  />
    </td>
</tr>

<tr>
    <th scope="row">Attachment</th>
    <td colspan="3">

        <ul class="right_btns">
            <input type="hidden" title="" placeholder="" class="w100p disabled"  id="itemRejAttchGrpId"  name="itemRejAttchGrpId" disabled="disabled" />
            <li><p class="btn_grid"  id="itemAttachmentBt"  style="display:none"><a id="itemAttachment" onclick="fn_viewAtachPop();" >View</a></p></li>
        </ul>

    </td>

</tr>

<tr>
    <th scope="row">Result</th>
    <td colspan="3">
         <select class="w100p" id="itemStatus" name="itemStatus" onchange="fn_setItemStatus();"></select>
     </td>

</tr>

<tr>
    <th scope="row">Remark</th>
    <td colspan="3">
         <textarea id="itemRejRemark" name="itemRejRemark"  cols="20" rows="5" placeholder="" onchange="fn_setItemRtnRemark();"></textarea>

    </td>
</tr>

</tbody>
</table><!-- table end -->

</form>
</section><!-- search_table end -->





</section><!-- pop_body end -->

</div><!-- popup_wrap end -->