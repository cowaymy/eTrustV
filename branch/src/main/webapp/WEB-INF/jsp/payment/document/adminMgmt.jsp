<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<style type="text/css">
.my-custom-up div{
    color:#FF0000;
}
</style>
<script type="text/javaScript">
//AUIGrid 그리드 객체
var watingGridID;
var reviewGridID;
var watingPopGridID;
var reviewPopGridID;

//Grid에서 선택된 RowID
var selectedGridValue;

var gridPros = {
        // 편집 가능 여부 (기본값 : false)
        editable : false,
        
        // 상태 칼럼 사용
        showStateColumn : false,
        
        selectionMode : "multipleRows"

};


$(document).ready(function(){
	
	watingGridID = GridCommon.createAUIGrid("wating_grid_wrap", watingColumnLayout,null,gridPros);
    reviewGridID = GridCommon.createAUIGrid("review_grid_wrap", reviewColumnLayout,null,gridPros);
	
    doGetCombo('/sales/customer/selectAccBank.do', '', '', 'bankWaiting', 'S', '')//selCodeAccBankId(Issue Bank)
    doGetCombo('/sales/customer/selectAccBank.do', '', '', 'bankReview', 'S', '')//selCodeAccBankId(Issue Bank)
    
    doGetCombo('/common/getAccountList.do', 'CRC' , ''   , 'settleAccWaiting' , 'S', '');
    doGetCombo('/common/getAccountList.do', 'CRC' , ''   , 'settleAccReview' , 'S', '');
	
	$("#isOnlineWaiting").multipleSelect("setSelects", [0]);
	$("#isOnlineReview").multipleSelect("checkAll");
    
    fn_watingLoadInfo();
    fn_reviewLoadInfo();
    
});

// AUIGrid 칼럼 설정
var watingColumnLayout = [ 
	{
		   dataField : "",
		   headerText : "",
		   editable : false,
		   width : 50,
		   renderer : 
		   {
			   type : "IconRenderer",
			   iconTableRef :  {
			       "default" : "${pageContext.request.contextPath}/resources/images/common/btn_right.gif"// default
			   },         
			   iconWidth : 20,
			   iconHeight : 16,
			  onclick : function(rowIndex, columnIndex, value, item) {
			      fn_openDivWatingPop(
			    		  item.trxId,
			    		  item.amount,
			    		  item.payModeId,
			    		  item.isOnline,
			    		  item.oriCcNo,
			    		  item.ccTypeId,
			    		  item.ccHolderName,
			    		  item.ccExpr,
			    		  item.bankId,
			    		  item.refDate,
			    		  item.appvNo,
			    		  item.mid,
			    		  item.refNo,
			    		  item.brnchId,
			    		  item.accCode,
			    		  item.payDate
			      );
			  }
		  }
	},
    {
        dataField : "payDate",
        headerText : "<spring:message code='pay.head.payDate'/>",
        editable : false
    }, 
    {
        dataField : "isOnline",
        headerText : "<spring:message code='pay.head.isOnline'/>",
        editable : true,
        visible:true,
        renderer : 
        {
            type : "CheckBoxEditRenderer",
            showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
            editable : true, // 체크박스 편집 활성화 여부(기본값 : false)
            checkValue : 1, // true, false 인 경우가 기본
            unCheckValue : 0,
            checkableFunction  : function(rowIndex, columnIndex, value, isChecked, item, dataField) {

            }
        }
    }, {
        dataField : "oriCcNo",
        headerText : "<spring:message code='pay.head.crcNo'/>",
        editable : false
    }, {
        dataField : "amount",
        headerText : "<spring:message code='pay.head.amount'/>",
        editable : false
    }, {
        dataField : "updDt",
        headerText : "<spring:message code='pay.head.mid'/>",
        editable : false
    }, {
        dataField : "crcType",
        headerText : "<spring:message code='pay.head.crcType'/>",
        editable : false
    }, {
        dataField : "ccHolderName",
        headerText : "<spring:message code='pay.head.crcHolder'/>",
        editable : false
    }, {
        dataField : "ccExpr",
        headerText : "<spring:message code='pay.head.crcExpiry'/>",
        editable : false
    }, {
        dataField : "appvNo",
        headerText : "<spring:message code='pay.head.appvNo'/>",
        editable : false
    },{
        dataField : "bank",
        headerText : "<spring:message code='pay.head.bank'/>",
        editable : false
    },{
        dataField : "accCode",
        headerText : "<spring:message code='pay.head.settlementAcc'/>",
        editable : false
    },{
        dataField : "refDate",
        headerText : "<spring:message code='pay.head.refDate'/>",
        editable : false
    },{
        dataField : "Ref No",
        headerText : "<spring:message code='pay.head.refNo'/>",
        editable : false
    },{
        dataField : "trxId",
        headerText : "<spring:message code='pay.head.trxId'/>",
        editable : false,
        visible : false
    }];

