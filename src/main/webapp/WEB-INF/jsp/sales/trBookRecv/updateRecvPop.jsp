<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script  type="text/javascript">
var tranGridID;
var tranToGridID;

$(document).ready(function(){
	creatTranGrid();
     
	fn_selectTranListAjax();
});

function creatTranGrid(){

	 var tranColLayout = [ 
           {dataField : "trTrnsitDetId", headerText : "", width : 110  , visible:false },
           {dataField : "trBookId", headerText : "", width : 110  , visible:false },
           {dataField : "trBookNo", headerText : "Book No", width : 90 ,  filter : {showIcon : true}},
           {dataField : "trBookPrefixNo", headerText : "Prefix", width : 70, filter : {showIcon : true} },
           {dataField : "trReciptNoStr", headerText : "From", width : 90,  filter : {showIcon : true} },
           {dataField : "trReciptNoEnd", headerText : "To", width : 90,   filter : {showIcon : true} },
           {dataField : "trBookQty", headerText : "Total <br/>Sheet(s)", width : 90 ,filter : {showIcon : true} },
           {dataField : "code", headerText : "Status", width : 60     }          
           ]; 
      
	 var tranToColLayout = [ 
           {dataField : "trTrnsitDetId", headerText : "", width : 110  , visible:false },
           {dataField : "trBookId", headerText : "", width : 110  , visible:false },
           {dataField : "trBookNo", headerText : "Book No", width : 90    },
           {dataField : "trBookPrefixNo", headerText : "Prefix", width : 70    },
           {dataField : "trReciptNoStr", headerText : "From", width : 90         },
           {dataField : "trReciptNoEnd", headerText : "To", width : 90           },
           {dataField : "trBookQty", headerText : "Total <br/>Sheet(s)", width : 90   },
           {dataField : "code", headerText : "Status", width : 60     }          
           ]; 
      

      var tranOptions = {
                 showStateColumn:false,
                 showRowNumColumn    : false,
                 usePaging : false,
                 editable : false,
                 fixedColumnCount    : 3,
                 selectionMode : "multiRow",
                 headerHeight : 30,
                 softRemoveRowMode:false
           }; 
      
      tranGridID = GridCommon.createAUIGrid("#tranGridID", tranColLayout, "", tranOptions);
      tranToGridID = GridCommon.createAUIGrid("#tranToGridID", tranToColLayout, "", tranOptions);
     
}


var fromItems = new Array();
var idx = 0;

function fn_transitDataMove(){

    var delCnt=0;
    var selectItems = AUIGrid.getSelectedItems(tranGridID);
    
    console.log(selectItems);
       
    
    for (var i in selectItems) {
        //var value = test[i];
        fromItems[idx] = AUIGrid.getItemByRowIndex(tranGridID, selectItems[i].rowIndex-delCnt);

        //AUIGrid.removeRow(tranGridID, selectItems[i].rowIndex);
        AUIGrid.removeRow(tranGridID, selectItems[i].rowIndex-delCnt);
        delCnt++;
        idx++;
    }   
    
    console.log(fromItems);
    
    AUIGrid.setGridData(tranToGridID, fromItems);
    
}

function fn_activeDataMove(){

    var delCnt=0;
    var selectItems = AUIGrid.getSelectedItems(tranToGridID);
    
    for (var i in selectItems) {
        
        var rowIdx = selectItems[i].rowIndex;
                
        AUIGrid.addRow(tranGridID, selectItems[i].item, 'first');   
                
        fromItems.splice(rowIdx-delCnt, 1);
                
        console.log("add Item" + selectItems[i]);   
                
        AUIGrid.removeRow(tranToGridID, rowIdx-delCnt);
        delCnt++;
        idx--;
    }       
    
}

