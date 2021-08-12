<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<style type="text/css">
.my-color-red div{
    color:#ff4800;
}

.my-color-green div{
    color:#00bd31;
}

.my-color-pink div{
    color:#f0008d;
}

.my-color-yellow div{
    color:#e6d406;
}

.myLinkStyle{
    text-decoration :underline !important;
}

</style>
<script type="text/javaScript">
var receiveListGrid;
var creditCardGrid;
var payItemGrid;

var gridPros = {
        editable: false,
        showStateColumn: false,
        pageRowCount : 100,
        height:200
};

var gridProsForMultiRows ={
		editable : false,
		showStateColumn:false,
		pageRowCount:100,
		height:200,
		selectionMode : "multipleRows"
};

var receiveColumnLayout=[
                {dataField:"itmId", headerText:" ", visible:false},
                {dataField:"batchId", headerText:" ", visible:false},
                 {
                	colSpan : 2,
			        dataField : "undefined",
			        headerText : " ",
			        width: 40,
			        renderer : 
                    {
                        type : "IconRenderer",
                        iconTableRef :  {
                            "default" : "${pageContext.request.contextPath}/resources/images/common/btn_right2.gif"// default
                        },         
                        iconWidth : 20,
                        iconHeight : 16,
			            onclick : function(rowIndex, columnIndex, value, item) {
			            	//alert(item.itmId);
			            	Common.ajax("GET", "/payment/selectDocItemPaymentItem.do", {"payItemId" : item.itmId}, function(result) {
			            		$("#pay_item_pop").show();
			            		AUIGrid.setGridData(payItemGrid, result);
			            		AUIGrid.resize(payItemGrid, 643, 280);
			                });
			            }
			        }
			       },
			       {
			    	    colSpan : -1,
	                    dataField : "undefined",
	                    headerText : " ",
	                    width: 40,
	                    renderer : 
                        {
                            type : "IconRenderer",
                            iconTableRef :  {
                                "default" : "${pageContext.request.contextPath}/resources/images/common/btn_right2.gif"// default
                            },         
                            iconWidth : 20,
                            iconHeight : 16,
	                        onclick : function(rowIndex, columnIndex, value, item) {
	                            //alert("( " + rowIndex + ", " + columnIndex + " ) " + item.name + " 상세보기 클릭");
	                            
	                            Common.ajax("GET", "/payment/selectLogItemPaymentItem.do", {"payItemId" : item.itmId}, function(result) {
	                               var message = "";
	                               for(var i=0; i<result.length; i++){
		                               message += "<p><b>"+result[i].userName + "(" +result[i].crtDt+")</b>Says : </p><br>";
		                               message += result[i].rem;
	                               }
	                            	$("#listBox_Log").html(message);
	                            });
	                        }
	                    }
	                   },
                  {dataField:"name", headerText:"<spring:message code='pay.head.satatus'/>",
	                	   styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
	                		   if(value == "Incomplete"){
	                               return "my-color-red";
	                		   }else if(value == "Completed"){
	                			   return "my-color-green";
	                		   }else if(value == "Review"){
	                			   return "my-color-pink";
	                		   }else if(value=="Resend"){
	                			   return "my-color-yellow";
	                		   }
	                		   return null;
	                       }
	              },
                  {dataField:"batchNo", headerText:" ",style : "myLinkStyle",
	            	  renderer : {
	                      type : "LinkRenderer",
	                      baseUrl : "javascript", 
	                      jsCallback : function(rowIndex, columnIndex, value, item) {
	                          Common.ajax("GET", "/payment/selectPayDocBatchById.do", {"batchId" : item.batchId}, function(result) {
	                        	  $("#r_batch_view_pop").show();
	                        	  
	                        	  $("#pBatchNo").text(result[0].batchNo);
	                        	  $("#pBatchStatus").text(result[0].name);
	                        	  $("#pCreateDate").text(result[0].crtDt);
	                        	  
	                        	  $("#pPayMode").text(result[0].codeName);
	                        	  $("#pManageStus").text(result[0].stusCodeId);
	                        	  $("#pCreator").text(result[0].creatorname);
	                        	  
	                        	  $("#pIsOnline").text(result[0].codeName ? "Online" : "Offline");
                                  $("#pTotItem").text(result[0].batchTotItm);
                                  $("#pUpdDt").text(result[0].updDt);
                                  
                                  $("#pTotNew").text(result[0].batchTotNw);
                                  $("#pTotResend").text(result[0].batchTotResend);
                                  $("#pUpdator").text(result[0].updUserIdName);
                                  
                                  $("#pTotReview").text(result[0].batchTotReviw);
                                  $("#pTotComplete").text(result[0].batchTotCmplt);
                                  $("#pIncomplete").text(result[0].batchTotIncmpt);
	                          });
	                      }
	                  }
	              },
                  {dataField:"payDt", headerText:"<spring:message code='pay.head.payDate'/>"},
                  {dataField:"isOnline", headerText:"<spring:message code='pay.head.isOnline'/>",
			        renderer:{
			            type : "CheckBoxEditRenderer",
			            showLabel : false,
			            editable : false,
			            checkValue : "1",
			            unCheckValue : "0"
			        }   
                  },
                  {dataField:"oriCcNo", headerText:"<spring:message code='pay.head.crcNo'/>"},
                  {dataField:"amt", headerText:"<spring:message code='pay.head.amount'/>"},
                  {dataField:"mid", headerText:"<spring:message code='pay.head.mid'/>"},
                  {dataField:"codeName1", headerText:"<spring:message code='pay.head.crcType'/>"},
                  {dataField:"ccHolderName", headerText:"<spring:message code='pay.head.crcHolder'/>"},
                  {dataField:"ccExpr", headerText:"<spring:message code='pay.head.crcExpiry'/>"},
                  {dataField:"appvNo", headerText:"<spring:message code='pay.head.appvNo'/>",dataType:"date",formatString:"dd-mm-yyyy"},
                  {dataField:"code2", headerText:"<spring:message code='pay.head.bank'/>"},
                  {dataField:"accCode", headerText:"<spring:message code='pay.head.settlementAcc'/>"},
                  {dataField:"refDt", headerText:"<spring:message code='pay.head.refDate'/>"},
                  {dataField:"", headerText:"<spring:message code='pay.head.refNo'/>"}
           ];
 var creditCardColumnLayout=[
                            {
                                dataField : "undefined",
                                headerText : " ",
                                width : 40,
                                renderer : 
                                {
                                    type : "IconRenderer",
                                    iconTableRef :  {
                                        "default" : "${pageContext.request.contextPath}/resources/images/common/btn_right2.gif"// default
                                    },         
                                    iconWidth : 20,
                                    iconHeight : 16,
                                    onclick : function(rowIndex, columnIndex, value, item) {
                                    	var param = {
                                    			"trxId":item.trxId,
                                    			"payModeId":item.payModeId,
                                    			"isOnline":item.isOnline,
                                    			"oriCcNo":item.oriCcNo,
                                    			"ccTypeId":item.ccTypeId,
                                    			"ccHolderName":item.ccHolderName,
                                    			"ccExpr":item.ccExpr,
                                    			"bankId":item.bankId,
                                    			"refDt":item.refDt,
                                    			"appvNo":item.appvNo,
                                    			"mid":item.mid,
                                    			"brnchId":item.brnchId,
                                    			"refNo":item.refNo
                                    	}
                                    	Common.ajax("GET", "/payment/selectDocItemPaymentItem2.do", param, function(result) {
                                    		   $("#pay_item_pop").show();
                                               AUIGrid.setGridData(payItemGrid, result);
                                               AUIGrid.resize(payItemGrid, 643, 280);
                                    	});
                                    }
                                }
                               },
                               {dataField:"payDt", headerText:"<spring:message code='pay.head.payDate'/>"},
                               {dataField:"isOnline", headerText:"<spring:message code='pay.head.isOnline'/>",
                                   renderer:{
                                       type : "CheckBoxEditRenderer",
                                       showLabel : false,
                                       editable : false,
                                       checkValue : "1",
                                       unCheckValue : "0"
                                   }   
                                 },
                               {dataField:"oriCcNo", headerText:"<spring:message code='pay.head.crcNo'/>"},
                               {dataField:"amt", headerText:"<spring:message code='pay.head.amount'/>"},
                               {dataField:"mid", headerText:"<spring:message code='pay.head.mid'/>"},
                               {dataField:"codeName", headerText:"<spring:message code='pay.head.crcType'/>"},
                               {dataField:"ccHolderName", headerText:"<spring:message code='pay.head.crcHolder'/>",dataType:"date",formatString:"dd-mm-yyyy"},
                               {dataField:"ccExpr", headerText:"<spring:message code='pay.head.crcExpiry'/>"},
                               {dataField:"appvNo", headerText:"<spring:message code='pay.head.appvNo'/>"},
                               {dataField:"code2", headerText:"<spring:message code='pay.head.bank'/>"},
                               {dataField:"accCode", headerText:"<spring:message code='pay.head.settlementAcc'/>"},
                               {dataField:"refDt", headerText:"<spring:message code='pay.head.refDate'/>"},
                               {dataField:"refNo", headerText:"<spring:message code='pay.head.refNo'/>"},
                               {dataField:"trxId", headerText:"", visible:false},
                               {dataField:"payModeId", headerText:"", visible:false},
                               {dataField:"ccTypeId", headerText:"", visible:false},
                               {dataField:"bankId", headerText:"", visible:false},
                               {dataField:"brnchId", headerText:"", visible:false}
                            ];
