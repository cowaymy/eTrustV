<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<style type="text/css">
.my-color-red div{
    color:#ff0000;
}

.my-color-green div{
    color:#0000ff;
}

.my-color-pink div{
    color:#ff087f;
}

.my-color-yellow div{
    color:#ffff00;
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
        pageRowCount : 5,
        height:200
};

var gridProsForMultiRows ={
		editable : false,
		showStateColumn:false,
		pageRowCount:5,
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
			        width: 70,
			        renderer : {
			            type : "ButtonRenderer",
			            labelText : ">",
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
	                    width: 70,
	                    renderer : {
	                        type : "ButtonRenderer",
	                        labelText : "...",
	                        onclick : function(rowIndex, columnIndex, value, item) {
	                            //alert("( " + rowIndex + ", " + columnIndex + " ) " + item.name + " 상세보기 클릭");
	                            alert(item.itmId);
	                            Common.ajax("GET", "/payment/selectLogItemPaymentItem.do", {"payItemId" : item.itmId}, function(result) {
	                               console.log(result);
	                               var message = "";
	                               message += result[0].userName + "(" +result[0].crtDt+")Says : ";
	                               message += result[0].rem;
	                            	$("#listBox_Log").html(message);
	                            });
	                        }
	                    }
	                   },
                  {dataField:"name", headerText:"Status",
	                	   styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
	                		   if(value == "Incomplete"){
	                               return "my-color-red";
	                		   }else if(value == "Complete"){
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
	                          console.log("value : " + value + ", item : " + item.itmId);
	                          Common.ajax("GET", "/payment/selectPayDocBatchById.do", {"batchId" : item.batchId}, function(result) {
	                        	  console.log(result);
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
                  {dataField:"payDt", headerText:"pay Date"},
                  {dataField:"isOnline", headerText:"is Online",
			        renderer:{
			            type : "CheckBoxEditRenderer",
			            showLabel : false,
			            editable : false,
			            checkValue : "1",
			            unCheckValue : "0"
			        }   
                  },
                  {dataField:"oriCcNo", headerText:"Crc No"},
                  {dataField:"amt", headerText:"Amount"},
                  {dataField:"mid", headerText:"MID"},
                  {dataField:"codeName1", headerText:"Crc Type"},
                  {dataField:"ccHolderName", headerText:"Crc Holder"},
                  {dataField:"ccExpr", headerText:"Crc Expiry"},
                  {dataField:"appvNo", headerText:"Appv No",dataType:"date",formatString:"dd-mm-yyyy"},
                  {dataField:"code2", headerText:"Bank"},
                  {dataField:"accCode", headerText:"Settlement Acc"},
                  {dataField:"refDt", headerText:"Ref Date"},
                  {dataField:"", headerText:"Ref No"}
           ];
 var creditCardColumnLayout=[
                            {
                                dataField : "undefined",
                                headerText : " ",
                                width: 70,
                                renderer : {
                                    type : "ButtonRenderer",
                                    labelText : ">",
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
                                    	console.log(param);
                                    	Common.ajax("GET", "/payment/selectDocItemPaymentItem2.do", param, function(result) {
                                    		   console.log(result);
                                    		   $("#pay_item_pop").show();
                                               AUIGrid.setGridData(payItemGrid, result);
                                               AUIGrid.resize(payItemGrid, 643, 280);
                                    	});
                                    }
                                }
                               },
                               {dataField:"payDt", headerText:"Pay Date"},
                               {dataField:"isOnline", headerText:"is Online",
                                   renderer:{
                                       type : "CheckBoxEditRenderer",
                                       showLabel : false,
                                       editable : false,
                                       checkValue : "1",
                                       unCheckValue : "0"
                                   }   
                                 },
                               {dataField:"oriCcNo", headerText:"Crc No"},
                               {dataField:"amt", headerText:"Amount"},
                               {dataField:"mid", headerText:"MID"},
                               {dataField:"codeName", headerText:"Crc Type"},
                               {dataField:"ccHolderName", headerText:"Crc Holder",dataType:"date",formatString:"dd-mm-yyyy"},
                               {dataField:"ccExpr", headerText:"Crc Expiry"},
                               {dataField:"appvNo", headerText:"Appv No"},
                               {dataField:"code2", headerText:"Bank"},
                               {dataField:"accCode", headerText:"Settlement Acc"},
                               {dataField:"refDt", headerText:"Ref Date"},
                               {dataField:"refNo", headerText:"Ref No"},
                               {dataField:"trxId", headerText:"", visible:false},
                               {dataField:"payModeId", headerText:"", visible:false},
                               {dataField:"ccTypeId", headerText:"", visible:false},
                               {dataField:"bankId", headerText:"", visible:false},
                               {dataField:"brnchId", headerText:"", visible:false}
                            ];
var payItemColumnLayout=[
								{dataField:"codeName", headerText:"Type"},
								{dataField:"orNo", headerText:"Receipt No"},
								{dataField:"c3", headerText:"Order No / Member Code"},
								{dataField:"payItmAmt", headerText:"Amount"}
                            ];      
$(document).ready(function(){
	
	receiveListGrid =  GridCommon.createAUIGrid("#grid_wrap_receive_list", receiveColumnLayout, null, gridProsForMultiRows);
	creditCardGrid = GridCommon.createAUIGrid("#grid_wrap_credit_card_list", creditCardColumnLayout, null, gridPros);
	payItemGrid =GridCommon.createAUIGrid("#pay_item_grid", payItemColumnLayout, null, gridPros);
	
	//Issue Bank 조회
	doGetCombo('/sales/customer/selectAccBank.do', '', '', 'rIssueBank', 'S', '')//selCodeAccBankId(Issue Bank)
    doGetCombo('/sales/customer/selectAccBank.do', '', '', 'cIssueBank', 'S', '')//selCodeAccBankId(Issue Bank)
    
    doGetComboSepa('/common/selectBranchCodeList.do', '1' , ' - '  ,'' , 'rBranch' , 'S', ''); //key-in Branch 생성
    doGetComboSepa('/common/selectBranchCodeList.do', '1' , ' - '  ,'137' , 'cBranch' , 'S', ''); //key-in Branch 생성
    
    doGetCombo('/common/getAccountList.do', 'CRC' , ''   , 'rSetAccount' , 'S', '');
    doGetCombo('/common/getAccountList.do', 'CRC' , ''   , 'cSetAccount' , 'S', '');
	 
});

function fn_rSearch(){
	$('#rPaymode').removeAttr('disabled');
    Common.ajax("GET", "/payment/selectReceiveList.do", $("#rSearchForm").serialize(), function(result) {
    	AUIGrid.setGridData(receiveListGrid, result);
    });
    $('#rPaymode').attr('disabled', 'true');
    
}

function fn_cSearch(){
	$('#cPaymode').removeAttr('disabled');
    Common.ajax("GET", "/payment/selectCreditCardList.do", $("#cSearchForm").serialize(), function(result) {
        AUIGrid.setGridData(creditCardGrid, result);
    });
    $('#cPaymode').attr('disabled', 'true');
}

function fn_save(){
	var selectedItems = AUIGrid.getSelectedItems(receiveListGrid);
	console.log(selectedItems);
	Common.ajax("GET", "/payment/saveReceiveList.do", {"selectedItems":selectedItems}, function(result) {
        //AUIGrid.setGridData(creditCardGrid, result);
    });
}
</script>
<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="../images/common/path_home.gif" alt="Home" /></li>
    <li>Sales</li>
    <li>Order list</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>Finance Management</h2>
</aside><!-- title_line end -->


<article class="acodi_wrap"><!-- acodi_wrap start -->
<dl>
    <dt class="click_add_on on"><a href="#">Receive List Management</a></dt>
    <dd>
    <ul class="right_btns">
        <li><p class="btn_blue"><a href="javascript:fn_rSearch()"><span class="search"></span>Search</a></p></li>
        <li><p class="btn_blue"><a href="#"><span class="clear"></span>Clear</a></p></li>
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
        <li><p class="btn_blue"><a href="javascript:fn_cSearch();"><span class="search"></span>Search</a></p></li>
        <li><p class="btn_blue"><a href="#"><span class="clear"></span>Clear</a></p></li>
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
        </select>
        </td>
    </tr>
    <tr>
        <th scope="row">Settlement Account</th>
        <td colspan="5">
        <select id="cSetAccount" name="cSetAccount">
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
<h3 class="pt0">WReceive List - Credit Card (Offline) </h3>
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
    <li><p class="btn_grid"><a href="#" id="save" onclick="javascript:fn_save();">save</a></p></li>
</ul>
</div><!-- border_box end -->

</div>

<div style="width:45%;">

<div class="border_box"><!-- border_box start -->

<aside class="title_line"><!-- title_line start -->
<h3 class="pt0">Credit Card (Online/Offline)</h3>
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
<div id="listBox_Log">
</div>
</section><!-- content end -->

<div id="pay_item_pop" class="popup_wrap size_mid" style="display:none;">
    <header class="pop_header">
        <h1> VIEW PAYMENT ITEM </h1>
        <ul class="right_opt">
            <li><p class="btn_blue2"><a href="#" onclick="">CLOSE</a></p></li>
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
            <li><p class="btn_blue2"><a href="#" onclick="">CLOSE</a></p></li>
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
