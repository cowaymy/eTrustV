<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/tiles/view/common.jsp" %>

<script type="text/javascript">

    $(document).ready(function() {
    	
    	//View Report
    	$("#reportType").change(function() {
			if($(this).val() == '0'){
				$("#reportFileName").val('/sales/CowayDailySalesStatusHP_Adv.rpt');
				$("#viewType").val("WINDOW");
				loader(0);
			}
			
		    if($(this).val() == '1'){
		    	$("#reportFileName").val('/sales/CowayDailySalesStatusCody.rpt');
		    	$("#viewType").val("WINDOW");
		    	loader(1);
            }
		});
    	
    	//DownLoad Report to PDF
    	$("#_pdfDownBtn").click(function() {
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
    });
    
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
    
    //On Load 
    var cnt = 0;
    
    function fn_procedureReport(inputVal){
    	
    	var option
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
        setTimeout("loader("+inputVal+");", 100);
    }

    function loader(inputVal){
        if(cnt == 0){
            try {
                Common.showLoader();
                fn_procedureReport(inputVal);
                cnt++;
            } catch (e) {
                Common.removeLoader();
                cnt = 0;
            }
        }else{
            Common.removeLoader();
            cnt = 0;
        }
    }
</script>


<form id="dataForm"> <!-- CowayDailySalesStatusHP_Adv.rpt --> <!--CowayDailySalesStatusCody.rpt  -->
    <input type="hidden" id="reportFileName" name="reportFileName" value="/sales/CowayDailySalesStatusHP_Adv.rpt"/>
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
        <option value="0">HP Analysis</option>
        <option value="1">Cody Analysis</option>
    </select>
    </td>
</tr>
</tbody>
</table><!-- table end -->

    <iframe onload="fn_onLoad(0)" name="reportIframe"  width="950px" height="600px" src="" scrolling="auto" frameborder="0"></iframe>

</section>
<!-- content end -->