var payItemColumnLayout=[
								{dataField:"codeName", headerText:"<spring:message code='pay.head.type'/>"},
								{dataField:"orNo", headerText:"<spring:message code='pay.head.receiptNo'/>"},
								{dataField:"c3", headerText:"<spring:message code='pay.head.orderNoMemCode'/>"},
								{dataField:"payItmAmt", headerText:"<spring:message code='pay.head.amount'/>"}
                            ];      
$(document).ready(function(){
	
	receiveListGrid =  GridCommon.createAUIGrid("#grid_wrap_receive_list", receiveColumnLayout, null, gridProsForMultiRows);
	creditCardGrid = GridCommon.createAUIGrid("#grid_wrap_credit_card_list", creditCardColumnLayout, null, gridPros);
	payItemGrid =GridCommon.createAUIGrid("#pay_item_grid", payItemColumnLayout, null, gridPros);
    
    fn_rSearch();
    fn_cSearch();
});

function fn_rSearch(){
	$('#rPaymode').removeAttr('disabled');
    Common.ajax("GET", "/payment/selectReceiveList.do", $("#rSearchForm").serialize(), function(result) {
    	AUIGrid.setGridData(receiveListGrid, result);
    });
    $('#rPaymode').attr('disabled', 'true');
   
    var str = "";
    
    $("#rOnline option:selected").each(function () {   
        str += $(this).text() + "/";   
     });
    
    var message = $("#rPaymode option:selected").text() + ' ( '+ str.substr(0, str.lastIndexOf("/")) +' )';
    $("#rTitle").text(message);
    
}

