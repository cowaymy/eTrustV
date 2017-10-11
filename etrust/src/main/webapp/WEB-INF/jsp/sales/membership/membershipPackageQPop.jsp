<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript" language="javascript">


var packageInfo={};

$(document).ready(function(){
    fn_selectCodel();
    
});




//PackID=" + packID + "&PackItemID=" + packItemID;
//리스트 조회.
function fn_selectListAjax() {       
	
	var packItemID = '${packItemID}';
	var packID = '${packID}';
	
	Common.ajax("GET", "/sales/mQPackages/selectPopUpList", {SRV_MEM_PAC_ID:packID  ,STK_ID: packItemID}, function(result) {
	  
		
	     console.log(result);
	      
	      
	      if (result[0] != null) {
	    	  
	    	  packageInfo = result[0];
              
	    	  $('#packcode option[value="' + packageInfo.stkId +'"]').prop('selected', true);
	    	
	    	  $("#srvPacItmRental").val(packageInfo.c1);  
	    	  $("#srvPacItmSvcFreq").val(packageInfo.srvMemItmPriod);  
	    	  $("#remark").val(packageInfo.srvMemItmRem);
	    	  
	    	  
	        }
	});
}





function fn_IsExistSVMContractPackCode() {       
   //this.txtCode.Text.Trim(), excludePackID)
	Common.ajaxSync("GET", "/sales/mPackages/isExistSVMPackCode", {SRV_PAC_ITM_ID: '${packID}'  }, function(result) {
    
		console.log(result);
		
		if(result !=""  && null !=result ){
			
			return true;
		}else{
			return false;
		}
		
		
    });
}



function fn_save(){
	
	
	if( ! fn_ValidRequiredField_Master()) return ;
	
	var  STKID = '${packItemID}';
	var  PACID = '${packID}';
	var  modType  = '${modType}';

	var saveForm ={
			 mod :modType,
             SRV_MEM_PAC_ID         : PACID,  
    	     SRV_MEM_ITM_PRIOD     : $("#srvPacItmSvcFreq").val(),
    	     SRV_MEM_ITM_PRC        : $("#srvPacItmRental").val(),
    	     SRV_MEM_ITM_PV          : 0,
    	     SRV_MEM_ITM_REM        : $("#remark").val().trim(),
    	     SRV_MEM_ITM_STUS_ID  : 1
    };

	
    Common.ajax("POST", "/sales/mQPackages/insertPackage.do", saveForm, function(result) {
        
           Common.alert("Product Item Saved "+DEFAULT_DELIMITER + "<b>Product item successfully saved.</b>");
           fn_DisableField();

       }, function(jqXHR, textStatus, errorThrown) {
           Common.alert("실패하였습니다.");
           console.log("실패하였습니다.");
           console.log("error : " + jqXHR + " \n " + textStatus + "\n" + errorThrown);
           
           Common.alert("Failed To Save "+DEFAULT_DELIMITER + "<b>Failed to save.Please try again later.</b>");

           console.log("jqXHR.responseJSON.message" + jqXHR.responseJSON.message);
           
       }); 
	
}




function fn_ValidRequiredField_Master(){
	
	var valid =true;
	var message ="";
	
	
	if($('select[name="packcode"]').val()  ==""){
	
		  valid = false;
	      message += "* Please key select a product item. <br />";
	}
	
	if($("#srvPacItmRental").val() ==""){
		 valid = false;
	        message += "* Please key in the monthly rental fee. <br />";
	}  
	
    if($("#srvPacItmSvcFreq").val() ==""){
    	  valid = false;
          message += "* Please key in the service frequency <br />";
    }  
    
    
    if (!valid)
        Common.alert("Add Package  "+DEFAULT_DELIMITER + message);

    
    return valid;
}


//리스트 조회.
function fn_selectCodel() {        
Common.ajax("GET", "/sales/mPackages/selectCodel", $("#sForm").serialize(), function(result) {
      console.log(result);
      
      
      if(null !=result ){
    	
    	  var  gList = Array();
    	  
    	  var  cList =Array();
    	  
    	  if (typeof(result.groupCodeList) != 'undefined' && result.groupCodeList !== null) {
              for (var k in result.groupCodeList) {
            	  gList[k] = result.groupCodeList[k].codeName;
              }
          }
    	    
   	     $.each(gList, function(index, value){
   	         $("#packcode").append('<optgroup label="'+value+'"  id="optgroup_'+index+'" >');
   		     
	   		      for(var k in result.codeList ){
	   		    	  if( typeof(result.codeList[k]) != 'undefined' && result.codeList[k].groupcd !== null  ){
	   		    		  
	   		    		  if(result.codeList[k].groupcd  == value ){
	   		    		    // console.log(result.codeList[k]);
	   		    	         $('<option />', {
	   		    	              value : result.codeList[k].codeid ,
	   		    	              text: result.codeList[k].codename 
	   		    	         }).appendTo($("#optgroup_"+index)); 

	                       }
	   		    	  }
	   		      }
	   		      
   		      $("#packcode").append('</optgroup>');
   	    });
   	     
   	    $("optgroup").attr("class" , "optgroup_text");
   	    
   	     fn_selectListAjax();
      }
   });
   
  
}




function fn_DisableField(){
	
    $("#packcode").attr("disabled" ,"disabled");
    $("#srvPacItmRental").attr("disabled" ,"disabled");
    $("#srvPacItmSvcFreq").attr("disabled" ,"disabled");
    $("#remark").attr("disabled" ,"disabled");
    $("#savebt").attr("style" ,"display:none");
}


</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->

 <c:if test="${modType eq 'EDIT' }">
<h1>EDIT  PRODUCT ITEM </h1>     </c:if>
      <c:if test="${modType eq 'ADD' }">
<h1>ADD  PRODUCT ITEM </h1>     </c:if>
     
     

<ul class="right_opt">
	<li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<section class="tap_wrap"><!-- tap_wrap start -->
<ul class="tap_type1">
	
	<li><a href="#">Product Infomation</a></li>
</ul>

<article class="tap_area"><!-- tap_area start -->

<section class="search_table"><!-- search_table start -->
<form action="#" method="post">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:190px" />
	<col style="width:*" />
	<col style="width:180px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row">Product Item<span class="must">*</span></th>
	<td> 
	
	 <c:if test="${modType eq 'EDIT' }">
	   <select class="w100p disabled"   disabled ="disabled"  id='packcode' name='packcode'    > </select>
	 </c:if>
	  <c:if test="${modType eq 'ADD' }">
        <select class="w100p " id='packcode' name='packcode' > </select>
     </c:if>
    <td>
	<th scope="row">Service Frequency <span class="must">*</span></th>
	<td><input type="text" title="" placeholder="Service Frequency" class="w100p" id="srvPacItmRental"  name="srvPacItmRental"/></td>
</tr>
<tr>
	<th scope="row">Item Price <span class="must">*</span></th>
	<td colspan="3"><input type="text" title="" placeholder="Item Price" class=""  id="srvPacItmSvcFreq"  name="srvPacItmSvcFreq" /></td>
</tr>
<tr>
    <th scope="row">Remark </th>
    <td colspan="3"> <textarea cols="20" rows="5" id='remark'  name='remark' placeholder="Remark" name='remark'></textarea></td>
</tr>
</tbody>
</table><!-- table end -->

</form>
</section><!-- search_table end -->

<ul class="center_btns">
	<li><p class="btn_blue2 big"><a href="#" id='savebt'   onclick="javascript:fn_save()">Save</a></p></li>
</ul>

</article><!-- tap_area end -->


</section><!-- tap_wrap end -->

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->