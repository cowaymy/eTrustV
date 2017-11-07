<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>

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
            	Common.alert("This billing schedule had been finished. Can not create bill twice.");
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
                           headerText : "Order No",
                           editable : false
                       }, {
                           dataField : "refNo",
                           headerText : "Ref No",
                           editable : false,
                           width: 100,
                       }, {
                           dataField : "salesDt",
                           headerText : "Order Date",
                           editable : false,
                           width: 200
                       }, {
                           dataField : "name",
                           headerText : "Status",
                           editable : false,
                           width: 200
                       }, {
                           dataField : "codeDesc",
                           headerText : "App Type",
                           editable : false
                       }, {
                           dataField : "stkDesc",
                           headerText : "Product",
                           editable : false
                       }, {
                           dataField : "name1",
                           headerText : "Customer",
                           editable : false,
                           width: 200 ,
                           style : "my-custom-up"
                       }, {
                           dataField : "custBillId",
                           headerText : "Bill ID",
                           editable : false
                       }, {
                           dataField : "salesOrdId",//hidden field
                           headerText : "salesOrdId",
                           visible : false
                       },{
                           dataField : "",
                           headerText : "",
                           editable : false,
                           renderer : {
                               type : "ButtonRenderer",
                               labelText : "Select",
                               onclick : function(rowIndex, columnIndex, value, item) {
                            	   fn_billingschedule(item.salesOrdId);
                               }
                           }
                       }];

var billingscheduleLayout = [ 
                       {
                           dataField : "salesOrdNo",
                           headerText : "Order No",
                           editable : false
                       }, {
                           dataField : "installment",
                           headerText : "Installment",
                           editable : false,
                       }, {
                           dataField : "schdulDt",
                           headerText : "Schedule Date",
                           editable : false,
                           width: 100
                       }, {
                           dataField : "billType",
                           headerText : "Type",
                           editable : false,
                           width: 100
                       }, {
                           dataField : "billAmt",
                           headerText : "Amount",
                           editable : false
                       }, {
                           dataField : "billingStus",
                           headerText : "Billing Status",
                           editable : false
                       }, {
                           dataField : "rentInstId",
                           headerText : "rentInstId",
                           editable : false,
                           visible : false
                       },{
                           dataField : "salesOrdId",
                           headerText : "Order Id",
                           editable : false,
                           visible : false
                       }];

var billingTargetLayout = [ 
                             {
                                 dataField : "salesOrdNo",
                                 headerText : "Order No",
                                 editable : false
                             }, {
                                 dataField : "installment",
                                 headerText : "Installment",
                                 editable : false,
                             }, {
                                 dataField : "schdulDt",
                                 headerText : "Schedule Date",
                                 editable : false,
                                 width: 100
                             }, {
                                 dataField : "billType",
                                 headerText : "Type",
                                 editable : false,
                                 width: 100
                             }, {
                                 dataField : "billAmt",
                                 headerText : "Amount",
                                 editable : false
                             }, {
                                 dataField : "billingStus",
                                 headerText : "Billing Status",
                                 editable : false
                             }, {
                                 dataField : "rentInstId",
                                 headerText : "rentInstId",
                                 editable : false,
                                 visible : false
                             },{
                                 dataField : "salesOrdId",
                                 headerText : "Order Id",
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
	        console.log(result);
	        
	        $('#orderId').val(ordId);
	        //$('#orderNo').val(ordNo);
	        AUIGrid.destroy(orderListGridId);
	        orderListGridId = GridCommon.createAUIGrid("grid_wrap", orderListLayout,"",gridPros);
	        AUIGrid.setGridData(orderListGridId, result.data.orderList);
	        
	        AUIGrid.destroy(billingscheduleGridId);
            AUIGrid.destroy(billingTargetGridId);
	        
	    });
	}
	
	function fn_createEvent(objId, eventType){
	    var e = jQuery.Event(eventType);
	    $('#'+objId).trigger(e);
	}
	
	function fn_billingschedule(ordId){
		Common.ajax("GET","/payment/selectRentalBillingSchedule.do", {"salesOrdId" : ordId}, function(result){
            console.log(result);
            
            AUIGrid.destroy(billingscheduleGridId);
            AUIGrid.destroy(billingTargetGridId);
            billingscheduleGridId = GridCommon.createAUIGrid("grid_wrap2", billingscheduleLayout,"",gridPros2);
            billingTargetGridId = GridCommon.createAUIGrid("grid_wrap3", billingTargetLayout,"",gridPros3);
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
	                    AUIGrid.addRow(billingTargetGridId, rowList, "first");
	                    AUIGrid.setSorting(billingTargetGridId, sortingInfo);
	                    AUIGrid.removeCheckedRows(billingscheduleGridId);
	                    
	                }else{
	                    Common.alert("Can not skip the previous unbilled schedules.");
	                }
	            }
			}
	    });
		
		$("#btnRemoveBillTarget").click(function(){
            var checkedItems = AUIGrid.getCheckedRowItemsAll(billingTargetGridId);
            var allItems = AUIGrid.getGridData(billingTargetGridId);
            var valid = true;
            
            if(checkedItems != undefined){
            	
            	if (checkedItems.length > 0){
                    
                    var item = new Object();
                    var rowList = [];
                    for (var i = checkedItems.length-1 ; i >= 0; i--){
                        //alert("allItems[i].installment : "+allItems[allItems.length-1].installment + " checkedItems[i].installment :" + checkedItems[checkedItems.length-1].installment);
                        if(Number(allItems[allItems.length-1].installment) >  Number(checkedItems[checkedItems.length-1].installment)){
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
                        AUIGrid.addRow(billingscheduleGridId, rowList, "first");
                        AUIGrid.removeCheckedRows(billingTargetGridId);
                        AUIGrid.setSorting(billingscheduleGridId, sortingInfo);
                    }else{
                        Common.alert("Remove latest one.");
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
	            console.log(result);
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
				    <li>Manual Billing </li>
		            <li>Advance Rental Fees</li>
				</ul>
				<aside class="title_line"><!-- title_line start -->
					<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
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
								         <a href="javascript:fn_orderSearch();" id="search">Search</a>
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
								    <li><p class="btn_blue2"><a href="#" id="btnAddToBillTarget">Add to Billing Target</a></p></li>
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
								    <li><p class="btn_blue2"><a href="javascript:void(0);" id="btnRemoveBillTarget">Remove From Billing Target</a></p></li>
								    <li><p class="btn_blue2"><a href="javascript:void(0);" id="createBills">Create Bills</a></p></li>
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
			    <li><p class="btn_blue2"><a href="" onclick="fn_createBillsPopClose();">CLOSE</a></p></li>
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
			    <li><p class="btn_blue2 big"><a href="javascript:void(0);" id="btnSave" onclick="">SAVE</a></p></li>
			</ul>
		</section><!-- pop_body end -->
	</div><!-- popup_wrap end -->
	</form>
</body>