function fn_cSearch(){
	$('#cPaymode').removeAttr('disabled');
    Common.ajax("GET", "/payment/selectCreditCardList.do", $("#cSearchForm").serialize(), function(result) {
        AUIGrid.setGridData(creditCardGrid, result);
    });
    $('#cPaymode').attr('disabled', 'true');
    
    var str = "";
    
    $("#cOnline option:selected").each(function () {   
        str += $(this).text() + "/";   
     });
    
    var message = $("#cPaymode option:selected").text() + ' ( '+ str.substr(0, str.lastIndexOf("/")) +' )';
    $("#cTitle").text(message);
}

function fn_save(){
	var selectedItems = AUIGrid.getSelectedItems(receiveListGrid);
	if(selectedItems.length > 0){
		$("#savePop").show();
		$("#totalSelectedItem").text(selectedItems.length);
	}else{
		Common.alert("<spring:message code='pay.alert.noItem'/>");
	}
}

function fn_confirmSave(){
	var data = {};
    var selectedItems = AUIGrid.getSelectedItems(receiveListGrid);
    data.checked = selectedItems;
    data.form = [{"remark":$("#pRemark").val(),"statusId":$("#pStatus").val()}];
    Common.ajax("POST", "/payment/saveReceiveList.do", data, function(result) {
    	$("#savePop").hide();
        $("#pRemark").val();
    	Common.alert(result.message);
        $("#listBox_Log").empty();
    });
}
</script>
<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on"><spring:message code='pay.text.myMenu'/></a></p>
<h2>Finance Management</h2>
</aside><!-- title_line end -->
<ul class="right_btns">
        <li><p class="btn_blue"><a href="#">Receive List</a></p></li>