//리스트 조회.
function fn_selectTranListAjax() {
    
   Common.ajax("GET", "/sales/trBookRecv/selectRecvInfo", $("#tranUForm").serialize(), function(result) {
      
	    console.log("성공.");
	    console.log( result);
       
	    $("#hTrnsitStusId").val(result.trnsitStusId);
	    $("#docNo").val(result.trnsitNo);
	    $("#hTrnsitTo").val(result.trnsitTo);
	    $("#hTrnsitFrom").val(result.trnsitFrom);
	    $("#hTrnsitCurier").val(result.trnsitCurier);
	    $("#hTransitStatusID").val(result.transitStatusID);
	    
       
	    $("#upTrnsitNo").html(result.trnsitNo);
	    $("#upTrnsitDt").html(result.trnsitDt);
	    $("#upTrnsitStusName").html(result.trnsitStusName);
	    $("#upTrnsitFrom").html(result.trnsitFrom).append(" - ").append(result.trnsitFromName);
	    $("#upTrnsitTo").html(result.trnsitTo).append(" - ").append(result.trnsitToName);
	    $("#upTrnsitClosDt").html(result.trnsitClosDt);
	    $("#upTrnsitTotBook").html(result.trnsitTotBook);
	    $("#upTrnsitCurier").html(result.trnsitCurier);
	    $("#upTrnsitCurierName").html(result.trnsitCurierName);
	    $("#upPendingCnt").html(result.pendingCnt);
	    $("#upRecvCnt").html(result.recvCnt);
	    $("#upNotRecvCnt").html(result.notRecvCnt);
        $("#upTrnsitToName").html(result.trnsitToName);
	    
	    AUIGrid.setGridData(tranGridID, result.pendingList);
	    AUIGrid.clearGridData(tranToGridID);
	    
	    if($("#saveYn").val() == "Y"){
	    	if($("#transitStatusID").val() == "36"){

	             $("#btnSave").hide();
	            Common.alert("Result Save Successful" +DEFAULT_DELIMITER+ "Transit result successfully saved.<br />This transit was closed." );
	        }else{
	            
	            if(result.pendingCnt == 0 ){

	                $("#btnSave").hide();
	                Common.alert("Result Save Successful" +DEFAULT_DELIMITER+ "Transit result successfully saved.<br />No pending item found but the transit is still under pending status." );
	            }else{
	                Common.alert("Result Save Successful" +DEFAULT_DELIMITER+ "Transit result successfully saved." );
	            }
	        }
	    }

	    });
  }


 function fn_save(){
	
	if(AUIGrid.getRowCount(tranToGridID) == 0){
		Common.alert("Item To Update" +DEFAULT_DELIMITER+ "No item to update transit status.<br />Please add item to transit." );
		return;
	}else{
		
		 $("#saveYn").val("Y");
	     var data = $("#tranUForm").serializeJSON();    
	     var gridData = AUIGrid.getGridData(tranToGridID);
	     data.gridData = gridData;
	     
	     Common.ajax("POST", "/sales/trBookRecv/updateTransit", data, function(result) {
	         
	         console.log("성공.");
	         console.log( result);     

	         fn_selectTranListAjax();


	         $("#saveYn").val("N");
	         fromItems = new Array();
	         idx = 0;
	         
	    },
	    function(jqXHR, textStatus, errorThrown){
	         try {
	             console.log("Fail Status : " + jqXHR.status);
	             console.log("code : "        + jqXHR.responseJSON.code);
	             console.log("message : "     + jqXHR.responseJSON.message);
	             console.log("detailMessage : "  + jqXHR.responseJSON.detailMessage);
	             }
	         catch (e)
	         {
	           console.log(e);
	         }
	         
	         Common.alert("Failed To Save" + DEFAULT_DELIMITER + "Failed to save. Please try again later." );
	         
	     });
	}
} 

</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>TR Book Management - Transit Receive Result Update</h1>
<ul class="right_opt">
	<li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->
