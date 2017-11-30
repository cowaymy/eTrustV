<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">
var myGridID;
$(document).ready(function(){
     $('.multy_select').on("change", function() {
           //console.log($(this).val());
       }).multipleSelect({}); 
    
    doGetComboSepa("/common/selectBranchCodeList.do",5 , '-',''   , 'branch' , 'S'); 
    doGetCombo('/services/mileageCileage/selectMemberCode', 3, '','CTCode', 'S');
    //doGetCombo('/services/bs/getCdList.do', '2' , ''   , 'CTCode' , 'S', '');
});



function fn_openReport(){   
		var date = new Date();
	    var month = date.getMonth()+1;
	  var memberId = "";
      var promotionId = "";
      var orderNo = "";
      var installNo = "";
      var installDate = "";
      var appType="";
      var branchId = "";
      
      if($("#CTCode").val() != ''){
          memberId = $("#CTCode").val();
      }
      if($("#promotCode").val() != ''){
          promotionId = $("#promotCode").val();
      }
      if($("#orderNo").val() != ''){
          orderNo = $("#orderNo").val();
      }
      if($("#installNo").val() != ''){
          installNo = $("#installNo").val();
      }
      if($("#installDt").val() != ''){
          installDate = "to_date("+$("#installDt").val() + ",DD/MM/YYYY)";
      }
      if($("#appliType").val() != ''){
          appType =  " ("+$("#appliType").val() + ") ";
      }
      if($("#branch").val() != ''){
          branchId = $("#branch").val();
      }
  
      $("#reportForm #V_MEMBERID").val(memberId);
      $("#reportForm #V_PROMOTIONID").val(promotionId);
      $("#reportForm #V_ORDERNO").val(orderNo);
      $("#reportForm #V_INSTALLNO").val(installNo);
      $("#reportForm #V_INSTALLDATE").val(installDate);
      $("#reportForm #V_APPTYPEID").val(appType);
      $("#reportForm #V_DSCBRANCHID").val(branchId);
      $("#reportForm #reportFileName").val('/services/InstallationFreeGiftList.rpt');
       $("#reportForm #viewType").val("PDF");
       $("#reportForm #reportDownFileName").val("InstallationFreeGiftList_"+date.getDate()+month+date.getFullYear());
       
      var option = {
              isProcedure : true, // procedure 로 구성된 리포트 인경우 필수.
      };
      
      Common.report("reportForm", option);
}

function fn_openExcel(){
		var date = new Date();
	    var month = date.getMonth()+1;
	    var memberId = "";
	    var promotionId = "";
	    var orderNo = "";
	    var installNo = "";
	    var installDate = "";
	    var appType="";
	    var branchId = "";
	    
	    if($("#CTCode").val() != ''){
	    	memberId = $("#CTCode").val();
	    }
	    if($("#promotCode").val() != ''){
	    	promotionId = $("#promotCode").val();
        }
	    if($("#orderNo").val() != ''){
	    	orderNo = $("#orderNo").val();
        }
	    if($("#installNo").val() != ''){
	    	installNo = $("#installNo").val();
        }
	    if($("#installDt").val() != ''){
	    	installDate = "to_date("+$("#installDt").val() + ",DD/MM/YYYY)";
        }
	    if($("#appliType").val() != ''){
	    	appType = installNo = " ("+$("#appliType").val() + ") ";
        }
	    if($("#branch").val() != ''){
	    	branchId = $("#branch").val();
        }
	
        $("#reportForm #V_MEMBERID").val(memberId);
        $("#reportForm #V_PROMOTIONID").val(promotionId);
        $("#reportForm #V_ORDERNO").val(orderNo);
        $("#reportForm #V_INSTALLNO").val(installNo);
        $("#reportForm #V_INSTALLDATE").val(installDate);
        $("#reportForm #V_APPTYPEID").val(appType);
        $("#reportForm #V_DSCBRANCHID").val(branchId);
        $("#reportForm #reportFileName").val('/services/InstallationFreeGiftList.rpt');
         $("#reportForm #viewType").val("EXCEL");
         $("#reportForm #reportDownFileName").val("InstallationFreeGiftList_"+date.getDate()+month+date.getFullYear());
         
        var option = {
                isProcedure : true, // procedure 로 구성된 리포트 인경우 필수.
        };
        
        Common.report("reportForm", option);
}

