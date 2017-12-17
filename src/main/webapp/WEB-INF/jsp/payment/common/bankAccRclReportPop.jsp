<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javaScript">
//Default Combo Data
var reportTypeData = [{"codeId": "1","codeName": "Deposit (Key-In vs Deposit Entry)"},
                     {"codeId": "2","codeName": "Deposit Entry vs Bank Statement"},
                     {"codeId": "3","codeName": "Bank Statement vs Deposit Entry"},
                     {"codeId": "4","codeName": "Deposit Summary"}];
    
    $(document).ready(function(){
        doDefCombo(reportTypeData, '' ,'reportType', 'S', '');
    });
    
    
    //크리스탈 레포트
    function fn_generateStatement(){
        var valid = true;
        var message = "";
        var reportType = $("#reportType").val();
        
        if(reportType == ""){
            valid = false;
            message += "* Please select the report type.<br />";
        }
        
        if (FormUtil.checkReqValue($("#dpDateFr")) || FormUtil.checkReqValue($("#dpDateTo"))) {
            valid = false;
            message += "* Please select the date (From & To).<br />";
        }
        
        if(valid){
            
        	if(reportType == "1"){
                $("#reportPDFForm #viewType").val("PDF");
                $("#reportPDFForm #reportFileName").val("/reconciliation/DepositKeyInVSEntry.rpt");
            }else if(reportType == "2"){
                $("#reportPDFForm #viewType").val("PDF");
                $("#reportPDFForm #reportFileName").val("/reconciliation/DepositEntryVSBankStatement.rpt");
            }else if(reportType == "3"){
                $("#reportPDFForm #viewType").val("PDF");
                $("#reportPDFForm #reportFileName").val("/reconciliation/BankStatementVSDepositEntry.rpt");
            }else if(reportType == "4"){
                $("#reportPDFForm #viewType").val("PDF");
                $("#reportPDFForm #reportFileName").val("/reconciliation/DepositSummary.rpt");
            }
            
            $("#V_STARTDATE").val($("#dpDateFr").val());
            $("#V_ENDDATE").val($("#dpDateTo").val());
            
            //report 호출
            var option = {
                    isProcedure : true, // procedure 로 구성된 리포트 인경우 필수.
            };

            Common.report("reportPDFForm", option);
        	
        }else{
        	Common.alert(message);
        }
        
    }

</script>
<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->
    <header class="pop_header"><!-- pop_header start -->
        <h1>Bank Account Reconciliation Report</h1>
        <ul class="right_opt">
            <li><p class="btn_blue2"><a href="#" id="accRclReportPopCloseBtn"><spring:message code='sys.btn.close'/></a></p></li>
        </ul>
    </header><!-- pop_header end -->
    <section class="pop_body"><!-- pop_body start -->
       <input id="callPrgm" name="callPrgm" value="${callPrgm}" type="hidden" />
        <section class="search_table"><!-- search_table start -->
            <form action="#" method="post" id="reportPDFForm">
                <input type="hidden" id="reportFileName" name="reportFileName" value="" />
                <input type="hidden" id="viewType" name="viewType" value="" />
                <input type="hidden" id="V_STARTDATE" name="V_STARTDATE" value="" />
                <input type="hidden" id="V_ENDDATE" name="V_ENDDATE" value="" />
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
                               <select id="reportType" name="reportType" class="w100p">
                               </select>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row">Date</th>
                            <td colspan="3">
                                <div class="date_set"><!-- date_set start -->
                                    <p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" name="dpDateFr" id="dpDateFr"/></p>
                                    <span>To</span>
                                    <p><input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" name="dpDateTo"  id="dpDateTo"/></p>
                                </div><!-- date_set end -->
                            </td>
                        </tr>
                    </tbody>
                </table><!-- table end -->
            </form>
            <ul class="center_btns">
                <li><p class="btn_blue2 big"><a href="javascript:fn_generateStatement();"><spring:message code='pay.btn.statementGenerate'/></a></p></li>
            </ul>
        </section><!-- search_table end -->
    </section><!-- content end -->
</div>
        