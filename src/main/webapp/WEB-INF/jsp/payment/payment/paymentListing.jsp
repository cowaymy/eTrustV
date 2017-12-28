<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
    
<script type="text/javaScript">

//Combo Data
var paymentTypeData = [{"codeId": "1","codeName": "All Payment"}, {"codeId": "2","codeName": "Selected Payment"}];
var paymentItemData = [{"codeId": "239","codeName": "Order Payment"},
			                       {"codeId": "104","codeName": "Trial Fees Payment"},
			                       {"codeId": "222","codeName": "HP Payment"},
			                       {"codeId": "102","codeName": "Training Payment"},
			                       {"codeId": "223","codeName": "Membership Payment"},
			                       {"codeId": "238","codeName": "AS Bill Payment"},
			                       {"codeId": "577","codeName": "POS Payment"},
			                       {"codeId": "101","codeName": "Reverse Payment"},
			                       {"codeId": "1308","codeName": "Rental Membership Payment"}
                                   ];
var batchTypeData = [{"codeId": "Payment","codeName": "Batch Payment"}, {"codeId": "Refund","codeName": "Batch Refund"}];

// 화면 초기화 함수 (jQuery 의 $(document).ready(function() {}); 과 같은 역할을 합니다.
$(document).ready(function(){
	
	//조회 조건 세팅 
	$('#payDate1').val($.datepicker.formatDate('dd/mm/yy', new Date()));
	$('#payDate2').val($.datepicker.formatDate('dd/mm/yy', new Date()));
	
	//Combo 생성
    doGetComboSepa('/common/selectBranchCodeList.do', '1' , ' - ' , '','branchId', 'S' , '');
    doDefCombo(paymentTypeData, '' ,'paymentType', 'S', '');
    //doDefCombo(paymentItemData, '' ,'paymentItem', 'A', '');  
    doDefCombo(batchTypeData, '' ,'batchType', 'S', '');    
	
    //Branch Combo 변경시 User Combo 생성
    $('#branchId').change(function (){
        doGetCombo('/common/getUsersByBranch.do', $(this).val() , ''   , 'userId' , 'S', '');
    });
    
    //Branch Combo 변경시 User Combo 생성
    $('#paymentType').change(function (){
    	if($(this).val() == "1"){
    	    $('#paymentItem').val('');
            $('#paymentItem').attr("disabled",true); 
        }else{
        	$('#paymentItem').val('');
            $('#paymentItem').attr("disabled",false); 
        }
    });
   
});

function fn_genDocument(docVal){
	
	if(FormUtil.checkReqValue($('#payDate1')) || FormUtil.checkReqValue($('#payDate2'))){
		Common.alert("<spring:message code='pay.alert.payDateFromTo'/>");
		return;
	}
	
	if(FormUtil.checkReqValue($("#branchId option:selected")) ){
        Common.alert("<spring:message code='pay.alert.selectBranch'/>");
        return;
    }
	
	if(!FormUtil.checkReqValue($("#receiptNoFr")) || !FormUtil.checkReqValue($("#receiptNoTo"))){
		if(FormUtil.checkReqValue($("#receiptNoFr")) || FormUtil.checkReqValue($("#receiptNoTo"))){
		    Common.alert("<spring:message code='pay.alert.receiptNoFromTo'/>");
		    return;
		}
    }
	
   if(!FormUtil.checkReqValue($("#trNoFr")) || !FormUtil.checkReqValue($("#trNoTo"))){
        if(FormUtil.checkReqValue($("#trNoFr")) || FormUtil.checkReqValue($("#trNoTo"))){
            Common.alert("<spring:message code='pay.alert.trNoFromTo'/>");
            return;
        }
    }
	
   
   $('#docVal').val(docVal);
   $('#branchName').val($("#branchId option:selected").text());
   $('#userNm').val($("#userId option:selected").text());
   
   Common.ajax("POST", "/payment/generateReportParam.do", $('#searchForm').serializeJSON(), function(result) {
	   
	   var option = {
               isProcedure : true,
       };
	   
	   if(result.data.docVal == 'EXCEL'){
		   $("#reportExcelForm #V_WHERESQL").val(result.data.whereSQL);   
		   Common.report("reportExcelForm", option);    
		   
	   }else if(result.data.docVal == 'PDF'){
		   $("#reportPDFForm #V_WHERESQL").val(result.data.whereSQL);		   
		   $("#reportPDFForm #V_SHOWPAYMENTDATE").val(result.data.showPaymentDate);
		   $("#reportPDFForm #V_SHOWKEYINBRANCH").val(result.data.showKeyInBranch);
		   $("#reportPDFForm #V_SHOWRECEIPTNO").val(result.data.showReceiptNo);
		   $("#reportPDFForm #V_SHOWTRNO").val(result.data.showTRNo);
		   $("#reportPDFForm #V_SHOWKEYINUSER").val(result.data.showKeyInUser);
		   $("#reportPDFForm #V_SHOWBATCHPAYMENTID").val(result.data.showBatchID);
			    
		   Common.report("reportPDFForm", option);   
	   } 

   }, function(jqXHR, textStatus, errorThrown) {
       Common.alert("<spring:message code='pay.alert.fail'/>");
   });
	
}

