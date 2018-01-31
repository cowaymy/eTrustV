<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script  type="text/javascript">

var trBookGridID;

$(document).ready(function(){

    creatGrid();
    
    $('#summaryListing').click(function() {
        Common.popupDiv("/sales/trBook/trBookMgmtSummaryListingPop.do", null, null, true);
    });
    $('#lostListing').click(function() {
        Common.popupDiv("/sales/trBook/trBookMgmtLostReportListPop.do", null, null, true);
    });
    $('#reqBatch').click(function() {
        Common.popupDiv("/sales/trBook/requestBahchListPop.do", null, null, true);
    });
     
});


function creatGrid(){

	    var trBookColLayout = [ 
	          {dataField : "trBookId", headerText : "", width : 140	 , visible:false   },
	          {dataField : "trBookNo", headerText : "<spring:message code="sal.title.bookNo" />", width : 140	    },
	          {dataField : "trBookPrefix", headerText : "<spring:message code="sal.title.prefix" />", width : 110	    },
	          {dataField : "trBookNoStart", headerText : "<spring:message code="sal.title.from" />", width : 120	    },
	          {dataField : "trBookNoEnd", headerText : "<spring:message code="sal.title.to" />", width : 120	    },
	          {dataField : "trBookPge", headerText : "<spring:message code="sal.title.sheet" />", width : 130	    },
	          {dataField : "trBookStusCode", headerText : "<spring:message code="sal.title.status" />", width : 110	    },
	          {dataField : "trHolder", headerText : "<spring:message code="sal.title.holder" />", width : 110	    },
	          {dataField : "trHolderType", headerText : "<spring:message code="sal.title.holderType" />", width : 110	    }	,          
	          {dataField : "boxNo", headerText : "", width : 110,	  visible:false   }         
	          ];
	    

	    var trBookOptions = {
	               showStateColumn:false,
	               showRowNumColumn    : true,
	               usePaging : true,
	               editable : false
	               //selectionMode : "singleRow"
	         }; 
	    
	    trBookGridID = GridCommon.createAUIGrid("#trBookGridID", trBookColLayout, "", trBookOptions);
	    
	    // 셀 더블클릭 이벤트 바인딩
	     AUIGrid.bind(trBookGridID, "cellDoubleClick", function(event){
	         
	          $("#trBookId").val(AUIGrid.getCellValue(trBookGridID , event.rowIndex , "trBookId"));
	         
	          Common.popupDiv("/sales/trBook/trBookMgmtDetailPop.do",$("#listSForm").serializeJSON(), null, true, "trBookMgmtDetailPop");
	          
	     });
	    // 셀 클릭 이벤트 바인딩
	     AUIGrid.bind(trBookGridID, "cellClick", function(event){
	         
	          $("#trBookId").val(AUIGrid.getCellValue(trBookGridID , event.rowIndex , "trBookId"));
		          
	     });
}

//리스트 조회.
function fn_selectListAjax() {
	$("#trBookId").val("");
   	
  Common.ajax("GET", "/sales/trBook/selectTrBookMgmtList", $("#listSForm").serialize(), function(result) {
      
       console.log("성공.");
       console.log( result);
       
      AUIGrid.setGridData(trBookGridID, result);

  });
}

function fn_clear(){
	$("#listSForm")[0].reset();
}

function fn_trBookAddSingle(){
	Common.popupDiv("/sales/trBook/trBookAddSinglePop.do",$("#listSForm").serializeJSON(), null, true, "trBookAddSinglePop");
}

function fn_trBookAddBulk(){
	Common.popupDiv("/sales/trBook/trBookAddBulkPop.do",$("#listSForm").serializeJSON(), null, true, "trBookAddBulkPop");
}

function fn_trBookTransaction(){
	Common.popupDiv("/sales/trBook/trBookTransactionPop.do",$("#listSForm").serializeJSON(), null, true, "trBookTransactionPop");
}

