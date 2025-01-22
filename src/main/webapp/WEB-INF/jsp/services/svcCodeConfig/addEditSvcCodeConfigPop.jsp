<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<style>
  .my-row-style {
      background:#FFB2D9;
      font-weight:bold;
      color:#22741C;
  }
</style>

<script type="text/javaScript" language="javascript">
  var msg = "";
  var prdCtgry = '${codeMgmtMap.prodCat}';
  var statusId = '${codeMgmtMap.stusId}';

  $(document).ready(function(){
    doGetCombo('/services/svcCodeConfig/selectProductCategoryList.do', '', '${codeMgmtMap.prodCat}', 'productCtgryNew', 'S',);
    doGetCombo('/services/svcCodeConfig/selectStatusCategoryCodeList.do','',statusId,'dftPrtStatus','S','');

    fn_viewType("${viewType}");

    $('#nc_close').click(function() {
      fn_saveclose();
    });
  });

  function  fn_viewType(type){
    type = "${viewType}";

    if(type == 1){
      $("#status").hide();
      $('#btn_save').show();
    } else if (type == 2 || type == 3) { // Edit or View
      $("#productCtgryNew option[value='"+ prdCtgry + "']").attr("selected", true);
      $("#dftPrtCde").val('${codeMgmtMap.defectCode}');
      $("#dftPrtDesc").val('${codeMgmtMap.defectDesc}');
      $("#dftPrtRemark").val('${codeMgmtMap.defectRemark}');
      $("#dftPrtStatus option[value="+statusId +"]").attr("selected", true);
      $("#effectiveDt").val('${codeMgmtMap.effDt}');
      $("#expireDt").val('${codeMgmtMap.expDt}');
      $("#hidDefectId").val('${codeMgmtMap.defectId}');
      $("#hidDefectGrp").val('${codeMgmtMap.defectGrp}');
    }

    if (type == 2){ //Edit and New
      $("#status").show();
      $('#btn_save').show();
    }

    if (type == 3){ //View
      $("#productCtgryNew").prop("disabled", true);
      $("#dftPrtCde").prop("disabled", true);
      $("#dftPrtDesc").prop("disabled", true);
      $("#dftPrtRemark").prop("disabled", true);
      $("#status").show();
      $("#dftPrtStatus").prop("disabled", true);
      $("#effectiveDt").prop("disabled", true);
      $("#expireDt").prop("disabled", true);

      $('#btn_save').hide();
    }
  }

  function fn_save(){
    var flag = false;
    var type = "${viewType}";

    if(fn_validate()){
      if(msg != "") {
        Common.alert(msg);
        flag = true;
      }
    }

    if(!flag){
      fn_saveNewCode();
    }
  }

  function fn_validate(){
    msg = "";
    var viewType = "${viewType}";

    if($("#productCtgryNew").val() == ""){
      msg += "* Please select a product category <br>";
    }

    if($("#dftPrtCde").val() == ""){
      msg += "* Please enter defect part code <br>";
    }

    if($("#dftPrtDesc").val() == ""){
      msg += "* Please enter defect part description <br>";
   }

    if($("#dftPrtRemark").val() == ""){
      msg += "* Please enter defect part remark <br>";
    }

    if($("#effectiveDt").val() == ""){
      msg += "* Please select effective date <br>";
    }

    if($("#expireDt").val() == ""){
      msg += "* Please select expire date <br>";
     }
    return msg;
  }

  function fn_saveNewCode(){
    var newDpCodeConfig = {
      viewType : '${viewType}',
      productCtgry : $("#productCtgryNew").val(),
      dftPrtCde : $("#dftPrtCde").val(),
      dftPrtDesc : $("#dftPrtDesc").val(),
      dftPrtRemark : $("#dftPrtRemark").val(),
      stus : '${viewType}' == 2 ? $("#dftPrtStatus").val() : '',
      effectiveDt : $("#effectiveDt").val(),
      expireDt : $("#expireDt").val(),
      hidDefectId : $("#hidDefectId").val(),
      hidDefectGrp : $("#hidDefectGrp").val()
    }

    var saveForm = {
      "newDpCodeConfig" :  newDpCodeConfig
    }

    Common.ajax("POST", "/services/svcCodeConfig/saveNewCode.do", saveForm, function(result) {
       Common.alert(result.message, fn_saveclose);
       $("#popup_wrap").remove();
       fn_selectSvcCodeConfigList();
    });
  }

  function fn_saveclose() {
    addSvcCodeConfigPopupId.remove();
  }