</ul>
<aside class="link_btns_wrap mt20"><!-- link_btns_wrap start -->
<p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
<dl class="link_list">
    <dt>Link</dt>
    <dd>
    <ul class="btns">
        <li><p class="link_btn type2"><a href="/payment/initSubmissionList.do">Submission List</a></p></li>
    </ul>
    <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
    </dd>
</dl>
</aside><!-- link_btns_wrap end -->
<article class="acodi_wrap mt20"><!-- acodi_wrap start -->
<dl>
    <dt class="click_add_on on"><a href="#">Receive List Management</a></dt>
    <dd>
    <ul class="right_btns">
        <li><p class="btn_blue"><a href="javascript:fn_rSearch()"><span class="search"></span><spring:message code='sys.btn.search'/></a></p></li>
        <li><p class="btn_blue"><a href="#"><span class="clear"></span><spring:message code='sys.btn.clear'/></a></p></li>
    </ul>
    <form id="rSearchForm" name="rSearchForm">
    <table class="type1 mt10"><!-- table start -->
    <caption>table</caption>
    <colgroup>
        <col style="width:170px" />
        <col style="width:*" />
        <col style="width:170px" />
        <col style="width:*" />
        <col style="width:160px" />
        <col style="width:*" />
    </colgroup>
    <tbody>
    <tr>
        <th scope="row">Paymode</th>
        <td>
        <select id="rPaymode" name="rPaymode" class="w100p disabled" disabled="disabled">
            <option selected value="107">Credit Card</option>
        </select>
        </td>
        <th scope="row">Is Online</th>
        <td>
        <select id="rOnline" name="rOnline" class="multy_select w100p" multiple="multiple">
            <option value="1">Online</option>
            <option value="0" selected>Offline</option>
        </select>
        </td>
        <th scope="row">Merchant ID</th>
        <td>
        <input id="rMerchantId" name="rMerchantId" type="text" title="" placeholder="Merchant ID" class="w100p" />
        </td>
    </tr>
    <tr>
        <th scope="row">Reference Date</th>
        <td>
        <input id="rRefDt" name="rRefDt" type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p" />
        </td>
        <th scope="row">Credit Card Number</th>
        <td>
        <input id="rCreditCardNo" name="rCreditCardNo" type="text" title="" placeholder="Credit Card Number" class="w100p" />
        </td>
        <th scope="row">Card Holder Name</th>
        <td>
        <input id="rCardHolderName" name="rCardHolderName" type="text" title="" placeholder="Card Holder Name" class="w100p" />
        </td>
    </tr>
    <tr>
        <th scope="row">Approval Number</th>
        <td>
        <input id="rApprovalNo" name="rApprovalNo" type="text" title="" placeholder="Approval Number" class="w100p" />
        </td>
        <th scope="row">Credit Card Type</th>
        <td>
        <select id="rCreditCardType" name="rCreditCardType" class="w100p">
            <option value="" selected>Credit Card Type</option>
            <option value="111">MASTER</option>
            <option value="112">VISA</option>
        </select>
        </td>
        <th scope="row">Issue Bank</th>
        <td>
        <select id="rIssueBank" name="rIssueBank" class="w100p">
            <option value="" selected>Choose One</option>
             <c:forEach var="issueList" items="${issueBank }" varStatus="status">
                <option value="${issueList.codeId }">${issueList.codeName }</option>
             </c:forEach>
        </select>
        </td>
    </tr>
    <tr>
        <th scope="row">Payment Date</th>
        <td colspan="3">

        <div class="date_set"><!-- date_set start -->
        <p><input type="text" id="rPayStartDt" name="rPayStartDt" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
        <span>To</span>
        <p><input type="text" id="rPayEndDt" name="rPayEndDt" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
        </div><!-- date_set end -->

        </td>
        <th scope="row">Key-In Branch</th>
        <td>
        <select id="rBranch" name="rBranch" class="w100p">
            <option value="" selected>Choose One</option>
            <c:forEach var="branch" items="${branchList }" varStatus="status">
                <option value="${branch.codeId }">${branch.codeName }</option>
             </c:forEach>
        </select>
        </td>
    </tr>
    <tr>
        <th scope="row">Batch No</th>
        <td>
        <input type="text" id="rBatchNo" name="rBatchNo" title="" placeholder="Batch No" class="w100p" />
        </td>
        <th scope="row">Batch Status</th>
        <td>
        <select id="rBatchStatus" name="rBatchStatus" class="multy_select w100p" multiple="multiple">
            <option value="1" selected>Active</option>
            <option value="36">Closed</option>
        </select>
        </td>
        <th scope="row">Item Status</th>
        <td>
        <select id="rItemStatus" name="rItemStatus" class="multy_select w100p" multiple="multiple">
            <option value="33" selected>New</option>
            <option value="79" selected>Resend</option>
            <option value="53">Review</option>
            <option value="4">Complete</option>
            <option value="50">Incomplete</option>
        </select>
        </td>
    </tr>
    <tr>
        <th scope="row">Batch Create Date</th>
        <td colspan="3">

        <div class="date_set"><!-- date_set start -->
        <p><input type="text" id="rBatchStartDt" name="rBatchStartDt" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
        <span>To</span>
        <p><input type="text" id="rBatchEndDt" name="rBatchEndDt" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
        </div><!-- date_set end -->

        </td>
        <th scope="row">Batch Creator</th>
        <td>
        <input type="text" id="rBatchCreator" name="rBatchCreator" title="" placeholder="Batch Creator" class="w100p" />
        
        </td>
    </tr>
    <tr>
        <th scope="row">Settlement Account</th>
        <td colspan="5">
        <select id="rSetAccount" name="rSetAccount" class="w100p">
            <option value="" selected>Choose One</option>
            <c:forEach var="crcList" items="${cardComboList }" varStatus="status">
                <option value="${crcList.accID }">${crcList.codeName }</option>
            </c:forEach>
        </select>
        </td>
    </tr>
    </tbody>
    </table><!-- table end -->