function fn_clear(){
    $("#searchForm")[0].reset();
}
   
</script>

<!-- content start -->
<section id="content">
    <ul class="path">
        <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    </ul>

    <!-- title_line start -->
    <aside class="title_line">
        <p class="fav"><a href="#" class="click_add_on"><spring:message code='pay.text.myMenu'/></a></p>
        <h2>Payment Listing</h2>
        <ul class="right_btns">
            <c:if test="${PAGE_AUTH.funcPrint == 'Y'}">
            <li><p class="btn_blue"><a href="javascript:fn_genDocument('PDF');"><spring:message code='pay.btn.GenerateToPDF'/></a></p></li>
            <li><p class="btn_blue"><a href="javascript:fn_genDocument('EXCEL');"><spring:message code='pay.btn.generateToExcel'/></a></p></li>
            </c:if>
            <li><p class="btn_blue"><a href="javascript:fn_clear();"><span class="clear"></span><spring:message code='sys.btn.clear'/></a></p></li>
        </ul>
    </aside>
    <!-- title_line end -->

    <!-- search_table start -->
    <section class="search_table">
        <form name="searchForm" id="searchForm"  method="post">
            <input type="hidden" name="docVal" id="docVal" />
            <input type="hidden" name="branchName" id="branchName" />
            <input type="hidden" name="userNm" id="userNm" />
            <table class="type1"><!-- table start -->
                <caption>table</caption>
				<colgroup>
				    <col style="width:150px" />
				    <col style="width:*" />
				    <col style="width:150px" />
				    <col style="width:*" />				    
				</colgroup>
				<tbody>
				    <tr>
				        <th scope="row">Payment Date</th>
					    <td>
					           <div class="date_set w100p"><!-- date_set start -->
					           <p><input id="payDate1" name="payDate1" type="text" title="Pay start Date" placeholder="DD/MM/YYYY" class="j_date" readonly /></p>
					           <span>~</span>
					           <p><input id="payDate2" name="payDate2"  type="text" title="Pay end Date" placeholder="DD/MM/YYYY" class="j_date" readonly  /></p>
					           </div><!-- date_set end -->
					    </td>
					    <th scope="row">Key-In Branch</th>
					    <td>
					           <select id="branchId" name="branchId" class="w100p"></select>
					    </td>
                    </tr>
                    <tr>
                        <th scope="row">Payment Type</th>
                        <td>
                           <select id="paymentType" name="paymentType" class="w100p">                               
                           </select>
                        </td>
                        <th scope="row"></th>
					    <td>
					       <select id="paymentItem" name="paymentItem[]" class="multy_select w100p" multiple="multiple">
					               <option value="239">Order Payment</option>
                                   <option value="104">Trial Fees Payment</option>
                                   <option value="222">HP Payment</option>
                                   <option value="102">Training Payment</option>
                                   <option value="223">Membership Payment</option>
                                   <option value="238">AS Bill Payment</option>
                                   <option value="577">POS Payment</option>
                                   <option value="101">Reverse Payment</option>
                                   <option value="1308">Rental Membership Payment</option>
					       </select>
					    </td>
                    </tr>
                    <tr>
                       <th scope="row">Receipt Number</th>
                        <td>
                            <div class="date_set w100p"><!-- date_set start -->
                            <p><input type="text" id="receiptNoFr" name="receiptNoFr" title="Receipt Number(From)" placeholder="Receipt Number(From)" class="w100p" /></p>                            
                            <span>To</span>
                            <p><input type="text" id="receiptNoTo" name="receiptNoTo" title="Receipt Number(To)" placeholder="Receipt Number(To)" class="w100p" /></p>
                            </div>
                        </td>
                        <th scope="row">TR Number</th>
                        <td>
                            <div class="date_set w100p"><!-- date_set start -->
                            <p><input type="text" id="trNoFr" name="trNoFr" title="TR Number(From)" placeholder="TR Number(From)" class="w100p" /></p>
                            <span>To</span>
                            <p><input type="text" id="trNoTo" name="trNoTo" title="TR Number(To)" placeholder="TR Number(To)" class="w100p" /></p>
                            </div>
                           
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Collector</th>
                        <td>
                           <input type="text" id="collector" name="collector" title="Collector" placeholder="Collector (Member Code)" class="w100p" />
                        </td>
                        
                        <th scope="row">Key-In User</th>
                        <td>
                           <select id="userId" name="userId" class="w100p">                               
                           </select>
                        </td>
                    </tr>
                    <tr>
					    <th scope="row">Batch Type</th>
					    <td>
					       <select id="batchType" name="batchType" class="w100p"></select>
					    </td>
					      <th scope="row">Batch ID</th>
                        <td>
                           <input type="text" id="batchId" name="batchId" title="Batch ID" placeholder="Batch ID" class="w100p" />
                        </td>
					</tr>
                </tbody>
            </table>
            <!-- table end -->            
        </form>
    </section>
    <!-- search_table end -->