</script>

<div id="popup_wrap" class="popup_wrap "><!-- popup_wrap start -->
  <header class="pop_header"><!-- pop_header start -->
    <h1>
      <c:if test="${viewType eq  '1' }"> New Service Defect Part Code Configuration</c:if>
      <c:if test="${viewType eq  '2' }"> Edit Service Defect Part Code Configuration</c:if>
      <c:if test="${viewType eq  '3' }"> View Service Defect Part Code Configuration</c:if>
    </h1>
    <ul class="right_opt">
        <li><p class="btn_blue2"><a href="#" id="nc_close"><spring:message code="sys.btn.close" /></a></p></li>
    </ul>
  </header>
  <section class="pop_body" style="height:450px"><!-- pop_body start -->
    <form action="#"   id="sForm"  name="saveForm" method="post" onsubmit="return false;">
      <section class="search_table"><!-- search_table start -->
        <form action="#" method="post"  id='collForm' name ='collForm'>
          <div style="display: none">
            <input type="text" name="hidDefectId" id="hidDefectId"/>
            <input type="text" name="hidDefectGrp" id="hidDefectGrp"/>
          </div>
          <table class="type1">
            <caption>table</caption>
            <colgroup>
              <col style="width:250px" />
              <col style="width:*" />
            </colgroup>
            <tbody>
              <tr>
                <th scope="row"><spring:message code="sal.title.text.productCategory" /></th>
                <td>
                    <select class="w100p" id="productCtgryNew" name="productCtgryNew" ></select>
                </td>
              </tr>
              <tr>
                <th scope="row"><spring:message code="service.text.dftPrtCde" /></th>
                <td><input type="text" title="" class="w100p"  id="dftPrtCde"  name="dftPrtCde" /></td>
              </tr>
              <tr>
                <th scope="row"><spring:message code="service.text.dftPrtDesc" /></th>
                <td><input type="text" title=""  class="w100p"  id="dftPrtDesc"  name="dftPrtDesc" /></td>
              </tr>
              <tr>
                <th scope="row"><spring:message code="service.text.dftPrtRemark" /></th>
                <td><input type="text" title=""  class="w100p"  id="dftPrtRemark"  name="dftPrtRemark" /></td>
              </tr>
              <tr id="status">
                <th scope="row"><spring:message code="service.title.Status"/></th>
                <td>
                  <select class="w100p" id="dftPrtStatus" name="dftPrtStatus" ></select>
                </td>
              </tr>
              <tr>
                <th scope="row"><spring:message code="svc.title.text.effectiveDate"/></th>
                <td><input type="text" title="Effective Date" placeholder="DD/MM/YYYY" class="w100p j_date" id="effectiveDt" /></td>
              </tr>
              <tr>
                <th scope="row"><spring:message code="svc.title.text.expireDate"/></th>
                <td><input type="text" title="Expire Date" placeholder="DD/MM/YYYY" class="w100p j_date" id="expireDt" /></td>
              </tr>
            </tbody>
          </table>
       </form>
     </section>
      <ul class="center_btns">
          <li><p class="btn_blue2"><a href="#" id="btn_save" onclick="javascript:fn_save()"><spring:message code="sys.btn.save" /></a></p></li>
      </ul>
    </form>
  </section>
 </section>
</section>
</div>