</form>
    </dd>
    <!-- ####################################################################################3 -->
    <dt class="click_add_on"><a href="#">Pending List Management</a></dt>
    <dd>
    <ul class="right_btns">
        <li><p class="btn_blue"><a href="javascript:fn_cSearch();"><span class="search"></span><spring:message code='sys.btn.search'/></a></p></li>
        <li><p class="btn_blue"><a href="#"><span class="clear"></span><spring:message code='sys.btn.clear'/></a></p></li>
    </ul>

    <form id="cSearchForm" name="cSearchForm">
    <table class="type1 mt10"><!-- table start -->
    <caption>table</caption>
    <colgroup>
        <col style="width:170px" />
        <col style="width:*" />
        <col style="width:170px" />
        <col style="width:*" />
        <col style="width:160px" />
        <col style="width:*" />
    </colgroup>
    <tbody>
    <tr>
        <th scope="row">Paymode</th>
        <td>
        <select id="cPaymode" name="cPaymode" class="w100p disabled"  disabled="disabled">
            <option value="107">Credit Card</option>
        </select>
        </td>
        <th scope="row">Is Online</th>
        <td>
        <select id="cOnline" name="cOnline" class="multy_select w100p" multiple="multiple">
            <option value="1">Online</option>
            <option value="0" selected>Offline</option>
        </select>
        </td>
        <th scope="row">Merchant ID</th>
        <td>
        <input type="text" id="cMerchantId" name="cMerchantId" title="" placeholder="Merchant ID" class="w100p" />
        </td>
    </tr>
    <tr>
        <th scope="row">Reference Date</th>
        <td>
        <input type="text" id="cRefDt" name="cRefDt" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p" />
        </td>
        <th scope="row">Credit Card Number</th>
        <td>
        <input type="text" id="cCreditCardNo" name="cCreditCardNo" title="" placeholder="Credit Card Number" class="w100p" />
        </td>
        <th scope="row">Card Holder Name</th>
        <td>
        <input type="text" id="cCardHolderName" name="cCardHolderName" title="" placeholder="Card Holder Name" class="w100p" />
        </td>
    </tr>
    <tr>
        <th scope="row">Approval Number</th>
        <td>
        <input type="text" id="cApprovalNo" name="cApprovalNo" title="" placeholder="Approval Number" class="w100p" />
        </td>
        <th scope="row">Credit Card Type</th>
        <td>
        <select id="cCreditCardType" name="cCreditCardType" class="w100p">
            <option value="" selected>Credit Card Type</option>
            <option value="111">MASTER</option>
            <option value="112">VISA</option>
        </select>
        </td>
        <th scope="row">Issue Bank</th>
        <td>
        <select id="cIssueBank" name="cIssueBank" class="w100p">
            <option value="" selected>Choose One</option>
             <c:forEach var="issueList" items="${issueBank }" varStatus="status">
                <option value="${issueList.codeId }">${issueList.codeName }</option>
             </c:forEach>
        </select>
        </td>
    </tr>
    <tr>
        <th scope="row">Payment Date</th>
        <td colspan="3">

        <div class="date_set"><!-- date_set start -->
        <p><input type="text" id="cPayStartDt" name="cPayStartDt" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
        <span>To</span>
        <p><input type="text" id="cPayEndDt" name="cPayEndDt" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
        </div><!-- date_set end -->

        </td>
        <th scope="row">Key-In Branch</th>
        <td>
        <select id="cBranch" name="cBranch" class="w100p">
            <option value="" selected>Choose One</option>
            <c:forEach var="branch" items="${branchList }" varStatus="status">
                <option value="${branch.codeId }" <c:if test="${branch.codeId eq '137' }">selected</c:if>>
                    ${branch.codeName }
                </option>
             </c:forEach>
        </select>
        </td>
    </tr>
    <tr>
        <th scope="row">Settlement Account</th>
        <td colspan="5">
        <select id="cSetAccount" name="cSetAccount">
            <option value="" selected>Choose One</option>
            <c:forEach var="crcList" items="${cardComboList }" varStatus="status">
                <option value="${crcList.accID }">${crcList.codeName }</option>
            </c:forEach>
        </select>
        </td>
    </tr>
    </tbody>
    </table><!-- table end -->