</section>
<form name="reportExcelForm" id="reportExcelForm"  method="post">
    <input type="hidden" id="reportFileName" name="reportFileName" value="/payment/PaymentListing_Excel.rpt" />
    <input type="hidden" id="viewType" name="viewType" value="EXCEL" />
    <input type="hidden" id="V_WHERESQL" name="V_WHERESQL" />
</form>


<form name="reportPDFForm" id="reportPDFForm"  method="post">
    <input type="hidden" id="reportFileName" name="reportFileName" value="/payment/PaymentListing_PDF.rpt" />
    <input type="hidden" id="viewType" name="viewType" value="PDF" />
    <input type="hidden" id="V_WHERESQL" name="V_WHERESQL" />    
    <input type="hidden" id="V_SHOWPAYMENTDATE" name="V_SHOWPAYMENTDATE" />                                   
    <input type="hidden" id="V_SHOWKEYINBRANCH" name="V_SHOWKEYINBRANCH" />                                   
    <input type="hidden" id="V_SHOWRECEIPTNO" name="V_SHOWRECEIPTNO" />                                   
    <input type="hidden" id="V_SHOWTRNO" name="V_SHOWTRNO" />                                   
    <input type="hidden" id="V_SHOWKEYINUSER" name="V_SHOWKEYINUSER" />                                   
    <input type="hidden" id="V_SHOWBATCHPAYMENTID" name="V_SHOWBATCHPAYMENTID" />    
</form>
