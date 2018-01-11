<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<script type="text/javaScript">
var myGridID;
var selectedEntryId;

$(document).ready(function(){
   // myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout,null,gridPros);
   myGridID = AUIGrid.create("#grid_wrap", columnLayout, gridPros); 
   AUIGrid.setSelectionMode(myGridID, "singleRow");  
    
 // 에디팅 시작 이벤트 바인딩
   /*  AUIGrid.bind(myGridID, ["cellEditBegin"], function(event) {
       if(event.item.name1 == 'Inactive'){
    	   return false;
       }else{
    	   Common.confirm("Are you sure you want to disable the selected Invoice P/O #? Once disabled, can not restore.", fn_doDisable);
       }
    }); */
    
    $("#startPeriod").keyup(function() {
        var str = $("#startPeriod").val();
        var pattern_eng = /[A-za-z]/g;

         if (pattern_eng.test(str)) {
             $("#startPeriod").val(str.replace(/[^0-9]/g, ""));
         }
   });
    
    $("#endPeriod").keyup(function() {
        var str = $("#endPeriod").val();
        var pattern_eng = /[A-za-z]/g;

         if (pattern_eng.test(str)) {
             $("#endPeriod").val(str.replace(/[^0-9]/g, ""));
         }
   });
    
    $("#startPeriod").change(function(e){
    	if($(this).val() < 1 ) $("#startPeriod").val(1);
    	else if($(this).val() > 60) $("#startPeriod").val(60);
    });
    
    $("#endPeriod").change(function(e){
        if($(this).val() < 1 ) $("#endPeriod").val(1);
        else if($(this).val() > 60) $("#endPeriod").val(60);
    });
});

var gridPros = {
        editable: false,
        showStateColumn: false,
        pageRowCount : 10,
        rowButtonDisabledFunction : function(rowIndex, item) {
            if(item.name1 == "Inactive") { // 제품이 LG G3 인 경우 체크박스 disabeld 처리함
                return false; // false 반환하면 disabled 처리됨
            }
            return true;
        }
};

var columnLayout=[
    {dataField:"id", headerText:"<spring:message code='pay.head.poEntryId'/>", visible:true},
    {dataField:"salesOrdNo", headerText:"<spring:message code='pay.head.orderNo'/>"},
    {dataField:"name", headerText:"<spring:message code='pay.head.customerName'/>"},
    {dataField:"poRefNo", headerText:"<spring:message code='pay.head.poReference'/>"},
    {dataField:"period", headerText:"<spring:message code='pay.head.period'/>"},
    {dataField:"userName", headerText:"<spring:message code='pay.head.createdBy'/>"},
    {dataField:"poCrtDt", headerText:"<spring:message code='pay.head.createdAt'/>", dataType : "date", formatString : "yyyy-mm-dd hh:MM:ss"}, 
    {dataField:"username1", headerText:"<spring:message code='pay.head.updatedBy'/>"},
    {dataField:"poUpdDt", headerText:"<spring:message code='pay.head.lastUpdate'/>", dataType : "date", formatString : "yyyy-mm-dd hh:MM:ss"},
    {dataField:"name1", headerText:"<spring:message code='pay.head.status'/>"},
    {
    	dataField : "disable",
    	headerText :"<spring:message code='pay.head.disable'/>",
    	renderer : {
    		type:"ButtonRenderer",
    		labelText : "<spring:message code='pay.head.disable'/>",
    		onclick : function(rowIndex, columnIndex, value, item){
    			if(item.name1 == 'Inactive'){
    				return false;
    			}else{
    				console.log("entryId : " +item.id);
                    selectedEntryId = item.id;
    				Common.confirm("<spring:message code='pay.alert.invoiceDisable'/>", fn_doDisable);
    				
    			}
    		} 
    	}
    }
];

function fn_doDisable(){
	console.log("selectedEntryID : " + selectedEntryId);
	if(selectedEntryId != undefined && selectedEntryId != ''){
		Common.ajax("GET", "/payment/disablePOEntry.do", {"poEntryId" : selectedEntryId}, function(result) {
	        if(result.message == '') {
	        	fn_loadOrderPO($("#orderId").val());
	        	Common.alert("<spring:message code='pay.alert.disableSuccess'/>");
	        }
	        else Common.alert("<spring:message code='pay.alert.error' arguments='"+result.message+"' htmlEscape='false'/>");
	    });
	}
}