</form>
    </dd>
</dl>
</article><!-- acodi_wrap end -->

<div class="divine_auto mt30"><!-- divine_auto start -->

<div style="width:55%;">

<div class="border_box"><!-- border_box start -->

<aside class="title_line"><!-- title_line start -->
<h3 class="pt0">Receive List - <label id="rTitle" class="pt0"></label> </h3>
</aside><!-- title_line end -->

<article id="grid_wrap_receive_list" class="grid_wrap"><!-- grid_wrap start -->
</article><!-- grid_wrap end -->

<div class="side_btns"><!-- side_btns start -->
<ul class="left_btns">
    <li>New</li>
    <li class="yellow_text">Resend </li>
    <li class="pink_text">Review </li>
    <li class="green_text">Complete </li>
    <li class="orange_text">Incomplete</li>
</ul>
<ul class="right_btns">
    <li>Ctrl + Click : for multiple selection</li>
</ul>

</div><!-- side_btns end -->
<ul class="right_btns">
    <li><p class="btn_grid"><a href="#" id="save" onclick="javascript:fn_save();"><spring:message code='sys.btn.save'/></a></p></li>
</ul>
</div><!-- border_box end -->

</div>

<div style="width:45%;">

<div class="border_box"><!-- border_box start -->

<aside class="title_line"><!-- title_line start -->
<h3 class="pt0">Admin Pending List - <label id="cTitle" class="pt0"></label> </h3>
</aside><!-- title_line end -->

<article id="grid_wrap_credit_card_list" class="grid_wrap"><!-- grid_wrap start -->
</article><!-- grid_wrap end -->

<ul class="right_btns">
    <li>Pending : Waiting for admin management</li>
</ul>

</div><!-- border_box end -->

</div>

</div><!-- divine_auto end -->

<aside class="title_line mt30"><!-- title_line start -->
<h3 class="pt0">Document Control Log</h3>
</aside><!-- title_line end -->
<div id="listBox_Log" class="border_box">
</div>
</section><!-- content end -->

