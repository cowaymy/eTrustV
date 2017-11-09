<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<script type="text/javaScript">
var reportTypeData = [{"codeId": "1","codeName": "Reconciliation Pending Report"},
                      {"codeId": "2","codeName": "Reconciliation UnKnown Report"},
                      {"codeId": "3","codeName": "Reconciliation UnMatch Report"}];

var modeTypeData = [{"codeId": "105","codeName": "Cash"},
                      {"codeId": "106","codeName": "Cheque"},
                      {"codeId": "108","codeName": "Online Payment"},
                      {"codeId": "107","codeName": "Credit Card"}];

	$(document).ready(function(){
		doDefCombo(reportTypeData, '' ,'reportType', 'S', '');
		doDefCombo(modeTypeData, '' ,'modeId', 'S', '');
		
		doGetCombo('/common/getAccountList.do', '' , ''   , 'account' , 'S', '');
		doGetComboSepa('/common/selectBranchCodeList.do', '1' , ' - ' , '','branchId', 'S' , '');
	});
	
	
	//크리스탈 레포트
    function fn_generateStatement(){
        var reportType = $("#reportType").val();
        
        if (reportType != ""){
            
            if(reportType == "1"){
                $("#reportPDFForm #viewType").val("PDF");
                $("#reportPDFForm #reportFileName").val("/reconciliation/RCL_Pending_PDF.rpt");
            }else if(reportType == "2"){
                $("#reportPDFForm #viewType").val("PDF");
                $("#reportPDFForm #reportFileName").val("/reconciliation/RCL_UnKnown_PDF.rpt");
            }else if(reportType == "3"){
                $("#reportPDFForm #viewType").val("PDF");
                $("#reportPDFForm #reportFileName").val("/reconciliation/RCL_UnMatch_PDF.rpt");
            }
            
            //report 호출
            var option = {
                    isProcedure : true, // procedure 로 구성된 리포트 인경우 필수.
            };

            Common.report("reportPDFForm", option);
        }else{
            Common.alert('<b>No print type selected.</b>');
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
	        <form action="#" method="post" id="reportPDFForm">
		        <input type="hidden" id="reportFileName" name="reportFileName" value="" />
		        <input type="hidden" id="viewType" name="viewType" value="" />
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
	                           <select id="reportType" name="reportType" class="w100p"></select>
	                        </td>
	                    </tr>
	                    <tr>
	                        <th scope="row">Branch</th>
	                        <td colspan="3">
	                           <select id="branchId" name="branchId" class="w100p"></select>
	                        </td>
	                    </tr>
	                    <tr>
	                        <th scope="row">Account</th>
	                        <td colspan="3">
	                           <select id="account" name="account" class="w100p"></select>
	                        </td>
	                    </tr>
	                    <tr>
	                        <th scope="row">Mode</th>
	                        <td colspan="3">
	                           <select id="modeId" name="modeId" class="w100p"></select>
	                        </td>
	                    </tr>
	                    <tr>
	                        <th scope="row">Date</th>
	                        <td colspan="3">
	                            <div class="date_set"><!-- date_set start -->
		                            <p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" name="fromUploadDate"/></p>
		                            <span>To</span>
		                            <p><input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" name="toUploadDate"/></p>
	                            </div><!-- date_set end -->
	                        </td>
	                    </tr>
	                </tbody>
	            </table><!-- table end -->
	        </form>
	        <ul class="center_btns">
                <li><p class="btn_blue2 big"><a href="javascript:fn_generateStatement();">Statement Generate</a></p></li>
            </ul>
	    </section><!-- search_table end -->
	
	</section><!-- content end -->
</div>
		