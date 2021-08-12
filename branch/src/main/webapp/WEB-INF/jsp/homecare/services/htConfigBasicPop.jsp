<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript" language="javascript">
var userId = '${SESSION_INFO.userId}';
var MEM_TYPE     = '${SESSION_INFO.userTypeId}';

//doGetCombo('/services/bs/getHSCody.do?&SRV_SO_ID='+'${configBasicInfo.ordNo}', '', '','entry_cmbServiceMem', 'S' , '');
        $(document).ready(function() {

        	     CommonCombo.make("entry_cmbServiceMem", '/homecare/services/selectHTMemberList.do', { htUserId : userId , entry_orderNo : $("#entry_orderNo").val() , memType : MEM_TYPE}, '${configBasicInfo.c2}', {isShowChoose: true});

           fn_getHSConfigBasicInfo();

               var configBsGen = ${configBasicInfo.configBsGen}
               $("#entry_availability option[value="+configBsGen +"]").attr("selected", true);

        });


      function fn_getHSConfigBasicInfo(){
            Common.ajax("GET", "/homecare/services/getHSConfigBasicInfo.do", $("#frmBasicInfo").serialize(), function(result) {
            console.log("fn_getHSConfigBasicInfo.");

            console.log("cmbServiceMemList {}" + result);
             });
     }



     function fn_doSave(){

          Common.ajax("GET", "/homecare/services/checkMemCode", { hscodyId : $('#entry_cmbServiceMem').val() }, function(result) {
              console.log("::::::::::::::ajax::::::::::::::");
              console.log(result);

              if ( !fn_validBasicInfo() ) {
                  return;
              }

             var checkSuccess = {code: "00", message: "fail"};

              if(JSON.stringify(result) === JSON.stringify(checkSuccess) ) {
                  Common.alert("Not Available to entry in the statue of the HT");
                  return;

              }
              else  fn_doSaveBasicInfo();
           });

    }

     function fn_validBasicInfo(){

          var isValid = true, msg = "";

              if($('#entry_availability').val() <= -1 ){
                    msg += "* Please select the Care Service availability.<br />";
                    isValid = false;
              }

              if ($('#entry_cmbServiceMem').val() <= -1){
                    msg += "* Please select the Homecare Technician incharge.<br />";
                    isValid = false;
              }


              if($('#entry_lstHSDate').val() == "") {
                    $('#entry_lstHSDate').val("01/01/1900");
              }

                    if(!isValid) Common.alert("<b>" + message +  DEFAULT_DELIMITER + "<b>"+msg+"</b>");

                    return isValid;

    }




        function  fn_doSaveBasicInfo(){

        var hsResultM ={
                   availability:                          $("#entry_availability").val(),
                   cmbServiceMem:                  $('#entry_cmbServiceMem').val() ,
                   lstHSDate:                           $('#entry_lstHSDate').val() ,
                   remark:                              $('#entry_remark').val() ,
                   settIns:                              $('#entry_settIns').prop("checked") ? '1': '0' ,
                   settHs:                              $('#entry_settHs').prop("checked") ? '1': '0',
                   settAs:                              $('#entry_settAs').prop("checked") ? '1': '0' ,
                   srvBsWeek:                          $(':input[name=entry_srvBsWeek]:radio:checked').val(),
                   salesOrderId:                        $('#salesOrderId').val(),
                   configId:                             $('#configId').val(),
                   hscodyId:                             $('#hscodyId').val(),
                   srvSoId:                                 $('#entry_orderNo').val(),
                   entry_cmbServiceMem:           $('#entry_cmbServiceMem').val(),
                   schdulId :                               $('#schdulId').val()
        }



        var  saveForm ={
            "hsResultM": hsResultM
        }


            Common.ajax("POST", "/homecare/services/saveHsConfigBasic.do", saveForm, function(result) {
            console.log("saved.");
            console.log( result);

            Common.alert("<b>CS Configuration successfully saved.</b>", fn_close);
            if($('#ind').val() == "1"){
            	 fn_getBSListAjax();
            }
                //Common.alert(result.message, fn_parentReload);
                //fn_DisablePageControl();
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
<h1>Care Service- <spring:message code='service.title.Configuration'/> - <spring:message code='service.title.BasicInfo'/></h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#"><spring:message code='expense.CLOSE'/></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

 <form id="frmBasicInfo" method="post">
<%-- <input id="salesOrderId" name="salesOrderId" type="hidden" value="${basicInfo.ordId}"/> --%>
<input type="hidden" name="salesOrderId"  id="salesOrderId" value="${SALEORD_ID}"/>
<input type="hidden" name="configId"  id="configId" value="${configBasicInfo.configId}"/>
<input type="hidden" name="brnchId"  id="brnchId" value="${BRNCH_ID}"/>
<input type="hidden" name="hscodyId"  id="hscodyId" value="${configBasicInfo.configBsMemId}"/>
<input type="hidden" name="configBsRem"  id="configBsRem" value="${configBasicInfo.configBsRem}"/>
<input type="hidden" name="codyMangrUserId" id="codyMangrUserId" value="${CODY_MANGR_USER_ID}"/>
<input type="hidden" name="custId" id="custId" value="${CUST_ID}"/>
<input type="hidden" name="custId" id="schdulId" value="${SCHDUL_ID}"/>
<input type="hidden" name="ind" id="ind" value="${IND}"/>

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
    <th scope="row" >Care Service Order No</th>
   <%--  <td><span><c:out value="${basicInfo.ordNo}"/></span> --%>
    <td>
    <input type="text" title="" id="entry_orderNo" name="entry_orderNo"  value="${configBasicInfo.ordNo}" placeholder="" class="readonly " readonly="readonly" style="width: 188px; " />
    </td>
    <th scope="row" ><spring:message code='service.title.ApplicationType'/></th>
    <td>
    <input type="text" title="" id="entry_appType" name="entry_appType"  value="${configBasicInfo.appTypeCode}" placeholder="" class="readonly " readonly="readonly" style="width: 157px; "/>
    </td>
</tr>
<tr>
    <th scope="row" >Services Address</th>
    <td colspan="3">
    <input type="text" title="" id="entry_address" name="entry_address"  value="${configBasicInfo.appTypeCode}" placeholder="" class="readonly " readonly="readonly" style="width: 188px; "/>
    </td>
</tr>
<tr>
    <th scope="row" ><spring:message code='service.title.Product'/></th>
    <td>
    <input type="text" title="" id="entry_product" name="entry_product"  value="${configBasicInfo.stock}" placeholder="" class="readonly " readonly="readonly" style="width: 188px; "/>
    </td>
    <th scope="row" ><spring:message code='service.title.CustomerName'/></th>
    <td>
    <input type="text" title="" id="entry_custName" name="entry_custName"  value="${configBasicInfo.custName}" placeholder="" class="readonly " readonly="readonly" style="width: 157px; "/>
    </td>
</tr>
<tr>
    <th scope="row" ><spring:message code='service.title.NRIC_CompanyNo'/></th>
    <td>
    <input type="text" title="" id="entry_nric" name="entry_nric"  value="${configBasicInfo.custNric}" placeholder="" class="readonly " readonly="readonly" style="width: 188px; "/>
    </td>
    <th scope="row" >CS Availability</th>
    <td>
<%--    <input type="text" title="" id="entry_availability" name="entry_availability"  value="${BasicInfo.custNric}" placeholder="" class="readonly " readonly="readonly" style="width: 464px; "/> --%>
    <select class="w100p" id="entry_availability" name="entry_availability">
        <option value="1">Available</option>
        <option value="0">Unavailable</option>
    </select>

    </td>
</tr>
<tr>
    <th scope="row" >Homecare Technician Code</th>
    <td>
        <!-- <input type="text" id="entry_cmbServiceMem" name="entry_cmbServiceMem" title="Member Code"  class="w100p" /> -->
        <select class="w100p" id="entry_cmbServiceMem" name="entry_cmbServiceMem">
        <!-- <option value="" selected="selected">dd</option>-->
        </select>
    </td>
    <th scope="row" >Last CS Date</th>
    <td>
    <input type="text" id="entry_lstHSDate" name="entry_lstHSDate" title="Create start Date" value="${configBasicInfo.c4}" placeholder="DD/MM/YYYY"  class="readonly " readonly="readonly"  />
    </td>
</tr>
<tr>
    <th scope="row" ><spring:message code='service.title.Remark'/></th>
    <td colspan="3">
     <textarea cols="20" rows="5" id="entry_remark" name="entry_remark" placeholder="" > ${configBasicInfo.configBsRem} </textarea>
</tr>
<%-- <tr>
    <th scope="row" ><spring:message code='service.title.HappyCallService'/></th>
    <td colspan="3">
    <label><input type="checkbox" id="entry_settIns" name="entry_settIns" <c:if test="${configBasicInfo.configSettIns == 1}">checked</c:if> /><span>Installation Type</span></label>
    <label><input type="checkbox" id="entry_settHs" name="entry_settHs" <c:if test="${configBasicInfo.configSettBs == 1}">checked</c:if>/><span>BS Type</span></label>
    <label><input type="checkbox" id="entry_settAs" name="entry_settAs" <c:if test="${configBasicInfo.configSettAs == 1}">checked</c:if>/><span>AS Type</span></label>
    </td>
</tr> --%>
<tr>
    <th scope="row" >Prefer CS Week</th>
    <td colspan="3">
    <label><input type="radio" id="entry_srvBsWeek" name="entry_srvBsWeek" value="0" <c:if test="${configBasicInfo.configBsWeek == 0}">checked</c:if> disabled/><span>None</span></label>
    <label><input type="radio" id="entry_srvBsWeek" name="entry_srvBsWeek" value="1" <c:if test="${configBasicInfo.configBsWeek == 1}">checked</c:if>/><span>Week 1</span></label>
    <label><input type="radio" id="entry_srvBsWeek" name="entry_srvBsWeek" value="2" <c:if test="${configBasicInfo.configBsWeek == 2}">checked</c:if>/><span>Week 2</span></label>
    <label><input type="radio" id="entry_srvBsWeek" name="entry_srvBsWeek" value="3" <c:if test="${configBasicInfo.configBsWeek == 3}">checked</c:if>/><span>Week 3</span></label>
    <label><input type="radio" id="entry_srvBsWeek" name="entry_srvBsWeek" value="4" <c:if test="${configBasicInfo.configBsWeek == 4}">checked</c:if>/><span>Week 4</span></label>
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