function fn_trBookAssign(){
	
	if($("#trBookId").val()==""){		
		   Common.alert("Book Missing" + DEFAULT_DELIMITER + "No TR book selected.");
	}else{			
		  
		if(fn_getBookActionValidation()){
			var selectedItems = AUIGrid.getSelectedItems(trBookGridID);        
            var first = selectedItems[0];
            
            var bookNo = AUIGrid.getCellValue(trBookGridID , first.rowIndex , "trBookNo");
            var trHolder = AUIGrid.getCellValue(trBookGridID , first.rowIndex , "trHolder");
            var trHolderType = AUIGrid.getCellValue(trBookGridID , first.rowIndex , "trHolderType");
            
            if(trHolderType != "Branch"){
                Common.alert("<spring:message code="sal.alert.title.trBookInfo" />"  + DEFAULT_DELIMITER + "[" + bookNo + "] <spring:message code="sal.alert.msg.isHoldingBy" /> [" + trHolder +"]. <spring:message code="sal.alert.msg.bookAssignIsDisallowed" />");
                return ;
            }else{

                Common.popupDiv("/sales/trBook/trBookAssignPop.do",$("#listSForm").serializeJSON(), null, true, "trBookAssignPop");
              //  Common.popupDiv("/sales/trBook/trBookReturnPop.do",$("#listSForm").serializeJSON(), null, true, "trBookRetrunPop");
            }
            
		}
		
	}
	
}

function fn_trBookReturn(){
	
    if($("#trBookId").val()==""){     
    	
        Common.alert("<spring:message code="sal.alert.title.bookMissing" />" + DEFAULT_DELIMITER + "<spring:message code="sal.alert.msg.noTrBookSelected" />");
        
    }else{  
    	
    	if(fn_getBookActionValidation()){
    		var selectedItems = AUIGrid.getSelectedItems(trBookGridID);        
            var first = selectedItems[0];
            
            var bookNo = AUIGrid.getCellValue(trBookGridID , first.rowIndex , "trBookNo");
            var trHolder = AUIGrid.getCellValue(trBookGridID , first.rowIndex , "trHolder");
            var trHolderType = AUIGrid.getCellValue(trBookGridID , first.rowIndex , "trHolderType");
                    
            if(trHolderType != "Member"){
                Common.alert("<spring:message code="sal.alert.title.trBookInfo" />"  + DEFAULT_DELIMITER + "[" + bookNo + "] <spring:message code="sal.alert.msg.isHoldingByBranch" /> [" + trHolder +"]. <spring:message code="sal.alert.msg.bookReturnIsDisallowed" />");
                return ;
            }else{
                Common.popupDiv("/sales/trBook/trBookReturnPop.do",$("#listSForm").serializeJSON(), null, true, "trBookRetrunPop");
            }
    	}
		 
	 }
}

function fn_trBookReport(){
	
    if($("#trBookId").val()==""){     
    	
        Common.alert("<spring:message code="sal.alert.title.bookMissing" />" + DEFAULT_DELIMITER + "<spring:message code="sal.alert.msg.noTrBookSelected" />");
        
    }else{  
    	
    	if(fn_getBookActionValidation()){
    		var selectedItems = AUIGrid.getSelectedItems(trBookGridID);        
            var first = selectedItems[0];
            
            var bookId = AUIGrid.getCellValue(trBookGridID , first.rowIndex , "trBookId");
            var bookStus = AUIGrid.getCellValue(trBookGridID , first.rowIndex , "trBookStusCode");
            var bookNo = AUIGrid.getCellValue(trBookGridID , first.rowIndex , "trBookNo");
                    
            if(bookStus != "ACT"){
                Common.alert("<spring:message code="sal.alert.title.trBookInfo" />"  + DEFAULT_DELIMITER + "[" + bookNo + "] <spring:message code="sal.alert.msg.reportLostIsDisallowed" />");
                return ;
            }else{
                Common.popupDiv("/sales/trBook/reportLostViewPop.do",$("#listSForm").serializeJSON(), null, true, "reportLostViewPop");
            }
    	}
		 
	 }
}

