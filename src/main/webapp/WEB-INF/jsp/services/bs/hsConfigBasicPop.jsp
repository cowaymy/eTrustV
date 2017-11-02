<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript" language="javascript">


	    $(document).ready(function() {
	    

	       fn_getHSConfigBasicInfo();
	    
	    
               var configBsGen = ${configBasicInfo.configBsGen}
               $("#entry_availability option[value="+configBsGen +"]").attr("selected", true);	    
	    
	    
	    });
    
    
     function fn_getHSConfigBasicInfo(){
            Common.ajax("GET", "/services/bs/getHSConfigBasicInfo.do", $("#frmBasicInfo").serialize(), function(result) {
            console.log("fn_getHSConfigBasicInfo.");
            
            console.log("cmbServiceMemList {}" + result);
             });
     }
     
     
    
     function fn_doSave(){
     
          if (! fn_validBasicInfo()) {
                 return ;
          }
        

        fn_doSaveBasicInfo();
        
    }
    
    
    
     function fn_validBasicInfo(){
    
	      var isValid = true, msg = "";
	
	          if($('#entry_availability').val() <= -1 ){
	                msg += "* Please select the BS availability.<br />";
	                isValid = false;
	          }
	          
	          if ($('#entry_cmbServiceMem').val() <= -1){
	                msg += "* Please select the BS incharge cody.<br />";
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
                   configId:                             $('#configId').val()
        }
    
    
    
        var  saveForm ={
            "hsResultM": hsResultM 
        }
    
    
            Common.ajax("POST", "/services/bs/saveHsConfigBasic.do", saveForm, function(result) {
            console.log("saved.");
            console.log( result);       
            
            Common.alert("<b>HS result successfully saved.</b>", fn_close);
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
    
    
 /*     $('#btnSaveBasicInfo').click(function() {  

        if(!fn_hsBasicSave()) return false;            

         //   fn_doSaveBasicInfo();
         
           alert(222222222);
        Common.ajax("POST", "/services/saveHsConfigBasic.do",  $("#frmBasicInfo").serializeJSON(), function(result) {
                        Common.alert("BS basic info setting successfully updated." + DEFAULT_DELIMITER + "<b>"+result.message+"</b>", fn_reloadPage);
            
            }, function(jqXHR, textStatus, errorThrown) {
                try {
                    Common.alert("Failed to save. Please try again later." + DEFAULT_DELIMITER + "<b>Failed To Save.<br />"+"Error message : " + jqXHR.responseJSON.message + "</b>");
                }
                catch(e) {
                    console.log(e);
                }
            }                    
        }); 
        
    } */
     

            
</script>




<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>HS Management - Configuration - Basic Info</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

 <form id="frmBasicInfo" method="post">
<%-- <input id="salesOrderId" name="salesOrderId" type="hidden" value="${basicInfo.ordId}"/> --%>
<input type="hidden" name="salesOrderId"  id="salesOrderId" value="${SALEORD_ID}"/>  
<input type="hidden" name="configId"  id="configId" value="${configBasicInfo.configId}"/>

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
    <th scope="row" >Order No</th>
   <%--  <td><span><c:out value="${basicInfo.ordNo}"/></span> --%>
    <td>
    <input type="text" title="" id="entry_orderNo" name="entry_orderNo"  value="${configBasicInfo.ordNo}" placeholder="" class="readonly " readonly="readonly" style="width: 188px; " />
    </td>
    <th scope="row">Application Type</th>
    <td>
    <input type="text" title="" id="entry_appType" name="entry_appType"  value="${configBasicInfo.appTypeCode}" placeholder="" class="readonly " readonly="readonly" style="width: 157px; "/>
    </td>
</tr>
<tr>
    <th scope="row">Installation Address</th>
    <td colspan="3">
    <input type="text" title="" id="entry_address" name="entry_address"  value="${configBasicInfo.appTypeCode}" placeholder="" class="readonly " readonly="readonly" style="width: 188px; "/>
    </td>
</tr>
<tr>
    <th scope="row">Product</th>
    <td>
    <input type="text" title="" id="entry_product" name="entry_product"  value="${configBasicInfo.stock}" placeholder="" class="readonly " readonly="readonly" style="width: 188px; "/>
    </td>
    <th scope="row">Customer Name</th>
    <td>
    <input type="text" title="" id="entry_custName" name="entry_custName"  value="${configBasicInfo.custName}" placeholder="" class="readonly " readonly="readonly" style="width: 157px; "/>    
    </td>
</tr>
<tr>
    <th scope="row">NRIC/Company No</th>
    <td>
    <input type="text" title="" id="entry_nric" name="entry_nric"  value="${configBasicInfo.custNric}" placeholder="" class="readonly " readonly="readonly" style="width: 188px; "/>
    </td>
    <th scope="row">HS Availability</th>
    <td>
<%--    <input type="text" title="" id="entry_availability" name="entry_availability"  value="${BasicInfo.custNric}" placeholder="" class="readonly " readonly="readonly" style="width: 464px; "/> --%>
    <select class="w100p" id="entry_availability" name="entry_availability">
        <option value="1">Available</option>
        <option value="0">Unavailable</option>
    </select>
    
    </td>
</tr>
<tr>
    <th scope="row">HS Cody Code</th>
    <td>
    <select class="w100p"  id="entry_cmbServiceMem" name="entry_cmbServiceMem" >
       <c:forEach var="list" items="${serMemList}" varStatus="status">
            <option value="${list.codeId}"> ${list.codeName } </option>
       </c:forEach> 
    </select>
    </td>
    <th scope="row">Last HS Date</th>
    <td>
    <input type="text" id="entry_lstHSDate" name="entry_lstHSDate" title="Create start Date" value="${configBasicInfo.c4}" placeholder="DD/MM/YYYY" class="j_date" />
    </td>
</tr>
<tr>
    <th scope="row">Remark</th>
    <td colspan="3">
    <textarea cols="20" rows="5" id="entry_remark" name="entry_remark" placeholder="" value="${configBasicInfo.configBsRem}"></textarea>
    </td>
</tr>
<tr>
    <th scope="row">Happy Call Service</th>
    <td colspan="3">
    <label><input type="checkbox" id="entry_settIns" name="entry_settIns" <c:if test="${configBasicInfo.configSettIns == 1}">checked</c:if> /><span>Installation Type</span></label>
    <label><input type="checkbox" id="entry_settHs" name="entry_settHs" <c:if test="${configBasicInfo.configSettBs == 1}">checked</c:if>/><span>BS Type</span></label>
    <label><input type="checkbox" id="entry_settAs" name="entry_settAs" <c:if test="${configBasicInfo.configSettAs == 1}">checked</c:if>/><span>AS Type</span></label>
    </td>
</tr>
<tr>
    <th scope="row">Prefer HS Week</th>
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
    <li><p class="btn_blue2 big"><a href="#" onclick="fn_doSave()">SAVE</a></p></li>
</ul>
</form> 

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->