$.fn.clearForm = function() {
    return this.each(function() {
        var type = this.type, tag = this.tagName.toLowerCase();
        if (tag === 'form'){
            return $(':input',this).clearForm();
        }
        if (type === 'text' || type === 'password' || type === 'hidden' || tag === 'textarea'){
            this.value = '';
        }else if (type === 'checkbox' || type === 'radio'){
            this.checked = false;
        }else if (tag === 'select'){
            this.selectedIndex = -1;
            f_multiCombo();
            f_multiCombo1();
        }
    });
};
</script>
<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Installation Free Gift List</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<section class="search_table"><!-- search_table start -->
<form action="#" id="reportForm">
<input type="hidden" id="V_MEMBERID" name="V_MEMBERID" />
<input type="hidden" id="V_PROMOTIONID" name="V_PROMOTIONID" />
<input type="hidden" id="V_ORDERNO" name="V_ORDERNO" />
<input type="hidden" id="V_INSTALLNO" name="V_INSTALLNO" />
<input type="hidden" id="V_INSTALLDATE" name="V_INSTALLDATE" />
<input type="hidden" id="V_APPTYPEID" name="V_APPTYPEID" />
<input type="hidden" id="V_DSCBRANCHID" name="V_DSCBRANCHID" />
<!--reportFileName,  viewType 모든 레포트 필수값 -->
<input type="hidden" id="reportFileName" name="reportFileName" />
<input type="hidden" id="viewType" name="viewType" />
<input type="hidden" id="reportDownFileName" name="reportDownFileName" value="DOWN_FILE_NAME" />
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
    <th scope="row">CT Code</th>
    <td>
    <select id="CTCode" name="CTCode">
    </select>
    </td>
    <th scope="row">Promotion Code</th>
    <td>
    <select id="promotCode" name="promotCode">
        <option value=""></option>
        <option value="31342">CMCPG160401 - 2016 FREE GIFT PROMOTION (REN): HAPPYCALL PAN</option>
        <option value="31343">CMCPG160402 - 2016 FREE GIFT PROMOTION (OUT): FULL SET OF HAPPYCALL</option>
        <option value="31345">CMCPG160402-1 - 2016 FREE GIFT PROMOTION (OUT): FULL SET OF HAPPYCALL - GOV/DESIGNATED AREA</option>
    </select>
    </td>
</tr>
<tr>
    <th scope="row">Order No</th>
    <td>
    <input type="text" title="" placeholder="Order No" class="" id="orderNo" name="orderNo"/>
    </td>
    <th scope="row">Install No</th>
    <td>
    <input type="text" title="" placeholder="Install No" class="" id="installNo" name="installNo"/>
    </td>
</tr>
<tr>
    <th scope="row">App Type</th>
    <td>
    <select class="multy_select" multiple="multiple" id="appliType" name="appliType">
        <option value="66">Rental</option>
        <option value="67, 68">Outright</option>
    </select>
    </td>
    <th scope="row">Install Date</th>
    <td>
    <input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" id="installDt" name="installDt"/>
    </td>
</tr>
<tr>
    <th scope="row">DSC Code</th>
    <td colspan="3">
    <select  id="branch" name="branch">
    </select>
    </td>
</tr>
</tbody>
</table><!-- table end -->
</form>
</section><!-- search_table end -->

<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#" onclick="javascript:fn_openReport()">Generate PDF</a></p></li>
    <li><p class="btn_blue2 big"><a href="#" onclick="javascript:fn_openExcel()">Generate Excel</a></p></li>
    <li><p class="btn_blue2 big"><a href="#" onclick="javascript:$('#reportForm').clearForm();">Clear</a></p></li>
</ul>

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->
