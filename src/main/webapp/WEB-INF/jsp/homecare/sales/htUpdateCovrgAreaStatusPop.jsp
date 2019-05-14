<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript" language="javascript">
var userId = '${SESSION_INFO.userId}';
var MEM_TYPE     = '${SESSION_INFO.userTypeId}';

//doGetCombo('/services/bs/getHSCody.do?&SRV_SO_ID='+'${configBasicInfo.ordNo}', '', '','entry_cmbServiceMem', 'S' , '');
        $(document).ready(function() {

                 //CommonCombo.make("entry_cmbServiceMem", '/homecare/services/selectHTMemberList.do', { htUserId : userId , entry_orderNo : $("#entry_orderNo").val() , memType : MEM_TYPE}, '${configBasicInfo.c2}', {isShowChoose: true});

        	 var stusCodeId = ${covrgAreaList.stusCodeId}
             $("#cmbStatus option[value="+stusCodeId +"]").attr("selected", true);
        });






     function fn_doSave(){

    	 fn_doSaveCovrgArea();

    }



        function  fn_doSaveCovrgArea(){

        	var areaCovrgId = ${covrgAreaList.areaCovrgId}
        	var areaId = $("#area_Id").val();

        	   var covrgArea ={

                       areaCovrgId :                             areaCovrgId,
                       areaId :                                     areaId,
                      stusCodeId :                        $("#cmbStatus").val(),
                       remark :                               $("#remark").val()
            }



                Common.ajax("POST", "/homecare/sales/updateCovrgAreaStatus.do", covrgArea, function(result) {
                console.log("saved.");
                console.log( result);

                Common.alert("<b>Coverage Area ID : "+ areaId + " status updated successfully.</b>", fn_close);
                    //Common.alert(result.message, fn_parentReload);
                    //fn_DisablePageControl();
            });



        }





    function fn_close(){
        $("#popup_wrap").remove();
         fn_parentReload();
    }


    function fn_parentReload() {
    	fn_searchCurrentCovrgArea(); //parent Method (Reload)
    }


</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Coverage Area Edit </h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#"><spring:message code='expense.CLOSE'/></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

 <form id="frmHTCovrgArea" method="post">
<%-- <input id="salesOrderId" name="salesOrderId" type="hidden" value="${basicInfo.ordId}"/> --%>
<input type="hidden" name="area_Id"  id="area_Id" value="${covrgAreaList.areaId}"/>


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
    <th scope="row" >Area ID</th>
   <%--  <td><span><c:out value="${basicInfo.ordNo}"/></span> --%>
    <td>
    <input type="text" title="" id="areaId" name="area_id"  value="${covrgAreaList.areaId}" placeholder="" class="readonly " readonly="readonly" />
    </td>
    <th scope="row" >Area</th>
    <td>
    <input type="text" title="" id="area" name="area"  value="${covrgAreaList.area}" placeholder="" class="readonly " readonly="readonly" />
    </td>
</tr>
<tr>
    <th scope="row" >City</th>
    <td colspan="3">
    <input type="text" title="" id="city" name="city"  value="${covrgAreaList.city}" placeholder="" class="readonly " readonly="readonly" />
    </td>
</tr>
<tr>
    <th scope="row" >State</th>
    <td>
    <input type="text" title="" id="state" name="state"  value="${covrgAreaList.state}" placeholder="" class="readonly " readonly="readonly" />
    </td>
    <th scope="row" >Postcode</th>
    <td>
    <input type="text" title="" id="postcode" name="postcode"  value="${covrgAreaList.postcode}" placeholder="" class="readonly " readonly="readonly" />
    </td>
</tr>
<tr>
    <th scope="row" >Status</th>
    <td>
    <select class="w100p" id="cmbStatus" name="status">
        <option value="1">Active</option>
        <option value="8">Inactive</option>
    </select>

    </td>
</tr>

<tr>
    <th scope="row" ><spring:message code='service.title.Remark'/></th>
    <td colspan="3">
     <textarea cols="20" rows="5" id="remark" name="remark" placeholder="" > ${covrgAreaList.areaRem} </textarea>
</tr>


</tbody>
</table><!-- table end -->

<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#" onclick="fn_doSave()"><spring:message code='service.btn.SAVE'/></a></p></li>
</ul>
</form>

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->