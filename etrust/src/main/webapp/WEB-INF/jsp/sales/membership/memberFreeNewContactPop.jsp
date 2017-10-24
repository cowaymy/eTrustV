<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>


<script type="text/javaScript" language="javascript">


$(document).ready(function(){
	 doGetCombo('/common/selectCodeList.do', '17', '','NEW_INITIALl', 'S' , 'f_multiCombo');  
	 doGetCombo('/common/selectCodeList.do', '2', '','NEW_RACE', 'S' , 'f_multiCombo');  
	 
	   //j_date
	    var pickerOpts={
	            changeMonth:true,
	            changeYear:true,
	            dateFormat: "dd/mm/yy"
	    };
	    
	    $(".j_date").datepicker(pickerOpts);


	 
});

//save.
function fn_doSaveAjax() {        
	
	if(fn_saveValidationCheck()){
		   
		$("#NEW_CUST_ID").val($("#CUST_ID").val())
		Common.ajax("GET", "/sales/membership/membershipNewContatSave", $("#contactForm").serialize(), function(result) {
			   console.log( result);
			   Common.alert(result.message, fn_getDataCPerson);
			   $("#n_close").click();
	     });  
	}
    
}



// Validation Check
function fn_saveValidationCheck(){

	
	
    if($("#NEW_INITIALl").val() == ''){
        Common.alert("Please select  inital type");
        return false;
    }
    
    if($("#NEW_RACE").val() == ''){
        Common.alert("Please select  race type");
        return false;
    }
    
    if($("#NEW_NAME").val() == ''){
        Common.alert("Please key in  name");
        return false;
    }
    
    if($("#NEW_GENDER").val() == ''){
    	   Common.alert("Please select  gender type");
        return false;
    }
    
    if($("#NEW_NRIC").val() == ''){
        //Common.alert("Please key in NRIC/Company number");
        //return false;
    }else{
        if(FormUtil.checkNum($("#NEW_NRIC"))){
            Common.alert("* Invalid nric number.");
            return;
        }
    }
        
    if($("#NEW_TELM1").val() == '' && $("#NEW_TELMR").val() == '' && $("#NEW_TELMF").val() == '' && $("#NEW_TELMO").val() == '' ){
        Common.alert("Please key in at least one contact number");
        return false;
    }else{
        if($("#NEW_TELM1").val() != ''){
            if(FormUtil.checkNum($("#NEW_TELM1"))){
                Common.alert("* Invalid telephone number (Mobile).");
                return false;
            }
            if($("#NEW_TELM1").length > 20){
                Common.alert("* Telephone number (Mobile) exceed length of 20.");
                return false;
            }
        }
        if($("#NEW_TELMO").val() != ''){

               if(FormUtil.checkNum($("#NEW_TELMO"))){
                   Common.alert("* Invalid telephone number (Office).");
                   return false;
               }
               if($("#NEW_TELMO").length > 20){
                   Common.alert("* Telephone number (Office) exceed length of 20.");
                   return false;
               }
           }
        if($("#NEW_TELMR").val() != ''){
               if(!FormUtil.checkNum($("#NEW_TELMR"))){
                   Common.alert("* Invalid telephone number (Office).");
                   return false;
               }
               if($("#NEW_TELMR").length > 20){
                   Common.alert("* Telephone number (Office) exceed length of 20.");
                   return false;
               }
           }
        if($("#NEW_TELMF").val() != ''){
               if(!FormUtil.checkNum($("#NEW_TELMF"))){
                   Common.alert("* Invalid telephone number (Office).");
                   return false;
               }
               if($("#NEW_TELMF").length > 20){
                   Common.alert("* Telephone number (Office) exceed length of 20.");
                   return false;
               }
           }
    }
    
    if($("#NEW_DOB").val() == ''){
        Common.alert("* Please key in  DOB.");
        return false;
    }
    
    
    if( $("#NEW_EMAIL").val() !=""){
    	  if(FormUtil.checkEmail($("#NEW_EMAIL").val())){
    	        Common.alert("* Invalid email address.");
    	        return false;
    	    }
    }
    
  
    
    return true;
}


