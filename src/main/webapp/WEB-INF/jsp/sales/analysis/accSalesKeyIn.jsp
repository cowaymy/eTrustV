<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/tiles/view/common.jsp" %>

<script type="text/javascript">

var sessionAuth = '${SESSION_INFO.userTypeId}';  //cody / hp
var setM;

//On Load 
var cnt =  -1;

    $(document).ready(function() {
    	 
    	//console.log("sessionAuth : " + sessionAuth);
    	//View Report
    	$("#reportType").change(function() {
    		if($(this).val() == '0'){
    			
    			 if(sessionAuth == '1'){ //auth HP
    				$("#reportFileName").val('/sales/CowayDailySalesStatusHP_Adv.rpt');
                    $("#viewType").val("WINDOW");
                    loader();	
    			}else if(sessionAuth == '2'){//auth Cody
    				$("#reportType").val('');
                    Common.alert('<spring:message code="sal.alert.msg.accessDeny" />');
                }else{
                	$("#reportFileName").val('/sales/CowayDailySalesStatusHP_Adv.rpt');
                    $("#viewType").val("WINDOW");
                    loader();
    			}
			}else if($(this).val() == '1'){
				
				 if(sessionAuth == '2'){//auth Cody
					$("#reportFileName").val('/sales/CowayDailySalesStatusCody.rpt');
	                $("#viewType").val("WINDOW");
	                loader();   
				}else if(sessionAuth == '1'){ //auth HP
					$("#reportType").val('');
                    Common.alert('<spring:message code="sal.alert.msg.accessDeny" />');   
                }else{
                	$("#reportFileName").val('/sales/CowayDailySalesStatusCody.rpt');
                    $("#viewType").val("WINDOW");
                    loader();
				} 
            }else{
            	$("#reportFileName").val('');
                $("#viewType").val("");
            }
		});
    	
    	//DownLoad Report to PDF
    	$("#_pdfDownBtn").click(function() {
    		
    		if($("#reportType").val() == '0'){
				$("#reportFileName").val('/sales/CowayDailySalesStatusHP_Adv.rpt');
                $("#viewType").val("PDF");
                fn_downloadReport(0);
			}else if($("#reportType").val() == '1'){
				$("#reportFileName").val('/sales/CowayDailySalesStatusCody.rpt');
                $("#viewType").val("PDF");
                fn_downloadReport(1);
			}else{
				Common.alert('<spring:message code="sal.alert.msg.selectRptFile" />');
			}
			
		});
    });// Document Ready Func End
    
    function fn_downloadReport(inputVal){
    	var option
    	if(inputVal == '0'){
    		option= {
    				isProcedure: true 
            }
    	}else{
    		option= {
    				isProcedure: false
            }
    	}
    	
    	//download Report
    	Common.report("dataForm", option);
    }
    
    
    
    function fn_procedureReport(){
    	
    	var option
    	var inputVal = $("#reportType").val();
    	if(inputVal == '0'){
    		option = {
                    isProcedure: true,
                    isBodyLoad : true,
                    bodyId : "reportIframe"
                };
    	}else{
    		 option = {
                    isProcedure: false,
                    isBodyLoad : true,
                    bodyId : "reportIframe"
                };
    	}
    	
        Common.report("dataForm", option);
    }

    function fn_onLoad(inputVal) {
        setTimeout("loader();", 500);
    }

    function loader(){
        
    	console.log("cnt : " + cnt);
    	
    	if(cnt == 0){
            try {
            	//console.log("로더 생성...");
            	Common.showLoader();
          //  	setM = setInterval("fn_maintanceSession()" , 60000);  //3Min
            	setM = setInterval(function(){
            		Common.ajax("GET", "/sales/analysis/maintanceSession", "", function(result) {
                        console.log("getServerTime : " + result.currTime);
                    });
            	} , 120000);  //3Min
                fn_procedureReport();
                cnt++;
            } catch (e) {
            	//console.log("실패 로더 리무브....");
            	Common.removeLoader();
                cnt = 0;
            }
        }else if(cnt == -1){ //first Load
        	//console.log("first Load....");
        	cnt++;
        	return;	
        }else{
            //console.log("로더 리무브....");
            clearInterval(setM);
            console.log("end MTNC....");
        	Common.removeLoader();
            cnt = 0;
        }
    }
    
</script>


<form id="dataForm"> <!-- CowayDailySalesStatusHP_Adv.rpt --> <!--CowayDailySalesStatusCody.rpt  -->
    <input type="hidden" id="reportFileName" name="reportFileName"/>
    <!-- Report Name  -->
    <input type="hidden" id="viewType" name="viewType" value="WINDOW"/><!-- View Type  -->
    <input type="hidden" id="V_PARAM" name="V_PARAM" value="TEMP" /><br />
</form>

<section id="content"><!-- content start -->
    <aside class="title_line"><!-- title_line start -->
        <p class="fav"><a href="#" class="click_add_on">My menu</a></p>
        <h2><spring:message code="sal.page.title.accSalesKeyIn" /></h2>
        
		<ul class="right_btns">
		    <li><p class="btn_blue"><a href="#" id="_pdfDownBtn" ><span></span><spring:message code="sal.btn.genPDF" /></a></p></li>
		</ul>
    </aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sal.text.reportType" /></th>
    <td>
    <select class="w100p" id="reportType" name="reportType"><!-- 398  -->
        <option selected="selected">choose one</option>
        <option value="0"><spring:message code="sal.combo.text.hpAnalysis" /></option>
        <option value="1"><spring:message code="sal.combo.text.codyAnalysis" /></option>
    </select>
    </td>
</tr>
</tbody>
</table><!-- table end -->

    <iframe onload="javascript: fn_onLoad()" name="reportIframe"  width="950px" height="600px" src="" scrolling="auto" frameborder="0"></iframe>

</section>
<!-- content end -->