//AUIGrid 칼럼 설정
var reviewColumnLayout = [ 
	{ dataField:"" ,
	    width: 30,
	    headerText:" ", 
	    colSpan : 2,
	   renderer : 
	           {
	          type : "IconRenderer",
	          iconTableRef :  {
	              "default" : "${pageContext.request.contextPath}/resources/images/common/btn_right.gif"// default
	          },         
	          iconWidth : 16,
	          iconHeight : 16,
	         onclick : function(rowIndex, columnIndex, value, item) {
	        	 fn_openDivReviewPop(item.itmId);
	         }
	       }
	},
	{ dataField:"" ,
	    width: 30,
	    headerText:" ", 
	    colSpan : -1,        
	    renderer : 
	           {
	          type : "IconRenderer",
	          iconTableRef :  
	          {
	        	  "default" : "${pageContext.request.contextPath}/resources/images/common/btn_right2.gif"// default
	          },
	          iconWidth : 16, 
	          iconHeight : 16,              
	          onclick : function(rowIndex, columnIndex, value, item) {
	              
	        	  fn_showLogMsg(item.itmId);
	         }
	       }
	},
    {
        dataField : "name",
        headerText : "<spring:message code='pay.head.status'/>",
        editable : false
    },
    {
        dataField : "batchNo",
        headerText : "",
        renderer : {
            type : "LinkRenderer",
            baseUrl : "javascript", 
            jsCallback : function(rowIndex, columnIndex, value, item) {
                console.log("value : " + value + ", item : " + item.itmId);
                
                fn_batchViewlPop(item.batchId);
            }
        }
    }, 
    {
        dataField : "payDt",
        headerText : "<spring:message code='pay.head.payDate'/>",
        editable : false
    }, {
    	dataField : "isOnline",
        headerText : "<spring:message code='pay.head.isOnline'/>",
        editable : true,
        visible:true,
        renderer : 
        {
            type : "CheckBoxEditRenderer",
            showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
            editable : true, // 체크박스 편집 활성화 여부(기본값 : false)
            checkValue : 1, // true, false 인 경우가 기본
            unCheckValue : 0,
            checkableFunction  : function(rowIndex, columnIndex, value, isChecked, item, dataField) {

            }
        }
    }, {
        dataField : "oriCcNo",
        headerText : "<spring:message code='pay.head.crcNo'/>",
        editable : false
    }, {
        dataField : "amt",
        headerText : "<spring:message code='pay.head.amount'/>",
        editable : false
    }, {
        dataField : "mid",
        headerText : "<spring:message code='pay.head.mid'/>",
        editable : false
    },{
        dataField : "c5",
        headerText : "<spring:message code='pay.head.crcType'/>",
        editable : false
    }, {
        dataField : "ccHolderName",
        headerText : "<spring:message code='pay.head.crcHolder'/>",
        editable : false
    }, {
        dataField : "ccExpr",
        headerText : "<spring:message code='pay.head.crcExpiry'/>",
        editable : false
    }, {
        dataField : "appvNo",
        headerText : "<spring:message code='pay.head.appvNo'/>",
        editable : false
    }, {
        dataField : "c2",
        headerText : "<spring:message code='pay.head.bank'/>",
        editable : false
    }, {
        dataField : "c1",
        headerText : "<spring:message code='pay.head.settlementAcc'/>",
        editable : false
    }, {
        dataField : "crtDt",
        headerText : "<spring:message code='pay.head.refDate'/>",
        editable : false
    }, {
        dataField : "",
        headerText : "<spring:message code='pay.head.refNo'/>",
        editable : false
    }];

