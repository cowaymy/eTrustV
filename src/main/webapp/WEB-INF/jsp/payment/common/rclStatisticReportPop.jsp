<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<script type="text/javaScript">

var modeTypeData = [{"codeId": "105","codeName": "Cash"},
                      {"codeId": "106","codeName": "Cheque"},
                      {"codeId": "108","codeName": "Online Payment"},
                      {"codeId": "107","codeName": "Credit Card"}];

	$(document).ready(function(){
		
		doDefCombo(modeTypeData, '' ,'modeId', 'M', 'f_modeCombo');
		doGetCombo('/common/getAccountList.do', '' , ''   , 'account' , 'M', 'f_accountCombo');
		doGetComboSepa('/common/selectBranchCodeList.do', '1' , ' - ' , '','branchId', 'M' , 'f_branchCombo');
		
		var today = new Date();
		var dd = today.getDate();
		var mm = today.getMonth()+1;
		var yyyy = today.getFullYear();
		
		if(dd<10) {
		    dd='0'+dd
		} 

		if(mm<10) {
		    mm='0'+mm
		} 
		var today = dd+"/"+mm+"/"+yyyy;
		
		$("#fromUploadDate").val(today);
		$("#toUploadDate").val(today);
	});
	
	function f_modeCombo() {
        $(function() {
            $('#modeId').change(function() {
            }).multipleSelect({
                //selectAll : true, // 전체선택 
                width : '80%'
            })
        });
    }
	
	function f_accountCombo() {
        $(function() {
            $('#account').change(function() {
            }).multipleSelect({
                //selectAll : true, // 전체선택 
                width : '80%'
            })
        });
    }
	
	function f_branchCombo() {
        $(function() {
            $('#branchId').change(function() {
            }).multipleSelect({
                //selectAll : true, // 전체선택 
                width : '80%'
            })
        });
    }
	
	//크리스탈 레포트
    function fn_generateStatement(){
        
		var reportType = $("#reportType").val();
        var valid = true;
        var message = "";
        
        /* alert("value : " + $("#branchId").val());
        
        alert("value : " + $("#branchId option:selected").text());
        
        alert("mode value : " + $("#modeId").val());
        
        alert("mode value : " + $("#modeId option:selected").text());
        
        return false; */
        
        if(reportType == ""){
            valid = false;
            message += "* Please select the report type.<br />";
            
        }
        
        if (FormUtil.checkReqValue($("#fromUploadDate")) || FormUtil.checkReqValue($("#toUploadDate"))) {
            valid = false;
            message += "* Please select the date (From & To).<br />";
        }
        
        if(valid){
        	
        	var branchId = $("#branchId").val();
        	var account = $("#account").val();
        	var modeId = $("#modeId").val();
        	var startDate = $("#fromUploadDate").val();
        	var endDate = $("#toUploadDate").val();
        	
        	//var branchCode = $("#branchId option:selected").text();
        	//var accountCode = $("#account option:selected").text();
        	//var modeCode = $("#modeId option:selected").text();
        	
        	if(reportType == "1"){
                $("#reportPendingForm #viewType").val("PDF");
                $("#reportPendingForm #reportFileName").val("/reconciliation/RCL_Pending_PDF.rpt");
                
                $("#reportPendingForm #V_BRANCHID").val(branchId);
                //$("#reportPendingForm #V_BRANCHCODE").val("");
                $("#reportPendingForm #V_ACCOUNTID").val(account);
                //$("#reportPendingForm #V_ACCOUNTCODE").val("");
                $("#reportPendingForm #V_MODEID").val(modeId);
                //$("#reportPendingForm #V_MODECODE").val("");
                $("#reportPendingForm #V_STARTDATE").val(startDate);
                $("#reportPendingForm #V_ENDDATE").val(endDate);
                
            }else if(reportType == "2"){
                $("#reportUnknownForm #viewType").val("PDF");
                $("#reportUnknownForm #reportFileName").val("/reconciliation/RCL_UnKnown_PDF.rpt");
                
                $("#reportUnknownForm #V_ACCOUNTID").val(account);
                //$("#reportUnknownForm #V_ACCOUNTCODE").val("");
                $("#reportUnknownForm #V_MODEID").val(modeId);
                //$("#reportUnknownForm #V_MODECODE").val("");
                $("#reportUnknownForm #V_STARTDATE").val(startDate);
                $("#reportUnknownForm #V_ENDDATE").val(endDate);
                
            }else if(reportType == "3"){
                $("#reportUnmatchForm #viewType").val("PDF");
                $("#reportUnmatchForm #reportFileName").val("/reconciliation/RCL_UnMatch_PDF.rpt");
                
                $("#reportUnmatchForm #V_ACCOUNTID").val(account);
                //$("#reportUnmatchForm #V_ACCOUNTCODE").val("");
                $("#reportUnmatchForm #V_MODEID").val(modeId);
                //$("#reportUnmatchForm #V_MODECODE").val("");
                $("#reportUnmatchForm #V_STARTDATE").val(startDate);
                $("#reportUnmatchForm #V_ENDDATE").val(endDate);
            }
            
            //report 호출
            var option = {
                    isProcedure : true, // procedure 로 구성된 리포트 인경우 필수.
            };
            
            if(reportType == "1"){
            	Common.report("reportPendingForm", option);
            }else if(reportType == "2"){
            	Common.report("reportUnknownForm", option);
            }else if(reportType == "3"){
            	Common.report("reportUnmatchForm", option);
            }
            
        }else{
        	Common.alert(message);
        }
        
    }
