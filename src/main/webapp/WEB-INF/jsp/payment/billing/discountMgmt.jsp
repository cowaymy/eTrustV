<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<style type="text/css">
.my-custom-up{
    text-align: left;
}
</style>
<script type="text/javaScript">
var discountGridId;
var selectedGridValue;
var gridPros = {
        // 편집 가능 여부 (기본값 : false)
        editable : false,
        
        // 상태 칼럼 사용
        showStateColumn : false
};

// 화면 초기화 함수 (jQuery 의 $(document).ready(function() {}); 과 같은 역할을 합니다.
$(document).ready(function(){
	discountGridId = GridCommon.createAUIGrid("discounGrid_wrap", discountLayout,"",gridPros);
	doGetComboDescription('/common/selectCodeList.do', '74', '','discountType', 'S' , ''); //discount 리스트 조회
	
});

var discountLayout = [ 
                       {
                           dataField : "salesOrdNo",
                           headerText : "<spring:message code='pay.head.orderNo'/>",
                           editable : false
                       }, {
                           dataField : "name",
                           headerText : "<spring:message code='pay.head.customerName'/>",
                           editable : false,
                           width: 300,
                           style : "my-custom-up"
                       }, {
                           dataField : "codeDesc",
                           headerText : "<spring:message code='pay.head.discountType'/>",
                           editable : false,
                           width: 200
                       }, {
                           dataField : "dcAmtPerInstlmt",
                           headerText : "<spring:message code='pay.head.amtPerInstallment'/>",
                           editable : false,
                           width: 200
                       }, {
                           dataField : "discountPeriod",
                           headerText : "<spring:message code='pay.head.discountPeriod'/>",
                           editable : false
                       }, {
                           dataField : "crtUserName",
                           headerText : "<spring:message code='pay.head.createdBy'/>",
                           editable : false
                       }, {
                           dataField : "",
                           headerText : "<spring:message code='pay.head.createdAy'/>",
                           editable : false
                       }, {
                           dataField : "updUserName",
                           headerText : "<spring:message code='pay.head.updatedBy'/>",
                           editable : false
                       }, {
                           dataField : "",
                           headerText : "<spring:message code='pay.head.lastUpdate'/>",
                           editable : false
                       }, {
                           dataField : "name1",
                           headerText : "<spring:message code='pay.head.status'/>",
                           editable : false
                       }, {
                           dataField : "",
                           headerText : "Disable",
                           editable : false,
                           renderer : {
                               type : "ButtonRenderer",
                               labelText : "Disable",
                               onclick : function(rowIndex, columnIndex, value, item) {
                                   if(item.dcStusId != "8"){
                                	   fn_disableDiscount(item.dscntEntryId);
                                   }else{
                                	   Common.alert("<spring:message code='pay.alert.disabledSuccess'/>");
                                   }
                               }
                           }
                       }];
                       
                       
	function fn_orderSearch(){
	    Common.popupDiv("/sales/order/orderSearchPop.do", {callPrgm : "BILLING_DISCOUNT_MGMT", indicator : "SearchTrialNo"});
	}
	
	function fn_orderInfo(ordNo, ordId){
        loadOrderInfo(ordNo, ordId);
    }
    
    function loadOrderInfo(ordNo, ordId){

    	Common.ajax("GET","/payment/selectBasicInfo.do", {"salesOrdId" : ordId}, function(result){
            
            //BASIC INFO
            $('#salesOrdId').val(result.data.basicInfo.ordId);
            $('#orderNo').val(result.data.basicInfo.ordNo);
            $('#custName').val(result.data.basicInfo.custName);
            
            AUIGrid.setGridData(discountGridId, result.data.discountList);
        });
    }
    
    function fn_createEvent(objId, eventType){
        var e = jQuery.Event(eventType);
        $('#'+objId).trigger(e);
    }
    
    function fn_addNewEntry(){
    	var salesOrdId = $('#salesOrdId').val().trim();
    	
    	if(FormUtil.isEmpty(salesOrdId)){
    		Common.alert("<spring:message code='pay.alert.selectOrderFirst'/>");
    		return;
    	}else{
    		
    		Common.ajax("GET","/payment/selectSalesOrderMById.do", {"salesOrdId" : salesOrdId}, function(result){
    			
                console.log(result);
                if(result.data.conversionSchemeId.cnvrSchemeId == 0){
                	
                	$('#addNewEntryPop').show();
                	
                }else{
                	
                	Common.alert("<spring:message code='pay.alert.meagaNotAllow'/>");
                }
            });
    	}
    }
    
    function fn_saveDiscount(){
    	
        var salesOrdId = $('#salesOrdId').val().trim();
        var discountType = $('#discountType').val();
        var startPeriod = $('#startPeriod').val();
        var endPeriod = $('#endPeriod').val();
        var discountAmount = $('#discountAmount').val();
        var remarks = $('#remarks').val().trim();
        var contractId = "";
        
        if(FormUtil.isEmpty(salesOrdId)){
            Common.alert("<spring:message code='pay.alert.selectOrderFirst'/>");
            return;
        }
    	
    	if(discountType == ""){
    		Common.alert("<spring:message code='pay.alert.requiredFieldDisType'/>");
            return;
    	}
    	
    	if(startPeriod == "" || endPeriod == ""){
            Common.alert("<spring:message code='pay.alert.requiredFieldDisPeriod'/>");
            return;
        }
    	
    	if((endPeriod - startPeriod) > 60){
            Common.alert("<spring:message code='pay.alert.cannot60Month'/>");
            return;
        }
    	
    	if(discountAmount == ""){
            Common.alert("<spring:message code='pay.alert.requiredFieldDisAmt'/>");
            return;
        }else{
        	if(discountType == "1251"){
        		
        		if(discountAmount > 0){
        			Common.alert("<spring:message code='pay.alert.mustBeLessThan0'/>");
                    return;
        		}
        		
        	}else{
        		if(discountAmount < 0){
                    Common.alert("<spring:message code='pay.alert.mustNotLessThan0'/>");
                    return;
                }
        	}
        }
    	
    	if(FormUtil.isEmpty(remarks)){
    		Common.alert("<spring:message code='pay.alert.requiredFieldRemarks'/>");
            return;
    	}
    	
    	Common.ajax("GET","/payment/saveDiscount.do", $("#billingForm").serialize(), function(result){
            $('#discountType').val('');
            $('#startPeriod').val('');
            $('#endPeriod').val('');
            $('#discountAmount').val('');
            $('#remarks').val('');
             $('#addNewEntryPop').hide();
            
            //BASIC INFO
            $('#salesOrdId').val(result.data.basicInfo.ordId);
            $('#orderNo').val(result.data.basicInfo.ordNo);
            $('#custName').val(result.data.basicInfo.custName);
            
            AUIGrid.setGridData(discountGridId, result.data.discountList);
        });
    }
    
    function fn_close() {
        $('#addNewEntryPop').hide();
    }
    
    function fn_disableDiscount(dscntEntryId){
    	var salesOrdId = $('#salesOrdId').val();
    	
    	if(dscntEntryId == ""){
    		Common.alert(dscntEntryId);
    	}else{
    		
    		Common.confirm("<spring:message code='pay.alert.saveDisableDiscount'/>",function (){
                Common.ajax("GET","/payment/saveDisableDiscount.do", {"dscntEntryId" : dscntEntryId, "salesOrdId" : salesOrdId}, function(result){
                    
                    //BASIC INFO
                    $('#salesOrdId').val(result.data.basicInfo.ordId);
                    $('#orderNo').val(result.data.basicInfo.ordNo);
                    $('#custName').val(result.data.basicInfo.custName);
                    AUIGrid.setGridData(discountGridId, result.data.discountList);
                    Common.alert(result.data.resultMessage);
                });
            });
    		
    	}
    }
    
    function onlyNumber(event){
        event = event || window.event;
        var keyID = (event.which) ? event.which : event.keyCode;
            if ( (keyID >= 48 && keyID <= 57) || (keyID >= 96 && keyID <= 105) || keyID == 8 || keyID == 46 || keyID == 37 || keyID == 39 || keyID == 110 || keyID == 190){ 
                return;
        }else{
                return false;
        }
    }

