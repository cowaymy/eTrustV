<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script  type="text/javascript">
var reqBatchGrid;

$(document).ready(function(){  
	creatReqBatchGrid();
	
	$("#btnClear").on("click", function(){
		$("#reqBahchForm")[0].reset();
	});
			
    CommonCombo.make("reqBranch", "/sales/trBook/selectBranch", "", "${reqBranch}", {
        id: "brnchId",
        name: "name"
    });

});

//Multy Select
$('.multy_select').change(function() {
  //console.log($(this).val());
      })
      .multipleSelect({
      width: '100%'
  });


function creatReqBatchGrid(){

    var colLayout = [ 
          {dataField : "trBookBkReqId", headerText : "", width : 140  , visible:false   },
          {dataField : "trBookBkReqNo", headerText : "<spring:message code="sal.title.batchNo" />", width : 120      },
          {dataField : "code1", headerText : "<spring:message code="sal.title.status" />", width : 80       },
          {dataField : "code", headerText : "<spring:message code="sal.title.branch" />", width : 120        },
          {dataField : "trBookBkReqQty", headerText : "<spring:message code="sal.title.quantity" />", width : 80        },
          {dataField : "trBookBkReqPgePerBook", headerText : "<spring:message code="sal.title.pagePerBook" />", width : 120      },
          {dataField : "trBookBkReqStartReciptNo", headerText : "<spring:message code="sal.title.startTr" />", width : 110     },
          {dataField : "trBookBkReqEndReciptNo", headerText : "<spring:message code="sal.title.endTr" />", width : 110       },
          {dataField : "crtUser", headerText : "<spring:message code="sal.title.creator" />", width : 110       } ,            
          {dataField : "trBookBkReqCrtDt", headerText : "<spring:message code="sal.title.crtDate" />", width : 110       }             
          ];
    

    var options = {
               showStateColumn:false,
               showRowNumColumn    : false,
               usePaging : true,
               editable : false//,
               //selectionMode : "singleRow"
         }; 
    
    reqBatchGrid = GridCommon.createAUIGrid("#reqBatchGrid", colLayout, "", options);
    
      // 셀 더블클릭 이벤트 바인딩
     AUIGrid.bind(reqBatchGrid, "cellDoubleClick", function(event){
         
    	 Common.popupDiv("/sales/trBook/requestBatchDetailPop.do",{reqId:AUIGrid.getCellValue(reqBatchGrid, event.rowIndex, "trBookBkReqId")}, null, true, "requestBatchDetailPop");
     }); 
}

//리스트 조회.
function fn_selectReqBatchList() {
    
   Common.ajax("GET", "/sales/trBook/selelctRequestBahchList", $("#reqBahchForm").serialize(), function(result) {
      
       console.log("성공.");
       console.log( result);
       
      AUIGrid.setGridData(reqBatchGrid, result);

  }); 
}


function fn_doPrintBatch(){
	//Validation
	var selRow = AUIGrid.getSelectedItems(reqBatchGrid);
	
	//Validation
    if(selRow == null || selRow.length <= 0 ){
        Common.alert('<spring:message code="sal.alert.msg.noResultSelected" />');
        return;
    }
	//Download Report
    var date = new Date().getDate();
    if(date.toString().length == 1){
        date = "0" + date;
    } 
	
	var rprFileName = selRow[0].item.trBookBkReqNo+"_"+date+(new Date().getMonth()+1)+new Date().getFullYear();
	//FileName
	$("#reportDownFileName").val(rprFileName);
	//Batch ID
	$("#BatchID").val(selRow[0].item.trBookBkReqId);
	//End Tr No
	$("#EndTRNo").val(selRow[0].item.trBookBkReqEndReciptNo);
	//Start Tr No
    $("#StartTRNo").val(selRow[0].item.trBookBkReqStartReciptNo);
	
	/* console.log('$("#reportDownFileName").val() : ' +$("#reportDownFileName").val());
	console.log('$("#BatchID").val() : ' +$("#BatchID").val());
	console.log('$("#EndTRNo").val() : ' +$("#EndTRNo").val());
	console.log('$("#StartTRNo").val() : ' +$("#StartTRNo").val()); */
	
	//download
	fn_report();
	
}

function fn_report() {
    var option = {
        isProcedure : false 
    };
    Common.report("dataForm", option);
}

</script>
<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<form id="dataForm">
    <input type="hidden" id="reportFileName" name="reportFileName" value="/sales/TRbookSummaryListingByBatch_PDF.rpt" /><!-- Report Name  -->
    <input type="hidden" id="viewType" name="viewType" value="PDF" /><!-- View Type  -->
    <input type="hidden" id="reportDownFileName" name="reportDownFileName"/><!-- Download Name -->
    
    <!-- params -->
    <input type="hidden" id="BatchID" name="BatchID" />
    <input type="hidden" id="EndTRNo" name="EndTRNo" />
    <input type="hidden" id="StartTRNo" name="StartTRNo" />
</form>

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="sal.page.title.trBookTransaction" /></h1>
<ul class="right_opt">
	<li><p class="btn_blue2"><a href="#"><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body" style="min-height: auto;"><!-- pop_body start -->

<form action="#" method="post" id="reqBahchForm" name="reqBahchForm">
<input type="hidden" id="pgm" name="pgm" value="tran"/>
<input type="hidden" id="trTranBookId" name="trBookId" />

<aside class="title_line"><!-- title_line start -->
<ul class="right_btns">
	<li><p class="btn_blue"><a href="#" onclick="javascript:fn_doPrintBatch();"><spring:message code="sal.title.text.bulkTrBookListing" /></a></p></li>
	<li><p class="btn_blue"><a href="#" onclick="javascript:fn_selectReqBatchList();"><span class="search"></span><spring:message code="sal.btn.search" /></a></p></li>
	<li><p class="btn_blue"><a href="#" id="btnClear"><span class="clear"></span><spring:message code="sal.btn.clear" /></a></p></li>
</ul>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:160px" />
	<col style="width:*" />
	<col style="width:160px" />
	<col style="width:*" />
	<col style="width:160px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row"><spring:message code="sal.text.batchNumber" /></th>
	<td><input type="text" title="" placeholder="Request Number" class="w100p"  id="batchNo" name ="batchNo"/>
	<th><spring:message code="sal.text.batchStatus" /></th>
	<td>
	    <select class="multy_select w100p" multiple="multiple" id="batchStatus" name="batchStatus">
            <option value="1" selected="selected"><spring:message code="sal.text.active" /></option>
            <option value="4"><spring:message code="sal.text.complete" /></option>
            <option value="8"><spring:message code="sal.text.inactive" /></option>
        </select>
    </td>
	<th scope="row"><spring:message code="sal.text.createDate" /></th>
	<td><input type="text"  placeholder="DD/MM/YYYY" class="j_date w100p" id="batchCrtDt" name="batchCrtDt"/>
</tr>
<tr>
	<th scope="row"><spring:message code="sal.text.requestBranch" /></th>
	<td>
       <select class="w100p" id="reqBranch" name="reqBranch">
       </select>
    </td>
	<th scope="row"><spring:message code="sal.text.creator" /></th>
	<td><input type="text" title="" placeholder="Creator(Username)" class="w100p"  id="userNm" name ="userNm"/></td>
	<td colspan="2"></td>
</tr>
</tbody>
</table><!-- table end -->

<section class="search_result"><!-- search_result start -->

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="reqBatchGrid" style="width:100%; height:250px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->


</section><!-- pop_body end -->

</div><!-- popup_wrap end -->