//AUIGrid 칼럼 설정
var watingPopColumnLayout = [ 
    {
        dataField : "codeName",
        headerText : "<spring:message code='pay.head.type'/>",
        editable : false
    }, {
        dataField : "orNo",
        headerText : "<spring:message code='pay.head.receiptNo'/>",
        editable : false
    }, {
        dataField : "c3",
        headerText : "<spring:message code='pay.head.orderNoMemberCode'/>",
        editable : false
    }, {
        dataField : "c4",
        headerText : "<spring:message code='pay.head.amount'/>",
        dataType: "numeric",
        formatString : "#,##0.00",
        editable : false
    }];

    //wating list 조회.
    function fn_watingLoadInfo(){
    	
    	$('#payModeWaiting').removeAttr('disabled');
        $('#keyBranchWaiting').removeAttr('disabled');
    	Common.ajax("GET","/payment/selectWatingLoadInfo.do",$("#waitingForm").serialize(), function(result){
    		console.log(result);
    		AUIGrid.setGridData(watingGridID, result);
    		
    		var title = "";
            title += $("#payModeWaiting option:checked").text(); + " ";
            var modeText = "";
            
            if($('#payModeWaiting').val() == "107"){
                
                title += "(";
                $("#isOnlineWaiting option:selected").each(function (){
                        
                    if(modeText != "")
                        modeText += "/";
                    modeText += $(this).text();
                        
                }); title += modeText + ")";
                
                $('#waitingListTitle').text("Waiting List - "+title);
            }
    		
    	});
        $('#payModeWaiting').attr('disabled', 'true');
        $('#keyBranchWaiting').attr('disabled', 'true');
    }
    
    //review list 조회
    function fn_reviewLoadInfo(){
    	
    	$('#payModeReview').removeAttr('disabled');
    	$('#keyBranchReview').removeAttr('disabled');
        Common.ajax("GET","/payment/selectReviewLoadInfo.do",$("#reviewForm").serialize(), function(result){
            console.log(result);
            AUIGrid.setGridData(reviewGridID, result);
            
            var title = "";
            title += $("#payModeReview option:checked").text(); + " ";
            var modeText = "";
            
            if($('#payModeReview').val() == "107"){
                
            	title += "(";
            	$("#isOnlineReview option:selected").each(function () { 
            			
            		if(modeText != "")
            			modeText += "/";
            		modeText += $(this).text();
            			
            	}); title += modeText + ")";
            	
            	$('#reviewListTitle').text("Review List - "+title);
            }
            
            $("#logMsgBox").text("No log to display");
        });
        $('#payModeReview').attr('disabled', 'true');
        $('#keyBranchReview').attr('disabled', 'true');
    }
    
    function fn_openDivWatingPop(trxId, amount, payModeId, isOnline, oriCcNo, ccTypeId, ccHolderName, ccExpr, bankId, refDate, appvNo, mid, refNo, brnchId, accCode, payDate){
    		
    		$("#detail_popup_wrap").show();
            
            $("#trxId").val(trxId);
            $("#amount").val(amount);
            $("#payModeId").val(payModeId);
            $("#isOnline").val(isOnline);
            $("#oriCcNo").val(oriCcNo);
            $("#ccTypeId").val(ccTypeId);
            $("#ccHolderName").val(ccHolderName);
            $("#ccExpr").val(ccExpr);
            $("#bankId").val(bankId);
            $("#refDate").val(refDate);
            $("#appvNo").val(appvNo);
            $("#mid").val(mid);
            $("#refNo").val(refNo);
            $("#brnchId").val(brnchId);
            $("#accCode").val(accCode);
            $("#payDate").val(payDate);
            
            Common.ajax("GET","/payment/selectDocItemPayDetailList.do",$("#watingDetailForm").serialize(), function(result){
                
                AUIGrid.destroy(reviewPopGridID);// 그리드 삭제
                AUIGrid.destroy(watingPopGridID);// 그리드 삭제
                watingPopGridID = GridCommon.createAUIGrid("detail_pop_grid_wrap", watingPopColumnLayout,null,gridPros);
                AUIGrid.setGridData(watingPopGridID, result);
                
            });
    }
    
    function fn_openDivReviewPop(itemId){
        
        $("#detail_popup_wrap").show();
        $("#itemId").val(itemId);
        
        Common.ajax("GET","/payment/selectDocItemPayReviewDetailList.do",$("#reviewDetailForm").serialize(), function(result){
            
        	AUIGrid.destroy(reviewPopGridID);
            AUIGrid.destroy(watingPopGridID);
            reviewPopGridID = GridCommon.createAUIGrid("detail_pop_grid_wrap", watingPopColumnLayout,null,gridPros);
            AUIGrid.setGridData(reviewPopGridID, result);
        });
    }
    
    function fn_openDivSendPop(){
    	
    	var selectedItems = AUIGrid.getSelectedItems(watingGridID);
    	
    	if(selectedItems.length > 0) {
    		$("#sendWatingPop_wrap").show();
    		var totalAmount = 0;
    		
    		for(i=0; i < selectedItems.length; i++) {
                rowInfoObj = selectedItems[i];
                rowItem = rowInfoObj.item;
                totalAmount += rowItem.amount;
            }
    		
    		$("#totalSelectedWating").text(selectedItems.length);
    		$("#totalAmountWating").text(totalAmount);
    	}else{
    		Common.alert("<spring:message code='pay.alert.noItem'/>");
    	}
    }
    
    function fn_confirmSendWating(){
    	
    	var data = {};
    	var selectedItem = AUIGrid.getSelectedItems(watingGridID);
        data.checked = selectedItem;
        data.form = [{"remark":$("#remarkWaiting").val()}];
    	console.log(data);
    	Common.ajax("POST","/payment/saveConfirmSendWating.do", data, function(result){
            console.log(result);
            
            $("#sendWatingPop_wrap").hide();
            $("#remarkWaiting").val("");
            $("#totalSelectedWating").text('');
            $("#totalAmountWating").text('');
            Common.alert(result.message);
        });
    }
    
    function fn_openDivResendPop(){
        
        var selectedItems = AUIGrid.getSelectedItems(reviewGridID);
        
        if(selectedItems.length > 0) {
            $("#sendReviewPop_wrap").show();
            
            $("#totalSelectedReview").text(selectedItems.length);
        }else{
            Common.alert("<spring:message code='pay.alert.noItem'/>");
        }
    }
    
    function fn_confirmResendReview(){
        
        var data = {};
        var selectedItem = AUIGrid.getSelectedItems(reviewGridID);
        data.checked = selectedItem;
        data.form = [{"remark":$("#remarkReview").val()}];
        Common.ajax("POST","/payment/saveConfirmResendReview.do", data, function(result){
            
            $("#sendReviewPop_wrap").hide();
            $("#remarkReview").val("");
            $("#totalSelectedReview").text('');
            Common.alert(result.message);
        });
    }
    
    function fn_showLogMsg(itmId){
    	
    	Common.ajax("GET","/payment/selectLoadItemLog.do",  {"itemId":itmId}, function(result){
            
            var msg = "";
            for (var key in result) {
                
                msg = "<b>"+result[key].c1 + " ( " +result[key].crtDt + " )</b> says :"+"<br>";
                
                if(result[key].rem != null){
                    msg += result[key].rem +"<br>";
                }else{
                    msg += ""+"<br>" ;
                }
            }
            
            $("#logMsgBox").html(msg);
        });
    }
    
    function fn_batchViewlPop(batchId){
    	
    	$("#batch_view_popup_wrap").show();
    
    	Common.ajax("GET","/payment/selectPaymentDocMs.do",  {"batchId":batchId}, function(result){
    		console.log(result);
    		
    		$("#tdBatchNo").text(result.batchNo);
    		$("#tdBatchStatus").text(result.name);
    		$("#tdCreateDate").text(result.crtDt);
    		$("#tdPaymentMode").text(result.codeName);
    		$("#tdManageStatus").text(result.batchNo);
    		$("#tdCreator").text(result.c2);
    		$("#tdIsOnline").text(result.batchPayIsOnline ? "Online" : "Offline");
    		$("#tdTotalItem").text(result.batchTotItm);
    		$("#tdUpdateDate").text(result.updDt);
    		$("#tdTotalNew").text(result.batchTotNw);
    		$("#tdTotalResend").text(result.batchTotResend);
    		$("#tdUpdator").text(result.c3);
    		$("#tdTotalReview").text(result.batchTotReviw);
    		$("#tdTotalComplete").text(result.batchTotCmplt);
    		$("#tdTotalIncomplete").text(result.batchTotIncmpt);
    	});
    }
    
    function fn_hideViewPop(val){
        $(val).hide();
        
        $("#tdBatchNo").text('');
        $("#tdBatchStatus").text('');
        $("#tdCreateDate").text('');
        $("#tdPaymentMode").text('');
        $("#tdManageStatus").text('');
        $("#tdCreator").text('');
        $("#tdIsOnline").text('');
        $("#tdTotalItem").text('');
        $("#tdUpdateDate").text('');
        $("#tdTotalNew").text('');
        $("#tdTotalResend").text('');
        $("#tdUpdator").text('');
        $("#tdTotalReview").text('');
        $("#tdTotalComplete").text('');
        $("#tdTotalIncomplete").text('');
        
    }
    
    function fn_waitingSendPopClose(val){
        $(val).hide();
        $("#totalSelectedWating").text('');
        $("#totalAmountWating").text('');
        $("#remarkWaiting").val('');
    }
    
    function fn_reviewSendPopClose(val){
        $(val).hide();
        $("#totalSelectedReview").text('');
        $("#remarkReview").val('');
    }
    
    function fn_viewPayPopClose(val){
        $(val).hide();
        AUIGrid.clearGridData(reviewPopGridID);  //grid data clear
        AUIGrid.clearGridData(watingPopGridID);  //grid data clear
    }
   
