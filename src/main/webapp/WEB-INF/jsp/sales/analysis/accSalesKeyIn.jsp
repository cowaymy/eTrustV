<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/tiles/view/common.jsp" %>

<script type="text/javascript">

var sessionAuth = '${SESSION_INFO.userTypeId}';
//On Load 
var cnt =  -1;

    $(document).ready(function() {
    	 
    	//console.log("sessionAuth : " + sessionAuth);
    	
    	//View Report
    	$("#reportType").change(function() {
    		if($(this).val() == '0'){
    			
    			$("#reportFileName").val('/sales/CowayDailySalesStatusHP_Adv.rpt');
                $("#viewType").val("WINDOW");
                loader();
    			
    			/* if(sessionAuth == '1'){ //auth HP
    				$("#reportFileName").val('/sales/CowayDailySalesStatusHP_Adv.rpt');
                    $("#viewType").val("WINDOW");
                    loader();	
    			}else{
    				Common.alert("access deny.");
    			} */
			}else if($(this).val() == '1'){
		    	
				$("#reportFileName").val('/sales/CowayDailySalesStatusCody.rpt');
                $("#viewType").val("WINDOW");
                loader();
				
				/* if(sessionAuth == '2'){//auth Cody
					$("#reportFileName").val('/sales/CowayDailySalesStatusCody.rpt');
	                $("#viewType").val("WINDOW");
	                loader();   
				}else{
					Common.alert("access deny.");
				} */
            }else{
            	$("#reportFileName").val('');
                $("#viewType").val("");
            }
		});
    	
    	//DownLoad Report to PDF
    	$("#_pdfDownBtn").click(function() {
			
    		if($("#reportType").val() == null || $("#reportType").val() == ''){
    			Common.alert("Please select Report Type");
    			return;
    		}
    		
    		if($("#reportType").val() == '0'){
				$("#reportFileName").val('/sales/CowayDailySalesStatusHP_Adv.rpt');
                $("#viewType").val("PDF");
                fn_downloadReport(0);
			}
			
			if($("#reportType").val() == '1'){
				$("#reportFileName").val('/sales/CowayDailySalesStatusCody.rpt');
                $("#viewType").val("PDF");
                fn_downloadReport(1);
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
        
    	//console.log("cnt : " + cnt);
    	
    	if(cnt == 0){
            try {
            	//console.log("로더 생성...");
            	Common.showLoader();
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
        <h2>Analysis - Accumulated Sales Key-In</h2>
        
		<ul class="right_btns">
		    <li><p class="btn_blue"><a href="#" id="_pdfDownBtn" ><span></span>PDF Download</a></p></li>
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
    <th scope="row">Report Type</th>
    <td>
    <select class="w100p" id="reportType" name="reportType">
        <option selected="selected">choose one</option>
        <option value="0">HP Analysis</option>
        <option value="1">Cody Analysis</option>
    </select>
    </td>
</tr>
</tbody>
</table><!-- table end -->

    <iframe onload="javascript: fn_onLoad()" name="reportIframe"  width="950px" height="600px" src="" scrolling="auto" frameborder="0"></iframe>

</section>
<!-- content end -->