<div id="pay_item_pop" class="popup_wrap size_mid" style="display:none;">
    <header class="pop_header">
        <h1> VIEW PAYMENT ITEM </h1>
        <ul class="right_opt">
            <li><p class="btn_blue2"><a href="#" onclick=""><spring:message code='sys.btn.close'/></a></p></li>
        </ul>
    </header>
    <!-- pop_body start -->
    <section class="pop_body">
		<section id="content"><!-- content start -->
			<article id="pay_item_grid" class="grid_wrap"><!-- grid_wrap start -->
	        </article><!-- grid_wrap end -->
        </section>
    </section>
    <!-- pop_body end -->
</div>
<!-- content end -->

<div id="r_batch_view_pop" class="popup_wrap size_mid" style="display:none;">
    <header class="pop_header">
        <h1> PAYMENT DOCUMENT MANAGEMENT BATCH VIEW </h1>
        <ul class="right_opt">
            <li><p class="btn_blue2"><a href="#" onclick=""><spring:message code='sys.btn.close'/></a></p></li>
        </ul>
    </header>
    <!-- pop_body start -->
    <section class="pop_body">
         <table class="type1 mt10"><!-- table start -->
		    <caption>table</caption>
		    <colgroup>
		        <col style="width:110px" />
		        <col style="width:*" />
		        <col style="width:110px" />
		        <col style="width:*" />
		        <col style="width:110px" />
		        <col style="width:*" />
		    </colgroup>
		    <tbody>
		      <tr>
		          <th>Batch No</th>
		          <td id="pBatchNo"></td>
		          <th>Batch Status</th>
		          <td id="pBatchStatus"></td>
		          <th>Create Date</th>
		          <td id="pCreateDate"></td>
		      </tr>
		      <tr>
                  <th>Payment Mode</th>
                  <td id="pPayMode"></td>
                  <th>Manage Status</th>
                  <td id="pManageStus"></td>
                  <th>Creator</th>
                  <td id="pCreator"></td>
              </tr>
              <tr>
                  <th>Is Online</th>
                  <td id="pIsOnline"></td>
                  <th>Total Item</th>
                  <td id="pTotItem"></td>
                  <th>Updae Date</th>
                  <td id="pUpdDt"></td>
              </tr>
              <tr>
                  <th>Total New</th>
                  <td id="pTotNew"></td>
                  <th>Total Resend</th>
                  <td id="pTotResend"></td>
                  <th>Updaor</th>
                  <td id="pUpdator"></td>
              </tr>
              <tr>
                  <th>Total Review</th>
                  <td id="pTotReview"></td>
                  <th>Total Complete</th>
                  <td id="pTotComplete"></td>
                  <th>Total Incomplete</th>
                  <td id="pIncomplete"></td>
              </tr>
		    </tbody>
		</table>
    </section>
    <!-- pop_body end -->
</div>

<div id="savePop" class="popup_wrap" style="display:none;"><!-- popup_wrap start -->
            <header class="pop_header"><!-- pop_header start -->
                <h1>RECEIVE LIST-SAVE</h1>
                <ul class="right_opt">
                    <li><p class="btn_blue2"><a href="#" onclick=""><spring:message code='sys.btn.close'/></a></p></li>
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
                            <th scope="row">Total Selected</th>
                            <td id="totalSelectedItem">
                            </td>
                        </tr>
                        <tr>
                            <th scope="row">Status</th>
                            <td>
                                <select id="pStatus" name="pStatus">
                                    <option value="4">Complete</option>
                                    <option value="50">Incomplete</option>
                                    <option value="53">Review</option>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row">Remark</th>
                            <td colspan="3">
                                <textarea cols="20" rows="5" placeholder=""  id="pRemark"></textarea>
                            </td>
                        </tr>
                    </tbody>
                </table><!-- table end -->
                <ul class="center_btns">
                    <li><p class="btn_blue2 big"><a href="javascript:fn_confirmSave();" id="btnConfirmResend"><spring:message code='pay.btn.confirmSend'/></a></p></li>
                </ul>
            </section><!-- pop_body end -->
</div><!-- popup_wrap end -->