</script>
<!-- content start -->
<section id="content"><!-- content start -->
	<ul class="path">
	    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
	</ul>
	<aside class="title_line"><!-- title_line start -->
		<p class="fav"><a href="#" class="click_add_on"><spring:message code='pay.text.myMenu'/></a></p>
		<h2>Admin Management</h2>
	</aside><!-- title_line end -->
	
	<article class="acodi_wrap"><!-- acodi_wrap start -->
		<dl>
		    <dt class="click_add_on on"><a href="#" id="watingList">>> Waiting List Management</a></dt>
		    <dd>
		    <ul class="right_btns">
		        <li><p class="btn_blue"><a href="javascript:fn_watingLoadInfo();"><span class="search"></span><spring:message code='sys.btn.search'/></a></p></li>
		        <li><p class="btn_blue"><a href="#"><span class="clear"></span><spring:message code='sys.btn.clear'/></a></p></li>
		    </ul>
		    <form name="waitingForm" id="waitingForm"  method="post">
			    <table class="type1 mt10"><!-- table start -->
				    <caption>table</caption>
				    <colgroup>
				        <col style="width:150px" />
				        <col style="width:*" />
				        <col style="width:150px" />
				        <col style="width:*" />
				        <col style="width:130px" />
				        <col style="width:*" />
				    </colgroup>
				    <tbody>
					    <tr>
					        <th scope="row">Paymode</th>
					        <td>
					        <select class="w100p disabled" id="payModeWaiting" name="payModeWaiting" disabled="disabled">
					            <option value="107">Credit Card</option>
					        </select>
					        </td>
					        <th scope="row">Is Online</th>
					        <td>
					        <select class="multy_select w100p" multiple="multiple" id="isOnlineWaiting" name="isOnlineWaiting">
					            <option value="1">Online</option>
					            <option value="0">Offline</option>
					        </select>
					        </td>
					        <th scope="row">Merchant ID</th>
					        <td>
					        <input type="text" title="" placeholder="Merchant ID" class="w100p" id="merchantIdWaiting" name="merchantIdWaiting" />
					        </td>
					    </tr>
					    <tr>
					        <th scope="row">Reference Date</th>
					        <td>
					        <input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p" id="refDateWaiting" name="refDateWaiting" />
					        </td>
					        <th scope="row">Credit Card Number</th>
					        <td>
					        <input type="text" title="" placeholder="Credit Card Number" class="w100p" id="crcNoWaiting" name="crcNoWaiting" />
					        </td>
					        <th scope="row">Card Holder Name</th>
					        <td>
					        <input type="text" title="" placeholder="Card Holder Name" class="w100p" id="holderNameWaiting" name="holderNameWaiting" />
					        </td>
					    </tr>
					    <tr>
					        <th scope="row">Approval Number</th>
					        <td>
					        <input type="text" title="" placeholder="Approval Number" class="w100p" id="appNoWaiting" name="appNoWaiting" />
					        </td>
					        <th scope="row">Credit Card Type</th>
					        <td>
					        <select class="w100p" id="crcTypeWaiting" name="crcTypeWaiting">
					            <option value="">Choose One</option>
					            <option value="111">MASTER</option>
					            <option value="112">VISA</option>
					        </select>
					        </td>
					        <th scope="row">Issue Bank</th>
					        <td>
					        <select class="w100p" id="bankWaiting" name="bankWaiting">
					        </select>
					        </td>
					    </tr>
					    <tr>
					        <th scope="row">Payment Date</th>
					        <td colspan="3">
					        
					        <div class="date_set"><!-- date_set start -->
					        <p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" id="payDateFrWaiting" name="payDateFrWaiting" /></p>
					        <span>To</span>
					        <p><input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" id="payDateToWaiting" name="payDateToWaiting" /></p>
					        </div><!-- date_set end -->
					
					        </td>
					        <th scope="row">Key-In Branch</th>
					        <td>
					           <select class="w100p disabled"  id="keyBranchWaiting" name="keyBranchWaiting">
					               <c:forEach var="list" items="${codeList }">
						               <c:if test="${list.codeId eq userBranchId}">
	                                    <option value="${list.codeId}" >${list.codeName}</option>
	                                   </c:if>
                                   </c:forEach>
					           </select>
					        </td>
					    </tr>
					    <tr>
					        <th scope="row">Settlement Account</th>
					        <td colspan="5">
						        <select class="" id="settleAccWaiting" name="settleAccWaiting"></select>
					        </td>
					    </tr>
				    </tbody>
			    </table><!-- table end -->
		    </form>
		    </dd>
		    <dt class="click_add_on"><a href="#">>> Review List Management</a></dt>
		    <dd>
		    <ul class="right_btns">
		        <li><p class="btn_blue"><a href="javascript:fn_reviewLoadInfo();"><span class="search"></span><spring:message code='sys.btn.search'/></a></p></li>
		        <li><p class="btn_blue"><a href="#"><span class="clear"></span><spring:message code='sys.btn.clear'/></a></p></li>
		    </ul>
		    <form name="reviewForm" id="reviewForm"  method="post">
			    <table class="type1 mt10"><!-- table start -->
				    <caption>table</caption>
				    <colgroup>
				        <col style="width:150px" />
				        <col style="width:*" />
				        <col style="width:150px" />
				        <col style="width:*" />
				        <col style="width:130px" />
				        <col style="width:*" />
				    </colgroup>
				    <tbody>
					    <tr>
					        <th scope="row">Paymode</th>
					        <td>
						        <select class="w100p disabled" id="payModeReview"  name="payModeReview" disabled="disabled">
						            <option value="107">Credit Card</option>
						        </select>
					        </td>
					        <th scope="row">Is Online</th>
					        <td>
						        <select class="multy_select w100p" multiple="multiple" id="isOnlineReview" name="isOnlineReview">
						            <option value="1">Online</option>
						            <option value="0">Offline</option>
						        </select>
					        </td>
					        <th scope="row">Merchant ID</th>
					        <td>
					            <input type="text" title="" placeholder="Merchant ID" class="w100p" id="merchantIdReview" name="merchantIdReview" />
					        </td>
					    </tr>
					    <tr>
					        <th scope="row">Reference Date</th>
					        <td>
					            <input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p" id="refDateReview" name="refDateReview" />
					        </td>
					        <th scope="row">Credit Card Number</th>
					        <td>
					            <input type="text" title="" placeholder="Credit Card Number" class="w100p" id="crcNoReview" name="crcNoReview" />
					        </td>
					        <th scope="row">Card Holder Name</th>
					        <td>
					            <input type="text" title="" placeholder="Card Holder Name" class="w100p" id="holderNameReview" name="holderNameReview" />
					        </td>
					    </tr>
					    <tr>
					        <th scope="row">Approval Number</th>
					        <td>
					        <input type="text" title="" placeholder="Approval Number" class="w100p" id="appNoReview" name="appNoReview" />
					        </td>
					        <th scope="row">Credit Card Type</th>
					        <td>
					        <select class="w100p" id="crcTypeReview" name="crcTypeReview">
					            <option value="">Choose One</option>
					            <option value="111">MASTER</option>
					            <option value="112">VISA</option>
					        </select>
					        </td>
					        <th scope="row">Issue Bank</th>
					        <td>
					            <select class="w100p" id="bankReview" name="bankReview"></select>
					        </td>
					    </tr>
					    <tr>
					        <th scope="row">Payment Date</th>
					        <td colspan="3">
						        <div class="date_set"><!-- date_set start -->
							        <p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" id="payDateFrReview" name="payDateFrReview" /></p>
							        <span>To</span>
							        <p><input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" id="payDateToReview" name="payDateToReview" /></p>
						        </div><!-- date_set end -->
					        </td>
					        <th scope="row">Key-In Branch</th>
					        <td>
					            <select class="w100p disabled"  id="keyBranchReview" name="keyBranchReview">
					               <c:forEach var="list" items="${codeList }">
                                       <c:if test="${list.codeId eq userBranchId}">
                                        <option value="${list.codeId}" >${list.codeName}</option>
                                       </c:if>
                                   </c:forEach>
					            </select>
					        </td>
					    </tr>
					    <tr>
					        <th scope="row">Batch No</th>
					        <td>
					            <input type="text" title="" placeholder="Batch Number" class="w100p" id="batchNoReview" name="batchNoReview" />
					        </td>
					        <th scope="row">Batch Create Date</th>
					        <td>
						        <div class="date_set"><!-- date_set start -->
							        <p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" id="batchCreDateFrReview" name="batchCreDateFrReview" /></p>
							        <span>To</span>
							        <p><input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" id="batchCreDateToReview" name="batchCreDateToReview" /></p>
						        </div><!-- date_set end -->
					        </td>
					        <th scope="row">Batch Creator</th>
					        <td>
					            <input type="text" title="" placeholder="Batch Creator(UserName)" class="w100p" id="batchCreatorReview" name="batchCreatorReview"/>
					        </td>
					    </tr>
					    <tr>
					        <th scope="row">Settlement Account</th>
					        <td colspan="5">
					            <select class="" id="settleAccReview" name="settleAccReview"></select>
					        </td>
					    </tr>
				    </tbody>
			    </table><!-- table end -->
			  </form>  
		    </dd>
		</dl>
	</article><!-- acodi_wrap end -->
	<div class="divine_auto mt30"><!-- divine_auto start -->
		<div style="width:50%;">
			<div class="border_box"><!-- border_box start -->
				<aside class="title_line"><!-- title_line start -->
				    <h3 class="pt0" id="waitingListTitle"></h3>
				</aside><!-- title_line end -->
				<ul class="right_btns">
				    <li>Ctrl + Click : for multiple selection</li>
				</ul>
				<article class="grid_wrap" id="wating_grid_wrap"><!-- grid_wrap start --></article><!-- grid_wrap end -->
				<ul class="right_btns">
                    <li><p class="btn_blue2"><a href="javascript:fn_openDivSendPop();" id="btnSendWating">Send</a></p></li>
                </ul>
			</div><!-- border_box end -->
		</div>
		<div style="width:50%;">
			<div class="border_box"><!-- border_box start -->
				<aside class="title_line"><!-- title_line start -->
				    <h3 class="pt0" id="reviewListTitle"></h3>
				</aside><!-- title_line end -->
				<ul class="right_btns">
				    <li>Ctrl + Click : for multiple selection</li>
				</ul>
				<article class="grid_wrap" id="review_grid_wrap"><!-- grid_wrap start --></article><!-- grid_wrap end -->
				<ul class="right_btns">
                    <li><p class="btn_blue2"><a href="javascript:fn_openDivResendPop();" id="btnConfirmSend_Review">Resend</a></p></li>
                </ul>
			</div><!-- border_box end -->
		</div>
	</div><!-- divine_auto end -->
	<aside class="title_line mt30"><!-- title_line start -->
	   <h3 class="pt0">Document Control Log</h3>
	</aside><!-- title_line end -->
	<article class="grid_wrap" id="logMsgBox"><!-- grid_wrap start -->No log to display</article><!-- grid_wrap end -->
