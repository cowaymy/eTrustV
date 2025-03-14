<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">

    $(document).ready(function(){

    $('#hsMonth').val($.datepicker.formatDate('mm/yy', new Date()));

     var memType = "${SESSION_INFO.userTypeId}";
     var memLevel = "${SESSION_INFO.memberLevel}";
     var htCode = "${SESSION_INFO.userName}";

     doGetCombo('/homecare/services/dscCode.do', 3, '','cmbDSC', 'S');
     doGetCombo('/homecare/services/insStatusCode.do', 1, '','cmbInsStatus', 'S');
     doGetCombo('/homecare/services/areaCode.do', 3, '','cmbArea', 'S');

     if(memType == 7 && memLevel == 4){

         doGetCombo('/homecare/services/HTCode.do', htCode, '','cmbCodyCode', 'S' , 'fn_getValue');
         $("#cmbDeptCode").attr("disabled",true);

     }else{

         doGetCombo('/homecare/services/deptCode.do', 3, '','cmbDeptCode', 'S');
         doGetCombo('/homecare/services/codyCode.do', 3, '','cmbCodyCode', 'S');

        $("#cmbDeptCode").change(function() {

           if($("#cmbDeptCode option:selected").val() == 0 || $("#cmbDeptCode option:selected").val() == "undefined" ){
                alert($("#cmbDeptCode option:selected").val());
                doGetCombo('/homecare/services/codyCode.do', 3, '','cmbCodyCode', 'S');
            }else{
                 doGetCombo('/homecare/services/codyCode_1.do', $("#cmbDeptCode option:selected").val() , '','cmbCodyCode', 'S');
            }

            doGetCombo('/homecare/services/codyCode_1.do', $("#cmbDeptCode option:selected").val() , '','cmbCodyCode', 'S');

        });

        }

        $("#cmbContent").change(function() {

          if($(this).val() ==0 || $(this).val() ==2) {
            $("#cmbDSC").val("");
            $("#cmbStatus").val("");
            $("#cmbInsStatus").val("");
            $("#cmbArea").val("");


            $('#cmbDSC').attr("disabled",true);
            $('#cmbStatus').attr("disabled",true);
            $('#cmbInsStatus').attr("disabled",true);
            $('#cmbArea').attr("disabled",true);


          }else if($(this).val() ==1) {
             $('#cmbDSC').attr("disabled",false);
            $('#cmbStatus').attr("disabled",false);
            $('#cmbInsStatus').attr("disabled",false);
            $('#cmbArea').attr("disabled",false);
          }
        });

    });

    function fn_getValue(){
    	var htCode = "${SESSION_INFO.userName}";
    	console.log("htCode : " + htCode);
    	$("#cmbCodyCode").val(htCode);
    }


function fn_validation(){
     if($("#cmbContent option:selected").index() < 1)
        {
            Common.alert("<spring:message code='sys.common.alert.validation' arguments='Please select the report type' htmlEscape='false'/>");
            return false;
        }

     if( '${SESSION_INFO.memberLevel}' == 4){
           if($("#cmbCodyCode option:selected").index() < 1)
	   {
           Common.alert("<spring:message code='sys.common.alert.validation' arguments='Please select the HT Code.' htmlEscape='false'/>");
           return false;
	   }
     }
    return true;
}


