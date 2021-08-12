<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript" language="javascript">

        $(document).ready(function() {

            CommonCombo.make("entry_cmbServiceMem", '/services/bs/selectHSCodyOldList.do', '', '${hsMonthlyConfigOldInfo.bsSetting.memCode}', {isShowChoose: true});

            fn_getHSConfigBasicInfo();

            var configBsGen = ${configBasicInfo.configBsGen}
            $("#entry_availability option[value="+configBsGen +"]").attr("selected", true);
        });


     function fn_getHSConfigBasicInfo(){
            Common.ajax("GET", "/services/bs/getHSMnthlyCnfigOldInfo.do", $("#frmBasicInfo").serialize(), function(result) {
            console.log("getHSMnthlyCnfigOldInfo.");

            console.log("cmbServiceMemList {}" + result);
             });
     }



     function fn_doSave(){

          Common.ajax("GET", "/services/bs/checkMemCode", { hscodyId : $('#entry_cmbServiceMem').val() }, function(result) {
              console.log(result);

              if ( !fn_validBasicInfo() ) {
                  return;
              }

             var checkSuccess = {code: "00", message: "fail"};

              if(JSON.stringify(result) === JSON.stringify(checkSuccess) ) {
                  Common.alert("Not Available to entry in the statue of the cody");
                  return;

              }
              else  fn_doSaveBasicInfo();
           });



    }



     function fn_validBasicInfo(){

          var isValid = true, msg = "";

              if($('#entry_availability').val() <= -1 ){
                    msg += "* Please select the BS availability.<br />";
                    isValid = false;
              }

              if ($('#entry_cmbServiceMem').val() > 1){
                    msg += "* Please select the BS incharge cody.<br />";
                    isValid = false;
              }

              console.log($('#entry_cmbServiceMem'));

              if($('#entry_lstHSDate').val() == "") {
                    $('#entry_lstHSDate').val("01/01/1900");
              }

              if(!isValid){
                    Common.alert("<b>" + message +  DEFAULT_DELIMITER + "<b>"+msg+"</b>")
              };

              return isValid;
    }




      function  fn_doSaveBasicInfo(){

        var hsResultM ={
        		   schdulId  :             $('#schdulId').val(),
                   codyCode:           $('#entry_cmbServiceMem').val()
        }

        var  saveForm ={
            "hsResultM": hsResultM
        }

           Common.ajax("POST", "/services/bs/updateCurrentMonthSettingCody.do", saveForm, function(result) {
            console.log("saved.");
            console.log( result);

            Common.alert("<b>HS result successfully saved.</b>", fn_close);
        });

    }

    function fn_close(){
        $("#popup_wrap").remove();
         fn_parentReload();
    }


    function fn_parentReload() {
        fn_getBasicListAjax(); //parent Method (Reload)
    }

</script>




<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code='service.title.HSManagement'/> - <spring:message code='service.title.Configuration'/> - <spring:message code='service.title.BSCurrentMonthSetting'/></h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#"><spring:message code='expense.CLOSE'/></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

 <form id="frmBasicInfo" method="post">
<input type="hidden" name="schdulId"  id="schdulId" value="${SCHDUL_ID}"/>
<input type="hidden" name="salesOrdId"  id="salesOrdId" value="${salesOrdId}"/>
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:200px" />
    <col style="width:750px" />
</colgroup>
<tbody>
<tr>
    <th scope="row" ><spring:message code='service.title.OrderNo'/></th>
    <td>
    <input type="text" title="" id="entry_bsNo" name="entry_bsNo"  value="${hsMonthlyConfigOldInfo.bsSetting.no}" placeholder="" class="readonly " readonly="readonly" style="width: 300px; " />
    </td>
</tr>
<tr>
    <th scope="row" ><spring:message code='service.title.OrderNo'/></th>
    <td>
    <input type="text" title="" id="entry_ordNo" name="entry_ordNo"  value="${hsMonthlyConfigOldInfo.bsSetting.salesOrdNo}" placeholder="" class="readonly " readonly="readonly" style="width: 300px; " />
    </td>
</tr>
<tr>
    <th scope="row" ><spring:message code='service.title.ApplicationType'/></th>
    <td>
    <input type="text" title="" id="entry_appType" name="entry_appType"  value="${hsMonthlyConfigOldInfo.bsSetting.appType}" placeholder="" class="readonly " readonly="readonly" style="width: 300px; " />
    </td>
</tr>
<tr>
    <th scope="row" ><spring:message code='service.title.CustomerName'/></th>
    <td>
    <input type="text" title="" id="entry_custName" name="entry_custName"  value="${hsMonthlyConfigOldInfo.bsSetting.name}" placeholder="" class="readonly " readonly="readonly" style="width: 450px; "/>
    </td>
</tr>
<tr>
    <th scope="row" ><spring:message code='service.title.NRIC_CompanyNo'/></th>
    <td>
    <input type="text" title="" id="entry_nric" name="entry_nric"  value="${hsMonthlyConfigOldInfo.bsSetting.nric}" placeholder="" class="readonly " readonly="readonly" style="width: 300px; "/>
    </td>
</tr>
<tr>
    <th scope="row" ><spring:message code='service.title.Product'/></th>
    <td>
    <input type="text" title="" id="entry_product" name="entry_product"  value="${hsMonthlyConfigOldInfo.bsSetting.stkCode} - ${hsMonthlyConfigOldInfo.bsSetting.stkDesc}" placeholder="" class="readonly " readonly="readonly" style="width: 300px; "/>
    </td>
</tr>
<tr>
    <th scope="row" ><spring:message code='service.title.InstallationAddress'/></th>
    <td colspan="3">
    <textarea cols="20" rows="5" id="entry_address" name="entry_address" placeholder="" class="readonly " readonly="readonly">${hsMonthlyConfigOldInfo.orderInstallationInfo.instAddrDtl} , ${hsMonthlyConfigOldInfo.orderInstallationInfo.instStreet} , ${hsMonthlyConfigOldInfo.orderInstallationInfo.instArea}, ${hsMonthlyConfigOldInfo.orderInstallationInfo.instPostcode},  ${hsMonthlyConfigOldInfo.orderInstallationInfo.instState}, ${hsMonthlyConfigOldInfo.orderInstallationInfo.instCountry}
    </textarea>
    </td>
</tr>
<tr>
    <th scope="row" ><spring:message code='service.title.HSCodyCode'/></th>
    <td>
        <select class="w100p" id="entry_cmbServiceMem" name="entry_cmbServiceMem"></select>
    </td>
</tr>
</tbody>
</table><!-- table end -->

<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#" onclick="fn_doSave()"><spring:message code='service.btn.SAVE'/></a></p></li>
</ul>
</form>

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->