function fn_trBookTranSingle(){
    
    if($("#trBookId").val()==""){       
           Common.alert("<spring:message code="sal.alert.title.bookMissing" />" + DEFAULT_DELIMITER + "<spring:message code="sal.alert.msg.noTrBookSelected" />");
    }else{          
          
        if(fn_getBookActionValidation()){
            var selectedItems = AUIGrid.getSelectedItems(trBookGridID);        
            var first = selectedItems[0];
            
            var bookNo = AUIGrid.getCellValue(trBookGridID , first.rowIndex , "trBookNo");
            var trHolder = AUIGrid.getCellValue(trBookGridID , first.rowIndex , "trHolder");
            var trHolderType = AUIGrid.getCellValue(trBookGridID , first.rowIndex , "trHolderType");
            
            if(trHolderType != "Branch"){
                Common.alert("<spring:message code="sal.alert.title.trBookInfo" />"  + DEFAULT_DELIMITER + "[" + bookNo + "] <spring:message code="sal.alert.msg.isHoldingBy" /> [" + trHolder +"]. <spring:message code="sal.alert.msg.bookTransferIsDisallowed" />");
                return ;
            }else{
                Common.popupDiv("/sales/trBook/trBookTranSinglePop.do",$("#listSForm").serializeJSON(), null, true, "trBookTranSinglePop");
            }
        }
        
    }
    
}

function fn_trBookTranBulk(){
	Common.popupDiv("/sales/trBook/trBookTranBulkPop.do",$("#listSForm").serializeJSON(), null, true, "trBookTranBulkPop");
}

function fn_requestBatch(){
	Common.popupDiv("/sales/trBook/requestBatchPop.do",$("#listSForm").serializeJSON(), null, true, "requestBatchPop");
}

function fn_getBookActionValidation(){
	
	var valid = true;
     
    var selectedItems = AUIGrid.getSelectedItems(trBookGridID); 
    
    var first = selectedItems[0];
    
    var bookId = AUIGrid.getCellValue(trBookGridID , first.rowIndex , "trBookId");
    var bookStatus = AUIGrid.getCellValue(trBookGridID , first.rowIndex , "trBookStusCode");
    var bookNo = AUIGrid.getCellValue(trBookGridID , first.rowIndex , "trBookNo");
   
    if ((bookStatus == "CLO") || (bookStatus == "CLOLOST"))
    {
        Common.alert("<spring:message code="sal.alert.title.trBookInfo" />"  + DEFAULT_DELIMITER + "[" + bookNo + "] <spring:message code="sal.alert.msg.bookHasReturnClosed" />");
        valid = false ;
    }
    else if (bookStatus == "IACT")
    {
        Common.alert("<spring:message code="sal.alert.title.trBookInfo" />"  + DEFAULT_DELIMITER + "[" + bookNo + "] <spring:message code="sal.alert.msg.bookHasDeactivated" />");
        valid = false ;
    }
    
    return valid;
}

function fn_trBookDeactivate(){
	
    if($("#trBookId").val()==""){       
        Common.alert("<spring:message code="sal.alert.title.bookMissing" />" + DEFAULT_DELIMITER + "<spring:message code="sal.alert.msg.noTrBookSelected" />");
	}else{          
	       
	     if(fn_getBookActionValidation()){
	         var selectedItems = AUIGrid.getSelectedItems(trBookGridID);        
	         var first = selectedItems[0];
	         
	         var bookNo = AUIGrid.getCellValue(trBookGridID , first.rowIndex , "trBookNo");
	         var trHolder = AUIGrid.getCellValue(trBookGridID , first.rowIndex , "trHolder");
	         var trHolderType = AUIGrid.getCellValue(trBookGridID , first.rowIndex , "trHolderType");
	         
	         if(trHolderType != "Branch"){
	             Common.alert("<spring:message code="sal.alert.title.trBookInfo" />"  + DEFAULT_DELIMITER + "[" + bookNo + "] <spring:message code="sal.alert.msg.isHoldingBy" /> [" + trHolder +"]. <spring:message code="sal.alert.msg.deactivationIsDisallowed" />");
	             return ;
	         }else{
	             Common.popupDiv("/sales/trBook/trBookDeactivatePop.do",$("#listSForm").serializeJSON(), null, true, "trBookDeactivatePop");
	         }
	     }
	     
	 }
}

