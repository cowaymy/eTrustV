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
var keyValueList = [{"code":"", "value":"Choose One"} ,{"code":"SUR", "value":"Surplus"}, {"code":"SHO", "value":"Shortage"}];

var keyStateValueList = [{"code":"", "value":"Choose One"} ,{"code":"C", "value":"Completed"}, {"code":"R", "value":"Reject"}];

var columnLayout = [
                    {dataField: "stkCode",headerText :"Item Code"           ,width:  100   ,height:30 , visible:true, editable : false},
                    {dataField: "itemCode",headerText :"Item Code"                   ,width:  100   ,height:30 , visible:false, editable : false},
                    {dataField: "itemDesc",headerText :"Item Description"           ,width: 280    ,height:30 , visible:true, editable : false},
                    {dataField: "itemCtgryCode",headerText :"Item Category"      ,width: 180    ,height:30 , visible:false, editable : false},
                    {dataField: "itemReqQty",headerText :"Transfer Quantity"             ,width:120   ,height:30 , visible:true, editable : false,dataType : "numeric", formatString : "#,##0"},
                    {dataField: "itemRecvQty",headerText :"Received Qty"          ,width:120   ,height:30 , visible:false, editable : true,dataType : "numeric", formatString : "#,##0"},
                    {dataField: "itemVarianceQty",headerText :"Variance Qty"      ,width:120   ,height:30 , visible:false, editable : false,dataType : "numeric", formatString : "#,##0"},
                    {dataField: "scnMoveType",headerText :"scnMoveType"      ,width:120   ,height:30 , visible:false, editable : false},

                    {dataField: "itemStatus",headerText :"Item Status"  ,width:120    ,height:30 , visible:true ,
                        renderer : {
                            type : "DropDownListRenderer",
                            list : keyStateValueList, //key-value Object 로 구성된 리스트
                            keyField : "code", // key 에 해당되는 필드명
                            valueField : "value" // value 에 해당되는 필드명
                        }
                    }
                   ,{dataField: "itemRejRemark",headerText :"Reject Reason"      ,width:220   ,height:30 , visible:true, editable : true}
                   ,{dataField: "atchFileName",headerText :"Reject Attachement"      ,width:180   ,height:30 , visible:true,editable : false,
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
                    ,{dataField: "itemRejAttchGrpId",headerText :"Reject AttachementId"      ,width:120   ,height:30 , visible:false}
                    ,{dataField: "physiclFileName",headerText :"Reject physiclFileName"      ,width:120   ,height:30 , visible:false}
                    ,{dataField: "atchFileId",headerText :"atchFileId"      ,width:120   ,height:30 , visible:false}
                    ,{dataField: "fileSubPath",headerText :"fileSubPath"      ,width:120   ,height:30 , visible:false}

 ];



//그리드 속성 설정
var gridProsPOS = {
        usePaging : true,
        pageRowCount : 20,
        editable : true,
        showRowCheckColumn : true
};

var myRecivedGridIDPOS;

$(document).ready(function () {


    myRecivedGridIDPOS = AUIGrid.create("#grid_wrapPOS", columnLayout, gridProsPOS);

    fn_getRecievedDataListAjax();

    AUIGrid.bind(myRecivedGridIDPOS, ["cellEditBegin", "cellEditEndBefore", "cellEditEnd", "cellEditCancel"], auiRecivedCellEditingHandler);


    // cellClick event.
    AUIGrid.bind(myRecivedGridIDPOS, "cellDoubleClick", function( event ) {
        console.log("rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex + " clicked");
        console.log(event);

        if(event.dataField =="atchFileName" ){
           if(event.value !=""){
                   var fileSubPath = event.item.fileSubPath;
                   var fileName =  event.item.atchFileName;
                   var orignlFileNm =event.item.physiclFileName;

                   window.open("<c:url value='/file/fileDown.do?fileId="+event.item.atchFileId+ "'/>");
        	}
        }
    });

});



function fn_close(){
    $("#popup_wrap").remove();
}






function auiRecivedCellEditingHandler(event) {

    if(event.type == "cellEditBegin") {
     //   document.getElementById("editBeginDesc").innerHTML = "에디팅 시작(cellEditBegin) : ( " + event.rowIndex + ", " + event.columnIndex + " ) " + event.headerText + ", value : " + event.value;
    } else if(event.type == "cellEditEnd") {

    	 if(event.dataField=="itemRecvQty"){

    		if(event.value>0){
                var reqQty =event.item.itemReqQty;
                AUIGrid.setCellValue(myRecivedGridIDPOS, event.rowIndex, 5, reqQty-event.value );
                AUIGrid.setCellValue(myRecivedGridIDPOS, event.rowIndex, 6,  $("#itemStatus").val());
                AUIGrid.setCellValue(myRecivedGridIDPOS, event.rowIndex, 7,  $("#moveReceivedTypeId").val());
            }
         }

    	 if(event.dataField=="itemStatus"){
    		 if(event.value !="C"){
    	            AUIGrid.setCellValue(myRecivedGridIDPOS, event.rowIndex, "itemRecvQty",0);
             }
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

//리스트 조회.
function fn_getRecievedDataListAjax  () {

Common.ajax("GET", "/sales/posstock/selectPosStockMgmtReceivedInfo.do?scnNo="+'${scnNo}', null, function(result) {
   console.log("성공.");
   console.log("data : " + result);
   console.log(result);

   AUIGrid.setGridData(myRecivedGridIDPOS, result.dataList);


   $("#scnReceivedNo").val(result.dataInfo.scnNo);
   $("#moveReceivedType").val(result.dataInfo.scnMoveTypeCode);
   $("#moveReceivedTypeId").val(result.dataInfo.scnMoveType);
   $("#moveReceivedStatus").val(result.dataInfo.scnMoveStatCode);
   $("#fromReceivedBrnchDesc").val(result.dataInfo.scnFromLocDesc);
   $("#toReceivedBrnchDesc").val(result.dataInfo.scnToLocDesc);
   $("#createDate").val(result.dataInfo.scnMoveDate);
   $("#totalItemCount").val(result.dataInfo.totalcnt);

   $("#ctotalItemCount").val(result.dataInfo.ctotalcnt);
   $("#rtotalItemCount").val(result.dataInfo.rtotalcnt);
});
}





function fn_saveRecivedGrid(){

	var checkList = GridCommon.getGridData(myRecivedGridIDPOS);

    console.log(checkList);

    if ($("#itemStatus").val() !="R"){
    	for(var i = 0 ; i < checkList.all.length ; i++){
            var itemReqQty  = checkList.all[i].itemRecvQty;

            if(checkList.all[i].itemStatus == "" ||checkList.all[i].itemStatus ==null ){
                Common.alert('* List status has "" Recevied  item(s). ');
                return ;
            }
        }
    }

    var prams ={data:GridCommon.getEditData(myRecivedGridIDPOS) , itemStatus : $("#itemStatus").val() , scnNo:$("#scnReceivedNo").val()};
    Common.ajax("POST", "/sales/posstock/updateRecivedPosStock.do", prams, function(result) {
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



function itemStatusChange(){

	var checkedItems = AUIGrid.getCheckedRowItems(myRecivedGridIDPOS);

    if(checkedItems.length <= 0) {
        return;
    }

    var str = "";
    var rowItem;
    for(var i=0, len = checkedItems.length; i<len; i++) {
        rowItem = checkedItems[i];
        AUIGrid.setCellValue(myRecivedGridIDPOS, rowItem.rowIndex, "itemStatus",  $("#itemStatus").val());

        if($("#itemStatus").val() =="C"){
            AUIGrid.setCellValue(myRecivedGridIDPOS, rowItem.rowIndex, "itemRecvQty",rowItem.item.itemReqQty);
        }else{
            AUIGrid.setCellValue(myRecivedGridIDPOS, rowItem.rowIndex, "itemRecvQty",0);
        }
    }

}


function rejectAttachUpLoad(rowIndex, columnIndex, value, item){

	if (AUIGrid.getCellValue(myRecivedGridIDPOS, rowIndex, "itemStatus") == "R" ){
		   attchIndex = rowIndex;
		    $("#uploadfile").click();
	}
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
	                    AUIGrid.setCellValue(myRecivedGridIDPOS, attchIndex, "atchFileName",result.files[0].atchFileName);
	                    AUIGrid.setCellValue(myRecivedGridIDPOS, attchIndex, "physiclFileName",result.files[0].physiclFileName);
	                    AUIGrid.setCellValue(myRecivedGridIDPOS, attchIndex, "itemRejAttchGrpId",result.atchFileGrpId);
                        Common.alert(result.message);
                        attchIndex=0;	        });

	      });
	});

</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Stock Receive</h1>
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
               <input type="text" title="" placeholder="" class="w100p disabled"  id="scnReceivedNo"  name="scnReceivedNo" disabled="disabled" />
    </td>
    <th scope="row">Movement Type</th>
    <td>
            <input type="text" title="" placeholder="" class="w100p disabled"  id="moveReceivedType"  name="moveReceivedType" disabled="disabled" />
             <input type="hidden" title="" placeholder="" class="w100p disabled"  id="moveReceivedTypeId"  name="moveReceivedTypeId" disabled="disabled" />

    </td>
      <th scope="row">Status</th>
    <td>
        <input type="text" title="" placeholder="" class="w100p disabled"  id="moveReceivedStatus"  name="moveReceivedStatus" disabled="disabled" />
    </td>
</tr>
<tr>
   <th scope="row">Transfer From</th>
    <td>
    <input type="text" title="" placeholder="" class="w100p disabled" id="fromReceivedBrnchDesc" name="fromReceivedBrnchDesc"  disabled="disabled"  />

    </td>
    <th scope="row">Transfer To</th>

    <td>
        <input type="text" title="" placeholder="" class="w100p disabled"  id="toReceivedBrnchDesc"  name="toReceivedBrnchDesc"  disabled="disabled" / >
    </td>
     <th scope="row">Create Date</th>
    <td>
            <input type="text" title="" placeholder="" class="w100p disabled"  id="createDate"  name="createDate" disabled="disabled" />
     </td>
</tr>


<tr>

    <th scope="row">Total Item</th>
    <td><input type="text" title="" placeholder="" class="w100p disabled"  id="totalItemCount"  name="totalItemCount" disabled="disabled" /> </td>

    <th scope="row">Total Completed</th>
    <td><input type="text" title="" placeholder="" class="w100p disabled"  id="ctotalItemCount"  name="ctotalItemCount" disabled="disabled" /> </td>


    <th scope="row">Total Reject</th>
    <td><input type="text" title="" placeholder="" class="w100p disabled"  id="rtotalItemCount"  name="rtotalItemCount" disabled="disabled" /> </td>


    </td>

</tr>

</tbody>
</table><!-- table end -->

</form>
</section><!-- search_table end -->



<aside class="title_line"><!-- title_line start -->
<h2>Result</h2>
</aside><!-- title_line end -->

<section class="search_result"><!-- search_result start -->


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
   <th scope="row">Item Status</th>
    <td>


             <select class="w100p" id="itemStatus" name="itemStatus"  onchange="itemStatusChange()" >
                <option value="">Choose One</option>
                <option value="C">Completed</option>
                <option value="R">Reject</option>
            </select>
    </td>
      <th scope="row"></th>
    <td>
        <div style="display: none" >
	        <form id="fileUploadForm" method="post" enctype="multipart/form-data" action="">
	           <input type="file" title="file add"  id="uploadfile" name="uploadfile"/>
	        </form>
        </div>

    </td>
</tr>

</tbody>
</table><!-- table end -->
</section>



<section class="search_result"><!-- search_result start -->


   <article class="grid_wrap">
    <!-- grid_wrap start -->
    <div id="grid_wrapPOS"
     style="width: 100%; height: 100%; margin: 0 auto;"></div>
   </article>

</section><!-- search_result end -->

<ul class="center_btns">
    <li><p class="btn_blue2 big"><a id="_receivedconfirm"  onclick="javascript:fn_saveRecivedGrid()" >SAVE</a></p></li>
</ul>
</section><!-- pop_body end -->

</div><!-- popup_wrap end -->