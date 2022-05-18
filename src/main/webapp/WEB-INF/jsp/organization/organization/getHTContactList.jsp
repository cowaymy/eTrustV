<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>


<script type="text/javaScript">


    $(document).ready(function() {
    	doGetComboData('/organization/selectHTOrgCode.do', null, true, 'cmbOrgCode', 'S','');
    	doGetComboData('/organization/selectHTGroupCode.do', null, true, 'cmbGrpCode', 'S','');
    	doGetComboData('/organization/selectHTDeptCode.do', null, true, 'cmbDeptCode', 'S','');
    	doGetCombo('/organization/selectStatusList.do', '', '', 'cmbStatusList', 'M', 'f_multiComboType');
    	doGetCombo('/organization/selectPositionList.do', '', '', 'cmbPositionList', 'M', 'f_multiComboType');
    });

  //btn clickevent
    $(function(){
        $('#cmbOrgCode').change(function(){
            var cmbOrgCode = $('#cmbOrgCode').val();
            doGetComboData('/organization/selectHTGroupCode.do', {orgCode: cmbOrgCode}, true, 'cmbGrpCode', 'S','');
        });

        $('#cmbGrpCode').change(function(){
        	var cmbOrgCode = $('#cmbOrgCode').val();
            var cmbGrpCode = $('#cmbGrpCode').val();

            doGetComboData('/organization/selectHTDeptCode.do', {orgCode: cmbOrgCode, grpCode : cmbGrpCode}, true, 'cmbDeptCode', 'S','');
        });


    });

    $.fn.clearForm = function() {
        return this.each(function() {
            var type = this.type, tag = this.tagName.toLowerCase();
            if (tag === 'form'){
                return $(':input',this).clearForm();
            }
            if (type === 'text' || type === 'password'  || tag === 'textarea'){
                if($("#"+this.id).hasClass("readonly")){

                }else{
                    this.value = '';
                }
            }else if (type === 'checkbox' || type === 'radio'){
                this.checked = false;

            }else if (tag === 'select'){
                if($("#memType").val() != "7"){ //check not HT level
                     this.selectedIndex = 0;
                }
            }

            $("#cmbPositionList").multipleSelect("uncheckAll");
            $("#cmbStatusList").multipleSelect("uncheckAll");
        });
    };

    function f_multiComboType() {
        $(function() {
            $('#cmbStatusList').change(function() {
            }).multipleSelect({
                selectAll : true
            });
            $('#cmbPositionList').change(function() {
            }).multipleSelect({
                selectAll : true
            });
        });
    }

    function fn_report(){

            var orgCode = null;
            var grpCode = null;
            var deptCode = null;
            var position = null;
            var status = null;



            if(!($("#cmbOrgCode").val() == null || $("#cmbOrgCode").val().length == 0)){
            	orgCode = $("#cmbOrgCode").val();
            }

            if(!($("#cmbGrpCode").val() == null || $("#cmbGrpCode").val().length == 0)){
            	grpCode = $("#cmbGrpCode").val();
            }

            if(!($("#cmbDeptCode").val() == null || $("#cmbDeptCode").val().length == 0)){
            	deptCode = $("#cmbDeptCode").val();
            }

            if(!($("#cmbPositionList").val() == null || $("#cmbPositionList").val().length == 0)){
            	position = $("#cmbPositionList").val();
            }

            if(!($("#cmbStatusList").val() == null || $("#cmbStatusList").val().length == 0)){
            	status = $("#cmbStatusList").val();
            }


            $("#form #V_ORGCODE").val(orgCode);
            $("#form #V_GRPCODE").val(grpCode);
            $("#form #V_DEPTCODE").val(deptCode);
            $("#form #V_POSITION").val(position);
            $("#form #V_STATUS").val(status);


            var date = new Date().getDate();

            if (date.toString().length == 1) {
                date = "0" + date;
            }

             $("#form #viewType").val("EXCEL");
             $("#form #reportFileName").val("/organization/HTContactList.rpt");
             console.log($("#form #reportFileName").val());

             $("#form #reportDownFileName").val("HTContactList_" + date + (new Date().getMonth() + 1) + new Date().getFullYear());

               // 프로시져로 구성된 경우 꼭 아래 option을 넘겨야 함.
              var option = {
                   isProcedure : true
               // procedure 로 구성된 리포트 인경우 필수.
               };

                Common.report("form", option);
        }

</script>

<div id="popup_wrap" class="popup_wrap size_mid"><!-- popup_wrap start -->
    <header class="pop_header"><!-- pop_header start -->
    <h1>HT Organization Contact List</h1>
    <ul class="right_opt">
        <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
    </ul>
    </header><!-- pop_header end -->

    <section class="pop_body"><!-- pop_body start -->
        <form  id="form" name="form" >
            <table class="type1">
                <caption>table</caption>
                <colgroup>
                    <col style="width: 200px" />
                    <col style="width: *" />
                </colgroup>

                <tbody>
				<tr>
				    <th scope="row">Org Code</th>
				    <td>
				      <select class="w100p" id="cmbOrgCode" name="cmbOrgCode"></select>
				    </td>
				</tr>
				<tr>
				    <th scope="row">Group Code</th>
				    <td>
				    <select class="w100p" id="cmbGrpCode" name="cmbGrpCode"></select>
				    </td>
				</tr>
				<tr>
				    <th scope="row">Dept Code</th>
				    <td>
				     <select class="w100p" id="cmbDeptCode" name="cmbDeptCode"></select>
				    </td>
				</tr>
				<tr>
				    <th scope="row">Position</th>
				    <td>
				    <select id="cmbPositionList" name="cmbPositionList" class="multy_select w100p" multiple="multiple"></select>
				    </td>
				</tr>
				<tr>
				    <th scope="row">Status</th>
				    <td>
                    <select id="cmbStatusList" name="cmbStatusList" class="multy_select w100p" multiple="multiple"></select>
				    </td>
				</tr>
                </tbody>
           </table>
			<input type="hidden" id="reportFileName" name="reportFileName" value="/organization/HTContactList.rpt" />
			<input type="hidden" id="viewType" name="viewType" value="EXCEL" />
			<input type="hidden" id="reportDownFileName" name="reportDownFileName" value="" />

			<input type="hidden" id="V_ORGCODE" name="V_ORGCODE" value="">
			<input type="hidden" id="V_GRPCODE" name="V_GRPCODE" value="">
			<input type="hidden" id="V_DEPTCODE" name="V_DEPTCODE" value="">
			<input type="hidden" id="V_POSITION" name="V_POSITION" value="">
			<input type="hidden" id="V_STATUS" name="V_STATUS" value="">


      </form>
                <ul class="center_btns">
                <li><p class="btn_blue2 big"><a href="#" onclick="javascript: fn_report()">Generate Excel</a></p></li>
                <li><p class="btn_blue2 big"><a id="btnClear" href="#" onclick="javascript:$('#form').clearForm();"><spring:message code='sales.Clear'/></a></p></li>
            </ul>
   </section>
</div><!-- popup_wrap end -->