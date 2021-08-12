<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<style type="text/css">
.my-custom-up{
    text-align: left;
}
</style>
<script type="text/javaScript">
var orderListGridId;
var billingscheduleGridId;
var billingTargetGridId;
var selectedGridValue;
var sortingInfo = [];
// 차례로 Country, Name, Price 에 대하여 각각 오름차순, 내림차순, 오름차순 지정.
sortingInfo[0] = { dataField : "installment", sortType : 1 }; // 오름차순 1

var gridPros = {
        // 편집 가능 여부 (기본값 : false)
        editable : false,
        
        // 상태 칼럼 사용
        showStateColumn : false,
};
var gridPros2 = {
        // 편집 가능 여부 (기본값 : false)
        editable : false,
        
        // 상태 칼럼 사용
        showStateColumn : false,
        pageRowCount : 61,
        // 체크박스 표시 설정
        showRowCheckColumn : true,
        // 전체 체크박스 표시 설정
        showRowAllCheckBox : true,
        softRemoveRowMode:false,
        independentAllCheckBox : true,

        rowCheckableFunction : function(rowIndex, isChecked, item) {
            if(item.billingStus == "Completed") { 
            	Common.alert("<spring:message code='pay.alert.notBillTwice'/>");
                return false;
            }
            return true;
        },
        

        rowCheckDisabledFunction : function(rowIndex, isChecked, item) {
            if(item.billingStus == "Completed") {
                return false; 
            }
            return true;
        }
       
};

var gridPros3 = {
        // 편집 가능 여부 (기본값 : false)
        editable : false,
        
        // 상태 칼럼 사용
        showStateColumn : false,
        pageRowCount : 61,
        // 체크박스 표시 설정
        showRowCheckColumn : true,
        // 전체 체크박스 표시 설정
        showRowAllCheckBox : true,
        softRemoveRowMode:false
};


$(document).ready(function(){
	
});

var orderListLayout = [ 
                       {
                           dataField : "salesOrdNo",
                           headerText : "<spring:message code='pay.head.orderNo'/>",
                           editable : false
                       }, {
                           dataField : "refNo",
                           headerText : "<spring:message code='pay.head.refNo'/>",
                           editable : false,
                           width: 100,
                       }, {
                           dataField : "salesDt",
                           headerText : "<spring:message code='pay.head.orderDate'/>",
                           editable : false,
                           width: 100
                       }, {
                           dataField : "name",
                           headerText : "<spring:message code='pay.head.status'/>",
                           editable : false,
                           width: 100
                       }, {
                           dataField : "codeDesc",
                           headerText : "<spring:message code='pay.head.appType'/>",
                           editable : false
                       }, {
                           dataField : "stkDesc",
                           headerText : "<spring:message code='pay.head.product'/>",
                           editable : false
                       }, {
                           dataField : "name1",
                           headerText : "<spring:message code='pay.head.customer'/>",
                           editable : false,
                           width: 200 ,
                           style : "my-custom-up"
                       }, {
                           dataField : "custBillId",
                           headerText : "<spring:message code='pay.head.billId'/>",
                           editable : false
                       }, {
                           dataField : "salesOrdId",//hidden field
                           headerText : "<spring:message code='pay.head.salesOrdId'/>",
                           visible : false
                       },{
                           dataField : "",
                           headerText : "",
                           editable : false,
                           renderer : {
                               type : "ButtonRenderer",
                               labelText : "Select",
                               onclick : function(rowIndex, columnIndex, value, item) {
                            	   fn_billingSchedule(item.salesOrdId);
                               }
                           }
                       }];

var billingscheduleLayout = [ 
                       {
                           dataField : "salesOrdNo",
                           headerText : "<spring:message code='pay.head.orderNo'/>",
                           editable : false
                       }, {
                           dataField : "installment",
                           headerText : "<spring:message code='pay.head.installment'/>",
                           editable : false,
                       }, {
                           dataField : "schdulDt",
                           headerText : "<spring:message code='pay.head.scheduleDate'/>",
                           editable : false,
                           width: 100
                       }, {
                           dataField : "billType",
                           headerText : "<spring:message code='pay.head.type'/>",
                           editable : false,
                           width: 100
                       }, {
                           dataField : "billAmt",
                           headerText : "<spring:message code='pay.head.amount'/>",
                           editable : false
                       }, {
                           dataField : "billingStus",
                           headerText : "<spring:message code='pay.head.billingStatus'/>",
                           editable : false
                       }, {
                           dataField : "rentInstId",
                           headerText : "<spring:message code='pay.head.rentInstId'/>",
                           editable : false,
                           visible : false
                       },{
                           dataField : "salesOrdId",
                           headerText : "<spring:message code='pay.head.orderId'/>",
                           editable : false,
                           visible : false
                       }];

