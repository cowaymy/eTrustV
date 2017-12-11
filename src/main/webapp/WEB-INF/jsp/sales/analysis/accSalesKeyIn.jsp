<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/tiles/view/common.jsp" %>

<script type="text/javascript">

    $(document).ready(function() {
    });

    var cnt = 0;

    
    function fn_procedureReport(){
    	var option = {
                isProcedure: true,
                isBodyLoad : true,
                bodyId : "reportIframe"
            };
            
            Common.report("dataForm", option);
    }

    function fn_onLoad() {
        
    	if(cnt == 0){
        	try {
        		Common.showLoader();
        		fn_procedureReport();
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
            <li><p class="btn_blue"><a href="#"><span class="search"></span>Search</a></p></li>
            <li><p class="btn_blue"><a href="#"><span class="clear"></span>Clear</a></p></li>
        </ul>
    </aside><!-- title_line end -->

    <iframe onload="fn_onLoad()" name="reportIframe"  width="950px" height="600px" src="" scrolling="auto" frameborder="0"></iframe>

</section>
<!-- content end -->