</section><!-- content end -->
<div id="detail_popup_wrap" class="popup_wrap" style="display:none;">
        <!-- popup_wrap start -->
        <header class="pop_header">
            <!-- pop_header start -->
            <h1>View Payment Item</h1>
            <ul class="right_opt">
                <li><p class="btn_blue2"><a href="#" onclick="fn_viewPayPopClose('#detail_popup_wrap');">CLOSE</a></p></li>
            </ul>
        </header>
        <!-- pop_header end -->
        
        <!-- pop_body start -->
        <section class="pop_body">
            <!-- search_result start -->
            <section class="search_result">
                <article class="grid_wrap"  id="detail_pop_grid_wrap"></article>
            </section>
            <!-- search_result end -->
        </section>
        <!-- pop_body end -->
        <form name="watingDetailForm" id="watingDetailForm"  method="post">
            <input type="hidden" id="trxId" name="trxId">
            <input type="hidden" id="amount" name="amount">
            <input type="hidden" id="payModeId" name="payModeId">
            <input type="hidden" id="isOnline" name="isOnline">
            <input type="hidden" id="oriCcNo" name="oriCcNo">
            <input type="hidden" id="ccTypeId" name="ccTypeId">
            <input type="hidden" id="ccHolderName" name="ccHolderName">
            <input type="hidden" id="ccExpr" name="ccExpr">
            <input type="hidden" id="bankId" name="bankId">
            <input type="hidden" id="refDate" name="refDate">
            <input type="hidden" id="appvNo" name="appvNo">
            <input type="hidden" id="mid" name="mid">
            <input type="hidden" id="refNo" name="refNo">
            <input type="hidden" id="brnchId" name="brnchId">
            <input type="hidden" id="accCode" name="accCode">
            <input type="hidden" id="payDate" name="payDate">
        </form>
        <form name="reviewDetailForm" id="reviewDetailForm"  method="post">
            <input type="hidden" id="itemId" name="itemId">
        </form>