var billingTargetLayout = [ 
                             {
                                 dataField : "salesOrdNo",
                                 headerText : "<spring:message code='pay.head.orderNo'/>",
                                 editable : false
                             }, {
                                 dataField : "installment",
                                 headerText : "<spring:message code='pay.head.installment'/>",
                                 editable : false,
                             }, {
                                 dataField : "schdulDt",
                                 headerText : "<spring:message code='pay.head.scheduleDate'/>",
                                 editable : false,
                                 width: 100
                             }, {
                                 dataField : "billType",
                                 headerText : "<spring:message code='pay.head.type'/>",
                                 editable : false,
                                 width: 100
                             }, {
                                 dataField : "billAmt",
                                 headerText : "<spring:message code='pay.head.amount'/>",
                                 editable : false
                             }, {
                                 dataField : "billingStus",
                                 headerText : "<spring:message code='pay.head.billingStatus'/>",
                                 editable : false
                             }, {
                                 dataField : "rentInstId",
                                 headerText : "<spring:message code='pay.head.rentInstId'/>",
                                 editable : false,
                                 visible : false
                             },{
                                 dataField : "salesOrdId",
                                 headerText : "<spring:message code='pay.head.orderId'/>",
                                 editable : false,
                                 visible : false
                             }]; 

	function fn_orderSearch(){
	    Common.popupDiv("/sales/order/orderSearchPop.do", {callPrgm : "BILLING_RENTAL_FEE", indicator : "SearchTrialNo"});
	}
	
	function fn_orderInfo(ordNo, ordId){
		orderList(ordNo, ordId);
	}
	
	function orderList(ordNo, ordId){
	
	    Common.ajax("GET","/payment/selectCustBillOrderList.do", {"salesOrdId" : ordId}, function(result){
	        
	        $('#orderId').val(ordId);
	        AUIGrid.destroy(orderListGridId);
	        orderListGridId = GridCommon.createAUIGrid("grid_wrap", orderListLayout,"",gridPros);
	        AUIGrid.setGridData(orderListGridId, result.data.orderList);
	        AUIGrid.resize(orderListGridId); 
	        
	        AUIGrid.destroy(billingscheduleGridId);
          AUIGrid.destroy(billingTargetGridId);
          billingscheduleGridId = GridCommon.createAUIGrid("grid_wrap2", billingscheduleLayout,"",gridPros2);
          billingTargetGridId = GridCommon.createAUIGrid("grid_wrap3", billingTargetLayout,"",gridPros3);
	        
	    });
	}
	
	function fn_createEvent(objId, eventType){
	    var e = jQuery.Event(eventType);
	    $('#'+objId).trigger(e);
	}
	
	function fn_billingSchedule(ordId){
		Common.ajax("GET","/payment/selectRentalBillingSchedule.do", {"salesOrdId" : ordId}, function(result){
            
            AUIGrid.setGridData(billingscheduleGridId, result.data.billingScheduleList);
            
            AUIGrid.bind(billingscheduleGridId, "rowAllChkClick", function( event ) {
                if(event.checked) {
                    // name 의 값들 얻기
                    var uniqueValues = AUIGrid.getColumnDistinctValues(event.pid, "billingStus");
                    uniqueValues.splice(uniqueValues.indexOf("Completed"),1);
                    AUIGrid.setCheckedRowsByValue(event.pid, "billingStus", uniqueValues);
                } else {
                    AUIGrid.setCheckedRowsByValue(event.pid, "billingStus", []);
                }
            });
            
        });
    }
	
	function fn_createBillsPopClose(){
		
		$('#createBillsPop').hide();
        $('#invoiceRemark').val("");
        $('#remark').val("");
    }
	
	//btn clickevent
	$(function(){
		
		$("#btnAddToBillTarget").click(function(){
			
			var checkedItems = AUIGrid.getCheckedRowItemsAll(billingscheduleGridId);
			var billingTargetItems = AUIGrid.getGridData(billingTargetGridId);
			
			if(checkedItems != undefined){
				  
				var allItems = AUIGrid.getGridData(billingscheduleGridId);
				var valid = true;
				var activeList = [];
				
				if(allItems.length > 0){
	      
					var j = 0; 
	        
					for (var i = 0 ; i < allItems.length ; i++){
	          
						if(allItems[i].billingStus == "Active"){
	          
							activeList[j] = {
									billingStus : allItems[i].billingStus,
									installment : allItems[i].installment
							}
	            
							j = j+1;
	            
						}
					}
				}
	      
				if(checkedItems.length > 0){
	      
					var item = new Object();
					var rowList = [];
	        
					for (var i = 0 ; i < checkedItems.length ; i++){
	          
						if(Number(activeList[i].installment) < Number(checkedItems[i].installment)){
	          
							valid = false;
	            
							break;
	            
						}else{
	          
							rowList[i] = {
	            
									salesOrdNo : checkedItems[i].salesOrdNo,
									installment : checkedItems[i].installment,
									schdulDt : checkedItems[i].schdulDt,
									billType : checkedItems[i].billType,
									billAmt : checkedItems[i].billAmt,
									billingStus : checkedItems[i].billingStus,
									salesOrdId : checkedItems[i].salesOrdId
							}
						}
					}

	        
					if(valid){
	          
						if(rowList.length > 0){
	          
							var chkRow = true;
	            
							for (var i = 0 ; i  < rowList.length ; i++){
	              
								var installment = rowList[i].installment;
								var salesOrdNo = rowList[i].salesOrdNo;
	              
								for (var j = 0 ; j  < billingTargetItems.length ; j++){
	              
									if(salesOrdNo ==  billingTargetItems[j].salesOrdNo){
	                  
										if(installment == billingTargetItems[j].installment){
											chkRow = false;
										}
									}
								}
	              
								if(chkRow){
									AUIGrid.addRow(billingTargetGridId, rowList[i], "first");
									AUIGrid.removeCheckedRows(billingscheduleGridId);
								}
							}
						}
	          
					}else{
						Common.alert("<spring:message code='pay.alert.notSkipSchedules'/>");
					}
				}
			}
		});
		
		$("#btnRemoveBillTarget").click(function(){
            
			var checkedItems = AUIGrid.getCheckedRowItemsAll(billingTargetGridId);
			var allItems = AUIGrid.getGridData(billingTargetGridId);
			var billingScheduleItems = AUIGrid.getGridData(billingscheduleGridId);
			var valid = true;
      
			if(checkedItems != undefined){
        
				if (checkedItems.length > 0){
					var item = new Object();
					var rowList = [];
					var index = 0;
					for (var i = checkedItems.length-1 ; i >= 0; i--){
            
						if(Number(allItems[allItems.length-1].installment) >  Number(checkedItems[checkedItems.length-1].installment)){
							valid = false;
							break;
						}else{
            
							if(checkedItems[i].salesOrdNo == billingScheduleItems[0].salesOrdNo){
              
								rowList[index] = {
                
										salesOrdNo : checkedItems[i].salesOrdNo,
										installment : checkedItems[i].installment,
										schdulDt : checkedItems[i].schdulDt,
										billType : checkedItems[i].billType,
										billAmt : checkedItems[i].billAmt,
										billingStus : checkedItems[i].billingStus,
										salesOrdId : checkedItems[i].salesOrdId
								}
								index++;
							}
						}
					}
          
					if(valid){
          
						if(rowList.length > 0){
            
							var chkRow = true;
							for (var i = 0 ; i  < rowList.length ; i++){
              
								var installment = rowList[i].installment;
								for (var j = 0 ; j  < billingScheduleItems.length ; j++){
                  
									if(installment == billingScheduleItems[j].installment){
										chkRow = false;
									}
								}
                
								if(chkRow){
									AUIGrid.addRow(billingscheduleGridId, rowList[i], "first");
								}
                        		
							}
							AUIGrid.setSorting(billingscheduleGridId, sortingInfo);
						}
            
						AUIGrid.removeCheckedRows(billingTargetGridId);
            
					}else{
						Common.alert("<spring:message code='pay.alert.removeLatestOne'/>");
					}
				}
			}
		});
		
		$("#createBills").click(function(){
			
			var allItems = AUIGrid.getGridData(billingTargetGridId);
            if(allItems != undefined && allItems.length > 0){
            	
            	$('#createBillsPop').show();
                $('#invoiceRemark').val("Effective from 1 September 2015, our company no longer gives any retrospective discount for outstanding rental fees which are billed before advance rental payment is received. The discount period for advance rental payment shall begin from the following month upon payment is received.");
			}
        });
		
		$("#btnSave").click(function(){
			var orderId = $("#orderId").val();
	        var remark = $("#remark").val();
	        var invoiceRemark = $("#invoiceRemark").val();
	        var data = {};
	        var billList = AUIGrid.getGridData(billingTargetGridId);
	        
	        if(billList.length > 0) {
	            data.all = billList;
	        }else {
	            return;
	        }
	        
	        data.form = [{"orderId":orderId ,"remark":remark, "invoiceRemark":invoiceRemark}];
	        
	        Common.ajax("POST","/payment/saveCreateBills.do", data, function(result){
	            AUIGrid.clearGridData(billingscheduleGridId);
                AUIGrid.clearGridData(billingTargetGridId);
                fn_createBillsPopClose();
	            Common.alert(result.message);
	        });
	        
	    }); //btnSave end
	});
