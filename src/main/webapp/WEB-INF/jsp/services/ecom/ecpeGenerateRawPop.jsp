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

    doGetCombo("/services/ecom/selectReasonJsonList", '', '', '_inputReqTypeSelect', 'S', '');
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

	 if($("#dscBranchPop").val() != null && $("#dscBranchPop").val() != ''){
         whereSql += " AND T12.BRNCH_ID IN (";
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

	   if($("#statusList").val() != null && $("#statusList").val() != ''){
         whereSql += " AND T1.ECPE_STUS_ID IN (";
         $('#statusList :selected').each(function(i, mul){
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

     if($("#_inputReqTypeSelect").val() != null && $("#_inputReqTypeSelect").val() != ''){
         whereSql += " AND T1.ECPE_REASON = '" + $('#_inputReqTypeSelect').val() +" ' ";
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

     $("#reportFileName").val('/services/ecpeRawData_Excel.rpt');  //Rpt File Name
     $("#viewType").val("EXCEL");  //view Type

     //title
     var date = new Date().getDate();
     if(date.toString().length == 1){
         date = "0" + date;
     }

    console.log(whereSql);
    var title = "CPERawData_Excel_"+date+(new Date().getMonth()+1)+new Date().getFullYear();
    $("#reportDownFileName").val(title); //Download File Name
    $("#V_WHERESQL").val(whereSql);// Procedure Param

    //  report 호출
    var option = {
        isProcedure : false // procedure 로 구성된 리포트 인경우 필수.
    };
    Common.report("cpeGenRawForm", option);
}
</script>
<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->
<header class="pop_header"><!-- pop_header start -->
<h1>Generate Raw Data</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#"><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->
<section class="pop_body"><!-- pop_body start -->

<section class="search_table"><!-- search_table start -->
<form id="cpeGenRawForm">

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
</colgroup>
<tbody>
<tr>
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
        <th scope="row"><spring:message code="cpe.title.text.requestType" /></th>
        <td><select class="w100p" name="inputReqTypeSelect" id="_inputReqTypeSelect"></select></td>
</tr>
<tr>
    <th scope="row"><spring:message code="service.title.DSCBranch" /></th>
       <td><select id="dscBranchPop" name="dscBranchPop" class="multy_select w100p" multiple="multiple">
       </select></td>
    <th scope="row"><spring:message code="sys.status" /></th>
	           <td><select class="multy_select w100p" multiple="multiple"
         id="statusList" name="statusList">

          <c:forEach var="list" items="${cpeStat}" varStatus="status">
            <option value="${list.code}" selected>${list.codeName}</option>
          </c:forEach>

        </select></td>
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