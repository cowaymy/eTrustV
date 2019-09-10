<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript" language="javascript">
var userId = '${SESSION_INFO.userId}';
var MEM_TYPE     = '${SESSION_INFO.userTypeId}';

//doGetCombo('/services/bs/getHSCody.do?&SRV_SO_ID='+'${configBasicInfo.ordNo}', '', '','entry_cmbServiceMem', 'S' , '');
        $(document).ready(function() {

                 CommonCombo.make("entry_cmbServiceMem", '/homecare/services/selectHTMemberList.do', '','', {isShowChoose: true});

        });


     function fn_doSave(){

         if ($("#entry_cmbServiceMem option:selected").index() < 1){
        	    Common.alert("* Please select the Homecare Technician incharge.");
            return false;
       }
              else{

            	  fn_doSaveBasicInfo();

              }
    }


        function  fn_doSaveBasicInfo(){

        var  saveForm ={
                "cmbServiceMem":                  $('#entry_cmbServiceMem').val() ,
                "remark":                              $('#entry_remark').val() ,
                "salesOrderId":                        $('#salesOrderId').val(),
                "schdulId" :                               $('#schdulId').val()
        }

            Common.ajax("POST", "/homecare/services/saveHsConfigBasicMultiple.do", saveForm, function(result) {
            console.log("saved.");
            console.log( result);

            Common.alert("<b>CS Configuration successfully saved.</b>", fn_close);

                 fn_getBSListAjax();

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
<h1>Assign HT Member - Group</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#"><spring:message code='expense.CLOSE'/></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

 <form id="frmBasicInfo" method="post">
<%-- <input id="salesOrderId" name="salesOrderId" type="hidden" value="${basicInfo.ordId}"/> --%>
<input type="hidden" name="salesOrderId"  id="salesOrderId" value="${SALEORD_ID}"/>
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
    <th scope="row" >Homecare Technician Code</th>
    <td>
        <!-- <input type="text" id="entry_cmbServiceMem" name="entry_cmbServiceMem" title="Member Code"  class="w100p" /> -->
        <select class="w100p" id="entry_cmbServiceMem" name="entry_cmbServiceMem">
        <!-- <option value="" selected="selected">dd</option>-->
        </select>
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