function fn_orderInfo(){
	Common.popupDiv("/sales/order/orderSearchPop.do", {callPrgm : "BILLING_STATEMENT_PO", indicator : "SearchTrialNo"});
}

function fn_callbackOrder(orderId){
    console.log("orderId : " + orderId);
    fn_loadOrderPO(orderId);
}

function fn_loadOrderPO(orderId){
	Common.ajax("GET", "/payment/selectOrderBasicInfoByOrderId.do", {"orderId" : orderId}, function(result) {
        $("#orderId").val(result.ordId);
        $("#orderNo").val(result.ordNo);
        $("#custName").val(result.custName);
        selectedEntryId = undefined;
        
    });
	
	Common.ajax("GET", "/payment/selectOrderDataByOrderId.do", {"orderId" : orderId}, function(result) {
		 AUIGrid.setGridData(myGridID, result);
    });
}

function fn_createEvent(objId, eventType){
    var e = jQuery.Event(eventType);
    $('#'+objId).trigger(e);
}

function fn_addEntry(){
	if($("#orderId").val() != undefined && $("#orderId").val() != ''){
		   $("#newEntry").show();
	}else{
		Common.alert("<spring:message code='pay.alert.selectAnOrderFirst'/>");
	}
}

function fn_hidePopup(){
    $("#newEntry").hide();
    $("#newEntryForm").each(function(){
        this.reset();
    });
}

function fn_doSave(){
	if($("#orderId").val() == undefined || $("#orderId").val() == ''){
		Common.alert("<spring:message code='pay.alert.selectAnOrderFirst'/>");
	}else{
		var orderId = $("#orderId").val();
		var startPeriod = $("#startPeriod").val();
		var endPeriod=$("#endPeriod").val();
		console.log("orderId :" + orderId +", startPeriod : " + startPeriod +", endPeriod : " + endPeriod);
		console.log("curdate : " + $.datepicker.formatDate($.datepicker.ATOM, new Date()));
		Common.ajax("GET", "/payment/selectInvoiceStatement.do", {"orderId" : orderId, "startPeriod" : startPeriod}, function(result) {
		    if(result.message != ''){
		    	Common.alert(result.message);
		    }else{
		    	if(startPeriod == '' || startPeriod == 0 || endPeriod == '' || endPeriod == 0){
		    		Common.alert("<spring:message code='pay.alert.requiredPeriod'/>");
		    		return;
		    	}else{
		    		if(Number(startPeriod) > Number(endPeriod)){
		    			Common.alert("<spring:message code='pay.alert.periodNotFulfilled'/>");
		    			return;
		    		}
		    	}
		    	
		    	var poNo = $("#referenceNo").val();
		    	if(poNo == undefined || poNo == '' ){
		    		Common.alert("<spring:message code='pay.alert.requiredPONo'/>");
		    		return;
		    	}else if(poNo.length > 20){
		    		Common.alert("<spring:message code='pay.alert.not20Char'/>");
		    		return;
		    	}
		    	
		    	var po = {
		    			"poOrderId" : orderId,
		    			"poReferenceNo" : $("#referenceNo").val(),
		    			"poStartInstallment" : startPeriod,
		    			"poEndInstallment" : endPeriod,
		    			"poRemark" : $("#remark").val(),
		    			"poStatusId" : 1
		    	};
		    	
		    	Common.ajax("GET", "/payment/insertInvoiceStatement.do", po, function(result) {
		    		console.log(result);
		    		fn_loadOrderPO(result.poOrderId);
		    	});
		    }
		    fn_hidePopup();
	    });
	}
		
}
</script>

<!-- content start -->
  <section id="content">
   <ul class="path">
       <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
   </ul>
  
   <!-- title_line start -->
   <aside class="title_line">
       <p class="fav"><a href="javascript:;" class="click_add_on"><spring:message code='pay.text.myMenu'/></a></p>
       <h2>Invoice/Statement Purchase Order</h2>   
       <ul class="right_btns">
           <c:if test="${PAGE_AUTH.funcView == 'Y'}">
           <li><p class="btn_blue"><a href="javascript:fn_orderInfo();"><span class="search"></span><spring:message code='sys.btn.search'/></a></p></li>
           </c:if>
       </ul>    
   </aside>
   <!-- title_line end -->


