<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javascript">

/* 멀티셀렉트 플러그인 start */
$('.multy_select').change(function() {
   //console.log($(this).val());
})
.multipleSelect({
   width: '100%'
});

$.fn.clearForm = function() {
     $("#reqStageIdPop").multipleSelect("checkAll");
    $("#dscBranchPop").multipleSelect("uncheckAll");
    $("#reqBranchPop").multipleSelect("uncheckAll");


    return this.each(function() {
        var type = this.type, tag = this.tagName.toLowerCase();
        if (tag === 'form'){
            return $(':input',this).clearForm();
        }
        if (type === 'text' || type === 'password' || type === 'hidden' || tag === 'textarea'){
            this.value = '';
        }else if (tag === 'select'){
            this.selectedIndex = 0;
        }

    });
};

$(document).ready(function() {

    doGetComboSepa('/common/selectBranchCodeList.do',  '5', ' - ', '',   'dscBranchPop', 'M', 'fn_multiCombo'); //Branch Code
    doGetComboSepa('/common/selectBranchCodeList.do', '1' , ' - ' , '','reqBranchPop', 'M' , 'fn_multiCombo');
});

function fn_multiCombo() {
    $('#dscBranchPop').change(function() {
        //console.log($(this).val());
    }).multipleSelect({
        selectAll: true,
        width: '100%'
    });

    $('#reqBranchPop').change(function() {
    }).multipleSelect({
        selectAll: true,
        width: '100%'
    });

}

function btnGenerate_Click(){

     var whereSql = '';
     var runNo = 0;
console.log(reqBranchPop);
     if($("#reqStageIdPop").val() != null && $("#reqStageIdPop").val() != ''){
         whereSql += " AND T1.REQ_STAGE_ID IN (";
         $('#reqStageIdPop :selected').each(function(i, mul){
             if(runNo > 0){
                 whereSql += ",'"+$(mul).val()+"'";
             }else{
                 whereSql += "'"+$(mul).val()+"'";
             }
             runNo += 1;
         });
         whereSql += ") ";

         runNo = 0;
     }

     if($("#reqBranchPop").val() != null && $("#reqBranchPop").val() != ''){
         whereSql += " AND T7.USER_BRNCH_ID IN (";
         $('#reqBranchPop :selected').each(function(i, mul){
             if(runNo > 0){
                 whereSql += ",'"+$(mul).val()+"'";
             }else{
                 whereSql += "'"+$(mul).val()+"'";
             }
             runNo += 1;
         });
         whereSql += ") ";

         runNo = 0;
     }

     if($("#dscBranchPop").val() != null && $("#dscBranchPop").val() != ''){
         whereSql += " AND T11.BRNCH_ID IN (";
         $('#dscBranchPop :selected').each(function(i, mul){
             if(runNo > 0){
                 whereSql += ",'"+$(mul).val()+"'";
             }else{
                 whereSql += "'"+$(mul).val()+"'";
             }
             runNo += 1;
         });
         whereSql += ") ";

         runNo = 0;
     }

     if($("#nricCompanyNo").val() != null &&  $("#nricCompanyNo").val() != ''){
         whereSql += " AND T11.BRNCH_ID = '" + $('#nricCompanyNo').val() +" ' ";
     }

     if($("#salesOrderNo").val() != null && $("#salesOrderNo").val() != ''){
         whereSql += " AND T1.SALES_ORD_NO = '" + $('#salesOrderNo').val() +" ' ";
     }

     if($("#custName").val().trim() != null && $("#custName").val() != ''){
         whereSql += " AND T3.NAME LIKE UPPER('%" + $('#custName').val() +"%') ";
     }

     if($("#reqStartDtPop").val() == null || $("#reqStartDtPop").val() == ''){
         Common.alert('<spring:message code="sal.alert.msg.assignStartDt" />');
         return;
     }
     if($("#reqEndDtPop").val() == null || $("#reqEndDtPop").val() == ''){
         Common.alert('<spring:message code="sal.alert.msg.assignEndDt" />');
         return;
     }

     if(($("#reqStartDtPop").val() != null && $("#reqStartDtPop").val() != '') &&  ($("#reqEndDtPop").val() != null || $("#reqEndDtPop").val().trim() != '')){
         var frArr = $("#reqStartDtPop").val().split("/");
         var toArr = $("#reqEndDtPop").val().split("/");
         var assignDtFrom = frArr[2]+"/"+frArr[1]+"/"+frArr[0]; // MM/dd/yyyy
         var assignDtTo = toArr[2]+"/"+toArr[1]+"/"+toArr[0];

         whereSql += " AND (T1.CRT_DT BETWEEN TO_DATE('"+assignDtFrom+"', 'yyyy/mm/dd') AND TO_DATE('"+assignDtTo+"', 'yyyy/mm/dd')+1)";
     }

     if(($("#apprStartDtPop").val() != null && $("#apprStartDtPop").val() != '') &&  ($("#apprEndDtPop").val() != null && $("#apprEndDtPop").val() != '')){
         var frArr = $("#apprStartDtPop").val().split("/");
         var toArr = $("#apprEndDtPop").val().split("/");
         var assignDtFromAppvr = frArr[2]+"/"+frArr[1]+"/"+frArr[0]; // MM/dd/yyyy
         var assignDtToAppvr = toArr[2]+"/"+toArr[1]+"/"+toArr[0];

         whereSql += " AND (T1.UPD_DT BETWEEN TO_DATE('"+assignDtFromAppvr+"', 'yyyy/mm/dd') AND TO_DATE('"+assignDtToAppvr+"', 'yyyy/mm/dd')+1)";
     }

     $("#reportFileName").val('/services/CPE_EnquiryRawData_Excel.rpt');  //Rpt File Name
     $("#viewType").val("EXCEL");  //view Type

     //title
     var date = new Date().getDate();
     if(date.toString().length == 1){
         date = "0" + date;
     }

    console.log(whereSql);
    var title = "CPE_EnquiryRawData_Excel_"+date+(new Date().getMonth()+1)+new Date().getFullYear();
    $("#reportDownFileName").val(title); //Download File Name
    $("#V_WHERESQL").val(whereSql);// Procedure Param

    //  report 호출
    var option = {
        isProcedure : false // procedure 로 구성된 리포트 인경우 필수.
    };

    Common.report("cpeGenEnqRawForm", option);
}
</script>
<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->
<header class="pop_header"><!-- pop_header start -->
<h1>Generate Enquiry Raw Data</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#"><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->
<section class="pop_body"><!-- pop_body start -->