</script>
<body>
	<form action="" id="billingForm" name="billingForm">
	    <input type="hidden" id="orderId" name="orderId">
		<div id="wrap"><!-- wrap start -->
			<section id="content"><!-- content start -->
				<ul class="path">
				    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
				</ul>
				<aside class="title_line"><!-- title_line start -->
					<p class="fav"><a href="#" class="click_add_on"><spring:message code='pay.text.myMenu'/></a></p>
					<h2>Advance Rental Fees</h2>
				</aside><!-- title_line end -->
				<section class="search_table"><!-- search_table start -->
					<table class="type1"><!-- table start -->
						<caption>table</caption>
						<colgroup>
						    <col style="width:190px" />
						    <col style="width:*" />
						</colgroup>
						<tbody>
							<tr>
							    <th scope="row">Selected Order No.</th>
							    <td>
								    <input type="text"  id="orderNo" name="orderNo" title="" placeholder="" class="readonly" />
								    <p class="btn_sky">
								         <c:if test="${PAGE_AUTH.funcView == 'Y'}">
								         <a href="javascript:fn_orderSearch();" id="search"><spring:message code='sys.btn.search'/></a>
								         </c:if>
								    </p>
							    </td>
							</tr>
						</tbody>
                    </table><!-- table end -->
					<article id="grid_wrap" class="grid_wrap"></article>
				    </section><!-- search_table end -->
					<div class="divine_auto"><!-- divine_auto start -->
						<div style="width:50%;">
							<aside class="title_line"><!-- title_line start -->
							<h3>Billing Schedule</h3>
							</aside><!-- title_line end -->
							
							<div class="border_box" style="height:350px;"><!-- border_box start -->
								<article id="grid_wrap2" class="grid_wrap"></article>
								<ul class="left_btns">
								    <li><p class="btn_blue2"><a href="#" id="btnAddToBillTarget"><spring:message code='pay.btn.addToBillTarget'/></a></p></li>
								</ul>
							</div><!-- border_box end -->
						</div>
						<div style="width:50%;">
							<aside class="title_line"><!-- title_line start -->
							  <h3>Billing Target</h3>
							</aside><!-- title_line end -->
							<div class="border_box" style="height:350px;"><!-- border_box start -->
								<article id="grid_wrap3" class="grid_wrap"></article>
								<ul class="left_btns">
								    <li><p class="btn_blue2"><a href="javascript:void(0);" id="btnRemoveBillTarget"><spring:message code='pay.btn.removeFromBillTarget'/></a></p></li>
								    <c:if test="${PAGE_AUTH.funcChange == 'Y'}">
								    <li><p class="btn_blue2"><a href="javascript:void(0);" id="createBills"><spring:message code='pay.btn.createBills'/></a></p></li>
								    </c:if>
								</ul>
							</div><!-- border_box end -->
						</div>
					</div><!-- divine_auto end -->
			</section><!-- content end -->
			<hr />
		</div><!-- wrap end -->
		<div id="createBillsPop" class="popup_wrap" style="display:none;"><!-- popup_wrap start -->
			<header class="pop_header"><!-- pop_header start -->
				<h1>Advance Bill Remark</h1>
				<ul class="right_opt">
				    <li><p class="btn_blue2"><a href="" onclick="fn_createBillsPopClose();"><spring:message code="newWebInvoice.btn.close" /></a></p></li>
				</ul>
			</header><!-- pop_header end -->
			<section class="pop_body"><!-- pop_body start -->
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
						    <th scope="row">Remark</th>
						    <td colspan="3">
						        <textarea cols="20" rows="5" placeholder="" id="remark"></textarea>
						    </td>
						</tr>
						<tr>
						    <th scope="row">Invoice Remark</th>
						    <td colspan="3">
						        <textarea cols="20" rows="5" placeholder="" id="invoiceRemark">
						        </textarea>
						    </td>
						</tr>
					</tbody>
				</table><!-- table end -->
				<ul class="center_btns">
				    <li><p class="btn_blue2 big"><a href="javascript:void(0);" id="btnSave" onclick=""><spring:message code='sys.btn.save'/></a></p></li>
				</ul>
			</section><!-- pop_body end -->
		</div><!-- popup_wrap end -->
	</form>
</body>