function fn_trBookKeep(){
    if($("#trBookId").val()==""){       
        Common.alert("<spring:message code="sal.alert.title.bookMissing" />" + DEFAULT_DELIMITER + "<spring:message code="sal.alert.msg.noTrBookSelected" />");
    }else{    
	
	    var selectedItems = AUIGrid.getSelectedItems(trBookGridID); 
	    
	    var first = selectedItems[0];
	    
	    var bookId = AUIGrid.getCellValue(trBookGridID , first.rowIndex , "trBookId");
	    var bookStatus = AUIGrid.getCellValue(trBookGridID , first.rowIndex , "trBookStusCode");
	    var bookNo = AUIGrid.getCellValue(trBookGridID , first.rowIndex , "trBookNo");

	    if ((bookStatus == "CLO") || (bookStatus == "CLOLOST"))
	    {

	    	var boxNo = AUIGrid.getCellValue(trBookGridID , first.rowIndex , "boxNo");
	    	
	    	if(boxNo == " "){	    		
	    		Common.popupDiv("/sales/trBook/trBookKeepBoxPop.do",$("#listSForm").serializeJSON(), null, true, "trBookKeepBoxPop");
	    	}else{
	    		Common.alert("<spring:message code="sal.alert.title.bookMissing" />" + DEFAULT_DELIMITER +"<spring:message code="sal.alert.msg.thisBookHasBeenKeptInBox" /> [" + boxNo + "].");
	    	}
	    	
	    }else{
	    	Common.alert("<spring:message code="sal.alert.title.trBookInfo" />"+DEFAULT_DELIMITER+"<b>[" + BookNo + "] <spring:message code="sal.alert.msg.bookYetClosed" /></b>");
	    }
    }
}

</script>

<section id="content"><!-- content start -->
<ul class="path">
	<li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
	<li>Sales</li>
	<li>TR Book</li>
	<li>TR Book Management</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2><spring:message code="sal.page.title.trBookManagement" /></h2>
<ul class="right_btns">
	<c:if test="${PAGE_AUTH.funcView == 'Y'}">
	<li><p class="btn_blue"><a href="#" onclick="javascript:fn_selectListAjax();"><span class="search"></span><spring:message code="sal.btn.search" /></a></p></li>
	</c:if>
	<li><p class="btn_blue"><a href="#" onclick="javascript:fn_clear();"><span class="clear"></span><spring:message code="sal.btn.clear" /></a></p></li>
</ul>
</aside><!-- title_line end -->

<form action="#" method="post" id="listSForm" name="listSForm">
<input type="hidden" id="trBookId" name="trBookId">


<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:150px" />
	<col style="width:*" />
	<col style="width:150px" />
	<col style="width:*" />
	<col style="width:150px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row"><spring:message code="sal.text.bookNo" /></th>
	<td>
	<input type="text" title="" placeholder="Book No" class="w100p"  id="trBookNo" name ="trBookNo"/>
	</td>
	<th scope="row"><spring:message code="sal.text.trNo" /></th>
	<td>
	<input type="text" title="" placeholder="TR No" class="w100p" id="trNo" name="trNo"/>
	</td>
	<th scope="row"><spring:message code="sal.text.createDate" /></th>
	<td>
		<input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p" id="trBookCrtDt" name="trBookCrtDt"/>
	</td>
</tr>
<tr>
	<th scope="row"><spring:message code="sal.text.createBy" /></th>
	<td>
	<input type="text" title="" placeholder="Create By" class="w100p" id="trBookCrtUser" name="trBookCrtUser"/>
	</td>
	<th scope="row"><spring:message code="sal.text.bookHolder" /></th>
	<td>
	<input type="text" title="" placeholder="Book Holder" class="w100p" id="trBookHolder" name="trBookHolder" />
	</td>
	<th scope="row"><spring:message code="sal.text.holderType" /></th>
	<td>
		<select class="w100p" id="trHolderType" name="trHolderType">
			<option value="Branch" selected="selected"><spring:message code="sal.text.branch" /></option>
			<option value="Member"><spring:message code="sal.text.member" /></option>
		</select>
	</td>
</tr>
<tr>
	<th scope="row"><spring:message code="sal.text.status" /></th>
	<td>
		<select class="multy_select w100p" multiple="multiple" id="status" name="status">
			<option value="1" selected="selected"><spring:message code="sal.text.active" /></option>
			<option value="36"><spring:message code="sal.text.close" /></option>
			<option value="67"><spring:message code="sal.text.lost" /></option>
		</select>
	</td>
	<td colspan="4"></td>