function fn_Generate(){
    if(fn_validation()){
        var date = new Date();
        var installStatus = $("#instalStatus").val();
        var SelectSql = "";
        var whereSeq = "";
        var orderBySql = "";
        var FullSql = "";
        var month = date.getMonth()+1;
        var day =date.getDate();
        if(date.getDate() < 10){
            day = "0"+date.getDate();
        }
/*         var tmpforecastMonth = $("#forecastMonth").val();
        var forecastMonth =tmpforecastMonth.substring(3,7)+"-"+tmpforecastMonth.substring(0,2)+"-01";
        var branchid = 0;
        branchid = Number($("#brnch option:selected").val());
 */

         var cmid = 0;
//        cmid = Number($("#V_HSType option:selected").val());
        cmid = Number($("#cmbContent option:selected").val());
        $("#summaryform #viewType").val("PDF");


        if(cmid == 1){


             var whereSql ="";
             if($("#hsMonth").val() != '' && $("#hsMonth").val() != null) {
                 whereSql+= " and m.YEAR =  to_char(to_date('" +  $("#hsMonth").val() + "'" + ",'" + "mm/yyyy" + "')," + "'yyyy" +  "')" ;
                 whereSql+= " and m.MONTH =  to_char(to_date('" +  $("#hsMonth").val() + "'" + ",'" + "mm/yyyy" + "')," + "'mm" +  "')" ;
             }

             if($("#cmbDeptCode").val() != '' && $("#cmbDeptCode").val() != null) {
                whereSql+= " AND v.DEPT_CODE = '" + $("#cmbDeptCode").val() + "'";
             }

             if($("#cmbCodyCode").val() != '' && $("#cmbCodyCode").val() != null) {
                whereSql+= " AND mr.MEM_CODE = '" + $("#cmbCodyCode").val() + "'";
             }

             if($("#cmbDSC").val() != '' && $("#cmbDSC").val() != null) {
                whereSql+= " AND i.BRNCH_ID = '" + $("#cmbDSC").val() + "'";
             }

             if($("#cmbStatus").val() != '' && $("#cmbStatus").val() != null) {
                whereSql+= " AND m.STUS_CODE_ID = '" + $("#cmbStatus").val() + "'";
             }

             if($("#cmbInsStatus").val() != '' && $("#cmbInsStatus").val() != null) {
                whereSql+= " AND a.STUS_CODE_ID = '" + $("#cmbInsStatus").val() + "'";
             }

             if($("#cmbArea").val() != '' && $("#cmbArea").val() != null) {
                whereSql+= " AND a.AREA_ID = '" + $("#cmbArea").val() + "'";
             }

             $("#summaryform #V_SELECTSQL").val("");
             $("#summaryform #V_WHERESQL").val(whereSql);
             $("#summaryform #V_GROUPBYSQL").val("");
             $("#summaryform #V_FULLSQL").val("");
         }else if (cmid == 2){

             var whereSql ="";

             if($("#hsMonth").val() != '' && $("#hsMonth").val() != null) {
                 whereSql+= " and m.YEAR =  to_char(to_date('" +  $("#hsMonth").val() + "'" + ",'" + "mm/yyyy" + "')," + "'yyyy" +  "')" ;
                 whereSql+= " and m.MONTH =  to_char(to_date('" +  $("#hsMonth").val() + "'" + ",'" + "mm/yyyy" + "')," + "'mm" +  "')" ;
             }

             if($("#cmbDeptCode").val() != '' && $("#cmbDeptCode").val() != null) {
                whereSql+= " AND v.DEPT_CODE = '" + $("#cmbDeptCode").val() + "'";
             }

             if($("#cmbCodyCode").val() != '' && $("#cmbCodyCode").val() != null) {
                whereSql+= " AND mr.MEM_CODE = '" + $("#cmbCodyCode").val() + "'";
             }

             $("#summaryform #V_SELECTSQL").val("");
             $("#summaryform #V_WHERESQL").val(whereSql);
             $("#summaryform #V_GROUPBYSQL").val("");
             $("#summaryform #V_FULLSQL").val("");

             //var month = $("#hsMonth").val().substring(0,2);
             //var year= $("#hsMonth").val().substring(3,7);

             //$("#summaryform #V_BSMONTH").val(month);
             //$("#summaryform #V_BSYEAR").val(year);
             //$("#summaryform #V_BSCODYID").val($("#cmbCodyCode").val());
             //$("#summaryform #V_BSCODYDEPTCODE").val($("#cmbDeptCode").val());
         }


        if(cmid==1){
            $("#summaryform #reportFileName").val('/homecare/htSummaryList.rpt');
            $("#summaryform #reportDownFileName").val("CSCountForecastByBranch_"+day+month+date.getFullYear());
        }else if(cmid==2){
            $("#summaryform #reportFileName").val('/homecare/htSummaryRemarkList.rpt');
            $("#summaryform #reportDownFileName").val("CSCountForecastByHTGroup_"+day+month+date.getFullYear());
        }

       //report 호출
         var option = {
                 isProcedure : true, // procedure 로 구성된 리포트 인경우 필수.
         };

         Common.report("summaryform", option);
    }

}




