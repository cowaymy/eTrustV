<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript" language="javascript">
var userId = '${SESSION_INFO.userId}';
var MEM_TYPE     = '${SESSION_INFO.userTypeId}';
var memberTypeData = 2;
/* var memberTypeData = [{"codeId": "2","codeName": "Coway Lady"}]; */

        $(document).ready(function() {

                 $('#memberTypeData').val(2);
                 doGetCombo('/services/hs/getDeptTreeList.do', memberTypeData , '' , 'cmbOrganizationId' , 'S', '');

        $('#cmbOrganizationId').change(function (){
            // var paramdata;

             $("#groupCode").val( $(this).val());
             $("#memType").val(memberTypeData);
             $("#memLvl").val(2);

             doGetComboData('/services/hs/getGroupTreeList.do', $("#cForm").serialize(), '','cmbGroupId', 'S' , '');

        });
        $('#cmbGroupId').change(function (){
            var paramdata;

            $("#groupCode").val( $(this).val());
            $("#memType").val(memberTypeData);
            $("#memLvl").val(3);

            doGetComboData('/services/hs/getGroupTreeList.do', $("#cForm").serialize(), '','cmbDepartmentCode', 'S' , '');

        });

        $('#cmbDepartmentCode ').change(function (){
            var paramdata;

            $("#groupCode").val( $(this).val());
            $("#memType").val(memberTypeData);
            $("#memLvl").val(4);

            doGetComboData('/services/hs/getGroupTreeList.do', $("#cForm").serialize(), '','cmbCodeLadyCode', 'S' , '');

        });

 });

           function fn_getOrgChartCdListAjax() {
    var deptIdCd = 0;
    var deptLevelCd = 1;
    var parentIdCd;
    var cmbDeptCode = $('#cmbDepartmentCode').val();
    var cmbGroupIdcd = $('#cmbGroupId').val();
    var cmbOrganiIdCd = $('#cmbOrganizationId').val();
    var cmbMemberTp = memberTypeData;

    if(memberTypeData==1){
        parentIdCd = 124;
    }else {
        cmbMemberTp = 2;
        parentIdCd = 31983;
    }


    if(cmbDeptCode != null && cmbDeptCode.length != 0){//DeptCode 있을때
        deptIdCd = cmbDeptCode;
        deptLevelCd = 3;
        parentIdCd = cmbGroupIdcd;
    }else {//DeptCode 없을때
        if(cmbGroupIdcd != null && cmbGroupIdcd.length !=0){
            deptIdCd = cmbGroupIdcd;
            deptLevelCd = 2;
            parentIdCd =cmbOrganiIdCd;
        }else {
            if(cmbOrganiIdCd != null && cmbOrganiIdCd.length !=0){
                deptIdCd = cmbOrganiIdCd;
                deptLevelCd = 1;
            }
        }
     }

   if(deptIdCd== 0){
        deptIdCd="";
   }

   if($("#cmbGroupId").val() == "" && $("#cmbOrganizationId").val() != ""){
         parentIdCd ="0";
   }


   var memType = $('#memType').val();
   var memLvl = $('#memLvl').val();


   if (memType == "4" ) {
       memType = "2";
       memLvl = "11";
   } else if (memType == "" ) {
       memType = "2";
   }

   var paramCddata;
   //paramHpdata = { groupCode : parentId , memType : cmbMemberTp , memLvl : deptLevel};
   paramCddata = { memType : memType , memLvl : memLvl, groupCode : "", searchDt : $('#searchDt').val()};

   Common.ajax("GET", "/organization/selectOrgChartCdList.do", paramCddata, function(result) {

        if ( memType == "2"  || memType == "4" ) {
            AUIGrid.setGridData(myCdGridID, result);
        }
    });

}


     function fn_doSave(){

         if ($("#cmbCodeLadyCode option:selected").index() < 1){
        	    Common.alert("* Please select the Cody incharge.");
            return false;
       }
              else{

            	  fn_doSaveBasicInfo();
              }
    }


        function  fn_doSaveBasicInfo(){

        var  saveForm ={
                "cmbServiceMem":                  $('#cmbCodeLadyCode').val() ,
                "remark":                              $('#entry_remark').val() ,
                "salesOrderId":                        $('#salesOrderId').val(),
                "schdulId" :                               $('#schdulId').val()
        }

            Common.ajax("POST", "/services/hs/saveHsConfigBasicMultiple.do", saveForm, function(result) {
            console.log("saved.");
            console.log( result);

            Common.alert("<b>CS Configuration successfully saved.</b>", fn_close);
        });

    }

    function fn_close(){
        $("#popup_wrap").remove();
         fn_parentReload();
    }


    function fn_parentReload() {
    	fn_getBSListAjax(); //parent Method (Reload)
    }


</script>

<div id="popup_wrap" class="popup_wrap size_mid" name='cForm'><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Assign CT Member - Group</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#"><spring:message code='expense.CLOSE'/></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

 <form id="cForm" method="post"  name='cForm'>
<%-- <input id="salesOrderId" name="salesOrderId" type="hidden" value="${basicInfo.ordId}"/> --%>
<input type="hidden" name="salesOrderId"  id="salesOrderId" value="${SALEORD_ID}"/>
<input type="hidden" name="custId" id="schdulId" value="${SCHDUL_ID}"/>
<input type="hidden" name="ind" id="ind" value="${IND}"/>
 <input type='hidden' id ='groupCode' name='groupCode'>
 <input type='hidden' id ='memType' name='memType'>
 <input type='hidden' id ='memLvl' name='memLvl'>

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
<th scope="row" >Organization Code</th>
<td><select id ="cmbOrganizationId" nsme = "cmbOrganizationId" class="w100p">
        <option value="">Organization</option>
    </select></td>
</tr>

<tr>
<th scope="row" >Group Code</th>
<td><select id ="cmbGroupId" nsme = "cmbGroupId" class="w100p">
        <option value="">GroupCode</option>
    </select></td>
</tr>

<tr>
<th scope="row" >Department Code</th>
<td><select id ="cmbDepartmentCode" nsme = "cmbDepartmentCode" class="w100p">
         <option value="">Department</option></td>
</tr>

<tr>
<th scope="row" >Code Lady</th>
<td><select id ="cmbCodeLadyCode" nsme = "cmbCodeLadyCode" class="w100p">
         <option value="">CodeLady</option></td>
</tr>

<tr>
    <th scope="row" ><spring:message code='service.title.Remark'/></th>
    <td colspan="3">
     <textarea cols="20" rows="5" id="entry_remark" name="entry_remark" placeholder="" > ${configBasicInfo.configBsRem} </textarea>
</tr>

</tbody>
</table><!-- table end -->

<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#" onclick="fn_doSave()"><spring:message code='service.btn.SAVE'/></a></p></li>
</ul>
</form>

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->