<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">
$(document).ready(function() {
    doGetComboSepa("/common/selectBranchCodeList.do",5 , '-',''   , 'branch' , 'S', '');
    doGetCombo('/services/as/report/selectMemberCodeList.do', '', '','CTCode', 'S' ,  '');

});
function f_multiCombo() {

}

function fn_validation(){
    if($("#reqstrDt").val() != '' || $("#reqendDt").val() != ''){
        if($("#reqstrDt").val() == '' || $("#reqendDt").val() == ''){
            Common.alert("<spring:message code='sys.common.alert.validation' arguments='appointment date (From & To)' htmlEscape='false'/>");
            return false;
        }
    }

    if($("#retstrDt").val() != '' || $("#retendDt").val() != ''){
        if($("#retstrDt").val() == '' || $("#retendDt").val() == ''){
            Common.alert("<spring:message code='sys.common.alert.validation' arguments='appointment date (From & To)' htmlEscape='false'/>");
            return false;
        }
    }

    return true;
}

function fn_openReport(){
    if(fn_validation()){
        var date = new Date();
        var month = date.getMonth()+1;
        var day = date.getDate();
        if(date.getDate() < 10){
            day = "0"+date.getDate();
        }

        var showYSType = "";
        var showReqDateFrom = "";
        var showReqDateTo = "";
        var showRetDateFrom = "";
        var showRetDateTo = "";
        var showCTCode = "";
        var showBranchCode = "";
        var showSortBy = "";
        var whereSQL = "";

        if($("#ysType :selected").val() == 1){
            whereSQL += " AND ((Case when som.App_Type_ID = 66 then NVL(TRR.TradeAmount, 0) else NVL(trd.TradeAmount, 0) end) > 0 ) ";
            showYSType = $("#ysType :selected").val();
        }

        if($("#ysType :selected").val() == 2){
            whereSQL += " AND ((Case when som.App_Type_ID = 66 then NVL(TRR.TradeAmount, 0) else NVL(trd.TradeAmount, 0) end) <= 0 ) ";
            showYSType = $("#ysType :selected").val();
        }

        if(!($("#reqstrDt").val() == null || $("#reqstrDt").val().length == 0)){
            whereSQL += " AND RET.REQST_DT >= TO_DATE('"+$("#reqstrDt").val()+"', 'dd/MM/YY') ";
            showReqDateFrom = $("#reqstrDt").val();
        }

        if(!($("#reqendDt").val() == null || $("#reqendDt").val().length == 0)){
            whereSQL += " AND RET.REQST_DT <= TO_DATE('"+$("#reqendDt").val()+"', 'dd/MM/YY') ";
            showReqDateTo = $("#reqendDt").val();
        }

        if(!($("#retstrDt").val() == null || $("#retstrDt").val().length == 0)){
            whereSQL += " AND RES.STK_RETN_DT >= TO_DATE('"+$("#retstrDt").val()+"', 'dd/MM/YY') ";
            showRetDateFrom = $("#retstrDt").val();
        }

        if(!($("#retendDt").val() == null || $("#retendDt").val().length == 0)){
            whereSQL += " AND RES.STK_RETN_DT <= TO_DATE('"+$("#retendDt").val()+"', 'dd/MM/YY') ";
            showRetDateTo = $("#retendDt").val();
        }

        if($("#CTCode :selected").index() > 0){
            whereSQL += " AND RES.Stk_Retn_CT_Mem_ID = '"+$("#CTCode :selected").val()+"'";
            showCTCode = $("#CTCode :selected").text();
        }

        if($("#branch :selected").index() > 0){
            whereSQL += " AND MBR.Brnch = '"+$("#branch :selected").val()+"'";
            showBranchCode = $("#branch :selected").text();
        }

        if($("#sortType :selected").val() == 1) {
        	showSortBy += " ORDER BY OCR.SO_REQ_NO ";
        }

        if($("#sortType :selected").val() == 2) {
        	showSortBy += " ORDER BY RET.RETN_NO ";
        }

        if($("#sortType :selected").val() == 3) {
        	showSortBy += " ORDER BY BRC.CODE ";
        }
      //  var showYSType = "";
     //   if($("#ysType").val() != '' && $("#ysType").val() != null){
     //   	showYSType = $("#ysType").val();
     //   }
     //   var showReqDateFrom = "";
    //    if($("#reqstrDt").val() != '' && $("#reqstrDt").val() != null){
    //        showReqDateFrom = $("#reqstrDt").val();
     //   }
     //   var showReqDateTo = "";
      //  if($("#reqendDt").val() != '' && $("#reqendDt").val() != null){
      //      showReqDateTo = $("#reqendDt").val();
     //   }
   //     var showRetDateFrom = "";
   //     if($("#retstrDt").val() != '' && $("#retstrDt").val() != null){
    //        showRetDateFrom = $("#retstrDt").val();
   //     }
  //      var showRetDateTo = "";
    //    if($("#retendDt").val() != '' && $("#retendDt").val() != null){
   //         showRetDateTo = $("#retendDt").val();
    //    }
     //   var showCTCode = "";
   //     if($("#CTCode").val() != '' && $("#CTCode").val() != null){
   //         showCTCode =$("#CTCode").val();
   //     }

  //      var showBranchCode = "";
  //      if($("#branch").val() != '' && $("#branch").val() != null){
   //         showBranchCode =$("#branch").val();
  //      }

    //    var showSortBy = "";
      //  if($("#sortType").val() != '' && $("#sortType").val() != null){
    //        showSortBy = $("#sortType").val();
    //    }



        $("#form #V_WHERESQL").val(whereSQL);
        $("#form #V_ISYS").val(showYSType);
        $("#form #V_OCR_DATEFROM").val(showReqDateFrom);
        $("#form #V_OCR_DATETO").val(showReqDateTo);
        $("#form #V_RET_DATEFROM").val(showRetDateFrom);
        $("#form #V_RET_DATETO").val(showRetDateTo);
        $("#form #V_BRANCH_ID").val(showBranchCode);
        $("#form #V_CT_ID").val(showCTCode);
        $("#form #V_ORDERBYSQL").val(showSortBy);
        $("#form #reportFileName").val('/sales/OrderCancellationYellowSheet_PDF.rpt');
        $("#form #viewType").val("PDF");
        $("#form #reportDownFileName").val("CancellationProductReturnSummary_" +day+month+date.getFullYear());

        var option = {
                isProcedure : true, // procedure 로 구성된 리포트 인경우 필수.
        };

        Common.report("form", option);

    }
}
$.fn.clearForm = function() {
 /*   return this.each(function() {
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
        }
    });*/
    $("#ysType :selected").val() == 0;
    $("#form")[0].reset();
};
</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Order Cancellation Product Return YS Listing</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#"><spring:message code='expense.CLOSE'/></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id="form">
<input type="hidden" id="V_ISYS" name="V_ISYS" />
<input type="hidden" id="V_OCR_DATEFROM" name="V_OCR_DATEFROM" />
<input type="hidden" id="V_OCR_DATETO" name="V_OCR_DATETO" />
<input type="hidden" id="V_RET_DATEFROM" name="V_RET_DATEFROM" />
<input type="hidden" id="V_RET_DATETO" name="V_RET_DATETO" />
<input type="hidden" id="V_BRANCH_ID" name="V_BRANCH_ID" />
<input type="hidden" id="V_CT_ID" name="V_CT_ID" />
<input type="hidden" id="V_SELECTSQL" name="V_SELECTSQL" />
<input type="hidden" id="V_WHERESQL" name="V_WHERESQL" />
<input type="hidden" id="V_ORDERBYSQL" name="V_ORDERBYSQL" />
<input type="hidden" id="V_FULLSQL" name="V_FULLSQL" />
<!--reportFileName,  viewType 모든 레포트 필수값 -->
<input type="hidden" id="reportFileName" name="reportFileName" />
<input type="hidden" id="viewType" name="viewType" />
<input type="hidden" id="reportDownFileName" name="reportDownFileName" value="DOWN_FILE_NAME" />