</tr>
</tbody>
</table><!-- table end -->
</form>

<aside class="link_btns_wrap"><!-- link_btns_wrap start -->
<p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
<dl class="link_list">
	<dt>Link</dt>
	<dd>
	<ul class="btns">
		<c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
		<li><p class="link_btn"><a href="#" id="summaryListing"><spring:message code="sal.btn.link.summaryListing" /></a></p></li>
		</c:if>
		<c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
		<li><p class="link_btn"><a href="#" id="lostListing"><spring:message code="sal.btn.link.lostListing" /></a></p></li>
		</c:if>
		<c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
        <li><p class="link_btn type2"><a href="#" onclick="javascript:fn_trBookTransaction();"><spring:message code="sal.btn.link.transactionList" /></a></p></li>
        </c:if>
		<c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
        <li><p class="link_btn type2"><a href="#" id="reqBatch"><spring:message code="sal.btn.link.requestBatch" /></a></p></li>
        </c:if>
	</ul>
	<p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
	</dd>
</dl>
</aside><!-- link_btns_wrap end -->
<section class="search_result"><!-- search_result start -->

<ul class="right_btns mt10">
    <c:if test="${PAGE_AUTH.funcUserDefine2 == 'Y'}">
	<li><p class="btn_grid"><a href="#" onclick="javascript:fn_trBookAddSingle();"><spring:message code="sal.btn.addSingle" /></a></p></li> <!-- TODO 권한 177  -->
	</c:if>
	<c:if test="${PAGE_AUTH.funcUserDefine2 == 'Y'}">
	<li><p class="btn_grid"><a href="#" onclick="javascript:fn_trBookAddBulk();"><spring:message code="sal.btn.addBulk" /></a></p></li>    <!-- TODO 권한 177  -->
	</c:if>
	<c:if test="${PAGE_AUTH.funcUserDefine3 == 'Y'}">
	<li><p class="btn_grid"><a href="#" onclick="javascript:fn_trBookTranSingle();"><spring:message code="sal.btn.transferSingle" /></a></p></li>  <!-- TODO 권한 122  -->
	</c:if>
	<c:if test="${PAGE_AUTH.funcUserDefine4 == 'Y'}">
	<li><p class="btn_grid"><a href="#" onclick="javascript:fn_trBookTranBulk();"><spring:message code="sal.btn.transferBulk" /></a></p></li>    <!-- TODO 권한 178  -->
	</c:if>
	<c:if test="${PAGE_AUTH.funcUserDefine5 == 'Y'}">
	<li><p class="btn_grid"><a href="#" onclick="javascript:fn_trBookAssign();"><spring:message code="sal.btn.assign" /></a></p></li>          <!-- TODO 권한 118  -->
	</c:if>
	<c:if test="${PAGE_AUTH.funcUserDefine6 == 'Y'}">
	<li><p class="btn_grid"><a href="#" onclick="javascript:fn_trBookReturn();"><spring:message code="sal.btn.return" /></a></p></li>          <!-- TODO 권한 120  -->
	</c:if>
	<c:if test="${PAGE_AUTH.funcUserDefine7 == 'Y'}">
	<li><p class="btn_grid"><a href="#" onclick="javascript:fn_trBookReport();"><spring:message code="sal.btn.reportLostWhole" /></a></p></li>          <!-- TODO 권한 179  -->
	</c:if>
	<c:if test="${PAGE_AUTH.funcUserDefine8 == 'Y'}">
	<li><p class="btn_grid"><a href="#" onclick="javascript:fn_trBookDeactivate();"><spring:message code="sal.btn.deactive" /></a></p></li>          <!-- TODO 권한 129  -->
	</c:if>
	<c:if test="${PAGE_AUTH.funcUserDefine9 == 'Y'}">
	<li><p class="btn_grid"><a href="#" onclick="javascript:fn_trBookKeep();"><spring:message code="sal.btn.keepIntoBox" /></a></p></li>          <!-- TODO 권한 125  -->
	</c:if>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="trBookGridID" style="width:100%; height:400px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- content end -->