<!-- search_table start -->
 <section class="search_table">
     <form name="searchForm" id="searchForm"  method="post">
         <input type="hidden" id="poNo" name="poNo" />
         <table class="type1"><!-- table start -->
			<caption>table</caption>
			<colgroup>
			    <col style="width:110px" />
			    <col style="width:*" />
			    <col style="width:150px" />
			    <col style="width:*" />
			</colgroup>
			<tbody>
			<tr>
			    <th scope="row">Order No.</th>
			    <td>
			    <input type="text" id="orderNo" name="orderNo" title="" placeholder="" class="w100p readonly" readonly/>
			    <input type="hidden" id="orderId" name="orderId" title="" placeholder="" class="w100p" />
			    </td>
			    <th scope="row">Customer Name</th>
			    <td>
			    <input type="text" id="custName" name="custName" title="" placeholder="" class="w100p readonly" readonly/>
			    </td>
			</tr>
			</tbody>
		</table><!-- table end -->
     </form>
     <!-- link_btns_wrap start -->
     <c:if test="${PAGE_AUTH.funcChange == 'Y'}">
     <aside class="link_btns_wrap">
         <p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
         <dl class="link_list">
             <dt>Link</dt>
             <dd>
                 <ul class="btns">
                     <li><p class="link_btn type2"><a href="javascript:fn_addEntry()"><spring:message code='pay.btn.addNewEntry'/></a></p></li>
                 </ul>
                 <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
             </dd>
         </dl>
     </aside>
     </c:if>
     <!-- link_btns_wrap end -->
    </section>

    <!-- search_result start -->
    <section class="search_result">     
  <!-- grid_wrap start -->
  <article id="grid_wrap" class="grid_wrap"></article>
  <!-- grid_wrap end -->
    </section>
</section>

 <div id="newEntry" class="popup_wrap size_mid" style="display:none;"><!-- popup_wrap start -->

     <header class="pop_header"><!-- pop_header start -->
         <h1>INVOICE/STATEMENT P/O MAINTANENCE</h1>
         <ul class="right_opt">
             <li><p class="btn_blue2"><a href="" onclick="javascript:fn_hidePopup();"><spring:message code='sys.btn.close'/></a></p></li>
         </ul>
     </header><!-- pop_header end -->

     <section class="pop_body"><!-- pop_body start -->
         <form id="newEntryForm" name="newEntryForm">
         <table class="type1"><!-- table start -->
		<caption>table</caption>
		<colgroup>
		    <col style="width:140px" />
		    <col style="width:*" />
		    <col style="width:180px" />
		    <col style="width:*" />
		</colgroup>
		<tbody>
			<tr>
			    <th scope="row">Period</th>
			    <td colspan="3">
			        <div class="date_set w100p">
			           <p><input type="text" id="startPeriod" name="startPeriod" title="" placeholder="" class="w100p" min="1" max="60"/></p>
			        <span>~</span>
		               <p><input type="text" id="endPeriod" name="endPeriod" title="" placeholder="" class="w100p" min="1" max="60"/></p>
		            </div>
			    </td>
			</tr>
			<tr>
			    <th scope="row">P/O Reference No.</th>
			    <td colspan="3">
			        <input type="text" id="referenceNo" name="referenceNo" title="" placeholder="" class="w100p" />
			    </td>
			</tr>
			<tr>
		        <th scope="row">Remarks</th>
		        <td colspan="3">
		            <input type="text" id="remark" name="remark" title="" placeholder="" class="w100p" />
		        </td>
		    </tr>
		</tbody>
	</table><!-- table end -->
         </form>
         <ul class="center_btns">
             <li><p class="btn_blue2 big"><a href="javascript:fn_doSave();" id="btnSave" onclick=""><spring:message code='sys.btn.save'/></a></p></li>
         </ul>

     </section><!-- pop_body end -->

 </div><!-- popup_wrap end -->