function fn_doClear() {

}



</script>


<form id="contactForm" name="contactForm">
<input type="hidden"  id="NEW_CUST_ID"  name="NEW_CUST_ID"/>
<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Contact Person Search</h1>
<ul class="right_opt">
	<li><p class="btn_blue2"><a href="#" id="n_close">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->


<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:110px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:120px" />
    <col style="width:*" />
    <col style="width:100px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Initial <span class="must">*</span></th>
    <td>
    <select class="w100p"  id='NEW_INITIALl' name='NEW_INITIALl'>
    </select>
    </td>
    <th scope="row">Name <span class="must">*</span></th>
    <td colspan="3">
    <input type="text" title=""  id='NEW_NAME' name ="NEW_NAME" placeholder="" class="w100p" />
    </td>
    <th scope="row">Gender <span class="must">*</span> </th>
    <td>
    <select class="w100p"  id='NEW_GENDER'  name='NEW_GENDER'>
        <option value='M'>M - Male </option>
        <option value='F' >F - Female </option>
    </select>
    </td>
</tr>
<tr>
    <th scope="row">DOB <span class="must">*</span></th>
    <td>
      <input type="text" title="Create start Date"   id="NEW_DOB" name="NEW_DOB" placeholder="DD/MM/YYYY" class="j_date w100p" />
    
    </td>
    <th scope="row">NRIC</th>
    <td colspan="3">
    <input type="text" title="" id='NEW_NRIC' name='NEW_NRIC' placeholder="" class="w100p" />
    </td>
    <th scope="row">Race <span class="must">*</span></th>
    <td>
    <select class="w100p" id='NEW_RACE' name='NEW_RACE' >
    </select>
    </td>
</tr>
<tr>
    <th scope="row">Post</th>
    <td colspan="3">
    <input type="text" title="" placeholder="" class="w100p"  id='NEW_POST' name='NEW_POST' />
    </td>
    <th scope="row">Department</th>
    <td colspan="3">
    <input type="text" title="" placeholder="" class="w100p"   id='NEW_DEPT' name='NEW_DEPT'  />
    </td>
</tr>
<tr>
    <th scope="row">Mobile No <span class="must">*</span></th>
    <td>
    <input type="text" title="" placeholder="" class="w100p"   id='NEW_TELM1' name='NEW_TELM1'  />
    </td>
    <th scope="row">Residence No <span class="must">*</span></th>
    <td>
    <input type="text" title="" placeholder="" class="w100p"   id='NEW_TELMR' name='NEW_TELR'/>
    </td>
    <th scope="row">Office No <span class="must">*</span></th>
    <td>
    <input type="text" title="" placeholder="" class="w100p"  id='NEW_TELMO' name='NEW_TELO'/>
    </td>
    <th scope="row">Fax No <span class="must">*</span></th>
    <td>
    <input type="text" title="" placeholder="" class="w100p"   id='NEW_TELMF' name='NEW_TELF' />
    </td>
</tr>
    <th scope="row">Email</th>
    <td colspan="7">
    <input type="text" title="" placeholder="" class="w100p"  id='NEW_EMAIL' name='NEW_EMAIL'/>
    </td>
</tr>
<tr>
    <td colspan="8" class="col_all">
    <label><input type="checkbox"  id='NEW_MAIN_SET'   name='NEW_MAIN_SET'  /><span>Set As Main Contact Person</span></label>
    <p class="fl_right"><span class="red_text">(* At least one contact number)</span></p>
    </td>
</tr>
</tbody>
</table><!-- table end -->

<ul class="center_btns">
    <li><p class="btn_blue big"><a href="#"  onclick="javascript:fn_doSaveAjax() ">Save</a></p></li>
</ul>


</section><!-- pop_body end -->

</div><!-- popup_wrap end -->

</form>
</body>