</script>
<body>
	<div id="wrap"><!-- wrap start -->
		<section id="content"><!-- content start -->
			<ul class="path">
			        <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
			</ul>
			<aside class="title_line"><!-- title_line start -->
				<p class="fav"><a href="#" class="click_add_on"><spring:message code='pay.text.myMenu'/></a></p>
				<h2>Discount Mgmt</h2>
			</aside><!-- title_line end -->
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
					    <th scope="row">Order Number</th>
					    <td>
					        <input type="text" name="orderNo" id="orderNo" title="" placeholder=""  class="readonly"/>
					         <p class="btn_sky">
                                <a href="javascript:fn_orderSearch();" id="search"><spring:message code='sys.btn.search'/></a>
                            </p>
					     </td>
					     <th scope="row">Customer Name</th>
					     <td colspan="2">
					        <input type="text" name="custName" id="custName" title="" placeholder="" style="width:60%"  class="readonly"/>
					     </td>
					</tr>
				</tbody>
			</table><!-- table end -->
			<section class="search_result">
			        <!-- link_btns_wrap start -->
			            <aside class="link_btns_wrap">
			                <p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
			                <dl class="link_list">
			                    <dt>Link</dt>
			                    <dd>                    
			                    <ul class="btns">
			                        <c:if test="${PAGE_AUTH.funcChange == 'Y'}">
			                        <li><p class="link_btn type2"><a href="javascript:fn_addNewEntry();"><spring:message code='pay.btn.link.addNewEntry'/></a></p></li>
			                        </c:if>
			                    </ul>
			                    <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
			                    </dd>
			                </dl>
			            </aside>
			            <!-- link_btns_wrap end -->
			            <article id="grid_wrap" class="grid_wrap mt10">
			               <div id="discounGrid_wrap" style="width:100%"></div>
			            </article>
			 </section>
		</section><!-- container end -->
		<hr />
	</div><!-- wrap end -->
	<form action="" id="billingForm" name="billingForm">
		<div id="addNewEntryPop" class="popup_wrap size_small" style="display:none"><!-- popup_wrap start -->
			<header class="pop_header"><!-- pop_header start -->
				<h1>Add New Module Unit</h1>
				<ul class="right_opt">
				    <li><p class="btn_blue2"><a href="#" onclick="fn_close();"><spring:message code='sys.btn.close'/></a></p></li>
				</ul>
			</header><!-- pop_header end -->
			<section class="pop_body"><!-- pop_body start -->
			    <table class="type1"><!-- table start -->
			        <caption>table</caption>
			                <colgroup>
			                    <col style="width:165px" />
			                    <col style="width:*" />
			                </colgroup>
			                <tbody>
			                    <tr>
			                        <th scope="row">Discount Type</th>
			                        <td>
			                            <select id="discountType" name="discountType" class="w100p"></select>    
			                        </td>
			                     </tr>
			                     <tr>
			                        <th scope="row">Discount Period</th>
			                        <td>
			                            <div class="date_set w100p">
			                                <p><input id="startPeriod" name="startPeriod" type="text" title="startPeriod" placeholder="" class="w100p" onkeydown='return onlyNumber(event)'/></p>
			                                <span>~</span>
			                                <p><input id="endPeriod" name="endPeriod"  type="text" title="endPeriod" placeholder="" class="w100p" onkeydown='return onlyNumber(event)'/></p>
			                             </div>   
			                        </td>
			                      </tr>
			                      <tr>
			                        <th scope="row">Discount Amount Per Installment</th>
			                        <td>
			                               <input id="discountAmount" name="discountAmount" type="text" title="discountAmount" placeholder="" class="w100p" onkeydown='return onlyNumber(event)'/>
			                        </td>
			                      </tr>
			                      <tr>
			                        <th scope="row">Remarks</th>
			                        <td>
			                                <input id="remarks" name="remarks" type="text" title="remarks" placeholder="" class="w100p"/>
			                        </td>
			                      </tr>
			                </tbody>
			    </table>
			    <ul class="center_btns">
			        <li><p class="btn_grid"><a href="javascript:fn_saveDiscount();"><spring:message code='sys.btn.save'/></a></p></li>
			    </ul>
			</section><!-- pop_body end -->
		</div><!-- popup_wrap end -->
		<input type="hidden" name="salesOrdId" id="salesOrdId">
		<input type="hidden" name="contractId" id="contractId">
		<input type="hidden" name="dscntEntryId" id="dscntEntryId">
	</form>
</body>