<form action="#" method="post" id="tranUForm" name="tranUForm">
    <input type="hidden" id="updTrnsitId" name="trnsitId" value="${trnsitId}"/>
    <input type="hidden" id="hTrnsitStusId" name="trnsitStusId" />
    <input type="hidden" id="docNo" name="docNo" />
    <input type="hidden" id="hTrnsitTo" name="trnsitTo" /><!-- receiver -->
    <input type="hidden" id="hTrnsitFrom" name="trnsitFrom" /> <!-- sender -->
    <input type="hidden" id="hTrnsitCurier" name="trnsitCurier" />
    <input type="hidden" id="hTransitStatusID" name="transitStatusID" />
    <input type="hidden" id="searchType" name="searchType" value ="Pen"/>
    <input type="hidden" id="saveYn" name="saveYn" />


<aside class="title_line"><!-- title_line start -->
<h2>Transit Information</h2>
</aside><!-- title_line end -->

<table class="type1 mt10"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:160px" />
	<col style="width:*" />
	<col style="width:160px" />
	<col style="width:*" />
	<col style="width:120px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Transit No</th>
    <td><span id="upTrnsitNo"></span></td>
    <th scope="row">Transit Date</th>
    <td><span id="upTrnsitDt"></span></td>
    <th scope="row">Transit Status</th>
    <td><span id="upTrnsitStusName"></span></td>
</tr>
<tr>
    <th scope="row">Transit From</th>
    <td><span id="upTrnsitFrom"></span></td>
    <th scope="row">Transit To</th>
    <td><span id="upTrnsitTo"></span></td>
    <th scope="row">Close Date</th>
    <td><span id="upTrnsitClosDt"></span></td>
</tr>
<tr>
    <th scope="row">Total Book Transit</th>
    <td><span id="upTrnsitTotBook"></span></td>
    <th scope="row">Courier</th>
    <td><span id="upTrnsitCurier"></span></td>
    <th scope="row">Creator</th>
    <td><span id="upTrnsitCurierName"></span></td>
</tr>
<tr>
    <th scope="row">Total Pending</th>
    <td><span id="upPendingCnt"></span></td>
    <th scope="row">Total Received</th>
    <td><span id="upRecvCnt"></span></td>
    <th scope="row">Total Not Received</th>
    <td><span id="upNotRecvCnt"></span></td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h2>Transit Result</h2>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:160px" />
	<col style="width:*" />
	<col style="width:160px" />
	<col style="width:*" />
	<col style="width:120px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row">Transit Status</th>
	<td>
		<select class="w100p" id="status" name="status">
			<option value="4">Received</option>
			<option value="50">Not Received</option>
		</select>
	</td>
	<td colspan="4"><p class="btn_blue2 big"><a href="#" onclick="javascript:fn_save();" id="btnSave">Save</a></p></td>
</tr>
</tbody>
</table><!-- table end -->

<section class="transfer_wrap"><!-- transfer_wrap start -->

<div class="tran_list" style="height:260px"><!-- tran_list start -->
	<aside class="title_line"><!-- title_line start -->
	<h3>Book In Transit</h3>
	</aside><!-- title_line end -->
    <article class="grid_wrap"><!-- grid_wrap start -->
        <div id="tranGridID" style="height:230px; margin:0 auto;"></div>
    </article><!-- grid_wrap end -->
</div><!-- tran_list end -->

<ul class="btns">
	<li><a href="#" onclick="javascript:fn_transitDataMove();"><img src="${pageContext.request.contextPath}/resources/images/common/btn_right.gif" alt="right" /></a></li>
	<li class="sec"><a href="#" onclick="javascript:fn_activeDataMove();"><img src="${pageContext.request.contextPath}/resources/images/common/btn_left.gif" alt="left" /></a></li>
</ul>

<div class="tran_list" style="height:260px"><!-- tran_list start -->
	<aside class="title_line"><!-- title_line start -->
	<h3>Active List</h3>
	</aside><!-- title_line end -->
	<article class="grid_wrap"><!-- grid_wrap start -->
        <div id="tranToGridID" style="height:230px; margin:0 auto;"></div>
	</article><!-- grid_wrap end -->
</div><!-- tran_list end -->

</section><!-- transfer_wrap end -->

</form>
<ul class="center_btns">

</ul>

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->