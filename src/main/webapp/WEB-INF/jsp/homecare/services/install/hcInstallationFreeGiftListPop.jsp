<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">
//Branch : 5743
var branchDs = [];
<c:forEach var="obj" items="${branchList}">
    branchDs.push({codeId:"${obj.codeId}", codeName:"${obj.codeName}"});
</c:forEach>

var myGridID;
$(document).ready(function(){
    $('.multy_select').on("change", function() {
           //console.log($(this).val());
    }).multipleSelect({});

    //doGetComboSepa("/common/selectBranchCodeList.do",5 , '-',''   , 'branch' , 'S');
    doDefCombo(branchDs, '', 'branch', 'S', '');   // Home Care Branch : 5743

    //doGetCombo('/services/as/report/selectMemberCodeList.do', '', '','CTCode', 'S' ,  '');
    $("#branch").change(function() {
        doGetCombo('/homecare/services/as/selectCTByDSCSearch.do', $("#branch").val(), '', 'CTCode', 'S', '');
    });

});



function fn_openReport(){
		var date = new Date();
	    var month = date.getMonth()+1;
	    var day = date.getDate();
        if(date.getDate() < 10){
            day = "0"+date.getDate();
        }
	  var memberId = "";
      var promotionId = "";
      var orderNo = "";
      var installNo = "";
      var installDate = "";
      var appType="";
      var branchId = "";

      if($("#CTCode").val() != '' && $("#CTCode").val() != null){
          memberId = $("#CTCode").val();
      }
      if($("#promotCode").val() != '' && $("#promotCode").val() != null){
          promotionId = $("#promotCode").val();
      }
      if($("#orderNo").val() != '' && $("#orderNo").val() != null){
          orderNo = $("#orderNo").val();
      }
      if($("#installNo").val() != '' && $("#installNo").val() != null){
          installNo = $("#installNo").val();
      }
      if($("#installDt").val() != '' && $("#installDt").val() != null){
          installDate = $("#installDt").val();
      }
      if($("#appliType").val() != '' && $("#appliType").val() != null){
          appType =  " ("+$("#appliType").val() + ") ";
      }
      if($("#branch").val() != '' && $("#branch").val() != null){
          //branchId = $("#branch").val();
    	  branchId = " (SELECT BRNCH_ID FROM SYS0005M WHERE CODE = '" + $("#branch").val() + "' AND STUS_ID = 1 AND TYPE_ID = 5754)";
      }

      $("#reportForm #V_MEMBERID").val(memberId);
      $("#reportForm #V_PROMOTIONID").val(promotionId);
      $("#reportForm #V_ORDERNO").val(orderNo);
      $("#reportForm #V_INSTALLNO").val(installNo);
      $("#reportForm #V_INSTALLDATE").val(installDate);
      $("#reportForm #V_APPTYPEID").val(appType);
      $("#reportForm #V_DSCBRANCHID").val(branchId);
      $("#reportForm #reportFileName").val('/homecare/hcInstallationFreeGiftList.rpt');
       $("#reportForm #viewType").val("PDF");
       $("#reportForm #reportDownFileName").val("InstallationFreeGiftList_"+day+month+date.getFullYear());

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
	    var day =date.getDate();
        if(date.getDate() < 10){
            day = "0"+date.getDate();
        }
	    if($("#CTCode").val() != '' && $("#CTCode").val() != null){
	    	memberId = $("#CTCode").val();
	    }
	    if($("#promotCode").val() != '' && $("#promotCode").val() != null){
	    	promotionId = $("#promotCode").val();
        }
	    if($("#orderNo").val() != '' && $("#orderNo").val() != null){
	    	orderNo = $("#orderNo").val();
        }
	    if($("#installNo").val() != '' && $("#installNo").val() != null){
	    	installNo = $("#installNo").val();
        }
	    if($("#installDt").val() != '' && $("#installDt").val() != null){
	    	installDate = $("#installDt").val();
        }
	    if($("#appliType").val() != '' && $("#appliType").val() != null){
	    	appType = installNo = " ("+$("#appliType").val() + ") ";
        }
	    if($("#branch").val() != '' && $("#branch").val() != null){
	          //branchId = $("#branch").val();
	          branchId = " (SELECT BRNCH_ID FROM SYS0005M WHERE CODE = '" + $("#branch").val() + "' AND STUS_ID = 1 AND TYPE_ID = 5754)";
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
         $("#reportForm #reportDownFileName").val("InstallationFreeGiftList_"+day+month+date.getFullYear());

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
            doGetCombo('/homecare/services/as/selectCTByDSCSearch.do', '-', '', 'CTCode', 'S', '');
        }
    });
};
</script>
<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code='service.btn.InstallationFreeGiftList'/></h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#"><spring:message code='expense.CLOSE'/></a></p></li>
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
    <th scope="row"><spring:message code='service.title.CTCode'/></th>
    <td>
    <select id="CTCode" name="CTCode">
    </select>
    </td>
    <th scope="row"><spring:message code='service.title.PromotionCode'/></th>
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
    <th scope="row"><spring:message code='service.title.OrderNo'/></th>
    <td>
    <input type="text" title="" placeholder="Order No" class="" id="orderNo" name="orderNo"/>
    </td>
    <th scope="row"><spring:message code='service.title.InstallNo'/></th>
    <td>
    <input type="text" title="" placeholder="Install No" class="" id="installNo" name="installNo"/>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code='service.title.AppType'/></th>
    <td>
    <select class="multy_select" multiple="multiple" id="appliType" name="appliType">
        <option value="66">Rental</option>
        <option value="67, 68">Outright</option>
    </select>
    </td>
    <th scope="row"><spring:message code='service.title.InstallDate'/></th>
    <td>
    <input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" id="installDt" name="installDt"/>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code='service.title.DSCCode'/></th>
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
    <li><p class="btn_blue2 big"><a href="#" onclick="javascript:fn_openReport()"><spring:message code='service.btn.GenerateToPDF'/></a></p></li>
    <li><p class="btn_blue2 big"><a href="#" onclick="javascript:fn_openExcel()"><spring:message code='service.btn.GenerateToExcel'/></a></p></li>
    <li><p class="btn_blue2 big"><a href="#" onclick="javascript:$('#reportForm').clearForm();"><spring:message code='service.btn.Clear'/></a></p></li>
</ul>

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->