</div>
<div id="sendWatingPop_wrap" class="popup_wrap" style="display:none;"><!-- popup_wrap start -->
            <header class="pop_header"><!-- pop_header start -->
                <h1>Wating List - Send</h1>
                <ul class="right_opt">
                    <li><p class="btn_blue2"><a href="#" onclick="fn_waitingSendPopClose('#sendWatingPop_wrap');"><spring:message code='sys.btn.close'/></a></p></li>
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
                            <td id="totalSelectedWating">
                            </td>
                            <th scope="row">Total Amount</th>
                            <td id="totalAmountWating">
                            </td>
                        </tr>
                        <tr>
                            <th scope="row">Remark</th>
                            <td colspan="3">
                                <textarea cols="20" rows="5" placeholder=""  id="remarkWaiting"></textarea>
                            </td>
                        </tr>
                    </tbody>
                </table><!-- table end -->
                <ul class="center_btns">
                    <li><p class="btn_blue2 big"><a href="javascript:fn_confirmSendWating();" id="btnConfirmSend"><spring:message code='pay.btn.confirmSend'/></a></p></li>
                </ul>
            </section><!-- pop_body end -->
</div><!-- popup_wrap end -->
<div id="sendReviewPop_wrap" class="popup_wrap" style="display:none;"><!-- popup_wrap start -->
            <header class="pop_header"><!-- pop_header start -->
                <h1>Review List - Resend</h1>
                <ul class="right_opt">
                    <li><p class="btn_blue2"><a href="#" onclick="fn_reviewSendPopClose('#sendReviewPop_wrap');"><spring:message code='sys.btn.close'/></a></p></li>
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
                            <td id="totalSelectedReview" colspan="3">
                            </td>
                        </tr>
                        <tr>
                            <th scope="row">Remark</th>
                            <td colspan="3">
                                <textarea cols="20" rows="5" placeholder=""  id="remarkReview"></textarea>
                            </td>
                        </tr>
                    </tbody>
                </table><!-- table end -->
                <ul class="center_btns">
                    <li><p class="btn_blue2 big"><a href="javascript:fn_confirmResendReview();" id="btnConfirmResend"><spring:message code='pay.btn.confirmSend'/></a></p></li>
                </ul>
            </section><!-- pop_body end -->