</script>
<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>CS Management - Summary Listing</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<section class="search_table"><!-- search_table start -->
<form action="#" id="summaryform">
<input type="hidden" id="V_HSType" name="V_HSType" />
<!--reportFileName,  viewType 모든 레포트 필수값 -->
<input type="hidden" id="V_SELECTSQL" name="V_SELECTSQL" />
<input type="hidden" id="V_WHERESQL" name="V_WHERESQL" />
<input type="hidden" id="V_GROUPBYSQL" name="V_GROUPBYSQL" />
<input type="hidden" id="V_FULLSQL" name="V_FULLSQL" />

<input type="hidden" id="V_BSMONTH" name="V_BSMONTH" />
<input type="hidden" id="V_BSYEAR" name="V_BSYEAR" />
<input type="hidden" id="V_BSCODYID" name="V_BSCODYID" />
<input type="hidden" id="V_BSCODYDEPTCODE" name="V_BSCODYDEPTCODE" />

<!--reportFileName,  viewType 모든 레포트 필수값 -->
<input type="hidden" id="reportFileName" name="reportFileName" />
<input type="hidden" id="viewType" name="viewType" />
<input type="hidden" id="reportDownFileName" name="reportDownFileName" value="DOWN_FILE_NAME" />

<aside class="title_line"><!-- title_line start -->
<ul class="right_btns">
</ul>
</aside><!-- title_line end -->

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
    <th scope="row">Type</th>
    <td>
    <select id="cmbContent" name="cmbContent">
        <option value="0">Choose one</option>
        <option value="1">Monthly CS Summary Report</option>
        <option value="2">Monthly CS Remark Listing</option>

    </select>
    </td>
    <th scope="row">CS Month</th>
    <td>
    <input type="text" title="CS Month" placeholder="MM/YYYY" class="j_date2 w100p" id="hsMonth" name="hsMonth"/>
    </td>
</tr>
<tr>
    <th scope="row">Department Code</th>
    <td>
    <select id="cmbDeptCode" name="cmbDeptCode">

    </select>
    </td>
    <th scope="row">HT Code</th>
    <td>
    <select id="cmbCodyCode" name="cmbCodyCode">
    </select>
    </td>
</tr>
<tr>
    <th scope="row">DSC Code</th>
    <td>
    <select id="cmbDSC" name="cmbDSC">
    </select>
    </td>
    <th scope="row">Status</th>
    <td>
    <select id="cmbStatus" name="cmbStatus">
        <option value="">Choose one</option>
        <option value="1">Active</option>
        <option value="4">Complete</option>
        <option value="10">Cancel</option>
        <option value="21">Fail</option>
    </select>
    </td>
</tr>
<tr>
    <th scope="row">Prefer State</th>
    <td>
    <select  id="cmbInsStatus" name="cmbInsStatus">
    </select>
    </td>
    <th scope="row">Prefer Area</th>
    <td>
    <select id="cmbArea" name="cmbArea">
    </select>
    </td>
</tr>
</tbody>
</table><!-- table end -->

<article class="grid_wrap"><!-- grid_wrap start -->
</article><!-- grid_wrap end -->

</form>
</section><!-- search_table end -->
<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#" onclick="javascript:fn_Generate()">Generate</a></p></li>
</ul>
</section><!-- pop_body end -->

</div><!-- popup_wrap end -->