</script>
<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->
    <header class="pop_header"><!-- pop_header start -->
        <h1>Reconciliation Statistic Report</h1>
        <ul class="right_opt">
            <li><p class="btn_blue2"><a href="#" id="rclStatisticReportPopCloseBtn">CLOSE</a></p></li>
        </ul>
    </header><!-- pop_header end -->
	<section class="pop_body"><!-- pop_body start -->
	   <input id="callPrgm" name="callPrgm" value="${callPrgm}" type="hidden" />
	    <section class="search_table"><!-- search_table start -->
	        <table class="type1"><!-- table start -->
                    <caption>table</caption>
                    <colgroup>
                        <col style="width:170px" />
                        <col style="width:*" />
                        <col style="width:140px" />
                        <col style="width:*" />
                    </colgroup>
                    <tbody>
                        <tr>
                            <th scope="row">Report Type</th>
                            <td colspan="3">
                               <select id="reportType" name="reportType" class="w100p" >
                                   <option value="1" selected="selected">Reconciliation Pending Report</option>
                                   <option value="2">Reconciliation UnKnown Report</option>
                                   <option value="3">Reconciliation UnMatch Report</option>
                               </select>
                            </td>
                            <th scope="row">Branch</th>
                            <td colspan="3">
                               <select id="branchId" name="branchId" class="w100p" multiple="multiple"></select>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row">Account</th>
                            <td colspan="3">
                               <select id="account" name="account" class="w100p" multiple="multiple"></select>
                            </td>
                            <th scope="row">Mode</th>
                            <td colspan="3">
                               <select id="modeId" name="modeId" class="w100p" multiple="multiple">
                               </select>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row">Date</th>
                            <td colspan="7">
                                <div class="date_set"><!-- date_set start -->
                                    <p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" name="fromUploadDate" id="fromUploadDate"/></p>
                                    <span>To</span>
                                    <p><input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" name="toUploadDate" id="toUploadDate"/></p>
                                </div><!-- date_set end -->
                            </td>
                        </tr>
                    </tbody>
                </table><!-- table end -->
	        <ul class="center_btns">
                <li><p class="btn_blue2 big"><a href="javascript:fn_generateStatement();">Statement Generate</a></p></li>
            </ul>
	    </section><!-- search_table end -->
	</section><!-- content end -->
	<form action="#" method="post" id="reportPendingForm">
	   <input type="hidden" id="reportFileName" name="reportFileName" value="" />
       <input type="hidden" id="viewType" name="viewType" value="" />
       <input type="hidden" id="V_BRANCHID" name="V_BRANCHID" value="" />
       <input type="hidden" id="V_BRANCHCODE" name="V_BRANCHCODE" value="" />
       <input type="hidden" id="V_ACCOUNTID" name="V_ACCOUNTID" value="" />
       <input type="hidden" id="V_ACCOUNTCODE" name="V_ACCOUNTCODE" value="" />
       <input type="hidden" id="V_MODEID" name="V_MODEID" value="" />
       <input type="hidden" id="V_MODECODE" name="V_MODECODE" value="" />
       <input type="hidden" id="V_STARTDATE" name="V_STARTDATE" value="" />
       <input type="hidden" id="V_ENDDATE" name="V_ENDDATE" value="" />
	</form>
	
	<form action="#" method="post" id="reportUnknownForm">
       <input type="hidden" id="reportFileName" name="reportFileName" value="" />
       <input type="hidden" id="viewType" name="viewType" value="" />
       <input type="hidden" id="V_ACCOUNTID" name="V_ACCOUNTID" value="" />
       <input type="hidden" id="V_ACCOUNTCODE" name="V_ACCOUNTCODE" value="" />
       <input type="hidden" id="V_MODEID" name="V_MODEID" value="" />
       <input type="hidden" id="V_MODECODE" name="V_MODECODE" value="" />
       <input type="hidden" id="V_STARTDATE" name="V_STARTDATE" value="" />
       <input type="hidden" id="V_ENDDATE" name="V_ENDDATE" value="" />
    </form>
    
    <form action="#" method="post" id="reportUnmatchForm">
       <input type="hidden" id="reportFileName" name="reportFileName" value="" />
       <input type="hidden" id="viewType" name="viewType" value="" />
       <input type="hidden" id="V_ACCOUNTID" name="V_ACCOUNTID" value="" />
       <input type="hidden" id="V_ACCOUNTCODE" name="V_ACCOUNTCODE" value="" />
       <input type="hidden" id="V_MODEID" name="V_MODEID" value="" />
       <input type="hidden" id="V_MODECODE" name="V_MODECODE" value="" />
       <input type="hidden" id="V_STARTDATE" name="V_STARTDATE" value="" />
       <input type="hidden" id="V_ENDDATE" name="V_ENDDATE" value="" />
    </form>
</div>
		