</div><!-- popup_wrap end -->
<div id="batch_view_popup_wrap" class="popup_wrap" style="display:none;">
    <header class="pop_header">
        <h1>Payment Document Management Batch View</h1>
        <ul class="right_opt">
            <li><p class="btn_blue2"><a href="#" onclick="fn_hideViewPop('#batch_view_popup_wrap');"><spring:message code='sys.btn.close'/></a></p></li>
        </ul>
    </header>
    <!-- pop_body start -->
    <section class="pop_body">
	    <table class="type1">
	        <colgroup>
	            <col style="width:165px" />
	            <col style="width:*" />
	        </colgroup>
	        <tbody>
		        <tr>
		            <th>Batch No</th>
		            <td id="tdBatchNo"></td>
		            <th>Batch Status</th>
		            <td id="tdBatchStatus"></td>
		            <th>Create Date</th>
		            <td id="tdCreateDate"></td>
		        </tr>
		        <tr>
		            <th>Payment Mode</th>
		            <td id="tdPaymentMode"></td>
		            <th>Manage Status</th>
		            <td id="tdManageStatus"></td>
		            <th>Creator</th>
		            <td id="tdCreator"></td>
		        </tr>
		        <tr>
		            <th>Is Online</th>
		            <td id="tdIsOnline"></td>
		            <th>Total Item</th>
		            <td id="tdTotalItem"></td>
		            <th>Update Date</th>
		            <td id="tdUpdateDate"></td>
		        </tr>
		        <tr>
		            <th>Total New</th>
		            <td id="tdTotalNew"></td>
		            <th>Total Resend</th>
		            <td id="tdTotalResend"></td>
		            <th>Updator</th>
		            <td id="tdUpdator"></td>
		        </tr>
		        <tr>
		            <th>Total Review</th>
		            <td id="tdTotalReview"></td>
		            <th>Total Complete</th>
		            <td id="tdTotalComplete"></td>
		            <th>Total Incomplete</th>
		            <td id="tdTotalIncomplete"></td>
		        </tr>
	        </tbody>
	    </table>
    </section>
    <!-- pop_body end -->
</div>