<section class="search_table"><!-- search_table start -->
<form id="cpeGenEnqRawForm">

<!-- Essential -->
<input type="hidden" id="reportFileName" name="reportFileName" value="" />
<input type="hidden" id="viewType" name="viewType" />
<input type="hidden" id="reportDownFileName" name="reportDownFileName"  />
<!-- Params -->
<input type="hidden" id="V_WHERESQL" name="V_WHERESQL" />

</form>
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
     <col style="width: 180px" />
     <col style="width: *" />
     <col style="width: 180px" />
     <col style="width: *" />
     <col style="width: 160px" />
     <col style="width: *" />
</colgroup>
<tbody>
<tr>
       <th scope="row"><spring:message code="sal.title.text.requestStage" /></th>
       <td><select id="reqStageIdPop" name="reqStageIdPop" class="multy_select w100p" multiple="multiple">
       <option value="24" selected><spring:message code="sal.text.beforeInstall" /></option>
       <option value="25" selected><spring:message code="sal.text.afterInstall" /></option>
       </select></td>
      <th scope="row"><spring:message code='service.title.NRIC_CompanyNo'/></th>
      <td><input type="text" id="nricCompanyNo" name="nricCompanyNo"
       placeholder="<spring:message code='service.title.NRIC_CompanyNo'/>" class="w100p" /></td>
       <th scope="row"><spring:message code='cpe.grid.requestDt'/></th>
      <td>
       <div class="date_set w100p">
        <!-- date_set start -->
        <p>
         <input type="text" title="Create start Date" value="${bfDay}"
          placeholder="DD/MM/YYYY" class="j_date w100p" id="reqStartDtPop"
          name="reqStartDtPop" />
        </p>
        <span>To</span>
        <p>
         <input type="text" title="Create end Date" value="${toDay}"
          placeholder="DD/MM/YYYY" class="j_date w100p" id="reqEndDtPop"
          name="reqEndDtPop" />
        </p>
       </div>
       <!-- date_set end -->
      </td>
</tr>
<tr>
    <th scope="row"><spring:message code="cpe.title.text.requestorBranch" /></th>
       <td><select id="reqBranchPop" name="reqBranchPop" class="multy_select w100p"  multiple="multiple">
       </select></td>
    <th scope="row"><spring:message code="sal.text.ordNo" /></th>
        <td>
        <input type="text" title="" placeholder="" class="w100p" id="salesOrderNo" name="salesOrderNo" />
        </td>
    <th scope="row"><spring:message code='sal.title.approveDate'/></th>
      <td>
       <div class="date_set w100p">
        <!-- date_set start -->
        <p>
         <input type="text" title="Create start Date" value="${bfDay}"
          placeholder="DD/MM/YYYY" class="j_date w100p" id="apprStartDtPop"
          name="apprStartDtPop" />
        </p>
        <span>To</span>
        <p>
         <input type="text" title="Create end Date" value="${toDay}"
          placeholder="DD/MM/YYYY" class="j_date w100p" id="apprEndDtPop"
          name="apprEndDtPop" />
        </p>
       </div>
       <!-- date_set end -->
      </td>
</tr>
<tr>
<th scope="row"><spring:message code="service.title.DSCBranch" /></th>
       <td><select id="dscBranchPop" name="dscBranchPop" class="multy_select w100p" multiple="multiple">
       </select></td>
<th scope="row"><spring:message code="service.grid.CustomerName" /></th>
        <td>
        <input type="text" title="" placeholder="" class="w100p" id="custName" name="custName" />
        </td>
        <td></td>
        <td></td>
</tr>
</tbody>
</table><!-- table end -->
<div style="height: 80px">
</div>
<ul class="right_btns">
    <li><p class="btn_blue"><a href="#" onclick="javascript: btnGenerate_Click()"><spring:message code="sal.btn.generate" /></a></p></li>
    <li><p class="btn_blue"><a href="#" onclick="javascript:$('#cpeGenRawForm').clearForm();"><span class="clear"></span><spring:message code="sal.btn.clear" /></a></p></li>
</ul>
</section><!-- search_table end -->
</section><!-- content end -->
<hr/>
</div><!-- popup_wrap end -->