<table class="type1"><!-- table start -->
<caption>table</caption>

<tbody>
<tr>
    <th scope="row">YS Type</th>
    <td>
    <select id="ysType" name="ysType">
        <option value="0" selected>All</option>
        <option value="1">YS</option>
        <option value="2">Non-YS</option>
    </select>
    </td>
        <th scope="row">Action CT</th>
    <td>
    <select id="CTCode" name="CTCode">
    </select>
    </td>
</tr>
<tr>
    <th scope="row">Request Date</th>
    <td>

    <div class="date_set"><!-- date_set start -->
    <p><input type="text" title="Request start Date" placeholder="DD/MM/YYYY" class="j_date" id="reqstrDt" name="reqstrDt" /></p>
    <span>To</span>
    <p><input type="text" title="Request end Date" placeholder="DD/MM/YYYY" class="j_date" id="reqendDt" name="reqendDt"/></p>
    </div><!-- date_set end -->

    </td>
    <th scope="row">Return Date</th>
    <td>

    <div class="date_set"><!-- date_set start -->
    <p><input type="text" title="Return start Date" placeholder="DD/MM/YYYY" class="j_date" id="retstrDt" name="retstrDt" /></p>
    <span>To</span>
    <p><input type="text" title="Return end Date" placeholder="DD/MM/YYYY" class="j_date" id="retendDt" name="retendDt"/></p>
    </div><!-- date_set end -->

    </td>
</tr>
<tr>

    <th scope="row">Branch Code</th>
    <td>
    <select id="branch" name="branch">
    </select>
    </td>
        <th scope="row"><spring:message code='service.title.SortBy'/></th>
    <td>
    <select id="sortType" name="sortType">
        <option value="1">OCR No</option>
        <option value="2">RET No</option>
        <option value="3">DSC Code</option>
    </select>
    </td>

</tr>

</tbody>
</table><!-- table end -->

<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#" onclick="javascript:fn_openReport()"><spring:message code='service.btn.Generate'/></a></p></li>
    <li><p class="btn_blue2 big"><a href="#" onclick="javascript:$('#form').clearForm();"><spring:message code='service.btn.Clear'/></a></p></li>
</ul>

</form>
</section><!-- search_table end -->

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->
